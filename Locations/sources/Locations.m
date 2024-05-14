(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Patterns*)


(* ::Subsubsection::Closed:: *)
(*BarcodeP*)


BarcodeP = _String?(StringMatchQ[#,RegularExpression["id:[0-9a-zA-Z]+\\s?"]]&);


(* ::Subsubsection::Closed:: *)
(*RepeatedBarcodeP*)


RepeatedBarcodeP = _String?(MatchQ[StringSplit[#],{Repeated[BarcodeP,{2,Infinity}]}]&);


(* ::Subsection:: *)
(*Location*)


(* ::Subsubsection:: *)
(*Location Options and Messages*)


DefineOptions[Location,
	Options :> {
		{Output -> Table, Association | Table | String, "Determines whether the function returns a list of associations or a table for each object whose location has been requested."},
		{LevelsUp -> Infinity, _Integer?Positive | Infinity, "How many levels of containers above the provided item will be returned as part of the item's location address."},
		{NearestUp -> {}, {} | ListableP[TypeP[{Object[Container], Object[Instrument]}]], "One or more SLL types that will terminate the container tree traversal when encountered."},
		FastTrackOption,
		CacheOption
	}
];

Location::ObjectNotFound = "The object(s) `1` cannot be found in the ECL database.";
Location::InvalidDate = "The provided date, `1`, is not in the past.";


(* ::Subsubsection:: *)
(*Location*)


(* ------------------- New ReverseMapping version of Location -------------------- *)

Location[myItem:ObjectP[LocationTypes], myOps:OptionsPattern[]] := FirstOrDefault[Location[{myItem}, myOps], $Failed];
Location[myItems:{ObjectP[LocationTypes]..}, myOps:OptionsPattern[]] := Module[
	{safeOps, invalidItems, repeatedContainerSpec, typesWithoutNearestUp, directContainers,
		directContainerNames, directContainerModelNames, inputPositions,
		upCtrInfoByInput, upCtrModelNamesByInput, upCtrCtrsByInput, upCtrCtrNamesByInput,
		upCtrContainerModelNamesByInput, locationAssocsByInput,cache,statusInfos,items,connectedLocationNames,connectedLocationModelNames,
		installedLocationNames,installedLocationModelNames, installedLocationNuts, installedLocationFerrules},

	(* default any unspecified or incorrectly specified options *)
	safeOps = SafeOptions[Location, ToList[myOps]];
	cache=Lookup[safeOps,Cache];

	(* If FastTrack is not enabled, check that all inputs are members of the database *)
	invalidItems = If[!(FastTrack/.safeOps),
		PickList[myItems, DatabaseMemberQ[myItems], False],
		{}
	];

	(* If any inputs are not in the database, display a message and return $Failed *)
	If[Length[invalidItems] > 0, Return[Message[Location::ObjectNotFound, invalidItems]; $Failed]];

	(* If myItems contains Object[Plumbing] or Object[Part,Nut]/Object[Part,Ferrule]/Object[Wiring], get Status, ConnectedLocation/InstalledLocation...etc in order to trace Location  *)
	{
		statusInfos,
		connectedLocationNames,
		connectedLocationModelNames,
		installedLocationNames,
		installedLocationModelNames,
		installedLocationNuts,
		installedLocationFerrules
	}=If[MemberQ[myItems,ObjectP[{Object[Plumbing],Object[Part,Nut],Object[Part,Ferrule],Object[Wiring]}]],
		Transpose[
			Quiet[
				Download[myItems,
					{
						Packet[Status,ConnectedLocation,InstalledLocation],
						ConnectedLocation[Name],
						ConnectedLocation[Model][Name],
						InstalledLocation[Name],
						InstalledLocation[Model][Name],
						InstalledLocation[Nuts],
						InstalledLocation[Ferrules]
					},
					Cache->cache,
					Date->Now
				],
			{Download::FieldDoesntExist,Download::MissingField,Download::NotLinkField}
			]
		],
		ReleaseHold@PadRight[{},7,Hold@ConstantArray[{},Length[myItems]]]
	];

	(* If myItems is Object[Plumbing] or Object[Part,Nut]/Object[Part,Ferrule]/Object[Wiring] and its status is Installed, use ConnectedLocation/InstalledLocation to trace Location; If ConnectedLocation/InstalledLocation is not informed, use Object instead *)
	items=If[MemberQ[myItems,ObjectP[{Object[Plumbing],Object[Part,Nut],Object[Part,Ferrule],Object[Wiring]}]],
		Map[
			Which[
				And[MatchQ[Lookup[#,Object],ObjectP[{Object[Plumbing],Object[Wiring]}]],MatchQ[Lookup[#,Status],Installed],MatchQ[Lookup[#,ConnectedLocation],ObjectP[]]],
				Download[Lookup[#,ConnectedLocation],Object],
				And[MatchQ[Lookup[#,Object],ObjectP[{Object[Part,Nut],Object[Part,Ferrule]}]],MatchQ[Lookup[#,Status],Installed],MatchQ[Lookup[#,InstalledLocation],ObjectP[]]],
				Download[Lookup[#,InstalledLocation],Object],
				True,
				Lookup[#,Object]
		]&,statusInfos
		],
		myItems
	];

	(* construct the Repeated field specification based on LevelsUp *)
	repeatedContainerSpec = If[MatchQ[LevelsUp/.safeOps, Infinity],
		Repeated[Container],
		Repeated[Container, LevelsUp/.safeOps]
	];

	(* construct the type termination condition based on the NearestUp option;
		Alternatives only works with == in Download termination condition, so we must get every container/instrument type and
		remove the ones on which we want to terminate *)
	(* The download call below fails if we pass in types that are not sub-types, so also remove Object[Container] and Object[Instrument] themselves (length\[Equal]1) *)
	typesWithoutNearestUp = Select[
		Complement[Types[{Object[Container],Object[Instrument]}],ToList[NearestUp/.safeOps]],
		Length[#]>1&
	];

	(* Download required fields from each container above the input containers in the container tree;
	 	upContainerInfoTuples in the form: {{{Object,Type,Name,Position}..}..}; each first-level element is a group
		of up-container information that corresponds to an initial input;
		use Type termination for NearestUp option; since Type termination will NOT return actual object, we must, at each level, get the
		next container up just in case. Also must do this for initial inputs in case type terminates Download immediately *)
	{
		directContainers, directContainerNames, directContainerModelNames, inputPositions,
		upCtrInfoByInput, upCtrModelNamesByInput,
		upCtrCtrsByInput, upCtrCtrNamesByInput, upCtrContainerModelNamesByInput
	} = Transpose[
		Download[items,
			{
				Container[Object], Container[Name], Container[Model][Name], Position,
				repeatedContainerSpec[{Object, Name, Position}], repeatedContainerSpec[Model][Name],
				repeatedContainerSpec[Container][Object], repeatedContainerSpec[Container][Name], repeatedContainerSpec[Container][Model][Name]
			},
			{
				None, None, None, None,
				Type == Alternatives@@typesWithoutNearestUp, Type == Alternatives@@typesWithoutNearestUp,
				Type == Alternatives@@typesWithoutNearestUp, Type == Alternatives@@typesWithoutNearestUp, Type == Alternatives@@typesWithoutNearestUp
			},
			Cache->(Cache/.safeOps),
			Date->Now
		]
	];

	(* for each up-containers information bundle, re-format the information into location associations;
	 	return an empty list if no up container information was retrieved, UNLESS we terminated due to the NearestUp;
		in this case, the directContainer will be present *)
	locationAssocsByInput = MapThread[
		Function[
			{
				directContainer, directContainerName, directContainerModelName, inputPosition,
				upCtrInfoTuples, upCtrModelNames,
				upCtrContainers, upCtrCtrNames, upCtrContainerModelNames,statusInfo,connectedLocationName,connectedLocationModelName,installedLocationName,installedLocationModelName,
				installedLocationNutList, installedLocationFerruleList
			},
			Module[
				{combinedUpCtrInfoTuples, moddedUpCtrInfoTuples, reversedUpCtrInfoTuples,
					containers, containerNames, positions,locationPackets, positionCheck},

				(* add the up container model names into the info tuples *)
				combinedUpCtrInfoTuples = MapThread[
					Append[#1,#2]&,
					{upCtrInfoTuples, upCtrModelNames}
				];

				(* modify the up ctr info tuples depending on the reason we terminated up ctr traversal *)
				moddedUpCtrInfoTuples = Which[
					(* if the length of the up ctr tuples is 0, AND the direct container's type matches the Nearest up pattern,
					 	create a single up ctr tuple using the direct container information *)
					Length[combinedUpCtrInfoTuples] == 0 && MatchQ[Download[directContainer, Type], TypeP[NearestUp/.safeOps]],
						{{directContainer, directContainerName, inputPosition, directContainerModelName}},

					(* if the length of the up ctr tuples is 0, AND the direct container's type does NOT match the Nearest up pattern,
					 	leave the tuples empty; this means we terminated because this input actually has no Container *)
					Length[combinedUpCtrInfoTuples] == 0 && !MatchQ[Download[directContainer, Type], TypeP[NearestUp/.safeOps]],
						{},

					(* if the length of the up ctr tuples is UNDER the LevelsUp (or LevelsUp is Infinity), AND the type of the last up container's
						container matches the NearestUp exclusion pattern, we need to tack that last tuple on  *)
					(MatchQ[LevelsUp/.safeOps,Infinity] || Length[combinedUpCtrInfoTuples] < (LevelsUp/.safeOps)) && MatchQ[Download[Last[upCtrContainers], Type], TypeP[NearestUp/.safeOps]],
						Append[combinedUpCtrInfoTuples, {Download[Last[upCtrContainers], Object], Last[upCtrCtrNames], Null, Last[upCtrContainerModelNames]}],

					(* if we're not in any of these cases, the up container tuples are fine asis *)
					True,
						combinedUpCtrInfoTuples
				];

				(* return early with an empty list if the up ctr tuples are an empty list *)
				If[MatchQ[moddedUpCtrInfoTuples, {}],
					Return[{}, Module]
				];

				(* reverse the up container infos, to make sure they're in largest->smallest order *)
				reversedUpCtrInfoTuples = Reverse[moddedUpCtrInfoTuples];

				(* slice out the up-container object references from the up container info *)
				containers = reversedUpCtrInfoTuples[[All,1]];

				(* determine the name associated with each up-container
				 	if Name is Null, use Model Name (and if that's Null set name to "") *)
				containerNames = MapThread[
					Function[{containerName,modelName},
						If[!NullQ[containerName],
							containerName,
							If[!NullQ[modelName],
								modelName,
								""
							]
						]
					],
					{reversedUpCtrInfoTuples[[All,2]],reversedUpCtrInfoTuples[[All,4]]}
				];

				(* assemble the positions for each location association; this list is offset by one from the
				 	up container objects, since the position is the position within the up container in which the next
					object down the list is located *)
				positions = Append[Rest[reversedUpCtrInfoTuples[[All,3]]], inputPosition];

				(* create the list of locations associations with the appropriate keys *)
				locationPackets=MapThread[
					<|
						"Object"->#1,
						"Name"->#2,
						"Position"->#3
					|>&,
					{containers, containerNames, positions}
				];

				Which[

					(* If the item is an installed plumbing/wiring object, ConnectedLocation is its first Location; otherwise, output locationPackets *)
					And[MatchQ[Lookup[statusInfo,Object],ObjectP[{Object[Plumbing],Object[Wiring]}]],MatchQ[Lookup[statusInfo,Status],Installed]],
					(* get ConnectedLocation as its first address *)
					Module[{name},
						(* get Name of ConnectedLocation; If not exists, use its Model's Name; If non exists, output "" *)
						name=If[!NullQ[connectedLocationName],
							connectedLocationName,
							If[!NullQ[connectedLocationModelName],
								connectedLocationModelName,
								""
							]
						];

						(* get association address for ConnectedLocation and prepand to locationPackets *)
						Append[locationPackets,
							<|
								"Object"->Lookup[statusInfo,ConnectedLocation][Object],
								"Name"->name,
								"Position"->""
							|>
						]
					],

					(* If the item is an installed fitting object, InstalledLocation is its first Location; otherwise, output locationPackets *)
					And[MatchQ[Lookup[statusInfo,Object],ObjectP[{Object[Part,Nut],Object[Part,Ferrule]}]],MatchQ[Lookup[statusInfo,Status],Installed]],
					(* get InstalledLocation as its first address *)
					Module[{object,name,position},
						object=Lookup[statusInfo,Object];
						(* get Name of InstalledLocation; If not exists, use its Model's Name; If non exists, output "" *)
						name=If[!NullQ[installedLocationName],
							installedLocationName,
							If[!NullQ[installedLocationModelName],
								installedLocationModelName,
								""
							]
						];
						(* get the position where the part has been placed *)
						positionCheck = Which[
							MatchQ[object,ObjectP[Object[Part,Nut]]],
							FirstCase[installedLocationNutList,{_,ObjectP[object],_}][[1]],
							MatchQ[object,ObjectP[Object[Part,Ferrule]]],
							FirstCase[installedLocationFerruleList,{_,ObjectP[object],_}][[1]],
							True,
							""
						];

						position = If[!NullQ[positionCheck],
							positionCheck,
							""
						];
						(* get association address for InstalledLocation and prepend to locationPackets *)
						Append[locationPackets,
							<|
								"Object"->Lookup[statusInfo,InstalledLocation][Object],
								"Name"->name,
								"Position"->position
							|>
						]
					],

					(* otherwise just return the locationPackets *)
					True,
					locationPackets
				]
			]
		],
		{
			directContainers, directContainerNames, directContainerModelNames, inputPositions,
			upCtrInfoByInput, upCtrModelNamesByInput,
			upCtrCtrsByInput, upCtrCtrNamesByInput, upCtrContainerModelNamesByInput,statusInfos,connectedLocationNames,connectedLocationModelNames,installedLocationNames,installedLocationModelNames,
			installedLocationNuts, installedLocationFerrules
		}
	];

	(* Provide output in LocationAssociationP, PlotTable, or String form, depending on options *)
	Switch[Output/.safeOps,
	 	Table, locationTable /@ locationAssocsByInput,
		Association, locationAssocsByInput,
		String, locationString /@ locationAssocsByInput
	]

];

(*Location (past date) *)
Location[myItem:ObjectP[LocationTypes], myPastDate_DateObject, myOps:OptionsPattern[]] := FirstOrDefault[Location[{myItem}, myPastDate, myOps], $Failed];
Location[myItems:{ObjectP[LocationTypes]..}, myPastDate_DateObject, myOps:OptionsPattern[]] := Module[
	{safeOps, invalidItems, cachedPackets, updatedOps, upContainersAndPositions,
	upCtrsRev, containerNames, assocsWithNamesFlat, assocsWithNamesRepartitioned, containerNamesNoNulls},

	safeOps = SafeOptions[Location, ToList[myOps]];

	(* Abort if the provided 'myPastDate' is not in the past *)
	If[myPastDate >= Now, Return[Message[Location::InvalidDate, myPastDate]; $Failed]];

	(* If FastTrack is not enabled, check that all inputs are members of the database *)
	invalidItems = If[!(FastTrack/.safeOps),
		PickList[myItems, DatabaseMemberQ[myItems], False],
		{}
	];

	(* If any inputs are not in the database, display a message and return $Failed *)
	If[Length[invalidItems] > 0, Return[Message[Location::ObjectNotFound, invalidItems]; $Failed]];

	(* Download partial packets for input items containing the relevant fields *)
	cachedPackets = Download[myItems, Packet[Name, LocationLog]];
	updatedOps = ReplaceRule[safeOps, Cache -> Join[Lookup[safeOps, Cache], DeleteDuplicates[cachedPackets]]];

	(* Get all up containers for 'myItem' on specified past date *)
	(* Returns a flat list of lists of {position, container} pairs *)
	upContainersAndPositions = Flatten /@ traverseLocationLog[
		cachedPackets,
		myPastDate,
		Lookup[updatedOps, LevelsUp],
		EndPattern -> ObjectReferenceP[Lookup[updatedOps, NearestUp]],
		Cache -> Lookup[updatedOps, Cache]
	];

	(* Reverse up containers to get a list from largest to smallest *)
	upCtrsRev = Reverse /@ upContainersAndPositions;

	(* Download relevant fields of each upContainer *)
	containerNames = Download[Lookup[Flatten[upCtrsRev], "Object", {}],	Name];

	(* Replace all 'Null' names with "" *)
	containerNamesNoNulls = ReplaceAll[containerNames, Null->""];

	(* Add Name rule to each association (must flatten to do so) *)
	assocsWithNamesFlat = MapThread[
		Insert[#1, "Name"->#2, 2]&,
		{Flatten[upCtrsRev], containerNamesNoNulls}
	];

	(* Repartition location associations into original groups *)
	assocsWithNamesRepartitioned = If[MatchQ[assocsWithNamesFlat, {}],
		Table[{}, Length[myItems]],
		Unflatten[assocsWithNamesFlat, upCtrsRev]
	];

	(* Provide output in LocationAssociationP, PlotTable, or String form, depending on options *)
	Switch[Lookup[updatedOps, Output],
	 	Table, locationTable /@ assocsWithNamesRepartitioned,
		Association, assocsWithNamesRepartitioned,
		String, locationString /@ assocsWithNamesRepartitioned
	]

];


(* ::Subsubsection::Closed:: *)
(*locationTable*)


(* Given a list of location associations, returns an easy-to-read PlotTable *)
locationTable[{}] := {};
locationTable[myLocationList:{LocationAssociationP..}] := Module[
	{tableHeaders, tableContents},

	tableHeaders = {"Object", "Name", "Position"};

	(* Pull all information from location associations into a table-friendly list of lists *)
	tableContents = Lookup[myLocationList, tableHeaders];

	(* Assemble headings and content into a table *)
	PlotTable[tableContents, TableHeadings -> {None, tableHeaders}]

];


(* ::Subsubsection::Closed:: *)
(*locationString*)


(* Given a list of location associations, returns a human-readable location string *)
locationString[{}] := "No location found";
locationString[myLocationList:{LocationAssociationP..}] := Module[
	{objects, names, positions, objectPlusPositionStrings},

	(* Extract objects, names, and positions from location associations *)
	objects = Lookup[myLocationList, "Object"];
	names = Lookup[myLocationList, "Name"];
	positions = Lookup[myLocationList, "Position"];

	(* Join each object's name with its position with appropriate separators *)
	objectPlusPositionStrings = MapThread[
		Function[
			{name,pos},
			StringJoin[name, StringJoin[" [", pos, "]"]]
		],
		{names,positions}
	];

	(* Assemble the set of object[position] strings into a single location string, using commas as separators *)
	StringJoin[Riffle[objectPlusPositionStrings, ", "]]

];


(* ::Subsubsection::Closed:: *)
(*traverseLocationLog*)


DefineOptions[
	traverseLocationLog,
	Options :> {
		{EndPattern->Alternatives[], _, "A pattern that will terminate traversal if it is encountered on any branch."},
		CacheOption,
		FastTrackOption
	}
];

(* Traverses 'FieldName' field repeatedly until 'Levels' traversals have been done, or until 'EndPattern' is matched on any given branch *)
traverseLocationLog[myItems:{PacketP[]..}, myPastDate_DateObject, levelsRemaining:(_Integer?NonNegative | Infinity), myOps:OptionsPattern[]] := Module[
	{safeOps, endPattern, incomingCache, locationLogs, pastContainersAndPositions, terminalConnectedItems, connectedItemsNoTerminals,
	connectedItemsObjects, nextLevel, nonTerminalItemPositions, nextLevelPadded, nonTerminalItemMask},

	(* Get safe options *)
	safeOps = If[!TrueQ[OptionValue[FastTrack]],
		SafeOptions[traverseLocationLog, ToList[myOps]],
		ToList[myOps]
	];

	(* Pull out necessary option values *)
	endPattern = Lookup[safeOps, EndPattern];
	incomingCache = Lookup[safeOps, Cache];

	(* Extract the location logs *)
	locationLogs = Lookup[myItems, LocationLog];

	(* Identify the branch to follow; each element will be in the form {"position", container} or {Null,Null} *)
	pastContainersAndPositions = Map[
		extractLocationAtTime[#, myPastDate]&,
		locationLogs
	];

	(* Generate a mask that distinguishes terminal/empty items from those that should continue traversal *)
	nonTerminalItemMask = Map[
		MatchQ[#, Except[{_,endPattern} | NullP]]&,
		pastContainersAndPositions
	];

	(* Remove Null entries and terminal descendants *)
	connectedItemsNoTerminals = PickList[pastContainersAndPositions, nonTerminalItemMask, True];

	(* Separate out only the objects of all connected items *)
	connectedItemsObjects = Download[connectedItemsNoTerminals[[All,2]], Object];

	(* Traverse the next level down after flattening, then separate the return back into lists of appropriate dimensions *)
	nextLevel = If[levelsRemaining > 1,
		(* If this isn't the last level (levelsRemaining == 1), traverse the next level *)
		traverseLocationLog[
			Download[
				connectedItemsObjects,
				Packet[LocationLog],
				Cache->incomingCache
			],
			myPastDate,
			levelsRemaining-1,
			Sequence@@ReplaceRule[safeOps, FastTrack->True]
		],
		(* If this is the last level, return properly partitioned empty lists for every next-level item *)
		Table[Null, Length[connectedItemsObjects]]
	];

	(* Get the positions of all non-terminal items that were passed on to the next iteration *)
	nonTerminalItemPositions = Flatten[Position[nonTerminalItemMask, True]];

	(* Pad nextLevel with Nulls in appropriate positions to account for traversal threads that have been terminated *)
	nextLevelPadded = ReplacePart[
		Repeat[Null, Length[pastContainersAndPositions]],
		MapThread[Rule, {nonTerminalItemPositions, nextLevel}]
	];

	(* For each input item, append a list of its descendants at the next level *)
	MapThread[
		Function[
			{singleContainerAndPosition, singleNextLevel},
			If[NullQ[singleContainerAndPosition],
				(* If the input item has no location, return {} *)
				{},
				If[MatchQ[singleNextLevel,Null],
					(* If the next level is Null, return an Association containing just this level's location information *)
					{AssociationThread[{"Object", "Position"}, Reverse[singleContainerAndPosition]]},
					(* If the next level is non-Null, append this level's Association with any from higher levels *)
					{AssociationThread[{"Object", "Position"}, Reverse[singleContainerAndPosition]], singleNextLevel}
				]
			]
		],
		{
			pastContainersAndPositions,
			nextLevelPadded
		}
	]

];
(* If no more connected items exist to traverse, return an empty list *)
traverseLocationLog[myItem:{}, myPastDate_DateObject, levelsRemaining:(_Integer?NonNegative | Infinity), myOps:OptionsPattern[]] := {};
(* If no more levels have been requested, return empty lists for all requested items *)
traverseLocationLog[myItems:{ObjectP[]..}, myPastDate_DateObject, 0, myOps:OptionsPattern[]] := Table[Null, Length[myItems]];


(* ::Subsubsection::Closed:: *)
(*extractLocationAtTime*)


(* Extracts the most recent LocationLog 'In' entry before 'pastTime' *)
extractLocationAtTime[{}, pastTime_?DateObjectQ] := Null;
extractLocationAtTime[locationLog:{_List..}, pastTime_DateObject] := Module[
	{locationLogFiltered, pastContainer,pastPosition,sortedLog,previousLogPosition},

	(* Select only the 'In' entries from the location log *)
	locationLogFiltered = Cases[locationLog, {_,In,___}];

	(* Sort the log by date, inserting the specific time we're looking at *)
	sortedLog = SortBy[
		Join[locationLogFiltered, {{pastTime}}],
		DateList[First[#]]&
	];

	(* Find the latest In before the date we're looking at*)
	previousLogPosition = Position[sortedLog,{pastTime}][[1,1]]-1;

	(* Return the object's position and container at pastTime *)
	If[previousLogPosition==0,
		Null,
		{
			sortedLog[[previousLogPosition,4]],
			Download[sortedLog[[previousLogPosition,3]],Object]
		}
	]

];



(* ::Subsection:: *)
(*PlaceItems*)


(* ::Subsubsection::Closed:: *)
(*PlaceItems Options and Messages*)


DefineOptions[PlaceItems,
	Options:>{
		{Layout->Null,ListableP[(Null|ObjectP[Model[DeckLayout]])],"A layout of racks for a model destination that should be taken into consideration when looking for proper positions for placing items.",IndexMatching->Input},
		{OpenFootprint->False,ListableP[BooleanP],"Indicates if open footprint positions should be included when placing items with footprints.",IndexMatching->Input},
		{LevelsDown->Infinity,ListableP[_Integer?NonNegative|Infinity],"The number of times to look at Contents of the destination to look for possible locations for placing the items.",IndexMatching->Input},
		CacheOption,
		SimulationOption,
		FastTrackOption
	}
];

PlaceItems::InputLengthMismatch="The length of the input lists do not match. Please provide input lists of the same length.";
PlaceItems::OptionLengthMismatch="The length of the `1` option is not the same as the input lists' length. Please provide a list matching the input lists' length, or alternatively, a single option value may be supplied.";
PlaceItems::DuplicateItems="The input item groups at positions `1` contain duplicate Objects; duplicated Objects have been ignored.";
PlaceItems::UnrecognizedLayout="The following destination/layout pairs are invalid, as the layout is not in the destination's AvailableLayouts field: `1`. For these destinations, please specify a layout present in AvailableLayouts.";
PlaceItems::NoPlacementsFound="No placements were found for the item groups at positions `1`. Please call openLocations on individual items in these groups with the destination at the provided indices, or consider allowing open footprints to be considered with the OpenFootprint option.";
PlaceItems::NoRacksFound="No Model[Container,Rack]s were found for the search condition(s) at position(s) `1`. Please call openLocations on individual items in these groups with the destination at the provided indices, or consider allowing open footprints to be considered with the OpenFootprint option.";




(* ::Subsubsection:: *)
(*PlaceItems*)


(* empty items to place short-circuit *)
PlaceItems[{},___]:={};

(* Single Group of Items to Place, Single Search Condition *)
PlaceItems[
	myItemsToPlace:{(ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}])..},
	mySearchCondition:Hold[_],
	myOptions:OptionsPattern[]
]:=Module[{coreOverloadReturn},

	(* assign the output of the core overload to a local variable *)
	coreOverloadReturn=PlaceItems[{myItemsToPlace},{mySearchCondition},myOptions];

	(* return a flat failure if that's what the core overload gave; otherwise, take First (assume it worked) *)
	If[MatchQ[coreOverloadReturn,$Failed],
		$Failed,
		First[coreOverloadReturn]
	]
];

(* List of Groups of Items, List of Search Conditions *)
PlaceItems[
	myItemGroupsToPlace:{{(ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}])..}..},
	mySearchConditions:{Hold[_]..},
	myOptions:OptionsPattern[]
]:=Module[{searchResults,failedSearchPositions,coreOverloadReturn},

	(*Gather the first Model[Container,Rack] that satisfies each Search criteria*)
	searchResults=Search[
		Table[Model[Container,Rack],Length[mySearchConditions]],
		mySearchConditions,
		MaxResults->1
	];

	(*If any of the Search conditions returned no results, return early  *)
	failedSearchPositions=Position[Map[Length,searchResults],0];
	If[Length[failedSearchPositions]>0,
		Message[PlaceItems::NoRacksFound,failedSearchPositions];
		Return[$Failed]
	];

	(* assign the output of the core overload to a local variable *)
	coreOverloadReturn=PlaceItems[myItemGroupsToPlace,Flatten[searchResults],myOptions];

	(* return a flat failure if that's what the core overload gave; otherwise return what it gave *)
	If[MatchQ[coreOverloadReturn,$Failed],
		$Failed,
		coreOverloadReturn
	]
];

(* List of Groups of Items, Mixed List of Destinations or Search Conditions *)
(* Search isn't happy with how the conditions are being passed in here, so commenting
 this overload out while I figure out how to properly deal with Search *)
(*PlaceItems[
	myItemGroupsToPlace:{{(ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}])..}..},
	myDestinationsOrSearchConditions:{(Hold[_]|ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}])..},
	myOptions:OptionsPattern[]
]:=Module[{searchConditionPositions,searchConditions,searchResults,failedSearchPositions,coreOverloadReturn},

	(* Gather the input positions that the contain a search condition *)
	searchConditionPositions=Position[myDestinationsOrSearchConditions, Hold[_]];

	(* Gather the list of search conditions *)
	searchConditions=myDestinationsOrSearchConditions[[Flatten[searchConditionPositions]]];

	(* Gather the first Model[Container,Rack] that satisfies each Search criteria *)
	searchResults=Search[
		Table[Model[Container,Rack],Length[Flatten[searchConditionPositions]]],
		myDestinationsOrSearchConditions[[Flatten[searchConditionPositions]]],
		MaxResults->1
	];

	(* If any of the Search conditions returned no results, return early  *)
	failedSearchPositions=Position[Map[Length,searchResults],0];
	If[Length[failedSearchPositions]>0,
		Message[PlaceItems::NoRacksFound,searchConditionPositions[[Flatten[failedSearchPositions]]]];
		Return[$Failed]
	];

	(* assign the output of the core overload to a local variable *)
	coreOverloadReturn=PlaceItems[myItemGroupsToPlace,Flatten[searchResults],myOptions];

	(* return a flat failure if that's what the core overload gave; otherwise, take First (assume it worked) *)
	If[MatchQ[coreOverloadReturn,$Failed],
		$Failed,
		First[coreOverloadReturn]
	]
];*)

(* Single Group of Items to Place, Single Destination *)
PlaceItems[
	myItemsToPlace:{(ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}])..},
	myDestination:ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],
	myOptions:OptionsPattern[]
]:=Module[{coreOverloadReturn},

	(* assign the output of the core overload to a local variable *)
	coreOverloadReturn=PlaceItems[{myItemsToPlace},{myDestination},myOptions];

	(* return a flat failure if that's what the core overload gave; otherwise, take First (assume it worked) *)
	If[MatchQ[coreOverloadReturn,$Failed],
		$Failed,
		First[coreOverloadReturn]
	]
];

(* CORE OVERLOAD: List of Groups of Items, List of Destinations, List of Layouts *)
PlaceItems[
	myItemGroupsToPlace:{{(ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}])..}..},
	myDestinations:{ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}]..},
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions,rawLayout,rawOpenFootprint,rawLevelsDown,inputCache,simulation,fastTrack,expandedLayout,expandedOpenFootprint,expandedLevelsDown,
		positionsWithDuplicateItems,itemGroupsSansDuplicateObjects,flatItemsToPlace,itemFieldSpecs,layoutFieldSpecs,destinationFieldSpecs,allFieldValues,flatItemDownloadTuples,
		destinationDownloadTuples,layoutDownloadTuples,newCache,invalidModelLayoutPairs,layoutsToConsiderByDestination,
		openLocationsByItemGroup,placementSetFunction,placementSets,failedPositions},

	(* default any unspecified or incorrectly-specified option values *)
	safeOptions=SafeOptions[PlaceItems, ToList[myOptions]];

	(* assign FastTrack and Cache option values *)
	inputCache=Lookup[safeOptions,Cache];
	simulation=Lookup[safeOptions,Simulation];
	fastTrack=Lookup[safeOptions,FastTrack];

	(* If input argument lengths are not the same, fail *)
	If[!fastTrack&&!SameLengthQ[myItemGroupsToPlace,myDestinations],
		Message[PlaceItems::InputLengthMismatch];
		Return[$Failed]
	];

	(* assign the raw Layout, OpenFootprint, LevelsDown option values *)
	rawLayout=Lookup[safeOptions,Layout];
	rawOpenFootprint=Lookup[safeOptions,OpenFootprint];
	rawLevelsDown=Lookup[safeOptions,LevelsDown];

	(* If Layout is specified as a list but its length does not match input, fail *)
	If[!fastTrack&&ListQ[rawLayout]&&!SameLengthQ[myItemGroupsToPlace,rawLayout],
		Message[PlaceItems::OptionLengthMismatch,Layout];
		Return[$Failed]
	];

	(* If OpenFootprint is specified as a list but its length does not match input, fail *)
	If[!fastTrack&&ListQ[rawOpenFootprint]&&!SameLengthQ[myItemGroupsToPlace,rawOpenFootprint],
		Message[PlaceItems::OptionLengthMismatch,OpenFootprint];
		Return[$Failed]
	];

	(* If LevelsDown is specified as a list but its length does not match input, fail *)
	If[!fastTrack&&ListQ[rawLevelsDown]&&!SameLengthQ[myItemGroupsToPlace,rawLevelsDown],
		Message[PlaceItems::OptionLengthMismatch,LevelsDown];
		Return[$Failed]
	];

	(* Extend length of Layout/OpenFootprint/LevelsDown to match input argument list lengths *)
	expandedLayout=If[ListQ[rawLayout],
		rawLayout,
		ConstantArray[rawLayout,Length[myItemGroupsToPlace]]
	];
	expandedOpenFootprint=If[ListQ[rawOpenFootprint],
		rawOpenFootprint,
		ConstantArray[rawOpenFootprint,Length[myItemGroupsToPlace]]
	];
	expandedLevelsDown=If[ListQ[rawLevelsDown],
		rawLevelsDown,
		ConstantArray[rawLevelsDown,Length[myItemGroupsToPlace]]
	];

	(* detect the positions of any item groups that have duplicated Objects; we don't want to try to place the same item twice *)
	positionsWithDuplicateItems=If[!fastTrack,
		MapIndexed[
			Function[{itemGroup,index},
				(* only consider objects when looking for duplicates *)
				If[!DuplicateFreeQ[Download[Cases[itemGroup,ObjectP[Object]],Object]],
					index,
					Nothing
				]
			],
			myItemGroupsToPlace
		],
		{}
	];

	(* if any positions had duplicate items, throw a warning before collapsing *)
	If[!fastTrack&&MatchQ[positionsWithDuplicateItems,{{_Integer}..}],
		Message[PlaceItems::DuplicateItems,positionsWithDuplicateItems]
	];

	(* now, whether we warned or not, definitely do remove duplicate Objects from the item groups *)
	itemGroupsSansDuplicateObjects=Map[
		Function[itemGroup,
			DeleteDuplicates[Download[itemGroup,Object],MatchQ[#1,ObjectP[Object]]&&MatchQ[#2,ObjectP[Object]]&&MatchQ[#1,#2]&]
		],
		myItemGroupsToPlace
	];

	(* flatten the item groups to place for Downloading *)
	flatItemsToPlace=Flatten[itemGroupsSansDuplicateObjects];

	(* If item is a model, fetch its Dimensions and Footprint. If item is an object, traverse through its model. *)
	itemFieldSpecs=Map[
		If[MatchQ[#,ObjectP[Model]],
			{Packet[Dimensions,Footprint]},
			{Packet[Model[{Dimensions,Footprint}]]}
		]&,
		flatItemsToPlace
	];

	(* If a layout is specified, download relevant fields; otherwise, download {} from Null (this leaves a Null) *)
	layoutFieldSpecs=MapThread[
		If[MatchQ[#1,ObjectP[Model[DeckLayout]]],
			Join[
				{
					(* Fetch parent deck layout packet *)
					Packet[Layout,NestedLayout],
					(* Fetch deck layout's model positions *)
					Packet[Field[Layout[[All,2]]][{Positions}]]
				},
				(* If LevelsDown is specified, insert it as an argument to Repeated, otherwise download entire tree *)
				If[MatchQ[#2,Infinity],
					{
						(* Traverse NestedLayout and fetch each's Layout *)
						Packet[Repeated[Field[NestedLayout[[All,2]]]][{Layout,NestedLayout}]],
						(* Fetch the positions for all models in each NestedLayout's Layout *)
						Packet[Repeated[Field[NestedLayout[[All,2]]]][Field[Layout[[All,2]]]][{Positions}]]
					},
					{
						Packet[Repeated[Field[NestedLayout[[All,2]]],#2][{Layout,NestedLayout}]],
						Packet[Repeated[Field[NestedLayout[[All,2]]],#2][Field[Layout[[All,2]]]][{Positions}]]
					}
				]
			],
			{}
		]&,
		{expandedLayout,expandedLevelsDown}
	];

	(* Depending on whether the destination is an object or model, download different fields *)
	destinationFieldSpecs=MapThread[
		If[MatchQ[#1,ObjectP[Model]],
			Join[
				{
					(* Fetch parent packet, as well as its AvailableLayout's layout, and its model's positions *)
					Packet[Positions,AvailableLayouts],
					Packet[Field[AvailableLayouts][{Layout,NestedLayout}]],
					Packet[Field[AvailableLayouts][Field[Layout[[All,2]]]][{Positions}]]
				},
				(* Fetch AvailableLayout's layout tree, and its model's positions *)
				If[MatchQ[#3,Infinity],
					{
						Packet[Field[AvailableLayouts][Repeated[Field[NestedLayout[[All,2]]]]][{Layout,NestedLayout}]],
						Packet[Field[AvailableLayouts][Repeated[Field[NestedLayout[[All,2]]]]][Field[Layout[[All,2]]]][{Positions}]]
					},
					{
						Packet[Field[AvailableLayouts][Repeated[Field[NestedLayout[[All,2]]],#3]][{Layout,NestedLayout}]],
						Packet[Field[AvailableLayouts][Repeated[Field[NestedLayout[[All,2]]],#3]][Field[Layout[[All,2]]]][{Positions}]]
					}
				]
			],
			(* If destination is a specific object, fetch contents tree *)
			If[MatchQ[#3,Infinity],
				{
					Packet[Model,Contents],
					Packet[Repeated[Field[Contents[[All,2]]]][{Contents,Model}]],
					Packet[Repeated[Field[Contents[[All,2]]]][Model][Positions]],
					Packet[Model[Positions]]
				},
				{
					Packet[Model,Contents],
					Packet[Repeated[Field[Contents[[All,2]]],#3][{Contents,Model}]],
					Packet[Repeated[Field[Contents[[All,2]]],#3][Model][Positions]],
					Packet[Model[Positions]]
				}
			]
		]&,
		{myDestinations,expandedLayout,expandedLevelsDown}
	];

	(* Download item, destination, and decklayout's field values *)
	allFieldValues=Quiet[Download[
		Join[flatItemsToPlace,myDestinations,expandedLayout],
		Evaluate[Join[itemFieldSpecs,destinationFieldSpecs,layoutFieldSpecs]],
		Cache->inputCache,
		Simulation->simulation
	],{Download::FieldDoesntExist}];

	(* separate download tuples from each of the groups of inputs *)
	{flatItemDownloadTuples,destinationDownloadTuples,layoutDownloadTuples}=FoldPairList[TakeDrop,allFieldValues,Length/@{flatItemsToPlace,myDestinations,expandedLayout}];

	(* also do a full flattening of every packet we downloaded since we will be passing all of this as Cache to openLocations *)
	newCache=DeleteDuplicatesBy[Join[inputCache,DeleteCases[Flatten[allFieldValues],Null|$Failed]],Lookup[#,Object]&];

	(* return model/layout pairs that are invalid, if not on FastTrack *)
	invalidModelLayoutPairs=If[!fastTrack,
		MapThread[
			Function[{destination,destinationDownloadTuple,layout},
				If[MatchQ[destination,ObjectP[Model]]&&!NullQ[layout]&&!MemberQ[Download[Lookup[destinationDownloadTuple[[1]],AvailableLayouts],Object],Download[layout,Object]],
					{destination,layout},
					Nothing
				]
			],
			{myDestinations,destinationDownloadTuples,expandedLayout}
		],
		{}
	];

	(* if we have any invalid model/layout pairs, report all of them at once and fail *)
	If[!fastTrack&&MatchQ[invalidModelLayoutPairs,{{ObjectP[],ObjectP[]}..}],
		Message[PlaceItems::UnrecognizedLayout,invalidModelLayoutPairs];
		Return[$Failed]
	];

	(* for each destination, determine which layouts need to be considered when trying to calculate placements *)
	layoutsToConsiderByDestination=MapThread[
		Function[{destination,destinationDownloadTuple,layout},

			(* convert the layouts into a list of layouts to try; if the destination is a Model,
				this is either the specified layout, or ALL AvailableLayouts (with Null as placeholder for empty AvailableLayouts);
				if dealing with an object destination, always ignore any layout argument and just send {Null} *)
			Which[
				MatchQ[destination,ObjectP[Model]]&&!NullQ[layout],{layout},
				MatchQ[destination,ObjectP[Model]]&&NullQ[layout],
					Module[{destinationAvailableLayouts},

						(* pull the available layouts from the first of this destination's tuples, which has the model packet in this case *)
						destinationAvailableLayouts=Download[Lookup[destinationDownloadTuple[[1]],AvailableLayouts],Object];

						(* if there are layouts, just return all of them; otherwise, use {Null} to indicate just the destination straight-up should be plumbed for openLocations *)
						If[MatchQ[destinationAvailableLayouts,{ObjectReferenceP[Model[DeckLayout]]..}],
							destinationAvailableLayouts,
							{Null}
						]
					],
				MatchQ[destination,ObjectP[Object]],{Null}
			]
		],
		{myDestinations,destinationDownloadTuples,expandedLayout}
	];

	(*OLD version mapping download-REMOVE when done
	openLocationsByItemGroup=MapThread[
		Function[{itemGroupToPlace,destination,layoutsToConsider,levelsDown,openFootprint},
			(* repeatedly call openLocations with the group of items, the appropriate options, and each of the layouts to consider *)
			Map[
				Function[layoutToConsider,
					openLocations[
						ConstantArray[destination,Length[itemGroupToPlace]],itemGroupToPlace,ConstantArray[layoutToConsider,Length[itemGroupToPlace]],
						FastTrack->True,Cache->newCache,LevelsDown->levelsDown,OpenFootprint->openFootprint
					]
				],
				layoutsToConsider
			]
		],
		{itemGroupsSansDuplicateObjects,myDestinations,layoutsToConsiderByDestination,expandedLevelsDown,expandedOpenFootprint}
	];*)

	(*for each group of items to place, we want to call openLocations with the associated destination and ALL possible layouts (or the one specified), to determine where each item can go INDIVIDUALLY;
	 	this line spits out a very nested list, where EACH ELEMENT looks like: openLocationsByItemPerLayout:{{{{destination,positionName}..}..}..} *)
	(*New listable version to avoid mapping download*)
	openLocationsByItemGroup=Module[{destinationsExpanded,itemGroupsExpanded,layoutsToConsiderExpanded,collapsedOpenLocationsOutput,outputPerDestination,openLocationOutputByDestination,openLocationOutputByItem,
		fullyExpandedLevelsDown,fullyExpandedOpenFootprint},
		(*Arrange the full lists of all the destinations, itemGroups, and layouts as expanded lists to call openLocations on*)
		{
			destinationsExpanded,
			itemGroupsExpanded,
			layoutsToConsiderExpanded,
			fullyExpandedLevelsDown,
			fullyExpandedOpenFootprint
		}=Transpose[
			Partition[
				Flatten[
					MapThread[
						Function[{itemGroupToPlace,destination,layoutsToConsider,levelsDown,openFootprint},
							(* repeatedly call openLocations with the group of items, the appropriate options, and each of the layouts to consider *)
							Map[
								Function[layoutToConsider,
									Transpose[
										{
											ConstantArray[destination,Length[itemGroupToPlace]],
											itemGroupToPlace,
											ConstantArray[layoutToConsider,Length[itemGroupToPlace]],
											ConstantArray[levelsDown,Length[itemGroupToPlace]],
											ConstantArray[openFootprint,Length[itemGroupToPlace]]
										}
									]
								],
								layoutsToConsider
							]
						],
						{itemGroupsSansDuplicateObjects,myDestinations,layoutsToConsiderByDestination,expandedLevelsDown,expandedOpenFootprint}
					]
				],
				5
			]
		];

	(*only call openLocations once with a full list of all the destinations, itemGroups, and layouts as expanded lists*)
		collapsedOpenLocationsOutput=openLocations[
			destinationsExpanded,
			itemGroupsExpanded,
			layoutsToConsiderExpanded,
			FastTrack->True,
			Cache->newCache,
			Simulation->simulation,
			LevelsDown->fullyExpandedLevelsDown,
			OpenFootprint->fullyExpandedOpenFootprint
		];
		(*To match the prior output list levels, nest everything further to preserve the old output format. Could remove this line if not needed in the future*)

		(* Step 1 - Group back by destination *)
		outputPerDestination=MapThread[
			Length[#1]*Length[#2]&,
			{itemGroupsSansDuplicateObjects,layoutsToConsiderByDestination}
		];
		openLocationOutputByDestination=TakeList[collapsedOpenLocationsOutput,outputPerDestination];

		(* Step 2 - Group back by Item *)
		openLocationOutputByItem=MapThread[
			Partition[#2,Length[#1]]&,
			{itemGroupsSansDuplicateObjects,openLocationOutputByDestination}
		];

		openLocationOutputByItem
	];

	(* write a helper which, given a list of items, and open locations for each of these items, eliminates duplicate entries such that each item is being placed in a unique, single location;
	 	returns Placement primitives, or a single $Failed if some items couldn't be placed *)
	placementSetFunction[myItemsToPlace:{ObjectP[]..},myOpenLocationsByItem:{{{ObjectReferenceP[],LocationPositionP}...}..},myLayout:(Null|ObjectP[Model[DeckLayout]])]:=Module[
		{openLocationsWithUniqueModels,itemToLocationEdges,possibleItemsToLocations,impossibleItems},

		(* right away, if any of the items do not even have a single possible location, we know enough to fail *)
		If[MemberQ[myOpenLocationsByItem,{}],
			Return[$Failed]
		];

		(* first we need to handle a bit of weirdness from openLocations; in the destination model with layout case, its possible that openLocations returned multiple identical locations;
		 	i.e. {Model[Container,Rack,"Tube Rack"],"A1"} and  {Model[Container,Rack,"Tube Rack"],"A1"}; but really these are talking about two distinct locations as part of a layout;
			we want to add uniqueness to such cases, but preserve matching between locations for items; as in, if itemA and itemB both have {Model[Container,Rack,"Tube Rack"],"A1"} TWICE,
			we want to make sure we can differentiate between the "first" and "second" instance of the location, to detect that we can indeed place both items;
			so, within each open locations list, add an integer, starting from 1, convert {ObjectP[Model],LocationPositionP} =>  {ObjectP[Model],LocationPositionP,integer} *)
		openLocationsWithUniqueModels=Map[
			Function[openLocationsForItem,
				If[MatchQ[openLocationsForItem,{{ObjectP[Model],LocationPositionP}..}],
					Fold[
						Function[{updatedLocations,currentLocationToAdd},
							Module[{existingIdenticalLocations,integerTag},

								(* see if we can find any existing locations in the already-updated locations that has the same model/positions as this current one we're looking at;
								 	remember that everything in updatedLocations has an extra index now *)
								existingIdenticalLocations=Select[updatedLocations,MatchQ[Most[#],currentLocationToAdd]&];

								(* if we drummed up any existing instances of this model/position pair, get the largest integer tacked onto any of these, and add 1;
								 	otherwise, return 1, as this is the first time we've seen this model/position pair *)
								integerTag=If[MatchQ[existingIdenticalLocations,{}],
									1,
									Max[existingIdenticalLocations[[All,3]]]+1
								];

								(* append the new tag to our location, and then add that to our growing list of updated locations *)
								Append[updatedLocations,Append[currentLocationToAdd,integerTag]]
							]
						],
						{},
						openLocationsForItem
					],
					(* if we have specific objects, there's no ambiguity; just let em ride *)
					openLocationsForItem
				]
			],
			myOpenLocationsByItem
		];

		(* for each pair of items and possible locations by item, create an item->possibleLocation rule; we are going to make a Graph to optimize finding a matching set of placements;
		 	since the items can ALSO be models, we want to add uniqueness to them in case we have duplicate models (previous error-checking ensures we don't have duplicate objects) *)
		itemToLocationEdges=Flatten[MapThread[
			Function[{item,openLocationsForItem},
				Module[{uniqueTag},

					(* generate a single unique tag for the item being placed; not necessary for Objects, but we'll do it anyhow for consistency *)
					uniqueTag=Unique[];

					(* create edges for sending to FindIndependentEdgeSet; this function will preference later copies of the same position, but we would prefer to front-load,
					 	i.e. preserve the order returned by openLocations; therefore, reverse the open locations by item here *)
					{uniqueTag,item}->#&/@Reverse[openLocationsForItem]
				]
			],
			{myItemsToPlace,openLocationsWithUniqueModels}
		],1];

		(* convert these edges into a graph, and then use mathematicas sweet function that will find a set of item->location edges that do not interfere;
		 	it will only implicitly alert that an item could not be satisfied, in that that item will not be in the list of edges at all; we'll handle that in a sec *)
		possibleItemsToLocations=FindIndependentEdgeSet[Graph[itemToLocationEdges]];

		(* detect if anything got left out *)
		impossibleItems=Complement[itemToLocationEdges[[All,1]],possibleItemsToLocations[[All,1]]][[All,2]];

		(* if we couldn't place everything, we have failed; return this failure and be sad *)
		If[MatchQ[impossibleItems,{ObjectP[]..}],
			Return[$Failed]
		];

		(* now we know that every item is represented in possibleItemsToLocations; we can convert these into placements!
			remember to remove the last index of model-containing locations, and use the layout if present;
			ALSO remember to remove tag from the item *)
		Map[
			Function[itemToLocationEdge,
				Module[{item,location,fixedItem,fixedLocation},

					(* separate the item and location; FindIndependentEdgeSet gives us Edges, which aren't EXACTLY rules, but we can separate them with First/Last *)
					{item,location}={First[itemToLocationEdge],Last[itemToLocationEdge]};

					(* remove the Unique symbol we added to the front to disambiguate multiple models *)
					fixedItem=Last[item];

					(* fix the location if it has length of 3 (we added an integer for disambiguation in the graph consideration) *)
					fixedLocation=If[Length[location]==3,
						Most[location],
						location
					];

					(* create a Placement primitive; Placement head doesn't handle Nothing, so branch beforehand with myLayout *)
					If[MatchQ[myLayout,ObjectP[Model[DeckLayout]]],
						Placement[Item->fixedItem,Destination->First[fixedLocation],Position->Last[fixedLocation],Layout->myLayout],
						Placement[Item->fixedItem,Destination->First[fixedLocation],Position->Last[fixedLocation]]
					]
				]
			],
			possibleItemsToLocations
		]
	];

	(* now we can use our handy function above on each of the possible location sets given to us by openLocations; for each item group, find the first considered layout that works;
	 	if NONE do, then propagate that failure *)
	placementSets=MapThread[
		Function[{itemGroup,openLocationGroupsByLayout,consideredLayouts},
			Module[{placementSetsByLayout},

				(* for each of our considered layouts, generate the placement group *)
				placementSetsByLayout=MapThread[
					Function[{openLocationGroupByItem,layout},
						placementSetFunction[itemGroup,openLocationGroupByItem,layout]
					],
					{openLocationGroupsByLayout,consideredLayouts}
				];

				(* select the first of these that is actually a list of sym reps (not failed); default overall value to $Failed if nothing worked *)
				FirstCase[placementSetsByLayout,{_Placement..},$Failed]
			]
		],
		{itemGroupsSansDuplicateObjects,openLocationsByItemGroup,layoutsToConsiderByDestination}
	];

	(* identify indices of item groups that got $Failed as a placment set for throwing message, if not on FastTrack *)
	failedPositions=If[!fastTrack,
		MapIndexed[
			Function[{placementSet,index},
				If[MatchQ[placementSet,$Failed],
					index,
					Nothing
				]
			],
			placementSets
		],
		{}
	];

	(* report all at once on the failed indices if not on FastTrack *)
	If[!fastTrack&&MatchQ[failedPositions,{{_Integer}..}],
		Message[PlaceItems::NoPlacementsFound,failedPositions]
	];

	(* return the mixed list of failures and placement sets *)
	placementSets
];



(* ::Subsection:: *)
(*Placement*)


(* ::Subsubsection::Closed:: *)
(*PlacementP *)


PlacementP:=AssociationMatchP[
	Association[
		Item->ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}],
		Destination->ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],
		Position->LocationPositionP,
		Layout->ObjectP[Model[DeckLayout]]
	],
	RequireAllKeys -> False
];



(* ::Subsubsection::Closed:: *)
(*Placement Primitive Installation*)


(* Define where to fetch the image used in all Placement primitives *)
placementIcon[]:=placementIcon[]=Import[FileNameJoin[{$EmeraldPath,"Locations","resources","images","PlacementIcon.png"}]];

(* Set UpValue for Placement's box creation such that primitives appear in the front end *)
installEmeraldPlacementBlobs[]:=Module[
	{},
	Placement/:MakeBoxes[myPlacementSpec:(Placement[_Association]),StandardForm]:=Module[
		{placementAssociation,item,destination,position,layout},

		(* Strip Placement head off parameter association *)
		placementAssociation = First[myPlacementSpec];

		(* Fetch Item specification *)
		item = Lookup[placementAssociation,Item,Null];

		(* Fetch Destination specification *)
		destination = Lookup[placementAssociation,Destination,Null];

		(* Fetch Position specification *)
		position = Lookup[placementAssociation,Position,Null];

		(* Fetch Layout specification *)
		layout = Lookup[placementAssociation,Layout,Null];

		(* Pass display arguments to low-level box function.
		If parameter is Null, do not include it in the primitive display *)
		BoxForm`ArrangeSummaryBox[
			Placement,
			myPlacementSpec,
			placementIcon[],
			Evaluate@{
				If[Not[NullQ[item]],
					BoxForm`SummaryItem[{"Item: ",item}],
					Nothing
				],
				If[Not[NullQ[destination]],
					BoxForm`SummaryItem[{"Destination: ",destination}],
					Nothing
				],
				If[Not[NullQ[position]],
					BoxForm`SummaryItem[{"Position: ",position}],
					Nothing
				],
				If[Not[NullQ[layout]],
					BoxForm`SummaryItem[{"Layout: ",layout}],
					Nothing
				]
			},
			{},
			StandardForm
		]
	];
];

(* Install on load *)
installEmeraldPlacementBlobs[];
OverloadSummaryHead[Placement];

(* Register installation in loader *)
OnLoad[
	installEmeraldPlacementBlobs[];
	OverloadSummaryHead[Placement];
];



(* ::Subsubsection:: *)
(*Placement Primitive Overload*)


Placement::InsufficientParameters = "Please make sure both Item and Destination is specified.";
Placement::InvalidPlacement = "The Placement parameters do not match PlacementP. Please make sure all keys are valid and their values match the required patterns in PlacementP.";

Placement[myPlacementRules:Sequence[Rule[_Symbol,_]...]]:=Module[
	{placementAssociation},

	(* Create association from input sequence of rules *)
	placementAssociation = Association[myPlacementRules];

	(* Item and Destination must be specified. If they are not, throw an error. *)
	If[!And[KeyExistsQ[placementAssociation,Item],KeyExistsQ[placementAssociation,Destination]],
		Message[Placement::InsufficientParameters];
		Return[$Failed]
	];

	(* If Placement specifications do not match PlacementP, throw error *)
	If[!MatchQ[placementAssociation,PlacementP],
		Message[Placement::InvalidPlacement];
		Return[$Failed]
	];

	(* Return primitive *)
	Placement[placementAssociation]
];



(* ::Subsection:: *)
(*openLocations*)


(* ::Subsubsection::Closed:: *)
(*openLocations Options and Messages*)


DefineOptions[openLocations,
	Options:>{
		{LevelsDown->Infinity,ListableP[_Integer?NonNegative|Infinity],"The number of layers of contents within the provided destination that will be searched for open locations. A value of Infinity will iteratively search all contents of the destination for open positions until there are are no further nested containers.",IndexMatching->Input},
		{OpenFootprint->False,ListableP[BooleanP],"Indicates if open footprint positions should be allowed when when searching for locations for items with specific footprints.",IndexMatching->Input},
		CacheOption,
		SimulationOption,
		FastTrackOption
	}
];
openLocations::TooManyLayouts="The object `1` has more than one layout in AvailableLayouts. Please specify a layout you wish to use.";
openLocations::InputLengthMismatch="The length of the input lists do not match. Please provide input lists of the same length.";
openLocations::OptionLengthMismatch="The length of the `1` option is not the same as the input lists' length. Please provide a list matching the input lists' length, or alternatively, a single option value may be supplied.";
openLocations::UnrecognizedLayout="The layout specified `2` is not in AvailableLayouts of `1`. Please specify a layout that is listed in AvailableLayouts.";



(* ::Subsubsection:: *)
(*openLocations*)


(* Single destination overload *)
openLocations[myDestination:ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],ops:OptionsPattern[]]:=Module[
	{},
	openLocations[myDestination,Null,Null,ops]
];

(* Single destination and item *)
openLocations[myDestination:ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],myItem:(ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}]|Null),ops:OptionsPattern[]]:=Module[
	{},
	openLocations[myDestination,myItem,Null,ops]
];

(* Single destination, item, and layout *)
openLocations[myDestination:ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],myItem:(ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}]|Null),myLayout:(ObjectP[Model[DeckLayout]]|Null),ops:OptionsPattern[]]:=Module[
	{result},

	(* Fetch core overload's result *)
	result = openLocations[{myDestination},{myItem},{myLayout},ops];

	(* If core overload fails, return failure, otherwise output first element *)
	If[MatchQ[result,$Failed],
		result,
		First[result]
	]
];

(* Listable overload sans deck layouts *)
openLocations[myDestinations:{ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}]...},myItems:{(ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}]|Null)...},ops:OptionsPattern[]]:=Module[
	{},
	openLocations[myDestinations,myItems,Table[Null,Length[myDestinations]],ops]
];

(* Listable overload sans items and deck layouts *)
openLocations[myDestinations:{ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}]...},ops:OptionsPattern[]]:=Module[
	{},
	openLocations[myDestinations,Table[Null,Length[myDestinations]],Table[Null,Length[myDestinations]],ops]
];

(* Core overload *)
openLocations[myDestinations:{ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}]...},myItems:{(ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}]|Null)...},myLayouts:{(ObjectP[Model[DeckLayout]]|Null)...},ops:OptionsPattern[]]:=Module[
	{safeOps,expandedLevelsDown,expandedOpenFootprint,itemFieldSpecs,layoutFieldSpecs,destinationFieldSpecs,
	allFieldValues,itemFieldValues,destinationFieldValues,layoutFieldValues,partlessDestinationFieldValues,
	occupiedPositionTuples,endpointRackModelObjects,endpointContentsObjects,allRackModelPackets,
	allLayoutPackets,endpointRackTuples,emptyLayoutPositions,nonEmptyModelLayoutTuples,modelLayoutTuples,occupiedModelPositionTuples,
	itemFootprints,itemDimensions,rackPositionTuples},

	(* Filter input options *)
	safeOps = SafeOptions[openLocations, ToList[ops]];

	(* If inputs are empty lists, return empty list *)
	If[MatchQ[myDestinations,{}],
		Return[{}],
		If[!Lookup[safeOps,FastTrack],
			(* If input argument lengths are not the same, fail *)
			If[!SameLengthQ[myDestinations,myItems,myLayouts],
				Message[openLocations::InputLengthMismatch];
				Return[$Failed],
				(* If LevelsDown is specified as a list but its length does not match input, fail *)
				If[
					And[
						MatchQ[Lookup[safeOps,LevelsDown],{(_Integer?NonNegative|Infinity)...}],
						!SameLengthQ[myDestinations,Lookup[safeOps,LevelsDown]]
					],
					Message[openLocations::OptionLengthMismatch,LevelsDown];
					Return[$Failed],
					(* If OpenFootprint is specified as a list but its length does not match input, fail *)
					If[
						And[
							MatchQ[Lookup[safeOps,OpenFootprint],{BooleanP...}],
							!SameLengthQ[myDestinations,Lookup[safeOps,OpenFootprint]]
						],
						Message[openLocations::OptionLengthMismatch,OpenFootprint];
						Return[$Failed]
					]
				]
			]
		]
	];

	(* Extend length of LevelsDown to match input argument list lengths *)
	expandedLevelsDown = If[MatchQ[Lookup[safeOps,LevelsDown],{(_Integer?NonNegative|Infinity)...}],
		Lookup[safeOps,LevelsDown],
		Table[Lookup[safeOps,LevelsDown],Length[myDestinations]]
	];

	(* Extend length of OpenFootprint to match input argument list lengths *)
	expandedOpenFootprint = If[MatchQ[Lookup[safeOps,OpenFootprint],{BooleanP...}],
		Lookup[safeOps,OpenFootprint],
		Table[Lookup[safeOps,OpenFootprint],Length[myDestinations]]
	];

	(* If item is a model, fetch its Dimensions and Footprint. If item is an object, traverse through its model. *)
	itemFieldSpecs = Map[
		If[MatchQ[#,ObjectP[Model]],
			{Packet[Dimensions,Footprint]},
			{Packet[Model[{Dimensions,Footprint}]]}
		]&,
		myItems
	];

	(* If a layout is specified, download relevant fields *)
	layoutFieldSpecs = MapThread[
		If[MatchQ[#1,ObjectP[Model[DeckLayout]]],
			Join[
				{
					(* Fetch parent deck layout packet *)
					Packet[Layout,NestedLayout],
					(* Fetch deck layout's model positions *)
					Packet[Field[Layout[[All,2]]][{Positions}]]
				},
				(* If LevelsDown is specified, insert it as an argument to Repeated, otherwise download entire tree *)
				If[MatchQ[#2,Infinity],
					{
						(* Traverse NestedLayout and fetch each's Layout *)
						Packet[Repeated[Field[NestedLayout[[All,2]]]][{Layout,NestedLayout}]],
						(* Fetch the positions for all models in each NestedLayout's Layout *)
						Packet[Repeated[Field[NestedLayout[[All,2]]]][Field[Layout[[All,2]]]][{Positions}]]
					},
					{
						Packet[Repeated[Field[NestedLayout[[All,2]]],#2][{Layout,NestedLayout}]],
						Packet[Repeated[Field[NestedLayout[[All,2]]],#2][Field[Layout[[All,2]]]][{Positions}]]
					}
				]
			],
			{}
		]&,
		{myLayouts,expandedLevelsDown}
	];

	(* Depending on whether the destination is an object or model, download different fields *)
	destinationFieldSpecs = MapThread[
		If[MatchQ[#1,ObjectP[Model]],
			Join[
				{
					(* Fetch parent packet, as well as its AvailableLayout's layout, and its model's positions *)
					Packet[Positions,AvailableLayouts],
					Packet[Field[AvailableLayouts[[1]]][{Layout,NestedLayout}]],
					Packet[Field[AvailableLayouts[[1]]][Field[Layout[[All,2]]]][{Positions}]]
				},
				(* Fetch AvailableLayout's layout tree, and its model's positions *)
				If[MatchQ[#3,Infinity],
					{
						Packet[Field[AvailableLayouts[[1]]][Repeated[Field[NestedLayout[[All,2]]]]][{Layout,NestedLayout}]],
						Packet[Field[AvailableLayouts[[1]]][Repeated[Field[NestedLayout[[All,2]]]]][Field[Layout[[All,2]]]][{Positions}]]
					},
					{
						Packet[Field[AvailableLayouts[[1]]][Repeated[Field[NestedLayout[[All,2]]],#3]][{Layout,NestedLayout}]],
						Packet[Field[AvailableLayouts[[1]]][Repeated[Field[NestedLayout[[All,2]]],#3]][Field[Layout[[All,2]]]][{Positions}]]
					}
				]
			],
			(* If destination is a specific object, fetch contents tree *)
			If[MatchQ[#3,Infinity],
				{
					Packet[Model,Contents],
					Packet[Repeated[Field[Contents[[All,2]]]][{Contents,Model}]],
					Packet[Repeated[Field[Contents[[All,2]]]][Model][Positions]],
					Packet[Model[Positions]]
				},
				{
					Packet[Model,Contents],
					Packet[Repeated[Field[Contents[[All,2]]],#3][{Contents,Model}]],
					Packet[Repeated[Field[Contents[[All,2]]],#3][Model][Positions]],
					Packet[Model[Positions]]
				}
			]
		]&,
		{myDestinations,myLayouts,expandedLevelsDown}
	];

	(* Download item, destination, and decklayout's field values *)
	allFieldValues = Quiet[
		Download[
			Join[myItems,myDestinations,myLayouts],
			Evaluate[Join[itemFieldSpecs,destinationFieldSpecs,layoutFieldSpecs]],
			Cache -> Lookup[safeOps,Cache],
			Simulation -> Lookup[safeOps, Simulation]
		],
		(* Quiet Part message in case AvailableLayouts is empty *)
		{Download::Part,Download::FieldDoesntExist}
	];

	(* Disambiguate item field values from destination field values *)
	{itemFieldValues,destinationFieldValues,layoutFieldValues} = {
		allFieldValues[[;;Length[myItems]]],
		allFieldValues[[(Length[myItems]+1);;(Length[myItems]+Length[myDestinations])]],
		allFieldValues[[(Length[myItems]+Length[myDestinations]+1);;]]
	};

	(* Make sure the layouts of destinationFieldValues appear in the Available deck layouts in cases where Models are found *)
	If[!Lookup[safeOps,FastTrack],
		MapThread[
			If[
				And[
					MatchQ[#1,ObjectP[Model]]&&!NullQ[#3],
					!MemberQ[Download[Lookup[#2[[1]],AvailableLayouts],Object],#3]
				],
				Message[openLocations::UnrecognizedLayout,#1,#3];
				Return[$Failed,Module]
			]&,
			{myDestinations,destinationFieldValues,myLayouts}
		]
	];

	(* Trim any field value lists pulled from Object[Part]s or Model[Part]s (or plumbing or sensors) in the recursive download above.
	Since Parts do not have Contents or Positions *)
	partlessDestinationFieldValues=DeleteCases[
		destinationFieldValues,
		{
			Null|AssociationMatchP[
				Association[
					Contents->$Failed,
					Positions->$Failed,
					Model->(Null|LinkP[Model[Part]]|ObjectP[{Model[Part], Model[Sensor],Object[Part], Object[Sensor],Model[Item],Model[Plumbing],Object[Plumbing],Model[Wiring],Object[Wiring],Object[Item],Model[Sample],Object[Sample]}]),
					Object->(LinkP[Model[Part]]|ObjectP[{Model[Part], Model[Sensor],Object[Part], Object[Sensor],Model[Item],Object[Item],Model[Plumbing],Object[Plumbing],Model[Wiring],Object[Wiring],Model[Sample],Object[Sample]}])
				],
				AllowForeignKeys->True,
				RequireAllKeys->False
			],
			$Failed
		},
		Infinity
	];

	(* Build tuples of container and its occupied positions in the form: {object, {positions..}} *)
	occupiedPositionTuples = MapThread[
		Function[{destinationObject,destinationValues,layout,layoutValues},
			If[MatchQ[destinationObject,ObjectP[Object]],
				DeleteCases[
					Map[
						{Lookup[#,Object],Cases[Lookup[#,Contents],{position_String,ObjectP[]}:>position]}&,
						(* Prepend destination's contents to the recursively downloaded contents tree *)
						Prepend[Flatten[destinationValues[[2]]],destinationValues[[1]]]
					],
					{_,{}}
				],
				{}
			]
		],
		{myDestinations,partlessDestinationFieldValues,myLayouts,layoutFieldValues}
	];

	(* Find model objects for each of the possible objects that could hold an item *)
	endpointRackModelObjects = MapThread[
		If[MatchQ[#1,ObjectP[Object]],
			(* If an object, prepend destination object's model with the recursively downloaded contents' models *)
			Download[Flatten[Join[{#2[[4]]},#2[[3]]]],Object],
			If[NullQ[#3],
				(* If no AvailableLayouts, only include destination as object *)
				If[Length[Lookup[#2[[1]],AvailableLayouts]]==0,
					{#1},
					(* If AvailableLayouts includes more than one layout, and no layout is specified, throw error *)
					If[(!Lookup[safeOps,FastTrack]&&Length[Lookup[#2[[1]],AvailableLayouts]]>1),
						Message[openLocations::TooManyLayouts,Lookup[#2[[1]],Object]];
						Return[$Failed,Module],
						(* Otherwise, prepend destination object to Layout's objects *)
						Prepend[
							(* Layout is in the form {position, object} *)
							If[MatchQ[#5,0],
								(* If LevelsDown -> 0, then we should not include any of the layout's level *)
								{},
								Download[(Join@@Lookup[Flatten[Join[{#2[[2]]}, #2[[4]]]],Layout])[[All,2]],Object]
							],
							#1
						]
					]
				],
				Join[
					{#1},
					(* If a layout, Join layout's packet with its recursive nested layout packets, then take their object *)
					If[MatchQ[#5,0],
						(* If LevelsDown -> 0, then we should not include any of the layout's level *)
						{},
						Download[(Join@@Lookup[Flatten[Join[{#4[[1]]}, #4[[3]]]],Layout])[[All,2]],Object]
					]
				]
			]
		]&,
		{myDestinations,partlessDestinationFieldValues,myLayouts,layoutFieldValues,expandedLevelsDown}
	];

	(* Find all objects in the contents tree of a destination (if its an object) *)
	endpointContentsObjects = MapThread[
		If[MatchQ[#1,ObjectP[Object]],
			Prepend[Download[Flatten[#2[[2]]],Object],#1],
			{}
		]&,
		{myDestinations,partlessDestinationFieldValues}
	];

	(* Generate list of all possible model packets for a destination/item pair *)
	allRackModelPackets = MapThread[
		If[MatchQ[#1,ObjectP[Object]],
			(* If an object, join destination's model packet with nested contents' model packets *)
			Flatten[Join[{#2[[4]]},#2[[3]]]],
			(* If a model, join parent model's packet with its AvailableLayout's Layout's model packet and its NestedLayouts' Layout model packets *)
			If[NullQ[#3],
				If[Length[Lookup[#2[[1]],AvailableLayouts]]==0,
					{#2[[1]]},
					Flatten[Join[{#2[[1]]},#2[[3]],#2[[5]]]]
				],
				Join[
					(* Join model's endpoints with layouts' *)
					Flatten[Join[{#2[[1]]},#2[[3]],#2[[5]]]],
					(* If a DeckLayout, join parent DeckLayout's layout model packets with its NestedLayouts' Layout model packets *)
					Flatten[Join[#4[[2]],#4[[4]]]]
				]
			]
		]&,
		{myDestinations,partlessDestinationFieldValues,myLayouts,layoutFieldValues}
	];

	(* Generate list of all layout packets for a destination *)
	allLayoutPackets = MapThread[
		If[MatchQ[#1,ObjectP[Object]],
			{},
			If[NullQ[#3],
				If[Length[Lookup[#2[[1]],AvailableLayouts]]==0,
					{},
					Flatten[Join[{#2[[2]]},#2[[4]]]]
				],
				Flatten[Join[{#4[[1]]},#4[[3]]]]
			]
		]&,
		{myDestinations,partlessDestinationFieldValues,myLayouts,layoutFieldValues}
	];

	(* Build tuple associating a potential destination object with its model packet in the form: {object, model packet} *)
	endpointRackTuples = MapThread[
		Function[{rackModelPackets,rackModelObjects,contentsObjectPackets,layoutPackets},
			MapThread[
				Function[{rackObject,rackModel},
					(* Build tuple of destination object (or model) and its model packet
					(if we're working in terms of models, the tuple will be {model, model packet}.
					if we're working in terms of objects, the tuple will be {object, model packet}) *)
					{rackObject,SelectFirst[rackModelPackets,SameObjectQ[Lookup[#,Object],rackModel]&]}
				],
				(* If we're traversing contents objects, thread over contents' objects and their models.
				Otherwise, thread over models *)
				If[Length[contentsObjectPackets]>0,
					{contentsObjectPackets,rackModelObjects},
					{rackModelObjects,rackModelObjects}
				]
			]
		],
		{allRackModelPackets,endpointRackModelObjects,endpointContentsObjects,allLayoutPackets}
	];

	(* Generate tuples pairing a model with the layout in which it is used (in the form {model, layout}) *)
	(* Here we have to do this for non empty layout only. Otherwise the MapThread level spec will run into weird errors.
	 	For example, it is OK to run MapThread level 2 on {{{},{}},{{},{}}}. Because both lists are empty, the MapThread will not try to get the level 2 items.
	 	However, it will run into problem running {{{},{a}},{{},{b}}}. Because for the first item {}-{}, Level 2 does not exist.
	 *)

	(* Record the positions of {},{} *)
	emptyLayoutPositions=Position[Transpose[{allLayoutPackets[[All,All,Key[Layout]]],allLayoutPackets[[All,All,Key[NestedLayout]]]}],{{},{}}];

	nonEmptyModelLayoutTuples = If[MemberQ[Transpose[{allLayoutPackets[[All,All,Key[Layout]]],allLayoutPackets[[All,All,Key[NestedLayout]]]}],Except[{{},{}}]],
		(Join@@#)&/@MapThread[
			Function[{layout,nestedLayout},
				Map[
					Function[layoutEntry,
						{
							Download[layoutEntry[[2]],Object],
							(* Find entry in NestedLayout that has the same position as the layoutEntry from Layout *)
							FirstCase[nestedLayout,{layoutEntry[[1]],nestedObject:ObjectP[]}:>Download[nestedObject,Object],Null]
						}
					],
					layout
				]
			],
			Transpose[DeleteCases[Transpose[{allLayoutPackets[[All,All,Key[Layout]]],allLayoutPackets[[All,All,Key[NestedLayout]]]}],{{},{}}]],
			2
		],
		{}
	];

	modelLayoutTuples = Fold[Insert[#1,{},#2]&,nonEmptyModelLayoutTuples,emptyLayoutPositions];

	(* For each model, pull out the positions in its associated layout that is occupied with racks in NestedLayout
	in the form {model, {occupied position..}} *)
	occupiedModelPositionTuples = MapThread[
		Function[{tuples,modelPackets,layoutPackets},
			Map[
				Function[modelLayoutTuple,
					{
						(* The model container for which occupied positions will be associated *)
						modelLayoutTuple[[1]],
						(* If no nested layout, no occupied positions *)
						If[NullQ[modelLayoutTuple[[2]]],
							{},
							(* Find packet for the container's layout object and take the positions in its Layout field (these are occupied) *)
							Lookup[SelectFirst[layoutPackets,MatchQ[Lookup[#,Object],modelLayoutTuple[[2]]]&],Layout][[All,1]]
						]
					}
				],
				tuples
			]
		],
		{modelLayoutTuples,allRackModelPackets,allLayoutPackets}
	];

	(* Extract footprints for items. If no footprint, set to Null *)
	itemFootprints = Map[
		If[NullQ[#]||MatchQ[#,$Failed],
			Null,
			Lookup[First[#],Footprint]
		]&,
		itemFieldValues
	];

	(* Extract dimensions for items. If no dimensions, set to Null *)
	itemDimensions = Map[
		If[NullQ[#]||MatchQ[#,$Failed],
			Null,
			Lookup[First[#],Dimensions]
		]&,
		itemFieldValues
	];

	(* Build tuples of possible destination locations in the form {destination object, {positions...}} *)
	rackPositionTuples = MapThread[
		Function[{itemFootprint,itemDimension,rackTuples,occupiedPositions,occupiedModelPositions,openFootprint},
			(* Map over tuples of {destination object or model, destination model's packet} *)
			Map[
				Function[rackTuple,
					{
						(* This is the object we're potentially placing an item into *)
						rackTuple[[1]],
						(* This builds a list of open positions in the object *)
						If[MatchQ[itemFootprint,FootprintP],
							(* If the item has a defined Footprint, Filter destination positions by their footprint, max height, and occupancy *)
							Select[
								Lookup[rackTuple[[2]],Positions],
								And[
									(* Depending on OpenFootprint, allow or disallow Open footprint *)
									If[openFootprint,
										MatchQ[Lookup[#,Footprint],(itemFootprint|Open|SingleItem)],
										MatchQ[Lookup[#,Footprint],itemFootprint]
									],
									(* If MaxHeight is Null, then any height can fit, otherwise make sure item is shorter than max height *)
									If[NullQ[Lookup[#,MaxHeight]],
										True,
										TrueQ[Lookup[#,MaxHeight]>=(itemDimension[[3]])]
									],
									(* Make sure position is not in the list of occupied positions for the destination *)
									!MemberQ[FirstCase[Join[occupiedPositions,occupiedModelPositions],{rackTuple[[1]],occupied_List}:>occupied,{}],Lookup[#,Name]]
								]&
							],
							(* If the item does not have a footprint or dimensions, filter by destination occupancy *)
							If[NullQ[itemDimension],
								Select[
									Lookup[rackTuple[[2]],Positions],
									(* Make sure position is not in the list of occupied positions for the destination *)
									!MemberQ[FirstCase[Join[occupiedPositions,occupiedModelPositions],{rackTuple[[1]],occupied_List}:>occupied,{}],Lookup[#,Name]]&
								],
								(* If the item does not have a footprint but has dimensions,
								 filter by destinations with dimensions greater than item and destination occupancy *)
								Select[
									Lookup[rackTuple[[2]],Positions],
									And[
										(* Make sure item is smaller than the destination *)
										TrueQ[Lookup[#,MaxWidth]>=(itemDimension[[1]])],
										TrueQ[Lookup[#,MaxDepth]>=(itemDimension[[2]])],
										(* If MaxHeight is Null, then any height can fit, otherwise make sure item is shorter than max height *)
										If[NullQ[Lookup[#,MaxHeight]],
											True,
											TrueQ[Lookup[#,MaxHeight]>=(itemDimension[[3]])]
										],
										(* Make sure position is not in the list of occupied positions for the destination *)
										!MemberQ[FirstCase[Join[occupiedPositions,occupiedModelPositions],{rackTuple[[1]],occupied_List}:>occupied,{}],Lookup[#,Name]]
									]&
								]
							]
						(* Pull out all position names *)
						][[All,Key[Name]]]
					}
				],
				rackTuples
			]
		],
		{itemFootprints,itemDimensions,endpointRackTuples,occupiedPositionTuples,occupiedModelPositionTuples,expandedOpenFootprint}
	];

	(* Expand rackPositionTuples from form {object, {positions..}} to {{object, position1}, {object, position2}, ..} *)
	Map[
		Function[positionTuples,
			Join@@Map[
				If[Length[#[[2]]]>0,
					Transpose[{Table[#[[1]],Length[#[[2]]]],#[[2]]}],
					Nothing
				]&,
				positionTuples
			]
		],
		rackPositionTuples
	]
];


(* ::Subsection:: *)
(*validPlacementQ*)


(* ::Subsubsection::Closed:: *)
(*validPlacementQ Options and Messages*)


DefineOptions[validPlacementQ,
	Options:>{
		{Layout->Null,ListableP[(Null|ObjectP[Model[DeckLayout]])],"A layout of racks for a model destination that should be taken into consideration when looking for proper positions for placing items.",IndexMatching->Input},
		{OpenFootprint->False,ListableP[BooleanP],"Indicates if open footprint positions should allowed when looking for an open position.",IndexMatching->Input},
		{LevelsDown->Infinity,ListableP[_Integer?NonNegative|Infinity],"The number of layers of contents within the provided destination that will be searched for open locations. A value of Infinity will iteratively search all contents of the destination for open positions until there are are no further nested containers.",IndexMatching->Input},
		CacheOption,
		SimulationOption,
		FastTrackOption
	}
];

validPlacementQ::InputLengthMismatch="The length of the input lists do not match. Please provide input lists of the same length.";
validPlacementQ::OptionLengthMismatch="The length of the `1` option is not the same as the input lists' length. Please provide a list matching the input lists' length, or alternatively, a single option value may be supplied.";



(* ::Subsubsection:: *)
(*validPlacementQ*)


(* Specific location position overload *)
validPlacementQ[myItem:ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}],{myDestination:ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],myLocation:LocationPositionP},ops:OptionsPattern[]]:=Module[
	{safeOptions,openLocs},

	(* default any unspecified or incorrectly-specified option values *)
	safeOptions = SafeOptions[validPlacementQ, ToList[ops]];

	(* Fetch all open locations for the destination *)
	openLocs = openLocations[myDestination,myItem,Lookup[safeOptions,Layout],PassOptions[openLocations,safeOptions]];

	(* If the {destination, location} tuple exists in the open locations list, it is a valid placement *)
	MemberQ[openLocs,{_?(MatchQ[Download[#,Object],Download[myDestination,Object]]&),myLocation}]
];

(* Placement primitive overload *)
validPlacementQ[myPlacement_Placement,ops:OptionsPattern[]]:=Module[
	{item,destination,position,layout},

	(* Extract item from primitive *)
	item = myPlacement[Item];

	(* Extract destination from primitive *)
	destination = myPlacement[Destination];

	(* Extract position from primitive. This will be Missing if no position specified. *)
	position = myPlacement[Position];

	(* Extract layout if specified, otherwise set to Null *)
	layout = If[!MissingQ[myPlacement[Layout]],
		myPlacement[Layout],
		Null
	];

	(* Pass to appropriate lower-level overloads depending on which keys are specified *)
	If[MatchQ[position,LocationPositionP],
		validPlacementQ[item,{destination,position},Layout -> layout,ops],
		validPlacementQ[item,destination,Layout -> layout,ops]
	]
];

(* Single item, single destination *)
validPlacementQ[myItem:ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}],myDestination:ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],ops:OptionsPattern[]]:=Module[
	{},

	(* Pass to lower-level, listed items overload with Null layout *)
	validPlacementQ[{myItem},myDestination,ops]
];

(* Multiple items, single destination *)
validPlacementQ[myItems:{ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}]...},myDestination:ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}],ops:OptionsPattern[]]:=Module[
	{listableReturn},

	(* Call core overload *)
	listableReturn = validPlacementQ[{myItems},{myDestination},ops];

	(* If core overload fails, return failure *)
	If[MatchQ[listableReturn,$Failed],
		Return[$Failed]
	];

	(* Remove list from output *)
	First[listableReturn]
];

(* Core overload *)
validPlacementQ[myItems:{{ObjectP[{Model[Instrument],Model[Container],Model[Sample],Model[Part], Model[Sensor],Model[Plumbing],Model[Wiring],Model[Item],Object[Item],Object[Instrument],Object[Container],Object[Sample],Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring]}]...}...},myDestinations:{ObjectP[{Model[Instrument],Model[Container],Object[Instrument],Object[Container]}]...},ops:OptionsPattern[]]:=Module[
	{safeOptions,inputCache,simulation,fastTrack,rawLayout,rawOpenFootprint,rawLevelsDown,placements},

	(* default any unspecified or incorrectly-specified option values *)
	safeOptions = SafeOptions[validPlacementQ, ToList[ops]];

	(* assign FastTrack and Cache option values *)
	inputCache = Lookup[safeOptions,Cache];
	simulation = Lookup[safeOptions, Simulation];
	fastTrack = Lookup[safeOptions,FastTrack];

	(* If input argument lengths are not the same, fail *)
	If[!fastTrack&&!SameLengthQ[myItems,myDestinations],
		Message[validPlacementQ::InputLengthMismatch];
		Return[$Failed]
	];

	(* assign the raw Layout, OpenFootprint, LevelsDown option values *)
	rawLayout = Lookup[safeOptions,Layout];
	rawOpenFootprint = Lookup[safeOptions,OpenFootprint];
	rawLevelsDown = Lookup[safeOptions,LevelsDown];

	(* If Layout is specified as a list but its length does not match input, fail *)
	If[!fastTrack&&ListQ[rawLayout]&&!SameLengthQ[myItems,rawLayout],
		Message[validPlacementQ::OptionLengthMismatch,Layout];
		Return[$Failed]
	];

	(* If OpenFootprint is specified as a list but its length does not match input, fail *)
	If[!fastTrack&&ListQ[rawOpenFootprint]&&!SameLengthQ[myItems,rawOpenFootprint],
		Message[validPlacementQ::OptionLengthMismatch,OpenFootprint];
		Return[$Failed]
	];

	(* If LevelsDown is specified as a list but its length does not match input, fail *)
	If[!fastTrack&&ListQ[rawLevelsDown]&&!SameLengthQ[myItems,rawLevelsDown],
		Message[validPlacementQ::OptionLengthMismatch,LevelsDown];
		Return[$Failed]
	];

	(* Attempt to build placements for item, destination, layout tuples *)
	placements = Quiet[
		PlaceItems[myItems,myDestinations,PassOptions[PlaceItems,ops]],
		(* Quiet NoPlacementsFound since this is just the False case *)
		PlaceItems::NoPlacementsFound
	];

	(* If PlaceItems fails, return failure *)
	If[MatchQ[placements,$Failed],
		Return[$Failed]
	];

	(* If PlaceItems returns a list of placements, then the prospective placement is valid *)
	Map[
		MatchQ[#,{_Placement..}]&,
		placements
	]
];


(* ::Subsection:: *)
(*PlotLocation/PlotContents*)


(* ::Subsubsection:: *)
(*plotContainer*)


(* --- Low-level private function that sits behind PlotLocation and PlotContents --- *)

DefineUsage[plotContainer,
{
	BasicDefinitions -> {
		{"plotContainer[obj]", "plot", "generates a plot of the location of an item 'obj' within the ECL facility."},
		{"plotContainer[mod]", "plot", "generates a plot of the physical layout of a Model[Container] or Model[Instrument] 'mod'."},
		{"plotContainer[pos]", "plot", "generates a plot of the location of a position 'pos' in its parent container within the ECL facility."}
	},
	MoreInformation -> {},
	Input :> {
		{"obj", ObjectP[LocationTypes], "An item whose location within the ECL facility will be plotted."},
		{"mod", ObjectP[LocationContainerModelTypes], "A container or instrument model whose layout will be plotted."},
		{"pos", {ObjectReferenceP[LocationContainerModelTypes], _String}, "A position in an item whose location within the ECL facility will be plotted."}
	},
	Output :> {
		{"plot", _Graphics | _Graphics3D, "A plot of the location of 'obj' within the ECL."}
	},
	Behaviors -> {
		"ReverseMapping"
	},
	Sync -> Automatic,
	SeeAlso -> {
		"PlotLocation",
		"PlotContents"
	},
	Author -> {"ben", "olatunde.olademehin"}
}];

DefineOptions[plotContainer,
	Options :> {
		{
			OptionName->Highlight,
			Default->{},
			Description->"What Object(s) will be highlighted on the plot.",
			AllowNull->True,
			Category->"Data Specifications",
			Widget->Alternatives[Adder[
				Alternatives[
					Widget[Type->Expression,Pattern:>ObjectReferenceP[LocationTypes],Size->Line],
					{
						"Location Container"->Widget[Type->Expression,Pattern:>ObjectReferenceP[LocationContainerTypes],Size->Line],
						"Location String"->Widget[Type->String,Pattern:>_String,Size->Line]
					}
				]],
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]]
			]
		},
		{
			OptionName->LiveDisplay,
			Default->Automatic,
			Description->"Determines whether containers in 2D container plots can be clicked to generate a new plot of the clicked item.",
			AllowNull->False,
			Category->"General",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Enumeration,Pattern:>BooleanP]
			]
		},
		{
			OptionName->PlotType,
			Default->Plot2D,
			Description->"Whether the resulting plot will be 2D or 3D.",
			AllowNull->False,
			Category->"Plot Style",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Plot2D,Plot3D]]
		},
		{
			OptionName->LabelPositions,
			Default->False,
			Description->"Determines whether text labels will be placed at the center of every position.",
			AllowNull->False,
			Category->"Plot Labeling",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName->ResolvedHighlight,
			Default->{},
			Description->"What Object(s) will be highlighted on the plot, with items outside the scope of a given plot replaced by the lowest item that contains them (where possible).",
			AllowNull->False,
			Category->"Hidden",
			Widget->Alternatives[Adder[
				Alternatives[
					Widget[Type->Expression,Pattern:>ObjectReferenceP[LocationTypes],Size->Line],
					{
						"Location Container"->Widget[Type->Expression,Pattern:>ObjectReferenceP[LocationContainerTypes],Size->Line],
						"Location String"->Widget[Type->String,Pattern:>_String,Size->Line]
					}
				]],
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]]
			]
		},
		{
			OptionName->HighlightInput,
			Default->Automatic,
			Description-> "Determines whether the input item will automatically be highlighted. If Automatic, the input item will be highlighted only if no other objects or positions are provided for highlighting via the Highlight option.",
			AllowNull->False,
			Category->"Data Specifications",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>BooleanP],
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
			]
		},
		{
			OptionName->HighlightStyle,
			Default->Automatic,
			Description->"The style that will be applied to boxes highlighting selected Objects. If Automatic, coloring and transparency are set based on the PlotType option to optimize visibility of all plotted elements.",
			AllowNull->False,
			Category->"Plot Style",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Expression,Pattern:>ListableP[ EdgeForm[ListableP[EdgeFormP]] | FaceForm[ListableP[FaceFormP]] |EdgeFormP],Size->Line]
			]
		},
		{
			OptionName->ContainerStyle,
			Default->Automatic,
			Description->"The style that will be applied to empty containers. If Automatic, coloring and transparency are set based on the PlotType option to optimize visibility of all plotted elements.",
			AllowNull->False,
			Category->"Data Specifications",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Expression,Pattern:>ListableP[ EdgeForm[ListableP[EdgeFormP]] | FaceForm[ListableP[FaceFormP]] |EdgeFormP],Size->Line]
			]
		},
		{
			OptionName->PositionStyle,
			Default->Automatic,
			Description->"The style that will be applied to empty positions. If Automatic, coloring and transparency are set based on the PlotType option to optimize visibility of all plotted elements.",
			AllowNull->False,
			Category->"Plot Style",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Expression,Pattern:>ListableP[ EdgeForm[ListableP[EdgeFormP]] | FaceForm[ListableP[FaceFormP]] |EdgeFormP],Size->Line]
			]
		},
		{
			OptionName->PlotRange,
			Default->All,
			Description->"Plotting area limits for the container plot. If specified explicitly, PlotRange must be in units of distance.",
			AllowNull->False,
			Category->"Plot Range",
			Widget->Widget[Type->Expression,Pattern:>PlotRangeP,Size->Line]
		},
		{
			OptionName->Axes,
			Default->True,
			Description->"Specifies whether plot axes will be shown.",
			AllowNull->False,
			Category->"Axes",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName->Map,
			Default->False,
			Description->"Indicates if a list of plots corresponding to each trace will be created, or if all traces within a list will be overlayed on the same plot.",
			AllowNull->False,
			Category->"Plot Range",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName->TargetUnits,
			Default->Automatic,
			Description->"Primary data is converted to these units before plotting.  If Automatic, units are taken from the first top-level container.  TargetUnits must be in units of Distance.",
			AllowNull->False,
			Category->"Data Specifications",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line],
				{
					"Target Unit"->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
						Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line]
					],
					"Target Unit"->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
						Widget[Type->Expression,Pattern:>_?UnitsQ,Size->Line]
					]
				}
			]
		},

		CacheOption,
		FastTrackOption,
		{
			OptionName->LevelsDown,
			Default->Automatic,
			Description->"How many layers of contents below the provided item will be returned.",
			AllowNull->False,
			Category->"General",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number,Pattern:>GreaterEqualP[0]],
				Widget[Type->Enumeration,Pattern:>Alternatives[All,Infinity]]
			]
		},
		{
			OptionName->LevelsUp,
			Default->Automatic,
			Description->"How many layers of containers above the provided item will be returned.",
			AllowNull->False,
			Category->"General",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[Type->Number,Pattern:>GreaterEqualP[0]],
				Widget[Type->Enumeration,Pattern:>Alternatives[All,Infinity]]
			]
		},
		{
			OptionName->NearestUp,
			Default->{},
			Description-> "One or more SLL Types that will terminate the upward search when encountered.",
			AllowNull->False,
			Category->"General",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				"Single"->Widget[Type->Expression,Pattern:>TypeP[{Object[Container], Object[Instrument]}],Size->Line],
				"Multiple"->Adder[Widget[Type->Expression,Pattern:>TypeP[{Object[Container], Object[Instrument]}],Size->Line]]
			]
		},
		{
			OptionName->NearestDown,
			Default->{},
			Description->"One or more SLL Types that will terminate any branch of the downward search where they are encountered.",
			AllowNull->False,
			Category->"",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				"Single"->Widget[Type->Expression,Pattern:>TypeP[{Object[Container], Object[Instrument]}],Size->Line],
				"Multiple"->Adder[Widget[Type->Expression,Pattern:>TypeP[{Object[Container], Object[Instrument]}],Size->Line]]
			]
		},
		{
			OptionName->PositionTooltips,
			Default->True,
			Description->"Whether position primitives should be drawn on top of container primitives and given tooltip text, or drawn beneath container primitives without tooltip text.",
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		{
			OptionName->FunctionHead,
			Default->PlotLocation,
			Description-> "The head of the public plot function that called this function; used for messages and follow-up plots based on click events.",
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[PlotLocation,PlotContents]]
		},
		{
			OptionName->DrawPositions,
			Default->True,
			Description->"If False, position graphics will not be drawn at any level below the topmost container in any given plot.",
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		}
	},
	SharedOptions :> {
		{EmeraldListLinePlot, {ImageSize}}
	}
];


(* Pass singleton input to ReverseMapping definition *)


(* Authors definition for Locations`Private`plotContainer *)
Authors[Locations`Private`plotContainer]:={"ben"};

plotContainer[myItem:ObjectP[LocationTypes], myOps:OptionsPattern[]] := Module[
	{plotResult},

	(* Pass to ReverseMapping definition *)
	plotResult = plotContainer[{myItem}, myOps];

	(* Return appropriately depending on ReverseMapping output *)
	Switch[plotResult,
		(* If returned a list of (one) plot, strip off the list and return only that one plot *)
		_List, First[plotResult],
		(* If output is a bare plot, return it *)
		_Graphics | _Graphics3D, plotResult,
		(* If the ReverseMapping call failed, return $Failed *)
		$Failed, $Failed
	]

];


(* Top-level definition; resolve necessary options and generate container tree *)
plotContainer[myItems:{ObjectP[LocationTypes]..}, myOps:OptionsPattern[]] := Module[
	{safeOps, databaseMemberBools, incomingCache, plot3DBool, containerStyleOption, positionStyleOption,
	highlightStyleOption, liveDisplayOption, highlightOption, levelsUpOption, levelsDownOption, itemObjects,
	objectFields, modelFields, fieldsList, assembledPlotFields, adjacencyLists, packetLists, flatPacketsList,
	masterAdjacencyGraph, minimalSetOfGraphs, gatheredInputs, ctrTrees, objectToPacketRules, completeTrees,
	objsToHighlight, topContainerPackets, topContainerObjects, plotUnits, frameLabels, anchorPoints, plotRanges,
	allPlotGraphics, highlightedGraphics, notHighlightedGraphics, allPlotGraphicsRearranged, graphicsHead,
	plots, targetUnitsOption, nearestUpHaltingCondition, nearestDownHaltingCondition,
	recursiveContainerSpec, recursiveContentsSpec, inputsWithoutTrees, inputsWithoutTreesGraphs,
	inputsWithoutTreesPositions, graphsWithBareInputs, packetValidityBools, inputsWithoutTreesNotInMergedGraphs,
	functionHead, highlightObjects, plotDownloadResult, highlightDownloadResult, rectifiedHighlightOption,
	highlightInputOption, invalidPackets, invalidObjects, validObjectAdjacencyLists, validInputsWithoutTrees},

	(* ----- Resolve relevant options and do validity checks ----- *)

	(* As a now-private function, plotContainer should always receive safe options *)
	safeOps = SafeOptions[plotContainer,ToList[myOps]];

	(* Look up what top-level container plotting function called this function, for message purposes *)
	functionHead = Lookup[safeOps, FunctionHead];

	(* Check DatabaseMemberQ if FastTrack->False *)
	databaseMemberBools = If[!Lookup[safeOps, FastTrack],
		DatabaseMemberQ[myItems],
		Table[True, Length[myItems]]
	];

	(* If any items have been flagged as nonexistent, return *)
	If[!And@@databaseMemberBools,
		Return[With[{fh=functionHead},Message[fh::ObjectNotFound, PickList[myItems, databaseMemberBools, False]]];$Failed]
	];


	incomingCache = Lookup[safeOps, Cache];

	(* Get Object References for all, deleting duplicates *)
	itemObjects = DeleteDuplicates[myItems[Object]];

	(* Determine plot dimensionality *)
	plot3DBool = MatchQ[Lookup[safeOps, PlotType], Plot3D];

	(* Figure out plot styles/colors based on PlotType and ShadeFilledPositions options *)
	{containerStyleOption, positionStyleOption, highlightStyleOption} = choosePlotStyles[safeOps];

	(* Resolve LiveDisplay option *)
	liveDisplayOption = Switch[{plot3DBool, Lookup[safeOps, LiveDisplay]},
		(* If plotting in 3D and LiveDisplay->True, display a message and set it to false *)
		{True, True}, (With[{fh=functionHead},Message[fh::IncompatibleOptions]]; False),
		(* If plotting in 3D and LiveDisplay->Automatic, resolve to False *)
		{True, Automatic}, False,
		(* If plotting in 2D and LiveDisplay->Automatic, resolve to True *)
		{False, Automatic}, True,
		(* In any other situation, use existing value *)
		_, Lookup[safeOps, LiveDisplay]
	];

	(* Get ObjectReferences for any ObjectP[] in the Highlight option to streamline matching later on *)
	highlightOption = ReplaceAll[Lookup[safeOps, Highlight], obj:ObjectP[] :> Download[obj, Object]];

	(* Resolve automatics for HighlightInput option *)
	highlightInputOption = Switch[{highlightOption, Lookup[safeOps, HighlightInput]},
		(* If Automatic and no specific Highlight requests have been made, highlight the input object *)
		{{}, Automatic}, True,
		(* If Automatic and specific Highlight requests have been made, do not highlight the input object *)
		{Except[{}], Automatic}, False,
		(* If HighlightInput has been specified explicitly, leave it alone (this covers all other cases) *)
		{_, Except[Automatic]}, Lookup[safeOps, HighlightInput]
	];

	(* Resolve the set of options specific to UpContainers *)
	levelsUpOption = Switch[Lookup[safeOps, {LevelsUp,NearestUp}],
		(* If LevelsUp is Automatic and NearestUp is not specified, go one level up *)
		{Automatic, {}}, 1,
		(* If NearestUp is specified, override specified LevelsUp and go as far up as needed *)
		{_, Except[{}]}, Infinity,
		(* If LevelsUp is specified and NearestUp is not, use the specified value for LevelsUp *)
		{InfiniteNumericP, {}}, Lookup[safeOps, LevelsUp],
		(* If LevelsUp->All, replace with 'Infinity' *)
		{All, _}, Infinity
	];

	(* Finish the resolution process by resolving options specific to DownContainers *)
	levelsDownOption = Switch[Lookup[safeOps, {LevelsDown,NearestDown}],
		(* If LevelsDown is Automatic and NearestDown is not specified, go one level down *)
		{Automatic, {}}, 1,
		(* If NearestDown is specified, override specified LevelsDown and go as far down as needed *)
		{_, Except[{}]}, Infinity,
		(* If LevelsDown is specified and NearestDown is not, use the specified value for LevelsDown *)
		{InfiniteNumericP, {}}, Lookup[safeOps, LevelsDown],
		(* If LevelsDown->All, replace with 'Infinity' *)
		{All, _}, Infinity
	];


	(* ----- Generate container trees ----- *)

	(* Get the set of objects for which highlighting has been requested *)
	highlightObjects = Cases[highlightOption, ObjectP[], Infinity];

	(* Assemble a single Download query that will both traverse and gather needed information *)
	objectFields = {Object, Type, Name, Model, Container, Contents, Position};
	modelFields = {Positions, PositionPlotting, Dimensions, CrossSectionalShape, Shape2D, Shape3D};
	fieldsList = Join[objectFields, Model/@modelFields];

	(* Generate patterns of types on which to continue traversal in each direction;
		Only matching by '==' works for Alternatives, so must get Complement of all possible Types;
		Must run Types on NearestUp/NearestDown option values to expand all subtypes (e.g. Object[Instrument]) *)
	nearestUpHaltingCondition = If[!MatchQ[Lookup[safeOps, NearestUp],{}],
		Type == Alternatives@@Select[Complement[Types[{Object[Container],Object[Instrument]}],Types[ToList[Lookup[safeOps, NearestUp]]]],(Length[#]>1&)],
		None
	];
	nearestDownHaltingCondition = If[!MatchQ[Lookup[safeOps, NearestDown],{}],
		Type == Alternatives@@Select[Complement[Types[{Object[Container],Object[Instrument],Object[Part], Object[Sensor],Object[Item],Object[Plumbing],Object[Wiring],Object[Sample]}],Types[ToList[Lookup[safeOps, NearestDown]]]],(Length[#]>1&)],
		None
	];

	recursiveContainerSpec = If[levelsUpOption == Infinity,
		Repeated[Container],
		Repeated[Container, levelsUpOption]
	];
	recursiveContentsSpec = If[levelsDownOption == Infinity,
		Repeated[Field[Contents[[All,2]]]],
		Repeated[Field[Contents[[All,2]]], levelsDownOption]
	];

	assembledPlotFields = {
		Sequence@@fieldsList,
		recursiveContainerSpec[objectFields],
		recursiveContainerSpec[Model[modelFields]],
		recursiveContentsSpec[objectFields],
		recursiveContentsSpec[Model[modelFields]]
	};

	(* Perform the Download operation, ignoring warnings for nonexistent fields.
			The first set of results will consist of all information required for plotting, for the items being plotted.
			The second set of results will consist of Container trees for the items being highlighted. These trees will be
				used below to highlight the nearest container if an item requested for highlighting is not within the scope
				of the generated plot(s) based on Level/Nearest options. *)
	{plotDownloadResult, highlightDownloadResult} = Quiet[
		Download[
			{itemObjects, highlightObjects},
			{assembledPlotFields,{Repeated[Container][Object]}},
			{
				(* No halting conditions are required for non-traversal field specs *)
				{None,None,None,None,None,None,None,None,None,None,None,None,None,
				(* Apply NearestUp conditions to Container traversals and NearestDown conditions to Contents traversals *)
				Evaluate[nearestUpHaltingCondition], Evaluate[nearestUpHaltingCondition], Evaluate[nearestDownHaltingCondition], Evaluate[nearestDownHaltingCondition]},
				{None}
			},
			HaltingCondition->Inclusive,
			Cache->incomingCache,
			Date->Now
		],
		Download::FieldDoesntExist
	];

	(* Return an error and $Failed if any of the models are Null except for Object[Sample]s *)
	If[MemberQ[plotDownloadResult[[All,{2,4}]],{Except[TypeP[Object[Sample]]],Null}],
		Return[
			With[{fh=functionHead},Message[fh::ModelNotFound,PickList[itemObjects,plotDownloadResult[[All,4]],Null]]];
			$Failed
		]
	];

	(* Parse the downloaded information to generate:
		1) A list of adjacency lists, one for each input
		2) A list of lists of partial packets for each object *)
	{adjacencyLists,packetLists} = Transpose[Map[
		buildContainerTree[#, objectFields, modelFields]&,
		plotDownloadResult
	]];

	(* Flatten the list of lists of packets for handling all at once *)
	flatPacketsList = Flatten[packetLists];

	(* Check assembled packets for validity; only valid if all required fields are populated.
	 	For containers, Object must have Model and Model must have Positions/PositionPlotting/Dimensions/CrossSectionalShape;
		For non-containers, Object must just have Model*)
	packetValidityBools = Map[
		MatchQ[
			Lookup[#, {Type, Model, Positions, PositionPlotting, Dimensions, CrossSectionalShape}],
			Alternatives[
				{TypeP[LocationNonContainerTypes], ___},
				{TypeP[LocationContainerTypes], Repeated[Except[NullP], 5]}
			]
		]&,
		flatPacketsList
	];

	(* Pull out all invalid packets *)
	invalidPackets = PickList[flatPacketsList, packetValidityBools, False];

	(* Pull out objects from invalid packets *)
	invalidObjects = DeleteDuplicates[Flatten[Lookup[invalidPackets, Object, {}]]];

	(* Remove any invalid objects from adjacency lists *)
	validObjectAdjacencyLists = DeleteCases[adjacencyLists, Rule[Alternatives@@invalidObjects, _] | Rule[_, Alternatives@@invalidObjects], {2}];

	(* Combine all adjacency lists into one *)
	masterAdjacencyGraph = Graph[Union@@validObjectAdjacencyLists];

	(* If any packets are missing essential fields, display a warning message.
		These objects will be omitted from subsequent plotting operations.
	 	Re-using the VOQ message here because objects that fail these tests (or objects whose models
		fail these tests) will be failing VOQ by definition. *)
	If[Length[invalidObjects] > 0, With[{fh=functionHead},Message[fh::InvalidObject, invalidObjects]]];


	(* Identify items that have no container or contents; these will be excluded from the graph merging
		below but will be added back later. Get the positions of these items in the input list so that they
		can	be added back at the appropriate locations if Map->True. *)
	inputsWithoutTrees = PickList[itemObjects, validObjectAdjacencyLists, {}];
	validInputsWithoutTrees = DeleteCases[inputsWithoutTrees, Alternatives@@invalidObjects];
	inputsWithoutTreesNotInMergedGraphs = Select[validInputsWithoutTrees, Cases[validObjectAdjacencyLists, #, Infinity] === {}&];
	inputsWithoutTreesGraphs = Graph[{#->{}}]& /@ inputsWithoutTreesNotInMergedGraphs;
	inputsWithoutTreesPositions = Flatten[Position[validObjectAdjacencyLists, {}]];

	(* If Map->False, combine input objects' graphs as far as possible; otherwise ya gotta keep 'em separated *)
	minimalSetOfGraphs = If[MatchQ[Lookup[safeOps, Map], False],
		(* If there's only one item being plotted, or if the graph is connected and no inputs lack both
			container and contents, move forward with the single, connected graph *)
		If[Or[Length[itemObjects] == 1, And[WeaklyConnectedGraphQ[masterAdjacencyGraph], validInputsWithoutTrees === {}]],
			(* If Map->False and all inputs' adjacency lists form a single connected graph, move forward with that graph *)
			{masterAdjacencyGraph},
			(* If adjacency lists from all inputs do not form a connected graph, throw a warning and combine as much as possible *)
			(
				With[{fh=functionHead},Message[fh::DisconnectedGraph]];
				Subgraph[masterAdjacencyGraph, #]& /@ WeaklyConnectedComponents[masterAdjacencyGraph]
			)
		],
		(* If Map->True, leave adjacency lists separate *)
		Graph /@ validObjectAdjacencyLists
	];

	(* If any input objects have no Container and no Contents with the given LevelsUp/LevelsDown,
		we still want to plot them in isolation IF they are valid objects.
			- If Map->True, replace the empty 'Graph[{}]' entries with the corresponding bare ObjectReferences.
			- If Map->False, the empty adjacency lists for those bare items will have melted away during Graph merging
				and order is not expected to be preserved, so add the bare ObjectReferences back to the end of the list of
				container trees. *)
	graphsWithBareInputs = Switch[{inputsWithoutTreesGraphs, Lookup[safeOps, Map]},
		(* If there were no bare inputs, do nothing *)
		{{}, _}, minimalSetOfGraphs,
		(* If there were bare inputs and Map->True, replace the relevant bare entries with 'Graph[item->{}]' entries *)
		{Except[{}], True},
			ReplacePart[minimalSetOfGraphs, MapThread[Rule, {inputsWithoutTreesPositions, inputsWithoutTreesGraphs}]],
		(* If there were bare inputs and Map->False, append `Graph[item->{}]` entries to the merged minimal set of Graphs *)
		{Except[{}], False},
			If[minimalSetOfGraphs==={Graph[{}]},
				inputsWithoutTreesGraphs,
				Join[minimalSetOfGraphs, inputsWithoutTreesGraphs]
			]
	];

	(* Gather inputs based on which Graph they ended up in *)
	gatheredInputs = Intersection[itemObjects, VertexList[#]]& /@ graphsWithBareInputs;

	(* Convert the adjacency list format to the nested rules required by lower level functions *)
	ctrTrees = convertToTree /@ graphsWithBareInputs;

	(* Assemble a list of replacement rules to convert each Object->Partial packet *)
	objectToPacketRules = Map[
		Rule[Lookup[#,Object], #]&,
		flatPacketsList
	];

	(* Replace all objects with packets *)
	completeTrees = ReplaceAll[ctrTrees, objectToPacketRules];

	(* If there is nothing to plot following removal of invalid items and subsequent processing, return {Null}
	 	This form will play nice with subsequent processing done by PlotLocation / PlotContents to handle output shape
			based on the shape of the original input *)
	If[MatchQ[completeTrees, {{}}], Return[$Failed]];


	(* ----- Figure out remaining plotting parameters and plot recursively ----- *)

	(* For each entry in the Highlight option for each graph, decide whether to use the option as-is
		 (if the item is within the scope of the plot) or to traverse up the highlighted object's container tree
		 until hitting an object that overlaps (if the item is not within the scope of the plot).
		 If the latter does not yield any overlap, highlight nothing. *)
	rectifiedHighlightOption = Map[
		Function[
			{containerGraph},
			If[Length[highlightDownloadResult]>0,
				MapThread[
					Function[
						{singleObjToHighlight, singleObjToHighlightContainers},
						With[
							{vertexList = VertexList[containerGraph],
								obj = If[MatchQ[singleObjToHighlight, ObjectP[]], singleObjToHighlight, First[singleObjToHighlight]]},
							(* Account for either an Object or a {Object, Position} highlight request *)
							If[MemberQ[vertexList, obj],
								(* If the item to highlight is present in the vertex list, return the item as-is *)
								singleObjToHighlight,
								(* If the item to highlight is not present in the vertex list, return the first item
										in itemToHighlight's container tree that overlaps with the container graph being plotted,
										If there is no overlap, return Nothing *)
								FirstCase[Flatten[singleObjToHighlightContainers], Alternatives@@Intersection[vertexList, Flatten[singleObjToHighlightContainers]], Nothing]
							]
						]
					],
					{highlightOption, highlightDownloadResult}
				],
				{}
			]
		],
		graphsWithBareInputs
	];

	(* Assemble a full list of things to highlight for each input *)
	objsToHighlight = If[highlightInputOption,
		(* If input highlighting has been requested, add the relevant input(s) to the existing Highlight option for each graph *)
		MapThread[Join, {rectifiedHighlightOption, gatheredInputs}],
		(* If input highlighting has not been requested, just repeat the provided option value for each graph *)
		rectifiedHighlightOption
	];

	(* Pull out the partial packet and object of the top container in each tree *)
	topContainerPackets = completeTrees[[All,1,1]];
	topContainerObjects = Lookup[topContainerPackets, Object];

	(* Pull the Units of the overall plot from the model of the top (largest) container *)
	targetUnitsOption = Lookup[safeOps, TargetUnits];
	plotUnits = Switch[targetUnitsOption,
		(* If TargetUnits->Automatic, use the unit of the X dimension of each top-level container packet *)
		ListableP[Automatic], Units[First /@ Lookup[topContainerPackets,Dimensions]],
		(* If TargetUnits->DistanceQ, use that unit *)
		_?DistanceQ, Table[targetUnitsOption, Length[topContainerPackets]],
		(* If TargetUnits is a listed pair of matching units, use that unit *)
		{Repeated[x_?DistanceQ,{2}]}, Table[First[targetUnitsOption],Length[topContainerPackets]],
		(* If TargetUnits is a listed pair in which one element is a unit and the other is Automatic, use the unit *)
		{_?DistanceQ, Automatic}, Table[targetUnitsOption,Length[topContainerPackets]],
		{Automatic,_?DistanceQ}, Table[targetUnitsOption,Length[topContainerPackets]],
		(* If TargetUnits is a listed pair of non-matching units (must be if this condition is reached), throw a warning and use the first unit *)
		{_?DistanceQ, _?DistanceQ},
			(
				With[{fh=functionHead},Message[fh::MismatchedUnits, targetUnitsOption, First[targetUnitsOption]]];
				Table[First[targetUnitsOption],Length[topContainerPackets]]
			)
	];

	(* Convert units to UnitDimension <> UnitForm for labeling frames / axes *)
	frameLabels = Map[
		(* Must use Metric->False here to avoid auto-conversion of non-metric units to metric (e.g. Foot->mm) *)
		StringJoin[UnitDimension[#], UnitForm[#, Number->False, Metric->False]]&,
		plotUnits
	];

	(* Determine the anchor points for the top-level container of each container tree *)
	(* Anchor point is at the container's x-y center, z=0 *)
	anchorPoints = Append[#, 0]& /@ MapThread[
		Unitless,
		{(Lookup[topContainerPackets, Dimensions][[All,;;2]]) / 2, plotUnits}
	];

	(* Expand plot range for all inputs *)
	plotRanges = Map[
		Unitless[Lookup[safeOps, PlotRange], #]&,
		plotUnits
	];

	(* Traverse all requested levels of container and plot from top to bottom, recursively drawing each position in the parent coordinate system *)
	(* Offsets are now passed around as AnchorPoints (Center) *)
	allPlotGraphics = MapThread[
		Function[
			{ctrTree, anchorPoint, highlighted, units, inputObj},
			containerAndPositionGraphics[First[ctrTree], anchorPoint, {}, 1,
				Highlight->highlightOption, ResolvedHighlight->highlighted, Units->units, InputObjects->inputObj, PlotType->Lookup[safeOps, PlotType],
				LabelPositions->Lookup[safeOps, LabelPositions], HighlightStyle->highlightStyleOption,
				ContainerStyle->containerStyleOption, PositionStyle->positionStyleOption, LiveDisplay->liveDisplayOption,
				PositionTooltips->Lookup[safeOps, PositionTooltips], FunctionHead->Lookup[safeOps, FunctionHead],
				DrawPositions->Lookup[safeOps, DrawPositions]
			]
		],
		{completeTrees, anchorPoints, objsToHighlight, plotUnits, gatheredInputs}
	];

	(* Select the appropriate Graphics head depending on whether 2D or 3D plot has been requested *)
	graphicsHead = If[plot3DBool,
		Graphics3D,
		Graphics
	];

	(* Put all the pieces together *)
	plots = MapThread[
		Function[
			{graphics, units, range},
			graphicsHead[
				{FaceForm[White],EdgeForm[Black],graphics},
				ImageSize->Lookup[safeOps, ImageSize],
				Background->White,
				ContentSelectable->False,
				PlotRangeClipping->True,
				(* Assemble other options based on specified PlotStyle and Axes options *)
				Sequence@@Join[
					If[plot3DBool,
						{Boxed->False,Lighting->"Neutral",SphericalRegion->True,RotationAction->"Clip"},
						{GridLines->Automatic,GridLinesStyle->Opacity[0.05],Method->{"GridLinesInFront"->True},PlotRange->range}
					],
					If[Lookup[safeOps, Axes],
						If[plot3DBool,
							{Axes->True,AxesLabel->{units, units, units}},
							{Axes->False, Frame->True, FrameLabel->{units,units}}
						],
						{}
					]
				]
			]
		],
		{allPlotGraphics, frameLabels, plotRanges}
	];

	If[Lookup[safeOps, Map],
		(* If Maps->True, return a list of all input plots *)
		plots,
		If[Length[plots] == 1,
			(* If Maps->False and all inputs formed a connected graph, return a single bare plot containing all inputs *)
			First[plots],
			(* If Maps->False but inputs did not form a connected graph, return a list of maximally-merged plots *)
			plots
		]
	]

];


(* Pass singleton position input to singleton plotContainer overload *)
plotContainer[myPosition:{ObjectReferenceP[LocationContainerTypes], _String}, myOps:OptionsPattern[]] := Module[
	{updatedHighlightOption},

	(* Add the input position to the list of items to highlight *)
	updatedHighlightOption = Append[OptionValue[Highlight], myPosition];

	(* Pass to singleton overload of plotContainer, replacing the old value of the Highlight option *)
	plotContainer[First[myPosition],Sequence@@ReplaceRule[ToList[myOps],{Highlight -> updatedHighlightOption, HighlightInput -> False}]]

];


(* Handle listed position input *)
plotContainer[myPositions:{{ObjectReferenceP[LocationContainerTypes], _String}..}, myOps:OptionsPattern[]] := Module[
	{updatedHighlightOption},

	(* Add the input positions to the list of items to highlight *)
	updatedHighlightOption = Join[OptionValue[Highlight], myPositions];

	(* Pass to plotContainer *)
	plotContainer[myPositions[[All,1]],Sequence@@ReplaceRule[ToList[myOps],{Highlight->updatedHighlightOption, HighlightInput->False}] ]

];


(* ::Subsubsection:: *)
(*PlotLocation*)


DefineOptions[PlotLocation,
	Options:>{OutputOption},
	SharedOptions :> {plotContainer}
];

PlotLocation::ObjectNotFound = "Unable to find the following objects in the database for plotting: `1`. Check that these input Object(s) have been entered correctly.";
PlotLocation::ModelNotFound = "Unable to plot the following objects due to missing container models: `1`. Populate the 'Model' field to make these Objects plottable.";
PlotLocation::DisconnectedGraph = "The specified inputs cannot be visualized on a single plot given the specified depth options. They will be split into the minimum number of connected container plots. If a single plot is desired, consider increasing LevelsUp/LevelsDown values to find overlap between the containers or contents of the input objects.";
PlotLocation::IncompatibleOptions = "LiveDisplay is unavailable when plotting in 3D. To use LiveDisplay, set PlotType->Plot2D.";
PlotLocation::MismatchedUnits = "The specified TargetUnits, `1`, do not match. Using units `2` for all plot dimensions. When specifying TargetUnits as a list, all members of the list must match.";
PlotLocation::InvalidObject = "The following objects or their models are missing fields that are required for plotting: `1`. These object(s) and their contents will be omitted from the resultant plot(s). Run ValidObjectQ with Verbose->Failures for more information.";
PlotLocation::InvalidPosition = "The following {object, position} pairs cannot be plotted because the specified positions are not defined in their container's model: `1`.";

PlotLocation[myItems:ListableP[ObjectP[LocationTypes]] | ListableP[{ObjectReferenceP[LocationContainerTypes], _String}], myOps:OptionsPattern[]] := Module[
	{nearestUpOption, levelsDownOption, safeOps,output,plotContainerOptions,fig},

	(* Pass the Location-plotting-standard NearestUp option UNLESS the user has specified a LevelsUp option, or if NearestUp was explicitly specified *)
	nearestUpOption=If[
		And[
			MatchQ[OptionValue[LevelsUp], Except[_Integer | Infinity]],
			MatchQ[OptionValue[NearestUp], Except[ListableP[TypeP[]]]]
		],
		NearestUp->Object[Container, Building],
		Nothing
	];

	(* Pass the Location-plotting-standard LevelsDown option UNLESS the user has specified it *)
	levelsDownOption = If[!MemberQ[ToList[myOps], HoldPattern[LevelsDown->_]],
		LevelsDown->1,
		Nothing
	];

	safeOps = SafeOptions[
		PlotLocation,
		ToList[ReplaceRule[ToList[myOps], {levelsDownOption, nearestUpOption, FunctionHead->PlotLocation}]]
	];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(*remove Output from the options to put into plotContainer*)
	plotContainerOptions=Normal@KeyDrop[Association[safeOps],Output];

	(*Call plotContainer*)
	fig=plotContainer[myItems, Sequence@@plotContainerOptions];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result->fig,
		Preview->fig,
		Tests->{},
		Options->safeOps
	}

];


(* ::Subsubsection:: *)
(*PlotContents*)

DefineOptions[PlotContents,
	Options:>{OutputOption},
	SharedOptions :> {

		(* Modify some of the ListPlotOptions options *)
		ModifyOptions["Shared",
			ListPlotOptions,
			{
				{OptionName->ContentSelectable,Default->False},
				{OptionName->PlotRangeClipping,Default->True},
				{OptionName->GridLines,Default->Automatic},
				{OptionName->GridLinesStyle,Default->Automatic}
			}
		],

		(* Take and don't change these options from ListPlotOptions *)
		ModifyOptions["Shared",ListPlotOptions,{Frame,FrameLabel,AxesLabel,Method}],

		(* Modify some of the ListPlot3DOptions options *)
		ModifyOptions["Shared",
			ListPlot3DOptions,
			{
				{OptionName->Boxed,Default->False},
				{OptionName->Lighting,Default->"Neutral"},
				{OptionName->SphericalRegion,Default->True},
				{OptionName->RotationAction,Default->"Clip"}
			}
		],

		(* Share all options from plotContainer *)
		plotContainer

	}
];

PlotContents::ObjectNotFound = "Unable to find the following objects in the database for plotting: `1`. Check that these input Object(s) have been entered correctly.";
PlotContents::ModelNotFound = "Unable to plot the following objects due to missing container models: `1`. Populate the 'Model' field to make these Objects plottable.";
PlotContents::DisconnectedGraph = "The specified inputs cannot be visualized on a single plot given the specified depth options. They will be split into the minimum number of connected container plots. If a single plot is desired, consider increasing LevelsUp/LevelsDown values to find overlap between the containers or contents of the input objects.";
PlotContents::IncompatibleOptions = "LiveDisplay is unavailable when plotting in 3D. To use LiveDisplay, set PlotType->Plot2D.";
PlotContents::MismatchedUnits = "The specified TargetUnits, `1`, do not match. Using units `2` for all plot dimensions. When specifying TargetUnits as a list, all members of the list must match.";
PlotContents::InvalidObject = "The following objects or their models are missing fields that are required for plotting: `1`. These object(s) and their contents will be omitted from the resultant plot(s). Run ValidObjectQ with Verbose->Failures for more information.";
PlotContents::InvalidPosition = "The following {object, position} pairs cannot be plotted because the specified positions are not defined in their container's model: `1`.";

PlotContents[myItems:ListableP[ObjectP[LocationTypes]] | ListableP[{ObjectReferenceP[LocationContainerTypes], _String}], myOps:OptionsPattern[PlotContents]] := Module[
	{safeOps, levelsUpOption, levelsDownOption,output,plot},

	(* Pass the Contents-plotting-standard LevelsUp option UNLESS the user has specified it *)
	levelsUpOption = If[!MemberQ[ToList[myOps], HoldPattern[LevelsUp->_]],
		LevelsUp->0,
		Nothing
	];

	(* Pass the Contents-plotting-standard LevelsDown option UNLESS the user has specified it *)
	levelsDownOption = If[!MemberQ[ToList[myOps], HoldPattern[LevelsDown->_]],
		LevelsDown->1,
		Nothing
	];

	(* Convert the original option into a list *)
	originalOps=ToList[myOps];

	safeOps = SafeOptions[
		PlotContents,
		ToList[ReplaceRule[ToList[myOps], {levelsUpOption, levelsDownOption, FunctionHead->PlotContents, DrawPositions->False}]]
	];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* The options passed to EmeraldListLinePlot *)
	passingOps=ToList@Plot`Private`stringOptionsToSymbolOptions[PassOptions[PlotContents,plotContainer,safeOps]];

	plots=ToList@plotContainer[myItems, Sequence@@passingOps];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result-> (If[Length[plots] == 1, First[plots], SlideView[plots]]),
		Preview->
			(
				If[Length[plots] == 1, First[plots], SlideView[plots]]
			) /.
			If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{},
		Options->safeOps
	}

];


(* ReverseMapping overload to handle plotting of models *)



(* Authors definition for PlotContents *)
Authors[PlotContents]:={"dirk.schild"};

PlotContents[myModel:ObjectP[LocationContainerModelTypes], myOps:OptionsPattern[PlotContents]] := Module[{output},
	output=PlotContents[ToList[myModel],myOps];
	If[MatchQ[output,$Failed],
		$Failed,
		output
	]
];

PlotContents[myModels:{ObjectP[LocationContainerModelTypes]..}, myOps:OptionsPattern[PlotContents]] := Module[
	{
		safeOps, modelPackets, plot3DBool, plotUnits, plotRanges, anchorPoints,
		containerPrimitiveOptions, outlineGraphics, positionPrimitiveOptions, positionGraphics,
		graphicsHead, modelPositions, frameLabels, containerStyleOption, positionStyleOption,
		highlightStyleOption, validityBools,output,plots,returnedPlotOps,mergedReturnedOps,
		resolvedOps
	},

	(* Convert the original option into a list *)
	originalOps=ToList[myOps];

	safeOps = SafeOptions[PlotContents, originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(* Check ValidObjectQ if FastTrack->False *)
	validityBools = If[!Lookup[safeOps, FastTrack],
		ValidObjectQ[myModels, OutputFormat->Boolean],
		Table[True, Length[myModels]]
	];

	(* If any items have been flagged as invalid, return *)
	If[!And@@validityBools,
		Return[Message[PlotContents::InvalidObject, PickList[myModels, validityBools, False]];$Failed]
	];

	(* Resolve style options *)
	{containerStyleOption, positionStyleOption, highlightStyleOption} = choosePlotStyles[safeOps];

	(* Download all models' relevant information *)
	modelPackets = Download[
		myModels,
		Packet[Object, Type, Positions, PositionPlotting, Dimensions, CrossSectionalShape, Shape2D, Shape3D],
		Date->Now
	];

	(* Determine whether this is a 3D plot *)
	plot3DBool = MatchQ[Lookup[safeOps, PlotType], Plot3D];

	(* Pull out Units in which each Model is defined *)
	plotUnits = Units[First /@ Lookup[modelPackets, Dimensions]];

	frameLabels = Map[
		StringJoin[UnitDimension[#], UnitForm[#, Number->False]]&,
		plotUnits
	];

	(* Expand plot range for all inputs *)
	plotRanges = Map[
		Unitless[Lookup[safeOps, PlotRange], #]&,
		plotUnits
	];

	(* generate single position definitions from information from the Positions/PositionPlotting fields for each of the models *)
	modelPositions = Map[
		Function[modelPacket,
			Map[
				Function[position,
					Module[{dimensions, positionPlottingEntry, anchorPoint},

						(* get the dimensions into a single tuple; these can be Null, so turn into 0 Meter *)
						dimensions = Lookup[position, {MaxWidth, MaxDepth, MaxHeight}]/.{Null->0 Meter};

						(* find the appropriate PositionPlotting entry for this position name *)
						positionPlottingEntry = SelectFirst[Lookup[modelPacket, PositionPlotting], MatchQ[Lookup[#, Name], Lookup[position, Name]]&];

						(* from the plotting entry, get the anchor point as a single spec *)
						anchorPoint = Lookup[positionPlottingEntry, {XOffset, YOffset, ZOffset}];

						(* assemble a single position entry with all informatino combined into downstream expected format *)
						{Name->Lookup[position, Name], AnchorPoint->anchorPoint, Dimensions->dimensions, CrossSectionalShape->Lookup[positionPlottingEntry, CrossSectionalShape], Rotation->Lookup[positionPlottingEntry, Rotation]}
					]
				],
				Lookup[modelPacket, Positions]
			]
		],
		modelPackets
	];

	(* Determine the anchor point for this top-level container *)
	anchorPoints = Append[#, 0]& /@ (Unitless[Lookup[modelPackets, Dimensions][[All,;;2]]] / 2);

	(* Generate the container outline *)
	containerPrimitiveOptions = PassOptions[plotContainer,containerPrimitive,safeOps];
	outlineGraphics = MapThread[
		Function[
			{packet, anchorpt},
			containerPrimitive[
				packet,
				anchorpt,
				{},
				Style->containerStyleOption,
				LiveDisplay->False,
				containerPrimitiveOptions
			]
		],
		{modelPackets, anchorPoints}
	];

	(* Generate the positions *)
	positionPrimitiveOptions = PassOptions[plotContainer,positionPrimitive,safeOps];
	positionGraphics = MapThread[
		Function[
			{positions, units, anchorpt},
			If[!MatchQ[positions, {}],
				Map[
					With[
						{curRot=Rotation/.#, anch=anchorOffsets[#,{0,0,0},1]},
						positionPrimitive[
							#,
							units,
							anch,
							addRotation[{},curRot,anch,plot3DBool],
							Tooltip->assembleTooltip[#],
							Style->positionStyleOption,
							Empty->True,
							LiveDisplay->False,
							positionPrimitiveOptions
						]
					]&,
					positions
				],
				{}
			]
		],
		{modelPositions, plotUnits, anchorPoints}
	];

	(* Select the appropriate Graphics head depending on whether 2D or 3D plot has been requested *)
	graphicsHead = If[plot3DBool,
		Graphics3D,
		Graphics
	];

	(* Resolving 2D/3D plot options *)
	resolvedAxes=If[MatchQ[Lookup[safeOps,Axes],Automatic],
		If[plot3DBool,True,False]
	];

	(* Put all the pieces together *)

	{plots,returnedPlotOps}=Transpose@
		MapThread[
			Function[
				{outline, posGraphs, units, range},
				Module[{options},
					options={
						Sequence@@Join[
							If[plot3DBool,
								{
									GridLines->
										If[MatchQ[Lookup[safeOps,GridLines],Automatic],None,Lookup[safeOps,GridLines]],
									GridLinesStyle->
										If[MatchQ[Lookup[safeOps,GridLinesStyle],Automatic],None,Lookup[safeOps,GridLinesStyle]]
								},
								{
									GridLines->
										If[MatchQ[Lookup[safeOps,GridLines],Automatic],Automatic,Lookup[safeOps,GridLines]],
									GridLinesStyle->
										If[MatchQ[Lookup[safeOps,GridLinesStyle],Automatic],Opacity[0.05],Lookup[safeOps,GridLinesStyle]],
									Method->
										If[MatchQ[Lookup[safeOps,Method],Automatic],{"GridLinesInFront"->True},Lookup[safeOps,GridLinesStyle]],
									PlotRange->range
								}
							],
							If[Lookup[safeOps, Axes],
							 	If[plot3DBool,
									{Axes->True,AxesLabel->{units, units, units}},
									{Axes->False, Frame->True, FrameLabel->{units,units}}
								],
								{}
							]
						]
					};
					{
						graphicsHead[
							{FaceForm[White],EdgeForm[Black],outline,posGraphs},
							PassOptions[PlotContents,graphicsHead,options]
						],
						options
					}
				]
			],
			{outlineGraphics, positionGraphics, frameLabels, plotRanges}
		];

	(* Options are aggregated into a single list by preserving those that were resolved to the same value for all inputs. Any options resolved to different values between inputs are set to Automatic. *)
	mergedReturnedOps=MapThread[If[CountDistinct[List@##]>1,First@#->Automatic,First@DeleteDuplicates[List@##]]&,returnedPlotOps];

	(* The final resolved options based on safeOps and the returned options from ELLP calls *)
	resolvedOps=ReplaceRule[safeOps,mergedReturnedOps];

	(* Return the result, options, or tests according to the output option. *)
	output/.{
		Result-> (If[Length[plots] == 1, First@plots, SlideView[plots]]),
		Preview->
			(
				If[Length[plots] == 1, First@plots, SlideView[plots]]
			) /.
			If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{},
		Options->resolvedOps
	}

];


(* ::Subsubsection:: *)
(*buildContainerTree*)

Error::ModelessItemsCannotBePlotted="The following objects, `1`, do not have a Model and therefore do not have defined Positions/Dimensions/etc that are required for plotting. Please correct the Model field for these objects.";

(* Takes the results of plotContainer Download call for a single object (i.e., container and contents tree for a single object).
	Each element will consist of a set of bare field results for the focal object, followed by four recursive result lists
	Return will be: 1) Full adjacency list (up and down containers included); 2) List of packets for items in the adjacency list *)
buildContainerTree[downloadResult_List, objectFields_List, modelFields_List] := Module[
	{combinedFieldNames, focalObjectFields, focalModelFields, containerObjectFields, containerModelFields,
	contentsObjectFields, contentsModelFields, itemsWithoutModels, containerPackets, containerPacketsDescendingOrder,
	fullNestedObjectFieldsTree, fullNestedModelFieldsTree, containersGraph,
	contentsPackets, contentsGraph},

	combinedFieldNames = Join[objectFields, modelFields];

	(* --- Split Download result into components and handle focal object fields --- *)

	(* Extract the first 'n' items from the Download result (fields from focal object), where 'n' is the length of 'objectFields' + 'modelFields' *)
	focalObjectFields = downloadResult[[;;Length[objectFields]]];
	focalModelFields = downloadResult[[Length[objectFields]+1;;Length[objectFields]+Length[modelFields]]];

	(* Rest of Download result will be, in order: 1) containers' Object fields; 2) containers' Model fields; 3) contents' Object fields; 4) contents' Model fields *)
	(* In order for the containers to connect to the downstream contents, the focal object's information must be added to both the container and contents query results
		For the container query results, this can be done by simply prepending since the results are in ascending order (smallest container first)
		For the contents query results, the focal object information must be added as the outermost level of nested information *)
	containerObjectFields = Prepend[downloadResult[[-4]], focalObjectFields];
	containerModelFields = Prepend[downloadResult[[-3]], focalModelFields];
	contentsObjectFields = {{focalObjectFields, Cases[downloadResult[[-2]], Except[Null]]}};
	contentsModelFields = {{focalModelFields, Cases[downloadResult[[-1]], Except[Null]]}};

	(* NOTE: If there are any model-less instruments/parts/items, this will cause PlotContents to wall of red. *)
	(* Try to catch this. *)
	itemsWithoutModels=Cases[Transpose[{downloadResult[[-2]], downloadResult[[-1]]}], {_, Null}][[All,1]][[All,1]];

	If[Length[itemsWithoutModels]>0,
		Message[Error::ModelessItemsCannotBePlotted, ECL`InternalUpload`ObjectToString[itemsWithoutModels]];

		Abort[];
	];

	(* --- Parse 'upward' traversals (flat list) --- *)

	(* Generate packets from field names and values (essentially recapitulate Output->Association) *)
	containerPackets = MapThread[
		AssociationThread[combinedFieldNames, Join[#1, #2]]&,
		{containerObjectFields, containerModelFields}
	];

	(* Reverse list of packets to be in descending location hierarchichal order *)
	containerPacketsDescendingOrder = Reverse[containerPackets];

	(* Generate adjacency rules for each sequential pair items to reflect the Container->Contents relationship *)
	containersGraph = Rule @@@ Partition[Lookup[containerPacketsDescendingOrder, Object], 2, 1];


	(* --- Parse 'downward' traversals (nested list) --- *)

	(* Model and Object trees should have the same shape, so traverse both simultaneously using a recursive helper *)
	(* Returns a list of {adjacency list, packets for items in adjacency list} *)
	{contentsGraph, contentsPackets} = traverseContentsTree[contentsObjectFields, contentsModelFields, objectFields, modelFields];

	(* Combine container and contents adjacency lists and packet lists for return *)
	{
		Join[containersGraph, contentsGraph],
		Join[containerPackets, contentsPackets]
	}

];

(* List of ancestors with descendants *)
(* Descendant list must be allowed to be '$Failed' for the case where the item being plotted is a sample which has no Contents field *)
traverseContentsTree[objectTree:{{{ObjectReferenceP[],__},{({__}|Null|$Failed)...}|Null|$Failed}..}, modelTree:{{{__},{({__}|Null|$Failed)...}|$Failed}..}, objectFields_List, modelFields_List] := Module[
	{},

	Flatten/@Transpose[MapThread[
		traverseContentsTree[#1, #2, objectFields, modelFields]&,
		{objectTree, modelTree}
	]]

];

(* Single ancestor with descendants *)
traverseContentsTree[objectTree:{{ObjectReferenceP[],__},{{__}...}}, modelTree:{{__},{({__}|Null)...}}, objectFields_List, modelFields_List] := Module[
	{thisLevelPacket, combinedFieldNames, nextLevelContentsObjects, thisLevelAdjacencyRules, thisLevelObjectToPacketRule,
	nextLevelTraversals, parentObjectFields, parentModelFields},

	combinedFieldNames = Join[objectFields, modelFields];

	(* Extract the ancestor Object fields and Model fields at this level *)
	parentObjectFields = First[objectTree];
	parentModelFields = First[modelTree];

	(* MapThread containers' Object and Model fields together and add field names *)
	thisLevelPacket = AssociationThread[
		combinedFieldNames,
		Join[parentObjectFields, parentModelFields]
	];

	(* Find ObjectReferences of all next-level contents in order to construct adjacency rules for this level *)
	(* Assumes that the ObjectReference will be the first field in ObjectFields.
		Next level may either be a list of lists (no further levels to traverse) or a list of lists of lists (further levels to traverse). *)
	nextLevelContentsObjects = Map[
		If[MatchQ[#, {ObjectReferenceP[],__}],
			#[[1]],
			#[[1,1]]
		]&,
		objectTree[[2]]
	];

	(* Generate graph adjacency rules between this level's for this level *)
	thisLevelAdjacencyRules = Rule[Lookup[thisLevelPacket, Object], #]& /@ nextLevelContentsObjects;

	(* Traverse the next level *)
	nextLevelTraversals = MapThread[
		traverseContentsTree[#1, #2, objectFields, modelFields]&,
		{objectTree[[2]], modelTree[[2]]}
	];

	(* Join subsequent recursion results with this level and return *)
	{
		Join[Flatten[nextLevelTraversals[[All,1]]], thisLevelAdjacencyRules],
		Append[Flatten[nextLevelTraversals[[All,2]]], thisLevelPacket]
	}

];

(* Single non-container ancestor; descendants are $Failed because ancestor has no Contents field *)
traverseContentsTree[objectTree:{{ObjectReferenceP[],__},{$Failed}|Null|$Failed}, modelTree:{({__}|Null),{$Failed}|$Failed}, objectFields_List, modelFields_List] := Module[
	{combinedFieldNames, thisLevelPacket, objectToPacketRule, safeModelTree},

	combinedFieldNames = Join[objectFields, modelFields];

	(* If the model is Null, model fields will not have been downloaded.
		Replace with a list of Nulls for now; will be caught by error checking within plotContainer *)
	safeModelTree = If[NullQ[First[modelTree]], Table[Null, Length[modelFields]], First[modelTree]];

	(* MapThread containers' Object and Model fields together and add field names *)
	thisLevelPacket = AssociationThread[
		combinedFieldNames,
		Join[First[objectTree], safeModelTree]
	];

	(* Return a list of {adjacency rules for graph, packets for objects in graph} *)
	(* No more adjacency rules to add since there are no more contents *)
	{{}, thisLevelPacket}

];


(* Single terminal descendant *)
traverseContentsTree[objectTree:{ObjectReferenceP[],__} | {}, modelTree:{__}|Null, objectFields_List, modelFields_List] := Module[
	{combinedFieldNames, thisLevelPacket, objectToPacketRule, safeModelTree},

	combinedFieldNames = Join[objectFields, modelFields];

	(* If the model is Null, model fields will not have been downloaded.
		Replace with a list of Nulls for now; will be caught by error checking within plotContainer *)
	safeModelTree = If[NullQ[modelTree], Table[Null, Length[modelFields]], modelTree];

	(* MapThread containers' Object and Model fields together and add field names *)
	thisLevelPacket = AssociationThread[
		combinedFieldNames,
		Join[objectTree, safeModelTree]
	];

	(* Return a list of {adjacency rules for graph, packets for objects in graph} *)
	(* No more adjacency rules to add since there are no more contents *)
	{{}, thisLevelPacket}

];


(* ::Subsubsection:: *)
(*containerAndPositionGraphics*)


DefineOptions[containerAndPositionGraphics,
	Options:>{
		{Units->Meter,_?DistanceQ,"The units in which the final plot will be drawn."},
		{InputObjects->Null, Null | {ObjectP[LocationTypes]..}, "The input to the top-level plotContainer call"}
	},
	SharedOptions:>{
		plotContainer
	}
];


containerAndPositionGraphics[
	myTree:(PacketP[LocationContainerTypes] | Rule[PacketP[LocationContainerTypes], __]),
	myOffsetAnchorPoint_List,
	myRotations_List,
	myIterationNumber:GreaterP[0,1],
	myOps:OptionsPattern[]
] := Module[
	{opsList, terminalItemBool, focalPacket, downstreamContents, containerPrimitiveOptions, positionPrimitiveOptions,
	focalObject, focalObjectUnit, unitScalar, plot3DBool, focalObjectBottomLeftCorner, outlineGraphic,
	positionDefinitions, sortedPositionDefinitions, sortedPositionNames, sortedPositionRotations,
	sortedPositionOffsetAnchorPoints, sortedPositionContents, positionPrimitives, sortedNextLevelContents,
	sortedNextLevelContentsPositionNames, sortedNextLevelContentsRotations, sortedNextLevelContentsAnchors,
	fixedNextLevelContents, typeSpecificColor, liveDisplayFunctionCall, combinedPrimitives, downstreamContainerObjects,
	plotPositionBools, invalidPositionContents, contentsLookup},

	(* ---------------------- Pull and calculate basic information about this container/instrument ---------------------- *)

	opsList = ToList[myOps];

	(* Determine whether this is a terminal item (bare packet) or a non-terminal item (rule) *)
	terminalItemBool = MatchQ[myTree, PacketP[]];

	(* Extract the packet for this level's focal item and those for any downstream contents *)
	focalPacket = If[terminalItemBool, myTree, First[myTree]];
	downstreamContents = If[terminalItemBool, {}, Last[myTree]];

	(* Generate option sets for each graphics-generating function so they don't have to be recalculated for each call *)
	containerPrimitiveOptions = PassOptions[containerAndPositionGraphics, containerPrimitive, opsList];
	positionPrimitiveOptions = PassOptions[containerAndPositionGraphics, positionPrimitive, opsList];

	(* Get the focal object reference *)
	focalObject = Lookup[focalPacket, Object];

	(* Pull units from the model *)
	focalObjectUnit = Units[First[Lookup[focalPacket, Dimensions]]];

	(* If the thing we're trying to plot doesn't have basic plotting information (e.g. units) in its model, return an empty list *)
	If[MatchQ[focalObjectUnit, Null|_Missing], Return[{}]];

	(* Figure out unit conversion -- generate a conversion scalar *)
	unitScalar = Unitless[Convert[focalObjectUnit, OptionValue[Units]]];

	(* Figure out whether we're plotting in 3D *)
	plot3DBool = MatchQ[OptionValue[PlotType], Plot3D];

	(* Calculate this container's bottom-left corner (offsetAnchorPoint - {1/2 DimX,1/2 DimY,0})*)
	focalObjectBottomLeftCorner = bottomLeftCorner[focalPacket, myOffsetAnchorPoint, unitScalar];


	(* ------------------------------ Draw graphics primitives for outline of focal object ----------------------------- *)

	typeSpecificColor = containerColor[focalPacket, plot3DBool];

	(* Generate a graphics primitive for the outline of the thing *)
	outlineGraphic = containerPrimitive[
		focalPacket,
		myOffsetAnchorPoint,
		myRotations,
		UnitScalar->unitScalar,
		Tooltip->assembleTooltip[focalPacket,0.5],
		Style->If[MemberQ[ToList[OptionValue[ResolvedHighlight]], focalObject],
			Append[Join[OptionValue[ContainerStyle],OptionValue[HighlightStyle]], typeSpecificColor],
			Append[OptionValue[ContainerStyle], typeSpecificColor]
		],
		Object->focalObject,
		ClickFunction -> If[!OptionValue[LiveDisplay],
	   		(* Do nothing on click if LiveDisplay is disabled *)
	   		Null,
			(* Otherwise, set up re-zooming on click.
				Pass unresolved Highlight option here to allow for re-resolution upon re-plotting. *)
			assembleClickFunction[focalObject, OptionValue[Highlight], OptionValue[FunctionHead]]
		],
		containerPrimitiveOptions
	];


	(* ------------------------ Plot positions and recurse deeper if needed; Return outline graphic, highlight graphic, and any position graphics -------------------------- *)

	(* generate single position definitions from information from the Positions/PositionPlotting fields for the focal packet *)
	positionDefinitions = Map[
		Function[position,
			Module[{dimensions, positionPlottingEntry, anchorPoint},

				(* get the dimensions into a single tuple *)
				dimensions = Lookup[position, {MaxWidth, MaxDepth, MaxHeight}]/.{Null->0 Meter};

				(* find the appropriate PositionPlotting entry for this position name *)
				positionPlottingEntry = SelectFirst[Lookup[focalPacket, PositionPlotting], MatchQ[Lookup[#, Name], Lookup[position, Name]]&];

				(* from the plotting entry, get the anchor point as a single spec *)
				anchorPoint = Lookup[positionPlottingEntry, {XOffset, YOffset, ZOffset}];

				(* assemble a single position entry with all informatino combined into downstream expected format *)
				{Name->Lookup[position, Name], AnchorPoint->anchorPoint, Dimensions->dimensions, CrossSectionalShape->Lookup[positionPlottingEntry, CrossSectionalShape], Rotation->Lookup[positionPlottingEntry, Rotation]}
			]
		],
		Lookup[focalPacket, Positions]
	];

	(* Return just the outline graphics if no positions are defined *)
	If[
		MatchQ[positionDefinitions, {}|NullP|_Missing],
		Return[GraphicsGroup[{outlineGraphic}]]
	];

	(* Sort positions by Z-height so that they are drawn in the proper order on 2D plots *)
	sortedPositionDefinitions = SortBy[positionDefinitions,Lookup[#, AnchorPoint][[3]]&];

	(* Look up the name of each position in sorted order *)
	sortedPositionNames = Lookup[sortedPositionDefinitions, Name];

	(* Look up the rotation of each position in sorted order *)
	sortedPositionRotations = Lookup[sortedPositionDefinitions, Rotation];

	(* Calculate the offset anchor point for each position in sorted order *)
	sortedPositionOffsetAnchorPoints = Map[
		anchorOffsets[#, focalObjectBottomLeftCorner, unitScalar]&,
		sortedPositionDefinitions
	];

	(* Look up the contents of each position in sorted order *)
	sortedPositionContents = Map[
		Cases[
			Lookup[focalPacket, Contents],
			{Lookup[#, Name], obj_} :> obj[Object]
		]&,
		sortedPositionDefinitions
	];

	(* Extract the direct contents' Objects to be used below to determine whether or not each position should be plotted;
	 	Exclude non-container Types so that positions filled with samples directly are still plotted (e.g. wells in a plate) *)
	downstreamContainerObjects = Cases[
		Lookup[Replace[downstreamContents, item_Rule :> First[item], {1}], Object, {}],
		Except[ObjectP[LocationNonContainerTypes]]
	];

	(* For each position, decide whether or not to plot it *)
	plotPositionBools = Map[
		If[Or[terminalItemBool, Length[#]==0],
			(* If this is the last level being plotted or the position has no contents, plot it *)
			True,
			(* Otherwise, only plot the position if none of its contents are going to be plotted in future iterations *)
			Length[Intersection[#, downstreamContainerObjects]] == 0
		]&,
		sortedPositionContents
	];

	(* Draw graphics for each position;
		Only draw position primitives if this is the top-level object being plotted. *)
	positionPrimitives = If[Or[myIterationNumber == 1, OptionValue[DrawPositions]],
		MapThread[
			Function[
				{currentPositionDefinition, currentPositionAnchorPoint, currentPositionContentsObjects, plotPositionBool},
				If[plotPositionBool,
					positionPrimitive[
						currentPositionDefinition,
						focalObjectUnit,
						currentPositionAnchorPoint,
						addRotation[myRotations,Lookup[currentPositionDefinition, Rotation], currentPositionAnchorPoint, plot3DBool],
						UnitScalar -> unitScalar,
						Tooltip -> If[OptionValue[PositionTooltips],
							assembleTooltip[focalObject, Lookup[currentPositionDefinition, Name], currentPositionContentsObjects, 0.2],
							Null
						],
						(* Not sure if {focalObject, Lookup[currentPositionDefinition, Name]} would ever match the format of ResolvedHighlight but leaving it since it was there *)
						Style -> If[MemberQ[OptionValue[ResolvedHighlight], Alternatives[{focalObject, Lookup[currentPositionDefinition, Name]},Sequence@@currentPositionContentsObjects]],
							Join[OptionValue[PositionStyle],OptionValue[HighlightStyle]],
							OptionValue[PositionStyle]
						],
						Object -> focalObject,
						ClickFunction -> If[!OptionValue[LiveDisplay],
							(* Do nothing on click if LiveDisplay is disabled or the object currently being plotted is the original input object *)
							Null,
							(* Otherwise, set up re-zooming on click.
								Pass unresolved Highlight option here to allow for re-resolution upon re-plotting. *)
							assembleClickFunction[{focalObject, Lookup[currentPositionDefinition, Name]}, OptionValue[Highlight], OptionValue[FunctionHead]]
						],
						positionPrimitiveOptions
					],
					Nothing
				]
			],
			{sortedPositionDefinitions, sortedPositionOffsetAnchorPoints, sortedPositionContents, plotPositionBools}
		],
		{}
	];


	(* Since any given piece of contents can be either a rule or a bare packet, define a simple function to look up
	fields within a single member or a list of contents. For a packet this is a simple Lookup; for a Rule it is a Lookup[First[]]. *)
	contentsLookup[contentsList_List, field_] := contentsLookup[#, field]& /@ contentsList;
	contentsLookup[contents_, field_] := If[MatchQ[contents, _Rule], Lookup[First[contents], field], Lookup[contents, field]];

	(* Sort the next-level contents based on the z-sorted list of position names *)
	sortedNextLevelContents = SortBy[
		downstreamContents,
		FirstOrDefault[
			Position[
				sortedPositionNames,
				contentsLookup[#, Position]
			]
		]&
	];

	(* Find contents that occupy positions that are undefined in the container model.
	These must be excluded because they cannot be plotted.
	This will also catch contents that have Position->Null. *)
	invalidPositionContents = Cases[
		sortedNextLevelContents,
		Alternatives[
			KeyValuePattern[Position -> Except[Alternatives@@sortedPositionNames]],
			Rule[KeyValuePattern[Position -> Except[Alternatives@@sortedPositionNames]], _]
		]
	];

	(* Report any cases in which Null or nonexistent positions are found *)
	With[{fh = OptionValue[FunctionHead]}, If[Length[invalidPositionContents]>0, Message[fh::InvalidPosition, contentsLookup[invalidPositionContents, {Object, Position}]]]];

	(* Find and eliminate next-level contents that don't have positions *)
	fixedNextLevelContents = DeleteCases[sortedNextLevelContents, Alternatives@@invalidPositionContents];

	(* Look up positions occupied by next level contents *)
	sortedNextLevelContentsPositionNames = Map[
		contentsLookup[#, Position]&,
		fixedNextLevelContents
	];

	(* Look up rotation of position occupied by each next level contents *)
	sortedNextLevelContentsRotations = Map[
		sortedPositionRotations[[Position[sortedPositionNames, #][[1,1]]]]&,
		sortedNextLevelContentsPositionNames
	];

	(* Look up offset anchor point of position occupied by each next level contents *)
	sortedNextLevelContentsAnchors = Map[
		sortedPositionOffsetAnchorPoints[[Position[sortedPositionNames, #][[1,1]]]]&,
		sortedNextLevelContentsPositionNames
	];

	combinedPrimitives = If[OptionValue[PositionTooltips],
		{outlineGraphic, positionPrimitives},
		{positionPrimitives, outlineGraphic}
	];

	(* Put the above primitives together in the ideal layering order, from bottom to top *)
	GraphicsGroup[{

		combinedPrimitives,

		(* Run containerAndPositionGraphics again on the contents of this level *)
		MapThread[
			Function[
				{contentsItem, posName, rotation, anchorPt},
				containerAndPositionGraphics[
					contentsItem,
					anchorPt,
					addRotation[myRotations,rotation,anchorPt,plot3DBool],
					myIterationNumber + 1,
					Sequence@@opsList
				]
			],
			{fixedNextLevelContents, sortedNextLevelContentsPositionNames, sortedNextLevelContentsRotations, sortedNextLevelContentsAnchors}
		]
	}]

];

(* If we run into a vessel, just plot the bare object even if it has contents *)
containerAndPositionGraphics[Rule[ctr:PacketP[Object[Container,Vessel]],cont__],offsetAnchorPoint_List,allRotations_List,myIterationNumber:GreaterP[0,1],ops:OptionsPattern[]] := containerAndPositionGraphics[ctr,offsetAnchorPoint,allRotations,myIterationNumber,ops];
(* If we run into a bare sample, don't plot anything *)
containerAndPositionGraphics[samp:PacketP[LocationNonContainerTypes] | Rule[PacketP[{Object[Sample], Object[Part], Object[Sensor],Object[Plumbing],Object[Wiring],Object[Item]}],_],offsetAnchorPoint_List,allRotations_List,myIterationNumber:GreaterP[0,1],ops:OptionsPattern[]] := {};
(* If we run into an empty list, don't plot anything *)
containerAndPositionGraphics[{},___] := {};

(* Assemble a plotContainer call that will be executed if any of this object's primitives are clicked *)
assembleClickFunction[focalObject:(ObjectP[] | {ObjectP[], _String}),highlightOption_,functionHead_Symbol] := With[
	{focObj=focalObject, highlight=highlightOption, func=functionHead},

	Hold[
		CellPrint[Cell[BoxForm[MakeBoxes[func[focObj, LevelsUp->0, LevelsDown->1, Highlight->highlight]]],"Input"]];
		CellPrint[ExpressionCell[func[focObj, LevelsUp->0, LevelsDown->1, Highlight->highlight],"Output"]]
	]

];


(* ::Subsubsection::Closed:: *)
(*choosePlotStyles*)


(* Determines style options to be used for different plot elements depending on plot dimensionality (2D or 3D) and shading option *)
(* Returns a list of {containerStyle, positionStyle, highlightStyle} *)
choosePlotStyles[safeOps:OptionsPattern[]] := Module[
	{plot3DBool, defaultCtrStyle, defaultPosStyle, defaultHighlightStyle},

	(* Plotting in 2D or 3D? *)
	plot3DBool = MatchQ[PlotType/.safeOps,Plot3D];

	(* Choose container, position, and highlight styles appropriate to the plot dimensionality *)
	{defaultCtrStyle, defaultPosStyle, defaultHighlightStyle} = Switch[plot3DBool,
		True,
			{
				{EdgeForm[{Black,Thickness[0.002]}],FaceForm[{Opacity[1],LightGray}]},
				{EdgeForm[{Gray,Dashing[{0.01, 0.005}],Thickness[0.002]}],FaceForm[{LightGray,Opacity[1]}]},
				{Darker[Green],Thickness[0.005]}
			},
		False,
			{
				{EdgeForm[{Thickness[0.002],Black}],FaceForm[{Opacity[0.6],LightGray}]},
				{EdgeForm[{Black,Dashing[{0.005, 0.005}],Thickness[0.002],Opacity[0.4]}],FaceForm[{LightGray,Opacity[0]}]},
				{EdgeForm[{Darker[Green],Thickness[0.005]}]}
			}
	];

	(* For any of the Style options that are set to Automatic, replace with the styles chosen above *)
	(* Any Style options that have been manually specified will be left alone *)
	{
		If[MatchQ[Lookup[safeOps, ContainerStyle], Automatic], defaultCtrStyle, Lookup[safeOps, ContainerStyle]],
		If[MatchQ[Lookup[safeOps, PositionStyle], Automatic], defaultPosStyle, Lookup[safeOps, PositionStyle]],
		If[MatchQ[Lookup[safeOps, HighlightStyle], Automatic], defaultHighlightStyle, Lookup[safeOps, HighlightStyle]]
	}

];


(* ::Subsubsection::Closed:: *)
(*convertToTree*)


(* Takes in a flat adjacency list and converts it into a nested list of rules in the form {rootCtr -> {contentsLvl1 -> {contentsLvl2->...}}} *)
(* This nested rule format is used by plotContainer to traverse the container tree recursively while passing on only the relevant contents to each recursion *)
convertToTree[gr_Graph] := convertToTree[ReplaceAll[EdgeList[gr], DirectedEdge->Rule]];
convertToTree[ruleList:{_Rule}] := {convertToTree[ruleList[[1,1]], ruleList]};
convertToTree[ruleList:{_Rule..}] := Module[
    {allLHS=DeleteDuplicates[ruleList[[All,1]]],allRHS=DeleteDuplicates[Flatten[ruleList[[All,2]]]],topNode,locTree},
    topNode = First[Complement[allLHS,allRHS]];
    {convertToTree[topNode,ruleList]}
];
(* Recursive function that does the building *)
convertToTree[node_,ruleList_] := Module[
    {childNodes},
    childNodes = Cases[ruleList,(Rule[node,rhs_]:>rhs)];
    If[childNodes == {},
        node,
        Rule[node,convertToTree[#,ruleList]&/@childNodes]
    ]
];
convertToTree[{},_] := Nothing;
convertToTree[{}] := {};


(* ::Subsubsection::Closed:: *)
(*anchorOffsets*)


(* Given coordinates for the bottom left corner of a container, calculates the absolute center anchor point of a position 'pos' within that container *)
anchorOffsets[pos:{__Rule},currentBottomLeftCorner:{_,_,_},unitScalar_] := Module[{anchorPt=Unitless[AnchorPoint/.pos],dims=Unitless[Dimensions/.pos]},
	currentBottomLeftCorner + (anchorPt * unitScalar)
];


(* ::Subsubsection::Closed:: *)
(*bottomLeftCorner*)


(* Given the center anchor point for an item (a container or position) and the item's dimensions, calculates the coordinates of the item's bottom left corner *)
bottomLeftCorner[containerModelInfo_,offsetAnchorPoint_,unitScalar_] := Module[
	{dimX, dimY, dimZ},

	(* Pull dimensions from packet *)
	{dimX, dimY, dimZ} = Unitless[Lookup[containerModelInfo, Dimensions]];

	(* Find item's bottom left corner by subtracting half-x and -y values from anchor point, which is in the center of the item *)
	offsetAnchorPoint - {dimX/2, dimY/2, 0} * unitScalar
];
bottomLeftCorner[dimX_,dimY_,offsetAnchorPoint_,unitScalar_] := offsetAnchorPoint - ({dimX/2,dimY/2,0} * unitScalar);


(* ::Subsubsection::Closed:: *)
(*assembleTooltip*)


(* Used for plotting of containers *)
assembleTooltip[ctr_,pos_String,delay:NumberP] := {Grid[{{Row[{ctr,", ",pos}]},{"Empty"}}],TooltipDelay->delay};
assembleTooltip[ctr_,pos_String,samp_,delay:NumberP] := {Grid[{{Row[{ctr,", ",pos}]},{Row[{"Contents: ",samp/.{}->"Empty"}]}}],TooltipDelay->delay};

(* Used for plotting of modelContainers *)
assembleTooltip[pos:{__Rule}] := {Row[{"Position: ",(Name/.pos)}],TooltipDelay->0.2};
assembleTooltip[ctrModelObj:PacketP[LocationContainerModelTypes]] := {ToString[ctrModelObj],TooltipDelay->0.2};

(* If passed a container info packet, display a column of Name,Object *)
(* For SLL3, replaced StickerName with just Name *)
assembleTooltip[ctrInfo:PacketP[LocationTypes],delay_] := {Column[{Name,Object}/.ctrInfo,Alignment->Center],TooltipDelay->delay};

(* Replacement for container info packet overload; display a column of Name,Object *)
assembleTooltip[obj:ObjectReferenceP[LocationTypes],name_String,delay_] := {Column[{name,obj},Alignment->Center],TooltipDelay->delay};


(* ::Subsubsection::Closed:: *)
(*containerPrimitive*)


DefineOptions[containerPrimitive,
	Options:>{
		{Tooltip->Null,_,"Tooltip options for labeling of this graphics primitive."},
		{Style->{EdgeForm[Black],FaceForm[{Opacity[0.2],LightGray}]},ListableP[EdgeForm[ListableP[EdgeFormP]]|FaceForm[ListableP[FaceFormP]]|EdgeFormP],"The EdgeForm and/or FaceForm for this beast."},
		{UnitScalar->1,_?NumericQ,"The scalar that will be used to Convert the container's dimensions to the dimensions of the parent plot."},
		{Object->Null,Null|ObjectReferenceP[],"The Object for which this primitive is being drawn, if any (this may be getting drawn for a modelContainer)."},
		{ClickFunction->Null,_,"The function that will be executed when the output primitive is clicked."}
	},
	SharedOptions:>{
		plotContainer
	}
];

(* Generate a graphics primitive for the physical footprint of a container or instrument *)
containerPrimitive[myPacket:PacketP[Join[LocationContainerTypes, LocationContainerModelTypes]],offsetAnchorPoint:{_?NumericQ,_?NumericQ,_?NumericQ},allRotations_List,ops:OptionsPattern[]] := Module[
	{modelObj, ctrObj, plot3DBool, scalar, style, tooltip, shape, shape2D, shape2DScaled,
	shape3D, shape3DScaled, modelDimsScaled, containerBottomLeftCorner, rectangleCorners, cuboidCorners,
	cylinderBottomCenter, cylinderTopCenter, cylinderRadius, diskXY, prim, tooltipPrim, mouseoverPrim, formattedPrim},

	modelObj = Lookup[myPacket, Model];
	ctrObj = Lookup[myPacket, Object];

	plot3DBool = MatchQ[OptionValue[PlotType],Plot3D];
	scalar = OptionValue[UnitScalar];
	style = OptionValue[Style];
	tooltip = OptionValue[Tooltip];

	(* Extract shape-related information from the packet; scale predefined shape primitives if they exist *)
	shape = Lookup[myPacket, CrossSectionalShape];
	shape2D = Lookup[myPacket, Shape2D, Null];
	shape2DScaled = If[!NullQ[shape2D],scalePrimitive[#,scalar]&/@shape2D];
	shape3D = Lookup[myPacket, Shape3D, Null];
	shape3DScaled = If[!NullQ[shape3D],scalePrimitive[#,scalar]&/@shape3D];
	(* scale a mesh by 1/1000 because we want the output units to be in meters, and meshes are usually saved in millimeters *)
	shape3D=If[MatchQ[shape3D,_MeshRegion|{_MeshRegion}],Scale[FirstOrDefault[shape3D,shape3D],0.001,{0,0,0}],shape3D];
	(* If container has zero height, add a small amount of height so that it plots visibly in 3D *)
	modelDimsScaled = (Unitless[Lookup[myPacket, Dimensions]] /. {x_,y_,0|0.}:>{x,y,0.01}) * scalar;
	(* Find the coordinates of the bottom left corner of this container *)
	containerBottomLeftCorner = bottomLeftCorner[myPacket,offsetAnchorPoint,scalar];

	(* Calculate relevant points for 2D and 3D plots of various shapes *)
	rectangleCorners = {
		containerBottomLeftCorner[[;;2]],
		containerBottomLeftCorner[[;;2]] + modelDimsScaled[[;;2]]
	};
	cuboidCorners = {
		containerBottomLeftCorner,
		containerBottomLeftCorner + modelDimsScaled
	};
	cylinderBottomCenter = offsetAnchorPoint;
	cylinderTopCenter = offsetAnchorPoint + {0,0,modelDimsScaled[[3]]};
	cylinderRadius = modelDimsScaled[[1]]/2;
	diskXY={modelDimsScaled[[1]]/2,modelDimsScaled[[2]]/2};

	(* Generate the appropriate primitive *)
	prim = Switch[{shape,plot3DBool},
		(* 3D plot, circular cross section *)
		{Circle, True},
			{
				(* if a custom 3d shape is defined, then plot it *)
				If[!NullQ[shape3D],
					Translate[{EdgeForm[],shape3D},offsetAnchorPoint],
					Nothing
				],
				(* If this is a bottom-level sample container, plot opaque; otherwise, plot translucent *)
				FaceForm[Opacity[If[MatchQ[ctrObj,ObjectReferenceP[{Object[Container,Plate],Object[Container,Vessel]}]],1.0,0.2]]],
				Cylinder[{cylinderBottomCenter,cylinderTopCenter},cylinderRadius]
			},
		(* 2D plot, circular cross section *)
		{Circle, False},
			{Disk[cylinderBottomCenter[[;;2]],cylinderRadius]},
		(* 3D plot, rectangular cross section *)
		{Rectangle|Null, True},
			{(* if a custom 3d shape is defined, then plot it *)
				If[!NullQ[shape3D],
					Translate[{EdgeForm[],shape3D},offsetAnchorPoint],
					Nothing
				],
				cuboidEdges[Sequence@@cuboidCorners]},
		(* 2D plot, rectangular cross section *)
		{Rectangle|Null, False},
			{If[!NullQ[shape2D],
				(* If a custom shape has been defined in the Shape2D field, offset it appropriately and use it *)
				(* Add a {Thin,Black} directive to color custom shapes differently *)
				Insert[offsetPrimitive2D[#,containerBottomLeftCorner[[;;2]]]& /@ shape2DScaled, GrayLevel[0.3],2],
				(* If no custom shape has been defined, plot as a rectangle *)
				Rectangle[Sequence@@rectangleCorners]
			]},
		(* 2D plot, circular cross section *)
		{Oval, False},
			{Disk[cylinderBottomCenter[[;;2]],diskXY]}
	];

	(* Add a tooltip if specified *)
	tooltipPrim = If[!NullQ[tooltip],
		Tooltip[applyRotation[prim,allRotations],Sequence@@tooltip],
		applyRotation[prim,allRotations]
	];

	(* If LiveDisplay->True and a 2D plot is being drawn, add a Mouseover behavior to highlight container *)
	mouseoverPrim = If[OptionValue[LiveDisplay] && !plot3DBool,
		Mouseover[{Sequence@@style,tooltipPrim}, {Sequence@@style, EdgeForm[{Thickness[0.005],Red}], tooltipPrim}],
		{Sequence@@style,tooltipPrim}
	];

	If[!NullQ[OptionValue[ClickFunction]],
		addClickEvent[mouseoverPrim, OptionValue[ClickFunction]],
		mouseoverPrim
	]

];

(* Handle input that does not have offset anchor point or rotation information *)
containerPrimitive[item_, ops:OptionsPattern[]] := containerPrimitive[item,{0,0,0},0,ops];

(* If passed an item that isn't a location-compatible container or model, return an empty list *)
containerPrimitive[item_, anchorPt_, rotation_, ___] := {};


(* ::Subsubsection::Closed:: *)
(*positionPrimitive*)


DefineOptions[positionPrimitive,
	Options:>{
		{Tooltip->Null,_,"Tooltip options for labeling of this graphics primitive."},
		{Style->{EdgeForm[Black],FaceForm[{Opacity[0.2],LightGray}]},ListableP[EdgeForm[ListableP[EdgeFormP]]|FaceForm[ListableP[FaceFormP]]|EdgeFormP],"The EdgeForm and/or FaceForm for this beast."},
		{Empty->False,BooleanP,"An 'X' will be drawn through the position if Empty->True."},
		{UnitScalar->1,_?NumericQ,"The scalar that will be used to convert the container's dimensions to the dimensions of the parent plot."},
		{Object->Null,Null|ObjectReferenceP[LocationContainerTypes],"The Object that will be \"selected\" when this primitive is clicked."},
		{ClickFunction->Null,_,"The function that will be executed when the output primitive is clicked."}
	},
	SharedOptions:>{
		plotContainer
	}
];


(* Generate a graphics primitive for a position within a container *)
positionPrimitive[pos:{__Rule},posUnit_?UnitsQ,offsetAnchorPoint:{_?NumericQ,_?NumericQ,_?NumericQ},allRotations_List,ops:OptionsPattern[]] := Module[
	{ctrObj, posName, plot3DBool, scalar, style, tooltip, shape, shape2D, shape2DScaled,
	shape3D, shape3DScaled, dims, dims2D, xyCenter, anchor2D, positionBottomLeftCorner2D,
	positionBottomLeftCorner3D, positionTopRightCorner2D, positionTopRightCorner3D,
	prim, tooltipPrim, mouseoverPrim, primLabeled},

	ctrObj = OptionValue[Object];
	posName = Lookup[pos, Name];

	(* Extract relevant option values *)
	plot3DBool = MatchQ[OptionValue[PlotType],Plot3D];
	scalar = OptionValue[UnitScalar];
	style = OptionValue[Style];
	tooltip = OptionValue[Tooltip];

	(* Extract shape-related information from the packet; scale predefined shape primitives if they exist *)
	shape = Lookup[pos, CrossSectionalShape];
	shape2D = Lookup[pos, Shape2D, Null];
	shape2DScaled = If[!NullQ[shape2D],Polygon[First[shape2D]*scalar]];
	shape3D = Lookup[pos, Shape3D, Null];
	shape3DScaled = If[!NullQ[shape3D],Polygon[First[shape2D]*scalar]];

	(* Scale position dimensions and calculate other important coordinates *)
	dims = Unitless[Lookup[pos, Dimensions]] * scalar;
	dims2D = dims[[;;2]];
	xyCenter = dims2D/2;
	anchor2D = offsetAnchorPoint[[;;2]];



	(* Plot all positions as 2-dimensional *)
	dims = {dims[[1]],dims[[2]],0.0001};

	(* Calculate relevant points for 2D and 3D plots *)
	positionBottomLeftCorner2D = anchor2D-(xyCenter);
	positionBottomLeftCorner3D = offsetAnchorPoint-Append[xyCenter,0];
	positionTopRightCorner2D = anchor2D+(xyCenter);
	positionTopRightCorner3D = offsetAnchorPoint+Append[xyCenter,dims[[3]]];

	prim = Switch[{shape, plot3DBool},
		(* 3D plot, circular cross section *)
		{Circle, True},
			{Cylinder[{offsetAnchorPoint, offsetAnchorPoint+{0,0,dims[[3]]}}, dims[[1]] / 2]},
		(* 2D plot, circular cross section *)
		{Circle, False},
			{Disk[anchor2D, xyCenter]},
		(* 3D plot, rectangular cross section *)
		{Rectangle, True},
			{Cuboid[positionBottomLeftCorner3D, positionTopRightCorner3D]},
		(* 2D plot, rectangular cross section *)
		{Rectangle, False},
			{If[!NullQ[shape2D],
				offsetPolygon[shape2DScaled,Table[positionBottomLeftCorner2D,{Length[First[shape2D]]}]],
				Rectangle[positionBottomLeftCorner2D, positionTopRightCorner2D]
			]},
		(*2D plot, oval*)
		{Oval,False},
			{Disk[anchor2D, xyCenter]}
	];

	(* Add a tooltip if specified *)
	tooltipPrim = If[!NullQ[tooltip],
		{Tooltip[applyRotation[prim,allRotations],Sequence@@tooltip]},
		{applyRotation[prim,allRotations]}
	];

	(* Add a label to the middle of the position primitive if specified *)
	primLabeled = If[OptionValue[LabelPositions],
		Append[tooltipPrim,Text[posName,anchor2D]],
		tooltipPrim
	];

	mouseoverPrim = If[OptionValue[LiveDisplay] && !plot3DBool,
			Mouseover[{Sequence@@style,primLabeled}, {Sequence@@style, EdgeForm[{Opacity[1],Red}], primLabeled}],
			{Sequence@@style,primLabeled}
	];

	If[!NullQ[OptionValue[ClickFunction]],
		addClickEvent[mouseoverPrim, OptionValue[ClickFunction]],
		mouseoverPrim
	]

];


(* ::Subsubsection::Closed:: *)
(*Graphics primitive formatting, translation, scaling, and rotation*)


(* Given an Polygon primitive and a set of offset coordinates, translate the polygon's coordinates by 'offsets' *)
offsetPolygon[poly_Polygon,offsets_List] := Polygon[First[poly]+offsets];


(* Given a graphics primitive containing one or more pairs or triplets of coordinates, translate all coordinates by 'offset' *)
offsetPrimitive2D[prim_,offset:{Repeated[NumberP,{2}]}] := ReplaceAll[prim, coord:{Repeated[NumberP,{2}]} :> (coord+offset)];
offsetPrimitive2D[prim_,offset:{Repeated[NumberP,{3}]}] := ReplaceAll[prim, coord:{Repeated[NumberP,{3}]} :> (coord+offset)];
offsetPrimitive2D[prim_ {Repeated[0|0., {2,3}]}] := prim;


(* If scalar is 1, return the primitive unchanged *)
scalePrimitive[prim_, 1] := prim;
(* Handle arcs specifically because their center and radius must be scaled, but arc specification must not *)
scalePrimitive[Circle[center_List, radius:NumberP, arcRange_], scalar:NumberP] := Circle[center*scalar, radius*scalar, arcRange];
(* Given a GraphicsComplex of primitives, scale all coordinates in the internal primitives by 'scalar' *)
scalePrimitive[cplx_GraphicsComplex,scalar:NumberP] := GraphicsComplex[
	ReplaceAll[First[cplx], n:NumberP :> n*scalar],
	Sequence@@Rest[cplx]
];
(* Given a graphics primitive containing one or more pairs or triplets of coordinates, scale all coordinates by 'scalar' *)
scalePrimitive[prim_,scalar:NumberP] := ReplaceAll[prim, coord:{Repeated[NumberP, {2,3}]} :> coord*scalar];



(* Add a rotation function to an existing list of rotation functions *)
addRotation[rotList_List,curRot:NumericP,newAnch_,plot3DBool:BooleanP] := If[curRot!=0,
	Append[
		rotList,
		Function[prim,rotate2D3D[prim,curRot,newAnch,plot3DBool]]
	],
	rotList
];


(* Rotates a primitive or set of primitives in either 2 or 3 dimensions *)
rotate2D3D[prims_,rot:NumberP,rotationCtr_,plot3DBool:BooleanP] := Rotate[
	prims,
	rot Degree,
	If[plot3DBool,
		Unevaluated[Sequence[{0,0,1},rotationCtr]],
		Unevaluated[Sequence[rotationCtr[[;;2]]]]
	]
];
rotate2D3D[prims_,0,rotationCtr_,plot3DBool:BooleanP] := prims;


(* Given a Graphics primitive 'prim' and a list of rotation pure functions 'rotList', applies them sequentially from beginning to end *)
applyRotation[prim_,rotList_List] := applyRotation[Last[rotList][prim],Most[rotList]];
applyRotation[prim_,{}] := prim;


(* Adds an event handler to run a piece of code when an item is clicked *)
addClickEvent[item_, functionCall_Hold] := MouseAppearance[
	EventHandler[
		item,
		{"MouseClicked":> ReleaseHold[functionCall]},
		PassEventsUp->True,
		PassEventsDown->False,
		Method->"Queued"
	],
	"LinkHand"
];



(* Give type-specific colors to container outlines to make the map more readable *)
containerColor[myPacket:PacketP[],myPlot3DBool:BooleanP] := Switch[Lookup[myPacket, Type],
	Object[Container,Bench], Gray,
	Object[Container,Shelf], Gray,
	Object[Container,Room], If[myPlot3DBool, Nothing, Lighter[LightGray]],
	Object[Container,FlammableCabinet], Lighter[Lighter[Yellow]],
	Object[Instrument,__], Lighter[Lighter[Blue]],
	Object[Container,WasteBin], Lighter[Brown],
	Object[Sample,__], Green,
	_, LightGray
];


(* ::Subsubsection::Closed:: *)
(*cuboidEdges*)


(* Builds a GraphicsComplex comprising only the edges of a Cuboid (no faces) with the specified corner coordinates *)
(* This allows for Tooltips / Mouseovers to remain accessible when plotting cuboidal items that contain other items *)
cuboidEdges[corner1:{Repeated[_?NumericQ,3]},corner2:{Repeated[_?NumericQ,3]}]:= Module[
	{x1,x2,y1,y2,z1,z2},

	{x1,y1,z1} = corner1;
	{x2,y2,z2} = corner2;

	GraphicsComplex[
		{
			{x1,y1,z1},{x2,y1,z1},{x2,y2,z1},{x1,y2,z1},{x1,y1,z2},{x1,y2,z2},{x2,y1,z2},{x2,y2,z2}
		},
		Line[{1,2,3,4,1,5,6,8,7,5,6,4,3,8,7,2}]
	]

];


(* ::Subsubsection::Closed:: *)
(*rectangleEdges*)


rectangleEdges[corner1:{Repeated[_?NumericQ,2]},corner2:{Repeated[_?NumericQ,2]}] := Module[
	{x1, x2, y1, y2},

	{x1, y1} = corner1;
	{x2, y2} = corner2;

	GraphicsComplex[
		{
			{x1, y1}, {x1, y2}, {x2, y2}, {x2, y1}
		},
		Line[{1, 2, 3, 4, 1}]
	]

];


(* ::Subsubsection::Closed:: *)
(*circlePolygon*)


(* Helper to Convert a circle into an inscribed n-gon *)
(* Empirically, >99% of the circle's area is covered by the n-gon when n>25, independent of radius; 99.9% when n>81 *)
circlePolygon[center_,radius_,numberOfPoints_Integer] := Module[
	{thetaIncrement,thetaList,points,pairs},

	(* Figure out the number of equally-sized pie pieces into which the circle will be split *)
	thetaIncrement = (2*Pi)/numberOfPoints;

	(* Make a list of the angles that define those pie pieces *)
	thetaList = Table[i*thetaIncrement,{i,1,numberOfPoints}];

	(* Define the points at which the rays defined by those angles intersect the circle *)
	points = (center+{radius*Cos[#],radius*Sin[#]})&/@thetaList;

	(* Assemble the points into a polygon *)
	Polygon[points]
];

(* If no number of sides is specified, default to 30 *)
circlePolygon[center_,radius_] := circlePolygon[center,radius,30];

(* If given a Circle with a center and a radius, call circlePolygon with those inputs arranged appropriately *)
circlePolygon[Circle[ctr:{_?NumericQ,_?NumericQ},rad_?NumericQ]] := circlePolygon[ctr,rad];


(* ::Subsubsection::Closed:: *)
(*regionEnclosedQ*)


(* Determine whether 'childPoly' is entirely enclosed by 'parentPoly', with the option to specify a nonzero percentage of 'childPoly''s area that does not overlap with 'parentPoly' *)
regionEnclosedQ[parentRegion:_?RegionQ,childRegion:_?RegionQ,allowableNonOverlap_?(And[NumericQ[#],GreaterEqual[#,0]]&)] := Module[
	{polyComp,compArea,areaDiffPct},

	(* Figure out the complement of the child polygon w.r.t. the parent polygon (the stuff in the child that doesn't overlap with the parent) *)
	polyComp = RegionDifference[childRegion,parentRegion];

	(* Calculate the area of the child polygon that falls outside the parent polygon *)
	compArea = If[MatchQ[polyComp,_EmptyRegion],
		0,
		Area[N[polyComp]]
	];

	(* Calculate the percentage of the child polygon compArea represents *)
	areaDiffPct = 100 * (compArea / Area[childRegion]);

	(* Decide whether the child is "enclosed" by the parent, depending on whether 'areaDiffPct' is LessEqual or Greater than the allowable non-overlapping percent area *)
	areaDiffPct <= allowableNonOverlap

];

(* If no error is specified, assume zero is tolerated *)
regionEnclosedQ[parentPoly_?RegionQ,childPoly_?RegionQ] := regionEnclosedQ[parentPoly,childPoly,0];


(* ::Subsubsection::Closed:: *)
(*regionIntersectionQ*)


(* Determine whether 'poly1' intersects with 'poly2', with the option to specify a nonzero percentage of the smaller polygon's area that is allowed to overlap without being considered intersection *)
regionIntersectionQ[region1:_?RegionQ,region2:_?RegionQ,allowableOverlap_?(And[NumericQ[#],GreaterEqual[#,0]]&)] := Module[
	{regionInter,regionInterArea,interPct1,interPct2,interPct},

	(* Calculate the intersection of the two polygons *)
	regionInter = N@RegionIntersection[region1,region2];

	(* Calculate the intersection area *)
	regionInterArea = Area[regionInter];

	(* Calculate the percentage of each input polygon the intersection represents *)
	interPct1 = 100 * (regionInterArea / Area[region1]);
	interPct2 = 100 * (regionInterArea / Area[region2]);

	(* Pick the one that is a larger percentage (biases towards confirming intersection) *)
	interPct = Max[{interPct1,interPct2}];

	(* Decode whehter the two polygons overlap, as defined as greater overlap than the allowable percent overlap  *)
	interPct > allowableOverlap

];

(* If no error is specified, assume zero is tolerated *)
regionIntersectionQ[region1_?RegionQ,region2_?RegionQ] := regionIntersectionQ[region1,region2,0];


(* ::Subsubsection::Closed:: *)
(*rotatePrimitive*)


(* Function for rotating points manually in space (will allow for polygon overlap computations needed in ValidObjectQ[container/modelContainer]) *)
ECL`Authors[rotatePrimitive]:={"ben", "olatunde.olademehin"};
(* Points *)
rotatePrimitive[pt:{NumericP,NumericP},rotationCtr:{NumericP,NumericP},angle:(NumericP|Times[NumericP,Degree])] := Module[
	{rotFcn},
	rotFcn = RotationTransform[angle,rotationCtr];
	rotFcn[pt]
];

(* Polygons and rectangles *)
rotatePrimitive[shape:(_Polygon|_Rectangle),rotationCtr:{NumericP,NumericP},angle:(NumericP|Times[NumericP,Degree])] := Module[
	{rotFcn},
	rotFcn = RotationTransform[angle,rotationCtr];
	shape/.{pt:{NumericP,NumericP}:>rotFcn[pt]}
];

(* Circles and Disks *)
rotatePrimitive[(head:(Circle|Disk))[ctr:{NumericP,NumericP},rest___],rotationCtr:{NumericP,NumericP},angle:(NumericP|Times[NumericP,Degree])] := Module[
	{rotFcn},
	rotFcn = RotationTransform[angle,rotationCtr];
	head[rotFcn[ctr],rest]
];

(* Scale rotation center down to 2D if 3D is supplied *)
rotatePrimitive[shape_,rotationCtr:{NumericP,NumericP,NumericP},angle:(NumericP|Times[NumericP,Degree])] := rotatePrimitive[shape,rotationCtr[[;;2]],angle];


(* ::Subsubsection:: *)
(*generateRegularRackPositions*)


generateRegularRackPositions::DimensionsIncomplete="One or more of the X, Y, and Z dimensions of this modelContainer are missing.";

(* Given a Model[Container,Plate] or Model[Container, Rack], extracts the needed parameters and generates positions *)
generateRegularRackPositions[modelObj:ObjectP[Model[Container]], wellShape:(Circle|Rectangle), wellFootprint:(FootprintP|Null)]:=Module[
	{downloadResult,rackDimensions,wellDimensions,
	wellDimensionZ,wellPitchX,wellPitchY,wellOffsetX,wellOffsetY,wellOffsetZ,numRows,numCols},

	(* Extract Model's dimensions *)
	{rackDimensions,wellDimensions,wellDimensionZ,wellPitchX,wellPitchY,wellOffsetX,wellOffsetY,wellOffsetZ,numRows,numCols} = Download[modelObj,
		{Dimensions,WellDimensions,WellDepth,HorizontalPitch,VerticalPitch,HorizontalMargin,VerticalMargin,DepthMargin,Rows,Columns}
	];

	(* If any of the Model's dimensions are Null, return an error message *)
	If[NullQ[rackDimensions],
		Return[Message[generateRegularRackPositions::DimensionsIncomplete]]
	];

	generateRegularRackPositions[
		numRows,
		numCols,
		Sequence@@rackDimensions,
		Sequence@@wellDimensions,
		wellDimensionZ, (* All positions are given zero height for ease of plotting *)
		wellPitchX,
		wellPitchY,
		wellOffsetX,
		wellOffsetY,
		wellOffsetZ,
		0 Meter,
		wellShape,
		wellFootprint
	]

];

(* Given all needed physical parameters, generates the Positions field for a plate or rack model *)
generateRegularRackPositions[
	numRows_Integer,
	numCols_Integer,
	rackDimensionX_?DistanceQ,
	rackDimensionY_?DistanceQ,
	rackDimensionZ_?DistanceQ,
	wellDimensionX_?DistanceQ,
	wellDimensionY_?DistanceQ,
	wellDimensionZ_?DistanceQ,
	xPitch_?DistanceQ,
	yPitch_?DistanceQ,
	xOffset_?DistanceQ,
	yOffset_?DistanceQ,
	zOffset_?DistanceQ,
	staggerOffset_?DistanceQ, (* this results in a stagger of columns, even columns get +half the stagger, odd get -half the stagger, if you use this option the yPitch need to be to mean of pitch of an even and odd column *)
	wellShape:(Circle|Rectangle),
	footprint:(FootprintP|Null)
] := Module[
	{startX,startY,positionRules,fixedZOffset},

	startX = xOffset+(wellDimensionX/2);
	startY = rackDimensionY-yOffset-(wellDimensionY/2);
	positionRules = MapThread[#1->#2&,{Range[1,26],{"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}}];

	fixedZOffset = If[zOffset<0 Millimeter, 0 Millimeter,zOffset];

	{
		Replace[Positions] -> Join@@Table[
			<|
				Name->StringJoin[row/.positionRules,ToString[col]],
				Footprint->footprint,
				MaxWidth->wellDimensionX,
				MaxDepth->wellDimensionY,
				MaxHeight->(wellDimensionZ /. 0 Millimeter->Null)
			|>,
			{row,1,numRows},
			{col,1,numCols}
		],
		Replace[PositionPlotting] -> Join@@Table[
			<|
				Name->StringJoin[row/.positionRules,ToString[col]],
				Sequence@@If[
					EvenQ[col],
					{XOffset->(startX+(xPitch*(col-1))),YOffset->(startY-(yPitch*(row-1))+(staggerOffset/2)),ZOffset->fixedZOffset},
					{XOffset->(startX+(xPitch*(col-1))),YOffset->(startY-(yPitch*(row-1))-(staggerOffset/2)),ZOffset->fixedZOffset}
				],
				CrossSectionalShape->wellShape,
				Rotation->0
			|>,
			{row,1,numRows},
			{col,1,numCols}
		]
}

];


(* ::Subsection::Closed:: *)
(*ToBarcode*)


(* ::Subsubsection::Closed:: *)
(*ToBarcode*)


ToBarcode[objects:ListableP[ObjectReferenceP[]]]:=Download[objects,ID];


(* ::Subsection::Closed:: *)
(*ToObject*)


(* ::Subsubsection::Closed:: *)
(*ToObject*)


ToObject[barcode:BarcodeP|{BarcodeP...}]:=Object[StringTrim[barcode]];


ToObject[barcodeString:RepeatedBarcodeP]:=ToObject[
	StringSplit[barcodeString]
];