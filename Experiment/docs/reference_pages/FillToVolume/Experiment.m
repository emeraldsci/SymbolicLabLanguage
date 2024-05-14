(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentFillToVolume*)

(* ::Subsubsection:: *)
(*ExperimentFillToVolume*)

DefineUsage[ExperimentFillToVolume,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentFillToVolume[Sample, Volume]", "Protocol"},
				Description -> "generates a 'Protocol' to fill the container of the specified 'Sample' to the specified 'volume'. Whereas ExperimentTransfer transfers an known amount into the destination, ExperimentFillToVolume transfers an unknown amount up until it reaches 'volume'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Sample",
							Description -> "The sample to which solvent should be added.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {Object[Container] -> Field[Contents[[All, 2]]]},
									PreparedSample -> False,
									PreparedContainer -> False
								],
								"Container with Well Position" -> {
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
						{
							InputName -> "Volume",
							Description -> "The final volume of the container once solvent is added.",
							Widget -> Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Microliter, 20 Liter],
									Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
								]
							],
							Expandable -> True
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol containing instructions for completion of the requested adding solvent up to a specified volume.",
						Pattern :> ObjectP[Object[Protocol, FillToVolume]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ValidExperimentFillToVolumeQ",
			"ExperimentFillToVolumeOptions",
			"ExperimentFillToVolumePreview",
			"ExperimentTransfer",
			"ExperimentStockSolution",
			"Transfer",
			"FillToVolume"
		},
		Author -> {"ryan.bisbey", "axu", "steven"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentFillToVolumeOptions*)

DefineUsage[ExperimentFillToVolumeOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentFillToVolumeOptions[Sample, Volume]", "ResolvedOptions"},
				Description -> "returns the 'ResolvedOptions' for an ExperimentFillToVolume call to fill the container of the specified 'Sample' to the specified 'volume'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Sample",
							Description -> "The sample to which solvent should be added.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable -> False
						},
						{
							InputName -> "Volume",
							Description -> "The final volume of the container once solvent is added.",
							Widget -> Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Microliter, 20 Liter],
									Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
								]
							],
							Expandable -> True
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The fully resolved options resulting from the provided ExperimentFillToVolume call.",
						Pattern :> {_Rule..}
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFillToVolume",
			"ValidExperimentFillToVolumeQ",
			"ExperimentFillToVolumePreview",
			"ExperimentTransfer",
			"ExperimentStockSolution",
			"Transfer",
			"FillToVolume"
		},
		Author -> {"ryan.bisbey", "axu", "steven"}
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentFillToVolumeQ*)

DefineUsage[ValidExperimentFillToVolumeQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentFillToVolumeQ[Sample, Volume]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentFillToVolume call to fill the container of the specified 'Sample' to the specified 'volume'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Sample",
							Description -> "The sample to which solvent should be added.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable -> False
						},
						{
							InputName -> "Volume",
							Description -> "The final volume of the container once solvent is added.",
							Widget -> Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Microliter, 20 Liter],
									Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
								]
							],
							Expandable -> True
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentFillToVolume call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFillToVolume",
			"ValidExperimentFillToVolumeQ",
			"ExperimentFillToVolumePreview",
			"ExperimentTransfer",
			"ExperimentStockSolution",
			"Transfer",
			"FillToVolume"
		},
		Author -> {"kelmen.low", "harrison.gronlund", "steven", "dima"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentFillToVolumePreview*)

DefineUsage[ExperimentFillToVolumePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentFillToVolumePreview[Sample, Volume]", "Preview"},
				Description -> "generates a graphical 'Preview' for an ExperimentFillToVolume call to fill the container of the specified 'Sample' to the specified 'volume'.  This value is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Sample",
							Description -> "The sample to which solvent should be added.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable -> False
						},
						{
							InputName -> "Volume",
							Description -> "The final volume of the container once solvent is added.",
							Widget -> Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Microliter, 20 Liter],
									Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
								]
							],
							Expandable -> True
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided FillToVolume experiment. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFillToVolume",
			"ValidExperimentFillToVolumeQ",
			"ExperimentFillToVolumeOptions",
			"ExperimentTransfer",
			"ExperimentStockSolution",
			"Transfer",
			"FillToVolume"
		},
		Author -> {"ryan.bisbey", "axu", "steven"}
	}
];