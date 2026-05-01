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
		WasteContainerShelf -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Shelf],
			Description -> "The shelf that contains WasteContainer and WastePump.",
			Category -> "Dimensions & Positions",
			Developer -> True
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
		VacuumSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "The vacuum gauge used by this instrument to sense the amount of vacuum being pulled by the vacuum line.",
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
		WasteContainerCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "The cap covering WasteContainer and connected with WasteContainerInlet and WasteContainerOutlet.",
			Category -> "Instrument Specifications"
		},
		SecondaryWasteContainerCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "The cap covering SecondaryWasteContainer and connected with WasteContainerOutlet and WastePumpInlet.",
			Category -> "Instrument Specifications"
		},
		WasteContainerInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing],
			Description -> "The tubing used by this instrument to uptake waste solution from the back of the instrument into the WasteContainer.",
			Category -> "Instrument Specifications"
		},
		WasteContainerOutlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing],
			Description -> "The tubing used by this instrument to connect the WasteContainer to SecondaryWasteContainer.",
			Category -> "Instrument Specifications"
		},
		WastePumpInlet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Plumbing, Tubing],
			Description -> "The tubing used by this instrument to connect SecondaryWasteContainer to WastePump.",
			Category -> "Instrument Specifications"
		},
		SystemPrimeFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path on the instrument computer in which the system priming protocol is stored locally.",
			Category -> "Qualifications & Maintenance"
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedPlateWasher],
			Description -> "The liquid handler that is connected to this washer such that samples may be passed between the two instruments robotically.",
			Category -> "Integrations"
		},
		WasteContainerStorageCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap for the waste container once it is disconnected from the instrument and carried across the lab to be emptied. This cap is stored in local cache while the WasteContainer is attached to the instrument via WasteContainerCap.",
			Category -> "Instrument Specifications"
		},
		BufferAStorageCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap for the StorageBufferA once it is disconnected from the instrument and stored. When not used, this cap is stored in BufferDeck.",
			Category -> "Instrument Specifications"
		},
		BufferBStorageCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap for the StorageBufferB once it is disconnected from the instrument and stored. When not used, this cap is stored in BufferDeck.",
			Category -> "Instrument Specifications"
		},
		BufferCStorageCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap for the StorageBufferC once it is disconnected from the instrument and stored. When not used, this cap is stored in BufferDeck.",
			Category -> "Instrument Specifications"
		},
		BufferDStorageCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap],
			Description -> "Indicates the cap for the StorageBufferD once it is disconnected from the instrument and stored. When not used, this cap is stored in BufferDeck.",
			Category -> "Instrument Specifications"
		},
		BufferLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item, Cap], Null},
			Description -> "The connection information for attaching buffer inlet lines to the aspiration buffer caps.",
			Headers -> {"Buffer Inlet Line", "Inlet Line Connection", "Buffer Cap", "Buffer Cap Connector"},
			Category -> "Instrument Specifications",
			Developer -> True
		},
		WasteLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item, Cap], Null},
			Description -> "The connection information for attaching WasteContainerInlet and WasteContainerOutlet to the WasteContainerCap.",
			Headers -> {"Instrument Waste Line", "Line Connection", "WasteContainerCap", "Cap Connector"},
			Category -> "Instrument Specifications",
			Developer -> True
		},
		WasteLineDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Object[Container], Null},
			Description -> "The destination information for the disconnected WasteContainerInlet and WasteContainerOutlet.",
			Headers -> {"Container", "Position"},
			Category -> "Instrument Specifications",
			Developer -> True
		},
		StorageBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The solution in which the instrument buffer line A is stored in when the instrument is not in use.",
			Developer -> True,
			Category -> "Cleaning"
		},
		StorageBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The solution in which the instrument buffer line B is stored in when the instrument is not in use.",
			Developer -> True,
			Category -> "Cleaning"
		},
		StorageBufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The solution in which the instrument buffer line C is stored in when the instrument is not in use.",
			Developer -> True,
			Category -> "Cleaning"
		},
		StorageBufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The solution in which the instrument buffer line D is stored in when the instrument is not in use.",
			Developer -> True,
			Category -> "Cleaning"
		}
	}
}];
