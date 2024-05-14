(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, VacuumEvaporation], {
	Description->"A protocol for concentrating samples via solvent evaporation in a low pressure enviroment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		EquilibrationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Bar],
			Units -> Bar Milli,
			Description -> "The target pressure to achieve by the end of the equilibration time.",
			Category -> "Equilibration"
		},
		PressureRampTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The amount of time it takes to evacaute the chamber until EquilibrationPressure is achieved.",
			Category -> "Equilibration",
			Abstract -> True
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The amount of time, including chamber evacuation, heating, centrifuging, drainage of vapors, defrost etc., it takes to achieve a steady state at the specified Temperature and EquilibrationPressure.",
			Category -> "Equilibration",
			Abstract -> True
		},
		EquilibrationTimeDisplay -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[EquilibrationTime]}, Computables`Private`vacuumEvaporationHoursAndMinutesTimeDisplay[Field[EquilibrationTime]]],
			Pattern :> _String,
			Description -> "The EquilibrationTime, in the form 'xx h yy m' for display in Rosetta.",
			Category -> "Equilibration",
			Developer -> True
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The vacuum centrifuge instrument used to evaporate the provided samples while centrifuging to prevent sample bumping.",
			Category -> "Evaporation"
		},
		VacuumEvaporationMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,VacuumEvaporation],
			Description -> "The method used to concentrate samples during this evaporation experiment.",
			Category -> "Evaporation",
			Developer->True
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature that is maintained in the sample chamber for the duration of the evaporation. Due to evaporative cooling, samples can become colder than this temperature during a run (but not warmer).",
			Category -> "Evaporation"
		},
		EvaporationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Bar],
			Units -> Bar Milli,
			Description -> "The pressure at which the samples will be dried and concentrated after equilibration is completed.",
			Category -> "Evaporation"
		},
		EvaporationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time, after equilibration is achieved, that the samples continue to undergo evaporation and concentration at the specified Temperature and EvaporationPressure.",
			Category -> "Evaporation",
			Abstract -> True
		},
		EvaporationTimeDisplay -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[EvaporationTime]}, Computables`Private`vacuumEvaporationHoursAndMinutesTimeDisplay[Field[EvaporationTime]]],
			Pattern :> _String,
			Description -> "The EvaporationTime, in the form 'xx h yy m' for display in Rosetta.",
			Category -> "Evaporation",
			Developer -> True
		},
		MethodTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "The total amount of time required for the vacuum evaporation method to complete.",
			Category -> "Evaporation",
			Developer -> True
		},
		WasteWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weight of the vacuum centrifuge's waste solvent container at the start of the evaporation protocol.",
			Category -> "Sensor Information",
			Developer -> True
		},
		CentrifugalForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The force (RCF) exerted on the samples as a result of centrifuging them to prevent sample bumping.",
			Category -> "Centrifugation"
		},
		RotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The rotation speed at which samples are rotated to prevent sample bumping.",
			Category -> "Centrifugation"
		},
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The balance instrument used to weigh the centrifuge buckets to ensure the vacuum centrifuge is balanced properly.",
			Category -> "Centrifugation"
		},
		BucketWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weights of the centrifuge buckets, with all sample containers loaded.",
			Category -> "Centrifugation",
			Developer -> True
		},
		Counterbalances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of UnbalancedContainers, the weighted container placed opposite the unbalanced container to ensure balanced centrifugation.",
			Category -> "Centrifugation"
		},
		CounterbalancePrepManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The set of instructions specifying the transfer of balance solvent to the Counterbalances for balancing the vacuum centrifuge during evaporation.",
			Category -> "Centrifugation",
			Developer -> True
		},
		CounterbalancePrepPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the transfer of balance solvent to the Counterbalances for balancing the vacuum centrifuge during evaporation.",
			Category -> "Centrifugation",
			Developer->True
		},
		CentrifugeBuckets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The centrifuge buckets used to place containers into the vacuum centrifuge.",
			Category -> "Centrifugation"
		},
		CentrifugeRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The centrifuge racks used to hold tubes or vials in the centrifuge buckets that are placed in the vacuum centrifuge.",
			Category -> "Centrifugation"
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "A list of placements used to place the containers to be evaporated in the appropriate positions of the vacuum centrifuge buckets.",
			Category -> "Placements",
			Developer -> True,
			Headers->{"Object to Place", "Destination Object","Destination Position"}
		},
		BucketPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "A list of placements used to place the centrifuge buckets in the appropriate positions of the vacuum centrifuge rotor.",
			Category -> "Placements",
			Developer -> True,
			Headers->{"Object to Place", "Destination Object","Destination Position"}
		},
		BalancingSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to counterbalance samples during evaporation, if a counterbalance is needed.",
			Category -> "Centrifugation"
		},
		FullyEvaporated -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MultipleChoiceAnswerP,
			Description -> "For each member of SamplesIn, indicates if the sample appears fully dried upon visual inspection.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		}
	}
}];
