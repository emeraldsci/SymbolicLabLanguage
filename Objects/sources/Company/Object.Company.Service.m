(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Company, Service], {
	Description->"A company that synthesizes custom-made samples as a service.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		CustomSynthesizes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample][ServiceProviders]|Model[Item][ServiceProviders], (* TODO: Remove Item here after Sample to Item migration. *)
			Description -> "Custom models of samples that this company synthesized for users.",
			Category -> "Organizational Information"
		},
		PreferredContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container][ServiceProviders],
			Description -> "Known container models that this company tends to ship the samples they supply in.",
			Category -> "Organizational Information"
		},
		PreferredCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Cap], Model[Item, Lid]],
			Description -> "Known cover models (caps, lids) that this company tends to use to seal containers they supply.",
			Category -> "Organizational Information"
		},
		Transactions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, DropShipping][Provider]
				],
			Description -> "A list of drop ship transactions placed with the service company.",
			Category -> "Organizational Information"
		}
	}
}];
