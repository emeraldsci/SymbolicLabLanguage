(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, EmptyWaste], {
	Description->"Definition of a set of parameters for a maintenance protocol that inspects waste bins and empties/replaces them if necessary.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		AutoclaveModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "Sterilizer used to process biohazardous waste before disposal.",
			Category -> "General",
			Abstract -> True
		},
		WasteType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WasteTypeP,
			Description -> "Indicates the waste type being checked.",
			Category -> "General",
			Abstract -> True
		},
		WasteSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[General,Instrument,All],
			Description -> "Indicates whether the waste being emptied by this model of maintenance is from a instrument's waste container (Instrument) or a common lab waste container (General) or both (All).",
			Category -> "General",
			Abstract -> True
		},
		AutoclaveProgram -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AutoclaveProgramP,
			Description -> "Optimal autoclave sterilization program to fully inactivate all biohazardous waste.",
			Category -> "General",
			Abstract -> True
		},
		ReplacementResources -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {Model[Container], Model[Container] | Model[Sample] | Model[Item]}, (*TODO after item migration, (remove sample)*)
			Description -> "Resource necessary to refresh waste bin.",
			Headers->{"Container Type", "Resource"},
			Category -> "General"
		},
		ContainedWasteModel->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[
				Model[Container,Waste],
				Model[Sample]
			],
			Description -> "Indicates the model Waste contained by the WasteBin.",
			Category -> "General",
			Developer-> True
		}
	}
}];
