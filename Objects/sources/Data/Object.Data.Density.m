

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, Density], {
	Description->"Measured density of a sample .",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DensityMethodP,
			Description -> "The method used to measure the density of the sample.",
			Category -> "General",
			Abstract->True
		},
		MethodFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the method files used to run the instrument.",
			Category -> "General"
		},
		Density -> {
			Format -> Single,
			Class -> Real,
			Pattern :>DensityP,
			Relation->Null,
			Units ->Gram/(Liter Milli),
			Description -> "Density of the sample as measured by the chosen density measurement method.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		SpecificGravity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units ->None,
			Description -> "Calculated specific gravity (also known as relative density) of the sample from the measured density.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		(*Only for DensityMeter method*)
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units ->Celsius,
			Description -> "Temperature during the density measurement experiment.",
			Category -> "Experimental Results"
		},
		(*Only for FixedVolumeWeight method*)
		TareWeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?MassQ,
			Units ->Gram,
			Description -> "Tare weights of the sample containers used for the manual (fixed weight volume) density measurement experiment.",
			Category -> "Experimental Results"
		},
		SampleWeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?MassQ,
			Units ->Gram,
			Description -> "Measured weights of the samples in their containers for the manual (fixed weight volume) density measurement experiment.",
			Category -> "Experimental Results"
		},
		Volumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Alternatives[Milliliter,Microliter]],
			Units ->Milliliter,
			Description -> "Measured volume of the samples for manual (fixed weight volume) density measurement experiment.",
			Category -> "Experimental Results"
		},
		AirCheck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Density],
			Description -> "Measured density of air during an air water check before the measurement.",
			Category -> "Experimental Results"
		},
		WaterCheck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Density],
			Description -> "Measured density of water during an air water check before the measurement.",
			Category -> "Experimental Results"
		}
	}
}];
