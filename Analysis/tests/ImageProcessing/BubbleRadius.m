(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AnalyzeBubbleRadius*)


(* Define Tests *)
DefineTests[AnalyzeBubbleRadius,
	{
		(*** Basic Usage ***)
		Example[{Basic, "Compute the distribution of bubble radii for multiple data objects with foaming video data:"},
			AnalyzeBubbleRadius[{
				Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],
				Object[Data,DynamicFoamAnalysis,"large bubbles for tests"]
			}],
			{ObjectP[Object[Analysis,BubbleRadius]]..}
		],
		Example[{Basic, "Compute the distribution of bubble radii given a foaming video cloud file:"},
			AnalyzeBubbleRadius[videoCloudFile],
			ObjectP[Object[Analysis,BubbleRadius]]
		],
		Example[{Basic, "Load the processed video in output analysis object as a Mathematica animation:"},
			ImportCloudFile@Download[AnalyzeBubbleRadius[Object[Data,DynamicFoamAnalysis,"large bubbles for tests"]],AnalysisVideoPreview],
			_Manipulate
		],
		Example[{Basic, "Compute the distribution of bubble radii for a single data object with foaming video data:"},
			AnalyzeBubbleRadius[
				Object[Data,DynamicFoamAnalysis,"small bubbles for tests"]
			],
			ObjectP[Object[Analysis,BubbleRadius]]
		],
		Example[{Basic, "Generate a preview of the bubble radius analysis:"},
			AnalyzeBubbleRadius[Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],Output->Preview],
			TabView[{(_String->_Image|_Grid|_Deploy)..}, ___]
		],

		(*** Additional Examples ***)
		Example[{Additional, "Compute the distribution of bubble radii for all data objects in a DynamicFoamAnalysis protocol with foaming video data:"},
			AnalyzeBubbleRadius[
				Object[Protocol,DynamicFoamAnalysis,"Test protocol for AnalyzeBubbleRadius"]
			],
			{($Failed|ObjectP[Object[Analysis,BubbleRadius]])..},
			Messages:>{Error::NoFoamStructureAnalysis}
		],

		(*** Options ***)
		Example[{Options, ProgressBars, "Show progress bars during the computation:"},
			AnalyzeBubbleRadius[
				Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
				ProgressBars->True
			],
			ObjectP[Object[Analysis,BubbleRadius]]
		],
		Example[{Options, ProgressBars, "Hide progress bars during the computation:"},
			AnalyzeBubbleRadius[
				Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
				ProgressBars->False
			],
			ObjectP[Object[Analysis,BubbleRadius]]
		],
		Example[{Options, HistogramResizeFrequency, "Specify how frequently, in frames, the histogram in the output video should be vertically resized. Use HistogramResizeFrequency->1 to resize every frame:"},
			AnalyzeBubbleRadius[
				Object[Data,DynamicFoamAnalysis,"downsampled video for tests"],
				HistogramResizeFrequency->1,
				Output->Preview
			],
			TabView[{(_String->_Image|_Grid|_Deploy)..}, ___],
			TimeConstraint->360
		],
		Example[{Options, HistogramType, "Specify if the output video histogram should show bubble radii or areas:"},
			AnalyzeBubbleRadius[
				Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],
				HistogramType->Area,
				Output->Preview
			],
			TabView[{(_String->_Image|_Grid|_Deploy)..}, ___]
		],
		Example[{Options, MinimumBubbleRadius, "Set a minimum bubble radius below which bubbles will be excluded from analysis:"},
			AnalyzeBubbleRadius[
				Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
				MinimumBubbleRadius->200 Micrometer,
				Output->Preview
			],
			TabView[{(_String->_Image|_Grid|_Deploy)..}, ___]
		],
		Example[{Options, MaximumBubbleRadius, "Set a maximum bubble radius below which bubbles will be excluded from analysis:"},
			AnalyzeBubbleRadius[
				Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
				MaximumBubbleRadius->200 Micrometer,
				Output->Preview
			],
			TabView[{(_String->_Image|_Grid|_Deploy)..}, ___]
		],
		Example[{Options, Template, "Inherit resolved options from a template/existing analysis object:"},
			AnalyzeBubbleRadius[
				Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
				Template->Object[Analysis,BubbleRadius,"Template analysis for testing"],
				Output->Options
			],
			_?(MemberQ[#,(MinimumBubbleRadius->100 Micrometer)]&)
		],

		(*** Messages ***)
		Example[{Messages, "NoBubblesFound", "Warning will be shown if no bubbles could be found in any of the frames of the input foaming video:"},
			AnalyzeBubbleRadius[
				Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
				MinimumBubbleRadius->300 Micrometer,
				MaximumBubbleRadius->200 Micrometer
			],
			ObjectP[Object[Analysis,BubbleRadius]],
			Messages:>{Warning::NoBubblesFound}
		],
		Example[{Messages, "NoFoamStructureAnalysis", "Error is shown if the input data object does not have a foaming video associated with it, e.g. if the data was not collected using the foam structure analysis module:"},
			AnalyzeBubbleRadius[Object[Data,DynamicFoamAnalysis,"data with no foaming video"]],
			$Failed,
			Messages:>{Error::NoFoamStructureAnalysis}
		],
		Example[{Messages, "VideoNotConverted", "Error is shown if the input data object has a foaming video which has not yet been converted to a TIFF:"},
			AnalyzeBubbleRadius[Object[Data,DynamicFoamAnalysis,"data with unconverted video"]],
			$Failed,
			Messages:>{Error::VideoNotConverted}
		],
		Example[{Messages, "InvalidFoamingVideoFormat", "Error is shown if the input data object has a converted video file that does not resolve to a list of images, typically caused by invalid file formats:"},
			AnalyzeBubbleRadius[Object[Data,DynamicFoamAnalysis,"data with linked text file"]],
			$Failed,
			Messages:>{Error::InvalidFoamingVideoFormat}
		],
		Example[{Messages, "LongComputation", "Error shows if the computation time is expected to exceed ten minutes. Estimated time is computed based on the total number of video frames to process:"},
			True,
			True
		],

		(*** Known Issues ***)
		Example[{Issues,"Video Cropping","Bubbles which are partially covered by video overlay elements in the RawVideoFile, such as the scale bar and information box below, will be excluded from the analysis:"},
			ImportCloudFile[sampleImage],
			_Image
		],

		(*** Tests ***)
		Test["Index-matching on options works correctly:",
			AnalyzeBubbleRadius[
				{Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],Object[Data,DynamicFoamAnalysis,"large bubbles for tests"]},
				MinimumBubbleRadius -> 10 Micrometer,
				HistogramResizeFrequency -> {1, 10},
				Output -> Options
			],
			{
				MinimumBubbleRadius->Quantity[10,"Micrometers"],
				MaximumBubbleRadius->None,
				HistogramType->Radius,
				HistogramResizeFrequency->{1,10},
				ProgressBars->True,
				Template->Null
			}
		],
		Test["Correct bubble statistics with small bubbles:",
			Unitless@Lookup[
				stripAppendReplaceKeyHeads@AnalyzeBubbleRadius[
					Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],
					Upload->False
				],
				{AverageBubbleRadius,StandardDeviationBubbleRadius}
			],
			{
				{{0.25,41.5758},{0.5,45.3131},{0.75,47.8166},{1.0,49.028},{1.25,50.3194}},
				{{0.25,33.4879},{0.5,35.6771},{0.75,38.2976},{1.0,41.3024},{1.25,43.9248}}
			},
			EquivalenceFunction->RoundMatchQ[4]
		],
		Test["Correct bubble statistics with large bubbles:",
			Unitless@Lookup[
				stripAppendReplaceKeyHeads@AnalyzeBubbleRadius[
					Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
					Upload->False
				],
				{AverageBubbleRadius,StandardDeviationBubbleRadius}
			],
			{
				{{0.25,118.24},{0.5,127.136},{0.75,131.916},{1.0,141.181},{1.25,142.969}},
				{{0.25,112.2},{0.5,116.635},{0.75,121.196},{1.0,125.1},{1.25,129.012}}
			},
			EquivalenceFunction->RoundMatchQ[4]
		],
		Test["Correct bubble statistics with size exclusion options:",
			Unitless@Lookup[
				stripAppendReplaceKeyHeads@AnalyzeBubbleRadius[
					Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
					MinimumBubbleRadius->50.0 Micrometer,
					MaximumBubbleRadius->400.0 Micrometer,
					Upload->False
				],
				{AverageBubbleRadius,StandardDeviationBubbleRadius}
			],
			{
				{{0.25, 177.556}, {0.5, 185.192}, {0.75, 188.003}, {1., 193.987}, {1.25, 196.123}},
				{{0.25, 91.7514}, {0.5, 92.0116}, {0.75, 92.5004}, {1., 93.9757}, {1.25, 91.9831}}
			},
			EquivalenceFunction->RoundMatchQ[4]
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Define raw data for testing *)
	Variables:>{videoCloudFile,sampleImage},
	SymbolSetUp:>(ClearMemoization[];),
	SetUp:>(
		videoCloudFile=Download[Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],ConvertedVideoFile];
		sampleImage=Object[EmeraldCloudFile,"id:P5ZnEjdn1MOO"];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeBubbleRadiusOptions*)


(* Define Tests *)
DefineTests[AnalyzeBubbleRadiusOptions,
	{
		Example[{Basic, "Return the resolved options for a single data object with foaming video data:"},
			AnalyzeBubbleRadiusOptions[
				Object[Data,DynamicFoamAnalysis,"small bubbles for tests"]
			],
			_Grid
		],
		Example[{Basic, "Return the resolved options for multiple data objects with foaming video data:"},
			AnalyzeBubbleRadiusOptions[
				{
					Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],
					Object[Data,DynamicFoamAnalysis,"large bubbles for tests"]
				},
				MinimumBubbleRadius->{50 Micrometer, 100 Micrometer}
			],
			_Grid
		],
		Example[{Basic, "Return the resolved options for all data objects in a DynamicFoamAnalysis protocol with foaming video data:"},
			AnalyzeBubbleRadiusOptions[
				Object[Protocol,DynamicFoamAnalysis,"Test protocol for AnalyzeBubbleRadius"],
				HistogramResizeFrequency->{1,5,10}
			],
			_Grid
		],
		Example[{Basic, "Return the resolved options from passing a foaming video cloud file as input:"},
			AnalyzeBubbleRadiusOptions[videoCloudFile],
			_Grid
		],
		Example[{Options, OutputFormat, "By default, AnalyzeBubbleRadiusOptions returns a table:"},
			AnalyzeBubbleRadiusOptions[
				Object[Data, DynamicFoamAnalysis, "full video for tests"],
				OutputFormat->Table
			],
			_Grid
		],
		Example[{Options, OutputFormat, "Return the resolved options as a list:"},
			AnalyzeBubbleRadiusOptions[
				Object[Data, DynamicFoamAnalysis, "full video for tests"],
				OutputFormat->List
			],
			{
				MinimumBubbleRadius->None,
				MaximumBubbleRadius->None,
				HistogramType->Radius,
				HistogramResizeFrequency->5,
				ProgressBars->True,
				Template->Null
			}
		]
	},

	(* Assign a test user for objects *)
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Define raw data for testing *)
	Variables:>{videoCloudFile,sampleImage},
	SymbolSetUp:>(ClearMemoization[];),
	SetUp:>(
		videoCloudFile=Download[Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],ConvertedVideoFile];
		sampleImage=Object[EmeraldCloudFile,"id:P5ZnEjdn1MOO"];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeBubbleRadiusPreview*)


(* Define Tests *)
DefineTests[AnalyzeBubbleRadiusPreview,
	{
		Example[{Basic, "Show a preview of the analysis for a single data object with foaming video data:"},
			AnalyzeBubbleRadiusPreview[
				Object[Data,DynamicFoamAnalysis,"full video for tests"]
			],
			TabView[{(_String->_Image|_Grid|_Deploy)..}, ___],
			TimeConstraint->360
		],
		Example[{Basic, "Show a preview of the analysis for multiple data objects with foaming video data:"},
			AnalyzeBubbleRadiusPreview[
				{
					Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],
					Object[Data,DynamicFoamAnalysis,"large bubbles for tests"]
				},
				MinimumBubbleRadius->{50 Micrometer, 100 Micrometer}
			],
			TabView[{Rule[_String,TabView[{(_String->_Image|_Grid|_Deploy)..},___]]..},___]
		],
		Example[{Basic, "Show a preview of the analysis for all data objects in a DynamicFoamAnalysis protocol with foaming video data:"},
			AnalyzeBubbleRadiusPreview[
				Object[Protocol,DynamicFoamAnalysis,"Test protocol for AnalyzeBubbleRadius"],
				HistogramResizeFrequency->{10,5,1}
			],
			TabView[{Rule[_String,TabView[{$Failed}|{(_String->_Image|_Grid|_Deploy)..},___]]..},___],
			Messages:>{Error::NoFoamStructureAnalysis}
		],
		Example[{Basic, "Show a preview of the analysis for a foaming video cloud file:"},
			AnalyzeBubbleRadiusPreview[videoCloudFile],
			TabView[{(_String->_Image|_Grid|_Deploy)..}, ___]
		]
	},

	(* Assign a test user for objects *)
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Define raw data for testing *)
	Variables:>{videoCloudFile,sampleImage},
	SymbolSetUp:>(ClearMemoization[];),
	SetUp:>(
		videoCloudFile=Download[Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],ConvertedVideoFile];
		sampleImage=Object[EmeraldCloudFile,"id:P5ZnEjdn1MOO"];
	)
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeBubbleRadiusQ*)


(* Define Tests *)
DefineTests[ValidAnalyzeBubbleRadiusQ,
	{
		Example[{Basic, "Validate input of a single data object with foaming video data:"},
			ValidAnalyzeBubbleRadiusQ[
				Object[Data,DynamicFoamAnalysis,"small bubbles for tests"]
			],
			True
		],
		Example[{Basic, "Validate input of multiple data objects with foaming video data:"},
			ValidAnalyzeBubbleRadiusQ[
				{
					Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],
					Object[Data,DynamicFoamAnalysis,"large bubbles for tests"]
				},
				MinimumBubbleRadius->{50 Micrometer, 100 Micrometer}
			],
			True
		],
		Example[{Basic, "Validate input of a protocol with foaming data objects. Here, check that index-matched options have the correct length (must be single or match length of Data field):"},
			ValidAnalyzeBubbleRadiusQ[
				Object[Protocol,DynamicFoamAnalysis,"Test protocol for AnalyzeBubbleRadius"],
				HistogramResizeFrequency->{1,5,10,20}
			],
			False
		],
		Example[{Basic, "Validate video cloud file input:"},
			ValidAnalyzeBubbleRadiusQ[videoCloudFile],
			True
		],
		Example[{Options, OutputFormat, "By default, ValidAnalyzeBubbleRadiusQ returns a boolean:"},
			ValidAnalyzeBubbleRadiusQ[
				Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
				OutputFormat->Boolean
			],
			True
		],
		Example[{Options, OutputFormat, "Return an EmeraldTestSummary:"},
			ValidAnalyzeBubbleRadiusQ[
				Object[Data,DynamicFoamAnalysis,"large bubbles for tests"],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options, Verbose, "Print verbose output indicating test passage/failure for each test:"},
			ValidAnalyzeBubbleRadiusQ[
				Object[Data, DynamicFoamAnalysis, "data with unconverted video"],
				Verbose->True
			],
			False
		],
		Example[{Options, Verbose, "Print verbose messages for failures only:"},
			ValidAnalyzeBubbleRadiusQ[
				Object[Data, DynamicFoamAnalysis, "data with unconverted video"],
				Verbose->Failures
			],
			False
		]
	},

	(* Assign a test user for objects *)
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	(* Define raw data for testing *)
	Variables:>{videoCloudFile,sampleImage},
	SymbolSetUp:>(ClearMemoization[];),
	SetUp:>(
		videoCloudFile=Download[Object[Data,DynamicFoamAnalysis,"small bubbles for tests"],ConvertedVideoFile];
		sampleImage=Object[EmeraldCloudFile,"id:P5ZnEjdn1MOO"];
	)
];
