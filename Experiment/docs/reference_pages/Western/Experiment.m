(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* ExperimentWestern *)

DefineUsage[ExperimentWestern,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentWestern[Samples,Antibodies]","Protocol"},
			Description->"generates a 'Protocol' object for running a western blot using capillary electrophoresis.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be run through a capillary electrophoresis-based western blot. Western blot is an analytical method used to detect specific proteins in a tissue-derived mixture.",
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
							},
							"Model Sample"->Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample]],
								ObjectTypes -> {Model[Sample]}
							]
						],
						Expandable->False
					},
					{
						InputName->"Antibodies",
						Description->"The PrimaryAntibody or PrimaryAntibodies which will be used along with the SecondaryAntibody to detect the input samples.",
						Widget->Alternatives[
							"Sample or Container" -> Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Model[Sample],Object[Container]}],
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
						Expandable->True
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName -> "Protocol",
					Description -> "A protocol object for running a capillary electrophoresis-based western blot.",
					Pattern :> ObjectP[Object[Protocol, Western]]
				}
			}
		}
	},
	MoreInformation->{
		"A maximum of 24 samples can be run in one experiment.",
		"The maximum recommended TotalProteinConcentration for input lysate samples is between 2 and 3 mg/mL.",
		"It is recommended to dilute concentrated lysate inputs with Model[Sample, StockSolution, \"Simple Western 0.1X Sample Buffer\"] using the Aliquot-related sample preparation options. Please see the AssayBuffer option for an example.",
		"For novel assays, it is recommended to start with lysate concentrations of 1 and 0.25 mg/mL. These will become 0.8 and 0.2 mg/mL after the LoadingBuffer is added to input lysate samples.",
		"For \"no lysate\" controls, use a sample of Model[Sample, StockSolution, \"Simple Western 0.1X Sample Buffer\"] in place of input lysate.",
		(* At some point I will want to add more information about the lysis buffers that are acceptable *)
		"A list of antibodies and recommended dilutions that have been successfully used in capillary-based western experiments can be found at https://www.proteinsimple.com/antibody/antibodies.html.",
		"If traditional Western Blot primary antibody dilution conditions are known, it is recommended to start with 100, 20, and 4 times the recommended traditional primary antibody dilutions for initial antibody screening. For example, if the recommended traditional Western dilution is 1:1000 (a PrimaryAntibodyDilutionFactor of 0.001), the recommended starting PrimaryAntibodyDilutionFactors would be 0.1, 0.02, and 0.004.",
		"For a new assay where Western blot parameters are not known, it is recommended to use PrimaryAntibodyDilutionFactors of 0.1, 0.02, and 0.004 for initial antibody screening.",
		"Corresponding SecondaryAntibodies will be automatically set for any PrimaryAntibodies that are derived from Mouse, Rabbit, Human, or Goat. For PrimaryAntibodies derived from other species, the user should provide a corresponding SecondaryAntibody.",
		"For more information about assay development and troubleshooting unexpected results, please refer to Object[Report, Literature, \"Simple Western Size Assay Development Guide\"]."
	},
	SeeAlso->{
		"ExperimentWesternOptions",
		"ValidExperimentWesternQ"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"lige.tonggu", "clayton.schwarz", "axu"}
}];