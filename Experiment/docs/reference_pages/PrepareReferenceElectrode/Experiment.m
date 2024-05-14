(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentPrepareReferenceElectrode*)


DefineUsage[ExperimentPrepareReferenceElectrode,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPrepareReferenceElectrode[ReferenceElectrodeModel]", "Protocol"},
				Description -> "generates a 'Protocol' for the preparation of a reference electrode of the given 'ReferenceElectrodeModel' according to the model information.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "ReferenceElectrodeModel",
							Description -> "The model of reference electrode to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Item, Electrode, ReferenceElectrode]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "Protocol specifying instructions for preparing the requested reference electrode model.",
						Pattern :> ObjectP[Object[Protocol, PrepareReferenceElectrode]]
					}
				}
			},
			{
				Definition -> {"ExperimentPrepareReferenceElectrode[SourceReferenceElectrode, TargetReferenceElectrodeModel]", "Protocol"},
				Description -> "generates a 'Protocol' to fill or refresh the reference solution of SourceReferenceElectrode and reset its Model to TargetReferenceElectrodeModel. If the provided SourceReferenceElectrode is a Model, an Object of this Model is selected first and prepared into a reference electrode of the TargetReferenceElectrodeModel.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "SourceReferenceElectrode",
							Description -> "The reference electrode (or its Model) to be prepared into TargetReferenceElectrodeModel during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "TargetReferenceElectrodeModel",
							Description -> "The model of reference electrode to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Item, Electrode, ReferenceElectrode]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "Protocol specifying instructions for preparing a reference electrode of the requested target reference electrode model.",
						Pattern :> ObjectP[Object[Protocol, PrepareReferenceElectrode]]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentPrepareReferenceElectrodeOptions",
			"ExperimentPrepareReferenceElectrodePreview",
			"ValidExperimentPrepareReferenceElectrodeQ",
			"UploadReferenceElectrodeModel",
			"ExperimentStockSolution",
			"UploadStockSolution"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "steven", "qijue.wang"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentPrepareReferenceElectrodeOptions*)


DefineUsage[ExperimentPrepareReferenceElectrodeOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPrepareReferenceElectrodeOptions[ReferenceElectrodeModel]", "ResolvedOptions"},
				Description -> "returns 'ResolvedOptions' from ExperimentPrepareReferenceElectrode for preparing of a reference electrode of the given 'ReferenceElectrodeModel' according to the model information.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "ReferenceElectrodeModel",
							Description -> "The model of reference electrode to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Item, Electrode, ReferenceElectrode]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from an ExperimentPrepareReferenceElectrode call for preparing a reference electrode of the given 'ReferenceElectrodeModel'.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			},
			{
				Definition -> {"ExperimentPrepareReferenceElectrodeOptions[SourceReferenceElectrode, TargetReferenceElectrodeModel]", "ResolvedOptions"},
				Description -> "returns 'ResolvedOptions' from ExperimentPrepareReferenceElectrode for refreshing the reference solution of SourceReferenceElectrode and reset its Model to TargetReferenceElectrodeModel. If the provided SourceReferenceElectrode is a Model, an Object of this Model is selected first and prepared into a reference electrode of the TargetReferenceElectrodeModel.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "SourceReferenceElectrode",
							Description -> "The reference electrode (or its Model) to be prepared into TargetReferenceElectrodeModel during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "TargetReferenceElectrodeModel",
							Description -> "The model of reference electrode to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Item, Electrode, ReferenceElectrode]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "The resolved options from an ExperimentPrepareReferenceElectrode call for preparing a reference electrode of the requested target reference electrode model.",
						Pattern :> {Rule[_Symbol, Except[Automatic]]..}
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentPrepareReferenceElectrode",
			"ExperimentPrepareReferenceElectrodePreview",
			"ValidExperimentPrepareReferenceElectrodeQ",
			"UploadReferenceElectrodeModel",
			"ExperimentStockSolution",
			"UploadStockSolution"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "steven", "qijue.wang"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentPrepareReferenceElectrodePreview*)
DefineUsage[ExperimentPrepareReferenceElectrodePreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentPrepareReferenceElectrodePreview[ReferenceElectrodeModel]", "Preview"},
				Description -> "returns a graphical representation for preparation of the given 'ReferenceElectrodeModel' according to its blank reference electrode model and reference solution model as defaults. This 'Preview' is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "ReferenceElectrodeModel",
							Description -> "The model of reference electrode to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Item, Electrode, ReferenceElectrode]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided reference electrode model preparation. This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition -> {"ExperimentPrepareReferenceElectrodePreview[SourceReferenceElectrode, TargetReferenceElectrodeModel]", "Preview"},
				Description -> "returns a graphical representation for preparation of the given 'ReferenceElectrodeModel' according to its blank reference electrode model and reference solution model as defaults, from the SourceReferenceElectrode Object or Model. This 'Preview' is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "SourceReferenceElectrode",
							Description -> "The reference electrode (or its Model) to be prepared into TargetReferenceElectrodeModel during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "TargetReferenceElectrodeModel",
							Description -> "The model of reference electrode to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Item, Electrode, ReferenceElectrode]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "A graphical representation of the provided reference electrode model preparation. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {
			"Currently, this preview function always returns Null."
		},
		SeeAlso -> {
			"ExperimentPrepareReferenceElectrode",
			"ExperimentPrepareReferenceElectrodeOptions",
			"ValidExperimentPrepareReferenceElectrodeQ",
			"UploadReferenceElectrodeModel",
			"ExperimentStockSolution",
			"UploadStockSolution"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "steven"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ValidExperimentPrepareReferenceElectrodeQ*)


DefineUsage[ValidExperimentPrepareReferenceElectrodeQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentPrepareReferenceElectrodeQ[ReferenceElectrodeModel]", "Boolean"},
				Description -> "checks the validity of an ExperimentPrepareReferenceElectrode call for preparation of the given 'ReferenceElectrodeModel' according to the model information.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "ReferenceElectrodeModel",
							Description -> "The model of reference electrode to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Item, Electrode, ReferenceElectrode]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A boolean indicating the validity of the ExperimentPrepareReferenceElectrode call.",
						Pattern :> BooleanP
					}
				}
			},
			{
				Definition -> {"ValidExperimentPrepareReferenceElectrodeQ[SourceReferenceElectrode, TargetReferenceElectrodeModel]", "Boolean"},
				Description -> "checks the validity of an ExperimentPrepareReferenceElectrode call for refreshing the reference solution of SourceReferenceElectrode and reset its Model to TargetReferenceElectrodeModel. If the provided SourceReferenceElectrode is a Model, an Object of this Model is selected first and prepared into a reference electrode of the TargetReferenceElectrodeModel.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "SourceReferenceElectrode",
							Description -> "The reference electrode (or its Model) to be prepared into TargetReferenceElectrodeModel during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Model[Item, Electrode, ReferenceElectrode], Object[Item, Electrode, ReferenceElectrode]}]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					],
					IndexMatching[
						{
							InputName -> "TargetReferenceElectrodeModel",
							Description -> "The model of reference electrode to be prepared during this protocol.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Item, Electrode, ReferenceElectrode]]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A boolean indicating the validity of the ExperimentPrepareReferenceElectrode call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentPrepareReferenceElectrode",
			"ExperimentPrepareReferenceElectrodePreview",
			"ExperimentPrepareReferenceElectrodeOptions",
			"UploadReferenceElectrodeModel",
			"ExperimentStockSolution",
			"UploadStockSolution"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund", "steven", "qijue.wang"}
	}
];