(* Package *)

DefineObjectType[Model[Maintenance, Shipping], {
	Description->"Definition of a set of parameters for a maintenance protocol that ships samples to users.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		HandlingPrice-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD],
			Units -> USD,
			Description -> "Labor prices associated with preparing an outgoing shipment from an ECL facility.",
			Category -> "Pricing Information"
		},

		AliquotPrice-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 USD],
			Units -> USD,
			Description -> "Price per sample of aliquoting in preparation for shipping the aliquoted sample from an ECL facility to the user's facility.",
			Category -> "Pricing Information"
		},
		Ice -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The model of ice used in packages prepared by this maintenance model.",
			Category -> "Shipping Information"
		},
		DryIce -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of dry ice used in packages prepared by this maintenance model.",
			Category -> "Shipping Information"
		},
		Padding -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The model of padding used in packages prepared by this maintenance model.",
			Category -> "Shipping Information"
		},
		PlateSeal -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The model of plate seals used to seal plates in packages prepared by this maintenance model.",
			Category -> "Shipping Information"
		},
		Balance-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Balance],
			Description -> "The model balance used to weigh packages prepared by this maintenance model.",
			Category -> "General"
		},
		PeanutsDispenser  -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Dispenser],
			Description -> "The dispenser used to hold and dispense dry ice used in this model of maintenance shipping.",
			Category -> "General"
		},
		DryIceDispenser -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Dispenser],
			Description -> "The dispenser used to hold and dispense packing peanuts used in this model of maintenance shipping.",
			Category -> "General"
		},

		ShippingLabelFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path in $PublicPath from which maintenances of this model directly import shipping labels.",
			Category -> "General",
			Developer->True
		},

		Shipper -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Shipper],
			Description -> "The shipping company used to deliver the transactions shipped in objects of this model maintenance to their final destination.",
			Category -> "Shipping Information"
		},

		PackageCapacity ->{
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units-> Percent,
			Description -> "The maximum percentage of volume of each box that can be filled with samples, leaving room for packaging materials in the remainder.",
			Category -> "Shipping Information"
		},

		PackingMaterialsCapacity->{
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units-> Percent,
			Description -> "The percentage of a box's empty volume reserved for filling with packing materials such as ice, dry ice, or peanuts.",
			Category -> "Shipping Information"
		}
	}
}];
