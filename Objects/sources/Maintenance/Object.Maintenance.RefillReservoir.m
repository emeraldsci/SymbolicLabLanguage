(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, RefillReservoir], {
	Description -> "A protocol that refills a reservoir on an instrument.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		FillVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], FillVolume]],
			Pattern :> Alternatives[GreaterP[0*Liter], GreaterP[0*Gram]],
			Description -> "The volume or mass the reservoir should be filled up to.",
			Category -> "General"
		},
		LabArea -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LabAreaP,
			Description -> "Indicates the area of the lab in which this maintenance occurs.",
			Category -> "General"
		},
		FillLiquid -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The liquid that is used to fill the reservoir.",
			Category -> "Refilling",
			Abstract -> True
		},
		FillLiquidContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container that is used to transfer liquid to the reservoir.",
			Category -> "Refilling"
		},
		FillLiquidPrep -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, ManualSamplePreparation]|Object[Protocol, RoboticSamplePreparation],
			Description -> "The sample manipulation protocol executed to transfer FillLiquid to the FillLiquidContainer.",
			Category -> "Refilling"
		},
		AdditivesTransferUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A list of manipulations to transfer FillLiquidAdditives into the container holding fill liquid in the order they are performed.",
			Category -> "Refilling",
			Developer -> True
		},
		ReservoirContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The container that holds reservoir liquid.",
			Category -> "Refilling"
		},
		ReservoirDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container deck that holds reservoir container.",
			Category -> "Refilling"
		},
		FillLiquidLevel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the fill liquid level in the reservoir meets the FillVolume criteria.",
			Category -> "Refilling",
			Developer -> True
		},
		Decontaminate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if rinse is required in the procedure when OptionalRinse is True.",
			Category -> "General",
			Developer -> True
		},
		LiquidWaste -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The liquid waste collected from the reservoir.",
			Category -> "General",
			Developer -> True
		},
		ReservoirRinseLiquid -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "Solution used to rinse the reservoir prior to refilling.",
			Category -> "General",
			Developer -> True
		},
		ReservoirRinseContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Container that is used to transfer liquid to rinse the reservoir.",
			Category -> "General",
			Developer -> True
		},
		WasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Container which is used to drain the waste in the reservoir for disposal.",
			Category -> "General",
			Developer -> True
		},
		BufferPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "Placements for buffer containers.",
			Category -> "Placements",
			Headers -> {"Buffer to Place", "Destination Container","Destination Position"},
			Developer -> True
		},
		ReservoirContainerPlacement -> {
			Format -> Single,
			Class -> {Link, Link, String},
			Pattern :> {_Link,_Link, _String},
			Relation -> {Object[Container],Object[Instrument], Null},
			Description -> "The placement used to place the ReservoirContainer in the dedicated position inside the Instrument.",
			Headers -> {"ReservoirContainer", "Instrument", "Instrument Position"},
			Category -> "Placements",
			Developer -> True
		},
		LiquidAutoclaveProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,Autoclave],
			Description -> "The protocols used to autoclave fill liquid sample.",
			Category -> "General",
			Developer -> True
		},
		RefillRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if an operator has determined by inspection whether adding liquid is necessary.",
			Category -> "Refilling",
			Developer -> True
		},
		CryoGloves -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Glove] | Object[Item,Glove],
			Description -> "The cryo gloves(s) worn to the hands from ultra low temperature surfaces/fluids.",
			Category -> "General",
			Developer -> True
		},
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,FumeHood] | Object[Instrument,FumeHood],
			Description -> "The environment in which to equilibrate temperature of the reservoir.",
			Category -> "General",
			Developer -> True
		},
		SampleContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container] | Object[Container],
			Description -> "Container used to hold the sample from the reservoir if it is not disposed.",
			Category -> "General",
			Developer -> True
		},
		StorageContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container] | Object[Container],
			Description -> "Container used to store the sample from the reservoir if it is not disposed.",
			Category -> "General"
		},
		Funnel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, Funnel] | Object[Part, Funnel],
			Description -> "The funnel used to transfer a sample from one container to another.",
			Category -> "General",
			Developer -> True
		},
		Spatula -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Spatula] | Object[Item, Spatula],
			Description -> "The type(s) of spatula(s) used to transfer a solid sample from the reservoir to the SampleContainer.",
			Category -> "General",
			Developer -> True
		}
	}
}];
