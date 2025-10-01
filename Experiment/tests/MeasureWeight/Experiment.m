(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMeasureWeight : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMeasureWeight*)


(* ::Subsubsection:: *)
(*ExperimentMeasureWeight*)

DefineTests[
	ExperimentMeasureWeight,
(* Basic examples *)
	{
		Example[{Basic,"Measure the weight of a single solid sample:"},
			ExperimentMeasureWeight[Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Basic,"Measure the weight of a single liquid sample:"},
			ExperimentMeasureWeight[Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Basic,"Measure the weight of a single liquid sample without a model:"},
			ExperimentMeasureWeight[Object[Sample,"Special liquid sample without a model for ExperimentMeasureWeight testing"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Basic,"Measure the weight of a single counted sample:"},
			ExperimentMeasureWeight[Object[Sample,"Available counted sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Additional,"Measure the weight of an empty container:"},
			ExperimentMeasureWeight[Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Additional,"Measure the weight of an empty container and a filled container:"},
			ExperimentMeasureWeight[{
				Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID]
			}],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Additional,"Measure the weight of a cap, an empty container, and a filled container:"},
			ExperimentMeasureWeight[{
				Object[Item,Cap,"Test cap 1 for ExperimentMeasureWeight testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID]
			}],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Test["Balance is set to Analytical for cap/lid/plate seal with unknown balance type:",
			prot = ExperimentMeasureWeight[Object[Item, Cap, "Test cap 1 for ExperimentMeasureWeight testing" <> $SessionUUID]];
			Download[Lookup[Download[prot, Batching][[1]], Balance], Mode],
			Analytical,
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			},
			Variables :> {prot}
		],

		Test["Populate CoveredContainer key in Batching field if we are measuring a cover that is currently on a container:",
			prot = ExperimentMeasureWeight[Object[Item, Cap, "Test cap 2 for ExperimentMeasureWeight testing" <> $SessionUUID]];
			Lookup[Download[prot, Batching][[1]], CoveredContainer],
			LinkP[Object[Container, Vessel, "Test covered container 1 for ExperimentMeasureWeight testing" <> $SessionUUID]],
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			},
			Variables :> {prot}
		],
		Test["Need a fumehood handling environment, if we are transferring a fuming/ventilated sample to TransferContainer:",
			prot = ExperimentMeasureWeight[
				Object[Container, Vessel, "Test covered container 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
				TransferContainer -> Automatic
			];
			Lookup[Download[prot, Batching][[1]], {TransferContainer, HandlingEnvironment}],
			{LinkP[Model[Container, Vessel]], LinkP[Model[Instrument, HandlingStation, FumeHood]]},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			},
			Variables :> {prot}
		],
		Test["Need a fumehood handling environment, if we are measuring cap that is currently covering a container that has fuming/ventilated sample in it:",
			prot = ExperimentMeasureWeight[Object[Item, Cap, "Test cap 2 for ExperimentMeasureWeight testing" <> $SessionUUID]];
			Lookup[Download[prot, Batching][[1]], HandlingEnvironment],
			LinkP[Model[Instrument, HandlingStation, FumeHood]],
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			},
			Variables :> {prot}
		],
		Test["Allow a list of fumehoods to be selected, if we are given a balance model that is not inside any of the current fumehood handling stations:",
			prot = ExperimentMeasureWeight[
				Object[Container, Vessel, "Test covered container 2 for ExperimentMeasureWeight testing" <> $SessionUUID],
				TransferContainer -> Automatic
			];
			FirstCase[Download[prot, RequiredResources], {obj_, Batching, _, HandlingEnvironment} :> Download[obj, InstrumentModels]],
			{ObjectP[Model[Instrument, HandlingStation, FumeHood]]..}?(Length[#] > 1&),
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			},
			Variables :> {prot}
		],
		Example[{Additional,"Measure the weight of a mixed set of samples (solid, liquid and counted):"},
			ExperimentMeasureWeight[{
				Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available counted sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available counted sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID]
			}],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Additional,"Measure the weight of a list of containers:"},
			ExperimentMeasureWeight[
				{Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID]
			}],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],

		(* 7 different CalibrateContainer scenarios *)
		Example[{Options,CalibrateContainer,"CalibrateContainer allows specification as to whether the tareweight of the input container should be recorded (empty container example):"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
					CalibrateContainer->True,
					Output->Options
				],
				CalibrateContainer
			],
			True
		],
		Example[{Options,CalibrateContainer,"CalibrateContainer allows specification as to whether the tareweight of the input container should be recorded (container with sample example):"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Sample,"Sample with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
					CalibrateContainer->True,
					Output->Options
				],
				CalibrateContainer
			],
			True
		],
		Example[{Options,CalibrateContainer,"If CalibrateContainer is specified to False, the tareweight of the container is not recorded, even if the container is empty:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
					CalibrateContainer->False,
					Output->Options
				],
				CalibrateContainer
			],
			False
		],
		Example[{Options,CalibrateContainer,"CalibrateContainer automatically resolves to False if a TransferContainer is specified:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
					CalibrateContainer->Automatic,
					TransferContainer->Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
					Output->Options
				],
				CalibrateContainer
			],
			False
		],
		Example[{Options,CalibrateContainer,"CalibrateContainer automatically resolves to True if the input container is empty:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
					CalibrateContainer->Automatic,
					Output->Options
				],
				CalibrateContainer
			],
			True
		],
		Example[{Options,CalibrateContainer,"CalibrateContainer automatically resolves to True if the input container contains a sample whose weight we know and the container does not have a tareweight:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Sample,"Sample with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
					CalibrateContainer->Automatic,
					Output->Options
				],
				CalibrateContainer
			],
			True
		],
		Example[{Options,CalibrateContainer,"CalibrateContainer automatically resolves to False if the container does not have a tareweight and we do not know the sample's weight:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
					CalibrateContainer->Automatic,
					Output->Options
				],
				CalibrateContainer
			],
			False
		],

		(* === 12 different TransferContainer scenarios, 1 of which causes error message === *)
		Example[{Options,TransferContainer,"TransferContainer allows specification of a container into which the sample should be transferred prior to weighing:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
					TransferContainer->Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
					Output->Options
				],
				TransferContainer
			],
			ObjectP[Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID]]
		],
		Example[{Options,TransferContainer,"TransferContainer can be set to Null if CalibrateContainer is set to True:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Sample,"Sample with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
					TransferContainer->Null,
					CalibrateContainer->True,
					Output->Options
				],
				{TransferContainer,CalibrateContainer}
			],
		{Null,True}
		],
		Example[{Options,TransferContainer,"TransferContainer can be set to Null if the input container is empty:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
					TransferContainer->Null,
					Output->Options
				],
				{TransferContainer}
			],
		{Null}
		],
		Example[{Options,TransferContainer,"TransferContainer can be set to Null if the input container has a tare weight:"},
			{
				Lookup[
					ExperimentMeasureWeight[
						Object[Container,Vessel,"Micro container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
						TransferContainer->Null,
						Output->Options
					],
					TransferContainer
				],
				Download[Object[Container,Vessel,"Micro container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],TareWeight]
			},
		{Null,1.`Gram}
		],
		Example[{Options,TransferContainer,"TransferContainer allows specification of a container model into which the sample should be transferred prior to weighing:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
					TransferContainer->Model[Container,Vessel,"50mL Tube"],
					Output->Options
				],
				TransferContainer
			],
			ObjectP[Model[Container,Vessel,"50mL Tube"]]
		],
		Example[{Options,TransferContainer,"TransferContainer automatically resolves to Null if the input container is empty:"},
			{Lookup[
				ExperimentMeasureWeight[
					Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
					TransferContainer->Automatic,
					Output->Options
				],
				TransferContainer
			]},
		{Null}
		],
		Example[{Options,TransferContainer,"TransferContainer automatically resolves to Null if the input container has a tareweight:"},
			{Lookup[
				ExperimentMeasureWeight[
					Object[Container,Vessel,"Micro container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
					TransferContainer->Automatic,
					Output->Options
				],
				TransferContainer
			]},
		{Null}
		],
		Example[{Options,TransferContainer,"TransferContainer automatically resolves to a suitable container model if the input container has no tareweight and contains a sample whose weight is not known:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
					TransferContainer->Automatic,
					Output->Options
				],
				TransferContainer
			],
      ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]
		],
    Example[{Options,TransferContainer,"TransferContainer automatically resolves to Null if the sample is moved during SamplePrep experiments prior to the MeasureWeight experiment since that ensures a TareWeight:"},
      Lookup[
        ExperimentMeasureWeight[
          Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
          TransferContainer->Automatic,
          AliquotContainer->Model[Container,Vessel,"id:bq9LA0dBGGR6"],
          Output->Options
        ],
        {TransferContainer,AliquotContainer}
      ],
      {Null,{{1,ObjectP[Model[Container,Vessel,"id:bq9LA0dBGGR6"]]}}}
    ],
		Example[{Options,TransferContainer,"If the sample is in a container with no TareWeight, do not use TransferContainer if TareWeight of the model container is informed:"},
			Lookup[ExperimentMeasureWeight[
				Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID],
				Output->Options],TransferContainer
			],
			Null
		],


		(* === 10 different Instrument scenarios, 2 of which cause error messages === *)
		Example[{Options,Instrument,"Instrument allows specification of a balance to be used for weighing:"},
			Lookup[
				ExperimentMeasureWeight[
					Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
					Instrument->Model[Instrument,Balance,"id:rea9jl5Vl1ae"],
					Output->Options
				],
				Instrument
			],
			ObjectP[Model[Instrument,Balance,"id:rea9jl5Vl1ae"]]
		],
		Example[{Options,Instrument,"Instrument can be specified to a Microbalance if TransferContainer is being used (since then a weighboat is used which fits on the balance):"},
			ExperimentMeasureWeight[
				(* this is a sample that will trigger automatic resolution to a TransferContainer  *)
				Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Instrument->Model[Instrument,Balance,"id:54n6evKx08XN"]
			],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Options,Instrument,"Instrument can be specified to a Microbalance if container is of a suitable Model {Model[Container,Vessel,\"id:AEqRl954GG7a\"],Model[Container,Vessel,\"id:7X104vK9ZZNJ\"]} and the sample weight is trustworthy and below 4.8 gram):"},
			ExperimentMeasureWeight[
				(* this is a sample in a Microbalance suitable container with Tareweight and has a trustworthy mass small enough to fit on the Microbalance, so it won't be transferred  *)
				Object[Sample,"Sample in Microcontainer with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				Instrument->Model[Instrument,Balance,"id:54n6evKx08XN"]
			],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Options,Instrument,"Instrument can be specified to a Microbalance if container is of a suitable Model {Model[Container,Vessel,\"id:AEqRl954GG7a\"],Model[Container,Vessel,\"id:7X104vK9ZZNJ\"]}, and if the sample weight is not trustworthy it is not taken into account:"},
			ExperimentMeasureWeight[
				(* this is a sample in a Microbalance suitable container with Tareweight and has a non-trustworthy mass - it will not be transferred and can be measured on a Microbalance *)
				Object[Sample,"Sample in Microcontainer with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				Instrument->Model[Instrument,Balance,"id:54n6evKx08XN"]
			],
			ObjectP[Object[Protocol,MeasureWeight]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Options,Instrument,"Instrument, if specified, needs to match the mode that is recommended for the model of the input container and the sample weight (if ):"},
			Module[{mySpecifiedInstrument},
				mySpecifiedInstrument=Lookup[
					ExperimentMeasureWeight[
						(* this is a sample in a 50 ml tube so the preferred balance is Analytical *)
						Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Instrument->Model[Instrument,Balance,"id:rea9jl5Vl1ae"],
						Output->Options
					],
					Instrument
				];
				{Download[mySpecifiedInstrument,Mode],Download[Model[Instrument,Balance,"id:rea9jl5Vl1ae"],Mode]}
				],
			{Analytical,Analytical}
		],
		Example[{Options,Instrument,"Instrument will automatically resolve to the PreferredBalance of the input container model if the container is empty:"},
			Module[{mySpecifiedInstrument},
				mySpecifiedInstrument=Lookup[
					ExperimentMeasureWeight[
						Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
						Output->Options
					],
				Instrument];
				{Download[mySpecifiedInstrument,Mode],Download[Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],Model[PreferredBalance]]}
				],
			{Analytical,Analytical}
		],
		Test["Resolve to SnR bench balance object automatically if we are in receiving:",
			testReceiving = Upload[<|Type -> Object[Maintenance, ReceiveInventory]|>];
			prot = ExperimentMeasureWeight[
				Object[Container, Vessel, "Empty 50ml container for ExperimentMeasureWeight testing" <> $SessionUUID],
				ParentProtocol -> testReceiving
			];
			Download[prot, Batching[[All, Balance]]],
			{ObjectP[Object[Instrument, Balance]]}
		],
		Example[{Options,Instrument,"Instrument will automatically resolve to the PreferredBalance of the input lid model:"},
			Module[{mySpecifiedInstrument},
				mySpecifiedInstrument=Lookup[
					ExperimentMeasureWeight[
						Object[Item,Lid,"Test lid 1 for ExperimentMeasureWeight testing"<>$SessionUUID],
						Output->Options
					],
				Instrument];
				{Download[mySpecifiedInstrument,Mode],Download[Object[Item,Lid,"Test lid 1 for ExperimentMeasureWeight testing"<>$SessionUUID],Model[PreferredBalance]]}
				],
			{Analytical,Analytical}
		],
		Example[{Options,Instrument,"Instrument will automatically resolve to the PreferredBalance of the input container model if the container contains a sample of which we don't know the weight:"},
			Module[{mySpecifiedInstrument},
				mySpecifiedInstrument=Lookup[
					ExperimentMeasureWeight[
						Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Output->Options
					],
				Instrument];
				{Download[mySpecifiedInstrument,Mode],Download[Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],Container[Model][PreferredBalance]]}
			],
			{Analytical,Analytical}
		],
		Example[{Options,Instrument,"Automatic instrument resolution will take sample weight into account only when it is trustworthy (here we resolve to Analytical even though the container's PreferredBalance is Analytical):"},
			Module[{mySpecifiedInstrument},
				mySpecifiedInstrument=Lookup[
					ExperimentMeasureWeight[
						Object[Sample,"Sample in 50ml container with super-heavy Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
						Output->Options
					],
				Instrument];
				{Download[mySpecifiedInstrument,Mode],Download[Object[Sample,"Sample in Microcontainer with Trusted Large Mass for ExperimentMeasureWeight testing"<> $SessionUUID],Container[Model][PreferredBalance]]}
			],
			{Macro,Analytical}
		],
		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentMeasureWeight[
				Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				SamplesInStorageCondition -> Refrigerator,
				Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,SamplesOutStorageCondition, "Indicates how the output samples of the experiment should be stored:"},
			options = ExperimentMeasureWeight[
				Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				SamplesInStorageCondition -> Refrigerator,
				Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,SampleLabel,"SampleLabel applies a label to the sample for use in SamplePreparation - label automatically applied:"},
			Lookup[ExperimentMeasureWeight[Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID], Output -> Options], SampleLabel],
			"measure weight sample" ~~ ___,
			EquivalenceFunction -> StringMatchQ
		],
		Example[{Options,SampleLabel,"SampleLabel applies a label to the sample for use in SamplePreparation:"},
			Lookup[ExperimentMeasureWeight[Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID], SampleLabel -> "my sample", Output -> Options], SampleLabel],
			"my sample"
		],
		Example[{Options,SampleContainerLabel,"SampleContainerLabel applies a label to the container of the sample for use in SamplePreparation: - label automatically applied:"},
			Lookup[ExperimentMeasureWeight[Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID], Output -> Options], SampleContainerLabel],
			"measure weight container" ~~ ___,
			EquivalenceFunction -> StringMatchQ
		],
		Example[{Options,SampleContainerLabel,"SampleContainerLabel applies a label to the container of the sample for use in SamplePreparation:"},
			Lookup[ExperimentMeasureWeight[Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID], SampleContainerLabel -> "my container", Output -> Options], SampleContainerLabel],
			"my container"
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentMeasureWeight[
				Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Test["ExperimentMeasureWeight returns a simulation blob if Output -> Simulation:",
			ExperimentMeasureWeight[Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID], Output -> Simulation],
			SimulationP
		],

		(* === Error messages === *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentMeasureWeight[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentMeasureWeight[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentMeasureWeight[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentMeasureWeight[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentMeasureWeight[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
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

				ExperimentMeasureWeight[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs or options contain temporal links:"},
			ExperimentMeasureWeight[
				Link[Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],Now]
			],
			ObjectP[Object[Protocol,MeasureWeight]],
			Messages :> {
				Warning::InputContainsTemporalLinks
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
    Example[{Messages,"MissingContainer","If the given input samples do not have a Container, they can't be weighed:"},
      ExperimentMeasureWeight[Object[Sample,"Sample without container for ExperimentMeasureWeight testing"<> $SessionUUID]],
      $Failed,
      Messages:>{
        Error::MissingContainer,
        Error::InvalidInput
      }
    ],
    Example[{Messages,"NoContentsToBeTransferred","Cannot specify a TransferContainer if the input containers do not have a content:"},
      ExperimentMeasureWeight[Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
        TransferContainer->Object[Container,Vessel,"Empty 50ml container 2 for ExperimentMeasureWeight testing"<> $SessionUUID]
        ],
      $Failed,
      Messages:>{
        Error::NoContentsToBeTransferred,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"NoContentsToBeTransferred","Cannot specify a TransferContainer if the input containers do not have a content:"},
      ExperimentMeasureWeight[Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
        TransferContainer->Object[Container,Vessel,"Empty 50ml container 2 for ExperimentMeasureWeight testing"<> $SessionUUID]
        ],
      $Failed,
      Messages:>{
        Error::NoContentsToBeTransferred,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"SamplePrepOnEmptyContainer","If the given input container is empty, SamplePrep options cannot be specified:"},
      ExperimentMeasureWeight[Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
        Incubate->True
      ],
      $Failed,
      Messages:>{
        Error::CantSamplePrepInvalidContainers,
        Error::InvalidInput,
				Error::InvalidOption
      }
    ],
    Example[{Messages,"TransferContainerNotEmpty","Specified TransferContainer has to be empty:"},
      ExperimentMeasureWeight[Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
        TransferContainer->Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID]
      ],
      $Failed,
      Messages:>{
        Error::TransferContainerNotEmpty,
        Error::InvalidOption
      }
    ],
    Example[{Messages,"DiscardedSamples","If the given input samples are discarded, they cannot be weighed:"},
			ExperimentMeasureWeight[Object[Sample,"Discarded sample for ExperimentMeasureWeight testing"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"IncompatibleContainerType","If the input containers or the containers of the input samples are not of the type MeasureWeightContainerP, they cannot be weighed:"},
			ExperimentMeasureWeight[Object[Sample,"Available sample in plate for ExperimentMeasureWeight testing"<> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::IncompatibleInputType,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ConflictingOptions","If CalibrateContainer is specified to True, we cannot have TransferContainer specified as well:"},
			ExperimentMeasureWeight[
				Object[Sample, "Sample with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				TransferContainer->Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
				CalibrateContainer->True
			],
			$Failed,
			Messages:>{
				Error::ConflictingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SampleMassUnknown","We can only measure the tareweight of the input container (CalibrateContainer -> True) if the container is either empty or it contains a sample whose weight is known:"},
			ExperimentMeasureWeight[Object[Sample,"Sample with no Mass for ExperimentMeasureWeight testing"<> $SessionUUID],CalibrateContainer->True],
			$Failed,
			Messages:>{
				Error::SampleMassUnknown,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SampleMassMayBeInaccurate", "When CalibrateContainer is set to True, it is assumed that the sample's mass is trustworthy (i.e. has not been manipulated by any other protocol after the latest mass entry has been recorded):"},
			Lookup[
				ExperimentMeasureWeight[
					(* This sample has a Mass but we don't trust it *)
					Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
					CalibrateContainer->True,
					Output->Options
				],
				CalibrateContainer
			],
			True,
			Messages:>{
				Warning::SampleMassMayBeInaccurate
			}
		],
		Example[{Messages,"TareWeightNeeded","TransferContainer can only be specified to Null if the input container's tareweight is known (or is empty):"},
			ExperimentMeasureWeight[
				Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				TransferContainer->Null
			],
			$Failed,
			Messages:>{
				Error::TareWeightNeeded,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnsuitableBalance","Specified Instrument needs to be identical to the balance that would be recommended for that particular sample:"},
			ExperimentMeasureWeight[
				Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Instrument->Model[Instrument,Balance,"id:aXRlGn6V7Jov"]
			],
			$Failed,
			Messages:>{
				Error::UnsuitableBalance,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ContainerIncompatibleWithBalance","Instrument can only be specified to a Microbalance if the containers are of the model {Model[Container,Vessel,\"id:AEqRl954GG7a\"],Model[Container,Vessel,\"id:7X104vK9ZZNJ\"]} or a TransferContainer is specified:"},
			ExperimentMeasureWeight[
				Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
				Instrument->Model[Instrument,Balance,"id:54n6evKx08XN"]
			],
			$Failed,
			Messages:>{
				Error::InputIncompatibleWithBalance,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnsuitableMicroBalance","Instrument can only be specified to a Microbalance if the weight of the sample to be weighed is below the weighing limit of the micro balance (4.8 Gram):"},
			ExperimentMeasureWeight[
				(* this container contains a sample with a trusted but way too heavy weight *)
				Object[Container,Vessel,"Micro container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Instrument->Model[Instrument,Balance,"id:54n6evKx08XN"]
			],
			$Failed,
			Messages:>{
				Error::UnsuitableMicroBalance,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnsuitableMicroBalance","Instrument can only be specified to a Microbalance if the weight of the sample is trustworthy:"},
			ExperimentMeasureWeight[
				(* this container contains a sample with a trusted but way too heavy weight *)
				Object[Container,Vessel,"Micro container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Instrument->Model[Instrument,Balance,"id:54n6evKx08XN"]
			],
			$Failed,
			Messages:>{
				Error::UnsuitableMicroBalance,
				Error::InvalidOption
			}
		],

		(* === Test that the batching fields are populated properly === *)

		Test["Samples are partitioned into batches of 25:",
			Module[{myProtocol},
				myProtocol=ExperimentMeasureWeight[
					{
						(* one empty container *)
						Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
						(* one regular  container with sample but mass is not trusted *)
						Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
						(* one container with sample with trustworthy mass *)
						Object[Container,Vessel,"50ml container 9 for ExperimentMeasureWeight testing"<> $SessionUUID],
						(* 24 containers with sample with trustworthy mass *)
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID]
					}
				];
				Download[myProtocol,BatchingLengths]
			],
			{25,2},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			TimeConstraint->600
		],
		Test["The Holder key in the Batching field is populated with appropriate racks when needed:",
			Module[{myProtocol},
				myProtocol=ExperimentMeasureWeight[
					{
					(* one regular  container with sample but mass is not trusted  - needs TransferContainer *)
						(* The transfer container automatically determined is a 50 ml tube, so needs a holder *)
						Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],

					(* one container with sample with trustworthy mass, with TransferContainer specified *)
						Object[Container,Vessel,"50ml container 9 for ExperimentMeasureWeight testing"<> $SessionUUID],

					(* one container with sample with non-trustworthy mass where CalibrateContainer is set to True *)
						Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],

					(* Container that needs scouting (and does have TareWeight so won't get transferred) *)
						Object[Container,Vessel,"50ml container without PreferredBalance for ExperimentMeasureWeight testing"<> $SessionUUID]
					},
					TransferContainer->{Automatic,Object[Container,Vessel,"Empty 50ml container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],Automatic,Automatic},
					CalibrateContainer->{Automatic,Automatic,True,Automatic}
				];
				Lookup[Download[myProtocol,Batching],Holder]
			],
			(* Note that because we now use Sample Object ID instead of Sample Object Name, the sorting of samples using the same Balance may be different every time *)
				{ObjectP[Model[Container, Rack]], ObjectP[Model[Container, Rack]], ObjectP[Model[Container, Rack]], ObjectP[Model[Container, Rack]]},
			(* the 3rd input causes this warning message since the sample mass is there but not trustworthy *)
			Messages:>{
				Warning::SampleMassMayBeInaccurate
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],

		Test["Batching field is properly populated (testing all sorts of samples and combinations of options):",
			Module[{myProtocol},
				myProtocol=ExperimentMeasureWeight[
						{
							(* 1) one empty container *)
							Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],

							(* 2) one regular  container with sample but mass is not trusted  - needs TransferContainer *)
							Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],

							(* 3) one container with sample with trustworthy mass, with TransferContainer specified *)
							Object[Container,Vessel,"50ml container 9 for ExperimentMeasureWeight testing"<> $SessionUUID],

							(* 4) one container with sample with non-trustworthy mass where CalibrateContainer is set to True *)
							Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],

							(* 5) Container that needs scouting (and does have TareWeight so won't get transferred) *)
							Object[Container,Vessel,"50ml container without PreferredBalance for ExperimentMeasureWeight testing"<> $SessionUUID]
						},
						TransferContainer->{Automatic,Automatic,Object[Container,Vessel,"Empty 50ml container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],Automatic,Automatic},
						CalibrateContainer->{Automatic,Automatic,Automatic,True,Automatic},
						Instrument->{Model[Instrument,Balance,"id:rea9jl5Vl1ae"],Automatic,Automatic,Automatic,Automatic}
				];
				{Download[myProtocol,Batching],Lookup[Download[myProtocol,Batching],Index]}
			],
			(* Note that these are resorted by the balance so they are not in the order that they were submitted *)
			(* Note that because we now use Sample Object ID instead of Sample Object Name, the sorting of samples using the same Balance may be different every time *)
			{
				{
					(* 5 *)
					<|
						WorkingContainerIn -> Null,
						ContainerIn -> ObjectP[Object[Container, Vessel, "50ml container without PreferredBalance for ExperimentMeasureWeight testing" <> $SessionUUID]],
						ScoutBalance -> ObjectP[Model[Instrument, Balance, "id:aXRlGn6V7Jov"]],
						Balance -> Null,
						Pipette -> Null,
						PipetteTips -> Null,
						WeighPaper -> Null,
						WeighBoat -> Null,
						TransferContainer -> Null,
						Holder -> ObjectP[Model[Container, Rack]],
						CalibrateContainer -> False,
						SortingIndex -> 5,
						Index -> 1,
						HandlingEnvironment -> Null,
						CoveredContainer -> Null
					|>,
					(* 1 *)
					<|
						WorkingContainerIn -> Null,
						ContainerIn -> ObjectP[Object[Container, Vessel, "Empty 50ml container for ExperimentMeasureWeight testing" <> $SessionUUID]],
						ScoutBalance -> Null,
						Balance -> ObjectP[Model[Instrument, Balance, "id:rea9jl5Vl1ae"]],
						Pipette -> Null,
						PipetteTips -> Null,
						WeighPaper -> Null,
						WeighBoat -> Null,
						TransferContainer -> Null,
						Holder -> ObjectP[Model[Container, Rack]],
						CalibrateContainer -> True,
						SortingIndex -> 1,
						Index -> 2,
						HandlingEnvironment -> ObjectP[],
						CoveredContainer -> Null
					|>,
					(* 2 *)
					<|
						WorkingContainerIn -> Null,
						ContainerIn -> ObjectP[Object[Container, Vessel, "50ml container 1 for ExperimentMeasureWeight testing" <> $SessionUUID]],
						ScoutBalance -> Null,
						Balance -> ObjectP[Model[Instrument, Balance]],
						Pipette -> Null,
						PipetteTips -> Null,
						WeighPaper -> ObjectP[Model[Item, Consumable, "id:3em6Zv9Njj5W"]],
						WeighBoat -> Null,
						TransferContainer -> ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]],
						Holder -> ObjectP[Model[Container, Rack]],
						CalibrateContainer -> False,
						SortingIndex -> 2,
						Index -> 3,
						HandlingEnvironment -> ObjectP[],
						CoveredContainer -> Null
					|>,
					(* 3 *)
					<|
						WorkingContainerIn -> Null,
						ContainerIn -> ObjectP[Object[Container, Vessel, "50ml container 9 for ExperimentMeasureWeight testing" <> $SessionUUID]],
						ScoutBalance -> Null,
						Balance -> ObjectP[Model[Instrument, Balance]],
						Pipette -> Null,
						PipetteTips -> Null,
						WeighPaper -> ObjectP[Model[Item, Consumable, "id:3em6Zv9Njj5W"]],
						WeighBoat -> Null,
						TransferContainer -> ObjectP[Object[Container, Vessel, "Empty 50ml container 2 for ExperimentMeasureWeight testing" <> $SessionUUID]],
						Holder -> ObjectP[Model[Container, Rack]],
						CalibrateContainer -> False,
						SortingIndex -> 3,
						Index -> 4,
						HandlingEnvironment -> ObjectP[],
						CoveredContainer -> Null
					|>,
					(* 4 *)
					<|
						WorkingContainerIn -> Null,
						ContainerIn -> ObjectP[Object[Container, Vessel, "50ml container 3 for ExperimentMeasureWeight testing" <> $SessionUUID]],
						ScoutBalance -> Null,
						Balance -> ObjectP[Model[Instrument, Balance]],
						Pipette -> Null,
						PipetteTips -> Null,
						WeighPaper -> Null,
						WeighBoat -> Null,
						TransferContainer -> Null,
						Holder -> ObjectP[Model[Container, Rack]],
						CalibrateContainer -> True,
						SortingIndex -> 4,
						Index -> 5,
						HandlingEnvironment -> ObjectP[],
						CoveredContainer -> Null
					|>
				},
				{1,2,3,4,5}
			},
			(* the 4th input causes this warning message since the sample mass is there but not trustworthy *)
			Messages:>{
				Warning::SampleMassMayBeInaccurate
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			TimeConstraint->600
		],

    (* some shared options *)
    Example[{Options,Confirm,"Indicate that the protocol should be moved directly into the queue:"},
      Download[
        ExperimentMeasureWeight[Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],Confirm->True],
        Status
      ],
		Processing|ShippingMaterials|Backlogged,
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
    ],

		Example[{Options,CanaryBranch,"Specify the CanaryBranch on which the protocol is run:"},
			Download[
				ExperimentMeasureWeight[Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],CanaryBranch->"d1cacc5a-948b-4843-aa46-97406bbfc368"],
				CanaryBranch
			],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Stubs:>{
				$EmailEnabled=False,
				GitBranchExistsQ[___] = True, InternalUpload`Private`sllDistroExistsQ[___] = True,
				$PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]
			}
		],

    Example[{Options,Name,"Give the protocol to be created a unique identifier which can be used instead of its ID:"},
      Download[
        ExperimentMeasureWeight[Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],Name->"My Favorite Weight Measurement Protocol"<> $SessionUUID],
        Name
      ],
      "My Favorite Weight Measurement Protocol"<> $SessionUUID,
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
    ],

    Example[{Options,NumberOfReplicates,"Indicate that each measurement should be repeated 3 times and the results should be averaged:"},
      Download[
        ExperimentMeasureWeight[{
          Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
          Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID]},
        NumberOfReplicates->3
        ],
        SamplesIn[Name]
      ],
      {
				"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID,
        "Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID,
        "Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID,
        "Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID,
        "Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID,
        "Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID
      },
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
    ],

		Example[{Options, Template, "Indicate that all the same options used for a previous protocol should be used again for the current protocol:"},
			Module[{templateMWProtocol, repeatProtocol},
				(* Create an initial protocol *)
				templateMWProtocol = ExperimentMeasureWeight[Object[Sample, "Available solid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], TransferContainer -> Model[Container, Vessel, "id:bq9LA0dBGGR6"]];

				(* Create another protocol which will exactly repeat the first, for a different sample though *)
				repeatProtocol = ExperimentMeasureWeight[Object[Sample, "Available solid sample 2 for ExperimentMeasureWeight testing" <> $SessionUUID], Template -> templateMWProtocol];

				MapThread[
					MatchQ[#1, #2]&,
					Lookup[
						Download[{templateMWProtocol, repeatProtocol}, ResolvedOptions],
						{Instrument, TransferContainer, CalibrateContainer}
					]
				]
			],
			{True, True, True},
			Stubs :> {
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled = False
			}
		],

    Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
      Lookup[ExperimentMeasureWeight[Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
        SamplesInStorageCondition -> Refrigerator, Output->Options],SamplesInStorageCondition],
      Refrigerator
    ],

    Example[{Options,SamplesOutStorageCondition,"Indicates how the output samples of the experiment should be stored:"},
      Lookup[ExperimentMeasureWeight[Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
        SamplesOutStorageCondition -> Refrigerator, Output->Options],SamplesOutStorageCondition],
      Refrigerator
    ],

		(* --- InSitu Testing --- *)
		Test["InSitu option will upload InSitu to the protocol object:",
			protObjX = ExperimentMeasureWeight[{Object[Sample,"Sample on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID]},InSitu->True];
			Download[protObjX,InSitu],
			True,
			Variables :> {protObjX}
		],
		Test["InSitu protocol will pick the Instrument the tubes are in for its instrument resource:",
			protObjX = ExperimentMeasureWeight[{Object[Sample,"Sample on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID]},InSitu->True];
			Download[protObjX,Batching[[All,Balance]][Object]],
			{Download[Object[Instrument,Balance,"Fake Balance 1 Testing MeasureWeight"<> $SessionUUID],Object]},
			Variables :> {protObjX}
		],
		Test["InSitu protocol will pick the Instrument the tubes are, even if they are in a rack, in for its instrument resource:",
			protObjX = ExperimentMeasureWeight[{Object[Sample,"Sample in rack on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID]},InSitu->True];
			Download[protObjX,Batching[[All,Balance]][Object]],
			{Download[Object[Instrument,Balance,"Fake Balance 2 Testing MeasureWeight"<> $SessionUUID],Object]},
			Variables :> {protObjX}
		],
		Test["InSitu option causes an Error if TransferContainer is also specified:",
			ExperimentMeasureWeight[{Object[Sample,"Sample on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID]},InSitu->True,TransferContainer->Model[Container,Vessel,"50mL Tube"]],
			$Failed,
			Messages :> {Error::InSituTransferContainer,Error::InvalidOption}
		],
		Test["InSitu option causes an Error if the samples location is not currently on an instrument:",
			ExperimentMeasureWeight[{Object[Sample,"Sample in rack not on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID]},InSitu->True],
			$Failed,
			Messages :> {Error::InSituImpossible,Error::InvalidOption}
		],


		(* SHARED SAMPLE PREP TESTS *)

		(* Note that for most of these the sample needs to be liquid and for most tests requires Volume to be informed and above 1.5*Milliliter *)
		(* Relevant fields for Centrifuge are Footprint in Model[Container], the function CentrifugeDevices, the field MinTemperature/MaxTemperature in Centrifuge *)
		(* Useful for Filter is to run ExperimentFilter with Output->Options and see what the Automatic resolves to for your particualr container / volume *)

		(* THIS TEST IS TURNS ON ALL THE BOOLEAN MASTER SWITCHES -> AUTOMATIC RESOLUTION *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
		  options=ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], Incubate->True, Centrifuge->True, Filtration->True, Aliquot->True, Output -> Options];
		  {Lookup[options, Incubate],Lookup[options, Centrifuge],Lookup[options, Filtration],Lookup[options, Aliquot]},
		  {True,True,True,True},
		  Variables :> {options},
				TimeConstraint->600
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			options = ExperimentMeasureWeight[
				(* Caffeine *)
				{Model[Sample, "id:L8kPEjNLDDBP"], Model[Sample, "id:L8kPEjNLDDBP"]},
				PreparedModelAmount -> 500 Milligram,
				(* 2mL Tube *)
				PreparedModelContainer -> Model[Container, Vessel, "id:3em6Zv9NjjN8"],
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				(* Caffeine *)
				{ObjectP[Model[Sample, "id:L8kPEjNLDDBP"]]..},
				(* 2mL Tube *)
				{ObjectP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]]..},
				{EqualP[500 Milligram]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentMeasureWeight[
				Model[Sample, "Ammonium hydroxide"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, MeasureWeight]]
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for ExperimentMeasureWeight:"},
			Download[ExperimentMeasureWeight["My NestedIndexMatching Sample"<> $SessionUUID,
				PreparatoryUnitOperations-> {
					LabelContainer[
						Label->"My NestedIndexMatching Sample"<> $SessionUUID,
						Container->Model[Container,Vessel,"2mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Isopropanol"],
						Amount->30*Microliter,
						Destination->{"My NestedIndexMatching Sample"<> $SessionUUID}
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Amount->30*Microliter,
						Destination->{"My NestedIndexMatching Sample"<> $SessionUUID}
					]
				}
			],PreparatoryUnitOperations],
			{SamplePreparationP..}
		],
  	(* ExperimentIncubate tests. *)
    Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
      options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], Incubate -> True, Output -> Options];
      Lookup[options, Incubate],
      True,
      Variables :> {options}
    ],
    Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
      options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
      Lookup[options, IncubationTemperature],
      40*Celsius,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
      options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
      Lookup[options, IncubationTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
      options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
      Lookup[options, MaxIncubationTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
      options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
      Lookup[options, IncubationInstrument],
      ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
      Variables :> {options}
    ],
    Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
      options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
      Lookup[options, AnnealingTime],
      40*Minute,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
      options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], IncubateAliquot -> 1.5*Milliliter, Output -> Options];
      Lookup[options, IncubateAliquot],
      1.5*Milliliter,
      EquivalenceFunction -> Equal,
      Variables :> {options}
    ],
    Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
      options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
      Lookup[options, IncubateAliquotContainer],
      {1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
      Variables :> {options}
    ],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotDestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotDestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options, DestinationWell, "Indicates the desired position in the corresponding DestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

	(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], CentrifugeTime -> 5*Minute,CentrifugeInstrument->Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeTime],
			5*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

	(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		(* this test requires a 50ml tube and FilterMaterial HAS to be set to PTFE, and the volume needs to be between 1.5 and 50ml *)
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FilterMaterial->PTFE, PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		(* This test needs Volume 50ml *)
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentMeasureWeight[Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
(* we will revisit this and change FilterSterile to make better sense with this task https://app.asana.com/1/84467620246/task/1209775340905665?focus=true
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			SetUp :> (
				Upload[
					<|
						Object -> Object[Sample, "Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Volume -> 0.2Milliliter
					|>
				];
			),
			TearDown :> (
				Upload[
					<|
						Object -> Object[Sample, "Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
						Volume -> 50Milliliter
					|>
				];
			)
		],*)
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FilterAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "15mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "15mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "15mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "15mL Tube"]]},
			Variables :> {options}
		],
	(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], AliquotAmount -> 0.08 Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], TargetConcentration -> 1*Millimolar, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConentration for dilution of aliquots of SamplesIn:"},
			options = ExperimentMeasureWeight[Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID], TargetConcentration -> 0.1Molar, TargetConcentrationAnalyte -> Model[Molecule, "Ethanol"], Output -> Options];
			Lookup[options, TargetConcentration],
			0.1Molar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AssayVolume->50*Microliter,AliquotAmount->25*Microliter,Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AssayVolume->50*Microliter,AliquotAmount->25*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AssayVolume->50*Microliter,AliquotAmount->25*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],AssayVolume->50*Microliter,AliquotAmount->25*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}},
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			Download[
				ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], ImageSample -> True],
				ImageSample
			],
			True
		],
		Test["Does not populate MeasureVolume or MeasureWeight:",
			Download[
				ExperimentMeasureWeight[Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID], ImageSample -> True],
				{MeasureVolume,MeasureWeight}
			],
			{Null,Null}
		],
		Test["Filters out any immobile containers if there's a parent protocol:",
			ExperimentMeasureWeight[
				{Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],Object[Container,Vessel,"Immobile container for ExperimentMeasureWeight testing"<> $SessionUUID]},
				ParentProtocol->Object[Protocol,HPLC,"HPLC Parent for ExperimentMeasureWeight testing"<> $SessionUUID]
			][ContainersIn],
			{ObjectP[]}
		],
		Test["Filters out any ampoule containers if there's a parent protocol:",
			ExperimentMeasureWeight[
				{Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],Object[Container,Vessel,"Ampoule container 1 for ExperimentMeasureWeight testing"<> $SessionUUID]},
				ParentProtocol->Object[Protocol,HPLC,"HPLC Parent for ExperimentMeasureWeight testing"<> $SessionUUID]
			][ContainersIn],
			{ObjectP[]}
		],
		Example[{Messages,"ImmobileSamples","Immobile samples cannot be measured because there are fixed in place:"},
			ExperimentMeasureWeight[
				{Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],Object[Container,Vessel,"Immobile container for ExperimentMeasureWeight testing"<> $SessionUUID]}
			],
			$Failed,
			Messages:>{Error::ImmobileSamples,Error::InvalidInput}
		],
		(*If there is Living sample in the input that has a disposable cover, and it does not have a parent protocol, throw a warning*)
		Example[{Messages,"LivingOrSterileSamplesQueuedForMeasureWeight","Queueing living samples that has a disposable cover will cause a warning, but a protocol can still be generated:"},
			Download[ExperimentMeasureWeight[Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <>
						$SessionUUID]],
				{Object, ContainersIn}
			],
			{
				ObjectP[Object[Protocol,MeasureWeight]],
				{ObjectP[Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID][Container]]}
			},
			Messages:>{Warning::LivingOrSterileSamplesQueuedForMeasureWeight},
			SetUp:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Living -> True|>,
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID][Container][Object], Cover -> Link[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], CoveredContainer]|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> False|>
			}]),
			TearDown:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Living -> Null|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> Null|>
			}];
			EraseLink[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID][CoveredContainer]])
		],
		(*If there is living/sterile sample in the input that has a disposable cover , and it does not have a parent protocol, throw a warning*)
		Example[{Messages,"LivingOrSterileSamplesQueuedForMeasureWeight","Queueing sterile samples that has a disposable cover will cause a warning, but a protocol can still be generated:"},
			Download[ExperimentMeasureWeight[Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <>
					$SessionUUID]],
				{Object, ContainersIn}
			],
			{
				ObjectP[Object[Protocol,MeasureWeight]],
				{ObjectP[Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID][Container]]}
			},
			Messages:>{Warning::LivingOrSterileSamplesQueuedForMeasureWeight},
			SetUp:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Sterile -> True|>,
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID][Container][Object], Cover -> Link[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], CoveredContainer]|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> False|>
			}]),
			TearDown:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Sterile -> Null|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> Null|>
			}];
			EraseLink[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID][CoveredContainer]])
		],
		(*If there is sterile/sterile sample in the input that has a reusable cover , and it does not have a parent protocol, throw a warning*)
		Test["Queueing sterile samples that has a reusable cover will not cause a warning and a protocol will be generated:",
			Download[ExperimentMeasureWeight[Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <>
					$SessionUUID]],
				{Object, ContainersIn}
			],
			{
				ObjectP[Object[Protocol,MeasureWeight]],
				{ObjectP[Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID][Container]]}
			},
			SetUp:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Sterile -> True|>,
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID][Container][Object], Cover -> Link[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], CoveredContainer]|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> True|>
			}]),
			TearDown:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Sterile -> Null|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> Null|>
			}];
			EraseLink[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID][CoveredContainer]])
		],
		(*If there is Living sample in the input with a disposable cover, and it has a parent protocol, quietly filter the sample out, and if no sample is left, return failed to proceed*)
		Test["Living samples that has a disposable cover will be filtered out without a warning if there is a parent protocol:",
			ExperimentMeasureWeight[Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <>
					$SessionUUID],
				ParentProtocol->Object[Protocol,HPLC,"HPLC Parent for ExperimentMeasureWeight testing"<> $SessionUUID]
			],
			$Failed,
			SetUp:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Living -> True|>,
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID][Container][Object], Cover -> Link[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], CoveredContainer]|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> False|>
			}]),
			TearDown:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Living -> Null|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> Null|>
			}];
			EraseLink[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID][CoveredContainer]])
		],
		(*If there is Sterile sample in the input with a disposable cover, and it has a parent protocol, quietly filter the sample out, and if no sample is left, return failed to proceed*)
		Test["Sterile samples that has a disposable cover will be filtered out without a warning if there is a parent protocol:",
			Download[
				ExperimentMeasureWeight[
					{Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
						Object[Sample, "Available liquid sample 2 for ExperimentMeasureWeight testing" <> $SessionUUID]},
				ParentProtocol->Object[Protocol,HPLC,"HPLC Parent for ExperimentMeasureWeight testing"<> $SessionUUID]
			], {Object, ContainersIn}],
			{
				ObjectP[Object[Protocol,MeasureWeight]],
				{ObjectP[Object[Sample, "Available liquid sample 2 for ExperimentMeasureWeight testing" <> $SessionUUID][Container]]}
			},
			SetUp:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Sterile -> True|>,
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID][Container][Object], Cover -> Link[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], CoveredContainer]|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> False|>
			}]),
			TearDown:>(Upload[{
				<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], Sterile -> Null|>,
				<|Object -> Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID], Reusable -> Null|>
			}];
			EraseLink[Object[Item, Cap, "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID][CoveredContainer]])
		],
		Test["Simulation function properly transfers samples to TransferContainers if all inputs require a transfer:",
			Module[{mySamples,protocol,simulation,beforeMasses, simulatedMasses, expectedTransferContainerModels, simulatedTransferContainerModels},
				mySamples = {
					Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
					Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
					Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
					Object[Sample,"Available counted sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
					Object[Sample,"Available counted sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID]
				};
				{protocol,simulation} = ExperimentMeasureWeight[
					mySamples,
					Output -> {Result,Simulation}
				];
				beforeMasses = Download[mySamples,Mass];
				simulatedMasses = Download[mySamples,Mass,Simulation->simulation];
				expectedTransferContainerModels=Download[protocol,Batching[[All,TransferContainer]][Object]];
				simulatedTransferContainerModels= Flatten[Download[mySamples,TransfersOut[[All,3]][Container][Model][Object],Simulation->simulation]];
				{
					beforeMasses,
					simulatedMasses,
					expectedTransferContainerModels,
					simulatedTransferContainerModels
				}
			],
			{
				{EqualP[2.5 Gram]..},
				{EqualP[0 Gram]..},
				{ObjectP[Model[Container, Vessel, "50mL Tube"]]..},
				{ObjectP[Model[Container, Vessel, "50mL Tube"]]..}
			}
		],
		Test["Simulation function properly transfers samples to TransferContainers if transfer containers are objects:",
			Module[{mySamples,protocol,simulation,beforeMasses, simulatedMasses, expectedTransferContainerModels, simulatedTransferContainerModels},
				mySamples = {
					Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<>$SessionUUID],
					Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
					Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID]
				};
				{protocol,simulation} = ExperimentMeasureWeight[
					mySamples,
					TransferContainer -> {
						Null,
						Automatic,
						Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID]
					},
					Output -> {Result,Simulation}
				];
				beforeMasses = Download[mySamples,Mass];
				simulatedMasses = Download[mySamples,Mass,Simulation->simulation];
				expectedTransferContainerModels=Download[protocol,Batching[[All,TransferContainer]][Object]];
				simulatedTransferContainerModels= Flatten[Download[mySamples,TransfersOut[[All,3]][Container][Model][Object],Simulation->simulation]];
				{
					beforeMasses,
					simulatedMasses,
					expectedTransferContainerModels,
					simulatedTransferContainerModels
				}
			],
			{
				{EqualP[2.5 Gram],EqualP[2.5 Gram],EqualP[2.5 Gram]},
				{EqualP[2.5 Gram],EqualP[0 Gram],EqualP[0 Gram]},
				{OrderlessPatternSequence[Null,ObjectP[Model[Container, Vessel, "50mL Tube"]],ObjectP[Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID]]]},
				{ObjectP[Model[Container, Vessel, "50mL Tube"]],ObjectP[Model[Container, Vessel, "Model container without tare weight for ExperimentMeasureWeight testing" <> $SessionUUID]]}
			}
		],
		Test["Simulation function properly transfers samples to TransferContainers if some inputs require a transfer:",
			Module[{mySamples,protocol,simulation,beforeMasses, simulatedMasses, expectedTransferContainerModels, simulatedTransferContainerModels},
				mySamples = {
					Object[Sample,"Sample without PreferredBalance for ExperimentMeasureWeight testing" <> $SessionUUID],
					Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
					Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<>$SessionUUID],
					Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
					Object[Sample,"Available counted sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
					Object[Sample,"Available counted sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID]
				};
				{protocol,simulation} = ExperimentMeasureWeight[
					mySamples,
					Output -> {Result,Simulation}
				];
				beforeMasses = Download[mySamples,Mass];
				simulatedMasses = Download[mySamples,Mass,Simulation->simulation];
				expectedTransferContainerModels=Download[protocol,Batching[[All,TransferContainer]][Object]];
				simulatedTransferContainerModels= Flatten[Download[mySamples,TransfersOut[[All,3]][Container][Model][Object],Simulation->simulation]];
				{
					beforeMasses,
					simulatedMasses,
					expectedTransferContainerModels,
					simulatedTransferContainerModels
				}
			],
			{
				{EqualP[2.5 Gram]..},
				{EqualP[2.5 Gram],EqualP[0 Gram],EqualP[2.5 Gram],EqualP[0 Gram],EqualP[0 Gram],EqualP[0 Gram]},
				{OrderlessPatternSequence[Null,ObjectP[Model[Container, Vessel, "50mL Tube"]],ObjectP[Model[Container, Vessel, "50mL Tube"]],ObjectP[Model[Container, Vessel, "50mL Tube"]],ObjectP[Model[Container, Vessel, "50mL Tube"]],Null]},
				{ObjectP[Model[Container, Vessel, "50mL Tube"]]..}
			}
		],
		Test["Simulation function returns properly if no inputs require a transfer to a TransferContainer:",
			Module[{mySamples,protocol,simulation,beforeMasses, simulatedMasses, expectedTransferContainerModels, simulatedTransferContainerModels},
				mySamples = {
					Object[Sample,"Sample without PreferredBalance for ExperimentMeasureWeight testing" <> $SessionUUID],
					Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<>$SessionUUID]
				};
				{protocol,simulation} = ExperimentMeasureWeight[
					mySamples,
					Output -> {Result,Simulation}
				];
				beforeMasses = Download[mySamples,Mass];
				simulatedMasses = Download[mySamples,Mass,Simulation->simulation];
				expectedTransferContainerModels=Download[protocol,Batching[[All,TransferContainer]][Object]];
				simulatedTransferContainerModels= Flatten[Download[mySamples,TransfersOut[[All,3]][Container][Model][Object],Simulation->simulation]];
				{
					beforeMasses,
					simulatedMasses,
					expectedTransferContainerModels,
					simulatedTransferContainerModels
				}
			],
			{
				{EqualP[2.5 Gram],EqualP[2.5 Gram]},
				{EqualP[2.5 Gram],EqualP[2.5 Gram]},
				{Null,Null},
				{}
			}
		]
	},
	SymbolSetUp:> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		ClearMemoization[];
		$CreatedObjects={};

     Module[{allObjects,existingObjects},
			 (*Gather all the objects and models created in SymbolSetUp*)
			 allObjects= {
				 (* bench *)
				 Object[Container,Bench, "Fake bench for MeasureWeight testing"<> $SessionUUID],
				 Object[Container,Rack,"Fake Rack 1 Testing MeasureWeight"<> $SessionUUID],
				 Object[Container,Rack,"Fake Rack 2 Testing MeasureWeight"<> $SessionUUID],
				 (* containers *)
				 Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"Empty 50ml container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"Empty 50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 4 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 5 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 6 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 7 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 8 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 9 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 10 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 11 with Model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 12 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 13 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container 14 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"Immobile container for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Plate,"96-well plate for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"Micro container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"Micro container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"Micro container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"Micro container 4 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"Ampoule container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Container,Vessel,"50ml container without PreferredBalance for ExperimentMeasureWeight testing"<> $SessionUUID],
				 (* samples *)
				 Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Special liquid sample without a model for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Available counted sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Available counted sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Discarded sample for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Available sample in plate for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample with no Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Ventilated sample for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample without PreferredBalance for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample in Microcontainer with Trusted Large Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample in Microcontainer with Non-Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample in Microcontainer with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample in 50ml container with super-heavy Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample without container for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample in immobile container for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample in ampoule for InSitu ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample in rack on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Sample in rack not on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Sample,"Fuming sample in covered container for ExperimentMeasureWeight testing" <> $SessionUUID],
				 Object[Sample,"Fuming sample 2 in covered container for ExperimentMeasureWeight testing" <> $SessionUUID],
				 (* other objects *)
				 Object[Protocol,MeasureWeight,"My Favorite Weight Measurement Protocol"<> $SessionUUID],
				 Object[Protocol,HPLC,"HPLC Parent for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Instrument,Balance,"Fake Balance 1 Testing MeasureWeight"<> $SessionUUID],
				 Object[Instrument,Balance,"Fake Balance 2 Testing MeasureWeight"<> $SessionUUID],
				 Object[Maintenance,ReceiveInventory,"Receiving protocol for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[User,Emerald,"Operator for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Object[Item,Cap,"Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID],
				 (* model *)
				 Model[Container,Vessel,"Model container without PreferredBalance for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Model[Container,Vessel,"Model container without tare weight for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Model[Container,Vessel,"Model container without tare weight prefer Bulk for ExperimentMeasureWeight testing"<> $SessionUUID],
				 Model[Item, Cap, "Test cap model 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
				 Object[Container, Vessel, "Test covered container 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
				 Object[Container, Vessel, "Test covered container 2 for ExperimentMeasureWeight testing" <> $SessionUUID],
				 Object[Item, Cap, "Test cap 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
				 Object[Item, Cap, "Test cap 2 for ExperimentMeasureWeight testing" <> $SessionUUID],
				 Object[Item, Cap, "Test cap 3 for ExperimentMeasureWeight testing" <> $SessionUUID],
				 Model[Item, Lid, "Test lid model 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
				 Object[Item, Lid, "Test lid 1 for ExperimentMeasureWeight testing" <> $SessionUUID]
			 };

			 (*Check whether the names we want to give below already exist in the database*)
			 existingObjects=PickList[allObjects, DatabaseMemberQ[allObjects]];

			 (*Erase any test objects and models that we failed to erase in the last unit test*)
			 Quiet[EraseObject[existingObjects, Force -> True, Verbose -> False]]
		 ];

		Block[{$DeveloperUpload = True},
			Module[{
				fakeBench, emptyContainer, secondEmptyContainer, thirdEmptyContainer, emptyContainer1, emptyContainer2,
				emptyContainer3, emptyContainer4, emptyContainer5, emptyContainer6, emptyContainer7, emptyContainer8,
				emptyContainer9, emptyContainer10, emptyContainer11, emptyContainer12, emptyContainer13, emptyMicroContainer1,
				emptyMicroContainer2, emptyMicroContainer3, selfStandingContainer, immobileContainer, ampouleContainer,
				emptyPlate, fakeRack1, fakeRack2,
				fakeBalance1, fakeBalance2, noPreContainerModel, noTareContainerModel, noTareContainerModel2, containerWithoutPrefBalance, noTareContainer,
				cap1, cap2, cap3, lid1, capModel1, lidModel1, containerToBeCovered1, containerToBeCovered2
			},


				(* upload to make cover models *)
				{capModel1, lidModel1} = Upload[{
					<|
						Type -> Model[Item, Cap],
						Name -> "Test cap model 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DeveloperObject -> True
					|>,
					<|
						Type -> Model[Item, Lid],
						Name -> "Test lid model 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						PreferredBalance -> Analytical,
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DeveloperObject -> True
					|>
				}];

				(* Create fake bench and rack for vessels *)
				fakeBench = Upload[<|
					Type -> Object[Container, Bench],
					Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
					Name -> "Fake bench for MeasureWeight testing" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];
				fakeRack1 = Upload[<|
					Type -> Object[Container, Rack],
					Model -> Link[Model[Container, Rack, "50mL Tube Stand"], Objects],
					Name -> "Fake Rack 1 Testing MeasureWeight" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];
				Upload[<|Object -> fakeRack1, Position -> "Weighing Slot"|>];
				fakeRack2 = Upload[<|
					Type -> Object[Container, Rack],
					Model -> Link[Model[Container, Rack, "50mL Tube Stand"], Objects],
					Name -> "Fake Rack 2 Testing MeasureWeight" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>];

				(* Upload instruments *)
				{
					fakeBalance1,
					fakeBalance2
				} = Upload[
					{
						<|Type -> Object[Instrument, Balance],
							Model -> Link[Model[Instrument, Balance, "Mettler Toledo XP6"], Objects],
							Name -> "Fake Balance 1 Testing MeasureWeight" <> $SessionUUID,
							Status -> Running,
							Site -> Link[$Site],
							DeveloperObject -> True|>,
						<|Type -> Object[Instrument, Balance],
							Model -> Link[Model[Instrument, Balance, "Ohaus Pioneer PA124"], Objects],
							Name -> "Fake Balance 2 Testing MeasureWeight" <> $SessionUUID,
							Status -> Running,
							Site -> Link[$Site],
							Append[Contents] -> {{"Weighing Slot", Link[fakeRack1, Container]}},
							DeveloperObject -> True|>
					}
				];

				(* Create container models. *)
				{
					noPreContainerModel,
					noTareContainerModel,
					noTareContainerModel2
				} = Upload[{
					<|Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						MaxVolume -> 50 * Milliliter,
						SelfStanding -> False,
						DisposableCaps -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> 0.02 * Meter, MaxDepth -> 0.02 * Meter, MaxHeight -> 0.02 * Meter|>},
						Name -> "Model container without PreferredBalance for ExperimentMeasureWeight testing" <> $SessionUUID|>,
					<|Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						MaxVolume -> 50 * Milliliter,
						SelfStanding -> False,
						DisposableCaps -> True,
						PreferredBalance -> Analytical,
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> Quantity[0.028575, "Meters"], MaxDepth -> Quantity[0.028575, "Meters"], MaxHeight -> Quantity[0.1143, "Meters"]|>},
						Name -> "Model container without tare weight for ExperimentMeasureWeight testing" <> $SessionUUID|>,
					<|Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						MaxVolume -> 20 Liter,
						SelfStanding -> False,
						DisposableCaps -> True,
						PreferredBalance -> Bulk,
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null, MaxWidth -> Quantity[0.028575, "Meters"], MaxDepth -> Quantity[0.028575, "Meters"], MaxHeight -> Quantity[0.1143, "Meters"]|>},
						Name -> "Model container without tare weight prefer Bulk for ExperimentMeasureWeight testing" <> $SessionUUID|>
				}];

				(* Create containers from newly generated container models *)
				{containerWithoutPrefBalance, noTareContainer} = Upload[{
					<|Type -> Object[Container, Vessel], TareWeight -> 1 * Gram, Model -> Link[noPreContainerModel, Objects], DeveloperObject -> True, Name -> "50ml container without PreferredBalance for ExperimentMeasureWeight testing" <> $SessionUUID, Site -> Link[$Site]|>,
					<|Type -> Object[Container, Vessel], Model -> Link[noTareContainerModel, Objects], DeveloperObject -> True, Name -> "50ml container 14 for ExperimentMeasureWeight testing" <> $SessionUUID, Site -> Link[$Site]|>
				}];

				(* Create empty containers. *)
				{
					emptyContainer,
					secondEmptyContainer,
					thirdEmptyContainer,
					emptyContainer1,
					emptyContainer2,
					emptyContainer3,
					emptyContainer4,
					emptyContainer5,
					emptyContainer6,
					emptyContainer7,
					emptyContainer8,
					emptyContainer9,
					emptyContainer10,
					emptyContainer11,
					emptyContainer12,
					emptyContainer13,
					emptyMicroContainer1,
					immobileContainer,
					ampouleContainer,
					emptyPlate,
					containerToBeCovered1,
					containerToBeCovered2,
					cap1,
					cap2,
					cap3,
					lid1
				} = UploadSample[
					{
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						noTareContainerModel,
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Glass CE Vials"],
						Model[Container, Vessel, "SymphonyX Main Solvent Tank"],
						Model[Container, Vessel, "1mL clear glass ampule"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						noTareContainerModel,
						noTareContainerModel2,
						capModel1,
						capModel1,
						capModel1,
						lidModel1
					},
					{
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"A1", fakeRack1},
						{"A1", fakeRack2},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench},
						{"Work Surface", fakeBench}
					},
					Name -> {
						"Empty 50ml container for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Empty 50ml container 2 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Empty 50ml container 3 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 2 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 3 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 4 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 5 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 6 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 7 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 8 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 9 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 10 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 11 with Model TareWeight for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 12 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"50ml container 13 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Micro container 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Immobile container for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Ampoule container 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"96-well plate for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Test covered container 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Test covered container 2 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Test cap 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Test cap 2 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Test cap 3 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Test lid 1 for ExperimentMeasureWeight testing" <> $SessionUUID
					}
				];

				(* cover the container! *)
				UploadCover[
					{containerToBeCovered1, containerToBeCovered2},
					Cover -> {cap2, cap3}
				];

				(* Create empty containers with tare weight 1 gram. *)
				{
					emptyMicroContainer2,
					emptyMicroContainer3,
					selfStandingContainer
				} = Upload[{
					<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "2mL Glass CE Vials"], Objects], TareWeight -> 1 * Gram, DeveloperObject -> True, Name -> "Micro container 2 for ExperimentMeasureWeight testing" <> $SessionUUID, Site -> Link[$Site]|>,
					<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "2mL Glass CE Vials"], Objects], TareWeight -> 1 * Gram, DeveloperObject -> True, Name -> "Micro container 3 for ExperimentMeasureWeight testing" <> $SessionUUID, Site -> Link[$Site]|>,
					<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "2mL Glass CE Vials"], Objects], TareWeight -> 1 * Gram, DeveloperObject -> True, Name -> "Micro container 4 for ExperimentMeasureWeight testing" <> $SessionUUID, Site -> Link[$Site]|>
				}];

				(* Add position to some container objects *)
				Upload[{
					<|Object -> emptyContainer12, Position -> "A1"|>,
					<|Object -> emptyContainer13, Position -> "A1"|>,
					<|Object -> selfStandingContainer, Position -> "A1"|>
				}];
				Upload[<|Object -> fakeBalance1, Replace[Contents] -> {{"Weighing Slot", Link[selfStandingContainer, Container]}}|>];

				(* Create other objects for testing. *)
				Upload[{
					<|Type -> Object[User, Emerald],
						Model -> Link[Model[User, Emerald, Operator, "Level 1"], Objects],
						Name -> "Operator for ExperimentMeasureWeight testing" <> $SessionUUID,
						DeveloperObject -> True|>,
					<|Type -> Object[Maintenance, ReceiveInventory],
						Name -> "Receiving protocol for ExperimentMeasureWeight testing" <> $SessionUUID,
						DeveloperObject -> True|>,
					<|Type -> Object[Protocol, HPLC],
						Name -> "HPLC Parent for ExperimentMeasureWeight testing" <> $SessionUUID,
						DeveloperObject -> True|>,
					<|Type -> Object[Item, Cap],
						Name -> "Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID,
						DeveloperObject -> True|>
				}];


				(* Create some samples in those containers *)
				(* create a sample without container *)
				Upload[<|Type -> Object[Sample], DeveloperObject -> True, Model -> Link[Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"], Objects], Name -> "Sample without container for ExperimentMeasureWeight testing" <> $SessionUUID, Site -> Link[$Site]|>];
				(* create samples in containers *)
				(* Note sample test models exist in database and do not get deleted each time *)
				UploadSample[
					{
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake Acetonitrile HPLC grade model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake Acetonitrile HPLC grade model for ExperimentMeasureWeight testing"],
						Model[Sample, StockSolution, "Fake 70% Ethanol model for ExperimentMeasureWeight testing"],
						Model[Sample, "Test Count Model 1 for MeasureCount"],
						Model[Sample, "Test Count Model 1 for MeasureCount"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake Acetonitrile HPLC grade model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Isoprene"],
						Model[Sample, "Fake salt chemical model for ExperimentMeasureWeight testing"],
						Model[Sample, "Trifluoroethanol, 99.8%"],
						Model[Sample, "Trifluoroethanol, 99.8%"]
					},
					{
						{"A1", emptyContainer1},
						{"A1", emptyContainer2},
						{"A1", thirdEmptyContainer},
						{"A1", emptyContainer3},
						{"A1", emptyContainer4},
						{"A1", emptyContainer5},
						{"A1", emptyContainer6},
						(* discarded sample: *)
						{"A1", emptyContainer7},
						{"A1", emptyPlate},
						{"A1", emptyContainer8},
						{"A1", emptyContainer9},
						{"A1", containerWithoutPrefBalance},
						{"A1", emptyMicroContainer1},
						{"A1", emptyMicroContainer2},
						{"A1", emptyMicroContainer3},
						{"A1", emptyContainer10},
						{"A1", emptyContainer11},
						{"A1", immobileContainer},
						{"A1", selfStandingContainer},
						{"A1", emptyContainer12},
						{"A1", emptyContainer13},
						{"A1", noTareContainer},
						{"A1", ampouleContainer},
						{"A1", containerToBeCovered1},
						{"A1", containerToBeCovered2}
					},
					Name -> {
						"Available solid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Available solid sample 2 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Special liquid sample without a model for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Available liquid sample 2 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Available counted sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Available counted sample 2 for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Discarded sample for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Available sample in plate for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample with no Mass for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample with Trusted Mass for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample without PreferredBalance for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample in Microcontainer with Trusted Large Mass for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample in Microcontainer with Trusted Mass for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample in Microcontainer with Non-Trusted Mass for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample in 50ml container with super-heavy Mass for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample in immobile container for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample on balance for InSitu ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample in rack on balance for InSitu ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample in rack not on balance for InSitu ExperimentMeasureWeight testing" <> $SessionUUID,
						"Ventilated sample for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Sample in ampoule for InSitu ExperimentMeasureWeight testing" <> $SessionUUID,
						"Fuming sample in covered container for ExperimentMeasureWeight testing" <> $SessionUUID,
						"Fuming sample 2 in covered container for ExperimentMeasureWeight testing" <> $SessionUUID
					}
				];

				(* Make some changes to our samples for testing purposes *)
				Upload[
					{
						<|Object -> Object[Sample, "Available solid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram|>,
						<|Object -> Object[Sample, "Available solid sample 2 for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram|>,
						<|Object -> Object[Sample, "Special liquid sample without a model for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Model -> Null|>,
						<|Object -> Object[Sample, "Available liquid sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram, Volume -> 2 * Milliliter, Concentration -> 1 * Millimolar|>,
						<|Object -> Object[Sample, "Available liquid sample 2 for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram, Volume -> 50 * Milliliter, Replace[Composition] -> {{1Molar, Link[Model[Molecule, "Ethanol"]], Now}}|>,
						<|Object -> Object[Sample, "Available counted sample 1 for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram|>,
						<|Object -> Object[Sample, "Available counted sample 2 for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram|>,
						<|Object -> Object[Sample, "Discarded sample for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Discarded, Mass -> 2.5 * Gram|>,
						<|Object -> Object[Sample, "Available sample in plate for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram|>,
						<|Object -> Object[Sample, "Sample with no Mass for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available|>,
						<|Object -> Object[Sample, "Sample with Trusted Mass for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 5.0 * Gram, Replace[MassLog] -> {{Now, 5.0 * Gram, Link[Object[Maintenance, ReceiveInventory, "Receiving protocol for ExperimentMeasureWeight testing" <> $SessionUUID]], UserSpecified}}|>,
						<|Object -> Object[Sample, "Sample without PreferredBalance for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram|>,
						<|Object -> Object[Sample, "Sample in Microcontainer with Trusted Large Mass for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 50 * Gram, Replace[MassLog] -> {{Now, 50 * Gram, Link[Object[Maintenance, ReceiveInventory, "Receiving protocol for ExperimentMeasureWeight testing" <> $SessionUUID]], UserSpecified}}|>,
						<|Object -> Object[Sample, "Sample in Microcontainer with Trusted Mass for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 0.01 * Gram, Replace[MassLog] -> {{Now, 0.01 * Gram, Link[Object[Maintenance, ReceiveInventory, "Receiving protocol for ExperimentMeasureWeight testing" <> $SessionUUID]], UserSpecified}}|>,
						<|Object -> Object[Sample, "Sample in Microcontainer with Non-Trusted Mass for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 0.01 * Gram|>,
						<|Object -> Object[Sample, "Sample in 50ml container with super-heavy Mass for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 4000 * Gram, Replace[MassLog] -> {{Now, 4000 * Gram, Link[Object[Maintenance, ReceiveInventory, "Receiving protocol for ExperimentMeasureWeight testing" <> $SessionUUID]], UserSpecified}}|>,
						<|Object -> Object[Sample, "Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram, Volume -> 2 * Milliliter, Concentration -> 1 * Millimolar, Replace[Composition] -> {{1 Millimolar, Link[Model[Molecule, "Sodium Chloride"]], Now}, {99 MassPercent, Link[Model[Molecule, "Water"]], Now}}|>,
						<|Object -> Object[Sample, "Sample in immobile container for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True|>,
						<|Object -> Object[Sample, "Sample on balance for InSitu ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True|>,
						<|Object -> Object[Sample, "Sample in rack on balance for InSitu ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True|>,
						<|Object -> Object[Sample, "Sample in rack not on balance for InSitu ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True|>,
						<|Object -> Object[Sample, "Ventilated sample for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> Null|>,
						<|Object -> Object[Sample, "Sample in ampoule for InSitu ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True|>,
						<|Object -> Object[Sample, "Fuming sample in covered container for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 2.5 * Gram, Volume -> 2 * Milliliter, Concentration -> 1 * Millimolar|>,
						<|Object -> Object[Sample, "Fuming sample 2 in covered container for ExperimentMeasureWeight testing" <> $SessionUUID], DeveloperObject -> True, Status -> Available, Mass -> 7000 * Gram, Volume -> 2 * Milliliter, Concentration -> 1 * Millimolar|>
					}
				];
			]
		]
	),

	SymbolTearDown:> (
		Module[{allObjects},
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			ClearMemoization[];
			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects=Cases[Flatten[{
				$CreatedObjects,
				(* bench *)
				Object[Container,Bench, "Fake bench for MeasureWeight testing"<> $SessionUUID],
				Object[Container,Rack,"Fake Rack 1 Testing MeasureWeight"<> $SessionUUID],
				Object[Container,Rack,"Fake Rack 2 Testing MeasureWeight"<> $SessionUUID],
				(* containers *)
				Object[Container,Vessel,"Empty 50ml container for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 4 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 5 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 6 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 7 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 8 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 9 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 10 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 11 with Model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 12 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 13 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container 14 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"Immobile container for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Plate,"96-well plate for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"Micro container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"Micro container 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"Micro container 3 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"Micro container 4 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"Ampoule container 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Container,Vessel,"50ml container without PreferredBalance for ExperimentMeasureWeight testing"<> $SessionUUID],
				(* samples *)
				Object[Sample,"Available solid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available solid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Special liquid sample without a model for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available liquid sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available liquid sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available counted sample 1 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available counted sample 2 for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Discarded sample for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Available sample in plate for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample with no Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Ventilated sample for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample without PreferredBalance for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample in Microcontainer with Trusted Large Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample in Microcontainer with Non-Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample in Microcontainer with Trusted Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample in 50ml container with super-heavy Mass for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample without container for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample in 50ml container with model TareWeight for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample in immobile container for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample in ampoule for InSitu ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample in rack on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Sample in rack not on balance for InSitu ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Sample,"Fuming sample in covered container for ExperimentMeasureWeight testing" <> $SessionUUID],
				Object[Sample,"Fuming sample 2 in covered container for ExperimentMeasureWeight testing" <> $SessionUUID],
				(* other objects *)
				Object[Protocol,MeasureWeight,"My Favorite Weight Measurement Protocol"<> $SessionUUID],
				Object[Protocol,HPLC,"HPLC Parent for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Instrument,Balance,"Fake Balance 1 Testing MeasureWeight"<> $SessionUUID],
				Object[Instrument,Balance,"Fake Balance 2 Testing MeasureWeight"<> $SessionUUID],
				Object[Maintenance,ReceiveInventory,"Receiving protocol for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[User,Emerald,"Operator for ExperimentMeasureWeight testing"<> $SessionUUID],
				Object[Item,Cap,"Test Cover for ExperimentMeasureWeight testing" <> $SessionUUID],
				(* model *)
				Model[Container,Vessel,"Model container without PreferredBalance for ExperimentMeasureWeight testing"<> $SessionUUID],
				Model[Container,Vessel,"Model container without tare weight for ExperimentMeasureWeight testing"<> $SessionUUID],
				Model[Container,Vessel,"Model container without tare weight prefer Bulk for ExperimentMeasureWeight testing"<> $SessionUUID],
				Model[Item, Cap, "Test cap model 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
				Object[Container, Vessel, "Test covered container 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
				Object[Container, Vessel, "Test covered container 2 for ExperimentMeasureWeight testing" <> $SessionUUID],
				Object[Item, Cap, "Test cap 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
				Object[Item, Cap, "Test cap 2 for ExperimentMeasureWeight testing" <> $SessionUUID],
				Object[Item, Cap, "Test cap 3 for ExperimentMeasureWeight testing" <> $SessionUUID],
				Model[Item, Lid, "Test lid model 1 for ExperimentMeasureWeight testing" <> $SessionUUID],
				Object[Item, Lid, "Test lid 1 for ExperimentMeasureWeight testing" <> $SessionUUID]
			}],ObjectP[]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[allObjects, Force->True, Verbose->False]];
			Unset[$CreatedObjects];
		]
	)
];


(* ::Subsubsection:: *)
(*ExperimentMeasureWeightOptions*)

DefineTests[
	ExperimentMeasureWeightOptions,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic,"Generate a table of resolved options for an ExperimentMeasureWeight call to measure the weight of a single sample:"},
			ExperimentMeasureWeightOptions[Object[Sample,"Sample 1 for ExperimentMeasureWeightOptions testing "<>$SessionUUID]],
			_Grid
		],
		Example[
			{Basic,"Generate a table of resolved options for an ExperimentMeasureWeight call to measure the weight of multiple samples:"},
			ExperimentMeasureWeightOptions[{
				Object[Sample,"Sample 2 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightOptions testing "<>$SessionUUID]
			}],
			_Grid
		],
		Example[
			{Basic,"Generate a table of resolved options for an ExperimentMeasureWeight call to measure the weight of a sample in a container:"},
			ExperimentMeasureWeightOptions[Object[Container,Vessel,"Vial 1 for ExperimentMeasureWeightOptions testing "<>$SessionUUID]],
			_Grid
		],

		(* --- Options Examples --- *)
		Example[
			{Options,OutputFormat,"Generate a list of resolved options for an ExperimentMeasureWeight call to measure the weight of multiple samples:"},
			ExperimentMeasureWeightOptions[{
				Object[Sample,"Sample 2 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightOptions testing "<>$SessionUUID]
			},OutputFormat->List],
			_?(MatchQ[
				Check[SafeOptions[ExperimentMeasureWeight,#],$Failed,{Error::Pattern}],
				{(_Rule|_RuleDelayed)..}
			]&)
		]
	},
	SymbolSetUp:>{
		Module[{allObjects,existingObjects,testBench,numberOfSamples,testContainers,testSamples},

			ClearMemoization[];

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Bench,"Bench for ExperimentMeasureWeightOptions testing "<>$SessionUUID],

				Object[Container,Vessel,"Vial 1 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 2 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 3 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 4 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],

				Object[Sample,"Sample 1 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 2 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightOptions testing "<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create the test bench *)
			testBench=Upload[
				<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Bench for ExperimentMeasureWeightOptions testing "<>$SessionUUID,
					DeveloperObject->True
				|>
			];

			(* Set the number of test containers and samples to create *)
			numberOfSamples=4;

			(* Create the test containers *)
			testContainers=UploadSample[
				Array[Model[Container,Vessel,"2mL Glass CE Vials"]&,numberOfSamples],
				Array[{"Work Surface",testBench}&,numberOfSamples],
				Name->Array["Vial "<>ToString[#]<>" for ExperimentMeasureWeightOptions testing "<>$SessionUUID&,numberOfSamples],
				Status->Available
			];

			(* Create the test samples *)
			testSamples=UploadSample[
				Array[Model[Sample,"Sodium Chloride"]&,numberOfSamples],
				Map[{"A1",#}&,testContainers],
				Name->Array["Sample "<>ToString[#]<>" for ExperimentMeasureWeightOptions testing "<>$SessionUUID&,numberOfSamples],
				InitialAmount->Array[#*100 Milligram&,numberOfSamples],
				Status->Available
			];
		];
	},
	SymbolTearDown:>{
		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Bench,"Bench for ExperimentMeasureWeightOptions testing "<>$SessionUUID],

				Object[Container,Vessel,"Vial 1 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 2 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 3 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 4 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],

				Object[Sample,"Sample 1 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 2 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightOptions testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightOptions testing "<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];
		];
	}
];


(* ::Subsubsection:: *)
(*ExperimentMeasureWeightPreview*)

DefineTests[
	ExperimentMeasureWeightPreview,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic,"Generate a preview for an ExperimentMeasureWeight call to measure the weight of a single sample (will always be Null):"},
			ExperimentMeasureWeightPreview[Object[Sample,"Sample 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]],
			Null
		],
		Example[
			{Basic,"Generate a preview for an ExperimentMeasureWeight call to measure the weight of a multiple sample (will always be Null):"},
			ExperimentMeasureWeightPreview[{
				Object[Sample,"Sample 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]
			}],
			Null
		],
		Example[
			{Basic,"Generate a preview for an ExperimentMeasureWeight call to measure the weight of a sample in a container (will always be Null):"},
			ExperimentMeasureWeightPreview[Object[Container,Vessel,"Vial 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]],
			Null
		]
	},
	SymbolSetUp:>{
		Module[{allObjects,existingObjects,testBench,numberOfSamples,testContainers,testSamples},

			ClearMemoization[];

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Bench,"Bench for ExperimentMeasureWeightPreview testing "<>$SessionUUID],

				Object[Container,Vessel,"Vial 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],

				Object[Sample,"Sample 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create the test bench *)
			testBench=Upload[
				<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Bench for ExperimentMeasureWeightPreview testing "<>$SessionUUID,
					DeveloperObject->True
				|>
			];

			(* Set the number of test containers and samples to create *)
			numberOfSamples=4;

			(* Create the test containers *)
			testContainers=UploadSample[
				Array[Model[Container,Vessel,"2mL Glass CE Vials"]&,numberOfSamples],
				Array[{"Work Surface",testBench}&,numberOfSamples],
				Name->Array["Vial "<>ToString[#]<>" for ExperimentMeasureWeightPreview testing "<>$SessionUUID&,numberOfSamples],
				Status->Available
			];

			(* Create the test samples *)
			testSamples=UploadSample[
				Array[Model[Sample,"Sodium Chloride"]&,numberOfSamples],
				Map[{"A1",#}&,testContainers],
				Name->Array["Sample "<>ToString[#]<>" for ExperimentMeasureWeightPreview testing "<>$SessionUUID&,numberOfSamples],
				InitialAmount->Array[#*100 Milligram&,numberOfSamples],
				Status->Available
			];
		];
	},
	SymbolTearDown:>{
		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Bench,"Bench for ExperimentMeasureWeightPreview testing "<>$SessionUUID],

				Object[Container,Vessel,"Vial 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],

				Object[Sample,"Sample 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];
		];
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentMeasureWeightQ*)


DefineTests[
	ValidExperimentMeasureWeightQ,
	{
		(* --- Basic Examples --- *)
		Example[
			{Basic,"Validate an ExperimentMeasureWeight call to measure the weight of a single sample:"},
			ValidExperimentMeasureWeightQ[Object[Sample,"Sample 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]],
			True
		],
		Example[
			{Basic,"Validate an ExperimentMeasureWeight call to measure the weight of multiple samples:"},
			ValidExperimentMeasureWeightQ[{
				Object[Sample,"Sample 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]
			}],
			True
		],
		Example[
			{Basic,"Validate an ExperimentMeasureWeight call to filter to measure the weight of a sample in a container:"},
			ValidExperimentMeasureWeightQ[Object[Container,Vessel,"Vial 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]],
			True
		],

		(* --- Options Examples --- *)
		Example[
			{Options,OutputFormat,"Validate an ExperimentMeasureWeight call to measure the weight of a single sample, returning an ECL Test Summary:"},
			ValidExperimentMeasureWeightQ[Object[Sample,"Sample 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[
			{Options,Verbose,"Validate an ExperimentMeasureWeight call to measure the weight of a single sample, printing a verbose summary of tests as they are run:"},
			ValidExperimentMeasureWeightQ[Object[Sample,"Sample 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],Verbose->True],
			True
		]
	},
	SymbolSetUp:>{
		Module[{allObjects,existingObjects,testBench,numberOfSamples,testContainers,testSamples},

			ClearMemoization[];

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Bench,"Bench for ExperimentMeasureWeightPreview testing "<>$SessionUUID],

				Object[Container,Vessel,"Vial 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],

				Object[Sample,"Sample 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create the test bench *)
			testBench=Upload[
				<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Bench for ExperimentMeasureWeightPreview testing "<>$SessionUUID,
					DeveloperObject->True
				|>
			];

			(* Set the number of test containers and samples to create *)
			numberOfSamples=4;

			(* Create the test containers *)
			testContainers=UploadSample[
				Array[Model[Container,Vessel,"2mL Glass CE Vials"]&,numberOfSamples],
				Array[{"Work Surface",testBench}&,numberOfSamples],
				Name->Array["Vial "<>ToString[#]<>" for ExperimentMeasureWeightPreview testing "<>$SessionUUID&,numberOfSamples],
				Status->Available
			];

			(* Create the test samples *)
			testSamples=UploadSample[
				Array[Model[Sample,"Sodium Chloride"]&,numberOfSamples],
				Map[{"A1",#}&,testContainers],
				Name->Array["Sample "<>ToString[#]<>" for ExperimentMeasureWeightPreview testing "<>$SessionUUID&,numberOfSamples],
				InitialAmount->Array[#*100 Milligram&,numberOfSamples],
				Status->Available
			];
		];
	},
	SymbolTearDown:>{
		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Bench,"Bench for ExperimentMeasureWeightPreview testing "<>$SessionUUID],

				Object[Container,Vessel,"Vial 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],

				Object[Sample,"Sample 1 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 2 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for ExperimentMeasureWeightPreview testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for ExperimentMeasureWeightPreview testing "<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];
		];
	}
];




(* ::Subsubsection:: *)
(* MeasureWeight *)
DefineTests[MeasureWeight,
	{
		Example[{Basic,"Form an MeasureWeight unit operation:"},
			MeasureWeight[
				Sample -> Object[Sample,"Sample 1 for MeasureWeight testing "<>$SessionUUID],
				CalibrateContainer -> True
			],
			MeasureWeightP
		],
		Example[{Basic,"Specifying a key incorrectly will not form a unit operation:"},
			primitive = MeasureWeight[
				Sample -> Object[Sample,"Sample 1 for MeasureWeight testing "<>$SessionUUID],
				TransferContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				CalibrateContainer -> True
			];
			MatchQ[primitive, SamplePreparationP],
			False,
			Variables -> {primitive}
		],
		Example[{Basic,"A protocol is generated when the unit op is inside an MSP:"},
			ExperimentManualSamplePreparation[
				{
					MeasureWeight[
						Sample -> Object[Sample,"Sample 1 for MeasureWeight testing "<>$SessionUUID]
					]
				}
			],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[{Basic,"A protocol is generated when the unit op is given labels as input:"},
			ExperimentManualSamplePreparation[
				{
					LabelSample[
						Sample -> Object[Sample,"Sample 1 for MeasureWeight testing "<>$SessionUUID],
						Label -> "my sample"
					],
					MeasureWeight[
						Sample -> "my sample"
					]
				}
			],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[{Basic,"A protocol is generated when the output of the measure weight is passed to another unit op using a label:"},
			ExperimentManualSamplePreparation[
				{
					MeasureWeight[
						Sample -> Object[Sample,"Sample 1 for MeasureWeight testing "<>$SessionUUID],
						TransferContainer -> Null,
						SampleLabel -> "my weighed sample"
					],
					Transfer[
						Source -> "my weighed sample",
						Destination -> Model[Container, Vessel, "2mL Tube"],
						Amount -> 0.01 Gram
					]
				}
			],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		]
	},
	SymbolSetUp:>{
		Module[{allObjects,existingObjects,testBench,numberOfSamples,testContainers,testSamples},

			ClearMemoization[];

			Off[Warning::SamplesOutOfStock];
			Off[Warning::InstrumentUndergoingMaintenance];

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Bench,"Bench for MeasureWeight testing "<>$SessionUUID],

				Object[Container,Vessel,"Vial 1 for MeasureWeight testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 2 for MeasureWeight testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 3 for MeasureWeight testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 4 for MeasureWeight testing "<>$SessionUUID],

				Object[Sample,"Sample 1 for MeasureWeight testing "<>$SessionUUID],
				Object[Sample,"Sample 2 for MeasureWeight testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for MeasureWeight testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for MeasureWeight testing "<>$SessionUUID]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Create the test bench *)
			testBench=Upload[
				<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"Bench for MeasureWeight testing "<>$SessionUUID,
					DeveloperObject->True
				|>
			];

			(* Set the number of test containers and samples to create *)
			numberOfSamples=4;

			(* Create the test containers *)
			testContainers=UploadSample[
				Array[Model[Container,Vessel,"2mL Glass CE Vials"]&,numberOfSamples],
				Array[{"Work Surface",testBench}&,numberOfSamples],
				Name->Array["Vial "<>ToString[#]<>" for MeasureWeight testing "<>$SessionUUID&,numberOfSamples],
				Status->Available
			];

			(* Create the test samples *)
			testSamples=UploadSample[
				Array[Model[Sample,"Sodium Chloride"]&,numberOfSamples],
				Map[{"A1",#}&,testContainers],
				Name->Array["Sample "<>ToString[#]<>" for MeasureWeight testing "<>$SessionUUID&,numberOfSamples],
				InitialAmount->Array[#*100 Milligram&,numberOfSamples],
				Status->Available
			];
		];
	},
	SymbolTearDown:>{
		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Container,Bench,"Bench for MeasureWeight testing "<>$SessionUUID],

				Object[Container,Vessel,"Vial 1 for MeasureWeight testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 2 for MeasureWeight testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 3 for MeasureWeight testing "<>$SessionUUID],
				Object[Container,Vessel,"Vial 4 for MeasureWeight testing "<>$SessionUUID],

				Object[Sample,"Sample 1 for MeasureWeight testing "<>$SessionUUID],
				Object[Sample,"Sample 2 for MeasureWeight testing "<>$SessionUUID],
				Object[Sample,"Sample 3 for MeasureWeight testing "<>$SessionUUID],
				Object[Sample,"Sample 4 for MeasureWeight testing "<>$SessionUUID]
			};

			(*Check whether the created objects and models exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase all the created objects and models*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];

			ClearMemoization[];
		];
	}
]

(* ::Section:: *)
(*End Test Package*)
