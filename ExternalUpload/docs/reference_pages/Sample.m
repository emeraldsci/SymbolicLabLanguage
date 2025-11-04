(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*UploadSampleModel*)

With[
	{
		(* Input widgets - must be := to generate a unique identifier each time it's inserted *)
		moleculeNameWidget := Widget[Type -> String, Pattern :> _String, Size -> Line, PatternTooltip -> "The common or internal name of this chemical."],
		pubChemWidget := Widget[
			Type -> Expression,
			Pattern :> Alternatives[GreaterEqualP[1, 1], _PubChem],
			Size -> Line,
			PatternTooltip -> "Enter the PubChem ID of the chemical to upload, as an integer or wrapped in a PubChem[...] head. (e.g. PubChem[679] is the ID of DMSO)."
		],
		inchiWidget := Widget[
			Type -> String,
			Pattern :> InChIP,
			Size -> Paragraph,
			PatternTooltip -> "The InChI of a molecule is a string that begins with InChI=."
		],
		inchiKeyWidget := Widget[
			Type -> String,
			Pattern :> InChIKeyP,
			Size -> Line,
			PatternTooltip -> "The InChIKey of this molecule, which is in the format of **************-**********-N where * is any uppercase letter."
		],
		casWidget := Widget[
			Type -> String,
			Pattern :> CASNumberP,
			Size -> Line,
			PatternTooltip -> "The CAS registry number of a molecule is a unique identifier specified by the American Chemical Society (ACS). CAS Numbers consist of 3 groups of digits, the first containing 2-7 digits, the second containing 2 digits and the final containing 1 digit, separated by hyphens. CAS numbers therefore range from **-**-* to *******-**-* where * is a digit character."
		],
		thermoWidget := Widget[
			Type -> String,
			Pattern :> ThermoFisherURLP,
			Size -> Paragraph,
			PatternTooltip -> "The URL of the ThermoFisher product page for a product of the required sample type."
		],
		sigmaWidget := Widget[
			Type -> String,
			Pattern :> MilliporeSigmaURLP,
			Size -> Paragraph,
			PatternTooltip -> "The URL of the Millipore Sigma product page for a product of the required sample type."
		]
	},
	DefineUsage[UploadSampleModel,
		{
			BasicDefinitions -> {
				(* Mixed input overload for implementation *)
				{
					Definition -> {"UploadSampleModel[inputs]", "sampleModel"},
					Description -> "creates/updates a 'sampleModel' that contains the template information for creating samples.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "inputs",
								Description -> "The new names and/or existing objects that should be updated with information given about the sample model.",
								Widget -> Alternatives[
									Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
									Widget[Type -> String, Pattern :> _String, Size -> Line],
									uploadSampleModelCompositionWidget[],
									moleculeNameWidget,
									pubChemWidget,
									inchiWidget,
									inchiKeyWidget,
									casWidget,
									thermoWidget,
									sigmaWidget
								]
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "sampleModel",
							Description -> "The created or updated sample models.",
							Pattern :> ObjectP[Model[Sample]]
						}
					},
					(* Hidden definition to call our functions with (ValidInputLengthsQ, etc.) *)
					CommandBuilder -> False
				},


				(* New object overload *)
				{
					Definition -> {"UploadSampleModel[sampleModelName]", "sampleModel"},
					Description -> "creates a new model 'sampleModel' that contains the template information for creating samples.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "sampleModelName",
								Description -> "The common name to describe this sample model and identify it in Constellation.",
								Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line]
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "sampleModel",
							Description -> "The new object containing the specified information about the new sample model.",
							Pattern :> ObjectP[Model[Sample]]
						}
					}
				},

				(* Modify existing object overload *)
				{
					Definition -> {"UploadSampleModel[existingSampleModel]", "updatedSampleModel"},
					Description -> "updates an existing sample model, 'existingSampleModel', that contains the template information for creating samples.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "existingSampleModel",
								Description -> "The existing Model[Sample] object that should be updated.",
								Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]], PreparedSample -> False, PreparedContainer -> False]
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "updatedSampleModel",
							Description -> "The updated Model[Sample].",
							Pattern :> ObjectP[Model[Sample]]
						}
					}
				},

				(* New object from Composition *)
				{
					Definition -> {"UploadSampleModel[sampleComposition]", "sampleModel"},
					Description -> "creates a new model 'sampleModel' that contains the template information for creating samples with the specified 'composition'.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "sampleComposition",
								Description -> "The components and relative amounts that constitute samples of this model.",
								Widget -> uploadSampleModelCompositionWidget[]
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "sampleModel",
							Description -> "The new object containing the specified information about the new sample model.",
							Pattern :> ObjectP[Model[Sample]]
						}
					}
				},

				(* New object identifier overload *)
				{
					Definition -> {"UploadSampleModel[moleculeIdentifier]", "sampleModel"},
					Description -> "creates a new model 'sampleModel' that contains the template information for creating samples described by 'moleculeIdentifier'.",
					Inputs :> {
						IndexMatching[
							{
								InputName -> "moleculeIdentifier",
								Description -> "An identifier that uniquely describes a molecule.",
								Widget -> Alternatives[
									moleculeNameWidget,
									pubChemWidget,
									inchiWidget,
									inchiKeyWidget,
									casWidget,
									thermoWidget,
									sigmaWidget
								]
							},
							IndexName -> "Input Data"
						]
					},
					Outputs :> {
						{
							OutputName -> "sampleModel",
							Description -> "The new object containing the specified information about the new sample model.",
							Pattern :> ObjectP[Model[Sample]]
						}
					}
				}
			},
			MoreInformation -> {
				"If updating the Composition of a Model[Sample], the compositions of all linked Object[Sample]'s will also be updated. The date in the components of the composition will have the Date of when UploadSampleModel is executed."
			},
			SeeAlso -> {
				"UploadMolecule",
				"UploadOligomer",
				"UploadProtein",
				"UploadAntibody",
				"UploadCarbohydrate"
			},
			Author -> {
				"david.ascough"
			}
		}
	]
];