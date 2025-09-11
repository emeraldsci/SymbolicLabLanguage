(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* ExperimentCapillaryELISA *)

DefineUsage[ExperimentCapillaryELISA,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentCapillaryELISA[Samples]","Protocol"},
			Description->"creates a 'Protocol' to run capillary Enzyme-Linked Immunosorbent Assay (ELISA) experiment on the provided 'Samples' for the detection of certain analytes.",
			Inputs:> {
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be analyzed using capillary ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
						Widget->Alternatives[
							"Sample or Container"->Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample], Object[Container]}],
								ObjectTypes -> {Object[Sample], Object[Container]},
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
							},
							"Model Sample"->Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample]],
								ObjectTypes -> {Model[Sample]}
							]
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Protocol",
					Description->"A protocol object that describes the capillary ELISA experiment to be run.",
					Pattern:>ObjectP[Object[Protocol,CapillaryELISA]]
				}
			}
		}
	},
	MoreInformation->{
		"ExperimentCapillaryELISA uses special cartridge plates with parallel microfluidics channels. The cartridge is loaded with samples and assay reagents. During capillary ELISA experiment, samples and reagents are directed into and out of the microfluidics channels through a series of pneumatic pistons to complete the entire workflow of a sandwich ELISA experiment.",
		"Each capillary ELISA cartridge is pre-loaded with streptavidin-conjugated fluorophore reagents, which can specifically recognize biotinylated detection antibodies in the sandwich ELISA. The fluorophore reagents are excited by a single mode 641nm laser diode and the fluorescence signals at 650 nm are detected by a CCD camera for quantitation of the analyte concentrations.",
		"Each microfluidics channel in capillary ELISA cartridge contains multiple Glass Nano-Reactors (GNR) that are functionalized with immunoassay reagents. Each GNR provides a single measurement so the experiment provides internal replicates for ELISA experiment. For each replicated measurement, a fluorescence signal value is provided by averaging approximately 50 readings at the specific GNR.",
		"There are five types of capillary ELISA cartridges. The cartridge type Customizable can be loaded with the user's antibody reagents and used for customized ELISA experiments. The other cartridge types - SinglePlex72X1, MultiAnalyte32X4, MultiAnalyte16X4 and MultiPlex32X8 - are pre-loaded with validated ELISA assays, available for more than 200 analytes. Different pre-loaded cartridge types provide different sample numbers, analyte numbers and internal replicates:",
		Grid[
			{
				{"Cartridge Type","Max Number of Samples","Max Number of Analytes","Internal Replicates per Sample","Preferred Loading Volume per Sample (After Dilution)"},
				{"Customizable","48","1 per Sample","3","50 Microliter"},
				{"SinglePlex72X1","72","1","3","50 Microliter"},
				{"MultiAnalyte32X4","32","4","3","50 Microliter"},
				{"MultiAnalyte16X4","16","4","3","50 Microliter"},
				{"MultiPlex32X8","32","8","2","50 Microliter"}
			}
		],
		"A capillary ELISA cartridge with Customizable cartridge type uses an anti-digoxigenin antibody coating in GNR to serve as the foundation for the assay. Custom capture antibody and detection antibody samples are prepared before starting the ELISA experiment. Two antibody reagents and the samples are loaded into different wells of capillary ELISA cartridge plate. Please refer to Object[EmeraldCloudFile,\"CapillaryELISA Customizable Cartridge Technical Note\"] and Object[EmeraldCloudFile,\"CapillaryELISA 48-Digoxigenin Cartridge Quick Start Guide\"] for details.",
		Grid[
			{
				{"Name","Required Conjugation","Preferred Conjugation Reagent","Preferred Concentration","Preferred Loading Volume","Purpose"},
				{"Sample","N/A","N/A","Minimum Diluteion Factor of 0.5","50 Microliter","-Detection and quantitation of analytes through antigen-antibody interaction with Capture Antibody and Detection Antibody."},
				{"Capture Antibody","Digoxigenin","Model[Sample,StockSolution,\"Digoxigenin-NHS, 0.67 mg/mL in DMF\"]","3.5 Microgram/Milliliter","50 Microliter","-Binding to the immobilized anti-digoxigenin monoclonal antibody in the capillaries;\n-Providing immobilization sites for analytes in Sample through antigen-antibody interaction."},
				{"Detection Antibody","Biotin","Model[Sample,StockSolution,\"Biotin-XX, 1 mg/mL in DMSO\"]","3.5 Microgram/Milliliter","50 Microliter","-Binding to the immobilized analytes in Sample through antigen-antibody interaction;\n-Providing attachment sites for streptavidin-conjugated fluorophore reagents for fluorescence measurements"}
			}
		],
		"A pre-loaded cartridge of ExperimentCapillaryELISA is loaded with capture antibodies and detection antibodies required for the entire ELISA workflow of the specific analytes. The cartridge comes with factory-calibrated standard curves of the assays, validated by the assay developer. A standard curve of an analyte was fit from standard sample data using the five-parameter logistic model:\nFluorescenceSignal = D + (A - D) / (1 + (Concentration / C) ^ B) ^ G\nFluorescence is provided in unit RFU and Concentration is provided in unit Picogram/Milliliter.",
		"Due to the manufacturing and validation steps, the lead time of a pre-loaded cartridge assay can take up to 14 days. It is recommended to use function UploadCapillaryELISACartridge to order a cartridge of interest ahead to reduce the waiting time of the experiment. Please refer to Object[Report,Literature,\"Simple Plex Assay Menu\"] for the available analytes of pre-loaded cartridges and Object[ManufacturingSpecification,CapillaryELISACartridge] of different analytes for compatibility and combination rules.",
		"In a pre-loaded cartridge, all samples must be extracted from same species (human, mouse or rat) and subjected to same analyte(s).",
		"Samples will be thawed and centrifuged at maximum speed (~14,800 rpm) for 7 minutes to separate any solid material from the liquid aliquot. The supernatant is used for sample spiking and dilution.",
		"If there are empty wells in the capillary ELISA cartridge after loading all the requested samples, standards and reagents, each empty well (sample well or antibody well) is filled with 50 Microliter of Model[Sample,\"Simple Plex Sample Diluent 13\"]. Due to the design of microfluidics system, it is not allowed to leave any wells dry and empty.",
        "CapillaryELISA experiment is run at 35Celsius temperature."
	},
	SeeAlso->{
		"ValidExperimentCapillaryELISAQ",
		"ExperimentCapillaryELISAOptions",
		"ExperimentELISA",
		"ExperimentWestern",
		"ExperimentTotalProteinQuantification",
		"ExperimentSamplePreparation"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"harrison.gronlund", "taylor.hochuli", "axu"}
}];



(* ::Subsubsection::Closed:: *)
(*ExperimentCapillaryELISAOptions*)

DefineUsage[ExperimentCapillaryELISAOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCapillaryELISAOptions[Samples]", "ResolvedOptions"},
				Description->"generates the 'ResolvedOptions' for performing capillary Enzyme-Linked Immunosorbent Assay (ELISA) experiment on the provided 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be analyzed using capillary ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
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
								},
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options describing how the capillary ELISA experiment is run when ExperimentCapillaryELISA is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"The options returned by ExperimentCapillaryELISAOptions may be passed directly to ExperimentCapillaryELISA."
		},
		SeeAlso->{
			"ExperimentCapillaryELISA",
			"ValidExperimentCapillaryELISAQ"
		},
		Author->{"dima", "clayton.schwarz", "axu"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentCapillaryELISAQ*)


DefineUsage[ValidExperimentCapillaryELISAQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentCapillaryELISAQ[Samples]", "Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentCapillaryELISA.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be analyzed using capillary ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
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
								},
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"The value indicating whether the ExperimentCapillary call is valid with the specified options on the provided samples. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentCapillaryELISA",
			"ExperimentCapillaryELISAOptions"
		},
		Author->{"dima", "clayton.schwarz", "axu"}
	}
];



DefineUsage[ExperimentCapillaryELISAPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCapillaryELISAPreview[Samples]","Preview"},
				Description->"returns a graphical preview of the capillary Enzyme-Linked Immunosorbent Assay (ELISA) experiment defined for 'Samples'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be analyzed using capillary ELISA for the detection and quantification of certain analytes such as peptides, proteins, antibodies and hormones.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
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
								},
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical preview of the ExperimentCapillaryELISA output. Return value can be changed via the OutputFormat option.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation->{
			"Due to the nature of ExperimentCapillaryELISA, no graphical preview is available for ExperimentCapillaryELISA. ExperimentCapillaryELISAPreview always returns Null."
		},
		SeeAlso->{
			"ExperimentCapillaryELISA",
			"ExperimentCapillaryELISAOptions",
			"ValidExperimentCapillaryELISAQ"
		},
		Author->{"dima", "clayton.schwarz", "axu"}
	}
];