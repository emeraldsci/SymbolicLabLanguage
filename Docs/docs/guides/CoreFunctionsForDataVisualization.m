(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Core Functions For Data Visualization",
	Abstract -> "Collection of functions for generic visualization of information from Constellation Objects.",
	Reference -> {

		"Visualizing Constellation Objects" -> {
			{Inspect, "Presents a tabular view of all of the fields stored for a given Constellation object."},
			{PlotObject, "Provides a visual representation of the information stored in the given Constellation object."}
		},

		"Plotting Extracted Data from Constellation" -> {
			{PlotTable, "Given a list of Objects and a list of fields within those objects, generates a table which presents the values of Fields in the provided objects."},
			{PlotImage, "Given an image file or data objects containing images, provides a visualization of these images that includes a measurement of absolute size scales when possible."}
		},

		"Plotting Data Objects" -> {
			{PlotAbsorbanceKinetics, "Generates a line plot of absorbance intensity as a function of time from the provided absorbance kinetics data."},
			{PlotAbsorbanceSpectroscopy, "Generates a line plot of the absorbance as a function of wavelength of the provided absorbance spectroscopy data."},
			{PlotAbsorbanceThermodynamics, "Generates a path plot of absorbance as a function of temperature from melting and cooling curves recorded in the provided absorbance thermodynamics data."},
			{PlotAgarose, "Generates pixel intensity plots of the agarose gel lane images from the provided AgaroseGelElectrophoresis data."},
			{PlotBioLayerInterferometry, "Generates a line plot of bio-layer thickness as a function of time from the provided bio-layer interferometry (BLI) data."},
			{PlotCellCount, "Generates an image of the microscope data with the putative cell areas indicated from the provided cell counting image analysis highlighted."},
			{PlotChromatography, "Generates a line plot of the detector response as a function of time of the provided chromatography data."},
			{PlotCrossFlowFiltration, "Generates plots of all data collected in a cross-flow filtration experimental protocol."},
			{PlotDifferentialScanningCalorimetry, "Generates a line plot of differential enthalpy as a function of temperature from the provided differential scanning calorimetry (DSC) data."},
			(*){PlotFlowCytometry,"Generates a histogram or scatter plot or higher dimensional plot of the detector response of the given dataset in observed events as recorded in the provided flow cytometry data."},*)
			{PlotFluorescenceIntensity, "Generates a histogram or box and whisker plot of the provided fluorescence intensity data."},
			{PlotFluorescenceKinetics, "Generates a line plot of fluorescent intensity as a function of time from the provided fluorescence kinetics data."},
			{PlotFluorescenceSpectroscopy, "Generates a line plot of fluorescent intensity as a function of wavelength form the provided fluoresce spectroscopy data."},
			{PlotFluorescenceThermodynamics, "Generates a path plot of fluorescent intensity as a function of temperature from melting and cooling curves recorded in the provided fluoresce thermodynamics data."},
			{PlotIRSpectroscopy, "Generates a plot of the IR transmittance as a function of wavenumber from the provided infrared spectroscopy data."},
			{PlotLuminescenceKinetics, "Generates a line plot of luminescence intensity as a function of time from the provided luminescence kinetics data."},
			{PlotLuminescenceSpectroscopy, "Generates a line plot of relative luminescence as a function of wavelength from the provided luminescence spectroscopy data."},
			{PlotMassSpectrometry, "Generates a line plot of detector intensity vs mass per charge (m/z) of an ionized particle from the provided mass spectrometry data."},
			{PlotMicroscope, "Generates an image of the microscope data with frame labels indicating the real-world distances of the items seen in the image in the provided microscope data."},
			{PlotNMR, "Generates a line or waterfall plot of detector intensity as a function of chemical shift with traditionally depicted inverted x-axis for chemical shift of the provided Nuclear Magnetic Resonance (NMR) data."},
			{PlotNMR2D, "Generates a contour plot of detector intensity as a function of chemical shift of the directly (F2) and indirectly (F1) measured nuclei, with traditionally depicted inverted x-axis for chemical shift of the provided Nuclear Magnetic Resonance (NMR) data."},
			{PlotPAGE, "Generates an image of the gel lanes side by side with a line plot of the pixel brightness as a function of distance along the lane from the provided Polyacrylamide Gel Electrophoresis (PAGE) data."},
			{PlotPowderXRD, "Generates a line plot of X-ray intensity as a function of diffraction angle from the provided powder X-ray diffraction data."},
			{PlotqPCR, "Generates a line plot of the normalized fluorescence intensity as a function of replication cycle from the provided qPCR data."},
			{PlotRamanSpectroscopy, "Generates a line plot of the average Raman spectrum from the provided Raman spectroscopy data, as well as the sampling path and individual Raman spectra for each sampling position."},
			{PlotSensor, "Generates a line plot of the sensor reading as a function of the date and time from the provided ECL Sensor Array data."},
			{PlotSurfaceTension, "Generates a list plot of surface tension as a function of concentration from the provided surface tension data."},
			{PlotVacuumEvaporation, "Generates a line plot of pressure and temperature readings as a function of the date and time they were recorded within the evaporation chamber of the speed-vac from the provided vacuum evaporation data."},
			{PlotVolume, "Generates a histogram or box-and-whisker plot of the distance recorded by ultrasonic sensors in order to determine volume from the provided volume data."},
			{PlotWestern, "Generates a list plot of the luminescence intensity as a function of molecular weight (as determined from a standard curve relating distance in the gel to molecular weight) from the provided Western data."}
		},

		"Plotting Analysis Objects" -> {
			{PlotAbsorbanceQuantification, "Generates a plot of overlaid absorbance spectroscopy data from replicate reads recorded as part of the given absorbance quantification protocol."},
			{PlotBindingKinetics, "Generates a plot comparing the prediction of fitted binding kinetics parameters to the source bio-layer interferometry data in the provided binding kinetics analysis object."},
			{PlotBindingQuantitation, "Generates a plot of the observed binding rate as a function of concentration showing the bio-layer thickness during the quantitation step from the provided BLI analysis object."},
			{PlotCellCount, "Generates an image of the microscope data with the putative cell areas indicated from the provided cell counting image analysis highlighted."},
			{PlotCellCountSummary, "Generates an image of the microscope data with the putative cell areas highlighted, along with a pie cart of relative areas of cell groupings from the provided cell counting image analysis highlighted."},
			{PlotColonies, "Generates a graphical representation of the number of colonies or plaques."},
			{PlotCopyNumber, "Generates a line plot of the fitted standard curve relating quantification cycle (Cq) to Log10[copy number] from the provided copy number analysis object."},
			{PlotCriticalMicelleConcentration, "Generates a list plot showing the critical micelle concentration above which surface tension is constant from the provided critical micelle concentration analysis object."},
			{PlotEpitopeBinning, "Generates a graph or table showing the groupings of samples with respect to the interactions with a particular target from a provided BLI experimental protocol."},
			{PlotFit, "Generates a plot of the source data of a fit overlaid with a line of the fitted equation from a provided fit analysis object."},
			{PlotFractions, "Generates a line plot of detector response vs time from source chromatography data with the time slices representing the time for which fractions were collected highlighted from the provided fraction analysis object."},
			{PlotGating, "Generates a scatter plot off with events colored by their clustering identity from the provided gating analysis object."},
			{PlotKineticRates, "Generates a line plot of concentration vs time of the predicted kinetic rate fitting from the given kinetic analysis overlaid with the provided source data."},
			{PlotLadder, "Generates a line plot of the strand length as a function of peak position for standard curve analysis of nucleic acids from the provided ladder analysis object."},
			{PlotMeltingPoint, "Generates a list plot of the source melting curve analysis along with a demarcation of the fitted melting point."},
			{PlotImageExposure, "Generates a graphical representation of the provided exposure analysis object."},
			{PlotMicroscopeOverlay, "Generates a combined false color image of two or more microscope images taken with different filters from the provided microscope overlay analysis object."},
			{PlotPrediction, "Generates a plot of the source data of a fit overlaid with a line of the fitted equation from a provided fit analysis object along with a line intersecting the fit using the given value and its predicted result via the fit."},
			{PlotPeaks, "Generates a bar chart or pie chart of the relative peak areas from the provided peak picking analysis object."},
			{PlotQuantificationCycle, "Generates a list plot of fluorescence intensity as a function of replication cycle with the quantification cycle (Cq) interpolated and highlighted from the provided quantification cycle analysis object."},
			{PlotSmoothing, "Generates a line plot of smooth data along with the original un-smoothed data points from a provided smoothing analysis object."},
			{PlotStandardCurve, "Generates a plot of a fitted standard curve overlaid with the data points use to fit it, and the input points the standard was applied to from the provided standard curve analysis object."},
			{PlotThermodynamics, "Generates a Van't Hoff plot log of Keq as a function of inverse temperature and the fitted line containing the thermodynamic parameters from the provided thermodynamic analysis object."}
		},

		"Plotting Simulation Objects" -> {
			{PlotProbeConcentration, "Generates a line plot of position vs predicted bound probe concentration from a provided primer set simulation object."},
			{PlotReactionMechanism, "Generates a graphical representation of a system of nucleic acid reactivity from a provided reaction mechanism."},
			{PlotState, "Generates a pie chart of relative concentrations of each species in a provided state representation."},
			{PlotTrajectory, "Generates a line plot of concentration as a function of time from the provided kinetic simulation object or trajectory representation."}
		},

		"Model Plotting" -> {
			{PlotGlycan, "Generates a graphic of the visual representation corresponding to a commonly accepted abbreviation of the glycan."},
			{PlotGlycanSequence, "Plots the graphical glycan sequence according to the input."},
			{PlotProtein, "Generates a 3D ribbon diagram of protein structure diagram from the provided protein model."},
			{PlotTranscript, "Returns a nucleic acid secondary structure visualization of the provided transcript model."},
			{PlotVirus, "Returns a electron microscopy image of the virion particle from the provided virus model."}
		}

	},
	RelatedGuides -> {
		GuideLink["PlottingBySubjectMatter"],
		GuideLink["PlottingUtilities"]
	}
]
