(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotWestern*)


DefineOptions[PlotWestern,
	optionsJoin[
		Options :> {ModifyOptions[EmeraldListLinePlot, Filling,Default-> Bottom,Category->"Hidden"]},
		generateSharedOptions[Object[Data,Western], MassSpectrum, PlotTypes -> {LinePlot}, Display -> {Peaks, Ladder}]
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];


PlotWestern[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotWestern]]:=
    rawToPacket[primaryData,Object[Data,Western],PlotWestern,SafeOptions[PlotWestern, ToList[inputOptions]]];
(* PlotWestern[infs:plotInputP,inputOptions:OptionsPattern[PlotWestern]]:= *)
PlotWestern[infs:ListableP[ObjectP[Object[Data,Western]],2],inputOptions:OptionsPattern[PlotWestern]]:=
    packetToELLP[infs,PlotWestern,ToList[inputOptions]];
