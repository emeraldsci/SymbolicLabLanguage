

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Section:: *)
(*Experiment Analysis Guide*)


Guide[
  Title->"Experiment Analysis",
  Abstract->"",
  Reference->{
		"Chromatography"->{
			{AnalyzePeaks,"Pick peaks from a chromatograph."},
			{AnalyzeLadder,"Associate ladder peak positions with lengths and fit expression relating retention time to oligomer length."},
			{AnalyzeFractions,"Select fractions samples from all collected fractions."}
		},
		"AbsorbanceThermodynamics"->{
			{AnalyzeMeltingPoint,"Determine melting points in melting or cooling curves."},
			{AnalyzeThermodynamics,"Determine enthalpy and entropy values from a set of melting point analyses."}
		},
		"Quantification"->{
			{AnalyzeAbsorbanceQuantification},
			{AnalyzeTotalProteinQuantification}
		},
		"QPCR"->{
			{AnalyzeQuantificationCycle,"Calculate quantification cycle from an amplification curve."},
			{AnalyzeCopyNumber,"Compute copy number from quantification cycle and standard curve."}
		},
		"NMR"->{
			{AnalyzePeaks,"Pick peaks from NMR spectrum."}
		},
		"MassSpectrometry"->{
			{AnalyzePeaks,"Pick peaks from mass spectrum."}
		},
		"Western"->{
			{AnalyzePeaks,"Pick peaks from mass spectrum."},
			{AnalyzeLadder,"Associate ladder peak positions with lengths and fit expression relating retention position to oligomer length."}
		},
		"AbsorbanceSpectroscopy"->{
			{AnalyzePeaks,"Pick peaks from absorbance spectrum."}
		},
		"PAGE"->{
			{AnalyzePeaks,"Pick peaks from lane image intensity."},
			{AnalyzeLadder,""}
		},
		"TLC"->{
			{AnalyzePeaks}
		},
		"Microscope"->{
			{AnalyzeCellCount,"Count cells in a micropscope image."},
			{AnalyzeMicroscopeOverlay,""}
		},
		"FluorescenceKinetics"->{
			{AnalyzeKinetics,"Find a mechansim's kinetic rates from fluorescence kinetics trajectories."}
		},
		"FlowCytommetry"->{
			{AnalyzeGating,""}
		}
	},
	RelatedGuides->{GuideLink["Analysis Categories"]}
];
