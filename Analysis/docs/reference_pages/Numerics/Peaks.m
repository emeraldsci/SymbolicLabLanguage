(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AnalyzePeaks*)


DefineUsage[AnalyzePeaks,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzePeaks[dataObject]", "analysisObject"},
			Description -> "finds peaks in the data from the field of 'dataObject' defined by the ReferenceField option, and computes peak properties such as Position, Height, Width, and Area.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "dataObject",
						Description -> "Object containing data that will be analyzed for peaks.",
						Widget -> Widget[Type->Object,Pattern:>ObjectP[
							{
								Object[Data,Chromatography],Object[Data,ChromatographyMassSpectra],Object[Data,AbsorbanceSpectroscopy],
								Object[Data,MassSpectrometry],Object[Data,NMR],Object[Data,PAGE],Object[Data,TLC],Object[Data,Western],
								Object[Data,FluorescenceSpectroscopy],Object[Data,LuminescenceSpectroscopy],Object[Data,XRayDiffraction],
								Object[Data,IRSpectroscopy],Object[Data,AgaroseGelElectrophoresis],
								Object[Data,DifferentialScanningCalorimetry],Object[Data,MeltingCurve],
								Object[Data,CircularDichroism],Object[Data,DynamicLightScattering],Object[Data,CapillaryGelElectrophoresisSDS]
							}
						]]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs:>{
				{
					OutputName -> "analysisObject",
					Description -> "An analysis object containing information about peaks in the given data, including peak heights and areas.",
					Pattern :> {_?NumericQ...}
				}
			}
		},
		{
			Definition -> {"AnalyzePeaks[protocol]", "{AnalysisObject..}"},
			Description -> "finds peaks in all DataObjects linked to the given 'protocol', and computes peak properties such as Position, Height, Width, and Area.",
			Inputs:>{
				{
					InputName -> "protocol",
					Description -> "Protocol object containing data that will be analyzed.",
						Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{
							Object[Protocol,HPLC],
							Object[Protocol,FPLC],
							Object[Protocol,AbsorbanceSpectroscopy],
							Object[Protocol,AgaroseGelElectrophoresis],
							Object[Protocol,MassSpectrometry],
							Object[Protocol,PAGE],
							Object[Protocol,Western],
							Object[Protocol,FluorescenceSpectroscopy],
							Object[Protocol,LCMS],
							Object[Protocol,LuminescenceSpectroscopy],
							Object[Protocol,NMR],
							Object[Protocol,PowderXRD],
							Object[Protocol,IRSpectroscopy],
							Object[Protocol,DifferentialScanningCalorimetry],
							Object[Protocol,SupercriticalFluidChromatography],
							Object[Protocol,CapillaryGelElectrophoresisSDS]
						}],
						Dereference -> {
							Object[Protocol,HPLC] -> Field[Data],
							Object[Protocol,FPLC] -> Field[Data],
							Object[Protocol,AbsorbanceSpectroscopy] -> Field[Data],
							Object[Protocol,AgaroseGelElectrophoresis] -> Field[Data],
							Object[Protocol,MassSpectrometry] -> Field[Data],
							Object[Protocol,PAGE] -> Field[Data],
							Object[Protocol,Western] -> Field[Data],
							Object[Protocol,FluorescenceSpectroscopy] -> Field[Data],
							Object[Protocol,LCMS] -> Field[Data],
							Object[Protocol,LuminescenceSpectroscopy] -> Field[Data],
							Object[Protocol,NMR] -> Field[Data],
							Object[Protocol,PowderXRD] -> Field[Data],
							Object[Protocol,IRSpectroscopy] -> Field[Data],
							Object[Protocol,DifferentialScanningCalorimetry] -> Field[Data],
							Object[Protocol,SupercriticalFluidChromatography] -> Field[Data],
							Object[Protocol,CapillaryGelElectrophoresisSDS] -> Field[Data]
						}
					]
				}
			},
			Outputs:>{
				{
					OutputName -> "analysisObject",
					Description -> "An analysis object containing information about peaks in the given data, including peak heights and areas.",
					Pattern :> {_?NumericQ...}
				}
			}
		},
		{
			Definition -> {"AnalyzePeaks[numericalData]", "analysisObject"},
			Description -> "finds peaks in the 'numericalData', and computes peak properties such as Position, Height, Width, and Area.",
			Inputs:>{
				{
					InputName -> "numericalData",
					Description -> "A list of two dimensional data points that will be analyzed for peaks.",
					Widget -> Widget[Type -> Expression, Pattern :> CoordinatesP|QuantityCoordinatesP[], Size -> Paragraph]
				}
			},

			Outputs:>{
				{
					OutputName -> "analysisObject",
					Description -> "An analysis object containing information about peaks in the given data, including peak heights and areas.",
					Pattern :> {_?NumericQ...}
				}
			}
		}
	},
	MoreInformation -> {
		"Each peak found is parameterized by its Position, Height, Width, Area, PeakRangeStart, PeakRangeEnd, WidthRangeStart, WidthRangeEnd, BaselineIntercept, and BaselineSlope.",
		"Peaks are returned sorted by increasing Position.",
		"Peak parameters are calculated following USP guidelines: Object[Report,Literature,\"id:bq9LA0JX8vKv\"].",
		"PeakResolution is calculated as 1.18(tR2 \[Minus] tR1)/(W[1,h/2] + W[2,h/2]), where tR1 and tR2 are retention times and W[1,h/2] and W[2,h/2] are Width at half height.",
		"HalfHeightNumberOfPlates is calculated as 5.54(tR/W[h/2])^2, where tR is retention time and W[h/2] is Width at half height.",
		"TangentNumberOfPlates is calculated as 16.0(tR/tW)^2, where tR is retention time and tW is the tangent peak width.",
		"TailingFactor is calculated as W0.05/2f, where W0.05 is width at 5% height and f is the distance between the leading edge and the peak maximum at 5% height."
	},
	SeeAlso -> {
		"AnalyzeFractions",
		"PlotPeaks",
		"PeakPurity"
	},
	Author -> {
		"kevin.hou",
		"david.hattery",
		"qian",
		"alice",
		"brad"
	},
	Preview->True,
	PreviewOptions -> {"PeakLabels","PeakAssignments"}
}];


(* ::Subsubsection::Closed:: *)
(*AnalyzePeaksOptions*)


DefineUsage[AnalyzePeaksOptions,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzePeaksOptions[data]", "options"},
			Description -> "resolve options to conduct AnalyzePeaks based on input data 'data'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "data",
						Description -> "Object containing data that will be analyzed for peaks.",
						Widget -> Widget[Type->Object,Pattern:>ObjectP[
							{
								Object[Data,Chromatography],Object[Data,ChromatographyMassSpectra],Object[Data,AbsorbanceSpectroscopy],
								Object[Data,MassSpectrometry],Object[Data,NMR],Object[Data,PAGE],Object[Data,TLC],Object[Data,Western],
								Object[Data,FluorescenceSpectroscopy],Object[Data,LuminescenceSpectroscopy],Object[Data,XRayDiffraction],
								Object[Data,IRSpectroscopy],Object[Data,AgaroseGelElectrophoresis],
								Object[Data,DifferentialScanningCalorimetry],Object[Data,MeltingCurve],
								Object[Data,CircularDichroism],Object[Data,DynamicLightScattering],Object[Data,CapillaryGelElectrophoresisSDS]
							}
						]]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for AnalyzePeaks.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		},
		{
			Definition -> {"AnalyzePeaksOptions[protocol]", "{options..}"},
			Description -> "resolve options to conduct AnalyzePeaks based on input protocol.",
			Inputs:>{
				{
					InputName -> "protocol",
					Description -> "Protocol object containing data that will be analyzed.",
					Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{
							Object[Protocol,HPLC],
							Object[Protocol,FPLC],
							Object[Protocol,AbsorbanceSpectroscopy],
							Object[Protocol,AgaroseGelElectrophoresis],
							Object[Protocol,MassSpectrometry],
							Object[Protocol,PAGE],
							Object[Protocol,Western],
							Object[Protocol,FluorescenceSpectroscopy],
							Object[Protocol,LCMS],
							Object[Protocol,LuminescenceSpectroscopy],
							Object[Protocol,NMR],
							Object[Protocol,PowderXRD],
							Object[Protocol,IRSpectroscopy],
							Object[Protocol,DifferentialScanningCalorimetry],
							Object[Protocol,SupercriticalFluidChromatography],
							Object[Protocol,CapillaryGelElectrophoresisSDS]
						}],
						Dereference -> {
							Object[Protocol,HPLC] -> Field[Data],
							Object[Protocol,FPLC] -> Field[Data],
							Object[Protocol,AbsorbanceSpectroscopy] -> Field[Data],
							Object[Protocol,AgaroseGelElectrophoresis] -> Field[Data],
							Object[Protocol,MassSpectrometry] -> Field[Data],
							Object[Protocol,PAGE] -> Field[Data],
							Object[Protocol,Western] -> Field[Data],
							Object[Protocol,FluorescenceSpectroscopy] -> Field[Data],
							Object[Protocol,LCMS] -> Field[Data],
							Object[Protocol,LuminescenceSpectroscopy] -> Field[Data],
							Object[Protocol,NMR] -> Field[Data],
							Object[Protocol,PowderXRD] -> Field[Data],
							Object[Protocol,IRSpectroscopy] -> Field[Data],
							Object[Protocol,DifferentialScanningCalorimetry] -> Field[Data],
							Object[Protocol,SupercriticalFluidChromatography] -> Field[Data],
							Object[Protocol,CapillaryGelElectrophoresisSDS] -> Field[Data]
						}
					]
				}
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for AnalyzePeaks.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		},
		{
			Definition -> {"AnalyzePeaksOptions[xy]", "options"},
			Description -> "resolve options to conduct AnalyzePeaks based on input data 'xy'.",
			Inputs:>{
				{
					InputName -> "xy",
					Description -> "Data points being analyzed for peaks.",
					Widget -> Widget[Type -> Expression, Pattern :> CoordinatesP, Size -> Paragraph]
				}
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for AnalyzePeaks.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzePeaks",
		"AnalyzePeaksPreview",
		"ValidAnalyzePeaksQ"
	},
	Author -> {
		"david.hattery",
		"qian",
		"alice",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*AnalyzePeaksPreview*)


DefineUsage[AnalyzePeaksPreview,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzePeaksPreview[data]", "preview"},
			Description -> "generate a graph as a preview of AnalyzePeaks result.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "data",
						Description -> "Object containing data that will be analyzed for peaks.",
						Widget -> Widget[Type->Object,Pattern:>ObjectP[
							{
								Object[Data,Chromatography],Object[Data,ChromatographyMassSpectra],Object[Data,AbsorbanceSpectroscopy],
								Object[Data,MassSpectrometry],Object[Data,NMR],Object[Data,PAGE],Object[Data,TLC],Object[Data,Western],
								Object[Data,FluorescenceSpectroscopy],Object[Data,LuminescenceSpectroscopy],Object[Data,XRayDiffraction],
								Object[Data,IRSpectroscopy],Object[Data,AgaroseGelElectrophoresis],
								Object[Data,DifferentialScanningCalorimetry],Object[Data,MeltingCurve],
								Object[Data,CircularDichroism],Object[Data,DynamicLightScattering],Object[Data,CapillaryGelElectrophoresisSDS]
							}
						]]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Preview of AnalyzePeaks result.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		},
		{
			Definition -> {"AnalyzePeaksPreview[protocol]", "{preview..}"},
			Description -> "generate a graph as a preview of AnalyzePeaks result.",
			Inputs:>{
				{
					InputName -> "protocol",
					Description -> "Protocol object containing data that will be analyzed.",
					Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{
							Object[Protocol,HPLC],
							Object[Protocol,FPLC],
							Object[Protocol,AbsorbanceSpectroscopy],
							Object[Protocol,AgaroseGelElectrophoresis],
							Object[Protocol,MassSpectrometry],
							Object[Protocol,PAGE],
							Object[Protocol,Western],
							Object[Protocol,FluorescenceSpectroscopy],
							Object[Protocol,LCMS],
							Object[Protocol,LuminescenceSpectroscopy],
							Object[Protocol,NMR],
							Object[Protocol,PowderXRD],
							Object[Protocol,IRSpectroscopy],
							Object[Protocol,DifferentialScanningCalorimetry],
							Object[Protocol,SupercriticalFluidChromatography],
							Object[Protocol,CapillaryGelElectrophoresisSDS]
						}],
						Dereference -> {
							Object[Protocol,HPLC] -> Field[Data],
							Object[Protocol,FPLC] -> Field[Data],
							Object[Protocol,AbsorbanceSpectroscopy] -> Field[Data],
							Object[Protocol,AgaroseGelElectrophoresis] -> Field[Data],
							Object[Protocol,MassSpectrometry] -> Field[Data],
							Object[Protocol,PAGE] -> Field[Data],
							Object[Protocol,Western] -> Field[Data],
							Object[Protocol,FluorescenceSpectroscopy] -> Field[Data],
							Object[Protocol,LCMS] -> Field[Data],
							Object[Protocol,LuminescenceSpectroscopy] -> Field[Data],
							Object[Protocol,NMR] -> Field[Data],
							Object[Protocol,PowderXRD] -> Field[Data],
							Object[Protocol,IRSpectroscopy] -> Field[Data],
							Object[Protocol,DifferentialScanningCalorimetry] -> Field[Data],
							Object[Protocol,SupercriticalFluidChromatography] -> Field[Data],
							Object[Protocol,CapillaryGelElectrophoresisSDS] -> Field[Data]
						}
					]
				}
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Preview of AnalyzePeaks result.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		},
		{
			Definition -> {"AnalyzePeaksPreview[xy]", "preview"},
			Description -> "generate a graph as a preview of AnalyzePeaks result.",
			Inputs:>{
				{
					InputName -> "xy",
					Description -> "Data points being analyzed for peaks.",
					Widget -> Widget[Type -> Expression, Pattern :> CoordinatesP, Size -> Paragraph]
				}
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Preview of AnalyzePeaks result.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzePeaks",
		"AnalyzePeaksOptions",
		"ValidAnalyzePeaksQ"
	},
	Author -> {
		"kevin.hou",
		"david.hattery",
		"qian",
		"alice",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*ValidAnalyzePeaksQ*)


DefineUsage[ValidAnalyzePeaksQ,
{
	BasicDefinitions -> {
		{
			Definition -> {"ValidAnalyzePeaksQ[data]", "tests"},
			Description -> "return an EmeraldTestSummary which contains the test results for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "data",
						Description -> "Object containing data that will be analyzed for peaks.",
						Widget -> Widget[Type->Object,Pattern:>ObjectP[
							{
								Object[Data,Chromatography],Object[Data,ChromatographyMassSpectra],Object[Data,AbsorbanceSpectroscopy],
								Object[Data,MassSpectrometry],Object[Data,NMR],Object[Data,PAGE],Object[Data,TLC],Object[Data,Western],
								Object[Data,FluorescenceSpectroscopy],Object[Data,LuminescenceSpectroscopy],Object[Data,XRayDiffraction],
								Object[Data,IRSpectroscopy],Object[Data,AgaroseGelElectrophoresis],
								Object[Data,DifferentialScanningCalorimetry],Object[Data,MeltingCurve],
								Object[Data,CircularDichroism],Object[Data,DynamicLightScattering],Object[Data,CapillaryGelElectrophoresisSDS]
							}
						]]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs:>{
				{
					OutputName -> "tests",
					Description -> "An EmeraldTestSummary or a single Boolean indicating validity.",
					Pattern :> EmeraldTestSummary| Boolean
				}
			}
		},
		{
			Definition -> {"ValidAnalyzePeaksQ[protocol]", "{tests..}"},
			Description -> "return an EmeraldTestSummary which contains the test results for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs:>{
				{
					InputName -> "protocol",
					Description -> "Protocol object containing data that will be analyzed.",
					Widget -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{
							Object[Protocol,HPLC],
							Object[Protocol,FPLC],
							Object[Protocol,AbsorbanceSpectroscopy],
							Object[Protocol,AgaroseGelElectrophoresis],
							Object[Protocol,MassSpectrometry],
							Object[Protocol,PAGE],
							Object[Protocol,Western],
							Object[Protocol,FluorescenceSpectroscopy],
							Object[Protocol,LCMS],
							Object[Protocol,LuminescenceSpectroscopy],
							Object[Protocol,NMR],
							Object[Protocol,PowderXRD],
							Object[Protocol,IRSpectroscopy],
							Object[Protocol,DifferentialScanningCalorimetry],
							Object[Protocol,SupercriticalFluidChromatography],
							Object[Protocol,CapillaryGelElectrophoresisSDS]
						}],
						Dereference -> {
							Object[Protocol,HPLC] -> Field[Data],
							Object[Protocol,FPLC] -> Field[Data],
							Object[Protocol,AbsorbanceSpectroscopy] -> Field[Data],
							Object[Protocol,AgaroseGelElectrophoresis] -> Field[Data],
							Object[Protocol,MassSpectrometry] -> Field[Data],
							Object[Protocol,PAGE] -> Field[Data],
							Object[Protocol,Western] -> Field[Data],
							Object[Protocol,FluorescenceSpectroscopy] -> Field[Data],
							Object[Protocol,LCMS] -> Field[Data],
							Object[Protocol,LuminescenceSpectroscopy] -> Field[Data],
							Object[Protocol,NMR] -> Field[Data],
							Object[Protocol,PowderXRD] -> Field[Data],
							Object[Protocol,IRSpectroscopy] -> Field[Data],
							Object[Protocol,DifferentialScanningCalorimetry] -> Field[Data],
							Object[Protocol,SupercriticalFluidChromatography] -> Field[Data],
							Object[Protocol,CapillaryGelElectrophoresisSDS] -> Field[Data]
						}
					]
				}
			},
			Outputs:>{
				{
					OutputName -> "tests",
					Description -> "An EmeraldTestSummary or a single Boolean indicating validity.",
					Pattern :> EmeraldTestSummary| Boolean
				}
			}
		},
		{
			Definition -> {"ValidAnalyzePeaksQ[xy]", "tests"},
			Description -> "return an EmeraldTestSummary which contains the test results for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs:>{
				{
					InputName -> "xy",
					Description -> "Data points being analyzed for peaks.",
					Widget -> Widget[Type -> Expression, Pattern :> CoordinatesP, Size -> Paragraph]
				}
			},
			Outputs:>{
				{
					OutputName -> "tests",
					Description -> "An EmeraldTestSummary or a single Boolean indicating validity.",
					Pattern :> EmeraldTestSummary| Boolean
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzePeaks",
		"AnalyzePeaksOptions",
		"AnalyzePeaksPreview"
	},
	Author -> {
		"david.hattery",
		"qian",
		"alice",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*PeakResolution*)


DefineUsage[PeakResolution,
{
	BasicDefinitions -> {
		{"PeakResolution[peaks, pkA, pkB]", "resolution", "returns the resolution between 'pkA' and 'pkB'."}
	},
	Input :> {
		{"peaks", ObjectP[{Object[Analysis,Peaks],Object[Data]}], "Peak data in the form of ObjectP[Object[Analysis,Peaks]] or ObjectP[Object[Data]]."},
		{"pkA", _String | _?NumericQ, "First peak as a peak label in the form of _String or as a number within the peak range in the form of _?NumericQ."},
		{"pkB", _String | _?NumericQ, "Second peak as a peak label in the form of _String or as a number within the peak range in the form of _?NumericQ."}
	},
	Output :> {
		{"resolution", _NumericQ, "The resolution between 'pkA' and 'pkB' as specified in 'peaks'."}
	},
	SeeAlso -> {
		"AnalyzePeaks",
		"PeakEpilog"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsection:: *)
(*Plotting*)


(* ::Subsubsection::Closed:: *)
(*PeakEpilog*)


DefineUsage[PeakEpilog,
{
	BasicDefinitions -> {
		{"PeakEpilog[plotData,peakData]", "epilog_Graphics", "generates an epilog graphic for denoting the information derived from peaks."}
	},
	Input :> {
		{"plotData", {{_?NumericQ, _?NumericQ}..}, "The data being plotted from which the peaks will come."},
		{"peakData", ObjectP[Object[Analysis, Peaks]], "The peak data as determined by peaks matching the peak pattern."}
	},
	Output :> {
		{"epilog", _, "Pictographic documentation of the peaks to be overlaid on a plot."}
	},
	SeeAlso -> {
		"PlotFractions",
		"PlotChromatography"
	},
	Author -> {"scicomp", "brad"}
}];
