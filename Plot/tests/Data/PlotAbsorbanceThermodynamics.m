(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAbsorbanceThermodynamics*)


DefineTests[PlotAbsorbanceThermodynamics,
	{
		Example[
			{Basic,"Plots all primary data fields present in the absorbance thermodynamics data object:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Test[
			"Given a packet:",
			PlotAbsorbanceThermodynamics[Download[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"]]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Basic,"Plots absorbance thermodynamics object in a link:"},
			PlotAbsorbanceThermodynamics[Link[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],Protocol]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Basic,"Plot only the cooling curve from the data object:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],PrimaryData->{CoolingCurve}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Basic,"Plot raw cooling curve data:"},
			PlotAbsorbanceThermodynamics[{{86.76999664, 0.8889893293}, {84.31999969, 0.8903881907}, {81.72000122, 0.8887994289}, {79.22000122, 0.8896051645}, {76.66999817, 0.8877320886}, {74.12000275, 0.8876239061}, {71.66999817, 0.8869766593}, {69.01999664, 0.8862888217}, {66.56999969, 0.883474648}, {63.97000122, 0.8812503815}, {61.41999817, 0.8708394766}, {59.02999878, 0.8542538881}, {56.36999893, 0.8401528597}, {53.81999969, 0.8302058578}, {51.31999969, 0.822193265}, {48.77000046, 0.8170831203}, {46.16999817, 0.8125882149}, {43.66999817, 0.8086900711}, {41.11999893, 0.8073564172}, {38.61999893, 0.8050329685}, {36.18000031, 0.8041143417}, {33.47000122, 0.8016431928}, {30.96999931, 0.8016029596}, {28.55999947, 0.8012183309}, {25.87000084, 0.8000658154}, {23.31999969, 0.8006708026}, {20.95999908, 0.7997810245}, {18.27000046, 0.7994769812}, {15.77000046, 0.7989316583}, {13.38000011, 0.7977842093}, {10.67000008, 0.7979000807}},PrimaryData->{CoolingCurve}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Basic,"Plots the Melting and Cooling curve when both are present in the absorbance thermodynamics data object:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,PlotType,"Plot three dimensional data:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "PlotAbsorbanceThermodynamics test 3D data"],PlotType->ListPlot3D],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,ArrowheadSize,"Indicate that small arrow heads should be used to chart the direction of the curve:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],ArrowheadSize->Small],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Wavelength,"Plot the data gathered at a specified wavelength:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"], Wavelength -> 260 Nanometer],
			_?ValidGraphicsQ,
			TimeConstraint -> 500
		],
		Example[
			{Options,CoolingCurve,"Provide a new value for the CoolingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],CoolingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,MeltingCurve,"Provide a new value for the MeltingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],MeltingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,SecondaryCoolingCurve,"Provide a new value for the SecondaryCoolingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],SecondaryCoolingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,SecondaryMeltingCurve,"Provide a new value for the SecondaryMeltingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],SecondaryMeltingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,TertiaryCoolingCurve,"Provide a new value for the CoolingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],TertiaryCoolingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,TertiaryMeltingCurve,"Provide a new value for the MeltingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],TertiaryMeltingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,AggregationCurve,"Provide a new value for the AggregationCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],AggregationCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,AggregationRecoveryCurve,"Provide a new value for the AggregationRecoveryCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],AggregationRecoveryCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,FinalCorrelationCurve,"Provide a new value for the FinalCorrelationCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],FinalCorrelationCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,FinalIntensityDistribution,"Provide a new value for the FinalIntensityDistribution instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],FinalIntensityDistribution->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,FinalMassDistribution,"Provide a new value for the FinalMassDistribution instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],FinalMassDistribution->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,InitialCorrelationCurve,"Provide a new value for the InitialCorrelationCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],InitialCorrelationCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,InitialIntensityDistribution,"Provide a new value for the InitialIntensityDistribution instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],InitialIntensityDistribution->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,InitialMassDistribution,"Provide a new value for the InitialMassDistribution instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],InitialMassDistribution->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,QuaternaryCoolingCurve,"Provide a new value for the QuaternaryCoolingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],QuaternaryCoolingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,QuaternaryMeltingCurve,"Provide a new value for the QuaternaryMeltingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],QuaternaryMeltingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,QuinaryCoolingCurve,"Provide a new value for the QuinaryCoolingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],QuinaryCoolingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,QuinaryMeltingCurve,"Provide a new value for the QuinaryMeltingCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],QuinaryMeltingCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryAggregationCurve,"Provide a new value for the SecondaryAggregationCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],SecondaryAggregationCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryAggregationRecoveryCurve,"Provide a new value for the SecondaryAggregationRecoveryCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],SecondaryAggregationRecoveryCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,TertiaryAggregationCurve,"Provide a new value for the TertiaryAggregationCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],TertiaryAggregationCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,TertiaryAggregationRecoveryCurve,"Provide a new value for the TertiaryAggregationRecoveryCurve instead of using the value recorded in the object being plotted:"},
			PlotAbsorbanceThermodynamics[Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],TertiaryAggregationRecoveryCurve->$outsideData],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],

	(* Standard plot options *)
		Example[
			{Options,PrimaryData,"Indicate the data which should be displayed on the primary y-axis:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "Secondary Cooling Curve Data"],PrimaryData->{SecondaryCoolingCurve}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,SecondaryData,"Plot the Cooling Curve on the secondary y-axis:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],PrimaryData->{MeltingCurve},SecondaryData->{CoolingCurve}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Display,"There is no additional overlay display for absorbance thermodynamics plots:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],Display->{}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,TargetUnits,"Plot the x-axis in units of Fahrenheit:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],TargetUnits->{Fahrenheit,ArbitraryUnit}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Map,"Generate a separate plot for each data object given:"},
			PlotAbsorbanceThermodynamics[{Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"]},Map->True],
			{_?ValidGraphicsQ..},
			TimeConstraint -> 120
		],
		Example[
			{Options,Legend,"Add a legend to the plot:"},
			PlotAbsorbanceThermodynamics[{Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"]},Legend->{"Data 92","Data 96"}],
			_?Core`Private`ValidLegendedQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,IncludeReplicates,"Include data gathered in an identical fashion when plotting:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "Secondary Cooling Curve Data"],PrimaryData->{SecondaryCoolingCurve},IncludeReplicates->True],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[{Options, Units, "Specify relevant units:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],Units -> {AbsorbanceSpectrum -> {Meter Nano, AbsorbanceUnit},Temperature -> {Meter Nano, Celsius}}],
			_?ValidGraphicsQ
		],
		Example[{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],PlotTheme->"Marketing"],
			_?ValidGraphicsQ
		],
		Example[{Options, Zoomable,"To improve performance indicate that the plot should not allow interactive zooming:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],Zoomable -> False],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotLabel, "Provide a title for the plot:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],PlotLabel -> "Absorbance Spectrum"],
			_?ValidGraphicsQ
		],
		Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],FrameLabel -> {"Wavelength", "Recorded Absorbance", None, None}],
			_?ValidGraphicsQ
		],
		Example[{Options, OptionFunctions,"Turn off formatting based on the absorbance value at a given wavelength by clearing the option functions:"},
			PlotAbsorbanceThermodynamics[Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],OptionFunctions -> {}],
			_?ValidGraphicsQ
		],
		Example[{Options, LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotAbsorbanceThermodynamics[{Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"]},LegendPlacement -> Right],
			_?ValidGraphicsQ
		],
		Example[{Options, Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotAbsorbanceThermodynamics[{Object[Data, MeltingCurve, "id:pZx9jonGJLOp"],Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"]},Boxes -> True],
			_?ValidGraphicsQ
		],
		Test["Plots multiple sets of absorbance thermodynamics data:",
			PlotAbsorbanceThermodynamics[{Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"]}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],

		(* Messages *)
		Example[{Messages,"UnresolvablePlotType","The provided data objects do not contain data of similar dimensionality:"},
			PlotAbsorbanceThermodynamics[{Object[Data,MeltingCurve,"id:pZx9jonGJLOp"],Object[Data,MeltingCurve,"PlotAbsorbanceThermodynamics test 3D data"]}],
			$Failed,
			Messages:>{Error::UnresolvablePlotType}
		],
		Example[{Messages,"MismatchedPlotType","The requested PlotType must match with the allowed PlotType determined from the dimensionality of the provided data:"},
			PlotAbsorbanceThermodynamics[
				Object[Data,MeltingCurve,"PlotAbsorbanceThermodynamics test 3D data"],
				PlotType->ListLinePlot
			],
			$Failed,
			Messages:>{Error::MismatchedPlotType}
		],
		Example[{Messages,"Invalid3DPlotOptions","EmeraldListLinePlot options must be Null when 3D plot is requested:"},
			PlotAbsorbanceThermodynamics[
				Object[Data,MeltingCurve,"PlotAbsorbanceThermodynamics test 3D data"],
				PlotType->ListPlot3D,
				AlignmentPoint->Center
			],
			$Failed,
			Messages:>{Error::Invalid3DPlotOptions}
		]
	},
	Stubs:>{
		$outsideData=QuantityArray[Table[{x,.8+.001*x},{x,1,100}],{Celsius,ArbitraryUnit}]
	},
	SymbolSetUp:>(
		Module[{allObjects},
			allObjects={
				Object[Data,MeltingCurve,"PlotAbsorbanceThermodynamics test 3D data"]
			};

			EraseObject[
				PickList[allObjects,DatabaseMemberQ[allObjects]],
				Force->True,
				Verbose->False
			]
		];

		$CreatedObjects={};

		Module[{data1},
			data1=CreateID[Object[Data,MeltingCurve]];
			Upload[
				<|
					Name->"PlotAbsorbanceThermodynamics test 3D data",
					Object->data1,
					Type->Object[Data,MeltingCurve],
					MinWavelength->300 Nanometer,
					MaxWavelength->500 Nanometer,
					MeltingCurve3D->QuantityArray[
						{{22.1161,266,3334.89},{24.8088,266,3322.31},{27.6072,266,3342.07},{30.3384,266,3328.32},{33.1176,266,3287.77},{36.0314,266,3299.14},{38.801,266,3324.75},{41.5802,266,3324.39},{44.3499,266,3283.66},{47.1483,266,3267.2},{49.8987,266,3311.95},{52.6683,266,3247.77},{55.4379,266,3271.48},{58.2267,266,3358.25},{60.9963,266,3463.33},{63.7755,266,3674.1},{66.5547,266,3833.56},{69.3147,266,3930.55},{72.0747,266,3991.85},{74.8443,266,3958.31},{77.6043,266,4067.92},{80.3739,266,4037.5},{83.1531,266,4061.26},{85.9227,266,4010.08},{88.7019,266,4017.95},{91.4715,266,3975.01},{94.2315,266,3989.08},{22.1161,473,31725.2},{24.8088,473,107589.},{27.6072,473,30182.4},{30.3384,473,34274.7},{33.1176,473,29972.},{36.0314,473,34408.8},{38.801,473,32074.1},{41.5802,473,33704.1},{44.3499,473,76050.7},{47.1483,473,31513.8},{49.8987,473,28513.6},{52.6683,473,28577.3},{55.4379,473,30210.},{58.2267,473,31476.3},{60.9963,473,39518.9},{63.7755,473,56068.2},{66.5547,473,68312.5},{69.3147,473,74598.4},{72.0747,473,77597.6},{74.8443,473,79565.8},{77.6043,473,84727.},{80.3739,473,87251.4},{83.1531,473,88683.7},{85.9227,473,88388.4},{88.7019,473,89189.9},{91.4715,473,90222.7},{94.2315,473,91797.6}},
						{Celsius,Nanometer,ArbitraryUnit}
					]
				|>
			]
		]
	),
	SymbolTearDown:>Module[{objsToErase},
		objsToErase=Flatten[{
			$CreatedObjects,
			Object[Data,MeltingCurve,"PlotAbsorbanceThermodynamics test 3D data"]
		}];

		EraseObject[
			PickList[objsToErase,DatabaseMemberQ[objsToErase]],
			Force->True,
			Verbose->False
		];
	]
];


