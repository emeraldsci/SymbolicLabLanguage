(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Helper Parser Functions (UploadMolecule/UploadSampleModel)*)

(* ::Subsubsection::Closed:: *)
(* parsePubChemCID Helpers *)


(* safeParse *)
(* Small helper to wrap an expression in Quiet and Check, and return $Failed if parsing fails, just because we do this a lot *)
(* Additional overload to also check that the value produced matches the expected pattern *)
(* We return $Failed so that subsequent code in this function knows that parsing failed, rather than returned an empty value *)

(* Don't prematurely evaluate the code block *)
SetAttributes[safeParse, HoldAll];

(* Simple quiet/check construct *)
safeParse[expr_] := Quiet[Check[expr, $Failed]];

(* Additional overload that checks the output matches a pattern too *)
safeParse[expr_, pattern_] := Module[
	{returnValue},

	returnValue = safeParse[expr];

	(* Return the value if it matches the expected pattern, otherwise return $Failed *)
	If[MatchQ[returnValue, pattern],
		returnValue,
		$Failed
	]
];


(* extractJSON *)
(* Helper to extract data entries from JSON *)
(* Takes a list of keys and looks up in the json in a nested fashion. Keys of form "a"=="b" apply to lists of associations and will pick the *)
(* First association where the key "a" has value of "b" *)

(* Ensure the a==b syntax doesn't prematurely evaluate *)
SetAttributes[extractJSON, HoldRest];

extractJSON::MissingKey = "Key `1` could not be found.";

extractJSON[json : Alternatives[_Association, {_Association..}], path : {Alternatives[_String, Equal[_String, _String]]..}] := Module[
	{heldPaths},

	(* Hold each member of the paths individually, so we can easily map over them. As some use the Equal syntax *)
	heldPaths = List @@ (Hold /@ Hold @@ Unevaluated[path]);

	(* Iterate over the keys and extract deeper into the JSON. Exit early if we hit a problem *)
	Catch[Fold[
		Function[{data, heldKey},
			Which[
				(* Exit early if the data is no longer in a valid format *)
				MatchQ[data, $Failed],
				data,

				(* If the top level data is an Association and a key was provided, it's a simple lookup *)
				MatchQ[data, _Association] && MatchQ[heldKey, Hold[_String]],
				Lookup[data, ReleaseHold[heldKey]],

				(* If the top level data is an Association, but equality provided. Can't proceed *)
				MatchQ[data, _Association],
				Message[extractJSON::MissingKey, heldKey];
				Throw[$Failed],

				(* If a list of associations and key provided, don't proceed right now *)
				MatchQ[heldKey, Hold[_String]],
				Message[extractJSON::MissingKey, heldKey];
				Throw[$Failed],

				(* Otherwise we have a list of associations and we have an equality key, so select the first association that matches the equality *)
				True,
				SelectFirst[
					data,
					MatchQ[Lookup[#, heldKey[[1, 1]]], heldKey[[1, 2]]] &,
					Message[extractJSON::MissingKey, heldKey];
					Throw[$Failed]
				]
			]
		],
		json,
		heldPaths
	]]
];
extractJSON[___] := $Failed;


(* extractValues *)
(* When we have a list of associations containing the data we need in PubChem format, helper to pull out all the data entries that match a pattern *)

(* Don't prematurely evaluate the pattern *)
SetAttributes[extractValues, HoldRest];

(* Main pattern overload - extract field values that MatchQ the pattern *)
extractValues[associationList : {_Association..}, pattern_] := Module[
	{valueData},

	(* Extract the value data - each is an association with keys such as "StringWithMarkup" *)
	valueData = Lookup[associationList, "Value"];

	(* Use cases to pull out anything from the values that matches the pattern *)
	Cases[valueData, pattern, Infinity]
];

(* Overload to pull out strings that don't match formatting text *)
extractValues[associationList : {_Association..}] := extractValues[associationList, Except[Alternatives["Italics", "Superscript", "Subscript"], _String]];
extractValues[{}, ___] := {};


(* extractStringValues *)
(* Wrapper to extractValues that matches string expressions. Longest match per string provided *)
(* StringPattern can be a simple StringExpression, where the whole matching expression is returned *)
(* Or a rule delayed can be supplied, as for StringCases, to extract part of the matching string, such as LetterCharacter ~~ x : DigitCharacter :> x *)

(* Don't prematurely evaluate the string pattern *)
SetAttributes[extractStringValues, HoldRest];

(* Core overload - accepts myOptions to pass through options, such as CaseSensitive to StringCases *)
extractStringValues[associationList : {_Association..}, stringPattern : _, All, myOptions : OptionsPattern[]] := Module[
	{allStrings},

	(* Extract all strings *)
	allStrings = extractValues[associationList];

	(* Extract all occurrences of the string pattern *)
	StringCases[allStrings, stringPattern, myOptions (* Mainly to accept case sensitive *)]
];

(* Overload to just extract one value per string - the longest *)
extractStringValues[associationList : {_Association..}, stringPattern : _, myOptions : OptionsPattern[]] := First[MaximalBy[#, StringLength[ToString[#]] &], Nothing] & /@ extractStringValues[associationList, stringPattern, All, myOptions];
extractStringValues[{}, ___] := {};


(* takeCommonest *)
(* Helper to take the most frequent value from a list. Taking the shortest if a tie *)
takeCommonest[myList_List] := First[SortBy[Commonest[myList], StringLength]];


(* dotHazardInformation *)
(* Helper for loading DOT hazard information from constellation *)
dotHazardInformation[] := Module[
	{rawData, dataAssociations},

	(* Import the raw data *)
	rawData = First[ImportCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "2839ab6f678c00e033bbb46e1d53638b.xls"]]];

	(* Parse the data *)
	dataAssociations = Module[
		{columnNames, subColumnNames, combinedColumnNames},

		(* Pull out the column names *)
		columnNames = rawData[[2]];
		subColumnNames = rawData[[3]];

		(* Combine the column and subcolumn names - the column name continues from the previous one if it's empty *)
		combinedColumnNames = Module[
			{expandedHeadings},

			(* Expand the column names to cover all the sub-columns *)
			expandedHeadings = Fold[
				Module[{newColumn},
					newColumn = If[MatchQ[#2, ""], Last[#1, Null], #2];
					Append[#1, newColumn]
				] &,
				{},
				columnNames
			];

			(* Combine the names *)
			MapThread[
				StringJoin[#1, #2]&,
				{expandedHeadings, subColumnNames}
			]
		];

		(* Extract the data for each molecule and each column *)
		Map[
			Function[line,
				AssociationThread[combinedColumnNames -> line]
			],
			rawData[[5 ;;]] (* Data starts on line 5 *)
		]
	];

	(* Memoize if it worked *)
	If[MatchQ[dataAssociations, {_Association..}],
		If[!MemberQ[$Memoization, ExternalUpload`Private`dotHazardInformation],
			AppendTo[$Memoization, ExternalUpload`Private`dotHazardInformation]
		];
		Set[dotHazardInformation[], dataAssociations]
	];

	(* Return the data *)
	dataAssociations
];


(* dotHazardClass *)
(* Very simple helper to go from UN Number to DOT Class *)
dotHazardClass[unNumber : _String?(StringMatchQ[#, "UN" ~~ Repeated[DigitCharacter, {4}]]&)] := Module[
	{dotHazardAssociation},

	(* Pull out the first entry in our DOT hazard lookup that matches our compound *)
	dotHazardAssociation = SelectFirst[dotHazardInformation[], MatchQ[Lookup[#, "ID Numbers"], unNumber] &, <||>];

	(* Return the hazard class entry *)
	Lookup[dotHazardAssociation, "Hazard class or Division", Null]
];



(* ::Subsection::Closed:: *)
(*PubChem CID To Association (parsePubChemCID)*)


(* Helper function to go from a PubChem CID (Compound ID) to an association of relevant information. *)
(* We do not memoize this function because it should always be called by another memoized function. *)
(* These other higher level functions check if they fail and do not memoize if so. *)
parsePubChemCID[cid_] := Module[
	{
		pubchemRecord, moleculeName, namesAndIdentifiersJSON,
		chemicalAndPhysicalProperties, computedChemicalAndPhysicalProperties, experimentalChemicalAndPhysicalProperties,
		computedDescriptorsJSON, molecularFormula, exactMass, monatomic, radioactive, drainDisposal, hCodesSplit, pCodesSplit,
		iupacName, inchi, inchiKey, otherIdentifiersJSON, casNumber, unii, synonyms, pungent, molecule,
		molecularWeight, simulatedLogP, logP, state, pkas, viscosity, meltingPoint, boilingPoint, vaporPressure, density, hazardous, flammable,
		pyrophoric, waterReactive, fuming, ventilated, lightSensitive, pCodes, hCodes, safetyAndHazards, unNumber, dotHazard, nfpaHazards, structureFileURL, imageFileURL,
		incompatibleMaterials, stronglyAcidic, stronglyBasic, corrosive, particularlyHazardousSubstance, msdsRequired
	},

	(* Download the PubChem record *)
	pubchemRecord = Module[
		{pubChemCIDURL, filledPubChemURL, httpResponse, bodyResponse, jsonResponse},

		(* The following is the template URL of the PubChem API for CIDs. The CID goes in `1`. *)
		pubChemCIDURL = "https://pubchem.ncbi.nlm.nih.gov/rest/pug_view/data/compound/`1`/JSON/";

		(* Fill out the template URL with the given CID. *)
		filledPubChemURL = StringTemplate[pubChemCIDURL][ToString[cid]];

		(* Get the body of the response from this URL. *)
		httpResponse = ManifoldEcho[
			URLRead[filledPubChemURL],
			"URLRead[\"" <> ToString[filledPubChemURL] <> "\"]"
		];

		(* Return status code early if the URLRead failed *)
		If[!MatchQ[httpResponse["StatusCode"], 200],
			(*Return[httpResponse["StatusCode"], Module] - return more detail when rest of error handling is merged*)
			$Failed
		];

		bodyResponse = Quiet[httpResponse["Body"]];

		(* Some of the entries on PubChem have bad UTF-8 encodings. Export as a correct UTF-8 encoding in order to generate a valid JSON response. *)
		jsonResponse = Quiet[ImportString[ExportString[bodyResponse, "Text", CharacterEncoding -> "UTF8"], "RawJSON"]];

		(* If an error was returned, return a $Failed. Throw a message in the higher level function that called this one. *)
		If[MatchQ[jsonResponse, _Failure | $Failed | KeyValuePattern["Fault" -> _]],
			$Failed,
			Lookup[jsonResponse, "Record"]
		]
	];


	(* If an error was returned, return $Failed. Throw a message in the higher level function that called this one. *)
	If[!MatchQ[pubchemRecord, _Association],
		Return[pubchemRecord];
	];


	(* Do the parsing! *)

	(* Top level *)
	(* Molecule name *)
	moleculeName = safeParse[
		Lookup[pubchemRecord, "RecordTitle", Null],

		_String
	];


	(* Names and Identifiers *)
	(* Parse out the "Names and Identifiers" section *)
	namesAndIdentifiersJSON = safeParse[extractJSON[pubchemRecord, {"Section", "TOCHeading" == "Names and Identifiers", "Section"}], _List];

	(* Parse out Synonyms *)
	synonyms = safeParse[
		Module[
			{synonymDataAssociations, allSynonyms},

			(* Extract the list of associations containing synonym data *)
			synonymDataAssociations = extractJSON[namesAndIdentifiersJSON, {"TOCHeading" == "Synonyms", "Section", "TOCHeading" == "MeSH Entry Terms", "Information"}];

			(* Extract the whole strings - each is a synonym *)
			allSynonyms = extractValues[synonymDataAssociations];

			(* Add the molecule name if it's not a member *)
			If[!MemberQ[allSynonyms, moleculeName],
				Prepend[allSynonyms, moleculeName],
				allSynonyms
			]
		],

		(* Ensure a list of strings is returned *)
		{_String...}
	];

	(* Molecular formula *)
	molecularFormula = safeParse[
		Module[
			{molecularFormulaDataAssociations, allFormulae},

			(* Extract the list of associations containing molecular formula data *)
			molecularFormulaDataAssociations = extractJSON[namesAndIdentifiersJSON, {"TOCHeading" == "Molecular Formula", "Information"}];

			(* Extract any strings or parts of strings that match the pattern for a molecular formula *)
			allFormulae = extractStringValues[molecularFormulaDataAssociations, Alternatives[LetterCharacter, DigitCharacter]..];

			(* Take the most frequent formula found *)
			takeCommonest[allFormulae]
		],

		(* Ensure a single molecular formula string is returned *)
		_String?(StringMatchQ[#, Alternatives[LetterCharacter, DigitCharacter]..] &)
	];

	(* Monatomic - do we just have one atom? *)
	monatomic = safeParse[
		If[StringQ[molecularFormula],
			(* If we have a molecular formula, we can tell if it's monatomic or not *)
			StringMatchQ[
				molecularFormula,
				(* Will be a single chemical symbol, either a single upper case letter, or upper case followed by lower case *)
				StringExpression[
					(* Single capital letter *)
					Alternatives @@ CharacterRange["A", "Z"],

					(* Optionally followed by lower case letter *)
					Alternatives[
						"",
						Alternatives @@CharacterRange["a", "z"]
					]
				]
			],

			(* No formula means we can't tell *)
			Null
		],

		Alternatives[BooleanP, Null]
	];

	(* Radioactive *)
	radioactive = safeParse[
		Module[
			{descriptionDataAssociations},

			(* Extract the list of associations containing description information *)
			descriptionDataAssociations = extractJSON[namesAndIdentifiersJSON, {"TOCHeading" == "Record Description", "Information"}];

			(* There is no specific information in the record for radioactive. However, as it's a big deal, it always gets mentioned in the description, so look there *)
			(* If it's not mentioned, it's almost certain it's not radioactive *)
			!MatchQ[extractStringValues[descriptionDataAssociations, Alternatives["radioactive"], IgnoreCase -> True], {}]
		],

		Alternatives[BooleanP, Null]
	];


	(* Computed Descriptors *)
	(* Parse out the "Computed Descriptors" section *)
	computedDescriptorsJSON = safeParse[extractJSON[namesAndIdentifiersJSON, {"TOCHeading" == "Computed Descriptors", "Section"}], _List];

	(* IUPAC systematic name *)
	iupacName = safeParse[
		Module[
			{iupacDataAssociations, allNames},

			(* Extract the list of associations containing IUPAC name data *)
			iupacDataAssociations = extractJSON[computedDescriptorsJSON, {"TOCHeading" == "IUPAC Name", "Information"}];

			(* Extract any strings or parts of strings that match the pattern for an IUPAC name *)
			allNames = extractStringValues[iupacDataAssociations, Alternatives[LetterCharacter, DigitCharacter, PunctuationCharacter, Whitespace]..];

			(* Take the most frequent name found *)
			takeCommonest[allNames]
		],

		_String
	];

	(* InChI, systematic identifier *)
	inchi = safeParse[
		Module[
			{inchiDataAssociations, allInChIs},

			(* Extract the list of associations containing InChI data *)
			inchiDataAssociations = extractJSON[computedDescriptorsJSON, {"TOCHeading" == "InChI", "Information"}];

			(* Extract any strings or parts of strings that match the pattern for an InChI. We can't use InChIP here as that's a pattern not a string pattern *)
			allInChIs = extractStringValues[inchiDataAssociations, "InChI=" ~~ Except[WhitespaceCharacter]..];

			(* Take the most frequent identifier found *)
			takeCommonest[allInChIs]
		],

		InChIP
	];

	(* InChIKey, hashed version of InChI. Highly unlikely to clash, but easier for database searching *)
	inchiKey = safeParse[
		Module[
			{inchiKeyDataAssociations, allInChIKeys},

			(* Extract the list of associations containing InChiKey data *)
			inchiKeyDataAssociations = extractJSON[computedDescriptorsJSON, {"TOCHeading" == "InChIKey", "Information"}];

			(* Extract any strings or parts of strings that match the pattern for an InChI. We can't use InChIKeyP here as that's a pattern not a string pattern *)
			allInChIKeys = extractStringValues[inchiKeyDataAssociations, Repeated[WordCharacter, {14}] ~~ "-" ~~ Repeated[WordCharacter, {10}] ~~ "-" ~~ WordCharacter];

			(* Take the most frequent identifier found *)
			takeCommonest[allInChIKeys]
		],

		InChIKeyP
	];

	(* Generate the molecular representation, if we can *)
	molecule = safeParse[
		Molecule[inchi],
		_Molecule
	];


	(* Other identifiers *)
	(* Parse out the "Other Identifiers" section *)
	otherIdentifiersJSON = safeParse[extractJSON[namesAndIdentifiersJSON, {"TOCHeading" == "Other Identifiers", "Section"}], _List];

	(* CAS registration number *)
	casNumber = safeParse[
		Module[
			{casDataAssociations, allCASNumbers},

			(* Extract the list of associations containing CAS number data *)
			casDataAssociations = extractJSON[otherIdentifiersJSON, {"TOCHeading" == "CAS", "Information"}];

			(* Extract any strings or parts of strings that match the pattern for a CAS Number. We can't use CASNumberP here as that's a pattern not a string pattern *)
			allCASNumbers = extractStringValues[casDataAssociations, Repeated[DigitCharacter, {2, 7}] ~~ "-" ~~ Repeated[DigitCharacter, {2}] ~~ "-" ~~ DigitCharacter];

			(* Take the most frequent identifier found *)
			takeCommonest[allCASNumbers]
		],

		CASNumberP
	];

	(* UNII (FDA unique ingredient identifier) registration number *)
	unii = safeParse[
		Module[
			{uniiDataAssociations, allUniiNumbers},

			(* Extract the list of associations containing UNII data *)
			uniiDataAssociations = extractJSON[otherIdentifiersJSON, {"TOCHeading" == "UNII", "Information"}];

			(* Extract any strings or parts of strings that match the pattern for a UNII Number *)
			allUniiNumbers = extractStringValues[uniiDataAssociations, WordCharacter..];

			(* Take the most frequent identifier found *)
			takeCommonest[allUniiNumbers]
		],

		_String?(StringMatchQ[#, WordCharacter..] &)
	];

	(* UN shipping hazard identifier number *)
	unNumber = safeParse[
		Module[
			{unNumberAssociations, allUNNumbers},

			(* Extract the list of associations containing UN Number data *)
			unNumberAssociations = extractJSON[otherIdentifiersJSON, {"TOCHeading" == "UN Number", "Information"}];

			(* Extract any strings or parts of strings that match the pattern for a UN Number - 4 digits *)
			allUNNumbers = extractStringValues[unNumberAssociations, WordBoundary ~~ x : Repeated[DigitCharacter, {4}] ~~ WordBoundary :> x];

			(* Take the most frequent identifier found *)
			takeCommonest[allUNNumbers]
		],

		_String?(StringMatchQ[#, Repeated[DigitCharacter, {4}]] &)
	];


	(* Physical properties *)
	(* Parse out the "Chemical and Physical Properties" section *)
	chemicalAndPhysicalProperties = safeParse[extractJSON[pubchemRecord, {"Section", "TOCHeading" == "Chemical and Physical Properties", "Section"}], _List];

	(* Computed Properties *)
	(* Parse out the "Computed Properties" section *)
	computedChemicalAndPhysicalProperties = safeParse[extractJSON[chemicalAndPhysicalProperties, {"TOCHeading" == "Computed Properties", "Section"}], _List];

	(* Molecular weight *)
	molecularWeight = safeParse[
		Module[
			{molecularWeightAssociations, molecularWeightTuples, allMolecularWeights},

			(* Extract the list of associations containing MW data *)
			molecularWeightAssociations = extractJSON[computedChemicalAndPhysicalProperties, {"TOCHeading" == "Molecular Weight", "Information"}];

			(* Molecular weights come in an association, split into values and units, so extract both parts *)
			molecularWeightTuples = extractValues[
				molecularWeightAssociations,

				(* Value may be a number in "Number", or a string in "StringWithMarkup". Unit is in "Unit" *)
				(* Check for something with a unit *)
				x : AssociationMatchP[<|"Unit" -> _|>, AllowForeignKeys -> True] :> Which[
					(* String value *)
					KeyExistsQ[x, "StringWithMarkup"],
					{
						ToExpression[Lookup[Lookup[x, "StringWithMarkup"], "String"][[1]]],
						Lookup[x, "Unit"]
					},

					(* Numeric value *)
					KeyExistsQ[x, "Number"],
					{
						Lookup[x, "Number"][[1]],
						Lookup[x, "Unit"]
					},

					(* No data *)
					True,
					Nothing
				]
			];

			(* Convert the tuples to quantities and filter out any invalid values *)
			allMolecularWeights = Map[
				Function[tuple,
					(* Quantity can convert "g/mol" string into units very fast locally *)
					With[{quantity = Quiet[Quantity @@ tuple]},
						If[UnitsQ[quantity, Gram / Mole],
							quantity,
							Nothing
						]
					]
				],
				molecularWeightTuples
			];

			(* Return the median if there are multiple values *)
			SafeRound[Median[allMolecularWeights], 0.01 Gram / Mole]
		],

		GreaterP[0 Gram / Mole]
	];


	(* Parse the Exact mass *)
	(* This is the most abundant mass of the molecule calculated using the natural abundance of isotopes on Earth *)
	(* Note that this is *not* the same as using the mass for the most abundant isotope for each element *)
	(* E.g. If an element, X, has two isotopes with mass 1 and 2, with 49 % and 51 % abundance *)
	(* For one atom of X, most abundant mass is 2 (51 % weighting) *)
	(* For 2 atoms of X, most abundant mass is *3* (50 % weighing) - you are statistically most likely to get one atom of each, not 2 of the most abundant *)
	(* Monoisotopic mass is the term for the mass using the mass of the most abundant isotope for each atom and summing those *)
	exactMass = safeParse[
		Module[
			{exactMassAssociations, exactMasses, validExactMasses},

			(* Extract the list of associations containing the exact mass *)
			exactMassAssociations = extractJSON[computedChemicalAndPhysicalProperties, {"TOCHeading" == "Exact Mass", "Information"}];

			(* Extract exact mass if there is one - held in string form *)
			exactMasses = extractStringValues[exactMassAssociations, NumberString];

			(* Filter out invalid entries *)
			validExactMasses = Module[{quantity},
				quantity = Quiet[ToExpression[#] Gram / Mole];

				If[Quiet[GreaterQ[quantity, 0 Gram / Mole]],
					quantity,
					Nothing
				]
			] & /@ exactMasses;

			(* Return the value from the first valid reference if there are multiple values (should only be one) *)
			First[validExactMasses]
		],

		GreaterP[0 Gram / Mole]
	];

	(* Simulated LogP *)
	simulatedLogP = safeParse[
		Module[
			{simulatedLogPDataAssociations, allSimulatedLogPs},

			(* Extract the list of associations containing simulated logP data *)
			simulatedLogPDataAssociations = extractJSON[computedChemicalAndPhysicalProperties, {"TOCHeading" == "XLogP3", "Information"}];

			(* Simulated logPs are numbers in the numeric field *)
			allSimulatedLogPs = extractValues[simulatedLogPDataAssociations, _?NumericQ];

			(* Return the median if there are multiple values *)
			SafeRound[Median[allSimulatedLogPs], 0.01]
		],

		NumericP
	];

	(* Experimental Properties *)
	(* Parse out the "Experimental Properties" section *)
	experimentalChemicalAndPhysicalProperties = safeParse[extractJSON[chemicalAndPhysicalProperties, {"TOCHeading" == "Experimental Properties", "Section"}], _List];

	(* LogP *)
	logP = safeParse[
		Module[
			{logPDataAssociations, allLogPs},

			(* Extract the list of associations containing experimental logP data *)
			logPDataAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "LogP", "Information"}];

			(* LogPs may be stored in numeric form or string form, so extract both *)
			allLogPs = Join[
				(* Some values are numeric *)
				extractValues[logPDataAssociations, _?NumericQ],

				(* Other values are in strings *)
				extractStringValues[
					logPDataAssociations,
					{
						(* Strings of the form e.g. "-0.30" *)
						StartOfString ~~ x : NumberString ~~ EndOfString :> ToExpression[x],

						(* Strings of the form e.g. "log Kow = -0.30" *)
						"log Kow = " ~~ x : NumberString :> ToExpression[x]
					}
				]
			];

			(* Return the median if there are multiple values *)
			SafeRound[Median[allLogPs], 0.01]
		],

		NumericP
	];

	(* pKa - note that each molecule may have multiple pkas. We store all acid dissociation constants in the database *)
	pkas = safeParse[
		Module[
			{pkaDataAssociations, allpKas, clusteredpKas, allpKaEntries, splitpKaEntries, sanitizedpKaEntries},

			(* Extract the list of associations containing experimental pka data *)
			pkaDataAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Dissociation Constants", "Information"}];

			(* pKas are stored in string form *)
			(* Most pKa records don't have detailed condition information, don't indicate which part of the molecule the constant refers to, nor if it's pKa/pKaH so this isn't going to be perfect *)
			(* Potentially pKa can be measured in different solvents too... *)
			(* Each string can contain multiple values if the molecule has multiple acidic protons *)
			(* First extract all of the string entries *)
			allpKaEntries = extractValues[pkaDataAssociations];

			(* Each record might contain multiple values, so split *)
			splitpKaEntries = StringTrim[Flatten[StringSplit[allpKaEntries, ";"]]];

			(* Remove any entries that are particularly suspicious, suggesting they're not an actual pKa of the molecule *)
			sanitizedpKaEntries = Select[splitpKaEntries, !StringContainsQ[#, Alternatives["cation", "pkah", "protonated", "conjugate"], IgnoreCase -> True] &];

			(* Pull pkas out of the sanitized strings *)
			allpKas = StringCases[
				sanitizedpKaEntries,
				{
					(* Strings of the form e.g. "2.01". If the number begins at the start of the string, we can be confident it's a pKa *)
					StartOfString ~~ x : NumberString :> ToExpression[x],

					(* "pKa 1 = " *)
					StringExpression[
						"pKa",
						Whitespace..,
						DigitCharacter..,
						Alternatives[Whitespace... ~~ Alternatives[":", "="]],
						Whitespace...,
						x : NumberString
					] :> ToExpression[x],

					(* "pKa =", "pK1:", "pK2" but not "pKb" as that's different *)
					StringExpression[
						"pK", Alternatives["a", DigitCharacter],
						Alternatives[Whitespace... ~~ Alternatives[":", "="], " "],
						Whitespace...,
						x : NumberString
					] :> ToExpression[x]
				}
			];

			(* We don't know how many pKas there might be so cluster as best we can. Treat anything within 0.5 as the same value *)
			(* A simple gather by a threshold is much faster and gives more intuitive results that the fancy ML FindClusters... *)
			clusteredpKas = Gather[Flatten[allpKas], (LessEqualQ[Abs[#1 - #2], 0.5]) &];

			(* Return the median for each cluster *)
			Sort[SafeRound[Median[#], 0.01] & /@ clusteredpKas]
		],

		{NumericP...}
	];

	(* Viscosity *)
	viscosity = safeParse[
		Module[
			{viscosityDataAssociations, viscosityTemperatureTuples, medianViscosity},

			(* Extract the list of associations containing experimental viscosity data *)
			viscosityDataAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Viscosity", "Information"}];

			(* Viscosities are stored in string form *)
			(* Records may contain temperature or dilution information. Important to filter out data not for pure compound, or near room temperature as it could be 100x out *)
			(* Each string may contain multiple values, under different conditions *)
			viscosityTemperatureTuples = Module[
				{viscosityString, temperatureString, referenceString, recordDelimiter, allViscosityEntries, allViscosityStrings, viscosityStringTuples, viscosityTemperatureTuples},

				(* Define some useful string forms *)
				(* The actual viscosity *)
				(* "1 cP", "1.1 - 1.2 Pa.s" etc *)
				viscosityString = StringExpression[
					(* Optional second value for viscosity range *)
					Alternatives[
						StringExpression[
							visc1 : NumberString,
							Whitespace...,
							Alternatives["to", "To", "TO", "-"],
							Whitespace...
						],
						""
					],

					(* We must have at least this one value *)
					visc2 : NumberString,
					Whitespace...,
					(* Poise, POISE, CENTIPOISES, cP, mPa.s, mPa-sec *)
					units : StringExpression[WordCharacter..., Alternatives["poise", "Poise", "POISE", "P", "Pa-s", "Pa.s", "Pa*s"], WordCharacter...],
					WordBoundary
				];

				(* Qualifies temperature at which reading was taken *)
				(* "at 298 K", "@ 300 Fahrenheit" etc *)
				temperatureString = StringExpression[
					Alternatives["AT", "At", "at", "@"],
					Whitespace...,
					temp : StringExpression[
						NumberString,
						Whitespace...,
						Alternatives["\[Degree]C", "\[Degree]F", "K", "Celsius", "Centigrade", "Fahrenheit", "Kelvin"]
					]
				];

				(* Quantity reference *)
				(* "(Smith et al., 2008)" etc *)
				referenceString = StringExpression[
					"(",
					Except[")"].., (* Reference name - could be in many forms. We'll take the chance it doesn't include parentheses *)
					",",
					Whitespace...,
					Repeated[DigitCharacter, {4}], (* Year *)
					")"
				];

				(* Record delimiter - splitting multiple records in same entry *)
				recordDelimiter = Alternatives[";"];

				(* We need to be defensive about string pattern matching, so don't allow random stuff in the string *)
				(* For example, ethylene glycol (PubChem[174) contains many records of the form "PEG 400: 105 to 130 mPa.s at 20 °C;" where "PEG 400" is *not* ethylene glycol *)
				(* Additionally, glycerin (PubChem[753]) has a record "17 CENTIPOISES AT 25 °C (70% SOLN)" which again is not for the pure molecule of interest *)

				(* First pull out any strings that contain a viscosity. May contain multiple records and may not be for pure compound *)
				allViscosityEntries = extractStringValues[
					viscosityDataAssociations,
					StartOfString ~~ ___ ~~ viscosityString ~~ ___ ~~ EndOfString
				];

				(* Now split each string to make sure each string only contains one record. *)
				(* (It's challenging to pull out whole records from "record1; record2; record3;" with StringCases because the delimiter can only belong to one match, and allowing overlaps gets complicated) *)
				(* String expressions don't have positive lookahead like regex *)
				allViscosityStrings = Flatten[StringSplit[allViscosityEntries, recordDelimiter]];

				(* Now pull out viscosity information from the string, but only if there is no superfluous information that's a red flag for an invalid value *)
				(* In form {{viscosity1 (optional for range), viscosity2, viscosity units, temperature of measurement}..} *)
				viscosityStringTuples = Flatten[StringCases[
					allViscosityStrings,
					StringExpression[
						StartOfString, (* Don't allow random stuff at beginning of entry which often indicates the wrong type of molecule *)
						Whitespace...,
						viscosityString,
						Whitespace...,
						Alternatives[temperatureString, ""],
						Whitespace...,
						Alternatives[referenceString, ""],
						EndOfString (* Don't allow random stuff at the end of entry which often indicates dilution/modification of the molecule *)
					] :> {visc1, visc2, units, temp}
				], 1];

				(* Interpret the tuples as quantities *)
				viscosityTemperatureTuples = Map[
					Function[
						entry,
						Module[
							{viscosity1, viscosity2, viscosityUnits, tempString, validatedUnits, averageViscosity, temperature},

							{viscosity1, viscosity2, viscosityUnits, tempString} = entry;

							(* Convert some unusual unit forms *)
							(* As these are non-standard, it could be dangerous adding to StringToQuantity, so convert here *)
							validatedUnits = viscosityUnits /. {"mPa-sec" -> "mPa*s"};

							(* If we found a viscosity range, average it *)
							averageViscosity = Quiet[If[MatchQ[viscosity1, ""],
								StringToQuantity[viscosity2 <> " " <> validatedUnits, Server -> False],
								Mean[StringToQuantity[{viscosity1 <> " " <> validatedUnits, viscosity2 <> " " <> validatedUnits}, Server -> False]]
							]];

							(* Parse the temperature if we have one *)
							temperature = If[MatchQ[temperatureString, ""],
								Null,
								Quiet[StringToQuantity[tempString, Server -> False]]
							];

							(* Return the tuple only if valid *)
							If[UnitsQ[averageViscosity, Centipoise] && Or[UnitsQ[temperature, Celsius], NullQ[temperature]],
								{averageViscosity, temperature},
								Nothing
							]
						]
					],
					viscosityStringTuples
				]
			];

			(* The viscosities may be at different temperatures, so filter for the preferred 25 C *)
			(* Take the median of the parsed strings within appropriate temperature range *)
			medianViscosity = Module[
				{viscositiesExact, viscosities5C},

				(* Pull out viscosities that meet a certain tolerance of the required temperature *)
				viscositiesExact = Cases[viscosityTemperatureTuples, {visc_, RangeP[24 Celsius, 26 Celsius]} :> visc];
				viscosities5C = Cases[viscosityTemperatureTuples, {visc_, RangeP[20 Celsius, 30 Celsius]} :> visc];

				(* Use the best tolerance for which we have data *)
				Which[
					!MatchQ[viscositiesExact, {}],
					UnitConvert[Median[viscositiesExact], Centipoise],

					!MatchQ[viscosities5C, {}],
					UnitConvert[Median[viscosities5C], Centipoise],

					True,
					Null
				]
			];

			(* Return the viscosity *)
			SafeRound[medianViscosity, 0.01]
		],

		Alternatives[GreaterEqualP[0 Centipoise], Null]
	];

	(* Get the melting point *)
	meltingPoint = safeParse[
		Module[
			{meltingPointDataAssociations, allMeltingTemperatureLists, medianMeltingPoint},

			(* Extract the list of associations containing experimental melting point data *)
			meltingPointDataAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Melting Point", "Information"}];

			(* Melting points are stored in string form *)
			(* Sometimes there might be hydrates or random compounds thrown in, but difficult to interpret that from the context *)
			(* Some values also just seem to be wrong without any clarifying information, for example PubChem[174] has records at -13 C and 4-10 C with no qualification *)
			(* Or PubChem[1004] with values at 42 C, 21 C *)
			(* Some records are also populated with random invalid data, such as "Latent heat of fusion - 10.5 kJ/mol (25 \[Degree]C)" which is super stupid as the temperature in there is not a melting point *)
			(* As melting points tend to be highly populated, pull them all out and rely on filtering the values afterwards by comparing them to eachother to guess what's right *)
			allMeltingTemperatureLists = Module[
				{temperatureStringTupleLists, meltingPointString, meltingPointQuantities},

				(* Define some useful string forms *)
				(* The actual melting point *)
				(* Could be of form "x units" or "x to y units" *)
				meltingPointString = StringExpression[
					(* Optional second value for temperature range *)
					Alternatives[
						StringExpression[
							mp1 : NumberString,
							Whitespace...,
							Alternatives["to", "To", "TO", "-"],
							Whitespace...
						],
						""
					],
					(* There must be at least this one temperature *)
					mp2 : NumberString,
					Whitespace...,
					units : StringExpression[WordCharacter..., Alternatives["\[Degree]C", "\[Degree]F", "K", "Celsius", "Centigrade", "Fahrenheit", "Kelvin"], WordCharacter...],
					WordBoundary
				];

				(* Pull out all the temperatures - this is a list of lists as there might be more than one temperature within an entry *)
				(* Knowing which temperatures came from the same reference is useful later *)
				temperatureStringTupleLists = extractStringValues[
					meltingPointDataAssociations,
					meltingPointString :> {mp1, mp2, units},

					(* Pull out as many temperatures from each entry as possible *)
					All
				];

				(* Convert to quantities - map over each reference, and then each temperature in the reference *)
				meltingPointQuantities = Map[
					Function[tupleList,
						Module[{allTemperaturesForReference},

							(* Convert all the temperatures for a given reference *)
							allTemperaturesForReference = Map[
								Function[tuple,
									Module[{meltingPoint1, meltingPoint2, units, meltingPointQuantity},

										{meltingPoint1, meltingPoint2, units} = tuple;

										(* Try and convert the melting point to a quantity *)
										(* Average the two values if we found a temperature range *)
										meltingPointQuantity = If[MatchQ[meltingPoint1, ""],
											Quiet[StringToQuantity[meltingPoint2 <> " " <> units, Server -> False]],
											Quiet[Mean[StringToQuantity[{meltingPoint1 <> " " <> units, meltingPoint2 <> " " <> units}, Server -> False]]]
										];

										(* Return the quantity if it's valid, else return Nothing *)
										If[UnitsQ[meltingPointQuantity, Celsius],
											meltingPointQuantity,
											Nothing
										]
									]
								],
								tupleList
							]
						]
					],
					temperatureStringTupleLists
				]
			];

			(* Now filter the melting points if we have multiple to try and guess what the right number is *)
			medianMeltingPoint = Module[
				{meltingPointsRefined, meltingPointGroups, mostFrequentMeltingPointGroups, meltingPointTolerance},

				(* Each reference may have multiple temperatures - take the best temperature from each one *)
				(* There can only be one correct melting point, so this does no harm, but prevents terrible references from overwhelming the correct data *)
				(* For example ethylene glycol has a single reference containing melting points for 6 PEGs that are obviously *not* ethylene glycol... *)
				(* Take the highest as pure compounds have higher melting points than impure - so at least we get it right for mixtures or hydrates *)
				meltingPointsRefined = If[!MatchQ[#, {}], Convert[Max[#], Celsius], Nothing] & /@ allMeltingTemperatureLists;

				(* Group the melting points. Correct melting points tend to be within 1C or so *)
				meltingPointTolerance = 1 Celsius;
				meltingPointGroups = Gather[meltingPointsRefined, (LessEqualQ[Abs[#1 - #2], meltingPointTolerance]) &];

				(* Find the longest group(s) = most frequent temperature found *)
				mostFrequentMeltingPointGroups = MaximalBy[meltingPointGroups, Length];

				(* Return the best temperature we found *)
				Which[
					(* No data *)
					MatchQ[mostFrequentMeltingPointGroups, {{}}],
					Null,

					(* If one temperature, use it *)
					EqualQ[Length[mostFrequentMeltingPointGroups], 1],
					Median[First[mostFrequentMeltingPointGroups]],

					(* More than one group *)
					True,
					Module[{medians},
						(* Compute all the medians *)
						medians = Median /@ mostFrequentMeltingPointGroups;

						(* Take the highest melting point that's not 25 C *)
						(* Highest melting point => purest compound *)
						(* 25 C is a common pollutant when people insert random data into the field, so don't use it when we have a choice *)
						(* We shouldn't end up with an empty list here, but handle it as Null in any case *)
						Max[
							Cases[medians, Except[RangeP[25 Celsius - (meltingPointTolerance / 2), 25 Celsius + (meltingPointTolerance / 2)]]]
						] /. (-Infinity) -> Null
					]
				]
			];

			(* Return the melting point *)
			SafeRound[medianMeltingPoint, 0.1]
		],

		Alternatives[UnitsP[Celsius], Null]
	];

	(* Get the boiling point *)
	boilingPoint = safeParse[
		Module[
			{boilingPointDataAssociations, allBoilingTemperatureTupleLists, medianBoilingPoint},

			(* Extract the list of associations containing experimental boiling point data *)
			boilingPointDataAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Boiling Point", "Information"}];

			(* Boiling points are stored in string form *)
			(* Most common issue is multiple boiling points measured at different pressures, so important to parse out pressure if there is one *)
			(* Occasionally values just seem to be wrong without any clarifying information, for example PubChem[1004] has records at 407 C and 158 C with no qualification *)
			(* As boiling points tend to be highly populated, pull them all out and rely on filtering the values afterwards by comparing them to eachother to guess what's right *)
			allBoilingTemperatureTupleLists = Module[
				{temperatureStringTupleLists, boilingPointString, pressureString, boilingPointQuantityTuples},

				(* Define some useful string forms *)
				(* The actual boiling point *)
				(* Could be of form "x units" or "x to y units" *)
				boilingPointString = StringExpression[
					(* Optional second value for temperature range *)
					Alternatives[
						StringExpression[
							bp1 : NumberString,
							Whitespace...,
							Alternatives["to", "To", "TO", "-"],
							Whitespace...
						],
						""
					],
					(* There must be at least this one temperature *)
					bp2 : NumberString,
					Whitespace...,
					units : StringExpression[WordCharacter..., Alternatives["\[Degree]C", "\[Degree]F", "K", "Celsius", "Centigrade", "Fahrenheit", "Kelvin"], WordCharacter...],
					WordBoundary
				];

				(* Pressure at which reading was taken *)
				pressureString = StringExpression[
					Alternatives["AT", "At", "at", "@"],
					Whitespace...,
					pressure : StringExpression[
						NumberString,
						Whitespace...,
						Alternatives["mmHg", "mm Hg", "Atm", "atm"]
					]
				];

				(* Pull out all the temperatures - this is a list of lists as there might be more than one temperature within a line *)
				(* Knowing which temperatures came from the same reference is useful later *)
				temperatureStringTupleLists = extractStringValues[
					boilingPointDataAssociations,
					StringExpression[
						boilingPointString,
						Alternatives[
							StringExpression[
								Shortest[___],
								pressureString
							],
							""
						]
					] :> {bp1, bp2, units, pressure},

					(* Pull out as many temperatures from each entry as possible *)
					All
				];

				(* Convert to quantities - map over each reference, and then each temperature in the reference. Tuple of {bp, pressure} *)
				boilingPointQuantityTuples = Map[
					Function[tupleList,
						Module[{allTemperaturesForReference},

							(* Convert all the temperatures for a given reference *)
							allTemperaturesForReference = Map[
								Function[tuple,
									Module[{boilingPoint1, boilingPoint2, units, pressure, boilingPointQuantity, pressureQuantity, sanitizedPressure},

										{boilingPoint1, boilingPoint2, units, pressure} = tuple;

										(* Try and convert the boiling point to a quantity *)
										(* Average the two values if we found a temperature range *)
										boilingPointQuantity = If[MatchQ[boilingPoint1, ""],
											Quiet[StringToQuantity[boilingPoint2 <> " " <> units, Server -> False]],
											Quiet[Mean[StringToQuantity[{boilingPoint1 <> " " <> units, boilingPoint2 <> " " <> units}, Server -> False]]]
										];

										(* Sanitize the pressure to ensure units are recognized *)
										sanitizedPressure = StringReplace[pressure, {"mm Hg" -> "mmHg"}];

										(* Try and convert the pressure to a quantity *)
										pressureQuantity = If[MatchQ[sanitizedPressure, ""],
											Null,
											Quiet[StringToQuantity[sanitizedPressure, Server -> False]]
										];

										(* Return the quantity if it's valid, else return Nothing *)
										If[UnitsQ[boilingPointQuantity, Celsius] && Or[UnitsQ[pressureQuantity], NullQ[pressureQuantity]],
											{boilingPointQuantity, pressureQuantity},
											Nothing
										]
									]
								],
								tupleList
							]
						]
					],
					temperatureStringTupleLists
				]
			];

			(* Now filter the boiling points if we have multiple to try and guess what the right number is *)
			medianBoilingPoint = Module[
				{boilingPointsRefined, boilingPointGroups, mostFrequentBoilingPointGroups, relevantBoilingPoints, boilingPointTolerance},

				(* Each reference may have multiple temperatures at the same pressure - take the best temperature from each one *)
				(* There can only be one correct boiling point, so this does no harm, but prevents terrible references from overwhelming the correct data *)
				(* Take the highest as pure compounds have higher boiling points than impure - so at least we get it right for mixtures *)
				boilingPointsRefined = Flatten[If[!MatchQ[#, {}],
					(* If we have data, group by the pressure at which the bp was measured *)
					Values[GroupBy[#,
						Last,

						(* For each set of bps at a given pressure, take the highest bp and return in a tuple with the pressure in mmHg *)
						Function[{duplicates}, {Convert[Max[First /@ duplicates], Celsius], SafeRound[Convert[duplicates[[1, 2]], MillimeterMercury], 1 MillimeterMercury]}]
					]],

					(* Otherwise return nothing if there was no data *)
					Nothing
				] & /@ allBoilingTemperatureTupleLists,
					1
				];

				(* Pull out the boiling points at the relevant pressure - 760 mmHg/1 atm *)
				relevantBoilingPoints = Module[{gatheredBoilingPoints, exactBoilingPoints, boilingPoints20mmHg},

					(* Gather the boiling points by pressure *)
					gatheredBoilingPoints = GroupBy[boilingPointsRefined, Last -> First];

					(* Pull out boiling points at 1 atmosphere. Assume no mention of pressure means 1 atm *)
					exactBoilingPoints = Flatten[Values[KeySelect[gatheredBoilingPoints, MatchQ[#, Alternatives[Null, RangeP[755 MillimeterMercury, 765 MillimeterMercury]]] &]]];

					(* Cast a wider net *)
					boilingPoints20mmHg = Flatten[Values[KeySelect[gatheredBoilingPoints, MatchQ[#, Alternatives[Null, RangeP[740 MillimeterMercury, 780 MillimeterMercury]]] &]]];

					If[!MatchQ[exactBoilingPoints, {}],
						exactBoilingPoints,
						boilingPoints20mmHg
					]
				];

				(* Group the boiling points. Correct boiling points tend to be within 1C or so *)
				boilingPointTolerance = 1 Celsius;
				boilingPointGroups = Gather[relevantBoilingPoints, (LessEqualQ[Abs[#1 - #2], boilingPointTolerance]) &];

				(* Find the longest group(s) = most frequent temperature found *)
				mostFrequentBoilingPointGroups = MaximalBy[boilingPointGroups, Length];

				(* Return the best temperature we found *)
				Which[
					(* No data *)
					MatchQ[mostFrequentBoilingPointGroups, {{}}],
					Null,

					(* If one temperature, use it *)
					EqualQ[Length[mostFrequentBoilingPointGroups], 1],
					Median[First[mostFrequentBoilingPointGroups]],

					(* More than one group *)
					True,
					Module[{medians},
						(* Compute all the medians *)
						medians = Median /@ mostFrequentBoilingPointGroups;

						(* Take the highest boiling point that's not 25 C *)
						(* Highest boiling point => purest compound *)
						(* 25 C is a common pollutant when people insert random data into the field, so don't use it when we have a choice *)
						(* We shouldn't end up with an empty list here, but handle it as Null in any case *)
						Max[
							Cases[medians, Except[RangeP[25 Celsius - (boilingPointTolerance / 2), 25 Celsius + (boilingPointTolerance / 2)]]]
						]
					]
				]
			];

			(* Return the boiling point *)
			SafeRound[medianBoilingPoint, 0.1]
		],

		Alternatives[UnitsP[Celsius], Null]
	];

	(* Get the state of matter *)
	state = safeParse[
		Module[{physicalDescriptionAssociations, stateDescriptors, stateDescriptorFrequencies, likelyState, likelyStateFromTemperatures, stateDefaultPriorities},

			(* There is no specific field for state of matter, so parse out descriptions, which almost always mention it *)
			physicalDescriptionAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Physical Description", "Information"}];

			(* Words that indicate a certain state of matter *)
			stateDescriptors = <|
				Solid -> Alternatives["solid", "powder", "powdery", "needles", "crystals", "crystalline"],
				Liquid -> Alternatives["liquid", "oil", "oily"],
				Gas -> Alternatives["gas", "gaseous"]
			|>;

			(* Count the number of times descriptors for each state are mentioned *)
			stateDescriptorFrequencies = Map[
				Length[Flatten[extractStringValues[physicalDescriptionAssociations, WordBoundary ~~ # ~~ WordBoundary, All, IgnoreCase -> True]]] &,
				stateDescriptors
			];

			(* See which state(s) is most frequent *)
			likelyState = MaximalBy[Keys[stateDescriptors], stateDescriptorFrequencies];

			(* Determine the state from the melting and boiling points. Use to break ties *)
			(* mp and bp data can be missing or occasionally spurious, so don't rely on it alone *)
			likelyStateFromTemperatures = Switch[{meltingPoint, boilingPoint},
				{_, LessP[25 Celsius]},
				Gas,

				{GreaterP[25 Celsius], _},
				Solid,

				{LessP[25 Celsius], GreaterP[25 Celsius]},
				Liquid,

				{_, _},
				Null
			];

			(* Set default ordering if we need to disambiguate *)
			stateDefaultPriorities = <|Solid -> 3, Liquid -> 2, Gas -> 1|>;

			(* Return the most likely state. Break final tie in order Solid > Liquid > Gas *)
			Which[
				(* If we have a state from the description, and it doesn't conflict with that from the temperatures, us it *)
				EqualQ[Length[likelyState], 1] && Or[MatchQ[likelyStateFromTemperatures, Null], MemberQ[likelyState, likelyStateFromTemperatures]],
				First[likelyState],

				(* If we got a state from the temperatures and it doesn't conflict with the description, use it *)
				!NullQ[likelyStateFromTemperatures] && Or[MemberQ[likelyState, likelyStateFromTemperatures], MatchQ[likelyState, {}]],
				likelyStateFromTemperatures,

				(* If the description and temperature method conflict, return the description method *)
				!NullQ[likelyStateFromTemperatures] && !MemberQ[likelyState, likelyStateFromTemperatures],
				First[MaximalBy[likelyState, stateDefaultPriorities]],

				(* Return Null if we failed *)
				True,
				Null
			]
		],

		Alternatives[Solid, Liquid, Gas]
	];

	(* Get the vapor pressure *)
	vaporPressure = safeParse[
		Module[
			{vaporPressureDataAssociations, allVaporPressureTupleLists, medianVaporPressure},

			(* Extract the list of associations containing experimental vapor pressure data *)
			vaporPressureDataAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Vapor Pressure", "Information"}];

			(* Vapor pressures are stored in string form *)
			(* Most common issue is multiple vapor pressures measured at different temperatures, so important to parse out temperature if there is one *)
			(* Pull out all values and rely on filtering the values afterwards by comparing them to eachother to guess what's right *)
			allVaporPressureTupleLists = Module[
				{pressureStringTupleLists, vaporPressureString, temperatureString, vaporPressureQuantityTuples},

				(* Define some useful string forms *)
				(* The actual vapor pressure *)
				(* Could be of form "x units" or "x to y units" *)
				vaporPressureString = StringExpression[
					(* Optional second value for vapor pressure range *)
					Alternatives[
						StringExpression[
							vp1 : NumberString,
							Whitespace...,
							Alternatives["to", "To", "TO", "-"],
							Whitespace...
						],
						""
					],
					(* There must be at least this one pressure *)
					vp2 : NumberString,
					Whitespace...,
					units : StringExpression[WordCharacter..., Alternatives["mmHg", "mm Hg", "Atm", "atm", "kPa", "Pa"], WordCharacter...],
					WordBoundary
				];

				(* Temperature at which reading was taken *)
				temperatureString = StringExpression[
					Alternatives["AT", "At", "at", "@"],
					Whitespace...,
					temperature : StringExpression[
						NumberString,
						Whitespace...,
						Alternatives["\[Degree]C", "\[Degree]F", "K", "Celsius", "Centigrade", "Fahrenheit", "Kelvin"]
					]
				];

				(* Pull out all the vapor pressures - this is a list of lists as there might be more than one pressure within a line *)
				(* Knowing which pressure came from the same reference is useful later *)
				pressureStringTupleLists = extractStringValues[
					vaporPressureDataAssociations,
					StringExpression[
						vaporPressureString,
						Alternatives[
							StringExpression[
								Shortest[___],
								temperatureString
							],
							""
						]
					] :> {vp1, vp2, units, temperature},

					(* Pull out as many temperatures from each entry as possible *)
					All
				];

				(* Convert to quantities - map over each reference, and then each pressure in the reference. Tuple of {vp, temperature} *)
				vaporPressureQuantityTuples = Map[
					Function[tupleList,
						Module[{allTemperaturesForReference},

							(* Convert all the pressures for a given reference *)
							allTemperaturesForReference = Map[
								Function[tuple,
									Module[{vaporPressure1, vaporPressure2, vaporPressure1Sanitized, vaporPressure2Sanitized, units, temperature, vaporPressureQuantity, temperatureQuantity},

										{vaporPressure1, vaporPressure2, units, temperature} = tuple;

										(* Sanitize the pressure to ensure units are recognized *)
										{vaporPressure1Sanitized, vaporPressure2Sanitized} = {
											vaporPressure1,
											vaporPressure2
										} /. {"mm Hg" -> "mmHg"};

										(* Try and convert the vapor pressure to a quantity *)
										(* Average the two values if we found a pressure range *)
										vaporPressureQuantity = If[MatchQ[vaporPressure1Sanitized, ""],
											Quiet[StringToQuantity[vaporPressure2Sanitized <> " " <> units, Server -> False]],
											Quiet[Mean[StringToQuantity[{vaporPressure1Sanitized <> " " <> units, vaporPressure2Sanitized <> " " <> units}, Server -> False]]]
										];

										(* Try and convert the temperature to a quantity *)
										temperatureQuantity = If[MatchQ[temperature, ""],
											Null,
											Quiet[StringToQuantity[temperature, Server -> False]]
										];

										(* Return the quantity if it's valid, else return Nothing *)
										If[UnitsQ[vaporPressureQuantity, Kilopascal] && Or[UnitsQ[temperatureQuantity], NullQ[temperatureQuantity]],
											{vaporPressureQuantity, temperatureQuantity},
											Nothing
										]
									]
								],
								tupleList
							]
						]
					],
					pressureStringTupleLists
				]
			];

			(* Now filter the vapor pressures if we have multiple to try and guess what the right number is *)
			medianVaporPressure = Module[
				{vaporPressuresRefined, vaporPressureGroups, mostFrequentVaporPressureGroups, relevantVaporPressures},

				(* Each reference may have multiple vapor pressures at the same temperature - take the best pressure from each one *)
				(* There can only be one correct vapor pressure, so this does no harm, but prevents terrible references from overwhelming the correct data *)
				(* Take the highest *)
				vaporPressuresRefined = Flatten[If[!MatchQ[#, {}],
					(* If we have data, group by the pressure at which the vp was measured *)
					Values[GroupBy[#,
						Last,

						(* For each set of vps at a given pressure, take the highest vp and return in a tuple with the temperature in C *)
						Function[{duplicates}, {Convert[Max[First /@ duplicates], Kilopascal], SafeRound[Convert[duplicates[[1, 2]], Celsius], 1 Celsius]}]
					]],

					(* Otherwise return nothing if there was no data *)
					Nothing
				] & /@ allVaporPressureTupleLists,
					1
				];

				(* Pull out the vapor pressures at the relevant temperature - 25 C *)
				relevantVaporPressures = Module[{gatheredVaporPressures, exactVaporPressures, vaporPressures5Celsius},

					(* Gather the vapor pressures by temperature *)
					gatheredVaporPressures = GroupBy[vaporPressuresRefined, Last -> First];

					(* Pull out vapor pressures at 25 C. Assume no mention of temperature means 25 C *)
					exactVaporPressures = Flatten[Values[KeySelect[gatheredVaporPressures, MatchQ[#, Alternatives[Null, RangeP[24 Celsius, 26 Celsius]]] &]]];

					(* Cast a wider net *)
					vaporPressures5Celsius = Flatten[Values[KeySelect[gatheredVaporPressures, MatchQ[#, Alternatives[Null, RangeP[20 Celsius, 30 Celsius]]] &]]];

					If[!MatchQ[exactVaporPressures, {}],
						exactVaporPressures,
						vaporPressures5Celsius
					]
				];

				(* Group the vapor pressures within 5 % of the smaller value *)
				vaporPressureGroups = Gather[relevantVaporPressures, (LessEqualQ[Abs[#1 - #2], Min[#1, #2] * 0.05]) &];

				(* Find the longest group(s) = most frequent pressure found *)
				mostFrequentVaporPressureGroups = MaximalBy[vaporPressureGroups, Length];

				(* Return the best vapor pressure we found *)
				Which[
					(* No data *)
					MatchQ[mostFrequentVaporPressureGroups, {{}}],
					Null,

					(* If one pressure, use it *)
					EqualQ[Length[mostFrequentVaporPressureGroups], 1],
					Median[First[mostFrequentVaporPressureGroups]],

					(* More than one group *)
					True,
					Module[{medians},
						(* Compute all the medians *)
						medians = Median /@ mostFrequentVaporPressureGroups;

						(* Take the median pressure *)
						Median[
							medians
						]
					]
				]
			];

			(* Return the vapor pressure *)
			SafeRound[UnitScale[medianVaporPressure], 0.1]
		],

		Alternatives[UnitsP[Kilopascal], Null]
	];


	(* Get the density *)
	density = safeParse[
		Module[
			{densityDataAssociations, densityTemperatureTuples, medianDensity},

			(* Extract the list of associations containing experimental density data *)
			densityDataAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Density", "Information"}];

			(* Densities are stored in string form *)
			(* Most common issue is densities measured at different temperatures, so important to parse out temperature if there is one *)
			(* Records may contain temperature or dilution information. Important to filter out data not for pure compound, or near room temperature *)
			(* Each string may contain multiple values, under different conditions *)
			densityTemperatureTuples = Module[
				{densityString, densityUnits, temperatureString, densityStringTupleLists, densityQuantityTuples},

				(* Define some useful string forms *)
				(* The actual density *)
				(* Could be x to y units *)
				densityString = StringExpression[
					(* Optional second value for density range *)
					Alternatives[
						StringExpression[
							dens1 : NumberString,
							Whitespace...,
							Alternatives["to", "To", "TO", "-"],
							Whitespace...
						],
						""
					],
					(* There must be at least this one density *)
					dens2 : NumberString
				];

				(* Units of density - optional as may be a relative density which is unitless *)
				densityUnits = units : Alternatives[
					Alternatives["k", ""] ~~ "g" ~~ Whitespace... ~~ "/" ~~ Whitespace... ~~ Alternatives["m", ""] ~~ "L",
					Alternatives["k", ""] ~~ "g" ~~ Whitespace... ~~ "/" ~~ Whitespace... ~~ "cm" ~~ Whitespace... ~~ "^" ~~ Whitespace... ~~ "3",
					Alternatives["k", ""] ~~ "g" ~~ Whitespace... ~~ "/" ~~ Whitespace... ~~ "dm" ~~ Whitespace... ~~ "^" ~~ Whitespace... ~~ "3",
					Alternatives["k", ""] ~~ "g" ~~ Whitespace... ~~ "/" ~~ Whitespace... ~~ Alternatives["cu", "cubic"] ~~ Whitespace... ~~ "cm",
					Alternatives["k", ""] ~~ "g" ~~ Whitespace... ~~ "/" ~~ Whitespace... ~~ Alternatives["cu", "cubic"] ~~ Whitespace... ~~ "dm",
					Alternatives["kilo", ""] ~~ "gram" ~~ Whitespace... ~~ "/" ~~ Whitespace... ~~ Alternatives["milli", ""] ~~ "liter"
				];

				(* Qualifies temperature at which reading was taken *)
				temperatureString = StringExpression[
					Alternatives["AT", "At", "at", "@"],
					Whitespace...,
					temp : StringExpression[
						NumberString,
						Whitespace...,
						Alternatives["\[Degree]C", "\[Degree]F", "K", "Celsius", "Centigrade", "Fahrenheit", "Kelvin"]
					]
				];

				(* Pull out all the densities - this is a list of lists as there might be more than one density within a line *)
				(* Knowing which densities came from the same reference is useful later *)
				(* We have to be careful to make sure we're only pulling out valid densities *)
				densityStringTupleLists = extractStringValues[
					densityDataAssociations,
					{
						(* If just a number on its own, allow it to not have units. We know for sure this should be a density *)
						StartOfString ~~ densityString ~~ EndOfString :> {dens1, dens2, units, temp},

						(* Match a PubChem entry that explicitly mentions the density of water *)
						StartOfString ~~ "Relative density (water = 1): " ~~ densityString ~~ EndOfString :> {dens1, dens2, units, temp},

						(* If we have a density with units, we can be permissive and look anywhere in the string. There may be multiple per reference *)
						densityString ~~ Whitespace... ~~ densityUnits ~~ Alternatives[Whitespace... ~~ temperatureString, ""] :> {dens1, dens2, units, temp},

						(* If density has a qualifying temperature we can also be more permissive about where we find it *)
						densityString ~~ Alternatives[Whitespace... ~~ densityUnits, ""] ~~ Whitespace... ~~ temperatureString :> {dens1, dens2, units, temp}
					},
					All
				] /. {dens1 -> "", dens2 -> "", units -> "", temp -> ""};

				(* Convert to quantities - map over each reference, and then each density in the reference. Tuple of {density, temperature} *)
				densityQuantityTuples = Map[
					Function[tupleList,
						Module[{allDensitiesForReference},

							(* Convert all the densities for a given reference *)
							allDensitiesForReference = Map[
								Function[tuple,
									Module[{density1, density2, units, sanitizedUnits, temperature, density, densityQuantity, temperatureQuantity, sanitizedPressure},

										{density1, density2, units, temperature} = tuple;

										(* Sanitize the density units to ensure they are recognized *)
										sanitizedUnits = StringReplace[units, {Alternatives["cu cm", "cubic cm"] -> "cm^3", Alternatives["cu dm", "cubic dm"] -> "dm^3"}];

										(* Try and convert the density to a quantity *)
										(* Average the two values if we found a density range *)
										density = If[MatchQ[density1, ""],
											Quiet[StringToQuantity[density2 <> " " <> sanitizedUnits, Server -> False]],
											Quiet[Mean[StringToQuantity[{density1 <> " " <> sanitizedUnits, density2 <> " " <> sanitizedUnits}, Server -> False]]]
										];

										(* If quantity has no units, assume it's a relative density *)
										densityQuantity = If[MatchQ[density, NumberP],
											density Gram / Milliliter,
											density
										];

										(* Try and convert the temperature to a quantity *)
										temperatureQuantity = If[MatchQ[temperature, ""],
											Null,
											Quiet[StringToQuantity[temperature, Server -> False]]
										];

										(* Return the quantity if it's valid, else return Nothing *)
										(* As some quantities are unitless, it's difficult to tell what's a density and what's a plain number, so filter out scientifically implausible values for standard conditions on earth *)
										If[MatchQ[densityQuantity, RangeP[0 Gram / Liter, 25 Gram / Milliliter]] && Or[UnitsQ[temperatureQuantity], NullQ[temperatureQuantity]],
											{densityQuantity, temperatureQuantity},
											Nothing
										]
									]
								],
								tupleList
							]
						]
					],
					densityStringTupleLists
				]
			];

			(* The densities may be at different temperatures, so filter for the preferred 25 C *)
			(* Take the median of the parsed strings within appropriate temperature range *)
			medianDensity = Module[
				{densitiesRefined, densityGroups, mostFrequentDensityGroups, relevantDensities},

				(* Each reference may have multiple densities at the same temperature - take the best density from each one *)
				(* There can only be one correct density, so this does no harm, but prevents terrible references from overwhelming the correct data *)
				(* Take the highest *)
				densitiesRefined = Flatten[If[!MatchQ[#, {}],
					(* If we have data, group by the temperature at which the density was measured *)
					Values[GroupBy[#,
						Last,

						(* For each set of densities at a given temperature, take the highest densities and return in a tuple with the temperature in C *)
						Function[{duplicates}, {Convert[Max[First /@ duplicates], Gram / Milliliter], SafeRound[Convert[duplicates[[1, 2]], Celsius], 1 Celsius]}]
					]],

					(* Otherwise return nothing if there was no data *)
					Nothing
				] & /@ densityTemperatureTuples,
					1
				];

				(* Pull out the densities at the relevant temperature - 25 C *)
				relevantDensities = Module[{gatheredDensities, exactDensities, densities10C, allDensities},

					(* Gather the densities by temperature *)
					gatheredDensities = GroupBy[densitiesRefined, Last -> First];

					(* Pull out densities at 25 C. Assume no mention of temperature means 25 C *)
					exactDensities = Flatten[Values[KeySelect[gatheredDensities, MatchQ[#, Alternatives[Null, RangeP[24 Celsius, 26 Celsius]]] &]]];

					(* Cast a wider net *)
					densities10C = Flatten[Values[KeySelect[gatheredDensities, MatchQ[#, Alternatives[Null, RangeP[20 Celsius, 30 Celsius]]] &]]];

					(* Full net *)
					allDensities = Flatten[Values[gatheredDensities]];

					Which[
						(* If we have densities at the right temperature, use them *)
						!MatchQ[exactDensities, {}],
						exactDensities,

						(* Otherwise if we have some with a slightly wider net, use those *)
						!MatchQ[densities10C, {}],
						densities10C,

						(* Otherwise if we're in condensed phase, use any values as density isn't strongly dependent on temperature *)
						MatchQ[state, Alternatives[Solid, Liquid]],
						allDensities,

						True,
						{}
					]
				];

				(* Group the densities. Check within 5 % of smallest value as densities cover many orders of magnitude *)
				densityGroups = Gather[
					relevantDensities,
					(LessEqualQ[Abs[#1 - #2], Min[#1, #2] * 0.05])&
				];

				(* Find the longest group(s) = most frequent density found *)
				mostFrequentDensityGroups = MaximalBy[densityGroups, Length];

				(* Return the best density we found *)
				Which[
					(* No data *)
					MatchQ[mostFrequentDensityGroups, {{}}],
					Null,

					(* If one density, use it *)
					EqualQ[Length[mostFrequentDensityGroups], 1],
					Median[First[mostFrequentDensityGroups]],

					(* More than one group *)
					True,
					Module[{medians},
						(* Compute all the medians *)
						medians = Median /@ mostFrequentDensityGroups;

						(* Take the middle density *)
						Median[
							medians
						]
					]
				]
			];

			(* Return the density *)
			medianDensity
		],

		Alternatives[UnitsP[Gram / Centimeter^3], Null]
	];


	(* -- Safety and Hazards Information Properties -- *)
	safetyAndHazards = safeParse[extractJSON[pubchemRecord, {"Section", "TOCHeading" == "Safety and Hazards", "Section"}], _List];

	(* Lookup the NPFA hazards - system used for lab safety *)
	nfpaHazards = safeParse[
		Module[
			{
				nfpaAssociations, nfpaFireAssociations, nfpaHealthAssociations, nfpaInstabilityAssociations, nfpaSpecificAssociations, nfpaPictogramAssociation, specialAbbreviations,
				pictogramHazardTuple, additionalHealthRatings, additionalFireRatings, additionalReactivityRatings, additionalSpecialRatings
			},

			(* Pull out all NFPA associations *)
			nfpaAssociations = extractJSON[safetyAndHazards, {"TOCHeading" == "Hazards Identification", "Section", "TOCHeading" == "NFPA Hazard Classification", "Information"}];

			(* Return $Failed early if no information *)
			If[FailureQ[nfpaAssociations],
				Return[$Failed, Module]
			];

			(* Pull out the NFPA Safety & Hazards Properties associations. May be multiple for each category *)
			{
				nfpaFireAssociations,
				nfpaHealthAssociations,
				nfpaInstabilityAssociations,
				nfpaSpecificAssociations,
				nfpaPictogramAssociation
			} = Map[
				Function[{section},
					Select[
						nfpaAssociations,
						MatchQ[Lookup[#, "Name"], section] &
					]
				],
				{"NFPA Fire Rating", "NFPA Health Rating", "NFPA Instability Rating", "NFPA Specific Notice", "NFPA 704 Diamond"}
			];

			(* Abbreviations in the special category - all lower case as we'll do a lower case match *)
			specialAbbreviations = <|
				"ox" -> Oxidizer, (* PubChem[944] *)
				"\:0335w\:0335" -> WaterReactive, (* PubChem[5462222] *)
				"w" -> WaterReactive, (* Seems reasonable to have this too in case special character isn't used *)
				"sa" -> Aspyxiant, (* Typo in the pattern *) (* I tried hard to find one but couldn't test this. Tried N2, H2, Xe, Kr, CO2, Cl2, SF6, C2F6, CH4, ...*)
				"cor" -> Corrosive, (* Again, couldn't get any obvious ones here *)
				"acid" -> Acid, (* Same here *)
				"bio" -> Bio, (* Couldn't find any evidence of this in PubChem, nor a standard abbreviation, so this is a guess *)
				"poison" -> Poisonous, (* Couldn't find any evidence of this in PubChem, nor a standard abbreviation, so this is a guess *)
				"rad" -> Radioactive, (* Couldn't find any evidence of this in PubChem, nor a standard abbreviation, so this is a guess *)
				"cryo" -> Cryogenic (* Couldn't find any evidence of this in PubChem, nor a standard abbreviation, so this is a guess *)
			|>;

			(* Parse the pictogram as that should summarize all our hazard information *)
			pictogramHazardTuple = If[!FailureQ[nfpaPictogramAssociation],
				Module[{rawTuples},
					(* If we have a pictogram, pull the information out of the string *)
					rawTuples = extractStringValues[
						nfpaPictogramAssociation,
						StringExpression[
							health : Alternatives["0", "1", "2", "3", "4"],
							"-",
							flammability : Alternatives["0", "1", "2", "3", "4"],
							"-",
							reactivity : Alternatives["0", "1", "2", "3", "4"],
							(* Special doesn't appear if there is no special *)
							Alternatives[
								StringExpression[
									"-",
									Whitespace...,
									special : __,
									EndOfString
								],
								""
							]
						] :> {
							ToExpression[health], ToExpression[flammability], ToExpression[reactivity],
							Lookup[specialAbbreviations, ToLowerCase[special], Null]
						}
					];

					(* Combine the tuples. Take the worst case scenario if there are multiple pictograms *)
					{
						Max[rawTuples[[All, 1]]],
						Max[rawTuples[[All, 2]]],
						Max[rawTuples[[All, 3]]],
						Cases[DeleteDuplicates[rawTuples[[All, 4]]], Except[Null]]
					}
				],

				(* Otherwise keep as Null *)
				Null
			];

			(* Check the specific hazard sections and double check the information here isn't stricter than in the pictogram *)
			{
				additionalHealthRatings,
				additionalFireRatings,
				additionalReactivityRatings
			} = Map[
				Function[associations,
					(* Pull out all the values *)
					extractStringValues[
						associations,
						StartOfString ~~ Whitespace ... ~~ x : DigitCharacter :> ToExpression[x]
					]
				],
				{nfpaHealthAssociations, nfpaFireAssociations, nfpaInstabilityAssociations}
			];

			additionalSpecialRatings = extractStringValues[
				nfpaSpecificAssociations,
				StartOfString ~~ Whitespace ... ~~ x : WordCharacter.. ~~ WordBoundary :> Lookup[specialAbbreviations, ToLowerCase[x], Null]
			];

			(* Return the most stringent requirements *)
			{
				Max[Prepend[additionalHealthRatings, pictogramHazardTuple[[1]]]],
				Max[Prepend[additionalFireRatings, pictogramHazardTuple[[2]]]],
				Max[Prepend[additionalReactivityRatings, pictogramHazardTuple[[3]]]],
				Cases[DeleteDuplicates[Join[additionalSpecialRatings, pictogramHazardTuple[[4]]]], Except[Null]]
			}
		],

		{
			Alternatives[0, 1, 2, 3, 4],
			Alternatives[0, 1, 2, 3, 4],
			Alternatives[0, 1, 2, 3, 4],
			{Alternatives[Oxidizer, WaterReactive, Aspyxiant (* Typo in pattern *), Corrosive, Acid, Bio, Poisonous, Radioactive, Cryogenic, Null]...}
		}
	];

	(* Parse out the Precautionary Statement Codes (P phrases) from the GHS Classification description. Just used internally in this function to augment other systems as contains more granular chemical information *)
	pCodes = safeParse[
		Module[{pCodeAssociation, pCodes},
			(* Pull out the association containing p codes *)
			pCodeAssociation = extractJSON[safetyAndHazards, {"TOCHeading" == "Hazards Identification", "Section", "TOCHeading" == "GHS Classification", "Information", "Name" == "Precautionary Statement Codes"}];

			(* Return $Failed early if insufficient information *)
			If[!AssociationQ[pCodeAssociation],
				Return[$Failed, Module]
			];

			(* Pull out the P-codes - of the form P### or P###+P###... *)
			pCodes = Flatten[extractStringValues[
				{pCodeAssociation},
				StringExpression[
					"P" ~~ Repeated[DigitCharacter, {3}],
					RepeatedNull[
						"+" ~~ "P" ~~ Repeated[DigitCharacter, {3}]
					]
				],
				All
			]]
		],

		{
			_String?(StringMatchQ[
				#,
				StringExpression[
					"P" ~~ Repeated[DigitCharacter, {3}],
					RepeatedNull[
						"+" ~~ "P" ~~ Repeated[DigitCharacter, {3}]
					]
				]
			]&)...
		}
	];

	(* P codes can sometimes be combined e.g. P304+P316 *)
	(* pCodesSplit contains a unique list of all the individual pCodes to make it easier to check for codes internally within this function *)
	pCodesSplit = safeParse[
		Sort[DeleteDuplicates[Flatten[StringSplit[pCodes, "+"]]]],
		{_String?(StringMatchQ[#, "P" ~~ Repeated[DigitCharacter, {3}]]&)...}
	];

	(* Parse out the Hazard Statement Codes (H phrases) from the GHS Classification description. Just used internally in this function to augment other systems as contains more granular chemical information *)
	hCodes = safeParse[
		Module[{hCodeAssociation, hCodes},
			(* Pull out the association containing h codes *)
			hCodeAssociation = extractJSON[safetyAndHazards, {"TOCHeading" == "Hazards Identification", "Section", "TOCHeading" == "GHS Classification", "Information", "Name" == "GHS Hazard Statements"}];

			(* Return $Failed early if insufficient information *)
			If[!AssociationQ[hCodeAssociation],
				Return[$Failed, Module]
			];

			(* Pull out the H-codes - of the form H### or H###+H###... *)
			hCodes = Flatten[extractStringValues[
				{hCodeAssociation},
				StringExpression[
					"H" ~~ Repeated[DigitCharacter, {3}],
					RepeatedNull[
						"+" ~~ "H" ~~ Repeated[DigitCharacter, {3}]
					]
				],
				All
			]]
		],

		{
			_String?(StringMatchQ[
				#,
				StringExpression[
					"H" ~~ Repeated[DigitCharacter, {3}],
					RepeatedNull[
						"+" ~~ "H" ~~ Repeated[DigitCharacter, {3}]
					]
				]
			]&)...
		}
	];

	(* Hazard codes can sometimes be combined e.g. H300+H310 *)
	(* hCodesSplit contains a unique list of all the individual hCodes to make it easier to check for codes internally within this function *)
	hCodesSplit = safeParse[
		Sort[DeleteDuplicates[Flatten[StringSplit[hCodes, "+"]]]],
		{_String?(StringMatchQ[#, "H" ~~ Repeated[DigitCharacter, {3}]]&)...}
	];

	(* Figure out if this chemical is "hazardous" according to GHS criteria. False/True/ParticularlyHazardousSubstance *)
	hazardous = safeParse[
		Module[{hazardsAssociations},
			(* Pull out the GHS section of the hazard information *)
			hazardsAssociations = extractJSON[safetyAndHazards, {"TOCHeading" == "Hazards Identification", "Section", "TOCHeading" == "GHS Classification", "Information"}];

			(* Return Null early if insufficient information *)
			If[!MatchQ[hazardsAssociations, {_Association..}],
				Return[Null, Module]
			];

			(* Rank as non-hazardous, hazardous, or particularly hazardous *)
			Which[
				(* If no information, return $Failed *)
				FailureQ[hCodesSplit],
				$Failed,

				(* If no h-phrases/failed h-phrases, it's not hazardous *)
				!MatchQ[hCodesSplit, {_String..}],
				False,

				(* If it contains certain nasty h-codes, it's particularly hazardous. This list is from the definition of ParticularlyHazardousSubstance field *)
				MemberQ[hCodesSplit, Alternatives["H340", "H360", "H362", "H300", "H310", "H330", "H370", "H371", "H372", "H373", "H350"]],
				ParticularlyHazardousSubstance,

				(* Otherwise it's simply hazardous *)
				True,
				True
			]
		],

		Alternatives[BooleanP, ParticularlyHazardousSubstance, Null]
	];

	(* Store whether the molecule is particularly hazardous in a boolean *)
	particularlyHazardousSubstance = safeParse[
		MatchQ[hazardous, ParticularlyHazardousSubstance],
		BooleanP
	];

	(* Determine if MSDS if required *)
	msdsRequired = safeParse[
		!MatchQ[hazardous, False],
		BooleanP
	];

	(* Figure out from the hazard information if this chemical is Flammable. *)
	(* H-phrase information can be pulled from here https://pubchem.ncbi.nlm.nih.gov/ghs/ghscode_10.txt *)
	flammable = safeParse[
		Module[{flammableHCodes, npfaFlammability},
			(* The following are the H-Codes that indicate that this chemical is Flammable. *)
			(* Anything with the flammable pictogram (GHS02). Note that low flammability substances, such as H227 combustible liquid doesn't have the pictogram whereas H226, Flammable liquid and vapor does *)
			(* So something like 1-octanol is *not* flammable (even though it's combustible). This meets our field definition where something must be easily ignited. *)
			flammableHCodes = {
				"H205", "H206", "H207", "H208", "H220", "H221", "H222", "H223",
				"H224", "H225", "H226", "H228", "H229", "H230", "H231",
				"H241", "H242", "H251", "H252", "H260", "H261", "H282",
				"H283",

				(* Pyrophoric - let's keep in flammable as GHS gives the flammable pictogram *)
				"H232", "H250"
			};

			(* Also cross check with NFPA *)
			(* NFPA 3 and above indicates a substance easily set alight at room temperature, per our field definition *)
			npfaFlammability = If[MatchQ[nfpaHazards, {_, _, _, _}],
				nfpaHazards[[2]],
				$Failed
			];

			(* Do our H-Codes contain any of these, or NFPA exceeds threshold? *)
			If[
				(* Can't tell if we have no info *)
				FailureQ[hCodesSplit] && FailureQ[npfaFlammability],
				$Failed,

				(* Otherwise see if any of the info indicates flammable *)
				Or[ContainsAny[hCodesSplit, flammableHCodes], GreaterEqualQ[npfaFlammability, 3]]
			]
		],

		BooleanP
	];

	(* Figure out if this chemical is pyrophoric (ignites spontaneously in air) *)
	pyrophoric = safeParse[
		Module[{pyrophoricHCodes},
			(* The following are the H-Codes that indicate that this chemical is pyrophoric. *)
			pyrophoricHCodes = {
				(* Pyrophoric *)
				"H220", "H232", "H250",
				(* Self-heating. Not technically pyrophoric, but has the same effect. Include whilst we don't have a separate field for self-heating *)
				"H251", "H252"
			};

			(* Do our H-Codes contain any of these? *)
			If[!FailureQ[hCodesSplit],
				ContainsAny[hCodesSplit, pyrophoricHCodes],
				$Failed
			]
		],

		BooleanP
	];

	(* Figure out if this chemical is water reactive. *)
	waterReactive = safeParse[
		Module[{waterReactiveHCodes, npfaWaterReactive},
			(* The following are the H-Codes that indicate that this chemical is water reactive *)
			waterReactiveHCodes = {
				"H260", "H261"
			};

			(* Also cross check with NFPA - one of the special categories *)
			npfaWaterReactive = If[MatchQ[nfpaHazards, {_, _, _, _}],
				MemberQ[nfpaHazards[[4]], WaterReactive],
				$Failed
			];

			(* Do our H-Codes contain any of these? Or does NFPA indicate water reactive? *)
			If[
				(* Can't tell if we have no info *)
				FailureQ[hCodesSplit] && FailureQ[npfaWaterReactive],
				$Failed,

				(* Otherwise see if any of the info indicates water reactivity *)
				Or[ContainsAny[hCodesSplit, waterReactiveHCodes], TrueQ[npfaWaterReactive]]
			]
		],

		BooleanP
	];

	(* Figure out if this chemical is fuming (releases fumes spontaneously in air) *)
	fuming = safeParse[
		Module[{fumingHCodes, fumingDescriptionQ},
			(* The following are the H-Codes that suggest that this chemical is fuming. There are no specific codes *)
			(* This is over-cautious but best be safe *)
			fumingHCodes = {
				(* Codes that mention harm through inhalation *)
				"H330", "H331", "H332", "H333", "H334", "H350i", "H300+H330", "H310+H330",
				"H300+H310+H330", "H301+H331", "H311+H331", "H301+H311+H331", "H302+H332",
				"H312+H332", "H312+H332", "H302+H321+H332", "H303+H333", "H313+H333", "H303+H313+H333",

				(* Codes that mention vapor *)
				"H224", "H225", "H226"
			};

			(* Check if the description mentions fuming - this is likely more accurate *)
			fumingDescriptionQ = Module[
				{moleculeDescriptionAssociations, fumingMentions},

				(* Pull out description *)
				moleculeDescriptionAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Physical Description", "Information"}];

				(* Count the number of times descriptors for each state are mentioned *)
				fumingMentions = Flatten[extractStringValues[
					moleculeDescriptionAssociations,
					WordBoundary ~~ Alternatives["fuming", "fume", "suffocating"] ~~ WordBoundary,
					All,
					IgnoreCase -> True
				]];

				MatchQ[fumingMentions, {_String..}]
			];

			(* Do our H-Codes contain any of these? Gases also can't be fuming as they're already gas *)
			If[
				(* If state is a gas, we can't fume *)
				MatchQ[state, Gas],
				False,

				(* Otherwise check the h codes and the description check *)
				Or[ContainsAny[hCodesSplit /. $Failed -> {}, fumingHCodes], fumingDescriptionQ]
			]
		],

		BooleanP
	];

	(* Parse the DOT Hazard Class using the DOT Hazardous materials table. *)
	dotHazard = safeParse[
		Module[{dotHazardClasses, dotHazardAssociations, pubchemDOTLabel},

			(* Hazard number to class *)
			dotHazardClasses = <|
				0. -> "Class 0",
				1.1 -> "Class 1 Division 1.1 Mass Explosion Hazard",
				1.2 -> "Class 1 Division 1.2 Projection Hazard",
				1.3 -> "Class 1 Division 1.3 Fire, Blast, or Projection Hazard",
				1.4 -> "Class 1 Division 1.4 Limited Explosion",
				1.5 -> "Class 1 Division 1.5 Insensitive Mass Explosion Hazard",
				1.6 -> "Class 1 Division 1.6 Insensitive No Mass Explosion Hazard",
				2.1 -> "Class 2 Division 2.1 Flammable Gas Hazard",
				2.2 -> "Class 2 Division 2.2 Non-Flammable Gas Hazard",
				2.3 -> "Class 2 Division 2.3 Toxic Gas Hazard",
				3. -> "Class 3 Flammable Liquids Hazard",
				4.1 -> "Class 4 Division 4.1 Flammable Solid Hazard",
				4.2 -> "Class 4 Division 4.2 Spontaneously Combustible Hazard",
				4.3 -> "Class 4 Division 4.3 Dangerous when Wet Hazard",
				5.1 -> "Class 5 Division 5.1 Oxidizers Hazard",
				5.2 -> "Class 5 Division 5.2 Organic Peroxides Hazard",
				6.1 -> "Class 6 Division 6.1 Toxic Substances Hazard",
				6.2 -> "Class 6 Division 6.2 Infectious Substances Hazard",
				7. -> "Class 7 Division 7 Radioactive Material Hazard",
				8. -> "Class 8 Division 8 Corrosives Hazard",
				9. -> "Class 9 Miscellaneous Dangerous Goods Hazard"
			|>;

			(* Pull out the DOT hazard association section *)
			dotHazardAssociations = safeParse[extractJSON[safetyAndHazards, {"TOCHeading" == "Transport Information", "Section", "TOCHeading" == "DOT Label", "Information"}], _List];

			(* Check if DOT information is included in the PubChem record *)
			pubchemDOTLabel = If[!FailureQ[dotHazardAssociations],
				Module[{pubchemDOTLabelStrings, labelWords, bestCode},
					(* And then pull out the label - often a shorthand version of the strings above *)
					pubchemDOTLabelStrings = extractValues[dotHazardAssociations];

					(* Find the best match *)


					(* Split the labels we found into words and crudely remove plurals. No harm if we remove "s" from other words *)
					labelWords = DeleteDuplicates[StringReplace[Flatten[StringSplit[pubchemDOTLabelStrings]], "s" ~~ WordBoundary -> ""]];

					(* See which code contains the most words *)
					bestCode = MaximalBy[
						Values[dotHazardClasses],
						StringCount[#,
							(* Make sure pattern matches whole words only - We can't use WordBoundary because it classes "-" in non-flammable as a word boundary *)
							(* Match whole words so flammable doesn't match non-flammable *)
							(* As we use whitespace, we have to allow overlaps in case words share a space *)
							Alternatives @@ (StringExpression[
								Alternatives[StartOfString, WhitespaceCharacter],
								#,
								Alternatives[Alternatives[EndOfString, WhitespaceCharacter], "s" ~~ Alternatives[EndOfString, WhitespaceCharacter]]
							]
								& /@ labelWords),
							IgnoreCase -> True,
							Overlaps -> True
						] &
					];

					(* Return the shortest match of the best ones if there are multiple *)
					First[MinimalBy[bestCode, StringLength], Null]
				],
				Null
			];

			(* If we were able to find a UN number before, use that to look up the DOT Hazard Class. *)
			Which[
				(* If we got the label from PubChem, use it *)
				!NullQ[pubchemDOTLabel],
				pubchemDOTLabel,

				(* Otherwise look up in hard coded database *)
				!NullQ[unNumber],
				Module[{dotHazardNumber}, (* Import our DOT Hazard dataset and look for this UN Number. *)
					dotHazardNumber = dotHazardClass["UN" <> unNumber];

					(* Convert this Hazard number into the correct Emerald string that matches DOTHazardClassP. *)
					FirstCase[KeyValueMap[{#1, #2} &, dotHazardClasses], {EqualP[dotHazardNumber], x_} :> x, $Failed]
				],

				(* Otherwise, we can't find a hazard class, so return Null *)
				True,
				$Failed
			]
		],

		DOTHazardClassP
	];

	(* Determine if our molecule is unsuitable for drain disposal *)
	drainDisposal = safeParse[
		Module[
			{environmentalHazardHCodes, disposalPCodes, hCodeDrainDisposalProblemQ, pCodeDrainDisposalProblemQ},

			(* H codes indicating environmental hazard *)
			environmentalHazardHCodes = {"H400", "H401", "H402", "H410", "H411", "H412", "H413"};

			(* P codes indicating special disposal instructions *)
			disposalPCodes = {"P273"};

			(* Check if we have a problem because of the codes *)
			hCodeDrainDisposalProblemQ = TrueQ[MemberQ[hCodesSplit, Alternatives @@ environmentalHazardHCodes]];
			pCodeDrainDisposalProblemQ = TrueQ[MemberQ[pCodesSplit, Alternatives @@ disposalPCodes]];

			(* If any of the listed conditions are met, set DrainDisposal to False. Otherwise we $Failed *)
			If[
				Or[
					hCodeDrainDisposalProblemQ,
					pCodeDrainDisposalProblemQ,

					(* Also don't dispose of if radioactive *)
					radioactive

					(* Don't add other hazards here as they can be too broad brush *)
					(* E.g. sulfuric acid is water reactive (explosive when concentrated) but is fine for drain disposal when diluted *)
				],
				False,
				$Failed
			]
		],

		BooleanP
	];

	(* Figure out if this chemical is light sensitive *)
	lightSensitive = safeParse[
		Module[{stabilityAndShelfLifeSection, storageConditionsSection, combinedLightSensitiveSections, lightSensitivityMentions},
			(* Check if the storage section mentions light sensitivity *)
			stabilityAndShelfLifeSection = Quiet[extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Stability/Shelf Life", "Information"}]];
			storageConditionsSection = Quiet[extractJSON[safetyAndHazards, {"TOCHeading" == "Handling and Storage", "Section", "TOCHeading" == "Storage Conditions", "Information"}]];

			(* Combine the associations *)
			combinedLightSensitiveSections = Cases[Flatten[{stabilityAndShelfLifeSection, storageConditionsSection}], _Association];

			(* Return $Failed if no info *)
			If[MatchQ[combinedLightSensitiveSections, {}],
				Return[$Failed, Module]
			];

			(* Find any strings that confirm light sensitivity *)
			lightSensitivityMentions = extractStringValues[
				combinedLightSensitiveSections,
				Alternatives[
					"light sensitive",
					"protect" ~~ Alternatives["", "ed", "ion"] ~~ " from " ~~ Alternatives["", "sun"] ~~ "light",
					"light" ~~ Alternatives["", " ", "-"] ~~ "resistant container",
					"avoid "~~ Alternatives["", "sun"] ~~ "light"
				],
				IgnoreCase -> True
			];

			(* Light sensitivity is relatively uncommon and should be mentioned in these sections, so we can be fairly confident that no mention == False *)
			(* So seems reasonable to set False if it's not True, if we have data *)
			MatchQ[lightSensitivityMentions, {_String..}]
		],

		BooleanP
	];

	(* Figure out if this chemical is pungent *)
	pungent = safeParse[
		Module[
			{
				recordDescriptionSection, propertiesPhysicalDescriptionSection, namesPhysicalDescriptionSection,
				odorDescriptionSection, combinedOdorDescriptionSections, odorDescriptionMentions, odorSectionMentions,
				strongOdorQualifiers, odorSynonyms, odorDescriptionPungentQ, odorSectionPungentQ
			},

			(* Check if description and odor sections mention odor *)
			recordDescriptionSection = Quiet[extractJSON[namesAndIdentifiersJSON, {"TOCHeading" == "Record Description", "Information"}]];
			propertiesPhysicalDescriptionSection = Quiet[extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Physical Description", "Information"}]];
			namesPhysicalDescriptionSection = Quiet[extractJSON[namesAndIdentifiersJSON, {"TOCHeading" == "Physical Description", "Information"}]];
			odorDescriptionSection = Quiet[extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "Physical Description", "Information"}]];

			(* Combine the description associations *)
			combinedOdorDescriptionSections = Cases[Flatten[{recordDescriptionSection, propertiesPhysicalDescriptionSection, namesPhysicalDescriptionSection}], _Association];

			(* Return $Failed if no info *)
			If[And[MatchQ[combinedOdorDescriptionSections, {}], !MatchQ[odorDescriptionSection, {_Association..}]],
				Return[$Failed, Module]
			];

			(* Set of words that mean a strong odor. Celebrating the rich tapestry of the English language *)
			strongOdorQualifiers = {"strong", "pungent", "suffocating", "sharp", "offensive", "disagreeable", "intense", "penetrating", "jolly nasty"};
			odorSynonyms = {"odor", "odour", "smell"};

			(* Find any strings that confirm strong odor. These sections are general, so we need to make sure it's talking about odor *)
			odorDescriptionMentions = extractStringValues[
				combinedOdorDescriptionSections,
				StringExpression[
					Alternatives @@ strongOdorQualifiers,
					" ",
					Alternatives @@ odorSynonyms
				],
				IgnoreCase -> True
			];

			(* Decide if odor description mentions exceed the threshold *)
			(* A single mention is sufficient here - false positive are unlikely *)
			odorDescriptionPungentQ = MatchQ[odorDescriptionMentions, {_String..}];

			(* Find any strings that confirm strong odor. This section is for odors only, so strong/pungent etc alone are sufficient without any odor word *)
			odorSectionMentions = extractStringValues[
				odorDescriptionSection,
				Alternatives @@ strongOdorQualifiers,
				IgnoreCase -> True
			];

			(* Decide if odor section mentions exceed the threshold *)
			(* Make sure at least 1/2 mention - this guards against irritating entries that describe what the odor is *not* such as ref 32 for glycerin *)
			odorSectionPungentQ = MatchQ[odorSectionMentions, {Repeated[_String, {Max[Floor[Length[odorDescriptionSection] / 2], 1], Infinity}]}];

			(* High pungency is unusual and should be mentioned in these sections, so we can be fairly confident that no mention == False *)
			(* So seems reasonable to set False if it's not True, if we have data *)
			Or[odorDescriptionPungentQ, odorSectionPungentQ]
		],

		Alternatives[BooleanP, Null]
	];

	(* Figure out if our compound is strongly acidic - defined as ~pKa <= 4 *)
	(* This includes acids that are chemically not a "strong acid" such as phosphoric acid, but they are acidic enough to have storage implications *)
	stronglyAcidic = safeParse[
		Module[
			{nfpaAcidQ, pkaAcidQ},

			(* Check if our NFPA rating says we're acidic. Defer to Null as this is a non-standard code *)
			nfpaAcidQ = If[MatchQ[nfpaHazards, _List],
				MemberQ[Last[nfpaHazards], Acid] /. False -> Null,
				Null
			];

			(* GHS h-codes don't have any acid specific codes *)

			(* Check if we meet the pKa threshold *)
			pkaAcidQ = If[MatchQ[pkas, _List],
				MemberQ[pkas, LessEqualP[4]],
				Null
			];

			If[NullQ[nfpaAcidQ] && NullQ[pkaAcidQ],
				(* Return $Failed if we can't tell *)
				$Failed,

				(* Otherwise return our determination *)
				Or[nfpaAcidQ, pkaAcidQ]
			]
		],
		BooleanP
	];

	(* Figure out if our compound is a strong base - defined as ~pKaH >= 11 *)
	(* But we don't parse the pka of the conjugate acid, so we can't work with that. Instead take a look at the pH section *)
	stronglyBasic = safeParse[
		Module[
			{pHDataAssociations, alkalineSolutionQ},

			(* Pull out the pH section, if there is one *)
			pHDataAssociations = extractJSON[experimentalChemicalAndPhysicalProperties, {"TOCHeading" == "pH", "Information"}];

			(* If the section mentions strongly alkaline solutions, we've got a strong base *)
			(* pH is the property of a solution - concentration/condition dependent - so don't attempt to parse values *)
			alkalineSolutionQ = MatchQ[
				extractStringValues[
					pHDataAssociations,
					"strong" ~~ ___ ~~ Alternatives["base", "basic", "alkaline"],
					IgnoreCase -> True
				],
				{_String..}
			];

			(* If we didn't find a mention, return $Failed rather than False as information could be missing *)
			alkalineSolutionQ /. {False -> $Failed}
		],
		BooleanP
	];

	(* Figure out if our compound is corrosive *)
	corrosive = safeParse[
		Module[
			{nfpaCorrosiveQ, corrosiveHCodes, hCodeCorrosiveQ, dotCorrosiveQ},

			(* Check if our NFPA rating says we're corrosive. Defer to Null as this is a non-standard code *)
			nfpaCorrosiveQ = If[MatchQ[nfpaHazards, _List],
				MemberQ[Last[nfpaHazards], Corrosive] /. False -> Null,
				Null
			];

			(* GHS h-codes for corrosion *)
			corrosiveHCodes = {"H290"};

			hCodeCorrosiveQ = If[MatchQ[hCodesSplit, _List],
				MemberQ[hCodes, Alternatives @@ corrosiveHCodes],
				Null
			];

			(* Check DOT code *)
			dotCorrosiveQ = If[StringQ[dotHazard],
				MatchQ[dotHazard, "Class 8 Division 8 Corrosives Hazard"],
				Null
			];

			(* Determine if we're corrosive *)
			If[NullQ[nfpaCorrosiveQ] && NullQ[hCodeCorrosiveQ] && NullQ[stronglyAcidic] && NullQ[stronglyBasic] && NullQ[dotCorrosiveQ],
				(* Return $Failed if we can't tell *)
				$Failed,

				(* Otherwise return our determination *)
				Or[nfpaCorrosiveQ, hCodeCorrosiveQ, stronglyAcidic, stronglyBasic, dotCorrosiveQ]
			]
		],
		BooleanP
	];

	(* Determine if compound needs to be ventilated *)
	ventilated = safeParse[
		TrueQ[Or[
			fuming,
			pungent,
			MatchQ[hazardous, ParticularlyHazardousSubstance]
		]],
		BooleanP
	];

	(* Assemble a list of probably incompatible materials *)
	incompatibleMaterials = safeParse[
		Module[
			{
				safeStorageAssociations, reactivityProfileAssociations, reactivityAndIncompatibilityAssociations, joinedIncompatibilityAssociations,
				incompatibleOxidizers, incompatibleOrganics, incompatibleGlasses, incompatibleMetals, allIncompatibleMaterials,
				listify
			},

			(* Look up key descriptions *)
			safeStorageAssociations = Quiet@extractJSON[safetyAndHazards, {"TOCHeading" == "Handling and Storage", "Section", "TOCHeading" == "Safe Storage", "Information"}];
			reactivityProfileAssociations = Quiet@extractJSON[safetyAndHazards, {"TOCHeading" == "Stability and Reactivity", "Section", "TOCHeading" == "Reactivity Profile", "Information"}];
			reactivityAndIncompatibilityAssociations = Quiet@extractJSON[safetyAndHazards, {"TOCHeading" == "Stability and Reactivity", "Section", "TOCHeading" == "Hazardous Reactivities and Incompatibilities", "Information"}];

			(* Combine the associations *)
			joinedIncompatibilityAssociations = Cases[Flatten[{safeStorageAssociations, reactivityProfileAssociations, reactivityAndIncompatibilityAssociations}], _Association];


			(* See if we have indicators of incompatibility with various classes *)
			(* When checking the safety data, you need to be careful. Occasionally compounds that are not a problem are mentioned. Also "Metal" could be "Metal", "non-metal", or "store in metal containers" *)
			(* Potential application for LLM *)

			(* Small helper to convert nested Alternatives in patterns to a list of items *)
			listify[pattern_] := Sort[Flatten[ReplaceAll[pattern, Alternatives -> List]]];

			(* Check for incompatibility with oxidizers *)
			incompatibleOxidizers = Module[
				{mentionedInSafetySection},

				(* Check if oxidizers are mentioned in the safety section - these only get mentioned if they're a problem *)
				mentionedInSafetySection = MatchQ[
					extractStringValues[
						joinedIncompatibilityAssociations,
						Alternatives["oxidizer", "oxidant"],
						IgnoreCase -> True
					],
					{_String..}
				];

				(* Incompatible if mentioned in the safety section, we're flammable/pyrophoric or a strong acid or base *)
				If[
					TrueQ[Or[
						mentionedInSafetySection,
						flammable,
						pyrophoric,
						stronglyAcidic,
						stronglyBasic
					]],
					{Oxidizer},
					{}
				]
			];

			(* Check for incompatibility with organic substances, such as wood. We're not referring to "organic" as in organic solvents here *)
			incompatibleOrganics = If[
				TrueQ[Or[
					stronglyAcidic,
					stronglyBasic,
					corrosive
				]],
				listify[OrganicMaterialP],
				{}
			];

			(* Check for incompatibility with glass *)
			(* Check for the word "etching". Glass if often mentioned as a safe container material. Corrosive materials are typically deemed compatible with glass *)
			incompatibleGlasses = If[
				MatchQ[extractStringValues[joinedIncompatibilityAssociations, Alternatives[WordBoundary ~~ "etch"], IgnoreCase -> True], {_String..}],
				listify[GlassP],
				{}
			];

			(* Check for incompatibility with metals *)
			(* These are metals that can be used as 'material' so we're not talking alkali metals *)
			(* We will also exclude corrosion resistant metals from our list too *)
			incompatibleMetals = Module[{corrosionResistantMetals, baseReactiveMetals, allMetals},

				(* Define some lists of special metals - members of MetalP *)
				(* Some metals are slow to corrode - we're being generic here about corrosion - anything marked as such by hazard classifications *)
				corrosionResistantMetals = {Platinum, Gold, Silver, StainlessSteel, Titanium, Aluminum};

				(* Most metals don't react with bases *)
				baseReactiveMetals = {Aluminum, Zinc};

				(* List all the metals we know *)
				allMetals = listify[MetalP];

				Which[
					(* Strong acids react with most metals *)
					TrueQ[stronglyAcidic],
					Complement[allMetals, corrosionResistantMetals],

					(* Strong bases only react with some metals *)
					TrueQ[stronglyBasic],
					baseReactiveMetals,

					(* If corrosive, assume reacts with all but inert metals. If we know it's a strong base, we already took the shorter list *)
					TrueQ[corrosive],
					Complement[allMetals, corrosionResistantMetals],

					(* Otherwise we're good *)
					True,
					{}
				]
			];

			(* Total up the list of incompatible materials *)
			allIncompatibleMaterials = Flatten[{
				incompatibleOxidizers,
				incompatibleOrganics,
				incompatibleGlasses,
				incompatibleMetals
			}];

			(* Return the list, or {None} if it's empty *)
			If[!MatchQ[allIncompatibleMaterials, {}],
				allIncompatibleMaterials,
				{None}
			]
		],
		Alternatives[{MaterialP..}, {None}]
	];

	(* -- Misc -- *)
	(* Having the PubChem ID buys us a few more things *)
	(* Unoptimized coordinates of structure in sdf format *)
	structureFileURL = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/" <> ToString[cid] <> "/record/SDF/?record_type=2d&response_type=display";

	(* 2D image of chemical structure *)
	imageFileURL = "https://pubchem.ncbi.nlm.nih.gov/image/imagefly.cgi?cid=" <> ToString[cid] <> "&width=500&height=500";

	(* Return an association with our constructed information. *)
	(* Replace any $Failed values with Null. It was useful internally to know if parsing failed, or we explicitly extracted a Null value *)
	(* But this function should not make a fuss and return Null *)
	Replace[
		<|
			Name -> moleculeName,
			MolecularWeight -> molecularWeight,
			MolecularFormula -> molecularFormula,
			ExactMass -> exactMass,
			Monatomic -> monatomic,
			StructureFile -> structureFileURL,
			StructureImageFile -> imageFileURL,
			CAS -> casNumber,
			UNII -> unii,
			IUPAC -> iupacName,
			InChI -> inchi,
			InChIKey -> inchiKey,
			Synonyms -> synonyms,
			State -> state,
			pKa -> pkas,
			(* Additional scraping data that we should only lookup if we're being called from SimulateLogPartitionCoefficient. *)
			If[MatchQ[ExternalUpload`Private`$SimulatedLogP, True],
				SimulatedLogP -> simulatedLogP,
				Nothing
			],
			LogP -> logP,
			BoilingPoint -> boilingPoint,
			VaporPressure -> vaporPressure,
			MeltingPoint -> meltingPoint,
			Density -> density,
			Viscosity -> viscosity,
			Radioactive -> radioactive,
			ParticularlyHazardousSubstance -> particularlyHazardousSubstance,
			MSDSRequired -> msdsRequired,
			DOTHazardClass -> dotHazard,
			NFPA -> nfpaHazards,
			Flammable -> flammable,
			Pyrophoric -> pyrophoric,
			WaterReactive -> waterReactive,
			Fuming -> fuming,
			Ventilated -> ventilated,
			DrainDisposal -> drainDisposal,
			LightSensitive -> lightSensitive,
			Pungent -> pungent,
			Acid -> stronglyAcidic,
			Base -> stronglyBasic,
			IncompatibleMaterials -> incompatibleMaterials,
			PubChemID -> ToExpression[cid],
			Molecule -> molecule
		|>,
		$Failed -> Null,
		{1}
	]
];



(* ::Subsubsection::Closed:: *)
(*PubChem CID to Association (parsePubChem) *)


parsePubChem[PubChem[myPubChemID_]]:=Module[
	{result},

	(* Attempt to query PubChem using this PubChem ID. If the PubChem server errors out, set our result to #Failed.*)
	result=Quiet[
		Check[
			parsePubChemCID[ToString[myPubChemID]],
			$Failed]
	];

	(* If the query didn't fail, memoize it. *)
	If[!SameQ[result, $Failed],
		parsePubChem[PubChem[myPubChemID]]=result;
	];

	(* Return the result. *)
	result
];



(* ::Subsubsection::Closed:: *)
(*Chemical Identifier to Association (parseChemicalIdentifier)*)


(* This helper function takes in a chemical identifier (including name) and returns an association of PubChem information. *)
parseChemicalIdentifier[identifier_String]:=Module[
	{result, pubChemNameURL, filledURL, jsonResponse, cid},
	result=Quiet[
		Check[
			(* The following is the template URL of the PubChem API for CIDs. The CID goes in `1`. *)
			pubChemNameURL="https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/JSON?name=`1`";

			(* Fill out the template URL with the given CID. *)
			filledURL=StringTemplate[pubChemNameURL][EncodeURIComponent[identifier]];

			(* Make a POST request to this URL. *)
			jsonResponse=ManifoldEcho[Quiet[URLExecute[filledURL, "RawJSON"]], "URLExecute[\""<>ToString[filledURL]<>"\", \"RawJSON\"]"];

			(* If an error was returned, return $Failed. Throw a message in the higher level function that called this one. *)
			If[MemberQ[jsonResponse, _Failure],
				Return[$Failed];
			];

			(* Extract the CID from the JSON packet. *)
			cid=jsonResponse["PC_Compounds"][[1]]["id"]["id"]["cid"];

			(* Use the CID to association parser. *)
			parsePubChemCID[cid],

			(* If something happened, return $Failed. Our high-level functions check for this. *)
			$Failed
		]
	];

	(* Iff the result is not $Failed, memoize. *)
	If[!SameQ[result, $Failed],
		parseChemicalIdentifier[identifier]=result;
	];

	(* Return the result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(*InChI to Association (parseInChI)*)

(* Overload for MM 12.3.1 which uses the Head ExternalIdentified[], instead of a direct string *)
parseInChI[ExternalIdentifier["InChI", identifier_String]]:=parseInChI[identifier];
(* This helper function takes in an InChI and returns an association of PubChem information. *)
parseInChI[identifier_String]:=Module[
	{result, pubChemInChIURL, filledURL, jsonResponse, cid},

	result=Quiet[
		Check[
			(* The following is the template URL of the PubChem API for CIDs. The CID goes in `1`. *)
			pubChemInChIURL="https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchi/JSON?inchi=`1`";

			(* Fill out the template URL with the given CID. *)
			filledURL=StringTemplate[pubChemInChIURL][EncodeURIComponent[identifier]];

			(* Make a POST request to this URL. *)
			jsonResponse=ManifoldEcho[
				Quiet[URLExecute[filledURL, "RawJSON"]],
				"Quiet[URLExecute[\""<>ToString[filledURL]<>"\", \"RawJSON\"]]"
			];

			(* If an error was returned, return $Failed. Throw a message in the higher level function that called this one. *)
			If[MemberQ[jsonResponse, _Failure],
				Return[$Failed];
			];

			(* Extract the CID from the JSON packet. *)
			cid=jsonResponse["PC_Compounds"][[1]]["id"]["id"]["cid"];

			(* Use the CID to association parser. *)
			parsePubChemCID[cid],

			(* If something happened, return $Failed. Our high-level functions check for this. *)
			$Failed
		]
	];

	(* Iff the result is not $Failed, memoize. *)
	If[!SameQ[result, $Failed],
		parseInChI[identifier]=result;
	];

	(* Return the result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(*ThermoFisher to Association (parseThermoURL)*)


parseThermoURL[url_String]:=Module[
	{result, response, thermoWebsite, casList, generalCASList, casInformation, productID, msdsURL, msdsPage, msdsString, cas,
		pubChemInformation, informationWithMSDS, thermoName},

	(* Wrap our computation with Quiet[] and Check[] because sometimes contacting the web server can result in an error. *)
	result=Quiet[
		Check[

			(* Download the HTML for the website. *)
			response = ManifoldEcho[
				URLRead[HTTPRequest[url, <|Method -> "GET"|>]],
				"URLRead[HTTPRequest[\""<>ToString[url]<>"\", <|Method -> \"GET\"|>]]"
			];
			thermoWebsite = {response["Body"]};

			(* Return early if the URLRead failed *)
			If[MatchQ[thermoWebsite, {Missing["NotAvailable", "Body"]}],
				Return[$Failed]
			];

			(* Get the product number from the ThermoFisher URL. *)
			(* If for some reason the URL doesnt match this pattern, look for it in the thermoWebsite. *)
			(* If it can't be found in the URL or site content, set it to empty string *)
			productID = FirstCase[
				{
					StringCases[url, "/catalog/product/"~~x:(DigitCharacter | WordCharacter | "-").. :> x],
					StringCases[First[thermoWebsite], "\"productId\":\""~~x:(DigitCharacter | WordCharacter | "-")..~~"\"" :> x]
				},
				Except[{}],
				""
			];

			(* Attempt to parse out the name of this chemical from the page. *)
			thermoName = Quiet[Check[
				Module[{rawStringName},
					(* Pull out the string within the <title> ... </title> *)
					rawStringName = FirstOrDefault[First[StringCases[thermoWebsite, Shortest["<title" ~~ ___ ~~ ">" ~~ x__ ~~ "</title>"] :> x]]];

					(* Convert all HTML entities into empty strings (Mathematica can't handle these) *)
					If[MatchQ[rawStringName, Null],
						Null,
						StringReplace[rawStringName, {
							("&#" | "&")~~(DigitCharacter | WordCharacter)..~~";" :> "",
							" | "~~(DigitCharacter..)~~"-"~~__ -> ""
						}]
					]
				],
				(* We failed to get the name, return Null. *)
				Null
			]];

			(* Extract the CAS Number as a list. *)
			casList = First[
				StringCases[
					First[thermoWebsite],
					{
						"CAS number: "~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~"<" -> {x, y, z},
						"CAS\",\"value\":\""~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~"\"" -> {x, y, z},
						"CAS\",\n"~~Whitespace..~~"\"value\": \""~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~"\"" -> {x, y, z}
					}
				],
				{}
			];

			(* If we successfully extracted CAS Number: XXX-XXX-XXX, use that. Otherwise, look for CAS in a more general way.*)
			generalCASList = If[Length[casList] > 0,
				{casList},
				StringCases[First[thermoWebsite], x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter.. -> {x, y, z}]
			];

			(* Download the information via PubChem via CAS or PubChemID *)
			casInformation = If[Length[generalCASList] > 0,
				(* Join the three extracted numbers to get the CAS. *)
				cas = StringJoin[Riffle[First[Commonest[generalCASList]], "-"]];

				(* Download the PubChem information via CAS. *)
				parseChemicalIdentifier[cas],

				(* Otherwise, we can't get information from the CAS. *)
				$Failed
			];

			(* Finally, if we couldn't get information from the InChIKey and we successfully parsed out a name, look for information from the name of the chemical. *)
			pubChemInformation = If[MatchQ[casInformation, $Failed] && !MatchQ[thermoName, Null],
				Module[{parsedByName},
					parsedByName = parseChemicalIdentifier[thermoName];

					If[!MatchQ[parsedByName, $Failed],
						parsedByName,
						casInformation
					]
				],
				casInformation
			];

			(* Attempt to get the MSDS Information. If we fail, that's okay - default to Null. *)
			msdsURL = Quiet[Check[

				(* Construct the URL to the MSDS of this chemical. *)
				msdsPage = "https://assets.thermofisher.com/TFS-Assets/LSG/SDS/"<>productID<>"_MTR-NALT_EN.pdf";

				(* Download the PDF and convert it to Plaintext. *)
				msdsString = Import[msdsPage, "Plaintext"];

				(* If we successfully got the URL and imported the body in plain text, return the msdsPage as the URL *)
				(* If we failed to get the PDF in Plaintext, msdsURL should be Null *)
				If[Length[StringCases[msdsString, "Safety Data Sheet"]] > 0,
					msdsPage,
					Null
				],

				(* Return Null if we encounter an error. *)
				Null
			]];

			(* Append MSDSFile\[Rule]msdsURL and MSDSRequired\[Rule]True *)
			(* MSDSRequired\[Rule]True should always be set when using a product URL to parse a chemical. *)
			informationWithMSDS = If[!MatchQ[pubChemInformation, $Failed],
				Merge[{<|MSDSFile -> msdsURL, MSDSRequired -> True|>, pubChemInformation}, (First[ToList[#]]&)],
				(* If something happened, return $Failed. Otherwise the whole association remains unevualated. *)
				$Failed
			];

			(* If the name parsing succeeded, return our association with the new name. *)
			If[!SameQ[thermoName, Null],
				(* The name parsing succeeded. Convert the association to a list so that we can replace the name. Then convert it back to an association. *)
				Module[{associationAsList, listWithName},
					(* Convert the association to a list. *)
					associationAsList = Normal[informationWithMSDS];

					(* Replace the name with our newly parsed name. *)
					listWithName = associationAsList /. (Name -> _) -> (Name -> thermoName);

					(* Convert it back to an association *)
					Association @@ listWithName
				],
				(* The name parsing didn't succeed. Return the original name. *)
				informationWithMSDS
			],

			(* If something happened, return $Failed. Our high-level functions check for this. *)
			$Failed
		]
	];

	(* Only memoize if the result wasn't Null. This is because the ThermoFisher server can sometimes fail or *)
	(* lock us out if we're making too many requests. *)
	If[!SameQ[result, $Failed],
		parseThermoURL[url] = result;
	];

	(* Return our result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(*Sigma to Association (parseSigmaURL)*)


parseSigmaURL[url_String]:=Module[
	{result, sigmaWebsite, casList, generalCASList, cas, pubChemInformation, msdsURL,
		sigmaID, sigmaMSDSPage, msdsBody, msdsID, potentialMSDSURL, potentialMSDSBody,
		informationWithMSDS, sigmaName, inchiKeyList, casInformation, inchiKeyInformation},

	(* Wrap our computation with Quiet[] and Check[] because sometimes contacting the web server can result in an error. *)
	result = Quiet[
		Check[
			(* Download the HTML for the website. *)
			sigmaWebsite = {
				ManifoldEcho[
					URLRead[
						HTTPRequest[
							url,
							<|
								Method -> "GET",
								(* this is a header that we found can work to get a response for now, but just so people keep an eye sigma may block us at any time b/c we run unit tests and ping their website too often *)
								"Headers" -> {
									"accept-language" -> "en-US,en;q=0.9",
									"user-agent" -> "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36"
								}
							|>
						]
					]["Body"],
					"URLRead[HTTPRequest[\""<>ToString[url]<>"\", <|Method -> \"GET\", \"Headers\" -> {\"accept-language\" -> \"en-US,en;q=0.9\", \"user-agent\" -> \"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36\"}|>]][\"Body\"]"
				]
			};

			(* Return early if the URLRead failed *)
			If[MatchQ[sigmaWebsite, {Missing["NotAvailable", "Body"]}],
				Return[$Failed]
			];

			(* Attempt to parse out the name of this chemical from the page. *)
			sigmaName = Quiet[Check[
				Module[{rawStringName},
					(* Pull out the string within the <title> ... </title> *)
					rawStringName = FirstOrDefault[
						StringCases[
							First[sigmaWebsite],
							{
								Shortest["\"title\":\"" ~~ x__ ~~ " " ~~ DigitCharacter.. ~~ "-" ~~ DigitCharacter.. ~~ "-" ~~ DigitCharacter ~~ "\",\"description\""] :> {x},
								Shortest["\"title\":\"" ~~ x__ ~~ " |"] :> {x}
							}
						],
						""
					];

					(* Convert all HTML entities into empty strings (Mathematica can't handle these) *)
					(* Also remove the | Sigma-Aldrich from the name. This shows up in the page title for styling. *)
					If[MatchQ[rawStringName, Null],
						Null,
						StringReplace[rawStringName, {
							"&#"~~(DigitCharacter | WordCharacter)..~~";" :> "",
							" | Sigma-Aldrich" -> "",
							" | "~~(DigitCharacter..)~~"-"~~__ -> ""
						}]
					]
				],
				(* We failed to get the name, return Null. *)
				Null
			]];

			(* Extract the CAS Number as a list. *)
			casList = FirstOrDefault[
				StringCases[
					First[sigmaWebsite],
					{
						"CAS No.: "~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~";" -> {x, y, z},
						"casNumber\":\""~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~"\"" -> {x, y, z},
						"CAS Number: "~~x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter..~~";" -> {x, y, z}
					}
				],
				{}
			];

			(* If we successfully extracted CAS Number: XXX-XXX-XXX, use that. Otherwise, look for CAS in a more general way.*)
			generalCASList = If[Length[casList] > 0,
				{casList},
				StringCases[First[sigmaWebsite], x:DigitCharacter..~~"-"~~y:DigitCharacter..~~"-"~~z:DigitCharacter.. -> {x, y, z}]
			];

			(* Download the information via PubChem via CAS or PubChemID *)
			casInformation = If[Length[generalCASList] > 0,
				(* Join the three extracted numbers to get the CAS. *)
				cas = StringJoin[Riffle[First[Commonest[generalCASList]], "-"]];

				(* Download the PubChem information via CAS. *)
				parseChemicalIdentifier[cas],

				(* Otherwise, we can't get information from the CAS. *)
				$Failed
			];

			(* If we couldn't get information from CAS, try to get the InChIKey. *)
			inchiKeyInformation = If[MatchQ[casInformation, $Failed],
				(* Look for the InChIKey. *)
				inchiKeyList = FirstOrDefault[
					StringCases[
						First[sigmaWebsite],
						{
							"InChI key\",\"values\":[\""~~x:LetterCharacter..~~"-"~~y:LetterCharacter..~~"-"~~z:LetterCharacter..~~"\"]"->{x~~"-"~~y~~"-"~~z},
							x:(WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~"-"~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~"-"~~WordCharacter):>{x}
						}
					],
					{}
				];

				(* Get PubChem information from the PubChem CID *)
				If[Length[inchiKeyList]==0,
					$Failed,
					parseChemicalIdentifier[First[inchiKeyList]]
				],
				(* Otherwise, we already have info from the CAS, use that. *)
				casInformation
			];

			(* Finally, if we couldn't get information from the InChIKey and we successfully parsed out a name, look for information from the name of the chemical. *)
			pubChemInformation = If[MatchQ[inchiKeyInformation, $Failed] && !MatchQ[sigmaName, Null],
				parseChemicalIdentifier[sigmaName],
				inchiKeyInformation
			];

			(* Attempt to get the MSDS Information. If we fail, that's okay - default to Null. *)
			msdsURL = Quiet[Check[
				(* Pull out the Product key from the Sigma website. *)
				sigmaID = StringTrim[
					First[
						FirstOrDefault[
							StringCases[
								First[sigmaWebsite],
								{
									"<strong itemprop=\"productKey\">"~~x:(DigitCharacter | WordCharacter | "-" | "_" | " ")..~~"</strong>" :> {x},
									Shortest["\"productKey\":\""~~x:__~~"\""] :> {x}
								}
							],
							""
						]
					]
				];

				(* Make a request to the Sigma MSDS searcher. *)
				(* DO NOT use the Emerald specific POST/GET functions here as they do not store the cookies. *)
				sigmaMSDSPage = Module[{productType},
					(* First extract the type of product from the URL. If it isnt found set to Null*)
					productType = FirstOrDefault[
						StringCases[url, "/product/" ~~ x : (WordCharacter ..) ~~ "/" :> x],
						Null
					];

					(* If we have a sigmaID and a productType, use these to get the MSDS URL. *)
					If[!MatchQ[productType, Null] && !MatchQ[sigmaID, Null],
						"https://www.sigmaaldrich.com/MSDS/MSDS/DisplayMSDSPage.do?country=US&language=en&productNumber="<>sigmaID<>"&brand="<>ToUpperCase[productType],
						Null
					]
				];

				(* Read from the MSDS page URL *)
				msdsBody = URLRead[
					HTTPRequest[
						sigmaMSDSPage,
						<|
							Method -> "GET",
							(* this is a header that we found can work to get a response for now, but just so people keep an eye sigma may block us at any time b/c we run unit tests and ping their website too often *)
							"Headers" -> {
								"accept-language" -> "en-US,en;q=0.9",
								"user-agent" -> "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36"
							}
						|>
					]
				]["Body"];

				(* 10/22/21 - The sigma website now directly returns the PDF from this request *)
				If[Length[StringCases[msdsBody, "PDF"]] > 0,
					(* If we have the PDF already, just return that for the msds URL *)
					sigmaMSDSPage,
					(* If we don't, default to the previous code *)
					(* Try and find the resolved MSDS ID from the page. Cookies are nesessary for this request, however, they are stored by using the URLRead[...] function. *)
					msdsID = FirstOrDefault@StringCases[msdsBody, "/MSDS/MSDS/PrintMSDSAction.do?name=msdspdf_"~~x:DigitCharacter.. :> x];

					If[!MatchQ[msdsID, _String],
						Null,
						(* Put together the potential MSDS URL. *)
						potentialMSDSURL = "https://www.sigmaaldrich.com/MSDS/MSDS/PrintMSDSAction.do?name=msdspdf_"<>msdsID;

						(* Download the body of the potential MSDS url. *)
						potentialMSDSBody = URLRead[
							HTTPRequest[
								potentialMSDSURL,
								<|
									Method -> "GET",
									(* this is a header that we found can work to get a response for now, but just so people keep an eye sigma may block us at any time b/c we run unit tests and ping their website too often *)
									"Headers" -> {
										"accept-language" -> "en-US,en;q=0.9",
										"user-agent" -> "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36"
									}
								|>
							]
						]["Body"];

						(* Check that the URL returned a PDF header. If so, it is good. If not, return Null. *)
						If[Length[StringCases[potentialMSDSBody, "PDF"]] > 0,
							potentialMSDSURL,
							Null
						]
					]
				],
				(* Return Null if we encounter an error. *)
				Null
			]];

			(* Append MSDSFile\[Rule]msdsURL and MSDSRequired\[Rule]True *)
			(* MSDSRequired\[Rule]True should always be set when using a product URL to parse a chemical. *)
			informationWithMSDS = If[!MatchQ[pubChemInformation, $Failed],
				Merge[{<|MSDSFile -> msdsURL, MSDSRequired -> True|>, pubChemInformation}, (First[ToList[#]]&)],
				(* If something happened, return $Failed. Otherwise the whole association remains unevualated. *)
				$Failed
			];

			(* If the name parsing succeeded, return our association with the new name. *)
			If[!SameQ[sigmaName, Null],
				(* The name parsing succeeded. Convert the association to a list so that we can replace the name. Then convert it back to an association. *)
				Module[{associationAsList, listWithName},
					(* Convert the association to a list. *)
					associationAsList = Normal[informationWithMSDS];

					(* Replace the name with our newly parsed name. *)
					listWithName = associationAsList /. (Name -> _) -> (Name -> sigmaName);

					(* Convert it back to an association *)
					Association @@ listWithName
				],
				(* The name parsing didn't succeed. Return the original name. *)
				informationWithMSDS
			],

			(* If something happened, return $Failed. Our high-level functions check for this. *)
			$Failed
		]
	];


	(* Only memoize if the result wasn't Null. This is because the ThermoFisher server can sometimes fail or *)
	(* lock us out if we're making too many requests. *)
	If[!SameQ[result, $Failed],
		parseSigmaURL[url]=result;
	];

	(* Return our result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(* findSDS *)

DefineOptions[findSDS,
	Options :> {
		{Vendor -> All, Alternatives[All, ListableP[_String]], "Ordered list of preferred vendors to return SDS from. Matches vendor URL. Function will attempt to return an SDS in all cases, even if one can't be sourced from a listed Vendor."},
		{Manufacturer -> All, Alternatives[All, ListableP[_String]], "Ordered list of preferred manufacturer to return SDS from. Matches manufacturer name. Function will attempt to return an SDS in all cases, even if one can't be sourced from a listed manufacturer."},
		{Product -> All, Alternatives[All, ListableP[_String]], "A list of preferred product numbers to return the SDS for. Matches any part of SDS database entry. Function will attempt to return an SDS in all cases, even if one can't be sourced with the specified product identifier."},
		{Output -> Open, Alternatives[URL, ValidatedURL, TemporaryFile, Open, CloudFile], "The format to return the SDS in. URL returns the best URL. ValidatedURL returns the best URL that's confirmed to return a pdf. Temporary file downloads the pdf and returns the local file reference. Open opens the pdf. Cloud file uploads the pdf to constellation and returns the cloud file."}
	}
];

(* Pretty much every part of this function is memoized to reduce pinging of servers and reduce the chance we hit any rate limits *)
findSDS[myIdentifier: Alternatives[_String, CASNumberP], myOptions : OptionsPattern[findSDS]] := Module[
	{safeOptions, vendorOption, outputOption, productOption, manufacturerOption, sdsData, filteredSDSData, sortedSDSData, validatedURL, downloadedPDF},

	(* Parse the options *)
	safeOptions = SafeOptions[findSDS, ToList[myOptions]];
	{vendorOption, manufacturerOption, productOption, outputOption} = Lookup[safeOptions, {Vendor, Manufacturer, Product, Output}];

	(* Get a list of associations from Chemical Safety website, each detailing a link to an SDS *)
	sdsData = searchChemicalSafetySDS[myIdentifier];

	(* There are likely many entries in the table so filter down and sort *)

	(* Filter out data we don't want *)
	filteredSDSData = If[MatchQ[sdsData, {}],
		sdsData,
		Module[{gatheredByCAS, sortedByCASFrequency, filteredByCAS},

			(* Filter by CAS number. Redundant if the input was a CAS but helps figure out the most likely chemical if name was provided *)
			(* Gather the information by CAS number *)
			gatheredByCAS = GatherBy[sdsData, Lookup[#, "CAS"] &];

			(* Sort the data by frequency the CAS appeared *)
			sortedByCASFrequency = SortBy[gatheredByCAS, Length];

			(* Take the most frequent cas number found, unless it's blank. In that case, use the second most frequent if possible *)
			filteredByCAS = If[GreaterQ[Length[sortedByCASFrequency], 1] && MatchQ[Lookup[sortedByCASFrequency[[-1, 1]], "CAS"], ""],
				sortedByCASFrequency[[-2]],
				sortedByCASFrequency[[-1]]
			];

			(* Filter out anything with no URL *)
			Select[filteredByCAS, MatchQ[Lookup[#, "URL"], URLP] &]
		]
	];

	(* Now sort the data from best to worst *)
	sortedSDSData = Module[{defaultVendorPriority, defaultManufacturerPriority, manufacturerOrdering, vendorOrdering},

		(* Default scores we give to prioritize vendors *)
		(* These strings match the URL *)
		(* Sigma are good but their website is incredibly twitchy with rate limits - I hit one whilst opening links in my browser whilst developing this function *)
		defaultVendorPriority = {
			"sigmaaldrich" -> 1,
			"thermofisher" -> 4,
			"fishersci" -> 3
		};

		(* Default scores we give to prioritize manufacturers *)
		(* These match the manufacturer field in words *)
		(* Sigma are good but their website is incredibly twitchy with rate limits - I hit one whilst opening links in my browser whilst developing this function *)
		defaultManufacturerPriority = {
			"Sigma Aldrich" -> 3,
			"Sigma" -> 3,
			"Aldrich" -> 3,
			"Thermo Fisher" -> 4,
			"Fisher Scientific" -> 4,
			"Alfa Aesar" -> 2,
			"VWR" -> 2
		};

		(* Compute the manufacturer priority *)
		manufacturerOrdering = Module[{completePriorityList, sanitizedManufacturers},
			(* Add any user specified priorities to the top of the list *)
			completePriorityList = If[MatchQ[manufacturerOption, All],
				defaultManufacturerPriority,
				Join[
					(# -> 50) & /@ ToList[manufacturerOption], (* Weight strongly if we match manufacturer *)
					defaultManufacturerPriority
				]
			];

			(* Sanitize the values *)
			sanitizedManufacturers = DeleteDuplicates[(StringReplace[ToLowerCase[First[#]], Whitespace -> ""] -> Last[#]) & /@ completePriorityList];

			(* Return the ranking, higher is better *)
			sanitizedManufacturers
		];


		(* Compute the manufacturer priority *)
		vendorOrdering = Module[{completePriorityList, sanitizedVendors},
			(* Add any user specified priorities to the top of the list *)
			completePriorityList = If[MatchQ[vendorOption, All],
				defaultVendorPriority,
				Join[
					(# -> 50) & /@ ToList[vendorOption],  (* Weight strongly if we match vendor *)
					defaultVendorPriority
				]
			];

			(* Sanitize the values *)
			sanitizedVendors = DeleteDuplicates[(StringReplace[ToLowerCase[First[#]], Whitespace -> ""] -> Last[#]) & /@ completePriorityList];

			(* Return the ranking, higher is better *)
			sanitizedVendors
		];

		(* No default prioritization for product numbers *)

		(* Sort the data *)
		ReverseSortBy[
			filteredSDSData,

			(* Compute a simple integer that represents the ordering priority of the entry *)
			Module[{url, manufacturer, productPriority, manufacturerPriority, vendorPriority},

				{url, manufacturer} = Lookup[#, {"URL", "Manufacturer"}];

				(* Compute the priority of the product matching. Just a binary True/False if the URL contains the product identifiers *)
				productPriority = If[MatchQ[productOption, All],
					(* No priority if no product specified *)
					0,

					(* Otherwise check if the url contains the product ID. Weight overwhelmingly if we find a match *)
					StringContainsQ[
						url,
						(* Compare in lower case and remove spaces *)
						Alternatives @@ StringReplace[ToLowerCase[ToList[productOption]], Whitespace -> ""],
						IgnoreCase -> True
					] /. {True -> 100, False -> 0}
				];

				(* Now deduce the manufacturer for this entry *)
				(* For every match, StringCases will return the priority number associated with it. Max will then either return the max priority found, or 0 if none found *)
				manufacturerPriority = Max[{
					0,
					StringCases[
						StringReplace[ToLowerCase[manufacturer], Whitespace -> ""],
						manufacturerOrdering,
						IgnoreCase -> True,
						Overlaps -> All
					]
				}];

				(* Now deduce the vendor priority for this entry *)
				(* For every match, StringCases will return the priority number associated with it. Max will then either return the max priority found, or 0 if none found *)
				vendorPriority = Max[{
					0,
					StringCases[
						StringReplace[ToLowerCase[url], Whitespace -> ""],
						vendorOrdering,
						IgnoreCase -> True,
						Overlaps -> All
					]
				}];

				(* Add up all the priority weightings *)
				Total[
					{
						productPriority,
						vendorPriority,
						manufacturerPriority
					}
				]
			]&
		]
	];

	(* Return the requested output *)

	(* Return early if we just want a URL without contacting the server and validating *)
	If[MatchQ[outputOption, URL],
		Return[First[Lookup[sortedSDSData, "URL", {}], Null]]
	];

	(* In all other cases, first download the contents of the URL to make sure it's a real pdf *)
	{validatedURL, downloadedPDF} = Module[
		{scanResult},

		(* Scan over all of the potential SDS in order and exit as soon as one works *)
		scanResult = Scan[
			Module[{url, downloadResult},

				url = Lookup[#, "URL"];

				(* Try and import the PDF, and check if the result is valid *)
				(* Returns either the valid File or $Failed. Function memoizes *)
				downloadResult = downloadAndValidateSDSURL[url];

				(* If the pdf is valid, return early and break the loop *)
				If[MatchQ[downloadResult, _File],
					Return[{url, downloadResult}]
				]
			] &,
			sortedSDSData
		];

		If[MatchQ[scanResult, {URLP, _File}],
			scanResult,
			{Null, Null}
		]
	];

	(* Return the output *)
	Which[
		(* Return the URL that we checked works *)
		MatchQ[outputOption, ValidatedURL],
		validatedURL,

		(* Return the path to the downloaded pdf *)
		MatchQ[outputOption, TemporaryFile],
		downloadedPDF,

		(* If user wants to open the SDS, use SystemOpen if we have one *)
		MatchQ[outputOption, Open] && !MatchQ[downloadedPDF, Null],
		SystemOpen[downloadedPDF],

		(* Otherwise return Null if we didn't have an SDS *)
		MatchQ[outputOption, Open],
		Null,

		(* If the user wants a cloud file, upload the pdf and return the cloud file *)
		MatchQ[outputOption, CloudFile],
		UploadCloudFile[downloadedPDF],

		(* Fall back - we shouldn't get here. Return both *)
		True,
		{validatedURL, downloadedPDF}
	]
];



(* Internal memoized function to perform an SDS search request with Chemical Safety website *)
searchChemicalSafetySDS[myIdentifier: Alternatives[_String, CASNumberP]] := Module[
	{casNumberQ, httpRequest, httpResponse, parsedData},

	(* Determine if the input is a cas number or not *)
	casNumberQ = MatchQ[myIdentifier, CASNumberP];

	(* Assemble the http request for ChemicalSafety.com *)
	httpRequest = Module[{searchCriteria},

		(* List of parameters to search by - we'll search by name or by cas *)
		searchCriteria = If[casNumberQ,
			{"cas|" <> myIdentifier},
			{"name|" <> myIdentifier}
		];

		<|
			"URL" -> "https://chemicalsafety.com/sds1/sds_retriever.php?action=search",
			"Headers" -> Association[
				"ContentType" -> "application/json"
			],
			"Method" -> "POST",
			"Body" -> <|
				"IsContains" -> False,
				"IncludeSynonyms" -> False,
				"SearchSdsServer" -> False,
				"HostName" -> "sfs website",
				"Remote" -> "209.105.189.138",
				"Bee" -> "stevia",
				"Action" -> "search",
				"Criteria" -> searchCriteria
			|>
		|>
	];

	(* Perform the request *)
	httpResponse = HTTPRequestJSON[httpRequest];

	(* Return $Failed if not successful *)
	If[!MatchQ[httpResponse, _Association],
		Return[$Failed]
	];

	(* Parse the response *)
	parsedData = Module[
		{columnNames, rowData, associationData},

		(* Lookup and sanitize the column names *)
		columnNames = Lookup[Lookup[httpResponse, "cols"], "prompt"] /. <|
			"MANUFACTURER" -> "Manufacturer",
			"HTTP REF" -> "URL"
		|>;

		rowData = Lookup[httpResponse, "rows"];

		(* Convert each entry into an association *)
		associationData = Map[
			AssociationThread[columnNames -> #] &,
			rowData
		];

		(* Drop keys we don't want *)
		KeyDrop[associationData, {"HASMSDS", "HPHRASES_IDS", "SDSSERVER"}]
	];

	(* Memoize result if successful *)
	If[MatchQ[parsedData, {_Association...}],
		(
			If[!MemberQ[$Memoization, ExternalUpload`Private`searchChemicalSafetySDS],
				AppendTo[$Memoization, ExternalUpload`Private`searchChemicalSafetySDS]
			];
			Set[searchChemicalSafetySDS[myIdentifier], parsedData]
		)
	];

	(* Return the data *)
	parsedData
];


(* ::Subsubsection::Closed:: *)
(* File/CloudFile Handling *)


(* Internal memoized function to perform HTTPRequest when validating URLs *)
downloadAndValidateURL[url_String, fileNameIdentifier : _String, fileValidationFunction : _Function] := Module[
	{filePath, downloadedFile, validFileQ, returnValue},

	(* Location to (attempt to) download file to *)
	filePath = Module[
		{splitFileName, fileNameIdentifierStem, fileNameIdentifierExtension},

		(* Split off the extension from the file name *)
		splitFileName = StringSplit[fileNameIdentifier, "."];

		(* Parse out the extension from the rest of the name *)
		{fileNameIdentifierStem, fileNameIdentifierExtension} = If[EqualQ[Length[splitFileName], 1],
			{First[splitFileName], ""},
			{StringRiffle[Most[splitFileName], "."], Last[splitFileName]}
		];

		(* Assemble the file name *)
		FileNameJoin[{$TemporaryDirectory, ToString[Unique[fileNameIdentifierStem]] <> "." <> fileNameIdentifierExtension}]
	];

	(* Attempt to download the file *)
	downloadedFile = URLDownload[
		HTTPRequest[url,
			<|
				Method -> "GET",
				"Headers" -> {
					"accept-language" -> "en-US,en;q=0.9",
					"user-agent" -> "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36"
				}
			|>
		],
		filePath,
		TimeConstraint -> 3
	];

	(* Check if we got something *)
	validFileQ = Quiet[Check[
		TrueQ[fileValidationFunction[downloadedFile]],
		False
	]];

	(* We'll return either the file or $Failed *)
	returnValue = If[validFileQ,
		downloadedFile,
		$Failed
	];

	(* Memoize the result - even if failed *)
	If[!MemberQ[$Memoization, ExternalUpload`Private`downloadAndValidateURL],
		AppendTo[$Memoization, ExternalUpload`Private`downloadAndValidateURL]
	];
	Set[downloadAndValidateURL[url, fileNameIdentifier, fileValidationFunction], returnValue];

	(* Return the result *)
	returnValue
];

(* Handy wrappers to prevent divergence when called from multiple places and ensure we hit memoization *)
(* SDS *)
downloadAndValidateSDSURL[url : URLP] := downloadAndValidateURL[
	url,
	"sds.pdf",
	And[
		(* First check the file format - FileFormat isn't outfoxed by incorrect extensions- we may have downloaded HTML to a .pdf filename but this will show it's still HTML *)
		MatchQ[FileFormat[#], "PDF"],

		(* If the file truly appears to be PDF format, import it and check we can read some text *)
		Quiet[Check[
			StringContainsQ[Import[#, "Plaintext"], Alternatives["safety data sheet", CaseSensitive["CAS"], CaseSensitive["GHS"]], IgnoreCase -> True],
			False
		]]
	]&
];

(* Structure Image File *)
downloadAndValidateStructureImageFileURL[url : URLP] := downloadAndValidateURL[
	url,
	"structureimage.png",
	(* Check that we get an image when we import the file *)
	ImageQ[Import[#]]&
];

(* Structure File *)
downloadAndValidateStructureFileURL[url : URLP] := downloadAndValidateURL[
	url,
	"structure.sdf",
	(* Check that we get a valid molecule when we import the structure file *)
	MatchQ[Import[#], {_Molecule..}]&
];


(* Internal memoized function for validating local files *)
validateLocalFile[filePath : FilePathP, fileValidationFunction : _Function] := Module[
	{validFileQ, returnValue},

	(* Validate the file using the supplied function *)
	validFileQ = Quiet[Check[
		TrueQ[fileValidationFunction[filePath]],
		False
	]];

	(* We'll return either the file or $Failed *)
	returnValue = If[validFileQ,
		File[filePath],
		$Failed
	];

	(* Memoize the result - even if failed *)
	If[!MemberQ[$Memoization, ExternalUpload`Private`validateLocalFile],
		AppendTo[$Memoization, ExternalUpload`Private`validateLocalFile]
	];
	Set[validateLocalFile[filePath, fileValidationFunction], returnValue];

	(* Return the result *)
	returnValue
];

(* Handy wrappers to prevent divergence when called from multiple places and ensure we hit memoization *)
(* Structure File *)
validateStructureFilePath[filePath : FilePathP] := validateLocalFile[
	filePath,
	MatchQ[Import[#], {_Molecule..}] &
];

(* Structure Image File *)
validateStructureImageFilePath[filePath : FilePathP] := validateLocalFile[
	filePath,
	ImageQ[Import[#]] &
];


(* Helper for uploading a file to AWS and returning constellation cloud file packet. Memoized to prevent re-uploading *)
pathToCloudFilePacket[file : Alternatives[FilePathP, _File]] := (pathToCloudFilePacket[file] = Module[
	{},

	(* Register memoization *)
	If[!MemberQ[$Memoization, ExternalUpload`Private`pathToCloudFilePacket],
		AppendTo[$Memoization, ExternalUpload`Private`pathToCloudFilePacket]
	];

	(* Upload the file to AWS and return the un-uploaded constellation packet *)
	UploadCloudFile[file, Upload -> False]
]);


(* ::Subsection::Closed:: *)
(*Shared Option Sets*)


(* ::Subsubsection::Closed:: *)
(*IdentityModelHealthAndSafetyOptions*)


DefineOptionSet[
	IdentityModelHealthAndSafetyOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> Radioactive,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule emit substantial ionizing radiation.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Ventilated,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule must be handled in a ventilated enclosures.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Pungent,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule must be handled in a ventilated enclosures.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Flammable,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule are easily set aflame under standard conditions.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Acid,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if this molecule forms strongly acidic solutions when dissolved in water (typically pKa <= 4) and requires secondary containment during storage.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Base,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if this molecule forms strongly basic solutions when dissolved in water (typically pKaH >= 11) and requires secondary containment during storage.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Pyrophoric,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule can ignite spontaneously upon exposure to air.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> WaterReactive,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule react spontaneously upon exposure to water.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Fuming,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule emit fumes spontaneously when exposed to air.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> HazardousBan,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule are currently banned from usage in the ECL because the facility isn't yet equiped to handle them.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> ExpirationHazard,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule become hazardous once they are expired and must be automatically disposed of when they pass their expiration date.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> ParticularlyHazardousSubstance,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if exposure to this substance has the potential to cause serious and lasting harm. A substance is considered particularly harmful if it is categorized by any of the following GHS classifications (as found on a MSDS): Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350).",
					Category -> "Health & Safety"
				},
				{
					OptionName -> DrainDisposal,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule may be safely disposed down a standard drain.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> MSDSRequired,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if an MSDS is applicable for this model.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> MSDSFile,
					Default -> Null,
					AllowNull -> True,
					Widget -> Alternatives[
						Widget[Type -> String, Pattern :> URLP, Size -> Line],
						Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]], PatternTooltip -> "A cloud file stored on Constellation that ends in .PDF."]
					],
					Description -> "URL of the MSDS (Materials Safety Data Sheet) PDF file.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> NFPA,
					Default -> Null,
					AllowNull -> True,
					Widget -> {
						"Health" -> Widget[Type -> Enumeration, Pattern :> 0 | 1 | 2 | 3 | 4],
						"Flammability" -> Widget[Type -> Enumeration, Pattern :> 0 | 1 | 2 | 3 | 4],
						"Reactivity" -> Widget[Type -> Enumeration, Pattern :> 0 | 1 | 2 | 3 | 4],
						"Special" -> Alternatives[
							Widget[
								Type -> MultiSelect,
								Pattern :> DuplicateFreeListableP[Oxidizer | WaterReactive | Aspyxiant | Corrosive | Acid | Bio | Poisonous | Radioactive | Cryogenic | Null]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[{}]
							]
						]
					},
					Description -> "The National Fire Protection Association (NFPA) 704 hazard diamond classification for the substance.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> DOTHazardClass,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> DOTHazardClassP],
					Description -> "The Department of Transportation hazard classification of the substance.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> BiosafetyLevel,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BiosafetyLevelP],
					Description -> "The Biosafety classification of the substance.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> DoubleGloveRequired,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if working with this substance required wearing two pairs of gloves.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> LightSensitive,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Determines if the sample reacts or degrades in the presence of light and should be stored in the dark to avoid exposure.",
					Category -> "Storage Information"
				},

				{
					OptionName -> IncompatibleMaterials,
					Default -> Null,
					AllowNull -> True,
					Widget -> With[{insertMe=Flatten[None | MaterialP]}, Adder[Widget[Type -> Enumeration, Pattern :> insertMe]]],
					Description -> "A list of materials that would be damaged if wetted by this model.",
					Category -> "Compatibility"
				},
				{
					OptionName -> LiquidHandlerIncompatible,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule cannot be reliably aspirated or dispensed on an automated liquid handling robot.",
					Category -> "Compatibility"
				},
				{
					OptionName -> PipettingMethod,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Method, Pipetting]]],
					Description -> "The pipetting parameters used to manipulate pure samples of this model.",
					Category -> "Compatibility"
				},
				{
					OptionName -> UltrasonicIncompatible,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule cannot be performed via the ultrasonic distance method due to vapors interfering with the reading.",
					Category -> "Compatibility"
				}
			]
		}
];


(* ::Subsubsection::Closed:: *)
(*ModelSampleHealthAndSafetyOptions*)


DefineOptionSet[
	ModelSampleHealthAndSafetyOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> State,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Solid, Liquid, Gas]],
					Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> SampleHandling,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> SampleHandlingP],
					Description -> "The method by which this sample should be manipulated in the lab when transfers out of the sample are requested.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CellType,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CellTypeP],
					Description -> "The primary types of cells that are contained within this sample.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CultureAdhesion,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CultureAdhesionP],
					Description -> "The default type of cell culture (adherent or suspension) that should be performed when growing these cells. If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Sterile,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates that this model of sample arrives free of both microbial contamination and any microbial cell samples from the manufacturer, or is prepared free of both microbial contamination and any microbial cell samples by employing autoclaving, sterile filtration, or mixing exclusively sterile components with aseptic techniques during the course of experiments, as well as during sample storage and handling.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> AsepticHandling,
					Default -> Null,
					Description -> "Indicates if aseptic techniques are expected for handling this model of sample. Aseptic techniques include sanitization, autoclaving, sterile filtration, mixing exclusively sterile components, and transferring in a biosafety cabinet during experimentation and storage.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> DefaultStorageCondition,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[StorageCondition]]],
					Description -> "The condition in which samples of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given sample.",
					Category -> "Storage Information"
				},
				{
					OptionName -> Expires,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if samples of this model expire after a given amount of time.",
					Category -> "Storage Information"
				},
				{
					OptionName -> ShelfLife,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Day], Units -> {1, {Day, {Day, Month, Year}}}],
					Description -> "The length of time after DateCreated that samples of this model are recommended for use before they should be discarded.",
					Category -> "Storage Information"
				},
				{
					OptionName -> UnsealedShelfLife,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Day], Units -> {1, {Day, {Day, Month, Year}}}],
					Description -> "The length of time after DateUnsealed that samples of this model are recommended for use before they should be discarded.",
					Category -> "Storage Information"
				},
				{
					OptionName -> TransportTemperature,
					Default -> Null,
					Description -> "The temperature that samples of this model should be incubated at while transported between instruments during experimentation.",
					AllowNull -> True,
					Category -> "Storage Information",
					Widget -> Widget[
						Type -> Quantity,
						Pattern :> Alternatives[RangeP[-86*Celsius, 10*Celsius], RangeP[30*Celsius, 105*Celsius]],
						Units -> Celsius
					]
				},
				{
					OptionName -> Anhydrous,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if this sample does not contain water.",
					Category -> "Health & Safety"
				}
			],
			IdentityModelHealthAndSafetyOptions
		}
];


(* ::Subsubsection::Closed:: *)
(*ObjectSampleHealthAndSafetyOptions*)


DefineOptionSet[
	ObjectSampleHealthAndSafetyOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> State,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Solid, Liquid, Gas]],
					Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> SampleHandling,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> SampleHandlingP],
					Description -> "The method by which this sample should be manipulated in the lab when transfers out of the sample are requested.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CellType,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CellTypeP],
					Description -> "The primary types of cells that are contained within this sample.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CultureAdhesion,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CultureAdhesionP],
					Description -> "The type of cell culture that is currently being performed to grow these cells.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Sterile,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates that this sample arrives free of both microbial contamination and any microbial cell samples from the manufacturer, or is prepared free of both microbial contamination and any microbial cell samples by employing autoclaving, sterile filtration, or mixing exclusively sterile components with aseptic techniques during experimentation and storage.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> StorageCondition,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[StorageCondition]], OpenPaths -> {{Object[Catalog, "Root"], "Storage Conditions"}}],
					Description -> "The condition in which this sample gets stored in when not used by an experiment.",
					Category -> "Storage Information"
				},
				{
					OptionName -> Expires,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if samples of this model expire after a given amount of time.",
					Category -> "Storage Information"
				},
				{
					OptionName -> ShelfLife,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Day], Units -> {1, {Day, {Day, Month, Year}}}],
					Description -> "The length of time after DateCreated that samples of this model are recommended for use before they should be discarded.",
					Category -> "Storage Information"
				},
				{
					OptionName -> UnsealedShelfLife,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Day], Units -> {1, {Day, {Day, Month, Year}}}],
					Description -> "The length of time after DateUnsealed that samples of this model are recommended for use before they should be discarded.",
					Category -> "Storage Information"
				},
				{
					OptionName -> TransportTemperature,
					Default -> Null,
					Description -> "The temperature that this sample should be heated or refrigerated while transported between instruments during experimentation.",
					AllowNull -> True,
					Category -> "Storage Information",
					Widget -> Widget[
						Type->Quantity,
						Pattern:>Alternatives[RangeP[-86*Celsius, 10*Celsius], RangeP[30*Celsius, 105*Celsius]],
						Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}
					]
				},
				{
					OptionName -> TransferTemperature,
					Default -> Null,
					Description -> "The temperature that this sample should be at before any transfers using this sample occur.",
					AllowNull -> True,
					Category -> "Storage Information",
					Widget -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[4 Celsius, 90 Celsius],
						Units -> Celsius
					]
				},
				{
					OptionName -> Anhydrous,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if this sample does not contain water.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> ExpirationDate,
					Default -> Null,
					Description -> "Date after which this sample is considered expired and users will be warned about using it in protocols.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Date,
						Pattern :> _?DateObjectQ,
						TimeSelector -> True
					]
				},
				{
					OptionName -> AutoclaveUnsafe,
					Default -> Null,
					Description -> "Indicates if this sample cannot be safely autoclaved.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> InertHandling,
					Default -> Null,
					Description -> "Indicates if this sample must be handled in a glove box.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> AsepticHandling,
					Default -> Null,
					Description -> "Indicates if aseptic techniques are followed for this sample. Aseptic techniques include sanitization, autoclaving, sterile filtration, mixing exclusively sterile components, and transferring in a biosafety cabinet during experimentation and storage.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> GloveBoxIncompatible,
					Default -> Null,
					Description -> "Indicates if this sample cannot be used inside of the glove box due high volatility and/or detrimental reactivity with the catalyst in the glove box that is used to remove traces of water and oxygen. Sulfur and sulfur compounds (such as H2S, RSH, COS, SO2, SO3), halides, halogen (Freon), alcohols, hydrazine, phosphene, arsine, arsenate, mercury, and saturation with water may deactivate the catalyst.",
					AllowNull -> True,
					Category -> "Compatibility",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> GloveBoxBlowerIncompatible,
					Default -> Null,
					Description -> "Indicates that the glove box blower must be turned off to prevent damage to the catalyst in the glove box that is used to remove traces of water and oxygen, when manipulating this sample inside of the glove box.",
					AllowNull -> True,
					Category -> "Compatibility",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> RNaseFree,
					Default -> Null,
					Description -> "Indicates that this sample is free of any RNases.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> NucleicAcidFree,
					Default -> Null,
					Description -> "Indicates if this sample is presently considered to be not contaminated with DNA and RNA.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> PyrogenFree,
					Default -> Null,
					Description -> "Indicates if this sample is presently considered to be not contaminated with endotoxin.",
					AllowNull -> True,
					Category -> "Health & Safety",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				},
				{
					OptionName -> AsepticTransportContainerType,
					Default -> Null,
					Description -> "Indicates how this sample is contained in an aseptic barrier and if it needs to be unbagged before being used in a protocol, maintenance, or qualification.",
					AllowNull -> True,
					Category -> "Storage Information",
					Widget -> Widget[
						Type -> Enumeration,
						Pattern :> AsepticTransportContainerTypeP
					]
				}
			],
			IdentityModelHealthAndSafetyOptions
		}
];


(* ::Subsubsection::Closed:: *)
(*ExternalUploadHiddenOptions*)


DefineOptionSet[
	ExternalUploadHiddenOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> Cache,
					Default -> {},
					AllowNull -> False,
					Widget -> Widget[Type -> Expression, Pattern :> _List, Size -> Line],
					Description -> "The download cache.",
					Category -> "Hidden"
				},
				{
					OptionName -> Upload,
					Default -> True,
					AllowNull -> False,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if the database changes resulting from this function should be made immediately or if upload packets should be returned.",
					Category -> "Hidden"
				},
				{
					OptionName -> Output,
					Default -> Result,
					AllowNull -> True,
					Widget -> Alternatives[
						Widget[Type -> Enumeration, Pattern :> CommandBuilderOutputP],
						Adder[Widget[Type -> Enumeration, Pattern :> CommandBuilderOutputP]]
					],
					Description -> "Indicate what the function should return.",
					Category -> "Hidden"
				}
			]
		}
];


(* ::Subsubsection::Closed:: *)
(*CellOptions*)


DefineOptionSet[
	CellOptions :>
		{
			IndexMatching[
				IndexMatchingInput -> "Input Data",
				{
					OptionName -> CellType,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CellTypeP],
					Description -> "The primary types of cells that are contained within this sample.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> CultureAdhesion,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> CultureAdhesionP],
					Description -> "The default type of cell culture (adherent or suspension) that should be performed when growing these cells. If a cell line can be cultured via an adherent or suspension culture, this is set to the most common cell culture type for the cell line.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Name,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
					Description -> "The name of the identity model.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> DefaultSampleModel,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
					Description -> "Specifies the model of sample that will be used if this model is specified to be used in an experiment.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Synonyms,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
					Description -> "List of possible alternative names this model goes by.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> ATCCID,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word],
					Description -> "The American Type Culture Collection (ATCC) identifying number of this cell line.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Species,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Species]]],
					Description -> "The species that this cell was originally cultivated from.",
					Category -> "Organizational Information"
				},

				{
					OptionName -> Diameter,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Micro * Meter], Units -> (Micro * Meter)],
					Description -> "The average diameter of an individual cell.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> DoublingTime,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Hour], Units -> {1, {Hour, {Day, Hour, Minute}}}],
					Description -> "The average period of time it takes for a population of these cells to double in number during their exponential growth phase in its preferred media.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Viruses,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Virus]]]],
					Description -> "Viruses that are known to be carried by this cell line.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> cDNAs,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, cDNA]]]],
					Description -> "The cDNA models that this cell line produces.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Transcripts,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, Transcript]]]],
					Description -> "The transcript models that this cell line produces.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> Lysates,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Lysate]]]],
					Description -> "The model of the contents of this cell when lysed.",
					Category -> "Organizational Information"
				},
				{
					OptionName -> PreferredLiquidMedia,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample,Media]]],
					Description -> "The recommended liquid media for the growth of the cells.",
					Category -> "General"
				},
				{
					OptionName -> PreferredSolidMedia,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample,Media]]],
					Description -> "The recommended solid media for the growth of the cells.",
					Category -> "General"
				},
				{
					OptionName -> PreferredFreezingMedia,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
					Description -> "The recommended media for cryopreservation of these cells, often containing additives that protect the cells during freezing.",
					Category -> "General"
				},
				{
					OptionName -> ThawCellsMethod,
					Default -> Null,
					AllowNull -> True,
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Method, ThawCells]]],
					Description -> "The default method by which to thaw cryovials of this cell line.",
					Category -> "General"
				},
				{
					OptionName -> DetectionLabels,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]]],
					Description -> "Indicate the tags (e.g. GFP, Alexa Fluor 488) that the cell contains, which can indicate the presence and amount of particular features or molecules in the cell. Allowed Model[Molecule] as DetectionLabels must have DetectionLabel->True.",
					Category -> "Physical Properties"
				},
				{
					OptionName -> PreferredColonyHandlerHeadCassettes,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Part,ColonyHandlerHeadCassette]]]],
					Description -> "The ColonyHandlerHeadCassettes that are designed to pick this cell type from a solid gel.",
					Category -> "General"
				},
				{
					OptionName -> FluorescentExcitationWavelength,
					Default -> Null,
					AllowNull -> True,
					Widget -> {
						"Minimum Wavelength" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Nanometer], Units -> Nanometer],
						"Maximum Wavelength" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Nanometer], Units -> Nanometer]
					},
					Description -> "The range of wavelengths that causes the cell to be in an excited state.",
					Category -> "General"
				},
				{
					OptionName -> FluorescentEmissionWavelength,
					Default -> Null,
					AllowNull -> True,
					Widget -> {
						"Minimum Wavelength" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Nanometer], Units -> Nanometer],
						"Maximum Wavelength" -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Nanometer], Units -> Nanometer]
					},
					Description -> "The detectable range of wavelengths this cell will emit through fluorescence after being put into an excited state.",
					Category -> "General"
				},
				{
					OptionName -> StandardCurves,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Analysis,StandardCurve]]]],
					Description -> "The standard curves used to convert between a combination of cell concentration units, Cell/Milliliter, OD600, CFU/Milliliter, RelativeNephelometricUnit, NephelometricTurbidityUnit, FormazinTurbidityUnit, and FormazinNephelometricUnit. If there exist multiple standard curves between the same units, the more recently generated curve will be used in calculations.",
					Category -> "General"
				},
				{
					OptionName -> StandardCurveProtocols,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Alternatives[Widget[Type -> Object, Pattern :> ObjectP[{Object[Protocol,Nephelometry], Object[Protocol,AbsorbanceIntensity]}]],Widget[Type -> Expression, Pattern :> Null, Size -> Line]]],
					Description -> "The protocol that generated the data used to determine the standard curve.",
					Category -> "General"
				}
			],

			IdentityModelHealthAndSafetyOptions,

			IndexMatching[
				IndexMatchingInput -> "Input Data",
				(* Overwrite some of the safety options with different defaults. *)
				{
					OptionName -> State,
					Default -> Liquid,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Solid, Liquid, Gas]],
					Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
					Category -> "Physical Properties"
				},
				{
					OptionName -> MSDSRequired,
					Default -> True,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if an MSDS is applicable for this model.",
					Category -> "Health & Safety"
				},
				{
					OptionName -> Flammable,
					Default -> False,
					AllowNull -> True,
					Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
					Description -> "Indicates if pure samples of this molecule are easily set aflame under standard conditions.",
					Category -> "Health & Safety"
				},

				{
					OptionName -> ReferenceImages,
					Default -> Null,
					AllowNull -> True,
					Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data]]]],
					Description -> "Reference microscope images exemplifying the typical appearance of this cell line.",
					Category -> "Experimental Results"
				}
			],

			ExternalUploadHiddenOptions
		}
];


(* ::Subsection::Closed:: *)
(*API Helpers*)


(* ::Subsubsection::Closed:: *)
(*retryConnection*)


Warning::APIConnection="A connection to the scraping API was not able to be formed. Please try re-running this function again and check your firewall settings or any input URLs (if applicable).";

(* Given a command, retries numberOfRetries times if it gets $Failed. *)
retryConnection[command_, numberOfRetries_Integer]:=Module[{i, commandResult},
	(* Keep retrying our command until we get a non $Failed result. *)
	(* Sorry functional programming gods. *)
	For[i=1, i <= numberOfRetries, i++,
		commandResult=Evaluate[command];

		If[!SameQ[commandResult, $Failed],
			Return[commandResult];
		];

		Pause[2^i];
	];

	(* We tried multiple times but get $Failed every time. Return $Failed. *)
	Message[Warning::APIConnection];
	$Failed
];

SetAttributes[retryConnection, HoldAll];


(* ::Subsubsection::Closed:: *)
(*resolveTemplateOptions*)


DefineOptions[resolveTemplateOptions,
	Options :> {
		{Exclude -> {}, {(_Symbol)..}, "List of option names that should not be replaced with values from the template."}
	}
];


resolveTemplateOptions[
	funcName:_Symbol,
	tempObj:Null,
	userOps_List,
	safeOps_List,
	ops:OptionsPattern[resolveTemplateOptions]
]:=safeOps;
(* Emergency Demo-related Fix. To be compressed later *)
resolveTemplateOptions[
	UploadSampleModel,
	tempObj:PacketP[],
	userOps_List,
	safeOps_List,
	ops:OptionsPattern[resolveTemplateOptions]
]:=Module[
	{listedOps, nonReusableFields, userOpsSpecified, defaultedOps, templateDefaultedRules,
		rulesReplaceEmptyLists, rulesWithoutEmptyList, replacedFormsSafeOps, replacedSafeOps, opsWithpKa, opsWithNFPA, finalizedOptions},

	(* Make sure we are dealing with lists of options *)
	listedOps=ToList[ops];

	(* A list of fields that should never be taken as*)
	nonReusableFields=OptionDefault[OptionValue[Exclude]];

	(* Determine which options the user specified *)
	userOpsSpecified=First /@ ToList[userOps];

	(* Determine which ops to pull from the template *)
	defaultedOps=DeleteCases[
		First /@ ToList[safeOps],
		Alternatives @@ Join[userOpsSpecified, ToList[nonReusableFields]]
	];

	(* Create a list of rules where defaulted options pull their value from the template object *)
	templateDefaultedRules=ReplaceAll[
		(# -> Lookup[tempObj, #])& /@ defaultedOps,
		xLink:LinkP[] :> Most[xLink](* Trim the IDs from any links discovered *)
	];

	(* Replace the multiple fields that get {} from the object with Null values instead *)
	rulesReplaceEmptyLists=If[
		MatchQ[Lookup[templateDefaultedRules, #], {}],
		# -> Null,
		# -> Lookup[templateDefaultedRules, #]
	]& /@ {
		AlternativeForms,
		pKa,
		PreferredMALDIMatrix,
		IncompatibleMaterials
	};

	rulesWithoutEmptyList=ReplaceRule[
		templateDefaultedRules,
		rulesReplaceEmptyLists
	];

	replacedFormsSafeOps=If[
		MatchQ[
			Lookup[rulesWithoutEmptyList, AlternativeForms],
			{ObjectP[Model[Sample]]..}
		],
		ReplaceRule[
			rulesWithoutEmptyList,
			AlternativeForms -> Append[
				Lookup[rulesWithoutEmptyList, AlternativeForms],
				Link[tempObj, AlternativeForms]
			]
		],
		ReplaceRule[
			rulesWithoutEmptyList,
			AlternativeForms -> {Link[tempObj, AlternativeForms]}
		]
	];

	(* pKa needs to be de-listed. *)
	opsWithpKa=ReplaceRule[
		replacedFormsSafeOps,
		pKa -> First[tempObj[pKa], Null]
	];

	(* NFPA is in a different format for easier command builderizing. *)
	(* If NFPA is specified, make it in the correct form. *)
	opsWithNFPA=If[MatchQ[tempObj[NFPA], NFPAP],
		ReplaceRule[
			opsWithpKa,
			NFPA -> {Lookup[tempObj[NFPA], Health], Lookup[tempObj[NFPA], Flammability], Lookup[tempObj[NFPA], Reactivity], Lookup[tempObj[NFPA], Special]}
		],
		ReplaceRule[
			opsWithpKa,
			NFPA -> Null
		]
	];

	(* Replace safe ops with rules pulled from the template obj*)
	replacedSafeOps=ReplaceRule[
		safeOps,
		opsWithNFPA
	];

	(* Make sure that we don't overwrite any user options. *)
	finalizedOptions=Normal[Join[Association[replacedSafeOps], Association[ToList[userOps]]]];

	(* Pass the final list through safe ops, and convert any links found into Links without IDs  *)
	Quiet[SafeOptions[UploadSampleModel, finalizedOptions]]
];

resolveTemplateOptions[
	funcName:_Symbol,
	tempObj:PacketP[],
	userOps_List,
	safeOps_List,
	ops:OptionsPattern[resolveTemplateOptions]
]:=Module[
	{listedOps, nonReusableFields, userOpsSpecified, defaultedOps, templateDefaultedRules, replacedSafeOps},

	(* Make sure we are dealing with lists of options *)
	listedOps=ToList[ops];

	(* A list of fields that should never be taken as*)
	nonReusableFields=OptionDefault[OptionValue[Exclude]];

	(* Determine which options the user specified *)
	userOpsSpecified=First /@ ToList[userOps];

	(* Determine which ops to pull from the template *)
	defaultedOps=DeleteCases[
		First /@ ToList[safeOps],
		Alternatives @@ Join[userOpsSpecified, ToList[nonReusableFields]]
	];

	(* Create a list of rules where defaulted options pull their value from the template object *)
	templateDefaultedRules=ReplaceAll[
		(# -> Lookup[tempObj, #])& /@ defaultedOps,
		xLink:LinkP[] :> Most[xLink](* Trim the IDs from any links discovered *)
	];

	(* Replace safe ops with rules pulled from the template obj*)
	replacedSafeOps=ReplaceRule[
		safeOps,
		templateDefaultedRules
	];

	(* Pass the final list through safe ops, and convert any links found into Links without IDs  *)
	SafeOptions[funcName, replacedSafeOps]
];


(* ::Subsection::Closed:: *)
(*Hold Helper Functions (Stolen from Widgets)*)


(* Given f and Hold[g[x]], return Hold[f[g[x]]] without evaluating anything. *)
holdComposition[f_, Hold[expr__]]:=Hold[f[expr]];
SetAttributes[holdComposition, HoldAll];


(* Given Hold[f[a[x],b[x],..]], returns {Hold[a[x]],Hold[b[x]]. *)
holdCompositionSingleton[heldItem_Hold]:=Module[{lengthOfHolds},
	(* Get the number of items inside of the f[...] head. *)
	lengthOfHolds=Length[Extract[heldItem, {1}]];

	(* Extract each item inside of the f[...] head and wrap it in a hold. *)
	Extract[heldItem, {1, #}, Hold]& /@ Range[lengthOfHolds]
];
SetAttributes[holdCompositionSingleton, HoldAll];


(* Given f and {Hold[a[x]], Hold[b[x]]..}, returns Hold[f[a[x],b[x]..]]. *)
holdCompositionList[f_, {helds___Hold}]:=Module[{joinedHelds},
	(* Join the held heads. *)
	joinedHelds=Join[helds];

	(* Swap the outter most hold with f. Then hold the result. *)
	With[{insertMe=joinedHelds}, holdComposition[f, insertMe]]
];
SetAttributes[holdCompositionList, HoldAll];


(* ::Subsection::Closed:: *)
(*Packet Formatting*)

(* ::Subsubsection::Closed:: *)
(*generateChangePacket*)

DefineOptions[generateChangePacket,
	Options :> {
		{ExistingPacket -> <||>, _Association, "The current packet of the object as in Constellation."},
		{Output -> Packet, ListableP[Alternatives[Packet, IrrelevantFields]], "Output of the function. Packet indicates the change packet, while IrrelavantFields is a list of options that exists in the resolved option input, but doesn't exist as a field of the target type."},
		{RemoveNull -> True, BooleanP, "Indicate if options which values are Null, {} or Automatic should be removed and not included in the final change packet."},
		{Append -> False, Alternatives[True, False, {_Symbol...}], "Indicates if multiple fields will be appended or replaced in the change packet. In addition to a single Boolean, one can also list fields that should be appended, in that case all other multiple fields will be replaced."}
	}
];

(* Given a type and a list of resolved options, formats the options into a change packet. Use a Boolean to indicate whether all multiple fields will be Appended (True) or Replaced (False). *)
generateChangePacket[myType_, resolvedOptions:{(_Rule| _RuleDelayed)...}, appendInput:BooleanP, myOptions:OptionsPattern[]]:= If[appendInput,
	generateChangePacket[myType, resolvedOptions, ReplaceRule[ToList[myOptions], {Append -> True}]],
	generateChangePacket[myType, resolvedOptions, ReplaceRule[ToList[myOptions], {Append -> False}]]
];

(* main overload: Given a type and a list of resolved options, formats the options into a change packet. *)
generateChangePacket[myType_, resolvedOptions:{(_Rule| _RuleDelayed)...}, myOptions:OptionsPattern[]]:=Module[
	{
		existingPacket, fields, convertedPacket, diffedPacket, output, genericOptions, irrelevantFields,
		packet, resolvedOptionsNoNull, fieldDefinitions, safeOps, removeNull, fieldsToAppend
	},
	(* get the options *)
	safeOps = SafeOptions[generateChangePacket, ToList[myOptions]];
	{existingPacket, output, removeNull, fieldsToAppend} = Lookup[safeOps, {ExistingPacket, Output, RemoveNull, Append}];

	(* Get the definition of this type. *)
	fieldDefinitions = Lookup[LookupTypeDefinition[myType], Fields];

	(* Remove entries from ResolvedOptions which the value are Null, Automatic, {} or a list of these, if we have RemoveNull -> True *)
	resolvedOptionsNoNull = If[TrueQ[removeNull],
		Select[resolvedOptions, !MatchQ[Values[#], ListableP[(Automatic | Null | {})]]&],
		resolvedOptions
	];

	(* Convert the field definition into an association *)
	fields = Association[fieldDefinitions];

	(* For each of our options, see if it exists as a field of the same name in the object. *)
	convertedPacket = Association@KeyValueMap[
		Function[{optionSymbol, optionValue},
			(* If this option doesn't exist as a field, do not include it in the change packet. *)
			If[!KeyExistsQ[fields, optionSymbol],
				Nothing,
				(* Otherwise, fetch the field definition and do some modifications on the Key and Values *)
				Module[{fieldDefinition, formattedOptionSymbol, formattedOptionValue},
					(* Get the information about this specific field. *)
					fieldDefinition = Lookup[fields, optionSymbol];
					(* Format our option symbol. *)
					(*If the option symbol is in the Append option, or Append -> True, switch the multiple field options to Append, otherwise Replace as usual*)
					formattedOptionSymbol=If[
						(TrueQ[fieldsToAppend] || MemberQ[ToList[fieldsToAppend], optionSymbol]),
						Switch[{Lookup[fieldDefinition, Format], optionSymbol},
							{Single, Notebook},
							Transfer[optionSymbol],
							{Single,_},
							optionSymbol,
							{Multiple,_},
							Append[optionSymbol]
						],
						Switch[{Lookup[fieldDefinition, Format], optionSymbol},
							{Single, Notebook},
							Transfer[optionSymbol],
							{Single,_},
							optionSymbol,
							{Multiple,_},
							Replace[optionSymbol]
						]
					];

					(* Call the helper to format the option value. The helper does the following things: *)
					(* 1. Wrap Link[] on objects for any link fields, including backlinks *)
					(* 2. For link fields relating to EmeraldCloudFile, if a local file path or url is provided, call UploadCloudFile to do the upload and replace field value with cloud file object *)
					(* 3. correctly format named multiple fields if the option value is index-multiple *)
					(* 4. feature 1 and 2 also applies to inner fields of named multiple or index multiple fields (e.g., first column of StoragePositions will get wrapped with Link[] *)
					(* 5. Performs any known custom conversions *)
					formattedOptionValue = formatFieldValue[myType, optionSymbol, optionValue, fieldDefinition];

					formattedOptionSymbol -> formattedOptionValue
				]
			]
		],
		Association@resolvedOptionsNoNull
	];

	(* Only include our key in our change packet if it is different than in our existing packet, if we have one. *)
	diffedPacket=If[MatchQ[existingPacket, <||>],
		convertedPacket,
		Association @@ KeyValueMap[
			Function[{key, value},
				Module[{strippedField},
					strippedField=(key /. {(Replace[field_]|Transfer[field_]) :> field});
					If[KeyExistsQ[existingPacket, strippedField] && MatchQ[Lookup[existingPacket, strippedField] /. {link_Link :> RemoveLinkID[link]}, value],
						(* Don't include the field *)
						Nothing,
						(* Otherwise, include the field. *)
						key -> value
					]
				]

			],
			convertedPacket
		]
	];

	(* Append the fields required to upload the object. *)
	packet = Join[
		diffedPacket,
		<|
			(* Only add Authors if it's in the type definition and it's not already in the resolved options list. *)
			If[KeyExistsQ[fields, Authors] && (!KeyExistsQ[resolvedOptionsNoNull, Authors]),
				Replace[Authors] -> {Link[$PersonID]},
				Nothing
			],
			(*more custom stuff that might pertain to specific upload functions*)
			(*Upload Column specific*)
			If[MemberQ[Keys@resolvedOptionsNoNull, ConnectorType],
				Switch[Lookup[resolvedOptionsNoNull, ConnectorType],
					FemaleFemale, Replace[Connectors] -> {{"Column Inlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Female}, {"Column Outlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Female}},
					FemaleMale, Replace[Connectors] -> {{"Column Inlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Female}, {"Column Outlet", Threaded, "10-32", 0.18 Inch, 0.18 Inch, Male}}
				],
				Nothing
			],
			(* If we're changing the Composition field, add a sample history card. *)
			(* Note: since SampleHistory has timestamp, we are not appending date (3rd column) of composition *)
			If[KeyExistsQ[diffedPacket, Replace[Composition] && !MatchQ[myType, TypeP[Model[Sample]]]],
				Append[SampleHistory] -> {
					DefinedComposition[<|
						Date -> Now,
						Composition -> Map[{#[[1]], #[[2]]}&,(Lookup[diffedPacket, Replace[Composition]] /. {link_Link :> Download[link, Object]})],
						ResponsibleParty -> Download[$PersonID, Object]
					|>]
				},
				Nothing
			]
		|>
	];

	(* Define a list of options that is normal to appear in resolved options but not fields *)
	genericOptions = {Upload, Cache, Simulation, Force, Output};
	(* Find irrelevant options that were specified *)
	irrelevantFields = Complement[Keys[resolvedOptionsNoNull], Join[Keys[fields], genericOptions]];

	output /. {Packet -> packet, IrrelevantFields -> irrelevantFields}

];

(* Define a helper to format the field value *)
formatFieldValue[objectType_, optionName_, optionValue_, fieldDefinition:{(_Rule | _RuleDelayed)..}] := Module[
	{format, class, relation, headers, preProcessedOptionValue, standardFieldValue},
	(* Look up the key field definitions *)
	{format, class, relation, headers} = Lookup[fieldDefinition, {Format, Class, Relation, Headers}, Null];

	(* Sanitize the option if required before standard processing *)
	(* Some options may be handled in partial form within SLL. This function fleshes them out into standard format *)
	(* A notable example is Object[Sample][Composition] which adds a Date column at upload time *)
	preProcessedOptionValue = preProcessOptionValue[objectType, optionName, optionValue];

	(* Format field values according to standard rules for the field type *)
	standardFieldValue = Which[
		(* For fields link to cloud file, if our field value is indeed EmeraldCloudFile, wrap that with Link[] *)
		MatchQ[class, Link] && MatchQ[relation, Object[EmeraldCloudFile]] && MatchQ[preProcessedOptionValue, ListableP[ObjectP[Object[EmeraldCloudFile]]]],
		Link[preProcessedOptionValue],

		(* For fields link to cloud file but our field value is not EmeraldCloudFile (most likely string, either local file path or url), replace that with UploadCloudFile *)
		MatchQ[class, Link] && MatchQ[relation, Object[EmeraldCloudFile]],
		Replace[
			preProcessedOptionValue,
			{
				(* If our string is a URL, then try and download it. Otherwise, pass directly to UploadCloudFile. *)
				(* TODO for now I just copied from the old code, but this is certainly not ideal. We should try to implement downloadAndValidateURL and validateLocalFile *)
				string_String :> If[MatchQ[string, URLP],
					With[{downloaded=Quiet[First[URLDownload[string]]]},
						If[MatchQ[downloaded, "ConnectionFailure"],
							Null,
							Link[UploadCloudFile[downloaded]]
						]
					],
					Link[Quiet[UploadCloudFile[string]]]
				]
			},
			{0, 1}
		],

		(* For other linked fields, we need to construct backlink as needed *)
		MatchQ[class, Link],
		Module[{relationsList, backlinkMap},
			(* Convert our Relation field into a list of relations. *)
			relationsList=If[MatchQ[relation, _Alternatives],
				List @@ relation,
				ToList[relation]
			];

			(* Build the type \[Rule] backlink mapping. *)
			backlinkMap=(
				If[!MatchQ[#, TypeP[]],
					obj:ObjectReferenceP[Head[#]] :> Link[obj, Sequence @@ #],
					obj:ObjectReferenceP[Head[#]] :> Link[obj]
				]
					&) /@ relationsList;

			(* Apply the backlink mapping. *)
			(preProcessedOptionValue /. {link_Link :> Download[link, Object]}) /. backlinkMap
		],

		(* For Index-multiple fields: divide the field definition by index, then recursively map the function to resolve field values *)
		MatchQ[class, _List] && MatchQ[headers, {_String..}],
		Module[{fieldPropertyKeys, fieldPropertyValues, indexLength, expandedFieldPropertyValues, expandedFieldDefinitions, expandedOptionValue, listedConvertedField},
			indexLength = Length[headers];
			(* Extract keys and values from field definition *)
			fieldPropertyKeys = Keys[fieldDefinition];
			fieldPropertyValues = Values[fieldDefinition];

			(* Expand the field definition to make it index-match to headers *)
			(* e.g., say original field definition is {Headers -> {"X", "Y"}, Description -> "xxx", Class -> {Link, Integer}}, *)
			(* We want {{Headers -> "X", Description -> "xxx", Class -> Link}, {Headers -> "Y", Description -> "xxx", Class -> Integer}} *)

			(* Form of this is {{"X", "Y"}, {"xxx", "xxx"}, {{Link, Integer}} *)
			expandedFieldPropertyValues = Map[
				If[MatchQ[#, _List] && Length[#] == indexLength,
					#,
					ConstantArray[#, indexLength]
				]&,
				fieldPropertyValues
			];

			expandedFieldDefinitions = Map[
				Function[{fieldPropertyValuesPerIndex},
					Normal[AssociationThread[fieldPropertyKeys, fieldPropertyValuesPerIndex], Association]
				],
				Transpose[expandedFieldPropertyValues]
			];

			(* Also expand the option value *)
			(* Option value should be a list of list, while the inner list index-match to headers *)
			expandedOptionValue = Which[
				(* If the length looks all good, make no change *)
				MatchQ[preProcessedOptionValue, {_List..}] && Length[First[preProcessedOptionValue]] == indexLength,
				preProcessedOptionValue,
				(* Otherwise, if the option value length itself matches index, most likely we simply need to wrap it with another layer of list *)
				MatchQ[preProcessedOptionValue, _List] && Length[preProcessedOptionValue] == indexLength,
				{preProcessedOptionValue},
				(* All other cases we have an error *)
				True,
				$Failed
			];

			(* If anything failing index-matching, return $Failed *)
			If[MatchQ[expandedOptionValue, $Failed],
				Return[$Failed, Module]
			];

			(* Now we have expanded our field definitions and values, call MapThread on the formatFieldValue function recursively *)
			listedConvertedField = Map[
				Function[{singleValues},
					MapThread[Function[{singleHeaderValue, singleHeaderDefinition},
						formatFieldValue[objectType, optionName, singleHeaderValue, singleHeaderDefinition]
					],
						{singleValues, expandedFieldDefinitions}
					]
				],
				expandedOptionValue
			];

			(* If the field format is single, convert back to a single value from list of lists *)
			Which[
				MatchQ[format, Single] && EqualQ[Length[listedConvertedField], 1],
				First[listedConvertedField],

				(* Throw an error if it's a single and we got multiple entries *)
				MatchQ[format, Single],
				$Failed,

				(* No change if it's a multiple *)
				True,
				listedConvertedField
			]
		],

		(* For named-multiple fields: do a similar treatment as index-multiple *)
		MatchQ[class, _List] && MatchQ[headers, {_Rule..}],
		Module[
			{
				indexLength, fieldPropertyKeys, fieldPropertyValues, expandedFieldPropertyValues, expandedFieldDefinitions,
				headerKeys, expandedOptionValue, indexMultipleFieldValue, listedConvertedField
			},
			indexLength = Length[headers];
			(* Extract keys and values from field definition *)
			fieldPropertyKeys = Keys[fieldDefinition];
			fieldPropertyValues = Values[fieldDefinition];

			(* Expand the field definition to make it index-match to headers *)
			(* e.g., say original field definition is {Headers -> {"X", "Y"}, Description -> "xxx", Class -> {Link, Integer}}, *)
			(* We want {{Headers -> "X", Description -> "xxx", Class -> Link}, {Headers -> "Y", Description -> "xxx", Class -> Integer}} *)

			(* Form of this is {{"X", "Y"}, {"xxx", "xxx"}, {{Link, Integer}} *)
			expandedFieldPropertyValues = Map[
				If[MatchQ[#, _List] && Length[#] == indexLength,
					#,
					ConstantArray[#, indexLength]
				]&,
				fieldPropertyValues
			];

			expandedFieldDefinitions = Map[
				Function[{fieldPropertyValuesPerIndex},
					Normal[AssociationThread[fieldPropertyKeys, fieldPropertyValuesPerIndex], Association]
				],
				Transpose[expandedFieldPropertyValues]
			];

			(* Also expand the option value *)
			headerKeys = Keys[headers];
			expandedOptionValue = Which[
				(* If the option value is in named-multiple form, i.e., list of associations, extract the values *)
				MatchQ[preProcessedOptionValue, {_Association..}],
				Lookup[#, headerKeys, Null]& /@ preProcessedOptionValue,
				(* If the option value is a singleton association, make it into a list of index-multiple *)
				MatchQ[preProcessedOptionValue, _Association],
				{Lookup[preProcessedOptionValue, headerKeys, Null]},
				(* If the option value is in index-multiple form, make no change *)
				MatchQ[preProcessedOptionValue, {_List..}] && Length[First[preProcessedOptionValue]] == indexLength,
				preProcessedOptionValue,
				(* Otherwise, if the option value length itself matches index, most likely we simply need to wrap it with another layer of list *)
				MatchQ[preProcessedOptionValue, _List] && Length[preProcessedOptionValue] == indexLength,
				{preProcessedOptionValue},
				(* All other cases we have an error *)
				True,
				$Failed
			];

			(* If anything failing index-matching, return $Failed *)
			If[MatchQ[expandedOptionValue, $Failed],
				Return[$Failed, Module]
			];

			(* Now we have expanded our field definitions and values, call MapThread on the formatFieldValue function recursively *)
			indexMultipleFieldValue = Map[
				Function[{singleValues},
					MapThread[Function[{singleHeaderValue, singleHeaderDefinition},
						formatFieldValue[objectType, optionName, singleHeaderValue, singleHeaderDefinition]
					],
						{singleValues, expandedFieldDefinitions}
					]
				],
				expandedOptionValue
			];

			(* Finally, we need to convert the field value in index-multiple format into the correct named-multiple format *)
			listedConvertedField = Map[
				Function[{innerValue},
					AssociationThread[headerKeys, innerValue]
				],
				indexMultipleFieldValue
			];

			(* If the field format is single, convert back to a single value from list of lists *)
			Which[
				MatchQ[format, Single] && EqualQ[Length[listedConvertedField], 1],
				First[listedConvertedField],

				(* Throw an error if it's a single and we got multiple entries *)
				MatchQ[format, Single],
				$Failed,

				(* No change if it's a multiple *)
				True,
				listedConvertedField
			]
		],
		(* Any other case, make no change to field value *)
		True,
		preProcessedOptionValue
	];

	(* Perform any custom conversions where the translation from option pattern to field pattern is non-standard *)
	translateCustomOptionValue[optionName, standardFieldValue]
];

(* helper *)
(* packet overload *)

(* some multiple options are specified in the form of index-multiple, e.g. Positions, however the actual field is Named multiple *)
(* So we need to convert the resolved option into correct association for upload *)
indexToNamedMultiple[myPacket_Association, myFieldDefinitions:{_Rule...}] := indexToNamedMultiple[Normal[myPacket, Association], myFieldDefinitions];

(* Empty rule (either resolved options or Named multiple field definitions) overload *)
indexToNamedMultiple[{}, _] := {};
indexToNamedMultiple[myfieldRules:{_Rule..}, {}] := myfieldRules;

(* Type overload *)
indexToNamedMultiple[myInput:{_Rule..}, myType:TypeP[]] := Module[
	{fieldDefinitions, namedMultipleFieldDefinitions},
	fieldDefinitions = Lookup[LookupTypeDefinition[myType], Fields];
	namedMultipleFieldDefinitions = Select[fieldDefinitions, MatchQ[Lookup[Values[#], Format], Multiple] && MatchQ[Lookup[Values[#], Headers, Null], {_Rule ..}] &];
	indexToNamedMultiple[myInput, namedMultipleFieldDefinitions]
];

(* singleton overload *)
indexToNamedMultiple[mySingleRule_Rule, mySecondInput_] := First[indexToNamedMultiple[{mySingleRule}, mySecondInput]]

(* Main overload *)
indexToNamedMultiple[myfieldRules:{_Rule..}, myFieldDefinitions:{_Rule..}] := Module[
	{fieldHeaders, fieldValues, fieldNames, correctedFieldValues, rulesNeedsTransfer, correctedFieldRules},

	fieldHeaders = Keys[Lookup[#, Headers]]& /@ Values[myFieldDefinitions];
	fieldNames = Keys[myFieldDefinitions];

	fieldValues = Lookup[myfieldRules, #, Null]& /@ fieldNames;

	(* Here is what we are trying to do. Use the Positions field in Model[Container] as an example: *)
	(* In the option for the UploadContainerModel function we are expecting the Positions field to format as index-multiple *)
	(* like {{"A1", Null, 1Meter, 1Meter, 1Meter}}. However, the Positions field in Model[Container] is defined as named-multiple *)
	(* Something like {<|Name -> "A1", Footprint -> Null, MaxWidth -> 1Meter, MaxDepth -> 1Meter, MaxHeight -> 1Meter|>} *)
	(* We need to convert the index-multiple option value into the correctly-formatted named-multiple field value, in order for the change packet to be valid *)
	correctedFieldValues = MapThread[
		Function[{fieldValue, headersOfOneField},
			If[NullQ[fieldValue] || MatchQ[fieldValue, {}],
				{},
				rulesNeedsTransfer = Transpose[
					MapThread[
						Function[{headerValues, header},
							If[MatchQ[headerValues, _List],
								(header -> #)& /@ headerValues,
								header -> headerValues
							]
						],
						{Transpose[fieldValue], headersOfOneField}
					]
				];
				If[MatchQ[rulesNeedsTransfer, {_Rule..}],
					{Association[rulesNeedsTransfer]},
					Association /@ rulesNeedsTransfer
				]
			]
		],
		{fieldValues, fieldHeaders}
	];

	correctedFieldRules = MapThread[
		Function[{field, value},
			If[MemberQ[Keys[myfieldRules], field],
				field -> value,
				Nothing
			]
		],
		{fieldNames, correctedFieldValues}
	];

	ReplaceRule[myfieldRules, correctedFieldRules]

];


(* ::Subsubsection::Closed:: *)
(*translateCustomOptionValue*)

(* Helper to convert the values of options into format suitable for upload where the relationship between the two is non-standard *)
translateCustomOptionValue[field_Symbol, optionValue_] := Switch[field,

	(* NFPA. Handled as a single expression, even though it looks a bit like a named single *)
	(* {1, 2, 3, {Oxidizer}} -> {Health -> 1, Flammability -> 2, Reactivity -> 3, Special -> {Oxidizer}} *)
	NFPA,
	Which[
		(* If matches NFPA field already except Special is set to Null, change that Null to a {} so we match NFPA *)
		MatchQ[ReplaceRule[optionValue, (Rule[Special, Null] -> Rule[Special, {}])], NFPAP],
		ReplaceRule[
			optionValue,
			(Rule[Special, Null] -> Rule[Special, {}])
		],

		(* If in option format, convert it to field format *)
		MatchQ[
			optionValue,
			{
			Alternatives[0, 1, 2, 3, 4],
			Alternatives[0, 1, 2, 3, 4],
			Alternatives[0, 1, 2, 3, 4],
			{Alternatives[Oxidizer, WaterReactive, Aspyxiant, Corrosive, Acid, Bio, Poisonous, Radioactive, Cryogenic, Null]...} | Null
		}],
		{
			Health -> optionValue[[1]],
			Flammability -> optionValue[[2]],
			Reactivity -> optionValue[[3]],
			Special -> If[NullQ[optionValue[[4]]], {}, ToList[optionValue[[4]]]]
		},

		(* Otherwise leave unchanged *)
		True,
		optionValue
	],

	(* Extinction coefficient. This field doesn't have headers *)
	(* {{myWavelength,myExtinctionCoefficient}} -> {<|Wavelength->myWavelength,ExtinctionCoefficient->myExtinctionCoefficient|>..} *)
	ExtinctionCoefficients,
	If[MatchQ[optionValue, {{_, _}..}],
		(* If we've got tuples, convert to an association *)
		Function[
			{myExtinctionCoefficient},
			<|Wavelength -> myExtinctionCoefficient[[1]], ExtinctionCoefficient -> myExtinctionCoefficient[[2]]|>
		] /@ optionValue,

		(* Otherwise leave as is *)
		optionValue
	],

	(* Anything else is unchanged *)
	_,
	optionValue
];


(* ::Subsubsection::Closed:: *)
(*preProcessOptionValue*)

(* Helper to convert incompletely defined options to fully defined options before standard processing *)
preProcessOptionValue[objectType : TypeP[], fieldName_Symbol, optionValue_] := Switch[{objectType, fieldName, optionValue},
	(* Object[Sample][Composition] has a 3rd column for date that needs to be added at upload time *)
	(* Convert any field value with only two columns *)
	{Object[Sample], Composition, {{_, _}..}},
	Module[{now},
		now = Now;

		(* Append the upload time to each row *)
		Append[#, now] & /@ optionValue
	],

	(* Leave anything else unchanged *)
	_,
	optionValue
];


(* ::Subsubsection::Closed:: *)
(*stripChangePacket*)


(* Change any change heads in our packet. Make sure to keep DelayedRules from evaluating the RHS. *)
stripChangePacket[myChangePacket_Association, myOptions:OptionsPattern[]]:=Module[{existingPacket, nonChangePacket, fullPacket, fields, nonComputableFields, notIncludedFields},
	(* Get the existing packet, if we were given one. *)
	existingPacket=Lookup[ToList[myOptions], ExistingPacket, <||>];

	(* Get rid of the Replace|Append heads. *)
	nonChangePacket=Association@Map[
		Function[changeField,
			ReplaceAll[changeField, {(Replace | Append | Transfer)[head_] :> head}]
		],
		Normal[myChangePacket]
	];

	(* Merge the existing packet with our change packet. *)
	fullPacket=Join[existingPacket, nonChangePacket];

	(* Get the object definition. *)
	fields=Lookup[LookupTypeDefinition[Lookup[myChangePacket, Type]], Fields];

	(* Get all non-computable fields. *)
	nonComputableFields=Cases[fields, Verbatim[Rule][_, KeyValuePattern[Class -> Except[Computable]]]][[All, 1]];

	(* Add Null/{} values for keys that don't exist in the change packet. *)
	(* Note: Never include Object. *)
	notIncludedFields=Complement[nonComputableFields, Append[Keys[fullPacket], Object]];

	(* Add these fields to the packet. *)
	Join[
		fullPacket,
		Association@Map[
			(If[MatchQ[Lookup[Lookup[fields, #], Format], Single],
				# -> Null,
				# -> {}
			]&),
			notIncludedFields
		]
	]
];


(* ::Subsection::Closed:: *)
(*Error Throwing*)


(* Get the full Error::MyError\[Rule]listOfCorrespondingInvalidOptions for the type given and all the supertypes of that type. *)
lookupInvalidOptionMap[myType_]:=Flatten[ValidObjectQ`Private`errorToOptionMap /@ NestWhileList[Most[#]&, myType, (Length[#] != 1&)]];


(* ::Subsection::Closed:: *)
(*Sister Functions*)

LazyLoading[$DelayDefaultUploadFunction, InstallValidQFunction, DownValueTrigger -> True];

InstallValidQFunction[myFunction_, myType_]:=Module[{validQFunctionString, validQFunctionSymbol, stringInputName},
	(* Do surgery to add Valid <> myFunction <> Q. *)
	validQFunctionString="Valid"<>ToString[myFunction]<>"Q";
	validQFunctionSymbol=ToExpression["ECL`"<>validQFunctionString];

	(* Install the usage rules. *)
	stringInputName=ToLowerCase[ToString[Last[myType]]];

	(* Install usage rules. *)
	DefineUsage[validQFunctionSymbol,
		{
			BasicDefinitions -> {
				{
					Definition -> {validQFunctionString<>"["<>stringInputName<>"Name]", "isValid"<>stringInputName<>"Model"},
					Description -> "returns a boolean that indicates if a valid "<>ToString[myType]<>" will be generated from the inputs of this function.",
					Inputs :> {
						{
							InputName -> stringInputName<>"Name",
							Description -> "The common name of this "<>stringInputName<>".",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
						}
					},
					Outputs :> {
						{
							OutputName -> "isValid"<>stringInputName<>"Model",
							Description -> "A boolean that indicates if the resulting "<>ToString[myType]<>" is valid.",
							Pattern :> BooleanP
						}
					}
				}
			},
			SeeAlso -> {
				"UploadOligomer",
				"UploadProtein",
				"UploadAntibody",
				"UploadCarbohydrate",
				"UploadPolymer",
				"UploadResin",
				"UploadSolidPhaseSupport",
				"UploadLysate",
				"UploadVirus",
				"UploadMammalianCell",
				"UploadBacterialCell",
				"UploadYeastCell",
				"UploadTissue",
				"UploadMaterial",
				"UploadSpecies",
				"UploadProduct",
				"Upload",
				"Download",
				"Inspect"
			},
			Author -> {
				"lige.tonggu"
			}
		}
	];

	(* Install the options. *)
	DefineOptions[validQFunctionSymbol,
		Options :> {
			VerboseOption,
			OutputFormatOption
		},
		SharedOptions :> {myFunction}
	];

	(* Install the downvalue. *)
	validQFunctionSymbol[myInput_, myOptions:OptionsPattern[]]:=Module[
		{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

		(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
		preparedOptions=Normal@KeyDrop[Append[ToList[myOptions], Output -> Tests], {Verbose, OutputFormat}];

		(* Call the function to get a list of tests *)
		functionTests=myFunction[myInput, Sequence @@ preparedOptions];

		initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

		allTests=If[MatchQ[functionTests, $Failed],
			{Test[initialTestDescription, False, True]},

			Module[{initialTest},
				initialTest=Test[initialTestDescription, True, True];

				Join[{initialTest}, functionTests]
			]
		];

		(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
		{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

		(* Run the tests as requested *)
		RunUnitTest[<|"TestResults" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["TestResults"]
	];
];

LazyLoading[$DelayDefaultUploadFunction, InstallOptionsFunction,
	DownValueTrigger -> True];

InstallOptionsFunction[myFunction_, myType_]:=Module[{optionsFunctionString, optionsFunctionSymbol, stringInputName},

	(* Do surgery to add myFunction <> Options. *)
	optionsFunctionString=ToString[myFunction]<>"Options";
	optionsFunctionSymbol=ToExpression["ECL`"<>optionsFunctionString];

	(* Install the usage rules. *)
	stringInputName=ToLowerCase[ToString[Last[myType]]];

	(* Install usage rules. *)
	DefineUsage[optionsFunctionSymbol,
		{
			BasicDefinitions -> {
				{
					Definition -> {optionsFunctionString<>"["<>stringInputName<>"Name]", stringInputName<>"Options"},
					Description -> "returns a list of options as they will be resolved by "<>ToString[myFunction]<>"[].",
					Inputs :> {
						{
							InputName -> stringInputName<>"Name",
							Description -> "The common name of this "<>stringInputName<>".",
							Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
						}
					},
					Outputs :> {
						{
							OutputName -> stringInputName<>"Options",
							Description -> "A list of resolved options as they will be resolved by "<>ToString[myFunction]<>"[].",
							Pattern :> {Rule..}
						}
					}
				}
			},
			SeeAlso -> {
				"UploadOligomer",
				"UploadProtein",
				"UploadAntibody",
				"UploadCarbohydrate",
				"UploadPolymer",
				"UploadResin",
				"UploadSolidPhaseSupport",
				"UploadLysate",
				"UploadVirus",
				"UploadMammalianCell",
				"UploadBacterialCell",
				"UploadYeastCell",
				"UploadTissue",
				"UploadMaterial",
				"UploadSpecies",
				"UploadProduct",
				"Upload",
				"Download",
				"Inspect"
			},
			Author -> {
				"lige.tonggu"
			}
		}
	];

	(* Install the options. *)
	DefineOptions[optionsFunctionSymbol,
		Options :> {
			{
				OptionName -> OutputFormat,
				Default -> Table,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
				Description -> "Determines whether the function returns a table or a list of the options.",
				Category -> "Protocol"
			}
		},
		SharedOptions :> {myFunction}
	];

	(* Install the downvalue. *)
	optionsFunctionSymbol[myInput_, myOptions:OptionsPattern[]]:=Module[
		{listedOps, outOps, options},

		(* get the options as a list *)
		listedOps=ToList[myOptions];

		outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

		options=myFunction[myInput, Sequence @@ Append[outOps, Output -> Options]];

		(* Return the option as a list or table *)
		If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
			LegacySLL`Private`optionsToTable[options, myFunction],
			options
		]
	];
];


(* ::Subsection:: *)
(*Install Tests*)

LazyLoading[$DelayDefaultUploadFunction, InstallIdentityModelTests,
	DownValueTrigger -> True, UpValueTriggers -> {Tests, Examples, RunUnitTest}];

InstallIdentityModelTests[myFunction_, basicDescription_, defaultFunctionArguments_List]:=InstallIdentityModelTests[
	myFunction, basicDescription, defaultFunctionArguments, {}
];

InstallIdentityModelTests[myFunction_, basicDescription_, defaultFunctionArguments_List, symbolSetUpObjectsToDelete:ListableP[ObjectP[]]]:=Module[{createExample, testsForOptions, optionDefinition, options, listOfTests},
	(* Helper function that will create an Example[...] with myDescription, myFunction, and myArguments. *)
	createExample[myDescription_, myFunctionSymbol_, myArguments_]:=Module[{heldFunctionCall, heldDescription},
		(* First we have to create Hold[myFunctionSymbol[myArguments]] and Hold[myDescription]. *)
		heldFunctionCall=With[{insertMe=(Sequence @@ myArguments)},
			holdCompositionList[myFunctionSymbol, {Hold[insertMe]}]
		];
		heldDescription=With[{insertMe=myDescription},
			Hold[insertMe]
		];

		(* holdCompositionList creates Hold[Example[...]], then Example is HoldRest so we ReleaseHold. *)
		ReleaseHold@With[{insertMe1=heldDescription, insertMe2=heldFunctionCall},
			holdCompositionList[
				Example,
				{
					insertMe1,
					insertMe2,
					Hold[ObjectP[]|_Grid|BooleanP],

					(* SetUp and TearDown are the same for all examples. *)
					Hold[
						SetUp :> {
							$CreatedObjects={};
						}
					],
					Hold[
						TearDown :> {
							EraseObject[$CreatedObjects, Force -> True];
							Unset[$CreatedObjects];
						}
					]
				}
			]
		]
	];

	(* Create a big dictionary of option name to information about the default test for that option. *)
	testsForOptions=Association@{
		Name -> <|
			Description -> "Use the Name option to set the name of this new identity model:",
			AdditionalOptions -> {Name -> "My New Identity Model #"<>CreateUUID[]}
		|>,
		Synonyms -> <|
			Description -> "Use the Synonyms option add additional names that this identity model goes by:",
			AdditionalOptions -> {Synonyms -> {"Novel Compound #4"}}
		|>,
		ExtinctionCoefficients -> <|
			Description -> "Use the ExtinctionCoefficients option to set the Extinction Coefficient of this uploaded identity model. This field is in the format {{Wavelength,ExtinctionCoefficient}..}:",
			AdditionalOptions -> {ExtinctionCoefficients -> {{260 Nanometer, 13400 Liter / (Centimeter * Mole)}}}
		|>,
		Density -> <|
			Description -> "Use the Density option to set the density of this uploaded identity model:",
			AdditionalOptions -> {Density -> 1.10 Gram / (Centimeter^3)}
		|>,
		MeltingPoint -> <|
			Description -> "Use the MeltingPoint option to provide the temperature at which the solid form of this identity model will melt:",
			AdditionalOptions -> {MeltingPoint -> 343.5 Celsius}
		|>,
		BoilingPoint -> <|
			Description -> "Use the BoilingPoint option to provide the temperature at which the liquid form of this identity model will evaporate:",
			AdditionalOptions -> {BoilingPoint -> 189 Celsius}
		|>,
		VaporPressure -> <|
			Description -> "Use the VaporPressure option to provide the equilibrium pressure of this identity model when it is in thermodynamic equilibrium with its condensed phase:",
			AdditionalOptions -> {VaporPressure -> 0.049 Kilo * Pascal}
		|>,
		Viscosity -> <|
			Description -> "Use the Viscosity option to provide the internal friction of this identity model, measured by the force per unit area resisting a flow between parallel layers of liquid:",
			AdditionalOptions -> {Viscosity -> Quantity[0.8949, "Centipoise"]}
		|>,
		pKa -> <|
			Description -> "Use the pKa option to specify the logarithmic acid dissociation constant for the hydrogen ions present in this identity model:",
			AdditionalOptions -> {pKa -> {2.37}}
		|>,
		pH -> <|
			Description -> "Use the pH option to specify the logarithmic concentration of hydrogen ions of a pure sample of this identity model at room temperature and pressure:",
			AdditionalOptions -> {pH -> {6.7}}
		|>,
		Radioactive -> <|
			Description -> "Use the Radioactive option to specify if this pure samples of this identity model contain unstable atomic nucleuses which lose energy by radiation:",
			AdditionalOptions -> {Radioactive -> False}
		|>,
		Ventilated -> <|
			Description -> "Use the Ventilated option to specify that the pure samples of this identity model need to be handled in a ventilated enclosure:",
			AdditionalOptions -> {Ventilated -> True}
		|>,
		Pungent -> <|
			Description -> "Use the Pungent option to indicate that pure samples of this identity model have a strong odor:",
			AdditionalOptions -> {Pungent -> True, Ventilated -> True}
		|>,
		Acid -> <|
			Description -> "Use the Acid option to specify that pure samples of this identity model are strong acids:",
			AdditionalOptions -> {Acid -> False}
		|>,
		Base -> <|
			Description -> "Use the Base option to specify that pure samples of this identity model are strong bases:",
			AdditionalOptions -> {Base -> False}
		|>,
		Pyrophoric -> <|
			Description -> "Use the Pyrophoric option to specify that pure samples of this identity model ignite spontaneously with contact with air:",
			AdditionalOptions -> {Pyrophoric -> False}
		|>,
		WaterReactive -> <|
			Description -> "Use the WaterReactive option to specify that pure samples of this identity model react violently with contact with water:",
			AdditionalOptions -> {WaterReactive -> False}
		|>,
		Fuming -> <|
			Description -> "Use the Fuming option to specify that pure samples of this identity model produce fumes when exposed to air:",
			AdditionalOptions -> {Fuming -> False}
		|>,
		HazardousBan -> <|
			Description -> "Use the HazardousBan option to indicate that sample that contain this identity model are currently banned from usage in the ECL because the facility isn't yet equipped to handle them:",
			AdditionalOptions -> {HazardousBan -> False}
		|>,
		ExpirationHazard -> <|
			Description -> "Use the ExpirationHazard option to indicate that samples that contain this identity model are hazardous when they become expired:",
			AdditionalOptions -> {ExpirationHazard -> False}
		|>,
		ParticularlyHazardousSubstance -> <|
			Description -> "Use the ParticularlyHazardousSubstance option to specify that special precautions should be taken in handling samples that contain this identity model. This option should be set to True if the GHS Classification of the identity model is an of the following: Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350):",
			AdditionalOptions -> {ParticularlyHazardousSubstance -> False}
		|>,
		DrainDisposal -> <|
			Description -> "Use the DrainDisposal option to specify that pure samples of this identity model can be safely disposed down a standard drain:",
			AdditionalOptions -> {DrainDisposal -> True}
		|>,
		MSDSRequired -> <|
			Description -> "Use the MSDSRequired option to indicate that an MSDS file must be supplied for this identity model. An MSDS file is required by SLL the identity model is detected to be hazardous, however, it is best to always provide an MSDS when possible:",
			AdditionalOptions -> {MSDSRequired -> False}
		|>,
		NFPA -> <|
			Description -> "Use the NFPA option to specify the National Fire Potection Association (NFPA) 704 Hazard diamond classification of this substance. This option is specified in the format {HealthRating,FlammabilityRating,ReactivityRating,SpecialConsiderationsList}. The valid symbols to include in SpecialConsiderationsList are Oxidizer|WaterReactive|Aspyxiant|Corrosive|Acid|Bio|Poisonous|Radioactive|Cryogenic|Null. The following identity model, as an NFPA of {1,0,0,{Radioactive}} which means that its Health rating is 1, its Flammability rating is 0, and its Reactivity rating is 0. This identity model has no special considerations:",
			AdditionalOptions -> {NFPA -> {1, 0, 0, {Radioactive}}}
		|>,
		DOTHazardClass -> <|
			Description -> "Use the DOTHazardClass option to set the DOT Hazard Class of this uploaded identity model. The valid values of this option can be found by evaluating DOTHazardClassP. The following identity model is part of DOT Hazard Class 0:",
			AdditionalOptions -> {DOTHazardClass -> "Class 0"}
		|>,
		LightSensitive -> <|
			Description -> "Use the LightSensitive option to specify if the identity model is light sensitive and special precautions should be taken to make sure that samples that contain this identity model should be handled in a dark room:",
			AdditionalOptions -> {LightSensitive -> False}
		|>,
		LiquidHandlerIncompatible -> <|
			Description -> "Use the LiquidHandlerIncompatible option to specify that pure samples of this identity model cannot be reliably aspirated or dispensed by a liquid handling robot (ex. Methanol):",
			AdditionalOptions -> {LiquidHandlerIncompatible -> False}
		|>,
		UltrasonicIncompatible -> <|
			Description -> "Use the UltrasonicIncompatible option to specify that volume measurements of pure samples of this identity model cannot be performed via the ultrasonic distance method due to vapors interfering with the reading (ex. Methanol):",
			AdditionalOptions -> {UltrasonicIncompatible -> False}
		|>,
		LiteratureReferences -> <|
			Description -> "Use the LiteratureReferences option to link to scholarly articles that mention this identity model:",
			AdditionalOptions -> {LiteratureReferences -> {Object[Report, Literature, "Doorbar HPV Review"]}}
		|>,
		PolymerType -> <|
			Description -> "Use the PolymerType option to indicate the type of polymer the oligomer is composed of (not counting modifications):",
			AdditionalOptions -> {PolymerType -> DNA}
		|>,
		State -> <|
			Description -> "Use the State option to set the state of matter (Solid, Liquid, Gas) of a pure sample of this identity model at room temperature and standard pressure:",
			AdditionalOptions -> {State -> Solid}
		|>,
		Flammable -> <|
			Description -> "Use the Flammable option to indicate if pure samples of this identity model easily combust:",
			AdditionalOptions -> {Flammable -> False}
		|>,
		BiosafetyLevel -> <|
			Description -> "Use the BiosafetyLevel option to specify the biosafety level of this identity model. The valid value of this options can be found by evaluating BiosafetyLevelP (\"BSL-1\",\"BSL-2\",\"BSL-3\",\"BSL-4\"):",
			AdditionalOptions -> {BiosafetyLevel -> "BSL-1"}
		|>,
		IncompatibleMaterials -> <|
			Description -> "Use the IncompatibleMaterials option to specify the list of materials that would become damaged if wetted by this identity model. Use MaterialP to see the materials that can be used in this field. Specify {None} if there are no IncompatibleMaterials:",
			AdditionalOptions -> {IncompatibleMaterials -> {None}}
		|>,
		Enthalpy -> <|
			Description -> "Use the enthalpy option to indicate the expected binding enthalpy for the binding of this oligomer. If Watson-Crick paring is not present in this structure, the Enthalpy is calculated with the structure bound to its reverse complement:",
			AdditionalOptions -> {Enthalpy -> Quantity[0., ("KilocaloriesThermochemical") / ("Moles")]}
		|>,
		Entropy -> <|
			Description -> "Use the entropy option to indicate the expected binding entropy for the binding of this oligomer. If Watson-Crick paring is not present in this structure, the Entropy is calculated with the structure bound to its reverse complement:",
			AdditionalOptions -> {Entropy -> Quantity[0., ("CaloriesThermochemical") / ("Kelvins" "Moles")]}
		|>,
		FreeEnergy -> <|
			Description -> "Use the free energy option to indicate the expected Gibbs Free Energy for the binding of oligomer at 37 Celsius. If Watson-Crick paring is not present in this structure, the Gibbs Free Energy is calculated with the structure bound to its reverse complement:",
			AdditionalOptions -> {Entropy -> 0 CaloriePerMoleKelvin}
		|>,

		(* Model[Molecule, Protein, Antibody] *)
		Species -> <|
			Description -> "Use the species option to indicate the species that the antibody was raised. Determines the type of secondary antibody required for labeling:",
			AdditionalOptions -> {Species -> Model[Species, "Human"]}
		|>,
		Target -> <|
			Description -> "Use the Target option to indicate the protein or antibody targets to which this antibody binds selectively:",
			AdditionalOptions -> {Target -> {Model[Molecule, Protein, "id:D8KAEvG676ML"], Model[Molecule, Protein, "id:wqW9BP7JmJZO"], Model[Molecule, Protein, "id:J8AY5jD676MB"], Model[Molecule, Protein, "id:8qZ1VW0676Jn"], Model[Molecule, Protein, "id:rea9jlRPmPB3"]}}
		|>,
		SecondaryAntibodies -> <|
			Description -> "Use the SecondaryAntibodies option to indicate the other antibodies that bind to this antibody and can be used for labeling:",
			AdditionalOptions -> {SecondaryAntibodies -> {Model[Molecule, Protein, Antibody, "id:lYq9jRxPaPal"]}}
		|>,
		Isotype -> <|
			Description -> "Indicate the subgroup of immunoglobulin this antibody belongs to, based on variations within the constant regions of its heavy and/or light chains.",
			AdditionalOptions -> {Isotype -> IgA}
		|>,
		Clonality -> <|
			Description -> "Specify whether the antibody is produced by one type of cells to recognize a single epitope (monoclonal) or several types of immune cells to recognize multiple epitopes (polyclonal):",
			AdditionalOptions -> {Clonality -> Monoclonal}
		|>,
		AssayTypes -> <|
			Description -> "Indicate the types of experiments in which this antibody is known to perform well in:",
			AdditionalOptions -> {AssayTypes -> {Western, FlowCytometry, ELISA, Immunohistochemistry, Immunoprecipitation, Immunofluorescence, ChromatinImmunoprecipitation}}
		|>,
		RecommendedDilution -> <|
			Description -> "Indicate the dilution that is recommended for use of this identity model in an assay:",
			AdditionalOptions -> {RecommendedDilution -> 0.5}
		|>,

		(* Model[Cell] *)
		DetectionLabels -> <|
			Description -> "Indicate the tags that the cell contains, which can indicate the presence and amount of particular features or molecules in the cell:",
			AdditionalOptions -> {DetectionLabels -> {Model[Molecule, Protein, "id:WNa4ZjKVdVLE"]}}
		|>,

		(* Model[Cell, Mammalian] *)
		CellType -> <|
			Description -> "Indicate the general type of the cell line (Mammalian, Bacterial, or Yeast):",
			AdditionalOptions -> {CellType -> Mammalian}
		|>,
		CultureAdhesion -> <|
			Description -> "Indicate the culture type of the cell line (Adherent or Suspension):",
			AdditionalOptions -> {CultureAdhesion -> Adherent}
		|>,

		(* Model[Cell, Bacteria] *)
		Antibiotics -> <|
			Description -> "Specify the antimicrobial substances that kill or inhibit the growth of this strain of bacteria:",
			AdditionalOptions -> {Antibiotics -> {Model[Molecule, "id:eGakldJvLvA4"]}}
		|>,
		Hosts -> <|
			Description -> "Specify the species that are known to carry this strain of bacteria:",
			AdditionalOptions -> {Hosts -> {Model[Species, "Human"]}}
		|>,
		GramStain -> <|
			Description -> "Indicate whether this strain of bacteria has a layer of peptidoglycan in its cell wall:",
			AdditionalOptions -> {GramStain -> Positive}
		|>,
		Flagella -> <|
			Description -> "Indicate the type of flagella that protrude from this bacterium's cell wall:",
			AdditionalOptions -> {Flagella -> Monotrichous}
		|>,
		Length -> <|
			Description -> "The length of a single bacterium's body along its longest dimension.",
			AdditionalOptions -> {Length -> 5 Micrometer}
		|>,

		(* Model[Molecule, Carbohydrate] *)
		GlyTouCanID -> <|
			Description -> "Specify the GlyTouCan IDs for this carbohydrate:",
			AdditionalOptions -> {GlyTouCanID -> {"1"}}
		|>,
		WURCS -> <|
			Description -> "Specify the Web3 Unique Representation of Carbohydate Structures notation for this carbohydrate:",
			AdditionalOptions -> {WURCS -> "1"}
		|>,
		MonoisotopicMass -> <|
			Description -> "The monoisotopic, underivatised, uncharged mass of this carbohydrate, calculated from experimental data for individual monosaccarides.",
			AdditionalOptions -> {MonoisotopicMass -> 200 Gram / Mole}
		|>,

		(* Model[Lysate] *)
		Cell -> <|
			Description -> "Specify the model of cell line that this lysate is extracted from:",
			AdditionalOptions -> {Cell -> Model[Cell, "HEK293"]}
		|>,

		(* Model[Virus] *)
		GenomeType -> <|
			Description -> "Specify the type of genetic material carried by the virus:",
			AdditionalOptions -> {GenomeType -> "+ssRNA"}
		|>,
		Taxonomy -> <|
			Description -> "Specify the taxonomic class of the virus as defined by its phenotypic characteristics:",
			AdditionalOptions -> {Taxonomy -> Coronavirus}
		|>,
		LatentState -> <|
			Description -> "Specify the state of the virus in a latently infected cell:",
			AdditionalOptions -> {LatentState -> Integrated}
		|>,
		CapsidGeometry -> <|
			Description -> "Specify the virus's capsid structure:",
			AdditionalOptions -> {CapsidGeometry -> Helical}
		|>
	};

	(* Get the options for this function. *)
	optionDefinition=OptionDefinition[myFunction];
	options=Lookup[OptionDefinition[myFunction], "OptionSymbol"];

	(* Construct our giant list of tests. *)
	listOfTests=Flatten[{
		(* Create the basic example given to us as input. *)
		createExample[{Basic, basicDescription}, myFunction, defaultFunctionArguments],

		(* Map over our big option dictionary, adding additional option examples if we have them. *)
		KeyValueMap[
			Function[{option, optionInformation},
				(* Only include this additional example if the option is part of our function AND (the option found in AdditionalOptions matches the pattern if it's in the AdditionalOptions). *)
				If[MemberQ[options, option] && !MemberQ[Cases[defaultFunctionArguments, _Rule][[All, 1]], option],
					(* Join the additional options at the end of the default function arguments. *)
					createExample[{Options, option, Lookup[optionInformation, Description]}, myFunction, Flatten[{defaultFunctionArguments, Lookup[optionInformation, AdditionalOptions, {}]}]],
					Nothing
				]
			],
			testsForOptions
		]
	}];

	(* Install the tests. *)
	If[Length[ToList[symbolSetUpObjectsToDelete]]>0,
		With[{insertMe1=myFunction, insertMe2=listOfTests, insertMe3=ToList[symbolSetUpObjectsToDelete]},
			DefineTests[
				insertMe1,
				insertMe2,
				SymbolSetUp :> {
					Off[Warning::APIConnection];

					$CreatedObjects={};

					Module[{existingObjs},
						existingObjs = PickList[insertMe3, DatabaseMemberQ[insertMe3]];
						EraseObject[existingObjs, Force -> True, Verbose -> False]
					]
				},
				SymbolTearDown :> {
					On[Warning::APIConnection];

					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];

					Unset[$CreatedObjects];
				}
			]
		],
		With[{insertMe1=myFunction, insertMe2=listOfTests},
			DefineTests[
				insertMe1,
				insertMe2,
				SymbolSetUp :> {
					Off[Warning::APIConnection];
					$CreatedObjects={};
				},
				SymbolTearDown :> {
					On[Warning::APIConnection];
					EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
					Unset[$CreatedObjects];
				}
			]
		]
	];
];


(* ::Subsection:: *)
(*Install Default Upload Function*)



LazyLoading[$DelayDefaultUploadFunction, InstallDefaultUploadFunction, DownValueTrigger -> True, UpValueTriggers -> {Usage}];

DefineOptions[InstallDefaultUploadFunction,
	Options :> {
		{
			OptionName -> OptionResolver,
			Default -> resolveDefaultUploadFunctionOptions,
			AllowNull -> False,
			Pattern :> _Symbol,
			Description -> "Specify the head of the option resolver function to use in the function definition.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> AuxilliaryPacketsFunction,
			Default -> generateDefaultUploadFunctionAuxilliaryPackets,
			AllowNull -> False,
			Pattern :> _Symbol,
			Description -> "Specify the head of the function to use to generate changes to additional objects in the function definition.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> InstallNameOverload,
			Default -> True,
			AllowNull -> False,
			Pattern :> BooleanP,
			Description -> "Indicates if the input pattern to the function allows a new object to be created by providing the new object name as a string input.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> InstallObjectOverload,
			Default -> True,
			AllowNull -> False,
			Pattern :> BooleanP,
			Description -> "Indicates if the input pattern to the function allows modification of existing objects by providing the object reference as input.",
			Category -> "Organizational Information"
		}
	}
];


(* Overload that specifies the option resolver to use. *)
InstallDefaultUploadFunction[myFunction_, myType_, options:OptionsPattern[InstallDefaultUploadFunction]]:=Module[
	{safeOptions, installNameOverload, installObjectOverload, optionResolver, auxilliaryPacketsFunction, stringInputName, singletonFunctionPattern, listableFunctionPattern},

	(* Get the safe options *)
	safeOptions = SafeOptions[InstallDefaultUploadFunction, ToList[options]];

	(* Look up option values *)
	{
		installNameOverload,
		installObjectOverload,
		optionResolver,
		auxilliaryPacketsFunction
	}=Lookup[safeOptions,
		{
			InstallNameOverload,
			InstallObjectOverload,
			OptionResolver,
			AuxilliaryPacketsFunction
		}
	];

	(* Install the usage rules. *)
	stringInputName=ToLowerCase[ToString[Last[myType]]];

	DefineUsage[myFunction,
		{
			BasicDefinitions -> {

				If[TrueQ[installNameOverload] && TrueQ[installObjectOverload],
					{
						Definition -> {ToString[myFunction]<>"[Inputs]", stringInputName<>"Model"},
						Description -> "creates/updates a model '"<>stringInputName<>"Model' that contains the information given about the "<>stringInputName<>".",
						Inputs :> {
							IndexMatching[
								{
									InputName -> "Inputs",
									Description -> "The new names and/or existing objects that should be updated with information given about the "<>stringInputName<>".",
									Widget -> Alternatives[
										With[{insertMe=myType},
											Widget[Type -> Object, Pattern :> ObjectP[insertMe]]
										],
										Widget[Type -> String, Pattern :> _String, Size -> Line]
									]
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							{
								OutputName -> stringInputName<>"Model",
								Description -> "The model that represents this "<>stringInputName<>".",
								Pattern :> ObjectP[myType]
							}
						},
						(* Hidden definition to call our functions with (ValidInputLengthsQ, etc.) *)
						CommandBuilder -> False
					},
					Nothing
				],

				If[TrueQ[installNameOverload],
					{
						Definition -> {ToString[myFunction]<>"["<>Capitalize[stringInputName]<>"Name]", stringInputName<>"Model"},
						Description -> "returns a new model '"<>stringInputName<>"Model' that contains the information given about the "<>stringInputName<>".",
						Inputs :> {
							IndexMatching[
								{
									InputName -> Capitalize[stringInputName]<>"Name",
									Description -> "The common name of this "<>stringInputName<>".",
									Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							{
								OutputName -> stringInputName<>"Model",
								Description -> "The model that represents this "<>stringInputName<>".",
								Pattern :> ObjectP[myType]
							}
						}
					},
					Nothing
				],

				If[TrueQ[installObjectOverload],
					{
						Definition -> {ToString[myFunction]<>"["<>Capitalize[stringInputName]<>"Object]", stringInputName<>"Model"},
						Description -> "updates an existing model '"<>stringInputName<>"Model' that contains the information given about the "<>stringInputName<>".",
						Inputs :> {
							IndexMatching[
								{
									InputName -> Capitalize[stringInputName]<>"Object",
									Description -> "The existing "<>ToString[myType]<>" object that should be updated.",
									Widget -> With[{insertMe=myType},
										Widget[Type -> Object, Pattern :> ObjectP[insertMe], PreparedSample -> False, PreparedContainer -> False]
									]
								},
								IndexName -> "Input Data"
							]
						},
						Outputs :> {
							{
								OutputName -> stringInputName<>"Model",
								Description -> "The model that represents this "<>stringInputName<>".",
								Pattern :> ObjectP[myType]
							}
						}
					},
					Nothing
				]
			},
			If[MatchQ[myFunction,UploadSampleModel],
				MoreInformation -> {
					"If Updating the Composition of a Model[Sample], the Compositions of all linked Object[Sample]'s will also be updated. The date in the components of the composition will have the Date of when UploadSampleModel is executed."
				},
				Nothing
			],
			SeeAlso -> {
				"UploadOligomer",
				"UploadProtein",
				"UploadAntibody",
				"UploadCarbohydrate",
				"UploadPolymer",
				"UploadResin",
				"UploadSolidPhaseSupport",
				"UploadLysate",
				"UploadVirus",
				"UploadMammalianCell",
				"UploadBacterialCell",
				"UploadYeastCell",
				"UploadTissue",
				"UploadMaterial",
				"UploadSpecies",
				"UploadProduct",
				"Upload",
				"Download",
				"Inspect"
			},
			Author -> {
				"lige.tonggu"
			}
		}
	];

	(* Create an input pattern for our listable and singleton functions. *)
	singletonFunctionPattern=Switch[{installNameOverload, installObjectOverload},
		{True, True},
		_String | ObjectP[myType],
		{True, False},
		_String,
		{False, True},
		ObjectP[myType]
	];

	listableFunctionPattern={singletonFunctionPattern..};

	(* Install the listable overload. *)
	With[
		{
			optionResolverFunction = optionResolver,
			auxPacketsFunction = auxilliaryPacketsFunction
		},

		myFunction[myInputs : listableFunctionPattern, myOptions : OptionsPattern[myFunction]] := Module[
			{listedInputs, listedOptions, outputSpecification, cache, simulation, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests,
				expandedInputs, expandedOptions, optionName, optionValueList, expandedOptionsWithName,
				resolvedOptions, resolvedOptionsInvalidInputs, resolvedOptionsInvalidOptions, collapsedResolvedOptions, uploadPackets, auxilliaryPackets,
				voqTestResults, voqTests, voqInvalidInputs, voqInvalidOptions, allInvalidInputs, allInvalidOptions,
				resultRule, previewRule, optionsRule, testsRule,
				inputObjectCache, listedOptionsWithCache, safeOptionsWithCache},

			(* Make sure we're working with a list of inputs and options *)
			listedInputs = ToList[myInputs];
			listedOptions = ToList[myOptions];

			(* Determine the requested return value from the function *)
			outputSpecification = If[!MatchQ[Lookup[listedOptions, Output], _Missing],
				Lookup[listedOptions, Output],
				Result
			];
			output = ToList[outputSpecification];

			(* Determine if we should keep a running list of tests *)
			gatherTests = MemberQ[output, Tests];

			(* Call SafeOptions to make sure all options match pattern *)
			{safeOptions, safeOptionTests} = If[gatherTests,
				SafeOptions[myFunction, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
				{SafeOptions[myFunction, listedOptions, AutoCorrect -> False], Null}
			];

			(* Call ValidInputLengthsQ to make sure all options are the right length *)
			{validLengths, validLengthTests} = If[gatherTests,
				ValidInputLengthsQ[myFunction, {listedInputs}, listedOptions, Output -> {Result, Tests}],
				{ValidInputLengthsQ[myFunction, {listedInputs}, listedOptions], Null}
			];

			(* If the specified options don't match their patterns return $Failed (or the tests up to this point)  *)
			If[MatchQ[safeOptions, $Failed],
				Return[outputSpecification /. {
					Result -> $Failed,
					Tests -> safeOptionTests,
					Options -> $Failed,
					Preview -> Null
				}]
			];

			(* If option lengths are invalid return $Failed (or the tests up to this point) *)
			If[!validLengths,
				Return[outputSpecification /. {
					Result -> $Failed,
					Tests -> Join[safeOptionTests, validLengthTests],
					Options -> $Failed,
					Preview -> Null
				}]
			];

			(* SafeOptions passed. Use SafeOptions to get the output format. *)
			outputSpecification = Lookup[safeOptions, Output];

			(* Grab the cache and simulation from options *)
			cache = Lookup[safeOptions, Cache, {}];
			simulation = Lookup[safeOptions, Simulation, Null];

			(* Download all of the objects from our input list without computable fields. *)
			inputObjectCache = Module[{objects, types, typeFields, fullDownloadFields},

				(*all unique objects we are working with*)
				objects = DeleteDuplicates[Cases[listedInputs, ObjectReferenceP[myType], Infinity]];
				(* This is required as the objects may be subtype of myType and we need to download all the fields. This is specifically important for Model[Sample,StockSolution] *)
				types = Download[objects, Type];

				(* fields without computable fields *)
				typeFields = Map[
					(
						# -> {Packet @@ Experiment`Private`noComputableFieldsList[#]}
					)&,
					DeleteDuplicates[types]
				];

				fullDownloadFields = types /. typeFields;

				(* need to Flatten here to get a flat list of packets *)
				Experiment`Private`FlattenCachePackets[
					Download[
						objects,
						fullDownloadFields,
						Cache -> cache,
						Simulation -> simulation
					]
				]
			];

			(* Add the input object packets to the Cache option *)
			listedOptionsWithCache = ReplaceRule[listedOptions, Cache -> inputObjectCache];
			safeOptionsWithCache = ReplaceRule[safeOptions, Cache -> inputObjectCache];

			(*-- Otherwise, we're dealing with a listable version. Map over the inputs and options. --*)
			(*-- Basic checks of input and option validity passed. We are ready to map over the inputs and options. --*)
			(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
			{expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[myFunction, {listedInputs}, listedOptionsWithCache];

			(* Put the option name inside of the option values list so we can easily MapThread. *)
			expandedOptionsWithName = Function[{option},
				optionName = option[[1]];
				optionValueList = option[[2]];

				(* We are given OptionName\[Rule]OptionValueList. *)
				(* We want {OptionName\[Rule]OptionValue1, OptionName\[Rule]OptionValue2, etc.} *)
				Function[{optionValue},
					optionName -> optionValue
				] /@ optionValueList
			] /@ expandedOptions;

			(* Resolve our options *)
			(* This is mapped for now, whilst converting from the previous mapping approach to listed form in line with style guide *)
			(* Note the options come out mapthread style - list of associations *)
			{resolvedOptions, resolvedOptionsInvalidInputs, resolvedOptionsInvalidOptions} = Module[
				{resolverOutput},

				(* Resolve the options *)
				(* This returns in a different format to an experiment function resolver *)
				(* Options need to be passed in in mapthread style format *)
				resolverOutput = optionResolverFunction[
					myType,
					listedInputs,
					SafeOptions[myFunction, #] & /@ Transpose[{Sequence @@ expandedOptionsWithName}](* Safe options *),
					Transpose[{Sequence @@ expandedOptionsWithName}](* User specified options *)
				];

				(* Return the required information *)
				Lookup[resolverOutput, {Result, InvalidInputs, InvalidOptions}]
			];

			(* Collapse and filter the resolved options *)
			collapsedResolvedOptions = CollapseIndexMatchedOptions[
				myFunction,
				RemoveHiddenOptions[
					UploadSampleModel,
					Replace[Merge[resolvedOptions, Identity], Association -> List, {1}, Heads -> True]
				],
				Ignore -> listedOptions,
				Messages -> False
			];


			(* Generate the upload packets from the resolved options *)
			uploadPackets = Module[
				{appendToFieldsQ, initialChangePackets, fullChangePackets},

				(* Check if we're appending to fields (rather than replacing the whole contents *)
				appendToFieldsQ = Lookup[safeOptionsWithCache, Append, False];

				(* Convert resolved options into change packets *)
				initialChangePackets = MapThread[
					With[{objectPacket = Experiment`Private`fetchPacketFromCache[#1, Lookup[safeOptionsWithCache, Cache]]},
						If[MatchQ[objectPacket, PacketP[]],
							(* If modifying an existing object, feed in the packet for the existing object *)
							generateChangePacket[myType, #2, appendToFieldsQ, ExistingPacket -> objectPacket],

							(* Otherwise, just pass in the resolved options *)
							generateChangePacket[myType, #2, appendToFieldsQ]
						]
					] &,
					{First[expandedInputs], resolvedOptions}
				];

				(* Create a new object reference for the object, or sub in the existing one if modifying an existing object *)
				fullChangePackets = MapThread[
					If[MatchQ[#1, ObjectP[myType]],
						Append[#2, Object -> Download[#1, Object]],
						Append[#2, Object -> CreateID[myType]]
					] &,
					{First[expandedInputs], initialChangePackets}
				]
			];


			(* Now create upload packets for any auxilliary changes, if needed *)
			(* The default function returns an empty list *)
			auxilliaryPackets = auxPacketsFunction[myType, listedInputs, listedOptionsWithCache, resolvedOptions];


			(* Perform error checking using VOQ system *)
			(* VOQ test failures will generate messages themselves directly *)
			{voqTestResults, voqTests, voqInvalidInputs, voqInvalidOptions} = Module[
				{pseudoObjectPackets, pseudoObjectPacketsWithoutRuleDelayeds, voqTestLists, voqResults, invalidOptions, invalidInputs},

				(* Convert the upload packets into packets that look like a real object, such as removing Append/Replace *)
				(* The new packet includes all fields including those with Null/{} value that were excluded from the change packet. *)
				(* If we're modifying an existing object, we merge that packet with our change packet *)
				pseudoObjectPackets = MapThread[
					Function[{inp, inpPack},
						With[{objectPacket = Experiment`Private`fetchPacketFromCache[inp, Lookup[listedOptionsWithCache, Cache]]},
							If[MatchQ[objectPacket, PacketP[]],
								stripChangePacket[Append[inpPack, Type -> myType], ExistingPacket -> objectPacket],
								stripChangePacket[Append[inpPack, Type -> myType]]
							]
						]
					],
					{listedInputs, uploadPackets}
				];

				(* Remove rule delayeds from the packet *)
				pseudoObjectPacketsWithoutRuleDelayeds = Module[
					{ruleLists, ruleListsWithoutRuleDelayeds},

					(* Convert the associations into lists of rules, as we can't filter by rule type in an association *)
					ruleLists = Replace[pseudoObjectPackets, Association -> List, {2}, Heads -> True];

					(* Remove the rule delayeds *)
					ruleListsWithoutRuleDelayeds = DeleteCases[ruleLists, _RuleDelayed, {2}];

					(* Convert back into associations and return *)
					Association @@@ ruleListsWithoutRuleDelayeds
				];

				(* Get the tests for each input *)
				voqTestLists = ValidObjectQ`Private`testsForPacket /@ pseudoObjectPacketsWithoutRuleDelayeds;

				(* Run the VOQ tests for each input *)
				{voqResults, invalidInputs, invalidOptions} = Module[
					{
						testEvaluationData, testMessageData, passingQs, messagesQs, messageRulesGrouped, invalidOptionMap,
						invalidOptions, messageRulesWithoutInvalidInput, messageRulesWithoutRequiredOptions
					},

					(* Run the tests *)
					(* This actually throws messages directly *)
					(* The custom error handling is reproduced from the previous code - it prevents the messages being thrown multiple times in the map *)
					(* so they can be combined later. But it's rather nasty redefining Message and can lead to weird side effects when anything *)
					(* within the error handling block is relying on what a message is (such as Check) *)
					(* But it does hide the mapped messages from Command Center when it calls the whole upload function wrapped in EvaluationData *)
					{testEvaluationData, testMessageData} = Internal`InheritedBlock[{Message, $InMsg = False},
						Module[{voqMessageList, evaluationData},

							(* Deprotect Message so that we can modify the downvalues. Ouch *)
							Unprotect[Message];

							(* Actually run the voq tests for each of the upload packets *)
							{evaluationData, voqMessageList} = Transpose[Block[
								{ECL`$UnitTestMessages = True},
								Module[{messageList, evaluationOutput},

									(* Create a list to store details about the messages in *)
									messageList = {};

									(* Set a conditional downvalue for the Message function, directing the information to our message list *)
									(* Record the message if it has an Error:: or Warning:: head. *)
									Message[msg_, vars___] /; !$InMsg := Block[{$InMsg = True},
										If[MatchQ[HoldForm[msg], HoldForm[MessageName[Error | Warning, _]]],

											(* If it's an error or warning, capture it and don't display *)
											AppendTo[messageList, {HoldForm[msg], vars}];

											(* If it's a different type of message, throw it as normal *)
											Message[msg, vars]
										]
									];

									(* Run the tests. Quiet other messages but we'll still capture our messages of interest *)
									evaluationOutput = Quiet[EvaluationData[RunUnitTest[<|"Function" -> #|>, OutputFormat -> SingleBoolean, Verbose -> False]]];

									(* Return the output and details of the messages thrown *)
									{evaluationOutput, messageList}
								]& /@ voqTestLists
							]];

							(* Return the evaluation data and the list of messages thrown *)
							{
								evaluationData,
								voqMessageList
							}
						]
					];

					(* Combine the captured messages so that they become listable and avoid duplicated messages *)
					(* i.e. rather than "Input A is invalid" and "Input B is invalid" we say "Inputs A and B are invalid" *)

					(* Build a map of messages and which inputs they were thrown for. Group together our message rules. *)
					messageRulesGrouped = Module[
						{messageRules},

						messageRules = Flatten@Map[
							Function[{inputMessageList},
								Function[{inputMessage},
									ToString[First[inputMessage]] -> Rest[inputMessage]
								] /@ inputMessageList
							],
							testMessageData
						];

						Merge[
							messageRules,
							Transpose
						]
					];

					(* Lookup the map from invalid option error message type to the list of invalid options that triggered it *)
					(* e.g. <|"Error::NameIsNotPartOfSynonyms" -> {Name, Synonyms}|> *)
					invalidOptionMap = lookupInvalidOptionMap[myType];

					(* Get the options that are invalid. *)
					invalidOptions = Cases[DeleteDuplicates[Flatten[Function[{messageName},
						(* If we're dealing with "Error::RequiredOptions", only count the options that are Null. *)
						If[MatchQ[messageName, "Error::RequiredOptions"],
							(* Only count the ones that are Null. *)
							Module[{allPossibleOptions},
								allPossibleOptions = Lookup[invalidOptionMap, messageName];

								(* We may have multiple Outputs requested from our result, so Flatten first and pull out the rules to get the options. *)
								(
									If[MemberQ[Lookup[Cases[Flatten[resolvedOptions], _Rule], #, Null], Null],
										#,
										Nothing
									]
										&) /@ allPossibleOptions
							],
							(* ELSE: Just lookup like normal. *)
							Lookup[invalidOptionMap, messageName, Null]
						]
					] /@ Keys[messageRulesGrouped]]], Except[_String | Null]];

					(* Get inputs that are invalid *)
					invalidInputs = First[Lookup[messageRulesGrouped, "Error::InvalidInput", {{}}]];

					(* Drop the invalid input messages *)
					messageRulesWithoutInvalidInput = KeyDrop[messageRulesGrouped, "Error::InvalidInput"];

					(* Throw Error::RequiredOptions separately. This is so that we can delete duplicates on the first `1`. *)
					messageRulesWithoutRequiredOptions = If[KeyExistsQ[messageRulesWithoutInvalidInput, "Error::RequiredOptions"],
						Message[
							Error::RequiredOptions,
							(* Flatten all of the options that are required. *)
							ToString[DeleteDuplicates[Flatten[messageRulesWithoutInvalidInput["Error::RequiredOptions"][[1]]]]],

							(* Also delete duplicates for the inputs. *)
							ToString[DeleteDuplicates[Flatten[messageRulesWithoutInvalidInput["Error::RequiredOptions"][[2]]]]]
						];
						KeyDrop[messageRulesWithoutInvalidInput, "Error::RequiredOptions"],
						messageRulesWithoutInvalidInput
					];

					(* Throw the listable versions of the Error and Warning messages. *)
					(
						Module[{messageName, messageContents, messageNameHead, messageNameTag},
							messageName = #[[1]];
							messageContents = #[[2]];

							(* First, get the message name head and tag.*)
							messageNameHead = ToExpression[First[StringCases[messageName, x___ ~~ "::" ~~ ___ :> x]]];
							messageNameTag = First[StringCases[messageName, ___ ~~ "::" ~~ x___ :> x]];

							(* Ignore Warning::UnknownOption since this is quieted in RunUnitTest but we're catching all messages. *)
							(* Also ignore Error::UnsupportedPolymers *)
							If[!MatchQ[messageName, "Warning::UnknownOption" | "Error::UnsupportedPolymers"],
								(* Throw the listable message. *)
								With[{insertMe1 = messageNameHead, insertMe2 = messageNameTag}, Message[MessageName[insertMe1, insertMe2], Sequence @@ (ToString[DeleteDuplicates[#]]& /@ messageContents)]];
							];

						] &
					) /@ Normal[messageRulesWithoutRequiredOptions];



					(* Did the tests pass? *)
					passingQs = Lookup[testEvaluationData, "Result"];

					(* Did the tests throw messages? (Either directly, or captured) *)
					messagesQs = MapThread[
						!MatchQ[{#1, #2}, {{}, {}}] &,
						{Lookup[testEvaluationData, "Messages"], testMessageData}
					];

					(* If VOQ didn't pass but also didn't throw any messages, call again with Verbose -> Failures to display the failures VOQ style *)
					MapThread[
						Function[{tests, passingQ, messageQ},
							If[!passingQ && !messageQ,
								RunUnitTest[<|"Function" -> tests|>, Verbose -> Failures]
							]
						],
						{voqTestLists, passingQs, messagesQs}
					];

					(* Return the VOQ results, invalid inputs and options *)
					{passingQs, invalidInputs, invalidOptions}
				];

				(* Return the VOQ results and the tests *)
				{voqResults, Flatten[voqTestLists], invalidInputs, invalidOptions}
			];


			(* Combine the lists of invalid inputs and invalid options *)
			allInvalidInputs = DeleteDuplicates[Join[resolvedOptionsInvalidInputs, voqInvalidInputs]];
			allInvalidOptions = Sort[DeleteDuplicates[Join[resolvedOptionsInvalidOptions, voqInvalidOptions]]];

			If[Length[allInvalidInputs] > 0,
				Message[Error::InvalidInput, ToString[allInvalidInputs]];
			];

			If[Length[allInvalidOptions] > 0,
				Message[Error::InvalidOption, ToString[allInvalidOptions]];
			];

			(* --- Generate rules for each possible Output value ---  *)
			(* Preview  *)
			previewRule = Preview -> Null;

			(* Options *)
			optionsRule = Options -> If[MemberQ[output, Options],
				collapsedResolvedOptions,
				Null
			];

			(* Tests *)
			testsRule = Tests -> If[MemberQ[output, Tests],
				Join[safeOptionTests, validLengthTests, voqTests],
				Null
			];

			(* Result *)
			resultRule = Result -> If[MemberQ[output, Result],
				Module[
					{allUploadPackets, uploadResult},

					(* If we failed to resolve options, return Null *)
					If[Or[Length[allInvalidInputs] > 0, Length[allInvalidOptions] > 0],
						Return[Null, Module]
					];

					(* Otherwise combine all the upload packets *)
					allUploadPackets = Flatten[{uploadPackets, auxilliaryPackets}];

					(* If not uploading, return the packets *)
					If[!TrueQ[Lookup[safeOptions, Upload]],
						Return[allUploadPackets, Module]
					];

					(* Perform the upload *)
					uploadResult = Upload[allUploadPackets];

					(* If upload was successful, return the list of core objects created/modified. Otherwise return Null *)
					If[MatchQ[uploadResult, {ObjectReferenceP[]...}],
						Cases[uploadResult, ObjectP[myType]],
						Null
					]
				],

				Null
			];

			(* return the output as requested *)
			outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
		];

		(* Install the singleton overload. *)
		myFunction[myInput : singletonFunctionPattern, myOptions : OptionsPattern[myFunction]] := Replace[
			myFunction[{myInput}, myOptions],
			(* Remove the listedness of any molecule in the Result *)
			x : {ObjectReferenceP[myType]} :> First[x]
		];

	]
];


(* ::Subsubsection::Closed:: *)
(*resolveDefaultUploadFunctionOptions*)

(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveDefaultUploadFunctionOptions[myType_, myInput:{___}, myOptions_, rawOptions_] := Module[
	{result},

	(* Map over the singleton function - this is legacy code *)
	result = MapThread[resolveDefaultUploadFunctionOptions[myType, #1, #2, #3] &, {myInput, myOptions, rawOptions}];

	(* Return the output in the expected format *)
	<|
		Result -> result,
		InvalidInputs -> {},
		InvalidOptions -> {}
	|>
];

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveDefaultUploadFunctionOptions[myType_, myName_String, myOptions_, rawOptions_]:=Module[
	{myOptionsAssociation, myOptionsWithName, myFinalizedOptions},

	(* Convert the options to an association. *)
	myOptionsAssociation=Association @@ myOptions;

	(* This option resolver is a little unusual in that we have to AutoFill the options in order to compute *)
	(* either the tests or the results. *)

	(* -- AutoFill based on the information we're given. -- *)
	(* Overwrite the Name option if it is Null. *)
	myOptionsWithName=If[MatchQ[Lookup[myOptionsAssociation, Name], Null],
		Append[myOptionsAssociation, Name -> myName],
		myOptionsAssociation
	];


	(* Make sure that if we have a Name and Synonyms field  that Name is apart of the Synonyms list. *)
	myFinalizedOptions=If[MatchQ[Lookup[myOptionsWithName, Synonyms], Null] || (KeyExistsQ[myOptionsWithName, Synonyms] && !MemberQ[Lookup[myOptionsWithName, Synonyms], Lookup[myOptionsWithName, Name]] && MatchQ[Lookup[myOptionsWithName, Name], _String]),
		Append[myOptionsWithName, Synonyms -> (Append[Lookup[myOptionsWithName, Synonyms] /. Null -> {}, Lookup[myOptionsWithName, Name]])],
		myOptionsWithName
	];

	(* Return our options. *)
	Normal[myFinalizedOptions]
];

(* Helper function to resolve the options to our function. *)

(* Core overload *)
resolveDefaultUploadFunctionOptions[myType_, myInput:ObjectP[], myOptions_, rawOptions_]:=Module[
	{objectPacket, fields, resolvedOptions},

	(* Lookup our packet from our cache. *)
	objectPacket=Experiment`Private`fetchPacketFromCache[myInput, Lookup[ToList[myOptions], Cache]];

	(* Get the definition of this type. *)
	fields=Association@Lookup[LookupTypeDefinition[myType], Fields];

	(* For each of our options, see if it exists as a field of the same name in the object. *)
	resolvedOptions=Association@KeyValueMap[
		Function[{fieldSymbol, fieldValue},
			Module[{fieldDefinition, formattedFieldValue},
				(* If field does not exist as an option do not include it in the resolved options *)
				If[!KeyExistsQ[myOptions, fieldSymbol],
					Nothing,

					(* If the user has specified this option, use that. *)
					If[KeyExistsQ[rawOptions, fieldSymbol],
						fieldSymbol -> Lookup[rawOptions, fieldSymbol],

						(* ELSE: Get the information about this specific field. *)
						fieldDefinition=Association@Lookup[fields, fieldSymbol];

						(* Strip off all links from our value. *)
						formattedFieldValue=ReplaceAll[fieldValue, link_Link :> RemoveLinkID[link]];

						(* Based on the class of our field, we have to format the values differently. *)
						Switch[{fieldSymbol, Lookup[fieldDefinition, Class]},
							{_, Computable},
							Nothing,
							{_, {_Rule..}}, (* Named Multiple *)
							fieldSymbol -> ReplaceAll[formattedFieldValue[[All, 2]], {} -> Null],
							{NFPA, _},
							fieldSymbol -> formattedFieldValue,
							_,
							fieldSymbol -> ReplaceAll[formattedFieldValue, {} -> Null]
						]
					]
				]
			]
		],
		Association@objectPacket
	];

	(* Return our resolved options as a list. *)
	Normal[resolvedOptions]
];

(* ::Subsubsection::Closed:: *)
(* generateDefaultUploadFunctionAuxilliaryPackets *)

(* Function simply returns an empty list *)
(* This makes implementation easier rather than conditionally writing the main function definition *)
generateDefaultUploadFunctionAuxilliaryPackets[___] := {};


(* ::Subsection::Closed:: *)
(* combineEHSFields *)

(* This overload doesn't take in any historical amounts to determine whether it's gone over the required threshold. *)
(* So, if you add one drop of acid into the solution, it will become Acid->True. This overload is only used for option *)
(* resolving in UploadSampleModel/UploadSample/UploadSampleTransfer/ExperimentTransfer to be extra safe since we want the user to tell us if things are okay. *)
combineEHSFields[ehsField_, sourceEHSValue_, destinationEHSValue_]:=Module[{},
	(* Note: If an EHS field gets added to the Object, it must be added to this merger function: *)
	ehsField -> Switch[ehsField,
		(* State has its own hierarchy: Liquid overrule Solid, then Gas if present. *)
		State,
		FirstCase[{Liquid, Solid, Gas, Null}, sourceEHSValue | destinationEHSValue, Null],
		(* CellType has its own hierarchy: Mammalian>Yeast>Bacteria, the same logic in UploadSampleModel *)
		CellType,
		FirstCase[{Mammalian, Yeast, Bacterial}, sourceEHSValue | destinationEHSValue, Null],

		(* BiosafetyLevel has its own hierarchy: *)
		BiosafetyLevel,
		FirstCase[{"BSL-4", "BSL-3", "BSL-2", "BSL-1"}, sourceEHSValue | destinationEHSValue, Null],

		(* double gloved doesn't care about % and just inherits any True if present *)
		DoubleGloveRequired,
		Or@@Map[MatchQ[#,True]&,{sourceEHSValue,destinationEHSValue}],

		(* PipettingMethod has its own hierarchy: *)
		PipettingMethod,
		(* First try to pick out of the hierarchy, from most to least conservative: *)
		FirstCase[
			{
				Model[Method, Pipetting, "id:AEqRl9KqjO4R"], (*Model[Method, Pipetting, "Organic High Viscosity"]*)
				Model[Method, Pipetting, "id:L8kPEjnkBZL4"], (*Model[Method, Pipetting, "Organic"]*)
				Model[Method, Pipetting, "id:4pO6dM5OV9vr"], (*Model[Method, Pipetting, "Organic Low Viscosity"],*)
				Model[Method, Pipetting, "id:xRO9n3BONYkj"], (*Model[Method, Pipetting, "Organic Low Volume"]*)
				Model[Method, Pipetting, "id:R8e1PjpeL6DJ"], (*Model[Method, Pipetting, "Aqueous High Viscosity"]*)
				Model[Method, Pipetting, "id:qdkmxzqkJlw1"], (*Model[Method, Pipetting, "Aqueous"]*)
				Model[Method, Pipetting, "id:54n6evLnXzxG"], (*Model[Method, Pipetting, "Aqueous Low Viscosity"]*)
				Model[Method, Pipetting, "id:wqW9BP7WbvjG"](*Model[Method, Pipetting, "Aqueous Low Volume"]*)
			},
			ObjectP[sourceEHSValue] | ObjectP[destinationEHSValue], (* Note: ObjectP may use Download[] to check an ID vs a Name *)
			(* If we aren't in the ECL defined hierarchy of pipetting methods (we have a custom method), use our custom method. *)
			FirstCase[{sourceEHSValue, destinationEHSValue}, ObjectP[Model[Method, Pipetting]], Null]
		],

		(* Fields gets combined: *)
		IncompatibleMaterials,
		Module[{combinedMaterials},
			combinedMaterials=DeleteDuplicates[Flatten[{sourceEHSValue, destinationEHSValue}]];

			(* If we have more than one, get rid of None: *)
			If[Length[combinedMaterials] > 1,
				Cases[combinedMaterials, Except[None]],
				combinedMaterials
			]
		],

		(* Fields that False wins out over True: *)
		Sterile | DrainDisposal | Anhydrous | AsepticHandling,
		FirstCase[{False, Null, True}, sourceEHSValue | destinationEHSValue, Null],

		(* Fields that True wins out over False|Null: *)
		Expires | Radioactive | Ventilated | Pungent | Flammable | Acid | Base | Pyrophoric | WaterReactive | Fuming | HazardousBan | ExpirationHazard | ParticularlyHazardousSubstance | MSDSRequired | LightSensitive | LiquidHandlerIncompatible | UltrasonicIncompatible,
		FirstCase[{True, False, Null}, sourceEHSValue | destinationEHSValue, Null],

		(* Fields that the Min wins out: *)
		ShelfLife | UnsealedShelfLife,
		(* If we have a Null, go with the value: *)
		If[MemberQ[{sourceEHSValue, destinationEHSValue}, Null | $Failed],
			FirstCase[{sourceEHSValue, destinationEHSValue}, _?NumericQ, Null],
			Min[{sourceEHSValue, destinationEHSValue}]
		],

		(* Fields that get Nulled if there are competing values: *)
		MSDSFile | DOTHazardClass,
		(* If we have a Null, go with the value: *)
		If[MemberQ[{sourceEHSValue, destinationEHSValue}, Null | $Failed],
			FirstCase[{sourceEHSValue, destinationEHSValue}, Except[Null | $Failed], Null],
			Null
		],

		(* Gets combined by index: *)
		NFPA,
		(* If we have a Null, go with the value: *)
		If[MemberQ[{sourceEHSValue, destinationEHSValue}, (Null | $Failed)],
			FirstCase[{sourceEHSValue, destinationEHSValue}, Except[Null | $Failed], Null],
			(* Both fields are not Null, combine: *)
			{
				Health -> Max[Lookup[sourceEHSValue, Health, Null], Lookup[destinationEHSValue, Health, Null]],

				Flammability -> Max[Lookup[sourceEHSValue, Flammability, Null], Lookup[destinationEHSValue, Flammability, Null]],

				Reactivity -> Max[Lookup[sourceEHSValue, Reactivity, Null], Lookup[destinationEHSValue, Reactivity, Null]],

				Special -> With[{listsCombined=DeleteDuplicates[Flatten[{Lookup[sourceEHSValue, Special, {}], Lookup[destinationEHSValue, Special, {}]}]]},
					(* Get rid of Null if we have more than 1 special condition: *)
					If[Length[listsCombined] > 1,
						Cases[listsCombined, Except[Null]],
						listsCombined
					]
				]
			}
		],
		(* Catch all *)
		_,
		sourceEHSValue
	]
];

(* this is an overload to resolve EHS fields based on the composition *)
combineEHSFields[composition:{{CompositionP | Null, ObjectP[] | Null} ...}, ehsFields:{_Symbol..}, amount:(VolumeP | MassP | CountP | Null), cache_]:=Module[
	{usedEHSField, compositionPackets, contributionPackets, density,
		initialContributionPackets, contributionScalingFactor, ehsFieldPercentages, resolvedFields, fieldDefinitions},

	(* we can not resolve storage  *)
	usedEHSField=DeleteCases[ehsFields, StorageCondition];

	(* if we were given an empty sample, fill the fields with Nulls *)
	If[MatchQ[composition, {} | {{Null, Null}}],
		Return[ReplaceRule[# -> Null& /@ usedEHSField, IncompatibleMaterials -> {Null}, Append -> False]]
	];

	(* get the composition with packets fetched from the cache *)
	(* in an ideal world ObjectP[packet] would actually work, but it doesn't *)
	(* also if we have a Null in the composition then just remove that from this guy *)
	compositionPackets=Map[
		Which[
			MatchQ[#[[2]], PacketP[]],
			{#[[1]], FirstCase[cache, ObjectP[Lookup[#[[2]], Object]]]},
			MatchQ[#[[2]], ObjectP[]],
			{#[[1]], FirstCase[cache, ObjectP[#[[2]]]]},
			NullQ[#[[2]]], Nothing,
			True, #
		]&,
		composition
	];

	(* if we have only one components - just return it's values *)
	If[Length[composition] == 1,
		Return[ # -> Lookup[compositionPackets[[1, 2]], #]& /@ usedEHSField]
	];

	(* approximate density of the sample, we don't need to be super close *)
	density=approximateDensity[compositionPackets];

	(* get contribution of each of the components of the Composition to the sample as a mass percent *)
	initialContributionPackets=Map[Function[{inputPair}, Module[
		{concentration, packet},
		{concentration, packet}=inputPair;
		{
			Switch[concentration,
				Null, 0,
				(* we have mol/l concentration, convert to MassPercent *)
				(_?QuantityQ | _?NumericQ)?ConcentrationQ, UnitConvert[concentration, "Moles" / "Liters"] * Lookup[packet, MolecularWeight] / density,
				(* we have g/l, convert to MassPercent *)
				(_?QuantityQ | _?NumericQ)?MassConcentrationQ, UnitConvert[concentration, "Grams" / "Liters"] / density,
				(* multiply by the density of the component and divide by the density of the sample *)
				(_?QuantityQ | _?NumericQ)?VolumePercentQ, concentration / (100 * VolumePercent) * If[MatchQ[Lookup[packet, Density], DensityP], Lookup[packet, Density], Quantity[0.997`, ("Grams") / ("Milliliters")]] / density,
				(* we already have mass %, great *)
				(_?QuantityQ | _?NumericQ)?MassPercentQ, concentration / (100 * MassPercent),
				(* confluency can not really be converted to mass % so don't add any contribution *)
				(_?QuantityQ | _?NumericQ)?PercentConfluencyQ, 0
			],
			packet
		}]], compositionPackets];

	(* get total contribution scaling factor *)
	(* for cases of {Null,X}.. just give scaling factor 1 so we don't crash *)
	contributionScalingFactor=If[EqualQ[Total[initialContributionPackets[[All, 1]]], 0], 1 , 1 / Total[initialContributionPackets[[All, 1]]]];

	(* get final contribution:packet pairs *)
	(* if we have only Null,X in the composition, give them all equal EHS percentages *)
	contributionPackets=If[MemberQ[compositionPackets[[All, 1]], Except[Null]],
		{#[[1]] * contributionScalingFactor, #[[2]]}& /@ initialContributionPackets,
		{1 / Length[compositionPackets], #[[2]]}& /@ compositionPackets];

	(* construct EHSFieldPercentage based off the composition *)
	ehsFieldPercentages=Map[Function[{field},
		Switch[field,
			(* IncompatibleMaterials are special since they are a list of things rather than a True/False *)
			(* should look like MaterialA->0.2, MaterialB->1 *)
			IncompatibleMaterials,
			field -> Module[{incompatibleMaterialsByComponent, contributionMaterials, mergedValues},
				incompatibleMaterialsByComponent=Map[Lookup[#[[2]], IncompatibleMaterials, {}]&, contributionPackets];
				(*Get a list in a form of {<|Material1->%contribution, Material2-> %Contribution|>, <|Material2->%Contribution..|>}*)
				contributionMaterials=MapThread[Function[{contribution, materials}, Association@Map[# -> contribution&, materials]], {contributionPackets[[All, 1]], incompatibleMaterialsByComponent}];
				(* merge incompatible materials totaling the amount they got *)
				mergedValues=KeyValueMap[#1 -> #2&, Merge[contributionMaterials, Total]]
			],

			(* NFPA is a list of rules, so we need to take care of them separately *)
			(* end result should be {Health->{1}, Reactivity->{1,2},..} *)
			NFPA,
			field -> KeyValueMap[#1 -> #2&, Merge[
				Map[Function[{packet},
					Association@If[NullQ@Lookup[packet, field, {}], {}, Lookup[packet, field, {}]]],
					contributionPackets[[All, 2]]],
				DeleteDuplicates[Join[#]]&]],

			(* single value that is not True/False *)
			(* Should be Value->RangeP[0,1] *)
			_,
			field -> KeyValueMap[#1 -> #2&,
				Merge[
					Map[Function[{tuple}, Lookup[tuple[[2]], field, Null] -> tuple[[1]]],
						contributionPackets],
					Total]]
		]], usedEHSField];

	(* resolve new field values using % from above and logic from another overload *)
	resolvedFields=Map[Function[{field},
		Module[{ehsFieldPercentage},

			ehsFieldPercentage=Lookup[ehsFieldPercentages, field];

			(* Based on these accumulated percentages, figure out what value we are returning*)
			field -> Switch[field,
				(* Solid and Liquid overrule Gas if present. Assume that the sample is liquid if there is more than 10% Liquid in the sample.*)
				State,
				Which[
					And[
						MemberQ[ehsFieldPercentage, Liquid -> GreaterP[0.]],
						Greater[
							Lookup[ehsFieldPercentage, Liquid] / Total[{
								Lookup[ehsFieldPercentage, Liquid, 0.],
								Lookup[ehsFieldPercentage, Solid, 0.],
								Lookup[ehsFieldPercentage, Gas, 0.]
							}],
							0.1`
						]
					],
					Liquid,
					MemberQ[ehsFieldPercentage, Solid -> _],
					Solid,
					MemberQ[ehsFieldPercentage, Gas -> _],
					Gas,
					True,
					Null
				],

				(* Simulate SampleHandling changes.*)
				(* NOTE: This should only be done for simulation purposes as we will ask the operator what the sample looks like after the transfer.*)
				SampleHandling,
				Which[
					MemberQ[ehsFieldPercentage, Slurry -> GreaterP[.25]],
					Slurry,
					MemberQ[ehsFieldPercentage, Viscous -> GreaterP[.25]],
					Viscous,
					MemberQ[ehsFieldPercentage, Paste -> GreaterP[.25]],
					Paste,
					MemberQ[ehsFieldPercentage, Liquid -> GreaterP[.25]],
					Liquid,
					MatchQ[Total[Lookup[ehsFieldPercentage, {Liquid, Slurry, Viscous, Paste}, 0]], GreaterP[.25]],
					Slurry,
					MemberQ[ehsFieldPercentage, Brittle -> _],
					Brittle,
					MemberQ[ehsFieldPercentage, Powder -> _],
					Powder,
					MemberQ[ehsFieldPercentage, Fabric -> _],
					Fabric,
					MemberQ[ehsFieldPercentage, Fixed -> _],
					Fixed,
					True,
					Null
				],

				(* If we have any bit of Mammalian, it's Mammalian if we have any bit of a Mammalian sample. Otherwise, if we have microbial, it's Microbial. *)
				CellType,
				Which[
					MemberQ[ehsFieldPercentage[[All, 1]], NonMicrobialCellTypeP],
						FirstCase[ehsFieldPercentage[[All, 1]], NonMicrobialCellTypeP],
					MemberQ[ehsFieldPercentage[[All, 1]], MicrobialCellTypeP],
						FirstCase[ehsFieldPercentage[[All, 1]], MicrobialCellTypeP],
					True,
						Null
				],

				(* BiosafetyLevel is just a hierarchy and doesn't care about percentages at all:*)
				BiosafetyLevel,
				FirstCase[{"BSL-4", "BSL-3", "BSL-2", "BSL-1"}, Alternatives @@ (ehsFieldPercentage[[All, 1]]), Null],

				(* double gloved doesn't care about % and just inherits any True if present *)
				DoubleGloveRequired,
				FirstCase[ehsFieldPercentage[[All, 1]], True, Null],

				(* PipettingMethod will take the pipetting method of the largest percentage:*)
				PipettingMethod,
				SortBy[ehsFieldPercentage, Last][[-1]][[1]],

				(* Materials are added to the larger list if they comprise more than 5%:*)
				IncompatibleMaterials,
				Module[{combinedMaterials},
					combinedMaterials=DeleteDuplicates[Cases[Flatten[Cases[ehsFieldPercentage, Verbatim[Rule][_, GreaterP[.05]]][[All, 1]]], Except[Null]]];
					(* If we have more than one, get rid of None: *)
					If[Length[combinedMaterials] > 1,
						Cases[combinedMaterials, Except[None]],
						combinedMaterials
					]
				],

				(* Fields that False wins out over True: *)
				Sterile|DrainDisposal|Anhydrous|AsepticHandling,
				Which[
					MemberQ[ehsFieldPercentage,False->_],False,
					MemberQ[ehsFieldPercentage,Null->_],Null,
					True,True
				],

				(* A drop of True will make it True:*)
				Radioactive | HazardousBan | ParticularlyHazardousSubstance | InertHandling,
				FirstCase[{True, False, Null}, Alternatives @@ (ehsFieldPercentage[[All, 1]]), Null],

				(* Cautious 5% Threshold to make it True.*)
				Flammable | Pyrophoric | WaterReactive | ExpirationHazard | MSDSRequired | LightSensitive | GloveBoxIncompatible | GloveBoxBlowerIncompatible,
				If[MemberQ[ehsFieldPercentage, True -> GreaterEqualP[.05]],
					True,
					SortBy[ehsFieldPercentage, Last][[-1]][[1]]
				],

				(* Less Cautious 10% Threshold to make it True.*)
				Expires | Ventilated | Pungent | Acid | Base | Fuming | LiquidHandlerIncompatible | UltrasonicIncompatible,
				If[MemberQ[ehsFieldPercentage, True -> GreaterEqualP[.1]],
					True,
					SortBy[ehsFieldPercentage, Last][[-1]][[1]]
				],

				(* Fields that the Min wins out:*)
				ShelfLife | UnsealedShelfLife | ExpirationDate,
				If[!MemberQ[ehsFieldPercentage[[All, 1]], _?DateObjectQ],
					Null,
					Min[Cases[ehsFieldPercentage[[All, 1]], _?DateObjectQ]]
				],

				(* Fields that get Nulled if there are competing values:*)
				MSDSFile | DOTHazardClass | TransportTemperature,
				If[Length[ehsFieldPercentage] > 1,
					Null,
					FirstOrDefault[FirstOrDefault[ehsFieldPercentage]]
				],

				(* Fields that get Nulled if there are competing values:*)
				NFPA,
				If[AnyTrue[Length[#] & /@ Values[ehsFieldPercentage], MatchQ[GreaterP[1]]],
					Null,
					Map[#[[1]] -> #[[2, 1]]&, ehsFieldPercentage]
				],

				(* Catch all*)
				_,
				SortBy[ehsFieldPercentage, Last][[-1]][[1]]
			]
		]
	], usedEHSField];

	(* do some error-correction *)
	fieldDefinitions=Lookup[LookupTypeDefinition[Model[Molecule]], Fields];
	Map[Function[{field},
		If[
			And[
				KeyExistsQ[resolvedFields, field],
				(* if field does not match it's storage pattern, make it Null *)
				!MatchQ[Lookup[resolvedFields, field], Lookup[Lookup[fieldDefinitions, field], Pattern] | Null]
				(*== If in the future we want to filter safety flags by volume/mass, make this an Or to the conditional above ==*)
				(* if we have less then 100uL/100mg of sample, do not populate certain safety fields *)
				(*And[
						MatchQ[field, (Expires | Ventilated | Pungent | Acid | Base | Fuming | LiquidHandlerIncompatible | UltrasonicIncompatible)],
						MatchQ[amount, (LessEqualP[100*Microliter]|LessEqualP[0.1*Gram])]
					]*)
			],
			field -> Null,
			field -> Lookup[resolvedFields, field]
		]],
		DeleteCases[usedEHSField, IncompatibleMaterials]]
];

(* NOTE: The existing cache is NOT a traditional object cache but has the added field EHSPercentages. *)
(* NOTE: transferAmount and destinationAmount must match. *)
combineEHSFields[ehsField_, sourceObject:ObjectP[], destinationObject:ObjectP[], transferAmount:(MassP | VolumeP), destinationAmount:(MassP | VolumeP), existingCache_List]:=Module[
	{sourcePacket, destinationPacket, sourceEHSValue, destinationEHSValue, destinationEHSPercentages, currentDestinationEHSFieldPercentages,
		amountTransferred, newDestinationEHSFieldPercentages, newDestinationEHSValue},

	(* Get our source and destination objects from our cache. *)
	sourcePacket=FirstCase[existingCache, KeyValuePattern[Object -> Download[sourceObject, Object]]];
	destinationPacket=FirstCase[existingCache, KeyValuePattern[Object -> Download[destinationObject, Object]]];

	(* Get the existing value of the EHS Field from our source and destination packet. *)
	sourceEHSValue=Lookup[sourcePacket, ehsField];
	destinationEHSValue=Lookup[destinationPacket, ehsField];

	(* Get the percentages of destination EHS Fields. We only really care about the destination since the *)
	(* transfer is from the source -> destination. *)
	destinationEHSPercentages=Lookup[destinationPacket, EHSPercentages, {}];

	(* If we don't have any destination percentages, assume that the percentage of the field value is 100%, *)
	(* aka, it's just given to us as the sample currently. *)
	(* NOTE: All of these percentages are RangeP[0,1] and don't have a Percent unit on them. *)
	currentDestinationEHSFieldPercentages=If[!KeyExistsQ[destinationEHSPercentages, ehsField],
		(* NOTE: We flatten out the field IncompatibleMaterials into its own materials. *)
		If[MatchQ[ehsField, IncompatibleMaterials],
			(# -> 1&) /@ ToList[destinationEHSValue],
			{destinationEHSValue -> 1}
		],
		Lookup[destinationEHSPercentages, ehsField]
	];

	(* Update the safety percentages. *)
	(* NOTE: We assume that the parent function passes down these in the same units. *)
	amountTransferred=Which[
		MatchQ[QuantityMagnitude[destinationAmount], 0 | 0.],
		1,

		MatchQ[destinationAmount, VolumeP] && MatchQ[transferAmount, VolumeP],
		N[transferAmount / (transferAmount + destinationAmount)],

		MatchQ[destinationAmount, MassP] && MatchQ[transferAmount, MassP],
		N[transferAmount / (transferAmount + destinationAmount)],

		MatchQ[destinationAmount, VolumeP] && MatchQ[transferAmount, MassP],
		If[MatchQ[Lookup[sourcePacket, Density], DensityP],
			N[(transferAmount / Lookup[sourcePacket, Density]) / ((transferAmount / Lookup[sourcePacket, Density]) + destinationAmount)],
			N[(transferAmount / Quantity[0.997`, ("Grams") / ("Milliliters")]) / ((transferAmount / Quantity[0.997`, ("Grams") / ("Milliliters")]) + destinationAmount)]
		],

		MatchQ[destinationAmount, MassP] && MatchQ[transferAmount, VolumeP],
		If[MatchQ[Lookup[sourcePacket, Density], DensityP],
			N[(transferAmount * Lookup[sourcePacket, Density]) / ((transferAmount * Lookup[sourcePacket, Density]) + destinationAmount)],
			N[(transferAmount * Quantity[0.997`, ("Grams") / ("Milliliters")]) / ((transferAmount * Quantity[0.997`, ("Grams") / ("Milliliters")]) + destinationAmount)]
		],

		True,
		1
	];

	(* If we already have some percentage of sourceEHSValue in our destination, we don't have to append it. *)
	(* NOTE: We flatten out the field IncompatibleMaterials into its own materials. *)
	newDestinationEHSFieldPercentages=If[MatchQ[ehsField, IncompatibleMaterials],
		If[MemberQ[currentDestinationEHSFieldPercentages, Alternatives @@ sourceEHSValue -> _],
			(
				If[MatchQ[#[[1]], Alternatives @@ ToList[sourceEHSValue]],
					#, (* Since the value that we're transferring in is amountTransferred, when you add it to (1-amountTransferred), it stays the same. *)
					#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])
				]
					&) /@ currentDestinationEHSFieldPercentages,
			Join[
				(#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])&) /@ currentDestinationEHSFieldPercentages,
				(# -> amountTransferred&) /@ ToList[sourceEHSValue]
			]
		],
		If[MemberQ[currentDestinationEHSFieldPercentages, sourceEHSValue -> _],
			(
				If[MatchQ[#[[1]], sourceEHSValue],
					#, (* Since the value that we're transferring in is amountTransferred, when you add it to (1-amountTransferred), it stays the same. *)
					#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])
				]
					&) /@ currentDestinationEHSFieldPercentages,
			Append[
				(#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])&) /@ currentDestinationEHSFieldPercentages,
				sourceEHSValue -> amountTransferred
			]
		]
	];

	(* Based on these accumulated percentages, figure out the new value of the destination's EHS field. *)
	newDestinationEHSValue=Switch[ehsField,
		(*  State has its own hierarchy: Liquid overrule Solid, then Gas if present. Assume that the sample is liquid if there is more than 10% Liquid in the sample. *)
		State,
		Which[
			And[
				MemberQ[newDestinationEHSFieldPercentages, Liquid -> GreaterP[0.]],
				Greater[
					Lookup[newDestinationEHSFieldPercentages, Liquid] / Total[{
						Lookup[newDestinationEHSFieldPercentages, Liquid, 0.],
						Lookup[newDestinationEHSFieldPercentages, Solid, 0.],
						Lookup[newDestinationEHSFieldPercentages, Gas, 0.]
					}],
					0.1`
				]
			],
			Liquid,
			MemberQ[newDestinationEHSFieldPercentages, Solid -> _],
			Solid,
			MemberQ[newDestinationEHSFieldPercentages, Gas -> _],
			Gas,
			True,
			Null
		],

		(* Simulate SampleHandling changes. *)
		(* NOTE: This should only be done for simulation purposes as we will ask the operator what the sample looks like after the transfer. *)
		SampleHandling,
		Which[
			MemberQ[newDestinationEHSFieldPercentages, Slurry -> GreaterP[.25]],
			Slurry,
			MemberQ[newDestinationEHSFieldPercentages, Viscous -> GreaterP[.25]],
			Viscous,
			MemberQ[newDestinationEHSFieldPercentages, Paste -> GreaterP[.25]],
			Paste,
			MemberQ[newDestinationEHSFieldPercentages, Liquid -> GreaterP[.25]],
			Liquid,
			MatchQ[Total[Lookup[newDestinationEHSFieldPercentages, {Liquid, Slurry, Viscous, Paste}, 0]], GreaterP[.25]],
			Slurry,
			MemberQ[newDestinationEHSFieldPercentages, Brittle -> _],
			Brittle,
			MemberQ[newDestinationEHSFieldPercentages, Powder -> _],
			Powder,
			MemberQ[newDestinationEHSFieldPercentages, Fabric -> _],
			Fabric,
			MemberQ[newDestinationEHSFieldPercentages, Fixed -> _],
			Fixed,
			True,
			Null
		],

		(* If we have any bit of Mammalian sample, it's NonMicrobial. *)
		CellType,
		Which[
			MemberQ[newDestinationEHSFieldPercentages[[All, 1]], NonMicrobialCellTypeP],
				FirstCase[newDestinationEHSFieldPercentages[[All, 1]], NonMicrobialCellTypeP],
			MemberQ[newDestinationEHSFieldPercentages[[All, 1]], MicrobialCellTypeP],
				FirstCase[newDestinationEHSFieldPercentages[[All, 1]], MicrobialCellTypeP],
			True,
				Null
		],

		(* BiosafetyLevel is just a hierarchy and doesn't care about percentages at all: *)
		BiosafetyLevel,
		FirstCase[{"BSL-4", "BSL-3", "BSL-2", "BSL-1"}, Alternatives @@ (newDestinationEHSFieldPercentages[[All, 1]]), Null],

		(* double gloved doesn't care about % and just inherits any True if present *)
		DoubleGloveRequired,
		FirstCase[newDestinationEHSFieldPercentages[[All, 1]], True, Null],

		(* PipettingMethod will take the pipetting method of the largest percentage: *)
		PipettingMethod,
		SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]],

		(* Materials are added to the larger list if they comprise more than 5%: *)
		IncompatibleMaterials,
		Module[{combinedMaterials},
			combinedMaterials = DeleteDuplicates[Cases[Flatten[Cases[newDestinationEHSFieldPercentages, Verbatim[Rule][_, GreaterP[.05]]][[All, 1]]], Except[Null]]];
			(* If we have more than one, get rid of None: *)
			If[Length[combinedMaterials] > 1,
				Cases[combinedMaterials, Except[None]],
				combinedMaterials
			]
		],

		(* Fields that False wins out over True: *)
		Sterile|DrainDisposal|Anhydrous| AsepticHandling,
		Which[
			MemberQ[newDestinationEHSFieldPercentages,False->_],False,
			MemberQ[newDestinationEHSFieldPercentages,Null->_],Null,
			True,True
		],

		(* A drop of True will make it True: *)
		Radioactive | HazardousBan | ParticularlyHazardousSubstance | InertHandling,
		FirstCase[{True, False, Null}, Alternatives @@ (newDestinationEHSFieldPercentages[[All, 1]]), Null],

		(* Cautious 5% Threshold to make it True. *)
		Flammable | Pyrophoric | WaterReactive | ExpirationHazard | MSDSRequired | LightSensitive | GloveBoxIncompatible | GloveBoxBlowerIncompatible,
		If[MemberQ[newDestinationEHSFieldPercentages, True -> GreaterEqualP[.05]],
			True,
			SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
		],

		(* Less Cautious 10% Threshold to make it True. *)
		Expires | Ventilated | Pungent | Acid | Base | Fuming | LiquidHandlerIncompatible | UltrasonicIncompatible,
		If[MemberQ[newDestinationEHSFieldPercentages, True -> GreaterEqualP[.1]],
			True,
			SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
		],

		(* Fields that the Min wins out: *)
		ShelfLife | UnsealedShelfLife | ExpirationDate,
		If[!MemberQ[newDestinationEHSFieldPercentages[[All, 1]], _?DateObjectQ],
			Null,
			Min[Cases[newDestinationEHSFieldPercentages[[All, 1]], _?DateObjectQ]]
		],

		(* Fields that get Nulled if there are competing values: *)
		MSDSFile | DOTHazardClass | NFPA | TransportTemperature,
		If[Length[newDestinationEHSFieldPercentages] > 1,
			Null,
			FirstOrDefault[FirstOrDefault[newDestinationEHSFieldPercentages]]
		],

		(* Do NOT alter the StorageCondition. *)
		StorageCondition,
		destinationEHSValue,

		(* Catch all *)
		_,
		SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
	];

	(* Return the new value and the new cache. *)
	{
		newDestinationEHSValue,

		(* Add the new destination packet. *)
		Append[
			(* Remove the old destination packet from the cache. *)
			deleteCachePacket[existingCache, destinationObject],
			Append[
				destinationPacket,
				{
					EHSPercentages -> Append[
						DeleteCases[
							destinationEHSPercentages,
							Verbatim[Rule][ehsField, _]
						],
						ehsField -> newDestinationEHSFieldPercentages
					],
					ehsField -> newDestinationEHSValue
				}
			]
		]
	}
];

(* version to work on all fields at once *)
(* NOTE: The output of this version is different as we need to return not one value but values for all fields. *)
(* NOTE: The existing cache is NOT a traditional object cache but has the added field EHSPercentages. *)
(* NOTE: transferAmount and destinationAmount must match. *)
combineEHSFields[ehsFields_List, sourceObject:ObjectP[], destinationObject:ObjectP[], transferAmount:(MassP | VolumeP), destinationAmount:(MassP | VolumeP), existingCache_List]:=Module[
	{sourcePacket, destinationPacket, destinationEHSPercentages,
		amountTransferred, newDestinationEHSValuesRules, newDestinationEHSPercentagesRules},

	(* Get our source and destination objects from our cache.*)
	sourcePacket=FirstCase[existingCache, KeyValuePattern[Object -> Download[sourceObject, Object]]];
	destinationPacket=FirstCase[existingCache, KeyValuePattern[Object -> Download[destinationObject, Object]]];

	(* NOTE: We assume that the parent function passes down these in the same units.*)
	amountTransferred=Which[
		MatchQ[QuantityMagnitude[destinationAmount], 0 | 0.],
		1,

		MatchQ[destinationAmount, VolumeP] && MatchQ[transferAmount, VolumeP],
		N[transferAmount / (transferAmount + destinationAmount)],

		MatchQ[destinationAmount, MassP] && MatchQ[transferAmount, MassP],
		N[transferAmount / (transferAmount + destinationAmount)],

		MatchQ[destinationAmount, VolumeP] && MatchQ[transferAmount, MassP],
		If[MatchQ[Lookup[sourcePacket, Density], DensityP],
			N[(transferAmount / Lookup[sourcePacket, Density]) / ((transferAmount / Lookup[sourcePacket, Density]) + destinationAmount)],
			N[(transferAmount / Quantity[0.997`, ("Grams") / ("Milliliters")]) / ((transferAmount / Quantity[0.997`, ("Grams") / ("Milliliters")]) + destinationAmount)]
		],

		MatchQ[destinationAmount, MassP] && MatchQ[transferAmount, VolumeP],
		If[MatchQ[Lookup[sourcePacket, Density], DensityP],
			N[(transferAmount * Lookup[sourcePacket, Density]) / ((transferAmount * Lookup[sourcePacket, Density]) + destinationAmount)],
			N[(transferAmount * Quantity[0.997`, ("Grams") / ("Milliliters")]) / ((transferAmount * Quantity[0.997`, ("Grams") / ("Milliliters")]) + destinationAmount)]
		],

		True,
		1
	];

	(* Get the percentages of destination EHS Fields. We only really care about the destination since the*)
	(* transfer is from the source -> destination.*)
	destinationEHSPercentages=Lookup[destinationPacket, EHSPercentages, {}];

	(* Form Field -> Value rules for the new values *)
	{newDestinationEHSValuesRules, newDestinationEHSPercentagesRules}=Transpose[
		Map[
			Function[{field},
				Module[{sourceEHSValue, destinationEHSValue, currentDestinationEHSFieldPercentages, newDestinationEHSFieldPercentages, newDestinationEHSValue},
					(* Get the existing value of the EHS Field from our source and destination packet. *)
					(* NOTE: If SampleHandling is Null, but the sample/model is a liquid, will use Liquid handling. Otherwise adding a liquid to a solid will result in solid handling. *)
					sourceEHSValue = If[
						And[
							MatchQ[Lookup[sourcePacket, Object], ObjectP[{Object[Sample], Model[Sample]}]],
							MatchQ[field, SampleHandling],
							MatchQ[Lookup[sourcePacket, field], Null],
							MatchQ[Lookup[sourcePacket, State], Liquid]
						],
						Liquid,
						Lookup[sourcePacket, field]
					];
					destinationEHSValue = If[
						And[
							MatchQ[Lookup[destinationPacket, Object], ObjectP[{Object[Sample], Model[Sample]}]],
							MatchQ[field, SampleHandling],
							MatchQ[Lookup[destinationPacket, field], Null],
							MatchQ[Lookup[destinationPacket, State], Liquid]
						],
						Liquid,
						Lookup[destinationPacket, field]
					];


					(* If we don't have any destination percentages, assume that the percentage of the field value is 100%,*)
					(* aka, it's just given to us as the sample currently.*)
					(* NOTE: All of these percentages are RangeP[0,1] and don't have a Percent unit on them.*)
					currentDestinationEHSFieldPercentages=If[!KeyExistsQ[destinationEHSPercentages, field],
						(* NOTE : We flatten out the field IncompatibleMaterials into its own materials.*)
						If[MatchQ[field, IncompatibleMaterials],
							(# -> 1&) /@ ToList[destinationEHSValue],
							{destinationEHSValue -> 1}
						],
						Lookup[destinationEHSPercentages, field]
					];

					(* Update the safety percentages.*)

					(* If we already have some percentage of sourceEHSValue in our destination, we don't have to append it.*)
					(* NOTE: We flatten out the field IncompatibleMaterials into its own materials.*)
					newDestinationEHSFieldPercentages=If[MatchQ[field, IncompatibleMaterials],
						If[MemberQ[currentDestinationEHSFieldPercentages, Alternatives @@ sourceEHSValue -> _],
							(
								If[MatchQ[#[[1]], Alternatives @@ ToList[sourceEHSValue]],
									#[[1]] -> #[[2]] + amountTransferred * (1 - #[[2]]),
									#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])
								]
									&) /@ currentDestinationEHSFieldPercentages,
							Join[
								(#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])&) /@ currentDestinationEHSFieldPercentages,
								(# -> amountTransferred&) /@ ToList[sourceEHSValue]
							]
						],
						If[MemberQ[currentDestinationEHSFieldPercentages, sourceEHSValue -> _],
							(
								If[MatchQ[#[[1]], sourceEHSValue],
									#[[1]] -> #[[2]] + amountTransferred * (1 - #[[2]]),
									#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])
								]
									&) /@ currentDestinationEHSFieldPercentages,
							Append[
								(#[[1]] -> (#[[2]] * Round[(1 - amountTransferred), 0.001])&) /@ currentDestinationEHSFieldPercentages,
								sourceEHSValue -> amountTransferred
							]
						]
					];

					(* Based on these accumulated percentages, figure out the new value of the destination's EHS field.*)
					newDestinationEHSValue=Switch[field,
						(* Solid and Liquid overrule Gas if present. Assume that the sample is liquid if there is more than 10% Liquid in the sample.*)
						State,
						Which[
							And[
								MemberQ[newDestinationEHSFieldPercentages, Liquid -> GreaterP[0.]],
								Greater[
									Lookup[newDestinationEHSFieldPercentages, Liquid] / Total[{
										Lookup[newDestinationEHSFieldPercentages, Liquid, 0.],
										Lookup[newDestinationEHSFieldPercentages, Solid, 0.],
										Lookup[newDestinationEHSFieldPercentages, Gas, 0.]
									}],
									0.1`
								]
							],
							Liquid,
							MemberQ[newDestinationEHSFieldPercentages, Solid -> _],
							Solid,
							MemberQ[newDestinationEHSFieldPercentages, Gas -> _],
							Gas,
							True,
							Null
						],

						(* Simulate SampleHandling changes.*)
						(* NOTE: This should only be done for simulation purposes as we will ask the operator what the sample looks like after the transfer.*)
						SampleHandling,
						Which[
							MemberQ[newDestinationEHSFieldPercentages, Slurry -> GreaterP[.25]],
							Slurry,
							MemberQ[newDestinationEHSFieldPercentages, Viscous -> GreaterP[.25]],
							Viscous,
							MemberQ[newDestinationEHSFieldPercentages, Paste -> GreaterP[.25]],
							Paste,
							MemberQ[newDestinationEHSFieldPercentages, Liquid -> GreaterP[.25]],
							Liquid,
							MatchQ[Total[Lookup[newDestinationEHSFieldPercentages, {Liquid, Slurry, Viscous, Paste}, 0]], GreaterP[.25]],
							Slurry,
							MemberQ[newDestinationEHSFieldPercentages, Brittle -> _],
							Brittle,
							MemberQ[newDestinationEHSFieldPercentages, Powder -> _],
							Powder,
							MemberQ[newDestinationEHSFieldPercentages, Fabric -> _],
							Fabric,
							MemberQ[newDestinationEHSFieldPercentages, Fixed -> _],
							Fixed,
							True,
							Null
						],

						(* If we have any bit of NonMicrobial sample, it's NonMicrobial. *)
						CellType,
						Which[
							MemberQ[newDestinationEHSFieldPercentages[[All, 1]], NonMicrobialCellTypeP],
								FirstCase[newDestinationEHSFieldPercentages[[All, 1]], NonMicrobialCellTypeP],
							MemberQ[newDestinationEHSFieldPercentages[[All, 1]], MicrobialCellTypeP],
								FirstCase[newDestinationEHSFieldPercentages[[All, 1]], MicrobialCellTypeP],
							True,
								Null
						],

						(* BiosafetyLevel is just a hierarchyand doesn't care about percentages at all:*)
						BiosafetyLevel,
						FirstCase[{"BSL-4", "BSL-3", "BSL-2", "BSL-1"}, Alternatives @@ (newDestinationEHSFieldPercentages[[All, 1]]), Null],

						(* double gloved doesn't care about % and just inherits any True if present *)
						DoubleGloveRequired,
						FirstCase[newDestinationEHSFieldPercentages[[All, 1]], True, Null],

						(* PipettingMethod will take the pipetting method of the largest percentage:*)
						PipettingMethod,
						SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]],

						(* Materials are added to the larger list if they comprise more than 5%:*)
						IncompatibleMaterials,
						Module[{combinedMaterials},
							combinedMaterials=DeleteDuplicates[Cases[Flatten[Cases[newDestinationEHSFieldPercentages, Verbatim[Rule][_, GreaterP[.05]]][[All, 1]]], Except[Null]]];
							(* If we have more than one, get rid of None: *)
							If[Length[combinedMaterials] > 1,
								Cases[combinedMaterials, Except[None]],
								combinedMaterials
							]
						],

						(* A drop of False or Null will make it False/Null. If both components are sterile then keep it True *)
						Sterile|DrainDisposal|Anhydrous|AsepticHandling,
						Which[
							MemberQ[newDestinationEHSFieldPercentages,False->_],False,
							MemberQ[newDestinationEHSFieldPercentages,Null->_],Null,
							True,True
						],

						(* A drop of True will make it True:*)
						Radioactive | HazardousBan | ParticularlyHazardousSubstance | InertHandling,
						FirstCase[{True, False, Null}, Alternatives @@ (newDestinationEHSFieldPercentages[[All, 1]]), Null],

						(* Cautious 5% Threshold to make it True.*)
						Flammable | Pyrophoric | WaterReactive | ExpirationHazard | MSDSRequired | LightSensitive | GloveBoxIncompatible | GloveBoxBlowerIncompatible,
						If[MemberQ[newDestinationEHSFieldPercentages, True -> GreaterEqualP[.05]],
							True,
							SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
						],

						(* Less Cautious 10% Threshold to make it True.*)
						Expires | Ventilated | Pungent | Acid | Base | Fuming | LiquidHandlerIncompatible | UltrasonicIncompatible,
						If[MemberQ[newDestinationEHSFieldPercentages, True -> GreaterEqualP[.1]],
							True,
							SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
						],

						(* Fields that the Min wins out:*)
						ShelfLife | UnsealedShelfLife | ExpirationDate,
						If[!MemberQ[newDestinationEHSFieldPercentages[[All, 1]], _?DateObjectQ],
							Null,
							Min[Cases[newDestinationEHSFieldPercentages[[All, 1]], _?DateObjectQ]]
						],

						(* Fields that get Nulled if there are competing values:*)
						MSDSFile | DOTHazardClass | NFPA | TransportTemperature,
						If[Length[newDestinationEHSFieldPercentages] > 1,
							Null,
							FirstOrDefault[FirstOrDefault[newDestinationEHSFieldPercentages]]
						],

						(* Do NOT alter the StorageCondition.*)
						StorageCondition,
						destinationEHSValue,

						(* Catch all*)
						_,
						SortBy[newDestinationEHSFieldPercentages, Last][[-1]][[1]]
					];

					{
						Rule[field, newDestinationEHSValue],
						Rule[field, newDestinationEHSFieldPercentages]
					}
				]
			],
			ehsFields
		]
	];

	(* I want this outside of the MapThread and fields should be checked if I am modifying them*)

	(*	 Return the association of new values and the new cache.*)
	{
		newDestinationEHSValuesRules,

		(* Add the new destination packet.*)
		Append[
			(* Remove the old destination packet from the cache.*)
			deleteCachePacket[existingCache, destinationObject],
			Append[
				destinationPacket,
				<|
					EHSPercentages -> Join[
						DeleteCases[
							destinationEHSPercentages,
							Verbatim[Rule][Alternatives @@ ehsFields, _]
						],
						newDestinationEHSPercentagesRules
					],
					Association[newDestinationEHSValuesRules]
				|>
			]
		]
	}
];

(* deleting packet from the cache *)
deleteCachePacket[cache_List, object_]:=Module[{objects, associationFiltered, association},
	(* grab the list of objects that we have in this cache *)
	objects=Lookup[cache, Object];

	(* make an association Object->Packet *)
	association=Association[MapThread[Rule[#1, #2] &, {objects, cache}]];

	(*drop the packet for the object*)
	associationFiltered=KeyDrop[association, Download[object, Object]];

	(*return cache without the packet*)
	Values[associationFiltered]
];

(* approximate density from composition *)
(* overload with 2 volumes passed in *)
approximateDensity[compositionTuples:{{VolumeP, PacketP[] | Null}..}]:=Module[
	{volumes, totalVolume, volumePercents, newTuples},
	volumes = compositionTuples[[All,1]];
	totalVolume = Total[volumes];
	volumePercents = If[totalVolume == 0 Liter,
		ConstantArray[0 VolumePercent, Length[volumes]],
		(# * VolumePercent / totalVolume)& /@ volumes
	];
	newTuples = Transpose@{volumePercents, compositionTuples[[All,2]]};
	approximateDensity[newTuples]
];

(* core overload *)
approximateDensity[compositionTuples:{{CompositionP | Null, PacketP[] | Null}..}]:=Module[{initialList, filteredList, initialContributions, scalingFactor, densities},
	initialList=Map[
		{
			#[[1]],
			Lookup[#[[2]], Density, Quantity[0.997`, "Grams" / "Liters"]],
			#[[2]]
		}&,
		compositionTuples
	];

	(* remove any Nulls and items of low concentration since they don't affect density much *)
	filteredList=DeleteCases[initialList,
		_?(MatchQ[First@#,
			Alternatives[
				Null,
				LessP[Quantity[5.`, "MassPercent"]],
				LessP[Quantity[5.`, "VolumePercent"]],
				LessP[Quantity[0.5`, "Moles" / "Liters"]],
				LessP[Quantity[10.`, "Grams" / "Liters"]],
				(_?QuantityQ | _?NumericQ)?PercentConfluencyQ
			]]&)];

	(* we are doing something shady here - we assume that we have 1kg and 1L of our mixture. This is not true,
	but we will get rid of the units this way and hopefully will be not completely off from the target density *)
	initialContributions=(Switch[#[[1]],
		(_?QuantityQ | _?NumericQ)?ConcentrationQ, UnitConvert[#[[1]], "Moles" / "Liters"] * Lookup[#[[3]], MolecularWeight] * Quantity[1.`, "Liters"] / Quantity[1.`, "Kilograms"],
		(_?QuantityQ | _?NumericQ)?MassConcentrationQ, UnitConvert[#[[1]], "Grams" / "Liters"] * Quantity[1.`, "Liters"] / Quantity[1.`, "Kilograms"],
		(_?QuantityQ | _?NumericQ)?VolumePercentQ, #[[1]] / (100 * VolumePercent) * If[MatchQ[Lookup[#[[3]], Density], DensityP], Lookup[#[[3]], Density], Quantity[0.997`, ("Grams") / ("Milliliters")]] * Quantity[1.`, "Liters"] / Quantity[1.`, "Kilograms"],
		(* we already have mass %, great *)
		(_?QuantityQ | _?NumericQ)?MassPercentQ, #[[1]] / (100 * MassPercent)
	])& /@ filteredList;

	(* make a scaling factor - by how much we need to multiply the # we have to get total of 100% *)
	scalingFactor=If[MatchQ[initialContributions, Null | {EqualP[0]...}], 1 , 1 / Total[initialContributions]];

	(* density of the identity models in use *)
	densities=Map[If[CompatibleUnitQ[Lookup[#, Density], "Grams" / "Liters"], Lookup[#, Density], Quantity[0.997`, ("Grams") / ("Milliliters")]]&, filteredList[[All, 3]]];

	(* return density *)
	If[
		MatchQ[densities, {}] || MatchQ[initialContributions, {EqualP[0]...}],
		Quantity[0.997`, ("Grams") / ("Milliliters")],
		UnitConvert[Total[MapThread[(#1 * scalingFactor * #2)&, {initialContributions, densities}]], "Grams" / "Liters"]]
];

DefineOptions[
	ValidObjectQMessages,
	Options :> {
		OutputOption
	}
];

(* Run VOQ tests, throwing messages instead of failing tests *)
ValidObjectQMessages[myInput_, newPacket:PacketP[], myOptions_, funcOptions:OptionsPattern[]]:=Module[
	{myType, fullChangePacket, originalPacket, nonChangePacket, packetWithoutRuleDelayed, packetTests, voqResult, failedTestSummaries, failedTestDescriptions, passedQ},

	myType=Lookup[newPacket, Type];

	(* Overwrite the Object key if our object already exists. *)
	fullChangePacket=If[MatchQ[myInput, ObjectP[myType]],
		Append[newPacket, Object -> Download[myInput, Object]],
		Append[newPacket, Object -> CreateID[myType]]
	];

	(* Strip off our change heads (Replace/Append) so that we can pretend that this is a real object so that we can call VOQ on it. *)
	(* This includes all fields to the packet as Null/{} if they weren't included in the change packet. *)
	(* If we had a previously existing packet, we merge that packet with our packet. *)

	originalPacket=If[MatchQ[myInput, ObjectP[]],
		Experiment`Private`fetchPacketFromCache[myInput, Lookup[ToList[myOptions], Cache]]
	];

	nonChangePacket=If[MatchQ[originalPacket, PacketP[]],
		stripChangePacket[fullChangePacket, ExistingPacket -> originalPacket],
		stripChangePacket[Append[fullChangePacket, Type -> myType]]
	];

	(* Get rid of any delayed rules so that we don't double upload. *)
	packetWithoutRuleDelayed=Association[Cases[Normal[nonChangePacket], Except[_RuleDelayed]]];

	(* Call VOQ, catch the messages that are thrown so that we know the corresponding InvalidOptions message to throw. *)
	packetTests=ValidObjectQ`Private`testsForPacket[packetWithoutRuleDelayed];

	(* Get the VOQ results *)
	voqResult=Block[{ECL`$UnitTestMessages=True},
		RunUnitTest[<|"Function" -> packetTests|>, OutputFormat -> TestSummary, Verbose -> False]
	];

	(* Get the test summaries for the failed tests *)
	failedTestSummaries=Flatten[Lookup[First[Lookup[voqResult, "Function"]], {ResultFailures, MessageFailures}]];

	(* Get the descriptions from failed tests *)
	failedTestDescriptions=Lookup[First /@ failedTestSummaries, Description];

	(* VOQ passes if we didn't have any messages thrown *)
	passedQ=Lookup[voqResult, "Function"][Passed];

	OptionValue[Output] /. {Result -> {passedQ, failedTestDescriptions}, Tests -> packetTests}
];

(* Authors definition for ExternalUpload`Private`approximateDensity *)
Authors[ExternalUpload`Private`approximateDensity]:={"dima", "steven", "simon.vu"};


(* ::Subsection::Closed:: *)
(*Test Data*)

(* Response from pubchem for caffeine *)


(* Expected data downloaded from pubchem for caffeine *)
caffeineData = <|
	Name -> "Caffeine",
	MolecularWeight -> 194.19 Gram / Mole,
	ExactMass -> 194.08037557` Gram / Mole,
	MolecularFormula -> "C8H10N4O2",
	Monatomic -> False,
	StructureFile -> "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/2519/record/SDF/?record_type=2d&response_type=display",
	StructureImageFile -> "https://pubchem.ncbi.nlm.nih.gov/image/imagefly.cgi?cid=2519&width=500&height=500",
	CAS -> "58-08-2",
	UNII -> "3G6A5W338E",
	IUPAC -> "1,3,7-trimethylpurine-2,6-dione",
	InChI -> "InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3",
	InChIKey -> "RYYVLZVUVIJVGH-UHFFFAOYSA-N",
	Synonyms -> {"Caffeine", "1,3,7-Trimethylxanthine", "Caffedrine", "Dexitac","Durvitan", "Vivarin"},
	State -> Solid,
	pKa -> {10.4, 14.},
	LogP -> -0.07,
	BoilingPoint -> 178 Celsius,
	VaporPressure -> Null,
	MeltingPoint -> 237.9 Celsius,
	Density -> 1.23 Gram / Centimeter^3,
	Viscosity -> Null,
	Radioactive -> False,
	ParticularlyHazardousSubstance -> False,
	MSDSRequired -> True,
	DOTHazardClass -> "Class 0",
	NFPA -> Null,
	Flammable -> False,
	Pyrophoric -> False,
	WaterReactive -> False,
	Fuming -> False,
	Ventilated -> False,
	DrainDisposal -> Null,
	LightSensitive -> False,
	Pungent -> False,
	PubChemID -> 2519,
	Molecule -> Molecule[
		{
			Atom["C", "HydrogenCount" -> 3],
			Atom["C", "HydrogenCount" -> 3],
			Atom["C", "HydrogenCount" -> 3],
			Atom["C", "HydrogenCount" -> 1],
			"C", "C", "C", "C", "N", "N", "N", "N", "O", "O"
		},
		{
			Bond[{1, 10}, "Single"],
			Bond[{2, 11}, "Single"],
			Bond[{3, 12}, "Single"],
			Bond[{4, 9}, "Aromatic"],
			Bond[{4, 10}, "Aromatic"],
			Bond[{5, 6}, "Aromatic"],
			Bond[{5, 7}, "Aromatic"],
			Bond[{5, 10}, "Aromatic"],
			Bond[{6, 9}, "Aromatic"],
			Bond[{6, 11}, "Aromatic"],
			Bond[{7, 12}, "Aromatic"],
			Bond[{7, 13}, "Double"],
			Bond[{8, 11}, "Aromatic"],
			Bond[{8, 12}, "Aromatic"],
			Bond[{8, 14}, "Double"]
		},
		{}
	],
	Acid -> Null,
	Base -> Null,
	IncompatibleMaterials -> {None}
|>;

(* Expected data downloaded from pubchem for cubane *)
cubaneData = <|
	Name -> "Cubane",
	MolecularWeight -> 104.15 Gram / Mole,
	ExactMass -> 104.062600255` Gram / Mole,
	MolecularFormula -> "C8H8",
	Monatomic -> False,
	StructureFile -> "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/136090/record/SDF/?record_type=2d&response_type=display",
	StructureImageFile -> "https://pubchem.ncbi.nlm.nih.gov/image/imagefly.cgi?cid=136090&width=500&height=500",
	CAS -> "277-10-1",
	UNII -> "Z5HM0Q7DK1",
	IUPAC -> "cubane",
	InChI -> "InChI=1S/C8H8/c1-2-5-3(1)7-4(1)6(2)8(5)7/h1-8H",
	InChIKey -> "TXWRERCHRDBNLG-UHFFFAOYSA-N",
	Synonyms -> Null,
	State -> Null,
	pKa -> Null,
	LogP -> Null,
	BoilingPoint -> Null,
	VaporPressure -> Null,
	MeltingPoint -> Null,
	Density -> Null,
	Viscosity -> Null,
	Radioactive -> False,
	ParticularlyHazardousSubstance -> False,
	MSDSRequired -> False,
	DOTHazardClass -> Null,
	NFPA -> Null,
	Flammable -> Null,
	Pyrophoric -> Null,
	WaterReactive -> Null,
	Fuming -> Null,
	Ventilated -> Null,
	DrainDisposal -> Null,
	LightSensitive -> False,
	Pungent -> False,
	PubChemID -> 136090,
	Molecule -> Molecule[
		{
			Atom["C", "HydrogenCount" -> 1],
			Atom["C", "HydrogenCount" -> 1],
			Atom["C", "HydrogenCount" -> 1],
			Atom["C", "HydrogenCount" -> 1],
			Atom["C", "HydrogenCount" -> 1],
			Atom["C", "HydrogenCount" -> 1],
			Atom["C", "HydrogenCount" -> 1],
			Atom["C", "HydrogenCount" -> 1]
		},
		{
			Bond[{1, 2}, "Single"],
			Bond[{1, 3}, "Single"],
			Bond[{1, 4}, "Single"],
			Bond[{2, 5}, "Single"],
			Bond[{2, 6}, "Single"],
			Bond[{3, 5}, "Single"],
			Bond[{3, 7}, "Single"],
			Bond[{4, 6}, "Single"],
			Bond[{4, 7}, "Single"],
			Bond[{5, 8}, "Single"],
			Bond[{6, 8}, "Single"],
			Bond[{7, 8}, "Single"]
		},
		{}
	],
	Acid -> Null,
	Base -> Null,
	IncompatibleMaterials -> {None}
|>;

(* Additional keys if SDS also scraped *)
caffeineDataSDS = Join[
	caffeineData,
	<|
		MSDSFile -> "All-sds.pdf"
	|>
];

cubaneDataSDS = Join[
	cubaneData,
	<|
		MSDSFile -> Null
	|>
];

(* Thermo SDS will be scraped from Thermo *)
caffeineDataThermo = Join[
	caffeineData,
	<|
		MSDSFile -> "thermo-sds.pdf"
	|>
];

(* Sigma SDS will be scraped from Sigma *)
caffeineDataSigma = Join[
	caffeineData,
	<|
		MSDSFile -> "sigma-sds.pdf"
	|>
];


(* Helper to convert a data association into a matchable pattern *)
patternify[assoc_Association] := AssociationMatchP[
	Map[
		Which[
			(* Use RangeP for numbers/quantities to allow a slight tolerance *)
			TrueQ[Or[UnitsQ[#], IntegerQ[#], NumericQ[#]]] && GreaterEqualQ[Unitless[#], 0],
				RangeP[0.99 * #, 1.01 * #],

			(* Reverse the range for negative values *)
			TrueQ[Or[UnitsQ[#], IntegerQ[#], NumericQ[#]]],
				RangeP[1.01 * #, 0.99 * #],

			(* Otherwise simply match the value *)
			True,
				#
		] &,
		assoc
	],
	AllowForeignKeys -> False,
	RequireAllKeys -> True
];

(* Patterns *)
caffeineDataP := patternify[caffeineData];
caffeineDataSDSP := patternify[caffeineDataSDS];
caffeineDataThermoP := patternify[caffeineDataThermo];
caffeineDataSigmaP := patternify[caffeineDataSigma];
cubaneDataP := patternify[cubaneData];
cubaneDataSDSP := patternify[cubaneDataSDS];