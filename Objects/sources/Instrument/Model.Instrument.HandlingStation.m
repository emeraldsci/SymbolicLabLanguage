(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, HandlingStation], {
	Description -> "The model of station that provides a specific handling environment while recording useful metadata (e.g. videos and photographs) that contextualizes the events associated with transfers between samples.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		BalanceType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BalanceModeP,
			Description -> "The scale of balance (Micro, Analytical, Macro, etc) that is contained within this Model of Handling Station for determining the mass of samples transferred.",
			Category -> "Instrument Specifications"
		},
		(* TODO 1) TransferEnvironment / TransferEnvironmentOption in ExperimentTransfer will need work by Sci-Qual / Sci-Infra. Support of Model[Container, Enclosure] and Object[Container, Enclosure] needs to be removed (micro balance have enclosure transfer environments?). 2) use ModifyOptions when ExperimentTransfer has been changed. The below pattern is originally from TransferEnvironmentOption with Model[Container, Enclosure] and all Objects removed. *)
		(*
		HandlingEnvironment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{
				Model[Instrument, BiosafetyCabinet],
				Model[Instrument, FumeHood],
				Model[Instrument, GloveBox],
				Model[Container, Bench]
			}],
			Description -> "The instrument or container used to isolate the transferred samples from the rest of the laboratory and personnel. Examples include Biosafety Cabinet, Fume Hood, Glove Box, or Bench.",
			Category -> "Instrument Specifications"
		},
		*)
		NumberOfVideoCameras -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Indicates how many cameras are present within the HandlingStation for streaming the actions of an operator.",
			Category -> "Instrument Specifications"
		},
		Ventilated -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this instrument is connected to a negative pressure source. This field does not guarantee a high flow rate, for instance, the ventilation flow rate may vary from 20-50 CFM inside of an enclosure to 100-400 CFM inside of a fumehood.",
			Category -> "Instrument Specifications"
		},
		Deionizing -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this instrument is equipped with a deionizer that intends to mitigate accumulated electrostatic charge from handled samples and containers before weighing.",
			Category -> "Instrument Specifications"
		},
		HermeticTransferCompatible -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this instrument is equipped with the nitrogen and argon gases, regulators, and valves needed to backfill containers during hermetic transfers.",
			Category -> "Instrument Specifications"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the handling station in {X (left-to-right), Y (back-to-front), Z (bottom-to-top)} directions where sample handling and transfer occur.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		ProvidedHandlingConditions -> {
			Relation -> Model[HandlingCondition],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The physical environments such as integration with ventilation, balance, UV-C light, and etc inside this instrument, which the samples are handled inside of. Handling in this case involves opening the container the sample resides in and adding to, removing, or measuring some of the sample.",
			Category -> "General"
		}
	}
}];
