(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentSerialDilute*)


DefineUsage[ExperimentSerialDilute,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentSerialDilute[samples]", "protocol"},
				Description -> "generates a 'protocol' to perform a series of dilutions iteratively by mixing samples with diluent, and transferring to another container of diluent.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "samples",
							Description -> "The samples to be iteratively diluted.",
							Widget ->
										Widget[
											Type -> Object,
											Pattern :> ObjectP[{Object[Sample], Object[Container]}],
											Dereference -> {
												Object[Container] -> Field[Contents[[All, 2]]]
												}
										],

							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "protocol",
						Description -> "A protocol containing instructions for completion of the requested sample serial dilution.",
						Pattern :> ObjectP[Object[Protocol, ManualSamplePreparation]]|ObjectP[Object[Protocol, RoboticSamplePreparation]]
					}
				}
			}

		},
		MoreInformation -> {
			
		},
		SeeAlso -> {
			"ValidExperimentSerialDiluteQ",
			"ExperimentSerialDiluteOptions",
			"ExperimentDilute",
			"ExperimentAliquot",
			"ExperimentResuspend",
			"ExperimentTransfer",
			"ExperimentSamplePreparation"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];