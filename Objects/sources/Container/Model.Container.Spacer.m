(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container,Spacer], {
	Description -> "Model information for a frame that can stack on top of other containers and can have containers or lids stacked on it. The spacer has openings on both the top and bottom and provides a gap between the containers above and below it. This allows extra clear height for items below which push above the surface, and also allows containers such as filters which pass liquid through to be positioned above a collection container below the spacer.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(*--- General ---*)
		LiquidHandlerPrefix->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The unique labware ID string prefix used to reference this model of rack when on a robotic liquid handler.",
			Category -> "General",
			Developer->True
		},

		(*--- Physical Properties ---*)

		(* Not using Material and MinClearance fields from Model[Item,Lidspacer]. Check if either are used in any code and need to be changed anywhere if we get rid of these fields *)

		(*--- Container Specifications ---*)
		SpacerType->{
			Format -> Single,
			Class -> Expression,
			Pattern :> LidSpacer | FilterSpacer,
			Description -> "The type of container that is lifted by the spacer. LidSpacer separates a lid from the container that is stacked below. A FilterSpacer separates a filter from the container that is stacked below.",
			Category -> "Container Specifications"
		},
		Elevation->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the bottom of the spacer to the plane where the plate that is being held makes contact with the spacer.",
			Category -> "Physical Properties"
		},
		StackHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "When this spacer is stacked on top of another container, the distance between the top of this spacer and the top of the container below.",
			Category -> "Container Specifications"
		},

		(*--- Dimensions & Positions ---*)
		BottomCavity3D -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {Meter Milli, Meter Milli,Meter Milli},
			Description -> "A list of internal rectangular cross sections describing the empty space at the bottom.",
			Headers -> {"X dimension","Y dimension","Z height"},
			Category -> "Dimensions & Positions"
		},
		ExternalDimensions3D -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {Meter Milli, Meter Milli,Meter Milli},
			Description -> "A list of the external rectangular cross sections of the container over the entire height of the container.",
			Headers -> {"X dimension","Y dimension","Z height"},
			Category -> "Dimensions & Positions"
		},
		NumberOfPositions -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of positions in the spacer that are capable of connecting items or samples in the container above the spacer with items or samples in the container below the spacer.",
			Category -> "Dimensions & Positions"
		},
		Rows -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of rows of positions in the spacer.",
			Category -> "Dimensions & Positions"
		},
		Columns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of columns of positions in the spacer.",
			Category -> "Dimensions & Positions"
		},
		AspectRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Ratio of the number of columns of positions vs the number of rows of positions in the spacer.",
			Category -> "Dimensions & Positions"
		},
		LiquidHandlerPositionIDs -> {
			Format -> Multiple,
			Class -> {String, String},
			Pattern :> {LocationPositionP, _String},
			Description -> "A table of SLL position names and their associated robotic liquid handler IDs.",
			Category -> "Dimensions & Positions",
			Headers -> {"Position Name", "Liquid Handler ID"},
			Developer -> True
		},
		HorizontalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance from the left edge of the spacer to the edge of the first position.",
			Category -> "Dimensions & Positions"
		},
		VerticalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance from the top edge of the spacer to the edge of the first position.",
			Category -> "Dimensions & Positions"
		},
		HorizontalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one position to the next in a given row.",
			Category -> "Dimensions & Positions"
		},
		VerticalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one position to the next in a given column.",
			Category -> "Dimensions & Positions"
		},
		GripHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance the liquid handler arms should grip below the top edge of the spacer to move it across the liquid handler deck.",
			Category -> "Dimensions & Positions",
			Developer -> True
		},

		(*--- Operating Limits ---*)
		MaxCentrifugationForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The maximum relative centrifugal force this spacer is capable of withstanding.",
			Category -> "Operating Limits"
		},

		PermanentStorage  -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the model rack has sufficient storage density to be used as a compact long term storage solution. Items in PermanentStorage racks can be stored in these racks, while items in non-PermanentStorage racks must be removed from the rack during Storage, StoreAll, and ProcessingStorage tasks.",
			Category -> "Operating Limits"
		},

		(*--- Qualifications & Maintenance ---*)
		SupportedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][AssociatedAccessories,1],
			Description -> "A list of instruments for which this container model is an accompanying accessory.",
			Category -> "Qualifications & Maintenance"
		}
	}


}]
