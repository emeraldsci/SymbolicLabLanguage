(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, PipettingLinearity], {
	Description->"A protocol that verifies the linearity of the volumes pipetted by the liquid handler target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		LabArea -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LabAreaP,
			Description -> "Indicates the area of the lab in which this Qualification occurs.",
			Category -> "General"
		},
		Buffer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The model or sample describing the liquid that will be used in this Qualification to test the linearity of the pipettors.",
			Category -> "Reagent Preparation"
		},
		BufferVolumes -> {
			Format -> Multiple,
			Class -> {Expression, Real, Integer, Integer},
			Pattern :> {WellP, GreaterEqualP[0*(Micro*Liter)], GreaterP[0, 1], GreaterP[0, 1]},
			Units -> {None, Liter Micro, None, None},
			Description -> "The volumes that will be pipetted into each well for this Qualification. The plate index indicates the plate number when there is more than one plate.",
			Category -> "General",
			Headers -> {"Well", "Volume", "Pipetting channel", "Plate index"}
		},
		TotalBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Microliter],
			Units -> Liter,
			Description -> "The total buffer volume required to complete the procedure.",
			Category -> "Reagent Preparation"
		},
		FluorescentReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The model or sample describing the fluorescent reagent that will be used to quantify the amount of liquid pipetted.",
			Category -> "Reagent Preparation"
		},
		FluorescentVolumes -> {
			Format -> Multiple,
			Class -> {Expression, Real, Integer, Integer},
			Pattern :> {WellP, GreaterP[0*(Micro*Liter)], GreaterP[0, 1], GreaterP[0, 1]},
			Units -> {None, Liter Micro, None, None},
			Description -> "The fluorescent sample volumes that will be pipetted into each well for this Qualification. The plate index indicates the plate numnber when there is more than one plate.",
			Category -> "General",
			Headers -> {"Well", "Volume", "Pipetting channel", "Plate index"}
		},
		TotalFluorescenceVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Microliter],
			Units -> Liter,
			Description -> "The total amount of fluorescent reagent volume required to complete the procedure.",
			Category -> "Reagent Preparation"
		},
		AssayPlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The plates containing the pipetted fluorescence reagent and buffer mixtures that will be measured and tested.",
			Category -> "Sample Preparation"
		},
		Tips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The model of the pipette tips used for this Qualification.",
			Category -> "Sample Preparation"
		},
		DilutionProgram -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Qualification],
			Description -> "The program containing detailed instructions for a robotic liquid handler to dilute and aliquot the fluorescence samples.",
			Category -> "Sample Preparation"
		},
		LiquidHandlerDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample], Null},
			Description -> "A list of container placements used to set-up the robotic liquid handler deck for liquid handling.",
			Category -> "Placements",
			Developer -> True,
			Headers->{"Container","Position"}
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The location of the robotic liquid handler method file used to pipette liquid into assay plates.",
			Category -> "General",
			Developer -> True
		},
		LiquidHandlerMethodKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The program key for the robotic liquid handler method used to pipette liquid into assay plates.",
			Category -> "General",
			Developer -> True
		},
		PipettingChannels -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> {GreaterP[0, 1]..},
			Units -> None,
			Description -> "The pipetting channels on the target that are tested in the Qualification.",
			Category -> "Sample Preparation"
		},
		NumberOfPlates -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of assay plates used in the Qualification.",
			Category -> "Sample Preparation"
		},
		ExcitationWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The wavelength of light used to excite the samples.",
			Category -> "Fluorescence Measurement"
		},
		EmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Nano*Meter],
			Units -> Meter Nano,
			Description -> "The primary wavelength at which fluorescence emitted from the samples is measured.",
			Category -> "Fluorescence Measurement"
		},
		FluorescenceIntensityProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,FluorescenceIntensity],
			Description -> "The protocol in which the fluorescence intensity of the assay plates are measured.",
			Category -> "Fluorescence Measurement"
		},
		FittingAnalysis ->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The linearity of fluorescence data obtained from samples pipetted by each pipette channel.",
			Category -> "Analysis & Reports"
		},
		RValues -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The square root of adjusted R squared values for each pipette channel tested in the Qualification.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		ChannelFluorescence -> {
			Format -> Multiple,
			Class -> {Real,Expression,Integer},
			Pattern :> {GreaterEqualP[0*Micromolar],DistributionP[RFU],GreaterP[0]},
			Description -> "The standard deviation in fluorescence values for each pipette channel tested in the Qualification in the form: {Fluorescence concentration, Distribution, Channel number}.",
			Units -> {Micromolar,None,None},
			Category -> "Experimental Results",
			Headers -> {"Fluorescein Concentration", "Fluorescence","Pipette Channel"},
			Abstract -> True
		},
		Results -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "The Qualification result for each pipette probe indicated in boolean.",
			Category -> "Experimental Results"
		}
	}
}];
