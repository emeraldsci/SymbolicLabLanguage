(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)

DefineUsage[ExperimentMedia,{
	BasicDefinitions->{
		{
			Definition->{"ExperimentMedia[MediaModel]", "Protocol"},
			Description->"generates a 'Protocol' for preparation of liquid or solid cell growth media according to its formula and preparation parameters defined in the 'MediaModel'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "MediaModel",
						Description -> "Model information for a mixed formulation designed to support the growth of microorganisms or cells.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample,Media]}]
						],
						Expandable->False
					},
					IndexName->"media"
				]
			},
			Outputs:>{
				{
					OutputName->"Protocol",
					Description->"Protocol specifying instructions for preparing the requested media.",
					Pattern:>ObjectP[Object[Protocol,StockSolution]]
				}
			}
		},
		{
			Definition->{"ExperimentMedia[Components,Solvent,TotalVolume]","Protocol"},
			Description->"creates a 'Protocol' for combining the exact amounts of the given list of 'Components', including optional GellingAgents such as Agar for solid media, and using 'Solvent' to fill to 'TotalVolume' after initial component combination. If no existing 'MediaModel' matches the specified list of 'Components', a new MediaModel will be created using UploadMedia with the provided components, Solvent, and total volume.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Components",
						Description->"A list of all samples and amounts to combine for preparation of the media (not including fill-to-volume solvent addition), with each addition in the form {amount,sample}.",
						Widget->Adder[
							{
								"Amount"->Alternatives[
									"Mass"->Widget[
										Type->Quantity,
										Pattern:>GreaterP[0*Milligram],
										Units->{Gram,{Milligram,Gram,Kilogram}}
									],
									"Volume"->Widget[
										Type->Quantity,
										Pattern:>GreaterP[0*Milliliter],
										Units->{Milliliter,{Microliter,Milliliter,Liter}}
									],
									"Count"->Widget[
										Type->Number,
										Pattern:>GreaterEqualP[1,1]
									]
								],
								"Sample"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
								]
							},
							Orientation->Vertical
						],
						Expandable->False
					},
					IndexName->"media"
				],
				IndexMatching[
					{
						InputName->"Solvent",
						Description->"The solvent used to bring up the volume to the solution's target volume after all other components have been added.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample]}],
							OpenPaths->{
								{
									Object[Catalog,"Root"],
									"Materials",
									"Reagents",
									"Water"
								}
							},
							PreparedSample->False
						],
						Expandable->False
					},
					IndexName->"media"
				],
				IndexMatching[
					{
						InputName->"TotalVolume",
						Description->"The total volume of solvent in which the provided components should be dissolved when this media model is prepared.",
						Widget->Widget[
							Type->Quantity,
							Pattern:>GreaterP[0*Milliliter],
							Units->{Milliliter,{Microliter,Milliliter,Liter}}
						],
						Expandable->False
					},
					IndexName->"media"
				]
			},
			Outputs:>{
				{
					OutputName->"Protocol",
					Description->"Protocol specifying instructions for preparing the requested media.",
					Pattern:>ObjectP[Object[Protocol,StockSolution]]
				}
			}
		},
		{
			Definition->{"ExperimentMedia[UnitOperations]","Protocol"},
			Description->"creates a 'Protocol' for media that is prepared by following the specified 'UnitOperations'.",
			Inputs:>{
				{
					InputName->"UnitOperations",
					Description->"The order of operations that is to be followed to make a median.",
					Widget->Alternatives[
						Adder[Alternatives[
							Widget[
								Type->UnitOperationMethod,
								Pattern:>ManualSamplePreparationMethodP,
								ECL`Methods->{ManualSamplePreparation},
								Widget->Widget[Type->UnitOperation,Pattern:>ManualSamplePreparationP]
							],
							Widget[Type->UnitOperation,Pattern:>ManualSamplePreparationP]
						]],
						Adder[Adder[Alternatives[
							Widget[
								Type->UnitOperationMethod,
								Pattern:>ManualSamplePreparationMethodP,
								ECL`Methods->{ManualSamplePreparation},
								Widget->Widget[Type->UnitOperation,Pattern:>ManualSamplePreparationP]
							],
							Widget[Type->UnitOperation,Pattern:>ManualSamplePreparationP]
						]]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"Protocol",
					Description->"Protocol specifying instructions for preparing the requested media.",
					Pattern:>ObjectP[Object[Protocol,StockSolution]]
				}
			}
		}
	},
	MoreInformation->{
		"Because this function may automatically generate names for new media models, it is possible that two different media models may have identical names. Please take care to avoid naming overlap with existing media."
	},
	SeeAlso->{
		"ExperimentMediaOptions",
		"ValidExperimentMediaQ",
		"ExperimentStockSolution",
		"ValidExperimentStockSolutionQ",
		"UploadMedia",
		"UploadStockSolution"
	},
	Author->{
		"daniel.shlian"
	}
}];

(* ::Subsubsection::Closed:: *)
(*ExperimentMediaOptions*)

DefineUsage[ExperimentMediaOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMediaOptions[Media]", "ResolvedOptions"},
				Description -> "returns 'ResolvedOptions' from ExperimentMedia for preparation of the given 'Media' according to its formula and using its preparation parameters as defaults.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Media",
							Description -> "The model of media to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample, Media]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from an ExperimentMedia call for preparing the provided media.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			},
			{
				Definition -> {"ExperimentMediaOptions[Components,Solvent,TotalVolume]", "ResolvedOptions"},
				Description -> "returns 'ResolvedOptions' from ExperimentMedia for combining 'Components' and using 'Solvent' to fill to 'TotalVolume' after initial component combination.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Components",
							Description -> "A list of components and amounts to combine before solvent addition, with each component in the form {component, amount}.",
							Widget -> Adder[
								{
									"Amount" -> Alternatives[
										"Mass" -> Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0 * Milligram],
											Units -> {Gram, {Milligram, Gram, Kilogram}}
										],
										"Volume" -> Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0 * Milliliter],
											Units -> {Milliliter, {Microliter, Milliliter, Liter}}
										],
										"Count" -> Widget[
											Type -> Number,
											Pattern :> GreaterEqualP[1, 1]
										]
									],
									"Component" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
									]
								},
								Orientation -> Vertical
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "Solvent",
							Description -> "The solvent used to bring up the volume to the solution's target volume after all other formula components have been added.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "TotalVolume",
							Description -> "The total volume of solvent in which the provided components should be dissolved when this media model is prepared.",
							Widget -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 * Milliliter],
								Units -> {Milliliter, {Microliter, Milliliter, Liter}}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from an ExperimentMedia call for preparing the provided stock solution.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			}
		},
		MoreInformation -> {
			"Because this function may automatically generate names for new media models, it is possible that two different media models may have identical names. Please take care to avoid naming overlap with existing media."
		},
		SeeAlso -> {
			"ExperimentMedia",
			"ValidExperimentMediaQ",
			"ExperimentMediaPreview",
			"UploadMedia",
			"ExperimentStockSolution",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"ExperimentIncubate",
			"ExperimentFilter",
			"UploadSampleModel"
		},
		Author -> {"daniel.shlian"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentMediaPreview*)


DefineUsage[ExperimentMediaPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMediaPreview[Media]", "Preview"},
				Description -> "returns a graphical representation for preparation of the given 'Media' according to its formula and using its preparation parameters as defaults. This 'Preview' is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Media",
							Description -> "The model of media to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample, Media]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided media preparation. This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition -> {"ExperimentMediaPreview[Components,Solvent,TotalVolume]", "Preview"},
				Description -> "returns a graphical representation for combining 'Components' and using 'Solvent' to fill to 'TotalVolume' after initial component combination. This 'Preview' is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Components",
							Description -> "A list of components and amounts to combine before solvent addition, with each component in the form {component, amount}.",
							Widget -> Adder[
								{
									"Amount" -> Alternatives[
										"Mass" -> Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0 * Milligram],
											Units -> {Gram, {Milligram, Gram, Kilogram}}
										],
										"Volume" -> Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0 * Milliliter],
											Units -> {Milliliter, {Microliter, Milliliter, Liter}}
										],
										"Count" -> Widget[
											Type -> Number,
											Pattern :> GreaterEqualP[1, 1]
										]
									],
									"Component" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
									]
								},
								Orientation -> Vertical
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "Solvent",
							Description -> "The solvent used to bring up the volume to the solution's target volume after all other formula components have been added.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "TotalVolume",
							Description -> "The total volume of solvent in which the provided components should be dissolved when this stock solution model is prepared.",
							Widget -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 * Milliliter],
								Units -> {Milliliter, {Microliter, Milliliter, Liter}}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided media preparation. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {
			"Currently, this preview function always returns Null."
		},
		SeeAlso -> {
			"ExperimentMedia",
			"ValidExperimentMediaQ",
			"ExperimentMediaPreview",
			"UploadMedia",
			"ExperimentStockSolution",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"ExperimentIncubate",
			"ExperimentFilter",
			"UploadSampleModel"
		},
		Author -> {"daniel.shlian"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentMediaQ*)


DefineUsage[ValidExperimentMediaQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentMediaQ[Media]", "Boolean"},
				Description -> "checks the validity of an ExperimentMedia call for preparation of the given 'Media' according to its formula and using its preparation parameters as defaults, returning a validity 'Boolean'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Media",
							Description -> "The model of stock solution to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample, Media]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A boolean indicating the validity of the ExperimentMedia call.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidExperimentMediaQ[Components,Solvent,TotalVolume]", "Boolean"},
				Description -> "checks the validity of an ExperimentMedia call for combining 'Components' and using 'Solvent' to fill to 'TotalVolume' after initial component combination, returning a validity 'Boolean'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Components",
							Description -> "A list of components and amounts to combine before solvent addition, with each component in the form {component, amount}.",
							Widget -> Adder[
								{
									"Amount" -> Alternatives[
										"Mass" -> Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0 * Milligram],
											Units -> {Gram, {Milligram, Gram, Kilogram}}
										],
										"Volume" -> Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0 * Milliliter],
											Units -> {Milliliter, {Microliter, Milliliter, Liter}}
										],
										"Count" -> Widget[
											Type -> Number,
											Pattern :> GreaterEqualP[1, 1]
										]
									],
									"Component" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
									]
								},
								Orientation -> Vertical
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "Solvent",
							Description -> "The solvent used to bring up the volume to the solution's target volume after all other formula components have been added.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "TotalVolume",
							Description -> "The total volume of solvent in which the provided components should be dissolved when this stock solution model is prepared.",
							Widget -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 * Milliliter],
								Units -> {Milliliter, {Microliter, Milliliter, Liter}}
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A boolean indicating the validity of the ExperimentMedia call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"Because this function may automatically generate names for new media models, it is possible that two different media models may have identical names. Please take care to avoid naming overlap with existing media."
		},
		SeeAlso -> {
			"ExperimentMedia",
			"ValidExperimentMediaQ",
			"ExperimentMediaPreview",
			"UploadMedia",
			"ExperimentStockSolution",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"ExperimentIncubate",
			"ExperimentFilter",
			"UploadSampleModel"
		},
		Author -> {"daniel.shlian"}
	}
];