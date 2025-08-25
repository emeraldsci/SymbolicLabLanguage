(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Vessel, Dissolution], {
	Description->"Information for a vessel used in the dissolution experiments. These vessels have special shapes and are not generally used for other purposes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DesignatedDissolutionShaft->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,DissolutionShaft],
			Description->"The mixing implement that is used with this shaft affector. It is considered best practice to use the same mixing implement for each experiment with the same dissolution shaft to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		},
		DesignatedInstrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,DissolutionApparatus],
			Description->"The dissolution apparatus that is used with this vessel. It is considered best practice to use the same dissolution apparatus for each experiment with the same vessel to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		},
		DesignatedInstallationPosition->{
			Format->Single,
			Class->Expression,
			Pattern:>LocationPositionP,
			Description->"The position in which the vessel is installed in the dissolution apparatus. It is considered best practice to install the vessel in the same position for each experiment to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		}
	}
}];