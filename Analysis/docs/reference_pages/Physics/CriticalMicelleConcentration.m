(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AnalyzeCriticalMicelleConcentration*)

DefineUsage[AnalyzeCriticalMicelleConcentration,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeCriticalMicelleConcentration[data]","object"},
				Description->"calculates the CriticalMicelleConcentration of the TargetMolecule in the samples of the provided SurfaceTension 'data'. The input data is generated by ExperimentMeasureSurfaceTension.",
				Inputs:>{
					{
						InputName->"data",
						Description->"An Object[Data, SurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.",
						Widget->Adder[Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Data,SurfaceTension]]
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"object",
						Description->"The object containing analysis results from the SurfaceTension Data.",
						Pattern:>ObjectP[Object[Analysis,CriticalMicelleConcentration]]
					}
				}
			},
			{
				Definition->{"AnalyzeCriticalMicelleConcentration[protocol]","object"},
				Description->"calculates the CriticalMicelleConcentration of the TargetMolecule in the samples of the provided MeasureSurfaceTension 'protocol'. The input data is generated by ExperimentMeasureSurfaceTension.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"An Object[Protocol, MeasureSurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.",
						Widget->Adder[Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol, MeasureSurfaceTension]]
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"object",
						Description->"The object containing analysis results from the SurfaceTension Data.",
						Pattern:>ObjectP[Object[Analysis,CriticalMicelleConcentration]]
					}
				}
			}
		},
		MoreInformation -> {
			"The CriticalMicelleConcentration of a TargetMolecule is calculated using the SurfaceTension values of all of the AliquotSamples.",
			"Surface tension is defined as the work required to expand a surface by an area. The accumulation of surface active compounds at the air-water interface lowers the surface tension. This can be described by the Gibbs adsorption isotherm detailed in Object[Report, Literature, \"id:n0k9mG8wBBXr\"]. A plot of surface tension vs. Ln[concentration] can be used to determine the Critical Micelle Concentration, Apparent Partitioning Coefficient, Surface Excess Concentration and Cross Sectional Area of the surfactant. The Critical Micelle Concentration is the concentration of surfactants above which micelles form and all additional surfactants added to the system go to micelles. This is determined with the intersection of linear fits of points in the premicellar region and postmicellar region. The Apparent Partitioning Coefficient is the inverse of the concentration where increasing the concentration of the sample starts decreasing the surface tension. This is determined with the intersection of premicellar region fit and the surface tension of the diluent. The Surface Excess Concentration is the amount of surfactant adsorbed at the air water interface per surface area, calculated by taking the negative of the slope premicellar region fit divided by the temperature and ideal gas constant. The Cross Sectional Area is calculated by taking the inverse of the SurfaceExcessConcentration and the Avogadro constant."
		},
		SeeAlso->{
			"ExperimentMeasureSurfaceTension",
			"PlotCriticalMicelleConcentration",
			"PlotSurfaceTension",
			"AnalyzeFit"
		},
		Author->{"axu", "waseem.vali", "josh.kenchel", "cgullekson"},
		Guides -> {
			"AnalysisCategories",
			"ExperimentAnalysis"
		},
		Tutorials->{

		},
		Preview->True
	}
];

(* ::Subsubsection::Closed:: *)
(*AnalyzeCriticalMicelleConcentrationOptions*)


DefineUsage[AnalyzeCriticalMicelleConcentrationOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeCriticalMicelleConcentrationOptions[data]","resolvedOptions"},
				Description->"returns the resolved options for AnalyzeCriticalMicelleConcentration when it is called on 'data'.",
				Inputs:>{
					{
						InputName->"data",
						Description->"An Object[Data, SurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.",
						Widget->Adder[Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Data,SurfaceTension]]
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"resolvedOptions",
						Description->"Resolved options when AnalyzeCriticalMicelleConcentration is called on the input data.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			},
			{
				Definition->{"AnalyzeCriticalMicelleConcentrationOptions[protocol]","resolvedOptions"},
				Description->"returns the resolved options for AnalyzeCriticalMicelleConcentration when it is called on 'protocol'.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"An Object[Protocol, MeasureSurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.",
						Widget->Adder[Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol, MeasureSurfaceTension]]
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"resolvedOptions",
						Description->"Resolved options when AnalyzeCriticalMicelleConcentration is called on the input data.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeCriticalMicelleConcentration",
			"AnalyzeCriticalMicelleConcentrationPreview",
			"ValidAnalyzeCriticalMicelleConcentrationQ",
			"ExperimentMeasureSurfaceTension",
			"PlotCriticalMicelleConcentration",
			"PlotSurfaceTension"
		},
		Author->{"axu", "dirk.schild", "josh.kenchel", "cgullekson"}
	}
];


(* ::Subsubsection::Closed:: *)
(*AnalyzeCriticalMicelleConcentrationPreview*)


DefineUsage[AnalyzeCriticalMicelleConcentrationPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"AnalyzeCriticalMicelleConcentrationPreview[data]","preview"},
				Description->"returns the graphical preview for AnalyzeCriticalMicelleConcentration when it is called on 'data'. The preview consists of the CriticalMicelleConcentrations of the AssaySamples and the SamplesIn.",
				Inputs:>{
					{
						InputName->"data",
						Description->"An Object[Data, SurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.",
						Widget->Adder[Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Data,SurfaceTension]]
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"Graphical preview representing the output of AnalyzeCriticalMicelleConcentration.",
						Pattern:>_TabView
					}
				}
			},
			{
				Definition->{"AnalyzeCriticalMicelleConcentrationPreview[protocol]","preview"},
				Description->"returns the graphical preview for AnalyzeCriticalMicelleConcentration when it is called on 'protocol'. The preview consists of the CriticalMicelleConcentrations of the AssaySamples and the SamplesIn.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"An Object[Protocol, MeasureSurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.",
						Widget->Adder[Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol, MeasureSurfaceTension]]
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"preview",
						Description->"Graphical preview representing the output of AnalyzeCriticalMicelleConcentration.",
						Pattern:>_TabView
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeCriticalMicelleConcentration",
			"AnalyzeCriticalMicelleConcentrationOptions",
			"ValidAnalyzeCriticalMicelleConcentrationQ",
			"ExperimentMeasureSurfaceTension",
			"PlotCriticalMicelleConcentration",
			"PlotSurfaceTension"
		},
		Author->{"axu", "dirk.schild", "josh.kenchel", "cgullekson"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidAnalyzeCriticalMicelleConcentrationQ*)


DefineUsage[ValidAnalyzeCriticalMicelleConcentrationQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidAnalyzeCriticalMicelleConcentrationQ[data]","boolean"},
				Description->"checks whether the provided inputs and specified options are valid for calling AnalyzeCriticalMicelleConcentration.",
				Inputs:>{
					{
						InputName->"data",
						Description->"An Object[Data, SurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.",
						Widget->Adder[Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Data,SurfaceTension]]
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"boolean",
						Description->"Whether or not the AnalyzeCriticalMicelleConcentration call is valid. Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			},
			{
				Definition->{"ValidAnalyzeCriticalMicelleConcentrationQ[protocol]","boolean"},
				Description->"checks whether the provided inputs and specified options are valid for calling AnalyzeCriticalMicelleConcentration.",
				Inputs:>{
					{
						InputName->"protocol",
						Description->"An Object[Protocol, MeasureSurfaceTension] Object whose SamplesIn will have their TargetMolecule's CriticalMicelleConcentration calculated.",
						Widget->Adder[Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol, MeasureSurfaceTension]]
						]]
					}
				},
				Outputs:>{
					{
						OutputName->"boolean",
						Description->"Whether or not the AnalyzeCriticalMicelleConcentration call is valid. Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"AnalyzeCriticalMicelleConcentration",
			"AnalyzeCriticalMicelleConcentrationOptions",
			"AnalyzeCriticalMicelleConcentrationPreview",
			"ExperimentMeasureSurfaceTension",
			"PlotCriticalMicelleConcentration",
			"PlotSurfaceTension"
		},
		Author->{"axu", "dirk.schild", "josh.kenchel", "cgullekson"}
	}
];