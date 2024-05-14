(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Link display boxes*)


(* ::Subsubsection:: *)
(*MakeBoxes for link buttons*)


temporalLinkIconSmall[]:=Set[
	temporalLinkIconSmall[],
	Import[FileNameJoin[{PackageDirectory["ConstellationViewers`"], "resources", "rewind@0.5x.png"}], "PNG"]
];

temporalLinkIcon[]:=Set[
	temporalLinkIcon[],
	Import[FileNameJoin[{PackageDirectory["ConstellationViewers`"], "resources", "rewind.png"}], "PNG"]
];

printFullOpacity[expr_]:=CellPrint[ExpressionCell[expr, "Print", PrivateCellOptions -> {"ContentsOpacity" -> 1.}]];

linkButton[link:LinkP[{Object[EmeraldCloudFile], Object[UnitOperation]}]]:=
	With[{obj=ToString[Download[link,Object]],
		date=If[MatchQ[link, TemporalLinkP[obj]],
			Last[link],
			None
		]
	},
		Interpretation[
			Button[
				Row[{Mouseover[obj, Style[obj, Underlined], ImageSize -> All]}],
				printFullOpacity[Inspect[link, Date -> date]],
				Appearance -> None,
				BaseStyle -> "EmeraldLink",
				Method -> "Queued"
			],
			link
		]
	];

linkButton[link:Link[obj_, ___]]:=
	With[{date=If[MatchQ[link, TemporalLinkP[obj]],
		TemporalLinkDate[link],
		None]
	},

		Interpretation[
			ActionMenu[ (* Have our super special icon if it is a Temporal Link *)
				If[!MatchQ[date, None],
					Row[{Row[{temporalLinkIconSmall[]}, Alignment -> {Left, Top}], Row[{Mouseover[obj, UnderBar[obj], ImageSize -> All]}, Alignment -> {Left, Bottom}]}, " "],
					Row[{Mouseover[obj, Style[obj, Underlined], ImageSize -> All]}, Alignment -> {Left, Bottom}]
				],
				{
					"Inspect object in page" :> If[date===None,
						printFullOpacity[Inspect[link]],
						printFullOpacity[Inspect[link, Date -> date]]
					],
					"Inspect object in new tab" :> inspectInNewWindow[obj, date],
					"Copy object ID" :> CopyToClipboard[obj]
				},
				Appearance -> None,
				BaseStyle -> "EmeraldLink",
				Method -> "Queued"
			],
			link
		]];

(* CC, put in new tab *)
inspectInNewWindow[obj_, date_]/;MatchQ[$ECLApplication, CommandCenter]:=AppHelpers`Private`postJSON[
	inspectWithDateCallJSON[obj, date]
];
inspectWithDateCallJSON[obj_, date_]:={
	"expr" -> "inspect:"<>ToString[obj, InputForm],
	If[date=!=None,
		"options" -> {"Date" -> ToString[date, InputForm]},
		Nothing
	]
};

(* desktop, put in new window *)
inspectInNewWindow[obj_, date_]:=NotebookEvaluate[
	CreateDocument[
		ExpressionCell[
			If[date===None,
				Defer[Inspect[obj]],
				Defer[Inspect[obj, Date -> date]]
			],
			"Input"]
		],
	InsertResults -> True
];



OnLoad[
	$LinkButtons=True;
	MakeBoxes[link:Except[Link[(Object[EmeraldCloudFile, _String]), ___], Link[(Object[Repeated[_Symbol, {0, 5}], _String] | Model[Repeated[_Symbol, {0, 5}], _String]), ___]], StandardForm]:=
		With[
			{boxes=ToBoxes[linkButton[link]]},
			boxes
		]/;TrueQ[$LinkButtons];

	(* For cloud file links, we don't want to turn the whole blob into a link otherwise the open/import/save/help buttons can't be clicked without clicking the link.
		But, if $LinkButtons is true, we don't want to show the Link head. So just omit the link head in these cases. *)
	MakeBoxes[link:(Link[(Object[EmeraldCloudFile,_String]),___]|Link[(Object[UnitOperation,___,_String]),___]), StandardForm] :=
		With[
			{boxes=ToBoxes[Download[link, Object]]},
			boxes
		]/;TrueQ[$LinkButtons];
];


progressIndicator[]=Row[
	{Constellation`Private`constellationImage[$ConstellationIconSize],
		Spacer[10],
		"Downloading objects from Constellation",
		ProgressIndicator[Appearance -> "Percolate"]
	}];



(* ::Subsubsection:: *)
(*Inspect*)


DefineOptions[Inspect,
	Options :> {
		{
			OptionName -> Date,
			Default -> Automatic,
			Description -> "Indicates which snapshot of the object to view.",
			ResolutionDescription -> "If Automatic, the most up-to-date data for the object will be retrieved.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector -> True],
				Widget[Type -> Enumeration, Pattern :> Alternatives[None]]
			]
		},
		{
			OptionName -> Abstract,
			Default -> False,
			Description -> "Indicates if only the Abstract fields should be displayed.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
		},
		{
			OptionName -> TimeConstraint,
			Default -> 5 * Second,
			Description -> "Any computable fields that take longer than TimeConstraint to evaluate will remain unevaluated.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Second], Units -> Alternatives[Second]]
		},
		{
			OptionName -> Developer,
			Default -> Automatic,
			Description -> "Indicates if Developer fields should be displayed.",
			ResolutionDescription -> "Automatic resolves to True if the current user is a Developer.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Automatic | True | False],
			Category -> "Hidden"
		},
		OutputOption
	}
];

Inspect::TooManyObjects="Inspect can only take a maximum of 10 objects. Please reduce the number of objects and try again.";

Inspect[inputs:ListableP[ObjectP[]], ops:OptionsPattern[Inspect]]:=Module[{},
	(* Disable $OutputNamedObjects temporarily since we do Object ID to Name conversions internally in Inspect *)
	With[
		{
			existingPostFunction=If[MatchQ[$Post, HoldPattern[$Post]],
				None,
				$Post
			]
		},
		$Post=Function[expr,
			If[existingPostFunction === None,
				(
					Unset[$Post];
					expr
				),
				(
					$Post=existingPostFunction;
					Block[{ECL`$OutputNamedObjects=False},
						existingPostFunction[expr]
					]
				)
			]
		]
	];
	inspectWithTime[inputs, ops]
];

inspectByteLimit:=Floor[ByteLimit / 5];

(* --- Object Inspect --- *)
(* Listable version *)
inspectWithTime[myInputs:{ObjectP[]..}, ops:OptionsPattern[Inspect]]:=Module[{safeOps, undownloadedItems, downloadedItems, itemMap, myPackets, date},
	(* Throw an error if too many objects are requested. Current limit is 10 *)
	If[Length[myInputs] > 10,
		Message[Inspect::TooManyObjects];
		Return[$Failed]
	];

	(* Safely extract the options so they fit to pattern definitions *)
	safeOps=SafeOptions[Inspect, ToList[ops]];

	(* Download all the object information into a packet *)
	undownloadedItems=Cases[myInputs, ObjectReferenceP[] | LinkP[]];

	date=Lookup[safeOps, Date];
	date=If[MatchQ[date, Automatic], None, date];

	(* Download all the undownloaded items in one fell swoop *)
	downloadedItems=Quiet[
		Download[undownloadedItems, Date -> date, BigQuantityArrayByteLimit -> inspectByteLimit],
		Download::FieldTooLarge
	];

	(* Generate a map of all undownloaded references to their downloaded packets *)
	itemMap=MapThread[#1 -> #2&, {undownloadedItems, downloadedItems}];

	(* Swap the downloaded packets into the list of myInputs using the map *)
	myPackets=If[MatchQ[#, PacketP[]], #, # /. itemMap]& /@ myInputs;

	(* Map Inspect over the packets with the shared options*)
	Inspect[#, safeOps]& /@ myPackets
];

inspectWithTime[myInput:ObjectP[], ops:OptionsPattern[Inspect]]:=Module[
	{safeOps, output, initialDate, developerOption, resolvedOps, inspectPreview, inspectResult, myPacket},

	(* Warn the user if they are not logged into Constellation *)
	If[!TrueQ[Constellation`Private`loggedInQ[]], Return["Not Logged In. Please Login and Re-evaluate"]];

	(* Safely extract the options so they fit to pattern definitions *)
	safeOps=SafeOptions[Inspect, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps, Output];

	(*** Inspect Option Resolution ***)

	(*  Only overload the Date on a temporal link if Automatic is specified. If some other date is specified (including None=<->Now) then use that date *)
	initialDate=Lookup[safeOps, Date];
	initialDate=If[MatchQ[myInput, TemporalLinkP[] && MatchQ[initialDate, Automatic]], TemporalLinkDate[myInput], initialDate];
	initialDate=If[MatchQ[initialDate, Automatic], None, initialDate];

	(* TODO: remove this as the developer option is not used *)
	developerOption=If[BooleanQ[Developer /. safeOps],
		Developer /. safeOps,
		MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]] && !MatchQ[$PersonID, Object[User, Emerald, Developer, "id:3em6ZvLJ6Dl7"]]
	];
	(* Update the resolved options *)
	resolvedOps=ReplaceRule[safeOps,
		{
			Date -> initialDate,
			Developer -> developerOption
		}
	];

	(* Download all the object information into a packet *)
	myPacket=Switch[myInput,
		PacketP[], myInput,
		TemporalLinkP[], Quiet[Download[myInput, Date -> initialDate, BigQuantityArrayByteLimit -> inspectByteLimit], Download::FieldTooLarge],
		_, Quiet[Download[myInput, Date -> initialDate, BigQuantityArrayByteLimit -> inspectByteLimit], Download::FieldTooLarge]
	];

	(* If the ID is bad exit with failed *)
	If[MatchQ[myPacket, $Failed], Return[$Failed]];

	(* Generate the preview if requested. Preview is the inspect output with Abstract forced to True *)
	inspectPreview=If[MemberQ[ToList[output], Preview],
		inspectWithTimeDynamicComponent[myPacket, initialDate, ReplaceRule[resolvedOps, {Abstract -> True}]] /. {
			(* Replace the Plot Title *)
			Set[ConstellationViewers`Private`formattedTitle, {{Item[x_, itemFormat:___], r1:___}, r2:__}] :> Set[
				ConstellationViewers`Private`formattedTitle,
				{{Item[Style["[PREVIEW] "<>First[x], Bold, Rule[FontFamily, "Helvetica"], Rule[FontSize, 14], Red], itemFormat], r1}, r2}
			]
		},
		Null
	];

	(* Generate the preview if requested. Preview is the inspect output with Abstract forced to True *)
	inspectResult=If[MemberQ[ToList[output], Result],
		inspectWithTimeDynamicComponent[myPacket, initialDate, ops],
		Null
	];

	(* Return the result, according to the output option. *)
	output /. {
		Result -> inspectResult,
		Preview -> Pane[inspectPreview /. {Rule[ItemSize, _] :> Rule[ItemSize, Scaled[0.5]]}, ImageSize -> {Full, 300}, Scrollbars -> {False, True}, Alignment -> Center],
		Tests -> {},
		Options -> resolvedOps
	}
];

inspectWithTimeDynamicComponent[initialPacket:PacketP[], date_, ops:OptionsPattern[Inspect]]:=DynamicModule[
	{myObject, myType, outputCell, formattedTitle, initialDate, dateDropDown, currentDateString, sortedDateStrings, safeOps},

	(* Pull out the type and object ID from the packet *)
	myObject=initialPacket[Object];
	myType=initialPacket[Type];
	initialDate=If[MatchQ[date, None], Now, date];
	currentDateString=TwelveHourDateString[initialDate];
	safeOps=SafeOptions[Inspect, ToList[ops]];

	dateDropDown="";
	(* Generate dynamic dropdown menu *)
	sortedDateStrings=getSortedDateStrings[myObject];
	(* If Object Log fails for some reason, skip this step of generating the drop down*)
	dateDropDown=If[!MatchQ[sortedDateStrings, $Failed],
		ActionMenu[currentDateString,
			# :> If[TrueQ[Constellation`Private`loggedInQ[]],
				(
					outputCell=If[MatchQ[#, "Present"],
						inspectWithTimeDynamicComponent[Quiet[Download[myObject, Date -> None, BigQuantityArrayByteLimit -> inspectByteLimit], Download::FieldTooLarge], None],
						inspectWithTimeDynamicComponent[Quiet[Download[myObject, Date -> DateObject[#], BigQuantityArrayByteLimit -> inspectByteLimit], Download::FieldTooLarge], DateObject[#]]
					];
					CellPrint[ExpressionCell[outputCell, "Output"]];
					NotebookDelete[EvaluationCell[]]
				)] & /@ sortedDateStrings,
			Appearance -> "PopupMenu",
			Method -> "Queued"],
		""];

	formattedTitle=formatTitle[myObject, dateDropDown];
	(* Actually render the output *)
	objectPacketToDisplay[initialPacket,
		myObject,
		myType,
		formatTitle[myObject, dateDropDown],
		safeOps]
];

formatTitle[myObject_, dateDropDown_]:={{titleItemStyle[formatObjectText[myObject], Left], titleItemStyle[dateDropDown, Right]}};

getSortedDateStrings[myObject_]:=Module[{possibleDates, possibleDateStrings},
	possibleDates=Quiet[ObjectLogAssociation[myObject, DatesOnly -> True]];
	If[MatchQ[possibleDates, $Failed] || MatchQ[possibleDates, Null], Return[$Failed]];
	possibleDates=Join[possibleDates, {Now} /. None -> Nothing];
	possibleDateStrings=TwelveHourDateString /@ possibleDates;
	Reverse[Append[SortBy[possibleDateStrings, AbsoluteTime], "Present"]]
];


(*
	TODO: Work in Progress
	We can most definitely
	1. Reduce the Download Calls
	2. Push more of the lifting to the Constellation Side
*)
objectPacketToDisplay[currentPacket:PacketP[], myObject_, myType_, formatedTitle_, safeOps_]:=Module[{developerOption, timeConstraint, evaluatedPacket,
	notnullPacket, developerReadyPacket, displayPacket, bigFields, bigFieldsOfInterest, evaluationButtonsPacket, bigEvaluationsPacket, processedPacket,
	nameCache, sortedPacket, gatheredPacket, categoryList, formatedCategories, formattedGatheredPacket, gridItems, currentPacketFilteredKeys,
	currentPacketFilteredKeysKey, calculatedComputables, currentDate, favorites},

	(* Resolve the Developer option. If an option is specified, use that option, otherwise resolve based on $PersonID. *)
	(* Specifically turn Frezza's developer default off so he can do demonstration displays as a normal user *)
	developerOption=If[BooleanQ[Developer /. safeOps],
		Developer /. safeOps,
		MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]] && !MatchQ[$PersonID, Object[User, Emerald, Developer, "id:3em6ZvLJ6Dl7"]]
	];
	timeConstraint=Unitless[Lookup[safeOps, TimeConstraint], Second];

	currentDate=Lookup[currentPacket, DownloadDate, None];

	(* Drop DownloadDate as it is not a really field on the object *)
	(* Drop CommandCenterActivityHistory as it is used for internal analysis only and shouldn't show up for any user *)
	currentPacketFilteredKeysKey=KeyDrop[currentPacket, {DownloadDate, CommandCenterActivityHistory}];

	(* evaluate computable fields in batch as many as we can *)
	calculatedComputables=calculateComputables[currentPacketFilteredKeysKey, timeConstraint];
	currentPacketFilteredKeys=<|currentPacketFilteredKeysKey, calculatedComputables|>;

	(* Continue to grab the computables for the rule-delayed things that got missed / never got resolved *)
	evaluatedPacket=AssociationMap[evaluateField[#, timeConstraint]&, currentPacketFilteredKeys];

	(* Gather all the keys and values for non null fields *)
	notnullPacket=Select[evaluatedPacket, !MatchQ[#, NullP | {}]&];

	(* If not Developer, filter out developer fields *)
	developerReadyPacket=If[developerOption, notnullPacket,
		Module[{developerFields},

			(* Determine which fields of the given type are developer fields *)
			developerFields=Keys[Select[ECL`Fields /. LookupTypeDefinition[myType], MemberQ[Last[#], Developer -> True]&]];

			(* Screen out anything in the association that's a developerField *)
			Association[Select[Normal[notnullPacket], !MemberQ[developerFields, First[#]]&]]
		]
	];

	(* If Abstract, filter out non abstract fields *)
	displayPacket=If[!(Abstract /. safeOps), developerReadyPacket,
		Module[{abstractFields},

			(* Determine which fields of the given type are abstract fields *)
			abstractFields=Keys[Select[ECL`Fields /. LookupTypeDefinition[myType], MemberQ[Last[#], Abstract -> True]&]];

			(* Screen out anything in the association that's not a member of the abstract fields *)
			Association[Select[Normal[developerReadyPacket], MemberQ[abstractFields, First[#]]&]]
		]
	];

	(* Pull out the BigQA and BigCompressed field names *)
	bigFields=Keys[Select[ECL`Fields /. LookupTypeDefinition[myType], MemberQ[Last[#], Class -> BigQuantityArray | BigCompressed] &]];
	bigFieldsOfInterest=If[KeyExistsQ[displayPacket, #], #, Nothing]& /@ bigFields;

	(* Replace the BigQA and BigCompressed field values with an evaluate button *)
	evaluationButtonsPacket=AssociationMap[evaluationButton[Lookup[displayPacket, #]] &, bigFieldsOfInterest];
	bigEvaluationsPacket=Join[displayPacket, evaluationButtonsPacket];

	(* Try to convert as many Objects referenced by ID to Objects referenced by Name *)
	nameCache=buildNameCache[bigEvaluationsPacket];

	processedPacket=processCloudFiles[bigEvaluationsPacket];

	(* Sort the fields of the packet in logical order by category and the order in which categories show up *)
	sortedPacket=sortFields[myType, processedPacket];

	sortedPacket=KeyDrop[sortedPacket, DownloadDate];
	(* Break the sorted packet up by category *)
	gatheredPacket=SplitBy[Normal[sortedPacket], (Category /. (First[#] /. (ECL`Fields /. LookupTypeDefinition[myType])))&];

	(* Generate a list of categories for each gathered packet group *)
	categoryList=Category /. (gatheredPacket[[All, 1, 1]] /. (ECL`Fields /. LookupTypeDefinition[myType]));

	(* Compile any favorite object information to add to the Inspect *)
	favorites=generateFavoriteLinks[myObject];

	If[Length[Flatten@favorites] > 0,
		AppendTo[categoryList, "Favorites"];
	];
	(* Format the categories displays for each category *)
	formatedCategories=formatCategory /@ categoryList;

	(* Format the keys and values in each gathered packet *)
	formattedGatheredPacket=formatPacket[#, currentPacketFilteredKeys, myObject, myType, nameCache]& /@ gatheredPacket;

	(* Shuffle the categories back on top of each gathered packet and flatten out the bunch to generate the final list of stuff that goes in the grid *)
	gridItems=Flatten[Riffle[formatedCategories, formattedGatheredPacket], 1];

	(* If number of links exceeds 30, do not render them as link buttons*)
	(* TODO: If we need to suppress links, alternative is to figure out why link buttons harm performance *)
	(*
	gridItemsWithFormattedLinks = If[Length[Cases[gridItems, LinkP[], Infinity]] > 30,
		gridItems /. (x: LinkP[] :> FullForm[x]),
		gridItems
	]; *)
	plotObjectPacket[currentPacketFilteredKeys ,gridItems, formatedTitle, favorites, safeOps]
];

(* Plot the Inspect packet *)
plotObjectPacket[packet_, gridItems_, title_, favorites_, safeOps_]:=Module[{plot, plotItem, favoriteGridItem},
	(* Plot the object being viewed. If Abstract is True or the object is not plottable, the result is Null. *)
	plot=Quiet[If[!Abstract /. safeOps,
		(* if type is model[container] return the cloud file object instead of the raw image to prevent freezing *)
		If[TrueQ[ECL`$CCD],
			PlotObject[packet],
			Staticize[PlotObject[packet]]
		]
	]];

	(* Put the plot into an item with the desired format. If the plot result is Null, the result is an empty list. *)
	plotItem=If[!NullQ[plot],
		{
			{Item[
				plot,
				Alignment -> Center, Frame -> True, FrameStyle -> solidFrame], SpanFromLeft}
		},
		{}
	];

	favoriteGridItem=If[Length[Flatten@favorites] > 0,
		{
			If[Length@FirstOrDefault@favorites[[1]] > 0,
				{formatFavoritesText@"Folders this object can be found in", Item[favorites[[1]], Alignment -> Left, Frame -> {True, None, True, True}, FrameStyle -> solidFrame]},
				Nothing],
			If[Length@FirstOrDefault@favorites[[2]] > 0,
				{formatFavoritesText@"Bookmarks for this object", Item[favorites[[2]], Alignment -> Left, Frame -> {True, None, True, True}, FrameStyle -> solidFrame]},
				Nothing]
		},
		{}
	];

	(* Make the grid *)
	Grid[Join[title, plotItem, gridItems, favoriteGridItem],
		Spacings -> {1, 1},
		Frame -> {True, All},
		FrameStyle -> solidFrame
	]
];

(* Note: This logic is a bit dated because we resolve majority of computable Downloads in Telescope since Fall 2022 *)
(* Set a global time constraint just in case, set to 2x time constraint *)
calculateComputables[packet:PacketP[],timeConstraint:GreaterP[0]]:=TimeConstrained[
	Module[{originalFields, allComputables, allFlattenedRules, objs, nonNullQ, nonNullObjs, requestedFields, values, unflattenedValues, nullList},
	(*
    Large majority of computable fields follow the same pattern.
    MaxColumnLength:>SafeEvaluate[{Download[Object[Instrument,HPLC,id:Y0lXejGKd8oo],Model,Date->None,Verbose->False]},
      Download[Download[Object[Instrument,HPLC,id:Y0lXejGKd8oo],Model,Date->None,Verbose->False],MaxColumnLength]]

    For this batching, we directly ask for Download[Download[Object[Instrument,HPLC,id:Y0lXejGKd8oo],Model,Date->None,Verbose->False],MaxColumnLength].
    We dont worry about SafeEvaluate because
    if Download[Object[Instrument,HPLC,id:Y0lXejGKd8oo],Model,Date->None,Verbose->False]} is Null,
    then the Requested fields will be also be Null [sic].

    The following pattern will capture the object being evaluated:
    object: Download[Object[Instrument,HPLC,id:Y0lXejGKd8oo],Model,Date->None,Verbose->False]]

    And the field that we want off of that object, (MaxColumnLength)
    That way in a batched form we can request
    Download[object, MaxColumnLength]

    We also grab the original field (the thing that appears before :>) in this case MaxColumnLength
    In order to stich the response back to the original packet.

    Original Ordering should all be maintained for the above stitching to be correct
  *)
	allComputables=Cases[
		Normal@packet,
		Alternatives[
			(* Support the traditional computable field pattern *)
			Pattern[
				p,
				RuleDelayed[
					rootFieldName_,
					SafeEvaluate[
						_,
						Download[
							Download[objs2_, fields2_, ___],
							fields3_,
							___
						]
					]
				]
			] :> {Hold[objs2[fields2]] ->Unevaluated[fields3] -> rootFieldName},
			(* Support the new computable field pattern with functions:
         i.e. SafeEvaluate[{Field[PDU], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDU], PDUInstrument]], *)
			Pattern[
				p,
				RuleDelayed[
					rootFieldName_,
					SafeEvaluate[
						_,
						_Symbol[
							___,
							Download[objs2_, fields2_, ___],
							___
						]
					]
				]
			] :> {Hold[objs2[fields2]] -> {} -> rootFieldName}
		]
	];

	(*
     This merge will combine together all the fields for the same objects.
    Hold[Download[x]] -> FieldA
    Hold[Download[x]] -> FieldB
    Hold[Download[y]] -> FieldC

    becomes:
    Hold[Download[x]] -> {FieldA, FieldB}
    Hold[Download[y]] -> {FieldC}
  *)
	allFlattenedRules=Merge[allComputables, Join];
	(* Get the objects to download from *)
	objs=ReleaseHold[Keys[allFlattenedRules]];
	(* If the field to download is Null or {}, no need to go through download *)
	nonNullQ=!MatchQ[#,Null|{}]&/@objs;
	nonNullObjs=PickList[objs,nonNullQ,True];

	(* Remove Null Objects and the corresponding fields since they exit early in download *)
	requestedFields=PickList[Keys@Values[allFlattenedRules],nonNullQ,True];
	unflattenedValues=Download[nonNullObjs, requestedFields, Date -> currentDate, Verbose -> False];
	(* Any Download that returns a pure Null instead of a nested null means the object itself is missing
   So filter these out from both unflattened values and original fields *)
	nullList=NullQ /@ unflattenedValues;
	values=Flatten@Replace[PickList[unflattenedValues, nullList, False],{}->{{}},{1}];
	originalFields=Flatten@PickList[PickList[Values@Values[allFlattenedRules], nonNullQ, True],nullList,False];
	AssociationThread[originalFields -> values]],
	2 * timeConstraint,
	<||>
];

processCloudFiles[packet:KeyValuePattern[{}]]:=Module[{cloudObjects,unitOperationObjects,cloudPackets,unitOperationPackets,cloudPacketLookup,
	unitOperationPacketLookup},
	(* Do a download to get all the cloud file and unit operation packets. *)
	cloudObjects=DeleteDuplicates[Download[Cases[packet,ObjectP[Object[EmeraldCloudFile]],Infinity],Object]];
	unitOperationObjects=DeleteDuplicates[Download[Cases[KeyDrop[packet, UnresolvedOptions], ObjectP[Object[UnitOperation]], Infinity],Object]];

	{cloudPackets, unitOperationPackets}=Flatten/@Download[
		{
			cloudObjects,
			unitOperationObjects
		},
		{
			{Packet[FileName,FileType,CloudFile]},
			{Packet[All]}
		},
		(* NOTE: We need to download ALL of the fields so that we can stich them together in our blob. If we don't send this option, *)
		(* some of the fields won't actually be downloaded and we'll end up mapping Download. *)
		PaginationLength -> 10^15
	];

	cloudPacketLookup=Rule@@@Transpose[{cloudObjects, cloudPackets}];
	unitOperationPacketLookup=Rule@@@Transpose[{unitOperationObjects, unitOperationPackets}];

	(* Make a helper to find the packet for a corresponding cloud object since we don't want to map download *)
	findCloudPacket[object_]:=Lookup[cloudPacketLookup, Download[object, Object]];
	findUnitOperationPacket[object_]:=Lookup[unitOperationPacketLookup, Download[object, Object]];

	(* Convert any cloud file objects in the packet to their corresponding packets. MakeBoxes will take care of doing the display, but this will prevent mapping download. *)
	(* ReplaceAll doesn't work on associations like named singles, so do replace to infinity instead *)
	Replace[
		packet,
		{
			x:LinkP[Object[EmeraldCloudFile]] :> findCloudPacket[x],
			x:LinkP[Object[UnitOperation]] :> findUnitOperationPacket[x]
		},
		Infinity
	]
];

(* For each field in evaluationsPacket that has less than 25 objects, converts the objects into an association containing the Object and the Name *)
buildNameCache[evaluationsPacket:KeyValuePattern[{}]]:=Module[{maxItemsPerValue=25, objectsToName, valuesToConsiderNames, nameCache},
	(* Set up a list to store the named objects *)
	objectsToName={};

	(* If there are quite a bit of numbers items in the Value, don't consider it for name evaluationPacket *)
	valuesToConsiderNames=If[!ListQ[#] || Length[Flatten[#]] < maxItemsPerValue, #, Nothing] & /@ Values[evaluationsPacket];

	(Flatten[valuesToConsiderNames]) /. {
		x:ObjectP[Object[Program, ProcedureEvent]] :> Nothing,
		x:ObjectP[] :> If[MatchQ[x, LinkP[] | ObjectReferenceP[]],
			AppendTo[objectsToName, x],
			AppendTo[objectsToName, Cases[ToList[Sequence @@ x], ObjectP[]]]]
	};

	(* Finally download the Names *)
	nameCache=Quiet[DeleteCases[Download[Flatten[objectsToName], Packet[Name]], KeyValuePattern[Name -> $Failed]], Download::ObjectDoesNotExist];
	If[MatchQ[nameCache,{KeyValuePattern[{Name->_,Object->_}]...}],
		nameCache,
		{}
	]
];

formatObjectText[myInput:ObjectReferenceP[]]:=Module[{objectText},
	(* Format the text in the display *)
	objectText=Style[ToString[myInput], Bold, FontFamily -> "Helvetica", FontSize -> 14, RGBColor["#4A4A4A"]]
];

titleItemStyle[expr_, alignment_]:=Item[expr, Alignment -> alignment, Background -> RGBColor["#CFD3D6"]];

evaluateField[Rule[a_, b_], tmax_]:=Rule[a, b];
evaluateField[RuleDelayed[a_, b_], 0]:=Rule[a, evaluationButton[b]];
evaluateField[RuleDelayed[a_, b_], tmax_]:= Rule[a, TimeConstrained[b, tmax, evaluationButton[b]]];

sortFields[myType_, displayPacket_]:=Module[{mySubtypes, allFields, sortedDatabaseEntries, sortedByCategoryAndDeveloper, sortedFieldNames},

	(* Generate a list of all the subtypes from most general to most specific *)
	mySubtypes=Table[Drop[myType, -i], {i, Length[myType] - 1, 0, -1}];

	(* Generate a list of all the fields building up from most general subtype to most speific *)
	allFields=DeleteDuplicatesBy[Flatten[(ECL`Fields /. LookupTypeDefinition[#])& /@ mySubtypes, 1], First];

	(* Gather the fields in the database entries by category *)
	sortedDatabaseEntries=GatherBy[allFields, Category /. Last[#]&];

	(* Sort the grouped fields so that the Developer fields are at the end of each category. *)
	sortedByCategoryAndDeveloper=Flatten[Map[Function[{fields},
		Join[Select[fields, Not[TrueQ[Developer /. Last[#]]] &],
			Select[fields, Developer /. Last[#] &]]], sortedDatabaseEntries]];

	(* Extract the field names in sorted order from the database entries *)
	(*  Manually add to the order so it always starts {object,type,id,name,model,etc...} *)
	sortedFieldNames=DeleteDuplicates[Join[{Object, Type, ID, Name, Model}, sortedByCategoryAndDeveloper[[All, 1]]]];

	(* Sort the display packet by the keys acording to their order in the sorted field name list *)
	KeySortBy[displayPacket, Position[sortedFieldNames, #]&]
];


formatCategory[myCategory_]:=Module[{text},
	(* Format the text in the display *)
	text=Style[myCategory, Bold, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]];

	(* Return the paired (key,value) for the grid *)
	{{
		Item[text, Alignment -> Left, Frame -> True, FrameStyle -> solidFrame, ItemSize -> {Automatic, 2}, Background -> RGBColor["#E2E4E6"]],
		Item["", Frame -> {True, False, True, True}, FrameStyle -> solidFrame, ItemSize -> {Automatic, 2}, Background -> RGBColor["#E2E4E6"]]
	}}
];

privateLinkIcon[]:=Set[
	privateLinkIcon[],
	Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "private_object.png"}], "PNG"]
];


replaceNameObject[x_, nameCache:{_Association...}]:=With[{name=Lookup[FirstCase[nameCache, KeyValuePattern[{Object -> Quiet[Download[x, Object], Download::ObjectDoesNotExist]}], <||>], Name, Null]},
	Which[
		NullQ[name], x,
		MatchQ[name, $Failed], Tooltip[privateLinkIcon[], "You do not have permissions to view this object.", TooltipStyle -> {Background -> RGBColor["#fffce1"], CellFrameColor -> RGBColor["#d6d5c4"], CellFrame -> 1}],
		True, Append[x[Type], name]
	]
];

replaceNameLink[x_, nameCache:{_Association...}]:=With[{name=Lookup[FirstCase[nameCache, KeyValuePattern[{Object -> Quiet[Download[x, Object], Download::ObjectDoesNotExist]}], <||>], Name, Null]},
	Which[
		NullQ[name], x,
		MatchQ[name, $Failed], Tooltip[privateLinkIcon[], "You do not have permissions to view this object.", TooltipStyle -> {Background -> RGBColor["#fffce1"], CellFrameColor -> RGBColor["#d6d5c4"], CellFrame -> 1}],
		True, Link[Append[x[Type], name], Sequence @@ Rest[x]]
	]
];

(* Strip off the primitive head and association, then do the replacement. *)
replacePrimitive[primitive_, nameCache_]:=With[{primitiveHead=Head[primitive]},
	primitiveHead[
		Association[
			(* Have to convert from Association -> List in order to ReplaceAll. *)
			Normal[primitive[[1]]] /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> replaceNameObject[x, nameCache], x:LinkP[] :> replaceNameLink[x, nameCache]}
		]
	]
];

dashedFrame:=Directive[RGBColor["#90ACBF"], Thickness@1, Dashing[2]];
solidFrame:=Directive[RGBColor["#8E8E8E"], Thickness@1];
(* Format the packet keys and values, and put them in an item. If the key/value pair is the first/last in the packet, the top/bottom frame will be colored to look like the header. Otherwise, they will be framed top and bottom with a dashed line. *)
formatPacket[myPartialPacket_, myPacket_, myObject_, myType_, nameCache:{_Association...}]:=Module[{},
	MapIndexed[{
		Item[formatKey[First[#1], myObject, myType, Last[#1]],
			Alignment -> {Left, Top},
			ItemSize -> {Full, .5},
			Frame -> Which[
				MatchQ[First[#2], 1] && MatchQ[First[#2], Length[myPartialPacket]], {solidFrame, solidFrame, solidFrame, None},
				MatchQ[First[#2], 1], {dashedFrame, solidFrame, solidFrame, None},
				MatchQ[First[#2], Length[myPartialPacket]], {solidFrame, solidFrame, dashedFrame, None},
				True, {dashedFrame, solidFrame, dashedFrame, None}
			]
		],
		Item[formatValue[Last[#1], First[#1], myPacket, myType, nameCache],
			Alignment -> {Left, Bottom},
			(* in MM 13.2 ItemSize -> {Full, 0.5} expands beyond the page as wide as the elements lists needs to be in one line *)
			ItemSize -> {Automatic, .5},
			Frame -> Which[
				MatchQ[First[#2], 1] && MatchQ[First[#2], Length[myPartialPacket]], {solidFrame, None, solidFrame, solidFrame},
				MatchQ[First[#2], 1], {dashedFrame, None, solidFrame, solidFrame},
				MatchQ[First[#2], Length[myPartialPacket]], {solidFrame, None, dashedFrame, solidFrame},
				True, {dashedFrame, None, dashedFrame, solidFrame}
			]
		]
	}&, myPartialPacket]
];


formatFavoritesText[text_String]:=Item[Style[text, Italic, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]], Alignment -> Left];

(* --- Overload for Objects --- *)
(* Mouse over shows description, clicking pops out dereference cells *)
formatKey[myKey_, myObject_, myType_, myItem_]:=Module[{text, description, styledDescription, infoIcon, mouseOver, textButton, headers, descriptionWithHeaders},

	(* Generate text in formated style *)
	text=Style[ToString[myKey], Bold, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]];

	(* Lookup the description for our key in our type *)
	description=Description /. (myKey /. (ECL`Fields /. LookupTypeDefinition[myType]));

	(* Pull out the headers of the field. *)
	headers=Headers /. (myKey /. (ECL`Fields /. LookupTypeDefinition[myType]));

	(* If the field has headers, append "in the form {Headers}" to the description. *)
	descriptionWithHeaders=If[MatchQ[headers, {String__}],
		StringTrim[description, "."]<>", in the form: "<>ToString[headers],
		description
	];

	(* Stylize the description text *)
	styledDescription=Style[descriptionWithHeaders, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]];

	(* Generate the info icon *)
	infoIcon=Framed[Style["i", FontFamily -> "Times", Bold, FontSize -> 10, Bold, RGBColor["#8E8E8E"]], ImageSize -> {17, 17}, RoundingRadius -> 100, Alignment -> Center, FrameStyle -> None, Background -> RGBColor["#E2E4E6"], FrameMargins -> None];

	(* Generate tool tip with description on mouse over *)
	mouseOver=Tooltip[infoIcon, styledDescription, TooltipStyle -> {Background -> RGBColor["#FFEE78"], CellFrameColor -> RGBColor["#8E8E8E"], CellFrame -> 1}];

	(* Buttonize the tool tip to dereference on click by droping out a paired input and output cell as if the users typed in the dereference of the field *)
	textButton=Button[text,
		Module[{},
			CellPrint[Cell[BoxForm[MakeBoxes[myObject[myKey]]], "Input"]];
			CellPrint[ExpressionCell[myObject[myKey], "Output"]];
		],
		Appearance -> None,
		Method -> "Queued"
	];

	(* Return the info button and the stylized key name in a grid *)
	Grid[{{
		mouseOver,
		textButton
	}}]

];

(* --- Overload for Types --- *)
(* Mouse over shows pattern, clicking don't do shit *)
formatKey[myKey_, myPattern_]:=Module[{text, styledDescription, infoIcon, mouseOver},

	(* Generate text in formated style *)
	text=Item[Style[ToString[myKey], Bold, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]], ItemSize -> {Scaled[.25], 2}];

	(* Stylize the description text *)
	styledDescription=Style[myPattern, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]];

	(* Generate the info icon *)
	infoIcon=Framed[Style["i", FontFamily -> "Times", Bold, FontSize -> 10, Bold, RGBColor["#8E8E8E"]], ImageSize -> {17, 17}, RoundingRadius -> 100, Alignment -> Center, FrameStyle -> None, Background -> RGBColor["#E2E4E6"], FrameMargins -> None];

	(* Generate tool tip with description on mouse over *)
	mouseOver=Tooltip[infoIcon, styledDescription, TooltipStyle -> {Background -> RGBColor["#FFEE78"], CellFrameColor -> RGBColor["#8E8E8E"], CellFrame -> 1}];

	Grid[{{mouseOver, text}}, Alignment -> Left, ItemSize -> {{Full, Scaled[.9]}}]

];

(* Stringify CloudFile objects in the Object field so that we don't get the cloud file blob at the top of the inspect table *)
formatValue[value:ObjectP[Object[EmeraldCloudFile]], key:Object, packet_, type:TypeP[], nameCache:{_Association...}]:=Style[ToString[value /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}], FontSize -> 11, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[value], MenuEvaluator -> Automatic]}];

(* Ignore EvaluationButtons since they do not need any formatting *)
formatValue[value_DynamicModule, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{},
	value
];

(* Named Multiple indexed to a Named Multiple of the same length*)
formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[
	{indexingKey, headerItems, indexingValues, valueItems, gridItems, grid, estimatedTableWidth,
		horizontalScrollBool, fieldHeaderKeys, fieldHeaders, indexingFieldHeadersKeys, indexingFieldHeaders, stylizedKey, stylizedIndexingKey, valueValues,
		indexingValueValues, joinedValues, keyItems, valuesNullColumnsRemoved, fieldHeadersNullColumnsRemoved
	},

	(* Pull out the headers of the field being plotted *)
	{fieldHeaderKeys, fieldHeaders}=getFieldHeadersWithDefault[value, key, type];
	{valuesNullColumnsRemoved, fieldHeadersNullColumnsRemoved} = removeNullColumnsFromNamedMultiples[value, fieldHeaderKeys, fieldHeaders];
	{indexingKey, indexingValues} = getIndexingKeysAndValues[key, packet, type];

	(* Pull out the headers of the indexing field *)
	{indexingFieldHeadersKeys, indexingFieldHeaders}=getFieldHeadersWithDefault[value, indexingKey, type];

	headerItems=getHeaderItems[Join[fieldHeadersNullColumnsRemoved, indexingFieldHeaders]];

	(* Stylize the field name *)
	stylizedKey=Style[key, Bold, LineBreakWithin -> False, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]];
	stylizedIndexingKey=Style[indexingKey, Bold, LineBreakWithin -> False, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]];

	(* If the values are an association (named), get just the values *)
	valueValues=If[MatchQ[valuesNullColumnsRemoved, {_Association ..}],
		Values[value],
		value
	];

	indexingValueValues=If[MatchQ[indexingValues, {_Association ..}],
		Values[indexingValues],
		indexingValues
	];

	(* Join the values and indexing values together *)
	joinedValues=MapThread[Join[#1, #2] &, {valueValues, indexingValueValues}];

	(* Format the values for the table *)
	valueItems=MapIndexed[
		Style[# /. {
			x_Association :> x,
			x:ObjectP[Object[Program, ProcedureEvent]] :> x,
			x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]],
			x:LinkP[] :> replaceNameLink[x, nameCache],
			x:_Symbol[_Association] :> replacePrimitive[x, nameCache],
			x_Quantity :> ToString[HoldForm[x]]
		},
		FontSize -> 11,
		LineBreakWithin -> False,
		ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
	]&, joinedValues, {2}];

	(* To make the table clear, we are also including the keys above each appropriate section *)
	keyItems=Join[{stylizedKey}, Table[SpanFromLeft, Length[First[valueValues]] - 1], {stylizedIndexingKey}, Table[SpanFromLeft, Length[First[indexingValueValues]] - 1]];

	(* Join the formatted header and values *)
	gridItems=Join[{keyItems}, {headerItems}, valueItems];

	(* Put the values in a grid *)
	grid=Grid[gridItems,
		Dividers -> {
			{{{Directive[RGBColor["#CBCBCB"], Thickness@1]}}, {1 -> Transparent, -1 -> Transparent, (Length[First[valueValues]] + 1) -> Directive[RGBColor["#8E8E8E"], Thickness@1]}},
			{1 -> Transparent, 3 -> Directive[RGBColor["#8E8E8E"], Thickness@1], -1 -> Transparent}},
		Background -> {None, {{{None, RGBColor["#E2E2E2"]}}, {1 -> RGBColor["#E2E4E6"], 2 -> RGBColor["#E2E4E6"]}}},
		Alignment -> {Left, Left, {{1, 1} -> Center, {1, (Length[First[valueValues]] + 1)} -> Center}},
		ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, False}, AppearanceElements -> None, ImageSize -> UpTo[Scaled[1]]
		],
		FrameMargins -> 0,
		FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1]
	]
]/;And[
	(* The field being plotted is a named multiple field *)
	NamedFieldQ[type[key]],
	MultipleFieldQ[type[key]],

	(* It is indexed to a field that is a named multiple or an indexed multiple*)
	Or[
		NamedFieldQ[type[(IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]],
		IndexedFieldQ[type[(IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]]
	],
	MultipleFieldQ[type[(IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]],

	(* The field and the indexing field are the same length *)
	SameLengthQ[Lookup[packet, key], Lookup[packet, (IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]]
];


formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{headerItems, valueItems, indexingKey,
	gridItems, grid, estimatedTableWidth, horizontalScrollBool, fieldHeaderKeys, fieldHeaders, indexingValues, indexingValueItems,
	valuesNullColumnsRemoved, fieldHeadersNullColumnsRemoved
},
	(* Pull out the headers of the field being plotted *)
	{fieldHeaderKeys,fieldHeaders}=getFieldHeadersWithDefault[value, key, type];
	{valuesNullColumnsRemoved, fieldHeadersNullColumnsRemoved} = removeNullColumnsFromNamedMultiples[value, fieldHeaderKeys, fieldHeaders];
	{indexingKey, indexingValues} = getIndexingKeysAndValues[key, packet, type];
	headerItems=getHeaderItems[Join[fieldHeadersNullColumnsRemoved, {indexingKey}]];


	(* Format the values for the table *)
	valueItems=MapIndexed[
		Style[# /. {
			x:ObjectP[Object[Program, ProcedureEvent]] :> x,
			x:ObjectReferenceP[] :> With[
				{name=Lookup[FirstCase[nameCache, KeyValuePattern[{Object -> Quiet[Download[x, Object], Download::ObjectDoesNotExist]}], <||>], Name, Null]},
				If[NullQ[name], x, Append[x[Type], name]]],

			x:LinkP[] :> With[
				{name=Lookup[FirstCase[nameCache, KeyValuePattern[{Object -> Quiet[Download[x, Object], Download::ObjectDoesNotExist]}], <||>], Name, Null]},
				If[NullQ[name], x, Link[Append[x[Type], name], Sequence @@ Rest[x]]]]
		},
			FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, Values[valuesNullColumnsRemoved], {2}];

	indexingValueItems=MapIndexed[
		Style[#, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, indexingValues];


	(* Join the formatted header and values *)
	gridItems=Transpose[MapThread[Prepend[#1, #2] &, {Join[Transpose[valueItems], {indexingValueItems}], headerItems}]];

	(* Put the values in a grid *)
	grid=Grid[gridItems,
		Dividers -> {
			{{{Directive[RGBColor["#CBCBCB"], Thickness@1]}}, {1 -> Transparent, -1 -> Transparent}},
			{1 -> Transparent, 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], -1 -> Transparent}
		},
		Background -> {None, {{{RGBColor["#E2E2E2"], None}}, {1 -> RGBColor["#E2E4E6"]}}},
		Alignment -> Left, ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, False}, AppearanceElements -> None, ImageSize -> UpTo[Scaled[1]]
		],
		FrameMargins -> 0,
		FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1]
	]
]/;And[
	(* The field being plotted is a named multiple field *)
	NamedFieldQ[type[key]],
	MultipleFieldQ[type[key]],

	(* and it is indexed to another field (that is not covered by the indexed to named/multiple field case above)*)
	FieldQ[type[(IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]],

	(* and the thing it is indexed to is populated *)
	!MatchQ[Lookup[packet, IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type]))], {}]
];


(* Named Multiple *)
formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{headerItems, valueItems,
	gridItems, grid, estimatedTableWidth, horizontalScrollBool, fieldHeaderKeys, fieldHeaders,
	valuesNullColumnsRemoved, fieldHeadersNullColumnsRemoved},

	{fieldHeaderKeys,fieldHeaders}=getFieldHeadersWithDefault[value, key, type];
	{valuesNullColumnsRemoved, fieldHeadersNullColumnsRemoved} = removeNullColumnsFromNamedMultiples[value, fieldHeaderKeys, fieldHeaders];
	headerItems=getHeaderItems[fieldHeadersNullColumnsRemoved];

	(* Format the values for the table *)
	valueItems=MapIndexed[
		Style[# /. {
			x_Association :> x,
			x:ObjectP[Object[Program, ProcedureEvent]] :> x,
			x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]],
			x:LinkP[] :> replaceNameLink[x, nameCache],
			x:_Symbol[_Association] :> replacePrimitive[x, nameCache],
			x_Quantity :> ToString[HoldForm[x]]
		},
		FontSize -> 11,
		LineBreakWithin -> False,
		ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
	]&, Values[valuesNullColumnsRemoved], {2}];

	(* Join the formatted header and values *)
	gridItems=Join[{headerItems}, valueItems];

	(* Put the values in a grid *)
	grid=Grid[gridItems,
		Dividers -> {
			{{{Directive[RGBColor["#CBCBCB"], Thickness@1]}}, {1 -> Transparent, -1 -> Transparent}},
			{1 -> Transparent, 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], -1 -> Transparent}
		},
		Background -> {None, {{{RGBColor["#E2E2E2"], None}}, {1 -> RGBColor["#E2E4E6"]}}},
		Alignment -> Left, ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, False}, AppearanceElements -> None, ImageSize -> UpTo[Scaled[1]]
		],
		FrameMargins -> 0,
		FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1]
	]
]/;And[
	(* The field being plotted is a named multiple field *)
	NamedFieldQ[type[key]],
	MultipleFieldQ[type[key]]
];


(* Index matched field that doesn't have headers and the indexed and indexing field values are the same length, and the number of table entries is <=5 *)
formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{indexingKey, headerItems, indexingValues, valueItems,
	indexingValueItems, gridItems, grid, estimatedTableWidth, horizontalScrollBool, nullRowsRemovedValue, nullRowsRemovedIndexingValues
},
	{indexingKey, indexingValues} = getIndexingKeysAndValues[key, packet, type];
	headerItems=getHeaderItems[{indexingKey, key}];
	{nullRowsRemovedValue, nullRowsRemovedIndexingValues}=removeNullRowsFromIndexedMultiples[value, indexingValues];

	(* Format the values for the table *)
	valueItems=MapIndexed[
		Style[# /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, nullRowsRemovedValue];

	indexingValueItems=MapIndexed[
		Style[#, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, nullRowsRemovedIndexingValues];

	(* Join the formatted header and values *)
	gridItems=MapThread[Prepend[#1, #2]&, {{indexingValueItems, valueItems}, headerItems}];

	(* Put the values in a grid *)
	grid=Grid[gridItems,
		Dividers -> {{{{None}}, {1 -> Transparent, 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], -1 -> Transparent}}, {1 -> Transparent, 2 -> Directive[RGBColor["#C2C2C2"], Thickness@1], -1 -> Transparent}},
		Background -> {{{{RGBColor["#E2E2E2"], None}}, {1 -> RGBColor["#E2E4E6"]}}, None},
		Alignment -> {{1 -> Left}, Center},
		ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, False}, AppearanceElements -> None, ImageSize -> UpTo[Scaled[1]]
		],
		FrameMargins -> 0,
		FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1]
	]
]/;FieldQ[type[(IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]] && Not[MatchQ[(Headers /. (key /. (ECL`Fields /. LookupTypeDefinition[type]))), {String__}]] && SameLengthQ[Lookup[packet, key], Lookup[packet, (IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]] && Length[value] <= 5;

(* Index matched field that does have headers and the indexed and indexing field values are the same length, and the number of table entries is <=5  *)
formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{indexingKey, headerItems, indexingValues, valueItems,
	indexingValueItems, gridItems, grid, estimatedTableWidth, horizontalScrollBool, fieldHeaders, nullRowsRemovedValue, nullRowsRemovedIndexingValues
},
	{indexingKey, indexingValues} = getIndexingKeysAndValues[key, packet, type];
	{fieldHeaders, headerItems} = getFieldHeadersAndHeaderItemsWithIndexingKey[key, type, indexingKey];
	{nullRowsRemovedValue, nullRowsRemovedIndexingValues}=removeNullRowsFromIndexedMultiples[value, indexingValues];

	(* Format the values for the table *)
	valueItems=MapIndexed[
		Style[# /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, nullRowsRemovedValue, {2}];

	indexingValueItems=MapIndexed[
		Style[#, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, nullRowsRemovedIndexingValues];

	(* Join the formatted header and values *)
	gridItems=MapThread[Prepend[#1, #2]&, {Join[{indexingValueItems}, Transpose[valueItems]], headerItems}];

	(* Put the values in a grid *)
	grid=Grid[gridItems,
		Dividers -> {{{{None}}, {1 -> Transparent, 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], -1 -> Transparent}}, {Directive[RGBColor["#C2C2C2"], Thickness@1], {1 -> Transparent, 2 -> Directive[RGBColor["#C2C2C2"], Thickness@1], -1 -> Transparent}}},
		Background -> {{{{RGBColor["#E2E2E2"], None}}, {1 -> RGBColor["#E2E4E6"]}}, None},
		Alignment -> {{1 -> Left}, Center},
		ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, False}, AppearanceElements -> None, ImageSize -> UpTo[Scaled[1]]
		],
		FrameMargins -> 0,
		FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1]
	]
]/;FieldQ[type[(IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]] && MatchQ[(Headers /. (key /. (ECL`Fields /. LookupTypeDefinition[type]))), {String__}] && SameLengthQ[Lookup[packet, key], Lookup[packet, (IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]] && Length[value] <= 5;

(* Index matched field that doesn't have headers and the indexed and indexing field values are the same length, and the number of table entries is >5 *)
formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{indexingKey, headerItems, indexingValues, valueItems,
	indexingValueItems, gridItems, grid, estimatedTableWidth, horizontalScrollBool, nullRowsRemovedValue, nullRowsRemovedIndexingValues
},
	{indexingKey, indexingValues} = getIndexingKeysAndValues[key, packet, type];
	(* The table headers are the key and the indexing key *)
	headerItems=getHeaderItems[{indexingKey, key}];
	{nullRowsRemovedValue, nullRowsRemovedIndexingValues}=removeNullRowsFromIndexedMultiples[value, indexingValues];

	(* Format the values for the table *)
	valueItems=MapIndexed[
		Style[# /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, nullRowsRemovedValue];

	indexingValueItems=MapIndexed[
		Style[#, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, nullRowsRemovedIndexingValues];

	(* Join the formatted header and values *)
	gridItems=Transpose[MapThread[Prepend[#1, #2]&, {{indexingValueItems, valueItems}, headerItems}]];

	grid=Grid[gridItems,
		Dividers -> {
			{{{Directive[RGBColor["#CBCBCB"], Thickness@1]}}, {1 -> Transparent, -1 -> Transparent}},
			{1 -> Transparent, 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], -1 -> Transparent}
		},
		Background -> {None, {{{RGBColor["#E2E2E2"], None}}, {1 -> RGBColor["#E2E4E6"]}}},
		Alignment -> Left, ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, False}, AppearanceElements -> None, ImageSize -> UpTo[Scaled[1]]
		],
		FrameMargins -> 0,
		FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1]
	]
]/;FieldQ[type[(IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]] && Not[MatchQ[(Headers /. (key /. (ECL`Fields /. LookupTypeDefinition[type]))), {String__}]] && SameLengthQ[Lookup[packet, key], Lookup[packet, (IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]] && Length[value] > 5;

(* Index matched field that does have headers and the indexed and indexing field values are the same length, and the number of table entries is >5  *)
formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{indexingKey, headerItems, indexingValues, valueItems,
	indexingValueItems, gridItems, grid, estimatedTableWidth, horizontalScrollBool, fieldHeaders, nullRowsRemovedValue, nullRowsRemovedIndexingValues
},
	(* The index matching field *)
	(* Pull out the values from the indexing field *)
	{indexingKey, indexingValues} = getIndexingKeysAndValues[key, packet, type];
	{fieldHeaders, headerItems} = getFieldHeadersAndHeaderItemsWithIndexingKey[key, type, indexingKey];
	{nullRowsRemovedValue, nullRowsRemovedIndexingValues}=removeNullRowsFromIndexedMultiples[value, indexingValues];

	(* Format the values for the table *)
	valueItems=MapIndexed[
		Style[# /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, nullRowsRemovedValue, {2}];

	indexingValueItems=MapIndexed[
		Style[#, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, nullRowsRemovedIndexingValues];

	(* Join the formatted header and values *)
	gridItems=Transpose[MapThread[Prepend[#1, #2]&, {Join[{indexingValueItems}, Transpose[valueItems]], headerItems}]];

	(* Put the values in a grid *)
	grid=Grid[gridItems,
		Dividers -> {
			{{{Directive[RGBColor["#CBCBCB"], Thickness@1]}}, {1 -> Transparent, -1 -> Transparent}},
			{1 -> Transparent, 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], -1 -> Transparent}
		},
		Background -> {None, {{{RGBColor["#E2E2E2"], None}}, {1 -> RGBColor["#E2E4E6"]}}},
		Alignment -> Left, ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, False}, AppearanceElements -> None, ImageSize -> UpTo[Scaled[1]]
		],
		FrameMargins -> 0,
		FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1]
	]
]/;FieldQ[type[(IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]] && MatchQ[(Headers /. (key /. (ECL`Fields /. LookupTypeDefinition[type]))), {String__}] && SameLengthQ[Lookup[packet, key], Lookup[packet, (IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type])))]] && Length[value] > 5;

(* Short table *)
formatValue[value_List, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{fieldHeaders, casedHeaders, headerValue, headerItems, valueItems, gridItems, grid, estimatedTableWidth, horizontalScrollBool},

	(* Pull out the Headers value of the field. *)
	fieldHeaders=Headers /. (key /. (ECL`Fields /. LookupTypeDefinition[type]));

	(* Capatilize the first letter of each word in the headers *)
	casedHeaders=StringReplace[#1, WordBoundary~~x_ :> ToUpperCase[x]]& /@ fieldHeaders;

	(* If headers are provided, use them and append units where available. Otherwise try to figure out appropriate headers. *)
	headerValue=If[MatchQ[casedHeaders, {String__}],
		casedHeaders,
		Table[Nothing, Length[value]]
	];

	(* Format the header for the table *)
	headerItems=
		Style[#, Bold, LineBreakWithin -> False, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]
		]& /@ headerValue;

	(* Format the values for the table *)
	valueItems=MapIndexed[
		Style[# /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, value, {2}];

	(* Join the formatted header and values *)
	gridItems=Prepend[valueItems, headerItems];

	(* Put the values in a grid *)
	grid=Grid[gridItems,
		Dividers -> {
			{{{Directive[RGBColor["#CBCBCB"], Thickness@1]}}, {1 -> Transparent, -1 -> Transparent}},
			{1 -> Transparent, 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], -1 -> Transparent}
		},
		Background -> {None, {{{RGBColor["#E2E2E2"], None}}, {1 -> RGBColor["#E2E4E6"]}}},
		Alignment -> Left, ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, False}, AppearanceElements -> None, ImageSize -> UpTo[Scaled[1]]
		],
		FrameMargins -> 0,
		FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1]
	]
]/;MatrixQ[value] && Length[value] <= 15;

(* Long table *)
formatValue[value_List, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{fieldHeaders, casedHeaders, headerValue, headerItems, valueItems, gridItems, grid, estimatedTableWidth, horizontalScrollBool},

	(* Pull out the Headers value of the field. *)
	fieldHeaders=Headers /. (key /. (ECL`Fields /. LookupTypeDefinition[type]));

	(* Capatilize the first letter of each word in the headers *)
	casedHeaders=StringReplace[#1, WordBoundary~~x_ :> ToUpperCase[x]]& /@ fieldHeaders;

	(* If headers are provided, use them. Otherwise try to figure out appropriate headers. *)
	headerValue=If[MatchQ[casedHeaders, {String__}],
		casedHeaders,
		Table[Nothing, Length[value]]
	];

	(* Format the header for the table *)
	headerItems=
		Style[#, Bold, LineBreakWithin -> False, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]
		]& /@ headerValue;

	(* Format the values for the table *)
	valueItems=MapIndexed[
		Style[# /. {
			x:ObjectP[Object[Program, ProcedureEvent]] :> x,
			x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache]}, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}
		]&, value, {2}];

	(* Join the formatted header and values *)
	gridItems=Prepend[valueItems, headerItems];

	(* Put the values in a grid *)
	grid=Grid[gridItems,
		Dividers -> {
			{{{Directive[RGBColor["#CBCBCB"], Thickness@1]}}, {1 -> Transparent, -1 -> Transparent}},
			{1 -> Transparent, 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], -1 -> Transparent}
		},
		Background -> {None, {{{RGBColor["#E2E2E2"], None}}, {1 -> RGBColor["#E2E4E6"]}}},
		Alignment -> Left, ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	(* Put the values in a grid hidden under a drop-down button *)
	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, True}, AppearanceElements -> None, ImageSize -> {UpTo[Scaled[1]], UpTo[450]}
		],
		FrameMargins -> 0,
		FrameStyle -> Directive[RGBColor["#8E8E8E"], Thickness@1]
	]
]/;MatrixQ[value] && 200 >= Length[value] > 15;

(* Short association or list of rules *)
formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Style[Column[value /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}], FontSize -> 11, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[value], MenuEvaluator -> Automatic]}]/;MatchQ[value, _Assocation | {_Rule..}] && Length[value] <= 15;

(* Long association or list of rules *)
formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=OpenerView[{dropdownButtonGraphic["Rules"], Style[Column[value /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}], FontSize -> 11, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[value], MenuEvaluator -> Automatic]}]}, False, Method -> "Active"]/;MatchQ[value, _Assocation | {_Rule..}] && Length[value] > 15;

(* Short index matched single: put in a table with headers *)
formatValue[value_List, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Module[{fieldHeaders, casedHeaders, headerValue, headerItems, valueItems, gridItems, grid, estimatedTableWidth, horizontalScrollBool},

	(* Pull out the Headers value of the field. *)
	fieldHeaders=Headers /. (key /. (ECL`Fields /. LookupTypeDefinition[type]));

	(* Capatilize the first letter of each word in the headers *)
	casedHeaders=StringReplace[#1, WordBoundary~~x_ :> ToUpperCase[x]]& /@ fieldHeaders;

	(* If headers are provided, use them and append units where available. Otherwise try to figure out appropriate headers. *)
	headerValue=If[MatchQ[casedHeaders, {String__}],
		casedHeaders,
		Table[Nothing, Length[value]]
	];

	(* Format the header for the table *)
	headerItems=
		Style[#, Bold, LineBreakWithin -> False, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]
		]& /@ headerValue;

	(* Format the values for the table *)
	valueItems=Style[# /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, LineBreakWithin -> False, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[#], MenuEvaluator -> Automatic]}] & /@ value;

	(* Join the formatted header and values *)
	gridItems=Prepend[{valueItems}, headerItems];

	(* Put the values in a grid *)
	grid=Grid[gridItems,
		Dividers -> {
			{{{Directive[RGBColor["#CBCBCB"], Thickness@1]}}, {1 -> Transparent, -1 -> Transparent}},
			{1 -> Transparent, 2 -> solidFrame, -1 -> Transparent}
		},
		Background -> {None, {{{RGBColor["#E2E2E2"], None}}, {1 -> RGBColor["#E2E4E6"]}}},
		Alignment -> Left, ItemSize -> {{All, All}}
	];

	(* Get the width of the grid in pixels *)
	estimatedTableWidth=FirstOrDefault[Quiet[Rasterize[grid, "RasterSize"], {Rasterize::bigraster}]];

	(* If the table width is greater than 380 pixels, turn on the horizontal scroll bar. (The minimum width currently allowed in the ISE is 387 pixels.) *)
	horizontalScrollBool=(estimatedTableWidth > 350) || NullQ[estimatedTableWidth];

	Framed[
		Pane[
			grid, Scrollbars -> {horizontalScrollBool, False}, AppearanceElements -> None, ImageSize -> UpTo[Scaled[1]]
		],
		FrameMargins -> 0,
		FrameStyle -> solidFrame
	]
]/;Length[value] <= 10 && Length[Flatten[value]] <= 25 && IndexedFieldQ[type[key]] && SingleFieldQ[type[key]];

(* Short list of stuff: put in a column *)
formatValue[value_List, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Style[Column[value /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}], FontSize -> 11, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[value], MenuEvaluator -> Automatic]}]/;Length[value] <= 10 && Length[Flatten[value]] <= 25;

(* Long list of stuff: put in list form under a drop down button *)
formatValue[value_List, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=OpenerView[{dropdownButtonGraphic["List"], Style[value /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[value], MenuEvaluator -> Automatic]}]}, False, Method -> "Active"]/;200 >= Length[value] > 10 || 200 >= Length[Flatten[value]] > 10;

(* Really long list of stuff: Shorten list under a drop down button *)
formatValue[value_List, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=OpenerView[{dropdownButtonGraphic["List"],
	Short[Style[value /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[value], MenuEvaluator -> Automatic]}], 1]
}, False, Method -> "Active"]/;Length[value] > 200 || Length[Flatten[value]] > 200;

(* Long string *)
formatValue[value_String, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=OpenerView[{dropdownButtonGraphic["String"], Style[value /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[value], MenuEvaluator -> Automatic]}]}, False, Method -> "Active"]/;StringLength[value] > 150;

(* Single field with units *)
formatValue[value_?QuantityQ, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Style[UnitScale[value /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}], FontSize -> 11, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[value], MenuEvaluator -> Automatic]}];

(* Everything else *)
formatValue[value_, key_Symbol, packet_, type:TypeP[], nameCache:{_Association...}]:=Style[value /. {x_Association :> x, x:ObjectP[Object[Program, ProcedureEvent]] :> x, x:ObjectReferenceP[] :> Evaluate[replaceNameObject[x, nameCache]], x:LinkP[] :> replaceNameLink[x, nameCache], x:_Symbol[_Association] :> replacePrimitive[x, nameCache]}, FontSize -> 11, ContextMenu -> {MenuItem["Copy to clipboard", KernelExecute@CopyToClipboard[value], MenuEvaluator -> Automatic]}];

(* Helper function to make a button graphic for Inspect action buttons *)
actionButtonGraphic[myText_String]:=Module[{stylizedText},
	(* Stylize the text*)
	stylizedText=Style[myText, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#CACACA"]];

	(* Frame the sytlized text *)
	Framed[stylizedText, RoundingRadius -> 5, Alignment -> Center, FrameStyle -> None, Background -> RGBColor["#232628"], FrameMargins -> 5]];

(* Helper function to make a button graphic for Inspect drop down buttons *)
dropdownButtonGraphic[myText_String]:=Module[{stylizedText},
	(* Stylize the text*)
	stylizedText=Style[myText, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]];

	(* Frame the sytlized text *)
	Framed[stylizedText, RoundingRadius -> 5, Alignment -> Center, FrameStyle -> None, Background -> RGBColor["#E2E4E6"], FrameMargins -> 5]
];


(* Helper functions for FormatValue *)

(* Helper function to remove rows from indexed multiple fields that are all null *)
removeNullRowsFromIndexedMultiples[fieldValues_, indexedValues_]:=Module[{valuesOnly, nullRowPositions},
	(* if field values is of associations *)
	valuesOnly=If[MatchQ[fieldValues, {_Association..}], Values@fieldValues, fieldValues];
	(* Grab the positions of all the null rows, we need to ensure a depth of 1 *)
	nullRowPositions=Position[valuesOnly, _?NullQ, 1];

	(* return the values with the rows removed where fieldvalues had all nulls *)
	{Delete[fieldValues, nullRowPositions], Delete[indexedValues, nullRowPositions]}
];

removeNullColumnsFromNamedMultiples[fieldValues_, fieldKeys_, fieldHeaders_]:=Module[{valuesOnly,
	transposedValues, fieldHeaderKeys, nullRowPositions, nullHeaders},
	(*Setting this in case fieldKeys is Null*)
	fieldHeaderKeys=fieldKeys;
	valuesOnly=If[MatchQ[fieldValues, {_Association..}], Values@fieldValues, fieldValues];
	transposedValues = Transpose@valuesOnly;
	(* Transpose so its easy to iterate*)
	nullRowPositions=Position[transposedValues, _?NullQ, 1];
	If[NullQ[fieldHeaderKeys],
		fieldHeaderKeys=fieldHeaders
	];

	(* return the values with the rows removed where fieldvalues had all nulls. Also take those correspnding headers out *)

	(*
		not sure if all of these are necessary, but playing it safe here
		because i see other places where named multiples are not always coming in as associations.
		They might be legacy/deprecated code, but i have no way of knowing.
	*)
	nullHeaders = If[MatchQ[#,_Symbol],#,Symbol[#]] & /@ Extract[fieldHeaderKeys, nullRowPositions];
	Which[
		(* list of associations. Expected case *)
		MatchQ[fieldValues, {_Association..}],
		{KeyDrop[fieldValues, nullHeaders], Delete[fieldHeaderKeys, nullRowPositions]},
		True, (* don't do anything for the unexpected case*)
		{fieldValues, fieldHeaderKeys}
	]
];

getIndexingKeysAndValues[key_Symbol, packet_, type:TypeP[]]:= Module[{indexingKey, indexingValues},
	(* The index matching field *)
	indexingKey=IndexMatching /. (key /. (ECL`Fields /. LookupTypeDefinition[type]));
	(* Pull out the values from the indexing field *)
	indexingValues=Lookup[packet, indexingKey];
	{indexingKey, indexingValues}
];

getFieldHeadersAndHeaderItemsWithIndexingKey[key_Symbol, type:TypeP[], indexingKey_] := Module[{fieldHeaders, headerItems},
	(* Pull out the Headers value of the field, which we know exists. Capitalize the first letter of each word in the header. *)
	fieldHeaders=Map[StringReplace[#1, WordBoundary~~x_ :> ToUpperCase[x]]&, Headers /. (key /. (ECL`Fields /. LookupTypeDefinition[type]))];

	(* The table headers are the indexing key and the Headers of the field *)
	headerItems=getHeaderItems[Join[{indexingKey}, fieldHeaders]];
	{fieldHeaders, headerItems}
];

getFieldHeadersWithDefault[value_, key_Symbol, type:TypeP[]]:=Module[{},
	With[{preDefinedHeaders=Headers /. (key /. (ECL`Fields /. LookupTypeDefinition[type]))},
		Which[
			(* Case where the headers are defined as {"header 1", ...} *)
			MatchQ[preDefinedHeaders, {_String ..}],
			{Null, Map[StringReplace[#1, WordBoundary~~x_ :> ToUpperCase[x]] &, preDefinedHeaders]},

			(* Case where the headers are defined as {symbol1->"header 1", ...} *)
			MatchQ[preDefinedHeaders, {Rule[_, _String] ..}],
			{Map[Symbol[StringReplace[#1, WordBoundary~~x_ :> ToUpperCase[x]]] &, ToString /@ Keys[preDefinedHeaders]],
				Map[StringReplace[#1, WordBoundary~~x_ :> ToUpperCase[x]] &, Values[preDefinedHeaders]]},

			(* Otherwise just use the named multiple to find the headers *)
			True,
			{Null, Map[StringReplace[#1, WordBoundary~~x_ :> ToUpperCase[x]] &, ToString /@ Keys[First[value]]]}
		]
	]
];

getHeaderItems[columnKeys_List] := Style[#, Bold, LineBreakWithin -> False, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]]& /@ columnKeys;

(* --- Type Inspect --- *)
(* Listable version *)
Inspect[myTypes:{TypeP[]..}, ops:OptionsPattern[Inspect]]:=Module[{safeOps},

	(* Safely extract the options so they fit to pattern definitions *)
	safeOps=SafeOptions[Inspect, ToList[ops]];

	(* Map with perserved options over all the types *)
	Inspect[#, safeOps]& /@ myTypes
];

Inspect[myType:TypeP[], ops:OptionsPattern[Inspect]]:=Module[
	{
		safeOps, output, abstractFields, myFields, typeDescription, groupedFields, categoryList, allKeyGroups, allDecriptionsGroups, allPatternGroups,
		formatedCategories, formattedKeys, formatKeyDescriptionPairs, gridItems, gridDisplay, formatedTitle, developerOption, resolvedOps
	},

	(* Safely extract the options so they fit to pattern definitions *)
	safeOps=SafeOptions[Inspect, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps, Output];

	(* Extract the description of the type from the stored structure of the database *)
	typeDescription=(Description /. LookupTypeDefinition[myType]);

	(* If Abstract is true remove non-abstract fields from database definitions *)
	abstractFields=If[(Abstract /. safeOps),
		Select[ECL`Fields /. LookupTypeDefinition[myType], MemberQ[Last[#], Abstract -> True]&],
		ECL`Fields /. LookupTypeDefinition[myType]
	];

	(* Resolve the Developer option. If an option is specified, use that option, otherwise resolve based on $PersonID. *)
	developerOption=If[BooleanQ[Developer /. safeOps],
		Developer /. safeOps,
		MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]]
	];

	(* If Developer is false remove developer fields from database definitions *)
	myFields=If[!developerOption,
		Select[abstractFields, !MemberQ[Last[#], Developer -> True]&],
		abstractFields
	];

	(* Break up the field definitions by Category *)
	groupedFields=GatherBy[myFields, (Category /. Last[#])&];

	(* Extract the list of all of the categories *)
	categoryList=Category /. (groupedFields[[All, 1, 2]]);

	(* Put togeather a list of lists of keys for field in each category *)
	allKeyGroups=groupedFields[[All, All, 1]];

	(* Put togeather a list of list of descriptions for field in each category *)
	allDecriptionsGroups=Description /. groupedFields[[All, All, 2]];

	(* Put togeather a list of lists of all the patterns *)
	allPatternGroups=Pattern /. groupedFields[[All, All, 2]];

	(* Format the categories displays for each category *)
	formatedCategories=formatCategory /@ categoryList;

	(* Format the keys with pattern mouse overs *)
	formattedKeys=MapThread[Function[{keyGroup, patternGroup}, MapThread[formatKey[#1, #2]&, {keyGroup, patternGroup}]], {allKeyGroups, allPatternGroups}];

	(* format the key with the descriptions *)
	formatKeyDescriptionPairs=MapThread[Function[{keyGroup, descriptionGroup}, MapThread[{#1, Item[Style[ToString[#2], FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]]]}&, {keyGroup, descriptionGroup}]], {formattedKeys, allDecriptionsGroups}];

	(* Generate a formated title for the display that includes the type and its description *)
	formatedTitle=formatTypeTitle[myType, typeDescription];

	(* Shuffle the categories back on top of each gathered packet and flatten out the bunch to generate the final list of stuff that goes in the grid *)
	gridItems=Join[formatedTitle, Flatten[Riffle[formatedCategories, formatKeyDescriptionPairs], 1]];

	(* Update the resolved options *)
	resolvedOps=ReplaceRule[safeOps,
		{
			Date -> None,
			Developer -> developerOption
		}
	];

	(* Return Formated Grid of information *)
	gridDisplay=Grid[gridItems,
		Alignment -> {{Left, Left}},
		Background -> {None, {{RGBColor["#E2E2E2"], None}}},
		Frame -> solidFrame
	];

	(* Return the result according to the output specification *)
	output /. {
		Result -> gridDisplay,
		Preview -> Pane[gridDisplay /. {Rule[ItemSize, _] :> Rule[ItemSize, Scaled[0.5]]}, ImageSize -> {Full, 300}, Scrollbars -> {False, True}, Alignment -> Center],
		Tests -> {},
		Options -> resolvedOps
	}
];


formatTypeTitle[myType_, myDescription_]:=Module[{typeText, descriptionText},
	(* Format the text in the display *)
	typeText=Style[myType, Bold, FontFamily -> "Helvetica", FontSize -> 14, RGBColor["#4A4A4A"]];
	descriptionText=Style[myDescription, FontFamily -> "Helvetica", FontSize -> 11, RGBColor["#4A4A4A"]];

	(* Return the paired (key,value) for the grid *)
	{
		{Item[typeText, Alignment -> Center, Background -> RGBColor["#CFD3D6"]], SpanFromLeft},
		{Item[descriptionText, Alignment -> Center, Background -> RGBColor["#CFD3D6"]], SpanFromLeft}
	}
];


(* ::Subsubsection::Closed:: *)
(*evaluationButton*)


DefineUsage[evaluationButton,
	{
		BasicDefinitions -> {
			{"evaluationButton[expr]", "button", "creates a button that when clicked will turn into the result of evaluating 'expr'."}
		},
		MoreInformation -> {
			"This function is HoldFIrst, so 'expr' does not evaluate until the button is clicked."
		},
		Input :> {
			{"expr", _, "An expression to evaluate."}
		},
		Output :> {
			{"button", _Button, "A button that evaluates and displays 'expr' when clicked."}
		},
		SeeAlso -> {
			"Button"
		},
		Author -> {
			"platform", "brad"
		}
	}];


DefineOptions[evaluationButton,
	Options :> {
		{Label -> "Evaluate", _, ""}
	}];


evaluationButton[expr_, ops:OptionsPattern[]]:=DynamicModule[{bool, out},
	bool=False;
	out="Evaluating...";
	Dynamic[If[bool === False,
		Button[
			actionButtonGraphic[OptionValue[Label]],
			bool=True;
			out=expr,
			Method -> "Queued", Appearance -> "Frameless"
		],
		out
	]
	]
];

SetAttributes[evaluationButton, HoldFirst];

TwelveHourDateString[date:_?DateObjectQ]:=DateString[date, {"Date", " ", "Hour12", ":", "Minute",
	":", "Second", " ", "AMPMLowerCase"}];


generateFavoriteLinks[object:ObjectP[]]:=Module[{favoriteFolders, favoriteBookmarks, objectID},
	favoriteFolders=Download[Search[Object[Favorite], TargetObject == object && FavoriteFolder != Null], FavoriteFolder];
	(* luckily Link[{}] yields {}*)
	favoriteBookmarks=Link[Search[Object[Favorite, Bookmark], TargetObject == object && Status == Active]];
	(* generate special buttons if in CC, which will do special FE actions *)
	objectID=ToString[object, InputForm];
	If[MatchQ[ECL`$ECLApplication, ECL`CommandCenter],
		(* Add Bookmark info to the cache *)
		Download[favoriteBookmarks, BookmarkPath];
		Return@{
			generateFavoriteLinkForFrontEnd[#, objectID] & /@ favoriteFolders,
			generateFavoriteLinkForFrontEnd[#, objectID] & /@ favoriteBookmarks
		}
	];
	{favoriteFolders, favoriteBookmarks}
];

generateFavoriteLinkForFrontEnd[link:ObjectP[], originalObjectID_String]:=With[{
	obj=Download[link, Object]
},
	With[{jumpString=Which[
		MatchQ[obj, ObjectP[Object[Favorite, Folder]]], "jumpToFavoriteFolder:"<>ToString[obj, InputForm],
		MatchQ[obj, ObjectP[Object[Favorite, Bookmark]]], "jumpToBookmark:"<>originalObjectID<>","<>ToString[Download[obj, BookmarkPath]],
		True, ""
	]},
		Button[
			Mouseover[Style[obj, RGBColor@"#6BBEEB"], Style[obj, Underlined, RGBColor@"#2AA4E6"]],
			AppHelpers`Private`postJSON[{"expr" -> jumpString}],
			Appearance -> None, ImageSize -> All, BaseStyle -> "EmeraldLink"
		]
	]
];