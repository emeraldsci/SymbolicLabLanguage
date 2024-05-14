(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAbsorbanceSpectroscopy*)


DefineTests[PlotAbsorbanceSpectroscopy,
	{
		Example[
			{Basic,"Plots absorbance spectroscopy data when given an AbsorbanceSpectroscopy data object:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Given a packet:",
			PlotAbsorbanceSpectroscopy[Download[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"]]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots absorbance spectroscopy data when given an AbsorbanceSpectroscopy data link:"},
			PlotAbsorbanceSpectroscopy[Link[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Protocol]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots absorbance spectroscopy data when given a list of XY coordinates representing the spectra:"},
			PlotAbsorbanceSpectroscopy[Download[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],AbsorbanceSpectrum]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Basic,"Plots multiple sets of data on the same graph:"},
			PlotAbsorbanceSpectroscopy[{Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"],Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"]}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Example[
			{Options,TargetUnits,"Plot the x-axis in units of pm:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"],TargetUnits->{Meter Pico,AbsorbanceUnit}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Temperature,"Specify a temperature trace for the spectra other than the one shown in the packet:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Temperature->QuantityArray[{{220,20},{350,25}},{Nano Meter, Celsius}]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Peaks,"Highlight specified peaks on mouseover:"},
			Module[{spectraPeaks},
				spectraPeaks=<|Type->Object[Analysis,Peaks],BaselineFunction -> Function[x, -0.0157`],Position->{222.`,225.`,259.`,264.`,344.`,354.`,385.`,731.`,791.`,838.`,846.`,868.`,872.`,889.`,893.`,898.`,913.`,922.`,930.`,934.`,940.`,948.`,955.`,964.`,968.`,972.`,974.`,976.`,983.`,986.`,988.`,990.`,992.`},Height->{0.07850000000000001`,0.06620000000000001`,0.09000000000000002`,0.09019999999999997`,0.005099999999999997`,0.0035999999999999956`,0.004800000000000002`,0.0127`,0.013600000000000001`,0.018699999999999998`,0.0209`,0.022199999999999998`,0.022300000000000004`,0.024399999999999998`,0.024499999999999997`,0.024799999999999996`,0.031700000000000006`,0.036899999999999995`,0.04879999999999999`,0.0551`,0.0686`,0.0928`,0.1271`,0.15869999999999998`,0.1595`,0.1618`,0.16219999999999998`,0.1645`,0.16259999999999997`,0.15949999999999998`,0.15719999999999998`,0.15389999999999998`,0.15209999999999999`},HalfHeightWidth->{2.`,1.`,7.`,12.`,2.`,2.`,2.`,2.`,3.`,4.`,2.`,3.`,1.`,4.`,2.`,2.`,4.`,2.`,2.`,1.`,2.`,3.`,3.`,5.`,2.`,1.`,1.`,3.`,2.`,1.`,1.`,1.`,5.`},Area->{0.22450000000000003`,0.28365`,1.5875500000000002`,1.89755`,0.015449999999999995`,0.010249999999999981`,0.010849999999999995`,0.045399999999999996`,0.07079999999999999`,0.10254999999999999`,0.09575`,0.10239999999999999`,0.04175000000000001`,0.15984999999999996`,0.06945`,0.09319999999999998`,0.23650000000000002`,0.19554999999999997`,0.2181`,0.10665`,0.3702`,0.63235`,0.7875000000000001`,1.4856999999999998`,0.4755`,0.32115`,0.32184999999999997`,0.8150000000000001`,0.4798499999999999`,0.3152`,0.3112`,0.30429999999999996`,1.3268499999999999`},PeakRangeStart->{221.`,224.`,237.`,263.`,342.`,351.`,382.`,728.`,788.`,833.`,843.`,864.`,871.`,883.`,892.`,895.`,909.`,917.`,926.`,933.`,935.`,941.`,949.`,956.`,966.`,971.`,973.`,975.`,982.`,985.`,987.`,989.`,991.`},PeakRangeEnd->{224.`,229.`,260.`,309.`,348.`,357.`,386.`,732.`,794.`,839.`,848.`,869.`,873.`,890.`,895.`,899.`,917.`,923.`,931.`,935.`,941.`,949.`,956.`,966.`,969.`,973.`,975.`,980.`,985.`,987.`,989.`,991.`,1000.`},WidthRangeStart->{221.`,224.`,253.`,263.`,343.`,353.`,384.`,730.`,789.`,835.`,845.`,866.`,872.`,886.`,892.`,897.`,911.`,921.`,929.`,934.`,939.`,946.`,953.`,961.`,967.`,971.`,974.`,975.`,982.`,986.`,987.`,989.`,991.`},WidthRangeEnd->{223.`,225.`,260.`,275.`,345.`,355.`,386.`,732.`,792.`,839.`,847.`,869.`,873.`,890.`,894.`,899.`,915.`,923.`,931.`,935.`,941.`,949.`,956.`,966.`,969.`,972.`,975.`,978.`,984.`,987.`,988.`,990.`,996.`},BaselineIntercept->{-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`,-0.0157`},BaselineSlope->{0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`,0.`}, TangentWidthLines -> {}, TangentWidthLineRanges -> {}, TangentNumberOfPlates -> {}, TangentResolution -> {}, TailingFactor -> {}, RelativeArea -> {}, RelativePosition -> {}, PeakLabel -> {}, TangentWidth -> {}, HalfHeightResolution -> {}, HalfHeightNumberOfPlates -> {}|>;
				PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Peaks->spectraPeaks,Display->{Peaks}]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Map,"Generate a separate plot for each data object given:"},
			PlotAbsorbanceSpectroscopy[{Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"]},Map->True],
			{_?ValidGraphicsQ,_?ValidGraphicsQ},
			TimeConstraint->120
		],
		Example[
			{Options,Legend,"Provide a custom legend for the data:"},
			PlotAbsorbanceSpectroscopy[{Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"]},Legend->{"Data 219098","Data 219097"}],
			_?Core`Private`ValidLegendedQ,
			TimeConstraint->120
		],
		Example[
			{Options,Units,"Specify relevant units:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Units->{AbsorbanceSpectrum->{Meter Nano,AbsorbanceUnit},Temperature->{Meter Nano,Celsius}}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,PrimaryData,"Indicate that the raw absorbance spectrum prior to blanking should be plotted on the y-axis:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],PrimaryData->UnblankedAbsorbanceSpectrum],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"Indicate that the raw absorbance spectrum prior to blanking should be plotted on the second y-axis:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],SecondaryData->{UnblankedAbsorbanceSpectrum}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Display,"By default picked peaks are displayed on top of the plot. Hide peaks by clearing the display:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Display->{}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],PlotTheme -> "Marketing"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],				
		Example[
			{Options,Zoomable,"To improve performance indicate that the plot should not allow interactive zooming:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Zoomable->False],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,ImageSize,"Specify the dimensions of the plot:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],ImageSize->Medium],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,PlotLabel,"Provide a title for the plot:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],PlotLabel->"Absorbance Spectrum"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,FrameLabel,"Specify custom x and y-axis labels:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],FrameLabel -> {"Wavelength", "Recorded Absorbance", None, None}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,OptionFunctions,"Turn off formatting based on the absorbance value at a given wavelength by clearing the option functions:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],OptionFunctions -> {}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,AbsorbanceSpectrum,"Provide a new value for the AbsorbanceSpectrum instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"],AbsorbanceSpectrum->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,AbsorbanceUnit}]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,UnblankedAbsorbanceSpectrum,"Provide a new value for the UnblankedAbsorbanceSpectrum instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"],PrimaryData->{UnblankedAbsorbanceSpectrum,AbsorbanceSpectrum},UnblankedAbsorbanceSpectrum->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,AbsorbanceUnit}]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Transmittance,"Provide a new value for the Transmittance instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"],PrimaryData->{AbsorbanceSpectrum},SecondaryData->{Transmittance},Transmittance->QuantityArray[Table[{x,75},{x,200,1000}],{Nanometer,Percent}]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotAbsorbanceSpectroscopy[
				{Object[Data, AbsorbanceSpectroscopy,"id:bq9LA0dBL6lL"],
				Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"],
				Object[Data, AbsorbanceSpectroscopy, "id:8qZ1VWNm1aRn"]},
				LegendPlacement -> Right
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotAbsorbanceSpectroscopy[
				{Object[Data, AbsorbanceSpectroscopy,"id:bq9LA0dBL6lL"],
					Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"],
					Object[Data, AbsorbanceSpectroscopy, "id:8qZ1VWNm1aRn"]},
				Boxes -> True
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,IncludeReplicates,"Indicate that replicate data should be averaged together and shown with error bars:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "Replicate Data"],IncludeReplicates->True],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,ErrorBars,"Toggle whether or not the error bars are displayed:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "Replicate Data"],IncludeReplicates->True,ErrorBars->False],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,ErrorType,"Indicate which statistic is used to generate the error bars:"},
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "Replicate Data"],IncludeReplicates->True,ErrorType->StandardError],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,Fractions,"Indicate a series of fractions to overlay on the plot:"},
			PlotAbsorbanceSpectroscopy[
				Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],
				Fractions->{
					{940 Nanometer,950 Nanometer,"A1"},
					{950 Nanometer,960 Nanometer,"A2"},
					{960 Nanometer,970 Nanometer,"A3"}
				}
			],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],		
		Test[
			"Plots many sets of data on the same graph:",
			PlotAbsorbanceSpectroscopy[{Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"],Object[Data, AbsorbanceSpectroscopy, "id:8qZ1VWNm1aRn"]}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Accepts EmeraldListLinePlot options:",
			PlotAbsorbanceSpectroscopy[dynamicSample,PlotStyle->ColorFade[{Red,Blue},Length[dynamicSample]],FillingStyle->Core`Private`fillingFade[{Red,Blue},Length[dynamicSample]]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Test[
			"Plots the absorbance spectroscopy data as a dashed line without filling when the spectra is outside of the dynamic range:",
			PlotAbsorbanceSpectroscopy[dynamicSample[[1]]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		(* Output tests *)
		Test[
			"Setting Output to Result returns the plot:",
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Output->Result],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Test[
			"Setting Output to Preview returns the plot:",
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Output->Preview],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

		Test[
			"Setting Output to Options returns the resolved options:",
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotAbsorbanceSpectroscopy]],
			TimeConstraint->120
		],

		Test[
			"Setting Output to Tests returns a list of tests:",
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Output->Tests],
			{(_EmeraldTest|_Example)...},
			TimeConstraint->120
		],

		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for data object input:",
			PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotAbsorbanceSpectroscopy]]
		],

		Test[
			"Setting Output to {Result,Options} returns the plot along with all resolved options for raw spectrum input:",
			PlotAbsorbanceSpectroscopy[Download[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],AbsorbanceSpectrum],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotAbsorbanceSpectroscopy]],
			TimeConstraint->120
		],

		Test[
			"Setting Output to Options returns all of the defined options:",
			Sort@Keys@PlotAbsorbanceSpectroscopy[Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Output->Options],
			Sort@Keys@SafeOptions@PlotAbsorbanceSpectroscopy,
			TimeConstraint->120
		],

		(* Dummy tests to satiate command builder *)
		Example[{Messages,"NoDataForPlotRamanSpectroscopyOutput","Dummy Test:"},True,True],
		Example[{Messages,"RamanMeasurementPositionSpectraMismatch","Dummy Test:"},True,True],
		Example[{Messages,"HighRamanSpectraDensity","Dummy Test:"},True,True],
		Example[{Messages,"WavelengthRequired","Dummy Test:"},True,True]

	},
	Variables:>{dynamicSample},
	SetUp:>(
		dynamicSample={Object[Data, AbsorbanceSpectroscopy, "id:bq9LA0dBL6lL"],Object[Data, AbsorbanceSpectroscopy, "id:rea9jl1o9473"],Object[Data, AbsorbanceSpectroscopy, "id:8qZ1VWNm1aRn"]};
	)
];
