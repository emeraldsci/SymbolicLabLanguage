(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAbsorbanceSpectroscopy*)


(* ::Subsubsection:: *)
(*PlotAbsorbanceSpectroscopy Options*)


DefineOptions[PlotAbsorbanceSpectroscopy,

	Options:>{
		(* Raw data fields *)
		{
			OptionName->AbsorbanceSpectrum,
			Description->"The absorbance spectrum trace to display on the plot.",
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>NullP|(ListableP[UnitCoordinatesP[],2]|ListableP[QuantityArrayP[],2]),Size->Paragraph],
			Category->"Raw Data"
		},

		{
			OptionName->Temperature,
			Description->"The temperature trace to display on the plot.",
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>NullP|(ListableP[UnitCoordinatesP[],2]|ListableP[QuantityArrayP[],2]),Size->Paragraph],
			Category->"Raw Data"
		},

		{
			OptionName->Transmittance,
			Description->"The transmittance trace to display on the plot.",
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>NullP|(ListableP[UnitCoordinatesP[],2]|ListableP[QuantityArrayP[],2]),Size->Paragraph],
			Category->"Raw Data"
		},

		{
			OptionName->UnblankedAbsorbanceSpectrum,
			Description->"The unblanked absorbance spectrum trace to display on the plot.",
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>NullP|(ListableP[UnitCoordinatesP[],2]|ListableP[QuantityArrayP[],2]),Size->Paragraph],
			Category->"Raw Data"
		},

		(* Change default Display options *)
		ModifyOptions[
			DisplayOption,
			Default->{Peaks},
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Adder[Widget[Type->Enumeration,Pattern:>Peaks|Fractions|Ladder]]
			],
			Category->"General"
		],

		(* Primary data *)
		ModifyOptions[
			PrimaryDataOption,
			Default->AbsorbanceSpectrum,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>AbsorbanceSpectrum|Transmittance|Temperature|UnblankedAbsorbanceSpectrum],
				Adder[Widget[Type->Enumeration,Pattern:>AbsorbanceSpectrum|Transmittance|Temperature|UnblankedAbsorbanceSpectrum]]
			],
			Category->"Primary Data"
		],
		ModifyOptions[EmeraldListLinePlot,{TargetUnits,PlotRange,PlotRangeClipping,ClippingStyle,ScaleX,ScaleY,Reflected},Category->"Hidden"],
		ModifyOptions[IncludeReplicatesOption,Category->"Primary Data"],
		ModifyOptions[EmeraldListLinePlot,{ErrorBars,ErrorType},Category->"Primary Data"],

		(* Secondary data *)
		ModifyOptions[
			SecondaryDataOption,
			Default->{Temperature},
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Adder[Widget[Type->Enumeration,Pattern:>AbsorbanceSpectrum|Transmittance|Temperature|UnblankedAbsorbanceSpectrum]]
			],
			Category->"Secondary Data"
		],

		(* Set default ImageSize to 600 *)
		ModifyOptions[ListPlotOptions,{{OptionName->ImageSize,Default->600}}],

		(* Change OptionFunctions widget to accept empty list *)
		ModifyOptions[
			OptionFunctionsOption,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Adder[Widget[Type->Expression, Pattern:>_Symbol, Size->Line]]
			],
			Category->"Hidden"
		],

		(* Set default Peaks/Fractions/Ladders to {} so widget appears in command builder *)
		ModifyOptions[EmeraldListLinePlot,{Peaks,Fractions},Default->{}],

		(* Hide some of the less useful EmeraldListLinePlot options *)
		ModifyOptions[EmeraldListLinePlot,{FrameUnits,Scale,Prolog,Epilog},Category->"Hidden"]

	},

	SharedOptions :> {
		(* Include additional options without modification *)
		ZoomableOption,
		PlotLabelOption,
		UnitsOption,
		MapOption,

		(* Inherit remaining options from EmeraldListLinePlot *)
		EmeraldListLinePlot
	}
];


(* ::Subsubsection:: *)
(*Helper Functions*)


(*
Define helper function that processes the output from ELLP/rawToPacket such that any returned Options are complete and command builder compatible.
Options listed in resolvedOps will be appended to the returned options, overriding any existing options of the same name.
*)

DefineOptions[processELLPOutput,
	Options:>{
		{LookupTable->False,BooleanP,"If True, returns an output lookup table."}
	}
];

(* Overload for unspecified resolvedOps *)
processELLPOutput[outputContent_,defaultedOps:{_Rule...},lookupTable:_Rule...]:=processELLPOutput[outputContent,defaultedOps,{},lookupTable];

(* Main function *)
processELLPOutput[outputContent_,defaultedOps:{_Rule...},resolvedOps:{_Rule...},ops:OptionsPattern[processELLPOutput]]:=Module[
	{output,map,flattenOptionSets,iterableContent,lookupTable},

	(* Lookup output from defaulted options *)
	output=Lookup[defaultedOps,Output];

	(* If output content is empty (ELLP failed), return safe output *)
	If[
		NullQ[outputContent],
		Return[
			output/.{
				Result->$Failed,
				Preview->Null,
				Options->ReplaceRule[defaultedOps,resolvedOps],
				Tests->{}
			}
		]
	];

	(* Rearrange output content such the outermost list is index-matched to the requested outputs, e.g. {{result..},{options..}} *)
	map=Lookup[defaultedOps,Map];
	iterableContent=Which[

		(* ELLP was mapped, and Output is a list of values *)
		TrueQ[map]&&MatchQ[output,_List],
		Transpose@outputContent,

		(* ELLP was mapped, and Output is a standalone value *)
		TrueQ[map]&&!MatchQ[output,_List],
		{outputContent},

		(* ELLP was not mapped, and Output is a list of values *)
		!TrueQ[map]&&MatchQ[output,_List],
		outputContent,

		(* ELLP was not mapped, and Output is a standalone value *)
		!TrueQ[map]&&!MatchQ[output,_List],
		{outputContent}

	];

	(* Define helper function that aggregates multiple option sets by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic.*)
	flattenOptionSets=Function[{optionSets},
		MapThread[
			If[CountDistinct[List@##]>1,
				First@#->Automatic,
				Sequence@@DeleteDuplicates[ToList[##]]
			]&,
			DeleteCases[optionSets,Null|$Failed]
		]
	];

	(* Process outputs *)
	lookupTable=MapThread[
		Switch[#1,

			(* Pass Result through unchanged*)
			Result,#1->#2,

			(* Merge listed previews (e.g. from Map\[Rule]True) into a SlideView *)
			Preview,#1->If[MatchQ[#2,_List],SlideView[#2],#2],

			(* Aggregate all tests into a single list *)
			Tests,#1->Flatten@#2,

			(* Process Options *)
			Options,
			Module[{outputOps},

				(* If output is a list of option sets (e.g. from Map\[Rule]True), flatten it *)
				outputOps=If[MatchQ[#2,{(Null|$Failed|{_Rule...})..}],flattenOptionSets[#2],#2];

				(* Append any missing safe options *)
				outputOps=ReplaceRule[defaultedOps,outputOps,Append->False];

				(* Replace Peaks packets or object references with original objects *)
				outputOps=outputOps/.(peaks:ObjectP[Object[Analysis,Peaks]]:>peaks[Object]);

				(* If Fractions or Peaks are null, set their corresponding options to Null *)
				outputOps=If[NullQ[Fractions/.outputOps],ReplaceRule[outputOps,{FractionColor->Null,FractionHighlights->Null,FractionHighlightColor->Null}],outputOps];
				outputOps=If[NullQ[Peaks/.outputOps],ReplaceRule[outputOps,{PeakLabels->Null,PeakLabelStyle->Null}],outputOps];

				(* Return the user-specified epilog, not the generated one *)
				outputOps=ReplaceRule[outputOps,Epilog->Lookup[defaultedOps,Epilog]];

				(* Append any resolved options *)
				outputOps=ReplaceRule[outputOps,resolvedOps,Append->True];

				(* Return processed output options *)
				#1->outputOps
			]

		]&,
		{ToList@output,iterableContent}
	];

	(* Return the requested output *)
	If[
		TrueQ[Lookup[SafeOptions[processELLPOutput,ToList@ops],LookupTable]],
		lookupTable,
		output/.lookupTable
	]
];


(* ::Subsubsection:: *)
(*PlotAbsorbanceSpectroscopy Main Function*)


(* Raw Definition *)
PlotAbsorbanceSpectroscopy[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotAbsorbanceSpectroscopy]]:=Module[
	{plotOutputs},

	(* Call plot function *)
	plotOutputs=rawToPacket[primaryData,
		Object[Data,AbsorbanceSpectroscopy],
		PlotAbsorbanceSpectroscopy,
		SafeOptions[PlotAbsorbanceSpectroscopy,ToList[inputOptions]]
	];

	(* Return rawToPacket output, adding any missing options *)
	processELLPOutput[plotOutputs,SafeOptions[PlotAbsorbanceSpectroscopy,ToList@inputOptions]]
];


(* Packet Definition *)
(* PlotAbsorbanceSpectroscopy[infs:plotInputP,inputOptions:OptionsPattern[PlotAbsorbanceSpectroscopy]]:= *)
PlotAbsorbanceSpectroscopy[infs:ListableP[ObjectP[Object[Data, AbsorbanceSpectroscopy]],2],inputOptions:OptionsPattern[PlotAbsorbanceSpectroscopy]]:=Module[
	{plotOutputs},

	(* Call plot function *)
	plotOutputs=packetToELLP[infs,PlotAbsorbanceSpectroscopy,ToList[inputOptions]];

	(* Return packetToELLP output, adding any missing options *)
	processELLPOutput[plotOutputs,SafeOptions[PlotAbsorbanceSpectroscopy,ToList@inputOptions]]
];
