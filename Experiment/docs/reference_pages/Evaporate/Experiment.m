(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentEvaporate*)


(* ::Subsubsection:: *)
(*ExperimentEvaporate*)


DefineUsage[ExperimentEvaporate,
	{
		BasicDefinitions-> {
			{
				Definition->{"ExperimentEvaporate[Samples]","Protocol"},
				Description->"generates a 'Protocol' that will evaporate solvent and condense the 'Samples' through vacuum pressure or nitrogen blow down at elevated temperatures using requested instruments such as rotovaps, speedvacs, or nitrogen blowers.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers holding the samples that will be concentrated by evaporation.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Container,Plate],Object[Container,Vessel],Object[Sample]}],
								Dereference -> {Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"A protocol to concentrate samples by  evaporation.",
						Pattern:>ObjectP[Object[Protocol,Evaporate]]
					}
				}
			}
		},
		MoreInformation -> {
			"ExperimentEvaporate allows for the option to EvaporateUntilDry, which runs the protocol until samples are dry (up to three consecutive rounds)."
		},
		SeeAlso->{
			"ValidExperimentEvaporateQ",
			"ExperimentEvaporateOptions",
			"ExperimentCentrifuge",
			"ExperimentDNASynthesis",
			"ExperimentPNASynthesis",
			"ExperimentHPLC"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"dima", "steven", "simon.vu", "axu", "wyatt", "stacey.lee", "sarah"}
	}
];