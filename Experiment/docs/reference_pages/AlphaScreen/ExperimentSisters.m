(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentAlphaScreenOptions*)

DefineUsage[ExperimentAlphaScreenOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAlphaScreenOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentAlphaScreen when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that have analytes with acceptor and donor beads ready for luminescent AlphaScreen measurement.",
							Widget -> Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Object[Container]}],ObjectTypes->{Object[Sample],Object[Container]}],
							Expandable -> False,
							Dereference -> {Object[Container]->Field[Contents[[All,2]]]}
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentAlphaScreen is called on 'Samples'.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentAlphaScreen",
			"ExperimentAlphaScreenPreview",
			"ValidExperimentAlphaScreenQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"eunbin.go", "jihan.kim", "fan.wu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentAlphaScreenPreview*)


DefineUsage[ExperimentAlphaScreenPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAlphaScreenPreview[Samples]","Preview"},
				Description->"returns the graphical preview for ExperimentAlphaScreen when it is called on 'Samples'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that have analytes with acceptor and donor beads ready for luminescent AlphaScreen measurement.",
							Widget -> Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Object[Container]}],ObjectTypes->{Object[Sample],Object[Container]}],
							Expandable -> False,
							Dereference -> {Object[Container]->Field[Contents[[All,2]]]}
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentAlphaScreen. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentAlphaScreen",
			"ExperimentAlphaScreenOptions",
			"ValidExperimentAlphaScreenQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"eunbin.go", "jihan.kim", "fan.wu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentAlphaScreenQ*)


DefineUsage[ValidExperimentAlphaScreenQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentAlphaScreenQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentAlphaScreen.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that have analytes with acceptor and donor beads ready for luminescent AlphaScreen measurement.",
							Widget -> Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Object[Container]}],ObjectTypes->{Object[Sample],Object[Container]}],
							Expandable -> False,
							Dereference -> {Object[Container]->Field[Contents[[All,2]]]}
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "Booleans",
						Description -> "Checks whether the provided 'Samples' and specified options are valid for calling ExperimentAlphaScreen.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentAlphaScreen",
			"ExperimentAlphaScreenPreview",
			"ExperimentAlphaScreenOptions"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"eunbin.go", "jihan.kim", "fan.wu"}
	}
];