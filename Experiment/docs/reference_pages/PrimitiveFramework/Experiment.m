(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*Experiment*)

DefineUsage[Experiment,
	{
		BasicDefinitions -> {
			{
				Definition->{"Experiment[UnitOperations]","Script"},
				Description->"creates a 'Script' object that will perform the experiments specified in 'UnitOperations'.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform a series of experiments.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualSamplePreparationMethodP,
										RoboticSamplePreparationMethodP,
										ManualCellPreparationMethodP,
										RoboticCellPreparationMethodP,
										ExperimentMethodP
									],
									ECL`Methods->{Experiment, ManualSamplePreparation, RoboticSamplePreparation, ManualCellPreparation, RoboticCellPreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ExperimentP]
								],
								Widget[Type -> UnitOperation, Pattern :> ExperimentP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Script",
						Description->"The script object describing how to perform the requested series of experiments.",
						Pattern:>ObjectP[Object[Notebook, Script]]
					}
				}
			}
		},
		PreviewFinalizedUnitOperations->True,
		ResolveInputs -> True,
		ResolveLabels -> True,
		SeeAlso -> {
			"ExperimentInputs",
			"ExperimentOptions",
			"ExperimentSamplePreparation",
			"ExperimentSamplePreparationOptions",
			"ExperimentSamplePreparationInputs",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"taylor.hochuli"}
	}
];


DefineUsage[ExperimentInputs,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentInputs[UnitOperations]","CalculatedUnitOperations"},
				Description->"returns the 'CalculatedUnitOperations' that will be used to perform the experiments specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform a series of experiments.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualSamplePreparationMethodP,
										RoboticSamplePreparationMethodP,
										ManualCellPreparationMethodP,
										RoboticCellPreparationMethodP,
										ExperimentMethodP
									],
									ECL`Methods->{Experiment, ManualSamplePreparation, RoboticSamplePreparation, ManualCellPreparation, RoboticCellPreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ExperimentP]
								],
								Widget[Type -> UnitOperation, Pattern :> ExperimentP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedUnitOperations",
						Description->"The calculated unit operations that will be used to perform the experiments.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"Experiment",
			"ExperimentOptions",
			"ExperimentSamplePreparation",
			"ExperimentSamplePreparationOptions",
			"ExperimentSamplePreparationInputs",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"taylor.hochuli"}
	}
];


DefineUsage[ExperimentOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentOptions[UnitOperations]","CalculatedOptions"},
				Description->"returns the 'CalculatedOptions' that will be used to perform the experiments specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform a series of experiments.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualSamplePreparationMethodP,
										RoboticSamplePreparationMethodP,
										ManualCellPreparationMethodP,
										RoboticCellPreparationMethodP,
										ExperimentMethodP
									],
									ECL`Methods->{Experiment, ManualSamplePreparation, RoboticSamplePreparation, ManualCellPreparation, RoboticCellPreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ExperimentP]
								],
								Widget[Type -> UnitOperation, Pattern :> ExperimentP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedOptions",
						Description->"The calculated options that will be used to perform the series of experiments.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"Experiment",
			"ExperimentInputs",
			"ExperimentSamplePreparation",
			"ExperimentSamplePreparationOptions",
			"ExperimentSamplePreparationInputs",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"taylor.hochuli"}
	}
];

DefineUsage[ValidExperimentQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentQ[UnitOperations]","Boolean"},
				Description->"checks whether the requested 'UnitOperations' and specified options are valid for calling Experiment.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform a series of experiments.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualSamplePreparationMethodP,
										RoboticSamplePreparationMethodP,
										ManualCellPreparationMethodP,
										RoboticCellPreparationMethodP,
										ExperimentMethodP
									],
									ECL`Methods->{Experiment, ManualSamplePreparation, RoboticSamplePreparation, ManualCellPreparation, RoboticCellPreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> ExperimentP]
								],
								Widget[Type -> UnitOperation, Pattern :> ExperimentP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description -> "Whether or not the Experiment call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"Experiment",
			"ExperimentInputs",
			"ExperimentOptions",
			"ExperimentSamplePreparation",
			"ExperimentSamplePreparationOptions",
			"ExperimentSamplePreparationInputs",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];

DefineUsage[ExperimentSamplePreparation,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentSamplePreparation[UnitOperations]","Protocol"},
				Description->"creates a 'Protocol' object that will perform the sample preparation specified in 'UnitOperations'.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the sample preparation.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualSamplePreparationMethodP,
										RoboticSamplePreparationMethodP
									],
									ECL`Methods->{ManualSamplePreparation, RoboticSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to perform the requested sample preparation.",
						Pattern:>ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation], Object[Notebook, Script]}]
					}
				}
			}
		},
		PreviewFinalizedUnitOperations->True,
		ResolveInputs -> True,
		ResolveLabels -> True,
		SeeAlso -> {
			"ExperimentSamplePreparationOptions",
			"ExperimentSamplePreparationInputs",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];


DefineUsage[ExperimentSamplePreparationInputs,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentSamplePreparationInputs[UnitOperations]","CalculatedUnitOperations"},
				Description->"returns the 'CalculatedUnitOperations' that will be used to perform the sample preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the sample preparation.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualSamplePreparationMethodP,
										RoboticSamplePreparationMethodP
									],
									ECL`Methods->{ManualSamplePreparation, RoboticSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedUnitOperations",
						Description->"The calculated unit operations that will be used to perform the sample preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentSamplePreparationOptions",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];


DefineUsage[ExperimentSamplePreparationOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentSamplePreparationOptions[UnitOperations]","CalculatedOptions"},
				Description->"returns the 'CalculatedOptions' that will be used to perform the sample preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the sample preparation.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualSamplePreparationMethodP,
										RoboticSamplePreparationMethodP
									],
									ECL`Methods->{ManualSamplePreparation, RoboticSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedOptions",
						Description->"The calculated options that will be used to perform the sample preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentSamplePreparationInputs",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];



DefineUsage[ExperimentSamplePreparationPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentSamplePreparationPreview[UnitOperations]","Preview"},
				Description->"returns the graphical 'Preview' for sample preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the sample preparation.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualSamplePreparationMethodP,
										RoboticSamplePreparationMethodP
									],
									ECL`Methods->{ManualSamplePreparation, RoboticSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentqPCR. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentSamplePreparationInputs",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];

DefineUsage[ValidExperimentSamplePreparationQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentSamplePreparationQ[UnitOperations]","Boolean"},
				Description->"checks whether the requested 'UnitOperations' and specified options are valid for calling ExperimentSamplePreparation.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the sample preparation.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualSamplePreparationMethodP,
										RoboticSamplePreparationMethodP
									],
									ECL`Methods->{ManualSamplePreparation, RoboticSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> SamplePreparationP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description -> "Whether or not the ExperimentSamplePreparation call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentSamplePreparationInputs",
			"ExperimentSamplePreparationOptions",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];

DefineUsage[ExperimentManualSamplePreparation,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentManualSamplePreparation[UnitOperations]","Protocol"},
				Description->"creates a 'Protocol' object that will perform the manual sample preparation specified in 'UnitOperations'.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the manual sample preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to perform the requested manual sample preparation.",
						Pattern:>ObjectP[Object[Protocol, ManualSamplePreparation]]
					}
				}
			}
		},
		PreviewFinalizedUnitOperations->True,
		ResolveInputs -> True,
		ResolveLabels -> True,
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentRoboticSamplePreparation",
			"ExperimentManualSamplePreparationInputs",
			"ExperimentManualSamplePreparationOptions"
		},
		Tutorials -> {},
		Author -> {"steven", "lige.tonggu", "thomas"}
	}
];

DefineUsage[ExperimentManualSamplePreparationInputs,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentManualSamplePreparationInputs[UnitOperations]","CalculatedUnitOperations"},
				Description->"returns the 'CalculatedUnitOperations' that will be used to perform the manual sample preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the manual sample preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedUnitOperations",
						Description->"The calculated unit operations that will be used to perform the manual sample preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation",
			"ExperimentManualSamplePreparationOptions"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];


DefineUsage[ExperimentManualSamplePreparationOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentManualSamplePreparationOptions[UnitOperations]","CalculatedOptions"},
				Description->"returns the 'CalculatedOptions' that will be used to perform the manual sample preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform a series the manual sample preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedOptions",
						Description->"The calculated options that will be used to perform the series the manual sample preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation",
			"ExperimentManualSamplePreparationInputs"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];

DefineUsage[ValidExperimentManualSamplePreparationQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentManualSamplePreparationQ[UnitOperations]","Boolean"},
				Description->"checks whether the requested 'UnitOperations' and specified options are valid for calling ExperimentManualSamplePreparation.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the sample preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> ManualSamplePreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description -> "Whether or not the ExperimentManualSamplePreparation call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation",
			"ExperimentManualSamplePreparationInputs"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];

DefineUsage[ExperimentRoboticSamplePreparation,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentRoboticSamplePreparation[UnitOperations]","Protocol"},
				Description->"creates a 'Protocol' object that will perform the robotic sample preparation specified in 'UnitOperations'.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the sample preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> RoboticSamplePreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to perform the specified robotic sample preparation.",
						Pattern:>ObjectP[Object[Protocol, RoboticSamplePreparation]]
					}
				}
			}
		},
		PreviewFinalizedUnitOperations->True,
		ResolveInputs -> True,
		ResolveLabels -> True,
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparationInputs"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];


DefineUsage[ExperimentRoboticSamplePreparationInputs,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentRoboticSamplePreparationInputs[UnitOperations]","CalculatedUnitOperations"},
				Description->"returns the 'CalculatedUnitOperations' that will be used to perform the robotic sample preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the robotic sample preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> RoboticSamplePreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedUnitOperations",
						Description->"The calculated unit operations that will be used to perform the robotic sample preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation",
			"ExperimentRoboticSamplePreparationOptions"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];


DefineUsage[ExperimentRoboticSamplePreparationOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentRoboticSamplePreparationOptions[UnitOperations]","CalculatedOptions"},
				Description->"returns the 'CalculatedOptions' that will be used to perform the robotic sample preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the robotic sample preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> RoboticSamplePreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedOptions",
						Description->"The calculated options that will be used to perform the robotic sample preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation",
			"ExperimentRoboticSamplePreparationInputs"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];

DefineUsage[ValidExperimentRoboticSamplePreparationQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentRoboticSamplePreparationQ[UnitOperations]","Boolean"},
				Description->"checks whether the requested 'UnitOperations' and specified options are valid for calling ExperimentRoboticSamplePreparation.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the robotic sample preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> RoboticSamplePreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description -> "Whether or not the ExperimentRoboticSamplePreparation call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation",
			"ExperimentRoboticSamplePreparationInputs"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];

DefineUsage[ExperimentCellPreparation,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentCellPreparation[UnitOperations]","Protocol"},
				Description->"creates a 'Protocol' object that will perform the cell preparation specified in 'UnitOperations'.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to prepare the given cells.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualCellPreparationMethodP,
										RoboticCellPreparationMethodP
									],
									ECL`Methods->{ManualCellPreparation, RoboticSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> CellPreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> CellPreparationP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to perform the requested cell preparation.",
						Pattern:>ObjectP[{Object[Protocol, ManualCellPreparation], Object[Protocol, RoboticCellPreparation], Object[Notebook, Script]}]
					}
				}
			}
		},
		PreviewFinalizedUnitOperations->True,
		ResolveInputs -> True,
		ResolveLabels -> True,
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparationInputs",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials -> {},
		Author -> {"steven"}
	}
];


DefineUsage[ExperimentCellPreparationInputs,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentCellPreparationInputs[UnitOperations]","CalculatedUnitOperations"},
				Description->"returns the 'CalculatedUnitOperations' that will be used to perform the cell preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the cell preparation.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualCellPreparationMethodP,
										RoboticCellPreparationMethodP
									],
									ECL`Methods->{ManualCellPreparation, RoboticSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> CellPreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> CellPreparationP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedUnitOperations",
						Description->"The calculated unit operations that will be used to perform the cell preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];


DefineUsage[ExperimentCellPreparationOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentCellPreparationOptions[UnitOperations]","CalculatedOptions"},
				Description->"returns the 'CalculatedOptions' that will be used to perform the cell preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the cell preparation.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualCellPreparationMethodP,
										RoboticCellPreparationMethodP
									],
									ECL`Methods->{ManualCellPreparation, RoboticSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> CellPreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> CellPreparationP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedOptions",
						Description->"The calculated options that will be used to perform the cell preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparationInputs",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];

DefineUsage[ValidExperimentCellPreparationQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentCellPreparationQ[UnitOperations]","Boolean"},
				Description->"checks whether the requested 'UnitOperations' and specified options are valid for calling ExperimentCellPreparation.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to prepare the given cells.",
						Widget->Adder[
							Alternatives[
								Widget[
									Type -> UnitOperationMethod,
									Pattern :> Alternatives[
										ManualCellPreparationMethodP,
										RoboticCellPreparationMethodP
									],
									ECL`Methods->{ManualCellPreparation, RoboticSamplePreparation},
									Widget->Widget[Type -> UnitOperation, Pattern :> CellPreparationP]
								],
								Widget[Type -> UnitOperation, Pattern :> CellPreparationP]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description -> "Whether or not the ExperimentCellPreparation call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparationInputs",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];


DefineUsage[ExperimentManualCellPreparation,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentManualCellPreparation[UnitOperations]","Protocol"},
				Description->"creates a 'Protocol' object that will perform the manual cell preparation specified in 'UnitOperations'.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the manual cell preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> ManualCellPreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to perform the requested cellular preparation.",
						Pattern:>ObjectP[Object[Protocol, ManualCellPreparation]]
					}
				}
			}
		},
		PreviewFinalizedUnitOperations->True,
		ResolveInputs -> True,
		ResolveLabels -> True,
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"ExperimentManualCellPreparationInputs",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];

DefineUsage[ExperimentManualCellPreparationInputs,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentManualCellPreparationInputs[UnitOperations]","CalculatedUnitOperations"},
				Description->"returns the 'CalculatedUnitOperations' that will be used to perform the manual cell preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the manual cell preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> ManualCellPreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedUnitOperations",
						Description->"The calculated unit operations that will be used to perform the manual cell preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];


DefineUsage[ExperimentManualCellPreparationOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentManualCellPreparationOptions[UnitOperations]","CalculatedOptions"},
				Description->"returns the 'CalculatedOptions' that will be used to perform the manual cell preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform a series the manual cell preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> ManualCellPreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedOptions",
						Description->"The calculated options that will be used to perform the series the manual cell preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];

DefineUsage[ValidExperimentManualCellPreparationQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentManualCellPreparationQ[UnitOperations]","Boolean"},
				Description->"checks whether the requested 'UnitOperations' and specified options are valid for calling ExperimentManualCellPreparation.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to prepare the given cells.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> ManualCellPreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description -> "Whether or not the ExperimentManualCellPreparation call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];


DefineUsage[ExperimentRoboticCellPreparation,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentRoboticCellPreparation[UnitOperations]","Protocol"},
				Description->"creates a 'Protocol' object that will perform the robotic cell preparation specified in 'UnitOperations'.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the specified robotic cell preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> RoboticCellPreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to perform the specified robotic cell preparation.",
						Pattern:>ObjectP[Object[Protocol, RoboticCellPreparation]]
					}
				}
			}
		},
		PreviewFinalizedUnitOperations->True,
		ResolveInputs -> True,
		ResolveLabels -> True,
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparationInputs"
		},
		Tutorials -> {},
		Author -> {"steven", "lige.tonggu", "thomas"}
	}
];

DefineUsage[ExperimentRoboticCellPreparationInputs,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentRoboticCellPreparationInputs[UnitOperations]","CalculatedUnitOperations"},
				Description->"returns the 'CalculatedUnitOperations' that will be used to perform the robotic cell preparation specified in 'UnitOperations'",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform the robotic cell preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> RoboticCellPreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedUnitOperations",
						Description->"The calculated unit operations that will be used to perform the robotic cell preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparationOptions"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];


DefineUsage[ExperimentRoboticCellPreparationOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentRoboticCellPreparationOptions[UnitOperations]","CalculatedOptions"},
				Description->"returns the 'CalculatedOptions' that will be used to perform the robotic cell preparation specified in 'UnitOperations'.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to perform a series the robotic cell preparation.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> RoboticCellPreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"CalculatedOptions",
						Description->"The calculated options that will be used to perform the series the robotic cell preparation.",
						Pattern:>_List
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparationInputs"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];

DefineUsage[ValidExperimentRoboticCellPreparationQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentRoboticCellPreparationQ[UnitOperations]","Boolean"},
				Description->"checks whether the requested 'UnitOperations' and specified options are valid for calling ExperimentRoboticCellPreparation.",
				Inputs:>{
					{
						InputName -> "UnitOperations",
						Description-> "The unit operations that specify how to prepare the given cells.",
						Widget->Adder[
							Widget[Type -> UnitOperation, Pattern :> RoboticCellPreparationP]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description -> "Whether or not the ExperimentRoboticCellPreparation call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentSamplePreparation",
			"ExperimentCellPreparation",
			"ExperimentManualCellPreparation",
			"ExperimentRoboticCellPreparationInputs"
		},
		Tutorials -> {},
		Author -> {"lige.tonggu"}
	}
];
