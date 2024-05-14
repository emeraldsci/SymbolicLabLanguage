(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*MicroscopeImageSelect*)


(* ::Subsubsection:: *)
(*MicroscopeImageSelect options*)

DefineOptions[MicroscopeImageSelect,
	Options:>{
		ImageSelectOptions,
		OutputOption,
		CacheOption
	}
];

(* ::Subsubsection:: *)
(*MicroscopeImageSelect messages*)


Warning::MicroscopeImageSelectNoData="There is no data provided in the following protocol(s): `1`.";
Error::MicroscopeImageSelectNoData="There is no data at all in the provided inputs. Please add protocols or data objects with actual data.";


(* ::Subsubsection:: *)
(*MicroscopeImageSelect*)


(* Handle the no input case *)
MicroscopeImageSelect[Alternatives[Null,{}],myOptions:OptionsPattern[MicroscopeImageSelect]]:=Module[{listedOptions,outputSpecification},
	listedOptions=ToList[myOptions];
	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[listedOptions,Output,Result];
	outputSpecification/.{Alternatives[Result,Options,Preview,Tests]->Null}
];


(* Preprocessing -- Handle the case of mixed protocol objects and data objects input *)
(* Memoize the result for faster access in the builder - when used in CellCount *)
MicroscopeImageSelect[
	myInput:ListableP[Alternatives[ObjectP[Object[Protocol,ImageCells]],ObjectP[Object[Data,Microscope]]]],
	myOptions:OptionsPattern[MicroscopeImageSelect]
]:=MicroscopeImageSelect[myInput,myOptions]=Module[
	{
		listedInput,listedOptions,outputSpecification,output,gatherTests,messages,safeOptions,safeOptionTests,updatedListedOptions,
		protocolObjects,protocolPackets,protocolDataObjects,dataObjectMap,noDataProtocols,mapThreadedOptions,expandedInputs,
		expandedOptions,finalDataObjects,expandedOptionValues,noDataBool,combinedDataOptions,collapsedIndexMatchedOptions,
		finalDataOptions,noDataProtocolsWarning,noDataTest,mainFunctionOutput
	},

	(* make sure inputs and options are in a list *)
	listedInput=ToList[myInput];
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[listedOptions,Output,Result];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* determine the requested return value from the function *)
	output=Lookup[listedOptions,OutputFormat,Association];

	(* pre-process our options by wrapping list around single value of options with Adder widget *)
	(* this is to make sure that mapThreadOption does not get confused with singleton pattern when transposing the values *)
	updatedListedOptions=KeyValueMap[
		Function[{key,value},
			If[MatchQ[key,Output|Cache]||MatchQ[value,All|_Span],
				key->value,
				key->ToList[value]
			]
		],
		Association@@listedOptions
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[MicroscopeImageSelect,updatedListedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[MicroscopeImageSelect,updatedListedOptions,AutoCorrect->False],Null}
	];

	(* expand our options *)
	{expandedInputs,expandedOptions}=ExpandIndexMatchedInputs[MicroscopeImageSelect,{listedInput},safeOptions,Messages->False];

	(* get all of our protocol objects from our input *)
	protocolObjects=Download[Cases[listedInput,ObjectP[Object[Protocol,ImageCells]]],Object];

	(* download data objects from our protocols *)
	protocolPackets=Download[protocolObjects,Packet[Data]];
	protocolDataObjects=Download[Lookup[protocolPackets,Data],Object];

	(* create a map between our protocol object and the respective data objects *)
	dataObjectMap=MapThread[#1->#2&,{protocolObjects,protocolDataObjects}];

	(* get any protocols without data *)
	noDataProtocols=Cases[protocolPackets,KeyValuePattern[{Object->prot_,Data->{}|Null}]:>prot];

	(* if there's any protocol without data and we're throwing messages, throw a warning *)
	If[Length[noDataProtocols]>0&&messages,
		Message[Warning::MicroscopeImageSelectNoData,noDataProtocols]
	];

	(* if we are gathering tests, create a warning test *)
	noDataProtocolsWarning=If[gatherTests,
		Warning["All protocols have data objects:",
			Length[noDataProtocols]>0,
			False
		],
		Nothing
	];

	(* create a mapthread version of our options *)
	mapThreadedOptions=OptionsHandling`Private`mapThreadOptions[MicroscopeImageSelect,expandedOptions];

	(* expand our options from protocol to data *)
	expandedOptionValues=MapThread[
		(* leave options alone if given a data object, if given a protocol object, lookup the data objects in the map and expand. *)
		Function[{input,options},
			If[MatchQ[input,ObjectP[Object[Protocol,Microscope]]],
				{Last@ExpandIndexMatchedInputs[MicroscopeImageSelect,{input/.dataObjectMap},Normal[options],Messages->False]},
				{Normal[options]}
			]
		],
		{listedInput,mapThreadedOptions}
	];

	(* Get the final list of data objects that we will send to the main function *)
	finalDataObjects=Flatten[listedInput/.dataObjectMap];

	(* if there's no data objects supplied at all, return early *)
	noDataBool=Length[finalDataObjects]==0;
	If[noDataBool&&messages,
		Message[Error::MicroscopeImageSelectNoData];
		Return[$Failed]
	];

	(* if we are gathering tests, create a corresponding test *)
	noDataTest=If[gatherTests,
		Test["There is at least one data object input:",
			noDataBool,
			False
		],
		Nothing
	];

	(* for the data options, we combine all the values for the same key under one key *)
	combinedDataOptions=If[noDataBool,
		{},
		Module[{indexMatchedOptions},
			indexMatchedOptions=Join@@expandedOptionValues;
			Keys[#][[1]]->Flatten@Values[#]&/@Transpose[indexMatchedOptions]
		]
	];

	(* convert expanded options back to singletons *)
	collapsedIndexMatchedOptions=CollapseIndexMatchedOptions[MicroscopeImageSelect,combinedDataOptions,Messages->False];

	(* collapse the non-index-matched options *)
	finalDataOptions=collapsedIndexMatchedOptions/.{
		Rule[x:Output,y_List]:>Rule[x,outputSpecification]
	};

	(* Call the main function that will give us the output we want *)
	mainFunctionOutput=MicroscopeImageSelect[finalDataObjects,finalDataOptions];

	(* Check if we are gathering tests, if so, add the noDataTest to the main function output and return the new output *)
	If[gatherTests,
		Which[
			(* If we only specify tests, i.e. Output->Tests, we have one case for when there are no tests returned from the main function *)
			MatchQ[outputSpecification,Tests]&&MatchQ[mainFunctionOutput,Null],{noDataTest,noDataProtocolsWarning},

			(* We have another case for when there are returned tests from the main functions *)
			MatchQ[outputSpecification,Tests],Join[mainFunctionOutput,{noDataTest,noDataProtocolsWarning}],

			(* If there are other specified options, e.g. Output->{Tests,Result}, then we have to insert the noDataTest *)
			True,
			Module[{testsIndex,listedOutput,originalTests,newTests},

				(* Get the index of the Tests in the output list *)
				testsIndex=First@FirstPosition[output,Tests];

				(* Should be in a list already, but just to be safe and then shorten the name *)
				listedOutput=ToList[mainFunctionOutput];
				originalTests=listedOutput[[testsIndex]];

				(* Consolidate the tests *)
				newTests=Join[originalTests,{noDataTest,noDataProtocolsWarning}];

				(* Modify the tests *)
				listedOutput[[testsIndex]]=newTests;
				listedOutput
			]
		],
		(* Else, just return the main function output *)
		mainFunctionOutput
	]
];

(* Main function *)
(* Memoize the result for faster access in the builder - when used in CellCount *)
MicroscopeImageSelect[
	myData:ListableP[ObjectP[Object[Data,Microscope]]],
	myOptions:OptionsPattern[MicroscopeImageSelect]
]:=MicroscopeImageSelect[myData,myOptions]=Module[
	{
		listedOptions,listedData,outputSpecification,output,gatherTests,messages,updatedListedOptions,safeOptions,
		safeOptionTests,validLengths,validLengthTests,cache,downloadedImagesAssociations,instrumentPackets,expandedOptions,
		mapThreadedOptions,selectedAssociations
	},
	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Make sure our data are in a list *)
	listedData=ToList[myData];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[listedOptions,Output,Result];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* pre-process our options by wrapping list around single value of options with Adder widget *)
	(* this is to make sure that mapThreadOption does not get confused when transposing the values *)
	updatedListedOptions=KeyValueMap[
		Function[{key,value},
			If[MatchQ[key,Output|Cache]||MatchQ[value,All|_Span],
				key->value,
				key->ToList[value]
			]
		],
		Association@@listedOptions
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[MicroscopeImageSelect,updatedListedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[MicroscopeImageSelect,updatedListedOptions,AutoCorrect->False],Null}
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[MicroscopeImageSelect,{listedData},updatedListedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[MicroscopeImageSelect,{listedData},updatedListedOptions],Null}
	];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point) *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOptionTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOptionTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* -------------- *)
	(* ---DOWNLOAD--- *)
	(* -------------- *)

	(* get the cache option *)
	cache=Lookup[listedOptions,Cache,{}];

	(* download Images field from data objects *)
	{downloadedImagesAssociations,instrumentPackets}=Transpose@Download[
		listedData,
		{
			Images,
			Packet[Instrument[Model]]
		},
		Date->Now,
		Cache->cache
	];

	(* ------------------ *)
	(* ---EXTRACT DATA--- *)
	(* ------------------ *)

	(* Expand index matched options to lists that match the specified input length *)
	expandedOptions=Last@ExpandIndexMatchedInputs[MicroscopeImageSelect,{listedData},safeOptions,Messages->False];

	(* create a mapthread version of our options *)
	mapThreadedOptions=OptionsHandling`Private`mapThreadOptions[MicroscopeImageSelect,expandedOptions];

	(* mapthread over downloaded image associations and options *)
	selectedAssociations=MapThread[
		Function[{imageAssociations,myInstrumentPacket,myMapThreadOptions},
			Module[{optionsAssociation,instrumentModel,instrumentObject,instrumentOption},

				(* Look up the Instrument option value *)
				instrumentOption=Lookup[myMapThreadOptions,Instrument];

				(* get the relevant options from our mapthreaded options. keep the association format *)
				optionsAssociation=KeyTake[myMapThreadOptions,
					{Instrument,ProtocolBatchNumber,DateAcquired,Mode,ObjectiveMagnification,ObjectiveNumericalAperture,
						Objective,ImageTimepoint,ImageZStep,ImagingSite,ExcitationWavelength,EmissionWavelength,
						DichroicFilterWavelength,EmissionFilter,DichroicFilter,ExcitationPower,TransmittedLightPower,
						ExposureTime,FocalHeight,ImageCorrection,ImageSizeX,ImageSizeY,ImageScaleX,ImageScaleY,ImageBitDepth,
						PixelBinning,StagePositionX,StagePositionY,ImagingSiteRow,ImagingSiteColumn,ImagingSiteRowSpacing,
						ImagingSiteColumnSpacing,WellCenterOffsetX,WellCenterOffsetY}
				];

				(* get the data object's instrument object and model *)
				{instrumentModel,instrumentObject}=Lookup[myInstrumentPacket,{Model,Object}]/.link_Link:>Download[link,Object];

				(* check if the instrument option match either model or object in the data object *)
				If[MatchQ[instrumentOption,ListableP@ObjectP[{instrumentModel,instrumentObject}]|All],
					Module[{selectionRules},
						(* determine selection criteria for each option *)
						selectionRules=KeyValueMap[
							Function[{optionName,optionValue},
								Switch[optionValue,
									(* option value is All: we won't include this in selection criteria since we accept All cases *)
									All,Nothing,
									(* option value is an expression or list of expressions: wrap with Alternatives *)
									ListableP[_Symbol],Rule[optionName,Alternatives@@ToList[optionValue]],
									(* option value is an object or list of objects: wrap with ObjectP *)
									ListableP[ObjectP[]],Rule[optionName,ObjectP[ToList[optionValue]]],
									(* option value is a Quantity/Real/Integer (singleton): wrap with EqualP *)
									_Quantity|NumericP,Rule[optionName,EqualP[optionValue]],
									(* option is a list of Quantity/Real/Integer: wrap each member with EqualP and apply Alternatives *)
									{_Quantity|NumericP...},Rule[optionName,Alternatives@@Map[EqualP[#]&,optionValue]],
									(* option is a Span: convert to RangeP *)
									_Span,Rule[optionName,RangeP@@optionValue],
									(* else: return Nothing *)
									_,Nothing
								]
							],
							KeyDrop[optionsAssociation,Instrument]
						];

						(* select image associations that satisfy the criteria *)
						Cases[imageAssociations,KeyValuePattern[selectionRules]]
					],
					(* else: return empty list *)
					{}
				]
			]
		],
		{downloadedImagesAssociations,instrumentPackets,mapThreadedOptions}
	];

	(* ------------------- *)
	(* ---RETURN OUTPUT--- *)
	(* ------------------- *)

	outputSpecification/.{
		Result->Flatten[selectedAssociations],
		Tests->Join[safeOptionTests,validLengthTests],
		Options->RemoveHiddenOptions[MicroscopeImageSelect,expandedOptions],
		Preview->Null
	}
];
