(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification, PipettingLinearity], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies the linearity of the volumes pipetted by a liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		TipModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The model of the pipetting tip that will be used to test pipetting linearity.",
			Category -> "General"
		},
		PipettingChannels -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The list of pipetting channels to be tested.",
			Category -> "General"
		},
		NumberOfPlates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of plates that will be used for this Qualification.",
			Category -> "General"
		},
		NumberOfReplicates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of replicates per volume per channel that will be tested in pipetting linearity.",
			Category -> "General"
		},
		NumberOfConcentrations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of different concentrations pipetted by each pipette channel to test pipetting linearity.",
			Category -> "General"
		},
		PlateModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of the plate that will be used for this Qualification.",
			Category -> "General"
		},
		FluorescentModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the fluorescent reagent that will be used for detection in this Qualification.",
			Category -> "General"
		},
		FluorescentConcentration->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nanomolar],
			Units -> (Nano Mole)/Liter,
			Description -> "The initial concentration of fluorescent reagent pipetted on the instrument.",
			Category -> "General"
		},
		FluorescentReservoirModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The container in which the fluorescent reagent is prepared in, prior to pipetting.",
			Category -> "General"
		},
		FluorescentDeadVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The dead volume in the FluorescentReservoirModel used to hold the fluorescent reagent. This volume must be accounted for when preparing the fluorescent reagent needed.",
			Category -> "General"
		},
		BufferModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the buffer that will be used in this Qualification.",
			Category -> "General"
		},
		BufferReservoirModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The container in which the buffer is prepared in, prior to pipetting.",
			Category -> "General"
		},
		BufferDeadVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Micro],
			Units -> Liter Micro,
			Description -> "The dead volume in the BufferReservoirModel used to hold the buffer. This volume must be accounted for when preparing the buffer needed.",
			Category -> "General"
		},
		LiquidHandlerMethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The location of the robotic liquid handler method file used to handle sample manipulations.",
			Category -> "General",
			Developer -> True
		},
		PlateReader -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The model of plate reader instrument is used to assess fluorescence intensity.",
			Category -> "General"
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the samples.",
			Category -> "General",
			Abstract -> True
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The primary wavelength at which fluorescence emitted from the samples is measured.",
			Category -> "General",
			Abstract -> True
		},
		PassingRValue -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The threshold for the Coefficient of Correlation calculated from the dataset required to pass the Qualification.",
			Category -> "General",
			Abstract->True
		}
	}
}];
