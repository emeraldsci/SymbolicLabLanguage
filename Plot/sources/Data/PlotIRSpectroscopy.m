(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotIRSpectroscopy*)


(* ::Subsubsection:: *)
(*PlotIRSpectroscopy*)


DefineOptions[PlotIRSpectroscopy,
	optionsJoin[
		generateSharedOptions[Object[Data, IRSpectroscopy], TransmittanceSpectrum, PlotTypes -> {LinePlot}, Display -> {Peaks}],
		Options:>{
			(* Change the defaults on these options *)
			ModifyOptions[EmeraldListLinePlot,
				{
					{OptionName -> Filling, Default -> Bottom},
					{OptionName -> Reflected, Default -> True},
					{OptionName -> Frame, Default -> {True, True, False, True}}
				}
			]
		}
	],
	SharedOptions:>{EmeraldListLinePlot}
];

Error::NoIRSpectroscopyDataToPlot = "The protocol object does not contain any associated IR spectroscopy data.";
Error::IRSpectroscopyProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotIRSpectroscopy or PlotObject on an individual data object to identify the missing values.";

(*Raw definition*)
PlotIRSpectroscopy[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotIRSpectroscopy]]:=rawToPacket[primaryData,Object[Data,IRSpectroscopy],PlotIRSpectroscopy,SafeOptions[PlotIRSpectroscopy, ToList[inputOptions]]];

(* Protocol Overload *)
PlotIRSpectroscopy[
	obj: ObjectP[Object[Protocol, IRSpectroscopy]],
	ops: OptionsPattern[PlotIRSpectroscopy]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotIRSpectroscopy, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, IRSpectroscopy]]..}],
		Message[Error::NoIRSpectroscopyDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotIRSpectroscopy[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotIRSpectroscopy[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::IRSpectroscopyProtocolDataNotPlotted];
		Return[$Failed],
		Nothing
	];

	(* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
	outputPlot = If[MemberQ[output, Result],
		If[Length[plots] > 1,
			SlideView[plots],
			First[plots]
		]
	];

	(* If Options were requested, just take the first set of options since they are the same for all plots. Make it a List first just in case there is only one option set. *)
	outputOptions = If[MemberQ[output, Options],
		First[ToList[resolvedOptions]]
	];

	(* Prepare our final result *)
	finalResult = output /. {
		Result -> outputPlot,
		Options -> outputOptions,
		Preview -> previewPlot,
		Tests -> {}
	};

	(* Return the result *)
	If[
		Length[finalResult] == 1,
		First[finalResult],
		finalResult
	]
];

(* PlotIRSpectroscopy[myInput:plotInputP, myOps:OptionsPattern[PlotIRSpectroscopy]]:= *)
PlotIRSpectroscopy[myInput:ListableP[ObjectP[Object[Data, IRSpectroscopy]],2], myOps:OptionsPattern[PlotIRSpectroscopy]]:=Module[
	{
		originalOps,safeOps,plotData,specificOptions,plotOptions,plotOutputs,primaryData,
		secondaryData,resolvedFrameLabel,resolvedFilling,resolvedPlotOps,
		peakPackets,convertedPeakPackets,resolvedPeaks
	},

	(* Convert the original options into a list *)
	originalOps=ToList[myOps];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotIRSpectroscopy,ToList[myOps]];

	(* Resolve the raw numerical data that you will plot *)
	plotData=Download[Flatten[ToList[myInput]]];

	(*resolve the frame label based on the primary and secondary data*)
	primaryData=Lookup[safeOps,PrimaryData];
	secondaryData=Lookup[safeOps,SecondaryData];

	(*define the axis label switch based on the IR data*)
	resolvedFrameLabel=If[MatchQ[Lookup[safeOps,FrameLabel],Automatic],
		{
			Switch[primaryData,
				Interferogram,"Mirror Position",
				_,"Wavenumber (1/cm)"
			],
			Switch[primaryData,
				AbsorbanceSpectrum,"Absorbance Unit",
				Interferogram,"Arbitrary Units",
				_,"Transmittance (%)"
			],
			None,
			If[Length[secondaryData]==0,
				None,
				Switch[First@secondaryData,
					AbsorbanceSpectrum,"Absorbance Unit",
					Interferogram,"Arbitrary Units",
					_,"Transmittance (%)"
				]
			]
		},
		Lookup[safeOps,FrameLabel]
	];

	(* Default Filling to None for Transmittance *)
	resolvedFilling=If[!MemberQ[originalOps,Filling],
		Switch[primaryData,
			TransmittanceSpectrum,None,
			_,Lookup[safeOps,Filling]
		],
		Lookup[safeOps,Filling]
	];

	(* Download all peak packets *)
	peakPackets=Download[ToList@Lookup[safeOps,Peaks,Null]];

	(* If plotting the Transmittance spectrum, convert any peaks picked on AbsorbanceSpectrum to the correct units *)
	convertedPeakPackets=If[MatchQ[primaryData,TransmittanceSpectrum],
		absorbancePeakPacketToTransmittance/@peakPackets,
		peakPackets
	];

	(* Options specifically resolved by this plot function *)
	resolvedPlotOps={
		FrameLabel->resolvedFrameLabel,
		Filling->resolvedFilling,
		If[MatchQ[peakPackets,{Null}|{Automatic}],
			Nothing,
			Peaks->convertedPeakPackets
		]
	};

	(* Safe options for this plot function, for Options return of command builder framework *)
	specificOptions=ReplaceRule[safeOps,Normal@KeyDrop[resolvedPlotOps,Peaks]];

	(* Call packetToELLP or rawToPacket[] *)
	plotOutputs=packetToELLP[
		Unflatten[plotData,ToList[myInput]],
		PlotIRSpectroscopy,
		(* NOTE - packetToELLP takes originalOps, not safeOps *)
		ReplaceRule[originalOps,resolvedPlotOps]
	];

	(* Use the processELLPOutput helper *)
	processELLPOutput[plotOutputs,specificOptions]
];


(* Convert peaks picked on AbsorbanceSpectrum to Transmittance units *)
absorbancePeakPacketToTransmittance[pks:PacketP[Object[Analysis,Peaks]]]:=Module[
	{pksList,pkPos,baselineFunc,convertedUnits,convertedBaseline,convertedBaselineIntercepts,convertedHeights,newPkList},

	(* Convert the packet to list of rules *)
	pksList=Normal[pks];

	(* Peak positions *)
	pkPos=Lookup[pksList,Position,{}];
	baselineFunc=Lookup[pksList,BaselineFunction];

	(* Swap absorbanceUnit with percent, since we convert absorbance to transmission *)
	convertedUnits=Lookup[pksList,PeakUnits]/.{AbsorbanceUnit->Percent};

	(* Convert baseline and baseline intercept *)
	convertedBaselineIntercepts=100.0*10^-Lookup[pksList,BaselineIntercept,{}];
	convertedBaseline=With[{f=Evaluate[Lookup[pksList,BaselineFunction]]},
		Function[{x},100.0*10^(-f[x])]
	];

	(* Convert the peak heights, accounting for the baseline *)
	convertedHeights=100.0*10^(-(Lookup[pksList,Height]+baselineFunc/@pkPos))-convertedBaseline/@pkPos;

	(* Swap out unconverted values in the peak packeet *)
	newPkList=ReplaceRule[pksList,{
		PeakUnits->convertedUnits,
		BaselineIntercept->convertedBaselineIntercepts,
		BaselineFunction->convertedBaseline,
		Height->convertedHeights
	}];

	(* Return the updated packet *)
	Association@@newPkList
];
