(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, PlateSeal], {
	Description->"Model information for a flexible item that attaches to the top of a plate (in order to protect its contents) via an adhesive, temperature activated adhesive, or press fit.",
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
		SealType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SealTypeP,
			Description -> "An enumerated symbol describing how this seal is attached to a plate.",
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
			Description -> "Minimum wavelength this type of PlateSeal allows to pass through, thereby allowing measurement of the sample covered using light source with larger wavelength.",
			Category -> "Container Specifications"
		},
		MaxTransparentWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[1 Nanometer,1 Meter],
			Units -> Nanometer,
			Description -> "Maximum wavelength this type of PlateSeal allows to pass through, thereby allowing measurement of the sample covered using light source with smaller wavelength.",
			Category -> "Container Specifications"
		},
		CondensationRings -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the lid has circular low-profile rings to catch any condensation.",
			Category -> "Physical Properties"
		},
		NotchPositions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> NotchPositionP,
			Description -> "The location of any diagonal cuts on the corners of the plate seal.",
			Category -> "Physical Properties"
		},
		Pierceable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this plate seal can be pierced by a needle.",
			Category -> "Physical Properties"
		},
		Breathable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether vapor can pass through the seal or holes in the plate seal.",
			Category -> "Physical Properties"
		},
		VerifiedCoverModel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this plate seal model is parameterized or if it needs to be parameterized and verified by the ECLs team.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Indicates the minimum temperature rating for the plate seal.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the maximum temperature rating for the plate seal.",
			Category -> "Operating Limits"
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
			Description -> "The maintenance in which the dimensions, shape, and properties of this plate seal model was parameterized.",
			Category -> "Qualifications & Maintenance"
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
		UnresolvedInputs -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The raw inputs provided by the user when creating this cover model via the UploadCoverModel function.",
			Category -> "Organizational Information",
			Developer -> True
		},
		UnresolvedOptions -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {(_Rule | _RuleDelayed)...},
			Description -> "The options provided by the user when creating this cover model via the UploadCoverModel function.",
			Category -> "Organizational Information",
			Developer -> True
		},
		ReplacementObject -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Cap][DeprecatedModels],
				Model[Item, Lid][DeprecatedModels],
				Model[Item, PlateSeal][DeprecatedModels]
			],
			Description -> "The new cover model object created by an ECL personnel that replaces the current one. User-created cover model can potentially be replaced entirely during the verification process if the Type of the cover model is determined to be incorrect.",
			Category -> "Organizational Information",
			AdminWriteOnly -> True
		},
		DeprecatedModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Cap][ReplacementObject],
				Model[Item, Lid][ReplacementObject],
				Model[Item, PlateSeal][ReplacementObject]
			],
			Description -> "User-created cover models that have been replaced by this current cover model by ECL personnel.",
			Category -> "Organizational Information",
			AdminWriteOnly -> True
		},
		PendingParameterization -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate whether this model is awaiting measurement and assessment of physical properties in the lab.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Weight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The mean weight of plate seals of this model. Experimental weights of new plate seals of this model must be within 5% of this weight.",
			Category -> "Physical Properties"
		},
		WeightDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "The statistical distribution of the mean weight of plate seals of this model.",
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
