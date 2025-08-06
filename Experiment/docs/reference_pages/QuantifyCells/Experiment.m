(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentQuantifyCells*)

DefineUsage[ExperimentQuantifyCells,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentQuantifyCells[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' object that measures the cell concentration in the provided 'Samples' with various methods. The methods that are currently supported include measuring the absorbance at 600 nm (OD600) of the 'Samples' with AbsorbanceIntensity measurement and measuring the turbidity of the 'Samples' with Nephelometry measurement.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The cell samples to be quantified.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position" -> {
									"Well Position" -> Alternatives[
										"A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells] -> Widget[
											Type -> Enumeration,
											Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> $MaxNumberOfWells]],
											PatternTooltip -> "Enumeration must be any well from A1 to "<>ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells]<>"."
										],
										"Container Position" -> Widget[
											Type -> String,
											Pattern :> LocationPositionP,
											PatternTooltip -> "Any valid container position.",
											Size -> Line
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
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "The protocol object that measures the cell concentration in the provided 'Samples'.",
						Pattern :> ObjectP[Object[Protocol, QuantifyCells]]
					}
				}
			}
		},
		MoreInformation -> {}, (* shows up in Details And Options of the help file - does not need this for experiment functions FOR NOW *)
		SeeAlso -> {
			"ExperimentQuantifyCellsOptions",
			"ValidExperimentQuantifyCellsQ",
			"ExperimentQuantifyCellsOptions",
			"ExperimentQuantifyCellsPreview",
			"ExperimentAbsorbanceIntensity",
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentNephelometry",
			"ExperimentCoulterCount",
			"ExperimentImageCells",
			"AnalyzeCellCount"
		},
		Tutorials -> {
			"Sample Preparation"
		},
		Author -> {
			"lei.tian"
		}
	}
];