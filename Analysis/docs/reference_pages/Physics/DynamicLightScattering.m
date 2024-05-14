(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*AnalyzeDynamicLightScattering*)


DefineUsageWithCompanions[AnalyzeDynamicLightScattering,
{
	BasicDefinitions -> {
		{
			Definition -> {"AnalyzeDynamicLightScattering[DynamicLightScatteringData]", "object"},
			Description -> "Calculates the key scientific parameters derived from the dynamic light scattering protocol, including Z-average diameter, second virial coefficient (b22), diffusion interation parameter (kD), and Kirkwood Buff integral (G22).",
			Inputs :> {
				{
					InputName -> "DynamicLightScatteringData",
					Description -> "Data containing dynamic light scattering correlation curves to be analyzed.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Data, DynamicLightScattering]}], ObjectTypes -> {Object[Data, DynamicLightScattering]}]
				}
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The object containing analysis for the scientific parameters derived from the dynamic light scattering correlation curves.",
					Pattern :> ObjectP[Object[Analysis, DynamicLightScattering]]
				}
			}
		},
		{
			Definition -> {"AnalyzeDynamicLightScattering[DynamicLightScatteringProtocol]", "object"},
			Description -> "Analyzes all the data in the given protocol.",
			Inputs :> {
				{
					InputName -> "DynamicLightScatteringProtocol",
					Description -> "Protocol with data objects containing dynamic light scattering correaltion curves to be analyzed.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Protocol, DynamicLightScattering]}], ObjectTypes -> {Object[Protocol, DynamicLightScattering]}]
				}
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The object containing the analysis of scientific parameters derived from the dynamic light scattering correlation curves.",
					Pattern :> ObjectP[Object[Analysis, DynamicLightScattering]]
				}
			}
		},
		{
			Definition -> {"AnalyzeDynamicLightScattering[MeltingCurveData]", "object"},
			Description -> "Calculates the Z-average diameter, polydispersity index, and diffusion coefficient for MeltingCurve data objects generated from Object[Protocol, ThermalShift].",
			Inputs :> {
				{
					InputName -> "MeltingCurveData",
					Description -> "Data containing dynamic light scattering correlation curves to be analyzed.",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Object[Data, DynamicLightScattering]}], ObjectTypes -> {Object[Data, DynamicLightScattering]}]
				}
			},
			Outputs :> {
				{
					OutputName -> "object",
					Description -> "The object containing analysis for the scientific parameters derived from the dynamic light scattering correlation curves.",
					Pattern :> ObjectP[Object[Analysis, DynamicLightScattering]]
				}
			}
		}
	},
	MoreInformation -> {
		"Two particle sizing methods are available: the instrument calculation and the cumulants method based on International Organization of Standardization (ISO) 22414:2017",
		"The cumulants method fits the decaying correlation curves with a single exponential that contains a polynomial in the exponent. Regarding the polynomial, the first order term represents the mean particle size, the second represents the variance, the third represents the skewness.",
		"Correlation curves can be excluded from the analysss if their initial values are too low, indicating improper sample loading, or if the correlation curve does not converge near 0, indicating significant noise.",
		"The diffusion coefficient is estimated by regressing the diffusion coefficient versus protein concentration. The ratio of the slope to y-intercept is the diffusion interaction parameter.",
		"The second virial coefficient is estimated by regressing the optical constant times the concentration divided by the Rayleigh ratio versus concentration. Half of the slope is the second virial coefficient.",
		"The Kirkwood Buff integral is estimated by regressing the Rayleigh ratio divided by the optical constant versus a first and second order coefficient term. The coefficient to the second order term divided by the molecular weight is the Kirkwood Buff integral."
	},
	SeeAlso -> {
		"PlotDynamicLightScattering",
		"DynamicLightScatteringLoading",
		"PlotDynamicLightScatteringLoading"
	},
	Author -> {
		"scicomp",
		"derek.machalek",
		"tommy.harrelson"
	},
	Preview->True
}];
