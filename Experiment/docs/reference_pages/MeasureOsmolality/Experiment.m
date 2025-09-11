(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureOsmolality*)

DefineUsage[ExperimentMeasureOsmolality,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentMeasureOsmolality[Objects]","Protocol"},
				Description->"creates a MeasureOsmolality 'Protocol' which determines the osmolality of 'objects'. Osmolality is a measure of the concentration of osmotically active species in a solution.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Objects",
							Description->"The samples or containers for whose contents the osmolality will be measured.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
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
						OutputName->"Protocol",
						Description->"The protocol object(s) describing how to run the MeasureOsmolality experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,MeasureOsmolality]]]
					}
				}
			}
		},
		MoreInformation->{
			"Currently, vapor pressure osmometry (VPO) by determining dew point temperature depression using a hygrometric thermocouple is the only method supported."
		},
		SeeAlso->{
			"ExperimentMeasureOsmolalityOptions",
			"ValidExperimentMeasureOsmolalityQ",
			"ExperimentMeasureWeight",
			"ExperimentMeasureVolume",
			"ExperimentMassSpectrometry",
			"ExperimentMeasureConductivity"
		},
		Author->{"david.ascough", "dirk.schild"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureOsmolalityOptions*)

DefineUsage[ExperimentMeasureOsmolalityOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentMeasureOsmolalityOptions[Objects]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentMeasureOsmolality when it is called on 'objects'.",
						Inputs:>{
					IndexMatching[
						{
							InputName->"Objects",
							Description->"The samples or containers for whose solutions the osmolality will be measured.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
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
						Description->"Resolved options when ExperimentMeasureOsmolality is called on the input objects.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"This function returns the resolved options that would be fed to ExperimentMeasureOsmolality if it were called on these input objects."
		},
		SeeAlso->{
			"ExperimentMeasureOsmolality",
			"ValidExperimentMeasureOsmolalityQ"
		},
		Author->{"david.ascough", "dirk.schild"}
	}
];




(* ::Subsubsection::Closed:: *)
(*ValidExperimentMeasureOsmolalityQ*)


DefineUsage[ValidExperimentMeasureOsmolalityQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentMeasureOsmolalityQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentMeasureOsmolality.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentMeasureOsmolality call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMeasureOsmolality",
			"ExperimentMeasureOsmolalityOptions"
		},
		Author -> {"david.ascough", "dirk.schild"}
	}
];

DefineUsage[ExperimentMeasureOsmolalityPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureOsmolalityPreview[Samples]", "Preview"},
				Description -> "returns a preview of the assay defined for 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A preview of the ExperimentMeasureOsmolality output.  Return value can be changed via the OutputFormat option.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMeasureOsmolality",
			"ExperimentMeasureOsmolalityOptions"
		},
		Author -> {"david.ascough", "dirk.schild"}
	}
];