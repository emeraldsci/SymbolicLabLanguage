(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotMicroscopeOverlay*)


DefineUsage[PlotMicroscopeOverlay,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotMicroscopeOverlay[overlay]","plot"},
				Description->"plots a microscope image within a zoomable frame.",

				Inputs:>{
					{
						InputName->"overlay",
						Description->"An Object[Analysis,MicroscopeOverlay] object.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object:"->Widget[Type->Expression,Pattern:>ObjectP[Object[Analysis,MicroscopeOverlay]],Size->Paragraph],
								"Select object:"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,MicroscopeOverlay]],ObjectTypes->{Object[Analysis,MicroscopeOverlay]}]
							],
							Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,MicroscopeOverlay]],ObjectTypes->{Object[Analysis,MicroscopeOverlay]}]
						]					
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"An overlayed false colored image of the different microscope image channels.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		MoreInformation -> {
			"Measurement lines can be added using Ctrl+LeftClick (Cmd+LeftClick on Mac).",
			"Measurement points can be moved by Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac).",
			"Measurement lines can be removed using Ctrl+RightClick (Cmd+RightClick on Mac)."
		},
		SeeAlso -> {
			"ImageOverlay",
			"MicroscopeOverlay"
		},
		Author -> {
			"sebastian.bernasek",
			"brad",
			"Sean",
			"Catherine",
			"Ruben"
		},
		Preview->True
	}
];
