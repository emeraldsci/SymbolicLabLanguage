(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotqPCR*)


DefineTests[PlotqPCR,
	{
		(*===Basic examples===*)
		Example[{Basic,"Given a qPCR data object, creates a plot for the applicable normalized and baseline-subtracted amplification curves. If there are linked analysis objects, the quantification cycle/copy number information from the most recent analysis for each applicable wavelength pair is displayed as a tooltip:"},
			PlotqPCR[
				Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID]
			],
			ValidGraphicsP[]
		],
		Example[{Basic,"Given multiple qPCR data objects, creates a plot for the applicable normalized and baseline-subtracted amplification curves. For each data object, if there are linked analysis objects, the quantification cycle/copy number information from the most recent analysis for each applicable wavelength pair is displayed as a tooltip:"},
			PlotqPCR[{
				Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID],
				Object[Data,qPCR,"PlotqPCR test data 2"<>plotqPCRUUID]
			}],
			ValidGraphicsP[]
		],
		
		(* analysis packet *)
		Example[{Basic,"Given an Object[Analysis, MeltingPoint] packet generated from Object[Data, qPCR], plot the melting curve as the negative derivative:"},
			PlotqPCR[meltingPointqPCRAnalysis],
			ValidGraphicsP[]
		],

		(*===Options tests===*)
		Example[{Options,Basic,"Set option PrimaryData->MeltingCurves to plot the melting curve:"},
			PlotqPCR[
				(*Test Object with no Notebook, no author, created in 2020; suitable for testing*)
				Object[Data, qPCR, "id:Z1lqpMzWNJKL"],
				PrimaryData->MeltingCurves
			],
			ValidGraphicsP[]
		],
		
		Example[{Options,Basic,"Set option PrimaryData->MeltingCurves to plot the melting curve. If a melting point analysis has been performed on the object, the analysis data will be used directly:"},
			PlotqPCR[
				(*Test Object with no Notebook, no author, created in 2020; suitable for testing*)
				Object[Data,qPCR,"PlotqPCR test data 3"<>plotqPCRUUID],
				PrimaryData->MeltingCurves
			],
			ValidGraphicsP[]
		],

		Example[{Options,BaselineDomain,"BaselineDomain is automatically set to the BaselineDomain from the most recent quantification cycle analysis object:"},
			PlotqPCR[
				Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID]
			],
			ValidGraphicsP[]
		],
		Example[{Options,BaselineDomain,"BaselineDomain is automatically set to {3 Cycle, 15 Cycle} if there are no linked quantification cycle analysis object:"},
			PlotqPCR[
				Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID]
			],
			ValidGraphicsP[],
			SetUp:>(
				$CreatedObjects={};
				Upload[<|
					Object->Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID],
					Replace[QuantificationCycleAnalyses]->{}
				|>]
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,BaselineDomain,"BaselineDomain can be specified:"},
			PlotqPCR[
				Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID],
				BaselineDomain->{1 Cycle,16 Cycle}
			],
			ValidGraphicsP[]
		],
		Example[{Options,CurveType,"CurveType can be specified as one type:"},
			PlotqPCR[
				Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID],
				CurveType->PrimaryAmplicon
			],
			ValidGraphicsP[]
		],
		Example[{Options,CurveType,"CurveType can be specified as multiple types:"},
			PlotqPCR[
				Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID],
				CurveType->{PrimaryAmplicon,PassiveReference}
			],
			ValidGraphicsP[]
		],
		
		(* Message Tests *)
		Example[{Messages,NoqPCRMeltingCurveData,"If no melting curve data is available, an error is thrown:"},
			PlotqPCR[
				Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID],
				PrimaryData->MeltingCurves
			],
			$Failed,
			Messages:>{Error::NoqPCRMeltingCurveData}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	Variables:>{meltingPointqPCRAnalysisPacket, plotqPCRUUID},

	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,qPCR,"PlotqPCR test data 1"],
				Object[Data,qPCR,"PlotqPCR test data 2"],
				Object[Analysis,QuantificationCycle,"PlotqPCR test Cq analysis 1"],
				Object[Analysis,QuantificationCycle,"PlotqPCR test Cq analysis 2"],
				Object[Analysis,Fit,"PlotqPCR test standard curve"],
				Object[Analysis,CopyNumber,"PlotqPCR test copy number analysis 1"],
				Object[Analysis,CopyNumber,"PlotqPCR test copy number analysis 2"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];
		
		Module[
			{
				dataObject1, dataObject2, qPCRProtocol, dataObject3
			},
			
			qPCRProtocol = Upload[<|Type->Object[Protocol, qPCR]|>];
			
			plotqPCRUUID = CreateUUID[];

			(*Make test samples*)
			InternalExperiment`Private`qPCRTestSampleSetup["PlotqPCR"];
	
			(*Make test data objects*)
			{dataObject1, dataObject2, dataObject3} = Upload[{
				<|
					Type->Object[Data,qPCR],
					Name->"PlotqPCR test data 1" <> plotqPCRUUID,
					Replace[SamplesIn]->Link[Object[Sample,"Test Template 1 for PlotqPCR"],Data],
					Replace[Primers]->Join[{{Link[Object[Sample,"Test Primer 1 Forward for PlotqPCR"]],Link[Object[Sample,"Test Primer 1 Reverse for PlotqPCR"]]}},ConstantArray[{Null,Null},20]],
					Replace[Probes]->PadRight[{Link[Object[Sample,"Test Probe 1 for PlotqPCR"]]},21,Null],
					Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
					Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
					Replace[AmplificationCurveTypes]->PadRight[{PrimaryAmplicon,Unused,Unused,Unused,Unused,Unused,PassiveReference},21,Unused],
					Replace[AmplificationCurves]->PadRight[{QuantityArray[{{1,0.838366},{2,0.867461},{3,0.882255},{4,0.887922},{5,0.8991},{6,0.908386},{7,0.915779},{8,0.922756},{9,0.929573},{10,0.93254},{11,0.941931},{12,0.954241},{13,0.963869},{14,0.966802},{15,0.979435},{16,0.993327},{17,1.02214},{18,1.06643},{19,1.14886},{20,1.29975},{21,1.56968},{22,1.95918},{23,2.38847},{24,2.78532},{25,3.16301},{26,3.53637},{27,3.89258},{28,4.20981},{29,4.47358},{30,4.7301},{31,4.96325},{32,5.17179},{33,5.33801},{34,5.50773},{35,5.65007},{36,5.77216},{37,5.92374},{38,6.01616},{39,6.12867},{40,6.21872}},{None,RFU}]},21,{QuantityArray[MapThread[{#1,#2}&,{Range[40],ConstantArray[1,40]}],{None,RFU}]}],
					Protocol->Link[qPCRProtocol, StandardData],
					DeveloperObject->True
				|>,
				<|
					Type->Object[Data,qPCR],
					Name->"PlotqPCR test data 2" <> plotqPCRUUID,
					Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for PlotqPCR"],Data],
					Replace[Primers]->PadRight[{{Null,Null},{Link[Object[Sample,"Test Primer 2 Forward for PlotqPCR"]],Link[Object[Sample,"Test Primer 2 Reverse for PlotqPCR"]]}},21,{{Null,Null}}],
					Replace[Probes]->ConstantArray[Null,21],
					Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
					Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
					Replace[AmplificationCurveTypes]->PadRight[{Unused,PrimaryAmplicon,Unused,Unused,Unused,Unused,PassiveReference},21,Unused],
					Replace[AmplificationCurves]->PadRight[{QuantityArray[MapThread[{#1,#2}&,{Range[40],ConstantArray[1,40]}],{None,RFU}],QuantityArray[{{1,0.444124},{2,0.460555},{3,0.465152},{4,0.471081},{5,0.475303},{6,0.479624},{7,0.480211},{8,0.487465},{9,0.490427},{10,0.504163},{11,0.519415},{12,0.53833},{13,0.582165},{14,0.663417},{15,0.816901},{16,1.09213},{17,1.52884},{18,2.06853},{19,2.63047},{20,3.14602},{21,3.65078},{22,4.12188},{23,4.52009},{24,4.86981},{25,5.19369},{26,5.46031},{27,5.72132},{28,5.93092},{29,6.14026},{30,6.29707},{31,6.44814},{32,6.59431},{33,6.71977},{34,6.80241},{35,6.91043},{36,6.97861},{37,7.08597},{38,7.15183},{39,7.24419},{40,7.27548}},{None,RFU}]},21,{QuantityArray[MapThread[{#1,#2}&,{Range[40],ConstantArray[1,40]}],{None,RFU}]}],
					Protocol->Link[qPCRProtocol, StandardData],
					DeveloperObject->True
				|>,
				<|
					Type->Object[Data,qPCR],
					Name->"PlotqPCR test data 3" <> plotqPCRUUID,
					Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for PlotqPCR"],Data],
					Replace[Primers]->PadRight[{{Null,Null},{Link[Object[Sample,"Test Primer 2 Forward for PlotqPCR"]],Link[Object[Sample,"Test Primer 2 Reverse for PlotqPCR"]]}},21,{{Null,Null}}],
					Replace[Probes]->ConstantArray[Null,21],
					Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
					Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
					Replace[AmplificationCurveTypes]->PadRight[{Unused,PrimaryAmplicon,Unused,Unused,Unused,Unused,PassiveReference},21,Unused],
					Replace[MeltingCurves]->QuantityArray[Transpose[{Range[50,70], {5.1596515399263385`,4.989083931825994`,4.585520827419312`,4.45792280963086`,4.1030606761816815`,3.9440080265281767`,3.661881164703322`,3.5426345581012306`,3.338099733969894`,3.074826762453064`,2.764096916180067`,2.4379521056792566`,2.3338071933027598`,1.9519166783189754`,1.7776523754153875`,1.6079924947567148`,1.1150241132692387`,1.0934485728595895`,0.838874165165215`,0.3900038683644859`,0.3642343459741698`}}], {Celsius, RFU}],
					Protocol->Link[qPCRProtocol, StandardData],
					DeveloperObject->True
				|>
			}];
			
			meltingPointqPCRAnalysis = AnalyzeMeltingPoint[dataObject3];
		
		];

		Module[{cqObjects,fitObject,cnObjects},

			(*Make test Cq analysis objects*)
			cqObjects=AnalyzeQuantificationCycle[
				{
					Object[Data,qPCR,"PlotqPCR test data 1"<>plotqPCRUUID],
					Object[Data,qPCR,"PlotqPCR test data 2"<>plotqPCRUUID]
				},
				Upload->False
			];
			Upload[{
				Append[First[cqObjects],{DeveloperObject->True,Name->"PlotqPCR test Cq analysis 1"}],
				Append[Last[cqObjects],{DeveloperObject->True,Name->"PlotqPCR test Cq analysis 2"}]
			}];

			(*Make a test standard curve*)
			fitObject=AnalyzeFit[
				{{Log10[1000],24.7 Cycle},{Log10[10000],21.6 Cycle},{Log10[100000],18.2 Cycle},{Log10[1000000],15 Cycle}},
				Linear,
				Name->"PlotqPCR test standard curve",
				Upload->False
			];
			Upload[Append[fitObject,DeveloperObject->True]];

			(*Make test copy number analysis objects*)
			cnObjects=AnalyzeCopyNumber[
				{
					Object[Analysis,QuantificationCycle,"PlotqPCR test Cq analysis 1"],
					Object[Analysis,QuantificationCycle,"PlotqPCR test Cq analysis 2"]
				},
				Object[Analysis,Fit,"PlotqPCR test standard curve"],
				Upload->False
			];
			Upload[{
				Append[First@cnObjects,{DeveloperObject->True,Name->"PlotqPCR test copy number analysis 1"}],
				Append[Last@cnObjects,{DeveloperObject->True,Name->"PlotqPCR test copy number analysis 2"}]
			}]

		];
	),
	
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];
