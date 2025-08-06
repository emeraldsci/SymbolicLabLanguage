(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotLuminescenceSpectroscopy*)


DefineTests[PlotLuminescenceSpectroscopy,
	{
		Example[
			{Basic,"Plot the luminescence spectrum for a given data object:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot multiple data objects:"},
			PlotLuminescenceSpectroscopy[{Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"],Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"]}],
			_?ValidGraphicsQ
		],
		Example[
			{Basic, "Plot the luminescence spectrum for data objects linked to a LuminescenceSpectroscopy protocol object:"},
			PlotLuminescenceSpectroscopy[Object[Protocol, LuminescenceSpectroscopy, "LuminescenceSpectroscopy Test Protocol 1"]],
			SlideView[{ValidGraphicsP[] ..}]
		],
		Example[
			{Options,PrimaryData,"Indicate that the spectrum should be plotted on the y-axis:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"],PrimaryData->EmissionSpectrum],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"There is no secondary data to display:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"],SecondaryData->{}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Display,"Use the display option to turn peak plotting off and on:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],Display->{}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Peaks,"Indicate the peaks that should be overlaid on the plot:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],Peaks->Object[Analysis,Peaks,"LuminescenceSpectroscopy Test Peaks"]],
			_?ValidGraphicsQ
		],
		Example[{Options,Units,"Specify the units to use when plotting the spectrum:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],Units->{EmissionTrajectories->{Nanometer,Kilo*RFU}}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"],PlotTheme -> "Marketing"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Zoomable,"Disallow interactive zooming by setting Zoomable->False:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"],Zoomable->False],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,TargetUnits,"Specify units for the XY axes:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],TargetUnits->{Nanometer,RLU}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotLuminescenceSpectroscopy[{Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"],Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"]},LegendPlacement->Right],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotLabel, "Provide a title for the plot:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"],PlotLabel -> "Luminescence Spectrum"],
			_?ValidGraphicsQ
		],
		Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"],FrameLabel -> {"Wavelength", "Recorded Luminescence", None, None}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotLuminescenceSpectroscopy[
				{Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 1"],Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"]},
				Boxes -> True
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Map,"Indicate that multiple plots should be created instead of overlaying data:"},
			PlotLuminescenceSpectroscopy[{Object[Data, LuminescenceSpectroscopy, "LuminescenceSpectroscopy Test Data 1"],Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"]},Map->True],
			{_?ValidGraphicsQ..}
		],
		Example[
			{Options,Legend,"Display a legend with the plot:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],Legend->{"My Data"}],
			_?Core`Private`ValidLegendedQ
		],
		Example[{Options,IncludeReplicates,"Indicate that replicate data should be averaged together and shown with error bars:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],IncludeReplicates->True],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,EmissionSpectrum,"Provide a new value for the spectrum instead of using the value recorded in the object being plotted:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],EmissionSpectrum->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,RLU}]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		
		Example[{Options,LegendLabel,"Specify the text displayed above the plot legend:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],LegendLabel->"Example Label"],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		
		Example[{Options,Scale,"Log-transform the luminescence values:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],Scale->Log],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[{Options,Fractions,"Specify fractions to be highlighted:"},
			fractions={{340 Nanometer,345 Nanometer,"A1"},{345 Nanometer,350 Nanometer,"A2"},{350 Nanometer,355 Nanometer,"A3"},{355 Nanometer,360 Nanometer,"A4"}};
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],Fractions->fractions],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		
		Example[{Options,Filling,"Specifies how the region surrounding the data is visualized:"},
			PlotLuminescenceSpectroscopy[Object[Data,LuminescenceSpectroscopy,"LuminescenceSpectroscopy Test Data 2"],Filling->None],
			ValidGraphicsP[],
			TimeConstraint->120
		],		
		
		(* Output tests *)
		Test[
			"Setting Output to Result returns the plot:",
			PlotLuminescenceSpectroscopy[Object[Data, LuminescenceSpectroscopy, "LuminescenceSpectroscopy Test Data 1"],Output->Result],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Setting Output to Preview returns the plot:",
			PlotLuminescenceSpectroscopy[Object[Data, LuminescenceSpectroscopy, "LuminescenceSpectroscopy Test Data 1"],Output->Preview],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Setting Output to Options returns the resolved options:",
			PlotLuminescenceSpectroscopy[Object[Data, LuminescenceSpectroscopy, "LuminescenceSpectroscopy Test Data 1"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotLuminescenceSpectroscopy]],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Tests returns a list of tests:",
			PlotLuminescenceSpectroscopy[Object[Data, LuminescenceSpectroscopy, "LuminescenceSpectroscopy Test Data 1"],Output->Tests],
			{(_EmeraldTest|_Example)...},
			TimeConstraint->120
		],
		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for data object input:",
			PlotLuminescenceSpectroscopy[Object[Data, LuminescenceSpectroscopy, "LuminescenceSpectroscopy Test Data 1"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotLuminescenceSpectroscopy]]
		],
		Test[
			"Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotLuminescenceSpectroscopy[Object[Data, LuminescenceSpectroscopy, "LuminescenceSpectroscopy Test Data 1"],Output->Options],
			Sort@Keys@SafeOptions@PlotLuminescenceSpectroscopy,
			TimeConstraint->120
		]
	},
	SymbolSetUp:>Module[{data1, data2, protocol1},
		$CreatedObjects={};

		{data1, data2, protocol1} = CreateID[{Object[Data, LuminescenceSpectroscopy], Object[Data, LuminescenceSpectroscopy], Object[Protocol, LuminescenceSpectroscopy]}];
		Upload[{
			<|
				Object->data1,
				Name->"LuminescenceSpectroscopy Test Data 1",
				EmissionSpectrum->QuantityArray[Table[{x+300,0.25 Exp[-.01 (x-50)^2]},{x,Range[0,100,0.2]}],{Nanometer,RLU}],
				Well->"A1"
			|>,
			<|
				Object->data2,
				Name->"LuminescenceSpectroscopy Test Data 2",
				EmissionSpectrum->QuantityArray[Table[{x+300,0.26 Exp[-.012 (x-50)^2]},{x,Range[0,100,0.2]}],{Nanometer,RLU}],
				Well->"A1",
				Replace[Replicates]->{Link[data1,Replicates]}
			|>
		}];
		AnalyzePeaks[data2,Name->"LuminescenceSpectroscopy Test Peaks"];
		Upload[<|
			Object -> protocol1,
			Name -> "LuminescenceSpectroscopy Test Protocol 1",
			Replace[Data] -> {Link[data1, Protocol], Link[data2, Protocol]}
		|>];
	],
	SymbolTearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	)
];
