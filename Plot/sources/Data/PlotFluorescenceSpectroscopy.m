(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceSpectroscopy*)


DefineOptions[PlotFluorescenceSpectroscopy,
	optionsJoin[
		generateSharedOptions[Object[Data,FluorescenceSpectroscopy],{ExcitationSpectrum,EmissionSpectrum},PlotTypes->{LinePlot},SecondaryData->{},Display->{Peaks},CategoryUpdates->{OptionFunctions->"Hidden"}],
		Options:>{ModifyOptions["Shared",EmeraldListLinePlot,{OptionName->Filling,Default->Bottom,Category->"Hidden"}]}
	],
	SharedOptions:>{EmeraldListLinePlot}
];


(* Raw Definition *)
PlotFluorescenceSpectroscopy[
	primaryData:rawPlotInputP,
	inputOptions:OptionsPattern[PlotFluorescenceSpectroscopy]
]:=Module[
	{originalOps, safeOps, plotOutputs},

	(* Convert the original options into a list *)
	originalOps = ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotFluorescenceSpectroscopy, originalOps]/.{
		Rule[PrimaryData,_]->Rule[PrimaryData,ExcitationSpectrum]
	};

	(* get the plot(s) *)
	plotOutputs = rawToPacket[
		primaryData,
		Object[Data,FluorescenceSpectroscopy],
		PlotFluorescenceSpectroscopy,
		safeOps
	];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs, safeOps]
];

(* Packet Definition *)
(* PlotFluorescenceSpectroscopy[infs:plotInputP,inputOptions:OptionsPattern[PlotFluorescenceSpectroscopy]]:= *)
PlotFluorescenceSpectroscopy[
	infs:ListableP[ObjectP[{Object[Data, FluorescenceSpectroscopy],Object[Data, LuminescenceSpectroscopy]}],2],
	inputOptions:OptionsPattern[PlotFluorescenceSpectroscopy]
]:=Module[
	{originalOps, safeOps, plotOutputs},

	(* Convert the original options into a list *)
	originalOps = ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotFluorescenceSpectroscopy, originalOps];

	(* get the plot(s) *)
	plotOutputs = packetToELLP[
		infs,
		PlotFluorescenceSpectroscopy,
		originalOps
	];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs, safeOps]
];
