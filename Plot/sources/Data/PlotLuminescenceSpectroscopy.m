(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotLuminescenceSpectroscopy*)


DefineOptions[PlotLuminescenceSpectroscopy,
	optionsJoin[
		generateSharedOptions[
			Object[Data,LuminescenceSpectroscopy],
			EmissionSpectrum,
			PlotTypes->{LinePlot},
			SecondaryData->{},
			Display->{Peaks},
			DefaultUpdates->{
				Peaks->{}
			},
			AllowNullUpdates->{
				Peaks->False
			},
			CategoryUpdates->{
				OptionFunctions->"Hidden",
				PrimaryData->"Data Specifications",
				SecondaryData->"Hidden",
				IncludeReplicates->"Hidden",
				Peaks->"Peaks",
				EmissionSpectrum->"Hidden"
			}
		],
		Options:>{
		
			ModifyOptions[EmeraldListLinePlot,{Reflected,SecondYUnit,SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle},Category->"Hidden"],
			ModifyOptions[EmeraldListLinePlot,{ErrorBars,ErrorType},Category->"Hidden"],
			
			ModifyOptions[EmeraldListLinePlot,
				{
					{
						OptionName->Scale,
						AllowNull->False
					},
					{
						OptionName->Fractions,
						AllowNull->False,
						Default->{},
						Category->"Fractions"
					},
					{
						OptionName->LegendLabel,
						AllowNull->False
					},				
					{
						OptionName->Filling,
						Default->Bottom
					}
				}
			]
		}
	],
	SharedOptions:>{EmeraldListLinePlot}
];


(* Raw Definition *)
PlotLuminescenceSpectroscopy[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotLuminescenceSpectroscopy]]:=Module[
	{safeOps,ellpOutput},
	safeOps=SafeOptions[PlotLuminescenceSpectroscopy, ToList[inputOptions]];
	ellpOutput=rawToPacket[primaryData,Object[Data,LuminescenceSpectroscopy],PlotLuminescenceSpectroscopy,safeOps];
	processELLPOutput[ellpOutput,safeOps]
];

(* Packet Definition *)
(* PlotLuminescenceSpectroscopy[infs:plotInputP,inputOptions:OptionsPattern[PlotLuminescenceSpectroscopy]]:= *)
PlotLuminescenceSpectroscopy[infs:ListableP[ObjectP[Object[Data, LuminescenceSpectroscopy]],2],inputOptions:OptionsPattern[PlotLuminescenceSpectroscopy]]:=Module[
	{safeOps,ellpOutput},
	safeOps=SafeOptions[PlotLuminescenceSpectroscopy,ToList[inputOptions]];	
	ellpOutput=packetToELLP[infs,PlotLuminescenceSpectroscopy,{inputOptions}];
	processELLPOutput[ellpOutput,safeOps]
];
