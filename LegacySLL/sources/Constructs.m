(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*Type*)


(* ::Subsubsection::Closed:: *)
(*typeP*)


typeP=(Object|Model)[Repeated[_Symbol,{0,5}]];


(* ::Subsection::Closed:: *)
(*Peaks Field Lookup*)


(* ::Subsubsection::Closed:: *)
(*peaksLookup*)


(*
	Elements are: type \[Rule] {PeaksField \[Rule] PeaksSourceField..}
	Used to relate Peaks/PeaksSource fields in types as a result of the flattening of field names
	to disallow things like PeaksSource[Spectra] as field names.
*)
peaksLookup={
	Object[Data,AbsorbanceSpectroscopy]-> {AbsorbanceSpectrum -> AbsorbanceSpectrumPeaksSource},
	Object[Data,AgaroseGelElectrophoresis] -> {
		SampleElectropherogram -> SampleElectropherogramPeaksAnalyses,
		MarkerElectropherogram -> MarkerElectropherogramPeaksAnalyses,
		PostSelectionElectropherogram->PostSelectionPeaksAnalyses
	},
	Object[Data,Chromatography] -> {
		Absorbance -> AbsorbancePeaksAnalyses,
		Absorbance3D -> Absorbance3DPeaksAnalyses,
		SecondaryAbsorbance -> SecondaryAbsorbancePeaksAnalyses,
		Conductance -> ConductancePeaksAnalyses,
		Fluorescence -> FluorescencePeaksAnalyses,
		SecondaryFluorescence -> SecondaryFluorescencePeaksAnalyses,
		TertiaryFluorescence -> TertiaryFluorescencePeaksAnalyses,
		QuaternaryFluorescence -> QuaternaryFluorescencePeaksAnalyses,
		Scattering -> ScatteringPeaksAnalyses,
		DynamicLightScattering -> DynamicLightScatteringPeaksAnalyses,
		MultiAngleLightScattering22Degree -> MultiAngleLightScatteringAnalyses,
		RefractiveIndex -> RefractiveIndexPeaksAnalysis,
		Scattering -> ScatteringPeaksAnalyses,
		FIDResponse -> FIDResponsePeaksAnalyses,
		Charge -> ChargePeaksAnalyses
	},
	Object[Data,ChromatographyMassSpectra] -> {
		Absorbance -> AbsorbancePeaksAnalyses,
		Absorbance3D -> Absorbance3DPeaksAnalyses,
		IonAbundance -> IonAbundancePeaksAnalyses,
		IonAbundance3D -> IonAbundance3DPeaksAnalyses,
		TotalIonAbundance -> IonAbundancePeaksAnalyses,
		MassSpectrum -> MassSpectrumPeaksAnalyses
	},
	Object[Data,FluorescenceSpectroscopy] -> {EmissionSpectrum -> EmissionSpectrumPeaksAnalyses,ExcitationSpectrum->ExcitationSpectrumPeaksAnalyses},
	Object[Data,LuminescenceSpectroscopy] -> {EmissionSpectrum -> PeaksAnalyses},
	Object[Data,MassSpectrometry] -> {MassSpectrum -> MassSpectrumPeaksAnalyses},
	Object[Data,MeltingCurve] -> {
		InitialIntensityDistribution->InitialIntensityPeaksAnalyses,
		FinalIntensityDistribution->FinalIntensityPeaksAnalyses,
		InitialMassDistribution->InitialMassPeaksAnalyses,
		FinalMassDistribution->FinalMassPeaksAnalyses
	},
	Object[Data,NMR] -> {NMRSpectrum -> NMRSpectrumPeaksAnalyses},
	Object[Data,PAGE] -> {
		OptimalLaneIntensity -> LanePeaksAnalyses,
		OptimalLaneImage -> LanePeaksAnalyses,
		LowExposureLaneIntensity -> LanePeaksAnalyses,
		MediumLowExposureLaneIntensity -> LanePeaksAnalyses,
		MediumHighExposureLaneIntensity -> LanePeaksAnalyses,
		HighExposureLaneIntensity -> LanePeaksAnalyses,
		LowExposureLadderIntensity -> LanePeaksAnalyses,
		MediumLowExposureLadderIntensity -> LanePeaksAnalyses,
		MediumHighExposureLadderIntensity -> LanePeaksAnalyses,
		HighExposureLadderIntensity -> LanePeaksAnalyses,
		LowExposureGelImage -> LanePeaksAnalyses,
		MediumLowExposureGelImage -> LanePeaksAnalyses,
		MediumHighExposureGelImage -> LanePeaksAnalyses,
		HighExposureGelImage -> LanePeaksAnalyses,
		LowExposureGelImageFile -> LanePeaksAnalyses,
		MediumLowExposureGelImageFile -> LanePeaksAnalyses,
		MediumHighExposureGelImageFile -> LanePeaksAnalyses,
		HighExposureGelImageFile -> LanePeaksAnalyses
	},
	Object[Data,Western] -> {MassSpectrum -> MassSpectrumPeaksAnalyses},
	Object[Data,TLC] -> {Intensity -> LanePeaksAnalyses, LaneImage -> LanePeaksAnalyses},
	Object[Data,XRayDiffraction] -> {BlankedDiffractionPattern -> DiffractionPeaksAnalyses},
	Object[Data,IRSpectroscopy] -> {AbsorbanceSpectrum -> AbsorbanceSpectrumPeaksSource},
	Object[Data,DifferentialScanningCalorimetry] -> {HeatingCurves -> HeatingCurvePeaksAnalyses},
	Object[Data,CircularDichroism]->{CircularDichroismAbsorbanceSpectrum->CircularDichroismPeaksAnalysis},
	Object[Data,DynamicLightScattering] -> {MassDistribution -> MassDistributionAnalyses,IntensityDistribution->IntensityDistributionAnalyses},
	Object[Data,CapillaryGelElectrophoresisSDS] -> {ProcessedUVAbsorbanceData -> PeaksAnalyses, RelativeMigrationData -> RelativeMigrationPeaksAnalyses},
	Object[Data, CoulterCount] -> {DiameterDistribution -> DiameterPeaksAnalyses, UnblankedDiameterDistribution -> DiameterPeaksAnalyses},
	Object[Data,CapillaryIsoelectricFocusing] -> {ProcessedUVAbsorbanceData -> PeaksAnalyses},
	Object[Data, FragmentAnalysis] -> {Electropherogram -> PeaksAnalyses, DNAFragmentSizeAnalyses -> PeaksAnalyses,RNAFragmentSizeAnalyses -> PeaksAnalyses}
};


(* ::Subsubsection::Closed:: *)
(*typeToPeaksFields*)


typeToPeaksFields[type:TypeP[]]:=Part[
	Lookup[peaksLookup,type,{}],
	All,
	1
];


(* ::Subsubsection::Closed:: *)
(*typeToPeaksSourceFields*)


typeToPeaksSourceFields[type:TypeP[]]:=Part[
	Lookup[
		peaksLookup,
		type,
		{}
	],
	All,
	2
];


(* ::Subsubsection::Closed:: *)
(*peaksFieldToPeaksSourceField*)


peaksFieldToPeaksSourceField[type:TypeP[], field:_Symbol]:=Lookup[
	Lookup[
		peaksLookup,
		type,
		{}
	],
	field,
	$Failed
];



(* ::Subsection::Closed:: *)
(*Fit Field Lookup*)


(* ::Subsubsection::Closed:: *)
(*fitLookup*)


(*
	Elements are: type \[Rule] {FitField \[Rule] FitSourceField..}
	Used to relate Fit/FitSource fields in types as a result of the flattening of field names
	to disallow things like FitSource[Spectra] as field names.
*)
fitLookup={
	Object[Data,Western]->{MassSpectrum->FitSourceSpectra},
	Object[Analysis,Ladder]->{FragmentPeaks->StandardFit}
};


(* ::Subsubsection::Closed:: *)
(*fitFieldToFitSourceField*)


fitFieldToFitSourceField[type:TypeP[], field:_Symbol]:=Lookup[
	Lookup[
		fitLookup,
		type,
		{}
	],
	field,
	$Failed
];
