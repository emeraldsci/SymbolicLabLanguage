(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,Lid], {
	Description->"Model information for a lid that can be placed on top of a container to non-hermetically cover it.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CoverType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CoverTypeP,
			Description -> "An enumerated symbol describing the cover this item represents. In addition to this field, NotchPositions and CoverFootprint are used to determine if a cover is compatible with a given container.",
			Category -> "Physical Properties"
		},
		CoverFootprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CoverFootprintP,
			Description -> "The footprint of the cover that is to be placed on a container.",
			Category -> "Physical Properties"
		},
		NotchPositions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> NotchPositionP,
			Description -> "The location of any cut-out notches in the corners of the lid.",
			Category -> "Physical Properties"
		},
		Opaque -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the exterior of this lid blocks the transmission of visible light.",
			Category -> "Physical Properties"
		},
		MinTransparentWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[1 Nanometer,1 Meter],
			Units -> Nanometer,
			Description -> "Minimum wavelength this type of lid allows to pass through, thereby allowing measurement of the sample covered using light source with larger wavelength.",
			Category -> "Container Specifications"
		},
		MaxTransparentWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[1 Nanometer,1 Meter],
			Units -> Nanometer,
			Description -> "Maximum wavelength this type of lid allows to pass through, thereby allowing measurement of the sample covered using light source with smaller wavelength.",
			Category -> "Container Specifications"
		},
		CondensationRings -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the lid has circular low-profile rings to catch any condensation.",
			Category -> "Physical Properties"
		},
		NumberOfRings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of individual condensation rings in the lid.",
			Category -> "Physical Properties"
		},
		Rows -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of rows of rings in the plate.",
			Category -> "Dimensions & Positions"
		},
		Columns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of columns of rings in the plate.",
			Category -> "Dimensions & Positions"
		},
		AspectRatio -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterP[0],
			Description -> "Ratio of the number of columns of rings vs the number of rows of rings on the lid.",
			Category -> "Dimensions & Positions"
		},
		RingDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Diameter of each round ring.",
			Category -> "Item Specifications"
		},
		HorizontalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance from the left edge of the lid to the edge of the first ring.",
			Category -> "Item Specifications"
		},
		VerticalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance from the top edge of the lid to the edge of the first ring.",
			Category -> "Item Specifications"
		},
		HorizontalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one ring to the next in a given row.",
			Category -> "Item Specifications"
		},
		VerticalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one ring to the next in a given column.",
			Category -> "Item Specifications"
		},
		HorizontalOffset-> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance between the center of ring A1 and ring B1 in the X direction.",
			Category -> "Item Specifications"
		},
		VerticalOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance between the center of ring A1 and ring A2 in the Y direction.",
			Category -> "Item Specifications"
		},
		LidThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Thickness of the lid material covering the opening portion of the container.",
			Category -> "Item Specifications"
		},
		LidPlateGripHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance the liquid handler arms should grip below the top edge of the lid to uncover when the lid is stacked on a container.",
			Category -> "Item Specifications",
			Developer -> True
		},
		LidStackGripHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance the liquid handler arms should grip below the top edge of the lid to remove it from the lid stack.",
			Category -> "Item Specifications",
			Developer -> True
		},
		InternalDimensions2D -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli, Meter Milli},
			Description -> "The dimensions of the internal rectangular cross sections of the lid.",
			Headers -> {"X dimension","Y dimension"},
			Category -> "Item Specifications"
		},
		RestingOrientation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FaceUp | FaceDown,
			Description -> "Indicates how lid should be placed when it's off the container.",
			Category -> "Storage & Handling"
		},
		Parameterizations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ParameterizeCover][ParameterizationModels],
			Description -> "The maintenance in which the dimensions, shape, and properties of this type of lid model was parameterized.",
			Category -> "Qualifications & Maintenance"
		},
		VerifiedCoverModel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this lid model is parameterized or if it needs to be parameterized and verified by the ECLs team.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		Verified -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the information in this model has been reviewed for accuracy by an ECL employee.",
			Category -> "Organizational Information"
		},
		VerifiedLog -> {
			Format -> Multiple,
			Class -> {Boolean, Link, Date},
			Pattern :> {BooleanP, _Link, _?DateObjectQ},
			Relation -> {Null, Object[User], Null},
			Headers -> {"Verified", "Responsible person", "Date"},
			Description -> "Records the history of changes to the Verified field, along with when the change occured, and the person responsible.",
			Category -> "Organizational Information"
		},
		PendingParameterization -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate whether this model is awaiting measurement and assessment of physical properties in the lab.",
			Category -> "Organizational Information",
			Developer -> True
		},
		AdditionalInformation -> {
			Format -> Multiple,
			Class -> {String, Date},
			Pattern :> {_String, _?DateObjectQ},
			Description -> "Supplementary information recorded from the UploadMolecule function. These information usually records the user supplied input and options, providing additional information for verification.",
			Headers -> {"Information", "Date Added"},
			Category -> "Hidden"
		},
		Weight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The mean weight of lids of this model. Experimental weights of new lids of this model must be within 5% of this weight.",
			Category -> "Physical Properties"
		},
		WeightDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "The statistical distribution of the mean weight of lids of this model.",
			Category -> "Physical Properties"
		},
		PreferredBalance -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BalanceModeP,
			Description -> "Indicates the recommended balance type for weighing a sample in this type of container.",
			Category -> "Physical Properties"
		}
	}
}];
