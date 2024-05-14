

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Instrument, DNASynthesizer], {
	Description->"Phosphoramidite Synthesizer that generates DNA/RNA or modified other oligomers.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

	(* --- Instrument Specifications --- *)
		FlushScript -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The autoit file for flushing the DNA synthesizer.",
			Category -> "Instrument Specifications"
		},
		MaintenanceFlushScript -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The autoit file for maintenance flushing.",
			Category -> "Instrument Specifications"
		},
		ColumnScale -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ColumnScale]],
			Pattern :> {GreaterP[0]..},
			Description -> "A list of synthesis scales for the different types of columns the instrument can work with.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		PlaceholderBottles -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Headers -> {"Slot", "Container"},
			Relation -> {Null, Object[Container, Vessel]},
			Description -> "A list of containers kept on the instrument while the instrument is not in use.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		NominalArgonPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],NominalArgonPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The normal working Argon pressure as indicated by the internal pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalChamberGaugePressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],NominalChamberGaugePressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The normal working chamber pressure as indicated by the chamber pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalPurgeGaugePressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],NominalPurgeGaugePressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The normal working purge pressure as indicated by the purge pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalAmiditeAndACNGaugePressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],NominalAmiditeAndACNGaugePressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The normal working amidite/ACN pressure as indicated by the amidite/ACN pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalCapAndActivatorGaugePressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],NominalCapAndActivatorGaugePressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The normal working cap/activator pressure as indicated by the cap/activator pressure gauge.",
			Category -> "Instrument Specifications"
		},
		NominalDeblockAndOxidizerGaugePressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],NominalDeblockAndOxidizerGaugePressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The normal working deblock/activator pressure as indicated by the deblock/activator pressure gauge.",
			Category -> "Instrument Specifications"
		},

	(* --- Operating Limits --- *)
		MaxColumns -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxColumns]],
			Pattern :> GreaterP[0],
			Description -> "Number of columns the synthesizer can work with in a single run.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxModifications -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxModifications]],
			Pattern :> GreaterP[0],
			Description -> "The maximum number of reagent positions for modifications that the instrument can hold.",
			Category -> "Operating Limits"
		},
		MinArgonPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinArgonPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The minimum allowable Argon pressure as indicated by the internal pressure gauge.",
			Category -> "Operating Limits"
		},
		MaxArgonPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxArgonPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum allowable Argon pressure as indicated by the internal pressure gauge.",
			Category -> "Operating Limits"
		},

	(* --- Calibration Information --- *)
		MaxSlopes -> {
			Format -> Multiple,
			Class -> {String,String,Expression},
			Pattern :> {_String,_String,_?FlowRateQ},
			Description -> "The maximum allowable slope.",
			Category -> "Qualifications & Maintenance",
			Headers->{"Dispensing Line","Bank","Maximum Slope"}
		},
		MinSlopes -> {
			Format -> Multiple,
			Class -> {String,String,Expression},
			Pattern :> {_String,_String,_?FlowRateQ},
			Description -> "The minimum allowable slope.",
			Category -> "Qualifications & Maintenance",
			Headers->{"Dispensing Line","Bank","Minimum Slope"}
		},
		MaxIntercepts -> {
			Format -> Multiple,
			Class -> {String,String,Expression},
			Pattern :> {_String,_String,_?VolumeQ},
			Description -> "The maximum allowable intercept.",
			Category -> "Qualifications & Maintenance",
			Headers->{"Dispensing Line","Bank","Maximum Intercept"}
		},
		MinIntercepts -> {
			Format -> Multiple,
			Class -> {String,String,Expression},
			Pattern :> {_String,_String,_?VolumeQ},
			Description -> "The minimum allowable intercept.",
			Category -> "Qualifications & Maintenance",
			Headers->{"Dispensing Line","Bank","Minimum Intercept"}
		},
	(* --- Sensor Information --- *)
		PrimaryWashSolutionScale -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Weight sensor used by this instrument to determine the amount of wash solution in the Bank 1 Wash Container.",
			Category -> "Sensor Information"
		},
		SecondaryWashSolutionScale -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Weight sensor used by this instrument to determine the amount of wash solution in the Bank 2 Wash Container.",
			Category -> "Sensor Information"
		},
		DeblockSolutionScale -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Weight sensor used by this instrument to determine the amount of deblock solution in the Deblock Container.",
			Category -> "Sensor Information"
		},
		ChamberPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Pressure sensor used by this instrument to monitor the chamber pressure during the synthesis.",
			Category -> "Sensor Information"
		},
		PurgePressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Pressure sensor used by this instrument to monitor the purge pressure during the synthesis.",
			Category -> "Sensor Information"
		},
		AmiditeAndACNPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Pressure sensor used by this instrument to monitor the delivery pressure for the Amidites and Acetonitrile lines during the synthesis.",
			Category -> "Sensor Information"
		},
		CapAndActivatorPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Pressure sensor used by this instrument to monitor the delivery pressure for the Cap and Activator lines during the synthesis.",
			Category -> "Sensor Information"
		},
		DeblockAndOxidizerPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Pressure sensor used by this instrument to monitor the delivery pressure for the Deblock and Oxidizer lines during the synthesis.",
			Category -> "Sensor Information"
		}
	}
}];
