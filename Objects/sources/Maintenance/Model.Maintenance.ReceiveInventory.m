(* Package *)

DefineObjectType[Model[Maintenance, ReceiveInventory], {
	Description->"Definition of a set of parameters for a maintenance protocol that receives items in the inventory.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ReceivingBench -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, Bench, Receiving],
				Object[Container, Bench]
			],
			Description -> "The bench to which newly-created items are moved before they are stored in a receiving protocol.",
			Category -> "Operations Information",
			Abstract -> True
		},
		ReceivingPrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD],
			Units -> USD,
			Description -> "Handling cost associated with receiving an incoming shipment to an ECL facility.",
			Category -> "Pricing Information",
			Abstract -> True
		},
		MeasureWeightPrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD],
			Units -> USD,
			Description -> "Cost of measuring the initial weight of a sample shipped to an ECL facility.",
			Category -> "Pricing Information",
			Abstract -> True
		},
		MeasureVolumePrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD],
			Units -> USD,
			Description -> "Cost of measuring the initial volume  of a sample shipped to an ECL facility.",
			Category -> "Pricing Information",
			Abstract -> True
		},
		MeasureCountPrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "Cost of measuring the initial count of a sample shipped to an ECL facility.",
			Category -> "Pricing Information",
			Abstract -> True
		}
	}
}];
