(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotTrajectory*)

DefineTests[trajectoryConcentrationSum,
	{
		Test["Make sure concentrations are summed correctly:",
			trajectoryConcentrationSum[Trajectory[{"a","b"},{{1,8},{2,6},{3,2}}, {2,4,6}, {Quantity["Seconds"], Quantity["Molar"]}]],
			Trajectory[{"ConcentrationSum"},{{9},{8},{5}}, {2,4,6}, {Quantity["Seconds"], Quantity["Molar"]}]
		]
	}
];

DefineTests[PlotTrajectory,
	{
		Example[{Basic,"Plot a kinetic simulation object:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"]],
			ZoomableP_?ValidGraphicsQ
		],

		Test["Given link:",
			PlotTrajectory[Link[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],Reference]],
			ZoomableP_?ValidGraphicsQ
		],

		Test["Given packet:",
			PlotTrajectory[Download[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"]]],
			ZoomableP_?ValidGraphicsQ
		],

		Example[{Basic,"Plot a list of simulation objects:"},
			PlotTrajectory[{Object[Simulation, Kinetics, "id:Vrbp1jG36WRo"],Object[Simulation, Kinetics, "id:XnlV5jmaM6Gz"],Object[Simulation, Kinetics, "id:qdkmxz0V7Z90"]}],
			ValidGraphicsP[]
		],

		Example[{Basic,"Plot all species in a trajectory:"},
			PlotTrajectory[trajectory],
			ZoomableP_?ValidGraphicsQ
		],

		Example[{Basic,"Plot only species a and g:"},
			PlotTrajectory[trajectory,{"a","g"}],
			ZoomableP_?ValidGraphicsQ
		],

		Example[{Additional,"Plot only the second and fourth species:"},
			PlotTrajectory[trajectory,{2,4}],
			ZoomableP_?ValidGraphicsQ
		],

		Example[{Additional,"Plot the 3 most abundant species:"},
			PlotTrajectory[trajectory,3],
			ZoomableP_?ValidGraphicsQ
		],

		Example[{Additional,"Plot the 5 least abundant species:"},
			PlotTrajectory[trajectory,-5],
			ZoomableP_?ValidGraphicsQ
		],

		Example[{Options,Tooltip,"Specify labels to appear above each trajectory on mouseover:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],Tooltip->{"String",Symbol,Structure[{Strand[DNA["ATCG"]]}],Strand[DNA["ATCG"]]}],
			ValidGraphicsP[]
		],

		Example[{Options,TotalConcentration,"Plot the sum of concentrations over all species in each simulation:"},
			PlotTrajectory[
				{
					Object[Simulation, Kinetics, "id:Vrbp1jG36WRo"],
					Object[Simulation, Kinetics, "id:XnlV5jmaM6Gz"]
				},
				TotalConcentration -> True],
			ValidGraphicsP[]
		],

		Example[{Options,Temperature,"Specify a temperature profile for the second y axis:"},
			PlotTrajectory[trajectory,Temperature->temperpatureCoordinates],
			ZoomableP_?ValidGraphicsQ
		],

		Example[{Options,Volume,"Specify a temperature profile for the second y axis:"},
			PlotTrajectory[trajectory,Volume->volumeCoordinates],
			ZoomableP_?ValidGraphicsQ
		],

		Example[{Options,Draw,"Specify what the mouseover shows:"},
			PlotTrajectory[trajectory,Draw->3],
			ZoomableP_?ValidGraphicsQ
		],

		Example[{Messages,"BadSpecies","Bad species specification:"},
			PlotTrajectory[trajectory,{"a","x"}],
			$Failed,
			Messages:>{Trajectory::BadSpecies}
		],

		Example[{Messages,"NoSpecies","No valid species:"},
			PlotTrajectory[trajectory,{"x","y"}],
			$Failed,
			Messages:>{Trajectory::BadSpecies,Trajectory::BadSpecies}
		],

		Example[{Messages,"InvalidNumberOfSpecies","Too many species requested:"},
			PlotTrajectory[trajectory,10],
			_?ValidGraphicsQ,
			Messages:>{Warning::InvalidNumberOfSpecies}
		],

		Example[{Messages,"InvalidIndices","Invalid species index specified:"},
			PlotTrajectory[trajectory,{1,2,20}],
			$Failed,
			Messages:>{Error::InvalidIndices}
		],

		Example[{Additional,"Mixed list of species types:"},
			PlotTrajectory[
				Trajectory[
					{"x","ATCGATCGATCG",Structure[{Strand[DNA["ATCGATCG"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]},
					{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},
					{Second,Mole/Liter}
				]
			],
			_?ValidGraphicsQ
		],

		Example[{Options,SecondaryData,"By default, SecondaryData is displayed only if its values vary with time:"},
			{
				PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"], SecondaryData -> Automatic],
				PlotTrajectory[Object[Simulation, Kinetics, "id:qdkmxzqknkYM"], SecondaryData -> Automatic]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],

		Example[{Options,SecondaryData,"Force the display of secondary data, even if it's a constant value:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:qdkmxzqknkYM"], SecondaryData -> Temperature],
			ValidGraphicsP[]
		],

		Example[{Options,SecondaryData,"Plot Volume first on secondary axis:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],{"ab"},SecondaryData->{Volume,Temperature}],
			ValidGraphicsP[]
		],

		Example[{Options,SecondaryData,"Plot only Temperature on secondary axis:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],{"ab"},SecondaryData->Temperature],
			ValidGraphicsP[]
		],

		Example[{Options,Legend,"Automatically resolve the legend based on the species names:"},
			PlotTrajectory[
				Trajectory[
					{"x","ATCGATCGATCG",Structure[{Strand[DNA["ATCGATCG"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]},
					{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},
					{Second,Mole/Liter}
				],
				Legend->Automatic
			],
			ZoomableP_?Core`Private`ValidLegendedQ
		],

		Example[{Options,LegendPlacement,"Adjust the legend position:"},
			PlotTrajectory[
				Trajectory[
					{"x","ATCGATCGATCG",Structure[{Strand[DNA["ATCGATCG"]]},{Bond[{1,1,1;;3},{1,1,4;;6}]}]},
					{{1,2,3},{4,5,6},{7,8,9},{10,11,12},{13,14,15}},{1,2,3,4,5},
					{Second,Mole/Liter}
				],
				Legend->Automatic,
				LegendPlacement->Bottom
			],
			ZoomableP_?Core`Private`ValidLegendedQ
		],

		Example[{Options,TargetUnits,"Specify x & y units:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],TargetUnits->{Minute,Millimolar}],
			ValidGraphicsP[]
		],

		Example[{Options,TargetUnits,"Specify x unit:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],TargetUnits->{Minute,Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,TargetUnits,"Specify y unit:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],TargetUnits->{Automatic,Millimolar}],
			ValidGraphicsP[]
		],

		Example[{Options,SecondYUnit,"Specify unit for second-y axis of temperature:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],SecondYUnit->Fahrenheit],
			ValidGraphicsP[]
		],

		Example[{Options,SecondYUnit,"Specify unit for second-y axis of volume:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],SecondaryData->Volume,SecondYUnit->Microliter],
			ValidGraphicsP[]
		],

		Example[{Options,Zoomable,"Toggle the interactive zoom feature:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"], Zoomable->False],
			ValidGraphicsP[]
		],

		Example[{Options,ImageSize,"Specify the plot size:"},
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],ImageSize->Medium],
			ValidGraphicsP[]
		],

		(* Output tests *)
		Test["Setting Output to Result returns the plot:",
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],Output->Result],
			_?ValidGraphicsQ
		],

		Test["Setting Output to Preview returns the plot:",
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],Output->Preview],
			_?ValidGraphicsQ
		],

		Test["Setting Output to Options returns the resolved options:",
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotTrajectory]]
		],

		Test["Setting Output to Tests returns a list of tests:",
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],Output->Tests],
			{(_EmeraldTest|_Example)...}
		],

		Test["Setting Output to {Result,Options} returns the plot along with all resolved options:",
			PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotTrajectory]]
		],

		Test["Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotTrajectory[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"],Output->Options],
			Sort@Keys@SafeOptions@PlotTrajectory
		]

	},
	Variables:>{trajectory,temperpatureCoordinates,volumeCoordinates},
	SetUp:>(
		trajectory=SimulateKinetics[{{"a"->"c",1},{"a"->"b"+"c",2},{"a"->2"h",.1},{2"e"->"a",.001},{"e"+"f"->"g",.2},{"h"\[Equilibrium]"c",10,.05},{"h"+"d"->"c"+"a",.005}},{"a"->10^-3,"b"->10^-4,"c"->10^-5},1 Second,Output->Result,Upload->False];
		temperpatureCoordinates = QuantityArray[Table[{t,30+5*Sin[Pi*t]},{t,0,1,0.01}],{Second,Celsius}];
		volumeCoordinates = QuantityArray[Table[{t,Piecewise[{{100,t<.1},{100t+90,t<0.3},{120,t<0.6},{50t+90,t<0.8}},130]},{t,0,1,0.01}],{Second,Microliter}];
	)
]
