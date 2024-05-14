(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentAliquot*)


DefineUsage[ExperimentAliquot,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAliquot[Sample, AliquotAmount]","Protocol"},
				Description->"transfers 'Amount' of 'Sample'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False
						},
						{
							InputName -> "AliquotAmount",
							Description-> "The sample amount to be transferred.",
							Widget->Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[0.1 Microliter, 20 Liter],
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
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"A protocol containing instructions for completion of the requested sample transfer.",
						Pattern:>ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]
					}
				}
			},
			{
				Definition->{"ExperimentAliquot[Sample, AliquotTargetConcentration]","Protocol"},
				Description->"dilutes the 'Sample' to match the 'AliquotTargetConcentration'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False
						},
						{
							InputName -> "AliquotTargetConcentration",
							Description-> "The sample concentration to target.",
							Widget->Widget[
								Type->Quantity,
								Pattern:>GreaterP[0 Molar]|GreaterP[0 Milligram/Milliliter],
								Units->Alternatives[
									{1,{Micromolar,{Micromolar,Millimolar,Molar}}},
									CompoundUnit[
										{1,{Gram,{Gram,Microgram,Milligram}}},
										{-1,{Liter,{Liter,Microliter,Milliliter}}}
									]
								]
							],
							Expandable->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"A protocol containing instructions for completion of the requested sample transfer.",
						Pattern:>ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]
					}
				}
			},
			{
				Definition->{"ExperimentAliquot[Sample]","Protocol"},
				Description->"generates a 'Protocol' to perform basic sample transfer, aliquoting, or concentration adjustment for the provided 'Sample'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Sample",
							Description-> "The sample to be transferred.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"A protocol containing instructions for completion of the requested sample transfer.",
						Pattern:>ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]
					}
				},
				CommandBuilder -> False
			},
			{
				Definition->{"ExperimentAliquot[SamplePools, Amounts]","Protocol"},
				Description->"consolidates 'Amounts' of each sample together into 'SamplePools'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "SamplePools",
							Description-> "The samples that should be consolidated together into a pool.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						{
							InputName -> "Amounts",
							Description-> "The amount to be transferred for each sample in each pool.",
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
						OutputName->"Protocol",
						Description->"A protocol containing instructions for completion of the requested sample transfer.",
						Pattern:>ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]
					}
				}
			},
			{
				Definition->{"ExperimentAliquot[SamplePools, TargetConcentrations]","Protocol"},
				Description->"dilutes 'SamplePools' to match the 'TargetConcentrations'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "SamplePools",
							Description-> "The samples that should be consolidated together into a pool.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						{
							InputName -> "TargetConcentrations",
							Description-> "The sample concentration to target.",
							Widget->Widget[
								Type->Quantity,
								Pattern:>GreaterP[0 Molar]|GreaterP[0 Milligram/Milliliter],
								Units->Alternatives[
									{1,{Micromolar,{Micromolar,Millimolar,Molar}}},
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
						OutputName->"Protocol",
						Description->"A protocol containing instructions for completion of the requested sample transfer.",
						Pattern:>ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]
					}
				}
			},
			{
				Definition->{"ExperimentAliquot[SamplePools]","Protocol"},
				Description->"generates a 'Protocol' to perform basic sample transfer, aliquoting, or concentration adjustment for the provided 'SamplePools'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "SamplePools",
							Description-> "The samples that should be consolidated together into a pool.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample], Object[Container]}],
								Dereference -> {
									Object[Container] -> Field[Contents[[All, 2]]]
								},
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable->False,
							NestedIndexMatching -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"A protocol containing instructions for completion of the requested sample transfer.",
						Pattern:>ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]
					}
				},
				CommandBuilder -> False
			}
		},
		MoreInformation->{
			"When handling items that are discrete such as tablets, the Amount can be specified either as a raw Integer (i.e., 3) or as a quantity with the \"Unit\" unit (i.e., 3*Unit).  These are equivalent and will be converted to raw integers during option resolution.",
			"This function serves as a simplified interface to ExperimentSamplePreparation.",
			"If buffer is added to a given aliquot, the combined samples are mixed after transfer.",
			"If pooling multiple samples into the same well using the nested input, be sure to specify either Amount or TargetConcentration for each sample.  See the examples in the \"Pooling\" section below for how not doing this may lead to unexpected behavior."
		},
		SeeAlso->{
			"ValidExperimentAliquotQ",
			"ExperimentAliquotOptions",
			"ExperimentAliquotPreview",
			"ExperimentSamplePreparation",
			"ExperimentManualSamplePreparation",
			"ExperimentRoboticSamplePreparation",
			"Transfer",
			"Mix",
			"Aliquot",
			"Consolidate"
		},
		Author->{"ben", "tyler.pabst", "charlene.konkankit", "cgullekson", "steven", "marie.wu"}
	}
];