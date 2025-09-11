(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*CompareObjects*)

(* Function for returning and/or printing the difference between multiple objects *)

(* ::Subsubsection:: *)
(*CompareObjects Error Messages*)
Error::CompareObjectsDatesLengthMismatch = "`1` objects are provided, however `2` download dates were provided. Please provide only 1 date, or one date per object.";
Error::CompareObjectsMoreInputsNeeded = "Please provide 2 or more objects to compare; or provide one object with at least 2 dates.";

(* ::Subsubsection:: *)
(*CompareObjects Options*)


DefineOptions[CompareObjects,
	Options :> {
		{
			OptionName -> OutputType,
			Default -> Differences,
			Description -> "The format of the output. Differences outputs an association of fields and their values, where the values differ between the objects provided. Fields outputs a list of fields where the values differ between the objects. Full outputs all fields, whether the values differ or not - most often used with printed output, where different colors are used to indicate matching.",
			AllowNull -> False,
			Category -> "General",
			Pattern :> Alternatives[Differences, Fields, Full]
		},
		{
			OptionName -> OutputFormat,
			Default -> Table,
			Description -> "Indicates how the output is visualized. Table returns a table of the output, with visual formatting. Association outputs the diff in association format.",
			AllowNull -> False,
			Category -> "General",
			Pattern :> Alternatives[Table, Association]
		},
		{
			OptionName -> Fields,
			Default -> Automatic,
			Description -> "The fields to compare between the objects.",
			ResolutionDescription -> "Automatically set to the union of all the fields of the objects provided.",
			AllowNull -> False,
			Category -> "General",
			Pattern :> Alternatives[All, ListableP[_Symbol], {}, Automatic]
		},
		{
			OptionName -> ExcludedFields,
			Default -> Automatic,
			Description -> "The fields to exclude from the comparison. Implemented after all other field resolution.",
			ResolutionDescription -> "Automatically set to fields that are not particularly relevant for this function, such as, but not limited to, log fields.",
			AllowNull -> True,
			Category -> "General",
			Pattern :> Alternatives[All, ListableP[_Symbol], {}, Automatic]
		},
		{
			OptionName -> SortMultiple,
			Default -> False,
			Description -> "Indicates if multiple fields should be sorted into canonical order before comparison.",
			AllowNull -> False,
			Category -> "General",
			Pattern :> BooleanP
		},
		{
			OptionName -> Date,
			Default -> Null,
			Description -> "A single time at which to compare or a list for each input object.",
			AllowNull -> True,
			Category -> "General",
			Pattern :> ListableP[_?DateObjectQ]
		},
		CacheOption
	}
];


(* ::Subsubsection:: *)
(*CompareObjects*)

(* ObjectP overloads *)
CompareObjects[myObjects : {ObjectP[] ..}, myOptions : OptionsPattern[]] :=
	Module[
		{parsedObjects},

		parsedObjects = Switch[#,
			LinkP[], Download[#, Object],
			PacketP[], Lookup[#, Object],
			ObjectReferenceP[], #
		] & /@ myObjects;

		CompareObjects[parsedObjects, myOptions]
	];

(* Single overload *)
CompareObjects[myObject : ObjectP[], myOptions : OptionsPattern[]] := CompareObjects[{myObject}, myOptions];

(* one-object-different-dates overload *)
CompareObjects[myObject : {ObjectReferenceP[]}, myOptions : OptionsPattern[]] := Module[
	{
		safeOps, date
	},

	(* determined all options *)
	safeOps = SafeOptions[CompareObjects, ToList[myOptions]];

	(* determine date *)
	date = Lookup[safeOps, Date];

	(* if Date contains more than one date, call CompareObjects properly otherwise return error *)
	If[
		MatchQ[date, {_?DateObjectQ, _?DateObjectQ..}],
		CompareObjects[ConstantArray[myObject[[1]], Length[date]], myOptions],
		Message[Error::CompareObjectsMoreInputsNeeded]; $Failed
	]
];

(* Two object convenience overload *)
CompareObjects[myObject1 : ObjectReferenceP[], myObject2 : ObjectReferenceP[], myOptions : OptionsPattern[]] :=
	CompareObjects[{myObject1, myObject2}, myOptions];

(* Empty Overload *)
CompareObjects[myObjects : NullP, myOptions : OptionsPattern[]] := (Message[Error::CompareObjectsMoreInputsNeeded]; $Failed);
CompareObjects[myObjects : {{} ...}, myOptions : OptionsPattern[]] := (Message[Error::CompareObjectsMoreInputsNeeded]; $Failed);

(* Main function *)
CompareObjects[myObjects : {ObjectReferenceP[] ..}, myOptions : OptionsPattern[]] := Module[
	{
		(* Inputs *)
		listedObjects, listedOptions, safeOps,

		(* Options lookup *)
		cacheOption, fields, excludedFields, outputType, outputFormat, sortMultiple, dates,

		(* Options resolution *)
		partiallyResolvedDownloadFields, downloadFields, partiallyResolvedFields, resolvedExcludedFields, resolvedFields,
		resolvedDates, fieldsToExclude, computableFields, arbitraryFields, logFields,

		(* Download *)
		objectPackets, cache, uniqueID, uniqueIds, rawObjectPackets,

		(* Comparisons *)
		fieldDiff, fieldDiffAssociation, fieldDiffGroups, sanitizeFieldValues, sanitizedField,

		(* Output *)
		table, fieldDiffOutput, fieldDiffFields, fieldDiffData, objectGroupNumbers, shortenedFieldDiffData,
		tabledOutputData, colorPalette, backgroundColors, backgroundColorsMM
	},

	(*Remove temporal links and named objects.*)
	{listedObjects, listedOptions} = Experiment`Private`sanitizeInputs[ToList[myObjects], ToList[myOptions]];

	safeOps = ECL`OptionsHandling`SafeOptions[CompareObjects, listedOptions];

	(* Lookup keys options *)

	{
		outputType, outputFormat, fields, excludedFields, sortMultiple, dates, cacheOption
	} = Lookup[safeOps,
		{
			OutputType, OutputFormat, Fields, ExcludedFields, SortMultiple, Date, Cache
		},
		Null
	];

	(* Resolve options *)
	(* If fields are not specified, resolve after the download *)
	partiallyResolvedDownloadFields = If[MatchQ[fields, Automatic],
		(* Get all keys that feature in any object *)
		{All},
		fields
	];

	(* Determine which fields are computable and exclude them *)
	computableFields = Module[
		{objectTypes, typeFieldReferences},

		(* Get a unique list of object types we're comparing *)
		objectTypes = DeleteDuplicates[myObjects[Type]];

		(* Get all of the fields in those types in format type[field] *)
		typeFieldReferences = Fields[objectTypes];

		(* Return the names of fields that are computable *)
		DeleteDuplicates[PickList[Last /@ typeFieldReferences, Lookup[LookupTypeDefinition /@ typeFieldReferences, Format], Computable]]
	];

	(* Determine log fields and exclude them *)
	logFields = Select[Fields[Output -> Short], StringEndsQ[ToString[#], "Log" | "Logs"] &];

	(* specify any other fields that don't provide relevant info here *)
	arbitraryFields = {
		Appearance, RequiredResources, SubprotocolRequiredResources, Checkpoints,
		CompletedTasks, ResolvedOptions, UnresolvedOptions, CheckpointProgress,
		Objects, RequestedResources
	};

	(* all log fields or any other not-useful fields to be excluded from comparison *)
	fieldsToExclude = Join[computableFields, logFields, arbitraryFields];

	(* Remove excluded fields *)
	resolvedExcludedFields = Switch[excludedFields,
		(* If no excluded fields are specified, exclude a few fields that can be generally annoying/not useful *)
		Automatic,
			fieldsToExclude,

		(* If given as Null, convert to empty list *)
		NullP,
			{},

		(* Otherwise, if specified, exclude the user specified fields *)
		_,
			Join[excludedFields /. Null :> {}, fieldsToExclude]
	];

	(* Remove the excluded fields from the field specification if not downloading all fields *)
	downloadFields = If[MatchQ[partiallyResolvedDownloadFields, {All}],
		partiallyResolvedDownloadFields,
		Complement[partiallyResolvedDownloadFields, resolvedExcludedFields]
	];

	(* Resolve the download date *)
	resolvedDates = ToList[dates] /. (Null -> Now);

	(* Throw an error if the dates don't index match the objects *)
	If[!MatchQ[Length[resolvedDates], Alternatives[1, Length[myObjects]]],
		Message[Error::CompareObjectsDatesLengthMismatch, Length[myObjects], Length[resolvedDates]];
		Return[$Failed]
	];

	(* Download all the information *)
	rawObjectPackets = Check[If[MatchQ[downloadFields, {All}],
		(* Use the quick version of download if downloading all fields *)
		Quiet[
			Download[
				listedObjects,
				Date -> Evaluate[resolvedDates],
				Cache -> cacheOption
			],
			{Download::FieldDoesntExist, Download::NotLinkField}
		],
		(* Otherwise download just the fields required *)
		Quiet[
			Download[
				listedObjects,
				Evaluate[Packet @@ downloadFields],
				Date -> Evaluate[resolvedDates],
				Cache -> cacheOption
			],
			{Download::FieldDoesntExist, Download::NotLinkField}
		]
	], $Failed];

	(* if Download throws any errors, other than the quieted ones, return $Failed *)
	If[FailureQ[rawObjectPackets], Return[$Failed]];

	(* create new cache *)
	cache = Experiment`Private`FlattenCachePackets[{cacheOption, objectPackets}];

	(* since objects might be the same, assign a new unique id to each packet *)
	uniqueIds = Range[Length[rawObjectPackets]];
	objectPackets = MapThread[Append[#1, uniqueID -> #2]&, {rawObjectPackets, uniqueIds}];

	(* Finish resolving the fields now we have info from the download *)

	(* Resolve options *)
	(* If fields are not specified, get the union of all the fields *)
	partiallyResolvedFields = If[MatchQ[fields, Automatic],
		(* Get all keys that feature in any object *)
		Union[Flatten[Keys /@ objectPackets]],
		partiallyResolvedDownloadFields
	];

	(* Remove the excluded fields from the field specification if not already *)
	resolvedFields = If[MatchQ[partiallyResolvedDownloadFields, {All}],
		Complement[partiallyResolvedFields, resolvedExcludedFields],
		downloadFields
	];

	(* Compare the field values *)
	(* Sanitize field values for e.g. object references *)
	sanitizeFieldValues[values : {__}, sort : BooleanP] := Module[
		{sanitizeRules, sanitized},
		sanitizeRules = {
			Link[x_, back_Symbol, int_Integer, _String, _?DateObjectQ] :> Link[x, back, int],
			Link[x_, back_Symbol, _String, _?DateObjectQ] :> Link[x, back],
			Link[x_, _String, _?DateObjectQ] :> Link[x]
		};

		(* Make object references consistent *)
		sanitized = values /. sanitizeRules;

		(* Sort multiple fields if requested *)
		If[sort && MatchQ[values, {{__} ..}],
			Sort /@ sanitized,
			sanitized
		]
	];

	(* Compare the fields *)
	fieldDiff = Map[
		Function[{fieldName},
			Module[
				{
					fieldValues, sanitizedFieldValues, resolvedComparisonFunction, augmentedPackets
				},

				(* Extract the field values *)
				fieldValues = Lookup[objectPackets, fieldName, "DNE"];

				(* Sanitize the object references *)
				sanitizedFieldValues = sanitizeFieldValues[fieldValues, sortMultiple];

				(* Work out which function to use to compare the field *)
				resolvedComparisonFunction = If[Length[Cases[fieldValues, _?NumericQ]] > 0,
					EqualQ,
					(* This will apply to objects too as already sanitized *)
					SameQ
				];

				(* Add sanitized field to packet to enable gathering *)
				augmentedPackets = MapThread[
					Append[#1, sanitizedField -> #2] &,
					{objectPackets, sanitizedFieldValues}
				];

				(* Return full values regardless of output *)
				{
					fieldName,
					sanitizedFieldValues,
					GatherBy[augmentedPackets, #[sanitizedField]&] /. AssociationThread[augmentedPackets, Lookup[augmentedPackets, uniqueID]]
				}

			]
		],
		DeleteCases[resolvedFields, uniqueID]
	];

	(* Filter out fields that are the same if required *)
	fieldDiffOutput = If[MatchQ[outputType, Full],
		fieldDiff,
		(* If outputting the diff, select only fields with a difference *)
		Select[fieldDiff, Length[#[[3]]] > 1&]
	];

	(* return early if no differences found *)
	If[MatchQ[fieldDiffOutput, {}], Return["No key differences found."]];

	(* separate  *)
	{fieldDiffFields, fieldDiffData, fieldDiffGroups} = Transpose[fieldDiffOutput];

	(* shorten data for proper display of long values *)
	shortenedFieldDiffData = Map[Short[#, 5]&, fieldDiffData, {2}];

	(* Convert the diffs to an association *)
	fieldDiffAssociation = AssociationThread[fieldDiffFields, fieldDiffData];

	(* Return if we just want the field names *)
	If[MatchQ[outputType, Fields],
		Return[fieldDiffFields]
	];

	(* If we're printing output, do so here *)
	table = If[MatchQ[outputFormat, Table],

		(* Convert each cell data point into table form for easier display *)
		tabledOutputData = Map[TableForm, shortenedFieldDiffData, {2}];

		(* Get the group number that each object is in for each field *)
		objectGroupNumbers = Outer[Position[#1, #2][[1, 1]]&, fieldDiffGroups, uniqueIds, 1];

		(* Generate colors for the background *)
		colorPalette = Nest[Lighter, Prepend[ColorData[1, "ColorList"], Gray], 3];

		(* Generate the background color specification, based on which group the object is in *)
		backgroundColors = Map[colorPalette[[#]] &, objectGroupNumbers, {2}];

		(* Convert to the MM syntax *)
		backgroundColorsMM = {None, None, Flatten@Outer[{#1 + 1, #2 + 1} -> backgroundColors[[#1, #2]] &, Sequence @@ Range[Dimensions[backgroundColors]]]};

		PlotTable[tabledOutputData, TableHeadings -> {fieldDiffFields, listedObjects}, Background -> backgroundColorsMM]
	];

	(* Return the output *)
	Switch[outputFormat,
		Association,
			fieldDiffAssociation,
		Table,
			table,
		_,
			Null
	]
];