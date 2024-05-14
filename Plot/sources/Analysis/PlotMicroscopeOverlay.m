(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotMicroscopeOverlay*)


DefineOptions[PlotMicroscopeOverlay,
	Options:>{
		ModifyOptions[ListPlotOptions,
			{
				{OptionName->ImageSize,Default->550}
			}
		]
	},
	(* Inherit all options from PlotImage *)
	SharedOptions:>{
		PlotImage
	}
];


PlotMicroscopeOverlay::NoOverlay="No overlay analysis exists for `1`";


PlotMicroscopeOverlay[id:objectOrLinkP[Object[Data,Microscope]], ops:OptionsPattern[]]:=
	PlotMicroscopeOverlay[Download[id, Packet[MicroscopeOverlay]], ops];

PlotMicroscopeOverlay[id:objectOrLinkP[Object[Analysis,MicroscopeOverlay]], ops:OptionsPattern[]]:=
	PlotMicroscopeOverlay[Download[id, Packet[Overlay]], ops];

PlotMicroscopeOverlay[dataInf: PacketP[Object[Data, Microscope]], ops:OptionsPattern[]]:=Module[{analysisObject},
	analysisObject = Lookup[dataInf, MicroscopeOverlay];
	If[MatchQ[analysisObject,Null],
		Message[PlotMicroscopeOverlay::NoOverlay, analysisObject];
		Return[Null];
	];
	PlotMicroscopeOverlay[analysisObject, ops]
];

(* Core function *)
PlotMicroscopeOverlay[packet: PacketP[Object[Analysis, MicroscopeOverlay]],ops:OptionsPattern[]]:=Module[
	{safeOps,output},

	safeOps=SafeOptions[PlotMicroscopeOverlay,ToList[ops]];

	(* Call PlotImage, returning all its outputs *)
	PlotImage[Lookup[packet,Overlay],Sequence@@safeOps]
];
