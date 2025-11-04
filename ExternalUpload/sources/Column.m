(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadColumn*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadColumn,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Name,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word],
				Description -> "The name of this column model.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Synonyms,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
				Description -> "List of possible alternative names this column model goes by.",
				ResolutionDescription -> "Resolves to the option Name, if provided. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Products,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The products that can be used to order more of this Model[Column].",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information",
				Widget -> Adder[
					Widget[Type -> Object, Pattern :> ObjectP[Object[Product]]
					]
				]
			},
			{
				OptionName -> SeparationMode,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The type of chromatography for which this column is suitable.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Model Information",
				Widget -> Widget[Type -> Enumeration, Pattern :> (SeparationModeP)]
			},
			{
				OptionName -> ColumnType,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The scale of the chromatography to be performed on the column. Analytical columns are used for smaller volumes and mainly for identification purposes. Preparative columns are used for larger volumes and mainly for separation purposes. Guard columns are mounted between the injector and main column to protect the main column from impurities.",
				Category -> "Physical Properties",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Widget -> Widget[Type -> Enumeration, Pattern :> (ColumnTypeP)]
			},
			{
				OptionName -> PackingType,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "The method used to fill the column with the resin, be that by hand packing with loose solid resin, by inserting a disposable cartridge, or with a column which has been prepacked during manufacturing.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (ColumnPackingTypeP)]
			},
			{
				OptionName -> PackingMaterial,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "Chemical composition of the packing material in the column.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (ColumnPackingMaterialP)]
			},
			{
				OptionName -> FunctionalGroup,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The functional group displayed on the column's stationary phase.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (ColumnFunctionalGroupP)]
			},
			{
				OptionName -> ParticleSize,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The size of the particles that make up the column packing material.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Nanometer],
					Units -> {Millimeter, {Millimeter, Micrometer, Nanometer}}
				]
			},
			{
				OptionName -> PoreSize,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The average size of the pores within the column packing material.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Angstrom],
					Units -> {Nanometer, {Nanometer, Picometer, Angstrom}}
				]
			},
			{
				OptionName -> ResinCapacity,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The weight of the resin that the column can be packed with.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Gram],
					Units -> {Gram, {Gram, Milligram}}
				]
			},
			{
				OptionName -> CasingMaterial,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The material that the exterior of the column which houses the packing material is composed of.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (MaterialP)]
			},
			{
				OptionName -> InletFilterMaterial,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The material of the inlet filter through which the sample must travel before reaching the stationary phase.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (FilterMembraneMaterialP)]
			},
			{
				OptionName -> InletFilterPoreSize,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The size of the pores in the inlet filter through which the sample must travel before reaching the stationary phase.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Micro * Meter],
					Units -> {Micrometer, {Micrometer, Nanometer}}
				]
			},
			{
				OptionName -> InletFilterThickness,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The thickness of the inlet filter through which the sample must travel before reaching the stationary phase.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Milli * Meter],
					Units -> {Millimeter, {Millimeter, Micrometer}}
				]
			},
			
			{
				OptionName -> MinPressure,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The minimum pressure the column can handle.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * PSI],
					Units -> {PSI, {PSI, Bar}}
				]
			},
			{
				OptionName -> MaxPressure,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The maximum pressure the column can handle.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * PSI],
					Units -> {PSI, {PSI, Bar}}
				]
			},
			{
				OptionName -> NominalFlowRate,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The nominal flow rate at which the column performs.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 Milliliter / Minute],
					Units -> CompoundUnit[
						{1, {Milliliter, {Milliliter, Liter}}},
						{-1, {Minute, {Minute, Second}}}
					]
				]
			},
			{
				OptionName -> MinFlowRate,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The minimum flow rate at which the column performs.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 Milliliter / Minute],
					Units -> CompoundUnit[
						{1, {Milliliter, {Milliliter, Liter}}},
						{-1, {Minute, {Minute, Second}}}
					]
				]
			},
			{
				OptionName -> MaxFlowRate,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The maximum flow rate at which the column performs.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 Milliliter / Minute],
					Units -> CompoundUnit[
						{1, {Milliliter, {Milliliter, Liter}}},
						{-1, {Minute, {Minute, Second}}}
					]
				]
			},
			{
				OptionName -> MinTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The minimum temperature at which this column can function.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Kelvin],
					Units -> Alternatives[Kelvin, Celsius, Fahrenheit]
				]
			},
			{
				OptionName -> MaxTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The maximum temperature at which this column can function.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Kelvin],
					Units -> {Celsius, {Celsius, Kelvin, Fahrenheit}}
				]
			},
			{
				OptionName -> MaxNumberOfUses,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The maximum number of injections for which this column is recommended to be used.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			},
			{
				OptionName -> MaxAcceleration,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The maximum flow rate acceleration at which to ramp the speed of pumping solvent for this column.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 (Milliliter / Minute / Minute)],
					Units -> CompoundUnit[
						{1, {Milliliter, {Milliliter, Liter}}},
						{-1, {Minute, {Minute, Second}}},
						{-1, {Minute, {Minute, Second}}}
					]
				]
			},
			
			{
				OptionName -> Diameter,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The internal diameter of the column.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Milli * Meter],
					Units -> Alternatives[
						{1, {Milli * Meter, {Milli * Meter, Centi * Meter}}}
					]
				]
			},
			{
				OptionName -> ColumnLength,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The internal length of the column.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Milli * Meter],
					Units -> Alternatives[
						{1, {Milli * Meter, {Milli * Meter, Centi * Meter}}}
					]
				]
			},
			{
				OptionName -> ColumnVolume,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "Total volume of the column. This is the sum of the packing volume and the void volume.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Liter * Milli],
					Units -> Alternatives[
						{1, {Milli * Liter, {Milli * Liter, Liter}}}
					]
				]
			},
			{
				OptionName -> Dimensions,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The external dimensions of this model of column.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Operating Limits",
				Widget -> {
					"Width" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Meter],
						Units -> {1, {Meter, {Millimeter, Centimeter, Meter, Kilometer}}},
						Min -> 0 Meter, Max -> Null, Increment -> Null,
						PatternTooltip -> "Number must be greater than or equal to 0 meters."
					],
					"Length" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Meter],
						Units -> {1, {Meter, {Millimeter, Centimeter, Meter, Kilometer}}},
						Min -> 0 Meter, Max -> Null, Increment -> Null,
						PatternTooltip -> "Number must be greater than or equal to 0 meters."
					],
					"Height" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Meter],
						Units -> {1, {Meter, {Millimeter, Centimeter, Meter, Kilometer}}},
						Min -> 0 Meter, Max -> Null, Increment -> Null,
						PatternTooltip -> "Number must be greater than or equal to 0 meters."
					]
				}
			},
			{
				OptionName -> PreferredGuardColumn,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The preferred guard column for use with this column.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Item, Column]}]
				]
			},
			{
				OptionName -> ProtectedColumns,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The analytical or preparative columns for which this column is preferred as a guard.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Compatibility",
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Model[Item, Column]}]]
				]
			},
			{
				OptionName -> PreferredGuardCartridge,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The guard column cartridge which is preferred to be inserted into this column.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Item, Cartridge, Column]}]
				]
			},
			{
				OptionName -> PreferredColumnJoin,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The column join that best connects a column to this guard column.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Plumbing, ColumnJoin]}]
				]
			},
			{
				OptionName -> WettedMaterials,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The materials of which this sample is made that may come in direct contact with fluids.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Compatibility",
				Widget -> Adder[Widget[Type -> Enumeration, Pattern :> (MaterialP)]]
			},
			{
				OptionName -> IncompatibleSolvents,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "Chemicals that are incompatible for use with this column.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Compatibility",
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]]
				]
			},
			{
				OptionName -> MinpH,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The minimum pH the column can handle.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 14]]
			},
			{
				OptionName -> MaxpH,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The maximum pH the column can handle.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null for new objects and the current field value for existing objects.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 14]]
			},
			{
				OptionName -> StorageCaps,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "Indicates whether this column requires special caps when being stored (e.g. not being on the instrument).",
				ResolutionDescription -> "If creating a new object, resolves to False. For existing objects, Automatic resolves to the current field value.",
				Category -> "Storage Information",
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
			},
			{
				OptionName -> ConnectorType,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "Indicates how the inlets are connected to tubing -- Female is a ferrule/screw must enter in, and Male indicates that inlet screws into another female port.",
				ResolutionDescription -> "If creating a new object, resolves to FemaleFemale. For existing objects, Automatic resolves to the current field value.",
				Category -> "Storage Information",
				Widget -> Widget[Type -> Enumeration, Pattern :> ColumnConnectorTypeP] (*FemaleFemale | FemaleMale*)
			},
			
			{
				OptionName -> DefaultStorageCondition,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "The condition in which this model columns are stored when not in use by an experiment.",
				ResolutionDescription -> "If creating a new object, resolves to Model[StorageCondition, \"Ambient Storage\"]. For existing objects, Automatic resolves to the current field value.",
				Category -> "Storage Information",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[StorageCondition]]]
			},
			{
				OptionName -> StorageBuffer,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The preferred buffer used to keep the resin wet while the column is stored.",
				ResolutionDescription -> "If creating a new object, Automatic resolves to Null. For existing objects, Automatic resolves to the current field value.",
				Category -> "Storage Information",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample]}]]
			}
		]
	},
	SharedOptions :> {
		ExternalUploadHiddenOptions
	}
];

(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
(* This is a basic legacy resolver that doesn't throw messages, so can just map over all the inputs *)
resolveUploadColumnOptions[myType_, myInput:{___}, myOptions_, rawOptions_] := Module[
	{result},

	(* Map over the singleton function - this is legacy code *)
	result = MapThread[resolveUploadColumnOptions[myType, #1, #2, #3] &, {myInput, myOptions, rawOptions}];

	(* Return the output in the expected format *)
	<|
		Result -> result,
		InvalidInputs -> {},
		InvalidOptions -> {},
		Tests -> {}
	|>
];

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadColumnOptions[myType_, myName_String, myOptions_, rawOptions_]:=Module[
	{
		myOptionsAssociation, myOptionsWithName, myOptionsWithSynonyms, optionsToMatchCartridge, cartridgeOptionUpdates, optionsWithCartridgeUpdates,
		storageCapsUpdate, connectorTypeUpdate, defaultStorageConditionUpdate, finalizedOptions
	},
	
	(* Convert the options to an association. *)
	myOptionsAssociation=Association @@ myOptions;
	
	(* This option resolver is a little unusual in that we have to AutoFill the options in order to compute *)
	(* either the tests or the results. *)
	
	(* -- AutoFill based on the information we're given. -- *)
	(* Overwrite the Name option if it is Null or Automatic *)
	myOptionsWithName=If[MatchQ[Lookup[myOptionsAssociation, Name], Alternatives[Null, Automatic]],
		Append[myOptionsAssociation, Name -> myName],
		myOptionsAssociation
	];
	
	(* Make sure that if we have a Name and Synonyms field  that Name is apart of the Synonyms list. *)
	myOptionsWithSynonyms=If[MatchQ[Lookup[myOptionsWithName, Synonyms], Alternatives[Null, Automatic]] || (!MemberQ[Lookup[myOptionsWithName, Synonyms], Lookup[myOptionsWithName, Name]] && MatchQ[Lookup[myOptionsWithName, Name], _String]),
		Append[myOptionsWithName, Synonyms -> (Append[Lookup[myOptionsWithName, Synonyms] /. Alternatives[Null, Automatic] -> {}, Lookup[myOptionsWithName, Name]])],
		myOptionsWithName
	];
	
	(* These are the options that we resolve from the PreferredGuardCartridge. *)
	optionsToMatchCartridge={SeparationMode, MaxpH, MaxPressure, MaxTemperature, MinFlowRate, MinpH, MinPressure, MinTemperature, NominalFlowRate, MaxFlowRate, PackingMaterial};
	
	(* If PreferredGuardCartridge is specified, pull values from it to populate any corresponding Automatic options. If no cartridge is specified, resolve these automatics to Null. *)
	cartridgeOptionUpdates=If[MatchQ[Lookup[myOptionsAssociation, PreferredGuardCartridge], ObjectP[]],
		Module[{cartridgePacket},
			(* Download the PreferredGuardCartidge. *)
			cartridgePacket=Download[Lookup[myOptionsAssociation, PreferredGuardCartridge], Packet[SeparationMode, MaxpH, MaxPressure, MaxTemperature, MinFlowRate, MinpH, MinPressure, MinTemperature, NominalFlowRate, MaxFlowRate, PackingMaterial]];
			
			MapThread[
				Function[{cartridgeValue, optionValue, optionName},
					If[MatchQ[optionValue, Automatic],
						Rule[optionName, cartridgeValue],
						Nothing
					]
				],
				{Lookup[cartridgePacket, optionsToMatchCartridge], Lookup[myOptionsWithSynonyms, optionsToMatchCartridge], optionsToMatchCartridge}
			]
		],
		MapThread[
			Function[{optionValue, optionName},
				If[MatchQ[optionValue, Automatic],
					Rule[optionName, Null],
					Nothing
				]
			],
			{Lookup[myOptionsWithSynonyms, optionsToMatchCartridge], optionsToMatchCartridge}
		]
	];

	(* Resolve the other automatic options *)
	(* StorageCaps, default False *)
	storageCapsUpdate = StorageCaps -> Replace[Lookup[myOptionsWithSynonyms, StorageCaps], Automatic -> False];

	(* ConnectorType, default female-female *)
	connectorTypeUpdate = ConnectorType -> Replace[Lookup[myOptionsWithSynonyms, ConnectorType], Automatic -> FemaleFemale];

	(* DefaultStorageCondition, default ambient *)
	defaultStorageConditionUpdate = DefaultStorageCondition -> Replace[Lookup[myOptionsWithSynonyms, DefaultStorageCondition], Automatic -> Model[StorageCondition, "Ambient Storage"]];
	
	(* Replace the manually resolved options *)
	optionsWithCartridgeUpdates=ReplaceRule[
		myOptionsWithSynonyms,
		Join[
			cartridgeOptionUpdates,
			{
				storageCapsUpdate,
				connectorTypeUpdate,
				defaultStorageConditionUpdate
			}
		]
	];

	(* Resolve any remaining options that are Automatic to Null *)
	finalizedOptions = Replace[
		optionsWithCartridgeUpdates,
		Automatic -> Null,
		{1}
	];
	
	(* Return our options. *)
	Normal[finalizedOptions]
];

(* Helper function to resolve the options to our function. *)
(* Just use the default for existing objects that resolves any Automatics to the current field value *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadColumnOptions[myType_, myInput:ObjectP[], myOptions_, rawOptions_]:=resolveDefaultUploadFunctionOptions[myType, myInput, myOptions, rawOptions];

installDefaultUploadFunction[
	UploadColumn,
	Model[Item, Column],
	OptionResolver -> resolveUploadColumnOptions,
	InstallNameOverload -> True,
	InstallObjectOverload -> True
];
installDefaultValidQFunction[UploadColumn, Model[Item, Column]];
installDefaultOptionsFunction[UploadColumn, Model[Item, Column]];
