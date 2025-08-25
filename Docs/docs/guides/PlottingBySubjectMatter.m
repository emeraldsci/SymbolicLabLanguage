(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


Guide[
	Title -> "Plotting By Subject Matter",
	Abstract -> "Collection of plotting functions organized by the subject matter they may be relevant to.",
	Reference -> {

		(* Experiments *)
		"Chromatography" -> {
			{PlotChromatography, "Generates a line plot of the detector response as a function of time of the provided chromatography data."},
			{PlotChromatographyMassSpectra, "Generates a waterfall plot showing mass spectra collected from LCMS/GCMS as a function of time. Also provides utilities for generating 2D slices of the 3D (time, m/z, intensity) data."},
			{PlotGradient, "Generates a line plot of the % composition of buffer as a function of time from the provided gradient method information."},
			{PlotFractions, "Generates a line plot of detector response vs time from source chromatography data with the time slices representing the time for which fractions were collected highlighted from the provided fraction analysis object."},
			{PlotLadder, "Generates a line plot of the strand length as a function of peak position for standard curve analysis of nucleic acids from the provided ladder analysis object."},
			{PlotTLC, "Displays the result of a thin layer chromatography experiment."}
		},

		"Spectroscopy" -> {
			{PlotAbsorbanceQuantification, "Generates a plot of overlaid absorbance spectroscopy data from replicates reads recorded as part of the given absorbance quantification protocol."},
			{PlotAbsorbanceSpectroscopy, "Generates a line plot of the absorbance as a function of wavelength of the provided absorbance spectroscopy data."},
			{Absorbance, "Extracts and returns the absorbance readings at a given wavelength from the provided absorbance spectra."},
			{Concentration, "Applies Beer's law to determine the concentration when provided the absorbance, path length, and extinction coefficient."},
			{PathLength, "Given either ultrasonic liquid level detection data, or absorbance spectroscopy data of a water based buffer (using the Raman scattering of water), calculates an estimate of the path length of a plate based sample."},
			{PlotNMR, "Generates a line or waterfall plot of detector intensity as a function of chemical shift with traditionally depicted inverted x-axis for chemical shift of the provided Nuclear Magnetic Resonance (NMR) data."},
			{PlotNMR2D, "Generates a contour plot of detector intensity as a function of chemical shift of the directly (F2) and indirectly (F1) measured nuclei, with traditionally depicted inverted x-axis for chemical shift of the provided Nuclear Magnetic Resonance (NMR) data."},
			{PlotCircularDichroism, "Generates a line plot of the circular dichroism (mdeg) as a function of the wavelength (nm) from the provided circular dichroism data objects."},
			{PlotFluorescenceIntensity, "Generates a histogram or box-and-whisker plot from the provided fluorescent intensity data."},
			{PlotFluorescenceSpectroscopy, "Generates a line plot of fluorescent intensity as a function of wavelength from the provided fluorescence spectroscopy data."},
			{PlotLuminescenceSpectroscopy, "Generates a line plot of relative luminescence as a function of wavelength from the provided luminescence spectroscopy data."},
			{PlotIRSpectroscopy, "Generates a plot of the IR transmittance as a function of wavenumber from the provided infrared spectroscopy data."},
			{PlotMassSpectrometry, "Generates a line plot of detector intensity vs mass per charge (m/z) of an ionized particle from the provided mass spectrometry data."},
			{PlotTimeSlice, "Generates a line plot of slices of a 3D field at given Time for the input Object."},
			{PlotNephelometry, "Generates a plot of the raw relative nephelometric measurement (RNU) as a function of the concentration of samples in the provided nephelometry data."},
			{PlotNephelometryKinetics, "Generates a plot of the raw relative nephelometric measurement (RNU) as a function of time of samples in the provided nephelometry kinetics data. A 3D plot can be displayed when dilutions with different concentration of the samples are measured."},
			{PlotPowderXRD, "Generates a line plot of X-ray intensity as a function of diffraction angle from the provided powder X-ray diffraction data."},
			{PlotRamanSpectroscopy, "Generates a line plot of the average Raman spectrum from the provided Raman spectroscopy data, as well as the sampling path and individual Raman spectra for each sampling position."},
			{PlotDissolvedOxygen, "Generates a line plot of the dissolved oxygen data."},
			{PlotDynamicLightScattering, "Generates a list line plot of intensity vs. particle size from dynamic light scattering data."}
		},

		"Bioassays" -> {
			{PlotELISA, "Displays the absorbance, fluorescence, or analyte concentration vs dilution factors for the supplied ELISA data."},
			{PlotDNASequencing, "Generates a plot of the raw fluorescence data versus scan number from the provided DNA sequencing data."},
			{PlotDNASequencingAnalysis, "Generates a plot that identifies bases and quality values from a DNA sequencing analysis plot."},
			{PlotAlphaScreen, "Displays the result of an alpha screen experiment."},
			{PlotBioLayerInterferometry, "Generates a line plot of bio-layer thickness as a function of time from the provided bio-layer interferometry (BLI) data."},
			{PlotBindingKinetics, "Generates a plot comparing the prediction of fitted binding kinetics parameters to the source bio-layer interferometry data in the provided binding kinetics analysis object."},
			{PlotBindingQuantitation, "Generates a plot of the observed binding rate as a function of concentration showing the bio-layer thickness during the quantitation step from the provided BLI analysis object."},
			{PlotEpitopeBinning, "Generates a graph or table showing the groupings of samples with respect to the interactions with a particular target from a provided BLI experimental protocol."}
		},

		"Filtration" -> {
			{PlotCrossFlowFiltration, "Generates plots of all data collected in a cross-flow filtration experimental protocol."}
		},

		(* Pending completion of ExperimentFlowCytometry *)
		(*)"Flow Cytometry" -> {
			{PlotFlowCytometry,"Generates a histogram or scatter plot or higher dimensional plot of the detector response of the given dataset in observed events as recorded in the provided flow cytometry data."},
			{PlotGating,"Generates a scatter plot off with events colored by their clustering identity from the provided gating analysis object."}
		},*)

		"Gel Electrophoresis" -> {
			{PlotAgarose, "Generates pixel intensity plots of the agarose gel lane images from the provided AgaroseGelElectrophoresis data."},
			{PlotPAGE, "Generates pixel intensity plots of the PAGE lane images from the provided PAGE data."},
			{PlotWestern, "Generates a line plot of luminescence as a function of molecular weight from the mass spectrum in the provided Western blot data."},
			{PlotCapillaryIsoelectricFocusing, "Generates a graphical plot of the data stored in a Capillary Isoelectric Focusing data object."},
			{PlotCapillaryIsoelectricFocusingEvolution,"Generates a graphical plot of the separation evolution data for CapillaryIsoelectricFocusing data or protocol objects."},
			{PlotCapillaryGelElectrophoresisSDS, "Generates a graphical plot of the data stored in Capillary Gel Electrophoresis SDS data."}
		},

		"Kinetics" -> {
			{PlotAbsorbanceKinetics, "Generates a line plot of absorbance intensity as a function of time from the provided absorbance kinetics data."},
			{PlotFluorescenceKinetics, "Generates a line plot of fluorescence intensity as a function of time from the provided fluorescence kinetics data."},
			{PlotLuminescenceKinetics, "Generates a line plot of luminescence intensity as a function of time from the provided luminescence kinetics data."},
			{PlotKineticRates, "Generates a line plot of concentration vs time of the predicted kinetic rate fitting from the given kinetic analysis overlaid with the provided source data."},
			{PlotTrajectory, "Generates a line plot of concentration as a function of time from the provided kinetic simulation object or trajectory representation."}
		},

		"Microscopy" -> {
			{PlotMicroscope, "Generates an image of the microscope data with frame labels indicating the real-world distances of the items seen in the image in the provided microscope data."},
			{PlotMicroscopeOverlay, "Generates a combined false color image of two or more microscope images taken with different filters from the provided microscope overlay analysis object."},
			{PlotCellCount, "Generates an image of the microscope data with the putative cell areas indicated from the provided cell counting image analysis highlighted."},
			{PlotCellCountSummary, "Generates an image of the microscope data with the putative cell areas highlighted, along with a pie cart of relative areas of cell groupings from the provided cell counting image analysis highlighted."},
			{PlotColonies, "Generates a graphical representation of the number of colonies or plaques."},
			{PlotImageExposure, "Generates a graphical representation of the provided exposure analysis object."},
			{ImageMask, "Replaces all the pixels in the input image that are outside of a given color range."},
			{ImageOverlay, "Overlays the pixel information from two images to combine them into one."},
			{CombineFluorescentImages, "Generates a false color RGB image of the provided composite fluorescent data."}
		},

		"Nucleic Acids" -> {
			{PlotProbeConcentration, "Generates a plot of bound probe concentration as a function of strand position from the provided probe selection simulation."},
			{PlotReactionMechanism, "Generates a graphical representation of a system of nucleic acid reactivity from a provided reaction mechanism."},
			{PlotState, "Generates a pie chart of relative concentrations of each species in a provided state representation."}
		},

		"PCR" -> {
			{PlotqPCR, "Generates a line plot of the normalized fluorescence intensity as a function of replication cycle from the provided qPCR data."},
			{PlotQuantificationCycle, "Generates a list plot of fluorescence intensity as a function of replication cycle with the quantification cycle (Cq) interpolated and highlighted from the provided quantification cycle analysis object."},
			{PlotCopyNumber, "Generates a line plot of the fitted standard curve relating quantification cycle (Cq) to Log10[copy number] from the provided copy number analysis object."},
			{PlotFluorescenceThermodynamics, "Generates a path plot of fluorescence intensity as a function of temperature from melting and cooling curves from the provided fluorescence thermodynamics data."},
			{PlotDigitalPCR, "Generates a plot using the flourescence signal amplitute values provided in the specified Data object."}
		},

		"Sample Preparation and Diagnostics" -> {
			{PlotpH, "Generates a column chart of pH measurements from the provided pH data objects."},
			{PlotSensor, "Generates a line plot of the sensor reading as a function of the date and time from the provided ECL Sensor Array data."},
			{PlotVacuumEvaporation, "Generates a line plot of temperature and pressure as a function of the date and time from the provided vacuum evaporation data."},
			{PlotVolume, "Generates a histogram or box-and-whisker plot of the distance recorded by ultrasonic sensors in order to determine volume from the provided volume data."}
		},

		"Surface Tension" -> {
			{PlotSurfaceTension, "Generates a list plot of surface tension as a function of concentration from the provided surface tension data."},
			{PlotCriticalMicelleConcentration, "Generates a list plot showing the critical micelle concentration above which surface tension is constant from the provided critical micelle concentration analysis object."}
		},

		"Property Measurement" -> {
			{PlotConductivity, "Generates a column chart of conductivity measurements from the provided conductivity data objects."},
			{PlotCyclicVoltammetry, "Generates a plot of the raw voltammogram showing the potential difference in millivolts versus the current in microAmperes from the provided cyclic voltammetry data objects."},
			{PlotDynamicFoamAnalysis, "Generates plots of the foam height, foam volume, bubble count, mean bubble area, average bubble radius and liquid content over time from the provided dynamic foam analysis data objects."}
		},

		"Thermodynamics" -> {
			{PlotAbsorbanceThermodynamics, "Generates a path plot of absorbance as a function of temperature from melting and cooling curves recorded in the provided absorbance thermodynamics data."},
			{PlotDifferentialScanningCalorimetry, "Generates a line plot of differential enthalpy as a function of temperature from the provided differential scanning calorimetry (DSC) data."},
			{PlotFluorescenceThermodynamics, "Generates a path plot of fluorescent intensity as a function of temperature from melting and cooling curves recorded in the provided fluorescence thermodynamics data."},
			{PlotMeltingPoint, "Generates a list plot of the source melting curve analysis along with a demarcation of the fitted melting point."},
			{PlotThermodynamics, "Generates a Van't Hoff plot log of Keq as a function of inverse temperature and the fitted line containing the thermodynamic parameters from the provided thermodynamic analysis object."}
		},

		(* Plotting physical locations *)

		"Plotting Positions" -> {
			{PlotLocation, "Generates an interactive plot of the location of an object or position within the ECL facility where it is presently located."},
			{PlotContents, "Generates an interactive plot of the current contents of a given container or position within an ECL facility."}
		},

		(* Analysis and Simulation Plots *)

		"Curve Fitting" -> {
			{PlotFit, "Generates a plot of the source data of a fit overlaid with a line of the fitted equation from a provided fit analysis object."},
			{PlotFitPreview, " Displays a plot for the calculated fit function overlaid on the input data."},
			{PlotPrediction, "Generates a plot of the source data of a fit overlaid with a line of the fitted equation from a provided fit analysis object along with a line intersecting the fit using the given value and its predicted result via the fit."},
			{PlotSmoothing, "Generates a line plot of smooth data along with the original un-smoothed data points from a provided smoothing analysis object."},
			{PlotStandardCurve, "Generates a plot of a fitted standard curve overlaid with the data points use to fit it, and the input points the standard was applied to from the provided standard curve analysis object."},
			{ValidPlotFitQ, "Returns an Emerald Test Summary which contains the test results of running PlotFit function on a given input, or a single Boolean indicating validity."}
		},

		"Model Visualization" -> {
			{PlotGlycan, "Generates a graphic of the visual representation corresponding to a commonly accepted abbreviation of the glycan."},
			{PlotProtein, "Generates a ribbon diagram of the structure from the provided protein model."},
			{PlotTranscript, "Generates visualizations of any stored structures in the provided transcript model."},
			{PlotVirus, "Displays a visualization of the provided virus model."},
			{PlotGlycanSequence, "Plots the graphical glycan sequence according to the input."},
			{PlotMolecule, "Displays a line structure for the specified molecule."}
		}
	},
	RelatedGuides -> {
		GuideLink["VisualizingConstellationObjects"],
		GuideLink["PlottingUtilities"]
	}
]
