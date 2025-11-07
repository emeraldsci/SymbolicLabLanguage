(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, DissolutionShaft], {
	Description->"Information for a shaft used to mix media during a dissolution experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ShaftLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],StirrerLength]],
			Pattern :> GreaterP[0 Milli Meter],
			Description -> "The overall length of the stirrer stem.",
			Category -> "Dimensions & Positions"
		},		
		ShaftDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ShaftDiameter]],
			Pattern :>GreaterP[0 Milli Meter],
			Description -> "The outside diameter of the stirrer stem.",
			Category -> "Dimensions & Positions"
		},
		DesignatedInstallationPosition->{
			Format->Single,
			Class->Expression,
			Pattern:>LocationPositionP,
			Description->"The position in which the shaft is installed in the dissolution apparatus. It is considered best practice to install the shaft in the same position for each experiment to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		},
		DesignatedInstrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,DissolutionApparatus],
			Description->"The dissolution apparatus that is used with this shaft. It is considered best practice to use the same dissolution apparatus for each experiment with the same dissolution shaft to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		}
	}
}];
