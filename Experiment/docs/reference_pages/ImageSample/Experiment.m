(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentImageSample*)

DefineUsage[
	ExperimentImageSample,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentImageSample[Objects]","Protocol"},
				Description -> "creates a 'Protocol' to photograph the provided sample or container 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers that will be photographed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
						OutputName -> "Protocol",
						Description -> "Protocol generated to photograph the input samples or containers.",
						Pattern :> ObjectP[Object[Protocol,ImageSample]]
					}
				}
			}
		},
		MoreInformation -> {
			"Captured images are associated with samples, not containers, so imaging of empty containers is disallowed."
		},
		SeeAlso -> {
			"ExperimentMeasureVolume",
			"ExperimentMeasureWeight",
			"RecordAppearance"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ben", "olatunde.olademehin", "paul"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentImageSampleQ*)

DefineUsage[
	ValidExperimentImageSampleQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentImageSampleQ[Objects]","Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentImageSample call for photographing of provided sample or container 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers that will be photographed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentImageSample call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentImageSample proper, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentMeasureVolume",
			"ExperimentMeasureWeight",
			"RecordAppearance"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ben", "olatunde.olademehin", "paul"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentImageSampleOptions*)

DefineUsage[
	ExperimentImageSampleOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentImageSampleOptions[Objects]","ResolvedOptions"},
				Description -> "generates the 'ResolvedOptions' for photographing of provided 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers that will be photographed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentImageSampleOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentImageSample."
		},
		SeeAlso -> {
			"ExperimentMeasureVolume",
			"ExperimentMeasureWeight",
			"RecordAppearance"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ben", "olatunde.olademehin", "paul"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentImageSamplePreview*)

DefineUsage[
	ExperimentImageSamplePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentImageSamplePreview[Objects]","Preview"},
				Description -> "creates a graphical 'Preview' for photographing of the provided 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers that will be photographed.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided ImageSample experiment. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureVolume",
			"ExperimentMeasureWeight",
			"RecordAppearance"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"ben", "olatunde.olademehin", "paul"}
	}
];