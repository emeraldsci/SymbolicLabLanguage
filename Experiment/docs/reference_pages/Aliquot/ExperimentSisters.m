(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ValidExperimentAliquotQ*)


DefineUsage[ValidExperimentAliquotQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentAliquotQ[Sample,Amount]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an ExperimentAliquot call for transferring 'amount' of 'Sample'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Sample]],
								ObjectTypes->{Object[Sample]}
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						{
							InputName -> "Amount",
							Description-> "The sample amount to be transferred.",
							Widget->Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Microliter, 20 Liter],
									Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
								],
								"Mass" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Milligram, 20 Kilogram],
									Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
								],
								"Count" -> Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Unit, 1 Unit],
									Units -> {1, {Unit, {Unit}}}
								],
								"Count" -> Widget[
									Type -> Number,
									Pattern :> GreaterP[0., 1.]
								],
								"All" -> Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[All]
								]
							],
							Expandable->True,
							NestedIndexMatching -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A True/False value indicating the validity of the provided ExperimentAliquot call.",
						Pattern:>BooleanP
					}
				}
			},
			{
				Definition->{"ValidExperimentAliquotQ[Sample,TargetConcentration]","Boolean"},
				Description->"returns a 'Boolean' indicating the validity of an ExperimentAliquot call for diluting 'Sample' to the 'targetConcentration'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Sample]],
								ObjectTypes->{Object[Sample]}
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						{
							InputName -> "TargetConcentration",
							Description-> "The sample concentration to target.",
							Widget->Widget[
								Type->Quantity,
								Pattern:>GreaterP[0 Molar]|GreaterP[0 Milligram/Milliliter],
								Units->Alternatives[
									Micromolar,
									Millimolar,
									Molar,
									CompoundUnit[
										{1,{Gram,{Gram,Microgram,Milligram}}},
										{-1,{Liter,{Liter,Microliter,Milliliter}}}
									]
								]
							],
							Expandable->True,
							NestedIndexMatching -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A True/False value indicating the validity of the provided ExperimentAliquot call.",
						Pattern:>BooleanP
					}
				}
			},
			{
				Definition->{"ValidExperimentAliquotQ[Sample]","Boolean"},
				Description->"validates an ExperimentAliquot call to perform basic sample transfer, aliquoting, or concentration adjustment for the provided 'Sample'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Sample]],
								ObjectTypes->{Object[Sample]}
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"A True/False value indicating the validity of the provided ExperimentAliquot call.",
						Pattern:>BooleanP
					}
				}
			}
		},
		MoreInformation->{
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentAliquot proper, will return a valid experiment."
		},
		SeeAlso->{
			"ExperimentAliquot",
			"ExperimentAliquotOptions",
			"ExperimentAliquotPreview",
			"ExperimentSamplePreparation",
			"Transfer",
			"Mix",
			"Aliquot",
			"Consolidate"
		},
		Author->{"ben", "tyler.pabst", "charlene.konkankit", "cgullekson", "steven", "hayley"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentAliquotOptions*)


DefineUsage[ExperimentAliquotOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAliquotOptions[Sample,Amount]","ResolvedOptions"},
				Description->"returns the 'ResolvedOptions' for an ExperimentAliquot call to transfer 'amount' of 'Sample'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Sample]],
								ObjectTypes->{Object[Sample]}
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						{
							InputName -> "Amount",
							Description-> "The sample amount to be transferred.",
							Widget->Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Microliter, 20 Liter],
									Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
								],
								"Mass" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Milligram, 20 Kilogram],
									Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
								],
								"Count" -> Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Unit, 1 Unit],
									Units -> {1, {Unit, {Unit}}}
								],
								"Count" -> Widget[
									Type -> Number,
									Pattern :> GreaterP[0., 1.]
								],
								"All" -> Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[All]
								]
							],
							Expandable->True,
							NestedIndexMatching -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The fully resolved options resulting from the provided ExperimentAliquot call.",
						Pattern:>{_Rule..}
					}
				}
			},
			{
				Definition->{"ExperimentAliquotOptions[Sample,TargetConcentration]","ResolvedOptions"},
				Description->"returns the 'ResolvedOptions' for an ExperimentAliquot call to dilute 'Sample' to 'targetConcentration'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Sample]],
								ObjectTypes->{Object[Sample]}
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						{
							InputName -> "TargetConcentration",
							Description-> "The sample concentration to target.",
							Widget->Widget[
								Type->Quantity,
								Pattern:>GreaterP[0 Molar]|GreaterP[0 Milligram/Milliliter],
								Units->Alternatives[
									Micromolar,
									Millimolar,
									Molar,
									CompoundUnit[
										{1,{Gram,{Gram,Microgram,Milligram}}},
										{-1,{Liter,{Liter,Microliter,Milliliter}}}
									]
								]
							],
							Expandable->True,
							NestedIndexMatching -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The fully resolved options resulting from the provided ExperimentAliquot call.",
						Pattern:>{_Rule..}
					}
				}
			},
			{
				Definition->{"ExperimentAliquotOptions[Sample]","ResolvedOptions"},
				Description->"returns the resolved options for an ExperimentAliquot to perform basic sample transfer, aliquoting, or concentration adjustment for the provided 'Sample'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Sample]],
								ObjectTypes->{Object[Sample]}
							],
							Expandable->False,
							NestedIndexMatching -> True

						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"The fully resolved options resulting from the provided ExperimentAliquot call.",
						Pattern:>{_Rule..}
					}
				}
			}
		},
		MoreInformation->{
			"The options returned by this function may be passed directly to ExperimentAliquot."
		},
		SeeAlso->{
			"ExperimentAliquot",
			"ValidExperimentAliquotQ",
			"ExperimentAliquotPreview",
			"ExperimentSamplePreparation",
			"Transfer",
			"Mix",
			"Aliquot",
			"Consolidate"
		},
		Author->{"ben", "tyler.pabst", "charlene.konkankit", "cgullekson", "steven", "hayley"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ExperimentAliquotPreview*)


DefineUsage[ExperimentAliquotPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAliquotPreview[Sample,Amount]","Preview"},
				Description->"returns a graphical representation for an ExperimentAliquot call that transfers 'amount' of 'Sample'. This value is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Sample]],
								ObjectTypes->{Object[Sample]}
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						{
							InputName -> "Amount",
							Description-> "The sample amount to be transferred.",
							Widget->Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Microliter, 20 Liter],
									Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
								],
								"Mass" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1 Milligram, 20 Kilogram],
									Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
								],
								"Count" -> Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Unit, 1 Unit],
									Units -> {1, {Unit, {Unit}}}
								],
								"Count" -> Widget[
									Type -> Number,
									Pattern :> GreaterP[0., 1.]
								],
								"All" -> Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[All]
								]
							],
							Expandable->True,
							NestedIndexMatching -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical representation of the provided sample aliquoting. This value is always Null.",
						Pattern:>Null
					}
				}
			},
			{
				Definition->{"ExperimentAliquotPreview[Sample,TargetConcentration]","Preview"},
				Description->"returns a graphical representation for an ExperimentAliquot call that dilutes 'Sample' to the 'targetConcentration'. This value is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Sample]],
								ObjectTypes->{Object[Sample]}
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						{
							InputName -> "TargetConcentration",
							Description-> "The sample concentration to target.",
							Widget->Widget[
								Type->Quantity,
								Pattern:>GreaterP[0 Molar]|GreaterP[0 Milligram/Milliliter],
								Units->Alternatives[
									Micromolar,
									Millimolar,
									Molar,
									CompoundUnit[
										{1,{Gram,{Gram,Microgram,Milligram}}},
										{-1,{Liter,{Liter,Microliter,Milliliter}}}
									]
								]
							],
							Expandable->True,
							NestedIndexMatching -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical representation of the provided sample aliquoting. This value is always Null.",
						Pattern:>Null
					}
				}
			},
			{
				Definition->{"ExperimentAliquotPreview[Sample]","Preview"},
				Description->"generates a graphical representation of basic sample transfer, aliquoting, or concentration adjustments for the provided 'Sample'. This value is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Object[Sample]],
								ObjectTypes->{Object[Sample]}
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical representation of the provided sample aliquoting. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation->{
			"This function currently does not return any preview."
		},
		SeeAlso->{
			"ExperimentAliquot",
			"ValidExperimentAliquotQ",
			"ExperimentAliquotOptions",
			"ExperimentSamplePreparation",
			"Transfer",
			"Mix",
			"Aliquot",
			"Consolidate"
		},
		Author->{"ben", "tyler.pabst", "charlene.konkankit", "cgullekson", "steven", "hayley"}
	}
];