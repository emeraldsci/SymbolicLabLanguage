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
		}
	}
}];
