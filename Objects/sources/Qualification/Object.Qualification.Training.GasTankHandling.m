(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Qualification, Training, GasTankHandling], {
	Description -> "A protocol that verifies an operator's ability to safely handle gas tanks.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		OperationalGasFlowSwitch -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, GasFlowSwitch],
				Object[Instrument, GasFlowSwitch]
			],
			Description -> "The gas flow switch used for tasks that require a device connected up to the lab gas lines.",
			Category -> "Qualification Parameters"
		},
		GasTank -> {
			Format -> Single,
			Class -> Link,
			Pattern :> Link,
			Relation -> Alternatives[
				Model[Container, GasCylinder],
				Object[Container, GasCylinder]
			],
			Description -> "The gas tank used for this training.",
			Category -> "Qualification Parameters"
		},

		GasFlowSwitchConnectionTraining -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this qualification includes training for connecting a gas tank to a gas flow switch.",
			Category -> "Qualification Parameters"
		},
		TrainingGasFlowSwitch -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, GasFlowSwitch],
				Object[Instrument, GasFlowSwitch]
			],
			Description -> "The gas flow switch used for tasks that require a device not connected up to the lab gas lines.",
			Category -> "Qualification Parameters"
		},
		GasFlowSwitchLeftInletPressureReading -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The pressure reading of the left inlet on the active gas flow switch, as recorded manually by the operator.",
			Category -> "Experimental Results"
		},
		GasFlowSwitchRightInletPressureReading -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The pressure reading of the right inlet on the active gas flow switch, as recorded manually by the operator.",
			Category -> "Experimental Results"
		},
		GasFlowSwitchOutletPressureReading -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The pressure reading of the outlet on the active gas flow switch, as recorded manually by the operator.",
			Category -> "Experimental Results"
		},
		GasFlowSwitchGaugeImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the pressure gauges on the operational gas flow switch model.",
			Category -> "Experimental Results"
		},
		GasFlowSwitchLeftInletReferencePressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The pressure reading of the left inlet on the active gas flow switch, as reported automatically by the gas flow switch.",
			Category -> "Experimental Results"
		},
		GasFlowSwitchRightInletReferencePressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The pressure reading of the right inlet on the active gas flow switch, as reported automatically by the gas flow switch.",
			Category -> "Experimental Results"
		},
		GasFlowSwitchOutletReferencePressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The pressure reading of the outlet on the active gas flow switch, as reported automatically by the gas flow switch.",
			Category -> "Experimental Results"
		},

		GasTankPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "Placement for Gas Tank when verifying installation technique.",
			Headers -> {"Movement Container", "Destination Container", "Destination Position"},
			Category -> "Placements",
			Developer -> True
		},

		ConnectedGasTankImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the gas tank and gas flow switch after they have performed the connection steps, to verify the tank was connected correctly.",
			Category -> "Experimental Results"
		},
		DisconnectedGasTankImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the gas tank and gas flow switch after they have performed the disconnection steps, to verify the tank was disconnected correctly.",
			Category -> "Experimental Results"
		},

		GasTankTopImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the top of the gas tank.",
			Category -> "Experimental Results"
		},
		GasTankVentImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the vent of the gas tank.",
			Category -> "Experimental Results"
		},
		GasTankPressureBuilderImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the pressure builder of the gas tank.",
			Category -> "Experimental Results"
		},
		GasTankGasOutletValveImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the gas outlet valve of the gas tank.",
			Category -> "Experimental Results"
		},
		GasTankLiquidOutletValveImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the liquid outlet valve of the gas tank.",
			Category -> "Experimental Results"
		},
		GasTankPressureGaugeImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the pressure gauge of the gas tank.",
			Category -> "Experimental Results"
		},
		GasTankFillGaugeImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the fill gauge of the gas tank.",
			Category -> "Experimental Results"
		},

		NMRInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, NMR] | Object[Instrument, NMR],
			Description -> "The NMR instrument to use for training in NMR refill.",
			Category -> "Qualification Parameters"
		},
		NMRTrainingProtocol ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, RefillReservoir, NMR],
			Description -> "The maintenance subprotocol for training in NMR refill.",
			Category -> "Qualification Parameters"
		},
		NMRConnectionImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the NMR instrument connected to a gas tank, focussing on the connections of tubing to the NMR, to verify the tank was connected correctly..",
			Category -> "Experimental Results"
		},
		NMRGasTankConnectionImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image taken by the operator showing the NMR instrument connected to a gas tank, focussing on the connections of gas tank, to verify the tank was connected correctly..",
			Category -> "Experimental Results"
		}
	}
}];
