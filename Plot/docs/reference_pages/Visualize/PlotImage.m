(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotImage*)


DefineUsage[PlotImage,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotImage[img]","fig"},
			Description->"creates a zoomable view of 'img' with rulers around the frame.",
			Inputs:>{
				{
					InputName->"img",
					Description->"An image to interact with.",
					Widget->Widget[Type->Expression, Pattern:>_Image|_Graphics|EmeraldCloudFileP, Size->Line]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"An interactive image that can be zoomed and measured.",
					Pattern:>ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"PlotImage[{img ..}]","fig"},
			Description->"overlays each 'img' in a single interactive figure.",
			Inputs:>{
				{
					InputName->"imgs",
					Description->"A list of images to interact with.",
					Widget->Adder[Widget[Type->Expression, Pattern:>_Image|_Graphics|EmeraldCloudFileP, Size->Line]]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"An interactive image that can be zoomed and measured.",
					Pattern:>ValidGraphicsP[]
				}
			}
		},		
		{
			Definition->{"PlotImage[dataObject]","fig"},
			Description->"displays the primary image associated with the data object.",
			Inputs:>{
				{
					InputName->"dataObject",
					Description->"An object containing an image that will be made interactive.",
					Widget->Widget[
						Type->Object, 
						Pattern:>ObjectP[{Object[Data,PAGE], Object[Data,Appearance], Object[Data,Microscope]}], 
						ObjectTypes->{Object[Data,PAGE], Object[Data,Appearance], Object[Data,Microscope]}
					]
				}
			},
			Outputs:>{
				{
					OutputName->"fig",
					Description->"An interactive image that can be zoomed and measured.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	MoreInformation -> {
		"On Command Center:",
		"Measurement lines can be added using Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac).",
		"Measurement points can be moved by hovering over a measure point and using Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac).",
		"Measurement lines can be removed using Ctrl+LeftClick (Cmd+LeftClick on Mac).",
		"Zooming can be done using LeftClick+Dragging to create a zoom box.",
		"On Command Center (Desktop):",
		"Measurement lines can be added using Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac).",
		"Measurement points can be moved by hovering over a measure point and using Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac).",
		"Measurement lines can be removed using Ctrl+LeftClick (Cmd+LeftClick on Mac).",
		"Zooming can be done using LeftClick+Dragging to create a zoom box, or by scrolling in and out on the mouse wheel."
	},
	SeeAlso -> {
		"PlotImageOptions",
		"PlotImagePreview",
		"EmeraldListLinePlot",
		"PlotChromatography",
		"PlotPeaks",
		"EmeraldBarChart",
		"Plot",
		"ListLinePlot"
	},
	Author -> {"dirk.schild", "sebastian.bernasek", "brad", "hayley"},
	Preview->True
}];


(* ::Subsubsection:: *)
(*PlotImageOptions*)


DefineUsage[PlotImageOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotImageOptions[img]","options"},
				Description->"creates a list 'options' used to generate the image plot.",
				Inputs:>{
					{
						InputName->"img",
						Description->"An image to interact with.",
						Widget->Widget[Type->Expression, Pattern:>_Image|_Graphics|EmeraldCloudFileP, Size->Line]
					}
				},
				Outputs:>{
					{
						OutputName->"options",
						Description->"A list of options used to plot the distribution.",
						Pattern:>_?ListQ
					}
				}
			},
			{
				Definition->{"PlotImageOptions[imgs]","options"},
				Description->"overlays each 'img' in a single interactive figure.",
				Inputs:>{
					{
						InputName->"imgs",
						Description->"A list of images to interact with.",
						Widget->Adder[Widget[Type->Expression, Pattern:>_Image|_Graphics|EmeraldCloudFileP, Size->Line]]
					}
				},
				Outputs:>{
					{
						OutputName->"options",
						Description->"A list of options used to plot the image.",
						Pattern:>_?ListQ
					}
				}
			},
			{
				Definition->{"PlotImageOptions[dataObject]","options"},
				Description->"displays the primary image associated with the data object.",
				Inputs:>{
					{
						InputName->"dataObject",
						Description->"An object containing an image that will be made interactive.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Data,PAGE], Object[Data,Appearance], Object[Data,Microscope]}],
							ObjectTypes->{Object[Data,PAGE], Object[Data,Appearance], Object[Data,Microscope]}
						]
					}
				},
				Outputs:>{
					{
						OutputName->"options",
						Description->"A list of options used to plot the image.",
						Pattern:>_?ListQ
					}
				}
			}
		},
		SeeAlso -> {
			"PlotImage",
			"PlotImagePreview",
			"PlotChromatography",
			"PlotPeaks",
			"EmeraldBarChart",
			"Plot",
			"ListLinePlot"
		},
		Author -> {"dirk.schild", "sebastian.bernasek", "brad", "hayley"},
		Preview->True
	}];


(* ::Subsubsection:: *)
(*PlotImagePreview*)


DefineUsage[PlotImagePreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotImagePreview[img]","preview"},
				Description->"creates a preview view of 'img' with rulers around the frame.",
				Inputs:>{
					{
						InputName->"img",
						Description->"An image to interact with.",
						Widget->Widget[Type->Expression, Pattern:>_Image|_Graphics|EmeraldCloudFileP, Size->Line]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"A preview image that can be zoomed and measured.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotImagePreview[{img ..}]","preview"},
				Description->"Previews each 'img' in a single figure.",
				Inputs:>{
					{
						InputName->"imgs",
						Description->"A list of images to interact with.",
						Widget->Adder[Widget[Type->Expression, Pattern:>_Image|_Graphics|EmeraldCloudFileP, Size->Line]]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"A preview image that can be zoomed and measured.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotImagePreview[dataObject]","preview"},
				Description->"displays the preview for the image associated with the data object.",
				Inputs:>{
					{
						InputName->"dataObject",
						Description->"An object containing an image that will be made interactive.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Data,PAGE], Object[Data,Appearance], Object[Data,Microscope]}],
							ObjectTypes->{Object[Data,PAGE], Object[Data,Appearance], Object[Data,Microscope]}
						]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"A preview image that can be zoomed and measured.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		MoreInformation -> {
			"On Command Center:",
			"Measurement lines can be added using Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac).",
			"Measurement points can be moved by hovering over a measure point and using Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac).",
			"Measurement lines can be removed using Ctrl+LeftClick (Cmd+LeftClick on Mac).",
			"Zooming can be done using LeftClick+Dragging to create a zoom box.",
			"On Command Center (Desktop):",
			"Measurement lines can be added using Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac).",
			"Measurement points can be moved by hovering over a measure point and using Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac).",
			"Measurement lines can be removed using Ctrl+LeftClick (Cmd+LeftClick on Mac).",
			"Zooming can be done using LeftClick+Dragging to create a zoom box, or by scrolling in and out on the mouse wheel."
		},
		SeeAlso -> {
			"PlotImage",
			"PlotImageOptions",
			"EmeraldListLinePlot",
			"PlotChromatography",
			"PlotPeaks",
			"EmeraldBarChart",
			"Plot",
			"ListLinePlot"
		},
		Author -> {
			"scicomp",
			"sebastian.bernasek",
			"brad",
			"hayley"
		},
		Preview->True
	}];