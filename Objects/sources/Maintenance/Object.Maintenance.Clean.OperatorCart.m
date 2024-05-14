(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Clean, OperatorCart], {
	Description->"A protocol that cleans and restocks the operator cart.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Ethanol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The squirt bottle container object holding 70% ethanol on the operator cart.",
			Category -> "General"
		},
		Methanol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The squirt bottle container object holding methanol on the operator cart.",
			Category -> "General"
		},
		Isopropanol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The squirt bottle container object holding isopropanol on the operator cart.",
			Category -> "General"
		},
		Acetone -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The squirt bottle container object holding acetone on the operator cart.",
			Category -> "General"
		},
		Water -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The squirt bottle container object holding water on the operator cart.",
			Category -> "General"
		},
		Lysol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The squirt bottle container object holding lysol on the operator cart.",
			Category -> "General"
		},
		ReservoirRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Rack],
			Description -> "The container racks holding carboys used to refill squirt bottles on operator carts.",
			Category -> "General"
		},
		AcetoneDispensionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Vessel],
				Object[Instrument,Dispenser]
			],
			Description -> "The container holding carboys used to refill acetone squirt bottles on operator carts.",
			Category -> "General"
		},
		EthanolDispensionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Vessel],
				Object[Instrument,Dispenser]
			],
			Description -> "The container holding carboys used to refill ethanol squirt bottles on operator carts.",
			Category -> "General"
		},
		IsopropanolDispensionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Vessel],
				Object[Instrument,Dispenser]
			],
			Description -> "The container holding carboys used to refill isopropanol squirt bottles on operator carts.",
			Category -> "General"
		},
		MethanolDispensionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Vessel],
				Object[Instrument,Dispenser]
			],
			Description -> "The container holding carboys used to refill methanol squirt bottles on operator carts.",
			Category -> "General"
		},
		LysolDispensionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Vessel],
				Object[Instrument,Dispenser]
			],
			Description -> "The container holding carboys used to refill lysol squirt bottles on operator carts.",
			Category -> "General"
		},
		WaterDispensionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,WaterPurifier],
				Object[Container,Vessel]
			],
			Description -> "The container holding carboys used to refill water squirt bottles on operator carts.",
			Category -> "General"
		},
		ReplacementPrinterLabel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Consumable],
				Object[Item,Consumable]
			],
			Description -> "Prinater label to restock printer on operator carts.",
			Category -> "General"
		},
		ReplacementPrinterResin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description -> "Prinater resin to restock printer on operator carts.",
			Category -> "General"
		},
		ReplacementChemwipe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "Chemwipe gathered to restock operator carts.",
			Category -> "General"
		},
		ReplacementPlateSealRoller -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part],
				Model[Part],
				Object[Item],
				Model[Item]
			],
			Description -> "Plate seal roller gathered to restock operator carts.",
			Category -> "General"
		},
		ReplacementPlateSeal -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "Plate seal gathered to restock operator carts.",
			Category -> "General"
		},
		ReplacementDeepWellPlateSeals -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "Deepl-well plate seals gathered to restock operator carts.",
			Category -> "General"
		},
		InitialDeepWellPlateSealCount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "Indicates the number of deep-well plate seals initially on the cart.",
			Category -> "General"
		},
		ReplacementGlove -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "Glove gathered to restock operator carts.",
			Category -> "General"
		},
		ReplacementBoxCutter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part], (* TODO: Remove Object[Sample] here after item migration *)
				Model[Part],
				Object[Item],
				Model[Item]
			],
			Description -> "Box cutter gathered to restock operator carts.",
			Category -> "General"
		},
		ReplacementBlade -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
			Object[Item,Consumable],
			Model[Item,Consumable]
			],
			Description -> "Blade for box cutter gathered to restock operator carts.",
			Category -> "General"
		},
		ReplacementBag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Bag],
				Model[Container,Bag]
			],
			Description -> "Bags gathered to restock operator carts.",
			Category -> "General"
		},
		ReplacementCapRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Rack],
				Model[Container,Rack]
			],
			Description -> "Cap racks gathered to restock operator carts.",
			Category -> "General"
		},
		WasteBin ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,WasteBin],
				Model[Container,WasteBin]
			],
			Description -> "Waste bin located on operator carts that is to be emptied during procedure.",
			Category -> "General"
		},
		WasteBinString->{
			Format->Single,
			Class->Expression,
			Pattern:>_String,
			Description->"Waste bin located on operator cart without accurate database location.",
			Category->"General"
		},
		EnvironmentalLiveData -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {TemperatureP,GreaterEqualP[0*Percent]},
			Units -> {Celsius, Percent},
			Description -> "Measurement of live environmental conditions during procedure used to test TwinCAT server.",
			Category -> "Experimental Results",
			Headers->{"Temperature","Humidity"}
		},
		ExtraItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container],
				Object[Part],
				Model[Part],
				Object[Item],
				Model[Item]
			],
			Description -> "Surplus cart accessories which are unneeded as the cart already has one instance of these.",
			Category -> "General"
		},
		CartsToMaintain -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "List of Available cart that need to be cleaned.",
			Category -> "General"
		},
		CartList -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _String,
			Description -> "A raw string of all selected cart IDs.",
			Category -> "General"
		},
		CartsBeingMaintained -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Carts that are cleaned in this maintenance.",
			Category -> "General"
		},
		MaintenanceProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->  Alternatives[
				Object[Protocol],
				Object[Maintenance]
			],
			Description -> "The protocols run on the targets that were used to generate Maintenance.",
			Category -> "General"
		}
	}
}];
