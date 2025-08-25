(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, BiosafetyCabinet], {
	Description -> "A protocol that verifies the functionality of the biosafety cabinet target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Qualification Parameters *)
		TestLight -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the biosafety cabinet's lights are functional.",
			Category -> "Qualification Parameters"
		},
		TestUVLight -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the biosafety cabinet's ultraviolet lights are functional.",
			Category -> "Qualification Parameters"
		},
		TestAlarm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the biosafety cabinet throws an alarm when the sash is at working height.",
			Category -> "Qualification Parameters"
		},
		RecordFlowSpeed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should record the speed of the air entering the sample chamber opening when the biosafety cabinet's sash is at working height.",
			Category -> "Qualification Parameters"
		},
		RecordLaminarFlowSpeed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should record the speed of the filtered air flowing down to the sample chamber surface when the biosafety cabinet's sash is at working height.",
			Category -> "Qualification Parameters"
		},
		ImageCertification -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should take a photograph of the biosafety cabinet's certification sticker.",
			Category -> "Qualification Parameters"
		},
		(* Experimental Results *)
		Light -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the biosafety cabinet's lights are functional.",
			Category -> "Experimental Results"
		},
		UVLight -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the biosafety cabinet's ultraviolet lights are functional.",
			Category -> "Experimental Results"
		},
		Alarm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the biosafety cabinet throws an alarm when the sash is at working height.",
			Category -> "Experimental Results"
		},
		LaminarFlowSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Foot / Minute, 999 Foot/Minute],
			Units -> Foot / Minute,
			Description -> "The recorded velocity of filtered air flowing down to the sample chamber surface when the biosafety cabinet's sash is at working height.",
			Category -> "Experimental Results"
		},
		FlowSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Foot / Minute, 999 Foot/Minute],
			Units -> Foot / Minute,
			Description -> "The recorded velocity of filtered air entering the sample chamber opening when the biosafety cabinet's sash is at working height.",
			Category -> "Experimental Results"
		},
		CertificationImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photograph taken of the biosafety cabinet's certification sticker during this qualification.",
			Category -> "Experimental Results"
		}
	}
}];