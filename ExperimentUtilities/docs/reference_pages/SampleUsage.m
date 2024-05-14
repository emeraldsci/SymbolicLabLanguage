(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*SampleUsage*)


DefineUsage[SampleUsage,
	{
		BasicDefinitions -> {
			{
				Definition -> {"SampleUsage[primitives]", "table"},
				Description -> "creates a 'table' containing the usage amount, the amount in the user's inventory, and the amount in the public inventory for all samples specified in 'primitives'.",
				Inputs :> {
					{
						InputName -> "primitives",
						Description -> "Sample manipulation primitives that include Define, Transfer, Aliquot, Consolidation, Resuspend, and FillToVolume.",
						Widget -> Experiment`Private`sampleManipulationWidget
					}
				},
				Outputs :> {
					{
						OutputName -> "table",
						Description -> "A table displaying information of each sample specified in the input primitives, including the usage amount specified in the primitives, the amount of sample in the user's inventory, and the amount of the sample in the public inventory.",
						Pattern :> _Pane
					},
					{
						OutputName -> "associations",
						Description -> "A list of associations containing information about each sample specified in the input primitives, including the usage amount specified in the primitives, the amount of sample in the user's inventory, and the amount of the sample in the public inventory (returned if OutputFormat -> Association).",
						Pattern :> {_Association..}
					}
				}
			}
		},
		MoreInformation -> {
			"The amount of each sample in the public inventory is a total amount of all samples sharing the same model as the sample of interest that are not part of any Notebooks.",
			"The initial amount of each sample in the user's inventory is a total amount of all samples sharing the same model as the sample of interest that are part of Notebooks financed by the user's financing teams.",
			"The final amount of each sample in the user's inventory is a predicted remaining amount if the provided manipulations were performed."
		},
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"Define",
			"Transfer",
			"Aliquot",
			"Consolidation",
			"Resuspend",
			"FillToVolume"
		},
		Author -> {"malav.desai", "waseem.vali", "varoth.lilascharoen"}
	}
];
