(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeMicroscopeOverlay*)


(* Updated options for Command Center *)
DefineOptions[AnalyzeMicroscopeOverlay,
	Options :> {
		IndexMatching[
			{
				OptionName -> BrightnessRed,
				Default -> 0,
				Description -> "The brightness adjustment for the red image.",
				AllowNull -> False,
				Category -> "Brightness",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[-1,1]
				]
			},
			{
				OptionName -> BrightnessGreen,
				Default -> 0,
				Description -> "The brightness adjustment for the green image.",
				AllowNull -> False,
				Category -> "Brightness",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[-1,1]
				]
			},
			{
				OptionName -> BrightnessBlue,
				Default -> 0,
				Description -> "The brightness adjustment for the blue image.",
				AllowNull -> False,
				Category -> "Brightness",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[-1,1]
				]
			},
			{
				OptionName -> ContrastRed,
				Default -> Automatic,
				Description -> "The contrast adjustment for the red image.",
				ResolutionDescription -> "Automatic resolves to the contrast of the initial red channel image, defined as the difference between the maximum and minimum pixel intensity of the image.",
				AllowNull -> False,
				Category -> "Contrast",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0,1]
				]
			},
			{
				OptionName -> ContrastGreen,
				Default -> Automatic,
				Description -> "The contrast adjustment for the green image.",
				ResolutionDescription -> "Automatic resolves to the contrast of the initial green channel image, defined as the difference between the maximum and minimum pixel intensity of the image.",
				AllowNull -> False,
				Category -> "Contrast",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0,1]
				]
			},
			{
				OptionName -> ContrastBlue,
				Default -> Automatic,
				Description -> "The contrast adjustment for the blue image.",
				ResolutionDescription -> "Automatic resolves to the contrast of the initial blue channel image, defined as the difference between the maximum and minimum pixel intensity of the image.",
				AllowNull -> False,
				Category -> "Contrast",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0,1]
				]
			},
			{
				OptionName -> FalseColorRed,
				Default -> RGBColor[1, 0, 0],
				Description -> "False color highlighting to use when overlaying the red fluorescence channel.",
				AllowNull -> False,
				Category -> "FalseColor",
				Widget -> Widget[
					Type -> Color,
					Pattern :> ColorP
				]
			},
			{
				OptionName -> FalseColorGreen,
				Default -> RGBColor[0, 1, 0],
				Description -> "False color highlighting to use when overlaying the green fluorescence channel.",
				AllowNull -> False,
				Category -> "FalseColor",
				Widget -> Widget[
					Type -> Color,
					Pattern :> ColorP
				]
			},
			{
				OptionName -> FalseColorBlue,
				Default -> RGBColor[0, 0, 1],
				Description -> "False color highlighting to use when overlaying the blue fluorescence channel.",
				AllowNull -> False,
				Category -> "FalseColor",
				Widget -> Widget[
					Type -> Color,
					Pattern :> ColorP
				]
			},
			{
				OptionName -> ChannelsOverlaid,
				Default -> Automatic,
				Description -> "List of image channels to be included in the overlay image. At least one fluorescent image must be specified.",
				ResolutionDescription -> "If Automatic, overlays all available images.",
				AllowNull -> False,
				Category -> "Others",
				Widget -> Widget[
					Type -> MultiSelect,
					Pattern :> DuplicateFreeListableP[Alternatives[Red, Green, Blue, PhaseContrast]]
				]
			},
			{
				OptionName -> Transparency,
				Default -> Automatic,
				Description -> "Transparency applied to flourescent image before being overlaid on phase contrast image. Transparency of 0 shows only fluorescent image, Transparency of 1 shows only phase contrast image.",
				ResolutionDescription -> "Transparency defaults to 0.5 when phase contrast image present, and otherwise defaults to 0.",
				AllowNull -> False,
				Category -> "Others",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0,1]
				]
			},
			IndexMatchingInput->"Microscope data"
		],
		AnalysisTemplateOption,
		OutputOption,
		UploadOption
	}
];


Warning::NoData = "There is no data provided in the given protocol(s) `1`.";
Warning::InvalidOverlayChannels = "At least one specified channel for the ChannelsOverlaid option of object(s) `1` is invalid. Please only include channels that are present in the given data object(s). Attempting to use any available specified channels.";
Error::NoData = "There is no data at all. Please add protocols or data objects with actual data.";
Error::NoFluorescentChannel = "At least one fluorescent channel must be included in overlay when PhaseContrast image is used. Please include a fluorescent channel to be displayed via the ChannelsOverlaid for object(s) `1`.";
Error::NoOverlayChannels = "At least one valid channel must be specified in ChannelsOverlaid option. Please include at least one valid channel in the ChannelsOverlaid option for object(s) `1`.";


(* ::Subsubsection:: *)
(*AnalyzeMicroscopeOverlay*)


(* Handle the no input case *)
AnalyzeMicroscopeOverlay[Alternatives[Null,{}], myOptions:OptionsPattern[AnalyzeMicroscopeOverlay]] := Module[{listedOptions,outputSpecification,output},
	listedOptions=ToList[myOptions];
	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[listedOptions,Output,Result];
	outputSpecification/.{Alternatives[Result, Options, Preview, Tests] -> Null}
];

(* Preprocessing -- Handle the case of mixed protocol objects and data objects input *)
AnalyzeMicroscopeOverlay[myInput:ListableP[Alternatives[ObjectP[Object[Protocol,Microscope]],ObjectP[Object[Data,Microscope]]]], myOptions:OptionsPattern[AnalyzeMicroscopeOverlay]] := Module[
	{
		listedInput,listedOptions,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,protocolObjects,protocolDataObjects,dataObjectMap,
		noDataProtocolsWarning,mapThreadedOptions,objects,expandedInputs,expandedOptions,finalDataObjects,expandedOptionValues,noDataTest,
		noDataBool,combinedDataOptions,collapsedIndexMatchedOptions,finalDataOptions,mainFunctionOutput
	},

	(* Usual ToList stuff *)
	listedInput=ToList[myInput];
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[listedOptions,Output,Result];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[AnalyzeMicroscopeOverlay,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[AnalyzeMicroscopeOverlay,listedOptions,AutoCorrect->False],Null}
	];

	(* Expand our options *)
	{expandedInputs,expandedOptions}=ExpandIndexMatchedInputs[AnalyzeMicroscopeOverlay,{listedInput},safeOptions,Messages->False];

	(* Get all of our protocol objects from our input. *)
	protocolObjects=Cases[listedInput,ObjectP[Object[Protocol,Microscope]]];
	(* Download data objects from our protocols. *)
	protocolDataObjects=Download[protocolObjects,Data];
	(* Create a map between our protocol object and the respective data objects. *)
	dataObjectMap=MapThread[#1->#2&,{protocolObjects,protocolDataObjects}];

	noDataProtocolsWarning = Module[{noDataProtocols},
		(* Get any protocols without data *)
		noDataProtocols = Select[protocolObjects, MatchQ[# /. dataObjectMap, {}] &];
		If[Length[Flatten[noDataProtocols]]>0,
			If[!gatherTests,Message[Warning::NoData,Flatten[noDataProtocols]]];
			Warning["All protocols have data objects.", True, False],
			Warning["All protocols have data objects.", True, True]
		]
	];

	(* Create a mapthread version of our options. *)
	mapThreadedOptions=OptionsHandling`Private`mapThreadOptions[AnalyzeMicroscopeOverlay,expandedOptions];

	(* Expand our options from protocol to data. *)
	expandedOptionValues=MapThread[
		(* Leave options alone if given a data object, if given a protocol object, lookup the data objects in the map and expand. *)
		Function[{input,options},
			If[MatchQ[input,ObjectP[Object[Protocol,Microscope]]],
				{Last@ExpandIndexMatchedInputs[AnalyzeMicroscopeOverlay,{input/.dataObjectMap},Normal[options],Messages->False]},
				{Normal[options]}
			]
		],
		{listedInput,mapThreadedOptions}
	];

	(* Get the final list of data objects that we will send to the main function *)
	finalDataObjects=Flatten[listedInput/.dataObjectMap];

	(* Start checking if there's no data objects supplied at all *)
	(* Create and gather tests if necessary *)
	noDataBool = Length[finalDataObjects]==0;
	noDataTest = If[noDataBool,
		Test["There is at least one data object input.", True, False],
		Test["There is at least one data object input.", True, True]
	];
	If[noDataBool&&!gatherTests,
		Message[Error::NoData];
		Return[$Failed]
	];

	(* For the data options, we combine all the values for the same key under one key *)
	combinedDataOptions = If[noDataBool,
		{},
		Module[{indexMatchedOptions},
			indexMatchedOptions = Join@@expandedOptionValues;
			Keys[#][[1]] -> Flatten@Values[#]&/@Transpose[indexMatchedOptions]
		]
	];

	(* Convert expanded options back to singletons *)
	collapsedIndexMatchedOptions=CollapseIndexMatchedOptions[AnalyzeMicroscopeOverlay,combinedDataOptions,Messages->False];
	(* Collapse the non-index-matched options *)
	finalDataOptions=collapsedIndexMatchedOptions/.{
		Rule[x : Alternatives[Template, Upload], y_List] :> Rule[x, First[y]],
		Rule[x : Output, y_List] :> Rule[x, outputSpecification]
	};

	(* Call the main function that will give us the output we want *)
	mainFunctionOutput = AnalyzeMicroscopeOverlay[finalDataObjects,finalDataOptions];
	(* Check if we are gathering tests, if so, add the noDataTest to the main function output and return the new output *)
	If[gatherTests,
		Which[
			(* If we only specify tests, i.e. Output->Tests, we have one case for when there are no tests returned from the main function *)
			MatchQ[outputSpecification,Tests]&&MatchQ[mainFunctionOutput,Null],{noDataTest,noDataProtocolsWarning},
			(* We have another case for when there are returned tests from the main functions *)
			MatchQ[outputSpecification,Tests],Join[mainFunctionOutput,{noDataTest,noDataProtocolsWarning}],
			(* If there are other specified options, e.g. Output->{Tests,Result}, then we have to insert the noDataTest *)
			True, Module[{testsIndex,listedOutput,originalTests,newTests},
			(* Get the index of the Tests in the output list *)
			testsIndex = First@FirstPosition[output,Tests];
			(* Should be in a list already, but just to be safe and then shorten the name *)
			listedOutput = ToList[mainFunctionOutput];
			originalTests = listedOutput[[testsIndex]];
			(* Consolidate the tests *)
			newTests = Join[originalTests,{noDataTest,noDataProtocolsWarning}];
			(* Modify the tests *)
			listedOutput[[testsIndex]] = newTests;
			listedOutput
		]
		],
		(* Else, just return the main function output *)
		mainFunctionOutput
	]
];

(* Main function *)
AnalyzeMicroscopeOverlay[myData:ListableP[ObjectP[Object[Data,Microscope]]], myOptions:OptionsPattern[AnalyzeMicroscopeOverlay]] := Module[
	{
		listedOptions,listedData,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,validLengths,validLengthTests,
		suppliedCache,downloadedPackets,cache,updatedOptions,unresolvedOptions,templateTests,combinedOptions,resolvedOptionsResult,
		resolvedOptionTests,resolvedOptionsTestResult,resolvedOptions,resolvedOptionsTests,previewRule,optionsRule,dataPacket,testsRule,resultRule
	},

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
		SafeOptions[AnalyzeMicroscopeOverlay,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[AnalyzeMicroscopeOverlay,listedOptions,AutoCorrect->False],Null}
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[AnalyzeMicroscopeOverlay,{listedData},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[AnalyzeMicroscopeOverlay,{listedData},listedOptions],Null}
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
	downloadedPackets=Download[
		listedData,
		Packet[
			PhaseContrastImageFile,FluorescenceImageFile,SecondaryFluorescenceImageFile,
			TertiaryFluorescenceImageFile,EmissionWavelength, SecondaryEmissionWavelength,
			TertiaryEmissionWavelength],
		Cache->suppliedCache
	];
	cache=Join[suppliedCache,Flatten[downloadedPackets]];

	(* Use any template options to get values for options not specified in myOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[AnalyzeMicroscopeOverlay,{listedData},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[AnalyzeMicroscopeOverlay,{listedData},listedOptions],{}}
	];

	combinedOptions=ReplaceRule[safeOptions, unresolvedOptions];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests} = resolveAnalyzeMicroscopeOverlayOptions[listedData,combinedOptions,Output->{Result,Tests},Cache->cache];
		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"AnalyzeMicroscopeOverlay"->resolvedOptionsTests|>,OutputFormat->Boolean,Verbose->False]["AnalyzeMicroscopeOverlay"],
			True,
			$Failed
		],

		(* We are not gathering tests. Check for Errors and return $Failed if necessary *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveAnalyzeMicroscopeOverlayOptions[listedData,combinedOptions,Output->Result,Cache->cache],{}},
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
		Join[safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests],
		Null
	];

	(* Prepare the upload packets if either Preview or Result is specified *)
	dataPacket = If[MemberQ[output,Alternatives[Preview,Result]],
		Module[
			{
				packet,redImages,greenImages,blueImages,pcImages,objects,expandedOptions,images,
				blueBrightness, greenBrightness, redBrightness,blueContrast, greenContrast, redContrast,blueFalseColor,
				greenFalseColor, redFalseColor, transparency, channelsOverlaid
			},

			(* Obtain all the microscope images *)
			{redImages,greenImages,blueImages,pcImages} = getAllMicroscopeImages[downloadedPackets];

			(* Expand index matched options to lists that match the specified input length *)
			{objects,expandedOptions} = ExpandIndexMatchedInputs[AnalyzeMicroscopeOverlay,{listedData},resolvedOptions,Messages->False];

			images = calculateMicroscopeOverlayImage[{redImages,greenImages,blueImages,pcImages},expandedOptions];

			(* Obtain lists of the specified options *)
			{
				blueBrightness,
				greenBrightness,
				redBrightness,
				blueContrast,
				greenContrast,
				redContrast,
				blueFalseColor,
				greenFalseColor,
				redFalseColor,
				transparency,
				channelsOverlaid
			} = Lookup[expandedOptions,
				{
					BrightnessBlue,
					BrightnessGreen,
					BrightnessRed,
					ContrastBlue,
					ContrastGreen,
					ContrastRed,
					FalseColorBlue,
					FalseColorGreen,
					FalseColorRed,
					Transparency,
					ChannelsOverlaid
				}
			];

			(* Return a list of packets *)
			MapThread[
				<|
					Type -> Object[Analysis, MicroscopeOverlay],
					UnresolvedOptions -> unresolvedOptions,
					ResolvedOptions -> resolvedOptions,
					Append[Reference] -> {Link[#1, MicroscopeOverlay]},
					BrightnessBlue -> #2,
					BrightnessGreen -> #3,
					BrightnessRed -> #4,
					ContrastBlue -> #5,
					ContrastGreen -> #6,
					ContrastRed -> #7,
					FalseColorBlue -> #8,
					FalseColorGreen -> #9,
					FalseColorRed -> #10,
					Transparency -> #11,
					Replace[ChannelsOverlaid]->#12,
					Overlay :> #13,
					OverlayFile -> Link[UploadCloudFile[#13,Name->"Overlay File"]]
					|>&,
				{
					listedData, blueBrightness, greenBrightness, redBrightness, blueContrast, greenContrast, redContrast,
					blueFalseColor, greenFalseColor, redFalseColor, transparency, channelsOverlaid, images
				}
			]
		],
		Null
	];

  (* Prepare the Preview result if we were asked to do so *)
  previewRule=Preview->If[MemberQ[output,Preview],
    Module[{plots},
      plots = ECL`PlotMicroscopeOverlay /@ dataPacket;
      If[Length[plots] === 1, First[plots], SlideView[plots]]
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


(* ::Subsubsection:: *)
(*resolveAnalyzeMicroscopeOverlayOptions*)


resolveAnalyzeMicroscopeOverlayOptions[myInput:ListableP[ObjectP[Object[Data, Microscope]]],myAnalyzeOptions_List,myOptions:OptionsPattern[]]:=Module[
	{
		objects,expandedOptions,cache,listedData,protocolPacket,output,redImage,greenImage,blueImage,pcImage,testsQ,resolveImageContrast,resolvedContrastRed,resolvedContrastGreen,resolvedContrastBlue,desiredImageChannels,
		availableImageChannels,imageChannelsMismatches,channelsOverlaidWarning,resolvedChannelsOverlaid,resolveMicroscopeOverlayTransparency,noOverlayChannelsObjects,noOverlayChannelsTest,noFluorescentChannelsObjects,noFluorescentChannelsTest,
		resolvedTransparency,resolvedOptions,collapsedOptions,testRule,resultRule,invalidInputs,invalidOptions
	},

	(* Lookup our supplied cache. *)
	cache = Lookup[{myOptions},Cache,{}];

	(* Convert to list if not already a list. *)
	listedData=Download[
		ToList[myInput],
		Packet[
			PhaseContrastImageFile,FluorescenceImageFile,SecondaryFluorescenceImageFile,
			TertiaryFluorescenceImageFile,EmissionWavelength, SecondaryEmissionWavelength,
			TertiaryEmissionWavelength],
		Cache->cache
	];

	(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
	{objects,expandedOptions} = ExpandIndexMatchedInputs[AnalyzeMicroscopeOverlay,{ToList[myInput]},myAnalyzeOptions,Messages->False];

	output=Lookup[{myOptions},Output];

	(* Obtain all the microscope images in a list for each image channel *)
	{redImage, greenImage, blueImage, pcImage} = getAllMicroscopeImages[listedData];

	(* See if we're gathering tests. *)
	testsQ=MemberQ[ToList[Lookup[{myOptions},Output,{}]],Tests];

	(* Resolve all options. *)
	(* Resolve Contrast for all three colors {ContrastRed,ContrastGreen,ContrastBlue} by taking the difference between the min and the max values in each image *)
	resolveImageContrast[Null, myOption_] := 0;
	resolveImageContrast[myImage_Image, myOption_] := If[MatchQ[myOption, Automatic], First[Differences[MinMax[Flatten[ImageData[myImage]]]]], myOption];
	resolvedContrastRed = MapThread[resolveImageContrast[#1, #2] &, {redImage, Lookup[expandedOptions, ContrastRed]}];
	resolvedContrastGreen = MapThread[resolveImageContrast[#1, #2] &, {greenImage, Lookup[expandedOptions, ContrastGreen]}];
	resolvedContrastBlue = MapThread[resolveImageContrast[#1, #2] &, {blueImage, Lookup[expandedOptions, ContrastBlue]}];

	desiredImageChannels = Lookup[expandedOptions,ChannelsOverlaid];
	(* From lists of image of each color, we convert into a boolean of each image type for each Data object, and based on that pick the available channels for each type *)
	availableImageChannels = MapThread[Pick[{Red,Green,Blue,PhaseContrast},({##}/.{Null->False,_Image->True})]&,{redImage,greenImage,blueImage,pcImage}];

	(* Get the image channels mismatches and the resolved ChannelsOverlaid options *)
	{imageChannelsMismatches,resolvedChannelsOverlaid} = Transpose@MapThread[
		Function[{availableChannels, desiredChannels, dataPacket},
			Which[
				(* If desiredChannels is Automatic, we give the available channels so no mismatch *)
				MatchQ[desiredChannels,Automatic],{{},availableChannels},
				(* If desiredChannels is not a subset of availableChannels, this is problem, return the dataPacket and the intersection between desired and available channels *)
				!MatchQ[Complement[desiredChannels,availableChannels],{}],{{dataPacket[Object]},Intersection[availableChannels, desiredChannels]},
				(* Else, the desired channels are valid, hence no mismatch *)
				True,{{},desiredChannels}
			]
		],
		{availableImageChannels,desiredImageChannels,listedData}
	];
	channelsOverlaidWarning = If[Length[Flatten[imageChannelsMismatches]]>0,
		If[!testsQ,Message[Warning::InvalidOverlayChannels,Flatten[imageChannelsMismatches]]];
		Warning["The OverlayChannels for all data entries are valid.", True, False],
		Warning["The OverlayChannels for all data entries are valid.", True, True]
	];

	(* Resolve Transparency according to option definitions *)
	resolvedTransparency = MapThread[
		Function[{myVal,myImage},
		Which[
			!MatchQ[myVal,Automatic],myVal,
			MatchQ[myImage,Null],0,
			True,0.5
		]
		],{Lookup[expandedOptions, Transparency], pcImage}];

	resolvedOptions = {
		Output->Lookup[expandedOptions,Output],
		BrightnessRed->Lookup[expandedOptions,BrightnessRed],
		BrightnessGreen->Lookup[expandedOptions,BrightnessGreen],
		BrightnessBlue->Lookup[expandedOptions,BrightnessBlue],
		ContrastRed->resolvedContrastRed,
		ContrastGreen->resolvedContrastGreen,
		ContrastBlue->resolvedContrastBlue,
		FalseColorRed->Lookup[expandedOptions,FalseColorRed],
		FalseColorGreen->Lookup[expandedOptions,FalseColorGreen],
		FalseColorBlue->Lookup[expandedOptions,FalseColorBlue],
		ChannelsOverlaid->resolvedChannelsOverlaid,
		Transparency->resolvedTransparency,
		Upload->Lookup[expandedOptions,Upload]
	};

	(* Convert expanded options back to singletons whenever possible to display clean values to the user (e.g. OptionName\[Rule]A, not OptionName\[Rule]{A,A,A,A,...})*)
	collapsedOptions=CollapseIndexMatchedOptions[AnalyzeMicroscopeOverlay,resolvedOptions,Messages->False];

	(* Do the remaining tests *)

	(* Get the objects without any channels in ChannelsOverlaid *)
	noOverlayChannelsObjects = MapThread[
		Function[{resolvedChannels,dataPacket},
			If[MatchQ[resolvedChannels,{}],
				{dataPacket[Object]},
				{}
			]
		],
		{resolvedChannelsOverlaid,listedData}
	];

	noOverlayChannelsTest = Module[{},
		If[Length[Flatten[noOverlayChannelsObjects]]>0,
			If[!testsQ,Message[Error::NoOverlayChannels,Flatten[noOverlayChannelsObjects]]];
			Test["There is at least one overlay channel for all data entries.", True, False],
			Test["There is at least one overlay channel for all data entries.", True, True]
		]
	];

	(* Get the objects without any fluorescence channels in ChannelsOverlaid *)
	noFluorescentChannelsObjects = MapThread[
		Function[{resolvedChannels,dataPacket},
			If[MatchQ[resolvedChannels,{PhaseContrast}],
				{dataPacket[Object]},
				{}
			]
		],
		{resolvedChannelsOverlaid,listedData}
	];

	noFluorescentChannelsTest = Module[{},
		If[Length[Flatten[noFluorescentChannelsObjects]]>0,
			If[!testsQ,Message[Error::NoFluorescentChannel,Flatten[noFluorescentChannelsObjects]]];
			Test["There is at least one fluorescent channel for all data entries.", True, False],
			Test["There is at least one fluorescent channel for all data entries.", True, True]
		]
	];

	(* Return the requested values *)
	(* Construct the Tests output (Null if Tests weren't requested) *)
	testRule=Tests->If[testsQ,
		{noOverlayChannelsTest,noFluorescentChannelsTest,channelsOverlaidWarning},
		{}
	];

	(* Gather our resolved options. *)
	resultRule=Result->collapsedOptions;

	(* Throw Error::InvalidInput/Error::InvalidOption. *)
	invalidInputs=Flatten[{noOverlayChannelsObjects,noFluorescentChannelsObjects}];
	invalidOptions=Flatten[If[Length[invalidInputs]>0,{ChannelsOverlaid},{}]];

	If[!testsQ&&Length[invalidInputs]>0,
		Message[Error::InvalidInput,ECL`InternalUpload`ObjectToString[invalidInputs,Cache->cache]];
	];
	If[!testsQ&&Length[invalidOptions]>0,
		Message[Error::InvalidOption,invalidOptions];
	];

	(* Return our output. *)
	output/.{testRule,resultRule}
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


(* ::Subsubsection:: *)
(*getAllMicroscopeImages*)


(* Get all the microscope images and sort according to their capture wavelength *)
getAllMicroscopeImages[myPackets:ListableP[PacketP[Object[Data, Microscope]]]] := Module[
	{
		listedPackets, imgsPC, imgs1, imgs2, imgs3, wavelength1, wavelength2, wavelength3,
		wavelengthColorRules, wavelengthImageRules, imageColorRulesFunction, rgbImageMatrix
	},
	listedPackets=ToList[myPackets];

	(* TODO Change this to reverse listable once we can parallel ImportCloudFile stuff. *)
	imgsPC = importOrNull[PhaseContrastImageFile /. listedPackets];
	imgs1 = importOrNull[FluorescenceImageFile /. listedPackets];
	imgs2 = importOrNull[SecondaryFluorescenceImageFile /. listedPackets];
	imgs3 = importOrNull[TertiaryFluorescenceImageFile /. listedPackets];

	(* Get the wavelengths *)
	{wavelength1, wavelength2, wavelength3} = Transpose[{EmissionWavelength, SecondaryEmissionWavelength, TertiaryEmissionWavelength} /. listedPackets];

	(* Mapping wavelength to color *)
	wavelengthColorRules = {
		620.*Nanometer -> Red,
		525.*Nanometer -> Green,
		460.*Nanometer -> Blue
	};

	(* Mapping wavelength to their images *)
	wavelengthImageRules = Transpose@{
		MapThread[Rule, {wavelength1, imgs1}],
		MapThread[Rule, {wavelength2, imgs2}],
		MapThread[Rule, {wavelength3, imgs3}]
	};

	(* For each row of wavelengthImageRules, first convert into rules of Color->Image, then a list of Images in the order {Red, Green, Blue} with value Null for data without the corresponding image color	*)
	imageColorRulesFunction[wavelengthImageRow_, wavelengthColorRules_] := Module[{colorImageRules},
		colorImageRules = Map[Rule[First[#] /. wavelengthColorRules, Last[#]] &, wavelengthImageRow];
		Replace[{Red, Green, Blue}, Append[colorImageRules, _ -> Null], {1}]
	];

	(* Each row of this matrix corresponds to images taken from one color *)
	rgbImageMatrix = Transpose@Map[imageColorRulesFunction[#, wavelengthColorRules]&, wavelengthImageRules];

	(* Add the phase contrast images as another row *)
	Append[rgbImageMatrix, imgsPC]
];


(* ::Subsubsection:: *)
(*calculateMicroscopeOverlayImage*)


calculateMicroscopeOverlayImage[{myRedImage_,myGreenImage_,myBlueImage_,myPCImage_},resolvedOptions_List] := Module[
	{
		listedRedImage,listedGreenImage,listedBlueImage,listedpcImage,redChannelBool, greenChannelBool, blueChannelBool, PCChannelBool,
		brightnessRed, brightnessGreen, brightnessBlue, contrastRed, contrastGreen, contrastBlue, falseColorRed, falseColorGreen, falseColorBlue, transparency,
		processOneChannel, threeChannelsSeparated, threeChannelsMerged, threeChannelsFinal
	},
	(* Get the images to list if not already *)
	{listedRedImage,listedGreenImage,listedBlueImage,listedpcImage}=ToList/@{myRedImage,myGreenImage,myBlueImage,myPCImage};

	(* Get lists of booleans if the particular channel should be included in the overlay *)
	{redChannelBool, greenChannelBool, blueChannelBool, PCChannelBool} = Module[{channelsOverlaid},
		channelsOverlaid=Lookup[resolvedOptions,ChannelsOverlaid];
		Transpose[
			Replace[
				{Red,Green,Blue,PhaseContrast},
				Append[Thread[Rule[#,True]],_->False],
				{1}
			]&/@channelsOverlaid
		]
	];

	(* Get the required values, the input resolvedOptions should already be expanded *)
	{
		brightnessRed, brightnessGreen, brightnessBlue,
		contrastRed, contrastGreen, contrastBlue,
		falseColorRed, falseColorGreen, falseColorBlue
	} = Lookup[resolvedOptions, {BrightnessRed, BrightnessGreen, BrightnessBlue, ContrastRed, ContrastGreen, ContrastBlue, FalseColorRed, FalseColorGreen, FalseColorBlue}];

	(* To process a channel, we adjust brightness contrast, and false color based on the image requirements. Return Null if channel is Null or if channelOverlayBool is False *)
	processOneChannel = Function[
		{channelOverlayBool, image, brightness, contrast, falseColor},
		MapThread[Module[{imageData, adjustedBrightnessContrast, adjustedColor},
			If[Or[!#1,MatchQ[#2,Null]],
				Null,
				imageData = ImageData[#2];
				adjustedBrightnessContrast = adjustImageBrightnessAndContrast[imageData, #3, #4];
				adjustedColor = adjustImageColor[adjustedBrightnessContrast, #5];
				ColorCombine[Image /@adjustedColor, "RGB"]
			]]&,
			{channelOverlayBool, image, brightness, contrast, falseColor}
		]
	];

	(* Process each of the three channels within each data object separately *)
	threeChannelsSeparated = MapThread[
		processOneChannel,
		{
			{redChannelBool, greenChannelBool, blueChannelBool},
			{listedRedImage, listedGreenImage, listedBlueImage},
			{brightnessRed, brightnessGreen, brightnessBlue},
			{contrastRed, contrastGreen, contrastBlue},
			{falseColorRed, falseColorGreen, falseColorBlue}
		}
	];

	(* Merge the three channels by first deleting Null channels, if all channels are Null, return Null for that data object *)
	threeChannelsMerged = MapThread[Module[{nonNullImages},
		nonNullImages = DeleteCases[{##}, Null];
		If[nonNullImages =!= {}, ImageAdd[nonNullImages]]]&,
		threeChannelsSeparated];

	(* Adjusted to the specified transparency option *)
	transparency = Lookup[resolvedOptions, Transparency];
	threeChannelsFinal = MapThread[
		If[MatchQ[Head[#1],Image],SetAlphaChannel[#1, 1 - #2]]&,
		{threeChannelsMerged,transparency}
	];

	MapThread[
		Which[
			(* If we do not have any of the luminescent channels, we return an empty image *)
			MatchQ[{#1,#2,#3,#4},Alternatives[{False,False,False,False},{False,False,False,True}]],
			Image[Show[Graphics[{}],ImageSize->550]],
			(* If we have a phase contrast layer, we return it merged with the threeChannelsFinal image *)
			#4,
			Image[Show[#5, #6, ImageSize->550]],
			(* Else return just the threeChannelsFinal image *)
			True,
			Image[Show[#6,ImageSize->550]]
		]&,
		{
			redChannelBool,
			greenChannelBool,
			blueChannelBool,
			PCChannelBool,
			myPCImage,
			threeChannelsFinal
		}
	]
];


(* ::Subsubsection:: *)
(*adjustImageBrightnessAndContrast*)


(* brightness \in[-0.5, 0.5], contrast \in [0, 1] *)
(* Matrix in, Matrix out *)
adjustImageBrightnessAndContrast[imgData_, brightness_, contrast_] := Module[
	{brightnessAdj, adjustedBrightness, minIntensity, maxIntensity, intensityDifference, minIntensityAfter, maxIntensityAfter, contrastAdj},
	(* Adjust the brightness of each pixel subject to a min of 0 and a max of 1 *)
	brightnessAdj = Min[1, Max[0, # + brightness]] &;
	adjustedBrightness = Map[brightnessAdj, imgData, {2}];

	{minIntensity, maxIntensity} = MinMax[adjustedBrightness];
	intensityDifference = maxIntensity - minIntensity;

	(* Figure out the new min and maxIntensity *)
	minIntensityAfter = If[intensityDifference <= contrast,
		(* If intensityDifference <= contrast, we need to scale up the intensity, doing this math will give a positive value *)
		minIntensity * ((1 - contrast) / (1 - intensityDifference)),
		(* If intensityDifference > contrast, we need to scale down the intensity, doing this math will give a positive value *)
		0.5 - (0.5 - minIntensity) * (contrast / intensityDifference)
	];
	maxIntensityAfter = minIntensityAfter + contrast;

	(* Do the contrast adjustment *)
	contrastAdj = (# - minIntensity) / (maxIntensity - minIntensity) * (maxIntensityAfter - minIntensityAfter) + minIntensityAfter &;
	Map[contrastAdj, adjustedBrightness, {2}]
];


(* ::Subsubsection:: *)
(*adjustImageColor*)


(* Matrix in, Matrix out *)
adjustImageColor[imgData_, falseColor_] := Module[
	{redChannel, greenChannel, blueChannel, colorList},
	(* Convert from RGB color into a list of (r,g,b) values *)
	colorList = falseColor /. RGBColor -> List;

	(* Determines the relative intensity of each color for each pixel *)
	redChannel = Map[# * colorList[[1]] &, imgData, {2}];
	greenChannel = Map[# * colorList[[2]] &, imgData, {2}];
	blueChannel = Map[# * colorList[[3]] &, imgData, {2}];
	{redChannel, greenChannel, blueChannel}
];


(* ::Subsection:: *)
(*AnalyzeMicroscopeOverlayOptions*)


DefineOptions[AnalyzeMicroscopeOverlayOptions,
	SharedOptions :> {AnalyzeMicroscopeOverlay}
];

AnalyzeMicroscopeOverlayOptions[myInput:ListableP[Alternatives[ObjectP[Object[Protocol,Microscope]],ObjectP[Object[Data,Microscope]]]], myOptions:OptionsPattern[AnalyzeMicroscopeOverlayOptions]]:=Module[{},
	AnalyzeMicroscopeOverlay[myInput,Append[ToList[myOptions],Output->Options]]
];


(* ::Subsection:: *)
(*AnalyzeMicroscopeOverlayPreview*)


DefineOptions[AnalyzeMicroscopeOverlayPreview,
	SharedOptions :> {AnalyzeMicroscopeOverlay}
];

AnalyzeMicroscopeOverlayPreview[myInput:ListableP[Alternatives[ObjectP[Object[Protocol,Microscope]],ObjectP[Object[Data,Microscope]]]], myOptions:OptionsPattern[AnalyzeMicroscopeOverlayPreview]]:=Module[{},
	AnalyzeMicroscopeOverlay[myInput,Append[ToList[myOptions],Output->Preview]]
];


(* ::Subsection:: *)
(*ValidAnalyzeMicroscopeOverlayQ*)


DefineOptions[ValidAnalyzeMicroscopeOverlayQ,
	Options :> {
		{
			OptionName -> Verbose,
			Default -> False,
			Description -> "Specify if we should have a verbose output.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[True,False]
			]
		},
		{
			OptionName -> OutputFormat,
			Default -> Boolean,
			Description -> "Determines the output format.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[Boolean,TestSummary]
			]
		}
	},
	SharedOptions :> {AnalyzeMicroscopeOverlay}
];

ValidAnalyzeMicroscopeOverlayQ[myInput:ListableP[Alternatives[ObjectP[Object[Data, Microscope]],ObjectP[Object[Protocol, Microscope]]]], myOptions:OptionsPattern[ValidAnalyzeMicroscopeOverlayQ]] :=
		Module[{listedInput,listedOptions,preparedOptions,functionTests,initialTestDescription,allTests,verbose,outputFormat,ranAllTests},

			listedInput=ToList[myInput];
			listedOptions=ToList[myOptions];

			(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
			preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

			(* Call the function to get a list of tests *)
			functionTests=AnalyzeMicroscopeOverlay[listedInput,preparedOptions];

			initialTestDescription="All provided options and inputs match their provided patterns and match their appropriate lengths (no further testing can proceed if this test fails):";

			(* This segment is taken from the Command Builder Framework *)
			allTests=If[MatchQ[functionTests,$Failed],
				{Test[initialTestDescription,False,True]},
				Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
					initialTest=Test[initialTestDescription,True,True];

					(* Create warnings for invalid objects *)
					validObjectBooleans=ValidObjectQ[listedInput,OutputFormat->Boolean];
					voqWarnings=MapThread[
						Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
							#2,
							True
						]&,
						{listedInput,validObjectBooleans}
					];
					(* Get all the tests/warnings *)
					Join[{},functionTests,voqWarnings]
				]
			];

			(* Run the tests as requested *)
			verbose=Lookup[listedOptions,Verbose,False];
			outputFormat=Lookup[listedOptions,OutputFormat,Boolean];
			Lookup[RunUnitTest[<|"ValidAnalyzeMicroscopeOverlayQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidAnalyzeMicroscopeOverlayQ"]
		];
