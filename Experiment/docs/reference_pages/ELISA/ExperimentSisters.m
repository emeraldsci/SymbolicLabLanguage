(* ::Subsubsection::Closed:: *)
(*ExperimentELISAOptions*)
DefineUsage[ExperimentELISAOptions,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentELISAOptions[Samples]","ResolvedOptions"},
			Description->"returns the resolved options for ExperimentELISA when it is called on",
			Inputs:> {
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
						Widget->Alternatives[
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
							},
							"Model Sample"->Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample]],
								ObjectTypes -> {Model[Sample]}
							]
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"ResolvedOptions",
					Description->"Resolved options when ExperimentELISA is called on the input samples and antibodies.",
					Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
				}
			}
		}
	},

	SeeAlso->{
		"ValidExperimentELISAQ",
		"ExperimentELISAOptions",
		"ExperimentWestern",
		"ExperimentTotalProteinQuantification",
		"ExperimentSamplePreparation"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"harrison.gronlund", "taylor.hochuli", "xiwei.shan"}
}];

(* ::Subsubsection::Closed:: *)
(*ExperimentELISAPreview*)
DefineUsage[ExperimentELISAPreview,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentELISAPreview[Samples]","Preview"},
			Description->"returns the graphical preview for ExperimentELISA when it is called on 'Samples'.  This output is always Null.",
			Inputs:> {
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
						Widget->Alternatives[
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
							},
							"Model Sample"->Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample]],
								ObjectTypes -> {Model[Sample]}
							]
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Preview",
					Description->"Graphical preview representing the output of ExperimentELISA.  This value is always Null.",
					Pattern:>Null
				}
			}
		}
	},
	SeeAlso->{
		"ValidExperimentELISAQ",
		"ExperimentELISAOptions",
		"ExperimentWestern",
		"ExperimentTotalProteinQuantification",
		"ExperimentSamplePreparation"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"harrison.gronlund", "taylor.hochuli", "xiwei.shan"}
}];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentELISAQ*)
DefineUsage[ValidExperimentELISAQ,{

	BasicDefinitions->{
		{
			Definition->{"ValidExperimentELISAQ[Samples]","Boolean"},
			Description->"checks whether the provided inputs and specified options are valid for calling ExperimentELISA.",
			Inputs:> {
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be analyzed using ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
						Widget->Alternatives[
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
							},
							"Model Sample"->Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample]],
								ObjectTypes -> {Model[Sample]}
							]
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Boolean",
					Description->"Whether or not the ExperimentELISA call is valid. Return value can be changed via the OutputFormat option.",
					Pattern:>_EmeraldTestSummary|BooleanP
				}
			}
		}
	},
	SeeAlso->{
		"ValidExperimentELISAQ",
		"ExperimentELISAOptions",
		"ExperimentWestern",
		"ExperimentTotalProteinQuantification",
		"ExperimentSamplePreparation"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"harrison.gronlund", "taylor.hochuli", "xiwei.shan"}
}];