(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFragmentAnalysis*)


DefineOptions[PlotFragmentAnalysis,
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
		generateSharedOptions[Object[Data,FragmentAnalysis], Electropherogram,PlotTypes -> {LinePlot}, Display -> {Peaks},DefaultUpdates -> {FrameLabel -> {"Time", "Fluorescence (RFU)"}}]
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}
];


PlotFragmentAnalysis[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotFragmentAnalysis]]:=rawToPacket[primaryData,Object[Data,PlotFragmentAnalysis],PlotFragmentAnalysis,SafeOptions[PlotFragmentAnalysis, ToList[inputOptions]]];
(* PlotFragmentAnalysis[infs:plotInputP,inputOptions:OptionsPattern[PlotFragmentAnalysis]]:= *)
PlotFragmentAnalysis[infs:plotInputP,inputOptions:OptionsPattern[PlotFragmentAnalysis]]:=Quiet[packetToELLP[infs,PlotFragmentAnalysis,ToList[inputOptions]],CompiledFunction::cfnlts];
