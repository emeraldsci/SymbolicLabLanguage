(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTestsWithCompanions[AnalyzeMeltingPoint,

	{
		(* ---- Basic ---- *)

		Example[{Basic, "Analyze melting points from Absorbance Thermodynamics data:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Upload -> False][MeanMeltingTemperature],
			Quantity[61.324020000000004`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],
		Test["Analyze melting points from Absorbance Thermodynamics data, Return Packet:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					MeanMeltingTemperature -> Quantity[61.324020000000004, "DegreesCelsius"],
					Replace[MeltingTemperatures] ->{Quantity[62.28595000000001, "DegreesCelsius"], Quantity[60.36209, "DegreesCelsius"]},
					Append[Reference] -> {Null|Link[Object[Data, MeltingCurve, _String], MeltingAnalyses]}
				},
				ResolvedOptions -> {
					Domain -> {7.52`, 87.42`},
					Range -> {0.09003236`, 0.1028803`},
					Method -> MidPoint,
					DataProcessing -> Smooth,
					SmoothingRadius -> 5,
					DataSet -> {MeltingCurve, CoolingCurve},
					PlotType -> MeltingPoint,
					ApplyAll -> False,
					Output -> Result,
					Upload -> False,
					Template -> Null},
				NullFields -> {MeltingTemperatureStandardDeviations, MeltingTemperatureDistributions},
				NonNullFields -> {MeltingCurvesFractionBound},
				Round -> 2
			],
			TimeConstraint->300
		],

		Example[{Basic, "Analyze melting points for Fluorescence Spectra data (MultimodeSpectrophotometer instrument):"},
			PlotMeltingPoint[AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"],Upload->False]],
			TabView[{_String -> _?ValidGraphicsQ, _String -> _?ValidGraphicsQ}],
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Basic, "Analyze some of the data sets in a thermal shift protocol:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Download[Object[Protocol,ThermalShift,"id:wqW9BP7X5O1B"],Data][[1;;3]],Upload->False],
			SlideView[{TabView[_List]..}],
			EquivalenceFunction->MatchQ,
			TimeConstraint->300
		],

		Example[{Basic, "Analyze all data sets in a protocol:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Protocol,UVMelting, "id:1ZA60vwjOj0a"],Upload->False],
			SlideView[{_?ValidGraphicsQ..}],
			TimeConstraint->300
		],

		Test["Analyze all data sets in a protocol, Return Packet:",
			AnalyzeMeltingPoint[Object[Protocol,UVMelting, "id:1ZA60vwjOj0a"], Upload -> False],
			Repeat[validAnalysisPacketP[Object[Analysis, MeltingPoint], {}], 2],
			Stubs:>{
				Download[Object[Protocol,UVMelting, "id:1ZA60vwjOj0a"], Data]=Download[{Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"]}]
			},
			TimeConstraint->300
		],

		Example[{Basic, "Compute melting points from a raw melting curve data:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[meltingCurve,Upload->False],
			_?ValidGraphicsQ,
			EquivalenceFunction->MatchQ,
			TimeConstraint->300
		],
		Test["Compute melting points from a raw melting curve data, Return Packet:",
			AnalyzeMeltingPoint[meltingCurve, Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					MeanMeltingTemperature -> Quantity[50.20358, "DegreesCelsius"],
					Replace[MeltingTemperatures] -> {Quantity[50.20358, "DegreesCelsius"]}
				},
				ResolvedOptions -> {Upload -> False, Domain -> {4.820000172`, 94.91999817`}, Range -> {0.3568803069999995`, 0.5884541270000001`}, Method -> MidPoint, DataProcessing -> Smooth, SmoothingRadius -> 5, DataSet -> {CoolingCurve}},
				NullFields -> {Reference, MeltingTemperatureStandardDeviations, MeltingTemperatureDistribution},
				NonNullFields -> {MeltingCurvesFractionBound},
				Round -> 3
			],
			TimeConstraint->300
		],
		Test["The input is Object[Data, MeltingPoint], calculation for PharmacopeiaStartPointTemperature",
			Lookup[
				AnalyzeMeltingPoint[Object[Data, MeltingPoint, "Melting Point Mock data unit test 1" <> uuid], Upload->False],
				{
					PharmacopeiaStartPointTemperature, PharmacopeiaMeniscusPointTemperature, PharmacopeiaClearPointTemperature,
					ThermodynamicStartPointTemperature, ThermodynamicMeniscusPointTemperature, ThermodynamicClearPointTemperature,
					USPharmacopeiaMeltingRange, BritishPharmacopeiaMeltingPoint, JapanesePharmacopeiaMeltingPoint
				}
			],
			{
				Quantity[237.269, "DegreesCelsius"],
				Quantity[237.619, "DegreesCelsius"],
				Quantity[237.856, "DegreesCelsius"],
				Quantity[237.070881752481, "DegreesCelsius"],
				Quantity[236.1331131436075, "DegreesCelsius"],
				Quantity[235.87481752481, "DegreesCelsius"],
				{
					Quantity[237.269, "DegreesCelsius"],
					Quantity[237.856, "DegreesCelsius"]
				},
				Quantity[237.856, "DegreesCelsius"],
				Quantity[237.856, "DegreesCelsius"]
			},
			EquivalenceFunction->RoundMatchQ[2]
		],

		(* ---- Additional ---- *)

		Example[{Additional, "Plot a melting point analysis:"},
			PlotMeltingPoint[AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Upload->False]],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],

		Example[{Additional, "Analyze some of the data sets in a thermal shift protocol and plotting the result of the derivative of the melting curves. In addition the results of FluorescenceLaserPowerOptimizationResult are shown:"},
			PlotMeltingPoint[AnalyzeMeltingPoint[Download[Object[Protocol, ThermalShift, "id:GmzlKjPKbL14"], Data][[1;;6;;2]],Upload->False],PlotType->All,LaserPowerDisplay->True],
			SlideView[{TabView[_List]..}],
			EquivalenceFunction->MatchQ,
			TimeConstraint->300
		],

		Example[{Additional,"Anayze melting points for Fluorescence Spectra data with plotting the derivative overlayed on top of the melting curve and aggregation curves:"},
			PlotMeltingPoint[AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:rea9jlRjdrno"],Upload->False],PlotType->All],
			TabView[{_String -> _?ValidGraphicsQ, _String -> _?ValidGraphicsQ, _String -> _?ValidGraphicsQ, _String -> _?ValidGraphicsQ}],
			EquivalenceFunction->MatchQ
		],

		Example[{Additional, "Analyze a list of data objects with multiple melting curves:"},
			PlotMeltingPoint[{
				AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:M8n3rx0nne4P"],DataSet->{MeltingCurve,CoolingCurve,SecondaryMeltingCurve,TertiaryMeltingCurve,TertiaryCoolingCurve},Upload -> False],
				AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:1ZA60vLAxlRa"],DataSet->{MeltingCurve,SecondaryMeltingCurve,SecondaryCoolingCurve},Upload -> False]
			}],
			SlideView[{_?ValidGraphicsQ..}],
			TimeConstraint->300
		],

		Example[{Additional, "Analyze a list of data objects:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[{Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"]}, Upload -> False],
			SlideView[{_?ValidGraphicsQ..}],
			TimeConstraint->300
		],
		Test["Analyze a list of data objects, Return Packet:",
			AnalyzeMeltingPoint[{Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"]}, Upload -> False],
			{
				validAnalysisPacketP[Object[Analysis, MeltingPoint],
					{
						MeanMeltingTemperature ->Quantity[61.324020000000004, "DegreesCelsius"],
						Replace[MeltingTemperatures] -> {Quantity[_?(MatchQ[Round[#],62]&), "DegreesCelsius"],Quantity[_?(MatchQ[Round[#],60]&), "DegreesCelsius"]},
						Append[Reference] -> {Null|Link[Object[Data, MeltingCurve, _String], MeltingAnalyses]}
					},
					NullFields -> {MeltingTemperatureStandardDeviation, MeltingTemperatureDistribution},
					NonNullFields -> {MeltingCurvesFractionBound, MeanMeltingTemperature},
					Round -> 3
				],
				validAnalysisPacketP[Object[Analysis, MeltingPoint],
					{
						MeanMeltingTemperature -> Quantity[75.757035, "DegreesCelsius"],
						Replace[MeltingTemperatures] -> {Quantity[75.35480000000001`, "DegreesCelsius"],
							Quantity[76.15927`, "DegreesCelsius"]},
						Append[Reference] -> {Link[Object[Data, MeltingCurve, _String],MeltingAnalyses]}
					},
					NonNullFields -> {MeltingCurvesFractionBound},
					Round -> 2
				]
			},
			TimeConstraint->300
		],

		Example[{Additional, "Compute melting points from a quantity array melting curve:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[QuantityArray[meltingCurve, {Celsius, ArbitraryUnit}], Upload -> False],
			_?ValidGraphicsQ,
			EquivalenceFunction->MatchQ,
			TimeConstraint->300
		],
		
		Test["Compute melting points from a quantity array melting curve, Return Packet:",
			AnalyzeMeltingPoint[QuantityArray[meltingCurve, {Celsius, ArbitraryUnit}], Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint], {MeanMeltingTemperature->Quantity[50.20358, "DegreesCelsius"]},Round->3],
			TimeConstraint->300
		],
		
		Test["Compute melting points from a quantity array fluorescence melting curve, Return Packet:",
			AnalyzeMeltingPoint[QuantityArray[meltingCurve, {Celsius, RFU}], Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint], {MeanMeltingTemperature->Quantity[50.20358, "DegreesCelsius"]},Round->3],
			TimeConstraint->300
		],

		Example[{Additional,"Given list of raw melting curves:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[{
				Table[{x,1000(Tanh[(x-60)/10.]+5)},{x,5,95}],
				Table[{x,1000(Tanh[(x-58)/10.]+5)},{x,5,95}],
				Table[{x,1000(Tanh[(x-56)/10.]+5)},{x,5,95}]
			}, Upload -> False],
			SlideView[{_?ValidGraphicsQ..}],
			TimeConstraint->300
		],

		Example[{Additional,"Given list of quantity array melting curves:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[{
				QuantityArray[Table[{x,1000(Tanh[(x-60)/10.]+5)},{x,5,95}],{Celsius,ArbitraryUnit}],
				QuantityArray[Table[{x,1000(Tanh[(x-58)/10.]+5)},{x,5,95}],{Celsius,ArbitraryUnit}],
				QuantityArray[Table[{x,1000(Tanh[(x-56)/10.]+5)},{x,5,95}],{Celsius,ArbitraryUnit}]
			}, Upload -> False],
			SlideView[{_?ValidGraphicsQ..}],
			TimeConstraint->300
		],

		Example[{Additional, "A set of AbsorbanceIntensity objects each containing one melting datapoints:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1}, Upload -> False][MeanMeltingTemperature],
			{Quantity[60.`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Example[{Additional, "Multiple sets of AbsorbanceIntensity objects each containing one melting datapoints:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1,absorbanceIntensityObjectsTest2}, Upload -> False],
			SlideView[{_?ValidGraphicsQ..}],
			TimeConstraint->300
		],

		Example[{Additional, "Custom transformation function to manipulate a 3D thermal response of a dataset:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"], DataSet -> {MeltingCurve3D}, DataSetTransformationFunction -> {MaxHeightFunction},Upload->False],
			_?ValidGraphicsQ,
			EquivalenceFunction->MatchQ,
			TimeConstraint->300
		],

		Example[{Additional, "Ratio transformation function:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:Z1lqpMznX9PM"], DataSet -> {MeltingCurve3D, AggregationCurve3D}, DataSetTransformationFunction -> {Ratio, Automatic},Wavelength->{330,350},MeltingOnset -> True,Upload->False],
			TabView[{_String -> _?ValidGraphicsQ, _String -> _?ValidGraphicsQ}],
			EquivalenceFunction->MatchQ,
			TimeConstraint->300
		],

		Example[{Additional, "Simple function which changes the dimension and averages the temperature values:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest2}, TemperatureTransformationFunction -> Function[x, {Mean[x]}], ResponseTransformationFunction -> Function[x, {Mean[x]}], Upload -> False][MeanMeltingTemperature],
			{Quantity[45.`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Example[{Additional, "Upload and download test of options added to object:"},
			Download[AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"]], {Domain, MeltingPlotRange, Wavelength, DataProcessing, SmoothingRadius, DataSet, PlotType, ApplyAll, Output,Upload, Template}],
			{{Quantity[7.52`, "DegreesCelsius"], Quantity[87.42`, "DegreesCelsius"]}, {0.09003236`, 0.1028803`}, Null, Smooth, 5.`, {MeltingCurve, CoolingCurve}, MeltingPoint, False, {Result}, True, Null}
		],
		
		Example[{Additional, "Melting point analysis of an Object[Data, qPCR] will calculate the negative derivative values of the MeltingCurves:"},
			packet = AnalyzeMeltingPoint[Object[Data, qPCR, "PlotqPCR test data 2" <> $SessionUUID], Upload->False];
			Lookup[packet, Replace[MeltingCurvesDerivativePoints]],
			{QuantityCoordinatesP[]},
			Variables:>{packet}
		],

		(* ---- Options ---- *)

		Example[{Options, Method, "For MidPoint method, the melting point is defined as the temperature corresponding to the halfway point between the top and bottom baseline:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Method -> MidPoint, Upload -> False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],
		Test["For MidPoint method, the melting point is defined as the temperature corresponding to the halfway point between the top and bottom baseline, Return Packet:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Method -> MidPoint, Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					Method -> MidPoint,
					MeanMeltingTemperature -> Quantity[61.392649188278774, "DegreesCelsius"],
					Replace[MeltingTemperatures] -> {Quantity[62.33309357893505`, "DegreesCelsius"],Quantity[60.4522047976225, "DegreesCelsius"]}
				},
				Round -> 2
			],
			TimeConstraint->300
		],

		Example[{Options, Method, "For InflectionPoint method, the melting point is defined as the inflection point of the alpha curve, which is the temperature at which the second derivative of the curve is zero:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Method -> InflectionPoint,Upload->False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],

		Example[{Options, DataProcessing, "Smooth the data with a Gaussian filter before calculating the melting point:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Method -> InflectionPoint, DataProcessing -> Smooth, Upload -> False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],
		Test["Smooth the data with a Gaussian filter before calculating the melting point, Return Packet:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Method -> InflectionPoint, DataProcessing -> Smooth, Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					Method -> InflectionPoint,
					MeanMeltingTemperature -> Quantity[58.07`, "DegreesCelsius"],
					Replace[MeltingTemperatures] -> {Quantity[63.57`, "DegreesCelsius"],Quantity[52.57`, "DegreesCelsius"]}
				},
				ResolvedOptions -> {
					Domain -> {7.52, 87.42},
					Range -> {0.09003236`, 0.1028803`},
					Method -> InflectionPoint,
					DataProcessing -> Smooth,
					SmoothingRadius -> 5,
					DataSet -> {MeltingCurve, CoolingCurve},
					PlotType -> MeltingPoint,
					ApplyAll -> False,
					Output -> Result,
					Upload -> False,
					Template -> Null
				},
				Round -> 3
			],
			TimeConstraint->300
		],

		Example[{Options, DataProcessing, "Fit the data to a sigmoid and then calculate the melting point from the fitted sigmoid expression:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Method -> InflectionPoint, DataProcessing -> Fit, Upload -> False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],
		Test["Fit the data to a sigmoid and then calculate the melting point from the fitted sigmoid expression, Return Packet:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Method -> InflectionPoint, DataProcessing -> Fit, Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					Method -> InflectionPoint,
				  MeanMeltingTemperature -> Quantity[63.12377116761004`, "DegreesCelsius"],
					MeltingTemperatureStandardDeviation -> Quantity[0.37333950111008485`, "DegreesCelsius"],
				  MeltingTemperatureDistribution ->  QuantityDistribution[NormalDistribution[63.12377116761004`, 0.37333950111008485`],"DegreesCelsius"],
				  Replace[MeltingTemperatureDistributions] -> {
						QuantityDistribution[NormalDistribution[64.95951215047647`, 0.6414887990622083`], "DegreesCelsius"],
				  	QuantityDistribution[NormalDistribution[61.288030184743604`, 0.3821277967306668`], "DegreesCelsius"]
					},
				  Replace[MeltingTemperatureStandardDeviations] -> {Quantity[0.6414887990622083`, "DegreesCelsius"], Quantity[0.3821277967306668`, "DegreesCelsius"]},
				  Replace[MeltingTemperatures] -> {Quantity[64.95951215047647`,"DegreesCelsius"], Quantity[61.288030184743604`, "DegreesCelsius"]}
				},
				ResolvedOptions -> {
					Domain -> {7.52, 87.42},
					Range -> {0.09003236`, 0.1028803`},
					Method -> InflectionPoint,
					DataProcessing -> Fit,
					SmoothingRadius -> 5,
					DataSet -> {MeltingCurve, CoolingCurve},
					PlotType -> MeltingPoint,
					ApplyAll -> False,
					Output -> Result,
					Upload -> False,
					Template -> Null
				},
				Round -> 3
			],
			TimeConstraint->300,
			EquivalenceFunction->RoundMatchQ[3]
		],

		Test["Make sure distributions come out correct when both curves are present:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"], Method -> InflectionPoint, DataProcessing -> Fit, Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					Method -> InflectionPoint,
					MeanMeltingTemperature -> Quantity[82.60588284736676`, "DegreesCelsius"],
					MeltingTemperatureStandardDeviation -> Quantity[1.7137317239401124`,"DegreesCelsius"],
					MeltingTemperatureDistribution -> QuantityDistribution[NormalDistribution[82.60588284736676`, 1.7137317239401124`], "DegreesCelsius"],
					Replace[MeltingTemperatureDistributions] ->	{QuantityDistribution[NormalDistribution[78.49775566012606`, 0.7348560358021872`],"DegreesCelsius"],QuantityDistribution[NormalDistribution[86.71401003460747`, 3.347759294393803`],	"DegreesCelsius"]},
					Replace[MeltingTemperatureStandardDeviations] -> {Quantity[0.7348560358021872`, "DegreesCelsius"],Quantity[3.347759294393803`,"DegreesCelsius"]},
					Replace[MeltingTemperatures] -> {Quantity[78.49775566012606`, "DegreesCelsius"],Quantity[86.71401003460747`, "DegreesCelsius"]}
				},
				ResolvedOptions -> {Method -> InflectionPoint, DataProcessing -> Fit, Upload -> False, SmoothingRadius -> 5, DataSet -> {MeltingCurve, CoolingCurve}},
				Round -> 3
			],
			TimeConstraint->300
		],

		Example[{Options, Domain, "Exclude from analysis any points outside the specified temperature domain:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Domain -> {50*Celsius, 80*Celsius},Upload->False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],
		Test["Exclude from analysis any points outside the specified temperature domain, Return Packet:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Domain -> {50*Celsius, 80*Celsius}, Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					MeanMeltingTemperature -> Quantity[64.420105, "DegreesCelsius"],
					Replace[MeltingTemperatures] -> {Quantity[64.04199, "DegreesCelsius"],Quantity[64.79822, "DegreesCelsius"]}
				},
				ResolvedOptions -> {
					Domain -> {50, 80},
					Range -> {0.09003236`, 0.1028803`},
					Method -> MidPoint,
					DataProcessing -> Smooth,
					SmoothingRadius -> 5,
					DataSet -> {MeltingCurve,CoolingCurve},
					PlotType -> MeltingPoint,
					ApplyAll -> False,
					Output ->	Result,
					Upload -> False,
					Template -> Null
				},
				Round -> 3
			],
			TimeConstraint->300
		],
		Example[{Options,Domain,"If units are not specified, Domain is assumed to be in Celsius:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Domain->{50,80},Upload->False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],


		Example[{Options, Range, "Exclude from analysis any points outside the specified measurand (in this case, absorbance) range:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Range -> {0, 0.9},Upload->False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],
		Test["Exclude from analysis any points outside the specified measured range (in this case, absorbance), Return Packet:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Range -> {0, 0.9}, Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					MeanMeltingTemperature -> Quantity[61.324020000000004, "DegreesCelsius"],
					Replace[MeltingTemperatures] -> {Quantity[62.28595000000001, "DegreesCelsius"],Quantity[60.36209, "DegreesCelsius"]}
				},
				ResolvedOptions -> {
					Domain -> {7.52`, 87.42`},
					Range -> {0, 0.9`},
					Method -> MidPoint,
					DataProcessing -> Smooth,
					SmoothingRadius -> 5,
					DataSet -> {MeltingCurve, CoolingCurve},
					PlotType -> MeltingPoint,
					ApplyAll -> False,
					Output -> Result,
					Upload -> False,
					Template -> Null},
				Round -> 2
			]
		],
		Example[{Options, Range, "If units are not specified, Range is assumed to be in ArbitraryUnit:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Range -> {0, 0.9}, Upload->False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],

		Example[{Options, DataSet, "Select the dataset to Analyze:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"], DataSet -> CoolingCurve, Upload->False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],

		Example[{Options, DataSet, "Select the dataset to Analyze using Field[] which works with nested fields as well:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"], DataSet -> Field[CoolingCurve], Upload->False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],

		Example[{Options, DataSetTransformationFunction, "Custom transformation function to manipulate the thermal response of a dataset:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"], DataSet -> {AggregationCurve, MeltingCurve3D, AggregationCurve}, DataSetTransformationFunction -> {None, BarycentricMean, responseChangeFunction}, Upload->False],
			TabView[{_String -> _?ValidGraphicsQ, _String -> _?ValidGraphicsQ}],
			EquivalenceFunction->MatchQ,
			TimeConstraint->300
		],

		Test["Select the dataset to Analyze, Return Packet:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"], DataSet -> CoolingCurve, Upload -> False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					MeanMeltingTemperature -> Quantity[76.15927, "DegreesCelsius"],
					Replace[MeltingTemperatures] -> {Quantity[76.15927, "DegreesCelsius"]}
				},
				ResolvedOptions -> {DataSet -> {CoolingCurve}, Upload -> False, Domain -> {6.32`,90.72`}, Range->{1.794097`,2.064242`}, Method -> MidPoint, DataProcessing -> Smooth, SmoothingRadius -> 5},
				NullFields -> {MeltingTemperatureStandardDeviation, MeltingTemperatureDistribution},
				NonNullFields -> {MeltingCurvesFractionBound},
				Round -> 3
			],
			TimeConstraint->300
		],

		Example[{Options,Wavelength,"Specify Automatic option for 3D melting/cooling data objects:"},
			PlotMeltingPoint[AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:wqW9BP7VMVkw"], DataSet -> {MeltingCurve3D, CoolingCurve3D}, Wavelength -> Automatic, Upload -> False]],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],

		Example[{Options,Wavelength,"Specify one wavelength (in Nanometers) for 3D melting/cooling data objects:"},
			PlotMeltingPoint[AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:wqW9BP7VMVkw"], DataSet -> {MeltingCurve3D, CoolingCurve3D}, Wavelength -> 280 Nanometer, Upload -> False]],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],

		Example[{Options,Wavelength,"Specify a wavelength range (in Nanometers) for 3D melting/cooling data objects:"},
			PlotMeltingPoint[AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:wqW9BP7VMVkw"], DataSet -> {MeltingCurve3D, CoolingCurve3D}, Wavelength -> 270 Nanometer ;; 290 Nanometer, Upload -> False]],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],

		Example[{Options,Wavelength,"Specify a wavelength range (in Nanometers) for a 3D melting curve for thermalshift protocol:"},
			PlotMeltingPoint[AnalyzeMeltingPoint[Download[Object[Protocol,ThermalShift,"id:wqW9BP7X5O1B"],Data][[1;;3]], DataSet -> {MeltingCurve3D}, Wavelength -> 270 Nanometer ;; 290 Nanometer, Upload -> False]],
			SlideView[{_?ValidGraphicsQ..}],
			TimeConstraint->300
		],

		Example[{Options,Wavelength,"Specify a wavelength range (in Nanometers) for a 3D protocol:"},
			PlotMeltingPoint[AnalyzeMeltingPoint[Object[Protocol, UVMelting, "id:L8kPEjnAP3Gw"], DataSet -> {MeltingCurve3D, CoolingCurve3D}, Wavelength -> 270 Nanometer ;; 290 Nanometer, Upload -> False]],
			SlideView[{_?ValidGraphicsQ..}],
			TimeConstraint->300
		],

		Example[{Options,Wavelength,"Specify a wavelength range (in Nanometers) for a 3D thermal shift dataset:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"],Method->Derivative, Wavelength -> 300 Nanometer ;; 420 Nanometer, Upload -> False][Replace[MeltingTemperatures]][[2]],
			79.91`*Celsius,
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,MeltingOnset,"Specify MeltingOnset to calculate the onset of melting temperature for AggregationCurveOnsetTemperature:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:6V0npvmNnvP8"], MeltingOnset->True, Upload -> False][Replace[MeltingOnsetTemperatures]][[1]],
			47.9259925311202`*Celsius,
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,MeltingOnset,"Specify the melting onset of melting and aggregation curves:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data,MeltingCurve,"id:1ZA60vLKEY5a"],MeltingOnset->True,Upload->False],
			_?ValidGraphicsQ,
			EquivalenceFunction->MatchQ
		],

		Example[{Options,MeltingOnsetPercent,"Specify a certain percentage of deviation from the initial flat region to indicate the melting onset (intensity rise):"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:6V0npvmNnvP8"], MeltingOnset->True, MeltingOnsetPercent -> 30 Percent, Upload -> False][Replace[MeltingOnsetTemperatures]][[1]],
			47.9259925311202`*Celsius,
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,SmoothingRadius,"Increase data smoothing before analysis:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"], DataSet -> {CoolingCurve}, SmoothingRadius->5, Upload -> False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],

		Example[{Options,PlotType,"Only plot the Derivative curve:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], PlotType -> Derivative, Output -> Preview],
			_,
			TimeConstraint->300
		],

		Example[{Options,Template,"Use options from previous melting point analysis:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Template->Object[Analysis,MeltingPoint,"id:vXl9j57l714D"],Upload->False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],
		Example[{Options,Template,"Explicitly specify Domain option, and pull remaining options from previous melting point analysis:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Template->Object[Analysis,MeltingPoint,"id:vXl9j57l714D"],Domain->{20,70},Upload->False],
			_?ValidGraphicsQ,
			TimeConstraint->300
		],
		Test["Explicitly specify Domain option, and pull remaining options from previous melting point analysis:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Upload->False,Template->Object[Analysis,MeltingPoint,"id:vXl9j57l714D"],Domain->{20.,70.}],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{Replace[MeltingTemperatures] -> {Quantity[57.44054912900049`, "DegreesCelsius"]}},
				ResolvedOptions -> {Template->Object[Analysis,MeltingPoint,"id:vXl9j57l714D"],Domain->{20.,70.}},
				Round -> 2
			],
			TimeConstraint->300
		],

		Example[{Options, Output, "Return only the melting temperature:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"], DataSet -> {CoolingCurve}, Upload -> False][MeanMeltingTemperature],
			Quantity[76.15927, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],
		Example[{Options, Output, "Return the melting temperatures from both the melting curve and cooling curve :"},
			Download[AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"],Output->Result],MeltingTemperatures],
			{Quantity[75.35480000000001, "DegreesCelsius"],Quantity[76.15927, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],
		Example[{Options, Upload, "Return the entire packet:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"], Upload -> False,Output->Result],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{
					MeanMeltingTemperature -> Quantity[75.757035`, "DegreesCelsius"],
					Replace[MeltingTemperatures] -> {Quantity[75.35480000000001`, "DegreesCelsius"], Quantity[76.15927`, "DegreesCelsius"]},
					Append[Reference] -> {Link[Object[Data, MeltingCurve, _String],MeltingAnalyses]}
				},
				Round -> 3
			],
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Example[{Options,TemperatureDataSet,"A set of objects, each containing a melting datapoint with the temperature stored at TemperatureDataSet:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1},TemperatureDataSet->Temperature, Upload -> False][MeanMeltingTemperature],
			{Quantity[60.`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Example[{Options,TemperatureDataSet,"A set of objects, each containing a melting datapoint with the temperature stored at TemperatureDataSet using Field[] which is intended for nested fields:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1},TemperatureDataSet->Field[Temperature], Upload -> False][MeanMeltingTemperature],
			{Quantity[60.`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Example[{Options,ResponseDataSet,"A set of objects, each containing a melting datapoint with the response stored at ResponseDataSet:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1},ResponseDataSet->Absorbance, Upload -> False][MeanMeltingTemperature],
			{Quantity[60.`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Example[{Options,ResponseDataSet,"A set of objects, each containing a melting datapoint with the response stored at ResponseDataSet using Field[] which is intended for nested fields:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1},ResponseDataSet->Field[Absorbance], Upload -> False][MeanMeltingTemperature],
			{Quantity[60.`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Example[{Options,TemperatureTransformationFunction,"Using TemperatureTransformationFunction to adjust the temperature data stored in TemperatureDataSet:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest2},TemperatureTransformationFunction->Function[x,x+0.5*Celsius], Upload -> False][MeanMeltingTemperature],
			{Quantity[45.5`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Example[{Options,ResponseTransformationFunction,"Using ResponseTransformationFunction to adjust the thermal response data stored in ResponseDataSet:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1},ResponseTransformationFunction->Function[x,x*200], Upload -> False][MeanMeltingTemperature],
			{Quantity[60.`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Example[{Options, StartPointThreshold, "Using StartPointThreshold to define the beginning of the melting process. It is for Object[Data, MeltingPoint] only:"},
			AnalyzeMeltingPoint[Object[Data, MeltingPoint, "Melting Point Mock data unit test 1" <> uuid], StartPointThreshold->0.2, Upload->False][PharmacopeiaStartPointTemperature],
			Quantity[234.427, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[2]
		],

		Example[{Options, MeniscusPointThreshold, "Using MeniscusPointThreshold to define the middle of the melting process. It is for Object[Data, MeltingPoint] only:"},
			AnalyzeMeltingPoint[Object[Data, MeltingPoint, "Melting Point Mock data unit test 1" <> uuid], MeniscusPointThreshold->0.6, Upload->False][PharmacopeiaMeniscusPointTemperature],
			Quantity[236.174, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[2]
		],

		Example[{Options, ClearPointSlopeThreshold, "Using ClearPointSlopeThreshold to define the endpoint of the melting process. It is for Object[Data, MeltingPoint] only:"},
			AnalyzeMeltingPoint[Object[Data, MeltingPoint, "Melting Point Mock data unit test 1" <> uuid], ClearPointSlopeThreshold->(0.003 Percent)/(Second), Upload->False][PharmacopeiaClearPointTemperature],
			Quantity[237.865, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[2]
		],

		Test[{Options, StartPointThreshold, "Change option value StartPointThreshold"},
			AnalyzeMeltingPoint[Object[Data, MeltingPoint, "Melting Point Mock data unit test 1" <> uuid], StartPointThreshold->0.2, Upload->False][PharmacopeiaStartPointTemperature],
			Quantity[234.427, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[2]
		],

		Test[{Options, MeniscusPointThreshold, "Change option value MeniscusPointThreshold"},
			AnalyzeMeltingPoint[Object[Data, MeltingPoint, "Melting Point Mock data unit test 1" <> uuid], MeniscusPointThreshold->0.6, Upload->False][PharmacopeiaMeniscusPointTemperature],
			Quantity[236.174, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[2]
		],

		Test[{Options, ClearPointSlopeThreshold, "Change option value ClearPointSlopeThreshold"},
			AnalyzeMeltingPoint[Object[Data, MeltingPoint, "Melting Point Mock data unit test 1" <> uuid], ClearPointSlopeThreshold->0.003/Second, Upload->False][PharmacopeiaClearPointTemperature],
			Quantity[237.865, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[2]
		],

		(* ---- Messages ---- *)

		Example[{Messages, "NonMatchingTransformationFunction", "Returns $Failed if DataSetTransformationFunctions length does not match that of DataSet:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"],Method -> Derivative, DataSet -> {MeltingCurve3D}, DataSetTransformationFunction -> {None, None}, Upload -> False],
			$Failed,
			Messages:>{
				Message[Error::NonMatchingTransformationFunction],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "DataSetDoesntExist", "Returns $Failed if the data set does not exist:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"], DataSet -> {MeltingCurve3}],
			$Failed,
			Messages:>{
				Message[Error::DataSetDoesntExist],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "DataSetDoesntExist", "Returns $Failed if the data set does not exist:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:O81aEB4kJ4Wo"], DataSet -> Field[Cooling]],
			$Failed,
			Messages:>{
				Message[Error::DataSetDoesntExist],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "ObjectDoesNotExist", "Returns $Failed if the object does not exist:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "object that is not available"]],
			$Failed,
			Messages:>{
				Message[Download::ObjectDoesNotExist],
				Message[Error::ObjectDoesNotExist]
			}
		],

		Example[{Messages, "InvalidTemperatureDataSet", "Returns $Failed if the TemperatureDataSet is not a valid field name:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1,absorbanceIntensityObjectsTest2,absorbanceIntensityObjectsTest1}, TemperatureDataSet -> {Taco,Taco,Automatic}],
			{$Failed, $Failed, ObjectP[Object[Analysis, MeltingPoint]]},
			Messages:>{
				Message[Error::InvalidTemperatureDataSet],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "InvalidTemperatureDataSet", "Returns $Failed if the TemperatureDataSet is not a valid field name using Field[]:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1,absorbanceIntensityObjectsTest2,absorbanceIntensityObjectsTest1}, TemperatureDataSet -> {Field[Taco],Taco,Automatic}],
			{$Failed, $Failed, ObjectP[Object[Analysis, MeltingPoint]]},
			Messages:>{
				Message[Error::InvalidTemperatureDataSet],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "InvalidResponseDataSet", "Returns $Failed if the ResponseDataSet is not a valid field name:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1}, ResponseDataSet -> Taco],
			{$Failed},
			Messages:>{
				Message[Error::InvalidResponseDataSet],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "InvalidResponseDataSet", "Returns $Failed if the ResponseDataSet is not a valid field name using Field[]:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1}, ResponseDataSet -> Field[Taco]],
			{$Failed},
			Messages:>{
				Message[Error::InvalidResponseDataSet],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "InvalidDataSet", "Returns $Failed if the data set does not have an acceptable melting curve pattern with temperature as the x-axis:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"], DataSet -> {MeltingCurve}],
			$Failed,
			Messages:>{
				Message[Error::InvalidDataSet],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "InvalidDataSet", "Return Null if input does not contain any suitable data for MeltingPoint analysis:"},
			AnalyzeMeltingPoint[<|Object -> Object[Data, MeltingCurve, "id:-1"], Type -> Object[Data, MeltingCurve], MeltingCurve -> {}, CoolingCurve -> {}, Wavelength -> Null|>, DataSet -> CoolingCurve, Upload -> False],
			$Failed,
			Messages:>{
				Message[Error::InvalidDataSet],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages, "InvalidTransformationFunction", "Returns $Failed if the transformed data set does not have an acceptable melting curve pattern with temperature as the x-axis:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"],Method -> Derivative, DataSet -> {MeltingCurve3D}, DataSetTransformationFunction -> {None}],
			$Failed,
			Messages:>{
				Message[Error::InvalidTransformationFunction],
				Message[Error::InvalidOption]
			}
		],

		Example[{Messages,"NoDataInDomainRange","Domain option excludes all data points:"},
			AnalyzeMeltingPoint[Table[{x,Sin[x]},{x,-2.,2,0.1}],Domain->{5,10},Upload->False],
			PacketP[],
			Messages:>{Message[Warning::NoDataInDomainRange]}
		],

		Example[{Messages, "MeltingPointOutOfDomain", "Melting point falls out of the input data domain:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:1ZA60vLAxlRa"],DataSet -> TertiaryMeltingCurve,Upload->False],
			PacketP[],
			Messages:>{Message[Warning::MeltingPointOutOfDomain]},
			TimeConstraint->300,
			Stubs:>{
				Analysis`Private`sigmoidMidPoint[___]:=110.
			}
		],

		Example[{Messages, "MeltingPointBadData", "Shape of the data curve is not as expected, which can lead to bad results:"},
			AnalyzeMeltingPoint[badMeltingCurve,Upload->False],
			PacketP[],
			Messages:>{Message[Warning::MeltingPointBadData]}
		],

		Example[{Messages, "SomeWavelengthsOutOfRange", "Some of the specified wavelengths are not within the wavelength range of the acquired data:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:wqW9BP7VMVkw"], Wavelength -> 198 Nanometer ;; 202 Nanometer, Upload -> False],
			PacketP[],
			Messages:>{
				Message[Warning::SomeWavelengthsOutOfRange,200.`,400.`]
			}
		],

		Example[{Messages, "AllWavelengthsOutOfRange", "All of the specified wavelengths are not within the wavelength range of the acquired data:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:wqW9BP7VMVkw"], Wavelength -> 198 Nanometer ;; 199 Nanometer, Upload -> False],
			PacketP[],
			Messages:>{
				Message[Warning::AllWavelengthsOutOfRange,200.`,400.`]
			}
		],

		Example[{Messages, "ObjectDoesNotContain3DCurves", "Object does not contain 3D curves, currently only Object[Protocol, UVMelting] and Object[Data, MeltingCurve] have 3D melting curves:"},
			AnalyzeMeltingPoint[Object[Data,MeltingCurve,"id:1ZA60vLKEY5a"], Wavelength -> 280 Nanometer, Upload -> False],
			PacketP[],
			Messages:>{Message[Warning::ObjectDoesNotContain3DCurves]}
		],

		Example[{Messages, "NoPacketsInInput", "Protocol does not contain any data packets:"},
			AnalyzeMeltingPoint[Object[Protocol, UVMelting, "id:zGj91aRrqR1E"], Upload -> False],
			$Failed,
			Messages:>{Message[Error::NoPacketsInInput]}
		],

		Example[
			{Messages,"UncertainMeltingOnset","Possible issue in finding melting onset due to using NonlinearModelFit, Interpolation, or FindRoot. Most of the time due to the assumption that the curve has a sigmoid-like shape:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vnOJKvw"], MeltingOnset->True, MeltingOnsetPercent -> 30 Percent, Upload -> False][Replace[MeltingOnsetTemperatures]][[1]],
			(*Mathematica 12.0/12.2 gives 38.647 or 53.387, 13.2 gives 53.231. On manifold, 12.0/12.2 gives 38.647 or 53.387, 13.2 gives 54.304.*)
			Alternatives[38.64716720581116`*Celsius,53.38696617558443`*Celsius,53.23095174154151`*Celsius, 54.30355850486331`*Celsius],
			EquivalenceFunction->RoundMatchQ[3],
			Stubs:>{
				Analysis`Private`meltingOnsetPointHelper[x_, y_, z_]:=Module[{}, Message[NonlinearModelFit::cvmit]; 53.231]
			},
			Messages:>{
				Message[Warning::UncertainMeltingOnset, AggregationCurve],
				Message[Warning::UncertainMeltingOnset, TransformedMeltingCurve3D]
			}
		],

		Example[
			{Messages,"InvalidTemperatureResponse","The temperature and response dataset should be valid fields within the object set:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest2},TemperatureDataSet -> Temperature, ResponseDataSet -> Null],
			{$Failed},
			TimeConstraint->300,
			Messages:>{
				Message[Error::InvalidTemperatureResponse],
				Message[Error::InvalidOption]
			}
		],

		Example[
			{Messages,"InvalidTransformedTemperature","After transformation of the temperature, the correct units of temperature should be preserved:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest2},TemperatureTransformationFunction->Function[x,x+0.5]],
			{$Failed},
			TimeConstraint->300,
			Messages:>{
				Message[Error::InvalidTransformedTemperature],
				Message[Error::InvalidOption]
			}
		],

		Example[
			{Messages,"InvalidTransformedResponse","After transformation of the response, the correct units of response should be preserved:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest2},ResponseTransformationFunction->Function[x,x+0.5]],
			{$Failed},
			TimeConstraint->300,
			Messages:>{
				Message[Error::InvalidTransformedResponse],
				Message[Error::InvalidOption]
			}
		],

		Example[
			{Messages,"InvalidTransformedResponse","After transformation the correct units of response should be preserved:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest2},ResponseTransformationFunction->Function[x,x+0.5]],
			{$Failed},
			TimeConstraint->300,
			Messages:>{
				Message[Error::InvalidTransformedResponse],
				Message[Error::InvalidOption]
			}
		],

		Example[
			{Messages,"UnusedDataSet","If temperature and response dataset are valid fields, DataSet is set to Null and warning is thrown if it is set as the option:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1},TemperatureDataSet -> Temperature, ResponseDataSet -> Absorbance, DataSet->MeltingCurve, Upload -> False][MeanMeltingTemperature],
			{Quantity[60.`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			Messages:>{Message[Warning::UnusedDataSet]}
		],

		Example[{Messages, "IncompatibleTransformation", "ThreeD to TwoD transformation can't be used for a 2D dataset, and it will be set to None:"},
			PlotMeltingPoint@AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"], DataSet -> {AggregationCurve}, DataSetTransformationFunction -> {BarycentricMean}, Upload->False],
			_?ValidGraphicsQ,
			EquivalenceFunction->MatchQ,
			TimeConstraint->300,
			Messages:>{
				Message[Warning::ObjectDoesNotContain3DCurves],
				Message[Warning::IncompatibleTransformation]
			}
		],

		Example[
			{Messages,"UnusedDataSetTransformation","If temperature and response dataset are valid fields, DataSetTransformationFunction is set to Null and warning is thrown if it is set as the option:"},
			AnalyzeMeltingPoint[{absorbanceIntensityObjectsTest1},TemperatureDataSet -> Temperature, ResponseDataSet -> Absorbance, DataSetTransformationFunction -> None, Upload->False][MeanMeltingTemperature],
			{Quantity[60.`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			Messages:>{Message[Warning::UnusedDataSetTransformation]}
		],

		Example[
			{Messages,"UnusedTemperatureTransformation","If temperature and response dataset are set to Null, TemperatureTransformationFunction will be unused:"},
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:7X104vndqXLk"], Method -> Derivative, DataSet -> MeltingCurve3D, TemperatureTransformationFunction -> Function[x,2*x], Upload->False][Replace[MeltingTemperatures]],
			{Quantity[80.59`, "DegreesCelsius"]},
			EquivalenceFunction->RoundMatchQ[3],
			Messages:>{Message[Warning::UnusedTemperatureTransformation]}
		],

		Example[
			{Messages,"FitIssue","If the temperature resolution in the melting curve is poor (few data points) and DataProcessing->Fit, this results in fit issue and a warning is thrown:"},
			AnalyzeMeltingPoint[poorMeltingCurve, DataProcessing->Fit, Upload->False][MeanMeltingTemperature],
			35.91932007178235`*Celsius,
			EquivalenceFunction->RoundMatchQ[3],
			Messages:>{Message[Warning::FitIssue]}
		],
		
		Example[
			{Messages,"NoMeltingCurveData","If the data object does not contain melting curve data, an error is thrown:"},
			AnalyzeMeltingPoint[<|Type -> Object[Data, MeltingCurve]|>],
			$Failed,
			Messages:>{Message[Error::NoMeltingCurveData]}
		],
		
		Example[
			{Messages,"NoqPCRMeltingCurvesData","For Object[Data, qPCR], if the MeltingCurves field does not contain melting curve data, an error is thrown:"},
			AnalyzeMeltingPoint[Object[Data,qPCR, "PlotqPCR test data 1" <> $SessionUUID]],
			$Failed,
			Messages:>{Message[Error::NoqPCRMeltingCurvesData]}
		],

		Example[
			{Messages,"InvalidAssayTypeForDLSProtocol","For Object[Protocol, DynamicLightScattering], if the AssayType field is not MeltingCurve, an error is thrown:"},
			AnalyzeMeltingPoint[Object[Protocol, DynamicLightScattering, "id:jLq9jXqP9o0W"]],
			$Failed,
			Messages:>{Message[Error::InvalidAssayTypeForDLSProtocol]}
		],

		(* ---- Tests ---- *)

		Test["Upload result:",
			AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"], Upload -> True],
			ObjectP[Object[Analysis,MeltingPoint]],
			TimeConstraint->300
		],

		Test["Method option changes answer:",
			SameQ@@{
				AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Method->MidPoint,Upload->False][MeanMeltingTemperature],
				AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Method->InflectionPoint,Upload->False][MeanMeltingTemperature]
			},
			False,
			TimeConstraint->300
		],
		Test["DataProcessing option changes answer:",
			SameQ@@{
				AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Method->MidPoint,DataProcessing->Smooth,Upload->False][MeanMeltingTemperature],
				AnalyzeMeltingPoint[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"],Method->MidPoint,DataProcessing->Fit,Upload->False][MeanMeltingTemperature]
			},
			False,
			TimeConstraint->300
		],
		Test["No error on non-reals:",
			AnalyzeMeltingPoint[Table[{x,Tanh[x-1]},{x,-10,10}],Upload->False][MeanMeltingTemperature],
			Quantity[0.9999993560187839, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Test["Given packet:",
			AnalyzeMeltingPoint[Download[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"]], Upload -> False][MeanMeltingTemperature],
			Quantity[61.324020000000004`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],
		Test["Given link:",
			AnalyzeMeltingPoint[Link[Object[Data, MeltingCurve, "id:KBL5DvYl3DRv"]], Upload -> False][MeanMeltingTemperature],
			Quantity[61.324020000000004`, "DegreesCelsius"],
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->300
		],

		Test["The input is Object[Data, MeltingCurve] and generated from DLSPlateReader, both DLS and SLS data are available",
			AnalyzeMeltingPoint[dlsMeltingCurveDataObj, Upload->False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{}
			],
			TimeConstraint->300,
			Messages:>{Warning::MeltingPointBadData}
		],
		Test["The input is Object[Data, MeltingCurve] and generated from DLSPlateReader, with only DLS data available",
			AnalyzeMeltingPoint[dlsMeltingCurveDataObjDLSOnly, Upload->False],
			validAnalysisPacketP[Object[Analysis, MeltingPoint],
				{}
			],
			TimeConstraint->300,
			Messages:>{Warning::MeltingPointBadData}
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	Variables :> {uuid},
	SymbolSetUp:>{

		$CreatedObjects={};

		(*test object for Object[Data, qPCR]*)
		Module[
			{
				asymptote1, asymptote2, logisticFunction, meltingCurveTest1, meltingCurveTest2,
				absorbanceIntensityPacketsTest1, absorbanceIntensityPacketsTest2
			},

			(* Gather and erase all pre-existing objects created in SymbolSetUp *)
			Module[
				{
					temperatureDataSetTest1,temperatureDataSetTest2,nameListTest1,nameListTest2,
					objectListTest1,objectListTest2,allDataObjects,allObjects,existingObjects,
					qPCRProtocol
				},
	
				(* The temperature dataset used for Test1 *)
				temperatureDataSetTest1=Range[20,100,5];
	
				(* The temperature dataset used for Test2 *)
				temperatureDataSetTest2=Range[10,80,5];
	
				(* The name of the object set Test1 *)
				nameListTest1=Map[("Analyze Melting Test " <> ToString[1] <> " Sample " <> ToString[#] <> $SessionUUID)&,Range[Length[temperatureDataSetTest1]]];
	
				(* The name of the object set Test2 *)
				nameListTest2=Map[("Analyze Melting Test " <> ToString[2] <> " Sample " <> ToString[#] <> $SessionUUID)&,Range[Length[temperatureDataSetTest2]]];
	
				(* All objects for Test1 *)
				objectListTest1=Map[Object[Data,AbsorbanceIntensity,#]&,nameListTest1];
	
				(* All objects for Test2 *)
				objectListTest2=Map[Object[Data,AbsorbanceIntensity,#]&,nameListTest2];
	
				(* All data objects generated for unit tests *)
				allDataObjects=Join[objectListTest1,objectListTest2];
	
				allObjects=allDataObjects;
	
				(* Check whether the names we want to give below already exist in the database *)
				existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
	
				(* Erase any test objects and models that we failed to erase in the last unit test *)
				Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
			];
	
			(* The function to produce a sigmoid behavior with the range of 0 and 1 *)
			asymptote1 = 0;
			asymptote2 = 1;
			logisticFunction=Function[{x,intercept,slope}, asymptote2+(asymptote1-asymptote2)/(1+Exp[slope*(intercept-x)])];
	
			(* A good melting curve with the range of 0 and 1 with intercept (melting temperature) 60 *)
			meltingCurveTest1 = Map[N[{#, logisticFunction[#, 60, 0.1]}]&, Range[20,100,5]];
	
			(* A good melting curve with the range of 0 and 1 with intercept (melting temperature) 45 *)
			meltingCurveTest2 = Map[N[{#, logisticFunction[#, 45, -0.1]}]&, Range[10,80,5]];
	
			(* The helper to generate the absorbance intensity objects *)
	
			absorbanceIntensityObjectHelper[meltingCurve_,testIndex_Integer,index_Integer] := Module[
				{temperature, response, name},
	
				(* The temperature value for each object *)
				temperature = meltingCurve[[index, 1]];
	
				(* The thermal response value for each object *)
				response = meltingCurve[[index, 2]];
	
				(* The name of the objects *)
				name = "Analyze Melting Test " <> ToString[testIndex] <> " Sample " <> ToString[index] <> $SessionUUID;
	
				<|
					Type -> Object[Data, AbsorbanceIntensity],
					Name -> name,
					Temperature -> temperature*Celsius,
					Absorbance -> response*AbsorbanceUnit
				|>
			];
	
			(* Format Absorbance intensity packets corresponding to the meltingCurveTest1 *)
			absorbanceIntensityPacketsTest1=Map[
				absorbanceIntensityObjectHelper[meltingCurveTest1,1,#]&, Range[Length[meltingCurveTest1]]
			];
	
			(* Upload test AbsorbanceIntensity data objects for Test1 *)
			absorbanceIntensityObjectsTest1=Upload[absorbanceIntensityPacketsTest1];
	
			(* Format Absorbance intensity packets corresponding to the meltingCurveTest1 *)
			absorbanceIntensityPacketsTest2=Map[
				absorbanceIntensityObjectHelper[meltingCurveTest2,2,#]&, Range[Length[meltingCurveTest2]]
			];
	
			(* Upload test AbsorbanceIntensity data objects for Test1 *)
			absorbanceIntensityObjectsTest2=Upload[absorbanceIntensityPacketsTest2];
			
			badChromatographyObject = Upload[<|Type -> Object[Data, Chromatography]|>];
			
			(* upload qPCR data for testing *)
			qPCRProtocol = Upload[<|Type->Object[Protocol, qPCR]|>];
			
			(*Make test data objects*)
			Upload[{
				<|
					Type->Object[Data,qPCR],
					Name->"PlotqPCR test data 1" <> $SessionUUID,
					(* Replace[SamplesIn]->Link[Object[Sample,"Test Template 1 for PlotqPCR"],Data],
					Replace[Primers]->Join[{{Link[Object[Sample,"Test Primer 1 Forward for PlotqPCR"]],Link[Object[Sample,"Test Primer 1 Reverse for PlotqPCR"]]}},ConstantArray[{Null,Null},20]],
					Replace[Probes]->PadRight[{Link[Object[Sample,"Test Probe 1 for PlotqPCR"]]},21,Null], *)
					Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
					Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
					Replace[AmplificationCurveTypes]->PadRight[{PrimaryAmplicon,Unused,Unused,Unused,Unused,Unused,PassiveReference},21,Unused],
					Replace[AmplificationCurves]->PadRight[{QuantityArray[{{1,0.838366},{2,0.867461},{3,0.882255},{4,0.887922},{5,0.8991},{6,0.908386},{7,0.915779},{8,0.922756},{9,0.929573},{10,0.93254},{11,0.941931},{12,0.954241},{13,0.963869},{14,0.966802},{15,0.979435},{16,0.993327},{17,1.02214},{18,1.06643},{19,1.14886},{20,1.29975},{21,1.56968},{22,1.95918},{23,2.38847},{24,2.78532},{25,3.16301},{26,3.53637},{27,3.89258},{28,4.20981},{29,4.47358},{30,4.7301},{31,4.96325},{32,5.17179},{33,5.33801},{34,5.50773},{35,5.65007},{36,5.77216},{37,5.92374},{38,6.01616},{39,6.12867},{40,6.21872}},{None,RFU}]},21,{QuantityArray[MapThread[{#1,#2}&,{Range[40],ConstantArray[1,40]}],{None,RFU}]}],
					Protocol->Link[qPCRProtocol, StandardData],
					DeveloperObject->True
				|>,
				<|
					Type->Object[Data,qPCR],
					Name->"PlotqPCR test data 2" <> $SessionUUID,
					(* Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for PlotqPCR"],Data],
					Replace[Primers]->PadRight[{{Null,Null},{Link[Object[Sample,"Test Primer 2 Forward for PlotqPCR"]],Link[Object[Sample,"Test Primer 2 Reverse for PlotqPCR"]]}},21,{{Null,Null}}],
					Replace[Probes]->ConstantArray[Null,21], *)
					Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
					Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
					Replace[AmplificationCurveTypes]->PadRight[{Unused,PrimaryAmplicon,Unused,Unused,Unused,Unused,PassiveReference},21,Unused],
					Replace[MeltingCurves]->QuantityArray[Transpose[{Range[50,70], {5.1596515399263385`,4.989083931825994`,4.585520827419312`,4.45792280963086`,4.1030606761816815`,3.9440080265281767`,3.661881164703322`,3.5426345581012306`,3.338099733969894`,3.074826762453064`,2.764096916180067`,2.4379521056792566`,2.3338071933027598`,1.9519166783189754`,1.7776523754153875`,1.6079924947567148`,1.1150241132692387`,1.0934485728595895`,0.838874165165215`,0.3900038683644859`,0.3642343459741698`}}], {Celsius, RFU}],
					Protocol->Link[qPCRProtocol, StandardData],
					DeveloperObject->True
				|>
			}];
			
		];

		(*test object for data generated from Object[Instrument, MultimodeSpectrophotometer] or Object[Instrument, DLSPlateReader]*)
		Module[{
			uncleInstrument, dynaproInstrument, meltingCurve, coolingCurve, secondaryMeltingCurve, secondaryCoolingCurve,
			tertiaryMeltingCurve, tertiaryCoolingCurve, estimatedMolecularWeights
		},
			uncleInstrument = Link[Object[Instrument, MultimodeSpectrophotometer, "id:P5ZnEjd9bjM4"], "9RdZXvRMeJ1l"];
			dynaproInstrument = Link[Object[Instrument, DLSPlateReader, "id:M8n3rxnpZE38"], "9RdZXvRMeJ1l"];
			{
				meltingCurve,
				coolingCurve,
				secondaryMeltingCurve,
				secondaryCoolingCurve,
				tertiaryMeltingCurve,
				tertiaryCoolingCurve
			} =
					Download[Object[Data, MeltingCurve, "id:M8n3rx0nne4P"], {
						MeltingCurve,
						CoolingCurve,
						SecondaryMeltingCurve,
						SecondaryCoolingCurve,
						TertiaryMeltingCurve,
						TertiaryCoolingCurve
					}];
			estimatedMolecularWeights = {{Quantity[5.52`, "DegreesCelsius"], Quantity[542.851`, ("Grams") / ("Moles")]}, {Quantity[6.02`, "DegreesCelsius"], Quantity[542.0835000000001`, ("Grams") / ("Moles")]}, {Quantity[6.72`, "DegreesCelsius"], Quantity[542.6345`, ("Grams") / ("Moles")]}, {Quantity[7.57`, "DegreesCelsius"], Quantity[541.6714999999999`, ("Grams") / ("Moles")]}, {Quantity[8.52`, "DegreesCelsius"], Quantity[542.8634999999999`, ("Grams") / ("Moles")]}, {Quantity[9.42`, "DegreesCelsius"], Quantity[542.2705`, ("Grams") / ("Moles")]}, {Quantity[10.37`, "DegreesCelsius"], Quantity[543.021`, ("Grams") / ("Moles")]}, {Quantity[11.32`, "DegreesCelsius"], Quantity[543.8685`, ("Grams") / ("Moles")]}, {Quantity[12.27`, "DegreesCelsius"], Quantity[543.064`, ("Grams") / ("Moles")]}, {Quantity[13.22`, "DegreesCelsius"], Quantity[543.9435`, ("Grams") / ("Moles")]}, {Quantity[14.22`, "DegreesCelsius"], Quantity[543.3765`, ("Grams") / ("Moles")]}, {Quantity[15.17`, "DegreesCelsius"], Quantity[543.732`, ("Grams") / ("Moles")]}, {Quantity[16.12`, "DegreesCelsius"], Quantity[543.3945`, ("Grams") / ("Moles")]}, {Quantity[17.07`, "DegreesCelsius"], Quantity[543.2955`, ("Grams") / ("Moles")]}, {Quantity[18.02`, "DegreesCelsius"], Quantity[543.778`, ("Grams") / ("Moles")]}, {Quantity[18.92`, "DegreesCelsius"], Quantity[543.8995`, ("Grams") / ("Moles")]}, {Quantity[19.87`, "DegreesCelsius"], Quantity[543.575`, ("Grams") / ("Moles")]}, {Quantity[20.82`, "DegreesCelsius"], Quantity[544.3155`, ("Grams") / ("Moles")]}, {Quantity[21.77`, "DegreesCelsius"], Quantity[545.7814999999999`, ("Grams") / ("Moles")]}, {Quantity[22.82`, "DegreesCelsius"], Quantity[544.0065000000001`, ("Grams") / ("Moles")]}, {Quantity[23.67`, "DegreesCelsius"], Quantity[544.3175`, ("Grams") / ("Moles")]}, {Quantity[24.62`, "DegreesCelsius"], Quantity[545.885`, ("Grams") / ("Moles")]}, {Quantity[25.62`, "DegreesCelsius"], Quantity[545.8215`, ("Grams") / ("Moles")]}, {Quantity[26.52`, "DegreesCelsius"], Quantity[545.8805`, ("Grams") / ("Moles")]}, {Quantity[27.47`, "DegreesCelsius"], Quantity[546.2845`, ("Grams") / ("Moles")]}, {Quantity[28.42`, "DegreesCelsius"], Quantity[546.345`, ("Grams") / ("Moles")]}, {Quantity[29.37`, "DegreesCelsius"], Quantity[547.7420000000001`, ("Grams") / ("Moles")]}, {Quantity[30.37`, "DegreesCelsius"], Quantity[547.895`, ("Grams") / ("Moles")]}, {Quantity[31.32`, "DegreesCelsius"], Quantity[548.2165`, ("Grams") / ("Moles")]}, {Quantity[32.22`, "DegreesCelsius"], Quantity[548.9985`, ("Grams") / ("Moles")]}, {Quantity[33.12`, "DegreesCelsius"], Quantity[548.41`, ("Grams") / ("Moles")]}, {Quantity[34.12`, "DegreesCelsius"], Quantity[549.9845`, ("Grams") / ("Moles")]}, {Quantity[35.07`, "DegreesCelsius"], Quantity[550.029`, ("Grams") / ("Moles")]}, {Quantity[36.02`, "DegreesCelsius"], Quantity[550.085`, ("Grams") / ("Moles")]}, {Quantity[36.92`, "DegreesCelsius"], Quantity[551.223`, ("Grams") / ("Moles")]}, {Quantity[37.92`, "DegreesCelsius"], Quantity[551.605`, ("Grams") / ("Moles")]}, {Quantity[38.77`, "DegreesCelsius"], Quantity[552.799`, ("Grams") / ("Moles")]}, {Quantity[39.77`, "DegreesCelsius"], Quantity[552.864`, ("Grams") / ("Moles")]}, {Quantity[40.67`, "DegreesCelsius"], Quantity[553.312`, ("Grams") / ("Moles")]}, {Quantity[41.57`, "DegreesCelsius"], Quantity[554.468`, ("Grams") / ("Moles")]}, {Quantity[42.57`, "DegreesCelsius"], Quantity[555.577`, ("Grams") / ("Moles")]}, {Quantity[43.57`, "DegreesCelsius"], Quantity[556.7529999999999`, ("Grams") / ("Moles")]}, {Quantity[44.52`, "DegreesCelsius"], Quantity[557.1804999999999`, ("Grams") / ("Moles")]}, {Quantity[45.37`, "DegreesCelsius"], Quantity[558.4135`, ("Grams") / ("Moles")]}, {Quantity[46.37`, "DegreesCelsius"], Quantity[559.462`, ("Grams") / ("Moles")]}, {Quantity[47.27`, "DegreesCelsius"], Quantity[559.1614999999999`, ("Grams") / ("Moles")]}, {Quantity[48.27`, "DegreesCelsius"], Quantity[560.163`, ("Grams") / ("Moles")]}, {Quantity[49.12`, "DegreesCelsius"], Quantity[561.1875`, ("Grams") / ("Moles")]}, {Quantity[50.07`, "DegreesCelsius"], Quantity[561.823`, ("Grams") / ("Moles")]}, {Quantity[51.02`, "DegreesCelsius"], Quantity[561.9955`, ("Grams") / ("Moles")]}, {Quantity[51.97`, "DegreesCelsius"], Quantity[563.5485`, ("Grams") / ("Moles")]}, {Quantity[52.92`, "DegreesCelsius"], Quantity[563.398`, ("Grams") / ("Moles")]}, {Quantity[53.92`, "DegreesCelsius"], Quantity[563.8935`, ("Grams") / ("Moles")]}, {Quantity[54.77`, "DegreesCelsius"], Quantity[563.7325`, ("Grams") / ("Moles")]}, {Quantity[55.77`, "DegreesCelsius"], Quantity[565.334`, ("Grams") / ("Moles")]}, {Quantity[56.72`, "DegreesCelsius"], Quantity[566.6865`, ("Grams") / ("Moles")]}, {Quantity[57.57`, "DegreesCelsius"], Quantity[566.727`, ("Grams") / ("Moles")]}, {Quantity[58.57`, "DegreesCelsius"], Quantity[568.341`, ("Grams") / ("Moles")]}, {Quantity[59.52`, "DegreesCelsius"], Quantity[567.095`, ("Grams") / ("Moles")]}, {Quantity[60.37`, "DegreesCelsius"], Quantity[568.955`, ("Grams") / ("Moles")]}, {Quantity[61.37`, "DegreesCelsius"], Quantity[568.462`, ("Grams") / ("Moles")]}, {Quantity[62.32`, "DegreesCelsius"], Quantity[570.7555`, ("Grams") / ("Moles")]}, {Quantity[63.17`, "DegreesCelsius"], Quantity[570.5855`, ("Grams") / ("Moles")]}, {Quantity[64.12`, "DegreesCelsius"], Quantity[571.9515`, ("Grams") / ("Moles")]}, {Quantity[65.12`, "DegreesCelsius"], Quantity[572.3595`, ("Grams") / ("Moles")]}, {Quantity[66.02`, "DegreesCelsius"], Quantity[574.2379999999999`, ("Grams") / ("Moles")]}, {Quantity[66.92`, "DegreesCelsius"], Quantity[573.64`, ("Grams") / ("Moles")]}, {Quantity[67.92`, "DegreesCelsius"], Quantity[574.414`, ("Grams") / ("Moles")]}, {Quantity[68.82`, "DegreesCelsius"], Quantity[574.6665`, ("Grams") / ("Moles")]}, {Quantity[69.77`, "DegreesCelsius"], Quantity[576.1605000000001`, ("Grams") / ("Moles")]}, {Quantity[70.67`, "DegreesCelsius"], Quantity[577.1915`, ("Grams") / ("Moles")]}, {Quantity[71.57`, "DegreesCelsius"], Quantity[577.971`, ("Grams") / ("Moles")]}, {Quantity[72.57`, "DegreesCelsius"], Quantity[578.8539999999999`, ("Grams") / ("Moles")]}, {Quantity[73.47`, "DegreesCelsius"], Quantity[579.887`, ("Grams") / ("Moles")]}, {Quantity[74.47`, "DegreesCelsius"], Quantity[577.6045`, ("Grams") / ("Moles")]}, {Quantity[75.32`, "DegreesCelsius"], Quantity[580.005`, ("Grams") / ("Moles")]}, {Quantity[76.27`, "DegreesCelsius"], Quantity[578.969`, ("Grams") / ("Moles")]}, {Quantity[77.17`, "DegreesCelsius"], Quantity[577.9970000000001`, ("Grams") / ("Moles")]}, {Quantity[78.12`, "DegreesCelsius"], Quantity[578.43`, ("Grams") / ("Moles")]}, {Quantity[78.97`, "DegreesCelsius"], Quantity[579.2535`, ("Grams") / ("Moles")]}, {Quantity[79.92`, "DegreesCelsius"], Quantity[579.8405`, ("Grams") / ("Moles")]}, {Quantity[80.77`, "DegreesCelsius"], Quantity[580.34`, ("Grams") / ("Moles")]}, {Quantity[81.77`, "DegreesCelsius"], Quantity[580.6614999999999`, ("Grams") / ("Moles")]}, {Quantity[82.67`, "DegreesCelsius"], Quantity[582.7545`, ("Grams") / ("Moles")]}, {Quantity[83.62`, "DegreesCelsius"], Quantity[582.0405`, ("Grams") / ("Moles")]}, {Quantity[84.57`, "DegreesCelsius"], Quantity[584.4485`, ("Grams") / ("Moles")]}, {Quantity[85.52`, "DegreesCelsius"], Quantity[583.2885`, ("Grams") / ("Moles")]}, {Quantity[86.42`, "DegreesCelsius"], Quantity[582.757`, ("Grams") / ("Moles")]}, {Quantity[87.37`, "DegreesCelsius"], Quantity[584.3205`, ("Grams") / ("Moles")]}, {Quantity[88.17`, "DegreesCelsius"], Quantity[585.703`, ("Grams") / ("Moles")]}, {Quantity[89.12`, "DegreesCelsius"], Quantity[581.7205`, ("Grams") / ("Moles")]}};

			dlsMeltingCurveDataObj = <|
				Type -> Object[Data, MeltingCurve],
				Object -> Object[Data, MeltingCurve, "test DLS MeltingCurve data"],
				Instrument -> dynaproInstrument,
				Protocol -> Object[Protocol, DynamicLightScattering, "test protocol"],
				Protocol[AssayType] -> MeltingCurve,
				EstimatedMolecularWeights -> estimatedMolecularWeights,
				DLSHeatingCurve -> meltingCurve,
				DLSCoolingCurve -> coolingCurve,
				SecondaryDLSHeatingCurve -> secondaryMeltingCurve,
				SecondaryDLSCoolingCurve -> secondaryCoolingCurve,
				TertiaryDLSHeatingCurve -> tertiaryMeltingCurve,
				TertiaryDLSCoolingCurve -> tertiaryCoolingCurve
			|>;

			dlsMeltingCurveDataObjDLSOnly = <|
				Type -> Object[Data, MeltingCurve],
				Object -> Object[Data, MeltingCurve, "test DLS MeltingCurve data"],
				Instrument -> dynaproInstrument,
				Protocol -> Object[Protocol, DynamicLightScattering, "test protocol"],
				Protocol[AssayType] -> MeltingCurve,
				DLSHeatingCurve -> meltingCurve,
				DLSCoolingCurve -> coolingCurve,
				SecondaryDLSHeatingCurve -> secondaryMeltingCurve,
				SecondaryDLSCoolingCurve -> secondaryCoolingCurve,
				TertiaryDLSHeatingCurve -> tertiaryMeltingCurve,
				TertiaryDLSCoolingCurve -> tertiaryCoolingCurve
			|>
		];

		(*test data object for Object[Data, MeltingPoint]*)
		Module[
			{
				line1Value, line2Value, line3Value, quantityLine1, quantityLine2, quantityLine3, videoFile,
				meltingPointData1, uploadVideo
			},
			uuid = CreateUUID[];

			line1Value = {{234.04`,-0.00972006`},{234.051`,-0.00486003`},{234.061`,0.00486003`},{234.07`,0.0170101`},{234.078`,0.0315902`},{234.085`,0.0461703`},{234.092`,0.0583204`},{234.098`,0.0680404`},{234.105`,0.0729005`},{234.112`,0.0729005`},{234.12`,0.0680404`},{234.129`,0.0607504`},{234.14`,0.0510303`},{234.152`,0.0437403`},{234.165`,0.0388802`},{234.178`,0.0364502`},{234.192`,0.0364502`},{234.205`,0.0388802`},{234.218`,0.0413103`},{234.231`,0.0413103`},{234.242`,0.0413103`},{234.253`,0.0437403`},{234.262`,0.0461703`},{234.272`,0.0534603`},{234.28`,0.0607504`},{234.288`,0.0729005`},{234.295`,0.0850505`},{234.302`,0.0972006`},{234.309`,0.106921`},{234.315`,0.111781`},{234.32`,0.114211`},{234.326`,0.111781`},{234.331`,0.109351`},{234.337`,0.106921`},{234.342`,0.104491`},{234.347`,0.102061`},{234.353`,0.102061`},{234.358`,0.102061`},{234.363`,0.104491`},{234.368`,0.109351`},{234.373`,0.114211`},{234.378`,0.121501`},{234.383`,0.128791`},{234.387`,0.138511`},{234.392`,0.148231`},{234.397`,0.157951`},{234.402`,0.165241`},{234.407`,0.172531`},{234.412`,0.177391`},{234.417`,0.184681`},{234.422`,0.194401`},{234.427`,0.201691`},{234.433`,0.213841`},{234.438`,0.225991`},{234.444`,0.238142`},{234.45`,0.250292`},{234.456`,0.262442`},{234.462`,0.269732`},{234.468`,0.279452`},{234.474`,0.286742`},{234.481`,0.294032`},{234.487`,0.301322`},{234.493`,0.306182`},{234.5`,0.308612`},{234.506`,0.311042`},{234.513`,0.311042`},{234.52`,0.308612`},{234.526`,0.308612`},{234.533`,0.306182`},{234.54`,0.306182`},{234.548`,0.311042`},{234.555`,0.315902`},{234.563`,0.320762`},{234.57`,0.328052`},{234.578`,0.332912`},{234.586`,0.335342`},{234.593`,0.332912`},{234.601`,0.330482`},{234.609`,0.325622`},{234.617`,0.323192`},{234.625`,0.320762`},{234.633`,0.320762`},{234.641`,0.323192`},{234.649`,0.328052`},{234.657`,0.332912`},{234.665`,0.337772`},{234.673`,0.342632`},{234.681`,0.342632`},{234.688`,0.342632`},{234.696`,0.340202`},{234.704`,0.335342`},{234.713`,0.330482`},{234.721`,0.325622`},{234.729`,0.320762`},{234.738`,0.315902`},{234.746`,0.308612`},{234.754`,0.306182`},{234.763`,0.301322`},{234.771`,0.298892`},{234.78`,0.296462`},{234.788`,0.296462`},{234.796`,0.294032`},{234.805`,0.294032`},{234.813`,0.291602`},{234.821`,0.291602`},{234.83`,0.286742`},{234.838`,0.281882`},{234.847`,0.277022`},{234.856`,0.267302`},{234.865`,0.260012`},{234.874`,0.250292`},{234.882`,0.243002`},{234.891`,0.238142`},{234.899`,0.233281`},{234.908`,0.233281`},{234.916`,0.233281`},{234.925`,0.233281`},{234.933`,0.233281`},{234.942`,0.235712`},{234.95`,0.238142`},{234.958`,0.240572`},{234.967`,0.243002`},{234.975`,0.245432`},{234.983`,0.250292`},{234.991`,0.250292`},{234.999`,0.252722`},{235.007`,0.252722`},{235.015`,0.252722`},{235.023`,0.255152`},{235.031`,0.257582`},{235.04`,0.262442`},{235.048`,0.264872`},{235.056`,0.267302`},{235.064`,0.269732`},{235.072`,0.269732`},{235.081`,0.272162`},{235.089`,0.272162`},{235.097`,0.272162`},{235.106`,0.274592`},{235.114`,0.279452`},{235.123`,0.284312`},{235.132`,0.289172`},{235.14`,0.296462`},{235.149`,0.303752`},{235.158`,0.311042`},{235.166`,0.318332`},{235.174`,0.325622`},{235.183`,0.328052`},{235.191`,0.328052`},{235.2`,0.328052`},{235.208`,0.325622`},{235.216`,0.320762`},{235.224`,0.318332`},{235.232`,0.318332`},{235.24`,0.318332`},{235.248`,0.320762`},{235.257`,0.323192`},{235.265`,0.328052`},{235.273`,0.332912`},{235.281`,0.335342`},{235.289`,0.337772`},{235.298`,0.335342`},{235.306`,0.332912`},{235.314`,0.330482`},{235.323`,0.330482`},{235.331`,0.330482`},{235.339`,0.335342`},{235.348`,0.342632`},{235.356`,0.349922`},{235.365`,0.354782`},{235.374`,0.359642`},{235.382`,0.362072`},{235.391`,0.364502`},{235.399`,0.366932`},{235.407`,0.369362`},{235.415`,0.371792`},{235.423`,0.374222`},{235.431`,0.374222`},{235.439`,0.371792`},{235.447`,0.366932`},{235.455`,0.362072`},{235.463`,0.359642`},{235.471`,0.357212`},{235.479`,0.357212`},{235.486`,0.359642`},{235.494`,0.364502`},{235.502`,0.369362`},{235.511`,0.371792`},{235.519`,0.376652`},{235.527`,0.376652`},{235.535`,0.379082`},{235.544`,0.376652`},{235.553`,0.374222`},{235.561`,0.369362`},{235.57`,0.362072`},{235.578`,0.352352`},{235.587`,0.345062`},{235.595`,0.335342`},{235.604`,0.328052`},{235.612`,0.323192`},{235.621`,0.323192`},{235.629`,0.323192`},{235.637`,0.325622`},{235.645`,0.325622`},{235.653`,0.325622`},{235.661`,0.323192`},{235.669`,0.320762`},{235.676`,0.318332`},{235.684`,0.315902`},{235.692`,0.315902`},{235.7`,0.315902`},{235.708`,0.315902`},{235.716`,0.313472`},{235.725`,0.311042`},{235.733`,0.303752`},{235.741`,0.296462`},{235.749`,0.289172`},{235.757`,0.281882`},{235.765`,0.277022`},{235.773`,0.274592`},{235.782`,0.272162`},{235.79`,0.272162`},{235.798`,0.274592`},{235.806`,0.277022`},{235.815`,0.279452`},{235.823`,0.279452`},{235.831`,0.281882`},{235.839`,0.284312`},{235.847`,0.284312`},{235.855`,0.286742`},{235.863`,0.286742`},{235.871`,0.289172`},{235.88`,0.291602`},{235.888`,0.296462`},{235.897`,0.303752`},{235.905`,0.311042`},{235.913`,0.318332`},{235.922`,0.323192`},{235.931`,0.328052`},{235.939`,0.332912`},{235.948`,0.332912`},{235.956`,0.332912`},{235.965`,0.335342`},{235.974`,0.335342`},{235.982`,0.340202`},{235.991`,0.347492`},{235.999`,0.354782`},{236.007`,0.362072`},{236.016`,0.371792`},{236.024`,0.379082`},{236.032`,0.386372`},{236.04`,0.391233`},{236.048`,0.398523`},{236.057`,0.405813`},{236.065`,0.415533`},{236.073`,0.427683`},{236.082`,0.442263`},{236.09`,0.456843`},{236.099`,0.473853`},{236.107`,0.490863`},{236.115`,0.507873`},{236.124`,0.524883`},{236.132`,0.539463`},{236.141`,0.554044`},{236.149`,0.568624`},{236.158`,0.583204`},{236.166`,0.597784`},{236.174`,0.612364`},{236.183`,0.629374`},{236.191`,0.648814`},{236.199`,0.670684`},{236.207`,0.694984`},{236.215`,0.719285`},{236.223`,0.746015`},{236.231`,0.767885`},{236.24`,0.789755`},{236.248`,0.809195`},{236.256`,0.828635`},{236.264`,0.845645`},{236.272`,0.862656`},{236.281`,0.884526`},{236.289`,0.906396`},{236.298`,0.928266`},{236.306`,0.954996`},{236.315`,0.979296`},{236.323`,1.00603`},{236.332`,1.03276`},{236.34`,1.06192`},{236.348`,1.08865`},{236.357`,1.11538`},{236.365`,1.14211`},{236.373`,1.16641`},{236.382`,1.19071`},{236.39`,1.21501`},{236.399`,1.23688`},{236.407`,1.25632`},{236.416`,1.27576`},{236.424`,1.2952`},{236.433`,1.31464`},{236.441`,1.33408`},{236.45`,1.35595`},{236.458`,1.37782`},{236.466`,1.39969`},{236.474`,1.42399`},{236.482`,1.44586`},{236.49`,1.47016`},{236.498`,1.49446`},{236.506`,1.51633`},{236.514`,1.54063`},{236.522`,1.5625`},{236.531`,1.58437`},{236.539`,1.60381`},{236.548`,1.62082`},{236.556`,1.6354`},{236.565`,1.64998`},{236.573`,1.66456`},{236.581`,1.67671`},{236.59`,1.69129`},{236.598`,1.70344`},{236.606`,1.71316`},{236.614`,1.72045`},{236.622`,1.72531`},{236.63`,1.73017`},{236.639`,1.7326`},{236.647`,1.73503`},{236.655`,1.74232`},{236.664`,1.75447`},{236.672`,1.76905`},{236.681`,1.78606`},{236.689`,1.80793`},{236.697`,1.82737`},{236.705`,1.84924`},{236.714`,1.87111`},{236.722`,1.89055`},{236.73`,1.90999`},{236.738`,1.92943`},{236.746`,1.9513`},{236.754`,1.97803`},{236.763`,2.00962`},{236.771`,2.04607`},{236.78`,2.08981`},{236.788`,2.14084`},{236.797`,2.19673`},{236.805`,2.25748`},{236.814`,2.32066`},{236.822`,2.38628`},{236.831`,2.45432`},{236.84`,2.52722`},{236.848`,2.60498`},{236.857`,2.6876`},{236.865`,2.77265`},{236.874`,2.86499`},{236.882`,2.9549`},{236.89`,3.04238`},{236.897`,3.12257`},{236.905`,3.18818`},{236.912`,3.24164`},{236.92`,3.27566`},{236.928`,3.2951`},{236.936`,3.29996`},{236.945`,3.29753`},{236.953`,3.29024`},{236.962`,3.28295`},{236.97`,3.28052`},{236.979`,3.28538`},{236.987`,3.2951`},{236.996`,3.31454`},{237.005`,3.34127`},{237.013`,3.37772`},{237.022`,3.42146`},{237.031`,3.4652`},{237.039`,3.50651`},{237.048`,3.54053`},{237.056`,3.5624`},{237.065`,3.57212`},{237.073`,3.57941`},{237.082`,3.58913`},{237.09`,3.61343`},{237.099`,3.6596`},{237.107`,3.73007`},{237.115`,3.82241`},{237.124`,3.92934`},{237.132`,4.04598`},{237.14`,4.15047`},{237.149`,4.23795`},{237.157`,4.29384`},{237.166`,4.31571`},{237.174`,4.30356`},{237.182`,4.26225`},{237.19`,4.2015`},{237.197`,4.13832`},{237.205`,4.08486`},{237.213`,4.05084`},{237.22`,4.04841`},{237.228`,4.08486`},{237.236`,4.16991`},{237.244`,4.31328`},{237.252`,4.52712`},{237.26`,4.81143`},{237.269`,5.16621`},{237.278`,5.57932`},{237.287`,6.02887`},{237.296`,6.48571`},{237.305`,6.92068`},{237.315`,7.30706`},{237.323`,7.62539`},{237.332`,7.87325`},{237.34`,8.05307`},{237.349`,8.18429`},{237.357`,8.28149`},{237.365`,8.3714`},{237.373`,8.46374`},{237.381`,8.57309`},{237.39`,8.69946`},{237.398`,8.83797`},{237.407`,8.98134`},{237.415`,9.12957`},{237.423`,9.28509`},{237.432`,9.45762`},{237.44`,9.66417`},{237.448`,9.93147`},{237.456`,10.2863`},{237.464`,10.7552`},{237.472`,11.3603`},{237.481`,12.1161`},{237.489`,13.0297`},{237.497`,14.1062`},{237.505`,15.3383`},{237.513`,16.7064`},{237.522`,18.1838`},{237.53`,19.739`},{237.537`,21.3404`},{237.545`,22.9734`},{237.554`,24.6428`},{237.562`,26.373`},{237.57`,28.1882`},{237.578`,30.1103`},{237.586`,32.1637`},{237.594`,34.3628`},{237.602`,36.7078`},{237.611`,39.201`},{237.619`,41.8327`},{237.628`,44.5932`},{237.636`,47.4752`},{237.644`,50.486`},{237.653`,53.6572`},{237.661`,57.0325`},{237.67`,60.6556`},{237.678`,64.5631`},{237.687`,68.7427`},{237.696`,73.141`},{237.704`,77.6268`},{237.712`,82.0349`},{237.721`,86.1854`},{237.729`,89.9179`},{237.737`,93.1231`},{237.746`,95.7523`},{237.754`,97.8178`},{237.762`,99.3633`},{237.77`,100.464`},{237.779`,101.208`},{237.787`,101.674`},{237.795`,101.951`},{237.804`,102.104`},{237.813`,102.18`},{237.821`,102.216`},{237.83`,102.233`},{237.839`,102.243`},{237.848`,102.25`},{237.856`,102.255`},{237.865`,102.257`},{237.873`,102.257`},{237.882`,102.255`},{237.89`,102.25`},{237.898`,102.248`},{237.906`,102.248`},{237.914`,102.255`},{237.922`,102.272`},{237.931`,102.296`},{237.939`,102.328`},{237.947`,102.364`},{237.955`,102.398`},{237.964`,102.428`},{237.972`,102.445`},{237.981`,102.452`},{237.989`,102.447`},{237.998`,102.437`},{238.006`,102.42`},{238.015`,102.403`},{238.023`,102.386`},{238.031`,102.369`},{238.039`,102.357`},{238.047`,102.347`},{238.055`,102.338`},{238.063`,102.33`},{238.071`,102.321`},{238.079`,102.311`},{238.087`,102.301`},{238.095`,102.292`},{238.103`,102.282`},{238.111`,102.279`},{238.12`,102.277`},{238.128`,102.279`},{238.136`,102.284`},{238.144`,102.287`},{238.153`,102.289`},{238.162`,102.289`},{238.17`,102.287`},{238.179`,102.282`},{238.187`,102.277`},{238.196`,102.27`},{238.204`,102.262`},{238.212`,102.253`},{238.22`,102.245`},{238.229`,102.238`},{238.237`,102.231`},{238.245`,102.226`},{238.253`,102.221`},{238.261`,102.216`},{238.269`,102.209`},{238.278`,102.202`},{238.286`,102.194`},{238.294`,102.189`},{238.302`,102.189`},{238.311`,102.192`},{238.32`,102.199`},{238.328`,102.211`},{238.337`,102.223`},{238.346`,102.233`},{238.354`,102.243`},{238.363`,102.25`},{238.371`,102.255`},{238.38`,102.265`},{238.388`,102.274`},{238.396`,102.287`},{238.405`,102.296`},{238.413`,102.301`},{238.422`,102.304`},{238.43`,102.304`},{238.439`,102.299`},{238.447`,102.294`},{238.456`,102.292`},{238.464`,102.292`},{238.473`,102.294`},{238.481`,102.299`},{238.49`,102.306`},{238.498`,102.313`},{238.507`,102.321`},{238.515`,102.328`},{238.524`,102.335`},{238.532`,102.338`},{238.54`,102.338`},{238.549`,102.338`},{238.557`,102.335`},{238.565`,102.333`},{238.573`,102.33`},{238.582`,102.333`},{238.59`,102.335`},{238.598`,102.343`},{238.606`,102.347`},{238.614`,102.35`},{238.622`,102.352`},{238.63`,102.35`},{238.638`,102.347`},{238.647`,102.343`},{238.655`,102.34`},{238.663`,102.34`},{238.672`,102.338`},{238.68`,102.335`},{238.689`,102.33`},{238.697`,102.323`},{238.706`,102.316`},{238.714`,102.309`},{238.723`,102.309`},{238.732`,102.311`},{238.741`,102.318`},{238.749`,102.328`},{238.758`,102.338`},{238.766`,102.345`},{238.775`,102.35`},{238.784`,102.35`},{238.792`,102.352`},{238.8`,102.352`},{238.809`,102.355`},{238.817`,102.357`},{238.825`,102.362`},{238.833`,102.369`},{238.84`,102.381`},{238.848`,102.396`},{238.856`,102.411`},{238.864`,102.425`},{238.872`,102.44`},{238.88`,102.447`},{238.888`,102.452`},{238.896`,102.454`},{238.904`,102.454`},{238.913`,102.457`},{238.921`,102.464`},{238.93`,102.474`}};
			line2Value = {{234.04`,-0.0200879`},{234.051`,-0.0251099`},{234.061`,-0.0301318`},{234.07`,-0.0301318`},{234.078`,-0.0251099`},{234.085`,-0.0175769`},{234.092`,-0.00502197`},{234.098`,0.00502197`},{234.105`,0.0175769`},{234.112`,0.0251099`},{234.12`,0.0301318`},{234.129`,0.0301318`},{234.14`,0.0276208`},{234.152`,0.0225989`},{234.165`,0.0175769`},{234.178`,0.0150659`},{234.192`,0.0100439`},{234.205`,0.00753296`},{234.218`,0.00502197`},{234.231`,0.00251099`},{234.242`,0},{234.253`,0},{234.262`,0},{234.272`,0.00753296`},{234.28`,0.0150659`},{234.288`,0.0251099`},{234.295`,0.0376648`},{234.302`,0.0451977`},{234.309`,0.0527307`},{234.315`,0.0552417`},{234.32`,0.0527307`},{234.326`,0.0502197`},{234.331`,0.0477087`},{234.337`,0.0477087`},{234.342`,0.0477087`},{234.347`,0.0527307`},{234.353`,0.0577527`},{234.358`,0.0652856`},{234.363`,0.0728186`},{234.368`,0.0778406`},{234.373`,0.0803515`},{234.378`,0.0828625`},{234.383`,0.0878845`},{234.387`,0.0929065`},{234.392`,0.100439`},{234.397`,0.107972`},{234.402`,0.115505`},{234.407`,0.120527`},{234.412`,0.125549`},{234.417`,0.130571`},{234.422`,0.135593`},{234.427`,0.143126`},{234.433`,0.150659`},{234.438`,0.163214`},{234.444`,0.173258`},{234.45`,0.183302`},{234.456`,0.193346`},{234.462`,0.200879`},{234.468`,0.208412`},{234.474`,0.213434`},{234.481`,0.218456`},{234.487`,0.223478`},{234.493`,0.2285`},{234.5`,0.231011`},{234.506`,0.236033`},{234.513`,0.238544`},{234.52`,0.241055`},{234.526`,0.241055`},{234.533`,0.243566`},{234.54`,0.246077`},{234.548`,0.248588`},{234.555`,0.25361`},{234.563`,0.256121`},{234.57`,0.258632`},{234.578`,0.258632`},{234.586`,0.258632`},{234.593`,0.256121`},{234.601`,0.25361`},{234.609`,0.251099`},{234.617`,0.248588`},{234.625`,0.246077`},{234.633`,0.246077`},{234.641`,0.248588`},{234.649`,0.251099`},{234.657`,0.251099`},{234.665`,0.25361`},{234.673`,0.256121`},{234.681`,0.256121`},{234.688`,0.256121`},{234.696`,0.256121`},{234.704`,0.256121`},{234.713`,0.256121`},{234.721`,0.25361`},{234.729`,0.251099`},{234.738`,0.248588`},{234.746`,0.243566`},{234.754`,0.236033`},{234.763`,0.225989`},{234.771`,0.218456`},{234.78`,0.210923`},{234.788`,0.20339`},{234.796`,0.200879`},{234.805`,0.20339`},{234.813`,0.205901`},{234.821`,0.210923`},{234.83`,0.215945`},{234.838`,0.218456`},{234.847`,0.220967`},{234.856`,0.218456`},{234.865`,0.213434`},{234.874`,0.208412`},{234.882`,0.200879`},{234.891`,0.195857`},{234.899`,0.193346`},{234.908`,0.193346`},{234.916`,0.195857`},{234.925`,0.198368`},{234.933`,0.200879`},{234.942`,0.200879`},{234.95`,0.20339`},{234.958`,0.205901`},{234.967`,0.205901`},{234.975`,0.210923`},{234.983`,0.213434`},{234.991`,0.218456`},{234.999`,0.220967`},{235.007`,0.220967`},{235.015`,0.220967`},{235.023`,0.218456`},{235.031`,0.215945`},{235.04`,0.213434`},{235.048`,0.213434`},{235.056`,0.210923`},{235.064`,0.213434`},{235.072`,0.213434`},{235.081`,0.213434`},{235.089`,0.218456`},{235.097`,0.220967`},{235.106`,0.225989`},{235.114`,0.231011`},{235.123`,0.236033`},{235.132`,0.243566`},{235.14`,0.251099`},{235.149`,0.258632`},{235.158`,0.266164`},{235.166`,0.271186`},{235.174`,0.273697`},{235.183`,0.273697`},{235.191`,0.273697`},{235.2`,0.271186`},{235.208`,0.268675`},{235.216`,0.266164`},{235.224`,0.266164`},{235.232`,0.266164`},{235.24`,0.271186`},{235.248`,0.273697`},{235.257`,0.28123`},{235.265`,0.286252`},{235.273`,0.293785`},{235.281`,0.301318`},{235.289`,0.308851`},{235.298`,0.313873`},{235.306`,0.321406`},{235.314`,0.326428`},{235.323`,0.33145`},{235.331`,0.336472`},{235.339`,0.341494`},{235.348`,0.346516`},{235.356`,0.351538`},{235.365`,0.359071`},{235.374`,0.364093`},{235.382`,0.371626`},{235.391`,0.379159`},{235.399`,0.386692`},{235.407`,0.394225`},{235.415`,0.401758`},{235.423`,0.404269`},{235.431`,0.404269`},{235.439`,0.401758`},{235.447`,0.396736`},{235.455`,0.391714`},{235.463`,0.386692`},{235.471`,0.384181`},{235.479`,0.384181`},{235.486`,0.384181`},{235.494`,0.386692`},{235.502`,0.386692`},{235.511`,0.386692`},{235.519`,0.389203`},{235.527`,0.389203`},{235.535`,0.391714`},{235.544`,0.394225`},{235.553`,0.396736`},{235.561`,0.399247`},{235.57`,0.399247`},{235.578`,0.396736`},{235.587`,0.394225`},{235.595`,0.389203`},{235.604`,0.384181`},{235.612`,0.379159`},{235.621`,0.374137`},{235.629`,0.371626`},{235.637`,0.369115`},{235.645`,0.366604`},{235.653`,0.366604`},{235.661`,0.364093`},{235.669`,0.364093`},{235.676`,0.366604`},{235.684`,0.366604`},{235.692`,0.369115`},{235.7`,0.371626`},{235.708`,0.371626`},{235.716`,0.369115`},{235.725`,0.366604`},{235.733`,0.364093`},{235.741`,0.359071`},{235.749`,0.354049`},{235.757`,0.349027`},{235.765`,0.346516`},{235.773`,0.341494`},{235.782`,0.338983`},{235.79`,0.336472`},{235.798`,0.336472`},{235.806`,0.336472`},{235.815`,0.341494`},{235.823`,0.346516`},{235.831`,0.351538`},{235.839`,0.354049`},{235.847`,0.35656`},{235.855`,0.359071`},{235.863`,0.35656`},{235.871`,0.35656`},{235.88`,0.35656`},{235.888`,0.359071`},{235.897`,0.364093`},{235.905`,0.369115`},{235.913`,0.376648`},{235.922`,0.379159`},{235.931`,0.38167`},{235.939`,0.379159`},{235.948`,0.374137`},{235.956`,0.366604`},{235.965`,0.359071`},{235.974`,0.354049`},{235.982`,0.349027`},{235.991`,0.351538`},{235.999`,0.35656`},{236.007`,0.364093`},{236.016`,0.371626`},{236.024`,0.379159`},{236.032`,0.386692`},{236.04`,0.389203`},{236.048`,0.391714`},{236.057`,0.391714`},{236.065`,0.391714`},{236.073`,0.394225`},{236.082`,0.394225`},{236.09`,0.396736`},{236.099`,0.401758`},{236.107`,0.40678`},{236.115`,0.414313`},{236.124`,0.424357`},{236.132`,0.434401`},{236.141`,0.444444`},{236.149`,0.454488`},{236.158`,0.467043`},{236.166`,0.477087`},{236.174`,0.489642`},{236.183`,0.502197`},{236.191`,0.517263`},{236.199`,0.532329`},{236.207`,0.547395`},{236.215`,0.562461`},{236.223`,0.577527`},{236.231`,0.592593`},{236.24`,0.607659`},{236.248`,0.622724`},{236.256`,0.635279`},{236.264`,0.650345`},{236.272`,0.6629`},{236.281`,0.675455`},{236.289`,0.68801`},{236.298`,0.700565`},{236.306`,0.71312`},{236.315`,0.728186`},{236.323`,0.745763`},{236.332`,0.76334`},{236.34`,0.783427`},{236.348`,0.806026`},{236.357`,0.828625`},{236.365`,0.851224`},{236.373`,0.876334`},{236.382`,0.901444`},{236.39`,0.924043`},{236.399`,0.946642`},{236.407`,0.96924`},{236.416`,0.989328`},{236.424`,1.01193`},{236.433`,1.03704`},{236.441`,1.06466`},{236.45`,1.0973`},{236.458`,1.13497`},{236.466`,1.17263`},{236.474`,1.21281`},{236.482`,1.24796`},{236.49`,1.2806`},{236.498`,1.31073`},{236.506`,1.33584`},{236.514`,1.35844`},{236.522`,1.37853`},{236.531`,1.39611`},{236.539`,1.41117`},{236.548`,1.42875`},{236.556`,1.44382`},{236.565`,1.4639`},{236.573`,1.4865`},{236.581`,1.51161`},{236.59`,1.53672`},{236.598`,1.56434`},{236.606`,1.58694`},{236.614`,1.60452`},{236.622`,1.61959`},{236.63`,1.63214`},{236.639`,1.64218`},{236.647`,1.65223`},{236.655`,1.66227`},{236.664`,1.67734`},{236.672`,1.69492`},{236.681`,1.715`},{236.689`,1.7376`},{236.697`,1.76271`},{236.705`,1.78782`},{236.714`,1.81293`},{236.722`,1.83553`},{236.73`,1.85813`},{236.738`,1.88073`},{236.746`,1.90333`},{236.754`,1.92593`},{236.763`,1.94852`},{236.771`,1.97363`},{236.78`,1.99372`},{236.788`,2.01632`},{236.797`,2.03641`},{236.805`,2.05399`},{236.814`,2.07407`},{236.822`,2.09416`},{236.831`,2.11425`},{236.84`,2.13685`},{236.848`,2.15945`},{236.857`,2.18456`},{236.865`,2.20716`},{236.874`,2.23478`},{236.882`,2.25989`},{236.89`,2.29002`},{236.897`,2.32015`},{236.905`,2.35279`},{236.912`,2.38544`},{236.92`,2.42059`},{236.928`,2.45323`},{236.936`,2.48839`},{236.945`,2.52354`},{236.953`,2.55869`},{236.962`,2.59385`},{236.97`,2.63151`},{236.979`,2.67169`},{236.987`,2.71438`},{236.996`,2.76208`},{237.005`,2.81733`},{237.013`,2.88261`},{237.022`,2.95543`},{237.031`,3.0408`},{237.039`,3.13371`},{237.048`,3.23666`},{237.056`,3.34965`},{237.065`,3.47018`},{237.073`,3.60075`},{237.082`,3.73635`},{237.09`,3.87696`},{237.099`,4.01507`},{237.107`,4.15066`},{237.115`,4.27119`},{237.124`,4.37163`},{237.132`,4.44444`},{237.14`,4.48211`},{237.149`,4.48462`},{237.157`,4.45951`},{237.166`,4.40929`},{237.174`,4.34903`},{237.182`,4.28625`},{237.19`,4.23603`},{237.197`,4.20088`},{237.205`,4.18581`},{237.213`,4.18832`},{237.22`,4.2059`},{237.228`,4.2285`},{237.236`,4.25863`},{237.244`,4.29127`},{237.252`,4.32894`},{237.26`,4.37414`},{237.269`,4.43691`},{237.278`,4.52228`},{237.287`,4.63026`},{237.296`,4.76334`},{237.305`,4.91149`},{237.315`,5.05964`},{237.323`,5.19021`},{237.332`,5.2806`},{237.34`,5.32078`},{237.349`,5.3032`},{237.357`,5.23792`},{237.365`,5.15254`},{237.373`,5.0747`},{237.381`,5.03955`},{237.39`,5.07972`},{237.398`,5.20025`},{237.407`,5.39862`},{237.415`,5.66478`},{237.423`,5.97615`},{237.432`,6.33271`},{237.44`,6.74953`},{237.448`,7.23415`},{237.456`,7.78657`},{237.464`,8.38418`},{237.472`,8.97928`},{237.481`,9.51161`},{237.489`,9.93095`},{237.497`,10.2072`},{237.505`,10.3402`},{237.513`,10.3603`},{237.522`,10.3227`},{237.53`,10.2724`},{237.537`,10.2448`},{237.545`,10.2574`},{237.554`,10.3001`},{237.562`,10.3679`},{237.57`,10.4583`},{237.578`,10.5712`},{237.586`,10.7043`},{237.594`,10.86`},{237.602`,11.0458`},{237.611`,11.2618`},{237.619`,11.5078`},{237.628`,11.7815`},{237.636`,12.0778`},{237.644`,12.3766`},{237.653`,12.6704`},{237.661`,12.9416`},{237.67`,13.1777`},{237.678`,13.3685`},{237.687`,13.5141`},{237.696`,13.6171`},{237.704`,13.6949`},{237.712`,13.7577`},{237.721`,13.8305`},{237.729`,13.9259`},{237.737`,14.0615`},{237.746`,14.2423`},{237.754`,14.4683`},{237.762`,14.7395`},{237.77`,15.0458`},{237.779`,15.3923`},{237.787`,15.7841`},{237.795`,16.2411`},{237.804`,16.7834`},{237.813`,17.4313`},{237.821`,18.1971`},{237.83`,19.0835`},{237.839`,20.0879`},{237.848`,21.2053`},{237.856`,22.4306`},{237.865`,23.764`},{237.873`,25.2279`},{237.882`,26.8424`},{237.89`,28.6529`},{237.898`,30.7043`},{237.906`,33.0521`},{237.914`,35.7464`},{237.922`,38.8023`},{237.931`,42.2046`},{237.939`,45.8983`},{237.947`,49.8079`},{237.955`,53.8431`},{237.964`,57.9284`},{237.972`,62.0013`},{237.981`,66.0339`},{237.989`,70.0163`},{237.998`,73.941`},{238.006`,77.7903`},{238.015`,81.5116`},{238.023`,85.037`},{238.031`,88.2888`},{238.039`,91.1839`},{238.047`,93.6698`},{238.055`,95.7087`},{238.063`,97.2957`},{238.071`,98.4633`},{238.079`,99.2643`},{238.087`,99.7715`},{238.095`,100.063`},{238.103`,100.213`},{238.111`,100.281`},{238.12`,100.314`},{238.128`,100.339`},{238.136`,100.367`},{238.144`,100.399`},{238.153`,100.429`},{238.162`,100.46`},{238.17`,100.485`},{238.179`,100.51`},{238.187`,100.53`},{238.196`,100.55`},{238.204`,100.57`},{238.212`,100.59`},{238.22`,100.61`},{238.229`,100.628`},{238.237`,100.645`},{238.245`,100.658`},{238.253`,100.665`},{238.261`,100.67`},{238.269`,100.668`},{238.278`,100.663`},{238.286`,100.653`},{238.294`,100.643`},{238.302`,100.633`},{238.311`,100.625`},{238.32`,100.618`},{238.328`,100.615`},{238.337`,100.613`},{238.346`,100.613`},{238.354`,100.613`},{238.363`,100.613`},{238.371`,100.615`},{238.38`,100.62`},{238.388`,100.625`},{238.396`,100.635`},{238.405`,100.648`},{238.413`,100.66`},{238.422`,100.675`},{238.43`,100.685`},{238.439`,100.693`},{238.447`,100.696`},{238.456`,100.696`},{238.464`,100.693`},{238.473`,100.691`},{238.481`,100.683`},{238.49`,100.675`},{238.498`,100.668`},{238.507`,100.66`},{238.515`,100.653`},{238.524`,100.645`},{238.532`,100.638`},{238.54`,100.633`},{238.549`,100.628`},{238.557`,100.628`},{238.565`,100.633`},{238.573`,100.643`},{238.582`,100.658`},{238.59`,100.675`},{238.598`,100.696`},{238.606`,100.713`},{238.614`,100.723`},{238.622`,100.726`},{238.63`,100.721`},{238.638`,100.711`},{238.647`,100.698`},{238.655`,100.685`},{238.663`,100.678`},{238.672`,100.67`},{238.68`,100.665`},{238.689`,100.665`},{238.697`,100.665`},{238.706`,100.668`},{238.714`,100.67`},{238.723`,100.678`},{238.732`,100.688`},{238.741`,100.698`},{238.749`,100.708`},{238.758`,100.718`},{238.766`,100.726`},{238.775`,100.733`},{238.784`,100.741`},{238.792`,100.743`},{238.8`,100.748`},{238.809`,100.753`},{238.817`,100.758`},{238.825`,100.768`},{238.833`,100.783`},{238.84`,100.798`},{238.848`,100.814`},{238.856`,100.826`},{238.864`,100.831`},{238.872`,100.829`},{238.88`,100.819`},{238.888`,100.804`},{238.896`,100.788`},{238.904`,100.776`},{238.913`,100.768`},{238.921`,100.766`},{238.93`,100.768`}};
			line3Value = {{234.04`,0.00508156`},{234.051`,0.0101631`},{234.061`,0.0152447`},{234.07`,0.022867`},{234.078`,0.0330301`},{234.085`,0.0482748`},{234.092`,0.0635195`},{234.098`,0.0787642`},{234.105`,0.0940088`},{234.112`,0.106713`},{234.12`,0.114335`},{234.129`,0.116876`},{234.14`,0.119417`},{234.152`,0.121957`},{234.165`,0.124498`},{234.178`,0.12958`},{234.192`,0.134661`},{234.205`,0.142284`},{234.218`,0.147365`},{234.231`,0.154988`},{234.242`,0.160069`},{234.253`,0.165151`},{234.262`,0.172773`},{234.272`,0.180395`},{234.28`,0.190558`},{234.288`,0.200722`},{234.295`,0.210885`},{234.302`,0.218507`},{234.309`,0.226129`},{234.315`,0.231211`},{234.32`,0.233752`},{234.326`,0.238833`},{234.331`,0.241374`},{234.337`,0.248996`},{234.342`,0.256619`},{234.347`,0.266782`},{234.353`,0.276945`},{234.358`,0.287108`},{234.363`,0.299812`},{234.368`,0.307434`},{234.373`,0.315057`},{234.378`,0.320138`},{234.383`,0.32522`},{234.387`,0.332842`},{234.392`,0.340464`},{234.397`,0.350628`},{234.402`,0.360791`},{234.407`,0.373495`},{234.412`,0.386198`},{234.417`,0.396362`},{234.422`,0.406525`},{234.427`,0.416688`},{234.433`,0.426851`},{234.438`,0.434473`},{234.444`,0.439555`},{234.45`,0.444636`},{234.456`,0.447177`},{234.462`,0.447177`},{234.468`,0.444636`},{234.474`,0.447177`},{234.481`,0.449718`},{234.487`,0.45734`},{234.493`,0.464963`},{234.5`,0.475126`},{234.506`,0.485289`},{234.513`,0.49037`},{234.52`,0.492911`},{234.526`,0.492911`},{234.533`,0.495452`},{234.54`,0.495452`},{234.548`,0.500534`},{234.555`,0.508156`},{234.563`,0.515778`},{234.57`,0.52086`},{234.578`,0.525941`},{234.586`,0.528482`},{234.593`,0.528482`},{234.601`,0.525941`},{234.609`,0.523401`},{234.617`,0.52086`},{234.625`,0.515778`},{234.633`,0.513237`},{234.641`,0.510697`},{234.649`,0.508156`},{234.657`,0.508156`},{234.665`,0.505615`},{234.673`,0.505615`},{234.681`,0.503074`},{234.688`,0.503074`},{234.696`,0.503074`},{234.704`,0.505615`},{234.713`,0.508156`},{234.721`,0.510697`},{234.729`,0.513237`},{234.738`,0.515778`},{234.746`,0.513237`},{234.754`,0.510697`},{234.763`,0.508156`},{234.771`,0.505615`},{234.78`,0.503074`},{234.788`,0.505615`},{234.796`,0.510697`},{234.805`,0.513237`},{234.813`,0.518319`},{234.821`,0.523401`},{234.83`,0.523401`},{234.838`,0.52086`},{234.847`,0.515778`},{234.856`,0.510697`},{234.865`,0.503074`},{234.874`,0.497993`},{234.882`,0.49037`},{234.891`,0.485289`},{234.899`,0.480207`},{234.908`,0.477667`},{234.916`,0.475126`},{234.925`,0.472585`},{234.933`,0.475126`},{234.942`,0.480207`},{234.95`,0.485289`},{234.958`,0.495452`},{234.967`,0.505615`},{234.975`,0.513237`},{234.983`,0.52086`},{234.991`,0.525941`},{234.999`,0.531023`},{235.007`,0.533564`},{235.015`,0.533564`},{235.023`,0.536104`},{235.031`,0.536104`},{235.04`,0.536104`},{235.048`,0.536104`},{235.056`,0.536104`},{235.064`,0.533564`},{235.072`,0.531023`},{235.081`,0.531023`},{235.089`,0.531023`},{235.097`,0.533564`},{235.106`,0.536104`},{235.114`,0.541186`},{235.123`,0.548808`},{235.132`,0.556431`},{235.14`,0.561512`},{235.149`,0.569135`},{235.158`,0.571675`},{235.166`,0.574216`},{235.174`,0.574216`},{235.183`,0.574216`},{235.191`,0.571675`},{235.2`,0.569135`},{235.208`,0.569135`},{235.216`,0.569135`},{235.224`,0.571675`},{235.232`,0.576757`},{235.24`,0.581839`},{235.248`,0.589461`},{235.257`,0.599624`},{235.265`,0.607246`},{235.273`,0.612328`},{235.281`,0.614869`},{235.289`,0.617409`},{235.298`,0.614869`},{235.306`,0.612328`},{235.314`,0.609787`},{235.323`,0.607246`},{235.331`,0.609787`},{235.339`,0.612328`},{235.348`,0.617409`},{235.356`,0.622491`},{235.365`,0.630113`},{235.374`,0.637736`},{235.382`,0.645358`},{235.391`,0.65298`},{235.399`,0.660603`},{235.407`,0.668225`},{235.415`,0.673307`},{235.423`,0.675847`},{235.431`,0.675847`},{235.439`,0.675847`},{235.447`,0.670766`},{235.455`,0.665684`},{235.463`,0.660603`},{235.471`,0.658062`},{235.479`,0.658062`},{235.486`,0.658062`},{235.494`,0.660603`},{235.502`,0.660603`},{235.511`,0.660603`},{235.519`,0.660603`},{235.527`,0.660603`},{235.535`,0.660603`},{235.544`,0.663143`},{235.553`,0.665684`},{235.561`,0.668225`},{235.57`,0.670766`},{235.578`,0.670766`},{235.587`,0.665684`},{235.595`,0.663143`},{235.604`,0.658062`},{235.612`,0.65298`},{235.621`,0.647899`},{235.629`,0.642817`},{235.637`,0.640276`},{235.645`,0.637736`},{235.653`,0.637736`},{235.661`,0.637736`},{235.669`,0.640276`},{235.676`,0.645358`},{235.684`,0.65044`},{235.692`,0.65298`},{235.7`,0.655521`},{235.708`,0.658062`},{235.716`,0.655521`},{235.725`,0.65298`},{235.733`,0.65044`},{235.741`,0.647899`},{235.749`,0.642817`},{235.757`,0.640276`},{235.765`,0.635195`},{235.773`,0.630113`},{235.782`,0.625032`},{235.79`,0.61995`},{235.798`,0.617409`},{235.806`,0.612328`},{235.815`,0.609787`},{235.823`,0.609787`},{235.831`,0.609787`},{235.839`,0.612328`},{235.847`,0.614869`},{235.855`,0.617409`},{235.863`,0.622491`},{235.871`,0.625032`},{235.88`,0.627573`},{235.888`,0.632654`},{235.897`,0.637736`},{235.905`,0.645358`},{235.913`,0.65298`},{235.922`,0.663143`},{235.931`,0.670766`},{235.939`,0.675847`},{235.948`,0.678388`},{235.956`,0.680929`},{235.965`,0.680929`},{235.974`,0.68347`},{235.982`,0.688551`},{235.991`,0.696174`},{235.999`,0.706337`},{236.007`,0.721581`},{236.016`,0.736826`},{236.024`,0.74953`},{236.032`,0.764775`},{236.04`,0.777479`},{236.048`,0.787642`},{236.057`,0.800346`},{236.065`,0.813049`},{236.073`,0.825753`},{236.082`,0.843539`},{236.09`,0.863865`},{236.099`,0.884191`},{236.107`,0.907058`},{236.115`,0.929925`},{236.124`,0.950252`},{236.132`,0.968037`},{236.141`,0.983282`},{236.149`,0.998526`},{236.158`,1.01377`},{236.166`,1.03156`},{236.174`,1.05188`},{236.183`,1.07475`},{236.191`,1.10016`},{236.199`,1.12302`},{236.207`,1.14589`},{236.215`,1.16622`},{236.223`,1.18654`},{236.231`,1.20433`},{236.24`,1.22466`},{236.248`,1.24244`},{236.256`,1.25769`},{236.264`,1.27293`},{236.272`,1.28818`},{236.281`,1.30088`},{236.289`,1.31612`},{236.298`,1.33137`},{236.306`,1.34915`},{236.315`,1.37202`},{236.323`,1.39489`},{236.332`,1.41775`},{236.34`,1.44062`},{236.348`,1.46603`},{236.357`,1.49144`},{236.365`,1.5143`},{236.373`,1.54225`},{236.382`,1.56766`},{236.39`,1.59307`},{236.399`,1.61848`},{236.407`,1.64388`},{236.416`,1.66675`},{236.424`,1.68708`},{236.433`,1.70994`},{236.441`,1.73281`},{236.45`,1.75568`},{236.458`,1.78109`},{236.466`,1.80395`},{236.474`,1.82936`},{236.482`,1.84969`},{236.49`,1.87255`},{236.498`,1.89034`},{236.506`,1.91067`},{236.514`,1.92591`},{236.522`,1.94116`},{236.531`,1.95132`},{236.539`,1.95894`},{236.548`,1.96402`},{236.556`,1.96656`},{236.565`,1.97164`},{236.573`,1.97927`},{236.581`,1.98943`},{236.59`,2.00213`},{236.598`,2.01484`},{236.606`,2.03008`},{236.614`,2.04025`},{236.622`,2.04787`},{236.63`,2.05549`},{236.639`,2.05803`},{236.647`,2.06057`},{236.655`,2.06311`},{236.664`,2.06819`},{236.672`,2.07582`},{236.681`,2.08598`},{236.689`,2.09868`},{236.697`,2.11393`},{236.705`,2.13171`},{236.714`,2.14696`},{236.722`,2.16474`},{236.73`,2.17745`},{236.738`,2.19015`},{236.746`,2.20032`},{236.754`,2.21048`},{236.763`,2.2181`},{236.771`,2.22318`},{236.78`,2.2308`},{236.788`,2.23843`},{236.797`,2.24605`},{236.805`,2.25367`},{236.814`,2.26383`},{236.822`,2.274`},{236.831`,2.2867`},{236.84`,2.29686`},{236.848`,2.30703`},{236.857`,2.31719`},{236.865`,2.32989`},{236.874`,2.3426`},{236.882`,2.35784`},{236.89`,2.37055`},{236.897`,2.38579`},{236.905`,2.40358`},{236.912`,2.41882`},{236.92`,2.44169`},{236.928`,2.46456`},{236.936`,2.49505`},{236.945`,2.53062`},{236.953`,2.57127`},{236.962`,2.617`},{236.97`,2.66274`},{236.979`,2.71101`},{236.987`,2.76183`},{236.996`,2.81264`},{237.005`,2.86854`},{237.013`,2.92952`},{237.022`,3.00066`},{237.031`,3.07688`},{237.039`,3.16835`},{237.048`,3.26998`},{237.056`,3.38432`},{237.065`,3.50882`},{237.073`,3.64094`},{237.082`,3.77052`},{237.09`,3.88993`},{237.099`,3.99665`},{237.107`,4.08303`},{237.115`,4.14655`},{237.124`,4.18975`},{237.132`,4.22023`},{237.14`,4.23802`},{237.149`,4.25581`},{237.157`,4.27105`},{237.166`,4.29392`},{237.174`,4.32187`},{237.182`,4.35998`},{237.19`,4.41587`},{237.197`,4.4921`},{237.205`,4.60389`},{237.213`,4.76396`},{237.22`,4.98501`},{237.228`,5.27974`},{237.236`,5.64561`},{237.244`,6.07754`},{237.252`,6.55521`},{237.26`,7.05574`},{237.269`,7.56136`},{237.278`,8.04919`},{237.287`,8.50907`},{237.296`,8.9283`},{237.305`,9.30942`},{237.315`,9.64988`},{237.323`,9.94207`},{237.332`,10.186`},{237.34`,10.3791`},{237.349`,10.5239`},{237.357`,10.6281`},{237.365`,10.6941`},{237.373`,10.7323`},{237.381`,10.745`},{237.39`,10.7323`},{237.398`,10.6891`},{237.407`,10.6001`},{237.415`,10.4502`},{237.423`,10.2241`},{237.432`,9.91666`},{237.44`,9.53555`},{237.448`,9.1214`},{237.456`,8.72504`},{237.464`,8.40998`},{237.472`,8.2245`},{237.481`,8.19147`},{237.489`,8.30581`},{237.497`,8.53702`},{237.505`,8.86224`},{237.513`,9.26876`},{237.522`,9.75151`},{237.53`,10.3105`},{237.537`,10.9381`},{237.545`,11.6037`},{237.554`,12.2542`},{237.562`,12.8259`},{237.57`,13.2578`},{237.578`,13.522`},{237.586`,13.6287`},{237.594`,13.6135`},{237.602`,13.5347`},{237.611`,13.4509`},{237.619`,13.4001`},{237.628`,13.3899`},{237.636`,13.4331`},{237.644`,13.5271`},{237.653`,13.6592`},{237.661`,13.8193`},{237.67`,14.0022`},{237.678`,14.1928`},{237.687`,14.3859`},{237.696`,14.5739`},{237.704`,14.7467`},{237.712`,14.8966`},{237.721`,15.0185`},{237.729`,15.11`},{237.737`,15.1812`},{237.746`,15.2421`},{237.754`,15.3107`},{237.762`,15.4022`},{237.77`,15.5318`},{237.779`,15.7046`},{237.787`,15.9256`},{237.795`,16.1873`},{237.804`,16.4846`},{237.813`,16.8047`},{237.821`,17.1325`},{237.83`,17.4602`},{237.839`,17.7677`},{237.848`,18.0599`},{237.856`,18.347`},{237.865`,18.6595`},{237.873`,19.0558`},{237.882`,19.5996`},{237.89`,20.372`},{237.898`,21.4493`},{237.906`,22.8924`},{237.914`,24.7421`},{237.922`,27.0237`},{237.931`,29.7424`},{237.939`,32.9031`},{237.947`,36.5161`},{237.955`,40.5966`},{237.964`,45.1497`},{237.972`,50.1677`},{237.981`,55.6202`},{237.989`,61.4183`},{237.998`,67.4145`},{238.006`,73.4082`},{238.015`,79.1529`},{238.023`,84.4072`},{238.031`,88.9679`},{238.039`,92.6978`},{238.047`,95.5562`},{238.055`,97.5863`},{238.063`,98.91`},{238.071`,99.6926`},{238.079`,100.102`},{238.087`,100.287`},{238.095`,100.356`},{238.103`,100.371`},{238.111`,100.379`},{238.12`,100.386`},{238.128`,100.401`},{238.136`,100.419`},{238.144`,100.437`},{238.153`,100.452`},{238.162`,100.468`},{238.17`,100.483`},{238.179`,100.503`},{238.187`,100.531`},{238.196`,100.562`},{238.204`,100.6`},{238.212`,100.638`},{238.22`,100.676`},{238.229`,100.709`},{238.237`,100.732`},{238.245`,100.747`},{238.253`,100.755`},{238.261`,100.755`},{238.269`,100.752`},{238.278`,100.744`},{238.286`,100.739`},{238.294`,100.732`},{238.302`,100.724`},{238.311`,100.719`},{238.32`,100.711`},{238.328`,100.704`},{238.337`,100.696`},{238.346`,100.686`},{238.354`,100.673`},{238.363`,100.663`},{238.371`,100.656`},{238.38`,100.65`},{238.388`,100.65`},{238.396`,100.65`},{238.405`,100.653`},{238.413`,100.653`},{238.422`,100.656`},{238.43`,100.653`},{238.439`,100.653`},{238.447`,100.65`},{238.456`,100.65`},{238.464`,100.65`},{238.473`,100.648`},{238.481`,100.645`},{238.49`,100.638`},{238.498`,100.628`},{238.507`,100.617`},{238.515`,100.61`},{238.524`,100.602`},{238.532`,100.6`},{238.54`,100.6`},{238.549`,100.605`},{238.557`,100.615`},{238.565`,100.625`},{238.573`,100.64`},{238.582`,100.658`},{238.59`,100.678`},{238.598`,100.694`},{238.606`,100.706`},{238.614`,100.711`},{238.622`,100.709`},{238.63`,100.701`},{238.638`,100.689`},{238.647`,100.673`},{238.655`,100.661`},{238.663`,100.65`},{238.672`,100.643`},{238.68`,100.638`},{238.689`,100.638`},{238.697`,100.638`},{238.706`,100.643`},{238.714`,100.645`},{238.723`,100.648`},{238.732`,100.65`},{238.741`,100.645`},{238.749`,100.638`},{238.758`,100.628`},{238.766`,100.615`},{238.775`,100.6`},{238.784`,100.584`},{238.792`,100.567`},{238.8`,100.546`},{238.809`,100.526`},{238.817`,100.506`},{238.825`,100.49`},{238.833`,100.483`},{238.84`,100.483`},{238.848`,100.493`},{238.856`,100.511`},{238.864`,100.534`},{238.872`,100.559`},{238.88`,100.582`},{238.888`,100.602`},{238.896`,100.617`},{238.904`,100.628`},{238.913`,100.638`},{238.921`,100.645`},{238.93`,100.653`}};

			quantityLine1 = QuantityArray[line1Value, {"DegreesCelsius", "Percent"}];
			quantityLine2 = QuantityArray[line2Value, {"DegreesCelsius", "Percent"}];
			quantityLine3 = QuantityArray[line3Value, {"DegreesCelsius", "Percent"}];
			videoFile = <|
				Type->Object[EmeraldCloudFile],
				FileName->"video demo.avi",
				FileType->"avi";
				CloudFile->ECL`EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard12/eaa4b1bd0b10682872ef244ab5e14b31.avi", "BYDOjvDB0DVvtwNelbo1J7DeF4npOJ8boaZ6"]
			|>;

			uploadVideo = Upload[videoFile];

			meltingPointData1 = <|
				Type -> Object[Data, MeltingPoint],
				Name -> "Melting Point Mock data unit test 1" <> uuid,
				Instrument -> Link[Object[Instrument, MeltingPointApparatus, "Persia"]],
				StartTemperature -> QuantityArray[First[First[line1Value]], Celsius],
				EndTemperature -> QuantityArray[First[Last[line1Value]], Celsius],
				DeveloperObject -> True,
				CapillaryVideoFile -> Link[uploadVideo],
				MeltingCurve -> quantityLine1,
				TemperatureRampRate -> 0.981271 Celsius/Minute
			|>;

			Upload[meltingPointData1];
		];
	},

	SymbolTearDown:>{
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	},

	Variables:>{
		meltingCurve,badMeltingCurve,poorMeltingCurve,MaxHeightFunction,responseChangeFunction,
		absorbanceIntensityObjectsTest1, absorbanceIntensityObjectsTest2, badChromatographyObject,
		dlsMeltingCurveDataObj,dlsMeltingCurveDataObjDLSOnly
	},

	SetUp:>{

		(* A coordinate list showing a typical cooling curve *)
		meltingCurve={{94.91999817`,0.5882810350000001`},{91.81999969`,0.5884541270000001`},
		{88.83999634`,0.5867453810000001`},{85.81999969`,0.58529067`},{82.81999969`,0.583597779`},
		{79.81999969`,0.581844211`},{76.81999969`,0.580616832`},{73.81999969`,0.5787916179999999`},
		{70.81999969`,0.576130509`},{67.81999969`,0.573802471`},{64.81999969`,0.5704038140000001`},
		{61.86999893`,0.566836476`},{58.86999893`,0.561558604`},{55.81999969`,0.546328425`},
		{52.81999969`,0.49655651999999995`},{49.81999969`,0.4524550439999999`},{46.81999969`,0.42511057900000004`},
		{43.81999969`,0.4125000240000001`},{40.86999893`,0.404709816`},{37.86999893`,0.3989851470000001`},
		{34.81999969`,0.39457202`},{31.81999969`,0.39030695000000004`},{28.81999969`,0.386383057`},
		{25.81999969`,0.38214278200000007`},{22.86000061`,0.377399445`},{19.81999969`,0.37228477000000004`},
		{16.81999969`,0.367433071`},{13.81999969`,0.3635615109999999`},{10.81999969`,0.360748053`},
		{7.820000172`,0.3586126569999999`},{4.820000172`,0.3568803069999995`}};

		(* A coordinate list showing a cooling curve *)
		badMeltingCurve = {{94.91999817`, 0.5882810350000001`}, {94.91999817`, 0.5882810350000001`},
		{91.81999969`,0.5884541270000001`}, {88.83999634`,0.5867453810000001`}, {85.81999969`, 0.58529067`},
		{82.81999969`,0.583597779`}, {79.81999969`, 0.581844211`}, {76.81999969`,0.580616832`},
		{73.81999969`, 0.5787916179999999`}, {70.81999969`,0.576130509`}, {67.81999969`, 0.573802471`},
		{64.81999969`,0.5704038140000001`}, {61.86999893`, 0.566836476`}, {58.86999893`,0.561558604`},
		{55.81999969`, 0.546328425`}, {52.81999969`,0.49655651999999995`}, {49.81999969`,0.4524550439999999`},
		{46.81999969`,0.42511057900000004`}, {43.81999969`,0.4125000240000001`}, {40.86999893`, 0.404709816`},
		{37.86999893`,0.3989851470000001`}, {34.81999969`, 0.39457202`}, {31.81999969`,0.39030695000000004`},
		{28.81999969`, 0.386383057`}, {25.81999969`,0.38214278200000007`}, {22.86000061`,0.377399445`},
		{19.81999969`, 0.37228477000000004`}, {16.81999969`,0.367433071`}, {13.81999969`, 0.3635615109999999`},
		{10.81999969`,0.360748053`}, {7.820000172`, 0.3586126569999999`}, {4.820000172`,0.35688030699999995`}};

		(* Very few datapoints cause the logistic fit to issue warning and change the fit setting *)
		poorMeltingCurve={
			{10.`,-0.024731520027054046`}, {15.`,-0.024761166773795144`},
			{20.`,-0.024807195725225127`}, {25.`,-0.02487395171590906`},
			{30.`,-0.0010142531923540152`}, {35.`,0.44227835628932477`},
			{40.`,1.5005148283688772`}, {45.`,1.4664032344320024`},
			{50.`,1.4717535208199337`}, {55.`,1.4798138087047636`},
			{60.`,1.4811774793050851`}, {65.`,1.480008586445279`},
			{69.69999694824219`,1.476355582714107`}
		};

		(* Custome Function: to find the maximum height in the wavelength dimension of a N by 3 list where the second element is wavelength *)
		MaxHeightFunction = Function[list,
			Module[{unitlessList, wl, wlRange, wlPositions, selectedData, groupedByTemp, temp, groupedWaves, groupedInts, maxInt},
				unitlessList = QuantityMagnitude[list];
				wl = Round[unitlessList[[;; , 2]], 0.000001];
				wlRange = Cases[wl, _?(250. <= # <= 255. &)];
				wlPositions = Position[wl, Alternatives @@ wlRange];
				selectedData = Extract[unitlessList, wlPositions];
				groupedByTemp = GatherBy[selectedData, First];
				temp = Flatten[groupedByTemp[[All, 1, 1]]];
				groupedWaves = groupedByTemp[[All, All, 2]];
				groupedInts = groupedByTemp[[All, All, 3]];
				maxInt = Max[#] & /@ groupedInts;
				QuantityArray[Transpose[{temp, maxInt}], {Celsius, ArbitraryUnit}]
			]
		];

		(* Custom Function: changes the second element (response) of a coordinate list *)
		responseChangeFunction = Function[list,
			Module[{unitlessList, newList},
				unitlessList = QuantityMagnitude[list];
				newList = Map[{#[[1]], 2*#[[2]]} &, unitlessList];
		    QuantityArray[newList, {Celsius, ArbitraryUnit}]
			]
		];
	},

	Stubs:>{
		Print[_] = Null
	}

];
