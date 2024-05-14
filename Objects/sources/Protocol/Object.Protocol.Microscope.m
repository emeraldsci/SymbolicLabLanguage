

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, Microscope], {
	Description->"A protocol that uses an epifluorescence microscope to take highly magnified images of very small specimems.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Microscope -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The microscope instrument used the take the photos during this protocol.",
			Category -> "General"
		},
		PlateModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of the plate of cells to be imaged.",
			Category -> "General"
		},
		DataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The directory where the microscope images resulting from this protocol are stored.",
			Category -> "General"
		},
		Objective -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Units -> None,
			Description -> "The degree of magnification provided by the objective lens, indicated by the number of times that the specimen is enlarged. For example 5X, 10X, 20X, etc.",
			Category -> "Imaging"
		},
		LightPath -> {
			Format -> Single,
			Class -> Real,
			Pattern :> LightPathP,
			Units -> Percent,
			Description -> "Indicates how the light is split between the objective and camera. 100% indicates all the light is diverted to the camera. 80% indicates that 80% of the light goes to the camera while the remaining 20% is diverted to the objective viewfinder.",
			Category -> "Imaging"
		},
		KohlerIllumination -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that the specimen is iluminated using Kohler illumination - which is a technique that ensures the specimen is evenly illuminated without the illumination source itself being visible in the image.",
			Category -> "Imaging"
		},
		PhaseContrastImage -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that a phase contrast image will be taken during this protocol.",
			Category -> "Imaging"
		},
		BlueFluorescenceImage -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that an image in the blue emission spectrum, appropriate for dyes such as DAPI, will be taken during this protocol.",
			Category -> "Imaging"
		},
		GreenFluorescenceImage -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that an image in the green emission spectrum, appropriate for dyes such as FITC and Cys2, will be taken during this protocol.",
			Category -> "Imaging"
		},
		RedFluorescenceImage -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that an image in the red emission spectrum, appropriate for dyes such as TRITC and Cy3, will be taken during this protocol.",
			Category -> "Imaging"
		},
		AutoFocusMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AutoFocusModeP,
			Description -> "Indicates which autofocus method should be used to reach the highest contrast ratio.\n\t\t\t\t\t\t\tThe 'Steps in Range' method will move the Z motor in discreet steps, as defined by the AutoFocusCoarseStep and AutoFocusFineStep. The motor will move up to 1/2 of the range defined in AutoFocusRange and step down for the entire range.\n\t\t\t\t\t\t\tThe 'Adaptive' method performs a search starting at the current Z position and moving up or down according to the measured contrast ratio.",
			Category -> "AutoFocus"
		},
		AutoFocusCoarseStep -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "The distance the objective moves, in every step, while attempting to automatically get a rough, initial focus of the specimen being imaged.",
			Category -> "AutoFocus"
		},
		AutoFocusFineStep -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "The distance the objective moves, in every step, while attempting to automatically get a final, fine focus of the specimen being imaged.",
			Category -> "AutoFocus"
		},
		AutoFocusRange -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micro*Meter],
			Units -> Meter Micro,
			Description -> "The range of distance within which automatic focusing is attempted using the Steps in Range method. The range is defined such that half of it lies above the AutoFocusStartPoint and half lies below the AutoFocusStartPoint.",
			Category -> "AutoFocus"
		},
		AutoFocusStartPoint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AutoFocusStartPointP,
			Description -> "If set to Fixed, the microscope will start auto focusing on each image from the same final focus point as the first image. If set to Automatic, the microscope will start auto focusing from the final focus point of each preceding image.",
			Category -> "AutoFocus"
		},
		PhaseContrastExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The length of time the camera image sensor is exposed to light for the phase contrast image.",
			Category -> "Exposure"
		},
		BlueFluorescenceExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The length of time the camera image sensor is exposed to light in the blue emission spectrum will be taken that is good for dyes such as a DAPI.",
			Category -> "Exposure"
		},
		GreenFluorescenceExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The length of time the camera image sensor is exposed to light in the green emission spectrum will be taken  that is good for dyes such as FITC and Cy2.",
			Category -> "Exposure"
		},
		RedFluorescenceExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Second],
			Units -> Milli Second,
			Description -> "The length of time the camera image sensor is exposed to light in the red emission spectrum will be taken that is good for dyes such as TRITC and Cy3.",
			Category -> "Exposure"
		},
		ScanPattern -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ScanPatternP,
			Description -> "The pattern of images to take in each well - either random points sampled from the well or a square tiled grid of points around the center of the well.",
			Category -> "Scan Area"
		},
		ScanRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The percentage of the well area, starting from 0% at the center of the well and increasing in a concentric circle to a maximum of 100% (encompassing the whole well), from which to sample image points if ScanPattern is selected to be \"Random\".",
			Category -> "Scan Area"
		},
		ImagesPerWell -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Units -> None,
			Description -> "The number of images to be taken in each well.",
			Category -> "Scan Area"
		},
		GridSize -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The number of images to take in each row and column of the grid, when ScanPattern is selected to be \"Tile Grid\".",
			Category -> "Scan Area"
		},
		FOVOverlap -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Percent],
			Units -> Percent,
			Description -> "The percentage of the field of view (FOV) of one image that overlaps with the neighbouring images in a grid of image points. This is only applicable when ScanPattern is selected to be \"Tile Grid\".",
			Category -> "Scan Area"
		},
		StainingProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, MitochondrialIntegrityAssay][AnalysisProtocol],
			Description -> "The staining protocol run prior to analysis of the cells by microscopy.",
			Category -> "Imaging"
		}
	}
}];
