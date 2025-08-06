(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentMeasureCount*)


DefineUsage[ExperimentMeasureCount,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureCount[Objects]", "Protocol"},
				Description -> "creates a MeasureCount 'Protocol' which determines the count of 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Objects",
							Description -> "The samples or containers whose contents' count will be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "The protocol object(s) describing how to run the MeasureCount experiment.",
						Pattern :> ListableP[ObjectP[Object[Protocol, MeasureCount]]]
					}
				}
			}
		},
		MoreInformation -> {
			"ExperimentMeasureCount can only be performed with samples of the type Object[Sample] that contain Tablets. To check whether samples contain tablets, download the corresponding model's Tablet field.",
			"The count of the tablets in a particular sample is measured by dividing the total mass of the sample by the average tablet weight.",
			"The average tablet weight is determined by a process called tablet parameterization where 10 tablets (or as specified by the user) are measured individually to determine the average SolidUnitWeight (stored in the Model[Sample]).",
			"The total mass of the sample is determined by the  execution of a MeasureWeight subprotocol during the MeasureCount experiment.",
			"By default, tablet parameterization and total-weight measurements are only performed when the SolidUnitWeight or the Mass of the sample are not yet known, respectively.",
			"The user has the option to force the tablet parameterization and/or total-weight measurement, independent of the SolidUnitWeight and the Mass being known, by setting the options ParameterizeTablets and MeasureTotalWeight, respectively.",
			"In these cases the SolidUnitWeight and Mass recorded previously are overwritten by the newly determined values."
		},
		SeeAlso -> {
			"ValidExperimentMeasureCountQ",
			"ExperimentMeasureCountOptions",
			"ExperimentMeasureWeight",
			"ExperimentMeasureVolume",
			"ExperimentMeasureDensity"
		},
		Author -> {"jireh.sacramento", "hayley", "ti.wu", "axu", "waltraud.mair"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentMeasureCountOptions*)


DefineUsage[ExperimentMeasureCountOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureCountOptions[Objects]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentMeasureCount when it is called on 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Objects",
							Description -> "The samples or containers whose contents' count will be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
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
						Description -> "Resolved options when ExperimentMeasureCount is called on the input objects.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentMeasureCount if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentMeasureCount",
			"ValidExperimentMeasureCountQ",
			"ExperimentMeasureWeight",
			"ExperimentMeasureVolume",
			"ExperimentMeasureDensity"
		},
		Author -> {"jireh.sacramento", "hayley", "ti.wu", "axu", "waltraud.mair"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentMeasureCountPreview*)


DefineUsage[ExperimentMeasureCountPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMeasureCountPreview[Objects]", "Preview"},
				Description -> "returns the preview for ExperimentMeasureCount when it is called on 'objects'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Objects",
							Description -> "The samples or containers whose contents' count will be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentMeasureCount. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureCount",
			"ValidExperimentMeasureCountQ",
			"ExperimentMeasureCountOptions",
			"ExperimentMeasureWeight",
			"ExperimentMeasureVolume",
			"ExperimentMeasureDensity"
		},
		Author -> {"jireh.sacramento", "hayley", "ti.wu", "axu", "waltraud.mair"}
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentMeasureCountQ*)


DefineUsage[ValidExperimentMeasureCountQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentMeasureCountQ[Objects]", "Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentMeasureCount.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Objects",
							Description -> "The samples or containers whose contents' count will be measured.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentMeasureCount call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentMeasureCount",
			"ExperimentMeasureCountOptions",
			"ExperimentMeasureWeight",
			"ExperimentMeasureVolume",
			"ExperimentMeasureDensity"
		},
		Author -> {"jireh.sacramento", "hayley", "ti.wu", "axu", "waltraud.mair"}
	}
];