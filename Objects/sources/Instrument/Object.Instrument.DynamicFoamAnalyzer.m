(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument,DynamicFoamAnalyzer],{
	Description->"An object for a dynamic foam analyzer instrument. The instrument allows for the characterization of foam generation and decay for samples over time. Foam characteristics that can be measured include the foamability of the sample, the sizes and distributions of foam bubbles, and the liquid content and drainage of the foam at various positions along the foam column.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		DetectionMethods->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],DetectionMethods]],
			Pattern:>{FoamDetectionMethodP..},
			Description->"The type of foam detection method(s) that can be performed by this instrument. The foam detection methods are the Height Method, Liquid Conductivity Method, and Imaging Method.",
			Category->"Instrument Specifications"
		},
		MinTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"The minimum temperature that the instrument can incubate the samples inside the columns at, during the dynamic foam analysis experiment.",
			Category->"Operating Limits"
		},
		MaxTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern:>GreaterP[0*Kelvin],
			Description->"The maximum temperature that the instrument can incubate the samples inside the columns at, during the dynamic foam analysis experiment.",
			Category->"Operating Limits"
		},
		MinColumnHeight->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinColumnHeight]],
			Pattern:>GreaterEqualP[0*Millimeter],
			Description->"The minimum height of the foam column that can be run on the instrument.",
			Category->"Operating Limits"
		},
		MaxColumnHeight->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxColumnHeight]],
			Pattern:>GreaterP[0*Millimeter],
			Description->"The maximum height of the foam column that can be run on the instrument.",
			Category->"Operating Limits"
		},
		MinColumnDiameter->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinColumnDiameter]],
			Pattern:>GreaterEqualP[0*Millimeter],
			Description->"The minimum outer column diameter of the foam column that can be run on the instrument.",
			Category->"Operating Limits"
		},
		MaxColumnDiameter->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxColumnDiameter]],
			Pattern:>GreaterP[0*Millimeter],
			Description->"The maximum outer column diameter of the foam column that can be run on the instrument.",
			Category->"Operating Limits"
		},
		AgitationTypes->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],AgitationTypes]],
			Pattern:>{FoamAgitationTypeP..},
			Description->"The types of agitation that can be used by this instrument during foam generation.",
			Category->"Instrument Specifications"
		},
		AvailableGases->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],AvailableGases]],
			Pattern:>{FoamSpargeGasP..},
			Description->"The gases that can be used for sparging the sample during foam generation.",
			Category->"Instrument Specifications"
		},
		MinGasPressure->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinGasPressure]],
			Pattern:>GreaterEqualP[0*Bar],
			Description->"The minimum pressure at which the external gas can be introduced for sparging the sample during foam generation.",
			Category->"Operating Limits"
		},
		MaxGasPressure->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxGasPressure]],
			Pattern:>GreaterP[0*Bar],
			Description->"The maximum pressure at which the external gas can be introduced for sparging the sample during foam generation.",
			Category->"Operating Limits"
		},
		MinFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinFlowRate]],
			Pattern:>GreaterEqualP[(0*Liter)/Minute],
			Description->"The minimum flow rate at which the gas can be introduced for sparging the sample during foam generation.",
			Category->"Operating Limits"
		},
		MaxFlowRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxFlowRate]],
			Pattern:>GreaterP[(0*Liter)/Minute],
			Description->"The maximum flow rate at which the gas can be introduced for sparging the sample during foam generation.",
			Category->"Operating Limits"
		},
		MinStirRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinStirRate]],
			Pattern:>GreaterEqualP[0*RPM],
			Description->"The minimum rate at which the stir blade can be rotated in order to stir and agitate the sample during foam generation.",
			Category->"Operating Limits"
		},
		MaxStirRate->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxStirRate]],
			Pattern:>GreaterP[0*RPM],
			Description->"The maximum rate at which the stir blade can be rotated in order to stir and agitate the sample during foam generation.",
			Category->"Operating Limits"
		},
		MinOscillationPeriod->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinOscillationPeriod]],
			Pattern:>GreaterEqualP[0 Second],
			Description->"The minimum oscillation period setting for the stirring blade that can be used during foam generation in this instrument.",
			Category->"Operating Limits"
		},
		MaxOscillationPeriod->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxOscillationPeriod]],
			Pattern:>GreaterP[0 Second],
			Description->"The maximum oscillation period setting for the stirring blade that can be used during foam generation in this instrument.",
			Category->"Operating Limits"
		},
		IlluminationWavelengths->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],IlluminationWavelengths]],
			Pattern:>{Alternatives[469 Nanometer,850 Nanometer]..},
			Description->"The types of wavelengths that can be used to illuminate the sample column during the course of the experiment.", (*TODO: fill in once I have numbers*)
			Category->"Instrument Specifications"
		},
		MinFoamHeightSamplingFrequency->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinFoamHeightSamplingFrequency]],
			Pattern:>GreaterEqualP[0*Hertz],
			Description->"The minimum data sampling frequency that can be performed by the instrument for foam height analysis, where the foam and liquid heights are monitored over time.",
			Category->"Operating Limits"
		},
		MaxFoamHeightSamplingFrequency->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxFoamHeightSamplingFrequency]],
			Pattern:>GreaterP[0*Hertz],
			Description->"The maximum data sampling frequency that can be performed by the instrument for foam height analysis, where the foam and liquid heights are monitored over time.",
			Category->"Operating Limits"
		}
	}
}];