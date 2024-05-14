(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadReferenceElectrodeModel*)


(* ::Subsubsection::Closed:: *)
(*Options and Messages*)


DefineOptions[UploadReferenceElectrodeModel,
	Options :> {
		(* Organizational Information *)
		{
			OptionName -> Name,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line,
				BoxText -> "Reference Electrode Model Name"
			],
			Description -> "The name that should be given to the reference electrode model generated.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> Synonyms,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Adder[
				Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				]
			],
			Description -> "A list of possible alternate names that should be associated with this reference electrode model. If Name is provided, the Synonyms should contain the Name as the first entry.",
			ResolutionDescription -> "Automatically set to contain the Name (as the first entry).",
			Category -> "Organizational Information"
		},

		(* -- ReferenceElectrode specific -- *)
		{
			OptionName -> ReferenceElectrodeType,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> ReferenceElectrodeTypeP
			],
			Description -> "The electrode category defined by the combination of the metal material and the reference solution filled in its glass tube. For example, a silver wire reference electrode filled with 3M KCl aqueous solution in its glass tube is of 'Ag/AgCl' type.",
			ResolutionDescription -> "Automatically set to the ReferenceElectrodeType field of the template reference electrode model if one is provided.",
			Category -> "General"
		},
		{
			OptionName -> Blank,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Model[Item, Electrode, ReferenceElectrode]]
			],
			Description -> "Indicates the empty reference electrode model that serves as the basis to transform into the new reference electrode model by filling the ReferenceSolution. Setting Blank option to Null indicates the reference electrode model being uploaded is a Blank model.",
			ResolutionDescription -> "Automatically set to the Blank field of the template reference electrode model if one is provided. If no template reference electrode model is provided, this is automatically set to Model[Item, Electrode, ReferenceElectrode, \"IKA Bare Silver Wire Reference Electrode\"]. The Blank option must be provided if the model being uploaded is a derived reference electrode model that cannot be directly purchased from a Product object.",
			Category -> "General"
		},
		{
			OptionName -> RecommendedSolventType,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Organic | Aqueous
			],
			Description -> "The type of solvent this reference electrode model is recommended to work in.",
			ResolutionDescription -> "Automatically set to the RecommendedSolventType field of the template reference electrode model if one is provided. If no template reference electrode model is provided and a Blank is provided, the RecommendedSolventType is set to Organic. If no template reference electrode model is provided and no Blank is provided, the RecommendedSolventType is set to Null.",
			Category -> "General"
		},
		{
			OptionName -> ReferenceSolution,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Model[Sample]]
			],
			Description -> "The reference solution filled in the glass tube of this reference electrode model. The reference solution usually has a pairing ion species (ReferenceCouplingSample) to couple with the electrode metal material to form a defined redox couple.",
			ResolutionDescription -> "Automatically set to the ReferenceSolution field of the template reference electrode model if one is provided. If no template reference electrode model is provided, the ReferenceSolution is default to Model[Sample, StockSolution, \"3M KCl Aqueous Solution, 10 mL\"] if RecommendedSolventType is Aqueous, and is default to Model[Sample, StockSolution, \"0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL\"] if RecommendedSolventType is Organic.",
			Category -> "General"
		},
		{
			OptionName -> ReferenceCouplingSample,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Model[Sample]]
			],
			Description -> "The chemical that forms a defined redox couple with the electrode's metal material. This redox couple indicates which ReferenceElectrodeType this reference electrode model belongs to.",
			ResolutionDescription -> "Automatically set to the ReferenceSolution field of the template reference electrode model if one is provided. If no template reference electrode model is provided, automatically set this to the DefaultSampleModel of the analyte molecule stored in the Analytes field of the ReferenceSolution.",
			Category -> "General"
		},
		{
			OptionName -> SolutionVolume,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Milliliter],
				Units -> {Milliliter, {Microliter, Milliliter, Liter}}
			],
			Description -> "The required volume of reference solution filled in the glass tube of the reference electrode for the electrode to properly work.",
			ResolutionDescription -> "Automatically set to the SolutionVolume field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the SolutionVolume field of the Blank reference electrode model.",
			Category -> "General"
		},
		{
			OptionName -> RecommendedRefreshPeriod,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Month],
				Units -> {Month, {Day, Month, Year}}
			],
			Description -> "The recommended time duration to refresh the reference solution filled in the glass tube of the reference electrode model. This option will not be used when comparing if two reference electrode models are identical.",
			ResolutionDescription -> "Automatically set to the RecommendedRefreshPeriod field of the template reference electrode model if one is provided. If no template reference electrode model is provided, RecommendedRefreshPeriod is default to 2 month.",
			Category -> "General"
		},

		{
			OptionName -> Dimensions,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> {
				"Width" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Centimeter],
					Units -> {Centimeter, {Millimeter, Centimeter, Meter}}
				],
				"Length" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Centimeter],
					Units -> {Centimeter, {Millimeter, Centimeter, Meter}}
				],
				"Height" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Centimeter],
					Units -> {Centimeter, {Millimeter, Centimeter, Meter}}
				]
			},
			Description -> "The external dimensions of this reference electrode model.",
			ResolutionDescription -> "Automatically set to the Dimensions field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the Dimensions field of the Blank reference electrode model.",
			Category -> "Dimensions & Positions"
		},
		{
			OptionName -> DefaultStorageCondition,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[AmbientStorage]
				],
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[StorageCondition]]
				]
			],
			Description -> "The condition in which reference electrodes of this model are stored when not in use by an experiment.",
			ResolutionDescription -> "Automatically set to the default storage condition of the ReferenceSolution. If the reference electrode model being uploaded is a Blank model (without ReferenceSolution), this is automatically set to Model[StorageCondition, \"Ambient Storage\"].",
			Category -> "Storage Information"
		},

		(* Physical Properties *)
		{
			OptionName -> BulkMaterial,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> MaterialP
			],
			Description -> "The internal portion of the metal wire or plate of this reference electrode model. This is the same as the WettedMaterials if the electrode's wire or plate does not have a CoatMaterial.",
			ResolutionDescription -> "Automatically set to the BulkMaterial field of the template reference electrode model if one is provided. Otherwise, if a Blank is provided, it is automatically set to the BulkMaterial field of the Blank reference electrode model.",
			Category -> "Physical Properties"
		},
		{
			OptionName -> CoatMaterial,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> MaterialP
			],
			Description -> "The external portion of the metal wire or plate of this reference electrode model, if the wire or plate has a different material on the outside of the BulkMaterial. This is the same as the WettedMaterials if CoatMaterial is present.",
			ResolutionDescription -> "Automatically set to the CoatMaterial field of the template reference electrode model if one is provided. Otherwise, if a Blank is provided, it is automatically set to the CoatMaterial field of the Blank reference electrode model.",
			Category -> "Physical Properties"
		},
		{
			OptionName -> ElectrodeShape,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> ElectrodeShapeP
			],
			Description -> "The shape of the conductive metal part of this reference electrode model. For example, the silver-based reference electrodes usually has a rod shape (see table x.x for other examples).",
			ResolutionDescription -> "Automatically set to the ElectrodeShape field of the template reference electrode model if one is provided. Otherwise, if a Blank is provided, it is automatically set to the ElectrodeShape field of the Blank reference electrode model.",
			Category -> "Physical Properties"
		},
		{
			OptionName -> ElectrodePackagingMaterial,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> MaterialP
			],
			Description -> "The material of this reference electrode model's conductive wiring or plate casing. The ElectrodePackingMaterial is also included in the WettedMaterials if the packaging material is not provided in the WettedMaterials option.",
			ResolutionDescription -> "Automatically set to the ElectrodePackingMaterial field of the template reference electrode model if one is provided. Otherwise, if a Blank is provided, it is automatically set to the ElectrodePackingMaterial field of the Blank reference electrode model.",
			Category -> "Physical Properties"
		},

		(* Wiring Information *)
		{
			OptionName -> WiringConnectors,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Adder[{
				"Wiring Connector Name" -> Widget[
					Type -> String,
					Pattern :> WiringConnectorNameP,
					Size -> Line,
					BoxText -> Null
				],
				"Wiring Connector Type" -> Widget[
					Type -> Enumeration,
					Pattern :> WiringConnectorP
				],
				"Wiring Connector Gender" -> Widget[
					Type -> Enumeration,
					Pattern :> ConnectorGenderP|None
				]
			}],
			Description -> "Specifications for the ends of the wiring connectors on this reference electrode model that may plug into and conductively connect to other wiring components. 'Wiring Connector Diameter' only applies to naked wire connectors.",
			ResolutionDescription -> "Automatically set to the information stored in WiringConnectors and WiringDiameters fields of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the information stored in WiringConnectors and WiringDiameters fields of the Blank reference electrode model.",
			Category -> "Wiring Information"
		},
		{
			OptionName -> WiringDiameters,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Adder[
				Alternatives[
					Widget[
						Type->Quantity,
						Pattern:>GreaterP[0 Millimeter],
						Units->{Millimeter, {Millimeter, Centimeter, Meter}}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					]
				]
			],
			Description -> "The effective diameters of each WiringConnector. This option only applies to naked wire connectors. If there are several wiring connectors, please make sure the list of the WiringDiameters is the same with the list of WiringConnectors.",
			ResolutionDescription -> "Automatically set to the WiringDiameters field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the WiringDiameters field of the Blank reference electrode model.",
			Category -> "Wiring Information"
		},
		{
			OptionName -> WiringLength,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 Centimeter],
				Units -> {Centimeter, {Millimeter, Centimeter, Meter}}
			],
			Description -> "The length of this reference electrode's conductive part, along its longest axis.",
			ResolutionDescription -> "Automatically set to the WiringLength field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the WiringLength field of the Blank reference electrode model.",
			Category -> "Wiring Information"
		},

		(* Operating Limits *)
		{
			OptionName -> MaxNumberOfUses,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterEqualP[1, 1]
			],
			Description -> "The maximum number of uses the reference electrode can endure before it is considered expired.",
			ResolutionDescription -> "Automatically set to the MaxNumberOfUses field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the MaxNumberOfUses field of the Blank reference electrode model.",
			Category -> "Operating Limits"
		},
		{
			OptionName -> MinPotential,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> LessEqualP[0 Volt],
				Units -> {Volt, {Millivolt, Volt}}
			],
			Description -> "The minimum electrical voltage can be applied on this reference electrode model without damaging the electrode.",
			ResolutionDescription -> "Automatically set to the MinPotential field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the MinPotential field of the Blank reference electrode model.",
			Category -> "Operating Limits"
		},
		{
			OptionName -> MaxPotential,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Volt],
				Units -> {Volt, {Millivolt, Volt}}
			],
			Description -> "The maximum electrical voltage can be applied on this reference electrode model without damaging the electrode.",
			ResolutionDescription -> "Automatically set to the MaxPotential field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the MaxPotential field of the Blank reference electrode model.",
			Category -> "Operating Limits"
		},
		{
			OptionName -> MaxNumberOfPolishings,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterEqualP[1, 1]
			],
			Description -> "The maximum number of polishings that the non-working part (the part does not contact experiment solution) of the reference electrode can endure before it is discarded.",
			ResolutionDescription -> "Automatically set to the MaxNumberOfPolishings field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the MaxNumberOfPolishings field of the Blank reference electrode model. If the model being uploaded is a Blank model (no Blank model is provided), it is automatically set to 50.",
			Category -> "Operating Limits"
		},

		(* Electrode Cleaning *)
		{
			OptionName -> SonicationSensitive,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates the electrode model has components that may be damaged if it is sonication-cleaned.",
			ResolutionDescription -> "Automatically set to the SonicationSensitive field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the SonicationSensitive field of the Blank reference electrode model.",
			Category -> "Electrode Cleaning"
		},

		(* --- Compatibility --- *)
		{
			OptionName -> WettedMaterials,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> With[
				{insertMe=Flatten[MaterialP]},
				Widget[
					Type -> MultiSelect,
					Pattern :> DuplicateFreeListableP[insertMe]
				]
			],
			Description -> "A list of materials that includes the CoatMaterial (if a CoatMaterial is present for this reference electrode model), BulkMaterial (if a CoatMaterial is not present for this reference electrode model), and the ElectrodePackingMaterial (if ElectrodePackaging is not None).",
			ResolutionDescription -> "Automatically set to the WettedMaterials field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the WettedMaterials field of the Blank reference electrode model.",
			Category -> "Compatibility"
		},
		{
			OptionName -> IncompatibleMaterials,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> With[
				{insertMe=Flatten[Append[MaterialP,None]]},
				Widget[
					Type -> MultiSelect,
					Pattern :> DuplicateFreeListableP[insertMe]
				]
			],
			Description -> "A list of materials that would be damaged if contacted by this model.",
			ResolutionDescription -> "Automatically set to the IncompatibleMaterials field of the template reference electrode model if one is provided. Otherwise, if a Blank model is provided, it is automatically set to the IncompatibleMaterials field of the Blank reference electrode model.",
			Category -> "Compatibility"
		},

		(* this option will be used only when UploadReferenceElectrodeModel is called in ExperimentPrepareReferenceElectrode *)
		{
			OptionName -> Preparable,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the reference electrode model can be prepared by ExperimentPrepareReferenceElectrode.",
			Category -> "Hidden"
		},

		(* This Price option is necessary for resource picking, and should not be Null if $Notebook is Null *)
		{
			OptionName -> Price,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 USD],
				Units -> USD
			],
			Description -> "Indicates the price of a reference electrode Object of the newly uploaded model. For a public reference electrode model (not associated with a Notebook), this option needs to be explicitly specified.",
			Category -> "Hidden"
		},

		(* Hidden option for when called via ExperimentPrepareReferenceElectrode via Engine to ensure that a newly-generated model gets the author of the protocol *)
		{
			OptionName -> Author,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[User]]
			],
			Description -> "The author of the root protocol that who should be listed as author of the reference electrode model created by this function. This option is intended to be passed from ExperimentPrepareReferenceElectrode when it is called by ResourcePicking in Engine only.",
			Category -> "Hidden"
		},

		UploadOption,
		CacheOption,
		OutputOption
	}
];

(* ======================== *)
(* ======= MESSAGES ======= *)
(* ======================== *)

Error::UREDeprecatedTemplateReferenceElectrodeModel = "The provided template reference electrode model input `1` is deprecated and not available to serve as a template for creation of a new reference electrode model (check the Deprecated field). Please either provide a non-deprecated reference electrode model to use as a template, or use the empty-input UploadReferenceElectrodeModel overload to create a new reference electrode model from specified options.";

(* == Option Resolving == *)
Error::UREBlankModelNotBareType = "The provided Blank model is not a \"Bare\" type reference electrode model. A \"Bare\" type reference electrode model has the word \"Bare\" or \"bare\" in its ReferenceElectrodeType and does not have a RecommendedSolventType, ReferenceSolution, ReferenceCouplingSample, or RecommendedRefreshPeriod defined.";
Error::UREReferenceElectrodeTypeUnresolvable = "The required ReferenceElectrodeType option cannot be resolved. Please specify an explicit reference electrode type when no template reference electrode model is provided and the Blank options is set to Null.";
Error::UREReferenceElectrodeTypeSameWithBlankModel = "The resolved ReferenceElectrodeType option is identical with the ReferenceElectrodeType of the resolved Blank model. If the current reference electrode model being uploaded is not a new Blank model, please use the Blank option to specify its Blank model and do not use the same Blank model as the input template reference electrode model.";
Error::UREReferenceElectrodeTypeInvalidForBlankModel = "The ReferenceElectrodeType is not a \"bare\" type (having \"Bare\" or \"bare\") when the model being uploaded is a Blank model (the Blank option is set to Null). Please set ReferenceElectrodeType to a \"bare\" type when the model being uploaded is a Blank model.";
Error::UREReferenceElectrodeTypeInvalidForNonBlankModel = "The ReferenceElectrodeType is a 'bare' type (having \"Bare\" or \"bare\") when the model being uploaded is not a Blank model (the Blank option is specified). Please do not set ReferenceElectrodeType to a \"bare\" type when the model being uploaded is not a Blank model.";
Error::URENonNullRecommendedSolventType = "The RecommendedSolventType is specified when the model being uploaded is a Blank model (the Blank option is set to Null). Please set RecommendedSolventType to Automatic or Null when the model being uploaded is a Blank model.";
Error::UREMissingRecommendedSolventType = "The RecommendedSolventType is set to Null when the model being uploaded is not a Blank model (the Blank option is specified). Please set RecommendedSolventType to Organic or Aqueous when the model being uploaded is not a Blank model.";

Error::UREReferenceSolutionLessThanTwoComponents = "The ReferenceSolution specified has less than two non-null entries in its Composition field. The reference solution sample model should have an entry for the solvent, an entry for the electrolyte, and an optional entry for the reference coupling sample.";
Error::UREReferenceSolutionMissingSolvent = "The ReferenceSolution specified does not have a solvent molecule or sample populated in its Solvent field. Please populate the Solvent field with the solvent molecule or sample used to prepare the ReferenceSolution.";
Error::UREReferenceSolutionSolventSampleAmbiguousMolecule = "The solvent sample in the Solvent field of the specified ReferenceSolution has more than one non-Null entry in its Composition field. Please populate the Composition field of the solvent sample with only the corresponding solvent molecule.";
Error::UREReferenceSolutionMissingAnalyte = "The ReferenceSolution specified does not have a molecule populated in its Analytes field. Please populate the Analytes field with the reference coupling molecule or the electrolyte molecule (when there is no reference coupling molecule) used to prepare the ReferenceSolution.";
Error::UREReferenceSolutionAmbiguousAnalyte = "The ReferenceSolution specified has more than one non-Null molecule populated in its Analytes field. Please populate the Analytes field with only the reference coupling molecule or the electrolyte molecule (when there is no reference coupling molecule) used to prepare the ReferenceSolution.";
Error::UREReferenceSolutionAnalyteMoleculeMissingDefaultSampleModel = "The molecule in the Analytes field of the specified ReferenceSolution does not have a DefaultSampleModel defined. Please populate the DefaultSampleModel field of this analyte/electrolyte molecule.";
Error::URENonNullReferenceSolution = "The ReferenceSolution is specified when the model being uploaded is a Blank model (the Blank option is set to Null). Please set ReferenceSolution to Automatic or Null when the model being uploaded is a Blank model.";
Error::UREMissingReferenceSolution = "The ReferenceSolution is set to Null when the model being uploaded is not a Blank model (the Blank option is specified). Please set ReferenceSolution to a solution sample model when the model being uploaded is not a Blank model.";
Warning::UREMismatchingSolventTypeWarning = "The ReferenceSolution has a mismatching solvent type with the RecommendedSolventType, which means the ReferenceSolution has water has its solvent while the RecommendedSolventType is Organic, or the ReferenceSolution has an orgniac solvent while the RecommendedSolventType is Aqueous. Please consider matching the ReferenceSolution solvent and the RecommendedSolventType.";

Error::URENullPriceForPublicPreparableModel = "The newly generated reference electrode model is a public and preparable model, but the Price option is not explicitly provided. Please use the Price option to indicate the price charged when a reference electrode of this model is prepared.";

Error::URENonNullReferenceCouplingSampleForBlankModel = "The ReferenceCouplingSample is specified when the model being uploaded is a Blank model (the Blank option is set to Null). Please set ReferenceCouplingSample to Automatic or Null when the model being uploaded is a Blank model.";
Error::URENonNullReferenceCouplingSampleForPseudoModel = "The ReferenceCouplingSample is specified when the ReferenceElectrodeType is a \"pseudo\" type (having \"Pseudo\" or \"pseudo\"). Please set ReferenceCouplingSample to Automatic or Null when the model being uploaded is of a pseudo reference electrode type, which by definition does not have a clearly defined redox coupling sample.";
Error::UREMissingReferenceCouplingSample = "The ReferenceCouplingSample is set to Null when the model being uploaded is not a Blank model (the Blank option is specified) and the ReferenceElectrodeType is not a \"pseudo\" type (having \"Pseudo\" or \"pseudo\"). Please set ReferenceCouplingSample to a redox coupling sample model when the model being uploaded is not a Blank model and the ReferenceElectrodeType is not a \"pseudo\" type .";
Error::UREReferenceCouplingSampleMissingAnalyte = "The ReferenceCouplingSample specified does not have a molecule populated in its Analytes field. Please populate the Analytes field of the ReferenceCouplingSample with the molecule of interest.";
Error::UREReferenceCouplingSampleAmbiguousAnalyte = "The ReferenceCouplingSample specified has more than one non-Null molecule populated in its Analytes field. Please populate the Analytes field of the ReferenceCouplingSample with only the molecule of interest.";
Error::UREMismatchingReferenceCouplingSampleMolecule = "The molecule defined by the ReferenceCouplingSample is different from the redox coupling molecule defined in the ReferenceSolution. Please make sure the redox coupling molecules in the ReferenceCouplingSample and ReferenceSolution are identical.";

Error::URENonNullRecommendedRefreshPeriod = "The RecommendedRefreshPeriod is specified when the model being uploaded is a Blank model (the Blank option is set to Null). Please set RecommendedRefreshPeriod to Automatic or Null when the model being uploaded is a Blank model.";
Error::UREMissingRecommendedRefreshPeriod = "The RecommendedRefreshPeriod is set to Null when the model being uploaded is not a Blank model (the Blank option is specified). Please set RecommendedRefreshPeriod to a time period (with a precision of one month) when the model being uploaded is not a Blank model.";
Error::URENameExisting = "The provided Name exists in the database. Please choose another Name.";
Error::UREMismatchingDefaultStorageCondition = "The provided DefaultStorageCondition option is different from the DefaultStorageCondition of the ReferenceSolution. Please set DefaultStorageCondition option to Automatic or to the DefaultStorageCondition of the ReferenceSolution.";

Error::URESolutionVolumeUnResolvable = "The SolutionVolume option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please explicitly specify the SolutionVolume option to a volume for a Blank reference electrode model.";
Error::UREDimensionsUnResolvable = "The Dimensions option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please explicitly specify the Dimensions option for a Blank reference electrode model.";
Error::UREBulkMaterialUnResolvable = "The BulkMaterial option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please explicitly specify the BulkMaterial option to a mateiral for a Blank reference electrode model.";
Error::URECoatMaterialUnResolvable = "The CoatMaterial option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please set the CoatMaterial to Null or to a material for a Blank reference electrode model.";
Error::UREElectrodeShapeUnResolvable = "The ElectrodeShape option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please explicitly specify the ElectrodeShape option for a Blank reference electrode model.";
Error::UREWiringConnectorsUnResolvable = "The WiringConnectors option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please explicitly specify the WiringConnectors option for a Blank reference electrode model.";
Error::UREMaxNumberOfUsesUnResolvable = "The MaxNumberOfUses option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please explicitly specify the MaxNumberOfUses option to an Integer for a Blank reference electrode model.";
Error::UREMinPotentialUnResolvable = "The MinPotential option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please explicitly specify the MinPotential option to a negative or zero voltage for a Blank reference electrode model.";
Error::UREMaxPotentialUnResolvable = "The MaxPotential option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please explicitly specify the MaxPotential option to a positive or zero voltage for a Blank reference electrode model.";
Error::URESonicationSensitiveUnResolvable = "The SonicationSensitive option can not be automatically resolved when the model being uploaded is a Blank model (the Blank option is set to Null). Please explicitly specify the SonicationSensitive option to True or False for a Blank reference electrode model.";

Error::UREConflictingSolutionVolume = "The specified SolutionVolume is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified SolutionVolume is identical with the Blank model.";
Error::UREConflictingDimensions = "The specified Dimensions is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified Dimensions is identical with the Blank model.";
Error::UREConflictingBulkMaterial = "The specified BulkMaterial is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified BulkMaterial is identical with the Blank model.";
Error::UREConflictingCoatMaterial = "The specified CoatMaterial is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified CoatMaterial is identical with the Blank model.";
Error::UREConflictingElectrodeShape = "The specified ElectrodeShape is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified ElectrodeShape is identical with the Blank model.";
Error::UREConflictingElectrodePackagingMaterial = "The specified ElectrodePackagingMaterial is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified ElectrodePackagingMaterial is identical with the Blank model.";
Error::UREConflictingWiringConnectors = "The specified WiringConnectors is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified WiringConnectors is identical with the Blank model.";
Error::UREConflictingWiringDiameters = "The specified WiringDiameters is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified WiringDiameters is identical with the Blank model.";
Error::UREConflictingWiringLength = "The specified WiringLength is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified WiringLength is identical with the Blank model.";
Error::UREConflictingSonicationSensitive = "The specified SonicationSensitive is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified SonicationSensitive is identical with the Blank model.";
Error::UREConflictingWettedMaterials = "The specified WettedMaterials is different from its Blank reference electrode model. Since we cannot perform any physical alternations to the reference electrodes, please make sure the specified WettedMaterials is identical with the Blank model.";
Error::UREConflictingMaxNumberOfUses = "The specified MaxNumberOfUses is greater than the MaxNumberOfUses of its Blank reference electrode model. Please make sure the specified MaxNumberOfUses is less or equal to the MaxNumberOfUses of the Blank model.";
Error::UREConflictingMaxNumberOfPolishings = "The specified MaxNumberOfPolishings is greater than the MaxNumberOfPolishings of its Blank reference electrode model. Please make sure the specified MaxNumberOfPolishings is less or equal to the MaxNumberOfPolishings of the Blank model.";
Error::UREConflictingMaxPotential = "The specified MaxPotential is greater than the MaxPotential of its Blank reference electrode model. Please make sure the specified MaxPotential is less or equal to the MaxPotential of the Blank model.";
Error::UREConflictingMinPotential = "The specified MinPotential is less than the MinPotential of its Blank reference electrode model. Please make sure the specified MinPotential is greater or equal to the MinPotential of the Blank model.";

Error::UREWiringParametersMismatchLengths = "The lengths of the specified WiringConnectors and WiringDiameters are different. Please make sure the WiringDiameters list has the same length of the WiringConnectors.";
Error::URENonNullWiringDiameterForNonExposedWire = "The wiring diameters are not Null for the following wiring connectors `1`. Please set the corresponding entries in WiringDiameters to Null. The wiring diameters are used (not Null) only for the exposed wire connectors.";
Error::UREMissingWiringDiameterForExposedWire = "The wiring diameters are set to Null for the following exposed wire connectors `1`. Please set these entries in WiringDiameters to the diameter of their corresponding exposed wire connectors.";

Error::UREMaxNumberOfPolishingsGreaterThanMaxNumberOfUses = "The specified MaxNumberOfPolishings (`1`) is greater than the MaxNumberOfUses (`2`). Please set MaxNumberOfPolishings to an Integer less or equal to the MaxNumberOfUses.";
Error::UREWettedMaterialsNotContainCoatMaterial = "The specified WettedMaterials does not contain the CoatMaterial. The WettedMaterials must contain the CoatMaterial if it is not Null.";
Error::UREWettedMaterialsNotContainBulkMaterial = "The specified WettedMaterials does not contain the BulkMaterial. The WettedMaterials must contain the BulkMaterial if CoatMaterial is Null.";
Error::UREWettedMaterialsNotContainElectrodePackagingMaterial = "The specified WettedMaterials does not contain the ElectrodePackagingMaterial. The WettedMaterials must contain the ElectrodePackagingMaterial if it is not Null.";
Error::UREIncompatibleMaterialsContainCoatMaterial = "The CoatMaterial is a member of the IncompatibleMaterials. The IncompatibleMaterials must not contain the CoatMaterial if the CoatMaterial is not Null.";
Error::UREIncompatibleMaterialsContainBulkMaterial = "The BulkMaterial is a member of the IncompatibleMaterials. The IncompatibleMaterials must not contain the BulkMaterial.";
Error::UREIncompatibleMaterialsContainElectrodePackagingMaterial = "The ElectrodePackagingMaterial is a member of the IncompatibleMaterials. The IncompatibleMaterials must not contain the ElectrodePackagingMaterial if the ElectrodePackagingMaterial is not Null.";

(* ::Subsubsection::Closed:: *)
(*UploadReferenceElectrodeModel*)

(* === OVERLOAD 1: Without Input templateReferenceElectrodeModel Overload === *)
UploadReferenceElectrodeModel[myOptions:OptionsPattern[UploadReferenceElectrodeModel]]:=uploadReferenceElectrodeModel[None, myOptions];

(* === OVERLOAD 2: Single Input templateReferenceElectrodeModels Overload === *)
UploadReferenceElectrodeModel[
	myTemplateReferenceElectrodeModel:ObjectP[Model[Item, Electrode, ReferenceElectrode]],
	myOptions:OptionsPattern[UploadReferenceElectrodeModel]
]:=uploadReferenceElectrodeModel[myTemplateReferenceElectrodeModel, myOptions];

(* === CORE === *)
uploadReferenceElectrodeModel[
	myTemplateReferenceElectrodeModel:ObjectP[Model[Item, Electrode, ReferenceElectrode]]|None,
	myOptions:OptionsPattern[UploadReferenceElectrodeModel]
]:=Module[
	{
		(* Initialization *)
		listedInputs, listedOptions, outputSpecification, listedOutput, gatherTests, safeOptions, safeOptionTests, author, inheritedCache, upload,

		(* DatabaseMemberQ checks *)
		objectsFromOptions, userSpecifiedObjects, objectsExistQs, objectsExistTests,

		(* Downloads *)
		storageConditionFieldNames, modelSampleFieldNames, moleculeFieldNames, solventAllFieldNames, referenceElectrodeFieldNames, storageConditionFields, modelReferenceElectrodeFields, modelSampleFields, storageModels, referenceElectrodeModels, sampleModels, storageModelPackets, referenceElectrodeModelPackets, sampleModelPackets, cacheBall, notebookDownload, authorNotebooks,

		(* Option resolution *)
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests,

		(* Outputs *)
		allTests, allTestTestResults, optionsRule, previewRule, testsRule, resultRule
	},

	(* -------------------- *)
	(* -- Initialization -- *)
	(* -------------------- *)

	(* get the listed form of the inputs and options provided *)
	{listedInputs, listedOptions} = sanitizeInputs[ToList[myTemplateReferenceElectrodeModel], ToList[myOptions]];

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	listedOutput = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[listedOutput, Tests];

	(* default all unspecified or incorrectly-specified options *)
	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[UploadReferenceElectrodeModel, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadReferenceElectrodeModel, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[MatchQ[safeOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> safeOptionTests,
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* NOTE: no fastTrack option for this UploadReferenceElectrodeModel function *)

	(* pseudo-resolve the hidden Author option; either it's Null (meaning we're being called by a User, so they are the author); or it's passed via Engine, and is a root protocol Author *)
	author = If[MatchQ[Lookup[safeOptions, Author], ObjectP[Object[User]]],
		Lookup[safeOptions, Author],
		$PersonID
	];

	(* Look up the provided Cache and Upload options. If we are from the ExperimentPrepareReferenceElectrode option, we get the cache and there is no need to download again? *)
	{inheritedCache, upload} = Lookup[safeOptions, {Cache, Upload}];

	(* ---------------------------------------------------- *)
	(* -- Check for Objects that are not in the database -- *)
	(* ---------------------------------------------------- *)

	(* Get objects provided in options *)
	objectsFromOptions = Cases[Values[safeOptions], ObjectP[]];

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten[{myTemplateReferenceElectrodeModel,objectsFromOptions}],
		ObjectP[]
	];

	(* Check if the userSpecifiedObjects exist *)
	objectsExistQs = DatabaseMemberQ[userSpecifiedObjects];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
			{userSpecifiedObjects, objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[userSpecifiedObjects ,objectsExistQs, False]];
			Message[Error::InvalidInput,PickList[userSpecifiedObjects, objectsExistQs, False]]
		];

		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests, objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* -------------- *)
	(* -- Download -- *)
	(* -------------- *)

	(* Download fields preparation *)
	storageConditionFieldNames = {Name, StorageCondition};

	modelSampleFieldNames = Join[SamplePreparationCacheFields[Model[Sample]], {Preparable, DefaultStorageCondition, IncompatibleMaterials}];

	moleculeFieldNames = {Name, DefaultSampleModel, MolecularWeight};

	(* Solvent field can only be a Model[Sample] *)
	solventAllFieldNames = modelSampleFieldNames;

	referenceElectrodeFieldNames = {Name, Deprecated, ReferenceElectrodeType, Blank, RecommendedSolventType, ReferenceSolution, ReferenceCouplingSample, SolutionVolume, RecommendedRefreshPeriod, Dimensions, DefaultStorageCondition, BulkMaterial, CoatMaterial, ElectrodeShape, ElectrodePackagingMaterial,WiringConnectors, WiringDiameters, WiringLength, MaxNumberOfUses, MinPotential, MaxPotential, MaxNumberOfPolishings, SonicationSensitive, WettedMaterials, IncompatibleMaterials};

	storageConditionFields = {
		Packet[Sequence@@storageConditionFieldNames];
	};

	modelReferenceElectrodeFields = {
		Packet[Sequence@@referenceElectrodeFieldNames],
		Packet[Blank[referenceElectrodeFieldNames]],
		Packet[DefaultStorageCondition[storageConditionFieldNames]],

		(* ReferenceSolution *)
		Packet[ReferenceSolution[modelSampleFieldNames]],
		Packet[ReferenceSolution[Analytes][moleculeFieldNames]],
		Packet[ReferenceSolution[Analytes][DefaultSampleModel][modelSampleFieldNames]],
		Packet[ReferenceSolution[Field[Composition[[All, 2]]]][moleculeFieldNames]],
		Packet[ReferenceSolution[Field[Solvent]][solventAllFieldNames]],

		(* ReferenceCouplingSample *)
		Packet[ReferenceCouplingSample[modelSampleFieldNames]],
		Packet[ReferenceCouplingSample[Analytes][moleculeFieldNames]],
		Packet[ReferenceCouplingSample[Analytes][DefaultSampleModel][modelSampleFieldNames]],
		Packet[ReferenceCouplingSample[Field[Composition[[All, 2]]]][moleculeFieldNames]],
		Packet[ReferenceCouplingSample[Field[Solvent]][solventAllFieldNames]]
	};

	modelSampleFields = {
		Packet[Sequence@@modelSampleFieldNames],
		Packet[Analytes[moleculeFieldNames]],
		Packet[Analytes[DefaultSampleModel][modelSampleFieldNames]],
		Packet[Field[Composition[[All, 2]]][moleculeFieldNames]],
		Packet[Field[Solvent][solventAllFieldNames]]
	};

	(* Identify downloading objects *)
	storageModels = Cases[userSpecifiedObjects, ObjectP[Model[StorageCondition]]];
	referenceElectrodeModels = DeleteDuplicates[Join[
		Cases[userSpecifiedObjects, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
		{Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]}
	]];
	sampleModels = DeleteDuplicates[Join[
		Cases[userSpecifiedObjects, ObjectP[Model[Sample]]],
		{
			Model[Sample, StockSolution, "3M KCl Aqueous Solution, 10 mL"],
			Model[Sample, StockSolution, "0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]
		}
	]];

	(* Download call *)
	{
		storageModelPackets,
		referenceElectrodeModelPackets,
		sampleModelPackets,
		notebookDownload
	} = Quiet[Download[
		{
			storageModels,
			referenceElectrodeModels,
			sampleModels,
			{author}
		},
		{
			storageConditionFields,
			modelReferenceElectrodeFields,
			modelSampleFields,
			{
				FinancingTeams[Notebooks][Object],
				SharingTeams[Notebooks][Object]
			}
		},
		Cache -> inheritedCache,
		Date -> Now
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	cacheBall = FlattenCachePackets[
		{
			inheritedCache,
			storageModelPackets,
			referenceElectrodeModelPackets,
			sampleModelPackets
		}
	];

	(* flatten out the notebooks; we will use these when generating the Result to look for AlternativePreparations *)
	authorNotebooks = DeleteDuplicates[Cases[Flatten[notebookDownload], ObjectReferenceP[Object[LaboratoryNotebook]]]];

	(* --------------------- *)
	(* -- Resolve Options -- *)
	(* --------------------- *)

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveUploadReferenceElectrodeOptions[myTemplateReferenceElectrodeModel, safeOptions, Cache -> cacheBall, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {resolveUploadReferenceElectrodeOptions[myTemplateReferenceElectrodeModel, safeOptions, Cache -> cacheBall],{}},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* ------------------------ *)
	(* -- Output Preparation -- *)
	(* ------------------------ *)

	(* gather all the tests we've generated together *)
	allTests = Join[safeOptionTests, objectsExistTests, resolvedOptionsTests];

	(* run the tests that we have generated to make sure we can go on *)
	allTestTestResults=If[gatherTests,
		RunUnitTest[<|"Tests" -> allTests|>,OutputFormat->SingleBoolean,Verbose->False],
		MatchQ[resolvedOptionsResult,Except[$Failed]]
	];

	(* prepare the options return rule; no index-matched options currently, so don't bother collapsing *)
	optionsRule = Options -> If[MemberQ[listedOutput, Options],
		RemoveHiddenOptions[UploadReferenceElectrodeModel, resolvedOptions],
		Null
	];

	(* function doesn't have a preview *)
	previewRule = Preview -> Null;

	(* accrue all of the Tests we generated *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* prepare the Result rule if asked; do not bother if we hit a failure on any of our above checks *)
	resultRule=Result->If[MemberQ[listedOutput,Result],
		If[Not[TrueQ[allTestTestResults]],
			$Failed,
			newReferenceElectrodeModel[
				!MatchQ[Lookup[resolvedOptions, Name], _String],
				author,
				authorNotebooks,
				resolvedOptions
			]
		],
		Null
	];

	(* return the requested outputs per the non-listed Output option *)
	outputSpecification /. {optionsRule, previewRule, testsRule, resultRule}
];


(* ::Subsubsection::Closed:: *)
(*UploadReferenceElectrodeModelOptions*)


DefineOptions[UploadReferenceElectrodeModelOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>(Table|List)],
			Description->"Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions:>{UploadReferenceElectrodeModel}
];

(* === OVERLOAD 1: Without Input templateReferenceElectrodeModel Overload === *)
UploadReferenceElectrodeModelOptions[myOptions:OptionsPattern[UploadReferenceElectrodeModelOptions]]:=Module[
	{listedOptions,optionsWithoutOutput,resolvedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadReferenceElectrodeModel options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved optinos *)
	resolvedOptions=UploadReferenceElectrodeModel[Append[optionsWithoutOutput,Output->Options]];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions failed *)
	If[MatchQ[resolvedOptions,$Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[resolvedOptions,UploadReferenceElectrodeModel],
			resolvedOptions
		]
	]
];

(* === OVERLOAD 2: Single Input templateReferenceElectrodeModels Overload === *)
UploadReferenceElectrodeModelOptions[
	myTemplateReferenceElectrodeModel:ObjectP[Model[Item, Electrode, ReferenceElectrode]],
	myOptions:OptionsPattern[UploadReferenceElectrodeModelOptions]
]:=Module[
	{listedOptions,optionsWithoutOutput,resolvedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadReferenceElectrodeModel options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved options *)
	resolvedOptions=UploadReferenceElectrodeModel[myTemplateReferenceElectrodeModel,Append[optionsWithoutOutput,Output->Options]];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions failed *)
	If[MatchQ[resolvedOptions,$Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[resolvedOptions,UploadReferenceElectrodeModel],
			resolvedOptions
		]
	]
];

(* ::Subsubsection::Closed:: *)
(*ValidUploadReferenceElectrodeModelQ*)


DefineOptions[ValidUploadReferenceElectrodeModelQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{UploadReferenceElectrodeModel}
];

(* === OVERLOAD 1: Without Input templateReferenceElectrodeModel Overload === *)
ValidUploadReferenceElectrodeModelQ[myOptions:OptionsPattern[ValidUploadReferenceElectrodeModelQ]]:=Module[
	{listedOptions,optionsWithoutOutput,tests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadReferenceElectrodeModel options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)|(Verbose->_)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests=UploadReferenceElectrodeModel[Append[optionsWithoutOutput,Output->Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadReferenceElectrodeModelQ"->tests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidUploadReferenceElectrodeModelQ"]
];

(* === OVERLOAD 2: Single Input templateReferenceElectrodeModels Overload === *)
ValidUploadReferenceElectrodeModelQ[
	myTemplateReferenceElectrodeModel:ObjectP[Model[Item, Electrode, ReferenceElectrode]],
	myOptions:OptionsPattern[ValidUploadReferenceElectrodeModelQ]
]:=Module[
	{listedOptions,optionsWithoutOutput,tests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadReferenceElectrodeModel options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions,(OutputFormat->_)|(Output->_)|(Verbose->_)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests=UploadReferenceElectrodeModel[myTemplateReferenceElectrodeModel, Append[optionsWithoutOutput,Output->Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadReferenceElectrodeModelQ"->tests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidUploadReferenceElectrodeModelQ"]
];


(* ::Subsubsection::Closed:: *)
(*resolveUploadReferenceElectrodeOptions*)

DefineOptions[
	resolveUploadReferenceElectrodeOptions,
	Options :> {HelperOutputOption, CacheOption}
];

resolveUploadReferenceElectrodeOptions[
	myTemplateReferenceElectrodeModel:ObjectP[Model[Item, Electrode, ReferenceElectrode]]|None,
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveUploadReferenceElectrodeOptions]
]:=Module[
	{
		(* == Initialization == *)
		outputSpecification, output, gatherTests, messages, inheritedCache, templateReferenceElectrodeModelPacket, optionsAssociation,

		(* == Invalid inputs check == *)
		templateDeprecated, templateDeprecatedTests, templateDeprecatedInvalidInputs,

		(* == Option rounding == *)
		optionPrecisions, precisionTests, roundedOptions,

		(* == Options lookup == *)
		name, synonyms, referenceElectrodeType, blank, recommendedSolventType, referenceSolution, referenceCouplingSample, solutionVolume, recommendedRefreshPeriod, defaultStorageCondition, preparable, price,

		dimensions, bulkMaterial, coatMaterial, electrodeShape, electrodePackagingMaterial, wiringConnectors, wiringDiameters, wiringLength, minPotential, maxPotential, maxNumberOfUses, maxNumberOfPolishings, sonicationSensitive, wettedMaterials, incompatibleMaterials,

		(* == Resolved options and help variables == *)
		resolvedReferenceElectrodeType, resolvedBlank, blankModelPacket, resolvedRecommendedSolventType, resolvedReferenceSolution, referenceSolutionSolventMolecule, referenceSolutionAnalyteMolecule, referenceSolutionAnalyteMoleculeConcentration, referenceSolutionAnalyteMoleculeDefaultSampleModel, resolvedPreparable, resolvedReferenceCouplingSample, referenceCouplingSampleCheckingOutput, referenceCouplingSampleAnalyteMolecule, resolvedRecommendedRefreshPeriod, referenceSolutionDefaultStorageCondition, resolvedDefaultStorageCondition,

		(* Physical parameters *)
		resolvedSolutionVolume, resolvedDimensions, resolvedBulkMaterial, resolvedCoatMaterial, resolvedElectrodeShape, resolvedElectrodePackagingMaterial, resolvedWiringConnectors, resolvedWiringDiameters, resolvedWiringLength, resolvedMaxNumberOfUses, resolvedMinPotential, resolvedMaxPotential, resolvedMaxNumberOfPolishings, resolvedSonicationSensitive, resolvedWettedMaterials, resolvedIncompatibleMaterials, equalFields, lessEqualFields, greaterEqualFields, inconsistencyCheckPacket, inconsistencyCheckResult, safeWettedMaterials, safeIncompatibleMaterials, resolvedSynonyms, safeSynonyms,

		(* == Error and warning checking booleans == *)
		referenceElectrodeTypeUnresolvableBool, blankModelNotBareTypeBool, referenceElectrodeTypeSameWithBlankModelBool, referenceElectrodeTypeInvalidForBlankModelBool, referenceElectrodeTypeInvalidForNonBlankModelBool, nonNullRecommendedSolventTypeBool, missingRecommendedSolventTypeBool, nullPriceBool,

		(* reference solution related *)
		referenceSolutionLessThanTwoComponentsBool, referenceSolutionMissingSolventBool, referenceSolutionSolventSampleAmbiguousMoleculeBool, referenceSolutionMissingAnalyteBool, referenceSolutionAmbiguousAnalyteBool, referenceSolutionAnalyteMoleculeMissingDefaultSampleModelBool, nonNullReferenceSolutionBool, missingReferenceSolutionBool, mismatchingSolventTypeWarningBool,

		(* reference coupling sample related *)
		nonNullReferenceCouplingSampleForBlankModelBool, nonNullReferenceCouplingSampleForPseudoModelBool, missingReferenceCouplingSampleBool, referenceCouplingSampleMissingAnalyteBool, referenceCouplingSampleAmbiguousAnalyteBool, mismatchingReferenceCouplingSampleMoleculeBool,

		nonNullRecommendedRefreshPeriodBool, missingRecommendedRefreshPeriodBool, nameExistingBool, mismatchingDefaultStorageConditionBool,

		(* Physical parameters errors *)
		solutionVolumeUnResolvableBool, dimensionsUnResolvableBool, bulkMaterialUnResolvableBool, coatMaterialUnResolvableBool, electrodeShapeUnResolvableBool, wiringConnectorsUnResolvableBool, maxNumberOfUsesUnResolvableBool, minPotentialUnResolvableBool, maxPotentialUnResolvableBool, sonicationSensitiveUnResolvableBool,

		conflictingSolutionVolumeBool, conflictingDimensionsBool, conflictingBulkMaterialBool, conflictingCoatMaterialBool, conflictingElectrodeShapeBool, conflictingElectrodePackagingMaterialBool, conflictingWiringConnectorsBool, conflictingWiringDiametersBool, conflictingWiringLengthBool, conflictingSonicationSensitiveBool, conflictingWettedMaterialsBool, conflictingMaxNumberOfUsesBool, conflictingMaxNumberOfPolishingsBool, conflictingMaxPotentialBool, conflictingMinPotentialBool,

		wiringParametersMismatchLengthsBool, nonNullWiringDiameterWiringConnectors, missingWiringDiameterWiringConnectors, nonNullWiringDiameterForNonExposedWireBool, missingWiringDiameterForExposedWireBool,

		maxNumberOfPolishingsGreaterThanMaxNumberOfUsesBool, wettedMaterialsNotContainCoatMaterialBool, wettedMaterialsNotContainBulkMaterialBool, wettedMaterialsNotContainElectrodePackagingMaterialBool, incompatibleMaterialsContainCoatMaterialBool, incompatibleMaterialsContainBulkMaterialBool, incompatibleMaterialsContainElectrodePackagingMaterialBool,

		(* == InvalidOptions == *)
		blankInvalidOptions, referenceElectrodeTypeInvalidOptions, recommendedSolventTypeInvalidOptions, referenceSolutionInvalidOptions, priceInvalidOptions, referenceCouplingSampleInvalidOptions, recommendedRefreshPeriodInvalidOptions, nameInvalidOptions, defaultStorageConditionInvalidOptions, solutionVolumeInvalidOptions, dimensionsInvalidOptions, bulkMaterialInvalidOptions, coatMaterialInvalidOptions, electrodeShapeInvalidOptions, electrodePackagingMaterialInvalidOptions, wiringConnectorsInvalidOptions, wiringDiametersInvalidOptions, wiringLengthInvalidOptions, maxNumberOfUsesInvalidOptions, minPotentialInvalidOptions, maxPotentialInvalidOptions, maxNumberOfPolishingsInvalidOptions, sonicationSensitiveInvalidOptions, wettedMaterialsInvalidOptions, incompatibleMaterialsInvalidOptions,

		(* == Output == *)
		resolvedOptionsAssociations, resolvedOptionTests, invalidInputs, invalidOptions, uploadReferenceElectrodeModelTests, resolvedOptions
	},

	(* ---------------------------------------------- *)
	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* ---------------------------------------------- *)

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];

	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];

	(* Fetch the templateReferenceElectrodeModelPacket *)
	templateReferenceElectrodeModelPacket = If[MatchQ[myTemplateReferenceElectrodeModel, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
		fetchPacketFromCache[Download[myTemplateReferenceElectrodeModel, Object], inheritedCache],
		Null
	];

	optionsAssociation = Association[myOptions];

	(* ----------------------------- *)
	(* -- INPUT VALIDATION CHECKS -- *)
	(* ----------------------------- *)

	(* --- Check if the input template reference electrode model is deprecated --- *)

	{templateDeprecated, templateDeprecatedTests} = If[MatchQ[templateReferenceElectrodeModelPacket, PacketP[]],

		(* If there is an input template reference electrode model, we continue *)
		Module[{deprecatedBool, test},

			(* determine indeed if it is *)
			deprecatedBool = TrueQ[Lookup[templateReferenceElectrodeModelPacket, Deprecated]];

			(* make a test for it *)
			test = If[gatherTests,
				Test["Template reference electrode model input " <> ToString[myTemplateReferenceElectrodeModel] <> " is active (not deprecated).",
					deprecatedBool,
					False
				],
				Nothing
			];

			(* throw a message if not test *)
			If[!gatherTests && deprecatedBool,
				Message[Error::UREDeprecatedTemplateReferenceElectrodeModel, myTemplateReferenceElectrodeModel];
				Message[Error::InvalidInput, myTemplateReferenceElectrodeModel]
			];

			(* return bool, test *)
			{deprecatedBool, {test}}
		],

		(* If there is no input template reference electrode model, we do nothing *)
		{False, {}}
	];

	(* gather the invalid inputs *)
	templateDeprecatedInvalidInputs = If[MatchQ[templateDeprecatedTests, True],
		{myTemplateReferenceElectrodeModel},
		{}
	];

	(* -------------- *)
	(* -- ROUNDING -- *)
	(* -------------- *)

	(* gather option precisions *)
	optionPrecisions = {
		{RecommendedRefreshPeriod, 10^0 * Month},
		{SolutionVolume, 10^-1 * Milliliter},
		{Dimensions, 10^-1 * Millimeter},
		{WiringLength, 10^-1 * Millimeter},
		{WiringDiameters, 10^-1 * Millimeter},
		{MinPotential, 10^0 * Millivolt},
		{MaxPotential, 10^0 * Millivolt}
	};

	(* big round call on the joined lists of all roundable options *)
	{
		roundedOptions,
		precisionTests
	} = If[gatherTests,
		RoundOptionPrecision[optionsAssociation, optionPrecisions[[All,1]], optionPrecisions[[All,2]], Output -> {Result, Tests}],
		{
			RoundOptionPrecision[optionsAssociation,  optionPrecisions[[All,1]], optionPrecisions[[All,2]]],
			{}
		}
	];

	(* ------------- *)
	(* -- RESOLVE -- *)
	(* ------------- *)

	(* Only one input, no need to MapThread *)

	(* == Look up options values == *)
	(* Non-physical parameters *)
	{
		name,
		synonyms,
		referenceElectrodeType,
		blank,
		recommendedSolventType,
		referenceSolution,
		referenceCouplingSample,
		solutionVolume,
		recommendedRefreshPeriod,
		defaultStorageCondition,
		preparable,
		price
	} = Lookup[roundedOptions,
		{
			Name,
			Synonyms,
			ReferenceElectrodeType,
			Blank,
			RecommendedSolventType,
			ReferenceSolution,
			ReferenceCouplingSample,
			SolutionVolume,
			RecommendedRefreshPeriod,
			DefaultStorageCondition,
			Preparable,
			Price
		}
	];

	(* Physical parameters *)
	{
		dimensions,
		bulkMaterial,
		coatMaterial,
		electrodeShape,
		electrodePackagingMaterial,
		wiringConnectors,
		wiringDiameters,
		wiringLength,
		minPotential,
		maxPotential,
		maxNumberOfUses,
		maxNumberOfPolishings,
		sonicationSensitive,
		wettedMaterials,
		incompatibleMaterials
	} = Lookup[roundedOptions,
		{
			Dimensions,
			BulkMaterial,
			CoatMaterial,
			ElectrodeShape,
			ElectrodePackagingMaterial,
			WiringConnectors,
			WiringDiameters,
			WiringLength,
			MinPotential,
			MaxPotential,
			MaxNumberOfUses,
			MaxNumberOfPolishings,
			SonicationSensitive,
			WettedMaterials,
			IncompatibleMaterials
		}
	];

	(* == We have collected myTemplateReferenceElectrodeModel previously == *)

	(* == Resolve ReferenceElectrodeType == *)
	resolvedReferenceElectrodeType = If[MatchQ[templateReferenceElectrodeModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],

		(* If myTemplateReferenceElectrodeModel is provided, resolve Automatic ReferenceElectrodeType to the ReferenceElectrodeType field of myTemplateReferenceElectrodeModel *)
		referenceElectrodeType /. {Automatic -> Lookup[templateReferenceElectrodeModelPacket, ReferenceElectrodeType]},

		(* If myTemplateReferenceElectrodeModel is not provided, resolve Automatic ReferenceElectrodeType Null *)
		referenceElectrodeType /. {Automatic -> Null}
	];

	(* -- Check if ReferenceElectrodeType can be resolved -- *)
	referenceElectrodeTypeUnresolvableBool = Not[MatchQ[resolvedReferenceElectrodeType, ReferenceElectrodeTypeP]];

	(* NOTE: we are collecting the tests (resolvedOptionTests) and throwing the messages after all the options are resolved *)

	(* == Resolve Blank == *)
	resolvedBlank = If[MatchQ[templateReferenceElectrodeModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],

		(* If myTemplateReferenceElectrodeModel is provided, resolve Automatic Blank to the Blank field of myTemplateReferenceElectrodeModel *)
		blank /. {Automatic -> Lookup[templateReferenceElectrodeModelPacket, Blank]},

		(* If myTemplateReferenceElectrodeModel is not provided, resolve Automatic Blank to Bare-Ag *)
		blank /. {Automatic -> Model[Item, Electrode, ReferenceElectrode, "IKA Bare Silver Wire Reference Electrode"]}
	] /. {x:ObjectP[] :> Download[x, Object]};

	(* If resolvedBlank is a model, gather its packet *)
	blankModelPacket = If[MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
		fetchPacketFromCache[Download[resolvedBlank, Object], inheritedCache],
		Null
	];

	(* Check if the resolvedBlank's ReferenceElectrodeType is Bare *)
	blankModelNotBareTypeBool = If[
		And[
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			!StringContainsQ[Lookup[blankModelPacket, ReferenceElectrodeType], "Bare", IgnoreCase -> True]
		],
		True,
		False
	];

	(* Collect the Blank invalidOptions *)
	blankInvalidOptions = If[
		MemberQ[
			{
				blankModelNotBareTypeBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{Blank},
		{}
	];

	(* Check if the resolvedReferenceElectrodeType is the same with the Blank's ReferenceElectrodeType *)
	referenceElectrodeTypeSameWithBlankModelBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			MatchQ[resolvedReferenceElectrodeType, Lookup[blankModelPacket, ReferenceElectrodeType]]
		],
		True,
		False
	];

	(* Check if resolvedReferenceElectrodeType does not contain "Bare" (which indicates a Blank model) when resolvedBlank is Null *)
	referenceElectrodeTypeInvalidForBlankModelBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[referenceElectrodeTypeSameWithBlankModelBool, False],
			MatchQ[resolvedBlank, Null],
			!StringContainsQ[resolvedReferenceElectrodeType, "Bare", IgnoreCase -> True]
		],
		True,
		False
	];

	(* Check if resolvedReferenceElectrodeType contains "Bare" (which indicates a Blank model) when resolvedBlank is not Null *)
	referenceElectrodeTypeInvalidForNonBlankModelBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[referenceElectrodeTypeSameWithBlankModelBool, False],
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			StringContainsQ[resolvedReferenceElectrodeType, "Bare", IgnoreCase -> True]
		],
		True,
		False
	];

	(* Collect the ReferenceElectrodeType invalidOptions *)
	referenceElectrodeTypeInvalidOptions = If[
		MemberQ[
			{
				referenceElectrodeTypeUnresolvableBool,
				referenceElectrodeTypeSameWithBlankModelBool,
				referenceElectrodeTypeInvalidForBlankModelBool,
				referenceElectrodeTypeInvalidForNonBlankModelBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{ReferenceElectrodeType},
		{}
	];

	(* == Resolve RecommendedSolventType == *)
	resolvedRecommendedSolventType = If[MatchQ[templateReferenceElectrodeModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],

		(* If a template model is provided *)
		recommendedSolventType /. {Automatic -> Lookup[templateReferenceElectrodeModelPacket, RecommendedSolventType]},

		(* If no template model is provided, we check the Blank *)
		If[MatchQ[blankModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],
			(* If a Blank is provided, we set the Automatic RecommendedSolventType to Organic *)
			recommendedSolventType /. {Automatic -> Organic},

			(* If no Blank is provided, we set the Automatic RecommendedSolventType to Null  *)
			recommendedSolventType /. {Automatic -> Null}
		]
	];

	(* Check if the resolvedRecommendedSolventType is defined for a blank model *)
	nonNullRecommendedSolventTypeBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, Null],
			!MatchQ[resolvedRecommendedSolventType, Null]
		],
		True,
		False
	];

	(* Check if the resolvedRecommendedSolventType is Null for a non-blank model *)
	missingRecommendedSolventTypeBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			!MatchQ[resolvedRecommendedSolventType, (Organic | Aqueous)]
		],
		True,
		False
	];

	(* Collect the RecommendedSolventType invalidOptions *)
	recommendedSolventTypeInvalidOptions = If[
		MemberQ[
			{
				nonNullRecommendedSolventTypeBool,
				missingRecommendedSolventTypeBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{RecommendedSolventType},
		{}
	];

	(* == Resolve ReferenceSolution == *)
	resolvedReferenceSolution = If[MatchQ[templateReferenceElectrodeModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],

		(* If a template model is provided *)
		referenceSolution /. {Automatic -> Lookup[templateReferenceElectrodeModelPacket, ReferenceSolution]},

		(* If no template model is provided, we check the Blank *)
		If[MatchQ[blankModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],

			(* If a Blank is provided, check the resolvedRecommendedSolventType *)
			If[MatchQ[resolvedRecommendedSolventType, Aqueous],
				(* If resolvedRecommendedSolventType is Aqueous, we set the Automatic ReferenceSolution to Model[Sample, StockSolution, "3M KCl Aqueous Solution, 10 mL"] *)
				referenceSolution /. {Automatic -> Model[Sample, StockSolution, "3M KCl Aqueous Solution, 10 mL"]},

				(* If resolvedRecommendedSolventType is Organic, we set the Automatic ReferenceSolution to Model[Sample, StockSolution, "0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"] *)
				referenceSolution /. {Automatic -> Model[Sample, StockSolution, "0.1M AgNO3 0.1M [NBu4][PF6] in acetonitrile, 10 mL"]}
			],

			(* If no Blank is provided, we set the Automatic ReferenceSolution to Null  *)
			referenceSolution /. {Automatic -> Null}
		]
	] /. {x:ObjectP[] :> Download[x, Object]};

	(* -- ReferenceSolution field checks using the checkReferenceSolutionValidity helper function -- *)
	{
		referenceSolutionSolventMolecule,
		referenceSolutionAnalyteMolecule,
		referenceSolutionAnalyteMoleculeConcentration,
		referenceSolutionAnalyteMoleculeDefaultSampleModel,
		referenceSolutionLessThanTwoComponentsBool,
		referenceSolutionMissingSolventBool,
		referenceSolutionSolventSampleAmbiguousMoleculeBool,
		referenceSolutionMissingAnalyteBool,
		referenceSolutionAmbiguousAnalyteBool,
		referenceSolutionAnalyteMoleculeMissingDefaultSampleModelBool
	} = If[MatchQ[resolvedReferenceSolution, ObjectP[Model[Sample]]],

		(* If the resolvedReferenceSolution is not Null *)
		checkReferenceSolutionValidity[resolvedReferenceSolution, inheritedCache],

		(* If the resolvedReferenceSolution is Null, we do nothing and set variables to Null and booleans to False *)
		Join[{Null, Null, Null, Null}, ConstantArray[False, 6]]
	];

	(* Check if the resolvedReferenceSolution is defined for a blank model *)
	nonNullReferenceSolutionBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, Null],
			!MatchQ[resolvedReferenceSolution, Null]
		],
		True,
		False
	];

	(* Check if the resolvedReferenceSolution is Null for a non-blank model *)
	missingReferenceSolutionBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			!MatchQ[resolvedReferenceSolution, ObjectP[Model[Sample]]]
		],
		True,
		False
	];

	(* Check if the solvent type of the reference solution and the RecommendedSolventType match. This is a warning, not an error *)
	mismatchingSolventTypeWarningBool = If[
		And[
			MatchQ[referenceSolutionSolventMolecule, ObjectP[Model[Molecule]]],
			MatchQ[resolvedRecommendedSolventType, (Aqueous|Organic)],
			MatchQ[nonNullReferenceSolutionBool, False],
			MatchQ[missingReferenceSolutionBool, False]
		],

		(* If the prerequisites are met, we compare the referenceSolutionSolventMolecule and resolvedRecommendedSolventType *)
		Which[

			(* If resolvedRecommendedSolventType is Aqueous but the referenceSolutionSolventMolecule is not water, set this warning to True *)
			MatchQ[resolvedRecommendedSolventType, Aqueous] && !MatchQ[referenceSolutionSolventMolecule, Model[Molecule, "id:vXl9j57PmP5D"]],
			True,

			(* If resolvedRecommendedSolventType is Organic but the referenceSolutionSolventMolecule is water, set this warning to True *)
			MatchQ[resolvedRecommendedSolventType, Organic] && MatchQ[referenceSolutionSolventMolecule, Model[Molecule, "id:vXl9j57PmP5D"]],
			True,

			(* For all other cases, set this warning to False *)
			True,
			False
		],

		(* If the prerequisites are not met, we set this error to False *)
		False
	];

	(* Collect the ReferenceSolution invalidOptions *)
	referenceSolutionInvalidOptions = If[
		MemberQ[
			{
				referenceSolutionLessThanTwoComponentsBool,
				referenceSolutionMissingSolventBool,
				referenceSolutionSolventSampleAmbiguousMoleculeBool,
				referenceSolutionMissingAnalyteBool,
				referenceSolutionAmbiguousAnalyteBool,
				referenceSolutionAnalyteMoleculeMissingDefaultSampleModelBool,
				nonNullReferenceSolutionBool,
				missingReferenceSolutionBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{ReferenceSolution},
		{}
	];

	(* At this point, we can resolve Preparable *)
	(* == Resolve Preparable == *)
	resolvedPreparable = If[
		And[
			MatchQ[blankModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],
			MatchQ[resolvedReferenceSolution, ObjectP[Model[Sample]]],
			MatchQ[Lookup[fetchPacketFromCache[resolvedReferenceSolution, inheritedCache], Preparable], True]
		],

		(* If the reference electrode model has a Blank and the reference solution is preparable, set Automatic Preparable to True *)
		preparable /. {Automatic -> True},

		(* Otherwise, set Automatic Preparable to False *)
		preparable /. {Automatic -> False}
	];

	(* == Check Price (we can't really automatically resolve this and it has be explicitly set) == *)
	nullPriceBool = If[
		And[
			MatchQ[$Notebook, Null],
			MatchQ[resolvedPreparable, True],
			MatchQ[price, Null]
		],
		(* If we do not have a notebook now and the resolvedPreparable is True, we force the Price to be not Null *)
		True,

		(* Otherwise we don't care about Price *)
		False
	];

	(* Collect the Price invalidOptions *)
	priceInvalidOptions = If[
		MemberQ[
			{
				nullPriceBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{Price},
		{}
	];

	(* == Resolve ReferenceCouplingSample == *)
	resolvedReferenceCouplingSample = If[MatchQ[templateReferenceElectrodeModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],

		(* If a template model is provided *)
		referenceCouplingSample /. {Automatic -> Lookup[templateReferenceElectrodeModelPacket, ReferenceCouplingSample]},

		(* If no template model is provided, we check the Blank *)
		If[MatchQ[blankModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],

			(* If a Blank is provided, check the resolvedReferenceSolution and referenceSolutionAnalyteMoleculeDefaultSampleModel *)
			If[
				And[
					MatchQ[resolvedReferenceSolution, ObjectP[Model[Sample]]],
					MatchQ[referenceSolutionAnalyteMoleculeDefaultSampleModel, ObjectP[Model[Sample]]]
				],

				(* If resolvedReferenceSolution and referenceSolutionAnalyteMoleculeDefaultSampleModel are valid samples, we check if the resolvedReferenceElectrodeType is a Pseudo type *)

				If[MatchQ[referenceElectrodeTypeUnresolvableBool, False] && StringContainsQ[resolvedReferenceElectrodeType, "Pseudo", IgnoreCase -> True],

					(* If resolvedReferenceElectrodeType is a Pseudo type, set the Automatic ReferenceCouplingSample to Null *)
					referenceCouplingSample /. {Automatic -> Null},

					(* If resolvedReferenceElectrodeType is a Pseudo type, set the Automatic ReferenceCouplingSample to Null *)
					referenceCouplingSample /. {Automatic -> referenceSolutionAnalyteMoleculeDefaultSampleModel}
				],

				(* Otherwise set the Automatic ReferenceCouplingSample to Null *)
				referenceCouplingSample /. {Automatic -> Null}
			],

			(* If no Blank is provided, we set the Automatic ReferenceCouplingSample to Null  *)
			referenceCouplingSample /. {Automatic -> Null}
		]
	] /. {x:ObjectP[] :> Download[x, Object]};

	(* Check if the resolvedReferenceCouplingSample is defined for a blank model *)
	nonNullReferenceCouplingSampleForBlankModelBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, Null],
			!MatchQ[resolvedReferenceCouplingSample, Null]
		],
		True,
		False
	];

	(* Check if the resolvedReferenceCouplingSample is defined for a pseudo model *)
	nonNullReferenceCouplingSampleForPseudoModelBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			StringContainsQ[resolvedReferenceElectrodeType, "Pseudo", IgnoreCase -> True]
		],
		True,
		False
	];

	(* Check if the resolvedReferenceCouplingSample is Null for a non-blank and non-pseudo model *)
	missingReferenceCouplingSampleBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			MatchQ[referenceSolutionMissingAnalyteBool, False],
			MatchQ[referenceSolutionAmbiguousAnalyteBool, False],
			MatchQ[referenceSolutionAnalyteMoleculeMissingDefaultSampleModelBool, False],
			!StringContainsQ[resolvedReferenceElectrodeType, "Pseudo", IgnoreCase -> True],
			!MatchQ[resolvedReferenceCouplingSample, ObjectP[Model[Sample]]]
		],
		True,
		False
	];

	(* Use the checkReferenceSolutionValidity helper function (ignoring irrelevant errors) to look into the resolvedReferenceCouplingSample and check its analytes *)
	referenceCouplingSampleCheckingOutput = If[MatchQ[resolvedReferenceCouplingSample, ObjectP[Model[Sample]]],

		(* If the resolvedReferenceCouplingSample is not Null *)
		checkReferenceSolutionValidity[resolvedReferenceCouplingSample, inheritedCache],

		(* If the resolvedReferenceCouplingSample is Null, we do nothing and set variables to Null and booleans to False *)
		Join[{Null, Null, Null, Null}, ConstantArray[False, 6]]
	];

	(* get out the variables and booleans *)
	referenceCouplingSampleAnalyteMolecule = referenceCouplingSampleCheckingOutput[[2]];
	referenceCouplingSampleMissingAnalyteBool = referenceCouplingSampleCheckingOutput[[8]];
	referenceCouplingSampleAmbiguousAnalyteBool = referenceCouplingSampleCheckingOutput[[9]];

	(* Check if the referenceCouplingSampleAnalyteMolecule is the same with the referenceSolutionAnalyteMolecule *)
	mismatchingReferenceCouplingSampleMoleculeBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			MatchQ[referenceSolutionMissingAnalyteBool, False],
			MatchQ[referenceSolutionAmbiguousAnalyteBool, False],
			MatchQ[referenceSolutionAnalyteMoleculeMissingDefaultSampleModelBool, False],
			!StringContainsQ[resolvedReferenceElectrodeType, "Pseudo", IgnoreCase -> True],
			MatchQ[referenceSolutionAnalyteMolecule, ObjectP[Model[Molecule]]],
			MatchQ[referenceCouplingSampleAnalyteMolecule, ObjectP[Model[Molecule]]],
			!MatchQ[referenceSolutionAnalyteMolecule, referenceCouplingSampleAnalyteMolecule]
		],
		True,
		False
	];

	(* Collect the ReferenceCouplingSample invalidOptions *)
	referenceCouplingSampleInvalidOptions = If[
		MemberQ[
			{
				nonNullReferenceCouplingSampleForBlankModelBool,
				nonNullReferenceCouplingSampleForPseudoModelBool,
				missingReferenceCouplingSampleBool,
				referenceCouplingSampleAmbiguousAnalyteBool,
				mismatchingReferenceCouplingSampleMoleculeBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{ReferenceCouplingSample},
		{}
	];

	(* == Resolve RecommendedRefreshPeriod == *)
	resolvedRecommendedRefreshPeriod = If[MatchQ[templateReferenceElectrodeModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],

		(* If a template model is provided *)
		recommendedRefreshPeriod /. {Automatic -> Lookup[templateReferenceElectrodeModelPacket, RecommendedRefreshPeriod]},

		(* If no template model is provided, we check the Blank *)
		If[MatchQ[blankModelPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],
			(* If a Blank is provided, we set the Automatic RecommendedRefreshPeriod to Organic *)
			recommendedRefreshPeriod /. {Automatic -> 2 Month},

			(* If no Blank is provided, we set the Automatic RecommendedRefreshPeriod to Null  *)
			recommendedRefreshPeriod /. {Automatic -> Null}
		]
	];

	(* Check if the resolvedRecommendedRefreshPeriod is defined for a blank model *)
	nonNullRecommendedRefreshPeriodBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, Null],
			!MatchQ[resolvedRecommendedRefreshPeriod, Null]
		],
		True,
		False
	];

	(* Check if the resolvedRecommendedRefreshPeriod is Null for a non-blank model *)
	missingRecommendedRefreshPeriodBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			!MatchQ[resolvedRecommendedRefreshPeriod, TimeP]
		],
		True,
		False
	];

	(* Collect the RecommendedRefreshPeriod invalidOptions *)
	recommendedRefreshPeriodInvalidOptions = If[
		MemberQ[
			{
				nonNullRecommendedRefreshPeriodBool,
				missingRecommendedRefreshPeriodBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{RecommendedRefreshPeriod},
		{}
	];

	(* == Resolve DefaultStorageCondition == *)
	(* -- Retrieve the DefaultStorageCondition of the ReferenceSolution first -- *)
	referenceSolutionDefaultStorageCondition = If[MatchQ[resolvedReferenceSolution, ObjectP[Model[Sample]]],

		(* If resolvedReferenceSolution is not Null, get this from the cache *)
		Lookup[fetchPacketFromCache[resolvedReferenceSolution, inheritedCache], DefaultStorageCondition],

		(* If resolvedReferenceSolution is Null, set this to Null as well *)
		Null
	] /. {x:ObjectP[] :> Download[x, Object]};

	(* For the AmbientStorage expression, replace it with the Ambient Storage Model *)
	resolvedDefaultStorageCondition = If[MatchQ[referenceSolutionDefaultStorageCondition, ObjectP[Model[StorageCondition]]],

		(* If we have a referenceSolutionDefaultStorageCondition, set Automatic DefaultStorageCondition to referenceSolutionDefaultStorageCondition *)
		defaultStorageCondition /. {Automatic -> referenceSolutionDefaultStorageCondition, AmbientStorage -> Model[StorageCondition, "id:7X104vnR18vX"]},

		(* If we do not have a referenceSolutionDefaultStorageCondition, set Automatic DefaultStorageCondition to the Ambient Storage Model *)
		defaultStorageCondition /. {Automatic -> Model[StorageCondition, "id:7X104vnR18vX"], AmbientStorage -> Model[StorageCondition, "id:7X104vnR18vX"]}
	];

	(* Check if the resolvedDefaultStorageCondition is matches with referenceSolutionDefaultStorageCondition *)
	mismatchingDefaultStorageConditionBool = If[
		And[
			MatchQ[referenceElectrodeTypeUnresolvableBool, False],
			MatchQ[resolvedBlank, ObjectP[Model[Item, Electrode, ReferenceElectrode]]],
			MatchQ[referenceSolutionDefaultStorageCondition, ObjectP[Model[StorageCondition]]],
			!MatchQ[resolvedDefaultStorageCondition, referenceSolutionDefaultStorageCondition]
		],
		True,
		False
	];

	(* Collect the DefaultStorageCondition invalidOptions *)
	defaultStorageConditionInvalidOptions = If[
		MemberQ[
			{
				mismatchingDefaultStorageConditionBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{DefaultStorageCondition},
		{}
	];

	(* == Resolve Physical Parameters using the helper functions == *)

	(* == Replace the Automatic options from templateReferenceElectrodeModel, and if templateReferenceElectrodeModel is not provided, replace the Automatic options from blankModel == *)
	{
		(* Physical parameters *)
		resolvedSolutionVolume,
		resolvedDimensions,
		resolvedBulkMaterial,
		resolvedCoatMaterial,
		resolvedElectrodeShape,
		resolvedElectrodePackagingMaterial,
		resolvedWiringConnectors,
		resolvedWiringDiameters,
		resolvedWiringLength,
		resolvedMaxNumberOfUses,
		resolvedMinPotential,
		resolvedMaxPotential,
		resolvedMaxNumberOfPolishings,
		resolvedSonicationSensitive,
		resolvedWettedMaterials,
		resolvedIncompatibleMaterials
	} = replacePhysicalParameterOptions[
		{
			solutionVolume,
			dimensions,
			bulkMaterial,
			coatMaterial,
			electrodeShape,
			electrodePackagingMaterial,
			wiringConnectors,
			wiringDiameters,
			wiringLength,
			maxNumberOfUses,
			minPotential,
			maxPotential,
			maxNumberOfPolishings,
			sonicationSensitive,
			wettedMaterials,
			incompatibleMaterials
		},
		{
			(* Physical parameters *)
			SolutionVolume,
			Dimensions,
			BulkMaterial,
			CoatMaterial,
			ElectrodeShape,
			ElectrodePackagingMaterial,
			WiringConnectors,
			WiringDiameters,
			WiringLength,
			MaxNumberOfUses,
			MinPotential,
			MaxPotential,
			MaxNumberOfPolishings,
			SonicationSensitive,
			WettedMaterials,
			IncompatibleMaterials
		},
		templateReferenceElectrodeModelPacket, blankModelPacket];

	(* -- Check if any of the physical parameters (except for the WettedMaterials and IncompatibleMaterials, since they may be resolvable later) are unresolvable, and they are still Automatic: Replace at level 1 -- *)
	{
		solutionVolumeUnResolvableBool,
		dimensionsUnResolvableBool,
		bulkMaterialUnResolvableBool,
		coatMaterialUnResolvableBool,
		electrodeShapeUnResolvableBool,
		wiringConnectorsUnResolvableBool,
		maxNumberOfUsesUnResolvableBool,
		minPotentialUnResolvableBool,
		maxPotentialUnResolvableBool,
		sonicationSensitiveUnResolvableBool
	} = Replace[{
		resolvedSolutionVolume,
		resolvedDimensions,
		resolvedBulkMaterial,
		resolvedCoatMaterial,
		resolvedElectrodeShape,
		resolvedWiringConnectors,
		resolvedMaxNumberOfUses,
		resolvedMinPotential,
		resolvedMaxPotential,
		resolvedSonicationSensitive
	}, {Automatic -> True, Except[Automatic] -> False}, 1];

	(* -- For the ElectrodePackingMaterial, WiringDiameter, and WiringLength, set still Automatic ones to Null, since they are not required to pass VOQ -- *)
	{
		resolvedElectrodePackagingMaterial,
		resolvedWiringDiameters,
		resolvedWiringLength
	} = {
		resolvedElectrodePackagingMaterial,
		resolvedWiringDiameters,
		resolvedWiringLength
	} /. {Automatic -> Null};

	(* Set still Automatic MaxNumberOfPolishings to 100 *)
	resolvedMaxNumberOfPolishings = resolvedMaxNumberOfPolishings /. {Automatic -> 50};

	(* == Check if the resolved parameters are the same with the Blank, which is restricted by the physical set up of the Blank, since we can't physically modify the Blank. NOTE: they can be different from the template Model == *)

	(* -- This includes identical/equal fields: SolutionVolume, Dimensions, BulkMaterial, CoatMaterial, ElectrodeShape, ElectrodePackagingMaterial, WiringConnectors, WiringDiameters, WiringLength, SonicationSensitive, WettedMaterials -- *)
	equalFields = {SolutionVolume, Dimensions, BulkMaterial, CoatMaterial, ElectrodeShape, ElectrodePackagingMaterial, WiringConnectors, WiringDiameters, WiringLength, SonicationSensitive, WettedMaterials};

	(* -- LessEqualFields: MaxNumberOfUses, MaxNumberOfPolishings, MaxPotential -- *)
	lessEqualFields = {MaxNumberOfUses, MaxNumberOfPolishings, MaxPotential};

	(* -- GreaterEqualFields: MinPotential -- *)
	greaterEqualFields = {MinPotential};

	(* -- Use the helper function to check the consistency between resolvedValues and the Blank. The helper function is forgiving and can take unresolved Automatics, and Automatics will always pass the check since the error tracking booleans are already collected above. -- *)

	(* Prepare the fake packet for the helper function *)
	inconsistencyCheckPacket = <|
		SolutionVolume -> resolvedSolutionVolume,
		Dimensions -> resolvedDimensions,
		BulkMaterial -> resolvedBulkMaterial,
		CoatMaterial -> resolvedCoatMaterial,
		ElectrodeShape -> resolvedElectrodeShape,
		ElectrodePackagingMaterial -> resolvedElectrodePackagingMaterial,
		WiringConnectors -> resolvedWiringConnectors,
		WiringDiameters -> resolvedWiringDiameters,
		WiringLength -> resolvedWiringLength,
		SonicationSensitive -> resolvedSonicationSensitive,
		WettedMaterials -> resolvedWettedMaterials,
		MaxNumberOfUses -> resolvedMaxNumberOfUses,
		MaxNumberOfPolishings -> resolvedMaxNumberOfPolishings,
		MaxPotential -> resolvedMaxPotential,
		MinPotential -> resolvedMinPotential
	|>;

	inconsistencyCheckResult = If[MatchQ[blankModelPacket, PacketP[]],

		(* If the Blank model is not Null, we call the helper function *)
		checkFieldsInconsistency[
			inconsistencyCheckPacket,
			blankModelPacket,
			equalFields,
			greaterEqualFields,
			lessEqualFields,
			10^-1 Milliliter,
			10^-1 Millimeter,
			10^-1 Millivolt
		],

		(* If the Blank model is Null, we set this to an empty association *)
		Association[]
	];

	(* -- Gather the checking booleans, default to False, since inconsistencyCheckResult can be an empty association -- *)

	{
		conflictingSolutionVolumeBool,
		conflictingDimensionsBool,
		conflictingBulkMaterialBool,
		conflictingCoatMaterialBool,
		conflictingElectrodeShapeBool,
		conflictingElectrodePackagingMaterialBool,
		conflictingWiringConnectorsBool,
		conflictingWiringDiametersBool,
		conflictingWiringLengthBool,
		conflictingSonicationSensitiveBool,
		conflictingWettedMaterialsBool,
		conflictingMaxNumberOfUsesBool,
		conflictingMaxNumberOfPolishingsBool,
		conflictingMaxPotentialBool,
		conflictingMinPotentialBool
	} = Lookup[inconsistencyCheckResult, Join[equalFields, lessEqualFields, greaterEqualFields], False];

	(* == We need to check some options when no Blank is provided, since they can also be conflicting == *)

	(* == Check WiringConnectors and WiringDiameters (only when Blank is Null) == *)

	(* -- Check if WiringConnectors and WiringDiameters have the same Length -- *)
	wiringParametersMismatchLengthsBool = If[!MatchQ[blankModelPacket, PacketP[]],

		(* If the blank model is Null, we continue to check this error *)
		If[
			And[
				MatchQ[wiringConnectorsUnResolvableBool, False],
				!MatchQ[resolvedWiringDiameters, Null|{}],
				!SameLengthQ[resolvedWiringConnectors, resolvedWiringDiameters]
			],

			(* If the resolvedWiringConnectors and resolvedWiringDiameters are both resolvable, resolvedWiringDiameters is specified, and they are of different lengths, set this error to True *)
			True,

			(* Otherwise to False *)
			False
		],
		(* If the blank model is not Null, set this error to False *)
		False
	];

	(* -- Check if WiringDiameters are Null for non-ExposedWires and are not Null for ExposedWires -- *)
	(* We first collect the invalid wiring connector names *)
	{nonNullWiringDiameterWiringConnectors, missingWiringDiameterWiringConnectors} = If[!MatchQ[blankModelPacket, PacketP[]],

		(* If the blank model is Null, we continue to check these  *)
		If[
			And[
				MatchQ[wiringConnectorsUnResolvableBool, False],
				!MatchQ[resolvedWiringDiameters, Null|{}],
				MatchQ[wiringParametersMismatchLengthsBool, False]
			],

			(* If the resolvedWiringConnectors and resolvedWiringDiameters are both resolvable, resolvedWiringDiameters is specified, and they are of the same lengths, we continue *)
			Module[{wiringConnectorNames, wiringConnectorTypes, nonNullList, missingList},

				(* Retrieve the names and types form the resolvedWiringConnectors *)
				wiringConnectorNames = resolvedWiringConnectors[[All, 1]];
				wiringConnectorTypes = resolvedWiringConnectors[[All, 2]];

				(* Check if any ExposedWires missing a diameter or any non-ExposedWires having a diameter *)
				{nonNullList, missingList} = Transpose[MapThread[
					Function[{type, diameter},
						Which[
							(* If the type is not ExposedWire and the diameter is not Null, set nonNull to True and missing to False *)
							MatchQ[type, Except[ExposedWire]] && MatchQ[diameter, DistanceP],
							{True, False},

							(* If the type is ExposedWire and the diameter is Null, set nonNull to False and missing to True *)
							MatchQ[type, ExposedWire] && MatchQ[diameter, Null],
							{False, True},

							(* Otherwise, set both nonNull and missing to False *)
							True,
							{False, False}
						]
					],
					{wiringConnectorTypes, resolvedWiringDiameters}
				]];

				(* Collect the invalid wiring connector names *)
				{
					PickList[wiringConnectorNames, nonNullList, True],
					PickList[wiringConnectorNames, missingList, True]
				}
			],

			(* Otherwise, set them to empty lists *)
			{{}, {}}
		],
		(* If the blank model is not Null, set them to empty lists *)
		{{}, {}}
	];

	(* Generate the error checking booleans *)
	nonNullWiringDiameterForNonExposedWireBool = If[!MatchQ[nonNullWiringDiameterWiringConnectors, {}],
		True,
		False
	];

	missingWiringDiameterForExposedWireBool = If[!MatchQ[missingWiringDiameterWiringConnectors, {}],
		True,
		False
	];

	(* == Check MaxNumberOfUses and MaxNumberOfPolishings (MaxNumberOfUses >= MaxNumberOfPolishings, only when Blank is Null) == *)
	maxNumberOfPolishingsGreaterThanMaxNumberOfUsesBool = If[

		And[
			MatchQ[resolvedMaxNumberOfPolishings, _Integer],
			MatchQ[resolvedMaxNumberOfUses, _Integer],
			MatchQ[conflictingMaxNumberOfUsesBool, False],
			MatchQ[conflictingMaxNumberOfPolishingsBool, False],
			GreaterQ[resolvedMaxNumberOfPolishings, resolvedMaxNumberOfUses]
		],

		(* If both are successfully resolved and no error was encountered, we can check this error *)
		True,
		False
	];

	(* == Resolve WettedMaterials if it is still Automatic == *)
	safeWettedMaterials = If[MatchQ[resolvedWettedMaterials, Automatic],

		(* If resolvedWettedMaterials is still Automatic, we check BulkMaterial, CoatMaterial, ElectrodePackagingMaterial *)
		If[MatchQ[resolvedCoatMaterial, MaterialP],

			(* If CoatMaterial is informed, we check CoatMaterial and ElectrodePackagingMaterial *)
			{resolvedCoatMaterial, resolvedElectrodePackagingMaterial} /. {Null -> Nothing, Automatic -> Nothing},

			(* If CoatMaterial is not informed, we check BulkMaterial and ElectrodePackagingMaterial *)
			{resolvedBulkMaterial, resolvedElectrodePackagingMaterial} /. {Null -> Nothing, Automatic -> Nothing}
		],

		(* Otherwise do nothing *)
		ToList[resolvedWettedMaterials]
	];

	(* -- Check if WettedMaterials contains CoatMaterial if CoatMaterial is not Null -- *)
	wettedMaterialsNotContainCoatMaterialBool = If[
		And[
			MatchQ[resolvedCoatMaterial, MaterialP],
			MatchQ[conflictingCoatMaterialBool, False],
			MatchQ[conflictingWettedMaterialsBool, False],
			!MemberQ[safeWettedMaterials, resolvedCoatMaterial]
		],

		(* If the resolvedCoatMaterial is not a member of the safeWettedMaterials, set this error to True *)
		True,
		False
	];

	(* -- Check if WettedMaterials contains BulkMaterial if CoatMaterial is Null -- *)
	wettedMaterialsNotContainBulkMaterialBool = If[
		And[
			!MatchQ[resolvedCoatMaterial, MaterialP],
			MatchQ[resolvedBulkMaterial, MaterialP],
			MatchQ[conflictingCoatMaterialBool, False],
			MatchQ[conflictingBulkMaterialBool, False],
			MatchQ[conflictingWettedMaterialsBool, False],
			!MemberQ[safeWettedMaterials, resolvedBulkMaterial]
		],

		(* If the resolvedBulkMaterial is not a member of the safeWettedMaterials, set this error to True *)
		True,
		False
	];

	(* -- Check if WettedMaterials contains ElectrodePackagingMaterial if ElectrodePackagingMaterial is not Null -- *)
	wettedMaterialsNotContainElectrodePackagingMaterialBool = If[
		And[
			MatchQ[resolvedElectrodePackagingMaterial, MaterialP],
			MatchQ[conflictingElectrodePackagingMaterialBool, False],
			MatchQ[conflictingWettedMaterialsBool, False],
			!MemberQ[safeWettedMaterials, resolvedElectrodePackagingMaterial]
		],

		(* If the resolvedElectrodePackagingMaterial is not a member of the safeWettedMaterials, set this error to True *)
		True,
		False
	];

	(* == Resolve IncompatibleMaterials if it is still Automatic == *)
	safeIncompatibleMaterials = If[MatchQ[resolvedIncompatibleMaterials, Automatic],

		(* If resolvedIncompatibleMaterials is still Automatic, set safeIncompatibleMaterials to None *)
		{None},

		(* Otherwise do nothing *)
		ToList[resolvedIncompatibleMaterials]
	];

	(* -- Check if IncompatibleMaterials does not contain CoatMaterial if CoatMaterial is not Null -- *)
	incompatibleMaterialsContainCoatMaterialBool = If[
		And[
			MatchQ[resolvedCoatMaterial, MaterialP],
			MatchQ[conflictingCoatMaterialBool, False],
			MemberQ[safeIncompatibleMaterials, resolvedCoatMaterial]
		],

		(* If the resolvedCoatMaterial is a member of the safeIncompatibleMaterials, set this error to True *)
		True,
		False
	];

	(* -- Check if IncompatibleMaterials does not contain BulkMaterial -- *)
	incompatibleMaterialsContainBulkMaterialBool = If[
		And[
			MatchQ[resolvedBulkMaterial, MaterialP],
			MatchQ[conflictingBulkMaterialBool, False],
			MemberQ[safeIncompatibleMaterials, resolvedBulkMaterial]
		],

		(* If the resolvedBulkMaterial is a member of the safeIncompatibleMaterials, set this error to True *)
		True,
		False
	];

	(* -- Check if IncompatibleMaterials does not contain ElectrodePackagingMaterial if ElectrodePackagingMaterial is not Null -- *)
	incompatibleMaterialsContainElectrodePackagingMaterialBool = If[
		And[
			MatchQ[resolvedElectrodePackagingMaterial, MaterialP],
			MatchQ[conflictingElectrodePackagingMaterialBool, False],
			MemberQ[safeIncompatibleMaterials, resolvedElectrodePackagingMaterial]
		],

		(* If the resolvedElectrodePackagingMaterial is a member of the safeIncompatibleMaterials, set this error to True *)
		True,
		False
	];

	(* == Check if Name exists in the database == *)
	nameExistingBool = If[MatchQ[name, _String],
		DatabaseMemberQ[Model[Item, Electrode, ReferenceElectrode, name]],
		False
	];

	(* Collect the Name invalidOptions *)
	nameInvalidOptions = If[
		MemberQ[
			{
				nameExistingBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{Name},
		{}
	];

	(* == Resolve Synonyms == *)
	resolvedSynonyms = If[StringQ[name],

		(* If name is a string, set Automatic Synonyms to {name} *)
		synonyms /. {Automatic -> {name}},

		(* If name is not a string, set Automatic Synonyms to Null *)
		Null
	];

	(* -- Adjust the Synonyms to safeSynonyms, instead of throwing errors -- *)
	safeSynonyms = Which[

		(* If name is not provided, return Null *)
		MatchQ[name, Null],
		Null,

		(* If name is not in the resolvedSynonyms, we prepend the name *)
		!MemberQ[resolvedSynonyms, name],
		Prepend[resolvedSynonyms, name],

		(* If name is in the resolvedSynonyms, we check its position *)
		MemberQ[resolvedSynonyms, name],
		Module[{synonymsWithoutDuplicates, namePosition},
			synonymsWithoutDuplicates = DeleteDuplicates[resolvedSynonyms];
			namePosition = First[Flatten[Position[synonymsWithoutDuplicates, name]]];

			If[MatchQ[namePosition, 1],

				(* If namePosition is 1, return synonymsWithoutDuplicates *)
				synonymsWithoutDuplicates,

				(* If namePosition is not 1, drop name from synonymsWithoutDuplicates and prepend name *)
				Prepend[Drop[synonymsWithoutDuplicates, {namePosition}], name]
			]
		]
	];

	(* == Collect the physical parameters invalidOptions == *)
	(* -- SolutionVolume -- *)
	solutionVolumeInvalidOptions = If[
		MemberQ[
			{
				solutionVolumeUnResolvableBool,
				conflictingSolutionVolumeBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{SolutionVolume},
		{}
	];

	(* -- Dimensions -- *)
	dimensionsInvalidOptions = If[
		MemberQ[
			{
				dimensionsUnResolvableBool,
				conflictingDimensionsBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{Dimensions},
		{}
	];

	(* -- BulkMaterial -- *)
	bulkMaterialInvalidOptions = If[
		MemberQ[
			{
				bulkMaterialUnResolvableBool,
				conflictingBulkMaterialBool,
				wettedMaterialsNotContainBulkMaterialBool,
				incompatibleMaterialsContainBulkMaterialBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{BulkMaterial},
		{}
	];

	(* -- CoatMaterial -- *)
	coatMaterialInvalidOptions = If[
		MemberQ[
			{
				coatMaterialUnResolvableBool,
				conflictingCoatMaterialBool,
				wettedMaterialsNotContainCoatMaterialBool,
				incompatibleMaterialsContainCoatMaterialBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{CoatMaterial},
		{}
	];

	(* -- ElectrodeShape -- *)
	electrodeShapeInvalidOptions = If[
		MemberQ[
			{
				electrodeShapeUnResolvableBool,
				conflictingElectrodeShapeBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{ElectrodeShape},
		{}
	];

	(* -- ElectrodePackagingMaterial -- *)
	electrodePackagingMaterialInvalidOptions = If[
		MemberQ[
			{
				conflictingElectrodePackagingMaterialBool,
				wettedMaterialsNotContainElectrodePackagingMaterialBool,
				incompatibleMaterialsContainElectrodePackagingMaterialBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{ElectrodePackagingMaterial},
		{}
	];

	(* -- WiringConnectors -- *)
	wiringConnectorsInvalidOptions = If[
		MemberQ[
			{
				wiringConnectorsUnResolvableBool,
				conflictingWiringConnectorsBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{WiringConnectors},
		{}
	];

	(* -- WiringDiameters -- *)
	wiringDiametersInvalidOptions = If[
		MemberQ[
			{
				conflictingWiringDiametersBool,
				wiringParametersMismatchLengthsBool,
				nonNullWiringDiameterForNonExposedWireBool,
				missingWiringDiameterForExposedWireBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{WiringDiameters},
		{}
	];

	(* -- WiringLength -- *)
	wiringLengthInvalidOptions = If[
		MemberQ[
			{
				conflictingWiringLengthBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{WiringLength},
		{}
	];

	(* -- MaxNumberOfUses -- *)
	maxNumberOfUsesInvalidOptions = If[
		MemberQ[
			{
				maxNumberOfUsesUnResolvableBool,
				conflictingMaxNumberOfUsesBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{MaxNumberOfUses},
		{}
	];

	(* -- MinPotential -- *)
	minPotentialInvalidOptions = If[
		MemberQ[
			{
				minPotentialUnResolvableBool,
				conflictingMinPotentialBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{MinPotential},
		{}
	];

	(* -- MaxPotential -- *)
	maxPotentialInvalidOptions = If[
		MemberQ[
			{
				maxPotentialUnResolvableBool,
				conflictingMaxPotentialBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{MaxPotential},
		{}
	];

	(* -- MaxNumberOfPolishings -- *)
	maxNumberOfPolishingsInvalidOptions = If[
		MemberQ[
			{
				conflictingMaxNumberOfPolishingsBool,
				maxNumberOfPolishingsGreaterThanMaxNumberOfUsesBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{MaxNumberOfPolishings},
		{}
	];

	(* -- SonicationSensitive -- *)
	sonicationSensitiveInvalidOptions = If[
		MemberQ[
			{
				sonicationSensitiveUnResolvableBool,
				conflictingSonicationSensitiveBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{SonicationSensitive},
		{}
	];

	(* -- WettedMaterials -- *)
	wettedMaterialsInvalidOptions = If[
		MemberQ[
			{
				conflictingWettedMaterialsBool,
				wettedMaterialsNotContainCoatMaterialBool,
				wettedMaterialsNotContainBulkMaterialBool,
				wettedMaterialsNotContainElectrodePackagingMaterialBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{WettedMaterials},
		{}
	];

	(* -- IncompatibleMaterials -- *)
	incompatibleMaterialsInvalidOptions = If[
		MemberQ[
			{
				incompatibleMaterialsContainCoatMaterialBool,
				incompatibleMaterialsContainBulkMaterialBool,
				incompatibleMaterialsContainElectrodePackagingMaterialBool
			},
			True
		],

		(* If any of the error checking booleans is True, we collect the invalidOption *)
		{IncompatibleMaterials},
		{}
	];

	resolvedOptionsAssociations = Association[
		(* Individual resolved options here *)
		Name -> name,
		Synonyms -> safeSynonyms,
		ReferenceElectrodeType -> resolvedReferenceElectrodeType,
		Blank -> resolvedBlank,
		RecommendedSolventType -> resolvedRecommendedSolventType,
		ReferenceSolution -> resolvedReferenceSolution,
		ReferenceCouplingSample -> resolvedReferenceCouplingSample,
		Preparable -> resolvedPreparable,
		SolutionVolume -> resolvedSolutionVolume,
		RecommendedRefreshPeriod -> resolvedRecommendedRefreshPeriod,
		Dimensions -> resolvedDimensions,
		DefaultStorageCondition -> resolvedDefaultStorageCondition,
		BulkMaterial -> resolvedBulkMaterial,
		CoatMaterial -> resolvedCoatMaterial,
		ElectrodeShape -> resolvedElectrodeShape,
		ElectrodePackagingMaterial -> resolvedElectrodePackagingMaterial,
		WiringConnectors -> resolvedWiringConnectors,
		WiringDiameters -> resolvedWiringDiameters,
		WiringLength -> resolvedWiringLength,
		MaxNumberOfUses -> resolvedMaxNumberOfUses,
		MinPotential -> resolvedMinPotential,
		MaxPotential -> resolvedMaxPotential,
		MaxNumberOfPolishings -> resolvedMaxNumberOfPolishings,
		SonicationSensitive -> resolvedSonicationSensitive,
		WettedMaterials -> safeWettedMaterials,
		IncompatibleMaterials -> safeIncompatibleMaterials
	];

	(* --------------------- *)
	(* -- Gathering Tests -- *)
	(* --------------------- *)

	(* We use the helper function referenceElectrodeTests to generate the tests from the error checking booleans we collected above *)
	resolvedOptionTests = If[gatherTests,

		(* If we are gathering tests, call the helper function *)

		referenceElectrodeTests[{

			(* blankModelNotBareTypeBool *)
			{Test, "The Blank is a 'bare' type reference electrode model.", blankModelNotBareTypeBool},

			(* referenceElectrodeTypeUnresolvableBool *)
			{Test, "The ReferenceElectrodeType can be successfully resolved.", referenceElectrodeTypeUnresolvableBool},

			(* referenceElectrodeTypeSameWithBlankModelBool *)
			{Test, "The ReferenceElectrodeType is not the same with the Blank model's ReferenceElectrodeType.", referenceElectrodeTypeSameWithBlankModelBool},

			(* referenceElectrodeTypeInvalidForBlankModelBool *)
			{Test, "The ReferenceElectrodeType is a \"bare\" type (having \"Bare\" or \"bare\") when the model being uploaded is a Blank model (the Blank option is set to Null).", referenceElectrodeTypeInvalidForBlankModelBool},

			(* referenceElectrodeTypeInvalidForNonBlankModelBool *)
			{Test, "The ReferenceElectrodeType is not a 'bare' type (having \"Bare\" or \"bare\") when the model being uploaded is not a Blank model (the Blank option is specified).", referenceElectrodeTypeInvalidForNonBlankModelBool},

			(* nonNullRecommendedSolventTypeBool *)
			{Test, "The RecommendedSolventType is not specified when the model being uploaded is a Blank model (the Blank option is set to Null).", nonNullRecommendedSolventTypeBool},

			(* missingRecommendedSolventTypeBool *)
			{Test, "The RecommendedSolventType is not set to Null when the model being uploaded is not a Blank model (the Blank option is specified).", missingRecommendedSolventTypeBool},



			(* referenceSolutionLessThanTwoComponentsBool *)
			{Test, "The ReferenceSolution specified has at least two non-null entries in its Composition field.", referenceSolutionLessThanTwoComponentsBool},

			(* referenceSolutionMissingSolventBool *)
			{Test, "The ReferenceSolution specified has a solvent sample populated in its Solvent field.", referenceSolutionMissingSolventBool},

			(* referenceSolutionSolventSampleAmbiguousMoleculeBool *)
			{Test, "The solvent sample in the Solvent field of the specified ReferenceSolution has only one non-Null entry in its Composition field.", referenceSolutionSolventSampleAmbiguousMoleculeBool},

			(* referenceSolutionMissingAnalyteBool *)
			{Test, "The ReferenceSolution specified has a molecule populated in its Analytes field.", referenceSolutionMissingAnalyteBool},

			(* referenceSolutionAmbiguousAnalyteBool *)
			{Test, "The ReferenceSolution specified has only one non-Null molecule populated in its Analytes field.", referenceSolutionAmbiguousAnalyteBool},

			(* referenceSolutionAnalyteMoleculeMissingDefaultSampleModelBool *)
			{Test, "The molecule in the Analytes field of the specified ReferenceSolution has a DefaultSampleModel defined.", referenceSolutionAnalyteMoleculeMissingDefaultSampleModelBool},

			(* nonNullReferenceSolutionBool *)
			{Test, "The ReferenceSolution is not specified when the model being uploaded is a Blank model (the Blank option is set to Null).", nonNullReferenceSolutionBool},

			(* missingReferenceSolutionBool *)
			{Test, "The ReferenceSolution is not set to Null when the model being uploaded is not a Blank model (the Blank option is specified).", missingReferenceSolutionBool},

			(* mismatchingSolventTypeWarningBool *)
			{Warning, "The ReferenceSolution has a matching solvent type with the RecommendedSolventType.", mismatchingSolventTypeWarningBool},


			(* nullPriceBool *)
			{Test, "The Price option is explicitly set for a preparable public reference electrode model.", nullPriceBool},


			(* nonNullReferenceCouplingSampleForBlankModelBool *)
			{Test, "The ReferenceCouplingSample is not specified when the model being uploaded is a Blank model (the Blank option is set to Null).", nonNullReferenceCouplingSampleForBlankModelBool},

			(* nonNullReferenceCouplingSampleForPseudoModelBool *)
			{Test, "The ReferenceCouplingSample is not specified when the ReferenceElectrodeType is a \"pseudo\" type (having \"Pseudo\" or \"pseudo\").", nonNullReferenceCouplingSampleForPseudoModelBool},

			(* missingReferenceCouplingSampleBool *)
			{Test, "The ReferenceCouplingSample is not set to Null when the model being uploaded is not a Blank model (the Blank option is specified) and the ReferenceElectrodeType is not a \"pseudo\" type (having \"Pseudo\" or \"pseudo\").", missingReferenceCouplingSampleBool},

			(* referenceCouplingSampleAmbiguousAnalyteBool *)
			{Test, "The ReferenceCouplingSample specified has only one non-Null molecule populated in its Analytes field.", referenceCouplingSampleAmbiguousAnalyteBool},

			(* mismatchingReferenceCouplingSampleMoleculeBool *)
			{Test, "The molecule defined by the ReferenceCouplingSample matches with the redox coupling molecule defined in the ReferenceSolution.", mismatchingReferenceCouplingSampleMoleculeBool},



			(* nonNullRecommendedRefreshPeriodBool *)
			{Test, "The RecommendedRefreshPeriod is not specified when the model being uploaded is a Blank model (the Blank option is set to Null).", nonNullRecommendedRefreshPeriodBool},

			(* missingRecommendedRefreshPeriodBool *)
			{Test, "The RecommendedRefreshPeriod is not set to Null when the model being uploaded is not a Blank model (the Blank option is specified).", missingRecommendedRefreshPeriodBool},

			(* nameExistingBool *)
			{Test, "The provided Name does not exist in the database.", nameExistingBool},

			(* mismatchingDefaultStorageConditionBool *)
			{Test, "The provided DefaultStorageCondition option is the same with the DefaultStorageCondition of the ReferenceSolution.", mismatchingDefaultStorageConditionBool},



			(* solutionVolumeUnResolvableBool *)
			{Test, "The SolutionVolume option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", solutionVolumeUnResolvableBool},

			(* dimensionsUnResolvableBool *)
			{Test, "The Dimensions option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", dimensionsUnResolvableBool},

			(* bulkMaterialUnResolvableBool *)
			{Test, "The BulkMaterial option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", bulkMaterialUnResolvableBool},

			(* coatMaterialUnResolvableBool *)
			{Test, "The CoatMaterial option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", coatMaterialUnResolvableBool},

			(* electrodeShapeUnResolvableBool *)
			{Test, "The ElectrodeShape option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", electrodeShapeUnResolvableBool},

			(* wiringConnectorsUnResolvableBool *)
			{Test, "The WiringConnectors option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", wiringConnectorsUnResolvableBool},

			(* maxNumberOfUsesUnResolvableBool *)
			{Test, "The MaxNumberOfUses option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", maxNumberOfUsesUnResolvableBool},

			(* minPotentialUnResolvableBool *)
			{Test, "The MinPotential option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", minPotentialUnResolvableBool},

			(* maxPotentialUnResolvableBool *)
			{Test, "The MaxPotential option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", maxPotentialUnResolvableBool},

			(* sonicationSensitiveUnResolvableBool *)
			{Test, "The SonicationSensitive option is provided when the model being uploaded is a Blank model (the Blank option is set to Null).", sonicationSensitiveUnResolvableBool},



			(* conflictingSolutionVolumeBool *)
			{Test, "The specified SolutionVolume is same with its Blank reference electrode model.", conflictingSolutionVolumeBool},

			(* conflictingDimensionsBool *)
			{Test, "The specified Dimensions is same with its Blank reference electrode model.", conflictingDimensionsBool},

			(* conflictingBulkMaterialBool *)
			{Test, "The specified BulkMaterial is same with its Blank reference electrode model.", conflictingBulkMaterialBool},

			(* conflictingCoatMaterialBool *)
			{Test, "The specified CoatMaterial is same with its Blank reference electrode model.", conflictingCoatMaterialBool},

			(* conflictingElectrodeShapeBool *)
			{Test, "The specified ElectrodeShape is same with its Blank reference electrode model.", conflictingElectrodeShapeBool},

			(* conflictingElectrodePackagingMaterialBool *)
			{Test, "The specified ElectrodePackagingMaterial is same with its Blank reference electrode model.", conflictingElectrodePackagingMaterialBool},

			(* conflictingWiringConnectorsBool *)
			{Test, "The specified WiringConnectors is same with its Blank reference electrode model.", conflictingWiringConnectorsBool},

			(* conflictingWiringDiametersBool *)
			{Test, "The specified WiringDiameters is same with its Blank reference electrode model.", conflictingWiringDiametersBool},

			(* conflictingWiringLengthBool *)
			{Test, "The specified WiringLength is same with its Blank reference electrode model.", conflictingWiringLengthBool},

			(* conflictingSonicationSensitiveBool *)
			{Test, "The specified SonicationSensitive is same with its Blank reference electrode model.", conflictingSonicationSensitiveBool},

			(* conflictingWettedMaterialsBool *)
			{Test, "The specified WettedMaterials is same with its Blank reference electrode model.", conflictingWettedMaterialsBool},

			(* conflictingMaxNumberOfUsesBool *)
			{Test, "The specified MaxNumberOfUses is same with its Blank reference electrode model.", conflictingMaxNumberOfUsesBool},

			(* conflictingMaxNumberOfPolishingsBool *)
			{Test, "The specified MaxNumberOfPolishings is same with its Blank reference electrode model.", conflictingMaxNumberOfPolishingsBool},

			(* conflictingMaxPotentialBool *)
			{Test, "The specified MaxPotential is same with its Blank reference electrode model.", conflictingMaxPotentialBool},

			(* conflictingMinPotentialBool *)
			{Test, "The specified MinPotential is same with its Blank reference electrode model.", conflictingMinPotentialBool},



			(* wiringParametersMismatchLengthsBool *)
			{Test, "The lengths of the specified WiringConnectors and WiringDiameters are the same", wiringParametersMismatchLengthsBool},

			(* nonNullWiringDiameterForNonExposedWireBool *)
			{Test, "Wiring diameters are Null for non-ExposedWire type wiring connectors", nonNullWiringDiameterForNonExposedWireBool},

			(* missingWiringDiameterForExposedWireBool *)
			{Test, "Wiring diameters are not Null for ExposedWire type wiring connectors", missingWiringDiameterForExposedWireBool},



			(* maxNumberOfPolishingsGreaterThanMaxNumberOfUsesBool *)
			{Test, "MaxNumberOfPolishings is less than or equal to the MaxNumberOfUses", maxNumberOfPolishingsGreaterThanMaxNumberOfUsesBool},

			(* wettedMaterialsNotContainCoatMaterialBool *)
			{Test, "The specified WettedMaterials contains the CoatMaterial.", wettedMaterialsNotContainCoatMaterialBool},

			(* wettedMaterialsNotContainBulkMaterialBool *)
			{Test, "The specified WettedMaterials contains the BulkMaterial.", wettedMaterialsNotContainBulkMaterialBool},

			(* wettedMaterialsNotContainElectrodePackagingMaterialBool *)
			{Test, "The specified WettedMaterials contains the ElectrodePackagingMaterial.", wettedMaterialsNotContainElectrodePackagingMaterialBool},

			(* incompatibleMaterialsContainCoatMaterialBool *)
			{Test, "The CoatMaterial is not a member of the IncompatibleMaterials.", incompatibleMaterialsContainCoatMaterialBool},

			(* incompatibleMaterialsContainBulkMaterialBool *)
			{Test, "The BulkMaterial is not a member of the IncompatibleMaterials.", incompatibleMaterialsContainBulkMaterialBool},

			(* incompatibleMaterialsContainElectrodePackagingMaterialBool *)
			{Test, "The ElectrodePackagingMaterial is not a member of the IncompatibleMaterials.", incompatibleMaterialsContainElectrodePackagingMaterialBool}

		}],

		(* If we are not gathering tests, return an empty list *)
		{}
	];

	(* -------------------- *)
	(* -- Throw Messages -- *)
	(* -------------------- *)

	If[messages,

		(* == If we are throwing messages == *)

		(* blankModelNotBareTypeBool *)
		If[MatchQ[blankModelNotBareTypeBool, True],
			Message[Error::UREBlankModelNotBareType]
		];

		(* referenceElectrodeTypeUnresolvableBool *)
		If[MatchQ[referenceElectrodeTypeUnresolvableBool, True],
			Message[Error::UREReferenceElectrodeTypeUnresolvable]
		];

		(* referenceElectrodeTypeSameWithBlankModelBool *)
		If[MatchQ[referenceElectrodeTypeSameWithBlankModelBool, True],
			Message[Error::UREReferenceElectrodeTypeSameWithBlankModel]
		];

		(* referenceElectrodeTypeInvalidForBlankModelBool *)
		If[MatchQ[referenceElectrodeTypeInvalidForBlankModelBool, True],
			Message[Error::UREReferenceElectrodeTypeInvalidForBlankModel]
		];

		(* referenceElectrodeTypeInvalidForNonBlankModelBool *)
		If[MatchQ[referenceElectrodeTypeInvalidForNonBlankModelBool, True],
			Message[Error::UREReferenceElectrodeTypeInvalidForNonBlankModel]
		];

		(* nonNullRecommendedSolventTypeBool *)
		If[MatchQ[nonNullRecommendedSolventTypeBool, True],
			Message[Error::URENonNullRecommendedSolventType]
		];

		(* missingRecommendedSolventTypeBool *)
		If[MatchQ[missingRecommendedSolventTypeBool, True],
			Message[Error::UREMissingRecommendedSolventType]
		];


		(* referenceSolutionLessThanTwoComponentsBool *)
		If[MatchQ[referenceSolutionLessThanTwoComponentsBool, True],
			Message[Error::UREReferenceSolutionLessThanTwoComponents]
		];

		(* referenceSolutionMissingSolventBool *)
		If[MatchQ[referenceSolutionMissingSolventBool, True],
			Message[Error::UREReferenceSolutionMissingSolvent]
		];

		(* referenceSolutionSolventSampleAmbiguousMoleculeBool *)
		If[MatchQ[referenceSolutionSolventSampleAmbiguousMoleculeBool, True],
			Message[Error::UREReferenceSolutionSolventSampleAmbiguousMolecule]
		];

		(* referenceSolutionMissingAnalyteBool *)
		If[MatchQ[referenceSolutionMissingAnalyteBool, True],
			Message[Error::UREReferenceSolutionMissingAnalyte]
		];

		(* referenceSolutionAmbiguousAnalyteBool *)
		If[MatchQ[referenceSolutionAmbiguousAnalyteBool, True],
			Message[Error::UREReferenceSolutionAmbiguousAnalyte]
		];

		(* referenceSolutionAnalyteMoleculeMissingDefaultSampleModelBool *)
		If[MatchQ[referenceSolutionAnalyteMoleculeMissingDefaultSampleModelBool, True],
			Message[Error::UREReferenceSolutionAnalyteMoleculeMissingDefaultSampleModel]
		];

		(* nonNullReferenceSolutionBool *)
		If[MatchQ[nonNullReferenceSolutionBool, True],
			Message[Error::URENonNullReferenceSolution]
		];

		(* missingReferenceSolutionBool *)
		If[MatchQ[missingReferenceSolutionBool, True],
			Message[Error::UREMissingReferenceSolution]
		];

		(* mismatchingSolventTypeWarningBool *)
		If[MatchQ[mismatchingSolventTypeWarningBool, True] && Not[MatchQ[$ECLApplication, Engine]],
			Message[Warning::UREMismatchingSolventTypeWarning]
		];


		(* nullPriceBool *)
		If[MatchQ[nullPriceBool, True],
			Message[Error::URENullPriceForPublicPreparableModel]
		];


		(* nonNullReferenceCouplingSampleForBlankModelBool *)
		If[MatchQ[nonNullReferenceCouplingSampleForBlankModelBool, True],
			Message[Error::URENonNullReferenceCouplingSampleForBlankModel]
		];

		(* nonNullReferenceCouplingSampleForPseudoModelBool *)
		If[MatchQ[nonNullReferenceCouplingSampleForPseudoModelBool, True],
			Message[Error::URENonNullReferenceCouplingSampleForPseudoModel]
		];

		(* missingReferenceCouplingSampleBool *)
		If[MatchQ[missingReferenceCouplingSampleBool, True],
			Message[Error::UREMissingReferenceCouplingSample]
		];

		(* referenceCouplingSampleAmbiguousAnalyteBool *)
		If[MatchQ[referenceCouplingSampleAmbiguousAnalyteBool, True],
			Message[Error::UREReferenceCouplingSampleAmbiguousAnalyte]
		];

		(* mismatchingReferenceCouplingSampleMoleculeBool *)
		If[MatchQ[mismatchingReferenceCouplingSampleMoleculeBool, True],
			Message[Error::UREMismatchingReferenceCouplingSampleMolecule]
		];



		(* nonNullRecommendedRefreshPeriodBool *)
		If[MatchQ[nonNullRecommendedRefreshPeriodBool, True],
			Message[Error::URENonNullRecommendedRefreshPeriod]
		];

		(* missingRecommendedRefreshPeriodBool *)
		If[MatchQ[missingRecommendedRefreshPeriodBool, True],
			Message[Error::UREMissingRecommendedRefreshPeriod]
		];

		(* nameExistingBool *)
		If[MatchQ[nameExistingBool, True],
			Message[Error::URENameExisting]
		];

		(* mismatchingDefaultStorageConditionBool *)
		If[MatchQ[mismatchingDefaultStorageConditionBool, True],
			Message[Error::UREMismatchingDefaultStorageCondition]
		];



		(* solutionVolumeUnResolvableBool *)
		If[MatchQ[solutionVolumeUnResolvableBool, True],
			Message[Error::URESolutionVolumeUnResolvable]
		];

		(* dimensionsUnResolvableBool *)
		If[MatchQ[dimensionsUnResolvableBool, True],
			Message[Error::UREDimensionsUnResolvable]
		];

		(* bulkMaterialUnResolvableBool *)
		If[MatchQ[bulkMaterialUnResolvableBool, True],
			Message[Error::UREBulkMaterialUnResolvable]
		];

		(* coatMaterialUnResolvableBool *)
		If[MatchQ[coatMaterialUnResolvableBool, True],
			Message[Error::URECoatMaterialUnResolvable]
		];

		(* electrodeShapeUnResolvableBool *)
		If[MatchQ[electrodeShapeUnResolvableBool, True],
			Message[Error::UREElectrodeShapeUnResolvable]
		];

		(* wiringConnectorsUnResolvableBool *)
		If[MatchQ[wiringConnectorsUnResolvableBool, True],
			Message[Error::UREWiringConnectorsUnResolvable]
		];

		(* maxNumberOfUsesUnResolvableBool *)
		If[MatchQ[maxNumberOfUsesUnResolvableBool, True],
			Message[Error::UREMaxNumberOfUsesUnResolvable]
		];

		(* minPotentialUnResolvableBool *)
		If[MatchQ[minPotentialUnResolvableBool, True],
			Message[Error::UREMinPotentialUnResolvable]
		];

		(* maxPotentialUnResolvableBool *)
		If[MatchQ[maxPotentialUnResolvableBool, True],
			Message[Error::UREMaxPotentialUnResolvable]
		];

		(* sonicationSensitiveUnResolvableBool *)
		If[MatchQ[sonicationSensitiveUnResolvableBool, True],
			Message[Error::URESonicationSensitiveUnResolvable]
		];



		(* conflictingSolutionVolumeBool *)
		If[MatchQ[conflictingSolutionVolumeBool, True],
			Message[Error::UREConflictingSolutionVolume]
		];

		(* conflictingDimensionsBool *)
		If[MatchQ[conflictingDimensionsBool, True],
			Message[Error::UREConflictingDimensions]
		];

		(* conflictingBulkMaterialBool *)
		If[MatchQ[conflictingBulkMaterialBool, True],
			Message[Error::UREConflictingBulkMaterial]
		];

		(* conflictingCoatMaterialBool *)
		If[MatchQ[conflictingCoatMaterialBool, True],
			Message[Error::UREConflictingCoatMaterial]
		];

		(* conflictingElectrodeShapeBool *)
		If[MatchQ[conflictingElectrodeShapeBool, True],
			Message[Error::UREConflictingElectrodeShape]
		];

		(* conflictingElectrodePackagingMaterialBool *)
		If[MatchQ[conflictingElectrodePackagingMaterialBool, True],
			Message[Error::UREConflictingElectrodePackagingMaterial]
		];

		(* conflictingWiringConnectorsBool *)
		If[MatchQ[conflictingWiringConnectorsBool, True],
			Message[Error::UREConflictingWiringConnectors]
		];

		(* conflictingWiringDiametersBool *)
		If[MatchQ[conflictingWiringDiametersBool, True],
			Message[Error::UREConflictingWiringDiameters]
		];

		(* conflictingWiringLengthBool *)
		If[MatchQ[conflictingWiringLengthBool, True],
			Message[Error::UREConflictingWiringLength]
		];

		(* conflictingSonicationSensitiveBool *)
		If[MatchQ[conflictingSonicationSensitiveBool, True],
			Message[Error::UREConflictingSonicationSensitive]
		];

		(* conflictingWettedMaterialsBool *)
		If[MatchQ[conflictingWettedMaterialsBool, True],
			Message[Error::UREConflictingWettedMaterials]
		];

		(* conflictingMaxNumberOfUsesBool *)
		If[MatchQ[conflictingMaxNumberOfUsesBool, True],
			Message[Error::UREConflictingMaxNumberOfUses]
		];

		(* conflictingMaxNumberOfPolishingsBool *)
		If[MatchQ[conflictingMaxNumberOfPolishingsBool, True],
			Message[Error::UREConflictingMaxNumberOfPolishings]
		];

		(* conflictingMaxPotentialBool *)
		If[MatchQ[conflictingMaxPotentialBool, True],
			Message[Error::UREConflictingMaxPotential]
		];

		(* conflictingMinPotentialBool *)
		If[MatchQ[conflictingMinPotentialBool, True],
			Message[Error::UREConflictingMinPotential]
		];



		(* wiringParametersMismatchLengthsBool *)
		If[MatchQ[wiringParametersMismatchLengthsBool, True],
			Message[Error::UREWiringParametersMismatchLengths]
		];

		(* nonNullWiringDiameterForNonExposedWireBool *)
		If[MatchQ[nonNullWiringDiameterForNonExposedWireBool, True],
			Message[Error::URENonNullWiringDiameterForNonExposedWire, ToString[nonNullWiringDiameterWiringConnectors]]
		];

		(* missingWiringDiameterForExposedWireBool *)
		If[MatchQ[missingWiringDiameterForExposedWireBool, True],
			Message[Error::UREMissingWiringDiameterForExposedWire, ToString[missingWiringDiameterWiringConnectors]]
		];



		(* maxNumberOfPolishingsGreaterThanMaxNumberOfUsesBool *)
		If[MatchQ[maxNumberOfPolishingsGreaterThanMaxNumberOfUsesBool, True],
			Message[Error::UREMaxNumberOfPolishingsGreaterThanMaxNumberOfUses, ToString[resolvedMaxNumberOfPolishings], ToString[resolvedMaxNumberOfUses]]
		];

		(* wettedMaterialsNotContainCoatMaterialBool *)
		If[MatchQ[wettedMaterialsNotContainCoatMaterialBool, True],
			Message[Error::UREWettedMaterialsNotContainCoatMaterial]
		];

		(* wettedMaterialsNotContainBulkMaterialBool *)
		If[MatchQ[wettedMaterialsNotContainBulkMaterialBool, True],
			Message[Error::UREWettedMaterialsNotContainBulkMaterial]
		];

		(* wettedMaterialsNotContainElectrodePackagingMaterialBool *)
		If[MatchQ[wettedMaterialsNotContainElectrodePackagingMaterialBool, True],
			Message[Error::UREWettedMaterialsNotContainElectrodePackagingMaterial]
		];

		(* incompatibleMaterialsContainCoatMaterialBool *)
		If[MatchQ[incompatibleMaterialsContainCoatMaterialBool, True],
			Message[Error::UREIncompatibleMaterialsContainCoatMaterial]
		];

		(* incompatibleMaterialsContainBulkMaterialBool *)
		If[MatchQ[incompatibleMaterialsContainBulkMaterialBool, True],
			Message[Error::UREIncompatibleMaterialsContainBulkMaterial]
		];

		(* incompatibleMaterialsContainElectrodePackagingMaterialBool *)
		If[MatchQ[incompatibleMaterialsContainElectrodePackagingMaterialBool, True],
			Message[Error::UREIncompatibleMaterialsContainElectrodePackagingMaterial]
		];

		(* == If we are not throwing messages, do nothing == *)
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	(* gather the invalid inputs *)
	invalidInputs = DeleteDuplicates[Flatten[{
		templateDeprecatedInvalidInputs
	}]];

	(* gather the invalid options *)
	invalidOptions = DeleteCases[
		DeleteDuplicates[
			Flatten[
				{
					blankInvalidOptions,
					referenceElectrodeTypeInvalidOptions,
					recommendedSolventTypeInvalidOptions,
					referenceSolutionInvalidOptions,
					priceInvalidOptions,
					referenceCouplingSampleInvalidOptions,
					recommendedRefreshPeriodInvalidOptions,
					nameInvalidOptions,
					defaultStorageConditionInvalidOptions,
					solutionVolumeInvalidOptions,
					dimensionsInvalidOptions,
					bulkMaterialInvalidOptions,
					coatMaterialInvalidOptions,
					electrodeShapeInvalidOptions,
					electrodePackagingMaterialInvalidOptions,
					wiringConnectorsInvalidOptions,
					wiringDiametersInvalidOptions,
					wiringLengthInvalidOptions,
					maxNumberOfUsesInvalidOptions,
					minPotentialInvalidOptions,
					maxPotentialInvalidOptions,
					maxNumberOfPolishingsInvalidOptions,
					sonicationSensitiveInvalidOptions,
					wettedMaterialsInvalidOptions,
					incompatibleMaterialsInvalidOptions
				}
			]
		],
		Null
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->inheritedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	uploadReferenceElectrodeModelTests = Cases[
		Flatten[
			{
				templateDeprecatedTests,

				(* Rounding tests *)
				precisionTests,

				(* Options *)
				resolvedOptionTests
			}
		], _EmeraldTest
	];

	(* ------------------------ *)
	(* --- RESOLVED OPTIONS --- *)
	(* ------------------------ *)

	resolvedOptions = ReplaceRule[Normal[roundedOptions],
		Flatten[
			{
				(* -- resolved options -- *)
				Normal[resolvedOptionsAssociations]
			}
		]
	]/.x:ObjectP[]:>Download[x,Object];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> uploadReferenceElectrodeModelTests
	}
];

(* ::Subsubsection::Closed:: *)
(*newReferenceElectrodeModel*)

(*
	PACKET CREATOR
		- turns the resolved options into a new reference electrode model packet
		- ALSO looks for an existing model with EXACTLY the same electrode parameters
*)

newReferenceElectrodeModel[
	myReturnExistingModelBool:BooleanP,
	myAuthor:ObjectP[Object[User]],
	myAuthorNotebooks:{ObjectReferenceP[Object[LaboratoryNotebook]]...},
	myResolvedOptions:{_Rule..}
]:=Module[
	{
		upload, fieldRule, coated, searchConditions, possibleModels, possibleModelPackets, checkingPacket, identicalModelBools,

		(* Upload *)
		newReferenceElectrodeUploadPacket, existingMatchingModel
	},

	(* pull out the Upload option *)
	upload = Lookup[myResolvedOptions,Upload];

	(* == Do the search to get packets of all possible reference electrode models == *)

	(* set up the coated to be used in the search and upload packet *)
	coated = If[MatchQ[Lookup[myResolvedOptions, CoatMaterial], MaterialP],
		True,
		False
	];

	(* set up the searchConditions *)
	searchConditions = And[
		RecommendedSolventType == Lookup[myResolvedOptions, RecommendedSolventType],
		ReferenceSolution == Lookup[myResolvedOptions, ReferenceSolution],
		ReferenceCouplingSample == Lookup[myResolvedOptions, ReferenceCouplingSample],
		BulkMaterial == Lookup[myResolvedOptions, BulkMaterial],
		ElectrodeShape == Lookup[myResolvedOptions, ElectrodeShape],
		Coated == coated,

		(* just in case somehow we got no notebooks *)
		If[MatchQ[myAuthorNotebooks,{}],
			Or[
				Notebook==Null
			],
			Or[
				Notebook==Alternatives@@myAuthorNotebooks,
				Notebook==Null
			]
		],
		Deprecated!=True
	];

	(* Search for all possible models *)
	possibleModels = Search[Model[Item, Electrode, ReferenceElectrode], Evaluate[searchConditions]];

	(* Get the possible model packets *)
	possibleModelPackets = Download[possibleModels, Packet[
		ReferenceElectrodeType, Blank, RecommendedSolventType, ReferenceSolution, ReferenceCouplingSample, Preparable,
		SolutionVolume, Dimensions, DefaultStorageCondition, BulkMaterial, CoatMaterial, ElectrodeShape, ElectrodePackagingMaterial,
		WiringConnectors, WiringDiameters, WiringLength, MinPotential, MaxPotential, SonicationSensitive, WettedMaterials, IncompatibleMaterials
	]];

	(* == Check if any of the possible models exactly match with the current Model == *)
	(* Since we can use the helper function to check the physical parameters, we set up a checkingPacket for the current model *)
	checkingPacket = Association[
		ReferenceElectrodeType -> Lookup[myResolvedOptions, ReferenceElectrodeType],
		RecommendedSolventType -> Lookup[myResolvedOptions, RecommendedSolventType],
		Preparable -> Lookup[myResolvedOptions, Preparable],
		SolutionVolume -> Lookup[myResolvedOptions, SolutionVolume],
		Dimensions -> Lookup[myResolvedOptions, Dimensions],
		BulkMaterial -> Lookup[myResolvedOptions, BulkMaterial],
		CoatMaterial -> Lookup[myResolvedOptions, CoatMaterial],
		ElectrodeShape -> Lookup[myResolvedOptions, ElectrodeShape],
		ElectrodePackagingMaterial -> Lookup[myResolvedOptions, ElectrodePackagingMaterial],
		WiringConnectors -> Lookup[myResolvedOptions, WiringConnectors],
		WiringDiameters -> Lookup[myResolvedOptions, WiringDiameters],
		WiringLength -> Lookup[myResolvedOptions, WiringLength],
		MinPotential -> Lookup[myResolvedOptions, MinPotential],
		MaxPotential -> Lookup[myResolvedOptions, MaxPotential],
		WettedMaterials -> Lookup[myResolvedOptions, WettedMaterials],
		IncompatibleMaterials -> Lookup[myResolvedOptions, IncompatibleMaterials]
	];

	identicalModelBools = Map[
		Function[{possibleModelPacket},
			Module[{inconsistencyCheckResult, otherFieldsCheckResult},

				(* First we get the physical parameters checking result using the helper function *)
				inconsistencyCheckResult = checkFieldsInconsistency[
					checkingPacket,
					possibleModelPacket,
					{ReferenceElectrodeType, RecommendedSolventType, Preparable, SolutionVolume, Dimensions, BulkMaterial, CoatMaterial, ElectrodeShape, ElectrodePackagingMaterial, WiringConnectors, WiringDiameters, WiringLength, MinPotential, MaxPotential, WettedMaterials, IncompatibleMaterials},
					{},
					{},
					(* We use higher tolerance here so we can catch the models that are varied by a small amount, but can be viewed as the same model. *)
					2 * 10^-1 Milliliter,
					5 * 10^-1 Millimeter,
					10^0 Millivolt
				];

				(* Other fields *)
				otherFieldsCheckResult = And[
					(* Check SonicationSensitive *)
					(* need to use TrueQ on both sides because a Null and False are the same here *)
					TrueQ[Lookup[myResolvedOptions, SonicationSensitive]] === TrueQ[Lookup[possibleModelPacket, SonicationSensitive]],

					(* And we need to check field with links *)
					Download[Lookup[myResolvedOptions, Blank], Object] === Download[Lookup[possibleModelPacket, Blank], Object],
					Download[Lookup[myResolvedOptions, ReferenceSolution], Object] === Download[Lookup[possibleModelPacket, ReferenceSolution], Object],
					Download[Lookup[myResolvedOptions, ReferenceCouplingSample], Object] === Download[Lookup[possibleModelPacket, ReferenceCouplingSample], Object],
					Download[Lookup[myResolvedOptions, DefaultStorageCondition], Object] === Download[Lookup[possibleModelPacket, DefaultStorageCondition], Object]
				];

				(* Return the check result *)
				(* 1. If any values in inconsistencyCheckResult is True, the two models are not identical *)
				(* 2. If otherFieldsCheckResult is False, the two models are not identical *)
				And[
					(* Check the Values of inconsistencyCheckResult and see if it has True *)
					!MemberQ[Values[inconsistencyCheckResult], True],

					otherFieldsCheckResult
				]
			]
		],
		possibleModelPackets
	];

	(* Get the existingMatchingModel *)
	existingMatchingModel = If[!MatchQ[PickList[possibleModels, identicalModelBools, True], {}] && myReturnExistingModelBool,
		First[PickList[possibleModels, identicalModelBools, True]],
		Null
	];

	(* make a quick helper function that looks up an option value from the resolved options and makes a rule for the field;
	 	if option value is Boolean, make False be Null *)
	fieldRule[myFieldName_Symbol]:=Module[{optionValue},

		(* get the option value for this field name *)
		optionValue=Lookup[myResolvedOptions, myFieldName];

		(* if the option value is specifically False, make it Null; if it's a multiple field add replace *)

		If[MatchQ[optionValue, _List],

			(* If it's a multiple field *)
			Replace[myFieldName] -> optionValue,

			(* If it's not a multiple field *)
			myFieldName -> Which[
				MatchQ[optionValue,False], Null,
				MatchQ[optionValue,ObjectP[]], Link[optionValue],
				True, optionValue
			]
		]
	];

	newReferenceElectrodeUploadPacket = Association[
		Join[
			{
				Object -> CreateID[Model[Item, Electrode, ReferenceElectrode]],
				Type -> Model[Item, Electrode, ReferenceElectrode],
				Replace[Authors] -> Link[{myAuthor}],

				(* --- based on options and not EXACT match between field name and option --- *)
				Coated -> coated,

				Replace[Synonyms] -> If[MatchQ[Lookup[myResolvedOptions,Synonyms], {_String..}],
					Lookup[myResolvedOptions, Synonyms],
					{}
				],

				Replace[WiringDiameters] -> If[MatchQ[Lookup[myResolvedOptions,WiringDiameters], {DistanceP..}],
					Lookup[myResolvedOptions, WiringDiameters],
					{}
				],

				(* here we want False instead of Null for Preparable *)
				Preparable -> Lookup[myResolvedOptions, Preparable],

				(* Price *)
				Price -> Lookup[myResolvedOptions, Price],

				(* here we want False instead of Null for SonicationSensitive *)
				SonicationSensitive -> Lookup[myResolvedOptions, SonicationSensitive]
			},

			(* for ALL of these options, use a helper to churn out rules  *)
			fieldRule/@ {
				Name, ReferenceElectrodeType, Blank, RecommendedSolventType, ReferenceSolution, ReferenceCouplingSample, SolutionVolume, RecommendedRefreshPeriod, DefaultStorageCondition, Dimensions, BulkMaterial, CoatMaterial, ElectrodeShape, ElectrodePackagingMaterial, WiringConnectors, WiringLength, MaxNumberOfUses, MinPotential, MaxPotential, MaxNumberOfPolishings, WettedMaterials, IncompatibleMaterials
			}
		]
	];

	(* either return the new packet/object (depending on Upload) if we don't have an existing, or just return the existing if we have it *)
	If[MatchQ[existingMatchingModel,ObjectReferenceP[]],
		existingMatchingModel,
		If[upload,
			Upload[newReferenceElectrodeUploadPacket],
			newReferenceElectrodeUploadPacket
		]
	]
];

(* ::Subsubsection::Closed:: *)

(* Helper function to generate tests *)
referenceElectrodeTests[
	myInputs:{{(Test|Warning), _String, BooleanP}..}
]:=Module[{testHeads, textList, booleanList},

	(* Break up the inputs *)
	testHeads = myInputs[[All, 1]];
	textList = myInputs[[All, 2]];
	booleanList = myInputs[[All, 3]];

	MapThread[
		Function[{testHead, checkingBoolean, text},
			testHead[text,
				checkingBoolean,
				False
			]
		],
		{testHeads, booleanList, textList}
	]
];

(* ::Subsubsection::Closed:: *)

(* Helper function to check the fields of ReferenceSolution are all valid *)
(* 1. The Composition field has at least two non-Null entries *)
(* 2. The Solvent field is informed *)
(* 3. If the Solvent field contains the solvent sample, its Composition has the corresponding solvent molecule *)
(* 4. The Analytes field in ReferenceSolution is informed *)
(* 5. The Analytes field in ReferenceSolution has only one non-Null entry *)

checkReferenceSolutionValidity[myReferenceSolution:ObjectP[Model[Sample]], myCache:{PacketP[]..}]:=Module[
	{
		referenceSolutionPacket, solvent, analytesList, compositionField, composition, solventSample, solventMolecule, analyteMolecule, analyteMoleculeConcentration, analyteMoleculeDefaultSampleModel,
		analytesListEverything,
		(* Error checking booleans *)
		solutionLessThanTwoComponentsBool, solutionMissingSolventBool, solventSampleAmbiguousMoleculeBool, solutionMissingAnalyteBool, solutionAmbiguousAnalyteBool, analyteMoleculeMissingDefaultSampleModelBool
	},

	(* Fetch the reference solution packet *)
	referenceSolutionPacket = fetchPacketFromCache[myReferenceSolution, myCache];

	(* Look up the Solvent, Analytes, Composition fields *)
	{solvent, compositionField} = Lookup[referenceSolutionPacket, {Solvent, Composition}] /. {x:ObjectP[] :> Download[x, Object]};

	(* Get all the molecules in the composition *)
	analytesListEverything = Flatten[{Cases[compositionField[[All, 2]],ObjectP[Model[Molecule]]]}];

	(* If Potassium chloride is in compositionField, choose that as analytesList, otherwise use the Analytes field *)
	analytesList = ToList[If[MemberQ[analytesListEverything,Model[Molecule, "id:dORYzZJ3l3ap"]],
		Model[Molecule, "id:dORYzZJ3l3ap"],
		Lookup[referenceSolutionPacket,Analytes]/.(x:ObjectP[] :> Download[x, Object])
	]];

	(* Remove the quantities that we do not need *)
	composition = compositionField[[All, 2]] /. {Null -> Nothing};

	(* If the composition has less than 2 non-Null entries, set solutionLessThanTwoComponentsBool to True *)
	solutionLessThanTwoComponentsBool = If[
		LessQ[Length[composition], 2],
		True,
		False
	];

	(* If solvent is Null, set solutionMissingSolventBool to True *)
	solutionMissingSolventBool = If[
		MatchQ[solvent, Null],
		True,
		False
	];

	(* We try to get solventSample and solventMolecule from solvent *)
	If[
		!solutionMissingSolventBool,

		(* If the only member in the solventList is Model[Sample] *)
		Module[
			{
				solventSampleComposition
			},

			solventSampleComposition = Lookup[fetchPacketFromCache[solvent, myCache], Composition][[All, 2]] /. {Null -> Nothing};

			If[MatchQ[Length[solventSampleComposition], 1],
				solventMolecule = First[solventSampleComposition]  /. {x:ObjectP[] :> Download[x, Object]};
				solventSampleAmbiguousMoleculeBool = False,

				solventMolecule = Null;
				solventSampleAmbiguousMoleculeBool = True
			];
		],

		(* If any of the two previous errors are encountered, we set them to Null *)
		solventSample = Null;
		solventMolecule = Null;
		solventSampleAmbiguousMoleculeBool = False;
	];

	(* If analytesList is an empty list, set solutionMissingAnalyteBool to True *)
	solutionMissingAnalyteBool = If[
		MatchQ[Length[analytesList], 0],
		True,
		False
	];

	(* If analytesList has more than one non-Null entries, set solutionAmbiguousAnalyteBool to True *)
	solutionAmbiguousAnalyteBool = If[
		GreaterQ[Length[(analytesList /. {Null -> Nothing})], 1],
		True,
		False
	];

	(* Find out the analyteMolecule *)
	analyteMolecule = If[
		And[
			MatchQ[solutionMissingAnalyteBool, False],
			MatchQ[solutionAmbiguousAnalyteBool, False]
		],

		(* If no analyte-related errors were encountered, set the analyteMolecule *)
		First[analytesList],
		Null
	];

	(* Find out the analyteMoleculeConcentration *)
	analyteMoleculeConcentration = If[MatchQ[analyteMolecule, ObjectP[Model[Molecule]]],

		(* If analyteMolecule is successfully retrieved, we continue *)
		If[MemberQ[composition, analyteMolecule],

			(* If analyteMolecule is a member of the Composition, continue *)
			Module[{matchingEntry, concentration},

				(* Get the composition entry that has the analyteMolecule *)
				matchingEntry = Flatten[Select[compositionField, MatchQ[Last[#], analyteMolecule]&]];

				(* Get the concentration *)
				concentration = First[matchingEntry];

				(* Do a rounding so we won't have a too high precision *)
				Which[

					(* If the concentration has a molar unit *)
					MatchQ[concentration, ConcentrationP],
					SafeRound[concentration, 10^-1 Millimolar],

					(* If the concentration has a mass concentration unit *)
					MatchQ[concentration, ConcentrationP],
					SafeRound[concentration, 10^-1 Milligram / Liter],

					True,
					concentration
				]
			],

			(* If analyteMolecule is not a member of the Composition, return Null *)
			Null
		],

		(* Otherwise, return Null *)
		Null
	];

	(* Find out the DefaultSampleModel of analyteMolecule *)
	If[MatchQ[analyteMolecule, ObjectP[Model[Molecule]]],

		(* If analyteMolecule is successfully retrieved, look up the DefaultSampleModel in the cache *)
		Module[{defaultSampleModel},
			defaultSampleModel = Lookup[fetchPacketFromCache[analyteMolecule, myCache], DefaultSampleModel] /. {x:ObjectP[] :> Download[x, Object]};

			If[MatchQ[defaultSampleModel, ObjectP[Model[Sample]]],

				(* If defaultSampleModel is a valid sample model *)
				analyteMoleculeDefaultSampleModel = defaultSampleModel;
				analyteMoleculeMissingDefaultSampleModelBool = False,

				(* If defaultSampleModel is not a valid sample model *)
				analyteMoleculeDefaultSampleModel = Null;
				analyteMoleculeMissingDefaultSampleModelBool = True
			]
		],

		(* If analyteMolecule is not successfully retrieved, set analyteMoleculeDefaultSampleModel to Null and analyteMoleculeMissingDefaultSampleModelBool to False *)
		analyteMoleculeDefaultSampleModel = Null;
		analyteMoleculeMissingDefaultSampleModelBool = False
	];

	(* return the variables and error checking booleans *)
	{solventMolecule, analyteMolecule, analyteMoleculeConcentration, analyteMoleculeDefaultSampleModel, solutionLessThanTwoComponentsBool, solutionMissingSolventBool, solventSampleAmbiguousMoleculeBool, solutionMissingAnalyteBool, solutionAmbiguousAnalyteBool, analyteMoleculeMissingDefaultSampleModelBool}
];


(* ::Subsubsection::Closed:: *)

(* Helper function to replace Automatic options from template reference electrode model or blankModel *)\
(* First replace option values from template reference electrode model *)
(* Then replace option values from blankModel model *)
replacePhysicalParameterOptions[
	myRawOptionValues:_List,
	myOptionsNames:_List,
	templateReferenceElectrodePacket:PacketP[Model[Item, Electrode, ReferenceElectrode]]|Null,
	blankPacket:PacketP[Model[Item, Electrode, ReferenceElectrode]]|Null
]:=Module[{safeTemplatePacket, safeBlankPacket},

	(* If templateReferenceElectrodePacket is Null, set safeTemplatePacket to an empty association *)
	safeTemplatePacket = If[MatchQ[templateReferenceElectrodePacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],
		templateReferenceElectrodePacket,
		Association[]
	];

	(* If blankPacket is Null, set safeBlankPacket to an empty association *)
	safeBlankPacket = If[MatchQ[blankPacket, PacketP[Model[Item, Electrode, ReferenceElectrode]]],
		blankPacket,
		Association[]
	];

	MapThread[
		Function[{optionValue, optionName},
			Module[
				{templateValue, blankValue, replacedValue},

				(* get the values from template and blank. If any of them is Null, default to Automatic *)
				templateValue = Lookup[safeTemplatePacket, optionName, Automatic];
				blankValue = Lookup[safeBlankPacket, optionName, Automatic];

				(* get the replacedValue, first from templateValue and then from blankValue (if it is still Automatic) *)
				replacedValue = (optionValue /. {Automatic -> templateValue}) /. {Automatic -> blankValue};

				(* Assign the final replacedValue *)
				replacedValue
			]
		],
		{myRawOptionValues, myOptionsNames}
	]
];

(* ::Subsubsection::Closed:: *)

(* Helper function: checkFieldsInconsistency *)
(* This function is used to check if various fields in one packets are consistent with another packet *)
(* 1. Input: a source checking packet and a reference packet *)
(* 2. For identicalFields: the fields in identicalFields have to be the same with reference, otherwise return False *)
(* 3. For greaterEqualFields: the fields in greaterEqualFields have to be the greater or equal than the fields in reference packet, otherwise return False *)
(* 4. For lessEqualFields: the fields in lessEqualFields have to be the less or equal than the fields in reference packet, otherwise return False *)
(* 5. Volume fields will be SafeRounded with volumePrecision and RoundAmbiguous -> Up before comparison *)
(* 6. Dimension fields will be SafeRounded with dimensionPrecision and RoundAmbiguous -> Up before comparison *)

checkFieldsInconsistency[
	myCheckPacket:_Association,
	myReferencePacket:PacketP[],
	equalFields:{_Symbol...},
	greaterEqualFields:{_Symbol...},
	lessEqualFields:{_Symbol...},
	volumePrecision:Alternatives[VolumeP, None],
	dimensionPrecision:Alternatives[DistanceP, None],
	voltagePrecision:Alternatives[VoltageP, None]
]:=Module[
	{
		outputAssociation
	},

	(* Check the fields *)
	outputAssociation = Association[Map[
		Function[{field},
			Module[
				{
					sourceValue,
					sourceValueRounded,
					referenceValue,
					referenceValueRounded,
					checkResult
				},

				(* Field lookup *)
				sourceValue = Lookup[myCheckPacket, field];
				referenceValue = Lookup[myReferencePacket, field];

				(* Perform the unit conversion and rounding *)
				{sourceValueRounded, referenceValueRounded} = If[
					MatchQ[#, Alternatives[ListableP[VolumeP], ListableP[DistanceP], ListableP[VoltageP]]],
					(* If the value is an array with units, we perform the conversion and rounding *)
					Module[{},
						(* Further check which type of array this value is *)
						Which[

							(* If the value is a value or a list of volumes *)
							MatchQ[#, ListableP[VolumeP]],
							SafeRound[UnitConvert[N[#], Milliliter], volumePrecision, RoundAmbiguous -> Up],

							(* If the value is a value or a list of distances *)
							MatchQ[#, ListableP[DistanceP]],
							SafeRound[UnitConvert[N[#], Millimeter], dimensionPrecision, RoundAmbiguous -> Up],

							(* If the value is a value or a list of voltages *)
							MatchQ[#, ListableP[VoltageP]],
							SafeRound[UnitConvert[N[#], Millivolt], voltagePrecision, RoundAmbiguous -> Up]
						]
					],

					(* If the value is not an array with units, we directly return the input value *)
					#
				]&/@{sourceValue, referenceValue};

				(* Perform the check, if the valueRounded is still Automatic, we skip the checking and set the checkResult as False *)
				checkResult = If[!MatchQ[sourceValueRounded, Automatic],

					(* If the sourceValueRounded is not Automatic, we continue with the check *)
					Which[

						(* If the field is a member of the equalFields *)
						MemberQ[equalFields, field],
						Not[MatchQ[sourceValueRounded, referenceValueRounded]],

						(* If the field is a member of the greaterEqualFields *)
						MemberQ[greaterEqualFields, field],
						Not[GreaterEqualQ[sourceValueRounded, referenceValueRounded]],

						(* If the field is a member of the lessEqualFields *)
						MemberQ[lessEqualFields, field],
						Not[LessEqualQ[sourceValueRounded, referenceValueRounded]]
					],

					(* If the sourceValueRounded is Automatic, we return False directly *)
					False
				];

				(* Return the check result *)
				field -> checkResult
			]
		],
		Join[equalFields, greaterEqualFields, lessEqualFields]
	]]
];