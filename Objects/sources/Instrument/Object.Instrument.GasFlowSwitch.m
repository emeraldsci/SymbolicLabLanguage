(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, GasFlowSwitch], {
	Description->"An instrument that is used to switch the flow of gas from two source tanks on the basis of each tank's source pressure.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		RightCylinder->{
			Format->Single,
			Class-> Link,
			Pattern:> _Link,
			Relation-> Alternatives[
				Object[Container,GasCylinder][GasFlowSwitch]
			],
			Description->"Gas cylinder connected to the right gas inlet of Gas Flow Switch.",
			Category->"Instrument Specifications"
		},
		LeftCylinder->{
			Format->Single,
			Class-> Link,
			Pattern:>_Link,
			Relation-> Alternatives[
				Object[Container,GasCylinder][GasFlowSwitch]
			],
			Description->"Gas cylinder connected to the left gas inlet of Gas Flow Switch.",
			Category->"Instrument Specifications"
		},
		RightInletPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure gauge indicating the pressure inside the gas tank connected to the right inlet.",
			Category -> "Sensor Information"
		},
		LeftInletPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure gauge indicating the pressure inside the gas tank connected to the left inlet.",
			Category -> "Sensor Information"
		},
		OutletPressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The pressure gauge indicating the pressure delivered from the gas flow switch to the downstream connected infrastructure.",
			Category -> "Sensor Information"
		},
		AutomaticTankReplacement -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if maintenance protocols are automatically generated to replace the tanks connected to this gas flow switch if tank replacement is indicated.",
			Category -> "Qualifications & Maintenance"
		},
		TurnsToOpen -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Round[Download[Field[Model],TurnsToOpen],1/4]},Round[Download[Field[Model],TurnsToOpen],1/4]],(*display as rational or integer in 1/4 increments*)
			Pattern:> Alternatives[
				_Rational,
				_Integer
			],
			Description -> "The number of turns (in 1/4 turn increments) that the pressure builder valves of tanks connected to this gas flow switch should be opened displayed as a fraction or integer.",
			Category -> "Instrument Specifications"
		}
	}
}];
