(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentThawCells*)

DefineUsage[ExperimentThawCells,
{
	BasicDefinitions -> {
		{
			Definition -> {"ExperimentThawCells[Samples]","Protocol"},
			Description -> "creates a 'Protocol' to thaw the given 'Samples'.",
			Inputs :> {
				IndexMatching[
					{
						InputName -> "Samples",
						Description-> "The samples or containers to be thawed.",
						Widget-> Alternatives[
							"Sample or Container"->Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container], Model[Sample]}],
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
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName -> "Protocol",
					Description -> "The protocol object to wash the provided samples.",
					Pattern :> ListableP[ObjectP[Object[Protocol, WashCells]]]
				}
			}
		}
	},
	SeeAlso -> {
		"ExperimentCellPreparation"
	},
	Author -> {"jireh.sacramento", "tim.pierpont", "thomas"}
}];