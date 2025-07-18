(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeThermodynamics*)


DefineUsageWithCompanions[AnalyzeThermodynamics,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeThermodynamics[{meltingAnalysis..}]", "object"},
			Description -> "calculates Gibbs free energy at 37Celsius of a melting reaction using a series of melting curve analyses and a two-state van't Hoff model (bound and unbound).",
			Inputs:>{
				{
					InputName -> "meltingAnalysis",
					Description -> "A melting point analysis.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Analysis,MeltingPoint]}]]
				}
			},
			Outputs:>{
				{
					OutputName -> "object",
					Description -> "The Analysis object containing Gibbs free energy at 37Celsius calculated for the dataset.",
					Pattern :> ObjectP[Object[Analysis, Thermodynamics]]
				}
			}
		},
		{
			Definition -> {"AnalyzeThermodynamics[{thermodynamicData..}]", "object"},
			Description -> "calculates the Gibbs free energy from the most recent melting point analysis linked to each given data.",
			Inputs:>{
				{
					InputName -> "thermodynamicData",
					Description -> "A thermodynamic data that has had a melting point analysis run on it.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Data,MeltingCurve], Object[Data,FluorescenceThermodynamics]}]]
				}
			},
			Outputs:>{
				{
					OutputName -> "object",
					Description -> "The Analysis object containing Gibbs free energy at 37Celsius calculated for the dataset.",
					Pattern :> ObjectP[Object[Analysis, Thermodynamics]]
				}
			}
		},
		{
			Definition -> {"AnalyzeThermodynamics[thermodynamicProtocol]", "object"},
			Description -> "calculates the Gibbs free energy from the most recent melting point analysis linked to all of the data linked to the given protocol.",
			Inputs:>{
				{
					InputName -> "thermodynamicProtocol",
					Description -> "An AbsorbanceThermodynamics or FluorescenceThermodynamics protocol whose data has had melting point analysis run on it.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Protocol,UVMelting], Object[Protocol,FluorescenceThermodynamics]}]]
				}
			},

			Outputs:>{
				{
					OutputName -> "object",
					Description -> "The Analysis object containing Gibbs free energy at 37Celsius calculated for the dataset.",
					Pattern :> ObjectP[Object[Analysis, Thermodynamics]]
				}
			}
		}
	},
	MoreInformation -> {
		"Thermodynamic properties are computing by fitting Gibbs free energy relationship, -R*T*Log[Keq]\[Equal]\[CapitalDelta]H-T*\[CapitalDelta]S (equation (8-7) from Object[Report, Literature, \"id:kEJ9mqa1Jr7P\"]), to the given melting points and their respective equilibrium constants Keq.",
		"Equilibrium constants Keq are computed at the half-bound state using the TargetConentrations from the thermodynamics protocol (equation (6-16) from Object[Report, Literature, \"id:kEJ9mqa1Jr7P\"])."
	},
	SeeAlso -> {
		"AnalyzeMeltingPoint",
		"AnalyzeFit",
		"SimulateMeltingTemperature",
		"SimulateFreeEnergy"
	},
	Author -> {
		"scicomp"
	},
	Guides -> {
		"AnalysisCategories",
		"ExperimentAnalysis"
	},
	Tutorials -> {

	},
	Preview->True
}];
