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
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, the instrument used to pump the liquid media from the container in which it was prepared to multiple incubation plates in a serial fashion.",
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
			IndexMatching->SamplesIn,
			Relation->Alternatives[Object[Container],Model[Container]],
			Description->"For each member of SamplesIn, the plates into which the prepared media will be transferred.",
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
			IndexMatching->SamplesIn,
			Description->"For each member of SamplesIn, indicates whether the media is fully liquified after incubation.",
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
		}
	}
}];