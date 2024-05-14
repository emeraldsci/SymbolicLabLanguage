

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Method, FractionCollection], {
	Description->"A description of chromatography fraction collection parameters.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		FractionCollectionMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FractionCollectionModeP,
			Description -> "The mode by which fractions are collected, based either on always collecting peaks in a given time range, collecting peaks when ever absorbance crosses above a threshold value, or based on the steepness of a peak's slope.",
			Category -> "General",
			Abstract -> True
		},
		FractionCollectionDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "The type of measurement that is used as signal to trigger fraction collection.",
			Category -> "General"
		},
		FractionCollectionStartTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The time before which no fractions will be collected.",
			Category -> "General"
		},
		FractionCollectionEndTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "The time after which no fractions will be collected.",
			Category -> "General"
		},
		MaxFractionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter*Milli],
			Units -> Liter Milli,
			Description -> "The maximum volume to be collected in a single fraction after which a new fraction will be generated.",
			Category -> "General"
		},
		MaxCollectionPeriod -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The maximum amount to collect in a single fraction after which a new fraction will be generated when FractionCollectionMode is Time.",
			Category -> "General"
		},
		FractionCollectionTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "The temperature at which the fractions are held during and after collection.",
			Category -> "General"
		},
		PeakSlopeDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The minimum duration that changes in slopes must be maintained before they are registered when FractionCollectionMode -> Peak.",
			Category -> "General"
		},
		PeakMinimumDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The least amount of time that changes in slopes must be maintained before they are registered when FractionCollectionMode -> Peak or Threshold.",
			Category -> "General"
		},
		AbsoluteThreshold -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli] | GreaterEqualP[0 Millisiemen/Centimeter] | UnitsP[0 Unit] | GreaterEqualP[0 RFU*Milli]),
			Description -> "The absorbance, fluorescence, circular dichroism or conductivity signal value above which fractions will always be collected when in Threshold mode.",
			Category -> "General"
		},
		PeakEndThreshold -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli] | GreaterEqualP[0 Millisiemen/Centimeter] | UnitsP[0 Unit]|GreaterEqualP[0 RFU*Milli]),
			Units -> None,
			Description -> "The  absorbance or conductivity signal value below which the end of a peak is marked and fraction collection stops.",
			Category -> "General"
		},
		PeakSlope -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli/Second] | GreaterEqualP[0 Millisiemen/(Centimeter Second)] | UnitsP[0 Unit / Second] | GreaterEqualP[0 RFU*Milli/Second]),
			Units -> None,
			Description -> "The minimum slope rate (per second) that must be met before a peak is detected and fraction collection begins.  A new peak (and new fraction) can be registered once the slope drops below this again, and collection ends when the PeakEndThreshold value is reached.",
			Category -> "General"
		},
		PeakSlopeEnd -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> (GreaterEqualP[0*AbsorbanceUnit*Milli/Second] | GreaterEqualP[0 Millisiemen/(Centimeter Second)] | UnitsP[0 Unit / Second] | GreaterEqualP[0 RFU*Milli/Second]),
			Units -> None,
			Description -> "The slope rate (per second) that indicates when to end Peak-based fraction collections.",
			Category -> "General"
		}
	}
}];
