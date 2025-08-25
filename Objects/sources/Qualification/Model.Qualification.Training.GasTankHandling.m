(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Qualification, Training, GasTankHandling], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies an operator's ability to safely handle gas tanks.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		OperationalGasFlowSwitchModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, GasFlowSwitch],
			Description -> "Type of gas flow switch used when training on tasks that require a device connected up to the lab gas lines, such as for live pressure readings.",
			Category -> "Qualification Parameters"
		},
		GasTankModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> Link,
			Relation -> Model[Container, GasCylinder],
			Description -> "Type of gas tank to use for this training.",
			Category -> "Qualification Parameters"
		},

		GasFlowSwitchConnectionTraining -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this qualification includes training for connecting a gas tank to a gas flow switch.",
			Category -> "Qualification Parameters"
		},
		TrainingGasFlowSwitchModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, GasFlowSwitch],
			Description -> "Type of gas flow switch used when training on tasks that require a device not connected up to the lab gas lines, such as for tank connection training.",
			Category -> "Qualification Parameters"
		},
		GasFlowSwitchGaugeReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing the pressure gauge positions on the operational gas flow switch model.",
			Category -> "Passing Criteria",
			Developer -> True
		},
		ConnectedGasTankReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing a gas tank of the appropriate model correctly connected to a gas flow switch of the appropriate model.",
			Category -> "Passing Criteria",
			Developer -> True
		},

		GasTankTopReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing the top of a gas tank of the appropriate model, highlighting important components.",
			Category -> "Passing Criteria",
			Developer -> True
		},
		GasTankVentReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing example vents for a gas tank of the appropriate model.",
			Category -> "Passing Criteria",
			Developer -> True
		},
		GasTankPressureBuilderReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing example pressure builders for a gas tank of the appropriate model.",
			Category -> "Passing Criteria",
			Developer -> True
		},
		GasTankGasOutletValveReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing example gas outlet valves for a gas tank of the appropriate model.",
			Category -> "Passing Criteria",
			Developer -> True
		},
		GasTankLiquidOutletValveReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing example liquid outlet valves for a gas tank of the appropriate model.",
			Category -> "Passing Criteria",
			Developer -> True
		},
		GasTankPressureGaugeReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing example pressure gauges for a gas tank of the appropriate model.",
			Category -> "Passing Criteria",
			Developer -> True
		},
		GasTankFillGaugeReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing example fill gauges for a gas tank of the appropriate model.",
			Category -> "Passing Criteria",
			Developer -> True
		},

		NMRInstrumentModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, NMR],
			Description -> "Type of NMR instrument to use for this training.",
			Category -> "Qualification Parameters"
		},
		NMRConnectionReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing the NMR instrument correctly connected to a gas tank, focussing on the connections of tubing to the NMR.",
			Category -> "Passing Criteria",
			Developer -> True
		},
		NMRGasTankConnectionReferenceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image showing the NMR instrument correctly connected to a gas tank, focussing on the connections of gas tank.",
			Category -> "Passing Criteria",
			Developer -> True
		}
	}
}];
