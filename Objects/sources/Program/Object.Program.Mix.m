(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Program, Mix], {
	Description->"The program used to store a batches of containers to be mixed together in a protocol[Mix].",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		Completed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this program has been completed by the procedure.",
			Category -> "General"
		},		
		ContainerBatch -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "List of containers to be mixed in the execution of this program.",
			Category -> "General"
		},
		SampleBatch -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "List of samples to be mixed in the execution of this program.",
			Category -> "General"
		},					
		FullyDissolved ->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MultipleChoiceAnswerP,
			Description -> "For each member of ContainerBatch or SampleBatch (if MixingType is Pipette), indicates if all components in the solution appear fully dissolved by visual inspection.",
			Category -> "General"
		},		
		MixingType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MixTypeP,
			Description -> "The type of mixing instrumentation used by this protocol to mix the samples.",
			Category -> "General"
		},
		PipetteManipulations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying how the SampleManipulationProtocols will mix the SampleBatch by pipetting.",
			Category -> "General"
		},		
		MixingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The length of time to mix the samples using the mixer.",
			Category -> "General"
		},
		NumberOfMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of times to mix. Applies for MixingType: Pipette or Invert.",
			Category -> "General"
		},		
		MixingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The rate to mix the samples during this protocol.",
			Category -> "General"
		}
	}
}];
