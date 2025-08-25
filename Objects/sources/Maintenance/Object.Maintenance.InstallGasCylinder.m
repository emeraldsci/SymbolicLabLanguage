(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, InstallGasCylinder], {
	Description -> "A protocol that replaces an empty gas tank with a full one.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields ->{

		LabArea->{
			Format->Single,
			Class->Expression,
			Pattern:>LabAreaP,
			Description->"Indicates the area of the lab in which this maintenance occurs.",
			Category->"General"
		},
		Building->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Building],
			Description->"The building that the gas storage room is located in.",
			Category->"General"
		},
		PressureSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sensor],
			Description->"Pressure sensor monitoring this cylinder.",
			Category->"Sensor Information"
		},
		LocationOfInstallation->{
			Format->Multiple,
			Class->{Link,String},
			Pattern:>{_Link,_String},
			Relation->{Object[Container],Null},
			Description->"Location of the Gas Cylinder Installation.",
			Headers->{"Destination Container","Destination Position"},
			Category->"General",
			Developer->True
		},
		ReplacementGasSample->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample],
				Model[Container],
				Object[Container]
			],
			Description->"New replacement sample of Gas connected to the taps.",
			Category->"General"
		},
		GasSamplePlacements->{
			Format->Multiple,
			Class->{Link,Link,String},
			Pattern:>{_Link,_Link,LocationPositionP},
			Relation->{Object[Container],Object[Container],Null},
			Description->"Placement for Gas Cylinder.",
			Headers->{"Movement Container","Destination Container","Destination Position"},
			Category->"Placements",
			Developer->True
		},
		GasLineConnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing],Null,Object[Container],Null},
			Description->"The information for attaching the gas cylinder being installed to the lab based gas line.",
			Headers->{"Lab Gas Line","Lab Gas Line Connector","Gas Cylinder","Gas Cylinder Connector"},
			Category->"General",
			Developer->True
		},
		GasLineDisconnections->{
			Format->Multiple,
			Class->{Link,String,Link,String},
			Pattern:>{_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation->{Object[Plumbing],Null,Object[Container],Null},
			Description->"The information for removing any existing gas cylinder from the lab based gas line prior to installation of the new cylinder.",
			Headers->{"Lab Gas Line","Lab Gas Line Connector","Gas Cylinder","Gas Cylinder Connector"},
			Category->"General",
			Developer->True
		},
		ReplacementRequired->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the target cylinder or tank needed to be swapped out with a new cylinder or tank of the same kind.",
			Category->"General",
			Developer->True
		},
		EmptyCylinderQ->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the target cylinder or tank was verified to be empty by an operator.",
			Category->"General",
			Developer->True
		},
		EmptyCylinderPlacement->{
			Format->Multiple,
			Class->{Link,Link,String},
			Pattern:>{_Link,_Link,LocationPositionP},
			Relation->{Object[Container],Object[Container],Null},
			Description->"Placement for the empty gas cylinder/tank being removed to install a new gas cylinder/tank.",
			Headers->{"Empty Gas Cylinder/Tank","Destination","Destination Position"},
			Category->"Placements",
			Developer->True
		},
		ReplacementCylinderPlacement->{
			Format->Multiple,
			Class->{Link,Link,String},
			Pattern:>{_Link,_Link,LocationPositionP},
			Relation->{Object[Container],Object[Container],Null},
			Description->"Placement for the replacement gas cylinder/tank that is being installed.",
			Headers->{"Replacement Gas Cylinder/Tank","Destination Room","Destination Position"},
			Category->"Placements",
			Developer->True
		},
		GasFlowSwitch->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,GasFlowSwitch],
			Description->"Gas Flow Switch used to monitor, control, and switch the flow of gas of the cylinder being replaced.",
			Category->"Sensor Information"
		},
		InstallationSide->{
			Format->Single,
			Class->Expression,
			Pattern:>(RightCylinder|LeftCylinder),
			Description->"The side of the Gas Flow Switch where the cylinder/tank will be installed.",
			Category->"Sensor Information"
		},
		AnomalousCylinders->{
			Format->Multiple,
			Class->Link,
			Pattern:>Link,
			Relation->Object[Container,GasCylinder],
			Description->"Gas cylinders/tanks that did not have their pressure built high enough for use in the installation.",
			Category->"General"
		},
		CryogenicFreezer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Instrument,CryogenicFreezer],
			Description->"Cryogenic Freezer connected to the cylinder being replaced.",
			Category->"Sensor Information"
		},
		LiquidLevelSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sensor,LiquidLevel],
			Description->"The built-in sensor that monitors the level of liquid nitrogen in a cryogenic freezer.",
			Category->"Sensor Information"
		},
		CurrentCryogenicFreezerNitrogenLevel->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Maintenance],
			Description->"The amount of liquid nitrogen in a Cryogenic Freezer.",
			Category->"Sensor Information"
		},
		MissingTargetTankQ->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the target gas tank is missing from the gas flow switch.",
			Category->"General"
		},
		ActualInstalledTank->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample],
				Model[Container],
				Object[Container]
			],
			Description->"The actual tank connected to the target tank's gas flow switch.",
			Category->"General"
		},
		CryogenicGloves->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item,Glove],
				Model[Item,Glove]
			],
			Description->"The cryo gloves worn to protect the hands from ultra low temperature surfaces/fluids.",
			Category->"General"
		},
		Wrench -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Wrench],
				Model[Item, Wrench]
			],
			Description -> "The wrench required for adjusting connections or valves on the gas cylinder.",
			Category -> "General"
		}
	}
}];
