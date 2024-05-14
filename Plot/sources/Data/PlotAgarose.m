(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAgarose*)


DefineOptions[PlotAgarose,
	optionsJoin[
		Options:>{
			ModifyOptions[EmeraldListLinePlot,
				{
					{
						OptionName->Filling,
						Default->Bottom,
						Description->"Indicates how the region under the spectrum should be shaded.",
						Category->"Hidden"
					}
				}
			],
			ModifyOptions[ScaleOption,
				{
					{
						OptionName->Scale,
						Default->LogLinear,
						Description->"Specifies the type of scaling the x and y axis will have.",
						Category->"Hidden"
					}
				}
			]
		},
		generateSharedOptions[Object[Data,AgaroseGelElectrophoresis], SampleElectropherogram,PlotTypes -> {LinePlot}, Display -> {Peaks},DefaultUpdates -> {FrameLabel -> {"Strand Length (bp)", "Fluorescence (RFU)"}}]
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];


PlotAgarose[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotAgarose]]:=rawToPacket[primaryData,Object[Data,AgaroseGelElectrophoresis],PlotAgarose,SafeOptions[PlotAgarose, ToList[inputOptions]]];
(* PlotAgarose[infs:plotInputP,inputOptions:OptionsPattern[PlotAgarose]]:= *)
PlotAgarose[infs:ListableP[ObjectP[Object[Data, AgaroseGelElectrophoresis]],2],inputOptions:OptionsPattern[PlotAgarose]]:=Quiet[packetToELLP[infs,PlotAgarose,ToList[inputOptions]],CompiledFunction::cfnlts];
