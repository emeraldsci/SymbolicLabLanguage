(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFlowCytometry*)


DefineTests[PlotFlowCytometry,{

	Example[{Basic,"Plot flow cytometry data:"},
		PlotFlowCytometry[Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID]],
		ValidGraphicsP[],
		TimeConstraint -> 240
	],
	Test["Given a packet:",
		PlotFlowCytometry[Download[Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID]]],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[{Basic,"Plot flow cytometry data in a link:"},
		PlotFlowCytometry[Link[Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID],Protocol]],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[{Basic,"Compare mutliple flow cytometry data sets:"},
		PlotFlowCytometry[{Object[Data, FlowCytometry, "id:qdkmxzqzDx4m"],Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID]}],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[{Options,PlotType,"List line plot of 1 data set:"},
		PlotFlowCytometry[
			Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID],
			PlotType->EmeraldListLinePlot],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[{Options,PlotType,"histogram plot of 1 data set:"},
		PlotFlowCytometry[
			Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID],
			PlotType->EmeraldHistogram],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[{Options,PlotType,"Smooth histogram plot of 1 data set:"},
		PlotFlowCytometry[
			Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID],
			PlotType->EmeraldSmoothHistogram],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[{Options,Channels,"Specify two channels data set:"},
		PlotFlowCytometry[
			Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID],
			Channels->{"405 FSC", "355 447/60"}],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[{Options,DataPoints,"Specify the type of data channel plot of 1 data set:"},
		PlotFlowCytometry[
			Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID],
			DataPoints->Height],
		ValidGraphicsP[],
		TimeConstraint -> 120
	]

},

	SymbolSetUp:>(
		Block[{$DeveloperUpload = True},
			$CreatedObjects = {};
			(*module for deleting created objects*)
			Module[{objects, existingObjects},
				objects={
					Object[Sample,"PlotFlowCytometry Test Sample 1"],
					Object[Sample,"PlotFlowCytometry Test Sample 2"],
					Object[Container,Vessel,"Test container for PlotFlowCytometry tests"<>$SessionUUID],
					Object[Container,Plate,"Test assay container for PlotFlowCytometry tests"<>$SessionUUID],
					Object[Protocol,FlowCytometry,"Test FlowCytometry Protocol for PlotFlowCytometry tests"<>$SessionUUID],
					Object[Protocol,FlowCytometry,"Test FlowCytometry Protocol for PlotFlowCytometry tests 2"<>$SessionUUID],
					Object[Container,Vessel,"Test waste container for PlotFlowCytometry tests"<>$SessionUUID],
					Object[Instrument,FlowCytometer,"Test instrument for PlotFlowCytometry tests"<>$SessionUUID],
					Object[Data,FlowCytometry,"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID]
				};

				existingObjects = PickList[objects, DatabaseMemberQ[objects]];
				EraseObject[existingObjects, Force -> True, Verbose -> False]

			];
			(*Delete existing files*)
			Module[{files},
				files={
					FileNameJoin[{$TemporaryDirectory,"Data", "ZE5FlowCytometer", "testPlotFlowCytometryprotocol", "PlotFlowCytometry Test fcs"}],
					FileNameJoin[{$TemporaryDirectory,"Data", "ZE5FlowCytometer", "testPlotFlowCytometryprotocol", "PlotFlowCytometry Test rlst"}]
				};
				If[FileExistsQ[#],DeleteFile[#]]&/@files
			];


			(*module for creating objects*)
			Upload[{
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "15mL Tube"], Objects],
					Name -> "Test container for PlotFlowCytometry tests"<>$SessionUUID
				],
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container,Plate,"id:1ZA60vwjbbqa"], Objects],
					Name -> "Test assay container for PlotFlowCytometry tests"<>$SessionUUID
				]
			}];

			ECL`InternalUpload`UploadSample[
				{Model[Sample, "Milli-Q water"],Model[Sample, "Milli-Q water"]},
				{{"A1",Object[Container,Vessel,"Test container for PlotFlowCytometry tests"<>$SessionUUID]},{"A1",Object[Container,Plate,"Test assay container for PlotFlowCytometry tests"<>$SessionUUID]}},
				InitialAmount -> {50 Microliter,50 Microliter},
				StorageCondition -> {Model[StorageCondition, "id:N80DNj1r04jW"],Model[StorageCondition, "id:N80DNj1r04jW"]},
				Name->{"PlotFlowCytometry Test Sample 1","PlotFlowCytometry Test Sample 2"}
			];


			(*instrument setups*)
			Upload[<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "id:3em6Zv9NjjkY"],Objects],
				Name->"Test waste container for PlotFlowCytometry tests"<>$SessionUUID
			|>];

			Upload[<|
				Type->Object[Instrument,FlowCytometer],
				Model->Link[Model[Instrument, FlowCytometer, "ZE5 Cell Analyzer"], Objects],
				WasteContainer->Link[Object[Container,Vessel,"Test waste container for PlotFlowCytometry tests"<>$SessionUUID]],
				Name->"Test instrument for PlotFlowCytometry tests"<>$SessionUUID
			|>];

			(* - Call ExperimentFlowCytometry, to create test protocols - *)
			Quiet[ExperimentFlowCytometry[Object[Sample,"PlotFlowCytometry Test Sample 1"],
				Detector->{"488 FSC","405 FSC","488 SSC","561 577/15","355 447/60"},
				Name->"Test FlowCytometry Protocol for PlotFlowCytometry tests"<>$SessionUUID]];

			Upload[<|
				Object->Object[Protocol,FlowCytometry,"Test FlowCytometry Protocol for PlotFlowCytometry tests"<>$SessionUUID],
				Replace[WorkingSamples]->Link@{Object[Sample,"PlotFlowCytometry Test Sample 1"]},
				Replace[WorkingContainers]->Link@{Object[Container,Vessel,"Test container for PlotFlowCytometry tests"<>$SessionUUID]},
				Replace[InjectionContainers]->Link@{Object[Container,Plate,"Test assay container for PlotFlowCytometry tests"<>$SessionUUID]},
				Instrument->Link[Object[Instrument,FlowCytometer,"Test instrument for PlotFlowCytometry tests"<>$SessionUUID]]
			|>];

			Block[{$PublicPath=$TemporaryDirectory},InternalExperiment`Private`compileFlowCytometry[Object[Protocol,FlowCytometry,"Test FlowCytometry Protocol for PlotFlowCytometry tests"<>$SessionUUID]]];

			(*create Test data to add to the protocols*)
			Module[{fakePath1,fullFileName1,fakePath2,fullFileName2},
				fakePath1 = FileNameJoin[{$TemporaryDirectory,"Data", "ZE5FlowCytometer", "testPlotFlowCytometryprotocol","ECL Test Projects-Training Test 2-20200724-0947"}];
				Quiet[CreateDirectory[fakePath1]];
				fullFileName1 = FileNameJoin[{fakePath1, "PlotFlowCytometry Test fcs"}];
				DownloadCloudFile[Object[EmeraldCloudFile, "id:8qZ1VW0WO1wZ"], fullFileName1];
				fakePath2 = FileNameJoin[{$TemporaryDirectory,"Data", "ZE5FlowCytometer", "testPlotFlowCytometryprotocol","ECL Test Projects-Training Test 2-20200724-0947"}];
				Quiet[CreateDirectory[fakePath2]];
				fullFileName2 = FileNameJoin[{fakePath1, "PlotFlowCytometry Test rlst"}];
				DownloadCloudFile[Object[EmeraldCloudFile, "id:R8e1Pjpjq1DJ"], fullFileName2];

				(* - Upload the  protocols with the various Objects they will need for the parser to work properly - *)
				Upload[
					{
						<|
							Object -> Object[Protocol,FlowCytometry,"Test FlowCytometry Protocol for PlotFlowCytometry tests"<>$SessionUUID],
							Replace[MethodFileName]->"testPlotFlowCytometryprotocol"
						|>

					}
				];
			];

			Block[{$PublicPath=$TemporaryDirectory},InternalExperiment`Private`parseFlowCytometry[Object[Protocol,FlowCytometry,"Test FlowCytometry Protocol for PlotFlowCytometry tests"<>$SessionUUID]]];

			Upload[<|
				Object->First[Object[Protocol,FlowCytometry,"Test FlowCytometry Protocol for PlotFlowCytometry tests"<>$SessionUUID][Data]][Object],
				Name->"Test FlowCytometry Data for PlotFlowCytometry tests"<>$SessionUUID
			|>]
		]
	),
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects], True], Force -> True, Verbose -> False];
	),

	Stubs :> {$PublicPath = $TemporaryDirectory,
		$PersonID = Object[User, "Test user for notebook-less test protocols"]}
];
