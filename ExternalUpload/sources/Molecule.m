(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadMolecule*)


(* ::Subsubsection::Closed:: *)
(*DefineOptions*)


DefineOptions[UploadMolecule,
	Options :> {

		(* Modify the resolution description of many options to say we'll get the value from PubChem *)
		ModifyOptions[
			MoleculeOptions,
			{
				Acid, Base,	BoilingPoint, CAS, Density,	DOTHazardClass, DoubleGloveRequired,
				DrainDisposal, ExactMass, Flammable, Fluorescent, Fuming, HazardousBan, InChI, InChIKey,
				IncompatibleMaterials, IUPAC, LightSensitive,LogP, MeltingPoint,
				MolecularFormula, MolecularWeight, Molecule, Name, NFPA, ParticularlyHazardousSubstance, pKa,
				PubChemID, Pungent, Pyrophoric, Radioactive, State, StructureFile, StructureImageFile, Synonyms,
				UNII, VaporPressure, Ventilated, Viscosity,WaterReactive
			},
			ResolutionDescription -> "If creating a new object, Automatic resolves to the value obtained from the PubChem database, otherwise Null. For existing objects, Automatic resolves to the current field value."
		],
		ModifyOptions[
			MoleculeOptions,
			{{
				OptionName -> MSDSFile,
				ResolutionDescription -> "If creating a new object, Automatic attempts to locate an SDS from a supplier website, otherwise Null. For existing objects, Automatic resolves to the current field value."
			}}
		],

		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Force,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Ignore duplicate molecule checks.",
				Category -> "Organizational Information"
			}
		]
	},

	SharedOptions :> {
		MoleculeOptions,
		ExternalUploadHiddenOptions
	}
];


(* ::Subsubsection::Closed:: *)
(*Code*)


(* ::Subsubsubsection::Closed:: *)
(*Public Function (Listable Version)*)


(* Overload for the case of no input arguments *)
UploadMolecule[myOptions:OptionsPattern[]]:=UploadMolecule[Null, myOptions];

installDefaultUploadFunction[
	UploadMolecule,
	Model[Molecule],
	InstallNameOverload -> True,
	InstallObjectOverload -> True,
	OptionResolver -> resolveUploadMoleculeOptions,
	DocumentationDefinitionNumber -> 11,
	InputPattern :> Alternatives[
		_PubChem,
		(* Numbers are interpreted as PubChem ID *)
		GreaterEqualP[1, 1],
		InChIP,
		InChIKeyP,
		CASNumberP,
		ThermoFisherURLP,
		MilliporeSigmaURLP,
		_String,
		ObjectP[Model[Molecule]],
		MoleculeP,
		Null,
		BooleanP
	],
	DuplicateObjectChecks -> {
		<|Field -> Name, Check -> Modification|>,
		<|Field -> CAS, Check -> Modification|>,
		<|Field -> InChI, Check -> Modification|>,
		<|Field -> InChIKey, Check -> Modification|>,
		<|Field -> IUPAC, Check -> Modification|>,
		<|Field -> PubChemID, Check -> Modification|>
	}
];
installDefaultValidQFunction[UploadMolecule, Model[Molecule]];
installDefaultOptionsFunction[UploadMolecule, Model[Molecule]];

(* ::Subsubsubsection::Closed:: *)
(*resolveUploadMoleculeOptions*)


Error::InputOptionMismatch = "Option `1` with value `2` does not match the supplied input for input(s): `3`. Please remove this option, or change the option to be consistent with the given input(s).";

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadMoleculeOptions[myType : Model[Molecule], myInputs_List, myMapThreadSafeOptions : {{___}..}, myMapThreadSpecifiedOptions : {{___}..}] := Module[
	{
		resolvedInputs, safeOptionsAssociations, specifiedOptionsAssociations, identifiersForPubChem, pubChemAssociationsWithInputs,
		pubChemAssociations, pubChemInvalidInputs, initiallyResolvedOptions, myOptionsWithSynonyms, finalizedOptions,
		resolvedOptions, resolvedModifyQs, identifierOptionConflictOptions,
		allInvalidOptions, safeOptionsExistingObjectDefaulted, existingObjectInvalidInputs, existingObjectInvalidOptions,
		allInvalidInputs, nonNameStringPatterns, nameInputPatternQ
	},

	(* Perform any input modifications required *)
	resolvedInputs = If[IntegerQ[#],
		(* Integers are PubChem IDs *)
		PubChem[#],
		#
	]& /@ myInputs;

	(* Check if we're modifying any of the inputs *)
	resolvedModifyQs = MatchQ[#, ObjectP[Model[Molecule]]] & /@ resolvedInputs;

	(* Convert the options to lists of associations *)
	safeOptionsAssociations = Association @@@ myMapThreadSafeOptions;
	specifiedOptionsAssociations = Association @@@ myMapThreadSpecifiedOptions;


	(* Temporary solution before a new framework is online - handle objects that we're modifying *)
	(* Resolve the options for the ones we're modifying *)
	{safeOptionsExistingObjectDefaulted, existingObjectInvalidInputs, existingObjectInvalidOptions} = Module[
		{
			modifyObjectPositions, modifyInputs, modifySafeOptions, modifySpecifiedOptions,
			modifyResolverOutput, modifyInvalidInputs, modifyInvalidOptions, updatedOptions
		},

		(* Check which positions have objects to modify in them *)
		modifyObjectPositions = Position[resolvedInputs, ObjectP[], 1];

		(* Pull out the objects to modify and their options *)
		modifyInputs = Extract[resolvedInputs, modifyObjectPositions];
		modifySafeOptions = Extract[safeOptionsAssociations, modifyObjectPositions];
		modifySpecifiedOptions = Extract[specifiedOptionsAssociations, modifyObjectPositions];

		(* Use the standard option resolver on them *)
		(* This just takes the existing values for the field and over-writes any that are specified by an option  *)
		modifyResolverOutput = resolveDefaultUploadFunctionOptions[
			Model[Molecule],
			modifyInputs,
			(* Function takes options in list of rules form *)
			Replace[modifySafeOptions, Association -> List, {2}, Heads -> True],
			Replace[modifySpecifiedOptions, Association -> List, {2}, Heads -> True]
		];

		(* Lookup the invalid inputs and options *)
		{modifyInvalidInputs, modifyInvalidOptions} = Lookup[modifyResolverOutput, {InvalidInputs, InvalidOptions}];

		(* Re-insert the modified options back into their index-matched position *)
		updatedOptions = ReplacePart[
			safeOptionsAssociations,
			AssociationThread[modifyObjectPositions, Association /@ Lookup[modifyResolverOutput, Result]]
		];

		(* Return the results *)
		{updatedOptions, modifyInvalidInputs, modifyInvalidOptions}
	];



	(* This option resolver contacts the PubChem database in an attempt to populate any blank fields *)
	(* Note that PubChem parsing is not infallible as the data has very mixed formatting *)

	(* Create a pattern to identify a name input - it's a string but not a URL, CAS number or other string identifier *)
	nonNameStringPatterns = {InChIP, InChIKeyP, URLP, CASNumberP};
	nameInputPatternQ[input_] := And[StringQ[input], !MatchQ[input, Alternatives @@ nonNameStringPatterns]];

	(* Do the pubchem parsing *)
	(* First assemble a list of identifiers to try on PubChem, in order, for each input *)
	identifiersForPubChem = MapThread[
		Function[
			{input, options},
			DeleteCases[
				DeleteDuplicates[{

					(* Try the supplied identifier first, unless it's a name. It's possible the name isn't actually a 'real' name, so we shouldn't use it in preference to a precise identifier *)
					(* Don't use a name if specified as an option *)
					If[!nameInputPatternQ[input], input, Null],
					Lookup[options, PubChemID, Null] /. x_Integer :> PubChem[x], (* PubChem option takes an integer, which needs to be wrapped in PubChem head for helper *)
					Lookup[options, InChI, Null],
					Lookup[options, InChIKey, Null],
					Lookup[options, CAS, Null],
					Lookup[options, UNII, Null],
					Lookup[options, IUPAC, Null],
					If[nameInputPatternQ[input], input, Null] (* Add the name at the end if it was supplied as an input *)
				}],
				Alternatives[Automatic, Null, ObjectP[Model[Molecule]]]
			]],
		{resolvedInputs, safeOptionsExistingObjectDefaulted}
	];

	(* Now actually call the API *)
	(* scrapeMoleculeData will try the identifiers in turn and throw any required messages *)
	(* Function returns $Failed if it can't scrape data. We can continue with empty data in many cases *)
	(* One notable exception is if the only identifiers are the inputs provided, which indicates this is likely an initial call from command center *)
	(* In that case, we'll throw a hard error if the identifier is invalid as it could be confusing to proceed otherwise *)
	{pubChemAssociations, pubChemInvalidInputs} = Module[
		{scrapingEvaluationData, allIdentifiersWereNonNameInputsQ, scrapingResult, messagesQ},

		(* Perform the scraping and capture any errors thrown *)
		scrapingEvaluationData = EvaluationData[
			scrapeMoleculeData[
				identifiersForPubChem
			]
		];

		(* Pull out the results of scraping *)
		scrapingResult = Lookup[scrapingEvaluationData, "Result"];

		(* Check if any messages were thrown *)
		messagesQ = !MatchQ[Lookup[scrapingEvaluationData, "Messages"], {}];

		(* Check if the identifiers supplied were all inputs to UploadMolecule (rather than options) *)
		(* But don't count names - want a soft warning in that case as it might not actually be a real name, and therefore may not serve the purpose of an identifier *)
		allIdentifiersWereNonNameInputsQ = And[
			MatchQ[identifiersForPubChem, ToList /@ resolvedInputs],
			!And @@ (nameInputPatternQ /@ resolvedInputs)
		];

		(* If not all the identifiers were inputs, return the (partial) results, with empty associations when we failed. And no invalid inputs *)
		(* Error messages were already thrown by the helper *)
		(* Otherwise, leave $Faileds in place, populate the invalid inputs and we'll exit early *)
		If[!allIdentifiersWereNonNameInputsQ,
			{
				Replace[
					scrapingResult,
					$Failed -> <||>,
					1
				],
				{}
			},

			{
				scrapingResult,
				PickList[
					resolvedInputs,
					scrapingResult,
					$Failed
				]
			}
		]
	];

	(* If there was a fatal problem with one of our inputs, return early *)
	If[MemberQ[pubChemAssociations, $Failed],
		Return[
			<|
				Result -> $Failed,
				InvalidInputs -> pubChemInvalidInputs,
				InvalidOptions -> {},
				Tests -> {}
			|>
		]
	];


	(* Ensure that the supplied input is preserved rather than overwritten by option resolution *)
	pubChemAssociationsWithInputs = MapThread[
		Function[{input, pubChemAssociation},
			Switch[input,
				(* UploadMolecule[]*)
				Null, pubChemAssociation,

				(* UploadMolecule[templateObject]*)
				ObjectP[Model[Molecule]], pubChemAssociation,

				(* UploadMolecule[molecule]*)
				MoleculeP, Merge[{<|Molecule -> input|>, pubChemAssociation}, First],

				(* UploadChemicalMode[myPubChemID] *)
				_PubChem, pubChemAssociation,

				(* UploadMolecule[inchi] *)
				InChIP, Merge[{<|InChI -> input|>, pubChemAssociation}, First],

				(* UploadMolecule[inchiKey] *)
				InChIKeyP, Merge[{<|InChIKey -> input|>, pubChemAssociation}, First],

				(* UploadMolecule[CAS] *)
				CASNumberP, Merge[{<|CAS -> input|>, pubChemAssociation}, First],

				(* UploadMolecule[thermoURL] - no merge as URL is not stored *)
				ThermoFisherURLP, pubChemAssociation,

				(* UploadMolecule[sigmaURL] - no merge as URL is not stored *)
				MilliporeSigmaURLP, pubChemAssociation,

				(* UploadMolecule[Name] - if PubChem returns a name, move it to the synonyms, and use the user input as the name *)
				_String,
				Module[{pubChemName, pubChemSynonyms, allSynonyms, pubChemAssociationWithName},

					pubChemName = Lookup[pubChemAssociation, Name, {}];

					(* look up pubchem synonyms *)
					pubChemSynonyms = Lookup[pubChemAssociation, Synonyms, {}];

					(* combine all names and synonyms for Synonyms field *)
					allSynonyms = DeleteDuplicates[Cases[Flatten[{input, pubChemName, pubChemSynonyms}], _String]];

					(* create the final  *)
					pubChemAssociationWithName = Merge[{<|Name -> input, Synonyms -> allSynonyms|>, pubChemAssociation}, First]
				]
			]
		],
		{resolvedInputs, pubChemAssociations}
	];

	(* Perform initial resolution of options. Include any custom option resolution here *)
	(* Make sure we favor the user's supplied safe options (that are not Null) over PubChem or the input. *)
	(* And ensure we only have options that are options of UploadMolecule - for example PubChem may return extra keys *)
	initiallyResolvedOptions = Module[
		{customResolvedSharedOptions, automaticallyResolvedOptionsList},

		(* Resolve certain options manually because they need custom treatment *)
		(* Options should come out index matching the inputs as {{Option -> Value, ...}, {Option -> Value, ...}, ...} *)

		(* Resolve any options within the shared option sets that need custom handling *)
		customResolvedSharedOptions = resolveCustomSharedUploadOptions[safeOptionsExistingObjectDefaulted, pubChemAssociationsWithInputs];

		(* List of options that were automatically resolved *)
		automaticallyResolvedOptionsList = Complement[
			(* All the options - filters out any superfluous keys such as from PubChem parsing *)
			Symbol /@ Keys[Options[UploadMolecule]],

			Flatten[Keys[customResolvedSharedOptions]]
		];

		(* Determine which option values to use. Manually resolved > user > PubChem and return the full resolved option sets *)
		MapThread[
			Function[{manualOptions, optionAssociation, pubChemAssociation},
				Merge[
					{manualOptions, KeyTake[optionAssociation, automaticallyResolvedOptionsList], KeyTake[pubChemAssociation, automaticallyResolvedOptionsList]},

					(* Take the first case that's not Automatic. Otherwise return Null as we didn't get a resolved value for that option *)
					FirstCase[#, Except[Automatic], Null] &
				]
			],
			{customResolvedSharedOptions, safeOptionsExistingObjectDefaulted, pubChemAssociationsWithInputs}
		]
	];

	(* Check for potential conflicts, where the input could also be specified as an option *)
	identifierOptionConflictOptions = Module[
		{identifierOptionTuples, invalidOptions},

		(* List the options to check and their patterns *)
		identifierOptionTuples = {
			{InChI, InChIP},
			{InChIKey, InChIKeyP},
			{CAS, CASNumberP},
			{Molecule, MoleculeP},
			{PubChemID, _PubChem}
		};

		(* For each identifier option in turn, check if any inputs were specified and if any of the options conflicted *)
		invalidOptions = Flatten[Map[
			Module[
				{option, optionPattern, inputOptionConflicts},

				(* Pull out the option name and pattern *)
				{option, optionPattern} = #;

				(* Check which of the inputs conflict with the option *)
				inputOptionConflicts = MapThread[
					Function[{input, options},
						And[
							MatchQ[input, optionPattern],
							!Or[
								(* Standard match *)
								MatchQ[input, Lookup[options, option]],

								(* Or options is Null/Automatic *)
								MatchQ[Lookup[options, option], Alternatives[Null, Automatic]],

								(* PubChem[x] matches x *)
								MatchQ[input, PubChem[Lookup[options, option]]]
							]
						]
					],
					{resolvedInputs, initiallyResolvedOptions}
				];

				(* Throw an error message if there's a conflict and return the invalid option *)
				If[MemberQ[inputOptionConflicts, True],
					Message[Error::InputOptionMismatch, ToString[option], Lookup[PickList[initiallyResolvedOptions, inputOptionConflicts], option], PickList[resolvedInputs, inputOptionConflicts]];
					{option},
					{}
				]
			] &,
			identifierOptionTuples
		]]
	];

	(* Make sure that if we have a Name and Synonyms field (we've filtered out Nulls above) that Name is a part of the Synonyms list. *)
	myOptionsWithSynonyms = Map[
		Function[{options},
			If[KeyExistsQ[options, Name] && KeyExistsQ[options, Synonyms],
				(* Make sure that the Name is a part of the Synonyms *)
				If[!MemberQ[options[Synonyms], options[Name]],
					(* If Name isn't in Synonyms, add it to the list. *)
					Append[options, Synonyms -> If[NullQ[options[Name]], Null, Prepend[Cases[ToList[options[Synonyms] /. Alternatives[Null, Automatic] -> {}], _String], options[Name]]]],
					(* Name is a part of Synonyms, don't do anything. *)
					options
				],
				(* We don't have to do anything if Name and Synonyms aren't both set. *)
				options
			]
		],
		initiallyResolvedOptions
	];

	(* Make sure that we don't overwrite any of the user's options. With certain exceptions *)
	(* Also convert any remaining automatics to Null *)
	finalizedOptions = Module[{combinedOptions},
		combinedOptions = Join[
			myOptionsWithSynonyms,
			KeyDrop[specifiedOptionsAssociations, {Synonyms, MSDSFile, MSDSRequired}],
			2
		];

		(* Resolve final automatics *)
		Replace[
			combinedOptions,
			Automatic -> Null,
			{2}
		]
	];


	(* Convert associations back to lists of rules *)
	resolvedOptions = Replace[finalizedOptions, Association -> List, {2}, Heads -> True];

	(* Combine all of the invalid inputs and options *)
	allInvalidInputs = Flatten[{pubChemInvalidInputs}];
	allInvalidOptions = Flatten[{identifierOptionConflictOptions}];

	(* Return the results required *)
	<|
		Result -> resolvedOptions,
		InvalidInputs -> allInvalidInputs,
		InvalidOptions -> allInvalidOptions,
		Tests -> {}
	|>
];
