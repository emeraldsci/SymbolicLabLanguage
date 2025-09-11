(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCircularDichroism*)


DefineTests[PlotCircularDichroism,
	{
		Example[
			{Basic,"Plots circular dichroism spectroscopy data when given a CircularDichroism data object:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test[
			"Given a packet:",
			PlotCircularDichroism[Download[Object[Data, CircularDichroism, "id:eGakldJqOnaB"]]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots circular dichroism spectroscopy data when given a CircularDichroism data link:"},
			PlotCircularDichroism[Link[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Protocol]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots circular dichroism spectroscopy data when given a CircularDichroism protocol object:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"][Protocol]],
			SlideView[{ValidGraphicsP[] ..}],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots circular dichroism spectroscopy data when given a list of XY coordinates representing the spectra:"},
			PlotCircularDichroism[Download[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],CircularDichroismAbsorbanceSpectrum]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots multiple sets of data on the same graph:"},
			PlotCircularDichroism[{Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],Object[Data, CircularDichroism, "id:eGakldJqOnaB"]}, Overlay->True],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		Example[
			{Options,Overlay,"By default, plots of multiple data objects will be generated separately:"},
			PlotCircularDichroism[
				{Object[Data, CircularDichroism, "id:J8AY5jDMlm99"], Object[Data, CircularDichroism, "id:8qZ1VW0JPeYX"], Object[Data, CircularDichroism, "id:rea9jlRBYLno"]}
 			],
			{ValidGraphicsP[]..},
			TimeConstraint->120
		],
		Example[
			{Options,Overlay,"Set Overlay->True to overlay multiple data on the same plot:"},
			PlotCircularDichroism[
				{Object[Data, CircularDichroism, "id:J8AY5jDMlm99"], Object[Data, CircularDichroism, "id:8qZ1VW0JPeYX"], Object[Data, CircularDichroism, "id:rea9jlRBYLno"]},
				Overlay -> True
 			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,TargetUnits,"Plot the x-axis in units of pm:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],TargetUnits->{Meter Pico,AngularDegree Milli}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Map,"Generate a separate plot for each data object given:"},
			PlotCircularDichroism[{Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"]}],
			{ValidGraphicsP[],ValidGraphicsP[]},
			TimeConstraint->120
		],
		Example[
			{Options,Legend,"Provide a custom legend for the data:"},
			PlotCircularDichroism[{Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"]}, Overlay->True, Legend->{"Data 219098","Data 219097"}],
			_?Core`Private`ValidLegendedQ,
			TimeConstraint->120
		],
		Example[
			{Options,Units,"Specify relevant units:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Units->{CircularDichroismAbsorbanceSpectrum->{Meter Nano,AngularDegree Milli},AbsorbanceSpectrum->{Meter Nano,AbsorbanceUnit}}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,PrimaryData,"Indicate that the raw circular dichroism spectrum prior to blanking should be plotted on the y-axis:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],PrimaryData->UnblankedCircularDichroismAbsorbanceSpectrum],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"Indicate that the raw circular dichroism spectrum prior to blanking should be plotted on the second y-axis:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],SecondaryData->{AbsorbanceSpectrum}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Display,"By default picked peaks are displayed on top of the plot. Hide peaks by clearing the display:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Display->{}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],PlotTheme -> "Marketing"],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Zoomable,"To improve performance indicate that the plot should not allow interactive zooming:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Zoomable->False],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,ImageSize,"Specify the dimensions of the plot:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],ImageSize->Medium],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,PlotLabel,"Provide a title for the plot:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],PlotLabel->"Ellipticity Spectrum"],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,FrameLabel,"Specify custom x and y-axis labels:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],FrameLabel -> {"Wavelength", "Ellipticity", None, None}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,OptionFunctions,"Turn off formatting based on the circular dichroism value at a given wavelength by clearing the option functions:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],OptionFunctions -> {}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,CircularDichroismSpectrum,"Provide a new value for the CircularDichroismSpectrum instead of using the value recorded in the object being plotted:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],CircularDichroismSpectrum->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,AngularDegree Milli}]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,CircularDichroismAbsorbanceSpectrum,"Provide a new value for the CircularDichroismAbsorbanceSpectrum instead of using the value recorded in the object being plotted:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],CircularDichroismAbsorbanceSpectrum->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,AngularDegree Milli}]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Peaks,"Provide a new value for the CircularDichroismAbsorbanceSpectrum instead of using the value recorded in the object being plotted:"},
			PlotCircularDichroism[
				Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],
				Peaks->AnalyzePeaks[
					Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"][CircularDichroismAbsorbanceSpectrum]
				]
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,AbsorbanceSpectrum,"Provide a new value for the UnblankedAbsorbanceSpectrum instead of using the value recorded in the object being plotted:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],PrimaryData->{UnblankedAbsorbanceSpectrum,AbsorbanceSpectrum},AbsorbanceSpectrum->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,AbsorbanceUnit}]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,UnblankedCircularDichroismSpectrum,"Provide a new value for the Transmittance instead of using the value recorded in the object being plotted:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],PrimaryData->{CircularDichroismSpectrum},SecondaryData->{AbsorbanceSpectrum},UnblankedCircularDichroismSpectrum->QuantityArray[Table[{x,75},{x,200,1000}],{Nanometer,AngularDegree Milli}]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotCircularDichroism[
				{Object[Data, CircularDichroism, "id:4pO6dM5RoZO7"],
				Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],
				Object[Data, CircularDichroism, "id:Vrbp1jKYdBbz"]},
				Overlay -> True,
				LegendPlacement -> Right
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotCircularDichroism[
				{Object[Data, CircularDichroism, "id:4pO6dM5RoZO7"],
					Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],
					Object[Data, CircularDichroism, "id:Vrbp1jKYdBbz"]},
				Overlay -> True,
				Boxes -> True
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Fractions,"Indicate a series of fractions to overlay on the plot:"},
			PlotCircularDichroism[
				Object[Data, CircularDichroism, "id:eGakldJqOnaB"],
				Fractions->{
					{250 Nanometer,270 Nanometer,"A1"},
					{270 Nanometer,290 Nanometer,"A2"},
					{290 Nanometer,310 Nanometer,"A3"}
				}
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test[
			"Plots many sets of data on the same graph:",
			PlotCircularDichroism[{Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],Object[Data, CircularDichroism, "id:Vrbp1jKYdBbz"]}, Overlay->True],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test[
			"Accepts EmeraldListLinePlot options:",
			PlotCircularDichroism[dynamicSample,PlotStyle->ColorFade[{Red,Blue},Length[dynamicSample]],FillingStyle->Core`Private`fillingFade[{Red,Blue},Length[dynamicSample]], Overlay->True],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test[
			"Plots the circular dichroism spectroscopy data as a dashed line without filling when the spectra is outside of the dynamic range:",
			PlotCircularDichroism[dynamicSample[[1]]],
			ValidGraphicsP[],
			TimeConstraint->120
		],

		(* Output tests *)
		Test[
			"Setting Output to Result returns the plot:",
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Output->Result],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Preview returns the plot:",
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Output->Preview],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Options returns the resolved options:",
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotCircularDichroism]],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Tests returns a list of tests:",
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Output->Tests],
			{(_EmeraldTest|_Example)...},
			TimeConstraint->120
		],
		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for data object input:",
			PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,ValidGraphicsP[]]&&MatchQ[Last@output,OptionsPattern[PlotCircularDichroism]]
		],
		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for raw spectrum input:",
			PlotCircularDichroism[Download[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],CircularDichroismAbsorbanceSpectrum],Output->{Result,Options}],
			output_List/;MatchQ[output,{ValidGraphicsP[], OptionsPattern[PlotCircularDichroism]}],
			TimeConstraint->120
		],
		Test[
			"Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotCircularDichroism[Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Output->Options],
			Sort@Keys@SafeOptions@PlotCircularDichroism,
			TimeConstraint->120
		],
		Example[{Messages, "NoCircularDichroismDataToPlot" ,"Throws an error when the protocol does not contain any associated circular dichroism data:"},
			PlotCircularDichroism[Object[Protocol, CircularDichroism, "Protocol without data for PlotCircularDichroism tests " <> $SessionUUID]],
			$Failed,
			Messages :> Error::NoCircularDichroismDataToPlot
		],
		Example[{Messages, "CircularDichroismProtocolDataNotPlotted", "Throws an error when the data does not contain required fields:"},
			PlotCircularDichroism[Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 1 for PlotCircularDichroism tests " <> $SessionUUID]],
			$Failed,
			Messages :> Error::CircularDichroismProtocolDataNotPlotted
		],
		Example[{Messages, "CircularDichroismProtocolDataNotPlotted", "Throws an error when the one of the input data does not contain required fields:"},
			PlotCircularDichroism[
				{
					Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 1 for PlotCircularDichroism tests " <> $SessionUUID],
					Object[Data, CircularDichroism, "id:eGakldJqOnaB"]
				}
			],
			$Failed,
			Messages :> Error::CircularDichroismProtocolDataNotPlotted
		],
		Example[{Messages, "CircularDichroismProtocolDataNotPlotted", "Throws an error when all the data do not contain required fields:"},
			PlotCircularDichroism[
				{
					Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 1 for PlotCircularDichroism tests " <> $SessionUUID],
					Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 2 for PlotCircularDichroism tests " <> $SessionUUID]
				}
			],
			$Failed,
			Messages :> Error::CircularDichroismProtocolDataNotPlotted
		],
		Example[{Messages, "CircularDichroismProtocolDataNotPlotted", "Throws an error when some of the data does not contain required fields:"},
			PlotCircularDichroism[
				{
					Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 1 for PlotCircularDichroism tests " <> $SessionUUID],
					Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 2 for PlotCircularDichroism tests " <> $SessionUUID],
					Object[Data, CircularDichroism, "id:eGakldJqOnaB"]
				}
			],
			$Failed,
			Messages :> Error::CircularDichroismProtocolDataNotPlotted
		]
	},
	Variables:>{dynamicSample},
	SetUp:>(
		dynamicSample={Object[Data, CircularDichroism, "id:eGakldJqOnaB"],Object[Data, CircularDichroism, "id:pZx9jo8k3RxM"],Object[Data, CircularDichroism, "id:Vrbp1jKYdBbz"]};
	),
	SymbolSetUp :> Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
		Module[
			{
				objects, existsFilter
			},
			$CreatedObjects = {};

			(* Erase any objects that we failed to erase in the last unit test. *)
			objects = {
				(* Protocols *)
				Object[Protocol, CircularDichroism, "Protocol without data for PlotCircularDichroism tests " <> $SessionUUID],
				(* Data Objects *)
				Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 1 for PlotCircularDichroism tests " <> $SessionUUID],
				Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 2 for PlotCircularDichroism tests " <> $SessionUUID]
			};

			existsFilter = DatabaseMemberQ[objects];

			EraseObject[
				PickList[objects, existsFilter],
				Force -> True,
				Verbose -> False
			];

			(* Upload temporary test protocols and data objects. *)
			Upload[{
				<|
					Type -> Object[Protocol, CircularDichroism],
					Name -> "Protocol without data for PlotCircularDichroism tests " <> $SessionUUID,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Data, CircularDichroism],
					Name -> "Incomplete CircularDichroism Data 1 for PlotCircularDichroism tests " <> $SessionUUID
				|>,
				<|
					Type -> Object[Data, CircularDichroism],
					Name -> "Incomplete CircularDichroism Data 2 for PlotCircularDichroism tests " <> $SessionUUID
				|>
			}];

		]
	],

	SymbolTearDown :> (
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects = Cases[{
				(* Protocols *)
				Object[Protocol, CircularDichroism, "Protocol without data for PlotCircularDichroism tests " <> $SessionUUID],
				(* Data Objects *)
				Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 1 for PlotCircularDichroism tests " <> $SessionUUID],
				Object[Data, CircularDichroism, "Incomplete CircularDichroism Data 2 for PlotCircularDichroism tests " <> $SessionUUID]
			},
				ObjectP[]
			];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter = DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force -> True,
				Verbose -> False
			]];
		]
	),

	Stubs:> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];
