(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*PlotDynamicLightScatteringLoading*)

DefineOptions[PlotDynamicLightScatteringLoading,
	Options	:> {
		OutputOption
	}
];


PlotDynamicLightScatteringLoading[myObject: ObjectP[Object[Analysis,DynamicLightScatteringLoading]],ops: OptionsPattern[PlotDynamicLightScatteringLoading]]:= Module[
	{
		excludedData, includedData, fig,dataSets, excludedDataSets, timeAxis,
		thresholdLine, cutoffLine, validFig, invalidFig, longestTimeAxes, latestTime,
		plotData, minMaxTime, validMinMaxTime, invalidMinMaxTime, includedColor,
		excludedColor, minTime, maxTime
	},

    (* default the options *)
    safeOps=SafeOptions[PlotDynamicLightScatteringLoading,ToList[ops]];
	resolvedOps = safeOps;

    (* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
    output=Lookup[safeOps,Output];

	(* Download all relevant fields from the analysis object *)
	{
		excludedData,
		includedData,
		correlationThreshold,
		timeThreshold,
		resolvedOptions
	} = Download[
		myObject,
		{
			ExcludedData,
			Data,
			CorrelationThreshold,
			TimeThreshold,
			ResolvedOptions
		}
	];

    (*Check if valid data and invald data are empty list,then return null*)
    If[And[MatchQ[includedData, {}], MatchQ[excludedData, {}]],
    	Return[<|Preview -> Null|>]
    ];

	(*Pull out the resolved option for CorrelationTemperature to use for final or initial curve*)
	correlationTemperature = Lookup[
		resolvedOptions,
		CorrelationTemperature,
		Null
	];

	(*Pull out maximum correlation *)
	correlationMaximum = Lookup[
		resolvedOptions,
		(* strip context for lookup *)
		Symbol[SymbolName[CorrelationMaximum]]
	];

	(*pull out the procol type*)
    joinedData = Join[includedData, excludedData];
    checkData = joinedData[[1]];

    (*Find what field the correlation data are stored in*)
    dataField = Switch[checkData,
        ObjectP[Object[Data, MeltingCurve]],
			If[MatchQ[correlationTemperature, Initial],
				InitialCorrelationCurve,
				FinalCorrelationCurve
			],
        ObjectP[Object[Data, DynamicLightScattering]],
            If[Not[MatchQ[checkData[CorrelationCurve], NullP | {}]],
                CorrelationCurve,
                CorrelationCurves
            ]
    ];

	(*Shared plotting values*)
	includedColor = Green;
	excludedColor = Red;
    frameLabel = {"Time (Microseconds)", "Correlation (Arbitrary Units)"};

	(*Check if valid data is populated and pull out relevant curves and create a figure*)
	validFig = dlslFigCreator[
		dataField,
		timeThreshold,
		correlationMaximum,
		correlationThreshold,
		includedColor,
		frameLabel,
		includedData
	];

	invalidFig = dlslFigCreator[
		dataField,
		timeThreshold,
		correlationMaximum,
		correlationThreshold,
		excludedColor,
		frameLabel,
		excludedData
	];

	fig = Show[
		validFig,
		invalidFig,
		PlotRange->All
	];

    (* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->fig,
		Preview->fig,
		Tests->{},
		Options->resolvedOps
	}

];


dlslFigCreator[__, {}]:={}

dlslFigCreator[
	dataField_,
	timeThreshold_,
	correlationMaximum_,
	correlationThreshold_,
	color_,
	frameLabel_,
	data_
] := Module[
	{dataSets},

	(* pull out valid data sets *)
	dataSets = Download[
		data,
		dataField
	];

	dataSets = dataCheckPrimary[dataSets, dataField];

	dlslPlotHelper[
		dataSets,
		dataField,
		timeThreshold,
		correlationMaximum,
		correlationThreshold,
		color,
		frameLabel,
		data
	]

];

dlslPlotHelper[
	dataSets_,
	dataField: CorrelationCurves,
	timeThreshold_,
	correlationMaximum_,
	correlationThreshold_,
	plotColor_,
	frameLabel_,
	data_
]:= Module[{plotData, longestTimeAxes, minMaxTime},

	(*Pull out data for plotting*)
	plotData = #[[;;,2]]&/@dataSets;

	(*Map over time axis to find longest time axis for each data set *)
	longestTimeAxes = Last[Sort[#[[;;,2]]]]&/@dataSets;
	minMaxTime = MinMax[#[[;;,1]]]&/@longestTimeAxes;

	(*Map over valid sets to get multiple plots*)
	MapThread[
		emeraldDLSLPlotHelper[
			#1,
			#2,
			timeThreshold,
			correlationMaximum,
			correlationThreshold,
			plotColor,
			frameLabel,
			data
		]&,
		{plotData, minMaxTime}
	]
];

dlslPlotHelper[
	dataSets_,
	dataField: CorrelationCurve|InitialCorrelationCurve|FinalCorrelationCurve,
	timeThreshold_,
	correlationMaximum_,
	correlationThreshold_,
	plotColor_,
	frameLabel_,
	data_
]:= Module[{longestTimeAxes, minMaxTime, fig},

	(*pull out longest time axes for plotting*)
	longestTimeAxes = Last[Sort[dataSets]];

	(*pull out MinMax time for the epilog which needs to be in show*)
	minMaxTime = MinMax[longestTimeAxes[[;;,1]]];

	(* create a new figure *)
	emeraldDLSLPlotHelper[
		dataSets,
		minMaxTime,
		timeThreshold,
		correlationMaximum,
		correlationThreshold,
		plotColor,
		frameLabel,
		data
	]

];

emeraldDLSLPlotHelper[
	dataSets_,
	minMaxTime_,
	timeThreshold_,
	correlationMaximum_,
	correlationThreshold_,
	plotColor_,
	frameLabel_,
	data_
]:= EmeraldListLinePlot[
		dataSets,
		Scale->LogLinear,
		Zoomable->False,
		PlotStyle->{plotColor},
		PlotRange->All,
		FrameLabel->frameLabel,
		Tooltip->(ToString[#[Object]]&)/@data,
		Epilog->{
			Tooltip[
				Line[
					{
						{Log10[QuantityMagnitude[Min[minMaxTime]]], correlationThreshold},
						{Log10[QuantityMagnitude[Max[minMaxTime]]], correlationThreshold}
					}
				],
				"CorrelationThreshold"
			],
			Tooltip[
				Line[
					{
						{Log10[QuantityMagnitude[timeThreshold]], -10},
						{Log10[QuantityMagnitude[timeThreshold]], 10}
					}
				],
				"TimeThreshold"
			],
			Tooltip[
				Line[
					{
						{Log10[QuantityMagnitude[Min[minMaxTime]]], correlationMaximum},
						{Log10[QuantityMagnitude[Max[minMaxTime]]], correlationMaximum}
					}
				],
				"CorrelationMaximum"
			]
		}
];

dataCheckPrimary[dataSets_, dataField: CorrelationCurves]:= Module[{curveCorrelations, curveMasses},

	(*pull out curveCorrelations and return only numeric data*)
	curveCorrelations = Map[
	(*dataCheck is in DynamicLightScatteringLoading source code*)
		Analysis`Private`dataCheck[#[[;;,2]]]&,
		dataSets
	];

	(*pull out concentrations with multiple fields*)
	curveConcentrations = Map[
		#[[;;,1]]&,
		dataSets
	];

	(*merge the cleaned up data back together*)
	MapThread[
		Transpose[{#1,#2}]&,
		{curveConcentrations, curveCorrelations}
	]

];

(*dataCheck is in DynamicLightScatteringLoading source code*)
dataCheckPrimary[dataSets_, dataField: CorrelationCurve|InitialCorrelationCurve|FinalCorrelationCurve]:= Analysis`Private`dataCheck[dataSets];
