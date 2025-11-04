(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation, Cover], {
	Description -> "A detailed set of parameters that specifies the information of how to secure caps, lids, or plate seals to the tops of containers in order to secure their contents.",
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
			Description -> "The samples whose containers will be covered.",
			Category -> "General",
			Migration->SplitField
		},
		SampleString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "The samples whose containers will be covered.",
			Category -> "General",
			Migration->SplitField
		},
		SampleExpression -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
			Relation -> Null,
			Description -> "The samples whose containers will be covered.",
			Category -> "General",
			Migration->SplitField
		},
		SampleLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SampleContainerLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		CoverType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CoverTypeP,
			Description -> "For each member of SampleLink, the type of cover (Crimp, Seal, Screw, Snap, or Place) that should be used to cover the container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		UsePreviousCover -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the previous cover should be used to re-cover this container. Note that the previous cover cannot be used if it is discarded or if CoverType->Crimp|Seal.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Opaque -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if an opaque cover is used to cover the container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		CoverLink -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Lid],
				Object[Item, Lid],
				Model[Item, Cap],
				Object[Item, Cap],
				Model[Item, Consumable],
				Object[Item, Consumable],
				Model[Item, PlateSeal],
				Object[Item, PlateSeal]
			],
			Description -> "For each member of SampleLink, the cap, lid, or plate seal that should be secured to the top of the given container.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		CoverString -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SampleLink, the cap, lid, or plate seal that should be secured to the top of the given container.",
			Category -> "General",
			IndexMatching -> SampleLink,
			Migration->SplitField
		},
		CoverLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "For each member of CoverLink, the label of the cover that are being used in the experiment, which is used for identification elsewhere in sample preparation.",
			Category -> "General",
			IndexMatching -> CoverLink
		},
		Septum -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Septum],
				Object[Item, Septum]
			],
			Description -> "For each member of SampleLink, the septum that is used in conjunction with the cover to secure the top of the given container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Stopper -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Stopper],
				Object[Item, Stopper]
			],
			Description -> "For each member of SampleLink, the stopper that is used in conjunction with the crimped cap to secure the top of the given container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		CapRack -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack],
				Model[Container,Deck],
				Object[Container,Deck]
			],
			Description -> "For each member of SampleLink, the cap rack that should be used to hold and identify the cap, if it does not have a barcode because it is too small.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		CrimpingJig -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,CrimpingJig],
				Object[Part,CrimpingJig]
			],
			Description -> "The jig used to position the covered containers with the head of the instrument for optimum crimping alignment.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Crimper],
				Object[Instrument, Crimper],

				Model[Part, Crimper],
				Object[Part, Crimper],

				Model[Instrument, PlateSealer],
				Object[Instrument, PlateSealer]
			],
			Description -> "For each member of SampleLink, the device used to help secure the cover to the top of the container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Decrimper -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Decrimper],
				Object[Part, Decrimper]
			],
			Description -> "For each member of SampleLink, the device used to remove the crimped cap if it was not placed on the container securely.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		CrimpingHead -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, CrimpingHead],
				Object[Part, CrimpingHead]
			],
			Description -> "The part that attaches to the crimper instrument and is used to attached crimped caps to vials.",
			Category -> "General"
		},
		DecrimpingHead -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, DecrimpingHead],
				Object[Part, DecrimpingHead]
			],
			Description -> "The part that attaches to the crimper instrument and is used to remove crimped caps from vials.",
			Category -> "General"
		},
		CrimpingPressure -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The pressure of the gas that is connected to the pneumatic crimper and determines the strength used to crimp or decrimp the crimped cap.",
			Category -> "General"
		},
		MeasuredCrimpingPressureData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Pressure],
			Description -> "The measured pressure of the gas that is connected to the pneumatic crimper and determines the strength used to crimp or decrimp the crimped cap.",
			Category -> "Experimental Results"
		},
		Temperature -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SampleLink, the temperature that will be used to heat the foil for sealing a plate.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Time -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of SampleLink, the duration of time used for applying Temperature to seal the plate.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		PlateSealAdapter -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Container,Rack],Object[Container,Rack]],
			Description->"For each member of SampleLink, the rack used to secure the container on the deck of the plate sealer instrument.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		PlateSealPaddle -> {
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Item, PlateSealRoller],Object[Item, PlateSealRoller]],
			Description->"For each member of SampleLink, the film sealing paddle used to secure the adhesive seal film to the top of the container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Parafilm -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if Parafilm should be used to secure the cover after it is attached to the container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		AluminumFoil -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if Aluminum Foil should be wrapped around the entire container after the cover is attached in order to protect the container's contents from light.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		KeckClamp -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Clamp],
				Object[Item, Clamp]
			],
			Description -> "For each member of SampleLink, the Keck Clamp that is used to secure a tapered stopper Cap to the tapered ground glass joint opening of the Container.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		KeepCovered -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if the cover on this container should be \"peeked\" off when transferred into/out of instead of taken off completely when performing Manual Transfers. When performing robotic manipulations, this indicates that the container should be re-covered after any manipulation that uncovers it is completed.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		SterileTechnique -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SampleLink, indicates if a sterile environment should be used for the covering.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		Environment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Model[Container, Bench],
				Model[Container, OperatorCart],

				Object[Instrument],
				Object[Container],
				Object[Item],
				Object[Part]
			],
			Description -> "For each member of SampleLink, the environment that should be used to perform the covering.",
			Category -> "General",
			IndexMatching -> SampleLink
		},
		AdditionalCrimpedCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item],
				Object[Item]
			],
			Description -> "The additional crimped caps that we need to retry the crimping, if the initial crimping was too loose or too tight.",
			Category -> "General"
		}
	}
}];