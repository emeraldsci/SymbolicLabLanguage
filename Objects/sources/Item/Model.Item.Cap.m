(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item,Cap], {
	Description->"Model information for cap used to cover a vessel.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CoverType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CoverTypeP,
			Description -> "An enumerated symbol describing the cover this item represents. In addition to this field, ThreadType and CoverFootprint are used to determine if a cover is compatible with a given container.",
			Category -> "Physical Properties"
		},
		CoverFootprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CoverFootprintP,
			Description -> "The footprint of the cover that is to be placed on a container.",
			Category -> "Physical Properties"
		},
		CrimpType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CrimpTypeP,
			Description -> "The type of crimping that is required to attach this cap to the container. Only applies if CoverType->Crimp.",
			Category -> "Physical Properties"
		},
		ThreadType -> {
			Format -> Single,
			Class -> String,
			Pattern :> NeckTypeP,
			Description -> "The GPI/SPI Neck Finish designation of the cap that is used to determine compatible neck threadings.",
			Category -> "Physical Properties"
		},
		SeptumRequired -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that a septum must be placed under the cap before it can be used. Septum compatibility is determined based on the CoverFootprint field.",
			Category -> "Physical Properties"
		},
		TaperGroundJointSize->{
			Format -> Single,
			Class -> String,
			Pattern :> GroundGlassJointSizeP,
			Description -> "The taper ground joint size designation of the cap. If populated, this cap must be secured to the container using a keck clamp that has the same TaperGroundJointSize.",
			Category -> "Physical Properties"
		},
		Opaque -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the exterior of this lid blocks the transmission of visible light.",
			Category -> "Physical Properties"
		},
		Pierceable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this cap can be pierced by a needle.",
			Category -> "Physical Properties"
		},
		Breathable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates whether vapor can pass through the cap or holes in the cap.",
			Category -> "Physical Properties"
		},
		MaxResealingGauge -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The largest needle size that still leaves the cap resealable after piercing.",
			Category -> "Physical Properties"
		},
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> PressureP,
			Units -> PSI,
			Description -> "Indicates the minimum pressure rating for the cap.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "Indicates the maximum pressure rating for the cap.",
			Category -> "Physical Properties"
		},
		CrimpingPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "The default pressure to set the crimping instrument to when securing or removing an object of this model from a container. This field can only be set for crimped caps.",
			Category -> "Physical Properties"
		},
		Barcode -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this cap should have a barcode sticker placed on it. If caps are not barcoded, they are placed on a cap rack (which is barcoded) whenever they are taken off of containers. Caps must be barcoded if they are over 54mm (the diameter of a GL45 cap, which is the largest cover that we can fit on our cap racks). If set to Null, indicates that the cap is not barcoded.",
			Category -> "Physical Properties"
		},

		(* --- Dimensions & Positions --- *)
		Positions -> {
			Format -> Multiple,
			Class -> {Name->String,Footprint->Expression,MaxWidth->Real,MaxDepth->Real,MaxHeight->Real},
			Pattern :> {Name->LocationPositionP,Footprint->(FootprintP|Open),MaxWidth->GreaterP[0 Centimeter],MaxDepth->GreaterP[0 Centimeter],MaxHeight->GreaterP[0 Centimeter]},
			Units -> {Name->None,Footprint->None,MaxWidth->Meter,MaxDepth->Meter,MaxHeight->Meter},
			Description -> "Spatial definitions of the positions that exist in this model of item cap.",
			Headers->{Name->"Name of Position",Footprint->"Footprint",MaxWidth->"Max Width",MaxDepth->"Max Depth",MaxHeight->"Max Height"},
			Category -> "Dimensions & Positions"
		},
		PositionPlotting -> {
			Format -> Multiple,
			Class -> {Name->String,XOffset->Real,YOffset->Real,ZOffset->Real,CrossSectionalShape->Expression,Rotation->Real},
			Pattern :> {Name->LocationPositionP,XOffset->GreaterEqualP[0 Meter],YOffset->GreaterEqualP[0 Meter],ZOffset->GreaterEqualP[0 Meter],CrossSectionalShape->CrossSectionalShapeP,Rotation->GreaterEqualP[-180]},
			Units -> {Name->None,XOffset->Meter,YOffset->Meter,ZOffset->Meter,CrossSectionalShape->None,Rotation->None},
			Description -> "For each member of Positions, the parameters required to plot the position, where the offsets refer to the location of the center of the position relative to the close, bottom, left hand corner of the item cap model's dimensions.",
			IndexMatching -> Positions,
			Headers->{Name->"Name of Position",XOffset->"XOffset",YOffset->"YOffset",ZOffset->"ZOffset",CrossSectionalShape->"Cross Sectional Shape",Rotation->"Rotation"},
			Category -> "Dimensions & Positions",
			Developer -> True
		},
		
		(*Dimension fields for aspiration cap*)
		AspirationTubeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The length of the tubing used to aspirate liquid from a container to which this cap is attached, measured from the end of the tubing to the point where the tubing attaches to the cap.",
			Category -> "Dimensions & Positions"
		},
		LevelSensorType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LevelSensorTypeP,
			Description -> "The type of volume sensor mounting to which this aspiration cap connects for sensornet volume monitoring.",
			Category -> "Compatibility"
		},
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The diameter of the hollow, fluid-containing portion of this plumbing component.",
			Category -> "Plumbing Information",
			Abstract->True
		},
		OuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The diameter of the entire plumbing component, orthogonal to the flow of fluid.",
			Category -> "Plumbing Information",
			Abstract->True
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Indicates the minimum temperature rating for the cap.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "Indicates the maximum temperature rating for the cap.",
			Category -> "Physical Properties"
		},
		MicrowaveSafe -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the cap can be used for microwave synthesis or digestion.",
			Category -> "Compatibility"
		},
		ControlledPressureRelease -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the cap can be vented to relieve a specified amount of pressure.",
			Category -> "Physical Properties"
		},
		BlowOffValve -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this cap is vented when the MaxPressure is reached.",
			Category -> "Physical Properties"
		},
		Parameterizations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ParameterizeCover][ParameterizationModels],
			Description -> "The maintenance in which the dimensions, shape, and properties of this type of cap model was parameterized.",
			Category -> "Qualifications & Maintenance"
		},
		VerifiedCoverModel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this cover model is parameterized or if it needs to be parameterized and verified by the ECLs team.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		InternalDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The depth of pHProbe inside of the vessel when the cap is covered in AdjustpH experiments. This depth is measured as the vertical distance from the top of the container.",
			Category -> "Dimensions & Positions"
		},
		InternalDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The required minimum interior diameter of the vessel to fit pHProbe when the cap is covered in AdjustpH experiments.",
			Category -> "Dimensions & Positions"
		},
		pHProbe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part, pHProbe],
			Description -> "The pH probe associated with this cap that directly immerses into samples for measurement.",
			Category -> "Instrument Specifications"
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
			Description -> "The mean weight of caps of this model. Experimental weights of new caps of this model must be within 5% of this weight.",
			Category -> "Physical Properties"
		},
		WeightDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "The statistical distribution of the mean weight of caps of this model.",
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
