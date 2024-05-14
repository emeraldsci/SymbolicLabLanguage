(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*AnalyzeImageExposure*)

DefineTestsWithCompanions[
	AnalyzeImageExposure,
	{

		(* --- basic --- *)

		Example[{Basic, "Analyze a list of exposure times and images stored as EmeraldCloudFiles to create an ImageExposure Analysis Object:"},
			AnalyzeImageExposure[{Quantity[3, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:rea9jlavddRr"]]}],
			{ObjectP[Object[Analysis,ImageExposure]]}
		],
		Example[{Basic, "Analyze a PAGE data to create an ImageExposure Analysis Object:"},
			AnalyzeImageExposure[Object[Data, PAGE, "id:XnlV5jlNO41n"]],
			ObjectP[Object[Analysis,ImageExposure]]
		],
		Example[{Basic, "Directly analyze images with exposure times:"},
			AnalyzeImageExposure[{
				{Quantity[13, "Milliseconds"], Object[EmeraldCloudFile, "id:BYDOjvDKzzD9"]},
				{Quantity[9, "Milliseconds"], Object[EmeraldCloudFile, "id:9RdZXvdm441x"]}
			}],
			{ObjectP[Object[Analysis, ImageExposure]]}
		],
		Example[{Basic, "Analyze a list of image links to determine the optimal image:"},
			AnalyzeImageExposure[
				{
					{Quantity[5, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:jLq9jXqVzzva"]]},
					{Quantity[9, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:9RdZXvdm441x"]]},
			 		{Quantity[13, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:BYDOjvDKzzD9"]]},
			 		{Quantity[25, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:Z1lqpMl0nnlz"]]}
				}, Output->Preview]
				_TabView
		],

		Example[{Basic, "Given a list of improperly exposed images, suggest the next exposure time for image acquisition:"},
			AnalyzeImageExposure[{
				{Quantity[5, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:jLq9jXqVzzva"]]},
				{Quantity[17,	"Milliseconds"], Link[Object[EmeraldCloudFile, "id:M8n3rxnewwnG"]]},
				{Quantity[21,	"Milliseconds"],	Link[Object[EmeraldCloudFile, "id:n0k9mGkYnnk1"]]}
			},Output->Preview],
			_TabView
		],

		(* additional *)

		Example[{Additional, "Analyze a list of exposure times and images. If no acceptable images are found suggest a new exposure time:"},
			packet = AnalyzeImageExposure[{Quantity[3, "Milliseconds"], Object[EmeraldCloudFile, "id:rea9jlavddRr"]}, Upload -> False];
			Lookup[packet, SuggestedExposureTime],
			{Quantity[6.`3., "Milliseconds"]},
			Variables:>{packet}
		],
		Example[{Additional, "Analyze a list of image cloud file objects to determine the optimal image:"},
			packet = AnalyzeImageExposure[
				{
					{Quantity[5, "Milliseconds"], Object[EmeraldCloudFile, "id:jLq9jXqVzzva"]},
					{Quantity[9, "Milliseconds"], Object[EmeraldCloudFile, "id:9RdZXvdm441x"]},
					{Quantity[13, "Milliseconds"], Object[EmeraldCloudFile, "id:BYDOjvDKzzD9"]},
					{Quantity[25, "Milliseconds"], Object[EmeraldCloudFile, "id:Z1lqpMl0nnlz"]}
				},
				Upload -> False
			];
			Lookup[packet, Replace[AcceptableImages]],
			{{Link@Object[EmeraldCloudFile, "id:9RdZXvdm441x"]}},
			Variables:>{packet}
		],


		(* PAGE *)

		Example[{Additional, "Analyze a list of PAGE data:"},
			AnalyzeImageExposure[
				{Object[Data, PAGE, "id:4pO6dMOmj4wr"],
				Object[Data, PAGE, "id:Vrbp1jbvae5W"],
				Object[Data, PAGE, "id:XnlV5jlNO41n"]}],
			{ObjectP[Object[Analysis, ImageExposure]]..}
		],
		Example[{Additional, "Given a PAGE protocol, gel images are analyzed by default:"},
			AnalyzeImageExposure[Object[Protocol, PAGE, "id:wqW9BPWWYed9"]],
			ObjectP[Object[Analysis, ImageExposure]]
		],

		Example[{Additional, "Analyze a list of PAGE protocols:"},
			AnalyzeImageExposure[{Object[Protocol, PAGE, "id:N80DNj0r89V6"], Object[Protocol, PAGE, "id:9RdZXvdW0BoK"]}],
			{ObjectP[Object[Analysis, ImageExposure]]..}
		],

		(* --- options --- *)

		(* Upload *)
		Example[{Options, Upload, "Set Upload to False to return a packet:"},
			AnalyzeImageExposure[{Quantity[3, "Milliseconds"], Object[EmeraldCloudFile, "id:rea9jlavddRr"]},Upload->False],
			{_Association}
		],

		(* Output *)
		Example[{Options, Output, "Set Output to Options to return function options:"},
			AnalyzeImageExposure[{Quantity[3, "Milliseconds"], Object[EmeraldCloudFile, "id:rea9jlavddRr"]},Output->Options],
			_List
		],

		(* Output *)
		Example[{Options, Output,	"Set Output to Preview to show analysis results:"},
			AnalyzeImageExposure[{
				{Quantity[5, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:jLq9jXqVzzva"]]},
				{Quantity[9, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:9RdZXvdm441x"]]},
				{Quantity[13, "Milliseconds"],	Link[Object[EmeraldCloudFile, "id:BYDOjvDKzzD9"]]},
				{Quantity[25, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:Z1lqpMl0nnlz"]]}
			},Output -> Preview],
			_TabView
		],

		(* Crop *)
		Example[{Options, Crop, "Input image will be trimmed if crop coordinates are provided:"},
			AnalyzeImageExposure[{Quantity[3, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:rea9jlavddRr"]]},Crop->{{80, 70}, {2730, 1750}}],
			{ObjectP[Object[Analysis, ImageExposure]]}
		],

		(* ImageType *)
		Example[{Options, ImageType, "Specify BrightField image to be analyzed:"},
			AnalyzeImageExposure[{Quantity[3, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:rea9jlavddRr"]]},ImageType->BrightField],
			{ObjectP[Object[Analysis, ImageExposure]]}
		],

		(* UnderExposedPixelThreshold *)
		Example[{Options, UnderExposedPixelThreshold, "Change UnderExposedPixelThreshold from default of 0.5 to 0.2 to shift optimality criteria toward lighter images:"},
			AnalyzeImageExposure[
				{
					{Quantity[5, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:jLq9jXqVzzva"]]},
					{Quantity[9, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:9RdZXvdm441x"]]},
					{Quantity[13, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:BYDOjvDKzzD9"]]},
					{Quantity[25, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:Z1lqpMl0nnlz"]]}
				},
				UnderExposedPixelThreshold -> 0.2, Output -> Preview
			],
			_TabView
		],

		Example[{Options, UnderExposedPixelThreshold, "Change UnderExposedPixelThreshold from default of 0.5 to 0.8 to shift optimality criteria toward darker images:"},
			packet = AnalyzeImageExposure[
				{
					{Quantity[5, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:jLq9jXqVzzva"]]},
					{Quantity[9, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:9RdZXvdm441x"]]},
					{Quantity[13, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:BYDOjvDKzzD9"]]},
					{Quantity[25, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:Z1lqpMl0nnlz"]]}
				},
				UnderExposedPixelThreshold -> 0.8, Upload -> False
			];
			Lookup[packet, OptimalExposureTime],
			{Quantity[9, "Milliseconds"]},
			Variables:>{packet}
		],

		(* OverExposedPixelThreshold *)
		Example[{Options, OverExposedPixelThreshold, "Change OverExposedPixelThreshold from default of 0.05 to 0.01 to shift optimality criteria toward darker images:"},
			AnalyzeImageExposure[{
				{Quantity[5, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:jLq9jXqVzzva"]]},
				{Quantity[9, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:9RdZXvdm441x"]]},
				{Quantity[13, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:BYDOjvDKzzD9"]]}},
				OverExposedPixelThreshold -> 0.01, Output -> Preview],
			_TabView
		],

		Example[{Options, OverExposedPixelThreshold, "Change OverExposedPixelThreshold from default of 0.05 to 0.1 to shift optimality criteria toward lighter images:"},
			packet = AnalyzeImageExposure[{
				{Quantity[5, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:jLq9jXqVzzva"]]},
				{Quantity[9, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:9RdZXvdm441x"]]},
				{Quantity[13, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:BYDOjvDKzzD9"]]}},
				OverExposedPixelThreshold -> 0.1, Upload -> False],
			Lookup[packet, SuggestedExposureTime],
			{Quantity[13, "Milliseconds"]},
			Variables:>{packet}
		],

		(* Options for PAGE *)

		(* PAGE preview *)
		Example[{Options, Preview, "Set Output to Preview to show analysis result for a PAGE data:"},
			AnalyzeImageExposure[Object[Data, PAGE, "id:XnlV5jlNO41n"],	Output -> Preview],
			_TabView
		],

		(* PAGE list preview *)
		Example[{Options, Preview, "Preview analysis results for a list of PAGE data:"},
		AnalyzeImageExposure[
			{
				Object[Data, PAGE, "id:4pO6dMOmj4wr"],
				Object[Data, PAGE, "id:Vrbp1jbvae5W"],
				Object[Data, PAGE, "id:XnlV5jlNO41n"]
			}, Output -> Preview],
			_SlideView
		],

		(* PAGE protocol preview *)
		Example[{Options, Preview ,"Preview analysis results for a PAGE protocol:"},
			AnalyzeImageExposure[Object[Protocol, PAGE, "id:wqW9BPWWYed9"], Output -> Preview],
			_TabView
		],

		(* --- messages ---*)

		(* ProceedWithLongestExposureImage for PAGE  *)
		Example[{Messages ,"ProceedWithLongestExposureImage", "For PAGE data, if no image is properly exposed, throw a warning message and default to image with the longest exposure:"},
			AnalyzeImageExposure[Object[Data, PAGE, "id:vXl9j5lx0bJ5"]],
			ObjectP[Object[Analysis, ImageExposure]],
			Messages :> {Warning::ProceedWithLongestExposureImage}
		],
		Example[{Messages, "IncorrectOptimalityCriteria", "If optimality criteria values are improperly specified, an error message is thrown and function returns $Failed:"},
			AnalyzeImageExposure[{
				{Quantity[5, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:jLq9jXqVzzva"]]},
				{Quantity[9, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:9RdZXvdm441x"]]},
				{Quantity[13, "Milliseconds"], Link[Object[EmeraldCloudFile, "id:BYDOjvDKzzD9"]]}},
				UnderExposedPixelThreshold -> 0.1, OverExposedPixelThreshold -> 0.001],
			{$Failed},
			Messages :> {Error::IncorrectOptimalityCriteria}
		],
		Example[{Messages, "Pattern", "An out of bounds criteria value causes function to throw an error message and return $Failed:"},
			AnalyzeImageExposure[{Quantity[3, "Milliseconds"], Object[EmeraldCloudFile, "id:rea9jlavddRr"]},
				UnderExposedPixelThreshold -> 1.3],
			{$Failed},
			Messages :> {Error::Pattern}
		],
		Example[{Messages, "InputNotImages", "If an input EmeraldCloudFile is not an image, an error is thrown and function returns $Failed:"},
			AnalyzeImageExposure[{Quantity[13, "Milliseconds"], Object[EmeraldCloudFile, "Test file for AnalyzeImageExposure"<>$SessionUUID]}],
			{$Failed},
			Messages :> {Error::InputNotImages}
		],
		Example[{Messages, "EmptyDataField", "A message is thrown and function returns $Failed if one or more required data field is empty:"},
			AnalyzeImageExposure[Object[Data, Appearance, "id:M8n3rxnmjOwG"]],
			$Failed,
			Messages :> {Error::EmptyDataField}
		],

		(* Tests *)
		Tests["Find the dynamic ranges of a page protocol",
			packet = AnalyzeImageExposure[Object[Protocol, PAGE, "id:wqW9BPWWYed9"], Upload -> False];
			Lookup[packet, Replace[DynamicRanges]],
			{-36.15746264006664, -25.953527073127866, -14.595193369224884, -4.014661070865466},
			Variables:>{packet},
			EquivalenceFunction->RoundMatchQ[6]
		],

		Tests["Find the dynamic ranges of a page protocol",
			packet=AnalyzeImageExposure[
				{{Quantity[5,"Milliseconds"],Object[EmeraldCloudFile,"id:jLq9jXqVzzva"]},
					{Quantity[9,"Milliseconds"],Object[EmeraldCloudFile,"id:9RdZXvdm441x"]},
					{Quantity[13,"Milliseconds"],Object[EmeraldCloudFile,"id:BYDOjvDKzzD9"]},
					{Quantity[25,"Milliseconds"],Object[EmeraldCloudFile,"id:Z1lqpMl0nnlz"]}},
				Upload->False
			];
			Lookup[packet, Replace[OverExposedPixelFractions]],
			{{0.008037075946795706, 0.01781732171498046, 0.09143123736064496, 0.27558152402955527}},
			Variables:>{packet},
			EquivalenceFunction->RoundMatchQ[6]
		]
  },
	SymbolSetUp:>{
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
		If[DatabaseMemberQ[Object[EmeraldCloudFile, "Test file for AnalyzeImageExposure"<>$SessionUUID]],
			EraseObject[Object[EmeraldCloudFile, "Test file for AnalyzeImageExposure"<>$SessionUUID],Force->True, Verbose->False]
		];
		$CreatedObjects={};

		Upload[<|
			CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "71bc46effed544e6ff716ed55b5bfa48.txt", "9RdZXv1GmNB6F10kDAK3bbDKuPNM6lGP7xqO"],
			FileName -> "Test file for AnalyzeImageExposure",
			FileType -> "txt",
			Type -> Object[EmeraldCloudFile],
			Name -> "Test file for AnalyzeImageExposure"<>$SessionUUID
		|>,
			AllowPublicObjects->True
		]
	},

	SymbolTearDown :> {
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
	}
];
