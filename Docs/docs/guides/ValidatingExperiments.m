(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Validating Experiments",
	Abstract -> "Collection of functions to check the validity of running experiment functions on given input and options.",
	Reference -> {
		"Liquid Transfers" -> {
			{ValidExperimentSamplePreparationQ, "Checks if the provided samples and specified options for the given ExperimentSamplePreparation function call are valid."},
			{ValidExperimentSerialDiluteQ, "Checks if the provided samples and specified options for the given ExperimentSerialDilute function call are valid."},
			{ValidExperimentAcousticLiquidHandlingQ, "Checks if the provided samples and specified options for the given ExperimentAcousticLiquidHandling function call are valid."},
			{ValidExperimentAliquotQ, "Checks if the provided samples and specified options for the given ExperimentAliquot function call are valid."},
			{ValidExperimentTransferQ, "Checks if the provided samples and specified options for the given ExperimentTransfer function call are valid."}
		},
		"Solid Transfers" -> {
			{ValidExperimentTransferQ, "Checks if the provided samples and specified options for the given ExperimentTransfer function call are valid."}
		},
		"Organic Synthesis" -> {
			{ValidExperimentDNASynthesisQ, "Checks if the provided samples and specified options for the given ExperimentDNASynthesis function call are valid."},
			{ValidExperimentRNASynthesisQ, "Checks if the provided samples and specified options for the given ExperimentRNASynthesis function call are valid."},
			{ValidExperimentPNASynthesisQ, "Checks if the provided samples and specified options for the given ExperimentPNASynthesis function call are valid."},
			{ValidExperimentPCRQ, "Checks if the provided samples and specified options for the given ExperimentPCR function call are valid."},
			{ValidExperimentPeptideSynthesisQ, "Checks if the provided samples and specified options for the given ExperimentPeptideSynthesis function call are valid."},
			{ValidExperimentBioconjugationQ, "Checks if the provided samples and specified options for the given ExperimentBioconjugation function call are valid."},
			{ValidSynthesisStepQ, "Checks if the input primitive has all the required key and can pass all the associated tests."}
		},
		"Separations" -> {
			{ValidExperimentTotalProteinDetectionQ, "Checks if the provided samples and specified options for the given ExperimentTotalProteinDetection function call are valid."},
			{ValidExperimentSolidPhaseExtractionQ, "Checks if the provided samples and specified options for the given ExperimentSolidPhaseExtraction function call are valid."},
			{ValidExperimentHPLCQ, "Checks if the provided samples and specified options for the given ExperimentHPLC function call are valid."},
			{ValidExperimentSupercriticalFluidChromatographyQ, "Checks if the provided samples and specified options for the given ExperimentSupercriticalFluidChromatography function call are valid."},
			{ValidExperimentFPLCQ, "Checks if the provided samples and specified options for the given ExperimentFPLC function call are valid."},
			{ValidExperimentAgaroseGelElectrophoresisQ, "Checks if the provided samples and specified options for the given ExperimentAgaroseGelElectrophoresis function call are valid."},
			{ValidExperimentPAGEQ, "Checks if the provided samples and specified options for the given ExperimentPAGE function call are valid."},
			{ValidExperimentWesternQ, "Checks if the provided samples and specified options for the given ExperimentWestern function call are valid."},
			{ValidExperimentCapillaryGelElectrophoresisSDSQ, "Checks if the provided samples and specified options for the given ExperimentCapillaryGelElectrophoresisSDS function call are valid."},
			{ValidExperimentIonChromatographyQ, "Checks if the provided samples and specified options for the given ExperimentIonChromatography function call are valid."},
			{ValidExperimentFlashChromatographyQ, "Checks if the provided samples and specified options for the given ExperimentFlashChromatography function call are valid."},
			{ValidExperimentGasChromatographyQ, "Checks if the provided samples and specified options for the given ExperimentGasChromatography function call are valid."},
			{ValidExperimentGCMSQ, "Checks if the provided samples and specified options for the given ExperimentGCMS function call are valid."},
			{ValidExperimentLCMSQ, "Checks if the provided samples and specified options for the given ExperimentLCMS function call are valid."},
			{ValidExperimentCrossFlowFiltrationQ, "Checks if the provided samples and specified options for the given ExperimentCrossFlowFiltration function call are valid."},
			{ValidExperimentDialysisQ, "Checks if the provided samples and specified options for the given ExperimentDialysis function call are valid."},
			{ValidExperimentCapillaryIsoelectricFocusingQ, "Checks if the provided samples and specified options for the given ExperimentCapillaryIsoelectricFocusing function call are valid."}
		},
		"Spectroscopy Experiments" -> {
			{ValidExperimentNMRQ, "Checks if the provided samples and specified options for the given ExperimentNMR function call are valid."},
			{ValidExperimentNMR2DQ, "Checks if the provided samples and specified options for the given ExperimentNMR2D function call are valid."},
			{ValidExperimentAbsorbanceIntensityQ, "Checks if the provided samples and specified options for the given ExperimentAbsorbanceIntensity function call are valid."},
			{ValidExperimentAbsorbanceSpectroscopyQ, "Checks if the provided samples and specified options for the given ExperimentAbsorbanceSpectroscopy function call are valid."},
			{ValidExperimentAbsorbanceKineticsQ, "Checks if the provided samples and specified options for the given ExperimentAbsorbanceKinetics function call are valid."},
			{ValidExperimentIRSpectroscopyQ, "Checks if the provided samples and specified options for the given ExperimentIRSpectroscopy function call are valid."},
			{ValidExperimentDynamicLightScatteringQ, "Checks if the provided samples and specified options for the given ExperimentDynamicLightScattering function call are valid."},
			{ValidExperimentFluorescenceIntensityQ, "Checks if the provided samples and specified options for the given ExperimentFluorescenceIntensity function call are valid."},
			{ValidExperimentFluorescenceSpectroscopyQ, "Checks if the provided samples and specified options for the given ExperimentFluorescenceSpectroscopy function call are valid."},
			{ValidExperimentFluorescenceKineticsQ, "Checks if the provided samples and specified options for the given ExperimentFluorescenceKinetics function call are valid."},
			{ValidExperimentFluorescencePolarizationQ, "Checks if the provided samples and specified options for the given ExperimentFluorescencePolarization function call are valid."},
			{ValidExperimentFluorescencePolarizationKineticsQ, "Checks if the provided samples and specified options for the given ExperimentFluorescencePolarizationKinetics function call are valid."},
			{ValidExperimentLuminescenceIntensityQ, "Checks if the provided samples and specified options for the given ExperimentLuminescenceIntensity function call are valid."},
			{ValidExperimentLuminescenceSpectroscopyQ, "Checks if the provided samples and specified options for the given ExperimentLuminescenceSpectroscopy function call are valid."},
			{ValidExperimentLuminescenceKineticsQ, "Checks if the provided samples and specified options for the given ExperimentLuminescenceKinetics function call are valid."},
			{ValidExperimentNephelometryQ, "Checks if the provided samples and specified options for the given ExperimentNephelometry function call are valid."},
			{ValidExperimentNephelometryKineticsQ, "Checks if the provided samples and specified options for the given ExperimentNephelometryKinetics function call are valid."},
			{ValidExperimentCircularDichroismQ, "Checks if the provided samples and specified options for the given ExperimentCircularDichroism function call are valid."},
			{ValidExperimentThermalShiftQ, "Checks if the provided samples and specified options for the given ExperimentThermalShift function call are valid."},
			{ValidExperimentRamanSpectroscopyQ, "Checks if the provided samples and specified options for the given ExperimentRamanSpectroscopy function call are valid."}
		},
		"Mass Spectrometry" -> {
			{ValidExperimentMassSpectrometryQ, "Checks if the provided samples and specified options for the given ExperimentMassSpectrometry function call are valid."},
			{ValidExperimentGCMSQ, "Checks if the provided samples and specified options for the given ExperimentGCMS function call are valid."},
			{ValidExperimentLCMSQ, "Checks if the provided samples and specified options for the given ExperimentLCMS function call are valid."},
			{ValidExperimentSupercriticalFluidChromatographyQ, "Checks if the provided samples and specified options for the given ExperimentSupercriticalFluidChromatography function call are valid."},
			{ValidExperimentICPMSQ, "Checks if the provided samples and specified options for the given ExperimentICPMS function call are valid."}
		},
		"Bioassays" -> {
			{ValidExperimentAlphaScreenQ, "Checks if the provided samples and specified options for the given ExperimentAlphaScreen function call are valid."},
			{ValidExperimentTotalProteinQuantificationQ, "Checks if the provided samples and specified options for the given ExperimentTotalProteinQuantification function call are valid."},
			{ValidExperimentqPCRQ, "Checks if the provided samples and specified options for the given ExperimentqPCR function call are valid."},
			{ValidExperimentBioLayerInterferometryQ, "Checks if the provided samples and specified options for the given ExperimentBioLayerInterferometry function call are valid."},
			{ValidExperimentWesternQ, "Checks if the provided samples and specified options for the given ExperimentWestern function call are valid."},
			{ValidExperimentUVMeltingQ, "Checks if the provided samples and specified options for the given ExperimentUVMelting function call are valid."},
			{ValidExperimentCapillaryELISAQ, "Checks if the provided samples and specified options for the given ExperimentCapillaryELISA function call are valid."},
			{ValidExperimentDifferentialScanningCalorimetryQ, "Checks if the provided samples and specified options for the given ExperimentDifferentialScanningCalorimetry function call are valid."},
			{ValidExperimentELISAQ, "Checks if the provided samples and specified options for the given ExperimentELISA function call are valid."},
			{ValidExperimentDNASequencingQ, "Checks if the provided samples and specified options for the given ExperimentDNASequencing function call are valid."}
		},
		"Crystallography" -> {
			{ValidExperimentGrowCrystalQ, "Checks if the provided samples and specified options for the given ExperimentGrowCrystal function call are valid."},
			{ValidExperimentPowderXRDQ, "Checks if the provided samples and specified options for the given ExperimentPowderXRD function call are valid."}
		},
		"Sample Preparation" -> {
			{ValidExperimentDiluteQ, "Checks if the provided samples and specified options for the given ExperimentDilute function call are valid."},
			{ValidExperimentSamplePreparationQ, "Checks if the provided samples and specified options for the given ExperimentSamplePreparation function call are valid."},
			{ValidExperimentSerialDiluteQ, "Checks if the provided samples and specified options for the given ExperimentSerialDilute function call are valid."},
			{ValidExperimentFlashFreezeQ, "Checks if the provided samples and specified options for the given ExperimentFlashFreeze function call are valid."},
			{ValidExperimentAliquotQ, "Checks if the provided samples and specified options for the given ExperimentAliquot function call are valid."},
			{ValidExperimentIncubateQ, "Checks if the provided samples and specified options for the given ExperimentIncubate function call are valid."},
			{ValidExperimentMixQ, "Checks if the provided samples and specified options for the given ExperimentMix function call are valid."},
			{ValidExperimentTransferQ, "Checks if the provided samples and specified options for the given ExperimentTransfer function call are valid."},
			{ValidExperimentCentrifugeQ, "Checks if the provided samples and specified options for the given ExperimentCentrifuge function call are valid."},
			{ValidExperimentDegasQ, "Checks if the provided samples and specified options for the given ExperimentDegas function call are valid."},
			{ValidExperimentFilterQ, "Checks if the provided samples and specified options for the given ExperimentFilter function call are valid."},
			{ValidExperimentStockSolutionQ, "Checks if the provided samples and specified options for the given ExperimentStockSolution function call are valid."},
			{ValidExperimentAutoclaveQ, "Checks if the provided samples and specified options for the given ExperimentAutoclave function call are valid."},
			{ValidExperimentEvaporateQ, "Checks if the provided samples and specified options for the given ExperimentEvaporate function call are valid."},
			{ValidExperimentLyophilizeQ, "Checks if the provided samples and specified options for the given ExperimentLyophilize function call are valid."},
			{ValidExperimentPelletQ, "Checks if the provided samples and specified options for the given ExperimentPellet function call are valid."},
			{ValidExperimentFillToVolumeQ, "Checks if the provided samples and specified options for the given ExperimentFillToVolume function call are valid."},
			{ValidExperimentAcousticLiquidHandlingQ, "Checks if the provided samples and specified options for the given ExperimentAcousticLiquidHandling function call are valid."},
			{ValidExperimentAdjustpHQ, "Checks if the provided samples and specified options for the given ExperimentAdjustpH function call are valid."},
			{ValidExperimentResuspendQ, "Checks if the provided samples and specified options for the given ExperimentResuspend function call are valid."},
			{ValidExperimentMagneticBeadSeparationQ, "Checks if the provided samples and specified options for the given ExperimentMagneticBeadSeparation function call are valid."},
			{ValidExperimentMicrowaveDigestionQ, "Checks if the provided samples and specified options for the given ExperimentMicrowaveDigestion function call are valid."},
			{ValidExperimentDesiccateQ, "Checks if the provided samples and specified options for the given ExperimentDesiccate function call are valid."},
			{ValidExperimentGrindQ, "Checks if the provided samples and specified options for the given ExperimentGrind function call are valid."}
		},
		"Property Measurement" -> {
			{ValidExperimentCountLiquidParticlesQ, "Checks if the provided samples and specified options for the given ExperimentCountLiquidParticles function call are valid."},
			{ValidExperimentMeasureOsmolalityQ, "Checks if the provided samples and specified options for the given ExperimentMeasureOsmolality function call are valid."},
			{ValidExperimentMeasureConductivityQ, "Checks if the provided samples and specified options for the given ExperimentMeasureConductivity function call are valid."},
			{ValidExperimentMeasureDensityQ, "Checks if the provided samples and specified options for the given ExperimentMeasureDensity function call are valid."},
			{ValidExperimentMeasureDissolvedOxygenQ, "Checks if the provided samples and specified options for the given ExperimentMeasureDissolvedOxygen function call are valid."},
			{ValidExperimentMeasurepHQ, "Checks if the provided samples and specified options for the given ExperimentMeasurepH function call are valid."},
			{ValidExperimentMeasureWeightQ, "Checks if the provided samples and specified options for the given ExperimentMeasureWeight function call are valid."},
			{ValidExperimentMeasureVolumeQ, "Checks if the provided samples and specified options for the given ExperimentMeasureVolume function call are valid."},
			{ValidExperimentMeasureCountQ, "Checks if the provided samples and specified options for the given ExperimentMeasureCount function call are valid."},
			{ValidExperimentImageSampleQ, "Checks if the provided samples and specified options for the given ExperimentImageSample function call are valid."},
			{ValidExperimentMeasureSurfaceTensionQ, "Checks if the provided samples and specified options for the given ExperimentMeasureSurfaceTension function call are valid."},
			{ValidExperimentMeasureRefractiveIndexQ, "Checks if the provided samples and specified options for the given ExperimentMeasureRefractiveIndex function call are valid."},
			{ValidExperimentCyclicVoltammetryQ, "Checks if the provided samples and specified options for the given ExperimentCyclicVoltammetry function call are valid."},
			{ValidExperimentPrepareReferenceElectrodeQ, "Checks if the provided samples and specified options for the given ExperimentPrepareReferenceElectrode function call are valid."},
			{ValidExperimentVisualInspectionQ, "Checks if the provided samples and specified options for the given ExperimentVisualInspection function call are valid."},
			{ValidExperimentMeasureViscosityQ, "Checks if the provided samples and specified options for the given ExperimentMeasureViscosity function call are valid."},
			{ValidExperimentDynamicFoamAnalysisQ, "Checks if the provided samples and specified options for the given ExperimentDynamicFoamAnalysis function call are valid."},
			{ValidExperimentMeasureMeltingPointQ, "Checks if the provided samples and specified options for the given ExperimentMeasureMeltingPoint function call are valid."}
		},
		"Cellular Experiments"->{
			{ValidExperimentImageCellsQ, "Checks if the provided samples and specified options for the given ExperimentImageCells function call are valid."}
		}
	},
	RelatedGuides -> {
		GuideLink["RunningExperiments"],
		GuideLink["UnitOperations"],
		GuideLink["CalculatingExperimentOptions"],
		GuideLink["ExperimentTrackingAndManagement"],
		GuideLink["FacilitiesCapabilitiesAndLimitations"],
		GuideLink["PricingFunctions"]
	}
]