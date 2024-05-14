(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDynamicFoamAnalysis*)


DefineTests[PlotDynamicFoamAnalysis,
	{
		(* -- BASIC -- *)
		Example[{Basic,"Given a DynamicFoamAnalysis data object, creates all possible plots related to the DetectionMethod:"},
			output=PlotDynamicFoamAnalysis[
				Object[Data,DynamicFoamAnalysis,"Example data 1 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID]
			];
			MatchQ[output,_TabView],
			True,
			Variables:>{output}
		],

		Example[{Basic,"Given multiple DynamicFoamAnalysis data objects, creates all possible plots related to the DetectionMethod):"},
			output=PlotDynamicFoamAnalysis[
				{
					Object[Data,DynamicFoamAnalysis,"Example data 1 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID],
					Object[Data,DynamicFoamAnalysis,"Example data 5 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID]
				}
			],
			_SlideView
		],

		Test["Given a DynamicFoamAnalysis data object with HeightMethod and ImagingMethod data, creates all possible plots related to the DetectionMethod:",
			output=PlotDynamicFoamAnalysis[
				Object[Data,DynamicFoamAnalysis,"Example data 2 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID]
			];
			{MatchQ[output,_TabView],Length[output[[1]]]},
			{True,5},
			Variables:>{output}
		],

		Test["Given a DynamicFoamAnalysis data object with HeightMethod and LiquidConductivityMethod data, creates all possible plots related to the DetectionMethod:",
			output=PlotDynamicFoamAnalysis[
				Object[Data,DynamicFoamAnalysis,"Example data 3 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID]
			];
			{MatchQ[output,_TabView],Length[output[[1]]]},
			{True,3},
			Variables:>{output}
		],

		Test["Given a DynamicFoamAnalysis data object with HeightMethod data, creates all possible plots related to the DetectionMethod:",
			output=PlotDynamicFoamAnalysis[
				Object[Data,DynamicFoamAnalysis,"Example data 4 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID]
			];
			{MatchQ[output,_TabView],Length[output[[1]]]},
			{True,2},
			Variables:>{output}
		],

		(* -- OPTIONS -- *)
		Example[{Options,PlotType,"Given a DynamicFoamAnalysis protocol object, use PlotType to specify which plots to generate:"},
			output=PlotDynamicFoamAnalysis[
				Object[Data,DynamicFoamAnalysis,"Example data 1 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID],
				PlotType->{FoamHeight,BubbleCount,LiquidContent}
			];
			{MatchQ[output,_TabView],Length[output[[1]]]},
			{True,3},
			Variables:>{output}
		],

		(* -- Messages -- *)
		Example[
			{Messages,"NoDataForPlotDynamicFoamAnalysisPlotType","An error will be shown if the specified DynamicFoamAnalysis data object does not have data for a specified plot type:"},
			PlotDynamicFoamAnalysis[
				Object[Data,DynamicFoamAnalysis,"Example data 4 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID],
				PlotType->{BubbleCount}
			],
			$Failed,
			Messages:>{Error::NoDataForPlotDynamicFoamAnalysisPlotType}
		],
		Test[
			"An error will be shown if the specified DynamicFoamAnalysis data object does not have data for a specified plot type:",
			PlotDynamicFoamAnalysis[
				Object[Data,DynamicFoamAnalysis,"Example data 4 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID],
				PlotType->{LiquidContent}
			],
			$Failed,
			Messages:>{Error::NoDataForPlotDynamicFoamAnalysisPlotType}
		]
	},

	(*  build test objects *)
	Stubs:>{
		$EmailEnabled=False
	},
	Variables:>{
		plotDynamicFoamUUID
	},
	SymbolSetUp:>(
		$CreatedObjects = {};
		Module[{objs,existingObjs},
			objs=Quiet[Cases[
				Flatten[{
					Object[Sample,"Sample1 for PlotDynamicFoamAnalysis tests"],
					Object[Sample,"Sample2 for PlotDynamicFoamAnalysis tests"],

					Object[Data,DynamicFoamAnalysis,"Example data 1 for PlotDynamicFoamAnalysis tests"],
					Object[Data,DynamicFoamAnalysis,"Example data 2 for PlotDynamicFoamAnalysis tests"],
					Object[Data,DynamicFoamAnalysis,"Example data 3 for PlotDynamicFoamAnalysis tests"],
					Object[Data,DynamicFoamAnalysis,"Example data 4 for PlotDynamicFoamAnalysis tests"],
					Object[Data,DynamicFoamAnalysis,"Example data 5 for PlotDynamicFoamAnalysis tests"]
				}],
				ObjectP[]
			]];
			existingObjs=PickList[objs,DatabaseMemberQ[objs]];
			EraseObject[existingObjs,Force->True,Verbose->False]
		];
		Block[{$AllowSystemsProtocols=True},
			Module[
				{
					downloadProtocol,liquidSample1,liquidSample2,dataObject1,dataObject2,dataObject3,dataObject4,dataObject5
				},
				plotDynamicFoamUUID = CreateUUID[];
				(* Example samples *)
				{
					liquidSample1,
					liquidSample2
				}=Upload[{
					<|
						Type->Object[Sample],
						Model->Link[Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],Objects],
						State->Liquid,
						Name->"Sample1 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID
					|>,
					<|
						Type->Object[Sample],
						Model->Link[Model[Sample,StockSolution,"0.5M Sodium dodecyl sulfate"],Objects],
						State->Liquid,
						Name->"Sample2 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID
					|>
				}];

				(* download things that we need in one download call *)
				downloadProtocol=Download[Object[Data,DynamicFoamAnalysis,"id:54n6evL6XbEP"],
					Packet[FoamHeight,LiquidHeight,TotalFoamLiquidHeight,FoamVolume,LiquidVolume,TotalFoamLiquidVolume,FoamVolumeStability,
					FoamLiquidStability,FoamTemperature,LiquidContentSensor1,LiquidContentSensor2,LiquidContentSensor3,LiquidContentSensor4,
					LiquidContentSensor5,LiquidContentSensor6,LiquidContentSensor7,BubbleCount,MeanBubbleArea,StandardDeviationBubbleArea,
					AverageBubbleRadius,MeanSquareBubbleRadius,BubbleSauterMeanRadius]
				];

				(* -- The following data are from the Object[Data, DynamicFoamAnalysis, "id:54n6evL6XbEP"] -- *)

				(* -- FAKE DATA OBJECTS -- *)
				dataObject1=Upload[<|
					Type->Object[Data,DynamicFoamAnalysis],
					Name->"Example data 1 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID,
					Replace[SamplesIn]->{Link[liquidSample1,Data]},
					DetectionMethod->{HeightMethod,LiquidConductivityMethod,ImagingMethod},
					Replace[FoamHeight]->Lookup[downloadProtocol,FoamHeight],
					Replace[LiquidHeight]->Lookup[downloadProtocol,LiquidHeight],
					Replace[TotalFoamLiquidHeight]->Lookup[downloadProtocol,TotalFoamLiquidHeight],
					Replace[FoamVolume]->Lookup[downloadProtocol,FoamVolume],
					Replace[LiquidVolume]->Lookup[downloadProtocol,LiquidVolume],
					Replace[TotalFoamLiquidVolume]->Lookup[downloadProtocol,TotalFoamLiquidVolume],
					Replace[FoamVolumeStability]->Lookup[downloadProtocol,FoamVolumeStability],
					Replace[FoamLiquidStability]->Lookup[downloadProtocol,FoamLiquidStability],
					Replace[FoamTemperature]->Lookup[downloadProtocol,FoamTemperature],
					Replace[LiquidContentSensor1]->Lookup[downloadProtocol,LiquidContentSensor1],
					Replace[LiquidContentSensor2]->Lookup[downloadProtocol,LiquidContentSensor2],
					Replace[LiquidContentSensor3]->Lookup[downloadProtocol,LiquidContentSensor3],
					Replace[LiquidContentSensor4]->Lookup[downloadProtocol,LiquidContentSensor4],
					Replace[LiquidContentSensor5]->Lookup[downloadProtocol,LiquidContentSensor5],
					Replace[LiquidContentSensor6]->Lookup[downloadProtocol,LiquidContentSensor6],
					Replace[LiquidContentSensor7]->Lookup[downloadProtocol,LiquidContentSensor7],
					Replace[BubbleCount]->Lookup[downloadProtocol,BubbleCount],
					Replace[MeanBubbleArea]->Lookup[downloadProtocol,MeanBubbleArea],
					Replace[StandardDeviationBubbleArea]->Lookup[downloadProtocol,StandardDeviationBubbleArea],
					Replace[AverageBubbleRadius]->Lookup[downloadProtocol,AverageBubbleRadius],
					Replace[MeanSquareBubbleRadius]->Lookup[downloadProtocol,MeanSquareBubbleRadius],
					Replace[BubbleSauterMeanRadius]->Lookup[downloadProtocol,BubbleSauterMeanRadius],
					DeveloperObject->True
				|>];

				dataObject2=Upload[<|
					Type->Object[Data,DynamicFoamAnalysis],
					Name->"Example data 2 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID,
					Replace[SamplesIn]->{Link[liquidSample1,Data]},
					DetectionMethod->{HeightMethod,ImagingMethod},
					Replace[FoamHeight]->Lookup[downloadProtocol,FoamHeight],
					Replace[LiquidHeight]->Lookup[downloadProtocol,LiquidHeight],
					Replace[TotalFoamLiquidHeight]->Lookup[downloadProtocol,TotalFoamLiquidHeight],
					Replace[FoamVolume]->Lookup[downloadProtocol,FoamVolume],
					Replace[LiquidVolume]->Lookup[downloadProtocol,LiquidVolume],
					Replace[TotalFoamLiquidVolume]->Lookup[downloadProtocol,TotalFoamLiquidVolume],
					Replace[FoamVolumeStability]->Lookup[downloadProtocol,FoamVolumeStability],
					Replace[FoamLiquidStability]->Lookup[downloadProtocol,FoamLiquidStability],
					Replace[FoamTemperature]->Lookup[downloadProtocol,FoamTemperature],
					Replace[BubbleCount]->Lookup[downloadProtocol,BubbleCount],
					Replace[MeanBubbleArea]->Lookup[downloadProtocol,MeanBubbleArea],
					Replace[StandardDeviationBubbleArea]->Lookup[downloadProtocol,StandardDeviationBubbleArea],
					Replace[AverageBubbleRadius]->Lookup[downloadProtocol,AverageBubbleRadius],
					Replace[MeanSquareBubbleRadius]->Lookup[downloadProtocol,MeanSquareBubbleRadius],
					Replace[BubbleSauterMeanRadius]->Lookup[downloadProtocol,BubbleSauterMeanRadius],
					DeveloperObject->True
				|>];

				dataObject3=Upload[<|
					Type->Object[Data,DynamicFoamAnalysis],
					Name->"Example data 3 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID,
					Replace[SamplesIn]->{Link[liquidSample1,Data]},
					DetectionMethod->{HeightMethod,LiquidConductivityMethod},
					Replace[FoamHeight]->Lookup[downloadProtocol,FoamHeight],
					Replace[LiquidHeight]->Lookup[downloadProtocol,LiquidHeight],
					Replace[TotalFoamLiquidHeight]->Lookup[downloadProtocol,TotalFoamLiquidHeight],
					Replace[FoamVolume]->Lookup[downloadProtocol,FoamVolume],
					Replace[LiquidVolume]->Lookup[downloadProtocol,LiquidVolume],
					Replace[TotalFoamLiquidVolume]->Lookup[downloadProtocol,TotalFoamLiquidVolume],
					Replace[FoamVolumeStability]->Lookup[downloadProtocol,FoamVolumeStability],
					Replace[FoamLiquidStability]->Lookup[downloadProtocol,FoamLiquidStability],
					Replace[FoamTemperature]->Lookup[downloadProtocol,FoamTemperature],
					Replace[LiquidContentSensor1]->Lookup[downloadProtocol,LiquidContentSensor1],
					Replace[LiquidContentSensor2]->Lookup[downloadProtocol,LiquidContentSensor2],
					Replace[LiquidContentSensor3]->Lookup[downloadProtocol,LiquidContentSensor3],
					Replace[LiquidContentSensor4]->Lookup[downloadProtocol,LiquidContentSensor4],
					Replace[LiquidContentSensor5]->Lookup[downloadProtocol,LiquidContentSensor5],
					Replace[LiquidContentSensor6]->Lookup[downloadProtocol,LiquidContentSensor6],
					Replace[LiquidContentSensor7]->Lookup[downloadProtocol,LiquidContentSensor7],
					DeveloperObject->True
				|>];

				dataObject4=Upload[<|
					Type->Object[Data,DynamicFoamAnalysis],
					Name->"Example data 4 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID,
					Replace[SamplesIn]->{Link[liquidSample1,Data]},
					DetectionMethod->{HeightMethod},
					Replace[FoamHeight]->Lookup[downloadProtocol,FoamHeight],
					Replace[LiquidHeight]->Lookup[downloadProtocol,LiquidHeight],
					Replace[TotalFoamLiquidHeight]->Lookup[downloadProtocol,TotalFoamLiquidHeight],
					Replace[FoamVolume]->Lookup[downloadProtocol,FoamVolume],
					Replace[LiquidVolume]->Lookup[downloadProtocol,LiquidVolume],
					Replace[TotalFoamLiquidVolume]->Lookup[downloadProtocol,TotalFoamLiquidVolume],
					Replace[FoamVolumeStability]->Lookup[downloadProtocol,FoamVolumeStability],
					Replace[FoamLiquidStability]->Lookup[downloadProtocol,FoamLiquidStability],
					Replace[FoamTemperature]->Lookup[downloadProtocol,FoamTemperature],
					DeveloperObject->True
				|>];

				dataObject5=Upload[<|
					Type->Object[Data,DynamicFoamAnalysis],
					Name->"Example data 5 for PlotDynamicFoamAnalysis tests"<>plotDynamicFoamUUID,
					Replace[SamplesIn]->{Link[liquidSample2,Data]},
					DetectionMethod->{HeightMethod,ImagingMethod,LiquidConductivityMethod},
					Replace[FoamHeight]->Lookup[downloadProtocol,FoamHeight],
					Replace[LiquidHeight]->Lookup[downloadProtocol,LiquidHeight],
					Replace[TotalFoamLiquidHeight]->Lookup[downloadProtocol,TotalFoamLiquidHeight],
					Replace[FoamVolume]->Lookup[downloadProtocol,FoamVolume],
					Replace[LiquidVolume]->Lookup[downloadProtocol,LiquidVolume],
					Replace[TotalFoamLiquidVolume]->Lookup[downloadProtocol,TotalFoamLiquidVolume],
					Replace[FoamVolumeStability]->Lookup[downloadProtocol,FoamVolumeStability],
					Replace[FoamLiquidStability]->Lookup[downloadProtocol,FoamLiquidStability],
					Replace[FoamTemperature]->Lookup[downloadProtocol,FoamTemperature],
					Replace[LiquidContentSensor1]->Lookup[downloadProtocol,LiquidContentSensor1],
					Replace[LiquidContentSensor2]->Lookup[downloadProtocol,LiquidContentSensor2],
					Replace[LiquidContentSensor3]->Lookup[downloadProtocol,LiquidContentSensor3],
					Replace[LiquidContentSensor4]->Lookup[downloadProtocol,LiquidContentSensor4],
					Replace[LiquidContentSensor5]->Lookup[downloadProtocol,LiquidContentSensor5],
					Replace[LiquidContentSensor6]->Lookup[downloadProtocol,LiquidContentSensor6],
					Replace[LiquidContentSensor7]->Lookup[downloadProtocol,LiquidContentSensor7],
					Replace[BubbleCount]->Lookup[downloadProtocol,BubbleCount],
					Replace[MeanBubbleArea]->Lookup[downloadProtocol,MeanBubbleArea],
					Replace[StandardDeviationBubbleArea]->Lookup[downloadProtocol,StandardDeviationBubbleArea],
					Replace[AverageBubbleRadius]->Lookup[downloadProtocol,AverageBubbleRadius],
					Replace[MeanSquareBubbleRadius]->Lookup[downloadProtocol,MeanSquareBubbleRadius],
					Replace[BubbleSauterMeanRadius]->Lookup[downloadProtocol,BubbleSauterMeanRadius],
					DeveloperObject->True
				|>]
			]
		]
	),
	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects], True], Force -> True, Verbose -> False];
	)
];
