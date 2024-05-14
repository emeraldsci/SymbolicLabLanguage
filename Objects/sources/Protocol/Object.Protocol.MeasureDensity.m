(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, MeasureDensity], {
	Description->"A protocol for quantifying sample density using a density meter, or by manual fixed volume weight method (measuring the weight of a known volume of the sample).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(*Shared items relevant to both manual and density meter methods*)
		BatchedSamplesIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "Input samples for this experiment re-ordered to collect density meter samples first, followed by fixed volume weight samples.",
			Category -> "General",
			Developer->True
		},
		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "Length of the batches of input samples for this experiment re-ordered to collect density meter samples first, followed by fixed volume weight samples.
				The first number corresponds to the number of Density Meter samples, and the second number is the number of Fixed Volume Weight samples.",
			Category -> "General",
			Developer->True
		},
		DensityMethods->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DensityMethodP,
			Description -> "For each member of SamplesIn, the method to use for density measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedMethods->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DensityMethodP,
			Description -> "For each member of BatchLengths, the method to use for density measurement.",
			Category -> "General",
			IndexMatching->BatchLengths,
			Developer->True
		},
		RecoupSample  -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the measured portion of the sample will be transferred back into the source vessel or disposed of after measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedRecoupSample  -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of BatchedSamplesIn, indicates if the measured portion of the sample will be transferred back into the source vessel or disposed of after measurement.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		Volumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume to measure (pipette into MeasurementContainers prior to measuring its weight for manual method, syringe into instrument for density meter).",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of BatchedSamplesIn, the volume to measure (pipette into MeasurementContainers prior to measuring its weight for manual method, syringe into instrument for density meter).",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		WasteContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container],Model[Container]],
			Description->"A waste beaker used to collect samples which will not be recouped.",
			Category -> "General",
			Developer->True
		},

		(*Density meter method files*)
		MethodFiles->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "For each member of SamplesIn, the raw method file used for density meter measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedMethodFiles->{
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of BatchedSamplesIn, the method file to use for density meter measurement.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		BatchedMethodFilesAir -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of BatchedSamplesIn, the method file to use for air density check.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		BatchedMethodFilesWater -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of BatchedSamplesIn, the method file to use for water density check.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		MethodFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The folder file path that contains all of the method files for running the density meter measurement.",
			Category -> "General",
			Developer->True
		},
		(*Density meter data files*)
		DataFiles->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation->Object[EmeraldCloudFile],
			Description -> "For each member of SamplesIn, the data file with the density meter measurement information.",
			Category -> "Experimental Results",
			IndexMatching->SamplesIn
		},
		BatchedDataFiles->{
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of BatchedSamplesIn, the data file with the density meter measurement information.",
			Category -> "Experimental Results",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		DataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The folder file path that contains all of the method files for running the density meter measurement.",
			Category -> "Experimental Results",
			Developer->True
		},

		(*Density meter items*)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument,DensityMeter],Model[Instrument,DensityMeter]],
			Description -> "The density meter instrument used to measure the density of the sample.",
			Category -> "General"
		},
		(*TODO: delete after air water check hotfix has merged*)
		AirWaterCheck -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Whether to perform air-water check maintenance on the instrument prior to starting the measurement (true if it has been >24 hours since the last check).",
			Category -> "General",
			Developer->True
		}, 
		AirWaterChecks -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the density of air, water and air will be measured before measuring the density of sample.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		BatchedAirWaterChecks -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of BatchedSamplesIn, indicates if the density of air, water and air will be measured before measuring the density of sample.",
			Category -> "General",
			IndexMatching -> BatchedSamplesIn
		},
		Temperature->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature to use for density meter measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedTemperature->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of BatchedSamplesIn, the temperature to use for density meter measurement.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		ViscosityCorrection  -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, determines if viscosity correction should be automatically applied during density meter measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedViscosityCorrection  -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of BatchedSamplesIn, determines if viscosity correction should be automatically applied during density meter measurement.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		PreWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The first pre-wash solution to use before density meter measurement.",
			Category -> "General"
		},

		WashSolution->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of SamplesIn, the first wash solution to use after density meter measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedWashSolution->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of BatchedSamplesIn, the first wash solution to use after density meter measurement.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		SecondaryPreWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The second pre-wash solution to use before density meter measurement.",
			Category -> "General"
		},
		SecondaryWashSolution->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of SamplesIn, the second wash solution to use after density meter measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedSecondaryWashSolution->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of BatchedSamplesIn, the second wash solution to use after density meter measurement.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		TertiaryPreWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The third pre-wash solution to use before density meter measurement.",
			Category -> "General"
		},
		TertiaryWashSolution->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of SamplesIn, the third wash solution to use after density meter measurement.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedTertiaryWashSolution->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[Object[Sample],Model[Sample]],
			Description -> "For each member of BatchedSamplesIn, the third wash solution to use after density meter measurement.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		AirWaterCheckSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The AirWaterCheck solution to use after density measurement of single sample or between samples.",
			Category -> "General"
		},
		AirWaterCheckSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe used to transfer the water used for the air water check into the instrument.",
			Category -> "General"
		},
		WashCycles->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units-> None,
			Description -> "For each member of SamplesIn, the number of wash cycles (using primary, secondary ant tertiary wash solutions once per cycle) to perform in between each sample run.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedWashCycles->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units-> None,
			Description -> "For each member of BatchedSamplesIn, the number of wash cycles (using primary, secondary and tertiary wash solutions once per cycle) to perform in between each sample run.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		WashVolume->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of each wash solution to use for cleaning the density meter chamber in between sample measurements.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedWashVolume->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of BatchedSamplesIn, the volume of each wash solution to use for cleaning the density meter chamber in between sample measurements.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		Needles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of SamplesIn, the needles used with the sample syringe to transfer the sample into the syringe.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedNeedles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of BatchedSamplesIn, the needles used with the sample syringe to transfer the sample into the syringe.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		SampleSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of SamplesIn, the syringe to transfer the sample into the instrument.",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedSampleSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of BatchedSamplesIn, the syringe to transfer the sample into the instrument.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		PreWashSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe used to transfer the pre wash solution from the wash beaker into the instrument.",
			Category -> "General"
		},
		SecondaryPreWashSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe used to transfer the secondary pre wash solution from the wash beaker into the instrument.",
			Category -> "General"
		},
		TertiaryPreWashSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe used to transfer the tertiary pre wash solution from the wash beaker into the instrument.",
			Category -> "General"
		},
		WashSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe used to transfer the wash solution from the wash beaker into the instrument.",
			Category -> "General"
		},
		SecondaryWashSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe used to transfer the secondary wash solution from the wash beaker into the instrument.",
			Category -> "General"
		},
		TertiaryWashSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "The syringe used to transfer the tertiary wash solution from the wash beaker into the instrument.",
			Category -> "General"
		},
		BatchedWashSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of BatchedSamplesIn, the syringe used to transfer the wash solution from the wash beaker into the instrument.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		BatchedSecondaryWashSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of BatchedSamplesIn, the syringe used to transfer the secondary wash solution from the wash beaker into the instrument.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		BatchedTertiaryWashSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Object[Container],
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of BatchedSamplesIn, the syringe used to transfer the tertiary wash solution from the wash beaker into the instrument.",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},

		(*Fixed volume weight items*)
		MeasurementContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container]],
			Description -> "For each member of SamplesIn, the container user the measure the weight of a known volume of that sample (manual fixed volume weight method).",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedMeasurementContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container]],
			Description -> "For each member of BatchedSamplesIn, the container user the measure the weight of a known volume of that sample (manual fixed volume weight method).",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		TareWeights->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of MeasurementContainers, a data object containing the empty weight of that container (manual fixed volume weight method).",
			Category -> "General",
			IndexMatching->MeasurementContainers
		},
		BatchedTareWeights->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of BatchedSamplesIn, a data object containing the empty weight of that container (manual fixed volume weight method).",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		SampleWeights->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of MeasurementContainers, a data object containing the weight of that container with the known volume of that sample added (manual fixed volume weight method).",
			Category -> "General",
			IndexMatching->MeasurementContainers
		},
		BatchedSampleWeights->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "For each member of BatchedSamplesIn, a data object containing the weight of that container with the known volume of that sample added (manual fixed volume weight method).",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		Pipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument],Model[Instrument]],
			Description -> "The pipette used to measure out the amounts being transferred (manual fixed volume weight method).",
			Category -> "General"
		},
		PipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of SamplesIn, the tips used with the pipette performing the transfer (manual fixed volume weight method).",
			Category -> "General",
			IndexMatching->SamplesIn
		},
		BatchedPipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of BatchedSamplesIn, the tips used with the pipette performing the transfer (manual fixed volume weight method).",
			Category -> "General",
			IndexMatching->BatchedSamplesIn,
			Developer->True
		},
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument],Model[Instrument]],
			Description -> "The balance used to measure out the amount being transferred (manual fixed volume weight method).",
			Category -> "General"
		},
		AirCheckData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The density data created by the air check.",
			Category->"Experimental Results"
		},
		WaterCheckData->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The density data created by the water check.",
			Category->"Experimental Results"
		}
	}
}];

