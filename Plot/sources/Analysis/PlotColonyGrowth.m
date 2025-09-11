(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotColonyGrowth*)


DefineOptions[PlotColonyGrowth,
	Options :> {
		(* Inherit options without modification *)
		OutputOption,
		FastTrackOption
	}
];

(*Given objects*)
PlotColonyGrowth[id: objectOrLinkP[Object[Analysis, ColonyGrowth]], ops: OptionsPattern[]]:= PlotColonyGrowth[Download[id], ops];
(*Main Overload*)
PlotColonyGrowth[
	myPacket: PacketP[Object[Analysis, ColonyGrowth]],
	myOptions: OptionsPattern[PlotColonyGrowth]
] := Module[
	{
		safeOps, output, packet, alignedImages, importedAlignedImages, resolvedIntermediate, resolvedPacket, finalPlot
	},

	(* Check safe options *)
	safeOps = SafeOptions[PlotColonyGrowth, ToList[myOptions]];
	output = Lookup[safeOps, Output];

	(* Remove the Replace and Append headers *)
	packet = Analysis`Private`stripAppendReplaceKeyHeads[myPacket];

	(* Extract HighlightedColonies image data *)
	alignedImages = Download[Analysis`Private`packetLookup[packet, HighlightedColonies], Object];
	importedAlignedImages = ImportCloudFile[alignedImages];

	(* Create association of intermediate and Packet *)
	resolvedIntermediate = <|
		Data -> Download[Analysis`Private`packetLookup[packet, Reference], Object],
		Images -> importedAlignedImages
	|>;

	resolvedPacket = <|
		Replace[TotalColonyProperties] -> Analysis`Private`packetLookup[packet, TotalColonyProperties],
		Replace[AverageDiameters] -> Analysis`Private`packetLookup[packet, AverageDiameters],
		Replace[AverageSeparations] -> Analysis`Private`packetLookup[packet, AverageSeparations],
		Replace[AverageRegularityRatios] -> Analysis`Private`packetLookup[packet, AverageRegularityRatios],
		Replace[AverageCircularityRatios] -> Analysis`Private`packetLookup[packet, AverageCircularityRatios],
		Replace[TotalColonyCountsLog] -> Analysis`Private`packetLookup[packet, TotalColonyCountsLog]
	|>;

	(* The core of analyzePreviewColonies located in Analysis/ImageProcessing/Colonies. *)
	finalPlot = Lookup[
		Analysis`Private`analyzeColonyGrowthPreview[{
			Intermediate  -> resolvedIntermediate,
			Packet -> resolvedPacket
		}],
		Preview
	];

	(* Return specified output *)
	output /.{
		Result -> finalPlot,
		Preview -> finalPlot,
		Tests -> {},
		Options -> safeOps
	}
];
