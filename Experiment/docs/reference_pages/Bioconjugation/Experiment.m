(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentBioconjugation*)
DefineUsage[ExperimentBioconjugation,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentBioconjugation[SamplePools, NewIdentityModels]", "Protocol"},
				Description -> "generates a 'Protocol' object to covalently bind 'SamplePools' through chemical crosslinking to create a sample composed of 'NewIdentityModels'. Bioconjugation reactions are a restricted form of synthesis where conjugations: 1) occur in aqueous solution, 2) occur at atmospheric conditions, 3) are low volume, 4) do not require slow addition of reagents, 5) and do not require reaction monitoring.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "SamplePools",
							Description -> "The samples to be chemically linked together into a pool.",
							Widget -> Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
									}
								]
							],
							Expandable -> False,
							NestedIndexMatching->True
						},
						{
							InputName -> "NewIdentityModels",
							Description -> "The models of the resulting conjugated molecule in each pool.",
							Widget ->
									Widget[
										Type -> Object,
										Pattern :> ObjectP[IdentityModelTypes]
									],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol object that describes the series of transfers and incubations necessary to chemically link the 'SamplePools' to create conjugated molecules characterized by 'NewIdentityModels'.",
						Pattern :> ObjectP[Object[Protocol, Bioconjugation]]
					}
				}
			}
		},
		MoreInformation -> {
			"ExperimentSamplePreparation is used to accomplish all experiment transfers and incubations."
		},
		SeeAlso -> {
			"ValidExperimentBioconjguationQ",
			"ExperimentBioconjguationOptions",
			"ExperimentBioconjugationPreview",
			"ExperimentSolidPhaseExtraction",
			"ExperimentDialysis",
			"ExperimentPellet",
			"ExperimentFilter"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {"jireh.sacramento", "xu.yi", "steven", "cgullekson", "millie.shah"}
	}
];