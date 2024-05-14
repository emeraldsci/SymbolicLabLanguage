(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, LiquidHandler], {
	Description->"The model liquid handler used for sample manipulation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Deck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Deck],
			Description -> "The deck layout that is installed on this type of liquid handler.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LiquidHandlingScaleP,
			Description -> "The volume range at which dispensing is being performed with this liquid handler.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TipType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LiquidHandlerTipTypeP,
			Description -> "The type of tips used by the liquid handler to aspirate and dispense liquids.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		LiquidHandlerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LiquidHandlerTypeP,
			Description -> "The type of function that this liquid handler is capable of performing.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		TubingType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlasticP,
			Description -> "Material the system tubing is composed of.",
			Category -> "Instrument Specifications"
		},
		SyringeVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "The capacity of the syringe pump used to dispense the fluid.",
			Category -> "Instrument Specifications"
		},
		TransferLoopVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Liter],
			Units->Milliliter,
			Description->"The capacity of the tubing which contains the fluid being transferred between the aspiration and dispense steps of the syringe pump cycle.",
			Category->"Instrument Specifications"
		},
		PrimeVolume->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Milli,
			Description -> "The amount of liquid needed to fill the liquid handler's lines prior to its use.",
			Category -> "Instrument Specifications"
		},
		IndependentChannels->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1],
			Units->None,
			Description->"Number of channels for robotic pipetting that can be moved independently along the vertical axis and one horizontal axis.",
			Category->"Instrument Specifications"
		},
		IndependentChannelResolution->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0Microliter],
			Units->Microliter,
			Description->"The smallest volume interval which can be handled by each independent pipetting channel.",
			Category->"Instrument Specifications"
		},
		AvailableFootprints->{
			Format->Multiple,
			Class->{Expression, Integer},
			Pattern:>{FootprintP, _?IntegerQ},
			Description->"The available footprints positions on this liquid handler.",
			Category->"Instrument Specifications",
			Headers->{"Footprint", "Number of Positions"},
			Developer->True
		},
		MaxStackedTipPositions->{
			Format->Single,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"The maximum number of stacked tip positions that will fit on this liquid handler.",
			Category->"Instrument Specifications",
			Developer->True
		},
		MaxNonStackedTipPositions->{
			Format->Single,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"The maximum number of non-stacked tip positions that will fit on this liquid handler.",
			Category->"Instrument Specifications",
			Developer->True
		},
		MaxOffDeckStoragePositions->{
			Format->Single,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"The maximum number of off-deck storage positions that are available to this liquid handler.",
			Category->"Instrument Specifications",
			Developer->True
		},
		MaxHeaterShakerPositions->{ (* DELETE? *)
			Format->Single,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"The maximum number of heater shaker positions on this liquid handler.",
			Category->"Instrument Specifications",
			Developer->True
		},
		MaxIncubatorPlatePositions->{
			Format->Single,
			Class->Integer,
			Pattern:>_?IntegerQ,
			Description->"The maximum number of incubator plate storage positions that are available to this liquid handler.",
			Category->"Instrument Specifications",
			Developer->True
		},
		IntegratedInstruments->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Instrument],
			Description->"The instrument models that are integrated into this liquid handler.",
			Category->"Integrations"
		},
		NitrogenPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "The pressure of the nitrogen gas used for pressure pushing samples.",
			Category -> "Operating Limits"
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The minimum flow rate of tips when aspirating or dispensing.",
			Category -> "Operating Limits"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> (Liter Milli)/Minute,
			Description -> "The maximum flow rate of the tips when aspirating or dispensing.",
			Category -> "Operating Limits"
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Micro,
			Description -> "The minimum volume that the liquid handler can transfer accurately.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter Micro,
			Description -> "The maximum volume that the liquid handler can transfer.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxDefaultTransfers -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Units -> None,
			Description -> "Maximum number of repeated transfers that should be made in deciding if this model instrument is a good default instrument for performing a transfer manipulation.",
			Category -> "Operating Limits"
		},
		MaxVolumes -> {
			Format -> Multiple,
			Class -> {String, Real},
			Pattern :> {_String, GreaterP[0 Milliliter]},
			Units -> {None, Milliliter},
			Headers -> {"Cylinder Name", "Max Volume"},
			Description -> "Max volume the liquid handler can dispense from each of its cylinders.",
			Category -> "Operating Limits"
		},
		SmallCylinderMaxVolume-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The maximum volume the macro liquid handler can dispense from its small cylinder.",
			Category -> "Operating Limits"
		},
		MediumCylinderMaxVolume-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The maximum volume the macro liquid handler can dispense from its Medium cylinder.",
			Category -> "Operating Limits"
		},
		LargeCylinderMaxVolume-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The maximum volume the macro liquid handler can dispense from its large cylinder.",
			Category -> "Operating Limits"
		},
		MaxHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Maximum allowed height from the deck to the traverse height of the probe (with tip) to avoid any collision.",
			Category -> "Operating Limits"
		},
		PipetteTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Tips],
			Description -> "Tips that can be used with the pipette channels of this model of instrument.",
			Category -> "Compatibility"
		},
		TubingOuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "Outer diameter of the tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Headers -> {"Width","Depth","Height"},
			Description -> "The size of the space inside the liquid handler.",
			Category -> "Dimensions & Positions"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the liquid handler can perform thermal incubation while mixing.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the liquid handler can perform thermal incubation while mixing.",
			Category -> "Operating Limits"
		},
		MinStirRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The slowest rotational speed at which the liquid handler's stirrer can operate.",
			Category -> "Operating Limits"
		},
		MaxStirRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "The fastest rotational speed at which the liquid handler's stirrer can operate.",
			Category -> "Operating Limits"
		},
		InternalRobotArmPositions->{
			Format -> Multiple,
			Class -> {
				Name->String,
				Device->Link,
				XPosition->Real,
				YPosition->Real,
				ZPosition->Real,
				ZRotation->Real,
				Width->Real,
				Depth->Real
			},
			Pattern :> {
				Name->_String,
				Device->_Link|Null,
				XPosition->DistanceP,
				YPosition->DistanceP,
				ZPosition->DistanceP,
				ZRotation->RangeP[-360 AngularDegree, 360 AngularDegree],
				Width->DistanceP,
				Depth->DistanceP

			},
			Relation -> {
				Name->Null,
				Device->Alternatives[Model[Container],Model[Instrument],Null],
				XPosition->Null,
				YPosition->Null,
				ZPosition->Null,
				ZRotation->Null,
				Width->Null,
				Depth->Null
			},
			Units -> {
				Name->None,
				Device->None,
				XPosition->Millimeter,
				YPosition->Millimeter,
				ZPosition->Millimeter,
				ZRotation->AngularDegree,
				Width->Millimeter,
				Depth->Millimeter
			},
			Description -> "A set of physical locations for the positions of plate positions that can be reached by the internal robot arm of this liquid handler. Positions are measured from the bottom left front corner of the liquid handler deck. Width is measured in the X axis, Depth in the Y axis. The Rotational location is measured clockwise in the plane perpendicular to the Z axis with the rotation axis going through the centroid of the plate.",
			Category -> "Dimensions & Positions"
		},
		ExternalRobotArmPaths->{
			Format -> Multiple,
			Class -> {
				Name->String,
				Instructions->Expression
			},
			Pattern:>{
				Name->_String,
				Instructions->{HMotionPrimitivesP..}(*MoveRobotArm|PickObject|PlaceObject|CloseGripper
																						|OpenGripper|SetGripperParameters|GoToSafePosition*)
			},
			Relation->{
				Name->Null,
				Instructions->Null
			},
			Units->{
				Name->None,
				Instructions->None
			},
			Description -> "A set of sets of ordered instructions for moving a robot arm along certain paths.",
			Category -> "Dimensions & Positions"

		},
		ExternalRobotArmWaypoints->{
			Format -> Multiple,
			Class -> {
				Name->String,
				Device->Link,
				XPosition->Real,
				YPosition->Real,
				ZPosition->Real,
				ZRotation->Real,
				RailPosition->Real,
				ElbowConfiguration->Expression,
				WaypointType->Expression
			},
			Pattern :> {
				Name->_String,
				Device->_Link|Null,
				XPosition->DistanceP,
				YPosition->DistanceP,
				ZPosition->DistanceP,
				ZRotation->RangeP[-360 AngularDegree, 360 AngularDegree],
				RailPosition->DistanceP,
				ElbowConfiguration->Patterns`Private`robotElbowConfigurationsP,(*RightElbow|LeftElbow*)
				WaypointType->Patterns`Private`robotWaypointTypeP(*RealWaypoint|VirtualWaypoint*)

			},
			Relation -> {
				Name->Null,
				Device->Alternatives[Model[Container],Model[Instrument],Null],
				XPosition->Null,
				YPosition->Null,
				ZPosition->Null,
				ZRotation->Null,
				RailPosition->Null,
				ElbowConfiguration->Null,
				WaypointType->Null
			},
			Units -> {
				Name->None,
				Device->None,
				XPosition->Millimeter,
				YPosition->Millimeter,
				ZPosition->Millimeter,
				ZRotation->AngularDegree,
				RailPosition->Millimeter,
				ElbowConfiguration->Null,
				WaypointType->Null
			},
			Description -> "A set of physical locations for positions that can be reached by an external robot arm associated with this liquid handler. Positions are measured from the bottom left front corner of the liquid handler deck. The Rotational location is measured clockwise in the plane perpendicular to the mentioned axis (in xy plane for ZRotation for example) with the rotation axis going through the center of the plate. Rail position is measured from the position along the linear traversal axis of the robot arm farthest away from the liquid handler. ApproachX/Y/Z are measured in Millimeters relative to the plate position and represent an intermediate location the robot gripper will reach before going straight to the waypoint position.",
			Category -> "Dimensions & Positions"
		}
	}
}];
