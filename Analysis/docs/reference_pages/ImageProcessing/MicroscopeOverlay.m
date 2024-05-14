(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeMicroscopeOverlay*)


(* Updated definition to Command Center *)
DefineUsage[AnalyzeMicroscopeOverlay,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeMicroscopeOverlay[microscopeImage]","overlayObject"},
				Description->"overlays microscope image data from multiple fluorescence and phase contrast channels to create a single combined image.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "microscopeImage",
							Description-> "A list of microscope protocol or data objects.",
							Widget -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Data, Microscope],Object[Protocol, Microscope]}]
											]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs:>{
					{
						OutputName->"overlayObject",
						Description->"Analysis object of overlay with given parameters.",
						Pattern:>ListableP[ObjectP[Object[Analysis,MicroscopeOverlay]]]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotMicroscope",
			"ImageOverlay",
			"AnalyzeCellCount"
		},
		Author -> {"scicomp", "brad"},
		Guides -> {
			"AnalysisCategories",
			"ExperimentAnalysis"
		},
		Tutorials -> {

		},
		Preview->True
	}
];

(* ::Subsubsection:: *)
(*AnalyzeMicroscopeOverlayOptions*)

DefineUsage[AnalyzeMicroscopeOverlayOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeMicroscopeOverlayOptions[microscopeImage]","options"},
				Description->"returns all options for the AnalyzeMicroscopeOverlay function with all Automatic options resolved to fixed values.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "microscopeImage",
							Description-> "A list of microscope protocol or data objects.",
							Widget -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Data, Microscope],Object[Protocol, Microscope]}]
											]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs:>{
					{
						OutputName->"options",
						Description->"The resolved options in the AnalyzeMicroscopeOverlay call.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeMicroscopeOverlay",
			"AnalyzeMicroscopeOverlayPreview",
			"ValidAnalyzeMicroscopeOverlayQ"
		},
		Author -> {"scicomp", "brad"},
		Guides -> {
			"AnalysisCategories",
			"ExperimentAnalysis"
		},
		Tutorials -> {

		}
	}
];

(* ::Subsubsection:: *)
(*AnalyzeMicroscopeOverlayOptions*)

DefineUsage[AnalyzeMicroscopeOverlayPreview,
	{
		BasicDefinitions->{
			{
				Definition -> {"AnalyzeMicroscopeOverlayPreview[microscopeImage]","preview"},
				Description -> "returns a graphical display representing AnalyzeMicroscopeOverlay output.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "microscopeImage",
							Description -> "A list of microscope protocol or data objects.",
							Widget -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Data, Microscope],Object[Protocol, Microscope]}]
											]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs :> {
					{
						OutputName -> "preview",
						Description -> "The graphical display representing the AnalyzeMicroscopeOverlay call output.",
						Pattern :> (ValidGraphicsP[] | Null)
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeMicroscopeOverlay",
			"AnalyzeMicroscopeOverlayOptions",
			"ValidAnalyzeMicroscopeOverlayQ"
		},
		Author -> {"scicomp", "brad"},
		Guides -> {
			"AnalysisCategories",
			"ExperimentAnalysis"
		},
		Tutorials -> {

		}
	}
];

(* ::Subsubsection:: *)
(*ValidAnalyzeMicroscopeOverlayQ*)

DefineUsage[ValidAnalyzeMicroscopeOverlayQ,
	{
		BasicDefinitions->{
			{
				Definition -> {"ValidAnalyzeMicroscopeOverlayQ[microscopeImage]","validity"},
				Description -> "returns an EmeraldTestSummary or a Boolean indicating if inputs have passed the test.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "microscopeImage",
							Description -> "A list of microscope protocol or data objects.",
							Widget -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Data, Microscope],Object[Protocol, Microscope]}]
											]
						},
						IndexName->"Microscope data"
					]
				},
				Outputs :> {
					{
						OutputName -> "validity",
						Description -> "Either an EmeraldTestSummary or a Boolean indicating if all tests have passed.",
						Pattern :> (EmeraldTestSummary | Boolean)
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeMicroscopeOverlay",
			"AnalyzeMicroscopeOverlayOptions",
			"AnalyzeMicroscopeOverlayPreview"
		},
		Author -> {"scicomp", "brad"},
		Guides -> {
			"AnalysisCategories",
			"ExperimentAnalysis"
		},
		Tutorials -> {

		}
	}
];