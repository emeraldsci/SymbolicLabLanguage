(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFragmentAnalysis*)


DefineTests[PlotFragmentAnalysis,
	{
		(* -- BASIC -- *)
		Example[{Basic,"Given a FragmentAnalysis data object, creates a plot for the SampleElectropherogram:"},
			PlotFragmentAnalysis[
				Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]
			],
			_?ValidGraphicsQ
		],
  
		Example[{Basic,"Plot a FragmentAnalysis data in a link:"},
			PlotFragmentAnalysis[Link[Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"],Protocol]],
			_?ValidGraphicsQ
		],

		Example[{Basic,"Given a FragmentAnalysis protocol object, plots the data objects linked to the protocol:"},
			PlotFragmentAnalysis[
				Object[Protocol, FragmentAnalysis, "FragmentAnalysis Protocol For PlotFragmentAnalysis Test " <> $SessionUUID]
			],
			_?ValidGraphicsQ,
			Stubs:>{
				ECL`AnalyzePeaks[___]:=Replace[Position]->{200,300,400,500,600}
			}
		],
        
        Example[{Basic, "Plot FragmentAnalysis data after calling AnalyzePeaks:"},
            AnalyzePeaks[Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]];
            PlotFragmentAnalysis[Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]],
            _?ValidGraphicsQ
        ],

		(* -- OPTIONS -- *)
		Example[{Options, ImageSize, "Set the image size for the output plots:"},
			PlotFragmentAnalysis[
				Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"],
				ImageSize -> 800
			],
			_?ValidGraphicsQ
		],
		Example[{Options,PrimaryData,"The field name containing the data to be plotted:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},PrimaryData->Electropherogram],
			_?ValidGraphicsQ,
			Stubs:>{
				ECL`AnalyzePeaks[___]:=Replace[Position]->{200,300,400,500,600}
			}
		],
		Example[{Options,Display,"Additional data to overlay on top of the plot:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},Display->{Peaks}],
			_?ValidGraphicsQ
		],
		Example[{Options,TargetUnits,"The units of the x and y axes. If these are distinct from the units currently associated with the data, unit conversions will occur before plotting:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},PrimaryData->Electropherogram,TargetUnits -> {Minute, RFU}],
			_?ValidGraphicsQ,
			Stubs:>{
				ECL`AnalyzePeaks[___]:=Replace[Position]->{200,300,400,500,600}
			}
		],
		Example[{Options,Zoomable,"Indicates if a dynamic plot which can be zoomed in or out will be returned:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},Zoomable->True],
			_?ValidGraphicsQ
		],
		Example[{Options,LegendPlacement,"Specifies where the legend will be placed relative to the plot:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},LegendPlacement->Right],
			_?ValidGraphicsQ
		],
		Example[{Options,Boxes,"If true, the legend will pair each label with a colored box. If false, the labels will be paired with a colored line:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},Boxes->True],
			_?ValidGraphicsQ
		],
		Example[{Options,FrameLabel,"The label to place on top of the frame:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},FrameLabel->{"time (s)","fluorescent intensity (arbitrary unit)",None,None}],
			_?ValidGraphicsQ
		],
		Example[{Options,PlotLabel,"Specifies an overall label for a plot:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},PlotLabel->"my experiment"],
			_?ValidGraphicsQ
		],
		Example[{Options,Legend,"A list of text descriptions of each data set in the plot:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},Legend->{"sample"}],
			_?ValidGraphicsQ
		]
	},
	SymbolSetUp :> (

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allObjects, existingObjects, protocol1, data1
			},

			(* All data objects generated for unit tests *)

			allObjects=
				{
					Object[Protocol, FragmentAnalysis, "FragmentAnalysis Protocol For PlotFragmentAnalysis Test " <> $SessionUUID],
					Object[Data, FragmentAnalysis, "FragmentAnalysis Data For PlotFragmentAnalysis Test " <> $SessionUUID]
				};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			{protocol1, data1} = CreateID[{Object[Protocol, FragmentAnalysis], Object[Data, FragmentAnalysis]}];

			Upload[
				<|
					Name -> "FragmentAnalysis Data For PlotFragmentAnalysis Test " <> $SessionUUID,
					Object -> data1,
					Type -> Object[Data, FragmentAnalysis],
					SampleAnalyteType->DNA,
					LaneImageFile->Link[Object[EmeraldCloudFile,"Test Lane Image File for PlotFragmentAnalysis tests"]],
					Electropherogram -> QuantityArray[{#, RandomReal[15000]} & /@ Range[1, 2698], {Second, RFU}]
				|>
			];

			Upload[
				<|
					Name -> "FragmentAnalysis Protocol For PlotFragmentAnalysis Test " <> $SessionUUID,
					Object -> protocol1,
					Type -> Object[Protocol, FragmentAnalysis],
					Replace[Data] -> {Link[data1, Protocol]}
				|>
			];
		];
	),
	SymbolTearDown :> Module[{objects},
		objects = {
			Object[Protocol, FragmentAnalysis, "FragmentAnalysis Protocol For PlotFragmentAnalysis Test " <> $SessionUUID],
			Object[Data, FragmentAnalysis, "FragmentAnalysis Data For PlotFragmentAnalysis Test " <> $SessionUUID]
		};

		EraseObject[
			PickList[objects,DatabaseMemberQ[objects],True],
			Verbose->False,
			Force->True
		]
	]

];
