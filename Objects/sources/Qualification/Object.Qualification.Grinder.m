(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, Grinder], {
	Description -> "A protocol that verifies the functionality of the grinder target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		QualificationSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample] | Object[Sample],
			Description -> "The sample used to verify whether a grinder effectively reduces the particle sizes of a powder.",
			Category -> "General"
		},
		Amount -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			Description -> "The mass of the sample ground into a fine powder via a grinder.",
			Category -> "General"
		},
		BulkDensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Gram / Milliliter],
			Units -> Gram / Milliliter,
			Description -> "The mass of a volume unit of the powder. The volume for calculating BulkDensity includes the volumes of particles, internal pores, and inter-particle void spaces. This parameter is used to calculate the volume of a powder from its mass (Amount). The volume, in turn, is used along with the fineness in PreferredGrinder to determine a suitable grinder instrument if Instrument is not specified.",
			Category -> "General"
		},
		GrindingRate -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0 RPM] | GreaterEqualP[0 Hertz],
			Description -> "The speed of the circular motion of the grinding tool at which the sample is ground into a fine powder in a BallMill or KnifeMill.",
			Category -> "General"
		},
		Time -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The duration for which the solid substance is ground into a fine powder in the grinder.",
			Category -> "General"
		},
		NumberOfGrindingSteps -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "The number of times that the grinding process is interrupted for cool down to completely grind the sample and prevent excessive heating. Between each grinding step, there is a cooling period during which the grinder is switched off to allow the sample to cool and prevent an excessive rise in its temperature.",
			Category -> "General"
		},
		CoolingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The duration of time that the grinder is switched off between after each grinding step to cool down the sample and prevent overheating.",
			Category -> "General"
		},
		CoarsePowderImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image file of the sample before grinding.",
			Category -> "Passing Criteria"
		},
		FinePowderImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image file of the sample after grinding.",
			Category -> "Passing Criteria"
		},
		ImagingDirection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ImagingDirectionP,
			Description -> "The direction from which the sample is imaged.",
			Category -> "General"
		}
	}
}];