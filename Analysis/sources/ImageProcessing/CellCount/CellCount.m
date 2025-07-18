(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeCellCount*)

(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

microscopeInputObjectTypes = Join[
	microscopeInputRawObjectTypes,
	microscopeInputDataObjectTypes
];

microscopeInputRawObjectTypes = {
	Object[EmeraldCloudFile]
};

microscopeInputDataObjectTypes = {
	Object[Data, Microscope],
	Object[Data, ImageCells]
};

microscopeInputProtocolTypes = {
	Object[Protocol, Microscope],
	Object[Protocol, ImageCells]
};

(* The pattern of a nested field used for ImageField *)
nestedFieldQ[arg:{_Symbol..}|{_Field..}]:=False;
nestedFieldQ[arg_Symbol]:=True;
nestedFieldQ[head_Symbol[arg_]]:=nestedFieldQ[arg];
nestedFieldQ[_]:=False;
nestedFieldP=_?nestedFieldQ|_Field|_Symbol;

(* Standard Cell Properties *)
StandardCellPropertiesP=Alternatives[
	NumberOfComponents,
	NumberOfColonies, (* The colonies in cell growth experiment *)
	NumberOfPlaques, (* The number of Plaques - bacterial lawn circular regions *)
	CellConfluency, (* The overall size of adherent cells *)
	CellMorphology, (* size and shape *)
	ColonyMorphology (* size and shape *)
];

(* Available methods for EdgeDetect MM function *)
GradientFilterMethodsP=Alternatives@@{Bessel,Gaussian,ShenCastan,Sobel};

(* Available methods for EdgeDetect MM function *)
EdgeDetectMethodsP=Alternatives@@{Canny,ShenCastan,Sobel};

(* Available mathods for Binarize MM function *)
BinarizeMethodsP=Alternatives@@{Cluster,Entropy,Mean,Median,MinimumError};

(* Available mathods for MorphologicalBinarize MM function *)
MorphologicalBinarizeMethodsP=Alternatives@@{Cluster,Entropy};

(* Available methods for Inpaint MM function *)
InpaintMethodsP=Alternatives@@{Diffusion,FastMarching,NavierStokes,TextureSynthesis,TotalVariation};

(* Available methods for WatershedComponents MM function *)
WatershedComponentsMethodsP=Alternatives@@{Watershed,Basins,Rainfall,Immersion};

MorphologicalComponentsMethodsP=Alternatives@@{Connected,Nested,Convex,ConvexHull,BoundingBox,BoundingDisk};

(* Different types of data to feed into Image[] function *)
ImageDataTypeP=Bit|Byte|Bit16|Real32|Real64;

(* Different Padding methods *)
PaddingMethodsP=Alternatives@@{Fixed,Periodic,Reflected};

(* All properties avaialable when using ComponentProperties *)
(** NOTE: All properties might not be available for a specific image type. It should be checked using CompoenentMeasurement[..,"Properties"] **)

ComponentPropertiesP=Alternatives@@{

	(* Area measurement *)
	Count,Area,FilledCount,EquivalentDiskRadius,AreaRadiusCoverage,

	(* Perimeter properties *)
	AuthalicRadius,MaxPerimeterDistance,OuterPerimeterCount,PerimeterCount,PerimeterLength,
	PerimeterPositions,PolygonalLength,

	(* Centroid properties *)
	Centroid,Medoid,MeanCentroidDistance,MaxCentroidDistance,MinCentroidDistance,

	(* Parameters of the oriented best-fit ellipse *)
	Length,Width,SemiAxes,Orientation,Elongation,Eccentricity,

	(* Shape measurements *)
	Circularity,FilledCircularity,Rectangularity,

	(* Bounding box properties *)
	Contours,BoundingBox,BoundingBoxArea,MinimalBoundingBox,

	(* Topological properties *)
	Fragmentation,Holes,Complexity,EulerNumber,EmbeddedComponents,EmbeddedComponentCount,
	EnclosingComponents,EnclosingComponentCount,

	(* Basic image intensity properties *)
	MinIntensity,MaxIntensity,MeanIntensity,MedianIntensity,StandardDeviationIntensity,
	TotalIntensity,Skew,IntensityCentroid

};

(* To be enumerated in the PropertyMeasurement field *)
ComponentPropertyCategoriesP=Alternatives@@{AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse,ShapeMeasurements,
	BoundingboxProperties,TopologicalProperties,ImageIntensity};

(* Area measurement *)
ComponentPropertiesAreaP=Alternatives@@{Count,Area,FilledCount,EquivalentDiskRadius,AreaRadiusCoverage};

(* Perimeter properties *)
ComponentPropertiesPerimeterP=Alternatives@@{AuthalicRadius,MaxPerimeterDistance,OuterPerimeterCount,
	PerimeterCount,PerimeterLength,PerimeterPositions,PolygonalLength};

(* Centroid properties *)
ComponentPropertiesCentroidP=Alternatives@@{Centroid,Medoid,MeanCentroidDistance,MaxCentroidDistance,
	MinCentroidDistance};

(* Parameters of the oriented best-fit ellipse *)
ComponentPropertiesEllipseP=Alternatives@@{Length,Width,SemiAxes,Orientation,Elongation,Eccentricity};

(* Shape measurements *)
ComponentPropertiesShapeP=Alternatives@@{Circularity,FilledCircularity,Rectangularity};

(* Bounding box properties *)
ComponentPropertiesBoundingBoxP=Alternatives@@{Contours,BoundingBox,BoundingBoxArea,MinimalBoundingBox};

(* Topological properties *)
ComponentPropertiesTopologyP=Alternatives@@{Fragmentation,Holes,Complexity,EulerNumber,EmbeddedComponents,
	EmbeddedComponentCount,EnclosingComponents,EnclosingComponentCount};

(* Basic image intensity properties *)
ComponentPropertiesIntensityP=Alternatives@@{MinIntensity,MaxIntensity,MeanIntensity,MedianIntensity,
	StandardDeviationIntensity,TotalIntensity,Skew,IntensityCentroid};


(* The available output format for ComponentMeasurements *)
ComponentPropertiesFormatsP=Alternatives@@{ComponentList,ComponentAssociation,PropertyAssociation,
	ComponentPropertyAssociation,PropertyComponentAssociation,Dataset};

(* Different formats to show the highlighed cells *)
HighlightedCellsFormatP=Alternatives@@{Circle,LabeledCircle,Colorize,Contour,LabeledContour};
(* ------------------------------------- *)
(* --- Primitive Options Definitions --- *)
(* ------------------------------------- *)

(* Common options *)
DefineOptionSet[
	commonOptions:>{
		{
			OptionName -> Image,
			Default -> Automatic,
			Description -> "The input image which will be adjusted. When the Image is left as Null, it will be autofilled based on the previous primitive output.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic], PatternTooltip->"When Automatic, the image will be autofilled based on the previous primitives."],
				"Image" -> Widget[Type -> Expression,Pattern :> _Image,Size -> Line],
				"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line]
			],
			Required -> False
		},
		{
			OptionName -> OutputImageLabel,
			Default -> Null,
			Description -> "The label of the image to refer to for any of the remaining primitives.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Widget[Type -> String,Pattern :> _String,Size -> Line]
		},
		{
			OptionName -> ImageAdjust,
			Default -> False,
			Description -> "If we use ImageAdjust on the output image.",
			AllowNull -> False,
			Category -> "General",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> ImageApply,
			Default -> False,
			Description -> "If we apply Image on the output matrix to make it an image.",
			AllowNull -> False,
			Category -> "General",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> Padding,
			Default -> None,
			Description -> "Padding scheme to use.",
			AllowNull -> False,
			Category -> "General",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>None | PaddingMethodsP],
				Widget[Type->Number,Pattern:>GreaterEqualP[0]]
			]
		},
		{
			OptionName -> CornerNeighbors,
			Default -> True,
			Description -> "Whether to include the corner neighbors.",
			AllowNull -> False,
			Category -> "General",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> Kernel,
			Default -> 1,
			Description -> "The structure element which contains a matrix of 0s and 1s.",
			AllowNull -> False,
			Category -> "General",
			Widget -> Alternatives[
				"DiskMatrix"->Widget[Type -> Expression,Pattern :> _?(MatrixQ[#,MemberQ[{0,1},#]&]&), PatternTooltip->"A kernel matrix specified with DiskMatrix[{..,..},..] with 1s within a disk.",Size -> Line],
				"BoxMatrix"->Widget[Type -> Expression,Pattern :> _?(MatrixQ[#,MemberQ[{0,1},#]&]&), PatternTooltip->"A kernel matrix specified with BoxMatrix[{..,..},..] with 1s within a rectangluar box.",Size -> Line],
				"Matrix"->Widget[Type -> Expression,Pattern :> _?(MatrixQ[#,MemberQ[{0,1},#]&]&), PatternTooltip->"Any kernel matrix specified with 1s within a rectangluar box.",Size -> Line],
				"Range"->Widget[Type -> Expression,Pattern :> GreaterEqualP[0], PatternTooltip->"This r value will be equivalent to use BoxMatrix[r].",Size -> Line]
			],
			Required->True
		},
		{
			OptionName->WorkingPrecision,
			Default->Automatic,
			AllowNull->False,
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[MachinePrecision]],
				Widget[Type->Number, Pattern:>GreaterP[0,1]]
			],
			Description->"Specifies how many digits of precision should be maintained in internal computations.",
			Category->"General"
		},
		{
			OptionName -> MaxIterations,
			Default -> 100,
			Description -> "The maximum number of iterations.",
			AllowNull -> False,
			Category -> "General",
			Widget->Widget[Type->Number,Pattern:>GreaterP[0,1] ]
		},
		{
			OptionName -> Standardized,
			Default -> True,
			Description -> "Whether to rescale and shift the Gaussian matrix to account for truncation.",
			AllowNull -> False,
			Category -> "General",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName -> ColorNegate,
			Default -> False,
			Description -> "If we use ColorNegate on the input image.",
			AllowNull -> False,
			Category -> "General",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	}
];

(*** ImageSelection Primitive ***)

(** ImageSelect **)

imageSelectPrimitive=DefinePrimitive[ImageSelect,
	OutputUnitOperationParserFunction->None,
	FastTrack->True,

	Options:>{
		(* Use all of MicroscopeImageSelect options with no index matching *)
		{
			OptionName->InputObject,
			Default -> Automatic,
			Description -> "The microscope data object used for selecting the images.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic], PatternTooltip->"When Automatic, the Object will be autofilled based on the input."],
				Widget[Type -> Object,Pattern :> ObjectP[Object[Data,Microscope]]]
			]
		},
		ModifyOptions[ImageSelectOptions,
			{
				IndexMatching->None,
				IndexMatchingInput->Null,
				IndexMatchingParent->Null,
				IndexMatchingOptions->{}
			}
		]
	},

	InputOptions->{InputObject},
	ExperimentFunction->Analysis`Private`resolveImageSelectPrimitive,
	Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","ImageSelect.png"}]],
	Generative->False,
	Category->"Image Selection",
	Description->"Selects the images from the data object by matching the features that are requested by the user with the ones stored in the Images field of the data object.",
	Author -> "scicomp"
];

(* Imaging Primitive Pattern *)
Clear[ImageSelectionPrimitiveP];
DefinePrimitiveSet[
	ImageSelectionPrimitiveP,
	{
		imageSelectPrimitive
	}
];

(*** Images Primitive ***)

(** MicroscopeImage **)

microscopeImagePrimitive=DefinePrimitive[MicroscopeImage,
	OutputUnitOperationParserFunction->None,
	FastTrack->True,

	Options:>{
		(* Use all of MicroscopeImageSelect options with no index matching *)
		{
			OptionName->InputObject,
			Default -> Automatic,
			Description -> "The microscope data object used for selecting the images.",
			AllowNull -> True,
			Category -> "General",
			Widget -> Alternatives[
				Widget[Type -> Enumeration,Pattern :> Alternatives[Automatic], PatternTooltip->"When Automatic, the Object will be autofilled based on the input."],
				Widget[Type -> Object,Pattern :> ObjectP[Object[Data,Microscope]]]
			]
		},
		ModifyOptions[ImageSelectOptions,
			{
				IndexMatching->None,
				IndexMatchingInput->Null,
				IndexMatchingParent->Null,
				IndexMatchingOptions->{}
			}
		]
	},

	InputOptions->{InputObject},
	ExperimentFunction->Analysis`Private`resolveMicroscopeImagePrimitive,
	Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","MicroscopeImage.png"}]],
	Category->"Image Selection",
	Description->"Specifies the images from the data object with specific features that are requested by the user. By default, this field is auto-populated based on the ImageSelection, however, the user can use this field and set the ImageSelection to Null."
];

(* Imaging Primitive Pattern *)
Clear[ImagesPrimitiveP];
DefinePrimitiveSet[
	ImagesPrimitiveP,
	{
		microscopeImagePrimitive
	}
];


(* Defining the image analysis primitives *)
setupImagePrimitives[]:=Module[
	{
		imagePrimitive,imageAdjustPrimitive,colorNegatePrimitive,colorSeparatePrimitive,binarizePrimitive,morphologicalBinarizePrimitive,
		topHatTransformPrimitive,bottomHatTransformPrimitive,histogramTransformPrimitive,fillingTransformPrimitive,brightnessEqualizePrimitive,
		imageMultiplyPrimitive,ridgeFilterPrimitive,standardDeviationFilterPrimitive,gradientFilterPrimitive,gaussianFilterPrimitive,
		laplacianGaussianFilterPrimitive,bilateralFilterPrimitive,imageTrimPrimitive,edgeDetectPrimitive,
		erosionPrimitive,dilationPrimitive,closingPrimitive,openingPrimitive,inpaintPrimitive,distanceTransformPrimitive,minDetectPrimitive,
		maxDetectPrimitive,watershedComponentsPrimitive,morphologicalComponentsPrimitive,selectComponentsPrimitive,updateMMFunctionSyntax,
		updateSyntaxInformation
	},

	(** Image **)

	imagePrimitive=DefinePrimitive[Image,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Type,
				Default -> Real32,
				Description -> "Possible settings for the type of image include.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> ImageDataTypeP
					]
				]
			}
		},

		InputOptions->{Image,Type},
		ExperimentFunction->Analysis`Private`resolveImagePrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Image.png"}]],
		Generative->False,
		Category->"Image Adjustment",
		Description->"This function can be used to create an image of a specified data type. Values in data are coerced to the specified type by rounding or clipping. By default, \"Real32\" is assumed.",
		Author -> "scicomp"
	];

	(** ImageAdjust **)

	imageAdjustPrimitive=DefinePrimitive[ImageAdjust,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,

		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Correction,
				Default -> {0,0,1},
				Description -> "The correction to the contrast, brightness and gamma feature of the image. For a single value brightness adjustment is zero and gamma is one. No adjustment corresponds to {0,0,1}.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Contrast"->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
					"Contrast-Brightness"->{
						"Contrast"->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
						"Brightness"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
					},
					"Contrast-Brightness-Gamma"->{
						"Contrast"->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
						"Brightness"->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
						"Gamma"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
					}
				]
			},
			{
				OptionName -> InputRange,
				Default -> Automatic,
				Description -> "The min and max range of the pixel intensity. Without input range, the intensity will be mapped to 0-1. If Automatic, the function make this min and max of the image.",
				AllowNull -> True,
				Category -> "General",
				Widget -> {
					"X"->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
					"Y"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
				}
			},
			{
				OptionName -> OutputRange,
				Default -> Automatic,
				Description -> "The min and max range of the pixel intensity for the output image.",
				AllowNull -> True,
				Category -> "General",
				Widget -> {
					"X"->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
					"Y"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
				}
			}
		},

		InputOptions->{Image,Correction,InputRange,OutputRange},
		ExperimentFunction->Analysis`Private`resolveImageAdjustPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","ImageAdjust.png"}]],
		Generative->False,
		Category->"Image Adjustment",
		Description->"Adjusts the contrast, brightness and gamma feature of an image. If no correction is given, the function automatically finds the adjustment parameters.",
		Author -> {"lige.tonggu", "waseem.vali"}
	];

	(** ColorNegate **)

	colorNegatePrimitive=DefinePrimitive[ColorNegate,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,

		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}]
		},

		InputOptions->{Image},
		ExperimentFunction->Analysis`Private`resolveColorNegatePrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","ColorNegate.png"}]],
		Generative->False,
		Category->"Image Adjustment",
		Description->"ColorNegate maps every pixel value or color v to 1-v. For images with defined color spaces, negation happens in the RGBColor space.",
		Author -> {"lige.tonggu", "waseem.vali"}
	];

	(** ColorSeparate **)

	colorSeparatePrimitive=DefinePrimitive[ColorSeparate,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,

		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Color,
				Default -> Null,
				Description -> "Indicates the color to separate using the ColorSeparate function.",
				AllowNull ->True,
				Widget->Widget[Type->Enumeration,Pattern:> ColorP ],
				Category -> "General"
			}
		},

		InputOptions->{Image,Color},
		ExperimentFunction->Analysis`Private`resolveColorSeparatePrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","ColorSeparate.png"}]],
		Generative->False,
		Category->"Image Adjustment",
		Description->"Takes a color image and gives a single gray-scale image corresponding to the color specified as the second argument.",
		Author -> {"lige.tonggu", "waseem.vali"}
	];


	(** Binarize **)

	DefineOptionSet[
		binarizePrimitiveOptions:>{
			{
				OptionName -> Method,
				Default -> Cluster,
				Description -> "How to use to specify the upper threshold.",
				ResolutionDescription->" Binarize uses Otsu's cluster variance maximization method.",
				AllowNull -> False,
				Category -> "General",
				Widget->Alternatives[
					"Method"->Widget[Type->Enumeration,Pattern:>Automatic | BinarizeMethodsP ],
					"BlackFraction & Fraction"->{
						"Method"->Widget[Type->Enumeration,Pattern:>Alternatives["BlackFraction"] ],
						"Fraction"->Widget[Type->Number,Pattern:>GreaterEqualP[0],PatternTooltip->"Will make this fraction of the pixels black."]
					}
				]
			}
		}
	];

	binarizePrimitive=DefinePrimitive[Binarize,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,

		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Threshold,
				Default -> Null,
				Description -> "The threshold for the binarization. When threshold is not given or is Null, it will be automatically found in mathematica's MorphologicalBinarize.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Lower-Upper Pair"->{
						"Lower Threshold"->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
						"Upper Threshold"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
					},
					"Automatic Lower"->Widget[Type -> Number,Pattern :> GreaterEqualP[0],PatternTooltip->"This will be equivalent to use {Automatic,t}."],
					"Automatic Upper"->Widget[Type -> Expression,Pattern :> {GreaterEqualP[0]},PatternTooltip->"This will be equivalent to use {t,Automatic}.",Size->Line],
					"Lower-Upper-Automatic"->Widget[Type -> Expression,Pattern :> {GreaterEqualP[0]|Automatic,GreaterEqualP[0]|Automatic},PatternTooltip->"{t1,t2} will be the lower and upper threshold values.",Size -> Line],
					"Function"->Widget[Type -> Expression,Pattern :> _Function,PatternTooltip->"For any point that this yields true the result is 1 and the rest 0.",Size -> Line]
				]
			}
		},

		SharedOptions:>{
			binarizePrimitiveOptions
		},

		ExperimentFunction->Analysis`Private`resolveBinarizePrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","MorphologicalBinarize.png"}]],
		InputOptions->{Image,Threshold},
		Generative->False,
		Category->"Image Segmentation",
		Description->"Creates a binary image. If Threshold is given as {t1,t2}, binarizing is done by replacing all values in the range of t1 and t2 with 1.",
		Author -> {"lige.tonggu", "waseem.vali"}
	];

	(** MorphologicalBinarize **)

	DefineOptionSet[
		morphologicalBinarizePrimitiveOptions:>{
			{
				OptionName -> Method,
				Default -> Cluster,
				Description -> "How to use to specify the upper threshold.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[Type->Enumeration,Pattern:>Automatic | MorphologicalBinarizeMethodsP ]
			}
		}
	];

	morphologicalBinarizePrimitive=DefinePrimitive[MorphologicalBinarize,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,

		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Threshold,
				Default -> Null,
				Description -> "The threshold for the binarization. When threshold is not given or is Null, it will be automatically found in mathematica's MorphologicalBinarize.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Lower-Upper Pair"->{
						"Lower Threshold"->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
						"Upper Threshold"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
					},
					"Automatic Lower"->Widget[Type -> Number,Pattern :> GreaterEqualP[0],PatternTooltip->"This will be equivalent to use {Automatic,t}."],
					"Automatic Upper"->Widget[Type -> Expression,Pattern :> {GreaterEqualP[0]},PatternTooltip->"This will be equivalent to use {t,Automatic}.",Size->Line],
					"Lower-Upper-Automatic"->Widget[Type -> Expression,Pattern :> {GreaterEqualP[0]|Automatic,GreaterEqualP[0]|Automatic},PatternTooltip->"{t1,t2} will be the lower and upper threshold values.",Size -> Line],
					"t1 Function"->Widget[Type -> Expression,Pattern :> {_Function},PatternTooltip->"This will be equivalent to use {Function[t2],t2} with t2 being Automatic.",Size -> Line],
					"t2 Function"->Widget[Type -> Expression,Pattern :> {GreaterEqualP[0],_Function},PatternTooltip->"This will be equivalent to use {t,Function[t]}.",Size -> Line]
				]
			}
		},

		SharedOptions:>{
			morphologicalBinarizePrimitiveOptions,
			ModifyOptions[commonOptions,CornerNeighbors]
		},

		ExperimentFunction->Analysis`Private`resolveMorphologicalBinarizePrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","MorphologicalBinarize.png"}]],
		InputOptions->{Image,Threshold},
		Generative->False,
		Category->"Image Segmentation",
		Description->"Creates a binary image. If Threshold is given as {t1,t2}, binarizing is done by replacing all values above the upper threshold t2 with 1, also including pixels with intensities above the lower threshold t1 that are connected to the foreground.",
		Author -> {"lige.tonggu", "waseem.vali"}
	];

	(** TopHatTransform **)

	topHatTransformPrimitive=DefinePrimitive[TopHatTransform,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel,Kernel}]
		},

		ExperimentFunction->Analysis`Private`resolveTopHatTransformPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","HistogramTransform.png"}]],
		InputOptions->{Image,Kernel},
		Generative->False,
		Category->"Image Adjustment",
		Description->"Gives the morphological top-hat transform of image with respect to structuring element Kernel.",
		Author -> {"lige.tonggu", "waseem.vali"}
	];

	(** BottomHatTransform **)

	bottomHatTransformPrimitive=DefinePrimitive[BottomHatTransform,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel,Kernel}]
		},

		ExperimentFunction->Analysis`Private`resolveBottomHatTransformPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","HistogramTransform.png"}]],
		InputOptions->{Image,Kernel},
		Generative->False,
		Category->"Image Adjustment",
		Description->"Gives the morphological bottom-hat transform of image with respect to structuring element Kernel.",
		Author -> {"lige.tonggu", "waseem.vali"}
	];

	(** HistogramTransform **)

	histogramTransformPrimitive=DefinePrimitive[HistogramTransform,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Distribution,
				Default -> Null,
				Description -> "The final distribution of the image histogram. In other words, the function gives an image in which pixel values are modified so that its histogram matches the probability density function (PDF) of the distribution according to the field Distribution.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Expression,Pattern :> _?DistributionParameterQ, Size -> Line]
			},
			{
				OptionName -> ReferenceImage,
				Default -> Null,
				Description -> "The reference image. The function outputs an image in which the histogram matches the histogram of the reference image.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Image" -> Widget[Type -> Expression,Pattern :> _Image,Size -> Line],
					"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Word]
				]
			}
		},

		ExperimentFunction->Analysis`Private`resolveHistogramTransformPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","HistogramTransform.png"}]],
		InputOptions->{Image,Distribution,ReferenceImage},
		Generative->False,
		Category->"Image Adjustment",
		Description->"Transforms pixel values of image so that its histogram is either nearly flat, or according to a distribution, or similar to a reference image.",
		Author -> {"lige.tonggu", "waseem.vali"}
	];

	(** FillingTransform **)

	fillingTransformPrimitive=DefinePrimitive[FillingTransform,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Depth,
				Default -> Null,
				Description -> "The function fills only extended minima with the value Depth or less.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0],PatternTooltip->"Extended minima of less than or equal to Depth will be filled."]
			},
			{
				OptionName -> Marker,
				Default -> Null,
				Description -> "The marker image. The function fills extended minima in regions where at least one corresponding element of marker is nonzero.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Image" -> Widget[Type -> Expression,Pattern :> _Image,Size -> Line],
					"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Word]
				]
			},
			ModifyOptions[commonOptions,
				{
					{OptionName->CornerNeighbors,Default->True},
					{OptionName->Padding,Default->0}
				}
			]
		},

		ExperimentFunction->Analysis`Private`resolveFillingTransformPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","FillingTransform.png"}]],
		InputOptions->{Image,Depth,Marker},
		Generative->False,
		Category->"Image Adjustment",
		Description->"The function gives a version of image with all extended minima filled. An extended minimum is a connected set of pixels surrounded by pixels that all have a greater value than the pixels in the set.",
		Author -> {"axu", "waseem.vali"}
	];

	(** BrightnessEqualize **)

	brightnessEqualizePrimitive=DefinePrimitive[BrightnessEqualize,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> FlatField,
				Default -> Null,
				Description -> "A flatfield image is an image of a homogeneous signal like a plain well-lit white background.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
			},
			{
				OptionName -> DarkField,
				Default -> Null,
				Description -> "A darkfield is the same image obtained without lighting. The flat fielding of an image with an object in the same setting is given by (image-flatfield)*Mean[flatfield-darkfield]/(flatfield-darkfield).",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
			}
			(* ModifyOptions[commonOptions,
				{
					{OptionName->Masking,Default->Automatic},
					{OptionName->PerformanceGoal,Default->Automatic}
				}
			] *)
		},

		ExperimentFunction->Analysis`Private`resolveBrightnessEqualizePrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","ImageAdjust.png"}]],
		InputOptions->{Image,FlatField,DarkField},
		Generative->False,
		Category->"Image Adjustment",
		Description->"The function gives local brightness adjustment which is also known as flat fielding, and is used for removing image artifacts caused by nonuniform lighting or variations in sensor sensitivities.",
		Author -> {"scicomp"}
	];

	(** ImageMultiply **)

	imageMultiplyPrimitive=DefinePrimitive[ImageMultiply,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> SecondImage,
				Default -> Null,
				Description -> "The field to provide the second image. The function gives an image in which each pixel is the product of the corresponding pixels in Image and SecondImage.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Image" -> Widget[Type -> Expression,Pattern :> _Image,Size -> Line],
					"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Word],
					"Factor" -> Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
				]
			}
		},

		InputOptions->{Image,SecondImage},
		ExperimentFunction->Analysis`Private`resolveImageMultiplyPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","ImageMultiply.png"}]],

		Generative->False,
		Category->"Image Adjustment",
		Description->"Gives an image in which each pixel is the product of the corresponding pixels in Image and SecondImage.",
		Author -> {"scicomp"}
	];

	(** StandardDeviationFilter **)

	standardDeviationFilterPrimitive=DefinePrimitive[StandardDeviationFilter,

		OutputUnitOperationParserFunction->None,
		FastTrack->True,

		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Radius,
				Default -> 1,
				Description -> "The function filters data by replacing every value by the standard deviations of the values in its range-r neighborhood.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"OneDimension"->Widget[Type -> Number,Pattern :> GreaterP[0]],
					"MultiDimensions"->Widget[Type -> Expression,Pattern :> {GreaterP[0]..}, Size->Line]
				]
			}
		},

		SharedOptions:>{
			ModifyOptions[commonOptions,{OptionName->ImageAdjust}]
		},

		ExperimentFunction->Analysis`Private`resolveStandardDeviationFilterPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Filters.png"}]],
		InputOptions->{Image,Radius},
		Generative->False,
		Category->"Image Adjustment",
		Description->"StandardDeviationFilter is used to filter data by returning the local dispersion of data, where the extent of the effect is dependent on the value of r. For multichannel images, StandardDeviationFilter operates separately on each channel.",
		Author -> {"jireh.sacramento", "xu.yi"}
	];

	(** RidgeFilter **)

	ridgeFilterPrimitive=DefinePrimitive[RidgeFilter,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Scale,
				Default -> 1,
				Description -> "The scale of the Gaussian derivatives in the Hessian matrix.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterP[0]]
			},
			{
				OptionName -> InterpolationOrder,
				Default -> Automatic,
				Description -> "This option is used in the computation of the Hessian matrix.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					Widget[Type -> Number,Pattern :> GreaterP[0]]
				]
			},
			ModifyOptions[commonOptions,{
				{OptionName->ImageAdjust},
				{OptionName->Padding,Default->Fixed}}
			]
		},

		ExperimentFunction->Analysis`Private`resolveRidgeFilterPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Filters.png"}]],
		InputOptions->{Image,Scale},
		Generative->False,
		Category->"Image Adjustment",
		Description->"RidgeFilter is commonly used to find ridges in images by computing estimates of the main principle curvature at each sample point using Gaussian derivatives. The main principle curvature orthogonal to a ridge is given by the main negative eigenvalue of the Hessian matrix.",
		Author -> {"jireh.sacramento", "xu.yi"}
	];

	(** GradientFilter **)

	gradientFilterPrimitive=DefinePrimitive[GradientFilter,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> GaussianParameters,
				Default -> 1,
				Description -> "The radius and the standard deviation of the Gaussian model used in the GradientFilter function. The function gives the magnitude of the gradient of data, computed using discrete derivatives of a Gaussian of sample with the specified radius. If standard deviation is specified, the function uses a Gaussian with the specified standard deviation.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Radius"->Widget[Type -> Number,Pattern :> GreaterP[0]],
					"Radius & StandardDeviation"->{
						"Radius"->Widget[Type -> Number,Pattern :> GreaterP[0]],
						"StandardDeviation"->Widget[Type -> Number,Pattern :> GreaterP[0]]
					}
				]
			},
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "The convolution kernel method to use.",
				AllowNull -> False,
				Category -> "General",
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					"Method"->Widget[Type->Enumeration,Pattern:>GradientFilterMethodsP ],
					"Explicit Kernel"->Widget[Type->Expression,Pattern:>_?MatrixQ, PatternTooltip->"The explicit form of the kernel. Please see mathematica helpfile for GradientFilter for an example.",Size->Line ],
					"DerivativeKernel & NonMaxSuppression"->{
						"DerivativeKernel" -> Alternatives[
							Widget[Type->Enumeration,Pattern:>GradientFilterMethodsP],
							Widget[Type->Enumeration,Pattern:>
								Alternatives[
									Rule["DerivativeKernel","Bessel"],
									Rule["DerivativeKernel","Gaussian"],
									Rule["DerivativeKernel","ShenCastan"],
									Rule["DerivativeKernel","Sobel"]
								]
							]
						],
						"NonMaxSuppression" -> Widget[Type->Enumeration,Pattern:>Alternatives[
							Rule["NonMaxSuppression",True],
							Rule["NonMaxSuppression",False]
						]]
					},
					"Explicit Kernel & NonMaxSuppression"->{
						"Kernel" -> Widget[Type->Expression,Pattern:>_?MatrixQ, PatternTooltip->"The explicit form of the kernel. Please see mathematica helpfile for GradientFilter for an example.",Size->Line ],
						"NonMaxSuppression" -> Widget[Type->Enumeration,Pattern:>Alternatives[
							Rule["NonMaxSuppression",True],
							Rule["NonMaxSuppression",False]
						]]
					}
				]
			},
			ModifyOptions[commonOptions,{
				{OptionName->Padding,Default->Fixed},
				{OptionName->WorkingPrecision},
				{OptionName->ImageAdjust}}
			]
		},

		ExperimentFunction->Analysis`Private`resolveGradientFilterPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Filters.png"}]],
		InputOptions->{Image,GaussianParameters},
		Generative->False,
		Category->"Image Adjustment",
		Description->"GradientFilter is commonly used to detect regions of rapid change in signals and images. For a single-channel image and for data, the gradient magnitude is the Euclidean norm of the gradient g at a pixel position, approximated using discrete derivatives of Gaussians in each dimension.",
		Author -> {"jireh.sacramento", "xu.yi"}
	];

	(** GaussianFilter **)

	gaussianFilterPrimitive=DefinePrimitive[GaussianFilter,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> GaussianParameters,
				Default -> 1,
				Description -> "The radius and the standard deviation of the Gaussian model used in the GradientFilter function. The function is a convolution-based filter that uses a Gaussian matrix with the parameters specified as its underlying kernel. If standard deviation is specified, the function uses a Gaussian with the specified standard deviation. If standard deviation is not specified, the function uses half of the radius for the standard deviation.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Radius"->Widget[Type -> Number,Pattern :> GreaterP[0]],
					"Radius & StandardDeviation"->Widget[Type -> Expression,Pattern :> {GreaterP[0],GreaterP[0]}, Size->Line]
				]
			},
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "The convolution kernel method to use.",
				AllowNull -> False,
				Category -> "General",
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					"Method"->Widget[Type->Enumeration,Pattern:>GradientFilterMethodsP ],
					"Explicit Kernel"->Widget[Type->Expression,Pattern:>_?MatrixQ, PatternTooltip->"The explicit form of the kernel. Please see mathematica helpfile for GradientFilter for an example.",Size->Line ],
					"DerivativeKernel & NonMaxSuppression"->{
						"DerivativeKernel" -> Alternatives[
							Widget[Type->Enumeration,Pattern:>GradientFilterMethodsP],
							Widget[Type->Enumeration,Pattern:>
								Alternatives[
									Rule["DerivativeKernel","Bessel"],
									Rule["DerivativeKernel","Gaussian"],
									Rule["DerivativeKernel","ShenCastan"],
									Rule["DerivativeKernel","Sobel"]
								]
							]
						],
						"NonMaxSuppression" -> Widget[Type->Enumeration,Pattern:>Alternatives[
							Rule["NonMaxSuppression",True],
							Rule["NonMaxSuppression",False]
						]]
					},
					"Explicit Kernel & NonMaxSuppression"->{
						"Kernel" -> Widget[Type->Expression,Pattern:>_?MatrixQ, PatternTooltip->"The explicit form of the kernel. Please see mathematica helpfile for GradientFilter for an example.",Size->Line ],
						"NonMaxSuppression" -> Widget[Type->Enumeration,Pattern:>Alternatives[
							Rule["NonMaxSuppression",True],
							Rule["NonMaxSuppression",False]
						]]
					}
				]
			},
			ModifyOptions[commonOptions,{
				{OptionName->Padding,Default->Fixed},
				{OptionName->WorkingPrecision},
				{OptionName->Standardized},
				{OptionName->ImageAdjust}}
			]
		},

		ExperimentFunction->Analysis`Private`resolveGaussianFilterPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Filters.png"}]],
		InputOptions->{Image,GaussianParameters},
		Generative->False,
		Category->"Image Adjustment",
		Description->"GaussianFilter is a filter commonly used in image processing for smoothing, reducing noise, and computing derivatives of an image. It is a convolution-based filter that uses a Gaussian matrix as its underlying kernel.",
		Author -> "jireh.sacramento"
	];

	(** LaplacianGaussianFilter **)

	laplacianGaussianFilterPrimitive=DefinePrimitive[LaplacianGaussianFilter,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> GaussianParameters,
				Default -> 1,
				Description -> "The radius and the standard deviation of the Gaussian model used in the GradientFilter function. The function is a convolution-based filter that uses a Gaussian matrix with the parameters specified as its underlying kernel. If standard deviation is specified, the function uses a Gaussian with the specified standard deviation. If standard deviation is not specified, the function uses half of the radius for the standard deviation.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Radius"->Widget[Type -> Number,Pattern :> GreaterP[0]],
					"Radius & StandardDeviation"->Widget[Type -> Expression,Pattern :> {GreaterP[0],GreaterP[0]}, Size->Line]
				]
			},
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "The convolution kernel method to use.",
				AllowNull -> False,
				Category -> "General",
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					"Method"->Widget[Type->Enumeration,Pattern:>GradientFilterMethodsP ],
					"Explicit Kernel"->Widget[Type->Expression,Pattern:>_?MatrixQ, PatternTooltip->"The explicit form of the kernel. Please see mathematica helpfile for GradientFilter for an example.",Size->Line ],
					"DerivativeKernel & NonMaxSuppression"->{
						"DerivativeKernel" -> Alternatives[
							Widget[Type->Enumeration,Pattern:>GradientFilterMethodsP],
							Widget[Type->Enumeration,Pattern:>
								Alternatives[
									Rule["DerivativeKernel","Bessel"],
									Rule["DerivativeKernel","Gaussian"],
									Rule["DerivativeKernel","ShenCastan"],
									Rule["DerivativeKernel","Sobel"]
								]
							]
						],
						"NonMaxSuppression" -> Widget[Type->Enumeration,Pattern:>Alternatives[
							Rule["NonMaxSuppression",True],
							Rule["NonMaxSuppression",False]
						]]
					},
					"Explicit Kernel & NonMaxSuppression"->{
						"Kernel" -> Widget[Type->Expression,Pattern:>_?MatrixQ, PatternTooltip->"The explicit form of the kernel. Please see mathematica helpfile for GradientFilter for an example.",Size->Line ],
						"NonMaxSuppression" -> Widget[Type->Enumeration,Pattern:>Alternatives[
							Rule["NonMaxSuppression",True],
							Rule["NonMaxSuppression",False]
						]]
					}
				]
			},
			ModifyOptions[commonOptions,{
				{OptionName->Padding,Default->Fixed},
				{OptionName->WorkingPrecision},
				{OptionName->Standardized},
				{OptionName->ImageAdjust}}
			]
		},

		ExperimentFunction->Analysis`Private`resolveLaplacianGaussianFilterPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Filters.png"}]],
		InputOptions->{Image,GaussianParameters},
		Generative->False,
		Category->"Image Adjustment",
		Description->"LaplacianGaussianFilter is a derivative filter that uses Gaussian smoothing to regularize the evaluation of discrete derivatives. It is commonly used to detect edges in images.",
		Author -> {"jireh.sacramento", "xu.yi"}
	];

	(** BilateralFilter **)

	bilateralFilterPrimitive=DefinePrimitive[BilateralFilter,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Radius,
				Default -> 1,
				Description -> "The radius around each pixel that the filtering is applied to. If the PixelValueSpread is too large, bilateral filtering yields results similar to Gaussian filtering with Radius indicating the range of GaussianFilter.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterP[0,1]]
			},
			{
				OptionName -> PixelValueSpread,
				Default -> 1,
				Description -> "The range of pixel values that are gonna be filtered by BilateralFilter will be limited to 2 times the PixelValueSpread. If the PixelValueSpread is too large, bilateral filtering yields results similar to Gaussian filtering with Radius indicating the range of GaussianFilter.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Radius"->Widget[Type -> Number,Pattern :> GreaterP[0]],
					"Radius & StandardDeviation"->Widget[Type -> Expression,Pattern :> {GreaterP[0],GreaterP[0]}, Size->Line]
				]
			},
			ModifyOptions[commonOptions,{
				{OptionName->WorkingPrecision},
				{OptionName->MaxIterations,Default->1},
				{OptionName->ImageAdjust}}
			]
		},

		ExperimentFunction->Analysis`Private`resolveBilateralFilterPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Filters.png"}]],
		InputOptions->{Image,Radius,PixelValueSpread},
		Generative->False,
		Category->"Image Adjustment",
		Description->"BilateralFilter is a nonlinear local filter used for edge-preserving smoothing. The amount of smoothing is dependent on the values of Radius and PixelValueSpread.",
		Author -> {"jireh.sacramento", "xu.yi"}
	];

	(** ImageTrim **)

	DefineOptionSet[
		imageTrimPrimitiveOptions:>{
			{
				OptionName -> DataRange,
				Default -> Full,
				Description -> "If a scale is used for ROI that is different than the scale of the image pixels, it should be specified in the DataRange.",
				AllowNull -> False,
				Category -> "General",
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,Full]],
					{
						"X Range"->
							{
								"Left"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Right"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							},
						"Y Range"->
							{
								"Bottom"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Top"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
					},
					{
						"X Range"->
							{
								"Left"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Right"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							},
						"Y Range"->
							{
								"Front"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Back"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							},
						"Z Range"->
							{
								"Bottom"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Top"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
					}
				]
			}
		}
	];
	imageTrimPrimitive=DefinePrimitive[ImageTrim,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> ROI,
				Default -> Automatic,
				Description -> "The region of interest. It can be specified either with the coordinates or using graphic primitives.",
				ResolutionDescription->"If Automatic and the instrument is Hemocytometer, then the region of interest is found based on the options HemocytometerSquarePosition. If Automatic for any other instrument, Full is used which leaves the image untrimmed.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Coordinates"->
						{
							"Left-Bottom Corner Coordinate"->
								{
									"X Pixel"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
									"Y Pixel"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
								},
							"Top-Right Corner Coordinate"->
								{
									"X Pixel"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
									"Y Pixel"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
								}
						},
					"Graphics"->Widget[Type -> Expression,Pattern :> Sphere[___]|Disk[___]|Point[___],Size -> Line],
					"Others"->Widget[Type -> Expression,Pattern :> _,Size -> Line]
				]
			},
			{
				OptionName -> Margin,
				Default -> Null,
				Description -> "The margin size to add to the trimmed image.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
			}
		},

		SharedOptions:>{
			imageTrimPrimitiveOptions,
			ModifyOptions[commonOptions,Padding]
		},

		InputOptions->{Image,ROI,Margin},
		ExperimentFunction->Analysis`Private`resolveImageTrimPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","ImageTrim.png"}]],
		(*InputOptions->{Mode},*)
		Generative->False,
		Category->"Image Segmentation",
		Description->"Trims the image based on the provided {{xmin,ymin},{xmax,ymax}} pixel coordinates.",
		Author -> {"axu", "waseem.vali"}
	];

	(* Imaging Primitive Pattern *)
	Clear[ImageAdjustmentPrimitiveP];
	DefinePrimitiveSet[
		ImageAdjustmentPrimitiveP,
		{
			imagePrimitive,
			imageAdjustPrimitive,
			colorNegatePrimitive,
			colorSeparatePrimitive,
			binarizePrimitive,
			morphologicalBinarizePrimitive,
			topHatTransformPrimitive,
			bottomHatTransformPrimitive,
			histogramTransformPrimitive,
			fillingTransformPrimitive,
			brightnessEqualizePrimitive,
			imageMultiplyPrimitive,
			ridgeFilterPrimitive,
			standardDeviationFilterPrimitive,
			gradientFilterPrimitive,
			gaussianFilterPrimitive,
			laplacianGaussianFilterPrimitive,
			bilateralFilterPrimitive,
			imageTrimPrimitive
		}
	];

	(*** ImageSegmentation Primitives ***)

	(** EdgeDetect **)

	DefineOptionSet[
		edgeDetectPrimitiveOptions:>{
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "How to determine the coefficients of the Gaussian matrix.",
				AllowNull -> False,
				Category -> "General",
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Automatic | EdgeDetectMethodsP ],
					{
						"Method"->Widget[Type->Enumeration,Pattern:>EdgeDetectMethodsP ],
						"StraightEdges"->Widget[Type->Expression, Pattern:> Rule["StraightEdges",_Integer],Size->Line]
					}
				]
			}
		}
	];
	edgeDetectPrimitive=DefinePrimitive[EdgeDetect,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Range,
				Default -> Null,
				Description -> "The region of interest. It can be specified either with the coordinates or using graphic primitives.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Fixed"->Widget[Type -> Number,Pattern :> GreaterEqualP[0],PatternTooltip->"This will be used as the Radius for every dimensions."],
					"2D"->{
						"Rrow for height"->Widget[Type -> Number,Pattern :> GreaterEqualP[0]],
						"Rcol for width"->Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
					},
					"3D"->{
						"Rslice for height"->Widget[Type -> Number,Pattern :> GreaterEqualP[0]],
						"Rrow for depth"->Widget[Type -> Number,Pattern :> GreaterEqualP[0]],
						"Rcol for width"->Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
					}
				]
			},
			{
				OptionName -> Threshold,
				Default -> Null,
				Description -> "The threshold to use for image edges.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Lower-Upper Pair"->{
						"Lower Threshold"->Widget[Type->Number,Pattern:>GreaterEqualP[0]],
						"Upper Threshold"->Widget[Type->Number,Pattern:>GreaterEqualP[0]]
					},
					"Automatic Lower"->Widget[Type -> Number,Pattern :> GreaterEqualP[0],PatternTooltip->"This will be equivalent to use {Automatic,t}."],
					"Automatic Upper"->Widget[Type -> Expression,Pattern :> {GreaterEqualP[0]},PatternTooltip->"This will be equivalent to use {t,Automatic}.",Size->Line],
					"Lower-Upper-Automatic"->Widget[Type -> Expression,Pattern :> {GreaterEqualP[0]|Automatic,GreaterEqualP[0]|Automatic},PatternTooltip->"{t1,t2} will be the lower and upper threshold values.",Size -> Line],
					"Function"->Widget[Type -> Expression,Pattern :> _Function,PatternTooltip->"For any point that this yields true the result is 1 and the rest 0.",Size -> Line],
					"Graphics"->Widget[Type -> Expression,Pattern :> Sphere[___]|Disk[___]|Point[___],PatternTooltip->"Any graphic primitive with a pattern Sphere[], Disk[], Point[].",Size -> Line],
					"Others"->Widget[Type -> Expression,Pattern :> _,Size -> Line]
				]
			}
		},

		SharedOptions:>{
			edgeDetectPrimitiveOptions,
			ModifyOptions[commonOptions,{OptionName->Padding,Default->0}]
		},

		InputOptions->{Image,Range,Threshold},
		ExperimentFunction->Analysis`Private`resolveEdgeDetectPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","EdgeDetect.png"}]],
		Generative->False,
		Category->"Image Segmentation",
		Description->"Detects the edges of an image that are a set of points between image regions and are typically computed by linking high-gradient pixels.",
		Author -> {"scicomp"}
	];

	(** Erosion **)

	erosionPrimitive=DefinePrimitive[Erosion,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel,Kernel}]
		},

		(** Option Options **)
		SharedOptions:>{
			ModifyOptions[commonOptions,{OptionName->Padding,Default->0}]
		},

		InputOptions->{Image,Kernel},
		ExperimentFunction->Analysis`Private`resolveErosionPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Erosion.png"}]],
		Generative->False,
		Category->"Image Segmentation",
		Description->"Gives the morphological erosion of the image by removing pixels from the boundary of the image components. This removal is performed with respect to a structuring element specified as Kernel.",
		Author -> {"scicomp", "pnafisi"}
	];

	(** Dilation **)

	dilationPrimitive=DefinePrimitive[Dilation,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel,Kernel}]
		},

		(** Option Options **)
		SharedOptions:>{
			ModifyOptions[commonOptions,{OptionName->Padding,Default->0}]
		},

		ExperimentFunction->Analysis`Private`resolveDilationPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Dilation.png"}]],
		InputOptions->{Image,Kernel},
		Generative->False,
		Category->"Image Segmentation",
		Description->"Gives the morphological dilation of the image by expanding/adding pixels to the boundary of the components. This addition is performed with respect to a structuring element specified as Kernel.",
		Author -> {"scicomp"}
	];

	(** Closing **)

	closingPrimitive=DefinePrimitive[Closing,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel,Kernel}]
		},

		ExperimentFunction->Analysis`Private`resolveClosingPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Closing.png"}]],
		InputOptions->{Image,Kernel},
		Generative->False,
		Category->"Image Segmentation",
		Description->"Gives the morphological closing of Image with respect to a structuring element specified as Kernel. Closing is equivalent to erosion of the dilated image, Erosion[Dilation[image]].",
		Author -> {"scicomp"}
	];

	(** Opening **)

	openingPrimitive=DefinePrimitive[Opening,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel,Kernel}]
		},

		ExperimentFunction->Analysis`Private`resolveOpeningPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Opening.png"}]],
		InputOptions->{Image,Kernel},
		Generative->False,
		Category->"Image Segmentation",
		Description->"Gives the morphological opening of Image with respect to a structuring element specified as Kernel. Opening is equivalent to dilation of the eroded image, Dilation[Erosion[image]].",
		Author -> {"scicomp"}
	];

	(** Inpaint **)

	inpaintPrimitive=DefinePrimitive[Inpaint,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			ModifyOptions[commonOptions,MaxIterations],
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "The inpaint method to use.",
				AllowNull -> False,
				Category -> "General",
				Widget->Alternatives[
					"Method"->Widget[Type->Enumeration,Pattern:>InpaintMethodsP ],
					"TotalVariation & Option"->{
						"Method" -> Widget[Type->Enumeration,Pattern:>Alternatives["TotalVariation"] ],
						"Option" -> Alternatives[
							Widget[Type->Enumeration,Pattern:>
								Alternatives[
									Rule["NoiseModel","Gaussian"],
									Rule["NoiseModel","Laplacian"],
									Rule["NoiseModel","Poisson"],
									Rule["Regularization",Automatic]
								]
							],
							Widget[Type->Expression,Pattern:>{"Regularization",_},PatternTooltip->"Any other value than Automatic for \"Regularization\".",Size->Line ]
						]
					},
					"TextureSynthesis & Option"->{
						"Method" -> Widget[Type->Enumeration,Pattern:>Alternatives["TextureSynthesis"] ],
						"Option" -> Alternatives[
							Widget[Type->Expression,Pattern:>
								Alternatives[
									Rule[Masking,_],
									Rule["MaxSamples",_],
									Rule["NeighborCount",_]
								],
								PatternTooltip->"Values selected for suboptions Masking, \"MaxSamples\", and \"NeighborCount\".",
								Size->Line
							]
						]
					}
				]
			},
			{
				OptionName -> Region,
				Default -> Null,
				Description -> "The image based on which the paint correction is performed. The region to be retouched can be given as an image, a graphics object, or a matrix.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					"Image" -> Widget[Type -> Expression,Pattern :> _Image,Size -> Line],
					"Matrix" -> Widget[Type -> Expression,Pattern :> _?MatrixQ,Size -> Paragraph],
					"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Word]
				]
			}
		},

		InputOptions->{Image,Region},
		ExperimentFunction->Analysis`Private`resolveInpaintPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Inpaint.png"}]],
		Generative->False,
		Category->"Image Segmentation",
		Description->"Gives a binary image in which white pixels correspond to constant extended maxima in the image. An extended maximum is a connected set of pixels with values greater than their surroundings. By default \"TextureSynthesis\" is used. Inpaint operates on different channels except for \"TextureSynthesis\".",
		Author -> {"scicomp"}
	];

	(** DistanceTransform **)

	DefineOptionSet[
		distanceTransformPrimitiveOptions:>{
			{
				OptionName -> DistanceFunction,
				Default -> EuclideanDistance,
				Description -> "The distance function to be used.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[Type->Enumeration,Pattern:>DistanceFunctionP ]
			}
		}
	];
	distanceTransformPrimitive=DefinePrimitive[DistanceTransform,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		(** Input Options **)
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Threshold,
				Default -> Null,
				Description -> "Values above the threshold are treated as foreground. If set as Null, the function gives the distance transform of image, in which the value of each pixel is replaced by its distance to the nearest background pixel.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0],PatternTooltip->"Values above the threshold will be treated as foreground."]
			}
		},

		(** Option Options **)
		SharedOptions:>{
			distanceTransformPrimitiveOptions,
			ModifyOptions[commonOptions,
				{
					{OptionName->ImageAdjust},
					{OptionName->Padding,Default->1}
				}
			]
		},

		ExperimentFunction->Analysis`Private`resolveDistanceTransformPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","DistanceTransform.png"}]],
		InputOptions->{Image,Threshold},
		Generative->False,
		Category->"Image Segmentation",
		Description->"Gives the distance transform of an image, in which the value of each pixel is replaced by its distance to the nearest background pixel.",
		Author -> {"scicomp", "pnafisi"}
	];

	(** MinDetect **)

	minDetectPrimitive=DefinePrimitive[MinDetect,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Height,
				Default -> Null,
				Description -> "The function finds extended minima where the range of pixel values are less than or equal to Height.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0],PatternTooltip->"Extended minima of greater than or equal to Height will be choped."]
			},
			ModifyOptions[commonOptions,
				{
					{OptionName->CornerNeighbors},
					{OptionName->Padding,Default->Automatic}
				}
			]
		},

		InputOptions->{Image,Height},
		ExperimentFunction->Analysis`Private`resolveMinDetectPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","MinDetect.png"}]],
		Generative->False,
		Category->"Image Segmentation",
		Description->"Gives a binary image in which white pixels correspond to constant extended mimima in the Image. An extended minimum is a connected set of pixels with values less than their surroundings.",
		Author -> {"scicomp", "pnafisi"}
	];


	(** MaxDetect **)

	maxDetectPrimitive=DefinePrimitive[MaxDetect,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Height,
				Default -> Null,
				Description -> "The function finds extended maxima where the range of pixel values are greater than or equal to Height.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0],PatternTooltip->"Extended maxima of less than or equal to Height will be choped."]
			},
			ModifyOptions[commonOptions,
				{
					{OptionName->CornerNeighbors},
					{OptionName->Padding,Default->Automatic}
				}
			]
		},

		InputOptions->{Image,Height},
		ExperimentFunction->Analysis`Private`resolveMaxDetectPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","MaxDetect.png"}]],
		Generative->False,
		Category->"Image Segmentation",
		Description->"Gives a binary image in which white pixels correspond to constant extended maxima in the Image. An extended maximum is a connected set of pixels with values greater than their surroundings.",
		Author -> {"scicomp", "pnafisi"}
	];

	(** WatershedComponents **)

	watershedComponentsPrimitive=DefinePrimitive[WatershedComponents,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "If a scale is used for ROI that is different than the scale of the image pixels, it should be specified in the DataRange.",
				AllowNull -> False,
				Category -> "General",
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
					"Method"->Widget[Type->Enumeration,Pattern:>WatershedComponentsMethodsP],
					"MinimumSaliency & Threshold"->{
						"Method"->Widget[Type->Enumeration,Pattern:>Alternatives["MinimumSaliency"]],
						"Threshold"->Widget[Type->Number,Pattern:>GreaterP[0],PatternTooltip->"Gradient descent algorithm is used that merges adjacent basins if their minimum boundary height is less than this value."]
					}
				]
			},
			{
				OptionName -> Marker,
				Default -> Null,
				Description -> "If Marker is specified, WatershedComponents finds basins only at the positions corresponding to foreground regions in a binary image marker.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Image"->Widget[Type -> Expression,Pattern :> _Image|EmeraldCloudFileP,Size -> Line],
					"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line],
					"Coordinates"->Widget[Type -> Expression,Pattern :> CoordinatesP,PatternTooltip->"A list of positions in standard image coordinate system.",Size -> Paragraph]
				]
			},
			{
				OptionName -> BitMultiply,
				Default -> Null,
				Description -> "The field to provide the second image. The function gives an image in which each pixel is the product of the corresponding pixels in Image and SecondImage.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Image" -> Widget[Type -> Expression,Pattern :> _Image,Size -> Line],
					"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Word]
				]
			},
			ModifyOptions[commonOptions,CornerNeighbors,Default->Automatic,ResolutionDescription->"With the \"MinimumSaliency\" method, CornerNeighbors->False is always used. All other methods by default use CornerNeighbors->True."],
			ModifyOptions[commonOptions,ColorNegate],
			ModifyOptions[commonOptions,ImageApply]
		},

		InputOptions->{Image,Marker},
		ExperimentFunction->Analysis`Private`resolveWatershedComponentsPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Components.png"}]],
		Generative->False,
		Category->"Image Segmentation",
		Description->"Computes the watershed transform of an image, returning the result as an array in which positive integers label the catchment basins. Zeros are the regions that do not belong to any component. The \"Watershed\" and \"Immersion\" methods return the watershed lines, represented as 0s in the label array.",
		Author -> {"scicomp"}
	];

	(** MorphologicalComponents **)

	DefineOptionSet[
		morphologicalComponentsPrimitiveOptions:>{
			{
				OptionName -> Method,
				Default -> Connected,
				Description -> "The method for finding morphological components.",
				AllowNull -> False,
				Category -> "General",
				Widget->Alternatives[
					"Method"->Widget[Type->Enumeration,Pattern:>MorphologicalComponentsMethodsP],
					"Others"->Widget[Type->Expression,Pattern:>_,Size->Word]
				]
			}
		}
	];
	morphologicalComponentsPrimitive=DefinePrimitive[MorphologicalComponents,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[commonOptions,{Image,OutputImageLabel}],
			{
				OptionName -> Threshold,
				Default -> 0,
				Description -> "Morphological component treats values above threshold as foreground.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> GreaterEqualP[0]]
			},
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "If a scale is used for ROI that is different than the scale of the image pixels, it should be specified in the DataRange.",
				AllowNull -> False,
				Category -> "General",
				Widget->Widget[Type->Enumeration,Pattern:>MorphologicalComponentsMethodsP]
			},
			ModifyOptions[commonOptions,{
				{OptionName->CornerNeighbors},
				{OptionName->Padding, Default->0}
			}]
		},

		ExperimentFunction->Analysis`Private`resolveMorphologicalComponentsPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Components.png"}]],
		InputOptions->{Image,Threshold},
		Generative->False,
		Category->"Image Segmentation",
		Description->"Assigns sequential integers to different connected components and 0 to pixels that correspond to the background in the image. Without the second argument is equivalent to setting threshold to zero.",
		Author -> {"scicomp"}
	];

	(** SelectComponents **)

	selectComponentsPrimitive=DefinePrimitive[SelectComponents,
		OutputUnitOperationParserFunction->None,
		FastTrack->True,
		Options:>{
			ModifyOptions[
				commonOptions,Image,
				Widget->Alternatives[
					Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
					"Image" -> Widget[Type -> Expression,Pattern :> _Image,Size -> Line],
					"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line],
					"Image & LabelMatrix"->{
						"Image"->Alternatives[
							"Image" -> Widget[Type -> Expression,Pattern :> _Image,Size -> Line],
							"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line]
						],
						"LabelMatrix"->Alternatives[
							"Matrix"->Widget[Type->Expression, Pattern:>_?MatrixQ,Size->Paragraph],
							"Label" -> Widget[Type -> String,Pattern :> _String,Size -> Line]
						]
					}
				],
				Required->False
			],
			ModifyOptions[commonOptions,OutputImageLabel],
			{
				OptionName -> LabelMatrix,
				Default -> Null,
				Description -> "The label matrix is an array of non-negative integers, in which each integer represents a component, and 0 represents the background.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type->Expression, Pattern:>_?MatrixQ,Size->Paragraph]
			},
			{
				OptionName -> Criteria,
				Default -> Automatic,
				Description -> "Selects components based on this given criteria. Components that are not selected are replaced with 0 (black) in both image and lmat.",
				ResolutionDescription->"If Automatic, the criteria is chosen based on the values of AreaThreshold, IntensityThreshold, MinComponentRadius, and MaxComponentRadius.",
				AllowNull -> False,
				Category -> "General",
				Widget -> Alternatives[
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
					"Size"->Widget[Type->Enumeration,Pattern:>Alternatives[Large,Small]],
					"Pure Function"->Widget[Type -> Expression,Pattern :> _Function | _ ,PatternTooltip->"The user can provide any conditional here like hash property > value. Any property from ComponentPropertiesP can be used. A component is selected if the function returns True.",Size->Paragraph]
				]
			},
			{
				OptionName -> Property,
				Default -> Null,
				Description -> "If specified, the function computes Property for all components and returns the first OrderingCount.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Alternatives[
					"Single"->Alternatives[
						"Known"->Widget[Type -> Enumeration,Pattern :>ComponentPropertiesP],
						"Unknown"->Widget[Type -> String,Pattern :>_String, Size->Word]
					],
					"Multiple"->Adder[
						Alternatives[
							"Known"->Widget[Type -> Enumeration,Pattern :>ComponentPropertiesP],
							"Unknown"->Widget[Type -> String,Pattern :>_String, Size->Word]
						]
					]
				]
			},
			{
				OptionName -> OrderingCount,
				Default -> Null,
				Description -> "SelectComponents will compute the Property for all components and returns the first OrderingCount, sorted using Sort.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Number,Pattern :> RangeP[-Infinity,Infinity,1],PatternTooltip->"Negative numbers will sorted in the reverse order."]
			},
			{
				OptionName -> OrderingFunction,
				Default -> Null,
				Description -> "Sorting of computed properties is done using the ordering function.",
				AllowNull -> True,
				Category -> "General",
				Widget -> Widget[Type -> Expression,Pattern :> _Function,Size->Paragraph]
			},
			ModifyOptions[commonOptions,{
				{OptionName->CornerNeighbors,Default->True}
			}]
		},

		InputOptions->{Image,LabelMatrix,Criteria,Property,OrderingCount,OrderingFunction},
		ExperimentFunction->Analysis`Private`resolveSelectComponentsPrimitive,
		Icon->Import[FileNameJoin[{PackageDirectory["Analysis`"],"resources","images","Components.png"}]],
		Generative->False,
		Category->"Image Segmentation",
		Description->"SelectComponents can be used to select image components with specific desired characteristics. Selection may be performed on components' location, shapes, and intensity properties.",
		Author -> {"scicomp"}
	];

	(* Imaging Primitive Pattern *)
	Clear[ImageSegmentationPrimitiveP];
	DefinePrimitiveSet[
		ImageSegmentationPrimitiveP,
		{
			(* One can use ImageAdjustment primitives in the segmentation *)
			imagePrimitive,
			imageAdjustPrimitive,
			colorNegatePrimitive,
			colorSeparatePrimitive,
			topHatTransformPrimitive,
			bottomHatTransformPrimitive,
			histogramTransformPrimitive,
			fillingTransformPrimitive,
			brightnessEqualizePrimitive,
			imageMultiplyPrimitive,
			ridgeFilterPrimitive,
			standardDeviationFilterPrimitive,
			gradientFilterPrimitive,
			gaussianFilterPrimitive,
			laplacianGaussianFilterPrimitive,
			bilateralFilterPrimitive,
			(* ImageSegmentation specific primitives *)
			edgeDetectPrimitive,
			binarizePrimitive,
			morphologicalBinarizePrimitive,
			erosionPrimitive,
			dilationPrimitive,
			closingPrimitive,
			openingPrimitive,
			inpaintPrimitive,
			distanceTransformPrimitive,
			minDetectPrimitive,
			maxDetectPrimitive,
			watershedComponentsPrimitive,
			morphologicalComponentsPrimitive,
			selectComponentsPrimitive
		}
	];

	(* ------------------------------------------------------------------------------------------ *)
	(* --- Update the FormatValues and the syntax of MM Image Functions to Support Primitives --- *)
	(* ------------------------------------------------------------------------------------------ *)

	(* ::Subsection:: *)
	(* updateMMFunctionSyntax *)

	(* Add rule condition to the default mm function definition *)
	updateMMFunctionSyntax[f_]:=Module[
		{wasProtected=MemberQ[Attributes[f],Protected],primitiveSetInformationAdjustment,primitiveSetInformationSegmentation,allPrimitiveInformation},

		If[wasProtected, Unprotect[f]];

		(* Take the option definition from the $PrimitiveSetPrimitiveLookup *)
		primitiveSetInformationAdjustment=Lookup[$PrimitiveSetPrimitiveLookup,Hold[ImageAdjustmentPrimitiveP]];
		primitiveSetInformationSegmentation=Lookup[$PrimitiveSetPrimitiveLookup,Hold[ImageSegmentationPrimitiveP]];
		allPrimitiveInformation=DeleteDuplicates@Join[Lookup[primitiveSetInformationAdjustment,Primitives],Lookup[primitiveSetInformationSegmentation,Primitives]];

		(* Update the syntax highlighting to allow *)
		updateSyntaxInformation[f,allPrimitiveInformation];

		If[wasProtected, Protect[f]];
	];

	(* Change the syntax information pattern *)
	updateSyntaxInformation[f_,allPrimitiveInformation_]:=Module[
		{
			wasProtected=MemberQ[Attributes[f],Protected],primitiveInformation,optionKeys,requiredInputOptions,optionalOptions,defaultSyntaxInformation
		},

		If[wasProtected, Unprotect[f]];

		defaultSyntaxInformation=SyntaxInformation[f];

		primitiveInformation=Lookup[allPrimitiveInformation,f];

		(* Input options and option options *)
		optionKeys=Lookup[Lookup[primitiveInformation,OptionDefinition],"OptionSymbol"];

		If[MatchQ[f,Image], Unprotect[f]];

		(* Add the syntax information and also the option names that don't exist in the default ridge filter *)
		SyntaxInformation[f] = {
			"ArgumentsPattern"->Switch[f,
				(* Taking care of special cases *)
				ImageAdjust,
					{_., _., Optional[{_, _}], Optional[{_, _}],OptionsPattern[]},
				Binarize|ColorNegate|StandardDeviationFilter|ColorNegate|ColorSeparate|FillingTransform,
					{_.,_.,OptionsPattern[]},
				ImageTrim,
					{_.,__,OptionsPattern[]},
				EdgeDetect|BrightnessEqualize|BilateralFilter,
					(* To allow optional first argument *)
					{_., _., _., OptionsPattern[]},
				Dilation|Erosion,
					{_, _., OptionsPattern[]},
				Opening|Closing|SelectComponents,
					{___, OptionsPattern[]},
				_,
					Replace["ArgumentsPattern",defaultSyntaxInformation]
			],
			(* Allows any pattern for the first input arguments *)
			"OptionNames"-> (ToString[#]& /@ DeleteDuplicates@Join[Keys@Options[f],optionKeys])
		};

		If[wasProtected, Protect[f]];
	];

	updateMMFunctionSyntax /@ {
		Image,ImageAdjust,Binarize,ColorSeparate,ColorNegate,GradientFilter,GaussianFilter,LaplacianGaussianFilter,BilateralFilter,
		StandardDeviationFilter,MorphologicalBinarize,TopHatTransform,BottomHatTransform,HistogramTransform,FillingTransform,BrightnessEqualize,
		ImageMultiply,RidgeFilter,ImageTrim,EdgeDetect,Erosion,Dilation,Closing,Opening,Inpaint,DistanceTransform,MinDetect,MaxDetect,
		WatershedComponents,MorphologicalComponents,SelectComponents
	};

	(* We unprotected Image in Primitives and now we'll protect it back *)
	If[!Protected[Image], Protect[Image]];

];
(* Since the symbols are in System` context, we need to OnLoad them to recover them after .mx file generation *)
setupImagePrimitives[];
OnLoad[setupImagePrimitives[]];

(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[AnalyzeCellCount,
	Options :> {

		IndexMatching[
			IndexMatchingInput -> "Microscope data",

			(*** Non-Pooled Options ***)

			(** Microscope Image Selection **)
			{
				OptionName -> ImageSelection,
				Default -> All,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> ({} | Automatic | Preview | All | MicroscopeModeP)],
					Adder[Widget[Type -> Primitive, Pattern :> ImageSelectionPrimitiveP]]
				],
				Description -> "A unit operation to select the microscope images using a short-hand notation, for instance, by choosing \"All\" or the microscope mode such as \"BrightField\", or a specific feature like \"ImagingSite\", i.e., \"ImageSelect[ImagingSite->1]\".",
				ResolutionDescription -> "If Automatic and the input is a data object, the steps will be selected based on the instrument.",
				Category -> "Image Selection"
			},
			{
				OptionName -> Images,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[{} | Automatic]],
					Adder[Widget[Type -> Primitive, Pattern :> ImagesPrimitiveP]]
				],
				Description -> "A unit operation to specify the microscope images by giving all of the image specifications including \"Mode\", \"ExposureTime\", \"ExcitationWavelength\" etc. By default, this option is auto-populated using the \"ImageSelection\" option. However, if Images option is given explicitly, it will be prioritized over \"ImageSelection\".",
				ResolutionDescription -> "If Automatic and the input is a data object, the steps will be selected based on the instrument.",
				Category -> "Image Selection"
			},
			{
				OptionName -> IndexMatchingAnchor,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[1]],
				Description -> "Used to nested index match options to Images correctly.",
				ResolutionDescription -> "Resolves to a nested list of 1s the same shape as the resolved Images option.",
				NestedIndexMatching -> True,
				Category -> "Hidden"
			},
			(** Source Specifications **)
			{
				OptionName -> CellType,
				Default -> Automatic,
				Description -> "The primary type of cells that are used within the samples that the images are acquired from. This will impact the automatic resolution of adjustment steps as well as automatic segmentation and property measurement in the data object.",
				ResolutionDescription -> "If Automatic, the cell type will be resolved to the one provided in the data object.",
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> CellTypeP],
				NestedIndexMatching -> False,
				Category -> "Source Specifications"
			},
			{
				OptionName -> CultureAdhesion,
				Default -> Automatic,
				Description -> "The culture adhesion type that indicates whether the cells adhere to the container that the images are aquired from. This will impact the automatic resolution of adjustment steps as well as automatic properties in the data object.",
				ResolutionDescription -> "If Automatic, the culture adhesion will be resolved to the one provided in the data object.",
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> CultureAdhesionP],
				NestedIndexMatching -> False,
				Category -> "Source Specifications"
			},

			(* Image Features *)
			{
				OptionName -> ImageScale,
				Default -> Automatic,
				Description -> "The scale of the image in x and y directions in [Length Unit]/Pixel or Pixel/[Length unit].",
				ResolutionDescription -> "If Automatic, the image scale will be resolved to the one provided in the data object.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Scale" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 * Micrometer / Pixel],
						Units -> CompoundUnit[
							{1, {Micrometer, {Micrometer}}},
							{-1, {Pixel, {Pixel}}}
						]
					],
					"" -> {
						"X Scale" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 * Micrometer / Pixel],
							Units -> CompoundUnit[
								{1, {Micrometer, {Micrometer}}},
								{-1, {Pixel, {Pixel}}}
							]
						],
						"Y Scale" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 * Micrometer / Pixel],
							Units -> CompoundUnit[
								{1, {Micrometer, {Micrometer}}},
								{-1, {Pixel, {Pixel}}}
							]
						]
					}
				],
				NestedIndexMatching -> True,
				Category -> "Source Specifications"
			},

			(* Hemocytometer Specifications *)
			{
				OptionName -> Method,
				Default -> Automatic,
				Description -> "The counting method for hemocytometer, manual will provide a preview for the user to select the cells manually. For Hybrid, first automatic counting is performed followed by an interface for user to select manually.",
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Automatic | Manual | Hybrid]],
				Category -> "Source Specifications"
			},
			{
				OptionName -> Hemocytometer,
				Default -> Automatic,
				Description -> "Indicates if the images are taken for the hemocytometer instrument.",
				ResolutionDescription -> "If Automatic and a microscope data object is provided, the container model of the SamplesIn will be checked and Hemocytometer is set to True if the container with Object[Container,Hemocytometer] pattern exists.",
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Category -> "Source Specifications"
			},
			{
				OptionName -> GridPattern,
				Default -> Automatic,
				Description -> "Indicates the grid pattern of the hemocytometer that the images are aquired from. There exists different standard grid patterns which differ in the number of sub-squares they contain and also the mesh size.",
				ResolutionDescription -> "If Automatic and the Hemocytometer is resolved to False, GridPattern is set to Null. If Automatic and Hemocytometer is True and Object[Container,Hemocytometer] exists, the GridPattern field is set to the GridPattern field of the object. Otherwise Neubauer is used as default.",
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> HemocytometerGridPatternP],
				NestedIndexMatching -> True,
				Category -> "Source Specifications"
			},
			{
				OptionName -> HemocytometerSquarePosition,
				Default -> Automatic,
				Description -> "Indicates the position of the sub-square within the grid pattern that is cropped and used for cell counting, where {1,1} is the bottom left square and {n,n} is the top right square. If All, the whole image is used, i.e., no cropping is performed.",
				ResolutionDescription -> "If Automatic and the Hemocytometer is resolved to False, HemocytometerSquarePosition is Null. If Automatic and Hemocytometer is True {1,1} will be used as the default.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Short-hand" -> Widget[Type -> Enumeration, Pattern :> Alternatives[All]],
					"Position indices" -> Alternatives[
						{
							"X index" -> Widget[Type -> Number, Pattern :> RangeP[1, 4, 1]],
							"Y index" -> Widget[Type -> Number, Pattern :> RangeP[1, 4, 1]]
						}
					]
				],
				NestedIndexMatching -> True,
				Category -> "Source Specifications"
			},

			(** Confluency Measurement **)
			{
				OptionName -> MeasureConfluency,
				Default -> Automatic,
				Description -> "Indicates if the confluency measurement is intended for an image with adherent cultured cells.",
				ResolutionDescription -> "If Automatic and a microscope data object is provided, this information is taken from the data object. If Automatic and the input in a raw image, confluency measurement is set to False.",
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				NestedIndexMatching -> True,
				Category -> "Confluency Measurement"
			},

			(** Confluency Measurement **)
			{
				OptionName -> MeasureCellViability,
				Default -> Automatic,
				Description -> "Indicates if the viability measurement is intended for an image.",
				ResolutionDescription -> "If Automatic and a microscope data object is provided, this information is taken from the data object. If Automatic and the input in a raw image, viability measurement is set to False.",
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				NestedIndexMatching -> True,
				Category -> "Property Measurement"
			},
			{
				OptionName -> CellViabilityThreshold,
				Default -> Automatic,
				Description -> "Indicates the normalized viability threshold (0-1 value) to use for filtering the counted cells and intensity analysis.",
				ResolutionDescription -> "If Automatic and the ImagingChannel is Null, this will be set to Null. If Automatic and the ImagingChannel is provided, the default will be 0.5.",
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 1]],
				NestedIndexMatching -> True,
				Category -> "Property Measurement"
			},

			(** Fluoresence Specifications **)
			{
				OptionName -> IntensityThreshold,
				Default -> Automatic,
				Description -> "Indicates the normalized fluoresence threshold (0-1 value) to use for filtering the counted cells and intensity analysis.",
				ResolutionDescription -> "If Automatic and the ImagingChannel is Null, this will be set to Null. If Automatic and the ImagingChannel is provided, the default will be 0.5.",
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 1]],
				NestedIndexMatching -> True,
				Category -> "Property Measurement"
			},

			(** Component Size **)
			{
				OptionName -> AreaThreshold,
				Default -> Automatic,
				Description -> "Indicates the minimum area of the components that will be included in the counting. All connected components with area below this value are excluded.",
				ResolutionDescription -> "If Automatic and the input is data object, the value is selected based on the instrument. If Automatic and the input is a raw image, the value is selected based on the image size.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Pixel" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Pixel^2], Units -> CompoundUnit[{2, {Pixel, {Pixel}}}]],
					"Micrometer" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Micrometer^2], Units -> CompoundUnit[{2, {Micrometer, {Micrometer}}}]]
				],
				NestedIndexMatching -> True,
				Category -> "Property Measurement"
			},
			{
				OptionName -> MinComponentRadius,
				Default -> Automatic,
				Description -> "Indicates the minimum radius of the components that will be included in the counting. All connected components with radius below this value are excluded.",
				ResolutionDescription -> "If Automatic and the input is data object, the value is selected based on the instrument. If Automatic and the input is a raw image, the value is set as 1 percent of the image size.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Pixel" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Pixel], Units -> Pixel],
					"Micrometer" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Micrometer], Units -> Micrometer]
				],
				NestedIndexMatching -> True,
				Category -> "Property Measurement"
			},
			{
				OptionName -> MaxComponentRadius,
				Default -> Automatic,
				Description -> "Indicates the maximum radius of the components that will be included in the counting. All connected components with radius greater than this value are excluded.",
				ResolutionDescription -> "If Automatic and the input is data object, the value is selected based on the instrument. If Automatic and the input is a raw image, the value is set as 2.5 percent of the image size.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Pixel" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Pixel], Units -> Pixel],
					"Micrometer" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Micrometer], Units -> Micrometer]
				],
				NestedIndexMatching -> True,
				Category -> "Property Measurement"
			},
			{
				OptionName -> MinCellRadius,
				Default -> Automatic,
				Description -> "Indicates the minimum radius of the cells that will be used for estimating the number of cells from the number of connected components.",
				ResolutionDescription -> "If Automatic and the input is data object, the value is selected based on the instrument. If Automatic the value defaults to 1 percentage of image size.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Pixel" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Pixel], Units -> Pixel],
					"Micrometer" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Micrometer], Units -> Micrometer]
				],
				NestedIndexMatching -> True,
				Category -> "Property Measurement"
			},
			{
				OptionName -> MaxCellRadius,
				Default -> Automatic,
				Description -> "Indicates the maximum radius of the cells that will be used for estimating the number of cells from the number of connected components.",
				ResolutionDescription -> "If Automatic and the input is data object, the value is selected based on the instrument. If Automatic the value defaults to 2.5 percentage of image size.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Pixel" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Pixel], Units -> Pixel],
					"Micrometer" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Micrometer], Units -> Micrometer]
				],
				NestedIndexMatching -> True,
				Category -> "Property Measurement"
			},

			(** Property Measurement **)
			{
				OptionName -> PropertyMeasurement,
				Default -> Automatic,
				Description -> "The cell properties that will be measured or inquired in the morphological components and will be included in the output analysis object.",
				ResolutionDescription -> "If Automatic, resolved values of CellType, CultureAdhesion, Hemocytometer, ImagingChannel and MicroscopeMode will be used to identify the properties to measure.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Single Property" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesP],
					(* Choosing from any of the known symbols *)
					"Standard Mathematica" -> Adder[
						Alternatives[
							"Area Measurement" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesAreaP],
							"Perimeter Properties" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesPerimeterP],
							"Centroid Properties" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesCentroidP],
							"Best-fit Ellipse" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesEllipseP],
							"Shape Measurements" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesShapeP],
							"Bounding-box Properties" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesBoundingBoxP],
							"Topological Properties" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesTopologyP],
							"Image Intensity" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesIntensityP]
						]
					],
					"Category" -> Adder[
						Widget[Type -> Enumeration, Pattern :> ComponentPropertyCategoriesP]
					],
					"Category & Property" -> Adder[
						Alternatives[
							"Category" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertyCategoriesP],
							"Area Measurement" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesAreaP],
							"Perimeter Properties" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesPerimeterP],
							"Centroid Properties" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesCentroidP],
							"Best-fit Ellipse" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesEllipseP],
							"Shape Measurements" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesShapeP],
							"Bounding-box Properties" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesBoundingBoxP],
							"Topological Properties" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesTopologyP],
							"Image Intensity" -> Widget[Type -> Enumeration, Pattern :> ComponentPropertiesIntensityP]
						]
					],
					(* Providing a pure function *)
					"Custom Function" -> Widget[Type -> Expression, Pattern :> _Function, PatternTooltip -> "A function that uses any of the above properties", Size -> Paragraph]
				],
				NestedIndexMatching -> True,
				Category -> "Property Measurement"
			},

			(** Image Adjustments **)
			{
				OptionName -> ImageAdjustment,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[None | {}]],
					Adder[Widget[Type -> Primitive, Pattern :> ImageAdjustmentPrimitiveP]]
				],
				NestedIndexMatching -> True,
				Description -> "A set of adjustment unit operations that are performed prior to the segmentation of the image.",
				ResolutionDescription -> "If Automatic, resolved values of CellType, CultureAdhesion, Hemocytometer, ImagingChannel and MicroscopeMode will be used to identify the adjustment steps.",
				Category -> "Image Processing"
			},

			(** Image Segmentation **)
			{
				OptionName -> ImageSegmentation,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> Alternatives[None | {}]],
					Adder[Widget[Type -> Primitive, Pattern :> ImageSegmentationPrimitiveP]]
				],
				NestedIndexMatching -> True,
				Description -> "A set of unit operations that are performed in order to segment the image and find the cells.",
				ResolutionDescription -> "If Automatic, resolved values of CellType, CultureAdhesion, Hemocytometer, ImagingChannel and MicroscopeMode will be used to identify the segmentation steps.",
				Category -> "Image Processing"
			},

			{
				OptionName -> HighlightedCellsFormat,
				Default -> LabeledCircle,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> HighlightedCellsFormatP],
				NestedIndexMatching -> True,
				Description -> "The style of the highlighted cells.",
				Category -> "Image Processing"
			},

			{
				OptionName -> ManualCoordinates,
				Default -> {},
				Description -> "The manual coordinates that was clicked on the image.",
				AllowNull -> True,
				Widget -> Widget[Type -> Expression, Pattern :> CoordinatesP | {}, Size -> Line],
				NestedIndexMatching -> True,
				Category -> "Output Processing"
			},

			{
				OptionName -> NumberOfManualCells,
				Default -> Null,
				Description -> "The number of cells in the squares of a hemocytometer. The matrix layout indicates the grid pattern which is 3 by 3 for most of the hemocytometer patterns or 4 by 4 for FuchsRosenthal.",
				AllowNull -> True,
				Widget -> Widget[Type -> Expression, Pattern :> {{GreaterEqualP[0]...}...}, Size -> Line],
				NestedIndexMatching -> True,
				Category -> "Output Processing"
			},

			{
				OptionName -> ManualSampleCellDensity,
				Default -> Null,
				Description -> "The number of manual cells per volume in the squares of a hemocytometer, which is calculated using the dilution factor given in the data object. The matrix layout indicates the grid pattern which is 3 by 3 for most of the hemocytometer patterns or 4 by 4 for FuchsRosenthal.",
				AllowNull -> True,
				Widget -> Widget[Type -> Expression, Pattern :> {{GreaterEqualP[0 1 / Milliliter]...}...}, Size -> Line],
				NestedIndexMatching -> True,
				Category -> "Output Processing"
			}

		],

		(** Output Processing **)
		{
			OptionName -> PlotProcessingSteps,
			Default -> False,
			Description -> "Indicates if the preview needs to contain all processing steps.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "Hidden"
		},

		{
			OptionName -> HistogramType,
			Default -> ComponentDiameter,
			Description -> "The default histogram type to demonstrate on the preview image.",
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[ComponentArea, ComponentDiameter, ComponentIntensity]],
			Category -> "Output Processing"
		},

		{
			OptionName -> IncludeComponentMatrix,
			Default -> False,
			Description -> "Whether to include image components matrix in the output object. This is often a large matrix and delays object inspection.",
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "Hidden"
		},

		ModifyOptions[
			"Shared",
			PlotImage,
			{
				OptionName -> TargetUnits,
				Widget -> Alternatives[
					Widget[Type -> Expression, Pattern :> Alternatives[Pixel, Micrometer], Size -> Word],
					{
						"" -> {
							"Left" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Pixel, Micrometer]],
							"Right" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Pixel, Micrometer]]
						},
						"" -> {
							"Top" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Pixel, Micrometer]],
							"Bottom" -> Widget[Type -> Enumeration, Pattern :> Alternatives[Pixel, Micrometer]]
						}
					}
				],
				Category -> "Output Processing",
				AllowNull -> True
			}
		],
		AnalysisPreviewSymbolOption,
		AnalysisTemplateOption,
		CacheOption,
		OutputOption,
		UploadOption
	}
];


(* ------------------------------------- *)
(* --- Warning and Error Definitions --- *)
(* ------------------------------------- *)

Error::ImageLabelNotAvailable="Image label `1` is not available in the list of available images. Please make sure that the label is spelled correctly and check $ImageLookup for the list of available images.";
Warning::SelectComponentsNotSpecified="MinComponentRadius, MaxComponentRadius, AreaThreshold, or IntensityThreshold have been specified without using SelectComponents in the list of ImageSegmentation for Input `1` image index `2`. Please add SelectComponents[] to the end of ImageSegmentation to take these criteria into effect.";
Error::ImageScaleNotAvailable="The image scale for input `1` is not available and therefore the units of `2` option is not acceptable. Please either provide the image scale using ImageScale option or provide the `2` in Pixels.";
Warning::CellCountNoData="There is no data provided in the following protocol(s): `1`.";
Error::CellCountNoData="There is no data at all in the provided inputs. Please add protocols or data objects with actual data.";
Warning::ConflictingCellRadiusOptions="Specified MinCellRadius `1` is greater than specified MaxCellRadius `2`. The issue might be due to using one of the MinCellRadius or MaxCellRadius with the other one set to their default value. In this case, both values will be set the same value.";
Error::InvalidMethod="Manual and Hybrid methods are used for hemocytometer images. Defaulting the values to 1 percentage and 2.5 percentage of image size. The Hemocytometer option for input `1` is not resolved to true, please explicitly set the Hemocytometer option to True if you want to use Manual or Hybrid methods.";
Error::InvalidNestedIndexMatchingOption="The length of the pooled options `2` for input `1` is not consistent with the length of the resolved Images option which is `3`.";
Warning::ConflictingComponentRadiusOptions="Specified MinComponentRadius `3` is greater than specified MaxComponentRadius `4` for input `1` image `2`. It will be set to the default value.";
Warning::ConflictingDefaultCellRadius="Either MinCellRadius or MaxCellRadius for input `1` has been specified which is incosistent with the default cell radius settings. MinCellRadius `2` needs to be less than MaxCellRadius `3` to perform PropagateUncertainty, therefore, MinCellRadius and MaxCellRadius is not utilized. Please either adjust the value of the currently specified option or specify both MinCellRadius and MaxCellRadius explicitly.";
Error::ImagesNotAvailable="Images field of the input `1` is empty. Please make sure that the microscope object contains the images and the field Images is populated.";
Warning::ConflictingAlgorithms="Image processing algorithms `1` and `2` for input `3` can not be True at the same time. The latter one will be set to False. Please use either one of the algorithms or explicitly provide ImageAdjustment and ImageSegmentation options.";
Warning::UnusedSquarePosition="Method for input `1` is set to Manual or Hybrid and therefore HemocytometerSquarePosition is set to All. Please use Method->Automatic if automatic detection for a specific square is intended.";

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)


(* ::Subsubsection::Closed:: *)
(*AnalyzeCellCount*)

(* Overload for single input object *)
AnalyzeCellCount[
  myImage:ObjectP[microscopeInputObjectTypes],
  myOptions:OptionsPattern[AnalyzeCellCount]
] := Module[
	{
		result
	},
	result=AnalyzeCellCount[{myImage}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1 || MatchQ[result,$Failed],
		result,
		First[result]
	]

];

(* Overload for a single protocol object *)
AnalyzeCellCount[myProtocolObject: ObjectP[Object[Protocol,ImageCells]], myOptions: OptionsPattern[AnalyzeCellCount]] := Module[
	{output},
	output = AnalyzeCellCount[myProtocolObject[Data], myOptions]
];

(* Overload for multiple protocol objects *)
AnalyzeCellCount[myProtocolObjects: {ObjectP[Object[Protocol,ImageCells]]..}, myOptions: OptionsPattern[AnalyzeCellCount]] := Module[
	{output},
	output = AnalyzeCellCount[Flatten[myProtocolObjects[Data],1], myOptions]
];

(** TODO: Mixed protocol objects and data objects **)

(* Overload for multiple data object input *)
AnalyzeCellCount[
  myData:{ObjectP[microscopeInputDataObjectTypes]..},
  myOptions:OptionsPattern[AnalyzeCellCount]
] := Module[
	{
		listedOptions,listedData,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,validLengths,validLengthTests,
		suppliedCache,cache,unresolvedOptions,templateTests,combinedOptions,resolvedOptionsResult,
		collapsedOptions,resolvedOptions,resolvedOptionsTests,previewRule,optionsRule,dataPacket,testsRule,resultRule,
		processingSteps,imageScale,dilutionFactor,sampleVolume,imageSelectionPreview,expandedResolvedOptions
	},

	(* Clearing the ImageLookup *)
	$ImageLookup=Null;

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];
	(* Make sure our data are in a list *)
	listedData=ToList[myData];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[listedOptions,Output,Result];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[AnalyzeCellCount,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[AnalyzeCellCount,listedOptions,AutoCorrect->False],Null}
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[AnalyzeCellCount,{listedData},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[AnalyzeCellCount,{listedData},listedOptions],Null}
	];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point) *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* --- Download explicit cache to get information needed by resolve<Type>Options/<type>ResourcePackets --- *)
	suppliedCache=Lookup[listedOptions,Cache,{}];
	downloadedDataPackets=Quiet[
		Download[
			listedData,
			{
				Packet[
					Images,CellModels,SamplesIn,Timelapse,ZStack,Protocol
				],
				(* The cell type and culture will be cached from the CellModels field *)
				Packet[
					Field[CellModels[{CellType,CultureAdhesion}]]
				],
				(* The container model will be cached to check if it is a hemocytometer *)
				Packet[
					Field[Protocol[ContainersIn]]
				],
				(* The grid pattern of the hemocytometer is stored in this field *)
				Packet[
					Field[Protocol[ContainersIn[GridPattern]]]
				],
				(* The source samples and the volume log *)
				Packet[
					Field[SamplesIn[{Composition,Volume,TransfersIn}]]
				]
			},
			Cache->suppliedCache
		],
		{Download::FieldDoesntExist}
	];

	cache=Join[suppliedCache,Flatten/@downloadedDataPackets];

	(* Use any template options to get values for options not specified in myOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[AnalyzeCellCount,{listedData},ReplaceAll[listedOptions,{(rule_->{{{}..}..}|{{}..}) :> (rule->{})}],1,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeCellCount,{listedData},ReplaceAll[listedOptions,{(rule_->{{{}..}..}|{{}..}) :> (rule->{})}],1],{}}
	];

	combinedOptions=ReplaceRule[safeOptions, unresolvedOptions];

	(* If for any of the inputs we need the image selector we return this preview with combined options *)
	imageSelectionPreview=Module[
		{
			nullifiedCombinedOptions,previewTables,objects,temporaryExpandedOptions,imageSelection,previewSlides,images,allImagesContent,
			temporaryCollapsedOptions,invalidImagesQ=False
		},

		(* Turn all automatic options to Null so we don't show then in the builder *)
		nullifiedCombinedOptions=ReplaceAll[
			combinedOptions,
			{
				(option:_Symbol?(!MatchQ[#,Images]&)->Automatic) :> (option->Null),
				(* The options not Automatic but we still nullify to avoid presenting them in the builder *)
				(option:(HighlightedCellsFormat|ManualCoordinates|HistogramType)->_) :> (option->Null)
			}
		];

		(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
		(** NOTE: we are going to use these temporary expanded options to resolve ImageSelection and Images options **)
		{objects,temporaryExpandedOptions} = ExpandIndexMatchedInputs[AnalyzeCellCount,{listedData},nullifiedCombinedOptions,1,Messages->False];

		imageSelection=Lookup[temporaryExpandedOptions,ImageSelection];

		images=Lookup[temporaryExpandedOptions,Images];

		(* Collapse the options so we don't expand Null options *)
		temporaryCollapsedOptions=ReplaceAll[
			temporaryExpandedOptions,
			{
				{{Null}..} :> Null,
				{Null ..} :> Null
			}
		];

		allImagesContent=MapThread[
			Lookup[Experiment`Private`fetchPacketFromCache[#1,#2],Images]&,
			{listedData,cache}
		];

		MapThread[
			(* There is no images found in the object *)
			If[MatchQ[#2,{}],
				Message[Error::ImagesNotAvailable,#1];Message[Error::InvalidInput,#1];invalidImagesQ=True;
			]&,
			{listedData,allImagesContent}
		];

		(* No images in the data object *)
		If[invalidImagesQ,
			Return[outputSpecification/.{Result->$Failed,Preview->$Failed,Options->temporaryCollapsedOptions,Tests->{}}]
		];

		(* Look at the combined options to see if we are asking preview for image selection *)
		previewTables=Which[

			(* If there are no Automatic images it mean we have already resolved - set to Null and proceed to the rest of the function *)
			!MemberQ[images,Automatic|Null],
				Null,

			(* If preview is explicitly selected *)
			MemberQ[imageSelection,Preview],
				makeImageSelectionPreview[listedData,allImagesContent,temporaryCollapsedOptions],

			(* If imageSelection is not preview but we are in the command center and the output is specified as preivew *)
			!MemberQ[imageSelection,Preview] && MatchQ[$ECLApplication,CommandCenter] && MemberQ[outputSpecification,Preview],
			 	makeImageSelectionPreview[listedData,allImagesContent,temporaryCollapsedOptions],

			True,
				Null
		];

		(* Return the preview *)
		If[!NullQ[previewTables],
			Return[outputSpecification/.{Result->previewTables,Preview->previewTables,Options->temporaryCollapsedOptions,Tests->{}}]
		]

	];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{expandedResolvedOptions,resolvedOptionsTests} = resolveAnalyzeCellCountOptions[listedData,listedOptions,combinedOptions,1,Output->{Result,Tests},Cache->cache];
		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"AnalyzeCellCount"->resolvedOptionsTests|>,OutputFormat->Boolean,Verbose->False]["AnalyzeCellCount"],
			True,
			$Failed
		],

		(* We are not gathering tests. Check for Errors and return $Failed if necessary *)
		Check[
			{expandedResolvedOptions,resolvedOptionsTests}={resolveAnalyzeCellCountOptions[listedData,listedOptions,combinedOptions,1,Output->Result,Cache->cache],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Convert expanded options back to singletons whenever possible to display clean values to the user (e.g. OptionName\[Rule]A, not OptionName\[Rule]{A,A,A,A,...})*)
	collapsedOptions=CollapseIndexMatchedOptions[AnalyzeCellCount,expandedResolvedOptions,Messages->False];

	(* CollapseOptions chanes the {x,x} value to a single digit which violates *)
	resolvedOptions=ReplaceAll[collapsedOptions,
		{
			(HemocytometerSquarePosition->position_Integer) :> (HemocytometerSquarePosition->{position,position}),
			(* Collapse mistakenly assumes that a pair of numbers is a scalar *)
			(ImageScale->scale:UnitsP[Micrometer/Pixel]) :> (ImageScale->{scale,scale}),
			(* In case of empty list we retain the listedness *)
			(ImageAdjustment->{}) :> (ImageAdjustment->Map[Map[{}&,Range[Length[referenceImages[[#]]]]]&,Range[Length[myInputs]]]),
			(ImageSegmentation->{}) :> (ImageSegmentation->Map[Map[{}&,Range[Length[referenceImages[[#]]]]]&,Range[Length[myInputs]]]),
			(* If ImageAdjustment was turned into a singlet, return as triple listed listed the way we expect in the later steps *)
			(ImageAdjustment->head_Symbol[assoc_Association]) :> (ImageAdjustment->Map[Map[{head[assoc]}&,Range[Length[referenceImages[[#]]]]]&,Range[Length[myInputs]]]),
			(ImageSegmentation->head_Symbol[assoc_Association]) :> (ImageSegmentation->Map[Map[{head[assoc]}&,Range[Length[referenceImages[[#]]]]]&,Range[Length[myInputs]]]),
			(* In case of the manual coordinates, we need to keep the nested empty lists *)
			(ManualCoordinates->{}) :> (ManualCoordinates->Map[Map[{}&,Range[Length[referenceImages[[#]]]]]&,Range[Length[myInputs]]]),
			(* Collapse mistakenly assumes that a pair of numbers is a scalar *)
			(ManualCoordinates->scalar_?NumericQ) :> FirstCase[resolvedOptions,HoldPattern[ManualCoordinates->_]]
		}
	];

	(* --- Generate rules for each possible Output value --- *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Tests result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper funcctions with any additional tests *)
		Flatten@Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests],
		Null
	];

	(* This looks at the transfer log and calculates the dilution factor *)
	dilutionFactor=calculateDilutionFactor[listedData,resolvedOptions,Cache->cache];
	(* This looks at the cache and calculates the sample volume *)
	sampleVolume=findSampleVolume[listedData,resolvedOptions,Cache->cache];

	(* Prepare the upload packets if either Preview or Result is specified *)
	dataPacket = If[ MemberQ[output,Alternatives[Preview,Result]] && !MatchQ[resolvedOptionsResult,$Failed],
		runImageProcessingSteps[listedData,unresolvedOptions,expandedResolvedOptions,1,dilutionFactor,sampleVolume,Cache->cache],
		Null
	];

	(* Figure out if we want to show the middle steps *)
	plotProcessingSteps=Lookup[resolvedOptions,PlotProcessingSteps];

	(* Take the image scale from the resolvedOptions - expand it if it is collapsed - take only the x scale *)
	imageScale=Replace[Lookup[resolvedOptions,ImageScale],
		{x_?QuantityQ,y_?QuantityQ} :> (Map[Map[{x,y}&,Range[Length[$ImageLookup[[#]]]]]&,Range[Length[$ImageLookup]]])
	];

	(* Take the image scale x for passing to the PlotImage *)
	imageScaleX=If[!NullQ[imageScale],
		imageScale[[All,All,1]],
		ConstantArray[Automatic,Length[referenceImages[[#]]]]&/@Range[Length[dataPacket]];
	];

	(* Plotting the processing steps *)
	processingSteps=If[!MatchQ[resolvedOptionsResult,$Failed] && !NullQ[$ImageLookup],
		If[Length[$ImageLookup]>1,
			SlideView[
				Map[
					Function[inputIndex,
						If[Length[$ImageLookup[[inputIndex]]]>1,
							TabView[
								Map[
									Function[imageIndex,
										Rule[
											("Image "<>ToString[imageIndex]),
											MenuView[
												(* Only picking the image elements *)
												KeyValueMap[
													Rule[#1,PlotImage[#2,TargetUnits->Lookup[resolvedOptions,TargetUnits],Scale->imageScaleX[[inputIndex,imageIndex]],PlotLabel->listedData[[inputIndex]]]]&,
													Select[$ImageLookup[[inputIndex,imageIndex]],ImageQ[#]&]
												]
											]
										]
									],
									Range[Length[$ImageLookup[[inputIndex]]]]
								],
								ControlPlacement->Left
							],
							MenuView[
								(* Only picking the image elements *)
								KeyValueMap[
									Rule[#1,PlotImage[#2,TargetUnits->Lookup[resolvedOptions,TargetUnits],Scale->imageScaleX[[inputIndex,1]],PlotLabel->listedData[[inputIndex]]]]&,
									Select[$ImageLookup[[inputIndex,1]],ImageQ[#]&]
								]
							]
						]
					],
					Range[Length[$ImageLookup]]
				]
			],
			If[Length[$ImageLookup[[1]]]>1,
				TabView[
					Map[
						Function[imageIndex,
							Rule[
								("Image "<>ToString[imageIndex]),
								MenuView[
									(* Only picking the image elements *)
									KeyValueMap[
										Rule[#1,PlotImage[#2,TargetUnits->Lookup[resolvedOptions,TargetUnits],Scale->imageScaleX[[1,imageIndex]]]]&,
										Select[$ImageLookup[[1,imageIndex]],ImageQ[#]&]
									]
								]
							]
						],
						Range[Length[$ImageLookup[[1]]]]
					],
					ControlPlacement->Left
				],
				MenuView[
					(* Only picking the image elements *)
					KeyValueMap[
						Rule[#1,PlotImage[#2,TargetUnits->Lookup[resolvedOptions,TargetUnits],Scale->imageScaleX[[1,1]]]]&,
						Select[$ImageLookup[[1,1]],ImageQ[#]&]
					]
				]
			]
		]
	];

  (* Prepare the Preview result if we were asked to do so *)
  previewRule=Preview->If[!MatchQ[resolvedOptionsResult,$Failed] && MemberQ[output,Preview],
		If[plotProcessingSteps,
			processingSteps,
			makePreview[listedData,resolvedOptions,dataPacket,imageScaleX,dilutionFactor,sampleVolume,Cache->cache]
		],
    Null
  ];

	(* If User requested for Result, either Upload the packet and return constellation messsage (if Upload->True) OR give the upload packet list (if Upload->False) *)
	resultRule=Result->If[MemberQ[output,Result],
		Which[
			MatchQ[resolvedOptionsResult,$Failed], $Failed,
			Lookup[resolvedOptions,Upload], Upload[dataPacket],
			True, dataPacket
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];

(* Overload for multiple raw image *)
AnalyzeCellCount[
  myImages:{ObjectP[microscopeInputRawObjectTypes]..},
  myOptions:OptionsPattern[AnalyzeCellCount]
] := Module[
	{
		listedOptions,listedImages,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,validLengths,validLengthTests,
		downloadedPackets,updatedOptions,unresolvedOptions,templateTests,combinedOptions,resolvedOptionsResult,
		resolvedOptionTests,resolvedOptionsTestResult,resolvedOptions,resolvedOptionsTests,previewRule,optionsRule,dataPacket,testsRule,resultRule,
		imageScale,imageScaleX,processingSteps,plotProcessingSteps
	},

	(* Clearing the ImageLookup *)
	$ImageLookup=Null;

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];
	(* Make sure our data are in a list *)
	listedImages=ToList[myImages];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[listedOptions,Output,Result];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[AnalyzeCellCount,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[AnalyzeCellCount,listedOptions,AutoCorrect->False],Null}
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[AnalyzeCellCount,{listedImages},listedOptions,2,Output->{Result,Tests}],
		{ValidInputLengthsQ[AnalyzeCellCount,{listedImages},listedOptions,2],Null}
	];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point) *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	(* NOTE: ApplyTemplateOptions has issues with {{}}, so we replace it with {} *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[AnalyzeCellCount,{listedImages},ReplaceAll[listedOptions,{(rule_->{{{}..}..}|{{}..}) :> (rule->{})}],2,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeCellCount,{listedImages},ReplaceAll[listedOptions,{(rule_->{{{}..}..}|{{}..}) :> (rule->{})}],2],{}}
	];

	combinedOptions=ReplaceRule[safeOptions, unresolvedOptions];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests} = resolveAnalyzeCellCountOptions[listedImages,listedOptions,combinedOptions,2,Output->{Result,Tests}];
		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"AnalyzeCellCount"->resolvedOptionsTests|>,OutputFormat->Boolean,Verbose->False]["AnalyzeCellCount"],
			True,
			$Failed
		],

		(* We are not gathering tests. Check for Errors and return $Failed if necessary *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveAnalyzeCellCountOptions[listedImages,listedOptions,combinedOptions,2,Output->Result],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* --- Generate rules for each possible Output value --- *)
	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Tests result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper funcctions with any additional tests *)
		Flatten@Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests],
		Null
	];

	(* Prepare the upload packets if either Preview or Result is specified *)
	dataPacket = If[ MemberQ[output,Alternatives[Preview,Result]] && !MatchQ[resolvedOptionsResult,$Failed],
		runImageProcessingSteps[listedImages,unresolvedOptions,resolvedOptions,2,1,1],
		Null
	];

	(* Figure out if we want to show the middle steps *)
	plotProcessingSteps=Lookup[resolvedOptions,PlotProcessingSteps];

	(* Take the image scale from the resolvedOptions - expand it if it is collapsed - take only the x scale *)
	imageScale=If[!MatchQ[resolvedOptionsResult,$Failed],
		Replace[Lookup[resolvedOptions,ImageScale],
			{x_?QuantityQ,y_?QuantityQ} :> (Map[{x,y}&,Range[Length[$ImageLookup]]])
		]
	];

	(* Take the image scale x for passing to the PlotImage *)
	imageScaleX=If[!NullQ[imageScale],
		imageScale[[All,1]],
		ConstantArray[Automatic,Length[dataPacket]]
	];

	(* Plotting the processing steps *)
	processingSteps=If[!MatchQ[resolvedOptionsResult,$Failed] && !NullQ[$ImageLookup],
		If[Length[listedImages]>1,
			TabView[
				Map[
					Function[imageIndex,
						Rule[
							("Image "<>ToString[imageIndex]),
							MenuView[
								(* Only picking the image elements *)
								KeyValueMap[
									Rule[
										#1,
										If[!NullQ[imageScaleX],
											PlotImage[#2,TargetUnits->Lookup[resolvedOptions,TargetUnits],Scale->imageScaleX[[imageIndex]]],
											PlotImage[#2]
										]
									]&,
									Select[$ImageLookup[[imageIndex]],(ImageQ[#])&]
								]
							]
						]
					],
					Range[Length[listedImages]]
				],
				ControlPlacement->Left
			],
			MenuView[
				(* Only picking the image elements *)
				KeyValueMap[
					Rule[
						#1,
						If[!NullQ[imageScaleX],
							PlotImage[#2,TargetUnits->Lookup[resolvedOptions,TargetUnits],Scale->imageScaleX[[1]]],
							PlotImage[#2]
						]
					]&,
					Select[$ImageLookup[[1]],(ImageQ[#])&]
				]
			]
		]
	];

  (* Prepare the Preview result if we were asked to do so *)
  previewRule=Preview->If[!MatchQ[resolvedOptionsResult,$Failed] && MemberQ[output,Preview],
    If[plotProcessingSteps,
			processingSteps,
			makePreview[listedImages,resolvedOptions,dataPacket,imageScaleX,ConstantArray[1,Length[listedImages]],ConstantArray[1 Milliliter,Length[listedImages]]]
		],
    Null
  ];

	(* If User requested for Result, either Upload the packet and return constellation messsage (if Upload->True) OR give the upload packet list (if Upload->False) *)
	resultRule=Result->If[MemberQ[output,Result],
		Which[
			MatchQ[resolvedOptionsResult,$Failed], $Failed,
			Lookup[resolvedOptions,Upload], Upload[dataPacket],
			True, dataPacket
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];

(* ::Subsubsection::Closed:: *)
(*calculateDilutionFactor*)

DefineOptions[calculateDilutionFactor,
	Options:>{
		CacheOption
	}
];

calculateDilutionFactor[
  myInputs:{ObjectP[microscopeInputObjectTypes]..},
  mySafeOptions_List,
  myOptions:OptionsPattern[calculateDilutionFactor]
]:=Module[
	{
		cache,dilutionFactor
	},

	(* Lookup our supplied cache. *)
	cache = Lookup[{myOptions},Cache,{}];

	(* The resolved hemocytometer field which indicates whether the image is aquired from a hemocytometer *)
	dilutionFactor=MapThread[
			(* For data object we take this information from the data object *)
		Function[{myInput,inputCache},
			Module[
				{samplesInObject,transferredIn,cultureAdhesionFromCellModel},

				(* Taking the model from the cache *)
				samplesInObject=First@Lookup[Experiment`Private`fetchPacketFromCache[myInput,inputCache],SamplesIn];

				(* Looking at the transfer logs of the samplesIn *)
				transferredIn=Lookup[Experiment`Private`fetchPacketFromCache[samplesInObject[Object],inputCache],TransfersIn];

				Which[
					(* If there are no transferredIn, the model sample is images directly *)
					MatchQ[transferredIn,{}|Null],
						1.0,
					(* If only one transferredIn, there is no diluent *)
					(* We have diluent *)
					True,
						Module[
							{
								allSamplesVolume,allOriginSamplesPackets,allSamplesComposition,diluentSamplesSet,cellSampleVolume
							},

							(* All transferredIn volumes to use when calculating the volume ratio for dilution factor *)
							allSamplesVolume=transferredIn[[All,2]];

							(* Taking the origin samples of the transferredIn samples *)
							allOriginSamplesPackets=Download[transferredIn[[All,3]]];

							(* The sample model that contains the cell *)
							allSamplesComposition=Lookup[allOriginSamplesPackets,Composition];

							(* The index associated with the cell samples *)
							cellSampleIndex=MapThread[
								Function[
									{inputIndex,inputComposition},

									(* If we can find Model[Cell] in the composition it will be cell sample *)
									If[MatchQ[Cases[composition, {___, {_, ObjectP[Model[Cell]]}, ___}],{}],
										inputIndex,
										Nothing
									]

								],
								{Range[Length[transferredIn]],allSamplesComposition}
							];

							(* TODO: Throw an error if there are more than 1 samples *)

							(* Diluent sample volume is just the total minus the cell sample volume *)
							allSamplesVolume[[First@cellSampleIndex]]/Total[allSamplesVolume]

						]
				]

			]
		],
		{myInputs,cache}
	];

	dilutionFactor

];

(* ::Subsubsection::Closed:: *)
(*findSampleVolume*)

DefineOptions[findSampleVolume,
	Options:>{
		CacheOption
	}
];

findSampleVolume[
  myInputs:{ObjectP[microscopeInputObjectTypes]..},
  mySafeOptions_List,
  myOptions:OptionsPattern[findSampleVolume]
]:=Module[
	{
		cache,cellSampleVolume
	},

	(* Lookup our supplied cache. *)
	cache = Lookup[{myOptions},Cache,{}];

	(* The resolved hemocytometer field which indicates whether the image is aquired from a hemocytometer *)
	cellSampleVolume=MapThread[
			(* For data object we take this information from the data object *)
		Function[{myInput,inputCache},
			Module[
				{samplesInObject,transferredIn,cultureAdhesionFromCellModel},

				(* Taking the model from the cache *)
				samplesInObject=First@Lookup[Experiment`Private`fetchPacketFromCache[myInput,inputCache],SamplesIn];

				(* Looking at the transfer logs of the samplesIn *)
				transferredIn=Lookup[Experiment`Private`fetchPacketFromCache[samplesInObject[Object],inputCache],TransfersIn];

				Which[
					(* If there are no transferredIn, the model sample is images directly *)
					MatchQ[transferredIn,{}|Null],
						transferredIn=Lookup[Experiment`Private`fetchPacketFromCache[samplesInObject[Object],inputCache],Volume],
					(* We have diluent *)
					True,
						Module[
							{
								allSamplesVolume,allOriginSamplesPackets,allSamplesComposition,diluentSamplesSet,cellSampleVolume
							},

							(* All transferredIn volumes to use when calculating the volume ratio for dilution factor *)
							allSamplesVolume=transferredIn[[All,2]];

							(* Taking the origin samples of the transferredIn samples *)
							allOriginSamplesPackets=Download[transferredIn[[All,3]]];

							(* The sample model that contains the cell *)
							allSamplesComposition=Lookup[allOriginSamplesPackets,Composition];

							(* The index associated with the cell samples *)
							cellSampleIndex=MapThread[
								Function[
									{inputIndex,inputComposition},

									(* If we can find Model[Cell] in the composition it will be cell sample *)
									If[MatchQ[Cases[composition, {___, {_, ObjectP[Model[Cell]]}, ___}],{}],
										inputIndex,
										Nothing
									]

								],
								{Range[Length[transferredIn]],allSamplesComposition}
							];

							(* Throw an error if there are more than 1 samples *)


							(* Diluent sample volume is just the total minus the cell sample volume *)
							allSamplesVolume[[First@cellSampleIndex]]

						]
				]

			]
		],
		{myInputs,cache}
	];

	cellSampleVolume

];

(* ------------------------------------- *)
(* --- Inputs and Options Resolution --- *)
(* ------------------------------------- *)

(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCellCountOptions*)


DefineOptions[resolveAnalyzeCellCountOptions,
	Options:>{
		OutputOption,
		CacheOption
	}
];

resolveAnalyzeCellCountOptions[
  myInputs:{ObjectP[microscopeInputObjectTypes]..},
	myAnalyzeOptions_List,
  mySafeOptions_List,
	definitionNumber_Integer,
  myOptions:OptionsPattern[resolveAnalyzeCellCountOptions]
]:=Module[
	{
		objects,temporaryExpandedOptions,expandedOptions,cache,listedInput,output,imageLinks,images,resolvedOptions,
		collapsedOptions,testRule,resultRule,referenceImageObjects,referenceImages,updatedCollapsedOptions,testsQ,
		(* hemocytometer *)
		hemocytometer,resolvedHemocytometer,hemocytometerSquarePosition,resolvedHemocytometerSquarePosition,gridPattern,
		resolvedGridPattern,cellType,resolvedCellType,cultureType,resolvedCultureType,intensityThreshold,
		resolvedIntensityThreshold,
		(* confluency *)
		measureConfluency,resolvedMeasureConfluency,
		(* viability *)
		measureCellViability,resolvedMeasureCellViability,cellViabilityThresholds,resolvedCellViabilityThreshold,
		cellViabilityThreshold,
		(* other parameters *)
		minComponentRadius,maxComponentRadius,resolvedMinComponentRadius,resolvedMaxComponentRadius,areaThreshold,resolvedAreaThreshold,
		imageScale,resolvedImageScale,referenceImageScaleX,referenceImageScaleY,targetUnits,resolvedTargetUnits,
		resolvedCultureAdhesion,cultureAdhesion,minCellRadius,maxCellRadius,resolvedMinCellRadius, resolvedMaxCellRadius,
		objectiveMagnification,method,methodTest,allPooledOptions,pooledOptionsLengthTest,indexMatchingAnchorList,invalidPooledOptionsQ=False,
		myRound,
		(* resolve primitive *)
		resolvedImageAdjustment,imageAdjustmentTests,resolvedImageSegmentation,imageSegmentationTests,
		resolvedPropertyMeasurement,resolvedImageSelection,imageSelectionTests,resolvedImages,imagesTests,
		updatedPartiallyResolvedOptions,selectComponentsAvailableTest,resolvedImageSelectionPrimitives,
		propertyMeasurement,partiallyResolvedOptions
	},

	(* See if we're gathering tests. *)
	testsQ=MemberQ[ToList[Lookup[{myOptions},Output,{}]],Tests];

	(* Lookup our supplied cache. *)
	cache = Lookup[{myOptions},Cache,{}];

	output=Lookup[{myOptions},Output];

	(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
	(** NOTE: we are going to use these temporary expanded options to resolve ImageSelection and Images options **)
	{objects,temporaryExpandedOptions} = ExpandIndexMatchedInputs[AnalyzeCellCount,{myInputs},mySafeOptions,definitionNumber,Messages->False];

	(** Resolve ImageSelection and Images **)

	(* Return with failed if any of the error messages are triggered within the resolvedImageAdjustment function *)
	{{resolvedImageSelection,resolvedImageSelectionPrimitives},imageSelectionTests}=If[testsQ,
		resolveImageSelectionPrimitives[myInputs,temporaryExpandedOptions,Output->{Result,Tests}],
		{resolveImageSelectionPrimitives[myInputs,temporaryExpandedOptions,Output->Result],{}}
	];

	(* The value for Images field specified by user *)
	images=Lookup[temporaryExpandedOptions,Images];

	(* Use the MicroscopeImageSelect to populate the Images fields *)
	(** NOTE: here we are applying the ImageSelection primitives **)
	{resolvedImages,imagesTests}=If[testsQ,
		resolveImagesPrimitives[myInputs,ReplaceRule[temporaryExpandedOptions,{ImageSelection->resolvedImageSelectionPrimitives}],Output->{Result,Tests}],
		{resolveImagesPrimitives[myInputs,ReplaceRule[temporaryExpandedOptions,{ImageSelection->resolvedImageSelectionPrimitives}],Output->Result],{}}
	];

	(* All of the pooled options for the AnalyzeCellCount *)
	allPooledOptions=ToExpression@Replace["OptionName",Select[OptionDefinition[AnalyzeCellCount], #["NestedIndexMatching"] == True &]];

	(* Checking the length of the provided pooled options *)
	pooledOptionsLengthTest=MapThread[
		Function[{myInput,inputIndex},
			Module[
				{invalidPooledOptions},
				invalidPooledOptions={};
				Map[
					If[
						(
							!MatchQ[Length[Part[Lookup[temporaryExpandedOptions,#],inputIndex]],Length[resolvedImages[[inputIndex]]]] &&
							(* Only include if the option is user options *)
							MemberQ[Keys@myAnalyzeOptions,#] &&
							(* Check to see the option is not expanded *)
							MatchQ[Lookup[myAnalyzeOptions,#],Lookup[temporaryExpandedOptions,#]]
						),
						AppendTo[invalidPooledOptions,#]
					]&,
					allPooledOptions
				];
				If[invalidPooledOptions!={},
					(* Throw a message indicating for which input we failed *)
					If[!testsQ,Message[Error::InvalidNestedIndexMatchingOption,myInput,invalidPooledOptions,Length[resolvedImages[[inputIndex]]]];Message[Error::InvalidOption,myInput]];invalidPooledOptionsQ=True;
					Test["The specified pooled options have the same length as the resolved images option.", True, False],
					Test["The specified pooled options have the same length as the resolved images option.", True, True]
				]
			]
		],
		{myInputs,Range[Length[myInputs]]}
	];

	(* Create a list that is of the same structure as resolvedImages that we can use to expand the rest of our options properly *)
	indexMatchingAnchorList = Map[Function[{imageList},Map[Function[{resolvedImage},1],imageList]],resolvedImages];

	(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
	(** NOTE: we are going to use these expanded options to resolve all options except ImageSelection and Images **)
	{objects,expandedOptions} = If[invalidPooledOptionsQ,
		(* We are gonna set all options to Null if any of the pooled options are invalid *)
		ExpandIndexMatchedInputs[AnalyzeCellCount,{myInputs},ReplaceRule[SafeOptions[AnalyzeCellCount],{IndexMatchingAnchor->indexMatchingAnchorList}],definitionNumber,Messages->False],
		ExpandIndexMatchedInputs[AnalyzeCellCount,{myInputs},ReplaceRule[mySafeOptions,{IndexMatchingAnchor->indexMatchingAnchorList}],definitionNumber,Messages->False]
	];

	(* Obtain all the microscope images in a list for each image channel *)
	{referenceImageObjects,referenceImages,referenceImageScaleX,referenceImageScaleY,objectiveMagnification} = getAllMicroscopeImages[myInputs,resolvedImages,Cache->cache];

	(** Resolve CellType **)

	cellType=Lookup[expandedOptions,CellType];

	(* The resolved hemocytometer field which indicates whether the image is aquired from a hemocytometer *)
	resolvedCellType=MapThread[
			(* For data object we take this information from the data object *)
		Function[{myInput,inputCache,inputCellType},
			Module[
				{cellModel,cellTypeFromCellModel},

				(* Taking the model from the cache - taking the first one *)
				(** TODO: check how multiple models are handeled **)
				cellModel=First@Lookup[Experiment`Private`fetchPacketFromCache[myInput,inputCache],CellModels];

				(* Taking the cell type from the cell model *)
				cellTypeFromCellModel=Lookup[Experiment`Private`fetchPacketFromCache[cellModel[Object],inputCache],CellType];

				If[MatchQ[inputCellType,Automatic],
					cellTypeFromCellModel,
					inputCellType
				]

			]
		],
		{myInputs,cache,cellType}
	];

	(** Resolve CultureType **)

	cultureAdhesion=Lookup[expandedOptions,CultureAdhesion];

	(* The resolved hemocytometer field which indicates whether the image is aquired from a hemocytometer *)
	resolvedCultureAdhesion=MapThread[
			(* For data object we take this information from the data object *)
		Function[{myInput,inputCache,inputCultureAdhesion},
			Module[
				{cellModel,cultureAdhesionFromCellModel},

				(* Taking the model from the cache - taking the first one *)
				(** TODO: check how multiple models are handeled **)
				cellModel=First@Lookup[Experiment`Private`fetchPacketFromCache[myInput,inputCache],CellModels];

				(* Taking the cell type from the cell model *)
				cultureAdhesionFromCellModel=Lookup[Experiment`Private`fetchPacketFromCache[cellModel[Object],inputCache],CultureAdhesion];

				If[MatchQ[inputCultureAdhesion,Automatic],
					cultureAdhesionFromCellModel,
					inputCultureAdhesion
				]

			]
		],
		{myInputs,cache,cultureAdhesion}
	];

	(** Resolve ImageScale **)

	(* The scale of the image in x and y directions *)
	imageScale=Lookup[expandedOptions,ImageScale];

	(* The resolved imagescale field which indicates the scale of the image in x and y directions *)
	resolvedImageScale=MapThread[
			(* For data object we take this information from the data object *)
		Function[{myInput,inputCache,inputImageScale,inputReferenceImageScaleX,inputReferenceImageScaleY},
			(* Mapping over all images of an input *)
			MapThread[
				If[MatchQ[#1,Automatic],
					(* Check the data object and see if the container is a hemocytometer *)
					{#2,#3},
					#1
				]&,
				{inputImageScale,inputReferenceImageScaleX,inputReferenceImageScaleY}
			]
		],
		{myInputs,cache,imageScale,referenceImageScaleX,referenceImageScaleY}
	];

	(** Resolve Hemocytometer **)

	(* Whether the image is associated with the hemocytometer *)
	hemocytometer=Lookup[expandedOptions,Hemocytometer];

	(* The resolved hemocytometer field which indicates whether the image is aquired from a hemocytometer *)
	resolvedHemocytometer=MapThread[
			(* For data object we take this information from the data object *)
		Function[{myInput,inputCache,inputHemocytometer},
			(* Mapping over all images of an input *)

			If[MatchQ[inputHemocytometer,Automatic],
				(* Check the data object and see if the container is a hemocytometer *)
				Module[
					{
						protocol,containersInFromProtocol
					},
					protocol=FirstOrDefault[Lookup[Experiment`Private`fetchPacketFromCache[myInput,inputCache],Protocol],Null];

					(* Taking the container object type from the protocol *)
					containersInFromProtocol=FirstOrDefault[Lookup[Experiment`Private`fetchPacketFromCache[protocol[Object],inputCache],ContainersIn],Null];

					If[MatchQ[containersInFromProtocol,ObjectP[Object[Container,Hemocytometer]]],
						True,
						False
					]
				],
				inputHemocytometer
			]
		],
		{myInputs,cache,hemocytometer}
	];

	(* Whether the image is associated with the hemocytometer *)
	method=Lookup[expandedOptions,Method];

	(* Throwing error message if ImageScale is not specified *)
	methodTest=MapThread[
		Function[{myInput,inputMethod,inputHemocytometer},
			If[
				And[
					!inputHemocytometer,
					MatchQ[inputMethod,Manual|Hybrid]
				],
				(* Throw a message indicating for which input we failed *)
				If[!testsQ,Message[Error::InvalidMethod,myInput];Message[Error::InvalidOption,myInput]];
				Test["The manual or hybrid method is chosen for a hemocytometer image.", True, False],
				Test["The manual or hybrid method is chosen for a hemocytometer image.", True, True]
			]
		],
		{myInputs,method,resolvedHemocytometer}
	];

	(* If the image is associated with the hemocytometer, what is the grid pattern *)
	gridPattern=Lookup[expandedOptions,GridPattern];

	(* The resolved hemocytometerSquarePosition field which indicates the position of the square that contains our region of interest *)
	resolvedGridPattern=MapThread[
		Function[{myInput,inputCache,inputHemocytometer,inputGridPattern},
			MapThread[
				Which[
					MatchQ[inputHemocytometer,True] && MatchQ[#1,Automatic],
						(* Take the grid pattern from the protocol object *)
						Module[
							{
								protocol,containersInFromProtocol
							},
							protocol=FirstOrDefault[Lookup[Experiment`Private`fetchPacketFromCache[myInput,inputCache],Protocol],Null];

							(* Taking the container object type from the protocol *)
							containersInFromProtocol=If[!MatchQ[protocol,Null],
								Lookup[Experiment`Private`fetchPacketFromCache[protocol[Object],inputCache],ContainersIn,Null]
							];

							(* Taking the grid pattern from the containersInFromProtocol *)
							gridPattern=If[!MatchQ[containersInFromProtocol,Null],
								Lookup[Experiment`Private`fetchPacketFromCache[containersInFromProtocol[Object],inputCache],GridPattern,Null]
							];

							If[MatchQ[gridPattern,HemocytometerGridPatternP],
								gridPattern,
								Neubauer
							]
						],
					MatchQ[inputHemocytometer,True] && !MatchQ[#1,Automatic],
						#1,
					True,
						Null
				]&,
				{inputGridPattern}
			]
		],
		{myInputs,cache,resolvedHemocytometer,gridPattern}
	];

	(* If the image is associated with the hemocytometer, what is the square position *)
	hemocytometerSquarePosition=Lookup[expandedOptions,HemocytometerSquarePosition];

	(* The resolved hemocytometerSquarePosition field which indicates the position of the square that contains our region of interest *)
	resolvedHemocytometerSquarePosition=Replace[
		MapThread[
			Function[{myInput,inputResolvedHemocytometer,inputHemocytometerSquarePosition,inputMethod},
				MapThread[
					Which[
						MatchQ[inputResolvedHemocytometer,True] && MatchQ[#1,Automatic|All],
							All,
						MatchQ[inputResolvedHemocytometer,True] && MatchQ[inputMethod,Manual|Hybrid] && !MatchQ[#1,Automatic|All],
							(
								Message[Warning::UnusedSquarePosition,myInput];
								All
							),
						MatchQ[inputResolvedHemocytometer,True] && !MatchQ[#1,Automatic|All],
							#1,
						True,
							Null
					]&,
					{inputHemocytometerSquarePosition}
				]
			],
			{myInputs,resolvedHemocytometer,hemocytometerSquarePosition,method}
		],
		{{Null..}..} :> Null
	];

	(** Resolve Confluency **)

	(* Whether the image is associated with the confluency measurement *)
	measureConfluency=Lookup[expandedOptions,MeasureConfluency];

	(* The resolved measureConfluency field which indicates whether the image is aquired for confluency measurement *)
	resolvedMeasureConfluency=MapThread[
		Function[{myInput,inputCellType,inputCultureAdhesion,inputMeasureConfluency,inputHemocytometer},
			MapThread[
				Which[
					MatchQ[#1,Automatic],
						Which[
							(* If Hemocytometer is resolved to True, MeasureConfluency is set to False *)
							inputHemocytometer,
								False,
							(* If the cell type is tissue culture and the cells are adherent*)
							(MatchQ[inputCellType,Mammalian] && MatchQ[inputCultureAdhesion,Adherent]),
								True,
							True,
								False
						],

					(* Hemocytometer and MeasureConfluency can't be used at the same time *)
					(#1 && inputHemocytometer),
						(
							Message[Warning::ConflictingAlgorithms,Hemocytometer,MeasureConfluency,myInput];
							False
						),
					True,
						#1
				]&,
				{inputMeasureConfluency}
			]
		],
		{myInputs,resolvedCellType,resolvedCultureAdhesion,measureConfluency,resolvedHemocytometer}
	];

	(** Resolve Viability **)

	(* Whether the image is associated with the viability measurement *)
	measureCellViability=Lookup[expandedOptions,MeasureCellViability];

	(* The resolved measureCellViability field which indicates whether the image is aquired for viability measurement *)
	resolvedMeasureCellViability=MapThread[
		Function[{myInput,inputCellType,inputCultureAdhesion,inputMeasureCellViability,inputHemocytometer,inputMeasureConfluency},
			MapThread[
				Which[
					MatchQ[#1,Automatic],
						Which[
							(* If Hemocytometer is resolved to True, MeasureConfluency is set to False *)
							inputHemocytometer,
								False,
							True,
								False
						],

					(* Hemocytometer and MeasureCellViability can't be used at the same time *)
					(#1 && inputHemocytometer),
						(
							Message[Warning::ConflictingAlgorithms,Hemocytometer,MeasureCellViability,myInput];
							False
						),

					(* MeasureConfluency and MeasureCellViability can't be used at the same time *)
					(#1 && #2),
						(
							Message[Warning::ConflictingAlgorithms,MeasureConfluency,MeasureCellViability,myInput];
							False
						),

					True,
						#1
				]&,
				{inputMeasureCellViability,inputMeasureConfluency}
			]
		],
		{myInputs,resolvedCellType,resolvedCultureAdhesion,measureCellViability,resolvedHemocytometer,resolvedMeasureConfluency}
	];

	(** Resolve CellViabilityThreshold **)

	cellViabilityThreshold=Lookup[expandedOptions,CellViabilityThreshold];

	resolvedCellViabilityThreshold=MapThread[
		Function[{myInput,inputReferenceImages,inputCellViabilityThreshold},
			MapThread[
				Which[
					(* Automatic resolves to 0.5 *)
					MatchQ[#3,Automatic],
						0.5,
					!MatchQ[#3,Automatic],
						#3,
					True,
						#3
				]&,
				{inputReferenceImages,inputReferenceImages,inputCellViabilityThreshold}
			]
		],
		{myInputs,referenceImages,cellViabilityThreshold}
	];

	(** Resolve IntensityThreshold **)

	intensityThreshold=Lookup[expandedOptions,IntensityThreshold];

	resolvedIntensityThreshold=MapThread[
		Function[{myInput,inputReferenceImages,inputIntensityThreshold},
			MapThread[
				Which[
					(* Automatic resolves to 0.1 *)
					MatchQ[#3,Automatic],
						0.01,
					!MatchQ[#3,Automatic],
						#3,
					True,
						#3
				]&,
				{inputReferenceImages,inputReferenceImages,inputIntensityThreshold}
			]
		],
		{myInputs,referenceImages,intensityThreshold}
	];

	(** Resolve AreaThreshold **)

	areaThreshold=Lookup[expandedOptions,AreaThreshold];

	resolvedAreaThreshold=MapThread[
		Function[{myInput,inputReferenceImages,inputAreaThreshold,inputHemocytometer},
			MapThread[
				Which[
					(* Automatic resolves to 2.5% of image dimension along with X axis *)
					MatchQ[#2,Automatic],
						10 Micrometer^2,

					True,
						#2
				]&,
				{inputReferenceImages,inputAreaThreshold}
			]
		],
		{myInputs,referenceImages,areaThreshold,resolvedHemocytometer}
	];

	(** Resolve MinComponentRadius **)

	minComponentRadius=Lookup[expandedOptions,MinComponentRadius];

	resolvedMinComponentRadius=MapThread[
		Function[{myInput,inputImage,inputMinComponentRadius,inputHemocytometer},
			MapThread[
				Which[
					MatchQ[#2,Automatic],
						2 Micrometer,

					True,
						#2
				]&,
				{inputImage,inputMinComponentRadius}
			]
		],
		{myInputs,referenceImages,minComponentRadius,resolvedHemocytometer}
	];

	(** Resolve MaxComponentRadius **)

	maxComponentRadius=Lookup[expandedOptions,MaxComponentRadius];

	resolvedMaxComponentRadius=MapThread[
		Function[{myInput,inputReferenceImages,inputMaxComponentRadius,inputHemocytometer,inputMinComponentRadius},
			MapThread[
				Which[

					MatchQ[#3,Automatic],
						20 Micrometer,

					(* Throw a warning and set the default max radius *)
					MatchQ[Units[#3],Units[#4]] && #3 < #4,
						(
							Message[Warning::ConflictingComponentRadiusOptions, myInput, #2, #4, #3];
							9 Pixel
						),

					True,
						#3
				]&,
				{inputReferenceImages,Range[Length[inputReferenceImages]],inputMaxComponentRadius,inputMinComponentRadius}
			]
		],
		{myInputs,referenceImages,maxComponentRadius,resolvedHemocytometer,resolvedMinComponentRadius}
	];

	(** Resolve MinCellRadius/MaxCellRadius **)

	{minCellRadius,maxCellRadius}=Lookup[expandedOptions,{MinCellRadius,MaxCellRadius}];

	{resolvedMinCellRadius, resolvedMaxCellRadius} = Transpose@MapThread[
		Function[{myInput,inputReferenceImages,inputObjectiveMagnification,inputMinCellRadius,inputMaxCellRadius},
			Transpose@MapThread[
				resolveAnalyzeCellCountMinMaxRadius[#2, {#3, #4}]&,
				{inputReferenceImages,inputObjectiveMagnification,inputMinCellRadius,inputMaxCellRadius}
			]
		],
		{myInputs,referenceImages,objectiveMagnification,minCellRadius,maxCellRadius}
	];

	(** Resolve TargetUnits **)

	targetUnits=Lookup[expandedOptions,TargetUnits];

	resolvedTargetUnits=Which[
		(* Automatic resolves to a specific combination to show pixel as the primary and micrometer as the secondary units *)
		MatchQ[targetUnits,Automatic],
			{{Pixel,Micrometer},{Pixel,Micrometer}},

		True,
			targetUnits
	];

	(* Take the first three significant digits *)
	myRound[number_]:=Round[number,0.001];

	(* Before passing to ImageAdjustment resolve some of the general options *)
	partiallyResolvedOptions=ReplaceRule[
		expandedOptions,
		{
			ImageSelection->resolvedImageSelection,
			Images->resolvedImages,
			CellType->resolvedCellType,
			CultureAdhesion->resolvedCultureAdhesion,
			ImageScale->resolvedImageScale,
			Hemocytometer->resolvedHemocytometer,
			GridPattern->resolvedGridPattern,
			HemocytometerSquarePosition->resolvedHemocytometerSquarePosition,
			MeasureConfluency->resolvedMeasureConfluency,
			MeasureCellViability->resolvedMeasureCellViability,
			CellViabilityThreshold->resolvedCellViabilityThreshold,
			IntensityThreshold->myRound@resolvedIntensityThreshold,
			AreaThreshold->myRound@resolvedAreaThreshold,
			MinComponentRadius->myRound@resolvedMinComponentRadius,
			MaxComponentRadius->myRound@resolvedMaxComponentRadius,
			MinCellRadius->myRound@resolvedMinCellRadius,
			MaxCellRadius->myRound@resolvedMaxCellRadius,
			TargetUnits->resolvedTargetUnits
		}
	];
	(** Resolve ImageAdjustment **)

	(* Return with failed if any of the error messages are triggered within the resolvedImageAdjustment function *)
	{resolvedImageAdjustment,imageAdjustmentTests}=If[testsQ,
		resolveImageAdjustmentPrimitives[myInputs,referenceImageObjects,partiallyResolvedOptions,Output->{Result,Tests}],
		{resolveImageAdjustmentPrimitives[myInputs,referenceImageObjects,partiallyResolvedOptions,Output->Result],{}}
	];


	(* Update ImageAdjustment for ImageSegmentation *)
	updatedPartiallyResolvedOptions=ReplaceRule[
		partiallyResolvedOptions,
		{
			ImageAdjustment->resolvedImageAdjustment
		}
	];

	(** Resolve ImageSegmentation **)

	(* Return with failed if any of the error messages are triggered within the resolvedImageSegmentation function *)
	{resolvedImageSegmentation,imageSegmentationTests}=If[testsQ,
		resolveImageSegmentationPrimitives[myInputs,referenceImageObjects,updatedPartiallyResolvedOptions,Output->{Result,Tests}],
		{resolveImageSegmentationPrimitives[myInputs,referenceImageObjects,updatedPartiallyResolvedOptions,Output->Result],{}}
	];

	(* Throwing error message if SelectComponents is not specified *)
	selectComponentsAvailableTest=If[ContainsAny[Flatten@referenceImageObjects,{Null}],
		{},
		MapThread[
			Function[{myInput,inputReferenceImages,inputIntensityThreshold,inputAreaThreshold,inputMinComponentRadius,inputMaxComponentRadius,inputImageSegmentation},
				(* Mapping over the images of each input *)
				MapThread[
					Function[{imageIndex,imageIntensityThreshold,imageAreaThreshold,imageMinComponentRadius,imageMaxComponentRadius,imageImageSegmentation},
						If[
							And[
								Or@@(!MatchQ[#,Automatic]&/@{imageIntensityThreshold,imageAreaThreshold,imageMinComponentRadius,imageMaxComponentRadius}),
								!MemberQ[Head[#]&/@imageImageSegmentation,SelectComponents]
							],
							(* Throw a message indicating for which input we failed *)
							If[!testsQ,Message[Warning::SelectComponentsNotSpecified,myInput,imageIndex]];
							Test["The SelectComponents primitive is specified in the ImageSegmentation if at least one of IntensityThreshold, AreaThreshold, MinComponentRadius, MaxComponentRadius is specified.", True, False],
							Test["The SelectComponents primitive is specified in the ImageSegmentation if at least one of IntensityThreshold, AreaThreshold, MinComponentRadius, MaxComponentRadius is specified.", True, True]
						]
					],
					{Range[Length[inputReferenceImages]],inputIntensityThreshold,inputAreaThreshold,inputMinComponentRadius,inputMaxComponentRadius,inputImageSegmentation}
				]
			],
			{myInputs,referenceImages,intensityThreshold,areaThreshold,minComponentRadius,maxComponentRadius,resolvedImageSegmentation}
		]
	];

	(** Resolve PropertyMeasurement **)

	(* If the image is associated with the hemocytometer, what is the property measurement *)
	propertyMeasurement=Lookup[expandedOptions,PropertyMeasurement];

	resolvedPropertyMeasurement=MapThread[
		Function[{myInput,inputPropertyMeasurement},
			MapThread[
				Switch[#1,
					(* These are requested by default *)
					Automatic,
						{Area,Circularity,EquivalentDiskRadius,Centroid,ImageIntensity},
					All,
						List@@ComponentPropertiesP,
					_,
						DeleteDuplicates[
							Join[
								{Area,Circularity,EquivalentDiskRadius,Centroid,ImageIntensity},
								ToList@#1
							]
						]
				]&,
				{inputPropertyMeasurement}
			]
		],
		{myInputs,propertyMeasurement}
	];

	(* Find the resolved option from the expandedOptions *)
	resolvedOptions = ReplaceAll[
		ReplaceRule[
			partiallyResolvedOptions,
			{
				Output->Lookup[expandedOptions,Output],
				Upload->Lookup[expandedOptions,Upload],
				(* The conversion to bypass collapsedOptions *)
				ImageAdjustment->Replace[resolvedImageAdjustment,{{{}..}..} :> {} ],
				ImageSegmentation->Replace[resolvedImageSegmentation,{{{}..}..} :> {}],
				PropertyMeasurement->resolvedPropertyMeasurement
			}
		],
		{
			((ManualCoordinates->{{{}..}..}) :> (ManualCoordinates->{}))
		}
	];

	(* Return the requested values *)
	(* Construct the Tests output (Null if Tests weren't requested) *)
	testRule=Tests->{
		pooledOptionsLengthTest,
		imageAdjustmentTests,
		imageSegmentationTests,
		methodTest,
		selectComponentsAvailableTest
	};

	(* Gather our resolved options. *)
	resultRule=Result->If[MemberQ[ToList@output,Result],
    resolvedOptions,
    Null
  ];

	(* Return our output. *)
	output/.{testRule,resultRule}
];


resolveAnalyzeCellCountOptions[
  myInputs:{ObjectP[microscopeInputRawObjectTypes]..},
  myAnalyzeOptions_List,
	mySafeOptions_List,
	definitionNumber_Integer,
  myOptions:OptionsPattern[resolveAnalyzeCellCountOptions]
]:=Module[
	{
		objects,expandedOptions,optionDefinition,revisedExpandedOptions,cache,listedInput,output,imageLinks,images,resolvedOptions,collapsedOptions,testRule,resultRule,
		referenceImageLinks,referenceImages,updatedCollapsedOptions,testsQ,
		(* hemocytometer *)
		hemocytometer,resolvedHemocytometer,hemocytometerSquarePosition,resolvedHemocytometerSquarePosition,gridPattern,
		resolvedGridPattern,
		(* confluency *)
		measureConfluency,resolvedMeasureConfluency,
		(* viability *)
		measureCellViability,resolvedMeasureCellViability,cellViabilityThresholds,resolvedCellViabilityThreshold,
		(* other parameters *)
		minCellRadii,maxCellRadii,resolvedMinComponentRadius,resolvedMaxComponentRadius,areaThresholds,resolvedAreaThreshold,
		intensityThresholds,resolvedIntensityThreshold,imageScale,resolvedImageScale,areaThresholdAcceptableUnitTest,
		minRadiusUnitTest,maxRadiusUnitTest,targetUnits,resolvedTargetUnits,acceptableTargetUnitsTest,resolvedCultureAdhesion,
		cultureAdhesion,resolvedCellType,cellType,minCellRadius,maxCellRadius,resolvedMinCellRadius,resolvedMaxCellRadius,
		method,methodTest,myRound,
		(* resolve primitive *)
		resolvedImageAdjustment,imageAdjustmentTests,resolvedImageSegmentation,imageSegmentationTests,
		resolvedPropertyMeasurement,resolvedImageSelection,imageSelectionTests,resolvedImages,imagesTests,
		updatedPartiallyResolvedOptions,selectComponentsAvailableTest,propertyMeasurement,partiallyResolvedOptions
	},

	(* See if we're gathering tests. *)
	testsQ=MemberQ[ToList[Lookup[{myOptions},Output,{}]],Tests];

	(* Lookup our supplied cache. *)
	cache = Lookup[{myOptions},Cache,{}];

	(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
	{objects,expandedOptions} = ExpandIndexMatchedInputs[AnalyzeCellCount,{myInputs},mySafeOptions,definitionNumber,Messages->False];
	
	(* Get the option definition of the function *)
	optionDefinition = OptionDefinition[AnalyzeCellCount];
	
	(* In the case of being passed raw data through EmeraldCloudFiles, we know there is only one image per input, therefore we can remove a level of index matching from our options *)
	revisedExpandedOptions = Function[{optionRule},
		Module[{optionSymbol,optionValue,nestedQ},
			(* Split the option into symbol and value *)
			optionSymbol = First[optionRule];
			optionValue = Last[optionRule];
			
			(* Determine whether the option is nested index matching or not *)
			nestedQ = Lookup[FirstCase[optionDefinition, KeyValuePattern[{"OptionSymbol" -> optionSymbol}]], "NestedIndexMatching"];
			
			(* If the option is nested index matching, take the first of each element. Otherwise leave it alone *)
			If[nestedQ,
				optionSymbol -> First/@optionValue,
				optionSymbol -> optionValue
			]
		]
	]/@expandedOptions;

	output=Lookup[{myOptions},Output];

	(* Obtain all the microscope images in a list for each image channel *)
	{referenceImageLinks,referenceImages} = getAllMicroscopeImages[myInputs,Cache->cache];

	(** Resolve CellType **)

	cellType=Lookup[revisedExpandedOptions,CellType];

	(* The resolved hemocytometer field which indicates whether the image is aquired from a hemocytometer *)
	resolvedCellType=MapThread[
			(* For data object we take this information from the data object *)
		Function[{myInput,inputCellType},
			Module[
				{},

				If[MatchQ[inputCellType,Automatic],
					Null,
					inputCellType
				]

			]
		],
		{myInputs,cellType}
	];

	(** Resolve CultureType **)

	cultureAdhesion=Lookup[revisedExpandedOptions,CultureAdhesion];

	(* The resolved hemocytometer field which indicates whether the image is aquired from a hemocytometer *)
	resolvedCultureAdhesion=MapThread[
			(* For data object we take this information from the data object *)
		Function[{myInput,inputCultureAdhesion},
			Module[
				{cellModel,cultureAdhesionFromCellModel},

				If[MatchQ[inputCultureAdhesion,Automatic],
					Null,
					inputCultureAdhesion
				]

			]
		],
		{myInputs,cultureAdhesion}
	];

	(** Resolve ImageScale **)

	(* The scale of the image in x and y directions *)
	imageScale=Lookup[revisedExpandedOptions,ImageScale];

	(* The resolved imagescale field which indicates the scale of the image in x and y directions *)
	resolvedImageScale=MapThread[
			(* For data object we take this information from the data object *)
		Function[{myInput,inputImageScale},
			(* Mapping over all images of an input *)
			If[MatchQ[inputImageScale,Automatic],
				(* Check the data object and see if the container is a hemocytometer *)
				Null,
				inputImageScale
			]
		],
		{myInputs,imageScale}
	];

	(** Resolve Hemocytometer **)

	(* Whether the image is associated with the hemocytometer *)
	hemocytometer=Lookup[revisedExpandedOptions,Hemocytometer];

	(* The resolved hemocytometer field which indicates whether the image is aquired from a hemocytometer *)
	resolvedHemocytometer=MapThread[
		Switch[#1,
			(* For raw images, only set the hemocytometer if we are explicitly said so *)
			ObjectP[Object[EmeraldCloudFile]],
				If[MatchQ[#2,Automatic],
					False,
					#2
				]
		]&,
		{myInputs,hemocytometer}
	];

	(* Whether the image is associated with the hemocytometer *)
	method=Lookup[revisedExpandedOptions,Method];

	(* Throwing error message if ImageScale is not specified *)
	methodTest=MapThread[
		Function[{myInput,inputMethod,inputHemocytometer},
			If[
				And[
					!inputHemocytometer,
					MatchQ[inputMethod,Manual|Hybrid]
				],
				(* Throw a message indicating for which input we failed *)
				If[!testsQ,Message[Error::InvalidMethod,myInput];Message[Error::InvalidOption,myInput]];
				Test["The manual or hybrid method is chosen for a hemocytometer image.", True, False],
				Test["The manual or hybrid method is chosen for a hemocytometer image.", True, True]
			]
		],
		{myInputs,method,resolvedHemocytometer}
	];

	(* If the image is associated with the hemocytometer, what is the grid pattern *)
	gridPattern=Lookup[revisedExpandedOptions,GridPattern];

	(* The resolved hemocytometerSquarePosition field which indicates the position of the square that contains our region of interest *)
	resolvedGridPattern=MapThread[
		Switch[#1,
			ObjectP[Object[EmeraldCloudFile]],
				Which[
					MatchQ[#2,True] && MatchQ[#3,Automatic],
						Neubauer,
					MatchQ[#2,True] && !MatchQ[#3,Automatic],
						#3,
					True,
						Null
				]
		]&,
		{myInputs,resolvedHemocytometer,gridPattern}
	];

	(* If the image is associated with the hemocytometer, what is the square position *)
	hemocytometerSquarePosition=Lookup[revisedExpandedOptions,HemocytometerSquarePosition];

	(* The resolved hemocytometerSquarePosition field which indicates the position of the square that contains our region of interest *)
	resolvedHemocytometerSquarePosition=Replace[
		MapThread[
			Switch[#1,
				ObjectP[Object[EmeraldCloudFile]],
					Which[
						MatchQ[#2,True] && MatchQ[#3,Automatic|All],
							All,
						MatchQ[#2,True] && MatchQ[#4,Manual|Hybrid] && !MatchQ[#1,Automatic|All],
							(
								Message[Warning::UnusedSquarePosition,#1];
								All
							),
						MatchQ[#2,True] && !MatchQ[#3,Automatic|All],
							#3,
						True,
							Null
					]
			]&,
			{myInputs,resolvedHemocytometer,hemocytometerSquarePosition,method}
		],
		({Null..} :> Null)
	];

	(** Resolve Confluency **)

	(* Whether the image is associated with the confluency measurement *)
	measureConfluency=Lookup[revisedExpandedOptions,MeasureConfluency];

	(* The resolved measureConfluency field which indicates whether the image is aquired for confluency measurement *)
	resolvedMeasureConfluency=MapThread[
		Switch[#1,
			(* For raw images, only set the measureConfluency if we are explicitly said so *)
			ObjectP[Object[EmeraldCloudFile]],
				Which[
					MatchQ[#2,Automatic],
						False,
					(* If Hemocytometer is True, MeasureConfluency can't be True, they are different algorithms *)
					(#2 && #3),
						(
							Message[Warning::ConflictingAlgorithms,Hemocytometer,MeasureConfluency,#1];
							False
						),
					True,
						#2
				]
		]&,
		{myInputs,measureConfluency,resolvedHemocytometer}
	];

	(** Resolve Viability **)

	(* Whether the image is associated with the viability measurement *)
	measureCellViability=Lookup[revisedExpandedOptions,MeasureCellViability];

	(* The resolved measureConfluency field which indicates whether the image is aquired for confluency measurement *)
	resolvedMeasureCellViability=MapThread[
		Switch[#1,
			(* For raw images, only set the measureConfluency if we are explicitly said so *)
			ObjectP[Object[EmeraldCloudFile]],
				Which[
					MatchQ[#2,Automatic],
						False,
					(* If Hemocytometer is True, MeasureCellViability can't be True, they are different algorithms *)
					(#2 && #3),
						(
							Message[Warning::ConflictingAlgorithms,Hemocytometer,MeasureCellViability,#1];
							False
						),
					(* If MeasureConfluency is True, MeasureCellViability can't be True, they are different algorithms *)
					(#2 && #4),
						(
							Message[Warning::ConflictingAlgorithms,MeasureConfluency,MeasureCellViability,#1];
							False
						),
					True,
						#2
				]
		]&,
		{myInputs,measureCellViability,resolvedHemocytometer,resolvedMeasureConfluency}
	];

	(** Resolve CellViabilityThreshold **)

	cellViabilityThresholds=Lookup[revisedExpandedOptions,CellViabilityThreshold];

	resolvedCellViabilityThreshold=MapThread[
		Function[{myInput,inputReferenceImages,inputCellViabilityThreshold},
			Which[
				(* Automatic resolves to 0.5 *)
				MatchQ[inputCellViabilityThreshold,Automatic],
					0.5,
				!MatchQ[inputCellViabilityThreshold,Automatic],
					inputCellViabilityThreshold
			]
		],
		{myInputs,referenceImages,cellViabilityThresholds}
	];

	(** Resolve IntensityThreshold **)

	intensityThresholds=Lookup[revisedExpandedOptions,IntensityThreshold];

	resolvedIntensityThreshold=MapThread[
		Function[{myInput,inputReferenceImages,inputIntensityThreshold},
			Which[
				(* Automatic resolves to 0.1 *)
				MatchQ[inputIntensityThreshold,Automatic],
					0.01,
				!MatchQ[inputIntensityThreshold,Automatic],
					inputIntensityThreshold
			]
		],
		{myInputs,referenceImages,intensityThresholds}
	];

	(** Resolve AreaThreshold **)

	areaThresholds=Lookup[revisedExpandedOptions,AreaThreshold];

	resolvedAreaThreshold=MapThread[
		Function[{myInput,referenceImage,areaThreshold,myHemocytometer},
			Which[
				(* Automatic resolves to 2.5% of image dimension along with X axis *)
				MatchQ[areaThreshold,Automatic] && myHemocytometer,
					10 Pixel^2,
				(* Automatic resolves to 0.5% of image dimension along with X axis *)
				MatchQ[areaThreshold,Automatic],
					(Times@@(ImageDimensions[referenceImage]))*0.000005 Pixel^2,
				True,
					areaThreshold
			]
		],
		{myInputs,referenceImages,areaThresholds,resolvedHemocytometer}
	];

	(* Throwing error message if ImageScale is not specified *)
	areaThresholdAcceptableUnitTest=MapThread[
		Function[{myInput,inputImageScale,inputAreaThreshold},
			If[
				And[
					MatchQ[inputImageScale,Null],
					MatchQ[inputAreaThreshold,UnitsP[Micrometer^2]]
				],
				(* Throw a message indicating for which input we failed *)
				If[!testsQ,Message[Error::ImageScaleNotAvailable,myInput,AreaThreshold];Message[Error::InvalidOption,myInput]];
				Test["The area threshold with length unit is acceptable since the ImageScale is available.", True, False],
				Test["The area threshold with length unit is acceptable since the ImageScale is available.", True, True]
			]
		],
		{myInputs,resolvedImageScale,resolvedAreaThreshold}
	];

	(** Resolve MinComponentRadius **)

	minCellRadii=Lookup[revisedExpandedOptions,MinComponentRadius];

	resolvedMinComponentRadius=MapThread[
		Function[{myInput,referenceImage,inputMinComponentRadius,myHemocytometer},
			Which[
				(* Automatic for hemocytometer resolves to 1 of image dimension along with X axis *)
				MatchQ[inputMinComponentRadius,Automatic] && myHemocytometer,
					1 Pixel,
				(* Automatic resolves to 1% of image dimension along with X axis *)
				MatchQ[inputMinComponentRadius,Automatic],
					ImageDimensions[referenceImage][[1]]*0.001 Pixel,

				True,
					inputMinComponentRadius
			]
		],
		{myInputs,referenceImages,minCellRadii,resolvedHemocytometer}
	];

	(* Throwing error message if ImageScale is not specified *)
	minRadiusUnitTest=MapThread[
		Function[{myInput,inputImageScale,inputMinComponentRadius},
			If[
				And[
					MatchQ[inputImageScale,Null],
					MatchQ[inputMinComponentRadius,UnitsP[Micrometer]]
				],
				(* Throw a message indicating for which input we failed *)
				If[!testsQ,Message[Warning::ImageScaleNotAvailable,myInput,MinComponentRadius];Message[Error::InvalidOption,myInput]];
				Test["The minimum radius with length unit is acceptable since the ImageScale is available.", True, False],
				Test["The minimum radius with length unit is acceptable since the ImageScale is available.", True, True]
			]
		],
		{myInputs,resolvedImageScale,resolvedMinComponentRadius}
	];

	(** Resolve MaxComponentRadius **)

	maxCellRadii=Lookup[revisedExpandedOptions,MaxComponentRadius];

	resolvedMaxComponentRadius=MapThread[
		Function[{myInput,referenceImage,inputMaxComponentRadius,myHemocytometer,inputMinComponentRadius},
			Which[
				(* Automatic for hemocytometer resolves to 1 of image dimension along with X axis *)
				MatchQ[inputMaxComponentRadius,Automatic] && myHemocytometer,
					9 Pixel,

				(* Automatic resolves to 2.5% of image dimension along with X axis *)
				MatchQ[inputMaxComponentRadius,Automatic],
					ImageDimensions[referenceImage][[1]]*0.025 Pixel,

				(* Throw a warning and set the default max radius *)
				MatchQ[Units[inputMaxComponentRadius],Units[inputMinComponentRadius]] && inputMaxComponentRadius < inputMinComponentRadius,
					(
						Message[Warning::ConflictingComponentRadiusOptions, myInput, 1, inputMinComponentRadius, inputMaxComponentRadius];
						9 Pixel
					),

				True,
					inputMaxComponentRadius
			]
		],
		{myInputs,referenceImages,maxCellRadii,resolvedHemocytometer,resolvedMinComponentRadius}
	];

	(* Throwing error message if ImageScale is not specified *)
	maxRadiusUnitTest=MapThread[
		Function[{myInput,inputImageScale,inputMaxComponentRadius},
			If[
				And[
					MatchQ[inputImageScale,Null],
					MatchQ[inputMaxComponentRadius,UnitsP[Micrometer]]
				],
				(* Throw a message indicating for which input we failed *)
				If[!testsQ,Message[Error::ImageScaleNotAvailable,myInput,MaxComponentRadius];Message[Error::InvalidOption,myInput]];
				Test["The maximum radius with length unit is acceptable since the ImageScale is available.", True, False],
				Test["The maximum radius with length unit is acceptable since the ImageScale is available.", True, True]
			]
		],
		{myInputs,resolvedImageScale,resolvedMaxComponentRadius}
	];

	(** Resolve MinCellRadius/MaxCellRadius **)

	{minCellRadius,maxCellRadius}=Lookup[revisedExpandedOptions,{MinCellRadius,MaxCellRadius}];

	{resolvedMinCellRadius, resolvedMaxCellRadius} = Transpose@MapThread[
		Function[{myInput,inputReferenceImages,inputMinCellRadius,inputMaxCellRadius},
			resolveAnalyzeCellCountMinMaxRadius[10, {inputMinCellRadius, inputMaxCellRadius}]
		],
		{myInputs,referenceImages,minCellRadius,maxCellRadius}
	];

	(** Resolve TargetUnits **)

	targetUnits=Lookup[revisedExpandedOptions,TargetUnits];

	resolvedTargetUnits=Which[
		(* Automatic resolves to a specific combination to show pixel as the primary and micrometer as the secondary units *)
		MatchQ[targetUnits,Automatic],
			{{Pixel,Pixel},{Pixel,Pixel}},

		True,
			targetUnits
	];

	(* Throwing error message if ImageScale is not specified *)
	acceptableTargetUnitsTest=MapThread[
		Function[{myInput,inputImageScale},
			If[
				And[
					MatchQ[inputImageScale,Null],
					Or @@ (MatchQ[#,UnitsP[Micrometer]] & /@ (ToList@(Flatten@resolvedTargetUnits)))
				],
				(* Throw a message indicating for which input we failed *)
				If[!testsQ,Message[Error::ImageScaleNotAvailable,myInput,TargetUnits];Message[Error::InvalidOption,myInput]];
				Test["The target unit with length unit is acceptable since the ImageScale is available.", True, False],
				Test["The target unit with length unit is acceptable since the ImageScale is available.", True, True]
			]
		],
		{myInputs,resolvedImageScale}
	];

	(* Take the first three significant digits *)
	myRound[number_]:=Round[number,0.001];

	(* Before passing to ImageAdjustment resolve some of the general options *)
	partiallyResolvedOptions=ReplaceRule[
		revisedExpandedOptions,
		{
			ImageSelection->Null,
			Images->Null,
			CellType->resolvedCellType,
			CultureAdhesion->resolvedCultureAdhesion,
			ImageScale->resolvedImageScale,
			Hemocytometer->resolvedHemocytometer,
			GridPattern->resolvedGridPattern,
			HemocytometerSquarePosition->resolvedHemocytometerSquarePosition,
			MeasureConfluency->resolvedMeasureConfluency,
			MeasureCellViability->resolvedMeasureCellViability,
			CellViabilityThreshold->resolvedCellViabilityThreshold,
			IntensityThreshold->myRound@resolvedIntensityThreshold,
			AreaThreshold->myRound@resolvedAreaThreshold,
			MinComponentRadius->myRound@resolvedMinComponentRadius,
			MaxComponentRadius->myRound@resolvedMaxComponentRadius,
			MinCellRadius->myRound@resolvedMinCellRadius,
			MaxCellRadius->myRound@resolvedMaxCellRadius,
			TargetUnits->resolvedTargetUnits
		}
	];
	(** Resolve ImageAdjustment **)

	(* Return with failed if any of the error messages are triggered within the resolvedImageAdjustment function *)
	{resolvedImageAdjustment,imageAdjustmentTests}=If[testsQ,
		resolveImageAdjustmentPrimitives[myInputs,partiallyResolvedOptions,Output->{Result,Tests}],
		{resolveImageAdjustmentPrimitives[myInputs,partiallyResolvedOptions,Output->Result],{}}
	];

	(* Update ImageAdjustment for ImageSegmentation *)
	updatedPartiallyResolvedOptions=ReplaceRule[
		partiallyResolvedOptions,
		{
			ImageAdjustment->resolvedImageAdjustment
		}
	];

	(** Resolve ImageSegmentation **)

	(* Return with failed if any of the error messages are triggered within the resolvedImageSegmentation function *)
	{resolvedImageSegmentation,imageSegmentationTests}=If[testsQ,
		resolveImageSegmentationPrimitives[myInputs,updatedPartiallyResolvedOptions,Output->{Result,Tests}],
		{resolveImageSegmentationPrimitives[myInputs,updatedPartiallyResolvedOptions,Output->Result],{}}
	];

	(* Throwing error message if SelectComponents is not specified *)
	selectComponentsAvailableTest=MapThread[
		Function[{myInput,inputIntensityThreshold,inputAreaThreshold,inputMinComponentRadius,inputMaxComponentRadius,inputImageSegmentation},
			If[
				And[
					Or@@(!MatchQ[#,Automatic]&/@{inputIntensityThreshold,inputAreaThreshold,inputMinComponentRadius,inputMaxComponentRadius}),
					!MemberQ[Head[#]&/@inputImageSegmentation,SelectComponents]
				],
				(* Throw a message indicating for which input we failed *)
				If[!testsQ,Message[Warning::SelectComponentsNotSpecified,myInput,1]];
				Test["The SelectComponents primitive is specified in the ImageSegmentation if at least one of IntensityThreshold, AreaThreshold, MinComponentRadius, MaxComponentRadius is specified.", True, False],
				Test["The SelectComponents primitive is specified in the ImageSegmentation if at least one of IntensityThreshold, AreaThreshold, MinComponentRadius, MaxComponentRadius is specified.", True, True]
			]
		],
		{myInputs,intensityThresholds,areaThresholds,minCellRadii,maxCellRadii,resolvedImageSegmentation}
	];

	(** Resolve PropertyMeasurement **)

	(* If the image is associated with the hemocytometer, what is the property measurement *)
	propertyMeasurement=Lookup[revisedExpandedOptions,PropertyMeasurement];

	resolvedPropertyMeasurement=MapThread[
		Function[{myInput,inputPropertyMeasurement},
			Switch[inputPropertyMeasurement,
				(* These are requested by default *)
				Automatic,
					{Area,Circularity,EquivalentDiskRadius,Centroid,ImageIntensity},
				All,
					List@@ComponentPropertiesP,
				_,
					DeleteDuplicates[
						Join[
							{Area,Circularity,EquivalentDiskRadius,Centroid,ImageIntensity},
							ToList@inputPropertyMeasurement
						]
					]
			]
		],
		{myInputs,propertyMeasurement}
	];

	(* Find the resolved option from the revisedExpandedOptions *)
	resolvedOptions = ReplaceAll[
		ReplaceRule[
			partiallyResolvedOptions,
			{
				Output->Lookup[revisedExpandedOptions,Output],
				Upload->Lookup[revisedExpandedOptions,Upload],
				(* The conversion to bypass collapsedOptions *)
				ImageAdjustment->Replace[resolvedImageAdjustment,{{}..} :> {}],
				ImageSegmentation->Replace[resolvedImageSegmentation,{{}..} :> {}],
				PropertyMeasurement->resolvedPropertyMeasurement,
				IndexMatchingAnchor->1
			}
		],
		{
			(ManualCoordinates->{{}..}) :> (ManualCoordinates->{})
		}
	];

	(* Convert expanded options back to singletons whenever possible to display clean values to the user (e.g. OptionName\[Rule]A, not OptionName\[Rule]{A,A,A,A,...})*)
	collapsedOptions=CollapseIndexMatchedOptions[AnalyzeCellCount,resolvedOptions,Messages->False];

	(* CollapseOptions chanes the {x,x} value to a single digit which violates it's pattern and is incorrect. we should retain it back to normal *)
	updatedCollapsedOptions=ReplaceAll[collapsedOptions,
		{
			(HemocytometerSquarePosition->position_Integer) :> (HemocytometerSquarePosition->{position,position}),
			(ImageScale->scale:UnitsP[Micrometer/Pixel]) :> (ImageScale->{scale,scale}),
			(* In case of empty list we retain the listedness *)
			(ImageAdjustment->{}) :> (ImageAdjustment->ConstantArray[{},Length[myInputs]]),
			(ImageSegmentation->{}) :> (ImageSegmentation->ConstantArray[{},Length[myInputs]]),
			(* If ImageAdjustment was turned into a singlet, return as triple listed listed the way we expect in the later steps *)
			(ImageAdjustment->head_Symbol[assoc_Association]) :> (ImageAdjustment->ConstantArray[{head[assoc]},Length[myInputs]]),
			(ImageSegmentation->head_Symbol[assoc_Association]) :> (ImageSegmentation->ConstantArray[{head[assoc]},Length[myInputs]]),
			(* In case of the manual coordinates, we need to keep the nested empty lists *)
			(ManualCoordinates->{}) :> (ManualCoordinates->ConstantArray[{},Length[myInputs]]),
			(* Collapse mistakenly assumes that a pair of numbers is a scalar *)
			(ManualCoordinates->scalar_?NumericQ) :> FirstCase[resolvedOptions,HoldPattern[ManualCoordinates->_]]
		}
	];

	(* Return the requested values *)
	(* Construct the Tests output (Null if Tests weren't requested) *)
	testRule=Tests->{
		imageAdjustmentTests,
		imageSegmentationTests,
		methodTest,
		selectComponentsAvailableTest
	};

	(* Gather our resolved options. *)
	resultRule=Result->If[MemberQ[ToList@output,Result],
    updatedCollapsedOptions,
    Null
  ];

	(* Return our output. *)
	output/.{testRule,resultRule}
];

(* ::Subsubsection::Closed:: *)
(*resolveAnalyzeCellCountMinMaxRadius*)

resolveAnalyzeCellCountMinMaxRadius[cellSize_, {valMin: Automatic, valMax: Automatic}] := {3 Micrometer, 10 Micrometer};
resolveAnalyzeCellCountMinMaxRadius[cellSize_, {valMin_, valMax: Automatic}] := {valMin, 10 Micrometer};
resolveAnalyzeCellCountMinMaxRadius[cellSize_, {valMin: Automatic, valMax_}] := {3 Micrometer, valMax};
resolveAnalyzeCellCountMinMaxRadius[cellSize_, {valMin_, valMax_}] := If[
	valMin>valMax,
	(
		Message[Warning::ConflictingCellRadiusOptions, valMin, valMax];
		{3 Micrometer, 10 Micrometer}
	),
	{valMin,valMax}
];

(* -------------------------------------- *)
(* --- Running Image Processing Steps --- *)
(* -------------------------------------- *)

(* ::Subsubsection:: *)
(*runImageProcessingSteps*)

DefineOptions[runImageProcessingSteps,
	Options:>{
		CacheOption
	}
];

(* Helper function to run the main image processing steps and format the analysis packet *)
runImageProcessingSteps[
	myInputs:{ObjectP[microscopeInputDataObjectTypes]..},
	unresolvedOptions:{(_Rule|_RuleDelayed)...},
	resolvedOptions:{(_Rule|_RuleDelayed)..}, (* NOTE: These resolved options are expected to be expanded to the nested level *)
	definitionNumber_Integer,
	myDilutionFactor_,
	mySampleVolume_,
	myOptions:OptionsPattern[runImageProcessingSteps]
]:=Module[
	{
		referenceImageObjects,referenceImages,objects,expandedOptions,allMapThreadedOptions,adjustedImages,highlightedCells,
		adjustedImagesCloudFiles,highlightedCellsCloudFiles,propertyMeasurementPackets,packetMainInformation,packetCategorizedProperties,
		cache,images,imageLookupKeys,packetImageLookup,referenceImageScaleX,referenceImageScaleY,
		imageScale,imageScaleX,objectiveMagnification,method
	},

	(* Lookup our supplied cache. *)
	cache = Lookup[{myOptions},Cache,{}];

	(* The resolved value for Images field *)
	images=Lookup[resolvedOptions,Images];

	(* Obtain all the microscope images *)
	{referenceImageObjects,referenceImages,referenceImageScaleX,referenceImageScaleY,objectiveMagnification} = getAllMicroscopeImages[myInputs,images,Cache->cache];

	(* Expand index matched options to lists that match the specified input length *)
	{objects,expandedOptions} = ExpandIndexMatchedInputs[AnalyzeCellCount,{myInputs},resolvedOptions,definitionNumber,Messages->False];

	(* Take the image scale from the resolvedOptions - expand it if it is collapsed - take only the x scale *)
	imageScale=Lookup[expandedOptions,ImageScale];

	(* Take the image scale x for passing to the PlotImage *)
	imageScaleX=If[!MatchQ[imageScale,{{Null..}..}],
		imageScale[[All,All,1]],
		(* Identity conversion if we don't have the image scale *)
		ReplaceAll[imageScale,Null :> 1]
	];

	(* create a mapthread version of our options *)
	allMapThreadedOptions=OptionsHandling`Private`mapThreadOptions[AnalyzeCellCount,expandedOptions];

	(* Initialize $ImageLookup *)
	$ImageLookup=Map[
		ConstantArray[<||>,Length[#]]&,
		referenceImages
	];

	method=Lookup[resolvedOptions,Method];

	{adjustedImages,highlightedCells,propertyMeasurementPackets} = If[!MatchQ[method,Manual],
		Transpose[
			(* First mapping over input data object *)
			MapThread[
				Function[{input,inputIndex,inputReferenceImages,inputMapThreadedOptions,inputImageScaleX},

					(* Mapping over the images of each data object input *)
					Transpose@MapThread[
						Function[{referenceImage,referenceImageIndex,referenceImageScaleX},
							(* Initialize the image lookup with the reference image*)
							$TemporaryImageLookup=<|"Reference Image"->referenceImage|>;

							Module[
								{
									adjustedImage,segmentedImage,adjustmentLastLabel,segmentationLastLabel
								},

								(* Get the adjustment result and the last output label to use for segmentation *)
								{adjustedImage,adjustmentLastLabel}=adjustImage[referenceImage,referenceImageIndex,inputMapThreadedOptions];

								(* Get the segmentation result and the last output label to use for property measurement *)
								{segmentedImage,segmentationLastLabel}=segmentImage[referenceImage,referenceImageIndex,inputMapThreadedOptions,adjustmentLastLabel];

								(* Update the global image lookup *)
								$ImageLookup[[inputIndex,referenceImageIndex]]=$TemporaryImageLookup;

								{
									adjustedImage,
									segmentedImage,
									measureProperty[input,referenceImage,referenceImageIndex,inputMapThreadedOptions,segmentationLastLabel,referenceImageScaleX]
								}
							]
						],
						{inputReferenceImages,Range[Length[inputReferenceImages]],inputImageScaleX}
					]

				],
				{myInputs,Range[Length[myInputs]],referenceImages,allMapThreadedOptions,imageScaleX}
			]
		],
		{Map[ConstantArray[Null,Length[#]]&,referenceImages],Map[ConstantArray[Null,Length[#]]&,referenceImages],Map[ConstantArray[<||>,Length[#]]&,referenceImages]}
	];

	(* Uploading the adjusted and segmented images to cloud file *)
	adjustedImagesCloudFiles=If[!MatchQ[method,Manual],
		Map[
			Function[inputAdjustedImages,
				UploadCloudFile[#,Name->"Adjusted Image"]&/@inputAdjustedImages
			],
			adjustedImages
		],
		Map[ConstantArray[Null,Length[#]]&,referenceImages]
	];
	highlightedCellsCloudFiles=If[!MatchQ[method,Manual],
		Map[
			Function[inputHighlightedCells,
				UploadCloudFile[#,Name->"Highlighted Image"]&/@inputHighlightedCells
			],
			highlightedCells
		],
		Map[ConstantArray[Null,Length[#]]&,referenceImages]
	];

	(* Mapping over all inputs *)
	packetMainInformation=MapThread[
		Function[
			{
				inputReferenceImages,inputReferenceImageObjects,inputAdjustedImagesCloudFiles,inputHighlightedCellsCloudFiles,inputPropertyMeasurementPackets,inputImageScaleX,input
			},
			Join[
				<|
					Type -> Object[Analysis, CellCount],
					UnresolvedOptions -> unresolvedOptions,
					ResolvedOptions -> resolvedOptions,
					Append[Reference] -> Link[input, CellCountAnalyses],
					Replace[ReferenceImage] -> (Link[#[Object]]&/@inputReferenceImageObjects),
					Replace[AdjustedImage] -> If[!NullQ[inputAdjustedImagesCloudFiles],(Link[#[Object]]&/@inputAdjustedImagesCloudFiles)],
					Replace[HighlightedCells] -> If[!NullQ[inputHighlightedCellsCloudFiles],(Link[#[Object]]&/@inputHighlightedCellsCloudFiles)],
					Replace[ImageComponents]->If[Lookup[resolvedOptions,IncludeComponentMatrix],(Lookup[#,ImageComponents]&/@inputPropertyMeasurementPackets)],
					Replace[NumberOfComponents]->(Lookup[#,NumberOfComponents]&/@inputPropertyMeasurementPackets),
					Replace[NumberOfCells]->(Lookup[#,NumberOfCells]&/@inputPropertyMeasurementPackets),
					Replace[CellViability]->(Lookup[#,CellViability]&/@inputPropertyMeasurementPackets)
				|>,
				(* Use Null if the number of cells is zero *)
				<|
					Replace[ComponentAreaDistribution]->MapThread[If[Lookup[#1,NumberOfComponents]>0,EmpiricalDistribution[Lookup[#1,Area]] Pixel^2 * #2^2]&, {inputPropertyMeasurementPackets,inputImageScaleX}],
					Replace[ComponentArea]->MapThread[If[Lookup[#1,NumberOfComponents]>0,Lookup[#1,Area] Pixel^2 * #2^2]&, {inputPropertyMeasurementPackets,inputImageScaleX}],
					Replace[ComponentCircularityDistribution]->(If[Lookup[#,NumberOfComponents]>0,EmpiricalDistribution[Lookup[#,Circularity]]]&/@inputPropertyMeasurementPackets),
					Replace[ComponentCircularity]->(If[Lookup[#,NumberOfComponents]>0,Lookup[#,Circularity]]&/@inputPropertyMeasurementPackets),
					Replace[ComponentDiameterDistribution]->MapThread[If[Lookup[#1,NumberOfComponents]>0,2*EmpiricalDistribution[Lookup[#1,EquivalentDiskRadius]] Pixel * #2]&, {inputPropertyMeasurementPackets,inputImageScaleX}],
					Replace[ComponentDiameter]->MapThread[If[Lookup[#1,NumberOfComponents]>0,2*Lookup[#1,EquivalentDiskRadius] Pixel * #2]&, {inputPropertyMeasurementPackets,inputImageScaleX}],
					Replace[ComponentCentroid]->MapThread[If[Lookup[#1,NumberOfComponents]>0,Lookup[#1,Centroid]]&, {inputPropertyMeasurementPackets,inputImageScaleX}],
					Replace[Confluency]->MapThread[
						If[Lookup[#2,NumberOfComponents]>0,
							Total[Lookup[#2,Area]]/Apply[Times,ImageDimensions[#1]]*100 Percent
						]&,
						{inputReferenceImages,inputPropertyMeasurementPackets}
					]
				|>
			]
		],
		{
			referenceImages,referenceImageObjects,adjustedImagesCloudFiles,highlightedCellsCloudFiles,propertyMeasurementPackets,imageScaleX,myInputs
		}
	];

	(* The categorized properties are also added to the propertyMeasurementPackets *)
	packetCategorizedProperties=MapThread[
		Function[
			{
				inputReferenceImageObjects,inputPropertyMeasurementPackets
			},
			Association@@Map[
				(Replace[#]->Lookup[inputPropertyMeasurementPackets,#,Null])&,
				{
					AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse,
					ShapeMeasurements,BoundingboxProperties,TopologicalProperties,ImageIntensity
				}
			]
		],
		{
			referenceImageObjects,propertyMeasurementPackets
		}
	];

	(* Find all keys to show in the image lookup field of analyze cell count *)
	imageLookupKeys=Keys[Lookup[LookupTypeDefinition[Object[Analysis,CellCount],ImageDataLookup],Class]];

	(* Update the image lookup from the data object the updated results *)
	packetImageLookup=MapThread[
		Function[
			{
				inputImages,inputReferenceImages,inputReferenceImageObjects,inputAdjustedImagesCloudFiles,inputHighlightedCellsCloudFiles,
				inputMapThreadedOptions,inputPropertyMeasurementPackets,inputImageScaleX
			},
			(* Mapping over the images of each input *)
			<|
				Replace[ImageDataLookup]->MapThread[
					Function[
						{
							microscopeImage,referenceImage,referenceImageObject,referenceImageIndex,adjustedImageObject,
							highlightedCellsObject,propertyMeasurementPacket,imageScaleXValue
						},
						Module[
							{
								microscopeImagePrimitive,fullLookupInformation
							},

							(* All keyvalues of the MicroscopeImage primitive for this current image *)
							microscopeImagePrimitive=KeyDrop[Association@@microscopeImage,Object];

							(* The results of analysis appended to the microscope image primitive info *)
							fullLookupInformation=Join[
								microscopeImagePrimitive,
								propertyMeasurementPacket,
								<|
									(* For replacing link *)
									Objective->If[!MatchQ[Lookup[microscopeImagePrimitive,Objective],Null|All],Link[Lookup[microscopeImagePrimitive,Objective][Object]]],
									EmissionFilter->If[!MatchQ[Lookup[microscopeImagePrimitive,EmissionFilter],Null|All],Link[Lookup[microscopeImagePrimitive,EmissionFilter][Object]]],
									DichroicFilter->If[!MatchQ[Lookup[microscopeImagePrimitive,DichroicFilter],Null|All],Link[Lookup[microscopeImagePrimitive,DichroicFilter][Object]]],
									ReferenceImage -> Link[referenceImageObject[Object]],
									AdjustedImage -> Link[adjustedImageObject[Object]],
									HighlightedCells -> Link[highlightedCellsObject[Object]],
									ImageComponents->If[Lookup[propertyMeasurementPacket,NumberOfComponents]>0 && Lookup[resolvedOptions,IncludeComponentMatrix],Lookup[propertyMeasurementPacket,ImageComponents]],
									ComponentAreaDistribution->If[Lookup[propertyMeasurementPacket,NumberOfComponents]>0,EmpiricalDistribution[Lookup[propertyMeasurementPacket,Area]] Pixel^2 * imageScaleXValue^2],
									ComponentArea->If[Lookup[propertyMeasurementPacket,NumberOfComponents]>0,Lookup[propertyMeasurementPacket,Area] Pixel^2 * imageScaleXValue^2],
									ComponentCircularityDistribution->If[Lookup[propertyMeasurementPacket,NumberOfComponents]>0,EmpiricalDistribution[Lookup[propertyMeasurementPacket,Circularity]]],
									ComponentCircularity->If[Lookup[propertyMeasurementPacket,NumberOfComponents]>0,Lookup[propertyMeasurementPacket,Circularity]],
									ComponentDiameterDistribution->If[Lookup[propertyMeasurementPacket,NumberOfComponents]>0,EmpiricalDistribution[Lookup[propertyMeasurementPacket,EquivalentDiskRadius]] Pixel * imageScaleXValue],
									ComponentDiameter->If[Lookup[propertyMeasurementPacket,NumberOfComponents]>0,Lookup[propertyMeasurementPacket,EquivalentDiskRadius] Pixel * imageScaleXValue],
									ComponentCentroid->If[Lookup[propertyMeasurementPacket,NumberOfComponents]>0,Lookup[propertyMeasurementPacket,Centroid]],
									Confluency->If[Lookup[propertyMeasurementPacket,NumberOfComponents]>0,
										Total[Lookup[propertyMeasurementPacket,Area]]/Apply[Times,ImageDimensions[referenceImage]]*100 Percent
									]
								|>
							];

							Association@@Map[
								#->Lookup[fullLookupInformation,#,Null]&,
								imageLookupKeys
							]
						]
					],
					{
						inputImages,inputReferenceImages,inputReferenceImageObjects,Range[Length[inputReferenceImageObjects]],
						inputAdjustedImagesCloudFiles,inputHighlightedCellsCloudFiles,inputPropertyMeasurementPackets,inputImageScaleX
					}
				]
			|>
		],
		{
			images,referenceImages,referenceImageObjects,adjustedImagesCloudFiles,highlightedCellsCloudFiles,allMapThreadedOptions,propertyMeasurementPackets,imageScaleX
		}
	];

	(* Return the results for all data object inputs *)
	MapThread[Join[#1,#2,#3]&,{packetMainInformation,packetCategorizedProperties,packetImageLookup}]

];

(* Helper function to run the main image processing steps and format the analysis packet *)
runImageProcessingSteps[
	myInputs:{ObjectP[microscopeInputRawObjectTypes]..},
	unresolvedOptions:{(_Rule|_RuleDelayed)...},
	resolvedOptions:{(_Rule|_RuleDelayed)..},
	definitionNumber_Integer,
	myDilutionFactor_,
	mySampleVolume_,
	myOptions:OptionsPattern[runImageProcessingSteps]
]:=Module[
	{
		imageLinks,images,objects,expandedOptions,optionDefinition,revisedExpandedOptions,allMapThreadedOptions,adjustedImages,highlightedCells,
		adjustedImagesCloudFiles,highlightedCellsCloudFiles,propertyMeasurementPackets,
		packetMainInformation,packetCategorizedProperties,adjustmentLastLabels,imageScale,imageScaleX
	},

	(* Obtain all the microscope images *)
	{imageLinks,images} = getAllMicroscopeImages[myInputs];

	(* Expand index matched options to lists that match the specified input length *)
	{objects,expandedOptions} = ExpandIndexMatchedInputs[AnalyzeCellCount,{myInputs},resolvedOptions,definitionNumber,Messages->False];

	(* Get the option definition of the function *)
	optionDefinition = OptionDefinition[AnalyzeCellCount];

	(* In the case of being passed raw data through EmeraldCloudFiles, we know there is only one image per input, therefore we can remove a level of index matching from our options *)
	revisedExpandedOptions = Function[{optionRule},
		Module[{optionSymbol,optionValue,nestedQ},
			(* Split the option into symbol and value *)
			optionSymbol = First[optionRule];
			optionValue = Last[optionRule];

			(* Determine whether the option is nested index matching or not *)
			nestedQ = Lookup[FirstCase[optionDefinition, KeyValuePattern[{"OptionSymbol" -> optionSymbol}]], "NestedIndexMatching"];

			(* If the option is nested index matching, take the first of each element. Otherwise leave it alone *)
			If[nestedQ,
				optionSymbol -> First/@optionValue,
				optionSymbol -> optionValue
			]
		]
	]/@expandedOptions;

	(* Take the image scale from the resolvedOptions - expand it if it is collapsed - take only the x scale *)
	imageScale=Lookup[revisedExpandedOptions,ImageScale];

	(* Take the image scale x for passing to the PlotImage *)
	imageScaleX=If[!MatchQ[imageScale,{Null..}],
		imageScale[[All,1]],
		(* Identity conversion if we don't have the image scale *)
		ReplaceAll[imageScale,Null :> 1]
	];

	(* create a mapthread version of our options *)
	allMapThreadedOptions=OptionsHandling`Private`mapThreadOptions[AnalyzeCellCount,revisedExpandedOptions];

	(* Initialize $ImageLookup *)
	$ImageLookup=ConstantArray[<||>,Length[myInputs]];

	(* Perform image adjustment first - we might need to use adjusted image of one image in another image segmentation *)
	{adjustedImages,adjustmentLastLabels} = Transpose@MapThread[
		Function[{inputIndex,image,imageIndex,mapThreadedOptions},

			(* Initialize the image lookup with the reference image*)
			$TemporaryImageLookup=<|"Reference Image"->image|>;

			(** NOTE: passing 0 cause there are only 1 image per input **)
			Module[
				{
					adjustedImage,adjustmentLastLabel
				},

				(* Get the adjustment result and the last output label to use for segmentation *)
				{adjustedImage,adjustmentLastLabel}=adjustImage[image,0,mapThreadedOptions];

				(* Update the global image lookup *)
				$ImageLookup[[inputIndex]]=$TemporaryImageLookup;

				{adjustedImage,adjustmentLastLabel}
			]
		],
		{Range[Length[myInputs]],images,Range[Length[images]],allMapThreadedOptions}
	];

	(* Perform the image segmentation and then find all properties - we might use the result of the image adjustment for one image in other images *)
	(* We will use the last adjustment label of each input for autopolulation of the Image input field *)
	{highlightedCells,propertyMeasurementPackets} = Transpose@MapThread[
		Function[{input,inputIndex,image,imageIndex,mapThreadedOptions,adjustmentLastLabel,inputImageScaleX},

			(* Initialize the image lookup with the reference image*)
			$TemporaryImageLookup=$ImageLookup[[inputIndex]];

			(** NOTE: passing 0 cause there are only 1 image per input **)
			Module[
				{
					segmentedImage,segmentationLastLabel
				},

				(* Get the segmentation result and the last output label to use for property measurement *)
				{segmentedImage,segmentationLastLabel}=segmentImage[image,0,mapThreadedOptions,adjustmentLastLabel];

				(* Update the global image lookup *)
				$ImageLookup[[inputIndex]]=$TemporaryImageLookup;

				{
					segmentedImage,
					measureProperty[input,image,0,mapThreadedOptions,segmentationLastLabel,inputImageScaleX]
				}
			]
		],
		{myInputs,Range[Length[myInputs]],images,Range[Length[images]],allMapThreadedOptions,adjustmentLastLabels,imageScaleX}
	];

	(* Uploading the adjusted and segmented images to cloud file *)
	adjustedImagesCloudFiles=UploadCloudFile[#,Name->"Adjusted Image"]&/@adjustedImages;
	highlightedCellsCloudFiles=UploadCloudFile[#,Name->"Highlighted Cells"]&/@highlightedCells;

	(* Return a list of packets *)
	packetMainInformation=MapThread[
		Join[
			<|
				Type -> Object[Analysis, CellCount],
				UnresolvedOptions -> unresolvedOptions,
				ResolvedOptions -> resolvedOptions,
				Replace[ReferenceImage] -> Link[#2[Object]],
				Replace[AdjustedImage] -> Link[#3[Object]],
				Replace[HighlightedCells] -> Link[#4[Object]],
				Replace[ImageComponents]->If[Lookup[resolvedOptions,IncludeComponentMatrix],Lookup[#5,ImageComponents]],
				Replace[NumberOfComponents]->Lookup[#5,NumberOfComponents],
				Replace[NumberOfCells]->Lookup[#5,NumberOfCells],
				Replace[CellViability]->Lookup[#5,CellViability]
			|>,
			<|
				If[!MatchQ[Lookup[#5,NumberOfComponents],0],
					{
						Replace[Confluency]->Total[Lookup[#5,Area]]/Apply[Times,ImageDimensions[#1]]*100 Percent,
						Replace[ComponentAreaDistribution]->EmpiricalDistribution[Lookup[#5,Area]] Pixel^2 * #6^2,
						Replace[ComponentArea]->Lookup[#5,Area] Pixel^2 * #6^2,
						Replace[ComponentCircularityDistribution]->EmpiricalDistribution[Lookup[#5,Circularity]],
						Replace[ComponentCircularity]->Lookup[#5,Circularity],
						Replace[ComponentDiameterDistribution]->EmpiricalDistribution[Lookup[#5,EquivalentDiskRadius]] Pixel * #6,
						Replace[ComponentDiameter]->Lookup[#5,EquivalentDiskRadius] Pixel * #6,
						Replace[ComponentCentroid]->Lookup[#5,Centroid]
					},
					{
						Replace[Confluency]->Null,
						Replace[ComponentAreaDistribution]->Null,
						Replace[ComponentArea]->Null,
						Replace[ComponentCircularityDistribution]->Null,
						Replace[ComponentCircularity]->Null,
						Replace[ComponentDiameterDistribution]->Null,
						Replace[ComponentDiameter]->Null,
						Replace[ComponentCentroid]->Null
					}
				]
			|>
		]&,
		{
			images,imageLinks,adjustedImagesCloudFiles,highlightedCellsCloudFiles,propertyMeasurementPackets,imageScaleX
		}
	];

	(* The categorized properties are also added to the propertyMeasurementPackets *)
	packetCategorizedProperties=MapThread[
		Function[{image,categorizedProperties},
			Association@@Map[
				(Replace[#]->Lookup[categorizedProperties,#,Null])&,
				{
					AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse,
					ShapeMeasurements,BoundingboxProperties,TopologicalProperties,ImageIntensity
				}
			]
		],
		{
			images,propertyMeasurementPackets
		}
	];

	MapThread[Join[#1,#2]&,{packetMainInformation,packetCategorizedProperties}]

];


(* -------------------------- *)
(* --- Downloading Images --- *)
(* -------------------------- *)


(* ::Subsubsection:: *)
(*getAllMicroscopeImages*)

DefineOptions[getAllMicroscopeImages,
	Options:>{
		CacheOption
	}
];

(* Get all the microscope images and sort according to their capture wavelength *)
getAllMicroscopeImages[
	myInputs:{ObjectP[Object[Data, Microscope]]..},
	resolvedImages_,
	myOptions:OptionsPattern[getAllMicroscopeImages]
] := Module[
	{
		primitiveSetInformation,allPrimitiveInformation,primitiveHeads,
		listedPackets,cache,primitiveInformation,inputOptions,optionOptions
	},
	listedPackets=ToList[myPackets];

	(* Lookup information about our primitive set from our backend association. *)
  primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ImagesPrimitiveP]];
  allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
  primitiveHeads=Keys[allPrimitiveInformation];

	(* Lookup our supplied cache. *)
	cache = Lookup[{myOptions},Cache,{}];

	(* Lookup our image adjustment primitive information. *)
	primitiveInformation=Lookup[allPrimitiveInformation, MicroscopeImage];

	(* Make sure we have other options as well because they need to index match *)
	inputOptions=Lookup[primitiveInformation,InputOptions,{}];

	(* The other option keys will be our option options *)
	optionOptions=UnsortedComplement[
		ToExpression[Lookup[Lookup[primitiveInformation, OptionDefinition],"OptionName"]],
		inputOptions
	];

	Transpose[

		If[MatchQ[resolvedImages,{{}..}],

			(* Return empty for all image information if no images found *)
			ConstantArray[{{},{},{},{}},Length[myInputs]],

			(* Mapping over multiple inputs *)
			MapThread[
				Function[{myInput,images},
					Transpose@Map[
						Function[image,

							Module[{keysValues,inputOptionRules,optionOptionRules,imageSelectRules},
								(* Find all of the options with their values for this primitive *)

								keysValues=KeyValueMap[Rule[#1,#2]&,Association@@(image)];

								(* We are not gonna use the input options with Null value *)
								inputOptionRules=Select[keysValues,
									MatchQ[First[#],Alternatives@@inputOptions]&
								];

								(* All of the key values correcponding to our optionOptions *)
								optionOptionRules=Select[keysValues,
									MatchQ[First[#],Alternatives@@optionOptions]&
								];

								(* The final result of the image select *)
								imageSelectRules=MicroscopeImageSelect[Sequence@@(Values@inputOptionRules),Sequence@@(optionOptionRules)];

								Flatten[
									{
										Lookup[imageSelectRules,ImageFile,Null],
										importOrNull[Lookup[imageSelectRules,ImageFile]],
										Lookup[imageSelectRules,ImageScaleX,Null],
										Lookup[imageSelectRules,ImageScaleY,Null],
										Lookup[imageSelectRules,ObjectiveMagnification,Null]
									}
								]
							]

						],
						images
					]
				],
				{myInputs,resolvedImages}
			]
		]
	]

];

(* Get all the microscope images and sort according to their capture wavelength *)
getAllMicroscopeImages[
	myCloudFiles:{EmeraldCloudFileP..},
	myOptions:OptionsPattern[getAllMicroscopeImages]
] := Module[
	{
	},

	(* Import all clould files and send back as a list *)
	{myCloudFiles,importOrNull[myCloudFiles]}

];

(* ::Subsubsection:: *)
(*importOrNull*)


(* Helper function to import if there is at least one file if not return Null *)
importOrNull[Null] := Null;
importOrNull[myFile_] := importOrNull[myFile] = ImportCloudFile[myFile];
importOrNull[myFiles : {__}] := importOrNull[myFiles] =  Module[{},
	listedFiles = ToList[myFiles];
	ImportCloudFile /@ myFiles
];

(* ------------------------ *)
(* --- Image Adjustment --- *)
(* ------------------------ *)

(* ::Subsubsection::Closed:: *)
(* adjustImage *)


(* This helper function applies the image adjustment steps in the order specidied *)
adjustImage[image_Image,imageIndex_Integer,resolvedOptions:_?AssociationQ]:=Module[
	{
		(* basic information for all primitives *)
		primitiveSetInformation,allPrimitiveInformation,primitiveHeads,
		(* *)
		imageAdjustmentOption,functions,settings,imageAdjustmentPrimitives,allPrimitiveFunctionSets,
		primitiveIndex,outputImage,outputLabel,lastLabel,adjustmentFunctions
	},

	(* Lookup information about our primitive set from our backend association. *)
  primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ImageAdjustmentPrimitiveP]];
  allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
  primitiveHeads=Keys[allPrimitiveInformation];

	(* Finding the image adjustment in the resolved option *)
  imageAdjustmentOption=If[imageIndex>0,
		Part[Lookup[resolvedOptions,ImageAdjustment],imageIndex],
		Lookup[resolvedOptions,ImageAdjustment]
	];

  (* Finding the image adjustment in the resolved option - Convert to association for better handling *)
  imageAdjustmentPrimitives=Map[
    Apply[Association,#]&,
    ToList@imageAdjustmentOption
  ];

	(* The name of the function is obtained by just removing the primitive step symbol name *)
	adjustmentFunctions=Map[
    Head[#]&,
    ToList@imageAdjustmentOption
  ];

	(* Initialize the primitive index and the last label *)
	primitiveIndex=0;
	lastLabel="Reference Image";

	(* If there are no primitives, then return the reference as the adjusted *)
	If[MatchQ[imageAdjustmentPrimitives,{}],
		AppendTo[$TemporaryImageLookup,<|"ImageAdjustment Result"->Lookup[$TemporaryImageLookup,"Reference Image"]|>];
		Return[{Lookup[$TemporaryImageLookup,"Reference Image"],lastLabel}]
	];

	While[True,
		(* Incrementing the primitive index to keep track of them for while statement *)
		primitiveIndex++;

		{outputImage,outputLabel}=emeraldImageFunction[
			primitiveSetInformation,
			allPrimitiveInformation,
			primitiveHeads,
			imageAdjustmentPrimitives[[primitiveIndex]],
			adjustmentFunctions[[primitiveIndex]],
			lastLabel
		];

		(* Update the last label based on the output results *)
		lastLabel=outputLabel;

		If[primitiveIndex==Length[imageAdjustmentPrimitives],
			AppendTo[$TemporaryImageLookup,<|"ImageAdjustment Result"->outputImage|>];
			Return[{outputImage,lastLabel}]
		]
	]

];

(* -------------------------- *)
(* --- Image Segmentation --- *)
(* -------------------------- *)

(* ::Subsubsection::Closed:: *)
(* segmentImage *)

(* This helper function applies the image adjustment steps in the order specidied *)
segmentImage[
	image_Image,
	imageIndex_Integer,
	resolvedOptions:_?AssociationQ,
	myLastLabel_String
]:=Module[
	{
		(* basic information for all primitives *)
		primitiveSetInformation,allPrimitiveInformation,primitiveHeads,
		(* *)
		imageAdjustmentOption,functions,settings,imageAdjustmentPrimitives,allPrimitiveFunctionSets,
		primitiveIndex,outputImage,outputLabel,lastLabel,segmentationFunctions,imageSegmentationPrimitives,
		highlightedCellsFormat,imageSegmentationOption
	},

	(* Lookup information about our primitive set from our backend association. *)
  primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ImageSegmentationPrimitiveP]];
  allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
  primitiveHeads=Keys[allPrimitiveInformation];

	(* Finding the image segmentation in the resolved option *)
  imageSegmentationOption=If[imageIndex>0,
		Part[Lookup[resolvedOptions,ImageSegmentation],imageIndex],
		Lookup[resolvedOptions,ImageSegmentation]
	];

	(* How to show the output cells - with circles or colorize *)
  highlightedCellsFormat=If[imageIndex>0,
		Part[Lookup[resolvedOptions,HighlightedCellsFormat],imageIndex],
		Lookup[resolvedOptions,HighlightedCellsFormat]
	];

  (* Finding the image segmentation in the resolved option - Convert to association for better handling *)
  imageSegmentationPrimitives=Map[
    Apply[Association,#]&,
    ToList@imageSegmentationOption
  ];

	(* The name of the function is obtained by just removing the primitive step symbol name *)
	segmentationFunctions=Map[
    Head[#]&,
    ToList@imageSegmentationOption
  ];

	(* Initialize the primtive index and the last label *)
	primitiveIndex=0;
	lastLabel=myLastLabel;

	(* If there are no primitives, then return the image adjustment result as the segmented *)
	If[MatchQ[imageSegmentationPrimitives,{}],
		AppendTo[$TemporaryImageLookup,<|"ImageSegmentation Result"->Lookup[$TemporaryImageLookup,"ImageAdjustment Result"]|>];
		Return[{Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],lastLabel}]
	];

	While[True,
		(* Incrementing the primitive index to keep track of them for while statement *)
		primitiveIndex++;

		{outputImage,outputLabel}=emeraldImageFunction[
			primitiveSetInformation,
			allPrimitiveInformation,
			primitiveHeads,
			imageSegmentationPrimitives[[primitiveIndex]],
			segmentationFunctions[[primitiveIndex]],
			lastLabel
		];

		(* Update the last label based on the output results *)
		lastLabel=outputLabel;

		If[primitiveIndex==Length[imageSegmentationPrimitives],
			(* Generate the highlighted image and return to use in the analysis object *)

			highlightedImage=Which[
				MatchQ[outputImage,_Image],
					(* If the image is generated highlight the segmented region all with a single red color *)
					(* NOTE: we use rasterize to avoid higher load for many detected cells cases. *)
					(* NOTE: Image[..] is supposed to do the same but in Windows MM V10. it messes up the display for some reason *)
					Rasterize[HighlightImage[Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],{Red,outputImage}],"Image"],
				(* If the image comes with a mask matrix *)
				(MatchQ[outputImage,{_Image,_?MatrixQ}] && And@@Lookup[resolvedOptions,MeasureCellViability]),
					Module[
						{
							cellViabilityThreshold,liveCells,deadCells
						},

						(* the resolved cell viability threshold *)
						cellViabilityThreshold=First@ToList[Lookup[resolvedOptions,CellViabilityThreshold]];

						(* Find the live and dead cell index so we can distinguish them on the highlighed image *)
						liveCells=Last@SelectComponents[outputImage,(#MeanIntensity>=cellViabilityThreshold&)];
						deadCells=Last@SelectComponents[outputImage,(#MeanIntensity<cellViabilityThreshold&)];

						Rasterize[HighlightImage[Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],{Green,Image[liveCells,"Bit"],Red,Image[deadCells,"Bit"]}],"Image"]
					],
				(* If the image comes with a mask matrix *)
				MatchQ[outputImage,{_Image,_?MatrixQ}],
					Module[
						{
							intensityThreshold
						},

						(* the resolved cell viability threshold *)
						intensityThreshold=First@ToList[Lookup[resolvedOptions,IntensityThreshold]];

						(* Find the cells with intensity higher than the threshold so we can distinguish them on the highlighed image *)
						selectedComponents=Last@SelectComponents[outputImage,(#MeanIntensity>=intensityThreshold&)];

						Rasterize[HighlightImage[Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],{Red,Image[selectedComponents,"Bit"]}],"Image"]
					],
				(* The output is not an image. Determine the equivalent radius and show the circles. *)
				True,
					Module[
						{intensityThreshold,measures},

						(* the resolved cell viability threshold *)
						intensityThreshold=First@ToList[Lookup[resolvedOptions,IntensityThreshold]];

						measures=ComponentMeasurements[{Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],outputImage},{"Centroid","EquivalentDiskRadius","Label","Contours","BoundingBox","MeanIntensity"},(#MeanIntensity>=intensityThreshold&)];

						(* If colorize is requested just use that for the detected components *)
						If[!MatchQ[highlightedCellsFormat,Colorize],
							Rasterize[
								Show[
									Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],
									Switch[highlightedCellsFormat,
										Contour,
											Graphics[
												{
													Red,Thickness[0.005],#& /@ (measures[[All,2,4]])
												}
											],
										Circle,
											Graphics[
												{
													Red,Circle@@#& /@ (measures[[All,2,1;;2]])
												}
											],
										LabeledCircle,
											Graphics[
												{
													Red,Tooltip[Circle@@#,ToString[#]]& /@ (measures[[All,2,1;;2]]),
													MapThread[
														Text,
														{Range[Length[measures[[All,2,1]]]],measures[[All,2,1]]}
													]
												}
											]
									]
		  					],
								"Image"
		 					],
							Colorize[outputImage]
						]
					]
			];
			AppendTo[$TemporaryImageLookup,<|"ImageSegmentation Result"->highlightedImage|>];
			Return[{highlightedImage,lastLabel}]
		]
	]

];

(* ----------------------------- *)
(* --- Property Measurements --- *)
(* ----------------------------- *)

(* ::Subsubsection::Closed:: *)
(* measureProperty *)

(* This helper function applies the image adjustment steps in the order specidied *)
measureProperty[
	input: ObjectP[microscopeInputObjectTypes],
	image_Image,
	imageIndex_Integer,
	resolvedOptions:_?AssociationQ,
	myLastLabel_String,
	myImageScale_
]:=Module[
	{
		(* basic information for all primitives *)
		propertyMeasurementOption,segmentedResult,requestedProperties,
		propertyValues,replacedCategoryProperties,categorizedProperties,rearrangedCategorizedProperties,
		morphologicalComponents,finalSegmentedResult,numberOfLiveCells,diameterHistogram,
		intensityThreshold
	},

	(* Finding the image segmentation in the resolved option - Convert to association for better handling *)
  propertyMeasurementOption=If[!MatchQ[Lookup[resolvedOptions,PropertyMeasurement],Automatic] && imageIndex>0,
		(* We list the property in case just a single property exist *)
		Module[{propertyMeasurementBase},
			propertyMeasurementBase=Part[Lookup[resolvedOptions,PropertyMeasurement],imageIndex];
			If[!MatchQ[propertyMeasurementBase,Automatic] && Length[propertyMeasurementBase]==0,
				ToList[propertyMeasurementBase],
				propertyMeasurementBase
			]
		],
		Lookup[resolvedOptions,PropertyMeasurement]
	];

	(* Lookup what we have got in the segmentation steps *)
	segmentedResult=Lookup[$TemporaryImageLookup,myLastLabel];

	(* If a category is selected then replace it will all the properties that it is translated to *)
	replacedCategoryProperties=If[!MatchQ[propertyMeasurementOption,Automatic],
		Flatten@ReplaceAll[propertyMeasurementOption,
			MapThread[
				Rule[#1,List@@#2]&,
				{
					{
						AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse,
						ShapeMeasurements,BoundingboxProperties,TopologicalProperties,ImageIntensity
					},
					{
						ComponentPropertiesAreaP,ComponentPropertiesPerimeterP,ComponentPropertiesCentroidP,ComponentPropertiesEllipseP,
						ComponentPropertiesShapeP,ComponentPropertiesBoundingBoxP,ComponentPropertiesTopologyP,ComponentPropertiesIntensityP
					}
				}
			]
		],
		{}
	];

	(* We are replacing the symbol with the strings since mathematica is confused otherwise *)
	requestedProperties=ReplaceAll[replacedCategoryProperties,
		{
			(property_?(MatchQ[#,ComponentPropertiesP]&)) :> (SymbolName[property]),
			(properties_?(MatchQ[#,{ComponentPropertiesP..}]&)) :> ((SymbolName[#]&/@properties))
		}
	];

	(* If there are any intensity related properties requested, we need to provide the adjusted image *)
	finalSegmentedResult=Which[
		MatchQ[segmentedResult,_?MatrixQ],
			{Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],segmentedResult},
		MatchQ[segmentedResult,{_Image,_?MatrixQ}],
			{Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],Last@segmentedResult},
		True,
			segmentedResult
	];

	(* The component matrix to use for the analysis object *)
	morphologicalComponents=Which[
		MatchQ[segmentedResult,_Image],
			MorphologicalComponents[segmentedResult],
		MatchQ[segmentedResult,{_Image,_?MatrixQ}],
			MorphologicalComponents[Last@segmentedResult],
		True,
			MorphologicalComponents[segmentedResult]
	];

	intensityThreshold=First@ToList[Lookup[resolvedOptions,IntensityThreshold]];

	propertyValues=Which[
		MatchQ[finalSegmentedResult,_Image],
			ComponentMeasurements[{Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],morphologicalComponents},requestedProperties,(#MeanIntensity>=intensityThreshold&),"PropertyAssociation"],
		(* If intensity data is not requested the component matrix is sufficient *)
		MatchQ[finalSegmentedResult,{_Image,_?MatrixQ}],
			ComponentMeasurements[finalSegmentedResult,requestedProperties,(#MeanIntensity>=intensityThreshold&),"PropertyAssociation"],
		True,
			ComponentMeasurements[{Lookup[$TemporaryImageLookup,"ImageAdjustment Result"],finalSegmentedResult},(#MeanIntensity>=intensityThreshold&),requestedProperties,"PropertyAssociation"]
	];

	(* Calculate the number of live cells *)
	{
		numberOfLiveCells
	}=If[(MatchQ[finalSegmentedResult,{_Image,_?MatrixQ}] && And@@Lookup[resolvedOptions,MeasureCellViability]),
		Module[
			{
				cellViabilityThreshold
			},

			(* the resolved cell viability threshold *)
			cellViabilityThreshold=First@ToList[Lookup[resolvedOptions,CellViabilityThreshold]];

			(* Find the live and dead cell index so we can distinguish them on the highlighed image *)
			liveCells=ComponentMeasurements[finalSegmentedResult,(#MeanIntensity>=cellViabilityThreshold&),{"Area"}];
			deadCells=ComponentMeasurements[finalSegmentedResult,(#MeanIntensity<cellViabilityThreshold&),{"Area"}];

			{
				Length[liveCells]
			}

		],
		{
			Null
		}
	];

	(* Constructing the category field by mapping over all fields and finding the ones that belong to it *)
	categorizedProperties=Association@@MapThread[
		Function[{category,propertiesP},
			(* Map over number of cells and if we have *)
			category->Association@@
				Append[
					Map[
						If[MatchQ[ToExpression[#],propertiesP],
							ToExpression[#]->Lookup[propertyValues,#1,Null],
							Nothing
						]&,
						requestedProperties
					],
					Map[
						Rule[#,Null]&,
						Complement[List@@propertiesP,replacedCategoryProperties]
					]
				]
		],
		{
			{
				AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse,
				ShapeMeasurements,BoundingboxProperties,TopologicalProperties,ImageIntensity
			},
			{
				ComponentPropertiesAreaP,ComponentPropertiesPerimeterP,ComponentPropertiesCentroidP,ComponentPropertiesEllipseP,
				ComponentPropertiesShapeP,ComponentPropertiesBoundingBoxP,ComponentPropertiesTopologyP,ComponentPropertiesIntensityP
			}
		}
	];

	(* Map over the number of cells and create an association for each one of them based on categorizedProperties *)
	rearrangedCategorizedProperties=Map[
		Function[cellIndex,
			(* Map over all categories and populate them by creating cell based information like {Area->value,Centroid->value,..} as opposed to property->{All cell values} *)
			Association@@KeyValueMap[
				Function[{category,categoryAssociation},
					(* If there is a values associated with this property include it *)
					Rule[category,
						Association@@KeyValueMap[
							Rule[#1,
								If[Length[#2]>0,
									#2[[cellIndex]],
									Null
								]
							]&,
							categoryAssociation
						]
					]
				],
				categorizedProperties
			]
		],
		Range[Length[Lookup[propertyValues,"Area"]]]
	];

	Join[
		<|
			ImageComponents->morphologicalComponents,
			NumberOfComponents->Length[Lookup[propertyValues,"Area"]],
			NumberOfCells->If[Length[Lookup[propertyValues,"Area"]]>0,
				Lookup[countCellFromComponents[input,Total[Lookup[propertyValues,"Area"]],resolvedOptions,myImageScale,imageIndex],CellCountDistribution],
				NormalDistribution[0,0.001]
			],
			CellViability->If[!NullQ[numberOfLiveCells],N[numberOfLiveCells/Length[Lookup[propertyValues,"Area"]]*100] Percent]
		|>,
		Association@@Map[
			(* Converting to symbol and lookup in the mathematica output *)
			Rule[ToExpression[#1], Lookup[propertyValues,#1]]&,
			requestedProperties
		],
		Association@@
			(* We are going to replace multiple empty associations with Null *)
			ReplaceAll[
				Map[
					(* Converting to symbol and lookup in the mathematica output *)
					Rule[#, ReplaceAll[#,rearrangedCategorizedProperties]]&,
					{
						AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse,
						ShapeMeasurements,BoundingboxProperties,TopologicalProperties,ImageIntensity
					}
				],
				{
					(* All properties are Nulls *)
					(x_Symbol->{<|(_Symbol->Null)..|>..}) :> (x->Null),
					(* NumberOfComponents were zero and we didn't populate the properties *)
					(x_Symbol->_Symbol) :> (x->Null)
				}
			]
	]

];

(* ::Subsubsection:: *)
(*countCellsFromComponents*)

(* Helper to determine the total number of cell and the its uncertainty based on the confluency and min and max cell radius *)
countCellFromComponents[input_,compArea_,resolvedOptions:_?AssociationQ,myImageScale_,imageIndex_]:=Module[

	{minCellRadius,maxCellRadius,minCellRadiusPixel,maxCellRadiusPixel,minA,maxA,singleCellArea,statPacket,cellCount,cellCountUncertainty,standardDeviation},

	(* Min/Max of the cell radius from the options *)
	minCellRadius=If[imageIndex>0,Lookup[resolvedOptions,MinCellRadius][[imageIndex]],Lookup[resolvedOptions,MinCellRadius]];
	maxCellRadius=If[imageIndex>0,Lookup[resolvedOptions,MaxCellRadius][[imageIndex]],Lookup[resolvedOptions,MaxCellRadius]];

	(* We need to convert micron to pixel *)
	(* NOTE: If ImageScale is not available, it is assumed to be 1 Pixel/Micrometer *)
	minCellRadiusPixel=Unitless@If[MatchQ[Units[minCellRadius],Pixel] || MatchQ[myImageScale,Automatic],minCellRadius,minCellRadius*1/myImageScale];
	maxCellRadiusPixel=Unitless@If[MatchQ[Units[maxCellRadius],Pixel] || MatchQ[myImageScale,Automatic],maxCellRadius,maxCellRadius*1/myImageScale];

	(* This means that one of the MinCellRadius or MaxCellRadius has been specified but it conflicts with the default. *)
	If[minCellRadiusPixel>maxCellRadiusPixel,
		Message[Warning::ConflictingDefaultCellRadius,input,minCellRadius,maxCellRadius];
	];

	{minA,maxA} = N@Pi*{minCellRadiusPixel,maxCellRadiusPixel}^2;
	singleCellArea = N@Mean[{minA,maxA}];

	(* We should already see the warning in case maxA<singleCellArea *)
	standardDeviation=If[maxA>singleCellArea,
		(maxA-singleCellArea)/3.,
		0.01
	];

	(* Run the propagate uncertainty to get the approximate number of cells based on the total area, and user specified min/max cell area *)
	statPacket = PropagateUncertainty[
		TotalArea/SingleCellArea,
		{TotalArea->compArea,SingleCellArea\[Distributed]NormalDistribution[singleCellArea,standardDeviation]},
		Method->Parametric,
		Output->All
	];

	{cellCount,cellCountUncertainty} = Lookup[statPacket,{Mean,StandardDeviation}];
	{
		CellCount->cellCount,
		CellCountStandardDeviation->cellCountUncertainty,
		CellCountDistribution->NormalDistribution[cellCount,cellCountUncertainty],
		AverageSingleCellArea->singleCellArea
	}
];

(* ::Subsubsection::Closed:: *)
(* emeraldImageFunction *)


(* Memoize the result for faster update in the builder *)
emeraldImageFunction[
	primitiveSetInformation_,
	allPrimitiveInformation_,
	primitiveHeads_,
	myPrimitive_,
	myEmeraldFunction_,
	lastLabel_String
]:=emeraldImageFunction[
	primitiveSetInformation,
	allPrimitiveInformation,
	primitiveHeads,
	myPrimitive,
	myEmeraldFunction,
	lastLabel
]=Module[
	{
		imageInput,image,imageLabelAvailableQ,result,autoFilledImageInput,outputLabel,keysValues,
		emeraldFunction,mathematicaFunction,primitiveInformation,inputOptions,optionOptions,
		inputOptionRules,optionOptionRules,mathematicaOptions,mathematicaOptionRules,finalResult,
		finalInputOptionRules,processedInputImage
	},

	(* The image input that is provided in the primitive *)
	imageInput=Lookup[myPrimitive,Image,Automatic];

	(* If the Image is left Null, it will be autofilled based on the last primitive label *)
	autoFilledImageInput=If[MatchQ[imageInput,Automatic],
		lastLabel,
		imageInput
	];

	(* Find the image either from the label or from the explicit input image *)
	(** NOTE: we have already checked that label exists **)
	image=Which[
		(StringQ[autoFilledImageInput]) || MatchQ[autoFilledImageInput,{_String,_String}],
			Lookup[$TemporaryImageLookup,autoFilledImageInput],
		MatchQ[autoFilledImageInput,{_String,_}],
			{Lookup[$TemporaryImageLookup,autoFilledImageInput[[1]]],autoFilledImageInput[[2]]},
		True,
			autoFilledImageInput
	];

	(* Find all of the options with their values for this primitive *)
	keysValues=KeyValueMap[Rule[#1,#2]&,KeyDrop[myPrimitive,{Image,OutputImageLabel}]];

	(* Create the symbol to call the function based on the name of function *)
	emeraldFunction=ToExpression["Analysis`Private`"<>Decapitalize[SymbolName[myEmeraldFunction]]];

	(* The primitive is translated to this mathematica function - Add any exception here *)
	mathematicaFunction=ToExpression[StringDelete[SymbolName[myEmeraldFunction],"Emerald"]];

	(* Lookup our image adjustment primitive information. *)
	primitiveInformation=Lookup[allPrimitiveInformation, myEmeraldFunction];

	(* Make sure we have other options as well because they need to index match *)
	inputOptions=UnsortedComplement[Lookup[primitiveInformation,InputOptions,{}],{Image}];

	(* The other option keys will be our option options *)
	optionOptions=UnsortedComplement[
		ToExpression[Lookup[Lookup[primitiveInformation, OptionDefinition],"OptionName"]],
		inputOptions
	];

	(* These options are treated differently than the underlying mathematica options *)
	mathematicaOptions=UnsortedComplement[optionOptions,{ColorNegate,ImageAdjust,BitMultiply,ImageApply}];

	(* We are not gonna use the input options with Null value *)
	inputOptionRules=Select[keysValues,
		And[
			MatchQ[First[#],Alternatives@@inputOptions],
			!MatchQ[Last[#],Null]
		]&
	];

	(* If we have labeled inputs, here we replace them with the actual Image. This update is done case-by-case unfortunately. *)
	finalInputOptionRules=Switch[myEmeraldFunction,
		ImageMultiply,
			ReplaceAll[inputOptionRules,
				{
					(SecondImage->secondImage_String) :> (SecondImage->Lookup[$TemporaryImageLookup,secondImage])
				}
			],

		Inpaint,
			ReplaceAll[inputOptionRules,
				{
					(Region->region_String) :> (Region->Lookup[$TemporaryImageLookup,region])
				}
			],

		WatershedComponents,
			ReplaceAll[inputOptionRules,
				{
					(Marker->marker_String) :> (Marker->Lookup[$TemporaryImageLookup,marker])
				}
			],

		SelectComponents,
			ReplaceAll[inputOptionRules,
				{
					(Property->property_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&)) :> (Property->SymbolName[property])
				}
			],

		ComponentMeasurements,
			ReplaceAll[inputOptionRules,
				{
					(Property->property_?(MatchQ[#,_Symbol]&)) :> (Property->SymbolName[property]),
					(Property->properties_?(MatchQ[#,{_Symbol..}]&)) :> (Property->(SymbolName[#]&/@properties)),
					(OutputFormat->outputFormat_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&)) :> (OutputFormat->SymbolName[outputFormat])
				}
			],

		_,
			inputOptionRules

	];

	(* All of the key values correcponding to our optionOptions *)

	optionOptionRules=ReplaceAll[
		Select[keysValues,
			MatchQ[First[#],Alternatives@@optionOptions]&
		],
		{
			(** NOTE: We are replacing the symbol method with the strings since mathematica is confused otherwise **)
			(Method->method_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&)) :> (Method->SymbolName[method]),
			(Method->
				{
					method1_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&),
					method2_String
				}
			) :>
			(Method->{SymbolName[method1],method2}),
			(Method->
				{
					method1_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&),
					method2_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&)
				}
			) :>
			(Method->{SymbolName[method1],SymbolName[method2]}),
			(Padding->padding_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&)) :> (Padding->SymbolName[padding]),
			(BitMultiply->bitMultiply_String) :> (BitMultiply->Lookup[$TemporaryImageLookup,bitMultiply])
		}
	];

	(* We are gonna use these rules directly for the mathematica function *)
	mathematicaOptionRules=ReplaceAll[
		Select[keysValues,
			MatchQ[First[#],Alternatives@@mathematicaOptions]&
		],
		{
			(** NOTE: We are replacing the symbol method with the strings since mathematica is confused otherwise **)
			(Method->method_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&)) :> (Method->SymbolName[method]),
			(Method->
				{
					method1_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&),
					method2_String
				}
			) :>
			(Method->{SymbolName[method1],method2}),
			(Method->
				{
					method1_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&),
					method2_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&)
				}
			) :>
			(Method->{SymbolName[method1],SymbolName[method2]}),
			(Padding->padding_?(And[MatchQ[#,_Symbol],!MatchQ[#,Automatic|None]]&)) :> (Padding->SymbolName[padding]),
			(BitMultiply->bitMultiply_String) :> (BitMultiply->Lookup[$TemporaryImageLookup,bitMultiply])
		}
	];

	(* Apply ColorNegate is the user has requested *)
	processedInputImage=Module[
		{colorNegate,colorNegateQ},

		(* If the primitive has the ImageAdjust option *)
		colorNegate=Lookup[optionOptionRules,ColorNegate,Null];

		(* If we have the ImageAdjust option and it is True, we should apply ImageAdjust *)
		colorNegateQ=If[!MatchQ[colorNegate,Null],
			Lookup[optionOptionRules,ColorNegate],
			False
		];

		Which[
			colorNegateQ,
				ColorNegate[image],
			True,
				image
		]
	];

	(* The final result from calling the underlying mathematica function *)
	result=If[Length[finalInputOptionRules]>0,
		mathematicaFunction@@{processedInputImage,Sequence@@(Values@finalInputOptionRules),Sequence@@mathematicaOptionRules},
		mathematicaFunction@@{processedInputImage,Sequence@@mathematicaOptionRules}
	];

	(** Dealing with any exceptions here **)

	finalResult=Module[
		{imageAdjust,imageAdjustQ,bitMultiply,bitMultiplyQ,imageApply,imageApplyQ},

		(* If the primitive has the ImageAdjust option *)
		imageAdjust=Lookup[optionOptionRules,ImageAdjust,Null];

		(* If we have the ImageAdjust option and it is True, we should apply ImageAdjust *)
		imageAdjustQ=If[!MatchQ[imageAdjust,Null],
			Lookup[optionOptionRules,ImageAdjust],
			False
		];

		(* If the primitive has the BitMultiply option *)
		bitMultiply=Lookup[optionOptionRules,BitMultiply,Null];

		(* If we have the BitMultiply option and it is True, we should apply ImageData[bitMultiply,"bit"] *)
		bitMultiplyQ=If[!MatchQ[bitMultiply,Null],
			True,
			False
		];

		(* If the primitive has the ImageAdjust option *)
		imageApply=Lookup[optionOptionRules,ImageApply,Null];

		(* If we have the ImageAdjust option and it is True, we should apply ImageAdjust *)
		imageApplyQ=If[!MatchQ[imageApply,Null],
			Lookup[optionOptionRules,ImageApply],
			False
		];

		(** TODO: image resize if the size has been changed like when we have padding **)
		Which[
			imageAdjustQ,
				ImageAdjust[result],
			bitMultiplyQ && imageApplyQ,
				Image[ImageData[bitMultiply,"bit"]*result,"Binary"],
			bitMultiplyQ && !imageApplyQ,
				ImageData[bitMultiply,"bit"]*result,
			imageApplyQ,
				Image[result,"Binary"],
			True,
				result
		]
	];

	(* Add the image with the provided label or with the default label *)
	outputLabel=If[MatchQ[Lookup[myPrimitive,OutputImageLabel],Null],
		StringDelete[SymbolName[myEmeraldFunction],"Emerald"],
		Lookup[myPrimitive,OutputImageLabel]
	];

	(* Add the image with the provided label or with the default label *)
	AppendTo[
		$TemporaryImageLookup,
		<|outputLabel->finalResult|>
	];
	{finalResult,outputLabel}

];

(* ::Subsubsection::Closed:: *)
(*App Stylesheet*)

(* Define colormap for partitions (same as default used by mathematica plot functions) *)
partitionColors=Join@@Table[ColorData[97,"ColorList"],{10}];

(* Define font sizes *)
smallFontSize=11;
mediumFontSize=12;
largeFontSize=24;

(* Title formating *)
titleFontSize=16;

(* Define font colors *)
baseFontColor=Darker[Gray,0.5];

(* Button formatting *)
buttonFontSize=12;
buttonColor=Gray;
buttonInactiveColor=Lighter[Gray,0.5];

(* Color used for excluded data points *)
excludedColor=Lighter[Gray,0.5];

(* Color used for the active gate in domain specification mode *)
activeGateColor=Orange;

(* Define table header/row colors *)
tableHeaderColor=Lighter[Gray,0.7];
tableRowColor=Lighter[Gray,0.9];

(* Define menu header/row colors *)
menuHeaderColor=Gray;
menuRowColor=Lighter[Gray,0.9];


(* Define highlighted row *)
tableHighlightedRowColor=Lighter[Blue,0.9];

(* The color for the active sorting button *)


(* ::Subsubsection::Closed:: *)
(* makeImageSelectionPreview *)

makeImageSelectionPreview[
	myInputs_,
	myImagesContent_,
	myExpandedOptions_
]:=Module[
	{
		cache,images,panelWidth=1300,panelHeight=800,imageFiles,listedImages,app
	},

	(* Take the images association from the cache *)
	images=Map[
		KeyTake[
			#,
			{
				Instrument,
				Mode,
				ObjectiveMagnification,
				ImageTimepoint,
				ImageZStep,
				ImagingSite,
				ExcitationWavelength,
				EmissionWavelength,
				DichroicFilterWavelength,
				ExcitationPower,
				TransmittedLightPower,
				ExposureTime,
				FocalHeight,
				ImageBitDepth,
				PixelBinning,
				ImagingSiteRow,
				ImagingSiteColumn
			}
		]&,
		myImagesContent
	];

	(* Passing the image files for showing the preview *)
	imageFiles=Map[
		#[ImageFile]&,
		myImagesContent
	];

	(* Change Association to Lists for better handling in the next functions *)
	listedImages=Map[
		Function[
			inputImages,
			Map[
				Function[inputImage,
					KeyValueMap[
						(#1->#2)&,
						inputImage
					]
				],
				inputImages
			]
		],
		images
	];

	(* Generate preview for all inputs *)
	app=With[

		{
			(* Main definitions *)

			(* initialize the preview symbol *)
			dv=SetupPreviewSymbol[
				(* analysis function we're inside *)
				AnalyzeCellCount,
				(* plot data, used to get coordinate bounds and units *)
				Null,
				(* resolved options.  all ops initialized to these values *)
				myExpandedOptions,
				PreviewSymbol->Lookup[myExpandedOptions,PreviewSymbol]
			]
		},

		DynamicModule[
			{
				grids
			},

			grids=MapThread[
				Function[
					{input,inputIndex,inputImages,inputImageFiles},

					Panel[
						makeSingleInputImageSelectionPreview[input,inputIndex,inputImages,inputImageFiles,myExpandedOptions,dv],
						ToString@input
					]

				],
				{myInputs,Range[Length[myInputs]],listedImages,imageFiles}
			];

			(*--------------*)
			(** Final grid **)
			(*--------------*)
			If[Length[myInputs]>1,
				SlideView[grids],
				First[grids]
			]

		]

	];

	(* Return the app *)
	Pane[
		app,
		ImageSize->{UpTo[panelWidth],UpTo[panelHeight]},
		ImageSizeAction->"Scrollable",
		Scrollbars->{False,False},
		Alignment->Center
	]

];

(* ::Subsubsection::Closed:: *)
(* makeSingleInputImageSelectionPreview *)

makeSingleInputImageSelectionPreview[
	myInput_,
	myInputIndex_,
	myImages_,
	myImageFiles_,
	myExpandedOptions_,
	dv_
]:=Module[
	{
		grid,panelWidth=900,panelHeight=400,imageSize=300,desiredIntensity=0.6,resizeFactor=5,
		infoIcon
	},

	(* Information graphics to be used alongside select table entry *)
	infoIcon = Tooltip[Style[FromCharacterCode[9432], Blue],"Once the images are selected, press 'Update' then 'Apply and Recalculate' to proceed"];

	(* Generate preview for either automated or manual clustering *)
	grid=With[

		{
			(* Main definitions *)

			(* the index of the input data object *)
			inputIndex=myInputIndex,

			(* all of the images *)
			images=myImages,

			(* the links for image files *)
			imageFiles=myImageFiles,

			(* the headers which are the keys of properties we are going to show *)
			tableHeaders = {Sequence@@Keys@myImages[[1]]},

			(* dataset is the list of image info *)
			data=Map[Values@#&,myImages]

		},

		DynamicModule[
			{
				myCheckbox,
				thumbnailPreview,
				choices,
				checkBoxes,
				table,
				sortingIndex,
				activeTableHeaders,
				imagesPrimitives,
				currentThumbnail,
				buttonAppearance,

				highlightedRow,
				firstImportedImage,
				updateThumbnail
			},

			(* Storing the image primitives to use for quick access - otherwise on the fly *)
			imagesPrimitives=Map[MicroscopeImage[ InputObject->Automatic, Sequence@@images[[#]] ]&,Range[Length[images]]];

			(*------------------------*)
			(** Function Definitions **)
			(*------------------------*)

			(* myCheckbox add or remove "elt" to/from the list "choice" *)
			SetAttributes[myCheckbox, HoldFirst];
			myCheckbox[choice_, elt_]:=Checkbox[
				Dynamic[
					MemberQ[choice, elt],
					(
						If[#,
							AppendTo[choice, elt],
							choice=DeleteCases[choice, elt]
						]
					)&
				]
			];

			(* Helper to update the LogPreviewChanges once we have selected images *)
			updateLogPreview[choices_,dvar_]:=LogPreviewChanges[dvar,{
				(* Take the images selected by the user *)
				(* NOTE: we don't want ImageFiles and drop it when mapping over the keys *)
				{Images,inputIndex}->
					imagesPrimitives[[choices]],
				(* Set the image selection to Null if the number of selected is larger than 0 *)
				{ImageSelection,inputIndex}->
					If[Length[choices]>0,
						Automatic,
						Preview
					]
			}];

			(* A function to preview the thumbnail of the image *)
			thumbnailPreview[row_]:=Button[
				row,
				(
					highlightedRow=row;
					currentThumbnail[[row]]=With[
						{importedImage=ImportCloudFile@imageFiles[[row]]},
						Image[ImageResize[ ImageAdjust[ importedImage, {0,Round[N[desiredIntensity/ImageMeasurements[importedImage,"MeanIntensity"]-1],0.001]} ], ImageDimensions[importedImage]/resizeFactor ], ImageSize->imageSize]
					]
				),
				Method -> "Queued"
			];

			(* This function is called when the slide view is pressed next or previous *)
			updateThumbnail[row_]:=With[
				{importedImage=ImportCloudFile@imageFiles[[row]]},
				currentThumbnail[[row]]=Image[ImageResize[ ImageAdjust[ importedImage, {0,Round[N[desiredIntensity/ImageMeasurements[importedImage,"MeanIntensity"]-1],0.001]} ], ImageDimensions[importedImage]/resizeFactor ], ImageSize->imageSize]
			];

			(*---------------------------------------*)
			(** Initialization of non-option things **)
			(*---------------------------------------*)

			choices={};
			(* The checkboxes to use in the select column *)
			checkBoxes=Table[myCheckbox[choices,i],{i,Length[images]}];

			(* The first image is shown by default *)
			firstImportedImage=ImportCloudFile@imageFiles[[1]];

			(* The thumbnail that we are dynamically updating to show *)
			currentThumbnail=ReplacePart[
				(* A framed box with the same size as the thumbnail that shows the image is loading *)
				ConstantArray[Framed["Loading image...",ImageSize->{imageSize,imageSize},Alignment->Center],Length[images]],
				1->Image[ImageResize[ ImageAdjust[ firstImportedImage, {0,Round[N[desiredIntensity/ImageMeasurements[firstImportedImage,"MeanIntensity"]-1],0.001]} ],ImageDimensions[firstImportedImage]/resizeFactor ], ImageSize->imageSize]
			];

			(* Table by concatanating checkboxes, thumbnails and the data *)
			table= Transpose@Insert[
				Insert[Transpose@data,checkBoxes,1],
				Table[thumbnailPreview[i],{i,Length[images]}],1
			];

			sortingIndex=0;

			(* The appearance changes to pressed if the sorting *)
			buttonAppearance=ConstantArray["DialogBox",Length[tableHeaders]+1];

			(* Make the table headers a button to enable sorting *)
			(* NOTE: +1 is because of the Image button that is not in the active headers but will be highlighted separately *)
			activeTableHeaders=MapIndexed[Button[#1,sortingIndex=First@#2;buttonAppearance[[All]]="DialogBox";buttonAppearance[[(First@#2)+1]]="Pressed",Appearance->Dynamic@buttonAppearance[[(First@#2)+1]], Method->"Queued"]&,tableHeaders];

			(* The table row that is actively highlighed which shows the image corresponding to the slide view index *)
			highlightedRow=1;

			(*--------------*)
			(** Final grid **)
			(*--------------*)

			Grid[
				{
					{
						Column[
							{
								Row[
									{
										Button["<<",(highlightedRow=1);If[!MatchQ[currentThumbnail[highlightedRow],_Image],updateThumbnail[highlightedRow]],Method -> "Queued"],
										Button["<",(highlightedRow=If[highlightedRow-1<=0,Length[images],highlightedRow-1]);If[!MatchQ[currentThumbnail[highlightedRow],_Image],updateThumbnail[highlightedRow]],Method -> "Queued"],
										Button[">",(highlightedRow=If[Length[images]==1,1,Mod[highlightedRow+1,Length[images]]]);If[!MatchQ[currentThumbnail[highlightedRow],_Image],updateThumbnail[highlightedRow]],Method -> "Queued"],
										Button[">>",(highlightedRow=Length[images]);If[!MatchQ[currentThumbnail[highlightedRow],_Image],updateThumbnail[highlightedRow]],Method -> "Queued"]
									}
								],
								Dynamic[Style[Text["Image "<>ToString[highlightedRow]],Bold],TrackedSymbols:>{highlightedRow}],
								Dynamic[currentThumbnail[[highlightedRow]],TrackedSymbols:>{highlightedRow}],
								Dynamic[
									Button[
										Tooltip["Update","Press after the images are selected"],
										updateLogPreview[choices,dv]
									],TrackedSymbols:>{choices,dv}
								]
							}
						],
						Pane[
							Dynamic[
								With[
									{
										(* Sorting based on the sortingIndex+2 column of the table *)
										ordering=OrderingBy[table, Function[x, #[[x]] &][sortingIndex+2]]
									},
									Grid[
										(* Table is sorted based on the selected header button from activeTableHeaders *)
										(* NOTE: We take all keys but Select and Image and +2 because of that *)
										(* NOTE: we find the position of highlighted row by looking at the ordering *)
										Insert[
											ReplaceAll[
												table[[ordering]],
												Null->"--"
											],
											Fold[Prepend,activeTableHeaders,{Row[{Select,Spacer[2],infoIcon}],Button[Image,sortingIndex=-1;buttonAppearance[[All]]="DialogBox";buttonAppearance[[1]]="Pressed",Appearance->Dynamic@buttonAppearance[[1]]]}],
											1
										],
										Background->{{},{tableHeaderColor,Sequence@@ReplacePart[ConstantArray[tableRowColor,Length[images]],(Position[ordering,highlightedRow][[1,1]])->tableHighlightedRowColor]}},
										Frame->All,
										FrameStyle->{Thick,White},
										ItemSize->{{Automatic,Automatic},2},
										BaseStyle->{FontSize->smallFontSize}
									]
								],
								TrackedSymbols:>{sortingIndex,currentThumbnail,highlightedRow,buttonAppearance}
							],
							ImageSize->{UpTo[panelWidth],UpTo[panelHeight]},
							ImageSizeAction->"Scrollable",
							Scrollbars->{True,True},
							Alignment->Center
						]
					}
				},
				Alignment->{Automatic,{Top}}
			],

			(* Inherit scope from outermost context so we can set and retrieve the PreviewValues *)
			InheritScope->True

		]

	]


];


(* ::Subsubsection::Closed:: *)
(* makePreview *)

DefineOptions[makePreview,
	Options:>{
		CacheOption
	}
];

makePreview[
	myInputs_,
	myResolvedOptions_,
	myDataPacket_,
	myImageScaleX_,
	myDilutionFactors_,
	mySampleVolumes_,
	myOptions:OptionsPattern[makePreview]
]:=Module[
	{
		cache,images,panelWidth=1800,panelHeight=800,imageFiles,listedImages,app
	},

	(* Lookup our supplied cache. *)
	cache = Lookup[{myOptions},Cache,{}];

	(* Generate preview for all inputs *)
	app=With[

		{
			(* Main definitions *)

			(* initialize the preview symbol *)
			dv=SetupPreviewSymbol[
				(* analysis function we're inside *)
				AnalyzeCellCount,
				(* plot data, used to get coordinate bounds and units *)
				Null,
				(* resolved options.  all ops initialized to these values *)
				myResolvedOptions,
				PreviewSymbol->Lookup[myResolvedOptions,PreviewSymbol]
			]
		},

		Module[
			{
				plots
			},

			(* Initialization of preview variables *)

			(* Remove the Replace and Append headers *)
			inputPackets=Analysis`Private`stripAppendReplaceKeyHeads[myDataPacket];

			(* Manual coordinates *)
			dv[ManualCoordinates]=Switch[PreviewValue[dv,ManualCoordinates],
				{},
					MapThread[
						Function[
							{inputIndex,inputDataPacket},
							ConstantArray[{},Length[Lookup[inputDataPacket,ReferenceImage]]]
						],
						{Range[Length[myInputs]],inputPackets}
					],
				_,
					PreviewValue[dv,ManualCoordinates]
			];

			(* NumberOfManualCells *)
			dv[NumberOfManualCells]=Switch[PreviewValue[dv,NumberOfManualCells],
				Null,
					MapThread[
						Function[
							{inputIndex,inputDataPacket},
							ConstantArray[{},Length[Lookup[inputDataPacket,ReferenceImage]]]
						],
						{Range[Length[myInputs]],inputPackets}
					],
				_,
					PreviewValue[dv,NumberOfManualCells]
			];

			(* ManualSampleCellDensity *)
			dv[ManualSampleCellDensity]=Switch[PreviewValue[dv,ManualSampleCellDensity],
				Null,
					MapThread[
						Function[
							{inputIndex,inputDataPacket},
							ConstantArray[{},Length[Lookup[inputDataPacket,ReferenceImage]]]
						],
						{Range[Length[myInputs]],inputPackets}
					],
				_,
					PreviewValue[dv,ManualSampleCellDensity]
			];

			(* Generating the main plot by calling the preview for each input individually *)
			plots=MapThread[
				Function[
					{input,inputIndex,inputDataPacket,inputImageScaleX,inputDilutionFactor,inputSampleVolume},

					Panel[
						(* Pass empty list for all inputs if it is empty for the raw input cases *)
						If[MatchQ[cache,{}],
							makeSingleInputPreview[
								input,inputIndex,inputDataPacket,inputImageScaleX,inputDilutionFactor,inputSampleVolume,{},dv
							],
							makeSingleInputPreview[
								input,inputIndex,inputDataPacket,inputImageScaleX,inputDilutionFactor,inputSampleVolume,cache[[inputIndex]],dv
							]
						],
						ToString@input
					]

				],
				{myInputs,Range[Length[myInputs]],myDataPacket,myImageScaleX,ToList@myDilutionFactors,ToList@mySampleVolumes}
			];

			(*--------------*)
			(** Final grid **)
			(*--------------*)
			If[Length[myInputs]>1,
				SlideView[plots],
				First[plots]
			]

		]

	];

	(* Return the app *)
	Pane[
		app,
		ImageSize->{UpTo[panelWidth],UpTo[panelHeight]},
		ImageSizeAction->"Scrollable",
		Scrollbars->{False,False},
		Alignment->Center
	]

];

makeSingleInputPreview[
	myInput_,
	myInputIndex_,
	myDataPacket_Association,
	myImageScale_,
	myDilutionFactor_,
	mySampleVolume_,
	myCache_,
	dv_
]:=Module[
	{
		inputPacket=objectPacket,resolvedOps,app
	},

	(* Remove the Replace and Append headers *)
	inputPacket=Analysis`Private`stripAppendReplaceKeyHeads[myDataPacket];

	resolvedOps=Lookup[inputPacket,ResolvedOptions];

	(* Generate preview for either automated or manual clustering *)
	If[MatchQ[Lookup[resolvedOps,Method],Manual|Hybrid],

		(* Panels for manual cell clicking for finding their location *)
		If[Length[Lookup[inputPacket,ReferenceImage]]>1,
			previewMultipleManualPanels[myInput,myInputIndex,inputPacket,resolvedOps,myImageScale,Lookup[resolvedOps,Method],myDilutionFactor,mySampleVolume,myCache,dv],
			previewManualPanels[myInput,myInputIndex,1,inputPacket,resolvedOps,myImageScale,Lookup[resolvedOps,Method],myDilutionFactor,mySampleVolume,myCache,dv]
		],

		If[Length[Lookup[inputPacket,ReferenceImage]]>1,
			previewMultipleAutomaticPanels[myInput,myInputIndex,inputPacket,resolvedOps,myImageScale,myDilutionFactor,mySampleVolume,myCache],
			previewAutomaticPanels[myInput,myInputIndex,inputPacket,resolvedOps,myImageScale,myDilutionFactor,mySampleVolume,myCache]
		]

	]

];


(* ::Subsubsection::Closed:: *)
(* previewMultipleManualPanels *)

previewMultipleManualPanels[
	myInput_,
	myInputIndex_,
	myPacket_Association,
	myResolvedOptions_,
	myImageScales_,
	myPreviewMode_,
	myDilutionFactor_,
	mySampleVolume_,
	myCache_,
	dv_
]:=Module[
	{
		imagePackets,imagesExpandedOptions,referenceImages,adjustedImages,highlightedCells,objects,expandedOptions
	},

	(*----------------------------*)
	(** Main Initial Definitions **)
	(*----------------------------*)

	(* All original images that we analyzed *)
	referenceImages = ImportCloudFile[Lookup[myPacket,ReferenceImage]];

	(* Images after performing the adjustment steps *)
	adjustedImages= ImportCloudFile[Lookup[myPacket,AdjustedImage]];

	(* Images after performing the adjustment and segmentation steps *)
	highlightedCells = ImportCloudFile[Lookup[myPacket,HighlightedCells]];

	(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
	{objects,expandedOptions} = ExpandIndexMatchedInputs[AnalyzeCellCount,{referenceImages},myResolvedOptions,Messages->False];

	(* Packaging the images and resolved options into multiple packets (one for each image)to be able to use previewAutomaticPanels *)
	{imagePackets,imagesExpandedOptions}=Transpose@MapThread[
		Function[
			{referenceImage,referenceImageIndex},
			{
				Association@@KeyValueMap[
					Rule[#1,
						Which[
							Length[#2]>1 && !MatchQ[#1,ResolvedOptions|UnresolvedOptions|DateCreated],
								Part[#2,referenceImageIndex],

							(* Skip any Null valued field and Resolved and UnresolvedOptions *)
							MatchQ[#2,Null|{}] || MatchQ[#1,ResolvedOptions|UnresolvedOptions],
								#2,

							True,
								First@ToList[#2]
						]
					]&,
					myPacket
				],
				KeyValueMap[
					Rule[#1,
						Which[

							MatchQ[#2,Null|{}],
								#2,

							MatchQ[#2,{Null..}],
								Part[#2,referenceImageIndex],

							MatchQ[Length[#2],0],
								#2,

							True,
								If[Length[First[#2]]>1,
									Part[First[#2],referenceImageIndex],
									First[ToList[#2]]
								]
						]
					]&,
					Association@@expandedOptions
				]
			}
		],
		{referenceImages,Range[Length[referenceImages]]}
	];

	(* Map over all images and construct a dynamic module for each image *)

	TabView[
		MapThread[
			Function[
				{referenceImageIndex,imagePacket,imageExpandedOptions,imageScale},
				Rule[
					"Image "<>ToString[referenceImageIndex],

					(* Dynamic module associated with each of the images *)
					previewManualPanels[myInput,myInputIndex,referenceImageIndex,imagePacket,imageExpandedOptions,imageScale,myDilutionFactor,mySampleVolume,myCache]

				]
			],

			{Range[Length[referenceImages]],imagePackets,imagesExpandedOptions,myImageScales}
		]
	]

];

(* ::Subsubsection::Closed:: *)
(* previewManualPanels *)

previewManualPanels[
	myInput_,
	myInputIndex_,
	myImageIndex_,
	myPacket_Association,
	myResolvedOptions_,
	myImageScale_,
	myPreviewMode_,
	myDilutionFactor_,
	mySampleVolume_,
	myCache_,
	dv_
]:=Module[
	{
	},

	With[
		{
			input=myInput,
			inputIndex=myInputIndex,
			imageIndex=myImageIndex,
			packet=myPacket,
			cache=myCache,

			(** Main Initial Definitions **)

			referenceImages=First@ToList@ImportCloudFile[Lookup[myPacket,ReferenceImage]],
			(* Images after performing the adjustment and segmentation steps *)
			highlightedCells = First@ToList@ImportCloudFile[Lookup[myPacket,HighlightedCells]],
			(* Images after performing the adjustment steps *)
			adjustedImages= First@ToList@ImportCloudFile[Lookup[myPacket,AdjustedImage]],
			targetUnits=Lookup[myResolvedOptions,TargetUnits],
			gridPattern=First@ToList@Lookup[myResolvedOptions,GridPattern]
		},

		DynamicModule[
			{

				(* Variables for hemocytometer *)
				hemocytometerPositionFunction,
				hemocytometerCenterFunction,
				hemocytometerSquareLength,
				hemocytometerOrigin,
				highlightedImage,
				numberOfAutomaticCells,
				updateSquareAutomaticCells,

				histogramType,
				clickedCoordinates,
				buttonTable,
				buttonAction,
				buttonActionAll,
				buttonDims,
				buttonArray,
				numberOfManualCells,
				currentSquarePosition,
				updateSquareManualCells,
				squareData,
				indexToPosition,
				gridDimensions,
				inputImageInedx,
				squaresOutline,

				(* Squares with non-zero cells in them *)
				numberOfSquares,
				volumeFactor,
				gridSize,
				automaticCells,
				automaticCellsArea,
				hemocytometerPositions,

				(* Add a toggle for overlaying the usage instructions *)
				middleEpilogSize,
				middleEpilogLocation,
				middleEpilogCenter,
				previousCoordinatesEpilog,
				resizedReferenceImages,
				resizeFactor=5,
				showInstructions=True

			},

			(*----------------------------*)
			(** Main Initial Definitions **)
			(*----------------------------*)

			(* For data objects the dimension is two while for the cloudfiles the dimension is 1 *)
			inputImageInedx=Which[
				MatchQ[input,ObjectP[microscopeInputDataObjectTypes]],
					{inputIndex,imageIndex},
				MatchQ[input,ObjectP[microscopeInputRawObjectTypes]],
					inputIndex
			];

			(* We don't need all pixels for the left figure *)
			resizedReferenceImages = ImageResize[referenceImages,ImageDimensions[referenceImages]/resizeFactor];

			(* Dimensions of the hemocytometer grid based on the grid pattern type - { X , Y } format *)
			gridDimensions=Switch[gridPattern,
				Neubauer|Malassez|Burker|BurkerTurk,
				{3,3},
				FuchsRosenthal,
				{4,4},
				HemocytometerGridPatternP,
				{3,3}
			];
			gridSize=gridDimensions[[1]];

			(* Taking the dimensions from the hemocytometer model in the cache *)
			findVolumeFactor[]:=Module[
				{
					protocol,containersInFromProtocol,containersInModel,chamberDepth,subregionPositions
				},

				(* The protocol object in the cache *)
				protocol=FirstOrDefault[Lookup[Experiment`Private`fetchPacketFromCache[input,cache],Protocol],Null];

				(* Taking the container object type from the protocol *)
				containersInFromProtocol=FirstOrDefault[Lookup[Experiment`Private`fetchPacketFromCache[protocol[Object],cache],ContainersIn],Null];

				(* containersInModel from the protocol *)
				containersInModel=If[!NullQ[containersInFromProtocol],
					Download[containersInFromProtocol,Model]
				];

				(* The depth of the whole hemocytometer chamber *)
				{chamberDepth,subregionPositions}=If[!NullQ[containersInModel],
					Download[containersInModel,{ChamberDepth,SubregionPositions}],
					{Null,Null}
				];

				(* The dimensions of the subregions (squares) in the hemocytometer *)
				{maxWidth,maxDepth}=If[!NullQ[containersInModel],
					Lookup[subregionPositions[[1]],{MaxWidth,MaxDepth}],
					{Null,Null}
				];

				(* If not Null find the conversion to Milliliter and then inverse to find the factor *)
				If[!NullQ[containersInModel],
					1/Unitless[UnitConvert[chamberDepth*maxWidth*maxDepth, Milliliter]],
					Switch[gridPattern,
						Neubauer|Malassez|Burker|BurkerTurk,
						10^4,
						FuchsRosenthal,
						10^4,
						HemocytometerGridPatternP,
						10^4
					]
				]

			];

			(* Volume factor which depends on the type of hemocytometer *)
			volumeFactor=If[!MatchQ[cache,{}],
				findVolumeFactor[],
				Switch[gridPattern,
					Neubauer|Malassez|Burker|BurkerTurk,
					10^4,
					FuchsRosenthal,
					10^4,
					HemocytometerGridPatternP,
					10^4
				]
			];

			automaticCells=Which[
				MatchQ[Lookup[myPacket,ComponentCentroid],{{_,_}..}],
					Lookup[myPacket,ComponentCentroid],
				MatchQ[Lookup[myPacket,ComponentCentroid],{{{_,_}..}}],
					First@Lookup[myPacket,ComponentCentroid],
				True,
					Lookup[myPacket,ComponentCentroid]
			];
			automaticCellsArea=Which[
				MatchQ[Lookup[myPacket,ComponentArea],{UnitsP[] ..}],
					Lookup[myPacket,ComponentArea],
				MatchQ[Lookup[myPacket,ComponentArea],{{UnitsP[] ..}}],
					First@Lookup[myPacket,ComponentArea],
				True,
					Lookup[myPacket,ComponentArea]
			];
			hemocytometerPositions=findHemocytometerSquareCoordinates[
				referenceImages,
				gridPattern,
				Permutations[Flatten@Map[{#, #} &, Range[gridSize]], {2}]
			];

			(*------------------------*)
			(** Function Definitions **)
			(*------------------------*)

			(* Plot the button tables for the hemocytometer *)
			buttonTable[action_, bArray_, dims_]:=Grid@Reverse@Array[Button[{#1, #2}, action[bArray, #1, #2]]&, dims];
			(* Reset the previous clicked buttons and blacken the one that is clicked *)
			buttonAction[bArray_, x_, y_]:=(Table[bArray[i,j]=0,{i,1,gridSize},{j,1,gridSize}];bArray[x, y] = 1; currentSquarePosition={x,y});
			(* Reset the previous clicked buttons and blacken all *)
			buttonActionAll[bArray_]:=(Table[bArray[i,j]=1,{i,1,gridSize},{j,1,gridSize}]; currentSquarePosition=All);
			(* Calculate the number of cells within a region *)
			updateSquareManualCells[{x_,y_}]:=Module[{count,samexQ,sameyQ},
				count=0;
				samexQ[position_]:=Floor[ ( position[[1]]-hemocytometerOrigin[[1]] )/hemocytometerSquareLength[[1]] ] + 1 == x;
				sameyQ[position_]:=Floor[ ( position[[2]]-hemocytometerOrigin[[2]] )/hemocytometerSquareLength[[2]] ] + 1 == y;
				Map[If[(samexQ[#] && sameyQ[#]),count+=1]&,Part[PreviewValue[dv,ManualCoordinates],Sequence@@inputImageInedx]];
				count
			];
			(* Flipping the rectangles *)
			flipper[rect_Association,rectIndex_]:=Module[{},
				Inset[
					Graphics[{#,Opacity[0.3],Rectangle[]}] & /@ rect["hues"],
					rect["cntr"], Automatic, 2 rect["r"]
				]
			];
			(* Finding the hemocytometer position and center of squares for referenceImage *)
			hemocytometerPositionFunction[{x_,y_}] := hemocytometerPositions[[(x-1)*gridSize+y]] /. ({{x1_,y1_},{x2_,y2_}}) :> ({{x1,x2},{y1,y2}});
			hemocytometerPositionFunction[All]=findHemocytometerSquareCoordinates[referenceImages,gridPattern,All] /. ({{x1_,y1_},{x2_,y2_}}) :> ({{x1,x2},{y1,y2}});
			hemocytometerCenterFunction[{x_,y_}] := hemocytometerPositions[[(x-1)*gridSize+y]] /. ({{x1_,y1_},{x2_,y2_}}) :> ({(x1+x2)/2,(y1+y2)/2});

			indexToPosition[index_]:={Floor[ (index - 1)/gridSize ] + 1,Mod[index - 1, gridSize ] + 1};

			(* Epilog for the middle image *)
			middleEpilogSize=ImageDimensions[referenceImages];
			middleEpilogLocation=findHemocytometerSquareCoordinates[referenceImages,gridPattern,All] /. ({{x1_,y1_},{x2_,y2_}}) :> (Round[{{(x1+x2)/2-middleEpilogSize[[1]]/2,(y1+y2)/2-middleEpilogSize[[2]]/2},{(x1+x2)/2+middleEpilogSize[[1]]/2,(y1+y2)/2+middleEpilogSize[[2]]/2}}]);
			middleEpilogCenter=middleEpilogLocation /. ({{x1_,y1_},{x2_,y2_}}) :> ({(x1+x2)/2,(y1+y2)/2});
			middleEpilog[instruction_]:=If[
				(instruction && MatchQ[Part[Lookup[myResolvedOptions,ManualCoordinates],Sequence@@inputImageInedx],{}]),
				{
					White,Opacity[0.8],Rectangle[Sequence@@middleEpilogLocation],
					Opacity[1],Style[Text["Mouse+Keypad guide:\nClick+Drag to zoom-in\nShift+LeftClick to add a new cell\nLeftClick to move the last added cell\nShift+RightClick to remove the last added cell",middleEpilogCenter],FontFamily->"Arial",FontSize->titleFontSize,FontColor->baseFontColor]
				},
				{}
			];

			(*---------------------*)
			(** Other Definitions **)
			(*---------------------*)
			hemocytometerSquareLength=hemocytometerPositionFunction[All] /. {{x1_,x2_},{y1_,y2_}} :> {(x2-x1)/gridSize , (y2-y1)/gridSize};

			hemocytometerOrigin=hemocytometerPositionFunction[All] /. {{x1_,x2_},{y1_,y2_}} :> {x1, y1};

			(* The grid which shows the outline of the hemocytometer squares *)
			squaresOutline=
				Join[
					(* horizontal lines *)
					{
						Blue,Dashed,Thick,
						Sequence@@Map[
							Line[{{hemocytometerOrigin[[1]],hemocytometerOrigin[[2]]+(#-1)*hemocytometerSquareLength[[2]]},{hemocytometerOrigin[[1]]+hemocytometerSquareLength[[1]]*gridDimensions[[1]],hemocytometerOrigin[[2]]+(#-1)*hemocytometerSquareLength[[2]]}}/resizeFactor]&,
							Range[gridDimensions[[1]]+1]
						]
					},
					(* vertical lines *)
					{
						Blue,Dashed,Thick,
						Sequence@@Map[
							Line[{{hemocytometerOrigin[[1]]+(#-1)*hemocytometerSquareLength[[1]],hemocytometerOrigin[[2]]},{hemocytometerOrigin[[1]]+(#-1)*hemocytometerSquareLength[[1]],hemocytometerOrigin[[2]]+hemocytometerSquareLength[[2]]*gridDimensions[[2]]}}/resizeFactor]&,
							Range[gridDimensions[[2]]+1]
						]
					}
				];

			(* Highlighted *)
			highlightedImage=If[myPreviewMode==Hybrid,
				(* HighlightImage[ImageAdjust[referenceImages,{0,2}],MapThread[{PointSize[Sqrt[#2/Pi]],Point[(#1+hemocytometerOrigin+2*hemocytometerSquareLength)]}&,{automaticCells,automaticCellsArea}]] *)
				Module[
					{img,region},
					img = ImageAdjust[referenceImages,{0,2}];

					region[center_,size_] := If[UnitsQ[size,Micrometer],
						{Red, Thickness[0.005], EdgeForm[], Circle[Unitless@center, Unitless@size / Unitless@(First@ToList@myImageScale)]},
						{Red, Thickness[0.005], EdgeForm[], Circle[Unitless@center, Unitless@size]}
					];

					Image@HighlightImage[
						img,
						MapThread[
							region[(#1+hemocytometerOrigin),Sqrt[#2/Pi]]&,
							{automaticCells,automaticCellsArea}
						]
					]
				]
			];

			numberOfAutomaticCells=ConstantArray[0,gridDimensions];
			updateSquareAutomaticCells[{x_,y_}]:=Module[{count,samexQ,sameyQ},
				count=0;
				samexQ[position_]:=Floor[ ( position[[1]] )/hemocytometerSquareLength[[1]] ] + 1 == y;
				sameyQ[position_]:=Floor[ ( position[[2]] )/hemocytometerSquareLength[[2]] ] + 1 == x;
				Map[If[(samexQ[#] && sameyQ[#]),count+=1]&,automaticCells];
				count
			];
			Table[numberOfAutomaticCells[[i,j]]=updateSquareAutomaticCells[{i,j}],{i,1,gridSize},{j,1,gridSize}];

			(* Taking a part of the preview value *)
			(* CoordinatesP correspond to constant for all *)
			takePreviewValue[previewValue_,index_]:=If[MatchQ[previewValue,CoordinatesP],
				previewValue,
				Part[previewValue,Sequence@@index]
			];
			(* To display a certain number of significant figures for distributions and numbers *)
			myRound[number_]:=NumberForm[number,{\[Infinity],2}];

			(*---------------------------------------*)
			(** Initialization of non-option things **)
			(*---------------------------------------*)

			histogramType=ComponentDiameter;

			currentSquarePosition=All;
			buttonDims = {3, 3};
			Array[(buttonArray[#1, #2] = 1) &, buttonDims];
			numberOfManualCells=ConstantArray[0,gridDimensions];
			squareData = Flatten@Table[
				<|
					"cntr" -> hemocytometerCenterFunction[{i,j}],"r"->hemocytometerSquareLength[[1]]/2,
					"rs-cntr" -> hemocytometerCenterFunction[{i,j}]/5,"rs-r"->hemocytometerSquareLength[[1]]/5/2
				|>,
				{i,1,gridSize},{j,1,gridSize}
			];
			numberOfSquares=Times@@gridDimensions;

			(* Starting the event handler to enable interacting with figures with mouse *)
			EventHandler[
				Dynamic[
					With[
						{
							insertSquareData=squareData,
							insertMiddleEpilog=middleEpilog,
							clickedCoordinates=PreviewValue[dv,ManualCoordinates]
						},
						Grid[
							{
								{
									(* The raw image and the buttons to select the squares *)
									Grid[
										{
											{
												Style[Text["Select hemocytometer square"],FontSize->titleFontSize,FontColor->baseFontColor,Alignment->Center],
												Spacer[50],
												Button["All Squares",showInstructions=False;buttonActionAll[buttonArray]]
											}
										},
										Alignment->{{Left,Right},Center}
									],

									(* The middle image with the mouse guide and also clear and undo buttons *)
									Row[
										{
											Style[Text["Click to count cells"],FontSize->titleFontSize,FontColor->baseFontColor],
											Spacer[20],
											Button["Clear",LogPreviewChanges[dv,{ {ManualCoordinates,{inputIndex,imageIndex}} -> {}}]],
											Button["Undo",LogPreviewChanges[dv,{ {ManualCoordinates,{inputIndex,imageIndex}} -> If[Length[takePreviewValue[PreviewValue[dv,ManualCoordinates],inputImageInedx]]>0,Most[takePreviewValue[PreviewValue[dv,ManualCoordinates],inputImageInedx]],takePreviewValue[PreviewValue[dv,ManualCoordinates],inputImageInedx]]}]]
										}
									],

									(* Table buttons *)
									Row[
										{
											Button["Update Table",
												(* Update manual cells *)
												Table[numberOfManualCells[[i,j]]=updateSquareManualCells[{i,j}],{i,1,gridSize},{j,1,gridSize}];
												(* Update the number of squares depending on if there are manual or automatic cells in them *)
												numberOfSquares=Count[numberOfManualCells+numberOfAutomaticCells,u_/;u>0,Infinity];
												(* Update log preview changes for number of manual cells and cell density *)
												LogPreviewChanges[dv,
													{
														{NumberOfManualCells,{inputIndex,imageIndex}}->numberOfManualCells,
														{ManualSampleCellDensity,{inputIndex,imageIndex}}->If[numberOfSquares!=0, N[Total[numberOfManualCells,2]/numberOfSquares*volumeFactor] Cell/Milliliter, 0 Cell/Milliliter]
													}
												]
											],
											(* Table buttons *)
											Button[Tooltip["Update Composition","Updates the sample composition field using the calculated cell concentration"],
												(* Update sample composition *)
												If[!NullQ[First@Lookup[Experiment`Private`fetchPacketFromCache[input,cache],SamplesIn]],
													Module[
														{
															sampleCellDensity,samplesInObject,composition,compositionIndex,updatedComposition,
															transferredIn,allOriginSamplesPackets,allSamplesComposition,cellSampleIndex,
															sourceCompositionIndex
														},

														(* Find the sample cell density updated in the previous step *)
														sampleCellDensity=takePreviewValue[PreviewValue[dv,ManualSampleCellDensity],inputImageInedx];

														(* Taking the model from the cache *)
														samplesInObject=First@Lookup[Experiment`Private`fetchPacketFromCache[input,cache],SamplesIn];

														(* Finding the composition after removing the links *)
														composition=Map[ReplaceAll[#, {{comp_, link_} :> {comp, RemoveLinkID[link]}}] &, Download[samplesInObject,Composition]];

														(* Find the element index associated with the cell model *)
														compositionIndex=Position[composition, {_, ObjectP[Model[Cell]]}];

														(* Update the composition of the sample in object *)
														updatedComposition=ReplacePart[composition,compositionIndex[[1,1]]->{sampleCellDensity,composition[[compositionIndex[[1,1]],2]]}];

														Upload[
															<|
																Object->RemoveLinkID[samplesInObject][Object],
																Replace[Composition]->updatedComposition
															|>
														];

														(* Update the source sample *)

														(* Looking at the transfer logs of the samplesIn *)
														transferredIn=Lookup[Experiment`Private`fetchPacketFromCache[samplesInObject[Object],cache],TransfersIn];

														(* Taking the origin samples of the transferredIn samples *)
														allOriginSamplesPackets=If[!MatchQ[transferredIn,{}|Null],Download[transferredIn[[All,3]]]];

														(* The sample model that contains the cell *)
														allSamplesComposition=If[!MatchQ[transferredIn,{}|Null],Lookup[allOriginSamplesPackets,Composition]];

														(* The index associated with the cell samples *)
														cellSampleIndex=If[!MatchQ[transferredIn,{}|Null],
															MapThread[
																Function[
																	{inputIndex,inputComposition},

																	(* If we can find Model[Cell] in the composition it will be cell sample *)
																	If[MatchQ[Cases[composition, {___, {_, ObjectP[Model[Cell]]}, ___}],{}],
																		inputIndex,
																		Nothing
																	]

																],
																{Range[Length[transferredIn]],allSamplesComposition}
															]
														];

														(* Find the element index associated with the cell model *)
														sourceCompositionIndex=If[Length[cellSampleIndex]>0,
															Position[allSamplesComposition[[First@cellSampleIndex]], {_, ObjectP[Model[Cell]]}]
														];

														(* Update the composition of the source sample in object *)
														updatedSourceComposition=If[!MatchQ[transferredIn,{}|Null] && Length[cellSampleIndex]>0,
															ReplacePart[
																allSamplesComposition[[First@cellSampleIndex]],
																sourceCompositionIndex[[1,1]]->sampleCellDensity*myDilutionFactor
															]
														];

														If[!MatchQ[transferredIn,{}|Null] && Length[cellSampleIndex]>0,
															Upload[
																<|
																	Object->RemoveLinkID[Lookup[allOriginSamplesPackets,Object][[cellSampleIndex]]],
																	Replace[Composition]->updatedComposition
																|>
															]
														];

													]
												]
											]
										}
									]

								},
								{
									(* Button for selecting the squares *)
									DynamicImage[
										ImageAdjust[resizedReferenceImages,{0,2}],
										Epilog->{
											(* The buttons *)
											(MapThread[
												Inset[Button[ToString[indexToPosition[#2]],showInstructions=False;currentSquarePosition=indexToPosition[#2]],#1["rs-cntr"], Automatic, 2 #1["rs-r"]]&,
												{insertSquareData,Range[Length[insertSquareData]]}
											]),
											(* Square outline *)
											squaresOutline
										},
										ImageSize->400
									],

									(* Middle image with the locator *)
									If[MatchQ[myPreviewMode,Hybrid],
										PlotImage[
											highlightedImage,
											Scale->First@ToList@myImageScale,
											TargetUnits->targetUnits,
											RulerType->Absolute,
											PlotRange->hemocytometerPositionFunction[currentSquarePosition],
											ImageSize->460,
											Epilog->{(Locator[#]&/@takePreviewValue[dv[ManualCoordinates],inputImageInedx])}
										],
										PlotImage[
											ImageAdjust[referenceImages,{0,2}],
											Scale->First@ToList@myImageScale,
											TargetUnits->targetUnits,
											RulerType->Absolute,
											PlotRange->hemocytometerPositionFunction[currentSquarePosition],
											ImageSize->460,
											Epilog->{(Locator[#]&/@takePreviewValue[dv[ManualCoordinates],inputImageInedx])}
										]
									],

									(* The result table *)
									Grid[
										If[MatchQ[myPreviewMode,Hybrid],
											{
												{Style[Text["Square position"],Bold],Style[Text["Manual count"],Bold],Style[Text["Automatic count"],Bold]},
												Sequence@@(
													Flatten[Table[
														{"Square "<>ToString[{i,j}],numberOfManualCells[[i,j]],numberOfAutomaticCells[[i,j]]},
														{i,1,gridSize},{j,1,gridSize}
													],1]
												),
												{Style[Text["Cell count"],Bold],Total[numberOfManualCells,2]+Total[numberOfAutomaticCells,2],SpanFromLeft},
												{Style[Text["Cell concentration"],Bold],If[numberOfSquares!=0,myRound@N[(Total[numberOfManualCells,2]+Total[numberOfAutomaticCells,2])/numberOfSquares*volumeFactor*Cell/Milliliter],0 Cell/Milliliter],SpanFromLeft},
												{Style[Text["Source sample\n cell concentration"],Bold],If[numberOfSquares!=0,myRound@N[(Total[numberOfManualCells,2]+Total[numberOfAutomaticCells,2])/numberOfSquares*volumeFactor*myDilutionFactor*Cell/Milliliter],0*Cell/Milliliter],SpanFromLeft},
												{Style[Text["Sample cell count"],Bold],If[numberOfSquares!=0,myRound@N[(Total[numberOfManualCells,2]+Total[numberOfAutomaticCells,2])/numberOfSquares*volumeFactor*Cell/Milliliter*mySampleVolume],0],SpanFromLeft}
											},
											{
												{Style[Text["Square position"],Bold],Style[Text["Manual count"],Bold]},
												Sequence@@(
													Flatten[Table[
														{"Square "<>ToString[{i,j}],numberOfManualCells[[i,j]]},
														{i,1,gridSize},{j,1,gridSize}
													],1]
												),
												{Style[Text["Cell count"],Bold],Total[numberOfManualCells,2]},
												{Style[Text["Cell concentration"],Bold],If[numberOfSquares!=0, myRound@N[Total[numberOfManualCells,2]/numberOfSquares*volumeFactor*Cell/Milliliter], 0*Cell/Milliliter]},
												{Style[Text["Source sample\n cell concentration"],Bold],If[numberOfSquares!=0, myRound@N[Total[numberOfManualCells,2]/numberOfSquares*volumeFactor*myDilutionFactor*Cell/Milliliter], 0*Cell/Milliliter]},
												{Style[Text["Sample cell count"],Bold],If[numberOfSquares!=0, myRound@N[Total[numberOfManualCells,2]/numberOfSquares*volumeFactor*Cell/Milliliter*mySampleVolume], 0]}
											}
										],
										Alignment->{{Left,Right},Center},
										Background->{{},{
											tableHeaderColor,Sequence@@ConstantArray[tableRowColor,Times@@gridDimensions],tableHeaderColor,tableHeaderColor,tableHeaderColor
											}
										},
										Frame->All,
										FrameStyle->{Thick,White},
										ItemSize->{{Automatic,Automatic},2},
										BaseStyle->{FontSize->smallFontSize}
									]

								}

							},
							Alignment->{Center,{Bottom,Top}},
							Spacings->{5,1}
						]
					],
					TrackedSymbols :> {dv,histogramType,currentSquarePosition,numberOfManualCells,showInstructions,numberOfSquares}
				],
				{
					(* -------- 3: Actions connected to the graphics ---------- *)
					{"MouseClicked",2}:>If[TrueQ[CurrentValue["ShiftKey"]],
						If[Length[Part[PreviewValue[dv,ManualCoordinates],Sequence@@inputImageInedx]]>0,
							LogPreviewChanges[dv,{{ManualCoordinates,inputImageInedx}->Most[takePreviewValue[PreviewValue[dv,ManualCoordinates],inputImageInedx]]}]
						],
						(* Without the shift key we will adjust the position of the selected points *)
						LogPreviewChanges[dv,
							{
								{ManualCoordinates,inputImageInedx}->Append[Most[takePreviewValue[PreviewValue[dv,ManualCoordinates],inputImageInedx]],MousePosition["Graphics"]]
							}
						]
					],
					{"MouseClicked", 1} :> If[TrueQ[CurrentValue["ShiftKey"]],
						(
							LogPreviewChanges[dv,{{ManualCoordinates,inputImageInedx}->Append[takePreviewValue[PreviewValue[dv,ManualCoordinates],inputImageInedx], MousePosition["Graphics"]]}]
						)
					]
				},
				PassEventsDown -> True
			]
		]

	]

];

(* ::Subsubsection::Closed:: *)
(* previewMultipleAutomaticPanels *)

previewMultipleAutomaticPanels[
	myInput_,
	myInputIndex_,
	myPacket_Association,
	myResolvedOptions_,
	myImageScales_,
	myDilutionFactor_,
	mySampleVolume_,
	myCache_
]:=Module[
	{
		imagePackets,imagesExpandedOptions,referenceImages,adjustedImages,highlightedCells,objects,expandedOptions
	},

	(*----------------------------*)
	(** Main Initial Definitions **)
	(*----------------------------*)

	(* All original images that we analyzed *)
	referenceImages = ImportCloudFile[Lookup[myPacket,ReferenceImage]];

	(* Images after performing the adjustment steps *)
	adjustedImages= ImportCloudFile[Lookup[myPacket,AdjustedImage]];

	(* Images after performing the adjustment and segmentation steps *)
	highlightedCells = ImportCloudFile[Lookup[myPacket,HighlightedCells]];

	(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
	{objects,expandedOptions} = ExpandIndexMatchedInputs[AnalyzeCellCount,{referenceImages},myResolvedOptions,Messages->False];

	(* Packaging the images and resolved options into multiple packets (one for each image)to be able to use previewAutomaticPanels *)
	{imagePackets,imagesExpandedOptions}=Transpose@MapThread[
		Function[
			{referenceImage,referenceImageIndex},
			{
				Association@@KeyValueMap[
					Rule[#1,
						Which[
							(* These means there is only one compoenent *)
							MatchQ[#1,ImageScale] && MatchQ[#2,{_,_}],
								#2,
							MatchQ[#1,TargetUnits] && MatchQ[#2,{{_,_},{_,_}}],
								#2,

							(* This means there are multiple compoenents *)
							Length[#2]>1 && !MatchQ[#1,ResolvedOptions|UnresolvedOptions|DateCreated|Type|Reference],
								Part[#2,referenceImageIndex],

							(* Skip any Null valued field and Resolved and UnresolvedOptions *)
							MatchQ[#2,Null|{}] || MatchQ[#1,ResolvedOptions|UnresolvedOptions],
								#2,

							True,
								First@ToList[#2]
						]
					]&,
					myPacket
				],
				KeyValueMap[
					Rule[#1,
						Which[

							(* These means there is only one compoenent *)
							MatchQ[#1,ImageScale] && MatchQ[#2,{_,_}],
								#2,
							MatchQ[#1,TargetUnits] && MatchQ[#2,{{_,_},{_,_}}],
								#2,

							MatchQ[#2,Null|{}],
								#2,

							MatchQ[#2,{Null..}],
								Part[#2,referenceImageIndex],

							MatchQ[Length[#2],0],
								#2,

							True,
								If[Length[First[#2]]>1,
									Part[First[#2],referenceImageIndex],
									First[ToList[#2]]
								]
						]
					]&,
					Association@@expandedOptions
				]
			}
		],
		{referenceImages,Range[Length[referenceImages]]}
	];

	(* Map over all images and construct a dynamic module for each image *)

	TabView[
		MapThread[
			Function[
				{referenceImageIndex,imagePacket,imageExpandedOptions,imageScale},
				Rule[
					"Image "<>ToString[referenceImageIndex],

					(* Dynamic module associated with each of the images *)
					previewAutomaticPanels[myInput,imagePacket,imageExpandedOptions,imageScale,myDilutionFactor,mySampleVolume]

				]
			],

			{Range[Length[referenceImages]],imagePackets,imagesExpandedOptions,myImageScales}
		]
	]

];

(* ::Subsubsection::Closed:: *)
(* previewAutomaticPanels *)

previewAutomaticPanels[
	myInput_,
	myInputIndex_,
	myPacket_Association,
	myResolvedOptions_,
	myImageScale_,
	myDilutionFactor_,
	mySampleVolume_,
	myCache_
]:=Module[
	{
	},

	With[
		{
			insertedImageScaleEpilog=imageScaleEpilog
		},

		DynamicModule[
			{
				input=myInput,
				packet=myPacket,
				ops=myResolvedOptions,

				(*----------------------------*)
				(** Main Initial Definitions **)
				(*----------------------------*)

				imageScale=First@ToList[myImageScale],

				(* All original images that we analyzed *)
				referenceImages = First@ToList@ImportCloudFile[Lookup[myPacket,ReferenceImage]],

				(* Images after performing the adjustment steps *)
				adjustedImages= First@ToList@ImportCloudFile[Lookup[myPacket,AdjustedImage]],

				(* Images after performing the adjustment and segmentation steps *)
				highlightedCells = First@ToList@ImportCloudFile[Lookup[myPacket,HighlightedCells]],

				minCellRadius=First@ToList[Lookup[myResolvedOptions,MinCellRadius]],
				maxCellRadius=First@ToList[Lookup[myResolvedOptions,MaxCellRadius]],
				areaThreshold=First@ToList[Lookup[myResolvedOptions,AreaThreshold]],

				hemocytometer=Lookup[myResolvedOptions,Hemocytometer],
				hemocytometerSquarePosition=Lookup[myResolvedOptions,HemocytometerSquarePosition],
				measureConfluency=Lookup[myResolvedOptions,MeasureConfluency],
				measureCellViability=Lookup[myResolvedOptions,MeasureCellViability],
				targetUnits=Lookup[myResolvedOptions,TargetUnits],
				(* Main properties of cells and the number of cells *)
				numberOfComponents=First@ToList[Lookup[myPacket,NumberOfComponents]],
				numberOfCells=First@ToList[Lookup[myPacket,NumberOfCells]],

				componentArea,
				componentAreaDistribution=First@ToList[Lookup[myPacket,ComponentAreaDistribution]],
				componentDiameter,
				componentDiameterDistribution=First@ToList[Lookup[myPacket,ComponentDiameterDistribution]],
				componentCircularity,
				componentCircularityDistribution=First@ToList[Lookup[myPacket,ComponentCircularityDistribution]],
				confluency=First@ToList[Lookup[myPacket,Confluency]],
				cellViability=First@ToList[Lookup[myPacket,CellViability]],
				componentCentroid,
				componentMeanIntensity,

				(* Initialize the preview symbol *)
				dv=SetupPreviewSymbol[
					AnalyzeCellCount,
					Null,
					myResolvedOptions,
					PreviewSymbol->Lookup[myResolvedOptions,PreviewSymbol]
				],
				imgDims,
				cellSizeCenter,
				componentSizeCenter,
				cellSizeGraphic,
				componentSizeGraphic,
				componentCentroidGraphic
			},

			imgDims=ImageDimensions[highlightedCells];
			cellSizeCenter = First[imgDims]/9 * {5,1};
			componentSizeCenter = First[imgDims]/9 * {7,1};
			minCellRadius=Unitless@If[MatchQ[Units[minCellRadius],Pixel] || MatchQ[imageScale,Automatic],minCellRadius,minCellRadius*1/imageScale];
			maxCellRadius=Unitless@If[MatchQ[Units[maxCellRadius],Pixel] || MatchQ[imageScale,Automatic],maxCellRadius,maxCellRadius*1/imageScale];
			areaThreshold=Unitless@If[MatchQ[Units[areaThreshold],Pixel^2] || MatchQ[imageScale,Automatic],areaThreshold,areaThreshold*1/imageScale^2];
			componentArea=Which[
				MatchQ[Lookup[myPacket,ComponentArea],{UnitsP[] ..}],
					Lookup[myPacket,ComponentArea],
				MatchQ[Lookup[myPacket,ComponentArea],{{UnitsP[] ..}}],
					First@Lookup[myPacket,ComponentArea],
				True,
					Lookup[myPacket,ComponentArea]
			];
			componentDiameter=Which[
				MatchQ[Lookup[myPacket,ComponentDiameter],{UnitsP[] ..}],
					Lookup[myPacket,ComponentDiameter],
				MatchQ[Lookup[myPacket,ComponentDiameter],{{UnitsP[] ..}}],
					First@Lookup[myPacket,ComponentDiameter],
				True,
					Lookup[myPacket,ComponentDiameter]
			];
			componentCircularity=Which[
				MatchQ[Lookup[myPacket,ComponentCircularity],{UnitsP[] ..}],
					Lookup[myPacket,ComponentCircularity],
				MatchQ[Lookup[myPacket,ComponentCircularity],{{UnitsP[] ..}}],
					First@Lookup[myPacket,ComponentCircularity],
				True,
					Lookup[myPacket,ComponentCircularity]
			];
			componentCentroid=Which[
				MatchQ[Lookup[myPacket,ComponentCentroid],{{_,_}..}],
					Lookup[myPacket,ComponentCentroid],
				MatchQ[Lookup[myPacket,ComponentCentroid],{{{_,_}..}}],
					First@Lookup[myPacket,ComponentCentroid],
				True,
					Lookup[myPacket,ComponentCentroid]
			];
			componentMeanIntensity=Which[
				MatchQ[Lookup[myPacket,ImageIntensity],{_Association..}],
					Lookup[Lookup[myPacket,ImageIntensity],MeanIntensity],
				MatchQ[Lookup[myPacket,ImageIntensity],{{_Association..}}],
					Lookup[First@Lookup[myPacket,ImageIntensity],MeanIntensity],
				Length[componentCentroid]>0 && !MatchQ[componentCentroid,{Null}],
					Lookup[Lookup[myPacket,ImageIntensity],MeanIntensity],
				True,
					Lookup[myPacket,ImageIntensity]
			];

			componentCentroidGraphic = If[Length[componentCentroid]>0 && !MatchQ[componentCentroid,{Null}],
				Graphics[
					MapThread[
						{
							Thick,Blue,
							Tooltip[
								Point[#1],
								Text["Component "<>ToString[#2]<>"\n"<>"Diameter "<>ToString[Round[Unitless@#3,0.1]]<>"\n"<>"Area "<>ToString[Round[Unitless@#4,0.1]]<>"\n"<>"Circularity "<>ToString[Round[Unitless@#5,0.1]]<>"\n"<>"Intensity "<>ToString[Round[Unitless@#6,0.01]]]
							]
						}&,
						{componentCentroid,Range[Length[componentCentroid]],componentDiameter,componentArea,componentCircularity,componentMeanIntensity}
					]
				],
				{Null}
			];
			cellSizeGraphic = If[Length[componentCentroid]>0 && !MatchQ[componentCentroid,{Null}],
				Graphics[{
					Locator[Dynamic[cellSizeCenter],ImageSize->Small],
					{Thick,Yellow,Tooltip[Circle[Dynamic[cellSizeCenter],Dynamic[minCellRadius]],"Min single cell area"]},
					{Thick,Yellow,Tooltip[Circle[Dynamic[cellSizeCenter],Dynamic[maxCellRadius]],"Max single cell area"]}
				}],
				{Null}
			];

			componentSizeGraphic = If[Length[componentCentroid]>0 && !MatchQ[componentCentroid,{Null}],
				Graphics[{
					Locator[Dynamic[componentSizeCenter],ImageSize->Small],
					{Thick,Green,Tooltip[Circle[Dynamic[componentSizeCenter],Dynamic[N[Sqrt[Unitless@areaThreshold/Pi]]]],"Min component area"]}
				}],
				{Null}
			];

			(* -------- Initialization ---------- *)

			Dynamic[
				With[
					{
						(* To display a certain number of significant figures for distributions and numbers *)
						myRound=Function[number,NumberForm[number,{\[Infinity],2}]]
					},

					(* ------- 2: Graphics for the figure  ---------*)
					Grid[
						{
							{
								(* NOTE: if the scalebar is in the epilog of DynamicImage it has weird behavior when zooming *)
								DynamicImage[
									highlightedCells,
									ImageSize->475,
									Epilog->{If[MatchQ[imageScale,Automatic],insertedImageScaleEpilog[highlightedCells,1],insertedImageScaleEpilog[highlightedCells,1/imageScale]],First@cellSizeGraphic,First@componentSizeGraphic,First@componentCentroidGraphic}
								],
								Dynamic[
									Pane[
										Column[
											{
												Which[
													hemocytometer,
														Grid[
															{
																{Style["Statistics of the detected cells",Bold],SpanFromLeft},
																{"Component count",myRound@numberOfComponents},
																{"Component area",myRound@componentAreaDistribution},
																{"Component diameter",myRound@componentDiameterDistribution},
																{"Component circularity",myRound@componentCircularityDistribution},
																{Style["Estimated cell count and concentration",Bold],SpanFromLeft},
																{"Cell count",numberOfCells},
																{"Cell concentration",myRound@QuantityDistribution[numberOfCells/1*10^4*myDilutionFactor,1/Milliliter]},
																{"Sample cell count",myRound@(numberOfCells/1*10^4*myDilutionFactor*Unitless[mySampleVolume])}
															},
															Alignment->{{Left,Right},Center},
															Background->{{},{
																tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor,
																tableHeaderColor,tableRowColor
																}
															},
															Frame->All,
															FrameStyle->{Thick,White},
															ItemSize->{{Automatic,Automatic},2},
															BaseStyle->{FontSize->smallFontSize}
														],
													measureCellViability,
														Grid[
															{
																{Style["Statistics of the detected cells",Bold],SpanFromLeft},
																{"Number of cell",numberOfComponents},
																{"Cell viability",cellViability},
																{"Cell area",myRound@componentAreaDistribution},
																{"Cell diameter",myRound@componentDiameterDistribution}
															},
															Alignment->{{Left,Right},Center},
															Background->{{},{
																tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor
																}
															},
															Frame->All,
															FrameStyle->{Thick,White},
															ItemSize->{{Automatic,Automatic},2},
															BaseStyle->{FontSize->smallFontSize}
														],
													True,
														Grid[
															{
																{Style["Statistics of the detected cells",Bold],SpanFromLeft},
																{"Component count",numberOfComponents},
																{"Component area",myRound@componentAreaDistribution},
																{"Component diameter",myRound@componentDiameterDistribution},
																{"Component circularity",myRound@componentCircularityDistribution},
																{"Confluency",myRound@confluency},
																{Style["Estimated cell count and concentration",Bold],SpanFromLeft},
																{"Cell count",myRound@numberOfCells}
															},
															Alignment->{{Left,Right},Center},
															Background->{{},{
																tableHeaderColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor,tableRowColor,
																tableHeaderColor,tableRowColor}
															},
															Frame->All,
															FrameStyle->{Thick,White},
															ItemSize->{{Automatic,Automatic},2},
															BaseStyle->{FontSize->smallFontSize}
														]
												],
												Row[
													{
														"Histogram type: ",
														RadioButtonBar[Dynamic@dv[HistogramType], {ComponentDiameter->"Diameter",ComponentArea->"Area",ComponentIntensity->"Intensity"},Appearance->"Horizontal"],
														Spacer[16]
													},
													BaseStyle->{12,FontFamily->"Arial"}
												],
												Switch[dv[HistogramType],
													ComponentArea,
														If[!NullQ[componentArea],
															Histogram[
																componentArea,
																Automatic,
																"Count",
																ImageSize->300,
																AxesLabel->{"Area","Number of Components"},
																PlotRange->All
															]
														],
													ComponentDiameter,
														If[!NullQ[componentDiameter],
															Histogram[
																componentDiameter,
																Automatic,
																"Count",
																ImageSize->300,
																AxesLabel->{"Diameter","Number of Components"},
																PlotRange->All
															]
														],
													ComponentIntensity,
														If[!NullQ[componentMeanIntensity],
															Histogram[
																componentMeanIntensity,
																Automatic,
																"Count",
																ImageSize->300,
																AxesLabel->{"Intensity","Number of Components"},
																PlotRange->All
															]
														]
												]
											},
											Alignment->Center,
											Spacings->3
										],
										(* Fix pane dimensions to max height of 500px, after which it scrolls *)
										ImageSize->{UpTo[375],UpTo[475]},
										ImageSizeAction->"Scrollable",
										Scrollbars -> {False, True}
									]

								]
							}
						},
						Spacings -> {5, 0},
						BaseStyle -> {GrayLevel[0.5]},
						BaseStyle -> {14,Bold,FontFamily->"Arial"}
					]

				],

				(* not strictly required, but makes things run smoother *)
				TrackedSymbols:>{dv}
			]

		]
	]

];

(* ::Subsubsection::Closed:: *)
(*imageScaleEpilog*)


imageScaleEpilog[img_Image,scale:Null]:={};
imageScaleEpilog[img_Image,scale:UnitsP[Pixel/Micron]]:=Module[
	{w,h,imgBarSizePixels,imagBarSizeDistance,imgBarSizeDistance,color,
	imgBarSizeDistanceRounded,imgBarSizePixelsRounded,barHeight,barStartX,barStopX,
	barCoords,leftVertBar,rightVertBar,textCoords},
	{w,h}=ImageDimensions[img];
	imgBarSizePixels = Round[w/5.];
	imgBarSizeDistance = UnitScale[imgBarSizePixels*Pixel /scale];
	imgBarSizeDistanceRounded = Round[imgBarSizeDistance,100*Units[imgBarSizeDistance]];
	imgBarSizePixelsRounded = Unitless[Round[imgBarSizeDistanceRounded*scale],Pixel];
	barHeight = h/8.;
	barStartX=w/8.;
	barStopX=barStartX+imgBarSizePixelsRounded;
	barCoords = {{barStartX,barHeight},{barStopX,barHeight}};
	leftVertBar = {{barStartX,barHeight*0.925},{barStartX,barHeight*1.075}};
	rightVertBar = {{barStopX,barHeight*0.925},{barStopX,barHeight*1.075}};
	textCoords = {Mean[{barStartX,barStopX}],barHeight};
	color = If[Mean[PixelValue[ColorConvert[img,"Grayscale"],Map[{#,barHeight}&,Subdivide[barStartX,barStopX,10]]]]>0.5,
		Black,
		White
	];
	Tooltip[
		{
			(* lines *)
			{Thick,color,Line[barCoords],Line[leftVertBar],Line[rightVertBar]},
			(* text above line *)
			Style[Text[ToString@Unitless@imgBarSizeDistanceRounded<>" \[Mu]m",textCoords,{0,-1}],Bold,color,FontSize->Large]
		},
		"Image scale: "<>ToString[scale]
	]
];
imageScaleEpilog[img_Image,scale_?NumericQ]:=Module[
	{w,h,imgBarSizePixels,imagBarSizeDistance,imgBarSizeDistance,color,
	imgBarSizeDistanceRounded,imgBarSizePixelsRounded,barHeight,barStartX,barStopX,
	barCoords,leftVertBar,rightVertBar,textCoords},
	{w,h}=ImageDimensions[img];
	imgBarSizePixels = Round[w/5.];
	imgBarSizeDistance = UnitScale[imgBarSizePixels*Pixel/(1 Pixel/Pixel)];
	imgBarSizeDistanceRounded = Round[imgBarSizeDistance,100*Units[imgBarSizeDistance]];
	imgBarSizePixelsRounded = Unitless[Round[imgBarSizeDistanceRounded*(1 Pixel/Pixel)],Pixel];
	barHeight = h/8.;
	barStartX=w/8.;
	barStopX=barStartX+imgBarSizePixelsRounded;
	barCoords = {{barStartX,barHeight},{barStopX,barHeight}};
	leftVertBar = {{barStartX,barHeight*0.925},{barStartX,barHeight*1.075}};
	rightVertBar = {{barStopX,barHeight*0.925},{barStopX,barHeight*1.075}};
	textCoords = {Mean[{barStartX,barStopX}],barHeight};
	color = If[Mean[PixelValue[ColorConvert[img,"Grayscale"],Map[{#,barHeight}&,Subdivide[barStartX,barStopX,10]]]]>0.5,
		Black,
		RGBColor[1, 1, 1]
	];
	{
		(* lines *)
		{Thick,color,Line[barCoords],Line[leftVertBar],Line[rightVertBar]},
		(* text above line *)
		Style[Text[imgBarSizeDistanceRounded,textCoords,{0,-1}],Bold,color,FontSize->Large]
	}
];

(* ::Section::Closed:: *)
(*Sister Functions*)




(* ::Subsection:: *)
(*AnalyzeCellCountOptions*)



DefineOptions[AnalyzeCellCountOptions,
	SharedOptions :> {AnalyzeCellCount},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];


(* Overload for single input object *)
AnalyzeCellCountOptions[
  myInput:ObjectP[microscopeInputObjectTypes],
  myOptions:OptionsPattern[AnalyzeCellCountOptions]
] := Module[
	{
		result
	},
	result=AnalyzeCellCountOptions[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1 || MatchQ[result,$Failed],
		result,
		First[result]
	]

];

(* Overload for multiple data objects *)
AnalyzeCellCountOptions[
  myData:{ObjectP[microscopeInputObjectTypes]..},
	myOptions: OptionsPattern[AnalyzeSmoothingOptions]
]:=Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	options = AnalyzeCellCount[myData,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,AnalyzeCellCount],
		options
	]
];



(* ::Subsection:: *)
(*AnalyzeCellCountPreview*)

DefineOptions[AnalyzeCellCountPreview,
	SharedOptions :> {AnalyzeCellCount}
];

(* Overload for single input object *)
AnalyzeCellCountPreview[
  myInput:ObjectP[microscopeInputObjectTypes],
  myOptions:OptionsPattern[AnalyzeCellCountPreview]
] := Module[
	{
		result
	},
	result=AnalyzeCellCountPreview[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1 || MatchQ[result,$Failed],
		result,
		First[result]
	]

];

AnalyzeCellCountPreview[
  myData:{ObjectP[microscopeInputObjectTypes]..},
	myOptions: OptionsPattern[AnalyzeCellCountPreview]
]:=Module[
	{preview},

	preview = AnalyzeCellCount[myData,Append[ToList[myOptions],Output->Preview]];

	If[MatchQ[preview, $Failed|Null],
		Null,
		preview
	]
];


(* ::Subsection:: *)
(*ValidAnalyzeCellCountQ*)


DefineOptions[ValidAnalyzeCellCountQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {AnalyzeCellCount}
];


(* Overload for single input object *)
ValidAnalyzeCellCountQ[
  myInput:ObjectP[microscopeInputObjectTypes],
  myOptions:OptionsPattern[ValidAnalyzeCellCountQ]
] := Module[
	{
		result
	},
	result=ValidAnalyzeCellCountQ[{myInput}, myOptions];
	If[!MatchQ[result,_List] || Length[result]>1 || MatchQ[result,$Failed],
		result,
		First[result]
	]

];


ValidAnalyzeCellCountQ[
  myInputs:{ObjectP[microscopeInputObjectTypes]..},
	myOptions: OptionsPattern[ValidAnalyzeCellCountQ]
]:=Module[
	{listedInputs,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,safeOptions,verbose,
  outputFormat,result,objectInputs},

	listedInputs=ToList[myInputs];
	listedOptions=ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=AnalyzeCellCount[listedInputs,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

      (* Object inputs *)
      objectInputs = Cases[Flatten[listedInputs,1], _Object | _Model];
      If[!MatchQ[objectInputs, {}],
  			(* Create warnings for invalid objects *)

  			validObjectBooleans=Quiet[
					ValidObjectQ[objectInputs,OutputFormat->Boolean],
					{RunValidQTest::InvalidTests}
				];

        voqWarnings=MapThread[
  				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
  					#2,
  					True
  				]&,
  				{objectInputs,validObjectBooleans}
  			];
  			(* Get all the tests/warnings *)
  			Join[{initialTest},functionTests,voqWarnings],

        functionTests
      ]
		]
	];

	(* Lookup test running options *)
	safeOptions=SafeOptions[ValidAnalyzeCellCountQ,Normal@KeyTake[listedOptions,{Verbose,OutputFormat}]];
	{verbose,outputFormat}=Lookup[safeOptions,{Verbose,OutputFormat}];

	(* Run the tests as requested and return just the summary not the assocition if OutputFormat->TestSummary*)
	result=RunUnitTest[{AnalyzeCellCount->DeleteCases[allTests,Null]},Verbose->verbose,OutputFormat->outputFormat];

	Lookup[result,AnalyzeCellCount]
];

(* Safe functions for unit tests *)

safeImage[expression_]:=Module[{},Quiet[Image[expression],{Image::imgarray}]];
messages={HoldPattern[Image::imgarray]}
