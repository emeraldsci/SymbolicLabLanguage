(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*UploadSampleModel*)

DefineUsage[UploadSampleModel,
	{
		BasicDefinitions -> {
			(* Mixed input overload for implementation *)
			{
				Definition -> {"UploadSampleModel[inputs]", "sampleModel"},
				Description -> "creates new or updates existing 'sampleModel's that contains the information for creating sample objects.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "inputs",
							Description -> "The new compositions, identifiers and/or existing objects that should be updated with information given about the sample model.",
							Widget -> Alternatives[
								Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
								uploadSampleModelCompositionWidget[],
								moleculeNameWidget[],
								pubChemWidget[],
								inchiWidget[],
								inchiKeyWidget[],
								casWidget[],
								thermoWidget[],
								sigmaWidget[]
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


			(* New object from Composition *)
			{
				Definition -> {"UploadSampleModel[sampleComposition]", "sampleModel"},
				Description -> "creates a new model 'sampleModel' that contains the information for creating sample objects with the specified 'composition'.",
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
				Description -> "creates a new model 'sampleModel' that contains the information for creating sample objects composed of pure 'moleculeIdentifier'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "moleculeIdentifier",
							Description -> "An identifier that uniquely describes a molecule.",
							Widget -> Alternatives[
								moleculeNameWidget[],
								pubChemWidget[],
								inchiWidget[],
								inchiKeyWidget[],
								casWidget[],
								thermoWidget[],
								sigmaWidget[]
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
			},


			(* Modify existing object overload *)
			{
				Definition -> {"UploadSampleModel[existingSampleModel]", "updatedSampleModel"},
				Description -> "updates an existing sample model, 'existingSampleModel', that contains the information for creating sample objects.",
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
			}
		},
		MoreInformation -> {
			"If updating the Composition of a Model[Sample], the compositions of all linked Object[Sample]'s will also be updated. The date in the components of the composition will have the date of when UploadSampleModel is executed.",
			"If a molecular identifier is specified in the input, UploadSampleModel will check for matching Model[Molecule]s in Constellation. If a molecule is not found, UploadSampleModel will attempt to create one using UploadMolecule with default options. This may not be successful if UploadMolecule cannot automatically determine all the required information. In that case please use UploadMolecule directly to create the Model[Molecule] first and provide the requested information."
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
];