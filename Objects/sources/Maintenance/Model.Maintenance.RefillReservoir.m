(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, RefillReservoir], {
	Description -> "Definition of a set of parameters for a maintenance protocol that refills an instrument's reservoir.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		Capacity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0*Liter], GreaterP[0*Gram]],
			Description -> "The maximum volume or mass that the reservoir can be filled to.",
			Category -> "General"
		},
		FillVolume -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0*Liter], GreaterP[0*Gram]],
			Description -> "The volume or mass to which this reservoir should be filled.",
			Category -> "General",
			Abstract -> True
		},
		MinResistivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*((Mega*Ohm)*(Centi*Meter))],
			Units -> Centi Mega Meter Ohm,
			Description -> "Minimum acceptable resistivity of the water that can be put into the reservoir.",
			Category -> "General"
		},
		MaxResistivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*((Mega*Ohm)*(Centi*Meter))],
			Units -> Centi Mega Meter Ohm,
			Description -> "Maximum resistivity of water that can be put into the reservoir.",
			Category -> "General"
		},
		ReservoirContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The type of reservoir container that is refilled in the maintenance.",
			Category -> "General"
		},
		RemovableReservoirContainer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the reservoir container can be removed from its location.",
			Category -> "General"
		},
		ReservoirCover -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[FieldP[Object, Output -> Short]],
			Description -> "The field relative to target models' objects which links to the closure for the reservoir.",
			Category -> "General"
		},
		ReservoirInlet -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[FieldP[Object, Output -> Short]],
			Description -> "The field relative to target models' objects which links to the port that connects to this reservoir.",
			Category -> "General"
		},
		DrainReservoir -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the fixed reservoir container needs to be drained before refilling.",
			Category -> "General"
		},
		PartialRefill -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "True if the fixed reservoir container is refilled with unknown amount of liquid volume.",
			Category -> "General"
		},
		FillLiquidAutoclave ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "True if the fill liquid used to refill the reservoir needs to be autoclaved.",
			Category -> "General"
		},
		FillLiquidAdditives -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of anti-microbial chemical or any other samples added to the fill liquid.",
			Category -> "Refilling",
			Abstract -> True
		},
		AdditivesVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Liter],
			Units -> Liter,
			Description -> "For each member of FillLiquidAdditives, the volume of additive that is added to the fill liquid sample.",
			Category -> "Refilling",
			IndexMatching -> FillLiquidAdditives
		},
		FillLiquidModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of liquid that is used to fill the reservoir.",
			Category -> "General",
			Abstract -> True
		},
		FillContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container that is used to transfer liquid to the reservoir.",
			Category -> "General"
		},
		SamplePreparationUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A set of instructions specifying the loading of the reservoir container with the desired solution for use in Maintenance.",
			Category -> "General"
		},
		ReservoirDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container deck on instrument that holds reservoir container.",
			Category -> "General"
		},
		ReservoirDeckName -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FieldP[Output->Short],
			Description -> "The field name in the instrument where reservoir deck is uploaded to.",
			Category -> "General"
		},
		ReservoirDeckSlotName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Slot name of where reservoir container is stored in the reservoir deck or rack.",
			Category -> "General"
		},
		ReservoirRinseLiquid -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of solution required to rinse the reservoir container.",
			Category -> "General"
		},
		ReservoirRinseVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "The volume of liquid used to rinse the reservoir.",
			Category -> "General"
		},
		RinseContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container that is used to transfer liquid to rinse the reservoir.",
			Category -> "General"
		},
		RinseNumber -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of times reservoir container needs to be rinsed before refilling.",
			Category -> "General"
		},
		WasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "Container used to drain liquid waste in the reservoir for disposal.",
			Category -> "General"
		},
		CryoGloveModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Glove],
			Description -> "The type(s) of cryo gloves(s) worn to the hands from ultra low temperature surfaces/fluids.",
			Category -> "General",
			Developer -> True
		},
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, FumeHood],
			Description -> "The environment in which to equilibrate temperature of the reservoir.",
			Category -> "General",
			Developer -> True
		}
	}
}];
