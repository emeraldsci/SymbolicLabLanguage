(* ::Package:: *)

DefineObjectType[Object[Qualification, FumeHood], {
	Description -> "A protocol that verifies the functionality of the fume hood target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Qualification Parameters *)
		TestLight -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the fume hood's lights are functional.",
			Category -> "Qualification Parameters"
		},
		TestAlarm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should test whether the fume hood's flow meter throws an alarm when the sash is at working height.",
			Category -> "Qualification Parameters"
		},
		RecordFlowSpeed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should record the air passing through the opening of the fume hood when the sash is at working height.",
			Category -> "Qualification Parameters"
		},
		ImageCertification -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the qualification should take a photograph of the fume hood's certification sticker.",
			Category -> "Qualification Parameters"
		},
		(* Experimental Results *)
		Light -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the fume hood's lights are functional.",
			Category -> "Experimental Results"
		},
		Alarm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the fume hood's flow meter throws an alarm when the sash is at working height.",
			Category -> "Experimental Results"
		},
		FlowSpeed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Foot / Minute],
			Units -> Foot / Minute,
			Description -> "The recorded velocity of air passing through the opening of the fume hood when the sash is at working height.",
			Category -> "Experimental Results"
		},
		SashAlarmThreshold -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			Description -> "If the fume hood's flow meter throws an alarm when the sash is at working height (Alarm = False), this is the percentage that the sash must be open (working height = 100%, completely closed = 0%) to record a flow speed greater than the instrument model's MinFlowSpeed.",
			Category -> "Experimental Results"
		},
		CertificationImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photograph taken of the fume hood's certification sticker during this qualification.",
			Category -> "Experimental Results"
		}
	}
}];