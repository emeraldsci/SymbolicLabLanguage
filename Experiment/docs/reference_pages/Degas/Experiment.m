(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentDegas*)


(* ::Subsubsection:: *)
(*ExperimentDegas Usage*)


DefineUsage[ExperimentDegas,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentDegas[Samples]","Protocol"},
				Description->"generates a 'Protocol' which can use a variety of different techniques (freeze-pump-thaw, sparging, or vacuum degassing) to remove dissolved gases from liquid 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples or containers whose contents are to be degassed during the protocol.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object(s) describing how to run the Degas experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,Degas]]]
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ValidExperimentDegasQ",
			"ExperimentDegasOptions",
			"ExperimentDegasPreview",
			"ExperimentFlashFreeze",
			"ExperimentUVMelting",
			"ExperimentHPLC"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"eunbin.go", "axu", "boris.brenerman", "cgullekson", "marie.wu"}
	}
];