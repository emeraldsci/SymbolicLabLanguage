

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Plate], {
	Description->"A model for a container that stores lab samples in individual wells. Often meets the ANSI/SBS plate dimensions standard.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		PlateColor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateColorP,
			Description -> "The color of the main body of the plate.",
			Category -> "Container Specifications"
		},
		WellColor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PlateColorP,
			Description -> "The color of the bottom of the wells of the plate.",
			Category -> "Container Specifications"
		},
		WellDimensions -> {
			Format -> Single,
			Class -> {Real,Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli,Meter Milli},
			Headers -> {"Width","Depth"},
			Description -> "Internal size of the each well in this model of plate.",
			Category -> "Container Specifications"
		},
		WellDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Diameter of each round well.",
			Category -> "Container Specifications"
		},
		HorizontalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance from the left edge of the plate to the edge of the first well.",
			Category -> "Container Specifications"
		},
		VerticalMargin -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Distance from the top edge of the plate to the edge of the first well.",
			Category -> "Container Specifications"
		},
		DepthMargin -> {
			Format -> Single,
			Class -> Real,
			(* Intentionally leave this open to negative values for cases where wells protrude beyond skirt (e.g., filter plates) *)
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Z-axis distance from the bottom of the plate to the bottom of the first well.",
			Category -> "Container Specifications"
		},
		MaxViewingAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0 AngularDegree, 180 AngularDegree],
			Units -> AngularDegree,
			Description -> "The angle from 0 to 180 degrees that defines a Conical shape from the bottom center point of the well to the top outside edge of the well. At any viewing angle larger than this, there exists a rotation that is not be able to see the bottom center of the well.",
			Category -> "Container Specifications"
		},
		WellBottomThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Micrometer],
			Units -> Micrometer,
			Description -> "The thickness of container material that constitutes the bottom of the well.",
			Category -> "Container Specifications"
		},
		Skirted -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container has walls that extend below the vessel's well geometry to allow the vessel to stand upright on a flat surface without use of a rack. For liquid handler compatible plates, this is used to calculate additional parameters for liquid handler applications.",
			Category -> "Container Specifications"
		},
		SkirtHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the bottom lip of the skirt that surrounds the plate to the very top of the plate.",
			Category -> "Container Specifications"
		},
		StackHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "When this plate is stacked on top of another plate, the distance between the top of this plate and the top of the plate below.",
			Category -> "Container Specifications"
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
		BottomCavity3D -> {
			Format -> Multiple,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter], GreaterEqualP[0*Milli*Meter]},
			Units -> {Meter Milli, Meter Milli,Meter Milli},
			Description -> "A list of internal rectangular cross sections describing the empty space at the bottom of a plate.",
			Headers -> {"X dimension","Y dimension","Z height"},
			Category -> "Dimensions & Positions"
		},
		VerifiedContainerModel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container model is parameterized or if it needs to be parameterized and verified by the ECLs team.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		VerifiedHamiltonContainerModel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container model is verified on the Hamilton liquid handler through ECL's VerifyHamiltonLabware qualification.",
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
		LabwareVerifications -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Qualification,VerifyHamiltonLabware][VerificationModels],
			Description -> "The qualification in which the Hamilton labware definition of this labware is verified.",
			Category -> "Qualifications & Maintenance"
		},
		FlangeHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The distance from the bottom of the plate to the top surface of the flange protruding from the plate wall around the bottom perimeter of the plate.",
			Category -> "Container Specifications"
		},
		FlangeWidth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The distance from the wall of the plate to the exterior side surface of the flange protruding from the plate wall around the bottom perimeter of the plate.",
			Category -> "Container Specifications"
		},
		HorizontalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one well to the next in a given row.",
			Category -> "Container Specifications"
		},
		VerticalPitch -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Center-to-center distance from one well to the next in a given column.",
			Category -> "Container Specifications"
		},
		HorizontalOffset-> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance between the center of well A1 and well B1 in the X direction.",
			Category -> "Container Specifications"
   		},
		VerticalOffset -> {
			Format -> Single,
			Class -> Real,
			Pattern :> DistanceP,
			Units -> Meter Milli,
			Description -> "Distance between the center of well A1 and well A2 in the Y direction.",
			Category -> "Container Specifications"
		},
		WellDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Maximum z-axis depth of each well.",
			Category -> "Container Specifications"
		},
		WellBottom -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellShapeP,
			Description -> "Shape of the bottom of each well.",
			Category -> "Container Specifications"
		},
		ConicalWellDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Depth of the conical section of the well.",
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
		Rows -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of wells in the plate from front to back - in the shorter horizontal direction if the plate is not square.",
			Category -> "Dimensions & Positions"
		},
		Columns -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of wells in the plate from left to right - in the longer horizontal direction if the plate is not square.",
			Category -> "Dimensions & Positions"
		},
		NumberOfWells -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of individual contents-holding cavities the plate has.",
			Category -> "Dimensions & Positions"
		},
		AspectRatio -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterP[0],
			Description -> "Ratio of the number of columns of wells vs the number of rows of wells on the plate.",
			Category -> "Dimensions & Positions"
		},
		RecommendedFillVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The largest recommended fill volume in the wells of this plate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxCentrifugationForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The maximum relative centrifugal force this plate is capable of withstanding.",
			Category -> "Operating Limits"
		},
		ReferenceVolumeData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Reference volume data conducted on empty plates of this modelContainer.",
			Category -> "Experimental Results"
		},
		ReferenceAbsorbanceSpectra -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Reference absorbance spectra taken on empty plates of this modelContainer.",
			Category -> "Experimental Results"
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
		LiquidHandlerPrefix->{
		    Format->Single,
		    Class->String,
		    Pattern:>_String,
		    Description->"The unique labware ID string prefix used to reference this model of plate on a robotic liquid handler.",
		    Category -> "General",
		    Developer->True
		},
		HighPrecisionPositionRequired->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this container model should be handled on a high precision position on a robotic liquid handler.",
			Category -> "General",
			Developer->True
		},
		MultiProbeHeadIncompatible->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if this container model can be the source or destination container of a multi-probe head transfer on a robotic liquid handler.",
			Category -> "Compatibility",
			Developer->True
		},
		LiquidHandlerAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Model[Container, Spacer]
			],
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
		LidSpacerRequired -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a spacer must be placed on top of the plate during automated liquid handling to prevent the plate lid from contacting samples in the plate.",
			Category -> "General",
			Developer -> True
		},
		BMGLayout -> {
			Format -> Single,
			Class -> String,
			Pattern :> BMGPlateFormatNameP,
			Description -> "The string indicating to the BMG plate readers the well layout of a given microtiter plate.",
			Category -> "General",
			Developer -> True
		},
		MetaXpressPrefix->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The unique labware ID string prefix used to reference this plate model in the MetaXpress software.",
			Category -> "General",
			Developer->True
		},
		ProductsContained -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][DefaultContainerModel],
			Description -> "Products representing regularly ordered items that are delivered in this type of container by default.",
			Category -> "Inventory",
			Developer->True
		},
		(* --- Quality Assurance --- *)
		CalibrationPlate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether this plate model is used for calibrating instruments.",
			Category -> "Quality Assurance"
		},
		ReceivingBatchInformation -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FieldP[Object[Report,Certificate,Analysis], Output->Short],
			Description -> "A list of the required fields populated by receiving.",
			Category -> "Quality Assurance"
		},
		ReceivingBatchCertificateExample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Report,Certificate][ModelsSupported],
			Description -> "Certificate example that contains images for where receiving batch information can be found on documentation.",
			Category -> "Quality Assurance"
		},
		InstrumentsCalibrated -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "If the plate is used for calibration, a list of instrument models that can be calibrated by this plate; must be informed if CalibrationPlate is True.",
			Category -> "Quality Assurance"
		},
		(* Fields for spectral calibration *)
		CalibrationWavelengths -> {
			Format -> Multiple,
			Class -> {Wavelength->VariableUnit, Tolerance->VariableUnit, Source->Link},
			Pattern :> {Wavelength->GreaterP[0*Nanometer],Tolerance->GreaterP[0*Nanometer], Source->_Link|Null},
			Relation -> {Wavelength->Null, Tolerance->Null, Source->Model[Sample]|Model[Molecule]|Null},
			Description -> "If the plate is used for calibration, a list of the wavelength(s) used for instrument calibration with their allowed tolerances and the source of the wavelength (sample or molecule); use Null if the source of the wavelength is the plate material itself.",
			Category -> "Quality Assurance"
		},
		(* Health and Safety *)
		MSDSRequired->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if an MSDS is applicable for this container model.",
			Category->"Health & Safety"
		},
		MSDSFile->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"A PDF file of the MSDS (Materials Safety Data Sheet) of this plate model.",
			Category->"Health & Safety"
		},
		NFPA->{
			Format->Single,
			Class->Expression,
			Pattern:>NFPAP,
			Description->"The National Fire Protection Association (NFPA) 704 hazard diamond classification for this plate model. The NFPA diamond standard is maintained by the United States National Fire Protection Association and summarizes, clockwise from top, Fire Hazard, Reactivity, Specific Hazard and Health Hazard of a substance.",
			Category->"Health & Safety"
		},
		DOTHazardClass->{
			Format->Single,
			Class->String,
			Pattern:>DOTHazardClassP,
			Description->"The Department of Transportation hazard classification of this plate model.",
			Category->"Health & Safety"
		}
	}
}];
