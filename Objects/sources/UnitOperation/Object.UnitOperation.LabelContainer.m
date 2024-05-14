(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[UnitOperation,LabelContainer],
	{
		Description->"A detailed set of parameters that labels a sample for later use in a SamplePreparation/CellPreparation experiment.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			Label -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "The label of the samples that will use used to refer to them in other unit operations.",
				Category -> "General"
			},
			ContainerLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "The container object that will be labeled for future use.",
				Category -> "General",
				Migration->SplitField
			},
			ContainerString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The container object that will be labeled for future use.",
				Category -> "General",
				Migration->SplitField
			},
			Restricted -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				Description -> "Indicates whether the sample should be restricted from automatic use is any of your team's experiments that request the sample's models. (Restricted samples can only be used in experiments when specifically provided as input to the experiment functions by a team member). Setting the option to Null means the sample should be untouched. Setting the option to True or False will set the Restricted field of the sample to that value respectively.",
				Category -> "Storage Information"
			}
		}
	}
];
