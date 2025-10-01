(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*pooledContainerToSampleOptions*)


DefineTests[pooledContainerToSampleOptions,
	{
		Example[{Basic,"Extracts the contents from any containers to return a list of samples:"},
			Experiment`Private`pooledContainerToSampleOptions[
				ExperimentSolidPhaseExtraction,
				testSamples,
				{
					(* Match to sample, should stay the same since it matches singleton pattern. *)
					LoadingSampleDispenseRate->5 Milliliter/Minute,

					(*matched to sample, should expaned to {True,True,{True,True,True},False,{True,False}}*)
					QuantitativeLoadingSample->{True,True,True,False,{True,False}},

					(*matched to sample, should expaned to {{.5mL},{.5mL, .4mL},{.75mL,.75mL,.75mL},.85mL,{.5mL,.5mL}}*)
					QuantitativeLoadingSampleVolume->{.5 Milliliter,{.5 Milliliter,.4 Milliliter},.75 Milliliter,.85 Milliliter,{.5 Milliliter,.5 Milliliter}},

					(*index matched to pool, should stay the same since it matches singleton pattern. *)
					WashingSolutionVolume->2 Milliliter,

					(*index matched to pool, should resolved to {1mL, 2mL, 1mL, 1mL, 1mL, 1.5mL 2mL}, since the plate has 3 samples*)
					ElutingSolutionVolume->{1 Milliliter, 2 Milliliter,1 Milliliter,1.5 Milliliter,2 Milliliter}
				}
			],
			{
				_List,
				{
					LoadingSampleDispenseRate -> Quantity[5, ("Milliliters")/("Minutes")],
					QuantitativeLoadingSample -> {True, True, {True}, {True}, {True},False, {True, False}},
					QuantitativeLoadingSampleVolume -> {Quantity[0.5,"Milliliters"], {Quantity[0.5, "Milliliters"],Quantity[0.4, "Milliliters"]}, {Quantity[0.75,"Milliliters"]}, {Quantity[0.75, "Milliliters"]}, {Quantity[0.5,"Milliliters"]},Quantity[0.85, "Milliliters"], {Quantity[0.5, "Milliliters"],Quantity[0.5, "Milliliters"]}},
					WashingSolutionVolume -> Quantity[2, "Milliliters"],
					ElutingSolutionVolume -> {Quantity[1, "Milliliters"], Quantity[2, "Milliliters"], Quantity[1, "Milliliters"], Quantity[1, "Milliliters"], Quantity[1, "Milliliters"], Quantity[1.5, "Milliliters"], Quantity[2, "Milliliters"]}}
			}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		(* Define some helper functions *)
		makeWater[volume_,conc_]:=Module[{container,id},
			container=Upload[Association[
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9Njjbv"],Objects],
				DeveloperObject->True,
				Status->Available
			]];
			id=ECL`InternalUpload`UploadSample[Model[Sample, "id:n0k9mGzRaaYn"],{"A1",container},InitialAmount-> volume,Status->Available];
			Upload[Association[Object->id,DeveloperObject->True,Concentration->conc]]
		];
		makeWater[volume_]:=makeWater[volume,Null];

		makeWaterInPlate[volume_, conc_, x_] :=Module[{container, id, wells, samps, dests},
			container =Upload[
				Association[
					Type -> Object[Container, Plate],
					Model ->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					DeveloperObject -> True, Status -> Available
				]
			];
			wells = ConvertWell[Range[1, x]];
			samps = Table[Model[Sample, "id:n0k9mGzRaaYn"], x];
			dests = Map[{#, container} &, wells];
			id = ECL`InternalUpload`UploadSample[samps, dests,InitialAmount -> volume, Status -> Available];
			Upload[Map[Association[Object -> #, DeveloperObject -> True,Concentration->conc]]&, id];
			id
		];

		makeWaterInPlate[volume_, x_] := makeWaterInPlate[volume,Null,x];

		testSamples={
			makeWater[2 Milliliter, 10 Micromolar],
			{makeWater[2 Milliliter, 12 Micromolar],makeWater[2 Milliliter, 14 Micromolar]},
			Download[First[makeWaterInPlate[2 Milliliter,  10 Micromolar,3]],Container[Object]],
			{Download[First[makeWaterInPlate[2 Milliliter,  10 Micromolar,3]],Container[Object]]},
			Download[{makeWater[2 Milliliter],makeWater[2 Milliliter, 9 Micromolar]}, Container[Object]]
		};
	)
];


(* ::Subsection::Closed:: *)
(*containerToSampleOptions *)


DefineTests[containerToSampleOptions,
	{
		Example[{Basic,"Extracts the contents from any containers to return a list of samples:"},
			containerToSampleOptions[ExperimentIncubate,{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},{Time -> 30 Second}],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"]},
				{Time -> 30 Second}
			}
		],

		Example[{Basic,"Expands options index matched to containers to be indexed matched to the samples within those containers:"},
			containerToSampleOptions[ExperimentIncubate,{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},{Time -> {30 Second, 40 Second}}],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"]},
				{Time -> {30 Second,40 Second,40 Second,40 Second}}
			}
		],

		Example[{Additional,"Options provided as single values are left unchanged:"},
			containerToSampleOptions[ExperimentCentrifuge,{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},{Intensity -> 1000 RPM,Time -> {30 Second, 40 Second}}],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"]},
				{Intensity -> 1000 RPM,Time -> {30 Second,40 Second,40 Second,40 Second}}
			}
		],

		Example[{Additional,"Accepts a mix of container, sample and item inputs:"},
			containerToSampleOptions[ShipToUser,{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],Object[Item,Column,"Test Column Sample for containerToSampleOptions"]},{ShippingSpeed -> NextDay}],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"],Object[Item,Column,"Test Column Sample for containerToSampleOptions"]},
				{ShippingSpeed -> NextDay},
				{}
			},
			SetUp:>(
				$CreatedObjects={};
				If[!DatabaseMemberQ[Model[Item,Column,"Test Model Column for containerToSampleOptions"]],
					Upload[<|DeveloperObject->True, Expires -> False, Name -> "Test Model Column for containerToSampleOptions", Type -> Model[Item,Column],Replace[Dimensions]->{Quantity[0.2032, "Meters"], Quantity[0.2032, "Meters"], Quantity[0.0762, "Meters"]}|>]
				];
				If[!DatabaseMemberQ[Object[Item,Column,"Test Column Sample for containerToSampleOptions"]],
					Upload[<|DeveloperObject->True, Type -> Object[Item,Column], Model->Link[Model[Item,Column,"Test Model Column for containerToSampleOptions"],Objects], Name -> "Test Column Sample for containerToSampleOptions"|>]
				];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		Example[{Additional,"Expands options index matched to containers to be index matched to samples when a mix of container, sample and item are given as  inputs:"},
			containerToSampleOptions[ShipToUser,{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],Object[Item,Column,"Test Column Sample for containerToSampleOptions"]},{ShippingSpeed -> {NextDay,ThreeDay,NextDay}}],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"],Object[Item,Column,"Test Column Sample for containerToSampleOptions"]},
				{ShippingSpeed -> {NextDay,ThreeDay,ThreeDay,ThreeDay,NextDay}},
				{}
			},
			SetUp:>(
				$CreatedObjects={};
				If[!DatabaseMemberQ[Model[Item,Column,"Test Model Column for containerToSampleOptions"]],
					Upload[<|DeveloperObject->True, Expires -> False, Name -> "Test Model Column for containerToSampleOptions", Type -> Model[Item,Column],Replace[Dimensions]->{Quantity[0.2032, "Meters"], Quantity[0.2032, "Meters"], Quantity[0.0762, "Meters"]}|>]
				];
				If[!DatabaseMemberQ[Object[Item,Column,"Test Column Sample for containerToSampleOptions"]],
					Upload[<|DeveloperObject->True, Type -> Object[Item,Column], Model->Link[Model[Item,Column,"Test Model Column for containerToSampleOptions"],Objects], Name -> "Test Column Sample for containerToSampleOptions"|>]
				];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Expands options index matched to containers to be index matched to samples when a mix of container, sample and item are given as  inputs:"},
			containerToSampleOptions[
				ExperimentMix,
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					{"A2", Object[Container, Plate,	"resolveExperimentOptions 3-Sample Plate"]},
					{"A1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]}
				},
				{
					MixType -> {Invert, Pipette, Pipette}
				}
			],
			{
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					Object[Sample, "id:wqW9BP7RrpPV"],
					Object[Sample, "id:L8kPEjnwq7JW"]
				},
				{MixType -> {Invert, Pipette, Pipette}}
			}
		],
		Example[{Additional,"Can specify only one single {Position,Container} as the input. "},
			containerToSampleOptions[
				ExperimentIncubate,
				{"A1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
				{Time -> 1 Minute}
			],
			{
				{Object[Sample, "id:L8kPEjnwq7JW"]},
				{Time -> Quantity[1, "Minutes"]}
			}
		],
		Example[{Options,Cache,"A cache can be supplied to avoid contacting the server:"},
			containerToSampleOptions[ExperimentCentrifuge,Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],{Intensity -> 1000 RPM,Time -> 30 Second},
				Cache->{
					<|
						Object->Object[Container,Plate,"id:lYq9jRxmlbNY"],
						ID -> "id:lYq9jRxmlbNY",
						Type -> Object[Container, Plate],
						Contents->{{"A1",Link[Object[Sample,"id:L8kPEjnwq7JW"],Container,"N80DNjvARBl6"]},{"A2",Link[Object[Sample,"id:wqW9BP7RrpPV"],Container,"zGj91akqJPwE"]},{"A3",Link[Object[Sample,"id:n0k9mG8xErAw"],Container,"xRO9n3Eb5PxZ"]}}
					|>
				}
			],
			{
				{Object[Sample, "id:L8kPEjnwq7JW"],Object[Sample, "id:wqW9BP7RrpPV"],Object[Sample, "id:n0k9mG8xErAw"]},
				{Intensity -> 1000 RPM,Time -> 30 Second}
			}
		],
		Example[{Options,Simulation,"Pass the simulation packet to the function: "},
			containerToSampleOptions[
				ExperimentCentrifuge,
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					{"A3", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					{"A1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]}
				},
				{
					Time -> {3 Minute, 4 Minute, 5 Minute},
					Intensity -> {2000 RPM, 4000 RPM, 3000 RPM}
				},
				Simulation->Simulation[
					<|
						MinVolume -> 2 Milliliter,
						StorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"], "jLq9jXGR5ZWZ"],
						Object -> Object[Container, Plate, "id:lYq9jRxmlbNY"],
						ID -> "id:lYq9jRxmlbNY",
						Type -> Object[Container, Plate]
					|>
				]
			],
			{
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					Object[Sample, "id:n0k9mG8xErAw"],
					Object[Sample, "id:L8kPEjnwq7JW"]
				},
				{
					Time -> {3 Minute, 4 Minute, 5 Minute},
					Intensity -> {2000 RPM, 4000 RPM, 3000 RPM}
				}
			}
		],
		Example[{Additional,"Recognizes that the option does not need to be expanded even though it is a list:"},
			containerToSampleOptions[
				ExperimentHPLC,
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
				{GradientA->{{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}}
			],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"]},
				{GradientA->{{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}}
			}
		],

		Example[{Additional,"If an option value does not match the length of the input it will be returned unchanged:"},
			containerToSampleOptions[ExperimentCentrifuge,{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},{Time -> {30 Second, 40 Second, 50 Second}}],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"]},
				{Time -> {30 Second, 40 Second, 50 Second}}
			}
		],

		Example[{Options,EmptyContainers,"If the experiment supports empty containers, set EmptyContainers->True to indicate the empty containers should be left unchanged and no messages should be printed:"},
			containerToSampleOptions[ExperimentMeasureWeight,{Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Vessel, "resolveExperimentOptions empty container"]}, {Aliquot->{True,True,False}},EmptyContainers->True],
			{
				{Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"],Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Vessel, "resolveExperimentOptions empty container"]},
				{Aliquot->{True,True,True,True,False}}
			}
		],

		Example[{Messages,"EmptyContainer","If one of the inputs is an empty container and EmptyContainers->False, the function will return $Failed:"},
			containerToSampleOptions[ExperimentCentrifuge,{Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Vessel, "resolveExperimentOptions empty container"]}, {Time -> 30 Second,Temperature->{20 Celsius,30 Celsius,40 Celsius}}],
			$Failed,
			Messages:>{Error::EmptyContainers}
		],
		Example[{Messages,"EmptyWells","If the input was specified as {Position, Container} but the position in that container is empty, the funciton will still return a fake sample and pass the information of this sample to the simulation packet."},
			containerToSampleOptions[
				ExperimentCentrifuge,
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					{"A2", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					{"B1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]}
				},
				{
					Time -> {3 Minute, 4 Minute, 5 Minute},
					Intensity -> {2000 RPM, 4000 RPM, 3000 RPM}
				},
				Output-> {Result,Simulation}
			],
			{
				{
					{
						Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
						Object[Sample, "id:wqW9BP7RrpPV"],
						ObjectP[Object[Sample]]
					},
					{
						Time -> {3 Minute, 4 Minute, 5 Minute},
						Intensity -> {2000 RPM, 4000 RPM, 3000 RPM}
					}
				},
				SimulationP
			},
			Messages:>{Error::ContainerEmptyWells}
		],
		Example[{Messages,"EmptyWells","If the input was specified as {Position, Container} but the position is empty on tht plate, the function will still return a fake sample and pass the information of this sample as the cache if the sample doest not has Simulation option: "},
			containerToSampleOptions[ExperimentMassSpectrometry,
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					{"A2", Object[Container, Plate,	"resolveExperimentOptions 3-Sample Plate"]},
					{"D1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]}
				},
				{
					InfusionFlowRate -> {10 Microliter / Minute,10 Microliter / Minute,10 Microliter / Minute},
					SampleVolume -> {2 Microliter, 1.5 Microliter, 1 Microliter}
				}
			],
			{
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					Object[Sample, "id:wqW9BP7RrpPV"],
					ObjectP[Object[Sample]]
				},
				{
					InfusionFlowRate -> {10 Microliter / Minute,10 Microliter / Minute,10 Microliter / Minute},
					SampleVolume -> {2 Microliter, 1.5 Microliter, 1 Microliter}
				}
			},
			Messages:>{Error::ContainerEmptyWells}
		],
		Example[{Messages,"WellNotOnThePlate","If the input was specified as {Position, Container} but the position is not allowed for the container, the funciton will still return a fake sample and pass the information of this sample to the simulation packet."},
			containerToSampleOptions[ExperimentCentrifuge,
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					{"A2", Object[Container, Plate,	"resolveExperimentOptions 3-Sample Plate"]},
					{"Z1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]}
				},
				{
					Time -> {3 Minute, 4 Minute, 5 Minute},
					Intensity -> {2000 RPM, 4000 RPM, 3000 RPM}
				},
				Output-> {Result,Simulation}
			],
			{
				{
					{
						Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
						Object[Sample, "id:wqW9BP7RrpPV"],
						ObjectP[Object[Sample]]
					},
					{
						Time -> {
							Quantity[3, "Minutes"],
							Quantity[4, "Minutes"],
							Quantity[5, "Minutes"]
						},
						Intensity -> {
							Quantity[2000, ("Revolutions")/("Minutes")],
							Quantity[4000, ("Revolutions")/("Minutes")],
							Quantity[3000, ("Revolutions")/("Minutes")]
						}
					}
				},
				SimulationP
			},
			Messages:>{Error::WellDoesNotExist}
		],
		Example[{Messages,"WellNotOnThePlate","If the input was specified as {Position, Container} but the position is not allowed for the container, the function will still return a fake sample and pass the information of this sample as the cache if the sample doest not has Simulation option:"},
			containerToSampleOptions[ExperimentMassSpectrometry,
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					{"A2", Object[Container, Plate,	"resolveExperimentOptions 3-Sample Plate"]},
					{"Z1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]}
				},
				{
					InfusionFlowRate -> {10 Microliter / Minute,10 Microliter / Minute,10 Microliter / Minute},
					SampleVolume -> {2 Microliter, 1.5 Microliter, 1 Microliter}
				}
			],
			{
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					Object[Sample, "id:wqW9BP7RrpPV"],
					ObjectP[Object[Sample]]
				},
				{
					InfusionFlowRate -> {Quantity[10, ("Microliters")/("Minutes")], Quantity[10, ("Microliters")/("Minutes")], Quantity[10, ("Microliters")/("Minutes")]},
					SampleVolume -> {Quantity[2, "Microliters"],Quantity[1.5, "Microliters"], Quantity[1, "Microliters"]}
				}
			},
			Messages:>{Error::WellDoesNotExist}
		],
		Example[{Messages,"WellNotOnThePlate","Experiment funcitons with container to sample options will catch WellNotOnThePlate error (Test No. 1):."},
			ExperimentCapillaryELISA[{"Z1",Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]}],
			$Failed,
			Messages:>{Error::WellDoesNotExist}
		],
		Test["Handles the case where only empty containers are specified:",
			containerToSampleOptions[ExperimentCentrifuge,{Object[Container, Vessel, "resolveExperimentOptions empty container"]},{Time -> 30 Second, Temperature->{30 Celsius}}],
			$Failed,
			Messages:>{Error::EmptyContainers}
		],
		Test["Handle the case where a variety of error has caused: ",
			containerToSampleOptions[ExperimentIncubate,
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					{"A2",Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					{"B8", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					{"Z1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]
				},
				{MixType -> {Invert, Pipette, Pipette}}
			],
			{
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					ObjectP[Object[Sample, "resolveExperimentOptions Oligomer 2"]],
					ObjectP[Object[Sample]],
					ObjectP[Object[Sample]],
					ObjectP[Object[Sample, "resolveExperimentOptions Oligomer 1"]],
					ObjectP[Object[Sample, "resolveExperimentOptions Oligomer 2"]],
					ObjectP[Object[Sample, "resolveExperimentOptions Oligomer 3"]]
				},
				{MixType -> {Invert, Pipette, Pipette}}
			},
			Messages:>{Error::ContainerEmptyWells,Error::WellDoesNotExist,Warning::DuplicateContainersSpecified}
		],
		Test["Handle the case where a variety of error has caused, and return a simulated cache since the experiment function do not have simulation: ",
			containerToSampleOptions[ExperimentMassSpectrometry,
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					{"A2",Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					{"B8", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					{"Z1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]
				},
				{InjectionType -> FlowInjection, InfusionFlowRate -> {10 Microliter / Minute,10 Microliter / Minute,10 Microliter / Minute,10 Microliter / Minute,10 Microliter / Minute}}
			],
			{
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					ObjectP[Object[Sample, "resolveExperimentOptions Oligomer 2"]],
					ObjectP[Object[Sample]],
					ObjectP[Object[Sample]],
					ObjectP[Object[Sample, "resolveExperimentOptions Oligomer 1"]],
					ObjectP[Object[Sample, "resolveExperimentOptions Oligomer 2"]],
					ObjectP[Object[Sample, "resolveExperimentOptions Oligomer 3"]]
				},
				{
					InjectionType -> FlowInjection,
					InfusionFlowRate -> {
						Quantity[10, ("Microliters")/("Minutes")],
						Quantity[10, ("Microliters")/("Minutes")],
						Quantity[10, ("Microliters")/("Minutes")],
						Quantity[10, ("Microliters")/("Minutes")],
						Quantity[10, ("Microliters")/("Minutes")],
						Quantity[10, ("Microliters")/("Minutes")],
						Quantity[10, ("Microliters")/("Minutes")]
					}
				}
			},
			Messages:>{Error::ContainerEmptyWells,Error::WellDoesNotExist,Warning::DuplicateContainersSpecified}
		],
		Test["Handles the case when a container model is provided through PreparatoryUnitOperations:",
			containerToSampleOptions[ExperimentCentrifuge,{Model[Container,Vessel,"2mL Tube"]},{Time -> 30 Second, Temperature->{30 Celsius}}],
			{$Failed,$Failed},
			Messages:>{Error::EmptyContainers}
		],
		Test["Returns tests only where only empty containers are returned:",
			containerToSampleOptions[ExperimentCentrifuge,{Object[Container, Vessel, "resolveExperimentOptions empty container"]},{Time -> 30 Second, Temperature->{30 Celsius}}, Output->Tests],
			{_EmeraldTest..}
		],
		Test["Returns results and tests only where only empty containers are returned:",
			containerToSampleOptions[ExperimentCentrifuge,{Object[Container, Vessel, "resolveExperimentOptions empty container"]},{Time -> 30 Second, Temperature->{30 Celsius}}, Output->{Result,Tests}],
			{
				{
					{Object[Container, Vessel,"resolveExperimentOptions empty container"]},
					{Time ->Quantity[30, "Seconds"],Temperature -> {Quantity[30, "DegreesCelsius"]}}
				},
				{_EmeraldTest..}
			}
		],

		Example[{Messages,"SampleAndContainerSpecified","Prints a warning if a sample and its container were specified:"},
			containerToSampleOptions[ExperimentCentrifuge,{Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],Object[Sample, "resolveExperimentOptions Oligomer 1"]},{Temperature->{30 Celsius,40 Celsius},Time -> 30 Second}],
			{
				{Object[Sample, "id:L8kPEjnwq7JW"],Object[Sample, "id:wqW9BP7RrpPV"],Object[Sample, "id:n0k9mG8xErAw"],Object[Sample, "resolveExperimentOptions Oligomer 1"]},
				{Temperature->{30 Celsius,30 Celsius,30 Celsius,40 Celsius},Time -> 30 Second}
			},
			Messages:>{Message[Warning::SampleAndContainerSpecified,{Object[Sample, "resolveExperimentOptions Oligomer 1"]}]}
		],
		Example[{Messages,"DuplicateContainersSpecified","Prints a warning if a container and specific positions in the same container were specified:"},
			containerToSampleOptions[
				ExperimentCentrifuge,
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					{"A2", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					{"A1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]
				},
				{
					Time -> {3 Minute, 4 Minute, 5 Minute, 6 Minute},
					Intensity -> {2000 RPM, 4000 RPM, 3000 RPM, 5000 RPM}}
			],
			{
				{
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
					Object[Sample, "id:wqW9BP7RrpPV"],
					Object[Sample, "id:L8kPEjnwq7JW"],
					Object[Sample, "id:L8kPEjnwq7JW"],
					Object[Sample, "id:wqW9BP7RrpPV"],
					Object[Sample, "id:n0k9mG8xErAw"]
				},
				{
					Time -> {3 Minute, 4 Minute, 5 Minute, 6 Minute, 6 Minute, 6 Minute},
					Intensity -> {2000 RPM, 4000 RPM, 3000 RPM, 5000 RPM, 5000 RPM, 5000 RPM}
				}
			},
			Messages:>{Warning::DuplicateContainersSpecified}
		],
		Test["Prints a warning if a sample object and its container were specified:",
			containerToSampleOptions[ExperimentCentrifuge,{Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],Object[Sample, "id:L8kPEjnwq7JW"]},{Temperature->{30 Celsius,40 Celsius},Time -> 30 Second}],
			{
				{Object[Sample, "id:L8kPEjnwq7JW"],Object[Sample, "id:wqW9BP7RrpPV"],Object[Sample, "id:n0k9mG8xErAw"],Object[Sample, "id:L8kPEjnwq7JW"]},
				{Temperature->{30 Celsius,30 Celsius,30 Celsius,40 Celsius},Time -> 30 Second}
			},
			Messages:>{Message[Warning::SampleAndContainerSpecified,{Object[Sample, "id:L8kPEjnwq7JW"]}]}
		],

		Test["Prints a warning if a sample object and its container were specified:",
			containerToSampleOptions[ExperimentCentrifuge,{Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],Object[Sample, "id:L8kPEjnwq7JW"]},{Temperature->{30 Celsius,40 Celsius},Time -> 30 Second},Output->{Result,Tests}],
			{{
				{Object[Sample, "id:L8kPEjnwq7JW"],Object[Sample, "id:wqW9BP7RrpPV"],Object[Sample, "id:n0k9mG8xErAw"],Object[Sample, "id:L8kPEjnwq7JW"]},
				{Temperature->{30 Celsius,30 Celsius,30 Celsius,40 Celsius},Time -> 30 Second}
			},{_EmeraldTest..}
			}
		],

		Test["Prints a warning if a sample object and its container were specified:",
			containerToSampleOptions[ExperimentCentrifuge,{Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],Object[Sample, "id:L8kPEjnwq7JW"]},{Temperature->{30 Celsius,40 Celsius},Time -> 30 Second},Output->Tests],
			{_EmeraldTest..}
		],

		Test["Handles the case where only samples are provided:",
			containerToSampleOptions[ExperimentCentrifuge,{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},{Time -> 30 Second}],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"]},
				{Time -> 30 Second}
			}
		],

		Test["Handles the case where no options are provided:",
			containerToSampleOptions[ExperimentCentrifuge,{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},{}],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"]},
				{}
			}
		],

		Test["Handles the case where unexpected experiment options are provided:",
			containerToSampleOptions[
				ExperimentMassSpectrometry,
				{Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
				{
					MassRange ->Quantity[1400, ("Grams")/("Moles")] ;; Quantity[12000, ("Grams")/("Moles")],
					Matrix -> Model[Sample, Matrix, "id:o1k9jAKOwwvG"],
					ImageSample -> False
				},
				Output -> Result,
				Cache -> {}
			],
			$Failed,
			Messages:>{Error::UnknownOption}
		],

		Test["Does not attempt to expand options index-matched to other options:",
			containerToSampleOptions[
				ExperimentHPLC,
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
				{BlankInjectionVolume->{10 Microliter,10 Microliter}}
			],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"]},
				{BlankInjectionVolume->{10 Microliter,10 Microliter}}
			}
		],

		Test["Expands options marked as index-matched to the inputs using the new widget-based option definitions:",
			containerToSampleOptions[
				ECL`AppHelpers`ExperimentTacoPreparation,
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
				{ECL`AppHelpers`Greenery->{ECL`AppHelpers`Lettuce,ECL`AppHelpers`Guac}}
			],
			{
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"]},
				{ECL`AppHelpers`Greenery->{ECL`AppHelpers`Lettuce,ECL`AppHelpers`Guac,ECL`AppHelpers`Guac,ECL`AppHelpers`Guac}},
				{}
			}
		],

		Test["Model[Sample] input is treated identically to Object[Sample] input:",
			containerToSampleOptions[
				ExperimentWestern,
				{Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{BlockingBuffer->Model[Sample, "Milli-Q water"],PrimaryAntibodyDiluentVolume->{5 Microliter,10 Microliter,15 Microliter}}
			],
			{
				{Object[Sample, "id:L8kPEjnwq7JW"], Object[Sample,"id:wqW9BP7RrpPV"], Object[Sample, "id:n0k9mG8xErAw"],Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{BlockingBuffer->Model[Sample, "Milli-Q water"],PrimaryAntibodyDiluentVolume->{5 Microliter,5 Microliter,5 Microliter,10 Microliter,15 Microliter}}
			}
		]
	}
];


(* ::Subsection::Closed:: *)
(*splitPrepOptions *)


DefineTests[splitPrepOptions,
	{
		Example[{Basic,"Divides the input options a list of prep options and list of experiment-specific options:"},
			splitPrepOptions[
				{
					MixTime->5 Minute,
					Blank->Model[Sample,"Milli-Q water"],
					BlankInjectionVolume->{10 Microliter,15 Microliter,20 Microliter},
					BlankColumnTemperature->45 Celsius
				}
			],
			{
				{MixTime->5 Minute},
				{OrderlessPatternSequence[
					Blank->Model[Sample,"Milli-Q water"],
					BlankInjectionVolume->{10 Microliter,15 Microliter,20 Microliter},
					BlankColumnTemperature->45 Celsius
				]}
			}
		],
		Example[{Basic,"Returns an empty list of prep options if no prep options are provided:"},
			splitPrepOptions[
				{
					Blank->Model[Sample,"Milli-Q water"],
					BlankInjectionVolume->{10 Microliter,15 Microliter,20 Microliter},
					BlankColumnTemperature->45 Celsius
				}
			],
			{
				{},
				{OrderlessPatternSequence[
					Blank->Model[Sample,"Milli-Q water"],
					BlankInjectionVolume->{10 Microliter,15 Microliter,20 Microliter},
					BlankColumnTemperature->45 Celsius
				]}
			}
		],
		Example[{Basic,"Returns an empty list of experiment options if all provided options are prep options:"},
			splitPrepOptions[
				{
					MixTime->5 Minute,
					IncubationTemperature->22 Celsius,
					AliquotCentrifugeTime->10 Minute
				}
			],
			{
				{OrderlessPatternSequence[
					IncubationTemperature->22 Celsius,
					MixTime->5 Minute,
					AliquotCentrifugeTime->10 Minute
				]},
				{}
			}
		],
		Example[{Options,PrepOptionSets,"Indicate that all prep option sets should be included in the prep option list:"},
			splitPrepOptions[
				{
					NumberOfMixes->5,
					MixVolume->1 Milliliter,
					CentrifugeTime->5 Minute,
					IncubationTemperature->37 Celsius,
					Blank->Model[Sample,"Milli-Q water"],
					BlankInjectionVolume->{10 Microliter,15 Microliter,20 Microliter},
					BlankColumnTemperature->45 Celsius
				},
				PrepOptionSets->All
			],
			{
				{OrderlessPatternSequence[NumberOfMixes->5,MixVolume->1 Milliliter,CentrifugeTime->5 Minute,IncubationTemperature->37 Celsius]},
				{OrderlessPatternSequence[
					Blank->Model[Sample,"Milli-Q water"],
					BlankInjectionVolume->{10 Microliter,15 Microliter,20 Microliter},
					BlankColumnTemperature->45 Celsius
				]}
			}
		],
		Example[{Options,PrepOptionSets,"Indicate the prep option sets that should be included in the prep option list:"},
			splitPrepOptions[
				{
					NumberOfMixes->5,
					MixVolume->1 Milliliter,
					CentrifugeTime->5 Minute,
					IncubationTemperature->37 Celsius
				},
				PrepOptionSets->{MixPrepOptions,IncubatePrepOptions}
			],
			{
				{OrderlessPatternSequence[NumberOfMixes->5,MixVolume->1 Milliliter,IncubationTemperature->37 Celsius]},
				{CentrifugeTime->5 Minute}
			}
		],
		Example[{Options,PrepOptionSets,"Indicate that only a particular prep option set should be included in the prep options list:"},
			splitPrepOptions[
				{
					NumberOfMixes->5,
					MixVolume->1 Milliliter,
					CentrifugeTime->5 Minute
				},
				PrepOptionSets->MixPrepOptions
			],
			{
				{OrderlessPatternSequence[NumberOfMixes->5,MixVolume->1 Milliliter]},
				{CentrifugeTime->5 Minute}
			}
		],
		Example[{Issues, "Assumes options have already been validated; no further validation is performed. Any options which are not known to be prep options will be included in the experiment-specific options list:"},
			splitPrepOptions[
				{
					CentrifugeTime->5 Minute,
					Random->"Taco"
				}
			],
			{
				{CentrifugeTime->5 Minute},
				{Random->"Taco"}
			}
		]
	}
];



(* ::Subsection::Closed:: *)
(*resolvePooledAliquotOptions*)


DefineTests[resolvePooledAliquotOptions,
	{
		Example[{Basic,"Works on pooled samples:"},
			resolvePooledAliquotOptions[
				ExperimentDifferentialScanningCalorimetry,
				{waterSample1,{waterSample2}},
				{waterSample1,{waterSample2}},
				{
					Incubate->{False,{False}},
					IncubationTemperature->{Null,{Null}},
					IncubationTime->{Null,{Null}},
					Mix->{Null,{Null}},
					MixType->{Null,{Null}},
					MixUntilDissolved->{Null,{Null}},
					MaxIncubationTime->{Null,{Null}},
					IncubationInstrument->{Null,{Null}},
					AnnealingTime->{Null,{Null}},
					IncubateAliquotContainer->{Null,{Null}},
					IncubateAliquot->{Null,{Null}},
					Centrifuge->{False,{False}},
					CentrifugeInstrument->{Null,{Null}},
					CentrifugeIntensity->{Null,{Null}},
					CentrifugeTime->{Null,{Null}},
					CentrifugeTemperature->{Null,{Null}},
					CentrifugeAliquotContainer->{Null,{Null}},
					CentrifugeAliquot->{Null,{Null}},
					Filtration->{False,{False}},
					FiltrationType->{Null,{Null}},
					FilterInstrument->{Null,{Null}},
					Filter->{Null,{Null}},
					FilterMaterial->{Null,{Null}},
					PrefilterMaterial->{Null,{Null}},
					FilterPoreSize->{Null,{Null}},
					PrefilterPoreSize->{Null,{Null}},
					FilterSyringe->{Null,{Null}},
					FilterHousing->{Null,{Null}},
					FilterIntensity->{Null,{Null}},
					FilterTime->{Null,{Null}},
					FilterTemperature->{Null,{Null}},
					FilterContainerOut->{Null,{Null}},
					FilterAliquotContainer->{Null,{Null}},
					FilterAliquot->{Null,{Null}},
					FilterSterile->{Null,{Null}},
					Aliquot->{Automatic,{Automatic}},
					AliquotAmount->{Automatic,{Automatic}},
					AliquotSampleLabel->{Automatic,{Automatic}},
					TargetConcentration->{Automatic,{Automatic}},
					TargetConcentrationAnalyte->{Automatic,{Automatic}},
					AssayVolume->{Automatic,{Automatic}},
					AliquotContainer->{Automatic,{Automatic}},
					ConcentratedBuffer->{Automatic,{Automatic}},
					DestinationWell->{Automatic,{Automatic}},
					BufferDilutionFactor->{Automatic,{Automatic}},
					BufferDiluent->{Automatic,{Automatic}},
					AssayBuffer->{Automatic,{Automatic}},
					AliquotSampleStorageCondition->{Automatic,{Automatic}},
					ConsolidateAliquots->Automatic,
					AliquotPreparation->Automatic
				},
				Cache->Download[{waterSample1,waterSample2}]
			],
			{_Rule..}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4}=Upload[{
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:zGj91aR3ddXJ"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:zGj91aR3ddXJ"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],DeveloperObject->True|>
		}];

		(* Create some water samples *)
		{waterSample1,waterSample2,waterSample3,waterSample4}=ECL`InternalUpload`UploadSample[
			{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
			{{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer4},{"A2",emptyContainer4}},
			InitialAmount->{50 Milliliter,50 Milliliter,1 Milliliter,1 Milliliter}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample1,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>,
			<|Object->waterSample3,DeveloperObject->True|>,
			<|Object->waterSample4,DeveloperObject->True|>,
			<|Object->emptyContainer1,DeveloperObject->True|>,
			<|Object->emptyContainer2,DeveloperObject->True|>,
			<|Object->emptyContainer3,DeveloperObject->True|>,
			<|Object->emptyContainer4,DeveloperObject->True|>
		}]
	),
	SymbolTearDown:>(
		EraseObject[$CreatedObjects, Force->True]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*resolveAliquotOptions*)


DefineTests[resolveAliquotOptions,
	{
		Example[{Basic, "Given a list of input samples and expanded options, returns resolved aliquot options:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic},
					TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Given a list of input samples and expanded options with Aliquot -> True for some and False for other samples, returns resolved aliquot options:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, True},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "When specifying some resolved options, return resolved aliquot options:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {True, False},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {300*Microliter, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {400*Microliter, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Model[Sample, "Milli-Q water"], Automatic},
					BufferDilutionFactor -> {10, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> True,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Given a list of input samples, expanded options, and target aliquot containers, returns resolved aliquot options:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->{Model[Container,Vessel,"id:bq9LA0dBGGR6"],Model[Container,Vessel,"id:bq9LA0dBGGR6"]},
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Basic, "Also works with pooled inputs, calculates buffer concentration amounts taking the pooling into consideration:"},
			resolveAliquotOptions[
				ExperimentUVMelting,
				{{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"]},
				{{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"]},
				{Incubate->{{False,False},False},IncubationTemperature->{{Null,Null},Null},IncubationTime->{{Null,Null},Null},Mix->{{Null,Null},Null},MixType->{{Null,Null},Null},MixUntilDissolved->{{Null,Null},Null},MaxIncubationTime->{{Null,Null},Null},IncubationInstrument->{{Null,Null},Null},AnnealingTime->{{Null,Null},Null},IncubateAliquotContainer->{{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},IncubateAliquot->{{20Microliter,20Microliter},20Microliter},Centrifuge->{{False,False},False},CentrifugeInstrument->{{Null,Null},Null},CentrifugeIntensity->{{Null,Null},Null},CentrifugeTime->{{Null,Null},Null},CentrifugeTemperature->{{Null,Null},Null},CentrifugeAliquotContainer->{{Null,Null},Null},CentrifugeAliquot->{{Null,Null},Null},Filtration->{{False,False},False},FiltrationType->{{Null,Null},Null},FilterInstrument->{{Null,Null},Null},Filter->{{Null,Null},Null},FilterMaterial->{{Null,Null},Null},PrefilterMaterial->{{Null,Null},Null},FilterPoreSize->{{Null,Null},Null},PrefilterPoreSize->{{Null,Null},Null},FilterSyringe->{{Null,Null},Null},FilterHousing->{{Null,Null},Null},FilterIntensity->{{Null,Null},Null},FilterTime->{{Null,Null},Null},FilterTemperature->{{Null,Null},Null},FilterContainerOut->{{Null,Null},Null},FilterAliquotContainer->{{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},FilterAliquot->{{15Microliter,15Microliter},17Microliter},FilterSterile->{{Null,Null},Null},Aliquot->{True,True},					AliquotSampleLabel -> {Automatic, Automatic}, AliquotAmount->{{11Microliter,12Microliter},10Microliter},TargetConcentration->{{Automatic,Automatic},Automatic},TargetConcentrationAnalyte->{{Automatic,Automatic},Automatic},AssayVolume->{Automatic,Automatic},AliquotContainer->{Automatic,Automatic},DestinationWell->{Automatic,Automatic},ConcentratedBuffer->{Automatic,Automatic},BufferDilutionFactor->{Automatic,Automatic},BufferDiluent->{Automatic,Automatic},AssayBuffer->{Automatic,Automatic},AliquotSampleStorageCondition->{Automatic,Automatic},ConsolidateAliquots->Automatic,AliquotPreparation->Automatic},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "Works with pooled inputs when non-pooled and pooled options are given (from the experiment function):"},
			resolveAliquotOptions[
				ExperimentUVMelting,
				{{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}},
				{{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}},
				{Instrument->Automatic,MaxTemperature->Quantity[95,"DegreesCelsius"],MinTemperature->Quantity[5,"DegreesCelsius"],NumberOfCycles->1,EquilibrationTime->Quantity[5,"Minutes"],TemperatureRampOrder->{Heating,Cooling},TemperatureResolution->Quantity[5,"DegreesCelsius"],Wavelength->Automatic,MinWavelength->Automatic,MaxWavelength->Automatic,TemperatureMonitor->ImmersionProbe,BlankMeasurement->False,NestedIndexMatchingMix->{Automatic,Automatic},NestedIndexMatchingMixType->{Automatic,Automatic},NestedIndexMatchingNumberOfMixes->{Automatic,Automatic},NestedIndexMatchingMixVolume->{Automatic,Automatic},NestedIndexMatchingIncubate->{Automatic,Automatic},PooledIncubationTime->{Automatic,Automatic},NestedIndexMatchingIncubationTemperature->{Automatic,Automatic},NestedIndexMatchingAnnealingTime->{Automatic,Automatic},ContainerOut->{Automatic,Automatic},Cache->{},FastTrack->False,Template->Null,ParentProtocol->Null,Operator->Null,Confirm->False,Name->Null,Upload->True,Output->Preview,Email->Automatic,Incubate->{{False,False},{False,False}},IncubationTemperature->{{Null,Null},{Null,Null}},IncubationTime->{{Null,Null},{Null,Null}},Mix->{{Null,Null},{Null,Null}},MixType->{{Null,Null},{Null,Null}},MixUntilDissolved->{{Null,Null},{Null,Null}},MaxIncubationTime->{{Null,Null},{Null,Null}},IncubationInstrument->{{Null,Null},{Null,Null}},AnnealingTime->{{Null,Null},{Null,Null}},IncubateAliquotContainer->{{Null,Null},{Null,Null}},IncubateAliquotDestinationWell->{{Null,Null},{Null,Null}},IncubateAliquot->{{Null,Null},{Null,Null}},Centrifuge->{{False,False},{False,False}},CentrifugeInstrument->{{Null,Null},{Null,Null}},CentrifugeIntensity->{{Null,Null},{Null,Null}},CentrifugeTime->{{Null,Null},{Null,Null}},CentrifugeTemperature->{{Null,Null},{Null,Null}},CentrifugeAliquotDestinationWell->{{Null,Null},{Null,Null}},CentrifugeAliquotContainer->{{Null,Null},{Null,Null}},CentrifugeAliquot->{{Null,Null},{Null,Null}},Filtration->{{False,False},{False,False}},FiltrationType->{{Null,Null},{Null,Null}},FilterInstrument->{{Null,Null},{Null,Null}},Filter->{{Null,Null},{Null,Null}},FilterMaterial->{{Null,Null},{Null,Null}},PrefilterMaterial->{{Null,Null},{Null,Null}},FilterPoreSize->{{Null,Null},{Null,Null}},PrefilterPoreSize->{{Null,Null},{Null,Null}},FilterSyringe->{{Null,Null},{Null,Null}},FilterHousing->{{Null,Null},{Null,Null}},FilterIntensity->{{Null,Null},{Null,Null}},FilterTime->{{Null,Null},{Null,Null}},FilterTemperature->{{Null,Null},{Null,Null}},FilterContainerOut->{{Null,Null},{Null,Null}},FilterAliquotDestinationWell->{{Null,Null},{Null,Null}},FilterAliquotContainer->{{Null,Null},{Null,Null}},FilterAliquot->{{Null,Null},{Null,Null}},FilterSterile->{{Null,Null},{Null,Null}},Aliquot->{Automatic,Automatic},					AliquotSampleLabel -> {Automatic, Automatic}, AliquotAmount->{{Automatic,Automatic},{Automatic,Automatic}},TargetConcentration->{{Automatic,Automatic},{Automatic,Automatic}}, TargetConcentrationAnalyte->{{Automatic,Automatic},{Automatic,Automatic}},AssayVolume->{Automatic,Automatic},ConcentratedBuffer->{Automatic,Automatic},BufferDilutionFactor->{Automatic,Automatic},BufferDiluent->{Automatic,Automatic},AssayBuffer->{Automatic,Automatic},AliquotSampleStorageCondition->{Automatic,Automatic},DestinationWell->{Automatic,Automatic},AliquotContainer->{Automatic,Automatic},AliquotPreparation->Automatic,ConsolidateAliquots->Automatic,MeasureWeight->True,MeasureVolume->True,ImageSample->Automatic,SubprotocolDescription->Null,SamplesInStorageCondition->{Null,Null},SamplesOutStorageCondition->{Null,Null},NumberOfReplicates->Null},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "If given a TargetAliquotContainer that is the same as the current container of the sample (with no other aliquot options set), it does not aliquot the sample:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->{Model[Container, Vessel, "2mL Tube"],Model[Container, Vessel, "2mL Tube"]},
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{(Verbatim[Rule][_,ListableP[Null|False]])..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "When specified with NumberOfReplicates, collapses all the output options to match the pre-NumberOfReplicates expansion EXCEPT AliquotContainer:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"], Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"], Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {True, False},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {300*Microliter, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {400*Microliter, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Model[Sample, "Milli-Q water"], Automatic},
					BufferDilutionFactor -> {10, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> True,
					AliquotPreparation -> Automatic,
					NumberOfReplicates -> 2
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{OrderlessPatternSequence[
				Aliquot -> {True, False},
				AliquotSampleLabel -> _List,
				AliquotAmount -> _?(Length[#] == 2 &),
				TargetConcentration -> _?(Length[#] == 2 &),
				TargetConcentrationAnalyte -> _?(Length[#] == 2 &),
				AssayVolume -> _?(Length[#] == 2 &),
				AliquotContainer -> {
					{_Integer, ObjectP[Model[Container]]},
					{_Integer, ObjectP[Model[Container]]},
					Null,
					Null
				},
				DestinationWell -> {
					_String,
					_String,
					Null,
					Null
				},
				ConcentratedBuffer -> _?(Length[#] == 2 &),
				BufferDilutionFactor -> _?(Length[#] == 2 &),
				BufferDiluent -> _?(Length[#] == 2 &),
				AssayBuffer -> _?(Length[#] == 2 &),
				AliquotSampleStorageCondition -> _?(Length[#] == 2 &),
				ConsolidateAliquots -> True,
				AliquotPreparation -> _
			]},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "Another test of pooled inputs/options:"},
			resolveAliquotOptions[
				ExperimentUVMelting,
				{{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"]},{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}},
				{{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"]},{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}},
				{Instrument->Automatic,MaxTemperature->95 Celsius,MinTemperature->5 Celsius,NumberOfCycles->1,EquilibrationTime->5 Minute,TemperatureRampOrder->{Heating,Cooling},TemperatureResolution->5 Celsius,Wavelength->Automatic,MinWavelength->Automatic,MaxWavelength->Automatic,TemperatureMonitor->ImmersionProbe,BlankMeasurement->False,NestedIndexMatchingMix->{Automatic,Automatic},NestedIndexMatchingMixType->{Pipette,Pipette},NestedIndexMatchingNumberOfMixes->{Automatic,Automatic},NestedIndexMatchingMixVolume->{Automatic,Automatic},NestedIndexMatchingIncubate->{Automatic,Automatic},PooledIncubationTime->{Automatic,Automatic},NestedIndexMatchingIncubationTemperature->{Automatic,Automatic},NestedIndexMatchingAnnealingTime->{Automatic,Automatic},Cache->{},FastTrack->False,Template->Null,ParentProtocol->Null,Operator->Null,Confirm->False,Name->Null,Upload->False,Output->Result,Email->Automatic,Incubate->{{False},{False,False}},IncubationTemperature->{{Null},{Null,Null}},IncubationTime->{{Null},{Null,Null}},Mix->{{Null},{Null,Null}},MixType->{{Null},{Null,Null}},MixUntilDissolved->{{Null},{Null,Null}},MaxIncubationTime->{{Null},{Null,Null}},IncubationInstrument->{{Null},{Null,Null}},AnnealingTime->{{Null},{Null,Null}},IncubateAliquotContainer->{{Null},{Null,Null}},IncubateAliquotDestinationWell->{{Null},{Null,Null}},IncubateAliquot->{{Null},{Null,Null}},Centrifuge->{{False},{False,False}},CentrifugeInstrument->{{Null},{Null,Null}},CentrifugeIntensity->{{Null},{Null,Null}},CentrifugeTime->{{Null},{Null,Null}},CentrifugeTemperature->{{Null},{Null,Null}},CentrifugeAliquotDestinationWell->{{Null},{Null,Null}},CentrifugeAliquotContainer->{{Null},{Null,Null}},CentrifugeAliquot->{{Null},{Null,Null}},Filtration->{{False},{False,False}},FiltrationType->{{Null},{Null,Null}},FilterInstrument->{{Null},{Null,Null}},Filter->{{Null},{Null,Null}},FilterMaterial->{{Null},{Null,Null}},PrefilterMaterial->{{Null},{Null,Null}},FilterPoreSize->{{Null},{Null,Null}},PrefilterPoreSize->{{Null},{Null,Null}},FilterSyringe->{{Null},{Null,Null}},FilterHousing->{{Null},{Null,Null}},FilterIntensity->{{Null},{Null,Null}},FilterTime->{{Null},{Null,Null}},FilterTemperature->{{Null},{Null,Null}},FilterContainerOut->{{Null},{Null,Null}},FilterAliquotDestinationWell->{{Null},{Null,Null}},FilterAliquotContainer->{{Null},{Null,Null}},FilterAliquot->{{Null},{Null,Null}},FilterSterile->{{Null},{Null,Null}},Aliquot->{Automatic,Automatic},					AliquotSampleLabel -> {Automatic, Automatic}, AliquotAmount->{{Automatic},{Automatic,Automatic}},TargetConcentration->{{Automatic},{Automatic,Automatic}},TargetConcentrationAnalyte->{{Automatic},{Automatic, Automatic}}, AssayVolume->{Automatic,Automatic},ConcentratedBuffer->{Automatic,Automatic},BufferDilutionFactor->{Automatic,Automatic},BufferDiluent->{Automatic,Automatic},AssayBuffer->{Automatic,Automatic},AliquotSampleStorageCondition->{Automatic,Automatic},DestinationWell->{Automatic,Automatic},AliquotContainer->{Automatic,Automatic},AliquotPreparation->Automatic,ConsolidateAliquots->Automatic,ImageSample->Automatic,SubprotocolDescription->Null,SamplesInStorageCondition->{Null,Null},NumberOfReplicates->Null},
				RequiredAliquotContainers->{Null,Null},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "If we are aliquotting because RequiredAliquotContainer is not the current container and the AliquotAmount/TargetConcentration/AssayVolume options are not set, then set AliquotAmount to RequiredAliquotAmount:"},
			Lookup[resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->{1.16 Milliliter, 0.87 Milliliter},
				(* The given samples are in 2mL tubes. *)
				RequiredAliquotContainers->{Model[Container, Vessel, "50mL Tube"],Model[Container, Vessel, "50mL Tube"]},
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],{AliquotAmount,TargetConcentration,TargetConcentrationAnalyte,AssayVolume}],
			{
				{EqualP[Quantity[1.16, "Milliliters"]], EqualP[Quantity[870., "Microliters"]]},
				{Null, Null},
				{Null, Null},
				{EqualP[Quantity[1.16, "Milliliters"]], EqualP[Quantity[870., "Microliters"]]}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Messages:>{
				Warning::AliquotRequired
			}
		],
		Example[{Additional, "Do not throw a message if the user set the aliquot options and we need to aliquot because of a target container:"},
			Lookup[resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {True, True},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->{1.16 Milliliter, 0.87 Milliliter},
				(* The given samples are in 2mL tubes. *)
				RequiredAliquotContainers->{Model[Container, Vessel, "50mL Tube"],Model[Container, Vessel, "50mL Tube"]},
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],{AliquotAmount,TargetConcentration,TargetConcentrationAnalyte,AssayVolume}],
			{
				{EqualP[Quantity[1.16, "Milliliters"]], EqualP[Quantity[870., "Microliters"]]},
				{Null, Null},
				{Null, Null},
				{EqualP[Quantity[1.16, "Milliliters"]], EqualP[Quantity[870., "Microliters"]]}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional, "If TargetConcentration is the only option set for a sample (whether or not we are aliquoting because of a container change or not), set the RequiredAliquotAmount as the AssayVolume. We are guaranteed that this will be a liquid (since TargetConcentration is set) and we do not want to exceed the volume of the given RequiredAliquotContainer:"},
			Lookup[resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)"]},
				{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {2.5 Millimolar, 1.7 Millimolar},
					TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->{1.8 Milliliter, 2.1 Milliliter},
				(* The given samples are in 2mL tubes. *)
				RequiredAliquotContainers->{Model[Container, Vessel, "2mL Tube"],Model[Container, Vessel, "50mL Tube"]},
				Cache->Download[{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)"]}]
			],{AliquotAmount,TargetConcentration, TargetConcentrationAnalyte, AssayVolume}],
			{
				{EqualP[Quantity[900., "Microliters"]], EqualP[Quantity[1.19, "Milliliters"]]},
				{EqualP[Quantity[2.5, "Millimolar"]], EqualP[Quantity[1.7, "Millimolar"]]},
				{ObjectP[Model[Molecule]], ObjectP[Model[Molecule]]},
				{EqualP[Quantity[1.8, "Milliliters"]], EqualP[Quantity[2.1, "Milliliters"]]}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "AliquotSampleLabelConflict", "An error is thrown if AliquotSampleLabel is set to Null but Aliquot is set to True:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {True, Automatic},
					AliquotSampleLabel -> {Null, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->{Model[Container,Vessel,"id:bq9LA0dBGGR6"],Model[Container,Vessel,"id:bq9LA0dBGGR6"]},
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			Messages:>{
				Warning::AliquotRequired,
				Error::AliquotSampleLabelConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "MissingRequiredAliquotAmounts", "If logged in as a developer and the RequiredAliquotAmount option was not given, an error message is thrown. This option must always be specified:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			Messages:>{
				Error::MissingRequiredAliquotAmounts
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "SolidSamplesNotAllowed", "If given samples that will still be solid after the aliquot stage, throws an error:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]},
				{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->{Model[Container,Vessel,"id:bq9LA0dBGGR6"],Model[Container,Vessel,"id:bq9LA0dBGGR6"]},
				Cache->Download[{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]}]
			],
			{_Rule..},
			Messages:>{
				Error::SolidSamplesUnsupported,
				Error::InvalidInput
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "SolidSamplesNotAllowed", "If solid samples will be diluted with solvent after the aliquot stage, does not throw a message:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]},
				{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {10Milliliter,15Milliliter},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->{Model[Container,Vessel,"id:bq9LA0dBGGR6"],Model[Container,Vessel,"id:bq9LA0dBGGR6"]},
				Cache->Download[{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]}]
			],
			{_Rule..},
			Messages:>{
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "SolidSamplesNotAllowed", "Does not throw a message, even if there will be solid samples after aliquot, if AllowSolids->True:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]},
				{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->{Model[Container,Vessel,"id:bq9LA0dBGGR6"],Model[Container,Vessel,"id:bq9LA0dBGGR6"]},
				Cache->Download[{Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]}],
				AllowSolids->True
			],
			{_Rule..},
			Messages:>{
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "AliquotContainers", "If given RequiredAliquotContainers when AliquotContainers is already specified by the user, an error is thrown:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Model[Container,Vessel,"id:3em6Zv9NjjN8"], Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->{Model[Container,Vessel,"id:bq9LA0dBGGR6"],Model[Container,Vessel,"id:bq9LA0dBGGR6"]},
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			Messages:>{
				Warning::AliquotRequired,
				Error::AliquotContainers,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "AliquotOptionConflict", "If Aliquot -> False but some of the index matching options are specified, throw an error:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, False},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {300*Microliter, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {400*Microliter, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Model[Sample, "Milli-Q water"], Automatic},
					BufferDilutionFactor -> {1, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> True,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			Messages :> {Error::AliquotOptionConflict, Error::InvalidOption},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "AliquotOptionConflict", "If Aliquot -> False but some of the non-index matching options are specified, don't throw an error:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, False},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> True,
					AliquotPreparation -> Robotic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages, "AliquotOptionMismatch", "If given RequiredAliquotContainers when AliquotContainers is already specified by the user, an error is thrown:"},
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic},
					TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Null, Automatic},
					DestinationWell -> {Automatic, Null},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				RequiredAliquotContainers->{Model[Container,Vessel,"id:bq9LA0dBGGR6"],Model[Container,Vessel,"id:bq9LA0dBGGR6"]},
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			],
			{_Rule..},
			Messages:>{
				Error::AliquotOptionMismatch,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, AliquotSampleStorageCondition, "AliquotSampleStorageCondition always resolves to Null if not specified because cannot be Automatic in resolveAliquotOptions:"},
			Lookup[resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, True},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			], AliquotSampleStorageCondition],
			{Null, Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, ConsolidateAliquots, "ConsolidateAliquots always resolves to False if not specified because cannot be Automatic in resolveAliquotOptions:"},
			Lookup[resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, True},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			], ConsolidateAliquots],
			False,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, ConcentratedBuffer, "ConcentratedBuffer always resolves to Null if not specified because cannot be Automatic in resolveAliquotOptions:"},
			Lookup[resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, True},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}]
			], ConcentratedBuffer],
			{Null, Null},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["When given samples that are to be pooled together and the RequiredAliquotAmounts option, resolveAliquotOptions always sets the RequiredAliquotAmounts option to the AssayVolume option (not the AliquotAmount option) if the AssayVolume/AliquotAmount options are not already set:",
			resolveAliquotOptions[
				ExperimentDifferentialScanningCalorimetry,
				{{Object[Sample,"PNA sample 1 in 2mL tube for ExperimentDSC"],Object[Sample,"DNA sample 1 in 2mL tube for ExperimentDSC"]},{Object[Sample,"DNA sample 1 in 2mL tube for ExperimentDSC"]}},
				{{Object[Sample,"PNA sample 1 in 2mL tube for ExperimentDSC"],Object[Sample,"DNA sample 1 in 2mL tube for ExperimentDSC"]},{Object[Sample,"DNA sample 1 in 2mL tube for ExperimentDSC"]}},
				{NestedIndexMatchingMix->Automatic,PooledMixRate->Automatic,NestedIndexMatchingMixTime->Automatic,NestedIndexMatchingCentrifuge->Automatic,NestedIndexMatchingCentrifugeForce->Automatic,NestedIndexMatchingCentrifugeTime->Automatic,NestedIndexMatchingIncubate->Automatic,PooledIncubationTime->Automatic,NestedIndexMatchingIncubationTemperature->Automatic,NestedIndexMatchingAnnealingTime->Automatic,InjectionVolume->Quantity[300,"Microliters"],InjectionRate->Quantity[100,("Microliters")/("Seconds")],CleaningFrequency->None,Blanks->{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},StartTemperature->{Quantity[4,"DegreesCelsius"],Quantity[4,"DegreesCelsius"]},EndTemperature->{Quantity[95,"DegreesCelsius"],Quantity[95,"DegreesCelsius"]},TemperatureRampRate->{Quantity[60,("DegreesCelsius")/("Hours")],Quantity[60,("DegreesCelsius")/("Hours")]},NumberOfScans->{1,1},RescanCoolingRate->{Automatic,Automatic},Cache->{},FastTrack->False,Template->Null,ParentProtocol->Null,Operator->Null,Confirm->False,Name->Null,Upload->True,Output->Result,Email->Automatic,PreparatoryUnitOperations->Null,Incubate->{{False,False},{False}},IncubationTemperature->{{Null,Null},{Null}},IncubationTime->{{Null,Null},{Null}},Mix->{{Null,Null},{Null}},MixType->{{Null,Null},{Null}},MixUntilDissolved->{{Null,Null},{Null}},MaxIncubationTime->{{Null,Null},{Null}},IncubationInstrument->{{Null,Null},{Null}},AnnealingTime->{{Null,Null},{Null}},IncubateAliquotContainer->{{Null,Null},{Null}},IncubateAliquotDestinationWell->{{Null,Null},{Null}},IncubateAliquot->{{Null,Null},{Null}},Centrifuge->{{False,False},{False}},CentrifugeInstrument->{{Null,Null},{Null}},CentrifugeIntensity->{{Null,Null},{Null}},CentrifugeTime->{{Null,Null},{Null}},CentrifugeTemperature->{{Null,Null},{Null}},CentrifugeAliquotDestinationWell->{{Null,Null},{Null}},CentrifugeAliquotContainer->{{Null,Null},{Null}},CentrifugeAliquot->{{Null,Null},{Null}},Filtration->{{False,False},{False}},FiltrationType->{{Null,Null},{Null}},FilterInstrument->{{Null,Null},{Null}},Filter->{{Null,Null},{Null}},FilterMaterial->{{Null,Null},{Null}},PrefilterMaterial->{{Null,Null},{Null}},FilterPoreSize->{{Null,Null},{Null}},PrefilterPoreSize->{{Null,Null},{Null}},FilterSyringe->{{Null,Null},{Null}},FilterHousing->{{Null,Null},{Null}},FilterIntensity->{{Null,Null},{Null}},FilterTime->{{Null,Null},{Null}},FilterTemperature->{{Null,Null},{Null}},FilterContainerOut->{{Null,Null},{Null}},FilterAliquotDestinationWell->{{Null,Null},{Null}},FilterAliquotContainer->{{Null,Null},{Null}},FilterAliquot->{{Null,Null},{Null}},FilterSterile->{{Null,Null},{Null}},Aliquot->{Automatic,Automatic},AliquotSampleLabel -> {Automatic, Automatic},AliquotAmount->{{Automatic,Automatic},{Automatic}},TargetConcentration->{{Automatic,Automatic},{Automatic}}, TargetConcentrationAnalyte->{{Automatic,Automatic},{Automatic}},AssayVolume->{Automatic,Automatic},ConcentratedBuffer->{Automatic,Automatic},BufferDilutionFactor->{Automatic,Automatic},BufferDiluent->{Automatic,Automatic},AssayBuffer->{Automatic,Automatic},AliquotSampleStorageCondition->{Automatic,Automatic},DestinationWell->{"A2","A4"},AliquotContainer->{Automatic,Automatic},AliquotPreparation->Automatic,ConsolidateAliquots->Automatic,MeasureWeight->True,MeasureVolume->True,ImageSample->Automatic,SubprotocolDescription->Null,SamplesInStorageCondition->{Null,Null},NumberOfReplicates->Null,Instrument->Model[Instrument,DifferentialScanningCalorimeter,"MicroCal VP-Capillary"]},
				Cache->dscAliquotTestCache,
				RequiredAliquotContainers->{Model[Container,Plate,"96-well 500uL Round Bottom DSC Plate"],Model[Container,Plate,"96-well 500uL Round Bottom DSC Plate"]},
				RequiredAliquotAmounts->{400 Microliter, 400 Microliter},
				AllowSolids->False
			],
			{_Rule..},
			Messages:>{
				Warning::TotalAliquotVolumeTooLarge
			},
			SetUp:>(
				$CreatedObjects={};

				(* Upload things for this test. *)
				Block[{$AllowSystemsProtocols=True},
					Module[{fakeBench,vessel1,vessel2,vessel3,vessel4,plate1,plate2,sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9,allObjs},
						fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentDifferentialScanningCalorimetry",DeveloperObject->True|>];

						{vessel1,vessel2,vessel3,vessel4,plate1,plate2}=UploadSample[{Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Vessel,"2mL Tube"],Model[Container,Plate,"96-well 2mL Deep Well Plate"],Model[Container,Plate,"96-well 500uL Round Bottom DSC Plate"]},{{"Work Surface",fakeBench},{"Work Surface",fakeBench},{"Work Surface",fakeBench},{"Work Surface",fakeBench},{"Work Surface",fakeBench},{"Work Surface",fakeBench}},FastTrack->True,Name->{"2mL tube 1 for ExperimentDifferentialScanningCalorimetry","2mL tube 2 for ExperimentDifferentialScanningCalorimetry","2mL tube 3 for ExperimentDifferentialScanningCalorimetry","2mL tube 4 for ExperimentDifferentialScanningCalorimetry","Deep well plate 1 for ExperimentDifferentialScanningCalorimetry","DifferentialScanningCalorimetry plate 1 for ExperimentDifferentialScanningCalorimetry"}];

						{sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9}=UploadSample[{Model[Sample,"Test PNA oligomer for DSC 1"],Model[Sample,"Test PNA oligomer for DSC 1"],Model[Sample,"Test DNA oligomer for DSC 1"],Model[Sample,"Test DNA oligomer for DSC 1"],Model[Sample,"Test PNA oligomer for DSC 1"],Model[Sample,"Test DNA oligomer for DSC 1"],Model[Sample,"Test PNA oligomer for DSC 1"],Model[Sample,"Test DNA oligomer for DSC 1"],Model[Sample,"Test PNA oligomer for DSC 2 (Deprecated)"]},{{"A1",vessel1},{"A1",vessel2},{"A1",vessel3},{"A1",vessel4},{"A1",plate1},{"A2",plate1},{"A1",plate2},{"A2",plate2},{"A3",plate2}},Name->{"PNA sample 1 in 2mL tube for ExperimentDSC","DNA sample 1 in 2mL tube for ExperimentDSC","PNA sample 2 in 2mL tube for ExperimentDSC","DNA sample 2 in 2mL tube for ExperimentDSC (Discarded)","PNA sample 3 in deep well plate for ExperimentDSC","DNA sample 3 in deep well plate for ExperimentDSC","PNA sample 4 in DSC plate for ExperimentDSC","DNA sample 4 in DSC plate for ExperimentDSC","PNA sample 5 in DSC plate for ExperimentDSC (Deprecated)"},InitialAmount->200*Microliter];

						allObjs={vessel1,vessel2,vessel3,vessel4,plate1,plate2,sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8,sample9};

						Upload[<|Object->#,DeveloperObject->True|>&/@allObjs];

						UploadSampleStatus[sample4,Discarded,FastTrack->True]
					]
				];

				dscAliquotTestCache=simulatedCache={<|Object->Object[Sample,"id:o1k9jAGqPe34"],Type->Object[Sample],Status->Available,Container->Link[Object[Container,Vessel,"id:XnlV5jK8XYM3"],Contents,2,"dORYzZ9MR5qp"],Count->Null,Volume->Quantity[0.0002`,"Liters"],Concentration->Null,MassConcentration->Null,Model->Link[Model[Sample,"id:GmzlKjPXRRDM"],Objects,"4pO6dM8GO915"],Position->"A1",Name->"PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry error",Mass->Null,Sterile->Null,StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"1ZA60vKqAN9M"],ThawTime->Null,ThawTemperature->Null,ID->"id:o1k9jAGqPe34"|>,<|Model->Link[Model[Container,Vessel,"id:3em6Zv9NjjN8"],Objects,"XnlV5j9ElDN3"],StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"eGakld5MaXlx"],Name->"2mL tube 1 for ExperimentDifferentialScanningCalorimetry error",Contents->{{"A1",Link[Object[Sample,"id:o1k9jAGqPe34"],Container,"54n6evNAnze7"]}},TareWeight->Null,Sterile->Null,Status->Available,Object->Object[Container,Vessel,"id:XnlV5jK8XYM3"],ID->"id:XnlV5jK8XYM3",Type->Object[Container,Vessel]|>,<|Name->"Test PNA oligomer for DifferentialScanningCalorimetry 1",Deprecated->Null,Sterile->Null,LiquidHandlerIncompatible->Null,State->Null,Tablet->Null,SolidUnitWeight->Null,Products->{},Dimensions->Null,IncompatibleMaterials->{},TransportTemperature->Null,ThawTime->Null,ThawTemperature->Null,Object->Model[Sample,"id:GmzlKjPXRRDM"],ID->"id:GmzlKjPXRRDM",Tablet->False,SolidUnitWeight->Null,Type->Model[Sample]|>,<|Object->Object[Sample,"id:zGj91a7P0z1b"],Type->Object[Sample],Status->Available,Container->Link[Object[Container,Vessel,"id:qdkmxzqOa474"],Contents,2,"wqW9BPKMWvBJ"],Count->Null,Volume->Quantity[0.0002`,"Liters"],Concentration->Null,MassConcentration->Null,Model->Link[Model[Sample,"id:GmzlKjPXRRDM"],Objects,"8qZ1VW9lZPVA"],Position->"A1",Name->"DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry error",Mass->Null,Sterile->Null,StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"jLq9jXbMqZjz"],ThawTime->Null,ThawTemperature->Null,ID->"id:zGj91a7P0z1b"|>,<|Model->Link[Model[Container,Vessel,"id:3em6Zv9NjjN8"],Objects,"1ZA60vKqANPq"],StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"Z1lqpMLkldEW"],Name->"2mL tube 2 for ExperimentDifferentialScanningCalorimetry error",Contents->{{"A1",Link[Object[Sample,"id:zGj91a7P0z1b"],Container,"n0k9mGbMk4Ln"]}},TareWeight->Null,Sterile->Null,Status->Available,Object->Object[Container,Vessel,"id:qdkmxzqOa474"],ID->"id:qdkmxzqOa474",Type->Object[Container,Vessel]|>,<|Name->"Test PNA oligomer for DifferentialScanningCalorimetry 1",Deprecated->Null,Sterile->Null,LiquidHandlerIncompatible->Null,State->Null,Tablet->Null,SolidUnitWeight->Null,Products->{},Dimensions->Null,IncompatibleMaterials->{},PolymerType->PNA,TransportTemperature->Null,MolecularWeight->Null,ThawTime->Null,ThawTemperature->Null,Object->Model[Sample,"id:GmzlKjPXRRDM"],ID->"id:GmzlKjPXRRDM",Type->Model[Sample]|>,<|Object->Object[Sample,"id:zGj91a7P0z1b"],Type->Object[Sample],Status->Available,Container->Link[Object[Container,Vessel,"id:qdkmxzqOa474"],Contents,2,"wqW9BPKMWvBJ"],Count->Null,Volume->Quantity[0.0002`,"Liters"],Concentration->Null,MassConcentration->Null,Model->Link[Model[Sample,"id:GmzlKjPXRRDM"],Objects,"8qZ1VW9lZPVA"],Position->"A1",Name->"DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry error",Mass->Null,Sterile->Null,StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"jLq9jXbMqZjz"],ThawTime->Null,ThawTemperature->Null,ID->"id:zGj91a7P0z1b"|>,<|Model->Link[Model[Container,Vessel,"id:3em6Zv9NjjN8"],Objects,"1ZA60vKqANPq"],StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"Z1lqpMLkldEW"],Name->"2mL tube 2 for ExperimentDifferentialScanningCalorimetry error",Contents->{{"A1",Link[Object[Sample,"id:zGj91a7P0z1b"],Container,"n0k9mGbMk4Ln"]}},TareWeight->Null,Sterile->Null,Status->Available,Object->Object[Container,Vessel,"id:qdkmxzqOa474"],ID->"id:qdkmxzqOa474",Type->Object[Container,Vessel]|>,<|Name->"Test PNA oligomer for DifferentialScanningCalorimetry 1",Deprecated->Null,Sterile->Null,LiquidHandlerIncompatible->Null,State->Null,Tablet->Null,SolidUnitWeight->Null,Products->{},Dimensions->Null,IncompatibleMaterials->{},PolymerType->PNA,TransportTemperature->Null,MolecularWeight->Null,ThawTime->Null,ThawTemperature->Null,Object->Model[Sample,"id:GmzlKjPXRRDM"],ID->"id:GmzlKjPXRRDM",Type->Model[Sample]|>,<|Object->Object[Sample,"id:o1k9jAGqPe34"],Type->Object[Sample],Status->Available,Container->Link[Object[Container,Vessel,"id:XnlV5jK8XYM3"],Contents,2,"dORYzZ9MR5qp"],Count->Null,Volume->Quantity[0.0002`,"Liters"],Concentration->Null,MassConcentration->Null,Model->Link[Model[Sample,"id:GmzlKjPXRRDM"],Objects,"4pO6dM8GO915"],Position->"A1",Name->"PNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry error",Mass->Null,Sterile->Null,StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"1ZA60vKqAN9M"],ThawTime->Null,ThawTemperature->Null,ID->"id:o1k9jAGqPe34"|>,<|Model->Link[Model[Container,Vessel,"id:3em6Zv9NjjN8"],Objects,"XnlV5j9ElDN3"],StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"eGakld5MaXlx"],Name->"2mL tube 1 for ExperimentDifferentialScanningCalorimetry error",Contents->{{"A1",Link[Object[Sample,"id:o1k9jAGqPe34"],Container,"54n6evNAnze7"]}},TareWeight->Null,Sterile->Null,Status->Available,Object->Object[Container,Vessel,"id:XnlV5jK8XYM3"],ID->"id:XnlV5jK8XYM3",Type->Object[Container,Vessel]|>,<|Name->"Test PNA oligomer for DifferentialScanningCalorimetry 1",Deprecated->Null,Sterile->Null,LiquidHandlerIncompatible->Null,State->Null,Tablet->Null,SolidUnitWeight->Null,Products->{},Dimensions->Null,IncompatibleMaterials->{},PolymerType->PNA,TransportTemperature->Null,MolecularWeight->Null,ThawTime->Null,ThawTemperature->Null,Object->Model[Sample,"id:GmzlKjPXRRDM"],ID->"id:GmzlKjPXRRDM",Type->Model[Sample]|>,<|Object->Object[Sample,"id:zGj91a7P0z1b"],Type->Object[Sample],Status->Available,Container->Link[Object[Container,Vessel,"id:qdkmxzqOa474"],Contents,2,"wqW9BPKMWvBJ"],Count->Null,Volume->Quantity[0.0002`,"Liters"],Concentration->Null,MassConcentration->Null,Model->Link[Model[Sample,"id:GmzlKjPXRRDM"],Objects,"8qZ1VW9lZPVA"],Position->"A1",Name->"DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry error",Mass->Null,Sterile->Null,StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"jLq9jXbMqZjz"],ThawTime->Null,ThawTemperature->Null,ID->"id:zGj91a7P0z1b"|>,<|Model->Link[Model[Container,Vessel,"id:3em6Zv9NjjN8"],Objects,"1ZA60vKqANPq"],StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"Z1lqpMLkldEW"],Name->"2mL tube 2 for ExperimentDifferentialScanningCalorimetry error",Contents->{{"A1",Link[Object[Sample,"id:zGj91a7P0z1b"],Container,"n0k9mGbMk4Ln"]}},TareWeight->Null,Sterile->Null,Status->Available,Object->Object[Container,Vessel,"id:qdkmxzqOa474"],ID->"id:qdkmxzqOa474",Type->Object[Container,Vessel]|>,<|Name->"Test PNA oligomer for DifferentialScanningCalorimetry 1",Deprecated->Null,Sterile->Null,LiquidHandlerIncompatible->Null,State->Null,Tablet->Null,SolidUnitWeight->Null,Products->{},Dimensions->Null,IncompatibleMaterials->{},PolymerType->PNA,TransportTemperature->Null,MolecularWeight->Null,ThawTime->Null,ThawTemperature->Null,Object->Model[Sample,"id:GmzlKjPXRRDM"],ID->"id:GmzlKjPXRRDM",Type->Model[Sample]|>,<|Object->Object[Sample,"id:zGj91a7P0z1b"],Type->Object[Sample],Status->Available,Container->Link[Object[Container,Vessel,"id:qdkmxzqOa474"],Contents,2,"wqW9BPKMWvBJ"],Count->Null,Volume->Quantity[0.0002`,"Liters"],Concentration->Null,MassConcentration->Null,Model->Link[Model[Sample,"id:GmzlKjPXRRDM"],Objects,"8qZ1VW9lZPVA"],Position->"A1",Name->"DNA sample 1 in 2mL tube for ExperimentDifferentialScanningCalorimetry error",Mass->Null,Sterile->Null,StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"jLq9jXbMqZjz"],ThawTime->Null,ThawTemperature->Null,ID->"id:zGj91a7P0z1b"|>,<|Model->Link[Model[Container,Vessel,"id:3em6Zv9NjjN8"],Objects,"1ZA60vKqANPq"],StorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"],"Z1lqpMLkldEW"],Name->"2mL tube 2 for ExperimentDifferentialScanningCalorimetry error",Contents->{{"A1",Link[Object[Sample,"id:zGj91a7P0z1b"],Container,"n0k9mGbMk4Ln"]}},TareWeight->Null,Sterile->Null,Status->Available,Object->Object[Container,Vessel,"id:qdkmxzqOa474"],ID->"id:qdkmxzqOa474",Type->Object[Container,Vessel]|>,<|Name->"Test PNA oligomer for DifferentialScanningCalorimetry 1",Deprecated->Null,Sterile->Null,LiquidHandlerIncompatible->Null,State->Null,Tablet->Null,SolidUnitWeight->Null,Products->{},Dimensions->Null,IncompatibleMaterials->{},PolymerType->PNA,TransportTemperature->Null,MolecularWeight->Null,ThawTime->Null,ThawTemperature->Null,Object->Model[Sample,"id:GmzlKjPXRRDM"],ID->"id:GmzlKjPXRRDM",Type->Model[Sample]|>};
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["If Output -> Tests, return a list of tests and don't throw messages:",
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, False},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {300*Microliter, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {400*Microliter, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Model[Sample, "Milli-Q water"], Automatic},
					BufferDilutionFactor -> {1, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> True,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}],
				Output -> Tests
			],
			{_EmeraldTest..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Test["The tests return False properly if an error has occurred:",
			tests = resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, False},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {300*Microliter, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {400*Microliter, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Model[Sample, "Milli-Q water"], Automatic},
					BufferDilutionFactor -> {1, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> True,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}],
				Output -> Tests
			];
			RunUnitTest[<|"Tests" -> tests|>, Verbose -> False, OutputFormat -> SingleBoolean],
			False,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {tests}
		],
		Test["The tests return True properly if no error has occurred:",
			tests = resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, True},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}],
				Output -> Tests
			];
			RunUnitTest[<|"Tests" -> tests|>, Verbose -> False, OutputFormat -> SingleBoolean],
			True,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			Variables :> {tests}
		],
		Test["If Output -> {Result, Tests}, return both",
			resolveAliquotOptions[
				ExperimentHPLC,
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]},
				{
					Incubate -> {False, False},
					IncubationTemperature -> {Null, Null},
					IncubationTime -> {Null, Null}, Mix -> {Null, Null},
					MixType -> {Null, Null}, MixUntilDissolved -> {Null, Null},
					MaxIncubationTime -> {Null, Null},
					IncubationInstrument -> {Null, Null}, AnnealingTime -> {Null, Null},
					IncubateAliquotContainer -> {Null, Null},
					IncubateAliquot -> {Null, Null}, Centrifuge -> {False, False},
					CentrifugeInstrument -> {Null, Null},
					CentrifugeIntensity -> {Null, Null}, CentrifugeTime -> {Null, Null},
					CentrifugeTemperature -> {Null, Null},
					CentrifugeAliquotContainer -> {Null, Null},
					CentrifugeAliquot -> {Null, Null}, Filtration -> {False, False},
					FiltrationType -> {Null, Null}, FilterInstrument -> {Null, Null},
					Filter -> {Null, Null}, FilterMaterial -> {Null, Null},
					PrefilterMaterial -> {Null, Null}, FilterPoreSize -> {Null, Null},
					PrefilterPoreSize -> {Null, Null}, FilterSyringe -> {Null, Null},
					FilterHousing -> {Null, Null}, FilterIntensity -> {Null, Null},
					FilterTime -> {Null, Null}, FilterTemperature -> {Null, Null},
					FilterContainerOut -> {Null, Null},
					FilterAliquotContainer -> {Null, Null},
					FilterAliquot -> {Null, Null},
					FilterSterile -> {Null, Null},
					Aliquot -> {False, True},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic}, TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {Automatic, Automatic},
					DestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic
				},
				RequiredAliquotAmounts->Null,
				Cache->Download[{Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],Object[Sample,"resolveAliquotOptions New Test Chemical 1 (1.8 mL)"]}],
				Output -> {Result, Tests}
			],
			{
				{_Rule..},
				{_EmeraldTest..}
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		]
	},
	Stubs:>{
		$EmailEnabled=False
	},
	SymbolSetUp :> {
		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for resolveAliquotOptions tests"],
				Object[Protocol, HPLC, "HPLC parent"],
				Object[Container, Vessel, "Fake container 1 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 2 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 3 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 4 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 5 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 6 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 7 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 8 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 9 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 10 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 11 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 12 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 13 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 14 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 15 for resolveAliquotOptions tests"],
				Object[Container, Plate, "Fake plate 1 for resolveAliquotOptions tests"],
				Object[Container, Plate, "Fake plate 2 for resolveAliquotOptions tests"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (200 uL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.8 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.5 mL, 5 mg / mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.8 mL, 3 mg / mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (25 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (no volume)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (5 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (3 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (Discarded)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		],
		Module[
			{
				fakeBench,
				container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13, container14, container15, plate1, plate2,
				sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15,

				allObjs
			},

			fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for resolveAliquotOptions tests",DeveloperObject->True|>];
			{
				container,
				container2,
				container3,
				container4,
				container5,
				container6,
				container7,
				container8,
				container9,
				container10,
				container11,
				container12,
				container13,
				container14,
				container15,
				plate1,
				plate2
			}=UploadSample[
				{
					Model[Container,Vessel,"2mL Tube"],
					Model[Container,Vessel,"2mL Tube"],
					Model[Container,Vessel,"2mL Tube"],
					Model[Container,Vessel,"2mL Tube"],
					Model[Container,Vessel,"2mL Tube"],
					Model[Container,Vessel,"2mL Tube"],
					Model[Container,Vessel,"2mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				},
				{
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench},
					{"Work Surface",fakeBench}
				},
				Status->{
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available,
					Available
				},
				Name->{
					"Fake container 1 for resolveAliquotOptions tests",
					"Fake container 2 for resolveAliquotOptions tests",
					"Fake container 3 for resolveAliquotOptions tests",
					"Fake container 4 for resolveAliquotOptions tests",
					"Fake container 5 for resolveAliquotOptions tests",
					"Fake container 6 for resolveAliquotOptions tests",
					"Fake container 7 for resolveAliquotOptions tests",
					"Fake container 8 for resolveAliquotOptions tests",
					"Fake container 9 for resolveAliquotOptions tests",
					"Fake container 10 for resolveAliquotOptions tests",
					"Fake container 11 for resolveAliquotOptions tests",
					"Fake container 12 for resolveAliquotOptions tests",
					"Fake container 13 for resolveAliquotOptions tests",
					"Fake container 14 for resolveAliquotOptions tests",
					"Fake container 15 for resolveAliquotOptions tests",
					"Fake plate 1 for resolveAliquotOptions tests",
					"Fake plate 2 for resolveAliquotOptions tests"
				}
			];
			{
				sample,
				sample2,
				sample3,
				sample4,
				sample5,
				sample6,
				sample7,
				sample8,
				sample9,
				sample10,
				sample11,
				sample12,
				sample13,
				sample14,
				sample15
			}=UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Ac-dC-CE Phosphoramidite"],
					Model[Sample,"Ac-dC-CE Phosphoramidite"]
				},
				{
					{"A1",container},
					{"A1",container2},
					{"A1",container3},
					{"A1",container4},
					{"A1",container5},
					{"A1",container6},
					{"A1",container7},
					{"A1",container8},
					{"A1",container9},
					{"A1",container10},
					{"A1",container11},
					{"A1",container12},
					{"A1",container13},
					{"A1",container14},
					{"A1",container15}
				},
				InitialAmount->{
					200*Microliter,
					1.5*Milliliter,
					1.5*Milliliter,
					1.8*Milliliter,
					1.8*Milliliter,
					1.5*Milliliter,
					1.8*Milliliter,
					25*Milliliter,
					10*Milliliter,
					Null,
					5*Milliliter,
					3*Milliliter,
					1*Milliliter,
					10 Gram,
					15 Gram
				},
				Name->{
					"resolveAliquotOptions New Test Chemical 1 (200 uL)",
					"resolveAliquotOptions New Test Chemical 1 (1.5 mL)",
					"resolveAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)",
					"resolveAliquotOptions New Test Chemical 1 (1.8 mL)",
					"resolveAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)",
					"resolveAliquotOptions New Test Chemical 1 (1.5 mL, 5 mg / mL)",
					"resolveAliquotOptions New Test Chemical 1 (1.8 mL, 3 mg / mL)",
					"resolveAliquotOptions New Test Chemical 1 (25 mL)",
					"resolveAliquotOptions New Test Chemical 1 (10 mL)",
					"resolveAliquotOptions New Test Chemical 1 (no volume)",
					"resolveAliquotOptions New Test Chemical 1 (5 mL)",
					"resolveAliquotOptions New Test Chemical 1 (3 mL)",
					"resolveAliquotOptions New Test Chemical 1 (Discarded)",
					"resolveAliquotOptions New Test Chemical 1 (10 g)",
					"resolveAliquotOptions New Test Chemical 1 (15 g)"
				}
			];


			allObjs = {
				container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11, container12, container13,
				sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15
			};

			Upload[Flatten[{
				<|Object->#,DeveloperObject->True|>&/@allObjs,
				<|Object -> sample3, Replace[Composition] -> {{100 VolumePercent,Link[Model[Molecule,"Water"]],Now},{5 Millimolar,Link[Model[Molecule,"Uracil"]],Now}}|>,
				<|Object -> sample5, Replace[Composition] -> {{100 VolumePercent,Link[Model[Molecule,"Water"]],Now},{3 Millimolar,Link[Model[Molecule,"Uracil"]],Now}}|>,
				<|Object -> sample6, Replace[Composition] -> {{100 VolumePercent,Link[Model[Molecule,"Water"]],Now},{3*(Milligram/Milliliter),Link[Model[Molecule,"Uracil"]],Now}}|>,
				<|Object -> sample7, Replace[Composition] -> {{100 VolumePercent,Link[Model[Molecule,"Water"]],Now},{3*(Milligram/Milliliter),Link[Model[Molecule,"Uracil"]],Now}}|>,
				<|Type -> Object[Protocol, HPLC], Name -> "HPLC parent", DeveloperObject -> True|>
			}]];
			UploadSampleStatus[sample13, Discarded, FastTrack -> True]

		]
	},
	SymbolTearDown :> {
		Module[
			{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Fake bench for resolveAliquotOptions tests"],
				Object[Protocol, HPLC, "HPLC parent"],
				Object[Container, Vessel, "Fake container 1 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 2 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 3 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 4 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 5 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 6 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 7 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 8 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 9 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 10 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 11 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 12 for resolveAliquotOptions tests"],
				Object[Container, Vessel, "Fake container 13 for resolveAliquotOptions tests"],
				Object[Container, Plate, "Fake plate 1 for resolveAliquotOptions tests"],
				Object[Container, Plate, "Fake plate 2 for resolveAliquotOptions tests"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (200 uL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.5 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.5 mL, 5 mM)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.8 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.8 mL, 3 mM)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.5 mL, 5 mg / mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (1.8 mL, 3 mg / mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (25 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (no volume)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (5 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (3 mL)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (Discarded)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (10 g)"],
				Object[Sample, "resolveAliquotOptions New Test Chemical 1 (15 g)"]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	}
];

(* ::Subsection::Closed:: *)
(*populateSamplePrepFieldsPooled*)
DefineTests[populateSamplePrepFieldsPooled,
	{
		Example[{Basic,"If input samples are pooled, Aliquot option will be expanded to index-match the flattened sample list:"},
			populateSamplePrepFieldsPooled[
				{{Object[Sample, "Test water sample for populateSamplePrepFieldsPooled unit test " <> $SessionUUID]},{Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID]}},
				{
					NumberOfReplicates->2,
					Aliquot -> {True, True},
					AliquotAmount -> {1*Milliliter, 1 * Milliliter},
					TargetConcentration -> {Null,Null},
					AssayVolume -> {1.5*Milliliter, 1.5*Milliliter},
					AliquotContainer -> {{1, Model[Container, Vessel, "2mL Tube"]}, {2, Model[Container, Vessel, "2mL Tube"]},{3, Model[Container, Vessel, "2mL Tube"]}, {4, Model[Container, Vessel, "2mL Tube"]}},
					ConcentratedBuffer -> {Null,Null},
					BufferDilutionFactor -> {Null,Null},
					BufferDiluent -> {Null,Null},
					AssayBuffer -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
					AliquotSampleStorageCondition -> Null,
					AliquotPreparation -> Null,
					ConsolidateAliquots -> False,
					DestinationWell->{Null,Null, Null, Null},
					TargetConcentrationAnalyte -> {Null, Null},
					AliquotSampleLabel->{Null,Null, Null, Null}
				}
			],
			<|Replace[AliquotSamplePreparation] -> {_Association, _Association, _Association, _Association, _Association, _Association}, ConsolidateAliquots -> False, AliquotPreparation -> Null|>
		],
		Example[{Basic,"If samples are not pooled, functions the same as populateSamplePrepFieldsPooled, which returns a list of sample preparation fields to include in the Object[Protocol], based on the sample prep options present in the resolved options:"},
			populateSamplePrepFieldsPooled[
				{Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID]},
				{
					Centrifuge->{True,False},
					CentrifugeInstrument->{Null,Null},
					CentrifugeIntensity->{Null,Null},
					CentrifugeTime->{Null,Null},
					CentrifugeTemperature->{Null,Null},
					CentrifugeAliquotContainer->{Null,Null},
					CentrifugeAliquot->{Null,Null},
					Filtration->{True,False},
					FiltrationType->{Null,Null},
					FilterInstrument->{Null,Null},
					Filter->{Null,Null},
					FilterMaterial->{Null,Null},
					FilterPoreSize->{Null,Null},
					FilterSyringe->{Null,Null},
					FilterHousing->{Null,Null},
					FilterIntensity->{Null,Null},
					FilterTime->{Null,Null},
					FilterTemperature->{Null,Null},
					FilterSterile->{Null,Null},
					FilterContainerOut->{Null,Null},
					FilterAliquotContainer->{Null,Null},
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquot->{Null,Null},
					PrefilterMaterial->{Null,Null},
					PrefilterPoreSize->{Null,Null}
				}
			],
			Association[
				Replace[CentrifugeSamplePreparation]->{
					Association[
						Centrifuge->True,
						CentrifugeInstrument->Null,
						CentrifugeIntensity->Null,
						CentrifugeTime->Null,
						CentrifugeTemperature->Null,
						CentrifugeAliquotContainer->Null,
						CentrifugeAliquot->Null,
						CentrifugeAliquotDestinationWell->Automatic
					],
					Association[
						Centrifuge->False,
						CentrifugeInstrument->Null,
						CentrifugeIntensity->Null,
						CentrifugeTime->Null,
						CentrifugeTemperature->Null,
						CentrifugeAliquotContainer->Null,
						CentrifugeAliquot->Null,
						CentrifugeAliquotDestinationWell->Automatic
					]
				},
				Replace[FilterSamplePreparation]->{
					Association[
						Filtration->True,
						FiltrationType->Null,
						Filter->Null,
						FilterMaterial->Null,
						FilterPoreSize->Null,
						FilterContainerOut->Null,
						FilterInstrument->Null,
						FilterSyringe->Null,
						FilterHousing->Null,
						FilterIntensity->Null,
						FilterTime->Null,
						FilterTemperature->Null,
						FilterSterile->Null,
						FilterAliquotContainer->Null,
						FilterAliquot->Null,
						PrefilterMaterial->Null,
						PrefilterPoreSize->Null,
						FilterAliquotDestinationWell->Automatic
					],
					Association[
						Filtration->False,
						FiltrationType->Null,
						Filter->Null,
						FilterMaterial->Null,
						FilterPoreSize->Null,
						FilterContainerOut->Null,
						FilterInstrument->Null,
						FilterSyringe->Null,
						FilterHousing->Null,
						FilterIntensity->Null,
						FilterTime->Null,
						FilterTemperature->Null,
						FilterSterile->Null,
						FilterAliquotContainer->Null,
						FilterAliquot->Null,
						PrefilterMaterial->Null,
						PrefilterPoreSize->Null,
						FilterAliquotDestinationWell->Automatic
					]
				}
			]
		],
		Test["Make sure the fields can be uploaded to an Object[Protocol]:",
			Join[
				<|Type->Object[Protocol],DeveloperObject->True|>,
				populateSamplePrepFieldsPooled[
					{Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID]},
					{
						Taco->Cat,
						NumberOfReplicates->2,
						CentrifugeAliquotDestinationWell->{Automatic,Automatic},
						FilterAliquotDestinationWell->{Automatic,Automatic},
						Centrifuge->{False,False},
						CentrifugeInstrument->{Null,Null},
						CentrifugeIntensity->{Null,Null},
						CentrifugeTime->{Null,Null},
						CentrifugeTemperature->{Null,Null},
						CentrifugeAliquotContainer->{Null,Null},
						CentrifugeAliquot->{Null,Null},
						Filtration->{False,False},
						FiltrationType->{Null,Null},
						FilterInstrument->{Null,Null},
						Filter->{Null,Null},
						FilterMaterial->{Null,Null},
						FilterPoreSize->{Null,Null},
						FilterSyringe->{Null,Null},
						FilterHousing->{Null,Null},
						FilterIntensity->{Null,Null},
						FilterTime->{Null,Null},
						FilterTemperature->{Null,Null},
						FilterSterile->{Null,Null},
						FilterContainerOut->{Null,Null},
						FilterAliquotContainer->{Null,Null},
						FilterAliquot->{Null,Null},
						PrefilterMaterial->{Null,Null},
						PrefilterPoreSize->{Null,Null}
					}
				]
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic,"Non sample-prep options are ignored:"},
			populateSamplePrepFieldsPooled[
				{Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID]},
				{
					Taco->Cat,
					NumberOfReplicates->2,
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					Centrifuge->{True,False},
					CentrifugeInstrument->{Null,Null},
					CentrifugeIntensity->{Null,Null},
					CentrifugeTime->{Null,Null},
					CentrifugeTemperature->{Null,Null},
					CentrifugeAliquotContainer->{Null,Null},
					CentrifugeAliquot->{Null,Null},
					Filtration->{False,True},
					FiltrationType->{Null,Null},
					FilterInstrument->{Null,Null},
					Filter->{Null,Null},
					FilterMaterial->{Null,Null},
					FilterPoreSize->{Null,Null},
					FilterSyringe->{Null,Null},
					FilterHousing->{Null,Null},
					FilterIntensity->{Null,Null},
					FilterTime->{Null,Null},
					FilterTemperature->{Null,Null},
					FilterSterile->{Null,Null},
					FilterContainerOut->{Null,Null},
					FilterAliquotContainer->{Null,Null},
					FilterAliquot->{Null,Null},
					PrefilterMaterial->{Null,Null},
					PrefilterPoreSize->{Null,Null}
				}
			],
			Association[
				Replace[CentrifugeSamplePreparation]->{
					Association[Centrifuge->True,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Automatic],
					Association[Centrifuge->False,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Null],
					Association[Centrifuge->False,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Automatic],
					Association[Centrifuge->False,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Null]
				},
				Replace[FilterSamplePreparation]->{
					Association[Filtration->False,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Automatic],
					Association[Filtration->False,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Null],
					Association[Filtration->True,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Automatic],
					Association[Filtration->False,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Null]
				}
			]
		],
		Example[{Basic,"Aliquot options are also supported:"},
			populateSamplePrepFieldsPooled[
				{Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID]},
				{
					NumberOfReplicates->2,
					Aliquot -> {True, True, True},
					AliquotAmount -> {1*Milliliter, 1*Milliliter, 1*Milliliter},
					TargetConcentration -> {Null,Null,Null},
					AssayVolume -> {1.5*Milliliter, 1.5*Milliliter, 1.5*Milliliter},
					AliquotContainer -> {{1, Model[Container, Vessel, "2mL Tube"]}, {2, Model[Container, Vessel, "2mL Tube"]}, {3, Model[Container, Vessel, "2mL Tube"]}, {4, Model[Container, Vessel, "2mL Tube"]}, {5, Model[Container, Vessel, "2mL Tube"]}, {6, Model[Container, Vessel, "2mL Tube"]}},
					ConcentratedBuffer -> {Null,Null,Null},
					BufferDilutionFactor -> {Null,Null,Null},
					BufferDiluent -> {Null,Null,Null},
					AssayBuffer -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
					AliquotSampleStorageCondition -> Null,
					AliquotPreparation -> Null,
					ConsolidateAliquots -> False,
					DestinationWell->{Null,Null,Null,Null,Null,Null},
					TargetConcentrationAnalyte -> {Null, Null, Null},
					AliquotSampleLabel->{Null,Null,Null,Null,Null,Null}
				}
			],
			<|Replace[AliquotSamplePreparation] -> {_Association..}, ConsolidateAliquots -> False, AliquotPreparation -> Null|>
		],
		Example[{Basic,"When passed the PreparatoryUnitOperations option, informs the PreparatoryUnitOperations field:"},
			populateSamplePrepFieldsPooled[
				{Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID]},
				{
					PreparatoryUnitOperations->{
						Transfer[Source->Object[Sample,"Test chemical 1 in plate for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID]]
					}
				}
			],
			<|Replace[PreparatoryUnitOperations]->{_Transfer}|>
		]
	},
	SymbolSetUp:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects,
				(* Test object variables *)
				emptyContainer1,emptyContainer2,discardedChemical,waterSample,testBench,testWaterContainer,testWaterSample,testPlate,testChemical
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container,Bench,"Test bench for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube 1 for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube 2 for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Sample,"Test discarded chemical for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for populateSamplePrepFieldsPooled unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];
			$CreatedObjects={};

			(* Create some empty containers *)
			{emptyContainer1,emptyContainer2}=Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test 50mL tube 1 for populateSamplePrepFieldsPooled unit test "<>$SessionUUID,
					DeveloperObject->True|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test 50mL tube 2 for populateSamplePrepFieldsPooled unit test "<>$SessionUUID,
					DeveloperObject->True|>
			}];

			(* Create some water samples *)
			{discardedChemical,waterSample}=UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter
				},
				Name->{
					"Test discarded chemical for populateSamplePrepFieldsPooled unit test "<>$SessionUUID,
					"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID
				}
			];

			(* Create and upload test objects *)
			testBench=Upload[<|
				Type->Object[Container,Bench],
				Name->"Test bench for populateSamplePrepFieldsPooled unit test "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				DeveloperObject->True
			|>];
			testWaterContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube of water for populateSamplePrepFieldsPooled unit test "<>$SessionUUID
			];
			testWaterSample=UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",testWaterContainer},
				Name->"Once Glorious Water Sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID,
				InitialAmount->30 Milliliter
			];
			testPlate=UploadSample[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				{"Work Surface",testBench},
				Name->"Once Your Favorite Sample Plate for populateSamplePrepFieldsPooled unit test "<>$SessionUUID
			];
			testChemical=UploadSample[
				Model[Sample,"Dimethylformamide, Reagent Grade"],
				{"A1",testPlate},
				Name->"Test chemical 1 in plate for populateSamplePrepFieldsPooled unit test "<>$SessionUUID,
				InitialAmount->1.5 Milliliter
			];

			(* Make sure test objects are DeveloperObject *)
			Upload[
				Map[
					<|Object->#,DeveloperObject->True|> &,
					Join[{waterSample,testWaterContainer,testWaterSample,testPlate,testChemical}]
				]
			];

			(* Make some changes to our samples to make them invalid. *)
			Upload[<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>];
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
						Object[Container,Bench,"Test bench for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube 1 for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube 2 for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Sample,"Test discarded chemical for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Sample,"Test water sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for populateSamplePrepFieldsPooled unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for populateSamplePrepFieldsPooled unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			Unset[$CreatedObjects];
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsection::Closed:: *)
(*populateSamplePrepFields*)


DefineTests[populateSamplePrepFields,
	{
		Example[{Basic,"Returns a list of sample preparation fields to include in the Object[Protocol], based on the sample prep options present in the resolved options:"},
			populateSamplePrepFields[
				{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
				{
					Centrifuge->{True,False},
					CentrifugeInstrument->{Null,Null},
					CentrifugeIntensity->{Null,Null},
					CentrifugeTime->{Null,Null},
					CentrifugeTemperature->{Null,Null},
					CentrifugeAliquotContainer->{Null,Null},
					CentrifugeAliquot->{Null,Null},
					Filtration->{True,False},
					FiltrationType->{Null,Null},
					FilterInstrument->{Null,Null},
					Filter->{Null,Null},
					FilterMaterial->{Null,Null},
					FilterPoreSize->{Null,Null},
					FilterSyringe->{Null,Null},
					FilterHousing->{Null,Null},
					FilterIntensity->{Null,Null},
					FilterTime->{Null,Null},
					FilterTemperature->{Null,Null},
					FilterSterile->{Null,Null},
					FilterContainerOut->{Null,Null},
					FilterAliquotContainer->{Null,Null},
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquot->{Null,Null},
					PrefilterMaterial->{Null,Null},
					PrefilterPoreSize->{Null,Null}
				}
			],
			Association[
				Replace[CentrifugeSamplePreparation]->{
					Association[
						Centrifuge->True,
						CentrifugeInstrument->Null,
						CentrifugeIntensity->Null,
						CentrifugeTime->Null,
						CentrifugeTemperature->Null,
						CentrifugeAliquotContainer->Null,
						CentrifugeAliquot->Null,
						CentrifugeAliquotDestinationWell->Automatic
					],
					Association[
						Centrifuge->False,
						CentrifugeInstrument->Null,
						CentrifugeIntensity->Null,
						CentrifugeTime->Null,
						CentrifugeTemperature->Null,
						CentrifugeAliquotContainer->Null,
						CentrifugeAliquot->Null,
						CentrifugeAliquotDestinationWell->Automatic
					]
				},
				Replace[FilterSamplePreparation]->{
					Association[
						Filtration->True,
						FiltrationType->Null,
						Filter->Null,
						FilterMaterial->Null,
						FilterPoreSize->Null,
						FilterContainerOut->Null,
						FilterInstrument->Null,
						FilterSyringe->Null,
						FilterHousing->Null,
						FilterIntensity->Null,
						FilterTime->Null,
						FilterTemperature->Null,
						FilterSterile->Null,
						FilterAliquotContainer->Null,
						FilterAliquot->Null,
						PrefilterMaterial->Null,
						PrefilterPoreSize->Null,
						FilterAliquotDestinationWell->Automatic
					],
					Association[
						Filtration->False,
						FiltrationType->Null,
						Filter->Null,
						FilterMaterial->Null,
						FilterPoreSize->Null,
						FilterContainerOut->Null,
						FilterInstrument->Null,
						FilterSyringe->Null,
						FilterHousing->Null,
						FilterIntensity->Null,
						FilterTime->Null,
						FilterTemperature->Null,
						FilterSterile->Null,
						FilterAliquotContainer->Null,
						FilterAliquot->Null,
						PrefilterMaterial->Null,
						PrefilterPoreSize->Null,
						FilterAliquotDestinationWell->Automatic
					]
				}
			]
		],
		Example[{Basic,"Sample preparation parameters are spaced with Null/False values for replicate samples:"},
			populateSamplePrepFields[
				{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
				{
					NumberOfReplicates->2,
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					Centrifuge->{True,False},
					CentrifugeInstrument->{Null,Null},
					CentrifugeIntensity->{Null,Null},
					CentrifugeTime->{Null,Null},
					CentrifugeTemperature->{Null,Null},
					CentrifugeAliquotContainer->{Null,Null},
					CentrifugeAliquot->{Null,Null},
					Filtration->{True,False},
					FiltrationType->{Null,Null},
					FilterInstrument->{Null,Null},
					Filter->{Null,Null},
					FilterMaterial->{Null,Null},
					FilterPoreSize->{Null,Null},
					FilterSyringe->{Null,Null},
					FilterHousing->{Null,Null},
					FilterIntensity->{Null,Null},
					FilterTime->{Null,Null},
					FilterTemperature->{Null,Null},
					FilterSterile->{Null,Null},
					FilterContainerOut->{Null,Null},
					FilterAliquotContainer->{Null,Null},
					FilterAliquot->{Null,Null},
					PrefilterMaterial->{Null,Null},
					PrefilterPoreSize->{Null,Null}
				}
			],
			Association[
				Replace[CentrifugeSamplePreparation]->{
					Association[Centrifuge->True,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Automatic],
					Association[Centrifuge->False,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Null],
					Association[Centrifuge->False,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Automatic],
					Association[Centrifuge->False,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Null]
				},
				Replace[FilterSamplePreparation]->{
					Association[Filtration->True,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Automatic],
					Association[Filtration->False,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Null],
					Association[Filtration->False,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Automatic],
					Association[Filtration->False,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Null]
				}
			]
		],
		Test["Make sure the fields can be uploaded to an Object[Protocol]:",
			Join[
				<|Type->Object[Protocol],DeveloperObject->True|>,
				populateSamplePrepFields[
					{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
					{
						Taco->Cat,
						NumberOfReplicates->2,
						CentrifugeAliquotDestinationWell->{Automatic,Automatic},
						FilterAliquotDestinationWell->{Automatic,Automatic},
						Centrifuge->{False,False},
						CentrifugeInstrument->{Null,Null},
						CentrifugeIntensity->{Null,Null},
						CentrifugeTime->{Null,Null},
						CentrifugeTemperature->{Null,Null},
						CentrifugeAliquotContainer->{Null,Null},
						CentrifugeAliquot->{Null,Null},
						Filtration->{False,False},
						FiltrationType->{Null,Null},
						FilterInstrument->{Null,Null},
						Filter->{Null,Null},
						FilterMaterial->{Null,Null},
						FilterPoreSize->{Null,Null},
						FilterSyringe->{Null,Null},
						FilterHousing->{Null,Null},
						FilterIntensity->{Null,Null},
						FilterTime->{Null,Null},
						FilterTemperature->{Null,Null},
						FilterSterile->{Null,Null},
						FilterContainerOut->{Null,Null},
						FilterAliquotContainer->{Null,Null},
						FilterAliquot->{Null,Null},
						PrefilterMaterial->{Null,Null},
						PrefilterPoreSize->{Null,Null}
					}
				]
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic,"Non sample-prep options are ignored:"},
			populateSamplePrepFields[
				{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
				{
					Taco->Cat,
					NumberOfReplicates->2,
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					Centrifuge->{True,False},
					CentrifugeInstrument->{Null,Null},
					CentrifugeIntensity->{Null,Null},
					CentrifugeTime->{Null,Null},
					CentrifugeTemperature->{Null,Null},
					CentrifugeAliquotContainer->{Null,Null},
					CentrifugeAliquot->{Null,Null},
					Filtration->{False,True},
					FiltrationType->{Null,Null},
					FilterInstrument->{Null,Null},
					Filter->{Null,Null},
					FilterMaterial->{Null,Null},
					FilterPoreSize->{Null,Null},
					FilterSyringe->{Null,Null},
					FilterHousing->{Null,Null},
					FilterIntensity->{Null,Null},
					FilterTime->{Null,Null},
					FilterTemperature->{Null,Null},
					FilterSterile->{Null,Null},
					FilterContainerOut->{Null,Null},
					FilterAliquotContainer->{Null,Null},
					FilterAliquot->{Null,Null},
					PrefilterMaterial->{Null,Null},
					PrefilterPoreSize->{Null,Null}
				}
			],
			Association[
				Replace[CentrifugeSamplePreparation]->{
					Association[Centrifuge->True,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Automatic],
					Association[Centrifuge->False,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Null],
					Association[Centrifuge->False,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Automatic],
					Association[Centrifuge->False,CentrifugeInstrument->Null,CentrifugeIntensity->Null,CentrifugeTime->Null,CentrifugeTemperature->Null,CentrifugeAliquotContainer->Null,CentrifugeAliquot->Null,CentrifugeAliquotDestinationWell->Null]
				},
				Replace[FilterSamplePreparation]->{
					Association[Filtration->False,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Automatic],
					Association[Filtration->False,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Null],
					Association[Filtration->True,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Automatic],
					Association[Filtration->False,FiltrationType->Null,Filter->Null,FilterMaterial->Null,FilterPoreSize->Null,FilterContainerOut->Null,FilterInstrument->Null,FilterSyringe->Null,FilterHousing->Null,FilterIntensity->Null,FilterTime->Null,FilterTemperature->Null,FilterSterile->Null,FilterAliquotContainer->Null,FilterAliquot->Null,PrefilterMaterial->Null,PrefilterPoreSize->Null,FilterAliquotDestinationWell->Null]
				}
			]
		],
		Example[{Basic,"Aliquot options are also supported:"},
			populateSamplePrepFields[
				{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
				{
					NumberOfReplicates->2,
					Aliquot -> {True, True, True},
					AliquotAmount -> {1*Milliliter, 1*Milliliter, 1*Milliliter},
					TargetConcentration -> {Null,Null,Null},
					AssayVolume -> {1.5*Milliliter, 1.5*Milliliter, 1.5*Milliliter},
					AliquotContainer -> {{1, Model[Container, Vessel, "2mL Tube"]}, {2, Model[Container, Vessel, "2mL Tube"]}, {3, Model[Container, Vessel, "2mL Tube"]}, {4, Model[Container, Vessel, "2mL Tube"]}, {5, Model[Container, Vessel, "2mL Tube"]}, {6, Model[Container, Vessel, "2mL Tube"]}},
					ConcentratedBuffer -> {Null,Null,Null},
					BufferDilutionFactor -> {Null,Null,Null},
					BufferDiluent -> {Null,Null,Null},
					AssayBuffer -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
					AliquotSampleStorageCondition -> Null,
					AliquotPreparation -> Null,
					ConsolidateAliquots -> False,
					DestinationWell->{Null,Null,Null,Null,Null,Null},
					TargetConcentrationAnalyte -> {Null, Null, Null},
					AliquotSampleLabel->{Null,Null,Null,Null,Null,Null}
				}
			],
			<|Replace[AliquotSamplePreparation] -> {_Association..}, ConsolidateAliquots -> False, AliquotPreparation -> Null|>
		],
		Example[{Basic,"When passed the PreparatoryUnitOperations option, informs the PreparatoryUnitOperations field:"},
			populateSamplePrepFields[
				{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
				{
					PreparatoryUnitOperations->{
						Transfer[Source->Object[Sample,"Test chemical 1 in plate for populateSamplePrepFields unit test "<>$SessionUUID],Amount->300 Microliter,Destination->Object[Sample,"Once Glorious Water Sample for populateSamplePrepFields unit test "<>$SessionUUID]]
					}
				}
			],
			<|Replace[PreparatoryUnitOperations]->{_Transfer}|>
		],
		Example[{Additional,"Despite the name, post-processing fields are also populated:"},
			populateSamplePrepFields[
				{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
				{ImageSample->True,MeasureVolume->True}
			],
			<|ImageSample->True,MeasureVolume->True|>
		],
		Example[{Additional,"Works for pooled inputs and options:"},
			populateSamplePrepFields[
				{{Object[Sample,"PNA sample 1 for ExperimentUVMelting testing"],Object[Sample,"PNA sample 2 for ExperimentUVMelting testing"]},{Object[Sample,"DNA sample 1 for ExperimentUVMelting testing"]}},
				{
					Instrument->Model[Instrument,Spectrophotometer,"Cary 3500"],
					MaxTemperature->Quantity[15,"DegreesCelsius"],
					MinTemperature->Quantity[10,"DegreesCelsius"],
					NumberOfCycles->1,
					EquilibrationTime->Quantity[1,"Minutes"],
					TemperatureRampOrder->{Heating,Cooling},
					TemperatureResolution->Quantity[5,"DegreesCelsius"],
					Wavelength->Quantity[260,"Nanometers"],
					MinWavelength->Null,
					MaxWavelength->Null,
					TemperatureMonitor->ImmersionProbe,
					BlankMeasurement->False,
					NestedIndexMatchingMix->{True,True},
					NestedIndexMatchingMixType->{Invert,Pipette},
					NestedIndexMatchingNumberOfMixes->{10,10},
					NestedIndexMatchingMixVolume->{Null,Quantity[400,"Microliters"]},
					NestedIndexMatchingIncubate->{False,True},
					PooledIncubationTime->{Null,Quantity[1,"Minutes"]},
					NestedIndexMatchingIncubationTemperature->{Null,Quantity[85,"DegreesCelsius"]},
					NestedIndexMatchingAnnealingTime->{Null,Quantity[1,"Minutes"]},
					ContainerOut->{{1,Model[Container,Plate,"96-well 2mL Deep Well Plate"]},{1,Model[Container,Plate,"96-well 2mL Deep Well Plate"]}},
					Cache->{},
					FastTrack->False,
					Template->Null,
					ParentProtocol->Null,
					Operator->Null,
					Confirm->False,
					Name->Null,
					Upload->False,
					Output->Result,
					Email->False,
					MeasureWeight->False,
					MeasureVolume->False,
					ImageSample->False,
					SubprotocolDescription->Null,
					SamplesInStorageCondition->{Null,DeepFreezer},
					SamplesOutStorageCondition->{Null,Refrigerator},
					NumberOfReplicates->Null,
					Incubate->{{True,True},{True}},
					IncubationTemperature->{{Ambient,Ambient},{Ambient}},
					IncubationTime->{{Null,Null},{Null}},
					Mix->{{True,True},{True}},
					MixType->{{Pipette,Pipette},{Pipette}},
					MixUntilDissolved->{{False,False},{False}},
					MaxIncubationTime->{{Null,Null},{Null}},
					IncubationInstrument->{{Null,Null},{Null}},
					AnnealingTime->{{Null,Null},{Null}},
					IncubateAliquotContainer->{{Null,Null},{Null}},
					IncubateAliquotDestinationWell->{{Null,Null},{Null}},
					IncubateAliquot->{{Null,Null},{Null}},
					Centrifuge->{{True,True},{True}},
					CentrifugeInstrument->{{Model[Instrument,Centrifuge,"id:pZx9jo8WA4z0"],Model[Instrument,Centrifuge,"id:pZx9jo8WA4z0"]},{Model[Instrument,Centrifuge,"id:pZx9jo8WA4z0"]}},
					CentrifugeIntensity->{{Quantity[546.78`,"StandardAccelerationOfGravity"],Quantity[546.78`,"StandardAccelerationOfGravity"]},{Quantity[546.78`,"StandardAccelerationOfGravity"]}},
					CentrifugeTime->{{Quantity[5,"Minutes"],Quantity[5,"Minutes"]},{Quantity[5,"Minutes"]}},CentrifugeTemperature->{{Ambient,Ambient},{Ambient}},
					CentrifugeAliquotContainer->{{Null,Null},{Null}},
					CentrifugeAliquotDestinationWell->{{Null,Null},{Null}},
					CentrifugeAliquot->{{Null,Null},{Null}},
					Filtration->{{False,False},{False}},
					FiltrationType->{{Null,Null},{Null}},
					FilterInstrument->{{Null,Null},{Null}},
					Filter->{{Null,Null},{Null}},
					FilterMaterial->{{Null,Null},{Null}},
					PrefilterMaterial->{{Null,Null},{Null}},
					FilterPoreSize->{{Null,Null},{Null}},
					PrefilterPoreSize->{{Null,Null},{Null}},
					FilterSyringe->{{Null,Null},{Null}},
					FilterHousing->{{Null,Null},{Null}},
					FilterIntensity->{{Null,Null},{Null}},
					FilterTime->{{Null,Null},{Null}},
					FilterTemperature->{{Null,Null},{Null}},
					FilterContainerOut->{{Null,Null},{Null}},
					FilterAliquotDestinationWell->{{Null,Null},{Null}},
					FilterAliquotContainer->{{Null,Null},{Null}},
					FilterAliquot->{{Null,Null},{Null}},
					FilterSterile->{{Null,Null},{Null}},
					AliquotAmount->{{Quantity[1,"Microliters"],Quantity[1,"Microliters"]},{Quantity[2,"Microliters"]}},
					TargetConcentration->{{Null,Null},{Null}},
					TargetConcentrationAnalyte -> {{Null, Null}, {Null}},
					AssayVolume->{Quantity[600,"Microliters"],Quantity[1000,"Microliters"]},
					AliquotContainer->{{1,Model[Container,Cuvette,"id:eGakld01zz3E"]},{2,Model[Container,Cuvette,"id:R8e1PjRDbbld"]}},
					DestinationWell->{"A1","A1"},
					ConcentratedBuffer->{Null,Null},
					BufferDilutionFactor->{Null,Null},
					BufferDiluent->{Null,Null},
					AssayBuffer->{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
					AliquotSampleStorageCondition->{Null,Null},
					Aliquot->{True,True},
					ConsolidateAliquots->False,
					AliquotPreparation->Manual
				}
			],
			Association[
				Replace[IncubateSamplePreparation] -> {_Association, _Association, _Association},
				Replace[CentrifugeSamplePreparation] -> {_Association, _Association, _Association},
				ImageSample -> False,
				MeasureVolume -> False,
				MeasureWeight -> False,
				Replace[SamplesInStorage] -> {Null, DeepFreezer},
				Replace[SamplesOutStorage] -> {Null, Refrigerator}
			]
		],
		Test["Make sure the SamplesInStorage and SamplesOutStorage are added to the packet when there are no replicates:",
			Lookup[
				Join[
					<|Type->Object[Protocol],DeveloperObject->True|>,
					populateSamplePrepFields[
						{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
						{
							SamplesInStorageCondition->{Null,DeepFreezer},
							SamplesOutStorageCondition->{Null,Refrigerator},
							Taco->Cat,
							NumberOfReplicates->Null,
							CentrifugeAliquotDestinationWell->{Automatic,Automatic},
							FilterAliquotDestinationWell->{Automatic,Automatic},
							Centrifuge->{False,False},
							CentrifugeInstrument->{Null,Null},
							CentrifugeIntensity->{Null,Null},
							CentrifugeTime->{Null,Null},
							CentrifugeTemperature->{Null,Null},
							CentrifugeAliquotContainer->{Null,Null},
							CentrifugeAliquot->{Null,Null},
							Filtration->{False,False},
							FiltrationType->{Null,Null},
							FilterInstrument->{Null,Null},
							Filter->{Null,Null},
							FilterMaterial->{Null,Null},
							FilterPoreSize->{Null,Null},
							FilterSyringe->{Null,Null},
							FilterHousing->{Null,Null},
							FilterIntensity->{Null,Null},
							FilterTime->{Null,Null},
							FilterTemperature->{Null,Null},
							FilterSterile->{Null,Null},
							FilterContainerOut->{Null,Null},
							FilterAliquotContainer->{Null,Null},
							FilterAliquot->{Null,Null},
							PrefilterMaterial->{Null,Null},
							PrefilterPoreSize->{Null,Null}
						}
					]
				],
				{Replace[SamplesInStorage],Replace[SamplesOutStorage]}
			],
			{{Null,DeepFreezer},{Null,Refrigerator}}
		],
		Test["Make sure the SamplesInStorage and SamplesOutStorage are added to the packet when there are replicates:",
			Lookup[
				Join[
					<|Type->Object[Protocol],DeveloperObject->True|>,
					populateSamplePrepFields[
						{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
						{
							SamplesInStorageCondition->{Null,DeepFreezer},
							SamplesOutStorageCondition->{Null,Refrigerator},
							Taco->Cat,
							NumberOfReplicates->2,
							CentrifugeAliquotDestinationWell->{Automatic,Automatic},
							FilterAliquotDestinationWell->{Automatic,Automatic},
							Centrifuge->{False,False},
							CentrifugeInstrument->{Null,Null},
							CentrifugeIntensity->{Null,Null},
							CentrifugeTime->{Null,Null},
							CentrifugeTemperature->{Null,Null},
							CentrifugeAliquotContainer->{Null,Null},
							CentrifugeAliquot->{Null,Null},
							Filtration->{False,False},
							FiltrationType->{Null,Null},
							FilterInstrument->{Null,Null},
							Filter->{Null,Null},
							FilterMaterial->{Null,Null},
							FilterPoreSize->{Null,Null},
							FilterSyringe->{Null,Null},
							FilterHousing->{Null,Null},
							FilterIntensity->{Null,Null},
							FilterTime->{Null,Null},
							FilterTemperature->{Null,Null},
							FilterSterile->{Null,Null},
							FilterContainerOut->{Null,Null},
							FilterAliquotContainer->{Null,Null},
							FilterAliquot->{Null,Null},
							PrefilterMaterial->{Null,Null},
							PrefilterPoreSize->{Null,Null}
						}
					]
				],
				{Replace[SamplesInStorage],Replace[SamplesOutStorage]}
			],
			{{Null,Null,DeepFreezer,DeepFreezer},{Null,Null,Refrigerator,Refrigerator}}
		],
		Test["Handles the case when there are replicates and no storage conditions:",
			Lookup[
				Join[
					<|Type->Object[Protocol],DeveloperObject->True|>,
					populateSamplePrepFields[
						{Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID]},
						{
							SamplesInStorageCondition->{},
							SamplesOutStorageCondition->Null,
							Taco->Cat,
							NumberOfReplicates->2,
							CentrifugeAliquotDestinationWell->{Automatic,Automatic},
							FilterAliquotDestinationWell->{Automatic,Automatic},
							Centrifuge->{False,False},
							CentrifugeInstrument->{Null,Null},
							CentrifugeIntensity->{Null,Null},
							CentrifugeTime->{Null,Null},
							CentrifugeTemperature->{Null,Null},
							CentrifugeAliquotContainer->{Null,Null},
							CentrifugeAliquot->{Null,Null},
							Filtration->{False,False},
							FiltrationType->{Null,Null},
							FilterInstrument->{Null,Null},
							Filter->{Null,Null},
							FilterMaterial->{Null,Null},
							FilterPoreSize->{Null,Null},
							FilterSyringe->{Null,Null},
							FilterHousing->{Null,Null},
							FilterIntensity->{Null,Null},
							FilterTime->{Null,Null},
							FilterTemperature->{Null,Null},
							FilterSterile->{Null,Null},
							FilterContainerOut->{Null,Null},
							FilterAliquotContainer->{Null,Null},
							FilterAliquot->{Null,Null},
							PrefilterMaterial->{Null,Null},
							PrefilterPoreSize->{Null,Null}
						}
					]
				],
				{Replace[SamplesInStorage],Replace[SamplesOutStorage]}
			],
			{{},Null}
		]
	},
	SymbolSetUp:>{
		Module[
			{
				(* For symbol setup/teardown *)
				allObjects,existingObjects,
				(* Test object variables *)
				emptyContainer1,emptyContainer2,discardedChemical,waterSample,testBench,testWaterContainer,testWaterSample,testPlate,testChemical
			},
			allObjects=Quiet[
				Cases[
					(* Enlist test objects to make sure they got deleted. *)
					Flatten[{
						$CreatedObjects,
						Object[Container,Bench,"Test bench for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube 1 for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube 2 for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Sample,"Test discarded chemical for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for populateSamplePrepFields unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];
			$CreatedObjects={};

			(* Create some empty containers *)
			{emptyContainer1,emptyContainer2}=Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test 50mL tube 1 for populateSamplePrepFields unit test "<>$SessionUUID,
					DeveloperObject->True|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test 50mL tube 2 for populateSamplePrepFields unit test "<>$SessionUUID,
					DeveloperObject->True|>
			}];

			(* Create some water samples *)
			{discardedChemical,waterSample}=UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter
				},
				Name->{
					"Test discarded chemical for populateSamplePrepFields unit test "<>$SessionUUID,
					"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID
				}
			];

			(* Create and upload test objects *)
			testBench=Upload[<|
				Type->Object[Container,Bench],
				Name->"Test bench for populateSamplePrepFields unit test "<>$SessionUUID,
				Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
				DeveloperObject->True
			|>];
			testWaterContainer=UploadSample[
				Model[Container,Vessel,"50mL Tube"],
				{"Work Surface",testBench},
				Name->"Test 50mL tube of water for populateSamplePrepFields unit test "<>$SessionUUID
			];
			testWaterSample=UploadSample[
				Model[Sample,"Milli-Q water"],
				{"A1",testWaterContainer},
				Name->"Once Glorious Water Sample for populateSamplePrepFields unit test "<>$SessionUUID,
				InitialAmount->30 Milliliter
			];
			testPlate=UploadSample[
				Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				{"Work Surface",testBench},
				Name->"Once Your Favorite Sample Plate for populateSamplePrepFields unit test "<>$SessionUUID
			];
			testChemical=UploadSample[
				Model[Sample,"Dimethylformamide, Reagent Grade"],
				{"A1",testPlate},
				Name->"Test chemical 1 in plate for populateSamplePrepFields unit test "<>$SessionUUID,
				InitialAmount->1.5 Milliliter
			];

			(* Make sure test objects are DeveloperObject *)
			Upload[
				Map[
					<|Object->#,DeveloperObject->True|> &,
					Join[{waterSample,testWaterContainer,testWaterSample,testPlate,testChemical}]
				]
			];

			(* Make some changes to our samples to make them invalid. *)
			Upload[<|Object->discardedChemical,Status->Discarded,DeveloperObject->True|>];
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
						Object[Container,Bench,"Test bench for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube 1 for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube 2 for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Sample,"Test discarded chemical for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Sample,"Test water sample for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Container,Vessel,"Test 50mL tube of water for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Sample,"Once Glorious Water Sample for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Container,Plate,"Once Your Favorite Sample Plate for populateSamplePrepFields unit test "<>$SessionUUID],
						Object[Sample,"Test chemical 1 in plate for populateSamplePrepFields unit test "<>$SessionUUID]
					}],
					ObjectP[]
				]
			];
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			EraseObject[existingObjects,Force->True,Verbose->False];

			Unset[$CreatedObjects];
		]
	},
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsubsection:: *)
(**)


(* ::Subsubsection:: *)
(**)


(* ::Subsection::Closed:: *)
(*resolvePooledSamplePrepOptions*)


DefineTests[resolvePooledSamplePrepOptions,
	{
		Example[{Basic,"Simulate the preparation of two samples that are being aliquoted:"},
			resolvePooledSamplePrepOptions[
				ExperimentDifferentialScanningCalorimetry,
				{waterSample1,{waterSample2}},
				{
					Aliquot->{Automatic,{Automatic}},
					AliquotAmount->{Quantity[20,"Microliters"],{Quantity[20,"Microliters"]}},
					TargetConcentration->{Automatic,{Automatic}},
					TargetConcentrationAnalyte->{Automatic,{Automatic}},
					AssayVolume->{Automatic,Automatic},
					AliquotContainer->{Model[Container,Plate,"id:01G6nvkKrrYm"],Model[Container,Plate,"id:01G6nvkKrrYm"]},
					ConcentratedBuffer->{Automatic,Automatic},
					BufferDilutionFactor->{Automatic,Automatic},
					BufferDiluent->{Automatic,Automatic},
					AssayBuffer->{Automatic,Automatic},
					AliquotSampleStorageCondition->{Automatic,Automatic},
					AliquotSampleLabel->{Automatic,Automatic},
					ConsolidateAliquots->False,
					DestinationWell->{Automatic,Automatic},
					AliquotPreparation->Automatic,
					Centrifuge->{Automatic,{Automatic}},
					CentrifugeInstrument->{Automatic,{Automatic}},
					CentrifugeIntensity->{Automatic,{Automatic}},
					CentrifugeTime->{Automatic,{Automatic}},
					CentrifugeTemperature->{Automatic,{Automatic}},
					CentrifugeAliquotContainer->{Automatic,{Automatic}},
					CentrifugeAliquotDestinationWell->{Automatic,{Automatic}},
					CentrifugeAliquot->{Automatic,{Automatic}},
					Filtration->{Automatic,{Automatic}},
					FiltrationType->{Automatic,{Automatic}},
					FilterInstrument->{Automatic,{Automatic}},
					Filter->{Automatic,{Automatic}},
					FilterMaterial->{Automatic,{Automatic}},
					FilterPoreSize->{Automatic,{Automatic}},
					FilterSyringe->{Automatic,{Automatic}},
					FilterHousing->{Automatic,{Automatic}},
					FilterIntensity->{Automatic,{Automatic}},
					FilterTime->{Automatic,{Automatic}},
					FilterTemperature->{Automatic,{Automatic}},
					FilterSterile->{Automatic,{Automatic}},
					FilterContainerOut->{Automatic,{Automatic}},
					FilterAliquotContainer->{Automatic,{Automatic}},
					FilterAliquotDestinationWell->{Automatic,{Automatic}},
					FilterAliquot->{Automatic,{Automatic}},
					PrefilterMaterial->{Automatic,{Automatic}},
					PrefilterPoreSize->{Automatic,{Automatic}}
				},
				Cache->Download[{waterSample1,waterSample2}]
			],
			{
				{PatternUnion[ObjectP[Object[Sample]],Except[waterSample1]],{PatternUnion[ObjectP[Object[Sample]],Except[waterSample2]]}},
				{_Rule...},
				{_Association..}
			}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4}=Upload[{
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:zGj91aR3ddXJ"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:zGj91aR3ddXJ"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],DeveloperObject->True|>
		}];

		(* Create some water samples *)
		{waterSample1,waterSample2,waterSample3,waterSample4}=ECL`InternalUpload`UploadSample[
			{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
			{{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer4},{"A2",emptyContainer4}},
			InitialAmount->{50 Milliliter,50 Milliliter,1 Milliliter,1 Milliliter}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample1,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>,
			<|Object->waterSample3,DeveloperObject->True|>,
			<|Object->waterSample4,DeveloperObject->True|>,
			<|Object->emptyContainer1,DeveloperObject->True|>,
			<|Object->emptyContainer2,DeveloperObject->True|>,
			<|Object->emptyContainer3,DeveloperObject->True|>,
			<|Object->emptyContainer4,DeveloperObject->True|>
		}]
	),
	SymbolTearDown:>(
		EraseObject[$CreatedObjects, Force->True]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*resolveSamplePrepOptions*)


DefineTests[resolveSamplePrepOptions,
	{
		Example[{Basic,"Simulate the preparation of two samples that are being aliquoted:"},
			resolveSamplePrepOptions[
				ExperimentIncubate,
				{Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]},
				{
					Aliquot->{Automatic,Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount->{Quantity[20,"Microliters"],Quantity[20,"Microliters"]},
					TargetConcentration->{Automatic,Automatic},
					TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume->{Automatic,Automatic},
					AliquotContainer->{Model[Container,Plate,"id:01G6nvkKrrYm"],Model[Container,Plate,"id:01G6nvkKrrYm"]},
					DestinationWell->{Automatic,Automatic},
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					ConcentratedBuffer->{Automatic,Automatic},
					BufferDilutionFactor->{Automatic,Automatic},
					BufferDiluent->{Automatic,Automatic},
					AssayBuffer->{Automatic,Automatic},
					AliquotSampleStorageCondition->{Automatic,Automatic},
					ConsolidateAliquots->Automatic,
					AliquotPreparation->Automatic,
					Centrifuge->{Automatic,Automatic},
					CentrifugeInstrument->{Automatic,Automatic},
					CentrifugeIntensity->{Automatic,Automatic},
					CentrifugeTime->{Automatic,Automatic},
					CentrifugeTemperature->{Automatic,Automatic},
					CentrifugeAliquotContainer->{Automatic,Automatic},
					CentrifugeAliquot->{Automatic,Automatic},
					Filtration->{Automatic,Automatic},
					FiltrationType->{Automatic,Automatic},
					FilterInstrument->{Automatic,Automatic},
					Filter->{Automatic,Automatic},
					FilterMaterial->{Automatic,Automatic},
					FilterPoreSize->{Automatic,Automatic},
					FilterSyringe->{Automatic,Automatic},
					FilterHousing->{Automatic,Automatic},
					FilterIntensity->{Automatic,Automatic},
					FilterTime->{Automatic,Automatic},
					FilterTemperature->{Automatic,Automatic},
					FilterSterile->{Automatic,Automatic},
					FilterContainerOut->{Automatic,Automatic},
					FilterAliquotContainer->{Automatic,Automatic},
					FilterAliquot->{Automatic,Automatic},
					PrefilterMaterial->{Automatic,Automatic},
					PrefilterPoreSize->{Automatic,Automatic}
				},
				Cache->Download[{Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]}]
			],
			{
				{PatternUnion[ObjectP[Object[Sample]],Except[ObjectP[Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID]]]],PatternUnion[ObjectP[Object[Sample]],Except[ObjectP["Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]]]},
				{_Rule...},
				{_Association..}
			}
		],
		Example[{Basic,"Simulate the preparation of two samples (with no sample prep or aliquot):"},
			resolveSamplePrepOptions[
				ExperimentHPLC,
				{Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]},
				{
					Aliquot->{Automatic,Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount->{Automatic,Automatic},
					TargetConcentration->{Automatic,Automatic},
					TargetConcentrationAnalyte->{Automatic,Automatic},
					AssayVolume->{Automatic,Automatic},
					AliquotContainer->{Automatic,Automatic},
					DestinationWell->{Automatic,Automatic},
					IncubateAliquotDestinationWell->{Automatic,Automatic},
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					ConcentratedBuffer->{Automatic,Automatic},
					BufferDilutionFactor->{Automatic,Automatic},
					BufferDiluent->{Automatic,Automatic},
					AssayBuffer->{Automatic,Automatic},
					AliquotSampleStorageCondition->{Automatic,Automatic},
					ConsolidateAliquots->Automatic,
					AliquotPreparation->Automatic,
					Incubate->{Automatic,Automatic},
					IncubationTemperature->{Automatic,Automatic},
					IncubationTime->{Automatic,Automatic},
					Mix->{Automatic,Automatic},
					MixType->{Automatic,Automatic},
					MixUntilDissolved->{Automatic,Automatic},
					MaxIncubationTime->{Automatic,Automatic},
					IncubationInstrument->{Automatic,Automatic},
					AnnealingTime->{Automatic,Automatic},
					IncubateAliquotContainer->{Automatic,Automatic},
					IncubateAliquot->{Automatic,Automatic},
					Centrifuge->{Automatic,Automatic},
					CentrifugeInstrument->{Automatic,Automatic},
					CentrifugeIntensity->{Automatic,Automatic},
					CentrifugeTime->{Automatic,Automatic},
					CentrifugeTemperature->{Automatic,Automatic},
					CentrifugeAliquotContainer->{Automatic,Automatic},
					CentrifugeAliquot->{Automatic,Automatic},
					Filtration->{Automatic,Automatic},
					FiltrationType->{Automatic,Automatic},
					FilterInstrument->{Automatic,Automatic},
					Filter->{Automatic,Automatic},
					FilterMaterial->{Automatic,Automatic},
					FilterPoreSize->{Automatic,Automatic},
					FilterSyringe->{Automatic,Automatic},
					FilterHousing->{Automatic,Automatic},
					FilterIntensity->{Automatic,Automatic},
					FilterTime->{Automatic,Automatic},
					FilterTemperature->{Automatic,Automatic},
					FilterSterile->{Automatic,Automatic},
					FilterContainerOut->{Automatic,Automatic},
					FilterAliquotContainer->{Automatic,Automatic},
					FilterAliquot->{Automatic,Automatic},
					PrefilterMaterial->{Automatic,Automatic},
					PrefilterPoreSize->{Automatic,Automatic}
				},
				Cache->Download[{Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]}]
			],
			{
				{ObjectP[Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID]],ObjectP[Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]]},
				{_Rule...},
				{_Association..}
			}
		],
		Example[{Basic,"Simulate sample preparation for pooled inputs and options. When given pooled inputs, the aliquot stage is not simulated, instead, resolved aliquot options are given:"},
			resolveSamplePrepOptions[
				ExperimentUVMelting,
				{{Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]},Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID]},
				{
					Incubate->{{True,True},True},
					IncubationTemperature->{{Automatic,Automatic},Automatic},
					IncubationTime->{{Automatic,Automatic},Automatic},
					Mix->{{Automatic,Automatic},Automatic},
					MixType->{{Automatic,Automatic},Automatic},
					MixUntilDissolved->{{Automatic,Automatic},Automatic},
					MaxIncubationTime->{{Automatic,Automatic},Automatic},
					IncubationInstrument->{{Automatic,Automatic},Automatic},
					AnnealingTime->{{Automatic,Automatic},Automatic},
					IncubateAliquotContainer->{{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},
					IncubateAliquot->{{20Microliter,20Microliter},20Microliter},
					Centrifuge->{{True,True},True},
					CentrifugeInstrument->{{Automatic,Automatic},Automatic},
					CentrifugeIntensity->{{Automatic,Automatic},Automatic},
					CentrifugeTime->{{Automatic,Automatic},Automatic},
					CentrifugeTemperature->{{Automatic,Automatic},Automatic},
					CentrifugeAliquotContainer->{{Automatic,Automatic},Automatic},
					CentrifugeAliquot->{{Automatic,Automatic},Automatic},
					Filtration->{{True,True},True},
					FiltrationType->{{Automatic,Automatic},Automatic},
					FilterInstrument->{{Automatic,Automatic},Automatic},
					Filter->{{Automatic,Automatic},Automatic},
					FilterMaterial->{{Automatic,Automatic},Automatic},
					PrefilterMaterial->{{Null,Null},Null},
					FilterPoreSize->{{Null,Null},Null},
					PrefilterPoreSize->{{Null,Null},Null},
					FilterSyringe->{{Null,Null},Null},
					FilterHousing->{{Automatic,Automatic},Automatic},
					FilterIntensity->{{Automatic,Automatic},Automatic},
					FilterTime->{{Automatic,Automatic},Automatic},
					FilterTemperature->{{Automatic,Automatic},Automatic},
					FilterContainerOut->{{Automatic,Automatic},Automatic},
					FilterAliquotContainer->{{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},
					FilterAliquot->{{15Microliter,15Microliter},17Microliter},
					FilterSterile->{{False,False},False},
					Aliquot->{True,True},
					AliquotAmount->{{11Microliter,12Microliter},10Microliter},
					TargetConcentration->{{Automatic,Automatic},Automatic},
					TargetConcentrationAnalyte->{{Automatic,Automatic},Automatic},
					AssayVolume->{Automatic,Automatic},
					AliquotContainer->{Automatic,Automatic},
					DestinationWell->{Automatic,Automatic},
					ConcentratedBuffer->{Automatic,Automatic},
					BufferDilutionFactor->{Automatic,Automatic},
					BufferDiluent->{Automatic,Automatic},
					AssayBuffer->{Automatic,Automatic},
					AliquotSampleStorageCondition->{Automatic,Automatic},
					ConsolidateAliquots->Automatic,
					AliquotPreparation->Automatic
				},
				Cache->Download[{Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]}]
			],
			{
				{{PatternUnion[ObjectP[Object[Sample]],Except[ObjectP[Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID]]]],PatternUnion[ObjectP[Object[Sample]],Except[ObjectP[Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]]]]},PatternUnion[ObjectP[Object[Sample]],Except[Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID]]]},
				{_Rule...},
				{_Association..}
			},
			Messages:>{}
		],
		Example[{Additional,"Master switches that are set to False stay set to False:"},
			{simulatedSamples,resolvedSamplePrepOptions,simulatedCache}=resolveSamplePrepOptions[
				ExperimentHPLC,
				{Object[Sample, "Test sample 5 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 6 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID]},
				{
					Aliquot->{Automatic,Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount->{5Gram,7Gram},
					TargetConcentration->{Automatic,Automatic},
					TargetConcentrationAnalyte->{Automatic,Automatic},
					AssayVolume->{10Milliliter,Automatic},
					AliquotContainer->{Automatic,Automatic},
					DestinationWell->{Automatic,Automatic},
					IncubateAliquotDestinationWell->{Automatic,Automatic},
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					ConcentratedBuffer->{Automatic,Automatic},
					BufferDilutionFactor->{Automatic,Automatic},
					BufferDiluent->{Automatic,Automatic},
					AssayBuffer->{Automatic,Automatic},
					AliquotSampleStorageCondition->{Automatic,Automatic},
					ConsolidateAliquots->Automatic,
					AliquotPreparation->Automatic,
					Incubate->{True,True},
					IncubationTemperature->{Automatic,Automatic},
					IncubationTime->{Automatic,Automatic},
					Mix->{True,True},
					MixType->{Automatic,Automatic},
					MixUntilDissolved->{True,True},
					MaxIncubationTime->{Automatic,Automatic},
					IncubationInstrument->{Automatic,Automatic},
					AnnealingTime->{Automatic,Automatic},
					IncubateAliquotContainer->{Automatic,Automatic},
					IncubateAliquot->{Automatic,Automatic},
					Centrifuge->{False,False},
					CentrifugeInstrument->{Automatic,Automatic},
					CentrifugeIntensity->{Automatic,Automatic},
					CentrifugeTime->{Null,Automatic},
					CentrifugeTemperature->{Automatic,Automatic},
					CentrifugeAliquotContainer->{Automatic,Automatic},
					CentrifugeAliquot->{Automatic,Automatic},
					Filtration->{Automatic,Automatic},
					FiltrationType->{Automatic,Automatic},
					FilterInstrument->{Automatic,Automatic},
					Filter->{False,False},
					FilterMaterial->{Automatic,Null},
					FilterPoreSize->{Automatic,Automatic},
					FilterSyringe->{Automatic,Automatic},
					FilterHousing->{Automatic,Automatic},
					FilterIntensity->{Automatic,Automatic},
					FilterTime->{Null,Automatic},
					FilterTemperature->{Automatic,Automatic},
					FilterSterile->{Automatic,Automatic},
					FilterContainerOut->{Automatic,Automatic},
					FilterAliquotContainer->{Automatic,Automatic},
					FilterAliquot->{Automatic,Automatic},
					PrefilterMaterial->{Automatic,Automatic},
					PrefilterPoreSize->{Automatic,Automatic}
				},
				Cache->Download[{Object[Sample, "Test sample 5 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 6 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID]}]
			];
			Lookup[resolvedSamplePrepOptions,{Incubate,Centrifuge,Filtration}],
			{{True,True},{False,False},{False,False}},
			Messages:>{}
		],
		Example[{Additional,"Simulate the preparation of two samples (solids that are being aliquoted):"},
			{simulatedSamples,resolvedSamplePrepOptions,simulatedCache}=resolveSamplePrepOptions[
				ExperimentHPLC,
				{Object[Sample, "Test sample 5 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 6 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID]},
				{
					Aliquot->{Automatic,Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount->{5Gram,7Gram},
					TargetConcentration->{Automatic,Automatic},
					TargetConcentrationAnalyte->{Automatic,Automatic},
					AssayVolume->{10Milliliter,Automatic},
					AliquotContainer->{Automatic,Automatic},
					DestinationWell->{Automatic,Automatic},
					IncubateAliquotDestinationWell->{Automatic,Automatic},
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					ConcentratedBuffer->{Automatic,Automatic},
					BufferDilutionFactor->{Automatic,Automatic},
					BufferDiluent->{Automatic,Automatic},
					AssayBuffer->{Automatic,Automatic},
					AliquotSampleStorageCondition->{Automatic,Automatic},
					ConsolidateAliquots->Automatic,
					AliquotPreparation->Automatic,
					Incubate->{True,True},
					IncubationTemperature->{Automatic,Automatic},
					IncubationTime->{Automatic,Automatic},
					Mix->{True,True},
					MixType->{Automatic,Automatic},
					MixUntilDissolved->{True,True},
					MaxIncubationTime->{Automatic,Automatic},
					IncubationInstrument->{Automatic,Automatic},
					AnnealingTime->{Automatic,Automatic},
					IncubateAliquotContainer->{Automatic,Automatic},
					IncubateAliquot->{Automatic,Automatic},
					Centrifuge->{Automatic,Automatic},
					CentrifugeInstrument->{Automatic,Automatic},
					CentrifugeIntensity->{Automatic,Automatic},
					CentrifugeTime->{5 Second,5 Minute},
					CentrifugeTemperature->{Automatic,Automatic},
					CentrifugeAliquotContainer->{Automatic,Automatic},
					CentrifugeAliquot->{Automatic,Automatic},
					Filtration->{Automatic,Automatic},
					FiltrationType->{Automatic,Automatic},
					FilterInstrument->{Automatic,Automatic},
					Filter->{Automatic,Automatic},
					FilterMaterial->{Automatic,Automatic},
					FilterPoreSize->{Automatic,Automatic},
					FilterSyringe->{Automatic,Automatic},
					FilterHousing->{Automatic,Automatic},
					FilterIntensity->{Automatic,Automatic},
					FilterTime->{Automatic,Automatic},
					FilterTemperature->{Automatic,Automatic},
					FilterSterile->{Automatic,Automatic},
					FilterContainerOut->{Automatic,Automatic},
					FilterAliquotContainer->{Automatic,Automatic},
					FilterAliquot->{Automatic,Automatic},
					PrefilterMaterial->{Automatic,Automatic},
					PrefilterPoreSize->{Automatic,Automatic}
				},
				Cache->Download[{Object[Sample, "Test sample 5 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 6 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID]}]
			];
			{Download[simulatedSamples[[1]],Volume,Cache->simulatedCache],Download[simulatedSamples[[2]],Mass,Cache->simulatedCache]},
			{RangeP[Quantity[9.99,"Milliliters"],Quantity[10.01,"Milliliters"]],RangeP[Quantity[6.99,"Grams"],Quantity[7.01,"Grams"]]},
			Messages:>{}
		],
		Example[{Additional,"If containers are passed to this function, containers will be returned:"},
			resolveSamplePrepOptions[
				ExperimentHPLC,
				{Object[Container, Vessel, "Test container 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Container, Vessel, "Test container 2 for resolveSamplePrepOptions tests" <> $SessionUUID]},
				{
					Aliquot->{Automatic,Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount->{Quantity[20,"Microliters"],Quantity[20,"Microliters"]},
					TargetConcentration->{Automatic,Automatic},
					TargetConcentrationAnalyte->{Automatic,Automatic},
					AssayVolume->{Automatic,Automatic},
					AliquotContainer->{Model[Container,Plate,"id:01G6nvkKrrYm"],Model[Container,Plate,"id:01G6nvkKrrYm"]},
					DestinationWell->{Automatic,Automatic},
					IncubateAliquotDestinationWell->{Automatic,Automatic},
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					ConcentratedBuffer->{Automatic,Automatic},
					BufferDilutionFactor->{Automatic,Automatic},
					BufferDiluent->{Automatic,Automatic},
					AssayBuffer->{Automatic,Automatic},
					AliquotSampleStorageCondition->{Automatic,Automatic},
					ConsolidateAliquots->Automatic,
					AliquotPreparation->Automatic,
					Incubate->{True,True},
					IncubationTemperature->{Automatic,Automatic},
					IncubationTime->{Automatic,Automatic},
					Mix->{True,True},
					MixType->{Automatic,Automatic},
					MixUntilDissolved->{True,True},
					MaxIncubationTime->{Automatic,Automatic},
					IncubationInstrument->{Automatic,Automatic},
					AnnealingTime->{Automatic,Automatic},
					IncubateAliquotContainer->{Automatic,Automatic},
					IncubateAliquot->{Automatic,Automatic},
					Centrifuge->{Automatic,Automatic},
					CentrifugeInstrument->{Automatic,Automatic},
					CentrifugeIntensity->{Automatic,Automatic},
					CentrifugeTime->{Automatic,Automatic},
					CentrifugeTemperature->{Automatic,Automatic},
					CentrifugeAliquotContainer->{Automatic,Automatic},
					CentrifugeAliquot->{Automatic,Automatic},
					Filtration->{Automatic,Automatic},
					FiltrationType->{Automatic,Automatic},
					FilterInstrument->{Automatic,Automatic},
					Filter->{Automatic,Automatic},
					FilterMaterial->{Automatic,Automatic},
					FilterPoreSize->{Automatic,Automatic},
					FilterSyringe->{Automatic,Automatic},
					FilterHousing->{Automatic,Automatic},
					FilterIntensity->{Automatic,Automatic},
					FilterTime->{Automatic,Automatic},
					FilterTemperature->{Automatic,Automatic},
					FilterSterile->{Automatic,Automatic},
					FilterContainerOut->{Automatic,Automatic},
					FilterAliquotContainer->{Automatic,Automatic},
					FilterAliquot->{Automatic,Automatic},
					PrefilterMaterial->{Automatic,Automatic},
					PrefilterPoreSize->{Automatic,Automatic}
				},
				Cache->Download[{Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Container, Vessel, "Test container 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Container, Vessel, "Test container 2 for resolveSamplePrepOptions tests" <> $SessionUUID]}]
			],
			{
				{PatternUnion[ObjectP[Object[Container]],Except[ObjectP[Object[Container, Vessel, "Test container 1 for resolveSamplePrepOptions tests" <> $SessionUUID]]]],PatternUnion[ObjectP[Object[Container]],Except[ObjectP[Object[Container, Vessel, "Test container 2 for resolveSamplePrepOptions tests" <> $SessionUUID]]]]},
				{_Rule...},
				{_Association..}
			},
			Messages:>{}
		],
		Example[{Additional,"Containers that have no samples in their Contents field cannot have sample prep options turned on for them:"},
			resolveSamplePrepOptions[
				ExperimentHPLC,
				{Object[Container, Vessel, "Test container 7 for resolveSamplePrepOptions tests" <> $SessionUUID], Object[Container, Vessel, "Test container 3 (empty) for resolveSamplePrepOptions tests" <> $SessionUUID]},
				{
					Aliquot->{Automatic,Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount->{Automatic,Automatic},
					TargetConcentration->{Automatic,Automatic},
					TargetConcentrationAnalyte->{Automatic,Automatic},
					AssayVolume->{Automatic,Automatic},
					AliquotContainer->{{1,Model[Container, Plate, "96-well PCR Plate"]},Model[Container, Plate, "96-well PCR Plate"]},
					DestinationWell->{Automatic,Automatic},
					IncubateAliquotDestinationWell->{Automatic,Automatic},
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					ConcentratedBuffer->{Automatic,Automatic},
					BufferDilutionFactor->{Automatic,Automatic},
					BufferDiluent->{Automatic,Automatic},
					AssayBuffer->{Automatic,Automatic},
					AliquotSampleStorageCondition->{Automatic,Automatic},
					ConsolidateAliquots->Automatic,
					AliquotPreparation->Automatic,
					Incubate->{Automatic,Automatic},
					IncubationTemperature->{Automatic,Automatic},
					IncubationTime->{Automatic,Automatic},
					Mix->{True,True},
					MixType->{Automatic,Automatic},
					MixUntilDissolved->{True,True},
					MaxIncubationTime->{Automatic,Automatic},
					IncubationInstrument->{Automatic,Automatic},
					AnnealingTime->{Automatic,Automatic},
					IncubateAliquotContainer->{Automatic,Automatic},
					IncubateAliquot->{Automatic,Automatic},
					Centrifuge->{Automatic,Automatic},
					CentrifugeInstrument->{Automatic,Automatic},
					CentrifugeIntensity->{Automatic,Automatic},
					CentrifugeTime->{Automatic,Automatic},
					CentrifugeTemperature->{Automatic,Automatic},
					CentrifugeAliquotContainer->{Automatic,Automatic},
					CentrifugeAliquot->{Automatic,Automatic},
					Filtration->{Automatic,Automatic},
					FiltrationType->{Centrifuge,Centrifuge},
					FilterInstrument->{Automatic,Automatic},
					Filter->{Automatic,Automatic},
					FilterMaterial->{Automatic,Automatic},
					FilterPoreSize->{Automatic,Automatic},
					FilterSyringe->{Automatic,Automatic},
					FilterHousing->{Automatic,Automatic},
					FilterIntensity->{Automatic,Automatic},
					FilterTime->{Automatic,Automatic},
					FilterTemperature->{Automatic,Automatic},
					FilterSterile->{Automatic,Automatic},
					FilterContainerOut->{Automatic,Automatic},
					FilterAliquotContainer->{Automatic,Automatic},
					FilterAliquot->{Automatic,Automatic},
					PrefilterMaterial->{Automatic,Automatic},
					PrefilterPoreSize->{Automatic,Automatic}
				},
				Cache -> Download[{Object[Sample, "Test sample 7 for resolveSamplePrepOptions tests" <> $SessionUUID], Object[Container, Vessel, "Test container 7 for resolveSamplePrepOptions tests" <> $SessionUUID], Object[Container, Vessel, "Test container 3 (empty) for resolveSamplePrepOptions tests" <> $SessionUUID]}]
			],
			{
				{ObjectP[Object[Container, Plate]], ObjectP[Object[Container, Vessel, "Test container 3 (empty) for resolveSamplePrepOptions tests" <> $SessionUUID]]},
				{_Rule...},
				{_Association..}
			},
			Messages:>{
				Error::CantSamplePrepInvalidContainers,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		Example[{Additional, "Containers that have multiple samples in their Contents field cannot have sample prep options turned on for them:"},
			resolveSamplePrepOptions[
				ExperimentHPLC,
				{Object[Container, Vessel, "Test container 7 for resolveSamplePrepOptions tests" <> $SessionUUID], Object[Container, Plate, "Test container 4 for resolveSamplePrepOptions tests" <> $SessionUUID]},
				{
					Aliquot -> {Automatic, Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount -> {Automatic, Automatic},
					TargetConcentration -> {Automatic, Automatic},
					TargetConcentrationAnalyte -> {Automatic, Automatic},
					AssayVolume -> {Automatic, Automatic},
					AliquotContainer -> {{1, Model[Container, Plate, "id:01G6nvkKrrYm"]}, Model[Container, Plate, "id:01G6nvkKrrYm"]},
					DestinationWell -> {Automatic, Automatic},
					IncubateAliquotDestinationWell -> {Automatic, Automatic},
					CentrifugeAliquotDestinationWell -> {Automatic, Automatic},
					FilterAliquotDestinationWell -> {Automatic, Automatic},
					ConcentratedBuffer -> {Automatic, Automatic},
					BufferDilutionFactor -> {Automatic, Automatic},
					BufferDiluent -> {Automatic, Automatic},
					AssayBuffer -> {Automatic, Automatic},
					AliquotSampleStorageCondition -> {Automatic, Automatic},
					ConsolidateAliquots -> Automatic,
					AliquotPreparation -> Automatic,
					Incubate -> {Automatic, Automatic},
					IncubationTemperature -> {Automatic, Automatic},
					IncubationTime -> {Automatic, Automatic},
					Mix -> {True, True},
					MixType -> {Automatic, Automatic},
					MixUntilDissolved -> {True, True},
					MaxIncubationTime -> {Automatic, Automatic},
					IncubationInstrument -> {Automatic, Automatic},
					AnnealingTime -> {Automatic, Automatic},
					IncubateAliquotContainer -> {Automatic, Automatic},
					IncubateAliquot -> {Automatic, Automatic},
					Centrifuge -> {True, True},
					CentrifugeInstrument -> {Automatic, Automatic},
					CentrifugeIntensity -> {Automatic, Automatic},
					CentrifugeTime -> {Automatic, Automatic},
					CentrifugeTemperature -> {Automatic, Automatic},
					CentrifugeAliquotContainer -> {Automatic, Automatic},
					CentrifugeAliquot -> {Automatic, Automatic},
					Filtration -> {Automatic, Automatic},
					FiltrationType -> {Automatic, Automatic},
					FilterInstrument -> {Automatic, Automatic},
					Filter -> {Automatic, Automatic},
					FilterMaterial -> {Automatic, Automatic},
					FilterPoreSize -> {Automatic, Automatic},
					FilterSyringe -> {Automatic, Automatic},
					FilterHousing -> {Automatic, Automatic},
					FilterIntensity -> {Automatic, Automatic},
					FilterTime -> {Automatic, Automatic},
					FilterTemperature -> {Automatic, Automatic},
					FilterSterile -> {Automatic, Automatic},
					FilterContainerOut -> {Automatic, Automatic},
					FilterAliquotContainer -> {Automatic, Automatic},
					FilterAliquot -> {Automatic, Automatic},
					PrefilterMaterial -> {Automatic, Automatic},
					PrefilterPoreSize -> {Automatic, Automatic}
				},
				Cache -> Download[{Object[Sample, "Test sample 7 for resolveSamplePrepOptions tests" <> $SessionUUID], Object[Container, Vessel, "Test container 7 for resolveSamplePrepOptions tests" <> $SessionUUID], Object[Container, Plate, "Test container 4 for resolveSamplePrepOptions tests" <> $SessionUUID]}]
			],
			{
				{ObjectP[Object[Container, Plate]], ObjectP[Object[Container, Plate, "Test container 4 for resolveSamplePrepOptions tests" <> $SessionUUID]]},
				{_Rule...},
				{_Association..}
			},
			Messages :> {
				Error::CantSamplePrepInvalidContainers,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		Example[{Additional,"Containers that cannot be sample prepped will have their options resolved to False/Null:"},
			{samples,options,cache}=resolveSamplePrepOptions[
				ExperimentHPLC,
				{Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID]},
				{
					Aliquot->{Automatic,Automatic},
					AliquotSampleLabel -> {Automatic, Automatic},
					AliquotAmount->{Automatic,Automatic},
					TargetConcentration->{Automatic,Automatic},
					TargetConcentrationAnalyte->{Automatic,Automatic},
					AssayVolume->{Automatic,Automatic},
					AliquotContainer->{{1,Model[Container,Plate,"id:01G6nvkKrrYm"]},Automatic},
					DestinationWell->{Automatic,Automatic},
					IncubateAliquotDestinationWell->{Automatic,Automatic},
					CentrifugeAliquotDestinationWell->{Automatic,Automatic},
					FilterAliquotDestinationWell->{Automatic,Automatic},
					ConcentratedBuffer->{Automatic,Automatic},
					BufferDilutionFactor->{Automatic,Automatic},
					BufferDiluent->{Automatic,Automatic},
					AssayBuffer->{Automatic,Automatic},
					AliquotSampleStorageCondition->{Automatic,Automatic},
					ConsolidateAliquots->Automatic,
					AliquotPreparation->Automatic,
					Incubate->{Automatic,Automatic},
					IncubationTemperature->{Automatic,Automatic},
					IncubationTime->{Automatic,Automatic},
					Mix->{True,Automatic},
					MixType->{Automatic,Automatic},
					MixUntilDissolved->{True,Automatic},
					MaxIncubationTime->{Automatic,Automatic},
					IncubationInstrument->{Automatic,Automatic},
					AnnealingTime->{Automatic,Automatic},
					IncubateAliquotContainer->{Automatic,Automatic},
					IncubateAliquot->{Automatic,Automatic},
					Centrifuge->{True,Automatic},
					CentrifugeInstrument->{Automatic,Automatic},
					CentrifugeIntensity->{Automatic,Automatic},
					CentrifugeTime->{Automatic,Automatic},
					CentrifugeTemperature->{Automatic,Automatic},
					CentrifugeAliquotContainer->{Automatic,Automatic},
					CentrifugeAliquot->{Automatic,Automatic},
					Filtration->{Automatic,Automatic},
					FiltrationType->{Automatic,Automatic},
					FilterInstrument->{Automatic,Automatic},
					Filter->{Automatic,Automatic},
					FilterMaterial->{Automatic,Automatic},
					FilterPoreSize->{Automatic,Automatic},
					FilterSyringe->{Automatic,Automatic},
					FilterHousing->{Automatic,Automatic},
					FilterIntensity->{Automatic,Automatic},
					FilterTime->{Automatic,Automatic},
					FilterTemperature->{Automatic,Automatic},
					FilterSterile->{Automatic,Automatic},
					FilterContainerOut->{Automatic,Automatic},
					FilterAliquotContainer->{Automatic,Automatic},
					FilterAliquot->{Automatic,Automatic},
					PrefilterMaterial->{Automatic,Automatic},
					PrefilterPoreSize->{Automatic,Automatic}
				},
				Cache->Download[{Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Container, Vessel, "Test container 1 for resolveSamplePrepOptions tests" <> $SessionUUID],Object[Container, Vessel, "Test container 3 (empty) for resolveSamplePrepOptions tests" <> $SessionUUID]}]
			];

			Lookup[options,{Incubate,Centrifuge,Filtration,Mix}],
			{{True,False},{True,False},{False,False},{True,False}},
			Messages:>{}
		]
	},
	SetUp :> (
		$CreatedObjects={}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp:>(
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 (empty) for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Plate, "Test container 4 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 3 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 4 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 5 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 6 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 7 for resolveSamplePrepOptions tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[
			{fakeBench, emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6,
				emptyContainer7, waterSample1, waterSample2, waterSample3, waterSample4, solidSample1, solidSample2,
				waterSample5},

			fakeBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Test bench for resolveSamplePrepOptions tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

			{
				emptyContainer1,
				emptyContainer2,
				emptyContainer3,
				emptyContainer4,
				emptyContainer5,
				emptyContainer6,
				emptyContainer7
			} = UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container, Vessel, "1L Glass Bottle"],
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"]
				},
				{
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench}
				},
				Name -> {
					"Test container 1 for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test container 2 for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test container 3 (empty) for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test container 4 for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test container 5 for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test container 6 for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test container 7 for resolveSamplePrepOptions tests" <> $SessionUUID
				}
			];

			(* Create some water samples *)
			{
				waterSample1,
				waterSample2,
				waterSample3,
				waterSample4,
				solidSample1,
				solidSample2,
				waterSample5
			} = ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Ac-dC-CE Phosphoramidite"],
					Model[Sample,"Ac-dC-CE Phosphoramidite"],
					Model[Sample,"Milli-Q water"]
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer4},
					{"A2",emptyContainer4},
					{"A1",emptyContainer5},
					{"A1",emptyContainer6},
					{"A1",emptyContainer7}
				},
				InitialAmount->{
					50 Milliliter,
					50 Milliliter,
					1 Milliliter,
					1 Milliliter,
					10Gram,
					11Gram,
					5 Milliliter
				},
				Name -> {
					"Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test sample 3 for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test sample 4 for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test sample 5 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test sample 6 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID,
					"Test sample 7 for resolveSamplePrepOptions tests" <> $SessionUUID
				}
			];

			(* Make some changes to our samples to make them invalid. *)
			Upload[<|Object -> #, DeveloperObject -> True|>& /@ {
				emptyContainer1, emptyContainer2, emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7,
				waterSample1, waterSample2, waterSample3, waterSample4, solidSample1, solidSample2, waterSample5
			}]
		];
	),
	SymbolTearDown:>(
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 (empty) for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Plate, "Test container 4 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Test container 7 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 1 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 2 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 3 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 4 for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 5 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 6 (solid) for resolveSamplePrepOptions tests" <> $SessionUUID],
					Object[Sample, "Test sample 7 for resolveSamplePrepOptions tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*simulateSamplePreparation*)


DefineTests[simulateSamplePreparation,
	{
		Example[{Basic,"Simulate the preparation of one sample that is not being aliquoted:"},
			simulateSamplePreparation[
				{waterSample1},
				{Instrument->{Model[Instrument,Centrifuge,"id:pZx9jo8WA4z0"]},Intensity->{Quantity[546.78`,"StandardAccelerationOfGravity"]},Template->Null,Confirm->False,Name->Null,IncubateAliquotContainer->Automatic,FilterAliquotContainer->Automatic,ImageSample->False,SamplesInStorageCondition->Null,Temperature->{Ambient},Time->{Quantity[5,"Minutes"]},AliquotAmount->Null,TargetConcentration->Null,AssayVolume->Null,AliquotContainer->Null,ConcentratedBuffer->Null,BufferDilutionFactor->Null,BufferDiluent->Null,AssayBuffer->Null,AliquotSampleStorageCondition->Null,Aliquot->False,ConsolidateAliquots->False,AliquotPreparation->Null,Incubate->Automatic,IncubationTemperature->Automatic,IncubationTime->Automatic,Mix->Automatic,MixType->Automatic,MixUntilDissolved->Automatic,MaxIncubationTime->Automatic,IncubationInstrument->Automatic,AnnealingTime->Automatic,Filtration->Automatic,FiltrationType->Automatic,FilterInstrument->Automatic,Filter->Automatic,FilterMaterial->Automatic,FilterPoreSize->Automatic,FilterSyringe->Automatic,FilterHousing->Automatic,FilterIntensity->Automatic,FilterTime->Automatic,FilterTemperature->Automatic,FilterSterile->Automatic,FilterContainerOut->Automatic},
				Aliquot,AssayVolume,AliquotContainer,"after aliquoting into CentrifugeContainers"
			],
			{{waterSample1},{}}
		],
		Example[{Basic,"Simulate the preparation of one sample that is being aliquoted:"},
			simulateSamplePreparation[
				{waterSample1},
				{Instrument->{Model[Instrument,Centrifuge,"id:pZx9jo8WA4z0"]},Intensity->{Quantity[546.78`,"StandardAccelerationOfGravity"]},Template->Null,Confirm->False,Name->Null,IncubateAliquotContainer->Automatic,FilterAliquotContainer->Automatic,ImageSample->False,SamplesInStorageCondition->Null,Temperature->{Ambient},Time->{Quantity[5,"Minutes"]},AliquotAmount->Null,TargetConcentration->Null,AssayVolume->1 Milliliter,AliquotContainer->Model[Container,Vessel,"id:3em6Zv9NjjN8"],ConcentratedBuffer->Null,BufferDilutionFactor->Null,BufferDiluent->Null,AssayBuffer->Null,AliquotSampleStorageCondition->Null,Aliquot->False,ConsolidateAliquots->False,AliquotPreparation->Null,Incubate->Automatic,IncubationTemperature->Automatic,IncubationTime->Automatic,Mix->Automatic,MixType->Automatic,MixUntilDissolved->Automatic,MaxIncubationTime->Automatic,IncubationInstrument->Automatic,AnnealingTime->Automatic,Filtration->Automatic,FiltrationType->Automatic,FilterInstrument->Automatic,Filter->Automatic,FilterMaterial->Automatic,FilterPoreSize->Automatic,FilterSyringe->Automatic,FilterHousing->Automatic,FilterIntensity->Automatic,FilterTime->Automatic,FilterTemperature->Automatic,FilterSterile->Automatic,FilterContainerOut->Automatic},
				Aliquot,AssayVolume,AliquotContainer,"after aliquoting into CentrifugeContainers"
			],
			{{ObjectP[Object[Sample]]},{}}
		],
		Example[{Basic,"Simulate the preparation of one sample that is having its mass aliquoted:"},
			simulateSamplePreparation[
				{waterSample1},
				{AssayAmount->10 Gram,Instrument->{Model[Instrument,Centrifuge,"id:pZx9jo8WA4z0"]},Intensity->{Quantity[546.78`,"StandardAccelerationOfGravity"]},Template->Null,Confirm->False,Name->Null,IncubateAliquotContainer->Automatic,FilterAliquotContainer->Automatic,ImageSample->False,SamplesInStorageCondition->Null,Temperature->{Ambient},Time->{Quantity[5,"Minutes"]},AliquotAmount->Null,TargetConcentration->Null,AssayVolume->1 Milliliter,AliquotContainer->Model[Container,Vessel,"id:3em6Zv9NjjN8"],ConcentratedBuffer->Null,BufferDilutionFactor->Null,BufferDiluent->Null,AssayBuffer->Null,AliquotSampleStorageCondition->Null,Aliquot->False,ConsolidateAliquots->False,AliquotPreparation->Null,Incubate->Automatic,IncubationTemperature->Automatic,IncubationTime->Automatic,Mix->Automatic,MixType->Automatic,MixUntilDissolved->Automatic,MaxIncubationTime->Automatic,IncubationInstrument->Automatic,AnnealingTime->Automatic,Filtration->Automatic,FiltrationType->Automatic,FilterInstrument->Automatic,Filter->Automatic,FilterMaterial->Automatic,FilterPoreSize->Automatic,FilterSyringe->Automatic,FilterHousing->Automatic,FilterIntensity->Automatic,FilterTime->Automatic,FilterTemperature->Automatic,FilterSterile->Automatic,FilterContainerOut->Automatic},
				Aliquot,AssayAmount,AliquotContainer,"after aliquoting into CentrifugeContainers"
			],
			{{ObjectP[Object[Sample]]},{}}
		],
		Example[{Basic,"Correctly handles ConsolidateAliquots->True:"},
			{samples,cache}=simulateSamplePreparation[{waterSample1,waterSample1},{AliquotAmount->{Quantity[25.`,"Microliters"],Quantity[25.`,"Microliters"]},TargetConcentration->{Null,Null},AssayVolume->{Quantity[25.`,"Microliters"],Quantity[25.`,"Microliters"]},AliquotContainer->{{1,Model[Container,Vessel,"id:3em6Zv9NjjN8"]},{1,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},ConcentratedBuffer->{Null,Null},BufferDilutionFactor->{Null,Null},BufferDiluent->{Null,Null},AssayBuffer->{Null,Null},AliquotSampleStorageCondition->{Null,Null},Aliquot->{True,True},ConsolidateAliquots->True,AliquotPreparation->Robotic},Aliquot,AssayVolume,AliquotContainer,"after aliquoting into AliquotContainer",Cache->Download[{waterSample1}]];
			{Length[DeleteDuplicates[samples]]==1,!MatchQ[samples,{waterSample1,waterSample1}],MatchQ[Download[First[samples],Volume,Cache->cache],RangeP[49.9Microliter,50.1Microliter]]},
			{True,True,True}
		]
	},
	SymbolSetUp:>(
		Off[Warning::DeprecatedProduct];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2}=Upload[{
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:zGj91aR3ddXJ"],Objects],DeveloperObject->True|>
		}];

		(* Create some water samples *)
		{waterSample1,waterSample2}=ECL`InternalUpload`UploadSample[
			{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
			{{"A1",emptyContainer1},{"A1",emptyContainer2}},
			InitialAmount->{50 Milliliter,50 Milliliter}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample1,Status->Discarded,DeveloperObject->True|>,
			<|Object->waterSample2,Status->Discarded,DeveloperObject->True|>
		}]
	),
	SymbolTearDown:>(
		On[Warning::DeprecatedProduct];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects, Force->True]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*simulateSamplePreparationPackets*)


DefineTests[simulateSamplePreparationPackets,
	{
		Test["If given cache as the input options, don't include that cache in the output; instead, include it with the other cache generated:",
			Module[{objects, options, newCache},
				{objects, options, newCache} = simulateSamplePreparationPackets[
					ExperimentMeasureConductivity,
					{"My Buffer"},
					{
						PreparatoryUnitOperations->{
							LabelContainer[
								Label->"My Buffer",
								Container->Model[Container,Vessel,"Amber Glass Bottle 4 L"]
							],
							Transfer[
								Source->Model[Sample, "Milli-Q water"],
								Destination->"My Buffer",
								Amount->2 Liter
							],
							Transfer[
								Source->Model[Sample,"Heptafluorobutyric acid"],
								Destination->"My Buffer",
								Amount->1 Milliliter
							]
						},
						Cache -> {<|Object -> Object[User, Emerald, Developer, "id:testdev"], CakePreference -> "Test Cheesecake", Simulated -> True|>}
					}
				];
				{
					Lookup[options, Cache],
					Download[Object[User, Emerald, Developer, "id:testdev"], CakePreference, Cache -> newCache]
				}
			],
			{
				_?MissingQ,
				"Test Cheesecake"
			}
		],
		Example[{Basic,"The old version of the function returns a cache when doing SP:"},
			simulateSamplePreparationPackets[
				ExperimentMeasureConductivity,
				{"My Buffer"},
				{
					PreparatoryUnitOperations->{
						LabelContainer[
							Label->"My Buffer",
							Container->Model[Container,Vessel,"Amber Glass Bottle 4 L"]
						],
						Transfer[
							Source->Model[Sample, "Milli-Q water"],
							Destination->"My Buffer",
							Amount->2 Liter
						],
						Transfer[
							Source->Model[Sample,"Heptafluorobutyric acid"],
							Destination->"My Buffer",
							Amount->1 Milliliter
						]
					}
				}
			],
			{_List, _List, _List},
			TimeConstraint -> 1000
		],
		Example[{Basic,"Simulate an incubation using PreparatoryUnitOperations:"},
			ExperimentIncubate[
				"My Container",
				PreparatoryUnitOperations->{
					LabelContainer[Label->"My Container",Container->Model[Container,Vessel,"50mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->10 Milliliter,Destination->"My Container"]
				}
			],
			ObjectP[Object[Protocol,Incubate]],
			TimeConstraint -> 1000
		],
		Example[{Basic,"Simulate an ExperimentPowderXRD using PreparatoryUnitOperations:"},
			protocol = ExperimentPowderXRD[
				{"NIST standard sample 1", "NIST standard sample 2"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "NIST standard sample 1", Container -> Model[Container, Vessel, "2mL Tube"]],
					LabelContainer[Label -> "NIST standard sample 2", Container -> Model[Container, Vessel, "2mL Tube"]],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 1",
						Amount -> 10*Milligram
					],
					Transfer[
						Source -> Model[Sample, "Silicon, NIST SRM 640f, powder, line position and line shape standard for powder diffraction"],
						Destination -> "NIST standard sample 2",
						Amount -> 10*Milligram
					],
					Transfer[
						Source -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
						Amount -> {80*Microliter, 80*Microliter},
						Destination -> {"NIST standard sample 1", "NIST standard sample 2"}
					]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol},
			TimeConstraint -> 900
		],
		Example[{Basic,"Providing an invalid option for PreparatoryUnitOperations cleanly returns $Failed:"},
			ExperimentIncubate[
				"My Container",
				PreparatoryUnitOperations->{
					Define[Name->"My Container",Container->Model[Container,Vessel,"50mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->10 Milliliter,Destination->"My Container"]
				},
				Time-> 2 Hour,
				Temperature -> 80 Celsius
			],
			$Failed,
			Messages:>{
				Error::InvalidUnitOperationHeads,
				Error::InvalidInput
			}
		],
		Example[{Basic,"Simulate an incubation with prepared samples in the options and in the input:"},
			ExperimentIncubate[
				{"My named model reference"},
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "my container", Container -> Model[Container, Vessel, "50mL Tube"]],
					LabelContainer[Label->"My named model reference",Container->Model[Container,Vessel,"50mL Tube"]],
					Transfer[Source -> Model[Sample, "Milli-Q water"], Amount -> 10 Milliliter, Destination -> "my container"],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->10 Milliliter,Destination->"My named model reference"]
				},
				AliquotContainer -> {{1, "my container"}}
			],
			$Failed,
			Messages:>{Error::NonEmptyContainers, Error::InvalidOption},
			TimeConstraint -> 1000
		],
		Test["Make sure that the old version of this function that returns a cache works properly with PreparatoryUnitOperations:",
			ExperimentAutoclave[
				"My Container",
				PreparatoryUnitOperations->{
					LabelContainer[Label->"My Container",Container->Model[Container, Vessel, "100 mL Glass Bottle"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Amount->10 Milliliter,Destination->"My Container"]
				}
			],
			ObjectP[Object[Protocol, Autoclave]],
			TimeConstraint -> 1000
		]
	},
	SymbolSetUp:>(
		Off[Warning::DeprecatedProduct];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};
	),
	SymbolTearDown:>(
		On[Warning::DeprecatedProduct];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects, Force->True]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	HardwareConfiguration -> HighRAM
];

(* ::Subsection::Closed:: *)
(*simulateSamplePreparationPacketsNew*)


DefineTests[simulateSamplePreparationPacketsNew,
	{
		Example[{Basic, "The new version of the function returns a simulation when doing SP:"},
			simulateSamplePreparationPacketsNew[
				ExperimentMeasureConductivity,
				{"My Buffer"},
				{
					PreparatoryUnitOperations->{
						LabelContainer[
							Label->"My Buffer",
							Container->Model[Container,Vessel,"Amber Glass Bottle 4 L"]
						],
						Transfer[
							Source->Model[Sample, "Milli-Q water"],
							Destination->"My Buffer",
							Amount->2 Liter
						],
						Transfer[
							Source->Model[Sample,"Heptafluorobutyric acid"],
							Destination->"My Buffer",
							Amount->1 Milliliter
						]
					}
				}
			],
			{_List, _List, SimulationP},
			TimeConstraint -> 1000
		],
		Example[{Basic, "When the input is a list of Model[Sample]s, returns a list of simulated Object[Sample]s and populates ModelInputOptions and PreparatoryUnitOperations:"},
			simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Model[Sample, "Milli-Q water"]},
				{Output -> Options}
			],
			{
				{ObjectP[Object[Sample]]},
				KeyValuePattern[{
					PreparedModelAmount -> EqualP[1 Milliliter],
					PreparedModelContainer -> ObjectP[Model[Container, Vessel, "2mL Tube"]],
					PreparatoryUnitOperations -> {ManualSamplePreparation[_LabelSample]}
				}],
				SimulationP
			}
		],
		Example[{Basic, "When the input is a list of Object[Sample]s, populates ModelInputOptions as Null:"},
			simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Object[Sample, "resolveExperimentOptions 2mL tube sample 1"]},
				{Output -> Options}
			],
			{
				{ObjectP[Object[Sample]]},
				KeyValuePattern[{
					PreparedModelAmount -> Null,
					PreparedModelContainer -> Null
				}],
				SimulationP
			}
		],
		Example[{Basic, "When the input is a list of containers with its location position, populates ModelInputOptions as Null:"},
			simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{
					{"A2", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					{"B8", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					{"Z1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]}
				},
				{Output -> Options}
			],
			{
				_List,
				KeyValuePattern[{
					PreparedModelAmount -> Null,
					PreparedModelContainer -> Null
				}],
				SimulationP
			}
		],
		Example[{Basic, "When the input is a mix of Model[Sample], Object[Sample] and container, populates ModelInputOptions in the corresponding position:"},
			simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{
					{"A2", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					Model[Sample, "Milli-Q water"],
					{"Z1", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
					Object[Sample, "resolveExperimentOptions 2mL tube sample 1"]
				},
				{Output -> Options}
			],
			{
				_List,
				KeyValuePattern[{
					PreparedModelAmount -> {Null, EqualP[1 Milliliter], Null, Null},
					PreparedModelContainer -> {Null, ObjectP[Model[Container, Vessel, "2mL Tube"]], Null, Null},
					PreparatoryUnitOperations -> {ManualSamplePreparation[_LabelSample]}
				}],
				SimulationP
			}
		],
		Example[{Basic, "When the input is nested indexmaching with Model[Sample], populates ModelInputOptions in the corresponding position:"},
			simulateSamplePreparationPacketsNew[
				ExperimentSolidPhaseExtraction,
				{
					{
						Object[Sample, "resolveExperimentOptions 2mL tube sample 1"],
						Model[Sample, StockSolution, "NaCl Solution in Water"]
					},
					{
						{"A2", Object[Container, Plate, "resolveExperimentOptions 3-Sample Plate"]},
						Model[Sample, StockSolution, "NaCl Solution in Water"]
					}
				},
				{Output -> Options}
			],
			{
				_List,
				KeyValuePattern[{
					PreparedModelAmount -> {{Null, EqualP[1 Milliliter]}, {Null, EqualP[1 Milliliter]}},
					PreparedModelContainer -> {{Null, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {Null, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
					PreparatoryUnitOperations -> {ManualSamplePreparation[_LabelSample]}
				}],
				SimulationP
			}
		],
		Test["When the input is a Model[Sample] and Sample(Container)Label is specified, populates ModelInputOptions and PreparatoryUnitOperations with the specified Sample(Container)Label as Label:",
			simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Model[Sample, "Milli-Q water"]},
				{SampleLabel -> "my water resource", SampleContainerLabel -> "my water tank", Output -> Options}
			],
			{
				{ObjectP[Object[Sample]]},
				KeyValuePattern[{
					PreparedModelAmount -> EqualP[1 Milliliter],
					PreparedModelContainer -> ObjectP[Model[Container, Vessel, "2mL Tube"]],
					PreparatoryUnitOperations -> {
						ManualSamplePreparation[
							LabelSample[
								KeyValuePattern[{
									Sample -> {ObjectP[Model[Sample, "Milli-Q water"]]},
									Label -> {"my water resource"},
									ContainerLabel -> {"my water tank"}
								}]
							]
						]
					}
				}],
				SimulationP
			}
		],
		Test["When the inputs are multiple Model[Sample]s in the same plate and the plate label is specified, populates PreparatoryUnitOperations with the specified SampleContainerLabel as ContainerLabel:",
			simulateSamplePreparationPacketsNew[
				ExperimentCircularDichroism,
				{Model[Sample, "Methanol"], Model[Sample, "Methanol"]},
				{
					PreparedModelContainer -> Model[Container, Plate, "Hellma Black Quartz Microplate"],
					PreparedModelAmount -> 200 Microliter,
					SampleContainerLabel -> {"my quartz plate", "my quartz plate"}
				}
			],
			{
				{ObjectP[Object[Sample]], ObjectP[Object[Sample]]},
				KeyValuePattern[{
					PreparedModelAmount -> EqualP[200 Microliter],
					PreparedModelContainer -> ObjectP[Model[Container, Plate, "Hellma Black Quartz Microplate"]],
					PreparatoryUnitOperations -> {
						ManualSamplePreparation[
							LabelSample[
								KeyValuePattern[{
									Sample -> {ObjectP[Model[Sample, "Methanol"]], ObjectP[Model[Sample, "Methanol"]]},
									Well -> {"A1", "B1"},
									ContainerLabel -> {"my quartz plate", "my quartz plate"}
								}]
							]
						]
					}
				}],
				SimulationP
			}
		],
		Test["When the input are multiple Model[Sample]s in 1-well plate model, partitioned samples to multiple plates and populate PreparatoryUnitOperations:",
			simulateSamplePreparationPacketsNew[
				ExperimentCircularDichroism,
				{Model[Sample, "Methanol"], Model[Sample, "Methanol"], Model[Sample, "Methanol"]},
				{
					PreparedModelContainer -> Model[Container, Plate, "Omni Tray Sterile Media Plate"],
					PreparedModelAmount -> 200 Microliter
				}
			],
			{
				{ObjectP[Object[Sample]], ObjectP[Object[Sample]], ObjectP[Object[Sample]]},
				KeyValuePattern[{
					PreparedModelAmount -> EqualP[200 Microliter],
					PreparedModelContainer -> ObjectP[Model[Container, Plate, "Omni Tray Sterile Media Plate"]],
					PreparatoryUnitOperations -> {
						ManualSamplePreparation[
							LabelSample[
								KeyValuePattern[{
									Sample -> {ObjectP[Model[Sample, "Methanol"]], ObjectP[Model[Sample, "Methanol"]], ObjectP[Model[Sample, "Methanol"]]},
									Well -> {"A1", "A1", "A1"}
								}]
							]
						]
					}
				}],
				SimulationP
			}
		],
		Test["When the input are multiple Model[Sample]s in different vessels and the container labels are specified, populates PreparatoryUnitOperations with the specified SampleContainerLabel as ContainerLabel:",
			simulateSamplePreparationPacketsNew[
				ExperimentCircularDichroism,
				{Model[Sample, "Methanol"], Model[Sample, "Methanol"], Model[Sample, "Methanol"]},
				{
					PreparedModelContainer -> {Model[Container, Plate, "Hellma Black Quartz Microplate"], Model[Container, Plate, "Hellma Black Quartz Microplate"], Model[Container, Vessel, "2mL Tube"]},
					PreparedModelAmount -> 200 Microliter,
					SampleContainerLabel -> {"my quartz plate1", "my quartz plate2", "my tube"}
				}
			],
			{
				{ObjectP[Object[Sample]], ObjectP[Object[Sample]], ObjectP[Object[Sample]]},
				KeyValuePattern[{
					PreparedModelAmount -> EqualP[200 Microliter],
					PreparedModelContainer -> {ObjectP[Model[Container, Plate, "Hellma Black Quartz Microplate"]], ObjectP[Model[Container, Plate, "Hellma Black Quartz Microplate"]], ObjectP[Model[Container, Vessel, "2mL Tube"]]},
					PreparatoryUnitOperations -> {
						ManualSamplePreparation[
							LabelSample[
								KeyValuePattern[{
									Sample -> {ObjectP[Model[Sample, "Methanol"]], ObjectP[Model[Sample, "Methanol"]], ObjectP[Model[Sample, "Methanol"]]},
									Well -> {"A1", "A1", "A1"},
									ContainerLabel -> {"my quartz plate1", "my quartz plate2", "my tube"}
								}]
							]
						]
					}
				}],
				SimulationP
			}
		],
		Test["When the input is a list of Model[Sample]s and Source(Container)Labels are specified, populates ModelInputOptions and PreparatoryUnitOperations with the specified Source(Container)Label as Label:",
			simulateSamplePreparationPacketsNew[
				ExperimentAliquot,
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				{SourceLabel -> {"my water resource1", "my water resource2"}, SourceContainerLabel -> {"my water tank1", "my water tank2"}, Output -> Options}
			],
			{
				{ObjectP[Object[Sample]], ObjectP[Object[Sample]]},
				KeyValuePattern[{
					PreparedModelAmount -> ListableP[EqualP[1 Milliliter]],
					PreparedModelContainer -> ListableP[ObjectP[Model[Container, Vessel, "2mL Tube"]]],
					PreparatoryUnitOperations -> {
						ManualSamplePreparation[
							LabelSample[
								KeyValuePattern[{
									Sample -> {ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]},
									Label -> {"my water resource1", "my water resource2"},
									ContainerLabel -> {"my water tank1", "my water tank2"}
								}]
							]
						]
					}
				}],
				SimulationP
			}
		],
		Test["When using framework experiment and Model[Sample]s as samples for the first unit operation and passed to downstream unit operations, ResolvedUnitOperationInput has the specified SampleLabel as 2nd unit operation input:",
			Module[{protocol},
				protocol = ExperimentManualCellPreparation[
					{
						Incubate[
							Sample -> Model[Sample, "Ecoli 25922-GFP Cell Line"],
							Thaw -> True,
							ThawTemperature -> 40 Celsius,
							SampleLabel -> "my cell",
							SampleContainerLabel -> "my cell container"
						],
						InoculateLiquidMedia[
							Sample -> "my cell",
							DestinationMedia -> Model[Sample, Media, "LB (Liquid)"],
							DestinationMediaContainer -> Model[Container, Vessel, "125mL Erlenmeyer Flask"],
							SampleOutLabel -> "sample in flask",
							ContainerOutLabel -> "my flask"
						]
					}
				];
				Download[protocol, {FutureLabeledObjects, ResolvedUnitOperationInputs}]
			],
			{
				{
					"my cell" -> _LabelField,
					"my cell container" -> _LabelField,
					"sample in flask" -> _LabelField,
					"my flask" -> _LabelField
				},
				{{ObjectP[Model[Sample, "Ecoli 25922-GFP Cell Line"]]}, {"my cell"}}
			}
		],
		Test["When using Model[Sample]s as samples for a standalone experiment, PreparedSamples field is populated:",
			Module[{protocol},
				protocol = ExperimentIncubate[
					Model[Sample, "Ecoli 25922-GFP Cell Line"],
					Thaw -> True,
					ThawTemperature -> 40 Celsius,
					SampleLabel -> "my cell",
					SampleContainerLabel -> "my cell container"
				];
				Download[protocol, PreparedSamples]
			],
			{
				{"my cell", SamplesIn, ___},
				{"my cell container", ContainersIn, ___}
			}
		],
		Test["When using Model[Sample]s as samples and add PreparatoryUnitOperations as the input again, don't duplicate LabelSample UOs:",
			simulateSamplePreparationPacketsNew[
				ExperimentAliquot,
				{Model[Sample, "Milli-Q water"]},
				{
					SourceLabel -> {"my water sample"},
					PreparatoryUnitOperations -> {ManualSamplePreparation[
						LabelSample[Sample -> Model[Sample, "Milli-Q water"], Label -> "my water sample", Amount -> 1 Milliliter, Container -> Model[Container, Vessel, "2mL Tube"]]]
					}
				}
			],
			{
				{ObjectP[Object[Sample]]},
				KeyValuePattern[{
					PreparedModelAmount -> EqualP[1 Milliliter],
					PreparedModelContainer -> ObjectP[Model[Container, Vessel, "2mL Tube"]],
					PreparatoryUnitOperations -> {
						ManualSamplePreparation[
							LabelSample[
								KeyValuePattern[{
									Sample -> {ObjectP[Model[Sample, "Milli-Q water"]]},
									Label -> {"my water sample"}
								}]
							]
						]
					}
				}],
				SimulationP
			}
		],
		Test["When using the same Model[Sample]s both as input sample and another non-input sample, both exist in LabelSample UO:",
			simulateSamplePreparationPacketsNew[
				ExperimentAliquot,
				{Model[Sample, "Milli-Q water"]},
				{
					SourceLabel -> {"my water sample"},
					PreparatoryUnitOperations -> {ManualSamplePreparation[
						LabelSample[Sample -> Model[Sample, "Milli-Q water"], Label -> "my back up water sample", Amount -> 1 Milliliter, Container -> Model[Container, Vessel, "2mL Tube"], Well -> "A1"]]
					}
				}
			],
			{
				{ObjectP[Object[Sample]]},
				KeyValuePattern[{
					PreparedModelAmount -> EqualP[1 Milliliter],
					PreparedModelContainer -> ObjectP[Model[Container, Vessel, "2mL Tube"]],
					PreparatoryUnitOperations -> {
						ManualSamplePreparation[
							LabelSample[
								KeyValuePattern[{
									Sample -> {ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]]},
									Label -> {"my back up water sample", "my water sample"}
								}]
							]
						]
					}
				}],
				SimulationP
			}
		],
		Test["If given a simulation as the input options, don't include that simulation in the output; instead, include it with the other simulation generated:",
			Module[{objects, options, newSimulation},
				{objects, options, newSimulation} = simulateSamplePreparationPacketsNew[
					ExperimentMeasureConductivity,
					{"My Buffer"},
					{
						PreparatoryUnitOperations->{
							LabelContainer[
								Label->"My Buffer",
								Container->Model[Container,Vessel,"Amber Glass Bottle 4 L"]
							],
							Transfer[
								Source->Model[Sample, "Milli-Q water"],
								Destination->"My Buffer",
								Amount->2 Liter
							],
							Transfer[
								Source->Model[Sample,"Heptafluorobutyric acid"],
								Destination->"My Buffer",
								Amount->1 Milliliter
							]
						},
						Simulation -> Simulation[<|Object -> Object[User, Emerald, Developer, "id:testdev"], CakePreference -> "Test Cheesecake"|>]
					}
				];
				{
					Lookup[options, Simulation],
					Download[Object[User, Emerald, Developer, "id:testdev"], CakePreference, Simulation -> newSimulation]
				}
			],
			{
				_?MissingQ,
				"Test Cheesecake"
			}
		],
		Example[{Options, DefaultPreparedModelContainer, "If a model is specified as the input to the function, DefaultPreparedModelContainer is default to 2mL Tube:"},
			{simSamples, resolvedOptions, outputSim} = simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Model[Sample, "Milli-Q water"]},
				{Thaw -> True, ThawTemperature -> 40 Celsius}
			];
			Lookup[resolvedOptions, PreparedModelContainer],
			ObjectP[Model[Container, Vessel, "2mL Tube"]],
			Variables :> {simSamples, resolvedOptions, outputSim}
		],
		Example[{Options, DefaultPreparedModelAmount, "If a model is specified as the input to the function, DefaultPreparedModelAmount is default to 1mL:"},
			{simSamples, resolvedOptions, outputSim} = simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Model[Sample, "Milli-Q water"]},
				{Thaw -> True, ThawTemperature -> 40 Celsius}
			],
			Lookup[resolvedOptions, PreparedModelAmount],
			EqualP[1 Milliliter],
			Variables :> {simSamples, resolvedOptions, outputSim}
		],
		Example[{Options, DefaultPreparedModelAmount, "DefaultPreparedModelAmount can be specified in the format of MassP:"},
			{simSamples, resolvedOptions, outputSim} = simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Model[Sample, "Sodium Chloride"]},
				{Thaw -> True, ThawTemperature -> 40 Celsius},
				DefaultPreparedModelAmount -> 1 Gram
			],
			Lookup[resolvedOptions, PreparedModelAmount],
			EqualP[1 Gram],
			Variables :> {simSamples, resolvedOptions, outputSim}
		],
		Example[{Options, DefaultPreparedModelAmount, "DefaultPreparedModelAmount can be specified in the format of CountP:"},
			{simSamples, resolvedOptions, outputSim} = simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Model[Sample, "Nootropic Sachets"]},
				{Thaw -> True, ThawTemperature -> 40 Celsius},
				DefaultPreparedModelAmount -> 1
			],
			Lookup[resolvedOptions, PreparedModelAmount],
			EqualP[1],
			Variables :> {simSamples, resolvedOptions, outputSim}
		],
		Example[{Options, DefaultPreparedModelAmount, "DefaultPreparedModelAmount can be specified as All and the entire amount from its product is used in LabelSample:"},
			{simSamples, resolvedOptions, outputSim} = simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Model[Sample, "Ecoli 25922-GFP Cell Line"]},
				{Thaw -> True, ThawTemperature -> 40 Celsius},
				DefaultPreparedModelAmount -> All
			],
			{
				Lookup[resolvedOptions, PreparedModelAmount],
				Lookup[resolvedOptions, PreparatoryUnitOperations]
			},
			{
				All,
				{
					ManualCellPreparation[
						LabelSample[
							KeyValuePattern[
								Sample -> ObjectP[Model[Sample, "Ecoli 25922-GFP Cell Line"]],
								Container -> ObjectP[],
								Amount -> 0.5 Gram
							]
						]
					]
				}
			},
			Variables :> {simSamples, resolvedOptions, outputSim}
		],
		Test["If DefaultPreparatoryModelAmount is specified to All, for water model or stock solution model still resolve to 1ml for PreparedModelAmount:",
			{simSamples, resolvedOptions, outputSim} = simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Model[Sample, "Milli-Q water"], Model[Sample, StockSolution, "NaCl Solution in Water"], Model[Sample, "Ecoli 25922-GFP Cell Line"]},
				{Thaw -> True, ThawTemperature -> 40 Celsius},
				DefaultPreparedModelAmount -> All
			];
			Lookup[resolvedOptions, {PreparedModelAmount, PreparatoryUnitOperations}],
			{
				All,
				{
					ManualCellPreparation[
						LabelSample[
							KeyValuePattern[{
								Sample -> {ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, StockSolution, "NaCl Solution in Water"]], ObjectP[Model[Sample, "Ecoli 25922-GFP Cell Line"]]},
								Container -> {ObjectP[]..},
								Amount -> {EqualP[1 Milliliter], EqualP[1 Milliliter], EqualP[0.5 Gram]}
							}]
						]
					]
				}
			},
			Variables :> {simSamples, resolvedOptions, outputSim}
		],
		Example[{Additional, "If a model is specified as the input to the function, PreparatoryModelContainer and PreparatoryModelAmount are specified to indicate what container and amount the model should have:"},
			options = ExperimentFilter[
				{Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "50mL Tube"],
				PreparedModelAmount -> 20 Milliliter,
				Output -> Options
			];
			preparatoryUnitOperations = Lookup[options, PreparatoryUnitOperations];
			labelSample = preparatoryUnitOperations[[1, 1]];
			prepContainer = labelSample[Container];
			prepAmount = labelSample[Amount];
			{prepContainer, prepAmount},
			{{ObjectP[Model[Container, Vessel, "50mL Tube"]]}, {EqualP[20 Milliliter]}},
			Variables :> {options, preparatoryUnitOperations, prepContainer, prepAmount}
		],
		Test["If preparing 3 models, and then we re-run the resolver with the resolved-from-the-first-time prep unit operations, we properly re-use the labels and don't just make more (and the scrambling order doesn't mess up the sample labeling):",
			inputModels = Download[{Model[Sample, "Milli-Q water"], Model[Sample, "Acetone, Reagent Grade"], Model[Sample, "Milli-Q water"]}, Object];
			options1 = ExperimentFilter[
				inputModels,
				PreparedModelContainer -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "2mL Tube"], Model[Container, Vessel, "15mL Tube"]},
				PreparedModelAmount -> {20 Milliliter, 1 Milliliter, 5 Milliliter},
				Output -> Options
			];
			{sampleLabels1, prepUOs1} = Lookup[options1, {SampleLabel, PreparatoryUnitOperations}];
			labelSample1 = prepUOs1[[1, 1]];
			labelToInputRules1 = MapThread[
				#1 -> #2&,
				{labelSample1[Label], labelSample1[Sample]}
			];

			options2 = ExperimentFilter[
				inputModels,
				PreparedModelContainer -> {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "2mL Tube"], Model[Container, Vessel, "15mL Tube"]},
				PreparedModelAmount -> {20 Milliliter, 1 Milliliter, 5 Milliliter},
				PreparatoryUnitOperations -> prepUOs1,
				Output -> Options
			];
			{sampleLabels2, prepUOs2} = Lookup[options2, {SampleLabel, PreparatoryUnitOperations}];

			labelSample2 = prepUOs2[[1, 1]];
			labelToInputRules2 = MapThread[
				#1 -> #2&,
				{labelSample2[Label], labelSample2[Sample]}
			];
			(* the labels, even if scrambled in the PreparatoryUnitOperations, are unscrambled in the SampleLabel option (both first and second time running it) *)
			{
				sampleLabels1 /. labelToInputRules1,
				sampleLabels2 /. labelToInputRules2
			},
			{inputModels, inputModels},
			Variables :> {inputModels, options1, sampleLabels1, prepUOs1, labelSample1, labelToInputRules1, options2, sampleLabels2, prepUOs2, labelSample2, labelToInputRules2},
			TimeConstraint -> 600
		],
		Example[{Messages, "PreparedModelAmountOrContainerMismatchedLength", "PreparedModelContainer and PreparedModelAmount must be index matched properly with the specified model(s):"},
			simulateSamplePreparationPacketsNew[
				ExperimentFilter,
				{Model[Sample, "Milli-Q water"]},
				{PreparedModelContainer -> {Model[Container, Vessel, "50mL Tube"]}, PreparedModelAmount -> {10 Milliliter, 20 Milliliter}}
			],
			_,
			Messages :> {
				Error::PreparedModelAmountOrContainerMismatchedLength,
				Error::InvalidOption
			}
		],
		Test["Immediately return $Failed in the experiment function when premature return is encountered:",
			ExperimentFilter[
				{Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> {Model[Container, Vessel, "50mL Tube"]},
				PreparedModelAmount -> {10 Milliliter, 20 Milliliter}
			],
			$Failed,
			Messages :> {
				Error::PreparedModelAmountOrContainerMismatchedLength,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreparedModelMissingProduct", "When PreparedModelAmount is All and PreparedModelContainer is 15ml tube but no such product is found:"},
			simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{Model[Sample, "Ecoli 25922-GFP Cell Line"]},
				{PreparedModelAmount -> All, PreparedModelContainer -> Model[Container, Vessel, "15mL Tube"]}
			],
			_,
			Messages :> {
				Error::PreparedModelMissingProduct,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoPreparatoryUnitOperationsWithItems", "When the input is an item and PreparatoryUnitOperation is specified, throw an error:"},
			simulateSamplePreparationPacketsNew[
				ExperimentAutoclave,
				{Object[Item, Septum, "Test Septum for simulateSamplePreparationPacketsNew" <> $SessionUUID]},
				{
					PreparatoryUnitOperations -> {
						LabelSample[Sample -> Model[Sample, "Milli-Q water"], Label -> "water 1"]
					}
				}
			],
			_,
			SetUp :> (
				$CreatedObjects = {};
				If[!DatabaseMemberQ[Object[Item, Septum, "Test Septum for simulateSamplePreparationPacketsNew" <> $SessionUUID]],
					Upload[<|
						Type -> Object[Item, Septum],
						DeveloperObject -> True,
						Name -> "Test Septum for simulateSamplePreparationPacketsNew" <> $SessionUUID,
						Model -> Link[Model[Item, Septum, "PTFE/Silicon 30mm Septum"], Objects]
					|>]
				]
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
				Unset[$CreatedObjects]
			),
			Messages :> {
				Error::NoPreparatoryUnitOperationsWithItems,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MissingDefineNames", "When prepared samples have not defined in PreparatoryUnitOperations option, throw an error:"},
			simulateSamplePreparationPacketsNew[
				ExperimentIncubate,
				{"new sample"},
				{}
			],
			_,
			Messages :> {
				Error::MissingDefineNames,
				Error::InvalidInput
			}
		]
	},
	SymbolSetUp:>(
		Off[Warning::DeprecatedProduct];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};
	),
	SymbolTearDown:>(
		On[Warning::DeprecatedProduct];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects, Force->True]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	HardwareConfiguration -> HighRAM
];

(* ::Subsection::Closed:: *)
(*populateWorkingAndAliquotSamples*)

DefineTests[populateWorkingAndAliquotSamples,
	{
		Example[{Basic,"If SamplesIn/ContainersIn are populated but WorkingSamples/WorkingContainers are not, propagate those:"},
			Download[
				populateWorkingAndAliquotSamples[Object[Protocol, Incubate, "Test Incubate sub 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]],
				{WorkingSamples, WorkingContainers}
			],
			{
				{
					ObjectP[Object[Sample, "Test sample 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]],
					ObjectP[Object[Sample, "Test sample 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]]
				},
				{
					ObjectP[Object[Container, Vessel, "Test container 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]],
					ObjectP[Object[Container, Vessel, "Test container 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]]
				}
			}
		],
		Example[{Basic,"If SamplesIn/ContainersIn and WorkingSamples are populated, propagate the WorkingSamples to AliquotSamples of both the protocol and the corresopnding unit operation:"},
			Download[
				populateWorkingAndAliquotSamples[Object[Protocol, Incubate, "Test Incubate sub 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]],
				{AliquotSamples, ParentProtocol[OutputUnitOperations][[1]][AliquotSamples]}
			],
			{
				{
					ObjectP[Object[Sample, "Test sample 5 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]],
					ObjectP[Object[Sample, "Test sample 6 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]]
				},
				{
					ObjectP[Object[Sample, "Test sample 5 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]],
					ObjectP[Object[Sample, "Test sample 6 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]]
				}
			}
		]
	},
	SymbolSetUp:>(
		Block[{$DeveloperUpload = True},
			Module[{objs, existingObjs},
				objs = {
					Object[Container, Bench, "Test bench for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Protocol, Incubate, "Test Incubate sub 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Protocol, Incubate, "Test Incubate sub 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Protocol, Filter, "Test Filter parent 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test MSP parent 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Sample, "Test sample 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Sample, "Test sample 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Sample, "Test sample 3 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Sample, "Test sample 4 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Sample, "Test sample 5 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Sample, "Test sample 6 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Container, Vessel, "Test container 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Container, Vessel, "Test container 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Container, Vessel, "Test container 3 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Container, Vessel, "Test container 4 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Container, Vessel, "Test container 5 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[Container, Vessel, "Test container 6 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
					Object[UnitOperation, Incubate, "Test Incubate unit operation 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]
				};
				existingObjs = PickList[objs, DatabaseMemberQ[objs]];
				EraseObject[existingObjs, Force -> True]
			];
			Module[
				{
					testBench,
					container1, container2, container3, container4, container5, container6,
					sample1, sample2, sample3, sample4, sample5, sample6,
					parentFilter1, parentMSP1, incubateSub1, incubateSub2, incubateUO1
				},

				testBench = Upload[<|Type -> Object[Container, Bench], Name -> "Test bench for populateWorkingAndAliquotSamples tests " <> $SessionUUID, Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects]|>];

				{
					container1,
					container2,
					container3,
					container4,
					container5,
					container6
				} = UploadSample[
					ConstantArray[Model[Container, Vessel, "2mL Tube"], 6],
					ConstantArray[{"Work Surface", testBench}, 6],
					Name -> Table["Test container " <> ToString[i] <> " for populateWorkingAndAliquotSamples tests " <> $SessionUUID, {i, 6}],
					FastTrack -> True
				];
				{
					sample1,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6
				} = UploadSample[
					ConstantArray[Model[Sample, "Milli-Q water"], 6],
					Map[
						{"A1", #}&,
						{
							container1,
							container2,
							container3,
							container4,
							container5,
							container6
						}
					],
					Name -> Table["Test sample " <> ToString[i] <> " for populateWorkingAndAliquotSamples tests " <> $SessionUUID, {i, 6}],
					InitialAmount -> 1 Milliliter,
					FastTrack -> True
				];

				{
					parentFilter1,
					parentMSP1,
					incubateSub1,
					incubateSub2,
					incubateUO1
				} = CreateID[{
					Object[Protocol, Filter],
					Object[Protocol, ManualSamplePreparation],
					Object[Protocol, Incubate],
					Object[Protocol, Incubate],
					Object[UnitOperation, Incubate]
				}];

				Upload[{
					<|
						Object -> parentFilter1,
						Name -> "Test Filter parent 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID
					|>,
					<|
						Object -> parentMSP1,
						Name -> "Test MSP parent 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID,
						Replace[OutputUnitOperations] -> Link[incubateUO1, Protocol]
					|>,
					<|
						Object -> incubateUO1,
						Name -> "Test Incubate unit operation 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID,
						Subprotocol -> Link[incubateSub2]
					|>,
					<|
						Object -> incubateSub1,
						Name -> "Test Incubate sub 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID,
						ParentProtocol -> Link[parentFilter1, Subprotocols],
						Replace[SamplesIn] -> {Link[sample1, Protocols], Link[sample2, Protocols]},
						Replace[ContainersIn] -> {Link[container1, Protocols], Link[container2, Protocols]}
					|>,
					<|
						Object -> incubateSub2,
						Name -> "Test Incubate sub 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID,
						ParentProtocol -> Link[parentMSP1, Subprotocols],
						Replace[SamplesIn] -> {Link[sample3, Protocols], Link[sample4, Protocols]},
						Replace[ContainersIn] -> {Link[container3, Protocols], Link[container4, Protocols]},
						Replace[WorkingSamples] -> {Link[sample5], Link[sample6]},
						Replace[WorkingContainers] -> {Link[container5], Link[container6]}
					|>
				}];
			]
		]
	),
	SymbolTearDown:>(
		Module[{objs, existingObjs},
			objs = {
				Object[Container, Bench, "Test bench for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Protocol, Incubate, "Test Incubate sub 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Protocol, Incubate, "Test Incubate sub 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Protocol, Filter, "Test Filter parent 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Test MSP parent 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Sample, "Test sample 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Sample, "Test sample 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Sample, "Test sample 3 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Sample, "Test sample 4 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Sample, "Test sample 5 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Sample, "Test sample 6 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Container, Vessel, "Test container 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Container, Vessel, "Test container 2 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Container, Vessel, "Test container 3 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Container, Vessel, "Test container 4 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Container, Vessel, "Test container 5 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[Container, Vessel, "Test container 6 for populateWorkingAndAliquotSamples tests " <> $SessionUUID],
				Object[UnitOperation, Incubate, "Test Incubate unit operation 1 for populateWorkingAndAliquotSamples tests " <> $SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True]
		]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*populateWorkingSamples*)

DefineTests[populateWorkingSamples,
	{
		Example[{Basic,"Populate the working samples of a parent protocol after an aliquot:"},
			Download[
				populateWorkingSamples[Object[Protocol, AbsorbanceSpectroscopy, "Test AbsSpec ParentProtocol for populateWorkingSamples" <> $SessionUUID]],
				{WorkingSamples, WorkingContainers}
			],
			{
				{
					ObjectP[Object[Sample, "populateWorkingSamples New Test Chemical 1 (1.5 mL)" <> $SessionUUID]]
				},
				{
					ObjectP[Object[Container, Vessel, "Test 2 mL Tube 1 for populateWorkingSamples tests" <> $SessionUUID]]
				}
			}
		]
	},
	SymbolSetUp :> (
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Test bench for populateWorkingSamples tests" <> $SessionUUID],

				Object[Instrument, PlateReader, "populateWorkingSamples test Pherastar" <> $SessionUUID],

				Object[Container, Plate, "Test plate 1 for populateWorkingSamples tests" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube 1 for populateWorkingSamples tests" <> $SessionUUID],
				Object[Container, Vessel, "Test 50 mL Tube 1 for populateWorkingSamples tests" <> $SessionUUID],

				Object[Sample, "populateWorkingSamples New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "populateWorkingSamples SamplesOut Chemical 1 (300 uL)" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Test AbsSpec ParentProtocol for populateWorkingSamples" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Test Aliquot Subprotocol for populateWorkingSamples" <> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench, container, container2, container3, sample, sample2, allObjs,
					pherastarReader, parentProtocol, aliquotProtocol, parentSamplesIn, sourceName
				},

				fakeBench=Upload[
					<|
						Type -> Object[Container,Bench],
						Model -> Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name -> "Test bench for populateWorkingSamples tests" <> $SessionUUID,
						DeveloperObject -> True
					|>
				];

				pherastarReader=Upload[
					<|
						Type -> Object[Instrument,PlateReader],
						Model -> Link[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"],Objects],
						Name -> "populateWorkingSamples test Pherastar" <> $SessionUUID,
						DeckLayout -> Link[Model[DeckLayout, "id:lYq9jRxzDNPl"], ConfiguredInstruments],
						DeveloperObject -> True,
						Software -> "ReaderControl",
						Site -> Link[$Site]
					|>];

				(* make containers and samples *)
				{
					container,
					container2,
					container3
				}=UploadSample[
					{
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Name->{
						"Test plate 1 for populateWorkingSamples tests" <> $SessionUUID,
						"Test 2 mL Tube 1 for populateWorkingSamples tests" <> $SessionUUID,
						"Test 50 mL Tube 1 for populateWorkingSamples tests" <> $SessionUUID
					}
				];


				{
					sample,
					sample2
				} = UploadSample[
					{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1", container2},
						{"A1", container}
					},
					State -> Liquid,
					InitialAmount -> {
						1.5*Milliliter,
						300*Microliter
					},
					Name -> {
						"populateWorkingSamples New Test Chemical 1 (1.5 mL)" <> $SessionUUID,
						"populateWorkingSamples SamplesOut Chemical 1 (300 uL)" <> $SessionUUID
					}
				];

				allObjs = Join[Flatten[{container, container2, container3, sample, sample2}]];

				(* make abs spec parent protocol *)
				parentProtocol = ExperimentAbsorbanceSpectroscopy[
					sample,
					Instrument -> pherastarReader,
					Aliquot -> True,
					Preparation -> Manual,
					AliquotPreparation -> Manual
				];

				TestResources[parentProtocol];

				parentSamplesIn = Download[parentProtocol, SamplesIn];
				sourceName = Lookup[Download[parentProtocol, AliquotSamplePreparation], AliquotSampleLabel];

				(* make MSP protocol *)
				aliquotProtocol =ExperimentAliquot[
					parentSamplesIn,
					SourceLabel -> sourceName,
					Amount -> 300 Microliter,
					ContainerOut -> container,
					Preparation -> Manual
				];

				(* upload necessary fields for function to work properly *)
				Upload[
					<|
						Object -> parentProtocol,
						Replace[WorkingSamples] -> Link[sample],
						Replace[WorkingContainers] -> Link[container2],
						Replace[SamplePreparationProtocols] -> Link[aliquotProtocol],
						Name -> "Test AbsSpec ParentProtocol for populateWorkingSamples" <> $SessionUUID,
						DeveloperObject -> True
					|>
				];

				Upload[
					<|
						Object -> aliquotProtocol,
						ParentProtocol -> Link[parentProtocol, Subprotocols],
						Replace[SamplesOut] -> Link[sample2, Protocols],
						Replace[ContainersOut] -> Link[container, Protocols],
						Name -> "Test Aliquot Subprotocol for populateWorkingSamples" <> $SessionUUID,
						DeveloperObject -> True

					|>
				];

				Upload[
					Flatten[{
						<|
							Object -> #,
							DeveloperObject -> True
						|>& /@ allObjs
					}]
				];

			]
		]
	),
	SymbolTearDown :> (
		Module[{allObjs, existingObjs},
			allObjs = {
				Object[Container, Bench, "Test bench for populateWorkingSamples tests" <> $SessionUUID],

				Object[Instrument, PlateReader, "populateWorkingSamples test Pherastar" <> $SessionUUID],

				Object[Container, Plate, "Test plate 1 for populateWorkingSamples tests" <> $SessionUUID],
				Object[Container, Vessel, "Test 2 mL Tube 1 for populateWorkingSamples tests" <> $SessionUUID],
				Object[Container, Vessel, "Test 50 mL Tube 1 for populateWorkingSamples tests" <> $SessionUUID],

				Object[Sample, "populateWorkingSamples New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "populateWorkingSamples SamplesOut Chemical 1 (300 uL)" <> $SessionUUID],

				Object[Protocol, AbsorbanceSpectroscopy, "Test AbsSpec ParentProtocol for populateWorkingSamples" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Test Aliquot Subprotocol for populateWorkingSamples" <> $SessionUUID]
			};
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			ClearMemoization[];
		]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*simulateSamplesResourcePackets*)


DefineTests[simulateSamplesResourcePackets,
	{
		Example[{Basic,"Simulate sample preparation:"},
			simulateSamplesResourcePackets[ExperimentHPLC,{waterSample1,waterSample2},{Mix->{False,False},MixType->{Null,Null},MixUntilDissolved->{False,False},IncubationInstrument->{Model[Instrument,HeatBlock,"id:1ZA60vwjbDJ0"],Model[Instrument,HeatBlock,"id:1ZA60vwjbDJ0"]},IncubationTime->{Quantity[1,"Hours"],Quantity[1,"Hours"]},MaxIncubationTime->{Null,Null},IncubationTemperature->{Quantity[40,"DegreesCelsius"],Quantity[40,"DegreesCelsius"]},AnnealingTime->{Null,Null},IncubateAliquot->{Quantity[21.`,"Microliters"],Quantity[21.`,"Microliters"]},IncubateAliquotContainer->{{1,Model[Container,Vessel,"id:4pO6dM5WvJKM"]},{2,Model[Container,Vessel,"id:zGj91aR3ddXJ"]}},IncubateAliquotDestinationWell->{"A1","A1"},Incubate->{True,True},CentrifugeInstrument->{Model[Instrument,Centrifuge,"id:jLq9jXY4kGJx"],Model[Instrument,Centrifuge,"id:jLq9jXY4kGJx"]},CentrifugeIntensity->{Quantity[664.24`,"StandardAccelerationOfGravity"],Quantity[664.24`,"StandardAccelerationOfGravity"]},CentrifugeTemperature->{Ambient,Ambient},CentrifugeTime->{Quantity[5,"Minutes"],Quantity[5,"Minutes"]},CentrifugeAliquot->{Quantity[21.`,"Microliters"],Quantity[21.`,"Microliters"]},CentrifugeAliquotContainer->{{1,Model[Container,Vessel,"id:3em6Zv9NjjN8"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},CentrifugeAliquotDestinationWell->{"A1","A1"},Centrifuge->{True,True},FilterSterile->{False,False},FiltrationType->{Centrifuge,Centrifuge},FilterInstrument->{Model[Instrument,Centrifuge,"id:jLq9jXY4kGJx"],Model[Instrument,Centrifuge,"id:jLq9jXY4kGJx"]},FilterSyringe->{Null,Null},FilterPoreSize->{Quantity[0.22`,"Micrometers"],Quantity[0.22`,"Micrometers"]},PrefilterPoreSize->{Null,Null},FilterMaterial->{PES,PES},PrefilterMaterial->{Null,Null},Filter->{Model[Container,Vessel,Filter,"id:qdkmxzq0WNnm"],Model[Container,Vessel,Filter,"id:qdkmxzq0WNnm"]},FilterHousing->{Null,Null},FilterIntensity->{Quantity[2000,"StandardAccelerationOfGravity"],Quantity[2000,"StandardAccelerationOfGravity"]},FilterTime->{Quantity[5,"Minutes"],Quantity[5,"Minutes"]},FilterTemperature->{Quantity[22,"DegreesCelsius"],Quantity[22,"DegreesCelsius"]},FilterContainerOut->{{1,Model[Container,Vessel,Filter,"id:qdkmxzq0WNnm"]},{2,Model[Container,Vessel,Filter,"id:qdkmxzq0WNnm"]}},FilterAliquot->{Null,Null},FilterAliquotContainer->{Null,Null},FilterAliquotDestinationWell->{Null,Null},Filtration->{True,True}}],
			{
				{ObjectP[Object[Sample]],ObjectP[Object[Sample]]},
				{_Association..}
			}
		],
		Example[{Basic,"Simulate sample preparation through all sample prep stages:"},
			simulateSamplesResourcePackets[ExperimentHPLC,
				{waterSample1,waterSample2,waterSample1},
				{IncubateAliquot->{20Microliter,20Microliter,20Microliter},IncubateAliquotContainer->{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},FilterAliquot->{20Microliter,20Microliter,20Microliter},FilterAliquotContainer->{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},AssayVolume->{10Microliter,10Microliter,10Microliter},AliquotContainer->{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},Aliquot->{True,True,True}}
			],
			{
				{ObjectP[Object[Sample]],ObjectP[Object[Sample]],ObjectP[Object[Sample]]},
				{_Association..}
			}
		],
		Example[{Basic,"Simulate sample preparation through all sample prep stages, using pooled input:"},
			simulateSamplesResourcePackets[ExperimentUVMelting,
				{{waterSample1,waterSample2},waterSample1},
				{IncubateAliquot->{{20Microliter,20Microliter},20Microliter},IncubateAliquotContainer->{{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},CentrifugeAliquot->{{Null,Null},Null},CentrifugeAliquotContainer->{{Null,Null},Null},FilterAliquot->{{15Microliter,15Microliter},17Microliter},FilterAliquotContainer->{{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},AssayVolume->{{11Microliter,12Microliter},10Microliter},AliquotContainer->{{{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},{2,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},{3,Model[Container,Vessel,"id:3em6Zv9NjjN8"]}},Aliquot->{{True,True},True}}
			],
			{
				{{ObjectP[Object[Sample]],ObjectP[Object[Sample]]},ObjectP[Object[Sample]]},
				{_Association..}
			}
		],
		Example[{Additional,"Simulates the aliquot stage, if specified, for non-pooled functions:"},
			simulateSamplesResourcePackets[
				ExperimentAbsorbanceSpectroscopy,
				{waterSample1,waterSample2,waterSample1,waterSample1},
				{Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],Temperature->Ambient,EquilibrationTime->Quantity[0,"Minutes"],QuantifyConcentration->False,QuantificationWavelength->Null,NumberOfReplicates->Null,BlankAbsorbance->True,Blanks->{Model[Sample,"Dimethylformamide, Anhydrous"],Model[Sample,"Dimethylformamide, Anhydrous"],Model[Sample,"Dimethylformamide, Anhydrous"],Model[Sample,"Dimethylformamide, Anhydrous"]},BlankVolumes->{Quantity[300,"Microliters"],Quantity[300,"Microliters"],Quantity[300,"Microliters"],Quantity[300,"Microliters"]},PlateReaderMix->False,PlateReaderMixRate->Null,PlateReaderMixTime->Null,PlateReaderMixMode->Null,Confirm->False,ImageSample->False,MeasureWeight->True,MeasureVolume->True,Name->Null,Template->Null,SamplesInStorageCondition->{Null,Null,Null,Null},Cache->{},Email->True,FastTrack->False,Operator->Null,Output->Result,ParentProtocol->Null,Upload->False,Incubate->{False,False,False,False},IncubationTemperature->{Null,Null,Null,Null},IncubationTime->{Null,Null,Null,Null},Mix->{Null,Null,Null,Null},MixType->{Null,Null,Null,Null},MixUntilDissolved->{Null,Null,Null,Null},MaxIncubationTime->{Null,Null,Null,Null},IncubationInstrument->{Null,Null,Null,Null},AnnealingTime->{Null,Null,Null,Null},IncubateAliquotContainer->{Null,Null,Null,Null},IncubateAliquotDestinationWell->{Null,Null,Null,Null},IncubateAliquot->{Null,Null,Null,Null},Centrifuge->{False,False,False,False},CentrifugeInstrument->{Null,Null,Null,Null},CentrifugeIntensity->{Null,Null,Null,Null},CentrifugeTime->{Null,Null,Null,Null},CentrifugeTemperature->{Null,Null,Null,Null},CentrifugeAliquotContainer->{Null,Null,Null,Null},CentrifugeAliquotDestinationWell->{Null,Null,Null,Null},CentrifugeAliquot->{Null,Null,Null,Null},Filtration->{False,False,False,False},FiltrationType->{Null,Null,Null,Null},FilterInstrument->{Null,Null,Null,Null},Filter->{Null,Null,Null,Null},FilterMaterial->{Null,Null,Null,Null},PrefilterMaterial->{Null,Null,Null,Null},FilterPoreSize->{Null,Null,Null,Null},PrefilterPoreSize->{Null,Null,Null,Null},FilterSyringe->{Null,Null,Null,Null},FilterHousing->{Null,Null,Null,Null},FilterIntensity->{Null,Null,Null,Null},FilterTime->{Null,Null,Null,Null},FilterTemperature->{Null,Null,Null,Null},FilterContainerOut->{Null,Null,Null,Null},FilterAliquotDestinationWell->{Null,Null,Null,Null},FilterAliquotContainer->{Null,Null,Null,Null},FilterAliquot->{Null,Null,Null,Null},FilterSterile->{Null,Null,Null,Null},AliquotAmount->{Quantity[0.30000000000000004`,"Milliliters"],Quantity[0.30000000000000004`,"Milliliters"],Quantity[0.30000000000000004`,"Milliliters"],Quantity[0.30000000000000004`,"Milliliters"]},TargetConcentration->{Null,Null,Null,Null},AssayVolume->{Quantity[0.30000000000000004`,"Milliliters"],Quantity[0.30000000000000004`,"Milliliters"],Quantity[0.30000000000000004`,"Milliliters"],Quantity[0.30000000000000004`,"Milliliters"]},AliquotContainer->{{1,Model[Container,Plate,"96-well UV-Star Plate"]},{1,Model[Container,Plate,"96-well UV-Star Plate"]},{1,Model[Container,Plate,"96-well UV-Star Plate"]},{1,Model[Container,Plate,"96-well UV-Star Plate"]}},DestinationWell->{"A1","A2","A3","A4"},ConcentratedBuffer->{Null,Null,Null,Null},BufferDilutionFactor->{Null,Null,Null,Null},BufferDiluent->{Null,Null,Null,Null},AssayBuffer->{Null,Null,Null,Null},AliquotSampleStorageCondition->{Null,Null,Null,Null},Aliquot->{True,True,True,True},ConsolidateAliquots->False,AliquotPreparation->Robotic}
			],
			{
				{PatternUnion[ObjectP[Object[Sample]],Except[waterSample1]],PatternUnion[ObjectP[Object[Sample]],Except[waterSample2]],PatternUnion[ObjectP[Object[Sample]],Except[waterSample1]],PatternUnion[ObjectP[Object[Sample]],Except[waterSample1]]},
				{_Association..}
			}
		]
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4}=Upload[{
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:zGj91aR3ddXJ"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:zGj91aR3ddXJ"],Objects],DeveloperObject->True|>,
			<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],DeveloperObject->True|>
		}];

		(* Create some water samples *)
		{waterSample1,waterSample2,waterSample3,waterSample4}=ECL`InternalUpload`UploadSample[
			{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
			{{"A1",emptyContainer1},{"A1",emptyContainer2},{"A1",emptyContainer4},{"A2",emptyContainer4}},
			InitialAmount->{50 Milliliter,50 Milliliter,1 Milliliter,1 Milliliter}
		];

		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample1,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>,
			<|Object->waterSample3,DeveloperObject->True|>,
			<|Object->waterSample4,DeveloperObject->True|>,
			<|Object->emptyContainer1,DeveloperObject->True|>,
			<|Object->emptyContainer2,DeveloperObject->True|>,
			<|Object->emptyContainer3,DeveloperObject->True|>,
			<|Object->emptyContainer4,DeveloperObject->True|>
		}]
	),
	SymbolTearDown:>(
		EraseObject[$CreatedObjects, Force->True]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*resolvePostProcessingOptions *)


DefineTests[resolvePostProcessingOptions,
	{
		Example[{Basic,"Resolves any post processing options based on the root protocol's value:"},
			resolvePostProcessingOptions[{
				ImageSample->Automatic,
				MeasureVolume->Automatic,
				MeasureWeight->Automatic,
				ParentProtocol->Object[Protocol,ManualSamplePreparation,"resolvePostProcessingOptions test parent protocol"]
			}],
			{
				ImageSample->False,
				MeasureVolume->False,
				MeasureWeight->True
			}
		],
		Example[{Basic,"If there is no parent protocol (or no parent protocol option), Automatics will default to True:"},
			resolvePostProcessingOptions[{
				ImageSample->True,
				MeasureVolume->Automatic,
				MeasureWeight->False
			}],
			{
				ImageSample->True,
				MeasureVolume->True,
				MeasureWeight->False
			}
		],
		Example[{Options,Sterile,"If samples are expected to be Sterile, Automatics will default to False:"},
			resolvePostProcessingOptions[
				{
					ImageSample->False,
					MeasureVolume->Automatic,
					MeasureWeight->False
				},
				Sterile->True
			],
			{
				ImageSample->False,
				MeasureVolume->False,
				MeasureWeight->False
			}
		],
		Example[{Options,Living,"If samples are expected to be Living, Automatics will default to False:"},
			resolvePostProcessingOptions[
				{
					ImageSample->Automatic,
					MeasureVolume->False,
					MeasureWeight->False
				},
				Living->True
			],
			{
				ImageSample->False,
				MeasureVolume->False,
				MeasureWeight->False
			}
		],
		Example[{Messages,"Warning::PostProcessingSterileSamples","If samples are expected to be Sterile but there is post-processing option specified to be True, a warning will be thrown:"},
			resolvePostProcessingOptions[
				{
					ImageSample->True,
					MeasureVolume->False,
					MeasureWeight->False
				},
				Sterile->True
			],
			{
				ImageSample->True,
				MeasureVolume->False,
				MeasureWeight->False
			},
			Messages:>{Warning::PostProcessingSterileSamples}
		],
		Example[{Messages,"Error::PostProcessingLivingSamples","If samples are expected to be Living but there is post-processing option specified to be True, an error will be thrown:"},
			resolvePostProcessingOptions[
				{
					ImageSample->True,
					MeasureVolume->False,
					MeasureWeight->False
				},
				Living->True
			],
			{
				ImageSample->$Failed,
				MeasureVolume->False,
				MeasureWeight->False
			},
			Messages:>{Error::PostProcessingLivingSamples}
		],
		Example[{Messages,"Error::PostProcessingLivingSamples","If running in Engine and samples are expected to be Sterile while there is post-processing option specified to be True, no message will be thrown:"},
			Block[{$ECLApplication=Engine},
				resolvePostProcessingOptions[
					{
						ImageSample->True,
						MeasureVolume->False,
						MeasureWeight->False
					},
					Sterile->True
				]
			],
			{
				ImageSample->True,
				MeasureVolume->False,
				MeasureWeight->False
			}
		],
		Test["Works if the ParentProtocol is a qualification or a maintenance:",
			{
				resolvePostProcessingOptions[{
					ImageSample->Automatic,
					MeasureVolume->Automatic,
					MeasureWeight->Automatic,
					ParentProtocol->Object[Qualification,HPLC,"resolvePostProcessingOptions test qualification"]
				}],
				resolvePostProcessingOptions[{
					ImageSample->Automatic,
					MeasureVolume->Automatic,
					MeasureWeight->Automatic,
					ParentProtocol->Object[Maintenance,Clean,OperatorCart,"resolvePostProcessingOptions test maintenance"]
				}]
			},
			{
				{ImageSample->True,MeasureVolume->True,MeasureWeight->True},
				{ImageSample->True,MeasureVolume->True,MeasureWeight->True}
			}
		],
		Test["Handles the case where the parent protocol is the root:",
			resolvePostProcessingOptions[{
				ImageSample->Automatic,
				MeasureVolume->Automatic,
				MeasureWeight->Automatic,
				ParentProtocol->Object[Protocol,HPLC,"resolvePostProcessingOptions test root protocol"]
			}],
			{
				ImageSample->False,
				MeasureVolume->False,
				MeasureWeight->True
			}
		],
		Test["If a post-processing option is not supplied, it will not be returned:",
			resolvePostProcessingOptions[{
				ImageSample->Automatic,
				MeasureVolume->Automatic,
				MeasureWeight->Automatic,
				ParentProtocol->Object[Protocol,HPLC,"resolvePostProcessingOptions test root protocol"]
			}],
			{
				ImageSample->False,
				MeasureVolume->False,
				MeasureWeight->True
			}
		]
	},
	SymbolSetUp:>Module[{hplcProtocol},
		$CreatedObjects={};
		hplcProtocol=CreateID[Object[Protocol,HPLC]];
		Upload[{
			<|
				Object->hplcProtocol,
				Name->"resolvePostProcessingOptions test root protocol",
				ImageSample->False,
				MeasureVolume->False,
				MeasureWeight->True
			|>,
			<|
				Type->Object[Protocol,ManualSamplePreparation],
				Name->"resolvePostProcessingOptions test parent protocol",
				ParentProtocol->Link[hplcProtocol,Subprotocols],
				ImageSample->True,
				MeasureVolume->True,
				MeasureWeight->False
			|>,
			<|
				Type->Object[Maintenance,Clean,OperatorCart],
				Name->"resolvePostProcessingOptions test maintenance"
			|>,
			<|
				Type->Object[Qualification,HPLC],
				Name->"resolvePostProcessingOptions test qualification"
			|>
		}]
	],
	SymbolTearDown:>{
		EraseObject[$CreatedObjects,Force->True,Verbose->False]
	}
];


(* ::Subsection::Closed:: *)
(*populatePreparedSamples*)


DefineTests[populatePreparedSamples,
	{
		Example[{Basic,"Simulate sample preparation for two inputs that are both simulated:"},
			{samplesIn,containersIn,workingSamples,workingContainers}=Download[populatePreparedSamples[Object[Protocol,Incubate,"Fake incubate protocol 1 for populatePreparedSamples tests" <> $SessionUUID]],{SamplesIn,ContainersIn,WorkingSamples,WorkingContainers}];

			And[
				MatchQ[{samplesIn,containersIn,workingSamples,workingContainers},
					{
						{ObjectP[Object[Sample]]..},
						{ObjectP[Object[Container]]..},
						{ObjectP[Object[Sample]]..},
						{ObjectP[Object[Container]]..}
					}
				],
				MatchQ[Download[samplesIn,Object],Download[workingSamples,Object]],
				MatchQ[Download[containersIn,Object],Download[workingContainers,Object]]
			],
			True,
			Variables:>{samplesIn,containersIn,workingSamples,workingContainers}
		],
		Example[{Basic,"Simulate sample preparation for inputs that are a combination of simulated a non-simulated:"},
			{samplesIn,containersIn,workingSamples,workingContainers}=Download[populatePreparedSamples[Object[Protocol,Incubate,"Fake incubate protocol 2 for populatePreparedSamples tests" <> $SessionUUID]],{SamplesIn,ContainersIn,WorkingSamples,WorkingContainers}];

			And[
				MatchQ[{samplesIn,containersIn,workingSamples,workingContainers},
					{
						{ObjectP[Object[Sample]]..},
						{ObjectP[Object[Container]]..},
						{ObjectP[Object[Sample]]..},
						{ObjectP[Object[Container]]..}
					}
				],
				MatchQ[Download[samplesIn,Object],Download[workingSamples,Object]],
				MatchQ[Download[containersIn,Object],Download[workingContainers,Object]]
			],
			True,
			Variables:>{samplesIn,containersIn,workingSamples,workingContainers}
		],
		Example[{Additional,"","Update NestedIndexMatchingSamplesIn when we can:"},
			Download[
				populatePreparedSamples[Object[Protocol,ImageCells,"Test image cells protocol 1 for populatePreparedSamples tests" <> $SessionUUID]],
				NestedIndexMatchingSamplesIn
			],
			{{ObjectReferenceP[]}}
		]
		(* TODO: Add more tests once define correctly points at a sample and not a container. Right now, our tests are limited to preparing inputs. *)
	},
	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{namedObjects},
			(* Erase any objects that exist. *)
			namedObjects={
				Object[Container,Vessel,"Test container 1 for populatePreparedSamples" <> $SessionUUID],
				Object[Container,Vessel,"Test container 2 for populatePreparedSamples" <> $SessionUUID],
				Object[Container,Vessel,"Test container 3 for populatePreparedSamples" <> $SessionUUID],
				Object[Container,Vessel,"Test container 4 for populatePreparedSamples" <> $SessionUUID],
				Object[Sample,"Test sample 1 for populatePreparedSamples" <> $SessionUUID],
				Object[Sample,"Test sample 2 for populatePreparedSamples" <> $SessionUUID],
				Object[Sample,"Test sample 3 for populatePreparedSamples" <> $SessionUUID],
				Object[Sample,"Test sample 4 for populatePreparedSamples" <> $SessionUUID],
				Object[Protocol,Incubate,"Fake incubate protocol 1 for populatePreparedSamples tests" <> $SessionUUID],
				Object[Protocol,Incubate,"Fake incubate protocol 2 for populatePreparedSamples tests" <> $SessionUUID],
				Object[Protocol,ImageCells,"Test image cells protocol 1 for populatePreparedSamples tests" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			];
		];

		Module[{
			emptyContainer1,emptyContainer2,emptyContainer3,sample1,sample2,sample3,incubateProtocol1,
			incubateProtocol2,samplePreparationProtocol,emptyContainer4,sample4
			,imageCellsProtocol1},

			(* Create our container with a sample in it. *)
			{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4}=Upload[{
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 1 for populatePreparedSamples" <> $SessionUUID,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 2 for populatePreparedSamples" <> $SessionUUID,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 3 for populatePreparedSamples" <> $SessionUUID,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>,
				<|
					Type->Object[Container,Vessel],
					Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
					Name->"Test container 4 for populatePreparedSamples" <> $SessionUUID,
					DeveloperObject->True,
					Site -> Link[$Site]
				|>
			}];

			(* Create our sample. *)
			{sample1,sample2,sample3,sample4}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"]
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3},
					{"A1",emptyContainer4}
				},
				InitialAmount->{49 Milliliter,49 Milliliter,49 Milliliter,49 Milliliter},
				Name->{
					"Test sample 1 for populatePreparedSamples" <> $SessionUUID,
					"Test sample 2 for populatePreparedSamples" <> $SessionUUID,
					"Test sample 3 for populatePreparedSamples" <> $SessionUUID,
					"Test sample 4 for populatePreparedSamples" <> $SessionUUID
				}
			];

			(* Create an incubation protocol. *)
			(* Quiet because we have some fields missing from cache right now. *)
			(* SM should put our sample in position "A1". *)
			incubateProtocol1=Quiet[
				ExperimentIncubate[
					{"my container","my sample"},
					PreparatoryUnitOperations->{
						LabelContainer[Label->"my container",Container->Model[Container,Vessel,"50mL Tube"]],
						Transfer[Source->Model[Sample,"Methanol"],Amount->10 Milliliter,Destination->"my container",DestinationLabel->"destination sample"],
						LabelSample[Label->"my sample",Sample->sample2]
					}
				]
			];

			incubateProtocol2=Quiet[
				ExperimentIncubate[
					{sample1,"my container","my sample"},
					PreparatoryUnitOperations->{
						LabelContainer[Label->"my container",Container->Model[Container,Vessel,"50mL Tube"]],
						Transfer[Source->Model[Sample,"Methanol"],Amount->10 Milliliter,Destination->"my container",DestinationLabel->"destination sample"],
						LabelSample[Label->"my sample",Sample->sample2]
					}
				]
			];

			imageCellsProtocol1=Quiet[
				ExperimentImageCells[
					"my sample",
					PreparatoryUnitOperations->{ManualSamplePreparation[ECL`LabelSample[<|ECL`Sample -> {ECL`Model[ECL`Sample, "id:O81aEBZnWMRO"]}, ECL`Sterile -> {True}, ECL`Amount -> {Quantity[1, "Milliliters"]}, ECL`Container -> {ECL`Model[ECL`Container, ECL`Plate, "id:eGakld01zzLx"]}, Label -> {"my sample"}|>]]},
					SamplingPattern->Grid,
					SamplingNumberOfRows->4,
					SamplingNumberOfColumns->4
				]
			];

			(* Create a sample manipulation protocol with DefinedObjects of "my container". *)
			samplePreparationProtocol=Upload[<|
				Type->Object[Protocol,ManualSamplePreparation],
				Replace[LabeledObjects]->{
					{"my container",Link[emptyContainer1]},
					{"my sample",Link[sample2]},
					{"destination sample", Link[sample3]}
				}
			|>];

			(* Add our SM as a subprotocol to our incubate protocol. *)
			Upload[{
				<|
					Object->incubateProtocol1,
					Name->"Fake incubate protocol 1 for populatePreparedSamples tests" <> $SessionUUID,
					Append[SamplePreparationProtocols]->Link[samplePreparationProtocol]
				|>,
				<|
					Object->incubateProtocol2,
					Name->"Fake incubate protocol 2 for populatePreparedSamples tests" <> $SessionUUID,
					Append[SamplePreparationProtocols]->Link[samplePreparationProtocol]
				|>,
				<|
					Object->imageCellsProtocol1,
					Name->"Test image cells protocol 1 for populatePreparedSamples tests" <> $SessionUUID,
					Append[SamplePreparationProtocols]->Link[samplePreparationProtocol]
				|>

			}];

			(* Make all of the objects created developer objects *)
			Upload[<|Object->#,DeveloperObject->True|> &/@$CreatedObjects];
		]
	),
	SymbolTearDown:>(
		EraseObject[
			PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects]],
			Force->True,
			Verbose->False
		];

		(* clear $CreatedObjects *)
		Unset[$CreatedObjects]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];



(* ::Subsection::Closed:: *)
(*fastAssocLookup*)


DefineTests[fastAssocLookup,
	{
		Example[{Basic, "Lookup a single field from the cache:"},
			packets = Download[Object[Sample, "fastAssocLookup test sample 1"<> $SessionUUID], {Packet[Model]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocLookup[fastPackets, Object[Sample, "fastAssocLookup test sample 1"<> $SessionUUID], Model],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{packets, fastPackets}
		],
		Example[{Basic, "Lookup through links from the cache:"},
			packets = Download[Object[Sample, "fastAssocLookup test sample 1"<> $SessionUUID], {Packet[Model], Packet[Model[{Name}]]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocLookup[fastPackets, Object[Sample, "fastAssocLookup test sample 1"<> $SessionUUID], {Model, Name}],
			"Milli-Q water",
			Variables:>{packets, fastPackets}
		],
		Test["When the expected packet is not found, return $Failed:",
			packets = Download[Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Packet[Model]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocLookup[fastPackets, Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Model, Name}],
			$Failed,
			Variables:>{packets, fastPackets}
		],
		Test["If asked to navigate through a non link field, Return $Failed:",
			packets = Download[Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Packet[Model], Packet[Model[{Name}]]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocLookup[fastPackets, Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Name, Name}],
			$Failed,
			Variables:>{packets, fastPackets}
		],
		Test["If the expected field is not present in the packet, Return $Failed:",
			packets = Download[Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Packet[Product], Packet[Model[{Name}]]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocLookup[fastPackets, Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Model, Name}],
			$Failed,
			Variables:>{packets, fastPackets}
		],
		Test["If we're going through links through a multiple field, properly go through the links:",
			packets = Download[Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Packet[Analytes], Packet[Analytes[{Name}]]}];
			fastPackets = makeFastAssocFromCache[Flatten[packets]];
			fastAssocLookup[fastPackets, Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Analytes, Name}],
			{"Water", "Ethanol"},
			Variables:>{packets, fastPackets}
		],
		Test["One can specify the part spec for any multiple fields using the Field[fieldName[[n]]] notation:",
			packets = Download[Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Packet[Analytes], Packet[Analytes[{Name}]]}];
			fastPackets = makeFastAssocFromCache[Flatten[packets]];
			fastAssocLookup[fastPackets, Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Field[Analytes[[1]]], Name}],
			"Water",
			Variables:>{packets, fastPackets}
		],
		Test["One can specify the part spec for any multiple fields using the Field[fieldName[[n]]] notation at any complexity:",
			packets = Download[Object[Container, Vessel, "fastAssocLookup test container 2" <> $SessionUUID], {Packet[Contents[[All, 2]][Analytes]], Packet[Contents[[All, 2]][Analytes][Name]], Packet[Contents]}];
			fastPackets = makeFastAssocFromCache[Flatten[packets]];
			fastAssocLookup[fastPackets, Object[Container, Vessel, "fastAssocLookup test container 2" <> $SessionUUID], {Field[Contents[[All, 2]]], Field[Analytes[[1]]], Name}],
			{"Water"},
			Variables:>{packets, fastPackets}
		],
		Test["Function supports Repeated[field name] notation to go through certain link field repeatedly:",
			packets = Download[Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Packet[Container, Name], Packet[Container[Container, Name]], Packet[Container[Container][Container, Name]]}];
			fastPackets = makeFastAssocFromCache[Flatten[packets]];
			fastAssocLookup[fastPackets, Object[Sample, "fastAssocLookup test sample 2"<> $SessionUUID], {Repeated[Container], Name}],
			{"fastAssocLookup test container 2" <> $SessionUUID, "Bench for fastAssocLookup tests" <> $SessionUUID},
			Variables:>{packets, fastPackets}
		],
		Test["Function supports more complicated Repeated[Field[fieldName[[part]]]] notation to repeatedly go through liked fields:",
			packets = Quiet[Download[Object[Container, Bench, "Bench for fastAssocLookup tests" <> $SessionUUID], {Packet[Contents, Name], Packet[Repeated[Contents[[All, 2]]][Contents, Name]]}]];
			fastPackets = makeFastAssocFromCache[DeleteCases[Flatten[packets], $Failed]];
			fastAssocLookup[fastPackets, Object[Container, Bench, "Bench for fastAssocLookup tests" <> $SessionUUID], {Repeated[Field[Contents[[1, 2]]]], Name}],
			{"fastAssocLookup test container 1" <> $SessionUUID, "fastAssocLookup test sample 1" <> $SessionUUID},
			Variables:>{packets, fastPackets}
		]
	},

	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for fastAssocLookup tests" <> $SessionUUID],
					Object[Container, Vessel, "fastAssocLookup test container 1" <> $SessionUUID],
					Object[Container, Vessel, "fastAssocLookup test container 2" <> $SessionUUID],
					Object[Sample, "fastAssocLookup test sample 1" <> $SessionUUID],
					Object[Sample, "fastAssocLookup test sample 2" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		Block[{$AllowSystemsProtocols = True},
			Module[
				{fakeBench, container, container2, sample, sample2},

				fakeBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Bench for fastAssocLookup tests" <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up containers *)
				{
					container,
					container2
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> Available,
					Name -> {
						"fastAssocLookup test container 1" <> $SessionUUID,
						"fastAssocLookup test container 2" <> $SessionUUID
					}
				];

				(*set up samples*)
				{
					sample,
					sample2
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, StockSolution, "70% Ethanol"]
					},
					{
						{"A1", container},
						{"A1", container2}
					},
					InitialAmount -> {
						1 Milliliter,
						1 Milliliter
					},
					Name -> {
						"fastAssocLookup test sample 1" <> $SessionUUID,
						"fastAssocLookup test sample 2" <> $SessionUUID
					}
				];

				Upload[Flatten[{
					<|
						Object -> sample2,
						Replace[Analytes] -> {
							Link[Model[Molecule, "Water"]],
							Link[Model[Molecule, "Ethanol"]]
						}
					|>,
					<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container, container2, sample, sample2}], ObjectP[]]
				}]];
			]
		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for fastAssocLookup tests" <> $SessionUUID],
					Object[Container, Vessel, "fastAssocLookup test container 1" <> $SessionUUID],
					Object[Container, Vessel, "fastAssocLookup test container 2" <> $SessionUUID],
					Object[Sample, "fastAssocLookup test sample 1" <> $SessionUUID],
					Object[Sample, "fastAssocLookup test sample 2" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection::Closed:: *)
(*fetchPacketFromFastAssoc*)

DefineTests[fetchPacketFromFastAssoc,
	{
		Test["Function fetches packet from fastAssoc:",
			pacs = Download[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}];
			fastPacs = makeFastAssocFromCache[Flatten[pacs]];
			fetchPacketFromFastAssoc[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], fastPacs],
			PacketP[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID]],
			Variables:>{fastPacs, pacs}
		],
		Test["If packets are not available from fastAssoc, return {}:",
			pacs = Download[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}];
			fastPacs = makeFastAssocFromCache[Flatten[pacs]];
			fetchPacketFromFastAssoc[Object[Container, Vessel, "fetchPacketFromFastAssoc test container 1" <> $SessionUUID], fastPacs],
			{},
			Variables:>{fastPacs, pacs}
		],
		Test["Function allows the third input Packet[fields...], in which case only fields specified will appear in the output packet:",
			pacs = Download[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}];
			fastPacs = makeFastAssocFromCache[Flatten[pacs]];
			fetchPacketFromFastAssoc[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], fastPacs, Packet[Container, Status, Name]],
			AssociationMatchP[<|
				Object -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object],
				Type -> Object[Sample],
				ID -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], ID],
				Name -> "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID,
				Status -> Available,
				Container -> LinkP[Object[Container, Vessel, "fetchPacketFromFastAssoc test container 1" <> $SessionUUID]]
			|>],
			Variables:>{fastPacs, pacs}
		],
		Test["When the third input is provided, Object, Type, ID, Name fields will always present in the packet:",
			pacs = Download[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}];
			fastPacs = makeFastAssocFromCache[Flatten[pacs]];
			fetchPacketFromFastAssoc[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], fastPacs, Packet[Status]],
			AssociationMatchP[<|
				Object -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object],
				Type -> Object[Sample],
				ID -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], ID],
				Name -> "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID,
				Status -> Available
			|>],
			Variables:>{fastPacs, pacs}
		],
		Test["When the third input is provided, any fields not found in the full packet defaults to $Failed:",
			pacs = Download[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}];
			fastPacs = makeFastAssocFromCache[Flatten[pacs]];
			fetchPacketFromFastAssoc[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], fastPacs, Packet[Contents]],
			AssociationMatchP[<|
				Object -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object],
				Type -> Object[Sample],
				ID -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], ID],
				Name -> "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID,
				Contents -> $Failed
			|>],
			Variables:>{fastPacs, pacs}
		],
		Test["When the third input is provided, a forth input can also be specified to indicate the default value of fields if it's not found:",
			pacs = Download[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}];
			fastPacs = makeFastAssocFromCache[Flatten[pacs]];
			fetchPacketFromFastAssoc[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], fastPacs, Packet[Contents], Null],
			AssociationMatchP[<|
				Object -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object],
				Type -> Object[Sample],
				ID -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], ID],
				Name -> "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID,
				Contents -> Null
			|>],
			Variables:>{fastPacs, pacs}
		],
		Test["Function works on a list of objects:",
			pacs = Download[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}];
			fastPacs = makeFastAssocFromCache[Flatten[pacs]];
			fetchPacketFromFastAssoc[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}, fastPacs],
			{PacketP[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID]], PacketP[Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]]},
			Variables:>{fastPacs, pacs}
		],
		Test["Function works on a list of objects with 3 entries:",
			pacs = Download[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}];
			fastPacs = makeFastAssocFromCache[Flatten[pacs]];
			fetchPacketFromFastAssoc[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}, fastPacs, Packet[Status, Contents]],
			{
				AssociationMatchP[<|
					Object -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object],
					Type -> Object[Sample],
					ID -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], ID],
					Name -> "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID,
					Contents -> $Failed,
					Status -> Available
				|>],
				AssociationMatchP[<|
					Object -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID], Object],
					Type -> Object[Sample],
					ID -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID], ID],
					Name -> "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID,
					Contents -> $Failed,
					Status -> Available
				|>]
			},
			Variables:>{fastPacs, pacs}
		],
		Test["Function works on a list of objects with 4 entries:",
			pacs = Download[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}];
			fastPacs = makeFastAssocFromCache[Flatten[pacs]];
			fetchPacketFromFastAssoc[{Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]}, fastPacs, Packet[Status, Contents], Null],
			{
				AssociationMatchP[<|
					Object -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], Object],
					Type -> Object[Sample],
					ID -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID], ID],
					Name -> "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID,
					Contents -> Null,
					Status -> Available
				|>],
				AssociationMatchP[<|
					Object -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID], Object],
					Type -> Object[Sample],
					ID -> Download[Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID], ID],
					Name -> "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID,
					Contents -> Null,
					Status -> Available
				|>]
			},
			Variables:>{fastPacs, pacs}
		]
	},
	SymbolSetUp :> {
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for fetchPacketFromFastAssoc tests" <> $SessionUUID],
					Object[Container, Vessel, "fetchPacketFromFastAssoc test container 1" <> $SessionUUID],
					Object[Container, Vessel, "fetchPacketFromFastAssoc test container 2" <> $SessionUUID],
					Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID],
					Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[
			{fakeBench, container, container2, sample, sample2},

			fakeBench = Upload[
				<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Bench for fetchPacketFromFastAssoc tests" <> $SessionUUID,
					DeveloperObject -> True,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
				|>
			];

			(* set up containers *)
			{
				container,
				container2
			} = UploadSample[
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					{"Work Surface", fakeBench},
					{"Work Surface", fakeBench}
				},
				Status -> Available,
				Name -> {
					"fetchPacketFromFastAssoc test container 1" <> $SessionUUID,
					"fetchPacketFromFastAssoc test container 2" <> $SessionUUID
				}
			];

			(*set up samples*)
			{
				sample,
				sample2
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, StockSolution, "70% Ethanol"]
				},
				{
					{"A1", container},
					{"A1", container2}
				},
				InitialAmount -> {
					1 Milliliter,
					1 Milliliter
				},
				Name -> {
					"fetchPacketFromFastAssoc test sample 1" <> $SessionUUID,
					"fetchPacketFromFastAssoc test sample 2" <> $SessionUUID
				}
			];

			Upload[Flatten[{
				<|
					Object -> sample2,
					Replace[Analytes] -> {
						Link[Model[Molecule, "Water"]],
						Link[Model[Molecule, "Ethanol"]]
					}
				|>,
				<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container, container2, sample, sample2}], ObjectP[]]
			}]];
		]
	},
	SymbolTearDown :> Module[{objs, existingObjs},
		objs = Quiet[Cases[
			Flatten[{
				Object[Container, Bench, "Bench for fetchPacketFromFastAssoc tests" <> $SessionUUID],
				Object[Container, Vessel, "fetchPacketFromFastAssoc test container 1" <> $SessionUUID],
				Object[Container, Vessel, "fetchPacketFromFastAssoc test container 2" <> $SessionUUID],
				Object[Sample, "fetchPacketFromFastAssoc test sample 1" <> $SessionUUID],
				Object[Sample, "fetchPacketFromFastAssoc test sample 2" <> $SessionUUID]
			}],
			ObjectP[]
		]];
		existingObjs = PickList[objs, DatabaseMemberQ[objs]];
		EraseObject[existingObjs, Force -> True, Verbose -> False]
	]
];


(* ::Subsection::Closed:: *)
(*fastAssocPacketLookup*)


DefineTests[fastAssocPacketLookup,
	{
		Example[{Basic, "Lookup a single field from the cache:"},
			packets = Download[Object[Sample, "fastAssocPacketLookup test sample 1"<> $SessionUUID], {Packet[Model], Packet[Model[All]]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocPacketLookup[fastPackets, Object[Sample, "fastAssocPacketLookup test sample 1"<> $SessionUUID], Model],
			PacketP[Model[Sample, "Milli-Q water"]],
			Variables:>{packets, fastPackets}
		],
		Example[{Basic, "If looking up something that isn't acutally an object, return the thing we were looking up:"},
			packets = Download[Object[Sample, "fastAssocPacketLookup test sample 1"<> $SessionUUID], {Packet[Model], Packet[Model[{Name}]]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocPacketLookup[fastPackets, Object[Sample, "fastAssocPacketLookup test sample 1"<> $SessionUUID], {Model, Name}],
			"Milli-Q water",
			Variables:>{packets, fastPackets}
		],
		Test["When the expected packet is not found, return {} like fetchPacketFromFastAssoc:",
			packets = Download[Object[Sample, "fastAssocPacketLookup test sample 2"<> $SessionUUID], {Packet[Model]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocPacketLookup[fastPackets, Object[Sample, "fastAssocPacketLookup test sample 2"<> $SessionUUID], Model],
			{},
			Variables:>{packets, fastPackets}
		],
		Test["If asked to navigate through a non link field, Return $Failed:",
			packets = Download[Object[Sample, "fastAssocPacketLookup test sample 2"<> $SessionUUID], {Packet[Model], Packet[Model[{Name}]]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocPacketLookup[fastPackets, Object[Sample, "fastAssocPacketLookup test sample 2"<> $SessionUUID], {Name, Name}],
			$Failed,
			Variables:>{packets, fastPackets}
		],
		Test["If the expected field is not present in the packet, Return $Failed:",
			packets = Download[Object[Sample, "fastAssocPacketLookup test sample 2"<> $SessionUUID], {Packet[Product], Packet[Model[{Name}]]}];
			fastPackets = makeFastAssocFromCache[packets];
			fastAssocPacketLookup[fastPackets, Object[Sample, "fastAssocPacketLookup test sample 2"<> $SessionUUID], {Model, Name}],
			$Failed,
			Variables:>{packets, fastPackets}
		],
		Test["If we're going through links through a multiple field, properly go through the links:",
			packets = Download[Object[Sample, "fastAssocPacketLookup test sample 2"<> $SessionUUID], {Packet[Analytes], Packet[Analytes[{Name}]]}];
			fastPackets = makeFastAssocFromCache[Flatten[packets]];
			fastAssocPacketLookup[fastPackets, Object[Sample, "fastAssocPacketLookup test sample 2"<> $SessionUUID], Analytes],
			{PacketP[], PacketP[]},
			Variables:>{packets, fastPackets}
		]
	},

	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for fastAssocPacketLookup tests" <> $SessionUUID],
					Object[Container, Vessel, "fastAssocPacketLookup test container 1" <> $SessionUUID],
					Object[Container, Vessel, "fastAssocPacketLookup test container 2" <> $SessionUUID],
					Object[Sample, "fastAssocPacketLookup test sample 1" <> $SessionUUID],
					Object[Sample, "fastAssocPacketLookup test sample 2" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		Block[{$AllowSystemsProtocols = True},
			Module[
				{fakeBench, container, container2, sample, sample2},

				fakeBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Bench for fastAssocPacketLookup tests" <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up containers *)
				{
					container,
					container2
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> Available,
					Name -> {
						"fastAssocPacketLookup test container 1" <> $SessionUUID,
						"fastAssocPacketLookup test container 2" <> $SessionUUID
					}
				];

				(*set up samples*)
				{
					sample,
					sample2
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, StockSolution, "70% Ethanol"]
					},
					{
						{"A1", container},
						{"A1", container2}
					},
					InitialAmount -> {
						1 Milliliter,
						1 Milliliter
					},
					Name -> {
						"fastAssocPacketLookup test sample 1" <> $SessionUUID,
						"fastAssocPacketLookup test sample 2" <> $SessionUUID
					}
				];

				Upload[Flatten[{
					<|
						Object -> sample2,
						Replace[Analytes] -> {
							Link[Model[Molecule, "Water"]],
							Link[Model[Molecule, "Ethanol"]]
						}
					|>,
					<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container, container2, sample, sample2}], ObjectP[]]
				}]];
			]
		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for fastAssocPacketLookup tests" <> $SessionUUID],
					Object[Container, Vessel, "fastAssocPacketLookup test container 1" <> $SessionUUID],
					Object[Container, Vessel, "fastAssocPacketLookup test container 2" <> $SessionUUID],
					Object[Sample, "fastAssocPacketLookup test sample 1" <> $SessionUUID],
					Object[Sample, "fastAssocPacketLookup test sample 2" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*repeatedFastAssocLookup*)


DefineTests[repeatedFastAssocLookup,
	{
		Example[{Basic, "Look up a field recursively up:"},
			packets = Download[Object[Sample, "repeatedFastAssocLookup test sample 1"<> $SessionUUID], {Packet[Container], Packet[Container[Container]], Packet[Container[Container][Container]]}];
			fastPackets = makeFastAssocFromCache[packets];
			repeatedFastAssocLookup[fastPackets, Object[Sample, "repeatedFastAssocLookup test sample 1"<> $SessionUUID], Container],
			{ObjectP[Object[Container]], ObjectP[Object[Container]]},
			Variables:>{packets, fastPackets}
		],
		Example[{Basic, "If we've got nothing going recursively up then return {}:"},
			packets = Download[Object[Sample, "repeatedFastAssocLookup test sample 1"<> $SessionUUID], {Packet[Container], Packet[Container[Container]], Packet[Container[Container][Container]]}];
			fastPackets = makeFastAssocFromCache[packets];
			repeatedFastAssocLookup[fastPackets, Object[Container, Bench, "Bench for repeatedFastAssocLookup tests" <> $SessionUUID], Container],
			{},
			Variables:>{packets, fastPackets}
		],
		Example[{Messages, "RecursionTerminated", "If we get caught in an infinite loop, then terminate and throw an error:"},
			packets = Download[Object[Sample, "repeatedFastAssocLookup test sample 2" <> $SessionUUID], {Packet[Container], Packet[Container[Container]]}];
			fastPackets = makeFastAssocFromCache[packets];
			repeatedFastAssocLookup[fastPackets, Object[Sample, "repeatedFastAssocLookup test sample 2" <> $SessionUUID], Container],
			{ObjectP[Object[Container]]..},
			Messages :> {repeatedFastAssocLookup::RecursionTerminated},
			Variables:>{packets, fastPackets}
		]
	},

	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for repeatedFastAssocLookup tests" <> $SessionUUID],
					Object[Container, Vessel, "repeatedFastAssocLookup test container 1" <> $SessionUUID],
					Object[Container, Vessel, "repeatedFastAssocLookup test container 2" <> $SessionUUID],
					Object[Sample, "repeatedFastAssocLookup test sample 1" <> $SessionUUID],
					Object[Sample, "repeatedFastAssocLookup test sample 2" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];

		Block[{$AllowSystemsProtocols = True},
			Module[
				{fakeBench, container, container2, sample, sample2},

				fakeBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Bench for repeatedFastAssocLookup tests" <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]
					|>
				];

				(* set up containers *)
				{
					container,
					container2
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Status -> Available,
					Name -> {
						"repeatedFastAssocLookup test container 1" <> $SessionUUID,
						"repeatedFastAssocLookup test container 2" <> $SessionUUID
					}
				];

				(*set up samples*)
				{
					sample,
					sample2
				} = UploadSample[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, StockSolution, "70% Ethanol"]
					},
					{
						{"A1", container},
						{"A1", container2}
					},
					InitialAmount -> {
						1 Milliliter,
						1 Milliliter
					},
					Name -> {
						"repeatedFastAssocLookup test sample 1" <> $SessionUUID,
						"repeatedFastAssocLookup test sample 2" <> $SessionUUID
					}
				];

				Upload[Flatten[{
					<|
						Object -> sample2,
						Replace[Analytes] -> {
							Link[Model[Molecule, "Water"]],
							Link[Model[Molecule, "Ethanol"]]
						}
					|>,
					<|Object -> #, DeveloperObject -> True|> & /@ Cases[Flatten[{container, container2, sample, sample2}], ObjectP[]],
					<|
						Object -> container2,
						Container -> Link[container2, Contents, 2]
					|>
				}]];
			]
		]
	),
	SymbolTearDown :> (
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Bench for repeatedFastAssocLookup tests" <> $SessionUUID],
					Object[Container, Vessel, "repeatedFastAssocLookup test container 1" <> $SessionUUID],
					Object[Container, Vessel, "repeatedFastAssocLookup test container 2" <> $SessionUUID],
					Object[Sample, "repeatedFastAssocLookup test sample 1" <> $SessionUUID],
					Object[Sample, "repeatedFastAssocLookup test sample 2" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsubsection::Closed:: *)
(*SamplePreparationCacheFields*)


DefineTests[
	SamplePreparationCacheFields,
	{
		Example[{Basic, "SamplePreparationCacheFields returns the fields associated with an Object[Sample] input:"},
			SamplePreparationCacheFields[Object[Sample]],
			{
				Object, Type, Name, State, BiosafetyLevel, CellType, CultureAdhesion, SampleHandling, Composition,
				Analytes, Solvent, MassConcentration, Concentration, Volume, Mass, Count, Status, Model, Position,
				Container, Living, Sterile, StorageCondition, MeltingPoint, ThawTime, ThawTemperature, MaxThawTime, ThawMixType,
				ThawMixRate, ThawMixTime, ThawNumberOfMixes, TransportTemperature, Tablet, Sachet, SolidUnitWeight,
				LiquidHandlerIncompatible, Site, RequestedResources, Conductivity, IncompatibleMaterials, pH, KitComponents,
				AsepticHandling, Density, Fuming, InertHandling, ParticleWeight, PipettingMethod, Pyrophoric,
				ReversePipetting, RNaseFree, TransferTemperature, TransportCondition, Ventilated, Well, SurfaceTension,
				AluminumFoil, Parafilm, Anhydrous, ExtinctionCoefficients, Notebook, Flammable
			}
		],
		Example[{Basic, "SamplePreparationCacheFields returns the fields associated with a Model[Sample] input:"},
			SamplePreparationCacheFields[Model[Sample]],
			{
				Conductivity, IncompatibleMaterials, pH, KitComponents, RequestedResources, Products, KitProducts, MixedBatchProducts,
				MaxThawTime, Solvent, SampleHandling, CellType, CultureAdhesion, BiosafetyLevel, Composition, Analytes, TransportTemperature,
				Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, Sachet, SolidUnitWeight, State, MolecularWeight, MeltingPoint,
				ThawTime, ThawTemperature, Dimensions, ExtinctionCoefficients, UsedAsSolvent, AsepticHandling, Density, Fuming, InertHandling,
				ParticleWeight, PipettingMethod, Pyrophoric, ReversePipetting, RNaseFree, TransferTemperature, TransportCondition, Ventilated, SurfaceTension,
				Parafilm, AluminumFoil, Living, Flammable
			}
		],
		Example[{Basic, "SamplePreparationCacheFields returns the fields associated with an Object[Container] input:"},
			SamplePreparationCacheFields[Object[Container]],
			{
				Type, Object, Name, Status, Model, Container, Contents, Container, Sterile, TareWeight, StorageCondition, RequestedResources, KitComponents, Site,
				Ampoule, Hermetic, MaxTemperature, MaxVolume, MinTemperature, Opaque, RNaseFree, Squeezable, InertHandling, AsepticHandling,
				ParticleWeight, PipettingMethod, Pyrophoric, ReversePipetting, TransferTemperature, TransportCondition, Ventilated,
				PreviousCover, Cover, Septum, KeepCovered, AluminumFoil, Parafilm
			}
		],
		Example[{Basic, "SamplePreparationCacheFields returns the fields associated with an Model[Container] input:"},
			SamplePreparationCacheFields[Model[Container]],
			{
				Name,Deprecated,DefaultStorageCondition,Sterile,AspectRatio,NumberOfWells,Footprint,Aperture,InternalDepth,
				SelfStanding,OpenContainer,MinVolume,MaxVolume,Dimensions,InternalDimensions,InternalDiameter,MaxTemperature,
				MinTemperature,Positions,FilterType, MembraneMaterial, MolecularWeightCutoff, PoreSize, PrefilterMembraneMaterial,
				PrefilterPoreSize, MaxCentrifugationForce, AvailableLayouts, WellDimensions,WellDiameter,WellDepth,WellColor,
				LiquidHandlerAdapter,WellPositionDimensions,WellDiameters,WellDepths,ContainerMaterials,WellBottom,NozzleHeight,
				NozzleOffset,SkirtHeight, RecommendedFillVolume,Immobile,RentByDefault,CoverFootprints,
				AluminumFoil, Ampoule, BuiltInCover, CoverTypes, Counterweights, EngineDefault, Hermetic, Opaque, Parafilm,
				RequestedResources, Reusable, RNaseFree, Squeezable, StorageBuffer, StorageBufferVolume,
				TareWeight, VolumeCalibrations, Columns,HorizontalPitch,LiquidHandlerPrefix, MultiProbeHeadIncompatible, VerticalPitch, MaxPressure,
				DestinationContainerModel,RetentateCollectionContainerModel,ConnectionType, KitProducts, Products, MixedBatchProducts, MaxOverheadMixRate
			}
		],
		Example[{Basic, "SamplePreparationCacheFields returns the fields associated with an Object[User] input:"},
			SamplePreparationCacheFields[Object[User]],
			{FirstName, LastName, Email, TeamEmailPreference, NotebookEmailPreferences, Name}
		]
	}
];




(* ::Subsubsection::Closed:: *)
(*resolveManualFrameworkFunction*)


DefineTests[
	resolveManualFrameworkFunction,
	{
		Example[{Basic, "If Preparation is Manual and any sample contains living material, return ExperimentManualCellPreparation:"},
			Module[
				{samples, objectFields, modelFields, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Sample, "Sample 1 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 2 for resolveManualFrameworkFunction tests " <>$SessionUUID]
				};

				(* Spoof a cache *)
				{objectFields, modelFields} = SamplePreparationCacheFields /@ {Object[Sample], Model[Sample]};
				downloadStuff = Quiet[
					Download[
						{
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Model[Sample]]]
						},
						{
							Evaluate[Packet @@ objectFields],
							Packet[Container[Contents]],
							Evaluate[Packet @@ modelFields]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolveManualFrameworkFunction[samples, {SterileTechnique -> Automatic}, Cache -> cache]
			],
			ExperimentManualCellPreparation
		],
		Example[{Basic, "If Preparation is Manual and no samples contain living material, return ExperimentManualSamplePreparation:"},
			Module[
				{samples, objectFields, modelFields, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Sample, "Sample 3 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 4 for resolveManualFrameworkFunction tests " <>$SessionUUID]
				};

				(* Spoof a cache *)
				{objectFields, modelFields} = SamplePreparationCacheFields /@ {Object[Sample], Model[Sample]};
				downloadStuff = Quiet[
					Download[
						{
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Model[Sample]]]
						},
						{
							Evaluate[Packet @@ objectFields],
							Packet[Container[Contents]],
							Evaluate[Packet @@ modelFields]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolveManualFrameworkFunction[samples, {SterileTechnique -> Automatic}, Cache -> cache]
			],
			ExperimentManualSamplePreparation
		],
		Example[{Basic, "If Preparation is Manual and no samples contain living material, return ExperimentManualSamplePreparation (Model[Sample] input):"},
			Module[
				{samples, objectFields, modelFields, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Model[Sample, "Milli-Q water"]
				};

				(* Spoof a cache *)
				{objectFields, modelFields} = SamplePreparationCacheFields /@ {Object[Sample], Model[Sample]};
				downloadStuff = Quiet[
					Download[
						{
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Model[Sample]]]
						},
						{
							Evaluate[Packet @@ objectFields],
							Evaluate[Packet @@ modelFields]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolveManualFrameworkFunction[samples, {SterileTechnique -> Automatic}, Cache -> cache]
			],
			ExperimentManualSamplePreparation
		],
		Example[{Basic, "If Preparation is Manual and some samples contain living material, return ExperimentManualCellPreparation (Model[Sample] input):"},
			Module[
				{samples, objectFields, modelFields, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Bacterial sample model for resolveManualFrameworkFunction tests " <> $SessionUUID]
				};

				(* Spoof a cache *)
				{objectFields, modelFields} = SamplePreparationCacheFields /@ {Object[Sample], Model[Sample]};
				downloadStuff = Quiet[
					Download[
						{
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Model[Sample]]]
						},
						{
							Evaluate[Packet @@ objectFields],
							Evaluate[Packet @@ modelFields]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolveManualFrameworkFunction[samples, {SterileTechnique -> Automatic}, Cache -> cache]
			],
			ExperimentManualCellPreparation
		],
		Example[{Basic, "If Output -> Type, return the Type corresponding to the resolved experiment function:"},
			Module[
				{samples, objectFields, modelFields, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Sample, "Sample 3 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 4 for resolveManualFrameworkFunction tests " <>$SessionUUID]
				};

				(* Spoof a cache *)
				{objectFields, modelFields} = SamplePreparationCacheFields /@ {Object[Sample], Model[Sample]};
				downloadStuff = Quiet[
					Download[
						{
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Model[Sample]]]
						},
						{
							Evaluate[Packet @@ objectFields],
							Packet[Container[Contents]],
							Evaluate[Packet @@ modelFields]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolveManualFrameworkFunction[samples, {SterileTechnique -> Automatic}, Cache -> cache, Output -> Type]
			],
			Object[Protocol, ManualSamplePreparation]
		],
		Example[{Basic, "If Preparation is Manual and any sample contains living material, return ExperimentManualCellPreparation (Object[Container] input):"},
			Module[
				{samples, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Container, Plate, "Plate 1 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 2 for resolveManualFrameworkFunction tests " <>$SessionUUID]
				};

				(* Spoof a cache *)
				downloadStuff = Quiet[
					Download[
						{
							samples
						},
						{
							Packet[Contents],
							Packet[Contents[[All, 2]][{Living, Sterile, CellType, Composition}]]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolveManualFrameworkFunction[samples, {SterileTechnique -> Automatic}, Cache -> cache]
			],
			ExperimentManualCellPreparation
		],
		Example[{Basic, "If Preparation is Manual and no sample contains living material, return ExperimentManualSamplePreparation (Object[Container] input):"},
			Module[
				{samples, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Container, Plate, "Plate 2 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 3 for resolveManualFrameworkFunction tests " <>$SessionUUID]
				};

				(* Spoof a cache *)
				downloadStuff = Quiet[
					Download[
						{
							samples
						},
						{
							Packet[Contents],
							Packet[Contents[[All, 2]][{Living, Sterile, CellType, Composition}]]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolveManualFrameworkFunction[samples, {SterileTechnique -> Automatic}, Cache -> cache]
			],
			ExperimentManualSamplePreparation
		],
		Example[{Basic, "If Preparation is Manual and no sample contains living material, But SterileTechnique is True, return ExperimentManualCellPreparation:"},
			Module[
				{samples, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Container, Plate, "Plate 2 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 3 for resolveManualFrameworkFunction tests " <>$SessionUUID]
				};

				(* Spoof a cache *)
				downloadStuff = Quiet[
					Download[
						{
							samples
						},
						{
							Packet[Contents],
							Packet[Contents[[All, 2]][{Living, Sterile, CellType, Composition}]]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolveManualFrameworkFunction[samples, {SterileTechnique -> True}, Cache -> cache]
			],
			ExperimentManualCellPreparation
		],
		Example[{Additional, "If the cache and simulation are missing any sample information, the necessary information is downloaded from the database:"},
			Module[
				{samples, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Container, Plate, "Plate 1 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 2 for resolveManualFrameworkFunction tests " <>$SessionUUID]
				};

				(* Spoof an incomplete cache *)
				downloadStuff = Quiet[
					Download[
						{
							{Object[Container, Plate, "Plate 2 for resolveManualFrameworkFunction tests " <>$SessionUUID]}
						},
						{
							Packet[Contents],
							Packet[Contents[[All, 2]][{Living, Sterile, CellType, Composition}]]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolveManualFrameworkFunction[samples, {SterileTechnique -> Automatic}, Cache -> {}, Simulation -> Simulation[]]
			],
			ExperimentManualCellPreparation
		]
	},
	Stubs :> {
		$DeveloperSearch = True
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Module[{namedObjects, existingObjs},
			$CreatedObjects = {};
			namedObjects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for resolveManualFrameworkFunction tests " <> $SessionUUID],
					Model[Cell, Bacteria, "Bacterial cell for resolveManualFrameworkFunction tests " <> $SessionUUID],
					Model[Sample, "Bacterial sample model for resolveManualFrameworkFunction tests " <> $SessionUUID],
					Object[Container, Vessel, "Tube 1 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 2 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 3 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 4 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 1 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 2 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 3 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Item, Tips, "Sterile Tips for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Item, Tips, "Non-Sterile Tips for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 1 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 2 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 3 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 4 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 5 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 6 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 7 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 8 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 9 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 10 for resolveManualFrameworkFunction tests " <>$SessionUUID]
				}],
				ObjectP[]
			]];

			existingObjs = PickList[namedObjects, DatabaseMemberQ[namedObjects]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

		];
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench, modelCell1, modelSample1,
					tube1, tube2, tube3, tube4, plate1, plate2, plate3, sterileTips, nonsterileTips,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10
				},

				(* Create a test bench *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for resolveManualFrameworkFunction tests " <> $SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				(* Make a test bacterial cell model. *)
				modelCell1 = UploadBacterialCell[
					"Bacterial cell for resolveManualFrameworkFunction tests " <> $SessionUUID,
					Morphology -> Cocci,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> Suspension
				];

				(* Make a test Model[Sample] *)
				modelSample1 = UploadSampleModel[
					"Bacterial sample model for resolveManualFrameworkFunction tests " <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, modelCell1}},
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

				(* Generate sample containers and tip objects. *)
				{
					tube1,
					tube2,
					tube3,
					tube4,
					plate1,
					plate2,
					plate3,
					sterileTips,
					nonsterileTips
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Item, Tips, "200 uL tips, sterile"],
						Model[Item, Tips, "200 uL tips, non-sterile"]
					},
					ConstantArray[{"Work Surface", testBench}, 9],
					Name -> {
						"Tube 1 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Tube 2 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Tube 3 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Tube 4 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Plate 1 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Plate 2 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Plate 3 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sterile Tips for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Non-Sterile Tips for resolveManualFrameworkFunction tests " <>$SessionUUID
					}
				];

				(* Generate samples *)
				{
					(* in tubes *)
					sample1,
					sample2,
					sample3,
					sample4,
					(* in plates *)
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10
				} = UploadSample[
					{
						(* in tubes *)
						modelSample1,
						modelSample1,
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						(* in plates *)
						modelSample1,
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						(* in tubes *)
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", tube4},
						(* in plates *)
						{"A1", plate1},
						{"A2", plate1},
						{"A1", plate2},
						{"A2", plate2},
						{"A1", plate3},
						{"A2", plate3}
					},
					InitialAmount -> ConstantArray[1 Milliliter, 10],
					Living -> {
						True,
						True,
						False,
						False,
						True,
						False,
						False,
						False,
						False,
						False
					},
					CellType -> {
						Bacterial,
						Bacterial,
						Null,
						Null,
						Bacterial,
						Null,
						Null,
						Null,
						Null,
						Null
					},
					State -> Liquid,
					Name -> {
						"Sample 1 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sample 2 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sample 3 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sample 4 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sample 5 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sample 6 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sample 7 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sample 8 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sample 9 for resolveManualFrameworkFunction tests " <>$SessionUUID,
						"Sample 10 for resolveManualFrameworkFunction tests " <>$SessionUUID
					}
				];

			];
		]
	),
	SymbolTearDown :> (
		Module[{namedObjects, allObjects, existingObjs},
			On[Warning::SamplesOutOfStock];
			namedObjects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for resolveManualFrameworkFunction tests " <> $SessionUUID],
					Model[Cell, Bacteria, "Bacterial cell for resolveManualFrameworkFunction tests " <> $SessionUUID],
					Model[Sample, "Bacterial sample model for resolveManualFrameworkFunction tests " <> $SessionUUID],
					Object[Container, Vessel, "Tube 1 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 2 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 3 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 4 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 1 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 2 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 3 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Item, Tips, "Sterile Tips for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Item, Tips, "Non-Sterile Tips for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 1 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 2 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 3 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 4 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 5 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 6 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 7 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 8 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 9 for resolveManualFrameworkFunction tests " <>$SessionUUID],
					Object[Sample, "Sample 10 for resolveManualFrameworkFunction tests " <>$SessionUUID]
				}],
				ObjectP[]
			]];

			allObjects = Quiet[Cases[
				Flatten[{
					$CreatedObjects,
					namedObjects
				}],
				ObjectP[]
			]];
			existingObjs = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Unset[$CreatedObjects];
		];
	)
];
(* ::Subsubsection::Closed:: *)
(*resolvePotentialWorkCells*)


DefineTests[
	resolvePotentialWorkCells,
	{
		Example[{Basic, "If Preparation is Robotic and any sample contains living material, return CellPreparation work cells:"},
			Module[
				{samples, objectFields, modelFields, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Sample, "Sample 1 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 2 for resolvePotentialWorkCells tests " <>$SessionUUID]
				};

				(* Spoof a cache *)
				{objectFields, modelFields} = SamplePreparationCacheFields /@ {Object[Sample], Model[Sample]};
				downloadStuff = Quiet[
					Download[
						{
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Model[Sample]]]
						},
						{
							Evaluate[Packet @@ objectFields],
							Packet[Container[Contents]],
							Evaluate[Packet @@ modelFields]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolvePotentialWorkCells[samples, {Preparation -> Robotic}, Cache -> cache]
			],
			{microbioSTAR|bioSTAR..}
		],
		Example[{Basic, "If input is Object[Container], the samples in its contents are checked for living materials and cell types for potential workcell resolution:"},
			Module[
				{container, objectFields, containerFields, downloadStuff, cache},
				container = Object[Container, Plate, "Plate 1 for resolvePotentialWorkCells tests " <>$SessionUUID];

				(* Spoof a cache *)
				{objectFields, containerFields} = SamplePreparationCacheFields /@ {Object[Sample], Object[Container]};
				downloadStuff = Quiet[
					Download[
						{
							container[Contents][[All,2]],
							{container}
						},
						{
							Evaluate[Packet @@ objectFields],
							Evaluate[Packet @@ containerFields]
						}
					],
					{Download::FieldDoesntExist}
				];

				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* The helper should be able to download the contents and sample info if no cache is fed *)
				(* Plate 1 contains a microbial sample and a water sample, therefore should resolve to microbioSTAR *)
				resolvePotentialWorkCells[
					container,
					{Preparation -> Robotic},
					Cache -> cache
				]
			],
			{microbioSTAR}
		],
		Example[{Basic, "If input is a position in Object[Container], only the sample at this position of the container is checked for living materials and cell types for potential workcell resolution:"},
			(* Because potential aliquot sample prep might be included that is out of the scope of this function, we do not want to screen out workcells prematurely *)
			Module[
				{container, objectFields, containerFields, downloadStuff, cache, potentialWorkCells},
				container = Object[Container, Plate, "Plate 1 for resolvePotentialWorkCells tests " <>$SessionUUID];

				(* Spoof a cache *)
				{objectFields, containerFields} = SamplePreparationCacheFields /@ {Object[Sample], Object[Container]};
				downloadStuff = Quiet[
					Download[
						{
							container[Contents][[All,2]],
							{container}
						},
						{
							Evaluate[Packet @@ objectFields],
							Evaluate[Packet @@ containerFields]
						}
					],
					{Download::FieldDoesntExist}
				];

				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* The helper should be able to download the contents and sample info if no cache is fed *)
				(* Plate 1 contains a microbial sample and a water sample, therefore should resolve to microbioSTAR *)
				potentialWorkCells = resolvePotentialWorkCells[
					{"A2", container},(* water is at this position *)
					{Preparation -> Robotic},
					Cache -> cache
				];

				MemberQ[potentialWorkCells, #]& /@{STAR, bioSTAR, microbioSTAR}
			],
			{True..}
		],
		Example[{Basic, "If input is simply an Automatic, all work cells are allowed:"},
			Module[{potentialWorkCells},
				potentialWorkCells = resolvePotentialWorkCells[
					Automatic,
					{Preparation -> Robotic}
				];
				MemberQ[potentialWorkCells, #]& /@{STAR, bioSTAR, microbioSTAR}
			],
			{True..}
		],
		Example[{Basic, "If Preparation is Robotic and no samples contain living material, return STAR ast one of the potential work cells:"},
			Module[
				{samples, objectFields, modelFields, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Sample, "Sample 3 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 4 for resolvePotentialWorkCells tests " <>$SessionUUID]
				};

				(* Spoof a cache *)
				{objectFields, modelFields} = SamplePreparationCacheFields /@ {Object[Sample], Model[Sample]};
				downloadStuff = Quiet[
					Download[
						{
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Object[Sample]]],
							Cases[samples, ObjectP[Model[Sample]]]
						},
						{
							Evaluate[Packet @@ objectFields],
							Packet[Container[Contents]],
							Evaluate[Packet @@ modelFields]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolvePotentialWorkCells[samples, {Preparation -> Robotic}, Cache -> cache]
			],
			{___, STAR, ___}
		],
		Example[{Additional, "If the cache and simulation are missing any sample information, the necessary information is downloaded from the database:"},
			Module[
				{samples, downloadStuff, cache},

				(* Download some information and generate the fastAssoc from it. *)
				samples = {
					Object[Container, Plate, "Plate 1 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 2 for resolvePotentialWorkCells tests " <>$SessionUUID]
				};

				(* Spoof an incomplete cache *)
				downloadStuff = Quiet[
					Download[
						{
							{Object[Container, Plate, "Plate 2 for resolvePotentialWorkCells tests " <>$SessionUUID]}
						},
						{
							Packet[Contents],
							Packet[Contents[[All, 2]][{Living, Sterile, CellType, Composition}]]
						}
					],
					{Download::FieldDoesntExist}
				];
				cache = Experiment`Private`FlattenCachePackets[downloadStuff];

				(* Run the helper. *)
				resolvePotentialWorkCells[samples, {Preparation -> Robotic}, Cache -> cache, Simulation -> Simulation[]]
			],
			{WorkCellP..}
		]
	},
	Stubs :> {
		$DeveloperSearch = True
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Module[{namedObjects, existingObjs},
			$CreatedObjects = {};
			namedObjects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for resolvePotentialWorkCells tests " <> $SessionUUID],
					Model[Cell, Bacteria, "Bacterial cell for resolvePotentialWorkCells tests " <> $SessionUUID],
					Model[Sample, "Bacterial sample model for resolvePotentialWorkCells tests " <> $SessionUUID],
					Object[Container, Vessel, "Tube 1 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 2 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 3 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 4 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 1 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 2 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 3 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Item, Tips, "Sterile Tips for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Item, Tips, "Non-Sterile Tips for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 1 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 2 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 3 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 4 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 5 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 6 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 7 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 8 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 9 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 10 for resolvePotentialWorkCells tests " <>$SessionUUID]
				}],
				ObjectP[]
			]];

			existingObjs = PickList[namedObjects, DatabaseMemberQ[namedObjects]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

		];
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench, modelCell1, modelSample1,
					tube1, tube2, tube3, tube4, plate1, plate2, plate3, sterileTips, nonsterileTips,
					sample1, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10
				},

				(* Create a test bench *)
				testBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Test bench for resolvePotentialWorkCells tests " <> $SessionUUID,
					StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					Site -> Link[$Site]
				|>];

				(* Make a test bacterial cell model. *)
				modelCell1 = UploadBacterialCell[
					"Bacterial cell for resolvePotentialWorkCells tests " <> $SessionUUID,
					Morphology -> Cocci,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSRequired -> False,
					IncompatibleMaterials -> {None},
					CellType -> Bacterial,
					CultureAdhesion -> Suspension
				];

				(* Make a test Model[Sample] *)
				modelSample1 = UploadSampleModel[
					"Bacterial sample model for resolvePotentialWorkCells tests " <> $SessionUUID,
					Composition -> {{95 VolumePercent, Model[Molecule, "Water"]}, {5 VolumePercent, modelCell1}},
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

				(* Generate sample containers and tip objects. *)
				{
					tube1,
					tube2,
					tube3,
					tube4,
					plate1,
					plate2,
					plate3,
					sterileTips,
					nonsterileTips
				} = UploadSample[
					{
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Item, Tips, "200 uL tips, sterile"],
						Model[Item, Tips, "200 uL tips, non-sterile"]
					},
					ConstantArray[{"Work Surface", testBench}, 9],
					Name -> {
						"Tube 1 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Tube 2 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Tube 3 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Tube 4 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Plate 1 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Plate 2 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Plate 3 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sterile Tips for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Non-Sterile Tips for resolvePotentialWorkCells tests " <>$SessionUUID
					}
				];

				(* Generate samples *)
				{
					(* in tubes *)
					sample1,
					sample2,
					sample3,
					sample4,
					(* in plates *)
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10
				} = UploadSample[
					{
						(* in tubes *)
						modelSample1,
						modelSample1,
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						(* in plates *)
						modelSample1,
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						(* in tubes *)
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", tube4},
						(* in plates *)
						{"A1", plate1},
						{"A2", plate1},
						{"A1", plate2},
						{"A2", plate2},
						{"A1", plate3},
						{"A2", plate3}
					},
					InitialAmount -> ConstantArray[1 Milliliter, 10],
					Living -> {
						True,
						True,
						False,
						False,
						True,
						False,
						False,
						False,
						False,
						False
					},
					CellType -> {
						Bacterial,
						Bacterial,
						Null,
						Null,
						Bacterial,
						Null,
						Null,
						Null,
						Null,
						Null
					},
					State -> Liquid,
					Name -> {
						"Sample 1 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sample 2 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sample 3 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sample 4 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sample 5 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sample 6 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sample 7 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sample 8 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sample 9 for resolvePotentialWorkCells tests " <>$SessionUUID,
						"Sample 10 for resolvePotentialWorkCells tests " <>$SessionUUID
					}
				];

			];
		]
	),
	SymbolTearDown :> (
		Module[{namedObjects, allObjects, existingObjs},
			On[Warning::SamplesOutOfStock];
			namedObjects = Quiet[Cases[
				Flatten[{
					Object[Container, Bench, "Test bench for resolvePotentialWorkCells tests " <> $SessionUUID],
					Model[Cell, Bacteria, "Bacterial cell for resolvePotentialWorkCells tests " <> $SessionUUID],
					Model[Sample, "Bacterial sample model for resolvePotentialWorkCells tests " <> $SessionUUID],
					Object[Container, Vessel, "Tube 1 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 2 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 3 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Vessel, "Tube 4 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 1 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 2 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Container, Plate, "Plate 3 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Item, Tips, "Sterile Tips for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Item, Tips, "Non-Sterile Tips for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 1 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 2 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 3 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 4 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 5 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 6 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 7 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 8 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 9 for resolvePotentialWorkCells tests " <>$SessionUUID],
					Object[Sample, "Sample 10 for resolvePotentialWorkCells tests " <>$SessionUUID]
				}],
				ObjectP[]
			]];

			allObjects = Quiet[Cases[
				Flatten[{
					$CreatedObjects,
					namedObjects
				}],
				ObjectP[]
			]];
			existingObjs = PickList[allObjects, DatabaseMemberQ[allObjects]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Unset[$CreatedObjects];
		];
	)
];


DefineTests[
	FlattenCachePacketsSimulation,
	{
		Test["The field gets updated with the merged cache:",
			cache = {<|Object -> Object[Sample, "id: 1234"], Volume -> 1 Milliliter, Status -> Liquid|>, <|Object -> Object[Sample, "id: 1234"], Volume -> 0.5 Milliliter|>};
			newCache = FlattenCachePacketsSimulation[cache];
			Download[
				Object[Sample, "id: 1234"],
				Volume,
				Cache -> newCache
			],
			EqualP[0.5 Milliliter],
			Variables :> {cache, newCache}
		],
		Test["The delayed rule is preserved and not evaluated:",
			notEvaluate := "evaluated";
			cache = {<|Object -> Object[Sample, "id: 1234"], Volume -> 1 Milliliter, Status -> Liquid, Appearance :> notEvaluate|>, <|Object -> Object[Sample, "id: 1234"], Volume -> 0.5 Milliliter|>};
			newCache = FlattenCachePacketsSimulation[cache];
			Count[Flatten[Normal[#, Association]& /@ newCache], Verbatim[RuleDelayed][_, _]],
			1,
			Variables :> {notEvaluate, cache, newCache}
		]
	}
];

