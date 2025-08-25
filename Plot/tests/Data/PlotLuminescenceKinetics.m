(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotLuminescenceKinetics*)


DefineTests[PlotLuminescenceKinetics,
	{
		Example[
			{Basic,"Plot the luminescence trajectory for a given data object:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot multiple data objects:"},
			PlotLuminescenceKinetics[{Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"]}],
			_?ValidGraphicsQ
		],
		Example[
			{Basic, "Plot the luminescence trajectory for data objects linked to a LuminescenceKinetics protocol object:"},
			PlotLuminescenceKinetics[Object[Protocol, LuminescenceKinetics,"LuminescenceKinetics Test Protocol 1"]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot the luminescence trajectory and temperature trace of the data of interest:"},
			PlotLuminescenceKinetics[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 2"],SecondaryData->{Temperature}],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot a raw emission trajectory:"},
			PlotLuminescenceKinetics[Download[{Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"]},EmissionTrajectories]],
			_?ValidGraphicsQ
		],		
		Example[
			{Basic,"Plot multiple raw emission trajectories:"},
			PlotLuminescenceKinetics[
				Download[{
					Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],
					Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"]
				},EmissionTrajectories]			
			],
			_?ValidGraphicsQ
		],
		Example[
			{Options,PrimaryData,"Indicate that the temperature should be plotted on the y-axis:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],PrimaryData->Temperature],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"Indicate that temperature should be plotted on the second y-axis:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],SecondaryData->{Temperature}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Display,"There is no additional display data:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],Display->{}],
			_?ValidGraphicsQ
		],
		Example[{Options,Units,"Specify the units to use when plotting the emission trajectory:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],Units->{EmissionTrajectories->{Nanometer,Kilo*RFU}}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],PlotTheme -> "Marketing"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Zoomable,"Disallow interactive zooming by setting Zoomable->False:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],Zoomable->False],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,TargetUnits,"Specify units for the XY axes:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],TargetUnits->{Second,RLU}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotLuminescenceKinetics[{Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"]},LegendPlacement->Right],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotLabel, "Provide a title for the plot:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],PlotLabel -> "Luminescence Spectrum"],
			_?ValidGraphicsQ
		],
		Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],FrameLabel -> {"Wavelength", "Recorded Luminescence", None, None}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotLuminescenceKinetics[
				{Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 1"],Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"]},
				Boxes -> True
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Temperature,"Include temperature data on the plot:"},
			Module[{myData,myTemp},
				{myTemp,myData}=Download[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],{Temperature,EmissionTrajectories}];
				PlotLuminescenceKinetics[myData,
					Temperature->myTemp
				]
			],
			_DynamicModule
		],
		Example[
			{Options,Map,"Indicate that multiple plots should be created instead of overlaying data:"},
			PlotLuminescenceKinetics[{Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"]},Map->True],
			{_?ValidGraphicsQ..}
		],
		Example[
			{Options,Legend,"Display a legend with the plot:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],Legend->{"My Data"}],
			_?Core`Private`ValidLegendedQ
		],
		Example[{Options,IncludeReplicates,"Indicate that replicate data should be averaged together and shown with error bars:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],PrimaryData->Temperature,IncludeReplicates->True],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,EmissionWavelength,"Display the trajectory measured at the specified emission wavelength:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],EmissionWavelength->590 Nanometer],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,DualEmissionWavelength,"Display the trajectory measured at the specified emission wavelength:"},
			PlotLuminescenceKinetics[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],DualEmissionWavelength->520 Nanometer],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,EmissionTrajectories,"Provide a new value for the trajectory instead of using the value recorded in the object being plotted:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],EmissionTrajectories->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,RFU}]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,DualEmissionTrajectories,"Provide a new value for the secondary trajectory instead of using the value recorded in the object being plotted:"},
			PlotLuminescenceKinetics[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],DualEmissionTrajectories->QuantityArray[Table[{x, Sqrt[x]/100}, {x, 250, 1000, 10}], {Nanometer, RFU}],PrimaryData -> DualEmissionTrajectories],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		
		Example[{Options,LegendLabel,"Specify the text displayed above the plot legend:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],LegendLabel->"Example Label"],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		
		Example[{Options,Scale,"Log-transform the luminescence values:"},
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],Scale->Log],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[{Options,Fractions,"Specify fractions to be highlighted:"},
			fractions={{1 Hour,1.5 Hour,"A1"},{1.5 Hour,2 Hour,"A2"},{2 Hour,2.5 Hour,"A3"},{2.5 Hour,3 Hour,"A4"}};
			PlotLuminescenceKinetics[Object[Data,LuminescenceKinetics,"LuminescenceKinetics Test Data 2"],Fractions->fractions],
			ValidGraphicsP[],
			TimeConstraint->120
		],		
		
		(* Output tests *)
		Test[
			"Setting Output to Result returns the plot:",
			PlotLuminescenceKinetics[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],Output->Result],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Test[
			"Setting Output to Preview returns the plot:",
			PlotLuminescenceKinetics[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],Output->Preview],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Test[
			"Setting Output to Options returns the resolved options:",
			PlotLuminescenceKinetics[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotLuminescenceKinetics]],
			TimeConstraint->120
		],

		Test[
			"Setting Output to Tests returns a list of tests:",
			PlotLuminescenceKinetics[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],Output->Tests],
			{(_EmeraldTest|_Example)...},
			TimeConstraint->120
		],

		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for data object input:",
			PlotLuminescenceKinetics[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotLuminescenceKinetics]]
		],

		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for raw trajectory input:",
			PlotLuminescenceKinetics[Download[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],EmissionTrajectories],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotLuminescenceKinetics]],
			TimeConstraint->120
		],

		Test[
			"Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotLuminescenceKinetics[Object[Data, LuminescenceKinetics, "LuminescenceKinetics Test Data 1"],Output->Options],
			Sort@Keys@SafeOptions@PlotLuminescenceKinetics,
			TimeConstraint->120
		]
		
	},
	SymbolSetUp:>Module[{data1, protocol1},
		$CreatedObjects={};
		{data1, protocol1} = CreateID[{Object[Data, LuminescenceKinetics], Object[Protocol, LuminescenceKinetics]}];
		Upload[{
			<|
				Object->data1,
				Name->"LuminescenceKinetics Test Data 1",
				Replace[EmissionTrajectories]->{QuantityArray[{#,100000/(1+Round[Exp[-.2 #]])}&/@Range[0,10],{Hour,RLU}]},
				Temperature->QuantityArray[{#,37+Random[]}&/@Range[0,10],{Hour,Celsius}],
				Replace[EmissionWavelengths]->{590 Nanometer},
				Well->"A1",
				Replace[Gains]->{2500 Microvolt}
			|>,
			<|
				Type->Object[Data,LuminescenceKinetics],
				Name->"LuminescenceKinetics Test Data 2",
				Replace[EmissionTrajectories]->{QuantityArray[{#,90000/(1+Round[Exp[-.25 #]])}&/@Range[0,10],{Hour,RLU}]},
				Replace[DualEmissionTrajectories]->{QuantityArray[{#,50000+Random[]*1000}&/@Range[0,10],{Hour,RLU}]},
				Temperature->QuantityArray[{#,37+Random[]}&/@Range[0,10],{Hour,Celsius}],
				Replace[EmissionWavelengths]->{590 Nanometer},
				Replace[DualEmissionWavelengths]->{520 Nanometer},
				Well->"A1",
				Replace[Gains]->{2500 Microvolt},
				Replace[Replicates]->{Link[data1,Replicates]}
			|>
		}];
		Upload[<|
			Object -> protocol1,
			Type -> Object[Protocol, LuminescenceKinetics],
			Name -> "LuminescenceKinetics Test Protocol 1",
			Replace[Data] -> {Link[data1, Protocol]}
		|>]
	],
	SymbolTearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	)
];
