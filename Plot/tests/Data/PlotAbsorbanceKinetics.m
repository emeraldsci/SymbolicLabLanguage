(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAbsorbanceKinetics*)


DefineTests[PlotAbsorbanceKinetics,
	{
		Example[
			{Basic,"Plots the absorbance trajectory in an AbsorbanceKinetics data object:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Given a packet:",
			PlotAbsorbanceKinetics[Download[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"]]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots absorbance kinetics data when given an AbsorbanceKinetics data link:"},
			PlotAbsorbanceKinetics[Link[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Protocol]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots absorbance kinetics data when given a list of XY coordinates representing the spectra:"},
			PlotAbsorbanceKinetics[Download[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],AbsorbanceTrajectories]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots multiple sets of data on the same graph:"},
			PlotAbsorbanceKinetics[{Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 2"]}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Example[
			{Options,TargetUnits,"Plot the x-axis in terms of minutes instead of seconds:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],TargetUnits->{Minute,AbsorbanceUnit}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Temperature,"Specify a temperature trace for the spectra other than the one shown in the packet:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Temperature->QuantityArray[{{220,20},{350,25}},{Second, Celsius}]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Map,"Generate a separate plot for each data object given:"},
			PlotAbsorbanceKinetics[{Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 2"]},Map->True],
			{_?ValidGraphicsQ,_?ValidGraphicsQ},
			TimeConstraint->120
		],
		Example[
			{Options,Legend,"Provide a custom legend for the data:"},
			PlotAbsorbanceKinetics[{Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 2"]},Legend->{"1","2"}],
			_?Core`Private`ValidLegendedQ,
			TimeConstraint->120
		],
		Example[
			{Options,Units,"Specify relevant units:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Units->{AbsorbanceTrajectories->{Meter Nano,AbsorbanceUnit},Temperature->{Second,Celsius}}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,PrimaryData,"Indicate that the raw absorbance spectrum prior to blanking should be plotted on the y-axis:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],PrimaryData->UnblankedAbsorbanceTrajectories],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"Indicate that the raw absorbance spectrum prior to blanking should be plotted on the second y-axis:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],SecondaryData->{UnblankedAbsorbanceTrajectories}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Display,"There are currently no peaks to display:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Display->{}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],PlotTheme -> "Marketing"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Zoomable,"To improve performance indicate that the plot should not allow interactive zooming:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Zoomable->False],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,PlotLabel,"Provide a title for the plot:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],PlotLabel->"Absorbance Kinetics"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,FrameLabel,"Specify custom x and y-axis labels:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],FrameLabel -> {"Wavelength", "Recorded Absorbance", None, None}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,OptionFunctions,"Turn off any special formatting by clearing the option functions:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],OptionFunctions -> {}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,AbsorbanceTrajectories,"Provide a new value for the AbsorbanceTrajectories instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],AbsorbanceTrajectories->{QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Second,AbsorbanceUnit}],QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Second,AbsorbanceUnit}]}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,UnblankedAbsorbanceTrajectories,"Provide a new value for the UnblankedAbsorbanceTrajectories instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],PrimaryData->UnblankedAbsorbanceTrajectories,
				UnblankedAbsorbanceTrajectories->{QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Second,AbsorbanceUnit}],QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Second,AbsorbanceUnit}]}
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Example[
			{Options,AbsorbanceTrajectory3D,"Provide a new value for the AbsorbanceTrajectories3D instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "3D Absorbance Data For Plotting"],AbsorbanceTrajectory3D->QuantityArray[{#,#*200,#^2} &/@Range[10],{Second,Nanometer,AbsorbanceUnit}], PlotType -> ListPlot3D],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,UnblankedAbsorbanceTrajectory3D,"Provide a new value for the UnblankedAbsorbanceTrajectories instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "3D Absorbance Data For Plotting"],PrimaryData->UnblankedAbsorbanceTrajectory3D,
				UnblankedAbsorbanceTrajectory3D->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Second,AbsorbanceUnit}],PlotType -> ListPlot3D
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotAbsorbanceKinetics[
				{Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 2"]},
				LegendPlacement -> Right
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotAbsorbanceKinetics[
				{Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 2"]},
				Boxes -> True
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,IncludeReplicates,"Indicate that replicate data should be averaged together and shown with error bars:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],IncludeReplicates->True],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Wavelength,"Plot the data gathered at a specified wavelength:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"], Wavelength -> 590 Nanometer],
			_?ValidGraphicsQ,
			TimeConstraint -> 500
		],
		Example[
			{Options,PlotType,"Plot 3D data as a ListPlot3D:"},
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "3D Absorbance Data For Plotting"], PlotType -> ListPlot3D],
			_?ValidGraphicsQ,
			TimeConstraint -> 500
		],
		Test[
			"Plots only data recorded at the given wavelength:",
			PlotAbsorbanceKinetics[Object[Data, AbsorbanceKinetics, "3D Absorbance Data For Plotting"], Wavelength -> 400 Nanometer,PlotType -> ListLinePlot],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Accepts EmeraldListLinePlot options:",
			PlotAbsorbanceKinetics[{Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 1"],Object[Data, AbsorbanceKinetics, "Absorbance Data For Plotting 2"]},PlotStyle->ColorFade[{Red,Blue},2],FillingStyle->Core`Private`fillingFade[{Red,Blue},2]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		]
	},
	SymbolSetUp:>(

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allObjects,existingObjects
			},

			(* All data objects generated for unit tests *)

			allObjects=
				{
					Object[Data,AbsorbanceKinetics,"3D Absorbance Data For Plotting"],
					Object[Data,AbsorbanceKinetics,"Absorbance Data For Plotting 1"],
					Object[Data,AbsorbanceKinetics,"Absorbance Data For Plotting 2"]
				};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		{d1,d2,d3}=CreateID[{Object[Data,AbsorbanceKinetics],Object[Data,AbsorbanceKinetics],Object[Data,AbsorbanceKinetics]}];
		Upload[
			{
				<|
					Name -> "3D Absorbance Data For Plotting",
					Object->d1,
					Type->Object[Data,AbsorbanceKinetics],
					MinWavelength->300 Nanometer,
					MaxWavelength->500 Nanometer,
					AbsorbanceTrajectory3D->QuantityArray[{#,#*100,#^2} &/@Range[10],{Second,Nanometer,AbsorbanceUnit}],
					UnblankedAbsorbanceTrajectory3D->QuantityArray[{#,#,(#+.01)^2} &/@Range[10],{Second,Nanometer,AbsorbanceUnit}]
				|>,
				<|
					Name -> "Absorbance Data For Plotting 1",
					Object->d2,
					Type->Object[Data,AbsorbanceKinetics],
					Replace[Wavelengths]->{340 Nanometer,590 Nanometer},
					Replace[AbsorbanceTrajectories]->{
						QuantityArray[{#,0.5/(1+Exp[-.7*#])} &/@Range[10],{Second,AbsorbanceUnit}],
						QuantityArray[{#,1/(1+Exp[-.7*#])} &/@Range[10],{Second,AbsorbanceUnit}]
					},
					Replace[UnblankedAbsorbanceTrajectories]->{
						QuantityArray[{#,0.6/(1+Exp[-.8*#])} &/@Range[10],{Second,AbsorbanceUnit}],
						QuantityArray[{#,1.1/(1+Exp[-.8*#])} &/@Range[10],{Second,AbsorbanceUnit}]
					},
					Replace[Replicates]->{Link[d3,Replicates]}
				|>,
				<|
					Name -> "Absorbance Data For Plotting 2",
					Object->d3,
					Type->Object[Data,AbsorbanceKinetics],
					Replace[Wavelengths]->{340 Nanometer,590 Nanometer},
					Replace[AbsorbanceTrajectories]->{
						QuantityArray[{#,0.5/(1+Exp[-.8*#])} &/@Range[10],{Second,AbsorbanceUnit}],
						QuantityArray[{#,1/(1+Exp[-.8*#])} &/@Range[10],{Second,AbsorbanceUnit}]
					},
					Replace[UnblankedAbsorbanceTrajectories]->{
						QuantityArray[{#,0.6/(1+Exp[-.8*#])} &/@Range[10],{Second,AbsorbanceUnit}],
						QuantityArray[{#,1.1/(1+Exp[-.8*#])} &/@Range[10],{Second,AbsorbanceUnit}]
					},
					Replace[Replicates]->{Link[d2,Replicates]}
				|>
			}
		]
	),
	SymbolTearDown:>Module[{objects},
		objects = {
			Object[Data,AbsorbanceKinetics,"3D Absorbance Data For Plotting"],
			Object[Data,AbsorbanceKinetics,"Absorbance Data For Plotting 1"],
			Object[Data,AbsorbanceKinetics,"Absorbance Data For Plotting 2"]
		};

		EraseObject[
			PickList[objects,DatabaseMemberQ[objects],True],
			Verbose->False,
			Force->True
		]
	]
];
