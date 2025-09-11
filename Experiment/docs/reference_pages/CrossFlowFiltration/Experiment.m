(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentCrossFlowFiltration*)


DefineUsage[ExperimentCrossFlowFiltration,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentCrossFlowFiltration[Samples]","Protocol"},
				Description -> "creates a 'Protocol' to filter the provided sample or container 'Samples' using cross flow filtration.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The sample or container whose contents are to be filtered during the protocol.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
											PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
						OutputName -> "Protocol",
						Description -> "Protocol generated to filter the input objects with cross flow filtration.",
						Pattern :> ListableP[ObjectP[Object[Protocol,CrossFlowFiltration]]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ValidExperimentCrossFlowFiltrationQ",
			"ExperimentCrossFlowFiltrationOptions",
			"PlotCrossFlowFiltration",
			"ExperimentFilter",
			"ExperimentDialysis"
		},
		Author -> {"harrison.gronlund", "weiran.wang", "gil.sharon", "gokay.yamankurt"}
	}];

(* ::Subsubsection::Closed:: *)

DefineUsage[ValidExperimentCrossFlowFiltrationQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentCrossFlowFiltrationQ[Samples]","Boolean"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentCrossFlowFiltration.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The sample or container whose contents are to be filtered during the protocol.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
						OutputName -> "Boolean",
						Description -> "Whether or not the ExperimentCrossFlowFiltration call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentCrossFlowFiltration",
			"ExperimentCrossFlowFiltrationOptions",
			"ExperimentFilter",
			"ExperimentDialysis"
		},
		Author -> {"harrison.gronlund", "weiran.wang", "gil.sharon", "gokay.yamankurt"}
	}];

(* ::Subsubsection::Closed:: *)

DefineUsage[ExperimentCrossFlowFiltrationOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCrossFlowFiltrationOptions[Samples]","ResolvedOptions"},
				Description->"outputs the resolved options of ExperimentCrossFlowFiltration with the provided inputs and specified options.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The sample or container whose contents are to be filtered during the protocol.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
						Description->"Resolved options when ExperimentCrossFlowFiltration is called on the input sample(s).",
						Pattern:>_List
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentCrossFlowFiltration",
			"ValidExperimentCrossFlowFiltrationQ",
			"ExperimentFilter",
			"ExperimentDialysis"
		},
		Author->{"harrison.gronlund", "weiran.wang", "gil.sharon", "gokay.yamankurt"}
	}
];

(* ::Subsubsection::Closed:: *)

DefineUsage[ExperimentCrossFlowFiltrationPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCrossFlowFiltrationPreview[Samples]","Preview"},
				Description->"currently ExperimentCrossFlowFiltration does not have a preview.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The sample or container whose contents are to be filtered during the protocol.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentCrossFlowFiltration. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentCrossFlowFiltration",
			"ValidExperimentCrossFlowFiltrationQ",
			"ExperimentCrossFlowFiltrationOptions",
			"ExperimentFilter",
			"ExperimentDialysis"
		},
		Author->{"harrison.gronlund", "weiran.wang", "gil.sharon", "gokay.yamankurt"}
	}
];




(* ::Subsubsection::Closed:: *)

(*CrossFlowFiltration*)

DefineUsage[CrossFlowFiltration,
	{
		BasicDefinitions -> {
			{
				Definition -> {"CrossFlowFiltration[Options]","UnitOperation"},
				Description -> "generates an ExperimentSamplePreparation-compatible 'UnitOperation' that filter the provided sample by flowing it parallel-wise to the membrane surface.",
				Inputs :> {
					{
						InputName -> "options",
						Description-> "The options that specify the sample and other experimental parameters for the cross flow filtration.",
						Widget->Widget[
							Type -> Expression,
							Pattern :> {_Rule..},
							Size -> Line
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName -> "UnitOperation",
						Description -> "The unit operation that represents this measurement.",
						Pattern :> _List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentCrossFlowFiltration",
			"ExperimentSamplePreparation",
			"Experiment"
		},
		Author -> {
			"harrison.gronlund",
			"weiran.wang"
		}
	}
];