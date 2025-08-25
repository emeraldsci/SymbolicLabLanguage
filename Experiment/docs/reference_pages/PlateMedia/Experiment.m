(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[ExperimentPlateMedia,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentPlateMedia[Media]","Protocol"},
				Description->"generates a 'Protocol' for transferring the 'Media' that consists of sterile liquid or heated solid media containing gelling agents to plates for cell culture incubation and growth.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Media",
							Description->"The media sample to be transferred to plates while heating with magnetic stirring in this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample,Media],Object[Sample],Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False
						},
						IndexName->"media"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"Protocol specifying instructions for transferring the requested 'Media' from its source container to plates.",
						Pattern:>ObjectP[Object[Protocol,PlateMedia]]
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentPlateMediaOptions",
			"ValidExperimentPlateMediaQ",
			"ExperimentPlateMediaPreview",
			"ExperimentMedia",
			"ExperimentStockSolution"
		},
		Author->{"daniel.shlian","taylor.hochuli", "eunbin.go"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentPlateMediaOptions*)

DefineUsage[ExperimentPlateMediaOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPlateMediaOptions[Media]", "ResolvedOptions"},
				Description -> "returns 'ResolvedOptions' from ExperimentPlateMedia for preparation of the given 'Media' according to its formula and using its preparation parameters as defaults.",
				Inputs :> {
					IndexMatching[
						{
							InputName->"Media",
							Description->"The media sample to be transferred to plates while heating with magnetic stirring in this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample,Media],Object[Sample],Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from an ExperimentPlateMedia call for preparing the provided media.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentPlateMediaOptions",
			"ValidExperimentPlateMediaQ",
			"ExperimentPlateMediaPreview",
			"ExperimentMedia",
			"ExperimentStockSolution"
		},
		Author -> {"daniel.shlian"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentPlateMediaPreview*)


DefineUsage[ExperimentPlateMediaPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPlateMediaPreview[Media]", "Preview"},
				Description -> "returns a graphical representation for preparation of the given 'Media' according to its formula and using its preparation parameters as defaults. This 'Preview' is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName->"Media",
							Description->"The media sample to be transferred to plates while heating with magnetic stirring in this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample,Media],Object[Sample],Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided media preparation. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {
			"Currently, this preview function always returns Null."
		},
		SeeAlso -> {
			"ExperimentPlateMediaOptions",
			"ValidExperimentPlateMediaQ",
			"ExperimentPlateMediaPreview",
			"ExperimentMedia",
			"ExperimentStockSolution"
		},
		Author -> {"daniel.shlian"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentStockSolutionQ*)


DefineUsage[ValidExperimentPlateMediaQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentPlateMediaQ[Media]", "Boolean"},
				Description -> "checks the validity of an ExperimentPlateMedia call for preparation of the given 'Media' according to its formula and using its preparation parameters as defaults, returning a validity 'Boolean'.",
				Inputs :> {
					IndexMatching[
						{
							InputName->"Media",
							Description->"The media sample to be transferred to plates while heating with magnetic stirring in this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample,Media],Object[Sample],Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A boolean indicating the validity of the ExperimentPlateMedia call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentPlateMediaOptions",
			"ValidExperimentPlateMediaQ",
			"ExperimentPlateMediaPreview",
			"ExperimentMedia",
			"ExperimentStockSolution"
		},
		Author -> {"daniel.shlian"}
	}
];

