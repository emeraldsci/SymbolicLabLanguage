(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, PlateWasher], {
	Description -> "A device to automatically wash microplates.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		NumberOfChannels -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], NumberOfChannels]],
			Pattern :> _Integer,
			Description -> "Indicates how many manifold channels the washer has.",
			Category -> "Instrument Specifications"
		},
		BufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Deck][Instruments], Object[Container]],
			Description -> "The platform which contains wash buffers and rinse buffers.",
			Category -> "Dimensions & Positions"
		},
		BufferAInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][PlateWasher]|Object[Plumbing, Tubing],
			Description -> "The buffer A inlet tubing used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferBInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][PlateWasher]|Object[Plumbing, Tubing],
			Description -> "The buffer B inlet tubing used to uptake buffer B from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferCInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][PlateWasher]|Object[Plumbing, Tubing],
			Description -> "The buffer C inlet tubing used to uptake buffer C from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferDInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing][PlateWasher]|Object[Plumbing, Tubing],
			Description -> "The buffer D inlet tubing used to uptake buffer D from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferACap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap][PlateWasher]|Object[Item, Cap]|Object[Plumbing, AspirationCap][PlateWasher],
			Description -> "The aspiration cap used to uptake buffer A from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferBCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap][PlateWasher]|Object[Item, Cap]|Object[Plumbing, AspirationCap][PlateWasher],
			Description -> "The aspiration cap used to uptake buffer B from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferCCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap][PlateWasher]|Object[Item, Cap]|Object[Plumbing, AspirationCap][PlateWasher],
			Description -> "The aspiration cap used to uptake buffer C from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferDCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap][PlateWasher]|Object[Item, Cap]|Object[Plumbing, AspirationCap][PlateWasher],
			Description -> "The aspiration cap used to uptake buffer D from buffer container to the instrument pump.",
			Category -> "Instrument Specifications"
		},
		BufferABottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer A volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferBBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer B volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferCBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer C volumes in bottles.",
			Category -> "Sensor Information"
		},
		BufferDBottleSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Volume],
			Description -> "The ultrasonic liquid level sensor used to assess Buffer D volumes in bottles.",
			Category -> "Sensor Information"
		},
		WastePump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VacuumPump][PlateWasher]|Object[Instrument, VacuumPump],
			Description -> "Vacuum pump that drains waste liquid into the carboy.",
			Category -> "Instrument Specifications"
		},
		SecondaryWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The container connected to the instrument and WasteContainer used to provide vacuum trap during operation.",
			Category -> "Instrument Specifications"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedPlateWasher],
			Description -> "The liquid handler that is connected to this washer such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		}
	}
}];
