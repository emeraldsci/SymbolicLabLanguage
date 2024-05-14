(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotICPMS*)


(*PlotICPMS Options*)
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

(* PlotICPMS raw plot overload *)
PlotICPMS[myInput:rawPlotInputP, myOps:OptionsPattern[PlotICPMS]]:=Module[
	{originalOps,safeOps,plotData,specificOptions,plotOptions,plotOutputs},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotICPMS,ToList[myOps]];

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions=Normal@KeyTake[safeOps,{TickColor,TickStyle,TickSize,TickLabel}];

	(* Call rawToPacket[] *)
	plotOutputs=rawToPacket[
		myInput,
		Object[Data,ICPMS],
		PlotICPMS,
		(* NOTE - rawToPacket takes safeOps, not originalOps *)
		safeOps
	];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs,safeOps,specificOptions]
];

(* PlotICPMS Data Object overload *)
(* PlotICPMS[myInput:plotInputP, myOps:OptionsPattern[PlotICPMS]]:= *)
PlotICPMS[myInput:ListableP[ObjectP[{Object[Data, ICPMS],Object[Data, ChromatographyMassSpectra],Object[Data, MassSpectrometry]}],2], myOps:OptionsPattern[PlotICPMS]]:=Module[
	{originalOps,safeOps,specificOptions,packets},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotICPMS,ToList[myOps]];

	(* Options specific to your function which do not get passed directly to the underlying plot *)
	specificOptions=Normal@KeyTake[safeOps,{TickColor,TickStyle,TickSize,TickLabel}];

	packets=Download[Flatten[ToList[myInput]]];


	(* Call packetToELLP or rawToPacket[] *)
	Module[
		{plotOutputs},
		plotOutputs=packetToELLP[
			myInput,
			PlotICPMS,
			(* NOTE - packetToELLP takes originalOps, not safeOps *)
			originalOps
		];
		(* Use the processELLPOutput helper *)
		processELLPOutput[plotOutputs,safeOps,specificOptions]

	]

];
