(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

With[{
	insertMe=Sequence@@$ObjectUnitOperationAbsorbanceSpectroscopyFields,
	insertMe2=Sequence@@$ObjectUnitOperationPlateReaderBaseFields
},
	DefineObjectType[Object[UnitOperation,AbsorbanceSpectroscopy], {
		Description->"A detailed set of parameters that specifies a single absorbance reading step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			QuantifyConcentration -> {
				Format -> Multiple,
				Class -> Boolean,
				Pattern :> BooleanP,
				IndexMatching -> SampleLink,
				Description -> "For each member of SampleLink, indicates if the concentration of the sample is determined.",
				Category -> "Quantification"
			},
			QuantificationAnalyte -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> IdentityModelTypeP,
				Description -> "For each member of SampleLink, the substance whose concentration should be determined during this experiment.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},
			QuantificationWavelength -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0 Nanometer],
				Units -> Nanometer,
				Description -> "For each member of SampleLink, the wavelength at which quantification analysis is performed to determine concentration.",
				Category -> "Quantification",
				IndexMatching -> SampleLink
			},

			insertMe,
			insertMe2
		}
	}]
];
