

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Rack], {
	Description->"A model of a container with regular dimensions and positions for storing other containers (plates, tubes, other racks, etc).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Rows -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of rows of positions in the rack.",
			Category -> "Dimensions & Positions"
		},
		Columns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of columns of positions in the rack.",
			Category -> "Dimensions & Positions"
		},
		WellDimensions -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli,Meter Milli},
			Headers -> {"Width","Depth"},
			Description -> "Internal size of the each position in this model of rack.",
			Category -> "Container Specifications"
		},
		WellDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Diameter of each round position.",
			Category -> "Container Specifications"
		},
		HorizontalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance from the left edge of the rack to the edge of the first position.",
			Category -> "Container Specifications"
		},
		VerticalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance from the top edge of the rack to the edge of the first position.",
			Category -> "Container Specifications"
		},
		DepthMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance from the bottom of the rack to the inside bottom of its first position.",
			Category -> "Container Specifications"
		},
		HorizontalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one position to the next in a given row.",
			Category -> "Container Specifications"
		},
		VerticalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one position to the next in a given column.",
			Category -> "Container Specifications"
		},
		HorizontalOffset-> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance between the center of well A1 and well B1.",
			Category -> "Container Specifications"
		},
		VerticalOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance between the center of well A1 and well A2.",
			Category -> "Container Specifications"
		},
		GripHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance the liquid handler arms should grip below the top edge of the container to move it across the liquid handler deck.",
			Category -> "Container Specifications",
			Developer -> True
		},
		NumberOfPositions -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of positions in the rack that are capable of holding containers or samples.",
			Category -> "Dimensions & Positions"
		},
		AspectRatio -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Ratio of the number of columns of positions vs the number of rows of positions in the rack.",
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
		LiquidHandlerPrefix->{
		    Format->Single,
		    Class->String,
		    Pattern:>_String,
		    Description->"The unique labware ID string prefix used to reference this model of rack when on a robotic liquid handler.",
		    Category -> "General",
		    Developer->True
		},
		Magnetized->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this rack has a built-in magnet that will separate out any magnetic particles in the sample when the sample is placed in the rack.",
			Category -> "General"
		},
		OperationsStandard->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether racks of this model are stocked in common areas for easy accessibility and used by default for general purposes. Racks with OperationStandard set to True are preferred for selection during resource picking tasks. If set to False, the rack model is not intended for holding vessels during transportation.",
			Category -> "General"
		},
		MaxCentrifugationForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The maximum relative centrifugal force this rack is capable of withstanding.",
			Category -> "Operating Limits"
		},
		BottomSupport3D -> {
			Format -> Multiple,
			Class -> {Name->String, Dimensions->Expression},
			Pattern :> {Name->LocationPositionP,Dimensions->{{GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]}..}},
			Units -> {Name->None,Dimensions->None},
			Description -> "A list of external rectangular cross sections describing a protrusion in the middle of a position indicated by Name which matches the Name in the Positions field.",
			Headers -> {Name->"Name of Position",Dimensions->"X, Y, Z dimensions of the protrusion"},
			Category -> "Dimensions & Positions"
		},
		BottomCavity3D -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {Meter Milli, Meter Milli,Meter Milli},
			Description -> "A list of internal rectangular cross sections describing the empty space at the bottom.",
			Headers -> {"X dimension","Y dimension","Z height"},
			Category -> "Dimensions & Positions"
		},
		PermanentStorage  -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the model rack has sufficient storage density to be used as a compact long term storage solution. Items in PermanentStorage racks can be stored in these racks, while items in non-PermanentStorage racks must be removed from the rack during Storage, StoreAll, and ProcessingStorage tasks.",
			Category -> "Operating Limits"
		},
		SupportedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][AssociatedAccessories,1],
			Description -> "A list of instruments for which this container model is an accompanying accessory.",
			Category -> "Qualifications & Maintenance"
		},
		CompatibleMixers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, Roller][CompatibleRacks]|Model[Instrument, Shaker][CompatibleAdapters],
			Description -> "A list of instruments that this rack model can support to hold samples during mixing. Currently, this is only applicable for rollers and shakers.",
			Category -> "Model Information"
		},
		CompatibleVolumetricFlasks ->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Vessel, VolumetricFlask][CompatibleAdapters],
			Description -> "Volumetric flasks that can be used with this shaker adapter when mixing with shaker.",
			Category -> "Model Information"
		}
	}
}];
