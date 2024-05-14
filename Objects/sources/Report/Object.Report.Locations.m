

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report, Locations], {
	Description->"A nightly report of location information for instruments and stationary containers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		TypesIndexed -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TypeP[],
			Description -> "The SLL Types that were indexed in this report.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		InvalidModelContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "A list of modelContainers failing ValidObjectQ.",
			Category -> "Organizational Information"
		},
		InvalidContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "A list of containers failing ValidObjectQ.",
			Category -> "Organizational Information"
		},
		InactiveItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Item],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "A list of items located that are Discarded, Inactive or Retired.",
			Category -> "Organizational Information"
		},
		ExpiredItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Part],
				Object[Item],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "A list of samples/containers/parts that are expired.",
			Category -> "Organizational Information"
		},
		CachedLocations -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {_Rule..}},
			Relation -> {Object[Instrument], Null},
			Description -> "Cached partial info packets containing instrument location info.",
			Category -> "Container Specifications",
			Headers -> {"Instrument", "Partial Packet"}
		},
		InstrumentsWithoutLocations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "A list of instruments without location information in their Container field.",
			Category -> "Container Specifications"
		},
		ContainersWithoutLocations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "A list of containers without location information in their Container field.",
			Category -> "Container Specifications"
		},
		SamplesWithoutLocations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Part],
				Object[Item],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "A list of samples/parts without location information in their Container field.",
			Category -> "Container Specifications"
		},
		EmptyPlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "A list of active plates that are empty or contain only Discarded items.",
			Category -> "Container Specifications"
		},
		EmptyVessels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "A list of active vessels that are empty or contain only Discarded items.",
			Category -> "Container Specifications"
		}
	}
}];
