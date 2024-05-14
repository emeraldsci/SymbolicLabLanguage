(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*PlotHelpers: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*Option Formatting & Resolution*)


(* ::Subsubsection::Closed:: *)
(*resolveFrame*)


DefineTests[resolveFrame,{

	Example[{Basic,"Resolve Automatic to bottom and left frame when no second-y data:"},
		resolveFrame[Automatic,{}],
		{{True,False},{True,False}}
	],
	Example[{Basic,"Resolve Automatic to bottom, left, and right frames when there is second-y data:"},
		resolveFrame[Automatic,{{{1,2},{2,3}}}],
		{{True,True},{True,False}}
	],
	Example[{Additional,"Resolve individual Automatics:"},
		resolveFrame[{Automatic,Automatic,Automatic,Automatic},{}],
		{{True,False},{True,False}}
	],
	Example[{Additional,"Resolve individual Automatics with second-y data:"},
		resolveFrame[{Automatic,Automatic,Automatic,Automatic},{{{1,2},{2,3}}}],
		{{True,True},{True,False}}
	],
	Example[{Additional,"Given explicit list of Trues and Falses, do nothing:"},
		resolveFrame[{True,False,True,False},{}],
		{{False,False},{True,True}}
	],
	Example[{Additional,"Given explicit list of Trues and Falses, do nothing, regardless of second-y data:"},
		resolveFrame[{True,False,True,False},{{{1,2},{2,3}}}],
		{{False,False},{True,True}}
	]

}];


(* ::Subsubsection::Closed:: *)
(* formatPlotLegend *)

DefineTests[formatPlotLegend,
	{
		Example[{Basic, "Generate plot legend with a single label:"},
			formatPlotLegend[{"test label"},1,1],
			_Placed
		],
		Example[{Basic, "Generate plot legend with multiple labels:"},
			formatPlotLegend[{"test label 1","test label 2"},1,1],
			_Placed
		],
		Example[{Basic, "Generate plot legend with placing legend at bottom:"},
			formatPlotLegend[{"test"}, 1, 1, LegendPlacement -> Bottom,
				Boxes -> True, PlotMarkers -> Automatic, LegendColors -> Automatic],
			_Placed
		],
		Example[{Basic, "Generate nothing if the input format is wrong:"},
			formatPlotLegend["test"],
			None
		]
	}
];

DefineTests[rawToPacket,{

	Example[{Basic,"Plot data points with CoolingCurve:"},
		Module[{dataset,safeops},
			dataset =  {{86.76999664, 0.8889893293}, {84.31999969,
				0.8903881907}, {81.72000122, 0.8887994289}, {79.22000122,
				0.8896051645}, {76.66999817, 0.8877320886}};
			safeops = SafeOptions[PlotAbsorbanceThermodynamics,{PrimaryData -> {CoolingCurve}}];
			rawToPacket[dataset,Object[Data, MeltingCurve], PlotAbsorbanceThermodynamics,safeops]
		],
		_DynamicModule
	],

	Example[{Basic,"Plot data points with MeltingCurve:"},
		Module[{dataset,safeops},
			dataset =  {{86.76999664, 0.8889893293}, {84.31999969,
				0.8903881907}, {81.72000122, 0.8887994289}, {79.22000122,
				0.8896051645}, {76.66999817, 0.8877320886}};
			safeops = SafeOptions[PlotAbsorbanceThermodynamics,{PrimaryData -> {MeltingCurve}}];
			rawToPacket[dataset,Object[Data, MeltingCurve], PlotAbsorbanceThermodynamics,safeops]
		],
		_DynamicModule
	],

	Example[{Basic,"Plot data points with CoolingCurve, 20 points:"},
		Module[{dataset,safeops},
			dataset =  {{86.76999664, 0.8889893293}, {84.31999969,
				0.8903881907}, {81.72000122, 0.8887994289}, {79.22000122,
				0.8896051645}, {76.66999817, 0.8877320886}, {86.66999817, 0.8877320886},
				{75.22783, 0.8877320886}, {71.66999817, 0.8877320886}, {72.66999817, 0.8877320886},
				{73.66999817, 0.8877320886}, {79.66999817, 0.8877320886}, {75.66999817, 0.8877320886},
				{77.66999817, 0.8877320886}, {76.66999817, 0.8877320886}, {78.66999817, 0.8877320886},
				{72.66999817, 0.8877320886}, {74.66999817, 0.8877320886}, {77.66999817, 0.8877320886},
				{70.66999817, 0.8877320886}, {73.66999817, 0.8877320886}};
			safeops = SafeOptions[PlotAbsorbanceThermodynamics,{PrimaryData -> {CoolingCurve}}];
			rawToPacket[dataset,Object[Data, MeltingCurve], PlotAbsorbanceThermodynamics,safeops]
		],
		_DynamicModule
	],

	Example[{Basic,"Plot data points with MeltingCurve, 20 points:"},
		Module[{dataset,safeops},
			dataset =  {{86.76999664, 0.8889893293}, {84.31999969,
				0.8903881907}, {81.72000122, 0.8887994289}, {79.22000122,
				0.8896051645}, {76.66999817, 0.8877320886}, {86.66999817, 0.8877320886},
				{75.22783, 0.8877320886}, {71.66999817, 0.8877320886}, {72.66999817, 0.8877320886},
				{73.66999817, 0.8877320886}, {79.66999817, 0.8877320886}, {75.66999817, 0.8877320886},
				{77.66999817, 0.8877320886}, {76.66999817, 0.8877320886}, {78.66999817, 0.8877320886},
				{72.66999817, 0.8877320886}, {74.66999817, 0.8877320886}, {77.66999817, 0.8877320886},
				{70.66999817, 0.8877320886}, {73.66999817, 0.8877320886}};
			safeops = SafeOptions[PlotAbsorbanceThermodynamics,{PrimaryData -> {MeltingCurve}}];
			rawToPacket[dataset,Object[Data, MeltingCurve], PlotAbsorbanceThermodynamics,safeops]
		],
		_DynamicModule
	],

	Example[{Basic,"Plot data points with Cooling, 1 points:"},
		Module[{dataset,safeops},
			dataset =  {{86.76999664, 0.8889893293}};
			safeops = SafeOptions[PlotAbsorbanceThermodynamics,{PrimaryData -> {CoolingCurve}}];
			rawToPacket[dataset,Object[Data, MeltingCurve], PlotAbsorbanceThermodynamics,safeops]
		],
		_DynamicModule
	]

}];

