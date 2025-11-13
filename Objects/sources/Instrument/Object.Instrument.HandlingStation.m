(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, HandlingStation], {
	Description -> "A station that provides a specific handling environment while recording useful metadata (e.g. videos and photographs) that contextualizes the events associated with transfers between samples.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		Deionizer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Deionizer][HandlingStation],
			Description -> "The deionizer inside this instrument that helps minimize static-potential build-up on ungrounded items during weighing.",
			Category -> "Instrument Specifications"
		},
		TopLight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part, Lamp][HandlingStation],Object[Part, Lamp][ConnectedInstrument]],
			Description -> "The light source that provides illumination from above for this handling station.",
			Category -> "Instrument Specifications"
		},
		PipetteCamera -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Camera][HandlingStation],
			Description -> "The camera that acquires images of a pipette dial as a pipette is used during procedures. These images record the pipette settings employed during transfers.",
			Category -> "Instrument Specifications"
		},
		IRProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature][HandlingStation],
			Description -> "The probe that measures the temperature of samples handled in this station in a contactless manner using a blackbody radiation measurement device.",
			Category -> "Instrument Specifications"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of the space inside the handling station in {X (left-to-right), Y (back-to-front), Z (bottom-to-top)} directions where sample handling and transfer occur.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		ImmersionProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature],
			Description -> "The immersion probe used to measure the temperature of samples transferred in this fume hood.",
			Category -> "Instrument Specifications"
		},
		Pipettes->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,Pipette]
			],
			Description -> "The pipettes that permanently are kept inside of this glove box.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Tips->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Tips]
			],
			Description -> "The pipettes that permanently are kept inside of this glove box.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Aspirator->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Aspirator],
			Description -> "The aspirator that is permanently kept inside of this biosafety cabinet.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		FlowMeter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],FlowMeter]],
			Pattern :> BooleanP,
			Description -> "Whether or not a flow meter is connected to the hood.",
			Category -> "Instrument Specifications"
		},
		Plumbing -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Plumbing]],
			Pattern :> {PlumbingP..},
			Description -> "List of items plumbed into the cabinet.",
			Category -> "Instrument Specifications"
		},
		LiquidWasteBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, WasteBin][HandlingStation],
			Description -> "The liquid waste bin located on the work surface of this fume hood.",
			Category -> "Instrument Specifications"
		}
	}
}];
