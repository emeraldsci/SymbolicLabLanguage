(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*UploadStockSolution*)


(* ::Subsubsection::Closed:: *)
(*UploadStockSolution*)


DefineUsage[UploadStockSolution,
	{
		BasicDefinitions->{
			{
				Definition->{"UploadStockSolution[Components,Solvent,TotalVolume]","StockSolutionModel"},
				Description->"creates a new 'StockSolutionModel' for combining 'components' and using 'solvent' to fill to 'totalVolume' after initial component combination.",
				Inputs:>{
					{
						InputName->"Components",
						Description->"A list of samples and amounts to combine before solvent addition, with each addition in the form {sample, amount}.",
						Widget->Adder[
							{
								"amount"->Alternatives[
									"Mass" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milligram],
										Units -> {Gram, {Milligram, Gram, Kilogram}}
									],
									"Volume" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milliliter],
										Units -> {Milliliter,{Microliter, Milliliter, Liter}}
									],
									"Count" -> Widget[
										Type->Number,
										Pattern:>GreaterEqualP[1,1]
									]
								],
								"Sample"-> Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]]
								]
							},
							Orientation->Vertical
						],
						Expandable->False
					},
					{
						InputName->"Solvent",
						Description->"The solvent used to bring up the volume to the solution's target volume after all other components have been added.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample]}]
						],
						Expandable->False
					},
					{
						InputName->"TotalVolume",
						Description->"The total volume of solvent in which the provided components should be dissolved when this stock solution model is prepared.",
						Widget->Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0*Milliliter],
							Units -> {Milliliter,{Microliter, Milliliter, Liter}}
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"StockSolutionModel",
						Description->"The newly-created stock solution model.",
						Pattern:>ObjectP[{Model[Sample,StockSolution],Model[Sample,Matrix],Model[Sample,Media]}]
					}
				}
			},
			{
				Definition->{"UploadStockSolution[Components]","StockSolutionModel"},
				Description->"creates a new 'StockSolutionModel' that is prepared by combining all samples as specified in the 'components'.",
				Inputs:>{
					{
						InputName->"Components",
						Description->"A list of all samples and amounts to combine for preparation of the stock solution, with each addition in the form {sample, amount}.",
						Widget->Adder[
							{
								"amount"->Alternatives[
									"Mass" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milligram],
										Units -> {Gram, {Milligram, Gram, Kilogram}}
									],
									"Volume" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milliliter],
										Units -> {Milliliter,{Microliter, Milliliter, Liter}}
									],
									"Count" -> Widget[
										Type->Number,
										Pattern:>GreaterEqualP[1,1]
									]
								],
								"Sample"-> Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]]
								]
							},
							Orientation->Vertical
						]
					}
				},
				Outputs:>{
					{
						OutputName->"StockSolutionModel",
						Description->"The newly-created stock solution model.",
						Pattern:>ObjectP[{Model[Sample,StockSolution],Model[Sample,Matrix],Model[Sample,Media]}]
					}
				}
			},
			{
				Definition->{"UploadStockSolution[TemplateStockSolution]","StockSolutionModel"},
				Description->"creates a new 'StockSolutionModel' using the formula from the 'TemplateStockSolution' and drawing any preparation parameter defaults from the 'TemplateStockSolution'.",
				Inputs:>{
					{
						InputName->"TemplateStockSolution",
						Description->"An existing stock solution model from which to use preparation parameters as defaults when creating a new model.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample,StockSolution],Model[Sample,Matrix],Model[Sample,Media]}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"StockSolutionModel",
						Description->"The newly-created stock solution model.",
						Pattern:>ObjectP[{Model[Sample,StockSolution],Model[Sample,Matrix],Model[Sample,Media]}]
					}
				}
			},
			{
				Definition->{"UploadStockSolution[UnitOperations]","StockSolutionModel"},
				Description->"creates a new 'StockSolutionModel' that is prepared by following the specified 'UnitOperations'.",
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
						OutputName->"StockSolutionModel",
						Description->"The newly-created stock solution model.",
						Pattern:>ObjectP[{Model[Sample,StockSolution],Model[Sample,Matrix],Model[Sample,Media]}]
					}
				}
			}
		},
		MoreInformation->{
			"If an existing stock solution model is found that matches all of the parameters specified for the new stock solution model, the existing model is returned in a simplified packet.",
			"However if a Name is explicitly provided, a new stock solution model will ALWAYS be uploaded.",
			"Stock solution models generated with this function may be then prepared via ExperimentStockSolution.",
			"ExperimentStockSolution also has an overload that directly calls this function.",
			"Components will be combined in the following order: \n\t1.) All solids are combined first in the provided order\n\t2.) All liquids will be added in the provided order, except for acids and bases\n\t3.) (optional): Fill-to-volume additions will be made to the provided total volume\n\t4.) All liquids that are acids and bases will be added"
		},
		SeeAlso->{
			"UploadStockSolutionOptions",
			"ValidUploadStockSolutionQ",
			"ExperimentStockSolution",
			"UploadSampleModel",
			"UploadProduct"
		},
		Author->{"tim.pierpont", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadStockSolutionOptions*)


DefineUsage[UploadStockSolutionOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"UploadStockSolutionOptions[Components,Solvent,TotalVolume]","ResolvedOptions"},
				Description->"returns the 'ResolvedOptions' from UploadStockSolution if generating a new stock solution model for combining 'components' and using 'solvent' to fill to 'totalVolume' after initial component combination.",
				Inputs:>{
					{
						InputName->"Components",
						Description->"A list of components and amounts to combine before solvent addition, with each component in the form {component, amount}.",
						Widget->Adder[
							{
								"amount"->Alternatives[
									"Mass" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milligram],
										Units -> {Gram, {Milligram, Gram, Kilogram}}
									],
									"Volume" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milliliter],
										Units -> {Milliliter,{Microliter, Milliliter, Liter}}
									],
									"Count" -> Widget[
										Type->Number,
										Pattern:>GreaterEqualP[1,1]
									]
								],
								"Sample"-> Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]]
								]
							},
							Orientation->Vertical
						],
						Expandable->False
					},
					{
						InputName->"Solvent",
						Description->"The solvent used to bring up the volume to the solution's target volume after all other formula component have been added.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample]}]
						],
						Expandable->False
					},
					{
						InputName->"TotalVolume",
						Description->"The total volume of solvent in which the provided components should be dissolved when this stock solution model is prepared.",
						Widget->Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0*Milliliter],
							Units -> {Milliliter,{Microliter, Milliliter, Liter}}
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options from UploadStockSolution for the provided formula.",
						Pattern:>{Rule[_Symbol,Except[Automatic]]..}
					}
				}
			},
			{
				Definition->{"UploadStockSolutionOptions[Components]","ResolvedOptions"},
				Description->"returns the 'ResolvedOptions' from UploadStockSolution if generating a new stock solution model with the given 'components'.",
				Inputs:>{
					{
						InputName->"Components",
						Description->"A list of all components and amounts to combine for preparation of the stock solution, with each addition in the form {sample, amount}.",
						Widget->Adder[
							{
								"amount"->Alternatives[
									"Mass" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milligram],
										Units -> {Gram, {Milligram, Gram, Kilogram}}
									],
									"Volume" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milliliter],
										Units -> {Milliliter,{Microliter, Milliliter, Liter}}
									],
									"Count" -> Widget[
										Type->Number,
										Pattern:>GreaterEqualP[1,1]
									]
								],
								"Sample"-> Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]]
								]
							},
							Orientation->Vertical
						]
					}
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options from UploadStockSolution for the provided components.",
						Pattern:>{Rule[_Symbol,Except[Automatic]]..}
					}
				}
			},
			{
				Definition->{"UploadStockSolutionOptions[TemplateStockSolution]","ResolvedOptions"},
				Description->"returns the 'resolvedOptions` from UploadStockSolution if using the formula from the 'TemplateStockSolution' and drawing any preparation parameter defaults from the 'TemplateStockSolution'.",
				Inputs:>{
					{
						InputName->"TemplateStockSolution",
						Description->"An existing stock solution model from which to use preparation parameters as defaults when creating a new model.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample,StockSolution],Model[Sample,Matrix],Model[Sample,Media]}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options from UploadStockSolution for the provided components.",
						Pattern:>{Rule[_Symbol,Except[Automatic]]..}
					}
				}
			},
			{
				Definition->{"UploadStockSolutionOptions[UnitOperations]","ResolvedOptions"},
				Description->"returns the 'resolvedOptions` from UploadStockSolution if using the specified 'UnitOperations'.",
				Inputs:>{
					{
						InputName->"UnitOperations",
						Description->"The order of operations that is to be followed to make a stock solution.",
						Widget->Adder[Widget[
							Type->UnitOperation,
							Pattern:>ManualSamplePreparationP
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The resolved options from UploadStockSolution for the provided components.",
						Pattern:>{Rule[_Symbol,Except[Automatic]]..}
					}
				}
			}
		},
		SeeAlso->{
			"UploadStockSolution",
			"ValidUploadStockSolutionQ",
			"ExperimentStockSolution",
			"ValidExperimentStockSolutionQ",
			"ExperimentStockSolutionOptions",
			"UploadSampleModel",
			"UploadProduct"
		},
		Author->{"tim.pierpont", "steven"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadStockSolutionQ*)


DefineUsage[ValidUploadStockSolutionQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidUploadStockSolutionQ[Components,Solvent,TotalVolume]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an UploadStockSolution call for generating a new stock solution model for combining 'components' and using 'solvent' to fill to 'totalVolume' after initial component combination.",
				Inputs:>{
					{
						InputName->"Components",
						Description->"A list of components and amounts to combine before solvent addition, with each component in the form {component, amount}.",
						Widget->Adder[
							{
								"amount"->Alternatives[
									"Mass" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milligram],
										Units -> {Gram, {Milligram, Gram, Kilogram}}
									],
									"Volume" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milliliter],
										Units -> {Milliliter,{Microliter, Milliliter, Liter}}
									],
									"Count" -> Widget[
										Type->Number,
										Pattern:>GreaterEqualP[1,1]
									]
								],
								"Sample"-> Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]]
								]
							},
							Orientation->Vertical
						],
						Expandable->False
					},
					{
						InputName->"Solvent",
						Description->"The solvent used to bring up the volume to the solution's target volume after all other formula component have been added.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample]}]
						],
						Expandable->False
					},
					{
						InputName->"TotalVolume",
						Description->"The total volume of solvent in which the provided components should be dissolved when this stock solution model is prepared.",
						Widget->Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0*Milliliter],
							Units -> {Milliliter,{Microliter, Milliliter, Liter}}
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A boolean indicating the validity of the UploadStockSolution call.",
						Pattern:>BooleanP
					}
				}
			},
			{
				Definition->{"ValidUploadStockSolutionQ[Components]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an UploadStockSolution call for creating a new model with the provided 'components'.",
				Inputs:>{
					{
						InputName->"Components",
						Description->"A list of all samples and amounts to combine for preparation of the stock solution, with each addition in the form {sample, amount}.",
						Widget->Adder[
							{
								"amount"->Alternatives[
									"Mass" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milligram],
										Units -> {Gram, {Milligram, Gram, Kilogram}}
									],
									"Volume" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0*Milliliter],
										Units -> {Milliliter,{Microliter, Milliliter, Liter}}
									],
									"Count" -> Widget[
										Type->Number,
										Pattern:>GreaterEqualP[1,1]
									]
								],
								"Sample"-> Widget[
									Type->Object,
									Pattern:>ObjectP[Model[Sample]]
								]
							},
							Orientation->Vertical
						]
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A boolean indicating the validity of the UploadStockSolution call.",
						Pattern:>BooleanP
					}
				}
			},
			{
				Definition->{"ValidUploadStockSolutionQ[TemplateStockSolution]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an UploadStockSolution call for creating a new model based on the provided 'TemplateStockSolution'.",
				Inputs:>{
					{
						InputName->"TemplateStockSolution",
						Description->"An existing stock solution model from which to use preparation parameters as defaults when creating a new model.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Sample,StockSolution],Model[Sample,Matrix],Model[Sample,Media]}]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A boolean indicating the validity of the UploadStockSolution call.",
						Pattern:>BooleanP
					}
				}
			},
			{
				Definition->{"ValidUploadStockSolutionQ[UnitOperations]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an UploadStockSolution call for creating a new model based on the provided 'UnitOperations'.",
				Inputs:>{
					{
						InputName->"UnitOperations",
						Description->"The order of operations that is to be followed to make a stock solution.",
						Widget->Adder[Widget[
							Type->UnitOperation,
							Pattern:>ManualSamplePreparationP
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A boolean indicating the validity of the UploadStockSolution call.",
						Pattern:>BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"UploadStockSolution",
			"UploadStockSolutionOptions",
			"ExperimentStockSolution",
			"ExperimentStockSolutionOptions",
			"ValidExperimentStockSolutionQ",
			"UploadSampleModel",
			"UploadProduct"
		},
		Author->{"tim.pierpont", "steven"}
	}
];