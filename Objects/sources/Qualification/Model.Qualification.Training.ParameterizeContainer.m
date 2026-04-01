(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: ian *)
(* :Date: 2023-02-14 *)

DefineObjectType[Model[Qualification, Training, ParameterizeContainer], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to measure and parameterize a container.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		ParameterizeTrainingContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			(* IMPORTANT *)
			(* Only Plate procedures in ParameterizeContainer are branched and modified for this training. If the container model needs to be changed to anything other than Plate, the related procedures should be modified in the ParameterizeContainer procedures *)
			Relation -> Model[Container, Plate] | Object[Container, Plate],
			Description -> "The part or container that an operator will parameterize for training.",
			Category -> "General"
		},
		Caliper -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, DistanceGauge], Model[Instrument, DistanceGauge]],
			Description -> "The model of the distance measurement device used to perform measurements in this protocol.",
			Category -> "General"
		},
		HeightGauge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, DistanceGauge], Model[Instrument, DistanceGauge]],
			Description -> "The model of the distance measurement device used to perform height measurements in this protocol.",
			Category -> "General"
		},
		DepthGauge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, DistanceGauge], Model[Instrument, DistanceGauge]],
			Description -> "The model of the distance measurement device used to perform depth measurements in this protocol.",
			Category -> "General"
		}
	}
}]