(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*CombineFluorescentImages*)


DefineUsage[CombineFluorescentImages,
{
	BasicDefinitions -> {
		{"CombineFluorescentImages[redImage,greenImage,blueImage,Overlay->True]", "overlayedImage", "creates a false colored RGB image of the provided 'redImage', 'greenImage', and 'blueImage'."},
		{"CombineFluorescentImages[redImage,greenImage,blueImage,Overlay->False]", "coloredImages", "creates false colored images of the provided 'redImage', 'greenImage', and 'blueImage'."},
		{"CombineFluorescentImages[Null,Null,Null]", "Null", "returns Null when all the inputs are Null."}
	},
	MoreInformation -> {
		"This function can combine up to three black and white images.  Each of the three provided images represents one channel in an RGB image, hence the inputs being 'redImage', 'greenImage', and 'blueImage' (the three channels in an RGB image).  However, one does not always need to provide images for all three channels.  In the case where there is a Null instead of an image provided for a channel, that channel won't be used in the ColorCombine overlay."
	},
	Input :> {
		{"redImage", _Image | Null, "The image to use for the red channel in the overlay."},
		{"greenImage", _Image | Null, "The image to use for the green channel in the overlay."},
		{"blueImage", _Image | Null, "The image to use for the blue channel in the overlay."}
	},
	Output :> {
		{"overlayedImage", _Image, "A false colored overlay of the red, green, and blue channel images."},
		{"coloredImages", {_Image | Null..}, "A list false colored images for the red, green, and blue images provided."}
	},
	SeeAlso -> {
		"ImageOverlay",
		"ImageMask"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*ImageIntensity*)


DefineUsage[ImageIntensity,
{
	BasicDefinitions -> {
		{"ImageIntensity[image]", "xy", "computes the intensity of an image by averaging pixel values vertically."}
	},
	Input :> {
		{"img", _Image|_Graphics, "Image whose pixel intensities will be computed."}
	},
	Output :> {
		{"xy", CoordinatesP, "Image intensity data indexed by pixel position."}
	},
	SeeAlso -> {
		"ImageMask",
		"ImageApply"
	},
	Author -> {
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection::Closed:: *)
(*ImageMask*)


DefineUsage[ImageMask,
{
	BasicDefinitions -> {
		{"ImageMask[inputImage, selectedColor, colorRange]", "outputImage", "replaces all pixels in 'inputImage' that are farther than the 'colorRange' from 'selectedColor' with the MaskColor."},
		{"ImageMask[inputImage, selectedColors, colorRange]", "outputImage", "replaces all pixels in 'inputImage' that are farther than the 'colorRange' away from any 'selectedColors' with the MaskColor."},
		{"ImageMask[inputImage, selectedColors, colorRanges]", "outputImage", "replaces all pixels in 'inputImage' that are farther than the 'colorRanges' away from each 'selectedColors' with the MaskColor."}
	},
	MoreInformation -> {
		"This is used to remove the background from images to make the foreground easier to detect."
	},
	Input :> {
		{"inputImage", _Image, "An image to process."},
		{"selectedColor", _?ColorQ, "A color that should be considered foreground."},
		{"selectedColors", {_?ColorQ..}, "A list of colors that should be considered foreground."},
		{"colorRange", _?NumericQ, "The distance from a color that is still considered to be foreground."},
		{"colorRanges", {_?NumericQ..}, "The distance from each color that is still considered to be foreground."}
	},
	Output :> {
		{"outputImage", _Image, "The image after making all the background pixels a uniform color."}
	},
	SeeAlso -> {
		"ImageIntensity",
		"ImageApply"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*ImageOverlay*)


DefineUsage[ImageOverlay,
{
	BasicDefinitions -> {
		{"ImageOverlay[images]", "overlay", "creates an image that is the overlay of multiple 'images'."}
	},
	Input :> {
		{"images", {(_Image | _Graphics)..}, "An list of images to overlay."}
	},
	Output :> {
		{"overlay", _Graphics, "An overlay of multiple images."}
	},
	SeeAlso -> {
		"ImageMask",
		"ImageApply"
	},
	Author -> {"scicomp", "brad"}
}];