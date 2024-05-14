(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Transaction,ShipToECL], {
	Description->"A transaction to ship samples from users sites to the ECL's sites.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SendingStatusP,
			Description -> "A symbol representing the current state of the transaction.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, SendingStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "Log of the status changes for this transaction.",
			Category -> "Organizational Information",
			Headers -> {"Date","Status","Responsible Party"},
			Developer -> True
		},
		SamplesOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "The sample objects from this transaction, including any requested transfers.",
			Category -> "Organizational Information"
		},
		ContainersOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container]],
			Description -> "The container objects from this transaction, including any requested transfers.",
			Category -> "Organizational Information"
		},
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
		TransferSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "Samples that should be moved into a new container upon arrival at ECL.",
			Category -> "Inventory"
		},
		TransferContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "For each member of TransferSamples, the type of container into which they will be transferred.",
			Category -> "Inventory",
			IndexMatching->TransferSamples
		},
		Receiving -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ReceiveInventory][Orders],
			Description -> "The MaintenanceReceiveInventory protocols that received this order.",
			Category -> "Inventory"
		},
		VolumeMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureVolume],
			Description -> "The protocol used to experimentally measure the volume of the samples upon arrival.",
			Category -> "Inventory"
		},
		WeightMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureWeight],
			Description -> "The protocol used to experimentally measure the mass of the samples upon arrival.",
			Category -> "Inventory"
		},
		EmptyContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container]],
			Description -> "A list of content-free Model or Object Containers that were shipped with the transaction. These empty containers are used for container parameterization, and allow the ECL to work with new container types that are encountered.",
			Category -> "Model Information"
		},
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
		}
	}
}];
