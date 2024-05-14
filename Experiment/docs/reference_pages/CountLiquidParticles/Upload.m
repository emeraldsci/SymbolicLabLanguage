(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* UploadCountLiquidParticlesMethod *)

DefineUsage[UploadCountLiquidParticlesMethod,{

	BasicDefinitions->{
		{
			Definition->{"UploadCountLiquidParticlesMethod[Samples]","capillaryELISACartridgeModel"},
			Description->"creates a new pre-loaded 'capillaryELISACartridgeModel' with the specified analytes, cartridge type and species.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The sample used ",
						Widget->Alternatives[
							Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample]}]
							]
						],
						Expandable->False
					},
					IndexName->"experiment samples"
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
	},
	SeeAlso->{
		"ExperimentCapillaryELISA",
		"ValidUploadCountLiquidParticlesMethodQ",
		"UploadCountLiquidParticlesMethodOptions",
		"UploadProduct",
		"Upload",
		"Download",
		"Inspect"
	},
	Author->{"jihan.kim", "lige.tonggu", "weiran.wang"}
}];



(* ::Subsubsection::Closed:: *)
(*UploadCountLiquidParticlesMethodOptions*)


DefineUsage[UploadCountLiquidParticlesMethodOptions,
	{
		BasicDefinitions-> {
			{
				Definition -> {"UploadCountLiquidParticlesMethodOptions[Samples]", "ResolvedOptions"},
				Description -> "returns the 'ResolvedOptions' from UploadCountLiquidParticlesMethod for creating a new pre-loaded capillary ELISA cartridge model with the specified 'Samples', cartridge type and species.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The targets (e.g., peptides, proteins, antibodies, hormones) detected and quantified in the samples using this pre-loaded capillary ELISA cartridge model through capillary ELISA experiment.",
							Widget -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample]}]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Null]
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
						Description -> "The resolved options from UploadCountLiquidParticlesMethod to create the desired pre-loaded capillary ELISA cartridge.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"The options returned by UploadCountLiquidParticlesMethodOptions may be passed directly to UploadCountLiquidParticlesMethod."
		},
		SeeAlso->{
			"UploadCountLiquidParticlesMethod",
			"ExperimentCapillaryELISA",
			"ValidUploadCountLiquidParticlesMethodQ",
			"UploadProduct",
			"Upload",
			"Download",
			"Inspect"
		},
		Author->{"jihan.kim", "lige.tonggu", "weiran.wang"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadCountLiquidParticlesMethodQ*)


DefineUsage[ValidUploadCountLiquidParticlesMethodQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidUploadCountLiquidParticlesMethodQ[Samples]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an UploadCountLiquidParticlesMethod call for creating a new pre-loaded capillary ELISA cartridge model with the specified 'Samples', cartridge type and species.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The targets (e.g., peptides, proteins, antibodies, hormones) detected and quantified in the samples using this pre-loaded capillary ELISA cartridge model through capillary ELISA experiment.",
							Widget -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample]}]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Null]
								]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A boolean indicating the validity of the UploadCountLiquidParticlesMethod call to create the desired pre-loaded capillary ELISA cartridge. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"UploadCountLiquidParticlesMethod",
			"ExperimentCapillaryELISA",
			"UploadCountLiquidParticlesMethodOptions",
			"UploadProduct",
			"Upload",
			"Download",
			"Inspect"
		},
		Author->{"jihan.kim", "lige.tonggu", "weiran.wang"}
	}
];



(* ::Subsection:: *)
(*UploadCountLiquidParticlesMethodPreview*)
DefineUsage[UploadCountLiquidParticlesMethodPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"UploadCountLiquidParticlesMethodPreview[Samples]","Preview"},
				Description->"returns a graphical 'Preview' for UploadCountLiquidParticlesMethod call for creating a new pre-loaded capillary ELISA cartridge model with the specified 'Samples', cartridge type and species.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
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
						IndexName -> "Samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the expected output of UploadCountLiquidParticlesMethod. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation->{
			"UploadCountLiquidParticlesMethodPreview always returns Null because no graphical preview of the new pre-loaded capillary ELISA cartridge model is available."
		},
		SeeAlso->{
			"UploadCountLiquidParticlesMethod",
			"ExperimentCapillaryELISA",
			"UploadCountLiquidParticlesMethodOptions",
			"ValidUploadCountLiquidParticlesMethodQ",
			"UploadProduct",
			"Upload",
			"Download",
			"Inspect"
		},
		Author->{"jihan.kim", "lige.tonggu", "weiran.wang"}
	}
];