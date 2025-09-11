(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(* ExperimentWashCellsOptions *)
DefineUsage[ExperimentWashCellsOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentWashCellsOptions[Samples]", "ResolvedOptions"},
				Description -> "generates a 'ResolvedOptions' object to wash the input 'Samples' which contain cells with media to remove debris.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to be washed by removing old buffer and adding fresh buffer.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position"->Alternatives[
										"A1 to P24"->Widget[
											Type->Enumeration,
											Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->$MaxNumberOfWells]],
											PatternTooltip->"Enumeration must be any well from A1 to P24."
										],
										"Container Position"->Widget[
											Type->String,
											Pattern:>LocationPositionP,
											PatternTooltip->"Any valid container position.",
											Size->Line
										]
									],
									"Container"->Widget[
										Type->Object,
										Pattern:>ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentWashCellsOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentWashCells."
		},
		SeeAlso -> {
			"ExperimentWashCells",
			"ValidExperimentWashCellsQ",
			"ExperimentWashCellsPreview"
		},
		Author -> {"harrison.gronlund"}
	}
];

(* ::Subsection:: *)
(* ValidExperimentWashCellsQ *)
DefineUsage[ValidExperimentWashCellsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentWashCellsQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentWashCells call for the cells in input 'Samples' with fresh media to remove debris.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to be washed by removing old buffer and adding fresh buffer.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position"->Alternatives[
										"A1 to P24"->Widget[
											Type->Enumeration,
											Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->$MaxNumberOfWells]],
											PatternTooltip->"Enumeration must be any well from A1 to P24."
										],
										"Container Position"->Widget[
											Type->String,
											Pattern:>LocationPositionP,
											PatternTooltip->"Any valid container position.",
											Size->Line
										]
									],
									"Container"->Widget[
										Type->Object,
										Pattern:>ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentWashCells call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentWashCells, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentWashCells",
			"ExperimentWashCellsOptions",
			"ExperimentWashCellsPreview"
		},
		Author -> {"harrison.gronlund"}
	}
];

(* ::Subsection:: *)
(* ExperimentWashCellsPreview *)
DefineUsage[ExperimentWashCellsPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentWashCellsPreview[Samples]", "Preview"},
				Description -> "generates a graphical 'Preview' for washing the cells in the input 'Samples' with fresh media to remove debris.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to be washed by removing old buffer and adding fresh buffer.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position"->Alternatives[
										"A1 to P24"->Widget[
											Type->Enumeration,
											Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->$MaxNumberOfWells]],
											PatternTooltip->"Enumeration must be any well from A1 to P24."
										],
										"Container Position"->Widget[
											Type->String,
											Pattern:>LocationPositionP,
											PatternTooltip->"Any valid container position.",
											Size->Line
										]
									],
									"Container"->Widget[
										Type->Object,
										Pattern:>ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided WashCells experiment. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentWashCells",
			"ExperimentWashCellsOptions",
			"ValidExperimentWashCellsQ"
		},
		Author -> {"harrison.gronlund"}
	}
];


(* ::Subsection:: *)
(* ExperimentChangeMediaOptions *)
DefineUsage[ExperimentChangeMediaOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentChangeMediaOptions[Samples]", "ResolvedOptions"},
				Description -> "generates a 'ResolvedOptions' object to reaplce the media for the input 'Samples' with the new buffer.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to have the current media removed and new media added.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position"->Alternatives[
										"A1 to P24"->Widget[
											Type->Enumeration,
											Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->$MaxNumberOfWells]],
											PatternTooltip->"Enumeration must be any well from A1 to P24."
										],
										"Container Position"->Widget[
											Type->String,
											Pattern:>LocationPositionP,
											PatternTooltip->"Any valid container position.",
											Size->Line
										]
									],
									"Container"->Widget[
										Type->Object,
										Pattern:>ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentChangeMediaOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentChangeMedia."
		},
		SeeAlso -> {
			"ExperimentChangeMedia",
			"ValidExperimentChangeMediaQ",
			"ExperimentChangeMediaPreview",
			"ChangeMedia"
		},
		Author -> {"dima","harrison.gronlund"}
	}
];

(* ::Subsection:: *)
(* ValidExperimentChangeMediaQ *)
DefineUsage[ValidExperimentChangeMediaQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentChangeMediaQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentChangeMedia call for media replacement for the 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to have the current media removed and new media added.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position"->Alternatives[
										"A1 to P24"->Widget[
											Type->Enumeration,
											Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->$MaxNumberOfWells]],
											PatternTooltip->"Enumeration must be any well from A1 to P24."
										],
										"Container Position"->Widget[
											Type->String,
											Pattern:>LocationPositionP,
											PatternTooltip->"Any valid container position.",
											Size->Line
										]
									],
									"Container"->Widget[
										Type->Object,
										Pattern:>ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentChangeMedia call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentChangeMedia, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentChangeMedia",
			"ExperimentChangeMediaOptions",
			"ExperimentChangeMediaPreview"
		},
		Author -> {"dima","harrison.gronlund"}
	}
];

(* ::Subsection:: *)
(* ExperimentChangeMediaPreview *)
DefineUsage[ExperimentChangeMediaPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentChangeMediaPreview[Samples]", "Preview"},
				Description -> "The cell samples to have the current media removed and new media added.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to have their media changed by removing old buffer and adding fresh buffer.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position"->Alternatives[
										"A1 to P24"->Widget[
											Type->Enumeration,
											Pattern:>Alternatives@@Flatten[AllWells[NumberOfWells->$MaxNumberOfWells]],
											PatternTooltip->"Enumeration must be any well from A1 to P24."
										],
										"Container Position"->Widget[
											Type->String,
											Pattern:>LocationPositionP,
											PatternTooltip->"Any valid container position.",
											Size->Line
										]
									],
									"Container"->Widget[
										Type->Object,
										Pattern:>ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable->False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided ChangeMedia experiment. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ChangeMedia",
			"ExperimentChangeMediaOptions",
			"ValidExperimentChangeMediaQ"
		},
		Author -> {"dima","harrison.gronlund"}
	}
];
