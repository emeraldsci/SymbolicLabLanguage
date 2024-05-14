(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMagneticBeadSeparation*)


DefineUsage[ExperimentMagneticBeadSeparation,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentMagneticBeadSeparation[Samples]","Protocol"},
				Description->"creates a 'Protocol' for isolating targets from 'Samples' via magnetic bead separation, which uses a magnetic field to separate superparamagnetic particles from suspensions.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The crude samples for separation.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->True,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the magnetic bead separation experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,MagneticBeadSeparation]]]
					}
				}
			}
		},
		MoreInformation->{
			"Samples for this experiment can be pooled by loading samples in the same pool sequentially to the same magnetic beads.",
			"    - To indicate that samples should be pooled, wrap the corresponding input samples in additional curly brackets, e.g. {{s1,s2},{s3,s4}}.",
			"    - Providing samples or vessels in a flat list indicates that each sample should be processed individually and not be pooled.",
			"    - Providing samples in a plate (e.g. myPlate or {myPlate}) indicates that each sample in the plate should be processed individually. If you wish to pool all samples in the plate, wrap the plate in additional curly brackets, (e.g. {{myPlate}})."
		},
		SeeAlso->{
			"ExperimentMagneticBeadSeparationOptions",
			"ExperimentMagneticBeadSeparationPreview",
			"ValidExperimentMagneticBeadSeparationQ",
			"ExperimentSolidPhaseExtraction"
		},
		Author->{"yanzhe.zhu", "melanie.reschke", "harrison.gronlund", "marie.wu", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMagneticBeadSeparationOptions*)


DefineUsage[ExperimentMagneticBeadSeparationOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentMagneticBeadSeparationOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentMagneticBeadSeparation when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The crude samples for separation.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options when ExperimentMagneticBeadSeparation is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentMagneticBeadSeparation",
			"ExperimentMagneticBeadSeparationPreview",
			"ValidExperimentMagneticBeadSeparationQ"
		},
		Author->{"yanzhe.zhu", "melanie.reschke", "harrison.gronlund", "marie.wu", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMagneticBeadSeparationPreview*)


DefineUsage[ExperimentMagneticBeadSeparationPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentMagneticBeadSeparationPreview[Samples]","Preview"},
				Description->"returns the graphical preview for ExperimentMagneticBeadSeparation when it is called on 'Samples'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The crude samples for separation.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"The graphical preview representing the output of ExperimentMagneticBeadSeparation. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentMagneticBeadSeparation",
			"ExperimentMagneticBeadSeparationOptions",
			"ValidExperimentMagneticBeadSeparationQ"
		},
		Author->{"yanzhe.zhu", "melanie.reschke", "harrison.gronlund", "marie.wu", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentMagneticBeadSeparationQ*)


DefineUsage[ValidExperimentMagneticBeadSeparationQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentMagneticBeadSeparationQ[Samples]","Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentMagneticBeadSeparation.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The crude samples for separation.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{Object[Container]->Field[Contents[[All,2]]]}
							],
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"The value indicating whether the ExperimentMagneticBeadSeparation call is valid. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentMagneticBeadSeparation",
			"ExperimentMagneticBeadSeparationOptions",
			"ExperimentMagneticBeadSeparationPreview"
		},
		Author->{"yanzhe.zhu", "melanie.reschke", "harrison.gronlund", "marie.wu", "eqian"}
	}
];