(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument,DynamicFoamAnalyzer],{
	Description->"A model for a dynamic foam analyzer instrument. The instrument allows for the characterization of foam generation and decay for samples over time. Foam characteristics that can be measured include the foamability of the sample, the sizes and distributions of foam bubbles, and the liquid content and drainage of the foam at various positions along the foam column.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		DetectionMethods->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FoamDetectionMethodP,
			Description->"The type of foam detection method(s) that can be performed by this instrument. The foam detection methods are the Height Method, Liquid Conductivity Method, and Imaging Method.",
			Category->"Instrument Specifications"
		},

		(* --- agitation --- *)
		MinTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The minimum temperature that the instrument can incubate the samples inside the columns at, during the dynamic foam analysis experiment.",
			Category->"Operating Limits"
		},
		MaxTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Kelvin],
			Units->Celsius,
			Description->"The maximum temperature that the instrument can incubate the samples inside the columns at, during the dynamic foam analysis experiment.",
			Category->"Operating Limits"
		},
		MinColumnHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Millimeter],
			Units->Millimeter,
			Description->"The minimum height of the foam column that can be run on the instrument.",
			Category->"Operating Limits"
		},
		MaxColumnHeight->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The maximum height of the foam column that can be run on the instrument.",
			Category->"Operating Limits"
		},
		MinColumnDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Millimeter],
			Units->Millimeter,
			Description->"The minimum outer column diameter of the foam column that can be run on the instrument.",
			Category->"Operating Limits"
		},
		MaxColumnDiameter->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Millimeter],
			Units->Millimeter,
			Description->"The maximum outer column diameter of the foam column that can be run on the instrument.",
			Category->"Operating Limits"
		},
		AgitationTypes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FoamAgitationTypeP,
			Description->"The types of agitation that can be used by this instrument during foam generation.",
			Category->"Instrument Specifications"
		},
		AvailableGases->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FoamSpargeGasP,
			Description->"The gases that can be used for sparging the sample during foam generation.",
			Category->"Instrument Specifications"
		},
		MinGasPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Bar],
			Units->Bar,
			Description->"The minimum manufacturer-approved gas pressure of the external gas source for the sparging gas used by the instrument.",
			Category->"Operating Limits"
		},
		MaxGasPressure->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Bar],
			Units->Bar,
			Description->"The maximum manufacturer-approved gas pressure of the external gas source for the sparging gas used by the instrument.",
			Category->"Operating Limits"
		},
		MinFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Liter)/Minute],
			Units->Liter/Minute,
			Description->"The minimum flow rate at which the gas can be introduced for sparging the sample during foam generation.",
			Category->"Operating Limits"
		},
		MaxFlowRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[(0*Liter)/Minute],
			Units->Liter/Minute,
			Description->"The maximum flow rate at which the gas can be introduced for sparging the sample during foam generation.",
			Category->"Operating Limits"
		},
		MinStirRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*RPM],
			Units->RPM,
			Description->"The minimum rate at which the stir blade can be rotated in order to stir and agitate the sample during foam generation.",
			Category->"Operating Limits"
		},
		MaxStirRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*RPM],
			Units->RPM,
			Description->"The maximum rate at which the stir blade can be rotated in order to stir and agitate the sample during foam generation.",
			Category->"Operating Limits"
		},
		MinOscillationPeriod->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"The minimum oscillation period setting for the stirring blade that can be used during foam generation in this instrument.", (*TODO: fill in*)
			Category->"Operating Limits"
		},
		MaxOscillationPeriod->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Second],
			Units->Second,
			Description->"The maximum oscillation period setting for the stirring blade that can be used during foam generation in this instrument.",(*TODO: fill in*)
			Category->"Operating Limits"
		},

		(* --- illumination --- *)
		IlluminationWavelengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>Alternatives[469 Nanometer,850 Nanometer],
			Units->Nanometer,
			Description->"The types of wavelengths that can be used to illuminate the sample column during the course of the experiment.", (*TODO: fill in once I have numbers*)
			Category->"Instrument Specifications"
		},
		MinFoamHeightSamplingFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Unit/Second],
			Units->Unit/Second,
			Description->"The minimum data sampling frequency that can be performed by the instrument for foam height analysis, where the foam and liquid heights are monitored over time.",
			Category->"Operating Limits"
		},
		MaxFoamHeightSamplingFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Unit/Second],
			Units->Unit/Second,
			Description->"The maximum data sampling frequency that can be performed by the instrument for foam height analysis, where the foam and liquid heights are monitored over time.",
			Category->"Operating Limits"
		}
	}
}];