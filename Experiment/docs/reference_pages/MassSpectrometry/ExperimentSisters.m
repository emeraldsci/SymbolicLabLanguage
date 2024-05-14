(* ::Subsubsection:: *)
(*ExperimentMassSpectrometryPreview*)


DefineUsage[ExperimentMassSpectrometryPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMassSpectrometryPreview[Samples]", "Preview"},
				Description -> "returns the graphical preview for ExperimentMassSpectrometry when it is called on 'Samples'.  This output is always Null.",
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
						Description -> "Graphical preview representing the output of ExperimentMassSpectrometry.  This value is always Null.",
						Pattern :> Null
					}
				}
			},
			{
				Definition -> {"ExperimentMassSpectrometryPreview[containers]", "Preview"},
				Description -> "returns the graphical preview for ExperimentMassSpectrometry when it is called on 'containers'.  This output is always Null.",
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
						Description -> "Graphical preview representing the output of ExperimentMassSpectrometry.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMassSpectrometry",
			"ValidExperimentMassSpectrometryQ",
			"ExperimentMassSpectrometryPreview",
			"ExperimentMassSpectrometryOptions",
			"ExperimentHPLC",
			"ExperimentPAGE"
		},
		Author -> {"mohamad.zandian", "xu.yi", "weiran.wang", "waltraud.mair", "hayley"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentMassSpectrometryOptions*)


DefineUsage[ExperimentMassSpectrometryOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentMassSpectrometryOptions[Samples]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentMassSpectrometry when it is called on 'Samples'.",
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
						Description -> "Resolved options when ExperimentMassSpectrometry is called on the input samples.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition -> {"ExperimentMassSpectrometryOptions[containers]", "ResolvedOptions"},
				Description -> "returns the resolved options for ExperimentMassSpectrometry when it is called on 'containers'.",
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
						Description -> "Resolved options when ExperimentMassSpectrometry is called on the input containers.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMassSpectrometry",
			"ValidExperimentMassSpectrometryQ",
			"ExperimentMassSpectrometryPreview",
			"ExperimentHPLC",
			"ExperimentPAGE"
		},
		Author -> {"mohamad.zandian", "xu.yi", "weiran.wang", "waltraud.mair", "hayley"}
	}
];



(* ::Subsubsection:: *)
(*ValidExperimentMassSpectrometryQ*)


DefineUsage[ValidExperimentMassSpectrometryQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentMassSpectrometryQ[Samples]", "Booleans"},
				Description -> "checks whether the provided 'Samples' and specified options are valid for calling ExperimentMassSpectrometry.",
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
						Description -> "Whether or not the ExperimentMassSpectrometry call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition -> {"ValidExperimentMassSpectrometryQ[containers]", "Booleans"},
				Description -> "checks whether the provided 'containers' and specified options are valid for calling ExperimentMassSpectrometry.",
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
						Description -> "Whether or not the ExperimentMassSpectrometry call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentMassSpectrometry",
			"ExperimentMassSpectrometryPreview",
			"ExperimentMassSpectrometryOptions",
			"ExperimentHPLC",
			"ExperimentPAGE"
		},
		Author -> {"mohamad.zandian", "xu.yi", "weiran.wang", "waltraud.mair", "hayley"}
	}
];