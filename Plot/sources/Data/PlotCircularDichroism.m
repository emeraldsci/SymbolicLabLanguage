(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCircularDichroism*)


(* ::Subsubsection:: *)
(*PlotCircularDichroism Options*)


DefineOptions[PlotCircularDichroism,

	Options:>{
		{
			OptionName->Overlay,
			Description->"When multiple input data is provided, determine if the spectra should be overlaid or split into separate plots.",
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Category->"General"
		},
		{
			OptionName->CircularDichroismSpectrum,
			Description->"The circular dichroism spectrum trace to display on the plot.",
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>NullP|(ListableP[UnitCoordinatesP[],2]|ListableP[QuantityArrayP[],2]),Size->Paragraph],
			Category->"Raw Data"
		},
		{
			OptionName->CircularDichroismAbsorbanceSpectrum,
			Description->"The corresponding circular dichroism absorbance (ellipticity) spectrum trace to display on the plot.",
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>NullP|(ListableP[UnitCoordinatesP[],2]|ListableP[QuantityArrayP[],2]),Size->Paragraph],
			Category->"Raw Data"
		},
		{
			OptionName->AbsorbanceSpectrum,
			Description->"The corresponding absorbance spectrum trace to display on the plot.",
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>NullP|(ListableP[UnitCoordinatesP[],2]|ListableP[QuantityArrayP[],2]),Size->Paragraph],
			Category->"Raw Data"
		},


		{
			OptionName->UnblankedCircularDichroismSpectrum,
			Description->"The unblanked circular dirchorism spectrum trace to display on the plot.",
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
			Default->CircularDichroismAbsorbanceSpectrum,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>(CircularDichroismAbsorbanceSpectrum|AbsorbanceDifferenceSpectrum|CircularDichroismSpectrum|UnblankedAbsorbanceDifferenceSpectrum|UnblankedCircularDichroismAbsorbanceSpectrum|AbsorbanceSpectrum|UnblankedAbsorbanceSpectrum)],
				Adder[Widget[Type->Enumeration,Pattern:>(CircularDichroismAbsorbanceSpectrum|AbsorbanceDifferenceSpectrum|CircularDichroismSpectrum|UnblankedAbsorbanceDifferenceSpectrum|UnblankedCircularDichroismAbsorbanceSpectrum|AbsorbanceSpectrum|UnblankedAbsorbanceSpectrum)]]
			],
			Category->"Primary Data"
		],

		ModifyOptions[IncludeReplicatesOption,Category->"Hidden"],
		ModifyOptions[EmeraldListLinePlot,{ErrorBars,ErrorType},Category->"Hidden"],

		(* Secondary data *)
		ModifyOptions[
			SecondaryDataOption,
			Default->{AbsorbanceSpectrum},
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Adder[Widget[Type->Enumeration,Pattern:>(AbsorbanceSpectrum|CircularDichroismAbsorbanceSpectrum|AbsorbanceDifferenceSpectrum|CircularDichroismSpectrum|UnblankedAbsorbanceDifferenceSpectrum|UnblankedCircularDichroismAbsorbanceSpectrum|UnblankedAbsorbanceSpectrum)]]
			],
			Category->"Secondary Data"
		],

		(* Set default ImageSize to 600 *)
		ModifyOptions[ListPlotOptions,{{OptionName->ImageSize,Default->600}}],

		(* Set the default frame label *)
		ModifyOptions[ListPlotOptions,{{OptionName->FrameLabel,Default->{{"Circular Dichroism (mdeg)", "Absorbance (AU)"}, {"Wavelength (nm)", None}}}}],

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
		ModifyOptions[EmeraldListLinePlot,{FrameUnits,Scale,Prolog,Epilog,TargetUnits,PlotRange,PlotRangeClipping,ClippingStyle,ScaleX,ScaleY,Reflected},Category->"Hidden"]

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

Error::NoCircularDichroismDataToPlot = "The protocol object does not contain any associated circular dichroism data.";
Error::CircularDichroismProtocolDataNotPlotted = "`1` not able to be plotted. `2`.";


(* ::Subsubsection:: *)
(*PlotCircularDichroism Main Function*)


(* Raw Definition *)
PlotCircularDichroism[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotCircularDichroism]]:=Module[
	{plotOutputs},

	(* Call plot function *)
	plotOutputs=rawToPacket[primaryData,
		Object[Data,CircularDichroism],
		PlotCircularDichroism,
		SafeOptions[PlotCircularDichroism,ReplaceRule[ToList[inputOptions],Map->False]]
	];

	(* Return rawToPacket output, adding any missing options *)
	processELLPOutput[plotOutputs,SafeOptions[PlotCircularDichroism,ToList@inputOptions]]
];

(* Protocol Overload *)
PlotCircularDichroism[
	obj: ObjectP[Object[Protocol, CircularDichroism]],
	ops: OptionsPattern[PlotCircularDichroism]
] := Module[{safeOps, output, data, previewPlot, plots, resolvedOptions, finalResult, outputPlot, outputOptions},

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotCircularDichroism, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = ToList[Lookup[safeOps, Output]];

	(* Download the data from the input protocol *)
	data = Download[obj, Data];

	(* Return an error if there is no data or it is not the correct data type *)
	If[!MatchQ[data, {ObjectP[Object[Data, CircularDichroism]]..}],
		Message[Error::NoCircularDichroismDataToPlot];
		Return[$Failed]
	];

	(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
	previewPlot = If[MemberQ[output, Preview],
		PlotCircularDichroism[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
		Null
	];

	(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
	{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
		Transpose[
			(PlotCircularDichroism[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
		],
		{{}, {}}
	];

	(* If all of the data objects failed to plot, return an error *)
	If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
		Message[Error::CircularDichroismProtocolDataNotPlotted];
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


(* Packet Definition *)
(* PlotCircularDichroism[infs:plotInputP,inputOptions:OptionsPattern[PlotCircularDichroism]]:= *)
PlotCircularDichroism[infs:ListableP[ObjectP[Object[Data, CircularDichroism]],2],inputOptions:OptionsPattern[PlotCircularDichroism]]:=Module[
	{resolvedMap, listedOps, output, plotOutputs, invalidDataObjects},

	(* Determine if the Map option needs to be passed *)
	resolvedMap = If[!TrueQ[OptionValue[Overlay]]&&MatchQ[infs,_List],
		Map->True,
		Map->False
	];

	(* Convert input options to a list. Set SecondaryData->{} if we are overlaying multiple data on the same plot *)
	listedOps = If[TrueQ[OptionValue[Overlay]]&&(Length[ToList[infs]]>1),
		ReplaceRule[{SecondaryData->{}, resolvedMap}, ToList[inputOptions]],
		ReplaceRule[{resolvedMap}, ToList[inputOptions]]
	];
	output = Lookup[SafeOptions[PlotCircularDichroism, ToList[inputOptions]], Output];

	(* Handle case where we do or do not want to overlay data *)
	plotOutputs = Quiet[
		packetToELLP[ToList[infs], PlotCircularDichroism, listedOps],
		{Warning::MappedNullPrimaryData, Error::NullPrimaryData}
	];

	(* The invalid data will return Null for result/preview from packetToELLP output *)
	invalidDataObjects = Which[
		TrueQ[Lookup[resolvedMap, Map]] && MemberQ[ToList@plotOutputs, Null],
			Module[{plotPosition},
				plotPosition = Which[
					!MatchQ[output, _List], ToList@plotOutputs,
					MemberQ[output, Preview|Result], plotOutputs[[All, FirstPosition[output, Result|Preview][[1]]]],
					True, ToList@plotOutputs
				];
				PickList[ToList@infs, ToList@plotOutputs, Null]
			],
		MemberQ[ToList@plotOutputs, Null],
			ToList@infs,
		True,
			{}
	];
	If[!MatchQ[invalidDataObjects, {}],
		Message[Error::CircularDichroismProtocolDataNotPlotted,
			Which[
				Length[invalidDataObjects] == Length[ToList@infs] && EqualQ[Length[invalidDataObjects], 1],
					"The data object is",
				Length[invalidDataObjects] == Length[ToList@infs],
					"All data objects are",
				EqualQ[Length[invalidDataObjects], 1],
					Capitalize@Experiment`Private`samplesForMessages[invalidDataObjects, CollapseForDisplay -> False] <> " is",
				TrueQ[Lookup[resolvedMap, Map]],
					Capitalize@Experiment`Private`samplesForMessages[invalidDataObjects, CollapseForDisplay -> False] <> " are",
				True,
					"At least one of the data objects is"
			],
			If[TrueQ[Lookup[resolvedMap, Map]] || EqualQ[Length[invalidDataObjects], 1],
				"Please check the field CircularDichroismAbsorbanceSpectrum which is required for plotting",
				"Please call PlotCircularDichroism or PlotObject on an individual data object or set the option Overlay to False to identify which data file(s) are missing a value for the field CircularDichroismAbsorbanceSpectrum"
			]
		];
		Return[$Failed],
		Nothing
	];

	(* Return packetToELLP output, adding any missing options *)
	processELLPOutput[plotOutputs, SafeOptions[PlotCircularDichroism, listedOps]]
];
