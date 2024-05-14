
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, CrossFlowFiltration], {
	Description->"The model for a cross-flow filtration instrument designed to purify many different kinds of samples, from protein solutions to nanoparticles to cells.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		(* ---------- Instrument Specifications ---------- *)

		PrimaryPump->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,PeristalticPump],
			Description->"The device used to circulate the retentate.",
			Category->"Instrument Specifications"
		},

		SecondaryPump->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,PeristalticPump],
			Description->"The device used to introduce the diafiltration buffer.",
			Category->"Instrument Specifications"
		},

		FeedScale->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,Balance],
			Description->"The balance used to weigh the sample during the experiment.",
			Category->"Instrument Specifications"
		},

		PermeateScale->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,Balance],
			Description->"The balance used to weigh the permeate during the experiment.",
			Category->"Instrument Specifications"
		},

		Detectors->{
			Format->Multiple,
			Class->Expression,
			Pattern:>CrossFlowFiltrationDetectorTypeP,
			Description->"A list of devices that can monitor a variety of signals during the experiment.",
			Category->"Instrument Specifications"
		},

		AbsorbanceDetector->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Part,Spectrophotometer],
			Description->"The device used to measure the optical absorbance.",
			Category->"Instrument Specifications"
		},

		(* ---------- Operating Limits ---------- *)

		MinMeasurableConductivity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Siemens/Meter],
			Units->Milli Siemens/Centimeter,
			Description->"The smallest amount of electrical conductivity that the detector can measure reliably.",
			Category->"Operating Limits"
		},

		MaxMeasurableConductivity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Siemens/Meter],
			Units->Milli Siemens/Centimeter,
			Description->"The largest amount of electrical conductivity that the detector can measure reliably.",
			Category->"Operating Limits"
		},

		ConductivityAccuracy->{
			Format->Multiple,
			Class->{RangeMin->Real,RangeMax->Real,Accuracy->Real},
			Pattern:>{RangeMin->GreaterP[0 Milli Siemens/Centimeter],RangeMax->GreaterP[0 Milli Siemens/Centimeter],Accuracy->Alternatives[GreaterP[0 Milli Siemens/Centimeter],Percent]},
			Units->{RangeMin->Milli Siemens/Centimeter,RangeMax->Milli Siemens/Centimeter,Accuracy->Milli Siemens/Centimeter},
			Headers->{RangeMin->"Range Min",RangeMax->"Range Max",Accuracy->"Accuracy"},
			Description->"How close the values measured by the detector are to the real value.",
			Category->"Operating Limits"
		},
		
		MinMeasurableTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"The lowest temperature that the detector can measure reliably.",
			Category->"Operating Limits"
		},

		MaxMeasurableTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"The highest temperature that the detector's can measure reliably.",
			Category->"Operating Limits"
		},

		TemperatureAccuracy->{
			Format->Single,
			Class->Real,
			Pattern:>Alternatives[GreaterP[0 Kelvin],Percent],
			Units->Celsius,
			Description->"How close the values measured by the detector are to the real value.",
			Category->"Operating Limits"
		},

		MinAbsorbanceWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Meter, 1 Meter],
			Units->Nanometer,
			Description->"The minimum wavelength that the detector can measure.",
			Category->"Operating Limits"
		},

		MaxAbsorbanceWavelength->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0 Meter, 1 Meter],
			Units->Nanometer,
			Description->"The maximum wavelength that the detector can measure.",
			Category->"Operating Limits"
		}
	}
}];
