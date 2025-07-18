(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAlphaScreen*)

DefineTests[PlotAlphaScreen,
	{

		Example[{Basic,"Plot a histogram of intensities:"},
			PlotAlphaScreen[objsHighIntensity],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Test["Given a packet:",
			PlotAlphaScreen[Download[objsHighIntensity]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Basic, "Plot data objects linked to a protocol when given an AlphaScreen protocol object:"},
			PlotAlphaScreen[Object[Protocol, AlphaScreen, "AlphaScreen Protocol for PlotAlphaScreen Test "<>$SessionUUID]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Basic,"Plot a histogram of intensities from links:"},
			PlotAlphaScreen[linksObjsHighIntensity],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Basic,"Compare intensities across datasets using a BoxWhiskerChart:"},
			PlotAlphaScreen[Download/@{objsHighIntensity,objsMedIntensity,objsLowIntensity}],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],


		(*
			ADDITIONAL
		*)
		Example[{Additional,"Input Type","List of info packets:"},
			PlotAlphaScreen[Download[objsHighIntensity]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Basic,"Input Type","Grouped lists of info packets:"},
			PlotAlphaScreen[Download/@{objsHighIntensity,objsMedIntensity,objsLowIntensity}],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Additional,"Input Type","List of intensity values:"},
			PlotAlphaScreen[RandomVariate[NormalDistribution[500,10],1000]*RLU],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Additional,"Input Type","Grouped lists of intensity values:"},
			PlotAlphaScreen[Map[RandomVariate[NormalDistribution[#,50],1000]&,{400,500,600}]*RLU],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		(*
			QAs
		*)
		Example[{Additional,"Quantity Arrays","QuantityArray of intensities:"},
			PlotAlphaScreen[QuantityArray[RandomVariate[NormalDistribution[50, 5], 1000],RLU]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Additional,"Quantity Arrays","A list of intensity quantity arrays:"},
			PlotAlphaScreen[{QuantityArray[RandomVariate[NormalDistribution[50, 5], 1000],RLU],QuantityArray[RandomVariate[NormalDistribution[40, 8], 1000],RLU]}],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Additional,"Quantity Arrays","Given a QuantityArray containing a single group of intensity data sets:"},
			PlotAlphaScreen[QuantityArray[{RandomVariate[NormalDistribution[50,5],1000],RandomVariate[NormalDistribution[40, 8],1000]},RLU]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],


		(*
			OPTIONS
		*)
		Example[{Options,DataSet,"Use the intensity data measured at the primary wavelength:"},
			PlotAlphaScreen[objsHighIntensity,DataSet->Intensity],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		Example[{Options,PlotType,"A flat list of intensities defaults to a Histogram diplsay:"},
			PlotAlphaScreen[objsHighIntensity],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,PlotType,"A flat list of intensities can also be displayed as a BarChart or BoxWhiskerChart:"},
			Grid[{{PlotAlphaScreen[objsHighIntensity,PlotType->BarChart],PlotAlphaScreen[objsHighIntensity,PlotType->BoxWhiskerChart]}}],
			Grid[{{ValidGraphicsP[], ValidGraphicsP[]}}],
			TimeConstraint -> 120
		],
		Example[{Options,PlotType,"Grouped lists of intensities defaults to a BoxWhiskerChart display:"},
			PlotAlphaScreen[Download[{objsHighIntensity,objsMedIntensity,objsLowIntensity}]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,PlotType,"Grouped lists of intensities can also be displayed as a BarChart or Histogram:"},
			Grid[{{
				PlotAlphaScreen[Download[{objsHighIntensity,objsMedIntensity,objsLowIntensity}],PlotType->BarChart],
				PlotAlphaScreen[Download[{objsHighIntensity,objsMedIntensity,objsLowIntensity}],PlotType->Histogram]}}],
			Grid[{{ValidGraphicsP[], ValidGraphicsP[]}}],
			TimeConstraint -> 120
		],


		Example[{Options,TargetUnits,"TargetUnits default to the unit on the data:"},
			PlotAlphaScreen[RandomVariate[NormalDistribution[500000,10000],1000]*Milli*RLU,TargetUnits->Automatic],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,TargetUnits,"Specify a TargetUnit:"},
			PlotAlphaScreen[RandomVariate[NormalDistribution[500000,10000],1000]*Milli*RLU,TargetUnits->RLU],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,TargetUnits,"Specify a TargetUnit when given data objects:"},
			PlotAlphaScreen[Download[objsHighIntensity],TargetUnits->Kilo*RLU],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,TargetUnits,"Specify a TargetUnit when given grouped data objects:"},
			PlotAlphaScreen[
				{
					Download[objsHighIntensity],
					Download[objsMedIntensity],
					Download[objsLowIntensity]
				},
				TargetUnits->Kilo*RLU
			],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,TargetUnits,"Specify a TargetUnit for a BarChart:"},
			PlotAlphaScreen[objsHighIntensity,TargetUnits->Kilo*RLU,PlotType->BarChart],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		Example[{Options,Legend,"Create a plot legend:"},
			PlotAlphaScreen[Download/@{objsHighIntensity,objsMedIntensity,objsLowIntensity},
				PlotType->Histogram,
				Legend->{"A","B","C"}
			],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		Example[{Options,BoxWhiskerType,"Use BoxWhiskerChart options to show additional information, here a mean confidence interval diamond:"},
			PlotAlphaScreen[Download/@{objsHighIntensity,objsMedIntensity,objsLowIntensity},
				PlotType->BoxWhiskerChart,
				BoxWhiskerType->"Diamond"
			],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		Example[{Options,ChartLabels,"Label the plot:"},
			PlotAlphaScreen[
				Download/@{objsHighIntensity,objsMedIntensity,objsLowIntensity},
				ChartLabels->{"A","B","C"}
			],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,Output,"Return a plot when Output->Preview:"},
			PlotAlphaScreen[objsHighIntensity, Output->Preview],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,Output,"Return a list of resolved options when Output->Options:"},
			Lookup[PlotAlphaScreen[objsHighIntensity, Output->Options],Output],
			Options,
			TimeConstraint -> 120
		],
		Example[{Options,Output,"Return an empty list when Output->Tests:"},
			PlotAlphaScreen[objsHighIntensity, Output->Tests],
			{},
			TimeConstraint -> 120
		]
	},


	Variables:>{objsHighIntensity,objsMedIntensity,objsLowIntensity,linksObjsHighIntensity},
	SetUp:>(
		objsHighIntensity={Object[Data, AlphaScreen, "id:mnk9jOR1LE5l"],
			Object[Data, AlphaScreen, "id:BYDOjvGWnzxl"],
			Object[Data, AlphaScreen, "id:M8n3rx0WRwXl"]};
		objsMedIntensity={Object[Data, AlphaScreen, "id:WNa4ZjK7k3ER"],
			Object[Data, AlphaScreen, "id:54n6evLwOZ3L"],
			Object[Data, AlphaScreen, "id:n0k9mG8ZEndk"]};
		objsLowIntensity={Object[Data, AlphaScreen, "id:Vrbp1jK7YWLO"],
			Object[Data, AlphaScreen, "id:XnlV5jK7P6YM"],
			Object[Data, AlphaScreen, "id:bq9LA0J6L0jv"]};
		linksObjsHighIntensity=Map[Link[#,Protocol]&,objsHighIntensity];
	),

	SymbolSetUp :> (
		Module[{allObjects},
			allObjects={
				Object[Data, AlphaScreen, "AlphaScreen Data for PlotAlphaScreen test " <> $SessionUUID],
				Object[Protocol, AlphaScreen, "AlphaScreen Protocol for PlotAlphaScreen Test "<>$SessionUUID]
			};

			EraseObject[
				PickList[allObjects, DatabaseMemberQ[allObjects]],
				Force -> True,
				Verbose -> False
			]
		];

		$CreatedObjects={};

		Module[{data1, protocol1},
			{data1, protocol1} = CreateID[{Object[Data, AlphaScreen], Object[Protocol, AlphaScreen]}];

			Upload[
				<|
					Name -> "AlphaScreen Data for PlotAlphaScreen test " <> $SessionUUID,
					Object -> data1,
					Type -> Object[Data, AlphaScreen],
					Intensity -> 190. RLU
				|>
			];

			Upload[
				<|
					Name -> "AlphaScreen Protocol for PlotAlphaScreen Test "<>$SessionUUID,
					Object -> protocol1,
					Type -> Object[Protocol, AlphaScreen],
					Replace[Data] -> {Link[data1, Protocol]}
				|>
			];
		]
	),
	SymbolTearDown:>Module[{objsToErase},
		objsToErase=Flatten[{
			$CreatedObjects,
			Object[Data, AlphaScreen, "AlphaScreen Data for PlotAlphaScreen test " <> $SessionUUID],
			Object[Protocol, AlphaScreen, "AlphaScreen Protocol for PlotAlphaScreen Test "<>$SessionUUID]
		}];

		EraseObject[
			PickList[objsToErase,DatabaseMemberQ[objsToErase]],
			Force->True,
			Verbose->False
		];
	]


];
