(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AdvancedAnalyzePeaks*)


DefineUsage[AdvancedAnalyzePeaks,
{
	BasicDefinitions -> {
		{
			Definition -> {"AdvancedAnalyzePeaks[dataObject]", "analysisObject"},
			Description -> "an updated version of AnalyzePeaks with improved display and additional peak selection capabilities. This definition finds peaks in the provided 'dataObject' and computes their properties. (Beta)",
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
								Object[Data,CircularDichroism],Object[Data,DynamicLightScattering],Object[Data,CapillaryGelElectrophoresisSDS],Object[Data,CoulterCount],
								Object[Data, CapillaryIsoelectricFocusing],Object[Data,FragmentAnalysis]
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
					Pattern :> ObjectP[Object[Analysis,Peaks]]
				}
			}
		},
		{
			Definition -> {"AdvancedAnalyzePeaks[protocol]", "{AnalysisObject..}"},
			Description -> "an updated version of AnalyzePeaks with improved display and additional peak selection capabilities. This definition finds peaks in all data linked to 'protocol'. (Beta)",
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
							Object[Protocol,CapillaryGelElectrophoresisSDS],
							Object[Protocol,CoulterCount],
							Object[Protocol,CapillaryIsoelectricFocusing]
						}]
					]
				}
			},
			Outputs:>{
				{
					OutputName -> "analysisObject",
					Description -> "An analysis object containing information about peaks in the given data, including peak heights and areas.",
					Pattern :> ObjectP[Object[Analysis,Peaks]]
				}
			}
		},
		{
			Definition -> {"AdvancedAnalyzePeaks[numericalData]", "analysisObject"},
			Description -> "an updated version of AnalyzePeaks with improved display and additional peak selection capabilities. This definition finds peaks in raw numeric data. (Beta)",
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
					Pattern :> ObjectP[Object[Analysis,Peaks]]
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
	Author -> {"brad", "hiren.patel"},
	Preview->True,
	PreviewOptions -> {"PeakLabels","PeakAssignments","Include","Exclude", "AbsoluteThreshold","Domain","RelativeTreshold","WidthThreshold","Split", "ManualPeakRanges", "ManualPeakPositions","ManualPeakBaselines", "ManualPeakAssignments"}
}];


(* ::Subsubsection::Closed:: *)
(*AdvancedAnalyzePeaksOptions*)


DefineUsage[AdvancedAnalyzePeaksOptions,
{
	BasicDefinitions -> {
		{
			Definition -> {"AdvancedAnalyzePeaksOptions[data]", "options"},
			Description -> "resolve options to conduct AdvancedAnalyzePeaks based on input data 'data'.",
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
								Object[Data,CircularDichroism],Object[Data,DynamicLightScattering],Object[Data,CapillaryGelElectrophoresisSDS],Object[Data,CoulterCount],
								Object[Data, CapillaryIsoelectricFocusing],Object[Data,FragmentAnalysis]
							}
						]]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for AdvancedAnalyzePeaks.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		},
		{
			Definition -> {"AdvancedAnalyzePeaksOptions[protocol]", "{options..}"},
			Description -> "resolve options to conduct AdvancedAnalyzePeaks based on input protocol.",
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
							Object[Protocol,CapillaryGelElectrophoresisSDS],
							Object[Protocol,CoulterCount],
							Object[Protocol,CapillaryIsoelectricFocusing]
						}]
					]
				}
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for AdvancedAnalyzePeaks.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		},
		{
			Definition -> {"AdvancedAnalyzePeaksOptions[xy]", "options"},
			Description -> "resolve options to conduct AdvancedAnalyzePeaks based on input data 'xy'.",
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
					Description -> "Resolved options for AdvancedAnalyzePeaks.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		}
	},
	SeeAlso -> {
		"AdvancedAnalyzePeaks",
		"AdvancedAnalyzePeaksPreview",
		"ValidAdvancedAnalyzePeaksQ"
	},
	Author -> {"brad", "hiren.patel"}
}];


(* ::Subsubsection::Closed:: *)
(*AdvancedAnalyzePeaksPreview*)


DefineUsage[AdvancedAnalyzePeaksPreview,
{
	BasicDefinitions -> {
		{
			Definition -> {"AdvancedAnalyzePeaksPreview[data]", "preview"},
			Description -> "generate a graph as a preview of AdvancedAnalyzePeaks result.",
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
								Object[Data,CircularDichroism],Object[Data,DynamicLightScattering],Object[Data,CapillaryGelElectrophoresisSDS],Object[Data,CoulterCount],
								Object[Data, CapillaryIsoelectricFocusing],Object[Data,FragmentAnalysis]
							}
						]]
					},
					IndexName -> "Input Data"
				]
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Preview of AdvancedAnalyzePeaks result.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		},
		{
			Definition -> {"AdvancedAnalyzePeaksPreview[protocol]", "{preview..}"},
			Description -> "generate a graph as a preview of AdvancedAnalyzePeaks result.",
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
							Object[Protocol,CapillaryGelElectrophoresisSDS],
							Object[Protocol,CoulterCount],
							Object[Protocol,CapillaryIsoelectricFocusing]
						}]
					]
				}
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Preview of AdvancedAnalyzePeaks result.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		},
		{
			Definition -> {"AdvancedAnalyzePeaksPreview[xy]", "preview"},
			Description -> "generate a graph as a preview of AdvancedAnalyzePeaks result.",
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
					Description -> "Preview of AdvancedAnalyzePeaks result.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		}
	},
	SeeAlso -> {
		"AdvancedAnalyzePeaks",
		"AdvancedAnalyzePeaksOptions",
		"ValidAdvancedAnalyzePeaksQ"
	},
	Author -> {"brad", "hiren.patel"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidAdvancedAnalyzePeaksQ*)


DefineUsage[ValidAdvancedAnalyzePeaksQ,
{
	BasicDefinitions -> {
		{
			Definition -> {"ValidAdvancedAnalyzePeaksQ[data]", "tests"},
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
								Object[Data,CircularDichroism],Object[Data,DynamicLightScattering],Object[Data,CapillaryGelElectrophoresisSDS],Object[Data,CoulterCount],
								Object[Data, CapillaryIsoelectricFocusing],Object[Data,FragmentAnalysis]
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
			Definition -> {"ValidAdvancedAnalyzePeaksQ[protocol]", "{tests..}"},
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
							Object[Protocol,CapillaryGelElectrophoresisSDS],
							Object[Protocol,CoulterCount],
							Object[Protocol,CapillaryIsoelectricFocusing]
						}]
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
			Definition -> {"ValidAdvancedAnalyzePeaksQ[xy]", "tests"},
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
		"AdvancedAnalyzePeaks",
		"AdvancedAnalyzePeaksOptions",
		"AdvancedAnalyzePeaksPreview"
	},
	Author -> {"brad", "hiren.patel"}
}];
