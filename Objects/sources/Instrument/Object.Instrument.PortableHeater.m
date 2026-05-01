(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, PortableHeater], {
	Description->"Portable heated incubators used for sample storage when samples must be transported or manipulated at a specified temperature outside of an oven.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature the portable heater is currently set to maintain.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature the Freezer can maintain.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of space inside the Freezer interior in the  {X (width), Y (depth), Z (height)} directions.",
			Category -> "Dimensions & Positions"
		},
		TemperatureControlledResources -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {
				Alternatives[Object[Resource, Sample], Object[Sample], Object[Item], Object[Container], Model[Sample], Model[Item], Model[Container]],
				Alternatives[Object[Protocol], Object[Maintenance], Object[Qualification]]
			},
			Description -> "Resources whose samples are stored in this portable cooler during the execution of the given protocol (if there is no resource for a sample, points to the sample directly).",
			Headers -> {"Resource", "Responsible Protocol"},
			Category -> "Container Specifications"
		},
		CurrentTransporterProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][CurrentTransporters],
				Object[Maintenance][CurrentTransporters],
				Object[Qualification][CurrentTransporters]
			],
			Description -> "Indicates the root protocol this instrument is used under as a transporter to contain samples requiring special transport conditions.",
			Category -> "Sample Storage",
			Developer -> True
		}
	}
}];
