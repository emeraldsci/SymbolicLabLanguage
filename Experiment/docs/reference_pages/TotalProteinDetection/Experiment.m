(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* ExperimentTotalProteinDetection *)

DefineUsage[ExperimentTotalProteinDetection,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentTotalProteinDetection[Samples]","Protocol"},
			Description->"generates a 'Protocol' object for running a capillary electrophoresis-based total protein labeling and detection assay.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be run through a capillary electrophoresis-based total protein labeling and detection assay. Proteins present in the input samples are separated by size, labeled with biotin, then treated with a streptavidin-HRP conjugate. The presence of this conjugate is detected by chemiluminescence.",
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
					Description -> "A protocol object for running a capillary electrophoresis-based total protein labeling and detection assay.",
					Pattern :> ObjectP[Object[Protocol, TotalProteinDetection]]
				}
			}
		}
	},
	MoreInformation->{
		"A maximum of 24 samples can be run in one experiment.",
		"The maximum recommended TotalProteinConcentration for input lysate samples is between 2 and 3 mg/mL. To find the ideal concentration for an initial experiment, it is recommended to start with 2, 1, 0.5, 0.25, and 0.125 mg/mL.",
		"It is recommended to dilute concentrated lysate inputs with Model[Sample, StockSolution, \"Simple Western 0.1X Sample Buffer\"] using the Aliquot-related sample preparation options. Please see the AssayBuffer option for an example.",
		"For more information about assay development and troubleshooting unexpected results, please refer to Object[Report, Literature, \"Simple Western Size Assay Development Guide\"]."
	},
	SeeAlso->{
		"ExperimentTotalProteinDetectionOptions",
		"ValidExperimentTotalProteinDetectionQ",
		"ExperimentWestern"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"andrey.shur", "lei.tian", "jihan.kim", "axu"}
}];