(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Replace], {
	Description->"A protocol that replaces semi-consumable parts of the target instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		LabArea -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LabAreaP,
			Description -> "Indicates the area of the lab in which this maintenance occurs.",
			Category -> "General"
		},
		ReplacementParts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Model[Sample],
				Model[Container],
				Model[Plumbing],
				Model[Wiring],
				Object[Part][Maintenance],
				Object[Sample],
				Object[Container],
				Object[Item],
				Object[Item][Maintenance],
				Model[Item],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "New replacement parts.",
			Category -> "General"
		},
		RemovedParts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part],
				Object[Sample],
				Object[Container],
				Object[Item],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Replaced parts.",
			Category -> "General"
		},
		PartsPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Alternatives[Object[Part],Object[Sample],Object[Container],Object[Item],Object[Plumbing],Object[Wiring]], Alternatives[Object[Instrument],Object[Container]], Null},
			Description -> "Placement positions for replacement semi-consumables.",
			Category -> "Placements",
			Headers -> {"Replacement Part", "Destination","Destination Position"},
			Developer -> True
		},
		ReplacementRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if an operator has determined by inspection whether the parts replacement is necessary.",
			Category -> "Placements",
			Developer -> True
		},
		RequiredTools -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Screwdriver],
				Model[Item, Wrench],
				Model[Item, Plier],
				Object[Item, Screwdriver],
				Object[Item, Wrench],
				Object[Item, Plier]
			],
			Description -> "The tools required for the maintenance.",
			Category -> "General"
		}
	}
}];
