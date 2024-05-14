(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* UploadCapillaryELISACartridge *)

DefineUsage[UploadCapillaryELISACartridge,{

	BasicDefinitions->{
		{
			Definition->{"UploadCapillaryELISACartridge[Analytes]","capillaryELISACartridgeModel"},
			Description->"creates a new pre-loaded 'capillaryELISACartridgeModel' with the specified analytes, cartridge type and species.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Analytes",
						Description->"The targets (e.g., peptides, proteins, antibodies, hormones) detected and quantified in the samples using this pre-loaded capillary ELISA cartridge model through capillary ELISA experiment.",
						Widget->Alternatives[
							Widget[
								Type->Object,
								Pattern:>ObjectP[{Model[Molecule]}]
							],
							With[{insertMe=Flatten[CapillaryELISAAnalyteP]},
								Widget[
									Type->MultiSelect,
									Pattern:>DuplicateFreeListableP[insertMe]
								]
							]
						],
						Expandable->False
					},
					IndexName->"Analytes"
				]
			},
			Outputs:>{
				{
					OutputName->"capillaryELISACartridgeModel",
					Description->"The model that represents this pre-loaded capillary ELISA cartridge.",
					Pattern:>ObjectP[Model[Container,Plate,Irregular,CapillaryELISA]]
				}
			}
		}
	},
	MoreInformation->{
		"The pre-loaded capillary ELISA cartridge are used in ExperimentCapillaryELISA for Enzyme-Linked Immunosorbent Assay (ELISA) experiments. A pre-loaded cartridge of ExperimentCapillaryELISA is loaded with capture antibodies (embedded on the bottom of the glass nano-reactors), detection antibodies and streptavidin-conjugated fluorophore reagents, providing the complete assay of the entire ELISA workflow of the specific analytes.",
		"The cartridge comes with factory-calibrated standard curves of the assays, validated by the assay developer. A standard curve of an analyte was fit from standard sample data using the five-parameter logistic model:\nFluorescenceSignal = D + (A - D) / (1 + (Concentration / C) ^ B) ^ G\nFluorescence is provided in unit RFU and Concentration is provided in unit Picogram/Milliliter.",
		"There are four types of pre-loaded capillary ELISA cartridges. The cartridges are pre-loaded with validated ELISA assays, available for more than 200 analytes. Different pre-loaded cartridge types provide different sample numbers, analyte numbers and internal replicates:",
		Grid[
			{
				{"Cartridge Type","Max Number of Samples","Max Number of Analytes","Internal Replicates per Sample"},
				{"SinglePlex72X1","72","1","3"},
				{"MultiAnalyte32X4","32","4","3"},
				{"MultiAnalyte16X4","16","4","3"},
				{"MultiPlex32X8","32","8","2"}
			}
		],
		"Please refer to Object[Report,Literature,\"Simple Plex Assay Menu\"] for the available analytes of pre-loaded cartridges and Object[ManufacturingSpecification,CapillaryELISACartridge] of different analytes for compatibility and combination rules.",
		"Due to the manufacturing and validation steps, the lead time of a pre-loaded cartridge assay can take up to 14 days. After the new capillary ELISA cartridge model is created by UploadCapillaryELISACartridge, it is recommended to use OrderSamples to order the cartridge ahead to reduce the waiting time of the experiment."
	},
	SeeAlso->{
		"ExperimentCapillaryELISA",
		"ValidUploadCapillaryELISACartridgeQ",
		"UploadCapillaryELISACartridgeOptions",
		"UploadProduct",
		"Upload",
		"Download",
		"Inspect"
	},
	Author->{"harrison.gronlund", "taylor.hochuli", "axu"}
}];



(* ::Subsubsection::Closed:: *)
(*UploadCapillaryELISACartridgeOptions*)


DefineUsage[UploadCapillaryELISACartridgeOptions,
	{
		BasicDefinitions-> {
			{
				Definition -> {"UploadCapillaryELISACartridgeOptions[Analytes]", "ResolvedOptions"},
				Description -> "returns the 'ResolvedOptions' from UploadCapillaryELISACartridge for creating a new pre-loaded capillary ELISA cartridge model with the specified 'Analytes', cartridge type and species.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Analytes",
							Description -> "The targets (e.g., peptides, proteins, antibodies, hormones) detected and quantified in the samples using this pre-loaded capillary ELISA cartridge model through capillary ELISA experiment.",
							Widget -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Molecule]}]
								],
								With[{insertMe = Flatten[CapillaryELISAAnalyteP]},
									Widget[
										Type -> MultiSelect,
										Pattern :> DuplicateFreeListableP[insertMe]
									]
								]
							],
							Expandable -> False
						},
						IndexName -> "Analytes"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from UploadCapillaryELISACartridge to create the desired pre-loaded capillary ELISA cartridge.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"The options returned by UploadCapillaryELISACartridgeOptions may be passed directly to UploadCapillaryELISACartridge."
		},
		SeeAlso->{
			"UploadCapillaryELISACartridge",
			"ExperimentCapillaryELISA",
			"ValidUploadCapillaryELISACartridgeQ",
			"UploadProduct",
			"Upload",
			"Download",
			"Inspect"
		},
		Author->{"harrison.gronlund", "taylor.hochuli", "axu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadCapillaryELISACartridgeQ*)


DefineUsage[ValidUploadCapillaryELISACartridgeQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidUploadCapillaryELISACartridgeQ[Analytes]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an UploadCapillaryELISACartridge call for creating a new pre-loaded capillary ELISA cartridge model with the specified 'Analytes', cartridge type and species.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Analytes",
							Description -> "The targets (e.g., peptides, proteins, antibodies, hormones) detected and quantified in the samples using this pre-loaded capillary ELISA cartridge model through capillary ELISA experiment.",
							Widget -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Molecule]}]
								],
								With[{insertMe = Flatten[CapillaryELISAAnalyteP]},
									Widget[
										Type -> MultiSelect,
										Pattern :> DuplicateFreeListableP[insertMe]
									]
								]
							],
							Expandable -> False
						},
						IndexName -> "Analytes"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A boolean indicating the validity of the UploadCapillaryELISACartridge call to create the desired pre-loaded capillary ELISA cartridge. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"UploadCapillaryELISACartridge",
			"ExperimentCapillaryELISA",
			"UploadCapillaryELISACartridgeOptions",
			"UploadProduct",
			"Upload",
			"Download",
			"Inspect"
		},
		Author->{"harrison.gronlund", "taylor.hochuli", "axu"}
	}
];



(* ::Subsection:: *)
(*UploadCapillaryELISACartridgePreview*)
DefineUsage[UploadCapillaryELISACartridgePreview,
	{
		BasicDefinitions->{
			{
				Definition->{"UploadCapillaryELISACartridgePreview[Analytes]","Preview"},
				Description->"returns a graphical 'Preview' for UploadCapillaryELISACartridge call for creating a new pre-loaded capillary ELISA cartridge model with the specified 'Analytes', cartridge type and species.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Analytes",
							Description -> "The targets (e.g., peptides, proteins, antibodies, hormones) detected and quantified in the samples using this pre-loaded capillary ELISA cartridge model through capillary ELISA experiment.",
							Widget -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Molecule]}]
								],
								With[{insertMe = Flatten[CapillaryELISAAnalyteP]},
									Widget[
										Type -> MultiSelect,
										Pattern :> DuplicateFreeListableP[insertMe]
									]
								]
							],
							Expandable -> False
						},
						IndexName -> "Analytes"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the expected output of UploadCapillaryELISACartridge. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation->{
			"UploadCapillaryELISACartridgePreview always returns Null because no graphical preview of the new pre-loaded capillary ELISA cartridge model is available."
		},
		SeeAlso->{
			"UploadCapillaryELISACartridge",
			"ExperimentCapillaryELISA",
			"UploadCapillaryELISACartridgeOptions",
			"ValidUploadCapillaryELISACartridgeQ",
			"UploadProduct",
			"Upload",
			"Download",
			"Inspect"
		},
		Author->{"harrison.gronlund", "taylor.hochuli", "axu"}
	}
];