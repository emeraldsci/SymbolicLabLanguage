
(* ::Subsubsection::Closed:: *)
(*ExperimentFlashChromatography*)

DefineUsage[ExperimentFlashChromatography,{
	BasicDefinitions->{{
		Definition->{"ExperimentFlashChromatography[Samples]","Protocol"},
		Description->"generates a 'Protocol' to separate 'Samples' via flash chromatography.",
		Inputs:>{
			IndexMatching[
				{
					InputName->"Samples",
					Description->"The analyte samples which should each be loaded into a column and analyzed and/or purified via flash chromatography.",
					Expandable->False,
					Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample],Object[Container]}],
						Dereference->{Object[Container]->Field[Contents[[All,2]]]}
					]
				},
				IndexName->"experiment samples"
			]
		},
		Outputs:>{
			{
				OutputName->"Protocol",
				Description->"A protocol object that describes the flash chromatography experiment to be run.",
				Pattern:>ObjectP[Object[Protocol,FlashChromatography]]
			}
		}
	}},
	MoreInformation->{
		"If the input samples are not in compatible containers, aliquots will automatically be transferred to appropriate containers.",
		"Compatible containers for liquid samples are: Model[Container, Syringe].",
		"Compatible containers for solid samples are: Model[Container, Cartridge, \"Solid load cartridge-5gram\"], etc...",
		"Compatible containers for preloaded samples are: Model[Container, Column]."
	},
	SeeAlso->{
		"ExperimentFlashChromatographyOptions",
		"ExperimentFlashChromatographyPreview",
		"ValidFlashChromatographyExperimentQ",
		"ExperimentHPLC",
		"ExperimentFPLC",
		"ExperimentIonChromatography",
		"ExperimentLCMS",
		"ExperimentSupercriticalFluidChromatography",
		"AnalyzeFractions",
		"AnalyzePeaks",
		"PlotChromatography"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{
		"clayton.schwarz"
	}
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentFlashChromatographyOptions*)

DefineUsage[ExperimentFlashChromatographyOptions,{
	BasicDefinitions->{{
		Definition->{"ExperimentFlashChromatographyOptions[Samples]","ResolvedOptions"},
		Description->"returns the 'ResolvedOptions' for ExperimentFlashChromatography when it is called on 'Samples'.",
		Inputs:>{
			IndexMatching[
				{
					InputName->"Samples",
					Description->"The analyte samples which should each be loaded into a column and analyzed and/or purified via flash chromatography.",
					Expandable->False,
					Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample],Object[Container]}],
						Dereference->{Object[Container]->Field[Contents[[All,2]]]}
					]
				},
				IndexName->"experiment samples"
			]
		},
		Outputs:>{
			{
				OutputName -> "ResolvedOptions",
				Description -> "The resolved options when ExperimentFlashChromatography is called on the input samples.",
				Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
			}
		}
	}},
	MoreInformation->{
		"This function returns the resolved options that would be fed to ExperimentFlashChromatography if it were called on these input samples."
	},
	SeeAlso->{
		"ExperimentFlashChromatography",
		"ExperimentFlashChromatographyPreview",
		"ValidFlashChromatographyExperimentQ"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{
		"clayton.schwarz"
	}
}];


(* ::Subsubsection::Closed:: *)
(*ExperimentFlashChromatographyPreview*)

DefineUsage[ExperimentFlashChromatographyPreview,{
	BasicDefinitions->{{
		Definition->{"ExperimentFlashChromatographyPreview[Samples]","Preview"},
		Description->"returns the 'Preview' for ExperimentFlashChromatography when it is called on 'Samples'.",
		Inputs:>{
			IndexMatching[
				{
					InputName->"Samples",
					Description->"The analyte samples which should each be loaded into a column and analyzed and/or purified via flash chromatography.",
					Expandable->False,
					Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample],Object[Container]}],
						Dereference->{Object[Container]->Field[Contents[[All,2]]]}
					]
				},
				IndexName->"experiment samples"
			]
		},
		Outputs:>{
			{
				OutputName -> "Preview",
				Description -> "Graphical preview representing the output of ExperimentFilter.  This value is always Null.",
				Pattern :> Null
			}
		}
	}},
	SeeAlso->{
		"ExperimentFlashChromatography",
		"ExperimentFlashChromatographyOptions",
		"ValidFlashChromatographyExperimentQ"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{
		"clayton.schwarz"
	}
}];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentFlashChromatographyQ*)

DefineUsage[ValidExperimentFlashChromatographyQ,{
	BasicDefinitions->{{
		Definition->{"ValidExperimentFlashChromatographyQ[Samples]","Boolean"},
		Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentFlashChromatography.",
		Inputs:>{
			IndexMatching[
				{
					InputName->"Samples",
					Description->"The analyte samples which should each be loaded into a column and analyzed and/or purified via flash chromatography.",
					Expandable->False,
					Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample],Object[Container]}],
						Dereference->{Object[Container]->Field[Contents[[All,2]]]}
					]
				},
				IndexName->"experiment samples"
			]
		},
		Outputs:>{
			{
				OutputName -> "Boolean",
				Description -> "Whether or not the ExperimentFlashChromatography call is valid.  Return value can be changed via the OutputFormat option.",
				Pattern :> _EmeraldTestSummary| BooleanP
			}
		}
	}},
	SeeAlso->{
		"ExperimentFlashChromatography",
		"ExperimentFlashChromatographyOptions",
		"ExperimentFlashChromatographyPreview",
		"ValidFlashChromatographyExperimentQ"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{
		"clayton.schwarz"
	}
}];

