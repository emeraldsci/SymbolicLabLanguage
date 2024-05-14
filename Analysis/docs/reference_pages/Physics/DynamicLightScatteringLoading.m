(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeDynamicLightScattering*)


DefineUsage[AnalyzeDynamicLightScatteringLoading,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeDynamicLightScatteringLoading[dynamicLightScatteringProtocol]", "object"},
			Description -> "identifies the dynamic light scattering data objects of the protocol with properly loaded samples during experimentation. Thresholding analysis of correlation curve data is used to heuristically group samples that likely failed loading of the instrument.",
			Inputs :> {
				{
					InputName -> "dynamicLightScatteringProtocol",
					Description -> "Protocol containing dynamic light scattering data to be analyzed.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Protocol, DynamicLightScattering], Object[Protocol, ThermalShift]}], ObjectTypes -> {Object[Protocol, DynamicLightScattering], Object[Protocol, ThermalShift]}]
				}
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The object containing analysis selecting dynamic light scattering data with properly loaded samples.",
					Pattern :> ObjectP[Object[Analysis, DynamicLightScatteringLoading]]
				}
			}
		}

	},
	MoreInformation -> {
		"Loading of the instrument has a known failure rate that is relatively high on the basis of the instrument properties themselves.",
		"Correlation curves at concentrations below 0.1 mg/ml may have correlations starting outside of the range from CorrelationThreshold to CorrelationMaximum. As a result they are not considered improperly loaded.",
		"Data objects that contain many correlation curves, such as those with AssayTypes B22kD, G22, and IsothermalStability, allow for 2 improperly loaded curves before the entire data object is considered improperly loaded."
	},
	SeeAlso -> {
		"PlotDynamicLightScatteringLoading",
		"AnalyzeDynamicLightScattering"
	},
	Author -> {
		"derek.machalek",
		"brad"
	},
	Preview->True
}];

(* ::Subsubsection::Closed:: *)
(*AnalyzeDynamicLightScatteringLoadingOptions*)


DefineUsage[AnalyzeDynamicLightScatteringLoadingOptions,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeDynamicLightScatteringLoadingOptions[dynamicLightScatteringProtocol]", "options"},
			Description -> "resolve options to conduct AnalyzeDynamicLightScatteringLoading based on input 'dynamicLightScatteringProtocol'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "dynamicLightScatteringProtocol",
						Description -> "Protocol containing DynamicLightScattering data to be sorted.",
						Widget -> Widget[Type->Expression, Pattern:>ObjectP[Object[Protocol, ThermalShift]]|ObjectP[Object[Protocol, DynamicLightScattering]],
						PatternTooltip->"A protocol containing Object[Data, MeltingPoint] or Object[Data, DynamicLightScattering] values to be evaluated as properly loaded.", Size->Paragraph]
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "options",
					Description -> "Resolved options for AnalyzeDynamicLightScatteringLoading.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzeDynamicLightScatteringLoading",
		"AnalyzeDynamicLightScatteringLoadingPreveiw",
		"ValidAnalyzeDynamicLightScatteringLoadingQ"
	},
	Author -> {
		"scicomp",
		"derek.machalek",
  		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*AnalyzeDynamicLightScatteringLoadingPreveiw*)

DefineUsage[AnalyzeDynamicLightScatteringLoadingPreview,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeDynamicLightScatteringLoadingPreview[dynamicLightScatteringProtocol]", "preview"},
			Description -> "generate a graph as a preview AnalyzeDynamicLightScatteringLoading based on input 'dynamicLightScatteringProtocol'.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "dynamicLightScatteringProtocol",
						Description -> "Protocol containing DynamicLightScattering data to be sorted.",
						Widget -> Widget[Type->Expression, Pattern:>ObjectP[Object[Protocol, ThermalShift]]|ObjectP[Object[Protocol, DynamicLightScattering]],
						PatternTooltip->"A protocol containing Object[Data, MeltingPoint] or Object[Data, DynamicLightScattering] values to be evaluated as properly loaded.", Size->Paragraph]
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "preview",
					Description -> "Preview of AnalyzeDynamicLightScatteringLoading.",
					Pattern :> ValidGraphicsP[] | Null
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzeDynamicLightScatteringLoading",
		"AnalyzeDynamicLightScatteringLoadingOptions",
		"ValidAnalyzeDynamicLightScatteringLoadingQ"
	},
	Author -> {
		"derek.machalek",
  		"brad"
	}
}];

(* ::Subsubsection::Closed:: *)
(*AnalyzeDynamicLightScatteringLoadingPreveiw*)

DefineUsage[ValidAnalyzeDynamicLightScatteringLoadingQ,
{
	BasicDefinitions -> {
		{
			Definition -> {"ValidAnalyzeDynamicLightScatteringLoadingQ[dynamicLightScatteringProtocol]", "tests"},
			Description -> "return an EmeraldTestSummary which contains the test results for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "dynamicLightScatteringProtocol",
						Description -> "Protocol containing DynamicLightScattering data to be sorted.",
						Widget -> Widget[Type->Expression, Pattern:>ObjectP[Object[Protocol, ThermalShift]]|ObjectP[Object[Protocol, DynamicLightScattering]],
						PatternTooltip->"A protocol containing Object[Data, MeltingPoint] or Object[Data, DynamicLightScattering] values to be evaluated as properly loaded..", Size->Paragraph]
					},
					IndexName -> "main input"
				]
			},
			Outputs:>{
				{
					OutputName -> "tests",
					Description -> "An EmeraldTestSummary or a single Boolean indicating validity.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		}
	},
	SeeAlso -> {
		"AnalyzeDynamicLightScatteringLoading",
		"AnalyzeDynamicLightScatteringLoadingOptions",
		"AnalyzeDynamicLightScatteringLoadingPreview"
	},
	Author -> {
		"derek.machalek",
  		"brad"
	}
}];
