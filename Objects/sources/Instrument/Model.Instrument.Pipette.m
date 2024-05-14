(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Pipette], {
	Description->"A Model of a handheld instrument for precisely moving small quantities of liquid.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		PipetteType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PipetteTypeP,
			Description -> "Type of pipette used.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TipConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TipConnectionTypeP,
			Description -> "The mechanism by which tips connects to this pipette.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		Controller -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Analog | Digital,
			Description -> "Describes how the required volume is set on the instrument.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Capabilities -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PipetCapabilitiesP,
			Description -> "Advanced capabilities of the pipette beyond just aspiration and dispensing.",
			Category -> "Instrument Specifications"
		},
		Channels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of redundant channels the pipette has.",
			Category -> "Instrument Specifications"
		},
		ChannelOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance between the centers of each of the channels that this pipette has.",
			Category -> "Instrument Specifications"
		},
		ManufacturerCV -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The manufacturer defined coefficient of variation (CV) for the pipette. The CV is defined as the ratio of standard deviation to the mean.",
			Category -> "Instrument Specifications"
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Milli],
			Units -> Liter Milli,
			Description -> "Minimum amount of volume the pipette can transfer.",
			Category -> "Operating Limits"
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Milli],
			Units -> Liter Milli,
			Description -> "Maximum amount of volume the pipette can transfer.",
			Category -> "Operating Limits"
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Micro,
			Description -> "The smallest interval which can be measured by this pipette.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TipTypes -> { (* NOTE: This field is deprecated. Use the TipConnectionType field instead. *)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Tips],
			Description -> "The models of tips compatible with this pipette.",
			Category -> "Operating Limits",
			Developer->True
		}
	}
}];
