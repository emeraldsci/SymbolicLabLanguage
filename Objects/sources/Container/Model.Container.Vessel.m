(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Vessel], {
	Description->"A description of a type of vessel (bottles, tubes, flasks etc.) which contains a sample in a single chamber.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "Resolution of the vessel's volume-indicating markings.",
			Category -> "Container Specifications"
		},
		NeckType -> {
			Format -> Single,
			Class -> String,
			Pattern :> NeckTypeP,
			Description -> "The GPI/SPI Neck Finish designation of the vessel used to determine the cap threading.",
			Category -> "Container Specifications"
		},
		TaperGroundJointSize -> {
			Format -> Single,
			Class -> String,
			Pattern :> GroundGlassJointSizeP,
			Description -> "The taper ground joint size designation of the mouth on this vessel.",
			Category -> "Container Specifications"
		},
		Dropper -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this vessel has an attachment in the aperture that allows it to only dispense liquid via drop creation.",
			Category -> "Container Specifications"
		},
		DepthMargin -> {
			Format -> Single,
			Class -> Real,
			(* Intentionally leave this open to negative values for cases where wells protrude beyond skirt (e.g., filter tubes) *)
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance from the bottom of the vessel to the inside bottom of its contents-holding position.",
			Category -> "Container Specifications"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli,Meter Milli},
			Headers -> {"Width","Depth"},
			Description -> "Interior size of the vessel's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		InternalDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Diameter of the vessel's contents holding cavity if the cavity is circular. If the cavity is not circular, InternalDimensions field should be used instead.",
			Category -> "Dimensions & Positions"
		},
		Aperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter Milli,
			Description -> "The minimum opening diameter encountered when aspirating from the container.",
			Category -> "Dimensions & Positions"
		},
		InternalDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the aperture to the bottom of vessel's contents-holding cavity.",
			Category -> "Dimensions & Positions"
		},
		InternalBottomShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellShapeP,
			Description -> "Shape of the bottom of the vessel's contents holding cavity. This is used to calculate the 3D shape and positions of the wells, which is especially important for application on liquid handlers.",
			Category -> "Dimensions & Positions"
		},
		InternalConicalDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Height of the conical section of the vessel's contents holding cavity.",
			Category -> "Container Specifications"
		},
		CappedHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The overall height of the vessel with the cap on, if applicable (height in Dimensions field represents uncapped height).",
			Category -> "Dimensions & Positions"
		},
		HandPumpRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if an external hand pump is required to remove liquid from this model of container.",
			Category -> "Container Specifications",
			Developer -> True
		},
		AspirationCaps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Cap],
			Description -> "The models of caps with integrated tubing that can be used to transfer liquids into and out of this container.",
			Category -> "Container Specifications"
		},
		Skirted -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container has walls that extend below the vessel's well geometry to allow the vessel to stand upright on a flat surface without use of a rack.",
			Category -> "Container Specifications"
		},
		MaxCentrifugationForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The maximum relative centrifugal force this vessel is capable of withstanding.",
			Category -> "Operating Limits"
		},
		ProductsContained -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][DefaultContainerModel],
			Description -> "Products representing regularly ordered items that are delivered in this type of vessel by default.",
			Category -> "Inventory",
			Developer->True
		},
		VolumeCalibrations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Calibration, Volume][ContainerModels],
			Description -> "Pathlength-to-volume calibrations performed on this model of container.",
			Category -> "Experimental Results",
			Developer->True
		},
		Counterweights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Counterweight][Counterweights],
			Description -> "The counterweight models that can be used to counterbalance this container model for centrifugation.",
			Category -> "General",
			Developer -> True
		},
		VerifiedContainerModel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container model is parameterized or if it needs to be parameterized and verified by the ECLs team.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		Parameterizations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ParameterizeContainer][ParameterizationModels],
			Description -> "The maintenance in which the dimensions, shape, and properties of this type of container model was parameterized.",
			Category -> "Qualifications & Maintenance"
		},
		PlateRackable-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container model fits into a rack which adapts it to a format matching a plate configuration.",
			Category -> "Qualifications & Maintenance"
		},
		SelfStandingContainers->{
			Format->Multiple,
			Class->Link,
			Pattern :> _Link,
			Relation->Model[Container,Rack],
			Description->"Model of a container capable of holding this type of vessel upright.",
			Category->"Compatibility"
		},
		PlateImagerRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack],
			Description -> "Model of a rack that can be used to image this container on a plate imager instrument.",
			Category -> "Compatibility"
		},
		SampleImagerRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack],
			Description -> "Model of a rack that can be used to image this container on a sample imager instrument.",
			Category -> "Compatibility"
		},
		Graduations->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The markings on this container model used to indicate the fluid's fill level.",
			Abstract->True,
			Category -> "Container Specifications"
		},
		LiquidHandlerRackID->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The labware definition of the robotic liquid handler racks that can hold this model of container.",
			Category -> "General",
			Developer->True
		},
		LiquidHandlerAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack],
			Description -> "Model of a rack that can be used to hold these vessels on a liquid handler deck.",
			Developer -> True,
			Category -> "Compatibility"
		},
		(* VacuumCentrifugeCompatibility used to echo CentrifugeCompatibility, which has been phased out in favor of using the footprint system. This field is also slated for removal.*)
		VacuumCentrifugeCompatibility -> {
			Format -> Multiple,
			Class -> {
				Instrument->Link,
				Rotor->Link,
				Bucket->Link,
				Rack->Link
			},
			Pattern :> {
				Instrument ->_Link,
				Rotor ->_Link,
				Bucket ->_Link,
				Rack ->_Link
			},
			Relation -> {
				Instrument->Model[Instrument,VacuumCentrifuge],
				Rotor->Model[Container, CentrifugeRotor],
				Bucket->Model[Container, CentrifugeBucket],
				Rack->Model[Container,Rack]
			},
			Units -> {
				Instrument ->None,
				Rotor ->None,
				Bucket ->None,
				Rack ->None
			},
			Headers -> {
				Instrument ->"Instrument Model",
				Rotor ->"Rotor Model",
				Bucket ->"Bucket Model",
				Rack -> "Rack Model"
			},
			Description -> "A listing of vacuum centrifuges and associated locations that this container model can be centrifuged on.",
			Developer -> True,
			Category -> "Compatibility"
		},
		ConnectedCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this vessel has a permanently attached cap.",
			Category -> "Physical Properties"
		},
		MaxOverheadMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description -> "The maximum allowable mixing rate this container can be used utilizing impeller on an overhead stirrer without inducing overflow or spillage.",
			Category -> "Compatibility"
		},
		GraduationTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GraduationTypeP,
			Description -> "For each member of Graduations, indicates if the graduation is labeled with a number, a long unlabeled line, or a short unlabeled line.",
			Category -> "Container Specifications",
			IndexMatching -> Graduations
		},
		GraduationLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Graduations, if GraduationTypes is Labeled, exactly matches the labeling text. Otherwise, Null.",
			Category -> "Container Specifications",
			IndexMatching -> Graduations,
			Developer -> True
		}
	}
}];
