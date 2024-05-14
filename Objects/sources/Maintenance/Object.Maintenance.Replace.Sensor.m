(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance,Replace,Sensor],{
	Description->"A protocol that replaces a sensor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		FeedPressureSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Part,PressureSensor],
				Object[Part,PressureSensor]
			],
			Description->"The replacement pressure sensors used in the protocol.",
			Category -> "General"
		},
		RetentatePressureSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Part,PressureSensor],
				Object[Part,PressureSensor]
			],
			Description->"The replacement pressure sensors used in the protocol.",
			Category->"General"
		},
		PermeatePressureSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Part,PressureSensor],
				Object[Part,PressureSensor]
			],
			Description->"The replacement pressure sensors used in the protocol.",
			Category->"General"
		},
		RetentateConductivitySensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Part,ConductivitySensor],
				Object[Part,ConductivitySensor]
			],
			Description->"The replacement conductivity sensors used in the protocol.",
			Category->"General"
		},
		PermeateConductivitySensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Part,ConductivitySensor],
				Object[Part,ConductivitySensor]
			],
			Description->"The replacement conductivity sensors used in the protocol.",
			Category->"General"
		}
	}
}];