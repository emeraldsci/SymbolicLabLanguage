(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Calculating Experiment Options",
	Abstract -> "Collection of functions that returns the resolved options of the experiment functions for the given input.",
	Reference -> {
		"Liquid Transfers" -> {
			{ExperimentSamplePreparationOptions, "Returns a list of resolved options when performing a list of basic operations for combining and preparing both liquid and solid samples in series."},
			{ExperimentSerialDiluteOptions, "Returns a list of resolved options when performing a series of dilutions iteratively by mixing samples with diluents and transferring to another container of the diluent."},
			{ExperimentAcousticLiquidHandlingOptions, "Returns a list of resolved options when performing transfers liquid samples with sound waves in nanoliter increments."},
			{ExperimentAliquotOptions, "Returns a list of resolved options when generating a series new samples by drawing from a source sample and optionally diluting them in a new buffer."},
			{ExperimentTransferOptions, "Returns a list of resolved options when moving an amount of sample from a specified source to a specified destination vessel."}
		},
		"Solid Transfers" -> {
			{ExperimentTransferOptions, "Returns a list of resolved options when moving an amount of sample from a specified source to a specified destination vessel."}
		},
		"Organic Synthesis" -> {
			{ExperimentDNASynthesisOptions, "Returns a list of resolved options when performing solid-phase deoxyribonucleic acid oligonucleotide synthesis of the given sequence or set of sequences using phosphoramidite chemistry."},
			{ExperimentRNASynthesisOptions, "Returns a list of resolved options when performing solid-phase ribonucleic acid oligonucleotide synthesis of the given sequence or set of sequences using phosphoramidite chemistry."},
			{ExperimentPNASynthesisOptions, "Returns a list of resolved options when performing solid-phase peptide synthesis of a given Peptide Nucleic Acid (PNA) sequencer set of sequences using Boc or Fmoc strategies."},
			{ExperimentPCROptions, "Returns a list of resolved options when amplifying a target sequence from a small quantity of template nucleic acid samples using oligonucleotide primers complementary to the two ends of the target sequence."},
			{ExperimentPeptideSynthesisOptions, "Returns a list of resolved options when performing classical solution phase synthesis of amino acids."},
			{ExperimentBioconjugationOptions, "Returns a list of resolved options when performing covalently binding the specified samples through chemical crosslinking creates a sample composed of new specified identity models."}
		},
		"Separations" -> {
			{ExperimentTotalProteinDetectionOptions, "Returns a list of resolved options when measuring total protein amount and labeling percentage using capillary electrophoresis."},
			{ExperimentSolidPhaseExtractionOptions, "Returns a list of resolved options when performing Solid Phase Extraction (SPE) to purify analyte molecules in the given samples by adsorbing analytes to a solid-phase resin, washing the resin with was buffer to remove impurities, and then eluting the analyte from the solid phase using an elution buffer."},
			{ExperimentHPLCOptions, "Returns a list of resolved options when performing High Pressure Liquid Chromatography (HPLC) to separate analyte molecules in the given samples on the basis of their relative affinity to a mobile phase and a solid phase by flowing mobile phase through columns at high pressures."},
			{ExperimentSupercriticalFluidChromatographyOptions, "Returns a list of resolved options when performing Supercritical Fluid Chromatography (SFC) to separate analyte molecules in the given samples on the basis of their relative affinity to a solid phase by flowing a pressured carbon dioxide stream through columns at high pressures."},
			{ExperimentFPLCOptions, "Returns a list of resolved options when performing Fast Protein Liquid Chromatography (FPLC) to separate analyte molecules in the given samples on the basis of their relative affinity to a mobile phase and a solid phase by flowing mobile phase through semi-disposable columns at moderate pressures."},
			{ExperimentAgaroseGelElectrophoresisOptions, "Returns a list of resolved options when performing agarose gel electrophoresis to separate analyte molecules in a given sample on the basis of their electrophoretic mobility though an agarose gel."},
			{ExperimentPAGEOptions, "Returns a list of resolved options when performing Polyacrylamide Gel Electrophoresis (PAGE) to separate analyte molecules in a given sample on the basis of their electrophoretic mobility though a polyacrylamide slab gel."},
			{ExperimentWesternOptions, "Returns a list of resolved options when performing a capillary-based experiment analogous to the traditional Western blot to detect the presence of a specific protein in a given sample."},
			{ExperimentCapillaryGelElectrophoresisSDSOptions, "Returns a list of resolved options when performing a capillary gel electrophoresis-SDS (CGE-SDS) on protein samples to separate them by their molecular weight."},
			{ExperimentIonChromatographyOptions, "Returns a list of resolved options when performing liquid chromatography to separate ionic species based on their interaction with a resin."},
			{ExperimentFlashChromatographyOptions, "Returns a list of resolved options when performing rapid separation to purify chemical mixtures based on their polarity differences with the aid of air pressure."},
			{ExperimentGasChromatographyOptions, "Returns a list of resolved options when performing separation of volatile analytes in gas-phase based on their interaction with the solid/liquid stationary phase."},
			{ExperimentGCMSOptions, "Returns a list of resolved options when performing gas chromatography by vaporizing volatilizable analytes in a sample and separating the gas-phase mixture via interaction with the stationary phase in the capillary column followed by injection of the separated analytes into a single quadrupole mass spectrometer to quantify the generated mass fragments by mass-to-charge ratio."},
			{ExperimentLCMSOptions, "Returns a list of resolved options when performing liquid chromatography (LC) to separate analyte molecules in the given sample, then ionizes each separated fraction to measure the mass-to-charge ratio of the molecules (MS)."},
			{ExperimentCrossFlowFiltrationOptions, "Returns a list of resolved options when performing filtration perpendicular to a filter."},
			{ExperimentDialysisOptions, "Returns a list of resolved options when performing separation to remove small unwanted compounds by diffusion through a semipermeable membrane."},
			{ExperimentCapillaryIsoelectricFocusingOptions, "Returns a list of resolved options when performing capillary Isoelectric Focusing (cIEF) to separate proteins based on their isoelectric point or charge."}
		},
		"Spectroscopy Experiments" -> {
			{ExperimentNMROptions, "Returns a list of resolved options when measuring the Nuclear Magnetic Resonance (NMR) of the given sample in one dimension in order to identify and characterize its chemical structure."},
			{ExperimentNMR2DOptions, "Returns a list of resolved options when measuring the two-dimensional Nuclear Magnetic Resonance (NMR) spectra of the given sample by correlating many one-dimensional NMR signals in order to identify and characterize its chemical structure."},
			{ExperimentAbsorbanceIntensityOptions, "Returns a list of resolved options when measuring Ultraviolet-Visible (UV-Vis) light absorbance of the given samples at a specific wavelength."},
			{ExperimentAbsorbanceSpectroscopyOptions, "Returns a list of resolved options when measuring Ultraviolet-Visible (UV-Vis) light absorbance of the given samples at a range of wavelengths."},
			{ExperimentAbsorbanceKineticsOptions, "Returns a list of resolved options when measuring Ultraviolet-Visible (UV-Vis) light absorbance of the given samples at a range of wavelengths over time."},
			{ExperimentIRSpectroscopyOptions, "Returns a list of resolved options when measuring Infrared (IR) light absorbance of the given samples at a range of wavelengths."},
			{ExperimentDynamicLightScatteringOptions, "Returns a list of resolved options when measuring scattered light intensity by moving particles in a sample to assess the size, polydispersity, thermal stability and colloidal stability of particles in the sample."},
			{ExperimentFluorescenceIntensityOptions, "Returns a list of resolved options when exciting the provided samples at given wavelength and measuring fluorescence signal at an emission wavelength."},
			{ExperimentFluorescenceSpectroscopyOptions, "Returns a list of resolved options when exciting the provided samples at given wavelength and measuring fluorescence signal at range of emission wavelengths."},
			{ExperimentFluorescenceKineticsOptions, "Returns a list of resolved options when exciting the provided samples at given wavelength and measuring evolution of fluorescence signal at an emission wavelength over time."},
			{ExperimentFluorescencePolarizationOptions, "Returns a list of resolved options when performing Fluorescence Polarization (FP), which assesses the fraction of sample bound to receptor by measuring the the molecular rotation of a fluorophore."},
			{ExperimentFluorescencePolarizationKineticsOptions, "Returns a list of resolved options when performing Fluorescence Polarization (FP) kinetics, assesses the fraction of sample bound to receptor by measuring the the molecular rotation of a fluorophore over time."},
			{ExperimentLuminescenceIntensityOptions, "Returns a list of resolved options when measuring the intensity of light produced by a samples undergoing chemical or biochemical reaction at a specific wavelength."},
			{ExperimentLuminescenceSpectroscopyOptions, "Returns a list of resolved options when measuring the intensity of light produced by a samples undergoing chemical or biochemical reaction at a range of wavelengths."},
			{ExperimentLuminescenceKineticsOptions, "Returns a list of resolved options when measuring the intensity of light produced by a samples undergoing chemical or biochemical reaction at a range of wavelengths over time."},
			{ExperimentNephelometryOptions, "Returns a list of resolved options when measuring the intensity of scattered light upon passing through a solution container suspended particles to characterize the amount of particles."},
			{ExperimentNephelometryKineticsOptions, "Returns a list of resolved options when measuring the change in the intensity of light scattered by a sample over time that contains insoluble suspended particles."},
			{ExperimentCircularDichroismOptions, "Returns a list of resolved options when measuring the differential absorption of specified samples' left and right circularly polarized light."},
			{ExperimentThermalShiftOptions, "Returns a list of resolved options when measuring changes in fluorescence emission of extrinsic fluorescent dyes or intrinsic molecular fluorescence to monitor conformational changes of nucleic acids or proteins across a temperature gradient."},
			{ExperimentRamanSpectroscopyOptions, "Returns a list of resolved options when measuring the intensity inelastic scattering of photons as the result of molecular vibrations interacting with monochromatic laser light."}
		},
		"Mass Spectrometry" -> {
			{ExperimentMassSpectrometryOptions, "Returns a list of resolved options when performing ionization of the given samples in order to measure the mass-to-charge ratio of the molecules in the samples."},
			{ExperimentGCMSOptions, "Returns a list of resolved options when performing gas chromatography by vaporizing volatilizable analytes in a sample and separating the gas-phase mixture via interaction with the stationary phase in the capillary column followed by injection of the separated analytes into a single quadrupole mass spectrometer to quantify the generated mass fragments by mass-to-charge ratio."},
			{ExperimentLCMSOptions, "Returns a list of resolved options when performing liquid chromatography (LC) to separate analyte molecules in the given sample, then ionizes each separated fraction to measure the mass-to-charge ratio of the molecules (MS)."},
			{ExperimentSupercriticalFluidChromatographyOptions, "Returns a list of resolved options when performing Supercritical Fluid Chromatography (SFC) to separate analyte molecules in the given samples on the basis of their relative affinity to a solid phase by flowing a pressured carbon dioxide stream through columns at high pressures. The output of this separation is then ionized in order to measure the mass-to-charge ratio of the molecules in the samples."},
			{ExperimentICPMSOptions, "Returns a list of resolved options when performing Inductively Coupled Plasma Mass Spectrometry (ICP-MS) to analyze the element or isotope composition and concentrations of given sample."}
		},
		"Bioassays" -> {
			{ExperimentAlphaScreenOptions, "Returns a list of resolved options when performing an ALPHA screen experiment with the given samples."},
			{ExperimentTotalProteinQuantificationOptions, "Returns a list of resolved options when performing an absorbance- or fluorescence-based assay to determine the total protein concentration of given input samples."},
			{ExperimentqPCROptions, "Returns a list of resolved options when performing a quantitative polymerase chain reaction (qPCR) which uses a thermocycler to amplify a target sequence (or sequences if multiplexing) from the sample using a primer set, quantifying the amount of DNA or RNA throughout the experiment using a fluorescent intercalating dye or fluorescently labeled probe."},
			{ExperimentBioLayerInterferometryOptions, "Returns a list of resolved options when quantifying the magnitude and kinetics of an interaction between a surface immobilized species and a solution phase analyte sample."},
			{ExperimentWesternOptions, "Returns a list of resolved options when performing a capillary-based experiment analogous to the traditional Western blot to detect the presence of a specific protein in a given sample."},
			{ExperimentUVMeltingOptions, "Returns a list of resolved options when performing Ultraviolet-Visible (UV-Vis) light absorbance melting curve analysis of given samples."},
			{ExperimentCapillaryELISAOptions,"Returns a list of resolved options when performing capillary Enzyme-Linked Immunosorbent Assay (ELISA) experiment on the provided Samples for the detection of certain analytes."},
			{ExperimentDifferentialScanningCalorimetryOptions, "Returns a list of resolved options when performing capillary differential scanning calorimetry (DSC) by measuring the amount of energy required to heat a given sample with respect to a reference."},
			{ExperimentELISAOptions, "Returns a list of resolved options when performing a quantitative characterization of the specific antigen concentration in samples."},
			{ExperimentDNASequencingOptions, "Returns a list of resolved options when identifying the order of nucleotides in a strand of DNA."}
		},
		"Crystallography" -> {
			{ExperimentGrowCrystalOptions, "Returns a list of resolved options when preparing crystallization samples."},
			{ExperimentPowderXRDOptions, "Returns a list of resolved options when measuring the diffraction of X-ray radiation on given powder samples."}
		},
		"Sample Preparation" -> {
			{ExperimentDiluteOptions, "Returns a list of resolved options when adding a specified amount of solvent to specified samples."},
			{ExperimentSamplePreparationOptions, "Returns a list of resolved options when performing a list of basic operations for combining and preparing both liquid and solid samples in series."},
			{ExperimentSerialDiluteOptions, "Returns a list of resolved options when performing a series of dilutions iteratively by mixing samples with diluents and transferring to another container of the diluent."},
			{ExperimentFlashFreezeOptions, "Returns a list of resolved options when performing freezing of specified sample objects through immersion of the sample containers in liquid nitrogen."},
			{ExperimentAliquotOptions, "Returns a list of resolved options when generating a series of new samples by drawing from a source sample and optionally diluting them in a new buffer."},
			{ExperimentIncubateOptions, "Returns a list of resolved options when heating and/or mixes the provided samples for a given amount of time at a given temperature, allowing for a follow up annealing time."},
			{ExperimentMixOptions, "Returns a list of resolved options when mixing and/or heating the provided samples for a given amount of time at a given rate and temperature."},
			{ExperimentTransferOptions, "Returns a list of resolved options when moving an amount of sample from a specified source to a specified destination vessel."},
			{ExperimentCentrifugeOptions, "Returns a list of resolved options when spinning down the provided samples for a given amount of time at a provided force or spin rate."},
			{ExperimentDegasOptions, "Returns a list of resolved options when performing a degassing procedure on the given samples using a specified technique."},
			{ExperimentFilterOptions, "Returns a list of resolved options when passing the provided samples through a given physical filter using a set of optional different methods."},
			{ExperimentStockSolutionOptions, "Returns a list of resolved options given a recipe containing a list of components and their amounts or concentrations, combination of the components, preparation, and conditioning of the mixture to generate a stock solution sample."},
			{ExperimentAutoclaveOptions, "Returns a list of resolved options when subjecting the provided samples or containers to extreme heat and pressure in order to sterilize."},
			{ExperimentEvaporateOptions, "Returns a list of resolved options when evaporating solvent from a provided sample under high vacuum at a given temperature with centrifugation to prevent bumping."},
			{ExperimentLyophilizeOptions, "Returns a list of resolved options when removing solvents from the provided samples via controlled freezing and sublimation under high vacuum."},
			{ExperimentPelletOptions, "Returns a list of resolved options when precipitating solids that are present in a solution, optionally aspirates off the supernatant, and resuspends the resulting pellet."},
			{ExperimentFillToVolumeOptions, "Returns a list of resolved options when adding sample to the a container until its volume reaches the desired value."},
			{ExperimentAcousticLiquidHandlingOptions, "Returns a list of resolved options when transferring liquid samples with sound waves in nanoliter increments."},
			{ExperimentAdjustpHOptions, "Returns a list of resolved options when adding acid or base titrant to change the pH of the given sample to the desired value.'"},
			{ExperimentResuspendOptions,"Returns a list of resolved options when dissolving the specified solid samples with some amount of solvent."},
			{ExperimentMagneticBeadSeparationOptions, "Returns a list of resolved options when isolating targets from specified sample via magnetic bead separation, which uses a magnetic field to separate superparamagnetic particles from suspensions."},
			{ExperimentMicrowaveDigestionOptions, "Returns a list of resolved options when breaking down complex samples via microwave heating and acid/oxidizing agent to fully solubilize sample for subsequent operations, especially ICP-MS."}
		},
		"Property Measurement" -> {
			{ExperimentCountLiquidParticlesOptions, "Returns a list of resolved options when measuring the number of suspended particles in a liquid colloid or very fine suspension sample."},
			{ExperimentMeasureOsmolalityOptions, "Returns a list of resolved options when measuring the concentration of osmotically active species in a solution."},
			{ExperimentMeasureConductivityOptions, "Returns a list of resolved options when measuring the electrical conductivity of a sample by immersion of a conductivity probe into the solution."},
			{ExperimentMeasureDensityOptions, "Returns a list of resolved options when measuring the density of the given samples using a fixed volume weight measurement or a density meter."},
			{ExperimentMeasureDissolvedOxygenOptions, "Returns a list of resolved options when measuring the partial pressure of oxygen in a sample by applying a constant voltage in a probe confined by an oxygen permeable membrane to detect oxygen reduction as an electrical signal. "},
			{ExperimentMeasurepHOptions, "Returns a list of resolved options when measuring the pH of the given sample using electrical potential sensors."},
			{ExperimentMeasureWeightOptions, "Returns a list of resolved options when measuring the weight of the given samples using an appropriately sized balance."},
			{ExperimentMeasureVolumeOptions, "Returns a list of resolved options when measuring the volume of the given samples using ultrasonic measurement of liquid surface distance and prior parametrization of the surface distance to volume in the samples container to determine sample volumes." },
			{ExperimentMeasureCountOptions, "Returns a list of resolved options when measuring the number of tablets in a given tablet sample by determining the average weight of the tablets in the sample and the total mass of the given tablet sample."},
			{ExperimentImageSampleOptions, "Returns a list of resolved options when recording an image of the given sample either from above or side on for larger transparent vessels."},
			{ExperimentMeasureSurfaceTensionOptions, "Returns a list of resolved options when measuring the surface tension of a sample by measuring the forces exerted on a small diameter rod as it is withdrawn from a sample."},
			{ExperimentMeasureRefractiveIndexOptions, "Returns a list of resolved options when measuring the Refractive Index (RI) of the given sample with refractometer."},
			{ExperimentCyclicVoltammetryOptions, "Returns a list of resolved options when measuring the reduction and oxidation processes of the given sample using Cyclic Voltammetry (CV)."},
			{ExperimentPrepareReferenceElectrodeOptions, "Returns a list of resolved options when generating a reference electrode filled with a reference solution to be used in electrochemical experiments, including Cyclic Voltammetry measurements."},
			{ExperimentVisualInspectionOptions, "Returns a list of resolved options when monitoring the insoluble particles in the given sample while its container is agitated."},
			{ExperimentMeasureViscosityOptions, "Returns a list of resolved options when measuring a fluid's viscosity defined as the resistance to deformation by assessing the flow rate of the sample when loaded into the viscometer chip."},
			{ExperimentDynamicFoamAnalysisOptions, "Returns a list of resolved options when characterizing the foamability, stability, drainage process and structure of liquid-based foams by monitoring foam generation and decay of a sample."}
		},
		"Cellular Experiments"->{
			{ExperimentImageCellsOptions,"Returns a list of resolved options when performing imaging on provided cellular samples using a bright-field microscope or a high content imager."}
		}
	},
	RelatedGuides -> {
		GuideLink["RunningExperiments"],
		GuideLink["UnitOperations"],
		GuideLink["ValidatingExperiments"],
		GuideLink["ExperimentTrackingAndManagement"],
		GuideLink["FacilitiesCapabilitiesAndLimitations"],
		GuideLink["PricingFunctions"]
	}
]