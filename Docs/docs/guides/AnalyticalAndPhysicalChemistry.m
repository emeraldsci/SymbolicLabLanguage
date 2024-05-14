(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Analytical And Physical Chemistry",
	Abstract -> "Collection of functions involved in deriving physical parameters from empirical data.",
	Reference -> {
		"Quantification" -> {
			{AnalyzeAbsorbanceQuantification, "Users Beer's Law to calculate the concentration of an analyte based on its extinction coefficient and absorbance spectra."},
			{AnalyzeTotalProteinQuantification, "Calculates total protein calculation based on total protein quantification assay data."},
			{AnalyzeCopyNumber, "Calculates the estimated copy number of a given gene sequences in an analyte based on qPCR data or Quantification Cycle analysis."},
			{PlotCopyNumber, "Generates a line plot of the fitted standard curve relating quantification cycle (Cq) to Log10[copy number] from the provided copy number analysis object."},
			{AnalyzeQuantificationCycle, "Calculates the Quantification Cycle (Cq) which is the inflection point in the amplification curve of qPCR data."},
			{PlotQuantificationCycle, "Plots the Cq value on the amplification curve the value was fit to."},
			{AnalyzePeaks, "Preforms peak picking analysis of experimental source data connecting the results of the analysis to its source data and experimental protocol information."},
			{AnalyzeCriticalMicelleConcentration, "Given the surface tension values at different concentrations, calculates the critical micelle concentration of a target molecule above which surface tension is constant and below which the surface tension decreases with concentration."},
			{PlotCriticalMicelleConcentration, "Generates a list plot showing the critical micelle concentration above which surface tension is constant from the provided critical micelle concentration analysis object."},
			{AnalyzeBindingQuantitation, "Determines the concentration of the analyte measured by first creating a standard curve that fits all data with the specified model and then finding the concentration at a specific binding rate."},
			{PlotBindingQuantitation, "Generates a plot of the observed binding rate as a function of concentration showing the bio-layer thickness during the quantitation step from the provided BLI analysis object."},
			{AnalyzeComposition, "Computes the concentrations of different analytes in assays based on the chromatogram peaks in a HPLC protocol."},
			{AnalyzeFractions, "Selects a set of fractions to be carried forward for further analysis from chromatography data where fractions were collected."}
		},
		"Thermodynamics" -> {
			{AnalyzeMeltingPoint, "Calculates the melting point from a melting curve, a cooling curve, or a dynamic light scattering dataset (dataset can be either from fluorescence or absorbance thermodynamics data, or thermal shift instrument which may contain both fluorescence spectra as well as dynamic light scattering data)."},
			{PlotMeltingPoint, "Generates a list plot of the source melting curve analysis along with a demarcation of the fitted melting point."},
			{AnalyzeThermodynamics, "Given a set of melting curve data or analysis, performs Van't Hoff analysis to determine free-energy, enthalpy, and entropy components of a binding event."},
			{PlotThermodynamics, "Generates a Van't Hoff plot log of Keq as a function of inverse temperature and the fitted line containing the thermodynamic parameters from the provided thermodynamic analysis object."},
			{AnalyzeParallelLine, "Calculates the relative potency ratio between two dose-response fitted curves."},
			{ReactionMechanism, "Used to represent a reaction mechanism consisting of a set of transformations."},
			{State, "Used to represent a single state of a reaction consisting of the species involved and their concentrations."},
			{SimulateEquilibrium, "Given a reaction mechanism and a set of initial conditions, projects the equilibrium state of the system."},
			{PlotState, "Plots the relative concentration of each species in a given state of a reaction."},
			{SimulateEquilibriumConstant, "Given a reaction and a temperature, calculates the equilibrium constant of a system."},
			{SimulateEnthalpy, "Given a reaction, calculates the change in enthalpy between the starting material and the product."},
			{SimulateEntropy, "Given a reaction, calculates the change in entropy between the starting material and the product."}
		},
		"Kinetics" -> {
			{AnalyzeKinetics, "Given a reaction mechanism and a set of reaction trajectories (either simulated or from experimentation) fits rate constants which represent a best fit to the trajectory data."},
			{SimulateKinetics, "Given a reaction mechanism (including rate constants), an initial state, and a time duration for the reaction simulates the time course behavior of a system."},
			{PlotTrajectory, "Plots the concentration of each species in a reaction as a function of time."},
			{ReactionMechanism, "Used to represent a reaction mechanism consisting of a set of transformations."},
			{AnalyzeBindingKinetics, "Solves the kinetic association and dissociation rates by fitting to the source biolayer interferometry binding kinetics."},
			{PlotBindingKinetics, "Generates a plot comparing the prediction of fitted binding kinetics parameters to the source bio-layer interferometry data in the provided binding kinetics analysis object."}
		}
	},
	RelatedGuides -> {
		GuideLink["NumericAnalysis"],
		GuideLink["ImageAnalysis"],
		GuideLink["AnalysisBySubjectMatter"]
	}
]
