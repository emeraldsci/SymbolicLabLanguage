

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, CellFreeze], {
	Description->"A protocol for gradual freezing of cells for long-term storage in the cryogenic freezer.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		DateFrozen -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which the cells were mixed with freezing media and placed in the controlled rate freezer.",
			Category -> "General",
			Abstract -> True
		},
		DateStored -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which the cells were moved from the controlled rate freezer to long term storage in the cryogenic freezer.",
			Category -> "General",
			Abstract -> True
		},
		WashMedia -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Media in which the cells are washed and resuspended in prior to freezing.",
			Category -> "General",
			Abstract -> True
		},
		ResuspensionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Micro,
			Description -> "The volume of wash media used to resuspend the cells after initial centrifugation.",
			Category -> "General"
		},
		WashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Micro,
			Description -> "The volume of wash media used to clean the cell pellet.",
			Category -> "General"
		},
		FreezingMedia -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "A cryoprotectant supplemented media in which the cells are frozen in order to preserve membrane intengrity.",
			Category -> "General",
			Abstract -> True
		},
		FreezingMediaVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Liter],
			Units -> Liter Micro,
			Description -> "The volume of freezing media added to cells prior to freezing.",
			Category -> "General"
		},
		Consolidation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the cells of the same model are combined together prior to freezing.",
			Category -> "General",
			Abstract -> True
		},
		CryoTubes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The cryogenic sample tubes in which the samples are stored.",
			Category -> "General"
		},
		NumberOfTubes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of cryo tubes the cell samples are  frozen into.",
			Category -> "General"
		}
	}
}];
