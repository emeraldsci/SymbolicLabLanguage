(* ::Subsubsection:: *)
(*ExperimentICPMSPreview*)


DefineUsage[ExperimentICPMSPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentICPMSPreview[Samples]", "Preview"},
				Description -> "returns the graphical preview for ExperimentICPMS when it is called on 'Samples'.  This output is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be analyzed using mass spectrometry.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample]}]
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentICPMS.  This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition -> {"ExperimentICPMSPreview[containers]", "Preview"},
				Description -> "returns the graphical preview for ExperimentICPMS when it is called on 'containers'.  This output is always Null.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "containers",
							Description -> "The containers holding samples to be analyzed using mass spectrometry.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Container, Vessel], Object[Container, Plate]}],
								ObjectTypes -> {Object[Container, Vessel], Object[Container, Plate]}
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentICPMS.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentICPMS",
			"ValidExperimentICPMSQ",
			"ExperimentICPMSPreview",
			"ExperimentICPMSOptions",
			"ExperimentMassSpectrometry"
		},
		Author -> {
			"hanming.yang"
		}
	}
];


(* ::Subsubsection:: *)
(*ExperimentICPMSOptions*)


DefineUsage[ExperimentICPMSOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentICPMSOptions[Samples]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentICPMS when it is called on 'Samples'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be analyzed using mass spectrometry.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample]}]
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentICPMS is called on the input samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition -> {"ExperimentICPMSOptions[containers]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentICPMS when it is called on 'containers'.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "containers",
							Description -> "The containers holding samples to be analyzed using mass spectrometry.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Container, Vessel], Object[Container, Plate]}],
								ObjectTypes -> {Object[Container, Vessel], Object[Container, Plate]}
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentICPMS is called on the input containers.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentICPMS",
			"ValidExperimentICPMSQ",
			"ExperimentICPMSPreview",
			"ExperimentMassSpectrometry"
		},
		Author -> {
			"hanming.yang"
		}
	}
];



(* ::Subsubsection:: *)
(*ValidExperimentICPMSQ*)


DefineUsage[ValidExperimentICPMSQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentICPMSQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentICPMS.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples to be analyzed using mass spectrometry.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Sample]}]
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentICPMS call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition -> {"ValidExperimentICPMSQ[containers]", "Booleans"},
				Description -> "checks whether the provided 'containers' and specified options are valid for calling ExperimentICPMS.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "containers",
							Description -> "The containers holding samples to be analyzed using mass spectrometry.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[{Object[Container, Vessel], Object[Container, Plate]}],
								ObjectTypes -> {Object[Container, Vessel], Object[Container, Plate]}
							],
							Expandable -> False
						},
						IndexName -> "Input"
					]
				},
				Outputs :> {
					{
						OutputName -> "Booleans",
						Description -> "Whether or not the ExperimentICPMS call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentICPMS",
			"ExperimentICPMSPreview",
			"ExperimentICPMSOptions",
			"ExperimentMassSpectrometry"
		},
		Author -> {
			"hanming.yang"
		}
	}
];
