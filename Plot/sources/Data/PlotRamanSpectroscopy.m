(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotRamanSpectroscopy*)


DefineOptions[PlotRamanSpectroscopy,
	Options:>{
		{
			OptionName -> ReduceData,
			Default -> Automatic,
			Description -> "Indicates if the number of spectra should be reduced when a dense sampling pattern was used. When True, a maximum of 50 spectra will be plotted.",
			AllowNull -> False,
			Category -> "Raman",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> OutputFormat,
			Default -> All,
			Description -> "Indicates if the output should be a table with all three plots or an individual plot.",
			AllowNull -> False,
			Category -> "Raman",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> All|Average|SpectraByPosition|PositionsWithSpectra
			]
		}
	},
	SharedOptions :> {
		ModifyOptions["Shared",
			EmeraldListLinePlot,
			{
				{OptionName->FrameLabel,Default->{"Raman Shift", Automatic}},
				{OptionName->Zoomable, Default-> True}
			}

		],
		EmeraldListLinePlot
	}
];

(* raman specific messages *)
Error::NoDataForPlotRamanSpectroscopyOutput = "The requested output format `1` requires data which is not included in the input.";
Error::RamanMeasurementPositionSpectraMismatch = "The number of spectra and the number of positions at which they were collected do not match. Please check the input for errors.";
Warning::HighRamanSpectraDensity = "The number of spectra that are plotted may make the output difficult to interpret and increase the amount of time it takes for plots to generate, set ReduceData ->True or Automatic to reduce the data density to 10%.";
Error::NoRamanSpectroscopyDataToPlot = "The protocol object does not contain any associated raman spectroscopy data.";
Error::RamanSpectroscopyProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotRamanSpectroscopy or PlotObject on an individual data object to identify the missing values.";

(* Raw Definition *)
(* multiple spectra with positions and/or average *)
PlotRamanSpectroscopy[dataSets:(rawPlotInputP|Null),positionSets:(rawPlotInputP|Null), averageData:(rawPlotInputP|Null), inputOptions:OptionsPattern[PlotRamanSpectroscopy]]:=
		Module[{nullPacket},
			nullPacket = <|
				Type-> Object[Data,RamanSpectroscopy],
				RamanSpectra -> dataSets,
				MeasurementPositions -> positionSets,
				AverageRamanSpectrum -> averageData
			|>;

			PlotRamanSpectroscopy[nullPacket, inputOptions]
		];

(* Protocol Overload *)
PlotRamanSpectroscopy[
	obj: ObjectP[Object[Protocol, RamanSpectroscopy]],
	ops: OptionsPattern[PlotRamanSpectroscopy]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotRamanSpectroscopy, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, RamanSpectroscopy]]..}],
		Message[Error::NoRamanSpectroscopyDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotRamanSpectroscopy[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotRamanSpectroscopy[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::RamanSpectroscopyProtocolDataNotPlotted];
		Return[$Failed],
		Nothing
	];

	(* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
	outputPlot = If[MemberQ[output, Result],
		If[Length[plots] > 1,
			SlideView[plots],
			First[plots]
		]
	];

	(* If Options were requested, just take the first set of options since they are the same for all plots. Make it a List first just in case there is only one option set. *)
	outputOptions = If[MemberQ[output, Options],
		First[ToList[resolvedOptions]]
	];

	(* Prepare our final result *)
	finalResult = output /. {
		Result -> outputPlot,
		Options -> outputOptions,
		Preview -> previewPlot,
		Tests -> {}
	};

	(* Return the result *)
	If[
		Length[finalResult] == 1,
		First[finalResult],
		finalResult
	]
];

(* Packet Definition *)
PlotRamanSpectroscopy[infs:ListableP[ObjectP[Object[Data,RamanSpectroscopy]]],inputOptions:OptionsPattern[PlotRamanSpectroscopy]]:=Module[
	{
		reduceData, output, outputFormat, listedOptions, safeOps, plotOptions, resolvedReduceData,
		(*downloaded fields*)
		downloadFields, allDownload, allRamanSpectra, allAverageSpectra, allMeasurementPositions,
		ramanSpectra, averageSpectra, measurementPositions,
		(*outputs*)
		fullSpectraOutputOps, averageSpectraOutputOps, samplingPatternOutputOps, samplingPatternOutput3DOps,
		mostlyResolvedOps, resolvedOps, finalResolvedOps, allFormattedPlots, allFinalResolvedOps,
		spectraWithLocations, averageSpectraOutput, samplingPatternOutput, fullSpectraOutput,
		formattedPlot, samplingPatternOutput3D, finalPlot
	},

	(* -- DOWNLOAD AND OPTIONS LOOKUP -- *)

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[inputOptions];
	safeOps= SafeOptions[PlotRamanSpectroscopy,listedOptions];


	(* look up unresolved options *)
	{reduceData, output, outputFormat}= Lookup[safeOps,{ReduceData, Output, OutputFormat}];

	(* pull out the plot options to pass directly to EmeraldListLinePlot *)
	plotOptions = Normal@KeyDrop[safeOps, {ReduceData,OutputFormat}];

	(*We don't need to spend time downloading the big lists stored in RamanSpectra and MeasurementPositions if OutputFormat is set to Average*)
	downloadFields = If[MatchQ[outputFormat,Average],
		{Null,AverageRamanSpectrum, Null},
		{RamanSpectra, AverageRamanSpectrum, MeasurementPositions}
	];

	(* download things we might need *)
	allDownload = Download[
		ToList[infs],
		downloadFields];

	allRamanSpectra = allDownload[[All,1]];
	allAverageSpectra = allDownload[[All,2]];
	allMeasurementPositions = allDownload[[All,3]];

	(* Listable iteration *)
	{allFormattedPlots, allFinalResolvedOps} = Transpose@MapThread[
		Function[{ramanSpectra, averageSpectra, measurementPositions},
			(* do some error checking to make sure index matching is ok *)
			If[!MemberQ[{measurementPositions, ramanSpectra}, Null]&&!SameLengthQ[measurementPositions, ramanSpectra],
				Message[Error::RamanMeasurementPositionSpectraMismatch];
				Return[$Failed]
			];

			(* if theres a lot of data, there is no point in plotting it all because it will be unreadably dense *)
			resolvedReduceData = If[MatchQ[Length[ToList[ramanSpectra]], GreaterP[100]],
				reduceData/.Automatic->True,
				reduceData/.Automatic->False
			];

			(*warn the user that the data is going to be unreadable*)
			If[MatchQ[Length[ToList[ramanSpectra]], GreaterP[500]]&&MatchQ[resolvedReduceData, False],
				Message[Warning::HighRamanSpectraDensity, Length[ToList[ramanSpectra]]]
			];

			(* -- PREPARE OUTPUT -- *)

			(*clean up the data if requested*)
			spectraWithLocations = If[!MemberQ[{measurementPositions, ramanSpectra}, Null],
				Module[{combinedPositionandSpectra},

					(* combine them so that we can properly pair down the data density *)
					combinedPositionandSpectra = Transpose[{measurementPositions, ramanSpectra}];

					(* pair the data -right now we just take every 50th spectrum *)
					If[MatchQ[resolvedReduceData, True],

						(* partition by the appropriate group and  *)
						Partition[combinedPositionandSpectra, (Round[Length[ramanSpectra]/50, 1])/.(0->1)][[All,1]],

						(*if we arent pairing, just leave it*)
						combinedPositionandSpectra
					]
				],

				(* if either one is Null, we have either already thrown an error or wont be using this anyway *)
				Null
			];

			(* Generate the plots *)

			(* prepare the average spectrum output if requested *)
			{averageSpectraOutput, averageSpectraOutputOps} = If[MatchQ[averageSpectra, Except[Null]]&&MatchQ[outputFormat, (All|Average)],
				EmeraldListLinePlot[averageSpectra, ReplaceRule[plotOptions, {Output -> {Result, Options}}]],
				{Null, Null}
			];


			{{samplingPatternOutput, samplingPatternOutputOps}, {samplingPatternOutput3D, samplingPatternOutput3DOps}} =
					If[!MemberQ[{measurementPositions, ramanSpectra}, Null] && MatchQ[outputFormat, All | PositionsWithSpectra],

						Module[{tooltip2D, tooltip3D, ops},

							(* Generate shared tooltip data with plot for each point *)
							(* Zoomable is set to False as these plots are part of a tooltip*)
							{tooltip2D, tooltip3D, ops} =
									Transpose @ Map[
										With[{plot = EmeraldListLinePlot[#[[2]], ReplaceRule[plotOptions, {Output -> {Result, Options}, Zoomable -> False}]]},
											{Tooltip[Most[#[[1]]], plot[[1]]], Tooltip[#[[1]], plot[[1]]], plot[[2]]}
										]&,
										spectraWithLocations
									];

							{
								{ListLinePlot[tooltip2D, AspectRatio -> 1, PlotMarkers -> {Automatic, Scaled[0.02]}, Axes -> None], ops[[1]]},
								{ListPointPlot3D[tooltip3D, AspectRatio -> 1, Axes -> None], ops[[1]]}
							}
						],
						{{Null, Null}, {Null, Null}}
					];

			(* prepare the full output *)
			{fullSpectraOutput, fullSpectraOutputOps} = If[!MemberQ[{measurementPositions, ramanSpectra}, Null]&&MatchQ[outputFormat, (All|SpectraByPosition)],
				Module[{data, positions, listOptions, newOptions},
					data = spectraWithLocations[[All,2]];
					positions = spectraWithLocations[[All,1]];
					listOptions = plotOptions;

					(* if they have not specified a Tooltip do that here. *)
					newOptions = If[MatchQ[Lookup[plotOptions, Tooltip, Null], (Automatic|Null)],
						ReplaceRule[listOptions,Tooltip -> {ToString/@positions}],
						listOptions
					];

					(*output the plot and options*)
					EmeraldListLinePlot[data, ReplaceRule[newOptions, {Output -> {Result, Options}}]]
				],
				{Null, Null}
			];

			mostlyResolvedOps = Switch[
				outputFormat,

				All,
				fullSpectraOutputOps,

				Average,
				averageSpectraOutputOps,

				PositionsWithSpectra,
				samplingPatternOutput3DOps,

				SpectraByPosition,
				fullSpectraOutputOps
			];

			(* check that the output is going to work and error out if Not *)
			Which[

				(*if anything is not there, cant do all*)
				MatchQ[outputFormat, All]&&MatchQ[Length[{fullSpectraOutput/.Null->Nothing, samplingPatternOutput, averageSpectraOutput}], LessP[3]],
				Message[Error::NoDataForPlotRamanSpectroscopyOutput, outputFormat];
				Return[$Failed],

				(* check average data *)
				MatchQ[outputFormat, Average]&&MatchQ[averageSpectraOutput, Nothing],
				Message[Error::NoDataForPlotRamanSpectroscopyOutput, outputFormat];
				Return[$Failed],

				(* check average data *)
				MatchQ[outputFormat, Positions]&&MatchQ[samplingPatternOutput, Nothing],
				Message[Error::NoDataForPlotRamanSpectroscopyOutput, outputFormat];
				Return[$Failed],

				(* check average data *)
				MatchQ[outputFormat, Spectra]&&MatchQ[fullSpectraOutput, Null],
				Message[Error::NoDataForPlotRamanSpectroscopyOutput, outputFormat];
				Return[$Failed],

				(* checks pass *)
				True,
				Null
			];

			(* Prepare the options for return *)
			(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
			resolvedOps = ReplaceRule[safeOps, Prepend[mostlyResolvedOps, Output -> output], Append->False];

			(* Options with special resolution in PlotRaman *)
			finalResolvedOps = ReplaceRule[resolvedOps,
				(* Any custom options which need special resolution *)
				{ReduceData -> resolvedReduceData},
				Append -> False
			];


			(* return the plot table of the three plots or the selected plot type *)
			formattedPlot = Switch[
				outputFormat,

				All,
				TabView[
					{
						"Averaged Spectrum"-> averageSpectraOutput,
						"Sampling Pattern with Spectra (2D)"-> samplingPatternOutput,
						"Sampling Pattern with Spectra (3D)"-> samplingPatternOutput3D,
						"Spectra from Sampling Position"->fullSpectraOutput
					},
					Alignment -> Center
				],

				Average,
				averageSpectraOutput,

				PositionsWithSpectra,
				samplingPatternOutput,

				SpectraByPosition,
				fullSpectraOutput
			];

			(* Return the plot and resolved options *)
			{formattedPlot, finalResolvedOps}
		],
		{allRamanSpectra, allAverageSpectra, allMeasurementPositions}
	];

	(* Throw things into a slideview if needed *)
	finalPlot = If[Length[allFormattedPlots]==1,
		First[allFormattedPlots],
		TabView[
			Thread[Download[ToList[infs], ID]->allFormattedPlots]
		]
	];

	(* Return the requested outputs *)
	output/.{
		Result->finalPlot,
		Options->First[allFinalResolvedOps],
		Preview->finalPlot,
		Tests->{}
	}
];
