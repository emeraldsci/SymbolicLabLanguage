(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeImageAdjustment*)


(* Updated definition to Command Center *)
DefineUsage[AnalyzeCellCount,
	{
		BasicDefinitions->{

			(* Definition one - a list of microscope data objects *)
			{
				Definition->{"AnalyzeCellCount[microscopeData]","cellCountObject"},
				Description->"counts the number of cells and their area and morphology given a microscope data object according to the type of cells in the aquired image. The function performs adjustment of image specification such as brightness and contrast and performs image segmentation.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "microscopeData",
							Description-> "A list of microscope protocol or data objects.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Data, Microscope],Object[Protocol,ImageCells]}]
							]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs:>{
					{
						OutputName->"cellCountObject",
						Description->"Analysis object for counting the number of cells that contains the information about cell count, cell size, and cell morphology.",
						Pattern:>ListableP[ObjectP[Object[Analysis,CellCount]]]
					}
				}
			},

			(* Definition two - a list of images either stored in cloud or provided as a raw image *)
			{
				Definition->{"AnalyzeCellCount[imageFiles]","cellCountObject"},
				Description->"counts the number of cells and measures the cell size and morphology by first adjusting the image specifications such as brightness and contrast and then performing image segmentation.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "imageFiles",
							Description-> "A list of microscope images stored in a cloud file or provided as a raw image.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[EmeraldCloudFile]]
							]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs:>{
					{
						OutputName->"cellCountObject",
						Description->"Analysis object for counting the number of cells that contains the information about cell count, cell size, and cell morphology.",
						Pattern:>ListableP[ObjectP[Object[Analysis,CellCount]]]
					}
				}
			}

		},
		SeeAlso -> {
			"Image",
			"ImageAdjust",
			"ImageTrim",
			"PlotMicroscope",
			"ImageAdjust",
			"AnalyzeColonies"
		},
		Author -> {
			"scicomp",
			"amir.saadat",
			"varoth.lilascharoen",
			"kevin.hou"
		},
		Guides -> {
			"AnalysisCategories",
			"ExperimentAnalysis"
		},
		Tutorials -> {
		},
		MoreInformation -> {
			"To view examples in the \"Additional Examples\" section of this helpfile, please evaluate the \"Example Setup\" section and then re-evaluate the additional example cells.",
			"There are three major algorithms used for segmentation. The default algorithm is optimized for well-separated cells or cell clusters.",
			"If MeasureConfluency->True, an algorithm is used on the basis of the paper \"A Method for Quick, Low-Cost Automated Confluency Measurements\" by Topman et al., Microsc. Microanal. 17, 915-922, 2011.",
			"The method detects the denuded areas in a micrograph of a culture based on standard deviation of pixel intensities, where low SD values indicate absence of cells and high SD values correspond to areas populated by cells.",
			"Note that the number of cells that is given as the output for a confluency measurement analysis is just the total number of disconnected components and is not the number of each individual cells within the segmented cell cluster.",
			"Two window sizes are used per each image: \"big\" window and \"small\" window, to achieve arrays of coarse and fine homogeneity measures.",
			"Threshold values are binarization can be determined for a given cell type through iterative visual inspection of detected denuded areas in the final output image and increased if the denuded areas are smaller than desired, or decreased otherwise.",
			"Opening is performed which is the operation of erosion followed by dilation, resulting in the removal of small isolated areas. Next morphological closing is done which is the operation of dilation followed by erosion, which results in the filling of small isolated \"holes\" in the image.",
			"If Hemocytometer->True, another algorithm is used which is similar to that of \"Automated Cell Counting and Characterization\" technical report by Janice Lai.",
			"The region of interest is chosen by a pair position index where {1,1} indicates lower left hemocytometer square and {n,n} indicates the top right square.",
			"In this algorithm, the background grid is first removed and then a standard segmentation algorithm is performed to find the cells."
		},
		Preview->True,
		PreviewOptions->{"ManualCoordinates","NumberOfManualCells","HistogramType","ManualSampleCellDensity"}
	}
];


(* ::Section::Closed:: *)
(*AnalyzeCellCountOptions*)


DefineUsage[AnalyzeCellCountOptions,
	{
		BasicDefinitions -> {

			(* Definition one - a list of microscope data objects *)
			{
				Definition->{"AnalyzeCellCountOptions[microscopeData]","cellCountObject"},
				Description->"returns all 'options' for AnalyzeCellCount['microscopeData'] after resolving all Automatic options.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "microscopeData",
							Description-> "A list of microscope protocol or data objects.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Data, Microscope],Object[Protocol,ImageCells]}]
							]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs:>{
	        {
						OutputName -> "options",
						Description -> "The resolved options in the AnalyzeCellCount call.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
					}
				}
			},

			(* Definition two - a lit of images either stored in cloud or provided as a raw image *)
			{
				Definition->{"AnalyzeCellCountOptions[images]","cellCountObject"},
				Description->"returns all 'options' for AnalyzeCellCount['images'] after resolving all Automatic options.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "images",
							Description-> "A list of microscope images stored in a cloud file or provided as a raw image.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[EmeraldCloudFile]]
							]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs:>{
	        {
						OutputName -> "options",
						Description -> "The resolved options in the AnalyzeCellCount call.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
					}
				}
			}

		},
		SeeAlso -> {
			"PlotMicroscope",
			"ImageAdjust",
			"AnalyzeCellCount"
		},
		Author -> {
			"scicomp",
			"amir.saadat",
			"varoth.lilascharoen",
			"kevin.hou"
		},
		Preview->True
	}
];



(* ::Section::Closed:: *)
(*AnalyzeCellCountPreview*)


DefineUsage[AnalyzeCellCountPreview,
	{
		BasicDefinitions -> {

			(* Definition one - a list of microscope data objects *)
			{
				Definition->{"AnalyzeCellCountPreview[microscopeData]","cellCountObject"},
				Description->"returns a graphical display representing AnalyzeCellCount['microscopeData'] output.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "microscopeData",
							Description-> "A list of microscope protocol or data objects.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Data, Microscope],Object[Protocol,ImageCells]}]
							]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "The graphical display representing the AnalyzeSmoothing call output.",
						Pattern :> (ValidGraphicsP[] | _TabView | Null)
					}
				}
			},

			(* Definition two - a lit of images either stored in cloud or provided as a raw image *)
			{
				Definition->{"AnalyzeCellCountPreview[images]","cellCountObject"},
				Description->"returns a graphical display representing AnalyzeCellCount['images'] output.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "images",
							Description-> "A list of microscope images stored in a cloud file or provided as a raw image.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[EmeraldCloudFile]]
							]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "The graphical display representing the AnalyzeSmoothing call output.",
						Pattern :> (ValidGraphicsP[] | _TabView | Null)
					}
				}
			}

		},
		SeeAlso -> {
			"PlotMicroscope",
			"ImageAdjust",
			"AnalyzeCellCount"
		},
		Author -> {
			"scicomp",
			"amir.saadat",
			"varoth.lilascharoen",
			"kevin.hou"
		},
		Preview->True
	}
];


(* ::Section::Closed:: *)
(*ValidAnalyzeCellCountQ*)

DefineUsage[ValidAnalyzeCellCountQ,
	{
		BasicDefinitions -> {

			(* Definition one - a list of microscope data objects *)
			{
				Definition->{"ValidAnalyzeCellCountQ[microscopeData]","cellCountObject"},
				Description->"returns an EmeraldTestSummary which contains the test results of AnalyzeCellCount['microscopeData'] for all the gathered tests/warnings or a single Boolean indicating validity.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "microscopeData",
							Description-> "A list of microscope protocol or data objects.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Data, Microscope],Object[Protocol,ImageCells]}]
							]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs :> {
	        {
						OutputName -> "testSummary",
						Description -> "The EmeraldTestSummary of AnalyzeCellCount['microscopeData'].",
						Pattern :> (EmeraldTestSummary| Boolean)
					}
	      }
			},

			(* Definition two - a lit of images either stored in cloud or provided as a raw image *)
			{
				Definition->{"ValidAnalyzeCellCountQ[images]","cellCountObject"},
				Description->"returns an EmeraldTestSummary which contains the test results of AnalyzeCellCount['images'] for all the gathered tests/warnings or a single Boolean indicating validity.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "images",
							Description-> "A list of microscope images stored in a cloud file or provided as a raw image.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[EmeraldCloudFile]]
							]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs :> {
	        {
						OutputName -> "testSummary",
						Description -> "The EmeraldTestSummary of AnalyzeCellCount['images'].",
						Pattern :> (EmeraldTestSummary| Boolean)
					}
	      }
			}

		},
		SeeAlso -> {
			"PlotMicroscope",
			"ImageAdjust",
			"AnalyzeCellCount"
		},
		Author -> {
			"scicomp",
			"amir.saadat",
			"varoth.lilascharoen",
			"kevin.hou"
		},
		Preview->True
	}
];


(* ::Section::Closed:: *)
(*ImageSelection Primitives*)

DefineUsage[ImageSelect,
	{
		BasicDefinitions -> {
			{"ImageSelect[imageRules]","primitive","generates an AnalyzeCellCount (ImageSelection option) compatible 'primitive' that selects the images according to some criteria from the list of available images in a data object."}
		},
		Input:>{
			{
				"imageRules",
				{
					InputObject->ObjectP[Object[Data,Microscope]]
				},
				"The list of key/value pairs specifying the object to use as the source in the ImageSelect primitive."
			}
		},
		Output:>{
			{"primitive",_ImageSelect,"A primitive for ImageSelection option of AnalyzeCellCount containing information for how to select the images from the data object."}
		},
		Sync -> Automatic,
		MoreInformation->{
			"Please look at the MicroscopeImageSelect function for a comprehensive list of options and their interpretation."
		},
		SeeAlso -> {
			"AnalyzeCellCount",
			"MicroscopeImage",
			"Image",
			"ImageAdjust"
		},
		Author->{"scicomp", "amir.saadat", "varoth.lilascharoen", "kevin.hou"}
	}
];

(* ::Section::Closed:: *)
(*Images Primitives*)

DefineUsage[MicroscopeImage,
	{
		BasicDefinitions -> {
			{"MicroscopeImage[imageRules]","primitive","generates an AnalyzeCellCount (Images option) compatible 'primitive' that selects the images according to some criteria from the list of available images in a data object."}
		},
		Input:>{
			{
				"imageRules",
				{
					InputObject->ObjectP[Object[Data,Microscope]]
				},
				"The list of key/value pairs specifying the object to use as the source in the Images primitive."
			}
		},
		Output:>{
			{"primitive",_ImageSelect,"A primitive for Images option of AnalyzeCellCount containing information for how to select the images from the data object."}
		},
		Sync -> Automatic,
		MoreInformation->{
			"Please look at the MicroscopeImageSelect function for a comprehensive list of options and their interpretation.",
			"ImageSelect is suitable for selecting based on some specific criteria for instance ImagingSite->1;;2, however, MicroscopeImage requires all of the keys to be specified."
		},
		SeeAlso -> {
			"AnalyzeCellCount",
			"ImageSelect",
			"Image",
			"ImageAdjust"
		},
		Author->{"scicomp", "amir.saadat", "varoth.lilascharoen", "kevin.hou"}
	}
];

(* ::Section::Closed:: *)
(*ImageAdjustment Primitives*)


(* ::Subsection::Closed:: *)
(*Image*)

DefineUsage[Image,
	{
		BasicDefinitions -> {
			{"Image[imageRules]","primitive","generates an AnalyzeCellCount (ImageAdjustment and ImageSegmentation options) compatible 'primitive' that converts the matrix output of image functions such as WatershedComponents to an image."}
		},
		Input:>{
			{
				"imageRules",
				{
					Image-> _Image | _String | {_Image,_Image} | {_Image,_?MatrixQ},

					Type-> ImageDataTypeP
				},
				"The list of key/value pairs specifying the image, and conversion type involved in the Image primitive."
			}
		},
		Output:>{
			{"primitive",_Image,"A primitive for ImageAdjustment/ImageSegmentation options of AnalyzeCellCount containing information for how to convert image matrix to an actual image."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"AnalyzeCellCount",
			"ImageAdjust",
			"ImageMultiply"
		},
		Author->{"scicomp", "amir.saadat", "varoth.lilascharoen", "kevin.hou"}
	}
];
