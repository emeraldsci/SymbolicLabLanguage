(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, Camera], {
	Description->"A camera used by instruments for taking images of samples and containers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {		
		EmbeddedPC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, EmbeddedPC][ConnectedDevices],
			Description -> "The CPU module used to control this camera.",
			Category -> "Part Specifications"
		},
		PLCVariableName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the variable that refers to this camera on the PLC that controls the camera.",
			Category -> "Part Specifications",
			Developer->True
		},
		SampleImager -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, SampleImager][SmallCamera],
				Object[Instrument, SampleImager][MediumCamera],
				Object[Instrument, SampleImager][LargeCamera]
			],
			Description -> "The sample imager to which this camera is attached.",
			Category -> "Part Specifications"
		},
		SampleInspector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, SampleInspector][Camera],
			Description -> "The sample inspector to which this camera is attached.",
			Category -> "Part Specifications"
		},
		TargetSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TargetSize]],
			Pattern :> CameraCategoryP,
			Description -> "The approximate size of the items which this model of camera is intended to image.",
			Category ->"Part Specifications"
		},
		MonitoredLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][Cameras, 2],
				Object[Instrument][Cameras, 2]
			],
			Description -> "The Instrument or Container that this camera is currently monitoring.",
			Category -> "Imaging"
		},
		IP -> {
			Format -> Single,
			Class -> String,
			Pattern :> IpP,
			Description -> "The IP of the camera on the camera server.",
			Category -> "Part Specifications",
			Developer->True
		},
		PostRotation -> {
			Format -> Single,
			Class -> Real, 
			Pattern :> RangeP[Quantity[-360, "Degrees"], Quantity[360, "Degrees"]],
			Units -> Quantity[1, "Degrees"],
  		Description -> "Angular rotation to apply to the images captured with this camera.", 
			Category -> "Part Specifications", 
			Developer -> True
		},
		Data -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Appearance][Camera],
			Description -> "All data obtained using this camera.",
			Category -> "Sensor Information"
		},
		FieldOfView -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CameraFieldOfViewP,
			Description -> "The horizonal length of the uncropped image.",
			Category -> "Part Specifications"
		},
		Illumination -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IlluminationDirectionP,
			Description -> "The direction from which the sample was illuminated.",
			Category ->"Part Specifications"
		},
		ExposureTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Millisecond,
			Description -> "The length of time for which a camera shutter stayed open while taking this image.",
			Category -> "Part Specifications"
		},
		ServerURL -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The unique server URL that generates a server when GoPros stream.",
			Category -> "Part Specifications"
		},
		StreamKey ->{
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], StreamKey]],
			Pattern :> _String,
			Description -> "The stream key GoPros use to access streaming server.",
			Category -> "Part Specifications"
		}
	}
}];
