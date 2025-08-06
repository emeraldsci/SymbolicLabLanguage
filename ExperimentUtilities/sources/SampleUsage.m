(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*SampleUsage*)


(* ::Subsubsection:: *)
(*SampleUsage Options*)


DefineOptions[SampleUsage,
	Options :> {
		{
			OptionName -> Messages,
			Default -> True,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "When True, prints any messages SampleUsage generates."
		},
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, Association]],
			Description -> "Determines if the function returns a table for all the information, or an association with the same information."
		},
		{
			OptionName -> Author,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type -> Object, Pattern :> ObjectP[Object[User]]],
				Adder[
					Widget[Type -> Object, Pattern :> ObjectP[Object[User]]]
				]
			],
			Description -> "The user(s) who authored the notebook associated with the specified objects given in the input primitives. Multiple authors can be specified.",
			ResolutionDescription -> "Automatically resolves to $PersonID."
		},
		{
			OptionName -> InventoryComparison,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "When True, checks the user's and the public inventory for the remaining amount of sample objects that share the same model as the input objects."
		},
		CacheOption
	}
];


(* ::Subsubsection:: *)
(*SampleUsage Messages*)


Warning::InvalidPrimitiveType="The primitive(s) at index `1` does not have the type Transfer, Aliquot, Consolidation, Resuspend, FillToVolume, or Define. The usage amount will only be calculated from primitives with valid manipulation type.";
Warning::InvalidPrimitiveKeyValue="The value of the following key(s) defined in the primitive at index `1` have invalid pattern that may affect the usage amount calculation: `2`. Please check the definition of the primitive in question.";
Warning::InvalidAmountLength="The amount(s) specified in the primitive at index `1` have invalid lengths that do not match with Sources or Destinations. Please check the definition of the primitive in question and specify amounts with correct lengths";
Warning::InvalidNameReference="The names `1` used in primitives at index `2` do not have an associated Define primitive that establishes the name. Please define any used names using a Define primitive.";
Error::NoValidPrimitives="There is no valid primitive to use for usage amount calculation.";
Warning::FillToVolumePrimitiveIncluded="Usage volume calculation for FillToVolume primitives may not be accurate due to possible density changes during manipulation.";
Warning::MissingObjects="Unable to find object(s) `1` in the database. Please check for errors in the object IDs or names.";
Error::NoValidObjectsToUse="There is no valid object to use for usage amount calculation.";
Warning::ExcessDestinationVolume="The primitive at index `1` has Destination volume of `2` that exceeds the specified FinalVolume.";
Warning::SamplesMarkedForDisposal="The following object(s) specified are flagged for disposal: `1`. If you don't wish to dispose of these samples, please run CancelDiscardSamples on them.";
Warning::DiscardedSamples="The following object(s) specified are discarded: `1`.";
Warning::ExpiredSamples="The following sample objects are marked expired: `1`.";
Warning::SamplesWithDeprecatedModels="The following sample object(s) specified have models that are deprecated: `1`. Please check the Deprecated field for the models in question, or provide samples with alternative models.";
Warning::DeprecatedSpecifiedModels="The following model object(s) specified are deprecated: `1`.  Please check the Deprecated field for the models in question, or provide non-deprecated models.";
Warning::SamplesNotOwned="The following object(s) specified are not part of a Notebook financed by one of the current financing teams: `1`. Please check the Notebook field of these objects and the Financers field of that Notebook; if they are public, please purchase these items before directly requesting them in an Experiment.";
Warning::InsufficientSampleAmount="The amount of `1` is not sufficient to perform the manipulation at index `2` and all subsequent manipulations. Please check the sample in question, or provide a new sample with sufficient amount.";


(* ::Subsubsection:: *)
(*SampleUsage*)


(* Singleton overload, taking only one SampleManipulation primitive *)
SampleUsage[myPrimitive:SampleManipulationP, ops:OptionsPattern[]]:=SampleUsage[{myPrimitive}, ops];

(* Core overload, taking a list of SampleManipulation primitives *)
SampleUsage[myPrimitives:{SampleManipulationP..}, ops:OptionsPattern[]]:=Module[
	{
		safeOps, messages, output, author, cache, inventoryCheck, definePrimitives, definedNamesLookup,
		definedNameReferences, invalidDefinedNameReferences, primitivesWithInvalidDefinedNames, invalidPrimitives,
		validPrimitives, defineReplaceRules, resolvedPrimitives, allObjsFromPrimitives, objRefReplaceRules, resolvedPrimitivesWithRefs,
		containerInputs, containerReplaceRules, transferAndFillToVolumeRules, sampleToAmountAssociationWithContainers, objsToRemove,
		keysToDrop, sampleToAmountAssociation, objPacketsToUse, objNamesToUse, objRefList, resultsToDisplay, validPrimitiveIndices,
		primitiveToPositionRules, resolvedReplaceRules, specifiedModelPackets, samplesModelPackets, modelsToSearchNoDupes,
		notebooksFromPackets, primitivesWithAmountKey, validPrimitiveTypeBools, invalidPrimitivePosition, primitivesWithInvalidType,
		primitiveKeyValidityRules, invalidKeyValuesPickList, primitivesWithInvalidKeys, fillToVolumePrimitives, sourceObjects,
		transferPrimitiveObjs, resultTuplesWithNoNames, resultTuplesWithNames, sortedResultsTuples, transferPrimitiveObjsNoModel,
		fillToVolumeObjs, fillToVolumeObjsNoModel, objsToTest, databaseMember, missingObjs, objsToUse, objsToUseWithAuthors, allFields,
		allPackets, newCache, allPacketsNoNotebook, financerPackets, fillToVolumeRules, totalUsageList, samplePackets, modelToSampleReplaceRules,
		allModelPackets, notDisposalBool, disposalSamples, notDiscardedBool, discardedSamples, expiredBool, expiredSamples,
		deprecatedSpecifiedModels, samplesWithDeprecatedModel, allAllowedNotebooks, samplesNotebook, notOwnedSamplesBools,
		notOwnedSamples, modelsToSearch, searchConditions, typesToSearch, searchResults, allPacketsNew, groupedPackets, publicPackets,
		ownedPackets, publicAmountPerModel, ownedAmountPerModel, waterModelReplaceRules, allModelReplaceRules, modelToAmountsReplaceRules,
		sampleToModelReplaceRules, modelsOfObjsToDisplay, resultsToPlot, primitiveToUsageRules, updatedPrimitiveToUsageValues,
		resolvedPrimitiveToUsageValues, updatedPrimitiveToUsageRules, sampleToInventoryRules, primitiveWithInsufficientSamples,
		firstPrimitiveWithInsufficientSamples, positionsWithInsufficientSamples, inventoriedAmounts, usersInitialAmount, publicAmount,
		amountPostManipulation, usersFinalAmount, usersFinalScaledAmount, additionalDefineReplaceRules, updatedDefineReplaceRules,
		definedNameToRefRules, definedNameRulesNoWells, definedNameLookupRules, definedNameLookup, definedNameLookupAssociation,
		definedNameList, finalizedDefinedNameList, resultsAssociation, tableHeadings, resolvedAuthor, allSampleModels, publicModelPackets,
		ownedModelPackets, modelToInventoryRules, expandVolume, primitivesWithExpandedAmount, mismatchedAmountLengthBools,
		invalidAmountPositions, primitivesWithInvalidAmountLength, primitivesWithConvertedTransfer, primitivesWithConvertedResuspend,
		samplesInitialAmount, modelList, modelNameList, samplesAmountRules, objsToDisplay, deprecatedModels, samplesWithoutModelReplaceRules,
		finalAmountReplaceRules, resultKeys, transferSampleToAmountRules
	},

	(* get the safe options and pull out the OutputFormat option *)
	safeOps=SafeOptions[SampleUsage, ToList[ops]];
	{messages, output, author, cache, inventoryCheck}=Lookup[safeOps, {Messages, OutputFormat, Author, Cache, InventoryComparison}];

	resolvedAuthor=If[MatchQ[author, Automatic],
		$PersonID,
		author
	];
	(* ------------------------------------------------------ *)
	(* ----------MANIPULATION TYPE VALIDATION CHECK---------- *)
	(* ------------------------------------------------------ *)

	(* Check if the input primitives have the types that are supported by the SampleUsage function *)
	validPrimitiveTypeBools=Map[
		Switch[#,
			Alternatives[_Transfer, _Aliquot, _Consolidation, _Resuspend, _FillToVolume, _Define], True,
			_, False
		]&,
		myPrimitives
	];

	(* get the positions of the invalid input primitives *)
	invalidPrimitivePosition=Flatten[Position[validPrimitiveTypeBools, False]];

	(* throw a warning message indicating the index of the given invalid primitives *)
	If[messages && Not[MatchQ[invalidPrimitivePosition, {}]],
		Message[Warning::InvalidPrimitiveType, invalidPrimitivePosition]
	];

	(* get the invalid primitives *)
	primitivesWithInvalidType=PickList[myPrimitives, validPrimitiveTypeBools, False];

	(* ----------------------------------------------------- *)
	(* ----------EXPAND PRIMITIVES WITH AMOUNT KEY---------- *)
	(* ----------------------------------------------------- *)

	(* we still allow the Amount key to be specified as legacy Volume key; convert everything to Amount/Amounts
	 	for ease of use internally; currently, only Transfer/Aliquot/Consolidation allow initial Volume(s) key use *)

	(* a helper function to expand values under Amount key to match the length sources or destinations *)
	expandVolume[amount_, length_]:=If[ListQ[amount], amount, Table[amount, Length[length]]];

	(* expand amounts in Transfer/Aliquot/Consolidation primitives *)
	primitivesWithExpandedAmount=Map[
		Switch[#,
			_Transfer,
			If[!MissingQ[#[Volume]],
				Transfer[Append[KeyDrop[First[#], Volume], Amount -> #[Volume]]],
				#
			],
			_Aliquot,
			If[!MissingQ[#[Volumes]],
				Head[#][Append[KeyDrop[First[#], Volumes], Amounts -> expandVolume[#[Volumes], #[Destinations]]]],
				Head[#][Append[KeyDrop[First[#], Volumes], Amounts -> expandVolume[#[Amounts], #[Destinations]]]]
			],
			_Consolidation,
			If[!MissingQ[#[Volumes]],
				Head[#][Append[KeyDrop[First[#], Volumes], Amounts -> expandVolume[#[Volumes], #[Sources]]]],
				Head[#][Append[KeyDrop[First[#], Volumes], Amounts -> expandVolume[#[Amounts], #[Sources]]]]
			],
			_,
			#
		]&,
		myPrimitives
	];

	(* ---------------------------------------------------------------- *)
	(* ----------PRIMITIVE KEY VALUE PATTERN VALIDATION CHECK---------- *)
	(* ---------------------------------------------------------------- *)

	(* Check if the relevant key to use in SampleUsage are specified correctly for each primitive type *)
	(* check the patterns of the keys in the provided manipulations to ensure validity *)
	(* Return a list of rules. Key points to False has value with invalid pattern *)
	primitiveKeyValidityRules=Map[
		Function[primitive,
			Switch[primitive,
				_Transfer,
				{
					Source -> MatchQ[primitive[Source], ListableP[Lookup[Experiment`Private`manipulationKeyPatterns[Transfer], Source]]],
					Amount -> MatchQ[primitive[Amount], ListableP[Lookup[Experiment`Private`manipulationKeyPatterns[Transfer], Amount]]]
				},

				_Aliquot,
				{
					Source -> MatchQ[primitive[Source], Lookup[Experiment`Private`manipulationKeyPatterns[Aliquot], Source]],
					Amounts -> MatchQ[primitive[Amounts], Lookup[Experiment`Private`manipulationKeyPatterns[Aliquot], Amounts]]
				},

				_Consolidation,
				{
					Sources -> MatchQ[primitive[Sources], Lookup[Experiment`Private`manipulationKeyPatterns[Consolidation], Sources]],
					Amounts -> MatchQ[primitive[Amounts], Lookup[Experiment`Private`manipulationKeyPatterns[Consolidation], Amounts]]
				},

				_Resuspend,
				{
					Volume -> MatchQ[primitive[Volume], Lookup[Experiment`Private`manipulationKeyPatterns[Resuspend], Volume]],
					If[MatchQ[primitive[Diluent], _Missing],
						Nothing,
						Diluent -> MatchQ[primitive[Diluent], Lookup[Experiment`Private`manipulationKeyPatterns[Resuspend], Diluent]]
					]
				},

				_FillToVolume,
				{
					Source -> MatchQ[primitive[Source], Lookup[Experiment`Private`manipulationKeyPatterns[FillToVolume], Source]],
					Destination -> MatchQ[primitive[Destination], Lookup[Experiment`Private`manipulationKeyPatterns[FillToVolume], Destination]],
					FinalVolume -> MatchQ[primitive[FinalVolume], Lookup[Experiment`Private`manipulationKeyPatterns[FillToVolume], FinalVolume]]
				},

				_Define,
				Map[
					Function[key,
						If[MatchQ[primitive[key], _Missing],
							Nothing,
							key -> MatchQ[primitive[key], Lookup[Experiment`Private`manipulationKeyPatterns[Define], key]]
						]
					],
					{Name, Sample, Container, Well, ContainerName, Model}
				],

				_,
				{}
			]
		],
		primitivesWithExpandedAmount
	];

	(* create a pick list to select primitives that have at least one invalid key value *)
	invalidKeyValuesPickList=Map[Apply[And, Values[#]]&, primitiveKeyValidityRules];

	(* Get the list of primitives with invalid key value *)
	primitivesWithInvalidKeys=PickList[primitivesWithExpandedAmount, invalidKeyValuesPickList, False];

	(* Throw a message if invalid key value patterns exist in our input primitives *)
	If[messages && Not[MatchQ[primitivesWithInvalidKeys, {}]],
		MapThread[
			Function[{bool, rules, index},
				If[Not[bool],
					Message[Warning::InvalidPrimitiveKeyValue,
						{index},
						PickList[rules[[All, 1]], rules[[All, 2]], False]
					]
				]
			],
			{invalidKeyValuesPickList, primitiveKeyValidityRules, Range[Length[primitivesWithExpandedAmount]]}
		]
	];

	(* -------------------------------------------------- *)
	(* ----------CONVERT RESUSPEND PRIMITIVE------------- *)
	(* -------------------------------------------------- *)

	(* convert all Resuspend primitives to Transfer for easy handling *)
	primitivesWithConvertedResuspend=Map[
		Switch[#,
			(* get only the converted Transfer primitive which is at index 1 *)
			_Resuspend, resuspendToTransferPrimitive[#][[1]],
			_, #
		]&,
		primitivesWithExpandedAmount
	];

	(* -------------------------------------------------- *)
	(* ----------AMOUNT LENGTH VALIDATION CHECK---------- *)
	(* -------------------------------------------------- *)

	(* call toFormattedTransferPrimitive as a mean to check matching amount length with Source or Destination *)
	(* convertTransfer works with all valid input format except Transfer primitive with amount length mismatch *)
	(* we simply check if MapThread error message is thrown from convertTransfer primitive *)

	primitivesWithConvertedTransfer=Map[
		Switch[#,
			_Transfer,
			Quiet[Check[
				Experiment`Private`toFormattedTransferPrimitive[#],
				$Failed,
				{MapThread::mptc}
			]],
			_, #
		]&,
		primitivesWithConvertedResuspend
	];

	(* check if the length of amount after expansion matches the length of sources or destinations *)
	mismatchedAmountLengthBools=Map[
		Switch[#,
			$Failed, True,
			_Aliquot, !MatchQ[Length[#[Destinations]], Length[#[Amounts]]],
			_Consolidation, !MatchQ[Length[#[Sources]], Length[#[Amounts]]],
			_, False
		]&,
		primitivesWithConvertedTransfer
	];

	(* get the positions of the input primitives with invalid amount length *)
	invalidAmountPositions=Flatten[Position[mismatchedAmountLengthBools, True]];

	(* throw a warning message indicating the index of the given invalid primitives *)
	If[messages && Not[MatchQ[invalidAmountPositions, {}]],
		Message[Warning::InvalidAmountLength, invalidAmountPositions]
	];

	(* get the invalid primitives *)
	primitivesWithInvalidAmountLength=PickList[primitivesWithConvertedResuspend, mismatchedAmountLengthBools, True];

	(* ---------------------------------------------- *)
	(* ----------HANDLING DEFINE PRIMITIVES---------- *)
	(* ---------------------------------------------- *)

	(* if not, throw a warning message, flag as invalid, and exclude *)

	(* get the Define primitives from our input primitives *)
	definePrimitives=Cases[primitivesWithConvertedResuspend, _Define];

	(* build association lookup of "Name" -> Define primitive *)
	definedNamesLookup=Association@Flatten@Map[
		{
			(#[Name] -> #),
			If[MatchQ[#[SampleName], _String],
				#[SampleName] -> #,
				Nothing
			],
			If[MatchQ[#[ContainerName], _String],
				#[ContainerName] -> #,
				Nothing
			]
		}&,
		definePrimitives
	];

	(* for any primitives that use a name, extract the referenced name *)
	definedNameReferences=Map[
		Switch[#,
			Alternatives[_Transfer, _FillToVolume],
			Cases[{#[Source], #[Destination]}, (name_String | {name_String, WellPositionP}) :> name, {1}],

			_Aliquot,
			Cases[Append[#[Destinations], #[Source]], (name_String | {name_String, WellPositionP}) :> name, {1}],

			_Consolidation,
			Cases[Append[#[Sources], #[Destination]], (name_String | {name_String, WellPositionP}) :> name, {1}],

			_Define,
			{
				If[MatchQ[#[Sample], {_String, WellPositionP}],
					#[Sample][[1]],
					Nothing
				],
				If[MatchQ[#[Container], _String],
					#[Container],
					Nothing
				]
			},

			_,
			{}
		]&,
		primitivesWithConvertedResuspend
	];

	(* extract any names that do not have an associated Define primitive *)
	invalidDefinedNameReferences=Map[
		Function[definedNames,
			Select[definedNames, !KeyExistsQ[definedNamesLookup, #]&]
		],
		definedNameReferences
	];

	(* get the primitives with invalid defined names *)
	primitivesWithInvalidDefinedNames=PickList[primitivesWithConvertedResuspend, invalidDefinedNameReferences, Except[{}]];

	(* Throw a message if our input primitives contain names that are not defined in Define primitives *)
	If[messages && Not[MatchQ[primitivesWithInvalidDefinedNames, {}]],
		MapIndexed[
			Function[{nameList, index},
				If[MatchQ[nameList, Except[{}]],
					Message[Warning::InvalidNameReference, nameList, index]
				]
			],
			invalidDefinedNameReferences
		]
	];

	(* get all the invalid primitives *)
	invalidPrimitives=DeleteDuplicates[Flatten[{primitivesWithInvalidType, primitivesWithInvalidKeys, primitivesWithInvalidDefinedNames, primitivesWithInvalidAmountLength}]];

	(* throw an error message and return $Failed early if there are no valid primitives to use *)
	If[MatchQ[Length[invalidPrimitives], Length[myPrimitives]],
		Message[Error::NoValidPrimitives];
		Return[$Failed]
	];

	(* collect all the valid primitives since we're done checking the primitives at high level *)
	validPrimitives=DeleteCases[primitivesWithConvertedResuspend, Alternatives @@ invalidPrimitives];

	(* get the original position of the valid primitive *)
	validPrimitiveIndices=MapIndexed[
		Function[{primitive, index},
			If[MemberQ[validPrimitives, primitive],
				index,
				Nothing
			]
		],
		primitivesWithConvertedResuspend
	];

	(* ----------------------------------------------------------- *)
	(* ----------REPLACE DEFINED NAMES IN THE PRIMITIVES---------- *)
	(* ----------------------------------------------------------- *)

	(* create replace rules for all defined names *)
	defineReplaceRules=Join @@ Map[
		Function[primitive,
			Module[{defineAssociation},

				defineAssociation=First[primitive];

				{
					Which[
						KeyExistsQ[defineAssociation, Sample],
						defineAssociation[Name] -> defineAssociation[Sample],
						KeyExistsQ[defineAssociation, Container] && !KeyExistsQ[defineAssociation, Sample] && !KeyExistsQ[defineAssociation, Well],
						defineAssociation[Name] -> defineAssociation[Container],
						KeyExistsQ[defineAssociation, Container] && !KeyExistsQ[defineAssociation, Sample] && KeyExistsQ[defineAssociation, Well],
						defineAssociation[Name] -> {defineAssociation[Container], defineAssociation[Well]},
						True,
						Nothing
					],
					If[KeyExistsQ[defineAssociation, ContainerName],
						defineAssociation[ContainerName] -> defineAssociation[Container],
						Nothing
					]
				}
			]
		],
		definePrimitives
	];

	(* replace all defined names in valid primitives *)
	resolvedPrimitives=Map[
		(* Don't replace anything in a Define primitive *)
		If[MatchQ[#, _Define],
			#,
			# //. defineReplaceRules
		]&,
		validPrimitives
	];

	(* when turning Objects primitives into Object References by using replace rule (object: ObjectP[] :> Download[object, Object]), *)
	(* the unevaluated download form is used in the primitive instead. It will show correct form in primitive blobs in MM front end *)
	(* we can get around this by creating a replace rule first with actual object reference first *)

	(* get all objects from the primitives *)
	allObjsFromPrimitives=Cases[resolvedPrimitives, ObjectP[], Infinity];

	(* create a replace rules with object references *)
	(* also support cases where missing object is specified *)
	objRefReplaceRules=Quiet[DeleteDuplicates[Map[
		If[MatchQ[Download[#, Object], $Failed],
			# -> #,
			# -> Download[#, Object]
		]&,
		allObjsFromPrimitives
	]]];

	(* turn all objects in the primitives into object references for ease of use downstream *)
	resolvedPrimitivesWithRefs=Map[
		(* Don't replace anything in Define primitive *)
		If[MatchQ[#, _Define],
			#,
			ReplaceAll[#, objRefReplaceRules]
		]&,
		resolvedPrimitives
	];

	(* create replace rules to track original position of the resolved primitives *)
	primitiveToPositionRules=MapThread[
		#1 -> #2&,
		{resolvedPrimitivesWithRefs, validPrimitiveIndices}
	];

	(* Separate FillToVolume primitives from the others *)
	fillToVolumePrimitives=Cases[resolvedPrimitivesWithRefs, _FillToVolume];

	(* Throw a warning message if at least one FillToVolume primitive is given to inform the user that the calculated usage amount may not be accurate *)
	If[messages && Not[MatchQ[fillToVolumePrimitives, {}]],
		Message[Warning::FillToVolumePrimitiveIncluded]
	];

	(* Resuspend doesn't have Amount key but can be treated the same way with the other primitives if Diluent is specified *)
	primitivesWithAmountKey=DeleteCases[resolvedPrimitivesWithRefs, Alternatives @@ Flatten[{fillToVolumePrimitives , definePrimitives}]];

	(* Extract the source objects from primitives with amount key *)
	(* note that at this point all Resuspend primitives have already been converted to Transfer primitives *)
	sourceObjects=Map[
		Switch[#,
			Alternatives[_Transfer, _Aliquot], #[Source],
			_Consolidation, #[Sources],
			_, Nothing
		]&,
		primitivesWithAmountKey
	];

	(* Get objects to download from Transfer-based primitives. Also delete string if well position is specified *)
	transferPrimitiveObjs=Cases[sourceObjects, ObjectP[], Infinity];

	(* Remove Model[Container] from our list of objects extracted from the primitives since we only care about samples *)
	transferPrimitiveObjsNoModel=Cases[transferPrimitiveObjs, Except[ObjectP[Model[Container]]]];

	(* --- Get objects to download from FillToVolume primitives --- *)
	(* Note: We need to check if destination is an empty container or objects with volume before we can calculate usage amount *)

	(* get all objects from FillToVolume primitives *)
	fillToVolumeObjs=Cases[fillToVolumePrimitives, ObjectP[], Infinity];

	(* Remove Model[Container] from FillToVolume Destination objects as we will treat them as empty containers *)
	fillToVolumeObjsNoModel=Cases[fillToVolumeObjs, Except[ObjectP[Model[Container]]]];

	(* Collect all objects to download *)
	objsToTest=DeleteDuplicates[Flatten[{transferPrimitiveObjsNoModel, fillToVolumeObjsNoModel}]];

	(* Test to see if the objsToTest exist in the database (or the input cache) *)
	databaseMember=Map[
		If[DatabaseMemberQ[#],
			True,
			MemberQ[Lookup[cache, Object], #]
		]&,
		objsToTest
	];

	(* Get the list of all missing objects *)
	missingObjs=PickList[objsToTest, databaseMember, False];

	(* Throw a message if any objects are missing from the database *)
	If[messages && Not[MatchQ[missingObjs, {}]],
		Message[Warning::MissingObjects, missingObjs]
	];

	(* Get the objects to use. Exclude missing objects *)
	objsToUse=PickList[objsToTest, databaseMember, True];

	(* throw an error message and return $Failed early if there are no valid objects to calculate the usage amount *)
	If[MatchQ[objsToUse, {}],
		Message[Error::NoValidObjectsToUse];
		Return[$Failed]
	];

	(* Get all objects to download including author *)
	objsToUseWithAuthors=Join[objsToUse, ToList[resolvedAuthor]];

	(* Get all the fields to download from all collected objects *)
	allFields=Map[
		Switch[#,
			ObjectP[Object[Sample]],
			{
				Packet[Model, Volume, Mass, Count, State, Container, AwaitingDisposal, Status, ExpirationDate, Notebook, Name],
				Packet[Model[{Deprecated, Name, State}]]
			},

			ObjectP[Model[Sample]],
			{
				Packet[Deprecated, Name, State]
			},

			ObjectP[Object[Container, Plate]],
			{
				Packet[Contents, MaxVolume],
				Packet[Field[Contents[[All, 2]]][{Model, Volume, Mass, Count, State, Container, AwaitingDisposal, Status, ExpirationDate, Notebook, Name, Position}]]
			},

			(* download fields for Object containers needed to determine usage volume for FillToVolume only. Restrict to subtype Vessel only *)
			ObjectP[Object[Container, Vessel]],
			{
				Packet[Contents, MaxVolume],
				Packet[Field[Contents[[All, 2]]][{Model, Volume, Mass, Count, State, Container, AwaitingDisposal, Status, ExpirationDate, Notebook, Name, Position}]]
			},

			ObjectP[Object[User]],
			{
				Packet[SharingTeams[{Notebooks, NotebooksFinanced}]],
				Packet[FinancingTeams[{Notebooks, NotebooksFinanced}]]
			},

			_, {}
		]&,
		objsToUseWithAuthors
	];

	(* Make a big download call to get everything we need *)
	allPackets=Quiet[
		Download[
			objsToUseWithAuthors,
			Evaluate[allFields],
			Cache -> cache,
			Date -> Now
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::MissingField}
	];

	(* make the new cache to use downstream *)
	newCache=Experiment`Private`FlattenCachePackets[Cases[{cache, allPackets}, PacketP[], Infinity]];

	(* Separate out the Notebook packet from the sample/model packets *)
	{allPacketsNoNotebook, financerPackets}=TakeDrop[allPackets, Length[objsToUse]];

	(* ------------------------------------------ *)
	(* -----Handling FillToVolume primitives----- *)
	(* ------------------------------------------ *)

	(* Convert FillToVolume primitives *)
	fillToVolumeRules=Map[
		Function[primitive,
			Module[{destination, finalVolume, unit, packet, contents, destinationVolume, volumeNeeded},

				(* assign destination and final volume to new variables to that we don't have to deference the primitive every single time *)
				destination=primitive[Destination];
				finalVolume=primitive[FinalVolume];

				(* get the unit specified with FinalVolume to use later *)
				unit=Units[finalVolume];

				(* get the volume from destination object *)
				destinationVolume=If[MatchQ[destination, ObjectP[Model[Container]]],

					(* If destination is a Model[Container, Vessel], assume empty and return 0 *)
					0 * unit,

					(* For all other object types, get the packet *)
					packet=Experiment`Private`fetchPacketFromCache[destination, newCache];

					(* get the contents from the packet *)
					contents=Flatten[Lookup[packet, Contents, {}]];

					Switch[destination,
						(* If Destination is a sample, return its volume *)
						NonSelfContainedSampleP,
						Lookup[packet, Volume],

						(* The remaining cases should only include Object[Container, Vessel] *)
						(* If Content is an empty list, return 0. Otherwise, return the volume of the content sample *)
						_,
						If[MatchQ[contents, {}],
							0 * unit,
							Lookup[Experiment`Private`fetchPacketFromCache[contents[[2]], newCache], Volume]
						]
					]
				];

				(* get the volume needed to FinalVolme *)
				volumeNeeded=If[destinationVolume < finalVolume,
					primitive[FinalVolume] - destinationVolume,

					(* if destination volume exceeds FinalVolume return 0 *)
					0 * unit
				];

				(* Return estimated usage volume. Throw a warning message if Destination volume exceeds FinalVolume *)
				If[messages && destinationVolume > finalVolume,
					Message[Warning::ExcessDestinationVolume,
						Flatten[primitive /. primitiveToPositionRules],
						UnitScale[destinationVolume]
					]
				];

				(* Create replace rule with Source object pointing to volume needed *)
				{primitive[Source] -> volumeNeeded}
			]
		],
		fillToVolumePrimitives
	];

	(* specify transfer primitives to get the source sample objects *)
	transferSampleToAmountRules=Map[
		Function[primitive,
			Module[{convertedPrimitive, specifiedPrimitive, sourceSamples, transferAmounts, transferRules},
				(* convert primitive to Transfer *)
				convertedPrimitive=Experiment`Private`toFormattedTransferPrimitive[primitive];
				(* specify primitive to populate SourceSample key *)
				specifiedPrimitive=Quiet[Check[Experiment`Private`populateTransferKeys[convertedPrimitive, Cache -> newCache],
					(* check if ObjectDoesNotExist error is thrown from populateTransferKeys since primitives with samples that are not on database can reach this point *)
					(* we create a fake association here to make it when we lookup SourceSample and Amount below in this Map *)
					<|SourceSample -> {{Null}}, Amount -> convertedPrimitive[Amount]|>,
					Download::ObjectDoesNotExist
				], {Download::ObjectDoesNotExist, Lookup::invrl}];
				(* get the resolved source samples for the specified primitive *)
				sourceSamples=Flatten[specifiedPrimitive[SourceSample]];
				(* get the transfer amount from the specified primitive *)
				transferAmounts=Flatten[specifiedPrimitive[Amount]];
				(* create transfer rules in the form {sampleObject -> amount} *)
				transferRules=Rule @@@ Transpose[{sourceSamples, transferAmounts}];
				(* drop any instances with Null as a key from the list *)
				(* Note: SourceSample can be Null if the Source Key value is specified as an empty container or well *)
				Cases[transferRules, Except[Null -> _]]
			]
		],
		primitivesWithAmountKey
	];

	(* -----Turn {container, well} and Object[Container, Vessel] into sample objects----- *)

	(* Combine Transfer and FillToVolume rules *)
	transferAndFillToVolumeRules=Flatten[{transferSampleToAmountRules, fillToVolumeRules}];

	(* get the inputs that are container objects or {container, well} *)
	containerInputs=Cases[transferAndFillToVolumeRules[[All, 1]], Alternatives[{ObjectP[Object[Container]], _String}, ObjectP[Object[Container]]]];

	(* create replace rules to turn {container, well} and Object[Container, Vessel] into objects *)
	containerReplaceRules=Map[
		Function[input,
			Module[{packet, allContents, content},
				(* get the container's packet from cache *)
				packet=Switch[input,
					ObjectP[Object[Container]], Experiment`Private`fetchPacketFromCache[input, newCache],
					_, Experiment`Private`fetchPacketFromCache[input[[1]], newCache]
				];
				(* lookup the container's contents *)
				allContents=Lookup[packet, Contents];
				(* select position from matching well *)
				content=Switch[input,
					(* if input is a container, use the entire Contents list *)
					ObjectP[Object[Container]],
					allContents,
					(* if input is a valid well position, find the matching well *)
					{ObjectP[Object[Container]], Apply[Alternatives, allContents[[All, 1]]]},
					Select[allContents, MatchQ[input[[2]], #[[1]]]&],
					(* for input with invalid well position/well position with no contents, return Null *)
					_,
					Null
				];
				(* make rule *)
				Switch[content,
					(* if content is Null (includes empty container object, and wells with no contents), return Nothing *)
					Null, Nothing,
					(* Otherwise, return the input -> content's object *)
					_, input -> Download[Flatten[content][[2]], Object, Cache -> newCache]
				]
			]
		],
		containerInputs
	];

	(* turn {container, well} and Object[Container, Vessel] into objects *)
	resolvedReplaceRules=transferAndFillToVolumeRules /. containerReplaceRules;

	(* merge the transfer rules to combine duplicates can total the usage amount for each sample *)
	sampleToAmountAssociationWithContainers=Merge[resolvedReplaceRules, UnitScale[N[Total[#]]]&];

	(* remove every keys that are not sample object or model at this point. this includes container models, empty container objects, and specified {container, well} with no contents *)
	objsToRemove=Cases[Keys[sampleToAmountAssociationWithContainers], Except[ObjectP[{Object[Sample], Model[Sample]}]]];

	(* combine all keys to drop from the association *)
	keysToDrop=Flatten[{objsToRemove, missingObjs}];

	(* drop keys that are not relevant from the association *)
	sampleToAmountAssociation=KeyDrop[sampleToAmountAssociationWithContainers, keysToDrop];

	(* Create a list of samples. No duplicates are present at this point *)
	objRefList=Keys[sampleToAmountAssociation];

	(* Create a list of total usage amount for each sample *)
	totalUsageList=Values[sampleToAmountAssociation];

	(* get the packets for objects that we will display in a table or return as association *)
	objPacketsToUse=Experiment`Private`fetchPacketFromCache[#, newCache]& /@ objRefList;

	(* get the object name from the packets *)
	objNamesToUse=Lookup[objPacketsToUse, Name];

	(* ----------------------------------------*)
	(* ----------DEFINED NAME LOOKUP---------- *)
	(* --------------------------------------- *)

	(* create replace rules to lookup defined names if given to make it easier for the user to know which sample is which *)

	(* turn all values in {string, string} format in defined name replace rules to {container, well} format *)
	additionalDefineReplaceRules=Cases[defineReplaceRules, (name_ -> {container_String, well_String}) :> ({container, well} -> ({container, well} /. defineReplaceRules))];

	(* update our original defined name replace rules with additional rules *)
	updatedDefineReplaceRules=Join[defineReplaceRules, additionalDefineReplaceRules];

	(* replace all objects in values with object references *)
	definedNameToRefRules=updatedDefineReplaceRules /. x:ObjectReferenceP[] :> Download[x, Object];

	(* turn values with {container, well} format into object references *)
	definedNameRulesNoWells=definedNameToRefRules /. containerReplaceRules;

	(* replace the remaining {string, string} values to object references *)
	definedNameLookupRules=definedNameRulesNoWells /. (name_ -> {container_, well_String}) :> name -> ({container, well} /. definedNameRulesNoWells);

	(* reverse key->value, and merge/join to make an association with all final object references as keys pointing to all possible define names *)
	definedNameLookup=Merge[Map[Reverse, definedNameLookupRules], Join];

	(* drop keys that are container models/objects since we only care about samples *)
	definedNameLookupAssociation=KeyDrop[definedNameLookup, Cases[Keys[definedNameLookup], ObjectP[{Object[Container], Model[Container]}]]];

	(* make defined name list that is index matched to object list to be displayed *)
	definedNameList=Map[
		Lookup[definedNameLookupAssociation, #, "-"]&,
		objRefList
	];

	(* turn each sub list of defined names into string to aid plotting *)
	finalizedDefinedNameList=Map[ToString, definedNameList /. {x_} :> x];

	(* ------------------------------------ *)
	(* ----------INVENTORY LOOKUP---------- *)
	(* ------------------------------------ *)

	(* Get the sample packets without their models *)
	samplePackets=Experiment`Private`fetchPacketFromCache[#, newCache]& /@ Cases[objsToUse, ObjectP[Object[Sample]]];

	(* Get the model packets of the user-specified samples *)
	samplesModelPackets=Experiment`Private`fetchPacketFromCache[#, newCache]& /@ Cases[Lookup[samplePackets, Model], ObjectP[]];

	(* Get the packets of the user-specified models *)
	specifiedModelPackets=Experiment`Private`fetchPacketFromCache[#, newCache]& /@ Cases[objsToUse, ObjectP[Model[Sample]]];

	(* combine user-specified model packets and sample's model packets *)
	allModelPackets=Flatten[{samplesModelPackets, specifiedModelPackets}];

	(* Make replace rules for the models and their corresponding samples *)
	(* This allows us to trace back to the samples when we check for deprecated models *)
	modelToSampleReplaceRules=If[MatchQ[samplePackets, {}],
		{},
		MapThread[
			Switch[#2,
				Null, Nothing,
				_, Download[#2, Object] -> #1
			]&,
			{Lookup[samplePackets, Object], Lookup[samplePackets, Model]}
		]
	];

	(* ------------------------------------------- *)
	(* ----------SAMPLE VALIDATION CHECK---------- *)
	(* ------------------------------------------- *)

	(* --- For all Object[Sample] objects, is the sample set for disposal? *)

	(* Get a list of booleans indicating if a sample is set for disposal. True indicates the sample is not set for disposal *)
	notDisposalBool=Map[
		!TrueQ[Lookup[#, AwaitingDisposal]]&,
		samplePackets
	];

	(* Get the samples set for disposal *)
	disposalSamples=PickList[samplePackets, notDisposalBool, False];

	(* Throw a message for the disposal samples *)
	If[messages && Not[MatchQ[disposalSamples, {}]],
		Message[Warning::SamplesMarkedForDisposal, Lookup[disposalSamples, Object]]
	];

	(* --- For all Object[Sample] objects, is the sample discarded? *)

	(* Get the list of booleans indicating if a sample is available (True) or Discarded (False) *)
	(* If Null, assume that the sample is not discarded and go straight to True *)
	notDiscardedBool=Map[
		!MatchQ[Lookup[#, Status], Discarded]&,
		samplePackets
	];

	(* Get the discarded samples *)
	discardedSamples=PickList[samplePackets, notDiscardedBool, False];

	(* Throw a message for the discarded samples *)
	If[messages && Not[MatchQ[discardedSamples, {}]],
		Message[Warning::DiscardedSamples, Lookup[discardedSamples, Object]]
	];

	(* --- For all Object[Sample] objects, is the sample Expired? *)

	(* Get the list of booleans indicating if a sample is expired *)
	(* If Null assume it's not expired *)
	expiredBool=Map[
		(!NullQ[#] && DateObjectQ[Lookup[#, ExpirationDate]] && Lookup[#, ExpirationDate] < Now)&,
		samplePackets
	];

	(* Get the expired samples *)
	expiredSamples=PickList[samplePackets, expiredBool, True];

	(* Throw a message for the expired samples *)
	If[messages && Not[MatchQ[expiredSamples, {}]],
		Message[Warning::ExpiredSamples, Lookup[expiredSamples, Object]]
	];

	(* --- Are the model for a given sample and the Model[Sample] specified by the user deprecated? *)

	(* Get the models from our packets that are deprecated *)
	deprecatedModels=Map[
		Switch[Lookup[#, Deprecated],
			True, Lookup[#, Object],
			_, Nothing
		]&,
		allModelPackets
	];

	(* Get the deprecated model for a given sample *)
	samplesWithDeprecatedModel=Cases[deprecatedModels, ObjectP[Lookup[samplesModelPackets, Object]]] /. modelToSampleReplaceRules;

	(* Get the deprecated user-specified models *)
	deprecatedSpecifiedModels=Cases[deprecatedModels, ObjectP[Lookup[specifiedModelPackets, Object]]];

	(* Throw a message for the deprecated model for a given sample *)
	If[messages && Not[MatchQ[samplesWithDeprecatedModel, {}]],
		Message[Warning::SamplesWithDeprecatedModels, samplesWithDeprecatedModel]
	];

	(* Throw a message for the deprecated models specified by the user *)
	If[messages && Not[MatchQ[deprecatedSpecifiedModels, {}]],
		Message[Warning::DeprecatedSpecifiedModels, deprecatedSpecifiedModels]
	];

	(* --- If a sample was specifically indicated, does that sample's notebook match a notebook owned by the requestor? --- *)

	(* Get all the Notebooks that the Samples to be used could have *)
	notebooksFromPackets=Flatten[Lookup[Flatten[financerPackets], {Notebooks, NotebooksFinanced}, {}]];

	(* all notebook objects are in link format. turn them into object references and delete duplicates *)
	allAllowedNotebooks=DeleteDuplicates[notebooksFromPackets] /. x:ObjectP[] :> Download[x, Object];

	(* Get the Notebook of each sample. make sure to strip off link *)
	samplesNotebook=Lookup[samplePackets, Notebook, {}] /. x:ObjectP[] :> Download[x, Object];

	(* Check if the specified samples are public or not owned by the requestor *)
	notOwnedSamplesBools=Map[
		Or[
			NullQ[#],
			!MemberQ[allAllowedNotebooks, #]
		]&,
		samplesNotebook
	];

	(* Get the specified public samples *)
	notOwnedSamples=PickList[samplePackets, notOwnedSamplesBools, True];

	(* Throw a warning message if the user specified a public sample in the primitives *)
	If[messages && Not[MatchQ[notOwnedSamples, {}]],
		Message[Warning::SamplesNotOwned, Lookup[notOwnedSamples, Object]]
	];

	(* ----------EARLY RETURN---------- *)
	(* when InventoryComparison -> False *)

	(* create a list of models index matched to object list to display *)
	modelList=Map[
		Switch[#,
			ObjectP[Object[Sample]], Lookup[Experiment`Private`fetchPacketFromCache[#, newCache], Model] /. x:ObjectP[] :> Download[x, Object],
			_, #
		]&,
		objRefList
	];

	(* create a list of model names index matched to object list to display *)
	modelNameList=Map[
		Lookup[Experiment`Private`fetchPacketFromCache[#, newCache], Name, "-"]&,
		modelList /. Null -> <||>
	];

	(* create a list of objects to display. replace model with "-" since we have another column for model *)
	objsToDisplay=objRefList /. x:ObjectP[Model[Sample]] :> "-";

	(* create replace rules of sample's amount. *)
	samplesAmountRules=Map[
		Module[{packet, state, volume, mass, count, amount},
			(* get the sample's packet *)
			packet=Experiment`Private`fetchPacketFromCache[#, newCache];

			(* get state, volume, mass, and count from the packet *)
			{state, volume, mass, count}=Lookup[packet, {State, Volume, Mass, Count}, Null];

			(* get the amount based on the state of the sample *)
			amount=Switch[#,
				(* if a model is specified return N/A as we only need to return sample's amount here *)
				ObjectP[Model[Sample]], "N/A",

				_, UnitScale[Switch[state,

					Liquid,
					If[NullQ[volume], 0 * Liter, volume],

					Solid,
					Which[
						!NullQ[mass], mass,
						NullQ[mass], If[NullQ[count], 0 * Gram, count],
						True, 0 * Gram
					],

					(* if State is Null, return amount that is not missing or Null *)
					_, SelectFirst[{volume, mass count}, !NullQ[#] && !MissingQ[#]&]
				]]
			];

			(* return rule sample -> amount *)
			# -> amount
		]&,
		objRefList
	];

	(* Early return. If inventoryCheck -> False, return the usage amount early without checking the inventory. *)
	If[Not[inventoryCheck],
		(* assemble results for early return *)
		resultsToDisplay=Map[
			Flatten,
			Transpose[
				{
					Sequence @@ If[MatchQ[objsToDisplay, {"-"..}], Nothing, {objNamesToUse, objsToDisplay}],
					If[MatchQ[definedNameLookupAssociation, <||>], Nothing, finalizedDefinedNameList],
					modelNameList,
					modelList,
					totalUsageList,
					samplesAmountRules[[All, 2]]
				}
			]];

		(* ---sort results to display--- *)
		(* get result tuples of objects without names *)
		resultTuplesWithNoNames=Select[resultsToDisplay, NullQ[#[[1]]]&];

		(* get result tuples of objects with names.sort by name (first index) *)
		resultTuplesWithNames=Sort[DeleteCases[resultsToDisplay, Alternatives @@ resultTuplesWithNoNames]];

		(* sort objects to display *)
		sortedResultsTuples=Flatten[{
			(* for objects with names, sort by names *)
			resultTuplesWithNames,
			(* objects without names, sort by Object References (second index) *)
			SortBy[resultTuplesWithNoNames, #[[2]]&]
		}, 1];

		(* create headings for the table *)
		tableHeadings={Automatic,
			{
				Sequence @@ If[MatchQ[objsToDisplay, {"-"..}], Nothing, {"Object Name", "Object"}],
				If[MatchQ[definedNameLookupAssociation, <||>], Nothing, "Defined Name"],
				"Model Name",
				"Model",
				"Usage Amount",
				"Sample's Amount"
			}
		};

		(* create a list of result association keys *)
		resultKeys={
			Sequence @@ If[MatchQ[objsToDisplay, {"-"..}], Nothing, {SampleName, Sample}],
			If[MatchQ[definedNameLookupAssociation, <||>], Nothing, DefinedName],
			ModelName,
			Model,
			Usage,
			Amount
		};

		(* create a list of associations to return *)
		resultsAssociation=Map[
			AssociationThread[resultKeys, #]&,
			sortedResultsTuples
		];

		(* ---return results--- *)
		(* generate output according to the OutputFormat option value *)
		If[MatchQ[output, Association],
			Return[resultsAssociation],
			Return[PlotTable[sortedResultsTuples, TableHeadings -> tableHeadings, UnitForm -> False]]
		]
	];

	(* ----------SEARCH PREPARATION---------- *)

	(* get all sample models object reference *)
	allSampleModels=Lookup[allModelPackets, Object];

	(* exclude the water model objects from the list of models to be searched as they would significantly slow down the search due to too many sample objects sharing the same models *)
	modelsToSearch=Cases[allSampleModels, Except[WaterModelP]];

	(* delete duplicates from the list of models to search *)
	modelsToSearchNoDupes=DeleteDuplicates[modelsToSearch];

	(* Create a list of object type to use when calling Search *)
	typesToSearch=ConstantArray[Object[Sample], Length[modelsToSearchNoDupes]];

	(* define our search criteria *)
	searchConditions=Map[
		Status == (Stocked | Available | InUse) && (Model == #) && Notebook == (Null | Alternatives @@ allAllowedNotebooks)&,
		modelsToSearchNoDupes
	];

	(* perform search and collect results *)
	searchResults=Search[typesToSearch, Evaluate[searchConditions]];

	(* Download Volume/Mass/Count/State/Notebook for objects in search results *)
	allPacketsNew=Quiet[
		Download[
			searchResults,
			Packet[Model, Volume, Mass, Count, State, Notebook],
			Cache -> newCache
		],
		{Download::FieldDoesntExist, Download::NotLinkField, Download::MissingField}
	];

	(* Group based on Notebook. Maintain index that matches searched Model objects. *)
	(* True will point to public inventory group with Notebook == Null *)
	groupedPackets=Map[
		Function[searchResultPerModel,
			GroupBy[searchResultPerModel, NullQ[Lookup[#, Notebook]] &]],
		allPacketsNew
	];

	(* Separate packets into public and private inventory *)
	publicPackets=Lookup[groupedPackets, True, {}];
	ownedPackets=Lookup[groupedPackets, False, {}];

	(* get the model packets for each public sample packet *)
	publicModelPackets=If[MatchQ[publicPackets, {}],
		{},
		Map[
			Switch[#,
				{}, {},
				_, Experiment`Private`fetchPacketFromCache[Lookup[#[[1]], Model], newCache]
			]&,
			publicPackets
		]
	];

	(* get the model packets for each owned sample packet *)
	ownedModelPackets=If[MatchQ[ownedPackets, {}],
		{},
		Map[
			Switch[#,
				{}, {},
				_, Experiment`Private`fetchPacketFromCache[Lookup[#[[1]], Model], newCache]
			]&,
			ownedPackets
		]
	];

	(* calculate total amount of samples sharing the same model in the user's inventory *)
	ownedAmountPerModel=MapThread[totalAmountLookup[#1, #2]&, {ownedPackets, ownedModelPackets}];

	(* calculate total amount of samples sharing the same model in the public inventory *)
	publicAmountPerModel=MapThread[totalAmountLookup[#1, #2]&, {publicPackets, publicModelPackets}];

	(* Make model to total amounts replace rules to pair *)
	(* also assign unit to zero amount *)
	modelToAmountsReplaceRules=MapThread[
		Module[{state, unit, amountTuple, updatedAmountTuple},
			state=Lookup[Experiment`Private`fetchPacketFromCache[#1, newCache], State];

			unit=Switch[state,
				Liquid, Liter,
				Solid, Gram,
				_, 1
			];

			amountTuple=#2;

			updatedAmountTuple=Map[
				Switch[Units[#],
					1, # * unit,
					_, #
				]&,
				amountTuple
			];

			#1 -> updatedAmountTuple
		]&,
		{modelsToSearchNoDupes, Transpose[{ownedAmountPerModel, publicAmountPerModel}]}
	];

	(* for water models, return "N/A" as inventory amount as we did not search for sample objects linked to them *)
	waterModelReplaceRules=Map[#1 -> {"N/A", "N/A"}&, DeleteDuplicates[Cases[Lookup[allModelPackets, Object], WaterModelP]]];

	(* create a replace rule for sample without model. assign 0 for amounts in both user's and public inventory *)
	samplesWithoutModelReplaceRules=Map[
		Module[{amount, unit},
			(* get the unit from sample's amount *)
			amount=# /. samplesAmountRules;
			unit=Units[amount];
			# -> {0, 0} * unit
		]&,
		PickList[Lookup[samplePackets, Object, {}], Lookup[samplePackets, Model, {}], Null]
	];

	(* create replaces rule to retrieve inventory amounts for a given model objects *)
	allModelReplaceRules=Flatten[{modelToAmountsReplaceRules, waterModelReplaceRules, samplesWithoutModelReplaceRules}];

	(* get the rules defined earlier that will replace sample object with its model *)
	sampleToModelReplaceRules=Reverse[modelToSampleReplaceRules, {2}];

	(* get the models of the sample objects to be displayed *)
	modelsOfObjsToDisplay=ReplaceAll[objRefList, sampleToModelReplaceRules];

	(* get the amounts in the inventory by using replace rules. This list is index matched to the list of objects to be displayed *)
	inventoriedAmounts=Replace[modelsOfObjsToDisplay, allModelReplaceRules, {1}];

	(* separate out the amounts in the user's inventory *)
	usersInitialAmount=inventoriedAmounts[[All, 1]] /. x_Quantity :> UnitScale[x];

	(* separate out the amounts in the public inventory *)
	publicAmount=inventoriedAmounts[[All, 2]] /. x_Quantity :> UnitScale[x];

	(* get initial amount for each sample *)
	samplesInitialAmount=MapThread[
		Function[{sample, amount},
			Switch[sample,
				(* if a sample object is specified, check if the sample is owned by the user *)
				ObjectP[Object[Sample]],

				If[MemberQ[notOwnedSamples, sample],
					(* if the sample is not owned by the user, set the initial amount to 0 to use for amount tracking *)
					0 * Units[amount],
					(* otherwise, use the sample's amount we obtained in the sample-to-amount rules we defined above *)
					sample /. samplesAmountRules
				],
				(* if a sample model is specified, use the total amount in the user's inventory *)
				_, amount
			]
		],
		{objRefList, inventoriedAmounts[[All , 1]]}
	];

	(* ----------INSUFFICIENT AMOUNT TRACKING---------- *)

	(* create primitive and usage replace rules for volume tracking *)
	primitiveToUsageRules=MapThread[
		(* if converted primitive is Null exclude. Null is a result from Resuspend primitive with no Diluent key *)
		If[NullQ[#2],
			Nothing,
			(* merge to sum usage of similar objects within each primitive *)
			#1 -> Merge[#2, Total]
		]&,
		(* maintain index of both the primitive list and converted list to pair properly *)
		{Join[primitivesWithAmountKey, fillToVolumePrimitives], Join[transferSampleToAmountRules, fillToVolumeRules]}
	];

	(* remove container models since we only care about sample usage *)
	updatedPrimitiveToUsageValues=KeyDrop[#, keysToDrop]& /@ Values[primitiveToUsageRules];

	(* turn container object into sample using our container replace rules defined above *)
	resolvedPrimitiveToUsageValues=Map[
		Function[usageValue,
			KeyMap[ReplaceAll[#, containerReplaceRules]&, usageValue]
		],
		updatedPrimitiveToUsageValues
	];

	(* update our primitive to usage rules with the resolved values *)
	updatedPrimitiveToUsageRules=MapThread[
		#1 -> #2&,
		{Keys[primitiveToUsageRules], resolvedPrimitiveToUsageValues}
	];

	(* create list of rules pairing each sample with its amount *)
	sampleToInventoryRules=MapThread[
		If[MatchQ[#2, "N/A"],
			#1 -> Infinity,
			#1 -> #2
		]&,
		{objRefList, samplesInitialAmount}
	];

	(* create replace rules for owned amount tracking of the model and update in the loop *)
	(* when the loop is done, we can use this final amount to display for all samples sharing this model *)
	(* create list of rules pairing each model with its amount in the user's inventory. index matched to sampleInventoryRules *)
	modelToInventoryRules=MapThread[
		Module[{model},
			(* get the model for each object *)
			model=Switch[#1,

				ObjectP[Model[Sample]], #1,

				_, Lookup[Experiment`Private`fetchPacketFromCache[#1, newCache], Model] /. x:ObjectP[] :> Download[x, Object]
			];

			(* If the initial amount in inventory is N/A, set to Infinity as this is a water model *)
			If[MatchQ[#2, "N/A"],
				model -> Infinity,
				If[NullQ[model], Nothing, model -> #2]
			]
		]&,
		{objRefList, usersInitialAmount}
	];

	(* map over our valid input primitives in original sequence and update volume in the user's inventory as if we are performing each manipulation *)
	(* whenever the amount goes below zero, return object {reference -> primitive} *)
	primitiveWithInsufficientSamples=Map[
		Function[primitive,
			Module[{sampleToUsageAssociation, updatedAmountRules},
				(* create a sample-amount lookup assocaition *)
				sampleToUsageAssociation=primitive /. updatedPrimitiveToUsageRules;

				(* create replace rules to update sample's amount and inventory amount *)
				updatedAmountRules=If[MatchQ[sampleToUsageAssociation, _Association],
					KeyValueMap[
						Module[{sample, amount, model, sampleAmountUpdate, inventoryAmountUpdate},

							{sample, amount}={#1, #2};

							(* get the sample's model from the packet *)
							model=Lookup[Experiment`Private`fetchPacketFromCache[sample, newCache], Model, sample] /. (x:ObjectP[] :> Download[x, Object]);

							(* make rule to update sample's amount *)
							sampleAmountUpdate=sample -> (Lookup[sampleToInventoryRules, sample] - amount);

							(* make rule to update inventory amount *)
							inventoryAmountUpdate=Switch[sample,
								(* if sample is already a model, use the update rule we already created *)
								ObjectP[Model[Sample]], sampleAmountUpdate,

								(* otherwise, check the sample has a model *)
								_, If[NullQ[model],
									(* return Null if sample doesn't have a model *)
									Null,
									(* otherwise, return rule to update inventory amount *)
									model -> (Lookup[modelToInventoryRules, model] - amount)
								]
							];

							(* return amount update rules *)
							DeleteDuplicates[Flatten[{sampleAmountUpdate, inventoryAmountUpdate}]]

						]&,
						sampleToUsageAssociation
					]
				];

				(* update sample's amount and inventory amount in the rules we defined outside *)
				If[!NullQ[updatedAmountRules],
					sampleToInventoryRules=ReplaceRule[sampleToInventoryRules, Flatten[updatedAmountRules]];
					modelToInventoryRules=ReplaceRule[modelToInventoryRules, Flatten[updatedAmountRules]]
				];

				(* if the sample's amount < 0, return sample -> primitive rule so that we know at which primitive that the sample ran out *)
				KeyValueMap[
					Function[{sample, amount},
						If[MatchQ[amount, LessP[0 * Units[amount]]],
							sample -> primitive,
							Nothing
						]
					],
					Association @@ sampleToInventoryRules
				]
			]
		],
		resolvedPrimitivesWithRefs
	];

	(* create replace rules of sample to first manipulation with insufficient sample's amount *)
	firstPrimitiveWithInsufficientSamples=MapThread[
		Function[{sample, primitive},
			If[MatchQ[primitive, SampleManipulationP],
				sample -> primitive,
				Nothing
			]
		],
		{objRefList, objRefList /. Flatten[primitiveWithInsufficientSamples]}
	];

	(* replace the primitive with their original user-specified positions *)
	positionsWithInsufficientSamples=firstPrimitiveWithInsufficientSamples /. primitiveToPositionRules;

	(* Throw a message for each sample that runs out in the course of the input manipulations *)
	If[!MatchQ[positionsWithInsufficientSamples, {}],
		Map[
			Message[Warning::InsufficientSampleAmount, First[#], Last[#]]&,
			positionsWithInsufficientSamples
		]
	];

	(* get the amount in the user's inventory after performing all manipulations *)
	amountPostManipulation=ReplaceAll[objRefList /. sampleToModelReplaceRules, modelToInventoryRules];

	(* create replace rules to update user's final amount *)
	finalAmountReplaceRules=Flatten[{
		amount:LessP[0] :> 0 * Units[amount],
		Infinity -> "N/A",
		Map[
			#[[1]] -> #[[2]][[1]]&,
			samplesWithoutModelReplaceRules
		]
	}];

	(* replace negative amount with zero, and infinity water amount with N/A *)
	usersFinalAmount=ReplaceAll[amountPostManipulation, finalAmountReplaceRules];

	(* call UnitScale on all amounts *)
	usersFinalScaledAmount=ReplaceAll[usersFinalAmount, x_Quantity :> UnitScale[x]];

	(* ---------- FORMAT RESULTS TO PLOT ----------- *)

	(* pair each object to be displayed to its name, usage amount, and inventory amounts *)
	resultsToPlot=Map[
		Flatten,
		Transpose[
			{
				Sequence @@ If[MatchQ[objsToDisplay, {"-"..}], Nothing, {objNamesToUse, objsToDisplay}],
				If[MatchQ[definedNameLookupAssociation, <||>], Nothing, finalizedDefinedNameList],
				modelNameList,
				modelList,
				totalUsageList,
				samplesAmountRules[[All, 2]],
				usersInitialAmount,
				usersFinalScaledAmount,
				publicAmount
			}
		]];

	(* ---sort results to display--- *)
	(* get result tuples of objects without names *)
	resultTuplesWithNoNames=Select[resultsToPlot, NullQ[#[[1]]]&];

	(* get result tuples of objects with names. sort by name (first index) *)
	resultTuplesWithNames=Sort[DeleteCases[resultsToPlot, Alternatives @@ resultTuplesWithNoNames]];

	(* sort objects to display *)
	sortedResultsTuples=Flatten[{
		(* for objects with names, sort by names *)
		resultTuplesWithNames,
		(* objects without names, sort by Object References (second index) *)
		SortBy[resultTuplesWithNoNames, #[[2]]&]
	}, 1];

	(* create headings for the table *)
	tableHeadings={Automatic,
		{
			Sequence @@ If[MatchQ[objsToDisplay, {"-"..}], Nothing, {"Object Name", "Object"}],
			If[MatchQ[definedNameLookupAssociation, <||>], Nothing, "Defined Name"],
			"Model Name",
			"Model",
			"Usage Amount",
			"Sample's Amount",
			"Initial Amount in User's Inventory",
			"Final Amount in User's Inventory",
			"Amount in Public Inventory"
		}
	};

	(* create a list of result association keys *)
	resultKeys={
		Sequence @@ If[MatchQ[objsToDisplay, {"-"..}], Nothing, {SampleName, Sample}],
		If[MatchQ[definedNameLookupAssociation, <||>], Nothing, DefinedName],
		ModelName,
		Model,
		Usage,
		Amount,
		UsersInitialAmount,
		UsersFinalAmount,
		PublicAmount
	};

	(* create a list of associations to return *)
	resultsAssociation=Map[
		AssociationThread[resultKeys, #]&,
		sortedResultsTuples
	];

	(* Return a Table or a list of associations based on the resolved OutputFormat option value *)
	Switch[output,
		Association, resultsAssociation,
		Table, PlotTable[sortedResultsTuples, TableHeadings -> tableHeadings, UnitForm -> False]
	]
];


(* ::Subsubsection:: *)
(*SampleUsage Helper Functions*)


(* create a helper function to calculate total amount in user's/public inventory for each model *)
(* empty list overload. return zero amount with unit based on the model's state *)
totalAmountLookup[{}, modelPacket_]:=Switch[Lookup[modelPacket, State],
	Liquid, 0 * Liter,
	Solid, 0 * Gram,
	_, 0
];
(* core overload. lookup amount based on the state of each model's state and return totaled amount *)
totalAmountLookup[packets:{PacketP[]..}, modelPacket_]:=Total[Map[
	Function[packet,
		Module[
			{state, volume, mass, count},

			state=Lookup[modelPacket, State];

			{volume, mass, count}=Lookup[packet, {Volume, Mass, Count}];

			Switch[state,
				Liquid,
				If[NullQ[volume], 0 * Liter, volume],

				Solid,
				Which[
					!NullQ[mass], mass,
					NullQ[mass], If[NullQ[count], 0 * Gram, count],
					True, 0 * Gram
				],

				_,
				0
			]
		]
	],
	packets
]];


(* ::Subsection::Closed:: *)
(*resuspendToTransferPrimitive*)


(* Convert any Resuspend primitive to Transfer primitives*)
resuspendToTransferPrimitive[myPrimitive:SampleManipulationP]:=Module[
	{resuspendAssoc, sample, volume, diluent, pipettingParameterNames, specifiedPipettingParameters, transferPrimitive,
		incubatePrimitive, specifiedMixType, specifiedMixUntilDissolved, specifiedMixVolume, specifiedNumMixes,
		specifiedMaxNumMixes, specifiedIncubationTime, specifiedMaxIncubationTime, specifiedIncubationInstrument,
		specifiedIncubationTemperature, speciifedAnnealingTime, allAutomaticMixOptionValues, incubateQ,
		allPrimitives},

	(* if the primitive that we got in is anything but a resuspend primitive, just return it right here *)
	(* returning as a list because that will help us on the other side*)
	If[Not[MatchQ[myPrimitive, _Resuspend]],
		Return[{myPrimitive}]
	];

	(* pull out the association form of the Resuspend primitive *)
	resuspendAssoc = First[myPrimitive];

	(* pull out the Volume, Sample, and Diluent from the Resuspend primitive *)
	sample = Lookup[resuspendAssoc, Sample];
	volume = Lookup[resuspendAssoc, Volume];
	diluent = Lookup[resuspendAssoc, Diluent, Model[Sample, "Milli-Q water"]];

	(* get all of the pipetting parameters that were specified as an association*)
	pipettingParameterNames = Keys[SafeOptions[Experiment`Private`pipettingParameterOptions]];
	specifiedPipettingParameters = KeyTake[resuspendAssoc, pipettingParameterNames];

	(* generate the transfer primitive  *)
	transferPrimitive = Transfer[Join[
		<|
			Source -> diluent,
			Destination -> sample,
			Amount -> volume
		|>,
		specifiedPipettingParameters
	]];

	(* pull out all the mix option values *)
	allAutomaticMixOptionValues = Lookup[
		resuspendAssoc,
		{
			MixType,
			MixUntilDissolved,
			MixVolume,
			NumberOfMixes,
			MaxNumberOfMixes,
			IncubationTime,
			MaxIncubationTime,
			IncubationInstrument,
			IncubationTemperature,
			AnnealingTime
		},
		Automatic
	];


	(* determine if we are going to incubate or not *)
	incubateQ = MemberQ[allAutomaticMixOptionValues, Except[Automatic|Null]];

	(* split the mix options into their own variables the logic below to be more straightforward *)
	{
		specifiedMixType,
		specifiedMixUntilDissolved,
		specifiedMixVolume,
		specifiedNumMixes,
		specifiedMaxNumMixes,
		specifiedIncubationTime,
		specifiedMaxIncubationTime,
		specifiedIncubationInstrument,
		specifiedIncubationTemperature,
		speciifedAnnealingTime
	} = allAutomaticMixOptionValues;

	(* generate the Incubate or Mix primitive *)
	(* doing it in the association form so that Nothing works properly (i.e., Incubate[Sample -> blah, Nothing] doesn't collapse, but Incubate[<|Smaple -> blah, Nothing|>] does)*)
	incubatePrimitive = If[incubateQ,
		Incubate[<|
			Sample -> sample,
			If[MatchQ[specifiedMixType, Automatic|Null],
				Nothing,
				MixType -> specifiedMixType
			],
			If[MatchQ[specifiedMixUntilDissolved, Automatic|Null],
				Nothing,
				MixUntilDissolved -> specifiedMixUntilDissolved
			],
			If[MatchQ[specifiedMixVolume, Automatic|Null],
				Nothing,
				MixVolume -> specifiedMixVolume
			],
			If[MatchQ[specifiedNumMixes, Automatic|Null],
				Nothing,
				NumberOfMixes -> specifiedNumMixes
			],
			If[MatchQ[specifiedMaxNumMixes, Automatic|Null],
				Nothing,
				MaxNumberOfMixes -> specifiedMaxNumMixes
			],
			If[MatchQ[specifiedIncubationTime, Automatic|Null],
				Nothing,
				Time -> specifiedIncubationTime
			],
			If[MatchQ[specifiedMaxIncubationTime, Automatic|Null],
				Nothing,
				MaxTime -> specifiedMaxIncubationTime
			],
			If[MatchQ[specifiedIncubationInstrument, Automatic|Null],
				Nothing,
				Instrument -> specifiedIncubationInstrument
			],
			(* Add Ambient to the temperature if it's not specified because otherwise it will freak out*)
			If[MatchQ[specifiedIncubationTemperature, Automatic|Null],
				Temperature -> Ambient,
				Temperature -> specifiedIncubationTemperature
			],
			If[MatchQ[speciifedAnnealingTime, Automatic|Null],
				Nothing,
				AnnealingTime -> speciifedAnnealingTime
			]
		|>],
		Null
	];

	(* return the transfer and incubate primitives *)
	allPrimitives = DeleteCases[Flatten[{transferPrimitive, incubatePrimitive}], Null];

	allPrimitives

];







