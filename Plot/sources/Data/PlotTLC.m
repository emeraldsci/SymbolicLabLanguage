(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotTLC*)


DefineOptions[PlotTLC,
	optionsJoin[
		Options:>{
			{Images -> {LaneImage}, {LaneImage}|{},"A list of fields containing images which should be placed at the top of the plot."}
		},
		generateSharedOptions[Object[Data, TLC], Intensity, PlotTypes -> {LinePlot}, Display -> {Peaks}, DefaultUpdates -> {FrameLabel -> {"Distance", "Summed Pixel Intensity."}}]
	],
	SharedOptions:>{
		EmeraldListLinePlot
	}
];


PlotTLC[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotTLC]]:=rawToPacket[primaryData,Object[Data,TLC],PlotTLC,SafeOptions[PlotTLC, ToList[inputOptions]]];
(* PlotTLC[infs:plotInputP,inputOptions:OptionsPattern[PlotTLC]]:= *)
PlotTLC[infs:ListableP[ObjectP[Object[Data, TLC]],2],inputOptions:OptionsPattern[PlotTLC]]:=packetToELLP[infs,PlotTLC,{inputOptions}];
