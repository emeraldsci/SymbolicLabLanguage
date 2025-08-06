(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)



(* ::Subsubsection::Closed:: *)
(*assembleStickerSheets*)

(* ::Subsection::Closed:: *)
(*PrintStickers*)


(* ::Subsubsection::Closed:: *)
(*PrintStickers Options and Messages*)

(* zxing-client java dependencies *)
(*
	Three jar files, core-3.4.0.jar, javase-3.4.0.jar and zxing-client.jar, are missing in MM 13.3.
	They were downloaded from MM 13.2 and stored in the resources folder of ExternalInventory,
	because they are needed for several sticker related functions
*)

javaFilesNotLoaded = True;
loadJavaFiles[] := If[$VersionNumber > 13.2 && javaFilesNotLoaded,
	(* Get our files which have the filter and slit look-ups *)
	resourceFolder = FileNameJoin[{PackageDirectory["ExternalInventory`"],"resources","zxing_client"}];
	coreJavaFile = FileNameJoin[{resourceFolder,"core-3.4.0.jar"}];
	javaseFile = FileNameJoin[{resourceFolder,"javase-3.4.0.jar"}];
	zxingClientFile = FileNameJoin[{resourceFolder,"zxing-client.jar"}];

	Needs["JLink`"];

	(* Add paths for MM to find Class files *)
	JLink`AddToClassPath[coreJavaFile];
	JLink`AddToClassPath[javaseFile];
	JLink`AddToClassPath[zxingClientFile];
	
	javaFilesNotLoaded = False
];

DefineOptions[
	PrintStickers,
	Options :> {
		{StickerSize -> Automatic, StickerSizeP | Automatic, "The size of sticker that will be printed, i.e. Small, Large, Piggyback. Small Destination stickers and all Large stickers require use of a different printer than is used for standard Small Object stickers."},
		{StickerModel -> Automatic, ObjectP[Model[Item, Sticker]] | Automatic, "Specifies what model of sticker will be printed, which determines the layout of each individual sticker and the layout of stickers on the printed sheets."},
		{Print -> True, BooleanP, "Specifies whether to go through with the printing operation (Print->True) or leave the sticker sheet(s) open (Print->False)."},
		{TextScaling -> Scale, Crop | Scale, "Specifies whether text that is too big for the sticker at the default size will be cropped or scaled."},
		{Border -> False, BooleanP, "If True, a black border will be drawn to delimit the boundaries of the sticker."},
		{FontFamily -> "Bitstream Vera Sans Mono", _String, "The font family that will be used for description text on printed stickers.", Category -> Hidden},
		{Output -> Notebook, Notebook | Graphics, "Specifies whether to return a notebook object or a list of graphics objects of the created stickers.", Category -> Hidden},
		{Interactive -> False, BooleanP,"Specifies whether the interactive printer selection pop up should appear.", Category -> Hidden},
		FastTrackOption,
		UploadOption,
		CacheOption
	}
];

PrintStickers::InvalidObjects="The following Objects do not exist in the ECL database: `1`.";
PrintStickers::NoDestinations="Destination stickers have been requested, but one or more of the input objects do not have any positions or connectors for which destination stickers can be printed.";
PrintStickers::StickerModelSizeMismatch="The specified StickerSize does not match the size of the specified StickerModel.";
PrintStickers::InputDimensionMismatch="The dimensions of the provided object list do not match the dimensions of the provided position list.";
PrintStickers::InvalidDestinations="The requested destinations `1` do not exist in the objects `2`. Please double check which positions or connectors you'd like to print stickers for.";
PrintStickers::StickerSizeTypeMismatch="The specified Piggyback StickerSize cannot be used to print Destination stickers. Please print object stickers or use the Small or Large StickerSize.";


(* ::Subsubsection::Closed:: *)
(*PrintStickers*)

(* --- Overload for Object[Transaction,ShipToECL] input to print stickers for all containers and items being shipped --- *)
PrintStickers[myTransaction:ObjectP[Object[Transaction, ShipToECL]], ops:OptionsPattern[]]:=Module[
	{safeOps, incomingCache, stickerModels, transactionInfo, unflatStickerPackets, itemPackets, containerPackets,
		itemModelPackets, containerModelObjects, stickerModelPackets, updatedCache, updatedOps, objectPackets,
		modelPackets, resolvedOps, barcodeTexts, stickerTexts, samplePackets, sampleModelPackets, emptyContainerPackets,
		emptyContainerModelPackets
	},

	safeOps=SafeOptions[PrintStickers, ToList[ops]];

	(* Extract cached Download packets that have been passed in *)
	incomingCache=Lookup[safeOps, Cache];

	(* If any of the input objects are not in the database, throw an error and return Failed. *)
	If[!TrueQ[Lookup[safeOps, FastTrack]] && !TrueQ[DatabaseMemberQ[myTransaction]],
		(Message[PrintStickers::InvalidObjects, myTransaction];
		Return[$Failed])
	];

	(* Since we don't know the resolved sticker models at this point, download all the sticker models (there are only 4). *)
	stickerModels=Search[Model[Item, Sticker], Deprecated != True];

	(* One consolidated download because that's how we roll. *)
	{transactionInfo, unflatStickerPackets}=Download[{{myTransaction}, stickerModels}, {
		{
			Packet[ReceivedSamples[{Name, Model, ID, Type}]],
			Packet[ReceivedContainers[{Name, Model}]],
			Packet[ReceivedSamples[Model[{Name}]]],
			Packet[ReceivedContainers[Model[{Name}]]],
			Packet[EmptyContainers[{Name, Model}]],
			Packet[EmptyContainers[Model[{Name}]]]
		}, {
			Packet[AspectRatio, BarcodeHorizontalPosition, BarcodeMaxHeight, BarcodeMaxWidth, BarcodeSize,
				BarcodeType, BarcodeVerticalPosition, BorderWidth, CharacterLimit, Columns, Height,
				HorizontalMargin, HorizontalPitch, ID, Name, Rows, StickerSize, StickersPerSheet, StickerType,
				TextBoxWidth, TextHorizontalPosition, TextSize, TextVerticalPitch, TextVerticalPosition,
				VerticalMargin, VerticalPitch, Width]
		}
	}, Cache -> incomingCache
	];

	(* Get the downloaded stuff into usable variables *)
	(* Delete any Null entries along the way to be resilient to Null placeholder entries in ReceivedContainers *)
	{samplePackets, containerPackets, sampleModelPackets, containerModelObjects, emptyContainerPackets, emptyContainerModelPackets}=DeleteCases[Flatten[#], Null] & /@ Transpose[transactionInfo];
	stickerModelPackets=Flatten[unflatStickerPackets];

	(* Add the packets downloaded above to the cache that was passed in *)
	updatedCache=DeleteCases[
		Union[incomingCache, Flatten[Join[samplePackets, containerPackets, sampleModelPackets, containerModelObjects, emptyContainerPackets, emptyContainerModelPackets, stickerModelPackets]]],
		Null
	];

	(* Replace the old Cache option with the updated version above *)
	updatedOps=ReplaceRule[safeOps, Cache -> updatedCache];

	(* Get just the items from the sample packets *)
	itemPackets=Cases[samplePackets, SelfContainedSampleP];
	itemModelPackets=Cases[sampleModelPackets, SelfContainedSampleModelP];

	(* Get the packets of the objects to print and the corresponding model packets *)
	objectPackets=Join[itemPackets, containerPackets, emptyContainerPackets];
	modelPackets=Join[itemModelPackets, containerModelObjects, emptyContainerModelPackets];

	(* If there is nothing to print (no containers or items), return an empty list. *)
	If[MatchQ[objectPackets, {}],
		Return[{}]
	];

	(* Resolve options *)
	resolvedOps=resolvePrintStickersOptions[Lookup[objectPackets, Object], stickerModelPackets, Object, updatedOps];

	(* If options resolution has failed, return $Failed for the entire printing operation *)
	If[MatchQ[resolvedOps, $Failed],
		Return[$Failed]
	];

	(* Generate barcode text and sticker text associations for Object stickers *)
	{barcodeTexts, stickerTexts}=assembleStickerInformation[
		objectPackets,
		modelPackets
	];

	(* Pass to core function *)
	printStickersCore[Lookup[objectPackets, Object], barcodeTexts, stickerTexts, PassOptions[PrintStickers, printStickersCore, resolvedOps]]

];

(* --- SLL Object/Packet/Link input, for printing Object stickers --- *)
PrintStickers[objects:ListableP[ObjectP[{Object[Sample], Object[Container], Object[Instrument], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring], Object[Item], Object[Package]}]], ops:OptionsPattern[]]:=Module[
	{safeOps, resolvedOps, incomingCache, updatedCache, updatedOps, barcodeTexts, stickerTexts, objectsList,
		stickerModels, stickerModelPackets, modelPackets, objectPackets, modelObjects, uploadPacket},

	safeOps=SafeOptions[PrintStickers, ToList[ops]];

	(* Extract cached Download packets that have been passed in *)
	incomingCache=Lookup[safeOps, Cache];

	(* Make sure that singleton input is wrapped in a list before continuing *)
	objectsList=ToList[objects];

	(* If any of the input objects are not in the database, throw an error and return Failed. *)
	With[{databaseMembers=DatabaseMemberQ[objectsList]},
		If[!TrueQ[Lookup[safeOps, FastTrack]] && MemberQ[databaseMembers, False],
			(Message[PrintStickers::InvalidObjects, PickList[objectsList, databaseMembers, False]];
			Return[$Failed])
		]
	];

	(* Since we don't know the resolved sticker models at this point, download all the sticker models (there are only 4). *)
	stickerModels=Search[Model[Item, Sticker]];

	(* Download partial packets for objects first; will be combined with the next Download call when possible *)
	(* New type Object[Package] may not have Model so we should quiet any message related *)
	objectPackets=Quiet[Download[objectsList, Packet[Name, Model], Cache -> incomingCache],Download::FieldDoesntExist];

	(* Pull Model from each input object packet, then download all models and sticker models *)
	(* Change $Failed to Null if we don't have a model *)
	modelObjects=Lookup[objectPackets, Model, Null]/.{$Failed->Null};

	{stickerModelPackets, modelPackets}=Unflatten[
		Download[Join[stickerModels, modelObjects], Cache -> incomingCache],
		{stickerModels, modelObjects}
	];

	(* Add the packets downloaded above to the cache that was passed in *)
	updatedCache=DeleteCases[
		Union[incomingCache, Flatten[Join[objectPackets, modelPackets, stickerModelPackets]]],
		Null
	];

	(* Replace the old Cache option with the updated version above *)
	updatedOps=ReplaceRule[safeOps, Cache -> updatedCache];

	(* Resolve options *)
	resolvedOps=resolvePrintStickersOptions[objectsList, stickerModelPackets, Object, updatedOps];

	(* If options resolution has failed, return $Failed for the entire printing operation *)
	If[MatchQ[resolvedOps, $Failed],
		Return[$Failed]
	];

	(* Generate barcode text and sticker text associations for Object stickers *)
	{barcodeTexts, stickerTexts}=assembleStickerInformation[
		objectPackets,
		modelPackets
	];

	uploadPacket=If[MatchQ[$PersonID, ObjectP[]],
		Association[
			Object -> $PersonID,
			Append[PrintStickersLog] -> Map[
				{Now, Link[#]}&,
				objectsList
			]
		],
		Null
	];

	If[OptionValue[Upload] && !NullQ[uploadPacket],
		Upload[uploadPacket]
	];

	(* Pass to core function *)
	printStickersCore[Download[objectsList, Object], barcodeTexts, stickerTexts, PassOptions[PrintStickers, printStickersCore, resolvedOps]]

];


(* --- SLL Object/Packet/Link input, for printing Destination stickers --- *)
PrintStickers[
	objects:ListableP[ObjectP[{Object[Sample], Object[Container], Object[Instrument], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring], Object[Item], Object[Package]}]],
	positions:(All | ListableP[_String, 2]),
	ops:OptionsPattern[]]:=Module[

	{safeOps, resolvedOps, modelObjects, incomingCache, updatedCache, updatedOps,
		barcodeTexts, stickerTexts, uploadPacket, objectsList, stickerModels, expandedAndFlattenedObjects,
		stickerModelPackets, modelPackets, objectPackets, expandedPositions, badObjs, badDestRequests},

	safeOps=SafeOptions[PrintStickers, ToList[ops]];

	(* Extract cached Download packets that have been passed in *)
	incomingCache=Lookup[safeOps, Cache];

	(* Make sure that singleton input is wrapped in a list before continuing *)
	objectsList=ToList[objects];

	(* If any of the input objects are not in the database, throw an error and return Failed. *)
	With[{databaseMembers=DatabaseMemberQ[objectsList]},
		If[!TrueQ[Lookup[safeOps, FastTrack]] && MemberQ[databaseMembers, False],
			(Message[PrintStickers::InvalidObjects, PickList[objectsList, databaseMembers, False]];
			Return[$Failed])
		]
	];

	(* Since we don't know the resolved sticker models at this point, download all the sticker models (there are only 4). *)
	stickerModels=Search[Model[Item, Sticker]];

	(* Download partial packets for objects first; will be combined with the next Download call when possible *)
	(* New type Object[Package] may not have Model so we should quiet any message related *)
	objectPackets=Quiet[Download[objectsList, Packet[Name, Model], Cache -> incomingCache],Download::FieldDoesntExist];

	(* Pull Model from each input object packet, then download all models and sticker models *)
	(* Change $Failed to Null if we don't have a model *)
	modelObjects=Lookup[objectPackets, Model, Null]/.{$Failed->Null};

	{stickerModelPackets, modelPackets}=Unflatten[
		Download[Join[stickerModels, modelObjects], Cache -> incomingCache],
		{stickerModels, modelObjects}
	];

	(* Add the packets downloaded above to the cache that was passed in *)
	updatedCache=DeleteCases[
		Union[incomingCache, Flatten[Join[objectPackets, modelPackets, stickerModelPackets]]],
		Null
	];

	(* Replace the old Cache option with the updated version above *)
	updatedOps=ReplaceRule[safeOps, Cache -> updatedCache];

	(* Resolve options, specifying that destination stickers will be printed *)
	resolvedOps=resolvePrintStickersOptions[objectsList, stickerModelPackets, Destination, updatedOps];

	(* If options resolution has failed, return $Failed for the entire printing operation *)
	If[MatchQ[resolvedOps, $Failed],
		Return[$Failed]
	];

	(* If input includes any objects whose models do not have Positions defined, throw an error and return Failed *)
	If[
		And[
			(* Object[Package] does not have Model so it is Null. They don't have positions *)
			Not[MemberQ[ToList@modelPackets,Null]],
			MemberQ[Lookup[DeleteCases[modelPackets,Null], Positions], {} | _Missing],
			MemberQ[Lookup[DeleteCases[modelPackets,Null], Connectors], {} | _Missing],
			MemberQ[Lookup[DeleteCases[modelPackets,Null], WiringConnectors], {} | _Missing]
		],
		Return[
			Message[PrintStickers::NoDestinations];
			$Failed
		]
	];

	(* Expand destination input as necessary *)
	expandedPositions=Switch[positions,

		(* Leave 'All' alone *)
		All, All,

		(* Expand singleton input into a list of lists matching length of 'objectsList' *)
		_String, Table[{positions}, Length[objectsList]],

		(* Repeat flat list input to match length of 'objectsList' *)
		{_String..}, Table[positions, Length[objectsList]],

		(* Pass through if positions is an index-matched list of lists; otherwise return an error *)
		{{_String..}..},
		If[MatchQ[Length[positions], Length[objectsList]],
			positions,
			Return[
				Message[PrintStickers::InputDimensionMismatch];
				$Failed
			]
		]
	];

	(* Double check the positions they've asked us to print exist in the corresponding models *)
	{badObjs, badDestRequests}=If[MatchQ[expandedPositions, All],

		(* They've requested all positions so no error is required*)
		{{}, {}},

		Module[{modelPositions, modelConnectors, modelWiringConnectors, modelPositionNames, modelConnectorNames, modelWiringConnectorNames, allDestinationNames, invalidModelPositions},

			(* Extract the list of position names for each input from its model *)
			modelPositions=Lookup[modelPackets, Positions, {}];
			modelConnectors=Lookup[modelPackets, Connectors, {}];
			modelWiringConnectors=Lookup[modelPackets, WiringConnectors, {}];
			modelPositionNames=Lookup[#, Name, {}]& /@ modelPositions;
			modelConnectorNames=#[[All, 1]]& /@ modelConnectors;
			modelWiringConnectorNames=#[[All, 1]]& /@ modelWiringConnectors;
			allDestinationNames=MapThread[Join, {modelPositionNames, modelConnectorNames, modelWiringConnectorNames}];

			(* Determine which, if any, model/destination paris are invalid *)
			invalidModelPositions=MapThread[
				Function[{requestedDests, destinationNames, objectInspected},
					If[SubsetQ[destinationNames, requestedDests],

						(* All destinations they've requested are in the position or connector fields *)
						{{}, {}},

						(* There was an issue, and we have to pick out whichever invalid positions they gave us *)
						{
							objectInspected,
							PickList[requestedDests, MemberQ[destinationNames, #]& /@ requestedDests, False]
						}
					]
				],
				{expandedPositions, allDestinationNames, objectsList}
			];

			(* Store the bad positions and object inputs for the error message *)
			{
				Flatten[invalidModelPositions[[All, 1]]],
				Flatten[invalidModelPositions[[All, 2]]]
			}
		]
	];

	If[
		!MatchQ[badObjs, {}],
		Return[
			Message[PrintStickers::InvalidDestinations, badDestRequests, badObjs];
			$Failed
		]
	];

	(* Generate barcode text and sticker text associations for Object stickers *)
	{expandedAndFlattenedObjects, barcodeTexts, stickerTexts}=assembleStickerInformation[
		objectPackets,
		modelPackets,

		expandedPositions
	];

	uploadPacket=If[MatchQ[$PersonID, ObjectP[]],
		Association[
			Object -> $PersonID,
			Append[PrintStickersLog] -> Map[
				{Now, Link[#]}&,
				objectsList
			]
		],
		Null
	];

	If[OptionValue[Upload] && !NullQ[uploadPacket],
		Upload[uploadPacket]
	];

	(* Pass to core function *)
	(* NOTE: We have to make sure that the objects we're passing down are index-matching. *)
	printStickersCore[
		expandedAndFlattenedObjects,
		barcodeTexts,
		stickerTexts,
		Sequence @@ resolvedOps
	]

];


(* --- Core definition: Takes in barcode text and description text and assembles and prints stickers --- *)
DefineOptions[
	printStickersCore,
	SharedOptions :> {PrintStickers}
];

Authors[printStickersCore]:={"ben", "olatunde.olademehin"};

printStickersCore[object:(ObjectP[]|BarcodeP), barcodeText_String?(StringLength[#1] > 0 &), stickerText:{Repeated[_String, {3}]}, ops:OptionsPattern[]]:=
	printStickersCore[{object}, {barcodeText}, {stickerText}, ops];
printStickersCore[objects:{(ObjectP[]|BarcodeP)..}, barcodeTexts:{_String?(StringLength[#1] > 0 &)..}, stickerTexts:{{Repeated[_String, {3}]}..}, ops:OptionsPattern[]]:=Module[
	{stickerGraphics,stickerSheets,opsList,stickersPerSheet,optionsToPass,interactiveQ,containerModels,return},

	opsList=ToList[ops];

	stickersPerSheet=Lookup[OptionValue[StickerModel], StickersPerSheet];

	optionsToPass=PassOptions[printStickersCore, drawSticker, opsList];

	(* Pull out the interactive option *)
	interactiveQ = OptionValue[Interactive];

	(* Get the models of these objects, if they are an Object[Container]. This is because for Model[Container, Vessel, "2mL Tube"] we have to *)
	(* move the right aligned text to the left since operators cut off the ends of the stickers to make them fit on the tube. *)
	containerModels=Download[Replace[objects, {Except[ObjectP[Object[Container]]] -> Null}, {1}], Model[Object]];

	(* Convert sticker input into a Graphics item for each sticker *)
	stickerGraphics=MapThread[
		drawSticker[#1, #2, #3, optionsToPass]&,
		{containerModels, barcodeTexts, stickerTexts}
	];

	(* Assemble sticker Graphics into sheets if Print\[Rule]True or we want Output\[Rule]Notebook *)
	stickerSheets=If[OptionValue[Print] || SameQ[OptionValue[Output], Notebook],
		assembleStickerSheets[stickerGraphics, stickersPerSheet, PassOptions[printStickersCore, assembleStickerSheets, opsList]],
		Null
	];

	(* Set the NewStickerPrinted field in the objects. This field lets engine know that it should show the hashcode when *)
	(* displaying the scan tile in engine. *)
	Upload[If[MatchQ[#, ObjectP[]], <|Object->#, NewStickerPrinted->True|>, Nothing]&/@Download[objects, Object]];

	(* Print and close sticker sheets and return Null if Print->True; otherwise, leave sheets open for examination *)
	return = If[TrueQ[OptionValue[Print]],
			(
				NotebookPrint[#,Interactive -> interactiveQ]& /@ stickerSheets;
				NotebookClose /@ stickerSheets;
			)
		,
		(* If Output\[Rule]Graphics, return the sticker graphics instead of the notebook. *)
		If[SameQ[OptionValue[Output], Graphics],
			stickerGraphics,

			(* Otherwise, return the notebook. *)
			stickerSheets
		]
	];

	(* we want to kill JLink` from the context path since it shadows some sother symbols used in SLL *)
	Experiment`Private`deleteJLink[];

	(* output whatever we were going to return *)
	return
];


(* App overload for reprinting stickers based on scanned barcode input *)
PrintStickers[opts:OptionsPattern[]]:=Module[{safeOps, barcodes, dialogBoolean},

	safeOps=SafeOptions[PrintStickers, ToList[opts]];

	(* Generate a dialog window to take scanned input *)
	dialogBoolean=ChoiceDialog[
		Column[{
			InputField[Dynamic[barcodes], String, ImageSize -> {300, Automatic}]
		}, Alignment -> Center],
		{" Print " -> True, " Cancel " -> False},
		WindowTitle -> "Scan barcodes for stickers to be reprinted",
		NotebookEventActions -> {
			"EscapeKeyDown" :> DialogReturn[False],
			"WindowClose" :> DialogReturn[False],
			"ReturnKeyDown" :> DialogReturn[True]
		},
		Initialization :> (FrontEndExecute[{
			FrontEnd`SelectionMove[#1, Before, Notebook, AutoScroll -> False],
			FrontEnd`SelectionMove[#1, Next, Cell, 2, AutoScroll -> False],
			FrontEnd`SelectionMove[#1, Previous, CellContents, AutoScroll -> False],
			FrontEnd`FrontEndToken[#1, "MovePreviousPlaceHolder"]
		}]&)
	];

	(* Print stickers for scanned input *)
	If[dialogBoolean && MatchQ[barcodes, BarcodeP | RepeatedBarcodeP],
		PrintStickers[ToObject[barcodes], Sequence @@ safeOps],
		$Canceled
	]

];


(* --- Barcode or raw ID input --- *)
PrintStickers[barcodeInput:{BarcodeP..} | BarcodeP | RepeatedBarcodeP, ops:OptionsPattern[PrintStickers]]:=Module[{
	objects
},
	objects=ToObject[barcodeInput];

	(* Unless the input is a list of raw IDs, pass to PrintStickers. *)
	If[!MatchQ[ToList[objects], {$Failed..}],
		PrintStickers[objects, ops],
		Module[{safeOps, incomingCache, objectsList, stickerModels, stickerModelPackets, updatedCache, updatedOps, resolvedOps, stickerTexts},

			safeOps=SafeOptions[PrintStickers, ToList[ops]];

			(* Extract cached Download packets that have been passed in *)
			incomingCache=Lookup[safeOps, Cache];

			(* Make sure that singleton input is wrapped in a list before continuing *)
			objectsList=ToList[barcodeInput];

			(* Since we don't know the resolved sticker models at this point, download all the sticker models (there are only 4). *)
			stickerModels=Search[Model[Item, Sticker]];

			(* Download the sticker models *)
			stickerModelPackets=Download[Join[stickerModels], Cache -> incomingCache];

			(* Add the packets downloaded above to the cache that was passed in *)
			updatedCache=DeleteCases[
				Union[incomingCache, stickerModelPackets],
				Null
			];

			(* Replace the old Cache option with the updated version above *)
			updatedOps=ReplaceRule[safeOps, Cache -> updatedCache];

			(* Resolve options *)
			resolvedOps=resolvePrintStickersOptions[objectsList, stickerModelPackets, Object, updatedOps];

			(* If options resolution has failed, return $Failed for the entire printing operation *)
			If[MatchQ[resolvedOps, $Failed],
				Return[$Failed]
			];

			(* Generate sticker text for Object stickers *)
			stickerTexts=Map[{"", #, ""}&, objectsList];

			(* Pass to core function *)
			printStickersCore[objectsList, objectsList, stickerTexts, PassOptions[PrintStickers, printStickersCore, resolvedOps]]
		]
	]


];


(* ::Subsubsection::Closed:: *)
(*assembleStickerInformation*)
$WordList:=$WordList=Import[FileNameJoin[{PackageDirectory["ExternalInventory`"],"resources","wordlist.txt"}], "List"];

generateNumberAndWord::MalformedInput="The input \"`1`\" is not a valid ID or list of IDs. Please revise.";

(* Core overload matching any valid SLL ID *)
generateNumberAndWord[myID:ObjectIDP]:=Module[{hash, number, word, finalNumber},

	hash=Hash[myID, "SHA"];

	number=Mod[hash, 100];
	word=$WordList[[Mod[hash, Length[$WordList]-1]+1]];

	(* Avoid 69 and 88 as numbers. *)
	finalNumber=If[MatchQ[number, 69|88],
		number+1,
		number
	];

	ToString[finalNumber] <> " " <> Capitalize[word]
];

(* Handle trailing positions automatically by dropping the position (e.g. "id:xyz[A1]" -> "id:xyz") *)
generateNumberAndWord[myIDWithPosition:_String?(StringMatchQ[#,ObjectIDStringP~~"["~~Alternatives[WordCharacter," "]..~~"]"]&)]:=generateNumberAndWord[First[StringCases[myIDWithPosition,ObjectIDStringP]]];

(* Handle surrounding whitespace automatically by dropping it (e.g. " id:xyz " -> "id:xyz") *)
generateNumberAndWord[myIDWithWhitespace:_String?(StringStartsQ[#,WhitespaceCharacter]||StringEndsQ[#,WhitespaceCharacter]&)]:=generateNumberAndWord[StringTrim[myIDWithWhitespace]];

(* Listable form *)
generateNumberAndWord[myIDs_List]:=Map[
	generateNumberAndWord,
	myIDs
];

(* Throw clear error for any other inputs *)
generateNumberAndWord[malformedInput_]:=(Message[generateNumberAndWord::MalformedInput,malformedInput];$Failed);

(* --- Given the sticker type and objects for which stickers will be printed, extracts and formats information that will appear on the stickers --- *)
Authors[assembleStickerInformation]:={"ben", "olatunde.olademehin"};
(* Overload for Object stickers *)
assembleStickerInformation[inputPackets:{PacketP[]..}, modelPackets:{(PacketP[] | Null)..}]:=Module[
  {inputIDs, inputNames, modelNames, stickerNames, descriptionText},

  (* These should not require database access so do not need Cache *)
  inputIDs=Lookup[inputPackets, ID];

  (* Extract the names of the inputs and their models *)
  (* Replace any Null Models with {} to allow for Lookup defaulting and retain index matching *)
  inputNames=Lookup[inputPackets, Name];
  modelNames=Lookup[Replace[modelPackets, Null -> {}, {1}], Name, Null];

  (* Select the name that will appear on the sticker for each object, preferring Name to Model[Name];
    If Name is Null or an auto-generated "LegacyID:xxxx", use Model[Name];
    If Model[Name] is Null, use "" *)
  stickerNames=MapThread[
    Which[
      Nor[NullQ[#1], StringMatchQ[#1, ("LegacyID:"~~___)]], #1,
      !NullQ[#2], #2,
      True, ""
    ]&,
    {inputNames, modelNames}
  ];

  (* Gather three-line lists of description text for each input *)
  descriptionText=Transpose[{generateNumberAndWord[Lookup[inputPackets, ID]], stickerNames, inputIDs}];

  {Lookup[inputPackets, ID], descriptionText}
];

(* Overload for Destination stickers -- takes an extra input for which positions and/or plumbing connectors should be printed*)
assembleStickerInformation[inputPackets:{PacketP[]..}, modelPackets:{(PacketP[] | Null)..}, destinations:All | {{_String..}..}]:=Module[
	{inputTypes, inputIDs, modelPositions, modelPositionNames,
		inputIDsExpandedAndFlattened, descriptionText, barcodeText, selectedPositionNames, objectsExpandedAndFlattened,
		selectedPositionNamesFlattened, descriptionTextReordered, modelObjects, modelObjectsExpandedAndFlattened,
		modelConnectors, modelConnectorNames, modelWiringConnectors, modelWiringConnectorNames, allDestinationNames},

	inputTypes=ToString /@ Lookup[inputPackets, Type];
	inputIDs=Lookup[inputPackets, ID];
	modelObjects=Lookup[modelPackets, Object];

	(* Extract the list of position names for each input from its model *)
	modelPositions=Lookup[modelPackets, Positions, {}];
	modelConnectors=Lookup[modelPackets, Connectors, {}];
	modelWiringConnectors=Lookup[modelPackets, WiringConnectors, {}];
	modelPositionNames=Lookup[#, Name, {}]& /@ modelPositions;
	modelConnectorNames=#[[All, 1]]& /@ modelConnectors;
	modelWiringConnectorNames=#[[All, 1]]& /@ modelWiringConnectors;
	allDestinationNames=MapThread[Join, {modelPositionNames, modelConnectorNames, modelWiringConnectorNames}];

	(* Only move forward with those destinations that have been specified in the Positions option *)
	selectedPositionNames=If[!MatchQ[destinations, All],
		MapThread[Intersection, {allDestinationNames, destinations}],
		allDestinationNames
	];
	selectedPositionNamesFlattened=Flatten[selectedPositionNames, 1];

	(* Expand ID and Model lists to match the lengths of the destinations lists *)
	inputIDsExpandedAndFlattened=Flatten[MapThread[
		Repeat[#1, Length[#2]]&,
		{inputIDs, selectedPositionNames}
	]];
	modelObjectsExpandedAndFlattened=Flatten[MapThread[
		Repeat[#1, Length[#2]]&,
		{modelObjects, selectedPositionNames}
	]];
	objectsExpandedAndFlattened=Flatten@MapThread[ConstantArray[#1, Length[#2]]&, {inputIDs, selectedPositionNames}];


	(* Gather three-line lists of description text for each position *)
	descriptionText=Transpose[{
		generateNumberAndWord[Flatten@MapThread[ConstantArray[#1, Length[#2]]&, {inputIDs, selectedPositionNames}]],
		selectedPositionNamesFlattened,
		inputIDsExpandedAndFlattened
	}];

	(* If printing destination stickers for VLM racks, reorder sticker text to place the position name on the bottom line
		next to the barcode so that both will be readable from the front when the position sticker is wrapped around the rack *)
	descriptionTextReordered=MapThread[
		If[SameObjectQ[#1, Model[Container, Rack, "id:7X104vK9ZZap"]],
			{#2[[2]], #2[[3]], #2[[1]]},
			#2
		]&,
		{modelObjectsExpandedAndFlattened, descriptionText}
	];

	(* Generate destination barcode string for each position, in the form 'id:asdfasdf[PositionName]' *)
	(* Use pre-reordering description text so that all sets of text are in the same order *)
	barcodeText=Map[
		StringJoin[#[[3]], "[", #[[2]], "]"]&,
		descriptionText
	];

	(* Return completed sticker info *)
	{objectsExpandedAndFlattened, barcodeText, descriptionTextReordered}

];


(* ::Subsubsection::Closed:: *)
(*resolvePrintStickersOptions*)

Authors[resolvePrintStickersOptions]:={"ben", "olatunde.olademehin"};

resolvePrintStickersOptions[
	{ObjectP[]..} | {{_String?(StringLength[#1] > 0 &)..}, {{Repeated[_String, {3}]}..}} | ListableP[BarcodeP],
	allStickerModelPackets:{PacketP[Model[Item, Sticker]]..},
	stickerType:StickerTypeP,
	ops:{_Rule...}
]:=Module[
	{stickerSizeOption, stickerModelOption, resolvedStickerSize,
		resolvedStickerModel, resolvedOptions, stickerModelPacket},

	stickerSizeOption=Lookup[ops, StickerSize];
	stickerModelOption=Lookup[ops, StickerModel];

	(* If StickerModel has been specified as an ObjectReference, extract its packet from cache *)
	stickerModelPacket=Switch[stickerModelOption,
		ObjectReferenceP[] | LinkP[], FirstCase[allStickerModelPackets, KeyValuePattern[Object -> (stickerModelOption[Object])]],
		PacketP[], stickerModelOption,
		Automatic, Null
	];


	(* --- Resolve StickerSize --- *)

	resolvedStickerSize=Module[{},


		If[
			(* If the StickerSize is Piggyback and the StickerType is Destination, throw an error and return $Failed *)
			Or[
				MatchQ[stickerSizeOption,Piggyback] && MatchQ[stickerType, Destination],
				MatchQ[stickerModelPacket,Except[Null]] && MatchQ[Lookup[stickerModelPacket, StickerSize], Piggyback] && MatchQ[stickerType,Destination]
			],
			(
				Message[PrintStickers::StickerSizeTypeMismatch];
				$Failed
			),
			(* Otherwise, resolve the sticker size *)
			Switch[
				{stickerSizeOption, stickerModelOption},

				(* If StickerSize has been specified and model has not, go with specified sticker size *)
				{Except[Automatic], Automatic}, stickerSizeOption,

				(* If StickerSize is Automatic and StickerModel has been specified, resolve StickerType *)
				{Automatic, Except[Automatic]}, Lookup[stickerModelPacket, StickerSize],

				(* If both StickerSize and StickerModel have been specified, verify that they match; if they don't, display a message and return $Failed *)
				{Except[Automatic], Except[Automatic]}, If[!MatchQ[stickerSizeOption, Lookup[stickerModelPacket, StickerSize]],
				(Message[PrintStickers::StickerModelSizeMismatch, stickerSizeOption, stickerModelOption];$Failed),
				stickerSizeOption
			],

				(* If both StickerSize and StickerModel are Automatic, default to Small stickers *)
				{Automatic, Automatic}, Small
			]
		]
	];


	(* --- Resolve StickerModel --- *)

	(* If StickerModel has been specified, return it; otherwise, select the appropriate model based on resolved size and type,
	then extract its packet from the sticker model packets passed in as input *)
	resolvedStickerModel=If[MatchQ[stickerModelOption, Automatic],
		FirstCase[
			allStickerModelPackets,
			KeyValuePattern[
				Object -> FirstOrDefault[Search[Model[Item, Sticker], StickerType == stickerType && StickerSize == resolvedStickerSize]]
			]
		],
		stickerModelPacket
	];

	resolvedOptions=ReplaceRule[ops,
		{StickerSize -> resolvedStickerSize, StickerModel -> resolvedStickerModel}];

	(* If resolution of any option failed, return $Failed *)
	If[MemberQ[resolvedOptions[[All, 2]], $Failed],
		$Failed,
		resolvedOptions
	]
];


(* ::Subsubsection::Closed:: *)
(*drawSticker*)


Authors[drawSticker]:={"ben", "olatunde.olademehin"};

DefineOptions[
	drawSticker,
	SharedOptions :> {
		PrintStickers
	}
];

$ShortStickerModels={
	Model[Container, Vessel, "id:M8n3rx03Ykp9"],
	Model[Container, Vessel, "id:o1k9jAG00e3N"],
	Model[Container, Vessel, "id:eGakld01zzpq"],
	Model[Container, Vessel, "id:3em6Zv9NjjN8"],
	Model[Container, Vessel, "id:mnk9jO3qDD4R"],
	Model[Container, Vessel, "id:jLq9jXvxr6OZ"],
	Model[Container, Vessel, "id:3em6ZvL8x4p8"]
};

(* Function to take barcode, description text, and sticker model and convert it into a sticker graphic *)
(* Since this function gets run for EVERY sticker that gets drawn, passing stickerPacket directly is faster than relying on cache *)
drawSticker[containerModel:(ObjectP[Model[Container]]|Null), barcodeText:_String?(StringLength[#1] > 0 &), textLines:{Repeated[_String, {3}]}, OptionsPattern[]]:=Module[
	{stickerWidth, stickerHeight, barcodePosition, barcodeMaxSize, barcodeType, textHorizontalPosition,
		textVerticalPosition, textBoxWidth, textSize, charLimit, textPitchY, barcodeImage, textAssociations,
		formattedText, barcodeInset, stickerPacket, fontFamily},

	(* --- Retrieve sticker parameters from model and make some basic decisions --- *)

	(* Extract other relevant options *)
	stickerPacket=OptionValue[StickerModel];
	fontFamily=OptionValue[FontFamily];

	(* Retrieve basic sticker dimensions from the selected model[Sticker] *)
	stickerWidth=Unitless[Lookup[stickerPacket, Width]];
	stickerHeight=Unitless[Lookup[stickerPacket, Height]];

	(* Retrieve barcode parameters *)
	barcodePosition={Unitless[Lookup[stickerPacket, BarcodeHorizontalPosition]], Unitless[Lookup[stickerPacket, BarcodeVerticalPosition]]};
	barcodeMaxSize=Unitless[Lookup[stickerPacket, {BarcodeMaxWidth, BarcodeMaxHeight}]];
	barcodeType=Lookup[stickerPacket, BarcodeType];

	(* Retrieve text parameters *)
	textHorizontalPosition=Unitless[Lookup[stickerPacket, TextHorizontalPosition]];
	textVerticalPosition=Unitless[Lookup[stickerPacket, TextVerticalPosition]];
	textBoxWidth=Unitless[Lookup[stickerPacket, TextBoxWidth]];
	textSize=Unitless[Lookup[stickerPacket, TextSize]];
	charLimit=Lookup[stickerPacket, CharacterLimit];
	textPitchY=Unitless[Lookup[stickerPacket, TextVerticalPitch]];


	(* --- Generate the individual components of the sticker --- *)


	(* Generate a barcode of the type specified by the sticker model *)
	barcodeImage=Switch[barcodeType,
		Barcode, BarcodeImage[barcodeText, "Code128", {100, 20}],
		QRCode, BarcodeImage[barcodeText, "QRCode"],
		DataMatrix, encodeDataMatrix[barcodeText, Automatic, Automatic, "Automatic"],
		DataMatrixRectangle, encodeDataMatrix[barcodeText, Automatic, Automatic, "Rectangle"],
		DataMatrixSquare, encodeDataMatrix[barcodeText, Automatic, Automatic, "Square"]
	];


	(* Embed the barcode in an inset that will position and scale it properly based on the selected sticker model *)
	barcodeInset=generateBarcodeInset[barcodeImage, barcodePosition, barcodeMaxSize];

	(* Generate lines of text for the sticker as Associations with "Text" and "TextSize" keys *)
	textAssociations=Switch[OptionValue[TextScaling],

		(* If TextScaling -> Scale, leave text alone and determine a scaling factor that will allow it all to fit *)
		Scale,
		MapIndexed[
			<|
				"Text" -> #,
				"TextSize" -> If[StringLength[#] == 0,
					Scaled[textSize],
					(* NOTE: If we're right aligning, we need to take into account our 6.9 mm shift for 2mL Tubes. *)
					If[MatchQ[First[#2], 2|3] && MatchQ[containerModel, ObjectP[$ShortStickerModels]],
						Scaled[Min[(1.4 * ((textBoxWidth - 6.9) / stickerWidth)) / (StringLength[#]), textSize]],
						Scaled[Min[(1.4 * (textBoxWidth / stickerWidth)) / (StringLength[#]), textSize]]
					]
				]
			|>&,
			textLines
		],

		(* If TextScaling -> Crop, truncate each line to the character limit in the sticker model if necessary *)
		Crop,
		<|
			"Text" -> If[StringLength[#] > charLimit,
				StringTake[#, ;;charLimit],
				#
			],
			"TextSize" -> Scaled[textSize]
		|>& /@ textLines
	];

	(* Format all lines of text together for insetting into the sticker *)
	(* The Text graphics primitive's Position argument specifies where each line of text will be CENTERED *)
	(* NOTE: For this small object stickers with a catch phrase, we want to put the catch phrase on the left and the other info *)
	(* on the right. *)
	formattedText=If[MatchQ[OptionValue[StickerModel], ObjectP[Model[Item, Sticker, "id:mnk9jO3dexZY"]]],
		MapIndexed[
			Text[
				Style[
					#1["Text"],
					Plain,
					FontSize -> #1["TextSize"],
					FontFamily -> fontFamily,
					TextAlignment -> Center,
					(* NOTE: We should bold the hashphrase on the first line and the ID on the third line. *)
					FontWeight -> Switch[First[#2],
						1,
							"Bold",
						2,
							"Light",
						3,
							"Bold"
					]
				],
				{
					Which[
						MatchQ[First[#2], 1],
							barcodeMaxSize[[1]],
						(* This is because for Model[Container, Vessel, "2mL Tube"] we have to  move the right aligned text to the *)
						(* left since operators cut off the ends of the stickers to make them fit on the tube. The 6.9 mm number comes *)
						(* from empirical measurement of how much of the sticker they usually cut off (plus a small buffer). *)
						MatchQ[containerModel, ObjectP[$ShortStickerModels]],
							stickerWidth - 6.9,
						True,
							stickerWidth
					],
					textVerticalPosition - textPitchY * (First[#2] - 1)
				},
				{If[MatchQ[First[#2], 1], Left, Right], Center}
			]&,
			textAssociations
		],
		MapIndexed[
			Text[
				Style[#1["Text"], Bold, FontSize -> #1["TextSize"], FontFamily -> fontFamily, TextAlignment -> Center],
				{textHorizontalPosition, textVerticalPosition - textPitchY * (First[#2] - 1)}
			]&,
			textAssociations
		]
	];

	(* Assemble the sticker elements on an appropriately sized background and return the resulting Graphics object *)
	Graphics[
		{
			FaceForm[White],
			If[TrueQ[OptionValue[Border]],
				EdgeForm[Black],
				Nothing
			],
			Rectangle[{0, 0}, {stickerWidth, stickerHeight}],
			barcodeInset,
			Sequence @@ formattedText
		},
		PlotRange -> {{0, stickerWidth}, {0, stickerHeight}}
	]

];

Authors[generateBarcodeInset]:={"ben", "olatunde.olademehin"};
(* Assemble an inset that will position and size the barcode image according to parameters in the sticker model *)
generateBarcodeInset[barcodeImage_Image, positionOnSticker:{NumericP, NumericP}, maxSizeOnSticker:{NumericP, NumericP}]:=Module[
	{barcodeTransparent, barcodeCenter},

	(* Make all the white space transparent so the borcode will scale properly without interpolation distortion *)
	barcodeTransparent=SetAlphaChannel[barcodeImage, ColorNegate[Binarize[barcodeImage]]];

	(* Calculate the center point of the barcode image *)
	barcodeCenter=ImageDimensions[barcodeTransparent] / 2;

	(* Generate the inset; barcodes are positioned on the sticker using their center as the anchor point *)
	Inset[barcodeTransparent, positionOnSticker, barcodeCenter, maxSizeOnSticker]

];


(* ::Subsubsection::Closed:: *)
(*encodeDataMatrix (Private)*)


Authors[encodeDataMatrix]:={"ben", "olatunde.olademehin"};
(* This function was written by Wolfram to enable us to generate DataMatrix codes of defined shape *)

encodeDataMatrix[data_?StringQ, minSize_:Automatic, maxSize_:Automatic, shape_:Automatic]:=Module[
	{res, raster, minDimension, maxDimension, hints, pixels, image, minWidth, minHeight,
		maxWidth, maxHeight, height, width},

	hints=Null;

	Check[Needs["JLink`"], Return[$Failed]];

	JLink`InstallJava[];

	JLink`JavaBlock[
		(* load Java files missing in 13.3.1 *)
		loadJavaFiles[];
		JLink`LoadJavaClass["com.wolfram.zxing.ZxingClient"];
		JLink`LoadJavaClass["com.wolfram.jlink.JLinkClassLoader"];
		JLink`LoadJavaClass["com.google.zxing.EncodeHintType"];
		JLink`LoadJavaClass["com.google.zxing.datamatrix.encoder.SymbolShapeHint"];
		hints=JLink`JavaNew[
			JLink`LoadJavaClass["java.util.EnumMap"],
			JLinkClassLoader`classFromName["com.google.zxing.EncodeHintType"]
		];

		If[VectorQ[minSize, Internal`PositiveMachineIntegerQ] && Length[minSize] === 2,
			{minWidth, minHeight}=minSize;
			minDimension=JLink`JavaNew[JLink`LoadJavaClass["com.google.zxing.Dimension"], minWidth, minHeight];
			hints@put[EncodeHintType`MINUSIZE, minDimension];
		];

		If[VectorQ[maxSize, Internal`PositiveMachineIntegerQ] && Length[maxSize] === 2,
			{maxWidth, maxHeight}=maxSize;
			maxDimension=JLink`JavaNew[JLink`LoadJavaClass["com.google.zxing.Dimension"], maxWidth, maxHeight];
			hints@put[EncodeHintType`MAXUSIZE, maxDimension];
		];

		Which[
			shape === "None", hints@put[EncodeHintType`DATAUMATRIXUSHAPE, SymbolShapeHint`FORCEUNONE],

			shape === "Square", hints@put[EncodeHintType`DATAUMATRIXUSHAPE, SymbolShapeHint`FORCEUSQUARE],

			shape === "Rectangle", hints@put[EncodeHintType`DATAUMATRIXUSHAPE, SymbolShapeHint`FORCEURECTANGLE]
		];

		(*width and height parameters in ZxingClient`encode are ignored for DataMatrix*)
		image=ZxingClient`encode[data, "DATA_MATRIX", 1, 1, hints];

		If[image === $Failed,
			Return[$Failed]
		];

		raster=image@getRaster[];

		If[raster === $Failed,
			Return[$Failed]
		];

		height=image@getHeight[];
		width=image@getWidth[];
		pixels=raster@getPixels[0, 0, width, height, JLink`JavaNew["[I", width * height]];

		If[pixels === $Failed,
			Return[$Failed]
		];

		res=ImageCrop[
			ImagePad[
				Image[
					ArrayReshape[pixels, {height, width}],
					"Bit"
				],
				1,
				White
			]
		];

		Return[res]
	]
];



Authors[assembleStickerSheets]:={"ben", "olatunde.olademehin", "zechen.zhang"};

DefineOptions[
	assembleStickerSheets,
	SharedOptions :> {
		PrintStickers
	}
];

(* Assembles a list of sticker graphics into an appropriately sized sheet to be sent to a Zebra label printer *)
assembleStickerSheets[stickerGraphics:{_Graphics..}, numberPerSet_Integer?Positive, OptionsPattern[]]:=Module[
	{stickerPacket, stickerWidth, stickerHeight, verticalPitch, horizontalMargin, verticalMargin,
		stickerGraphicsPartitioned, stickersPerPartition, stickerSheets, documents},

	stickerPacket=OptionValue[StickerModel];

	(* Extract required sticker parameters from the sticker model packet *)
	stickerWidth=Unitless[Lookup[stickerPacket, Width]];
	stickerHeight=Unitless[Lookup[stickerPacket, Height]];
	verticalPitch=Unitless[Lookup[stickerPacket, VerticalPitch]];
	horizontalMargin=Unitless[Lookup[stickerPacket, HorizontalMargin]];
	verticalMargin=Unitless[Lookup[stickerPacket, VerticalMargin]];

	(* Partition stickers into groups of the specified size *)
	stickerGraphicsPartitioned=PartitionRemainder[stickerGraphics, numberPerSet];
	stickersPerPartition=Length /@ stickerGraphicsPartitioned;

	(* Assemble the grouped stickers into sheets formatted for printing *)
	stickerSheets=Map[

		(* Map over the partitioned list of stickers, generating one "page" worth of stickers at a time *)
		Function[{batchOfStickers},

			(* For each batch of stickers to be printed on a single "page", create a set of sticker insets.
				Stickers all have the same horizontal position, but each subsequent sticker decreases in vertical
				position by the sticker model's vertical pitch, corresponding to a lower position on the printed page. *)
			MapIndexed[

				(* Use the map index (#2) to offset each sticker by the appropriate multiple of its model's vertical pitch *)
				Inset[#1,
					{horizontalMargin, -verticalMargin - stickerHeight - (First[#2] - 1) * verticalPitch},
					{0, 0},
					{stickerWidth, stickerHeight}
				]&, batchOfStickers
			]
		], stickerGraphicsPartitioned
	];

	(* Create and return a list of notebooks that hold each sticker sheet in a printer-ready form *)
	documents=MapThread[
		Module[
			{nb},
			nb=CreateDocument[
				Graphics[
					#1,
					(* Size each "page" appropriately for the number of stickers it holds *)
					PlotRange -> {{0, 207.264}, {-(verticalMargin + (verticalPitch * #2)), 0}},
					ImageSize -> 807
				],
				WindowTitle -> "Sticker Printing Output",
				Saveable -> False
			];
			CurrentValue[nb, {PrintingOptions, "PrintingMargins"}]={{0, 0}, {0, 0}};
			CurrentValue[nb, {PrintingOptions, "FirstPageFooter"}]=False;
			CurrentValue[nb, {PrintingOptions, "FirstPageHeader"}]=False;
			CurrentValue[nb, {PrintingOptions, "RestPagesFooter"}]=False;
			CurrentValue[nb, {PrintingOptions, "RestPagesHeader"}]=False;
			Which[
				MatchQ[OptionValue[StickerSize], Large],
				CurrentValue[nb, {PrintingOptions, "PaperSize"}] = {144, 90}; (* 2 inch x 1.25 inch*)
				CurrentValue[nb, {PrintingOptions, "PaperOrientation"}] = "Portrait",

				MatchQ[OptionValue[StickerSize], Small],
				CurrentValue[nb, {PrintingOptions, "PaperSize"}] = {116.64, 21.6}; (* 1.62 inch x 0.3 inch*)
				CurrentValue[nb, {PrintingOptions, "PaperOrientation"}] = "Portrait"
			];
			nb
		]&,
		{stickerSheets, stickersPerPartition}
	]

];


(* ::Subsubsection:: *)
(*PrintStickersCommandCenter*)


PrintStickersCommandCenter[input___]:=Module[{graphics, images, exportPaths},
	(* Call PrintStickers[input] with Output\[Rule]Graphics and Print\[Rule]False. *)
	graphics=PrintStickers[input, Output -> Graphics, Print -> False];

	(* Take those graphics and rasterize them using DPI 300 *)
	images=(Rasterize[#, ImageResolution -> 300, ImageSize -> {162, 23}, RasterSize -> 800]&) /@ graphics;

	(* Create export paths for these images *)
	exportPaths=(FileNameJoin[{$TemporaryDirectory, ToString[#]<>".png"}]&) /@ Range[Length[images]];

	(* Export each of our images to these paths *)
	MapThread[(Export[#1, #2]&), {exportPaths, images}];

	(* Return the paths of our exported images *)
	exportPaths
];