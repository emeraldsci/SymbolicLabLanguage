(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance,Replace,Sensor],{
	Description->"Definition of a set of parameters for a maintenance protocol that replaces a sensor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		PressureSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,PressureSensor],
			Description->"The model of the replacement pressure sensor.",
			Category->"General",
			Abstract->True
		},
		
		ConductivitySensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,ConductivitySensor],
			Description->"The model of the replacement conductivity sensor.",
			Category->"General",
			Abstract->True
		}
	}
}];