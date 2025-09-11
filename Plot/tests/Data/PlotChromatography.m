(* ::Package:: *)

(* ::Section:: *)
(*Tests*)


(* ::Subsection:: *)
(*PlotChromatography*)


DefineTests[PlotChromatography,
	{
		Example[
			{Basic,"Generate an interactive plot of the data in the chromatography object:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"]],
			_?ValidGraphicsQ
		],
		(*
		Example[
			{Basic,"Generate an interactive plot of the data in the chromatography mass spectrometery object:"},
			PlotChromatography[Object[Data, ChromatographyMassSpectra, "Test ChromatographyMS data object 1 for PlotChromatography tests"]],
			_?ValidGraphicsQ
		],
		*)
		Example[
			{Basic,"Overlay several chromatograms in an interactive plot:"},
			PlotChromatography[{Object[Data, Chromatography, "id:M8n3rx0l7738"],
				Object[Data, Chromatography, "id:WNa4ZjKvdd47"],
				Object[Data, Chromatography, "id:54n6evLE776B"],
				Object[Data, Chromatography, "id:n0k9mG8AJJ9p"],
				Object[Data, Chromatography, "id:01G6nvw7WW64"],
				Object[Data, Chromatography, "id:1ZA60vLrWW66"]}],
			_?ValidGraphicsQ
		],
		Example[{Basic,"Plots absorbance data during an LCMS run:"},
			PlotChromatography[
				Object[Data, ChromatographyMassSpectra, "id:AEqRl9KRdmPw"],
				PrimaryData -> Absorbance3D, PlotType -> ListLinePlot
			],
			_?ValidGraphicsQ
		],
		Test[
			"Given a packet:",
			PlotChromatography[Download[Object[Data, Chromatography, "id:eGakld01dzk4"]]],
			_?ValidGraphicsQ
		],
		Test["Plots the chromatography data object in a link:",
			PlotChromatography[Link[Object[Data, Chromatography, "id:eGakld01dzk4"],Protocol]],
			_?ValidGraphicsQ
		],
		Test["Plots the chromatography data objects linked to a protocol object:",
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"][Protocol]],
			SlideView[{ValidGraphicsP[] ..}]
		],

		Test[
			"Plot two data objects with two items in SecondaryData:",
			PlotChromatography[{Object[Data, Chromatography, "id:M8n3rx0l7738"], Object[Data, Chromatography, "id:WNa4ZjKvdd47"]}, SecondaryData -> {GradientA, GradientB}],
			_?ValidGraphicsQ
		],

		(*Options *)

		Example[
			{Options,Display,"Display standard analysis associated with the data:"},
			PlotChromatography[Object[Data, Chromatography, "id:pZx9jo8A400j"], Display -> {Ladder}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,SecondaryData,"Specify additional fields to show on the second-y axis:"},
			PlotChromatography[Object[Data, Chromatography, "id:rea9jl1ol575"],SecondaryData->{GradientB,GradientC,Pressure}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,SecondaryData,"The first additional field determines the second-y axis label:"},
			PlotChromatography[Object[Data, Chromatography, "id:rea9jl1ol575"],SecondaryData->{Pressure,GradientB}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,SecondaryData,"Choose a singleton secondary data field:"},
			PlotChromatography[Object[Data, Chromatography, "id:zGj91a77x81v"], SecondaryData -> GradientD],
			_?ValidGraphicsQ
		],
		Example[
			{Options,SecondaryData,"Null secondary data will not be shown:"},
			PlotChromatography[Object[Data, Chromatography, "id:zGj91a77x81v"], SecondaryData -> {GradientD}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,FractionHighlights,"Highlight and name specific fractions:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"],Display->{Fractions},FractionHighlights->{{Quantity[18.21816667`, "Minutes"], Quantity[18.93833333`, "Minutes"], "2F3"}, {Quantity[18.93833333`,"Minutes"], Quantity[19.65833333`, "Minutes"], "2F4"}},FractionHighlightColor-> Blue],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Map,"Create a separate plot for each chromatograph:"},
			PlotChromatography[{Object[Data, Chromatography, "id:M8n3rx0Db9nG"], Object[Data, Chromatography, "id:qdkmxzqew7ka"]}, Map -> True],
			{_?ValidGraphicsQ..}
		],
		Example[
			{Options,Legend,"Add a legend to the plot:"},
			PlotChromatography[{Object[Data, Chromatography, "id:9RdZXv1W61bL"], Object[Data, Chromatography, "id:mnk9jORxoRAw"], Object[Data, Chromatography, "id:BYDOjvGNPGm8"]},Legend->{"Sample ATK2","Sample ATK3","Sample ATK4"}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Units,"Specify the units of the data being plotted:"},
			PlotChromatography[Object[Data, Chromatography, "id:01G6nvw7WW64"], Units -> {Chromatogram -> {Minute, AbsorbanceUnit}, Pressure -> {Minute, PSI}}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,PlotRange,"Adjust plot range:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"],PlotRange->{{0,25Minute},{0,1300Milli AbsorbanceUnit}},TargetUnits->{Hour,AbsorbanceUnit}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,PlotType,"Plot 3D chromatography data as a contour plot:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakldJ8EEz1"], PlotType -> ContourPlot],
			_?ValidGraphicsQ,
			TimeConstraint->500
		],
		Example[
			{Options,PlotType,"Plot 3D chromatography data as a density plot:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakldJ8EEz1"], PlotType -> DensityPlot],
			_?ValidGraphicsQ,
			TimeConstraint->500
		],
		Example[
			{Options,PlotType,"Plot 3D chromatography data as a 3D plot:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakldJ8EEz1"], PlotType -> ListPlot3D],
			_?ValidGraphicsQ,
			TimeConstraint->500
		],
		Example[
			{Options,Wavelength,"Plot the data gathered at a specified wavelength:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakldJ8EEz1"], Wavelength -> 220 Nanometer],
			_?ValidGraphicsQ,
			TimeConstraint -> 500
		],
		Example[
			{Options,SamplingRate,"Plot every 100th data point:"},
			PlotChromatography[Object[Data, Chromatography, "id:lYq9jRxnNNLr"], PlotType -> ContourPlot, SamplingRate -> 100],
			_?ValidGraphicsQ
		],
		Example[{Options,PrimaryData,"Specify what to plot as the primary data:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"],PrimaryData->Pressure],
			ValidGraphicsP[]
		],
		Example[{Options,LinkedObjects,"Specify Field to be plotted along side Primary Data:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"], LinkedObjects->{StandardData}],
			ValidGraphicsP[]
		],
		Example[{Options,Zoomable,"Produce a plot which can be zoomed in on:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"], Zoomable->True],
			ValidGraphicsP[]
		],
		Example[{Options,Zoomable,"Produce a plot which cannot be zoomed in on:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"], Zoomable->False],
			ValidGraphicsP[]
		],
		Example[{Options,Mass,"Indicate the mass (ion) by m//z for which the data should be plotted:"},
			PlotChromatography[Object[Data, ChromatographyMassSpectra, "id:R8e1PjpK8aNn"], Mass->500*Nanometer],
			ValidGraphicsP[]
		],
		Example[{Options,PlotLabel,"Add a label to the plot:"},
			PlotChromatography[Object[Data, Chromatography, "id:M8n3rx0l7738"], PlotLabel->"Test Title"],
			ValidGraphicsP[]
		],
		Example[{Options,PlotLabel,"Automatic will default to the object ID:"},
			PlotChromatography[Object[Data, Chromatography, "id:M8n3rx0l7738"], PlotLabel -> Automatic],
			ValidGraphicsP[]
		],
		Example[{Options,PlotLabel,"Provide labels for each Plot:"},
			PlotChromatography[{Object[Data, Chromatography, "id:wqW9BP4YP0r9"], Object[Data, Chromatography, "id:eGakld01dzk4"]}, PlotLabel -> {"Test 1", "Test 2"}],
			ValidGraphicsP[]
		],
		Example[{Options,Peaks,"By default any labels included in the peaks specification will be plotted:"},
			PlotChromatography[Object[Data, Chromatography, "id:J8AY5jwz4rMb"]],
			ValidGraphicsP[]
		],
		Example[{Options,PeakLabels,"Add a label to each peak:"},
			PlotChromatography[Object[Data, Chromatography, "id:M8n3rx0l7738"], PeakLabels -> {"LMW", "HMW"}],
			ValidGraphicsP[]
		],
		Example[{Options,PeakLabels,"Provide labels for each set of peaks:"},
			PlotChromatography[{Object[Data, Chromatography, "id:wqW9BP4YP0r9"], Object[Data, Chromatography, "id:eGakld01dzk4"]}, PeakLabels -> {{"Control"}, {"Treatment"}}],
			ValidGraphicsP[]
		],
		Example[{Options,PeakLabelStyle,"Set the appearance of the peak label text:"},
			PlotChromatography[Object[Data, Chromatography, "id:M8n3rx0l7738"], PeakLabels -> {"LMW", "HMW"}, PeakLabelStyle -> {14, Black, FontFamily -> "Arial"}],
			ValidGraphicsP[]
		],
		Example[{Options,TargetUnits,"Adjust the units of the primary data and the peaks associated with it:"},
			PlotChromatography[Object[Data, Chromatography, "id:Y0lXejM6vKzl"], TargetUnits -> {Second, AbsorbanceUnit}],
			ValidGraphicsP[]
		],
		Example[{Options,Fractions,"Display fractions on the plot along with data:"},
			PlotChromatography[Object[Data, Chromatography, "id:M8n3rx0l7738"],
				Fractions -> {{27*Second, 28*Second, "A1"}, {28*Second, 29*Second,
					"A2"}, {29*Second, 1/2*Minute, "A3"}, {30*Second, 31*Second,
					"A4"}, {31*Second, 32*Second, "A5"}, {32*Second, 33*Second,
					"A6"}}],
			ValidGraphicsP[]
		],
		Example[{Options,TransformX,"Transform the units of the x-axis to be Volume instead of Time:"},
			PlotChromatography[Object[Data, Chromatography, "id:M8n3rx0l7738"],TransformX->Volume],
			ValidGraphicsP[]
		],
		Example[{Messages,"AllWavelengths","Cannot specify a specific wavelength when plotting 3D Data:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakldJ8EEz1"],PlotType->ListPlot3D,Wavelength->500 Nanometer],
			ValidGraphicsP[],
			Messages:>{Warning::AllWavelengths}
		],
		Example[{Messages,"WavelengthUnavailable","No data is available at the requested wavelength:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakldJ8EEz1"],Wavelength->600 Nanometer],
			ValidGraphicsP[],
			Messages:>{Warning::WavelengthUnavailable,Error::InvalidOption}
		],
		Example[{Messages,"DimensionMismatch","Cannot 3D plot 2D data:"},
			PlotChromatography[Object[Data, Chromatography, "id:M8n3rx0l7738"],PlotType->ListPlot3D],
			ValidGraphicsP[],
			Messages:>{Error::DimensionMismatch,Error::InvalidOption}
		],
		Example[{Messages,"CannotTransform3DData","Cannot Transform 3D Data. Will throw a warning and then plot the data without the transform:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakldJ8EEz1"], PlotType -> ListPlot3D,TransformX->Volume],
			ValidGraphicsP[],
			Messages:>{Warning::CannotTransform3DData}
		],
		Example[{Messages,"CannotTransformMassSpecData","Cannot Transform Mass Spec Data. Will throw a warning and then plot the data without the transform:"},
			PlotChromatography[Object[Data, ChromatographyMassSpectra, "id:R8e1PjpK8aNn"],TransformX->Volume],
			ValidGraphicsP[],
			Messages:>{Warning::CannotTransformMassSpecData}
		],
		Example[{Messages,"InvalidTargetUnits","If specified TargetUnits do not match transformation specification. Will throw a warning and then plot the data without the transform:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakldJ8EEz1"],TransformX->Volume,TargetUnits->{Minute,MilliAbsorbanceUnit}],
			ValidGraphicsP[],
			Messages:>{Warning::InvalidTargetUnits}
		],
		Example[{Messages,"UndefinedFlowRate","If the flow rate of the chromatography object is not defined. Will throw a warning and then plot the data without the transform:"},
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"],TransformX -> Volume],
			ValidGraphicsP[],
			Messages:>{Warning::UndefinedFlowRate}
		],
		Example[{Options,SecondaryData,"Will adjust gradient curves to start at correct time:"},
			PlotChromatography[Object[Data, Chromatography, "id:mnk9jORa1W7b"],SecondaryData -> {GradientC, GradientD}],
			ValidGraphicsP[]
		],
		Test[
			"Does not move the gradient if GradientStartTime is Null:",
			PlotChromatography[Object[Data, Chromatography, "id:GmzlKjPKWeD4"],SecondaryData -> {GradientC}],
			ValidGraphicsP[]
		],
		Test[
			"Prevents the labels from overlapping by increasing their heights:",
			PlotChromatography[Object[Data, Chromatography, "id:AEqRl9KNJ0Ol"]],
			ValidGraphicsP[]
		],
		Test[
			"Returns a list of plots when data is input in a list of lists:",
			PlotChromatography[{{Object[Data, Chromatography, "id:eGakld01dzk4"]}}],
			{_?ValidGraphicsQ..}
		],
		Test[
			"Accepts a Chromatography data packet:",
			PlotChromatography[Download[Object[Data, Chromatography, "id:eGakld01dzk4"]]],
			_?ValidGraphicsQ
		],
		Test[
			"Accepts a list of Chromatography data packets:",
			PlotChromatography[Download[{Object[Data, Chromatography, "id:wqW9BP4YP0r9"],Object[Data, Chromatography, "id:eGakld01dzk4"]}]],
			_?ValidGraphicsQ
		],
		Test[
			"Fills in partially specified plot ranges:",
			PlotChromatography[{Object[Data, Chromatography, "id:wqW9BP4YP0r9"],Object[Data, Chromatography, "id:eGakld01dzk4"]},PlotRange->{{0,25 Minute},Full}],
			_?ValidGraphicsQ
		],
		Test[
			"The function is listable, creating a separate plot for each nested list of data:",
			PlotChromatography[{{Object[Data, Chromatography, "id:wqW9BP4YP0r9"]},{Object[Data, Chromatography, "id:eGakld01dzk4"]}},PlotRange->{{0,25 Minute},Full}],
			{_?ValidGraphicsQ..}
		],
		Test[
			"Overlays multiple chromatograph data sets:",
			PlotChromatography[{Object[Data, Chromatography, "id:eGakld01dzk4"],Object[Data, Chromatography, "id:wqW9BP4YP0r9"]}],
			_?ValidGraphicsQ
		],
		Test[
			"Display GradientB,GradientC and SecondaryChromatogram:",
			PlotChromatography[Object[Data, Chromatography, "id:aXRlGn6ol5W0"],PrimaryData->{Absorbance, SecondaryAbsorbance},SecondaryData->{GradientB,GradientC}],
			_?ValidGraphicsQ
		],
		Test[
			"When displaying fractions, any picked fractions are highlighted in a different color:",
			PlotChromatography[Object[Data, Chromatography, "id:aXRlGn6ol5W0"],Display->{Fractions}],
			_?ValidGraphicsQ
		],
		Test[
			"Specify the plot legend:",
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"],Legend->{"Data 29854"}],
			_?ValidGraphicsQ
		],
		Test[
			"Specify the plot legend:",
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"],Legend->{"Fish"}],
			_?ValidGraphicsQ
		],
		Test[
			"Accepts raw data:",
			PlotChromatography[Object[Data, Chromatography, "id:eGakld01dzk4"][Absorbance]],
			_?ValidGraphicsQ
		],
		Test["Display option works without list:",
			PlotChromatography[Object[Data, Chromatography, "id:aXRlGn6ol5W0"],Display->Fractions],
			ValidGraphicsP[]
		]
	},
	SymbolSetUp:>(
		(*delete the old objects in case they're still in the database*)
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					(*created test data objects*)
					Object[Data,ChromatographyMassSpectra,"Test ChromatographyMS data object 1 for PlotChromatography tests"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		(*make our objects*)
		Module[{dataPacket1},
			(*articulate the packet*)
			dataPacket1=<|
				Type->Object[Data,ChromatographyMassSpectra],
				Name->"Test ChromatographyMS data object 1 for PlotChromatography tests",
				MinMass->150 Dalton,
				MaxMass->650 Dalton,
				MinAbsorbanceWavelength->210 Nanometer,
				MaxAbsorbanceWavelength->400 Nanometer,
				IonAbundanceMass->419 Dalton,
				DeveloperObject->True
				(*TODO: finish the rest of this when tommy makes the changes*)
			|>;

			Upload[dataPacket1]

		];
	)
];
