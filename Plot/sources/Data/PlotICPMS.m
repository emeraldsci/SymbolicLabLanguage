(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* Input Patterns, Options, Warnings and Error *)
plotRawTypesP = rawPlotInputP;
plotDataTypesP = ObjectP[{Object[Data, ICPMS]}];
plotProtocolTypesP = ObjectP[Object[Protocol, ICPMS]];

plotInputTypesP = Join[
  plotRawTypesP,
  plotDataTypesP,
  plotProtocolTypesP
];

(* ::Subsection:: *)
(* Input Pattern Definitions *)

(* ::Subsection:: *)
(* PlotICPMS Options *)
DefineOptions[PlotICPMS,
	optionsJoin[
		(* In order to let the x-axis showing Mass-To-Charge Ratio (m/z) as the unit, the frame label is hard coded here. will change after we add m/z to EmeraldUnit*)
		generateSharedOptions[Object[Data, ICPMS], MassSpectrum, PlotTypes -> {LinePlot}, Display -> {Peaks}, DefaultUpdates -> {OptionFunctions -> {molecularWeightEpilogs},FrameUnits->{None,None},FrameLabel -> {"Mass-to-Charge Ratio (m/z)", None, None, None}}],
		Options :>{
			{
				OptionName->TickColor,
				Default-> Opacity[0.5, RGBColor[0.75, 0., 0.25]],
				Description->"The color of the molecular weight ticks.",
				Category->"MolecularWeightEpilog",
				AllowNull->True,
				Widget->Widget[Type->Expression,Pattern:>_Opacity|ColorP,Size->Line]
			},
			{
				OptionName->TickStyle,
				Default->{Thickness[Large]},
				Description->"The style for the text labeling the molecular weight ticks.",
				Category->"MolecularWeightEpilog",
				AllowNull->True,
				Widget->Adder[Widget[Type->Expression,Pattern:>LineStyleP,Size->Line]]
			},
			{
				OptionName->TickSize,
				Default-> 0.5,
				Description-> "The fraction of the plot height each primary molecular weight ticks should occupy.",
				Category->"MolecularWeightEpilog",
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern:>RangeP[0,1]]
			},
			{
				OptionName->TickLabel,
				Default-> True,
				Description->"Indicates if the primary molecular weight ticks should be labeled.",
				Category->"MolecularWeightEpilog",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
			}
		}
	],
	SharedOptions :> {
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->Frame,Default->{True,False,False,False}},
				{OptionName->LabelStyle,Default->{Bold, 12, FontFamily -> "Arial"}},
				{OptionName->Filling,Default->Bottom}
			}
		],

		EmeraldListLinePlot
	}
];

(* ::Subsection:: *)
(* Warnings and Errors *)
Error::NoICPMSDataToPlot = "The protocol object does not contain any associated ICPMS data.";
Error::ICPMSProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotICPMS or PlotObject on an individual data object to identify the missing values.";
Error::MissingMassSpectrumData = "`1` missing MassSpectrum data and cannot be plotted."

(* ::Section:: *)
(* Plot Function Main *)

(* ::Subsection:: *)
(* PlotICPMS raw plot overload *)
PlotICPMS[
	myInput: plotRawTypesP,
	myOps: OptionsPattern[PlotICPMS]
]:= Module[{originalOps, safeOps,
		specificOptions,plotOptions,plotOutputs,
		sortedData, dataAsPeaks},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotICPMS,ToList[myOps]];

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions=Normal@KeyTake[safeOps,{TickColor,TickStyle,TickSize,TickLabel}];

	(* Transform Raw Data in Peaks. Assumes raw data for ICPMS is passed in centroid form. *)
	(* rawToPacket is effectively a convoluted way to create a generic packet of the relevant type. RawData has no way of being passed into the correct field,
	so any field specific data manips need to happen within this overload. *)
	sortedData = Switch[
		Head[myInput],
		List, Sort[myInput],
		QuantityArray, sortQuantityArray[myInput]
	];
	dataAsPeaks = Analysis`Private`pointsToPeaks[sortedData];
	
	(* Call rawToPacket[] *)
	plotOutputs=rawToPacket[
		dataAsPeaks,
		Object[Data,ICPMS],
		PlotICPMS,
		(* NOTE - rawToPacket takes safeOps, not originalOps *)
		safeOps
	];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs,safeOps,specificOptions]
];

(* ::Subsection:: *)
(* Protocol Overload *)
PlotICPMS[
	obj: plotProtocolTypesP,
	ops: OptionsPattern[PlotICPMS]
] := Module[{safeOps, output, data,
			previewPlot, plots, resolvedOptions,
			finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotICPMS, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, ICPMS]]..}],
		Message[Error::NoICPMSDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotICPMS[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotICPMS[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::ICPMSProtocolDataNotPlotted];
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

(* ::Subsection:: *)
(* PlotICPMS Data Object overload *)

PlotICPMS[
	myInput:ListableP[plotDataTypesP, 2],
	myOps:OptionsPattern[PlotICPMS]
] := Module[{originalOps,safeOps,specificOptions,
		packets, containsValidData, errorMsgValue, filteredPackets,
		centroidData, sortedCentroidData,
		dataAsPeaks, dataAsPeaksAssocs},
	
	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotICPMS,ToList[myOps]];

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions=Normal@KeyTake[safeOps,{TickColor,TickStyle,TickSize,TickLabel}];

	(* Downlad the actual data in packets. *)
	packets=Download[Flatten[ToList[myInput]]];

	(* packetToELLP below does not gracefully handle empty primary data fields, so drop packets as needed here
	   and raise corresponding warnings. If all packets missing data, return $Failed. *)
	(* Note, since input data could be a link or packet, we perform the check
	   on the packets after downloading. *)
	containsValidData = Map[!MatchQ[#[MassSpectrum], Null]&, packets];
	If[MatchQ[containsValidData, {False..}],
		errorMsgValue = If[Length[containsValidData] == 1, First[packets][Object], "All objects"];
		Message[Error::MissingMassSpectrumData, errorMsgValue];
		Return[$Failed];
	];
	filteredPackets = Pick[packets, containsValidData];
	MapThread[If[!#1, Message[Error::MissingMassSpectrumData, #2[Object]]]&,
		{containsValidData, packets}
	];
			
	(* Apply pointsToPeaks to transform centroid data for plotting. *)
	centroidData = Map[#[MassSpectrum]&, filteredPackets];
	sortedCentroidData = Map[sortQuantityArray[#]&, centroidData];
	dataAsPeaks = Map[Analysis`Private`pointsToPeaks[#]&, sortedCentroidData];
	dataAsPeaksAssocs = Map[<|MassSpectrum->#|>&, dataAsPeaks];
	updatedPackets = Analysis`Private`mapThreadAssociateTo[
		filteredPackets, dataAsPeaksAssocs
	];

	plotOutputs=packetToELLP[
		updatedPackets,
		PlotICPMS,
		(* NOTE - packetToELLP takes originalOps, not safeOps *)
		originalOps
	];
	processELLPOutput[plotOutputs,safeOps,specificOptions]

];


(* ::Subsection:: *)
(* Preview Helper Functions *)

(* NOTE: This file also uses pointsToPeaks and mapThreadAssociateTo functions implemented in Analysis/Numerics/MassSpectrumDeconvolution.m.
sortQuanityArray below complements these functions for sorting mass spec data, but is only used here since sorting is handled elsewhere in the other file.
If these methods are used across more MS plots, consider moving all to a dedicated helper function file. *)

sortQuantityArray[data_QuantityArray] := Module[{},
	QuantityArray[
		Sort[QuantityMagnitude[data]],
		First[QuantityUnit[data]]
	]
];
