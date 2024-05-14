(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Image Utilities*)


(* ::Subsubsection::Closed:: *)
(*CombineFluorescentImages*)


DefineOptions[CombineFluorescentImages,
	Options :> {
		{OverlayChannels -> All, {(BlueImage | GreenImage | RedImage)..} | All, "The color channels to use in creating the overlaid images.  If All, all fluorescent channels will be overlaid."},
		{Overlay -> True, BooleanP, "If True, an overlaid image of all fluorescent channels will be returned.  If False, a list of colorized fluorescent images will be returned."},
		{ImageDimensions -> Automatic, Automatic | {Automatic | _?NumericQ, Automatic | _?NumericQ}, "If Automatic, the image dimensions of the provided images will be used for the dimensions of the final 'rgbImage'.  Otherwise the provided image dimensions will be used."}
	}];


CombineFluorescentImages[Null,Null,Null,OptionsPattern[CombineFluorescentImages]]:=Null;


(* --- Core Function --- *)
CombineFluorescentImages[redImage:(_Image|Null),greenImage:(_Image|Null),blueImage:(_Image|Null),opts:OptionsPattern[CombineFluorescentImages]]:=Module[
	{defaultedOptions,images,overlayChannels,overlay,imageDimensions,blackImage,resizedImages,selectedImages},

	defaultedOptions = SafeOptions[CombineFluorescentImages, ToList[opts]];
	images = {redImage, greenImage, blueImage};
	overlay = Overlay /. defaultedOptions;
	overlayChannels = OverlayChannels /. defaultedOptions;

  If[MatchQ[overlayChannels,All],
    overlayChannels = {RedImage,GreenImage,BlueImage}
  ];

  imageDimensions = automaticToImageDimensions[
    ImageDimensions /. defaultedOptions,
    DeleteCases[images,Null]
  ];

	(* make a black image of those image dimensions to fill in any blanks *)
	blackImage=Image[ConstantArray[0,Reverse[imageDimensions]]];

	(* resize all the images to match the black image *)
	resizedImages = images /. img_Image :> ImageResize[img,imageDimensions];

	(* pick out only the images we actually want to combine and replace the others with the blackImage *)
	selectedImages = MapThread[
    If[MemberQ[overlayChannels,#1],
      #2,
      Null
    ]&,{{RedImage,GreenImage,BlueImage},resizedImages}
  ];
  

	(*combine all the images together or return false colored images*)
	If[overlay,
		ColorCombine[selectedImages/.{Null->blackImage},"RGB"],
    overlayList[overlayChannels,resizedImages,blackImage]
	]
];


automaticToImageDimensions[Automatic,images:{__Image}]:=automaticToImageDimensions[{Automatic,Automatic},images];

automaticToImageDimensions[{width:Automatic|_?NumericQ,height:Automatic|_?NumericQ},images:{__Image}]:=Module[
  {dimensions,finalWidth,finalHeight},

  dimensions=ImageDimensions[
    First[images]
  ];
  
  finalWidth=If[MatchQ[width,Automatic],
    First[dimensions],
    width
  ];

  finalHeight=If[MatchQ[height,Automatic],
    Last[dimensions],
    height
  ];
  
  {finalWidth,finalHeight}
];


overlayList[channels_List,images:{(_Image|Null)..},blackImage_Image]:=Cases[
  MapThread[
    If[MemberQ[channels,#1],
      colorCombineIndex[images,#2,blackImage],
      #1
    ]&,
    {{RedImage,GreenImage,BlueImage},{1,2,3}}
  ],
  (_Image | Null)
];

colorCombineIndex[images:{(_Image|Null)..},index_Integer,blackImage_Image]:=With[
  {image=images[[index]],blackImages=Table[blackImage,{3}]},

  If[MatchQ[image,Null],
    Null,
    ColorCombine[
      ReplacePart[blackImages,index->image],
      "RGB"
    ]
  ]
];


(* ::Subsubsection:: *)
(*ImageIntensity*)


DefineOptions[ImageIntensity,
	Options :> {
		{Rotate -> Automatic, Automatic | True | False | _?NumericQ, "If True, rotate the image 90 degrees counter-clockwise before computing intensity.  If Automatic, rotates so the height is not greater than the width (Landscape orientation).  If _?NumericQ, rotates the image counter-clockwise by that amount."},
		{InvertIntensity -> Automatic, Automatic | True | False, "If True, treat dark colors as high intensity.  If Automatic, chooses value that minimizes total intensity in the image."},
		{AveragingFunction -> Mean, _Function | _Symbol, "Function to average each column of pixel intensities."},
		{ImageApply -> Mean, _Function | _Symbol, "Function to apply to each pixel color."},
		{Normalize -> False, True | False, "If True, normalize intensity data to be on a scale from 0 to 1."}
	}];


(* Given Null *)
ImageIntensity[Null,___]:=Null;

(*  Given _Image or _Graphics *)
ImageIntensity[img:(_Graphics|_Image),OptionsPattern[ImageIntensity]]:=Module[
	{rotate,imageRotated,rotation,inverse,xy,imageApply,intens,intensNormalized,normalize},

	rotate = OptionDefault[OptionValue[Rotate]];

	(* function to apply to each pixel color *)
	imageApply=OptionDefault[OptionValue[ImageApply]];

	(* whether or not to normalize data *)
	normalize=OptionDefault[OptionValue[Normalize]];

	(* Determine amount to rotate image *)
	rotation=Switch[rotate,
		Automatic, If[Less@@ImageDimensions[img],Pi/2,0],
		True,Pi/2,
		False,0,
		_?NumericQ,rotate
	];

	(* rotate the image *)
	imageRotated = ImageRotate[img,rotation];

	(* Do we want to invert the intesnity, so dark is 'high' *)
	inverse = Switch[OptionValue[InvertIntensity],
		Automatic|Null,Less[nintimage[imageRotated,True],nintimage[imageRotated,False]], 
		True|False,OptionValue[InvertIntensity]
	];

	(* pull the intensity data from the image *)
	xy=Transpose[ImageData[imageRotated]];

	(* compute intensity for each column of pixels *)
	intens=If[inverse===True,InvertData,Identity][
		MapThread[{#2,OptionValue[AveragingFunction][Flatten[imageApply/@#1]]}&,{xy,Range[Length[xy]]}]
	];

	(* normalize the data, if desired *)
	intensNormalized=If[normalize,
		RescaleY[intens,MinMax[intens[[;;,2]]],{0.,1.}],
		intens
	];

	
	intensNormalized

];

(* listable *)
ImageIntensity[imgs:{(_Graphics|_Image)..},ops:OptionsPattern[ImageIntensity]]:=ImageIntensity[#,ops]&/@imgs;


(* helper to determine whether or not to invert intensity when InvertIntensity->Automatic *)
nintimage[img_,inv_]:=With[{summed=ImageIntensity[img,Rotate->False,InvertIntensity->inv]},
	Total[Most[summed[[;;,2]]]*Differences[summed[[;;,1]]]]
];


(* ::Subsubsection::Closed:: *)
(*ImageMask*)


DefineOptions[ImageMask,
	Options :> {
		{MaskColor -> RGBColor[0, 0, 0], _?ColorQ, "The background will be set to this."},
		{DistanceFunction -> EuclideanDistance, EuclideanDistance | SquaredEuclideanDistance | ManhattanDistance, "The function that will be used to calculate color distance."}
	}];


ImageMask[img_Image, selectedColor_?ColorQ, colorRange:_?NumericQ, ops:OptionsPattern[]]:=ImageMask[img, {selectedColor}, colorRange, ops];

ImageMask[img_Image, selectedColors:{_?ColorQ..}, colorRange:_?NumericQ, ops:OptionsPattern[ImageMask]]:=With[
	{colorRanges=Table[colorRange, {Length[selectedColors]}]},

	ImageMask[img, selectedColors, colorRanges, ops]
];

ImageMask[img_Image, selectedColors:{_?ColorQ..}, colorRanges:{_?NumericQ ..}, ops:OptionsPattern[ImageMask]]:=With[
	{maskColor=OptionValue[MaskColor],distanceFunction=OptionValue[DistanceFunction]},
	ImageApply[
		maskPixel[#,selectedColors,colorRanges,maskColor,distanceFunction]&,
		img
	]
]/;SameLengthQ[selectedColors, colorRanges];

pixelP={_?NumericQ,_?NumericQ,_?NumericQ};

maskPixel[pixel:pixelP,selectionColors:{_?ColorQ..},thresholds:{_?NumericQ..},replacementColor_?ColorQ,distanceFunction_]:=With[
	{
		rgbColors=List@@ColorConvert[#,"RGB"]&/@selectionColors,
		rgbReplacement=ColorConvert[replacementColor,"RGB"]	
	},
	If[Or@@MapThread[distanceFunction[pixel,#1]<#2&,{rgbColors,thresholds}],
		pixel,
		List@@rgbReplacement
	]
];



(* ::Subsubsection::Closed:: *)
(*ImageOverlay*)


DefineOptions[ImageOverlay,
	Options :> {
		{Contrast -> Automatic, {_?NumericQ..} | Automatic, "The contrast for each of the images in the overlay."},
		{Brightness -> Automatic, {_?NumericQ..} | Automatic, "The brightness for each of the images in the overlay."},
		{Transparency -> Automatic, {_?NumericQ..} | Automatic, "The brightness for each of the images in the overlay."},
		{ImageSize -> 500, _?NumericQ, "The size of the overlayed image."}
	}];


ImageOverlay::InconsistentOptionLengths="The length of the Contrast/Brightness/Transparency options must be the same as that of the input images list. Defaulting Options to Automatic.";


ImageOverlay[images:{__Image}, ops:OptionsPattern[ImageOverlay]]:=Module[
	{defaultedOptions, imageCount, imageSize, contrastValues, brightnessValues, transparencyValues, adjustedImages},

  defaultedOptions = SafeOptions[ImageOverlay, ToList[ops]];
  imageCount = Length[images];
  imageSize = ImageSize /. defaultedOptions;

  contrastValues = Contrast /. defaultedOptions;
	brightnessValues = Brightness /. defaultedOptions;
	transparencyValues = Transparency /. defaultedOptions;
  
  
  (*Check that all options are the same length as the images list (or all automatic)*)
  If[
    And[
      !SameQ[Automatic,contrastValues,brightnessValues,transparencyValues],
      !SameLengthQ@@DeleteCases[{images,contrastValues,brightnessValues,transparencyValues},Automatic]
    ],
    Message[ImageOverlay::InconsistentOptionLengths]
  ];

  (*Default Automatic Option Values*)
  If[automaticOrInvalidLengthQ[contrastValues,imageCount],
    contrastValues = Table[0,{imageCount}]
  ];

  If[automaticOrInvalidLengthQ[brightnessValues,imageCount],
    brightnessValues = Table[0,{imageCount}]
  ];

  If[automaticOrInvalidLengthQ[transparencyValues,imageCount],
    transparencyValues = Join[{0},Table[0.75,{imageCount-1}]]
  ];

  adjustedImages = MapThread[
    Function[
      {image,contrast,brightness,transparency},
      SetAlphaChannel[ImageAdjust[image, {contrast, brightness}], 1-transparency]
    ],
    {images,contrastValues,brightnessValues,transparencyValues}
  ];

	overlayImage=Show[
    adjustedImages,
		ImageSize->imageSize
  ]
];


automaticOrInvalidLengthQ[input:Automatic,_Integer]:=True;
automaticOrInvalidLengthQ[input_List,expectedLength_Integer]:=Length[input]=!=expectedLength;
