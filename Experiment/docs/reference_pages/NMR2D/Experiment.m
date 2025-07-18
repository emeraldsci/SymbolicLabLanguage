(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentNMR2D*)


DefineUsage[ExperimentNMR2D,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNMR2D[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object for measuring the two-dimensional nuclear magnetic resonance (NMR) spectrum of provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which a two-dimensional nuclear magnetic resonance spectrum will be obtained.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},

				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol object for measuring the two-dimensional nuclear magnetic resonance spectra of input samples.",
						Pattern :> ObjectP[Object[Protocol, NMR2D]]
					}
				}
			}
		},
		MoreInformation -> {
			"NMR uses the excitation and relaxation of nuclear spin to characterize the composition and structure of compounds.",
			"All provided samples will be dissolved in the specified NMR solvent automatically prior to data collection.",
			"Note that for all options, the Direct and Indirect options refer to what are also known as the f2/T2 and f1/T1 nuclei, respectively.",
			Grid[
				{
					{"Experiment", "Name", "f2 (direct) nucleus", "f1 (indirect) nucleus", "Description"},
					{"COSY", "Correlation spectroscopy", "1H", "1H", "Homonuclear experiment correlating the two- and three-bond couplings between protons."},
					{"DQFCOSY", "Double-quantum filtered COSY", "1H", "1H", "COSY variant that provides both positive and negative value peaks reflective of the splitting of the peaks. Double-quantum filtering suppresses singlet and diagonal peaks."},
					{"COSYBeta", "COSY featuring a 45 degree pulse", "1H", "1H", "COSY variant that uses a shorter pulse (45 degree rather than the typical 90 degree). This allows for the distinction of vicinal and geminal proton-proton couplings, and simplifies splitting patterns compared to conventional COSY."},
					{"TOCSY", "Total correlation spectroscopy", "1H", "1H", "Homonuclear experiment correlating all protons in the same spin system."},
					{"HSQC", "Heteronuclear single quantum correlation spectroscopy", "1H", "13C/15N", "Heteronuclear experiment correlating the one-bond couplings between protons and carbons/nitrogens. For 1H-13C HSQC, positive peaks indicate a CH2 and negative peaks indicate CH or CH3."},
					{"HMQC", "Heteronuclear multiple-quantum correlation spectroscopy", "1H", "13C", "Heteronuclear experiment correlating the one-bond couplings between protons and carbons/nitrogens. For 1H-13C HMQC, positive peaks indicate a CH2 and negative peaks indicate CH or CH3. More robust but less sensitive than the similar HSQC."},
					{"HMBC", "Heteronuclear multiple-bond correlation spectroscopy", "1H", "13C/15N", "Heteronuclear experiment correlating the two-, three-, and four-bond couplings between protons and carbons/nitrogens."},
					{"HSQCTOCSY", "Combination HSQC-TOCSY", "1H", "13C", "Heteronuclear experiment correlating carbon peaks with all protons in the same spin system as the proton to which it is bonded using HSQC."},
					{"HMQCTOCSY", "Combination HMQC-TOCSY", "1H", "13C", "Heteronuclear experiment correlating carbon peaks with all protons in the same spin system as the proton to which it is bonded using HMBC."},
					{"NOESY", "Nuclear Overhauser effect spectroscopy", "1H", "1H", "Homonuclear experiment using the nuclear Overhauser effect (NOE) to identify through-space interactions of spins for molecules below 1000 or greater than 2000 Daltons."},
					{"ROESY", "Rotating-frame Overhauser effect spectroscopy", "1H", "1H", "Homonuclear experiment using a rotating frame NOE to identify through-space interactions of spins for molecules of all sizes."}
				}
			],
			"The below table indicates how the DirectSpectralDomain and IndirectSpectralDomain options are automatically determined:",
			Grid[
				{
					{"ExperimentType", "IndirectNucleus", "Automatic DirectSpectralDomain", "Automatic IndirectSpectralDomain"},
					{"COSY", "1H", Span[-0.5 PPM, 12.5 PPM], Span[-0.5 PPM, 12.5 PPM]},
					{"DQFCOSY", "1H", Span[-1.0 PPM, 12.0 PPM], Span[-1.0 PPM, 12 PPM]},
					{"COSYBeta", "1H", Span[-0.3 PPM, 9.7 PPM], Span[-0.3 PPM, 9.3 PPM]},
					{"TOCSY", "1H", Span[-0.3 PPM, 9.7 PPM], Span[-0.3 PPM, 9.3 PPM]},
					{"HSQC", "13C", Span[0.0 PPM, 12.0 PPM], Span[0 PPM, 180 PPM]},
					{"HSQC", "15N", Span[-0.5 PPM, 13.5 PPM], Span[-50 PPM, 350 PPM]},
					{"HMQC", "13C", Span[-1.8 PPM, 11.2 PPM], Span[-7.5 PPM, 157.5 PPM]},
					{"HMBC", "13C", Span[-0.1 PPM, 12.8 PPM], Span[-10 PPM, 210 PPM]},
					{"HMBC", "15N", Span[-0.5 PPM, 12.5 PPM], Span[-50 PPM, 350 PPM]},
					{"HSQCTOCSY", "13C", Span[-3.3 PPM, 12.7 PPM], Span[-7.5 PPM, 157.5 PPM]},
					{"HMQCTOCSY", "13C", Span[-1.8 PPM, 11.2 PPM], Span[-7.5 PPM, 157.5 PPM]},
					{"NOESY", "1H", Span[-0.3 PPM, 9.7 PPM], Span[-0.3 PPM, 9.3 PPM]},
					{"ROESY", "1H", Span[-0.3 PPM, 9.7 PPM], Span[-0.3 PPM, 9.3 PPM]}
				}
			]

		},
		SeeAlso -> {
			"ExperimentNMR",
			"ExperimentNMR2DPreview",
			"ExperimentNMR2DOptions",
			"PlotNMR2D",
			"ValidExperimentNMR2DQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian", "steven"}
	}
];


(* ::Subsection:: *)
(*ValidExperimentNMR2DQ*)


DefineUsage[ValidExperimentNMR2DQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentNMR2DQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentNMR2D call for measuring the two-dimensional nuclear magnetic resonance (NMR) spectrum of provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which a two-dimensional nuclear magnetic resonance spectrum will be obtained.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentNMR2D call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentNMR2D proper, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentNMR2D",
			"ExperimentNMR2DPreview",
			"ExperimentNMR2DOptions",
			"PlotNMR2D"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian", "steven"}
	}
];


(* ::Subsection:: *)
(*ExperimentNMR2DOptions*)


DefineUsage[ExperimentNMR2DOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNMR2DOptions[Samples]", "ResolvedOptions"},
				Description -> "generates the 'ResolvedOptions' for measuring the two-dimensional nuclear magnetic resonance (NMR) spectrum of provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which a two-dimensional nuclear magnetic resonance spectrum will be obtained.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentNMR2DOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentNMR2D."
		},
		SeeAlso -> {
			"ExperimentNMR2D",
			"ExperimentNMR2DPreview",
			"PlotNMR2D",
			"ValidExperimentNMR2DQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian", "steven"}
	}
];

(* ::Subsection:: *)
(*ExperimentNMR2DPreview*)


DefineUsage[ExperimentNMR2DPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentNMR2DPreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for measuring the two-dimensional nuclear magnetic resonance (NMR) spectrum of powder 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples for which a two-dimensional nuclear magnetic resonance spectrum will be obtained.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical representation of the provided NMR experiment.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation -> {

		},
		SeeAlso -> {
			"ExperimentNMR2D",
			"ExperimentNMR2DOptions",
			"PlotNMR2D",
			"ValidExperimentNMR2DQ"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian", "steven"}
	}
];