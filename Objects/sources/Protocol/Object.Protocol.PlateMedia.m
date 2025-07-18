(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol,PlateMedia],{
	Description->"A protocol for pumping liquid media from its preparatory container to incubation plates.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		PlatingMethods->{
			Format->Multiple,
			Class->Expression,
			Pattern:>MediaPlatingMethodP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates the method by the prepared stock solution is transferred from its preparatory container to plates.",
			Category->"General",
			Abstract->True
		},
		Instruments->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument], Object[Instrument]],
			Description->"The instrument(s) used to pump the liquid media from the container in which it was prepared to multiple incubation plates in a serial fashion.",
			Category->"General"
		},
		Incubators->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Instrument],Object[Instrument]],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the device used to heat and mix the liquid media, thereby maintaining a constant temperature and uniformity throughout the liquid for pumping the media to fill incubation plates.",
			Category->"General"
		},
		Volumes->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{GreaterEqualP[0*Milliliter]..},
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the volume of media transferred from SamplesIn to the destination plate.",
			Category->"General"
		},
		DestinationWells->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{_String..},
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the destination wells and plates into which the prepared media was transferred.",
			Category->"General"
		},
		Temperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the temperature at which the autoclaved media with gelling agents is incubated prior to and during the media plating process.",
			Category->"General"
		},
		PrePlatingIncubationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the duration of time for which the media will be heated/cooled with optional stirring to the target PlatingTemperature.",
			Category -> "General"
		},
		MaxPrePlatingIncubationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the maximum duration of time for which the media will be allowed to be heated/cooled with optional stirring to the target PlatingTemperature.",
			Category -> "General"
		},
		MixRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*RPM],
			Units->RPM,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the rate at which the stir bar within the container housing the heated media is rotated prior to pumping.",
			Category->"General"
		},
		PouringRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[(0*Liter)/Minute],
			Units->Liter/Minute,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the volume of media per unit time transferred from the media's source container to the destination plates by the plate pouring instrument.",
			Category->"General"
		},
		SolidificationTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the duration of time after transferring heated media containing gelling agents into incubation plates, for which they are held at ambient temperature for the media to solidify before allowing them to be used for experiments.",
			Category->"General"
		},
		PlatesOut->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container],Model[Container]],
			Description->"The plates into which the prepared media will be transferred.",
			Category->"Experimental Results"
		},
		PlatesOutGrouped->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{ObjectP[]..},
			Description->"The plates into which the prepared media will be transferred, grouped by SamplesIn.",
			Category->"Experimental Results",
			Developer->True
		},
		NumbersOfPlates->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0,1],
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates the number of plates to which the prepared media should be transferred.",
			Category->"Experimental Results"
		},
		PouringFailed->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates if the media was not successfully transferred from the container in which it was prepared to the incubation plates due to the inability of the peristalic pump to transfer the media from its container to plates because it was too viscous when incubated at the specified temperatures.",
			Category->"Experimental Results"
		},
		FullyThawed->{
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates whether the current media is fully liquefied after incubation.",
			Category->"General",
			Developer->True
		},
		TotalIncubationTimes->{
			Format->Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			IndexMatching -> SamplesIn,
			Description->"For each member of SamplesIn, the total time the sample has been incubated prior to pouring into plates.",
			Category->"General",
			Developer->True
		},
		Tips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Tips] | Model[Item, Tips],
			Description -> "Tips required to pour the media.",
			Category -> "General",
			Developer -> True
		},
		TransferEnvironment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, BiosafetyCabinet] | Model[Instrument, BiosafetyCabinet],
			Description -> "The biosafety cabinet used to pour plates.",
			Category -> "General",
			Developer -> True
		},
		BiosafetyWasteBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, WasteBin] | Model[Container, WasteBin],
			Description -> "Waste bins used in the biosafety cabinet.",
			Category -> "General",
			Developer -> True
		},
		BiosafetyWasteBag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Consumable] | Model[Item, Consumable],
			Description -> "Waste bags used in the biosafety cabinet.",
			Category -> "General",
			Developer -> True
		},
		BiosafetyWasteBinPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {
				Alternatives[
					Object[Container,WasteBin],
					Model[Container,WasteBin],
					Object[Item,Consumable],
					Model[Item,Consumable]
				],
				Alternatives[
					Object[Instrument,BiosafetyCabinet],
					Model[Instrument,BiosafetyCabinet],
					Object[Container,WasteBin],
					Model[Container,WasteBin]
				],
				Null
			},
			Headers -> {"Objects to move", "Object to move to", "Position to move to"},
			Description -> "The specific positions into which waste bin objects should be moved into the biosafety cabinet at the beginning of the protocol.",
			Category -> "General",
			Developer -> True
		},
		FlameSource -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part,Lighter]|Object[Part,Lighter],
			Description -> "Specifies the part used to heat destination with a flame to remove bubbles.",
			Category -> "Temperature Equilibration",
			Developer -> True
		},
		PlateBags -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Bag, Aseptic],Model[Container, Bag, Aseptic]],
			Description -> "The aseptic bags in which the prepared media plates will be stored.",
			Category -> "Experimental Results"
		},
		PlateBagsGrouped -> {
			Format->Multiple,
			Class->Expression,
			Pattern:>{(ObjectP[]|Null)...},
			Description->"The aseptic bags in which the prepared media plates will be stored, grouped by SamplesIn.",
			Category->"Experimental Results",
			Developer->True
		},
		PlateBagPlacements->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{ObjectP[], ObjectP[]|Null, LocationPositionP}...}|Null,
			Description -> "The specific bags into which the specific plates should be placed after pouring.",
			Category -> "Experimental Results",
			Developer -> True
		}
	}
}];
