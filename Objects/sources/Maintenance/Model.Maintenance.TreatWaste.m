(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, TreatWaste], {
	Description->"Definition of a set of parameters for a maintenance protocol that treats and safely disposes of the waste.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CleaningType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleaningTypeP,
			Description -> "Indicates the type of cleaning or sterilization that the contents of containers of this model will undergo.",
			Category -> "General"
		},
		DisinfectantModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the concentrated disinfactant that is diluted and combined with liquid samples to mitigate their biohzard.",
			Category -> "General"
		},
		DisinfectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The length of time for which the source samples are incubated with bleach.",
			Category -> "General"
		},
		TreatmentContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel],
			Description -> "The model of the BleachContainers that are loaded with bleach and brought to the BisoafetyCabinet to treat the liquid biohazard samples.",
			Category -> "General"
		},
		FunnelModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, Funnel],
			Description -> "The model of the funnel used to facilitate the transfer of liquid biohazard waste to the BleachContainers in the BiosafetyCabinet.",
			Category -> "General",
			Developer -> True
		},
		FunnelBathContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel],
			Description -> "The container model that is used to hold the Funnel in a bleach bath after transferring liquid biohazard waste from all batches.",
			Category -> "General",
			Developer -> True
		}
	}
}];