(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument,Osmometer],{
	Description->"A device for measurement of the osmolality of a solution using the vapor pressure osmometry method, by determining dew point depression.
	The instrument measures the dew point depression, a colligative property, of the sample solution and uses internal calibration to convert this to solution osmolality.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		(*Operating Limits*)
		MinOperatingTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinOperatingTemperature]],
			Pattern:>GreaterEqualP[0 Kelvin],
			Description->"The minimum temperature at which the osmometer is capable of producing a reliable osmolality measurement.",
			Category->"Operating Limits"
		},
		MaxOperatingTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxOperatingTemperature]],
			Pattern:>GreaterEqualP[0 Kelvin],
			Description->"The maximum temperature at which the osmometer is capable of producing a reliable osmolality measurement.",
			Category->"Operating Limits"
		},
		DedicatedSolvent->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],DedicatedSolvent]],
			Pattern:>BooleanP,
			Description->"Indicates if the instrument can only be used with one specific solvent.",
			Category->"Operating Limits"
		},
		(*Instrument Specifications*)
		OsmolalityMethod->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],OsmolalityMethod]],
			Pattern:>OsmolalityMethodP,
			Description->"The experimental technique or principle used by this instrument to determine the osmolality of samples.",
			Category->"Instrument Specifications"
		},
		MinOsmolality->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinOsmolality]],
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Description->"The minimum osmolality that the instrument is capable of measuring.",
			Category->"Instrument Specifications"
		},
		MaxOsmolality->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxOsmolality]],
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Description->"The maximum osmolality that the instrument is capable of measuring.",
			Category->"Instrument Specifications"
		},
		MinSampleVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MinSampleVolume]],
			Pattern:>GreaterEqualP[0 Microliter],
			Description->"The minimum volume of sample that the instrument is capable of performing an osmolality measurement on.",
			Category->"Instrument Specifications"
		},
		MaxSampleVolume->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MaxSampleVolume]],
			Pattern:>GreaterEqualP[0 Microliter],
			Description->"The maximum volume of sample that the instrument is capable of performing an osmolality measurement on.",
			Category->"Instrument Specifications"
		},
		MeasurementChamberMinTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MeasurementChamberMinTemperature]],
			Pattern:>GreaterEqualP[0 Kelvin],
			Description->"The minimum temperature that the osmometer can measure the osmolality of a sample at.",
			Category->"Instrument Specifications"
		},
		MeasurementChamberMaxTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MeasurementChamberMaxTemperature]],
			Pattern:>GreaterEqualP[0 Kelvin],
			Description->"The maximum temperature that the osmometer can measure the osmolality of a sample at.",
			Category->"Instrument Specifications"
		},
		MeasurementTime->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],MeasurementTime]],
			Pattern:>GreaterEqualP[0 Second],
			Description->"The total amount of time taken for the instrument to return an osmolality reading after the sample is loaded into the instrument.",
			Category->"Instrument Specifications"
		},
		EquilibrationTime->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],EquilibrationTime]],
			Pattern:>GreaterEqualP[0 Second],
			Description->"The amount of time taken for the measurement chamber to equilibrate after the sample is loaded into the instrument and prior to osmolality measurement.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityResolution->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerOsmolalityResolution]],
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Description->"The minimum change in sample osmolality that leads to a change in the displayed value, described as a constant value over the instrument measurement range. For resolution that is variable over the measurement range, see ManufacturerOsmolalityResolutionScoped.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityResolutionScoped->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerOsmolalityResolutionScoped]],
			Pattern:>{GreaterEqualP[0 Millimole/Kilogram],GreaterEqualP[0 Millimole/Kilogram]},
			Description->"The minimum change in sample osmolality that leads to a change in the displayed value, described by values at various points over the instrument measurement range. For resolution that is constant over the measurement range, see ManufacturerOsmolalityResolution.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityAccuracy->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerOsmolalityAccuracy]],
			Pattern:>GreaterEqualP[0 Percent],
			Description->"The deviation of an osmolality measurement performed by the instrument from its true value, described as a constant value over the instrument measurement range. For accuracy that is variable over the measurement range, see ManufacturerOsmolalityAccuracyScoped.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityAccuracyScoped->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerOsmolalityAccuracyScoped]],
			Pattern:>{GreaterEqualP[0 Millimole/Kilogram],GreaterEqualP[0 Percent]},
			Description->"The deviation of an osmolality measurement performed by the instrument from its true value, described by values at various points over the instrument measurement range. For accuracy that is constant over the measurement range, see ManufacturerOsmolalityAccuracy.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityRepeatability->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerOsmolalityRepeatability]],
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Description->"The variability in osmolality measurements performed by the instrument, described as a constant value over the instrument measurement range. For repeatability that is variable over the measurement range, see ManufacturerOsmolalityRepeatabilityScoped.",
			Category->"Instrument Specifications"
		},
		ManufacturerOsmolalityRepeatabilityScoped->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerOsmolalityRepeatabilityScoped]],
			Pattern:>{GreaterEqualP[0 Millimole/Kilogram],GreaterEqualP[0 Millimole/Kilogram]},
			Description->"The variability in osmolality measurements performed by the instrument, described by values at various points over the instrument measurement range. For repeatability that is constant over the measurement range, see ManufacturerOsmolalityRepeatability.",
			Category->"Instrument Specifications"
		},
		CustomCalibrants->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],CustomCalibrants]],
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
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],ManufacturerCalibrantOsmolalities]],
			Pattern:>GreaterEqualP[0 Millimole/Kilogram],
			Description->"For each member of ManufacturerCalibrants, the osmolality of the solution.",
			Category->"Instrument Specifications"
		},
		(*Cleaning*)
		CustomCleaningSolution->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],CustomCleaningSolution]],
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
		},
		(*Cleaning containers*)
		CleaningSolutionContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Vessel],
			Description->"The container connected to the instrument used to contain the cleaning solution.",
			Category->"Instrument Specifications",
			Developer->True
		},
		(*Desiccant Cartridge*)
		DesiccantCartridge->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Cartridge,Desiccant],
			Description->"The desiccant cartridge installed in the instrument used to dry the measurement chamber between readings.",
			Category->"Instrument Specifications",
			Developer->True
		}
	}
}]