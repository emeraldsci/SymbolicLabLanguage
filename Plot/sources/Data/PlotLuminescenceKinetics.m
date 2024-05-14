(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotLuminescenceKinetics*)


DefineOptions[PlotLuminescenceKinetics,
	optionsJoin[
		generateSharedOptions[
			Object[Data,LuminescenceKinetics],
			EmissionTrajectories,
			PlotTypes->{LinePlot},
			SecondaryData->{},
			CategoryUpdates->{
				OptionFunctions->"Hidden",
				Display->"Hidden",
				PrimaryData->"Data Specifications",
				SecondaryData->"Secondary Data",
				IncludeReplicates->"Hidden",
				EmissionTrajectories->"Hidden",
				DualEmissionTrajectories->"Hidden",
				Temperature->"Hidden"
			},
			AllowNullUpdates->{
			}
		],
		Options:>{
			
			ModifyOptions[EmeraldListLinePlot,{SecondYCoordinates},Category->"Hidden"],
			
			ModifyOptions[
				EmeraldListLinePlot,
				{
					{
						OptionName->Scale,
						AllowNull->False
					},
					{
						OptionName->ErrorBars,
						Category->"Hidden"
					},					
					{
						OptionName->ErrorType,
						Category->"Hidden"
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
					}
					
				}
			],
			
			ModifyOptions[EmeraldListLinePlot,{Reflected,Peaks,PeakLabels,PeakLabelStyle,Ladder},Category->"Hidden"]
		
		}
	],
	SharedOptions :> {
		{PlotFluorescenceKinetics,{EmissionWavelength,DualEmissionWavelength}},
		EmeraldListLinePlot
	}
];


(* Raw Definition *)
PlotLuminescenceKinetics[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotLuminescenceKinetics]]:=Module[
	{safeOps,ellpOutput},
	safeOps=SafeOptions[PlotLuminescenceKinetics, ToList[inputOptions]];
	ellpOutput=rawToPacket[primaryData,Object[Data,LuminescenceKinetics],PlotLuminescenceKinetics,safeOps];
	processELLPOutput[ellpOutput,safeOps]
];

(* Packet Definition *)
(* PlotLuminescenceKinetics[infs:plotInputP,inputOptions:OptionsPattern[PlotLuminescenceKinetics]]:= *)
PlotLuminescenceKinetics[infs:ListableP[ObjectP[Object[Data,LuminescenceKinetics]],2],inputOptions:OptionsPattern[PlotLuminescenceKinetics]]:=Module[
	{safeOps},
	safeOps=SafeOptions[PlotLuminescenceKinetics,ToList@inputOptions];
	processELLPOutput[PlotFluorescenceKinetics[infs,inputOptions],safeOps]
];
