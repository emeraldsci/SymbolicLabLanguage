(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*PlotFit*)


DefineTests[PlotFit,{

	Example[{Basic,"Plot a fit object:"},
		PlotFit[Object[Analysis, Fit, "id:o1k9jAKp3b7E"]],
		_?ValidGraphicsQ
	],
	Example[{Basic,"Plot the output of the fit function:"},
		Module[{xy},
			xy=Map[{#,#^3+RandomVariate[CauchyDistribution[0,0.005`]]}&,Range[-3,3,0.1]];
			PlotFit[AnalyzeFit[xy,Polynomial,PolynomialDegree->3,Upload->False]]
		],
		_?ValidGraphicsQ
	],
	Example[{Basic,"Plot a fit and its data:"},
		Module[{xy,f},
			xy=Map[{#,#^3+RandomVariate[CauchyDistribution[0,0.005`]]}&,Range[-3,3,0.1]];
			f=#^3&;
			PlotFit[xy,f]
		],
		_?ValidGraphicsQ
	],
	Example[{Basic,"Plot a 2-D fit:"},
		PlotFit[Object[Analysis, Fit, "id:eGakld01qaKe"]],
		_?ValidGraphicsQ
	],


	(* ---------------------- Additional ---------------------- *)
	Example[{Additional,"Plot a unitless fit option:"},
		PlotFit[Object[Analysis, Fit, "id:lYq9jRzZrJJl"]],
		_?ValidGraphicsQ
	],
	Example[{Additional,"Plot a unitless fit option:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"]],
		_?ValidGraphicsQ
	],
	Example[{Additional,"Plot a 2-D LinearLog fit:"},
		PlotFit[Object[Analysis,Fit,"id:qdkmxz0V749a"]],
		_?ValidGraphicsQ
	],
	Example[{Additional,"Plot a 2-D LinearLog fit: without showing excluded points:"},
		PlotFit[Object[Analysis,Fit,"id:qdkmxz0V749a"],Display->{}],
		_?ValidGraphicsQ
	],


	(* ---------------------- Options ---------------------- *)

	(* PlotStyle *)
	Example[{Options,PlotStyle,"Plot the fit:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],PlotStyle->Fit],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotStyle,"Plot the error:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],PlotStyle->Error],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotStyle,"Plot a 2-D fit:"},
		PlotFit[Object[Analysis, Fit, "id:dORYzZn0XRbR"],PlotStyle->Fit],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotStyle,"Plot the error of a 2-D fit:"},
		PlotFit[Object[Analysis, Fit, "id:dORYzZn0XRbR"],PlotStyle->Error],
		_?ValidGraphicsQ
	],

	(* PlotType *)
	Example[{Options,PlotType,"Plot using Linear axes:"},
		PlotFit[Map[{#,Exp[#]+10}&,Range[0,5,0.1]],7 +15 #1-11 #1^2+2.5 #1^3&],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotType,"Plot using LinearLog axes:"},
		PlotFit[Map[{#,Exp[#]+10}&,Range[0,5,0.1]],7 +15 #1-11 #1^2+2.5 #1^3&,PlotType->LinearLog],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotType,"Plot using LogLinear axes:"},
		PlotFit[Map[{#,Exp[#]+10}&,Range[0,5,0.1]],7 +15 #1-11 #1^2+2.5 #1^3&,PlotType->LogLinear],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotType,"Plot using Log axes:"},
		PlotFit[Map[{#,Exp[#]+10}&,Range[0,5,0.1]],7 +15 #1-11 #1^2+2.5 #1^3&,PlotType->Log],
		_?ValidGraphicsQ
	],
	Example[{Options,FrameLabel,"Specify frame label:"},
		PlotFit[Object[Analysis, Fit, "id:eGakld09W8bq"],FrameLabel -> {"Distance", "Volume"}],
		_?ValidGraphicsQ
	],

	Example[{Options,TargetUnits,"Specify frame label:"},
		PlotFit[Object[Analysis, Fit, "id:o1k9jAKp3b7E"],TargetUnits -> {Inch, Milliliter}],
		_?ValidGraphicsQ
	],

	(* Display *)
	Example[{Options,Display,"Plot only the points:"},
		PlotFit[Object[Analysis,Fit,"id:eGakldJ4qebG"],Display->{}],
		_?ValidGraphicsQ
	],
		Example[{Options,Display,"Plot only the fit and points:"},
		PlotFit[Object[Analysis,Fit,"id:eGakldJ4qebG"],Display->{Fit}],
		_?ValidGraphicsQ
	],
	Example[{Options,Display,"Plot the excluded points:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Display->{Exclude}],
		_?ValidGraphicsQ
	],
	Example[{Options,Display,"Plot the quantile lines:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Display->{Quantile},PlotStyle->Error],
		_?ValidGraphicsQ
	],
	Example[{Options,Display,"Plot the confidence and prediction bands:"},
		PlotFit[Object[Analysis,Fit,"id:eGakldJ4qebG"],Display->{ConfidenceBands,PredictionBands}],
		_?ValidGraphicsQ
	],

	Example[{Options,ConfidenceLevel,"Specify confidence level for prediction and confidence bands:"},
		PlotFit[Object[Analysis, Fit, "id:eGakldJ4qebG"],
			Display -> {PredictionBands, ConfidenceBands},
			ConfidenceLevel -> 0.99],
		_?ValidGraphicsQ
	],

	Example[{Options,ConfidenceLevel,"Show bands at multiple confidence levels:"},
		PlotFit[Object[Analysis, Fit, "id:eGakldJ4qebG"],
			Display -> {PredictionBands},
			ConfidenceLevel -> {0.5,0.75,0.99}],
		_?ValidGraphicsQ
	],

	Example[{Options,ErrorBandFilling,"Fill error bands:"},
		PlotFit[Object[Analysis, Fit, "id:eGakldJ4qebG"],
			Display -> {PredictionBands},
			ConfidenceLevel -> {0.5,0.75,0.99},
			ErrorBandFilling->True
		],
		_?ValidGraphicsQ
	],

	Example[{Options,Legend,"Add a legend:"},
		PlotFit[Object[Analysis, Fit, "id:o1k9jAKp3b7E"],
			ConfidenceLevel -> 0.9, Legend -> Automatic],
		_?ValidGraphicsQ
	],

	(* Exclude *)
	Example[{Options,Exclude,"No excludes:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Exclude->None],
		_?ValidGraphicsQ
	],
	Example[{Options,Exclude,"Specify points to exclude:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Exclude->{{6,0.0007687286191898207`},{26,0.0014696341489390946`},{31,0.010574960522093474`}}],
		_?ValidGraphicsQ
	],
	Example[{Options,Exclude,"Specify indices of points to exclude:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Exclude->{5,10,15,20,25,30,35}],
		_?ValidGraphicsQ
	],
	Test["Excludeing a point that is not in the data should be ok:",
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Exclude->{{1,1}}],
		_?ValidGraphicsQ
	],

	(* Outliers *)
	Example[{Options,Outliers,"No outliers:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Outliers->{},Exclude->None],
		_?ValidGraphicsQ
	],
	Example[{Options,Outliers,"Compute outliers:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Outliers->Automatic,Exclude->None],
		_?ValidGraphicsQ
	],
	Example[{Options,Outliers,"Specify outlier points:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Outliers->{{6,0.0007687286191898207`},{26,0.0014696341489390946`},{31,0.010574960522093474`}},Exclude->None],
		_?ValidGraphicsQ
	],
	Example[{Options,Outliers,"Specify indices of outliers:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Outliers->{5,10,15,20,25,30,35},Exclude->None],
		_?ValidGraphicsQ
	],


	(* OutlierDistance *)
	Example[{Options,OutlierDistance,"Strict outlier tolerance:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],OutlierDistance->1,Outliers->Automatic,Exclude->None],
		_?ValidGraphicsQ
	],
	Example[{Options,OutlierDistance,"Loose outlier tolerance:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],OutlierDistance->3,Outliers->Automatic,Exclude->None],
		_?ValidGraphicsQ
	],
	Example[{Options,OutlierDistance,"No outliers:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],OutlierDistance->Infinity,Outliers->Automatic,Exclude->None],
		_?ValidGraphicsQ
	],



	(* Error *)
	Example[{Options,Error,"Compute error based on fit and data:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Error->Automatic],
		_?ValidGraphicsQ
	],
	Example[{Options,Error,"Specify constant error:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Error->2.5],
		_?ValidGraphicsQ
	],
	Example[{Options,Error,"Specify error that varies with x-coordinate:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Error->(#^2&)],
		_?ValidGraphicsQ
	],


	(* SamplePoints *)
	Example[{Options,SamplePoints,"Display error bars at 5 evenly distributed points:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"],SamplePoints->5],
		_?ValidGraphicsQ
	],
	Example[{Options,SamplePoints,"Display error bars at 50 evenly distributed points:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"],SamplePoints->50],
		_?ValidGraphicsQ
	],
	Example[{Options,SamplePoints,"Display error bars at the given x-values:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"],SamplePoints->{5,6,15,17,40,43}],
		_?ValidGraphicsQ
	],

	(* PointSize *)
	Example[{Options,PointSize,"Determine point size automatically based on number of points:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],PointSize->Automatic],
		_?ValidGraphicsQ
	],
	Example[{Options,PointSize,"Large points:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],PointSize->Large],
		_?ValidGraphicsQ
	],
	Example[{Options,PointSize,"Specify point size:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],PointSize->.05],
		_?ValidGraphicsQ
	],


	Example[{Options,StandardDeviation,"Standard deviation of the fit:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"], StandardDeviation->0.001],
		_?ValidGraphicsQ
	],
	Example[{Options,Frame,"Specification for plot frame:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], Frame->True],
		_?ValidGraphicsQ
	],
	Example[{Options,LabelStyle,"Style to be applied to all plot labels:"},
		PlotFit[Object[Analysis, Fit, "id:eGakld09W8bq"],FrameLabel -> {"Distance", "Volume"},LabelStyle->{Bold, 20, FontFamily -> "Times"}],
		_?ValidGraphicsQ
	],
	Example[{Options,ImageSize,"Size of the plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], ImageSize->300],
		_?ValidGraphicsQ
	],

	(* additional options *)
	Example[{Options,Joined,"Specifies whether points in each dataset should be joined into a line, or should be plotted as separate points:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"], Joined->True],
		_?ValidGraphicsQ
	],
	Example[{Options,HatDiagonal,"Influence matrix for the fit, to be used for computing outliers:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"], HatDiagonal->Null],
		_?ValidGraphicsQ
	],
	Example[{Options,MeanPredictionError,"Function defining mean prediction error for the fit:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"], MeanPredictionError->Null],
		_?ValidGraphicsQ
	],
	Example[{Options,SinglePredictionError,"Function defining single prediction error for the fit:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"], SinglePredictionError->Null],
		_?ValidGraphicsQ
	],
	Example[{Options,DegreesOfFreedom,"Degrees of freedom of the fit. Used to calculate error bands:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"], DegreesOfFreedom->3],
		_?ValidGraphicsQ
	],
	Example[{Options,AspectRatio,"The ratio of height to width for this plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], AspectRatio->0.5],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotLabel,"Specifies an overall label for a plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], PlotLabel->"Sigmoid"],
		_?ValidGraphicsQ
	],
	Example[{Options,FrameStyle,"Style specifications for the frame of the plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], FrameStyle->Red],
		_?ValidGraphicsQ
	],
	Example[{Options,FrameTicks,"Specifies the location of tick marks on the frame of the plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], FrameTicks->All],
		_?ValidGraphicsQ
	],
	Example[{Options,FrameTicksStyle,"Style specifications for frame ticks:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], FrameTicksStyle->Blue],
		_?ValidGraphicsQ
	],
	Example[{Options,GridLines,"Grid lines that should be drawn on the plot. When set to Automatic, the grid lines resolve to reasonably spaced grid lines, depending on the range of the plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], GridLines->Automatic],
		_?ValidGraphicsQ
	],
	Example[{Options,GridLinesStyle,"Style specifications for grid lines of the plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], GridLines->Automatic, GridLinesStyle->Purple],
		_?ValidGraphicsQ
	],
	Example[{Options,Background,"Specifies the background color of the plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], Background->LightYellow],
		_?ValidGraphicsQ
	],
	Example[{Options,RotateLabel,"Whether to rotate the vertical label on the frame of the plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], RotateLabel->False],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotRange,"PlotRange specification for the primary data. PlotRange units must be compatible with units of primary data:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], PlotRange->{{10, 40},Automatic}],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotRangeClipping,"Specifies whether graphics objects should be clipped at the edge of the region defined by PlotRange, or should be allowed to extend to the actual edge of the image:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], PlotRange->{{10, 40},Automatic}, PlotRangeClipping->False],
		_?ValidGraphicsQ
	],
	Example[{Options,InterpolationOrder,"Specifies the order of interpolation to use when the points of the dataset are joined together:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"], InterpolationOrder->1],
		_?ValidGraphicsQ
	],
	Example[{Options,Filling,"The region of the plot that should be filled under points, curves, and surfaces:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], Filling->Bottom],
		_?ValidGraphicsQ
	],
	Example[{Options,FillingStyle,"Specify how filling should be styled:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], Filling->Bottom, FillingStyle->Dashed],
		_?ValidGraphicsQ
	],
	Example[{Options,LabelingFunction,"Specifies how points on this plot should be labeled:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], LabelingFunction->Automatic],
		_?ValidGraphicsQ
	],
	Example[{Options,PlotMarkers,"Specifies what markers to draw at the points plotted:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], PlotMarkers->None],
		_?ValidGraphicsQ
	],
	Example[{Options,ColorFunction,"A function to apply to determine colors of elements in the plot:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], ColorFunction->"ArmyColors"],
		_?ValidGraphicsQ
	],
	Example[{Options,ColorFunctionScaling,"Scales the arguments to the color function between 0 and 1:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], ColorFunctionScaling->True],
		_?ValidGraphicsQ
	],
	Example[{Options,ClippingStyle,"The style of the curves or surfaces that extend beyond the plot range:"},
		PlotFit[Object[Analysis, Fit, "id:9RdZXvKBzWzl"], PlotRange->{{10, 40},Automatic},ClippingStyle->Red],
		_?ValidGraphicsQ
	],
	Example[{Options,Prolog,"Provide a list of graphics primitives to render before plot elements:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"], Prolog ->{Style[Disk[{35, 0.013},{10, 0.009}],LightGreen]}],
		_?ValidGraphicsQ
	],
	Example[{Options,Epilog,"Provide a list of graphics primitives to render after plot elements:"},
		PlotFit[Object[Analysis, Fit, "id:pZx9jonGV4Y5"], Epilog ->{Style[Disk[{35, 0.013},{10, 0.009}],LightGreen]}],
		_?ValidGraphicsQ
	],

	Example[{Messages,"NoPlotAvailabe","Cannot plot fits with more than 2 independent variables:"},
		PlotFit[Object[Analysis, Fit, "id:WNa4ZjKWLdmq"]],
		$Failed,
		Messages:>{Error::InvalidOption, Error::NoPlotAvailabe}
	],

	(* ---------------------- Tests ---------------------- *)
	Test["Given a link:",
		PlotFit[Link[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],Reference]],
		_?ValidGraphicsQ
	],
	Test["Given a packet:",
		PlotFit[Download[Object[Analysis, Fit, "id:9RdZXvKBzWzl"]]],
		_?ValidGraphicsQ
	],
	Test["QuantityFunction with QuantityUnits:",
		PlotFit[Object[Analysis,Fit,"id:9RdZXvK8Az3Z"]],
		_?ValidGraphicsQ
	]


},
	Stubs:> {
		Download[Object[Analysis,Fit,"id:eGakldJ4qebG"]]=<|AdjustedRSquared -> 0.6819181396797791, AIC -> 2.4479266148621974, AICc -> 3.9479266148621974, BestFitExpression -> -0.01695996835114195 + 0.5594745800234386*x, BestFitFunction -> (-0.01695996835114195 + 0.5594745800234386*#1 & ), BestFitParameters -> {{p5140, -0.01695996835114195, 0.05302128067707796}, {p5141, 0.5594745800234386, 0.08660446649234446}}, BestFitParametersDistribution -> MultinormalDistribution[{-0.01695996835114195, 0.5594745800234386}, {{0.0028112562046374804, 0.0008114849838719741}, {0.0008114849838719741, 0.007500333616423614}}], BestFitResiduals -> {-0.16140022146994681, 0.13281510214623327, -0.2374438105948633, 0.31426493343731177, 0.015843518953650104, 0.05222546317906607, 0.1315818562880044, -0.23268286177791553, 0.020485011742743864, 0.18123753501249654, -0.24485476165860298, -0.17355079405075555, -0.22778561877584907, 0.25701209469814945, -0.1272810315534309, 0.3958539878461808, 0.061694057674818836, 0.3745998776233878, -0.20703343149701142, -0.32558090722366684}, BestFitVariables -> {x}, BIC -> 5.435123435524169, CovarianceMatrix -> {{0.0028112562046374804, 0.0008114849838719741}, {0.0008114849838719741, 0.007500333616423614}}, DataPoints -> {{0.8511221555942918, 0.25218781070160684}, {-0.46110821728537443, -0.5076211563401488}, {-0.5794906733420495, -0.2889448062676187}, {0.048948830841040625, -0.16312513582446794}, {0.1993703832580911, 0.35159478778944}, {0.14196826025647447, -0.16531795434334173}, {-0.05175698349678903, -0.290771446614891}, {0.564229057661926, 0.6945658345674655}, {-0.6068350604532058, -0.34062523998804717}, {-0.9258759920399036, -0.772407860746315}, {-0.9710869540171143, -0.7216586555860541}, {-0.42260953506191656, -0.23291424875106453}, {-0.2109089595088185, 0.046279365116977944}, {0.2427018383192907, -0.008455490839971186}, {-0.9682092793069206, -0.4258333461199443}, {-0.5388723719824786, -0.186863506064269}, {0.6137953043494369, 0.38813695944493676}, {-0.6860931956091547, -0.08654673738420093}, {0.657987381374574, 0.7257671231275078}, {0.9388603068526673, 0.18272760030226398}}, DataUnits -> {1, 1}, DateCreated -> DateObject[{2018, 5, 2, 10, 31, 34.}, "Instant", "Gregorian", -7.], DependentVariableData -> {}, Derivative :> SafeEvaluate[{Download[Object[Analysis, Fit, "id:eGakldJ4qebG"], BestFitFunction, Verbose -> False]}, Computables`Private`derivativeComputable[Download[Object[Analysis, Fit, "id:eGakldJ4qebG"], BestFitFunction, Verbose -> False]]], DeveloperObject -> Null, EstimatedVariance -> 0.05446918119013592, Exclude -> {}, ExpressionType -> Linear, HatDiagonal -> {0.15252845198363485, 0.1518457455558245, 0.14206604070145862, 0.09598700637730676, 0.08423790865223504, 0.08058580989341617, 0.07554097684023522, 0.06715023395492786, 0.06361256535128355, 0.05145279395285998, 0.05043857643009036, 0.05340027760912369, 0.05861728565733116, 0.06302565336556303, 0.06695446743443516, 0.11226068239208828, 0.12177782299143569, 0.1308336145647061, 0.17672214442214051, 0.20096194186990365}, ID -> "id:eGakldJ4qebG", IndependentVariableData -> {}, LegacyID -> Null, MaxDomain -> {0.9388603068526673}, MeanPredictionDistribution -> Function[{x}, NormalDistribution[-0.01695996835114195 + 0.5594745800234386*x, Sqrt[0.0028112562046374804 + 0.0008114849838719741*x + (0.0008114849838719741 + 0.007500333616423614*x)*x]]], MeanPredictionError -> Function[{x}, Sqrt[0.0028112562046374804 + 0.0008114849838719741*x + (0.0008114849838719741 + 0.007500333616423614*x)*x]], MeanPredictionInterval -> Function[{x}, {-0.01695996835114195 + 0.5594745800234386*x - 2.1009220402410382*Sqrt[0.0028112562046374804 + 0.0008114849838719741*x + (0.0008114849838719741 + 0.007500333616423614*x)*x], -0.01695996835114195 + 0.5594745800234386*x + 2.1009220402410382*Sqrt[0.0028112562046374804 + 0.0008114849838719741*x + (0.0008114849838719741 + 0.007500333616423614*x)*x]}], MinDomain -> {-0.9710869540171143}, Name -> Null, Notebook -> Null, Object -> Object[Analysis, Fit, "id:eGakldJ4qebG"], Outliers -> {}, PredictedResponse -> {-0.5602584341161073, -0.5586484482661775, -0.5349640501514517, -0.4008116708215127, -0.3564687589416973, -0.34117026944668477, -0.3184453623522734, -0.2749382945622333, -0.2533992604938084, -0.1349581698955186, -0.04591668495628804, 0.010425658226287594, 0.06246766443250733, 0.09458269309129055, 0.11882554071345973, 0.29871184672128465, 0.3264429017701179, 0.35116724550412, 0.45922124219861826, 0.5083085075259308}, PredictedValues -> {}, Reference -> {}, ReferenceField -> Null, Response -> {-0.7216586555860541, -0.4258333461199443, -0.772407860746315, -0.08654673738420093, -0.34062523998804717, -0.2889448062676187, -0.186863506064269, -0.5076211563401488, -0.23291424875106453, 0.046279365116977944, -0.290771446614891, -0.16312513582446794, -0.16531795434334173, 0.35159478778944, -0.008455490839971186, 0.6945658345674655, 0.38813695944493676, 0.7257671231275078, 0.25218781070160684, 0.18272760030226398}, RSquared -> 0.6986592902229487, SecondaryIndependentVariableData -> {}, SinglePredictionDistribution -> Function[{x}, NormalDistribution[-0.01695996835114195 + 0.5594745800234386*x, Sqrt[0.05728043739477339 + 0.0008114849838719741*x + (0.0008114849838719741 + 0.007500333616423614*x)*x]]], SinglePredictionError -> Function[{x}, Sqrt[0.05728043739477339 + 0.0008114849838719741*x + (0.0008114849838719741 + 0.007500333616423614*x)*x]], SinglePredictionInterval -> Function[{x}, {-0.01695996835114195 + 0.5594745800234386*x - 2.1009220402410382*Sqrt[0.05728043739477339 + 0.0008114849838719741*x + (0.0008114849838719741 + 0.007500333616423614*x)*x], -0.01695996835114195 + 0.5594745800234386*x + 2.1009220402410382*Sqrt[0.05728043739477339 + 0.0008114849838719741*x + (0.0008114849838719741 + 0.007500333616423614*x)*x]}], StandardDeviation -> 0.23338633462595001, SumSquaredError -> 0.9804452614224466, SymbolicExpression -> p5140 + p5141*x, TertiaryIndependentVariableData -> {}, Type -> Object[Analysis, Fit]|>
	}
];


(* ::Subsubsection:: *)
(*PlotFitOptions*)


DefineTests[PlotFitOptions, {
	Example[{Basic,"Return the resolved options of PlotFit:"},
		PlotFitOptions[Object[Analysis, Fit, "id:o1k9jAKp3b7E"],FrameLabel->Automatic],
		_Grid
	],
	Example[{Basic,"The outliers can be automatically detected and put into resolved options:"},
		PlotFitOptions[Map[{#,Exp[#]+10}&,Range[0,5,0.1]],7 +15 #1-11 #1^2+2.5 #1^3&,Outliers->Automatic],
		_Grid
	],
	Example[{Basic,"Determine point size automatically based on number of points:"},
		PlotFitOptions[Object[Analysis, Fit, "id:9RdZXvKBzWzl"],PointSize->Automatic],
		_Grid
	],
	Example[{Options,OutputFormat,"Return the options as a list:"},
		PlotFitOptions[Object[Analysis, Fit, "id:o1k9jAKp3b7E"],OutputFormat->List],
		_List
	]
}
];


(* ::Subsubsection::Closed:: *)
(*PlotFitPreview*)


DefineTests[PlotFitPreview, {
	Example[{Basic,"Return a graphical display for the calculated fit function on top of input data:"},
		PlotFitPreview[Object[Analysis,Fit,"id:lYq9jRzZrJJl"]],
		ValidGraphicsP[]
	],
	Example[{Basic,"The 3-D preview of the 2-D fitobject:"},
		PlotFitPreview[Object[Analysis,Fit,"id:eGakld01qaKe"]],
		ValidGraphicsP[]
	],
	Example[{Basic,"Error plot preview:"},
		PlotFitPreview[Object[Analysis,Fit,"id:9RdZXvKBzWzl"],PlotStyle->Error],
		ValidGraphicsP[]
	]
}
];


(* ::Subsubsection:: *)
(*ValidPlotFitQ*)


DefineTests[ValidPlotFitQ, {
	Example[{Basic,"Return test results for all the gathered tests/warning:"},
		ValidPlotFitQ[Map[{#,Exp[#]+10}&,Range[0,5,0.1]],7 +15 #1-11 #1^2+2.5 #1^3&],
		True
	],
	Example[{Basic,"The function also checks if the input objects are valid:"},
		ValidPlotFitQ[Object[Analysis,Fit,"id:eGakld01qaKe"]],
		True
	],
	Example[{Basic,"Works on 2-D fit:"},
		ValidPlotFitQ[Object[Analysis, Fit, "id:dORYzZn0XRbR"],PlotStyle->Fit],
		True
	],
	Example[{Options,OutputFormat,"Specify OutputFormat to be TestSummary:"},
		ValidPlotFitQ[Object[Analysis,Fit,"id:eGakld01qaKe"], OutputFormat->TestSummary],
		_EmeraldTestSummary
	],
	Example[{Options,Verbose,"Specify Verbose to be True:"},
		ValidPlotFitQ[Object[Analysis, Fit, "id:dORYzZn0XRbR"], Verbose->True],
		True
	]

}
];


(* ::Section:: *)
(*End Test Package*)
