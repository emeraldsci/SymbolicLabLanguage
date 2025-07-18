(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,VolumetricFlask],
	{
		Description->"A protocol that verifies an operator's ability to fill a volumetric flask.",
		CreatePrivileges->None,
		Cache->Session,
		Fields -> {
			VolumetricFlasks -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Container, Vessel, VolumetricFlask],Object[Container, Vessel, VolumetricFlask]],
				Description -> "The volumetric flasks that were used to test the user's ability to measure amounts of a test sample using volumetric flasks.",
				Category -> "Volumetric Flask Skills"
			},
			VolumetricFlaskBuffer->{
				Units -> None,
				Relation -> (Model[Sample]|Object[Sample]),
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The buffer that will be transferred to test the user's volumetric flask usage skills. As specified in FillToVolumeUnitOperations, the VolumetricFlasks are initially filled with the buffer to the specified SampleVolumes in the model of the qualification. The buffer then serves as the solvent to bring the solution up to the target volumes.",
				Category -> "Volumetric Flask Skills"
			},
			InitialTransferGraduatedCylinders -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Container, GraduatedCylinder],Object[Container, GraduatedCylinder]],
				Description -> "For each member of VolumetricFlasks, the graduated cylinder used to transfer the initial SampleVolume of VolumetricFlaskBuffer into the flask before starting the FillToVolume step.",
				Category -> "Volumetric Flask Skills",
				IndexMatching -> VolumetricFlasks
			},
			InitialTransferFunnels -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Part, Funnel], Object[Part, Funnel]],
				Description -> "For each member of VolumetricFlasks, the funnel used to guide pouring the VolumetricFlaskBuffer from the InitialTransferGraduatedCylinder into the flask during the initial transfer step.",
				Category -> "Volumetric Flask Skills",
				IndexMatching -> VolumetricFlasks
			},
			VolumetricFlaskGraduatedCylinders -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Container, GraduatedCylinder],Object[Container, GraduatedCylinder]],
				Description -> "For each member of VolumetricFlasks, the graduated cylinder used to transfer the VolumetricFlaskBuffer during the FillToVolume step. This field may be Null if no graduated cylinder is required for small-volume transfers.",
				Category -> "Volumetric Flask Skills",
				IndexMatching -> VolumetricFlasks
			},
			VolumetricFlaskFunnels -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Part, Funnel], Object[Part, Funnel]],
				Description -> "For each member of VolumetricFlasks, the funnel used to guide pouring the VolumetricFlaskBuffer from the VolumetricFlaskGraduatedCylinder into the flask during the FillToVolume step. This field may be Null if no graduated cylinder or funnel is needed for small-volume transfers.",
				Category -> "Volumetric Flask Skills",
				IndexMatching -> VolumetricFlasks
			},
			VolumetricFlaskIntermediateContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Container, Vessel],Object[Container, Vessel]],
				Description -> "For each member of VolumetricFlasks, the container into which the VolumetricFlaskBuffer is decanted prior to final transfer into the flask using VolumetricFlaskTransferPipets.",
				Category -> "Volumetric Flask Skills",
				IndexMatching -> VolumetricFlasks
			},
			VolumetricFlaskTransferPipets -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[Model[Item, Consumable],Object[Item, Consumable]],
				Description -> "For each member of VolumetricFlasks, the disposable transfer pipet used to perform drop-by-drop transfers of VolumetricFlaskBuffer from the VolumetricFlaskIntermediateContainer into the flask, ensuring precise FillToVolume accuracy.",
				Category -> "Volumetric Flask Skills",
				IndexMatching -> VolumetricFlasks
			},
			FillToVolumeUnitOperations -> {
				Format->Multiple,
				Class->Expression,
				Pattern:>SamplePreparationP,
				Description->"A set of unit operations specifying the initial transfers of VolumetricFlaskBuffer into VolumetricFlasks and the follow-up transfers to fill the VolumetricFlasks to the target volumes.",
				Category -> "Volumetric Flask Skills"
			}
		}
	}
]