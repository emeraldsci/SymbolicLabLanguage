

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report, AbortedProtocol], {
	Description -> "A record of any in-progress or completed clean up needed after aborting a protocol, such as instruments to release or samples to store or discard.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields ->
		{
			AbortedProtocol -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Protocol], Object[Qualification], Object[Maintenance]],
				Description -> "The protocol requiring clean-up after being ended mid-run due to an error.",
				Category -> "General"
			},
			Resolved -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates if all clean-up for the aborted protocol has been completed.",
				Abstract -> True,
				Category -> "General"
			},
			UnreleasedInventory -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Container], Object[Item],Object[Wiring], Object[Part], Object[Plumbing]],
				Description -> "All labware and reagents that must be manually assessed and released or discarded.",
				Category -> "General"
			},
			UnreleasedInstruments -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Instrument],
				Description -> "Instruments used by the aborted protocol that must be manually assessed and returned to ground state before being released.",
				Category -> "General"
			},
			ReleasedInstruments -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Instrument],
				Description -> "Stateless instruments used by the aborted protocol that were automatically released when the protocol was aborted.",
				Category -> "General"
			},
			Site -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container,Site],
				Description -> "The ECL site at which the protocol was running.",
				Abstract -> True,
				Category -> "General"
			},
			StoredInventory -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Sample], Object[Container], Object[Item], Object[Wiring], Object[Part], Object[Plumbing]],
				Description -> "All reusable or otherwise unimpacted labware and reagents that were automatically released when the protocol was aborted.",
				Category -> "Storage Information"
			},
			DiscardedInventory -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Sample], Object[Container], Object[Item],Object[Wiring], Object[Part], Object[Plumbing]],
				Description -> "All labware and reagents that were consumed by the protocol or are otherwise unsuitable for reuse that are set to be discarded when the protocol was aborted.",
				Category -> "Storage Information"
			},
			MaintenanceProtocols -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Maintenance],
				Description -> "Storage updates created to store or discard labware and reagents as needed.",
				Category -> "Storage Information"
			}
		}
}];
