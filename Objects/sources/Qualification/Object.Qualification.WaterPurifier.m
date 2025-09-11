(* ::Package:: *)

DefineObjectType[Object[Qualification, WaterPurifier], {
	Description -> "A protocol that verifies the functionality of the water purifier target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Experimental Results *)
		Alarm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the water purifier's screen was displaying any warnings or alarms during this qualification.",
			Category -> "Experimental Results"
		},
		WaterDispensed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the water purifier was able to dispense water when the dispenser's trigger was activated.",
			Category -> "Experimental Results"
		},
		QualityReportImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photograph taken of the water quality report displayed on the water purifier's screen after water was dispensed.",
			Category -> "Experimental Results"
		},
		QualityReport -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "For instrument Models with QRCode->True, a string of the information contained in the quick response code within the QualityReportImage.",
			Category -> "Experimental Results"
		},
		Resistivity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Megaohm Centimeter],
			Units -> Megaohm Centimeter,
			Description -> "The recorded resistivity of the water dispensed by the water purifier.",
			Category -> "Experimental Results"
		},
		TotalOrganicCarbon -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PPB],
			Units -> PPB,
			Description -> "The parts per billion of total organic carbon (ppb TOC) measured in the the water dispensed by the water purifier.",
			Category -> "Experimental Results"
		},
		Temperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "The recorded temperature of the water dispensed by the water purifier.",
			Category -> "Experimental Results"
		},
		Volume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Liter,
			Description -> "The recorded volume of the water dispensed by the water purifier.",
			Category -> "Experimental Results"
		}
	}
}];