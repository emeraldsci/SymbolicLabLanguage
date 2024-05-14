

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, Dialysis], {
	Description->"Protocol for removing small molecules from a sample by diffusion.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of sample loading into the dialysis membrane.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> True
		},
		LoadingPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Pipette], Object[Instrument, Pipette]],
			Description -> "The pipette controllers used to load the SampleVolumes into the dialysis tubing.",
			Category->"Sample Preparation"
		},
		LoadingPipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The pipette tips used to load the SampleVolumes into dialysis tubing.",
			Category -> "Sample Preparation"
		},
		DialysisMethod->{
			Format->Single,
			Class->Expression,
			Pattern:> DynamicDialysis|StaticDialysis|EquilibriumDialysis,
			Description->"The dialysis type used to remove impurities from the sample.",
			Category->"General",
			Abstract -> True
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Dialyzer],
				Object[Instrument,Dialyzer],
				Model[Instrument,Vortex],
				Object[Instrument,Vortex],
				Model[Instrument,OverheadStirrer],
				Object[Instrument,OverheadStirrer],
				Model[Instrument,HeatBlock],
				Object[Instrument,HeatBlock]
			],
			Description -> "The instrument used to perform the dialysis.",
			Category -> "General",
			Abstract -> True
		},
		DialysisMembranes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container,Vessel,Dialysis],
				Model[Container,Vessel,Dialysis],
				Object[Container,Plate,Dialysis],
				Model[Container,Plate,Dialysis],
				Object[Item,DialysisMembrane],
				Model[Item,DialysisMembrane]
			],
			Description->"For each member of SamplesIn, the membrane used to remove impurities from the sample.",
			Category->"General",
			IndexMatching->SamplesIn,
			Abstract -> True
		},
		DialysisMembraneSources->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Item,DialysisMembrane],
				Object[Item,DialysisMembrane]
			],
			Description->"For each member of SamplesIn, the membrane that the DialysisMembranes pieces were cut off of.",
			Category->"General",
			IndexMatching->SamplesIn,
			Abstract -> True
		},
		DialysisMembraneLengths->{
			Format->Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Millimeter],
			Units -> Millimeter,
			Description->"For each member of SamplesIn, the length of dialysis membrane tubing.",
			Category->"General",
			IndexMatching->SamplesIn
		},
		DialysisClips->{
			Format->Multiple,
			Class->{Link,Link},
			Pattern:>{_Link,_Link},
			Relation->{Model[Part,DialysisClip]|Object[Part,DialysisClip], Model[Part,DialysisClip]|Object[Part,DialysisClip]},
			Headers-> {"Bottom Clip", "Top Clip"},
			Description->"For each member of SamplesIn, the bottom and top clips used to close the dialysis membrane tubing.",
			Category->"General",
			IndexMatching->SamplesIn
		},
		FloatingRacks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,FloatingRack],Object[Container,FloatingRack]],
			Description->"For each member of SamplesIn, the container used to submerge the dialysis membrane inside the dialysate.",
			Category->"General",
			IndexMatching->SamplesIn
		},
		EquilibriumDialysisRacks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Plate],Object[Container,Plate]],
			Description->"For each member of SamplesIn, the container used to hold DialysisMembranes during equilibrium dialysis.",
			Category->"General"
		},
		DialysisMembraneSoakSolutions -> {
			Format -> Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, the liquid the DialysisMembrane is soaked in to remove the membrane's preservation solution.",
			Category -> "General"
		},
		DialysisMembraneSoakVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, the amount liquid the DialysisMembrane is soaked in to remove the membrane's preservation solution.",
			Category -> "General"
		},
		DialysisMembraneSoakContainers -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, the amount liquid the DialysisMembrane is soaked in to remove the membrane's preservation solution.",
			Category -> "General"
		},
		DialysisMembraneSoakTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, the duration of time the DialysisMembrane should be soaked to remove the membrane's preservation solution.",
			Category -> "General"
		},
		DialysisMembraneSoakPrimitives-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer of dialysis membrane soak solution into a container before the DialysisMembrane is soaked.",
			Category -> "General"
		},
		DialysisMembraneSoakWaitPrimitives-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the time the DialysisMembrane sits in soak solution.",
			Category -> "General"
		},
		DialysisMembraneSoakRemovePrimitives-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer of dialyis membrane soak solution out of the DialysisMembrane.",
			Category -> "General"
		},
		WasteContainer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container],Model[Container]],
			Description->"A waste beaker used to collect solutions which will not be recouped.",
			Category -> "General"
		},
		SampleLoadingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the sample transfer of the experimental samples into the DialysisMembranes prior to the dialysis.",
			Category -> "Sample Preparation"
		},
		SampleLoadingManipulations ->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"Sample manipulations protocols used to load the samples into the DialysisMembranes and the dialysate into dialysate containers prior to the dialysis.",
			Category->"Sample Preparation"
		},
		DialysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "Indicates the duration of time for which the samples will be dialyzed in the first round of dialysis..",
			Category -> "Equilibration",
			Abstract -> True
		},
		SecondaryDialysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "Indicates the duration of time for which the samples will be dialyzed in the second round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		TertiaryDialysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "Indicates the duration of time for which the samples will be dialyzed in the third round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		QuaternaryDialysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "Indicates the duration of time for which the samples will be dialyzed in the fourth round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		QuinaryDialysisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "Indicates the duration of time for which the samples will be dialyzed in the fifth round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		Dialysates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, the dialysis buffer used by this experiment in the first round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		SecondaryDialysates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, the dialysis buffer the Dialysate is replaced with for the second round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		TertiaryDialysates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, the dialysis buffer the Dialysate is replaced with for the third round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		QuaternaryDialysates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, the dialysis buffer the Dialysate is replaced with for the fourth round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		QuinaryDialysates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Model[Sample],
			IndexMatching->SamplesIn,
			Description -> "For each member of SamplesIn, the dialysis buffer the Dialysate is replaced with for the fifth round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		DialysateVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the Dialysate used by this experiment in the first round of dialysis..",
			IndexMatching -> SamplesIn,
			Category -> "Equilibration",
			Abstract -> True
		},
		SecondaryDialysateVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the Dialysate used by this experiment in the second round of dialysis.",
			IndexMatching -> SamplesIn,
			Category -> "Equilibration",
			Abstract -> True
		},
		TertiaryDialysateVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the Dialysate used by this experiment in the third round of dialysis.",
			IndexMatching -> SamplesIn,
			Category -> "Equilibration",
			Abstract -> True
		},
		QuaternaryDialysateVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the Dialysate used by this experiment in the fourth round of dialysis.",
			IndexMatching -> SamplesIn,
			Category -> "Equilibration",
			Abstract -> True
		},
		QuinaryDialysateVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the Dialysate used by this experiment in the fifth round of dialysis.",
			IndexMatching -> SamplesIn,
			Category -> "Equilibration",
			Abstract -> True
		},
		DialysatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer of the Dialysate into the DialysateContainer prior to the first round of dialysis.",
			Category -> "Sample Preparation"
		},
		SecondaryDialysatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer of the Dialysate into the DialysateContainer prior to the second round of dialysis.",
			Category -> "Sample Preparation"
		},
		TertiaryDialysatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer of the Dialysate into the DialysateContainer prior to the third round of dialysis.",
			Category -> "Sample Preparation"
		},
		QuaternaryDialysatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer of the Dialysate into the DialysateContainer prior to the fourth round of dialysis.",
			Category -> "Sample Preparation"
		},
		QuinaryDialysatePrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer of the Dialysate into the DialysateContainer prior to the fifth round of dialysis.",
			Category -> "Sample Preparation"
		},
		DialysateTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature the Dialysates are held during this experiment in the first round of dialysis..",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		SecondaryDialysateTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature the Dialysates are held during this experiment in the second round of dialysis.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		TertiaryDialysateTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature the Dialysates are held during this experiment in the third round of dialysis.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		QuaternaryDialysateTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature the Dialysates are held during this experiment in the fourth round of dialysis.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		QuinaryDialysateTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature the Dialysates are held during this experiment in the fifth round of dialysis.",
			Category -> "Sample Preparation",
			Abstract -> True
		},
		DialysateContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The dialysis container used to hold the Dialysate and sample in the first round of dialysis.",
			Category-> "Equilibration"
		},
		SecondaryDialysateContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The dialysis container used to hold the Dialysate and sample in the second round of dialysis.",
			Category-> "Equilibration"
		},
		TertiaryDialysateContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The dialysis container used to hold the Dialysate and sample in the third round of dialysis.",
			Category-> "Equilibration"
		},
		QuaternaryDialysateContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The dialysis container used to hold the Dialysate and sample in the fourth round of dialysis.",
			Category-> "Equilibration"
		},
		QuinaryDialysateContainer->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The dialysis container used to hold the Dialysate and sample in the fifth round of dialysis.",
			Category-> "Equilibration"
		},
		StirBar->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Part,StirBar],
				Model[Part,StirBar]
			],
			Description->"The magnetic bar used to mix the dialysates in dialysis containers.",
			Category-> "Equilibration"
		},
		StirBarRetriever -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, StirBarRetriever],
				Model[Part, StirBarRetriever]
			],
			Description -> "The magnet and handle used to remove the StirBar from the Dialysate.",
			Category -> "Equilibration",
			Developer -> True
		},
		DialysisMixRate ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The frequency of rotation the mixing instrument should use to mix the dialysate in the first round of dialysis..",
			Category -> "Equilibration",
			Abstract -> True
		},
		DialysisMixRateSetting -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Value at which the dial or digital setting of the mixing instrument has to be set to achieve the desired DialysisMixRate.",
			Category -> "Equilibration",
			Developer -> True
		},
		SecondaryDialysisMixRate ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The frequency of rotation the mixing instrument should use to mix the dialysate in the second round of dialysis..",
			Category -> "Equilibration",
			Abstract -> True
		},
		SecondaryDialysisMixRateSetting -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Value at which the dial or digital setting of the mixing instrument has to be set to achieve the desired SecondaryDialysisMixRate.",
			Category -> "Equilibration",
			Developer -> True
		},
		TertiaryDialysisMixRate ->{
			Format -> Single,
			Class -> Real,
			Pattern :>GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The frequency of rotation the mixing instrument should use to mix the dialysate in the third round of dialysis..",
			Category -> "Equilibration",
			Abstract -> True
		},
		TertiaryDialysisMixRateSetting -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Value at which the dial or digital setting of the mixing instrument has to be set to achieve the desired TertiaryDialysisMixRate.",
			Category -> "Equilibration",
			Developer -> True
		},
		QuaternaryDialysisMixRate ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The frequency of rotation the mixing instrument should use to mix the dialysate in the fourth round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		QuaternaryDialysisMixRateSetting -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Value at which the dial or digital setting of the mixing instrument has to be set to achieve the desired QuaternaryDialysisMixRate.",
			Category -> "Equilibration",
			Developer -> True
		},
		QuinaryDialysisMixRate ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The frequency of rotation the mixing instrument should use to mix the dialysate in the fifth round of dialysis.",
			Category -> "Equilibration",
			Abstract -> True
		},
		QuinaryDialysisMixRateSetting -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "Value at which the dial or digital setting of the mixing instrument has to be set to achieve the desired QuinaryDialysisMixRate.",
			Category -> "Equilibration",
			Developer -> True
		},
		EquilibrationProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
			Description -> "The incubation protocols used to equilibrate the samples and dialysates during dialysis.",
			Category -> "Equilibration"
		},
		DialysateSamplingVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volume of the Dialysate to store after the experiment is complete.",
			IndexMatching -> SamplesIn,
			Category -> "Storage Information"
		},
		SecondaryDialysateSamplingVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the SecondaryDialysate to store after the experiment is complete.",
			IndexMatching -> SamplesIn,
			Category -> "Storage Information"
		},
		TertiaryDialysateSamplingVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the TertiaryDialysate to store after the experiment is complete.",
			IndexMatching -> SamplesIn,
			Category -> "Storage Information"
		},
		QuaternaryDialysateSamplingVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the QuaternaryDialysate to store after the experiment is complete.",
			IndexMatching -> SamplesIn,
			Category -> "Storage Information"
		},
		QuinaryDialysateSamplingVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the QuinaryDialysate to store after the experiment is complete.",
			IndexMatching -> SamplesIn,
			Category -> "Storage Information"
		},
		DialysateContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the Dialysate after the prototocol is complete.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		SecondaryDialysateContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the SecondaryDialysate after the prototocol is complete.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		TertiaryDialysateContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the TertiaryDialysate after the prototocol is complete.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		QuaternaryDialysateContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the QuaternaryDialysate after the prototocol is complete.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		QuinaryDialysateContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the QuinaryDialysate after the prototocol is complete.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		DialysateSamplingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer sampling volumes of Dialysates into the DialysateContainersOut after the first round of dialysis.",
			Category -> "Storage Information"
		},
		SecondaryDialysateSamplingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer sampling volumes of SecondaryDialysates into the SecondaryDialysateContainersOut after the second round of dialysis.",
			Category -> "Storage Information"
		},
		TertiaryDialysateSamplingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer sampling volumes of TertiaryDialysates into the TertiaryDialysateContainersOut after the third round of dialysis.",
			Category -> "Storage Information"
		},
		QuaternaryDialysateSamplingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer sampling volumes of QuaternaryDialysates into the QuaternaryDialysateContainersOut after the fourth round of dialysis.",
			Category -> "Storage Information"
		},
		QuinaryDialysateSamplingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer sampling volumes of QuinaryDialysates into the QuinaryDialysateContainersOut after the firth round of dialysis.",
			Category -> "Storage Information"
		},
		DialysateStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the condition under which the Dialysate sampled by this experiment should be stored after the protocol is completed.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		SecondaryDialysateStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the conditions under which the SecondaryDialysate sampled by this experiment should be stored after the protocol is completed.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		TertiaryDialysateStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the conditions under which the TertiaryDialysate sampled by this experiment should be stored after the protocol is completed.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		QuaternaryDialysateStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the conditions under which the QuaternaryDialysate sampled by this experiment should be stored after the protocol is completed.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		QuinaryDialysateStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the conditions under which the QuinaryDialysate used by this experiment should be stored after the protocol is completed.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		RetentateSamplingStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the conditions the sampling volume taken out of sample after the first round of dialysis are stored after the experiment is complete.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		SecondaryRetentateSamplingStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the conditions the sampling volume taken out of sample after the second round of dialysis are stored after the experiment is complete.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		TertiaryRetentateSamplingStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the conditions the sampling volume taken out of sample after the third round of dialysis are stored after the experiment is complete.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		QuaternaryRetentateSamplingStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the conditions the sampling volume taken out of sample after the fouth round of dialysis are stored after the experiment is complete.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		RetentateStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(SampleStorageTypeP|Disposal),
			Description->"For each member of SamplesIn, the conditions under which the sample dialyzed by this experiment should be stored after the protocol is completed.",
			Category->"Storage Information",
			IndexMatching->SamplesIn
		},
		RetentateSamplingVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the sample dialyzed in the first round of dialysis to store after the experiment is complete.",
			IndexMatching -> SamplesIn,
			Category -> "Storage Information"
		},
		SecondaryRetentateSamplingVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the sample dialyzed in the second round of dialysis to store after the experiment is complete.",
			IndexMatching -> SamplesIn,
			Category -> "Storage Information"
		},
		TertiaryRetentateSamplingVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the sample dialyzed in the third round of dialysis to store after the experiment is complete.",
			IndexMatching -> SamplesIn,
			Category -> "Storage Information"
		},
		QuaternaryRetentateSamplingVolumes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Milliliter,10 Liter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, the volumes of the sample dialyzed in the fourth round of dialysis to store after the experiment is complete.",
			IndexMatching -> SamplesIn,
			Category -> "Storage Information"
		},
		SamplingPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description -> "The pipette controllers used to remove RetentateSamplingVolumes out of dialysis tubing.",
			Category -> "Storage Information"
		},
		SamplingPipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The pipette tips used to remove RetentateSamplingVolumes out of dialysis tubing.",
			Category -> "Storage Information"
		},
		SecondarySamplingPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description -> "The pipette controllers used to remove SecondaryRetentateSamplingVolumes out of dialysis tubing.",
			Category -> "Storage Information"
		},
		SecondarySamplingPipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The pipette tips used to remove SecondaryRetentateSamplingVolumes out of dialysis tubing.",
			Category -> "Storage Information"
		},
		TertiarySamplingPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description -> "The pipette controllers used to remove TertiaryRetentateSamplingVolumes out of dialysis tubing.",
			Category -> "Storage Information"
		},
		TertiarySamplingPipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The pipette tips used to remove TertiaryRetentateSamplingVolumes out of dialysis tubing.",
			Category -> "Storage Information"
		},
		QuaternarySamplingPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description -> "The pipette controllers used to remove QuaternaryRetentateSamplingVolumes out of dialysis tubing.",
			Category -> "Storage Information"
		},
		QuaternarySamplingPipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The pipette tips used to remove QuaternaryRetentateSamplingVolumes out of dialysis tubing.",
			Category -> "Storage Information"
		},
		RetentateSamplingContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the sampling volume taken out of the sample after the first round of dialysis.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		SecondaryRetentateSamplingContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the sampling volume taken out of the sample after the second round of dialysis.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		TertiaryRetentateSamplingContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the sampling volume taken out of the sample after the third round of dialysis.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		QuaternaryRetentateSamplingContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the sampling volume taken out of the sample after the fourth round of dialysis.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		RetentateSamplingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer sampling volumes of the retentate into the RetentateContainersOut after the first round of dialysis.",
			Category -> "Storage Information"
		},
		SecondaryRetentateSamplingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer sampling volumes of the retentate into the SecondaryRetentateContainersOut after the second round of dialysis.",
			Category -> "Storage Information"
		},
		TertiaryRetentateSamplingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer sampling volumes of the retentate into the TertiaryRetentateContainersOut after the third round of dialysis.",
			Category -> "Storage Information"
		},
		QuaternaryRetentateSamplingPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer sampling volumes of the retentate into the QuaternaryRetentateContainersOut after the fourth round of dialysis.",
			Category -> "Storage Information"
		},
		SamplingManipulations ->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"Sample manipulations protocols used to take samplings of retentate and dialysate after dialysis.",
			Category->"Storage Information"
		},
		RetentateContainersOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of SamplesIn, the container that should be used to hold the sample dialyzed by this experiment after the protocol is complete.",
			Category-> "Storage Information",
			IndexMatching->SamplesIn
		},
		CollectionPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,Pipette],
				Object[Instrument,Pipette]
			],
			Description -> "The pipette controllers used to remove Retentate out of dialysis tubing after the final round of dialysis.",
			Category -> "Storage Information"
		},
		CollectionPipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "Pipette tips used to remove Retentate out of dialysis tubing after the final round of dialysis.",
			Category -> "Storage Information"
		},
		RetentateCollectionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "A set of instructions specifying the transfer of the retentate into the RetentateContainersOut after the final round of dialysis.",
			Category -> "Storage Information"
		},
		RetentateCollectionManipulations ->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"Sample manipulations protocols used to transfer the retentate into the RetentateContainersOut after the final round of dialysis.",
			Category->"Storage Information"
		},
		FlowRate->{
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0.004 Milliliter/Minute, 184 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "The average rate in which the dialysate is flowed across the sample, as controlled by a peristaltic pump.",
			Category -> "General",
			Abstract -> True
		},
		DynamicDialysisMethod->{
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Recirculation|SinglePass],
			Description -> "The mode the Instrument will be set up.",
			Category -> "General",
			Abstract -> True
		},
		ImageSystem->{
			Format->Single,
			Class->Boolean,
			Pattern :> BooleanP,
			Description->"Indicates whether images of the dynamic dialysis object will be taken before and after equilibration.",
			Category -> "General"
		},
		InitialDialysisSystemAppearance->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, an image of dialysis setup taken immediately before equilibration.",
			Category -> "Equilibration"
		},
		FinalDialysisSystemAppearance->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			IndexMatching -> SamplesIn,
			Description -> "For each member of SamplesIn, an image of dialysis setup taken immediately after equilibration.",
			Category -> "Equilibration"
		},

		(*TODO:add in after it is possible*)
		(*)ImagingInterval->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Day],
			Units->Hour,
			Description->"The amount of time for between each image of the system.",
			Category->"Equilibration",
			Developer -> True
		},*)
		RunTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Day],
			Units->Hour,
			Description->"For each member of SamplesIn, the estimated time for which the sample is dialyzed.",
			Category->"Equilibration",
			IndexMatching->SamplesIn
		},
		BatchedSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Units -> None,
			Description -> "The list of samples that will be dialyzed simultaneously as part of the same 'batch'.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedSampleIndexes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The index in WorkingSamples in BatchedSamples lengths.",
			Category -> "Batching",
			Developer -> True
		},
		BatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"Parameters describing the length of each batch.",
			Category->"Batching",
			Developer->True
		},
		DialysateBatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"Parameters describing the length of each batch.",
			Category->"Batching",
			Developer->True
		},
		BatchingSingle -> {
			Format -> Multiple,
			Class -> {
				FloatingRack -> Link,
				DialysateContainer -> Link,
				SecondaryDialysateContainer -> Link,
				TertiaryDialysateContainer -> Link,
				QuaternaryDialysateContainer -> Link,
				QuinaryDialysateContainer -> Link,
				DialysisMembraneSoakTime->Real
			},
			Pattern :> {
				FloatingRack -> _Link,
				DialysateContainer -> _Link,
				SecondaryDialysateContainer -> _Link,
				TertiaryDialysateContainer -> _Link,
				QuaternaryDialysateContainer -> _Link,
				QuinaryDialysateContainer -> _Link,
				DialysisMembraneSoakTime-> GreaterP[0 Minute]
			},
			Relation -> {
				FloatingRack ->Alternatives[Object[Container,FloatingRack],Model[Container,FloatingRack]],
				DialysateContainer ->Alternatives[Object[Container],Model[Container]],
				SecondaryDialysateContainer -> Alternatives[Object[Container],Model[Container]],
				TertiaryDialysateContainer -> Alternatives[Object[Container],Model[Container]],
				QuaternaryDialysateContainer -> Alternatives[Object[Container],Model[Container]],
				QuinaryDialysateContainer -> Alternatives[Object[Container],Model[Container]],
				DialysisMembraneSoakTime-> Null
			},
			Units -> {
				FloatingRack -> None,
				DialysateContainer -> None,
				SecondaryDialysateContainer -> None,
				TertiaryDialysateContainer -> None,
				QuaternaryDialysateContainer -> None,
				QuinaryDialysateContainer -> None,
				DialysisMembraneSoakTime-> Minute
			},
			Headers -> {
				FloatingRack -> "FloatingRack",
				DialysateContainer -> "DialysateContainer",
				SecondaryDialysateContainer -> "SecondaryDialysateContainer",
				TertiaryDialysateContainer -> "TertiaryDialysateContainer",
				QuaternaryDialysateContainer -> "QuaternaryDialysateContainer",
				QuinaryDialysateContainer -> "QuinaryDialysateContainer",
				DialysisMembraneSoakTime-> "DialysisMembraneSoakTimes"
			},
			Description -> "For each member of BatchLengths, the measurement setup values shared by each sample in the batch.",
			Category -> "Batching",
			Developer -> True
		},
		BatchingMultiple -> {
			Format -> Multiple,
			Class -> {
				DialysisMembraneSoakSolution -> Link,
				Dialysate -> Link,
				SecondaryDialysate -> Link,
				TertiaryDialysate -> Link,
				QuaternaryDialysate -> Link,
				QuinaryDialysate -> Link,
				DialysisMembraneSoakContainers -> Link,
				DialysisMembranes-> Link,
				SampleVolumes->Real,
				DialysisMembraneSoakVolumes->Real,
				BottomDialysisClip->Link,
				TopDialysisClip->Link
			},
			Pattern :> {
				DialysisMembraneSoakSolution-> _Link,
				Dialysate-> _Link,
				SecondaryDialysate -> _Link,
				TertiaryDialysate -> _Link,
				QuaternaryDialysate -> _Link,
				QuinaryDialysate -> _Link,
				DialysisMembraneSoakContainers -> _Link,
				DialysisMembranes-> _Link,
				SampleVolumes-> GreaterP[0 Milliliter],
				DialysisMembraneSoakVolumes-> GreaterP[0 Milliliter],
				BottomDialysisClip->_Link,
				TopDialysisClip->_Link
			},
			Relation -> {
				DialysisMembraneSoakSolution-> Alternatives[Model[Sample],Object[Sample]],
				Dialysate-> Alternatives[Model[Sample],Object[Sample]],
				SecondaryDialysate->Alternatives[Model[Sample],Object[Sample]],
				TertiaryDialysate->Alternatives[Model[Sample],Object[Sample]],
				QuaternaryDialysate ->Alternatives[Model[Sample],Object[Sample]],
				QuinaryDialysate ->Alternatives[Model[Sample],Object[Sample]],
				DialysisMembraneSoakContainers -> Alternatives[Model[Container],Object[Container]],
				DialysisMembranes->Alternatives[
					Object[Container,Vessel,Dialysis],
					Model[Container,Vessel,Dialysis],
					Object[Container,Plate,Dialysis],
					Model[Container,Plate,Dialysis],
					Object[Item,DialysisMembrane],
					Model[Item,DialysisMembrane]
				],
				SampleVolumes-> Null,
				DialysisMembraneSoakVolumes-> Null,
				BottomDialysisClip->Model[Part,DialysisClip]|Object[Part,DialysisClip],
				TopDialysisClip->Model[Part,DialysisClip]|Object[Part,DialysisClip]
			},
			Units -> {
				DialysisMembraneSoakSolution->None,
				Dialysate->None,
				SecondaryDialysate -> None,
				TertiaryDialysate -> None,
				QuaternaryDialysate -> None,
				QuinaryDialysate -> None,
				DialysisMembraneSoakContainers->None,
				DialysisMembranes-> None,
				SampleVolumes-> Milliliter,
				DialysisMembraneSoakVolumes-> Milliliter,
				BottomDialysisClip->None,
				TopDialysisClip->None
			},
			Headers -> {
				DialysisMembraneSoakSolution->"DialysisMembraneSoakSolution",
				Dialysate->"Dialysate",
				SecondaryDialysate ->"SecondaryDialysate",
				TertiaryDialysate -> "TertiaryDialysate",
				QuaternaryDialysate -> "QuaternaryDialysate",
				QuinaryDialysate -> "QuinaryDialysate",
				DialysisMembraneSoakContainers->"DialysisMembraneSoakContainers",
				DialysisMembranes-> "DialysisMembranes",
				SampleVolumes-> "SampleVolumes",
				DialysisMembraneSoakVolumes-> "DialysisMembraneSoakVolumes",
				BottomDialysisClip->"BottomDialysisClip",
				TopDialysisClip->"TopDialysisClip"
			},
			Description -> "For each sample, the setup values in batch order.",
			Category -> "Batching",
			Developer -> True
		},
		BatchingPipettes -> {
			Format -> Multiple,
			Class -> {
				LoadingPipette->Link,
				SamplingPipette->Link,
				SecondarySamplingPipette->Link,
				TertiarySamplingPipette->Link,
				QuaternarySamplingPipette->Link,
				CollectionPipette->Link,
				LoadingPipetteTip->Link,
				SamplingPipetteTip->Link,
				SecondarySamplingPipetteTip->Link,
				TertiarySamplingPipetteTip->Link,
				QuaternarySamplingPipetteTip->Link,
				CollectionPipetteTip->Link
			},
			Pattern :> {
				LoadingPipette->_Link,
				SamplingPipette->_Link,
				SecondarySamplingPipette->_Link,
				TertiarySamplingPipette->_Link,
				QuaternarySamplingPipette->_Link,
				CollectionPipette->_Link,
				LoadingPipetteTip->_Link,
				SamplingPipetteTip->_Link,
				SecondarySamplingPipetteTip->_Link,
				TertiarySamplingPipetteTip->_Link,
				QuaternarySamplingPipetteTip->_Link,
				CollectionPipetteTip->_Link
			},
			Relation -> {
				LoadingPipette->Alternatives[Model[Instrument,Pipette], Object[Instrument,Pipette]],
				SamplingPipette->Alternatives[Model[Instrument,Pipette], Object[Instrument,Pipette]],
				SecondarySamplingPipette->Alternatives[Model[Instrument,Pipette], Object[Instrument,Pipette]],
				TertiarySamplingPipette->Alternatives[Model[Instrument,Pipette], Object[Instrument,Pipette]],
				QuaternarySamplingPipette->Alternatives[Model[Instrument,Pipette], Object[Instrument,Pipette]],
				CollectionPipette->Alternatives[Model[Instrument,Pipette], Object[Instrument,Pipette]],
				LoadingPipetteTip->Alternatives[Model[Item], Object[Item]],
				SamplingPipetteTip->Alternatives[Model[Item], Object[Item]],
				SecondarySamplingPipetteTip->Alternatives[Model[Item], Object[Item]],
				TertiarySamplingPipetteTip->Alternatives[Model[Item], Object[Item]],
				QuaternarySamplingPipetteTip->Alternatives[Model[Item], Object[Item]],
				CollectionPipetteTip->Alternatives[Model[Item], Object[Item]]
			},
			Units -> {
				LoadingPipette->None,
				SamplingPipette->None,
				SecondarySamplingPipette->None,
				TertiarySamplingPipette->None,
				QuaternarySamplingPipette->None,
				CollectionPipette->None,
				LoadingPipetteTip->None,
				SamplingPipetteTip->None,
				SecondarySamplingPipetteTip->None,
				TertiarySamplingPipetteTip->None,
				QuaternarySamplingPipetteTip->None,
				CollectionPipetteTip->None
			},
			Headers -> {
				LoadingPipette->"LoadingPipette",
				SamplingPipette->"SamplingPipette",
				SecondarySamplingPipette->"SecondarySamplingPipette",
				TertiarySamplingPipette->"TertiarySamplingPipette",
				QuaternarySamplingPipette->"QuaternarySamplingPipette",
				CollectionPipette->"CollectionPipette",
				LoadingPipetteTip->"LoadingPipetteTip",
				SamplingPipetteTip->"SamplingPipetteTip",
				SecondarySamplingPipetteTip->"SecondarySamplingPipetteTip",
				TertiarySamplingPipetteTip->"TertiarySamplingPipetteTip",
				QuaternarySamplingPipetteTip->"QuaternarySamplingPipetteTip",
				CollectionPipetteTip->"CollectionPipetteTip"
			},
			Description -> "For each sample, the pipetting resources in batch order.",
			Category -> "Batching",
			Developer -> True
		},
		BatchingVolumes -> {
			Format -> Multiple,
			Class -> {
				DialysateVolumes->Real,
				SecondaryDialysateVolumes->Real,
				TertiaryDialysateVolumes->Real,
				QuaternaryDialysateVolumes->Real,
				QuinaryDialysateVolumes->Real,
				DialysateSamplingVolumes->Real,
				SecondaryDialysateSamplingVolumes->Real,
				TertiaryDialysateSamplingVolumes->Real,
				QuaternaryDialysateSamplingVolumes->Real,
				QuinaryDialysateSamplingVolumes->Real,
				RetentateSamplingVolumes->Real,
				SecondaryRetentateSamplingVolumes->Real,
				TertiaryRetentateSamplingVolumes->Real,
				QuaternaryRetentateSamplingVolumes->Real
			},
			Pattern :> {
				DialysateVolumes-> GreaterP[0 Milliliter],
				SecondaryDialysateVolumes-> GreaterP[0 Milliliter],
				TertiaryDialysateVolumes-> GreaterP[0 Milliliter],
				QuaternaryDialysateVolumes-> GreaterP[0 Milliliter],
				QuinaryDialysateVolumes-> GreaterP[0 Milliliter],
				DialysateSamplingVolumes-> GreaterP[0 Milliliter],
				SecondaryDialysateSamplingVolumes-> GreaterP[0 Milliliter],
				TertiaryDialysateSamplingVolumes-> GreaterP[0 Milliliter],
				QuaternaryDialysateSamplingVolumes-> GreaterP[0 Milliliter],
				QuinaryDialysateSamplingVolumes-> GreaterP[0 Milliliter],
				RetentateSamplingVolumes-> GreaterP[0 Milliliter],
				SecondaryRetentateSamplingVolumes-> GreaterP[0 Milliliter],
				TertiaryRetentateSamplingVolumes-> GreaterP[0 Milliliter],
				QuaternaryRetentateSamplingVolumes-> GreaterP[0 Milliliter]
			},
			Relation -> {
				DialysateVolumes-> Null,
				SecondaryDialysateVolumes-> Null,
				TertiaryDialysateVolumes-> Null,
				QuaternaryDialysateVolumes-> Null,
				QuinaryDialysateVolumes-> Null,
				DialysateSamplingVolumes-> Null,
				SecondaryDialysateSamplingVolumes-> Null,
				TertiaryDialysateSamplingVolumes-> Null,
				QuaternaryDialysateSamplingVolumes-> Null,
				QuinaryDialysateSamplingVolumes-> Null,
				RetentateSamplingVolumes-> Null,
				SecondaryRetentateSamplingVolumes-> Null,
				TertiaryRetentateSamplingVolumes-> Null,
				QuaternaryRetentateSamplingVolumes-> Null
			},
			Units -> {
				DialysateVolumes-> Milliliter,
				SecondaryDialysateVolumes-> Milliliter,
				TertiaryDialysateVolumes-> Milliliter,
				QuaternaryDialysateVolumes-> Milliliter,
				QuinaryDialysateVolumes-> Milliliter,
				DialysateSamplingVolumes-> Milliliter,
				SecondaryDialysateSamplingVolumes-> Milliliter,
				TertiaryDialysateSamplingVolumes-> Milliliter,
				QuaternaryDialysateSamplingVolumes-> Milliliter,
				QuinaryDialysateSamplingVolumes-> Milliliter,
				RetentateSamplingVolumes-> Milliliter,
				SecondaryRetentateSamplingVolumes-> Milliliter,
				TertiaryRetentateSamplingVolumes-> Milliliter,
				QuaternaryRetentateSamplingVolumes-> Milliliter
			},
			Headers -> {
				DialysateVolumes-> "DialysateVolumes",
				SecondaryDialysateVolumes-> "SecondaryDialysateVolumes",
				TertiaryDialysateVolumes-> "TertiaryDialysateVolumes",
				QuaternaryDialysateVolumes-> "QuaternaryDialysateVolumes",
				QuinaryDialysateVolumes-> "QuinaryDialysateVolumes",
				DialysateSamplingVolumes-> "DialysateSamplingVolumes",
				SecondaryDialysateSamplingVolumes-> "SecondaryDialysateSamplingVolumes",
				TertiaryDialysateSamplingVolumes-> "TertiaryDialysateSamplingVolumes",
				QuaternaryDialysateSamplingVolumes-> "QuaternaryDialysateSamplingVolumes",
				QuinaryDialysateSamplingVolumes-> "QuinaryDialysateSamplingVolumes",
				RetentateSamplingVolumes-> "RetentateSamplingVolumes",
				SecondaryRetentateSamplingVolumes-> "SecondaryRetentateSamplingVolumes",
				TertiaryRetentateSamplingVolumes->"TertiaryRetentateSamplingVolumes",
				QuaternaryRetentateSamplingVolumes-> "QuaternaryRetentateSamplingVolumes"
			},
			Description ->"For each sample, the setup volumes values in batch order.",
			Category -> "Batching",
			Developer -> True
		},
		BatchingContainers -> {
			Format -> Multiple,
			Class -> {
				DialysateContainersOut->Link,
				SecondaryDialysateContainersOut->Link,
				TertiaryDialysateContainersOut->Link,
				QuaternaryDialysateContainersOut->Link,
				QuinaryDialysateContainersOut->Link,
				RetentateSamplingContainersOut->Link,
				SecondaryRetentateSamplingContainersOut->Link,
				TertiaryRetentateSamplingContainersOut->Link,
				QuaternaryRetentateSamplingContainersOut->Link,
				RetentateContainersOut->Link
			},
			Pattern :> {
				DialysateContainersOut->_Link,
				SecondaryDialysateContainersOut->_Link,
				TertiaryDialysateContainersOut->_Link,
				QuaternaryDialysateContainersOut->_Link,
				QuinaryDialysateContainersOut->_Link,
				RetentateSamplingContainersOut->_Link,
				SecondaryRetentateSamplingContainersOut->_Link,
				TertiaryRetentateSamplingContainersOut->_Link,
				QuaternaryRetentateSamplingContainersOut->_Link,
				RetentateContainersOut->_Link
			},
			Relation -> {
				DialysateContainersOut->Alternatives[Model[Container],Object[Container]],
				SecondaryDialysateContainersOut->Alternatives[Model[Container],Object[Container]],
				TertiaryDialysateContainersOut->Alternatives[Model[Container],Object[Container]],
				QuaternaryDialysateContainersOut->Alternatives[Model[Container],Object[Container]],
				QuinaryDialysateContainersOut->Alternatives[Model[Container],Object[Container]],
				RetentateSamplingContainersOut->Alternatives[Model[Container],Object[Container]],
				SecondaryRetentateSamplingContainersOut->Alternatives[Model[Container],Object[Container]],
				TertiaryRetentateSamplingContainersOut->Alternatives[Model[Container],Object[Container]],
				QuaternaryRetentateSamplingContainersOut->Alternatives[Model[Container],Object[Container]],
				RetentateContainersOut->Alternatives[Model[Container],Object[Container]]
			},
			Units -> {
				DialysateContainersOut->None,
				SecondaryDialysateContainersOut->None,
				TertiaryDialysateContainersOut->None,
				QuaternaryDialysateContainersOut->None,
				QuinaryDialysateContainersOut->None,
				RetentateSamplingContainersOut->None,
				SecondaryRetentateSamplingContainersOut->None,
				TertiaryRetentateSamplingContainersOut->None,
				QuaternaryRetentateSamplingContainersOut->None,
				RetentateContainersOut->None
			},
			Headers -> {
				DialysateContainersOut->"DialysateContainersOut",
				SecondaryDialysateContainersOut->"SecondaryDialysateContainersOut",
				TertiaryDialysateContainersOut->"TertiaryDialysateContainersOut",
				QuaternaryDialysateContainersOut->"QuaternaryDialysateContainersOut",
				QuinaryDialysateContainersOut->"QuinaryDialysateContainersOut",
				RetentateSamplingContainersOut->"RetentateSamplingContainersOut",
				SecondaryRetentateSamplingContainersOut->"SecondaryRetentateSamplingContainersOut",
				TertiaryRetentateSamplingContainersOut->"TertiaryRetentateSamplingContainersOut",
				QuaternaryRetentateSamplingContainersOut->"QuaternaryRetentateSamplingContainersOut",
				RetentateContainersOut->"RetentateContainersOut"
			},
			Description -> "For each sample, the setup containersout values in batch order.",
			Category -> "Batching",
			Developer -> True
		},
		BatchingStorageConditions -> {
			Format -> Multiple,
			Class -> {
				DialysateStorageCondition->Expression,
				SecondaryDialysateStorageCondition->Expression,
				TertiaryDialysateStorageCondition->Expression,
				QuaternaryDialysateStorageCondition->Expression,
				QuinaryDialysateStorageCondition->Expression,
				RetentateSamplingStorageCondition->Expression,
				SecondaryRetentateSamplingStorageCondition->Expression,
				TertiaryRetentateSamplingStorageCondition->Expression,
				QuaternaryRetentateSamplingStorageCondition->Expression,
				RetentateStorageCondition->Expression,
				SamplesInStorage->Expression
			},
			Pattern :> {
				DialysateStorageCondition->SampleStorageTypeP|Disposal,
				SecondaryDialysateStorageCondition->SampleStorageTypeP|Disposal,
				TertiaryDialysateStorageCondition->SampleStorageTypeP|Disposal,
				QuaternaryDialysateStorageCondition->SampleStorageTypeP|Disposal,
				QuinaryDialysateStorageCondition->SampleStorageTypeP|Disposal,
				RetentateSamplingStorageCondition->SampleStorageTypeP|Disposal,
				SecondaryRetentateSamplingStorageCondition->SampleStorageTypeP|Disposal,
				TertiaryRetentateSamplingStorageCondition->SampleStorageTypeP|Disposal,
				QuaternaryRetentateSamplingStorageCondition->SampleStorageTypeP|Disposal,
				RetentateStorageCondition->SampleStorageTypeP|Disposal,
				SamplesInStorage->SampleStorageTypeP|Disposal
			},
			Relation -> {
				DialysateStorageCondition->Null,
				SecondaryDialysateStorageCondition->Null,
				TertiaryDialysateStorageCondition->Null,
				QuaternaryDialysateStorageCondition->Null,
				QuinaryDialysateStorageCondition->Null,
				RetentateSamplingStorageCondition->Null,
				SecondaryRetentateSamplingStorageCondition->Null,
				TertiaryRetentateSamplingStorageCondition->Null,
				QuaternaryRetentateSamplingStorageCondition->Null,
				RetentateStorageCondition->Null,
				SamplesInStorage->Null
			},
			Units -> {
				DialysateStorageCondition->None,
				SecondaryDialysateStorageCondition->None,
				TertiaryDialysateStorageCondition->None,
				QuaternaryDialysateStorageCondition->None,
				QuinaryDialysateStorageCondition->None,
				RetentateSamplingStorageCondition->None,
				SecondaryRetentateSamplingStorageCondition->None,
				TertiaryRetentateSamplingStorageCondition->None,
				QuaternaryRetentateSamplingStorageCondition->None,
				RetentateStorageCondition->None,
				SamplesInStorage->None
			},
			Headers -> {
				DialysateStorageCondition->"DialysateStorageCondition",
				SecondaryDialysateStorageCondition->"SecondaryDialysateStorageCondition",
				TertiaryDialysateStorageCondition->"TertiaryDialysateStorageCondition",
				QuaternaryDialysateStorageCondition->"QuaternaryDialysateStorageCondition",
				QuinaryDialysateStorageCondition->"QuinaryDialysateContainersOut",
				RetentateSamplingStorageCondition->"RetentateSamplingStorageCondition",
				SecondaryRetentateSamplingStorageCondition->"SecondaryRetentateSamplingStorageCondition",
				TertiaryRetentateSamplingStorageCondition->"TertiaryRetentateSamplingStorageCondition",
				QuaternaryRetentateSamplingStorageCondition->"QuaternaryRetentateSamplingContainersOut",
				RetentateStorageCondition->"RetentateStorageCondition",
				SamplesInStorage->"SamplesInStorage"
			},
			Description -> "For each sample, the storage conditions in batch order.",
			Category -> "Batching",
			Developer -> True
		},
		CurrentDialysates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The shared dialysates in the current batch of dialysis.",
			Category -> "Batching",
			Developer -> True
		},
		WorkSurface -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The location in which the dialysis is performed.",
			Category -> "Equilibration",
			Developer -> True
		},
		CleaningSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solution used to clean the instrument tubing after the dialysis has been completed.",
			Category->"Cleaning",
			Developer->True
		}
	}
}];
