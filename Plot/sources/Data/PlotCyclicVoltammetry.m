(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCyclicVoltammetry*)


DefineOptions[PlotCyclicVoltammetry,
	Options:>{
		{
			OptionName -> MeasurementType,
			Default -> Automatic,
			Description -> "Indicates which type(s) of the cyclic voltammetry data is being plotted. If a CyclicVoltammetry protocol is used as the input, MeasurementTypes is set to All. If a CyclicVoltammetry data object is used as the input, this option is ignored.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[All, CyclicVoltammetryDataTypeP]
			]
		}
	},
	SharedOptions :> {
		EmeraldListLinePlot
	}
];

(* raman specific messages *)
Error::NoDataForPlotCyclicVoltammetryMeasurementType = "The requested measurement type `1` requires data which is not included in the input CyclicVoltammetry protocol.";

(* Packet Definition *)
PlotCyclicVoltammetry[
	myInput:ObjectP[{Object[Protocol,CyclicVoltammetry],Object[Data,CyclicVoltammetry]}],
	inputOptions:OptionsPattern[PlotCyclicVoltammetry]
]:=Module[
	{
		listedOptions, safeOps, output, measurementType, resolvedMeasurementType, plotOptions,

		(*downloaded fields*)
		dataProtocol, electrodePretreatmentData, electrodePretreatmentDataPackets, cyclicVoltammetryData, cyclicVoltammetryDataPackets, postMeasurementAdditionData, postMeasurementAdditionDataPackets, allDataPackets,

		(* output for single data plot *)
		currentPlot, currentPlotOps, currentPlotResolvedMeasurementType,

		(* output for protocol plot *)
		electrodePretreatmentDataPlot, cyclicVoltammetryDataPlot, postMeasurementAdditionDataPlot, finalPlot, resolvedOps
	},

	(* -- DOWNLOAD AND OPTIONS LOOKUP -- *)

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[inputOptions];
	safeOps = SafeOptions[PlotCyclicVoltammetry,listedOptions];

	(* look up unresolved options *)
	{output, measurementType} = Lookup[safeOps,{Output, MeasurementType}];

	(* Resolve measurementType *)
	resolvedMeasurementType = measurementType /. {Automatic -> All};

	(* pull out the plot options to pass directly to EmeraldListLinePlot *)
	plotOptions = KeyDrop[safeOps, {MeasurementType}];

	(* If we are dealing with a data object, we do a quick download to find out the protocol *)
	dataProtocol = If[MatchQ[myInput, ObjectP[Object[Data, CyclicVoltammetry]]],

		(* If myInput is a data object, download its Protocol *)
		Download[myInput, Protocol] /. {x:ObjectP[]:>Download[x,Object]},

		(* If myInput is already a protocol, set it to myInput *)
		myInput
	];

	(* download things we need *)
	{
		electrodePretreatmentData,
		electrodePretreatmentDataPackets,
		cyclicVoltammetryData,
		cyclicVoltammetryDataPackets,
		postMeasurementAdditionData,
		postMeasurementAdditionDataPackets
	} = Download[
		dataProtocol,
		{
			ElectrodePretreatmentData,
			Packet[ElectrodePretreatmentData[{SamplesIn, LoadingSample, DataType, RawVoltammograms, VoltammogramPotentials}]],
			CyclicVoltammetryData,
			Packet[CyclicVoltammetryData[{SamplesIn, LoadingSample, DataType, RawVoltammograms, VoltammogramPotentials}]],
			PostMeasurementStandardAdditionData,
			Packet[PostMeasurementStandardAdditionData[{SamplesIn, LoadingSample, DataType, RawVoltammograms, VoltammogramPotentials}]]
		}
	] /. {x:LinkP[]:>Download[x,Object]};

	(* Generate a allDataPackets so we can search easier *)
	allDataPackets = Join[electrodePretreatmentDataPackets, cyclicVoltammetryDataPackets, postMeasurementAdditionDataPackets];

	(* -- PREPARE OUTPUT -- *)

	(* Generate a currentPlot if myInput is a data Object *)
	{currentPlot, currentPlotOps, currentPlotResolvedMeasurementType} = If[MatchQ[myInput, ObjectP[Object[Data, CyclicVoltammetry]]],

		(* If myInput is a data object, generate the plot *)
		Module[{samplesIn, sampleInName, loadingSample, loadingSampleName, dataType, rawVoltammograms, potentials, plot, plotOps, curveLength, legends, title},

			(* Get the information from the allDataPackets *)
			{samplesIn, loadingSample, dataType, rawVoltammograms, potentials} = Lookup[Experiment`Private`fetchPacketFromCache[Download[myInput, Object], allDataPackets], {SamplesIn, LoadingSample, DataType, RawVoltammograms, VoltammogramPotentials}];

			(* Generate the legends *)
			curveLength = Length[rawVoltammograms];
			legends = Take[{"Primary", "Secondary", "Tertiary", "Quaternary"}, curveLength];

			(* Generate a title *)
			sampleInName = ECL`InternalUpload`ObjectToString[First[samplesIn], Cache -> allDataPackets];
			loadingSampleName = ECL`InternalUpload`ObjectToString[loadingSample, Cache -> allDataPackets];
			title = StringJoin[{"SampleIn: ", sampleInName, "\n LoadingSample: ", loadingSampleName, "\n", ToString[dataType]}];

			(* generate the data and options *)
			{plot, plotOps} = EmeraldListLinePlot[rawVoltammograms, ReplaceRule[Normal[plotOptions], {Legend -> legends, PlotLabel -> Style[title, 12], Output -> {Result, Options}}]];

			(* Return the results *)
			{plot, plotOps, dataType}
		],

		(* If myInput is a protocol, return a bunch of Null's *)
		{Null, Null, Null}
	];

	(* Return early if we have the currentPlot *)
	If[!MatchQ[currentPlot, Null],
		Return[
			output/.{
				Result -> currentPlot,
				Options -> ReplaceRule[
					currentPlotOps,
					Prepend[{MeasurementType -> currentPlotResolvedMeasurementType}, Output -> output],
					Append -> True
				],
				Preview -> currentPlot,
				Tests->{}
			}
		]
	];

	(* --- If we reach to this part, which means the input is a CyclicVoltammetry protocol, we need to go through all the ElectrodePretreatment, CyclicVoltammetry, and PostMeasurementStandardAdditionData --- *)
	(* First we do the error checking *)
	Which[

		(* If MeasurementType is set to ElectrodePretreatment and we do not have the data *)
		MatchQ[resolvedMeasurementType, ElectrodePretreatment]&&MatchQ[electrodePretreatmentData, ({}|{Null..})],
		Message[Error::NoDataForPlotCyclicVoltammetryMeasurementType, resolvedMeasurementType];
		Return[$Failed],

		(* If MeasurementType is set to PostMeasurementStandardAddition and we do not have the data *)
		MatchQ[resolvedMeasurementType, PostMeasurementStandardAddition]&&MatchQ[postMeasurementAdditionData, ({}|{Null..})],
		Message[Error::NoDataForPlotCyclicVoltammetryMeasurementType, resolvedMeasurementType];
		Return[$Failed]
	];

	(* -- ElectrodePretreatment data -- *)
	electrodePretreatmentDataPlot = If[!MatchQ[electrodePretreatmentData, ({}|{Null..})],
		(* If we have electrodePretreatmentData, continue *)
		Module[{dataPlot, subPlots, sampleNames},
			{subPlots, sampleNames} = Transpose[Map[
				Function[{data},
					(* Check if the current data is Null *)
					If[!MatchQ[data, Null],

						(* If it's not Null, continue *)
						Module[{samplesIn, sampleInName, loadingSample, loadingSampleName, dataType, rawVoltammograms, potentials, plot, plotOps, curveLength, legends, title},

							(* Get the information from the allDataPackets *)
							{samplesIn, loadingSample, dataType, rawVoltammograms, potentials} = Lookup[Experiment`Private`fetchPacketFromCache[data, allDataPackets], {SamplesIn, LoadingSample, DataType, RawVoltammograms, VoltammogramPotentials}];

							(* Generate the legends *)
							curveLength = Length[rawVoltammograms];
							legends = Take[{"Primary", "Secondary", "Tertiary", "Quaternary"}, curveLength];

							(* Generate a title *)
							sampleInName = ECL`InternalUpload`ObjectToString[First[samplesIn], Cache -> allDataPackets];
							loadingSampleName = ECL`InternalUpload`ObjectToString[loadingSample, Cache -> allDataPackets];
							title = StringJoin[{"SampleIn: ", sampleInName, "\n LoadingSample: ", loadingSampleName, "\n", ToString[dataType]}];

							(* generate the data and options *)
							{plot, plotOps} = EmeraldListLinePlot[rawVoltammograms, ReplaceRule[Normal[plotOptions], {Legend -> legends, PlotLabel -> Style[title, 12], Output -> {Result, Options}}]];

							(* Return the results *)
							{plot, sampleInName}
						],

						(* If current data is Null, return {Null, Null} *)
						{Null, Null}
					]
				],
				electrodePretreatmentData
			]];

			(* Construct the electrodePretreatmentDataPlot *)
			dataPlot = MapThread[
				If[(!MatchQ[#1, Null] && !MatchQ[#2, Null]),
					(#2 -> Zoomable[#1]),

					(* If they are Null, return Nothing *)
					Nothing
				]&,
				{subPlots, sampleNames}
			];

			(* Return the TabView. NOTE: here we don't have to check if dataPlot is an empty list, since that case means the electrodePretreatmentData is {Null..}, which is taken care of earlier *)
			TabView[
				dataPlot,
				Alignment -> Center
			]
		],

		(* If we don't have electrodePretreatmentData, return Null *)
		Null
	];

	(* -- CyclicVoltammetry data (we always have) -- *)
	cyclicVoltammetryDataPlot = Module[{dataPlot, subPlots, sampleNames},
		{subPlots, sampleNames} = Transpose[Map[
			Function[{data},
				Module[{samplesIn, sampleInName, loadingSample, loadingSampleName, dataType, rawVoltammograms, potentials, plot, plotOps, curveLength, legends, title},

					(* Get the information from the allDataPackets *)
					{samplesIn, loadingSample, dataType, rawVoltammograms, potentials} = Lookup[Experiment`Private`fetchPacketFromCache[data, allDataPackets], {SamplesIn, LoadingSample, DataType, RawVoltammograms, VoltammogramPotentials}];

					(* Generate the legends *)
					curveLength = Length[rawVoltammograms];
					legends = Take[{"Primary", "Secondary", "Tertiary", "Quaternary"}, curveLength];

					(* Generate a title *)
					sampleInName = ECL`InternalUpload`ObjectToString[First[samplesIn], Cache -> allDataPackets];
					loadingSampleName = ECL`InternalUpload`ObjectToString[loadingSample, Cache -> allDataPackets];
					title = StringJoin[{"SampleIn: ", sampleInName, "\n LoadingSample: ", loadingSampleName, "\n", ToString[dataType]}];

					(* generate the data and options *)
					{plot, plotOps} = EmeraldListLinePlot[rawVoltammograms, ReplaceRule[Normal[plotOptions], {Legend -> legends, PlotLabel -> Style[title, 12], Output -> {Result, Options}}]];

					(* Return the results *)
					{plot, sampleInName}
				]
			],
			cyclicVoltammetryData
		]];

		(* Construct the cyclicVoltammetryDataPlot *)
		dataPlot = MapThread[
			(#2 -> Zoomable[#1])&,
			{subPlots, sampleNames}
		];

		(* Return the result *)
		TabView[
			dataPlot,
			Alignment -> Center
		]
	];

	(* -- PostMeasurementAddition data -- *)
	postMeasurementAdditionDataPlot = If[!MatchQ[postMeasurementAdditionData, ({}|{Null..})],
		(* If we have postMeasurementAdditionData, continue *)
		Module[{dataPlot, subPlots, sampleNames},
			{subPlots, sampleNames} = Transpose[Map[
				Function[{data},
					(* Check if the current data is Null *)
					If[!MatchQ[data, Null],

						(* If it's not Null, continue *)
						Module[{samplesIn, sampleInName, loadingSample, loadingSampleName, dataType, rawVoltammograms, potentials, plot, plotOps, curveLength, legends, title},

							(* Get the information from the allDataPackets *)
							{samplesIn, loadingSample, dataType, rawVoltammograms, potentials} = Lookup[Experiment`Private`fetchPacketFromCache[data, allDataPackets], {SamplesIn, LoadingSample, DataType, RawVoltammograms, VoltammogramPotentials}];

							(* Generate the legends *)
							curveLength = Length[rawVoltammograms];
							legends = Take[{"Primary", "Secondary", "Tertiary", "Quaternary"}, curveLength];

							(* Generate a title *)
							sampleInName = ECL`InternalUpload`ObjectToString[First[samplesIn], Cache -> allDataPackets];
							loadingSampleName = ECL`InternalUpload`ObjectToString[loadingSample, Cache -> allDataPackets];
							title = StringJoin[{"SampleIn: ", sampleInName, "\n LoadingSample: ", loadingSampleName, "\n", ToString[dataType]}];

							(* generate the data and options *)
							{plot, plotOps} = EmeraldListLinePlot[rawVoltammograms, ReplaceRule[Normal[plotOptions], {Legend -> legends, PlotLabel -> Style[title, 12], Output -> {Result, Options}}]];

							(* Return the results *)
							{plot, sampleInName}
						],

						(* If current data is Null, return {Null, Null} *)
						{Null, Null}
					]
				],
				postMeasurementAdditionData
			]];

			(* Construct the postMeasurementAdditionDataPlot *)
			dataPlot = MapThread[
				If[(!MatchQ[#1, Null] && !MatchQ[#2, Null]),
					(#2 -> Zoomable[#1]),

					(* If they are Null, return Nothing *)
					Nothing
				]&,
				{subPlots, sampleNames}
			];

			(* Return the TabView. NOTE: here we don't have to check if dataPlot is an empty list, since that case means the postMeasurementAdditionData is {Null..}, which is taken care of earlier *)
			TabView[
				dataPlot,
				Alignment -> Center
			]
		],

		(* If we don't have postMeasurementAdditionData, return Null *)
		Null
	];

	(* Construct the final plot *)
	finalPlot = TabView[
		{
			(* electrodePretreatDataPlot *)
			If[MatchQ[resolvedMeasurementType, Alternatives[All, ElectrodePretreatment]]&&!MatchQ[electrodePretreatmentData, ({}|{Null..})],
				"Electrode Pretreatment Data" -> electrodePretreatmentDataPlot,
				Nothing
			],

			(* cyclicVoltammetryDataPlot *)
			If[MatchQ[resolvedMeasurementType, Alternatives[All, CyclicVoltammetryMeasurement]],
				"Cyclic Voltammetry Measurement Data" -> cyclicVoltammetryDataPlot,
				Nothing
			],

			(* postMeasurementAdditionDataPlot *)
			If[MatchQ[resolvedMeasurementType, Alternatives[All, PostMeasurementStandardAddition]]&&!MatchQ[postMeasurementAdditionData, ({}|{Null..})],
				"Post Measurement Standard Addition Data" -> postMeasurementAdditionDataPlot,
				Nothing
			]
		},
		Alignment -> Center
	];

	(* Prepare the options for return *)
	(* NOTE: if we are plotting a whole protocol object, since there are so many subplots, we only change the MeasurementType option of the input options *)
	resolvedOps = ReplaceRule[
		safeOps,
		Prepend[{MeasurementType -> resolvedMeasurementType}, Output -> output],
		Append -> False
	];

	(* Return the requested outputs *)
	output/.{
		Result->finalPlot,
		Options->resolvedOps,
		Preview->finalPlot,
		Tests->{}
	}
];
