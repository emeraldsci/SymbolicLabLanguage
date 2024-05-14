

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceSpectroscopy*)

DefineUsage[ExperimentAbsorbanceSpectroscopy,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentAbsorbanceSpectroscopy[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object for running an assay to measure the absorbance of the 'Samples' at specified wavelengths.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input contents which will be transferred into a microfluidic chip, plate, or cuvette to measure the absorbance at specified wavelengths.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								ObjectTypes -> {Object[Sample], Object[Container]},
								Dereference ->{
									Object[Container]->Field[Contents[[All,2]]]
								}
								],
							Description -> "The samples to be measured.",
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
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :>{
					{
						OutputName->"Protocol",
						Description->"A protocol object for measuring absorbance of samples.",
						Pattern:>ObjectP[Object[Protocol,AbsorbanceSpectroscopy]]
					}
				}
			}
		},
		MoreInformation -> {
			"When using a Lunatic instrument, the most samples that can be run in one protocol (including blanks) is 94 samples. If you want to run on more than 94 samples, please manually group your samples into multiple protocols."
		},
		SeeAlso -> {
			"ValidExperimentAbsorbanceSpectroscopyQ",
			"ExperimentAbsorbanceSpectroscopyOptions",
			"ExperimentAbsorbanceSpectroscopyPreview",
			"AnalyzeAbsorbanceQuantification",
			"PlotAbsorbanceSpectroscopy",
			"ExperimentAbsorbanceIntensity"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hayley"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentAbsorbanceSpectroscopyQ*)

DefineUsage[ValidExperimentAbsorbanceSpectroscopyQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentAbsorbanceSpectroscopyQ[Samples]", "Booleans"},
				Description -> "checks whether the provided input 'Samples' and specified options are valid arguments for ExperimentAbsorbanceSpectroscopy.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input contents which will be transferred into a microfluidic chip, plate, or cuvette to measure the absorbance at specified wavelengths.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								ObjectTypes -> {Object[Sample], Object[Container]},
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								}
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Indicates whether or not the ExperimentAbsorbanceSpectroscopy call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentAbsorbanceSpectroscopyOptions",
			"ExperimentAbsorbanceSpectroscopyPreview",
			"AnalyzeAbsorbanceQuantification",
			"PlotAbsorbanceSpectroscopy",
			"ExperimentAbsorbanceIntensity"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hayley"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceSpectroscopyOptions*)

DefineUsage[ExperimentAbsorbanceSpectroscopyOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentAbsorbanceSpectroscopyOptions[Samples]", "Booleans"},
				Description -> "returns the set options for ExperimentAbsorbanceSpectroscopy when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input contents which will be transferred into a microfluidic chip, plate, or cuvette to measure the absorbance at specified wavelengths.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								ObjectTypes -> {Object[Sample], Object[Container]},
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								}
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentAbsorbanceSpectroscopy is called on the input samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentAbsorbanceSpectroscopy",
			"ValidExperimentAbsorbanceSpectroscopyQ",
			"ExperimentAbsorbanceSpectroscopyPreview",
			"AnalyzeAbsorbanceQuantification",
			"PlotAbsorbanceSpectroscopy",
			"ExperimentAbsorbanceIntensity"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hayley"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentAbsorbanceSpectroscopyPreview*)

DefineUsage[ExperimentAbsorbanceSpectroscopyPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentAbsorbanceSpectroscopyPreview[Samples]", "Preview"},
				Description -> "display a graphical preview for ExperimentAbsorbanceSpectroscopy when it is called on 'Samples'.  This output is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The input contents which will be transferred into a microfluidic chip, plate, or cuvette to measure the absorbance at specified wavelengths.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								ObjectTypes -> {Object[Sample], Object[Container]},
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								}
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentAbsorbanceSpectroscopy.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentAbsorbanceSpectroscopy",
			"ValidExperimentAbsorbanceSpectroscopyQ",
			"ExperimentAbsorbanceSpectroscopyOptions",
			"AnalyzeAbsorbanceQuantification",
			"PlotAbsorbanceSpectroscopy",
			"ExperimentAbsorbanceIntensity"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"dima", "steven", "simon.vu", "hayley"}
	}
];