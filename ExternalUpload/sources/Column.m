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
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word],
				Description -> "The name of this column model.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Synonyms,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
				Description -> "List of possible alternative names this column model goes by.",
				ResolutionDescription -> "Resolves to the option Name, if provided. Otherwise, resolves to Null.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Products,
				Default -> Null,
				AllowNull -> True,
				Description -> "The products that can be used to order more of this Model[Column].",
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
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
				Category -> "Model Information",
				Widget -> Widget[Type -> Enumeration, Pattern :> (SeparationModeP)]
			},
			{
				OptionName -> ColumnType,
				Default -> Null,
				AllowNull -> True,
				Description -> "The scale of the chromatography to be performed on the column. Analytical columns are used for smaller volumes and mainly for identification purposes. Preparative columns are used for larger volumes and mainly for separation purposes. Guard columns are mounted between the injector and main column to protect the main column from impurities.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (ColumnTypeP)]
			},
			{
				OptionName -> PackingType,
				Default -> Null,
				AllowNull -> False,
				Description -> "The method used to fill the column with the resin, be that by hand packing with loose solid resin, by inserting a disposable cartridge, or with a column which has been prepacked during manufacturing.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (ColumnPackingTypeP)]
			},
			{
				OptionName -> PackingMaterial,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "Chemical composition of the packing material in the column.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (ColumnPackingMaterialP)]
			},
			{
				OptionName -> FunctionalGroup,
				Default -> Null,
				AllowNull -> True,
				Description -> "The functional group displayed on the column's stationary phase.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (ColumnFunctionalGroupP)]
			},
			{
				OptionName -> ParticleSize,
				Default -> Null,
				AllowNull -> True,
				Description -> "The size of the particles that make up the column packing material.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Nanometer],
					Units -> {Millimeter, {Millimeter, Micrometer, Nanometer}}
				]
			},
			{
				OptionName -> PoreSize,
				Default -> Null,
				AllowNull -> True,
				Description -> "The average size of the pores within the column packing material.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Angstrom],
					Units -> {Nanometer, {Nanometer, Picometer, Angstrom}}
				]
			},
			{
				OptionName -> ResinCapacity,
				Default -> Null,
				AllowNull -> True,
				Description -> "The weight of the resin that the column can be packed with.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Gram],
					Units -> {Gram, {Gram, Milligram}}
				]
			},
			{
				OptionName -> CasingMaterial,
				Default -> Null,
				AllowNull -> True,
				Description -> "The material that the exterior of the column which houses the packing material is composed of.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (MaterialP)]
			},
			{
				OptionName -> InletFilterMaterial,
				Default -> Null,
				AllowNull -> True,
				Description -> "The material of the inlet filter through which the sample must travel before reaching the stationary phase.",
				Category -> "Physical Properties",
				Widget -> Widget[Type -> Enumeration, Pattern :> (FilterMembraneMaterialP)]
			},
			{
				OptionName -> InletFilterPoreSize,
				Default -> Null,
				AllowNull -> True,
				Description -> "The size of the pores in the inlet filter through which the sample must travel before reaching the stationary phase.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Micro * Meter],
					Units -> {Micrometer, {Micrometer, Nanometer}}
				]
			},
			{
				OptionName -> InletFilterThickness,
				Default -> Null,
				AllowNull -> True,
				Description -> "The thickness of the inlet filter through which the sample must travel before reaching the stationary phase.",
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
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
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
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
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
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
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
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
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
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
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
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
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
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Kelvin],
					Units -> {Celsius, {Celsius, Kelvin, Fahrenheit}}
				]
			},
			{
				OptionName -> MaxNumberOfUses,
				Default -> Null,
				AllowNull -> True,
				Description -> "The maximum number of injections for which this column is recommended to be used.",
				Category -> "Operating Limits",
				Widget -> Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			},
			{
				OptionName -> MaxAcceleration,
				Default -> Null,
				AllowNull -> True,
				Description -> "The maximum flow rate acceleration at which to ramp the speed of pumping solvent for this column.",
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
				Default -> Null,
				AllowNull -> True,
				Description -> "The internal diameter of the column.",
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
				Default -> Null,
				AllowNull -> True,
				Description -> "The internal length of the column.",
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
				Default -> Null,
				AllowNull -> True,
				Description -> "Total volume of the column. This is the sum of the packing volume and the void volume.",
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
				Default -> Null,
				AllowNull -> True,
				Description -> "The external dimensions of this model of column.",
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
				Default -> Null,
				AllowNull -> True,
				Description -> "The preferred guard column for use with this column.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Item, Column]}]
				]
			},
			{
				OptionName -> ProtectedColumns,
				Default -> Null,
				AllowNull -> True,
				Description -> "The analytical or preparative columns for which this column is preferred as a guard.",
				Category -> "Compatibility",
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Model[Item, Column]}]]
				]
			},
			{
				OptionName -> PreferredGuardCartridge,
				Default -> Null,
				AllowNull -> True,
				Description -> "The guard column cartridge which is preferred to be inserted into this column.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Item, Cartridge, Column]}]
				]
			},
			{
				OptionName -> PreferredColumnJoin,
				Default -> Null,
				AllowNull -> True,
				Description -> "The column join that best connects a column to this guard column.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Plumbing, ColumnJoin]}]
				]
			},
			{
				OptionName -> WettedMaterials,
				Default -> Null,
				AllowNull -> True,
				Description -> "The materials of which this sample is made that may come in direct contact with fluids.",
				Category -> "Compatibility",
				Widget -> Adder[Widget[Type -> Enumeration, Pattern :> (MaterialP)]]
			},
			{
				OptionName -> IncompatibleSolvents,
				Default -> Null,
				AllowNull -> True,
				Description -> "Chemicals that are incompatible for use with this column.",
				Category -> "Compatibility",
				Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]]
				]
			},
			{
				OptionName -> MinpH,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The minimum pH the column can handle.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 14]]
			},
			{
				OptionName -> MaxpH,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The maximum pH the column can handle.",
				ResolutionDescription -> "If PreferredGuardCartridge is specified, the value from that object is used. Otherwise, resolves to Null.",
				Category -> "Compatibility",
				Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 14]]
			},
			{
				OptionName -> StorageCaps,
				Default -> False,
				AllowNull -> False,
				Description -> "Indicates whether this column requires special caps when being stored (e.g. not being on the instrument).",
				Category -> "Storage Information",
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
			},
			{
				OptionName -> ConnectorType,
				Default -> FemaleFemale,
				AllowNull -> False,
				Description -> "Indicates how the inlets are connected to tubing -- Female is a ferrule/screw must enter in, and Male indicates that inlet screws into another female port.",
				Category -> "Storage Information",
				Widget -> Widget[Type -> Enumeration, Pattern :> ColumnConnectorTypeP] (*FemaleFemale | FemaleMale*)
			},
			
			{
				OptionName -> DefaultStorageCondition,
				Default -> Model[StorageCondition, "Ambient Storage"],
				AllowNull -> False,
				Description -> "The condition in which this model columns are stored when not in use by an experiment.",
				Category -> "Storage Information",
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[StorageCondition]]]
			}
		]
	},
	SharedOptions :> {
		ExternalUploadHiddenOptions
	}
];


(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadColumnOptions[myType_, myName_String, myOptions_, rawOptions_]:=Module[
	{outputOption, myOptionsAssociation, myOptionsWithName, myOptionsWithSynonyms, optionsToMatchCartridge, cartridgeOptionUpdates, optionsWithCartridgeUpdates},
	
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
	myOptionsWithSynonyms=If[MatchQ[Lookup[myOptionsWithName, Synonyms], Null] || (!MemberQ[Lookup[myOptionsWithName, Synonyms], Lookup[myOptionsWithName, Name]] && MatchQ[Lookup[myOptionsWithName, Name], _String]),
		Append[myOptionsWithName, Synonyms -> (Append[Lookup[myOptionsWithName, Synonyms] /. Null -> {}, Lookup[myOptionsWithName, Name]])],
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
	
	(* Replace with our resolved cartidge options. *)
	optionsWithCartridgeUpdates=ReplaceRule[myOptionsWithSynonyms, cartridgeOptionUpdates];
	
	(* Return our options. *)
	Normal[optionsWithCartridgeUpdates]
];

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadColumnOptions[myType_, myInput:ObjectP[], myOptions_, rawOptions_]:=Module[
	{objectPacket, fields, resolvedOptions},
	
	(* Lookup our packet from our cache. *)
	objectPacket=Experiment`Private`fetchPacketFromCache[myInput, Lookup[ToList[myOptions], Cache]];
	
	(* Get the definition of this type. *)
	fields=Association@Lookup[LookupTypeDefinition[myType], Fields];
	
	(* For each of our options, see if it exists as a field of the same name in the object. *)
	resolvedOptions=Association@KeyValueMap[
		Function[{fieldSymbol, fieldValue},
			Module[{fieldDefinition, formattedOptionSymbol, formattedFieldValue},
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
						Switch[Lookup[fieldDefinition, Class],
							Computable,
							Nothing,
							_List,
							fieldSymbol -> formattedFieldValue[[All, 2]],
							_,
							fieldSymbol -> formattedFieldValue
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

InstallDefaultUploadFunction[
	UploadColumn,
	Model[Item, Column],
	resolveUploadColumnOptions,
	{InstallNameOverload -> True, InstallObjectOverload -> True}
];
InstallValidQFunction[UploadColumn, Model[Item, Column]];
InstallOptionsFunction[UploadColumn, Model[Item, Column]];
