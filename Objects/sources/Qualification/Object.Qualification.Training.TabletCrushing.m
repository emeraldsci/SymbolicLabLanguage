(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification,Training,TabletCrushing], {
	Description->"The qualification to test the user's ability to respond to tablet crush.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TabletSample -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The model or sample describing the tablet that will be used in this Qualification to test sample retention after crushing.",
			Category -> "Tablet Crushing Skills"
		},
		TabletCrusher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, TabletCrusher],
				Object[Item, TabletCrusher]
			],
			Description -> "The model or item describing the device that will be used in this Qualification to crush tablets.",
			Category -> "Tablet Crushing Skills"
		},
		TabletCrusherBag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> Link,
			Relation -> Alternatives[
				Object[Item, TabletCrusherBag],
				Model[Item, TabletCrusherBag]
			],
			Description -> "Container which tablets are placed into prior to being crushed by the target instrument.",
			Category -> "Tablet Crushing Skills"
		},
		TabletBalance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> Link,
			Relation -> Alternatives[
				Object[Instrument, Balance],
				Model[Instrument, Balance]
			],
			Description -> "Instrument which tablets are weighed on before and after they have been crushed.",
			Category -> "Tablet Crushing Skills"
		},
		HandlingEnvironment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, HandlingStation],
				Object[Instrument, HandlingStation]
			],
			Description -> "The environment in which crushing and weighing tablets happens.",
			Category -> "General"
		},
		TabletPostCrushContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> Link,
			Relation -> Alternatives[
				Object[Container, Vessel],
				Model[Container, Vessel]
			],
			Description -> "Container which tablets are placed into after being crushed by the target instrument.",
			Category -> "Tablet Crushing Skills"
		},
		TabletPostCrushContainerRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> Link,
			Relation -> Alternatives[
				Object[Container, Rack],
				Model[Container, Rack]
			],
			Description -> "Rack used to hold the container carrying the tablet after it has been crushed.",
			Category -> "Tablet Crushing Skills"
		},
		TabletWeighingContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> Link,
			Relation -> Alternatives[
				Object[Item, WeighBoat],
				Model[Item, WeighBoat]
			],
			Description -> "Container used to hold the tablet for weight measurements before it has been crushed.",
			Category -> "Tablet Crushing Skills"
		},
		TabletSpatulas -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> Link,
			Relation -> Alternatives[
				Object[Item, Spatula],
				Model[Item, Spatula]
			],
			Description -> "Tool used to get a tablet out of the bottle for weighing and for transfer into a tablet crusher bag.",
			Category -> "Tablet Crushing Skills"
		},
		TabletPreCrushWeight -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight of the tablet before it has been crushed.",
			Category -> "Experimental Results"
		},
		TabletPostCrushWeight -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight of the tablet after it has been crushed.",
			Category -> "Experimental Results"
		},
		TabletPostCrushContainerWeight -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The weight of the container carrying the crushed tablet.",
			Category -> "Experimental Results"
		},
		TabletWeighingContainerTareWeight -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The tared weight of TableWeighPaper.",
			Category -> "Experimental Results"
		},
		TabletPostCrushContainerRackTareWeight -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The tared weight of TablePostCrushContainerRack.",
			Category -> "Experimental Results"
		},
		TabletPostCrushImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,ImageSample],
			Description -> "The Cloud File containing image data of the tablet after it has been crushed.",
			Category -> "Experimental Results"
		},
		WeightStabilityDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration for which the balance reading needs to stay within a range defined by MaxWeightVariation before being considered stable and measured.",
			Category -> "General"
		},
		MaxWeightVariation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milligram],
			Units -> Milligram,
			Description -> "The max allowed amplitude the balance readings can fluctuate with for a duration defined by WeightStabilityDuration before being considered stable and measured.",
			Category -> "General"
		}
	}
}]