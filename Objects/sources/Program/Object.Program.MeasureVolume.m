

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Program,MeasureVolume], {
	Description->"A program containing parameters for a single volume measurement run via liquid level detection.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		SamplesIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The samples whose volumes are measured by this program.",
			Category -> "General",
			Abstract -> True
		},
		ContainersIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers whose volumes are measured by this program.",
			Category -> "General",
			Abstract->True
		},
		TubeRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Rack],
				Object[Container,Rack]
			],
			Description -> "The rack used to hold tubes upright for liquid level measurement.",
			Category -> "General",
			Developer->True
		},
		PlatePlatform -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Rack],
				Object[Container,Rack]
			],
			Description -> "The rack used to boost the height of short plates to improve liquid level measurement accuracy.",
			Category -> "General",
			Developer->True
		},
		TubeRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Model[Container,Rack] | Object[Container,Rack], Null},
			Description -> "Placement instructions specifying the locations in the tube rack where the target containers are placed.",
			Category -> "General",
			Headers -> {"Object to Place","Destination Object","Destination Position"},
			Developer->True
		},
		LiquidLevelDetector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,LiquidLevelDetector],
				Object[Instrument,LiquidLevelDetector]
			],
			Description -> "The instrument used to measure liquid levels via sonic distance for volume calculation.",
			Category -> "Volume Measurement",
			Abstract->True
		},
		SensorArmHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Centi Meter,
			Description -> "The height at which the liquid level detecting sensor arm is set to ensure the target vessel will fit beneath it.",
			Category -> "Volume Measurement",
			Developer -> True
		},
		PlateLayoutFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the file used to specify the layout settings for the liquid level detector's distance measurements.",
			Category -> "Volume Measurement",
			Developer -> True
		},
		DataFileNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Names of data files containing liquid level readings for the containers measured in this program.",
			Category -> "Experimental Results",
			Developer -> True
		},
		TareDistance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,Volume],
			Description -> "A tared liquid level measurement with no vessel beneath the sensor.",
			Category -> "Experimental Results"
		}
	}
}];
