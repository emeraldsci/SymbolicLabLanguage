

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentFlowCytometry*)

DefineUsage[ExperimentFlowCytometry,{
	BasicDefinitions -> {{
		Definition -> {"ExperimentFlowCytometry[Samples]","Protocol"},
		Description -> "generates a 'Protocol' to anaylze 'Samples' via flow cytometry.",
		Inputs :> {
			IndexMatching[
				{
					InputName -> "Samples",
					Description -> "The samples which should be injected into a flow cytometer and analyzed.",
					Expandable -> False,
					Widget -> Alternatives[
						"Sample or Container"->Widget[
							Type -> Object,
							Pattern :> ObjectP[{Object[Sample], Object[Container]}],
							ObjectTypes -> {Object[Sample], Object[Container]},
							Dereference -> {
								Object[Container] -> Field[Contents[[All, 2]]]
							}
						],
						"Container with Well Position"->{
							"Well Position" -> Alternatives[
								"A1 to P24" -> Widget[
									Type -> Enumeration,
									Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
									PatternTooltip -> "Enumeration must be any well from A1 to H12."
								],
								"Container Position" -> Widget[
									Type -> String,
									Pattern :> LocationPositionP,
									PatternTooltip -> "Any valid container position.",
									Size->Line
								]
							],
							"Container" -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Container]}]
							]
						}
					]
				},
				IndexName -> "experiment samples"
			]
		},
		Outputs :> {
			{
				OutputName -> "Protocol",
				Description -> "A protocol object that describes the flow cytometry experiment to be run.",
				Pattern :> ObjectP[Object[Protocol, FlowCytometry]]
			}
		}
	}},
	MoreInformation -> {
		"If the input samples are not in compatible containers, aliquots will automatically be transferred to appropriate containers of Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]."
	},
	SeeAlso -> {
		"ExperimentFlowCytometryOptions",
		"ValidExperimentFlowCytometryQ",
		"ExperimentImageCells"
	},
	Author -> {"ryan.bisbey", "dirk.schild", "josh.kenchel", "cgullekson"}
}];


(* ::Subsubsection:: *)
(*ExperimentFlowCytometryOptions*)

DefineUsage[ExperimentFlowCytometryOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentFlowCytometryOptions[Objects]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentFlowCytometryOptions when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The analyte samples which should be injected flow cytometer and analyzed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description -> "Resolved options when ExperimentFlowCytometryOptions is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentFlowCytometryOptions if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentFlowCytometry",
			"ExperimentFlowCytometryPreview",
			"ValidExperimentFlowCytometryQ",
			"ExperimentImageCells"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ryan.bisbey", "dirk.schild", "josh.kenchel", "cgullekson"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentFlowCytometryPreview*)

DefineUsage[ExperimentFlowCytometryPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentFlowCytometryPreview[Objects]","Preview"},
				Description -> "returns the preview for ExperimentFlowCytometry when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The analyte samples which should be injected into a flow cytometer and analyzed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description -> "Graphical preview representing the output of ExperimentFlowCytometry. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFlowCytometry",
			"ExperimentFlowCytometryOptions",
			"ValidExperimentFlowCytometryQ",
			"ExperimentImageCells"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ryan.bisbey", "dirk.schild", "josh.kenchel", "cgullekson"}
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentFlowCytometryQ*)

DefineUsage[ValidExperimentFlowCytometryQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentFlowCytometryQ[Objects]","Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentFlowCytometry.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The analyte samples which should be injected into a flow cytometer and analyzed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentFlowCytometry call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFlowCytometry",
			"ExperimentFlowCytometryOptions",
			"ExperimentFlowCytometryPreview",
			"ExperimentImageCells"

		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ryan.bisbey", "dirk.schild", "josh.kenchel", "cgullekson"}
	}
];