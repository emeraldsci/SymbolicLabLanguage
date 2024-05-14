(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotIRSpectroscopy*)


DefineTests[PlotIRSpectroscopy,
	{
		Example[
			{Basic,"Plot multiple infrared spectra on the same graph:"},
			PlotIRSpectroscopy[{Object[Data,IRSpectroscopy,"id:O81aEBZbVoLj"],Object[Data,IRSpectroscopy,"id:GmzlKjPb71rN"]}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots infrared spectroscopy data when given an IRSpectroscopy data link:"},
			PlotIRSpectroscopy[Link[Object[Data,IRSpectroscopy,"id:aXRlGn6GGo0k"],Protocol]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots infrared spectroscopy data when given an IRSpectroscopy data object:"},
			PlotIRSpectroscopy[Object[Data,IRSpectroscopy,"id:aXRlGn6GGo0k"]],
			ValidGraphicsP[]
		],
		Example[
			{Options,PrimaryData,"Indicate that the absorbance spectrum should be plotted on the y-axis:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"], PrimaryData -> AbsorbanceSpectrum],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"Indicate that absorbance spectrum should be plotted on the second y-axis:"},
			PlotIRSpectroscopy[Object[Data,IRSpectroscopy,"id:aXRlGn6GGo0k"], SecondaryData -> {AbsorbanceSpectrum}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Display,"There is no additional display data:"},
			PlotIRSpectroscopy[Object[Data,IRSpectroscopy,"id:aXRlGn6GGo0k"],Display->{}],
			ValidGraphicsP[]
		],
		Example[{Options,IncludeReplicates,"Indicate that replicate data should be averaged together and shown with error bars:"},
			PlotIRSpectroscopy[Object[Data,IRSpectroscopy,"id:aXRlGn6GGo0k"],IncludeReplicates->True],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,TargetUnits,"Specify units for the XY axes:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"], TargetUnits -> {1/Millimeter, Automatic}],
			ValidGraphicsP[]
		],
		Example[
			{Options,Zoomable,"Disallow interactive zooming by setting Zoomable->False:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],Zoomable->False],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],LegendPlacement->Right],
			ValidGraphicsP[]
		],
		Example[{Options, PlotLabel, "Provide a title for the plot:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],PlotLabel -> "Infrared Transmittance Spectrum"],
			ValidGraphicsP[]
		],
		Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],FrameLabel -> {"Wavenumber", "Transmittance Amount", None, None}],
			ValidGraphicsP[]
		],
		Example[
			{Options,Legend,"Display a legend with the plot:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],Legend->{"My Data"}],
			_?Core`Private`ValidLegendedQ
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotIRSpectroscopy[
				Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],
				Boxes -> True
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,Peaks,"By default any labels included in the peaks specification will be plotted:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"]],
			ValidGraphicsP[]
		],
		Example[{Options,OptionFunctions,"There are currently no OptionFunctions for this plot function:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],OptionFunctions->{}],
			ValidGraphicsP[]
		],
		Example[{Options,Filling,"Control the shading on the figure:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],Filling->Top],
			ValidGraphicsP[]
		],
		Example[{Options,Reflected,"Change the axis orientation:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],Reflected->False],
			ValidGraphicsP[]
		],
		Example[{Options,Frame,"Change the border around the figure:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"],Frame -> {True, True, True, True}],
			ValidGraphicsP[]
		],
		Example[{Options,AbsorbanceSpectrum,"Define an absorbance spectrum to include:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:pZx9jo8DazZ4"],
				AbsorbanceSpectrum -> Take[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"][ AbsorbanceSpectrum], 100]
			],
			ValidGraphicsP[]
		],
		Example[{Options,SingleBeamSpectrum,"Define an SingleBeamSpectrum to include:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:pZx9jo8DazZ4"],
				SingleBeamSpectrum -> Take[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"][ SingleBeamSpectrum], 100]
			],
			ValidGraphicsP[]
		],
		Example[{Options,TransmittanceSpectrum,"Define an TransmittanceSpectrum to include:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:pZx9jo8DazZ4"],
				TransmittanceSpectrum -> Take[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"][ TransmittanceSpectrum], 100]
			],
			ValidGraphicsP[]
		],
		Example[{Options,UnblankedSpectrum,"Define an UnblankedSpectrum to include:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:pZx9jo8DazZ4"],
				UnblankedSpectrum -> Take[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"][ TransmittanceSpectrum], 100]
			],
			ValidGraphicsP[]
		],
		Example[{Options,Interferogram,"Define an inteferogram to include:"},
			PlotIRSpectroscopy[Object[Data, IRSpectroscopy, "id:pZx9jo8DazZ4"],
				PrimaryData -> Interferogram,
				Interferogram -> Take[Object[Data, IRSpectroscopy, "id:aXRlGn6GGo0k"][Interferogram], 100]
			],
			ValidGraphicsP[]
		]
	}
];
