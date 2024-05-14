(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Cover], {
	Description->"A protocol that will secure caps, lids, or plate seals to the tops of containers in order to secure their contents.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CoverTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CoverTypeP,
			Description -> "The type of cover (Crimp, Seal, Screw, Snap, or Place) that should be used to cover the container.",
			Category -> "General"
		},
		UsePreviousCovers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the previous cover should be used to re-cover this container. Note that the previous cover cannot be used if it is discarded or if CoverType->Crimp|Seal.",
			Category -> "General"
		},
		Opaque -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if an opaque cover is used to cover the container.",
			Category -> "General"
		},
		Covers -> {
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
			Description -> "The cap, lid, or plate seal that should be secured to the top of the given container.",
			Category -> "General"
		},
		Septa -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Septum],
				Object[Item, Septum]
			],
			Description -> "The septum that are used in conjunction with the cover to secure the top of the given container.",
			Category -> "General"
		},
		Stoppers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Stopper],
				Object[Item, Stopper]
			],
			Description -> "The stoppers that are used in conjunction with the cover to secure the top of the given container.",
			Category -> "General"
		},
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Crimper],
				Object[Instrument, Crimper],

				Model[Instrument, PlateSealer],
				Object[Instrument, PlateSealer]
			],
			Description -> "The device used to help secure the cover to the top of the container.",
			Category -> "General"
		},
		CrimpingHeads -> {
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
		DecrimpingHeads -> {
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
		CrimpingPressures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The pressure of the gas that is connected to the pneumatic crimper and determines the strength used to crimp or decrimp the crimped cap.",
			Category -> "General"
		},
		CrimpingJigs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,CrimpingJig],
				Object[Part,CrimpingJig]
			],
			Description -> "The jigs used to position covered containers with the head of the instrument for optimum crimping alignment.",
			Category -> "General"
		},
		CapRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack],
				Model[Container,Deck],
				Object[Container,Deck]
			],
			Description -> "The cap racks that should be used to hold and identify the caps, if they do not have a barcode because they are too small.",
			Category -> "General"
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature that will be used to heat the foil for sealing a plate.",
			Category -> "General"
		},
		Times -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "The duration of time used for applying Temperature to seal the plate.",
			Category -> "General"
		},
		PlateSealAdapter -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack]
			],
			Description -> "The adapter to raise the plate to be sealed by the PlateSealer instrument.",
			Category -> "General"
		},
		PlateSealPaddle -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, PlateSealRoller],
				Object[Item, PlateSealRoller]
			],
			Description -> "The film sealing paddle to secure the adhesive seal to the plate.",
			Category -> "General"
		},
		Parafilm -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if Parafilm should be used to secure the cover after it is attached to the container.",
			Category -> "General"
		},
		AluminumFoil -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if Aluminum Foil should be wrapped around the entire container after the cover is attached in order to protect the container's contents from light.",
			Category -> "General"
		},
		KeckClamp -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Clamp],
				Object[Item, Clamp]
			],
			Description -> "The Keck Clamp that is used to secure a tapered stopper Cap to the tapered ground glass joint opening of the Container.",
			Category -> "General"
		},
		KeepCovered -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cover on this container should be \"peeked\" off when transferred into/out of instead of taken off completely when performing Manual Transfers. When performing robotic manipulations, this indicates that the container should be re-covered after any manipulation that uncovers it is completed.",
			Category -> "General"
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
			Description -> "The environment that should be used to perform the covering.",
			Category -> "General"
		},
		SterileTechnique -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a sterile environment should be used for the covering.",
			Category -> "General"
		}
	}
}];
