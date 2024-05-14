(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotPAGE*)


DefineOptions[PlotPAGE,
	optionsJoin[
		Options :> {
			{
				OptionName->IncludeLadder,
				Description->"If true, any ladders associated with the data will also be plotted.",
				Default->True,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>Alternatives[BooleanP]],
				Category->"Data Specification"
			},
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
			ModifyOptions[ImagesOption,
				{
					{
						OptionName->Images,
						Default->Automatic,
						Widget->Alternatives[
							Adder[Widget[Type->Enumeration, Pattern:>Alternatives[LowExposureLaneImage,MediumLowExposureLaneImage,MediumHighExposureLaneImage,HighExposureLaneImage,OptimalLaneImage]]],
							Widget[Type->Enumeration, Pattern:>Alternatives[Null]]
						],
						Category->"Hidden"
					}
				}
			],
			ModifyOptions[LinkedObjectsOption,
				{
					{
						OptionName->LinkedObjects,
						Default->{LadderData},
						Widget->Alternatives[
							Adder[Widget[Type->Enumeration, Pattern:>Alternatives[LadderData]]],
							Widget[Type->Enumeration, Pattern:>Alternatives[NeighboringLanes]],
							Widget[Type->Enumeration, Pattern:>Alternatives[Null]]
							],
						Category->"Hidden"
					}
				}
			]
		},
		generateSharedOptions[Object[Data, PAGE], OptimalLaneIntensity, PlotTypes -> {LinePlot}, Display -> {Peaks, Ladder}, DefaultUpdates -> {FrameLabel -> {"Distance", "Summed Pixel Intensity."}}]
	],
	SharedOptions :> {
		EmeraldListLinePlot
	}];


PlotPAGE[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotPAGE]]:=rawToPacket[primaryData,Object[Data,PAGE],PlotPAGE,SafeOptions[PlotPAGE, ToList[inputOptions]]];
(* PlotPAGE[infs:plotInputP,inputOptions:OptionsPattern[PlotPAGE]]:= *)
PlotPAGE[infs:ListableP[ObjectP[Object[Data,PAGE]],2],inputOptions:OptionsPattern[PlotPAGE]]:=Module[
	{imagesOption,primaryDataOption,resolvedImages,resolvedOptions},

	imagesOption=Lookup[ToList[inputOptions],Images,Automatic];
	primaryDataOption=Lookup[ToList[inputOptions],PrimaryData,{}];

	resolvedImages=If[MatchQ[imagesOption,Automatic],
		(* Check if we have PrimaryData specified *)
		Which[
			MatchQ[primaryDataOption,Automatic|{}],{OptimalLaneImage},
			MatchQ[primaryDataOption,LowExposureLaneIntensity|MediumLowExposureLaneIntensity|MediumHighExposureLaneIntensity|HighExposureLaneIntensity|OptimalLaneIntensity],
			{primaryDataOption/.{LowExposureLaneIntensity->LowExposureLaneImage,MediumLowExposureLaneIntensity->MediumLowExposureLaneImage,MediumHighExposureLaneIntensity->MediumHighExposureLaneImage,HighExposureLaneIntensity->HighExposureLaneImage,OptimalLaneIntensity->OptimalLaneImage}},
			True,
			Cases[
				ToList[primaryDataOption],
				LowExposureLaneIntensity|MediumLowExposureLaneIntensity|MediumHighExposureLaneIntensity|HighExposureLaneIntensity|OptimalLaneIntensity
			]/.{LowExposureLaneIntensity->LowExposureLaneImage,MediumLowExposureLaneIntensity->MediumLowExposureLaneImage,MediumHighExposureLaneIntensity->MediumHighExposureLaneImage,HighExposureLaneIntensity->HighExposureLaneImage,OptimalLaneIntensity->OptimalLaneImage}
		],
		imagesOption
	];

	resolvedOptions=ReplaceRule[ToList[inputOptions],Images->resolvedImages];

	packetToELLP[infs,PlotPAGE,resolvedOptions]
];
