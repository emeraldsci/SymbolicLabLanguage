(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Autoclave], {
	Description->"A protocol that uses the autoclave to sterilize and exterminate any micro-organisms present in the input samples/containers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "Autoclave used to sterilize and exterminate micro-organisms present in the input samples.",
			Category -> "Autoclave Setup"
		},
		AutoclaveProgram -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> AutoclaveProgramP,
			Description -> "The type of sterilization program the autoclave will run which is usually chosen according to the materials that are being autoclaved (liquids or dry samples).",
			Category -> "Autoclave Setup",
			Abstract -> True
		},
		AutoclavedInputs->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Object[Item]
			],
			Description->"The containers and the self-contained samples that are placed into the autoclave and sterilized.",
			Category->"Sterilizing",
			Developer->True
		},
		SterilizationBagPlacements->{
			Format->Multiple,
			Class->{Link,Link,String},
			Pattern:>{_Link,_Link,LocationPositionP},
			Relation->{
				Alternatives[
					Object[Container],
					Object[Item]
				],
				Alternatives[
					Object[Container,Bag,Autoclave],
					Model[Container,Bag,Autoclave]
				],
				Null
			},
			Description->"A list of placements used to move the input samples to be bagged into the autoclave bags into which they are sealed prior to being placed into the autoclave and sterilized.",
			Category->"Sterilizing",
			Headers->{"Bagged Input","Autoclave Bag","Position"}
		},
		SterilizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute, 1*Minute],
			Units -> Minute,
			Description -> "The nominal length of time for which the sterilization cycle is run, when any micro-organisms present in the autoclave chamber are exterminated. This time excludes chamber conditioning time and time to return to ambient conditions.",
			Category -> "Sterilizing"
		},
		SterilizationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[100*Celsius, 1*Celsius],
			Units -> Celsius,
			Description -> "The nominal temperature that the autoclave chamber will maintain during the sterilization cycle - when micro-organisms present in the autoclave chamber are exterminated.",
			Category -> "Sterilizing"
		},
		SteamIntegrator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "Chemical indicator used to ascertain that proper sterilization conditions (dependant on steam, time and temperature) are achieved inside the autoclave chamber during operation.",
			Category -> "Sterilizing"
		},
		SteamIntegratorResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SteamIntegratorResultP,
			Description -> "Indicates the result of the SteamIntegrator which checks if sterilization conditions were achieved during the autoclave cycle.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		ImageSamples -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the samples are to be imaged after autoclaving.",
			Category -> "Sample Post-Processing"
		},
		MeasureVolumes -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the volumes of the samples are to be measured after autoclaving.",
			Category -> "Sample Post-Processing"
		},
		AluminumFoil -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "Aluminum foil used to wrap and cover open containers that are to be autoclaved.",
			Category -> "Autoclave Setup",
			Developer -> True
		},
		AutoclaveTape -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "Adhesive tape that can withstand autoclave chamber conditions.",
			Category -> "Autoclave Setup",
			Developer -> True
		},
		SecondaryContainer -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The container that holds the items being autoclaved during autoclaving.",
			Category -> "Autoclave Setup",
			Developer -> True
		},
		CappedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers to be autoclaved that already have caps at the beginning of the protocol and do not need to be covered with aluminum foil.",
			Category -> "Autoclave Setup",
			Developer -> True
		},
		AluminumFoilContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that started the protocol without a cover that are covered with aluminum foil prior to autoclaving.",
			Category -> "Autoclave Setup",
			Developer -> True
		}
	}
}];
