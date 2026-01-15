(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Item, Cannula], {
	Description->"Information for a cannula used to sample media during a dissolution experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DesignatedInstrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,DissolutionApparatus],
			Description->"The dissolution apparatus that is used with this cannula. It is considered best practice to use the same dissolution apparatus for each experiment with the same cannula to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		},
		DesignatedInstallationPosition->{
			Format->Single,
			Class->Expression,
			Pattern:>LocationPositionP,
			Description->"The dissolution vessel position this cannula should be used with during the experiment. It is considered best practice to install the vessel in the same position for each experiment to keep the number of variables between experiments to a minimum.",
			Category->"Dimensions & Positions"
		}
	}
}];

