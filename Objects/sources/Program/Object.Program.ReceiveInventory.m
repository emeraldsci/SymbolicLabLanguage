DefineObjectType[Object[Program, ReceiveInventory], {
	Description->"A set of parameters used to print stickers in MaintenanceReceiveInventory.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		BatchNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The batch number of the items in this Program.",
			Category -> "Inventory",
			Abstract -> True
		},
		QuantityReceived -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of units for this batch number in this Program.",
			Category -> "Inventory",
			Abstract -> True
		},
		ProductName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the items received in this Program.",
			Category -> "Inventory",
			Abstract -> True
		},
		Items -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Instrument],
				Object[Part],
				Object[Item],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
			],
			Description -> "The samples of a particular batch number in this Program.",
			Category -> "Inventory",
			Abstract -> True
		},
		Containers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers of a particular batch number in this Program.",
			Category -> "Inventory",
			Abstract -> True
		},
		MeasuredBagDimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
			Units ->{Meter,Meter,Meter},
			Description -> "The external dimensions of the boxes in Containers.",
			Category -> "Inventory",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		MeasuredBagModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The empirically determined bag model for the Containers of this program.",
			Category -> "Inventory"
		},
		Product -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product],
			Description -> "When applicable, the product being received by this program.",
			Category -> "Inventory"
		},
		Covers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap],Object[Item, Lid], Object[Item, PlateSeal]],
			Description -> "The covers sealing the containers of a particular batch number in this Program.",
			Category -> "Inventory"
		},
		ShippedRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The racks which were shipped along with the other received items.",
			Category -> "Inventory"
		},
		PrintedCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap],Object[Item, Lid], Object[Item, PlateSeal]],
			Description -> "The covers sealing the containers of a particular batch number in this Program for which stickers should be printed.",
			Category -> "Inventory"
		},
		CoverPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link,_Link},
			Relation -> {Object[Container],Alternatives[Object[Item, Cap],Object[Item, Lid], Object[Item, PlateSeal]]},
			Headers -> {"Container","Cover"},
			Description -> "The covers paired with their respective containers.",
			Category -> "Inventory"
		},
		Volume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "For drop-shipped products, the sample volumes determined from user input, product documentation, or experimental measurement.",
			Category -> "Inventory"
		},
		Mass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "For drop-shipped products, the sample masses determined from user input, product documentation, or experimental measurement.",
			Category -> "Inventory"
		},
		Count -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For drop-shipped products, the sample counts determined from user input, product documentation, or experimental measurement.",
			Category -> "Inventory"
		},
		Concentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micromolar],
			Units -> Micromolar,
			Description -> "For drop-shipped products, the sample concentrations determined from user input, product documentation, or experimental measurement.",
			Category -> "Inventory"
		},
		MassConcentration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Gram/Liter,
			Description -> "For drop-shipped products, the sample mass concentrations determined from user input, product documentation, or experimental measurement.",
			Category -> "Inventory"
		},
		MassSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | ExperimentallyMeasure,
			Description -> "For drop-shipped products, how the mass of the samples will be populated upon arrival.",
			Category -> "Inventory"
		},
		CountSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | ExperimentallyMeasure,
			Description -> "For drop-shipped products, how the count of the samples will be populated upon arrival.",
			Category -> "Inventory"
		},
		VolumeSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | ExperimentallyMeasure,
			Description -> "For drop-shipped products, how the volume of the samples will be populated upon arrival.",
			Category -> "Inventory"
		},
		ConcentrationSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation ,
			Description -> "For drop-shipped products, how the concentration of the samples will be populated upon arrival.",
			Category -> "Inventory"
		},
		MassConcentrationSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation ,
			Description -> "For drop-shipped products, how the mass concentration of the items will be populated upon arrival.",
			Category -> "Inventory"
		},
		Order -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction],
			Description -> "The transaction object that corresponds to the items in this program.",
			Category -> "Inventory"
		},
		UnverifiedCovers -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :>BooleanP,
			Description -> "Indicates if there are covers in this shipment which do not match the physical characteristics of their assigned Model.",
			Category -> "Inventory"
		}
	}
}];
