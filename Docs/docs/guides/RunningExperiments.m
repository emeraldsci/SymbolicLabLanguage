(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Running Experiments",
	Abstract -> "Collection of functions used to remotely conduct experiments in an ECL facility.",
	Reference -> {
		"Liquid Transfers" -> {
			{ExperimentSamplePreparation, "Performs a list of basic operations for combining and preparing both liquid and solid samples in series."},
			{ExperimentSerialDilute, "Performs a series of dilutions iteratively by mixing samples with diluents and transferring to another container of the diluent."},
			{ExperimentAcousticLiquidHandling, "Transfers liquid samples with sound waves in nanoliter increments."},
			{ExperimentAliquot, "Generates a series new samples by drawing from a source sample and optionally diluting them in a new buffer."},
			{ExperimentTransfer, "Moves an amount of sample from a specified source to a specified destination vessel."}
		},
		"Solid Transfers" -> {
			{ExperimentTransfer, "Moves an amount of sample from a specified source to a specified destination vessel."}
		},
		"Organic Synthesis" -> {
			{ExperimentDNASynthesis, "Performs solid-phase deoxyribonucleic acid oligonucleotide synthesis of the given sequence or set of sequences using phosphoramidite chemistry."},
			{ExperimentRNASynthesis, "Performs solid-phase ribonucleic acid oligonucleotide synthesis of the given sequence or set of sequences using phosphoramidite chemistry."},
			{ExperimentPNASynthesis, "Performs solid-phase peptide synthesis of a given Peptide Nucleic Acid (PNA) sequencer set of sequences using Boc or Fmoc strategies."},
			{ExperimentPCR, "Amplifies a target sequence from a small quantity of template nucleic acid samples using oligonucleotide primers complementary to the two ends of the target sequence."},
			{ExperimentPeptideSynthesis, "Performs classical solution phase synthesis of amino acids."},
			{ExperimentBioconjugation, "Covalently binding the specified samples through chemical crosslinking creates a sample composed of new specified identity models."}
		},
		"Separations" -> {
			{ExperimentTotalProteinDetection, "Measures total protein amount and labeling percentage using capillary electrophoresis."},
			{ExperimentSolidPhaseExtraction, "Performs Solid Phase Extraction (SPE) to purify analyte molecules in the given samples by adsorbing analytes to a solid-phase resin, washing the resin with was buffer to remove impurities, and then eluting the analyte from the solid phase using an elution buffer."},
			{ExperimentHPLC, "Performs High Pressure Liquid Chromatography (HPLC) to separate analyte molecules in the given samples on the basis of their relative affinity to a mobile phase and a solid phase by flowing mobile phase through columns at high pressures."},
			{ExperimentSupercriticalFluidChromatography, "Performs Supercritical Fluid Chromatography (SFC) to separate analyte molecules in the given samples on the basis of their relative affinity to a solid phase by flowing a pressured carbon dioxide stream through columns at high pressures."},
			{ExperimentFPLC, "Performs Fast Protein Liquid Chromatography (FPLC) to separate analyte molecules in the given samples on the basis of their relative affinity to a mobile phase and a solid phase by flowing mobile phase through semi-disposable columns at moderate pressures."},
			{ExperimentAgaroseGelElectrophoresis, "Performs agarose gel electrophoresis to separate analyte molecules in a given sample on the basis of their electrophoretic mobility though an agarose gel."},
			{ExperimentPAGE, "Performs Polyacrylamide Gel Electrophoresis (PAGE) to separate analyte molecules in a given sample on the basis of their electrophoretic mobility though a polyacrylamide slab gel."},
			{ExperimentWestern, "Performs a capillary-based experiment analogous to the traditional Western blot to detect the presence of a specific protein in a given sample."},
			{ExperimentCapillaryGelElectrophoresisSDS, "Performs a capillary gel electrophoresis-SDS (CGE-SDS) on protein samples to separate them by their molecular weight."},
			{ExperimentIonChromatography, "Performs liquid chromatography to separate ionic species based on their interaction with a resin."},
			{ExperimentFlashChromatography, "Performs rapid separation to purify chemical mixtures based on their polarity differences with the aid of air pressure."},
			{ExperimentGCMS, "Performs gas chromatography by vaporizing volatilizable analytes in a sample and separating the gas-phase mixture via interaction with the stationary phase in the capillary column followed by injection of the separated analytes into a single quadrupole mass spectrometer to quantify the generated mass fragments by mass-to-charge ratio."},
			{ExperimentLCMS, "Performs liquid chromatography (LC) to separate analyte molecules in the given sample, then ionizes each separated fraction to measure the mass-to-charge ratio of the molecules (MS)."},
			{ExperimentCrossFlowFiltration, "Performs filtration perpendicular to a filter."},
			{ExperimentLiquidLiquidExtraction, "Separate the aqueous and organic phases of a given sample via pipette or phase separator, in order to isolate a target analyte that is more concentrated in either the aqueous or organic phase."},
			{ExperimentDialysis, "Performs separation to remove small unwanted compounds by diffusion through a semipermeable membrane."},
			{ExperimentCapillaryIsoelectricFocusing, "Performs capillary Isoelectric Focusing (cIEF) to separate proteins based on their isoelectric point or charge."},
			{ExperimentGasChromatography, "Performs separation of volatile analytes in gas-phase based on their interaction with the solid/liquid stationary phase."}
		},
		"Spectroscopy Experiments" -> {
			{ExperimentNMR, "Measures the Nuclear Magnetic Resonance (NMR) of the given sample in one dimension in order to identify and characterize its chemical structure."},
			{ExperimentNMR2D, "Measures the two-dimensional Nuclear Magnetic Resonance (NMR) spectra of the given sample by correlating many one-dimensional NMR signals in order to identify and characterize its chemical structure."},
			{ExperimentAbsorbanceIntensity, "Measures Ultraviolet-Visible (UV-Vis) light absorbance of the given samples at a specific wavelength."},
			{ExperimentAbsorbanceSpectroscopy, "Measures Ultraviolet-Visible (UV-Vis) light absorbance of the given samples at a range of wavelengths."},
			{ExperimentAbsorbanceKinetics, "Measures Ultraviolet-Visible (UV-Vis) light absorbance of the given samples at a range of wavelengths over time."},
			{ExperimentIRSpectroscopy, "Measures Infrared (IR) light absorbance of the given samples at a range of wavelengths."},
			{ExperimentDynamicLightScattering, "Measures scattered light intensity by moving particles in a sample to assess the size, polydispersity, thermal stability and colloidal stability of particles in the sample."},
			{ExperimentFluorescenceIntensity, "Excites the provided samples at given wavelength and records a measurement of fluorescence signal at an emission wavelength."},
			{ExperimentFluorescenceSpectroscopy, "Excites the provided samples at range of given wavelengths and records a measurement of fluorescence signal at range of emission wavelengths."},
			{ExperimentFluorescenceKinetics, "Excites the provided samples at given wavelength and monitors evolution of fluorescence signal at an emission wavelength over time."},
			{ExperimentFluorescencePolarization, "Performs Fluorescence Polarization (FP), which assesses the fraction of sample bound to receptor by measuring the molecular rotation of a fluorophore."},
			{ExperimentFluorescencePolarizationKinetics, "Performs Fluorescence Polarization (FP) kinetics, assesses the fraction of sample bound to receptor by measuring the molecular rotation of a fluorophore over time."},
			{ExperimentLuminescenceIntensity, "Measures the intensity of light produced by a samples undergoing chemical or biochemical reaction at a specific wavelength."},
			{ExperimentLuminescenceSpectroscopy, "Measures the intensity of light produced by a samples undergoing chemical or biochemical reaction at a range of wavelengths."},
			{ExperimentLuminescenceKinetics, "Measures the intensity of light produced by a samples undergoing chemical or biochemical reaction at a range of wavelengths over time."},
			{ExperimentNephelometry, "Measures the intensity of scattered light upon passing through a solution container suspended particles to characterize the amount of particles."},
			{ExperimentNephelometryKinetics, "Measures the change in the intensity of light scattered by a sample over time that contains insoluble suspended particles."},
			{ExperimentCircularDichroism, "Measures the differential absorption of specified samples' left and right circularly polarized light."},
			{ExperimentThermalShift, "Measures changes in fluorescence emission of extrinsic fluorescent dyes or intrinsic molecular fluorescence to monitor conformational changes of nucleic acids or proteins across a temperature gradient."},
			{ExperimentRamanSpectroscopy, "Measures the intensity inelastic scattering of photons as the result of molecular vibrations interacting with monochromatic laser light."}
		},
		"Mass Spectrometry" -> {
			{ExperimentMassSpectrometry, "Ionizes the given samples in order to measure the mass-to-charge ratio of the molecules in the samples."},
			{ExperimentGCMS, "Performs gas chromatography by vaporizing volatilizable analytes in a sample and separating the gas-phase mixture via interaction with the stationary phase in the capillary column followed by injection of the separated analytes into a single quadrupole mass spectrometer to quantify the generated mass fragments by mass-to-charge ratio."},
			{ExperimentLCMS, "Performs liquid chromatography (LC) to separate analyte molecules in the given sample, then ionizes each separated fraction to measure the mass-to-charge ratio of the molecules (MS)."},
			{ExperimentSupercriticalFluidChromatography, "Performs Supercritical Fluid Chromatography (SFC) to separate analyte molecules in the given samples on the basis of their relative affinity to a solid phase by flowing a pressured carbon dioxide stream through columns at high pressures. The output of this separation is then ionized in order to measure the mass-to-charge ratio of the molecules in the samples."},
			{ExperimentICPMS, "Performs Inductively Coupled Plasma Mass Spectrometry (ICP-MS) experiment to analyze the element or isotope composition and concentrations of given samples."}
		},
		"Bioassays" -> {
			{ExperimentAlphaScreen, "Performs an ALPHA screen experiment with the given samples."},
			{ExperimentTotalProteinQuantification, "Performs an absorbance- or fluorescence-based assay to determine the total protein concentration of given input samples."},
			{ExperimentqPCR, "Performs a quantitative polymerase chain reaction (qPCR) which uses a thermocycler to amplify a target sequence (or sequences if multiplexing) from the sample using a primer set, quantifying the amount of DNA or RNA throughout the experiment using a fluorescent intercalating dye or fluorescently labeled probe."},
			{ExperimentBioLayerInterferometry, "Quantifies the magnitude and kinetics of an interaction between a surface immobilized species and a solution phase analyte sample."},
			{ExperimentWestern, "Performs a capillary-based experiment analogous to the traditional Western blot to detect the presence of a specific protein in a given sample."},
			{ExperimentUVMelting, "Performs Ultraviolet-Visible (UV-Vis) light absorbance melting curve analysis of given samples."},
			{ExperimentCapillaryELISA,"Performs capillary Enzyme-Linked Immunosorbent Assay (ELISA) experiment on the provided Samples for the detection of certain analytes."},
			{ExperimentDifferentialScanningCalorimetry, "Performs capillary differential scanning calorimetry (DSC) by measuring the amount of energy required to heat a given sample with respect to a reference."},
			{ExperimentELISA, "Performs a quantitative characterization of the specific antigen concentration in samples."},
			{ExperimentDNASequencing, "Identifies the order of nucleotides in a strand of DNA."}
		},
		"Crystallography" -> {
			{ExperimentGrowCrystal, "Prepares crystals in crystallization plate and monitors the growth of crystals using visible light, ultraviolet light and cross polarized light."},
			{ExperimentPowderXRD, "Measures the diffraction of X-ray radiation on given powder samples."}
		},
		"Sample Preparation" -> {
			{ExperimentDilute, "Adds a specified amount of solvent to specified samples."},
			{ExperimentSamplePreparation, "Performs a list of basic operations for combining and preparing both liquid and solid samples in series."},
			{ExperimentAliquot, "Generates a series new samples by drawing from a source sample and optionally diluting them in a new buffer."},
			{ExperimentIncubate, "Heats and/or mixes the provided samples for a given amount of time at a given temperature, allowing for a follow up annealing time."},
			{ExperimentMix, "Mixes and/or heats the provided samples for a given amount of time at a given rate and temperature."},
			{ExperimentTransfer, "Moves an amount of sample from a specified source to a specified destination vessel."},
			{ExperimentCentrifuge, "Spins down the provided samples for a given amount of time at a provided force or spin rate."},
			{ExperimentDegas, "Performs a degassing procedure on the given samples using a specified technique."},
			{ExperimentFilter, "Passes the provided samples through a given physical filter using a set of optional different methods."},
			{ExperimentStockSolution, "Given a recipe containing a list of components and their amounts or concentrations, combines the components,  prepares, and conditions the mixture to generate a stock solution sample."},
			{ExperimentAutoclave, "Subjects the provided samples or containers to extreme heat and pressure in order to sterilize."},
			{ExperimentEvaporate, "Evaporates solvent from a provided sample under high vacuum at a given temperature with centrifugation to prevent bumping."},
			{ExperimentLyophilize, "Removes solvents from the provided samples via controlled freezing and sublimation under high vacuum."},
			{ExperimentPellet, "Precipitates solids that are present in a solution, optionally aspirates off the supernatant, and resuspends the resulting pellet."},
			{ExperimentFillToVolume, "Adds sample to the a container until its volume reaches the desired value."},
			{ExperimentAcousticLiquidHandling, "Transfers liquid samples with sound waves in nanoliter increments."},
			{ExperimentAdjustpH, "Adds acid or base titrant to change the pH of the given sample to the desired value.'"},
			{ExperimentResuspend,"Dissolve the specified solid samples with some amount of solvent."},
			{ExperimentMagneticBeadSeparation, "Isolates targets from specified sample via magnetic bead separation, which uses a magnetic field to separate superparamagnetic particles from suspensions."},
			{ExperimentMicrowaveDigestion, "Breaks down complex samples via microwave heating and acid/oxidizing agent to fully solubilize sample for subsequent operations, especially ICP-MS."},
			{ExperimentSerialDilute, "Performs a series of dilutions iteratively by mixing samples with diluents and transferring to another container of the diluent."},
			{ExperimentFlashFreeze, "Performs freezing of specified sample objects through immersion of the sample containers in liquid nitrogen."},
			{ExperimentDesiccate, "Dries out solid substances by absorbing water molecules from the samples through exposing them to a chemical desiccant in a bell jar desiccator under vacuum or non-vacuum conditions."},
			{ExperimentGrind, "Employs mechanical actions to break particles of solid samples into smaller powder particles, using a grinding apparatus"}
		},
		"Property Measurement" -> {
			{ExperimentCountLiquidParticles, "Measures the number of suspended particles in a liquid colloid or very fine suspension sample."},
			{ExperimentCoulterCount, "Measures the number and size distribution of suspended particles (typically cells) in a liquid colloid or very fine suspension sample."},
			{ExperimentMeasureOsmolality, "Measures the concentration of osmotically active species in a solution."},
			{ExperimentMeasureConductivity, "Measures the electrical conductivity of a sample by immersion of a conductivity probe into the solution."},
			{ExperimentMeasureContactAngle, "Measures the contact angle of a fiber sample with a wetting liquid using a force tensiometer."},
			{ExperimentMeasureDensity, "Measures the density of the given samples using a fixed volume weight measurement or a density meter."},
			{ExperimentMeasureDissolvedOxygen, "Measures the partial pressure of oxygen in a sample by applying a constant voltage in a probe confined by an oxygen permeable membrane to detect oxygen reduction as an electrical signal. "},
			{ExperimentMeasurepH, "Measures the pH of the given sample using electrical potential sensors."},
			{ExperimentMeasureWeight, "Measures the weight of the given samples using an appropriately sized balance."},
			{ExperimentMeasureVolume, "Measures the volume of the given samples using ultrasonic measurement of liquid surface distance and prior parametrization of the surface distance to volume in the samples container to determine sample volumes." },
			{ExperimentMeasureCount, "Measures the number of tablets in a given tablet sample by determining the average weight of the tablets in the sample and the total mass of the given tablet sample."},
			{ExperimentImageSample, "Records an image of the given sample either from above or side on for larger transparent vessels."},
			{ExperimentMeasureSurfaceTension, "Determines the surface tension of a sample by measuring the forces exerted on a small diameter rod as it is withdrawn from a sample."},
			{ExperimentMeasureRefractiveIndex, "Measures the Refractive Index (RI) of the given sample with refractometer."},
			{ExperimentCyclicVoltammetry, "Characterizes the reduction and oxidation processes of the given sample using Cyclic Voltammetry (CV)."},
			{ExperimentPrepareReferenceElectrode, "Generates a reference electrode filled with a reference solution to be used in electrochemical experiments, including Cyclic Voltammetry measurements."},
			{ExperimentVisualInspection, "Monitors the insoluble particles in the given sample while its container is agitated."},
			{ExperimentMeasureViscosity, "Measures a fluid's viscosity defined as the resistance to deformation by assessing the flow rate of the sample when loaded into the viscometer chip."},
			{ExperimentDynamicFoamAnalysis, "Characterizes the foamability, stability, drainage process and structure of liquid-based foams by monitoring foam generation and decay of a sample."},
			{ExperimentMeasureMeltingPoint, "Measures the melting points of the solid samples using a melting point apparatus that applies an increasing temperature gradient to melting point capillary tubes containing a small amount of the input samples."}
		},
		"Cellular Experiments" -> {
			{ExperimentImageCells, "Performs imaging on provided cellular samples using a bright-field microscope or a high content imager."},
			{ExperimentImageColonies, "Acquires bright-field, absorbance or fluorescence images of the provided samples containing microbial cells on a solid media plate using a colony handler."},
			{ExperimentLyseCells, "Ruptures the cell membranes of provided cell samples to enable extraction of targeted cellular components."},
			{ExperimentFreezeCells, "Lowers the temperature of cell samples under controlled conditions to prepare cells for long term cryopreservation."},
			{ExperimentCoulterCount, "Measures the number and size distribution of suspended cells in a cellular sample."},
			{ExperimentQuantifyColonies, "Measures the microbial cell concentration in the provided samples."}
		}
	},
	RelatedGuides -> {
		GuideLink["ValidatingExperiments"],
		GuideLink["CalculatingExperimentOptions"],
		GuideLink["AnalysisBySubjectMatter"],
		GuideLink["PlottingBySubjectMatter"],
		GuideLink["ExperimentTrackingAndManagement"],
		GuideLink["FacilitiesCapabilitiesAndLimitations"],
		GuideLink["PricingFunctions"]
	}
]
