(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Analysis By Subject Matter",
	Abstract -> "Collection of analysis functions organized by the subject mater they may be relevant to.",
	Reference -> {
		"Chromatography" -> {
			{AnalyzePeaks, "Preforms peak picking analysis of experimental source data connecting the results of the analysis to its source data and experimental protocol information."},
			{PlotChromatography, "Generates a line plot of the detector response as a function of time of the provided chromatography data."},
			{AnalyzeFractionsApp, "Selects a set of fractions or all fractions from the source data."},
			{AnalyzeFractions, "Selects a set of fractions to be carried forward for further analysis from chromatography data where fractions were collected."},
			{PlotFractions, "Generates a line plot of detector response vs time from source chromatography data with the time slices representing the time for which fractions were collected highlighted from the provided fraction analysis object."},
			{AnalyzeLadder, "Fits a standard curve function to relate position of a given band or peak to length of a nucleic acid species."},
			{PlotLadder, "Generates a line plot of the strand length as a function of peak position for standard curve analysis of nucleic acids from the provided ladder analysis object."},
			{AnalyzeComposition, "Computes the concentrations of different analytes in assays based on the chromatogram peaks in a HPLC protocol."}
		},
		"Spectroscopy" -> {
			{AnalyzePeaks, "Preforms peak picking analysis of experimental source data connecting the results of the analysis to its source data and experimental protocol information."},
			{AnalyzeAbsorbanceQuantification, "Users Beer's Law to calculate the concentration of an analyte based on its extinction coefficient and absorbance spectra."},
			{PlotAbsorbanceQuantification, "Generates a plot of overlaid absorbance spectroscopy data from replicates reads recorded as part of the given absorbance quantification protocol."},
			{AnalyzeTotalProteinQuantification, "Calculates total protein calculation based on total protein quantification assay data."},
			{AnalyzeDynamicLightScattering, "Calculates key scientific parameters including Z-average diameter, second virial coefficient, diffusion interaction parameter and kirkwood Buff integral from dynamic light scattering data."},
			{AnalyzeDynamicLightScatteringLoading, "Performs thresholding analysis of correlation curve data on dynamic light scattering data objects of a given protocol to identify the samples that were properly loaded."},
			{PlotDynamicLightScattering, "Generates a list line plot of intensity vs. particle size from dynamic light scattering data."}
		},
		"PCR" -> {
			{AnalyzeCopyNumber, "Calculates the estimated copy number of a given gene sequences in an analyte based on qPCR data or Quantification Cycle analysis."},
			{PlotCopyNumber, "Generates a line plot of the fitted standard curve relating quantification cycle (Cq) to Log10[copy number] from the provided copy number analysis object."},
			{AnalyzeQuantificationCycle, "Calculates the Quantification Cycle (Cq) which is the inflection point in the amplification curve of qPCR data."},
			{PlotQuantificationCycle, "Generates a list plot of fluorescence intensity as a function of replication cycle with the quantification cycle (Cq) interpolated and highlighted from the provided quantification cycle analysis object."}
		},
		"Bioassays" -> {
			{AnalyzeBindingKinetics, "Solves the kinetic association and dissociation rates by fitting to the source biolayer interferometry binding kinetics data."},
			{PlotBindingKinetics, "Generates a plot comparing the prediction of fitted binding kinetics parameters to the source bio-layer interferometry data in the provided binding kinetics analysis object."},
			{AnalyzeBindingQuantitation, "Determines the concentration of the analyte measured by first creating a standard curve that fits all data with the specified model and then finding the concentration at a specific binding rate."},
			{PlotBindingQuantitation, "Generates a plot of the observed binding rate as a function of concentration showing the bio-layer thickness during the quantitation step from the provided BLI analysis object."},
			{AnalyzeEpitopeBinning, "Given a biolayer interferometry dataset, classifies antibodies by their interaction with a given antigen based on the thickness of the biolayer formed during the association of the antibodies."},
			{PlotEpitopeBinning, "Generates a graph or table showing the groupings of samples with respect to the interactions with a particular target from a provided BLI experimental protocol."},
			{AnalyzeDNASequencing, "Given an DNA sequencing electrophoregram fluorescence data, conducts base calling analysis which assigns DNA sequences as a function of the scan number."},
			{PlotDNASequencing, "Generates a plot of the raw fluorescence data versus scan number from the provided DNA sequencing data."}
			(* Functions commented out until ExperimentFlowCytometry is online
			{AnalyzeCompensationMatrix, "Given a flow cytometry protocol with compensation samples, calculate the compensation matrix which corrects for signal spillover between detectors."},
			{AnalyzeFlowCytometry, "Given flow cytometry data, cluster cells into populations using manual and/or automatic gating and compute the cell count for each population."},
			{AnalyzeGating, "Performs manual gating or algorithmic clustering on multi-dimensional scatter plot flow cytometry data."},
			{PlotFlowCytometry, "Generates a scatter-plot of forward scatter vs. side scatter intensity from flow cytometry data."}*)
		},
		"Microscopy" -> {
			{AnalyzeCellCount, "Counts the apparent number of cells in the provided microscope image data."},
			{AnalyzeMicroscopeOverlay, "Generates an analytical combination of different composite fluorescent images for use in co-localization analysis."},
			{PlotMicroscopeOverlay, "Generates a combined false color image of two or more microscope images taken with different filters from the provided microscope overlay analysis object."},
			{PlotCellCount, "Generates an image of the microscope data with the putative cell areas indicated from the provided cell counting image analysis highlighted."},
			{PlotCellCountSummary, "Generates an image of the microscope data with the putative cell areas highlighted, along with a pie cart of relative areas of cell groupings from the provided cell counting image analysis highlighted."},
			{CombineFluorescentImages, "Generates a false color RGB image of the provided composite fluorescent data."},
			{ImageMask, "Replaces all the pixels in the input image that are outside of a given color range."},
			{ImageOverlay, "Overlays the pixel information from two images to combine them into one."},
			{ImageIntensity, "Computes the average intensity of the pixels as a function of the vertical pixel position in the image."}
		},
		"Quantification" -> {
			{AnalyzeAbsorbanceQuantification, "Users Beer's Law to calculate the concentration of an analyte based on its extinction coefficient and absorbance spectra."},
			{PlotAbsorbanceQuantification, "Generates a plot of overlaid absorbance spectroscopy data from replicates reads recorded as part of the given absorbance quantification protocol."},
			{AnalyzeTotalProteinQuantification, "Calculates total protein calculation based on total protein quantification assay data."},
			{AnalyzeCopyNumber, "Calculates the estimated copy number of a given gene sequences in an analyte based on qPCR data or Quantification Cycle analysis."},
			{PlotCopyNumber, "Generates a line plot of the fitted standard curve relating quantification cycle (Cq) to Log10[copy number] from the provided copy number analysis object."},
			{AnalyzeQuantificationCycle, "Calculates the Quantification Cycle (Cq) which is the inflection point in the amplification curve of qPCR data."},
			{PlotQuantificationCycle, "Generates a list plot of fluorescence intensity as a function of replication cycle with the quantification cycle (Cq) interpolated and highlighted from the provided quantification cycle analysis object."},
			{AnalyzePeaks, "Preforms peak picking analysis of experimental source data connecting the results of the analysis to its source data and experimental protocol information."},
			{AnalyzeBindingQuantitation, "Determines the concentration of the analyte measured by first creating a standard curve that fits all data with the specified model and then finding the concentration at a specific binding rate."},
			{PlotBindingQuantitation, "Generates a plot of the observed binding rate as a function of concentration showing the bio-layer thickness during the quantitation step from the provided BLI analysis object."}
		},
		"Thermodynamics" -> {
			{AnalyzeMeltingPoint, "Calculates the melting point from a melting curve dataset (either from fluorescence  or absorbance thermodynamics data)."},
			{PlotMeltingPoint, "Generates a list plot of the source melting curve analysis along with a demarcation of the fitted melting point."},
			{AnalyzeThermodynamics, "Given a set of melting curve data or analysis, performs Van't Hoff analysis to determine free-energy, enthalpy, and entropy components of a binding event."},
			{PlotThermodynamics, "Generates a Van't Hoff plot log of Keq as a function of inverse temperature and the fitted line containing the thermodynamic parameters from the provided thermodynamic analysis object."},
			{AnalyzeParallelLine, "Calculates the relative potency ratio between two dose-response fitted curves."}
		},
		"Kinetics" -> {
			{AnalyzeKinetics, "Given a reaction mechanism and a set of reaction trajectories (either simulated or from experimentation) fits rate constants which represent a best fit to the trajectory data."},
			{AnalyzeBindingKinetics, "Solves the kinetic association and dissociation rates by fitting to the source biolayer interferometry binding kinetics data."},
			{PlotBindingKinetics, "Generates a plot comparing the prediction of fitted binding kinetics parameters to the source bio-layer interferometry data in the provided binding kinetics analysis object."}
		},
		"Property Measurement" -> {
			{AnalyzeBubbleRadius, "Computes the distribution of bubble radii from videos contained in dynamic foam analysis data."},
			{PlotDynamicFoamAnalysis, "Generates plots of the foam height, foam volume, bubble count, mean bubble area, average bubble radius and liquid content over time from the provided dynamic foam analysis data objects."}
		}
	},
	RelatedGuides -> {
		GuideLink["NumericAnalysis"],
		GuideLink["AnalyticalAndPhysicalChemistry"],
		GuideLink["ImageAnalysis"]
	}
]
