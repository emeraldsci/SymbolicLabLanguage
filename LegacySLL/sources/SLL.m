(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*ObjectToFilePath*)


DefineOptions[ObjectToFilePath,
	Options:>{
		{OutputFormat->String,Object|ID|String,"Indicates the structure of the output string."},
		{Lowercase->True,BooleanP,"Indicates if the id should be converted to a lowercase form such that it is unique to a case-insensitive system."},
		{SpecialCharacter -> "_", "_"|"$"|"(", "Indicates the special character to use to indicate a capital letter in an ID."},
		FastTrackOption
	}
];


ObjectToFilePath::MissingObjects="Not all the provided objects exist in the database. Check `1`";


ObjectToFilePath[myObjects:ListableP[ObjectP[]],myOps:OptionsPattern[ObjectToFilePath]]:=Module[
	{defaultedOptions,specialCharacterOption,objectsList,types,ids,updatedIds,objectStrings},

	defaultedOptions = SafeOptions[ObjectToFilePath, ToList[myOps]];
	specialCharacterOption=SpecialCharacter/.defaultedOptions;

	(* Make sure we're working with a list *)
	objectsList = ToList[myObjects];

	(* If we aren't fast tracking, check all objects are in the database *)
	If[!Lookup[defaultedOptions,FastTrack],
		Module[{nonexistentObjects},

			(* Get objects for which DatabaseMemberQ returns false *)
			nonexistentObjects=PickList[
				objectsList,
				DatabaseMemberQ[objectsList],
				False
			];

			(* Return $Failed if there are objects which don't exist in the database *)
			If[!MatchQ[nonexistentObjects,{}],
				Message[ObjectToFilePath::MissingObjects,nonexistentObjects];
				Return[$Failed]
			]
		]
	];

	(* Get the types and IDs for the objects.  Do two downloads because unless we are using named objects, we can avoid a trip to the db *)
	{types,ids} = {Download[objectsList, Type], Download[objectsList, ID]};

	(* If Lowercase -> True, replace each uppercase letter in ID with lowercase form preceeded by "$" *)
	updatedIds = If[Lookup[defaultedOptions,Lowercase],
		StringReplace[#,upper : CharacterRange["A", "Z"] :> specialCharacterOption <> ToLowerCase[upper]]&/@ids,
		ids
	];

	(* Create the final list of object strings according to the OutputFormat *)
	objectStrings = Switch[Lookup[defaultedOptions,OutputFormat],
		(* Replace colon with _ *)
		ID,StringReplace[updatedIds,":" ->"_"],
		(* Drop the "id:" from each ID *)
		String,StringDrop[updatedIds,3],
		(* Recreate the objects, then replace/remove the special characters *)
		Object,Module[{reconstructedObjects},
			reconstructedObjects = MapThread[
				Append[#1,#2]&,
				{types,updatedIds}
			];
			StringReplace[ToString/@reconstructedObjects,{ "[" |", " | ":" ->"_","]"->""}]
		]
	];

	(* If a singleton input was provided, return a singleton output *)
	If[ListQ[myObjects],
		objectStrings,
		First[objectStrings]
	]
];


(* ::Subsection:: *)
(*Patterns and Conversions*)


(* ::Subsubsection::Closed:: *)
(*typeUnits*)

Authors[typeUnits]:={"platform"};

typeUnits[object : ObjectReferenceP[]]:=typeUnits[
	Download[object,Type]
];
typeUnits[packet:PacketP[]]:=typeUnits[
	packet[Type]
];
typeUnits[type:TypeP[]]:=Cases[
	Lookup[
		LookupTypeDefinition[type],
		Fields
	],
	RuleDelayed[
		Rule[x_,{___,Rule[Units,y:Except[None]],___...}],
		x->y
	]
];

(*Workaround for MM10 bug with printing from an output cell renders the output
grayed out.*)
printFullOpacity[expr_]:=CellPrint[ExpressionCell[expr,"Print",PrivateCellOptions->{"ContentsOpacity"->1.}]];


(* ::Subsubsection::Closed:: *)
(*PDBIDExistsQ*)


PDBIDExistsQ[pdbID_String] := Module[
	{importPath,imported},

	(* string join the pdb id to the importing file path *)
	importPath = "https://files.rcsb.org/download/"<>pdbID<>".pdb";

	(* import as pdb *)
	imported = Quiet[Import[importPath,"PDB"]];

	(* if the import failed, return an error message, otherwise return the graphic *)
	If[
	MatchQ[imported,$Failed],
	False,
	True
	]
];



(* ::Subsubsection::Closed:: *)
(*ProtocolTypes*)


DefineOptions[
	ProtocolTypes,
	Options :> {
		{Output -> Full, Full | Short, "Full returns every protocol type and its subtypes, Short returns only the top level parent types."}
	}
];

ProtocolTypes[ops:OptionsPattern[ProtocolTypes]]:=With[
	{
		allTypes = Apply[
			Join,
			Map[
				Types,
				{
					Object[Protocol],
					Object[Qualification],
					Object[Maintenance]
				}
			]
		]
  	},
	If[MatchQ[OptionDefault[OptionValue[Output]], Short],
		Select[allTypes, Length[#] == 1&],
		allTypes
	]
];

(* this pattern is slow and shows up everywhere so memoize it *)
If[$LazyLoading,
	ProtocolTypes[] = ProtocolTypes[];
	ProtocolTypes[Output -> Short] = ProtocolTypes[Output -> Short];
	(* totally redundant to have the long forms in ObjectP anyway; short is fine here *)
	ObjectP[ProtocolTypes[]] = ObjectP[ProtocolTypes[Output -> Short]];
];

(* ::Subsubsection::Closed:: *)
(*ProtocolTypeP*)


ProtocolTypeP[]:=TypeP[{
	Object[Protocol],
	Object[Qualification],
	Object[Maintenance]
}];



(* ::Subsubsection::Closed:: *)
(*Sample/Model/Container Patterns*)

(* because we are using bad practices in the code and occasionally we are using this as a straight MatchQ, we have to keep named object versions in here as well as IDs *)
WaterModelP:=Alternatives[
	Model[Sample, "Milli-Q water"],
	Model[Sample, "RO Water"],
	Model[Sample, "Tap Water"],
	Model[Sample,"id:8qZ1VWNmdLBD"],
	Model[Sample,"id:n0k9mGzRaaYn"],
	Model[Sample,"id:1ZA60vwjbbea"]
];

SelfContainedSampleTypes:=Types[Object[Item]];

SelfContainedSampleP:=ObjectP[SelfContainedSampleTypes];

NonSelfContainedSampleTypes:=Complement[
	Types[Object[Sample]],
	SelfContainedSampleTypes
];
NonSelfContainedSampleP:=ObjectP[
	NonSelfContainedSampleTypes
];

SelfContainedModelTypes:=Apply[Model, #] & /@ SelfContainedSampleTypes;
SelfContainedSampleModelP:=ObjectP[SelfContainedModelTypes];

NonSelfContainedModelTypes:=Complement[
	Types[Model[Sample]],
	SelfContainedModelTypes
];
NonSelfContainedSampleModelP:=ObjectP[
	NonSelfContainedModelTypes
];

FluidContainerTypes:=Flatten[
	Types/@{
		Object[Container, Vessel],
		Object[Container, Plate],
		Object[Container, GasCylinder],
		Object[Container, GraduatedCylinder],
		Object[Container, Cuvette],
		Object[Container, DosingHead],
		Object[Container, Cartridge],
		Object[Container, WasteBin],
		Object[Container, ReactionVessel],
		Object[Container, ExtractionCartridge],
		Object[Container, MicrofluidicChip],
		Object[Container, ProteinCapillaryElectrophoresisCartridge],
		Object[Container, Hemocytometer],
		Object[Container, MicroscopeSlide],
		Object[Container, Capillary],
		Object[Container, GrindingContainer],
		Object[Container, WashBath],
		Object[Container, BumpTrap]
	},
	1
];
FluidContainerP:=ObjectP[FluidContainerTypes];

FluidContainerModelTypes:=Flatten[
	Types/@{
		Model[Container, Vessel],
		Model[Container, Plate],
		Model[Container, GasCylinder],
		Model[Container, GraduatedCylinder],
		Model[Container, Cuvette],
		Model[Container, DosingHead],
		Model[Container, Cartridge],
		Model[Container, WasteBin],
		Model[Container, ReactionVessel],
		Model[Container, ExtractionCartridge],
		Model[Container, MicrofluidicChip],
		Model[Container, ProteinCapillaryElectrophoresisCartridge],
		Model[Container, Hemocytometer],
		Model[Container, MicroscopeSlide],
		Model[Container, Capillary],
		Model[Container, GrindingContainer],
		Model[Container, WashBath]
	},
	1
];
FluidContainerModelP:=ObjectP[FluidContainerModelTypes];

SingleSampleContainerTypes:=Flatten[Types/@{Object[Container,Cartridge],Object[Container,Cuvette],Object[Container, DosingHead],Object[Container, GasCylinder],Object[Container, GraduatedCylinder],Object[Container, ReactionVessel],Object[Container, Vessel]},1];
SingleSampleContainerP:=ObjectP[SingleSampleContainerTypes];

MeasureWeightContainerTypes:=Complement[SingleSampleContainerTypes,Flatten[Types/@{Object[Container, GasCylinder], Object[Container, Waste], Object[Container, DosingHead]},1]];
MeasureWeightContainerP:=ObjectP[MeasureWeightContainerTypes];
MeasureWeightModelContainerTypes:=Apply[Model,#]&/@MeasureWeightContainerTypes;
MeasureWeightModelContainerP:=ObjectP[MeasureWeightModelContainerTypes];

PlateAndWellP:={ObjectP[Object[Container,Plate]],WellPositionP};


(* ::Subsubsection:: *)
(*NamedObject*)

DefineOptions[NamedObject,
	Options:>{
		{ConvertToObjectReference->True,BooleanP,"Indicates if additional forms of constellation objects (links and packets) should be replaced with object references (Object[...]), along with having their IDs replaced with Names."},
		{MaxNumberOfObjects->Infinity,(_Integer|Infinity),"Indicates the maximum number of objects to replace IDs with Names. If there are more than MaxNumberOfObjects in the input expression, the input expression is returned untouched."},
		CacheOption
	}
];

(* A function that replace an Object's ID with it's Name, assuming Name isn't Null *)

NamedObject[Null, myOptions:OptionsPattern[]]:=Null;
NamedObject[$Failed, myOptions:OptionsPattern[]]:=$Failed;
NamedObject[{}, myOptions:OptionsPattern[]]:={};

(* Shortcut if given packet(s) with a name in it *)
NamedObject[packets : {PacketP[{Object[], Model[]}, {Object, Name}]..}, myOptions:OptionsPattern[]] := Module[
	{safeOptions, convertToObjectReferenceOption, maxObjectsOption},

	(* Process the options *)
	safeOptions=SafeOptions[NamedObject, ToList[myOptions]];

	{convertToObjectReferenceOption, maxObjectsOption} = Lookup[safeOptions, {ConvertToObjectReference, MaxNumberOfObjects}];

	(* If not converting packets or we exceed the max number of objects, don't convert and return early *)
	If[!TrueQ[convertToObjectReferenceOption] || GreaterQ[Length[packets], maxObjectsOption],
		Return[packets]
	];

	(* Otherwise convert the packets *)
	Map[
		Module[{objectName},

			(* Extract the object name *)
			objectName = Lookup[#, Name];

			(* If the name is a string, use it otherwise return the packet *)
			If[MatchQ[objectName, _String],
				Append[Most[Lookup[#, Object]], objectName],
				#
			]
		]&,
		packets
	]
];

NamedObject[packet : PacketP[{Object[], Model[]}, {Object, Name}], myOptions:OptionsPattern[]] := First[NamedObject[{packet}, myOptions]];

(* Overload to get names of all links in a nested expression (e.g., in a Composition field) *)
NamedObject[expr_, myOptions:OptionsPattern[]] := Module[
	{safeOptions, convertToObjectReferenceQ, maxNumberOfObjects, listedExpression, objectPositions, extractedObjects, convertedObjects, replacementRules, cacheOption},

	safeOptions=SafeOptions[NamedObject, ToList[myOptions]];

	(* Get our options *)
	{
		convertToObjectReferenceQ,
		maxNumberOfObjects,
		cacheOption
	} = Lookup[
		safeOptions,
		{
			ConvertToObjectReference,
			MaxNumberOfObjects,
			Cache
		}
	];

	(* ToList our expression. *)
	listedExpression=ToList[expr];

	(* Find all SLL objects in the expression to arbitrary depth *)
	objectPositions = If[MatchQ[convertToObjectReferenceQ, True],
		Position[
			listedExpression,
			(* Pull out all ObjectPs that are not a named object reference *)
			Except[
				Alternatives[
					Object[Repeated[_Symbol, {0, 5}], _String?(!StringMatchQ[#,"id:"~~__]&)],
					Model[Repeated[_Symbol, {0, 5}], _String?(!StringMatchQ[#,"id:"~~__]&)]
				]?(ObjectReferenceQ[#1] &),
				ObjectP[]
			]
		],
		Position[
			listedExpression,
			(* Pull out all ID form object references *)
			Alternatives[
				Object[Repeated[_Symbol, {0, 5}], _String?(StringMatchQ[#,"id:"~~__]&)],
				Model[Repeated[_Symbol, {0, 5}], _String?(StringMatchQ[#,"id:"~~__]&)]
			]?(ObjectReferenceQ[#1] &)
		]
	];

	(* Extract all SLL objects *)
	extractedObjects = Extract[listedExpression, objectPositions];

	(* Short circuit if we need to convert too many objects *)
	If[Length[extractedObjects]>maxNumberOfObjects,
		Return[expr]
	];

	(* Convert to named form where possible *)
	convertedObjects=convertToNamedForm[extractedObjects,convertToObjectReferenceQ, cacheOption];

	(* Generate Position->Named Object replacement rules *)
	(* NOTE: We do a little bit of error checking here since NamedObject can try to convert un-uploaded change packets. *)
	replacementRules = Rule@@@Cases[
		Transpose[{objectPositions, convertedObjects}],
		{_, ObjectReferenceP[]}
	];

	(* Replace those bastards *)
	If[MatchQ[expr, _List],
		ReplacePart[listedExpression, replacementRules],
		First@ReplacePart[listedExpression, replacementRules]
	]
];

(* Converts each object with ID to and object with Name *)
convertToNamedForm[extractedObjects_List,convertToObjectReferenceQ:BooleanP,cache:{(ObjectP[]|Null)...}]:=If[Length[extractedObjects]==0,
	{},
	Module[
		{listedInput, filteredInput, objectsExistQ, existingObjects, existingNames, existingTypes, existingNameObjects, objReplaceRules, existingIDs,
			nonexistentObjects, nonexistentObjReferences, nonexistentReplaceRules, listedInputNoNull, objectNames, objectTypes, objectIDs,
			combinedCache},

		listedInput = ToList[extractedObjects];
		listedInputNoNull = DeleteCases[listedInput, Null|$Failed];

		(* If ConvertToObjectReference -> False, then we only want to apply the function on object references. *)
		filteredInput = If[MatchQ[convertToObjectReferenceQ, True],
			listedInputNoNull,
			Cases[
				listedInputNoNull,
				Alternatives[
					Object[Repeated[_Symbol, {0, 5}], _String?(StringMatchQ[#,"id:"~~__]&)],
					Model[Repeated[_Symbol, {0, 5}], _String?(StringMatchQ[#,"id:"~~__]&)]
				]?(ObjectReferenceQ[#1] &)
			]
		];

		(* Augment the explicitly given cache with any packets in the list of objects to convert *)
		(* This ensures that we don't contact the database if a packet and its object reference both appear in the list *)
		(* This currently happens for all packets as the object references are pulled out of the packets too *)
		combinedCache = Experiment`Private`FlattenCachePackets[{cache, Cases[filteredInput, PacketP[{Object[], Model[]}, {Object, Type, ID, Name}]]}];

		(* get the names and types. This performs de facto DBQ check as name will be $Failed if object doesn't exist *)
		{objectNames, objectTypes, objectIDs} = Transpose[
			Quiet[
				Download[
					(* Replace packets in the list with object references. This ensures that we go to the database and download the name if the Name field is missing *)
					(* Otherwise we'd throw and silence a missing field error and get $Failed *)
					(* If it's an upload packet it may be missing the object key *)
					ReplaceAll[filteredInput, x: PacketP[] :> Lookup[x, Object, x]],
					{Name, Type, ID},
					Cache -> combinedCache
				],
				{Download::ObjectDoesNotExist, Download::MissingField, Download::FieldDoesntExist, Download::MissingCacheField}
			]
		];

		(* If the download packet has both an ID and a Name, the object exists *)
		objectsExistQ = MapThread[And[!FailureQ[#1], !FailureQ[#2]] &, {objectNames, objectIDs}];

		(* get the existing objects *)
		existingObjects = PickList[filteredInput, objectsExistQ];

		(* Pull out the info just for the objects that exist *)
		existingNames = PickList[objectNames, objectsExistQ];
		existingTypes = PickList[objectTypes, objectsExistQ];
		existingIDs = PickList[objectIDs, objectsExistQ];

		(* put the existing name-objects together *)
		existingNameObjects = MapThread[
			If[StringQ[#2],
				Append[#1, #2],
				Append[#1, #3]
			]&,
			{existingTypes, existingNames, existingIDs}
		];

		(* make replace rules converting the existing objects to the existing name objects *)
		objReplaceRules = MapThread[#1 -> #2&, {existingObjects, existingNameObjects}];

		(* make the nonexistent replace rules *)
		nonexistentObjects = PickList[filteredInput, objectsExistQ, False];
		nonexistentObjReferences = Map[
			Switch[#,
				PacketP[], Lookup[#, Object],
				LinkP[], First[#],
				ObjectReferenceP[], #
			]&,
			nonexistentObjects
		];
		nonexistentReplaceRules = MapThread[#1 -> #2&, {nonexistentObjects, nonexistentObjReferences}];

		If[ListQ[extractedObjects],
			Replace[extractedObjects, Join[objReplaceRules, nonexistentReplaceRules, {x:Null|$Failed :> x} ], {1}],
			Replace[extractedObjects, Join[objReplaceRules, nonexistentReplaceRules, {x:Null|$Failed :> x}], {0}]
		]
	]
];


(* ::Subsection::Closed:: *)
(*AchievableResolution*)


(* ::Subsubsection::Closed:: *)
(*AchievableResolution Options and Messages*)


DefineOptions[AchievableResolution,
	Options:>{
		{RoundingFunction->SafeRound,Round|Ceiling|Floor,"The function used to change the amount to the appropriate resolution."},
		{Messages->True,BooleanP,"Indicates if the function should print a message if any rounding occurred.",Category->Hidden}
	}
];

Error::MinimumAmount="The amount `1` is below the minimum measurable amount for any measuring device at ECL. Please request at least the minimum measurable amount (`2`) instead.";
Warning::AmountRounded="The amount `1` has been rounded to `2` as that has the maximum achievable resolution using the measuring devices available in the ECL.";


(* ::Subsubsection::Closed:: *)
(*AchievableResolution*)


(* Amount Only Overload: considers all possible devices *)
AchievableResolution[myRawAmount:(VolumeP|MassP),myOptions:OptionsPattern[]]:=AchievableResolution[myRawAmount,All,myOptions];

(* Core Function: takes amount and device(s) or All keyword *)
AchievableResolution[
	myRawAmount:(VolumeP|MassP),
	myDeviceType:(All|ListableP[TypeP[{Model[Instrument,Balance],Model[Item,Tips],Model[Container,Syringe],Model[Container,GraduatedCylinder],Model[Instrument,BottleTopDispenser]}]]),
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions,messages,possibleDeviceTuples,validDeviceTuples,minAmount,maxAmount,amountToConsider,
		scaledAmount, resolutionForAmountInTargetUnit, resolutionForAmount,amountToRound,roundedAmount, roundingFunction},

	(* default any unspecified or incorrectly-specified options; assign Messages option value *)
	safeOptions=SafeOptions[AchievableResolution, ToList[myOptions]];
	messages=Lookup[safeOptions,Messages];
	roundingFunction=Lookup[safeOptions,RoundingFunction];

	(* call TransferDevices to get the full device list; do not send Amount, because we want to be permissive to situations where amount is outside device type range *)
	possibleDeviceTuples=TransferDevices[myDeviceType,All];

	(* initially make sure we remove tuples that are in the wrong units *)
	validDeviceTuples=Select[possibleDeviceTuples,CompatibleUnitQ[myRawAmount,#[[2]]]&];

	(* get the minimum and maximum amount that are within range of this set of devices *)
	minAmount=Min[validDeviceTuples[[All,2]]];
	maxAmount=Max[validDeviceTuples[[All,3]]];

	(* determine what amount to use in order to decide which device/range/resolution tuple is the best one to use; i.e. bump to min/max if the raw amount is out of range;
	 	throw a message here to indicate that we had to bump up a min volume *)
	amountToConsider=Which[
		myRawAmount<minAmount,
			If[messages,
				Message[Error::MinimumAmount,myRawAmount,minAmount]
			];
			Return[$Failed],
		myRawAmount>maxAmount,
			maxAmount,
		True,
			myRawAmount
	];

	(* use the amount to consider to determine the tuple from which to get resolution; take the FIRST one for which the amount is in range; TransferDevices returns overlapping
	 	amount ranges, but they are in priority order *)
	resolutionForAmount=Last[SelectFirst[validDeviceTuples,MatchQ[amountToConsider,RangeP@@#[[{2,3}]]]&]];

	(* use the resolution to round the input amount; handle the fact that we are permissive to amounts greater than a max (assume repeat transfers, and want to round the raw amount in that case) *)
	amountToRound=If[myRawAmount>maxAmount,
		myRawAmount,
		amountToConsider
	];
	(* UnitScale mess with with precision of the number, but we want the final rounded number to have the scaled unit. Therefore we do the scaling and unit conversion outside, and do rounding function as the last step *)
	scaledAmount = UnitScale[amountToRound, Simplify -> False];
	resolutionForAmountInTargetUnit = UnitConvert[resolutionForAmount, Units[scaledAmount]];
	roundedAmount= roundingFunction[scaledAmount,resolutionForAmountInTargetUnit];

	(* detect if we rounded the amount and throw a message to indicate as such; do NOT throw a message if we bumped to minimum (that message already tells the tale) *)
	(* do not throw this warning in the Engine since it is effectively a warning *)
	If[
		And[
			messages,
			myRawAmount >= minAmount,
			!PossibleZeroQ[roundedAmount - myRawAmount],
			!MatchQ[$ECLApplication, Engine]
		],
		Message[Warning::AmountRounded, myRawAmount, roundedAmount]
	];

	(* return the rounded amount *)
	roundedAmount
];


(* ::Subsection:: *)
(*TransferDevices*)


(* ::Subsubsection:: *)
(*TransferDevices*)


DefineOptions[TransferDevices,
	Options:>{
		(* This isn't PipetteTypeP because we don't want to include Hamilton tips. *)
		{PipetteType->{Micropipette, Serological},All|ListableP[PipetteTypeP],"Indicates which types of tips should be returned."},
		{TipConnectionType->All,All|ListableP[TipConnectionTypeP],"Indicates the connection types for the tips that will be returned."},
		{TipMaterial->All,All|ListableP[MaterialP],"The material of the pipette tips used to aspirate and dispense the requested volume during the transfer."},
		{IncompatibleMaterials->Null,ListableP[None|MaterialP],"The incompatible materials of the sample that the transfer device cannot be made of."},
		{TipType->All,All|ListableP[TipTypeP],"Indicates which types of tips should be returned."},
		{Sterile->All,All|BooleanP,"Indicates if sterile/non-sterile transfer devices should be returned."},
		{CultureHandling->All,All|CultureHandlingP,"Indicates if specialized Mammalian/Microbial transfer devices should be returned."},
		{EngineDefault->True,All|True,"Indicates if only transfer devices with EngineDefault->True or all transfer devices should be returned."},
		{AllowMultipleTransfers -> False, True|False, "Indicates whether we allow pipette tips to conduct transfer multiple times in order to fulfill the volume requested."}
	}
];

(* need to set DeveloperObject != True here directly because if someone happens to call TransferDevices with $DeveloperSearch = True the first time in their kernel, then this will memoize to {} and fail for all subsequent uses of this function *)
cacheTransferDevicePackets[string_]:=cacheTransferDevicePackets[string]=Module[{},
	If[!MemberQ[ECL`$Memoization, LegacySLL`Private`cacheTransferDevicePackets],
		AppendTo[ECL`$Memoization, LegacySLL`Private`cacheTransferDevicePackets]
	];
	Flatten@Download[
		Search[{{Model[Item, Tips]}, {Model[Instrument, Balance]}, {Model[Container, Syringe]}, {Model[Container, GraduatedCylinder]}}, Deprecated != True && DeveloperObject != True],
		{
			{Packet[Object, Material, PipetteType, TipConnectionType, MinVolume, MaxVolume, Resolution, Sterile, WideBore, Filtered, GelLoading, Aspirator, EngineDefault]},
			{Packet[MinWeight, MaxWeight, Resolution, Sterile, EngineDefault]},
			{Packet[MinVolume, MaxVolume, Resolution, ContainerMaterials, ConnectionType, Sterile, EngineDefault]},
			{Packet[MinVolume, MaxVolume, Resolution, ContainerMaterials, Sterile, EngineDefault]}
		}
	]];
transferDevicesFastCache[string_]:=transferDevicesFastCache[string]=Module[{},
	If[!MemberQ[ECL`$Memoization,LegacySLL`Private`transferDevicesFastCache],
		AppendTo[ECL`$Memoization,LegacySLL`Private`transferDevicesFastCache]
	];
		Experiment`Private`makeFastAssocFromCache[cacheTransferDevicePackets["Memoization"]]
];

TransferDevices[myAllowedTypes:(ListableP[TypeP[]]|All),myAmount:(MassP|VolumeP|All),ops:OptionsPattern[TransferDevices]]:=Module[
	{
		safeOps,transferDevicePackets,rawTransferDeviceFastCache,transferDeviceFastCache,
		pipetteType,tipConnectionType,tipMaterial,incompatibleMaterials,tipType,sterile,cultureHandling,engineDefault,
		volumePackets,massPackets,volumeAndMassPackets,amountFilteredPackets,
		tipFilterTipSortingFunction,tipSortingFunction,sterileSortingFunction, pipetteTypeSortingFunction, allowMultipleTransfers,
		extraAmountFilteredPacketsNeedingMultipleTransfers, singleTransferResults, multiTransferResults
	},

	safeOps=SafeOptions[TransferDevices,ToList[ops]];

	(* Download our transfer device packets. *)
	transferDevicePackets=cacheTransferDevicePackets["Memoization"];
	rawTransferDeviceFastCache=transferDevicesFastCache["Memoization"];

	(* Determine what kind of tips user wants *)
	pipetteType=Lookup[safeOps,PipetteType];
	tipConnectionType=Lookup[safeOps,TipConnectionType];
	tipMaterial=Lookup[safeOps,TipMaterial];
	incompatibleMaterials=Lookup[safeOps,IncompatibleMaterials];
	tipType=Lookup[safeOps,TipType];
	sterile=Lookup[safeOps,Sterile];
	cultureHandling=Lookup[safeOps,CultureHandling];
	engineDefault=Lookup[safeOps,EngineDefault];
	allowMultipleTransfers = Lookup[safeOps, AllowMultipleTransfers];

	transferDeviceFastCache=If[MatchQ[engineDefault,True],
		Select[rawTransferDeviceFastCache,(MatchQ[#,KeyValuePattern[EngineDefault->True]]&)],
		rawTransferDeviceFastCache
	];

	(* Were we asked for a volume? *)
	volumePackets=If[MatchQ[myAmount, VolumeP|All],
		Module[{filteredTips,filteredSyringes,filteredGraduatedCylinders},
			(* Filter all of our tips. *)
			filteredTips=If[MemberQ[ToList[myAllowedTypes], Model[Item, Tips]] || MatchQ[myAllowedTypes, All],
				Module[
					{allTips,pipetteTypeFilteredTips,connectionTypeFilteredTips,tipMaterialFilteredTips,incompatibleMaterialsFilteredTypes,
						sterileFilteredTips},

					allTips = Values[KeySelect[transferDeviceFastCache, MatchQ[ObjectReferenceP[Model[Item, Tips]]]]];

					pipetteTypeFilteredTips=If[MatchQ[pipetteType, Except[All]],
						Cases[allTips, KeyValuePattern[PipetteType->Alternatives@@ToList[pipetteType]]],
						Cases[allTips, KeyValuePattern[PipetteType->Except[Null]]]
					];

					connectionTypeFilteredTips=If[MatchQ[tipConnectionType, Except[All]],
						Cases[pipetteTypeFilteredTips, KeyValuePattern[TipConnectionType->Alternatives@@ToList[tipConnectionType]]],
						pipetteTypeFilteredTips
					];

					tipMaterialFilteredTips=If[MatchQ[tipMaterial, Except[All]],
						Cases[connectionTypeFilteredTips, KeyValuePattern[Material->Alternatives@@ToList[tipMaterial]]],
						connectionTypeFilteredTips
					];

					incompatibleMaterialsFilteredTypes=If[MatchQ[incompatibleMaterials, Except[Null]],
						Cases[tipMaterialFilteredTips, KeyValuePattern[Material->Except[Alternatives@@ToList[incompatibleMaterials]]]],
						tipMaterialFilteredTips
					];

					sterileFilteredTips=If[MatchQ[sterile, Except[All]],
						Cases[incompatibleMaterialsFilteredTypes, KeyValuePattern[Sterile->sterile]],
						incompatibleMaterialsFilteredTypes
					];

					Which[
						(*If tipType option is normal, get tips with all other TipTypeP goes to False or Null*)
						MatchQ[tipType, Normal],
						Cases[sterileFilteredTips,KeyValuePattern[{WideBore->Null|False,Filtered->Null|False,GelLoading->Null|False,Aspirator->Null|False}]],
						(*If tipType is a TipTypeP other than Normal, map over the tip types to refine*)
						MatchQ[tipType, Except[All]],
						Cases[sterileFilteredTips, KeyValuePattern[(tipType/.Barrier->Filtered) -> True]],
						(*If tipType option is All, all tips qualify*)
						True,sterileFilteredTips
					]
				],
				{}
			];

			(* Filter our syringes *)
			filteredSyringes=If[MemberQ[ToList[myAllowedTypes], Model[Container,Syringe]] || MatchQ[myAllowedTypes, All],
				Module[{allSyringes,materialFilteredSyringes,connectionTypeFilteredSyringes},
					allSyringes=Values[KeySelect[transferDeviceFastCache, MatchQ[ObjectReferenceP[Model[Container,Syringe]]]]];

					materialFilteredSyringes=If[MatchQ[incompatibleMaterials, Except[Null]],
						Cases[allSyringes, KeyValuePattern[ContainerMaterials->_?(!MemberQ[#, Alternatives@@ToList[incompatibleMaterials]]&)]],
						allSyringes
					];

					connectionTypeFilteredSyringes=Cases[
						materialFilteredSyringes,
						KeyValuePattern[ConnectionType->LuerLock|SlipLuer]
					];

					If[MatchQ[sterile, Except[All]],
						Cases[connectionTypeFilteredSyringes, KeyValuePattern[Sterile->sterile]],
						connectionTypeFilteredSyringes
					]
				],
				{}
			];

			(* Filter our graduated cylinders. *)
			filteredGraduatedCylinders=If[MemberQ[ToList[myAllowedTypes], Model[Container,GraduatedCylinder]] || MatchQ[myAllowedTypes, All],
				Module[{allGraduatedCylinders,materialFilteredGraduatedCylinders, sterileFilteredGraduatedCylinders, polyPropyleneVolumes},
					allGraduatedCylinders=Values[KeySelect[transferDeviceFastCache, MatchQ[ObjectReferenceP[Model[Container,GraduatedCylinder]]]]];

					(* filter for material compatibility *)
					materialFilteredGraduatedCylinders=If[MatchQ[incompatibleMaterials, Except[Null]],
						Cases[allGraduatedCylinders, KeyValuePattern[ContainerMaterials->_?(!MemberQ[#, Alternatives@@ToList[incompatibleMaterials]]&)]],
						allGraduatedCylinders
					];

					(* filter if we need it to be sterile *)
					sterileFilteredGraduatedCylinders = If[MatchQ[sterile, Except[All]],
						Cases[materialFilteredGraduatedCylinders, KeyValuePattern[Sterile->sterile]],
						materialFilteredGraduatedCylinders
					];

					(* pull out all the volumes for our non glass gcs *)
					polyPropyleneVolumes = Lookup[
						Cases[sterileFilteredGraduatedCylinders, KeyValuePattern[ContainerMaterials -> Except[{Glass}]]],
						MaxVolume,
						{}
					];

					(* in cases where a gc of equal volume is returned, remove the glass one *)
					DeleteCases[sterileFilteredGraduatedCylinders, KeyValuePattern[{ContainerMaterials -> {Glass}, MaxVolume -> Alternatives@@polyPropyleneVolumes}]]
				],
				{}
			];

			(* Join our packets before filtering based on the amounts. *)
			Flatten[{filteredTips,filteredSyringes,filteredGraduatedCylinders}]
		],
		{}
	];

	(* Were we asked for a mass? *)
	massPackets=If[(MemberQ[ToList[myAllowedTypes], Model[Instrument,Balance]] || MatchQ[myAllowedTypes, All]) && MatchQ[myAmount, MassP|All],
		Values[KeySelect[transferDeviceFastCache, MatchQ[ObjectReferenceP[Model[Instrument,Balance]]]]],
		{}
	];

	(* Join our volume and mass packets. *)
	volumeAndMassPackets=Flatten[{volumePackets,massPackets}];

	(* Filter by amount if requested *)
	amountFilteredPackets=Switch[myAmount,
		All,
			(
				(* Need to delete the cases where all the values are Nulls because if some bad husk object gets created it can mess this stuff up *)
				Which[
					KeyExistsQ[#, MinWeight] && MatchQ[#, KeyValuePattern[{MinWeight -> Null, MaxWeight -> Null, Resolution -> Null}]], Nothing,
					KeyExistsQ[#, MinWeight], Lookup[#, {Object, MinWeight, MaxWeight, Resolution}],
					KeyExistsQ[#, MinVolume] && MatchQ[#, KeyValuePattern[{MinVolume -> Null, MaxVolume -> Null, Resolution -> Null}]], Nothing,
					KeyExistsQ[#, MinVolume], Lookup[#, {Object, MinVolume, MaxVolume, Resolution}]
				]
			&)/@volumeAndMassPackets,
		VolumeP,
			With[{
				extractedInfo=If[Length[volumeAndMassPackets]>0,
					{#[[1]],Unitless[UnitConvert[#[[2]],"Microliters"]],Unitless[UnitConvert[#[[3]],"Microliters"]],#[[4]]}&/@Lookup[volumeAndMassPackets,{Object,MinVolume,MaxVolume,Resolution}],
					{}
				],
				pat1=LessEqualP[Unitless[UnitConvert[myAmount,"Microliters"]]],
				pat2=GreaterEqualP[Unitless[UnitConvert[myAmount,"Microliters"]]]
			},
				{
					#[[1]],
					#[[2]] Microliter,
					#[[3]] Microliter,
					#[[4]]
				}&/@Select[extractedInfo,And[MatchQ[#[[2]],pat1],MatchQ[#[[3]],pat2]]&]
			],
		MassP,
			(
				Lookup[#, {Object, MinWeight, MaxWeight, Resolution}]
			&)/@Cases[volumeAndMassPackets,KeyValuePattern[{MinWeight->LessEqualP[myAmount], MaxWeight->GreaterEqualP[myAmount]}]]
	];

	(* construct a secondary list of packets, which the MaxVolume of tips are lower than what we request *)
	extraAmountFilteredPacketsNeedingMultipleTransfers = If[MatchQ[myAmount, VolumeP] && allowMultipleTransfers,
		With[{
			extractedInfo=If[Length[volumeAndMassPackets]>0,
				{#[[1]],Unitless[UnitConvert[#[[2]],"Microliters"]],Unitless[UnitConvert[#[[3]],"Microliters"]],#[[4]]}&/@Lookup[volumeAndMassPackets,{Object,MinVolume,MaxVolume,Resolution}],
				{}
			],
			pat1=LessEqualP[Unitless[UnitConvert[myAmount,"Microliters"]]],
			pat2=LessP[Unitless[UnitConvert[myAmount,"Microliters"]]]
		},
			{
				#[[1]],
				#[[2]] Microliter,
				#[[3]] Microliter,
				#[[4]]
			}&/@Select[extractedInfo,And[MatchQ[#[[2]],pat1],MatchQ[#[[3]],pat2]]&]
		],
		{}
	];

	(* Sort by Resolution, then sort by TipType (we want Normal tips over other types). *)
	tipSortingFunction[myInput_List]:=If[
		MatchQ[myInput[[1]], ObjectP[Model[Item, Tips]]],
		FirstPosition[
			{Normal, Barrier, WideBore,{Barrier,WideBore},GelLoading},
			(If[MatchQ[
				Lookup[Experiment`Private`fetchPacketFromFastAssoc[myInput[[1]], transferDeviceFastCache],#],
				True],
				#,
				Nothing]&/@{Filtered,WideBore,GelLoading,Aspirator})/.{Filtered->Barrier,{x_}:>x,{}->Normal},
			{1}
		]
	];

	sterileSortingFunction[myInput_List]:=FirstPosition[
		{False, True},
		Lookup[Experiment`Private`fetchPacketFromFastAssoc[myInput[[1]], transferDeviceFastCache], Sterile, Null]/.{Null->False},
		{1}
	];

	pipetteTypeSortingFunction[myInput_List]:=If[MatchQ[myInput[[1]], ObjectP[Model[Item, Tips]]],
		FirstPosition[
			{Alternatives[Hamilton, Micropipette, Serological], PositiveDisplacement},
			Lookup[Experiment`Private`fetchPacketFromFastAssoc[myInput[[1]], transferDeviceFastCache], PipetteType],
			{1}
		],
		(* this is so we can keep tips as our first entry in the resulting table *)
		{2,4}
	];

	(* non-filtered tips to be used first *)
	tipFilterTipSortingFunction[myInput_List]:=If[MatchQ[myInput[[1]], ObjectP[Model[Item, Tips]]],
		FirstPosition[
			{False, True},
			Lookup[Experiment`Private`fetchPacketFromFastAssoc[myInput[[1]], transferDeviceFastCache], Filtered],
			{1}
		]
	];

	(* Sort by PipetteType(we want positive displacement last), Resolution (low to high), MaxVolume (low to high), Sterile (non-sterile, then sterile) TipType (we want Normal tips over other types). *)
	singleTransferResults = SortBy[amountFilteredPackets, {
		pipetteTypeSortingFunction,
		Last,
		tipFilterTipSortingFunction,
		(#[[3]]&),
		sterileSortingFunction,
		tipSortingFunction
	}];

	(* Sort by similar logic but except prioritize MaxVolume *)
	multiTransferResults = SortBy[extraAmountFilteredPacketsNeedingMultipleTransfers, {
		(-1*#[[3]]&),
		pipetteTypeSortingFunction,
		Last,
		tipFilterTipSortingFunction,
		sterileSortingFunction,
		tipSortingFunction
	}];

	Join[singleTransferResults, multiTransferResults]
];


(* ::Subsubsection::Closed:: *)
(*SampleVolumeRangeQ*)


SampleVolumeRangeQ[volume:VolumeP]:=Module[{minVolume,devicesToMeasure,containersToHold},
	minVolume=Min[Cases[TransferDevices[All, All][[All, 2]], VolumeP]];

	If[volume<minVolume,
		False,
		Module[{},
			devicesToMeasure=TransferDevices[All,volume];
			containersToHold=Quiet[PreferredContainer[volume,Type->Vessel],PreferredContainer::ContainerNotFound];

			(* If there's no device that can measure the volume and no container that can hold it, it's not reasonable *)
			(* Consider containers, since we can make repeated measurements with the same device to achieve volumes larger than the max *)
			!(MatchQ[devicesToMeasure,{}]&&MatchQ[containersToHold,$Failed])
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*SampleVolumeRangeP*)


SampleVolumeRangeP::usage="Matches a volume which can be measured and stored in the lab.";
SampleVolumeRangeP:=_?SampleVolumeRangeQ;



(* ::Subsection::Closed:: *)
(*optionsToTable*)


(* ::Subsubsection::Closed:: *)
(*optionsToTable*)


(*
	Converts a list of options to a table with the category, name, value, and description of the options.
	Input:
		myOptionsList - the options to display
		myFunction - the name of the function these are options for
	Output:
		a table with the options (name, value, description) arranged by category
*)

optionsToTable[$Failed,_Symbol]:=$Failed;
optionsToTable[myOptionsList:{},myFunction_Symbol]:={};
optionsToTable[myOptionsList:{_Rule..},myFunction_Symbol]:=Module[{optionDefinition,keys,values,descriptions,categories,allInfo,groupedInfo,gridList,nonameValues},

(* Get the option definition of the function *)
	optionDefinition = OptionDefinition[myFunction];

	(* Get the keys of the given options *)
	keys = Keys[myOptionsList];

	(* Get the values of the given options *)
	nonameValues = Values[myOptionsList];

	(* Convert object refs with IDs to named objects when possible *)
	values = NamedObject[nonameValues];

	(* For each key, pull out the corresponding description from the option definition *)
	(* note that if the option can't be found, we'll just do "" as a placeholder *)
	descriptions = Lookup[FirstCase[optionDefinition, KeyValuePattern["OptionName" -> ToString[#]], <||>], "Description", ""] & /@ keys;

	(* For each key, pull out the corresponding category from the option definition *)
	(* note that if the option can't be found, we'll just do "Hidden" as a placeholder because those will get removed later *)
	categories = Lookup[FirstCase[optionDefinition, KeyValuePattern["OptionName" -> ToString[#]], <||>], "Category", "Hidden"] & /@ keys;

	(* Pool all of the info for each defined option into a list *)
	allInfo = Transpose[{keys, values, descriptions, categories}];

	(* Group the option info by category *)
	groupedInfo = GatherBy[allInfo, #[[4]] &];

	(* Assemble the info into a formatted grid *)
	gridList=Map[
		Function[categoryGroup,
		(* For each category group, format the category cell and make the option cells. If the category is hidden, do nothing *)
			If[MatchQ[categoryGroup[[1]][[-1]], "Hidden"],
				Nothing,
				{
				(* Make the category cell *)
					{
						{
							Item[
								Style[categoryGroup[[1]][[-1]], Bold, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]],
								Alignment -> Left,
								Frame -> True,
								FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1],
								ItemSize -> {Full, 2}, Background -> RGBColor["#E2E4E6"]],
							SpanFromLeft
						}
					},
					MapIndexed[
						{
						(* Make the item for the option name *)
							Item[
								Tooltip[
									Button[
										Style[#1[[1]], FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]],
										CopyToClipboard[#1[[1]]],
										Appearance -> None, Method -> "Queued"
									],
									"Copy value clipboard"
								],
								Alignment -> {Left, Center},
								ItemSize -> {Full, .5},
							(* The frame is determined by whether this is the first, last, or neither entry in the category *)
								Frame -> Which[
								(* If this is the first entry in this category section and there is only one entry in this section, {bottom is gray solid, left is gray solid, top is gray solid, right has none}*)
									MatchQ[First[#2], 1] && MatchQ[First[#2], Length[categoryGroup]],
									{
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										None
									},

								(* If this is the first entry in this category section and there is more than one entry in this section, {bottom is blue dashed, left is gray solid, top is gray solid, right has none} *)
									MatchQ[First[#2], 1],
									{
										Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										None
									},

								(* If this is the last entry in this category section,{bottom is gray solid, left is gray solid, top is blue dashed, right has none}*)
									MatchQ[First[#2], Length[categoryGroup]],
									{
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
										None
									},

								(* Otherwise, {bottom is blue dashed, left is gray solid, top is blue dashed, right has none}*)
									True,
									{
										Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
										None
									}
								]
							],

						(* Make the item for the option value *)
							Item[
								Tooltip[
									Button[
										Style[#1[[2]], FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]],
										CopyToClipboard[#1[[2]]],
										Appearance -> None, Method -> "Queued"
									],
									"Copy value clipboard"
								],
								Alignment -> {Left, Center},
								ItemSize -> {30, .5}, Frame -> Which[

							(* If this is the first entry in this category section and there is only one entry in this section, {bottom is gray solid, left is gray solid, top is gray solid, right has none}*)
								MatchQ[First[#2], 1] && MatchQ[First[#2], Length[categoryGroup]],
								{
									Directive[RGBColor["#8E8E8E"], Thickness@1],
									None,
									Directive[RGBColor["#8E8E8E"], Thickness@1],
									None
								},

							(* If this is the first entry in this category section and there is more than one entry in this section, {bottom is blue dashed, left is gray solid, top is gray solid, right has none} *)
								MatchQ[First[#2], 1],
								{
									Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
									None,
									Directive[RGBColor["#8E8E8E"], Thickness@1],
									None
								},

							(* If this is the last entry in this category section, {bottom is gray solid, left is gray solid, top is blue dashed, right has none}*)
								MatchQ[First[#2], Length[categoryGroup]],
								{
									Directive[RGBColor["#8E8E8E"], Thickness@1],
									None,
									Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
									None
								},

							(* Otherwise, {bottom is blue dashed, left is gray solid, top is blue dashed, right has none}*)
								True,
								{
									Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
									None,
									Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
									None
								}
							]
							],

						(* Make the item for the option description *)
							Item[
								Style[#1[[3]], FontFamily -> "Helvetica", FontSize -> 11,
									RGBColor["#4A4A4A"]],

								Alignment -> {Left, Center}, ItemSize -> {50, .5},
								Frame -> Which[

								(* If this is the first entry in this category section and there is only one entry in this section, {bottom is gray solid, left is none, top is gray solid, right is gray solid}*)
									MatchQ[First[#2], 1] && MatchQ[First[#2], Length[categoryGroup]],
									{
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										None,
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										Directive[RGBColor["#8E8E8E"], Thickness@1]
									},

								(* If this is the first entry in this category section and there is more than one entry in this section,{bottom is blue dashed, left is none, top is gray solid, right is gray solid} *)
									MatchQ[First[#2], 1],
									{
										Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
										None,
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										Directive[RGBColor["#8E8E8E"], Thickness@1]
									},

								(* If this is the last entry in this category section, {bottom is gray solid, left is none, top is blue dashed, right is  gray solid}*)
									MatchQ[First[#2], Length[categoryGroup]],
									{
										Directive[RGBColor["#8E8E8E"], Thickness@1],
										None,
										Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
										Directive[RGBColor["#8E8E8E"], Thickness@1]
									},

								(* Otherwise, {bottom is blue dashed, left is none, top is blue dashed, right is gray solid }*)True,
									{
										Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
										None,
										Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]],
										Directive[RGBColor["#8E8E8E"], Thickness@1]
									}
								]
							]
						} &, categoryGroup]
				}
			]
		], groupedInfo];

	(* Output the table (unless there is nothing to show, then just return an empty list) *)
	If[MatchQ[gridList,{}],
		{},
		Grid[Flatten[gridList, 2], Frame -> Directive[RGBColor["#8E8E8E"], Thickness@1]]
	]
];


(* ::Subsection::Closed:: *)
(*Bond syntax error fix*)

(* The below code prevents mathematica from registering a syntax error for the Bond function*)
Unprotect[Bond];
SyntaxInformation[Bond] = {"ArgumentsPattern" -> {__, __}};
