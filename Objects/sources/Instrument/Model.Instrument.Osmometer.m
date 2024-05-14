(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument,Osmometer],{
	Description->"A model describing a device for measurement of the osmolality of a solution using the vapor pressure osmometry method, by determining dew point depression.
	The instrument measures the dew point depression, a colligative property, of the sample solution and uses internal calibration to convert this to solution osmolality.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(*Operating Limits*)
		MinOperatingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The minimum temperature at which the osmometer is capable of producing a reliable osmolality measurement.",
			Category->"Operating Limits"
		},
		MaxOperatingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The maximum temperature at which the osmometer is capable of producing a reliable osmolality measurement.",
			Category->"Operating Limits"
		},
		DedicatedSolvent->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the instrument can only be used with one specific solvent.",
			Category->"Operating Limits"
		},
		(*Instrument Specifications*)
		OsmolalityMethod->{
			Format->Single,
			Class->Expression,
			Pattern:>OsmolalityMethodP,
			Description->"The experimental technique or principle used by this instrument to determine the osmolality of samples.",
			Category->"Instrument Specifications"
		},
		MinOsmolality->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Units->Millimole/Kilogram,
			Description->"The minimum osmolality that the instrument is capable of measuring.",
			Category->"Instrument Specifications"
		},
		MaxOsmolality->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Units->Millimole/Kilogram,
			Description->"The maximum osmolality that the instrument is capable of measuring.",
			Category->"Instrument Specifications"
		},
		MinSampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"The minimum volume of sample that the instrument is capable of performing an osmolality measurement on.",
			Category->"Instrument Specifications"
		},
		MaxSampleVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Microliter],
			Units->Microliter,
			Description->"The maximum volume of sample that the instrument is capable of performing an osmolality measurement on.",
			Category->"Instrument Specifications"
		},
		MeasurementChamberMinTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The minimum temperature that the osmometer can measure the osmolality of a sample at.",
			Category->"Instrument Specifications"
		},
		MeasurementChamberMaxTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Kelvin],
			Units->Celsius,
			Description->"The maximum temperature that the osmometer can measure the osmolality of a sample at.",
			Category->"Instrument Specifications"
		},
		MeasurementTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"The total amount of time taken for the instrument to return an osmolality reading after the sample is loaded into the instrument.",
			Category->"Instrument Specifications"
		},
		EquilibrationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Second],
			Units->Second,
			Description->"The amount of time taken for the measurement chamber to equilibrate after the sample is loaded into the instrument and prior to osmolality measurement.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityResolution->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Units->Millimole/Kilogram,
			Description->"The minimum change in sample osmolality that leads to a change in the displayed value, described as a constant value over the instrument measurement range. For resolution that is variable over the measurement range, see ManufacturerOsmolalityResolutionScoped.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityResolutionScoped->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterEqualP[0 Millimole/Kilogram],GreaterEqualP[0 Millimole/Kilogram]},
			Units->{Millimole/Kilogram,Millimole/Kilogram},
			Headers->{"OsmolalityMeasurement","Resolution"},
			Description->"The minimum change in sample osmolality that leads to a change in the displayed value, described by values at various points over the instrument measurement range. For resolution that is constant over the measurement range, see ManufacturerOsmolalityResolution.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityAccuracy->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Units->Millimole/Kilogram,
			Description->"The deviation of an osmolality measurement performed by the instrument from its true value, described as a constant value over the instrument measurement range. For accuracy that is variable over the measurement range, see ManufacturerOsmolalityAccuracyScoped.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityAccuracyScoped->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterEqualP[0 Millimole/Kilogram],GreaterEqualP[0 Percent]},
			Units->{Millimole/Kilogram,Percent},
			Headers->{"OsmolalityMeasurement","Accuracy"},
			Description->"The deviation of an osmolality measurement performed by the instrument from its true value, described by values at various points over the instrument measurement range. For accuracy that is constant over the measurement range, see ManufacturerOsmolalityAccuracy.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityRepeatability->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Units->Millimole/Kilogram,
			Description->"The variability in osmolality measurements performed by the instrument, described as a constant value over the instrument measurement range. For repeatability that is variable over the measurement range, see ManufacturerOsmolalityRepeatabilityScoped.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityRepeatabilityScoped->{
			Format->Multiple,
			Class->{Real,Real},
			Pattern:>{GreaterEqualP[0 Millimole/Kilogram],GreaterEqualP[0 Millimole/Kilogram]},
			Units->{Millimole/Kilogram,Millimole/Kilogram},
			Headers->{"OsmolalityMeasurement","Repeatability"},
			Description->"The variability in osmolality measurements performed by the instrument, described by values at various points over the instrument measurement range. For repeatability that is constant over the measurement range, see ManufacturerOsmolalityRepeatability.",
			Category->"Instrument Specifications"
		},
		(*Calibration*)
		CustomCalibrants->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the instrument can be calibrated using user specified calibrants.",
			Category->"Instrument Specifications"
		},
		ManufacturerCalibrants->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The solutions of known osmolality used by the instrument to determine the function to convert from raw measurement to osmolality.",
			Category->"Instrument Specifications"
		},
		ManufacturerCalibrantOsmolalities->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Units->Millimole/Kilogram,
			Description->"For each member of ManufacturerCalibrants, the osmolality of the solution.",
			Category->"Instrument Specifications",
			IndexMatching->ManufacturerCalibrants
		},
		(*Cleaning*)
		CustomCleaningSolution->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the instrument can be cleaned using user specified cleaning solution.",
			Category->"Instrument Specifications"
		},
		ManufacturerCleaningSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"The solution used to remove debris from the thermocouple head.",
			Category->"Instrument Specifications"
		}
	}
}]