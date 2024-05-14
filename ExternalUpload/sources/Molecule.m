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
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Name,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The name of the identity model.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Molecule,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Expression, Pattern :> MoleculeP | _?StructureQ | _?StrandQ, Size -> Line],
				Description -> "The chemical structure that represents this molecule.",
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
				OptionName -> UNII,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word],
				Description -> "Unique Ingredient Identifier of compounds based on the unified identification scheme of FDA.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> InChI,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> InChIP, Size -> Line, PatternTooltip -> "A valid InChI identifier that starts with InChI=."],
				Description -> "The International Chemical Identifer (InChI) that uniquely identifies this chemical species.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> InChIKey,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> InChIKeyP, Size -> Line, PatternTooltip -> "A valid InChIKey identifier in the form ##############-##########-# where # is any letter between A-Z." ],
				Description -> "The International Chemical Identifer (InChI) Key that uniquely identifies this chemical species.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> PubChemID,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> GreaterP[0, 1]],
				Description -> "The PubChem Compound ID that uniquely identifies this molecule in the PubChem database.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> CAS,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> CASNumberP, Size -> Line],
				Description -> "Chemical Abstracts Service (CAS) registry number for a chemical.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> IUPAC,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "International Union of Pure and Applied Chemistry (IUPAC) name for the substance.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> MolecularFormula,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word],
				Description -> "Chemical formula of this substance (e.g. H2O, NH2, etc.).",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Monatomic,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this molecule consists of exactly one atom (e.g. H, Au, Cd(2+) etc.).",
				Category -> "Physical Properties"
			},
			{
				OptionName -> MolecularWeight,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[(0 * Gram) / Mole],
					Units -> CompoundUnit[
						{1, {Gram, {Gram}}},
						{-1, {Mole, {Mole}}}
					]
				],
				Description -> "The molecular weight of the chemical (the mass of one mole of the molecule).",
				Category -> "Physical Properties"
			},
			{
				OptionName -> ExactMass,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[(0 * Gram) / Mole],
					Units -> CompoundUnit[
						{1, {Gram, {Gram}}},
						{-1, {Mole, {Mole}}}
					]
				],
				Description -> "The most abundant mass of the molecule calculated using the natural abundance of isotopes on Earth.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> State,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Solid, Liquid, Gas]],
				Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Density,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[(0 * Gram) / Milliliter],
					Units -> CompoundUnit[
						{1, {Gram, {Kilogram, Gram}}},
						Alternatives[
							{-3, {Meter, {Centimeter, Meter}}},
							{-1, {Liter, {Milliliter, Liter}}}
						]
					]
				],
				Description -> "Known density of pure samples of this molecule at room temperature.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> ExtinctionCoefficients,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[
					{
						"Wavelength" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 * Nanometer],
							Units -> {1, {Nanometer, {Nanometer}}}
						],
						"ExtinctionCoefficient" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Liter / (Centimeter * Mole)],
							Units -> CompoundUnit[
								{1, {Liter, {Liter}}},
								{-1, {Centimeter, {Centimeter}}},
								{-1, {Mole, {Mole}}}
							]
						]
					}
				],
				Description -> "A measure of how strongly this molecule absorbs light at a particular wavelength.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> StructureImageFile,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> String, Pattern :> URLP, Size -> Line],
					Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]]]
				],
				Description -> "The URL of an image depicting the chemical structure of the pure form of this substance.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> StructureFile,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					"URL" -> Widget[Type -> String, Pattern :> URLP, Size -> Line],
					"File Path" -> Widget[Type -> String, Pattern :> FilePathP, Size -> Line],
					"EmeraldCloudFile" -> Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]]]
				],
				Description -> "The URL of a file that represents the chemical structure of the pure form of this substance.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> MeltingPoint,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Kelvin],
					Units -> Alternatives[
						{1, {Celsius, {Celsius}}},
						{1, {Kelvin, {Kelvin}}},
						{1, {Fahrenheit, {Fahrenheit}}}
					]
				],
				Description -> "Melting temperature of the pure substance at atmospheric pressure.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> BoilingPoint,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Kelvin],
					Units -> Alternatives[
						{1, {Celsius, {Celsius}}},
						{1, {Kelvin, {Kelvin}}},
						{1, {Fahrenheit, {Fahrenheit}}}
					]
				],
				Description -> "Temperature at which the pure substance boils under atmospheric pressure.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> VaporPressure,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Kilo * Pascal],
					Units -> Alternatives[
						{1, {Pascal, {Pascal}}},
						{1, {Atmosphere, {Atmosphere}}},
						{1, {Bar, {Bar}}},
						{1, {Torr, {Torr}}}
					]
				],
				Description -> "Vapor pressure of the substance at room temperature.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Viscosity,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 * Pascal * Second^-1] | GreaterEqualP[0 * Poise],
					Units -> Alternatives[
						{1, {Poise, {Millipoise, Centipoise, Poise}}},
						CompoundUnit[
							{1, {Pascal, {Milli * Pascal, Centi * Pascal, Deci * Pascal, Pascal}}},
							{-1, {Second, {Second}}}
						]
					]
				],
				Description -> "Vapor pressure of the substance at room temperature.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> LogP,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[-Infinity, Infinity]],
				Description -> "The logarithm of the partition coefficient, which is the ratio of concentrations of a solute between the aqueous and organic phases of a biphasic solution.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> pKa,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Number, Pattern :> RangeP[-Infinity, Infinity]]],
				Description -> "The logarithmic acid dissociation constants of the substance at room temperature.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> pH,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 14]],
				Description -> "The logarithmic concentration of hydrogen ions of a pure sample of this molecule at room temperature and pressure.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Fluorescent,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates that the molecule emits a characteristic light spectra upon excitation.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> FluorescenceExcitationMaximums,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 * Nanometer], Units -> {1, {Nanometer, {Nanometer}}}]],
				Description -> "The wavelengths corresponding to the highest peak of each fluorescent moiety's excitation spectrum.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> FluorescenceEmissionMaximums,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 * Nanometer], Units -> {1, {Nanometer, {Nanometer}}}]],
				Description -> "The wavelengths corresponding to the highest peak of each fluorescent moiety's emission spectrum.",
				Category -> "Physical Properties"
			},

			{
				OptionName -> DetectionLabel,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates whether this molecule (e.g. Alexa Fluor 488) can be attached to another molecule and act as a tag that can indicate the presence and amount of the other molecule.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> AffinityLabel,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates whether this molecule can be attached to another molecule and act as a tag that can indicate the presence and amount of the other molecule (e.g. His tag).",
				Category -> "Physical Properties"
			},
			{
				OptionName -> DetectionLabels,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]]],
				Description -> "Indicates the tags (e.g. Alexa Fluor 488) that the molecule contains, which can indicate the presence and amount of the molecule. Allowed Model[Molecule] as DetectionLabels have DetectionLabel->True.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> AffinityLabels,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]]],
				Description -> "Indicates the tags (e.g. His Tag) that the molecule contains, which has high binding capacity with other materials. Allowed Model[Molecule] as AffinityLabels have AffinityLabel->True.",
				Category -> "Physical Properties"
			},

			(* Chiral Properties*)
			{
				OptionName -> Chiral,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this molecule is a enantiomer, that cannot be superposed on its mirror image by any combination of rotations and translations.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Racemic,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this molecule represents equal amounts of left- and right-handed enantiomers of a chiral molecule.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> EnantiomerForms,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]]],
				Description -> "If this molecule is racemic (Racemic -> True), indicates models for its left- and right-handed enantiomers.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> RacemicForm,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]],
				Description -> "If this molecule is one of the enantiomers (Chiral -> True), indicates the model for its racemic form.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> EnantiomerPair,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]],
				Description -> "If this molecule is racemic (Racemic -> True), indicates models for its left- and right-handed enantiomers.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> ModifyInputModel,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "When the input to UploadMolecule is a Model[Molecule] object, specify whether the input should be modified or used as a template for a new model.",
				ResolutionDescription -> "Defaults to True if the input is a Model[Molecule], and Null otherwise.",
				Category -> "Input Processing"
			}
		]
	},

	SharedOptions :> {
		IdentityModelHealthAndSafetyOptions
	},

	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> LiteratureReferences,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> Object, Pattern :> ObjectP[Object[Report, Literature]]]
				],
				Description -> "Literature references that discuss this molecule.",
				Category -> "Analysis & Reports"
			}
		]
	},

	SharedOptions :> {
		ExternalUploadHiddenOptions
	}
];


(* ::Subsubsection::Closed:: *)
(*Code*)


(* ::Subsubsubsection::Closed:: *)
(*Public Function (Listable Version)*)


Error::UploadMoleculeModelUnknownInput="The following inputs in the given list, `1`, do not match a valid input pattern for the function UploadMolecule[...]. For more information about the inputs that this function can take, evaluate ?UploadMolecule in the notebook.";

(* Overload for the case of no input arguments *)
UploadMolecule[myOptions:OptionsPattern[]]:=UploadMolecule[Null, myOptions];

UploadMolecule[myInput_, myOptions:OptionsPattern[]]:=Module[
	{listedInputs, listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests,
		knownInputPatterns, invalidInputs, expandedInputs, expandedOptions, optionName, optionValueList, expandedOptionsWithName, transposedInputsAndOptions,
		transposedInputsAndOptionsWithoutUpload, results, messages, messageRules, messageRulesGrouped,
		messageRulesWithoutInvalidInput, transposedResults, outputRules, resultRule, packetUUIDs, packetsToUpload, uploadedPackets, resultRuleWithObjects,
		invalidOptionMap, invalidOptions, messageRulesWithoutRequiredOptions, requiredOptionsMissing},

	(* Make sure we're working with a list of inputs. *)
	listedInputs=ToList[myInput];

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=If[!MatchQ[Lookup[listedOptions, Output], _Missing],
		Lookup[listedOptions, Output],
		Result
	];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTests,
		SafeOptions[UploadMolecule, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadMolecule, listedOptions, AutoCorrect -> False], Null}
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 11, Output -> {Result, Tests}],
		{ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 11], Null}
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
	outputSpecification=Lookup[safeOptions, Output];

	(* Make sure that each one of our inputs match a known input pattern. *)
	knownInputPatterns=Alternatives[
		_PubChem,
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
	];

	(* Go through our list of inputs and make sure that each of them matches a known pattern. *)
	invalidInputs=(If[!MatchQ[#, knownInputPatterns], ToString[#], Nothing]&) /@ listedInputs;

	(* If there were invalid inputs, throw an error and return $Failed. *)
	If[!MatchQ[invalidInputs, {}],
		Message[Error::UploadMoleculeModelUnknownInput, ToString[invalidInputs]];
		Message[Error::InvalidInput, ToString[invalidInputs]];
		Return[$Failed];
	];


	(*-- Otherwise, we're dealing with a listable version. Map over the inputs and options. --*)
	(*-- Basic checks of input and option validity passed. We are ready to map over the inputs and options. --*)
	(* Expand any index-matched options from OptionName\[Rule]A to OptionName\[Rule]{A,A,A,...} so that it's safe to MapThread over pairs of options, inputs when resolving/validating values *)
	{{expandedInputs}, expandedOptions}=ExpandIndexMatchedInputs[UploadMolecule, {listedInputs}, ToList[myOptions], 11];

	(* Put the option name inside of the option values list so we can easily MapThread. *)
	expandedOptionsWithName=Function[{option},
		optionName=option[[1]];
		optionValueList=option[[2]];

		(* We are given OptionName\[Rule]OptionValueList. *)
		(* We want {OptionName\[Rule]OptionValue1, OptionName\[Rule]OptionValue2, etc.} *)
		Function[{optionValue},
			optionName -> optionValue
		] /@ optionValueList
	] /@ expandedOptions;

	(* Transpose our inputs and options together. *)
	transposedInputsAndOptions=Transpose[{expandedInputs, Sequence @@ expandedOptionsWithName}];

	(* Remove any Upload\[Rule]_ in our options and append Upload\[Rule]False to every transposed list. *)
	(* This is so that we can bundle the uploads together at the end. *)
	transposedInputsAndOptionsWithoutUpload=(Append[#, Upload -> False]&) /@ (transposedInputsAndOptions /. (Upload -> _) -> Nothing);

	(* We want to get all of the messages thrown by the function while not showing them to the user. *)
	(* Internal`InheritedBlock inherits the DownValues of Message while allowing block-scoped modification. *)
	{results, messages}=Internal`InheritedBlock[{Message, $InMsg=False},
		Transpose[(
			Module[{myMessageList},
				myMessageList={};
				Unprotect[Message];

				(* Set a conditional downvalue for the Message function. *)
				(* Record the message if it has an Error:: or Warning:: head. *)
				Message[msg_, vars___]/;!$InMsg:=Block[{$InMsg=True},
					If[MatchQ[HoldForm[msg], HoldForm[MessageName[Error | Warning, _]]],
						AppendTo[myMessageList, {HoldForm[msg], vars}];
						Message[msg, vars]
					]
				];

				(* Evaluate the singleton function. Return the result along with the messages. *)
				{Quiet[uploadMoleculeModelSingleton[Sequence @@ #]], myMessageList}
			]
				&) /@ transposedInputsAndOptionsWithoutUpload]
	];

	(* Build a map of messages and which inputs they were thrown for. *)
	messageRules=Flatten@Map[
		Function[{inputMessageList},
			Function[{inputMessage},
				ToString[First[inputMessage]] -> Rest[inputMessage]
			] /@ inputMessageList
		],
		messages
	];

	(* Group together our message rules. *)
	messageRulesGrouped=Merge[
		messageRules,
		Transpose
	];

	(* Throw Error::InvalidOption based on the messages that we threw in RunUnitTest. *)
	invalidOptionMap=lookupInvalidOptionMap[Model[Molecule]];

	(* Get the options that are invalid. *)
	invalidOptions=Cases[DeleteDuplicates[Flatten[Function[{messageName},
		(* If we're dealing with "Error::RequiredOptions", only count the options that are Null. *)
		If[MatchQ[messageName, "Error::RequiredOptions"],
			(* Only count the ones that are Null. *)
			Module[{allPossibleOptions},
				allPossibleOptions=Lookup[invalidOptionMap, messageName];

				(* We may have multiple Outputs requested from our result, so Flatten first and pull out the rules to get the options. *)
				(
					If[MemberQ[Lookup[Cases[Flatten[results], _Rule], #, Null], Null],
						#,
						Nothing
					]
						&) /@ allPossibleOptions
			],
			(* ELSE: Just lookup like normal. *)
			Lookup[invalidOptionMap, messageName, Null]
		]
	] /@ Keys[messageRulesGrouped]]], Except[_String | Null]];

	If[Length[invalidOptions] > 0,
		Message[Error::InvalidOption, ToString[invalidOptions]];
	];

	(* If Error::InvalidInput is thrown, message it seperately. These error names must be present for the Command Builder to pick up on them. *)
	messageRulesWithoutInvalidInput=If[KeyExistsQ[messageRulesGrouped, "Error::InvalidInput"],
		Message[Error::InvalidInput, ToString[First[messageRulesGrouped["Error::InvalidInput"]]]];
		KeyDrop[messageRulesGrouped, "Error::InvalidInput"],
		messageRulesGrouped
	];

	(* Set up the error boolean *)
	requiredOptionsMissing=False;

	(* Throw Error::RequiredOptions separately. This is so that we can delete duplicates on the first `1`. *)
	messageRulesWithoutRequiredOptions=If[KeyExistsQ[messageRulesWithoutInvalidInput, "Error::RequiredOptions"],
		requiredOptionsMissing=True;
		Message[
			Error::RequiredOptions,
			(* Flatten all of the options that are required. *)
			ToString[DeleteDuplicates[Flatten[messageRulesWithoutInvalidInput["Error::RequiredOptions"][[1]]]]],

			(* Also delete duplicates for the inputs. *)
			ToString[DeleteDuplicates[Flatten[messageRulesWithoutInvalidInput["Error::RequiredOptions"][[2]]]]]
		];
		KeyDrop[messageRulesWithoutInvalidInput, "Error::RequiredOptions"],
		requiredOptionsMissing=False;
		messageRulesWithoutInvalidInput
	];


	(* Throw the listable versions of the Error and Warning messages. *)
	(
		Module[{messageName, messageContents, messageNameHead, messageNameTag, originalMessage, additionalInputInformation},
			messageName=#[[1]];
			messageContents=#[[2]];

			(* First, get the message name head and tag.*)
			messageNameHead=ToExpression[First[StringCases[messageName, x___~~"::"~~___ :> x]]];
			messageNameTag=First[StringCases[messageName, ___~~"::"~~x___ :> x]];

			(* Ignore Warning::UnknownOption since this is quieted in RunUnitTest but we're catching all messages. *)
			If[!MatchQ[messageName, "Warning::UnknownOption"],
				(* Throw the listable message. *)
				With[{insertMe1=messageNameHead, insertMe2=messageNameTag}, Message[MessageName[insertMe1, insertMe2], Sequence @@ (ToString[DeleteDuplicates[#]]& /@ messageContents)]];
			];

		]
			&) /@ Normal[messageRulesWithoutRequiredOptions];

	(* Transpose our result (if we have an output in a list form) and return them in the correct format. If we aren't dealing with an output list, just add a level of listing. *)
	transposedResults=If[MatchQ[outputSpecification, _List],
		Transpose[results],
		{results}
	];

	(* Generate the output rules for this output. *)
	outputRules=MapThread[
		(
			Switch[#1,
				Result,
				#1 -> #2,
				Options,
				#1 -> Normal[Merge[Association /@ #2, Identity]],
				Tests,
				#1 -> Flatten[#2],
				_,
				#1 -> #2
			]
				&),
		{ToList[outputSpecification], transposedResults}
	];

	(* Change the result rule to include the object IDs if we're uploading. *)
	resultRule=Result -> If[MemberQ[Keys[outputRules], Result] && !(Length[invalidOptions] > 0 || Length[invalidInputs] > 0) &&!TrueQ[requiredOptionsMissing],
		(* Lookup our output packets. *)
		packetsToUpload=Lookup[outputRules, Result];

		(* Upload if we're supposed to upload our packets and didn't get a Null result (a failure for one of the packets). *)
		If[Lookup[safeOptions, Upload] && !MemberQ[packetsToUpload, Null],
			Module[{allObjects, filteredObjects},
				(* Get rid of DelayedRules, then upload. *)
				allObjects=Upload[
					(Association @@ #&) /@ ReplaceAll[
						Normal /@ Flatten[packetsToUpload],
						RuleDelayed -> Rule
					]
				];

				(* Return all objects of our type. *)
				filteredObjects=DeleteDuplicates[Cases[allObjects, ObjectP[Model[Molecule]]]];

				(* If we only have one filtered object, unlist it. *)
				If[Length[filteredObjects] == 1,
					First[filteredObjects],
					filteredObjects
				]
			],
			(* ELSE: Just return our packets. *)
			packetsToUpload
		],
		Null
	];

	(* Return the output in the specification wanted. *)
	outputSpecification /. (outputRules /. (Result -> _) -> (resultRule))
];


(* ::Subsubsubsection::Closed:: *)
(*Private Function (Singleton Version)*)


uploadMoleculeModelSingleton[myInput_, myOptions:OptionsPattern[]]:=Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests,
		optionsRule, previewRule, testsRule, resultRule, templatedSafeOps, resolvedOptions,
		optionswithNFPA, optionsWithExtinctionCoefficient,
		suppliedCache, toDownload, downloadedPacket, cache, referenceObj, nfpaPacket,
		changePacket, nonChangePacket, packetTests, passedQ},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* It's a little janky, but if we are for sure modifying an existing input, we need to append the Name option here *)
	If[MatchQ[myInput,ObjectP[Model[Molecule]]]&&Lookup[listedOptions,ModifyInputModel,True],
		listedOptions=ReplaceRule[
			(* Performance should not be a huge issue here since this function reaches out to external DBs *)
			{Name->Download[myInput,Name]},
			listedOptions
		]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=SafeOptions[UploadMolecule, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests}=Switch[myInput,

		(* UploadMolecule[molecule] *)
		MoleculeP,
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 2, Output -> {Result, Tests}],

		(* UploadMolecule[myPubChemID] *)
		_PubChem,
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 3, Output -> {Result, Tests}],

		(* UploadMolecule[inchi] *)
		InChIP,
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 4, Output -> {Result, Tests}],

		(* UploadMolecule[inchiKey] *)
		InChIKeyP,
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 5, Output -> {Result, Tests}],

		(* UploadMolecule[CAS] *)
		CASNumberP,
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 6, Output -> {Result, Tests}],

		(* UploadMolecule[thermoURL] *)
		ThermoFisherURLP,
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 7, Output -> {Result, Tests}],

		(* UploadMolecule[sigmaURL] *)
		MilliporeSigmaURLP,
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 8, Output -> {Result, Tests}],

		(* UploadMolecule[templateObject] *)
		ObjectP[Model[Molecule]],
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 9, Output -> {Result, Tests}],

		(* UploadMolecule[Name] *)
		_String,
		ValidInputLengthsQ[UploadMolecule, {myInput}, listedOptions, 1, Output -> {Result, Tests}],

		(* UploadMolecule[] *)
		Null,
		ValidInputLengthsQ[UploadMolecule, {}, listedOptions, 10, Output -> {Result, Tests}]
	];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[safeOptions, Output];
	output=ToList[outputSpecification];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[Lookup[listedOptions, Output] /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* --- Download explicit cache to get information needed by resolve<Type>Options/<type>ResourcePackets --- *)
	suppliedCache=Lookup[listedOptions, Cache, {}];

	(* Create a list of objects to gather information on *)
	toDownload=Switch[myInput,
		(* If one of the string inputs was used, no objects to download *)
		_String | Null,
		{},

		(* Wrap a list around the input object *)
		ObjectP[Model[Molecule]],
		myInput,

		(* Default to downloading nothing *)
		_,
		{}
	];

	(* Gather information on the provided Objects *)
	downloadedPacket=Download[
		toDownload,
		Cache -> suppliedCache
	];

	(* Create one single cache *)
	cache=Join[suppliedCache, {downloadedPacket}];

	(* Resolve what the template object should be *)
	(* A special case is for NFPA. Storage pattern in object is a named multiple. We need to change it to a list for our purpose *)
	nfpaPacket=If[KeyExistsQ[downloadedPacket,NFPA],
		<|NFPA->Values[Lookup[downloadedPacket,NFPA]]|>,
		<||>
	];

	referenceObj=If[
		(* If there were no downloaded packets *)
		MatchQ[downloadedPacket, {}],

		(* referenceObj = Null *)
		Null,

		(* Otherwise return the object. Delete empty list or Null since we may have pattern mismatch for options if we don't do so *)
		DeleteCases[Join[downloadedPacket,nfpaPacket], Null|{}]
	];

	(* Replaces any rules that were not specified by the user with a value from the template *)
	templatedSafeOps=resolveTemplateOptions[
		UploadMolecule,
		referenceObj,
		listedOptions,
		safeOptions,
		Exclude -> {Name}
	];

	(* Get our resolved options. *)
	resolvedOptions=resolveUploadMoleculeOptions[myInput, templatedSafeOps, listedOptions];

	(* --- Generate our formatted upload packet --- *)

	(* Change any options that aren't in the same format as the field definition. *)

	(* Convert our NFPA option into a valid NFPAP. *)
	optionswithNFPA=(
		If[SameQ[NFPA, #[[1]]] && !MatchQ[#[[2]], Null],
			#[[1]] -> {Health -> #[[2]][[1]], Flammability -> #[[2]][[2]], Reactivity -> #[[2]][[3]], Special -> ToList[#[[2]][[4]]]},
			#
		]
			&) /@ resolvedOptions;

	(* Convert our named multiple field - ExtinctionCoefficient - into its correct format. *)
	optionsWithExtinctionCoefficient=(
		If[SameQ[ExtinctionCoefficients, #[[1]]],
			(* Right now, our extinction coefficient option is in the form {{myWavelength,myExtinctionCoefficient. *)
			(* We need the format to be {<|Wavelength->myWavelength,ExtinctionCoefficient->myExtinctionCoefficient|>..} *)
			#[[1]] -> Function[{myExtinctionCoefficient}, <|Wavelength -> myExtinctionCoefficient[[1]], ExtinctionCoefficient -> myExtinctionCoefficient[[2]]|>] /@ #[[2]],
			#
		]
			&) /@ optionswithNFPA;

	(* Convert our options into a change packet. *)
	changePacket=Append[
		generateChangePacket[Model[Molecule], optionsWithExtinctionCoefficient],
		Type -> Model[Molecule]
	];

	(* If the input was a Model[Molecule] and ModifyInputModel is True, upload to the existing object *)
	If[MatchQ[myInput,ObjectP[Model[Molecule]]]&&TrueQ[Lookup[optionsWithExtinctionCoefficient, ModifyInputModel]],
		changePacket[Object] = Download[myInput, Object]
	];

	(* Strip off our change heads (Replace/Append) so that we can pretend that this is a real object so that we can call VOQ on it. *)
	(* This includes all fields to the packet as Null/{} if they weren't included in the change packet. *)
	nonChangePacket=stripChangePacket[changePacket];

	(* Call VOQ, catch the messages that are thrown so that we know the corresponding InvalidOptions message to throw. *)
	packetTests=ValidObjectQ`Private`testsForPacket[nonChangePacket];

	(* VOQ passes if we didn't have any messages thrown. *)
	passedQ=Block[{ECL`$UnitTestMessages=True},
		Length[Lookup[
			EvaluationData[RunUnitTest[<|"Function" -> packetTests|>, OutputFormat -> SingleBoolean, Verbose -> False]],
			"Messages",
			{}
		]] == 0
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[UploadMolecule, resolvedOptions],
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	(* There is no preview for this function. *)
	previewRule=Preview -> Null;

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		(* Join all exisiting tests generated by helper funcctions with any additional tests *)
		Flatten[Join[safeOptionTests, validLengthTests, packetTests]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result -> If[MemberQ[output, Result] && TrueQ[passedQ],
		changePacket,
		Null
	];

	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
];


(* ::Subsubsubsection::Closed:: *)
(*resolveUploadMoleculeOptions*)


Error::InputOptionMismatch="Option `1` with value `2` does not match the supplied input for input(s): `3`. Please change these options to be consistent with the given input(s).";
Warning::SimilarMolecules="The following molecules, `1`, have a same molecular identifier as the molecules, `2`, you are trying to upload. Please use this existing molecular model if suitable.";

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadMoleculeOptions[myInput_, myOptions_, myRawOptions_, myResolveOptions:OptionsPattern[]]:=Module[
	{listedOptions, outputOption, myOptionsAssociation, testsRule, resultRule, parsedInput,
		pubChemAssociation, pubChemWithInput, mergeFunction, myOptionsWithPubChem, invalidOptions, myOptionsWithSynonyms, nonNullOptions, invalidNullOptions,
		invalidMSDSOptions, optionsWithAuthors, optionsWithAlternativeForms, optionsWithType,
		myFinalizedOptions, identifiersToLookup, myChemicalIdentifiers, myChemicalIdentifierRules, similarChemicals, similarChemicalsNotInAlternativeForms, storageInformation, defaultStorageCondition, optionsWithDimensions, specifiedTabletBool,
		specifiedTabletWeight, validTabletTests, myOptionsWithStorageCondition, myOptionsWithVentilated, myOptionsWithTemplateOptions,
		alternativeFormFields, nfpaObjectFormat, newObjectFields, nearlyResolvedOptions, resolvedModifyQ},

	(* Convert the options to this function into a list. *)
	listedOptions=ToList[myResolveOptions];

	(* Modify defaults to true if input was a Molecule, and null otherwise *)
	resolvedModifyQ=Lookup[myRawOptions, ModifyInputModel]/.{
		_Missing -> If[MatchQ[myInput,ObjectP[Model[Molecule]]],
			True,
			Null
		]
	};

	(* Extract the Output option. If we were not given the Output option, default it to Result. *)
	outputOption=If[MatchQ[listedOptions, {}],
		Result,
		Output /. listedOptions
	];

	(* Convert the options to an association. *)
	myOptionsAssociation=Association @@ myOptions;

	(* This option resolver is a little unusual in that we have to AutoFill the options in order to compute *)
	(* either the tests or the results. *)

	(* -- AutoFill based on the information we're given. -- *)

	(* First, download all of the information that we have from PubChem *)
	(* Retry our connection 3 times, if any one of the connections fail. *)
	parsedInput=Switch[myInput,
		(* UploadMolecule[] *)
		Null,
		$Failed,

		(* UploadMolecule[templateObject] *)
		(* This returns Failed as we want to use all options values to find the PubChem info instead of the template objects name or information *)
		ObjectP[Model[Molecule]],
		$Failed,

		(* Get the InChI associated with the input and parse the result *)
		MoleculeP,
		With[{insertMe=MoleculeValue[myInput, "InChI"]}, retryConnection[parseInChI[insertMe], 3]],

		(* UploadMolecule[PubChem[myPubChemID]] *)
		_PubChem,
		With[{insertMe=myInput}, retryConnection[parsePubChem[insertMe], 3]],

		(* UploadMolecule[inchi] *)
		InChIP,
		With[{insertMe=myInput}, retryConnection[parseInChI[insertMe], 3]],

		(* UploadMolecule[inchiKey] *)
		InChIKeyP,
		With[{insertMe=myInput}, retryConnection[parseChemicalIdentifier[insertMe], 3]],

		(* UploadMolecule[CAS] *)
		CASNumberP,
		With[{insertMe=myInput}, retryConnection[parseChemicalIdentifier[insertMe], 3]],

		(* UploadMolecule[thermoURL] *)
		ThermoFisherURLP,
		With[{insertMe=myInput}, retryConnection[parseThermoURL[insertMe], 3]],

		(* UploadMolecule[sigmaURL] *)
		MilliporeSigmaURLP,
		With[{insertMe=myInput}, retryConnection[parseSigmaURL[insertMe], 3]],

		(* UploadMolecule[Name] *)
		_String,
		With[{insertMe=myInput}, retryConnection[parseChemicalIdentifier[insertMe], 3]]
	];

	(* See if we were able to get anything from the input. *)
	pubChemAssociation=If[SameQ[parsedInput, $Failed],
		(* We were not able to get anything from the input. *)
		(* See if we have any identifiers from myOptions that we can jack into PubChem with. *)

		(* Note: Our parser helper functions memoize so it's okay to use them in And[...] statements *)
		(* to make sure they didn't fail. *)

		(* InChI is our preferred identifier to look up by. It's usually in PubChem. *)
		If[
			And[
				KeyExistsQ[myOptionsAssociation, InChI],
				!SameQ[myOptionsAssociation[InChI], Null],
				!SameQ[parseChemicalIdentifier[myOptionsAssociation[InChI]], $Failed]
			],
			With[{insertMe=myOptionsAssociation[InChI]}, retryConnection[parseChemicalIdentifier[insertMe], 3]],

			(* Otherwise, try to parse by CAS *)
			If[
				And[
					KeyExistsQ[myOptionsAssociation, CAS],
					!SameQ[myOptionsAssociation[CAS], Null],
					!SameQ[parseChemicalIdentifier[myOptionsAssociation[CAS]], $Failed]
				],
				With[{insertMe=myOptionsAssociation[CAS]}, retryConnection[parseChemicalIdentifier[insertMe], 3]],

				(* Otherwise, try to parse by UNII *)
				If[
					And[
						KeyExistsQ[myOptionsAssociation, UNII],
						!SameQ[myOptionsAssociation[UNII], Null],
						!SameQ[parseChemicalIdentifier[myOptionsAssociation[UNII]], $Failed]
					],
					With[{insertMe=myOptionsAssociation[UNII]}, retryConnection[parseChemicalIdentifier[insertMe], 3]],

					(* Otherwise, try to parse by IUPAC *)
					If[
						And[
							KeyExistsQ[myOptionsAssociation, IUPAC],
							!SameQ[myOptionsAssociation[IUPAC], Null],
							!SameQ[parseChemicalIdentifier[myOptionsAssociation[IUPAC]], $Failed]
						],
						With[{insertMe=myOptionsAssociation[IUPAC]}, retryConnection[parseChemicalIdentifier[insertMe], 3]],

						(* Otherwise, try to parse by Name *)
						If[
							And[
								KeyExistsQ[myOptionsAssociation, Name],
								!SameQ[myOptionsAssociation[Name], Null],
								!SameQ[parseChemicalIdentifier[myOptionsAssociation[Name]], $Failed]
							],
							With[{insertMe=myOptionsAssociation[Name]}, retryConnection[parseChemicalIdentifier[insertMe], 3]],

							(* We've run out of options here. Return an empty association. *)
							<||>
						]
					]
				]
			]
		],

		(* We were able to find information in PubChem based on our input. *)
		(* Just return that association. *)
		parsedInput
	];

	(* -- Make sure that we do not overwrite the supplied INPUT with PubChem autoresolving. -- *)
	pubChemWithInput=Switch[myInput,
		(* UploadMolecule[]*)
		Null,
		pubChemAssociation,

		(* UploadMolecule[templateObject]*)
		ObjectP[Model[Molecule]],
		pubChemAssociation,

		(* UploadMolecule[molecule]*)
		MoleculeP,
		Merge[{<|Molecule -> myInput|>, pubChemAssociation}, First],

		(* UploadChemicalMode[myPubChemID] *)
		_PubChem,
		pubChemAssociation,

		(* UploadMolecule[inchi] *)
		InChIP,
		Merge[{<|InChI -> myInput|>, pubChemAssociation}, First],

		(* UploadMolecule[inchiKey] *)
		InChIKeyP,
		Merge[{<|InChIKey -> myInput|>, pubChemAssociation}, First],

		(* UploadMolecule[CAS] *)
		CASNumberP,
		Merge[{<|CAS -> myInput|>, pubChemAssociation}, First],

		(* UploadMolecule[thermoURL] *)
		ThermoFisherURLP,
		(* No merging needed. ThermoFisherURL is not stored in Model[Molecule]. *)
		pubChemAssociation,

		(* UploadMolecule[sigmaURL] *)
		MilliporeSigmaURLP,
		(* No merging needed. MilliporeSigmaURL is not stored in Model[Molecule]. *)
		pubChemAssociation,

		(* UploadMolecule[Name] *)
		_String,
		Merge[{<|Name -> myInput|>, pubChemAssociation}, First]
	];

	(* -- Make sure that we do not overwrite any of the user's supplied OPTIONS. -- *)
	(* Define a function to do our association merge with. *)
	mergeFunction=(If[Length[#] == 1,
		(* If there's nothing to merge, just return the first element of the merged values list. *)
		First[#],
		(* Otherwise, if the First element of the list isn't null (from the myOptions list), return that. *)
		(* Otherwise, use the second element. *)
		If[!SameQ[First[#], Null],
			First[#],
			#[[2]]
		]
	]&);

	(* Make sure we favor the user's supplied options (that are not Null) over PubChem or the input. *)
	myOptionsWithPubChem=Merge[{myOptions, pubChemWithInput}, mergeFunction];

	(* Keep track of the invalid options throughout our error checking so that we only throw one big Error::InvalidOption at the end and don't overwhelm the user. *)
	invalidOptions={};

	(* Make sure the user's supplied options agree with the user's supplied input. *)
	Switch[myInput,
		(* UploadMolecule[inchi] *)
		InChIP,
		If[KeyExistsQ[myOptionsWithPubChem, InChI] && !SameQ[myOptionsWithPubChem[InChI], myInput],
			Message[Error::InputOptionMismatch, "InChI", ToString[myOptionsWithPubChem[InChI]], ToString[myInput]];
			AppendTo[invalidOptions, "InChI"];
		],
		(* UploadMolecule[inchiKey] *)
		InChIKeyP,
		If[KeyExistsQ[myOptionsWithPubChem, InChIKey] && !SameQ[myOptionsWithPubChem[InChIKey], myInput],
			Message[Error::InputOptionMismatch, "InChIKey", ToString[myOptionsWithPubChem[InChIKey]], ToString[myInput]];
			AppendTo[invalidOptions, "InChIKey"];
		],
		(* UploadMolecule[CAS] *)
		CASNumberP,
		If[KeyExistsQ[myOptionsWithPubChem, CAS] && !SameQ[myOptionsWithPubChem[CAS], myInput],
			Message[Error::InputOptionMismatch, "CAS", ToString[myOptionsWithPubChem[CAS]], ToString[myInput]];
			AppendTo[invalidOptions, "CAS"];
		],
		(* UploadMolecule[Molecule] *)
		MoleculeP,
		If[KeyExistsQ[myOptionsWithPubChem, Molecule] && !SameQ[myOptionsWithPubChem[Molecule], myInput],
			Message[Error::InputOptionMismatch, "Molecule", ToString[myOptionsWithPubChem[Molecule]], ToString[myInput]];
			AppendTo[invalidOptions, "Molecule"];
		]
	];

	(* Favor the template options over any scraped options. *)
	myOptionsWithTemplateOptions=If[MatchQ[myInput, ObjectP[Model[Molecule]]],
		Join[myOptionsWithPubChem, Association[myOptions]],
		myOptionsWithPubChem
	];

	(* Make sure that if we have a Name and Synonyms field (we've filtered out Nulls above) that Name is apart of the Synonyms list. *)
	myOptionsWithSynonyms=If[KeyExistsQ[myOptionsWithTemplateOptions, Name] && KeyExistsQ[myOptionsWithTemplateOptions, Synonyms],
		(* Make sure that the Name is apart of the Synonyms *)
		If[!MemberQ[myOptionsWithTemplateOptions[Synonyms], myOptionsWithTemplateOptions[Name]],
			(* If Name isn't in Synonyms, add it to the list. *)
			Append[myOptionsWithTemplateOptions, Synonyms -> If[NullQ[myOptionsWithTemplateOptions[Name]], Null, Prepend[ToList[myOptionsWithTemplateOptions[Synonyms]], myOptionsWithTemplateOptions[Name]]]],
			(* Name is apart of Synonyms, don't do anything. *)
			myOptionsWithTemplateOptions
		],
		(* We don't have to do anything if Name and Synonyms aren't both set. *)
		myOptionsWithTemplateOptions
	];

	(* Make sure that we don't overwrite any of the user's options. *)
	myFinalizedOptions=Join[myOptionsWithSynonyms, Association[myRawOptions]];

	(* If we are given InChI, InChIKey, CAS, or IUPAC name, search for similar alternative forms in the database. *)

	(* Lookup these chemical identifiers from our resolved options. *)
	identifiersToLookup={InChI, InChIKey, CAS, IUPAC};
	myChemicalIdentifiers=Lookup[myFinalizedOptions, identifiersToLookup];

	(* Convert this information into rule form (ex. CAS\[Rule]myCAS), filtering out missing identifiers. *)
	myChemicalIdentifierRules=MapThread[Rule, {identifiersToLookup, myChemicalIdentifiers}] /. ((_ -> _Missing) | (_ -> (Null | {Null..}))) -> Nothing;

	(* Search for chemicals if we got any identifiers. *)
	similarChemicals=If[Length[myChemicalIdentifierRules] >= 1,
		With[{insertMe=And @@ (Equal @@ #& /@ myChemicalIdentifierRules)},
			Search[Model[Molecule], insertMe]
		],
		{}
	];

	(* If we found similar chemicals, throw a warning if they are not all in the AlternativeForms. *)
	If[Length[similarChemicals] >= 1,
		Message[Warning::SimilarMolecules, ToString[similarChemicals], ToString[myInput]];
	];

	(* Almost completely resolved options *)
	nearlyResolvedOptions = Normal[myFinalizedOptions];

	(* Return resolved options *)
	ReplaceRule[nearlyResolvedOptions, {ModifyInputModel->resolvedModifyQ}]
];


(* ::Subsubsection::Closed:: *)
(*Valid Function*)


DefineOptions[ValidUploadMoleculeQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadMolecule}
];


(* Overload for the case of no input arguments *)
ValidUploadMoleculeQ[myInput___, myOptions:OptionsPattern[]]:=Module[
	{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[myOptions], Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=UploadMolecule[myInput, Sequence @@ preparedOptions];

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
	RunUnitTest[<|"ValidUploadMoleculeQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidUploadMoleculeQ"]
];


(* ::Subsubsection::Closed:: *)
(*Option Function*)


DefineOptions[UploadMoleculeOptions,
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
	SharedOptions :> {UploadMolecule}
];


UploadMoleculeOptions[myInput___, myOptions:OptionsPattern[]]:=Module[
	{listedOps, outOps, options},

	(* get the options as a list *)
	listedOps=ToList[myOptions];

	outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

	options=UploadMolecule[myInput, Sequence @@ Append[outOps, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadMolecule],
		options
	]
];
