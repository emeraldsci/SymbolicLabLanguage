(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentWaterPreparation*)

DefineUsage[ExperimentWaterPreparation,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentWaterPreparation[Models, Containers, Amounts]","Protocol"},
				Description -> "creates a 'Protocol' object that will transfer 'Amounts' of each of the water 'Models' to 'Containers'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Models",
							Description-> "The water models that are prepared.",
							Widget -> Alternatives[
								"Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]]
								]
							],
							Expandable -> False
						},
						{
							InputName -> "Containers",
							Description-> "The containers to which the water is transferred.",
							Widget -> Alternatives[
								"Object" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container], Model[Container]}]
								]
							],
							Expandable -> True
						},
						{
							InputName -> "Amounts",
							Description -> "The volumes of the water to be transferred.",
							Widget -> Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1.5 Milliliter, 20 Liter],
									Units -> {1, {Milliliter, { Milliliter, Liter}}}
								]
							],
							Expandable -> True
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "The protocol object describing how to perform the requested water generation.",
						Pattern :> ListableP[ObjectP[Object[Protocol, WaterPreparation]]]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentWaterPreparationOptions",
			"ValidExperimentWaterPreparationQ",
			"ExperimentSamplePreparation"
		},
		Author -> {"jireh.sacramento"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ExperimentWaterPreparationOptions*)

DefineUsage[ExperimentWaterPreparationOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentWaterPreparationOptions[Models, Containers, Amounts]", "ResolvedOptions"},
				Description->"generates the 'ResolvedOptions' for performing a water preparation experiment.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Models",
							Description-> "The water models that are prepared.",
							Widget -> Alternatives[
								"Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]]
								]
							],
							Expandable -> False
						},
						{
							InputName -> "Containers",
							Description-> "The containers to which the water is transferred.",
							Widget -> Alternatives[
								"Object" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container], Model[Container]}]
								]
							],
							Expandable -> True
						},
						{
							InputName -> "Amounts",
							Description -> "The volumes of the water to be transferred.",
							Widget -> Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1.5 Milliliter, 20 Liter],
									Units -> {1, {Milliliter, {Milliliter, Liter}}}
								]
							],
							Expandable -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options describing how the Water Preparation is run when ExperimentWaterPreparation is called.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"The options returned by ExperimentWaterPreparationOptions may be passed directly to ExperimentWaterPreparation."
		},
		SeeAlso->{
			"ExperimentWaterPreparation",
			"ValidExperimentWaterPreparationQ"
		},
		Author->{
			"jireh.sacramento"
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentWaterPreparationQ*)


DefineUsage[ValidExperimentWaterPreparationQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentWaterPreparationQ[Models, Containers, Amounts]", "Boolean"},
				Description->"checks whether the provided 'Models', 'Containers', 'Amounts' and specified options are valid for calling ExperimentWaterPreparation.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Models",
							Description-> "The water models that are prepared.",
							Widget -> Alternatives[
								"Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]]
								]
							],
							Expandable -> False
						},
						{
							InputName -> "Containers",
							Description-> "The containers to which the water is transferred.",
							Widget -> Alternatives[
								"Object" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container], Model[Container]}]
								]
							],
							Expandable -> True
						},
						{
							InputName -> "Amounts",
							Description -> "The volumes of the water to be transferred.",
							Widget -> Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1.5 Milliliter, 20 Liter],
									Units -> {1, {Milliliter, {Milliliter, Liter}}}
								]
							],
							Expandable -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"The value indicating whether the ExperimentWaterPreparation call is valid with the specified options on the provided samples. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentWaterPreparation",
			"ExperimentWaterPreparationOptions"
		},
		Author->{
			"jireh.sacramento"
		}
	}
];

DefineUsage[ExperimentWaterPreparationPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentWaterPreparationPreview[Models, Containers, Amounts]","Preview"},
				Description->"returns a graphical preview of the WaterPreparation experiment. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Models",
							Description-> "The water models that are prepared.",
							Widget -> Alternatives[
								"Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]]
								]
							],
							Expandable -> False
						},
						{
							InputName -> "Containers",
							Description-> "The containers to which the water is transferred.",
							Widget -> Alternatives[
								"Object" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container], Model[Container]}]
								]
							],
							Expandable -> True
						},
						{
							InputName -> "Amounts",
							Description -> "The volumes of the water to be transferred.",
							Widget -> Alternatives[
								"Volume" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[1.5 Milliliter, 20 Liter],
									Units -> {1, {Milliliter, {Milliliter, Liter}}}
								]
							],
							Expandable -> True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical preview of the ExperimentWaterPreparation output. Return value can be changed via the OutputFormat option.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation->{
			"Due to the nature of ExperimentWaterPreparation, no graphical preview is available for ExperimentWaterPreparation. ExperimentWaterPreparationPreview always returns Null."
		},
		SeeAlso->{
			"ExperimentWaterPreparation",
			"ExperimentWaterPreparationOptions",
			"ValidExperimentWaterPreparationQ"
		},
		Author->{
			"jireh.sacramento"
		}
	}
];
