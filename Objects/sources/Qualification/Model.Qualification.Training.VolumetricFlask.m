(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Training,VolumetricFlask],
	{
		Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to fill a volumetric flask.",
		CreatePrivileges->None,
		Cache->Session,
		Fields -> {
			VolumetricFlaskModels->{
				Units -> None,
				Relation -> Model[Container, Vessel, VolumetricFlask],
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The model(s) of volumetric flasks that will be used to test the user's ability to measure amounts of a test sample using volumetric flasks. Note that the same model can be repeated for fidelity.",
				Category -> "Volumetric Flask Skills"
			},
			VolumetricFlaskBufferModel->{
				Units -> None,
				Relation -> Model[Sample],
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The model of buffer that will be transferred to test the user's volumetric flask usage skills. Initially, the flasks are filled with the specified SampleVolumes of buffer. The buffer then serves as the solvent to bring the solution up to the target volume. Defaults to MilliQ water.",
				Category -> "Volumetric Flask Skills"
			},
			SampleVolumes->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Microliter],
				Units->Microliter,
				Description->"For each member of VolumetricFlaskModels, indicates the initial volume of VolumetricFlaskBufferModel transferred into the volumetric flask prior to initiating the FillToVolume step.",
				IndexMatching->VolumetricFlaskModels,
				Category -> "Volumetric Flask Skills"
			},
			GradingCriteria->{
				Format -> Multiple,
				Class -> Real,
				Pattern:>GreaterP[0],
				Units->Percent,
				IndexMatching -> VolumetricFlaskModels,
				Description -> "For each member of VolumetricFlaskModels, the permitted percentage deviation from the target volume (MaxVolume of VolumetricFlaskModels) based weight measurements. For example, if a 100-milliliter volumetric flask is used and the GradingCriteria is set to 2 percent, then the acceptable deviation is less than or equal to 2 milliliters for the training practical to be considered a pass.",
				Category -> "Passing Criteria"
			}
		}
	}
]