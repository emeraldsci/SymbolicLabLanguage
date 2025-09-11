(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadSampleModel*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadSampleModel,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Name,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The name of the sample.",
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
				OptionName -> Composition,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[{
					"Amount" -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> Alternatives[
								GreaterP[0 Molar],
								GreaterP[0 Gram / Liter],
								RangeP[0 VolumePercent, 100 VolumePercent],
								RangeP[0 MassPercent, 100 MassPercent],
								RangeP[0 PercentConfluency, 100 PercentConfluency],
								GreaterP[0 Cell / Liter],
								GreaterP[0 CFU / Liter],
								GreaterP[0 OD600]
							],
							Units -> Alternatives[
								{1, {Molar, {Micromolar, Millimolar, Molar}}},
								CompoundUnit[
									{1, {Gram, {Kilogram, Gram, Milligram, Microgram}}},
									{-1, {Liter, {Liter, Milliliter, Microliter}}}
								],
								{1, {VolumePercent, {VolumePercent}}},
								{1, {MassPercent, {MassPercent}}},
								{1, {PercentConfluency, {PercentConfluency}}},
								CompoundUnit[
									{1, {EmeraldCell, {EmeraldCell}}},
									{-1, {Milliliter, {Liter, Milliliter, Microliter}}}
								],
								CompoundUnit[
									{1, {CFU, {CFU}}},
									{-1, {Milliliter, {Liter, Milliliter, Microliter}}}
								],
								{1, {OD600, {OD600}}}
							]
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					],
					"Identity Model" -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[List @@ IdentityModelTypeP]],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					]
				}],
				Description -> "The molecular composition of this model.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> OpticalComposition,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[{
					"Amount" -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> Alternatives[
								RangeP[-100 Percent, 100 Percent]
							],
							Units -> Alternatives[
								Percent
							]
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					],
					"Identity Model" -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[List @@ IdentityModelTypeP]],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					]
				}],
				Description -> "The molecular composition (in percent) of enantiomers, if this sample contains one of the enantiomers or is a mixture of enantiomers.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Media,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Sample]]
				],
				Description -> "The base cell growth medium this sample model is in.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> UsedAsMedia,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this sample is used as a cell growth medium.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Living,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if there is living material in this sample.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> CellType,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CellTypeP
				],
				Description -> "The taxon of the organism or cell line from which the cell sample originates. Options include Bacterial, Mammalian, Insect, Plant, and Yeast.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Solvent,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object, Pattern :> ObjectP[Model[Sample]]
				],
				Description -> "The base solution this sample model is in.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> UsedAsSolvent,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this sample is used as a solvent.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> ConcentratedBufferDiluent,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
				Description -> "The buffer that is used to dilute the sample by ConcentratedBufferDilutionFactor to form BaselineStock.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> ConcentratedBufferDilutionFactor,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> GreaterP[0]],
				Description -> "The amount by which this the sample must be diluted with its ConcentratedBufferDiluent in order to form standard ratio of Models for 1X buffer.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> BaselineStock,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
				Description -> "The models that when diluted with their ConcentratedBufferDiluent by ConcentratedBufferDilutionFactor form equivalent 1X versions of the same buffer.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> AlternativeForms,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Model[Sample]]]],
				Description -> "Models of other samples with different grades, hydration states, monobasic/dibasic forms, etc.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Grade,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> GradeP],
				Description -> "The purity of this model, encapsulating a set of purity standards for specific uses.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> ProductDocumentationFiles,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]]]],
				Description -> "PDFs of any product documentation provided by the supplier of this model.",
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
				Description -> "Known density of samples of this model at room temperature.",
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
				Description -> "A measure of how strongly this sample absorbs light at a particular wavelength.",
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
				OptionName -> pKa,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[-Infinity, Infinity]],
				Description -> "The logarithmic acid dissociation constants of the substance at room temperature.",
				Category -> "Physical Properties"
			},
			(* The FixedAmounts and TransferOutSolventVolumes need to be index-matched. It is enforced in VOQ for now *)
			{
				OptionName -> FixedAmounts,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Quantity,
						Pattern :> Alternatives[
							GreaterP[0 * Gram],
							GreaterP[0 * Liter]
						],
						Units -> Alternatives[
							{1, {Gram, {Milligram, Gram}}},
							{1, {Liter, {Microliter, Milliliter, Liter}}}
						]
					]
				],
				Description -> "The pre-measured amounts in which samples of this model are always stored.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> TransferOutSolventVolumes,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 * Liter],
						Units -> {1, {Liter, {Microliter, Milliliter, Liter}}}
					]
				],
				Description -> "The amounts of the dissolution solvents required to solvate the fixed aliquot amount of this model.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> SingleUse,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this model of sample must be used only once and then disposed of after use.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Tablet,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this sample is in tablet form.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Sachet,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this sample is in the form of a small pouch filled with a measured amount of loose solid substance.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> SolidUnitWeight,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Gram],
					Units -> {1, {Gram, {Milligram, Gram}}}
				],
				Description -> "If this is a tablet or sachet, the weight of a single tablet or sachet.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> DefaultSachetPouch,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Material]]],
				Description -> "The material of the pouch that the filler of the sachet is wrapped in to form a single unit of sachet.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Fiber,
				Default -> False,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this model is in the form of a thin cylindrical string of solid substance.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> FiberCircumference,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> Millimeter
				],
				Description -> "It's the perimeter of the circular cross-section of a the sample if it is a single fiber. In the context of measuring contact angle or surface tension, it's essentially the so called \"wetted length\", the length of the three-phase boundary line for contact between a solid and a liquid in a bulk third phase.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Products,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Product]]]],
				Description -> "Products ordering information for this model.",
				Category -> "Inventory"
			},
			{
				OptionName -> ServiceProviders,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Company, Service]]]],
				Description -> "Service companies that provide synthesis of this model as a service.",
				Category -> "Inventory"
			},
			{
				OptionName -> ThawTemperature,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[-20 Celsius, 90 Celsius], Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}],
				Description -> "The default temperature that samples of this model should be thawed at before using in experimentation.",
				Category -> "Storage Information"
			},
			{
				OptionName -> ThawTime,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Second], Units -> {1, {Second, {Hour, Minute, Second}}}],
				Description -> "The default time that samples of this model should be thawed before using in experimentation. If the samples are still not thawed after this time, thawing will continue until the samples are fully thawed.",
				Category -> "Storage Information"
			},
			{
				OptionName -> MaxThawTime,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Second], Units -> {1, {Second, {Hour, Minute, Second}}}],
				Description -> "The default maximum time that samples of this model should be thawed before using in experimentation.",
				Category -> "Storage Information"
			},
			{
				OptionName -> PipettingMethod,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Method, Pipetting]]],
				Description -> "The pipetting parameters used to manipulate samples of this model; these parameters may be overridden by direct specification of pipetting parameters in manipulation primitives.",
				Category -> "Storage Information"
			},
			{
				OptionName -> TransportTemperature,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern:>Alternatives[RangeP[-86*Celsius, 10*Celsius], RangeP[30*Celsius, 105*Celsius]], Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}],
				Description -> "The temperature that if samples of this model should be heated or refrigerated during transport when used in experiments.",
				Category -> "Storage Information"
			},
			{
				OptionName -> ThawCellsMethod,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Method, ThawCells]]],
				Description -> "The default method by which to thaw cryovials of this sample model.",
				Category -> "Storage Information"
			},
			{
				OptionName -> AsepticTransportContainerType,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> AsepticTransportContainerTypeP],
				Description -> "The manner in which samples of this model are contained in an aseptic barrier and if they need to be unbagged before being used in a protocol, maintenance, or qualification.",
				Category -> "Storage Information"
			},
			{
				OptionName -> Notebook,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[LaboratoryNotebook]]],
				Description -> "The Notebook this Model will belong to. For Public Model has to be set to Null.",
				Category -> "Hidden"
			}
		]
	},

	SharedOptions :> {
		ModelSampleHealthAndSafetyOptions
	},

	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> PreferredMALDIMatrix,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Model[Sample, Matrix]]]],
				Description -> "The model of the matrix that is best suited for mass spectrometry of this sample.",
				Category -> "Compatibility"
			}
		]
	},

	SharedOptions :> {
		ExternalUploadHiddenOptions
	}
];


InstallDefaultUploadFunction[UploadSampleModel, Model[Sample], OptionResolver -> resolvedUploadSampleOptions, AuxilliaryPacketsFunction -> uploadSampleModelAuxilliaryPackets];
InstallValidQFunction[UploadSampleModel, Model[Sample]];
InstallOptionsFunction[UploadSampleModel, Model[Sample]];


(* ::Subsubsection::Closed:: *)
(*Option Resolver*)

Error::MissingLivingOption = "For inputs, `1`, the Model[Cell](s), `2` were found in the provided Composition. Please use the Living option to specify whether the cells are alive or dead.";

(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
(* This is a legacy resolver where the original version wasn't listable, so this is a bit hacky in the short term *)
(* This helper will soon be re-written *)
(* But I want to get the framework refactor online first as a separate entity for better testing *)
resolvedUploadSampleOptions[myType_, myInput:{___}, myOptions_, rawOptions_] := Module[
	{result, inputsWithInvalidOptions},

	(* Map over the singleton function - this is legacy code *)
	{result, inputsWithInvalidOptions} = Transpose@MapThread[
		Module[{originalResult},

			(* Run the option resolver for each input. Quiet and catch the living option error message that's thrown so we can thrown it just the once later *)
			Quiet[Check[
				originalResult = resolvedUploadSampleOptions[myType, #1, #2, #3];
				{originalResult, {}},

				(* If we threw the missing living option message, store that invalid input *)
				{originalResult, #1},

				(* Only check for intended message *)
				{Error::MissingLivingOption}
			], {Error::MissingLivingOption}]
		]&,
		{myInput, myOptions, rawOptions}
	];

	(* If any of the inputs failed, now throw the message to the front end, once, in listed form *)
	If[!MatchQ[Flatten[inputsWithInvalidOptions], {}],
		Message[Error::MissingLivingOption, Flatten[inputsWithInvalidOptions], Cases[#, ObjectP[Model[Cell]], Infinity] & /@ Lookup[PickList[result, inputsWithInvalidOptions, Except[{}]], Composition]]
	];

	(* Return the output in the expected format *)
	<|
		Result -> result,
		InvalidInputs -> {},
		InvalidOptions -> If[!MatchQ[Flatten[inputsWithInvalidOptions], {}], {Living}, {}]
	|>
];

(* New object overload. *)
resolvedUploadSampleOptions[myType_, myName_String, myOptions_, rawOptions_] := Module[
	{
		myOptionsAssociation, resolvedNotebook, myOptionsAssociationWithNotebook, myOptionsWithName, pubChemInformation, safeComposition,
		myOptionsWithPubChem, myOptionsWithSynonyms, allIdentityModels, resolvedSafetyOptions, mysemiFinalizedOptions,
		modelCellInComposition, cellPacketsInComposition, livingOptionProvidedBool, cellTypeProvidedBool, allIdentityModelPackets,
		resolvedCellType, resolvedSterile, resolvedAsepticHandling, myFinalizedOptions
	},

	(* Convert the options to an association. *)
	myOptionsAssociation = Association @@ myOptions;
	resolvedNotebook = If[MatchQ[Lookup[myOptionsAssociation, Notebook], Automatic],
		Download[$Notebook, Object],
		Lookup[myOptionsAssociation, Notebook]
	];

	myOptionsAssociationWithNotebook = Append[myOptionsAssociation, Notebook -> resolvedNotebook];

	(* This option resolver is a little unusual in that we have to AutoFill the options in order to compute *)
	(* either the tests or the results. *)

	(* -- AutoFill based on the information we're given. -- *)
	(* Overwrite the Name option if it is Null. *)
	myOptionsWithName = If[MatchQ[Lookup[myOptionsAssociationWithNotebook, Name], Null],
		Append[myOptionsAssociationWithNotebook, Name -> myName],
		myOptionsAssociationWithNotebook
	];

	(* Try to get information from PubChem. *)
	pubChemInformation = parseChemicalIdentifier[myName];

	myOptionsWithPubChem = If[MatchQ[pubChemInformation, $Failed],
		myOptionsWithName,
		Module[{filteredPubChemOptions},
			(* Some PubChem keys may not be options to UploadSampleModel. *)
			filteredPubChemOptions = Association@(KeyValueMap[
				Function[{key, value},
					If[KeyExistsQ[myOptionsAssociationWithNotebook, key],
						key -> value,
						Nothing
					]
				],
				pubChemInformation
			]);

			(* Merge our option sets, favoring user defined options that are non-Null. *)
			Merge[
				{myOptionsWithName, filteredPubChemOptions},
				(If[Length[#] == 1,
					#[[1]],
					If[MatchQ[#[[1]], Null],
						#[[2]],
						#[[1]]
					]
				]&)]
		]
	];

	(* Make sure that if we have a Name and Synonyms field  that Name is apart of the Synonyms list. *)
	myOptionsWithSynonyms = If[MatchQ[Lookup[myOptionsWithPubChem, Synonyms], Null] || (!MemberQ[Lookup[myOptionsWithPubChem, Synonyms], Lookup[myOptionsWithPubChem, Name]] && MatchQ[Lookup[myOptionsWithPubChem, Name], _String]),
		Append[myOptionsWithPubChem, Synonyms -> (Append[Lookup[myOptionsWithPubChem, Synonyms] /. Null -> {}, Lookup[myOptionsWithPubChem, Name]])],
		myOptionsWithPubChem
	];

	(* Extract the composition *)
	safeComposition = If[MatchQ[Lookup[myOptionsAssociation, Composition], Null],
		{},
		Lookup[myOptionsAssociation, Composition]
	];

	(* Get the identity models from our composition. *)
	allIdentityModels = Cases[safeComposition[[All, 2]], IdentityModelP];

	(* If we have a composition, combine the EHS information from those identity models. *)
	resolvedSafetyOptions = If[Length[allIdentityModels] > 0,
		Module[{identityModelSafetyFields, identityModelSafetyFieldsPacket},
			(* Get all of the safety fields from our identity models. *)
			identityModelSafetyFields = ToExpression /@ Options[ExternalUpload`Private`IdentityModelHealthAndSafetyOptions][[All, 1]];
			identityModelSafetyFieldsPacket = Packet @@ Flatten[{identityModelSafetyFields, CellType}];

			(* Do our download, this download is also used later when resolving cell type. *)
			allIdentityModelPackets=Quiet[
				Download[allIdentityModels, identityModelSafetyFieldsPacket],
				{Download::FieldDoesntExist, Download::MissingField, Download::ObjectDoesNotExist, Download::Part, Download::MissingCacheField}
			];

			(* For a given safety field, combine the fields from the identity models: *)
			Map[
				Function[{ehsField},
					(* Don't overwrite the user's options. *)
					If[MatchQ[Lookup[myOptionsAssociation, ehsField], Except[Null | Automatic]],
						Nothing,
						ehsField -> Fold[
							ExternalUpload`Private`combineEHSFields[ehsField, #1, #2][[2]]&, (* Note: ExternalUpload`Private`combineEHSFields returns a rule. *)
							(* if we are working with the cases when a given field is $Failed (for example DoubleGloveRequired for Cells) -> swap it to Null *)
							Lookup[allIdentityModelPackets, ehsField, {Null, Null}]/.{$Failed->Null}
						]
					]
				],
				identityModelSafetyFields
			]
		],
		(* ELSE: Can't resolve safety information. *)
		{}
	];

	(* Combine our safety options from IdentityModelHealthAndSafetyOptions. *)
	(* Note:ModelSampleHealthAndSafetyOptions also contains:Anhydrous, AsepticHandling, CellType, CultureAdhesion, *)
	(* DefaultStorageCondition, Expires, SampleHandling, ShelfLife, State, Sterile, TransportTemperature, UnsealedShelfLife *)
	(* Those options are not in resolvedSafetyOptions, but in myOptionsWithSynonyms with default/user-specified values *)
	mysemiFinalizedOptions = Merge[{resolvedSafetyOptions, myOptionsWithSynonyms}, First];

	(* Extract any Model[Cell] from the composition *)
	modelCellInComposition = Cases[safeComposition[[All, 2]], ObjectP[Model[Cell]]];
	cellPacketsInComposition = Cases[allIdentityModelPackets, ObjectP[modelCellInComposition]];

	(* Extract the living option from the rawOptions *)
	livingOptionProvidedBool = MatchQ[Lookup[rawOptions, Living, $Failed], BooleanP];

	(* Throw an error if the Living option was not provided and there are Model[Cell]'s in the Composition *)
	If[Length[modelCellInComposition] > 0 && !livingOptionProvidedBool,
		Message[Error::MissingLivingOption, modelCellInComposition]
	];

	(* Extract the living option from the rawOptions *)
	cellTypeProvidedBool = MatchQ[Lookup[rawOptions, CellType, $Failed], CellTypeP];

	resolvedCellType = Which[
		(* not a living situation *)
		MatchQ[Lookup[mysemiFinalizedOptions, Living], False|Null],
			Null,
		(* living and we have a CellType specified *)
		cellTypeProvidedBool,
			Lookup[rawOptions, CellType],
		(* we don't have a provided CellType, resolve from the composition *)
		Length[modelCellInComposition] > 0,
			Which[
				(* we have only one cell in the composition *)
				Length[modelCellInComposition] == 1,
					Lookup[First@cellPacketsInComposition, CellType],
				(* we have only the same type of cells in the composition - steal it from the first one *)
				Length[DeleteDuplicates@Lookup[cellPacketsInComposition, CellType]] == 1,
					Lookup[First@cellPacketsInComposition, CellType],
				(* we have more than 1 different cell type, we are using these in order of Mammalian>Plant>Insect>Fungal>Yeast>Bacteria to get the highest ranking cell type *)
				Length[DeleteDuplicates@Lookup[cellPacketsInComposition, CellType]]>1,
					FirstCase[List@@CellTypeP, Alternatives@@DeleteDuplicates[Lookup[cellPacketsInComposition, CellType]]],
				(* we somehow were not able to resolve the CellType here, return Null *)
				True,
					Null
			],
		(* we somehow failed to resolve it, return Null *)
		True,
			Null
	];

	resolvedSterile = Which[
		(* Do we have Sterile specified *)
		MatchQ[Lookup[rawOptions, Sterile], BooleanP], MatchQ[Lookup[rawOptions, Sterile], BooleanP],
		(* Do we have living set as True? Set False for microbial cells *)
		TrueQ[Lookup[mysemiFinalizedOptions, Living]] && MemberQ[Lookup[cellPacketsInComposition, CellType], MicrobialCellTypeP],
			False,
		(* we somehow failed to resolve it, return Null *)
		True,
			Null
	];

	resolvedAsepticHandling = Which[
		(* Do we have AsepticHandling specified *)
		MatchQ[Lookup[rawOptions, AsepticHandling], BooleanP], MatchQ[Lookup[rawOptions, AsepticHandling], BooleanP],
		(* Do we have living set as True? Set True for all cell samples *)
		TrueQ[Lookup[mysemiFinalizedOptions, Living]], True,
		(* Do we have Sterile set as True? Set True to keep sterile state *)
		TrueQ[resolvedSterile], True,
		(* we somehow failed to resolve it, return Null *)
		True, Null
	];

	(* Upload Sterile/CellType/AsepticHandling options. *)
	myFinalizedOptions = ReplaceRule[
		Normal[mysemiFinalizedOptions],
		{
			CellType -> resolvedCellType,
			Sterile -> resolvedSterile,
			AsepticHandling -> resolvedAsepticHandling
		}
	];

	(* Return our options. *)
	myFinalizedOptions
];


(* This existing object overload is the same as the default resolver. *)
resolvedUploadSampleOptions[myType_, myInput:ObjectP[], myOptions_, rawOptions_]:=resolveDefaultUploadFunctionOptions[myType, myInput, myOptions, rawOptions];


(* ::Subsubsection::Closed:: *)
(* Auxilliary packets function *)
uploadSampleModelAuxilliaryPackets[myType_, myInputs_List, myOptionsList_List, myResolvedMapThreadOptionsList_List] := Module[
	{
		modelSampleInputQs, auxilliaryPackets,
		activeSamplesPackets, timeOfUpdate
	},

	(* Check if we're modifying an existing Model[Sample] *)
	modelSampleInputQs = MatchQ[#, ObjectP[Model[Sample]]] & /@ myInputs;

	(* Search for any active samples of the models that are being modified and download packets for them *)
	activeSamplesPackets = Module[
		{modelSampleInputs, activeSamplesSearchResult},

		(* Pick out the inputs that are Model[Sample]s *)
		modelSampleInputs = PickList[myInputs, modelSampleInputQs];

		(* Search for the active samples for each input *)
		activeSamplesSearchResult = With[
			{
				types = ConstantArray[Object[Sample], Length[modelSampleInputs]],
				clauses = (Status != Discarded && Model == #) & /@ modelSampleInputs
			},
			Search[types, clauses]
		];

		(* Download whole packets for all the samples *)
		activeSamplesPackets = Download[activeSamplesSearchResult];

		(* Index match the results back with the original inputs, filling with Null *)
		ReplacePart[
			ConstantArray[Null, Length[myInputs]],
			AssociationThread[Position[modelSampleInputQs, True], activeSamplesPackets]
		]
	];

	(* Save the current time to attribute the changes to *)
	timeOfUpdate = Now;

	(* Generate the auxilliary packets for each input *)
	auxilliaryPackets = MapThread[
		Function[{input, resolvedOptionSet, activeSamplePackets},
			Module[
				{},

				(* If our input isn't a Model[Sample] i.e. we're not modifying an existing model, there's nothing to do *)
				If[!MatchQ[input, ObjectP[Model[Sample]]],
					Return[{}, Module]
				];

				(* Otherwise generate packets to copy the changes over to the associated Object[Sample]s *)
				Map[
					Function[samplePacket,
						Module[
							{modifiedOptions, filteredOptions, changePacket},

							(* Make any modifications to the option values *)
							modifiedOptions = Map[
								Function[{optionRule},
									Module[{optionSymbol,optionValue},

										(* Split the option into symbol and value *)
										optionSymbol = First[optionRule];
										optionValue = Last[optionRule];

										(* Append the time to the end of the composition *)
										If[MatchQ[optionSymbol, Composition] && !MatchQ[optionValue, Null | {Null}],
											optionSymbol -> Map[
												Function[{myEntry},
													{myEntry[[1]], Link[myEntry[[2]]], timeOfUpdate}
												],
												optionValue
											],

											(* Otherwise just pass through the option *)
											optionSymbol -> If[MatchQ[optionValue, {Null}], Null, optionValue]
										]
									]
								],
								resolvedOptionSet
							];

							(* Remove any options that shouldn't be used to update fields *)
							filteredOptions = Cases[modifiedOptions, HoldPattern[Except[Name] -> _]];

							(* Return the change packet *)
							changePacket = generateChangePacket[Object[Sample], filteredOptions, ExistingPacket -> samplePacket];

							(* Add in the object key for the existing object *)
							Append[
								changePacket,
								Object -> Lookup[samplePacket, Object]
							]
						]
					],
					activeSamplePackets
				]
			]
		],
		{myInputs, myResolvedMapThreadOptionsList, activeSamplesPackets}
	];

	(* Return the index matched lists of packets *)
	auxilliaryPackets
];