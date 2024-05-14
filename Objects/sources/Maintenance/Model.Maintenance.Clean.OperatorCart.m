(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Clean, OperatorCart], {
	Description->"Definition of a set of parameters for a maintenance protocol that cleans and restocks the operator cart.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Ethanol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The squirt bottle container model holding 70% ethanol on the operator cart.",
			Category -> "General"
		},
		Methanol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The squirt bottle container model holding methanol on the operator cart.",
			Category -> "General"
		},
		Isopropanol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The squirt bottle container model holding isopropanol on the operator cart.",
			Category -> "General"
		},
		Acetone -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The squirt bottle container model holding acetone on the operator cart.",
			Category -> "General"
		},
		Lysol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The squirt bottle container model holding lysol on the operator cart.",
			Category -> "General"
		},
		Water -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The squirt bottle container model holding water on the operator cart.",
			Category -> "General"
		},
		FillVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The volume to which squirt bottles should be filled.",
			Category -> "General",
			Abstract -> True
		},
		ReservoirRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Rack],
			Description -> "The rack container model holding carboys used to refill squirt bottles on operator carts.",
			Category -> "General"
		},
		Chemwipe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The kimwipe model located on operator carts.",
			Category -> "General"
		},
		PlateSeal -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The zone-free plate seal model located on operator carts.",
			Category -> "General"
		},
		DeepWellPlateSeal -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The deep-well plate seal model located on operator carts.",
			Category -> "General"
		},
		DeepWellPlateSealCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Indicates the minimum number of deep-well plate seals required on the cart.",
			Category -> "General"
		},
		BoxCutter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part]|Model[Item], (* TODO: Remove after item migration. *)
			Description -> "The razor blade box cutter model located on operator carts.",
			Category -> "General"
		},
		Blade -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The razor blade box cutter model located on operator carts.",
			Category -> "General"
		},
		PlateSealRoller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part]|Model[Item],
			Description -> "The plate seal roller model located on operator carts.",
			Category -> "General"
		},
		WasteBin ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,WasteBin],
			Description -> "Waste bin located on operator carts that is to be emptied during procedure.",
			Category -> "General"
		},
		Gloves -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null, Model[Item,Consumable]},
			Description -> "Glove models of different sizes available for operators to gather.",
			Category -> "General",
			Headers -> {"Size","Model"}
		},
		CableLabelSticker -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The label sticker model for needles located on operator carts.",
			Category -> "General"
		},
		PrinterLabel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The sticker label model for the printer located on operator carts.",
			Category -> "General"
		},
		PrinterResin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The sticker resin model for the printer located on operator carts.",
			Category -> "General"
		},
		Bag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Bag],
			Description -> "The bag model used to store cartridges on the operator carts.",
			Category -> "General"
		},
		CapRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Rack],
			Description -> "The cap rack model used to store caps on the operator carts.",
			Category -> "General"
		}
	}
}];
