(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*PlotCloudFile*)


DefineUsage[PlotCloudFile,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotCloudFile[cloudFile]","preview"},
				Description->"creates an image or snippet of the file contents of 'cloudFile'.",
				Inputs:>{
					{
						InputName->"cloudFile",
						Description->"A single cloud file to plot.",
						Widget->Widget[Type->Object, Pattern:>ObjectP[Object[EmeraldCloudFile]]]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"An image or snippet of the file contents.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotCloudFile[cloudFiles]","previews"},
				Description->"creates a list of images or snippets of the file contents of 'cloudFiles'.",
				Inputs:>{
					{
						InputName->"cloudFiles",
						Description->"A list of cloud files to interact with.",
						Widget->Adder[
							Widget[Type->Object, Pattern:>ObjectP[Object[EmeraldCloudFile]]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"previews",
						Description->"An image or snippet of the file contents.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		MoreInformation -> {
			"Measurement lines can be added using Ctrl+LeftClick.",
			"Measurement points can be moved by RightClick+Dragging.",
			"Measurement lines can be removed using Ctrl+RightClick.",
			"If the file is not imported as a graphic, image, or string, the output will be Null."
		},
		SeeAlso -> {
			"PlotImage",
			"UploadCloudFile",
			"Inspect",
			"ImportCloudFile",
			"DownloadCloudFile"
		},
		Author -> {"dirk.schild", "amir.saadat", "brad", "thomas"},
		Preview->True
	}
];