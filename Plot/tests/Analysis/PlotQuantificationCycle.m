(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotQuantificationCycle*)


DefineTests[PlotQuantificationCycle,
	{
		(*===Basic examples===*)
		Example[{Basic,"Given a quantification cycle analysis object, creates a plot for the analysis object:"},
			PlotQuantificationCycle[
				Object[Analysis,QuantificationCycle,"Test Cq analysis1 for PlotQuantificationCycle"]
			],
			ValidGraphicsP[]
		],

		Example[{Basic,"Given multiple quantification cycle analysis objects, creates a plot for the analysis objects:"},
			PlotQuantificationCycle[{
				Object[Analysis,QuantificationCycle,"Test Cq analysis1 for PlotQuantificationCycle"],
				Object[Analysis,QuantificationCycle,"Test Cq analysis2 for PlotQuantificationCycle"]
			}],
			ValidGraphicsP[]
		],

		(*===Options examples===*)
		Example[{Options,Zoomable,"Toggles the interactive zoom feature:"},
			PlotQuantificationCycle[
				Object[Analysis,QuantificationCycle,"Test Cq analysis1 for PlotQuantificationCycle"],
				Zoomable->False
			],
			g_/;ValidGraphicsQ[g]&&Length@Cases[g,_DynamicModule,-1]==0
		],

		(* Output tests *)
		Test["Setting Output to Result returns the plot:",
			PlotQuantificationCycle[Object[Analysis,QuantificationCycle,"Test Cq analysis1 for PlotQuantificationCycle"],Output->Result],
			_?ValidGraphicsQ
		],

		Test["Setting Output to Preview returns the plot:",
			PlotQuantificationCycle[Object[Analysis,QuantificationCycle,"Test Cq analysis1 for PlotQuantificationCycle"],Output->Preview],
			_?ValidGraphicsQ
		],

		Test["Setting Output to Options returns the resolved options:",
			PlotQuantificationCycle[Object[Analysis,QuantificationCycle,"Test Cq analysis1 for PlotQuantificationCycle"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotQuantificationCycle]]
		],

		Test["Setting Output to Tests returns a list of tests:",
			PlotQuantificationCycle[Object[Analysis,QuantificationCycle,"Test Cq analysis1 for PlotQuantificationCycle"],Output->Tests],
			{(_EmeraldTest|_Example)...}
		],

		Test["Setting Output to {Result,Options} returns the plot along with all resolved options:",
			PlotQuantificationCycle[Object[Analysis,QuantificationCycle,"Test Cq analysis1 for PlotQuantificationCycle"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotQuantificationCycle]]
		]

	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,qPCR,"Test qPCR data for PlotQuantificationCycle target1"],
				Object[Data,qPCR,"Test qPCR data for PlotQuantificationCycle target2"],
				Object[Analysis,QuantificationCycle,"Test Cq analysis1 for PlotQuantificationCycle"],
				Object[Analysis,QuantificationCycle,"Test Cq analysis2 for PlotQuantificationCycle"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

		(*Make test samples*)
		InternalExperiment`Private`qPCRTestSampleSetup["PlotQuantificationCycle"];

		(*Make test data objects*)
		Upload[{
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data for PlotQuantificationCycle target1",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 1 for PlotQuantificationCycle"],Data],
				Replace[Primers]->Join[{{Link[Object[Sample,"Test Primer 1 Forward for PlotQuantificationCycle"]],Link[Object[Sample,"Test Primer 1 Reverse for PlotQuantificationCycle"]]}},ConstantArray[{Null,Null},20]],
				Replace[Probes]->PadRight[{Link[Object[Sample,"Test Probe 1 for PlotQuantificationCycle"]]},21,Null],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:XnlV5jKAO6YN"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[{{1,0.838366},{2,0.867461},{3,0.882255},{4,0.887922},{5,0.8991},{6,0.908386},{7,0.915779},{8,0.922756},{9,0.929573},{10,0.93254},{11,0.941931},{12,0.954241},{13,0.963869},{14,0.966802},{15,0.979435},{16,0.993327},{17,1.02214},{18,1.06643},{19,1.14886},{20,1.29975},{21,1.56968},{22,1.95918},{23,2.38847},{24,2.78532},{25,3.16301},{26,3.53637},{27,3.89258},{28,4.20981},{29,4.47358},{30,4.7301},{31,4.96325},{32,5.17179},{33,5.33801},{34,5.50773},{35,5.65007},{36,5.77216},{37,5.92374},{38,6.01616},{39,6.12867},{40,6.21872}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data for PlotQuantificationCycle target2",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for PlotQuantificationCycle"],Data],
				Replace[Primers]->PadRight[{{Null,Null},{Link[Object[Sample,"Test Primer 2 Forward for PlotQuantificationCycle"]],Link[Object[Sample,"Test Primer 2 Reverse for PlotQuantificationCycle"]]}},21,{{Null,Null}}],
				Replace[Probes]->ConstantArray[Null,21],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{Unused,PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:n0k9mG8wKnd4"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[ConstantArray[{1,1},40],{None,RFU}],QuantityArray[{{1,0.444124},{2,0.460555},{3,0.465152},{4,0.471081},{5,0.475303},{6,0.479624},{7,0.480211},{8,0.487465},{9,0.490427},{10,0.504163},{11,0.519415},{12,0.53833},{13,0.582165},{14,0.663417},{15,0.816901},{16,1.09213},{17,1.52884},{18,2.06853},{19,2.63047},{20,3.14602},{21,3.65078},{22,4.12188},{23,4.52009},{24,4.86981},{25,5.19369},{26,5.46031},{27,5.72132},{28,5.93092},{29,6.14026},{30,6.29707},{31,6.44814},{32,6.59431},{33,6.71977},{34,6.80241},{35,6.91043},{36,6.97861},{37,7.08597},{38,7.15183},{39,7.24419},{40,7.27548}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>
		}];

		(*Make test analysis objects*)
		Upload[{
			<|Append[Flatten[Normal[AnalyzeQuantificationCycle[Object[Data,qPCR,"Test qPCR data for PlotQuantificationCycle target1"],Upload->False]]],Name->"Test Cq analysis1 for PlotQuantificationCycle"]|>,
			<|Append[Flatten[Normal[AnalyzeQuantificationCycle[Object[Data,qPCR,"Test qPCR data for PlotQuantificationCycle target2"],Method->InflectionPoint,Upload->False]]],Name->"Test Cq analysis2 for PlotQuantificationCycle"]|>
		}];
	),


	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];
