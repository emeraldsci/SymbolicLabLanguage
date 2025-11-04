(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, pHMeter], {
	Description->"Device for high precision measurement of pH.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Resolution -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Resolution]],
			Pattern :> GreaterP[0],
			Description -> "The smallest change in pH that corresponds to a change in recorded value of the meter.",
			Category -> "Instrument Specifications"
		},
		ManufacturerRepeatability -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],ManufacturerRepeatability]],
			Pattern :> GreaterP[0],
			Description -> "The pH meter ability to show consistent results under the same conditions according to the manufacturer.",
			Category -> "Instrument Specifications"
		},
		Probe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, pHProbe][pHMeter],
			Description -> "The first part associated with this instrument that directly immerses into samples for measurement.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		SecondaryProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,pHProbe][pHMeter],
			Description -> "The second part associated with this instrument that directly immerses into samples for measurement.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TertiaryProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, pHProbe][pHMeter],
			Description -> "The third part associated with this instrument that directly immerses into samples for measurement.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		InUseProbeHolder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The probe holder for holding the one probe that is actively being used in the current experiment.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		PermanentProbeHolder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The probe holder for storing all the probe(s) that are connected to this pH Meter when they are not in use.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		ProbeReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The internal chamber container of the Probe that contains the storage solution (usually \"Electrolyte 3 mol/L KCl\") used to maintain stable reference electrode conditions for accurate pH measurement.",
			Category -> "Instrument Specifications"
		},
		SecondaryProbeReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The internal chamber container of the SecondaryProbe that contains the storage solution (usually \"Electrolyte 3 mol/L KCl\") used to maintain stable reference electrode conditions for accurate pH measurement.",
			Category -> "Instrument Specifications"
		},
		TertiaryProbeReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The internal chamber container of the TertiaryProbe that contains the storage solution (usually \"Electrolyte 3 mol/L KCl\") used to maintain stable reference electrode conditions for accurate pH measurement.",
			Category -> "Instrument Specifications"
		},
		ProbeStorageContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container filled with storage solution (usually \"Electrolyte 3 mol/L KCl\") secured to the bottom of the Probe to keep the pH probe's glass membrane and reference junction hydrated when not in use.",
			Category -> "Instrument Specifications"
		},
		SecondaryProbeStorageContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container filled with storage solution (usually \"Electrolyte 3 mol/L KCl\") secured to the bottom of the SecondaryProbe to keep the pH probe's glass membrane and reference junction hydrated when not in use.",
			Category -> "Instrument Specifications"
		},
		TertiaryProbeStorageContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container filled with storage solution (usually \"Electrolyte 3 mol/L KCl\") secured to the bottom of the TertiaryProbe to keep the pH probe's glass membrane and reference junction hydrated when not in use.",
			Category -> "Instrument Specifications"
		},
		pHSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensornet pH sensor used by this instrument.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		MinpHs -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinpHs]],
			Pattern :> GreaterP[0],
			Description -> "Minimum pH the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxpHs -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxpHs]],
			Pattern :> GreaterP[0],
			Description -> "Maximum pH the instrument can measure.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		SampleChamber -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The container ID of the sample chamber that permanently resides in this pHMeter. Sample chambers are present in droplet pH meters.",
			Category -> "Instrument Specifications",
			Developer->True,
			Abstract -> True
		},
		CalibrationBufferSets -> {
			Format -> Multiple,
			Class -> {Calibration -> String, Method -> String, LowCalibrationBufferpH -> Real, MediumCalibrationBufferpH -> Real, HighCalibrationBufferpH -> Real, pHCalibration -> Link},
			Pattern :> {Calibration -> _String, Method -> _String, LowCalibrationBufferpH -> RangeP[0,14], MediumCalibrationBufferpH -> RangeP[0,14], HighCalibrationBufferpH -> RangeP[0,14], pHCalibration -> _Link},
			Relation -> {Calibration -> Null, Method -> Null, LowCalibrationBufferpH -> Null, MediumCalibrationBufferpH -> Null, HighCalibrationBufferpH -> Null, pHCalibration -> Object[Method, pHCalibration]},
			Description -> "The calibration buffer sets that have been defined on the seven excellence pH meter.",
			Category -> "Instrument Specifications",
			Headers -> {Calibration->"Calibration Buffer Set Name", Method -> "Method Name", LowCalibrationBufferpH->"Low Calibration Buffer pH", MediumCalibrationBufferpH -> "Medium Calibration Buffer pH", HighCalibrationBufferpH -> "High Calibration Buffer pH", pHCalibration -> "pH Calibration Method"}
		}
	}
}];
