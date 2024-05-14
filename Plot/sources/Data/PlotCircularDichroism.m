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


(* Packet Definition *)
(* PlotCircularDichroism[infs:plotInputP,inputOptions:OptionsPattern[PlotCircularDichroism]]:= *)
PlotCircularDichroism[infs:ListableP[ObjectP[Object[Data, CircularDichroism]],2],inputOptions:OptionsPattern[PlotCircularDichroism]]:=Module[
	{resolvedMap, listedOps, plotOutputs, output},

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

	(* Handle case where we do or do not want to overlay data *)
	plotOutputs=packetToELLP[ToList[infs], PlotCircularDichroism, listedOps];

	(* Return packetToELLP output, adding any missing options *)
	processELLPOutput[plotOutputs, SafeOptions[PlotCircularDichroism, listedOps]]
];
