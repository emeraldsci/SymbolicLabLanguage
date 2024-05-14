(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)



With[{
	shipFromECLSharedFields=Sequence@@$ShipFromECLSharedGeneralFields,
	sharedShippingFields= Sequence@@$ShipFromECLSharedShippingFields,
	aliquotFields = Sequence@@$ShipFromECLSharedAliquotFields
},
	DefineObjectType[Object[Transaction, SiteToSite], {
		Description -> "Objects for tracking the shipments of experimental materials between ECL facilities",
		CreatePrivileges -> None,
		Cache -> Session,
		Fields -> {
			Status -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Alternatives[ReturningStatusP, SendingStatusP],
				Description ->  "An indication of whether the transaction has shipped or is pending or if it has encountered troubleshooting.",
				Category -> "Organizational Information",
				Abstract -> True
			},
			StatusLog -> {
				Format -> Multiple,
				Class -> {Date, Expression, Link},
				Pattern :> {_?DateObjectQ, Alternatives[ReturningStatusP, SendingStatusP], _Link},
				Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
				Description -> "Log of the status changes for this transaction.",
				Category -> "Organizational Information",
				Headers -> {"Date","Status","Responsible Party"},
				Developer -> True
			},
			SamplesIn -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> (Object[Sample]|Object[Item]|Model[Container]|Model[Sample]|Model[Item]),
				Description -> "The samples given as input to this transaction.",
				Category -> "Organizational Information"
			},
			ContainersIn -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container],
				Description -> "The containers of the input samples for this transaction.",
				Category -> "Organizational Information"
			},
			SamplesOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Sample]|Object[Item],
				Description -> "The samples (either the samples in or the aliquoted samples) shipped from ECL to the user in this transaction.",
				Category -> "Organizational Information"
			},
			ContainersOut -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container],
				Description -> "The containers shipped from ECL to the user in this transaction.",
				Category -> "Organizational Information"
			},
			WorkingSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Object[Item],
					Model[Item],
					Model[Sample],
					Model[Container]
				],
				Description -> "For each member of SamplesIn, the derived sample on which the experiment acts. This list diverges from SamplesIn when input samples are transferred to new containers.",
				Category -> "Resources",
				IndexMatching->SamplesIn,
				Developer -> True
			},

			WorkingContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description ->"Containers of the samples corresponding to preparations of SamplesIn generated during sample preparation and intended for use in this experiment.",
				Category -> "Resources",
				Developer -> True
			},

			shipFromECLSharedFields,
			sharedShippingFields,
			aliquotFields,

			(* -- Receiving Information -- *)
			ReceivedSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Sample]|Object[Item],
				Description -> "The sample objects from this transaction that are generated from the user-specified sample models.",
				Category -> "Inventory"
			},
			ReceivedContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Container],
				Description -> "The user-specified container objects that are shipped in this transaction.",
				Category -> "Inventory"
			},
			ReceivedCovers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Object[Item, Cap], Object[Item, Lid], Object[Item, PlateSeal]],
				Description -> "The user-specified container cover objects that are shipped in this transaction.",
				Category -> "Inventory"
			},
			Receiving -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Maintenance, ReceiveInventory][Orders],
				Description -> "The MaintenanceReceiveInventory protocols that received this order.",
				Category -> "Inventory"
			},

			(* -- Resources -- *)
			Resources -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Resource][Order],
				Description -> "The resources that can only be fulfilled once this transaction is received.",
				Category -> "Resources"
			},
			DependentProtocols -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Protocol][ShippingMaterials, 1],
					Object[Maintenance][ShippingMaterials, 1],
					Object[Qualification][ShippingMaterials, 1]
				],
				Description -> "Indicates the protocols that are depending on this transaction to be received before they can be run or continued.",
				Category -> "Resources"
			},
			Amounts -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0*Milliliter] | GreaterP[0*Milligram] | GreaterP[0*Unit, 1*Unit],
				Units -> None,
				Description -> "For each member of SamplesIn, the amount of sample requested.",
				Category -> "Resources",
				IndexMatching->SamplesIn
			},
			ContainerModels -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Model[Container],
				Description -> "For each member of SamplesIn, the type of containers used to hold the requested sample.",
				Category -> "Resources",
				IndexMatching->SamplesIn
			}
		}
	}]
];
