(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, CrossFlowFiltration], {
	Description->"An instrument designed to purify many different kinds of samples using cross-flow filtration.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{

		(* ---------- Instrument Specifications ---------- *)
		
		PrimaryPump->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,PeristalticPump][Instrument],
			Description->"The device used to circulate the retentate.",
			Category->"Instrument Specifications"
		},
		
		SecondaryPump->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,PeristalticPump][Instrument],
			Description->"The device used to introduce the diafiltration buffer.",
			Category->"Instrument Specifications"
		},
		
		FeedScale->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,Balance][Instrument],
			Description->"The balance used to weigh the sample during the experiment.",
			Category->"Instrument Specifications"
		},
		
		PermeateScale->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,Balance][Instrument],
			Description->"The balance used to weigh the permeate during the experiment.",
			Category->"Instrument Specifications"
		},

		Detectors->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],Detectors]],
			Pattern:>CrossFlowFiltrationDetectorTypeP,
			Description->"A list of devices that can monitor a variety of signals during the experiment.",
			Category->"Instrument Specifications",
			Abstract->True
		},
		
		FeedPressureSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,PressureSensor],
			Description->"The device used to measure the pressure of the solution going into the filter.",
			Category->"Instrument Specifications"
		},
		
		RetentatePressureSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,PressureSensor],
			Description->"The device used to measure the pressure of the solution going into the retentate line from the filter.",
			Category->"Instrument Specifications"
		},
		
		PermeatePressureSensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,PressureSensor],
			Description->"The device used to measure the pressure of the solution going into the permeate line from the filter.",
			Category->"Instrument Specifications"
		},
		
		RetentateConductivitySensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,ConductivitySensor],
			Description->"The device used to measure the conductivity of the retentate.",
			Category->"Instrument Specifications"
		},
		
		PermeateConductivitySensor->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,ConductivitySensor],
			Description->"The device used to measure the conductivity of the permeate.",
			Category->"Instrument Specifications"
		},
		
		AbsorbanceDetector->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part,Spectrophotometer],
			Description->"The type of device available to measure the optical absorbance.",
			Category->"Instrument Specifications"
		},

		PermeateValve->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Plumbing,Valve][ConnectedInstrument],
			Description->"The pinch valve installed between the filter permeate outlet and the conductivity sensor inlet to prevent filters from drying.",
			Category->"Instrument Specifications"
		},

		BackFlowValveCover->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,PinchValveCover],
			Description->"The cover used to prevent tubing from being misplaced on the automatic backflow valve.",
			Category->"Instrument Specifications"
		},
		(* ---------- Operating Limits ---------- *)
		
		MinMeasurableConductivity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],MinMeasurableConductivity]],
			Pattern:>GreaterP[0 Siemens/Meter],
			Description->"The smallest amount of electrical conductivity that the detector can measure reliably.",
			Category->"Operating Limits"
		},
		
		MaxMeasurableConductivity->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxMeasurableConductivity]],
			Pattern:>GreaterP[0 Siemens/Meter],
			Description->"The largest amount of electrical conductivity that the detector can measure reliably.",
			Category->"Operating Limits"
		},

		ConductivityAccuracy->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],ConductivityAccuracy]],
			Pattern:>Alternatives[GreaterP[0 Siemens/Meter],Percent],
			Description->"How close the values measured by the detector are to the real value.",
			Category->"Operating Limits"
		},

		MinMeasurableTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],MinMeasurableTemperature]],
			Pattern:>GreaterP[0 Celsius],
			Description->"The lowest temperature that the detector can measure reliably.",
			Category->"Operating Limits"
		},

		MaxMeasurableTemperature->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxMeasurableTemperature]],
			Pattern:>GreaterP[0 Celsius],
			Description->"The highest temperature that the detector's can measure reliably.",
			Category->"Operating Limits"
		},

		TemperatureAccuracy->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],TemperatureAccuracy]],
			Pattern:>Alternatives[GreaterP[0 Celsius],Percent],
			Description->"How close the values measured by the detector are to the real value.",
			Category->"Operating Limits"
		},

		MinAbsorbanceWavelength->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],MinAbsorbanceWavelength]],
			Pattern:>GreaterP[0 Meter, 1 Meter],
			Description->"The minimum wavelength that the detector can measure.",
			Category->"Operating Limits"
		},

		MaxAbsorbanceWavelength->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxAbsorbanceWavelength]],
			Pattern:>GreaterP[0 Meter, 1 Meter],
			Description->"The maximum wavelength that the detector can measure.",
			Category->"Operating Limits"
		},
		LongTubeCutter->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part, CuttingJig],
			Description->"The type of device available to measure the optical absorbance.",
			Category->"Instrument Specifications",
			Developer->True
		},
		MediumTubeCutter->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part, CuttingJig],
			Description->"The type of device available to measure the optical absorbance.",
			Category->"Instrument Specifications",
			Developer->True
		},
		ShortTubeCutter->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part, CuttingJig],
			Description->"The type of device available to measure the optical absorbance.",
			Category->"Instrument Specifications",
			Developer->True
		},
		TinyTubeCutter->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Part, CuttingJig],
			Description->"The type of device available to measure the optical absorbance.",
			Category->"Instrument Specifications",
			Developer->True
		}
	}
}];
