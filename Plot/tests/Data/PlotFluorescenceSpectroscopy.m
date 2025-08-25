(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceSpectroscopy*)


DefineTests[PlotFluorescenceSpectroscopy,
	{
		Example[
			{Basic,"Plot the emission spectrum for a given data object:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot multiple data objects:"},
			PlotFluorescenceSpectroscopy[{Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"]}],
			_?ValidGraphicsQ
		],
		Example[
			{Basic,"Plot the emission spectrum for data objects linked to a given protocol object:"},
			PlotFluorescenceSpectroscopy[Object[Protocol, FluorescenceSpectroscopy, "FluorescenceSpectroscopy Test Protocol 2"]],
			SlideView[{ValidGraphicsP[] ..}]
		],
		Example[
			{Options,PrimaryData,"Overlay the emission and excitation spectra:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],PrimaryData->{ExcitationSpectrum,EmissionSpectrum}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"There is no secondary data to display:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],SecondaryData->{}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Display,"Use the display option to turn peak plotting off and on:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"],Display->{}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Peaks,"Indicate the peaks that should be overlaid on the plot:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"],Peaks->Object[Analysis,Peaks,"FluorescenceSpectroscopy Test Peaks"]],
			_?ValidGraphicsQ
		],
		Example[{Options,Units,"Specify the units to use when plotting the spectrum:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"],Units->{EmissionTrajectories->{Nanometer,Kilo*RFU}}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],PlotTheme -> "Marketing"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Zoomable,"Disallow interactive zooming by setting Zoomable->False:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],Zoomable->False],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,TargetUnits,"Specify units for the XY axes:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"],TargetUnits->{Nanometer,RFU}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotFluorescenceSpectroscopy[{Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"]},LegendPlacement->Right],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotLabel, "Provide a title for the plot:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],PlotLabel -> "Fluorescence Spectrum"],
			_?ValidGraphicsQ
		],
		Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],FrameLabel -> {"Wavelength", "Recorded Fluorescence", None, None}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotFluorescenceSpectroscopy[
				{Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"]},
				Boxes -> True
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Map,"Indicate that multiple plots should be created instead of overlaying data:"},
			PlotFluorescenceSpectroscopy[{Object[Data, FluorescenceSpectroscopy, "FluorescenceSpectroscopy Test Data 1"],Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"]},Map->True],
			{_?ValidGraphicsQ..}
		],
		Example[
			{Options,Legend,"Display a legend with the plot:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"],Legend->{"My Data"}],
			_?Core`Private`ValidLegendedQ
		],
		Example[{Options,IncludeReplicates,"Indicate that replicate data should be averaged together and shown with error bars:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"],IncludeReplicates->True],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,EmissionSpectrum,"Provide a new value for the emission spectrum instead of using the value recorded in the object being plotted:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"],EmissionSpectrum->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,RFU}]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,ExcitationSpectrum,"Provide a new value for the excitation spectrum instead of using the value recorded in the object being plotted:"},
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"],ExcitationSpectrum->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,RFU}]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Test["Given output option as Result, returns a plot:",
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],Output->Result],
			_?ValidGraphicsQ
		],
		Test["Given output option as Preview, returns a plot:",
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],Output->Preview],
			_?ValidGraphicsQ
		],
		Test["Given output option as Options, returns a list of resolved options:",
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],Output->Options],
			KeyValuePattern[{}]
		],
		Test["Given output option as Tests, returns {}:",
			PlotFluorescenceSpectroscopy[Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],Output->Tests],
			{}
		]
	},
	SymbolSetUp:>Module[{data1,data2, protocol1},
		Module[{allObjects,existingObjects},

			(* Gather all the objects created in SymbolSetup *)
			allObjects=Cases[Flatten[{
				Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 1"],
				Object[Data,FluorescenceSpectroscopy,"FluorescenceSpectroscopy Test Data 2"],
				Object[Analysis,Peaks,"FluorescenceSpectroscopy Test Peaks"],
				Object[Protocol, FluorescenceSpectroscopy, "FluorescenceSpectroscopy Test Protocol 2"]
			}],ObjectP[]];

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		$CreatedObjects={};

		{data1, data2, protocol1} = CreateID[{Object[Data,FluorescenceSpectroscopy], Object[Data,FluorescenceSpectroscopy], Object[Protocol,FluorescenceSpectroscopy]}];
		Upload[{
			<|
				Object->data1,
				Name->"FluorescenceSpectroscopy Test Data 1",
				EmissionSpectrum->QuantityArray[Table[{x+300,0.25 Exp[-.01 (x-50)^2]},{x,Range[0,100,0.2]}],{Nanometer,RFU}],
				ExcitationSpectrum->QuantityArray[Table[{x+300,0.23 Exp[-.01 (x-40)^2]},{x,Range[0,100,0.2]}],{Nanometer,RFU}],
				Well->"A1"
			|>,
			<|
				Object->data2,
				Name->"FluorescenceSpectroscopy Test Data 2",
				EmissionSpectrum->QuantityArray[Table[{x+300,0.26 Exp[-.012 (x-50)^2]},{x,Range[0,100,0.2]}],{Nanometer,RFU}],
				ExcitationSpectrum->QuantityArray[Table[{x+300,0.24 Exp[-.01 (x-40)^2]},{x,Range[0,100,0.2]}],{Nanometer,RFU}],
				Well->"A1",
				Replace[Replicates]->{Link[data1,Replicates]}
			|>
		}];
		AnalyzePeaks[data2,Name->"FluorescenceSpectroscopy Test Peaks"];
		Upload[<|
			Object->protocol1,
			Name->"FluorescenceSpectroscopy Test Protocol 2",
			Replace[Data] -> {Link[data1, Protocol], Link[data2, Protocol]}
		|>];
	],
	SymbolTearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	)
];
