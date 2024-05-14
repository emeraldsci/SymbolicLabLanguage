(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Physical Simulations",
	Abstract -> "Collection of functions for simulating thermodynamic or kinetic properties for chemical reactions and oligonucleotides.",
	Reference -> {
		"Thermodynamics & Kinetics" -> {
			{SimulateEquilibrium, "Performs simulation of the equilibrium state from the chemical reactions with given initial conditions."},
			{SimulateKinetics, "Performs simulation of the chemical reactions with given initial conditions and duration and returns the trajectory of concentrations of reaction components against time."},
			{SimulateFreeEnergy, "Computes the Gibbs free energy from the chemical reactions, and from the hybridization or melting reactions of oligonucleotides."},
			{SimulateEquilibriumConstant, "Computes the equilibrium constant from the chemical reactions."}
		},
		"Oligonucleotides" -> {
			{SimulateEnthalpy,"Computes the change in enthalpy of the given reaction between two oligonucleotides with traditional Nearest Neighbor thermodynamic analysis."},
			{SimulateEntropy, "Computes the change in entropy of the given reaction between two oligonucleotides with traditional Nearest Neighbor thermodynamic analysis."},
			{SimulateFreeEnergy, "Computes the free energy of the given reaction between two oligonucleotides at the specified concentration with traditional Nearest Neighbor thermodynamic analysis."},
			{SimulateEquilibriumConstant, "Computes the equilibrium constant of the given reaction between two oligonucleotides at the specified concentration with traditional Nearest Neighbor thermodynamic analysis."},
			{SimulateFolding, "Predicts potential secondary structures of the given oligonucleotides."},
			{SimulateHybridization, "Predicts potential hybridized structures from multiple given oligonucleotides."},
			{SimulateReactivity, "Generates a putative reaction mechanism that describes the hybridization behavior of the system of nucleic acids or adds reaction rates to known reaction types from the given nucleic acid reaction."},
			{SimulateEquilibrium, "Performs simulation of the equilibrium state from the oligonucleotides reactions with given initial conditions."},
			{SimulateKinetics, "Performs simulation of the oligonucleotides reactions with given initial conditions and duration and returns the trajectory of concentrations of reaction components against time."},
			{SimulateMeltingCurve, "Performs simulation of the melting reactions from given oligonucleotides and returns the trajectory of concentrations of oligonucleotide species against temperature."},
			{SimulateMeltingTemperature, "Computes the melting temperature of the given reaction between two oligonucleotides at the specified concentration with traditional Nearest Neighbor thermodynamic analysis."},
			{SimulateProbeSelection, "Simulates which probe sequence would most faithfully bind to the target sequence, with any folding or self-pairing of the probe or target sequence taken into account."}
		}
	},
	RelatedGuides -> {
		GuideLink["AnalysisBySubjectMatter"],
		GuideLink["PlottingBySubjectMatter"],
		GuideLink["VisualizingConstellationObjects"],
		GuideLink["NumericAnalysis"],
		GuideLink["StatisticalDistributions"]
	}
]
