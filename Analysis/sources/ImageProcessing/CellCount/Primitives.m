(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ------------------------------- *)
(* --- Common Helper Functions --- *)
(* ------------------------------- *)

(* ::Subsection:: *)
(* Common Helper Functions *)

(* ::Subsubsection:: *)
(* checkPrimitivesPattern *)

(* Helper function to run an pattern checking on a list of primitives for a single input *)
checkPrimitivesPattern[
	myFunction_Symbol,
	myPrimitives_List,
	primitiveSetInformation_,
	allPrimitiveInformation_,
	primitiveHeads_
]:=Module[

	{
		invalidPrimitiveHeadsWithIndices,invalidPrimitiveOptionKeysWithIndices,invalidPrimitiveOptionPatternsWithIndices,
		invalidPrimitiveRequiredOptionsWithIndices
	},

	(* Keep track of invalid primitives to throw messages about. *)
	invalidPrimitiveHeadsWithIndices={};
	invalidPrimitiveOptionKeysWithIndices={};
	invalidPrimitiveOptionPatternsWithIndices={};
	invalidPrimitiveRequiredOptionsWithIndices={};

	(* Go through each of our primitives and check them. *)
	MapThread[
		Function[{currentPrimitive, primitiveIndex},
			Module[{primitiveDefinition},
				(* Get the definition for this primitive, within the primitive set. *)
				primitiveDefinition=Lookup[allPrimitiveInformation, Head[currentPrimitive]];

				Which[
					(* First, check that the primitive head exists in our primitive set. *)
					!MatchQ[Head[currentPrimitive], Alternatives@@primitiveHeads],
						AppendTo[invalidPrimitiveHeadsWithIndices, {Head[currentPrimitive], primitiveIndex}],

					(* Next, make sure that for the primitive head that we have, all the options match their pattern. *)
					(* NOTE: We specifically form the primitive pattern for each primitive set to only include the options that relate *)
					(* to that primtiive set (for each primitive). So, we can first just do a pattern match to see if all the options are okay. *)
					!MatchQ[currentPrimitive, Lookup[primitiveDefinition, Pattern]],
						Module[{invalidOptionKeys, invalidOptionPatterns, requiredOptions, missingRequiredOptions},
							(* Get any options that don't exist in the primitive definition. *)
							invalidOptionKeys=Complement[
								Keys[currentPrimitive[[1]]],
								Flatten[{Lookup[Lookup[primitiveDefinition, OptionDefinition], "OptionSymbol"], PrimitiveMethod, PrimitiveMethodIndex}]
							];

							If[Length[invalidOptionKeys]>0,
								AppendTo[invalidPrimitiveOptionKeysWithIndices, {invalidOptionKeys, primitiveIndex, Head[currentPrimitive]}];
							];

							(* Get any options that don't match their pattern. *)
							invalidOptionPatterns=KeyValueMap[
								Function[{option, value},
									Module[{optionPattern},
										(* Get the pattern for this option. If the option doesn't exist in the definition, just skip over it because it *)
										(* will be covered by our invalidOptionKeys check. *)
										optionPattern=ReleaseHold@Lookup[
											FirstCase[Lookup[primitiveDefinition, OptionDefinition], KeyValuePattern["OptionSymbol"->option], <|"Pattern"->_|>],
											"Pattern"
										];

										If[!MatchQ[value, optionPattern],
											option,
											Nothing
										]
									]
								],
								currentPrimitive[[1]]
							];

							If[Length[invalidOptionPatterns]>0,
								AppendTo[invalidPrimitiveOptionPatternsWithIndices, {invalidOptionPatterns, primitiveIndex, Head[currentPrimitive]}];
							];

							(* Detect if we are missing required options. *)
							requiredOptions=Lookup[Cases[Lookup[primitiveDefinition, OptionDefinition], KeyValuePattern["Required"->True]], "OptionSymbol", {}];

							missingRequiredOptions=Complement[requiredOptions, Keys[currentPrimitive[[1]]]];

							If[Length[missingRequiredOptions]>0,
								AppendTo[invalidPrimitiveRequiredOptionsWithIndices, {missingRequiredOptions, primitiveIndex, Head[currentPrimitive]}];
							];
						],

					(* All of the primitives look good! *)
					True,
						Null
				]
			]
		],
		{myPrimitives, Range[Length[myPrimitives]]}
	];

	(* If we encountered any bad primitives, yell about them and return $Failed. *)
	If[Length[invalidPrimitiveHeadsWithIndices]>0,
		Message[Error::InvalidUnitOperationHeads, invalidPrimitiveHeadsWithIndices[[All,1]], invalidPrimitiveHeadsWithIndices[[All,2]], myFunction];
	];

	If[Length[invalidPrimitiveOptionKeysWithIndices]>0,
		Message[Error::InvalidUnitOperationOptions, invalidPrimitiveOptionKeysWithIndices[[All,1]], invalidPrimitiveOptionKeysWithIndices[[All,2]], invalidPrimitiveOptionKeysWithIndices[[All,3]], myFunction];
	];

	If[Length[invalidPrimitiveOptionPatternsWithIndices]>0,
		Message[Error::InvalidUnitOperationValues, invalidPrimitiveOptionPatternsWithIndices[[All,1]], invalidPrimitiveOptionPatternsWithIndices[[All,2]], invalidPrimitiveOptionPatternsWithIndices[[All,3]], myFunction];
	];

	If[Length[invalidPrimitiveRequiredOptionsWithIndices]>0,
		Message[Error::InvalidUnitOperationRequiredOptions, invalidPrimitiveRequiredOptionsWithIndices[[All,1]], invalidPrimitiveRequiredOptionsWithIndices[[All,2]], invalidPrimitiveRequiredOptionsWithIndices[[All,3]], myFunction];
	];

	If[Or[
			Length[invalidPrimitiveHeadsWithIndices]>0,
			Length[invalidPrimitiveOptionKeysWithIndices]>0,
			Length[invalidPrimitiveOptionPatternsWithIndices]>0,
			Length[invalidPrimitiveRequiredOptionsWithIndices]>0
		],

		Return[$Failed];
	];

];

(* ::Subsubsection:: *)
(* checkPrimitivesLabel *)

(* Helper function to run an pattern checking on a list of primitives for a single input *)
checkPrimitivesLabel[
	myFunction_Symbol,
	myPrimitives_List,
	primitiveSetInformation_,
	allPrimitiveInformation_,
	primitiveHeads_
]:=Module[

	{
		availableOutputImageLabels,invalidPrimitiveLabelsWithIndices
	},

	(* Initialize all available output image labels with the reference image *)
	(* For ImageAdjustment, only "Reference Image" is already available while "ImageAdjustment Result" is also available for ImageSegmentation steps *)
	availableOutputImageLabels=Switch[myFunction,
		ImageAdjustment,
			{"Reference Image"},
		ImageSegmentation,
			{"Reference Image","ImageAdjustment Result"}
	];

	(* Keep track of invalid primitives to throw messages about. *)
	invalidPrimitiveLabelsWithIndices={};

	(* Go through each of our primitives and check them. *)
	MapThread[
		Function[{currentPrimitive, primitiveIndex},
			Module[{primitiveAssociation,outputImageLable,primitiveDefinition,region,image,secondImage,bitMultiply,marker},

				(* Convert to association for better handling *)
				primitiveAssociation=Association@@currentPrimitive;

				(* Search for the Image we will use the label if the image is a string *)
				image=Lookup[primitiveAssociation, Image];

				(* Search the image label we will keep track of the labels in order *)
				outputImageLabel=Lookup[primitiveAssociation, OutputImageLabel, Null];

				(* Get the definition for this primitive, within the primitive set. *)
				If[StringQ[image] && !MemberQ[availableOutputImageLabels,image],
					(* If we don't have the label add the primitive to the list of invalid ones *)
					AppendTo[
						invalidPrimitiveLabelsWithIndices,{currentPrimitive, primitiveIndex, image}
					]
				];

				(** Exceptional cases where we check the labels **)

				secondImage=Lookup[primitiveAssociation, SecondImage, Null];

				(* ImageMultiply SecondImage field *)
				If[MatchQ[Head[primitiveAssociation],ImageMultiply],

					(* Get the definition for this primitive, within the primitive set. *)
					If[StringQ[secondImage] && !MemberQ[availableOutputImageLabels,secondImage],
						(* If we don't have the label add the primitive to the list of invalid ones *)
						AppendTo[
							invalidPrimitiveLabelsWithIndices,{currentPrimitive, primitiveIndex, secondImage}
						]
					]
				];

				bitMultiply=Lookup[primitiveAssociation, BitMultiply,Null];
				marker=Lookup[primitiveAssociation, Marker,Null];

				(* WatershedComponents BitMultiply field *)
				If[MatchQ[Head[primitiveAssociation],WatershedComponents],

					(* Get the definition for this primitive, within the primitive set. *)
					If[StringQ[bitMultiply] && !MemberQ[availableOutputImageLabels,bitMultiply],
						(* If we don't have the label add the primitive to the list of invalid ones *)
						AppendTo[
							invalidPrimitiveLabelsWithIndices,{currentPrimitive, primitiveIndex, bitMultiply}
						]
					];

					(* Get the definition for this primitive, within the primitive set. *)
					If[StringQ[marker] && !MemberQ[availableOutputImageLabels,marker],
						(* If we don't have the label add the primitive to the list of invalid ones *)
						AppendTo[
							invalidPrimitiveLabelsWithIndices,{currentPrimitive, primitiveIndex, marker}
						]
					]

				];

				region=Lookup[primitiveAssociation, Region, Null];

				(* Inpaint Region field *)
				If[MatchQ[Head[primitiveAssociation],Inpaint],

					(* Get the definition for this primitive, within the primitive set. *)
					If[StringQ[region] && !MemberQ[availableOutputImageLabels,region],
						(* If we don't have the label add the primitive to the list of invalid ones *)
						AppendTo[
							invalidPrimitiveLabelsWithIndices,{currentPrimitive, primitiveIndex, region}
						]
					]
				];

				(* If the output label is given add it to the avaialable list of labels *)
				If[!MatchQ[outputImageLabel,Null],
					AppendTo[
						availableOutputImageLabels,outputImageLabel
					]
				]

			]
		],
		{myPrimitives, Range[Length[myPrimitives]]}
	];

	(* If we encountered any bad primitives, yell about them and return $Failed. *)
	If[Length[invalidPrimitiveLabelsWithIndices]>0,
		Message[Error::InvalidPrimitiveLabels, invalidPrimitiveLabelsWithIndices[[All,1]], invalidPrimitiveLabelsWithIndices[[All,2]], myFunction, invalidPrimitiveLabelsWithIndices[[All,3]]];
	];

	If[Length[invalidPrimitiveLabelsWithIndices]>0,

		Return[$Failed];
	];

];


(* ::Subsubsection:: *)
(* Messages *)

Error::InvalidUnitOperationHeads="The following primitive types, `1`, at indices, `2`, are not allowed primitive types for `3`. Please consult the documentation for `3` or construct your analysis call in the command builder.";
Error::InvalidUnitOperationOptions="The following options, `1`, at indices, `2`, are not valid options for the primitives, `3`, in `4`. Please only specify valid options for the primitives chosen.";
Error::InvalidUnitOperationValues="The following options, `1`, at indices, `2`, do not match the allowed pattern for the primitives, `3`, in `4`. Please make sure that these options match their allowed patterns for `3`.";
Error::InvalidUnitOperationRequiredOptions="The following options, `1`, are required to specify a valid `3` primitive at indices, `2`, for `4`. Please specify these options in order to specify a valid analysis.";
Error::InvalidPrimitiveLabels="The following primitive types, `1`, at indices, `2` of primitive option `3` is using the label `4` which is not in the list of available labels. Please double check the spelling of the specified label(s).";
Error::IncompleteMicroscopeImageKeys="The keys provided for MicroscopeImage primitive of Images field for input `1` is missing the following keys: `2`. Please either provide these values using MicroscopeImage primitive of Images option or use ImageSelect primitive of ImageSelection option to pick a subset of images.";
Warning::UnusedProperty="The Property, OrderingCount, and OrderingFunction is unused for the primitive `1` of input `2`. If Criteria field is specified for the SelectComponents primitive, the Property, OrderingCount, and OrderingFunction fields will be set to Null.";
Warning::UnusedComponentProperty="The Property is unused for the primitive `1` of input `2`. If Criteria field is specified for the SelectComponents primitive, the Property field will be set to Null.";
Error::NoImagesFound="No images found based on the ImageSelection option and Images options for input `1`. Please check the fields ImageSelection and Images for availabe imaging modes in the input data object.";
Error::InvalidImagesPrimitive="No images were found for input `1` based on the primive `2`. Please check all images of the data object by using ImageSelection->Preview in the analysis function or from the Images field of the data object.";

(* ------------------------------------------------------- *)
(* --- Update MM Image Functions to Support Primitives --- *)
(* ------------------------------------------------------- *)

suppressImageMessages[]:=Module[
	{},
	(* Quieting mathematica invalid input messages *)
	Once[Get[FileNameJoin[{System`Private`$MessagesDir, $Language, "Messages.m"}]]];
	Map[
		Function[functionName,
			(* All the known messages *)
			Off[functionName::imginv];Off[functionName::argr];Off[functionName::argt];Off[functionName::arg1];Off[functionName::argrx];Off[functionName::argtu];Off[functionName::argb];Off[functionName::argbu];Off[functionName::optx];
			Switch[functionName,
				Image,
					Off[functionName::imgarray];Unprotect[Image]
			];
			(* All messages we get from the notebook listed in the top *)
			Messages[functionName]=ReplaceAll[Messages[functionName],RuleDelayed[left_,right_] :> If[!MatchQ[right,$Off[___]],RuleDelayed[left,$Off[right]],RuleDelayed[left,right]]]
		],
		{
			Image,ImageAdjust,Binarize,ColorSeparate,ColorNegate,GradientFilter,GaussianFilter,LaplacianGaussianFilter,BilateralFilter,
			StandardDeviationFilter,MorphologicalBinarize,TopHatTransform,BottomHatTransform,HistogramTransform,FillingTransform,
			BrightnessEqualize,ImageMultiply,RidgeFilter,ImageTrim,EdgeDetect,Erosion,Dilation,Closing,Opening,Inpaint,
			DistanceTransform,MinDetect,MaxDetect,WatershedComponents,MorphologicalComponents,SelectComponents
		}
	]
];

(* Since the symbols are in System` context, we need to OnLoad them to recover them after .mx file generation *)

suppressImageMessages[];

OnLoad[
	suppressImageMessages[]
];



(* Finding all of the messages associated with *)

(* -------------------------------- *)
(* --- Resolving ImageSelection --- *)
(* -------------------------------- *)


(* ::Subsection:: *)
(* resolveImageSelectionPrimitives *)

DefineOptions[resolveImageSelectionPrimitives,
	Options:>{
    OutputOption
	},
	SharedOptions:>{
	}
];

resolveImageSelectionPrimitives[
  myInputs:{ObjectP[Object[Data,Microscope]]..},
  myExpandedOptions:{(_Rule|_RuleDelayed)..},
  myAdjustmentOptions:OptionsPattern[resolveImageSelectionPrimitives]
]:=Module[

	{
    outputSpecification,output,testsQ,
    allMapThreadedOptions,allResolvedOptions,allResolvedPrimitives,
		resultRule,testsRule
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* See if we're gathering tests. *)
	testsQ=MemberQ[output,Tests];

	(* create a mapthread version of our options *)
	allMapThreadedOptions=OptionsHandling`Private`mapThreadOptions[AnalyzeCellCount,myExpandedOptions];

	(* Mapping over all of the inputs with their options *)
	{allResolvedOptions,allResolvedPrimitives,allTests}=Transpose@MapThread[
		Function[
			{myInput,inputIndex,mapThreadOptions},
			Module[
				{
					imageSelectionOption,imageSelectionPrimitives,
					(* for error checking *)
					primitiveSetInformation,allPrimitiveInformation,primitiveHeads,
					(* for resolving primitives *)
					shorthandPrimitives,resultRule,finalPrimitives,
					(* for running tests *)
					validPritimivePatternTest,validPritimiveLabelTest,allPrimitiveTests,testsRule,
					resolvedImageSelectionPrimitives
				},

				(** Find Primitives **)

				(* Finding the image adjustment in the resolved option - Convert to association for better handling *)
				imageSelectionOption=Lookup[mapThreadOptions,ImageSelection];

				(* Make sure that a singlet primitive is listed not to break mapping *)
				imageSelectionPrimitives=ToList[imageSelectionOption];

				(* Lookup information about our primitive set from our backend association. *)
				primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ImageSelectionPrimitiveP]];
				allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
				primitiveHeads=Keys[allPrimitiveInformation];

				(* Set all of the automatic image adjustment based on the other option *)
				shorthandPrimitives=Switch[imageSelectionOption,
					All|Automatic,
						{
							ImageSelect@@ (Rule[#,All]&/@ToExpression[Keys[Options[ImageSelectOptions]]])
						},
					MicroscopeModeP,
						{
							ImageSelect@@ Flatten@{
								Mode->imageSelectionOption,
								Rule[#,All]&/@Complement[ToExpression[Keys[Options[ImageSelectOptions]]],{Mode}]
							}
						}
					(* True,
						{} *)
				];

				(* We are going to pass this set of primitives to the resolve functions *)
				finalPrimitives=If[MatchQ[imageSelectionOption,All|Automatic|MicroscopeModeP],
					shorthandPrimitives,
					imageSelectionPrimitives
				];

				(** Pattern checking **)
				validPritimivePatternTest =
					If[
						MatchQ[
							checkPrimitivesPattern[
								ImageSelection,
								finalPrimitives,
								primitiveSetInformation,
								allPrimitiveInformation,
								primitiveHeads
							],
							$Failed
						],
						(* Throw a message indicating for which input we failed *)
						If[!testsQ,Message[Error::InvalidOption,myInput]];
						Test["All the ImageSelection primitives have been specified with correct patterns.", True, False],
						Test["All the ImageSelection primitives have been specified with correct patterns.", True, True]
					];

				(** Label checking **)

				validPritimiveLabelTest =
					If[
						MatchQ[
							checkPrimitivesLabel[
								ImageSelection,
								finalPrimitives,
								primitiveSetInformation,
								allPrimitiveInformation,
								primitiveHeads
							],
							$Failed
						],
						(* Throw a message indicating for which input we failed *)
						If[!testsQ,Message[Error::InvalidInput,myInput]];
						Test["The labels used in the ImageSelection primitives are availabe.", True, False],
						Test["The labels used in the ImageSelection primitives are availabe.", True, True]
					];

				(** Resolve primitives **)

				(* Go through each of our primitives and check them. *)
				resolvedImageSelectionPrimitives=
					(* For non automatic, lookup the primitives one by one and resolve their options *)
					MapThread[
						Function[{currentPrimitive, primitiveIndex},
							Module[
								{
									selectionFunction,selectionFunctionResolveFunction,selectionFunctionInformation,selectionFunctionDefaultList
								},

								(* Convert to association for better handling *)
								currentPrimitiveAssociation=Association@@currentPrimitive;

								(* The adjustment function is the head of the primitive *)
								selectionFunction=Head[currentPrimitive];

								(* All the primitive information for our specific adjustment function *)
								selectionFunctionInformation=Lookup[allPrimitiveInformation,selectionFunction];

								(* Finding the resolve function from allPrimitiveInformation *)
								selectionFunctionResolveFunction=Lookup[selectionFunctionInformation,ExperimentFunction];

								(* Apply the resolve option based on the adjustment function *)
								selectionFunctionResolveFunction@@{
									currentPrimitive,
									selectionFunctionInformation,
									primitiveIndex,
									myInput,
									inputIndex,
									KeyValueMap[Rule[#1,#2]&,mapThreadOptions]
								}

							]
						],
						{finalPrimitives, Range[Length[finalPrimitives]]}
					];

				(* Combine all of the tests we ran on this primitive *)
				allPrimitiveTests={validPritimivePatternTest,validPritimiveLabelTest};

				(* We keep the short-hand image selection - otherwise the primitives will be set as the ImageSelection resolved values *)
				resolvedImageSelection=Switch[imageSelectionOption,
					All|MicroscopeModeP,
						imageSelectionOption,
					_,
						resolvedImageSelectionPrimitives
				];

				{resolvedImageSelection,resolvedImageSelectionPrimitives,allPrimitiveTests}

			]
		],
		{myInputs,Range[Length[myInputs]],allMapThreadedOptions}
	];

	(* A list of allResolvedOptions for all inputs *)
	resultRule=Result->{allResolvedOptions,allResolvedPrimitives};

	(* A list containing lists of all tests ran for all inputs *)
	testsRule=Tests->allTests;

	outputSpecification/.{testsRule,resultRule}

];


(* Different overlaods for image adjust *)
resolveImageSelectPrimitive[
	myPrimitive_ImageSelect,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput:ObjectP[Object[Data,Microscope]],
	myInputIndex_Integer,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		object,resolvedObject
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	(* We don't pass the options that are the default of the MicroscopeImageSelect to be cleaner in the builder *)
	safeOptions=Cases[
		ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]],
		Except[_->All]
	];

	(* Take the object input option from the primitive - if given will be used otherwise the data object myInput will be used *)
	object = Lookup[safeOptions,InputObject];

	resolvedObject=If[MatchQ[object,Automatic|Null],
		myInput,
		object
	];

	ImageSelect@@ReplaceRule[
		safeOptions,
		{
			InputObject->resolvedObject
		}
	]

];

(* ------------------------ *)
(* --- Resolving Images --- *)
(* ------------------------ *)


(* ::Subsection:: *)
(* resolveImagesPrimitives *)

DefineOptions[resolveImagesPrimitives,
	Options:>{
    OutputOption
	},
	SharedOptions:>{
	}
];

resolveImagesPrimitives[
  myInputs:{ObjectP[Object[Data,Microscope]]..},
  myExpandedOptions:{(_Rule|_RuleDelayed)..},
  myAdjustmentOptions:OptionsPattern[resolveImagesPrimitives]
]:=Module[

	{
    outputSpecification,output,testsQ,
    allMapThreadedOptions,allResolvedOptions,resultRule,testsRule
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* See if we're gathering tests. *)
	testsQ=MemberQ[output,Tests];

	(* create a mapthread version of our options *)
	allMapThreadedOptions=OptionsHandling`Private`mapThreadOptions[AnalyzeCellCount,myExpandedOptions];

	(* Mapping over all of the inputs with their options *)
	{allResolvedOptions,allTests}=Transpose@MapThread[
		Function[
			{myInput,inputIndex,mapThreadOptions},
			Module[
				{
					imagesOption,imagesPrimitives,
					(* for error checking *)
					primitiveSetInformation,allPrimitiveInformation,primitiveHeads,
					(* for resolving primitives *)
					automaticQ,automaticPrimitives,resultRule,finalPrimitives,
					(* for running tests *)
					validPritimivePatternTest,validPritimiveLabelTest,allPrimitiveTests,testsRule,
					resolvedImagesPrimitives,validImageSelectionAndImagesTest
				},

				(** Find Primitives **)

				(* Finding the image adjustment in the resolved option - Convert to association for better handling *)
				imagesOption=Lookup[mapThreadOptions,Images];

				(* Make sure that a singlet primitive is listed not to break mapping *)
				imagesPrimitives=ToList[imagesOption];

				(* Lookup information about our primitive set from our backend association. *)
				primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ImagesPrimitiveP]];
				allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
				primitiveHeads=Keys[allPrimitiveInformation];

				(* Set all of the automatic image adjustment based on the other option *)
				automaticQ=MatchQ[imagesOption,Automatic];

				(* Set all of the automatic image adjustment based on the other option *)
				automaticPrimitives=If[automaticQ,
					populateImagesprimitives[myInput,KeyValueMap[Rule[#1,#2]&,mapThreadOptions],primitiveSetInformation,allPrimitiveInformation,primitiveHeads]
				];

				(* We are going to pass this set of primitives to the resolve functions *)
				finalPrimitives=If[automaticQ,
					automaticPrimitives,
					imagesPrimitives
				];

				validImageSelectionTest=If[MatchQ[finalPrimitives,{}],
					(* Throw a message indicating for which input we failed *)
					If[!testsQ,
						Message[Error::NoImagesFound,myInput];
						Message[Error::InvalidOption,myInput]
					];
					Test["Images primitives were populated based on the ImageSelection and Images options.", True, False],
					Test["Images primitives were populated based on the ImageSelection and Images options.", True, True]
				];

				(** Pattern checking **)
				validPritimivePatternTest =
					If[
						MatchQ[
							checkPrimitivesPattern[
								Images,
								finalPrimitives,
								primitiveSetInformation,
								allPrimitiveInformation,
								primitiveHeads
							],
							$Failed
						],
						(* Throw a message indicating for which input we failed *)
						If[!testsQ,Message[Error::InvalidOption,myInput]];
						Test["All the Images primitives have been specified with correct patterns.", True, False],
						Test["All the Images primitives have been specified with correct patterns.", True, True]
					];

				(** Label checking **)

				validPritimiveLabelTest =
					If[
						MatchQ[
							checkPrimitivesLabel[
								Images,
								finalPrimitives,
								primitiveSetInformation,
								allPrimitiveInformation,
								primitiveHeads
							],
							$Failed
						],
						(* Throw a message indicating for which input we failed *)
						If[!testsQ,Message[Error::InvalidOption,myInput]];
						Test["The labels used in the Images primitives are availabe.", True, False],
						Test["The labels used in the Images primitives are availabe.", True, True]
					];

				(* Checking the keys of MicroscopeImage primitive *)
				validMicroscopeImageKeysTest=MapThread[
					Function[{currentPrimitive, primitiveIndex},
						Module[
							{primitiveInformation,allMicroscopeImageKeys,providedMicroscopeImageKeys},

							(* Take the primitive information from $PrimitiveSetPrimitiveLookup *)
							primitiveInformation=Lookup[allPrimitiveInformation,MicroscopeImage];

							(* Take the keys from all options for MicroscopeImage - all of them should be given - remove instrument *)
							(* allMicroscopeImageKeys=DeleteCases[ToExpression[Lookup[Lookup[primitiveInformation, OptionDefinition],"OptionName"]],Instrument]; *)

							allMicroscopeImageKeys={
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
							};
							(* allMicroscopeImageKeys={Mode,ObjectiveMagnification,ImageTimepoint,ImageZStep,ImagingSite}; *)

							(* Privided keys *)
							providedMicroscopeImageKeys=Keys[Association@@currentPrimitive];

							If[MatchQ[Head[currentPrimitive],MicroscopeImage] && !MatchQ[Complement[allMicroscopeImageKeys,providedMicroscopeImageKeys],{}],
								(* Throw a message indicating for which input we failed *)
								If[!testsQ,
									Message[Error::IncompleteMicroscopeImageKeys,myInput,Complement[allMicroscopeImageKeys,providedMicroscopeImageKeys]];
									Message[Error::InvalidOption,myInput]
								];
								Test["All keys for the MicroscopeImage primitive of Images option are provided.", True, False],
								Test["All keys for the MicroscopeImage primitive of Images option are provided.", True, True]
							]
						]
					],
					{finalPrimitives, Range[Length[finalPrimitives]]}
				];

				(** Resolve primitives **)

				(* Go through each of our primitives and check them. *)
				resolvedImagesPrimitives=
					(* For non automatic, lookup the primitives one by one and resolve their options *)
					MapThread[
						Function[{currentPrimitive, primitiveIndex},
							Module[
								{
									imagesFunction,imagesFunctionResolveFunction,imagesFunctionInformation,imagesFunctionDefaultList,
									selectedImages,validSelectedImageTest
								},

								(* Convert to association for better handling *)
								currentPrimitiveAssociation=Association@@currentPrimitive;

								(* The adjustment function is the head of the primitive *)
								imagesFunction=Head[currentPrimitive];

								(* All the primitive information for our specific adjustment function *)
								imagesFunctionInformation=Lookup[allPrimitiveInformation,imagesFunction];

								(* Finding the resolve function from allPrimitiveInformation *)
								imagesFunctionResolveFunction=Lookup[imagesFunctionInformation,ExperimentFunction];

								(* Apply the resolve option based on the adjustment function *)
								imagesFunctionResolveFunction@@{
									currentPrimitive,
									imagesFunctionInformation,
									primitiveIndex,
									myInput,
									inputIndex,
									KeyValueMap[Rule[#1,#2]&,mapThreadOptions]
								}

							]
						],
						{finalPrimitives, Range[Length[finalPrimitives]]}
					];

				(* Combine all of the tests we ran on this primitive *)
				allPrimitiveTests={validPritimivePatternTest,validPritimiveLabelTest,validMicroscopeImageKeysTest,validImageSelectionTest};

				{resolvedImagesPrimitives,allPrimitiveTests}

			]
		],
		{myInputs,Range[Length[myInputs]],allMapThreadedOptions}
	];

	(* A list of allResolvedOptions for all inputs *)
	resultRule=Result->allResolvedOptions;

	(* A list containing lists of all tests ran for all inputs *)
	testsRule=Tests->allTests;

	outputSpecification/.{testsRule,resultRule}

];


(* ::Subsubsection:: *)
(* populateImagesprimitives *)

(* Helper function to automatically poplulate the primitives based on the user and data options *)
populateImagesprimitives[
	myInput:ObjectP[Object[Data,Microscope]],
	myExpandedOptions:{(_Rule|_RuleDelayed)..},
	primitiveSetInformation_,
	allPrimitiveInformation_,
	primitiveHeads_
]:=Module[
	{
		imageSelection,primitiveInformation,inputOptions,optionOptions,keysValues,
		inputOptionRules,optionOptionRules,imageSelectRules
	},

	(* The resolved value of ImageSelection field *)
	imageSelection=Association@@(First@Lookup[myExpandedOptions,ImageSelection]);

	(* Lookup our image adjustment primitive information. *)
	primitiveInformation=Lookup[allPrimitiveInformation, MicroscopeImage];

	(* Make sure we have other options as well because they need to index match *)
	inputOptions=Lookup[primitiveInformation,InputOptions,{}];
	
	(* The other option keys will be our option options *)
	optionOptions=UnsortedComplement[
		ToExpression[Lookup[Lookup[primitiveInformation, OptionDefinition],"OptionName"]],
		inputOptions
	];

	(* Find all of the options with their values for this primitive *)
	keysValues=KeyValueMap[Rule[#1,#2]&,imageSelection];

	(* We are not gonna use the input options with Null value *)
	inputOptionRules=Select[keysValues,
		MatchQ[First[#],Alternatives@@inputOptions]&
	];

	(* All of the key values correcponding to our optionOptions *)
	optionOptionRules=Select[keysValues,
		MatchQ[First[#],Alternatives@@optionOptions]&
	];

	(* The final result of the image select, if not Object is given use input *)
	imageSelectRules=MicroscopeImageSelect[Sequence@@(Values@inputOptionRules),Sequence@@(optionOptionRules)];

	Map[
		MicroscopeImage[
			Sequence@@(inputOptionRules),
			Sequence@@(Cases[ReplaceRule[optionOptionRules,KeyValueMap[Rule[#1,#2]&,#],Append->True],Except[ImageFile->_]])
		]&,
		imageSelectRules
	]

];

(* Different overlaods for image adjust *)
resolveMicroscopeImagePrimitive[
	myPrimitive_MicroscopeImage,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput:ObjectP[Object[Data,Microscope]],
	myInputIndex_Integer,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		object,resolvedObject,
		inputOptions,optionOptions,keysValues,inputOptionRules,
		optionOptionRules,imageSelectRules
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Make sure we have other options as well because they need to index match *)
	inputOptions=Lookup[myPrimitiveInformation,InputOptions,{}];

	(* The other option keys will be our option options *)
	optionOptions=UnsortedComplement[
		ToExpression[Lookup[Lookup[myPrimitiveInformation, OptionDefinition],"OptionName"]],
		inputOptions
	];

	(* Find all of the options with their values for this primitive *)
	keysValues=KeyValueMap[Rule[#1,#2]&,primitiveAssociation];

	(* We are not gonna use the input options with Null value *)
	inputOptionRules=Select[keysValues,
		MatchQ[First[#],Alternatives@@inputOptions]&
	];

	(* All of the key values correcponding to our optionOptions *)
	optionOptionRules=Select[keysValues,
		MatchQ[First[#],Alternatives@@optionOptions]&
	];

	(* The final result of the image select, if not Object is given use input *)
	imageSelectRules=KeyDrop[
		MicroscopeImageSelect[myInput,Sequence@@(optionOptionRules)],
		ImageFile
	];

	If[MatchQ[imageSelectRules,{}],
		Message[Error::InvalidImagesPrimitive,myInput,myPrimitiveIndex];
		Message[Error::InvalidOption,myInput]
	];

	(* Take the object input option from the primitive - if given will be used otherwise the data object myInput will be used *)
	object = Lookup[safeOptions,InputObject];

	resolvedObject=If[MatchQ[object,Automatic|Null],
		myInput,
		object
	];

	If[MatchQ[imageSelectRules,{}],
		MicroscopeImage@@ReplaceRule[
			safeOptions,
			{
				InputObject->resolvedObject
			},
			Append->True
		],
		MicroscopeImage@@ReplaceRule[
			KeyValueMap[Rule[#1,#2]&,imageSelectRules[[1]]],
			{
				InputObject->resolvedObject
			},
			Append->True
		]
	]

];

(* --------------------------------- *)
(* --- Resolving ImageAdjustment --- *)
(* --------------------------------- *)


(* ::Subsection:: *)
(* resolveImageAdjustmentPrimitives *)


DefineOptions[resolveImageAdjustmentPrimitives,
	Options:>{
    OutputOption
	},
	SharedOptions:>{
	}
];

(* Overload for data object *)
resolveImageAdjustmentPrimitives[
  myInputs:{ObjectP[Object[Data,Microscope]]..},
	allReferenceImages:{{ObjectP[Object[EmeraldCloudFile]]...}..},
  allExpandedOptions:{(_Rule|_RuleDelayed)..},
  myAdjustmentOptions:OptionsPattern[resolveImageAdjustmentPrimitives]
]:=Module[
	{
		outputSpecification,output,testsQ,allResolvedOptions,allTests,resultRule,testsRule,
		allMapThreadedOptions
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* See if we're gathering tests. *)
	testsQ=MemberQ[output,Tests];

	(* create a mapthread version of our options *)
	allMapThreadedOptions=OptionsHandling`Private`mapThreadOptions[AnalyzeCellCount,allExpandedOptions];

	{allResolvedOptions,allTests}=Transpose[
		If[MatchQ[allReferenceImages,{{}..}],

			(* For no images, return empty resolved options and tests *)
			ConstantArray[{{},{}},Length[myInputs]],

			MapThread[
				Function[{referenceImages,expandedOptions},

					resolveImageAdjustmentPrimitives[
						referenceImages,
						KeyValueMap[Rule[#1,#2]&,expandedOptions],
						Output->{Result,Tests}
					]
				],
				{allReferenceImages,allMapThreadedOptions}
			]

		]
	];

	(* A list of allResolvedOptions for all inputs *)
	resultRule=Result->allResolvedOptions;

	(* A list containing lists of all tests ran for all inputs *)
	testsRule=Tests->allTests;

	outputSpecification/.{testsRule,resultRule}

];

resolveImageAdjustmentPrimitives[
  myInputs:{ObjectP[Object[EmeraldCloudFile]]..},
  myExpandedOptions:{(_Rule|_RuleDelayed)..},
  myAdjustmentOptions:OptionsPattern[resolveImageAdjustmentPrimitives]
]:=Module[

	{
    outputSpecification,output,testsQ,
    allMapThreadedOptions,allResolvedOptions,resultRule,testsRule,images,allTests
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* See if we're gathering tests. *)
	testsQ=MemberQ[output,Tests];

	(* Import the cloud file - we are going to *)
	images=ImportCloudFile@myInputs;

	(* create a mapthread version of our options *)
	allMapThreadedOptions=OptionsHandling`Private`mapThreadOptions[AnalyzeCellCount,myExpandedOptions];

	(* Mapping over all of the inputs with their options *)
	{allResolvedOptions,allTests}=Transpose@MapThread[
		Function[
			{myInput,image,inputIndex,mapThreadOptions},
			Module[
				{
					imageAdjustmentOption,imageAdjustmentPrimitives,
					(* for error checking *)
					primitiveSetInformation,allPrimitiveInformation,primitiveHeads,
					(* for resolving primitives *)
					automaticQ,automaticPrimitives,resultRule,finalPrimitives,
					(* for running tests *)
					validPritimivePatternTest,validPritimiveLabelTest,allPrimitiveTests,testsRule,
					resolvedImageAdjustmentPrimitives
				},

				(** Find Primitives **)

				(* Finding the image adjustment in the resolved option - Convert to association for better handling *)
				imageAdjustmentOption=Lookup[mapThreadOptions,ImageAdjustment];

				(* Make sure that a singlet primitive is listed not to break mapping *)
				imageAdjustmentPrimitives=If[MatchQ[imageAdjustmentOption,None],
					{},
					ToList[imageAdjustmentOption]
				];

				(* Lookup information about our primitive set from our backend association. *)
				primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ImageAdjustmentPrimitiveP]];
				allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
				primitiveHeads=Keys[allPrimitiveInformation];

				(* If automatic is chosen we will find the image adjustment primitives based on the master switch *)
			  automaticQ=MatchQ[imageAdjustmentOption,Automatic];

				(* Set all of the automatic image adjustment based on the other option *)
				automaticPrimitives=If[automaticQ,
					populateImageAdjustmentprimitives[myInput,image,KeyValueMap[Rule[#1,#2]&,mapThreadOptions]]
				];

				(* We are going to pass this set of primitives to the resolve functions *)
				finalPrimitives=If[automaticQ,
					automaticPrimitives,
					imageAdjustmentPrimitives
				];

				(** Pattern checking **)
				validPritimivePatternTest =
					If[
						MatchQ[
							checkPrimitivesPattern[
								ImageAdjustment,
								finalPrimitives,
								primitiveSetInformation,
								allPrimitiveInformation,
								primitiveHeads
							],
							$Failed
						],
						(* Throw a message indicating for which input we failed *)
						If[!testsQ,Message[Error::InvalidOption,myInput]];
						Test["All the ImageAdjustment primitives have been specified with correct patterns.", True, False],
						Test["All the ImageAdjustment primitives have been specified with correct patterns.", True, True]
					];

				(** Label checking **)

				validPritimiveLabelTest =
					If[
						MatchQ[
							checkPrimitivesLabel[
								ImageAdjustment,
								finalPrimitives,
								primitiveSetInformation,
								allPrimitiveInformation,
								primitiveHeads
							],
							$Failed
						],
						(* Throw a message indicating for which input we failed *)
						If[!testsQ,Message[Error::InvalidOption,myInput]];
						Test["The labels used in the ImageAdjustment primitives are availabe.", True, False],
						Test["The labels used in the ImageAdjustment primitives are availabe.", True, True]
					];

				(** Resolve primitives **)

				(* Go through each of our primitives and check them. *)
				resolvedImageAdjustmentPrimitives=
					(* For non automatic, lookup the primitives one by one and resolve their options *)
					MapThread[
						Function[{currentPrimitive, primitiveIndex},
							Module[
								{
									adjustmentFunction,adjustmentFunctionResolveFunction,adjustmentFunctionInformation,adjustmentFunctionDefaultList
								},

								(* Convert to association for better handling *)
								currentPrimitiveAssociation=Association@@currentPrimitive;

								(* The adjustment function is the head of the primitive *)
								adjustmentFunction=Head[currentPrimitive];

								(* All the primitive information for our specific adjustment function *)
								adjustmentFunctionInformation=Lookup[allPrimitiveInformation,adjustmentFunction];

								(* Finding the resolve function from allPrimitiveInformation *)
								adjustmentFunctionResolveFunction=Lookup[adjustmentFunctionInformation,ExperimentFunction];

								(* Apply the resolve option based on the adjustment function *)
								adjustmentFunctionResolveFunction@@{
									currentPrimitive,
									adjustmentFunctionInformation,
									primitiveIndex,
									myInput,
									inputIndex,
									image,
									KeyValueMap[Rule[#1,#2]&,mapThreadOptions]
								}

							]
						],
						{finalPrimitives, Range[Length[finalPrimitives]]}
					];

				(* Combine all of the tests we ran on this primitive *)
				allPrimitiveTests={validPritimivePatternTest,validPritimiveLabelTest};

				{
					resolvedImageAdjustmentPrimitives,
					allPrimitiveTests
				}

			]
		],
		{myInputs,images,Range[Length[myInputs]],allMapThreadedOptions}
	];

	(* A list of allResolvedOptions for all inputs *)
	resultRule=Result->allResolvedOptions;

	(* A list containing lists of all tests ran for all inputs *)
	testsRule=Tests->allTests;

	outputSpecification/.{testsRule,resultRule}

];

(* ::Subsubsection:: *)
(* populateImageAdjustmentprimitives *)

(* Helper function to automatically poplulate the primitives based on the user and data options *)
populateImageAdjustmentprimitives[
	myInput:ObjectP[Object[EmeraldCloudFile]],
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		hemocytometer,masterSwitch,gridPattern,hemocytometerSquarePosition,hemocytometerSquareCoordinates,
		measureConfluency,desiredMeanIntensity,imageMeanIntensity,brightnessIncreaseFactor
	},

	(* Whether the image is associated with the hemocytometer *)
	hemocytometer=Lookup[myExpandedOptions,Hemocytometer];

	(* Whether the image is associated with the confluency measurement *)
	measureConfluency=Lookup[myExpandedOptions,MeasureConfluency];

	(* Specify the master switch here *)
	masterSwitch=Which[
		hemocytometer,
			"Hemocytometer",
		measureConfluency,
			"MeasureConfluency",
		True,
			None
	];

	(** Hemocytometer Specifications **)

	(* If the image is associated with the hemocytometer, what is the grid pattern *)
	gridPattern=Lookup[myExpandedOptions,GridPattern];

	(* The square in the hemocytometer grid pattern that is our region of interest *)
	hemocytometerSquarePosition=Lookup[myExpandedOptions,HemocytometerSquarePosition];

	(* The coordinates of the hemocytometer square that is the region of interest *)
	hemocytometerSquareCoordinates=If[hemocytometer,
		findHemocytometerSquareCoordinates[
			myImage,
			gridPattern,
			hemocytometerSquarePosition
		]
	];

	(* The desired mean intensity value if the mean intensity is less than  *)
	desiredMeanIntensity = 0.6;
	imageMeanIntensity = ImageMeasurements[myImage, "MeanIntensity"];

	(* This ensures that we get the mean intensity that is set to the desiredMeanIntensity *)
	brightnessIncreaseFactor = Round[N[desiredMeanIntensity/imageMeanIntensity],0.001];

	If[MatchQ[myImage,{}],

		(* For no image, no image adjustment *)
		{},

		Which[

			(* Only increase brightness if the mean intensity is less than 0.1 *)
			(MatchQ[masterSwitch,"Hemocytometer"] && imageMeanIntensity < 0.4),
				{
					ImageAdjust[Correction->{0,2}],
					ImageTrim[]
				},


			MatchQ[masterSwitch,"Hemocytometer"],
				{
					ImageTrim[]
				},

			(MatchQ[masterSwitch,"MeasureConfluency"] && imageMeanIntensity < 0.3),
				{
					ImageAdjust[Correction->{0,2},OutputImageLabel->"adjusted"]
				},

			MatchQ[masterSwitch,"MeasureConfluency"],
				{
				},

			(* Default adjustment *)

			True,
				{}
		]
	]

];


(* Helper function to find the trim position of the hemocytometer *)
(* Memoize the result for faster performance in the builder *)
findHemocytometerSquareCoordinates[
	image_Image,
	gridPattern:HemocytometerGridPatternP,
	position:{GreaterEqualP[0],GreaterEqualP[0]}|{{GreaterEqualP[0],GreaterEqualP[0]}..}|All
]:=findHemocytometerSquareCoordinates[image,gridPattern,position]=Module[
	{
		imageAdjusted,gridCroppedFiltered,averageXRule,averageYRule,findMainVerticalLines,findMainHorizontalLines,
		verticalGridEdges,verticalGridDilatedEroded,verticalLines,sortedVerticalLines,mainVerticalLines,
		horizontalGridEdges,horizontalGridDilatedEroded,horizontalLines,sortedHorizontalLines,mainHorizontalLines,
		gridSize,squareIndexFromPosition,squareIndecies
	},

	(* Dimensions of the hemocytometer grid based on the grid pattern type - { X , Y } format *)
	gridSize=Switch[gridPattern,
		Neubauer|Malassez|Burker|BurkerTurk,
		{3,3},
		FuchsRosenthal,
		{4,4},
		HemocytometerGridPatternP,
		{3,3}
	];

	(* Adjust the image brightness *)
	imageAdjusted= ImageAdjust[image, {0, 2}];

	(* gaussina filter *)
	gridCroppedFiltered = GaussianFilter[imageAdjusted, 1];
	averageXRule = {{x1_, y1_}, {x2_, y2_}} :> (x1 + x2)/2;
	averageYRule = {{x1_, y1_}, {x2_, y2_}} :> (y1 + y2)/2;

	(* A code which finds the 4 major vertical lines *)
	findMainVerticalLines[{{x1min_, y1min_}, {x2min_, y2min_}, {x1max_, y1max_}, {x2max_, y2max_}}] := Module[
		{ysorted, xminAve, xmaxAve, xdel, yminAve, ymaxAve},

		(* sort y so we take two of the smallest ys and two of the larger ones *)
		ysorted = Sort[{y1min, y2min, y1max, y2max}];
		(* Average min of the y in the vertical lines *)
		yminAve = Mean[ysorted[[1 ;; 2]]];
		ymaxAve = Mean[ysorted[[3 ;; 4]]];
		(* Average of the min x and max x and the delta *)
		xminAve = Mean[{x1min, x2min}];
		xmaxAve = Mean[{x1max, x2max}];
		xdel = xmaxAve - xminAve;
		Map[
			Line[{{xminAve  + (#-1)/gridSize[[1]] * xdel, yminAve }, {xminAve + (#-1)/gridSize[[1]] * xdel, ymaxAve}}]&,
			Range[gridSize[[1]]+1]
		]
	];
	(* A code which finds the 4 major horizontal lines *)
	findMainHorizontalLines[{{x1min_, y1min_}, {x2min_, y2min_}, {x1max_, y1max_}, {x2max_, y2max_}}] := Module[
		{xsorted, xminAve, xmaxAve, ydel, yminAve, ymaxAve},
		(* sort y so we take two of the smallest ys and two of the larger ones *)
		xsorted = Sort[{x1min, x2min, x1max, x2max}];
		(* Average min of the x in the vertical lines *)
		xminAve = Mean[xsorted[[1 ;; 2]]];
		xmaxAve = Mean[xsorted[[3 ;; 4]]];
		(* Average of the min y and max y and the delta *)
		yminAve = Mean[{y1min, y2min}];
		ymaxAve = Mean[{y1max, y2max}];
		ydel = ymaxAve - yminAve;
		Map[
			Line[{{xminAve, yminAve + (#-1)/gridSize[[2]] * ydel }, {xmaxAve, yminAve + (#-1)/gridSize[[2]] * ydel}}]&,
			Range[gridSize[[2]]+1]
		]
	];

	(* detecting edges *)
	verticalGridEdges = EdgeDetect[gridCroppedFiltered, {0, 10}];

	(* Dilation followed by erosion *)
	verticalGridDilatedEroded = Erosion[Dilation[verticalGridEdges, DiskMatrix[2]], DiskMatrix[2]];

	(* find the edges *)
	verticalLines = ImageLines[verticalGridDilatedEroded, MaxFeatures -> 100];

	(*finding the average x value of a horizontal lines based on start and the end of the line *)
	sortedVerticalLines = Sort[verticalLines, (#1[[1]] /. averageXRule) < (#2[[1]] /. averageXRule) &];

	(* dividing extra lines *)
	mainVerticalLines = findMainVerticalLines[Join[First@sortedVerticalLines[[1]], First@sortedVerticalLines[[-1]]]];

	(* detecting edges *)
	horizontalGridEdges = EdgeDetect[gridCroppedFiltered, {10, 0}];

	(* Dilation followed by erosion *)
	horizontalGridDilatedEroded = Erosion[Dilation[horizontalGridEdges, DiskMatrix[2]], DiskMatrix[2]];

	(* find the edges *)
	horizontalLines = ImageLines[horizontalGridDilatedEroded, MaxFeatures -> 100];

	(* Echo[Show[imageAdjusted,
	 Graphics[{Thick, Blue,
	   Join[mainVerticalLines, mainHorizontalLines]}]]]; *)

	(*finding the average x value of a horizontal lines based on start and the end of the line *)
	sortedHorizontalLines = Sort[horizontalLines, (#1[[1]] /. averageYRule) < (#2[[1]] /. averageYRule) &];

	(* dividing extra lines *)
	mainHorizontalLines = findMainHorizontalLines[Join[First@sortedHorizontalLines[[1]], First@sortedHorizontalLines[[-1]]]];

	(* The index of the vertical and horizontal lines which make the square *)
	squareIndecies = Function[i,
		(* The first two values are the first and second index of the vertical lines *)
		(* The last two values are the first and second index of the horizontal lines *)
		(** NOTE: the enumeration is from the bottom to the top and from left to right **)
		{
			Mod[i - 1, gridSize[[1]] ] + 1,
			Mod[i - 1, gridSize[[1]] ] + 2,
			Floor[ (i - 1)/gridSize[[1]] ] + 1,
			Floor[ (i - 1)/gridSize[[1]] ] + 2
		}
	];

	(* A single digit the describes the index of the square based on the {X,Y} position *)
	(* {  {7, 8, 9},{4, 5, 6},{1, 2, 3}  } is the index scheme based on the position *)
	squareIndexFromPosition=Which[
		MatchQ[position,{_,_}],
			( (position[[2]]-1)*gridSize[[1]]+position[[1]] ),
		MatchQ[position,{{_,_}..}],
			Map[
				( (#[[2]]-1)*gridSize[[1]]+#[[1]] )&,
				position
			]
	];

	Which[
		MatchQ[position,All],

			{
				{First@mainVerticalLines[[1]] /. averageXRule, First@mainHorizontalLines[[1]] /. averageYRule},
				{First@mainVerticalLines[[-1]] /. averageXRule, First@mainHorizontalLines[[-1]] /. averageYRule}
			},

		MatchQ[position,{_,_}],

			{
				{
					First@mainVerticalLines[[Part[squareIndecies[squareIndexFromPosition], 1]]] /. averageXRule,
					First@mainHorizontalLines[[Part[squareIndecies[squareIndexFromPosition], 3]]] /. averageYRule
				},
				{
					First@mainVerticalLines[[Part[squareIndecies[squareIndexFromPosition], 2]]] /. averageXRule,
					First@mainHorizontalLines[[Part[squareIndecies[squareIndexFromPosition], 4]]] /. averageYRule
				}
			},

		MatchQ[position,{{_,_}..}],

			Map[
				Function[eachSquareIndexFromPosition,
					{
						{
							First@mainVerticalLines[[Part[squareIndecies[eachSquareIndexFromPosition], 1]]] /. averageXRule,
							First@mainHorizontalLines[[Part[squareIndecies[eachSquareIndexFromPosition], 3]]] /. averageYRule
						},
						{
							First@mainVerticalLines[[Part[squareIndecies[eachSquareIndexFromPosition], 2]]] /. averageXRule,
							First@mainHorizontalLines[[Part[squareIndecies[eachSquareIndexFromPosition], 4]]] /. averageYRule
						}
					}
				],
				squareIndexFromPosition
			]
	]

];

(* ::Subsubsection:: *)
(* resolveImageAdjustPrimitive *)

(* Different overlaods for image adjust *)
resolveImagePrimitive[
	myPrimitive_Image,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		image,outputImageLabel,type
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,type}=
		Lookup[safeOptions,{Image,OutputImageLabel,Type}];

	Image[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Type->type
	]

];

(* ::Subsubsection:: *)
(* resolveImageAdjustPrimitive *)

(* Different overlaods for image adjust *)
resolveImageAdjustPrimitive[
	myPrimitive_ImageAdjust,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		image,outputImageLabel,correction,inputRange,outputRange,resolvedCorrection,resolvedInputRange,resolvedOutputRange
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,correction,inputRange,outputRange}=
		Lookup[safeOptions,{Image,OutputImageLabel,Correction,InputRange,OutputRange}];

	(* If Automatic we set it to Null and when applying it will be ignored *)
	resolvedCorrection=If[MatchQ[correction,Automatic],
		Null,
		correction
	];

	(* If Automatic we set it to Null and when applying it will be ignored *)
	resolvedInputRange=If[MatchQ[inputRange,Automatic],
		Null,
		inputRange
	];

	(* If Automatic we set it to Null and when applying it will be ignored *)
	resolvedOutputRange=If[MatchQ[outputRange,Automatic],
		Null,
		outputRange
	];

	ImageAdjust[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Correction->resolvedCorrection,
		InputRange->resolvedInputRange,
		OutputRange->resolvedOutputRange
	]

];

(* ::Subsubsection:: *)
(* resolveColorNegatePrimitive *)

(* Different overlaods for image adjust *)
resolveColorNegatePrimitive[
	myPrimitive_ColorNegate,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		image,outputImageLabel
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel}=
		Lookup[safeOptions,{Image,OutputImageLabel}];

	ColorNegate[
		Image->image,
		OutputImageLabel->outputImageLabel
	]

];

(* ::Subsubsection:: *)
(* resolveColorSeparatePrimitive *)

(* Different overlaods for image adjust *)
resolveColorSeparatePrimitive[
	myPrimitive_ColorSeparate,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		image,outputImageLabel,color
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,color}=
		Lookup[safeOptions,{Image,OutputImageLabel,Color}];

	ColorNegate[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Color->color
	]

];

(* ::Subsubsection:: *)
(* resolveTopHatTransformPrimitive *)

resolveTopHatTransformPrimitive[
	myPrimitive_TopHatTransform,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,kernel
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,kernel}=
		Lookup[safeOptions,{Image,OutputImageLabel,Kernel}];

	TopHatTransform[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Kernel->kernel
	]

];

(* ::Subsubsection:: *)
(* resolveTopHatTransformPrimitive *)

resolveBottomHatTransformPrimitive[
	myPrimitive_BottomHatTransform,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,kernel
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,kernel}=
		Lookup[safeOptions,{Image,OutputImageLabel,Kernel}];

	BottomHatTransform[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Kernel->kernel
	]

];

(* ::Subsubsection:: *)
(* resolveHistogramTransformPrimitive *)

resolveHistogramTransformPrimitive[
	myPrimitive_HistogramTransform,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,distribution,referenceImage
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,distribution,referenceImage}=
		Lookup[safeOptions,{Image,OutputImageLabel,Distribution,ReferenceImage}];

	HistogramTransform[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Distribution->distribution,
		ReferenceImage->referenceImage
	]

];

(* ::Subsubsection:: *)
(* resolveFillingTransformPrimitive *)

resolveFillingTransformPrimitive[
	myPrimitive_FillingTransform,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,distribution,referenceImage,
		marker,depth,padding,cornerNeighbors
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,marker,depth,padding,cornerNeighbors}=
		Lookup[safeOptions,{Image,OutputImageLabel,Marker,Depth,Padding,CornerNeighbors}];

	FillingTransform[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Marker->marker,
		Depth->depth,
		Padding->padding,
		CornerNeighbors->cornerNeighbors
	]

];

(* ::Subsubsection:: *)
(* resolveBrightnessEqualizePrimitive *)

resolveBrightnessEqualizePrimitive[
	myPrimitive_BrightnessEqualize,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,distribution,referenceImage,
		marker,depth,padding,cornerNeighbors
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,flatField,darkField}=
		Lookup[safeOptions,{Image,OutputImageLabel,FlatField,DarkField}];

	BrightnessEqualize[
		Image->image,
		OutputImageLabel->outputImageLabel,
		FlatField->flatField,
		DarkField->darkField
	]

];

(* ::Subsubsection:: *)
(* resolveImageAdjustPrimitive *)

(* Different overlaods for image adjust *)
resolveImageMultiplyPrimitive[
	myPrimitive_ImageMultiply,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,image,outputImageLabel,
		secondImage
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,secondImage}=
		Lookup[safeOptions,{Image,OutputImageLabel,SecondImage}];

	ImageMultiply[
		Image->image,
		OutputImageLabel->outputImageLabel,
		SecondImage->secondImage
	]

];

(* ::Subsubsection:: *)
(* resolveRidgeFilterPrimitive *)

(* Different overlaods for image adjust *)
resolveRidgeFilterPrimitive[
	myPrimitive_RidgeFilter,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,image,outputImageLabel,
		scale,interpolationOrder,padding,imageAdjust
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,scale,interpolationOrder,padding,imageAdjust}=
		Lookup[safeOptions,{Image,OutputImageLabel,Scale,InterpolationOrder,Padding,ImageAdjust}];

	RidgeFilter[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Scale->scale,
		InterpolationOrder->interpolationOrder,
		Padding->padding,
		ImageAdjust->imageAdjust
	]

];

(* ::Subsubsection:: *)
(* resolveStandardDeviationFilterPrimitive *)

(* Different overlaods for image adjust *)
resolveStandardDeviationFilterPrimitive[
	myPrimitive_StandardDeviationFilter,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,image,outputImageLabel,
		radius,imageAdjust
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,radius,imageAdjust}=
		Lookup[safeOptions,{Image,OutputImageLabel,Radius,ImageAdjust}];

	StandardDeviationFilter[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Radius->radius,
		ImageAdjust->imageAdjust
	]

];


(* ::Subsubsection:: *)
(* resolveGradientFilterPrimitive *)

(* Different overlaods for image adjust *)
resolveGradientFilterPrimitive[
	myPrimitive_GradientFilter,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,image,outputImageLabel,
		gaussianParameters,method,padding,workingPrecision,imageAdjust
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,gaussianParameters,method,padding,workingPrecision,imageAdjust}=
		Lookup[safeOptions,{Image,OutputImageLabel,GaussianParameters,Method,Padding,WorkingPrecision,ImageAdjust}];

	GradientFilter[
		Image->image,
		OutputImageLabel->outputImageLabel,
		GaussianParameters->gaussianParameters,
		Method->method,
		Padding->padding,
		WorkingPrecision->workingPrecision,
		ImageAdjust->imageAdjust
	]

];

(* ::Subsubsection:: *)
(* resolveGaussianFilterPrimitive *)

(* Different overlaods for image adjust *)
resolveGaussianFilterPrimitive[
	myPrimitive_GaussianFilter,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,image,outputImageLabel,
		gaussianParameters,method,padding,workingPrecision,standardized,imageAdjust
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,gaussianParameters,method,padding,workingPrecision,standardized,imageAdjust}=
		Lookup[safeOptions,{Image,OutputImageLabel,GaussianParameters,Method,Padding,WorkingPrecision,Standardized,ImageAdjust}];

	GaussianFilter[
		Image->image,
		OutputImageLabel->outputImageLabel,
		GaussianParameters->gaussianParameters,
		Method->method,
		Padding->padding,
		WorkingPrecision->workingPrecision,
		Standardized->standardized,
		ImageAdjust->imageAdjust
	]

];

(* ::Subsubsection:: *)
(* resolveLaplacianGaussianFilterPrimitive *)

(* Different overlaods for image adjust *)
resolveLaplacianGaussianFilterPrimitive[
	myPrimitive_LaplacianGaussianFilter,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,image,outputImageLabel,
		gaussianParameters,method,padding,workingPrecision,standardized,imageAdjust
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,gaussianParameters,method,padding,workingPrecision,standardized,imageAdjust}=
		Lookup[safeOptions,{Image,OutputImageLabel,GaussianParameters,Method,Padding,WorkingPrecision,Standardized,ImageAdjust}];

	LaplacianGaussianFilter[
		Image->image,
		OutputImageLabel->outputImageLabel,
		GaussianParameters->gaussianParameters,
		Method->method,
		Padding->padding,
		WorkingPrecision->workingPrecision,
		Standardized->standardized,
		ImageAdjust->imageAdjust
	]

];

(* ::Subsubsection:: *)
(* resolveBilateralFilterPrimitive *)

(* Different overlaods for image adjust *)
resolveBilateralFilterPrimitive[
	myPrimitive_BilateralFilter,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,image,outputImageLabel,
		radius,pixelValueSpread,workingPrecision,maxIterations,imageAdjust
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,radius,pixelValueSpread,workingPrecision,maxIterations,imageAdjust}=
		Lookup[safeOptions,{Image,OutputImageLabel,Radius,PixelValueSpread,WorkingPrecision,MaxIterations,ImageAdjust}];

	BilateralFilter[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Radius->radius,
		PixelValueSpread->pixelValueSpread,
		WorkingPrecision->workingPrecision,
		MaxIterations->maxIterations,
		ImageAdjust->imageAdjust
	]

];


(* ::Subsubsection:: *)
(* resolveImageAdjustPrimitive *)

(* Different overlaods for image adjust *)
resolveImageTrimPrimitive[
	myPrimitive_ImageTrim,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		image,outputImageLabel,margin,roi,padding,dataRange,resolvedROI,hemocytometer,gridPattern,hemocytometerSquarePosition,
		hemocytometerSquareCoordinates,myRound
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,roi,margin,padding,dataRange}=
		Lookup[safeOptions,{Image,OutputImageLabel,ROI,Margin,Padding,DataRange}];

	(** Hemocytometer Specifications **)

	(* Whether the image is associated with the hemocytometer *)
	hemocytometer=Lookup[myExpandedOptions,Hemocytometer];

	(* If the image is associated with the hemocytometer, what is the grid pattern *)
	gridPattern=Lookup[myExpandedOptions,GridPattern];

	(* The square in the hemocytometer grid pattern that is our region of interest *)
	hemocytometerSquarePosition=Lookup[myExpandedOptions,HemocytometerSquarePosition];

	(* The coordinates of the hemocytometer square that is the region of interest *)
	hemocytometerSquareCoordinates=If[hemocytometer,
		findHemocytometerSquareCoordinates[
			myImage,
			gridPattern,
			hemocytometerSquarePosition
		]
	];

	(* The coordinates of the hemocytometer square that is the region of interest *)
	resolvedROI=Which[
		hemocytometer && MatchQ[roi,Automatic],
			hemocytometerSquareCoordinates,
		hemocytometer && !MatchQ[roi,Automatic],
			roi,
		!hemocytometer && MatchQ[roi,Automatic],
			{{1,1},ImageDimensions[myImage]},
		True,
			roi
	];

	(* To display a certain number of significant figures for distributions and numbers *)
	myRound[number_]:=Round[number,0.001];

	ImageTrim[
		Image->image,
		OutputImageLabel->outputImageLabel,
		ROI->myRound@resolvedROI,
		Margin->margin,
		Padding->padding,
		DataRange->dataRange
	]

];


(* ----------------------------------- *)
(* --- Resolving ImageSegmentation --- *)
(* ----------------------------------- *)


(* ::Subsection:: *)
(* resolveImageSegmentationPrimitives *)


DefineOptions[resolveImageSegmentationPrimitives,
	Options:>{
    OutputOption
	},
	SharedOptions:>{
	}
];


(* Overload for data object *)
resolveImageSegmentationPrimitives[
  myInputs:{ObjectP[Object[Data,Microscope]]..},
	allReferenceImages:{{ObjectP[Object[EmeraldCloudFile]]...}..},
  allExpandedOptions:{(_Rule|_RuleDelayed)..},
  mySegmentationOptions:OptionsPattern[resolveImageSegmentationPrimitives]
]:=Module[
	{
		outputSpecification,output,testsQ,allResolvedOptions,allTests,resultRule,testsRule,
		allMapThreadedOptions
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* See if we're gathering tests. *)
	testsQ=MemberQ[output,Tests];

	(* create a mapthread version of our options *)
	allMapThreadedOptions=OptionsHandling`Private`mapThreadOptions[AnalyzeCellCount,allExpandedOptions];

	{allResolvedOptions,allTests}=Transpose[

		If[MatchQ[allReferenceImages,{{}..}],

			(* For no images, return empty resolved options and tests *)
			ConstantArray[{{},{}},Length[myInputs]],

			MapThread[
				Function[{referenceImages,expandedOptions},
					resolveImageSegmentationPrimitives[
						referenceImages,
						KeyValueMap[Rule[#1,#2]&,expandedOptions],
						Output->{Result,Tests}
					]
				],
				{allReferenceImages,allMapThreadedOptions}
			]
		]
	];

	(* A list of allResolvedOptions for all inputs *)
	resultRule=Result->allResolvedOptions;

	(* A list containing lists of all tests ran for all inputs *)
	testsRule=Tests->allTests;

	outputSpecification/.{testsRule,resultRule}

];

resolveImageSegmentationPrimitives[
  myInputs:{ObjectP[Object[EmeraldCloudFile]]..},
  myExpandedOptions:{(_Rule|_RuleDelayed)..},
  mySegmentationOptions:OptionsPattern[resolveImageSegmentationPrimitives]
]:=Module[

	{
    outputSpecification,output,testsQ,
    allMapThreadedOptions,allResolvedOptions,resultRule,testsRule,adjustmentAddedFinalPrimitives,
		images,allTests
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* See if we're gathering tests. *)
	testsQ=MemberQ[output,Tests];

	(* Import the cloud file - we are going to *)
	images=ImportCloudFile@myInputs;

	(* create a mapthread version of our options *)
	allMapThreadedOptions=OptionsHandling`Private`mapThreadOptions[AnalyzeCellCount,myExpandedOptions];

	(* Mapping over all of the inputs with their options *)
	{allResolvedOptions,allTests}=Transpose@MapThread[
		Function[
			{myInput,image,inputIndex,mapThreadOptions},
			Module[
				{
					imageSegmentationOption,imageSegmentationPrimitives,
					(* for error checking *)
					primitiveSetInformation,allPrimitiveInformation,primitiveHeads,
					(* for resolving primitives *)
					automaticQ,automaticPrimitives,resultRule,finalPrimitives,
					(* for running tests *)
					validPritimivePatternTest,validPritimiveLabelTest,allPrimitiveTests,testsRule,
					resolvedImageSegmentationPrimitives,imageAdjustmentOption,imageAdjustmentPrimitives
				},

				(** Find Primitives **)

				(* We'll pass image adjustment resolved options to validPritimiveLabelTest check for labels *)
				imageAdjustmentOption=Lookup[mapThreadOptions,ImageAdjustment];

				(* Make sure that a singlet primitive is listed not to break mapping *)
				imageAdjustmentPrimitives=ToList[imageAdjustmentOption];

				(* Finding the image segmentation in the resolved option - Convert to association for better handling *)
				imageSegmentationOption=Lookup[mapThreadOptions,ImageSegmentation];

				(* Make sure that a singlet primitive is listed not to break mapping *)
				imageSegmentationPrimitives=If[MatchQ[imageSegmentationOption,None],
					{},
					ToList[imageSegmentationOption]
				];

				(* Lookup information about our primitive set from our backend association. *)
				primitiveSetInformation=Lookup[$PrimitiveSetPrimitiveLookup, Hold[ImageSegmentationPrimitiveP]];
				allPrimitiveInformation=Lookup[primitiveSetInformation, Primitives];
				primitiveHeads=Keys[allPrimitiveInformation];

				(* If automatic is chosen we will find the image segmentation primitives based on the master switch *)
			  automaticQ=MatchQ[imageSegmentationOption,Automatic];

				(* Set all of the automatic image segmentation based on the other option *)
				automaticPrimitives=If[automaticQ,
					populateImageSegmentationprimitives[myInput,image,KeyValueMap[Rule[#1,#2]&,mapThreadOptions]]
				];

				(* We are going to pass this set of primitives to the resolve functions *)
				finalPrimitives=If[automaticQ,
					automaticPrimitives,
					imageSegmentationPrimitives
				];

				(* We'll add adjustment primitives to check for the labels *)
				adjustmentAddedFinalPrimitives=Join[
					imageAdjustmentPrimitives,
					finalPrimitives
				];

				(** Pattern checking **)
				validPritimivePatternTest =
					If[
						MatchQ[
							checkPrimitivesPattern[
								ImageSegmentation,
								finalPrimitives,
								primitiveSetInformation,
								allPrimitiveInformation,
								primitiveHeads
							],
							$Failed
						],
						(* Throw a message indicating for which input we failed *)
						If[!testsQ,Message[Error::InvalidOption,myInput]];
						Test["All the ImageSegmentation primitives have been specified with correct patterns.", True, False],
						Test["All the ImageSegmentation primitives have been specified with correct patterns.", True, True]
					];

				(** Label checking **)

				validPritimiveLabelTest =
					If[
						MatchQ[
							checkPrimitivesLabel[
								ImageSegmentation,
								adjustmentAddedFinalPrimitives,
								primitiveSetInformation,
								allPrimitiveInformation,
								primitiveHeads
							],
							$Failed
						],
						(* Throw a message indicating for which input we failed *)
						If[!testsQ,Message[Error::InvalidOption,myInput]];
						Test["The labels used in the ImageSegmentation primitives are availabe.", True, False],
						Test["The labels used in the ImageSegmentation primitives are availabe.", True, True]
					];

				(** Resolve primitives **)

				(* Go through each of our primitives and check them. *)
				resolvedImageSegmentationPrimitives=
					(* For non automatic, lookup the primitives one by one and resolve their options *)
					MapThread[
						Function[{currentPrimitive, primitiveIndex},
							Module[
								{
									segmentationFunction,segmentationFunctionResolveFunction,segmentationFunctionInformation,segmentationFunctionDefaultList
								},

								(* Convert to association for better handling *)
								currentPrimitiveAssociation=Association@@currentPrimitive;

								(* The segmentation function is the head of the primitive *)
								segmentationFunction=Head[currentPrimitive];

								(* All the primitive information for our specific adjustment function *)
								segmentationFunctionInformation=Lookup[allPrimitiveInformation,segmentationFunction];

								(* Finding the resolve function from allPrimitiveInformation *)
								segmentationFunctionResolveFunction=Lookup[segmentationFunctionInformation,ExperimentFunction];

								(* Apply the resolve option based on the segmentation function *)
								segmentationFunctionResolveFunction@@{
									currentPrimitive,
									segmentationFunctionInformation,
									primitiveIndex,
									myInput,
									inputIndex,
									image,
									KeyValueMap[Rule[#1,#2]&,mapThreadOptions]
								}

							]
						],
						{finalPrimitives, Range[Length[finalPrimitives]]}
					];

				(* Combine all of the tests we ran on this primitive *)
				allPrimitiveTests={validPritimivePatternTest,validPritimiveLabelTest};

				{resolvedImageSegmentationPrimitives,allPrimitiveTests}

			]
		],
		{myInputs,images,Range[Length[myInputs]],allMapThreadedOptions}
	];

	(* A list of allResolvedOptions for all inputs *)
	resultRule=Result->allResolvedOptions;

	(* A list containing lists of all tests ran for all inputs *)
	testsRule=Tests->allTests;

	outputSpecification/.{testsRule,resultRule}

];


(* ::Subsubsection:: *)
(* populateImageSegmentationprimitives *)

(* Helper function to automatically poplulate the primitives based on the user and data options *)
populateImageSegmentationprimitives[
	myInput:ObjectP[Object[EmeraldCloudFile]],
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		method,hemocytometer,masterSwitch,measureConfluency,minComponentRadius,maxComponentRadius,areaThreshold,selectComponentCriteria,
		measureCellViability
	},

	(* Whether the counting is manual or automatic *)
	method=Lookup[myExpandedOptions,Method];

	(* Whether the image is associated with the hemocytometer *)
	hemocytometer=Lookup[myExpandedOptions,Hemocytometer];

	(* Whether the image is associated with the confluency measurement *)
	measureConfluency=Lookup[myExpandedOptions,MeasureConfluency];

	(* Whether the image is associated with the viability measurement *)
	measureCellViability=Lookup[myExpandedOptions,MeasureCellViability];

	(* Specify the master switch here *)
	masterSwitch=Which[
		(hemocytometer && measureCellViability),
			"Hemocytometer & CellViability",
		hemocytometer,
			"Hemocytometer",
		measureConfluency,
			"MeasureConfluency",
		measureCellViability,
			"MeasureCellViability",
		True,
			None
	];

	If[MatchQ[myImage,{}] || MatchQ[method,Manual],

		(* For no image, no image adjustment *)
		{},

		Switch[masterSwitch,

			"Hemocytometer",
				{
					EdgeDetect[Image->"ImageAdjustment Result"],
					Closing[Kernel->3],
					Dilation[Kernel->DiskMatrix[2]],
					Erosion[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
					RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
					MorphologicalBinarize[Threshold->{0.15,0.5},Method->Entropy,OutputImageLabel->"mask"],
					(*Remove the background mesh*)
					Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"],
					DistanceTransform[Image->"inpainted",Padding->0,ImageAdjust->True],
					MaxDetect[Height->0.02,OutputImageLabel->"marker"],
					GradientFilter[Image->"inpainted",GaussianParameters->3, OutputImageLabel->"filtered"],
					WatershedComponents[Marker->"marker",Method->Basins,OutputImageLabel->"components"],
					SelectComponents[Image->{"ImageAdjustment Result","components"}, Criteria->( (#EquivalentDiskRadius>=1.5) && (#EquivalentDiskRadius<=15) && (#Area>=20) && (#Area<=250) && (#Circularity>0.8) && (#Circularity<1.1) & )]
				},
			"MeasureConfluency",
				{
					StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
					Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
					StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
					Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
					(* Dilate only the big window result *)
					Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
					ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
					Closing[Kernel->ConstantArray[1,{6,6}]],
					Opening[Kernel->ConstantArray[1,{6,6}]]
				},

			"MeasureCellViability",
				{
					Binarize[OutputImageLabel->"binarized"],
					EdgeDetect[],
					Closing[Kernel->3],
					Dilation[Kernel->DiskMatrix[2]],
					Erosion[Kernel->DiskMatrix[2],OutputImageLabel->"closed"],
					FillingTransform[OutputImageLabel->"filled"],
					DistanceTransform[Padding->0,ImageAdjust->True],
					MaxDetect[Height->0.02,OutputImageLabel->"marker"],
					WatershedComponents[Image->"filled",Marker->"marker",Method->Basins,BitMultiply->"filled",OutputImageLabel->"components"],
					SelectComponents[Image->{"ImageAdjustment Result","components"}]
				},
			(* The default set of segmentation processing steps *)
			_,
				{
					EdgeDetect[Threshold->1,Padding->Fixed],
					Closing[Kernel->2],
					FillingTransform[OutputImageLabel->"filled"],
					DistanceTransform[Padding->0,ImageAdjust->True],
					MaxDetect[Height->0.01,OutputImageLabel->"marker"],
					WatershedComponents[Image->"filled",Marker->"marker",Method->Basins,BitMultiply->"filled",OutputImageLabel->"components"],
					SelectComponents[Image->{"filled","components"}]
				}
		]
	]

];


(* ::Subsubsection:: *)
(* resolveEdgeDetectPrimitive *)

(* Different overlaods for image adjust *)
resolveEdgeDetectPrimitive[
	myPrimitive_EdgeDetect,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,range,threshold,
		method,padding
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,range,threshold,method,padding}=
		Lookup[safeOptions,{Image,OutputImageLabel,Range,Threshold,Method,Padding}];

	EdgeDetect[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Range->range,
		Threshold->threshold,
		Method->method,
		Padding->padding
	]

];


(* ::Subsubsection:: *)
(* resolveErosionPrimitive *)

resolveErosionPrimitive[
	myPrimitive_Erosion,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,kernel,padding
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,kernel,padding}=
		Lookup[safeOptions,{Image,OutputImageLabel,Kernel,Padding}];

	Erosion[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Kernel->kernel,
		Padding->padding
	]

];

(* ::Subsubsection:: *)
(* resolveDilationPrimitive *)

resolveDilationPrimitive[
	myPrimitive_Dilation,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,kernel,padding
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,kernel,padding}=
		Lookup[safeOptions,{Image,OutputImageLabel,Kernel,Padding}];

	Dilation[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Kernel->kernel,
		Padding->padding
	]

];

(* ::Subsubsection:: *)
(* resolveClosingPrimitive *)

resolveClosingPrimitive[
	myPrimitive_Closing,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,kernel,padding
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,kernel}=
		Lookup[safeOptions,{Image,OutputImageLabel,Kernel}];

	Closing[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Kernel->kernel
	]

];

(* ::Subsubsection:: *)
(* resolveOpeningPrimitive *)

resolveOpeningPrimitive[
	myPrimitive_Opening,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,kernel,padding
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,kernel}=
		Lookup[safeOptions,{Image,OutputImageLabel,Kernel}];

	Opening[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Kernel->kernel
	]

];

(* ::Subsubsection:: *)
(* resolveMorphologicalBinarizePrimitive *)

resolveMorphologicalBinarizePrimitive[
	myPrimitive_,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,
		method,threshold,cornerNeighbors
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,method,threshold,cornerNeighbors}=
		Lookup[safeOptions,{Image,OutputImageLabel,Method,Threshold,CornerNeighbors}];

	MorphologicalBinarize[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Method->method,
		Threshold->threshold,
		CornerNeighbors->cornerNeighbors
	]

];

(* ::Subsubsection:: *)
(* resolveBinarizePrimitive *)

resolveBinarizePrimitive[
	myPrimitive_Binarize,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,
		method,threshold
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,method,threshold}=
		Lookup[safeOptions,{Image,OutputImageLabel,Method,Threshold}];

	Binarize[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Method->method,
		Threshold->threshold
	]

];

(* ::Subsubsection:: *)
(* resolveInpaintPrimitive *)

resolveInpaintPrimitive[
	myPrimitive_Inpaint,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,
		region,maxIterations,method
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,region,maxIterations,method}=
		Lookup[safeOptions,{Image,OutputImageLabel,Region,MaxIterations,Method}];

	Inpaint[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Region->region,
		MaxIterations->maxIterations,
		Method->method
	]

];

(* ::Subsubsection:: *)
(* resolveDistanceTransformPrimitive *)

resolveDistanceTransformPrimitive[
	myPrimitive_DistanceTransform,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,
		threshold,distanceFunction,imageAdjust,padding
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,threshold,distanceFunction,imageAdjust,padding}=
		Lookup[safeOptions,{Image,OutputImageLabel,Threshold,DistanceFunction,ImageAdjust,Padding}];

	DistanceTransform[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Threshold->threshold,
		DistanceFunction->distanceFunction,
		ImageAdjust->imageAdjust,
		Padding->padding
	]

];

(* ::Subsubsection:: *)
(* resolveMinDetectPrimitive *)

resolveMinDetectPrimitive[
	myPrimitive_MinDetect,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,
		height,cornerNeighbors,padding
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,height,cornerNeighbors,padding}=
		Lookup[safeOptions,{Image,OutputImageLabel,Height,CornerNeighbors,Padding}];

	MinDetect[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Height->height,
		CornerNeighbors->cornerNeighbors,
		Padding->padding
	]

];

(* ::Subsubsection:: *)
(* resolveMaxDetectPrimitive *)

resolveMaxDetectPrimitive[
	myPrimitive_MaxDetect,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,safeOptions,defaultList,image,outputImageLabel,
		height,cornerNeighbors,padding
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,height,cornerNeighbors,padding}=
		Lookup[safeOptions,{Image,OutputImageLabel,Height,CornerNeighbors,Padding}];

	MaxDetect[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Height->height,
		CornerNeighbors->cornerNeighbors,
		Padding->padding
	]

];

(* ::Subsubsection:: *)
(* resolveWatershedComponentsPrimitive *)

(* Different overlaods for image adjust *)
resolveWatershedComponentsPrimitive[
	myPrimitive_WatershedComponents,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		image,outputImageLabel,marker,method,cornerNeighbors,colorNegate,bitMultiply,imageApply
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,marker,method,cornerNeighbors,colorNegate,bitMultiply,imageApply}=
		Lookup[safeOptions,{Image,OutputImageLabel,Marker,Method,CornerNeighbors,ColorNegate,BitMultiply,ImageApply}];

	WatershedComponents[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Marker->marker,
		Method->method,
		CornerNeighbors->cornerNeighbors,
		ColorNegate->colorNegate,
		BitMultiply->bitMultiply,
		ImageApply->imageApply
	]

];

(* ::Subsubsection:: *)
(* resolveMorphologicalComponentsPrimitive *)

(* Different overlaods for image adjust *)
resolveMorphologicalComponentsPrimitive[
	myPrimitive_MorphologicalComponents,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		image,outputImageLabel,threshold,method,cornerNeighbors,padding
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,threshold,method,cornerNeighbors,padding}=
		Lookup[safeOptions,{Image,OutputImageLabel,Threshold,Method,CornerNeighbors,Padding}];

	MorphologicalComponents[
		Image->image,
		OutputImageLabel->outputImageLabel,
		Threshold->threshold,
		Method->method,
		CornerNeighbors->cornerNeighbors,
		Padding->padding
	]

];

(* ::Subsubsection:: *)
(* resolveSelectComponentsPrimitive *)

(* Different overlaods for image adjust *)
resolveSelectComponentsPrimitive[
	myPrimitive_SelectComponents,
	myPrimitiveInformation_Association,
	myPrimitiveIndex_Integer,
	myInput_,
	myInputIndex_Integer,
	myImage_Image,
	myExpandedOptions:{(_Rule|_RuleDelayed)..}
]:=Module[
	{
		primitiveAssociation,optionDefinition,defaultList,safeOptions,
		image,outputImageLabel,labelMatrix,criteria,property,orderingCount,orderingFunction,
		resolvedProperty,resolvedOrderingCount,resolvedOrderingFunction,unusedProperty,
		minComponentRadius,maxComponentRadius,areaThreshold,resolvedCriteria,imageScale,minComponentRadiusPixels,
		maxComponentRadiusPixels,areaThresholdPixels,intensityThreshold
	},

	(* Convert to association for better handling *)
	primitiveAssociation=Association@@myPrimitive;

	(* A list of all option definitions for the primitive function *)
	optionDefinition=Lookup[myPrimitiveInformation, OptionDefinition];

	(* A list with the default values *)
	defaultList=Map[
		Module[{optionName,default},
			optionName=#["OptionName"];
			default=ReleaseHold[#["Default"]];
			Rule[
				If[StringQ[optionName],Symbol[optionName],optionName],
				If[StringQ[default],Symbol[default],default]
			]
		]&,
		optionDefinition
	];

	(* For safeOptions, we replace the default list with the ones specified in the primitive *)
	safeOptions=ReplaceRule[defaultList,KeyValueMap[Rule[#1,#2]&,primitiveAssociation]];

	(* Look for the safe options and we will resolve if automatic *)
	{image,outputImageLabel,labelMatrix,criteria,property,orderingCount,orderingFunction}=
		Lookup[safeOptions,{Image,OutputImageLabel,LabelMatrix,Criteria,Property,OrderingCount,OrderingFunction}];

	unusedProperty=If[
		(!MatchQ[criteria,Null] && !MatchQ[property,Null]),
		Message[Warning::UnusedProperty,myPrimitiveIndex,myInputIndex];
		True,
		False
	];

	(* Take MinComponentRadius, MaxComponentRadius, and AreaThreshold to add to the SelectComponents primitive *)
	(* The cell size criteria that is specified and will affect the select component primitive *)
	{imageScale,minComponentRadius,maxComponentRadius,areaThreshold,intensityThreshold}=Lookup[myExpandedOptions,{ImageScale,MinComponentRadius,MaxComponentRadius,AreaThreshold,IntensityThreshold}];

	(* Converting the units to pixels *)
	minComponentRadiusPixels=Which[
		MatchQ[imageScale,Null] && MatchQ[minComponentRadius,UnitsP[Micrometer]],
			Unitless[minComponentRadius],
		MatchQ[minComponentRadius,UnitsP[Micrometer]],
			If[MatchQ[imageScale,{_,_}],
				Unitless[minComponentRadius/Mean[imageScale],Pixel],
				Unitless[minComponentRadius/imageScale,Pixel]
			],
		True,
			Unitless[minComponentRadius,Pixel]
	];
	maxComponentRadiusPixels=Which[
		MatchQ[imageScale,Null] && MatchQ[maxComponentRadius,UnitsP[Micrometer]],
			Unitless[maxComponentRadius],
		MatchQ[maxComponentRadius,UnitsP[Micrometer]],
			If[MatchQ[imageScale,{_,_}],
				Unitless[maxComponentRadius/Mean[imageScale],Pixel],
				Unitless[maxComponentRadius/imageScale,Pixel]
			],
		True,
			Unitless[maxComponentRadius,Pixel]
	];

	areaThresholdPixels=Which[
		MatchQ[imageScale,Null] && MatchQ[areaThreshold,UnitsP[Micrometer^2]],
			Unitless[areaThreshold],
		MatchQ[areaThreshold,UnitsP[Micrometer^2]],
			If[MatchQ[imageScale,{_,_}],
				Unitless[areaThreshold/Times[imageScale[[1]],imageScale[[2]]],Pixel^2],
				Unitless[areaThreshold/imageScale^2,Pixel^2]
			],
		True,
			Unitless[areaThreshold,Pixel^2]
	];

	(* The coordinates of the hemocytometer square that is the region of interest *)
	resolvedCriteria=If[MatchQ[criteria,Automatic],
		With[{insertMe1=areaThresholdPixels,insertMe2=minComponentRadiusPixels,insertMe3=maxComponentRadiusPixels,insertMe4=intensityThreshold},
			(
				(#Area >= insertMe1) &&
				(#EquivalentDiskRadius>=insertMe2) &&
				(#EquivalentDiskRadius<=insertMe3) &
			)
		],
		With[{insertMeCriteria=criteria[[1]],insertMe1=areaThresholdPixels,insertMe2=minComponentRadiusPixels,insertMe3=maxComponentRadiusPixels,insertMe4=intensityThreshold},
			(
				insertMeCriteria &&
				(#Area >= insertMe1) &&
				(#EquivalentDiskRadius>=insertMe2) &&
				(#EquivalentDiskRadius<=insertMe3) &
			)
		]
	];

	(* If criteria is selected, the property can't be specified and will be set to Null *)
	{resolvedProperty,resolvedOrderingCount,resolvedOrderingFunction}=If[unusedProperty,
		{Null,Null,Null},
		{property,orderingCount,orderingFunction}
	];

	SelectComponents[
		Image->image,
		OutputImageLabel->outputImageLabel,
		LabelMatrix->labelMatrix,
		Criteria->resolvedCriteria,
		Property->resolvedProperty,
		OrderingCount->orderingCount,
		OrderingFunction->orderingFunction
	]

];
