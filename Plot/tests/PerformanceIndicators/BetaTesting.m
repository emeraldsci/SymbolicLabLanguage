(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Beta Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotBetaTesting*)

(* ::Subsection::Closed:: *)
(* PlotBetaTesting *)
DefineTests[PlotBetaTesting,
    {
        Example[{Basic,"Open a notebook and creates an underlying cloud file showing the stability of the protocol:"},
            PlotBetaTesting[ExperimentImageSample],
			ObjectP[Object[EmeraldCloudFile]],
			TimeConstraint->600
		],
		Example[{Options,StartDate,"Specify that only protocols created after a given date should be considered:"},
			PlotBetaTesting[
				ExperimentMeasureWeight,
				StartDate->Now-1 Week
			],
			ObjectP[Object[EmeraldCloudFile]],
			TimeConstraint->600
		],
		Example[{Options,SearchCriteria,"If the experiment creates objects with a shared protocol type, provide options used to search for specific completed protocols:"},
			PlotBetaTesting[ExperimentImageSample,
				SearchCriteria->(PlateImagerInstruments[Type] == Model[Instrument, PlateImager])
			],
			ObjectP[Object[EmeraldCloudFile]],
			TimeConstraint->600
		],
		Example[{Options,OutputFormat,"Indicate that the key criteria and results should be returned in a table instead of creating a full notebook:"},
			PlotBetaTesting[ExperimentMeasureWeight,
				OutputFormat->SummaryTable,
				StartDate->Now-1 Week
			],
			_Grid,
			TimeConstraint->600
		],
		Example[{Messages,"TypeLookup","The type corresponding to the experiment must be listed in Experiment`Private`experimentFunctionTypeLookup or in ProcedureFramework`Private`experimentFunctionTypeLookup in order to run the function:"},
			PlotBetaTesting[
				ExperimentScience
			],
			$Failed,
			Messages:>{PlotBetaTesting::TypeLookup}
		]
    },
	Stubs:>{
		$RequiredSearchName = "PlotBetaTesting",
		$DeveloperSearch = True
	},
	SymbolSetUp:>Module[{functionTestID, notebookPacket, tubePacket, unitTestSuitePacket, unitTestFunctionPacket, operatorPacket,
		tube1,tube2,notebook,unitTestSuite,unitTestFunction,operator, waterSample1, waterSample2, imageProtocol, protocol1,
		protocol2, protocol3, protocol4, tsTickets, statusPackets, devObjectPackets, namePackets
	},

		$CreatedObjects={};

		functionTestID=CreateID[Object[UnitTest,Function]];

		notebookPacket=<|Type->Object[LaboratoryNotebook], DeveloperObject->True|>;

		tubePacket=<|Type->Object[Container,Vessel], Model->Link[Model[Container, Vessel, "2mL Tube"],Objects], DeveloperObject->True|>;

		unitTestSuitePacket=<|
			Type->Object[UnitTest,Suite],
			DeveloperObject->True,
			SLLVersion->"stable",
			Status->Completed,
			Replace[UnitTests]->Link[ConstantArray[functionTestID,3001],UnitTestSuite],
			Name->"Test Suite for PlotBetaTesting "<>$SessionUUID
		|>;

		unitTestFunctionPacket=<|
			Object->functionTestID,
			DeveloperObject->True,
			Function->ExperimentImageSample,
			Status->Passed
		|>;

		operatorPacket=<|
			Type->Model[User,Emerald,Operator],
			DeveloperObject->True,
			Replace[ProtocolPermissions]->{Object[Protocol,ImageSample]},
			Name->"PlotBetaTesting Operator "<>$SessionUUID
		|>;

		{tube1,tube2,notebook,unitTestSuite,unitTestFunction,operator}=Upload[
			{tubePacket,tubePacket,notebookPacket,unitTestSuitePacket,unitTestFunctionPacket,operatorPacket}
		];

		{waterSample1,waterSample2}=ECL`InternalUpload`UploadSample[
			{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
			{{"A1",tube1},{"A1",tube2}},
			InitialAmount->{100 Microliter,100 Microliter}
		];

		protocol1 = ExperimentImageSample[{waterSample1},Name->"PlotBetaTesting Test Protocol 1 "<>$SessionUUID];
		protocol2 = ExperimentImageSample[{waterSample2},Name->"PlotBetaTesting Test Protocol 2 "<>$SessionUUID];
		protocol3 = ExperimentImageSample[{waterSample1,waterSample2},Name->"PlotBetaTesting Test Protocol 3 "<>$SessionUUID];
		protocol4 = ExperimentMeasureWeight[{waterSample1,waterSample2},Name->"PlotBetaTesting Test Protocol 4 "<>$SessionUUID];

		tsTickets = RequestSupport[
			{{Operations, "Compile Error", "Compile threw Missing[NotFound]"}},
			AffectedProtocol -> {protocol1},
			SourceProtocol -> {protocol1},
			Notebook -> notebook
		];

		statusPackets=MapIndexed[
			With[
				{date=Now-First[#2]*Day},
				<|
					Object->#1,
					DateCompleted->date,
					Status->Completed,
					Replace[StatusLog]->{{date,Completed,Link[$PersonID]}}
				|>
			]&,
			{protocol1,protocol2,protocol3,protocol4}
		];

		devObjectPackets = Map[
			<|
				Object->#,
				DeveloperObject->True
			|>&,
			Join[tsTickets,{protocol1,protocol2,protocol3,protocol4}]
		];

		namePackets=Map[
			<|
				Object->#,
				Name->"PlotBetaTesting "<>ToString[#[ID]]<>" "<>$SessionUUID
			|>&,
			Join[tsTickets,{unitTestFunction}]
		];

		Upload[Join[statusPackets,devObjectPackets,namePackets]]
	]
]