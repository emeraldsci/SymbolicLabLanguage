(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container,Plate,Irregular],{
	Description->"A model for a container that stores lab samples in individual wells. The well size and layout of well columns and rows may not be consistent throughout the plate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		WellColors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PlateColorP,
			Description -> "For each member of Positions, the color of the bottom of the well.",
			IndexMatching -> Positions,
			Category -> "Container Specifications"
		},
		WellTreatments -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> WellTreatmentP,
			Description -> "For each member of Positions, the treatment or coating, if any, on the well.",
			IndexMatching -> Positions,
			Category -> "Container Specifications"
		},
		WellPositionBottomThickness -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Micrometer],
			Units -> Micrometer,
			Description -> "For each member of Positions, the thickness of container material that constitutes the bottom of the well.",
			IndexMatching -> Positions,
			Category -> "Container Specifications"
		},
		MaxViewingAngles -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 AngularDegree,180 AngularDegree],
			Units -> AngularDegree,
			Description -> "For each member of Positions, the angle from 0 to 180 degrees that defines a Conical shape from the bottom center point of the well to the top outside edge of the well. At any viewing angle larger than this, there exists a rotation that is not be able to see the bottom center of the well.",
			IndexMatching -> Positions,
			Category -> "Container Specifications"
		},
		WellPositionDimensions -> {
			Format -> Multiple,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli,Meter Milli},
			Headers -> {"Width","Depth"},
			Description -> "For each member of Positions, the internal size of the well.",
			IndexMatching -> Positions,
			Category -> "Container Specifications"
		},
		WellDiameters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "For each member of Positions, the diameter of the well, if round.",
			IndexMatching -> Positions,
			Category -> "Container Specifications"
		},
		WellDepths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "For each member of Positions, the maximum z-axis depth of the well.",
			IndexMatching -> Positions,
			Category -> "Container Specifications"
		},
		WellBottoms -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> WellShapeP,
			Description -> "For each member of Positions, the shape of the bottom of the well.",
			IndexMatching -> Positions,
			Category -> "Container Specifications"
		},
		ConicalWellDepths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "For each member of Positions, the depth of the conical section of the well.",
			IndexMatching -> Positions,
			Category -> "Container Specifications"
		},
		MinVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Milli,
			Description -> "For each member of Positions, the smallest amount of fluid the well can hold.",
			IndexMatching -> Positions,
			Category -> "Operating Limits"
		},
		MaxVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Milli,
			Description -> "For each member of Positions, the largest amount of fluid the well can hold.",
			IndexMatching -> Positions,
			Category -> "Operating Limits"
		},
		CoveredVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "For each member of Positions, the volume of the well with the cover applied or with an imaginary boundary at the top edge of the plate. Considering surface tension, the filled volume of liquid should be 10% smaller than this to avoid cover contacting samples.",
			IndexMatching -> Positions,
			Category -> "Operating Limits"
		},
		RecommendedFillVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "For each member of Positions, the largest recommended fill volume in the wells of this plate.",
			IndexMatching -> Positions,
			Category -> "Operating Limits"
		},
		HeadspaceSharingWells -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {WellPositionP..},
			Description -> "The wells of the same container that share headspace with each other are grouped in a list together. Headspace is the room above the wells connected by the micro-ledges or micro-channels. Water vapor is able to escape from one well of the HeadspaceSharingWells to another well after the container is covered.",
			Category -> "Container Specifications"
		}
	}
}];
