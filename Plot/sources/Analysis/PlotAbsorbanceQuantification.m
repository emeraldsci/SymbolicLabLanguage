(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotAbsorbanceQuantification*)


DefineOptions[PlotAbsorbanceQuantification,
	Options :> {

		{
			OptionName->DataField,
			Description->"The field in the Object[Analysis,AbsorbanceQuantification] object from which to pull the data to be plotted.",
			Default->AbsorbanceSpectra,
			AllowNull->False,
			Widget->Alternatives[
				"Enter fields:"->Widget[Type->Expression,Pattern:>ListableP[AbsorbanceSpectraEmpty|AbsorbanceSpectraBlank|AbsorbanceSpectra],Size->Line],
				"Select fields"->Adder[Widget[Type->Enumeration,Pattern:>AbsorbanceSpectraEmpty|AbsorbanceSpectraBlank|AbsorbanceSpectra]]
			],
			Category->"General"
		},

		(* Hide PrimaryData and set default SecondaryData to empty list *)
		ModifyOptions[PlotAbsorbanceSpectroscopy,{
			{
				OptionName->PrimaryData,
				Category->"Hidden"
			},
			{
				OptionName->SecondaryData,
				Default->{}
			}
		}
		]
	},
	SharedOptions :> {
		PlotAbsorbanceSpectroscopy
	}
];


PlotAbsorbanceQuantification::NoData="The provided object `1` contains no absorbance spectra data.  Be sure to run AnalyzeAbsorbanceQuantification on your protocol[AbsorbanceQuantification] object before trying to plot.";


(* --- OPTION RESOLVER --- *)
resolvePlotAbsorbanceQuantificationOptions[quantAnalysis_,spectra_,safeOps_]:=Module[
	{plotLabelOpt,plotLabel,linearRange,minAbs,maxAbs},

	(* get the plot label option *)
	plotLabelOpt = PlotLabel/.safeOps;

	(* get the actual plot label, ie.  handle the Automatic case *)
	plotLabel = If[MatchQ[plotLabelOpt,Automatic],
		Module[{quantSample,name,obj},
			(* get the sample from the analysis *)
			quantSample = FirstOrDefault[Download[quantAnalysis,SamplesIn]];

			(* pull the name and object from the sample *)
			{name,obj} = If[MatchQ[quantSample,Null],
				{Null,Null},
				Download[quantSample,{Name,Object}]
			];

			(* generate the plot label *)
			Switch[{name,obj},
				{Null,Null},
				ToString[quantAnalysis[Object]],
				{Null,_},
					ToString[obj],
				{_,_},
				StringJoin[
					ToString[obj],
					": ",
					name
				]
			]
		],
		plotLabelOpt
	];

	(* Return resolved options *)
	ReplaceRule[safeOps,{PlotLabel->plotLabel}]

];


(* --- CORE FUNCTION --- *)
PlotAbsorbanceQuantification[quantAnalysis:PacketP[Object[Analysis,AbsorbanceQuantification]],opts:OptionsPattern[PlotAbsorbanceQuantification]]:=Module[
	{safeOps,spectra,resolvedOps,output,finalPlot},

	(* first default the options *)
	safeOps=SafeOptions[PlotAbsorbanceQuantification, ToList[opts]];

	(* pull the data objects from the Object[Analysis,AbsorbanceQuantification] object *)
	spectra=DeleteCases[Flatten[(DataField/.safeOps)/.quantAnalysis],Null];

	(* if there isn't anything to plot, thrown an error and return *)
	If[MatchQ[spectra,{}],
		Message[PlotAbsorbanceQuantification::NoData,Object/.quantAnalysis];
		Return[]
	];

	(* resolve plot options *)
	resolvedOps=resolvePlotAbsorbanceQuantificationOptions[quantAnalysis,spectra,safeOps];

	(* pass to core plotting function *)
	finalPlot=PlotAbsorbanceSpectroscopy[spectra,
		PassOptions[PlotAbsorbanceSpectroscopy,
			AutoBlank->False,
			Output->Result,
			Sequence@@resolvedOps
		]
	];

	(* Return the result, according to the output option *)
	output=Lookup[safeOps,Output];
	output/.{
		Result->finalPlot,
		Preview->finalPlot,
		Tests->{},
		Options->resolvedOps
	}

];

(* --- SLLified[protocol[AbsorbanceQuantification]] --- *)
PlotAbsorbanceQuantification[quantProcess:PacketP[Object[Protocol,AbsorbanceQuantification]],opts:OptionsPattern[PlotAbsorbanceQuantification]]:=Module[
	{analyses},

	(* pull the analyses *)
	analyses = DeleteDuplicates[Cases[QuantificationAnalyses/.Download[Data/.quantProcess],ObjectReferenceP[Object[Analysis,AbsorbanceQuantification]],Infinity]];

	(* if there are no analysese, throw a message and return *)
	If[MatchQ[analyses,{}],
		Message[PlotAbsorbanceQuantification::NoData,Object/.quantProcess];
		Return[]
	];

	(* pass to core function *)
	PlotAbsorbanceQuantification[Last[analyses],opts]/.{{Null..}->Null}

];

(* --- Listable overloads --- *)
PlotAbsorbanceQuantification[quantAnalysis:{PacketP[Object[Analysis,AbsorbanceQuantification]]..},ops:OptionsPattern[]]:=consolidateOutputs[PlotAbsorbanceQuantification,quantAnalysis,ops];
PlotAbsorbanceQuantification[quantProcess:{PacketP[Object[Protocol,AbsorbanceQuantification]]..},ops:OptionsPattern[]]:=consolidateOutputs[PlotAbsorbanceQuantification,quantProcess,ops];

(* --- Objects overload --- *)
PlotAbsorbanceQuantification[object:ListableP[(objectOrLinkP[Object[Analysis,AbsorbanceQuantification]]|objectOrLinkP[Object[Protocol,AbsorbanceQuantification]])],opts:OptionsPattern[]]:=
	If[And@@DatabaseMemberQ[ToList[object]],
		PlotAbsorbanceQuantification[Download[object],opts],
		Message[Generic::MissingObject,PlotAbsorbanceQuantification,object]
	]
