(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentStockSolution*)


DefineUsage[ExperimentStockSolution,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentStockSolution[StockSolution]", "Protocol"},
				Description -> "generates a 'Protocol' for preparation of the given 'StockSolution' according to its formula and using its preparation parameters as defaults.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "StockSolution",
							Description -> "The model of stock solution to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}],
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Materials"
									}
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
						Description -> "Protocol specifying instructions for preparing the requested stock solution.",
						Pattern :> ObjectP[Object[Protocol, StockSolution]]
					}
				}
			},
			{
				Definition -> {"ExperimentStockSolution[Components,Solvent,TotalVolume]", "Protocol"},
				Description -> "creates a 'Protocol' for combining 'Components' and using 'Solvent' to fill to 'TotalVolume' after initial component combination. If necessary, a new stock solution model will be generated using UploadStockSolution with the provided components, Solvent, and total volume.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Components",
							Description -> "A list of all samples and amounts to combine for preparation of the stock solution (not including fill-to-volume solvent addition), with each addition in the form {amount, sample}.",
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
									"Sample" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
										OpenPaths -> {
											{
												Object[Catalog, "Root"],
												"Materials"
											}
										}
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
							Description -> "The solvent used to bring up the volume to the solution's target volume after all other components have been added.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample]}],
								PreparedSample->False,
								OpenPaths -> {
									{
										Object[Catalog, "Root"],
										"Materials",
										"Reagents",
										"Water"
									},
									{
										Object[Catalog, "Root"],
										"Materials",
										"Reagents",
										"Solvents"
									},
									{
										Object[Catalog, "Root"],
										"Materials",
										"Reagents",
										"Buffers"
									}
								}
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
						OutputName -> "Protocol",
						Description -> "Protocol specifying instructions for preparing the requested stock solution.",
						Pattern :> ObjectP[Object[Protocol, StockSolution]]
					}
				}
			},
			{
				Definition -> {"ExperimentStockSolution[Components]", "Protocol"},
				Description -> "creates a 'Protocol' for combining 'Components' without filling to a particular volume with a solvent. If necessary, a new stock solution model will be created using UploadStockSolution.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Components",
							Description -> "A list of all components and amounts to combine for preparation of the stock solution (not including fill-to-volume solvent addition), with each component in the form {amount, component}.",
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
										Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
										PreparedSample->False,
										OpenPaths -> {
											{
												Object[Catalog, "Root"],
												"Materials"
											}
										}
									]
								},
								Orientation -> Vertical
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "Protocol specifying instructions for preparing the requested stock solution.",
						Pattern :> ObjectP[Object[Protocol, StockSolution]]
					}
				}
			},
			{
				Definition->{"ExperimentStockSolution[UnitOperations]","Protocol"},
				Description->"creates a 'Protocol' for stock solution that is prepared by following the specified 'UnitOperations'.",
				Inputs:>{
					{
						InputName->"UnitOperations",
						Description->"The order of operations that is to be followed to make a stock solution.",
						Widget->Alternatives[
							Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]],
							Adder[Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]]]
						]
					}
				},
				Outputs:>{
					{
						OutputName -> "Protocol",
						Description -> "Protocol specifying instructions for preparing the requested stock solution.",
						Pattern :> ObjectP[Object[Protocol, StockSolution]]
					}
				}
			}
		},
		MoreInformation -> {
			"Stock solution preparation proceeds in the following order:\n\t- component combination\n\t- solvent filling to total volume\n\t- pHing\n\t- mixing\n\t- incubation\n\t- pH titration\n\t- filtration",
			"Stock solution models represent a specific combination of the formula and the preparation that should be performed when making a solution according to the formula. As a result, if specific preparation options are provided that differ from preparation information in the stock solution model, a new stock solution model - same formula, different preparation parameters - may be automatically created.",
			"See UploadStockSolution for more details about the direct formula input to this function."
		},
		SeeAlso -> {
			"ValidExperimentStockSolutionQ",
			"ExperimentStockSolutionOptions",
			"ExperimentStockSolutionPreview",
			"UploadStockSolution",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"ExperimentIncubate",
			"ExperimentFilter",
			"UploadSampleModel"
		},
		Author -> {"lei.tian", "tim.pierpont", "steven", "hayley"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentStockSolutionOptions*)


DefineUsage[ExperimentStockSolutionOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentStockSolutionOptions[StockSolution]", "ResolvedOptions"},
				Description -> "returns 'ResolvedOptions' from ExperimentStockSolution for preparation of the given 'StockSolution' according to its formula and using its preparation parameters as defaults.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "StockSolution",
							Description -> "The model of stock solution to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from an ExperimentStockSolution call for preparing the provided stock solution.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			},
			{
				Definition -> {"ExperimentStockSolutionOptions[Components,Solvent,TotalVolume]", "ResolvedOptions"},
				Description -> "returns 'ResolvedOptions' from ExperimentStockSolution for combining 'Components' and using 'Solvent' to fill to 'TotalVolume' after initial component combination.",
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
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from an ExperimentStockSolution call for preparing the provided stock solution.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			},
			{
				Definition -> {"ExperimentStockSolutionOptions[Components]", "ResolvedOptions"},
				Description -> "returns 'ResolvedOptions' from ExperimentStockSolution for preparing a stock solution according to the provided 'Components'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Components",
							Description -> "A list of all samples and amounts to combine for preparation of the stock solution, with each addition in the form {sample, amount}.",
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
									"Sample" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
									]
								},
								Orientation -> Vertical
							]
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from an ExperimentStockSolution call for preparing the provided stock solution.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			},
			{
				Definition->{"ExperimentStockSolutionOptions[UnitOperations]","ResolvedOptions"},
				Description->"returns 'ResolvedOptions' from ExperimentStockSolution for preparation by following the specified 'UnitOperations'.",
				Inputs:>{
					{
						InputName->"UnitOperations",
						Description->"The order of operations that is to be followed to make a stock solution.",
						Widget->Alternatives[
							Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]],
							Adder[Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from an ExperimentStockSolution call for preparing the provided stock solution.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			}
		},
		MoreInformation -> {
			"Stock solution preparation proceeds in the following order:\n\t- component combination\n\t- solvent filling to total volume\n\t- mixing\n\t- incubation\n\t- pH adjustment\n\t- filtration"
		},
		SeeAlso -> {
			"ExperimentStockSolution",
			"ValidExperimentStockSolutionQ",
			"ExperimentStockSolutionPreview",
			"UploadStockSolution",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"ExperimentIncubate",
			"ExperimentFilter",
			"UploadSampleModel"
		},
		Author -> {"lei.tian", "tim.pierpont", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentStockSolutionPreview*)


DefineUsage[ExperimentStockSolutionPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentStockSolutionPreview[StockSolution]", "Preview"},
				Description -> "returns a graphical representation for preparation of the given 'StockSolution' according to its formula and using its preparation parameters as defaults. This 'Preview' is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "StockSolution",
							Description -> "The model of stock solution to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided stock solution preparation. This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition -> {"ExperimentStockSolutionPreview[Components,Solvent,TotalVolume]", "Preview"},
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
						Description -> "A graphical representation of the provided stock solution preparation. This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition -> {"ExperimentStockSolutionPreview[Components]", "Preview"},
				Description -> "returns a graphical representation for preparing a stock solution according to the provided 'Components'. This 'Preview' is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Components",
							Description -> "A list of all sample and amounts to combine for preparation of the stock solution, with each addition in the form {sample, amount}.",
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
									"Sample" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
									]
								},
								Orientation -> Vertical
							]
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided stock solution preparation. This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition->{"ExperimentStockSolutionPreview[UnitOperations]","Preview"},
				Description->"returns 'Preview' from ExperimentStockSolution for preparation by following the specified 'UnitOperations'.",
				Inputs:>{
					{
						InputName->"UnitOperations",
						Description->"The order of operations that is to be followed to make a stock solution.",
						Widget->Alternatives[
							Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]],
							Adder[Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided stock solution preparation. This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition->{"ValidExperimentStockSolutionQ[UnitOperations]","Boolean"},
				Description->"checks the validity of an ExperimentStockSolution call for preparation by following the specified 'UnitOperations'.",
				Inputs:>{
					{
						InputName->"UnitOperations",
						Description->"The order of operations that is to be followed to make a stock solution.",
						Widget->Alternatives[
							Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]],
							Adder[Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A boolean indicating the validity of the ExperimentStockSolution call.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {
			"Currently, this preview function always returns Null."
		},
		SeeAlso -> {
			"ExperimentStockSolution",
			"ValidExperimentStockSolutionQ",
			"ExperimentStockSolutionOptions",
			"UploadStockSolution",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"ExperimentIncubate",
			"ExperimentFilter",
			"UploadSampleModel"
		},
		Author -> {"lei.tian", "tim.pierpont", "nont.kosaisawe", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentStockSolutionQ*)


DefineUsage[ValidExperimentStockSolutionQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentStockSolutionQ[StockSolution]", "Boolean"},
				Description -> "checks the validity of an ExperimentStockSolution call for preparation of the given 'StockSolution' according to its formula and using its preparation parameters as defaults, returning a validity 'Boolean'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "StockSolution",
							Description -> "The model of stock solution to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Sample, StockSolution], Model[Sample, Matrix], Model[Sample, Media]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A boolean indicating the validity of the ExperimentStockSolution call.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidExperimentStockSolutionQ[Components,Solvent,TotalVolume]", "Boolean"},
				Description -> "checks the validity of an ExperimentStockSolution call for combining 'Components' and using 'Solvent' to fill to 'TotalVolume' after initial component combination, returning a validity 'Boolean'.",
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
						Description -> "A boolean indicating the validity of the ExperimentStockSolution call.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidExperimentStockSolutionQ[Components]", "Boolean"},
				Description -> "checks the validity of an ExperimentStockSolution call for preparing a stock solution according to the 'Components' specification, returning a validity 'Boolean'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Components",
							Description -> "A list of all samples and amounts to combine for preparation of the stock solution, with each addition in the form {samples, amount}.",
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
							]
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A boolean indicating the validity of the ExperimentStockSolution call.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition->{"ValidExperimentStockSolutionQ[UnitOperations]","Boolean"},
				Description->"checks the validity of an ExperimentStockSolution call for preparation by following the specified 'UnitOperations'.",
				Inputs:>{
					{
						InputName->"UnitOperations",
						Description->"The order of operations that is to be followed to make a stock solution.",
						Widget->Alternatives[
							Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]],
							Adder[Adder[Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> ManualSamplePreparationMethodP,
									ECL`Methods->{ManualSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
							]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A boolean indicating the validity of the ExperimentStockSolution call.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {
			"Stock solution preparation proceeds in the following order:\n\t- component combination\n\t- solvent filling to total volume\n\t- mixing\n\t- incubation\n\t- pH adjustment\n\t- filtration"
		},
		SeeAlso -> {
			"ExperimentStockSolution",
			"ExperimentStockSolutionOptions",
			"ExperimentStockSolutionPreview",
			"UploadStockSolution",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"ExperimentIncubate",
			"ExperimentFilter",
			"UploadSampleModel"
		},
		Author -> {"lei.tian", "tim.pierpont", "steven"}
	}
];