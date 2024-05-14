(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


Authors[pooledContainerToSampleOptions]:={"hanming.yang", "thomas"};
Authors[resolvePooledAliquotOptions]:={"thomas", "lige.tonggu"};
Authors[resolvePooledSamplePrepOptions]:={"thomas", "lige.tonggu"};
Authors[simulateSamplePreparation]:={"thomas", "lige.tonggu"};
Authors[simulateSamplePreparationPackets]:={"thomas", "lige.tonggu"};
Authors[populateWorkingSamples]:={"hanming.yang", "thomas"};
Authors[populatePreparedSamples]:={"hanming.yang", "thomas"};
Authors[populatePreparedSamplesPooled]:={"hanming.yang"};

(* ::Subsection::Closed:: *)
(*SamplePreparationCacheFields*)


DefineOptions[
	SamplePreparationCacheFields,
	Options:>{
		{Format->List,List|Packet|Sequence,"Indicates what format the fields should be returned in."}
	}
];

Authors[SamplePreparationCacheFields] := {"kelmen.low", "dima", "charlene.konkankit", "thomas"};

SamplePreparationCacheFields[type_,ops:OptionsPattern[]]:=Module[{fields, safeOptions},
	(* Get our options. *)
	safeOptions=SafeOptions[SamplePreparationCacheFields,ToList[ops]];

	(* Get the list of fields from our switch statement. *)
	fields = Switch[type,
		Object[Sample],
			{
				Object, Type, Name, State, BiosafetyLevel, CellType, CultureAdhesion, SampleHandling, Composition,
				Analytes, Solvent, MassConcentration, Concentration, Volume, Mass, Count, Status, Model, Position,
				Container, Sterile, StorageCondition, ThawTime, ThawTemperature, MaxThawTime, ThawMixType,
				ThawMixRate, ThawMixTime, ThawNumberOfMixes, TransportWarmed, TransportChilled, Tablet, TabletWeight,
				LiquidHandlerIncompatible, Site, RequestedResources, Conductivity, IncompatibleMaterials, pH, KitComponents,
				BiosafetyHandling, Density, Fuming, InertHandling, ParticleWeight, PipettingMethod, Pyrophoric,
				ReversePipetting, RNaseFree, TransferTemperature, TransportCondition, Ventilated, Well, SurfaceTension,
				AluminumFoil, Parafilm, Anhydrous
			},
		Model[Sample],
			{
				Conductivity, IncompatibleMaterials, pH, KitComponents, RequestedResources, Products, KitProducts, MixedBatchProducts,
				MaxThawTime, Solvent, SampleHandling, CellType, CultureAdhesion, BiosafetyLevel, Composition, Analytes, TransportWarmed,
				TransportChilled, Name, Deprecated, Sterile, LiquidHandlerIncompatible, Tablet, TabletWeight, State, MolecularWeight, ThawTime,
				ThawTemperature, Dimensions, ExtinctionCoefficients, UsedAsSolvent, BiosafetyHandling, Density, Fuming, InertHandling,
				ParticleWeight, PipettingMethod, Pyrophoric, ReversePipetting, RNaseFree, TransferTemperature, TransportCondition, Ventilated, SurfaceTension,
				Parafilm, AluminumFoil
			},
		Object[Container],
			{
				Type, Object, Name, Status, Model, Container, Contents, Container, Sterile, TareWeight, StorageCondition, RequestedResources, KitComponents, Site,
				Ampoule, Hermetic, MaxTemperature, MaxVolume, MinTemperature, Opaque, RNaseFree, Squeezable, InertHandling,
				ParticleWeight, PipettingMethod, Pyrophoric, ReversePipetting, TransferTemperature, TransportCondition, Ventilated,
				PreviousCover, Cover, Septum, KeepCovered, AluminumFoil,Parafilm
			},
		Model[Container],
			{
				Name,Deprecated,DefaultStorageCondition,Sterile,AspectRatio,NumberOfWells,Footprint,Aperture,InternalDepth,
				SelfStanding,OpenContainer,MinVolume,MaxVolume,Dimensions,InternalDimensions,InternalDiameter,MaxTemperature,
				MinTemperature,Positions,FilterType, MembraneMaterial, MolecularWeightCutoff, PoreSize, PrefilterMembraneMaterial,
				PrefilterPoreSize, MaxCentrifugationForce, AvailableLayouts, WellDimensions,WellDiameter,WellDepth,WellColor,
				LiquidHandlerAdapter,WellPositionDimensions,WellDiameters,WellDepths,ContainerMaterials,WellBottom,NozzleHeight,
				NozzleOffset,SkirtHeight, RecommendedFillVolume,Immobile,RentByDefault,CoverFootprints,
				AluminumFoil, Ampoule, BuiltInCover, CoverTypes, Counterweights, EngineDefault, Hermetic, Opaque, Parafilm,
				RequestedResources, Reusability, RNaseFree, Squeezable, StorageBuffer, StorageBufferVolume,
				TareWeight, VolumeCalibrations, Columns,HorizontalPitch,LiquidHandlerPrefix, MultiProbeHeadIncompatible, VerticalPitch, MaxPressure,
				DestinationContainerModel,RetentateCollectionContainerModel,ConnectionType, KitProducts, Products, MixedBatchProducts
			},
		Object[User],
			{FirstName, LastName, Email, TeamEmailPreference, NotebookEmailPreferences, Name},
		(* No other types are downloaded in the sample preparation resolvers. *)
		_,
			{}
	];

	(* Format our output differently depending on the Format option. *)
	Switch[Lookup[safeOptions,Format],
		List,
			fields,
		Packet,
			Packet@@fields,
		Sequence,
			Sequence@@fields,
		_,
			fields
	]
];

FlattenCachePackets[cachePackets_]:=Module[{flattenedCachePackets,filteredCachePackets},
	(* Flatten our cache packets into a list. *)
	flattenedCachePackets=Flatten[{cachePackets}];

	(* Get all of the packets out of our flat list (get rid of $Failed or other rubbish). *)
	filteredCachePackets=Cases[flattenedCachePackets,PacketP[]];

	(* Merge all packets by the Object key. If there are multiple of the same key, take the one from the first packet that shows up. *)
	(* cannot use Merge here because Merge evaluates :> which will cause Computable fields to get evaluated when they should not be *)
	(* If we have Merge[{<|a -> 1, b :> 2|>, <|a -> 3, b -> 4|>}, First], it will return <|a -> 1, b -> 2|>.  It _should_ return <|a -> 1, b :> 2|>.  If you have a mixed bag of things where the same key is both -> and :> then you can run into this problem *)
	(* if we do Join[Reverse[{<|a -> 1, b :> 2|>, <|a -> 3, b -> 4|>}]] it will properly return <|a -> 1, b :> 2|> *)
	Map[
		Function[{packetsToMerge},
			Join @@ Reverse[packetsToMerge]
		],
		GatherBy[filteredCachePackets, Lookup[#, Object]&]
	]
];

(* ::Subsection::Closed:: *)
(*nonComputableFields*)
(* returns a Packet with _all_ fields of a type except for Computable fields *)

Authors[noComputableFieldsPacket]:={"dima"};

noComputableFieldsPacket[type:TypeP[]]:=noComputableFieldsPacket[type]=Block[
	{},
	(* Memoize this function *)
	If[!MemberQ[$Memoization, Experiment`Private`noComputableFieldsPacket],
		AppendTo[$Memoization, Experiment`Private`noComputableFieldsPacket]
	];
	Packet@@noComputableFieldsList[type]
];

noComputableFieldsList[type:TypeP[]]:=noComputableFieldsList[type]=Block[
	{
		definition=LookupTypeDefinition[type],
		fields, shortFields, nonComputableTuples
	},
	(* Memoize this function *)
	If[!MemberQ[$Memoization, Experiment`Private`noComputableFieldsList],
		AppendTo[$Memoization, Experiment`Private`noComputableFieldsList]
	];

	fields=Lookup[definition, Fields];
	shortFields=Map[
		{#[[1]], Lookup[#[[2]], Format]}&,
		fields
	];
	nonComputableTuples=DeleteCases[shortFields, {_, Computable}];
	nonComputableTuples[[All, 1]]
];

safeFieldsForCachePacket[type:TypeP[]]:=safeFieldsForCachePacket[type]=Module[{fields,finalFieldList},
	(* Memoize this function *)
	If[!MemberQ[$Memoization, Experiment`Private`safeFieldsForCachePacket],
		AppendTo[$Memoization, Experiment`Private`safeFieldsForCachePacket]
	];

	(* get all non-computable fields of this type *)
	fields=noComputableFieldsList[type];

	(* for some types, we want to remove large fields like Objects/Samples *)
	finalFieldList=Switch[type,
		(* we don't need the Objects field that could be giant *)
		TypeP[{Model[Container],Model[Instrument],Model[Item],Object[LaboratoryNotebook],Model[Maintenance],Model[Package],Model[Part],Model[Qualification],Model[Sample],Model[Sensor],Model[User]}],
		DeleteCases[fields,Objects],

		(* Smaples field for Products is not relevant but can be *)
		TypeP[Object[Product]],
		DeleteCases[fields,Samples],

		_,
		fields
	];

	(* return as a Packet *)
	Packet@@finalFieldList
];


(* ::Subsection::Closed:: *)
(* removes temporal links from inputs and options *)

Warning::InputContainsTemporalLinks="The following input(s), `1`, were detected to be links. The most recent information about these inputs will be downloaded in order to generate an protocol and the temporal date provided will be ignored.";

(* find the link references in the input and replace them with Object Representation (with the links stripped) *)
removeLinks[myInput_, myOptions_] := Module[
	{myOptionsWithoutCacheAndSimulation, optionLinks, optionLinkObjects, inputLinks, inputLinkObjects},
	(* Do not attempt to sanitize the links in the Cache or Simulation options. *)
	myOptionsWithoutCacheAndSimulation=Normal@KeyDrop[
		Association[myOptions],
		{Simulation, Cache}
	];

	(* get the link objects for the options *)
	optionLinks = DeleteDuplicates[Cases[myOptionsWithoutCacheAndSimulation, LinkP[IncludeTemporalLinks -> True], Infinity]];
	optionLinkObjects = Download[optionLinks, Object];

	(* get the links for the inputs *)
	(* importantly, we are flattening and not going down to Infinity because we don't want to remove links from input packets *)
	inputLinks = DeleteDuplicates[Cases[Flatten[myInput], LinkP[IncludeTemporalLinks -> True]]];
	inputLinkObjects = Download[inputLinks, Object];

	(* Does this list include temporal links? *)
	If[!MatchQ[$ECLApplication, Engine] && Length[Cases[Join[optionLinks, inputLinks], TemporalLinkP[]]]>0,
		Message[Warning::InputContainsTemporalLinks, ObjectToString[DeleteDuplicates[Cases[Join[optionLinks, inputLinks], TemporalLinkP[]]]]];
	];

	(* Does this list include links at all? *)
	{
		If[Length[inputLinks] > 0,
			myInput /. MapThread[(#1 -> #2)&, {inputLinks, inputLinkObjects}],
			myInput
		],
		If[Length[optionLinks] > 0,
			myOptions /. MapThread[(#1 -> #2)&, {optionLinks, optionLinkObjects}],
			myOptions
		]
	}
];


(* ::Subsection::Closed:: *)
(* replaces objects referenced by name to IDs *)
sanitizeInputs[myInput_List]:=First@sanitizeInputs[myInput, {}];
sanitizeInputs[myInput_List, myOptions:Alternatives[_List,$Failed]]:= Module[
	{
		myOptionsWithoutCacheAndSimulation, allObjects, allObjectIDs, allObjectIDsChecked, sampleToIDMap
	},

	(* Do not attempt to sanitize the links in the Cache or Simulation options. *)
	myOptionsWithoutCacheAndSimulation=If[MatchQ[myOptions, _List],
		Normal@KeyDrop[
			Association[myOptions],
			{Simulation, Cache}
		],
		$Failed
	];

	(*get all objects/models. I don't need to worry about links since they don't have Names and the objects inside will be replaced with IDs regardless*)
	allObjects = Cases[{myInput, myOptionsWithoutCacheAndSimulation}, ObjectReferenceP[], Infinity];
	allObjectIDs = Quiet[Download[allObjects, Object],{Download::ObjectDoesNotExist}];

	(* if Object does not exist in the DB, return it in the same way as it was entered *)
	allObjectIDsChecked = MapThread[
		If[MatchQ[#1, $Failed],#2,#1]&,
		{allObjectIDs, allObjects}];

	(* change Sample to more general terms *)
	sampleToIDMap = Module[{objectsModels, bool, namedSamples, namedSamplesIDs},
		objectsModels = allObjects;
		bool = Map[
			MatchQ[(
				Model[Repeated[_Symbol, {0, 5}], ___Symbol, _?(StringMatchQ[#, "id:" ~~ __]&)] |
					Object[Repeated[_Symbol, {0, 5}], ___Symbol, _?(StringMatchQ[#, "id:" ~~ __]&)]
			)], objectsModels];
		namedSamples  = PickList[objectsModels, bool, False];
		namedSamplesIDs = PickList[Flatten[allObjectIDsChecked],bool, False];
		MapThread[Rule[#1,#2]&,{namedSamples, namedSamplesIDs}]
	];

	{myInput, myOptions}/.sampleToIDMap
];

(* overload to work on 3 inputs - most of the experiment functions will be calling this one *)
sanitizeInputs[myInput_List, mySafeOptions:Alternatives[_List,$Failed], myOptionsWithPreparedSamples_List]:= Module[
	{
		mySafeOptionsWithoutCacheAndSimulation, myOptionsWithoutCacheAndSimulation, allObjects, allObjectIDs, allObjectIDsChecked, sampleToIDMap
	},

	(* Do not attempt to sanitize the links in the Cache or Simulation options. *)
	mySafeOptionsWithoutCacheAndSimulation=If[MatchQ[mySafeOptions, _List],
		Normal@KeyDrop[
			Association[mySafeOptions],
			{Simulation, Cache}
		],
		$Failed
	];

	myOptionsWithoutCacheAndSimulation=If[MatchQ[myOptionsWithPreparedSamples, _List],
		Normal@KeyDrop[
			Association[myOptionsWithPreparedSamples],
			{Simulation, Cache}
		],
		$Failed
	];

	(*get all objects/models. I don't need to worry about links since they don't have Names and the objects inside will be replaced with IDs regardless*)
	allObjects = Cases[{myInput, mySafeOptionsWithoutCacheAndSimulation, myOptionsWithoutCacheAndSimulation}, ObjectReferenceP[], Infinity];
	allObjectIDs = Quiet[Download[allObjects, Object],{Download::ObjectDoesNotExist}];

	(* if Object does not exist in the DB, return it in the same way as it was entered *)
	allObjectIDsChecked = MapThread[
		If[MatchQ[#1, $Failed],#2,#1]&,
		{allObjectIDs, allObjects}];

	(* change Sample to more general terms *)
	sampleToIDMap = Module[{objectsModels, bool, namedSamples, namedSamplesIDs},
		objectsModels = allObjects;
		bool = Map[
			MatchQ[(
				Model[Repeated[_Symbol, {0, 5}], ___Symbol, _?(StringMatchQ[#, "id:" ~~ __]&)] |
						Object[Repeated[_Symbol, {0, 5}], ___Symbol, _?(StringMatchQ[#, "id:" ~~ __]&)]
			)], objectsModels];
		namedSamples  = PickList[objectsModels, bool, False];
		namedSamplesIDs = PickList[Flatten[allObjectIDsChecked],bool, False];
		MapThread[Rule[#1,#2]&,{namedSamples, namedSamplesIDs}]
	];

	{myInput, mySafeOptions, myOptionsWithPreparedSamples}/.sampleToIDMap
];

(* ::Subsection::Closed:: *)
(*fetchPacketFromCache *)


fetchPacketFromCache[Null,_]:=Null;
fetchPacketFromCache[myPacket_Association,myCachedPackets_]:=myPacket;
(* if we don't have a cache here - just return Null right away *)
fetchPacketFromCache[myObject_Association,myCachedPackets:{}]:=<||>;
fetchPacketFromCache[myObject_,myCachedPackets_]:=Module[
	{myObjectNoLink,naiveLookup,type,name},

	(* If given $Failed, return an empty packet. *)
	If[MatchQ[myObject,$Failed],
		Return[<||>];
	];

	(* Make sure that myObject isn't a link. *)
	myObjectNoLink=Download[myObject,Object];

	(* First try to find the packet from the cache using Object->myObject *)
	naiveLookup=FirstCase[myCachedPackets,KeyValuePattern[{Object->myObjectNoLink}],<||>];

	(* Were we able to find a packet? *)
	If[!MatchQ[naiveLookup,<||>],
		(* Yes. *)
		naiveLookup,
		(* No. *)
		(* We may have been given a name. *)
		(* Get the type and name from the object. *)
		type=Most[myObjectNoLink];
		name=Last[myObjectNoLink];

		(* Lookup via the name and type. *)
		FirstCase[myCachedPackets,KeyValuePattern[{Type->type,Name->name}],<||>]
	]
];


(* ::Subsection::Closed:: *)
(*makeFastAssocFromCache*)

(* make a hash table that is much faster than using Cases to find a packet from the cache *)
makeFastAssocFromCache[myCache:{}]:=<||>;
makeFastAssocFromCache[myCache:{__Association}]:=Module[
	{objects, names, namedObjects, cacheAssoc},

	(* pull out the names and object IDs from the cache *)
	{objects, names} = Transpose[Lookup[myCache, {Object, Name}]];

	(* get the named objects; if there isn't a name or an object then just use Null *)
	namedObjects = MapThread[
		If[MatchQ[#1, _Model | _Object] && StringQ[#2],
			Append[Most[#1], #2],
			Null
		]&,
		{objects, names}
	];

	(* make an association of the objects/named objects and cache *)
	cacheAssoc = KeyDrop[AssociationThread[Join[objects, namedObjects], Join[myCache, myCache]], Null]

];


(* ::Subsection::Closed:: *)
(*fetchPacketFromFastAssoc*)

(* get the packet from our association generated from makeFastAssocFromCache *)
fetchPacketFromFastAssoc[myNullOrFailed:Null|$Failed|_String, _]:=myNullOrFailed;
(* if we don't have a cache here - just return Null right away *)
fetchPacketFromFastAssoc[myObject:ObjectP[], myEmptyCache:<||>]:={};
fetchPacketFromFastAssoc[myObject:ObjectP[], myAssoc_Association]:=With[
	{
		(* make sure we're using an object and not a link or packet *)
		objectReference = Switch[myObject,
			ObjectReferenceP[], myObject,
			LinkP[], myObject /. Link[x_, ___] :> x,
			_, Lookup[myObject, Object]
		]
	},

	(* if we cant find the packet, return an empty list so that fastAssocLookup will be ok *)
	(* we need to remove names for this to work *)
	Lookup[myAssoc, Download[objectReference, Object], {}]
];


(* ::Subsection::Closed:: *)
(*fastAssocLookup*)

(* If the object is Null, return Null *)


(* Authors definition for Experiment`Private`fastAssocLookup *)
Authors[Experiment`Private`fastAssocLookup]:={"hanming.yang", "steven"};

fastAssocLookup[myAssoc_Association, myObject:Null, myFields:ListableP[_Symbol]]:=Null;
fastAssocLookup[myAssoc:<||>, myObject:ObjectP[],myFields:ListableP[_Symbol]]:=$Failed;
fastAssocLookup[myAssoc:<||>, myObjects:{ObjectP[]..},myFields:ListableP[_Symbol]]:=ConstantArray[$Failed,Length[myObjects]];

(* look up recursively from the fast association if we don't already have the packet on hand *)
fastAssocLookup[myAssoc_Association, myObject:ObjectP[], myFields:ListableP[_Symbol]]:=Module[
	{listyFields, objectPacket, firstValue},

	(* make sure we have a list of fields *)
	listyFields = ToList[myFields];

	(* get the packet for the object *)
	(*this will always return either a packet or {}*)
	objectPacket = fetchPacketFromFastAssoc[Download[myObject, Object], myAssoc];

	(* get the first value *)
	(* if there is no packet or the value is not there, return $Failed *)
	firstValue = Lookup[objectPacket, First[listyFields], $Failed];

	(* if we couldn't find a packet in fetchPacketFromFastAssoc or the field is not present in that packet and we are going to try another iteration, need to return $Failed *)
	If[MatchQ[firstValue,Except[ListableP[ObjectP[]]]]&&MatchQ[Length[listyFields], GreaterP[1]],
		Return[$Failed]
	];

	(* if listyFields was length 1, then we're done and should return that value; otherwise, recursively call dispatchLookup again *)
	(* note that if we have a list of objects as the first result, that is fine and we'll just go through all of them*)
	Which[
		Length[listyFields] == 1, firstValue,
		MatchQ[firstValue, ObjectP[]], fastAssocLookup[myAssoc, firstValue, Rest[listyFields]],
		True, (fastAssocLookup[myAssoc, #, Rest[listyFields]]& /@ firstValue)
	]

];

(* Lookup the same fields from multiple objects *)
fastAssocLookup[myAssoc_Association,myObjects:{ObjectP[]..},myFields:ListableP[_Symbol]]:=fastAssocLookup[myAssoc,#,myFields]&/@myObjects;

(* Empty list as sample overload *)
fastAssocLookup[myAssoc_Association,myObjects:{},myFields:ListableP[_Symbol]]:={};

(* ::Subsection::Closed:: *)
(*fastAssocPacketLookup*)

(* Authors definition for Experiment`Private`fastAssocLookup *)
Authors[Experiment`Private`fastAssocPacketLookup]:={"steven", "dima"};

(* if the object is Null, return Null *)
fastAssocPacketLookup[myFastAssoc_Association, myObject:Null, myFields:ListableP[_Symbol]]:=Null;
fastAssocPacketLookup[myEmptyAssoc:<||>, myObject:ObjectP[],myFields:ListableP[_Symbol]]:=$Failed;
fastAssocPacketLookup[myEmptyAssoc:<||>, myObjects:{ObjectP[]..},myFields:ListableP[_Symbol]]:=ConstantArray[$Failed,Length[myObjects]];

(* get the packet of a field you're looking up from an object *)
(* for example, fastAssocPacketLookup[fastAssoc, sample, {Container, Model}] will get the container model packet of the provided sample *)
fastAssocPacketLookup[myFastAssoc_Association, myObject:ObjectP[], myFields:ListableP[_Symbol]]:=Module[
	{fastAssocLookupResult},

	(* first lookup everything using fastAssocLookup *)
	fastAssocLookupResult = fastAssocLookup[myFastAssoc, myObject, myFields];

	(* now fetch the packet for the thing or things that we actually dug to get *)
	If[ListQ[fastAssocLookupResult],
		fetchPacketFromFastAssoc[#, myFastAssoc] & /@ fastAssocLookupResult,
		fetchPacketFromFastAssoc[fastAssocLookupResult, myFastAssoc]
	]
];

(* ::Subsection::Closed:: *)
(*repeatedFastAssocLookup*)


(* Authors definition for Experiment`Private`fastAssocLookup *)
Authors[Experiment`Private`fastAssocPacketLookup]:={"steven"};

repeatedFastAssocLookup::RecursionTerminated="repeatedFastAssocLookup has completed 40 iterations of looking up the value of `1` at field `2`, and has did not terminate.  An infinite loop is suspected; please check to make sure this effort does in fact terminate.";

repeatedFastAssocLookup[myEmptyCacheAssociation:<||>,___]:={};
(* Note that currently, this only works with simple recursion (Repeated[Container] or Repeated[ParentProtocol]).  It doesn't work with complicated ones like Repeated[Contents[[All, 2]]]. *)
(* also only works on single fields *)
repeatedFastAssocLookup[myFastAssoc_Association, myObject:ObjectP[], myField_Symbol]:=Module[
	{runningList, initialParent, nextParent},

	(* figure out what the first iteration of this field is; we are going to constantly change nextParent and append to runningList *)
	runningList = {};
	initialParent = fastAssocLookup[myFastAssoc, myObject, myField];
	nextParent = initialParent;

	(* setting limit of this to 40; any more and I'm assuming I'm in a recursive loop and don't want that *)
	While[MatchQ[nextParent, ObjectP[]] && Length[runningList] < 40,
		AppendTo[runningList, nextParent];
		nextParent = fastAssocLookup[myFastAssoc, nextParent, myField];
	];

	If[Length[runningList] >= 20,
		Message[repeatedFastAssocLookup::RecursionTerminated, myObject, myField]
	];

	runningList
];

(* ::Subsection::Closed:: *)
(*pooledContainerToSampleOptions*)


DefineOptions[
	pooledContainerToSampleOptions,
	Options:>{
		{EmptyContainers->False,BooleanP,"Indicates if the experiment for which options are being converted can handle empty containers."},
		{GroupContainerSamples->False,BooleanP,"Indicates that when a container is expanded into its samples, if the samples should be placed in the same pooling group."},
		{
			Output -> Result,
			ListableP[Result|Tests|Simulation], (*Not using HelperOutputOption here since we add Simulation as the output for this option*)
			"Indicate what the helper function that does not need the Preview or Options output should return.",
			Category->Hidden
		},
		SimulationOption,
		CacheOption
	}
];


(* Given an input and option value (with the option's singleton pattern), does a lightweight ValidInputLengthsQ, assuming that constant options (singletons) will be expanded later. *)
sameInputAndOptionPoolLengthQ[input_,optionValue_,singletonPattern_,pooled_]:=With[{},
	(* If input2 matches singleton pattern, we're okay. *)
	If[MatchQ[optionValue,ReleaseHold[singletonPattern]],
		Return[True];
	];

	(* Note: If the option value doesn't match the singleton pattern, we're guaranteed for the option value to be in a list. *)

	(* Otherwise, make sure we match the first level of index matching. *)
	(* If the input is a singleton, we should not have the option value be in a list. *)
	If[MatchQ[{input,optionValue},{Except[_List],_List}]||!SameLengthQ[input,optionValue],
		Return[False];
	];

	(* Only check the second level of index matching if we have a pooled option. *)
	If[TrueQ[pooled],
		Return[True];
	];

	(* We have a pooled option. *)
	And@@MapThread[
		Function[{inputElement,optionElement},

			(* If our second element matches the singleton pattern, we're okay. *)
			If[MatchQ[optionElement,ReleaseHold[singletonPattern]],
				True,
				(* We didn't match the singleton pattern. *)
				(* Make sure the input element isn't a singleton with the option element being a list. If they're okay, then make sure the lengths are the same. *)
				If[MatchQ[{inputElement,optionElement},{Except[_List],_List}]||!SameLengthQ[ToList[inputElement],ToList[optionElement]],
					False,
					True
				]
			]
		],
		{input,optionValue}
	]
];


Error::InvalidIndexMatching="The following option(s) `1` are not correctly index-matched to their inputs. Please check the lengths of your inputs and options.";

pooledContainerToSampleOptions[myFunction_Symbol, myObjects_, myOptions : {(_Rule | _RuleDelayed)...}, options : OptionsPattern[]] := Module[
	{listedOptions, safeOptions, cache, simulation, emptyContainersOption, groupContainerSamples, outputSpecification, gatherTests, listedObjects, optionDefinition, validOptionLengthsQ,
		optionSymbol, optionValue, positionInContainers,  containerPositions, containersWithPositions, noPositionObjects, containers, cacheBall, containerToSampleRules, containerNumberOfSamples, emptyContainers, emptyContainerTests, expandedInputs,
		expandedOptions, correspondingOptionValues, expandedOptionValues, replacedOptions, optionValueBooleans, filteredPositions, filteredNumberOfSamples,
		specificOptionDefinition, indexMatchingInput, singletonPattern, pooledQ, output, simulationRule},

	(* ToList our options. *)
	listedOptions = ToList[options];

	(* Get our SafeOptions. *)
	safeOptions = SafeOptions[pooledContainerToSampleOptions, listedOptions, AutoCorrect -> False];

	(* Lookup our options. *)
	{
		cache,
		simulation,
		emptyContainersOption,
		groupContainerSamples,
		outputSpecification
	} = Lookup[
		safeOptions,
		{
			Cache,
			Simulation,
			EmptyContainers,
			GroupContainerSamples,
			Output
		},
		{}
	];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[outputSpecification, Tests];

	(* ToList our objects. *)
	listedObjects = ToList[myObjects];

	(* Get the option definition for the function. *)
	optionDefinition = OptionDefinition[myFunction];

	(* Make sure that our objects and our options are of the same length. *)
	validOptionLengthsQ = Map[
		Function[{option},
			(* Get the option symbol and value. *)
			optionSymbol = option[[1]];
			optionValue = option[[2]];

			(* Get the option definition. *)
			specificOptionDefinition = FirstCase[optionDefinition, KeyValuePattern["OptionSymbol" -> optionSymbol], <||>];

			(* See if this option index-matches the input. *)
			indexMatchingInput = Lookup[specificOptionDefinition, "IndexMatchingInput", $Failed];

			(* Make sure that the option value is the same length as our input objects. *)
			If[MatchQ[indexMatchingInput, _String],
				(* Get the singleton pattern of our option. If our option matches that, don't bother checking. *)
				singletonPattern = Lookup[specificOptionDefinition, "SingletonPattern", $Failed];

				(* See if our option is pooled. *)
				pooledQ = Lookup[specificOptionDefinition, "NestedIndexMatching", $Failed];

				(* Make sure that our input and option value are the same lengths, taking into account if they are pooled. *)
				sameInputAndOptionPoolLengthQ[myObjects, optionValue, singletonPattern, pooledQ],
				(* Not index-matching, no need to check. *)
				True
			]
		],
		myOptions
	];

	(* If our inputs and options aren't of the same length, return $Failed. *)
	If[!And @@ validOptionLengthsQ,
		(* If we aren't gathering tests, throw an Error. *)
		If[!MemberQ[ToList[outputSpecification], Tests],
			Message[Error::InvalidIndexMatching, PickList[myOptions, validOptionLengthsQ, False][[All, 1]]];
		];

		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> {Test["The inputs and options are matching in length (including the length of corresponding pooled sample groups):", False, True]},
			Simulation -> (simulation /. {Null -> Simulation[]})
		}]
	];

	(* Collect all {Position,Container} in the list *)
	positionInContainers = Position[myObjects, {LocationPositionP, ObjectP[Object[Container]]}];

	(* Extract the corresponding container object *)
	containersWithPositions = myObjects[[Sequence @@ #]]& /@ positionInContainers;

	(* Replace the {Position,Container} with Null so we are not counting it twice for Object[Container] *)
	noPositionObjects = ReplacePart[myObjects, (# -> Null) & /@ positionInContainers];

	(* Get the positions of the containers in our input list. *)
	containerPositions = Position[noPositionObjects, ObjectP[Object[Container]]];

	(* Get all of the containers in listedObjects. *)
	containers = noPositionObjects[[Sequence @@ #]]& /@ containerPositions;

	(* Download the contents of our containers. *)
	(* Note: Make sure to pass down cache here since some of our containers can be simulated. *)
	cacheBall = Quiet[Flatten[{
		Download[
			DeleteDuplicates[Join[containersWithPositions[[All,2]],containers]],
			Packet[Contents, Name],
			Cache -> cache,
			Simulation -> simulation
		],
		cache
	}]];

	(* Create replacement rules from our containers to our samples. *)
	containerToSampleRules = Join[
		MapThread[
			Function[{container, containerPosition},
				(* If we're going down more than 1 level of nesting, we always have to return a sequence (we can't have 3 levels of nesting). *)
				container -> If[Length[containerPosition] > 1,
					Download[FirstCase[Lookup[fetchPacketFromCache[container[[2]], cacheBall], Contents],{container[[1]],___},{Null,Null}][[2]], Object],
					(* Otherwise, we're at the top level and can return either 1 list or multiple lists. *)
					If[groupContainerSamples,
						(* We are grouping the samples together. *)
						Download[{FirstCase[Lookup[fetchPacketFromCache[container[[2]], cacheBall], Contents],{container[[1]],___},{Null,Null}][[2]]}, Object],
						(* We are not grouping the samples together. *)
						Sequence @@ ({#}& /@ Download[{FirstCase[Lookup[fetchPacketFromCache[container[[2]], cacheBall], Contents],{container[[1]],___},{Null,Null}][[2]]}, Object])
					]
				]
			],
			{containersWithPositions,positionInContainers}
		],
		MapThread[
			Function[{container, containerPosition},
				(* If we're going down more than 1 level of nesting, we always have to return a sequence (we can't have 3 levels of nesting). *)
				container -> If[Length[containerPosition] > 1,
					Sequence @@ Download[Lookup[fetchPacketFromCache[container, cacheBall], Contents][[All, 2]], Object],
					(* Otherwise, we're at the top level and can return either 1 list or multiple lists. *)
					If[groupContainerSamples,
						(* We are grouping the samples together. *)
						Download[Lookup[fetchPacketFromCache[container, cacheBall], Contents][[All, 2]], Object],
						(* We are not grouping the samples together. *)
						Sequence @@ ({#}& /@ Download[Lookup[fetchPacketFromCache[container, cacheBall], Contents][[All, 2]], Object])
					]
				]
			],
			{containers,containerPositions}
		]
	];

	(* For each of these replacement rules, get the number of samples in the container. *)
	containerNumberOfSamples = (Length[ToList[#[[2]]]]&) /@ containerToSampleRules;

	(* Print an error if empty containers were supplied and they are not supported by the experiment *)
	emptyContainers = PickList[Keys[containerToSampleRules], containerNumberOfSamples, 0];
	If[!MatchQ[emptyContainers, {}] && !emptyContainersOption && !gatherTests,
		(
			Message[Error::EmptyContainers, emptyContainers];
			Return[outputSpecification /. {
				Result -> $Failed,
				Simulation -> (simulation /. {Null -> Simulation[]}),
				Tests -> {}
			}]
		)
	];

	(* make a test that matches the above message *)
	emptyContainerTests = If[!emptyContainersOption && gatherTests,
		MapThread[
			Test[ToString[#1, InputForm] <> " contains samples on which the experiment can act", MatchQ[#2, 0], False]&,
			{Keys[containerToSampleRules], containerNumberOfSamples}
		],
		{}
	];

	(* Replace our containers with these samples. *)
	expandedInputs = myObjects /. containerToSampleRules;

	(* Expand our options. *)
	expandedOptions = Function[{option},
		(* Get our option symbol and value. *)
		optionSymbol = option[[1]];
		optionValue = option[[2]];

		(* Get the option definition. *)
		specificOptionDefinition = FirstCase[optionDefinition, KeyValuePattern["OptionSymbol" -> optionSymbol], <||>];

		(* Get the singleton pattern of our option. *)
		singletonPattern = Lookup[specificOptionDefinition, "SingletonPattern", $Failed];

		(* See if our option is pooled. *)
		pooledQ = Lookup[specificOptionDefinition, "NestedIndexMatching", $Failed];

		(* See if this option index-matches the input. *)
		indexMatchingInput = Lookup[specificOptionDefinition, "IndexMatchingInput", $Failed];

		(* If our option isn't index-matched to pools or if it matches singleton pattern, we don't have to change anything. *)
		If[MatchQ[optionValue, ReleaseHold[singletonPattern]],
			option,
			(* See if this option is matched to the input. *)
			If[MatchQ[indexMatchingInput, Except[_String]],
				(* We are not matching to the input, don't expand anything. *)
				option,
				(* Our option value is a list that is index matched to the input. We have to change any indices that correspond with the container to match the samples. *)

				(* For each of our container indices, make sure that the uppermost level spec is a list and it doesn't already match singleton pattern. *)
				(* Exclude it if it doesn't satisfy this criteria *)
				optionValueBooleans = With[{containerOptionValue = optionValue[[Sequence @@ Most[#]]]},
					If[MatchQ[containerOptionValue, _List] && !MatchQ[containerOptionValue, ReleaseHold[singletonPattern]],
						True,
						False
					]
				]& /@ containerPositions;

				(* Filter our positions and number of samples. *)
				filteredPositions = PickList[containerPositions, optionValueBooleans];
				filteredNumberOfSamples = PickList[containerNumberOfSamples, optionValueBooleans];

				(* Get the values that show up at our container indices. *)
				correspondingOptionValues = optionValue[[Sequence @@ #]]& /@ filteredPositions;

				(* Based on position in the list and whether we're grouping samples together, expand our options for each of these positions. *)
				(* Note: This is different than the code above because we have to List[...] since we don't have the list head to distinguish our values (sequence in a list will mess up our map thread. *)
				expandedOptionValues = MapThread[
					Function[{value, position, numberOfSamples},
						(* If we're going down more than 1 level of nesting, we always have to return a sequence (we can't have 3 levels of nesting). *)
						If[Length[position] > 1 || MatchQ[pooledQ, False],
							{Sequence @@ ConstantArray[value, numberOfSamples]},
							(* Otherwise, we're at the top level and can return either 1 list or multiple lists. *)
							If[groupContainerSamples,
								(* We are grouping the samples together. *)
								{ConstantArray[value, numberOfSamples]},
								(* We are not grouping the samples together. *)
								{Sequence @@ ({#}& /@ ConstantArray[value, numberOfSamples])}
							]
						]
					],
					{correspondingOptionValues, filteredPositions, filteredNumberOfSamples}
				];

				(* Replace each of our positions with these values. *)
				replacedOptions = Fold[ReplacePart[#1, (#2[[1]]) -> Sequence @@ (#2[[2]])]&, Lookup[myOptions, optionSymbol], Transpose[{filteredPositions, expandedOptionValues}]];

				(* Return our replaced options. *)
				optionSymbol -> replacedOptions
			]
		]
	] /@ myOptions;


	(* Build simulation *)
	simulationRule = Simulation -> If[MemberQ[output, Simulation],
		(* Return the samples and the index-matched options*)

		(* Update the simulation. *)
		If[NullQ[simulation], Simulation[], simulation],

		Null
	];

	(* Return our output. *)
	outputSpecification /. {
		(* Make sure that our replaced input isn't a sequence. *)
		Result -> If[MatchQ[{expandedInputs}, {_Sequence}],
			{{expandedInputs}, expandedOptions},
			{expandedInputs, expandedOptions}
		],
		Tests -> Flatten[{
			Test["The inputs and options are matching in length (including the length of corresponding pooled sample groups):", True, True],
			emptyContainerTests
		}],
		simulationRule
	}
];


(* ::Subsection::Closed:: *)
(*containerToSampleOptions*)


(* ::Subsubsection::Closed:: *)
(*containerToSampleOptions - Options*)


DefineOptions[
	containerToSampleOptions,
	Options:>{
		{
			EmptyContainers->False,
			BooleanP,
			"Indicates if the experiment for which options are being converted can handle empty containers."
		},
		{
			Output -> Result,
			ListableP[Result|Tests|Simulation], (*Not using HelperOutputOption here since we add Simulation as the output for this option*)
			"Indicate what the helper function that does not need the Preview or Options output should return.",
			Category->Hidden
		},
		CacheOption,
		SimulationOption
	}
];


(* ::Subsubsection::Closed:: *)
(*containerToSampleOptions - Messages*)


Warning::SampleAndContainerSpecified="The following sample(s) were specified along with the containers holding these sample(s), `1`. If this was intended, this message can be ignored. If you do not wish to operate on these samples twice, please remove them or their containers from your input list.";
Warning::DuplicateContainersSpecified="The following containers(s) were specified, `1`, along with the specific positions in that container, `2`. This will result in the positions, `2`, being sent as input twice to the experiment function. If this was intended, this message can be ignored. If you do not wish to operate on these samples twice, please those containers from your input list.";
Error::ContainerEmptyWells="The specified the well(s) in the following container(s), `1`, are currently empty and cannot be used an input to the experiment function. Please only specify wells that contain samples in them.";
Error::WellDoesNotExist="The following well specification(s), `1` , do not exist for container(s), `2`. Please double check the list of valid wells for a given container by looking at the AllowedPositions field of the Object[Container].";

(* ::Subsubsection::Closed:: *)
(*containerToSampleOptions*)


(*
	--- Main Overload ---
	Expands options index matched to a container to be indexed matched to the samples within that container
	Only options provided as a list are expanded
	Input:
		myObjects - a mixed list of samples and containers
		myOptions - options associated with myObjects
	Output:
		{samples,expandedOptions} - samples and the options index matched to them
*)

containerToSampleOptions[myFunction_Symbol, myObject : ListableP[ObjectP[{Object[Sample], Model[Sample], Object[Container], Object[Item]}] | {LocationPositionP, ObjectP[Object[Container]]}], myOptions : {(_Rule | _RuleDelayed)...}, ops : OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, objects, containers, specifiedSamples, listedContainerContents, listedSampleObjects, containerContents,
		sampleObjects, safeExperimentOptions, containerToContents, emptyContainers, occupiedContainerToContents, samplesSpecifiedTwice, optionDefinitions, updatedOptions, samples, testsRule, resultRule,
		allTests, emptyContainerTests, samplesAndContainersTests, flattenedContainerContentsPattern, unlistedSamples, positionInContainers, positions, specifiedContainers, containerContentsWithPositions,
		containerPackets, containerPositions, listedContainerContentsWithPositions, listedContainerPackets, sampleFromSpecifiedPosition, simulatedSamplePackets, emptyWellBooleans, emptyWellContents,
		wellOutOfRangeBooleans, emptyWellTests, nonEmptyWellContents, simulation, simulationRule, samplesByPositionQ, occupiedContainerToContentWithPositions, flattenedContainerPattern, containersSpecifiedTwice,
		nonOnPlateContents, nonOnPlateTests, listedContainerPositions, cache, listedContainerModelPackets, containerModelPackets
	},

	(* Make sure we're working with a list of options and objects *)
	listedOptions = ToList[ops];
	objects = If[MatchQ[myObject, {LocationPositionP, ObjectP[Object[Container]]}], {myObject}, ToList[myObject]];

	(* Get the simulation for *)
	simulation = Lookup[listedOptions, Simulation, Null];
	cache = Lookup[listedOptions, Cache, {}];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Add an SafeOption for experiment options to make sure every input experiment options match pattern *)
	(* Here we will only run SafeOption to check if everything works fine but will not use the results from SafeOptions*)
	safeExperimentOptions = SafeOptions[myFunction, ToList[myOptions], AutoCorrect -> False];

	(* If the specified experiment function options don't match their patterns, return $Failed *)
	If[MatchQ[safeExperimentOptions, $Failed],
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[containerToSampleOptions, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[containerToSampleOptions, listedOptions, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns, return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[{$Failed, $Failed}]
	];

	(* Get all the containers in the list *)
	containers = Cases[objects, ObjectP[Object[Container]]];

	(* Get all the samples and items in the list *)
	specifiedSamples = Cases[objects, ObjectP[{Object[Sample], Model[Sample], Object[Item]}]];

	(* Collect all {Position,Container} in the list *)
	positionInContainers = Cases[objects, {LocationPositionP, ObjectP[Object[Container]]}];

	(* Build a boolean when the options were specified by position *)
	samplesByPositionQ = Length[positionInContainers] > 0;

	(* Get the positions and specifiedContainers  *)
	{positions, specifiedContainers} = If[
		samplesByPositionQ,
		{positionInContainers[[All, 1]], Download[positionInContainers[[All, 2]], Object]},
		{{}, {}}
	];

	(* Get the contents of the containers and the sample objects (in case links, packets, or names were provided) *)
	{listedContainerContents, listedSampleObjects, listedContainerContentsWithPositions, listedContainerPackets, listedContainerModelPackets, listedContainerPositions} = Download[
		{containers, specifiedSamples, specifiedContainers, specifiedContainers, specifiedContainers, specifiedContainers},
		{
			{Contents[[All, 2]][Object]},
			{Object},
			{Contents},
			{Packet[StorageCondition]},
			{Packet[Model[{MinVolume, MaxVolume}]]},
			{Model[Positions]}
		},
		Cache -> Lookup[safeOptions, Cache],
		Simulation -> Lookup[safeOptions, Simulation]
	];

	{
		containerContents,
		sampleObjects,
		containerContentsWithPositions,
		containerPackets,
		containerModelPackets,
		containerPositions
	} = Flatten[#, 1]& /@ {
		listedContainerContents,
		listedSampleObjects,
		listedContainerContentsWithPositions,
		listedContainerPackets,
		listedContainerModelPackets,
		listedContainerPositions
	};

	(* Here we fetch the sample from its desired location from download packet *)
	(* If we don't have a sample there, upload a fake water sample in order to pass the front end check. *)
	{sampleFromSpecifiedPosition, simulatedSamplePackets, emptyWellBooleans, wellOutOfRangeBooleans} = If[samplesByPositionQ,
		Transpose@MapThread[
			Function[{position, container, content, packet, allowedPosition, containerModelPacket},
				Module[{sampleInPosition, simulatedSamplePacket, sampleObject, emptyWellQ, wellOutOfRangeQ, positionOnPlateQ},

					(* Check if we have a sample in the desired options for the container *)
					sampleInPosition = Lookup[Rule @@@ content, position, Null];

					(* Check if specified well is a reasonable position on that plate *)
					positionOnPlateQ = MemberQ[Lookup[allowedPosition, Name], position];

					(* if not build a fake sample to be passed back to the experiment function to bypass the front end limitation that we don't return an error here.*)
					{simulatedSamplePacket, emptyWellQ, wellOutOfRangeQ} = Which[
						(* If there is sample in that well, we won't simulate the sample packet *)
						MatchQ[sampleInPosition, ObjectP[]], {{}, False, False},

						(* If the there is no contents in the specified well but the specified well in on that plate *)
						positionOnPlateQ,
						{
							UploadSample[Model[Sample, "Milli-Q water"], {position, container},
								Name -> "Non-existing sample " <> ToString[Unique[]],
								InitialAmount -> Which[
									MatchQ[Lookup[containerModelPacket, MinVolume], VolumeP],
									Lookup[containerModelPacket, MinVolume],
									MatchQ[Lookup[containerModelPacket, MaxVolume], VolumeP],
									Lookup[containerModelPacket, MaxVolume],
									True,
									1 Microliter
								],
								StorageCondition -> Download[Lookup[packet, StorageCondition], Object] /. {Null -> Automatic}, (*TODO double check if storage container is single*)
								Upload -> False,
								(*								SimulationMode->True,*)
								FastTrack -> True,
								Simulation -> simulation,
								Cache -> cache
							],
							True,
							False
						},

						(* If the specified plate are not even on the plate, we use the last well of that plate and simulate a fake sample *)
						True,
						{
							UploadSample[Model[Sample, "Milli-Q water"], {Last[Lookup[allowedPosition, Name]], container},
								Name -> "Non-existing sample in an non-existing well " <> ToString[Unique[]],
								InitialAmount -> Which[
									MatchQ[Lookup[containerModelPacket, MinVolume], VolumeP],
									Lookup[containerModelPacket, MinVolume],
									MatchQ[Lookup[containerModelPacket, MaxVolume], VolumeP],
									Lookup[containerModelPacket, MaxVolume],
									True,
									1 Microliter
								],
								StorageCondition -> Download[Lookup[packet, StorageCondition], Object] /. {Null -> Automatic},
								Upload -> False,
								(*								SimulationMode->True,*)
								FastTrack -> True,
								Simulation -> simulation,
								Cache -> cache
							],
							False,
							True
						}

					];

					(* Generate the sampleObject we need to return *)
					sampleObject = If[
						MatchQ[sampleInPosition, ObjectP[]],

						Download[sampleInPosition, Object],

						First[Lookup[simulatedSamplePacket, Object]]

					];

					{sampleObject, simulatedSamplePacket, emptyWellQ, wellOutOfRangeQ}

				]
			],
			{
				(*1*)positions,
				(*2*)specifiedContainers,
				(*3*)containerContentsWithPositions,
				(*4*)containerPackets,
				(*5*)containerPositions,
				(*6*)containerModelPackets
			}
		],
		{{}, {}, {}, {}}
	];

	(* Create a list of rules linking containers to their contents *)
	containerToContents = AssociationThread[containers, containerContents];

	(* Print an error if empty containers were supplied and they are not supported by the experiment *)
	emptyContainers = Keys[Select[containerToContents, MatchQ[{}]]];

	If[!MatchQ[emptyContainers, {}] && !Lookup[safeOptions, EmptyContainers] && !gatherTests,
		Message[
			Error::EmptyContainers,
			ObjectToString[emptyContainers, Cache -> cache]
		];
		Return[outputSpecification /. {
			Result -> $Failed,
			Simulation -> (simulation /. {Null -> Simulation[]}),
			Tests -> {}
		}]
	];

	(* make a test that matches the above message *)
	emptyContainerTests = If[!Lookup[safeOptions, EmptyContainers] && gatherTests,
		Map[
			Test[ToString[#, InputForm] <> " contains samples on which the experiment can act", MatchQ[Lookup[containerToContents, #], {}], False]&,
			Keys[containerToContents]
		],
		{}
	];

	(* In those cases where user specifies {Position,Plate} and the corresponding position is empty we will throw an error stating that it's empty well *)
	emptyWellContents = PickList[positionInContainers, emptyWellBooleans];

	(*Throw the Error message*)
	If[!MatchQ[emptyWellContents, {}] && !Lookup[safeOptions, EmptyContainers] && !gatherTests,
		Message[Error::ContainerEmptyWells, emptyWellContents]
	];

	(* make a test that matches the above message *)
	emptyWellTests = If[!Lookup[safeOptions, EmptyContainers] && gatherTests,
		Map[
			Test[ToString[#, InputForm] <> " contains samples on which the experiment can per", MatchQ[Lookup[containerToContents, #], {}], False]&,
			emptyWellContents
		],
		{}
	];

	(* Build an error message when user specify a well that is not on that plate *)
	nonOnPlateContents = PickList[positionInContainers, wellOutOfRangeBooleans];


	(*Throw the Error message*)
	If[!MatchQ[nonOnPlateContents, {}] && !Lookup[safeOptions, EmptyContainers] && !gatherTests,
		Message[Error::WellDoesNotExist, nonOnPlateContents[[All, 1]], nonOnPlateContents[[All, 2]]]
	];

	(* make a test that matches the above message *)
	nonOnPlateTests = If[!Lookup[safeOptions, EmptyContainers] && gatherTests,
		Map[
			Test[ToString[#, InputForm] <> " contains samples on which the experiment can per", MatchQ[Lookup[containerToContents, #], {}], False]&,
			nonOnPlateContents
		],
		{}
	];


	(* Generate the a the non-empty samples *)
	nonEmptyWellContents = PickList[sampleFromSpecifiedPosition, emptyWellBooleans, False];

	occupiedContainerToContents = KeyDrop[containerToContents, emptyContainers];

	(* Combine the containerToContents Lookup with *)
	occupiedContainerToContentWithPositions = Join[occupiedContainerToContents, AssociationThread[positionInContainers, ToList /@ sampleFromSpecifiedPosition]];

	(* Note: ObjectP chokes on 9000+ samples due to recursion limits. We're only building a pattern here so it can be duplicate free *)
	flattenedContainerContentsPattern = ObjectP[DeleteDuplicates@Flatten[{containerContents, nonEmptyWellContents}]];

	(* Print a warning if samples and their containers were supplied in the input list *)
	samplesSpecifiedTwice = Cases[sampleObjects, flattenedContainerContentsPattern];
	If[!MatchQ[samplesSpecifiedTwice, {}] && !gatherTests && !MatchQ[$ECLApplication, Engine],
		(* When printing the message, return the sample in the form it was originally specified *)
		Message[Warning::SampleAndContainerSpecified, Lookup[AssociationThread[sampleObjects, specifiedSamples], samplesSpecifiedTwice]]
	];

	(*
		"The following samples were specified along with the containers holding these samples. If this was intended, this message can be ignored. If you do not wish to operate on these samples twice, please remove them or their containers from your input list."
	*)

	samplesAndContainersTests = If[gatherTests,
		Map[
			Test[ToString[#, InputForm] <> " and its container should not appear in the input twice unless the intent is for this sample to be operate on twice.",
				MatchQ[#, flattenedContainerContentsPattern],
				False
			]&,
			sampleObjects
		]
	];

	(* Build an error checker that duplicate container contents were specified *)
	(* build a pattern represents all specified containers *)
	(* Here check duplicate container specified by both the container and {<position>, container} and give user a warning *)
	flattenedContainerPattern = ObjectP[DeleteDuplicates@Flatten[{specifiedContainers}]];

	containersSpecifiedTwice = Cases[containers, flattenedContainerPattern];
	If[!MatchQ[containersSpecifiedTwice, {}] && !gatherTests && !MatchQ[$ECLApplication, Engine],
		(* When printing the message, return the sample in the form it was originally specified *)
		Message[Warning::DuplicateContainersSpecified, containersSpecifiedTwice, PickList[positions, specifiedContainers, flattenedContainerPattern]]
	];

	(* Build a new test *)
	samplesAndContainersTests = If[gatherTests,
		Map[
			Test[ToString[#, InputForm] <> " should not appear in the input twice unless the intent is for its content to be operate on twice.",
				MatchQ[#, flattenedContainerPattern],
				False
			]&,
			containers
		]
	];


	(* For each option, get the list of keys used to define the option *)
	optionDefinitions = OptionDefinition[myFunction];

	(* Update any MapThread option values to be index matched to a list of samples instead of samples and containers *)
	updatedOptions = Map[
		Function[optionRule,
			Module[{optionName, optionValue, optionDefinition, inputMatchedBoolean, optionPattern, singletonPattern},
				(* Get the option name and value from the rule *)
				optionName = First[optionRule];
				optionValue = Last[optionRule];

				(* Determine if the option is index-matched to the input *)
				optionDefinition = SelectFirst[optionDefinitions, MatchQ[#["OptionName"], SymbolName[optionName]]&];
				inputMatchedBoolean = MatchQ[Lookup[optionDefinition, "IndexMatching"], "Input"] || MatchQ[Lookup[optionDefinition, "IndexMatchingInput"], _String];
				optionPattern = Lookup[optionDefinition, "Pattern"];
				singletonPattern = If[MatchQ[Lookup[optionDefinition, "SingletonPattern"], _Missing],
					FirstCase[optionPattern, Verbatim[ListableP][pattern_] :> pattern],
					Lookup[optionDefinition, "SingletonPattern"]
				];

				(* Update the option rule if the option is MapThread, index-matched to the input and already expanded *)
				(* Only update if option is valid and expanded, leave options with improper lengths/patterns alone *)
				optionName -> If[inputMatchedBoolean && MatchQ[optionValue, ReleaseHold[optionPattern]] && !MatchQ[optionValue, ReleaseHold[singletonPattern]] && SameLengthQ[objects, optionValue],
					(* Repeat container option values n times where n is the number of samples in the container *)
					(* Note this assumes option lengths have already been validated *)

					MapThread[
						Function[{object, valueForObject},

							If[MatchQ[object, ObjectP[{Object[Sample], Object[Item]}]],
								valueForObject,
								Sequence @@ ConstantArray[valueForObject, Length[Lookup[occupiedContainerToContentWithPositions, Key[object], {object}]]]
							]
						],
						{objects, optionValue}
					],
					(* Option value is a singleton and so does not need to be expanded for the changing input *)
					optionValue
				]
			]
		],
		myOptions
	];

	allTests = Flatten[{emptyContainerTests, samplesAndContainersTests, emptyWellTests, nonOnPlateTests}];

	(* Replace any containers with their contents *)
	samples = Flatten[objects /. occupiedContainerToContentWithPositions, 1];

	(* If we only have one sample and were given a container without a list, delist our sample. *)
	(* This is so that Expandable\[Rule]True works when we have a secondary input. *)
	unlistedSamples = If[Length[samples] == 1 && MatchQ[myObject, ObjectP[]],
		First[samples],
		samples
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests -> If[MemberQ[output, Tests],
		(* Join all existing tests generated by helper functions with any additional tests *)
		Join[safeOptionTests, allTests],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result -> If[MemberQ[output, Result],
		(* Return the samples and the index-matched options*)
		If[MemberQ[Keys[Options[myFunction]], "Simulation"],

			(* if the function contains the simulation as the results we only return the sample and the expanded options *)
			{unlistedSamples, updatedOptions},

			(* if the function has not included the simulation yet, return {sample, expanded options, simulated packet as the cache} *)
			{unlistedSamples, updatedOptions, FlattenCachePackets[simulatedSamplePackets]}
		]
	];


	(* Build simulation *)
	simulationRule = Simulation -> If[MemberQ[output, Simulation],
		(* Return the samples and the index-matched options*)

		(* Update the simulation. *)
		Which[
			(* If there is a specified simulation and we are generating new simulation, update simulation here *)
			And[MatchQ[simulation, SimulationP], Length[Flatten[simulatedSamplePackets]] > 0], UpdateSimulation[simulation, Simulation[Flatten[simulatedSamplePackets]]],

			(* If there is no specified simulation but we are generating new simulation packets, update Simulation[] here *)
			Length[Flatten[simulatedSamplePackets]] > 0, UpdateSimulation[Simulation[], Simulation[Flatten[simulatedSamplePackets]]],

			(* If there is a new simulation packet specified, but we are not generating the simulation packet, just return the old simulation packet *)
			And[MatchQ[simulation, SimulationP], Length[Flatten[simulatedSamplePackets]] == 0], simulation,

			(* Catch all by return Nulls *)
			True, Null
		],

		Null
	];

	outputSpecification /. {testsRule, resultRule, simulationRule}

];


(* Invalid Input Overload - Handle the case that a Model[Container] is provided in PreparatoryPrimitives and cannot be the input of the Function *)
containerToSampleOptions[myFunction_Symbol,myObject:ListableP[ObjectP[{Object[Sample],Model[Sample],Object[Container],Model[Container]}]|{LocationPositionP,ObjectP[Object[Container]]}],myOptions:{(_Rule|_RuleDelayed)...},ops:OptionsPattern[]]:=Module[
	{listedOptions,objects,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,invalidContainerModel,emptyContainerTest,testsRule},

	(* Make sure we're working with a list of options and objects *)
	listedOptions=ToList[ops];
	objects=ToList[myObject];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[containerToSampleOptions,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[containerToSampleOptions,listedOptions,AutoCorrect->False],Null}
	];

	(* If the specified options don't match their patterns, return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[{$Failed,$Failed}]
	];

	(* Select the Model[Container] invalid input. *)
	invalidContainerModel=Cases[objects,ObjectP[Model[Container]],Infinity];

	If[MatchQ[invalidContainerModel,{}],
		(* Call the main overload if every input is valid *)
		containerToSampleOptions[myFunction,myObject,myOptions,ops],

		If[!gatherTests,
			(* Otherwise we certainly have Model[Container] that is provided from PreparatoryUnitOperations. This happens when a container is defined but no sample is transferred into the container. Error::EmptyContainers is a good message here and this will merge with the existing logic very well. *)
			Message[Error::EmptyContainers,invalidContainerModel];Return[{$Failed,$Failed}]
		]
	];

	(* make a test that matches the above message *)
	emptyContainerTest=If[!Lookup[safeOptions,EmptyContainers]&&gatherTests,
		Test["The defined container(s) contains samples on which the experiment can act.", MatchQ[invalidContainerModel, {}], True],
		{}
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests->If[gatherTests,
		(* Join all existing tests generated by helper functions with any additional tests *)
		Append[safeOptionTests,emptyContainerTest],
		Null
	];

	(* The only case that we will return here is that we are gathering tests. Otherwise it should have returned earlier with $Failed *)
	outputSpecification/.{testsRule}

];


(* ::Subsection::Closed:: *)
(*splitPrepOptions*)


(* ::Subsubsection::Closed:: *)
(*prepOptionSetP*)


(* a pattern to match the allowed symbols for prep option sets that can be split out by splitPrepOptions *)
prepOptionSetP=Alternatives[
	IncubatePrepOptions,MixPrepOptions,CentrifugePrepOptions,FilterPrepOptions,AliquotOptions,
	AliquotIncubateOptions,AliquotMixOptions,AliquotCentrifugeOptions,AliquotFilterOptions,IncubatePrepOptionsNew,CentrifugePrepOptionsNew,FilterPrepOptionsNew
];


(* ::Subsubsection::Closed:: *)
(*splitPrepOptions Options*)


DefineOptions[
	splitPrepOptions,
	Options:>{
		{PrepOptionSets->All,All|ListableP[prepOptionSetP],"The prep option set(s) that should be included in the prep list."}
	}
];


(* ::Subsubsection::Closed:: *)
(*splitPrepOptions*)


splitPrepOptions[myOptionsToSplit:{(_Rule|_RuleDelayed)...},myOptions:OptionsPattern[]]:=Module[
	{safeOptions,splitOptionsOption,optionSetsToSplit,optionNamesToSplit,prepOptions,experimentSpecificOptions,numberOfReplicates},

	(* default any unspecified or incorrectly-specified options (to this function itself); get PrepOptionSets option *)
	safeOptions=SafeOptions[splitPrepOptions, ToList[myOptions]];
	splitOptionsOption=Lookup[safeOptions,PrepOptionSets];

	(* determine which options sets should be split into the prep list *)
	optionSetsToSplit=If[MatchQ[splitOptionsOption,All],
		List@@prepOptionSetP,
		ToList[splitOptionsOption]
	];

	(* get all the names of the options we should split out, based on the option sets we are splitting out *)
	optionNamesToSplit=ToExpression[Flatten[Options/@optionSetsToSplit,1][[All,1]]];

	(* perform the actual splitting of the prep option names from the experiment options *)
	prepOptions=Normal@KeyTake[myOptionsToSplit,optionNamesToSplit];
	experimentSpecificOptions=Normal@KeyDrop[myOptionsToSplit,optionNamesToSplit];

	(* Get NumberOfReplicates. *)
	numberOfReplicates=Lookup[myOptionsToSplit,NumberOfReplicates,$Failed];

	(* If NumberOfReplicates is an option, return it in both sets. This is because the SP resolver AND experiment option resolver use this option. *)
	If[KeyExistsQ[myOptionsToSplit,NumberOfReplicates],
		{Append[prepOptions,NumberOfReplicates->numberOfReplicates],Append[experimentSpecificOptions,NumberOfReplicates->numberOfReplicates]},
		{prepOptions,experimentSpecificOptions}
	]
];


(* ::Subsection::Closed:: *)
(*simulateSamplePreparationPackets*)


Error::MissingDefineNames="The following prepared samples, `1`, were found in the inputs/options but were not defined using the PreparatoryUnitOperations option. In order to use prepared samples, please specify them using the PreparatoryUnitOperations option.";
Error::ConflictingPreparatoryUnitOperationsAndPrimitives="The PreparatoryUnitOperations option was set to `1` and the PreparatoryPrimitives option was set to `2`. Only one of these options can be set in an single experiment call. PreparatoryPrimitives is the older system that uses ExperimentSampleManipulation to prepare samples for the experiment. PreparatoryUnitOperations is the latest system (with more features) that uses ExperimentSamplePreparation to prepare samples for the experiment. It is recommended that users use the PreparatoryUnitOperations option since the PreparatoryPrimitives option will be deprecated in the future.";
Error::NoPreparatoryUnitOperationsWithItems="The following inputs are Items, `1`, but the PreparatoryUnitOperations option is set to `2` and the PreparatoryPrimitives option is set to `3`. Neither PreparatoryUnitOperations not PreparatoryPrimitives options can be used with Items. Please leave those options unspecified or run the experiment on Samples instead of Items.";

simulateSamplePreparationPacketsNew[myFunction_Symbol,mySamples:ListableP[ListableP[(ObjectP[{Object[Container],Object[Sample],Model[Sample],Object[Item]}]|_String|{LocationPositionP, _String|ObjectP[Object[Container]]}|Null)]],myExperimentOptions_List, myResolutionOptions:OptionsPattern[]]:=Module[
	{cache,samplePreparationQ,samplePreparationCache,defineNameLookup,optionDefinitions,optionSymbol,optionValue,optionDefinition,flattenedWidget,
		preparedQ,sampleDefineNames,missingSampleDefineNames,preparedSampleStrings,combinedMissingDefineNames,missingOptionDefineNames,
		preparedOptionsResult,labelRules, samplesByID,
		experimentOptionsByID, updatedSimulation, simulation, samplesWithPreparedSamples, optionsWithPreparedSamples, sampleManipulationQ,
		resolvedUnitOperations, samplePreparationResult, cacheCompatibilityModeQ, optionsNoSimOrCache},

	(* replace all Named objects to be referenced by ID *)
	{samplesByID, experimentOptionsByID} = sanitizeInputs[mySamples, myExperimentOptions];

	(* Lookup the cache. *)
	cache = Lookup[ToList[experimentOptionsByID], Cache, {}];
	simulation = Lookup[ToList[experimentOptionsByID], Simulation, Null];

	(* Are we being called from the old simulateSamplePreparationPackets function and doing SP? *)
	(* We will only be given this flag if our parent function thinks we're doing SP and wants a cache back. *)
	cacheCompatibilityModeQ = Lookup[ToList[myResolutionOptions], CacheCompatibilityMode, False];

	(* NOTE: This is to short circuit when we get called first from the containers function and next from the samples function. *)
	(* The only way for us to get passed a simulation is from the previous instance from this function since this option can only *)
	(* be specified from a direct experiment call (and not in the primitive framework). *)
	(* note that we're deleting the Simulation from the specified options because we're returning it separately and since the simulation can be huge, we don't need to have it twice *)
	If[MatchQ[simulation, SimulationP] && !MatchQ[cacheCompatibilityModeQ, True],
		Return[{samplesByID, DeleteCases[experimentOptionsByID, Simulation -> _], simulation}]
	];

	(* Get the option definitions for our function. *)
	optionDefinitions = OptionDefinition[myFunction];

	(* See if we were given the PreparatoryUnitOperations option in experimentOptionsByID and if so, if it's not Null. *)
	(* Existence of this option implies that we have to call the ExperimentSamplePreparation simulator first. *)
	(* NOTE: Also, if we are given a simulation, assume that we've already simulated out unit operations. This is because *)
	(* the container overload of ExperimentBLAH does the SP simulation, then passes it down to the sample overload of *)
	(* ExperimentBLAH which also calls this function and attempts to do SP simulation. We don't want to do SP simulation *)
	(* twice since that would be inaccurate. Additionally, PreparatoryUnitOperations are not allowed inside of UnitOperations *)
	(* in SP, so there's no reason why we should get a simulation passed down to us. *)
	samplePreparationQ = And[
		KeyExistsQ[experimentOptionsByID, PreparatoryUnitOperations],
		MatchQ[Lookup[experimentOptionsByID, PreparatoryUnitOperations], Except[Null|{}]],
		!MatchQ[simulation, SimulationP]
	];

	(* See if we were given the PreparatoryPrimitives option. *)
	(* NOTE: If we're given both the PreparatoryUnitOperations and PreparatoryPrimitives option, we will use PreparatoryUnitOperations *)
	(* but throw a hard error. *)
	sampleManipulationQ=And[
		KeyExistsQ[experimentOptionsByID,PreparatoryPrimitives],
		MatchQ[Lookup[experimentOptionsByID,PreparatoryPrimitives], Except[Null|{}]]
	];

	(* Throw an error if PreparatoryUnitOperations or PreparatoryPrimitives are specified for Object[Item] inputs *)
	If[
		And[
			MemberQ[samplesByID,ObjectP[Object[Item]]],
			Or[
				MatchQ[samplePreparationQ,True],
				MatchQ[sampleManipulationQ,True]
			]
		],
		Message[
			Error::NoPreparatoryUnitOperationsWithItems,
			Cases[samplesByID,ObjectP[Object[Item]]],
			Lookup[experimentOptionsByID,PreparatoryUnitOperations],
			Lookup[experimentOptionsByID,PreparatoryPrimitives]
		];
		Message[
			Error::InvalidOption,
			{PreparatoryUnitOperations,PreparatoryPrimitives}
		];
		(* Since we're going to immediately return $Failed in the experiment function, doesn't really matter what we return here. *)
		Which[
			MatchQ[simulation,SimulationP],
			Return[{samplesByID,experimentOptionsByID,simulation}],
			MatchQ[cacheCompatibilityModeQ,True],
			Return[{samplesByID,experimentOptionsByID,{}}],
			True,
			Return[{samplesByID,experimentOptionsByID,Simulation[]}]
		]
	];

	(* Throw an error if PreparatoryUnitOperations and PreparatoryPrimitives are both specified *)
	If[And[
		MatchQ[samplePreparationQ, True],
		MatchQ[sampleManipulationQ, True]
	],
		Message[
			Error::ConflictingPreparatoryUnitOperationsAndPrimitives,
			Lookup[experimentOptionsByID, PreparatoryUnitOperations],
			Lookup[experimentOptionsByID,PreparatoryPrimitives]
		];

		Message[
			Error::InvalidOption,
			{PreparatoryUnitOperations, PreparatoryPrimitives}
		];

		(* Since we're going to immediately return $Failed in the experiment function, doesn't really matter what we return here. *)
		Which[
			MatchQ[simulation, SimulationP],
			Return[{samplesByID, experimentOptionsByID, simulation}],
			MatchQ[cacheCompatibilityModeQ, True],
			Return[{samplesByID, experimentOptionsByID, {}}],
			True,
			Return[{samplesByID, experimentOptionsByID, Simulation[]}]
		]
	];

	(* If we are not doing any preparation, just check that we don't have any random strings and return the inputs, options, and cache as usual. *)
	(* This is similar to the define name checks below when we ARE doing simulation, but we don't have to worry about potentially valid inputs. *)
	(* The comments and caveats here are copied from down below. *)
	If[!MatchQ[samplePreparationQ,True] && !MatchQ[sampleManipulationQ,True],
		Module[{rawOptionDefineNames, rawSampleDefineNames, combinedRawMissingNames},
			(* Replace any options that can take prepared samples with their respective simulated objects. *)
			rawOptionDefineNames = Map[
				Function[{option},
					(* Seperate the option key from the value. *)
					optionSymbol = option[[1]];
					optionValue = option[[2]];

					(* If our option value isn't a string, don't bother. *)
					If[Length[Cases[ToList[optionValue], _String, Infinity]] == 0 || MatchQ[optionSymbol, PreparatoryUnitOperations],
						{},
						(* Our option is a string. It could be a prepared sample/container. *)

						(* Get the definition of this specific option. *)
						optionDefinition = FirstCase[optionDefinitions, KeyValuePattern["OptionSymbol" -> optionSymbol], <||>];

						(* Get the widget and change all associations into lists. Associations don't work with Cases[...]. *)
						flattenedWidget = Lookup[optionDefinition, "Widget", <||>] /. {Verbatim[Widget][Verbatim[Association][x__]] :> List[x]};

						(* See if it can be a prepared container or sample. *)
						preparedQ = Or @@ Cases[flattenedWidget, ((PreparedContainer | PreparedSample) -> x : _) :> x, Infinity];

						(* If it can be prepared and it's a string, we're dealing with a prepared sample/container. *)
						If[preparedQ,
							(* Get all of our strings that are NOT inside of an object or model head. *)
							(* We assume that the only way that there can be a define name is if it's inside of a list head (we ToList the option value so we catch the singleton case). *)
							(* We have to wrap an extra list to tell Cases[...] that we're not asking for the listable overload. *)
							(* TODO: This will not work if we have both strings and prepared samples/containers in a list together for an option value. *)
							(* We could solve this if we did a widget matching (the same code that we use to take resolved options from experiment functions and create a tree of widgets to
							give to the command builder front end). Then, we would know when strings match up to object widgets. However, that'd slow this down the code a bit, although I
							guess that we would only need to trigger the matching when there is both a string in the option value (in a list, not in an object or model head) and there is
							a prepared sample/container object widget for that option. When widget matching, we'd presumably skip over it if the pattern doesn't match since this is before
							safe options.*)
							DeleteCases[Cases[{ToList[optionValue]}, List[___, x_String, ___] :> x, Infinity],Alternatives@@Flatten[AllWells[NumberOfWells->384]]],
							(* Our option can't take prepared samples/containers. Just return the original option. *)
							{}
						]
					]
				],
				experimentOptionsByID
			];

			(* Replace any samples that are strings with their correct prepared samples. *)
			(* If we have a prepared sample in our sample list, find that prepared sample's object reference from the simulated cache. *)
			(* Note: We have to flatten because of pooling. *)
			rawSampleDefineNames = If[MemberQ[Flatten[ToList[samplesByID]], _String],
				(* Get all of the define names from our sample input. *)
				(* Note: We have to flatten because of pooling. *)
				Cases[Flatten[ToList[samplesByID]], Except[LocationPositionP,_String]],
				(* There are no prepared samples in our sample list. *)
				{}
			];


			(* Get all of the define names that we're missing. *)
			combinedRawMissingNames = Flatten[{rawOptionDefineNames, rawSampleDefineNames}];

			(* If there are missing define names in the samples or options, throw an error. *)
			If[Length[combinedRawMissingNames] > 0,
				Message[Error::MissingDefineNames, combinedRawMissingNames];

				(* Throw a specific input message if we have missing input define names. *)
				If[Length[Flatten[rawSampleDefineNames]] > 0,
					Message[Error::InvalidInput, Flatten[rawSampleDefineNames]];
				];

				(* Throw a specific option message if we have missing input define names. *)
				If[Length[Flatten[rawOptionDefineNames]] > 0,
					Message[Error::InvalidOption, Flatten[rawOptionDefineNames]];
				];
			];
		];

		(* NOTE: The old function used to return a blank simulation, even if there was no sample preparation going on so *)
		(* we need to mimic this functionality. *)
		Which[
			MatchQ[simulation, SimulationP],
			Return[{samplesByID, experimentOptionsByID, simulation}],
			MatchQ[cacheCompatibilityModeQ, True],
			Return[{samplesByID, experimentOptionsByID, cache}],
			True,
			Return[{samplesByID, experimentOptionsByID, Simulation[]}]
		];
	];

	(* Perform our simulation. *)
	samplePreparationResult = Check[
		(* Are we doing SP or SM? Note that we set different variables for each one here. *)
		If[MatchQ[samplePreparationQ, True],
			{resolvedUnitOperations, updatedSimulation} = ExperimentSamplePreparation[
				Lookup[experimentOptionsByID, PreparatoryUnitOperations],
				Cache -> cache,
				Simulation -> simulation,
				Output -> {Input, Simulation},
				(* NOTE: If we're being called from the command builder, we want to show the non-finalized version of the options. *)
				PreviewFinalizedUnitOperations->If[MatchQ[ECL`AppHelpers`$CommandBuilder, True],
					False,
					True
				]
			],
			{samplePreparationCache,defineNameLookup}=simulateSampleManipulation[
				Lookup[experimentOptionsByID,PreparatoryPrimitives],
				Cache->cache
			]
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Return early if there was a problem with the user's given manipulations. *)
	If[MatchQ[samplePreparationResult, $Failed],
		Which[
			MatchQ[simulation, SimulationP],
			Return[{samplesByID, experimentOptionsByID, simulation}],
			MatchQ[cacheCompatibilityModeQ, True],
			Return[{samplesByID, experimentOptionsByID, cache}],
			True,
			Return[{samplesByID, experimentOptionsByID, Simulation[]}]
		];
	];

	(* Make sure that we have the required fields that we need. *)
	samplePreparationCache=If[MatchQ[samplePreparationQ, True],
		{},
		Module[{samplePreparationCacheWithAdditionalFields, defineObjectPositions, defineObjectPackets, newDefineObjectPackets},

			samplePreparationCacheWithAdditionalFields=Function[{packet},
				If[MatchQ[Lookup[packet, Simulated, False], False],
					packet,
					Module[{requiredFields, additionalFields},
						(* Switch on packet type to get our required fields. *)
						requiredFields=Switch[Lookup[packet,Object],
							ObjectP[Object[Sample]],
							InternalUpload`Private`$RequiredObjectSampleFields,
							ObjectP[Object[Container]],
							InternalUpload`Private`$RequiredObjectContainerFields,
							ObjectP[Model[Sample]],
							InternalUpload`Private`$RequiredModelSampleFields,
							_,
							{}
						];

						(* Get the additional fields to add to the packet. *)
						additionalFields=Function[{field},
							If[KeyExistsQ[packet,field],
								Nothing,
								(* Otherwise, add this field as a Null or {}. *)
								(* Note: Sometimes SM simulation doesn't give us the Type key. Go from object to type. *)
								Switch[Lookup[Quiet[LookupTypeDefinition[Lookup[packet,Object][Type],field]]/.{$Failed->{}},Format,Null],
									Single,
									field->Null,
									Multiple,
									field->{},
									Null, (* The field may not exist in this type. *)
									Nothing,
									_, (* This should never happen, but just in case someone is downloading from a Computable field. *)
									field->Null
								]
							]
						]/@requiredFields;

						(* If our packet doesn't have the Type key, add it. *)
						If[MatchQ[Lookup[packet,Type,Null],Null],
							Append[Append[packet,additionalFields],Type->Lookup[packet,Object][Type]],
							Append[packet,additionalFields]
						]
					]
				]
			]/@samplePreparationCache;

			(* For each of our defined lookups, add the key DefineName to the corresponding object's packet. *)

			(* Lookup the packets for our objects that are defined. *)
			(* Some of our resulting define names may not be simulated (take an existing sample and give it a name). Thus, if something's not in the cache, don't add the Simulated key. *)
			(* Note that these non-simulated defined samples will be contained in the defineNameLookup that is returned. *)
			defineObjectPositions=FirstPosition[samplePreparationCache,KeyValuePattern[Object->#],Null]&/@defineNameLookup[[All,2]];
			defineObjectPackets=samplePreparationCache[[Flatten[defineObjectPositions]/.{Null->Nothing}]];

			(* Add the DefineName key to our packets. *)
			newDefineObjectPackets=MapThread[If[MatchQ[#2,Null],Nothing,Append[samplePreparationCache[[#2]],DefineName->#1]]&,{defineNameLookup[[All,1]],Flatten[defineObjectPositions]}];

			(* Drop out old packets and add our new packets with the new key. *)
			Join[Delete[samplePreparationCache,defineObjectPositions/.{Null->Nothing}],newDefineObjectPackets]
		]
	];

	(* pull out the labels from the simulation *)
	labelRules = If[MatchQ[samplePreparationQ, True],
		Lookup[First[updatedSimulation], Labels],
		defineNameLookup
	];

	(* Replace any options that can take prepared samples with their respective simulated objects. *)
	preparedOptionsResult = Map[
		Function[{option},
			(* Seperate the option key from the value. *)
			optionSymbol = option[[1]];
			optionValue = option[[2]];

			(* If our option value isn't a string, don't bother. *)
			If[Length[Cases[ToList[optionValue], _String, Infinity]] == 0 || MatchQ[optionSymbol, PreparatoryUnitOperations|PreparatoryPrimitives],
				{option, {}},
				(* Our option is a string. It could be a prepared sample/container. *)

				(* Get the definition of this specific option. *)
				optionDefinition = FirstCase[optionDefinitions, KeyValuePattern["OptionSymbol" -> optionSymbol]];

				(* Get the widget and change all associations into lists. Associations don't work with Cases[...]. *)
				flattenedWidget = Lookup[optionDefinition, "Widget", <||>] /. {Verbatim[Widget][Verbatim[Association][x__]] :> List[x]};

				(* See if it can be a prepared container or sample. *)
				preparedQ = Or @@ Cases[flattenedWidget, ((PreparedContainer | PreparedSample) -> x : _) :> x, Infinity];

				(* If it can be prepared and it's a string, we're dealing with a prepared sample/container. *)
				If[preparedQ,
					(* Get all of our strings that are NOT inside of an object or model head. *)
					(* We assume that the only way that there can be a define name is if it's inside of a list head (we ToList the option value so we catch the singleton case). *)
					(* We have to wrap an extra list to tell Cases[...] that we're not asking for the listable overload. *)
					(* TODO: This will not work if we have both strings and prepared samples/containers in a list together for an option value. *)
					(* We could solve this if we did a widget matching (the same code that we use to take resolved options from experiment functions and create a tree of widgets to
					give to the command builder front end). Then, we would know when strings match up to object widgets. However, that'd slow this down the code a bit, although I
					guess that we would only need to trigger the matching when there is both a string in the option value (in a list, not in an object or model head) and there is
					a prepared sample/container object widget for that option. When widget matching, we'd presumably skip over it if the pattern doesn't match since this is before
					safe options.*)
					preparedSampleStrings = DeleteCases[Cases[{ToList[optionValue]}, List[___, x_String, ___] :> x, Infinity],Alternatives@@Flatten[AllWells[NumberOfWells->384]]];

					(* Replace our defined names with our simulated objects. *)
					{
						optionSymbol -> (optionValue /. labelRules),
						Complement[preparedSampleStrings,labelRules[[All,1]]]
					},
					(* Our option can't take prepared samples/containers. Just return the original option. *)
					{
						option,
						{}
					}
				]
			]
		],
		experimentOptionsByID
	];

	(* Transpose out result. *)
	{optionsWithPreparedSamples, missingOptionDefineNames} = If[Length[preparedOptionsResult] > 0,
		Transpose[preparedOptionsResult],
		{{}, {}}
	];

	(* Replace our options with our resolves SP unit operations, if we're doing SP. *)
	optionsWithPreparedSamples=If[MatchQ[samplePreparationQ, True],
		ReplaceRule[
			optionsWithPreparedSamples,
			PreparatoryUnitOperations->resolvedUnitOperations
		],
		optionsWithPreparedSamples
	];

	(* Replace any samples that are strings with their correct prepared samples. *)
	(* If we have a prepared sample in our sample list, find that prepared sample's object reference from the simulated cache. *)
	(* Note: We have to flatten because of pooling. *)
	{samplesWithPreparedSamples, missingSampleDefineNames} = If[MemberQ[Flatten[ToList[samplesByID]], _String] && (samplePreparationQ || sampleManipulationQ),
		(* Get all of the define names from our sample input. *)
		(* Note: We have to flatten because of pooling. *)
		sampleDefineNames = Cases[Flatten[ToList[samplesByID]],Except[LocationPositionP,_String]];

		(* Return our result. *)
		{
			(* Replace our defined names with the object references. *)
			samplesByID /. labelRules,
			(* Are there define names not in our lookup table? *)
			DeleteCases[sampleDefineNames, Alternatives @@ Keys[labelRules]]
		},
		(* There are no prepared samples in our sample list. *)
		{samplesByID, {}}
	];

	(* Get all of the define names that we're missing. *)
	combinedMissingDefineNames = Flatten[{missingSampleDefineNames, missingOptionDefineNames}];

	(* If there are missing define names in the samples or options, throw an error. *)
	If[Length[combinedMissingDefineNames] > 0,
		Message[Error::MissingDefineNames, combinedMissingDefineNames];

		(* Throw a specific input message if we have missing input define names. *)
		If[Length[Flatten[missingSampleDefineNames]] > 0,
			Message[Error::InvalidInput, Flatten[missingSampleDefineNames]];
		];

		(* Throw a specific option message if we have missing input define names. *)
		If[Length[Flatten[missingOptionDefineNames]] > 0,
			Message[Error::InvalidOption, Flatten[missingOptionDefineNames]];
		];
	];

	(* take the Simulation and Cache options out of optionsWithPreparedSamples; we only want to return these as part of the third argument (which we're already doing); don't need them in the second argument *)
	optionsNoSimOrCache = DeleteCases[optionsWithPreparedSamples, Simulation|Cache -> _];

	(* Return our new input, options, and cache. *)
	{
		samplesWithPreparedSamples,
		optionsNoSimOrCache,
		Which[
			MatchQ[samplePreparationQ, True],
			UpdateSimulation[If[NullQ[simulation], Simulation[], simulation], updatedSimulation],
			MatchQ[cacheCompatibilityModeQ, True],
			FlattenCachePackets[{samplePreparationCache, cache}],
			True,
			UpdateSimulation[
				UpdateSimulation[
					If[NullQ[simulation], Simulation[], simulation],
					Simulation[samplePreparationCache]
				],
				Simulation[Labels->defineNameLookup]
			]
		]
	}
];

(* backwards compatible with existing code that doesn't use simulation but ideally you'd just call simulateSamplePreparationPackets directly *)
simulateSamplePreparationPackets[myFunction_Symbol,mySamples:ListableP[ListableP[(ObjectP[{Object[Container],Object[Sample],Model[Sample],Object[Item]}]|_String|{LocationPositionP, _String|ObjectP[Object[Container]]}|Null)]],myExperimentOptions_List]:=Module[
	{
		mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,simulation,newCache,objects,simulatedQ,objectIsSimulatedLookup,
		newReverseCompatibleCache,nonSimulatedObjects,additionalCacheFields,sampleManipulationQ
	},

	(* NOTE: If we have a simulated object already in our cache, assume that we've already called this function and just *)
	(* return. This is because we don't want to simulate SP twice. Also note that there is a catch inside of *)
	(* simulateSamplePreparationPacketsNew which does the same thing, but that looks for simulations vs this looks for packets *)
	(* that have Simulated->True. *)
	(* note that we're deleting the Cache from the specified options because we're returning it separately and since the cache can be huge, we don't need to have it twice *)
	If[MemberQ[Lookup[myExperimentOptions, Cache, {}], KeyValuePattern[Simulated->True]],
		Return[{mySamples, DeleteCases[myExperimentOptions, Cache -> _], Lookup[myExperimentOptions, Cache, {}]}];
	];

	(* Are we doing SM? If so, tell the subfunction that we want the cache back. *)
	sampleManipulationQ=KeyExistsQ[myExperimentOptions,PreparatoryPrimitives]&&MatchQ[Lookup[myExperimentOptions,PreparatoryPrimitives],{SampleManipulationP..}];

	(* Call the core function. *)
	{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, simulation} = If[MatchQ[sampleManipulationQ, True],
		simulateSamplePreparationPacketsNew[myFunction, mySamples, myExperimentOptions, CacheCompatibilityMode->True],
		simulateSamplePreparationPacketsNew[myFunction, mySamples, myExperimentOptions]
	];

	(* If there is no simulation, then there is nothing that was simulated, return early. *)
	If[MatchQ[simulation, Null],
		Return[{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, Lookup[myExperimentOptions, Cache, {}]}];
	];

	(* pull out the new cache from the simulation object, unless we're in cache compatibility mode and got a cache back. *)
	newCache = If[MatchQ[sampleManipulationQ, False],
		Lookup[First[simulation], Packets],
		simulation
	];

	(* Add the Simulated and DefineName key to our cache for reverse compatibility with the old version of the framework *)
	(* that is expecting the result from SM. *)
	{objects, simulatedQ} = If[MatchQ[sampleManipulationQ, False],
		Module[{allObjects},
			allObjects=If[Length[newCache]==0,
				{},
				DeleteDuplicates[Lookup[newCache, Object]]
			];

			{
				allObjects,
				MapThread[
					(MatchQ[#1, False] && MatchQ[#2, True]&),
					{
						DatabaseMemberQ[allObjects],
						DatabaseMemberQ[allObjects, Simulation->simulation]
					}
				]
			}
		],
		Module[{allObjects, simulatedObjectsFastSet},
			allObjects=If[Length[newCache]==0,
				{},
				DeleteDuplicates[Lookup[newCache, Object]]
			];

			simulatedObjectsFastSet=Association[(Lookup[#, Object]->Null&)/@Cases[newCache, KeyValuePattern[Simulated->True]]];

			{
				allObjects,
				(KeyExistsQ[simulatedObjectsFastSet, #]&)/@allObjects
			}
		]
	];
	objectIsSimulatedLookup=Association@(Rule@@@Transpose[{objects, simulatedQ}]);

	(* Add the Simulated and DefineName keys for reverse compatibility in code that relies on it. *)
	newReverseCompatibleCache=Map[
		Function[{packet},
			Which[
				Lookup[objectIsSimulatedLookup, Lookup[packet, Object], False],
					Module[{packetWithCacheFields},
						(* Fill out all fields in the type with Null/{} if they are not simulated. Otherwise, we will get a *)
						(* download cache error and download will try to reach out to the database. *)
						packetWithCacheFields=Join[
							packet,
							Association@Map[
								Function[{field},
									Which[
										KeyExistsQ[packet, field],
											Nothing,
										MatchQ[Quiet[Lookup[LookupTypeDefinition[Lookup[packet,Type],field],Format]],Multiple],
											field->{},
										True,
											field->Null
									]
								],
								Fields[Lookup[packet, Type], Output->Short]
							]
						];

						(* If we're doing SM, we already have all the fields we need from that short circuit. Otherwise, we need to add fields *)
						(* so that the SP packets look like they're coming from SM. *)
						If[MatchQ[sampleManipulationQ, True],
							packetWithCacheFields,
							Append[
								packetWithCacheFields,
								{
									Simulated->True,
									DefineName->Lookup[Reverse/@Lookup[simulation[[1]], Labels], Lookup[packet, Object], Null],
									Name->Which[
										!MatchQ[Lookup[packet, Name, Null], Null],
										Lookup[packet, Name],
										MatchQ[label, _String],
										"Simulation of "<>label,
										True,
										"Simulated Object "<>ToString[Lookup[packet, Object]]
									]
								}
							]
						]
					],
				(* NOTE: Don't include empty backlink packets since they don't really buy us anything for reverse compatibility except for *)
				(* false cache miss errors. *)
				AssociationMatchQ[packet, <|Object->ObjectP[Model[]], Objects->_List|>],
					Nothing,
				True,
					packet
			]
		],
		newCache
	];

	(* Download all fields from non-simulated objects to make sure that we don't get cache misses. *)
	(* NOTE: The more efficient thing here is to use the new simulation system since it only stores the object diff. *)
	nonSimulatedObjects=Download[PickList[objects, simulatedQ, False], Object];
	additionalCacheFields=Module[{allObjects,fieldSpec},
		(* include $PersonID just to be safe and have it in our cache for UploadProtocol *)
		allObjects = ToList/@nonSimulatedObjects;
		fieldSpec = Map[Function[type,
			Switch[type,
				(* we don't need the Objects field that could be giant *)
				TypeP[{Model[Container],Model[Instrument],Model[Item],Object[LaboratoryNotebook],Model[Maintenance],Model[Package],Model[Part],Model[Qualification],Model[Sample],Model[Sensor],Model[User]}],
				{Packet@@DeleteCases[noComputableFieldsList[type],Objects|Protocols]},

				(* Smaples field for Products is not relevant but can be *)
				TypeP[Object[Product]],
				{Packet@@DeleteCases[noComputableFieldsList[type],Samples]},

				TypeP[Object[User]],
				{Packet@@DeleteCases[
					noComputableFieldsList[type],
					Alternatives@@{PrintStickersLog,CommandCenterActivityHistory,ProtocolsAuthored,SimulationsAuthored,
						ProtocolsArchived,FavoriteObjects,LastSelectedObjects,TransactionsCreated,TransactionsArchived}]
				},

				_,
				{Packet@@noComputableFieldsList[type]}
			]
		],Download[Flatten@allObjects, Type]];
			{noComputableFieldsList[#]}&/@Download[Flatten@allObjects, Type];

		Flatten@Quiet[
			Download[
				allObjects,
				fieldSpec
			],
			{Download::FieldDoesntExist}
		]];

	{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, FlattenCachePackets[{newReverseCompatibleCache, additionalCacheFields}]}
];

(* ::Subsection::Closed:: *)
(*simulateSamplesResourcePackets*)


(* ::Subsubsection::Closed:: *)
(*Main Function*)


(* Takes in (1) myFunction (the symbol of the experiment function), (2) mySamples (the inputted samples into the experiment function), (3) resolved options, (4) cache. *)
(* Returns simulated samples (replaced in-situ with our non-simulated samples) and a new simulated cache. *)
simulateSamplesResourcePackets[myFunction_Symbol,mySamples:{(NonSelfContainedSampleP|_String)..},myResolvedOptions_List,myOptions:OptionsPattern[]]:=Module[
	{cache,simulation,combinedSimulationAndCache,pooledQ,samplePreparationOptions,mapThreadFriendlyOptions,incubateVolume,incubateContainer,centrifugeVolume,centrifugeContainer,filterVolume,
		filterContainer,aliquotAssayVolume,aliquotContainer,masterSwitches,volumes,containers,optionsList,samplePreparationInformation},

	(* Lookup the cache. *)
	cache=Lookup[ToList[myOptions],Cache,{}];
	simulation=Lookup[ToList[myOptions],Simulation,Null];

	(* Combine the simulation and cache to do lookups from. *)
	combinedSimulationAndCache=Which[
		MatchQ[simulation, SimulationP] && !MatchQ[Lookup[simulation[[1]], Updated], True],
		FlattenCachePackets[{Lookup[UpdateSimulation[Simulation[], simulation][[1]], Packets], cache}],
		MatchQ[simulation, SimulationP],
		FlattenCachePackets[{Lookup[simulation[[1]], Packets], cache}],
		True,
		cache
	];

	(* See if we have a pooling function. *)
	(* All pooling functions have the first input marked as pooled in their Usage. *)
	pooledQ=Lookup[First[Lookup[Usage[myFunction],"Input"]],"NestedIndexMatching"];

	(* Pooling functions have to have their aliquot simulation stripped out. *)
	samplePreparationOptions=If[pooledQ,
		(* This function only cares about the first three stages of sample preparation (Incubate,Filter,Centrifuge). *)
		(* Strip out any options that we don't need. This is important because we could have a pooled function in which options may be index-matched to pools, messing up mapThreadOptions. *)
		(* As noted earlier, we don't need the Aliquot options, but it's also important to note that the Aliquot options can be pooled for pooled functions, which will also mess us up. *)
		First[splitPrepOptions[myResolvedOptions,PrepOptionSets->{IncubatePrepOptionsNew,CentrifugePrepOptionsNew,FilterPrepOptionsNew}]],
		myResolvedOptions
	];

	(* -- Simulate the other part of sample preparation -- *)
	(* Get the MapThread friendly version of our function's options. *)
	(* if we have no options then just map thread an empty association *)
	mapThreadFriendlyOptions=If[MatchQ[samplePreparationOptions, {}],
		ConstantArray[<||>, Length[mySamples]],
		OptionsHandling`Private`mapThreadOptions[myFunction,samplePreparationOptions]
	];

	(* For each sample, get the latest {volume, container}. If the sample isn't being manipulated at all by sample preparation, return Null. *)
	samplePreparationInformation=MapThread[
		(* Lookup the starting volume of our samples. *)
		Function[{sample,indexMatchingOptions},
			(* Go through each of the sample prep steps (if they exist) and keep track of the most recent volume and container of the sample. *)
			{incubateVolume, incubateContainer}=If[!MatchQ[myFunction,ExperimentIncubate]&&KeyExistsQ[myResolvedOptions,IncubateAliquot],
				(* Get the IncubateAliquot and IncubateAliquotContainer. *)
				If[MatchQ[Lookup[indexMatchingOptions,IncubateAliquot,Null],Null]||MatchQ[Lookup[indexMatchingOptions,IncubateAliquotContainer,Null],Null],
					{Null,Null},
					{Lookup[indexMatchingOptions,IncubateAliquot,Null],Lookup[indexMatchingOptions,IncubateAliquotContainer,Null]}
				],
				(* Incubation sample prep is not supported by this function. *)
				{Null,Null}
			];

			(* Go through each of the sample prep steps (if they exist) and keep track of the most recent volume and container of the sample. *)
			{centrifugeVolume, centrifugeContainer}=If[!MatchQ[myFunction,ExperimentCentrifuge]&&KeyExistsQ[myResolvedOptions,CentrifugeAliquot],
				(* Get the CentrifugeAliquot and CentrifugeAliquotContainer. *)
				If[MatchQ[Lookup[indexMatchingOptions,CentrifugeAliquot,Null],Null]||MatchQ[Lookup[indexMatchingOptions,CentrifugeAliquotContainer,Null],Null],
					{incubateVolume, incubateContainer},
					{Lookup[indexMatchingOptions,CentrifugeAliquot,Null],Lookup[indexMatchingOptions,CentrifugeAliquotContainer,Null]}
				],
				(* Centrifuge sample prep is not supported by this function. *)
				{incubateVolume, incubateContainer}
			];

			(* Go through each of the sample prep steps (if they exist) and keep track of the most recent volume and container of the sample. *)
			{filterVolume, filterContainer}=If[!MatchQ[myFunction,ExperimentFilter]&&KeyExistsQ[myResolvedOptions,Filtration],
				(* Get the FilterAliquot and FilterAliquotContainer. *)
				If[MatchQ[Lookup[indexMatchingOptions,Filtration,False],Null|False]||MatchQ[Lookup[indexMatchingOptions,FilterContainerOut,Null],Null],
					{centrifugeVolume, centrifugeContainer},
					(* If we have a Null volume, lookup the volume of our sample to start with, we always filter the whole sample. *)
					If[MatchQ[centrifugeVolume, VolumeP],
						{centrifugeVolume,Lookup[indexMatchingOptions,FilterContainerOut,Null]},
						{Lookup[fetchPacketFromCache[sample, combinedSimulationAndCache], Volume],Lookup[indexMatchingOptions,FilterContainerOut,Null]}
					]
				],
				(* Filter sample prep is not supported by this function. *)
				{centrifugeVolume, centrifugeContainer}
			];

			(* Go through each of the sample prep steps (if they exist) and keep track of the most recent volume and container of the sample. *)
			{aliquotAssayVolume, aliquotContainer}=If[!MatchQ[myFunction,ExperimentAliquot]&&KeyExistsQ[myResolvedOptions,Aliquot],
				(* Get the AssayVolume and AliquotContainer. *)
				If[MatchQ[Lookup[indexMatchingOptions,AssayVolume,Null],Null]||MatchQ[Lookup[indexMatchingOptions,AliquotContainer,Null],Null],
					{filterVolume, filterContainer},
					{Lookup[indexMatchingOptions,AssayVolume,Null],Lookup[indexMatchingOptions,AliquotContainer,Null]}
				],
				(* Aliquot sample prep is not supported by this function. *)
				{filterVolume, filterContainer}
			];

			(* If we got to the end and got {Null,Null}, that means that our sample isn't being touched at all by sample prep. *)
			(* Return {master switch, volume, container} for each sample. *)
			If[MatchQ[{aliquotAssayVolume, aliquotContainer},{Null,Null}],
				{False,aliquotAssayVolume,aliquotContainer},
				{True,aliquotAssayVolume,aliquotContainer}
			]
		],
		{mySamples,mapThreadFriendlyOptions}
	];

	(* Transpose our result. *)
	{masterSwitches, volumes, containers}=Transpose[samplePreparationInformation];

	(* Prepare a list of options to pass to simulate our samples. *)
	optionsList={
		MasterSwitch->masterSwitches,
		Volumes->volumes,
		Containers->containers,

		(* NOTE: This makes it such that we get a more accurate simulation back with the correct Position. *)
		If[KeyExistsQ[samplePreparationOptions, DestinationWell],
			DestinationWell->Lookup[mapThreadFriendlyOptions, DestinationWell],
			Nothing
		]
	};

	(* Simulate our samples. *)
	(* Note: We are not throwing messages here so the simulation stage doesn't have to be 100% correct (since the user will never see it). *)
	simulateSamplePreparation[mySamples,optionsList,MasterSwitch,Volumes,Containers,"after Sample Preparation",Cache->combinedSimulationAndCache]
];


(* ::Subsubsection::Closed:: *)
(*NestedIndexMatching Overload*)


(* Takes in (1) myFunction (the symbol of the experiment function), (2) mySamples (the inputted samples into the experiment function), (3) resolved options, (4) cache. *)
(* Returns simulated samples (replaced in-situ with our non-simulated samples) and a new simulated cache. *)
simulateSamplesResourcePackets[myFunction_Symbol,mySamples:{ListableP[(NonSelfContainedSampleP|_String)]..},myResolvedOptions_List,myOptions:OptionsPattern[]]:=Module[
	{flattenedSamples,uuidShell,optionDefinitions,flatOptions,optionSymbol,optionValue,optionDefinition,singletonPattern,aliquotOptions,sanitizedOptions,simulatedSamples,
	flattenedOptionValue,simulatedCache,uuidToSimulatedSample},

	(* Flatten our samples. *)
	flattenedSamples=Flatten[mySamples];

	(* Take each of our options and flatten their values. *)
	uuidShell=mySamples/.{(NonSelfContainedSampleP|_String):>CreateUUID[]};

	(* Get our option definitions. *)
	optionDefinitions=OptionDefinition[myFunction];

	(* Flatten each of our option if it is pooled. *)
	flatOptions=Function[{option},
		(* Get the option name and value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Get the definition of our option. *)
		optionDefinition=FirstCase[optionDefinitions,KeyValuePattern["OptionSymbol"->optionSymbol]];

		(* Get the singleton pattern of our option. *)
		singletonPattern=Lookup[optionDefinition,"SingletonPattern",Null];

		(* If our option is pooled, we have to flatten it. *)
		If[Lookup[optionDefinition,"NestedIndexMatching",False],
			(* Our option is pooled. If an element of our list doesn't match the singleton, then it must be a pool. Flatten it. *)
			flattenedOptionValue=(
				If[!MatchQ[#,ReleaseHold[singletonPattern]],
					Sequence@@#,
					#
				]
			&)/@optionValue;

			(* There are possible ambiguities between pooled and singleton options. If the length of our option value still doesn't match the length of our inputs, flatten again. *)
			If[Length[flattenedOptionValue]!=Length[flattenedSamples],
				optionSymbol->Flatten[flattenedOptionValue],
				optionSymbol->flattenedOptionValue
			],
			(* Our option is not pooled. Nothing to do. *)
			option
		]
	]/@myResolvedOptions;

	(* Get our aliquot option symbols (from the aliquot stage). *)
	aliquotOptions=ToExpression/@Options[AliquotOptions][[All,1]];

	(* Remove the Aliquot option. This is because we do not simulate an aliquot with pooled inputs. *)
	sanitizedOptions=flatOptions/.{(Alternatives@@aliquotOptions->_)->Nothing};

	(* Call our core function. *)
	{simulatedSamples,simulatedCache}=simulateSamplesResourcePackets[myFunction,Flatten[mySamples],sanitizedOptions,myOptions];

	(* Create replace rules of UUIDs to simulated samples to put them back into the proper uuid pooled shell. *)
	uuidToSimulatedSample=MapThread[Rule,{Flatten[uuidShell],simulatedSamples}];

	(* Put the simulated samples back in the shell. Also return the simulated cache. *)
	{uuidShell/.uuidToSimulatedSample,simulatedCache}
];


(* ::Subsubsection::Closed:: *)
(*Container Overload*)


(* Returns {samples, simulatedCache}. *)
simulateSamplesResourcePackets[myFunction_Symbol,mySamples:{(NonSelfContainedSampleP|SelfContainedSampleP|ObjectP[Object[Container]]|_String)..},myResolvedOptions_List,myOptions:OptionsPattern[]]:=Module[
	{cache,optionDefinition,numberOfReplicates,nonSelfContainedPositions,containerPositions,containerSingleSamplePositions,
		validInputPositions,invalidInputs,validInputs,validOptions,optionSymbol,optionValue,indexMatchingQ,
		simulatedSamples,simulatedCache,invalidInputPositions,foldedSamples,allSamples
	},

	(* Lookup our cache. *)
	cache=Lookup[ToList[myOptions],Cache,{}];

	(* Get the option definition for our function. *)
	(* We just use HPLC for this because HPLC has all sample prep options. Should probably change this later. *)
	optionDefinition=OptionDefinition[myFunction];

	(* Get the NumberOfReplicates option. *)
	numberOfReplicates=Lookup[myResolvedOptions,NumberOfReplicates,Null]/.{Automatic|Null->1};

	(* Get the positions of the self-contained samples, non-self-contained samples, and containers. *)
	nonSelfContainedPositions=Flatten[Position[mySamples,NonSelfContainedSampleP,{1}]];
	containerPositions=Flatten[Position[mySamples,ObjectP[Object[Container]],{1}]];

	(* Get the positions of the containers that only have one sample in them. *)
	containerSingleSamplePositions=(
		If[Length[Lookup[fetchPacketFromCache[mySamples[[#]],cache],Contents]]==1,
			#,
			Nothing
		]
			&)/@containerPositions;

	(* Get the positions of the valid inputs. *)
	validInputPositions=Sort[Flatten[{nonSelfContainedPositions,containerSingleSamplePositions}]];

	(* Note: We do not check for invalid set options here because we already threw messages about invalid set options back in resolveSamplePrepOptions. *)

	(* Filter down our inputs and options to only the valid input samples. *)
	validInputs=(
		(* If we have a valid container, we need to get the single sample out of it. *)
		If[MatchQ[mySamples[[#]],ObjectP[Object[Container]]],
			First[Lookup[fetchPacketFromCache[mySamples[[#]],cache],Contents][[All,2]]],
			mySamples[[#]]
		]
			&)/@validInputPositions;

	(* Get the positions of the invalid inputs. *)
	invalidInputPositions=Complement[Range[Length[mySamples]],validInputPositions];

	(* Filter down our options so that we only have the index-matching values to our valid inputs. *)
	validOptions=Function[{option},
		(* Split out the option symbol and the option value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Lookup our option definition to see if it's index-matching. *)
		indexMatchingQ=MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->optionSymbol]],"IndexMatchingInput"],"experiment samples"];

		(* Are we dealing with the AliquotContainer, AliquotSampleLabel, or DestinationWell option? *)
		If[MatchQ[optionSymbol,AliquotContainer|DestinationWell|AliquotSampleLabel],
			(* AliquotContainer and DestinationWell are index-matched to either Length[mySamples] or Length[mySamples]*NumberOfReplicates. *)
			If[Length[Lookup[myResolvedOptions,optionSymbol]]==Length[mySamples],
				(* Index-matched to mySamples, regularly filter. *)
				optionSymbol->optionValue[[validInputPositions]],
				(* Otherwise, collapse NumberOfReplicates expanded version and then filter. *)
				optionSymbol->optionValue[[;;;;numberOfReplicates]][[validInputPositions]]
			],
			(* Otherwise, look to see if our option is index-matching. *)
			If[indexMatchingQ,
				optionSymbol->optionValue[[validInputPositions]],
				option
			]
		]
	]/@myResolvedOptions;

	(* Call our main overload. *)
	{simulatedSamples,simulatedCache}=If[Length[validInputs]>0,
		(* If we are passing a PreparatoryUnitOperations option down, then we will get an additional return value. *)
		simulateSamplesResourcePackets[myFunction,validInputs,validOptions,myOptions],
		{{},cache}
	];

	(* Get the positions of the invalid inputs. *)
	invalidInputPositions=Complement[Range[Length[mySamples]],validInputPositions];
	invalidInputs=mySamples[[invalidInputPositions]];

	(* Thread our simulated and invalid samples (samples that we're not passing through simulation) together. *)
	(* Start off with simulatedSamples, and insert the invalid samples in the correct position with a Fold. *)
	foldedSamples=Fold[(Insert[#1,First[#2],Last[#2]]&),simulatedSamples,Transpose[{invalidInputs,invalidInputPositions}]];

	(* Some of our samples may have been given to us as containers (and we mapped them to their single sample when passing them to the simulation stage). *)
	(* If something was originally a container, keep it as a container. *)
	allSamples=MapThread[
		Function[{originalObject,newObject},
			If[MatchQ[originalObject,ObjectP[Object[Container]]]&&!MatchQ[newObject,ObjectP[Object[Container]]],
				(* Our original object was a container and our new object isn't a container. *)
				(* Do a cache lookup and keep it as a container. *)
				Lookup[fetchPacketFromCache[newObject,simulatedCache],Container]/.{link_Link:>Download[link, Object]},
				(* Otherwise, we're okay. *)
				newObject
			]
		],
		{mySamples,foldedSamples}
	];

	(* Return our threaded options. *)
	{allSamples,simulatedCache}
];

(* New Overload that returns a simulation. *)
(* TODO: The internals of simulateSamplesResourcePackets still use cache balling instead of proper simulation and should be rewritten. *)
simulateSamplesResourcePacketsNew[myFunction_Symbol,mySamples_List,myResolvedOptions_List,myOptions:OptionsPattern[]]:=Module[
	{simulatedSamples,simulatedCache,existingSimulation, allSamplePrepBools},

	(* short circuit if we aren't incubating, filtering, centrifuging, or aliquoting *)
	allSamplePrepBools = Switch[myFunction,
		ExperimentIncubate | ExperimentMix, Flatten[{Null, Lookup[myResolvedOptions, {Centrifuge, Filter, Aliquot}, Null]}],
		ExperimentCentrifuge, Flatten[{Null, Lookup[myResolvedOptions, {Incubate, Filter, Aliquot}, Null]}],
		ExperimentFilter, Flatten[{Null, Lookup[myResolvedOptions, {Incubate, Centrifuge, Aliquot}, Null]}],
		ExperimentAliquot, Flatten[{Null, Lookup[myResolvedOptions, {Incubate, Centrifuge, Filter}, Null]}]
	];

	(* Lookup the simulation option. *)
	existingSimulation = Lookup[ToList[myOptions], Simulation, Simulation[]];

	(* Call the old function; short circuit if we didn't do any sample prep *)
	{simulatedSamples, simulatedCache} = If[MatchQ[allSamplePrepBools, {(False | Null)..}],
		{mySamples, Lookup[First[existingSimulation], Packets]},
		simulateSamplesResourcePackets[myFunction, mySamples, myResolvedOptions, myOptions]
	];


	(* Convert the cache to a simulation. *)
	If[MatchQ[existingSimulation, SimulationP],
		{simulatedSamples, UpdateSimulation[existingSimulation, Simulation[simulatedCache]]},
		{simulatedSamples, Simulation[simulatedCache]}
	]
];

(* ::Subsection::Closed:: *)
(*resolvePooledSamplePrepOptions*)


(* This function simply flattens our pooled options and resolves the sample prep pretending that pools aren't a thing. *)
resolvePooledSamplePrepOptions[myFunction_,mySamples_List,mySamplePrepOptions_List,myOptions:OptionsPattern[resolveSamplePrepOptions]]:=Module[
	{safeOps,outputSpecification,output,uuidShell,flatUUIDs,flattenedSamples,optionDefinitions,flattenedOptions,optionSymbol,optionValue,optionDefinition,singletonPattern,flattenedOptionValue,
		simulatedSamples,resolvedOptions,simulatedCache,repooledSamples,repooledOptions,numberOfReplicates,samplePrepTests},

	(* get the safe options *)
	safeOps = SafeOptions[resolveSamplePrepOptions, ToList[myOptions]];

	(* get the output specification/output and cache options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Replace the objects in our function with UUIDs. *)
	uuidShell=mySamples/.{ObjectP[]:>CreateUUID[]};

	(* Flatten our UUIDs. *)
	flatUUIDs=Flatten[uuidShell];

	(* Flatten our input samples and options. *)
	flattenedSamples=Flatten[mySamples];

	(* Get our option definitions. *)
	optionDefinitions=OverwriteAliquotOptionDefinition[myFunction,OptionDefinition[myFunction]];

	(* Flatten each of our option if it is pooled. *)
	flattenedOptions=Function[{option},
		(* Get the option name and value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Get the definition of our option. *)
		optionDefinition=FirstCase[optionDefinitions,KeyValuePattern["OptionSymbol"->optionSymbol]];

		(* Get the singleton pattern of our option. *)
		singletonPattern=Lookup[optionDefinition,"SingletonPattern",Null];

		(* If our option is pooled, we have to flatten it. *)
		If[Lookup[optionDefinition,"NestedIndexMatching",False],
			(* Our option is pooled. If an element of our list doesn't match the singleton, then it must be a pool. Flatten it. *)
			flattenedOptionValue=(
				If[!MatchQ[#,ReleaseHold[singletonPattern]],
					Sequence@@#,
					#
				]
			&)/@optionValue;

			(* There are possible ambiguities between pooled and singleton options. If the length of our option value still doesn't match the length of our inputs, flatten again. *)
			If[Length[flattenedOptionValue]!=Length[flattenedSamples],
				optionSymbol->Flatten[flattenedOptionValue],
				optionSymbol->flattenedOptionValue
			],
			(* Our option is not pooled. Nothing to do. *)
			option
		]
	]/@mySamplePrepOptions;

	(* Pass our flattened samples and options to the main resolver. *)
	{{simulatedSamples, resolvedOptions, simulatedCache},samplePrepTests}=If[MemberQ[output,Tests],
		resolveSamplePrepOptions[myFunction,flattenedSamples,flattenedOptions,myOptions],
		{resolveSamplePrepOptions[myFunction,flattenedSamples,flattenedOptions,myOptions],{}}
	];

	(* Get our samples and options back into the correct pooled format. *)
	repooledSamples=uuidShell/.MapThread[Rule,{flatUUIDs,simulatedSamples}];
	repooledOptions=Function[{option},
		(* Get the option name and value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Get the definition of our option. *)
		optionDefinition=FirstCase[optionDefinitions,KeyValuePattern["OptionSymbol"->optionSymbol]];

		(* Get the number of replicates option. *)
		numberOfReplicates=Lookup[mySamplePrepOptions,NumberOfReplicates]/.{Null->1};

		(* If our option is pooled, we have to re-pool it. *)
		If[Lookup[optionDefinition,"NestedIndexMatching",False],
			(* Does the length of our option match the length of our input? If not, we have to collapse our replicates. *)
			If[Length[optionValue]==Length[simulatedSamples],
				optionSymbol->uuidShell/.MapThread[Rule,{flatUUIDs,optionValue}],
				optionSymbol->uuidShell/.MapThread[Rule,{flatUUIDs,optionValue[[;;;;numberOfReplicates]]}]
			],
			(* Our option is not pooled. Nothing to do. *)
			option
		]
	]/@resolvedOptions;

	(* Return our repooled samples and options. *)
	outputSpecification/.{
		Result->{repooledSamples, repooledOptions, simulatedCache},
		Tests->samplePrepTests
	}
];


(* ::Subsection::Closed:: *)
(*resolveSamplePrepOptions*)


(* ::Subsubsection::Closed:: *)
(*simulateSamplePreparation*)


(* Helper function that takes in (1) working samples, (2) resolved sample prep options (for a given step of the sample prep chain, ex. Incubate), (3) related master switch, volume, and container out symbols, (4) cache (via myOptions). *)
(* Returns simulated samples (replaced in-situ with our non-simulated samples) and a new simulated cache. *)
simulateSamplePreparation[mySamples:{ObjectP[Object[Sample]]...},samplePrepOptions_List,masterSwitch_Symbol,amountOption_Symbol,containersOut_Symbol,simulationStage_String,myOptions:OptionsPattern[]]:=Module[
	{cache,simulation,combinedCacheAndSimulation,consolidateAliquots,masterSwitchBooleans,manipulatedSamples,manipulatedSampleAmounts,manipulatedContainersOut,manipulatedDestinationWell,containersOutObjects,manipulatedSampleInformation,uncachedObjects,extraPackets,cacheBall,sampleGroupings,
		simulatedCache,containerModel,samples,overrideAmounts,overrideAmountOptions,containerModelPacket,allowedPositions,pickedPositions,
		simulatedSamples,nonSimulatedSamples,simulatedSamplesInOrder,simulatedSamplePositions,simulationResult,returnedCache,indices,simulatedIndices,container,destinationWells,correctDestinationWell},

	(* Lookup the given cache. *)
	cache=Lookup[ToList[myOptions],Cache,{}];
	simulation=Lookup[ToList[myOptions],Simulation,Null];

	(* Combine the cache and simulation. *)
	(* TODO: This is temporary and will be removed during our simulation re-write. *)
	combinedCacheAndSimulation=Which[
		MatchQ[simulation, SimulationP] && !MatchQ[Lookup[simulation[[1]], Updated], True],
		FlattenCachePackets[{Lookup[UpdateSimulation[Simulation[], simulation][[1]], Packets], cache}],
		MatchQ[simulation, SimulationP],
		FlattenCachePackets[{Lookup[simulation[[1]], Packets], cache}],
		True,
		cache
	];

	(* See if we are consolidating aliquots. *)
	consolidateAliquots=Lookup[samplePrepOptions,ConsolidateAliquots,False]/.{Null|Automatic->False};

	(* Get the master switch option and filter out samples that were not processed (ex. Aliquot option). *)
	masterSwitchBooleans=ToList[Lookup[samplePrepOptions,masterSwitch]]/.{Automatic->False};

	(* Get the samples that were manipulated. *)
	manipulatedSamples=PickList[ToList[mySamples],masterSwitchBooleans];

	(* Get the amounts of the samples that should change (or should not if amountOption is Null). *)
	manipulatedSampleAmounts=If[MatchQ[amountOption,Null],
		(* Keep the amounts of the samples the same. *)
		ConstantArray[Null,Length[manipulatedSamples]],
		(* We should change the amounts of our samples. *)
		(* Default to 0 if we were given a Null in this list (we shouldn't have been). *)
		PickList[ToList[Lookup[samplePrepOptions,amountOption]],masterSwitchBooleans]/.{Null|Automatic->0}
	];

	(* Get the ContainersOut and DestinationWell of our samples that are being manipulated. *)
	manipulatedContainersOut=PickList[ToList[Lookup[samplePrepOptions,containersOut]],masterSwitchBooleans]/.{Automatic->Null};

	manipulatedDestinationWell=PickList[ToList[Lookup[samplePrepOptions,DestinationWell,ConstantArray[Null,Length[masterSwitchBooleans]]]],masterSwitchBooleans]/.{Automatic->Null};

	(* Get only the objects of the containers out. *)
	containersOutObjects=Cases[manipulatedContainersOut,ObjectP[{Object[Container],Model[Container]}],Infinity];

	(* Thread together all of our aliquot information. *)
	(* We also transpose together an index so that we know how to re-arrange them into the correct order of the input list at the end. *)
	manipulatedSampleInformation=Transpose[{manipulatedSamples,manipulatedSampleAmounts,manipulatedContainersOut,manipulatedDestinationWell,Range[Length[manipulatedSamples]]}];

	(* Determine if we have any samples/containers which haven't already been downloaded *)
	uncachedObjects=Map[
		If[MatchQ[fetchPacketFromCache[#,combinedCacheAndSimulation],<||>],
			#,
			Nothing
		]&,
		Flatten[{mySamples,containersOutObjects}]
	];

	(* Download anything not currently in our cache *)
	(* Note that if we tried to download objects which were already in our cache, the computable fields in the cache would get evaluated *)
	extraPackets=Quiet[Download[uncachedObjects,Cache->combinedCacheAndSimulation]];

	(* Create a cache ball. *)
	cacheBall=Flatten[{combinedCacheAndSimulation,extraPackets}];

	(* manipulatedSampleInformation is in the format {{sampleGrouping,sampleVolume,containerOut,index}..}. *)
	(* Group samples by their container out. *)
	sampleGroupings=Values[GroupBy[manipulatedSampleInformation,(#[[3;;4]]&)]];

	(* Loop over each of our sample groupings, generating simulated samples as we go. *)
	(* In each loop, gather {simulatedSamples, simulatedCache, simulatedIndices}. *)
	simulationResult=Function[{sampleGroup},
		(* sampleGroup is in the form {{sample,overrideVolume,containerOut}..}. *)

		(* Get the container we're going to simulate. *)
		container=First[sampleGroup][[3]][[2]];

		destinationWells=sampleGroup[[All,4]];

		(* Get the model of this container. *)
		containerModel=If[MatchQ[container,ObjectP[Model[Container]]],
			container,
			Download[Lookup[fetchPacketFromCache[container,cacheBall],Model],Object]
		];

		(* Get our samples. *)
		samples=sampleGroup[[All,1]];

		(* Get our override amounts. *)
		overrideAmounts=sampleGroup[[All,2]];

		(* Lookup our indices. *)
		indices=sampleGroup[[All,5]];

		(* Get the container model's packet from our cache. *)
		containerModelPacket=fetchPacketFromCache[containerModel,cacheBall];

		(* Get the name of the positions that we're going place our sample(s) in. *)
		(* If we can't find the positions from the packet, assume 96 deep-well plate, this is the safest thing to fall back on (vessels will have A1 picked). *)
		allowedPositions=If[MatchQ[containerModelPacket,_Association]&&!MatchQ[containerModelPacket,Null|<||>|$Failed]&&KeyExistsQ[containerModelPacket,Positions]&&!MatchQ[Lookup[containerModelPacket, Positions], {}],
			Name/.Lookup[containerModelPacket,Positions],
			{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12","B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12","C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12","E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12","H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12"}
		];

		(* Look to see if we are consolidating aliquots. *)
		If[consolidateAliquots||Length[allowedPositions]==1,
			(* We are consolidating aliquots. *)
			(* Create override options. This is simply the summation of all of the amounts. *)
			overrideAmountOptions=If[MatchQ[overrideAmounts,{Null...}],
				Nothing,
				(* Should we override Volume, Mass, or Count? Default to Volume. *)
				Switch[Total[overrideAmounts/.{Null->0}],
					VolumeP,
					{Volume->Total[overrideAmounts/.{Null->0}]},
					MassP,
					{Mass->Total[overrideAmounts/.{Null->0}]},
					UnitsP[Unit]|_Integer|_Real,
					{Count->Total[overrideAmounts/.{Null->0}]},
					_,
					{Volume->Total[overrideAmounts/.{Null->0}]}
				]
			];

			correctDestinationWell=If[NullQ[First[destinationWells]],
				First[allowedPositions],
				First[destinationWells]
			];

			(* Create our simulated samples and containers. *)
			returnedCache=SimulateSample[{First[samples]},simulationStage,{correctDestinationWell},containerModel,overrideAmountOptions,Cache->cacheBall];

			(* Return our result. *)
			(* Our simulated objects are all of the objects in the first position of our cache. We expand out this sample to match the multiple consolidate aliquot samples we were given.*)
			{Flatten[ConstantArray[Lookup[returnedCache[[1]],Object],Length[samples]]],returnedCache,indices},

			(* ELSE: We are not consolidating aliquots. *)
			(* Create override options, if necessary. *)
			overrideAmountOptions=If[MatchQ[overrideAmounts,{Null...}],
				Nothing,
				Switch[#,
					VolumeP,
					{Volume->#},
					MassP,
					{Mass->#},
					UnitsP[Unit]|_Integer|_Real,
					{Count->#},
					_,
					{Volume->#}
				]&/@overrideAmounts
			];

			(* Pick the first positions in the container for our samples. *)
			pickedPositions=ReplacePart[
				destinationWells,
				Module[{nullPositions},
					nullPositions=Position[destinationWells, Except[_String], Heads->False];

					Rule@@@Transpose[{nullPositions, Take[allowedPositions, Length[nullPositions]]}]
				]
			];

			(* Create our simulated samples and containers. *)
			returnedCache=SimulateSample[samples,simulationStage,pickedPositions,containerModel,overrideAmountOptions,Cache->cacheBall];

			(* Return our result. *)
			(* Our simulated objects are all of the objects in the first position of our cache. *)
			{Lookup[returnedCache[[1]],Object],returnedCache,indices}
		]
	]/@sampleGroupings;

	(* Transpose if we got a result back. *)
	{simulatedSamples,simulatedCache,simulatedIndices}=If[MatchQ[simulationResult,{}],
		{{},{},{}},
		(* Transpose and flatten each of simulatedSamples and simulatedCache. *)
		Flatten/@Transpose[simulationResult]
	];

	(* Some of our samples don't need to be simulated. Combine our non-simulated and simulated samples. *)
	(* Get the non-simulated samples. *)
	nonSimulatedSamples=PickList[mySamples,masterSwitchBooleans,False];

	(* Get the simulated samples (in the order they are in mySamples). *)
	simulatedSamplesInOrder=simulatedSamples[[Ordering@simulatedIndices]];

	(* Get the positions of the simulated samples. *)
	simulatedSamplePositions=Position[masterSwitchBooleans,True];

	(* Interleave the simulated and non-simulated samples in order. *)
	samples=Fold[(Insert[#1,First[#2],Last[#2]]&),nonSimulatedSamples,Transpose[{simulatedSamplesInOrder,simulatedSamplePositions}]];

	{samples,Flatten[{simulatedCache,cache}]}
];


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[
	resolveSamplePrepOptions,
	Options:>{
		CacheOption,
		SimulationOption,
		OutputOption,
		{
			OptionName->Debug,
			Default->False,
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if debug messages should be printed upon execution of this function.",
			Category->"Hidden"
		},
		{
			OptionName->EnableSamplePreparation,
			Default->True,
			AllowNull->False,
			Widget -> Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the sample preperation options for this function should be resolved. This option is set to False when resolveSamplePrepOptions is called within a sample prep experiment to avoid an infinite loop.",
			Category->"Hidden"
		}
	}
];


(* ::Subsubsection::Closed:: *)
(*Main Function*)


Warning::resolveSamplePrepOptionsNoCache="resolveSamplePrepOptions needs to be passed cache in order to function correctly. Please pass down packets for all of the containers and samples that you are using.";
Error::IncubateIncorrectlySpecified="The Incubate option for sample(s), `1`, is set to False, but the option(s), `2`, are set. Please do not set these options or set the Incubate option to True.";
Error::CentrifugeIncorrectlySpecified="The Centrifuge option for sample(s), `1`, is set to False, but the option(s), `2`, are set. Please do not set these options or set the Centrifuge option to True.";
Error::FiltrationIncorrectlySpecified="The Filtration option for sample(s), `1`, is set to False, but the option(s), `2`, are set. Please do not set these options or set the Filtration option to True.";

(* This main overload just takes in NonSelfContainedSamples (samples in containers that are clearly compatible with sample prep). *)
resolveSamplePrepOptions[myFunction_,mySamples:{ListableP[NonSelfContainedSampleP|_String]..},myExperimentOptions_List,myOptions:OptionsPattern[resolveSamplePrepOptions]]:=Module[
	{safeOptions,pooledQ,listedSamples,listedOptions,uuidShell,flatUUIDs,flattenedSamples,flattenedOptions,cache,simulation,debug,outputSpecification,output,gatherTests,
	messages,aliquotAmount,optionDefinitions,incubationRequestedQ,incubateSimulatedSamples,incubateSimulatedCache,resolvedIncubateOptions,centrifugeRequestedQ,
	centrifugeSimulatedSamples,centrifugeSimulatedCache,resolvedCentrifugeOptions,filterRequestedQ,filterSimulatedSamples,filterSimulatedCache,resolvedFilterOptions,
	aliquotContainerSpecifiedQ,aliquotSimulatedSamples,aliquotSimulatedCache,resolvedAliquotOptions,resolvedSamplePrepOptions,incubateTests,centrifugeTests,filterTests,expandedSamplePrepOptions,
	resultRule,testRule,numberOfReplicates,invalidInputs,singletonPattern,flattenedOptionValue,reformatedSamples,reformatedOptions,aliquotOptions,repooledSamples,repooledOptions,
	indexMatchingAliquotOptions, functionOptions, reformatedOptionsMinusMisfits},

	(* Get the safe options of this function. *)
	safeOptions=SafeOptions[resolveSamplePrepOptions,ToList[myOptions]];

	(* See if our sample list is pooled. *)
	pooledQ=MemberQ[mySamples,_List];

	(* Get our option definitions. *)
	optionDefinitions=OptionDefinition[myFunction];

	(* If our sample list was pooled, our options were also pooled. Flatten both. *)
	{listedSamples,listedOptions}=If[pooledQ,
		(* Replace the objects in our function with UUIDs. *)
		uuidShell=mySamples/.{ObjectP[]:>CreateUUID[]};

		(* Flatten our UUIDs. *)
		flatUUIDs=Flatten[uuidShell];

		(* Flatten our input samples and options. *)
		flattenedSamples=Flatten[mySamples];

		(* Flatten each of our option if it is pooled. *)
		flattenedOptions=Function[{option},
			(* Get the option name and value. *)
			optionSymbol=option[[1]];
			optionValue=option[[2]];

			(* Get the definition of our option. *)
			optionDefinition=FirstCase[optionDefinitions,KeyValuePattern["OptionSymbol"->optionSymbol]];

			(* Get the singleton pattern of our option. *)
			singletonPattern=Lookup[optionDefinition,"SingletonPattern",Null];

			(* If our option is pooled, we have to flatten it. *)
			If[Lookup[optionDefinition,"NestedIndexMatching",False],
				(* Our option is pooled. If an element of our list doesn't match the singleton, then it must be a pool. Flatten it. *)
				flattenedOptionValue=(
					If[!MatchQ[#,ReleaseHold[singletonPattern]],
						Sequence@@#,
						#
					]
				&)/@optionValue;

				(* There are possible ambiguities between pooled and singleton options. If the length of our option value still doesn't match the length of our inputs, flatten again. *)
				If[Length[flattenedOptionValue]!=Length[flattenedSamples],
					optionSymbol->Flatten[flattenedOptionValue],
					optionSymbol->flattenedOptionValue
				],
				(* Our option is not pooled. Nothing to do. *)
				option
			]
		]/@myExperimentOptions;

		{flattenedSamples,flattenedOptions},
		(* Not pooled. *)
		{ToList[mySamples],myExperimentOptions}
	];

	(* Lookup our given cache and our Simulation.  Note that if Null, replace with Simulation. *)
	cache=Lookup[safeOptions,Cache,{}];
	simulation = If[NullQ[Lookup[safeOptions,Simulation]],
		Simulation[],
		Lookup[safeOptions,Simulation, Simulation[]]
	];

	(* Throw a warning (for the developer) if no cache is passed. *)
	If[MatchQ[$PersonID,ObjectP[Object[User,Emerald,Developer]]]&&MatchQ[cache,{}],
		Message[Warning::resolveSamplePrepOptionsNoCache];
	];

	(* Lookup our debug option. *)
	debug=Lookup[safeOptions,Debug,False];

	(* Get the output specification. *)
	outputSpecification=Lookup[safeOptions,Output];
	output=ToList[outputSpecification];

	(* figure out if we are gathering tests or not *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Get the AliquotAmount option. *)
	aliquotAmount=Lookup[myExperimentOptions,AliquotAmount];

	(* Get the NumberOfReplicates option. *)
	numberOfReplicates=Lookup[myExperimentOptions,NumberOfReplicates,Null]/.{Automatic|Null->1};

	(* Keep track of invalid inputs. *)
	invalidInputs={};

	(* Is Incubation supported by this parent function and has the user requested incubation? (Incubation is disabled in ExperimentIncubate). *)
	incubationRequestedQ=And[
		(* Incubation is supported by this function. *)
		!MatchQ[myFunction,ExperimentIncubate],
		(* And either: *)
		Or[
			(* The user has requested Incubation manually: *)
			MemberQ[ToList[Lookup[listedOptions,Incubate,False]],True],
			(* Or one of the incubation related options is not Automatic or Null. *)
			Or@@(
				MemberQ[ToList[Lookup[listedOptions,Symbol[#],Null]],Except[Automatic|Null|False|{Automatic,Automatic}]]
			&)/@Options[IncubatePrepOptionsNew][[All,1]]
		],
		(* Sample prep isn't set to False. *)
		Lookup[safeOptions,EnableSamplePreparation,True]
	];

	(* Resolve the incubation part of our sample prep workflow: *)
	{incubateSimulatedSamples,incubateSimulatedCache,resolvedIncubateOptions,incubateTests}=If[incubationRequestedQ,
		Module[{rawOptions,mappedOptions,incubateBooleans,mapThreadFriendlyOptions,masterSwitchBooleans,incorrectlySetOptions,
			filteredSamples,resolvedOptions,tests,filteredOptions,automaticCompatibleOptions,simulatedSamples,simulatedCache,expandedResolvedOptions,
			unmappedOptions,samplePrepOptions,threadedOptions,finalOptions,falseBooleanPositions,nonSimulatedSamples,allSamples},

			(* -- MAP OUR SAMPLE PREP OPTIONS INTO REGULAR EXPERIMENT OPTIONS -- *)
			(* Get our options that are related to Incubation. *)
			rawOptions=First[splitPrepOptions[listedOptions,PrepOptionSets->IncubatePrepOptionsNew]]/.{(NumberOfReplicates->_):>Nothing};

			(* Map our sample prep options to the ExperimentIncubate option set. *)
			(* All option symbols are the same except for the following. Also remove the Incubate boolean. *)
			mappedOptions=Replace[rawOptions,{IncubationTemperature->Temperature,IncubationTime->Time,MaxIncubationTime->MaxTime,IncubationInstrument->Instrument,IncubateAliquotContainer->AliquotContainer,IncubateAliquotDestinationWell->DestinationWell,IncubateAliquot->AliquotAmount,(Incubate->_):>Nothing},2];

			(* -- FIGURE OUT WHICH SAMPLES ARE BEING MANIPULATED -- *)
			(* Expand the incubate booleans we received. *)
			incubateBooleans=If[MatchQ[Lookup[rawOptions,Incubate],_List],
				Lookup[rawOptions,Incubate],
				ConstantArray[Lookup[rawOptions,Incubate],Length[listedSamples]]
			];

			(* Get a MapThread friendly version of options. *)
			(* Use the rawMappedOptions here since this is only used to figure out the masterSwitchBooleans. *)
			mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentIncubate,mappedOptions];

			(* Figure out if each of our samples is being incubated. A sample is being incubated if the Incubate option is set to True or if one of the Incubation related options is not Null|Automatic. *)
			masterSwitchBooleans=MapThread[
				Function[{boolean,incubateOptions},
					Or[
						TrueQ[boolean],
						MemberQ[Values[incubateOptions],Except[Automatic|Null|False|{Automatic,Automatic}]]
					]
				],
				{incubateBooleans,mapThreadFriendlyOptions}
			];

			(* If any of our booleans are incorrectly turned off, throw a message. *)
			incorrectlySetOptions=MapThread[
				Function[{boolean,incubateOptions,sample},
					If[MatchQ[boolean,False]&&MemberQ[Values[incubateOptions],Except[Automatic|Null|False|{Automatic,Automatic}]],
						{sample,Cases[Normal[incubateOptions],(x_->Except[Automatic|Null|False|{Automatic,Automatic}]):>x]/.{Temperature->IncubationTemperature,Time->IncubationTime,MaxTime->MaxIncubationTime,Instrument->IncubationInstrument,AliquotContainer->IncubateAliquotContainer,DestinationWell->IncubateAliquotDestinationWell,AliquotAmount->IncubateAliquot}},
						Nothing
					]
				],
				{incubateBooleans,mapThreadFriendlyOptions,listedSamples}
			];

			(* Keep track of invalid inputs. *)
			invalidInputs=Append[invalidInputs,incorrectlySetOptions[[All,1]]];

			(* If there are incorrectly set options, throw a message. *)
			If[Length[incorrectlySetOptions]>0,
				Message[Error::IncubateIncorrectlySpecified,ObjectToString[incorrectlySetOptions[[All,1]]],ObjectToString[DeleteDuplicates[Flatten[incorrectlySetOptions[[All,2]]]]]];
			];

			(* Filter our samples that are going to be manipulated. *)
			filteredSamples=PickList[listedSamples,masterSwitchBooleans];

			(* Get the option information for our function. *)
			optionDefinition=OptionDefinition[ExperimentIncubate];

			(* Filter our options so that they index-match to filteredSamples. *)
			filteredOptions=Function[{option},
				(* If this option is index-matching to "experiment samples", filter it. Otherwise, don't. *)
				If[MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->First[option]]],"IndexMatchingInput",Null],"experiment samples"]||MatchQ[First[option],AliquotContainer|DestinationWell|AliquotSampleLabel],
					First[option]->PickList[Last[option],masterSwitchBooleans],
					option
				]
			]/@mappedOptions;

			(* For each of our options, we have to make sure that the standalone function can take Automatic as a value. If not, set it to the Default. *)
			automaticCompatibleOptions=Function[{option},
				(* Does this option take Automatic as as value? *)
				If[MatchQ[Automatic,ReleaseHold[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->First[option]]],"Pattern",Null]]],
					(* It does, no compatibility changes needed. *)
					option,
					(* It does not. Map Automatic to the option default. *)
					option/.{Automatic->ReleaseHold[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->First[option]]],"Default",Null]]}
				]
			]/@filteredOptions;

			If[debug,
				Echo["Calling Incubate Resolver..."];
			];

			(* -- RESOLVE OPTIONS AND SIMULATE SAMPLES -- *)
			(* Call the resolver. Pass EnableSamplePreparation\[Rule]False to indicate that the resolver should not deal with sample preperation (otherwise we end up in an infinite loop). *)
			{resolvedOptions,tests}=Quiet[
				If[gatherTests,
					ExperimentIncubate[filteredSamples,Flatten[{automaticCompatibleOptions,EnableSamplePreparation->False,Cache->cache,Simulation->simulation,Output->{Options,Tests}}]],
					{ExperimentIncubate[filteredSamples,Flatten[{automaticCompatibleOptions,EnableSamplePreparation->False,Cache->cache,Simulation->simulation, Output->Options}]],{}}
				],
				{
					Error::SamplesMarkedForDisposal,
					Error::DiscardedSamples
				}
			];

			If[debug,
				Echo[resolvedOptions,"Incubate resolved options"];
			];

			(* Expand our resolved option set. *)
			expandedResolvedOptions=Last[ExpandIndexMatchedInputs[ExperimentIncubate,{filteredSamples},resolvedOptions,Messages->False]];

			If[debug,
				Echo["Starting incubate simulation..."];
			];

			(* Get our simulated samples and simulated cache. *)
			{simulatedSamples,simulatedCache}=simulateSamplePreparation[filteredSamples,expandedResolvedOptions,Aliquot,AssayVolume,AliquotContainer,"after Incubation",Cache->cache,Simulation->simulation];

			If[debug,
				Echo["Finished incubate simulation..."];
			];

			(* -- THREAD OUR OPTIONS BACK INTO THE CORRECT FORMAT -- *)
			(* Map our option set back: *)
			unmappedOptions=Replace[expandedResolvedOptions,{Temperature->IncubationTemperature,Time->IncubationTime,MaxTime->MaxIncubationTime,Instrument->IncubationInstrument,AliquotContainer->IncubateAliquotContainer,DestinationWell->IncubateAliquotDestinationWell,AliquotAmount->IncubateAliquot},2];

			(* Only allow options that are part of Incubate sample prep (Incubate has a bunch of miscellaneous options like Cache, Upload, etc.) *)
			samplePrepOptions=(
				If[MemberQ[Options[IncubatePrepOptionsNew][[All,1]],ToString[First[#]]],
					#,
					Nothing
				]
					&)/@unmappedOptions;

			(* Get the positions of the False booleans in masterSwitchBooleans. *)
			falseBooleanPositions=Position[masterSwitchBooleans,False];

			(* If a sample is not being manipulated, insert a Null for the option. *)
			threadedOptions=Function[{option},
				(* Insert Nulls where ever samples are not being manipulated, unless we are dealing with the Mix option. *)
				(* We do Mix\[Rule]False so that it shows up in the command builder (isn't hidden by the Null checkbox). *)
				If[MatchQ[First[option],Mix],
					First[option]->Fold[(Insert[#1,False,#2]&),Last[option],falseBooleanPositions],
					First[option]->Fold[(Insert[#1,Null,#2]&),Last[option],falseBooleanPositions]
				]
			]/@samplePrepOptions;

			(* Add our master switches back to our options. *)
			finalOptions=Append[threadedOptions,Incubate->masterSwitchBooleans];

			(* Get our non-simulated samples. *)
			nonSimulatedSamples=PickList[listedSamples,masterSwitchBooleans,False];

			(* Combine our simulated and non-simulated samples. *)
			(* Start off with simulatedSamples, and insert the non-simulated samples in the correct position with a Fold. *)
			allSamples=Fold[(Insert[#1,First[#2],Last[#2]]&),simulatedSamples,Transpose[{nonSimulatedSamples,falseBooleanPositions}]];

			(* Look at the Aliquot related options and simulate our samples. *)
			{allSamples,simulatedCache,finalOptions,tests}
		],
		(* ELSE: Incubation options are not supported by this function or the user hasn't requested for incubation. *)
		Module[{resolvedOptions},
			(* Does this function have Incubation sample prep? *)
			resolvedOptions=If[!MatchQ[myFunction,ExperimentIncubate],
				(* Yes, set any incubation rules we were given to Null. *)
				Join[
					{Incubate->ConstantArray[False,Length[listedSamples]]},
					(If[MatchQ[#,"Incubate"],
						Nothing,
						Symbol[#]->ConstantArray[Null,Length[listedSamples]]
					]&)/@Options[IncubatePrepOptionsNew][[All,1]]
				],
				(* No, don't give back any resolved options. *)
				{}
			];

			{listedSamples,cache,resolvedOptions,{}}
		]
	];

	(* Is Centrifugation supported by this parent function and has the user requested centrifugation? (Centrifuge is disabled in ExperimentCentrifuge). *)
	centrifugeRequestedQ=And[
		(* Centrifugation is supported by this function. *)
		!MatchQ[myFunction,ExperimentCentrifuge],
		(* And either: *)
		Or[
			(* The user has requested Centrifugation manually: *)
			MemberQ[ToList[Lookup[listedOptions,Centrifuge,False]],True],
			(* Or one of the centrifugation related options is not Automatic or Null. *)
			Or@@(
				MemberQ[ToList[Lookup[listedOptions,Symbol[#],Null]],Except[Automatic|Null|False|{Automatic,Automatic}]]
			&)/@Options[CentrifugePrepOptionsNew][[All,1]]
		],
		(* Sample prep isn't set to False. *)
		Lookup[safeOptions,EnableSamplePreparation,True]
	];

	(* Resolve the centrifugation part of our sample prep workflow: *)
	{centrifugeSimulatedSamples,centrifugeSimulatedCache,resolvedCentrifugeOptions,centrifugeTests}=If[centrifugeRequestedQ,
		Module[{rawOptions,mappedOptions,centrifugeBooleans,
			mapThreadFriendlyOptions,masterSwitchBooleans,filteredSamples,resolvedOptions,tests,filteredOptions,automaticCompatibleOptions,simulatedSamples,simulatedCache,
			expandedResolvedOptions,unmappedOptions,samplePrepOptions,threadedOptions,falseBooleanPositions,nonSimulatedSamples,allSamples,finalOptions,incorrectlySetOptions},

			(* -- MAP OUR SAMPLE PREP OPTIONS INTO REGULAR EXPERIMENT OPTIONS -- *)
			(* Get our options that are related to centrifugation. *)
			rawOptions=First[splitPrepOptions[listedOptions,PrepOptionSets->CentrifugePrepOptionsNew]]/.{(NumberOfReplicates->_):>Nothing};

			(* Map our sample prep options to the ExperimentIncubate option set. *)
			(* All option symbols are the same except for the following. Also remove the Centrifuge boolean and CentrifugeAliquotContainer option. *)
			mappedOptions=Replace[rawOptions,{CentrifugeIntensity->Intensity,CentrifugeTime->Time,CentrifugeTemperature->Temperature,CentrifugeInstrument->Instrument,CentrifugeAliquotContainer->AliquotContainer,CentrifugeAliquotDestinationWell->DestinationWell,CentrifugeAliquot->AliquotAmount,(Centrifuge->_):>Nothing},2];

			(* -- FIGURE OUT WHICH SAMPLES ARE BEING MANIPULATED -- *)
			(* Expand the centrifuge booleans we received. *)
			centrifugeBooleans=If[MatchQ[Lookup[rawOptions,Centrifuge],_List],
				Lookup[rawOptions,Centrifuge],
				ConstantArray[Lookup[rawOptions,Centrifuge],Length[incubateSimulatedSamples]]
			];

			(* Get a MapThread friendly version of options. *)
			mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentCentrifuge,mappedOptions];

			(* Figure out if each of our samples is being centrifuged. A sample is being centrifuged if the Centrifuge option is set to True or if one of the Centrifuge related options is not Null|Automatic. *)
			masterSwitchBooleans=MapThread[
				Function[{boolean,options},
					Or[
						TrueQ[boolean],
						MemberQ[Values[options],Except[Automatic|Null|False|{Automatic,Automatic}]]
					]
				],
				{centrifugeBooleans,mapThreadFriendlyOptions}
			];

			(* If any of our booleans are incorrectly turned off, throw a message. *)
			incorrectlySetOptions=MapThread[
				Function[{boolean,options,sample},
					If[MatchQ[boolean,False]&&MemberQ[Values[options],Except[Automatic|Null|False|{Automatic,Automatic}]],
						{sample,Cases[Normal[options],(x_->Except[Automatic|Null|False|{Automatic,Automatic}]):>x]/.{Intensity->CentrifugeIntensity,Time->CentrifugeTime,Temperature->CentrifugeTemperature,Instrument->CentrifugeInstrument,AliquotContainer->CentrifugeAliquotContainer,DestinationWell->CentrifugeAliquotDestinationWell,AliquotAmount->CentrifugeAliquot}},
						Nothing
					]
				],
				{centrifugeBooleans,mapThreadFriendlyOptions,listedSamples}
			];

			(* Keep track of invalid inputs. *)
			invalidInputs=Append[invalidInputs,incorrectlySetOptions[[All,1]]];

			(* If there are incorrectly set options, throw a message. *)
			If[Length[incorrectlySetOptions]>0,
				Message[Error::CentrifugeIncorrectlySpecified,ObjectToString[incorrectlySetOptions[[All,1]]],ObjectToString[DeleteDuplicates[Flatten[incorrectlySetOptions[[All,2]]]]]];
			];

			(* Filter our samples that are going to be manipulated. *)
			filteredSamples=PickList[incubateSimulatedSamples,masterSwitchBooleans];

			(* Get the option information for our function. *)
			optionDefinition=OptionDefinition[ExperimentCentrifuge];

			(* Filter our options so that they index-match to filteredSamples. *)
			filteredOptions=Function[{option},
				(* If this option is index-matching to "experiment samples", filter it. Otherwise, don't. *)
				If[MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->First[option]]],"IndexMatchingInput",Null],"experiment samples"]||MatchQ[First[option],AliquotContainer|DestinationWell|AliquotSampleLabel],
					First[option]->PickList[Last[option],masterSwitchBooleans],
					option
				]
			]/@mappedOptions;

			(* For each of our options, we have to make sure that the standalone function can take Automatic as a value. If not, set it to the Default. *)
			automaticCompatibleOptions=Function[{option},
				(* Does this option take Automatic as as value? *)
				If[MatchQ[Automatic,ReleaseHold[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->First[option]]],"Pattern",Null]]],
					(* It does, no compatibility changes needed. *)
					option,
					(* It does not. Map Automatic to the option default. *)
					option/.{Automatic->ReleaseHold[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->First[option]]],"Default",Null]]}
				]
			]/@filteredOptions;

			If[debug,
				Echo["Starting centrifuge resolver..."];
			];

			(* -- RESOLVE OPTIONS AND SIMULATE SAMPLES -- *)
			(* Call the resolver. Pass EnableSamplePreparation\[Rule]False to indicate that the resolver should not deal with sample preperation (otherwise we end up in an infinite loop). *)
			{resolvedOptions,tests}=Quiet[
				If[gatherTests,
					ExperimentCentrifuge[filteredSamples,Flatten[{automaticCompatibleOptions,EnableSamplePreparation->False,Simulation -> UpdateSimulation[simulation, Simulation[incubateSimulatedCache]], Cache->incubateSimulatedCache,Output->{Options,Tests}}]],
					{ExperimentCentrifuge[filteredSamples,Flatten[{automaticCompatibleOptions,EnableSamplePreparation->False,Simulation -> UpdateSimulation[simulation, Simulation[incubateSimulatedCache]], Cache->incubateSimulatedCache,Output->Options}]],{}}
				],
				{
					Error::SamplesMarkedForDisposal,
					Error::DiscardedSamples
				}
			];

			If[debug,
				Echo[resolvedOptions,"Centrifuge resolved options"];
			];

			(* Expand our resolved option set. *)
			expandedResolvedOptions=Last[ExpandIndexMatchedInputs[ExperimentCentrifuge,{filteredSamples},resolvedOptions,Messages->False]];

			If[debug,
				Echo[resolvedOptions,"Starting centrifuge simulation..."];
			];

			(* Get our simulated samples and simulated cache. *)
			{simulatedSamples,simulatedCache}=simulateSamplePreparation[filteredSamples,expandedResolvedOptions,Aliquot,AssayVolume,AliquotContainer,"after Centrifugation",Cache->incubateSimulatedCache,Simulation->simulation];

			If[debug,
				Echo[resolvedOptions,"Finished centrifuge simulation."];
			];

			(* -- THREAD OUR OPTIONS BACK INTO THE CORRECT FORMAT -- *)
			(* Map our option set back: *)
			unmappedOptions=Replace[expandedResolvedOptions,{Intensity->CentrifugeIntensity,Time->CentrifugeTime,Temperature->CentrifugeTemperature,Instrument->CentrifugeInstrument,AliquotContainer->CentrifugeAliquotContainer,DestinationWell->CentrifugeAliquotDestinationWell,AliquotAmount->CentrifugeAliquot},2];

			(* Only allow options that are part of Centrifuge sample prep (Centrifuge has a bunch of miscellaneous options like Cache, Upload, etc.) *)
			samplePrepOptions=(
				If[MemberQ[Options[CentrifugePrepOptionsNew][[All,1]],ToString[First[#]]],
					#,
					Nothing
				]
					&)/@unmappedOptions;

			(* Get the positions of the False booleans in masterSwitchBooleans. *)
			falseBooleanPositions=Position[masterSwitchBooleans,False];

			(* If a sample is not being manipulated, insert a Null for the option. *)
			threadedOptions=Function[{option},
				(* Insert Nulls where ever samples are not being manipulated. *)
				First[option]->Fold[(Insert[#1,Null,#2]&),Last[option],falseBooleanPositions]
			]/@samplePrepOptions;

			(* Add our master switches back to our options. *)
			finalOptions=Append[threadedOptions,Centrifuge->masterSwitchBooleans];

			(* Get our non-simulated samples. *)
			nonSimulatedSamples=PickList[incubateSimulatedSamples,masterSwitchBooleans,False];

			(* Combine our simulated and non-simulated samples. *)
			(* Start off with simulatedSamples, and insert the non-simulated samples in the correct position with a Fold. *)
			allSamples=Fold[(Insert[#1,First[#2],Last[#2]]&),simulatedSamples,Transpose[{nonSimulatedSamples,falseBooleanPositions}]];

			(* Look at the Aliquot related options and simulate our samples. *)
			{allSamples,simulatedCache,finalOptions,tests}

		],
		(* ELSE: Centrifugation options are not supported by this function or the user hasn't requested for centrifugation. *)
		Module[{resolvedOptions},
			(* Does this function have Incubation sample prep? *)
			resolvedOptions=If[!MatchQ[myFunction,ExperimentCentrifuge],
				(* Yes, set any incubation rules we were given to Null. *)
				Join[
					{Centrifuge->ConstantArray[False,Length[listedSamples]]},
					(If[MatchQ[#,"Centrifuge"],
						Nothing,
						Symbol[#]->ConstantArray[Null,Length[listedSamples]]
					]&)/@Options[CentrifugePrepOptionsNew][[All,1]]
				],
				(* No, don't give back any resolved options. *)
				{}
			];

			{incubateSimulatedSamples,incubateSimulatedCache,resolvedOptions,{}}
		]
	];

	(* Is Filtration supported by this parent function and has the user requested centrifugation? (Filtration is disabled in ExperimentFilter). *)
	filterRequestedQ=And[
		(* Filtration is supported by this function. *)
		!MatchQ[myFunction,ExperimentFilter],
		(* And either: *)
		Or[
			(* The user has requested Filtration manually: *)
			MemberQ[ToList[Lookup[listedOptions,Filtration,False]],True],
			(* Or one of the filtration related options is not Automatic or Null. Need to do {Automatic, Automatic} because FilterContainerOut resolves to that and I don't want that *)
			Or@@(
				MemberQ[ToList[Lookup[listedOptions,Symbol[#],Null]],Except[Automatic|Null|False|{Automatic,Automatic}]]
			&)/@Options[FilterPrepOptionsNew][[All,1]]
		],
		(* Sample prep isn't set to False. *)
		Lookup[safeOptions,EnableSamplePreparation,True]
	];

	(* Resolve the centrifugation part of our sample prep workflow: *)
	{filterSimulatedSamples,filterSimulatedCache,resolvedFilterOptions,filterTests}=If[filterRequestedQ,
		Module[{rawOptions,mappedOptions,filterBooleans,mapThreadFriendlyOptions,masterSwitchBooleans,filteredSamples,resolvedOptions,tests,
			filteredOptions,automaticCompatibleOptions,simulatedSamples,simulatedCache,expandedResolvedOptions,unmappedOptions,samplePrepOptions,threadedOptions,falseBooleanPositions,
			nonSimulatedSamples,allSamples,preFilterSampleVolumes,finalOptions,incorrectlySetOptions},

			(* -- MAP OUR SAMPLE PREP OPTIONS INTO REGULAR EXPERIMENT OPTIONS -- *)
			(* Get our options that are related to filtration. *)
			rawOptions=First[splitPrepOptions[listedOptions,PrepOptionSets->FilterPrepOptionsNew]]/.{(NumberOfReplicates->_):>Nothing};

			(* Map our sample prep options to the ExperimentFilter option set. *)
			(* All option symbols are the same except for the following. Also remove the Filter boolean. *)
			mappedOptions=Replace[rawOptions,{PrefilterMaterial->PrefilterMembraneMaterial,FilterInstrument->Instrument,FilterMaterial->MembraneMaterial,FilterPoreSize->PoreSize,FilterSyringe->Syringe,FilterIntensity->Intensity,FilterTime->Time,FilterTemperature->Temperature,FilterSterile->Sterile,FilterContainerOut->FiltrateContainerOut,FilterAliquotContainer->AliquotContainer,FilterAliquotDestinationWell->DestinationWell,FilterAliquot->AliquotAmount,(Filtration->_):>Nothing},2];

			(* -- FIGURE OUT WHICH SAMPLES ARE BEING MANIPULATED -- *)
			(* Expand the centrifuge booleans we received. *)
			filterBooleans=If[MatchQ[Lookup[rawOptions,Filtration],_List],
				Lookup[rawOptions,Filtration],
				ConstantArray[Lookup[rawOptions,Filtration],Length[centrifugeSimulatedSamples]]
			];

			(* Get a MapThread friendly version of options. *)
			mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentFilter,mappedOptions];

			(* Figure out if each of our samples is being centrifuged. A sample is being centrifuged if the Centrifuge option is set to True or if one of the Centrifuge related options is not Null|Automatic. *)
			masterSwitchBooleans=MapThread[
				Function[{boolean,options},
					Or[
						TrueQ[boolean],
						MemberQ[Values[options],Except[Automatic|Null|False|{Automatic,Automatic}]]
					]
				],
				{filterBooleans,mapThreadFriendlyOptions}
			];

			(* If any of our booleans are incorrectly turned off, throw a message. *)
			incorrectlySetOptions=MapThread[
				Function[{boolean,options,sample},
					If[MatchQ[boolean,False]&&MemberQ[Values[options],Except[Automatic|Null|False|{Automatic,Automatic}]],
						{sample,Cases[Normal[options],(x_->Except[Automatic|Null|False|{Automatic,Automatic}]):>x]/.{PrefilterMembraneMaterial->PrefilterMaterial,Instrument->FilterInstrument,MembraneMaterial->FilterMaterial,PoreSize->FilterPoreSize,Syringe->FilterSyringe,Intensity->FilterIntensity,Time->FilterTime,Temperature->FilterTemperature,Sterile->FilterSterile,FiltrateContainerOut->FilterContainerOut,AliquotContainer->FilterAliquotContainer,DestinationWell->FilterAliquotDestinationWell,AliquotAmount->FilterAliquot}},
						Nothing
					]
				],
				{filterBooleans,mapThreadFriendlyOptions,listedSamples}
			];

			(* Keep track of invalid inputs. *)
			invalidInputs=Append[invalidInputs,incorrectlySetOptions[[All,1]]];

			(* If there are incorrectly set options, throw a message. *)
			If[Length[incorrectlySetOptions]>0,
				Message[Error::FiltrationIncorrectlySpecified,ObjectToString[incorrectlySetOptions[[All,1]], Cache -> centrifugeSimulatedCache],ObjectToString[DeleteDuplicates[Flatten[incorrectlySetOptions[[All,2]]]], Cache -> centrifugeSimulatedCache]];
			];

			(* Filter our samples that are going to be manipulated. *)
			filteredSamples=PickList[centrifugeSimulatedSamples,masterSwitchBooleans];

			(* Get the option information for our function. *)
			optionDefinition=OptionDefinition[ExperimentFilter];

			(* Filter our options so that they index-match to filteredSamples. *)
			filteredOptions=Function[{option},
				(* If this option is index-matching to "experiment samples", filter it. Otherwise, don't. *)
				If[MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->First[option]]],"IndexMatchingInput",Null],"experiment samples"]||MatchQ[First[option],AliquotContainer|DestinationWell|AliquotSampleLabel],
					First[option]->PickList[Last[option],masterSwitchBooleans],
					option
				]
			]/@mappedOptions;

			(* For each of our options, we have to make sure that the standalone function can take Automatic as a value. If not, set it to the Default. *)
			automaticCompatibleOptions=Function[{option},
				(* Does this option take Automatic as as value? *)
				If[MatchQ[Automatic,ReleaseHold[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->First[option]]],"Pattern",Null]]],
					(* It does, no compatibility changes needed. *)
					option,
					(* It does not. Map Automatic to the option default. *)
					option/.{Automatic->ReleaseHold[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->First[option]]],"Default",Null]]}
				]
			]/@filteredOptions;

			If[debug,
				Echo["Calling filter resolver..."];
			];

			(* -- RESOLVE OPTIONS AND SIMULATE SAMPLES -- *)
			(* Call the resolver. Pass EnableSamplePreparation\[Rule]False to indicate that the resolver should not deal with sample preperation (otherwise we end up in an infinite loop). *)
			{resolvedOptions,tests}=Quiet[
				If[gatherTests,
					ExperimentFilter[filteredSamples,Flatten[{automaticCompatibleOptions,EnableSamplePreparation->False,Simulation -> UpdateSimulation[simulation, Simulation[centrifugeSimulatedCache]], Cache->centrifugeSimulatedCache,Output->{Options,Tests}}]],
					{ExperimentFilter[filteredSamples,Flatten[{automaticCompatibleOptions,EnableSamplePreparation->False,Simulation -> UpdateSimulation[simulation, Simulation[centrifugeSimulatedCache]], Cache->centrifugeSimulatedCache,Output->Options}]],{}}
				],
				{
					Error::SamplesMarkedForDisposal,
					Error::DiscardedSamples
				}
			];

			If[debug,
				Echo[resolvedOptions,"End filter resolver."];
			];

			(* Expand our resolved option set. *)
			expandedResolvedOptions=Last[ExpandIndexMatchedInputs[ExperimentFilter,{filteredSamples},resolvedOptions,Messages->False]];

			(* Get our simulated samples and simulated cache (from our pre-filter aliquot step). *)
			{simulatedSamples,simulatedCache}=simulateSamplePreparation[filteredSamples,expandedResolvedOptions,Aliquot,AssayVolume,AliquotContainer,"after FilterAliquot",Cache->centrifugeSimulatedCache];

			(* Get the volumes of each of our samples after aliquoting. Assume that filtering results in no loss of sample. *)
			preFilterSampleVolumes=(
				Lookup[fetchPacketFromCache[#,simulatedCache],Volume,Null]
					&)/@simulatedSamples;

			If[debug,
				Echo["Starting filter simulation..."];
			];

			(* Get our simulated samples and simulated cache (from our post-filter aliquot step). *)
			(* We want to simulate all of our filter samples since filtered samples will always have a container change at the end. *)
			{simulatedSamples,simulatedCache}=simulateSamplePreparation[simulatedSamples,Join[expandedResolvedOptions,{FilterBooleans->ConstantArray[True,Length[simulatedSamples]],PostFilterVolumes->preFilterSampleVolumes}],FilterBooleans,PostFilterVolumes,FiltrateContainerOut,"after Filtration",Cache->simulatedCache,Simulation->simulation];

			If[debug,
				Echo["End filter simulation."];
			];

			(* -- THREAD OUR OPTIONS BACK INTO THE CORRECT FORMAT -- *)

			(* Map our option set back: *)
			unmappedOptions=Replace[expandedResolvedOptions,{PrefilterMembraneMaterial->PrefilterMaterial,Instrument->FilterInstrument,MembraneMaterial->FilterMaterial,PoreSize->FilterPoreSize,Syringe->FilterSyringe,Intensity->FilterIntensity,Time->FilterTime,Temperature->FilterTemperature,Sterile->FilterSterile,FiltrateContainerOut->FilterContainerOut,AliquotContainer->FilterAliquotContainer,DestinationWell->FilterAliquotDestinationWell,AliquotAmount->FilterAliquot},2];

			(* Only allow options that are part of Filter sample prep (Incubate has a bunch of miscellaneous options like Cache, Upload, etc.) *)
			samplePrepOptions=(
				If[MemberQ[Options[FilterPrepOptionsNew][[All,1]],ToString[First[#]]],
					#,
					Nothing
				]
					&)/@unmappedOptions;

			(* Get the positions of the False booleans in masterSwitchBooleans. *)
			falseBooleanPositions=Position[masterSwitchBooleans,False];

			(* If a sample is not being manipulated, insert a Null for the option. *)
			threadedOptions=Function[{option},
				(* Insert Nulls where ever samples are not being manipulated. *)
				First[option]->Fold[(Insert[#1,Null,#2]&),Last[option],falseBooleanPositions]
			]/@samplePrepOptions;

			(* Add our master switches back to our options. *)
			finalOptions=Append[threadedOptions,Filtration->masterSwitchBooleans];

			(* Get our non-simulated samples. *)
			nonSimulatedSamples=PickList[listedSamples,masterSwitchBooleans,False];

			(* Combine our simulated and non-simulated samples. *)
			(* Start off with simulatedSamples, and insert the non-simulated samples in the correct position with a Fold. *)
			allSamples=Fold[(Insert[#1,First[#2],Last[#2]]&),simulatedSamples,Transpose[{nonSimulatedSamples,falseBooleanPositions}]];

			(* Look at the Aliquot related options and simulate our samples. *)
			{allSamples,simulatedCache,finalOptions,tests}
		],
		(* ELSE: Filter options are not supported by this function or the user hasn't requested for centrifugation. *)
		Module[{resolvedOptions},
			(* Does this function have Filter sample prep? *)
			resolvedOptions=If[!MatchQ[myFunction,ExperimentFilter],
				(* Yes, set any Filter rules we were given to Null. *)
				Join[
					{Filtration->ConstantArray[False,Length[listedSamples]]},
					(If[MatchQ[#,"Filtration"],
						Nothing,
						Symbol[#]->ConstantArray[Null,Length[listedSamples]]
					]&)/@Options[FilterPrepOptionsNew][[All,1]]
				],
				(* No, don't give back any resolved options. *)
				{}
			];

			{centrifugeSimulatedSamples,centrifugeSimulatedCache,resolvedOptions,{}}
		]
	];

	(* Define a list of index matching aliquot options for us to check to see if an aliquot is going to happen. *)
	(* Note: This is different than the list in resolveAliquotOptions because we aren't interested in resolving the Aliquot option. Simply look to see if anything has explicitly been asked to aliquot. *)
	indexMatchingAliquotOptions={Aliquot, AliquotSampleLabel, AliquotAmount, TargetConcentration, TargetConcentrationAnalyte, AssayVolume, AliquotContainer, DestinationWell, ConcentratedBuffer, BufferDilutionFactor, BufferDiluent, AssayBuffer, AliquotSampleStorageCondition};

	(* Has the user set any of the Aliquot options for any samples? *)
	aliquotContainerSpecifiedQ=And[
		(* Make sure that all of our Aliquot keys exist. *)
		Sequence@@(
			KeyExistsQ[listedOptions,#]&/@indexMatchingAliquotOptions
		),
		(* And if any of our aliquot keys are set, then we need to aliquot. *)
		Or@@Flatten[{
			!MatchQ[Lookup[listedOptions,#],{ListableP[Null|Automatic|False|{Automatic,Automatic}]..}]&/@indexMatchingAliquotOptions,
			MemberQ[mySamples,_List?(Length[#]>1&)]
		}]
	];

	(* Perform aliquot simulation if requested. *)
	{aliquotSimulatedSamples,aliquotSimulatedCache,resolvedAliquotOptions}=If[aliquotContainerSpecifiedQ,
		Module[{aliquotContainerOption,filterBooleans,filteredSamples,filteredAliquotOptions,destinationWellOption,aliquotSampleLabelOption,expandedAliquotOptionsWithoutReplicates,
		assayAmount,simulatedSamples,simulatedCache,nonSimulatedSamples,falseBooleanPositions,allSamples,threadedOptions,finalOptions,resolvedOptions},

			(* If we were previously pooled, we flattened our samples and options so that we could resolve our first three stages. *)
			(* Repool our samples to pass into the aliquot resolver. *)
			(* Note: Repooling does not currently support SM sample preparation, only worry about this once it comes online. *)
			{repooledSamples,repooledOptions}=If[pooledQ,
				(* Replace the objects in our function with UUIDs. *)
				uuidShell=mySamples/.{ObjectP[]:>CreateUUID[],_String:>CreateUUID[]};

				(* Get our samples and options back into the correct pooled format. *)
				{uuidShell/.MapThread[Rule,{Flatten[uuidShell],filterSimulatedSamples}],myExperimentOptions},
				{filterSimulatedSamples,listedOptions}
			];

			(* Get the AliquotContainer option. *)
			(* If it is index-matched to Length[listedSamples]*numberOfReplicates, filter it down, otherwise, leave it alone. *)
			aliquotContainerOption=If[Length[Lookup[repooledOptions,AliquotContainer]]==Length[repooledSamples],
				(* Index-matched to listedSamples. *)
				Lookup[repooledOptions,AliquotContainer],
				(* Otherwise, collapse NumberOfReplicates expanded version. *)
				Lookup[repooledOptions,AliquotContainer][[;;;;numberOfReplicates]]
			];

			(* Get the DestinationWell option. *)
			(* If it is index-matched to Length[listedSamples]*numberOfReplicates, filter it down, otherwise, leave it alone. *)
			destinationWellOption=If[Length[Lookup[repooledOptions,DestinationWell]]==Length[repooledSamples],
				(* Index-matched to listedSamples. *)
				Lookup[repooledOptions,DestinationWell],
				(* Otherwise, collapse NumberOfReplicates expanded version. *)
				Lookup[repooledOptions,DestinationWell][[;;;;numberOfReplicates]]
			];

			(* Get the AliquotSampleLabel option. *)
			(* If it is index-matched to Length[listedSamples]*numberOfReplicates, filter it down, otherwise, leave it alone. *)
			aliquotSampleLabelOption=If[Length[Lookup[repooledOptions,AliquotSampleLabel]]==Length[repooledSamples],
				(* Index-matched to listedSamples. *)
				Lookup[repooledOptions,AliquotSampleLabel],
				(* Otherwise, collapse NumberOfReplicates expanded version. *)
				Lookup[repooledOptions,AliquotSampleLabel][[;;;;numberOfReplicates]]
			];

			(* Replace the AliquotContainer and DestinationWell options. *)
			expandedAliquotOptionsWithoutReplicates=ReplaceRule[repooledOptions,{AliquotContainer->aliquotContainerOption,DestinationWell->destinationWellOption, AliquotSampleLabel->aliquotSampleLabelOption}];

			(* The user has specified aliquot containers. Resolve our aliquot options for the samples with aliquot containers or aliquot volumes specified. *)
			filterBooleans=MapThread[
				Function[{aliquot, aliquotSampleLabel, aliquotAmount, targetConc, targetConcAnalyte, assayVolume, aliquotContainer, destinationWell, concBuffer, bufferDilutionFactor, bufferDiluent, assayBuffer, storageCondition,sample},
					Or[
						(* All pools with more than one sample should be aliquotted. *)
						MatchQ[sample,_List?(Length[#]>1&)],
						(* If any of our aliquot options are set, we should resolve the aliquot options (and potentially simulate) for this sample. *)
						MemberQ[
							{aliquot, aliquotSampleLabel, aliquotAmount, targetConc, targetConcAnalyte, assayVolume, aliquotContainer, destinationWell, concBuffer, bufferDilutionFactor, bufferDiluent, assayBuffer, storageCondition},
							Except[ListableP[Null|Automatic|False|{Automatic,Automatic}]]
						]
					]
				],
				{Sequence@@Lookup[expandedAliquotOptionsWithoutReplicates,indexMatchingAliquotOptions],repooledSamples}
			];

			(* Filter our samples. *)
			filteredSamples=PickList[repooledSamples,filterBooleans];

			(* Filter our aliquot options. *)
			filteredAliquotOptions=(
				(* Depending on the aliquot option, handle our filtering differently: *)
				If[MatchQ[Symbol[#],AliquotContainer|DestinationWell|AliquotSampleLabel],
					(* AliquotContainer is index-matched to either Length[listedSamples] or Length[mySamplesWithPreparedSamples]*NumberOfReplicates. *)
					If[Length[Lookup[repooledOptions,Symbol[#]]]==Length[filterBooleans],
						(* Index-matched to listedSamples, regularly filter. *)
						Symbol[#]->PickList[Lookup[repooledOptions,Symbol[#]],filterBooleans],
						(* Otherwise, collapse NumberOfReplicates expanded version and then filter. *)
						Symbol[#]->PickList[Lookup[repooledOptions,Symbol[#]][[;;;;numberOfReplicates]],filterBooleans]
					],
					(* Otherwise, look to see if our option is index-matching. *)
					If[MemberQ[indexMatchingAliquotOptions,Symbol[#]],
						Symbol[#]->PickList[Lookup[repooledOptions,Symbol[#]],filterBooleans],
						Symbol[#]->Lookup[repooledOptions,Symbol[#]]
					]
				]
			&)/@Options[AliquotOptions][[All,1]];

			If[debug,
				Echo["Starting aliquot resolution..."];
			];

			(* Resolve our aliquot options. *)
			(* We quiet ALL messages here because we will call the aliquot resolver again in resolveAliquotOptions. *)
			resolvedOptions=Quiet[
				resolveAliquotOptions[
					myFunction,
					filteredSamples,
					filteredSamples,
					filteredAliquotOptions,
					RequiredAliquotAmounts->Null,
					RequiredAliquotContainers->Automatic,
					Cache->Flatten[{filterSimulatedCache,cache}],
					Simulation->UpdateSimulation[simulation, Simulation[filterSimulatedCache]]
				]
			];

			If[debug,
				Echo[resolvedOptions,"End aliquot resolution."];
			];

			(* We need to create an AssayAmount key here to send into simulateSamplePreparation since AssayVolume will be Null if AliquotAmount is a solid/tablet that is not being diluted with buffer. *)
			assayAmount=MapThread[
				Function[{aliquotAmount,assayVolume},
					(* Try to use the assayVolume key. If it's Null, that means that our sample is a solid - fall back on the AliquotAmount key. *)
					If[!MatchQ[assayVolume,Null],
						assayVolume,
						aliquotAmount
					]
				],
				{Lookup[resolvedOptions,AliquotAmount],Lookup[resolvedOptions,AssayVolume]}
			];

			(* We return different values depending on whether or not our samples are pooled. *)
			(* If our samples are pooled, do not simulated and return the resolved options. Otherwise, simulate and do not return aliquot resolved options. *)
			If[pooledQ,
				(* We are pooled. Instead of simulating, give the experiment function back the resolved aliquot options so it can see what's in each pool. *)
				If[debug,
					Echo["Pooling input detected. Not simulating aliquot."];
				];

				(* -- THREAD OUR OPTIONS BACK INTO THE CORRECT FORMAT -- *)
				(* Get the positions of the False booleans in masterSwitchBooleans. *)
				falseBooleanPositions=Position[filterBooleans,False];

				(* If a sample is not being manipulated, insert a Null for the option. *)
				threadedOptions=Function[{option},
					(* Is this option index matching? *)
					If[MatchQ[First[option],Alternatives@@indexMatchingAliquotOptions],
						(* Insert Nulls/False where ever samples are not being manipulated. *)
						First[option]->Fold[(Insert[#1,Null,#2]&),Last[option],falseBooleanPositions],
						option
					]
				]/@resolvedOptions;

				(* Add our master switches back to our options. *)
				finalOptions=Append[threadedOptions,Aliquot->filterBooleans];

				(* Return our simulated samples and cache from the filtration stage, also return the aliquot options. *)
				{filterSimulatedSamples,filterSimulatedCache,finalOptions},

				(* ELSE: Simulate our aliquot transfer. *)
				If[debug,
					Echo["No pooling input detected. Not simulating aliquot."];
				];

				{simulatedSamples,simulatedCache}=simulateSamplePreparation[filteredSamples,Flatten[{resolvedOptions,AssayAmount->assayAmount}],Aliquot,AssayAmount,AliquotContainer,"after Sample Preparation",Cache->Flatten[{filterSimulatedCache,cache}],Simulation->simulation];

				(* Get the positions of the non-simulated samples. *)
				nonSimulatedSamples=PickList[filterSimulatedSamples,filterBooleans,False];
				falseBooleanPositions=Position[filterBooleans,False];

				(* Tread our simulated and non-simulated samples together. *)
				(* Start off with simulatedSamples, and insert the non-simulated samples in the correct position with a Fold. *)
				allSamples=Fold[(Insert[#1,First[#2],Last[#2]]&),simulatedSamples,Transpose[{nonSimulatedSamples,falseBooleanPositions}]];

				(* Return our aliquot simulated samples and cache, do not return any aliquot options. *)
				{allSamples,simulatedCache,{}}
			]
		],
		(* We have to return placeholder False/Null options for Aliquot if given a pooling function. Pooling functions expect these preliminary aliquot options to see the pooling groups. *)
		aliquotOptions=If[pooledQ,
			Module[{indexMatchedOptions},
				(* Get all the index matched options. *)
				indexMatchedOptions=Function[{optionSymbol},
					(* AliquotAmount and TargetConcentration and TargetConcentrationAnalyte are matched to the samples, not to the pools. *)
					(* Otherwise, the option is matched to the pools. *)
					If[MatchQ[optionSymbol,AliquotAmount|TargetConcentration|TargetConcentrationAnalyte],
						optionSymbol->(mySamples/.{ObjectP[]->Null}),
						optionSymbol->ConstantArray[Null,Length[mySamples]]
					]
				]/@indexMatchingAliquotOptions;

				(* Add the non-index matched options. *)
				ReplaceRule[indexMatchedOptions,{Aliquot->ConstantArray[False,Length[mySamples]],ConsolidateAliquots->Null,AliquotPreparation->Null}]
			],
			(* ELSE: We are not pooled, do not return options. *)
			{}
		];

		(* No aliquot options have been specified. Just pass along the filter resolved variables and the placeholder aliquot options, if necessary. *)
		{filterSimulatedSamples,filterSimulatedCache,aliquotOptions}
	];

	(* Combine our sample prep options. *)
	resolvedSamplePrepOptions=Join[resolvedIncubateOptions,resolvedCentrifugeOptions,resolvedFilterOptions,resolvedAliquotOptions];

	(* If we were given pooled samples, we flattened them at the beginning of this function. Re-pool them. Otherwise, they are already in the correct format. *)
	{reformatedSamples,reformatedOptions}=If[pooledQ,
		(* Note: This remapping code is also not compliant with SM preparation. Worry about that when it comes online. *)
		(* Replace the objects in our function with UUIDs. *)
		uuidShell=mySamples/.{ObjectP[]:>CreateUUID[]};

		(* Flatten our UUIDs. *)
		flatUUIDs=Flatten[uuidShell];

		(* Get our aliquot options. These are already pooled so we don't have to worry about them. *)
		aliquotOptions=ToExpression/@Options[AliquotOptions][[All,1]];

		(* Pool our samples back as well. *)
		repooledSamples=uuidShell/.MapThread[Rule,{flatUUIDs,aliquotSimulatedSamples}];

		(* Get our samples and options back into the correct pooled format. *)
		repooledOptions=Function[{option},
			Module[{optionSymbol,optionValue,optionDefinition,numberOfReplicates},
				(* Get the option name and value. *)
				optionSymbol=option[[1]];
				optionValue=option[[2]];

				(* Get the definition of our option. *)
				optionDefinition=FirstCase[optionDefinitions,KeyValuePattern["OptionSymbol"->optionSymbol]];

				(* Get the number of replicates option. *)
				numberOfReplicates=Lookup[myExperimentOptions,NumberOfReplicates,Null]/.{Null->1};

				(* If our option is pooled, we have to re-pool it. *)
				If[Lookup[optionDefinition,"NestedIndexMatching",False]&&!MatchQ[optionSymbol,Alternatives@@aliquotOptions],
					(* Does the length of our option match the length of our input? If not, we have to collapse our replicates. *)
					If[Length[optionValue]==Length[aliquotSimulatedSamples],
						optionSymbol->uuidShell/.MapThread[Rule,{flatUUIDs,optionValue}],
						optionSymbol->uuidShell/.MapThread[Rule,{flatUUIDs,optionValue[[;;;;numberOfReplicates]]}]
					],
					(* Our option is not pooled. Nothing to do. *)
					option
				]
			]
		]/@resolvedSamplePrepOptions;

		(* Return our re-pooled input and option results. *)
		{repooledSamples,repooledOptions},
		(* ELSE: No pooled inputs. Nothing to reformat. *)
		{aliquotSimulatedSamples,resolvedSamplePrepOptions}
	];

	(* get all the options for the specified function *)
	functionOptions = Keys[SafeOptions[myFunction]];

	(* get rid of any options that are in the reformatedOptions that are not options of myFunction*)
	reformatedOptionsMinusMisfits = Select[reformatedOptions, MemberQ[functionOptions, First[#]]&];

	(* Make sure all options are expanded. *)
	(* Don't try to expand things if the first definition of this function requires multiple inputs (we're only given a single list of samples). *)
	(* Also don't try to expand if we weren't pooled to begin with *)
	expandedSamplePrepOptions=If[Length[Lookup[First[Lookup[Usage[myFunction],"BasicDefinitions"]],"Inputs"]]>1 || !pooledQ,
		reformatedOptionsMinusMisfits,
		Last[ExpandIndexMatchedInputs[myFunction,{reformatedSamples},reformatedOptionsMinusMisfits]]
	];

	(* Return our requested output. *)
	resultRule=Result->{reformatedSamples,expandedSamplePrepOptions,FlattenCachePackets[{aliquotSimulatedCache,cache}]};

	testRule=Tests->Flatten[{incubateTests,centrifugeTests,filterTests}];

	If[debug,
		Echo["Finished sample prep resolving..."];
	];

	outputSpecification/.{resultRule,testRule}
];


(* ::Subsubsection::Closed:: *)
(*Container Overload*)


Error::CantSamplePrepSelfContainedSamples="The sample preparation option(s), `1`, have been turned on for self-contained samples (samples without containers), `2`. Sample preparation experiments require non self-contained samples as input (samples that reside within containers). To see the valid sample types that can be used in sample preparation, evaluate NonSelfContainedSampleTypes. Please turn off the sample preparation options for these samples.";
Error::CantSamplePrepInvalidContainers="The sample preparation option(s), `1`, have been set for the following container(s), `2`. These container(s) either have no samples or multiple samples in them. Sample Preparation can only be specified for containers with exactly one sample in them. Please turn off sample preparation for these containers.";

(* This container overload takes self contained samples and containers (in addition to taking non self contained samples). *)
resolveSamplePrepOptions[myFunction_,mySamples:{(NonSelfContainedSampleP|SelfContainedSampleP|ObjectP[Object[Container]]|_String)..},mySamplePrepOptions_List,myOptions:OptionsPattern[resolveSamplePrepOptions]]:=Module[
	{cache,safeOptions,outputSpecification,output,optionDefinition,numberOfReplicates,selfContainedPositions,nonSelfContainedPositions,containerPositions,containerSingleSamplePositions,
		validInputPositions,samplePrepOptions,invalidSelfContainedResults,incorrectlySetSamplePrepOptions,invalidSelfContainedObjects,invalidSelfContainedSamplePrepOptions,
		containerResults,containerPacket,containerContents,invalidContainerObjects,invalidContainerSamplePrepOptions,invalidInputs,invalidOptions,
		validInputs,validOptions,optionSymbol,optionValue,indexMatchingQ,simulatedSamples,resolvedSamplePrepOptions,simulatedCache,invalidInputPositions,foldedSamples,allSamples,allOptions,
		sanitizedOptions,simulationTests,sampleObjs},

	(* Lookup our cache. *)
	cache=Lookup[ToList[myOptions],Cache,{}];

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolveSamplePrepOptions,ToList[myOptions]];

	(* get samples samples without links; this is important because otherwise the Position stuff below doesn't work *)
	sampleObjs = Map[
		Switch[#,
			LinkP[], Download[#, Object],
			PacketP[], Lookup[#, Object],
			_, #
		]&,
		mySamples
	];

	(* Lookup our output specification. *)
	(* get the output specification/output and cache options *)
	outputSpecification=Lookup[safeOptions, Output];
	output=ToList[outputSpecification];

	(* Get the option definition for our function. *)
	optionDefinition=OptionDefinition[myFunction];

	(* Get the NumberOfReplicates option. *)
	numberOfReplicates=Lookup[mySamplePrepOptions,NumberOfReplicates,Null]/.{Automatic|Null->1};

	(* Get the positions of the self-contained samples, non-self-contained samples, and containers. *)
	selfContainedPositions=Flatten[Position[sampleObjs,SelfContainedSampleP]];
	nonSelfContainedPositions=Flatten[Position[sampleObjs,NonSelfContainedSampleP]];
	containerPositions=Flatten[Position[sampleObjs,ObjectP[Object[Container]]]];

	(* Get the positions of the containers that only have one sample in them. *)
	containerSingleSamplePositions=(
		If[Length[Lookup[fetchPacketFromCache[sampleObjs[[#]],cache],Contents]]==1,
			#,
			Nothing
		]
			&)/@containerPositions;

	(* Get the positions of the valid inputs. *)
	validInputPositions=Sort[Flatten[{nonSelfContainedPositions,containerSingleSamplePositions}]];

	(* Combine all of our sample prep option names. *)
	(* Note: These are strings (because of the degeneracy that are string keys). *)
	samplePrepOptions=Flatten[(Options[#][[All,1]]&)/@{IncubatePrepOptionsNew,CentrifugePrepOptionsNew,FilterPrepOptionsNew,AliquotOptions}];

	(* Make sure that no sample prep options are set for the self-contained samples. *)
	invalidSelfContainedResults=Function[{selfContainedPosition},
		(* Get the sample prep option names that are set for self contained samples. *)
		incorrectlySetSamplePrepOptions=(If[
			And[
				(* Make sure that the option we're looking at is index-matching. *)
				MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->Symbol[#]]],"IndexMatchingInput"],_String],
				(* If it's index matching, make sure it isn't set. *)
				MemberQ[
					ToList[Lookup[mySamplePrepOptions,Symbol[#],ConstantArray[Null,Length[sampleObjs]]][[selfContainedPosition]]],
					Except[Automatic|Null|False]
				]
			],
			Symbol[#],
			Nothing
		]&)/@samplePrepOptions;

		(* If any options are set, return them. *)
		If[Length[incorrectlySetSamplePrepOptions]>0,
			{sampleObjs[[selfContainedPosition]],incorrectlySetSamplePrepOptions},
			Nothing
		]
	]/@selfContainedPositions;

	(* Transpose our result. *)
	{invalidSelfContainedObjects, invalidSelfContainedSamplePrepOptions}=If[Length[invalidSelfContainedResults]>0,
		Transpose[invalidSelfContainedResults],
		{{},{}}
	];

	(* Throw an error if required. *)
	If[Length[invalidSelfContainedObjects]>0,
		Message[Error::CantSamplePrepSelfContainedSamples,ObjectToString[invalidSelfContainedSamplePrepOptions],ObjectToString[invalidSelfContainedObjects]];
	];

	(* Make sure that no sample prep options are set for the empty containers. *)
	containerResults=Function[{containerPosition},
		(* Get the packet of this container. *)
		containerPacket=fetchPacketFromCache[sampleObjs[[containerPosition]],cache];

		(* Get the number of samples in this container. *)
		containerContents=Lookup[containerPacket,Contents];

		(* If there is not EXACTLY 1 sample in this container, then we should not have any sample prep options set. *)
		If[Length[containerContents]!=1,
			(* See if any sample prep options are set for this position. *)
			incorrectlySetSamplePrepOptions=(If[
				Or[
					(* If we are dealing with an index-matching option, make sure it isn't set. *)
					And[
						(* Make sure that the option we're looking at is index-matching. *)
						MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->Symbol[#]]],"IndexMatchingInput"],_String],
						(* If it's index matching, make sure it isn't set. *)
						MemberQ[
							ToList[Lookup[mySamplePrepOptions,Symbol[#]][[containerPosition]]],
							Except[Automatic|Null|False]
						]
					],
					(* If we are dealing with AliquotContainer, AliquotSampleLabel, or DestinationWell (which isn't index-matching) account for NumberOfReplicates and make sure it isn't set after that. *)
					And[
						MatchQ[Symbol[#],AliquotContainer|DestinationWell|AliquotSampleLabel],
						(* AliquotContainer, AliquotSampleLabel, and DestinationWell are index-matched to either Length[sampleObjs] or Length[sampleObjs]*NumberOfReplicates. *)
						MemberQ[
							(* If we have NumberOfReplicates, we have to filter out the replicates before we Take[...]. *)
							If[Length[Lookup[mySamplePrepOptions,Symbol[#]]]==Length[sampleObjs],
								(* Index-matched to sampleObjs, regularly make sure it isn't set. *)
								Lookup[mySamplePrepOptions,Symbol[#]][[containerPosition]],
								(* Otherwise, collapse NumberOfReplicates expanded version and make sure it isn't set. *)
								Lookup[mySamplePrepOptions,Symbol[#]][[;;;;numberOfReplicates]][[containerPosition]]
							],
							Except[Automatic|Null|False]
						]
					]
				],
				Symbol[#],
				Nothing
			]&)/@samplePrepOptions;

			(* If any options are set, return them. *)
			If[Length[incorrectlySetSamplePrepOptions]>0,
				{sampleObjs[[containerPosition]],incorrectlySetSamplePrepOptions},
				Nothing
			],
			(* ELSE: There is one sample in this container, we're good to go. *)
			Nothing
		]
	]/@containerPositions;

	(* Transpose our result. *)
	{invalidContainerObjects, invalidContainerSamplePrepOptions}=If[Length[containerResults]>0,
		Transpose[containerResults],
		{{},{}}
	];

	(* Throw an error if required. *)
	If[Length[invalidContainerObjects]>0,
		Message[Error::CantSamplePrepInvalidContainers,ObjectToString[invalidContainerSamplePrepOptions],ObjectToString[invalidContainerObjects]];
	];

	(* Throw Error::InvalidInputs or Error::InvalidOptions if required. *)
	invalidInputs=DeleteDuplicates[Flatten[{invalidSelfContainedObjects,invalidContainerObjects}]];
	invalidOptions=DeleteDuplicates[Flatten[{invalidSelfContainedSamplePrepOptions,invalidContainerSamplePrepOptions}]];

	If[Length[invalidInputs]>0,
		Message[Error::InvalidInput,ObjectToString[invalidInputs]];
	];

	If[Length[invalidOptions]>0,
		Message[Error::InvalidOption,ObjectToString[invalidOptions]];
	];

	(* Filter down our inputs and options to only the valid input samples. *)
	validInputs=(
		(* If we have a valid container, we need to get the single sample out of it. *)
		If[MatchQ[sampleObjs[[#]],ObjectP[Object[Container]]],
			First[Lookup[fetchPacketFromCache[sampleObjs[[#]],cache],Contents][[All,2]]],
			sampleObjs[[#]]
		]
			&)/@validInputPositions;

	(* Filter down our options so that we only have the index-matching values to our valid inputs. *)
	validOptions=Function[{option},
		(* Split out the option symbol and the option value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Lookup our option definition to see if it's index-matching. *)
		indexMatchingQ=MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->optionSymbol],<||>],"IndexMatchingInput",Null],_String];

		(* Are we dealing with the AliquotContainer option? *)
		If[MatchQ[optionSymbol,AliquotContainer|DestinationWell|AliquotSampleLabel],
			(* AliquotContainer, AliquotSampleLabel, and DestinationWell are index-matched to either Length[sampleObjs] or Length[sampleObjs]*NumberOfReplicates. *)
			If[Length[Lookup[mySamplePrepOptions,optionSymbol]]==Length[sampleObjs],
				(* Index-matched to sampleObjs, regularly filter. *)
				optionSymbol->optionValue[[validInputPositions]],
				(* Otherwise, collapse NumberOfReplicates expanded version and then filter. *)
				optionSymbol->optionValue[[;;;;numberOfReplicates]][[validInputPositions]]
			],
			(* Otherwise, look to see if our option is index-matching. *)
			If[indexMatchingQ,
				optionSymbol->optionValue[[validInputPositions]],
				option
			]
		]
	]/@mySamplePrepOptions;

	(* Drop the Output option from our option set. *)
	sanitizedOptions=myOptions/.{(Output->_)->Nothing};

	(* Call our main overload. *)
	{{simulatedSamples,resolvedSamplePrepOptions,simulatedCache},simulationTests}=If[Length[validInputs]>0,
		If[MemberQ[output,Tests],
			resolveSamplePrepOptions[myFunction,validInputs,validOptions,ReplaceRule[ToList[sanitizedOptions], Output->{Result,Tests}]],
			{resolveSamplePrepOptions[myFunction,validInputs,validOptions,ReplaceRule[ToList[sanitizedOptions], Output->Result]],{}}
		],
		{
			{{},(Symbol[#]->{}&)/@samplePrepOptions,cache},
			{}
		}
	];

	(* Thread back our resolved options (for non-self-contained samples) in their correct positions with other object/container types being set to Null/False appropriately. *)

	(* Get the positions of the invalid inputs. *)
	invalidInputPositions=Complement[Range[Length[sampleObjs]],validInputPositions];
	invalidInputs=sampleObjs[[invalidInputPositions]];

	(* Thread our simulated and invalid samples (samples that we're not passing through simulation) together. *)
	(* Start off with simulatedSamples, and insert the invalid samples in the correct position with a Fold. *)
	foldedSamples=Fold[(Insert[#1,First[#2],Last[#2]]&),simulatedSamples,Transpose[{invalidInputs,invalidInputPositions}]];

	(* Some of our samples may have been given to us as containers (and we mapped them to their single sample when passing them to the simulation stage). *)
	(* If something was originally a container, keep it as a container. *)
	allSamples=MapThread[
		Function[{originalObject,newObject},
			If[MatchQ[originalObject,ObjectP[Object[Container]]]&&!MatchQ[newObject,ObjectP[Object[Container]]],
				(* Our original object was a container and our new object isn't a container. *)
				(* Do a cache lookup and keep it as a container. *)
				Lookup[fetchPacketFromCache[newObject,simulatedCache],Container]/.{link_Link:>Download[link, Object]},
				(* Otherwise, we're okay. *)
				newObject
			]
		],
		{sampleObjs,foldedSamples}
	];

	(* Thread our options back together. *)
	allOptions=Function[{option},
		(* Split out the option symbol and the option value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Lookup our option definition to see if it's index-matching. *)
		indexMatchingQ=MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->optionSymbol]],"IndexMatchingInput"],"experiment samples"];

		(* Are we dealing with the AliquotContainer option? *)
		If[MatchQ[optionSymbol,AliquotContainer|DestinationWell|AliquotSampleLabel],
			(* AliquotContainer, AliquotSampleLabel, and DestinationWell are index-matched to either Length[sampleObjs] or Length[sampleObjs]*NumberOfReplicates. *)
			If[Length[Lookup[mySamplePrepOptions,optionSymbol]]==Length[sampleObjs],
				(* Index-matched to sampleObjs, regularly filter. *)
				optionSymbol->Fold[(Insert[#1,Null,#2]&),optionValue,invalidInputPositions],
				(* Otherwise, collapse NumberOfReplicates expanded version and then filter. *)
				optionSymbol->Fold[(Insert[#1,Null,#2]&),optionValue[[;;;;numberOfReplicates]],invalidInputPositions]
			],
			(* Otherwise, look to see if our option is index-matching. *)
			If[indexMatchingQ,
				(* Are we dealing with a master switch option? If so, use False instead of Null. *)
				If[MatchQ[optionSymbol,Incubate|Centrifuge|Filtration|Aliquot|Mix],
					optionSymbol->Fold[(Insert[#1,False,#2]&),optionValue,invalidInputPositions],
					optionSymbol->Fold[(Insert[#1,Null,#2]&),optionValue,invalidInputPositions]
				],
				If[MatchQ[optionValue,{}],
					optionSymbol->Null,
					option
				]
			]
		]
	]/@resolvedSamplePrepOptions;

	(* Return our threaded together results. *)
	outputSpecification/.{
		Result->{allSamples,allOptions,simulatedCache},
		Tests->simulationTests
	}
];

(* ::Subsubsection::Closed:: *)
(*Simulation Overload*)
(* resolveSamplePrepOptionsNew *)
(* TODO: The internals of resolveSamplePrepOptions still use cache balling instead of proper simulation and should be rewritten. *)
resolveSamplePrepOptionsNew[myFunction_, mySamples_List, mySamplePrepOptions_List, myOptions : OptionsPattern[]] := Module[
	{simulatedSamples, resolvedSamplePrepOptions, simulatedCache, existingSimulation, outputSpecification, output,
		gatherTests, resultValue, samplePrepTests, oldCache, oldCacheBadEntriesRemoved, samplePreparationQ},

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];

	(* remove entries from the input cache that have Object -> $Failed *)
	(* TODO ideally we wouldn't have to deal with this but currently UpdateSimulation freaks out if you are adding something like <|Object -> $Failed, Type -> Object[Protocol, ManualSamplePreparation]|> to an existing simulation*)
	(* TODO old download could give you some stuff like this; new download TBD.  So leave this in at least until $FastDownload ships *)
	oldCache = Lookup[ToList[myOptions], Cache, {}];
	oldCacheBadEntriesRemoved = DeleteCases[oldCache, KeyValuePattern[{Object -> $Failed}]];

	(* Call the old function. *)
	{{simulatedSamples, resolvedSamplePrepOptions, simulatedCache}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptions[myFunction, mySamples, mySamplePrepOptions, ReplaceRule[ToList[myOptions], {Cache -> oldCacheBadEntriesRemoved, Output -> {Result, Tests}}]],
		{resolveSamplePrepOptions[myFunction, mySamples, mySamplePrepOptions, ReplaceRule[ToList[myOptions], {Cache -> oldCacheBadEntriesRemoved, Output -> Result}]], {}}
	];

	(* Lookup the simulation option. *)
	existingSimulation = Lookup[ToList[myOptions], Simulation, {}];

	(* Did the function perform any simulation? Don't want to unnecessarily call UpdateSimulation. *)
	(* NOTE: We need to quiet here in case the objects don't exist. *)
	samplePreparationQ=Quiet[!MatchQ[Download[simulatedSamples, Object], Download[mySamples, Object]]];

	(* Convert the cache to a simulation. *)
	resultValue = Which[
		MatchQ[existingSimulation, SimulationP] && !samplePreparationQ,
			{simulatedSamples, resolvedSamplePrepOptions, existingSimulation},
		MatchQ[existingSimulation, SimulationP] && samplePreparationQ,
			{simulatedSamples, resolvedSamplePrepOptions, UpdateSimulation[existingSimulation, Simulation[simulatedCache]]},
		samplePreparationQ,
			{simulatedSamples, resolvedSamplePrepOptions, Simulation[simulatedCache]},
		True,
			{simulatedSamples, resolvedSamplePrepOptions, Simulation[]}
	];

	outputSpecification /. {Result -> resultValue, Tests -> samplePrepTests}
];

(* ::Subsection::Closed:: *)
(*resolvePooledAliquotOptions*)


(* This function simply flattens our pooled options and resolves the sample prep pretending that pools aren't a thing. *)
resolvePooledAliquotOptions[myFunction_,mySamples_List,mySimulatedSamples_List,mySamplePrepOptions_List,myOptions:OptionsPattern[]]:=Module[
	{safeOps,outputSpecification,output,uuidShell,flatUUIDs,flattenedSamples,flattenedSimulatedSamples,flattenedOptions,optionDefinitions,
		repooledOptions,resolvedAliquotOptions,optionSymbol,optionValue,optionDefinition,singletonPattern,
		flattenedOptionValue,numberOfReplicates,pooledQ,samplePreparationOptions,onlySamplePrepOptions,aliquotTests},

	(* get the safe options *)
	safeOps = SafeOptions[resolveAliquotOptions, ToList[myOptions]];

	(* get the output specification/output and cache options *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Replace the objects in our function with UUIDs. *)
	uuidShell=mySamples/.{ObjectP[]:>CreateUUID[]};

	(* Flatten our UUIDs. *)
	flatUUIDs=Flatten[uuidShell];

	(* Flatten our input samples and options. *)
	flattenedSamples=Flatten[mySamples];
	flattenedSimulatedSamples=Flatten[mySimulatedSamples];

	(* Get our option definitions. *)
	optionDefinitions=OverwriteAliquotOptionDefinition[myFunction,OptionDefinition[myFunction]];

	(* Flatten each of our option if it is pooled. *)
	flattenedOptions=Function[{option},
		(* Get the option name and value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Get the definition of our option. *)
		optionDefinition=FirstCase[optionDefinitions,KeyValuePattern["OptionSymbol"->optionSymbol]];

		(* Get the singleton pattern of our option. *)
		singletonPattern=Lookup[optionDefinition,"SingletonPattern",Null];

		(* If our option is pooled, we have to flatten it. *)
		(* AliquotContainer, AliquotSampleLabel, and DestinationWell are really pooled but are not defined as such. *)
		(* Note: This is only in this pooled version for Paul. *)
		If[Lookup[optionDefinition,"NestedIndexMatching",False]||MatchQ[optionSymbol,AliquotContainer|DestinationWell|AliquotSampleLabel],
			(* Our option is pooled. If an element of our list doesn't match the singleton, then it must be a pool. Flatten it. *)
			flattenedOptionValue=(
				If[!MatchQ[#,ReleaseHold[singletonPattern]],
					Sequence@@#,
					#
				]
					&)/@optionValue;

			(* There are possible ambiguities between pooled and singleton options. If the length of our option value still doesn't match the length of our inputs, flatten again. *)
			If[Length[flattenedOptionValue]!=Length[flattenedSamples],
				optionSymbol->Flatten[flattenedOptionValue],
				optionSymbol->flattenedOptionValue
			],
			(* Our option is not pooled. Nothing to do. *)
			option
		]
	]/@mySamplePrepOptions;

	(* See if we have a pooling function. *)
	(* All pooling functions have the first input marked as pooled in their Usage. *)
	pooledQ=Lookup[First[Lookup[Usage[myFunction],"Input"]],"NestedIndexMatching"];

	(* Pooling functions have to have their aliquot simulation stripped out. *)
	samplePreparationOptions=If[pooledQ,
		(* This function only cares about the first three stages of sample preparation (Incubate,Filter,Centrifuge). *)
		(* Strip out any options that we don't need. This is important because we could have a pooled function in which options may be index-matched to pools, messing up mapThreadOptions. *)
		(* As noted earlier, we don't need the Aliquot options, but it's also important to note that the Aliquot options can be pooled for pooled functions, which will also mess us up. *)
		(* Make sure to include NumberOfReplicates as well. *)
		onlySamplePrepOptions=First[splitPrepOptions[flattenedOptions,PrepOptionSets->{IncubatePrepOptionsNew,CentrifugePrepOptionsNew,FilterPrepOptionsNew,AliquotOptions}]];

		If[KeyExistsQ[flattenedOptions,NumberOfReplicates],
			Append[onlySamplePrepOptions,NumberOfReplicates->Lookup[flattenedOptions,NumberOfReplicates]],
			onlySamplePrepOptions
		],
		flattenedOptions
	];

	(* Pass our flattened samples and options to the main resolver. *)
	{resolvedAliquotOptions,aliquotTests}=If[MemberQ[output,Tests],
		resolveAliquotOptions[myFunction,flattenedSamples,flattenedSimulatedSamples,samplePreparationOptions,myOptions],
		{resolveAliquotOptions[myFunction,flattenedSamples,flattenedSimulatedSamples,samplePreparationOptions,myOptions],{}}
	];

	(* Get our samples and options back into the correct pooled format. *)
	repooledOptions=Function[{option},
		(* Get the option name and value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Get the definition of our option. *)
		optionDefinition=FirstCase[optionDefinitions,KeyValuePattern["OptionSymbol"->optionSymbol]];

		(* Get the number of replicates option. *)
		numberOfReplicates=Lookup[mySamplePrepOptions,NumberOfReplicates,Null]/.{Null->1};

		(* If our option is pooled, we have to re-pool it. *)
		If[Lookup[optionDefinition,"NestedIndexMatching",False]||MatchQ[optionSymbol,AliquotContainer|DestinationWell|AliquotSampleLabel],
			(* Does the length of our option match the length of our input? If not, we have to collapse our replicates. *)
			If[Length[optionValue]==Length[mySimulatedSamples],
				optionSymbol->uuidShell/.MapThread[Rule,{flatUUIDs,optionValue}],
				optionSymbol->uuidShell/.MapThread[Rule,{flatUUIDs,optionValue[[;;;;numberOfReplicates]]}]
			],
			(* Our option is not pooled. Nothing to do. *)
			option
		]
	]/@resolvedAliquotOptions;

	(* Return our repooled options. *)
	outputSpecification/.{
		Result->repooledOptions,
		Tests->aliquotTests
	}
];

(* ::Subsection:: *)
(*resolveAliquotOptions*)


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[
	resolveAliquotOptions,
	Options:>{
		{
			OptionName -> RequiredAliquotContainers,
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Model[Container]]|Null|Automatic|{_Integer,ObjectP[{Model[Container],Object[Container]}]}],Size->Line],
			Description -> "The required AliquotContainer for each index-matched sample. If the index-matched sample to this option does not need to be aliquoted into another container, set this corresponding index as Null (and its container will not be changed). To have the container of our samples automatically be determined by ExperimentAliquot, set this option to Automatic (this is not a common use case)."
		},
		{
			OptionName -> RequiredAliquotAmounts,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>{((_?QuantityQ|_?NumericQ|Null)|{(_?QuantityQ|_?NumericQ|Null)..})..},Size->Line],
			Description -> "The required amount of sample required to perform the experiment. If there is a range of amounts that would be acceptable to successfully perform the experiment, choose the smallest amount. Remember to add a buffer amount (ex. 10%) to this amount. If your experiment can operate on solids or volumes, pass the required amount in a list of the required solid or volume amount (depending on whether a buffer is added), index matched to each sample."
		},
		{
			OptionName -> MinimizeTransfers,
			Default -> False,
			Description -> "If samples are requested to go to the same RequiredAliquotContainers and the whole sample is being transferred, consolidate samples into input containers that satisfy the RequiredAliquotContainers option as long as there are no stowaways and are enough wells.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> AllowSolids,
			Default -> False,
			Description -> "Indicates if solid samples are valid inputs to the parent experiment function. If this option is set to False and the resulting sample after the aliquot stage will be a solid, this function will throw an error.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> AllowPoolsWithoutAliquot,
			Default -> False,
			Description -> "Indicates if pools are allowed with the corresponding Aliquot boolean set to False.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> AliquotWarningMessage,
			Default -> Automatic,
			Description -> "The experiment specific warning message that should be thrown when we must aliquot the user's sample for container compatibility reasons. Should be in the form \"because (options/reason why we must transfer the containers). Please (follow up action).\"",
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			]
		},
		CacheOption,
		SimulationOption,
		FastTrackOption,
		OutputOption
	}
];


(* ::Subsubsection:: *)
(*Main Function*)


Error::AliquotOptionConflict="The aliquoting options `1` are specified for sample(s) `2`; however, the overall Aliquot boolean is set to False. If you did not set any of these Aliquot options, this means that the Experiment function needs Aliquot capabilities turned on in order to place your sample in a experiment-compatible container. Please turn on the Aliquot boolean or specify different samples.";
Error::AliquotContainers="The sample(s), `1`, have AliquotContainer->`2`, however, these container(s) are not compatible with the other experimental options selected. Please consider moving the sample(s) into `3` or choose other experimental settings.";
Error::SolidSamplesUnsupported="The solid sample(s), `1`, are not compatible with `2`. Please use the AssayBuffer and AssayVolume options to add buffer to these solid samples so that they are compatible with the experiment.";
Error::PoolWithoutAliquot="The following pool(s), `1`, have their corresponding Aliquot option set to False. `2` requires that pooled inputs must be combined together in order to be specified as valid input to the function. Please change the value of the Aliquot option.";
Error::MissingRequiredAliquotAmounts="The option RequiredAliquotAmounts is REQUIRED by the resolveAliquotOptions function. You MUST specify this option.";
Error::NotEnoughRequiredAmount="The function `1` requires the sample(s) `2` to have at least `3` in order to run the experiment based on the experimental options chosen. The aliquotting options have specified that only `4` will be aliquotted into a new container. Please change the experimental/aliquot options such that there is enough sample available to run the experiment.";
Warning::AliquotRequired="The sample(s) `1`, must be transferred from their current container(s) `2` into `3` `4`";
Error::AliquotSampleLabelConflict="The AliquotSampleLabel option cannot be set to Null if Aliquot is set to True. Please leave this option as Automatic in order for Aliquotting to occur.";

resolveAliquotOptions[myFunction_,mySamples:{ListableP[NonSelfContainedSampleP]..},mySimulatedSamples:{ListableP[ObjectP[Object[Sample]]]..},mySamplePrepOptions:{_Rule..},myOptions:OptionsPattern[]]:=Module[
	{aliquotOptions,rawTargetContainers,targetContainers,invalidAliquotResults,reSimulatedSamples,expandedOriginalSimulatedSamples,targetContainerWithUserOptions,invalidAliquots,
		aliquotContainerTest,resolvedTargetContainers,containerCache,indexMatchingAliquotOptions,resolvedAliquotBools,indexMatchingAliquotOptionsBySample,gatherTests,
		aliquotedSamples,aliquotedOptionsPerSample,aliquotOptionNameMap,renamedAliquotOptions,reCombinedIndexMatchingAliquotOptions,reCombinedAliquotOptions,safeOps,outputSpecification,cache,output,
		resolvedAliquotOptions,aliquotResolutionTests,resolvedAliquotedAliquotOptions,reverseAliquotOptionNameMap,renamedResolvedAliquotedAliquotOptions,messages,aliquotOptionsSetIncorrectly,fastTrack,
		aliquotOptionsSetIncorrectlyTests,resolvedConsolidateAliquots,resolvedAliquotPreparation,notAliquotedSamples,notAliquotedOptionsPerSample,notAliquotedResolvedOptionsPerSample,aliquotedPositions,
		notAliquotedPositions,aliquotedPositionReplaceRules,notAliquotedPositionReplaceRules,numReplicates,resolvedAliquotOptionsPerSample,resolvedIndexMatchingAliquotOptions,resultRule,testsRule,
		resolvedConcBuffer,resolvedStorageCondition,preResolvedAliquotOptions,splitResolvedAliquotedAliquotOptions,resolvedAliquotContainer,resolvedDestinationWells,collapsedAliquotOptionsPerSample,
		resolvedCollapsedIndexMatchingAliquotOptions,expandedAliquotOptions,collapsedAliquotBool,expandedTargetContainers,expandedDestinationWell,expandedSamples,aliquotContainerCollapsed,
		targetContainerObject,aliquotContainerObject,expandedAliquotOptionsWithoutReplicates,nonAliquottedPools,rawAliquotAmounts,targetAliquotAmounts,resolvedAliquotAmount,resolvedAssayVolume,
		expandedTargetAliquotAmounts,invalidRequiredAliquotAmountInputs,resolvedErrorCheckingAmount,resolvedErrorCheckingAmountWithReplicates,developerSpecifiedCompatibleAmount,roundedDeveloperSpecifiedCompatibleAmount,aliquotContainerWarnings,aliquotContainerWarningResults,
		simulation,resolvedAliquotSampleLabels,invalidAliquotSampleLabels,invalidAliquotSampleLabelTests,updatedSimulation,
		simulateResourcePacketsQ},

	(* get the safe options *)
	safeOps = SafeOptions[resolveAliquotOptions, ToList[myOptions]];

	(* get the output specification/output and cache options *)
	{outputSpecification, cache, simulation, fastTrack} = Lookup[safeOps, {Output, Cache, Simulation, FastTrack}];
	output = ToList[outputSpecification];

	(* get the NumberOfReplicates option from myOptions; if it isn't there, then resolve to 1 *)
	numReplicates = Lookup[mySamplePrepOptions, NumberOfReplicates, 1] /. {Null -> 1};

	(* figure out if we are gathering tests or not *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(* split out the aliquot options from the rest *)
	aliquotOptions = First[splitPrepOptions[mySamplePrepOptions, PrepOptionSets -> AliquotOptions]];

	(* determine if we need to simulate the resource packets at this stage *)
	(* at this point the sample prep options will be resolved, so we can check if Incubate/Centrifuge/Filter are set to True *)
	(* since we're in the Aliquot resolver though, this is more challenging for Aliquot *)
	simulateResourcePacketsQ = Or[
		MemberQ[ToList[Lookup[mySamplePrepOptions, Incubate]], True],
		MemberQ[ToList[Lookup[mySamplePrepOptions, Centrifuge]], True],
		MemberQ[ToList[Lookup[mySamplePrepOptions, Filtration]], True],
		(* determining aliquoting by checking if Aliquot is True somewhere, or AssayVolume is set somewhere, or AliquotContainer is set somewhere *)
		(* note that this is just mirroring the logic inside of simulateSamplePreparationPacketsNew *)
		MemberQ[ToList[Lookup[mySamplePrepOptions, Aliquot]], True],
		MemberQ[ToList[Lookup[mySamplePrepOptions, AssayVolume]], VolumeP],
		MemberQ[Flatten[{Lookup[mySamplePrepOptions, AliquotContainer]}], ObjectP[{Object[Container], Model[Container]}]]
	];

	(* Get our simulated samples, past the Filter step. We don't want the aliquot simulation. *)
	(* By taking out the aliquot master switch, we will ensure that aliquot simulation does not happen. *)
	(* Only bother re-simulating if we have the Incubate, Centrifuge, or Filter keys and at least one of them are true. *)
	{reSimulatedSamples, updatedSimulation} = If[simulateResourcePacketsQ,
		simulateSamplesResourcePacketsNew[myFunction, mySamples, mySamplePrepOptions /. {(Aliquot -> _) -> Nothing}, Simulation -> simulation, Cache -> cache],
		{mySamples, simulation}
	];

	(* Make sure we have a path from the sample to the container to the model. *)
	(* NOTE: We memoize this so that we can lazy load (speed) and only download this information if we really need it. *)
	containerCache[]:=containerCache[]=Flatten@Quiet[Download[
		{
			DeleteDuplicates@Flatten[{reSimulatedSamples, mySimulatedSamples}],
			DeleteDuplicates@Flatten[{reSimulatedSamples, mySimulatedSamples}]
		},
		{
			Packet[Container, Mass, Volume, State, Name],
			Packet[Container[{Model, Name}]]
		},
		Cache -> cache,
		Simulation -> updatedSimulation
	]];

	(*-- EXPAND OUR INDEX-MATCHING OPTIONS --*)
	(* expand the aliquot options in accordance with NumberOfReplicates *)
	expandedAliquotOptions = MapThread[
		Function[{optionName, optionValue},
			(* Our singleton options don't need to be expanded out. *)
			If[MatchQ[optionName, ConsolidateAliquots | AliquotPreparation],
				optionName -> optionValue,
				(* TargetContainer and DestinationWell are "fake" index matched. Don't expand if we don't need to. *)
				If[Length[optionValue]==Length[mySamples]*numReplicates,
					optionName -> optionValue,
					optionName -> Map[
						(Sequence@@ConstantArray[#, numReplicates]&),
						optionValue
					]
				]
			]
		],
		{Keys[aliquotOptions], Values[aliquotOptions]}
	];

	(* Also expand our options without NumberOfReplicates *)
	expandedAliquotOptionsWithoutReplicates = MapThread[
		Function[{optionName, optionValue},
			(* Our singleton options don't need to be expanded out. *)
			If[MatchQ[optionName, ConsolidateAliquots | AliquotPreparation],
				optionName -> optionValue,
				(* Make sure that our "fake index matched" options aren't expanded already to the replicates. *)
				If[Length[optionValue]==Length[mySamples]*numReplicates,
					optionName -> optionValue[[;;;;numReplicates]],
					optionName -> optionValue
				]
			]
		],
		{Keys[aliquotOptions], Values[aliquotOptions]}
	];

	(* get the index matching shared aliquot options *)
	(* note that this does NOT include the Aliquot option itself *)
	indexMatchingAliquotOptions = {AliquotSampleLabel, AliquotAmount, TargetConcentration, TargetConcentrationAnalyte, AssayVolume, AliquotContainer, DestinationWell, ConcentratedBuffer, BufferDilutionFactor, BufferDiluent, AssayBuffer, AliquotSampleStorageCondition};

	(* -- RESOLVE TARGET CONTAINER AND CHECK FOR ERRORS -- *)
	(* Lookup the RequiredAliquotContainers option. *)
	rawTargetContainers=Lookup[safeOps,RequiredAliquotContainers];

	(* If RequiredAliquotContainers is not specified (the default is Null), expand it. *)
	(* TargetContainer specifies that the developer wants the sample to move into another container. *)
	(* If the developer wants the sample to be in the same container as it currently is in (whether aliquoting happens or not), it will be set to Null at the corresponding index. *)
	targetContainers=If[MatchQ[rawTargetContainers,Null|Automatic],
		ConstantArray[rawTargetContainers,Length[mySamples]],
		(* We were given a list of target containers. *)
		MapThread[
			Function[{targetContainer,aliquot, aliquotSampleLabel, aliquotAmount, targetConc, targetConcAnalyte, assayVolume, aliquotContainer, destinationWell, concBuffer, bufferDilutionFactor, bufferDiluent, assayBuffer, storageCondition,sample},
				Module[{container, containerModel},
					(* Get the container of our sample. *)
					container = Lookup[fetchPacketFromCache[sample,containerCache[]],Container,Null];

					(* Get the container of our sample. *)
					containerModel = If[NullQ[container],
						Null,
						Lookup[fetchPacketFromCache[container,containerCache[]], Model, Automatic] /. {link:LinkP[]:>Download[link,Object]}
					];

					(* If the container of our sample is the same as the provided target container, we may change it to Null (no aliquot). Otherwise, leave it alone. *)
					If[MatchQ[containerModel,ObjectP[targetContainer]|Automatic|Null|{_,ObjectP[targetContainer]}],
						(* Were any other aliquot options set for this sample? If so, we are going to perform an aliquot. If not, there should be no aliquot. *)
						(* We also perform an aliquot if given a pooled sample group. *)
						If[MatchQ[sample, _List?(Length[#]>1&)]||MemberQ[{aliquot, aliquotAmount, targetConc, targetConcAnalyte, assayVolume, aliquotContainer, destinationWell, concBuffer, bufferDilutionFactor, bufferDiluent, assayBuffer, storageCondition}, Except[Null|False|Automatic|{Automatic,Automatic}]],
							(* There's going to be an aliquot. Maintain the target container so that the ExperimentAliquot resolver doesn't try to resolve it to PreferredContainer. *)
							targetContainer,
							(* There's not going to be an aliquot. Set the target container to Null. *)
							Null
						],
						targetContainer
					]
				]
			],
			{rawTargetContainers,Sequence@@Lookup[expandedAliquotOptionsWithoutReplicates, Prepend[indexMatchingAliquotOptions, Aliquot]], reSimulatedSamples}
		]
	];

	(* Make sure that AliquotContainer index-matches to mySamples since that's the format of TargetAliquotContainer. *)
	aliquotContainerCollapsed=If[Length[Lookup[mySamplePrepOptions,AliquotContainer]]!=Length[mySamples],
		Lookup[mySamplePrepOptions,AliquotContainer][[;;;;numReplicates]],
		Lookup[mySamplePrepOptions,AliquotContainer]
	];

	(* Make sure that if the developer specified a target container that the user didn't also specify a target container. *)
	(* If we need to set AliquotContainers to facilitate a transfer, make sure that the user didn't already set it. *)
	(* If they did, collect the containers they set to throw an error. *)
	{targetContainerWithUserOptions,invalidAliquotResults,aliquotContainerWarnings}=Transpose[MapThread[
		Function[{targetContainer,aliquotContainer,aliquotAmount,simulatedSample,originalSample,aliquotOptions},
			(* Did the user give us an AliquotContainer? *)
			If[MatchQ[aliquotContainer,Except[Automatic|{Automatic,Automatic}]],
				(* User gave us an aliquot container. *)

				(* Do we have targetContainer set by the developer? *)
				If[MatchQ[targetContainer,Null|Automatic|{Automatic,Automatic}],
					(* targetContainer is not set. *)
					(* resolveSamplePrepOptions will simulate an aliquot change for us when the user sets AliquotContainer for a sample. *)
					(* This is because experiment functions will only transfer into preferred containers but if the user wants to explicitly use a non-preferred container that is compatible with our experiment, that should be allowed. *)
					(* This means that we should resolve our aliquot options for this sample based on the original sample, not the simulated sample. *)
					(* Set the aliquot container to the simulated sample's container. *)
					{aliquotContainer,{},{}},

					(* ELSE: targetContainer is set. *)
					(* Get the object of the target container and aliquot container. *)
					targetContainerObject=If[MatchQ[targetContainer,_List],
						Quiet[Download[targetContainer[[2]],Object]],
						Quiet[Download[targetContainer,Object]]
					];
					aliquotContainerObject=If[MatchQ[aliquotContainer,_List],
						Quiet[Download[aliquotContainer[[2]],Object]],
						Quiet[Download[aliquotContainer,Object]]
					];

					(* Is aliquot container the same as target aliquot container (or if the objects are the same)? *)
					If[MatchQ[targetContainer,aliquotContainer]||MatchQ[targetContainerObject,aliquotContainerObject],
						(* TargetContainer and AliquotTargetContainer are the same. Throw no error. *)
						{aliquotContainer,{},{}},
						(* The user gave us an aliquotContainer and targetContainer is set. *)
						(* resolveSamplePrepOptions will simulate an aliquot change for us when the user sets AliquotContainer for a sample. *)
						(* This means that we need to do an aliquot because the experiment is not compatible with the container that the user gave us. *)
						(* Throw an error. *)
						{aliquotContainer,{simulatedSample,aliquotContainer,targetContainer},{}}
					]
				],
				(* The user didn't give us an aliquot container. *)
				(* If the target container is not Null or Automatic and there are no aliquot options set, make sure to warn the user that we're going to aliquot if none of the aliquot options are set except consolidate aliquots. *)
				If[MatchQ[targetContainer,Null|Automatic]||MemberQ[KeyDrop[aliquotOptions,ConsolidateAliquots],Except[ListableP[Null|Automatic]]],
					{targetContainer,{},{}},
					{targetContainer,{},{simulatedSample,cacheLookup[containerCache[], simulatedSample, {Container, Model}],targetContainer}}
				]
			]
		],
		{targetContainers,aliquotContainerCollapsed,Lookup[mySamplePrepOptions,AliquotAmount],reSimulatedSamples,mySamples,OptionsHandling`Private`mapThreadOptions[ExperimentAliquot,expandedAliquotOptionsWithoutReplicates]}
	]];

	(* Get rid of empty results. *)
	aliquotContainerWarningResults=aliquotContainerWarnings/.{{}->Nothing};

	(* If we must aliquot because of an incompatible container, throw a warning to the user. *)
	(* If the developer set this option to Null, they are throwing their own more specific message. *)
	If[Length[aliquotContainerWarningResults]>0 && !MatchQ[Lookup[safeOps,AliquotWarningMessage],Null] && !MatchQ[$ECLApplication, Engine],
		(* Lookup our explanation from the developer as to why we need to aliquot. *)
		(* Throw our error message. *)
		Message[
			Warning::AliquotRequired,
			ObjectToString[aliquotContainerWarningResults[[All,1]],Cache->cache],
			ObjectToString[aliquotContainerWarningResults[[All,2]],Cache->cache],
			ObjectToString[aliquotContainerWarningResults[[All,3]],Cache->cache],
			Lookup[safeOps,AliquotWarningMessage]/.{Automatic->"because the sample's current containers are not compatible with the experimental options that are provided. Please choose different experimental options if an aliquot is not wanted."}
		];
		Null
	];

	(* expand the re-simulated samples *)
	expandedSamples = Map[
		Sequence@@ConstantArray[#, numReplicates]&,
		reSimulatedSamples
	];

	(* expand the original simulated samples *)
	expandedOriginalSimulatedSamples = Map[
		Sequence@@ConstantArray[#, numReplicates]&,
		mySimulatedSamples
	];

	(* expand TargetContainers with NumberOfReplicates *)
	expandedTargetContainers = Map[
		(Sequence@@ConstantArray[#, numReplicates]&),
		targetContainerWithUserOptions
	];

	(* expand DestinationWell with NumberOfReplicates *)
	expandedDestinationWell = If[Length[Lookup[mySamplePrepOptions,DestinationWell]]!=Length[expandedSamples],
		Map[
			(Sequence@@ConstantArray[#, numReplicates]&),
			Lookup[mySamplePrepOptions,DestinationWell]
		],
		Lookup[mySamplePrepOptions,DestinationWell]
	];

	(* Filter out {} from invalidAliquotResults. *)
	invalidAliquots=invalidAliquotResults/.{{}->Nothing};

	(* If there are invalid options and we are throwing messages, throw an error message and keep track of our invalid options for Error::InvalidOptions. *)
	If[Length[invalidAliquots]>0&&!gatherTests,
		Message[Error::AliquotContainers,ObjectToString[invalidAliquots[[All,1]],Cache->cache],ObjectToString[invalidAliquots[[All,2]],Cache->cache],ObjectToString[invalidAliquots[[All,3]],Cache->cache]];
		Message[Error::InvalidOption,AliquotContainer];
	];

	(* Create the corresponding test for the aliquot container incompatible error. *)
	aliquotContainerTest=If[gatherTests,
	(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=invalidAliquots[[All,1]];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[mySamples,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following samples, "<>ObjectToString[failingInputs,Cache->cache]<>" have valid aliquot container specifications.",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following samples, "<>ObjectToString[passingInputs,Cache->cache]<>" have valid aliquot container specifications.",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* --- Manually resolve a few options --- *)
	(* get the resolved Aliquot bool; this is True if anything is specified, and false if nothing is specified*)
	(* It is important to note that the RequiredAliquotAmount option does not switch on our aliquotting ability. We will only use it in pre-resolving if we decided here that we're going to aliquot. *)
	resolvedAliquotBools = MapThread[
		Function[{sample, aliquot, aliquotSampleLabel, aliquotAmount, targetConc, targetConcAnalyte, assayVolume, aliquotContainer, destinationWell, concBuffer, bufferDilutionFactor, bufferDiluent, assayBuffer, storageCondition, targetContainer},
			Which[
				(* if Aliquot is specified, use that *)
				MatchQ[aliquot, BooleanP], aliquot,

				(* Do we have a pooled sample group (of more than one sample)? If so, we should default the Aliquot option to True. *)
				(* note: ExperimentImageCells accepts pooled inputs but does not want samples to be aliquoted unless other aliquot options are specified *)
				MatchQ[sample, _List?(Length[#]>1&)]&&MatchQ[myFunction,Except[ExperimentImageCells]], True,

				(* if any of the other aliquot options are anything besides Null or Automatic, then resolve aliquot to True *)
				MemberQ[Flatten[{aliquotSampleLabel, aliquotAmount, targetConc, targetConcAnalyte, assayVolume, aliquotContainer, destinationWell, concBuffer, bufferDilutionFactor, bufferDiluent, assayBuffer, storageCondition, targetContainer}], Except[Null|Automatic]], True,

				(* otherwise resolve to False *)
				True, False
			]
		],
		(* Lookup our aliquot index-matching options and append our target containers to it. *)
		{expandedSamples, Sequence@@Lookup[expandedAliquotOptions, Prepend[indexMatchingAliquotOptions, Aliquot]], expandedTargetContainers}
	];

	(* resolve the ConsolidateAliquots option; if we got this far and it's still Automatic, just resolve to False UNLESS Aliquot -> {False..}, in which case resolve to Null *)
	(* default isn't False because want to allow parent functions to pre-resolve *)
	resolvedConsolidateAliquots = Which[
		MatchQ[Lookup[expandedAliquotOptions, ConsolidateAliquots], Automatic] && MatchQ[resolvedAliquotBools, {False..}], Null,
		MatchQ[Lookup[expandedAliquotOptions, ConsolidateAliquots], Automatic], False,
		True, Lookup[expandedAliquotOptions, ConsolidateAliquots]
	];

	(* resolve the AliquotSampleLabel option, if we have it. *)
	(* NOTE: Like the other label options, this is hidden when running the experiment function "standalone" and is only used *)
	(* in the primitives. *)
	resolvedAliquotSampleLabels=If[MatchQ[resolvedConsolidateAliquots, False],
		(* if we DO NOT consolidate, make a unique label for each entry *)
		MapThread[
			Function[{aliquotOption, aliquotSampleLabel},
				Which[
					MatchQ[aliquotSampleLabel, Except[Automatic]], aliquotSampleLabel,
					MatchQ[aliquotOption, True], ToLowerCase[StringReplace[ToString[myFunction], "Experiment" -> ""]]<>" aliquot sample "<>ToString[Unique[]],
					True, Null
				]
			],
			{resolvedAliquotBools, Lookup[expandedAliquotOptions, AliquotSampleLabel]}
		],
		(* if we DO consolidate aliquots, we need to give only one label to each group of consolidated ones *)
		Which[
			MatchQ[Lookup[expandedAliquotOptions, AliquotSampleLabel], Except[{Automatic..}]],
			Lookup[expandedAliquotOptions, AliquotSampleLabel],

			MemberQ[resolvedAliquotBools, True],
			Module[{aliquotFalsePositions, aliquotTruePositions, aliquotTrueSamples, aliquotFalseLabels, aliquotFalseTuples,
				aliquotLabelSpecifiedPositions,aliquotLabelSpecifiedLabels, aliquotLabelSpecifiedTuples,
				uniqueAliquotLabelsLength, uniqueAliquotLabels,uniqueAliquotSampleToLabelRule,
				expandedLabels, aliquotTrueTuples},

				aliquotFalsePositions = Cases[Flatten@Position[resolvedAliquotBools,False,{1}],_Integer];
				aliquotFalseLabels = ConstantArray[Null, Length[aliquotFalsePositions]];
				aliquotFalseTuples = Transpose[{aliquotFalseLabels, aliquotFalsePositions}];

				aliquotLabelSpecifiedPositions = DeleteCases[Cases[Flatten@Position[Lookup[expandedAliquotOptions, AliquotSampleLabel],Except[Automatic],{1}],_Integer],0];
				aliquotLabelSpecifiedLabels = Cases[Lookup[expandedAliquotOptions, AliquotSampleLabel], Except[Automatic]];
				aliquotLabelSpecifiedTuples = Transpose[{aliquotLabelSpecifiedLabels, aliquotLabelSpecifiedPositions}];

				aliquotTruePositions = Complement[Range[Length[resolvedAliquotBools]],aliquotFalsePositions, aliquotLabelSpecifiedPositions];
				aliquotTrueSamples = Part[Download[expandedSamples,Object],aliquotTruePositions];
				uniqueAliquotLabelsLength = Length[DeleteDuplicates[aliquotTrueSamples]];
				uniqueAliquotLabels = Table[(ToLowerCase[StringReplace[ToString[myFunction], "Experiment" -> ""]]<>" aliquot sample "<>ToString[Unique[]]),
					uniqueAliquotLabelsLength];
				uniqueAliquotSampleToLabelRule = MapThread[(#1->#2)&,{DeleteDuplicates[aliquotTrueSamples],uniqueAliquotLabels}];
				expandedLabels = aliquotTrueSamples/.uniqueAliquotSampleToLabelRule;
				aliquotTrueTuples = Transpose[{expandedLabels, aliquotTruePositions}];

				SortBy[Join[aliquotTrueTuples, aliquotFalseTuples, aliquotLabelSpecifiedTuples],Last][[All,1]]
			],

			True,
			ConstantArray[Null, Length[resolvedAliquotBools]]
		]
	];

	(* check to make sure the aliquot options were not set if Aliquot -> False *)
	(* We ListableP the pattern here because of pooling. *)
	invalidAliquotSampleLabels = MapThread[
		If[MatchQ[{#1, #2}, {True, Except[_String]}|{False, _String}],
			#2,
			Nothing
		]&,
		{resolvedAliquotBools, resolvedAliquotSampleLabels}
	];

	(* generate the tests for if the aliquot options were set incorrectly or not, and throw messages if necessary *)
	invalidAliquotSampleLabelTests = If[Not[fastTrack],
		Module[{passingInputs, failingInputTest, passingInputTest},

			(* get the inputs whose filter options are fine *)
			passingInputs = Complement[resolvedAliquotSampleLabels, invalidAliquotSampleLabels];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[invalidAliquotSampleLabels] > 0 && gatherTests,
				Test["AliquotSampleLabel is not set to Null if Aliquotting is turned on for labels " <> ToString[invalidAliquotSampleLabels]<>":",
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["AliquotSampleLabel is not set to Null if Aliquotting is turned on for labels " <> ToString[passingInputs]<>":",
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			If[Length[invalidAliquotSampleLabels] > 0 && messages,
				Message[Error::AliquotSampleLabelConflict];
				Message[Error::InvalidOption, {AliquotSampleLabel}]
			];

			(* Return our created tests. *)
			{passingInputTest, failingInputTest}
		],
		{}
	];

	(* resolve the ConcentratedBuffer and AliquotSampleStorageCondition options; all this means is turn an Automatic to a Null *)
	resolvedConcBuffer = Lookup[expandedAliquotOptions, ConcentratedBuffer] /. {Automatic -> Null};
	resolvedStorageCondition = Lookup[expandedAliquotOptions, AliquotSampleStorageCondition] /. {Automatic -> Null};

	(* If Aliquot\[Rule]True and TargetContainer has Null at the corresponding index, choose the container that the sample is already in. *)
	resolvedTargetContainers=MapThread[
		Function[{aliquotBool,targetContainer,sample,originalSimulatedSample},
			(* Are we are aliquoting this sample? *)
			If[aliquotBool,
				(* Yes. Is TargetContainer Null (keep the container the same)? *)
				If[MatchQ[targetContainer,Null],
					(* Yes. Use the container of our sample. *)
					(* Note: Since this function supports pooled inputs, there is no container to keep the same if given a pooling list. *)
					If[MatchQ[originalSimulatedSample,_List],
						Automatic,
						(* Note: Use the original simulated sample that came out of resolveSamplePrepOptions because that's what the experiment writer checks on to set TargetAliquotContainer. *)
						Lookup[fetchPacketFromCache[Lookup[fetchPacketFromCache[originalSimulatedSample,containerCache[]],Container,Null],containerCache[]],Model,Automatic]/.{link_Link:>Download[link, Object]}
					],
					(* No. Use the target container. *)
					targetContainer
				],
				(* No. Just use targetContainer. *)
				targetContainer
			]
		],
		{resolvedAliquotBools,expandedTargetContainers,expandedSamples,expandedOriginalSimulatedSamples}
	];

	(*-- ALIQUOT AMOUNT PRE-RESOLVING AND MORE ERROR CHECKING --*)
	(* Lookup the RequiredAliquotAmounts option. *)
	rawAliquotAmounts=Lookup[safeOps,RequiredAliquotAmounts];

	(* Expand our aliquot amounts option. If not given anything by the developer go with {Null..} since we don't want to affect the user. *)
	(* Make sure that our singleton elements of the list are in a list. *)
	targetAliquotAmounts=If[MatchQ[rawAliquotAmounts,Automatic],

		(* If the developer doesn't give us the RequiredAliquotAmounts option, throw an error. Only show the error when a developer is logged in because users shouldn't care. Do not throw the message in engine. *)
		If[!MatchQ[$ECLApplication,Engine]&&MatchQ[$PersonID, ObjectP[Object[User,Emerald,Developer]]],
			Message[Error::MissingRequiredAliquotAmounts]
		];

		ConstantArray[{Null},Length[mySamples]],
		(* We were given an option by the developer. *)
		(* Expand it if it isn't a list. *)
		If[MatchQ[rawAliquotAmounts,_List]&&MatchQ[Length[rawAliquotAmounts],Length[mySamples]],
			ToList/@rawAliquotAmounts,
			ConstantArray[ToList[rawAliquotAmounts],Length[mySamples]]
		]
	];

	(* Expand our target aliquot amounts in accordance to NumberOfReplicates. *)
	expandedTargetAliquotAmounts=Map[
		Sequence@@ConstantArray[#, numReplicates]&,
		targetAliquotAmounts
	];

	(* If we are aliquotting a sample, we might pre-resolve some options based on RequiredAliquotAmounts: *)
	{resolvedAliquotAmount,resolvedAssayVolume}=Transpose[MapThread[
		Function[{sampleGroup,mappedAliquotOptions,targetAliquotAmount,resolvedAliquotBool},
			(* Are we not aliquotting this sample or is our target amount Null (the developer doesn't care about the amount)? *)
			If[MatchQ[resolvedAliquotBool,False]||MatchQ[targetAliquotAmount,{Null}],
				(* Yes. Do not change the AliquotAmount or AssayVolume options. *)
				Lookup[mappedAliquotOptions,{AliquotAmount,AssayVolume}],
				(* No. Pre-resolve based on what options are set. *)

				(* Is AliquotAmount or AliquotVolume already set? *)
				If[MatchQ[Lookup[mappedAliquotOptions,AliquotAmount],ListableP[(_?QuantityQ|_?NumericQ)|Null]]||MatchQ[Lookup[mappedAliquotOptions,AssayVolume],ListableP[VolumeP|Null]],
					(* Yes. Do not pre-resolve anything. We will error check later. *)
					Lookup[mappedAliquotOptions,{AliquotAmount,AssayVolume}],
					(* No - neither are set. *)

					(* Are we pooling? This will be indicated if our current sample list has more than one sample. *)
					If[Length[ToList[sampleGroup]]>1,
						(* Yes - we are pooling. When pooling, always pass RequiredAliquotAmount to the AssayVolume option. *)
						(* ExperimentAliquot will throw an error if the buffer options are not set. *)
						{Lookup[mappedAliquotOptions,AliquotAmount],First[targetAliquotAmount]},

						(* No - we are not pooling. *)
						(* Were we given a count/mass and not a volume for our target? *)
						If[MatchQ[targetAliquotAmount,{Except[VolumeP]..}],
							(* Set AliquotAmount to our target. *)
							{First[targetAliquotAmount],Lookup[mappedAliquotOptions,AssayVolume]},
							(* No, we were given a volume as well. *)

							(* Are any of our buffer options set? *)
						If[MemberQ[Flatten[Lookup[mappedAliquotOptions,{TargetConcentration,TargetConcentrationAnalyte,ConcentratedBuffer,BufferDilutionFactor,BufferDiluent,AssayBuffer}]],Except[Null|Automatic]],
									(* Yes - set AssayVolume to our given volume since we are going to dilute and end up with a volume. *)
								{Lookup[mappedAliquotOptions,AliquotAmount],FirstCase[targetAliquotAmount,VolumeP]},
								(* No - set our first given value to AliquotAmount. *)
								{First[targetAliquotAmount],Lookup[mappedAliquotOptions,AssayVolume]}
							]
						]
					]
				]
			]
		],
		(* Because ExperimentFillToVolume does not actually have the AliquotOptions shared option set we must exchange it with one that does *)
		{expandedSamples,OptionsHandling`Private`mapThreadOptions[myFunction /. {ExperimentFillToVolume -> ExperimentFilter},expandedAliquotOptions],expandedTargetAliquotAmounts,resolvedAliquotBools}
	]];

	(* pass the pre-resolved options into the aliquot options *)
	preResolvedAliquotOptions = ReplaceRule[
		expandedAliquotOptions,
		{
			ConsolidateAliquots -> resolvedConsolidateAliquots,
			ConcentratedBuffer -> resolvedConcBuffer,
			AliquotSampleStorageCondition -> resolvedStorageCondition,
			AliquotContainer -> resolvedTargetContainers,
			DestinationWell -> expandedDestinationWell,
			AliquotAmount -> resolvedAliquotAmount,
			AssayVolume -> resolvedAssayVolume,
			AliquotSampleLabel -> resolvedAliquotSampleLabels
		}
	];

	(* split out the aliquot options by sample *)
	indexMatchingAliquotOptionsBySample = Table[
		Map[
			# -> Lookup[preResolvedAliquotOptions, #][[index]]&,
			indexMatchingAliquotOptions
		],
		{index, Range[Length[expandedSamples]]}
	];

	(* check to make sure the aliquot options were not set if Aliquot -> False *)
	(* We ListableP the pattern here because of pooling. *)
	aliquotOptionsSetIncorrectly = MapThread[
		MatchQ[#1, False] && MemberQ[Flatten[Lookup[#2, indexMatchingAliquotOptions]], Except[ListableP[Null|Automatic|{Automatic,Automatic}]]]&,
		{resolvedAliquotBools, indexMatchingAliquotOptionsBySample}
	];

	(* generate the tests for if the aliquot options were set incorrectly or not, and throw messages if necessary *)
	aliquotOptionsSetIncorrectlyTests = If[Not[fastTrack],
		Module[{failingInputs, passingInputs, failingInputTest, passingInputTest, failingAliquotOptions},

			(* get the inputs that have correspondingly-bad aliquot options *)
			failingInputs = PickList[expandedSamples, aliquotOptionsSetIncorrectly];

			(* get the failing aliquot options *)
			failingAliquotOptions = MapThread[
				If[TrueQ[#1],
					PickList[indexMatchingAliquotOptions, Lookup[#2, indexMatchingAliquotOptions], Except[ListableP[Automatic|Null|{Automatic,Automatic}]]],
					Nothing
				]&,
				{aliquotOptionsSetIncorrectly, indexMatchingAliquotOptionsBySample}
			];

			(* get the inputs whose filter options are fine *)
			passingInputs = PickList[expandedSamples, aliquotOptionsSetIncorrectly, False];

			(* create a test for the non-passing inputs *)
			failingInputTest = If[Length[failingInputs] > 0 && gatherTests,
				Test["Aliquot options are not specified for the following if Aliquot is set to False: " <> ObjectToString[failingInputs,Cache->cache],
					True,
					False
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTest = If[Length[passingInputs] > 0 && gatherTests,
				Test["Aliquot options are not specified for the following if Aliquot is set to False: " <> ObjectToString[passingInputs,Cache->cache],
					True,
					True
				],
				Nothing
			];

			(* throw an error if we need to do so and are throwing messages *)
			If[Length[failingInputs] > 0 && messages,
				Message[Error::AliquotOptionConflict, failingAliquotOptions, failingInputs];
				Message[Error::InvalidOption, Flatten[{Aliquot, DeleteDuplicates[Flatten[failingAliquotOptions]]}]]
			];

			(* Return our created tests. *)
			{passingInputTest, failingInputTest}
		],
		{}
	];

	(* get the samples that are going to be aliquoted and the options that these correspond to (and also the other options too) *)
	aliquotedSamples = PickList[expandedSamples, resolvedAliquotBools];
	aliquotedOptionsPerSample = Map[
		If[NullQ[Lookup[#,AliquotSampleLabel]],
			(* SampleOutLabel in ExperimentAliquot cannot be Null. We have thrown Error::AliquotSampleLabelConflict earlier so we want to change it to Automatic now for ExperimentAliquot *)
			(* At the final resolvedAliquotOptions stage, we still use resolvedAliquotSampleLabel, which will reset this temporary change *)
			ReplaceRule[#,{AliquotSampleLabel->Automatic}],
			#
		]&,
		PickList[indexMatchingAliquotOptionsBySample, resolvedAliquotBools]
	];

	(* re-combine the options *)
	reCombinedIndexMatchingAliquotOptions = Normal[Merge[aliquotedOptionsPerSample, Join]];

	(* add the non-index-matching options back *)
	reCombinedAliquotOptions = Join[
		reCombinedIndexMatchingAliquotOptions,
		{ConsolidateAliquots -> resolvedConsolidateAliquots, AliquotPreparation -> Lookup[preResolvedAliquotOptions, AliquotPreparation]}
	];

	(* define a mapping between the aliquot options and the actual options that ExperimentAliquot uses *)
	aliquotOptionNameMap = {
		AliquotAmount -> Amount,
		AliquotContainer -> ContainerOut,
		AliquotSampleStorageCondition -> SamplesOutStorageCondition,
		AliquotPreparation -> Preparation,
		AliquotSampleLabel -> SampleOutLabel
	};

	(* rename the aliquot options *)
	(* also don't pass down the AliquotSampleLabel option. *)
	renamedAliquotOptions = reCombinedAliquotOptions /. aliquotOptionNameMap;

	(* Start a new label session. This is so that label resolution in ExperimentAliquot is deterministic and therefore *)
	(* the caches inside of the primitive framework can work correctly. *)
	StartUniqueLabelsSession[];

	(* call the ExperimentAliquot resolver *)
	{resolvedAliquotedAliquotOptions, aliquotResolutionTests} = Which[
		MatchQ[aliquotedSamples, {}], {{}, {}},
		gatherTests, ExperimentAliquot[aliquotedSamples, ReplaceRule[renamedAliquotOptions, {Output -> {Options, Tests}, Cache -> cache, Simulation -> updatedSimulation, EnableSamplePreparation -> True}]],
		True, {ExperimentAliquot[aliquotedSamples, ReplaceRule[renamedAliquotOptions, {Output -> Options, Cache -> cache, Simulation -> updatedSimulation, EnableSamplePreparation -> True}]], Null}
	];

	(* End the new label session. *)
	EndUniqueLabelsSession[];

	(* reverse our earlier lookup to get a map back to the shared aliquot options *)
	reverseAliquotOptionNameMap = Reverse /@ aliquotOptionNameMap;

	(* get the resolved aliquot options with the shared aliquot option names *)
	renamedResolvedAliquotedAliquotOptions = resolvedAliquotedAliquotOptions /. reverseAliquotOptionNameMap;

	(* pull out the resolved AliquotPreparation *)
	(* if we're not aliquoting at all (i.e., this is an empty list), resolve to Null *)
	resolvedAliquotPreparation = Which[
		MatchQ[Lookup[expandedAliquotOptions, AliquotPreparation], Automatic] && MatchQ[resolvedAliquotBools, {False..}], Null,
		MatchQ[Lookup[expandedAliquotOptions, AliquotPreparation], Automatic], Lookup[renamedResolvedAliquotedAliquotOptions, AliquotPreparation, Null],
		True, Lookup[expandedAliquotOptions, AliquotPreparation]
	];

	(* need to re-split the resolved aliquoted aliquot options *)
	splitResolvedAliquotedAliquotOptions = Table[
		Map[
			# -> Lookup[renamedResolvedAliquotedAliquotOptions, #][[index]]&,
			indexMatchingAliquotOptions
		],
		{index, Range[Length[aliquotedSamples]]}
	];

	(* get the not-aliquoted options and samples *)
	notAliquotedSamples = PickList[expandedSamples, resolvedAliquotBools, False];
	notAliquotedOptionsPerSample = PickList[indexMatchingAliquotOptionsBySample, resolvedAliquotBools, False];

	(* for all the non-aliquoted values, change all the Automatics to Null or False*)
	(* this is a little goofier for the ContainerOut option because the Automatics can be nested *)
	notAliquotedResolvedOptionsPerSample = Map[
		If[MatchQ[Keys[#], AliquotContainer] && MatchQ[Values[#], ListableP[Null|Automatic]],
			Keys[#] -> Null,
			# /. {Automatic -> Null}
		]&,
		notAliquotedOptionsPerSample,
		{2}
	];

	(* get the positions of the places where we are actually aliquoting vs not *)
	aliquotedPositions = Position[resolvedAliquotBools, True];
	notAliquotedPositions = Position[resolvedAliquotBools, False];

	(* make replace rules for ReplacePart for the aliquoted and not-aliquoted resolved options we have *)
	aliquotedPositionReplaceRules = MapThread[#1 -> #2&, {aliquotedPositions, splitResolvedAliquotedAliquotOptions}];
	notAliquotedPositionReplaceRules = MapThread[#1 -> #2&, {notAliquotedPositions, notAliquotedResolvedOptionsPerSample}];

	(* get the resolved aliquot options per sample *)
	resolvedAliquotOptionsPerSample = ReplacePart[resolvedAliquotBools, Flatten[{aliquotedPositionReplaceRules, notAliquotedPositionReplaceRules}]];

	(* combine all the resolved options together *)
	resolvedIndexMatchingAliquotOptions = Normal[Merge[resolvedAliquotOptionsPerSample, Join]];

	(* going to get a little goofy here.  pull out the AliquotContainer option from this totally expanded set of options *)
	resolvedAliquotContainer = Lookup[resolvedIndexMatchingAliquotOptions, AliquotContainer];
	resolvedDestinationWells = Lookup[resolvedIndexMatchingAliquotOptions, DestinationWell];

	(* now collapse all the aliquoting options in accordance with NumberOfReplicates *)
	(* to do this, we need to get every other element starting with the first with steps of length numReplicates (do this with the weird Part thing) *)
	(* if NumberOfReplicates is Null or 1 though, just stick with what we have *)
	collapsedAliquotOptionsPerSample = If[MatchQ[numReplicates, GreaterEqualP[2, 1]],
		resolvedAliquotOptionsPerSample[[1 ;; Length[resolvedAliquotOptionsPerSample] ;; numReplicates]],
		resolvedAliquotOptionsPerSample
	];

	(* combine the collapsed resolved options together *)
	resolvedCollapsedIndexMatchingAliquotOptions = Normal[Merge[collapsedAliquotOptionsPerSample, Join]];

	(* collapse the Aliquot bool *)
	collapsedAliquotBool = If[MatchQ[numReplicates, GreaterEqualP[2, 1]],
		resolvedAliquotBools[[1 ;; Length[resolvedAliquotBools] ;; numReplicates]],
		resolvedAliquotBools
	];

	(*-- FINAL ERROR CHECKING --*)

	(* get the resolved options *)
	(* importantly, I am replacing with the not-collapsed version of AliquotContainer since it's not technically an index matching option *)
	resolvedAliquotOptions = ReplaceRule[
		resolvedCollapsedIndexMatchingAliquotOptions,
		{
			Aliquot -> collapsedAliquotBool,
			ConsolidateAliquots -> resolvedConsolidateAliquots,
			AliquotPreparation -> resolvedAliquotPreparation,
			AliquotContainer -> resolvedAliquotContainer,
			DestinationWell->resolvedDestinationWells,
			AliquotSampleLabel->resolvedAliquotSampleLabels
		}
	];

	(*-- Make sure that if we aliquotted, we have respected the developer set RequiredAliquotAmount. --*)
	invalidRequiredAliquotAmountInputs=MapThread[
		Function[{sample,aliquotBoolean,aliquotAmount,assayVolume,targetAliquotAmount},
			(* Only check if we are aliquotting the given sample. *)
			If[MatchQ[aliquotBoolean,False],
				(* No error checking needed. FRQ will catch any problems. *)
				Nothing,
				(* Error checking needed. *)

				(* Is AssayVolume Null? If it is, error check based on AliquotAmount. *)
				resolvedErrorCheckingAmount=If[MatchQ[assayVolume,Null],
					aliquotAmount,
					assayVolume
				];

				(* Get the developer specified amount that is compatible with the resolved AliquotAmount. *)
				developerSpecifiedCompatibleAmount=FirstCase[targetAliquotAmount,UnitsP[resolvedErrorCheckingAmount],targetAliquotAmount];

				(* Round what the developer wanted to what we can physically do in the lab *)
				roundedDeveloperSpecifiedCompatibleAmount=Quiet[AchievableResolution[developerSpecifiedCompatibleAmount],{Error::MinimumAmount,Warning::AmountRounded}];

				(* Consider NumberOfReplicates if we need to ConsolidateAliquots *)
				resolvedErrorCheckingAmountWithReplicates = If[resolvedConsolidateAliquots,
					resolvedErrorCheckingAmount*numReplicates,
					resolvedErrorCheckingAmount
				];

				(* Throw an error if the resolved amount is less than the developer specified amount. *)
				Which[

					(* If AchievableResolution call returned $Failed, indicating that the amount we want to aliquot is too small, don't throw an error as ExperimentAliquot already should do this *)
					FailureQ[roundedDeveloperSpecifiedCompatibleAmount]&&!FailureQ[developerSpecifiedCompatibleAmount],Nothing,

					(* If the amount we resolved to is less than what the developer wanted up to resolution, throw an error *)
					MatchQ[resolvedErrorCheckingAmountWithReplicates,LessP[roundedDeveloperSpecifiedCompatibleAmount]],{sample,roundedDeveloperSpecifiedCompatibleAmount,resolvedErrorCheckingAmount},

					(* Otherwise, no issues *)
					True,Nothing
				]
			]
		],
		{reSimulatedSamples,collapsedAliquotBool,Lookup[collapsedAliquotOptionsPerSample,AliquotAmount],Lookup[collapsedAliquotOptionsPerSample,AssayVolume],targetAliquotAmounts}
	];

	(* If we found errors, throw a message. *)
	If[Length[invalidRequiredAliquotAmountInputs]>0 && Not[gatherTests],
		Message[Error::NotEnoughRequiredAmount,ToString[myFunction],ObjectToString[invalidRequiredAliquotAmountInputs[[All,1]],Cache->cache],ObjectToString[invalidRequiredAliquotAmountInputs[[All,2]]],ObjectToString[invalidRequiredAliquotAmountInputs[[All,3]]]];
		Message[Error::InvalidInput,ObjectToString[invalidRequiredAliquotAmountInputs[[All,1]],Cache->cache]];
	];

	(*-- If AllowSolids\[Rule]False, make sure that none of our resulting samples will be solids. --*)
	(* Note: We do not use the simulateSamplePreparation function here because that does a lot of un-necessary packet wrangling to create simulated samples and cache. Simply check the options and objects. *)
	If[MatchQ[Lookup[safeOps,AllowSolids],False],
		Module[{solidSamples,samplePacket,sampleState,sampleMass,sampleVolume},
			(* Check to make sure that none of our resulting aliquot samples (and non-aliquotted samples) will be solids. *)
			solidSamples=MapThread[
				Function[{sample,aliquotBoolean,aliquotAmount,assayVolume},
					(* Was our sample aliquotted at all? *)
					If[aliquotBoolean,
						(* Our sample was aliquotted. *)
						(* Our sample is a solid if AliquotAmount is populated but AssayVolume isn't populated. *)
						If[MatchQ[{aliquotAmount,assayVolume},{Except[Null],Null}],
							sample,
							Nothing
						],
						(* ELSE: Our sample was not aliquotted. *)
						(* Lookup our sample's packet to see if it's a solid. *)
						samplePacket=fetchPacketFromCache[sample,containerCache[]];

						(* Get the Mass, Volume and State fields from the sample packet. *)
						{sampleMass,sampleVolume,sampleState}=Lookup[samplePacket,{Mass,Volume,State},Null];

						(* If sample has solid state, it is a solid. If it has liquid state, it is a liquid. *)
						(* If sample doesn't have State field populated, our sample is a solid if Mass is populated and Volume is not populated. Otherwise, it's a liquid. *)
						Which[
							MatchQ[sampleState,Solid], sample,
							MatchQ[sampleState,Liquid], Nothing,
							NullQ[sampleState] && MatchQ[{sampleMass,sampleVolume},{Except[Null],Null}], sample,
							True, Nothing
						]
					]
				],
				{reSimulatedSamples,collapsedAliquotBool,Lookup[collapsedAliquotOptionsPerSample,AliquotAmount],Lookup[collapsedAliquotOptionsPerSample,AssayVolume]}
			];

			(* If we had solid samples, throw an error. *)
			If[Length[solidSamples]>0 && Not[gatherTests],
				Message[Error::SolidSamplesUnsupported,ObjectToString[solidSamples,Cache->cache],myFunction];
				Message[Error::InvalidInput,ObjectToString[solidSamples,Cache->cache]];
			];
		]
	];

	(*-- If we have a pooled input, make sure that the corresponding Aliquot boolean is turned on. --*)
	If[MatchQ[Lookup[safeOps,AllowPoolsWithoutAliquot],False],
		nonAliquottedPools=MapThread[
			Function[{sample, aliquotBoolean},
				If[MatchQ[sample,_List?(Length[#]>1)]&&MatchQ[aliquotBoolean,False],
					sample,
					Nothing
				]
			],
			{reSimulatedSamples,collapsedAliquotBool}
		];

		If[Length[nonAliquottedPools]>0 && Not[gatherTests],
			Message[Error::PoolWithoutAliquot,ObjectToString[nonAliquottedPools,Cache->cache],myFunction];
			Message[Error::InvalidInput,ObjectToString[Flatten[nonAliquottedPools],Cache->cache]];
		];
	];

	(* make the result and tests rules *)
	resultRule = Result -> resolvedAliquotOptions;
	testsRule = Tests -> Cases[Flatten[{invalidAliquotSampleLabelTests, aliquotOptionsSetIncorrectlyTests, aliquotResolutionTests,aliquotContainerTest}], _EmeraldTest];

	(* return the options and/or tests *)
	outputSpecification /. {resultRule, testsRule}
];


(* ::Subsubsection::Closed:: *)
(*Container Overload*)


(* This container overload takes self contained samples and containers (in addition to taking non self contained samples). *)
resolveAliquotOptions[myFunction_,mySamples:{(NonSelfContainedSampleP|SelfContainedSampleP|ObjectP[Object[Container]])..},mySimulatedSamples:{(ObjectP[{Object[Sample],Object[Container],Object[Item]}])..},mySamplePrepOptions_List,myOptions:OptionsPattern[]]:=Module[
	{cache,optionDefinition,numberOfReplicates,nonSelfContainedPositions,containerPositions,containerSingleSamplePositions,
		validInputPositions,
		validInputs,validOptions,optionSymbol,optionValue,indexMatchingQ,resolvedAliquotOptions,invalidInputPositions,
		allOptions,validSimulatedInputs,RequiredAliquotContainersOption,sanitizedAilquotOptions,aliquotTests,output,outputSpecification,
		safeOptions},

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolveAliquotOptions,ToList[myOptions]];

	(* Lookup our cache. *)
	cache=Lookup[safeOptions,Cache,{}];

	(* Lookup our output specification. *)
	(* get the output specification/output and cache options *)
	outputSpecification=Lookup[safeOptions, Output];
	output=ToList[outputSpecification];

	(* Get the option definition for our function. *)
	optionDefinition=OptionDefinition[myFunction];

	(* Get the NumberOfReplicates option. *)
	numberOfReplicates=Lookup[mySamplePrepOptions,NumberOfReplicates,Null]/.{Automatic|Null->1};

	(* NOTE: In resolveAliquotOptions, we take in both mySamples and mySimulatedSamples (because we need to see if we did a container swap back in resolveSamplePrepOptions. *)
	(* We only do simulation on inputs that are valid (aka NonSelfContainedSamplesP or containers with EXACTLY one sample. *)
	(* Therefore, we can still switch based off mySamples to see if we would have done the simulation or not. *)

	(* Get the positions of the self-contained samples, non-self-contained samples, and containers. *)
	nonSelfContainedPositions=Flatten[Position[mySamples,NonSelfContainedSampleP]];
	containerPositions=Flatten[Position[mySamples,ObjectP[Object[Container]]]];

	(* Get the positions of the containers that only have one sample in them. *)
	containerSingleSamplePositions=(
		If[Length[Lookup[fetchPacketFromCache[mySamples[[#]],cache],Contents]]==1,
			#,
			Nothing
		]
			&)/@containerPositions;

	(* Get the positions of the valid inputs. *)
	validInputPositions=Sort[Flatten[{nonSelfContainedPositions,containerSingleSamplePositions}]];

	(* Note: We do not check for invalid set options here because we already threw messages about invalid set options back in resolveSamplePrepOptions. *)

	(* Filter down our inputs and options to only the valid input samples. *)
	validInputs=(
		(* If we have a valid container, we need to get the single sample out of it. *)
		If[MatchQ[mySamples[[#]],ObjectP[Object[Container]]],
			First[Lookup[fetchPacketFromCache[mySamples[[#]],cache],Contents][[All,2]]],
			mySamples[[#]]
		]
			&)/@validInputPositions;

	(* Do the same but for the simulated samples. *)
	validSimulatedInputs=(
		(* If we have a valid container, we need to get the single sample out of it. *)
		If[MatchQ[mySimulatedSamples[[#]],ObjectP[Object[Container]]],
			First[Lookup[fetchPacketFromCache[mySimulatedSamples[[#]],cache],Contents][[All,2]]],
			mySimulatedSamples[[#]]
		]
			&)/@validInputPositions;

	(* Get the positions of the invalid inputs. *)
	invalidInputPositions=Complement[Range[Length[mySamples]],validInputPositions];

	(* Filter down our options so that we only have the index-matching values to our valid inputs. *)
	validOptions=Function[{option},
		(* Split out the option symbol and the option value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Lookup our option definition to see if it's index-matching. *)
		indexMatchingQ=MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->optionSymbol],<||>],"IndexMatchingInput",Null],"experiment samples"];

		(* Are we dealing with the AliquotContainer option? *)
		If[MatchQ[optionSymbol,AliquotContainer|DestinationWell|AliquotSampleLabel],
			(* AliquotContainer is index-matched to either Length[mySamples] or Length[mySamples]*NumberOfReplicates. *)
			If[Length[Lookup[mySamplePrepOptions,optionSymbol]]==Length[mySamples],
				(* Index-matched to mySamples, regularly filter. *)
				optionSymbol->optionValue[[validInputPositions]],
				(* Otherwise, collapse NumberOfReplicates expanded version and then filter. *)
				optionSymbol->optionValue[[;;;;numberOfReplicates]][[validInputPositions]]
			],
			(* Otherwise, look to see if our option is index-matching. *)
			If[indexMatchingQ,
				optionSymbol->optionValue[[validInputPositions]],
				option
			]
		]
	]/@mySamplePrepOptions;

	(* See if we have a RequiredAliquotContainers option given. If we have one, pass the valid positions down. *)
	RequiredAliquotContainersOption=If[KeyExistsQ[ToList[myOptions],RequiredAliquotContainers],
		RequiredAliquotContainers->Lookup[ToList[myOptions],RequiredAliquotContainers][[validInputPositions]],
		Nothing
	];

	(* Drop the RequiredAliquotContainers option from our option set (we just filtered it). *)
	sanitizedAilquotOptions=ToList[myOptions]/.{(RequiredAliquotContainers->_)->Nothing,(Output->_)->Nothing};

	(* Call our main overload. *)
	(* See if we have any inputs to call the resolver with. *)
	{resolvedAliquotOptions,aliquotTests}=If[Length[validInputs]>0,
		If[MemberQ[output,Tests],
			resolveAliquotOptions[myFunction,validInputs,validSimulatedInputs,validOptions,{Sequence@@sanitizedAilquotOptions,RequiredAliquotContainersOption,Output->{Result,Tests}}],
			{resolveAliquotOptions[myFunction,validInputs,validSimulatedInputs,validOptions,{Sequence@@sanitizedAilquotOptions,RequiredAliquotContainersOption,Output->Result}],{}}
		],
		{
			(If[MatchQ[Symbol[#],ConsolidateAliquots|AliquotPreparation],
				Symbol[#]->Null,
				Symbol[#]->{}
			]&)/@(Options[AliquotOptions][[All,1]]),
			{}
		}
	];

	(* Thread back our resolved options (for non-self-contained samples) in their correct positions with other object/container types being set to Null/False appropriately. *)

	(* Thread our options back together. *)
	allOptions=Function[{option},
		(* Split out the option symbol and the option value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Lookup our option definition to see if it's index-matching. *)
		indexMatchingQ=MatchQ[Lookup[FirstCase[optionDefinition,KeyValuePattern["OptionSymbol"->optionSymbol],<||>],"IndexMatchingInput"],"experiment samples"];

		(* Are we dealing with the AliquotContainer, AliquotSampleLabel, or DestinationWell option? *)
		If[MatchQ[optionSymbol,AliquotContainer|DestinationWell|AliquotSampleLabel],
			(* AliquotContainer is index-matched to either Length[validInputs] or Length[validInputs]*NumberOfReplicates. *)
			If[Length[Lookup[mySamplePrepOptions,optionSymbol]]==Length[validInputs],
				(* Index-matched to mySamples, regularly filter. *)
				optionSymbol->Fold[(Insert[#1,Null,#2]&),optionValue,invalidInputPositions],
				(* Otherwise, collapse NumberOfReplicates expanded version and then filter. *)
				optionSymbol->Fold[(Insert[#1,Null,#2]&),optionValue[[;;;;numberOfReplicates]],invalidInputPositions]
			],
			(* Otherwise, look to see if our option is index-matching. *)
			If[indexMatchingQ,
				(* Are we dealing with a master switch option? If so, use False instead of Null. *)
				If[MatchQ[optionSymbol,Incubate|Centrifuge|Filtration|Aliquot|Mix],
					optionSymbol->Fold[(Insert[#1,False,#2]&),optionValue,invalidInputPositions],
					optionSymbol->Fold[(Insert[#1,Null,#2]&),optionValue,invalidInputPositions]
				],
				If[MatchQ[optionValue,{}],
					optionSymbol->Null,
					option
				]
			]
		]
	]/@resolvedAliquotOptions;

	(* Return our threaded options. *)
	outputSpecification/.{
		Result->allOptions,
		Tests->aliquotTests
	}
];


(* ::Subsection::Closed:: *)
(*expandNumberOfReplicates*)


(* Given myFunction, mySamples, and myOptions: returns a list of expanded samples and options, according to the NumberOfReplicates option. *)
(* Assumes the myOptions is already expanded and that the only index-matching of inputs is to the samples. *)
expandNumberOfReplicates[myFunction_Symbol,mySamples_List,myOptions_List]:=Module[
	{numberOfReplicates,optionDefinitions,expandedOptions,optionDefinition,inputMatchedBoolean,expandedSamples},

	(* Get the NumberOfReplicates option. *)
	numberOfReplicates=Lookup[myOptions,NumberOfReplicates,1]/.{Null->1};

	(* If there is no expanding to do, return our samples and options. *)
	If[MatchQ[numberOfReplicates,1],
		{mySamples,myOptions},
		(* ELSE: There is expanding to do. *)
		(* Get the option definition for myFunction. *)
		optionDefinitions=OptionDefinition[myFunction];

		(* For all of the options that we were given (assume that they are expanded) expand the options further. *)
		expandedOptions=Function[{option},
			(*Figure out if this option is index-matching to the input.*)
			optionDefinition=SelectFirst[optionDefinitions,MatchQ[#["OptionSymbol"],option[[1]]]&];
			inputMatchedBoolean=MatchQ[Lookup[optionDefinition,"IndexMatchingInput"],_String];

			(*If our option is index matched to the input (assume it's the samples),then expand them.*)
			If[inputMatchedBoolean,
				option[[1]]->(Sequence@@ConstantArray[#,numberOfReplicates]&)/@option[[2]],
				option
			]
		]/@myOptions;

		(* Expand our samples. *)
		expandedSamples=(Sequence@@ConstantArray[#,numberOfReplicates]&)/@mySamples;

		(* Return our expanded samples and options. *)
		{expandedSamples,expandedOptions}
	]
];


(* ::Subsection::Closed:: *)
(*populateSamplePrepFieldsPooledIndexMatched*)


populateSamplePrepFieldsPooledIndexMatched[myUnexpandedSamplesIn_, myResolvedOptions:{(_Rule | _RuleDelayed)...}, myPopulationOptions:OptionsPattern[]] := Module[
	{flattenedSamples,optionDefinitions,flattenedOptions,optionSymbol,optionValue,optionDefinition,singletonPattern,flattenedOptionValue},
	(* Flatten our input samples and options. *)
	flattenedSamples=Flatten[myUnexpandedSamplesIn];

	(* Get our option definitions. *)
	(* Use ExperimentSolidPhaseExtraction since it has all of the sample prep options that are pooled. *)
	optionDefinitions=OverwriteAliquotOptionDefinition[ExperimentSolidPhaseExtraction,OptionDefinition[ExperimentSolidPhaseExtraction]];

	(* Flatten each of our option if it is pooled. *)
	flattenedOptions=Function[{option},
		(* Get the option name and value. *)
		optionSymbol=option[[1]];
		optionValue=option[[2]];

		(* Get the definition of our option. *)
		optionDefinition=FirstCase[optionDefinitions,KeyValuePattern["OptionSymbol"->optionSymbol]];

		(* Get the singleton pattern of our option. *)
		singletonPattern=Lookup[optionDefinition,"SingletonPattern",Null];

		(* If our option is pooled, we have to flatten it. *)
		If[Lookup[optionDefinition,"NestedIndexMatching",False]||MatchQ[optionSymbol,AliquotContainer|DestinationWell|AliquotSampleLabel],
			(* Our option is pooled. If an element of our list doesn't match the singleton, then it must be a pool. Flatten it. *)
			flattenedOptionValue=(
				If[!MatchQ[#,ReleaseHold[singletonPattern]],
					Sequence@@#,
					#
				]
			&)/@optionValue;

			(* There are possible ambiguities between pooled and singleton options. If the length of our option value still doesn't match the length of our inputs, flatten again. *)
			If[Length[flattenedOptionValue]!=Length[flattenedSamples],
				optionSymbol->Flatten[flattenedOptionValue],
				optionSymbol->flattenedOptionValue
			],
			(* Our option is not pooled. Nothing to do. *)
			option
		]
	]/@myResolvedOptions;

	(* Pass this to the main function. *)
	populateSamplePrepFields[flattenedSamples,flattenedOptions,myPopulationOptions]
];


(* ::Subsection::Closed:: *)
(*populateSamplePrepFieldsPooled*)


populateSamplePrepFieldsPooled[myUnexpandedSamplesIn:ListableP[{ObjectP[{Object[Sample],Object[Container],Object[Item]}]...}], myResolvedOptions:{(_Rule | _RuleDelayed)...}, myPopulationOptions:OptionsPattern[]] := Module[
	{
		aliquotBool, aliquotOptions, rawFields, rawAliquotSamplePreparation, samplePooling, numberOfReplicates,
		expandedAliquotSamplePreparation
	},


	aliquotOptions=Lookup[LookupTypeDefinition[Object[Protocol],AliquotSamplePreparation],Class][[All,1]];

	(* get a boolean indicating if we have all the aliquot options passed in *)
	aliquotBool=ContainsAll[Keys[myResolvedOptions], aliquotOptions]&&MemberQ[Flatten[Lookup[myResolvedOptions,Aliquot]],True];

	numberOfReplicates = Lookup[myResolvedOptions, NumberOfReplicates, 1] /. {Null -> 1};

	samplePooling = samplePooling = Length /@ (Flatten[ConstantArray[ToList[#], numberOfReplicates] & /@ myUnexpandedSamplesIn, 1]);

	rawFields = populateSamplePrepFields[myUnexpandedSamplesIn, myResolvedOptions, myPopulationOptions];

	rawAliquotSamplePreparation = If[aliquotBool,
		Lookup[rawFields, Replace[AliquotSamplePreparation]],
		{}
	];

	expandedAliquotSamplePreparation = If[aliquotBool,
		Flatten[MapThread[
			Module[{rawVolume, correctedVolume, correctedVolumeAssoc},
				rawVolume = Lookup[#1, AssayVolume];
				correctedVolume = rawVolume/#2;
				correctedVolumeAssoc = Association[ReplaceRule[Normal[#1], AssayVolume -> correctedVolume]];
				ConstantArray[correctedVolumeAssoc, #2]
			]&,
			{rawAliquotSamplePreparation, samplePooling}
		]],
		{}
	];

	If[aliquotBool,
		Association[ReplaceRule[Normal[rawFields], Replace[AliquotSamplePreparation] -> expandedAliquotSamplePreparation]],
		rawFields
	]


];


(* ::Subsection::Closed:: *)
(*populateSamplePrepFields*)


DefineOptions[
	populateSamplePrepFields,
	Options:>{CacheOption,SimulationOption}
];

(* TODO: Rewrite this to not rely on the Simulated key in the cache ball. *)
populateSamplePrepFields[myUnexpandedSamplesIn : ListableP[{ObjectP[{Object[Sample],Object[Container],Object[Item]}]...}], myResolvedOptions : {(_Rule | _RuleDelayed)...}, myPopulationOptions : OptionsPattern[]] := Module[
	{safeOptions,cache,simulation,numberOfReplicates,samplesInLength,incubationRule,aliquotOptions,centrifugeRule,filterRule,aliquotRule,aliquotSingletonRules,imageSampleRule,
		measureVolumeRule,measureWeightRule,aliquotBool,expandedSamplesIn,myResolvedOptionsWithLinks,allSamples, allSamplesIDs, simulatedQ,sampleToResourceMap,myResolvedOptionsWithResources,aliquotOptionsRawSymbols,
		aliquotOptionsRaw,rawAliquotContainer,
		rawAliquotSampleLabel, aliquotSampleLabelIndex,
		aliquotContainerIndex,incubateOptions,centrifugeOptions,filterOptions,samplePreparationRule, aliquotOptionsWithDestinationWell,
		aliquotOptionsWithAliquotContainer,rawDestinationWell,destinationWellIndex,pooledQ,duplicateReplicates,sampsInStorageRule,sampsOutStorageRule,
		sampleToIDMap, allSamplesIDsNoDuplicates, allSampleModels, allModelIDs, myResolvedOptionsWithoutCacheAndSimulation},

	(* Get our safe options. *)
	safeOptions = SafeOptions[populateSamplePrepFields, ToList[myPopulationOptions]];

	(* Get our cache. *)
	(* NOTE: We explicitly don't have to combine our cache and simulation in this function because we're just looking for *)
	(* the Simulated->True key here. *)
	cache=Lookup[safeOptions,Cache,{}];
	simulation=Lookup[safeOptions,Simulation,{}];

	(* Get the value of NumberOfReplicates from our options. *)
	(* Not all experiment functions have a NumberOfReplicates option, so default it to 1. *)
	(* If NumberOfReplicates is specified as Null, this is the same thing as setting it to 1. *)
	numberOfReplicates = Lookup[myResolvedOptions, NumberOfReplicates, 1] /. {Null -> 1};

	(* Get the length of our SamplesIn. *)
	samplesInLength = Length[myUnexpandedSamplesIn];

	(* get the SamplesIn expanded by NumberOfReplicates *)
	expandedSamplesIn = Flatten[Map[
		ConstantArray[#, numberOfReplicates]&,
		myUnexpandedSamplesIn
	]];

	(* Make sure that certain keys from our resolved options are in links, if applicable. *)
	myResolvedOptionsWithLinks=(
		If[And[
			(* Are we dealing with an option that can take an object? *)
			MatchQ[#[[1]],IncubationInstrument|CentrifugeInstrument|Filter|FilterInstrument|FilterSyringe|FilterHousing|AssayBuffer|BufferDiluent|ConcentratedBuffer],
			(* Does this option have an object reference as a value? *)
			MatchQ[#[[2]],ObjectP[]|ListableP[{(ObjectP[]|Null)...}]]
		],
			(* Remove two-way link IDs *)
			#/.{x:ObjectP[]:>Link[Download[x,Object]]},
			#
		]&)/@myResolvedOptions;

	(* Make sure to remove the Simulation and Cache options, if we have them. This is because we do not want to Cases Infinity from *)
	(* these options. *)
	myResolvedOptionsWithoutCacheAndSimulation=Normal@KeyDrop[
		Association[myResolvedOptionsWithLinks],
		{Simulation, Cache}
	];

	(* Replace any simulated samples with resources. Only replace simulated samples so that they get changed after SM sample prep. *)
	(* All other real samples will have resources created by their subprotocols. *)
	allSamples=DeleteDuplicates[Download[Cases[myResolvedOptionsWithoutCacheAndSimulation,ObjectReferenceP[Object[Sample]],Infinity],Object]];

	allSampleModels=DeleteDuplicates[Download[Cases[myResolvedOptionsWithoutCacheAndSimulation,ObjectReferenceP[Model[Sample]],Infinity],Object]];

	(* get Object for all Object[Sample] and Model[Sample] in our list *)
	{allSamplesIDs, allModelIDs} = Download[{allSamples,allSampleModels},Object];

	(* Make a map of objects specified by Name to their specification by ID - filtering reduces the amount of pattern matching *)
	sampleToIDMap = Module[{objectsModels, bool, namedSamples, namedSamplesIDs},
		objectsModels = Flatten[{allSamples,allSampleModels}];
		bool = Map[MatchQ[(Model[Sample,___Symbol,_?(StringMatchQ[#,"id:"~~__]&)]|Object[Sample,___Symbol,_?(StringMatchQ[#,"id:"~~__]&)])],objectsModels];
		namedSamples  = PickList[objectsModels,bool, False];
		namedSamplesIDs = PickList[Flatten[{allSamplesIDs,allModelIDs}],bool, False];
		MapThread[Rule[#1,#2]&,{namedSamples, namedSamplesIDs}]
	];

	allSamplesIDsNoDuplicates = DeleteDuplicates[allSamplesIDs];

	simulatedQ=Lookup[fetchPacketFromCache[#,cache],Simulated,False]&/@allSamplesIDsNoDuplicates;

	(* If our sample was simulated, replace it with a resource. *)
	sampleToResourceMap=MapThread[
		Function[{sample,simulatedBoolean},
			If[simulatedBoolean,
				sample->Resource[Sample->sample],
				Nothing
			]
		],
		{allSamplesIDsNoDuplicates,simulatedQ}
	];

	(* Replace our simulated samples with resources. *)
	myResolvedOptionsWithResources=(myResolvedOptionsWithLinks/.sampleToIDMap)/.sampleToResourceMap;

	(* Detect if we are are pooled. *)
	pooledQ=MemberQ[myUnexpandedSamplesIn,_List];

	(* Get our incubation, centrifuge, and filter sample prep options, in the order that they appear in their respective named multiple fields. *)
	incubateOptions=Lookup[LookupTypeDefinition[Object[Protocol],IncubateSamplePreparation],Class][[All,1]];
	centrifugeOptions=Lookup[LookupTypeDefinition[Object[Protocol],CentrifugeSamplePreparation],Class][[All,1]];
	filterOptions=Lookup[LookupTypeDefinition[Object[Protocol],FilterSamplePreparation],Class][[All,1]];
	aliquotOptions=Lookup[LookupTypeDefinition[Object[Protocol],AliquotSamplePreparation],Class][[All,1]];

	(* Prepare our incubation preparation rule. *)
	(* See if all of the incubation keys are contained within our resolved options. *)
	incubationRule = If[ContainsAll[Keys[myResolvedOptionsWithResources], incubateOptions]&&MemberQ[Flatten[Lookup[myResolvedOptionsWithResources,Incubate]],True],
		(* We have all of the necessary incubation information to populate the IncubatePreparation field. *)
		{Replace[IncubateSamplePreparation] -> Module[{expandedOptions},

			(* We must prepare our expanded options. *)
			(* If we are pooled, we have to do a flattening of each of our option lists, if our corresponding input index was a pool. *)
			expandedOptions = If[pooledQ,
				Transpose[
					Apply[Sequence,#,{1}]&/@Lookup[myResolvedOptionsWithResources, incubateOptions]
				],
				Transpose[Lookup[myResolvedOptionsWithResources, incubateOptions]]
			];

			(* Create our list of associations. *)
			Flatten[
				Function[{currentOptions},
					{
						(* Create the sample prep association for our original sample in. *)
						{Association[MapThread[(#1->#2&),{incubateOptions,currentOptions}]]},

						(* We are not sample preping our replicates. Fill the replicates with Nulls. *)
						ConstantArray[
							Association[MapThread[(#1->#2&),{incubateOptions,Prepend[ConstantArray[Null,Length[incubateOptions]-1],False]}]],
							numberOfReplicates - 1
						]
					}
				]/@expandedOptions
			]
		]},
		(* Not all of our incubation options are provided. Do not upload to the object. *)
		Nothing
	];

	(* Prepare our centrifuge preparation rule. *)
	(* See if all of the centrifuge keys are contained within our resolved options. *)
	centrifugeRule = If[ContainsAll[Keys[myResolvedOptionsWithResources], centrifugeOptions]&&MemberQ[Flatten[Lookup[myResolvedOptionsWithResources,Centrifuge]],True],
		(* We have all of the necessary centrifuge information to populate the MixPreparation field. *)
		{Replace[CentrifugeSamplePreparation] -> Module[{expandedOptions},
			(* We must prepare our expanded options. *)
			(* If we are pooled, we have to do a flattening of each of our option lists, if our corresponding input index was a pool. *)
			expandedOptions = If[pooledQ,
				Transpose[
					Apply[Sequence,#,{1}]&/@Lookup[myResolvedOptionsWithResources, centrifugeOptions]
				],
				Transpose[Lookup[myResolvedOptionsWithResources, centrifugeOptions]]
			];

			(* Create our list of associations. *)
			Flatten[
				Function[{currentOptions},
					{
						(* Create the sample prep association for our original sample in. *)
						{Association[MapThread[(#1->#2&),{centrifugeOptions,currentOptions}]]},

						(* We are not sample preping our replicates. Fill the replicates with Nulls. *)
						ConstantArray[
							Association[MapThread[(#1->#2&),{centrifugeOptions,Prepend[ConstantArray[Null,Length[centrifugeOptions]-1],False]}]],
							numberOfReplicates - 1
						]
					}
				]/@expandedOptions
			]
		]},
		(* Not all of our centrifuge options are provided. Do not upload to the object. *)
		Nothing
	];

	(* Prepare our filter preparation rule. *)
	(* See if all of the filter keys are contained within our resolved options. *)
	filterRule = If[ContainsAll[Keys[myResolvedOptionsWithResources], filterOptions]&&MemberQ[Flatten[Lookup[myResolvedOptionsWithResources,Filtration]],True],
		(* We have all of the necessary filter information to populate the MixPreparation field. *)
		{Replace[FilterSamplePreparation] -> Module[{expandedOptions},
			(* We must prepare our expanded options. *)
			(* If we are pooled, we have to do a flattening of each of our option lists, if our corresponding input index was a pool. *)
			expandedOptions = If[pooledQ,
				Transpose[
					Apply[Sequence,#,{1}]&/@Lookup[myResolvedOptionsWithResources, filterOptions]
				],
				Transpose[Lookup[myResolvedOptionsWithResources, filterOptions]]
			];

			(* Create our list of associations. *)
			Flatten[
				Function[{currentOptions},
					{
						(* Create the sample prep association for our original sample in. *)
						{Association[MapThread[(#1->#2&),{filterOptions,currentOptions}]]},

						(* We are not sample preping our replicates. Fill the replicates with Nulls. *)
						ConstantArray[
							Association[MapThread[(#1->#2&),{filterOptions,Prepend[ConstantArray[Null,Length[filterOptions]-1],False]}]],
							numberOfReplicates - 1
						]
					}
				]/@expandedOptions
			]
		]},
		(* Not all of our filter options are provided. Do not upload to the object. *)
		Nothing
	];

	(* get a boolean indicating if we have all the aliquot options passed in *)
	aliquotBool=ContainsAll[Keys[myResolvedOptionsWithResources], aliquotOptions]&&MemberQ[Flatten[Lookup[myResolvedOptionsWithResources,Aliquot]],True];

	(* Prepare our aliquot preparation rule. *)
	(* See if all of the aliquot keys are contained within our resolved options. *)
	aliquotRule=If[aliquotBool,
		(* Define a list of symbols without the AliquotContainer, AliquotSampleLabel, and DestinationWell keys. *)
		(* We deal with that separately. *)
		aliquotOptionsRawSymbols=aliquotOptions/.{(AliquotContainer|DestinationWell|AliquotSampleLabel)->Nothing};

		(* We have all of the necessary filter information to populate the AliquotSamplePreparation field. *)
		aliquotOptionsRaw=Module[{expandedOptions},
			(* We must prepare our expanded options. *)
			expandedOptions=Transpose[Lookup[myResolvedOptionsWithResources, aliquotOptionsRawSymbols]];

			(* Create our list of associations. *)
			Flatten[
				Function[{currentOptions},
					{
						(* Create the sample prep association for our original sample in. *)
						{Association[MapThread[(#1->#2&),{aliquotOptionsRawSymbols,currentOptions}]]},

						(* We ALWAYS sample prep our aliquot replicates. *)
						ConstantArray[
							Association[MapThread[(#1->#2&),{aliquotOptionsRawSymbols,currentOptions}]],
							numberOfReplicates - 1
						]
					}
				]/@expandedOptions
			]
		];

		(* Get the raw resolved value of AliquotContainer. *)
		rawAliquotContainer=Lookup[myResolvedOptionsWithResources,AliquotContainer];

		(* Get the index of AliquotContainers in our field. *)
		aliquotContainerIndex=First[FirstPosition[aliquotOptions,AliquotContainer]];

		(* Add our AliquotContainer to each association. *)
		aliquotOptionsWithAliquotContainer=MapThread[(
			Insert[#,AliquotContainer->#2,aliquotContainerIndex]
				&),{aliquotOptionsRaw,rawAliquotContainer}];

		(* Get the raw resolved value of DestinationWell. *)
		rawDestinationWell=Lookup[myResolvedOptionsWithResources,DestinationWell];

		(* Get the index of DestinationWell in our field. *)
		destinationWellIndex=First[FirstPosition[aliquotOptions,DestinationWell]];

		(* Add our DestinationWell to each association. *)
		aliquotOptionsWithDestinationWell = MapThread[(
			Insert[#,DestinationWell->#2,destinationWellIndex]
				&),{aliquotOptionsWithAliquotContainer,rawDestinationWell}];

		(* Get the raw resolved value of AliquotContainer. *)
		rawAliquotSampleLabel=Lookup[myResolvedOptionsWithResources,AliquotSampleLabel];

		(* Get the index of AliquotContainers in our field. *)
		aliquotSampleLabelIndex=First[FirstPosition[aliquotOptions,AliquotSampleLabel]];

		(* Add our AliquotContainer to each association. *)
		{
			Replace[AliquotSamplePreparation] -> MapThread[(
				Insert[#, AliquotSampleLabel -> #2, aliquotSampleLabelIndex]
					&), {aliquotOptionsWithDestinationWell, rawAliquotSampleLabel}]
		},
		Nothing
	];

	(* Do we have information about our aliquots? *)
	aliquotSingletonRules=If[aliquotBool,
		(* Create rules about our singleton aliquot fields. *)
		{
			ConsolidateAliquots -> Lookup[myResolvedOptionsWithResources, ConsolidateAliquots],
			AliquotPreparation -> Lookup[myResolvedOptionsWithResources, AliquotPreparation]
		},
		Nothing
	];

	(* Do we have information about ImageSample? *)
	imageSampleRule=If[MemberQ[Keys[myResolvedOptionsWithResources], ImageSample],
		{ImageSample -> Lookup[myResolvedOptionsWithResources, ImageSample]},
		Nothing
	];

	(* Do we have information about MeasureVolume? *)
	measureVolumeRule=If[MemberQ[Keys[myResolvedOptionsWithResources], MeasureVolume],
		{MeasureVolume -> Lookup[myResolvedOptionsWithResources, MeasureVolume]},
		Nothing
	];

	(* Do we have information about MeasureWeight? *)
	measureWeightRule=If[MemberQ[Keys[myResolvedOptionsWithResources], MeasureWeight],
		{MeasureWeight -> Lookup[myResolvedOptionsWithResources, MeasureWeight]},
		Nothing
	];

	(* == Function: expandReplicates: Copy values as needed as they are expanded for any replicates == *)
	duplicateReplicates[value_]:=Module[{},
		If[MatchQ[numberOfReplicates,Null]||MatchQ[value,Null|{}],
			value,
			Flatten[Map[ConstantArray[#,numberOfReplicates]&,value],1]
		]
	];

	(* Do we have information about SamplesInStorageCondition? *)
	sampsInStorageRule=If[MemberQ[Keys[myResolvedOptionsWithResources], SamplesInStorageCondition],
		{Replace[SamplesInStorage] -> duplicateReplicates[Lookup[myResolvedOptionsWithResources, SamplesInStorageCondition]]},
		Nothing
	];

	(* Do we have information about SamplesOutStorageCondition? *)
	sampsOutStorageRule=If[MemberQ[Keys[myResolvedOptionsWithResources], SamplesOutStorageCondition],
		{Replace[SamplesOutStorage] -> duplicateReplicates[Lookup[myResolvedOptionsWithResources, SamplesOutStorageCondition]]},
		Nothing
	];

	(* If we were given the PreparatoryUnitOperations option and it is not Null, upload it to the PreparatoryUnitOperations field. *)
	(* NOTE: We provide backwards compatibility support for PreparatoryPrimitives. We error checked earlier to make *)
	(* sure that we weren't given both. *)
	samplePreparationRule=Which[
		And[
			MemberQ[Keys[myResolvedOptionsWithResources],PreparatoryUnitOperations],
			!MatchQ[Lookup[myResolvedOptionsWithResources,PreparatoryUnitOperations],Null]
		],
		{Replace[PreparatoryUnitOperations]->Lookup[myResolvedOptionsWithResources, PreparatoryUnitOperations]},
		And[
			MemberQ[Keys[myResolvedOptionsWithResources],PreparatoryPrimitives],
			!MatchQ[Lookup[myResolvedOptionsWithResources,PreparatoryPrimitives],Null]
		],
		{Replace[PreparatoryPrimitives]->Lookup[myResolvedOptionsWithResources, PreparatoryPrimitives]},
		True,
		Nothing
	];

	(* Combine all of our field rules together into an association. *)
	Association[Flatten[{
		incubationRule,
		centrifugeRule,
		filterRule,
		aliquotRule,
		aliquotSingletonRules,
		imageSampleRule,
		measureVolumeRule,
		measureWeightRule,
		sampsInStorageRule,
		sampsOutStorageRule,
		samplePreparationRule
	}]]/.{Ambient->$AmbientTemperature}
];


(* ::Subsection::Closed:: *)
(*populateWorkingSamples*)


(* Given a protocol object, looks at the SamplePreparationProtocols field and populates the WorkingSamples field of the given protocol object correctly. *)
(* Right now, this function is NOT recursive since there is no way of doing sample simulation outside of sample prep (in the resolver functions). *)
populateWorkingSamples[myProtocol:ObjectP[{Object[Protocol],Object[Transaction,ShipToUser]}]]:=Module[
	{
		cacheBall, protocolPacket, lastSamplePreparationProtocol, containersInLengths, emptyContainerPositions,
		emptyContainers, nullSamplePositions, nullSamplePositionToEmptyContainerMap, parentProtocolWorkingSamples,
		parentProtocolWorkingContainers, samplePreparationProtocolPackets, manualAliquotUOPatternP,
		lastSamplePrepProtocolType, filterBooleans, workingSamples, workingContainers,
		lastSamplePreparationProtocolPacket
	},

	(* Clear the download cache because there is a weird bug where WorkingContainers is sometimes wrong. *)
	ClearDownload[];

	(* Download necessary information about our protocol object. *)
	cacheBall=Quiet[Flatten[Download[
		myProtocol,
		{
			Packet[SamplePreparationProtocols,IncubateSamplePreparation,CentrifugeSamplePreparation,FilterSamplePreparation,AliquotSamplePreparation,WorkingSamples,WorkingContainers,ResolvedOptions,ConsolidateAliquots,SamplesIn,ContainersIn],
			Packet[WorkingSamples[Container]],
			Packet[ContainersIn[Contents]],
			Packet[SamplePreparationProtocols[{LabeledObjects, OutputUnitOperations,WorkingSamples,SamplesOut,AliquotSamplePreparation}]],
			Packet[SamplePreparationProtocols[LabeledObjects][[All,2]][{Container, Name}]],
			Packet[SamplePreparationProtocols[OutputUnitOperations][{Subprotocol}]],
			Packet[SamplePreparationProtocols[OutputUnitOperations][Subprotocol][{WorkingSamples,SamplesOut,AliquotSamplePreparation}]],
			Packet[SamplePreparationProtocols[OutputUnitOperations][Subprotocol][WorkingSamples][{Container}]],
			Packet[SamplePreparationProtocols[OutputUnitOperations][Subprotocol][SamplesOut][{Container}]],
			Packet[SamplePreparationProtocols[WorkingSamples][{Container}]],
			Packet[SamplePreparationProtocols[SamplesOut][{Container}]]
		}
	]],{Download::FieldDoesntExist, Download::NotLinkField}];

	(* Get the protocol packet from our cache. *)
	protocolPacket=fetchPacketFromCache[myProtocol,cacheBall];

	(* If no sample preperation protocol were run, short circuit. *)
	If[MatchQ[Lookup[protocolPacket,SamplePreparationProtocols],{}],
		Return[myProtocol]
	];

	(* Get the last sample prep protocol that was run on our parent protocol. *)
	lastSamplePreparationProtocol=Last[Lookup[protocolPacket,SamplePreparationProtocols]];

	(* Create our empty container to sample map. *)
	(* Get the lengths of the contents of all our ContainersIn. *)
	containersInLengths=Length[Lookup[fetchPacketFromCache[#,cacheBall],Contents]]&/@Lookup[protocolPacket,ContainersIn];

	(* Get the positions of the empty containers. *)
	emptyContainerPositions=Flatten[Position[containersInLengths,0]];

	(* Get our empty containers in order. *)
	emptyContainers=Lookup[protocolPacket,ContainersIn][[emptyContainerPositions]];

	(* Get the positions of the Nulls in our SamplesIn. *)
	nullSamplePositions=Flatten[Position[Lookup[protocolPacket,SamplesIn],Null]];

	(* Create our null sample index to empty container object map. *)
	(* Filter will remove the sample from the container, causing it to be empty so we exempt is here. *)
	nullSamplePositionToEmptyContainerMap=If[
		MemberQ[Lookup[protocolPacket,SamplePreparationProtocols], ObjectP[Object[Protocol,Filter]]],
		{},
		MapThread[#1->#2&,{nullSamplePositions,emptyContainers}]
	];

	(* Get the working samples of our parent protocol. *)
	(* If this field doesn't exist, use SamplesIn. *)
	parentProtocolWorkingSamples=If[KeyExistsQ[protocolPacket,WorkingSamples],
		Lookup[protocolPacket,WorkingSamples]/.{link_Link:>Download[link, Object]},
		Lookup[protocolPacket,SamplesIn]/.{link_Link:>Download[link, Object]}
	];

	(* Get the working containers of our parent protocol. *)
	(* If this field doesn't exist, use ContainersIn. *)
	parentProtocolWorkingContainers=If[KeyExistsQ[protocolPacket,WorkingContainers],
		Lookup[protocolPacket,WorkingContainers]/.{link_Link:>Download[link, Object]},
		Lookup[protocolPacket,ContainersIn]/.{link_Link:>Download[link, Object]}
	];

	(* get the packet for the last sample prep protocol *)
	samplePreparationProtocolPackets = fetchPacketFromCache[#, cacheBall]& /@ Download[Lookup[protocolPacket, SamplePreparationProtocols], Object];

	(* this is the manual pattern for matching the ManualSamplePreparation unit operations to it being an aliquot protocol; note that if we change how ExperimentAliquot makes its UnitOperations, this also needs to change *)
	manualAliquotUOPatternP = {
		ObjectP[Object[UnitOperation, LabelSample]] | ObjectP[Object[UnitOperation, LabelContainer]],
		ObjectP[Object[UnitOperation, LabelContainer]] | ObjectP[Object[UnitOperation, LabelSample]],
		Repeated[ObjectP[Object[UnitOperation, LabelSample]], {0, 1}],
		ObjectP[Object[UnitOperation, Transfer]],
		Repeated[ObjectP[{Object[UnitOperation, Centrifuge], Object[UnitOperation, Incubate]}], {0, Infinity}]
	};

	(* get the protocol type every one of the sample preparation protocols were *)
	lastSamplePreparationProtocolPacket = Last[samplePreparationProtocolPackets];
	lastSamplePrepProtocolType = Which[
		(* NOTE: If there are aliquot options specified, a non MSP/RSP protocol can be generated. *)
		MatchQ[lastSamplePreparationProtocolPacket, ObjectP[Object[Protocol,Incubate]]],
			Incubate,
		MatchQ[lastSamplePreparationProtocolPacket, ObjectP[Object[Protocol,Centrifuge]]],
			Centrifuge,
		MatchQ[lastSamplePreparationProtocolPacket, ObjectP[Object[Protocol,Filter]]],
			Filter,
		MatchQ[Lookup[lastSamplePreparationProtocolPacket, OutputUnitOperations], {ObjectP[Object[UnitOperation, Incubate]]}],
			Incubate,
		MatchQ[Lookup[lastSamplePreparationProtocolPacket, OutputUnitOperations], {ObjectP[Object[UnitOperation, Centrifuge]]}],
			Centrifuge,
		MatchQ[Lookup[lastSamplePreparationProtocolPacket, OutputUnitOperations], {ObjectP[Object[UnitOperation, Filter]]}],
			Filter,
		Or[
			MatchQ[lastSamplePreparationProtocolPacket, ObjectP[Object[Protocol, RoboticSamplePreparation]]] && MatchQ[Lookup[lastSamplePreparationProtocolPacket, OutputUnitOperations], {ObjectP[Object[UnitOperation, Aliquot]]}],
			(* MSP Experiment Aliquot doesn't actually create aliquot UOs - it makes LabelSample, LabelContainer, and Transfer UOs *)
			MatchQ[lastSamplePreparationProtocolPacket, ObjectP[Object[Protocol, ManualSamplePreparation]]] && MemberQ[Lookup[lastSamplePreparationProtocolPacket, OutputUnitOperations],ObjectP[{Object[UnitOperation, LabelContainer], Object[UnitOperation, LabelSample], Object[UnitOperation, Transfer]}]] && Length[Lookup[lastSamplePreparationProtocolPacket, OutputUnitOperations]] > 1
		],
			Aliquot
	];

	(* Get the correct filtering booleans based on the type of the last sample prep protocol. *)
	filterBooleans = Switch[lastSamplePrepProtocolType,
		Incubate, Lookup[Lookup[protocolPacket, IncubateSamplePreparation], Incubate],
		Centrifuge, Lookup[Lookup[protocolPacket, CentrifugeSamplePreparation], Centrifuge],
		Filter, Lookup[Lookup[protocolPacket, FilterSamplePreparation], Filtration],
		Aliquot, Lookup[Lookup[protocolPacket, AliquotSamplePreparation], Aliquot]
	];

	(* We need to replace the working samples that were affected by sample preparation. *)

	(* What kind of sample prep protocol are we dealing with (is it aliquot?) *)
	{workingSamples,workingContainers}=If[MatchQ[lastSamplePrepProtocolType, Aliquot],
		Module[
			{aliquotPreparationAssociations, newWorkingSamples, newWorkingContainers},

			(* -- DEALING WITH ALIQUOTING -- *)
			(* Lookup the aliquot information for each of our working samples. *)
			aliquotPreparationAssociations=Lookup[protocolPacket,AliquotSamplePreparation];

			(* For each of our current WorkingSamples that we have, get the ones that were aliquotted. *)
			newWorkingSamples=MapThread[
				Function[{aliquotInformation, parentProtocolWorkingSample},
					If[MatchQ[Lookup[aliquotInformation, Aliquot], False],
						parentProtocolWorkingSample,
						Lookup[Rule@@@Lookup[lastSamplePreparationProtocolPacket, LabeledObjects], Lookup[aliquotInformation, AliquotSampleLabel]]
					]
				],
				{aliquotPreparationAssociations, parentProtocolWorkingSamples}
			];
			newWorkingContainers=(Lookup[fetchPacketFromCache[#, cacheBall], Container]&)/@newWorkingSamples;

			{
				Link/@(newWorkingSamples/.{link_Link:>Download[link, Object]}),
				Link/@DeleteDuplicates[(newWorkingContainers/.{link_Link:>Download[link, Object]})]
			}
		],
		Module[
			{realProtocolPacket, lastSamplePreperationWorkingSamples, lastSamplePreparationSamplesOut, lastSamplePreparationRelevantSamples,
				resolvedOptions, numberOfReplicates, relevantSamplesWithReplicates, filterBooleansWithReplicatesIndices,
				filterBooleansWithReplicates, nonManipulatedSamples, manipulatedSamplePositions, samples, currentWorkingContainers},
			(* -- NOT DEALING WITH ALIQUOTING. -- *)
			(* Non-aliquot sample preparation does not set Incubate|Centrifuge|Filtration\[Rule]True for its replicates. *)

			(* Lookup the working samples of our last sample prep protocol. *)
			(* NOTE: Go to the actual Object[Protocol, BLAH], not MSP/RSP. *)
			(* The only exception is Centrifuge *)
			realProtocolPacket=If[MatchQ[lastSamplePreparationProtocol, Except[ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]]],
				lastSamplePreparationProtocolPacket,
				fetchPacketFromCache[
					Lookup[
						fetchPacketFromCache[
							Lookup[fetchPacketFromCache[lastSamplePreparationProtocol,cacheBall], OutputUnitOperations][[1]],
							cacheBall
						],
						Subprotocol
					],
					cacheBall
				]
			];
			lastSamplePreperationWorkingSamples=Lookup[
				realProtocolPacket,
				WorkingSamples
			];

			(* Lookup the samples out of our last sample prep protocol. *)
			lastSamplePreparationSamplesOut=Lookup[realProtocolPacket,SamplesOut];

			(* If we have SamplesOut, use that. Otherwise, use WorkingSamples. *)
			(* This is because in Filter, we will generate new SamplesOut after we filter into a container. *)
			lastSamplePreparationRelevantSamples=If[!MatchQ[lastSamplePreparationSamplesOut,{}|Null],
				lastSamplePreparationSamplesOut,
				lastSamplePreperationWorkingSamples
			];

			(* Get the resolved options of our protocol. *)
			resolvedOptions=Lookup[fetchPacketFromCache[myProtocol,cacheBall],ResolvedOptions];

			(* See if we have a NumberOfReplicates option here. *)
			numberOfReplicates=If[KeyExistsQ[resolvedOptions,NumberOfReplicates],
				(* We have a NumberOfReplicates option here. *)
				Lookup[resolvedOptions,NumberOfReplicates,Null]/.{Null->1},
				(* We don't have a NumberOfReplicates option here. *)
				1
			];

			(* Take our relevant samples from our last sample preparation protocol and duplicate them according to NumberOfReplicates. *)
			relevantSamplesWithReplicates=Flatten[(ConstantArray[#,numberOfReplicates]&)/@lastSamplePreparationRelevantSamples];

			(* Take our filter booleans and whenever there is a True, add numberOfReplicates-1 more True values in the list. *)
			(* This is because we don't sample prep our replicates. *)
			filterBooleansWithReplicatesIndices=MapThread[
				Function[{index,boolean},
					If[TrueQ[boolean],
						Sequence@@Table[
							{index+counter,True},
							{counter,0,numberOfReplicates-1}
						],
						{index,boolean}
					]
				],
				{Range[Length[filterBooleans]],filterBooleans}
			];

			(* Compile down our indices. *)
			filterBooleansWithReplicates=(
				Or@@(Cases[filterBooleansWithReplicatesIndices,{#,_}][[All,2]])
			&)/@Range[Length[filterBooleans]];

			(* Get the working samples of our sample protocol that were not touched by sample prep. *)
			nonManipulatedSamples=PickList[parentProtocolWorkingSamples,filterBooleansWithReplicates,False];

			(* Get the positions of the manipulated samples. *)
			manipulatedSamplePositions=Position[filterBooleansWithReplicates,True];

			(* Interleave the manipulated and non-manipulated samples in order. *)
			samples=Fold[(Insert[#1,First[#2],Last[#2]]&),nonManipulatedSamples,Transpose[{relevantSamplesWithReplicates,manipulatedSamplePositions}]];

			(* We need to give WorkingContainers. *)
			(* If we have a self contained sample or if our sample is Null, there is no container. *)
			currentWorkingContainers=MapThread[
				Function[{sample,sampleIndex},
					(* SelfContainedSamples have no container. *)
					If[MatchQ[sample,SelfContainedSampleP],
						Nothing,
						(* If we have a Null sample, go from the index to the empty container. *)
						If[MatchQ[sample,Null],
							sampleIndex/.nullSamplePositionToEmptyContainerMap,
							(* Our sample is not self-contained or Null, it should have a container. *)
							Lookup[fetchPacketFromCache[sample,cacheBall],Container]
						]
					]
				],
				{samples,Range[Length[samples]]}
			];

			{
				Link/@(samples/.{link_Link:>Download[link, Object]}),
				Link/@DeleteDuplicates[(currentWorkingContainers/.{link_Link:>Download[link, Object]})]
			}
		]
	];

	(* Upload our working samples and working containers. *)
	Upload[<|
		Object->myProtocol,
		Replace[WorkingSamples]->workingSamples,
		Replace[WorkingContainers]->workingContainers
	|>];

	(* Return myProtocol. *)
	myProtocol
];


(* Maintenance shipping loops over the transactions during aliquot preparation.
	Since execute tasks can only work on the maintenance, a helper to sort out which transaction we want to populate working samples for, then populate working samples in that transaction.
	Although this requires a second download, it is faster than downloading all of the fields needed in the core overload from all of the transactions shipped in this maintenance. *)
populateWorkingSamples[myMaintenance:ObjectP[Object[Maintenance,Shipping]]]:=Module[{transactionPackets,workingTransaction},

	transactionPackets= Download[myMaintenance, Packet[Transactions[SamplePreparationProtocols]]];

	(* Find the last transaction in the list that has SamplePreparationProtocols populated *)
	workingTransaction=Lookup[FirstCase[Reverse[transactionPackets], KeyValuePattern[SamplePreparationProtocols -> {ObjectP[]..}],{}], Object,Null];

	(* If we didn't find a transaction, return the maintenance. Otherwise, populate working samples on the found transaction. *)
	If[NullQ[workingTransaction],
		myMaintenance,
		populateWorkingSamples[workingTransaction]
	]
];


(* ::Subsection::Closed:: *)
(*populateWorkingAndAliquotSamples*)


(* populateWorkingAndAliquotSamples populates WorkingSamples/WorkingContainers if they were not populated yet (there was no sample prep). *)
(* populateWorkingAndAliquotSamples populates the AliquotSamples field with the results in the WorkingSamples field ONLY if WorkingSamples was different than SamplesIn. Otherwise, this field is not uploaded. *)
(* Therefore, this field will only be populated if aliquots were made. *)
populateWorkingAndAliquotSamples[myProtocol:ObjectP[Object[Protocol]]]:=Module[
	{workingSamples,samplesIn,workingContainers,containersIn,parentProtocolUnitOperationPackets,protocolUnitOperation,aliquotSamples},
	(* Download WorkingSamples and SamplesIn. *)
	{
		workingSamples,
		workingContainers,
		containersIn,
		samplesIn,
		parentProtocolUnitOperationPackets
	}=Quiet[Download[
		myProtocol,
		{
			WorkingSamples,
			WorkingContainers,
			ContainersIn,
			SamplesIn,
			Packet[ParentProtocol[OutputUnitOperations[{Subprotocol}]]]
		}
	],{Download::FieldDoesntExist, Download::NotLinkField}];

	(* Find the correct UO that we should update *)
	(* We have to go through ParentProtocol as the link between UnitOperation and its Subprotocol is not a two-way link *)
	protocolUnitOperation=Download[FirstCase[parentProtocolUnitOperationPackets,KeyValuePattern[Subprotocol->LinkP[Download[myProtocol,Object]]],Null],Object];

	(* SamplesIn and WorkingSamples can be Object[Item], but AliquotSamples can only be Object[Sample], so only allow
	Object[Sample] as putative AliquotSamples*)
	aliquotSamples=Cases[workingSamples,ObjectP[Object[Sample]]];

	(* If WorkingSamples is not filled out, fill out WorkingSamples/WorkingContainers from ContainersIn/SamplesIn. *)
	(* This guarantees us that there was no sample prep previously so we do not populate the aliquot samples field. *)
	If[MatchQ[workingSamples,Null|{}],
		Upload[<|
			Object->myProtocol,
			Replace[WorkingSamples]->Link[samplesIn],
			Replace[WorkingContainers]->Link[containersIn]
		|>],
		(* Look at the objects from WorkingSamples/SamplesIn and compare. *)
		If[!MatchQ[Download[workingSamples,Object],Download[samplesIn,Object]],
			(* Strip the links and upload. *)
			Upload[<|
				Object->myProtocol,
				Replace[AliquotSamples]->Link[aliquotSamples]
			|>];
			(* Also update the corresponding UO if not Null *)
			If[!NullQ[protocolUnitOperation],
				Upload[<|
					Object->protocolUnitOperation,
					Replace[AliquotSamples]->Link[aliquotSamples]
				|>]
			];
			(* Return myProtocol *)
			myProtocol,
			myProtocol
		]
	]
];


(* ::Subsection::Closed:: *)
(*populatePreparedSamples*)

Error::MissingDefineName="The following define name(s), `1`, were missing from the LabeledObjects map in the Object[Protocol, Manual/RoboticSamplePreparation]. The Prepared Samples cannot be updated.";

DefineOptions[populatePreparedSamples,
	SharedOptions:>{
		CacheOption,
		UploadOption,
		SimulationOption,

		{Protocol -> Null, Null | ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}], "The protocol for which this exporter is creating the liquid handler procedure."}
	}
];

(* Updates the fields in the protocol object with the prepared samples in the following scenarios: *)
(* 1) PreparatoryUnitOperations field of Object[Protocol] or PreparatoryPrimitives via SM. *)
(* 2) UnitOperation object inside of SP protocol. *)
(* NOTE: When this function is called on an Object[UnitOperation], it will directly pull the LabeledObjects field from the Protocol *)
(* field from the unit operation. *)
populatePreparedSamples[myProtocol:ObjectP[{Object[Protocol], Object[UnitOperation]}], myOptions:OptionsPattern[]]:=Module[
	{safeOptions,protocolPacket,samplePreparationProtocol,labeledObjects,preparedSamplesMap,
		labeledObjectRules,preparedSampleDefineNames,preparedSamples,rawPreparedSamplePositions,replacedDefineNames,preparedSamplePositions,
		preparedSampleFieldNames,protocolPacketWithPreparedSampleFields,protocolPacketWithoutLinkIDs,preparedSamplesWithLinks,samplePositionsWithKeyedFields,fieldName,
		fullFieldRelation,relevantRelationPart,relationFieldList,relationFieldSymbols,possibleBacklinks,preparedSampleTypes,replacedProtocolPacket,
		changeProtocolPacket,preparedSampleContainerPositions,containerContentCache,preparedSamplesConsideringContainers,containerPacket,containerContents,
		updateWorkingSamples,updateWorkingContainers,changePacket},

	(* Get our safe options. *)
	safeOptions=SafeOptions[populatePreparedSamples, ToList[myOptions]];

	(* The way to get to LabeledObjects is different for an Object[Protocol] (via PreparatoryUnitOperations) vs an *)
	(* Object[UnitOperation] inside of SP. *)
	{protocolPacket,samplePreparationProtocol,labeledObjects,containerContentCache}=Which[
		(* Using the SM PreparatoryPrimitives / SP PreparatoryUnitOperations system. *)
		MatchQ[myProtocol, ObjectP[Object[Protocol]]],
		Module[{lastSamplePreparationProtocol},
			(* Get the value of the last sample preparation protocol. *)
			lastSamplePreparationProtocol=Download[
				myProtocol,
				SamplePreparationProtocols[[-1]],
				Simulation->Lookup[safeOptions, Simulation]
			];

			If[MatchQ[lastSamplePreparationProtocol, ObjectP[Object[Notebook, Script]]],
				(* NOTE: If we have a script, we're guaranteed to only have SP subprotocols. *)
				Module[
					{tempProtocolPacket, tempSamplePreparationProtocol, labeledObjectsList, containerContentCacheList},
					(* NOTE: If we have a script protocol, we have to traverse into the protocols that the script kicks off *)
					(* to get the labeled objects. *)
					{tempProtocolPacket, tempSamplePreparationProtocol, labeledObjectsList, containerContentCacheList}=Quiet[
						Download[
							myProtocol,
							{
								Packet[PreparedSamples],
								SamplePreparationProtocols[[-1]],
								SamplePreparationProtocols[[-1]][Protocols][LabeledObjects],
								Packet[SamplePreparationProtocols[[-1]][Protocols][LabeledObjects][[All,2]][Contents]]
							},
							Cache->Lookup[safeOptions, Cache],
							Simulation->Lookup[safeOptions, Simulation]
						],
						{Download::FieldDoesntExist, Download::NotLinkField}
					];

					{
						tempProtocolPacket,
						tempSamplePreparationProtocol,
						Flatten[labeledObjectsList,1],
						Cases[Flatten[containerContentCacheList], PacketP[]]
					}
				],
				Module[{tempProtocolPacket, tempSamplePreparationProtocol, labeledObjectsList, definedObjectsList, labeledObjectsContainerContentCacheList, definedObjectsContainerContentCacheList},
					(* NOTE: We have to handle both DefinedObjects and LabeledObjects here. *)
					{tempProtocolPacket, tempSamplePreparationProtocol, labeledObjectsList, definedObjectsList, labeledObjectsContainerContentCacheList, definedObjectsContainerContentCacheList}=Quiet[
						Download[
							myProtocol,
							{
								Packet[PreparedSamples],
								SamplePreparationProtocols[[-1]],
								SamplePreparationProtocols[[-1]][LabeledObjects],
								SamplePreparationProtocols[[-1]][DefinedObjects],
								Packet[SamplePreparationProtocols[[-1]][LabeledObjects][[All,2]][Contents]],
								Packet[SamplePreparationProtocols[[-1]][DefinedObjects][[All,2]][Contents]]
							},
							Cache->Lookup[safeOptions, Cache],
							Simulation->Lookup[safeOptions, Simulation]
						],
						{Download::FieldDoesntExist, Download::NotLinkField}
					];

					{
						tempProtocolPacket,
						tempSamplePreparationProtocol,
						If[!MatchQ[labeledObjectsList, $Failed],
							labeledObjectsList,
							definedObjectsList
						],
						If[!MatchQ[labeledObjectsContainerContentCacheList, $Failed],
							Cases[Flatten[labeledObjectsContainerContentCacheList], PacketP[]],
							Cases[Flatten[definedObjectsContainerContentCacheList], PacketP[]]
						]
					}
				]
			]
		],
		(* Using the UnitOperation system, but not a sub unit operation. *)
		!MatchQ[Lookup[safeOptions, Protocol], ObjectP[]],
		Quiet[
			Download[
				myProtocol,
				{
					Packet[PreparedSamples],
					Protocol,
					Protocol[LabeledObjects],
					Packet[Protocol[LabeledObjects][[All,2]][Contents]]
				},
				Simulation->Lookup[safeOptions, Simulation]
			],
			{Download::FieldDoesntExist, Download::NotLinkField}
		],
		(* Using the UnitOperation system, is a sub unit operations (so the Protocol field isn't filled out). *)
		True,
		First/@Quiet[
			Download[
				{
					myProtocol,
					Lookup[safeOptions, Protocol],
					Lookup[safeOptions, Protocol],
					Lookup[safeOptions, Protocol]
				},
				{
					{Packet[PreparedSamples]},
					{Object},
					{LabeledObjects},
					{Packet[LabeledObjects[[All,2]][Contents]]}
				},
				Simulation->Lookup[safeOptions, Simulation]
			],
			{Download::FieldDoesntExist, Download::NotLinkField}
		]
	];

	(* The last sample preparation protocol that we have executed should be a ManualSamplePreparation. *)
	(* If this isn't the case, error out. (Only check the last in case things were troubleshot). *)
	If[!MatchQ[samplePreparationProtocol,ObjectP[{Object[Notebook, Script], Object[Protocol,SampleManipulation], Object[Protocol,ManualSamplePreparation], Object[Protocol,RoboticSamplePreparation], Object[Protocol,ManualCellPreparation], Object[Protocol,RoboticCellPreparation]}]],
		Message[Error::NoSamplePreparationProtocol];
		Return[$Failed];
	];

	(* Get the PreparedSamples map. *)
	preparedSamplesMap=Lookup[protocolPacket,PreparedSamples];

	(* Look at the PreparedSamples map. If there is nothing to map, then return early. *)
	If[Length[preparedSamplesMap]==0||MatchQ[preparedSamplesMap,{}],
		If[MatchQ[Lookup[safeOptions, Upload], False],
			Return[{}],
			Return[myProtocol]
		];
	];

	(* We have prepared samples to fill in. *)

	(* -- Get the prepared samples that we should fill in and the positions to fill them in. -- *)

	(* Convert the LabeledObjects field (which is now {{name,object}..}) to an association (<|(name->object)..|>) with
	later labels replacing identical earlier ones *)
	labeledObjectRules=AssociationThread[labeledObjects[[All,1]],labeledObjects[[All,2]]];

	(* Get the define names of our prepared samples. *)
	preparedSampleDefineNames=preparedSamplesMap[[All,1]];

	(* Replace our define names with the actual objects. *)
	replacedDefineNames=preparedSampleDefineNames/.labeledObjectRules;

	(* Get our prepared samples (without links) index-matched to their positions. *)
	preparedSamples=Download[replacedDefineNames,Object];

	(* Get the positions that each of our objects should be inserted in. *)
	(* Get rid of the first and last indices. *)
	rawPreparedSamplePositions=Most[Rest[#]]&/@preparedSamplesMap;

	(* Get the container indices of our prepared samples. *)
	preparedSampleContainerPositions=Last[#]&/@preparedSamplesMap;

	(* Swap out our prepared containers with prepared samples if we were asked to do so by RequireResources. *)
	preparedSamplesConsideringContainers=MapThread[
		Function[{preparedSample,containerPosition},
			(* Skip over this if there is no container position. *)
			If[MatchQ[containerPosition,Null],
				preparedSample,
				(* Otherwise, we have a container that needs dereferencing. *)

				(* Get the container's packet. *)
				containerPacket=fetchPacketFromCache[preparedSample,Flatten[containerContentCache]];

				(* Lookup the Contents. *)
				containerContents=Lookup[containerPacket,Contents];

				(* Get the sample with the given position. *)
				Download[FirstCase[containerContents,{containerPosition,_},{$Failed,$Failed}][[2]],Object]
			]
		],
		{preparedSamples,preparedSampleContainerPositions}
	];

	(* Get the names of the fields where we need to replace our samples. *)
	preparedSampleFieldNames=First/@rawPreparedSamplePositions;

	(* We have to wrap the first index (the field) with Key[...] and get rid of any Nulls. *)
	preparedSamplePositions=({Key[#[[1]]],Sequence@@Rest[#]}/.{Null->Nothing}&)/@rawPreparedSamplePositions;

	(* Re-download our protocol packet with these field names. We do a _seperate_ download here because it is faster than downloading the entire protocol packet. *)
	protocolPacketWithPreparedSampleFields=With[{insertMe=Packet@@preparedSampleFieldNames},Download[myProtocol,insertMe,Simulation->Lookup[safeOptions, Simulation]]];

	(* Every link that we download from Constellation will already have a link ID. Remove these link IDs in order to re-upload. *)
	(* Note: Named fields (in associations) will not evaluate our Most[...] but the field values will be de-reference inside of the Upload code and the values will be evaluated. *)
	protocolPacketWithoutLinkIDs=protocolPacketWithPreparedSampleFields/.{link_Link:>RemoveLinkID[link]};

	(* For each prepared sample that we're in-situ replacing, decide if we need to convert our object into a link, with a potential backlink. *)
	preparedSamplesWithLinks=MapThread[
		Function[{preparedSample,position,containerLocation},
			(* Note: This code is borrowed from RequireResources. Thanks Steven. *)
			(* Get the field name that we're putting this prepared samples in. *)
			fieldName=First[position];

			(* get the relation definition for the field name, using the packet to figure out the type *)
			fullFieldRelation=LookupTypeDefinition[Lookup[protocolPacket,Type][fieldName],Relation];

			(* get the part of the relation that we actually care about; if the field we are dealing with is indexed, we need to get the right piece of the relation *)
			relevantRelationPart=Switch[{position,SingleFieldQ[Lookup[protocolPacket,Type][fieldName]]},
				(* either an indexed single or flat multiple; can tell based on full relation being a list or not *)
				{{_Symbol, _Integer},_},If[ListQ[fullFieldRelation],
					fullFieldRelation[[Last[position]]],
					fullFieldRelation
				],
				(* named single *)
				{{_Symbol, PatternUnion[_Symbol, Except[Null]]},True},Lookup[fullFieldRelation,Last[position]],
				(* indexed multiple *)
				{{_Symbol, _Integer, _Integer},_},fullFieldRelation[[Last[position]]],
				(* named multiple *)
				{{_Symbol, _Integer, PatternUnion[_Symbol, Except[Null]]},_},Lookup[fullFieldRelation,Last[position]],
				(* indexed single *)
				{{_Symbol, _Integer, Null},True}, fullFieldRelation[[position[[2]]]],
				(* anything else we have a flat Relation already *)
				_,fullFieldRelation
			];

			(* convert this alternatives into a List, if it isn't already *)
			relationFieldList=If[MatchQ[relevantRelationPart,_Alternatives],
				List@@relevantRelationPart,
				ToList[relevantRelationPart]
			];
			(* get the backlink field symbols (sans duplicates), if any, from each of the possible relation fields; there is no backlink if this is an empty list *)
			relationFieldSymbols=DeleteDuplicates@Map[
				If[MatchQ[#,TypeP[]],
					Nothing,
					{Head[#],First[#]}
				]&,
				relationFieldList
			];

			(* Get the type and supertypes of this prepared sample. *)
			preparedSampleTypes=NestWhileList[Most,preparedSample[Type],(Length[#]>1&)];

			(* Based on the type of the prepared object, get the corresponding back link we should use. *)
			possibleBacklinks=Cases[relationFieldSymbols,{Alternatives@@preparedSampleTypes,_}];

			(* Are there possible backlinks to use? *)
			If[Length[possibleBacklinks]>0,
				(* Yes. Use the first one. *)
				Link[preparedSample,Last[First[possibleBacklinks]]],
				(* No. No backlink required. *)
				Link[preparedSample]
			]
		],
		{preparedSamplesConsideringContainers,rawPreparedSamplePositions,preparedSampleContainerPositions}
	];

	(* need to wrap Key around the subfield when dealing with named single or multiple to work with ReplacePart *)
	samplePositionsWithKeyedFields=preparedSamplePositions/.{field:Key[_Symbol],pos___,subField_Symbol}:>{field,pos,Key[subField]};

	(* Use our prepared samples (with links) to replace them into our packet. *)
	replacedProtocolPacket=ReplacePart[protocolPacketWithoutLinkIDs,MapThread[#1->#2&,{samplePositionsWithKeyedFields,preparedSamplesWithLinks}]];

	(* Wrap any multiple fields in Replace[...]. *)
	changeProtocolPacket=Function[{fieldRule},
		(* If we have a multiple field, use Replace[...] *)
		If[MatchQ[Lookup[LookupTypeDefinition[Lookup[protocolPacket,Type],First[fieldRule]],Format],Multiple],
			Replace[First[fieldRule]]->Last[fieldRule],
			fieldRule
		]
	]/@Normal[replacedProtocolPacket];

	(* If changing SamplesIn/ContainersIn, also change WorkingSamples/WorkingContainers. *)
	(* This is because we do not (on purpose) create resources for our WorkingSamples/WorkingContainers so they do not get updated. *)
	updateWorkingSamples=If[KeyExistsQ[changeProtocolPacket,Replace[SamplesIn]],
		Replace[WorkingSamples]->Link[Lookup[changeProtocolPacket,Replace[SamplesIn]]], (* WorkingSamples has no backlink. *)
		Nothing
	];

	updateWorkingContainers=Which[
		KeyExistsQ[changeProtocolPacket,Replace[ContainersIn]],
		{Replace[WorkingContainers] -> Link[Lookup[changeProtocolPacket, Replace[ContainersIn]]]}, (* WorkingContainers has no backlink. *)

		(* If there were no defined objects that had to go into ContainersIn, but we are updating SamplesIn, make sure WorkingContainers is the duplicate free list of the new SamplesIn containers *)
		KeyExistsQ[changeProtocolPacket,Replace[SamplesIn]],
		With[{newContainersIn = Download[Lookup[changeProtocolPacket,Replace[SamplesIn]],Container[Object]]},
			{
				Replace[WorkingContainers] -> Link[DeleteDuplicates[newContainersIn]],
				Replace[ContainersIn] -> Link[newContainersIn, Protocols]
			}
		],
		True, {}
	];

	(* Create our change packet. *)
	changePacket=Association@Join[changeProtocolPacket,{updateWorkingSamples},{updateWorkingContainers}];

	(* Return. *)
	If[MatchQ[Lookup[safeOptions, Upload], False],
		changePacket,
		Upload[changePacket]
	]
];


(* ::Subsection::Closed:: *)
(* resolvePostProcessingOptions *)


resolvePostProcessingOptions[myExperimentOptions:{(_Rule|RuleDelayed)...}]:=Module[{
	parentProtocol,parentPacket,listedGrandparentPackets,listedAncestorPackets,imageSample,measureVolume,
	measureWeight,inheritOption,resolvedImageSample,resolvedMeasureVolume,resolvedMeasureWeight,preparation,
	simulation},

	(* Get the parent protocol listed in the option *)
	parentProtocol=Lookup[myExperimentOptions,ParentProtocol,Null];
	preparation=Lookup[myExperimentOptions,Preparation,Manual];

	(* this is because SampleManipulation has a Simulation option that is a boolean*)
	simulation = Replace[Lookup[myExperimentOptions, Simulation, Null], BooleanP -> Null, {0}];

	(* Download the parent protocol and all other parents up to root *)
	(* Quiet since Maintenance and Qualifications don't have *)
	{parentPacket,listedGrandparentPackets}=If[MatchQ[parentProtocol,Null],
		{<||>,{}},
		Quiet[
			Download[
				parentProtocol,
				{
					Packet[ImageSample,MeasureVolume,MeasureWeight],
					Packet[ParentProtocol..[{ImageSample,MeasureVolume,MeasureWeight}]]
				},
				Simulation -> simulation
			],
			Download::FieldDoesntExist
		]
	];

	(* Get the full recursive list of ParentProtocol packets, include our direct parent *)
	listedAncestorPackets=Prepend[Flatten[listedGrandparentPackets,1],parentPacket];

	(* Lookup the specified options *)
	{imageSample,measureVolume,measureWeight}=Lookup[myExperimentOptions,{ImageSample,MeasureVolume,MeasureWeight},None];

	(* == Define Function: inheritOption == *)
	(* resolve option by looking at root protocol's value *)
	inheritOption[option_Symbol,field_Symbol]:=Which[
		(* If the option wasn't sent in, use indicate with None keyword *)
		MatchQ[option,None], None,

		(* Use user value *)
		MatchQ[option,BooleanP],option,

		(* Default to False if Preparation->Robotic *)
		MatchQ[preparation, Robotic], Null,

		(* Default to True if no parent *)
		MatchQ[parentProtocol,Null],True,

		(* Match root protocol value - should probably use ParentProtocol, but not yet trusted to be doing the same inheritance logic *)
		(* Only set to True, if parent option is True - not $Failed, Null or False *)
		True,MatchQ[Lookup[Last[listedAncestorPackets],field],True|$Failed]
	];

	(* Resolve each post processing option *)
	resolvedImageSample=inheritOption[imageSample,ImageSample];
	resolvedMeasureVolume=inheritOption[measureVolume,MeasureVolume];
	resolvedMeasureWeight=inheritOption[measureWeight,MeasureWeight];

	(* Return the list of resolved options, filtering out any Nones (which indicate we weren't given this option to resolve *)
	DeleteCases[
		{
			ImageSample->resolvedImageSample,
			MeasureVolume->resolvedMeasureVolume,
			MeasureWeight->resolvedMeasureWeight
		},
		(_->None)
	]
];



(* ::Subsection::Closed:: *)
(* hamiltonAliquotContainers *)

hamiltonAliquotContainers[fakeString:_String]:=hamiltonAliquotContainers[fakeString] = Module[
	{},

	(*Add hamiltonAliquotContainers to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`hamiltonAliquotContainers];

	DeleteDuplicates[
		Join[
			PreferredContainer[#,LiquidHandlerCompatible -> True, Type -> Vessel] & /@ {0.5 Milliliter, 1 Milliliter, 5 Milliliter, 50 Milliliter},
			PreferredContainer[#,LiquidHandlerCompatible -> True, Type -> Plate] & /@ {0.5 Milliliter, 1 Milliliter, 3 Milliliter, 5 Milliliter, 51 Milliliter},
			compatibleSampleManipulationContainers[MicroLiquidHandling]
		]
	]
];