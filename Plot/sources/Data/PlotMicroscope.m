(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotMicroscope*)


DefineOptions[PlotMicroscope,
	Options :> {

		(* Primary data *)
		{
			OptionName->PlotType,
			Default->Image,
			AllowNull->False,
			Description->"If Image, an image or grid of images will be generated. If BarChart, a chart of the cell counts or cell intensities will be generated, depending on the Display option.",
			Widget->Widget[Type->Enumeration,Pattern:>Image | BarChart],
			Category->"Hidden"
		},

		CacheOption,

		OutputOption
	},
	SharedOptions :> {
		ModifyOptions["Shared",ImageSelectOptions,
			{
				IndexMatching->None,
				IndexMatchingInput->Null,
				IndexMatchingParent->Null,
				IndexMatchingOptions->{}
			}
		],
		PlotImage,
		PlotCellCount,
		EmeraldBarChart,
		EmeraldPieChart
	}
];


Error::MissingImages="The Images field of the input `1` is Null or empty. Please make sure that this field is populated with the input images.";


(* --- Sample overloads --- *)
PlotMicroscope[cellMods:ListableP[ObjectP[Model[Sample]]],ops:OptionsPattern[]]:=Module[
	{cellImages,imagesToPlot},

	(* Download the images related to the sample *)
	cellImages = Download[ToList[First[Download[cellMods,Composition[[All,2]]]]],ReferenceImages];

	(* When given multiple reference images, we should only return the plot the last/most recent image of each input*)
	imagesToPlot = If[Length[#]>=1,
		Last[#],
		Null
	]&/@cellImages;

	(* Pass to core *)
	PlotMicroscope[imagesToPlot,ops]
];

PlotMicroscope[cellObjs:ListableP[ObjectP[Object[Sample]]],ops:OptionsPattern[]]:=Module[
	{cellImages,imagesToPlot},

	(* Download the images related to the sample *)
	cellImages = Cases[#,ObjectP[Object[Data,Microscope]]]&/@Download[ToList[cellObjs],Data];

	(* When given multiple data per object, we should only return the plot the last/most recent image of each input *)
	imagesToPlot = If[Length[#]>=1,
		Last[#],
		Null
	]&/@cellImages;

	(* Pass to core *)
	PlotMicroscope[imagesToPlot,ops]
];


(* --- Helper to pass off to correct form --- *)
PlotMicroscope[microscopeData:{ObjectP[Object[Data,Microscope]]..},opts:OptionsPattern[]]:=Module[
	{
		gatherTestsQ,plotType, imageSize,outputSpecification,output,
		safeOps,safeOpsTests,validLengthsQ,validLengthTests,channel,cache,imagePackets,suppliedCache,
		channelImages,objsMissingChannel,plots,returnedPlotOps,mergedReturnedOps,resolvedOps,
		imageSelectPackets, containsTiledImagesQ
	},

	(* Convert the original option into a list *)
	originalOps=ToList[opts];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps,safeOpsTests} = If[gatherTestsQ,
		SafeOptions[PlotMicroscope,ToList[opts],AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[PlotMicroscope,ToList[opts],AutoCorrect->False,Output->Result],{}}
	];

	(*If the specified options don't match their patterns return $Failed*)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengthsQ,validLengthTests}=If[gatherTestsQ,
		ValidInputLengthsQ[PlotMicroscope,{microscopeData},ToList[opts],Output->{Result,Tests}],
		{ValidInputLengthsQ[PlotMicroscope,{microscopeData},ToList[opts]],Null}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengthsQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* pull out some option values *)
	plotType = Lookup[safeOps,PlotType];
	channel = Lookup[safeOps,ImageChannel];

	imageSize = If[
		MatchQ[Lookup[safeOps,ImageSize],Automatic],
		600,
		Lookup[safeOps,ImageSize]
	];
	
	(* boolean to check if tiling parser was used *)
	containsTiledImagesQ = MemberQ[Keys[Select[microscopeData[[1]], Not[MatchQ[#, Null | {}]] &]], HighResolutionTiledImages];
	
	(* check if the length of the data is 1 and it contains HighResolutionTiledImages to redirect to the tiled overload *)
	If[MatchQ[Length[microscopeData], 1] && containsTiledImagesQ,
		Return[outputSpecification/.{
			Result|Preview -> interactiveMicroscope[microscopeData[[1]], safeOps],
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> safeOps
		}]
	];

	(* --- Download call ---  *)

	(* look up cache *)
	cache = Lookup[safeOps, Cache];

	(* Download relevant information *)
	(* this line fails FastDownload. Replace Download with KeyTake since there is no need for another download *)
	(* imagePackets = Download[microscopeData,Packet[Object,Images,PhaseContrastImage,FluorescenceImage,SecondaryFluorescenceImage,TertiaryFluorescenceImage,Scale]]; *)
  	imagePackets = KeyTake[microscopeData,{Object,Images,PhaseContrastImage,FluorescenceImage,SecondaryFluorescenceImage,TertiaryFluorescenceImage,Scale}];

	(* ammend the supplied cache *)
	suppliedCache = Join[cache,imagePackets];

	(* Store the images *)
	(* channelImages = Lookup[imagePackets,channel]; *)
	channelImages = Lookup[imagePackets,Images];

	(* If the requested channel is Null for any images, throw an Error *)
	If[MemberQ[channelImages,Null|{}],

		(* Determine which objects are missing images *)
		(* the following line failes when $FastDownload=True. Use Lookup instead of Download *)
		(* objsMissingChannel = Part[Download[microscopeData,Object],Flatten@Position[channelImages,Null|{}]]; *)
		objsMissingChannel = Part[Lookup[microscopeData, Object],Flatten@Position[channelImages,Null|{}]];

		(* Throw the message *)
		(* Message[Error::MissingImages,ToString[objsMissingChannel]];*)
		Message[Error::MissingImages,ToString[objsMissingChannel]];
		(* Return $Failed and optiosn *)
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Finding the image files based on the criteria based on the user options *)
	imageSelectPackets=Map[
		ECL`MicroscopeImageSelect[
			If[AssociationQ[#],Lookup[#,Object],#],
			PassOptions[PlotMicroscope,MicroscopeImageSelect,ReplaceRule[safeOps,{Output->Result}]]
		]&,
		microscopeData
	];

	{plots,returnedPlotOps}=Transpose@If[MatchQ[plotType,BarChart],

		(* pass off to PlotCellCount *)
		(* TODO: this part needs to be updated *)
		{PlotCellCount[microscopeData,PassOptions[PlotMicroscope,PlotCellCount,ReplaceRule[safeOps,{PlotType->Automatic,ImageSize->imageSize,Output->{Result,Options}}]]]},

		(* if we've got an image, then figure out which core function to pass off too *)
		Map[
			Function[
				imageSelectPacket,
				Module[
					{
						imageFiles,imageScales
					},
					(* The cloud file associated with the microscope images *)
					imageFiles=Lookup[imageSelectPacket,ImageFile];

					(* Assume the same image scale, that is the way we do now for PlotImage *)
					(* TODO: upgrade to take unequal x and y image scales *)
					imageScales=Lookup[imageSelectPacket,ImageScaleX];

					Transpose@MapThread[
						PlotImage[
							#1,
							PassOptions[PlotMicroscope,PlotImage,{ImageSize->imageSize,Scale->#2,Output->{Result,Options}}]
						]&,
						{imageFiles,imageScales}
					]
				]
			],
			imageSelectPackets
		]
	];

	(* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
	(* NOTE: we flatten the first level which corresponds to multiple images of an input *)
	mergedReturnedOps=MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,First@DeleteDuplicates[List@##]]&,Flatten[returnedPlotOps,1]];

	(* The final resolved options based on safeOps and the returned options from ELLP calls *)
	resolvedOps=ReplaceRule[safeOps,Prepend[mergedReturnedOps,Output->output]];

	(* Return the result, options, or tests according to the output option. *)
	outputSpecification/.{
		Result-> (
			If[Length[plots] == 1,
				(* The images of the first input *)
				If[Length[plots[[1]]]==1,
					First[plots[[1]]],
					SlideView[plots[[1]]]
				],
				(* SlideView if there are multiple images for each input *)
				(* Add the input name as the title using the Panel *)
				SlideView[
					MapThread[
						Function[
							{microscopeDataInput,inputPlot},
							Panel[
								If[Length[inputPlot]==1,
									First[inputPlot],
									SlideView[inputPlot]
								],
								ToString[If[AssociationQ[microscopeDataInput],Lookup[microscopeDataInput,Object],microscopeDataInput]]
							]
						],
						{microscopeData,plots}
					]
				]
			]
		),
		Preview->(
			If[Length[plots] == 1,
				(* The images of the first input *)
				If[Length[plots[[1]]]==1,
					First[plots[[1]]],
					SlideView[plots[[1]]]
				],
				SlideView[
					MapThread[
						Function[
							{microscopeDataInput,inputPlot},
							Panel[
								If[Length[inputPlot]==1,
									First[inputPlot],
									SlideView[inputPlot]
								],
								ToString[If[AssociationQ[microscopeDataInput],Lookup[microscopeDataInput,Object],microscopeDataInput]]
							]
						],
						{microscopeData,plots}
					]
				]
			]
		) /. If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{},
		Options->resolvedOps
	}

];


(* --- Superlistable --- *)
PlotMicroscope[microscopeData:{{PacketP[Object[Data,Microscope]]..}..},opts:OptionsPattern[]]:=Module[
	{
		originalOps,defaultedOptions,output,plotType,imageSize,plots,returnedPlotOps,mergedReturnedOps,resolvedOps
	},

	(* Convert the original option into a list *)
	originalOps=ToList[opts];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
	defaultedOptions = SafeOptions[PlotMicroscope, ToList[opts]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[defaultedOptions,Output];

	(* pull out some option values *)
	plotType = PlotType/.defaultedOptions;
	imageSize = ImageSize/.defaultedOptions;

	(* pass off to the appropriate core function *)
	{plots,returnedPlotOps}=If[MatchQ[plotType,BarChart],
		(* pass off to PlotCellCount *)
		{PlotCellCount[microscopeData,PassOptions[PlotMicroscope,PlotCellCount,ReplaceRule[defaultedOptions,{PlotType->Automatic,ImageSize->imageSize,Output->{Result,Options}}]]]},
		(* if we've got an image, then figure out which core function to pass off too *)
		PlotMicroscope[#,Sequence@@defaultedOptions,Output->{Result,Options}]&/@microscopeData
	];

	(* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
	mergedReturnedOps=MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,First@DeleteDuplicates[List@##]]&,returnedPlotOps];

	(* The final resolved options based on safeOps and the returned options from ELLP calls *)
	resolvedOps=ReplaceRule[defaultedOptions,Prepend[mergedReturnedOps,Output->output]];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result-> (If[Length[plots] == 1, First[plots], SlideView[plots]]),
		Preview->
			(
				If[Length[plots] == 1, First[plots], SlideView[plots]]
			) /.
			If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{},
		Options->resolvedOps
	}

];


(* --- ObjectP --- *)
PlotMicroscope[microscopeData:objectOrLinkP[Object[Data,Microscope]],opts:OptionsPattern[PlotMicroscope]]:=Module[{output},

	output=PlotMicroscope[ToList[Download[microscopeData]],opts];
	If[MatchQ[output,$Failed],
		$Failed,
		output
	]
];

PlotMicroscope[microscopeData:{objectOrLinkP[Object[Data,Microscope]]..},opts:OptionsPattern[PlotMicroscope]]:=
	PlotMicroscope[ToList[Download[microscopeData]],opts];

(* --- Single Packet --- *)
PlotMicroscope[microscopeData:PacketP[Object[Data,Microscope]],opts:OptionsPattern[PlotMicroscope]]:=Module[{output},
	output=PlotMicroscope[ToList[microscopeData],opts];
	If[MatchQ[output,$Failed],
		$Failed,
		output
	]
];


(* General catch all, particularly for objects that have no reference images or data associated with them *)
PlotMicroscope[ListableP[Null]|{},ops:OptionsPattern[PlotMicroscope]]:=Null;



(* Interactive Plot Microscope Helpers *)

(* global variables which control plot microscope *)
(* determines if low res images are "Byte ot Bit16" *)
$plotMicroscopeBitDepth = "Byte";
$plotMicroscopeBitDepthValue = If[MatchQ[$plotMicroscopeBitDepth , "Byte"], 8, 16];
$bitConversion := If[MatchQ[$plotMicroscopeBitDepth , "Byte"], 255, 65535];
$plotMicroscopeRawArrayFormat := If[MatchQ[$plotMicroscopeBitDepth , "Byte"], "UnsignedInteger8", "UnsignedInteger16"];

(* interactive plot microscope for tiled data objects *)
interactiveMicroscope[dataPacket_, ops:OptionsPattern[PlotMicroscope]]:=Module[
	{
		partitionedImages, lowResolutionTiledImages, objectiveMagnification, imageTimepoint, imageZStep,
		mode, excitationWavelength, emissionWavelength, imageFile, xRange, yRange, lowResolutionImages,
		modeContext, imageContext, imageArrayPositions, magnification, timePoint, zStacks, channels,
		imageArray, rasterBoxImages, imageSizeX, imageSizeY, imageScaleX, imageScaleY,
		wellCenterOffsetX, wellCenterOffsetY, meanDateAcquired, dichroicFilterWavelength,
		channelDisplay, channelTooltips, channelColors, channelColorReplacement, channelIndexColor,
		uniqueMeanDateAcquired, mediumResolutionTiledImages,
		unitlessImageScaleX, unitlessImageScaleY, unitlessWellCenterOffsetX, unitlessWellCenterOffsetY,
		unitlessImageSizeX, unitlessImageSizeY, zStepSize, highResolutionTiledImages,
		baseImages, mediumResolutionList, highResImages, baseIndex, plotTitle
	},
	
	(* pull out the partitioned and medium resolution images *)
	{
		lowResolutionTiledImages,
		mediumResolutionTiledImages,
		highResolutionTiledImages,
		partitionedImages,
		zStepSize
	} = Lookup[dataPacket,
		{
			LowResolutionTiledImages,
			MediumResolutionTiledImages,
			HighResolutionTiledImages,
			HighResolutionPartitionedImages,
			ZStepSize
		}
	];
	
	(* select the lowest populated resolution to be the base images *)
	{baseImages, baseIndex} = Which[
		Not[MatchQ[lowResolutionTiledImages, {}]],
			{lowResolutionTiledImages, 1},
		Not[MatchQ[mediumResolutionTiledImages, {}]],
			{mediumResolutionTiledImages, 2},
		True,
			{highResolutionTiledImages, 3}
	];
	
	(* pull info from lowest resolution images *)
	{
		objectiveMagnification, imageTimepoint, imageZStep,
		mode, excitationWavelength, emissionWavelength, dichroicFilterWavelength, imageFile,
		imageSizeX, imageSizeY, imageScaleX, imageScaleY,
		wellCenterOffsetX, wellCenterOffsetY, meanDateAcquired
	} = Transpose@Lookup[
		baseImages,
		{
			ObjectiveMagnification, ImageTimepoint, ImageZStep,
			Mode, ExcitationWavelength, EmissionWavelength, DichroicFilterWavelength, ImageFile,
			ImageSizeX, ImageSizeY, ImageScaleX, ImageScaleY,
			WellCenterOffsetX, WellCenterOffsetY, MeanDateAcquired
		}
	];
	
	(* dates images were takes *)
	uniqueMeanDateAcquired = DeleteDuplicates@meanDateAcquired;
	
	(* convert offset and scale to micrometers *)
	unitlessImageScaleX = Unitless@Convert[imageScaleX, Micrometer/Pixel];
	unitlessImageScaleY = Unitless@Convert[imageScaleY, Micrometer/Pixel];
	unitlessWellCenterOffsetX = Unitless@Convert[wellCenterOffsetX, Micrometer];
	unitlessWellCenterOffsetY = Unitless@Convert[wellCenterOffsetY, Micrometer];
	
	(* strip off units *)
	unitlessImageSizeX = Unitless@imageSizeX;
	unitlessImageSizeY = Unitless@imageSizeY;
	
	rangeFunction[scale_, size_, offset_]:=MapThread[
		{-#1*#2/2, #1*#2/2} + #3&,
		{scale, size, offset}
	];
	
	(* calculate x and y range *)
	xRange = rangeFunction[unitlessImageScaleX, unitlessImageSizeX, unitlessWellCenterOffsetX];
	yRange = rangeFunction[unitlessImageScaleY, unitlessImageSizeY, unitlessWellCenterOffsetY];
	
	(* download low resolution files *)
	lowResolutionImages = ImportCloudFile[imageFile];
(*	lowResolutionImages2 = lowResolutionImages;*)
	
(*	lowResolutionImages = lowResolutionImages2;*)
	
	(* combine the mode contexts to create channels *)
	modeContext = Transpose[{mode, excitationWavelength, dichroicFilterWavelength, emissionWavelength}];
	
	(* create a full image context of mag, time, z, and channel *)
	imageContext = Transpose[{objectiveMagnification, imageTimepoint, imageZStep, modeContext}];
	
	(* convert image context to indicies for quick lookup in the dynamic *)
	{imageArrayPositions, {magnification, timePoint, zStacks, channels}} = indexImageContext[imageContext];
	
	(* combine image context, ranges, and images into a list of medium resolution, if they are present *)
	mediumResolutionList = If[MatchQ[mediumResolutionTiledImages, {}] || Not[MatchQ[baseIndex, 1]],
		Null,
		(* lookup medium resolution image files *)
		Transpose@Lookup[mediumResolutionTiledImages, ImageFile];
		MapThread[
			{Sequence@@#1, #2, #3, #4}&,
			{imageArrayPositions, xRange, yRange, Lookup[mediumResolutionTiledImages, ImageFile]}
		]
	];
	
	(* convert empty partitioned images to Null *)
	partitionedImages = partitionedImages/.{}->Null;
	
	(* store info about medium and partitioned images, both will be Null if unused *)
	highResImages = {mediumResolutionList,partitionedImages};
	
	(* convert display to shorthand *)
	channelDisplay = channelShorthandNames/@channels;
	
	(* tooltip name helpers *)
	channelTooltipNames[{mode_, excitation_Quantity, dichroic_, emission_Quantity}]:= (
		ToString[mode] <> ", "<>
		cleanWavelength[excitation] <> " nm (Excitation Wavelength)/ " <>
		cleanWavelength[dichroic] <> " nm (Dichroic Wavelength)/ " <>
      	cleanWavelength[emission] <> " nm (Emission Wavelength)"
	);
	channelTooltipNames[{mode_, excitation_, dichroic_, emission_}]:= ToString[mode];
	
	(* get tooltip names *)
	channelTooltips = channelTooltipNames/@channels;
	
	(* get faux colors *)
	channelColors = List@@colorSelection[#]&/@channels;
	
	(* rules to replace channel, channel -> color and index -> color *)
	channelColorReplacement = Rule@@@Transpose[{channels, channelColors}];
	channelIndexColor = Rule@@@Transpose[{Range[Length[channels]], channelColors}];
	
	(* channels for the different modes for all tiled images *)
	channelColors = modeContext/.channelColorReplacement;
	
	(* baseImage array with indexes of mag, T, Z, and channel and values of contextImageAssoc *)
	imageArray = ConstantArray[1, Length/@{magnification, timePoint, zStacks, channels}];
	
	(* convert images to rasterboxes *)
	rasterBoxImages = MapThread[
		rasterBoxes,
		{lowResolutionImages, xRange, yRange, ConstantArray[1, Length[yRange]]}
    ];

	(* directly update image array *)
	MapThread[
		(imageArray[[Sequence@@#1]] = #2)&,
		{imageArrayPositions, rasterBoxImages}
	];
	
	(* Resolve the plot title to be the object if unspecified *)
	plotTitle = Lookup[ops, PlotLabel];
	plotTitle = If[MatchQ[plotTitle, Automatic|None],
		ToString[dataPacket[Object]],
		plotTitle
	];
	
	(* pass everything to the interactive framework *)
	Pane[
		ECL`SciCompFramework`PlotMicroscopeInteractiveImage[
			imageArray,
			highResImages,
			uniqueMeanDateAcquired,
			magnification,
			Convert[zStepSize, Micrometer],
			{channelDisplay, channelTooltips, channelIndexColor},
			(*
				The scaling is built in directly to the raster boxes,
				this scaling indicates to PlotMicroscopeInteractiveImage not to change it anymore
			*)
			"ImageScale" -> 1 Pixel/Micrometer,
			"ContentSize" -> 500,
			"ZoomMethod" -> {"Click", "Scroll"},
			"AutoDownsampling" -> False,
			(* default is True *)
			"PreserveAspectRatio" -> Lookup[ops, PreserveAspectRatio],
			"Title" -> plotTitle
		],
		Alignment -> Center
	]
	
];

(* color selection helper *)
colorSelection[{mode_, excitation_, dichroic_, emission_}]:=fauxColor[mode, QuantityMagnitude@excitation, QuantityMagnitude@dichroic, QuantityMagnitude@emission];
fauxColor[mode_, excitation_, dichroic_, emission_]:=ColorData["VisibleSpectrum"][Min[Max[emission, 400], 700]];
fauxColor[BrightField, _, _, _]:= RGBColor[0.7, 0.7, 0.7];
fauxColor[mode_, 405, 421, 452]:= RGBColor[0.3446448848402421`,0.`,1.`]; (* DAPI *)
fauxColor[mode_, 446, 445, 483]:= RGBColor[0.`,0.5671672227632978`,0.9608462062440879`]; (* CFP *)
fauxColor[mode_, 477, 488, 520]:= RGBColor[0.`,1.`,0.`]; (* FITC *)
fauxColor[mode_, 520, 520, 562]:= RGBColor[0.6287116860363728`,1.`,0.`]; (* YFP *)
fauxColor[mode_, 546, 564, 595]:= RGBColor[1.`,0.5592234773166501`,0.`]; (* TRITC *)
fauxColor[mode_, 546, 593, 624]:= RGBColor[1.`,0.`,0.`]; (* TexasRed *)
fauxColor[mode_, 546, 656, 692]:= RGBColor[0.4373335436311113`,0.`,0.`]; (* Cy3Cy5FRET *)
fauxColor[mode_, 638, 656, 692]:= RGBColor[0.4373335436311113`,0.`,0.`]; (* Cy5 *)
fauxColor[mode_, 749, 774, 819]:= RGBColor[0.`,0.`,0.`]; (* Cy7 *)

(* helpers to convert channels to shorthand or extra ex/em names for display *)
cleanWavelength[wavelength_]:=ToString[Round[wavelength]];
channelShorthandNames[{mode_, excitation_, dichroic_, emission_}]:= ToString[mode];
channelShorthandNames[{mode_, excitation_Quantity, dichroic_, emission_Quantity}]:= channelShorthands[{mode, Round@QuantityMagnitude@excitation, Round@QuantityMagnitude@dichroic, Round@QuantityMagnitude@emission}];
channelShorthands[{BrightField, _, _, _}]:= "BrightField";
channelShorthands[{mode_, 405, 421, 452}]:= "DAPI";
channelShorthands[{mode_, 446, 445, 483}]:= "CFP";
channelShorthands[{mode_, 477, 488, 520}]:= "FITC";
channelShorthands[{mode_, 520, 520, 562}]:= "YFP";
channelShorthands[{mode_, 546, 564, 595}]:= "TRITC";
channelShorthands[{mode_, 546, 593, 624}]:= "TexasRed";
channelShorthands[{mode_, 546, 656, 692}]:= "Cy3Cy5FRET";
channelShorthands[{mode_, 638, 656, 692}]:= "Cy5";
channelShorthands[{mode_, 749, 774, 819}]:= "Cy7";
channelShorthands[{mode_, excitation_?NumericQ, dichroic_, emission_?NumericQ}]:=cleanWavelength[excitation]<>" nm (Ex)/ "<>cleanWavelength[emission]<>" nm (Em)";
channelShorthands[{mode_, excitation_, dichroic_, emission_}]:=ToString[mode];

(* overload for RGBColor input that *)
rasterBoxes[image_, rangeX_, rangeY_, rgbColor_RGBColor]:= rasterBoxes[image, rangeX, rangeY, ToList[Sequence@@rgbColor]];

(* convert images to raster boxes *)
rasterBoxes[image_, rangeX_, rangeY_, rgbColor_]:=Module[
	{
		numericArray, boxDims, imageData
	},
	
	(* pull out the image data *)
	imageData = ImageData[image, $plotMicroscopeBitDepth, DataReversed -> True];
	
	(* for gray scale, just multiply the single scaler by the image data *)
	(* for RGB colors make three arrays and transpose them together *)
	imageData = If[MatchQ[Length[rgbColor], 0|1],
		imageData*rgbColor,
		Round[SciCompFramework`Private`convertNumericArrayColor[imageData, rgbColor]]
	];
	
	(* create a raster box, use Evaluate because arguments are held *)
	numericArray=RawArray[$plotMicroscopeRawArrayFormat,imageData];
	boxDims = Transpose@{Unitless[rangeX], Unitless[rangeY]};
	RasterBox[Evaluate@numericArray,Evaluate@boxDims, Evaluate@{0, $bitConversion}]
];

(* helper to index the image context (e.g., mag {4x, 9x} becomes {1,2}) *)
indexImageContext[imageContext_]:=Module[
	{
		magnificationSorted, timePointSorted, zStacksSorted, channelsSorted, transposedKeys,
		assocKeyPositions
	},
	
	(* extract context values, remove duplicates and sort *)
	{magnificationSorted, timePointSorted, zStacksSorted, channelsSorted}  = Array[Sort[DeleteDuplicates[imageContext[[;;,#]]]]&, 4];
	
	(* transpose the actual keys for indexing*)
	transposedKeys = Transpose@imageContext;
	
	(* keys values converted to indexes (e.g., mag {4x, 9x} becomes {1,2}) *)
	assocKeyPositions = MapThread[
		Function[{individualKey},Flatten@Position[#1,individualKey]]/@#2&,
		{{magnificationSorted, timePointSorted, zStacksSorted, channelsSorted}, transposedKeys}
	];
	
	(* combined indexes for each context value into a point in the array and return the sorted values *)
	{Join @@@ Transpose[assocKeyPositions], {magnificationSorted, timePointSorted, zStacksSorted, channelsSorted}}

];
