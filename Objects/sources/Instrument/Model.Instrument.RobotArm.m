(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, RobotArm], {
	Description->"A model robotic arm used for moving plates or other labware between instruments or locations in physical space.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		GantryType->{
			Format -> Single,
			Class -> Expression,
			Pattern :> GantryTypeP,
			Description -> "The geometry of the mechanism used to position the end effector of the arm.",
			Category -> "Instrument Specifications"
		},
		ApproximateWorkingEnvelope->{
			Format -> Single,
			Class -> {Real,Real,Real,Real,Real,Real},
			Pattern :> {DistanceP,DistanceP, DistanceP,DistanceP,DistanceP, DistanceP},
			Units -> {Meter,Meter,Meter,Meter,Meter,Meter},
			Description -> "A rectangular prism encompassing the volume in three dimensional space that the robot arm end effector can access, centered at the origin point of the arm's coordinate system. The actual working envelope of a non-cartesian arm is not a rectangular prism, thus for those Gantry types, the envelope defined here is approximate.",
			Headers -> {"MinX","MaxX","MinY","MaxY","MinZ","MaxZ"},
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		LinearRailAttached->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if this robot arm has an optional additional linear track attached, that allows automated translational motion of the arm assembly.",
			Category -> "Item Specifications"
		},
		LinearRailRelativeAngle->{
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[-180 AngularDegree,180AngularDegree],
			Units->AngularDegree,
			Description -> "The angle created from the forward vector of the arm, and the positive direction of motion defined by the linear rail, if the rail exists. A positive angle is defined as clockwise when viewed from above.",
			Category -> "Instrument Specifications"
		},
		Grippers->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GripperTypeP,
			Units->None,
			Description -> "A list of all the types of grabbing implements that the arm can utilize in manipulating labware.",
			Category -> "Instrument Specifications"
		},
		GripperOpeningWidths->{
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0 Millimeter],GreaterP[0 Millimeter]},
			Units->{Millimeter,Millimeter},
			Headers -> {"Minimum Opening Width", "Maximum Opening Width"},
			Description -> "For each member of Grippers, the minimum and maximum width the gripping implement is capable of being opened.",
			IndexMatching->Grippers,
			Category -> "Instrument Specifications"
		}
	}
}];
