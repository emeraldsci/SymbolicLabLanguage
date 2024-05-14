(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*PlotDynamicLightScatteringAnalysis*)

DefineOptions[PlotDynamicLightScatteringAnalysis,
	Options	:> {
		OutputOption
	}
];

PlotDynamicLightScatteringAnalysis[myObject: ObjectP[Object[Analysis,DynamicLightScattering]], ops: OptionsPattern[PlotDynamicLightScatteringAnalysis]]:=Module[
	{
		reference, assayType
	},

	(* Pull out the DLS reference to decide what plotting to do *)
	{
		reference,
		assayType
	} = Quiet[
		Download[myObject,
			{
				Reference,
				Reference[AssayType]
			}
		],
		{Download::FieldDoesntExist}
	];

	(* Use refrence to determine which plotting to do *)
	Which[
		MatchQ[reference, ListableP[ObjectP[Object[Data, DynamicLightScattering]]]],
			assayType = FirstOrDefault[assayType, assayType];
			plotDynamicLightScattering[myObject, assayType, ops],
		MatchQ[reference, ListableP[ObjectP[Object[Data, MeltingCurve]]]],
			plotMeltingCurve[myObject, ops]
	]
]


(* Melting Curve *)
plotMeltingCurve[myObject: ObjectP[Object[Analysis,DynamicLightScattering]], ops: OptionsPattern[PlotDynamicLightScatteringAnalysis]]:= Module[
	{
		safeOps, resolvedOps, output, plots
	},

	(*download corrrelation curves *)
	{
		correlationCurves
	} = Download[myObject,
		{
			CorrelationCurves
		}
	];

	(* default the options *)
    safeOps=SafeOptions[PlotDynamicLightScatteringAnalysis,ToList[ops]];
	resolvedOps = safeOps;

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
    output=Lookup[safeOps,Output];

	plots = EmeraldListLinePlot[
		correlationCurves,
		Scale->LogLinear,
		PlotLabel->"Correlation Curves",
		FrameLabel->{{"Autocorrelation (Arbitrary units)", None},{"Time (uSeconds)", None}},
		Frame -> {{True, True}, {True, True}},
		Legend -> {"Initial", "Final"}
	];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->plots,
		Preview->plots,
		Tests->{},
		Options->resolvedOps
	}

];

(* ----- DYNAMIC LIGHT SCATTERING ALL ASSAY TYPES ----- *)

(* SizingPolydispersity *)
plotDynamicLightScattering[myObject: ObjectP[Object[Analysis,DynamicLightScattering]], SizingPolydispersity, ops: OptionsPattern[PlotDynamicLightScatteringAnalysis]]:= Module[
	{
		safeOps, resolvedOps, output, plots
	},

	(*download corrrelation curves *)
	{
		correlationCurves
	} = Download[myObject,
		{
			CorrelationCurves
		}
	];

	(* default the options *)
    safeOps=SafeOptions[PlotDynamicLightScatteringAnalysis,ToList[ops]];
	resolvedOps = safeOps;

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
    output=Lookup[safeOps,Output];

	plots = EmeraldListLinePlot[
		correlationCurves,
		Scale->LogLinear,
		PlotLabel->"Correlation Curve",
		FrameLabel->{{"Autocorrelation (Arbitrary units)", None},{"Time (uSeconds)", None}},
		Frame -> {{True, True}, {True, True}}
	];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->plots,
		Preview->plots,
		Tests->{},
		Options->resolvedOps
	}

];

(* Isothermal Stability *)
plotDynamicLightScattering[myObject: ObjectP[Object[Analysis,DynamicLightScattering]], IsothermalStability, ops: OptionsPattern[PlotDynamicLightScatteringAnalysis]]:= Module[
	{
		safeOps, resolvedOps, output, plots, correlationCurves,
		assayConditions, zAverageDiameters, correlationCurvePlot,
		particleSizePlot, allPlots
	},

	(*download corrrelation curves *)
	{
		correlationCurves,
		assayConditions,
		zAverageDiameters
	} = Download[myObject,
		{
			CorrelationCurves,
			AssayConditions,
			ZAverageDiameters
		}
	];

	(* default the options *)
    safeOps=SafeOptions[PlotDynamicLightScatteringAnalysis,ToList[ops]];
	resolvedOps = safeOps;

	correlationCurvePlot = EmeraldListLinePlot[
		correlationCurves,
		Scale->LogLinear,
		PlotLabel->"Correlation Curve",
		FrameLabel->{{"Particle Size (nm)", None},{"Time (uSeconds)", None}},
		Frame -> {{True, True}, {True, True}}
	];

	particleSizePlot = EmeraldListLinePlot[
		Transpose[{assayConditions, zAverageDiameters}],
		Scale->LogLinear,
		PlotLabel->"Particle Z-Average Diameter (nm)",
		FrameLabel->{{"Autocorrelation (Arbitrary units)", None},{"Time (uSeconds)", None}},
		Frame -> {{True, True}, {True, True}}
	];

	(* Put all plots together into a single tab view figure *)
	allPlots = TabView[{"Isothermal Particle Sizes" -> particleSizePlot, "Correlation Curves" -> correlationCurvePlot}];

	(* Requested output *)
    output=Lookup[safeOps,Output];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->allPlots,
		Preview->allPlots,
		Tests->{},
		Options->resolvedOps
	}

];

(* B22kd and G22 *)
plotDynamicLightScattering[myObject: ObjectP[Object[Analysis,DynamicLightScattering]], B22kD|G22, ops: OptionsPattern[PlotDynamicLightScatteringAnalysis]]:= Module[
	{
		excludedData, includedData, fig,dataSets, excludedDataSets, timeAxis, thresholdLine, cutoffLine, validFig,
		invalidFig, longestTimeAxes, latestTime, plotData, minMaxTime, validMinMaxTime, invalidMinMaxTime, includedColor,
		excludedColor, minTime, maxTime, maxMassConcentration, diffFig1, diffSlope, diffIntercept, diffFig2, diffFig,
		rayleighY, virialFig1, virialSlope, virialIntercept, virialX, virialY, virialFig2, virialFig, goodCorrelationsFig,
		badCorrelationCurves, badCorrelationsFig, correlationsFig
	},

	(* Download values from object *)
	{
		massConcentrations,
		diffusionCoefficients,
		diffusionInteractionParameterStatistics,
		secondVirialCoefficientStatistics,
		opticalConstant,
		solventRayleighRatio,
		filteredCorrelationCurves,
		allCorrelationCurves,
		diffusionInteractionParameterFit,
		secondVirialCoefficientFit,
		kirkwoodBuffIntegralFit
	} =
	Download[myObject,
		{
			AssayConditions,
			DiffusionCoefficients,
			DiffusionInteractionParameterStatistics,
			SecondVirialCoefficientStatistics,
			OpticalConstantValue,
			SolventRayleighRatios,
			CorrelationCurves,
			Reference[CorrelationCurves],
			DiffusionInteractionParameterFit,
			SecondVirialCoefficientFit,
			KirkwoodBuffIntegralFit
		}
	];

    (* default the options *)
    safeOps=SafeOptions[PlotDynamicLightScatteringAnalysis,ToList[ops]];
	resolvedOps = safeOps;

    (* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
    output=Lookup[safeOps,Output];

	(* Plot 1 - kd - diffusion data vs. concentration *)
	maxMassConcentration = Max[massConcentrations] + 1 Milligram/Milliliter;

	diffFig = PlotObject[
		diffusionInteractionParameterFit,
		FrameLabel -> {{"Diffusion", None},{"Concentration", None}},
		PlotRange -> {{0 Milligram/Milliliter, maxMassConcentration}, {Automatic, Automatic}},
		Outliers -> {},
		PointSize->Large,
		Display -> {ConfidenceBands},
		ConfidenceLevel -> 0.9,
		PlotLabel -> "Diffusion Coefficient",
		StandardDeviation -> Automatic
	];

	virialFig = PlotObject[
		secondVirialCoefficientFit,
		FrameLabel -> {{"Kc/R0", None},{"Concentration", None}},
		PlotRange -> {{0 Milligram/Milliliter, maxMassConcentration}, {Automatic, Automatic}},
		Outliers -> {},
		PointSize->Large,
		Display -> {ConfidenceBands},
		ConfidenceLevel -> 0.9,
		PlotLabel -> "Second Virial Coefficient",
		StandardDeviation -> Automatic
	];

	(* Plot 3 G22 fig *)
	kirkwoodFig = PlotObject[
		kirkwoodBuffIntegralFit,
		FrameLabel -> {{"K/R0", None},{"Concentration", None}},
		PlotRange -> {{0 Milligram/Milliliter, maxMassConcentration}, {Automatic, Automatic}},
		Outliers -> {},
		PointSize->Large,
		Display -> {ConfidenceBands},
		ConfidenceLevel -> 0.9,
		PlotLabel -> "Kirkwood Buff Integral",
		StandardDeviation -> Automatic
	];

	(* Plot 4 correlationCurves *)
	(* create a plot of the good correlation curves *)
	goodCorrelationsFig = EmeraldListLinePlot[
		filteredCorrelationCurves,
		Scale->LogLinear,
		PlotStyle->ConstantArray[Blue, Length[filteredCorrelationCurves]]
	];

	(* If we are using the packet allCorrelationCurves is the right dimensions, from the object it needs to be indexed *)
	badCorrelationCurves = If[Length[allCorrelationCurves] == 1,
		allCorrelationCurves[[1]],
		allCorrelationCurves
	];

	(* Pull out curves with no concentation since they are blanks *)
	badCorrelationCurves = DeleteCases[badCorrelationCurves, _?(#[[1]] <= 0 Milligram/Milliliter&)];
	badCorrelationCurves = badCorrelationCurves[[;;,2]];

	(* create plot of the bad correlation curves *)
	badCorrelationsFig = EmeraldListLinePlot[
		badCorrelationCurves,
		Scale->LogLinear,
		PlotStyle->ConstantArray[{Red, Thickness[0.001]}, Length[allCorrelationCurves]],
		PlotLabel->"Correlation Curves",
		FrameLabel->{{"Autocorrelation (Arbitrary units)", None},{"Time (uSeconds)", None}},
		Frame -> {{True, True}, {True, True}}
	];

	(* Combined good and bad curves *)
	correlationsFig = Zoomable[Show[badCorrelationsFig, goodCorrelationsFig]];

	(* Put all plots together into a single tab view figure *)
	allPlots = TabView[
		{
			"kD" -> diffFig,
			"B22" -> virialFig,
			"G22" -> kirkwoodFig,
			"Correlation Curves" -> correlationsFig
		}
	];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->allPlots,
		Preview->allPlots,
		Tests->{},
		Options->resolvedOps
	}

]
