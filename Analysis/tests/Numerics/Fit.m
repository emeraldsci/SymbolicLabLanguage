(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Fit: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AnalyzeFit*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeFit*)


DefineTests[AnalyzeFit, {

	(* --------------------- BASIC --------------------*)
	Example[{Basic, "Fit a line to data:"},
		PlotFit[AnalyzeFit[LinearData, Polynomial]],
		_?ValidGraphicsQ,
		Stubs:>{
			AnalyzeFit[LinearData, Polynomial] =
			AnalyzeFit[LinearData, Polynomial, Upload->False]
		},
		EquivalenceFunction -> RoundMatchQ[12]
	],
	Test["Fit a line to data:",
		stripAppendReplaceKeyHeads@Download[AnalyzeFit[LinearData, Polynomial]],
		validAnalysisPacketP[Object[Analysis, Fit],
			{

			},
			ResolvedOptions -> {ReferenceField -> Null, Exclude -> {}, Domain -> {{-3., 3.}}, Range->{-4.897`,6.318`}, ExcludeOutliers -> False, OutlierDistance -> 1.5, PolynomialDegree -> 1, StartingValues -> {}},
			Round -> 12
		]
	],

	Example[{Basic,"Fit an exponential to data:"},
		PlotFit[AnalyzeFit[ExponentialData,Exponential]],
		_?ValidGraphicsQ,
		Stubs:>{
			AnalyzeFit[ExponentialData,Exponential]=
			stripAppendReplaceKeyHeads[AnalyzeFit[ExponentialData, Exponential, Upload->False]]
		},
		EquivalenceFunction -> RoundMatchQ[5]
	],
	Test["Fit an exponential to data:",
		stripAppendReplaceKeyHeads@AnalyzeFit[ExponentialData,Exponential, Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {1,1},
				MinDomain -> {-3.},
				MaxDomain -> {3.},
				ExpressionType -> Exponential,
				BestFitExpression->0.17353902209687178` +E^(1.0279487943734598` (-0.06867780594777119`+x)),
				BestFitVariables -> {x},
				BestFitFunction->(0.9318370973505959` (0.18623321886441183` +E^(1.0279487943734598` #1))&),
				BestFitParameters->{{_Symbol,0.17353902209687178`,0.12755126617524618`},{_Symbol,1.0279487943734598`,0.0330308304896095`},{_Symbol,0.06867780594777119`,0.0917825371007853`}},
				CovarianceMatrix->{{0.016269325502908497`,0.002754661667453522`,0.008306411511034378`},{0.0027546616674535176`,0.0010910357628333169`,0.002997113422421144`},{0.008306411511034369`,0.002997113422421145`,0.008424034116657028`}},
				HatDiagonal->{0.1442510826636265`,0.1391386443209117`,0.1324068252935273`,0.12381708720907932`,0.11334861551037317`,0.10147088276721555`,0.08957311716413298`,0.08053265260348941`,0.07922583533626597`,0.09236336875807488`,0.12627001928581666`,0.18047411678858177`,0.23667919893215644`,0.257067599411554`,0.2685978184586423`,0.8347831354965503`},
				RSquared->0.9973850641331126`,
				AdjustedRSquared->0.9969827663074375`,
				AIC->13.748700560178591`,
				AICc->17.385064196542228`,
				BIC->16.839055449137717`,
				EstimatedVariance->0.10321470800926999`,
				SumSquaredError->1.3417912041205098`,
				StandardDeviation->0.32127045928511694`
			},
			ResolvedOptions -> {Upload->False,ReferenceField->Null,Exclude->{},Domain->{{-3.`,3.`}},Range->{-0.1217`,20.53`},ExcludeOutliers->False,OutlierDistance->1.5`,PolynomialDegree->1,StartingValues->{}},
			NullFields -> {ReferenceField, Derivative, Exclude, Outliers, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 4
		]
	],
	Test["Valid statistics when the sum of residuals is exactly zero:",
		AnalyzeFit[{{3,3},{4,4},{5,5}},Upload->False][ANOVATable],
		_Pane
	],
	Test["Linear fit on two data points runs correctly, and the marginal best fit distribution is null (only one fit is possible):",
		AnalyzeFit[{{0.5,0.2},{2.2,3.5}},Upload->False][Replace[MarginalBestFitDistribution]],
		Null
	],
	Test["Fit runs without errors given a vertical line as input:",
		PlotFit@AnalyzeFit[{{3,3},{3,-2},{3,0}}],
		ValidGraphicsP[]
	],

	Example[{Basic, "Fit uncertain data:"},
		PlotFit[AnalyzeFit[UncertainData],Display->{DataError}],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[UncertainData]=
			stripAppendReplaceKeyHeads[AnalyzeFit[UncertainData,Upload->False]]
		}
	],
	Test["Fit uncertain data:",
		stripAppendReplaceKeyHeads@AnalyzeFit[UncertainData, Polynomial, Upload -> False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{

			},
			ResolvedOptions -> {},
			NullFields -> {ReferenceField, Derivative, Exclude, Calibration},
			NonNullFields -> {Response, SymbolicExpression, PredictedResponse, BestFitResiduals,  MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 10
		]
	],


	(* --------------------- ADDITIONAL --------------------*)
	Example[{Additional,"Multivariate Data","Fit a linear function of two variables:"},
		PlotFit[AnalyzeFit[LinearData3D, Linear]],
		_?ValidGraphicsQ,
		Stubs:>{
			AnalyzeFit[LinearData3D, Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData3D, Linear, Upload->False]]
		},
		EquivalenceFunction -> RoundMatchQ[12]
	],
	Test["Fit a linear function of two variables:",
		stripAppendReplaceKeyHeads@AnalyzeFit[LinearData3D, Linear, Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {1,1,1},
				MinDomain->{-2.`,-3.`},
				MaxDomain->{2.`,3.`},
				DataPoints->{{_?NumericQ,_?NumericQ,_?NumericQ}..},
				ExpressionType -> Linear,
				BestFitExpression->1.0000000000000007` +1.9999999999999916` x1+2.9999999999999987` x2,
				BestFitVariables -> {x1,x2},
				BestFitFunction->(1.0000000000000007` +1.9999999999999916` #1+2.9999999999999987` #2&)
			},
			ResolvedOptions -> {},
			NullFields -> {ReferenceField, Derivative, Exclude, Calibration},
			NonNullFields -> {Response, PredictedResponse, BestFitResiduals,  MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 10
		]
	],

	Example[{Additional,"Multivariate Data","Fit a quadratic function of two variables:"},
		PlotFit[AnalyzeFit[QuadraticData3D,Polynomial, PolynomialDegree->2]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[QuadraticData3D,Polynomial, PolynomialDegree->2]=
			stripAppendReplaceKeyHeads[AnalyzeFit[QuadraticData3D,Polynomial, PolynomialDegree->2, Upload->False]]
		}
	],

	Example[{Additional,"Multivariate Data","Fit a 2-D Gaussian:"},
		PlotFit[AnalyzeFit[GaussianData3D,Gaussian]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[GaussianData3D,Gaussian]=
			stripAppendReplaceKeyHeads[AnalyzeFit[GaussianData3D,Gaussian, Upload->False]]
		}
	],

	Example[{Additional,"Multivariate Data","Specify multivariate function to fit to:"},
		PlotFit[AnalyzeFit[QuadraticData3D,   a0 + a1*#1 + a2*#2 + a12*#1*#2  + a11*#1^2 + a22*#2^2 &]],
		_?ValidGraphicsQ
	],

	Example[{Additional,"Multivariate Data","Fit a LinearLog function of two variables:"},
		PlotFit[AnalyzeFit[LinearData3D,LinearLog]],
		ValidGraphicsP[],
		Messages:>{AnalyzeFit::NonPositiveValues}
	],

	Example[{Additional,"Units","The given data can be a QuantityArray:"},
		PlotFit[AnalyzeFit[QuantityData,Exponential]],
		_?ValidGraphicsQ,
		Stubs :> {
			AnalyzeFit[QuantityData,Exponential] =
			stripAppendReplaceKeyHeads[AnalyzeFit[QuantityData,Exponential,Upload->False]]
		},
		EquivalenceFunction -> RoundMatchQ[12]
	],

	Test["The given data can be a QuantityArray:",
		stripAppendReplaceKeyHeads@AnalyzeFit[QuantityData,Exponential, Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {Second,Meter},
				MinDomain -> {-3.},
				MaxDomain -> {3.},
				ExpressionType -> Exponential,
				BestFitExpression->0.17353902209687178` +E^(1.0279487943734598` (-0.06867780594777119`+x)),
				BestFitVariables -> {x},
				BestFitFunction->QuantityFunction[(0.9318370973505959` (0.18623321886441183` +E^(1.0279487943734598` #1))&),{Second},Meter],
				BestFitParameters->{{_Symbol,0.17353902209687178`,0.12755126617524618`},{_Symbol,1.0279487943734598`,0.0330308304896095`},{_Symbol,0.06867780594777119`,0.0917825371007853`}},
				CovarianceMatrix->{{0.016269325502908497`,0.002754661667453522`,0.008306411511034378`},{0.0027546616674535176`,0.0010910357628333169`,0.002997113422421144`},{0.008306411511034369`,0.002997113422421145`,0.008424034116657028`}},
				HatDiagonal->{0.1442510826636265`,0.1391386443209117`,0.1324068252935273`,0.12381708720907932`,0.11334861551037317`,0.10147088276721555`,0.08957311716413298`,0.08053265260348941`,0.07922583533626597`,0.09236336875807488`,0.12627001928581666`,0.18047411678858177`,0.23667919893215644`,0.257067599411554`,0.2685978184586423`,0.8347831354965503`},
				RSquared->0.9973850641331126`,
				AdjustedRSquared->0.9969827663074375`,
				AIC->13.748700560178591`,
				AICc->17.385064196542228`,
				BIC->16.839055449137717`,
				EstimatedVariance->0.10321470800926999`,
				SumSquaredError->1.3417912041205098`,
				StandardDeviation->0.32127045928511694`
			},
			ResolvedOptions -> {Upload->False,ReferenceField->Null,Exclude->{},Domain->{{-3.`,3.`}},Range->{-0.1217`,20.53`},ExcludeOutliers->False,OutlierDistance->1.5`,PolynomialDegree->1,LogBase->10,StartingValues->{}},
			NullFields -> {ReferenceField, Derivative, Exclude, Outliers, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 4
		]
	],


	Example[{Additional, "Uncertain data","Fitting algorithm takes into account uncertainty in data points:"},
		PlotFit/@{
			AnalyzeFit[UncertainData],
			AnalyzeFit[Map[Mean,UncertainData,{2}]]
		},
		{_?ValidGraphicsQ , _?ValidGraphicsQ},
		Stubs:>{
			AnalyzeFit[UncertainData]=
			stripAppendReplaceKeyHeads[AnalyzeFit[UncertainData,Upload->False]],

			AnalyzeFit[Map[Mean,UncertainData,{2}]]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Map[Mean,UncertainData,{2}],Upload->False]]
		},
		EquivalenceFunction -> RoundMatchQ[12]
	],
	Example[{Additional, "Uncertain data", "Data with y-uncertainty only:"},
		yDistOnly = MapAt[Mean,UncertainData,{;;,1}];
		PlotFit[AnalyzeFit[MapAt[Mean,UncertainData,{;;,1}]],Display->{DataError}],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[yDistOnly] =
			stripAppendReplaceKeyHeads[AnalyzeFit[yDistOnly, Upload->False]]
		}
	],
	Example[{Additional, "Uncertain data", "Data with x-uncertainty only:"},
		xDistOnly = MapAt[Mean,UncertainData,{;;,2}];
		PlotFit[AnalyzeFit[xDistOnly],Display->{DataError}],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[xDistOnly]=
			stripAppendReplaceKeyHeads[AnalyzeFit[xDistOnly,Upload->False]]
		}
	],
	Example[{Additional,"Uncertain data","Fit to numerical distributions mixed with quantities:"},
		PlotFit[AnalyzeFit[{{DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674`, 15.459992338727531`, 16.34041161139497}, False}, 1, 3], Quantity[1.08, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296`, 14.30371964237898}, False}, 1, 3], Quantity[0.84, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662`, 24.637186814801282`, 25.21412493285868}, False}, 1, 3], Quantity[2.4000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978`, 11.845913840759607`}, False}, 1, 3], Quantity[0.48000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], Quantity[10.8, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994`, 55.76507849401303}, False}, 1, 3], Quantity[7.2, "Milliliters"]}},Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674`, 15.459992338727531`, 16.34041161139497}, False}, 1, 3], Quantity[1.08, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296`, 14.30371964237898}, False}, 1, 3], Quantity[0.84, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662`, 24.637186814801282`, 25.21412493285868}, False}, 1, 3], Quantity[2.4000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978`, 11.845913840759607`}, False}, 1, 3], Quantity[0.48000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], Quantity[10.8, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994`, 55.76507849401303}, False}, 1, 3], Quantity[7.2, "Milliliters"]}},Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674`, 15.459992338727531`, 16.34041161139497}, False}, 1, 3], Quantity[1.08, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296`, 14.30371964237898}, False}, 1, 3], Quantity[0.84, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662`, 24.637186814801282`, 25.21412493285868}, False}, 1, 3], Quantity[2.4000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978`, 11.845913840759607`}, False}, 1, 3], Quantity[0.48000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], Quantity[10.8, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994`, 55.76507849401303}, False}, 1, 3], Quantity[7.2, "Milliliters"]}},Linear,Upload->False]]
		}
	],
	Test["Fit to numerical distributions mixed with quantities:",
		PlotFit@AnalyzeFit[{{DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674`, 15.459992338727531`, 16.34041161139497}, False}, 1, 3], Quantity[1.08, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296`, 14.30371964237898}, False}, 1, 3], Quantity[0.84, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662`, 24.637186814801282`, 25.21412493285868}, False}, 1, 3], Quantity[2.4000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978`, 11.845913840759607`}, False}, 1, 3], Quantity[0.48000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], Quantity[10.8, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994`, 55.76507849401303}, False}, 1, 3], Quantity[7.2, "Milliliters"]}},Linear],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674`, 15.459992338727531`, 16.34041161139497}, False}, 1, 3], Quantity[1.08, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296`, 14.30371964237898}, False}, 1, 3], Quantity[0.84, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662`, 24.637186814801282`, 25.21412493285868}, False}, 1, 3], Quantity[2.4000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978`, 11.845913840759607`}, False}, 1, 3], Quantity[0.48000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], Quantity[10.8, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994`, 55.76507849401303}, False}, 1, 3], Quantity[7.2, "Milliliters"]}},Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674`, 15.459992338727531`, 16.34041161139497}, False}, 1, 3], Quantity[1.08, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296`, 14.30371964237898}, False}, 1, 3], Quantity[0.84, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662`, 24.637186814801282`, 25.21412493285868}, False}, 1, 3], Quantity[2.4000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978`, 11.845913840759607`}, False}, 1, 3], Quantity[0.48000000000000004`, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], Quantity[10.8, "Milliliters"]}, {DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994`, 55.76507849401303}, False}, 1, 3], Quantity[7.2, "Milliliters"]}},Linear,Upload->False]]
		},
		EquivalenceFunction -> RoundMatchQ[12]
	],
	Example[{Additional,"Uncertain data","Fit to quantity distributions mixed with quantities:"},
		PlotFit[AnalyzeFit[{{QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674, 15.459992338727531, 16.34041161139497}, False}, 1, 3], "Seconds"], Quantity[1.08, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296, 14.30371964237898}, False}, 1, 3], "Seconds"], Quantity[0.84, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662, 24.637186814801282, 25.21412493285868}, False}, 1, 3], "Seconds"], Quantity[2.4000000000000004, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978, 11.845913840759607}, False}, 1, 3], "Seconds"], Quantity[0.48000000000000004, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], "Seconds"], Quantity[10.8, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994, 55.76507849401303}, False}, 1, 3], "Seconds"], Quantity[7.2, "Milliliters"]}},Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674, 15.459992338727531, 16.34041161139497}, False}, 1, 3], "Seconds"], Quantity[1.08, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296, 14.30371964237898}, False}, 1, 3], "Seconds"], Quantity[0.84, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662, 24.637186814801282, 25.21412493285868}, False}, 1, 3], "Seconds"], Quantity[2.4000000000000004, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978, 11.845913840759607}, False}, 1, 3], "Seconds"], Quantity[0.48000000000000004, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], "Seconds"], Quantity[10.8, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994, 55.76507849401303}, False}, 1, 3], "Seconds"], Quantity[7.2, "Milliliters"]}},Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674, 15.459992338727531, 16.34041161139497}, False}, 1, 3], "Seconds"], Quantity[1.08, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296, 14.30371964237898}, False}, 1, 3], "Seconds"], Quantity[0.84, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662, 24.637186814801282, 25.21412493285868}, False}, 1, 3], "Seconds"], Quantity[2.4000000000000004, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978, 11.845913840759607}, False}, 1, 3], "Seconds"], Quantity[0.48000000000000004, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], "Seconds"], Quantity[10.8, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994, 55.76507849401303}, False}, 1, 3], "Seconds"], Quantity[7.2, "Milliliters"]}},Linear,Upload->False]]
		}
	],
	Test["Fit to quantity distributions mixed with quantities:",
		BestFitFunction/.AnalyzeFit[{{QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {13.840501929305674, 15.459992338727531, 16.34041161139497}, False}, 1, 3], "Seconds"], Quantity[1.08, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {12.55442125540921, 13.615602912635296, 14.30371964237898}, False}, 1, 3], "Seconds"], Quantity[0.84, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {23.121800815774662, 24.637186814801282, 25.21412493285868}, False}, 1, 3], "Seconds"], Quantity[2.4000000000000004, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {9.929771793878473, 11.275657897367978, 11.845913840759607}, False}, 1, 3], "Seconds"], Quantity[0.48000000000000004, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {77.81512893663026, 78.40089885644896, 78.93598198404977}, False}, 1, 3], "Seconds"], Quantity[10.8, "Milliliters"]}, {QuantityDistribution[DataDistribution["Empirical", {{0.3333333333333333, 0.3333333333333333, 0.3333333333333333}, {54.1943667574766, 55.684191696400994, 55.76507849401303}, False}, 1, 3], "Seconds"], Quantity[7.2, "Milliliters"]}},Linear,Upload->False],
		QuantityFunction[-1.2550858502460742 + 0.15345962590183457*#1 & , {Quantity[1, "Seconds"]}, Quantity[1, "Milliliters"]],
		EquivalenceFunction -> RoundMatchQ[12]
	],




	Example[{Additional,"Object inputs","Fit a standard curve to fluorescence kinetics data:"},
		PlotFit[AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:4pO6dMWv6vKo"],Quantity[50,"Nanomolar"]}},Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:4pO6dMWv6vKo"],Quantity[50,"Nanomolar"]}},Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:4pO6dMWv6vKo"],Quantity[50,"Nanomolar"]}},Linear, Upload->False]]
		}
	],
	Test["Fit a standard curve to fluorescence kinetics data:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:4pO6dMWv6vKo"],Quantity[50,"Nanomolar"]}},Linear,Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {RFU,Nanomolar},
				ExpressionType -> Linear,
				BestFitExpression -> -6.751495587961278`+ 0.0002501058394122681` x,
				IndependentVariableData->{{Link[Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:4pO6dMWv6vKo"]],EmissionTrajectories,_Function}}
			},
			NullFields->{DependentVariableData,SecondaryIndependentVariableData,TertiaryIndependentVariableData},
			Round -> 12
		]
	],


	Example[{Additional,"Object inputs","Fit a standard curve to fluorescence intensities data:"},
		PlotFit[AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Quantity[28,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[45,"Nanomolar"]}},Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Quantity[28,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[45,"Nanomolar"]}},Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Quantity[28,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[45,"Nanomolar"]}},Linear,Upload->False]]
		}
	],
	Test["Fit a standard curve to fluorescence Intensities data:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],5Nanomolar},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[50,"Nanomolar"]}},Linear,Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {RFU,Nanomolar},
				ExpressionType -> Linear,
				BestFitExpression -> -334.52766037657824`+ 0.05737132447076863` x,
				IndependentVariableData->{{Link[Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"]],Intensities,_Function}}
			},
			NullFields->{DependentVariableData,SecondaryIndependentVariableData,TertiaryIndependentVariableData},
			ResolvedOptions -> {},
			Round -> 12
		]
	],

	(* temporarily broken because QPCR objects are changing *)
	(*Example[{Additional,"Object inputs","Fit a LinearLog standard curve relating copy number to quantification cycle:"},*)
		(*PlotFit[AnalyzeFit[{{Object[Data, qPCR, "id:3em6Zv9N6BdL"],100000},{Object[Data, qPCR, "id:O81aEB4kaKdj"],10000},{Object[Data, qPCR, "id:E8zoYveRoBPA"],1000},{Object[Data, qPCR, "id:kEJ9mqaV9NY3"],100},{Object[Data, qPCR, "id:aXRlGnZmlWq0"],10}},LinearLog],Display->{}],*)
		(*ValidGraphicsP[],*)
		(*Stubs:>{*)
			(*AnalyzeFit[{{Object[Data, qPCR, "id:3em6Zv9N6BdL"],100000},{Object[Data, qPCR, "id:O81aEB4kaKdj"],10000},{Object[Data, qPCR, "id:E8zoYveRoBPA"],1000},{Object[Data, qPCR, "id:kEJ9mqaV9NY3"],100},{Object[Data, qPCR, "id:aXRlGnZmlWq0"],10}},LinearLog]=*)
			(*stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, qPCR, "id:3em6Zv9N6BdL"],100000},{Object[Data, qPCR, "id:O81aEB4kaKdj"],10000},{Object[Data, qPCR, "id:E8zoYveRoBPA"],1000},{Object[Data, qPCR, "id:kEJ9mqaV9NY3"],100},{Object[Data, qPCR, "id:aXRlGnZmlWq0"],10}},LinearLog,Upload->False]]*)
		(*}*)
	(*],*)
	(*Test["Fit a LinearLog standard curve relating copy number to quantification cycle:",*)
		(*stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, qPCR, "id:3em6Zv9N6BdL"],100000},{Object[Data, qPCR, "id:O81aEB4kaKdj"],10000},{Object[Data, qPCR, "id:E8zoYveRoBPA"],1000},{Object[Data, qPCR, "id:kEJ9mqaV9NY3"],100},{Object[Data, qPCR, "id:aXRlGnZmlWq0"],10}},LinearLog,Upload->False],*)
		(*Analysis`Private`validAnalysisPacketP[Object[Analysis, Fit],*)
			(*{*)
				(*DataUnits -> {Cycle,1},*)
				(*ExpressionType -> LinearLog,*)
				(*BestFitExpression -> 10^(5.195162977402761 - 0.19948259286359185*x),*)
				(*IndependentVariableData->{{Link[Object[Data, qPCR, "id:3em6Zv9N6BdL"]],QuantificationCycle,Identity},{Link[Object[Data, qPCR, "id:O81aEB4kaKdj"]],QuantificationCycle,Identity},{Link[Object[Data, qPCR, "id:E8zoYveRoBPA"]],QuantificationCycle,Identity},{Link[Object[Data, qPCR, "id:kEJ9mqaV9NY3"]],QuantificationCycle,Identity},{Link[Object[Data, qPCR, "id:aXRlGnZmlWq0"]],QuantificationCycle,Identity}}*)
			(*},*)
			(*NullFields->{DependentVariableData,SecondaryIndependentVariableData,TertiaryIndependentVariableData},*)
			(*ResolvedOptions -> {},*)
			(*Round -> 12*)
		(*]*)
	(*],*)

	Example[{Additional,"Object inputs","Fit a LogLinear standard curve relating copy number to quantification cycle:"},
		PlotFit[AnalyzeFit[{{100000,Object[Analysis, QuantificationCycle, "id:4pO6dMWvYnN8"]},{10000,Object[Analysis, QuantificationCycle, "id:M8n3rxYEk4bR"]},{1000,Object[Analysis, QuantificationCycle, "id:J8AY5jwzLdRB"]},{100,Object[Analysis, QuantificationCycle, "id:R8e1PjRDwb6a"]},{10,Object[Analysis, QuantificationCycle, "id:vXl9j5qEAn8Z"]}},LogLinear],Display->{},PlotType->LogLinear],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{100000,Object[Analysis, QuantificationCycle, "id:4pO6dMWvYnN8"]},{10000,Object[Analysis, QuantificationCycle, "id:M8n3rxYEk4bR"]},{1000,Object[Analysis, QuantificationCycle, "id:J8AY5jwzLdRB"]},{100,Object[Analysis, QuantificationCycle, "id:R8e1PjRDwb6a"]},{10,Object[Analysis, QuantificationCycle, "id:vXl9j5qEAn8Z"]}},LogLinear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{100000,Object[Analysis, QuantificationCycle, "id:4pO6dMWvYnN8"]},{10000,Object[Analysis, QuantificationCycle, "id:M8n3rxYEk4bR"]},{1000,Object[Analysis, QuantificationCycle, "id:J8AY5jwzLdRB"]},{100,Object[Analysis, QuantificationCycle, "id:R8e1PjRDwb6a"]},{10,Object[Analysis, QuantificationCycle, "id:vXl9j5qEAn8Z"]}},LogLinear,Upload->False]]
		}
	],
	Test["Fit a LinearLog standard curve relating copy number to quantification cycle:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{100000,Object[Analysis, QuantificationCycle, "id:4pO6dMWvYnN8"]},{10000,Object[Analysis, QuantificationCycle, "id:M8n3rxYEk4bR"]},{1000,Object[Analysis, QuantificationCycle, "id:J8AY5jwzLdRB"]},{100,Object[Analysis, QuantificationCycle, "id:R8e1PjRDwb6a"]},{10,Object[Analysis, QuantificationCycle, "id:vXl9j5qEAn8Z"]}},LogLinear,Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {1,Cycle},
				ExpressionType -> LogLinear,
				BestFitExpression -> 25.380130693843704` -2.1164735704132482` Log[x],
				DependentVariableData->{{Link[Object[Analysis, QuantificationCycle, "id:4pO6dMWvYnN8"]],QuantificationCycle,Identity},{Link[Object[Analysis, QuantificationCycle, "id:M8n3rxYEk4bR"]],QuantificationCycle,Identity},{Link[Object[Analysis, QuantificationCycle, "id:J8AY5jwzLdRB"]],QuantificationCycle,Identity},{Link[Object[Analysis, QuantificationCycle, "id:R8e1PjRDwb6a"]],QuantificationCycle,Identity},{Link[Object[Analysis, QuantificationCycle, "id:vXl9j5qEAn8Z"]],QuantificationCycle,Identity}}
			},
			NullFields->{IndependentVariableData,SecondaryIndependentVariableData,TertiaryIndependentVariableData},
			ResolvedOptions -> {},
			Round -> 12
		]
	],


	Example[{Additional,"Object inputs","Fit a standard curve relating peak position to fragment size by pulling all x-values from first object and all y-values from second object:"},
		PlotFit[AnalyzeFit[{Object[Analysis, Peaks, "id:lYq9jRzXle9Y"],
			Model[Sample, StockSolution, Standard, "id:1ZA60vLraxRM"]},
			Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{Object[Analysis, Peaks, "id:lYq9jRzXle9Y"],Model[Sample,StockSolution,Standard,"id:1ZA60vLraxRM"]},Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{Object[Analysis, Peaks, "id:lYq9jRzXle9Y"],Model[Sample,StockSolution,Standard,"id:1ZA60vLraxRM"]},Linear,Upload->False]]
		}
	],

	Example[{Additional,"Object inputs","Pull peak positions from object and specify sizes:"},
		PlotFit[AnalyzeFit[{Object[Analysis, Peaks, "id:vXl9j5qErJak"],{10,15,20,25,30,35,40,45,50,60,70,80}},Exponential]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{Object[Analysis, Peaks, "id:vXl9j5qErJak"],{10,15,20,25,30,35,40,45,50,60,70,80}},Exponential]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{Object[Analysis, Peaks, "id:vXl9j5qErJak"],{10,15,20,25,30,35,40,45,50,60,70,80}},Exponential,Upload->False]]
		}
	],
	Test["Pull peak positions from object and specify sizes:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{Object[Analysis, Peaks, "id:vXl9j5qErJak"],Nucleotide*{10,15,20,25,30,35,40,45,50,60,70,80}},Exponential,Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {1,Nucleotide},
				ExpressionType -> Exponential,
				BestFitExpression -> 10.356220367238992 + E^(0.1385278707831012*(-9.977473328846939 + x)),
				IndependentVariableData->{{Link[Object[Analysis, Peaks, "id:vXl9j5qErJak"]],Position,Identity}}
			},
			NullFields->{DependentVariableData,SecondaryIndependentVariableData,TertiaryIndependentVariableData},
			Round -> 3
		]
	],

	Example[{Additional,"Object inputs","Pull sizes from object and specify positions:"},
		PlotFit[AnalyzeFit[{{11.91`,13.09`,14.36`,15.91`,17.73`},Model[Sample,StockSolution,Standard,"id:1ZA60vLraxRM"]}]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{11.91`,13.09`,14.36`,15.91`,17.73`},Model[Sample,StockSolution,Standard,"id:1ZA60vLraxRM"]}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{11.91`,13.09`,14.36`,15.91`,17.73`},Model[Sample,StockSolution,Standard,"id:1ZA60vLraxRM"]},Upload->False]]
		}
	],



	Example[{Additional, "Object inputs",	"Fit Volume vs LiquidLevel using ObjectFields to address multiple fields in the same objects:"},
		PlotFit[AnalyzeFit[{{Object[Data, Volume, "id:KBL5DvYlevWx",LiquidLevel],	Object[Data, Volume, "id:KBL5DvYlevWx"]}, {Object[Data, Volume,	"id:jLq9jXY46X7w", LiquidLevel],Object[Data, Volume, "id:jLq9jXY46X7w"]}, {Object[Data, Volume,"id:7X104vK9lvMd", LiquidLevel],Object[Data, Volume, "id:7X104vK9lvMd"]}, {Object[Data, Volume,	"id:N80DNjlYVjWN", LiquidLevel],Object[Data, Volume, "id:N80DNjlYVjWN"]}, {Object[Data, Volume,	"id:vXl9j5qE65RD", LiquidLevel],Object[Data, Volume, "id:vXl9j5qE65RD"]}}, Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{Object[Data, Volume, "id:KBL5DvYlevWx",LiquidLevel],	Object[Data, Volume, "id:KBL5DvYlevWx"]}, {Object[Data, Volume,	"id:jLq9jXY46X7w", LiquidLevel],Object[Data, Volume, "id:jLq9jXY46X7w"]}, {Object[Data, Volume,"id:7X104vK9lvMd", LiquidLevel],Object[Data, Volume, "id:7X104vK9lvMd"]}, {Object[Data, Volume,	"id:N80DNjlYVjWN", LiquidLevel],Object[Data, Volume, "id:N80DNjlYVjWN"]}, {Object[Data, Volume,	"id:vXl9j5qE65RD", LiquidLevel],Object[Data, Volume, "id:vXl9j5qE65RD"]}}, Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, Volume, "id:KBL5DvYlevWx",LiquidLevel],	Object[Data, Volume, "id:KBL5DvYlevWx"]}, {Object[Data, Volume,	"id:jLq9jXY46X7w", LiquidLevel],Object[Data, Volume, "id:jLq9jXY46X7w"]}, {Object[Data, Volume,"id:7X104vK9lvMd", LiquidLevel],Object[Data, Volume, "id:7X104vK9lvMd"]}, {Object[Data, Volume,	"id:N80DNjlYVjWN", LiquidLevel],Object[Data, Volume, "id:N80DNjlYVjWN"]}, {Object[Data, Volume,	"id:vXl9j5qE65RD", LiquidLevel],Object[Data, Volume, "id:vXl9j5qE65RD"]}}, Linear,Upload -> False]]
		}
	],
	Test["Fit Volume vs LiquidLevel using ObjectFields to address multiple fields in the same objects:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data,Volume,"id:KBL5DvYlevWx",LiquidLevel],Object[Data, Volume, "id:KBL5DvYlevWx"]},{Object[Data,Volume,"id:jLq9jXY46X7w",LiquidLevel],Object[Data, Volume, "id:jLq9jXY46X7w"]},{Object[Data,Volume,"id:7X104vK9lvMd",LiquidLevel],Object[Data, Volume, "id:7X104vK9lvMd"]},{Object[Data,Volume,"id:N80DNjlYVjWN",LiquidLevel],Object[Data, Volume, "id:N80DNjlYVjWN"]},{Object[Data,Volume,"id:vXl9j5qE65RD",LiquidLevel],Object[Data, Volume, "id:vXl9j5qE65RD"]}},Linear,Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {Millimeter,Microliter},
				ExpressionType -> Linear,
				BestFitExpression -> 2991.0885989438075` -59.04669515852866` x,
				DependentVariableData->{{Link[Object[Data, Volume, "id:KBL5DvYlevWx"]], Volume, Identity}, {Link[Object[Data, Volume, "id:jLq9jXY46X7w"]], Volume, Identity}, {Link[Object[Data, Volume, "id:7X104vK9lvMd"]], Volume, Identity}, {Link[Object[Data, Volume, "id:N80DNjlYVjWN"]], Volume, Identity}, {Link[Object[Data, Volume, "id:vXl9j5qE65RD"]], Volume, Identity}},
				IndependentVariableData->{{Link[Object[Data, Volume, "id:KBL5DvYlevWx"]], LiquidLevel, Identity}, {Link[Object[Data, Volume, "id:jLq9jXY46X7w"]], LiquidLevel, Identity}, {Link[Object[Data, Volume, "id:7X104vK9lvMd"]], LiquidLevel, Identity}, {Link[Object[Data, Volume, "id:N80DNjlYVjWN"]], LiquidLevel, Identity}, {Link[Object[Data, Volume, "id:vXl9j5qE65RD"]], LiquidLevel, Identity}}
			},
			NullFields->{SecondaryIndependentVariableData,TertiaryIndependentVariableData},
			Round -> 10
		]
	],

	Example[{Additional,"Object inputs","One data point per object:"},
		PlotFit[AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"]}},Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"]}},Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"]}},Linear,Upload->False]]
		}
	],
	Test["One data point per object:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"]}},Linear,Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {RFU,RFU},
				ExpressionType -> Linear,
				BestFitExpression -> 5814.331294472963` +0.004933839414243557` x,
				DependentVariableData->{{Link[Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"]],Intensities,_Function}},
				IndependentVariableData->{{Link[Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"]],EmissionTrajectories,_Function}}
			},
			NullFields->{SecondaryIndependentVariableData,TertiaryIndependentVariableData},
			Round -> 12
		]
	],


	Example[{Additional,"Object inputs","Fit function of two variables to fluorescence objects:"},
		PlotFit[AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"], Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[40,"Nanomolar"]}},Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"], Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[40,"Nanomolar"]}},Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"], Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[40,"Nanomolar"]}},Linear,Upload->False]]
		}
	],
	Test["Fit function of two variables to fluorescence objects:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"], Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[40,"Nanomolar"]}},Linear,Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				DataUnits -> {RFU,RFU,Nanomolar},
				ExpressionType -> Linear,
				BestFitExpression -> -28.31001713815705`+ 0.00024524744307723536` x1+0.003528728132641374` x2,
				IndependentVariableData->{{Link[Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"]],EmissionTrajectories,_Function}},
				SecondaryIndependentVariableData->{{Link[Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"]],Intensities,_Function}}
			},
			NullFields->{DependentVariableData,TertiaryIndependentVariableData},
			Round -> 12
		]
	],

	Example[{Additional,"Object inputs","Fit function of two variables to peak positions:"},
		PlotFit[AnalyzeFit[{Object[Analysis, Peaks, "id:lYq9jRzXle9Y"], {1, 1,
			2, 2, 3},
			Model[Sample, StockSolution, Standard, "id:1ZA60vLraxRM"]},
			Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{Object[Analysis, Peaks, "id:lYq9jRzXle9Y"], {1, 1,
				2, 2, 3},
				Model[Sample, StockSolution, Standard, "id:1ZA60vLraxRM"]},
				Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{Object[Analysis, Peaks, "id:lYq9jRzXle9Y"], {1, 1,
				2, 2, 3},
				Model[Sample, StockSolution, Standard, "id:1ZA60vLraxRM"]},
				Linear,Upload->False]]
		}
	],



	Example[{Additional, "Fit Type", "Fit a gaussian:"},
		PlotFit[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[2+3*Exp[-(x-1)^2/1.5],.2]]},{x,-3,4,0.1}], Gaussian]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[2+3*Exp[-(x-1)^2/1.5],.2]]},{x,-3,4,0.1}], Gaussian]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[2+3*Exp[-(x-1)^2/1.5],.2]]},{x,-3,4,0.1}], Gaussian, Upload -> False]]
		}
	],
	Example[{Additional, "Fit Type", "Fit a linear function:"},
		PlotFit[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[3-2x,.7]]},{x,-3,4,0.1}], Linear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[3-2x,.7]]},{x,-3,4,0.1}], Linear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[3-2x,.7]]},{x,-3,4,0.1}], Linear, Upload -> False]]
		}
	],
	Example[{Additional, "Fit Type", "Fit a cubic polynomial:"},
		PlotFit[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[3-2x+.5*x^2-0.75*x^3,3]]},{x,-3,4,0.1}], Polynomial,PolynomialDegree->3]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[3-2x+.5*x^2-0.75*x^3,3]]},{x,-3,4,0.1}], Polynomial,PolynomialDegree->3]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[3-2x+.5*x^2-0.75*x^3,3]]},{x,-3,4,0.1}], Polynomial,PolynomialDegree->3, Upload -> False]]
		}
	],
	Example[{Additional, "Fit Type", "Fit a log-linear expression a+b*Log[x]:"},
		PlotFit[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[1+2Log[3*x],.25]]},{x,1,10,0.1}], LogLinear]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[1+2Log[3*x],.25]]},{x,1,10,0.1}], LogLinear]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[1+2Log[3*x],.25]]},{x,1,10,0.1}], LogLinear, Upload -> False]]
		}
	],
	Example[{Additional, "Fit Type", "Fit a linear-log expression 10^(a+b*x):"},
		PlotFit[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[10^(.1x-0.25),.1]]},{x,2,9,0.1}], LinearLog]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[10^(.1x-0.25),.1]]},{x,2,9,0.1}], LinearLog]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[10^(.1x-0.25),.1]]},{x,2,9,0.1}], LinearLog, Upload -> False]]
		}
	],
	Example[{Additional, "Fit Type", "Fit a log-log expression 10^(a+b*Log[x]):"},
		PlotFit[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[10^(-3+0.8*Log[2*x]),.007]]},{x,3,10,0.1}], Log]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[10^(-3+0.8*Log[2*x]),.007]]},{x,3,10,0.1}], Log]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[10^(-3+0.8*Log[2*x]),.007]]},{x,3,10,0.1}], Log, Upload -> False]]
		}
	],
	Example[{Additional, "Fit Type", "Fit logistic function sigmoid:"},
		PlotFit[AnalyzeFit[LogisticSigmoidData, Logistic]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LogisticSigmoidData, Logistic]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LogisticSigmoidData, Logistic, Upload -> False]]
		}
	],
	Example[{Additional, "Fit Type", "Fit error function sigmoid:"},
		PlotFit[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[2 + 1.4 * Erf[.6*x -1.5],.08]]},{x,-2,5,0.1}], Erf]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[2 + 1.4 * Erf[.6*x -1.5],.08]]},{x,-2,5,0.1}], Erf]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,RandomVariate[NormalDistribution[2 + 1.4 * Erf[.6*x -1.5],.08]]},{x,-2,5,0.1}], Erf, Upload -> False]]
		}
	],


	Example[{Additional,"Fit Type","Assumes linear fit if no expression given:"},
		BestFitFunction/.AnalyzeFit[{{1,2},{3,4},{5,6},{7,8}}],
		0.9999999999999998 + 0.9999999999999999*#1 &,
		Stubs:>{
			AnalyzeFit[{{1,2},{3,4},{5,6},{7,8}}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{1,2},{3,4},{5,6},{7,8}},Upload->False]]
		},
		EquivalenceFunction -> RoundMatchQ[10]
	],
	Test["Assumes linear fit if no expression given:",
		stripAppendReplaceKeyHeads[AnalyzeFit[{{1,2},{3,4},{5,6},{7,8}},Upload->False]][ExpressionType],
		(Linear | _Linear)
	],

	(* --------------------- MESSAGES --------------------*)
	Example[{Messages,"DataSizeMismatch","Size of x and y data lists must match:"},
		AnalyzeFit[{{7.85,11.52,13.58,14.66},Model[Sample,StockSolution,Standard,"id:1ZA60vLraxRM"]},Upload->False],
		$Failed,
		Messages:>{AnalyzeFit::DataSizeMismatch}
	],
	Example[{Messages,"OverFit","Overfitting message thrown when you have fewer data points than parameters in the fitted function:"},
		BestFitFunction/.AnalyzeFit[{{1,2}},Polynomial,Upload->False],
		0.9999999999999996 + 0.9999999999999999*#1 &,
		Messages:>{AnalyzeFit::OverFit},
		EquivalenceFunction -> RoundMatchQ[12]
	],

	Example[{Messages,"NonPositiveValues","Negative x values will be excluded when fitting to a log function:"},
		PlotFit[AnalyzeFit[ExponentialData,Log]],
		ValidGraphicsP[],
		Messages:>{AnalyzeFit::NonPositiveValues}
	],

	Example[{Messages,"InvalidExpressionType","Given unknown expression type:"},
		AnalyzeFit[ExponentialData,Circle],
		$Failed,
		Stubs:>{
			AnalyzeFit[ExponentialData,Circle]=
			stripAppendReplaceKeyHeads[AnalyzeFit[ExponentialData,Circle, Upload->False]]
		},
		Messages:>{Error::InvalidInput}
	],
	Example[{Messages,"InvalidExpressionType","Given known expression type with incompatible data:"},
		AnalyzeFit[LinearData4D,Sigmoid],
		$Failed,
		Messages:>{AnalyzeFit::InvalidExpressionType}
	],

	Example[{Messages,"NoUnknownParameter","There must be unknown parameters in the expression in order to fit:"},
		AnalyzeFit[LinearData,2*# + 5&],
		$Failed,
		Messages:>{AnalyzeFit::NoUnknownParameter}
	],

	Example[{Messages,"TooManyOutliers","If too many of the points are excluded as outliers, the resulting fit should not be trusted:"},
		AnalyzeFit[{{-3,1},{-2,2},{-1,-1},{-1,-0.5},{0,0},{1,0.5},{1,1},{2,-2},{3,-1}},Polynomial,OutlierDistance->.01,ExcludeOutliers->Repeatedly],
		_,
		Messages:>{AnalyzeFit::TooManyOutliers}
	],
	Example[{Messages,"InvalidDomain","In the Domain option, the left boundary should be less than the right boundary:"},
		AnalyzeFit[LinearData,2*# + 5&, Domain->{2,1}],
		$Failed,
		Messages:>{AnalyzeFit::InvalidDomain, Error::InvalidOption}
	],

	Example[{Messages,"NoValidData","Cannot fit if all data points are filtered out by option restrictions:"},
		AnalyzeFit[LinearData,2*# + 5&, Domain->{100,200}],
		$Failed,
		Messages:>{AnalyzeFit::NoValidData}
	],
	Example[{Messages,"InvalidPolynomialDegree","Polynomial degree must not exceed number of data points:"},
		AnalyzeFit[LinearData,Polynomial,PolynomialDegree->20,Upload->False],
		$Failed,
		Messages:>{AnalyzeFit::InvalidPolynomialDegree, Error::InvalidOption}
	],


	Example[{Messages,"InvalidFitField","FitField option must be a field in the input objects:"},
		AnalyzeFit[{Object[Analysis, Peaks, "id:N80DNjlYOpzA"],Range[14]}, Linear, Upload -> False,FitField -> MeltingPoint],
		$Failed,
		Messages:>{AnalyzeFit::InvalidFitField, Error::InvalidOption}
	],


	Test["If too many of the points are excluded as outliers, the reuslting fit should not be trusted:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{-3,1},{-2,2},{-1,-1},{-1,-0.5},{0,0},{1,0.5},{1,1},{2,-2},{3,-1}},Polynomial,OutlierDistance->.01,ExcludeOutliers->Repeatedly,Upload->False],
		Analysis`Private`validAnalysisPacketP[Object[Analysis, Fit],
			{
			},
			ResolvedOptions -> {OutlierDistance->0.01`,ExcludeOutliers->Repeatedly,Upload->False,ReferenceField->Null,Exclude->{},Domain->{{-3,3}},Range->{-2,2},PolynomialDegree->1,StartingValues->{}},
			NullFields -> {ReferenceField, Derivative, Outliers, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 5
		],
		Messages:>{AnalyzeFit::TooManyOutliers}
	],



	Example[{Messages,"FitFieldResolutionFailure","Not every object has fields that can be fit to:"},
		AnalyzeFit[{Model[Sample,StockSolution,Standard,"id:D8KAEvGx9jBO"],Object[Analysis, Fit, "id:lYq9jRzXdR9X"]},Upload->False],
		$Failed,
		Messages:>{AnalyzeFit::FitFieldResolutionFailure, Error::InvalidOption}
	],

	Example[{Messages,"InvalidFunction","Pure function input must contain symbolic parameters only:"},
		AnalyzeFit[ExponentialData,#1 x+"string"&],
		$Failed,
		Messages:>{AnalyzeFit::InvalidFunction}
	],
	Example[{Messages,"InputDataSizeMismatch","Number of variables in function must match dimenions of input data:"},
		AnalyzeFit[ExponentialData,#1 x+#2&],
		$Failed,
		Messages:>{AnalyzeFit::InputDataSizeMismatch}
	],
	Example[{Messages,"CannotFit","Unable to find a satisfactory fit to the data:"},
		AnalyzeFit[{{-2, 1/100}, {-1, 1/10}, {0, 1}, {1, 10}},Function[x,a*Log[Sqrt[x]]+b],Upload->False],
		$Failed,
		Messages:>{AnalyzeFit::CannotFit}
	],
	Example[{Messages,"ImaginaryFitParameters","Unable to find a real valued set of parameters:"},
		AnalyzeFit[{{-5, 1/100000}, {-4, 1/10000}, {-3, 1/1000}, {-2, 1/100}},Function[x,a*Log[Sqrt[x]]+b],Upload->False],
		$Failed,
		Messages:>{AnalyzeFit::ImaginaryFitParameters}
	],
	Example[{Messages,"MachinePrecisionIssue","The fit function results in numbers that are either too large or too small:"},
		AnalyzeFit[{{1, 10}, {2, 100}, {3, 1000}, {4, 10000}, {5, 100000}},Logistic,Upload->False],
		$Failed,
		Messages:>{AnalyzeFit::MachinePrecisionIssue}
	],
	Example[{Messages,"MachinePrecisionIssue","The input data results in numbers that are either too large or too small:"},
		AnalyzeFit[{{1,1},{1000,100},{-1,100},{10^100,100}},Logistic,Upload->False],
		$Failed,
		Messages:>{AnalyzeFit::MachinePrecisionIssue}
	],
	Example[{Messages,"ZeroInterceptIgnored","The ZeroIntercept option can only be set to True if the fit type is Linear:"},
		AnalyzeFit[{{0,2},{1,4},{2,4.2},{3,5.5},{4,8.0}}, Polynomial, PolynomialDegree->2, ZeroIntercept->True],
		ObjectP[Object[Analysis,Fit]],
		Messages:>{AnalyzeFit::ZeroInterceptIgnored}
	],
	Example[{Messages,"InputContainsTemporalLinks","Warn the user if any of the inputs contain temporal links:"},
		PlotFit[
			AnalyzeFit[{
					{
						Link[Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],DateObject["Now"]],
						Object[Data,FluorescenceIntensity,"id:pZx9jonGJOr5"]
					},
					{
						Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],
    				Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"]
					},
					{
						Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],
    				Link[Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],DateObject["Now"]]
					}
				},
				Linear,
  			Upload -> False
			]
		],
		ValidGraphicsP[],
		Messages :> {Warning::InputContainsTemporalLinks}
	],

	(* --------------------- OPTIONS --------------------*)
	Example[{Options, StartingValues, "Specify initial guesses for some of the parameter values:"},
		PlotFit@AnalyzeFit[Table[{x,10+1000*Sin[x]}, {x,0,5,0.1}], Function[x,b+ a*Sin[c*x]],StartingValues -> {a -> 500, b->5}],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Table[{x,10+1000*Sin[x]}, {x,0,5,0.1}], Function[x,b+ a*Sin[c*x]],StartingValues -> {a -> 500, b->5}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,10+1000*Sin[x]}, {x,0,5,0.1}], Function[x,b+ a*Sin[c*x]],StartingValues -> {a -> 500, b->5},Upload -> False]]
		}
	],
	Example[{Options, StartingValues, "Some problems require good starting values in order to obatin a good fit:"},
		Grid[{{
			PlotFit[AnalyzeFit[Table[{x,10+1000 Sin[x]},{x,0,5,0.1`}],Function[x,b+a Sin[c x]],StartingValues->{a->500,b->5}],PlotLabel->"Specify starting values for parameters"],
			PlotFit[AnalyzeFit[Table[{x,10+1000 Sin[x]},{x,0,5,0.1`}],Function[x,b+a Sin[c x]]],PlotLabel->"Default starting values"]
		}}],
		Grid[{{ValidGraphicsP[],ValidGraphicsP[]}}],
		Stubs:>{
			AnalyzeFit[Table[{x,10+1000 Sin[x]},{x,0,5,0.1`}],Function[x,b+a Sin[c x]],StartingValues->{a->500,b->5}]=
			Quiet[stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,10+1000 Sin[x]},{x,0,5,0.1`}],Function[x,b+a Sin[c x]],Upload->False,StartingValues->{a->500,b->5}]]],
			AnalyzeFit[Table[{x,10+1000 Sin[x]},{x,0,5,0.1`}],Function[x,b+a Sin[c x]]]=
			Quiet[stripAppendReplaceKeyHeads[AnalyzeFit[Table[{x,10+1000 Sin[x]},{x,0,5,0.1`}],Function[x,b+a Sin[c x]],Upload->False]]]
		}
	],
	(*Test["Specify initial guesses for parameter values:",
		stripAppendReplaceKeyHeads@AnalyzeFit[Table[{x,10+1000*Sin[x]}, {x,0,5,0.1}], Function[x,b+ a*Sin[c*x]],StartingValues -> {a -> 1000, b->10, c-> 0.5},Upload -> False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				ExpressionType -> Other,
				BestFitExpression -> 10.` +1000.` Sin[1.` x],
				BestFitVariables -> {x},
				BestFitFunction -> (10.` +1000.` Sin[1.` #1]&)
			},
			Round -> 12
		]
	],*)

	Example[{Options,PolynomialDegree,"Fit a third degree polynomial to data:"},
		PlotFit[AnalyzeFit[LinearData,Polynomial,PolynomialDegree->3]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LinearData,Polynomial,PolynomialDegree->3]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData,Polynomial,PolynomialDegree->3, Upload->False]]
		},
		EquivalenceFunction -> RoundMatchQ[12]
	],
	Test["Fit a third degree polynomial to data:",
		stripAppendReplaceKeyHeads@AnalyzeFit[LinearData,Polynomial,PolynomialDegree->3, Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				ExpressionType -> Polynomial,
				BestFitExpression->0.8037641369047649` +2.251305458392871` x+0.024242165616246033` x^2-0.047686918264269365` x^3,
				CovarianceMatrix->{{0.046364846893991`,-8.328849910654659`*^-18,-0.007615776428053713`,1.224209854206349`*^-18},{-8.328849910654659`*^-18,0.03869876857599909`,1.78320623385294`*^-18,-0.005367579719012742`},{-0.007615776428053713`,1.7832062338529397`*^-18,0.002239934243545209`,-2.5866485769562983`*^-19},{1.224209854206349`*^-18,-0.005367579719012741`,-2.586648576956298`*^-19,0.0008816655254620139`}},
				SumSquaredError->3.9304717514128082`
			},
			ResolvedOptions -> {PolynomialDegree->3},
			NullFields -> {ReferenceField, Derivative, Exclude, Outliers, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 12
		]
	],

	Example[{Options,ReferenceField,"Specify reference field:"},
		AnalyzeFit[{Object[Analysis, Peaks, "id:N80DNjlYOpzA"],
			Range[14]}, Linear, ReferenceField -> Position],
		PacketP[],
		Stubs:>{
			AnalyzeFit[{Object[Analysis, Peaks, "id:N80DNjlYOpzA"],
			Range[14]}, Linear, ReferenceField -> Position]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{Object[Analysis, Peaks, "id:N80DNjlYOpzA"],
			Range[14]}, Linear, Upload -> False,
			ReferenceField -> Position]]
		}
	],

	Example[{Options, Domain,"Points outside Domain will be excluded from fitting:"},
		PlotFit[AnalyzeFit[LinearData,Domain->{-2.,2.}]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LinearData,Domain->{-2.,2.}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData,Domain->{-2.,2.},Upload->False]]
		}
	],
	Test["Points outside Domain will be excluded from fitting:",
		stripAppendReplaceKeyHeads@AnalyzeFit[LinearData,Domain->{-2.,2.},Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				Exclude->{{-3.`,-4.897`},{-2.6`,-4.003`},{-2.2`,-2.403`},{2.2`,5.198`},{2.6`,6.275`},{3.`,6.318`}},
				MinDomain -> {-2.`},
				MaxDomain -> {2.`},
				ExpressionType -> Linear,
				BestFitExpression->0.7691000000000001` +2.2414939393939393` x,
				SumSquaredError->2.2933199195151523`
			},
			ResolvedOptions -> {Domain->{{-2.`,2.`}}},
			NullFields -> {ReferenceField, Derivative, Outliers, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 12
		]
	],
	Example[{Options, Domain,"Distribution points are filtered out based on their means:"},
		PlotFit[AnalyzeFit[UncertainData,Domain->{-1.,0.5}],Display->{DataError}],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[UncertainData,Domain->{-1.,0.5}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[UncertainData,Domain->{-1.,0.5},Upload->False]]
		}
	],


	Example[{Options, ErrorMethod,"Use first order approximation to derive best fit parameters distribution:"},
		PlotFit@AnalyzeFit[LinearData,ErrorMethod->Parametric],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LinearData,ErrorMethod->Parametric]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData,ErrorMethod->Parametric,Upload->False]]
		}
	],
	Example[{Options, ErrorMethod,"Use monto carlo fitting to obtain best fit parameters distribution:"},
		PlotFit@AnalyzeFit[LinearData,ErrorMethod->Empirical],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LinearData,ErrorMethod->Empirical]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData,ErrorMethod->Empirical,Upload->False]]
		}
	],
	Example[{Options, NumberOfSamples,"Specify number of samples used in monte carlo sampling:"},
		PlotFit@AnalyzeFit[LinearData,ErrorMethod->Empirical,NumberOfSamples->100],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LinearData,ErrorMethod->Empirical,NumberOfSamples->100]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData,ErrorMethod->Empirical,NumberOfSamples->100,Upload->False]]
		}
	],


	Example[{Options,Range,"Any points outside range are excluded from the fit calcuation:"},
		PlotFit[AnalyzeFit[LinearData,Polynomial,Range->{-2,3}]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LinearData,Polynomial,Range->{-2,3}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData,Polynomial,Range->{-2,3}, Upload->False]]
		}
	],
	Test["Any points outside range are excluded from the fit calcuation:",
		stripAppendReplaceKeyHeads@AnalyzeFit[LinearData,Polynomial,Range->{-2,3}, Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				Exclude->{{-3.`,-4.897`},{-2.6`,-4.003`},{-2.2`,-2.403`},{-1.8`,-3.005`},{-1.4`,-2.716`},{1.`,3.949`},{1.4`,4.179`},{1.8`,4.3`},{2.2`,5.198`},{2.6`,6.275`},{3.`,6.318`}},
				Outliers->{},
				BestFitExpression->0.5759900000000001` +1.8959500000000002` x,
				SumSquaredError->0.6287866360000001`
			},
			ResolvedOptions -> {Range->{-2,3},Domain->{{-3.`,3.`}}},
			NullFields -> {ReferenceField, Derivative, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 12
		]
	],

	Example[{Options,Exclude,"If there are known outliers in the data set, they can be excluded from fitting by listing them in the Exclude list:"},
		PlotFit[AnalyzeFit[Map[{#,Replace[#,3->20]}&,Range[-5,5]],Polynomial,Exclude->{{3,20}}]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Map[{#,Replace[#,3->20]}&,Range[-5,5]],Polynomial,Exclude->{{3,20}}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Map[{#,Replace[#,3->20]}&,Range[-5,5]],Polynomial,Exclude->{{3,20}},Upload->False]]
		}
	],
	Test["If there are known outliers in the data set, they can be excluded from fitting by listing them in the Exclude list:",
		stripAppendReplaceKeyHeads@AnalyzeFit[Map[{#,Replace[#,3->20]}&,Range[-5,5]],Polynomial,Exclude->{{3,20}},Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				Exclude->{{3,20}},
				MinDomain -> {-5},
				MaxDomain -> {5},
				ExpressionType -> Polynomial,
				BestFitExpression -> _?NumericQ +0.9999999999999999` x
			},
			ResolvedOptions -> {Exclude->{{3,20}},ExcludeOutliers->False,OutlierDistance->1.5`},
			NullFields -> {ReferenceField, Derivative, Outliers, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 12
		]
	],
	Example[{Options,Exclude,"Specify index of points to exclude:"},
		PlotFit[AnalyzeFit[Map[{#,RandomVariate[NormalDistribution[#,0.5]]}&,Range[-5,5,.5]],Polynomial,Exclude->{2,4,11,17,18}]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Map[{#,RandomVariate[NormalDistribution[#,0.5]]}&,Range[-5,5,.5]],Polynomial,Exclude->{2,4,11,17,18}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[Map[{#,RandomVariate[NormalDistribution[#,0.5]]}&,Range[-5,5,.5]],Polynomial,Exclude->{2,4,11,17,18},Upload->False]]
		}
	],
	Test["Specify index of points to exclude:",
		stripAppendReplaceKeyHeads@AnalyzeFit[Map[{#,RandomVariate[NormalDistribution[#,0.5]]}&,Range[-5,5,.5]],Polynomial,Exclude->{2,4,11,17,18},Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				Exclude->{{-4.5`,_?NumericQ},{-3.5`,_?NumericQ},{0.`,_?NumericQ},{3.`,_?NumericQ},{3.5`,_?NumericQ}}
			},
			ResolvedOptions -> {Exclude->{{-4.5`,_?NumericQ},{-3.5`,_?NumericQ},{0.`,_?NumericQ},{3.`,_?NumericQ},{3.5`,_?NumericQ}},ExcludeOutliers->False,OutlierDistance->1.5`},
			Round -> 12
		]
	],

	Example[{Options,ExcludeOutliers,"If ExcludeOutliers->True, any points detected as outliers will be excluded from fitting:"},
		PlotFit[AnalyzeFit[LinearData, OutlierDistance -> 0.3, ExcludeOutliers -> True]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LinearData, OutlierDistance -> 0.3, ExcludeOutliers -> True]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData, OutlierDistance -> 0.3, ExcludeOutliers -> True, Upload->False]]
		}
	],
	Test["If ExcludeOutliers->True, any points detected as outliers will be excluded from fitting:",
		stripAppendReplaceKeyHeads@AnalyzeFit[LinearData,OutlierDistance -> 0.3, ExcludeOutliers -> True,Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				Exclude->{{-2.2`,-2.403`},{-1.4`,-2.716`},{-0.2`,-0.2952`},{1.`,3.949`},{1.4`,4.179`}},
				Outliers->{{2.6`,6.275`}},
				ExpressionType -> Linear,
				BestFitFunction->(0.7951166666666662` +1.942083333333333` #1&),
				HatDiagonal->{0.3110674525212836`,0.25834970530451873`,0.1745252128356254`,0.1195153896529142`,0.10281597904387688`,0.09102815979043874`,0.09593975114603798`,0.15389652914210872`,0.18762278978389002`,0.2285527177472168`,0.2766863130320892`},
				SumSquaredError->0.8279952333333338`
			},
			ResolvedOptions -> {OutlierDistance->0.3,ExcludeOutliers->True},
			NullFields -> {ReferenceField, Derivative, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 12
		]
	],
	Example[{Options,ExcludeOutliers,"Excluding outliers from a fit often results in new outliers due to the resulting fit being more accurate. ExcludeOutliers->Repeatedly re-fits excluding the newly found outliers up to 3 times or until no more outliers are found:"},
		PlotFit[AnalyzeFit[LinearData, OutlierDistance -> 0.3, ExcludeOutliers -> Repeatedly]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LinearData, OutlierDistance -> 0.3, ExcludeOutliers -> Repeatedly]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData, OutlierDistance -> 0.3, ExcludeOutliers -> Repeatedly, Upload->False]]
		}
	],
	Test["Excluding outliers from a fit often results in new outliers due to the resulting fit being more accurate. ExcludeOutliers->Repeatedly re-fits excluding the newly found outliers up to 3 times or until no more outliers are found:",
		stripAppendReplaceKeyHeads@AnalyzeFit[LinearData,OutlierDistance -> 0.3, ExcludeOutliers -> Repeatedly,Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				Exclude->{{-2.2`,-2.403`},{-1.4`,-2.716`},{-0.2`,-0.2952`},{1.`,3.949`},{1.4`,4.179`},{2.6`,6.275`}},
				Outliers->{},
				ExpressionType -> Linear,
				BestFitExpression->0.7483426994906623` +1.9110224957555177` x,
				HatDiagonal->{0.32003395585738537`,0.26315789473684215`,0.17487266553480474`,0.12054329371816636`,0.1061120543293718`,0.10271646859083189`,0.11375212224108658`,0.19779286926994905`,0.2427843803056027`,0.3582342954159592`},
				SumSquaredError->0.5877953449235995`
			},
			ResolvedOptions -> {OutlierDistance->0.3,ExcludeOutliers->Repeatedly},
			NullFields -> {ReferenceField, Derivative, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 10
		]
	],

	Example[{Options,OutlierDistance,"Control the distance at which points are labeled as outliers:"},
		PlotFit[AnalyzeFit[LinearData, OutlierDistance -> 0.1]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[LinearData, OutlierDistance -> 0.1]=
			stripAppendReplaceKeyHeads[AnalyzeFit[LinearData, OutlierDistance -> 0.1, Upload->False]]
		}
	],
	Test["Control the distance at which points are labeled as outliers:",
		stripAppendReplaceKeyHeads@AnalyzeFit[LinearData, OutlierDistance -> 0.1, Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				Outliers->{{-2.2`,-2.403`},{-1.4`,-2.716`},{-0.2`,-0.2952`},{1.`,3.949`},{1.4`,4.179`},{2.6`,6.275`}},
				ExpressionType -> Linear,
				BestFitExpression->0.8861875000000002` +1.9609875` x,
				HatDiagonal->{0.2279411764705883`,0.186764705882353`,0.15147058823529413`,0.12205882352941178`,0.09852941176470592`,0.0808823529411765`,0.06911764705882356`,0.06323529411764708`,0.06323529411764708`,0.06911764705882355`,0.08088235294117647`,0.09852941176470587`,0.12205882352941176`,0.1514705882352941`,0.1867647058823529`,0.22794117647058815`},
				SumSquaredError->4.861215069000003`
			},
			ResolvedOptions -> {OutlierDistance->0.1`},
			NullFields -> {ReferenceField, Derivative, Exclude, Calibration},
			NonNullFields -> {DataPoints, Response, SymbolicExpression, BestFitParameters, PredictedResponse, BestFitResiduals, HatDiagonal, MeanPredictionError, MeanPredictionDistribution, SinglePredictionError, SinglePredictionDistribution, MeanPredictionInterval, SinglePredictionInterval},
			Round -> 12
		]
	],


	Example[{Options,Output,"Return the uploaded object:"},
		AnalyzeFit[LinearData, Upload->True],
		ObjectP[],
		Stubs:>{
			Upload[{PacketP[Object[Analysis, Fit]]},___]:={Object[Analysis, Fit, "id:0"]},
			Print[_]:=Null
		}
	],


	Example[{Options,TransformationFunction,"Transform EmissionTrajectories into x-values by taking the Max fluorescence across all time in the trajectory:"},
		PlotFit[AnalyzeFit[
			{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:4pO6dMWv6vKo"],Quantity[50,"Nanomolar"]}},
			Linear,FitField->EmissionTrajectories,TransformationFunction->Function[Max[First[#][[;;,2]]]]]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[
			{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:4pO6dMWv6vKo"],Quantity[50,"Nanomolar"]}},
			Linear,FitField->EmissionTrajectories,TransformationFunction->Function[Max[First[#][[;;,2]]]]]=
			stripAppendReplaceKeyHeads[AnalyzeFit[
			{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],Quantity[0,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],Quantity[10,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],Quantity[30,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceKinetics, "id:4pO6dMWv6vKo"],Quantity[50,"Nanomolar"]}},
			Linear,Upload->False,FitField->EmissionTrajectories,TransformationFunction->Function[Max[First[#][[;;,2]]]]]]
		}
	],
	Example[{Options,TransformationFunction,"Transform Absorbance spectrum into x-values by computing its absorbance at a 550 Nanometer:"},
		PlotFit[AnalyzeFit[{{Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAKO9597"], Quantity[0., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:zGj91aR39L9e"], Quantity[2., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:lYq9jRzX9d9p"], Quantity[4., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjNLPYPV"], Quantity[6., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:E8zoYveRoGo7"], Quantity[8., "Micrograms"/"Microliters"]}},
		Linear,FitField->AbsorbanceSpectrum,TransformationFunction->Function[Absorbance[Unitless[#],550Nanometer]]]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAKO9597"], Quantity[0., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:zGj91aR39L9e"], Quantity[2., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:lYq9jRzX9d9p"], Quantity[4., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjNLPYPV"], Quantity[6., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:E8zoYveRoGo7"], Quantity[8., "Micrograms"/"Microliters"]}},
		Linear,FitField->AbsorbanceSpectrum,TransformationFunction->Function[Absorbance[Unitless[#],550Nanometer]]]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAKO9597"], Quantity[0., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:zGj91aR39L9e"], Quantity[2., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:lYq9jRzX9d9p"], Quantity[4., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjNLPYPV"], Quantity[6., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:E8zoYveRoGo7"], Quantity[8., "Micrograms"/"Microliters"]}},
		Linear,Upload->False,FitField->AbsorbanceSpectrum,TransformationFunction->Function[Absorbance[Unitless[#],550Nanometer]]]]
		}
	],
	Test["TransformationFunction is applied and changes output:",
		#[BestFitFunction]&/@{
			stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAKO9597"], Quantity[0., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:zGj91aR39L9e"], Quantity[2., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:lYq9jRzX9d9p"], Quantity[4., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjNLPYPV"], Quantity[6., "Micrograms"/"Microliters"]}},
				Linear,Upload->False,FitField->AbsorbanceSpectrum,TransformationFunction->Function[Absorbance[Unitless[#],550Nanometer]]],
			stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, AbsorbanceSpectroscopy, "id:o1k9jAKO9597"], Quantity[0., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:zGj91aR39L9e"], Quantity[2., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:lYq9jRzX9d9p"], Quantity[4., "Micrograms"/"Microliters"]}, {Object[Data, AbsorbanceSpectroscopy, "id:L8kPEjNLPYPV"], Quantity[6., "Micrograms"/"Microliters"]}},
				Linear,Upload->False,FitField->AbsorbanceSpectrum,TransformationFunction->Function[Absorbance[Unitless[#],560Nanometer]]]
		},
		{QuantityFunction[-13.747384159418488 + 71.31098215634867*#1 & , {Quantity[1, IndependentUnit["AbsorbanceUnit"]]}, Quantity[1, "Micrograms"/"Microliters"]], QuantityFunction[-8.645209767992773 + 49.20857708849684*#1 & , {Quantity[1, IndependentUnit["AbsorbanceUnit"]]}, Quantity[1, "Micrograms"/"Microliters"]]},
		EquivalenceFunction->RoundMatchQ[10]
	],



	Example[{Options,FitField,"Specify field in data objects from which x-coordinates are pulled:"},
		PlotFit[AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[25,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Quantity[18,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[30,"Nanomolar"]}},Linear,FitField->DualEmissionIntensities]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[25,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Quantity[18,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[30,"Nanomolar"]}},Linear,FitField->DualEmissionIntensities]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[25,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Quantity[18,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[30,"Nanomolar"]}},Linear,Upload->False,FitField->DualEmissionIntensities]]
		}
	],
	Test["FitField is pulled from and changes output:",
		#[BestFitFunction]&/@{
			stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[25,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Quantity[18,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[30,"Nanomolar"]}},Linear,Upload->False,FitField->Intensities],
			stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Quantity[25,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Quantity[20,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Quantity[18,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Quantity[40,"Nanomolar"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Quantity[30,"Nanomolar"]}},Linear,Upload->False,FitField->DualEmissionIntensities]
		},
		{
			QuantityFunction[-54.43169974057366`+ 0.012788286683380732` #1&,{RFU},Nanomolar],
			QuantityFunction[-111.09844918591743`+ 0.023113073920021057` #1&,{RFU},Nanomolar]
		},
		EquivalenceFunction->RoundMatchQ[10]
	],
	Example[{Options,FitField,"Specify data field for both x and y objects:"},
		PlotFit[AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Object[Data, Volume, "id:KBL5DvYlevWx"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Object[Data, Volume, "id:jLq9jXY46X7w"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Object[Data, Volume, "id:7X104vK9lvMd"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Object[Data, Volume, "id:N80DNjlYVjWN"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Object[Data, Volume, "id:vXl9j5qE65RD"]}},FitField->{Intensities,LiquidLevel}]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Object[Data, Volume, "id:KBL5DvYlevWx"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Object[Data, Volume, "id:jLq9jXY46X7w"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Object[Data, Volume, "id:7X104vK9lvMd"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Object[Data, Volume, "id:N80DNjlYVjWN"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Object[Data, Volume, "id:vXl9j5qE65RD"]}},FitField->{Intensities,LiquidLevel}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Object[Data, Volume, "id:KBL5DvYlevWx"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Object[Data, Volume, "id:jLq9jXY46X7w"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Object[Data, Volume, "id:7X104vK9lvMd"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Object[Data, Volume, "id:N80DNjlYVjWN"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Object[Data, Volume, "id:vXl9j5qE65RD"]}},FitField->{Intensities,LiquidLevel},Upload->False]]
		}
	],
	Test["Specify data field for both x and y objects:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"],Object[Data, Volume, "id:KBL5DvYlevWx"]},{Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"],Object[Data, Volume, "id:jLq9jXY46X7w"]},{Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"],Object[Data, Volume, "id:7X104vK9lvMd"]},{Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"],Object[Data, Volume, "id:N80DNjlYVjWN"]},{Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"],Object[Data, Volume, "id:vXl9j5qE65RD"]}},FitField->{Intensities,LiquidLevel},Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				BestFitExpression->123.28101540805011` -0.01403323265703714` x,
				DataUnits->{RFU,Millimeter},
				DependentVariableData->{{Link[Object[Data, Volume, "id:KBL5DvYlevWx"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:jLq9jXY46X7w"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:7X104vK9lvMd"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:N80DNjlYVjWN"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:vXl9j5qE65RD"]],LiquidLevel,Identity}},
				IndependentVariableData->{{Link[Object[Data, FluorescenceIntensity, "id:pZx9jonGJOr5"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:4pO6dMWvnm7w"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:Vrbp1jG80vZo"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:XnlV5jmbZNez"]],Intensities,_Function},{Link[Object[Data, FluorescenceIntensity, "id:lYq9jRzX3Oa4"]],Intensities,_Function}}
			},
			NullFields->{SecondaryIndependentVariableData,TertiaryIndependentVariableData},
			Round -> 12
		]
	],
	Example[{Options,FitField,"Specify data field for z objects only:"},
		PlotFit[AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],10Nanomolar,Object[Data, Volume, "id:KBL5DvYlevWx"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],15Nanomolar,Object[Data, Volume, "id:jLq9jXY46X7w"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],20Nanomolar,Object[Data, Volume, "id:7X104vK9lvMd"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],25Nanomolar,Object[Data, Volume, "id:N80DNjlYVjWN"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],30Nanomolar,Object[Data, Volume, "id:vXl9j5qE65RD"]}},FitField->{Automatic,Automatic,LiquidLevel}]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],10Nanomolar,Object[Data, Volume, "id:KBL5DvYlevWx"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],15Nanomolar,Object[Data, Volume, "id:jLq9jXY46X7w"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],20Nanomolar,Object[Data, Volume, "id:7X104vK9lvMd"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],25Nanomolar,Object[Data, Volume, "id:N80DNjlYVjWN"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],30Nanomolar,Object[Data, Volume, "id:vXl9j5qE65RD"]}},FitField->{Automatic,Automatic,LiquidLevel}]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],10Nanomolar,Object[Data, Volume, "id:KBL5DvYlevWx"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],15Nanomolar,Object[Data, Volume, "id:jLq9jXY46X7w"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],20Nanomolar,Object[Data, Volume, "id:7X104vK9lvMd"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],25Nanomolar,Object[Data, Volume, "id:N80DNjlYVjWN"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],30Nanomolar,Object[Data, Volume, "id:vXl9j5qE65RD"]}},FitField->{Automatic,Automatic,LiquidLevel},Upload->False]]
		}
	],
	Test["Specify data field for both x and y objects:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"],10Nanomolar,Object[Data, Volume, "id:KBL5DvYlevWx"]},{Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"],15Nanomolar,Object[Data, Volume, "id:jLq9jXY46X7w"]},{Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"],20Nanomolar,Object[Data, Volume, "id:7X104vK9lvMd"]},{Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"],25Nanomolar,Object[Data, Volume, "id:N80DNjlYVjWN"]},{Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"],30Nanomolar,Object[Data, Volume, "id:vXl9j5qE65RD"]}},FitField->{Automatic,Automatic,LiquidLevel},Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				BestFitExpression->-43.819006777125814`- 0.0019446329929008403` x1+14.19745071873404` x2,
				DataUnits->{RFU,Nanomolar,Millimeter},
				DependentVariableData->{{Link[Object[Data, Volume, "id:KBL5DvYlevWx"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:jLq9jXY46X7w"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:7X104vK9lvMd"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:N80DNjlYVjWN"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:vXl9j5qE65RD"]],LiquidLevel,Identity}},
				IndependentVariableData->{{Link[Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"]],EmissionTrajectories,_Function}}
			},
			NullFields->{SecondaryIndependentVariableData,TertiaryIndependentVariableData},
			Round -> 12
		]
	],

	Test["Null IndependentVariableData and Non-Null SecondaryIndependentVariableData:",
		stripAppendReplaceKeyHeads@AnalyzeFit[{{Quantity[10, "Nanomolar"], Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"], Object[Data, Volume, "id:KBL5DvYlevWx"]},{Quantity[15, "Nanomolar"], Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"], Object[Data, Volume, "id:jLq9jXY46X7w"]},{Quantity[20, "Nanomolar"], Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"], Object[Data, Volume, "id:7X104vK9lvMd"]},{Quantity[25, "Nanomolar"], Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"], Object[Data, Volume, "id:N80DNjlYVjWN"]},  {Quantity[30, "Nanomolar"], Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"], Object[Data, Volume, "id:vXl9j5qE65RD"]}},FitField->{Automatic,Automatic,LiquidLevel},Upload->False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				BestFitExpression->-43.819006777131285`+ 14.197450718734924` x1-0.001944632992900957` x2,
				DataUnits->{Nanomolar,RFU,Millimeter},
				DependentVariableData->{{Link[Object[Data, Volume, "id:KBL5DvYlevWx"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:jLq9jXY46X7w"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:7X104vK9lvMd"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:N80DNjlYVjWN"]],LiquidLevel,Identity},{Link[Object[Data, Volume, "id:vXl9j5qE65RD"]],LiquidLevel,Identity}},
				SecondaryIndependentVariableData->{{Link[Object[Data, FluorescenceKinetics, "id:bq9LA0dBLvXm"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:dORYzZn0Y00G"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:Z1lqpMGjqJd9"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:R8e1PjRD1Eqj"]],EmissionTrajectories,_Function},{Link[Object[Data, FluorescenceKinetics, "id:01G6nvkK6JlE"]],EmissionTrajectories,_Function}}
			},
			NullFields->{IndependentVariableData,TertiaryIndependentVariableData},
			Round -> 12
		]
	],

	(* Object[Analysis,Fit,"id:jLq9jXvYqKox"] *)
	Example[{Options,Template,"Use options from previous fit analysis to fit a cubic:"},
		PlotFit@AnalyzeFit[ExponentialData,Polynomial,Template->Object[Analysis,Fit,"id:jLq9jXvYqKox"]],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[ExponentialData,Polynomial,Template->Object[Analysis,Fit,"id:jLq9jXvYqKox"]]=
			stripAppendReplaceKeyHeads[AnalyzeFit[ExponentialData,Polynomial,Upload->False,Template->Object[Analysis,Fit,"id:jLq9jXvYqKox"]]]
		},
		EquivalenceFunction->RoundMatchQ[10]
	],
	Example[{Options,Template,"Explicitly specify PolynomialDegree option, and pull remaining options from previous fit analysis:"},
		PlotFit@AnalyzeFit[ExponentialData,Polynomial,Template->Object[Analysis,Fit,"id:jLq9jXvYqKox"],PolynomialDegree->2],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[ExponentialData,Polynomial,Template->Object[Analysis,Fit,"id:jLq9jXvYqKox"],PolynomialDegree->2]=
			stripAppendReplaceKeyHeads[AnalyzeFit[ExponentialData,Polynomial,Upload->False,Template->Object[Analysis,Fit,"id:jLq9jXvYqKox"],PolynomialDegree->2]]
		},
		EquivalenceFunction->RoundMatchQ[10]
	],
	Example[{Options,Method,"Method used for fitting:"},
		PlotFit@AnalyzeFit[ExponentialData,Polynomial,Method->Gradient,PolynomialDegree->2],
		ValidGraphicsP[],
		Messages:>{NonlinearModelFit::lmnl},
		EquivalenceFunction->RoundMatchQ[10]
	],
	Example[{Options,Scale,"Whether or not to scale the data to the unit box before fitting:"},
		PlotFit@AnalyzeFit[ExponentialData,Polynomial,Scale->True,PolynomialDegree->2],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[ExponentialData,Polynomial,Scale->True,PolynomialDegree->2]=
			stripAppendReplaceKeyHeads[AnalyzeFit[ExponentialData,Polynomial,Upload->False,Scale->True,PolynomialDegree->2]]
		},
		EquivalenceFunction->RoundMatchQ[10]
	],
	(*Test["Explicitly specify PolynomialDegree option, and pull remaining options from previous fit analysis:",
		stripAppendReplaceKeyHeads@AnalyzeFit[ExponentialData,Polynomial,Upload->False,Template->Object[Analysis,Fit,"id:Vrbp1jKGdoVe"],PolynomialDegree->2],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				ExpressionType -> Polynomial,
				BestFitExpression -> 1.0230653273809518 + 1.1058511904761905*x + 0.9202566964285714*x^2
			},
			Round -> 12
		]
	],*)

	Example[{Options,LogBase,"Fit log expression using base 2:"},
		BestFitExpression/.AnalyzeFit[{{2.`,0.9739361909785468`},{2.5`,0.9943937439060883`},{3.`,1.0518185287546629`},{3.5`,1.0331500354495802`},{4.`,1.1431755913515238`},{4.5`,1.1653717034078148`},{5.`,1.1877278163422305`},{5.5`,1.249997504045294`},{6.`,1.284259347084248`},{6.5`,1.2513679430543536`},{7.`,1.376027419194724`},{7.5`,1.4138796240657971`},{8.`,1.4192203186045542`},{8.5`,1.515757608678853`},{9.`,1.5824982390784073`}}, LinearLog,LogBase->2],
		2^(-0.23925410190609184 + 0.09771909712007877*x),
		Stubs:>{
			AnalyzeFit[{{2.`,0.9739361909785468`},{2.5`,0.9943937439060883`},{3.`,1.0518185287546629`},{3.5`,1.0331500354495802`},{4.`,1.1431755913515238`},{4.5`,1.1653717034078148`},{5.`,1.1877278163422305`},{5.5`,1.249997504045294`},{6.`,1.284259347084248`},{6.5`,1.2513679430543536`},{7.`,1.376027419194724`},{7.5`,1.4138796240657971`},{8.`,1.4192203186045542`},{8.5`,1.515757608678853`},{9.`,1.5824982390784073`}}, LinearLog,LogBase->2]=
			stripAppendReplaceKeyHeads[AnalyzeFit[{{2.`,0.9739361909785468`},{2.5`,0.9943937439060883`},{3.`,1.0518185287546629`},{3.5`,1.0331500354495802`},{4.`,1.1431755913515238`},{4.5`,1.1653717034078148`},{5.`,1.1877278163422305`},{5.5`,1.249997504045294`},{6.`,1.284259347084248`},{6.5`,1.2513679430543536`},{7.`,1.376027419194724`},{7.5`,1.4138796240657971`},{8.`,1.4192203186045542`},{8.5`,1.515757608678853`},{9.`,1.5824982390784073`}}, LinearLog, Upload -> False,LogBase->2]]
		},
		EquivalenceFunction -> RoundMatchQ[12]
	],

	Example[{Options, Name, "Name to be used as the name of Object[Analysis, Fit] generated by the analysis:"},
		randomStr = CreateUUID[];
		Name/.Download[AnalyzeFit[LinearData,Polynomial,Name->randomStr]],
		_String
	],
	Example[{Options,LogTransformed,"Applied when input fitType is LogisticFourParam, True when the input x axis is log-transformed, False otherwise:"},
		PlotFit@AnalyzeFit[Logistic4ParametersData, LogisticFourParam, LogTransformed->True],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[Logistic4ParametersData, LogisticFourParam, LogTransformed->True] =
			AnalyzeFit[Logistic4ParametersData, LogisticFourParam, LogTransformed->True, Upload->False]
		}
	],

	Example[{Options,FitNormalization,"Whether or not to scale the fitting equation to help in finding the fit:"},
		PlotFit@AnalyzeFit[ExponentialDataNormalization,Exponential,FitNormalization->True],
		ValidGraphicsP[],
		Stubs:>{
			AnalyzeFit[ExponentialDataNormalization,Exponential,FitNormalization->True]=
			stripAppendReplaceKeyHeads[AnalyzeFit[ExponentialDataNormalization,Exponential,Upload->False,FitNormalization->True]]
		},
		EquivalenceFunction->RoundMatchQ[10]
	],
	Example[{Options,ZeroIntercept,"Set to True to force a linear fit through the origin:"},
		PlotFit@AnalyzeFit[{{0,2},{1,4},{2,4.2},{3,5.5},{4,8.0}},Linear,ZeroIntercept->True],
		ValidGraphicsP[]
	],
	(* --------------------- TESTS --------------------*)
	(*Test["UnresolvedOptions records all input options in their original form, while ResolvedOptions stores all parsed options that are actually applied to the analysis:",
		AnalyzeFit[LinearData, Pony->"boop", Exclude->zebra,Range->Automatic, Upload -> False],
		validAnalysisPacketP[Object[Analysis, Fit],
			{
				UnresolvedOptions -> {Pony->"boop",Exclude->zebra,Range->Automatic,Upload->False}
			},
			ResolvedOptions -> {Upload->False,ReferenceField->Null,Exclude->{},Domain->{{-3.`,3.`}},ExcludeOutliers->False,OutlierDistance->1.5`,PolynomialDegree->1,StartingValues->{}},
			Round -> 12
		],
			Messages :> {Warning::UnknownOption, Warning::OptionPattern}
	],*)

	Test["Upload result:",
		AnalyzeFit[LinearData, Polynomial, Upload -> True],
		ObjectP[]
	],
	Test["Flot line on zero works:",
		AnalyzeFit[{{0, 0}, {1, 0}, {2, 0}}, Linear, Upload -> True],
		ObjectP[Object[Analysis,Fit]]
	]


	},
	Variables:>{LinearData, ExponentialData, QuantityData,SigmoidalData,UncertainData,GaussianData3D,QuadraticData3D,LinearData3D,LinearData4D},
	SetUp:>(
		LinearData = {{-3.`,-4.897`},{-2.6`,-4.003`},{-2.2`,-2.403`},{-1.8`,-3.005`},{-1.4`,-2.716`},{-1.`,-1.503`},{-0.6`,-0.1098`},{-0.2`,-0.2952`},{0.2`,1.316`},{0.6`,1.576`},{1.`,3.949`},{1.4`,4.179`},{1.8`,4.3`},{2.2`,5.198`},{2.6`,6.275`},{3.`,6.318`}};
		ExponentialData = {{-3.`,0.4854`},{-2.6`,0.009696`},{-2.2`,-0.1217`},{-1.8`,0.4016`},{-1.4`,0.1827`},{-1.`,0.4692`},{-0.6`,0.9731`},{-0.2`,1.079`},{0.2`,1.663`},{0.6`,1.892`},{1.`,2.232`},{1.4`,4.542`},{1.8`,6.235`},{2.2`,8.632`},{2.6`,13.86`},{3.`,20.53`}};
		QuantityData = {{Quantity[-3., "Seconds"], Quantity[0.4854, "Meters"]}, {Quantity[-2.6, "Seconds"], Quantity[0.009696, "Meters"]}, {Quantity[-2.2, "Seconds"], Quantity[-0.1217, "Meters"]}, {Quantity[-1.8, "Seconds"], Quantity[0.4016, "Meters"]}, {Quantity[-1.4, "Seconds"], Quantity[0.1827, "Meters"]}, {Quantity[-1., "Seconds"], Quantity[0.4692, "Meters"]}, {Quantity[-0.6, "Seconds"], Quantity[0.9731, "Meters"]}, {Quantity[-0.2, "Seconds"], Quantity[1.079, "Meters"]}, {Quantity[0.2, "Seconds"], Quantity[1.663, "Meters"]}, {Quantity[0.6, "Seconds"], Quantity[1.892, "Meters"]}, {Quantity[1., "Seconds"], Quantity[2.232, "Meters"]}, {Quantity[1.4, "Seconds"], Quantity[4.542, "Meters"]}, {Quantity[1.8, "Seconds"], Quantity[6.235, "Meters"]}, {Quantity[2.2, "Seconds"], Quantity[8.632, "Meters"]}, {Quantity[2.6, "Seconds"], Quantity[13.86, "Meters"]}, {Quantity[3., "Seconds"], Quantity[20.53, "Meters"]}};
		SigmoidalData = {{-1.`,-0.9763`},{-0.98`,-1.331`},{-0.96`,-0.8991`},{-0.94`,-0.9057`},{-0.92`,-0.9964`},{-0.9`,-0.6414`},{-0.88`,-0.9649`},{-0.86`,-0.9536`},{-0.84`,-1.24`},{-0.82`,-0.9611`},{-0.8`,-1.202`},{-0.78`,-1.161`},{-0.76`,-0.6268`},{-0.74`,-1.179`},{-0.72`,-0.3558`},{-0.7`,-1.016`},{-0.68`,-0.911`},{-0.66`,-1.14`},{-0.64`,-0.9853`},{-0.62`,-0.872`},{-0.6`,-0.6536`},{-0.58`,-0.8317`},{-0.56`,-1.396`},{-0.54`,-1.059`},{-0.52`,-0.4521`},{-0.5`,-0.8287`},{-0.48`,-1.108`},{-0.46`,-1.062`},{-0.44`,-1.276`},{-0.42`,-0.9952`},{-0.4`,-0.8192`},{-0.38`,-0.9518`},{-0.36`,-1.219`},{-0.34`,-0.6284`},{-0.32`,-0.8746`},{-0.3`,-1.192`},{-0.28`,-0.6712`},{-0.26`,-0.3373`},{-0.24`,-1.276`},{-0.22`,-0.5794`},{-0.2`,-0.9035`},{-0.18`,-0.6881`},{-0.16`,-0.5804`},{-0.14`,-0.8684`},{-0.12`,-0.6382`},{-0.1`,-0.8744`},{-0.08`,-0.4039`},{-0.06`,-0.437`},{-0.04`,-0.1911`},{-0.02`,-0.2004`},{0.`,-0.1427`},{0.02`,-0.387`},{0.04`,0.1412`},{0.06`,0.05373`},{0.08`,0.04831`},{0.1`,0.2733`},{0.12`,0.1861`},{0.14`,0.2377`},{0.16`,0.6427`},{0.18`,0.6063`},{0.2`,0.6145`},{0.22`,0.8393`},{0.24`,0.7439`},{0.26`,1.339`},{0.28`,0.81`},{0.3`,1.109`},{0.32`,1.707`},{0.34`,1.472`},{0.36`,1.349`},{0.38`,1.412`},{0.4`,1.399`},{0.42`,1.862`},{0.44`,1.905`},{0.46`,1.999`},{0.48`,2.203`},{0.5`,2.264`},{0.52`,2.391`},{0.54`,2.72`},{0.56`,2.532`},{0.58`,2.457`},{0.6`,2.739`},{0.62`,2.875`},{0.64`,2.584`},{0.66`,2.451`},{0.68`,2.684`},{0.7`,2.638`},{0.72`,2.501`},{0.74`,2.78`},{0.76`,2.995`},{0.78`,2.977`},{0.8`,3.107`},{0.82`,2.959`},{0.84`,2.603`},{0.86`,2.459`},{0.88`,2.918`},{0.9`,3.105`},{0.92`,2.829`},{0.94`,2.856`},{0.96`,2.659`},{0.98`,3.02`},{1.`,2.996`}};
		UncertainData={{NormalDistribution[-1., 0.0005], NormalDistribution[-0.9976, 0.002]}, {NormalDistribution[-0.8956, 0.0055], NormalDistribution[-0.9089, 0.022]}, {NormalDistribution[-0.8075, 0.0105], NormalDistribution[-0.8355, 0.042]}, {NormalDistribution[-0.7049, 0.0155], NormalDistribution[-0.7896, 0.062]}, {NormalDistribution[-0.6327, 0.0205], NormalDistribution[-0.5383, 0.082]}, {NormalDistribution[-0.5051, 0.0255], NormalDistribution[-0.5172, 0.102]}, {NormalDistribution[-0.4239, 0.0305], NormalDistribution[-0.4134, 0.122]}, {NormalDistribution[-0.2446, 0.0355], NormalDistribution[-0.1254, 0.142]}, {NormalDistribution[-0.2096, 0.0405], NormalDistribution[-0.133, 0.162]}, {NormalDistribution[-0.07844, 0.0455], NormalDistribution[-0.1071, 0.182]}, {NormalDistribution[-0.03332, 0.0505], NormalDistribution[0.3436, 0.202]}, {NormalDistribution[0.1042, 0.0555], NormalDistribution[-0.1409, 0.222]}, {NormalDistribution[0.07294, 0.0605], NormalDistribution[0.1775, 0.242]}, {NormalDistribution[0.2964, 0.0655], NormalDistribution[0.6103, 0.262]}, {NormalDistribution[0.3328, 0.0705], NormalDistribution[0.6125, 0.282]}, {NormalDistribution[0.5841, 0.0755], NormalDistribution[0.09859, 0.302]}, {NormalDistribution[0.6871, 0.0805], NormalDistribution[0.7224, 0.322]}, {NormalDistribution[0.6717, 0.0855], NormalDistribution[0.8013, 0.342]}, {NormalDistribution[0.8505, 0.0905], NormalDistribution[1.011, 0.362]}, {NormalDistribution[0.9857, 0.0955], NormalDistribution[0.8559, 0.382]}, {NormalDistribution[0.7945, 0.1005], NormalDistribution[0.7334, 0.402]}};
		GaussianData3D=MapThread[{#1,#2,RandomVariate[NormalDistribution[1+Exp[-2(#1^2+#2^2)],0.03]]}&,Transpose[RandomReal[{-2,2},{1000,2}]]];
		QuadraticData3D = MapThread[{#1,#2,RandomVariate[NormalDistribution[1+2#1-3#2+#1*#2+5*#2^2+7.*#1^2,2.]]}&,Transpose[RandomReal[{-2,2},{1000,2}]]];
		LinearData3D = Flatten[Table[{x,y,1+2*x+3*y},{x,-2,2,.2},{y,-3,3,.2}],1];
		LinearData4D = Flatten[Table[{x,y,z,1+2*x+3*y+4*z},{x,-2,2,.6},{y,-3,3,.6},{z,-2,2,0.6}],2];
		(* Table[{x,RandomVariate[NormalDistribution[2-3/(2+Exp[1.5 x-.5]),0.05`]]},{x,-5,5,0.1}] *)
		LogisticSigmoidData = {{-5.`,0.5360654035734815`},{-4.9`,0.41526465259733897`},{-4.8`,0.5411628258760882`},{-4.7`,0.4283057697649798`},{-4.6`,0.5835176180776163`},{-4.5`,0.4806331968044639`},{-4.4`,0.5257607851845436`},{-4.3`,0.6234295554126191`},{-4.2`,0.5418878387494863`},{-4.1`,0.492447058048215`},{-4.`,0.41506264748326505`},{-3.9`,0.4399509374049419`},{-3.8`,0.48908547895169585`},{-3.7`,0.43050424885279914`},{-3.5999999999999996`,0.42495714668307194`},{-3.5`,0.5087053510147588`},{-3.4`,0.43083054858890657`},{-3.3`,0.48458159863830474`},{-3.2`,0.4496915439585302`},{-3.0999999999999996`,0.4465575818670485`},{-3.`,0.5379309790175933`},{-2.9`,0.38258148890128574`},{-2.8`,0.5172923949460838`},{-2.6999999999999997`,0.5075402597651899`},{-2.5999999999999996`,0.5146484148262112`},{-2.5`,0.47109620231854865`},{-2.4`,0.5542038834335734`},{-2.3`,0.5004572685387667`},{-2.1999999999999997`,0.48457888454515397`},{-2.0999999999999996`,0.5710201508082335`},{-2.`,0.5827019450778358`},{-1.9`,0.5762699548150051`},{-1.7999999999999998`,0.526831116746754`},{-1.6999999999999997`,0.4708376191902946`},{-1.5999999999999996`,0.5254873084309657`},{-1.5`,0.6029669095031949`},{-1.4`,0.5555443404406745`},{-1.2999999999999998`,0.5623614987238458`},{-1.1999999999999997`,0.49899085594613574`},{-1.0999999999999996`,0.625921157011421`},{-1.`,0.5943797025534109`},{-0.8999999999999995`,0.6726987232295496`},{-0.7999999999999998`,0.6093497730596252`},{-0.7000000000000002`,0.593344270646875`},{-0.5999999999999996`,0.6467385007345696`},{-0.5`,0.7075215280450129`},{-0.39999999999999947`,0.6971207676195855`},{-0.2999999999999998`,0.7678010229958383`},{-0.1999999999999993`,0.7762114863180275`},{-0.09999999999999964`,0.8232899048883182`},{0.`,0.8152689621188137`},{0.10000000000000053`,0.9074991410655522`},{0.20000000000000018`,0.9119223725666227`},{0.3000000000000007`,1.0321022979434074`},{0.40000000000000036`,1.052450420708777`},{0.5`,1.1217434597309566`},{0.6000000000000005`,1.1347879633791378`},{0.7000000000000002`,1.1697784748747397`},{0.8000000000000007`,1.2951829249448146`},{0.9000000000000004`,1.3137991845293828`},{1.`,1.360478284127484`},{1.1000000000000005`,1.4022339919208802`},{1.2000000000000002`,1.5019848133994091`},{1.3000000000000007`,1.5732486487004709`},{1.4000000000000004`,1.5885166755630336`},{1.5`,1.6788220360664527`},{1.6000000000000005`,1.6471228978937762`},{1.7000000000000002`,1.7446956842590338`},{1.8000000000000007`,1.711367826202818`},{1.9000000000000004`,1.7505115710445367`},{2.`,1.7083738827143005`},{2.1000000000000005`,1.869227587274361`},{2.2`,1.8202988550598662`},{2.3000000000000007`,1.8982147080955398`},{2.4000000000000004`,1.8896656086825476`},{2.5`,1.884912881243116`},{2.6000000000000005`,1.9061612303960886`},{2.7`,1.8801264447039177`},{2.8000000000000007`,1.9743292701557078`},{2.9000000000000004`,2.048472889507275`},{3.`,1.963036917175147`},{3.0999999999999996`,1.9906272530363436`},{3.200000000000001`,1.880524582686476`},{3.3000000000000007`,2.035787490126448`},{3.4000000000000004`,1.952564813974556`},{3.5`,2.0220809596661162`},{3.5999999999999996`,1.8842330350259813`},{3.700000000000001`,1.9471090892619207`},{3.8000000000000007`,2.0519840739091446`},{3.9000000000000004`,2.0075240052716095`},{4.`,2.0519337027836757`},{4.1`,1.9662173968843468`},{4.200000000000001`,1.9729103174911`},{4.300000000000001`,1.982062310170723`},{4.4`,1.9726820549657467`},{4.5`,2.0011957562270615`},{4.600000000000001`,1.9355762659997529`},{4.700000000000001`,1.9768731068876466`},{4.800000000000001`,2.008641011840361`},{4.9`,1.9375344951348539`},{5.`,1.9443156610460175`}};
		Logistic4ParametersData = {{7.96578`,5913.`},{6.24332`,10729.`},{4.52085`,20825.`},{2.79839`,50478.5`},{1.07592`,119492.5`},{-0.646546`,196904.5`},{-2.36901`,224309.`},{-4.09148`,229128.`}};
		ExponentialDataNormalization = {{68.18181818181819`, 300}, {93.63636363636363`, 200}, {111.81818181818181`, 150}, {136.36363636363637`, 100}, {154.54545454545456`, 75}, {184.54545454545456`, 50},
		{218.1818181818182`, 35}, {257.27272727272725`, 25}, {308.1818181818182`, 20}, {357.27272727272725`, 15}, {385.4545454545455`, 10}}
	),
	SymbolSetUp :> (
		$CreatedObjects = {};
	),
	SymbolTearDown :> (
		EraseObject[
			PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]],
			Force -> True,
			Verbose -> False
		];
		Unset[$CreatedObjects];
	)
];



(* ::Subsubsection:: *)
(*AnalyzeFitOptions*)


DefineTests[AnalyzeFitOptions, {
	Example[{Basic,"Return all options with Automatic resolved to a fixed value:"},
		AnalyzeFitOptions[LinearData,Polynomial, Domain->Automatic, TransformationFunction->Automatic, Upload->False],
		_Grid
	],
	Example[{Basic,"The reference field can also be resolved:"},
		AnalyzeFitOptions[{Object[Analysis,Peaks,"id:N80DNjlYOpzA"],Range[14]},Linear,ReferenceField->Position,Upload->False],
		_Grid
	],
	Example[{Options,OutputFormat,"Return the options as a list:"},
		AnalyzeFitOptions[LinearData,Polynomial, Domain->Automatic, TransformationFunction->Automatic, Upload->False, OutputFormat->List],
		{
			Exclude->{},
			Domain->{{-3., 3.}},
			Range->{-4.897, 6.318},
			ExcludeOutliers->False,
			OutlierDistance->1.5,
			PolynomialDegree->1,
			LogBase->10,
			LogTransformed->True,
			StartingValues->{},
			ErrorMethod->Parametric,
			NumberOfSamples->1000,
			FitField -> Null,
			ReferenceField -> Null,
			TransformationFunction -> Identity,
			Method -> Automatic,
			Scale -> False,
			Name -> Null,
			FitNormalization -> False,
			ZeroIntercept -> False,
			Template -> Null
		}
	]
},
	Variables:>{LinearData},
	SetUp:>(
		LinearData = {{-3.`,-4.897`},{-2.6`,-4.003`},{-2.2`,-2.403`},{-1.8`,-3.005`},{-1.4`,-2.716`},{-1.`,-1.503`},{-0.6`,-0.1098`},{-0.2`,-0.2952`},{0.2`,1.316`},{0.6`,1.576`},{1.`,3.949`},{1.4`,4.179`},{1.8`,4.3`},{2.2`,5.198`},{2.6`,6.275`},{3.`,6.318`}}
	)
];


(* ::Subsubsection::Closed:: *)
(*AnalyzeFitPreview*)


DefineTests[AnalyzeFitPreview, {
	Example[{Basic,"Return a graphical display for the calculated fit function on top of input data:"},
		AnalyzeFitPreview[LinearData,Polynomial,Upload->False],
		ValidGraphicsP[]
	],
	Example[{Basic,"The reference field can also be resolved:"},
		AnalyzeFitPreview[Table[{x,RandomVariate[NormalDistribution[3 - 2 ECL`x, 0.7]]},{x,-3,4,0.1`}],Linear, Upload->False],
		ValidGraphicsP[]
	],
	Example[{Basic,"Can work with object inputs:"},
		AnalyzeFitPreview[{Object[Analysis, Peaks, "id:lYq9jRzXle9Y"], {1, 2, 3, 4, 5}, Model[Sample, StockSolution, Standard, "id:1ZA60vLraxRM"]},Linear,Upload->False],
		ValidGraphicsP[]
	]
},
	Variables:>{LinearData},
	SetUp:>(
		LinearData = {{-3.`,-4.897`},{-2.6`,-4.003`},{-2.2`,-2.403`},{-1.8`,-3.005`},{-1.4`,-2.716`},{-1.`,-1.503`},{-0.6`,-0.1098`},{-0.2`,-0.2952`},{0.2`,1.316`},{0.6`,1.576`},{1.`,3.949`},{1.4`,4.179`},{1.8`,4.3`},{2.2`,5.198`},{2.6`,6.275`},{3.`,6.318`}}
	)

];


(* ::Subsubsection::Closed:: *)
(*ValidAnalyzeFitQ*)


DefineTests[ValidAnalyzeFitQ, {
	Example[{Basic,"Return test results for all the gathered tests/warning:"},
		ValidAnalyzeFitQ[LinearData,Polynomial,Upload->False],
		True
	],
	Example[{Basic,"The function also checks if the input objects are valid:"},
		Quiet[ValidAnalyzeFitQ[{Object[Analysis, Peaks, "id:lYq9jRzXle9Y"], {1, 2, 3, 4, 5}, Model[Sample, StockSolution, Standard, "id:1ZA60vLraxRM"]},Linear,Upload->False],{RunValidQTest::InvalidTests}],
		True
	],
	Example[{Options,OutputFormat,"Specify OutputFormat to be TestSummary:"},
		ValidAnalyzeFitQ[LinearData,Polynomial,Upload->False,OutputFormat->TestSummary],
		_EmeraldTestSummary
	],
	Example[{Options,Verbose,"Specify Verbose to be True:"},
		Quiet[ValidAnalyzeFitQ[{Object[Analysis, Peaks, "id:lYq9jRzXle9Y"], {1, 2, 3, 4, 5}, Model[Sample, StockSolution, Standard, "id:1ZA60vLraxRM"]},Verbose->True],{RunValidQTest::InvalidTests}],
		True
	]

},
	Variables:>{LinearData},
	SetUp:>(
		LinearData = {{-3.`,-4.897`},{-2.6`,-4.003`},{-2.2`,-2.403`},{-1.8`,-3.005`},{-1.4`,-2.716`},{-1.`,-1.503`},{-0.6`,-0.1098`},{-0.2`,-0.2952`},{0.2`,1.316`},{0.6`,1.576`},{1.`,3.949`},{1.4`,4.179`},{1.8`,4.3`},{2.2`,5.198`},{2.6`,6.275`},{3.`,6.318`}}
	)

];


(* ::Subsection::Closed:: *)
(*Fitting Utilities*)


(* ::Subsubsection::Closed:: *)
(*transformFunction*)


DefineTests[transformFunction,
{
		Example[
			{Basic,"Affine transformation of nonlinear function:"},
			transformFunction[Exp[#1] #1^2&,{0.3`,-7.`},{2,3}],
			-0.14285714285714285` (-3+E^(2+0.3` #1) (2+0.3` #1)^2)&
		],
		Example[
			{Basic,"Affine transformation of linear function:"},
			transformFunction[#1&,{0.3`,-7.`},{2,3}],
			-0.14285714285714285` (-1+0.3` #1)&
		],
		Example[
			{Basic,"Identity transformation:"},
			transformFunction[#1^2&,{1,1},{0,0}],
			#1^2&
		]

}];


(* ::Subsubsection::Closed:: *)
(*computeFitError*)


DefineTests[computeFitError,{

	Test[computeFitError[#1*10+2&,{{1,1}}],0],
	Test[computeFitError[#1*10+2&,N@Transpose@{Range[1,10],Range[11,20]}],27.248853186877426,EquivalenceFunction->RoundMatchQ[10]]

}];


(* ::Subsection::Closed:: *)
(*ConvertGradient*)


(* ::Subsubsection:: *)
(*ConvertGradient*)


DefineTests[ConvertGradient, {
	Example[{Basic,"Return the approximated percent composition of solvent A,B,C,D over the gradient segment time:"},
		ListLinePlot[Most[Rest[Transpose[ConvertGradient[percentData1]]]], PlotLegends->{"A","B","C","D"}],
		_Legended
	],
	Example[{Basic,"Curves are concave when curve number is between 6 and 10:"},
		ListLinePlot[Most[Rest[Transpose[ConvertGradient[percentData2]]]], PlotLegends->{"A","B","C","D"}],
		_Legended
	],
	Example[{Basic,"Curves are step functions when curve number is 1 or 11:"},
		ListLinePlot[Most[Rest[Transpose[ConvertGradient[percentData3]]]], PlotLegends->{"A","B","C","D"}],
		_Legended
	],
	Example[{Options,SamplingRate,"Time step as a ratio to overall time length to sample each curve:"},
		ConvertGradient[percentData1, SamplingRate->0.3],
		{{_Quantity..}..}
	]
},

	Variables:>{percentData1, percentData2, percentData3},
	SetUp:>(
		percentData1 = {{0Minute, {90Percent, 10Percent, 0 Percent, 0Percent},Milliliter/Minute, Null}, {10Minute, {50Percent, 50Percent, 0 Percent, 0Percent},0.5Milliliter/Minute, 2},{15Minute, {10Percent, 20Percent, 70 Percent, 0Percent},2Milliliter/Minute, 9}};
		percentData2 = {{0Minute, {90Percent, 10Percent, 0 Percent, 0Percent},Milliliter/Minute, Null}, {10Minute, {50Percent, 50Percent, 0 Percent, 0Percent},0.5Milliliter/Minute, 7},{15Minute, {10Percent, 20Percent, 70 Percent, 0Percent},2Milliliter/Minute, 10}};
		percentData3 = {{0Minute, {90Percent, 10Percent, 0 Percent, 0Percent},Milliliter/Minute, Null}, {10Minute, {50Percent, 50Percent, 0 Percent, 0Percent},0.5Milliliter/Minute, 1},{15Minute, {10Percent, 20Percent, 70 Percent, 0Percent},2Milliliter/Minute, 10}}
	)

];


(* ::Section:: *)
(*End Test Package*)
