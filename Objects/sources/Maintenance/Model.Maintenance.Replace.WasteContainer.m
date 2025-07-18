(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Replace, WasteContainer], {
	Description -> "Definition of a set of parameters for a maintenance protocol that moves the full waste containers to the waste holding area and replaces them with new empty waste containers.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		PercentFull -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "The minimum volume of the waste container filled by waste to be replaced.",
			Category -> "General"
		},
		WasteModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "Indicates the model of the waste sample to be checked by the maintenance.",
			Category -> "General",
			Developer -> True
		},
		WasteContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "Indicates the model of the waste container to be checked by the maintenance.",
			Category -> "General",
			Developer -> True
		},
		ReplacementContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of the waste container that is used to replace the full waste container.",
			Category -> "General"
		},
		MaxWasteAccumulationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Day],
			Units -> Day,
			Description -> "The maximum time a waste container can be used without being replaced determined by EHS.",
			Category -> "General"
		},
		WasteLabel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, WasteLabel],
			Description -> "The label specifying the contents and other specifications of the accumulated waste in the waste container.",
			Category -> "General",
			Developer -> True
		},
		HazardousWasteLabel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, WasteLabel],
			Description -> "The label specifying the intended use of the waste container.",
			Category -> "General",
			Developer -> True
		},
		WasteLabelFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path in $PublicPath from which maintenances of this model directly import waste labels.",
			Category -> "General",
			Developer -> True
		},
		FullContainerCabinets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The cabinets where full waste containers are placed after being replaced.",
			Category -> "General",
			Developer -> True
		},
		EmptiedContainerCabinet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The cabinet where waste containers are placed after being emptied.",
			Category -> "General",
			Developer -> True
		},
		WasteRoomSuppliesCabinet -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The cabinets where empty rinsed waste containers are stored.",
			Category -> "General",
			Developer -> True
		},
		Printer -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _String},
			Relation -> {Object[Container], Null},
			Description -> "Container and name of the printer that is used to print the contents list of the replaced waste containers.",
			Headers -> {"Location", "Name"},
			Category -> "General",
			Developer -> True
		},
		Funnel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, Funnel],
			Description -> "A funnel for easily transferring liquid from a container to another.",
			Category -> "General",
			Developer -> True
		}
	}
}];
