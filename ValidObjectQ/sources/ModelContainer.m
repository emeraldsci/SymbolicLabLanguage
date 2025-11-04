(* ::Package:: *)
 
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*Error messages*)
Error::RequiredNullOptions = "Since the option `1` is set to True, options `2` must be Null. Please either set `2` to Null or correct option `1`.";
Error::RequiredNullOptionsFromExistingField = "The option `1` was set to True `3`, therefore options `2` must be Null, which is not the case now. Please set `2` to Null, or set option `1` to False.";
Error::CoverTypesRequired = "If none of PermanentlySealed, BuiltInCover and Ampoule are True, `1` must not be Null. Please specify a non-Null value for CoverTypes option.";
Error::UnableToDetermineCoverTypes = "`1` option is required because none of PermanentlySealed, BuiltInCover and Ampoule are True, however it is missing from `2`. Please set this option manually.";
Error::CoverTypeInconsistency = "`2` is `4` allowed for `1` option for `3` input type. Please change the `1` option to a compatible value, such as `5`.";
Error::CoverTypeInconsistencyFromExistingField = "`1` option was incorrectly set to contain `2` by `4`, which is `5` allowed for `3` input type. Please change the `1` option to a compatible value manually, such as `6`.";
Error::SterilizationConflict = "If `1` is set to True, `2` must also be set to True.";
Error::SterilizationConflictFromExistingField = "Since `1` has been set to True according to `3`, `2` must also be set to True, which is currently not the case. Please set `2` to True as well.";
Error::SterilizationConflictWithExistingField = "Since you have set `1` to True, `2` option must also be set to True, however it is incorrectly set to `4` according to `3`. Please manually set `2` to True.";
Error::SterilizationConflictBetweenExistingField = "If `1` is set to True, `2` must also be set to True, however that's not the case currently according to `3`. Please change at least one option.";
Error::CleaningMethodConflict = "If `1` is not set to Null, `2` must be set to True.";
Error::CleaningMethodConflictFromExistingField = "Since `1` has been set to non-Null according to `3`, `2` must be set to True, which is currently not the case. Please set `2` to True as well.";
Error::CleaningMethodConflictWithExistingField = "Since you have set `1` to non-Null, `2` option must also be set to True, however it is incorrectly set to `4` according to `3`. Please manually set `2` to True.";
Error::CleaningMethodConflictBetweenExistingField = "If `1` is not set to Null, `2` must be set to True, however that's not the case currently according to `3`. Please manually change at least one of them.";
Error::PositionInconsistency = "All entries from `1` and `2` option must share the same Name of Position, which is not the case currently. Please check these two options and correct the position names, or set both to Automatic.";
Error::PositionInconsistencyFromExistingSource = "The entries you provided for option `1` does not share the same Name of Positions with option `2`, which is inherited from `3`. Please correct the position names of option `1` or manually specify option `2`.";
Error::PositionInconsistencyBetweenExistingSource = "The options `1` and `2`, which are both inherited from `3`, do not share the same set of Name of Positions among all entries. The Name of Positions for `1` are `4`, while Name of Positions for `2` are `5`. Please correct this by manually specify either the `1` or `2` option.";
Error::PermanentlySealedAmpouleHermeticConflict = "The options `1` and `2` cannot both be set to True simultaneously. Please change either one of these options.";
Error::PermanentlySealedAmpouleHermeticConflictFromExistingField = "Since option `1`, which is inherited from `3`, is set to True, option `2` cannot be True. Please set option `2` to False instead.";
Error::PermanentlySealedAmpouleHermeticConflictBetweenExistingField = "The options `1` and `2`, which were both inherited from `3`, were both set to True, which is not allowed. Please manually change at least one of them to False.";
Error::MissingInternalDimensions = "For input `1`, either the two indexes in `2` are informed, or `3` must be informed. Please modify your options accordingly.";
Error::ApertureRequired = "For input `1` Aperture option must be specified, unless any of the following options is set to True: {Ampoule, Dropper, Hermetic, PermanentlySealed}.";
Error::InconsistentPitch = "`1` option should be specified if and only if `2` is greater than 1. Please set `1` to Null, or change the value of `2` to greater than 1.";
Error::InconsistentPitchWithExistingField = "You have specified the `1` option, however this is not allowed since the `2` option was set to 1 according to `3`. Please either set `1` to Null, or manually change `2` to greater than 1.";
Error::InconsistentPitchToExistingField = "A non-Null value has been inherited from `3` for option `1`, however this conflicts with `2` option, because `1` should only be specified if `2` is greater than 1. Please manually set `1` option to Null, or change `2` to greater than 1.";
Error::InconsistentPitchBetweenExistingField = "The options `1` and `2` inherited from `3` conflicts with each other because `1` should only be specified if `2` is greater than 1. Please manually change either one of these options.";
Error::ConflictingOptionsMagnitude = "`1` option must be `3` `2`. Please correct either `1` or `2` option so that `1` is `3` `2`.";
Error::ConflictingOptionsMagnitudeWithExistingField = "The `1` option from `2` is `3`, however you attempted to specify `4` option to `5`. This is not possible because `1` must be `6` `4`. Please change your `4` option value or supply new option value for `1` so that `1` is `6` `4`.";
Error::ConflictingOptionsMagnitudeFromExistingField = "`1` option must be `3` `2`, however in the `4` this is not true. Please manually change at least one of these options.";
Error::ReusabilityConflict = "Since `1` option is set to True, `2` must be specified. Please set the `2` option to a non-Null value, or change `1` option to False.";
Error::ReusabilityConflictNoNull = "Since `1` option has been resolved to True, `2` cannot be set to Null. Please either change the `2` option, or change `1` to False.";
Error::ReusabilityConflictWithExistingField = "You have set option `1` to True, however the related option(s) `2` were set to Null according to `3`, which is not allowed. Please manually specify the `2` options.";
Error::ReusabilityConflictBetweenExistingField = "Inherited from `3`, option `1` was set to True while option `2` is set to Null, which is not allowed. Please manually change option `1` to False, or supply non-Null value for option `2`.";
Error::InternalConicalDepthNotAllowed = "`1` option can be specified only if `2` is RoundBottom or VBottom. Please set the option `1` to Null, or change the `2` option.";
Error::InternalConicalDepthNotAllowedWithExistingField = "`1` option can be specified only if `2` is RoundBottom or VBottom, however the `2` is set to `4` by `3`. Please manually change option `2`, or set `1` to Null.";
Error::InternalConicalDepthNotAllowedDueToExistingField = "You have specified `2` option to be `4`, however the `1` option inherited non-Null value from `3`, which is not compatible with `4`. Please manually set `1` to Null, or change `2` option to RoundBottom or VBottom.";
Error::InternalConicalDepthNotAllowedBetweenExistingField = "The options `1` and `2` inherited from `3` are not compatible with each other; Non-Null value for `1` option is only allowed if `2` is RoundBottom or VBottom. Please manually change `1` to Null or set `2` to RoundBottom or VBottom.";
Error::MultiplePositions = "The `1` option has more than one entry, which is not allowed for `2` input type. Please remove the excess entries from `1` position.";
Error::MultiplePositionsFromExistingObject = "The `1` option inherited from `3` has more than one entry, which is not allowed for `2` input type. Please manually set the `1` option, or set it to Null or Automatic.";
Error::NotAllowedPositionName = "For `2` type input, the only allowed position name for `1` option is \"A1\". Please change your `1` option so that the first entry is \"A1\".";
Error::NotAllowedPositionNameFromExistingObject = "For `2` type input, the only allowed position name for `1` option is \"A1\", which does not match the current `1` option inherited from `3`. Please manually change the `1` option so that the first entry is \"A1\".";
Error::ConflictingDimensionsEntry = "If option `1` is set to Circle and `2` is specified, the first and second entry of `2` must be identical. Please change your `2` option, or set `1` to anything other than Circle.";
Error::ConflictingDimensionsEntryWithExistingField = "You have set the option `1` to Circle, but the `2` inherited from `3` has unequal X and Y dimensions. Please manually correct `2` option, or change `1` option to other values.";
Error::ConflictingDimensionsEntryFromExistingField = "The `1` option inherited from `3` is set to Circle, which is not compatible with the `2` option because Circular cross-section requires the first two entries of `2` option to equal to each other. Please manually change `1` to other values, or change your `2` option so that the first two entries are equal to each other.";
Error::ConflictingDimensionsEntryBetweenExistingField = "The `1` option inherited from `3` is set to Circle, however the `2` option also inherited from `3` has unequal X and Y dimensions. Please correct either of these two options.";
Error::ColumnRowInconsistency = "The `1` must equal to the `4` of option `2` and `3`, which is not the case now. Please correct one of these options, or leave `1` automatic so it can be auto-computed.";
Error::ColumnRowInconsistencyWithExistingField = "The `1` must equal to the `4` option `2` and `3`, however option(s) `5` inherited from `6` does not satisfy such condition. Please correct `4` options manually.";
Error::MutuallyExclusiveOptions = "One and only one of the two options `1` and `2` should be specified. Please set one of them to Null.";
Error::MutuallyExclusiveOptionsWithExistingField = "You have specified option `1` while option `2` inherited non-Null value from `3`. This is not allowed because option `1` and `2` are mutually exclusive; please manually set option `2` to Null.";
Error::MutuallyExclusiveOptionsBetweenExistingField = "One and only one of the two options `1` and `2` should be specified, but currently both were `4` according to `3`. Please manually set one of them to Null";
Error::InvalidDestinationContainerModel = "For filter models with FilterType -> Centrifuge, only container models which has Counterweights can be used as `1` option. Please change the `1` to a different container model which has non-empty Counterweights field, or set it to Null.";
Error::InvalidDestinationContainerModelWithExistingField = "For filter models with FilterType -> Centrifuge, The `1` option is set to `2` by `3`, which is not valid because `2` does not have and Counterweights defined. Please manually change the `1` to a different container model which has non-empty Counterweights field, or set it to Null.";
Error::RedundantOptions = "The following options `2` are specified, which are not applicable for inputs `1`. Please set those options to Null.";
Error::RedundantOptionsFromExistingField = "The following options `2` are inherited from `3`, which are not applicable for inputs `1`. Please manually set `2` options to Null.";
Error::ConditionalRequiredOptions = "For `2` type input, the following options `1` are required but are currently set to Null if `3`. Please specify values for these options.";
Error::ConditionalRequiredOptionsUnableToFindInfo = "For `2` type input, the following options `1` are required if `3`, but currently their information cannot be retrieved from `4`. Please specify values for these options.";
Error::FunctionalGroupMismatch = "For `2` type input, if ChromatographyType option is set to Flash and PackingType is Prepacked, option `1` must be set to C18 or Null. Please correct the `1` option.";
Error::FunctionalGroupMismatchFromExistingSource = "For `2` type input, if ChromatographyType option is set to Flash and PackingType is Prepacked, option `1` must be set to C18 or Null, however it is currently set to `3` according to `4`. Please correct the `1` option manually.";
Error::IncorrectPositionLength = "The length of the `1` option does not match the `2` option `3`. Currently, `1` option has `4` entries, while the `2` is `5`. Please check your `1` option input and add/remove entries accordingly, or set it to Automatic to allow auto-calculation, or set it to Null so that it can be filled on our side in lab.";
Error::IncorrectNumberOfWells = "You have specified the `2` option, which does not match the length of `1` option `3`. Currently, `1` option has `4` entries, while the `2` is `5`. Please double check your `1` and `2` option, either change `2` to match the length of `1`, or add/remove entry of `1` to match `2`.";
Error::IncorrectResolvedNumberOfWells = "The `2` option calculated from Rows and Columns option does not match the length of `1` option `3`. Currently, `1` option has `4` entries, while the `2` is `5`.  Please double check your `1`, Rows and Columns option, either change Rows or Columns to match the length of `1`, or add/remove entry of `1` to match the product of Rows and Columns.";
Error::InconsistentPositionAndNumberOfWells = "The length of the `1` option does not match the `2` option, both of which are `3`. Currently, `1` option has `4` entries, while the `2` is `5`. Please manually correct at least one of them so that length of `1` matches `2`.";
Error::IncorrectOptionMagnitude = "The following options: `1` must be specified in a way such that option value of the left ones are `2` the right ones.";
Error::MultipleMutuallyExclusiveOptions = "One and only one of the following options `1` should be specified. Please choose one to keep and set all other options to Null.";


(* ::Subsection:: *)
(*validModelContainerQTests*)
DefineOptions[
	validModelContainerQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerQTests[packet:PacketP[Model[Container]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache, fastAssoc, object, identifier, commonFields, parameterizedFields},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};
	object = Lookup[packet, Object];
	identifier = If[DatabaseMemberQ[object],
		object,
		Lookup[packet, Type]
	];
	fastAssoc = updateFastAssoc[{{ProductsContained, ProductModel, Packet[SingleUse]}}, packet, cache];

	commonFields = If[MatchQ[Lookup[packet, Type], Model[Container, Site]],
		{
			Name,
			Synonyms,
			Authors,
			Dimensions
		},
		{
			Name,
			Synonyms,
			Authors,
			MinTemperature,
			MaxTemperature
		}
	];

	parameterizedFields = {
		Positions,
		PositionPlotting,
		Dimensions,
		CrossSectionalShape,
		SelfStanding
	};

	(* construct tests *)
	{

		(* ----------General Shared Field shaping ----------*)

		NotNullFieldTest[packet,
			If[MatchQ[Lookup[packet, PendingParameterization], True],
				commonFields,
				Join[commonFields, parameterizedFields]
			],
			Message -> Automatic,
			ParentFunction -> "UploadContainerModel",
			FieldSource -> fieldSource
		],


		FieldComparisonTest[packet,
			{MaxTemperature, MinTemperature},
			GreaterEqual,
			Message -> Automatic,
			FieldSource -> fieldSource
		],

		RequiredTogetherTest[packet,{
			StickerPositionOnReceiving,
			PositionStickerPlacementImage
		}],

		RequiredTogetherTest[packet,{
			StickerConnectionOnReceiving,
			ConnectionStickerPlacementImage
		}],

		Test["The contents of the Name field is a member of the Synonyms field:",
			MemberQ[Lookup[packet, Synonyms],Lookup[packet, Name]],
			True,
			Message -> {Hold[Error::NameIsPartOfSynonyms], identifier}
		],

		Test["If PermanentlySealed is True, CoverTypes and CoverFootprints must be Null:",
			If[MatchQ[Lookup[packet, PermanentlySealed], True],
				MatchQ[Lookup[packet, CoverTypes], {}] && MatchQ[Lookup[packet, CoverFootprints], {}],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, PermanentlySealed],
				User, {Hold[Error::RequiredNullOptions], PermanentlySealed, {CoverTypes, CoverFootprints}},
				Template, {Hold[Error::RequiredNullOptionsFromExistingField], PermanentlySealed, {CoverTypes, CoverFootprints}, "according to Template option"},
				Field, {Hold[Error::RequiredNullOptionsFromExistingField], PermanentlySealed, {CoverTypes, CoverFootprints}, "according to database"},
				_, {Hold[Error::RequiredNullOptions], PermanentlySealed, {CoverTypes, CoverFootprints}}
			]
		],


		Test["If BuiltInCover is True, CoverTypes and CoverFootprints must be Null:",
			If[MatchQ[Lookup[packet, BuiltInCover], True],
				MatchQ[Lookup[packet, CoverTypes], {}] && MatchQ[Lookup[packet, CoverFootprints], {}],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, BuiltInCover],
				User, {Hold[Error::RequiredNullOptions], BuiltInCover, {CoverTypes, CoverFootprints}},
				Template, {Hold[Error::RequiredNullOptionsFromExistingField], BuiltInCover, {CoverTypes, CoverFootprints}, "according to Template option"},
				Field, {Hold[Error::RequiredNullOptionsFromExistingField], BuiltInCover, {CoverTypes, CoverFootprints}, "according to database"},
				_, {Hold[Error::RequiredNullOptions], BuiltInCover, {CoverTypes, CoverFootprints}}
			]
		],

		Test["If Ampoule is True, CoverTypes and CoverFootprints must be Null:",
			If[MatchQ[Lookup[packet, Ampoule], True],
				MatchQ[Lookup[packet, CoverTypes], {}] && MatchQ[Lookup[packet, CoverFootprints], {}],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, Ampoule],
				User, {Hold[Error::RequiredNullOptions], Ampoule, {CoverTypes, CoverFootprints}},
				Template, {Hold[Error::RequiredNullOptionsFromExistingField], Ampoule, {CoverTypes, CoverFootprints}, "according to Template option"},
				Field, {Hold[Error::RequiredNullOptionsFromExistingField], Ampoule, {CoverTypes, CoverFootprints}, "according to database"},
				_, {Hold[Error::RequiredNullOptions], Ampoule, {CoverTypes, CoverFootprints}}
			]
		],

		Test["If none of PermanentlySealed, BuiltInCover and Ampoule are True, CoverTypes must not be Null:",
			If[MatchQ[Lookup[packet,Type],Alternatives[Model[Container, Vessel],Model[Container,Plate]]],
				If[And[MatchQ[Lookup[packet, BuiltInCover], Except[True]], MatchQ[Lookup[packet, Ampoule], Except[True]],MatchQ[Lookup[packet, PermanentlySealed], Except[True]]],
					MatchQ[Length[DeleteCases[ToList[Lookup[packet, CoverTypes, {}]], Null]], GreaterP[0]],
					True
				],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, CoverTypes],
				User, {Hold[Error::CoverTypesRequired], CoverTypes},
				Template, {Hold[Error::UnableToDetermineCoverTypes], CoverTypes, "Template option"},
				Field, {Hold[Error::UnableToDetermineCoverTypes], CoverTypes, "database"},
				_, {Hold[Error::CoverTypesRequired], CoverTypes}
			]
		],

		Test["If the CoverTypes contains Seal, we must be a Model[Container, Plate]:",
			Lookup[packet,{CoverTypes,Type}],
			{_?(MemberQ[#, Seal]&), TypeP[Model[Container, Plate]]} | {Except[_?(MemberQ[#, Seal]&)], _},
			Message -> Switch[Lookup[fieldSource, CoverTypes],
				User, {Hold[Error::CoverTypeInconsistency], CoverTypes, "Seal", "Model[Container, Plate]", "only", "Screw, Crimp, Place, Snap"},
				Template, {Hold[Error::CoverTypeInconsistencyFromExistingField], CoverTypes, "Seal", "Model[Container, Plate]", "Template option", "only", "Screw, Crimp, Place, Snap"},
				Field, {Hold[Error::CoverTypeInconsistencyFromExistingField], CoverTypes, "Seal", "Model[Container, Plate]", "database", "only", "Screw, Crimp, Place, Snap"},
				_, {Hold[Error::CoverTypeInconsistency], CoverTypes, "Seal", "Model[Container, Plate]", "only", "Screw, Crimp, Place, Snap"}
			]
		],

		Test["If the CoverTypes contains Screw, we must not be a Model[Container, Plate]:",
			Lookup[packet,{CoverTypes,Type}],
			{_?(MemberQ[#, Screw]&), Except[TypeP[Model[Container, Plate]]]} | {Except[_?(MemberQ[#, Screw]&)], _},
			Message -> Switch[Lookup[fieldSource, CoverTypes],
				User, {Hold[Error::CoverTypeInconsistency], CoverTypes, "Screw", "Model[Container, Plate]", "not", "Seal, Place, Snap"},
				Template, {Hold[Error::CoverTypeInconsistencyFromExistingField], CoverTypes, "Screw", "Model[Container, Plate]", "Template option", "not", "Seal, Place, Snap"},
				Field, {Hold[Error::CoverTypeInconsistencyFromExistingField], CoverTypes, "Screw", "Model[Container, Plate]", "database", "not", "Seal, Place, Snap"},
				_, {Hold[Error::CoverTypeInconsistency], CoverTypes, "Screw", "Model[Container, Plate]", "not", "Seal, Place, Snap"}
			]
		],

		Test["If the CoverTypes contains Crimp, we must not be a Model[Container, Plate]:",
			Lookup[packet,{CoverTypes,Type}],
			{_?(MemberQ[#, Crimp]&), Except[TypeP[Model[Container, Plate]]]} | {Except[_?(MemberQ[#, Crimp]&)], _},
			Message -> Switch[Lookup[fieldSource, CoverTypes],
				User, {Hold[Error::CoverTypeInconsistency], CoverTypes, "Crimp", "Model[Container, Plate]", "not", "Seal, Place, Snap"},
				Template, {Hold[Error::CoverTypeInconsistencyFromExistingField], CoverTypes, "Crimp", "Model[Container, Plate]", "Template option", "not", "Seal, Place, Snap"},
				Field, {Hold[Error::CoverTypeInconsistencyFromExistingField], CoverTypes, "Crimp", "Model[Container, Plate]", "database", "not", "Seal, Place, Snap"},
				_, {Hold[Error::CoverTypeInconsistency], CoverTypes, "Crimp", "Model[Container, Plate]", "not", "Seal, Place, Snap"}
			]
		],

		RequiredTogetherTest[packet,
			{
				CleaningMethod,
				PreferredWashBin
			},
			Message -> Automatic,
			FieldSource -> fieldSource
		],

		Test["If Sterilized field is True, Sterile field must be True:",
			If[MatchQ[Lookup[packet, Sterilized], True],
				TrueQ[Lookup[packet, Sterile]],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, {Sterile, Sterilized}],
				{(User | Resolved), (User | Resolved)}, {Hold[Error::SterilizationConflict], Sterilized, Sterile},
				{Template, (User | Resolved)}, {Hold[Error::SterilizationConflictFromExistingField], Sterilized, Sterile, "Template option"},
				{(User | Resolved), Template}, {Hold[Error::SterilizationConflictWithExistingField], Sterilized, Sterile, "Template option", Lookup[packet, Sterile]},
				{Field, (User | Resolved)}, {Hold[Error::SterilizationConflictFromExistingField], Sterilized, Sterile, "database"},
				{(User | Resolved), Field}, {Hold[Error::SterilizationConflictWithExistingField], Sterilized, Sterile, "database", Lookup[packet, Sterile]},
				{Template, Template}, {Hold[Error::SterilizationConflictBetweenExistingField], Sterilized, Sterile, "Template option"},
				{Field, Field}, {Hold[Error::SterilizationConflictBetweenExistingField], Sterilized, Sterile, "database"},
				{_, _}, {Hold[Error::SterilizationConflict], Sterilized, Sterile}
			]
		],

		Test["A container of this model cannot be obtained by both a normal product and a kit product (i.e., Products and KitProducts cannot both be populated):",
			Lookup[packet, {Products, KitProducts}],
			Alternatives[
				{{}, {}},
				{{ObjectP[Object[Product]]..}, {}},
				{{}, {ObjectP[Object[Product]]..}}
			]
		],


		(* not all reusable containers need to be cleaned, but for sure if we ARE cleaning it, it is reusable *)
		Test["If CleaningMethod field is populated, Reusable field must be True:",
			If[MatchQ[Lookup[packet,CleaningMethod],CleaningMethodP],
				TrueQ[Lookup[packet,Reusable]],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, {CleaningMethod, Reusable}],
				{(User | Resolved), (User | Resolved)}, {Hold[Error::CleaningMethodConflict], CleaningMethod, Reusable},
				{Template, (User | Resolved)}, {Hold[Error::CleaningMethodConflictFromExistingField], CleaningMethod, Reusable, "Template option"},
				{(User | Resolved), Template}, {Hold[Error::CleaningMethodConflictWithExistingField], CleaningMethod, Reusable, "Template option", Lookup[packet, Reusable]},
				{Field, (User | Resolved)}, {Hold[Error::CleaningMethodConflictFromExistingField], CleaningMethod, Reusable, "database"},
				{(User | Resolved), Field}, {Hold[Error::CleaningMethodConflictWithExistingField], CleaningMethod, Reusable, "database", Lookup[packet, Reusable]},
				{Template, Template}, {Hold[Error::CleaningMethodConflictBetweenExistingField], CleaningMethod, Reusable, "Template option"},
				{Field, Field}, {Hold[Error::CleaningMethodConflictBetweenExistingField], CleaningMethod, Reusable, "database"},
				{_, _}, {Hold[Error::CleaningMethodConflict], CleaningMethod, Reusable}
			]
		],

		If[MatchQ[Lookup[packet,Type],Except[Model[Container, Site]]] && (!TrueQ[Lookup[packet, PendingParameterization]]),
			Test["Every member of Positions also has a corresponding PositionPlotting entry:",
				{
					Complement[Lookup[Lookup[packet,Positions],Name],Lookup[Lookup[packet,PositionPlotting],Name]],
					Complement[Lookup[Lookup[packet,PositionPlotting],Name],Lookup[Lookup[packet,Positions],Name]]
				},
				{{}, {}},
				Message -> Switch[Lookup[fieldSource, {Positions, PositionPlotting}],
					{User, User}, {Hold[Error::PositionInconsistency], Positions, PositionPlotting},
					{User, Template}, {Hold[Error::PositionInconsistencyFromExistingSource], Positions, PositionPlotting, "Template option"},
					{Template, User}, {Hold[Error::PositionInconsistencyFromExistingSource], PositionPlotting, Positions, "Template option"},
					{User, Field}, {Hold[Error::PositionInconsistencyFromExistingSource], Positions, PositionPlotting, "database"},
					{Field, User}, {Hold[Error::PositionInconsistencyFromExistingSource], PositionPlotting, Positions, "database"},
					{Template, Template}, {Hold[Error::PositionInconsistencyBetweenExistingSource], Positions, PositionPlotting, "Template option", Lookup[Lookup[packet, Positions], Name], Lookup[Lookup[packet, PositionPlotting], Name]},
					{Field, Field}, {Hold[Error::PositionInconsistencyBetweenExistingSource], Positions, PositionPlotting, "database", Lookup[Lookup[packet, Positions], Name], Lookup[Lookup[packet, PositionPlotting], Name]},
					{_, _}, {Hold[Error::PositionInconsistency], Positions, PositionPlotting}
				]
			],
			(* Difference between these two tests: If we are still PendingParameterization, then it's OK that both of these fields are {} *)
			Test["Every member of Positions also has a corresponding PositionPlotting entry:",
				{
					Complement[Lookup[Lookup[packet,Positions],Name, {}],Lookup[Lookup[packet,PositionPlotting],Name, {}]],
					Complement[Lookup[Lookup[packet,PositionPlotting],Name, {}],Lookup[Lookup[packet,Positions],Name, {}]]
				},
				{{}, {}},
				Message -> Switch[Lookup[fieldSource, {Positions, PositionPlotting}],
					{User, User}, {Hold[Error::PositionInconsistency], Positions, PositionPlotting},
					{User, Template}, {Hold[Error::PositionInconsistencyFromExistingSource], Positions, PositionPlotting, "Template option"},
					{Template, User}, {Hold[Error::PositionInconsistencyFromExistingSource], PositionPlotting, Positions, "Template option"},
					{User, Field}, {Hold[Error::PositionInconsistencyFromExistingSource], Positions, PositionPlotting, "database"},
					{Field, User}, {Hold[Error::PositionInconsistencyFromExistingSource], PositionPlotting, Positions, "database"},
					{Template, Template}, {Hold[Error::PositionInconsistencyBetweenExistingSource], Positions, PositionPlotting, "Template option", Lookup[Lookup[packet, Positions], Name], Lookup[Lookup[packet, PositionPlotting], Name]},
					{Field, Field}, {Hold[Error::PositionInconsistencyBetweenExistingSource], Positions, PositionPlotting, "database", Lookup[Lookup[packet, Positions], Name], Lookup[Lookup[packet, PositionPlotting], Name]},
					{_, _}, {Hold[Error::PositionInconsistency], Positions, PositionPlotting}
				]
			]
		],

		Test["If PreferredCamera->Plate, PreferredIllumination cannot be Side due to instrument limitations:",
			Lookup[packet, {PreferredCamera, PreferredIllumination}],
			Alternatives[
				{Plate, Except[Side]},
				{Except[Plate], _}
			]
		],

		Test["If the container model is in the Public ECL Catalog, ImageFileScale is populated:",
			With[
				{catalogContainerModels = DeleteDuplicates[Cases[Catalog`Private`catalogObjs[], ObjectP[Model[Container]]]]},
				If[MemberQ[catalogContainerModels, Lookup[packet, Object]],
					!MatchQ[Lookup[packet, ImageFileScale], Null],
					True
				]
			],
			True
		],

		Test["If the container model is an Ampoule and arrives as a product containing a sample, that model sample is set to SingleUse -> True:",
			If[TrueQ[Lookup[packet, Ampoule]] && MatchQ[Lookup[packet, ProductsContained], {ObjectP[Object[Product]]..}],
				MatchQ[Experiment`Private`fastAssocLookup[fastAssoc, object, {ProductsContained, ProductModel, SingleUse}], {True..}],
				True
			],
			True
		],

		Test["If PermanentlySealed is True, Ampoule must not be True:",
			Lookup[packet, {Ampoule, PermanentlySealed}],
			Alternatives[
				{_, Null|False},
				{Except[True], True}
			],
			Message -> Switch[Lookup[fieldSource, {PermanentlySealed, Ampoule}],
				{User, User}, {Hold[Error::PermanentlySealedAmpouleHermeticConflict], PermanentlySealed, Ampoule},
				{(User | Resolved), Template}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictFromExistingField], Ampoule, PermanentlySealed, "Template option"},
				{Template, (User | Resolved)}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictFromExistingField], PermanentlySealed, Ampoule, "Template option"},
				{(User | Resolved), Field}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictFromExistingField], Ampoule, PermanentlySealed, "database"},
				{Field, (User | Resolved)}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictFromExistingField], PermanentlySealed, Ampoule, "database"},
				{Template, Template}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictBetweenExistingField], PermanentlySealed, Ampoule, "Template option"},
				{Field, Field}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictBetweenExistingField], PermanentlySealed, Ampoule, "database"},
				{_, _}, {Hold[Error::PermanentlySealedAmpouleHermeticConflict], PermanentlySealed, Ampoule}
			]
		],

		Test["If PermanentlySealed is True, Hermetic must not be True:",
			Lookup[packet, {Hermetic, PermanentlySealed}],
			Alternatives[
				{_, Null|False},
				{Except[True], True}
			],
			Message -> Switch[Lookup[fieldSource, {PermanentlySealed, Hermetic}],
				{User, User}, {Hold[Error::PermanentlySealedAmpouleHermeticConflict], PermanentlySealed, Hermetic},
				{(User | Resolved), Template}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictFromExistingField], Hermetic, PermanentlySealed, "Template option"},
				{Template, (User | Resolved)}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictFromExistingField], PermanentlySealed, Hermetic, "Template option"},
				{(User | Resolved), Field}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictFromExistingField], Hermetic, PermanentlySealed, "database"},
				{Field, (User | Resolved)}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictFromExistingField], PermanentlySealed, Hermetic, "database"},
				{Template, Template}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictBetweenExistingField], PermanentlySealed, Hermetic, "Template option"},
				{Field, Field}, {Hold[Error::PermanentlySealedAmpouleHermeticConflictBetweenExistingField], PermanentlySealed, Hermetic, "database"},
				{_, _}, {Hold[Error::PermanentlySealedAmpouleHermeticConflict], PermanentlySealed, Hermetic}
			]
		],

		Test["If the StorageOrientation is Side|Face StorageOrientationImage must be populated unless it is an unverified Plate/Vessel:",
			Lookup[packet, {StorageOrientation, StorageOrientationImage, VerifiedContainerModel}, $Failed],
			Alternatives[
				{_,_, (False|Null)},
				{(Side|Face), ObjectP[], _},
				{Except[(Side|Face)], _, _}
			]
		],

		Test["If the StorageOrientation is Upright StorageOrientationImage or ImageFile must be populated unless it is an unverified Plate/Vessel:",
			Lookup[packet, {StorageOrientation, StorageOrientationImage, ImageFile, VerifiedContainerModel}],
			Alternatives[
				{_, _, _, (False|Null)},
				{Upright, ObjectP[], _, _},
				{Upright, _, ObjectP[], _},
				{Except[Upright], _, _, _}
			]
		],

		(* ---------- Finer-grained tests for container validity ---------- *)

		containerModelImageAspectRatio[packet],
		If[TrueQ[Lookup[packet, PendingParameterization]],
			Nothing,
			containerModelPositionsDimensionsValid[packet]
		]
	}
];


(* Check that all Positions fit within the container's Dimensions *)
(* Works only in the X and Y dimensions; ignores Z *)
containerModelPositionsDimensionsValid[packet:PacketP[]]:=Module[
	{positions,positionPlotting,modelShape,xDim,yDim,zDim,oldPositions,dims,modelPoly,positionPoly,positionPolys,positionNames,valid,invalid},

	(* Look up required fields *)
	{positions,positionPlotting,modelShape}=Lookup[packet,{Positions,PositionPlotting,CrossSectionalShape}];

	(* Return no test if either Positions or PositionPlotting are empty.
		RequiredTogether test shared among all container types will catch cases where one or the other is not populated. *)
	If[Or[MatchQ[positions,{}], MatchQ[positionPlotting, {}]], Return[Nothing]];

	dims=Unitless[#, Meter]&/@Lookup[packet,Dimensions];
	{xDim,yDim,zDim}=dims[[#]] & /@ {1, 2, 3};

	(* generate single position definitions from information from the Positions/PositionPlotting fields for each of the models *)
	oldPositions = Map[
		Function[position,
			Module[{dimensions, positionPlottingEntry, anchorPoint},

				(* get the dimensions into a single tuple; these can be Null, so turn into 0 Meter *)
				dimensions = Lookup[position, {MaxWidth, MaxDepth, MaxHeight}]/.{Null->0 Meter};

				(* find the appropriate PositionPlotting entry for this position name *)
				positionPlottingEntry = SelectFirst[positionPlotting, MatchQ[Lookup[#, Name], Lookup[position, Name]]&, <||>];

				(* from the plotting entry, get the anchor point as a single spec *)
				anchorPoint = Lookup[positionPlottingEntry, {XOffset, YOffset, ZOffset}, Null];

				(* assemble a single position entry with all informatino combined into downstream expected format *)
				{Name->Lookup[position, Name], AnchorPoint->anchorPoint, Dimensions->dimensions, CrossSectionalShape->Lookup[positionPlottingEntry, CrossSectionalShape], Rotation->Lookup[positionPlottingEntry, Rotation]}
			]
		],
		positions
	];

	Test[
		"Positions all lie within two of three of the modelContainer's dimensions (requires that the Positions, PositionPlotting, CrossSectionalShape, and Dimensions fields be informed):",
		If[AnyTrue[{oldPositions,modelShape,dims},NullQ],
			True,

			Module[{},
				modelPoly = If[MatchQ[modelShape,(Rectangle|Null)],
					Polygon[{{0,0},{0,yDim},{xDim,yDim},{xDim,0}}],
					Disk[{xDim/2,yDim/2},xDim]
				]; (* Change to footprint later? *)

				(* Define a private helper to Convert a given position to a polygon in the modelContainer coordinate system and rotate it appropriately if necessary *)
				positionPoly[pos_] := Module[
					{anchor=Unitless[AnchorPoint/.pos, Meter],shape=CrossSectionalShape/.pos,rot=Rotation/.pos,(*rotFcn=RotationTransform[],*)halfX=Unitless[(Dimensions/.pos)[[1]]/2, Meter],halfY=Unitless[(Dimensions/.pos)[[2]]/2, Meter]},

					(* Draw the graphics primitive for this position in the coordinate system of the parent modelContainer, rotating as appropriate *)
					Locations`Private`rotatePrimitive[
						If[MatchQ[shape,(Rectangle|Null)],
							Polygon[{{anchor[[1]]-halfX,anchor[[2]]-halfY},{anchor[[1]]-halfX,anchor[[2]]+halfY},{anchor[[1]]+halfX,anchor[[2]]+halfY},{anchor[[1]]+halfX,anchor[[2]]-halfY}}],
							Disk[anchor[[;;2]],halfX]
						],
						anchor,
						rot Degree
					]
				];

				(* Convert all positions to polygons using the function above *)
				positionPolys = {Name/.#,positionPoly[#]}&/@oldPositions;

				(* Figure out which positions are valid and which are not using a helper *)
				valid = Select[positionPolys,Locations`Private`regionEnclosedQ[modelPoly,Last[#],1]&];
				invalid = Complement[positionPolys,valid];
				Length[invalid]==0
			]
		],
		True
	]
];


(* Check that the contents of ContainerImage2D, if they exist, are the same aspect ratio as the modelContainer (within 1%) *)
containerModelImageAspectRatio[packet:PacketP[]]:=Module[
	{containerImage2DFile,dimensionX,dimensionY,dims},

	{containerImage2DFile,dims}=Lookup[packet,{ContainerImage2DFile,Dimensions}];
	If[NullQ[containerImage2DFile],
		Return[Nothing]
	];
	{dimensionX,dimensionY}=dims[[#]]&/@{1,2};

	Test[
		"ContainerImage2DFile's aspect ratio matches the modelContainer's X-Y aspect ratio to within 1%",
		Module[
			{img,ctrAspectRatio,imgDims,imgAspectRatio,aspectRatioPctDiff},
			img=ImportCloudFile[containerImage2DFile];
			ctrAspectRatio=(dimensionX/dimensionY);
			imgDims=ImageDimensions[img];
			imgAspectRatio=imgDims[[1]]/imgDims[[2]];
			aspectRatioPctDiff = 100 * Abs[(1-(ctrAspectRatio/imgAspectRatio))];
			aspectRatioPctDiff<1
		],
		True
	]
];


(* ::Subsection::Closed:: *)
(*validModelContainerBagQTests*)


validModelContainerBagQTests[packet:PacketP[Model[Container,Bag]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet,{
		CleaningMethod,
		MinVolume,
		PreferredBalance,
		PreferredCamera,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsubsection:: *)
(*validModelContainerBagDishwasherQTests*)


validModelContainerBagDishwasherQTests[packet:PacketP[Model[Container,Bag,Dishwasher]]]:={
	(* Shared fields shaping *)
	NotNullFieldTest[packet,{
		MeshSize
	}]
};

(* ::Subsubsection:: *)
(*validModelContainerBagAsepticQTests*)


validModelContainerBagAsepticQTests[packet:PacketP[Model[Container,Bag,Aseptic]]]:={};


(* ::Subsubsection:: *)
(*validModelContainerBagAutoclaveQTests*)


validModelContainerBagAutoclaveQTests[packet:PacketP[Model[Container,Bag,Autoclave]]]:={
	(* Shared fields shaping *)
	NotNullFieldTest[packet,{
		SterilizationMethods
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerBenchQTests*)


validModelContainerBenchQTests[packet:PacketP[Model[Container,Bench]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerBenchReceivingQTests*)


validModelContainerBenchReceivingQTests[packet:PacketP[Model[Container,Bench, Receiving]]]:={};


(* ::Subsection::Closed:: *)
(*validModelContainerBuildingQTests*)


validModelContainerBuildingQTests[packet:PacketP[Model[Container,Building]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerSiteQTests*)


validModelContainerSiteQTests[packet:PacketP[Model[Container,Site]]]:={
(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerCabinetQTests*)


validModelContainerCabinetQTests[packet:PacketP[Model[Container,Cabinet]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};

(* ::Subsection::Closed:: *)
(*validModelContainerCapillaryQTests*)


validModelContainerCapillaryQTests[packet:PacketP[Model[Container, Capillary]]]:={

	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume}],

	(* Fields which should not be null *)
	NotNullFieldTest[packet, {
		CasingRequired,
		IrretrievableContents,
		CapillaryType,
		Barcode},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerCartDockQTests*)


validModelContainerCartDockQTests[packet:PacketP[Model[Container,CartDock]]]:={
	(* Shared fields shaping *)
	NotNullFieldTest[packet,{
		PlugRequirements,
		AssociatedAccessories
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerExtractionCartridgeQTests*)
DefineOptions[
	validModelContainerExtractionCartridgeQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerExtractionCartridgeQTests[packet:PacketP[Model[Container,ExtractionCartridge]], ops:OptionsPattern[]]:= Module[
	{safeOps, fieldSource, cache, fastAssoc, object, identifier, commonFields, parameterizedFields},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};
	object = Lookup[packet, Object];
	identifier = If[DatabaseMemberQ[object],
		object,
		Lookup[packet, Type]
	];
	fastAssoc = updateFastAssoc[{{ProductsContained, ProductModel, Packet[SingleUse]}}, packet, cache];

	(* Define fields that must be informed regardless of PendingParameterization field *)
	commonFields = {
		ImageFile,
		Fragile,
		MinTemperature,
		MaxTemperature,
		Reusable,
		MaxVolume,
		PackingMaterial,
		SeparationMode,
		FunctionalGroup,
		ParticleSize,
		PoreSize,
		BedWeight,
		Footprint,
		DefaultStorageCondition,
		CoverTypes,
		DefaultStickerModel
	};

	(* Define fields that is OK to be left empty if PendingParameterization -> True *)
	parameterizedFields = {CartridgeLength};

	{

		(* Required fields *)
		NotNullFieldTest[packet,
			If[MatchQ[Lookup[packet, PendingParameterization], True],
				commonFields,
				Join[commonFields, parameterizedFields]
			],
			Message -> Automatic,
			FieldSource -> fieldSource,
			ParentFunction -> "UploadContainerModel"
		],

		RequiredTogetherTest[packet,
			{
				InletFilterThickness,
				InletFilterMaterial
			},
			Message -> Automatic,
			FieldSource -> fieldSource
		],

		RequiredTogetherTest[packet,
			{
				OutletFilterThickness,
				OutletFilterMaterial
			},
			Message -> Automatic,
			FieldSource -> fieldSource
		],

		MapThread[
			Function[{field1, field2},
				FieldComparisonTest[packet,
					{field1, field2},
					LessEqual,
					Message -> Automatic,
					FieldSource -> fieldSource
				]
			],
			{
				{MinPressure, MinpH, MinFlowRate, NominalFlowRate, MinFlowRate},
				{MaxPressure, MaxpH, NominalFlowRate, MaxFlowRate, MaxFlowRate}
			}
		],

		(* Fields that must be informed if ChromatographyType is Flash *)
		If[MatchQ[Lookup[packet,ChromatographyType],Flash],
			Map[
				Function[{field},
					NotNullFieldTest[packet,
						field,
						Message -> Switch[Lookup[fieldSource, field],
							(User | Resolved), {Hold[Error::ConditionalRequiredOptions], field, Lookup[packet, Type], "ChromatographyType option is set to Flash"},
							Template, {Hold[Error::ConditionalRequiredOptionsUnableToFindInfo], field, Lookup[packet, Type], "ChromatographyType option is set to Flash", "Template option"},
							Field, {Hold[Error::ConditionalRequiredOptionsUnableToFindInfo], field, Lookup[packet, Type], "ChromatographyType option is set to Flash", "database"},
							_, {Hold[Error::ConditionalRequiredOptions], field, Lookup[packet, Type], "ChromatographyType option is set to Flash"}
						]
					]
				],
				{PackingType,MaxBedWeight,MinFlowRate,MaxFlowRate,MinPressure,MaxPressure,Diameter,CartridgeLength}
			],
			Nothing
		],

		If[MatchQ[Lookup[packet, {ChromatographyType, PackingType}], {Flash, Prepacked}],
			Map[
				Function[{field},
					NotNullFieldTest[packet,
						field,
						Message -> Switch[Lookup[fieldSource, field],
							(User | Resolved), {Hold[Error::ConditionalRequiredOptions], field, Lookup[packet, Type], "ChromatographyType option is set to Flash and PackingType is Prepacked"},
							Template, {Hold[Error::ConditionalRequiredOptionsUnableToFindInfo], field, Lookup[packet, Type], "ChromatographyType option is set to Flash and PackingType is Prepacked", "Template option"},
							Field, {Hold[Error::ConditionalRequiredOptionsUnableToFindInfo], field, Lookup[packet, Type], "ChromatographyType option is set to Flash and PackingType is Prepacked", "database"},
							_, {Hold[Error::ConditionalRequiredOptions], field, Lookup[packet, Type], "ChromatographyType option is set to Flash and PackingType is Prepacked"}
						]
					]
				],
				{PackingMaterial, BedWeight, SeparationMode}
			],
			Nothing
		],

		Test["If ChromatographyType is Flash and PackingType is Prepacked, FunctionalGroup must be either Null or C18:",
			Switch[Lookup[packet,{ChromatographyType,PackingType,FunctionalGroup}],
				{Flash, Prepacked, (C18 | Null)}, True,
				{Flash, Prepacked, _}, False,
				{_, _, _}, True
			],
			True,
			Message -> Switch[Lookup[fieldSource, FunctionalGroup],
				User, {Hold[Error::FunctionalGroupMismatch], FunctionalGroup, Lookup[packet, Type]},
				Template, {Hold[Error::FunctionalGroupMismatchFromExistingSource], FunctionalGroup, Lookup[packet, Type], Lookup[packet, FunctionalGroup], "Template option"},
				Field, {Hold[Error::FunctionalGroupMismatchFromExistingSource], FunctionalGroup, Lookup[packet, Type], Lookup[packet, FunctionalGroup], "database"},
				_, {Hold[Error::FunctionalGroupMismatch], FunctionalGroup, Lookup[packet, Type]}
			]
		],

		(* If ChromatographyType is Flash, BedWeight must be less than or equal to MaxBedWeight *)
		If[MatchQ[Lookup[packet,ChromatographyType],Flash],
			FieldComparisonTest[packet,
				{BedWeight,MaxBedWeight},
				LessEqual,
				Message -> Automatic,
				FieldSource -> fieldSource
			],
			Nothing
		]
	}
];


(* ::Subsection::Closed:: *)
(*validModelContainerCentrifugeRotorQTests*)


validModelContainerCentrifugeRotorQTests[packet:PacketP[Model[Container,CentrifugeRotor]]]:={

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	NotNullFieldTest[packet, {RotorType,MaxForce,MaxRadius,MaxImbalance},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],


	Test["If RotorType is SwingBucket, NumberOfBuckets has to be informed. If RotorType is Fixed, NumberOfBuckets has to be Null:",
		Lookup[packet,{RotorType,NumberOfBuckets}],
		{SwingingBucket,Except[Null]}|{FixedAngle,Null}
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerCentrifugeBucketQTests*)


validModelContainerCentrifugeBucketQTests[packet:PacketP[Model[Container,CentrifugeBucket]]]:={

	NotNullFieldTest[packet, {Rotor,MaxForce,MaxRadius,MaxRotationRate,ImageFile},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],


	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		CleaningMethod,
		Ampoule,
		Hermetic
	}],

	(* MaxForce is equal to MaxRotationRate at MaxRadius *)
	Test[
		"MaxForce is equal to MaxRotationRate at MaxRadius:",
		Equal[
			Round[RCFToRPM[Lookup[packet,MaxForce],Lookup[packet,MaxRadius]]],
			Round[Lookup[packet,MaxRotationRate]]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerColonyHandlerHeadCassetteHolderQTests*)


validModelContainerColonyHandlerHeadCassetteHolderQTests[packet:PacketP[Model[Container,ColonyHandlerHeadCassetteHolder]]]:={};


(* ::Subsection::Closed:: *)
(*validModelContainerCuvetteQTests*)


validModelContainerCuvetteQTests[packet:PacketP[Model[Container,Cuvette]]]:={

	NotNullFieldTest[packet,{
			PathLength,
			Material,
			WallType,
			MinVolume,
			MaxVolume,
			MinRecommendedWavelength,
			MaxRecommendedWavelength,
			InternalDepth,
			Scale,
			PreferredCamera,
			ImageFile
		},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],
	Test["Either both indexes in InternalDimensions are informed, InternalDiameter is informed, or both InternalDimensions and InternalDiameter are informed:",
		Lookup[packet,{InternalDimensions, InternalDiameter}],
		{NullP,Except[NullP]}|{{Except[NullP],Except[NullP]},_}],

	Test["The width and depth of InternalDimensions are equal to the InternalDiameter if both are informed:",
		If[MatchQ[{Lookup[packet,InternalDimensions],Lookup[packet,InternalDiameter]},{Except[Null],Except[Null]}],
			Module[{internalDimensions,internalDiameter},
				internalDimensions=Lookup[packet,InternalDimensions];
				internalDiameter = Lookup[packet,InternalDiameter];
				And[
					MatchQ[internalDimensions[[1]],internalDiameter],
					MatchQ[internalDimensions[[2]],internalDiameter]
				]
			],
			True],
		True
	],

	Test["PathLength is equal to depth (InternalDimensions[[2]]) or InternalDiameter:",
		Module[{internalDimensions,pathLength,internalDiameter,internalDimensionDepth},
			internalDimensions=Lookup[packet,InternalDimensions];
			internalDimensionDepth = If[MatchQ[internalDimensions,Null],Null,internalDimensions[[2]]];
			pathLength=Lookup[packet,PathLength];
			internalDiameter = Lookup[packet,InternalDiameter];
			Or[
				MatchQ[pathLength,internalDimensionDepth],
				MatchQ[pathLength,internalDiameter]
			]
		],
		True
	],

	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],
	FieldComparisonTest[packet,{MinRecommendedWavelength,MaxRecommendedWavelength},Less]
};


(* ::Subsection:: *)
(*validModelContainerDeckQTests*)


validModelContainerDeckQTests[packet:PacketP[Model[Container,Deck]]]:={
(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	Test["If LiquidHandlerPositionIDs is populated, each member of Positions is represented:",
		Module[{positionIDs,positions},
			{positionIDs,positions}=Lookup[packet,{LiquidHandlerPositionIDs,Positions}];
			If[MatchQ[positionIDs,{}],
				True,
				MatchQ[Complement[(Name/.#&)/@positions,positionIDs[[All,1]]],{}]
			]
		],
		True
	],
	Test["If LiquidHandlerPositionTracks is populated, each member of Positions is represented:",
		Module[{positionIDs,positions},
			{positionIDs,positions}=Lookup[packet,{LiquidHandlerPositionTracks,Positions}];
			If[MatchQ[positionIDs,{}],
				True,
				MatchQ[Complement[(Name/.#&)/@positions,positionIDs[[All,1]]],{}]
			]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerDosingHeadQTests*)


validModelContainerDosingHeadQTests[packet:PacketP[Model[Container,DosingHead]]]:={
	(* null shared fields *)
	NullFieldTest[packet, {
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	(* not null unique fields *)
	NotNullFieldTest[packet,{
		MinDosingQuantity,
		PreferredMaxDosingQuantity,
		ImageFile,
		MaxVolume
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	Test["There is a single position defined for the modelContainer:",
		Length[DeleteCases[Lookup[packet,Positions],NullP]],
		1
	],

	Test["The single position defined is named A1:",
		Name /.FirstOrDefault[Lookup[packet,Positions]/. NullP->{Name->None}],
		"A1"
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerElectricalPanelQTests*)


validModelContainerElectricalPanelQTests[packet:PacketP[Model[Container,ElectricalPanel]]]:={
	(* Shared fields *)

	(* Unique fields *)
	NotNullFieldTest[packet,{
		MaxSinglePoleVoltage,
		MaxMultiPoleVoltage,
		MaxCurrent,
		TotalNumberOfSpaces
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerEnclosureQTests*)


validModelContainerEnclosureQTests[packet:PacketP[Model[Container,Enclosure]]]:={
	(* Shared fields *)

	(* Unique fields *)
	NotNullFieldTest[packet,{Vented,Opaque}],
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerEnvelopeQTests*)


validModelContainerEnvelopeQTests[packet:PacketP[Model[Container,Envelope]]]:={
	(* Shared fields *)

	(* Unique fields *)
	NotNullFieldTest[packet,
		{
			InternalDimensions,
			ContainerMaterials
		},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],
	NullFieldTest[packet,
		{
			CleaningMethod,
			MinVolume,
			MaxVolume,
			PreferredBalance,
			Ampoule,
			Hermetic
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerFlammableCabinetQTests*)


validModelContainerFlammableCabinetQTests[packet:PacketP[Model[Container,FlammableCabinet]]]:={

	(* Safety fields filled in *)
	NotNullFieldTest[packet,{
		VolumeCapacity,
		FireRating,
		FlowRate,
		AutomaticDoorClose,
		Certifications
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],
	NullFieldTest[packet, {
		MinVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerFiberSampleHolderQTests*)


validModelContainerFiberSampleHolderQTests[packet:PacketP[Model[Container,FiberSampleHolder]]]:={
	NotNullFieldTest[packet,{
		SupportedInstruments
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerFloorQTests*)


validModelContainerFloorQTests[packet:PacketP[Model[Container,Floor]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerFloatingRackQTests*)


validModelContainerFloatingRackQTests[packet:PacketP[Model[Container,FloatingRack]]]:={
	(* Shared Fields which should be null *)
	NotNullFieldTest[packet, {
		MinTemperature,
		MaxTemperature,
		NumberOfSlots,
		RackThickness,
		SlotDiameter
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerGasCylinderQTests*)


validModelContainerGasCylinderQTests[packet:PacketP[Model[Container,GasCylinder]]]:={
	(* Fields which should be null *)

	(* Unique fields *)
	NotNullFieldTest[packet, {MaxCapacity,MaxPressure,LiquidLevelGauge},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerGraduatedCylinderQTests*)


validModelContainerGraduatedCylinderQTests[packet:PacketP[Model[Container,GraduatedCylinder]]]:={

	(* Shared Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		ImageFile,
		MinVolume,
		MaxVolume,
		Resolution,
		PreferredCamera,
		Graduations,
		GraduationTypes
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		Ampoule,
		Hermetic
	}],

	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],

	Test["Graduations are listed from the smallest marking:",
		{Lookup[packet,Graduations],MatchQ[Lookup[packet,Graduations],Sort[Lookup[packet,Graduations]]]},
		{{___},True}
	],
	Test["The first index of Graduations equals the MinVolume:",
		{{Lookup[packet,Graduations][[1]], Lookup[packet, MinVolume]}, EqualQ[Lookup[packet,Graduations][[1]],Lookup[packet, MinVolume]]},
		{{___},True}
	],
	Test["The last index of Graduations equals the MaxVolume:",
		{{Lookup[packet,Graduations][[-1]], Lookup[packet, MaxVolume]}, EqualQ[Lookup[packet,Graduations][[-1]],Lookup[packet, MaxVolume]]},
		{{___},True}
	],
	Test[
		"GraduatedCylinder should has RentByDefault set as True:",
		MatchQ[Lookup[packet,RentByDefault],True],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelContainerGrinderTubeHolderQTests*)


validModelContainerGrinderTubeHolderQTests[packet:PacketP[Model[Container, GrinderTubeHolder]]]:= {

	(* Fields which should NOT be null *)
	NotNullFieldTest[packet, {
		(* Shared *)
		ImageFile,
		(* Specific *)
		SupportedInstruments
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};


	validModelContainerGrindingContainerQTests[packet:PacketP[Model[Container, GrindingContainer]]]:= {

		(* Fields which should NOT be null *)
		NotNullFieldTest[packet, {
			(* Shared *)
			ImageFile,
			MaxVolume,
			(* Specific *)
			SupportedInstruments
		},
			Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
		],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		Ampoule,
		Hermetic
	}],

	Test["If MinVolume is informed, it should be less than or equal to MaxVolume:",
		If[
			!NullQ[Lookup[packet, MinVolume]],
			LessEqualQ[Lookup[packet, MinVolume], Lookup[packet, MaxVolume]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerHemocytometerQTests*)


validModelContainerHemocytometerQTests[packet:PacketP[Model[Container,Hemocytometer]]]:={

	(* Shared Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Reusable,
		MinVolume,
		MaxVolume
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Unique fields *)
	NotNullFieldTest[packet,{
		RecommendedFillVolume,
		ChamberDimensions,
		ChamberDepth,
		NumberOfChambers,
		GridDimensions,
		GridVolume,
		GridColumns,
		NumberOfGrids,
		GridPositions,
		GridPositionPlotting
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{
		CleaningMethod,
		PreferredBalance,
		Ampoule,
		Hermetic,
		PreferredWashBin,
		PreferredMixer,
		DisposableCaps
	}],

	(* Minimums and maximums *)
	FieldComparisonTest[packet,{MinVolume,RecommendedFillVolume,MaxVolume},LessEqual],

	(* fields required together *)
	RequiredTogetherTest[packet,{PreferredMicroscope,PreferredObjectiveMagnification}],

	(* additional tests to perform if PlateFootprintAdapters is populated *)
	If[MatchQ[Lookup[packet,PlateFootprintAdapters],{}],
		Nothing,
		Module[{adapterPackets,adapterFootprint,adapterPositions,slideFootprintExistQs,footprintTest,positionTest},

			(* download the adapter footprints and positions *)
			adapterPackets=Download[Lookup[packet,PlateFootprintAdapters],Packet[Footprint,Positions]];

			(* get the adapter footprints and positions *)
			adapterFootprint=Lookup[adapterPackets,Footprint];
			adapterPositions=Lookup[adapterPackets,Positions];

			(* check if there's any position with MicroscopeSlide footprint in each adapter *)
			slideFootprintExistQs=MemberQ[Lookup[#,Footprint],MicroscopeSlide]&/@adapterPositions;

			(* if PlateFootprintAdapters is populated, all models must have plate footprint *)
			footprintTest=Test["Each member of PlateFootprintAdapters must have a Plate footprint:",
				Cases[adapterFootprint,Except[Plate]],
				{}
			];

			(* if PlateFootprintAdapters is populated, all models must have positions that accept MicroscopeSlide *)
			positionTest=Test["Each member of PlateFootprintAdapters must have positions that accept MicroscopeSlide:",
				And@@slideFootprintExistQs,
				True
			];

			(* return our tests *)
			{footprintTest,positionTest}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerJunctionBoxQTests*)


validModelContainerJunctionBoxQTests[packet:PacketP[Model[Container,JunctionBox]]]:={

};


(* ::Subsection::Closed:: *)
(*validModelContainerMagazineRackQTests*)


validModelContainerMagazineRackQTests[packet:PacketP[Model[Container,MagazineRack]]]:= {

	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]

};


(* ::Subsection::Closed:: *)
(*validModelContainerPhaseSeparatorQTests*)


validModelContainerPhaseSeparatorQTests[packet:PacketP[Model[Container,PhaseSeparator]]]:= {

	NotNullFieldTest[packet, {
		CartridgeWorkingVolume,
		Tabbed,
		MaxRetentionTime,
		ContainerMaterials
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]

};


(* ::Subsection::Closed:: *)
(*validModelContainerPlateSealMagazineQTests*)


validModelContainerPlateSealMagazineQTests[packet:PacketP[Model[Container,PlateSealMagazine]]]:= {

	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]

};


(* ::Subsection::Closed:: *)
(*validModelContainerMicrofluidicChipQTests*)


validModelContainerMicrofluidicChipQTests[packet:PacketP[Model[Container,MicrofluidicChip]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		PreferredBalance,
		Ampoule,
		Hermetic,
		PreferredWashBin,
		PreferredMixer,
		DisposableCaps
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerNMRSpinnerQTests*)


validModelContainerNMRSpinnerQTests[packet:PacketP[Model[Container,NMRSpinner]]]:={

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		PreferredBalance,
		Ampoule,
		Hermetic,
		PreferredWashBin,
		PreferredMixer,
		DisposableCaps
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerMicroscopeSlideQTests*)


validModelContainerMicroscopeSlideQTests[packet:PacketP[Model[Container,MicroscopeSlide]]]:={

	(* Shared Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Reusable
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{
		CleaningMethod,
		PreferredBalance,
		Ampoule,
		Hermetic,
		PreferredWashBin,
		PreferredMixer,
		DisposableCaps
	}],

	(* additional tests to perform if PlateFootprintAdapters is populated *)
	If[MatchQ[Lookup[packet,PlateFootprintAdapters],{}],
		Nothing,
		Module[{adapterPackets,adapterFootprint,adapterPositions,slideFootprintExistQs,footprintTest,positionTest},

			(* download the adapter footprints and positions *)
			adapterPackets=Download[Lookup[packet,PlateFootprintAdapters],Packet[Footprint,Positions]];

			(* get the adapter footprints and positions *)
			adapterFootprint=Lookup[adapterPackets,Footprint];
			adapterPositions=Lookup[adapterPackets,Positions];

			(* check if there's any position with MicroscopeSlide footprint in each adapter *)
			slideFootprintExistQs=MemberQ[Lookup[#,Footprint],MicroscopeSlide]&/@adapterPositions;

			(* if PlateFootprintAdapters is populated, all models must have plate footprint *)
			footprintTest=Test["Each member of PlateFootprintAdapters must have a Plate footprint:",
				Cases[adapterFootprint,Except[Plate]],
				{}
			];

			(* if PlateFootprintAdapters is populated, all models must have positions that accept MicroscopeSlide *)
			positionTest=Test["Each member of PlateFootprintAdapters must have positions that accept MicroscopeSlide:",
				And@@slideFootprintExistQs,
				True
			];

			(* return our tests *)
			{footprintTest,positionTest}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerOperatorCartQTests*)


validModelContainerOperatorCartQTests[packet:PacketP[Model[Container,OperatorCart]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerPlateQTests*)
DefineOptions[
	validModelContainerPlateQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateQTests[packet:PacketP[Model[Container,Plate]], ops:OptionsPattern[]] := Module[
	{liquidHandlerAdapterPacket, safeOps, fieldSource, cache, object, identifier, pendingParameterizationQ, commonFields, parameterizedFields},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};
	object = Lookup[packet, Object];
	identifier = If[DatabaseMemberQ[object],
		object,
		Lookup[packet, Type]
	];

	(* Required fields if CalibrationPlate is True *)
	Test["If CalibrationPlate is True, then InstrumentsCalibrated must be informed:",
		If[TrueQ[Lookup[packet,CalibrationPlate]],
			NotNullField[InstrumentsCalibrated],
			False
		],
		True
	],

	liquidHandlerAdapterPacket = fetchPacketFromCacheOrDownload[{LiquidHandlerAdapter, Packet[Positions]}, packet, cache];
	pendingParameterizationQ = TrueQ[Lookup[packet, PendingParameterization]];

	commonFields = {
		ImageFile,
		PlateColor,
		WellColor,
		Treatment,
		Rows,
		Columns,
		NumberOfWells,
		AspectRatio,
		MaxVolume,
		MinVolume,
		Skirted,
		Fragile,
		StorageOrientation,
		Reusable,
		MinTemperature,
		MaxTemperature,
		Sterile,
		RNaseFree,
		PyrogenFree,
		Footprint,
		DefaultStorageCondition,
		DefaultStickerModel
	};

	parameterizedFields = {
		HorizontalMargin,
		VerticalMargin,
		DepthMargin,
		WellDepth,
		WellBottom,
		HorizontalOffset,
		VerticalOffset,
		TransportStable
	};

	If[MatchQ[Lookup[packet,Type],Except[Model[Container,Plate,Irregular] | Model[Container,Plate,Irregular,CapillaryELISA] | Model[Container,Plate,Irregular,Crystallization]]],

		(* For all plates that are not Irregular Plates *)
		(* Shared fields *)
		{
			NotNullFieldTest[packet,
				If[MatchQ[Lookup[packet, PendingParameterization], True],
					commonFields,
					Join[commonFields, parameterizedFields]
				],
				Message -> Automatic,
				FieldSource -> fieldSource,
				ParentFunction -> "UploadContainerModel"
			],

			(* Shared fields shaping *)

			(* Well dimensions: *)
			If[pendingParameterizationQ,
				(* If still need parameterization, it's OK that Columns > 1 while HorizontalPitch == Null, but not the opposite *)
				Test["If HorizontalPitch is informed, Columns must be greater than 1:",
					Lookup[packet,{Columns, HorizontalPitch}],
					{GreaterP[1], Except[NullP]} | {_, NullP},
					Message -> Switch[Lookup[fieldSource, {HorizontalPitch, Columns}],
						{User, (User | Resolved)}, {Hold[Error::InconsistentPitch], HorizontalPitch, Columns},
						{User, Template}, {Hold[Error::InconsistentPitchWithExistingField], HorizontalPitch, Columns, "Template option"},
						{User, Field}, {Hold[Error::InconsistentPitchWithExistingField], HorizontalPitch, Columns, "database"},
						{Template, (User | Resolved)}, {Hold[Error::InconsistentPitchToExistingField], HorizontalPitch, Columns, "Template option"},
						{Field, (User | Resolved)}, {Hold[Error::InconsistentPitchToExistingField], HorizontalPitch, Columns, "database"},
						{Template, Template}, {Hold[Error::InconsistentPitchBetweenExistingField], HorizontalPitch, Columns, "Template option"},
						{Field, Field}, {Hold[Error::InconsistentPitchBetweenExistingField], HorizontalPitch, Columns, "database"},
						{_, _}, {Hold[Error::InconsistentPitch], HorizontalPitch, Columns}
					]
				],
				Test["If and only if Columns is greater than 1, HorizontalPitch is informed:",
					Lookup[packet,{Columns, HorizontalPitch}],
					{GreaterP[1], Except[NullP]} | {Except[GreaterP[1]], NullP},
					Message -> Switch[Lookup[fieldSource, {HorizontalPitch, Columns}],
						{User, (User | Resolved)}, {Hold[Error::InconsistentPitch], HorizontalPitch, Columns},
						{User, Template}, {Hold[Error::InconsistentPitchWithExistingField], HorizontalPitch, Columns, "Template option"},
						{User, Field}, {Hold[Error::InconsistentPitchWithExistingField], HorizontalPitch, Columns, "database"},
						{Template, (User | Resolved)}, {Hold[Error::InconsistentPitchToExistingField], HorizontalPitch, Columns, "Template option"},
						{Field, (User | Resolved)}, {Hold[Error::InconsistentPitchToExistingField], HorizontalPitch, Columns, "database"},
						{Template, Template}, {Hold[Error::InconsistentPitchBetweenExistingField], HorizontalPitch, Columns, "Template option"},
						{Field, Field}, {Hold[Error::InconsistentPitchBetweenExistingField], HorizontalPitch, Columns, "database"},
						{_, _}, {Hold[Error::InconsistentPitch], HorizontalPitch, Columns}
					]
				]
			],

			If[pendingParameterizationQ,
				(* If still need parameterization, it's OK that Rows > 1 while VerticalPitch == Null, but not the opposite *)
				Test["If VerticalPitch is informed, Rows must be greater than 1:",
					Lookup[packet,{Rows, VerticalPitch}],
					{GreaterP[1], Except[NullP]} | {_, NullP},
					Message -> Switch[Lookup[fieldSource, {VerticalPitch, Rows}],
						{User, (User | Resolved)}, {Hold[Error::InconsistentPitch], VerticalPitch, Rows},
						{User, Template}, {Hold[Error::InconsistentPitchWithExistingField], VerticalPitch, Rows, "Template option"},
						{User, Field}, {Hold[Error::InconsistentPitchWithExistingField], VerticalPitch, Rows, "database"},
						{Template, (User | Resolved)}, {Hold[Error::InconsistentPitchToExistingField], VerticalPitch, Rows, "Template option"},
						{Field, (User | Resolved)}, {Hold[Error::InconsistentPitchToExistingField], VerticalPitch, Rows, "database"},
						{Template, Template}, {Hold[Error::InconsistentPitchBetweenExistingField], VerticalPitch, Rows, "Template option"},
						{Field, Field}, {Hold[Error::InconsistentPitchBetweenExistingField], VerticalPitch, Rows, "database"},
						{_, _}, {Hold[Error::InconsistentPitch], VerticalPitch, Rows}
					]
				],
				Test["If and only if Rows is greater than 1, VerticalPitch is informed:",
					Lookup[packet,{Rows, VerticalPitch}],
					{GreaterP[1], Except[NullP]} | {Except[GreaterP[1]], NullP},
					Message -> Switch[Lookup[fieldSource, {VerticalPitch, Rows}],
						{User, (User | Resolved)}, {Hold[Error::InconsistentPitch], VerticalPitch, Rows},
						{User, Template}, {Hold[Error::InconsistentPitchWithExistingField], VerticalPitch, Rows, "Template option"},
						{User, Field}, {Hold[Error::InconsistentPitchWithExistingField], VerticalPitch, Rows, "database"},
						{Template, (User | Resolved)}, {Hold[Error::InconsistentPitchToExistingField], VerticalPitch, Rows, "Template option"},
						{Field, (User | Resolved)}, {Hold[Error::InconsistentPitchToExistingField], VerticalPitch, Rows, "database"},
						{Template, Template}, {Hold[Error::InconsistentPitchBetweenExistingField], VerticalPitch, Rows, "Template option"},
						{Field, Field}, {Hold[Error::InconsistentPitchBetweenExistingField], VerticalPitch, Rows, "database"},
						{_, _}, {Hold[Error::InconsistentPitch], VerticalPitch, Rows}
					]
				]
			],

			If[pendingParameterizationQ,
				Nothing,
				Test["Either the two indexes in WellDimensions are informed, or WellDiameter is informed:",
					Lookup[packet,{WellDimensions,WellDiameter}],
					{NullP,Except[NullP]} |
						{{Except[NullP],Except[NullP]},NullP}
				]
			],

			If[pendingParameterizationQ,
				(* If container is still pending parameterization, allow ConicalWellDepth to be Null in all cases *)
				Test["If ConicalWellDepth is informed, WellBottom must be VBottom or RoundBottom:",
					Lookup[packet,{WellBottom,ConicalWellDepth}],
					{RoundBottom | VBottom, Except[NullP]} | {_,NullP},
					Message -> Switch[Lookup[fieldSource, {ConicalWellDepth, WellBottom}],
						{User, User}, {Hold[Error::InternalConicalDepthNotAllowed], ConicalWellDepth, WellBottom},
						{User, Template}, {Hold[Error::InternalConicalDepthNotAllowedWithExistingField], ConicalWellDepth, WellBottom, "Template option", Lookup[packet, WellBottom]},
						{User, Field}, {Hold[Error::InternalConicalDepthNotAllowedWithExistingField], ConicalWellDepth, WellBottom, "database", Lookup[packet, WellBottom]},
						{Template, User}, {Hold[Error::InternalConicalDepthNotAllowedDueToExistingField], ConicalWellDepth, WellBottom, "Template option", Lookup[packet, WellBottom]},
						{Field, User}, {Hold[Error::InternalConicalDepthNotAllowedDueToExistingField], ConicalWellDepth, WellBottom, "database", Lookup[packet, WellBottom]},
						{Template, Template}, {Hold[Error::InternalConicalDepthNotAllowedBetweenExistingField], ConicalWellDepth, WellBottom, "Template option"},
						{Field, Field}, {Hold[Error::InternalConicalDepthNotAllowedBetweenExistingField], ConicalWellDepth, WellBottom, "database"},
						{_, _}, {Hold[Error::InternalConicalDepthNotAllowed], ConicalWellDepth, WellBottom}
					]
				],
				Test["If and only if WellBottom is RoundBottom or VBottom, ConicalWellDepth is informed:",
					Lookup[packet,{WellBottom,ConicalWellDepth}],
					{RoundBottom | VBottom,Except[NullP]} | {Except[RoundBottom | VBottom],NullP}
				]
			],

			(* Only do the test if all 3 fields are informed; if any one of them is missing, it should be caught by the previous NotNullFieldTest *)
			(* Options resolver calculates the third one from the other two if only two of them is informed, so we shouldn't see error from resolver *)
			If[!MemberQ[Lookup[packet, {Rows, Columns, NumberOfWells}, Null], Null],
				Test["Columns * Rows equals NumberOfWells:",
					Times@@Lookup[packet, {Rows, Columns}],
					Lookup[packet, NumberOfWells],
					Message -> Switch[Lookup[fieldSource, {NumberOfWells, Rows, Columns}],
						{User, User, User}, {Hold[Error::ColumnRowInconsistency], NumberOfWells, Rows, Columns, "product of"},
						_?(MemberQ[Template]), {Hold[Error::ColumnRowInconsistencyWithExistingField], NumberOfWells, Rows, Columns, "product of", PickList[{NumberOfWells, Rows, Columns}, Lookup[fieldSource, {NumberOfWells, Rows, Columns}], Template], "Template option"},
						_?(MemberQ[Field]), {Hold[Error::ColumnRowInconsistencyWithExistingField], NumberOfWells, Rows, Columns, "product of", PickList[{NumberOfWells, Rows, Columns}, Lookup[fieldSource, {NumberOfWells, Rows, Columns}], Field], "database"},
						{_, _, _}, {Hold[Error::ColumnRowInconsistency], NumberOfWells, Rows, Columns, "product of"}
					]
				],
				Nothing
			],

			If[!MemberQ[Lookup[packet, {Columns, Rows, AspectRatio}, Null], Null],
				Test["Columns/Rows  equals AspectRatio:",
					Lookup[packet,AspectRatio],
					_?(Equal[#,Divide@@Lookup[packet,{Columns,Rows} ]]&),
					Message -> Switch[Lookup[fieldSource, {AspectRatio, Columns, Rows}],
						{User, User, User}, {Hold[Error::ColumnRowInconsistency], AspectRatio, Columns, Rows, "ratio between"},
						_?(MemberQ[Template]), {Hold[Error::ColumnRowInconsistencyWithExistingField], AspectRatio, Columns, Rows, "ratio between", PickList[{AspectRatio, Columns, Rows}, Lookup[fieldSource, {AspectRatio, Columns, Rows}], Template], "Template option"},
						_?(MemberQ[Field]), {Hold[Error::ColumnRowInconsistencyWithExistingField], AspectRatio, Columns, Rows, "ratio between", PickList[{AspectRatio, Columns, Rows}, Lookup[fieldSource, {AspectRatio, Columns, Rows}], Field], "database"},
						{_, _, _}, {Hold[Error::ColumnRowInconsistency], AspectRatio, Columns, Rows, "ratio between"}
					]
				],
				Nothing
			],

			(* Check that the length of Positions and PositionPlotting field is equals NumberOfWells. Allow both fields to be {} if PendingParameterization -> True *)
			If[pendingParameterizationQ,
				Test["Length of Positions field, if informed, must be equal to the NumberOfWells:",
					Or[
						(* let check pass if NumberOfWells is not informed. The overall VOQ will fail elsewhere anyway *)
						NullQ[Lookup[packet, NumberOfWells, Null]],
						(* let check pass if Positions is {} *)
						Length[Lookup[packet, Positions]] == 0,
						(* actual check *)
						Length[Lookup[packet, Positions]] == Lookup[packet, NumberOfWells]
					],
					True,
					Message -> Switch[Lookup[fieldSource, {Positions, NumberOfWells}],
						{User, User}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "that you have specified", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{User, Template}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "according to the Template option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{User, Field}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "according to the database", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{User, Resolved}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Template, User}, {Hold[Error::IncorrectNumberOfWells], Positions, NumberOfWells, "according to the Template option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Field, User}, {Hold[Error::IncorrectNumberOfWells], Positions, NumberOfWells, "according to the database", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Resolved, User}, {Hold[Error::IncorrectNumberOfWells], Positions, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Template, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], Positions, NumberOfWells, "according to the Template option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Field, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], Positions, NumberOfWells, "according to the database", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Resolved, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], Positions, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Template, Template}, {Hold[Error::InconsistentPositionAndNumberOfWells], Positions, NumberOfWells, "inherited from the Template option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Field, Field}, {Hold[Error::InconsistentPositionAndNumberOfWells], Positions, NumberOfWells, "set according to database", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{_, _}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "that you have specified", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]}
					]
				],
				Test["Length of Positions field must be equal to the NumberOfWells:",
					Or[
						(* let check pass if NumberOfWells is not informed. The overall VOQ will fail elsewhere anyway *)
						NullQ[Lookup[packet, NumberOfWells, Null]],
						(* actual check *)
						Length[Lookup[packet, Positions]] == Lookup[packet, NumberOfWells]
					],
					True,
					Message -> Switch[Lookup[fieldSource, {Positions, NumberOfWells}],
						{User, User}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "that you have specified", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{User, Template}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "according to the Template option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{User, Field}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "according to the database", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{User, Resolved}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Template, User}, {Hold[Error::IncorrectNumberOfWells], Positions, NumberOfWells, "according to the Template option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Field, User}, {Hold[Error::IncorrectNumberOfWells], Positions, NumberOfWells, "according to the database", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Resolved, User}, {Hold[Error::IncorrectNumberOfWells], Positions, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Template, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], Positions, NumberOfWells, "according to the Template option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Field, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], Positions, NumberOfWells, "according to the database", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Resolved, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], Positions, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Template, Template}, {Hold[Error::InconsistentPositionAndNumberOfWells], Positions, NumberOfWells, "inherited from the Template option", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{Field, Field}, {Hold[Error::InconsistentPositionAndNumberOfWells], Positions, NumberOfWells, "set according to database", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]},
						{_, _}, {Hold[Error::IncorrectPositionLength], Positions, NumberOfWells, "that you have specified", Length[Lookup[packet, Positions]], Lookup[packet, NumberOfWells]}
					]
				]
			],

			If[pendingParameterizationQ,
				Test["Length of PositionPlotting field, if informed, must be equal to the NumberOfWells:",
					Or[
						(* let check pass if NumberOfWells is not informed. The overall VOQ will fail elsewhere anyway *)
						NullQ[Lookup[packet, NumberOfWells, Null]],
						(* let check pass if PositionPlotting is {} *)
						Length[Lookup[packet, PositionPlotting]] == 0,
						(* actual check *)
						Length[Lookup[packet, PositionPlotting]] == Lookup[packet, NumberOfWells]
					],
					True,
					Message -> Switch[Lookup[fieldSource, {PositionPlotting, NumberOfWells}],
						{User, User}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "that you have specified", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{User, Template}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "according to the Template option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{User, Field}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "according to the database", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{User, Resolved}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Template, User}, {Hold[Error::IncorrectNumberOfWells], PositionPlotting, NumberOfWells, "according to the Template option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Field, User}, {Hold[Error::IncorrectNumberOfWells], PositionPlotting, NumberOfWells, "according to the database", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Resolved, User}, {Hold[Error::IncorrectNumberOfWells], PositionPlotting, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Template, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], PositionPlotting, NumberOfWells, "according to the Template option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Field, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], PositionPlotting, NumberOfWells, "according to the database", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Resolved, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], PositionPlotting, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Template, Template}, {Hold[Error::InconsistentPositionAndNumberOfWells], PositionPlotting, NumberOfWells, "inherited from the Template option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Field, Field}, {Hold[Error::InconsistentPositionAndNumberOfWells], PositionPlotting, NumberOfWells, "set according to database", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{_, _}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "that you have specified", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]}
					]
				],
				Test["Length of PositionPlotting field must be equal to the NumberOfWells:",
					Or[
						(* let check pass if NumberOfWells is not informed. The overall VOQ will fail elsewhere anyway *)
						NullQ[Lookup[packet, NumberOfWells, Null]],
						(* actual check *)
						Length[Lookup[packet, PositionPlotting]] == Lookup[packet, NumberOfWells]
					],
					True,
					Message -> Switch[Lookup[fieldSource, {PositionPlotting, NumberOfWells}],
						{User, User}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "that you have specified", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{User, Template}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "according to the Template option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{User, Field}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "according to the database", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{User, Resolved}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Template, User}, {Hold[Error::IncorrectNumberOfWells], PositionPlotting, NumberOfWells, "according to the Template option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Field, User}, {Hold[Error::IncorrectNumberOfWells], PositionPlotting, NumberOfWells, "according to the database", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Resolved, User}, {Hold[Error::IncorrectNumberOfWells], PositionPlotting, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Template, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], PositionPlotting, NumberOfWells, "according to the Template option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Field, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], PositionPlotting, NumberOfWells, "according to the database", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Resolved, Resolved}, {Hold[Error::IncorrectResolvedNumberOfWells], PositionPlotting, NumberOfWells, "that was calculated from Rows and Columns option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Template, Template}, {Hold[Error::InconsistentPositionAndNumberOfWells], PositionPlotting, NumberOfWells, "inherited from the Template option", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{Field, Field}, {Hold[Error::InconsistentPositionAndNumberOfWells], PositionPlotting, NumberOfWells, "set according to database", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]},
						{_, _}, {Hold[Error::IncorrectPositionLength], PositionPlotting, NumberOfWells, "that you have specified", Length[Lookup[packet, PositionPlotting]], Lookup[packet, NumberOfWells]}
					]
				]
			],

			Test["If NumberOfWells is >=48, then PreferredCamera should be populated:",
				Lookup[packet,{NumberOfWells, PreferredCamera}],
				Alternatives[
					{GreaterEqualP[48],Plate},
					{_,_}
				],
				Message -> Switch[Lookup[fieldSource, PreferredCamera],
					User, {Hold[Error::RequiredOptions], PreferredCamera, identifier},
					External, {Hold[Error::UnableToFindInfo], PreferredCamera, identifier, "supplier webpage", "UploadContainerModel"},
					Template, {Hold[Error::UnableToFindInfo], PreferredCamera, identifier, "object specified in Template option", "UploadContainerModel"},
					Resolved, {Hold[Error::UnableToResolveOption], PreferredCamera, identifier},
					_, {Hold[Error::RequiredOptions], PreferredCamera, identifier}
				]
			],

			Test["If LiquidHandlerAdapter is populated, it should have a Plate Slot:",
				If[MatchQ[Lookup[packet,LiquidHandlerAdapter],ObjectP[]],
					MemberQ[Lookup[Lookup[liquidHandlerAdapterPacket,Positions],Name],"Plate Slot"],
					True
				],
				True
			],

			(*
			TODO turn this on once we have re-parametrized all plates used in the lab
			Test["The thickness of the well bottom is positive: ",
				Lookup[packet,Dimensions][[3]] - Lookup[packet,WellDepth] - Lookup[packet,DepthMargin],
				GreaterP[0Millimeter]
			],*)

			Test["If BottomCavity3D is populated, all entries lie withing the Dimensions of the Container:",
				If[MatchQ[Lookup[packet,BottomCavity3D],Except[Null | {}]],
					Module[{xDim,yDim,zDim},
						{xDim,yDim,zDim}=Lookup[packet,Dimensions];
						MatchQ[
							Lookup[packet,BottomCavity3D],
							{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}
						]],
					True
				],
				True
			],

			(* Minimums and maximums *)
			FieldComparisonTest[packet,
				{MinVolume, RecommendedFillVolume},
				LessEqual,
				Message -> Automatic,
				FieldSource -> fieldSource
			],
			FieldComparisonTest[packet,
				{RecommendedFillVolume,MaxVolume},
				LessEqual,
				Message -> Automatic,
				FieldSource -> fieldSource
			],
			FieldComparisonTest[packet,
				{MinVolume,MaxVolume},
				LessEqual,
				Message -> Automatic,
				FieldSource -> fieldSource
			]
		},

		(* For Model[Container,Plate,Irregular] *)
		{
			NotNullFieldTest[packet,{
				ImageFile,
				PlateColor,
				WellColor,
				NumberOfWells,
				HorizontalMargin,
				VerticalMargin,
				DepthMargin,
				WellDepth,
				WellBottom,
				MaxVolume,
				MinVolume
			},
				Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
			],

			(* Minimums and maximums *)
			FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],

			Test["If LiquidHandlerAdapter is populated, it should have a Plate Slot:",
				If[MatchQ[Lookup[packet,LiquidHandlerAdapter],ObjectP[]],
					MemberQ[Lookup[Lookup[liquidHandlerAdapterPacket,Positions],Name],"Plate Slot"],
					True
				],
				True
			],

			Test["If BottomCavity3D is populated, all entries lie withing the Dimensions of the Container:",
				If[MatchQ[Lookup[packet,BottomCavity3D],Except[Null | {}]],
					Module[{xDim,yDim,zDim},
						{xDim,yDim,zDim}=Lookup[packet,Dimensions];
						MatchQ[
							Lookup[packet,BottomCavity3D],
							{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}
						]],
					True
				],
				True
			],

			(* Require flange-related fields together *)
			RequiredTogetherTest[packet,{FlangeHeight,FlangeWidth}]
		}
	]
];


(* ::Subsection::Closed:: *)
(*validModelContainerPlateDropletCartridgeQTests*)
DefineOptions[
	validModelContainerPlateDropletCartridgeQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateDropletCartridgeQTests[packet:PacketP[Model[Container,Plate,DropletCartridge]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{

	NotNullFieldTest[packet,
		{
			DropletsFromSampleVolume,
			AverageDropletVolume
		},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]

	}
];


(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateIrregularArrayCardQTests*)
DefineOptions[
	validModelContainerPlateIrregularArrayCardQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateIrregularArrayCardQTests[packet:PacketP[Model[Container,Plate,Irregular,ArrayCard]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{

	NotNullFieldTest[packet,{
		ForwardPrimers,
		ReversePrimers,
		Probes
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]

	}
];


(* ::Subsection::Closed:: *)
(*validModelContainerPlateIrregularCapillaryELISAQTests*)
DefineOptions[
	validModelContainerPlateIrregularCapillaryELISAQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateIrregularCapillaryELISAQTests[packet:PacketP[Model[Container,Plate,Irregular,CapillaryELISA]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{

		(* Null Shared Fields *)
		NullFieldTest[packet,{
			CleaningMethod,
			Ampoule,
			Hermetic
		}],

	(* Not Null Shared Fields *)
	NotNullFieldTest[packet,{
		Expires,
		Reusable
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Not Null Unique Fields*)
	NotNullFieldTest[packet,{
		MaxNumberOfSamples,
		CartridgeType,
		NumberOfReplicates,
		WellContents,
		MinBufferVolume
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

		(* MinBufferVolume must match the type of the cartridge *)
		Test["MinBufferVolume must match CartridgeType:",
			Lookup[packet,{CartridgeType,MinBufferVolume}],
			{SinglePlex72X1,10.0Milliliter}|{MultiAnalyte32X4,16.0Milliliter}|{MultiAnalyte16X4,8.0Milliliter}|{MultiPlex32X8,16.0Milliliter}|{Customizable,6.0Milliliter}
		],

		(* Depending on the CartridgeType, information about Analytes should be populated or Null. *)
		If[MatchQ[Lookup[packet,CartridgeType],Customizable],

			NullFieldTest[packet,{
				AnalyteNames,
				AnalyteMolecules
			}],

		NotNullFieldTest[packet,{
			AnalyteNames,
			AnalyteMolecules
		},
			Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
		]
	],

		(* AnalyteNames and AnalyteMolecules should match each other - they can be Null when one or more channels of a multi-analyte or multiplex cartridge is empty *)
		Test["AnalyteNames should match AnalyteMolecules:",
			And@@(
				MapThread[
					Module[
						{analyteManuSpec,analyteMoleculeIDFromManuSpec,validAnalyteMoleculeQ},
						analyteManuSpec=Search[Object[ManufacturingSpecification,CapillaryELISACartridge],AnalyteName==#1];
						analyteMoleculeIDFromManuSpec=If[MatchQ[analyteManuSpec,{}],
							Null,
							FirstOrDefault[analyteManuSpec[AnalyteMolecule][ID]]
						];
						validAnalyteMoleculeQ=If[MatchQ[analyteMoleculeIDFromManuSpec,Null],
							MatchQ[#2,Null],
							MatchQ[analyteMoleculeIDFromManuSpec,#2[ID]]
						]
					]&,
					{packet[AnalyteNames],packet[AnalyteMolecules]}
				]
			),
			True
		]

	}
];



(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateIrregularCrystallizationQTests*)
DefineOptions[
	validModelContainerPlateIrregularCrystallizationQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateIrregularCrystallizationQTests[packet:PacketP[Model[Container, Plate, Irregular,Crystallization]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	{
		NullFieldTest[packet,{
			CleaningMethod,
			Ampoule,
			Hermetic
		}],
		NotNullFieldTest[packet, {
			CompatibleCrystallizationTechniques,
			LabeledColumns,
			LabeledRows,
			WellContents
		},
			Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
		],
		Test["Labeled Columns * Labeled Rows the number of individual Wells or HeadspaceSharingWells:",
			If[!NullQ[Lookup[packet, HeadspaceSharingWells]],
				Length[packet[HeadspaceSharingWells]]===packet[LabeledColumns]*packet[LabeledRows],
				Lookup[packet, NumberOfWells]===packet[LabeledColumns]*packet[LabeledRows]
			],
			True
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateIrregularRamanQTests*)
DefineOptions[
	validModelContainerPlateIrregularRamanQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateIrregularRamanQTests[packet:PacketP[Model[Container, Plate, Irregular, Raman]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(*Shared fields*)
	{
		NotNullFieldTest[packet, {
			WellWindowDimensions
		},
			Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
		],

		NullFieldTest[packet, {
			MaxCentrifugationForce,
			VacuumCentrifugeCompatibility
		}]
	}
];



(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateCapillaryStripQTests*)
DefineOptions[
	validModelContainerPlateCapillaryStripQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateCapillaryStripQTests[packet:PacketP[Model[Container, Plate, CapillaryStrip]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(*Shared fields*)
	{
		NotNullFieldTest[packet, {
			Reusable,
			RecommendedFillVolume
		},
			Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
		],
		NullFieldTest[packet, {
			MaxCentrifugationForce,
			VacuumCentrifugeCompatibility}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*validModelContainerPlateFilterQTests*)
DefineOptions[
	validModelContainerPlateFilterQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateFilterQTests[packet:PacketP[Model[Container,Plate,Filter]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache, object, fastAssoc, identifier},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};
	object = Lookup[packet, Object];
	identifier = If[DatabaseMemberQ[object],
		object,
		Lookup[packet, Type]
	];

	(* construct tests *)
	{
		(* Shared fields *)
		NotNullFieldTest[packet,
			{
				MembraneMaterial,
				PrefilterPoreSize
			},
			Message -> Automatic,
			FieldSource -> fieldSource,
			ParentFunction -> "UploadContainerModel"
		],

		UniquelyInformedTest[packet,
			{PoreSize,MolecularWeightCutoff},
			Message -> Automatic,
			FieldSource -> fieldSource
		],

		Map[
			Function[{field},
				NullFieldTest[
					packet,
					field,
					Message -> Switch[Lookup[fieldSource, field],
						User, {Hold[Error::RedundantOptions], Lookup[packet, Type], field},
						Template, {Hold[Error::RedundantOptionsFromExistingField], Lookup[packet, Type], field, "Template option"},
						Field, {Hold[Error::RedundantOptionsFromExistingField], Lookup[packet, Type], field, "database"},
						_, {Hold[Error::RedundantOptions], Lookup[packet, Type], field}
					]
				]
			],
			{
				CleaningMethod,
				Ampoule,
				Hermetic
			}
		],

		Test["If StorageBuffer -> True, then StorageBufferVolume must be populated:",
			If[TrueQ[Lookup[packet, StorageBuffer]],
				VolumeQ[Lookup[packet, StorageBufferVolume]],
				True
			],
			True
		]
	}
];



(* ::Subsection::Closed:: *)
(*validModelContainerPlateDialysisQTests*)


validModelContainerPlateDialysisQTests[packet:PacketP[Model[Container,Plate,Dialysis]]]:={

	NotNullFieldTest[packet,{
		MolecularWeightCutoff
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]

};





(* ::Subsection::Closed:: *)
(*validModelContainerPlateDialysisQTests*)
DefineOptions[
	validModelContainerPlateDialysisQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateDialysisQTests[packet:PacketP[Model[Container,Plate,Dialysis]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{

		NotNullFieldTest[packet,{
			MolecularWeightCutoff
		}]

	}
];

(* ::Subsection::Closed:: *)
(*validModelContainerPlateIrregularQTests*)
DefineOptions[
	validModelContainerPlateIrregularQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateIrregularQTests[packet:PacketP[Model[Container,Plate,Irregular]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{

	(* Shared fields *)
	NotNullFieldTest[packet,{
		WellColors,
		WellTreatments,
		WellDepths,
		WellBottoms,
		MinVolumes,
		MaxVolumes,
		RecommendedFillVolumes
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

		Test["For every single well, minimum volume is less than or equal to recommended fill volume and recommended fill volume is less than or equal to maximum volume",
			And @@ MapThread[LessEqual[#1,#2,#3]&,{packet[MinVolumes],packet[RecommendedFillVolumes],packet[MaxVolumes]}],
			True
		]
	}
];



(* ::Subsection::Closed:: *)
(*validModelContainerPortableCoolerQTests*)


validModelContainerPortableCoolerQTests[packet:PacketP[Model[Container,PortableCooler]]]:={

	NotNullFieldTest[packet, {NominalTemperature,MinIncubationTemperature,MaxIncubationTemperature},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	(* Minimums and maximums *)
	FieldComparisonTest[packet,{MinIncubationTemperature,NominalTemperature,MaxIncubationTemperature},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelContainerPortableHeaterQTests*)


validModelContainerPortableHeaterQTests[packet:PacketP[Model[Container,PortableHeater]]]:={

	NotNullFieldTest[packet, {NominalTemperature,MinIncubationTemperature,MaxIncubationTemperature},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

	(* Minimums and maximums *)
	FieldComparisonTest[packet,{MinIncubationTemperature,NominalTemperature,MaxIncubationTemperature},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelContainerRackQTests*)


validModelContainerRackQTests[packet:PacketP[Model[Container,Rack]]]:={

	RequiredTogetherTest[packet,{Rows,Columns}],
	NotNullFieldTest[packet,{
		NumberOfPositions,
		HorizontalOffset,
		VerticalOffset,
		Footprint
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],

(* Well dimensions: *)
	Test["If and only if Columns is greater than 1, HorizontalPitch and HorizontalMargin are informed:",
		Lookup[packet,{Columns,HorizontalPitch,HorizontalMargin}],
		{GreaterP[1],Except[NullP],Except[NullP]}|{Except[GreaterP[1]],_,_}
	],

	Test["If and only if Rows is greater than 1, VerticalPitch and VerticalMargin area informed:",
		Lookup[packet,{Rows,VerticalPitch,VerticalMargin}],
		{GreaterP[1],Except[NullP],Except[NullP]}|{Except[GreaterP[1]],_,_}
	],

	Test["Either the two indexes in WellDimensions are informed, or WellDiameter is informed:",
		Lookup[packet,{WellDimensions,WellDiameter}],
		{NullP,Except[NullP]}|{{Except[NullP],Except[NullP]},NullP}
	],

	Test["NumberOfPositions matches the number of positions specified in Positions:",
		Lookup[packet,NumberOfPositions],
		Length[Lookup[packet,Positions]]
	];

	Test["If both Rows and Columns are non-Null, then AspectRatio must be informed and must be equal to Columns/Rows. Otherwise, AspectRatio cannot be informed:",
		Lookup[packet,{Rows,Columns,AspectRatio}],
		Alternatives[
			{Except[NullP],Except[NullP],_?(Equal[Rationalize[#],Divide @@ Lookup[packet, {Columns, Rows} ]]&)},
			{NullP,NullP,NullP}
		]
	],

	Test["If both Rows and Columns are non-Null, then NumberOfPositions must be equal to Rows*Columns:",
		Lookup[packet,{Rows,Columns,NumberOfPositions}],
		Alternatives[
			{Except[NullP],Except[NullP],Times@@Lookup[packet, {Rows, Columns}]},
			{NullP,NullP,Except[NullP]}
		]
	],

	Test["If LiquidHandlerPositionIDs is populated, each member of Positions is represented:",
		Module[{positionIDs,positions},
			{positionIDs,positions}=Lookup[packet,{LiquidHandlerPositionIDs,Positions}];
			If[MatchQ[positionIDs,{}],
				True,
				MatchQ[Complement[(Name/.#&)/@positions,positionIDs[[All,1]]],{}]
			]
		],
		True
	],

	Test["If BottomSupport3D is populated, all members should be in Positions:",
		If[MatchQ[Lookup[packet,BottomSupport3D],Except[Null | {}]],
			MatchQ[
				Complement[
					Lookup[Lookup[packet,BottomSupport3D],Name],
					Lookup[Lookup[packet,Positions],Name]
				],
				{}
			],
			True
		],
		True
	],

	Test["If BottomSupport3D is populated, all entries lie withing the Dimensions of the Container:",
		If[MatchQ[Lookup[packet,BottomSupport3D],Except[Null | {}]],
			Module[{xDim,yDim,zDim},
				{xDim,yDim,zDim}=Lookup[packet,Dimensions];
				AllTrue[
					Lookup[Lookup[packet,BottomSupport3D],Dimensions],
					MatchQ[{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}]
				]
			],
			True
		],
		True
	],

	Test["If BottomCavity3D is populated, all entries lie withing the Dimensions of the Container:",
		If[MatchQ[Lookup[packet,BottomCavity3D],Except[Null | {}]],
			Module[{xDim,yDim,zDim},
				{xDim,yDim,zDim}=Lookup[packet,Dimensions];
				MatchQ[
					Lookup[packet,BottomCavity3D],
					{{RangeP[0Millimeter,xDim],RangeP[0Millimeter,yDim],RangeP[0Millimeter,zDim]}..}
				]],
			True
		],
		True
	],

	Test["If the rack model has PermanentStorage -> False, any Object[StorageAvailability]s associated with its objects must not have a status that renders them findable:",
		If[MatchQ[Lookup[packet, PermanentStorage], False],
			MatchQ[
				Flatten[Download[Lookup[packet, Objects], StorageAvailability[[All,2]][Status]]],
				{(Inactive|Discarded|InUse)...}
			],
			True
		],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerProteinCapillaryElectrophoresisCartridgeQTests*)


validModelContainerProteinCapillaryElectrophoresisCartridgeQTests[packet:PacketP[Model[Container, ProteinCapillaryElectrophoresisCartridge]]]:={

	(* Shared fields *)
	NotNullFieldTest[packet,{
		MaxNumberOfUses,
		ExperimentType,
		CapillaryLength,
		CapillaryDiameter,
		Footprint,
		Positions
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerProteinCapillaryElectrophoresisCartridgeInsertQTests*)


validModelContainerProteinCapillaryElectrophoresisCartridgeInsertQTests[packet:PacketP[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert]]]:={
	(* Shared fields *)
	NotNullFieldTest[packet,{
		Footprint,
		Positions
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};



(* ::Subsubsection::Closed:: *)
(*validModelContainerRackDishwasherQTests*)


validModelContainerRackDishwasherQTests[packet:PacketP[Model[Container,Rack,Dishwasher]]]:={

	NullFieldTest[packet,CleaningMethod],
	NotNullFieldTest[packet,{RackType,BaseHeight},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	Test["If RackType is Active then NumberOfPositions should be informed:",
		Lookup[packet,{RackType,NumberOfPositions}],
		Alternatives[
			{Active,Except[Null]},
			{Passive,_}
		]
	]
};




(* ::Subsubsection::Closed:: *)
(*validModelContainerRackInsulatedCoolerQTests*)


validModelContainerRackInsulatedCoolerQTests[packet:PacketP[Model[Container,Rack,InsulatedCooler]]]:={

	NotNullFieldTest[packet,{
		DefaultContainer
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};







(* ::Subsection::Closed:: *)
(*validModelContainerReactionVesselQTests*)


validModelContainerReactionVesselQTests[packet:PacketP[Model[Container,ReactionVessel]]]:={

	(* Shared Fields which should not be null *)
	NotNullFieldTest[packet, {
		MaxVolume,
		SelfStanding,
		PreferredCamera,
		ImageFile
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	FieldComparisonTest[packet,{MinPressure,MaxPressure},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelContainerReactionVesselMicrowaveQTests*)


validModelContainerReactionVesselMicrowaveQTests[packet:PacketP[Model[Container,ReactionVessel, Microwave]]]:={

	(* Shared Fields which should not be null *)
	NotNullFieldTest[packet, {
		CleaningMethod
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerReactionVesselSolidPhaseSynthesisQTests*)


validModelContainerReactionVesselSolidPhaseSynthesisQTests[packet:PacketP[Model[Container,ReactionVessel,SolidPhaseSynthesis]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {CleaningMethod}],

	(* Required fields *)
	RequiredTogetherTest[packet,{InletFilterThickness,InletFilterMaterial}],
	RequiredTogetherTest[packet,{OutletFilterThickness,OutletFilterMaterial}],

	FieldComparisonTest[packet,{MaxFlowRate,MinFlowRate},GreaterEqual],
	FieldComparisonTest[packet,{MaxFlowRate,NominalFlowRate},GreaterEqual],
	FieldComparisonTest[packet,{NominalFlowRate,MinFlowRate},GreaterEqual]
};


(* ::Subsection::Closed:: *)
(*validModelContainerReactionVesselElectrochemicalSynthesisQTests*)


validModelContainerReactionVesselElectrochemicalSynthesisQTests[packet:PacketP[Model[Container,ReactionVessel,ElectrochemicalSynthesis]]]:={

	(* Shared Fields which should not be null *)
	NotNullFieldTest[packet, {
		MaxNumberOfUses,
		CleaningMethod
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerRoomQTests*)


validModelContainerRoomQTests[packet:PacketP[Model[Container,Room]]]:={
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerSafeQTests*)


validModelContainerSafeQTests[packet:PacketP[Model[Container,Safe]]]:={
(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerShelfQTests*)


validModelContainerShelfQTests[packet:PacketP[Model[Container,Shelf]]]:={
	(* Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerShelvingUnitQTests*)


validModelContainerShelvingUnitQTests[packet:PacketP[Model[Container,ShelvingUnit]]]:={
	(* Fields which should be null *)
	NullFieldTest[packet, {
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerShippingQTests*)


validModelContainerShippingQTests[packet:PacketP[Model[Container, Shipping]]]:={
(* Shared fields shaping *)
	NullFieldTest[packet,{
		CleaningMethod,
		ImageFile,
		MinVolume,
		MaxVolume,
		Ampoule,
		Hermetic
	}]
};



(* ::Subsection::Closed:: *)
(*validModelContainerSyringeQTests*)


validModelContainerSyringeQTests[packet:PacketP[Model[Container,Syringe]]]:={
	(* unique fields which should be not null *)
	NotNullFieldTest[packet,{
		BarrelMaterial,
		PlungerMaterial,
		ConnectionType,
		MinVolume,
		MaxVolume,
		Resolution,
		DeadVolume,
		PreferredCamera,
		ImageFile
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],
	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		PreferredBalance
	}],

	Test["If the syringe is LuerLock, InnerDiameter must be populated:",
		If[MatchQ[Lookup[packet, ConnectionType], LuerLock],
			Not[NullQ[Lookup[packet, InnerDiameter]]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerSyringeToolQTests*)


validModelContainerSyringeToolQTests[packet:PacketP[Model[Container,SyringeTool]]]:={
	(* unique fields which should be not null *)
	NotNullFieldTest[packet,{
		ImageFile
	},
		Message -> Automatic,
		ParentFunction -> "UploadContainerModel"
	],
	(* Shared Fields which should be null *)
	NullFieldTest[packet, {
		CleaningMethod,
		PreferredBalance,
		MinVolume,
		MaxVolume
	}]
};


(* ::Subsection::Closed:: *)
(*validModelContainerVesselQTests*)
DefineOptions[
	validModelContainerVesselQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerVesselQTests[packet:PacketP[Model[Container,Vessel]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache, object, identifier, fastAssoc, commonFields, parameterizedFields},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};
	object = Lookup[packet, Object];
	identifier = If[DatabaseMemberQ[object],
		object,
		Lookup[packet, Type]
	];
	fastAssoc = updateFastAssoc[{{ProductsContained, ProductModel, Packet[SingleUse]}}, packet, cache];

	commonFields = {
		ImageFile,
		MaxVolume,
		InternalBottomShape,
		Sterile,
		Stocked,
		Ampoule,
		Squeezable,
		Fragile,
		Reusable,
		MinVolume,
		RNaseFree,
		PyrogenFree,
		DefaultStorageCondition,
		ContainerMaterials,
		DefaultStickerModel,
		Opaque
	};

	parameterizedFields = {
		PreferredBalance,
		SelfStanding,
		PreferredCamera
	};

	(* construct tests *)
	{

		(* Not Null fields *)
		NotNullFieldTest[packet,
			If[MatchQ[Lookup[packet, PendingParameterization], True],
				commonFields,
				Join[commonFields, parameterizedFields]
			],
			Message -> Automatic,
			FieldSource -> fieldSource,
			ParentFunction -> "UploadContainerModel"
		],

		If[TrueQ[Lookup[packet, Reusable]],
			NotNullFieldTest[
				packet,
				CleaningMethod,
				Message -> Switch[Lookup[fieldSource, {Reusable, CleaningMethod}],
					{User, User}, {Hold[Error::ReusabilityConflict], Reusable, CleaningMethod},
					{(Template | Resolved | Field), User}, {Hold[Error::ReusabilityConflictNoNull], Reusable, CleaningMethod},
					{User, Resolved}, {Hold[Error::UnableToResolveOption], CleaningMethod, Lookup[packet, Type]},
					{(User | Resolved), Template}, {Hold[Error::ReusabilityConflictWithExistingField], Reusable, CleaningMethod, "Template option"},
					{(User | Resolved), Field}, {Hold[Error::ReusabilityConflictWithExistingField], Reusable, CleaningMethod, "database"},
					{Template, Template}, {Hold[Error::ReusabilityConflictBetweenExistingField], Reusable, CleaningMethod, "Template option"},
					{Field, Field}, {Hold[Error::ReusabilityConflictBetweenExistingField], Reusable, CleaningMethod, "database"},
					{_, _}, {Hold[Error::ReusabilityConflict], Reusable, CleaningMethod}
				]
			],
			Nothing
		],

		If[TrueQ[Lookup[packet, Reusable]],
			NotNullFieldTest[
				packet,
				PreferredWashBin,
				Message -> Switch[Lookup[fieldSource, {Reusable, PreferredWashBin}],
					{User, User}, {Hold[Error::ReusabilityConflict], Reusable, PreferredWashBin},
					{(Template | Resolved | Field), User}, {Hold[Error::ReusabilityConflictNoNull], Reusable, PreferredWashBin},
					{User, Resolved}, {Hold[Error::UnableToResolveOption], PreferredWashBin, Lookup[packet, Type]},
					{(User | Resolved), Template}, {Hold[Error::ReusabilityConflictWithExistingField], Reusable, PreferredWashBin, "Template option"},
					{(User | Resolved), Field}, {Hold[Error::ReusabilityConflictWithExistingField], Reusable, PreferredWashBin, "database"},
					{Template, Template}, {Hold[Error::ReusabilityConflictBetweenExistingField], Reusable, PreferredWashBin, "Template option"},
					{Field, Field}, {Hold[Error::ReusabilityConflictBetweenExistingField], Reusable, PreferredWashBin, "database"},
					{_, _}, {Hold[Error::ReusabilityConflict], Reusable, PreferredWashBin}
				]
			],
			Nothing
		],

		(* Well dimensions: *)

		Test["For ampoule containers (i.e. Ampoule is True), BuiltInCover is False:",
			Lookup[packet,{Ampoule, BuiltInCover}],
			{True, Alternatives[False, Null]} | {False | Null, _}
		],

		Test["InternalDepth is informed unless the vessel is an Ampoule or PermanentlySealed, in which case it may be Null:",
			Lookup[packet,{Ampoule, PermanentlySealed, InternalDepth}],
			{True, _, _} | {_, True, _} | {Except[True], Except[True], Except[NullP]}
		],
		If[TrueQ[Lookup[packet, PendingParameterization]],
			Nothing,
			Test["InternalDepth is informed unless the vessel is an Ampoule or PermanentlySealed, in which case it may be Null:",
				Lookup[packet,{Ampoule, PermanentlySealed, InternalDepth}],
				{True, _, _} | {_, True, _} | {Except[True], Except[True], Except[NullP]}
			]
		],

		If[TrueQ[Lookup[packet, PendingParameterization]],
			Nothing,
			(* Message should never be thrown when user call this function, so no need to define custom error message *)
			Test["Either the two indexes in InternalDimensions are informed, or InternalDiameter is informed:",
				Lookup[packet,{InternalDimensions,InternalDiameter}],
				{NullP,Except[NullP]}|{{Except[NullP],Except[NullP]},NullP},
				Message -> {Hold[Error::MissingInternalDimensions], identifier, InternalDimensions, InternalDiameter}
			]
		],

		Test["Only one of NeckType or TaperGroundJointSize may be informed:",
			Lookup[packet,{NeckType,TaperGroundJointSize}],
			{NullP,NullP}|{Except[NullP],NullP}|{NullP,Except[NullP]}
		],

		(* These two tests are intentionally separated because the first test is OK to bypass if PendingParameterization -> True *)
		If[TrueQ[Lookup[packet, PendingParameterization]],
			Nothing,
			Test["If InternalBottomShape is RoundBottom or VBottom, InternalConicalDepth is informed:",
				Lookup[packet,{InternalBottomShape,InternalConicalDepth}],
				{RoundBottom|VBottom, Except[NullP]} | {Except[RoundBottom|VBottom], _}
			]
		],

		Test["Only if InternalBottomShape is RoundBottom or VBottom, InternalConicalDepth is informed:",
			Lookup[packet,{InternalBottomShape,InternalConicalDepth}],
			{RoundBottom|VBottom, _} | {Except[RoundBottom|VBottom], NullP},
			Message -> Switch[Lookup[fieldSource, {InternalConicalDepth, InternalBottomShape}],
				{User, User}, {Hold[Error::InternalConicalDepthNotAllowed], InternalConicalDepth, InternalBottomShape},
				{User, Template}, {Hold[Error::InternalConicalDepthNotAllowedWithExistingField], InternalConicalDepth, InternalBottomShape, "Template option", Lookup[packet, InternalBottomShape]},
				{User, Field}, {Hold[Error::InternalConicalDepthNotAllowedWithExistingField], InternalConicalDepth, InternalBottomShape, "database", Lookup[packet, InternalBottomShape]},
				{Template, User}, {Hold[Error::InternalConicalDepthNotAllowedDueToExistingField], InternalConicalDepth, InternalBottomShape, "Template option", Lookup[packet, InternalBottomShape]},
				{Field, User}, {Hold[Error::InternalConicalDepthNotAllowedDueToExistingField], InternalConicalDepth, InternalBottomShape, "database", Lookup[packet, InternalBottomShape]},
				{Template, Template}, {Hold[Error::InternalConicalDepthNotAllowedBetweenExistingField], InternalConicalDepth, InternalBottomShape, "Template option"},
				{Field, Field}, {Hold[Error::InternalConicalDepthNotAllowedBetweenExistingField], InternalConicalDepth, InternalBottomShape, "database"},
				{_, _}, {Hold[Error::InternalConicalDepthNotAllowed], InternalConicalDepth, InternalBottomShape}
			]
		],


		If[TrueQ[Lookup[packet, PendingParameterization]],
			(* The test below is divided intentionally to make it easier to communicate the error to user *)
			{
				(* Allow empty Positions if container is still pending parameterization *)
				Test["There is at most 1 entry of Positions field defined for the model container:",
					Length[Lookup[packet, Positions]],
					Alternatives[0, 1],
					Message -> Switch[Lookup[fieldSource, Positions],
						User, {Hold[Error::MultiplePositions], Positions, Lookup[packet, Type]},
						Template, {Hold[Error::MultiplePositionsFromExistingObject], Positions, Lookup[packet, Type], "Template option"},
						Field, {Hold[Error::MultiplePositionsFromExistingObject], Positions, Lookup[packet, Type], "database"},
						_, {Hold[Error::MultiplePositions], Positions, Lookup[packet, Type]}
					]
				],
				Test["If one single entry is defined for Positions, the position name must be \"A1\":",
					{Length[Lookup[packet, Positions]], Lookup[packet, Positions]},
					Alternatives[{1, {AssociationMatchP[<|Name->"A1"|>, AllowForeignKeys->True]}}, {Except[1], _}],
					Message -> Switch[Lookup[fieldSource, Positions],
						User, {Hold[Error::NotAllowedPositionName], Positions, Lookup[packet, Type]},
						Template, {Hold[Error::NotAllowedPositionNameFromExistingObject], Positions, Lookup[packet, Type], "Template option"},
						Field, {Hold[Error::NotAllowedPositionNameFromExistingObject], Positions, Lookup[packet, Type], "database"},
						_, {Hold[Error::NotAllowedPositionName], Positions, Lookup[packet, Type]}
					]
				]
			},
			Test["There is a single position defined for the model container named \"A1\":",
				Lookup[packet,Positions],
				{AssociationMatchP[<|Name->"A1"|>,AllowForeignKeys->True]}
			]
		],

		If[TrueQ[Lookup[packet, PendingParameterization]],
			(* The test below is divided intentionally to make it easier to communicate the error to user *)
			{
				Test["There is at most 1 entries of PositionPlotting field defined for the model container:",
					Length[Lookup[packet, PositionPlotting]],
					Alternatives[0, 1],
					Message -> Switch[Lookup[fieldSource, PositionPlotting],
						User, {Hold[Error::MultiplePositions], PositionPlotting, Lookup[packet, Type]},
						Template, {Hold[Error::MultiplePositionsFromExistingObject], PositionPlotting, Lookup[packet, Type], "Template option"},
						Field, {Hold[Error::MultiplePositionsFromExistingObject], PositionPlotting, Lookup[packet, Type], "database"},
						_, {Hold[Error::MultiplePositions], PositionPlotting, Lookup[packet, Type]}
					]
				],
				Test["If one single entry is defined for PositionPlotting, the position name must be \"A1\":",
					{Length[Lookup[packet, PositionPlotting]], Lookup[packet, PositionPlotting]},
					Alternatives[{1, {AssociationMatchP[<|Name->"A1"|>, AllowForeignKeys->True]}}, {Except[1], _}],
					Message -> Switch[Lookup[fieldSource, PositionPlotting],
						User, {Hold[Error::NotAllowedPositionName], PositionPlotting, Lookup[packet, Type]},
						Template, {Hold[Error::NotAllowedPositionNameFromExistingObject], PositionPlotting, Lookup[packet, Type], "Template option"},
						Field, {Hold[Error::NotAllowedPositionNameFromExistingObject], PositionPlotting, Lookup[packet, Type], "database"},
						_, {Hold[Error::NotAllowedPositionName], PositionPlotting, Lookup[packet, Type]}
					]
				]
			},
			Test["There is a single entry in PositionPlotting defined for the model container named \"A1\":",
				Lookup[packet,Positions],
				{AssociationMatchP[<|Name->"A1"|>,AllowForeignKeys->True]}
			]
		],

		If[TrueQ[Lookup[packet, PendingParameterization]],
			Nothing,
			(* Message should never be thrown when user call this function, so no need to define custom error message *)
			Test["Aperture is informed if the container is not an ampoule, permanently sealed, dropper, or Hermetic:",
				Lookup[packet,{Ampoule,Dropper,Hermetic,PermanentlySealed,Aperture}],
				Alternatives[
					{True,_,_,_,_},
					{_,True,_,_,_},
					{_,_,True,_,_},
					{_,_,_,True,_},
					{Except[True],Except[True],Except[True],Except[True],Except[Null]}
				],
				Message -> {Hold[Error::ApertureRequired], identifier}
			]
		],

		Test["If Graduations is informed, they are listed from the smallest marking:",
			{Lookup[packet,Graduations],MatchQ[Lookup[packet,Graduations],Sort[Lookup[packet,Graduations]]]},
			{{___},True}
		],

		If[TrueQ[Lookup[packet, PendingParameterization]],
			(* If the container is still pending parameterization, we allow the Dimensions to be empty *)
			Test["If the container has CrossSectionalShape->Circle, X and Y dimensions must be identical:",
				Lookup[packet, {CrossSectionalShape, Dimensions}],
				Alternatives[
					{Circle, {diameter_, diameter_, _}},
					{Except[Circle], _},
					{_, ({} | {Null, Null, _})}
				],
				Message -> Switch[Lookup[fieldSource, {CrossSectionalShape, Dimensions}],
					{User, User}, {Hold[Error::ConflictingDimensionsEntry], CrossSectionalShape, Dimensions},
					{User, Template}, {Hold[Error::ConflictingDimensionsEntryWithExistingField], CrossSectionalShape, Dimensions, "Template option"},
					{User, Field}, {Hold[Error::ConflictingDimensionsEntryWithExistingField], CrossSectionalShape, Dimensions, "database"},
					{Template, User}, {Hold[Error::ConflictingDimensionsEntryFromExistingField], CrossSectionalShape, Dimensions, "Template option"},
					{Field, User}, {Hold[Error::ConflictingDimensionsEntryFromExistingField], CrossSectionalShape, Dimensions, "database"},
					{Template, Template}, {Hold[Error::ConflictingDimensionsEntryBetweenExistingField], CrossSectionalShape, Dimensions, "Template option"},
					{Field, Field}, {Hold[Error::ConflictingDimensionsEntryBetweenExistingField], CrossSectionalShape, Dimensions, "database"},
					{_, _}, {Hold[Error::ConflictingDimensionsEntry], CrossSectionalShape, Dimensions}
				]
			],
			Test["If the container has CrossSectionalShape->Circle, X and Y dimensions must be identical:",
				Lookup[packet, {CrossSectionalShape, Dimensions}],
				Alternatives[
					{Circle, {diameter_, diameter_, _}},
					{Except[Circle], _}
				],
				Message -> Switch[Lookup[fieldSource, {CrossSectionalShape, Dimensions}],
					{User, User}, {Hold[Error::ConflictingDimensionsEntry], CrossSectionalShape, Dimensions},
					{User, Template}, {Hold[Error::ConflictingDimensionsEntryWithExistingField], CrossSectionalShape, Dimensions, "Template option"},
					{User, Field}, {Hold[Error::ConflictingDimensionsEntryWithExistingField], CrossSectionalShape, Dimensions, "database"},
					{Template, User}, {Hold[Error::ConflictingDimensionsEntryFromExistingField], CrossSectionalShape, Dimensions, "Template option"},
					{Field, User}, {Hold[Error::ConflictingDimensionsEntryFromExistingField], CrossSectionalShape, Dimensions, "database"},
					{Template, Template}, {Hold[Error::ConflictingDimensionsEntryBetweenExistingField], CrossSectionalShape, Dimensions, "Template option"},
					{Field, Field}, {Hold[Error::ConflictingDimensionsEntryBetweenExistingField], CrossSectionalShape, Dimensions, "database"},
					{_, _}, {Hold[Error::ConflictingDimensionsEntry], CrossSectionalShape, Dimensions}
				]
			]
		],

		Test["PlateImagerRack must be populated if and only if PreferredCamera or CompatibleCameras includes Plate:",
			{Append@@Lookup[packet, {CompatibleCameras, PreferredCamera}], Lookup[packet, PlateImagerRack]},
			Alternatives[
				{_?(MemberQ[#, Plate]&), Except[Null]},
				{_?(!MemberQ[#, Plate]&), Null}
			]
		]
	}
];



(* ::Subsection::Closed:: *)
(*validModelContainerVesselDialysisQTests*)

DefineOptions[
	validModelContainerVesselDialysisQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerVesselDialysisQTests[packet:PacketP[Model[Container,Vessel,Dialysis]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{
		NotNullFieldTest[packet,{
			MolecularWeightCutoff
		},
			Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
		]
	}
];



(* ::Subsubsection:: *)
(**)


(* ::Subsection::Closed:: *)
(*validModelContainerVesselBufferCartridgeQTests *)
DefineOptions[
	validModelContainerVesselBufferCartridgeQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerVesselBufferCartridgeQTests[packet:PacketP[Model[Container,Vessel,BufferCartridge]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{

		Test[
			"If CathodeSequencingBuffer is informed, it matches the correct buffer object type:",
			MatchQ[Lookup[packet,CathodeSequencingBuffer],Alternatives[Null,ObjectP[{Model[Sample,"DNA Sequencing Cathode Buffer"],Object[Sample,"DNA Sequencing Cathode Buffer"]}]]],
			True
		]
	}
];


(* ::Subsection::Closed:: *)
(*validModelContainerBasketQTests*)
DefineOptions[
	validModelContainerBasketQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerBasketQTests[packet:PacketP[Model[Container,Basket]], ops:OptionsPattern[]] := {};


(* ::Subsection::Closed:: *)
(*validModelContainerSinkerQTests*)
DefineOptions[
	validModelContainerSinkerQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerSinkerQTests[packet:PacketP[Model[Container,Sinker]], ops:OptionsPattern[]] := {};


(* ::Subsection::Closed:: *)
(*validModelContainerDosageDispensingUnitQTests*)
DefineOptions[
	validModelContainerDosageDispensingUnitQTests,
	Options :> {additionalValidQTestOptions}
];
validModelContainerDosageDispensingUnitQTests[packet:PacketP[Model[Container,DosageDispensingUnit]], ops:OptionsPattern[]] := {};

(* ::Subsection::Closed:: *)
(*validModelContainerVesselCrossFlowQTests*)
DefineOptions[
	validModelContainerVesselCrossFlowQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerVesselCrossFlowQTests[packet:PacketP[Model[Container,Vessel,CrossFlowContainer]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	{
		NotNullFieldTest[packet,{
			MinVolume,
			MaxVolume,
			Connectors
		},
			Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
		],

		Test[
			"Object has at least three connectors with names \"Filter Outlet\", \"Detector Inlet\" and \"Diafiltration Buffer Inlet\":",
			MemberQ[Lookup[packet,Connectors][[All,1]],#]&/@{"Filter Outlet","Detector Inlet","Diafiltration Buffer Inlet"},
			{True,True,True}
		]
	}
];



(* ::Subsection::Closed:: *)
(*validModelContainerVesselCrossFlowQTests*)
DefineOptions[
	validModelWashContainerVesselCrossFlowQTests,
	Options :> {additionalValidQTestOptions}
];

validModelWashContainerVesselCrossFlowQTests[packet:PacketP[Model[Container,Vessel,CrossFlowWashContainer]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{

	NotNullFieldTest[packet,{
		MinVolume,
		MaxVolume,
		Connectors
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],


		Test[
			"Object has at least three connectors with names \"Filter Outlet\", \"Detector Inlet\" and \"Diafiltration Buffer Inlet\":",
			MemberQ[Lookup[packet,Connectors][[All,1]],#]&/@{"Filter Outlet","Detector Inlet","Diafiltration Buffer Inlet"},
			{True,True,True}
		]
	}
];


(* ::Subsection::Closed:: *)
(*validModelContainerVesselFilterQTests*)
DefineOptions[
	validModelContainerVesselFilterQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerVesselFilterQTests[packet:PacketP[Model[Container,Vessel,Filter]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache, object, fastAssoc, identifier},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};
	object = Lookup[packet, Object];
	identifier = If[DatabaseMemberQ[object],
		object,
		Lookup[packet, Type]
	];
	fastAssoc = updateFastAssoc[{{DestinationContainerModel, CounterWeights}}, packet, cache];

	(* construct tests *)
	{

		(* Shared fields *)
		NotNullFieldTest[packet,
			{
				MembraneMaterial,
				PreferredBalance,
				FilterType
			},
			Message -> Automatic,
			FieldSource -> fieldSource,
			ParentFunction -> "UploadContainerModel"
		],

		UniquelyInformedTest[packet,
			{PoreSize,MolecularWeightCutoff},
			Message -> Automatic,
			FieldSource -> fieldSource
		],

		Test["If FilterType is Centrifuge and DestinationContainerModel is populated, the Counterweights field of the DestinationContainerModel must also be populated:",
			If[MatchQ[Lookup[packet, {FilterType, DestinationContainerModel}], {Centrifuge, Except[Null]}],
				Not[MatchQ[Experiment`Private`fastAssocLookup[fastAssoc, object, {DestinationContainerModel, Counterweights}], {}]],
				True
			],
			True,
			Message -> Switch[Lookup[fieldSource, DestinationContainerModel],
				(User | Resolved), {Hold[Error::InvalidDestinationContainerModel], DestinationContainerModel},
				Template, {Hold[Error::InvalidDestinationContainerModelWithExistingField], DestinationContainerModel, Lookup[packet, DestinationContainerModel], "Template option"},
				Field, {Hold[Error::InvalidDestinationContainerModelWithExistingField], DestinationContainerModel, Lookup[packet, DestinationContainerModel], "database"},
				_, {Hold[Error::InvalidDestinationContainerModel], DestinationContainerModel}
			]
		],

		Test["If StorageBuffer -> True, then StorageBufferVolume must be populated:",
			If[TrueQ[Lookup[packet, StorageBuffer]],
				VolumeQ[Lookup[packet, StorageBufferVolume]],
				True
			],
			True
		],

		Map[
			Function[{field},
				NullFieldTest[
					packet,
					field,
					Message -> Switch[Lookup[fieldSource, field],
						User, {Hold[Error::RedundantOptions], Lookup[packet, Type], field},
						Template, {Hold[Error::RedundantOptionsFromExistingField], Lookup[packet, Type], field, "Template option"},
						Field, {Hold[Error::RedundantOptionsFromExistingField], Lookup[packet, Type], field, "database"},
						_, {Hold[Error::RedundantOptions], Lookup[packet, Type], field}
					]
				]
			],
			{
				CleaningMethod,
				Ampoule,
				Hermetic
			}
		]
	}
];


(* ::Subsection::Closed:: *)
(*validModelContainerVesselVolumetricFlaskQTests*)
DefineOptions[
	validModelContainerVesselVolumetricFlaskQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerVesselVolumetricFlaskQTests[packet:PacketP[Model[Container,Vessel,VolumetricFlask]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{
		NotNullFieldTest[packet,{
			Precision
		},
			Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
		],

		Test[
			"Graduations of the container is informed and only informed one value:",
			MatchQ[Lookup[packet,Graduations],{_}],
			True
		],
		Test[
			"VolumetricFlask should has RentByDefault set as True:",
			MatchQ[Lookup[packet,RentByDefault],True],
			True
		]
	}
];


(* ::Subsection::Closed:: *)
(*validModelContainerVesselGasWashingBottleQTests*)
DefineOptions[
	validModelContainerVesselGasWashingBottleQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerVesselGasWashingBottleQTests[packet:PacketP[Model[Container,Vessel,GasWashingBottle]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{
		NotNullFieldTest[packet,{
			MaxVolume,
			MaxNumberOfUses,
			InletFritted
		},
			Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
		],

		Test["The InletPorosity should only be informed when the InletFritted is True:",
			Module[{inletFritted, inletPorosity},
				{inletFritted, inletPorosity} = Lookup[packet, {InletFritted, InletPorosity}]
			],
			Alternatives[{True, GasWashingBottlePorosityP}, {False, Null}]
		]
	}
];


(* ::Subsection::Closed:: *)
(*validContainerWashBathQTests*)


validContainerWashBathQTests[packet:PacketP[Model[Container,WashBath]]]:={

	(* Make sure MaxSampleVolume is populated *)
	NotNullFieldTest[packet, {MaxSampleVolume},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerWashBinQTests*)


validModelContainerWashBinQTests[packet:PacketP[Model[Container,WashBin]]]:={

	(* Shared fields shaping *)
	NullFieldTest[packet,{
		Ampoule,
		Hermetic
	}],

	NotNullFieldTest[packet, {
		CleaningType
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]

};


(* ::Subsection::Closed:: *)
(*validModelContainerWasteBinQTests*)


validModelContainerWasteBinQTests[packet:PacketP[Model[Container,WasteBin]]]:={

	NotNullFieldTest[packet,{MaxVolume,WasteType,ContainerMaterials},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Shared Fields which should be null *)
	NullFieldTest[
		packet,
		{
			CleaningMethod,
			PreferredBalance,
			Ampoule,
			Hermetic
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelContainerWasteQTests*)


validModelContainerWasteQTests[packet:PacketP[Model[Container,Waste]]]:={
	NullFieldTest[packet, {
		CleaningMethod,
		ImageFile,
		MinVolume,
		MaxVolume,
		PreferredBalance,
		Ampoule,
		Hermetic
	}],
	NotNullFieldTest[packet,WasteType,
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]

};


(* ::Subsection::Closed:: *)
(*validModelContainerBoxQTests*)


validModelContainerBoxQTests[packet:PacketP[Model[Container,Box]]]:= {

	NotNullFieldTest[packet, {
		InternalDimensions,
		ContainerMaterials
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]
};



(* ::Subsection::Closed:: *)
(*validModelContainerLightBoxQTests*)


validModelContainerLightBoxQTests[packet:PacketP[Model[Container,LightBox]]]:= {

};


(* ::Subsection::Closed:: *)
(*validModelContainerBumpTrapQTests*)


validModelContainerBumpTrapQTests[packet:PacketP[Model[Container,BumpTrap]]]:={

	(* Not Null fields *)
	NotNullFieldTest[
		packet,
		{
			ImageFile,
			MaxVolume,
			Sterile,
			Opaque,
			Stocked,
			InternalDepth,
			Aperture
		},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(* Well dimensions: *)

	Test["Either the two indexes in InternalDimensions are informed, or InternalDiameter is informed:",
		Lookup[packet,{InternalDimensions,InternalDiameter}],
		{NullP,Except[NullP]}|{{Except[NullP],Except[NullP]},NullP}
	],

	Test["Only one NeckType or TaperGroundJointSize may be informed:",
		Lookup[packet,{NeckType,TaperGroundJointSize}],
		{NullP,NullP}|{Except[NullP],NullP}|{NullP,Except[NullP]}
	],

	Test["There is a single position defined for the model container named \"A1\":",
		Lookup[packet,Positions],
		{AssociationMatchP[<|Name->"A1"|>,AllowForeignKeys->True]}
	],

	Test["If the container has CrossSectionalShape->Circle, X and Y dimensions must be identical:",
		Lookup[packet, {CrossSectionalShape, Dimensions}],
		Alternatives[
			{Circle, {diameter_, diameter_, _}},
			{Except[Circle], _}
		]
	]
};

DefineOptions[
	validModelContainerPlateMALDIQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlateMALDIQTests[packet:PacketP[Model[Container,Plate,MALDI]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{

		Test["The container's footprint is MALDIPlate:",
			Lookup[packet,Footprint],
			MALDIPlate
		]
	}
];

DefineOptions[
	validModelContainerPlatePhaseSeparatorQTests,
	Options :> {additionalValidQTestOptions}
];

validModelContainerPlatePhaseSeparatorQTests[packet:PacketP[Model[Container,Plate,PhaseSeparator]], ops:OptionsPattern[]] := Module[
	{safeOps, fieldSource, cache},

	(* read options *)
	safeOps = SafeOptions[validModelContainerQTests, ToList[ops]];
	{fieldSource, cache} = Lookup[safeOps, #]& /@ {FieldSource, Cache};

	(* construct tests *)
	{
		Test["The container's footprint is Plate:",
			Lookup[packet,Footprint],
			Plate
		]
	}
];


(* ::Subsection::Closed:: *)
(*validModelContainerFoamAgitationModuleQTests*)


validModelContainerFoamAgitationModuleQTests[packet:PacketP[Model[Container,FoamAgitationModule]]]:={
	(*fields that should be informed*)

	(*sanity check tests*)
	FieldComparisonTest[packet,{MinFilterDiameter,MaxFilterDiameter},LessEqual],
	FieldComparisonTest[packet,{MinColumnDiameter,MaxColumnDiameter},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelContainerFoamColumnQTests*)


validModelContainerFoamColumnQTests[packet:PacketP[Model[Container,FoamColumn]]]:={

	NotNullFieldTest[packet,{
		Detector,
		Jacketed,
		Prism,
		Diameter,
		ColumnHeight
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	(*Sanity check ranges*)
	FieldComparisonTest[packet,{MinSampleVolume,MaxSampleVolume},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelContainerStandQTests*)


validModelContainerStandQTests[packet:PacketP[Model[Container,Stand]]]:={

	NotNullFieldTest[packet,{
		RodLength,
		RodDiameter
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	]

};


(* ::Subsection::Closed:: *)
(*validModelContainerClampQTests*)


validModelContainerClampQTests[packet:PacketP[Model[Container,Clamp]]]:={

	NotNullFieldTest[packet,{
		MinDiameter,
		MaxDiameter
	},
		Message -> {Hold[Error::RequiredOptions], Lookup[packet, Object, Null]}
	],

	FieldComparisonTest[packet,{MinDiameter,MaxDiameter},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelContainerSpillKitQTests*)


validModelContainerSpillKitQTests[packet:PacketP[Model[Container,SpillKit]]]:= {

};


(* ::Subsection::Closed:: *)
(*validModelContainerDissolutionShaftQTests*)


validModelContainerDissolutionShaftQTests[packet:PacketP[Model[Container,DissolutionShaft]]]:= {

};

(* ::Subsubsection::Closed:: *)
(*errorToOptionMap*)

errorToOptionMap[Model[Container]] := {
	"Error::RequiredOptions" -> {
		Name,
		Synonyms,
		Authors,
		Positions,
		PositionPlotting,
		Dimensions,
		CrossSectionalShape,
		MinTemperature,
		MaxTemperature,
		SelfStanding
	}
};

errorToOptionMap[Model[Container, Vessel]] := {
	"Error::RequiredOptions" -> {
		ImageFile,
		PreferredBalance,
		SelfStanding,
		MaxVolume,
		InternalBottomShape,
		PreferredCamera,
		Sterile,
		Opaque,
		Stocked,
		Ampoule,
		Squeezable,
		Fragile,
		Reusable,
		MinVolume,
		RNaseFree,
		PyrogenFree,
		DefaultStorageCondition,
		ContainerMaterials,
		DefaultStickerModel
	}
};

errorToOptionMap[Model[Container, Plate]] := {
	"Error::RequiredOptions" -> {
		ImageFile,
		PlateColor,
		WellColor,
		Treatment,
		Rows,
		Columns,
		NumberOfWells,
		AspectRatio,
		HorizontalMargin,
		VerticalMargin,
		DepthMargin,
		WellDepth,
		WellBottom,
		MaxVolume,
		MinVolume,
		HorizontalOffset,
		VerticalOffset,
		Skirted,
		Fragile,
		StorageOrientation,
		Reusable,
		MinTemperature,
		MaxTemperature,
		Sterile,
		RNaseFree,
		PyrogenFree,
		Footprint,
		DefaultStorageCondition,
		DefaultStickerModel
	}
};

errorToOptionMap[Model[Container, Plate, Filter]] := {
	"Error::RequiredOptions" -> {
		MembraneMaterial,
		MolecularWeightCutoff,
		PrefilterPoreSize,
		PoreSize
	}
};

errorToOptionMap[Model[Container, ExtractionCartridge]] := {
	"Error::RequiredOptions" -> {
		ImageFile,
		Fragile,
		MinTemperature,
		MaxTemperature,
		Reusable,
		MaxVolume,
		PackingMaterial,
		SeparationMode,
		FunctionalGroup,
		ParticleSize,
		PoreSize,
		BedWeight,
		Footprint,
		DefaultStorageCondition,
		CoverTypes,
		DefaultStickerModel
	}
};



(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Model[Container],validModelContainerQTests];
registerValidQTestFunction[Model[Container, Bag],validModelContainerBagQTests];
registerValidQTestFunction[Model[Container, Bag, Aseptic],validModelContainerBagAsepticQTests];
registerValidQTestFunction[Model[Container, Bag, Autoclave],validModelContainerBagAutoclaveQTests];
registerValidQTestFunction[Model[Container, Bag, Dishwasher],validModelContainerBagDishwasherQTests];
registerValidQTestFunction[Model[Container, Bench],validModelContainerBenchQTests];
registerValidQTestFunction[Model[Container, Bench, Receiving],validModelContainerBenchReceivingQTests];
registerValidQTestFunction[Model[Container, Building],validModelContainerBuildingQTests];
registerValidQTestFunction[Model[Container, BumpTrap],validModelContainerBumpTrapQTests];
registerValidQTestFunction[Model[Container, Cabinet],validModelContainerCabinetQTests];
registerValidQTestFunction[Model[Container, Capillary],validModelContainerCapillaryQTests];
registerValidQTestFunction[Model[Container, CartDock],validModelContainerCartDockQTests];
registerValidQTestFunction[Model[Container, CentrifugeBucket],validModelContainerCentrifugeBucketQTests];
registerValidQTestFunction[Model[Container, CentrifugeRotor],validModelContainerCentrifugeRotorQTests];
registerValidQTestFunction[Model[Container, ColonyHandlerHeadCassetteHolder],validModelContainerColonyHandlerHeadCassetteHolderQTests];
registerValidQTestFunction[Model[Container, Cuvette],validModelContainerCuvetteQTests];
registerValidQTestFunction[Model[Container, Deck],validModelContainerDeckQTests];
registerValidQTestFunction[Model[Container, DosingHead],validModelContainerDosingHeadQTests];
registerValidQTestFunction[Model[Container, ElectricalPanel],validModelContainerElectricalPanelQTests];
registerValidQTestFunction[Model[Container, Enclosure],validModelContainerEnclosureQTests];
registerValidQTestFunction[Model[Container, ExtractionCartridge],validModelContainerExtractionCartridgeQTests];
registerValidQTestFunction[Model[Container, Envelope], validModelContainerEnvelopeQTests];
registerValidQTestFunction[Model[Container, FlammableCabinet],validModelContainerFlammableCabinetQTests];
registerValidQTestFunction[Model[Container,FiberSampleHolder],validModelContainerFiberSampleHolderQTests];
registerValidQTestFunction[Model[Container, FloatingRack],validModelContainerFloatingRackQTests];
registerValidQTestFunction[Model[Container, Floor],validModelContainerFloorQTests];
registerValidQTestFunction[Model[Container, FoamColumn],validModelContainerFoamColumnQTests];
registerValidQTestFunction[Model[Container, FoamAgitationModule],validModelContainerFoamAgitationModuleQTests];
registerValidQTestFunction[Model[Container, GasCylinder],validModelContainerGasCylinderQTests];
registerValidQTestFunction[Model[Container, GraduatedCylinder],validModelContainerGraduatedCylinderQTests];
registerValidQTestFunction[Model[Container, GrinderTubeHolder],validModelContainerGrinderTubeHolderQTests];
registerValidQTestFunction[Model[Container, GrindingContainer],validModelContainerGrindingContainerQTests];
registerValidQTestFunction[Model[Container, Hemocytometer],validModelContainerHemocytometerQTests];
registerValidQTestFunction[Model[Container, LightBox],validModelContainerLightBoxQTests];
registerValidQTestFunction[Model[Container, JunctionBox],validModelContainerJunctionBoxQTests];
registerValidQTestFunction[Model[Container, MagazineRack],validModelContainerMagazineRackQTests];
registerValidQTestFunction[Model[Container, MicrofluidicChip],validModelContainerMicrofluidicChipQTests];
registerValidQTestFunction[Model[Container, MicroscopeSlide],validModelContainerMicroscopeSlideQTests];
registerValidQTestFunction[Model[Container, NMRSpinner],validModelContainerNMRSpinnerQTests];
registerValidQTestFunction[Model[Container, OperatorCart],validModelContainerOperatorCartQTests];
registerValidQTestFunction[Model[Container, Plate],validModelContainerPlateQTests];
registerValidQTestFunction[Model[Container, Plate, CapillaryStrip],validModelContainerPlateCapillaryStripQTests];
registerValidQTestFunction[Model[Container, Plate, Dialysis],validModelContainerPlateDialysisQTests];
registerValidQTestFunction[Model[Container, Plate, DropletCartridge],validModelContainerPlateDropletCartridgeQTests];
registerValidQTestFunction[Model[Container, Plate, Filter],validModelContainerPlateFilterQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular],validModelContainerPlateIrregularQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular, ArrayCard],validModelContainerPlateIrregularArrayCardQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular, CapillaryELISA],validModelContainerPlateIrregularCapillaryELISAQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular, Raman], validModelContainerPlateIrregularRamanQTests];
registerValidQTestFunction[Model[Container, PlateSealMagazine],validModelContainerPlateSealMagazineQTests];
registerValidQTestFunction[Model[Container, PortableCooler],validModelContainerPortableCoolerQTests];
registerValidQTestFunction[Model[Container, PortableHeater],validModelContainerPortableHeaterQTests];
registerValidQTestFunction[Model[Container, ProteinCapillaryElectrophoresisCartridge],validModelContainerProteinCapillaryElectrophoresisCartridgeQTests];
registerValidQTestFunction[Model[Container, ProteinCapillaryElectrophoresisCartridgeInsert],validModelContainerProteinCapillaryElectrophoresisCartridgeInsertQTests];
registerValidQTestFunction[Model[Container, Rack],validModelContainerRackQTests];
registerValidQTestFunction[Model[Container, Rack, Dishwasher],validModelContainerRackDishwasherQTests];
registerValidQTestFunction[Model[Container, Rack,InsulatedCooler],validModelContainerRackInsulatedCoolerQTests];
registerValidQTestFunction[Model[Container, ReactionVessel],validModelContainerReactionVesselQTests];
registerValidQTestFunction[Model[Container, ReactionVessel, Microwave],validModelContainerReactionVesselMicrowaveQTests];
registerValidQTestFunction[Model[Container, ReactionVessel, SolidPhaseSynthesis],validModelContainerReactionVesselSolidPhaseSynthesisQTests];
registerValidQTestFunction[Model[Container, ReactionVessel, ElectrochemicalSynthesis],validModelContainerReactionVesselElectrochemicalSynthesisQTests];
registerValidQTestFunction[Model[Container, Room],validModelContainerRoomQTests];
registerValidQTestFunction[Model[Container, Safe],validModelContainerSafeQTests];
registerValidQTestFunction[Model[Container, Shelf],validModelContainerShelfQTests];
registerValidQTestFunction[Model[Container, ShelvingUnit],validModelContainerShelvingUnitQTests];
registerValidQTestFunction[Model[Container, Shipping],validModelContainerShippingQTests];
registerValidQTestFunction[Model[Container, Syringe],validModelContainerSyringeQTests];
registerValidQTestFunction[Model[Container, SyringeTool],validModelContainerSyringeToolQTests];
registerValidQTestFunction[Model[Container, Vessel],validModelContainerVesselQTests];
registerValidQTestFunction[Model[Container, Basket],validModelContainerBasketQTests];
registerValidQTestFunction[Model[Container, Vessel, BufferCartridge],validModelContainerVesselBufferCartridgeQTests];
registerValidQTestFunction[Model[Container, Vessel, CrossFlowContainer],validModelContainerVesselCrossFlowQTests];
registerValidQTestFunction[Model[Container, Vessel, CrossFlowWashContainer],validModelWashContainerVesselCrossFlowQTests];
registerValidQTestFunction[Model[Container, Vessel, Dialysis],validModelContainerVesselDialysisQTests];
registerValidQTestFunction[Model[Container, Vessel, Filter],validModelContainerVesselFilterQTests];
registerValidQTestFunction[Model[Container, Vessel, VolumetricFlask],validModelContainerVesselVolumetricFlaskQTests];
registerValidQTestFunction[Model[Container, Vessel, GasWashingBottle],validModelContainerVesselGasWashingBottleQTests];
registerValidQTestFunction[Model[Container, Plate, Irregular,Crystallization], validModelContainerPlateIrregularCrystallizationQTests];
registerValidQTestFunction[Model[Container, WashBath],validContainerWashBathQTests];
registerValidQTestFunction[Model[Container, WashBin],validModelContainerWashBinQTests];
registerValidQTestFunction[Model[Container, WasteBin],validModelContainerWasteBinQTests];
registerValidQTestFunction[Model[Container, Waste],validModelContainerWasteQTests];
registerValidQTestFunction[Model[Container, Site],validModelContainerSiteQTests];
registerValidQTestFunction[Model[Container, Sinker],validModelContainerSinkerQTests];
registerValidQTestFunction[Model[Container, DosageDispensingUnit],validModelContainerDosageDispensingUnitQTests];
registerValidQTestFunction[Model[Container, Box],validModelContainerBoxQTests];
registerValidQTestFunction[Model[Container, Plate, MALDI],validModelContainerPlateMALDIQTests];
registerValidQTestFunction[Model[Container, Plate, PhaseSeparator],validModelContainerPlatePhaseSeparatorQTests];
registerValidQTestFunction[Model[Container, Stand],validModelContainerStandQTests];
registerValidQTestFunction[Model[Container, Clamp],validModelContainerClampQTests];
registerValidQTestFunction[Model[Container,PhaseSeparator],validModelContainerPhaseSeparatorQTests];
registerValidQTestFunction[Model[Container,SpillKit],validModelContainerSpillKitQTests];
registerValidQTestFunction[Model[Container,DissolutionShaft],validModelContainerDissolutionShaftQTests];
