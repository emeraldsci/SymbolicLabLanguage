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
			Description -> "Indicates if the number of spectra should be reduced when a dense sampling pattern was used. When True, only 10% of the collected spectra will be plotted.",
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
			ListPlotOptions,
			{OptionName->FrameLabel,Default->{"Raman Shift", Automatic}}
		],
		EmeraldListLinePlot
	}
];

(* raman specific messages *)
Error::NoDataForPlotRamanSpectroscopyOutput = "The requested output format `1` requires data which is not included in the input.";
Error::RamanMeasurementPositionSpectraMismatch = "The number of spectra and the number of positions at which they were collected do not match. Please check the input for errors.";
Warning::HighRamanSpectraDensity = "The number of spectra that are plotted may make the output difficult to interpret and increase the amount of time it takes for plots to generate, set ReduceData ->True or Automatic to reduce the data density to 10%.";

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

(* Packet Definition *)
PlotRamanSpectroscopy[infs:ListableP[ObjectP[Object[Data,RamanSpectroscopy]]],inputOptions:OptionsPattern[PlotRamanSpectroscopy]]:=Module[
	{
		reduceData, output, outputFormat, listedOptions, safeOps, plotOptions, resolvedReduceData,
		(*downloaded fields*)
		allDownload, allRamanSpectra, allAverageSpectra, allMeasurementPositions,
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
	safeOps=SafeOptions[PlotRamanSpectroscopy,listedOptions];

	(* look up unresolved options *)
	{reduceData, output, outputFormat}=Lookup[safeOps,{ReduceData, Output, OutputFormat}];

	(* pull out the plot options to pass directly to EmeraldListLinePlot *)
	plotOptions = Normal@KeyDrop[safeOps, {ReduceData,OutputFormat}];

	(* download things we might need *)
	allDownload = Download[
		ToList[infs],
		{RamanSpectra, AverageRamanSpectrum, MeasurementPositions}
	];

	allRamanSpectra = allDownload[[All,1]];
	allAverageSpectra = allDownload[[All,2]];
	allMeasurementPositions = allDownload[[All,3]];

	(* Listable iteration *)
	{allFormattedPlots, allFinalResolvedOps} = Transpose@MapThread[
		Function[{ramanSpectra, averageSpectra, measurementPositions},
			(* do some error checking to make sure index matchign is ok *)
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

					(* pare the data -right now we jsut take 10 % when this is reuqested *)
					If[MatchQ[resolvedReduceData, True],

						(* partition by the appropriate group and  *)
						Partition[combinedPositionandSpectra, (Round[Length[ramanSpectra]/10, 1])/.(0->1)][[All,1]],

						(*if we arent paring, just leave it*)
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

			(* prepare the sampling pattern based output *)
			{samplingPatternOutput, samplingPatternOutputOps}= If[!MemberQ[{measurementPositions, ramanSpectra}, Null]&&MatchQ[outputFormat, (All|PositionsWithSpectra)],
				Module[{positionsWithToolTip, positionsWithToolTipOps},

					(* attach the spectra to each position in the sampling pattern - just take the x, y here*)
					{positionsWithToolTip, positionsWithToolTipOps} = Transpose@Map[Module[{plot,ops},
						{plot, ops} = EmeraldListLinePlot[#[[2]], ReplaceRule[plotOptions, {Output -> {Result, Options}}]];

						{Tooltip[Most[#[[1]]], plot], ops}
					]&, spectraWithLocations];

					(* make the plot of the positions so they can mouseover to get the spectra *)
					{ListLinePlot[positionsWithToolTip, AspectRatio->1, PlotMarkers->{Automatic, Scaled[0.02]}, Axes ->None], positionsWithToolTipOps[[1]]}
				],
				{Null, Null}
			];

			(* prepare the sampling pattern based output *)
			{samplingPatternOutput3D, samplingPatternOutput3DOps} = If[!MemberQ[{measurementPositions, ramanSpectra}, Null]&&MatchQ[outputFormat, (All|PositionsWithSpectra)],
				Module[{positionsWithToolTip, positionsWithToolTipOps},

					(* attache the spectra to each position in the sampling pattern *)
					{positionsWithToolTip, positionsWithToolTipOps} = Transpose@Map[Module[{plot,ops},
						{plot, ops} = EmeraldListLinePlot[#[[2]], ReplaceRule[plotOptions, {Output -> {Result, Options}}]];

						{Tooltip[#[[1]], plot], ops}
					]&, spectraWithLocations];

					(* make the plot of the positions so they can mouseover to t get hte spectra *)
					{ListPointPlot3D[positionsWithToolTip, AspectRatio->1, Axes ->None], positionsWithToolTipOps[[1]]}
				],
				{Null,Null}
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
						"Averaged Spectrum"-> Zoomable[
							averageSpectraOutput
						],
						"Sampling Pattern with Spectra (2D)"-> Zoomable[
							samplingPatternOutput
						],
						"Sampling Pattern with Spectra (3D)"-> Zoomable[
							samplingPatternOutput3D
						],
						"Spectra from Sampling Position"-> Zoomable[
							fullSpectraOutput
						]
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
