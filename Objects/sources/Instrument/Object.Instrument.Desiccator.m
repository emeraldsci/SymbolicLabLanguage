(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Desiccator], {
	Description -> "An instrument used to keep internal samples dry thought the use of a vacuum and/or desiccants.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		SampleType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], SampleType]],
			Pattern :> Alternatives[Open, Closed],
			Description -> "The type of sample that are intended to occupy this model of desiccator. Open SampleType leaves the container of the sample open and isolated to actively dry the sample inside whereas Closed SampleType is for long term storage and leaves the containers closed while sharing the desiccator with many containers.",
			Category -> "Instrument Specifications"
		},
		Desiccant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item],
			Description -> "The drying agent used to keep the contents of the desiccator dry.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		DesiccantCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], DesiccantCapacity]],
			Pattern :> GreaterP[0 Gram],
			Description -> "The weight of the desiccant the desiccator is cable of holding.",
			Category -> "Instrument Specifications"
		},
		DesiccantReplacementFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], DesiccantReplacementFrequency]],
			Pattern :> GreaterP[0 * Week],
			Description -> "The frequency with which the desiccant should be replaced.",
			Category -> "Instrument Specifications"
		},
		Vacuumable -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Vacuumable]],
			Pattern :> BooleanP,
			Description -> "Indicates if the contents of the desiccator can be evacuated using a vacuum source.",
			Category -> "Instrument Specifications"
		},
		MinPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinPressure]],
			Pattern :> GreaterP[0 * PSI],
			Description -> "Minimum internal pressure the desiccator can withstand (as designated by its pressure gauge).",
			Category -> "Instrument Specifications"
		},
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "Vacuum pump used to create low pressure atmosphere inside the desiccator.",
			Category -> "Instrument Specifications"
		},
		Lid -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part],
			Description -> "The lid of the desiccator.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		SampleDeck -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck],
			Description -> "The location in the instrument where samples are placed.",
			Category -> "Instrument Specifications"
		},
		DrierDeck -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck],
			Description -> "The location in the instrument where desiccant is placed.",
			Category -> "Instrument Specifications"
		},
		PressureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Pressure],
			Description -> "Sensor for monitoring the pressure inside the desiccator.",
			Category -> "Sensor Information"
		},

		(* --- Qualifications & Maintenance---*)

		AutomaticVacuumEvacuation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the pump specified VacuumPump field will be remotely activated to maintain vacuum pressure of attached desiccator.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		}
	}
}];
