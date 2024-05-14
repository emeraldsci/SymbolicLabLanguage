(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Aspirator], {
	Description->"A device that aspirates liquid out of a container or instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TipConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TipConnectionTypeP,
			Description -> "The mechanism by which tips connects to this aspirator, when the aspirator is being used without the multichannel attachment.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MultichannelTipConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TipConnectionTypeP,
			Description -> "The mechanism by which tips connects to this aspirator, when the multichannel attachment is installed to the base of the aspirator.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument]|Model[Part, HandPump],
			Description -> "Vacuum pump used to aspirate liquid.",
			Category -> "Instrument Specifications"
		},
		Channels -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of channels that the aspirator can be configured to aspirate with.",
			Category -> "Instrument Specifications"
		},
		ChannelOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance between the centers of each of the channels that this pipette has.",
			Category -> "Instrument Specifications"
		}
	}
}];
