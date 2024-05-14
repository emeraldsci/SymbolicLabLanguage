(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab,Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeImageExposure*)


DefineUsageWithCompanions[AnalyzeImageExposure,
{
	BasicDefinitions->{
		(* definition 1: Basic definition, a list of input images *)
		{
			Definition->{"AnalyzeImageExposure[ImageData]","Object"},
			Description->"identifies the optimal image from 'ImageData' by calculating pixel gray level statistics. If none of the input images are properly exposed, a new exposure time will be suggested for next image acquisition.",
			Inputs:>{
					{
						InputName->"ImageData",
						Description->"A list of exposure times and images to be analyzed.",
						Widget->Alternatives[
							"Single image"->{
									"Exposure Time"->Widget[Type->Quantity,Pattern:>GreaterP[0*Millisecond],Units->Millisecond],
									"Image"->Widget[Type->Expression,Pattern:>_?ImageQ|LinkP[Object[EmeraldCloudFile]]|ObjectP[Object[EmeraldCloudFile]],Size->Line]},
							"Multiple images"->Adder[{
									"Exposure Time"->Widget[Type->Quantity,Pattern:>GreaterP[0*Millisecond],Units->Millisecond],
									"Image"->Widget[Type->Expression,Pattern:>_?ImageQ|LinkP[Object[EmeraldCloudFile]]|ObjectP[Object[EmeraldCloudFile]],Size->Line]}]]
					}
			},
			Outputs:>{
				{
					OutputName->"Object",
					Description->"Object(s) containing the best exposed images and the pixel level statistics derived from the input image data.",
					Pattern:>ObjectP[Object[Analysis,ImageExposure]]
				}
			}
		},

		(* definition 2.1: for QPIX images *)
		{
			Definition->{"AnalyzeImageExposure[AppearanceColoniesImages]","Object"},
			Description->"identifies the optimal image from 'AppearanceColoniesImages'.  If no optimal image is found, a new exposure time is suggested for next image acquisition.",
			Inputs:>{
				{
					InputName->"AppearanceColoniesImages",
					Description->"A list of images representing the physical appearance of a sample that contains bacterial colonies to be analyzed.",
					Widget->Alternatives[
						"Single object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,Appearance,Colonies]]],
						"Multiple objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,Appearance,Colonies]]]]
					]}
			},
			Outputs:>{
				{
					OutputName->"Object",
					Description->"Object(s) containing the best exposed images and the pixel level statistics derived from the input image data.",
					Pattern:>ObjectP[Object[Analysis,ImageExposure]]
				}
			}
		},
		(* definition 2.2: for Object[Data,Appearance] *)
		{
			Definition->{"AnalyzeImageExposure[AppearanceImages]","Object"},
			Description->"identifies the optimal image from 'AppearanceImages'.  If no optimal image is found, an exposure time is suggested.",
			Inputs:>{
				{
					InputName->"AppearanceImages",
					Description->"A list of Appearance objects representing the physical appearance of samples to be analyzed.",
					Widget->Alternatives[
						"Single object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,Appearance]]],
						"Multiple objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,Appearance]]]]
					]}
			},
			Outputs:>{
				{
					OutputName->"Object",
					Description->"Object(s) containing analysis for the exposure parameters derived from the input image data.",
					Pattern:>ObjectP[Object[Analysis,ImageExposure]]
				}
			}
		},

		(* definition 3: PAGE data *)
		{
			Definition->{"AnalyzeImageExposure[PAGEData]","Object"},
			Description->"examines 'PAGEData' to identify the optimally exposed lane image.  If no optimal image is found, an exposure time is suggested.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"PAGEData",
						Description->"A list of PAGE data objects to be analyzed.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[Object[Data,PAGE]]],
							Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,PAGE]]]]
						]},
					IndexName->"PAGE Date"
				]
			},
			Outputs:>{
				{
					OutputName->"Objects",
					Description->"The objects containing analyses for PAGE images.",
					Pattern:>{ObjectP[Object[Analysis,ImageExposure]]..}
				}
			}
		},

		(* definition 4: PAGE protocol *)
		{
			Definition->{"AnalyzeImageExposure[PAGEProtocol]","Object"},
			Description->"examines all lane or gel images produced by 'PAGEProtocol' to identify optimally exposed gel images.  If no optimal image is found, an exposure time is suggested.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"PAGEProtocol",
						Description->"A list of PAGE Protocol objects containing PAGE data objects to be analyzed.",
						Widget->Alternatives[
							Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,PAGE]]],
							Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,PAGE]]]]
						]},
					IndexName->"PAGE Protocol"
				]
			},
			Outputs:>{
				{
					OutputName->"Objects",
					Description->"The objects containing analyses for PAGE images.",
					Pattern:>{ObjectP[Object[Analysis,ImageExposure]]..}
				}
			}
		}
	},
	MoreInformation->{
		"Image information content is analyzed using gray scale image. Color images are first converted to gray scale image before analysis. The amount of under-exposure and over-exposure in an image is quantified based on pixel level statistics. From this analysis, a list of images with acceptable exposure is identified. The optimal image is identified from the acceptable images using an image-type dependent optimality criterion. For BrightField images, it is the image with the highest entropy. For fluorescence images, it is the image with the lowest entropy among acceptable images."
	},
	SeeAlso->{
		"AnalyzeColonies",
		"AnalyzeLane"
	},
	Author->{
		"scicomp"
	},
	Preview->True
}];
