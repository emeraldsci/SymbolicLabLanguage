(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Maintenance, Replace, WasteContainer], {
	Description -> "A protocol that that moves the full waste containers to the waste holding area and replaces them with new empty waste containers.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		CheckedWasteContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Waste containers that were inspected during this maintenance.",
			Category -> "General",
			Abstract -> True
		},
		FullWasteContainers -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the waste container is full.",
			Category -> "General",
			Developer -> True
		},
		ReplacedWasteContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Waste containers that were replaced during this maintenance.",
			Category -> "General",
			Abstract -> True
		},
		EmptiedWasteContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that are emptied and ready to rinse.",
			Category -> "General",
			Developer -> True
		},
		RinsateWasteContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Model[Container]],
			Description -> "Waste containers that were resource picked for rinsates from rinsing the EmptiedWasteContainers.",
			Category -> "General",
			Developer -> True
		},
		UsedRinsateWasteContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Waste containers that were filled with rinsate waste from rinsing the EmptiedWasteContainers.",
			Category -> "General",
			Developer -> True
		},
		AllWasteContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "All waste containers that were labeled and stored for pickup during this maintenance, including ReplacedWasteContainers and UsedRinsateWasteContainers.",
			Category -> "General",
			Developer -> True
		},
		ReplaceWasteContainersQ -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CheckedWasteContainers, indicates if the waste container must be replaced.",
			IndexMatching -> CheckedWasteContainers,
			Category -> "General",
			Developer -> True
		},
		PickedSamplePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container], Object[Container] | Object[Instrument], Null},
			Description -> "Placements for exchanged waste type.",
			Category -> "Placements",
			Headers -> {"New Waste Container", "Destination Container", "Destination Position"},
			Developer -> True
		},
		WasteLabel -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, WasteLabel] | Object[Item, WasteLabel],
			Description -> "The label specifying the contents and other specifications of the accumulated waste in the waste container.",
			Category -> "General",
			Developer -> True
		},
		HazardousWasteLabel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, WasteLabel] | Object[Item, WasteLabel],
			Description -> "The label specifying the intended use of the waste container.",
			Category -> "General",
			Developer -> True
		},
		AccumulationStartDate -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The date when a waste container was first placed in use.",
			Category -> "General",
			Developer -> True
		},
		WasteLabelFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of AllWasteContainers, the filepath of the pdf file that contains the EHS labels to affix to the waste container.",
			Developer -> True,
			Category -> "General",
			IndexMatching -> AllWasteContainers
		},
		WasteType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WasteTypeP,
			Description -> "Indicates the waste type being checked.",
			Category -> "General",
			Abstract -> True
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
		PercentFull -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Percent],
			Units -> Percent,
			Description -> "The minimum volume of the waste container filled by waste to be replaced.",
			Category -> "General"
		},
		LongAccumulatedWaste -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of CheckedWasteContainers, indicates if the waste container is accumulated more than a predetermined time.",
			IndexMatching -> CheckedWasteContainers,
			Category -> "General",
			Developer -> True
		},
		WasteLabelImageFront -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of AllWasteContainers, an image from the front side of the waste label for verification purposes.",
			Category -> "General",
			Developer -> True,
			IndexMatching -> AllWasteContainers
		},
		WasteLabelImageBack -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of AllWasteContainers, an image from the back side of the waste label for verification purposes.",
			Category -> "General",
			Developer -> True,
			IndexMatching -> AllWasteContainers
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
			Relation -> Model[Part, Funnel] | Object[Part, Funnel],
			Description -> "A funnel for easily transferring liquid from a container to another.",
			Category -> "General",
			Developer -> True
		}
	}
}];