(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, Degas], {
	Description -> "A detailed set of parameters that specifies the information of how to use a variety of different techniques (freeze-pump-thaw, sparging, or vacuum degassing) to remove dissolved gases from liquid.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		SampleLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Model[Container],
				Object[Container]
			],
			Description -> "The samples that are being degassed.",
			Category -> "General",
			Migration->SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the samples that are being degassed.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source sample that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, the label of the source container that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		DegasType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DegasTypeP,
			Description -> "For each member of SampleLink, the degassing type (freeze-pump-thaw, sparging, or vacuum degassing) should be used. Freeze-pump-thaw involves freezing the liquid, applying a vacuum to evacuate the headspace above the liquid, and then thawing the liquid to allow the decreased pressure of the headspace to lower the solubility of dissolved gases; this is usually repeated a few times to ensure thorough degassing. Sparging involves bubbling a chemically inert gas through the liquid for an extended period of time to aid in removal of dissolved gases. Vacuum degassing involves lowering the pressure of the headspace above the liquid to decrease solubility of the dissolved gases, while continually removing any bubbled out dissolved gases from the headspace.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		Instrument->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,SpargingApparatus],
				Model[Instrument,VacuumDegasser],
				Model[Instrument,FreezePumpThawApparatus],
				Object[Instrument,SpargingApparatus],
				Object[Instrument,VacuumDegasser],
				Object[Instrument,FreezePumpThawApparatus]
			],
			Description->"For each member of SampleLink, the degassing instrument should be used.",
			Category->"Method Information",
			IndexMatching -> SampleLink
		},
		DissolvedOxygen->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates whether dissolved oxygen measurements should be taken using the dissolved oxygen meter, before and after the degassing procedure is performed. The dissolved oxygen measurements can only be taken on aqueous solutions.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		FreezeTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SampleLink, the amount of time the sample will be flash frozen by submerging the container in a dewar filled with liquid nitrogen during the freeze-pump-thaw procedure. This is the first step in the freeze-pump-thaw cycle.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		PumpTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SampleLink, the amount of time the sample will be vacuumed during the pump step of the freeze-pump-thaw procedure. The pump step evacuates the headspace above the frozen sample in preparation for the thawing step.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		ThawTemperature->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the temperature that the heat bath regulator will be set to for thawing the sample during the freeze-pump-thaw procedure.",
			Category ->"Method Information",
			IndexMatching -> SampleLink
		},
		ThawTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SampleLink, the amount of time the sample will be thawed during the freeze-pump-thaw procedure. During the thaw step, the decreased headspace pressure from the pump step will decrease the solubility of dissolved gases in the thawed liquid, thereby causing dissolved gases to bubble out from the liquid as it thaws.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		NumberOfCycles -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[1,1],
			Description -> "For each member of SampleLink, The number of cycles of freezing the sample, evacuating the headspace above the sample, and then thawing the sample that will be performed as part of a single freeze-pump-thaw protocol.",
			IndexMatching -> SampleLink,
			Category ->"Method Information"
		},
		FreezePumpThawContainer -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Vessel],Object[Container,Vessel]],
			Description->"For each member of SampleLink, the container that will hold the sample during Freeze Pump Thaw. No more than 50% of the volume of the container can be filled during Freeze Pump Thaw.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		VacuumPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Milli*Bar],
			Units -> Milli*Bar,
			Description -> "For each member of SampleLink, the vacuum pressure that the vacuum pump regulator will be set to during the vacuum degassing procedure.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		VacuumSonicate->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates whether or not the sample will be agitated by immersing the container in a sonicator during the vacuum degassing method.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		VacuumTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SampleLink, the amount of time the sample will be vacuumed during the vacuum degassing method.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		VacuumUntilBubbleless->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates whether vacuum degassing should be performed until the sample is entirely bubbleless, during the vacuum degassing method.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		MaxVacuumTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SampleLink, the maximum amount of time the sample will be vacuumed during the vacuum degassing procedure.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		SpargingGas -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DegasGasP,
			Description -> "For each member of SampleLink, the inert gas (nitrogen, argon, or helium) will be used during the sparging method.",
			Category ->  "Method Information",
			IndexMatching -> SampleLink
		},
		SpargingTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SampleLink, the amount of time the sample will be sparged during the sparging method.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		SpargingMix->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"For each member of SampleLink, indicates whether the sample will be mixed during the sparging method.",
			Category->"General",
			IndexMatching->SampleLink
		},
		HeadspaceGasFlush -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> DegasGasP|None,
			Description -> "For each member of SampleLink, the inert gas used to replace the headspace after degassing. None indicates that no specific gas will be used and that the sample will be exposed to the atmosphere when capping. For sparging, no headspace gas flushing can be performed.",
			Category ->  "Method Information",
			IndexMatching -> SampleLink
		},
		HeadspaceGasFlushTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SampleLink, the amount of time the sample will be flushed with the headspace gas after degassing.",
			Category -> "Method Information",
			IndexMatching -> SampleLink
		},
		FullyBubbleless -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the sample appears fully bubbleless upon visual inspection, during the vacuum degas process.",
			Category -> "Experimental Results",
			IndexMatching -> SampleLink
		},
		InitialDissolvedOxygen->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link|Null,
			Relation->Object[Protocol,MeasureDissolvedOxygen],
			Description->"For each member of SampleLink, the MeasureDissolvedOxygen protocol generated as a result of the execution of MeasureDissolvedOxygen, which is used to determine the initial dissolved oxygen reading of the sample.",
			Category -> "Experimental Results",
			IndexMatching -> SampleLink
		},
		FinalDissolvedOxygen->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link|Null,
			Relation->Object[Protocol,MeasureDissolvedOxygen],
			Description->"For each member of SampleLink, the MeasureDissolvedOxygen protocol generated as a result of the execution of MeasureDissolvedOxygen, which is used to determine the final dissolved oxygen reading of the sample.",
			Category -> "Experimental Results",
			IndexMatching -> SampleLink
		},
		InitialDissolvedOxygenConcentration->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(DistributionP[Percent]|DistributionP[Milligram/Liter])|Null,
			Description->"For each member of SampleLink, indicates what the dissolved oxygen level of the sample is prior to running the degassing procedure.",
			Category->"Experimental Results",
			IndexMatching -> SampleLink
		},
		FinalDissolvedOxygenConcentration->{
			Format->Multiple,
			Class->Expression,
			Pattern:>(DistributionP[Percent]|DistributionP[Milligram/Liter])|Null,
			Description->"For each member of SampleLink, indicates what the dissolved oxygen level of the sample is prior to running the degassing procedure.",
			Category->"Experimental Results"
		}
	}
}];