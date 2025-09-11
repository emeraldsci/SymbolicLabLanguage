
(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentResuspend*)


DefineUsage[ExperimentResuspend,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentResuspend[Sample]", "Protocol"},
				Description -> "generates a 'Protocol' to perform basic resuspension of the provided solid 'Sample' with some amount of solvent.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Sample",
							Description -> "The sample to be diluted.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									},
									PreparedSample -> False,
									PreparedContainer -> False
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
									}
								]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol containing instructions for completion of the requested sample resuspension.",
						Pattern :> ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation], Object[Protocol, RoboticSamplePreparation], Object[Protocol, RoboticCellPreparation]}]
					}
				}
			}
		},
		MoreInformation -> {
			"When handling items that are discrete such as tablets, the Amount can be specified either as a raw Integer (i.e., 3) or as a quantity with the \"Unit\" unit (i.e., 3*Unit).  These are equivalent and will be converted to raw integers during option resolution.",
			"This function serves as a simplified interface to ExperimentSamplePreparation.",
			"The SamplePreparation procedure is used to accomplish the resuspension."
		},
		SeeAlso -> {
			"ValidExperimentResuspendQ",
			"ExperimentResuspendOptions",
			"ExperimentResuspendPreview",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"Transfer",
			"Mix",
			"Aliquot"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "cgullekson", "steven", "marie.wu"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentResuspendOptions*)

DefineUsage[ExperimentResuspendOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentResuspendOptions[Objects]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentResuspendOptions when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description -> "The sample to be diluted.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									},
									PreparedSample -> False,
									PreparedContainer -> False
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
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description -> "Resolved options when ExperimentResuspendOptions is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentResuspendOptions if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentResuspend",
			"ValidExperimentResuspendQ",
			"ExperimentResuspendPreview",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"Transfer",
			"Mix",
			"Aliquot"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "cgullekson", "steven"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentResuspendPreview*)

DefineUsage[ExperimentResuspendPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentResuspendPreview[Objects]","Preview"},
				Description -> "returns the preview for ExperimentResuspend when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description -> "The sample to be diluted.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									},
									PreparedSample -> False,
									PreparedContainer -> False
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
				Outputs:>{
					{
						OutputName->"Preview",
						Description -> "Graphical preview representing the output of ExperimentResuspend. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentResuspend",
			"ValidExperimentResuspendQ",
			"ExperimentResuspendOptions",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"Transfer",
			"Mix",
			"Aliquot"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "cgullekson", "steven"}
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentResuspendQ*)

DefineUsage[ValidExperimentResuspendQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentResuspendQ[Objects]","Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentResuspend.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description -> "The sample to be diluted.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									},
									PreparedSample -> False,
									PreparedContainer -> False
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
				Outputs:>{
					{
						OutputName->"Booleans",
						Description -> "Whether or not the ExperimentResuspend call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentResuspend",
			"ExperimentResuspendOptions",
			"ExperimentResuspendPreview",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"Transfer",
			"Mix",
			"Aliquot"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "cgullekson", "steven"}
	}
];