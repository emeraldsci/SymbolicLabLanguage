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
				Description -> "The name of the molecule.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Molecule,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					"Atomic Structure" -> Widget[
						Type -> Molecule,
						Pattern :> MoleculeP
					],
					"Polymer Strand/Structure" -> Widget[Type -> Expression, Pattern :> _?StructureQ | _?StrandQ, Size -> Line]
				],
				Description -> "The chemical structure that represents this molecule.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> DefaultSampleModel,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
				Description -> "The model of sample that will be used if this molecule is specified to be used in an experiment.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Synonyms,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
				Description -> "A list of alternative names for this molecule.",
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
				Description -> "The International Chemical Identifier (InChI) that uniquely identifies this chemical species.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> InChIKey,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> InChIKeyP, Size -> Line, PatternTooltip -> "A valid InChIKey identifier in the form ##############-##########-# where # is any letter between A-Z." ],
				Description -> "The International Chemical Identifier (InChI) Key that uniquely identifies this chemical species.",
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
				Description -> "Chemical formula of this substance (e.g. H2O, NH3, etc.).",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Monatomic,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this molecule consists of exactly one atom (e.g. He).",
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
				Description -> "The ratio between mass and amount of substance for this molecule - the mass of one mole of the molecule.",
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
				Description -> "The physical state of a pure sample of this molecule at room temperature and pressure.",
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
				Description -> "The weight of sample per amount of volume for this molecule at room temperature and pressure.",
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
					"URL" -> Widget[Type -> String, Pattern :> URLP, Size -> Line],
					"File Path" -> Widget[Type -> String, Pattern :> FilePathP, Size -> Line],
					"EmeraldCloudFile" -> Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]]]
				],
				Description -> "An image depicting the chemical structure of this molecule.",
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
				Description -> "A file containing the chemical structure of this molecule.",
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
				Description -> "The temperature at which bulk sample of this molecule transitions from solid to liquid at atmospheric pressure.",
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
				Description -> "The temperature at which bulk sample of this molecule transitions from condensed phase to gas at atmospheric pressure. This occurs when the vapor pressure of the sample equals atmospheric pressure.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> VaporPressure,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 * Kilo * Pascal],
					Units -> Alternatives[
						{1, {Pascal, {Pascal}}},
						{1, {Atmosphere, {Atmosphere}}},
						{1, {Bar, {Bar}}},
						{1, {Torr, {Torr}}}
					]
				],
				Description -> "The pressure of the vapor in thermodynamic equilibrium with condensed phase for this molecule in a closed system at room temperature.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Viscosity,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 * Pascal * Second] | GreaterEqualP[0 * Poise],
					Units -> Alternatives[
						{1, {Poise, {Millipoise, Centipoise, Poise}}},
						CompoundUnit[
							{1, {Pascal, {Milli * Pascal, Centi * Pascal, Deci * Pascal, Pascal}}},
							{1, {Second, {Second}}}
						]
					]
				],
				Description -> "The dynamic viscosity of samples of this substance at room temperature and pressure, indicating how resistant it is to flow when an external force is applied.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> LogP,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[-Infinity, Infinity]],
				Description -> "The logarithm of the partition coefficient, which is the ratio of concentrations of a solute between the aqueous and organic phases of an octanol-water biphasic system.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> pKa,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Number, Pattern :> RangeP[-Infinity, Infinity]]],
				Description -> "The logarithmic acid dissociation constants of the substance at room temperature in water.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Fluorescent,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this molecule can re-emit light upon excitation.",
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
				Description -> "Indicates whether this molecule can be attached to another molecule and act as a tag for detection and quantification of that molecule through methods that don't require physical binding, such as fluorescence (e.g. Alexa Fluor 488).",
				Category -> "Physical Properties"
			},
			{
				OptionName -> AffinityLabel,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates whether this molecule can be attached to another molecule and act as a tag for detection and quantification of that molecule through physical binding (e.g. His tag).",
				Category -> "Physical Properties"
			},
			{
				OptionName -> DetectionLabels,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]]],
				Description -> "The tags that this molecule contains which enable detection and quantification of the molecule through methods that don't require physical binding, such fluorescence (e.g. Alexa Fluor 488). Model[Molecule]s can be used as DetectionLabels when they have DetectionLabel->True.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> AffinityLabels,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]]],
				Description -> "The tags that this molecule contains which enable detection and quantification of the molecule through physical binding (e.g. His tag). Model[Molecule]s can be used as DetectionLabels when they have AffinityLabel->True.",
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
				Description -> "Indicates if this molecule represents a mixture of equal amounts of the two enantiomers of a chiral molecule.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> EnantiomerForms,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]]],
				Description -> "If this model molecule is racemic (Racemic -> True), indicates the two models for the enantiomerically pure forms.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> RacemicForm,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]],
				Description -> "If this molecule represents one of a pair of enantiomers (Chiral -> True), indicates the model for its racemic form.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> EnantiomerPair,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule]]],
				Description -> "If this molecule represents one of a pair of enantiomers (Chiral -> True), indicates the model for the alternative enantiomer of this molecule.",
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
			},
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
		ExternalUploadHiddenOptions
	}
];


(* ::Subsubsection::Closed:: *)
(*Code*)


(* ::Subsubsubsection::Closed:: *)
(*Public Function (Listable Version)*)


Error::UploadMoleculeModelUnknownInput="The following inputs in the given list, `1`, do not match a valid input pattern for the function UploadMolecule[...]. For more information about the inputs that this function can take, evaluate ?UploadMolecule in the notebook.";
Error::InvalidMSDSURL="The MSDSFile URL(s) provided did not return a pdf when downloaded for inputs `1`. Please double check the URL `2`.";
Error::InvalidStructureImageFileURL="The StructureImageFile URL(s) did not return an image when downloaded for inputs `1`. Please double check the URL(s) `2`.";
Error::InvalidStructureFileURL="The StructureFile URL(s) did not return a readable file when downloaded for inputs `1`. Please double check the URL(s) `2`.";
Error::InvalidStructureImageLocalFile="The StructureImageFile path(s) provided did not return an image when imported for inputs `1`. Please double check the filepath(s) `2`.";
Error::InvalidStructureLocalFile="The StructureFile path(s) provided did not return a readable file when imported for inputs `1`. Please double check the filepath(s) `2`.";

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

	(* If Error::InvalidInput is thrown, message it separately. These error names must be present for the Command Builder to pick up on them. *)
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
		changePacket, auxilliaryPackets, nonChangePacket, packetTests, passedQ},

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
	(* Note: if we fail to resolve options due to input error, skip changePacket generation *)
	{changePacket, auxilliaryPackets}= If[!MatchQ[resolvedOptions, $Failed],
		Module[
			{
				specialOptions, packetWithoutSpecialOptions, coreUploadPacket, augmentedPacket, additionalPackets,
				msdsFieldValue, msdsPackets, structureImageFieldValue, structureImagePackets, structureFieldValue, structurePackets
			},

			(* Options to treat with a custom approach *)
			specialOptions = {MSDSFile, StructureImageFile, StructureFile};

			(* Filter those options out of the packet *)
			packetWithoutSpecialOptions = Select[optionsWithExtinctionCoefficient, !MatchQ[First[#], Alternatives @@ specialOptions] &];

			(* Convert the standard options to fields *)
			coreUploadPacket = Append[
				generateChangePacket[Model[Molecule], packetWithoutSpecialOptions],
				Type -> Model[Molecule]
			];


			(* Generate the field values for the custom fields *)
			(* MSDSFile *)
			{msdsFieldValue, msdsPackets} = Switch[Lookup[optionsWithExtinctionCoefficient, MSDSFile],
				URLP,
				Module[{localFile, cloudFilePacket},
					(* downloadAndValidateSDSURL/pathToCloudFilePacket are memoized helpers - we already downloaded the pdf when we searched for the SDS earlier to verify the URL worked *)
					(* This i) avoids a situation where the URL no longer works (rate limit etc) ii) prevents re-download, so is faster *)
					(* URL -> memoized validated local file *)
					localFile = downloadAndValidateSDSURL[Lookup[optionsWithExtinctionCoefficient, MSDSFile]];

					(* local file -> memoized cloud file packet *)
					cloudFilePacket = Quiet[pathToCloudFilePacket[localFile]];

					(* Throw message if the download/upload didn't work *)
					If[!MatchQ[cloudFilePacket, PacketP[]],
						Message[Error::InvalidMSDSURL, myInput, Lookup[optionsWithExtinctionCoefficient, MSDSFile]];
						Return[{$Failed, {}}, Module]
					];

					{Link[Lookup[cloudFilePacket, Object]], {cloudFilePacket}}
				],

				ObjectP[Object[EmeraldCloudFile]],
				{Link[Lookup[optionsWithExtinctionCoefficient, MSDSFile]], {}},

				_,
				{Lookup[optionsWithExtinctionCoefficient, MSDSFile], {}}
			];

			(* StructureImageFile - generated internally, or possibly supplied by user *)
			(* If generated internally, it's not memoized but the URL is reliable *)
			(* Handling here prevents repeated download/upload and allows validation of URL *)
			{structureImageFieldValue, structureImagePackets} = Switch[Lookup[optionsWithExtinctionCoefficient, StructureImageFile],
				URLP,
				Module[{localFile, cloudFilePacket},
					(* URL -> memoized validated local file *)
					localFile = downloadAndValidateStructureImageFileURL[Lookup[optionsWithExtinctionCoefficient, StructureImageFile]];

					(* local file -> memoized cloud file packet *)
					cloudFilePacket = Quiet[pathToCloudFilePacket[localFile]];

					(* Throw message if the upload didn't work *)
					If[!MatchQ[cloudFilePacket, PacketP[]],
						Message[Error::InvalidStructureImageFileURL, myInput, Lookup[optionsWithExtinctionCoefficient, StructureImageFile]];
						Return[{$Failed, {}}, Module]
					];

					{Link[Lookup[cloudFilePacket, Object]], {cloudFilePacket}}
				],

				FilePathP,
				Module[{validatedFile, cloudFilePacket},
					(* file path -> memoized validated file *)
					validatedFile = validateStructureImageFilePath[Lookup[optionsWithExtinctionCoefficient, StructureImageFile]];

					(* local file -> memoized cloud file packet *)
					cloudFilePacket = Quiet[pathToCloudFilePacket[validatedFile]];

					(* Throw message if the upload didn't work *)
					If[!MatchQ[cloudFilePacket, PacketP[]],
						Message[Error::InvalidStructureImageLocalFile, myInput, Lookup[optionsWithExtinctionCoefficient, StructureImageFile]];
						Return[{$Failed, {}}, Module]
					];

					{Link[Lookup[cloudFilePacket, Object]], {cloudFilePacket}}
				],

				ObjectP[Object[EmeraldCloudFile]],
				{Link[Lookup[optionsWithExtinctionCoefficient, StructureImageFile]], {}},

				_,
				{Lookup[optionsWithExtinctionCoefficient, StructureImageFile], {}}
			];

			(* StructureFile - generated internally, or possibly supplied by user *)
			(* If generated internally, it's not memoized but the URL is reliable *)
			(* Handling here prevents repeated download/upload and allows validation of URL *)
			{structureFieldValue, structurePackets} = Switch[Lookup[optionsWithExtinctionCoefficient, StructureFile],
				URLP,
				Module[{localFile, cloudFilePacket},
					(* URL -> memoized validated local file *)
					localFile = downloadAndValidateStructureFileURL[Lookup[optionsWithExtinctionCoefficient, StructureFile]];

					(* local file -> memoized cloud file packet *)
					cloudFilePacket = Quiet[pathToCloudFilePacket[localFile]];

					(* Throw message if the upload didn't work *)
					If[!MatchQ[cloudFilePacket, PacketP[]],
						Message[Error::InvalidStructureFileURL, myInput, Lookup[optionsWithExtinctionCoefficient, StructureFile]];
						Return[{$Failed, {}}, Module]
					];

					{Link[Lookup[cloudFilePacket, Object]], {cloudFilePacket}}
				],

				FilePathP,
				Module[{validatedFile, cloudFilePacket},
					(* file path -> memoized validated file *)
					validatedFile = validateStructureFilePath[Lookup[optionsWithExtinctionCoefficient, StructureFile]];

					(* local file -> memoized cloud file packet *)
					cloudFilePacket = Quiet[pathToCloudFilePacket[validatedFile]];

					(* Throw message if the upload didn't work *)
					If[!MatchQ[cloudFilePacket, PacketP[]],
						Message[Error::InvalidStructureLocalFile, myInput, Lookup[optionsWithExtinctionCoefficient, StructureFile]];
						Return[{$Failed, {}}, Module]
					];

					{Link[Lookup[cloudFilePacket, Object]], {cloudFilePacket}}
				],

				ObjectP[Object[EmeraldCloudFile]],
				{Link[Lookup[optionsWithExtinctionCoefficient, StructureFile]], {}},

				_,
				{Lookup[optionsWithExtinctionCoefficient, StructureFile], {}}
			];

			(* Add the custom fields - additional upload packets are linked to directly *)
			augmentedPacket = Join[
				coreUploadPacket,
				<|
					MSDSFile -> msdsFieldValue,
					StructureImageFile -> structureImageFieldValue,
					StructureFile ->structureFieldValue
				|>
			];

			(* Combine the additional packets for upload *)
			additionalPackets = Flatten[{msdsPackets, structureImagePackets, structurePackets}];

			(* Return the change packet and the auxilliary packets *)
			{
				augmentedPacket,
				additionalPackets
			}
		],
		{{}, {}}
	];

	(* If the input was a Model[Molecule] and ModifyInputModel is True, upload to the existing object *)
	If[MatchQ[myInput,ObjectP[Model[Molecule]]]&&TrueQ[Lookup[optionsWithExtinctionCoefficient, ModifyInputModel]],
		changePacket[Object] = Download[myInput, Object]
	];

	(* Strip off our change heads (Replace/Append) so that we can pretend that this is a real object so that we can call VOQ on it. *)
	(* This includes all fields to the packet as Null/{} if they weren't included in the change packet. *)
	nonChangePacket=If[!MatchQ[resolvedOptions, $Failed],
		stripChangePacket[changePacket],
		{}
	];

	(* Call VOQ, catch the messages that are thrown so that we know the corresponding InvalidOptions message to throw. *)
	packetTests=If[!MatchQ[resolvedOptions, $Failed],
		ValidObjectQ`Private`testsForPacket[nonChangePacket],
		{}
	];

	(* VOQ passes if we didn't have any messages thrown. *)
	(* RunUnitTest calls ClearMemoization so Block it to prevent that *)
	passedQ=Block[{ECL`$UnitTestMessages=True, ClearMemoization},
		Length[Lookup[
			EvaluationData[RunUnitTest[<|"Function" -> packetTests|>, OutputFormat -> SingleBoolean, Verbose -> False]],
			"Messages",
			{}
		]] == 0
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	(* Note: if we fail to resolve options due to input error, return the error with no options *)
	optionsRule=Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[UploadMolecule, resolvedOptions/.$Failed->{}],
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	(* There is no preview for this function. *)
	previewRule=Preview -> Null;

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		(* Join all existing tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests, validLengthTests, packetTests]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	(* This includes the auxilliary packets *)
	resultRule=Result -> If[MemberQ[output, Result] && TrueQ[passedQ],
		Flatten[{changePacket, auxilliaryPackets}],
		Null
	];

	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
];


(* ::Subsubsubsection::Closed:: *)
(*resolveUploadMoleculeOptions*)


Error::InputOptionMismatch="Option `1` with value `2` does not match the supplied input for input(s): `3`. Please remove this option, or change the option to be consistent with the given input(s).";
Error::MoleculeExists="The following existing molecules, `1`, share a molecular identifier with the inputs, `2`, you are trying to upload. Please use this existing model if suitable. If the existing molecule is unsuitable, please set the Force option to True to bypass this check.";
Error::APIConnection="A connection to the scraping API , `1`, was not able to be formed. Please try re-running this function again and check your firewall settings or any input URLs (if applicable).";

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadMoleculeOptions[myInput_, myOptions_, myRawOptions_, myResolveOptions:OptionsPattern[]]:=Module[
	{
		listedOptions, outputOption, myOptionsAssociation, parsedInput, pubChemAssociation, pubChemWithInput,
		mergeFunction, myOptionsWithPubChem, invalidOptions, myOptionsWithSynonyms, myFinalizedOptions,
		identifiersToLookup, myChemicalIdentifiers, myChemicalIdentifierRules, similarChemicals, pubChemAssociationWithName,
		myOptionsWithTemplateOptions, nearlyResolvedOptions, resolvedModifyQ, pubChemName, allSynonyms, pubChemSynonyms

	},

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
		With[{insertMe=myInput},
			Module[{thermoURL, thermoResult},
				thermoURL = parseThermoURL[insertMe];
				thermoResult = If[!MatchQ[thermoURL, $Failed],
					retryConnection[thermoURL, 3]
				];
				(* Return failed no connection after retry  *)
				If[MatchQ[thermoURL, $Failed] || MatchQ[thermoResult, $Failed],
					Message[Error::APIConnection, insertMe];
					Return[$Failed],
					thermoResult
				]
			]
		],

		(* UploadMolecule[sigmaURL] *)
		(* Spamming connection to sigma has led to blocked connection, reduce to 2 *)
		MilliporeSigmaURLP,
		With[{insertMe=myInput},
			Module[{sigmaURL, sigmaResult},
				sigmaURL = parseSigmaURL[insertMe];
				sigmaResult = If[!MatchQ[sigmaURL, $Failed],
					retryConnection[sigmaURL, 2]
				];
				(* Return failed no connection after retry  *)
				If[MatchQ[sigmaURL, $Failed] || MatchQ[sigmaResult, $Failed],
					Message[Error::APIConnection, insertMe];
					Return[$Failed],
					sigmaResult
				]
			]
		],

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
		(* if pubchem returns a name, move it to the synonyms, and use the user input as the name *)
		pubChemName = Lookup[pubChemAssociation, Name, {}];
		(* look up pubchem synonyms *)
		pubChemSynonyms = Lookup[pubChemAssociation, Synonyms, {}];
		(* combine all names and synonyms for Synonyms field *)
		allSynonyms = DeleteDuplicates[Cases[Flatten[{myInput, pubChemName, pubChemSynonyms}], _String]];
		(* create the final  *)
		pubChemAssociationWithName = Merge[{<|Name -> myInput, Synonyms -> allSynonyms|>, pubChemAssociation}, First]
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
	myOptionsWithSynonyms = If[KeyExistsQ[myOptionsWithTemplateOptions, Name] && KeyExistsQ[myOptionsWithTemplateOptions, Synonyms],
		(* Make sure that the Name is apart of the Synonyms *)
		If[!MemberQ[myOptionsWithTemplateOptions[Synonyms], myOptionsWithTemplateOptions[Name]],
			(* If Name isn't in Synonyms, add it to the list. *)
			Append[myOptionsWithTemplateOptions, Synonyms -> If[NullQ[myOptionsWithTemplateOptions[Name]], Null, Prepend[Cases[ToList[myOptionsWithTemplateOptions[Synonyms]], _String], myOptionsWithTemplateOptions[Name]]]],
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
	identifiersToLookup={InChI, InChIKey, CAS, IUPAC, PubChemID};
	myChemicalIdentifiers=Lookup[myFinalizedOptions, identifiersToLookup];

	(* Convert this information into rule form (ex. CAS\[Rule]myCAS), filtering out missing identifiers. *)
	myChemicalIdentifierRules=MapThread[Rule, {identifiersToLookup, myChemicalIdentifiers}] /. ((_ -> _Missing) | (_ -> (Null | {Null..}))) -> Nothing;

	(* Search for similar chemicals. Will throw a message if one already exists *)
	(* Ignore check if forcing *)
	If[!TrueQ[Lookup[myRawOptions, Force]],
		Module[{duplicateMolecules},
			duplicateMolecules = duplicateMoleculeCheck[myChemicalIdentifierRules];

			(* Throw an error if there is already a duplicate *)
			If[!MatchQ[duplicateMolecules, {}],
				Message[Error::MoleculeExists, ToString[duplicateMolecules], ToString[myInput]]
			]
		]
	];

	(* Almost completely resolved options *)
	nearlyResolvedOptions = Normal[myFinalizedOptions];

	(* Return resolved options *)
	ReplaceRule[nearlyResolvedOptions, {ModifyInputModel->resolvedModifyQ}]
];


(* Check if a molecule still exists in Constellation that shares a unique identifier *)
(* Abstract this as a small helper, mainly so we can selectively stub it for unit testing *)
(* Empty overload so that unknown molecules with no identifiers don't show as duplicates of each other *)
duplicateMoleculeCheck[{}] := {};
duplicateMoleculeCheck[identifierRules : {_Rule..}] := With[
	{identifierSearchTerm = Or @@ (Equal @@ #& /@ identifierRules)},
	Search[Model[Molecule], identifierSearchTerm]
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
