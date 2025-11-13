(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, PrepareReferenceElectrode], {
	Description->"A protocol describing a set of instructions to get one or more reference electrodes of specified models ready to be used in electrochemical experiments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- General --- *)
		ReferenceElectrodes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Electrode, ReferenceElectrode],
				Object[Item, Electrode, ReferenceElectrode]
			],
			Description -> "The reference electrodes get prepared during the course of this protocol. The model of the reference electrode is changed from OriginReferenceElectrodeModel to TargetReferenceElectrodeModel, by filling or refreshing the reference solution within the electrode's glass tube.",
			Category -> "General"
		},

		TargetReferenceElectrodeModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Electrode, ReferenceElectrode],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the final model of the reference electrodes after the electrode is prepared.",
			Category -> "General",
			Abstract -> True
		},

		OriginReferenceElectrodeModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Electrode, ReferenceElectrode],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the starting model of the reference electrode before the electrode is prepared.",
			Category -> "General"
		},

		ReferenceSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the solution used to fill or refresh the ReferenceElectrode to transform the electrode's model to TargetReferenceElectrodeModel.",
			Category -> "General"
		},

		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, FumeHood], Object[Instrument, FumeHood], Model[Instrument, HandlingStation, FumeHood], Object[Instrument, HandlingStation, FumeHood]],
			Description -> "Indicates the fume hood where the reference electrode preparation is performed.",
			Category -> "General",
			Developer -> True
		},

		ElectrodeImagingRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Rack], Object[Container, Rack]],
			Description -> "Indicates the rack to hold the reference electrode when the electrode is being imaged.",
			Category -> "General",
			Developer -> True
		},

		ElectrodeImagingDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Deck], Object[Container, Deck]],
			Description -> "Indicates the deck to place the ElectrodeImagingRack when the electrode is being imaged.",
			Category -> "General",
			Developer -> True
		},

		ReferenceElectrodeRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Rack], Object[Container, Rack]],
			Description -> "Indicates the rack used to hold the reference electrodes upwards during the course of the current protocol.",
			Category -> "General",
			Developer -> True
		},

		(* --- Reference Electrode Polishing --- *)
		PolishReferenceElectrode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, indicates if in the presence of rust, the non-working part (the metal part that does not directly contact experiment solution) of reference electrode is polished with a piece of 1200 grit sandpaper.",
			Category -> "Electrode Polishing"
		},

		Sandpaper -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Consumable, Sandpaper], Object[Item, Consumable, Sandpaper]],
			Description -> "Indicates the sandpaper used to polish the reference electrodes.",
			Category -> "Electrode Polishing"
		},

		PolishingPerformed -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of ReferenceElectrodes, indicates if the electrode is polished in attempt to remove any rust present on the non-working part of the electrode.",
			Category -> "Electrode Polishing"
		},

		ReferenceElectrodeRustChecking -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[None, Both, WorkingPart, NonWorkingPart],
			Description -> "For each member of ReferenceElectrodes, indicates if rust is present on the reference electrode and the location of the observed rust, after the electrode is polished.",
			Category -> "Electrode Polishing"
		},

		(* --- Reference Electrode Cleaning --- *)

		ReferenceElectrodeNeedsAspiration -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, indicates the reference electrode already has a previous reference solution filled and needs aspiration.",
			Category -> "Electrode Cleaning"
		},

		WasteReferenceSolutionCollectionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			Description -> "The container to collect any previous reference solutions stored in the reference electrodes.",
			Category -> "Electrode Cleaning"
		},

		WasteReferenceSolutionCollectionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Syringe], Object[Container, Syringe]],
			Description -> "The syringe (along with its attached needle) used to remove the previous reference solution stored in the reference electrodes into the WasteReferenceSolutionCollectionContainer.",
			Category -> "Electrode Cleaning"
		},

		WasteReferenceSolutionCollectionNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Needle], Object[Item, Needle]],
			Description -> "The needle (along with the syringe it attached to) used to remove the previous reference solution stored in the reference electrodes into the WasteReferenceSolutionCollectionContainer.",
			Category -> "Electrode Cleaning"
		},

		PrimaryWashingSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the first solution used to wash the reference electrode metal part and its glass tube.",
			Category -> "Electrode Cleaning"
		},

		PrimaryWashingSolutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the volume of the PrimaryWashingSolution used in each washing cycle.",
			Category -> "Electrode Cleaning"
		},

		NumberOfPrimaryWashings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the number of cycles the reference electrode is washed by the PrimaryWashingSolution.",
			Category -> "Electrode Cleaning"
		},

		PrimaryWashingSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Syringe], Object[Container, Syringe]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the syringe (along with its attached needle) used to perform the primary washing.",
			Category -> "Electrode Cleaning"
		},

		PrimaryWashingSolutionCollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the container to collect the primary washing solution.",
			Category -> "Electrode Cleaning"
		},

		SecondaryWashingSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the second solution used to wash the reference electrode metal part and its glass tube.",
			Category -> "Electrode Cleaning"
		},

		SecondaryWashingSolutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the volume of the SecondaryWashingSolution used in each washing cycle.",
			Category -> "Electrode Cleaning"
		},

		NumberOfSecondaryWashings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the number of cycles the reference electrode is washed by the SecondaryWashingSolution.",
			Category -> "Electrode Cleaning"
		},

		SecondaryWashingSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Syringe], Object[Container, Syringe]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the syringe (along with its attached needle) used to perform the secondary washing.",
			Category -> "Electrode Cleaning"
		},

		SecondaryWashingSolutionCollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the container to collect the secondary washing solution.",
			Category -> "Electrode Cleaning"
		},

		UniqueWashingSolutions -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0 Milliliter]},
			Units -> {None, Milliliter},
			Relation -> {Alternatives[Model[Sample], Object[Sample]], Null},
			Headers -> {"Washing Solution", "Total Volume"},
			Description -> "The volume used for each unique washing solution. This volume includes the volumes to wash the reference electrode metal part and the electrode glass tube (both inside and outside).",
			Category -> "Electrode Cleaning"
		},

		WashingSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Syringe], Object[Container, Syringe]],
			IndexMatching -> UniqueWashingSolutions,
			Description -> "For each member of UniqueWashingSolutions, the syringe used with the needle to perform the reference electrode washings.",
			Category -> "Electrode Cleaning"
		},

		WashingNeedles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Needle], Object[Item, Needle]],
			IndexMatching -> UniqueWashingSolutions,
			Description -> "For each member of UniqueWashingSolutions, the needle used with the syringe to perform the reference electrode washings.",
			Category -> "Electrode Cleaning"
		},

		WashingSolutionCollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			IndexMatching -> UniqueWashingSolutions,
			Description -> "For each member of UniqueWashingSolutions, the container collecting the used washing solution during the course of this protocol.",
			Category -> "Electrode Cleaning"
		},

		(* --- Reference Electrode Preparation --- *)
		PrimingVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the volume of the ReferenceSolution used to prime the metal part of the reference electrode and the inside of its glass tube in each priming cycle.",
			Category -> "Reference Electrode Preparation"
		},

		NumberOfPrimings -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the number of priming cycles.",
			Category -> "Reference Electrode Preparation"
		},

		ReferenceElectrodePrimingSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Syringe], Object[Container, Syringe]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the syringe (along with its attached needle) used to perform the priming of the electrode's metal part and its glass tube (inside).",
			Category -> "Electrode Cleaning"
		},

		ReferenceElectrodeReferenceSolutionCollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the container to collect the used priming reference solution.",
			Category -> "Electrode Cleaning"
		},

		ElectrodeRefillVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the volume of the ReferenceSolution used fill the reference electrode's glass tube.",
			Category -> "Reference Electrode Preparation"
		},

		ReferenceElectrodeRefillSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Syringe], Object[Container, Syringe]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the syringe (along with its attached needle) used to fill the electrode's glass tube with the reference solution.",
			Category -> "Reference Electrode Preparation"
		},

		ReferenceElectrodeRefillNeedles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Needle], Object[Item, Needle]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, the needle used with the syringe to fill the electrode's glass tube with the reference solution.",
			Category -> "Reference Electrode Preparation"
		},

		UniqueReferenceSolutions -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0 Milliliter]},
			Units -> {None, Milliliter},
			Relation -> {Alternatives[Model[Sample], Object[Sample]], Null},
			Headers -> {"Reference Solution", "Total Volume"},
			Description -> "The total volume used for each unique reference solution. This volume includes the volumes to prime the reference electrode metal part, the electrode glass tube and to refill the glass tube.",
			Category -> "Reference Electrode Preparation"
		},

		PrimingSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Syringe], Object[Container, Syringe]],
			IndexMatching -> UniqueReferenceSolutions,
			Description -> "For each member of UniqueReferenceSolutions, the syringe used with the needle to perform the reference electrode primings and to transfer the reference solution into the glass tube of the reference electrode.",
			Category -> "Reference Electrode Preparation"
		},

		PrimingNeedles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Needle], Object[Item, Needle]],
			IndexMatching -> UniqueReferenceSolutions,
			Description -> "For each member of UniqueReferenceSolutions, the needle used with the syringe to perform the reference electrode primings and to transfer the reference solution into the glass tube of the reference electrode.",
			Category -> "Reference Electrode Preparation"
		},

		ReferenceSolutionCollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			IndexMatching -> UniqueReferenceSolutions,
			Description -> "For each member of UniqueReferenceSolutions, the container collecting the used priming reference solution during the course of this protocol.",
			Category -> "Reference Electrode Preparation"
		},

		ReferenceElectrodePrimingSoakTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, indicates the minimum duration of the reference electrode metal wire or plate will be soaked in the ReferenceSolution within the glass tube after the last priming cycle.",
			Category -> "Reference Electrode Preparation"
		},

		MaxPrimingSoakTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "The maximum value of ReferenceElectrodePrimingSoakTimes.",
			Category -> "Reference Electrode Preparation",
			Developer ->True
		},

		Tweezers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tweezer],
				Object[Item, Tweezer]
			],
			Description -> "The tweezers used to move the reference electrodes in and out of its container.",
			Category -> "Reference Electrode Preparation",
			Developer ->True
		},

		(* --- Storage Information --- *)
		ReferenceElectrodeStorageContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			IndexMatching -> ReferenceElectrodes,
			Description -> "For each member of ReferenceElectrodes, indicates the container in which the prepared reference electrode is transported and stored.",
			Category -> "Storage Information"
		},

		OldReferenceElectrodeStorageContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			Description -> "Indicates the previous containers which stored the reference electrodes. These containers will be replaced by the new storage containers and will be cleaned up.",
			Category -> "Storage Information",
			Developer -> True
		},

		InitialReferenceElectrodeAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The images of the reference electrodes taken immediately before the preparation steps start.",
			Category -> "Storage Information",
			Developer -> True
		},

		FinalReferenceElectrodeAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The images of the reference electrodes taken after the preparation steps are finished.",
			Category -> "Storage Information",
			Developer -> True
		},

		(* --- Resources --- *)
		PreparedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][Preparation],
			IndexMatching -> TargetReferenceElectrodeModels,
			Description -> "For each member of TargetReferenceElectrodeModels, the resource in the parent protocol that is fulfilled by preparing a reference electrode of the target reference electrode model.",
			Category -> "Resources",
			Developer -> True
		}
	}
}];
