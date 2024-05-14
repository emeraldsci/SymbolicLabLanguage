

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, FlowCytometer], {
	Description->"A device used for counting cells by individually assessing fluorescence and light scattering properties of the cells as they flow by a detector one by one in a line.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Mode -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Mode]],
			Pattern :> FlowCytometerModeP,
			Description -> "Type of analysis and/or processing the cytometer can perform (Sorting or Counting).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Detectors -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Detectors]],
			Pattern :> {{FlowCytometryDetectorP, GreaterP[0*Nano*Meter], _String, _String ,_String, _String, _String,GreaterP[0*Nano*Meter], GreaterP[0*Nano*Meter],_String}..},
			Description -> "The available fluorescence channels, based on the installed optic module models installed in this modelInstrument.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers -> {"Channel","Excitation Wavelength", "Scatter Angle", "Filter 1", "Filter 2", "Filter 3", "Filter 4", "Min Detected Wavelength", "Max Detected Wavelength", "Fluorophores"}
		},
		MaxEventRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxEventRate]],
			Pattern :> GreaterP[0*PerSecond],
			Description -> "The number of events per second this model of flow cytometer is capable of detecting.",
			Category -> "Operating Limits"
		},
		MinInjectionRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinInjectionRate]],
			Pattern :> GreaterP[(0*(Micro*Liter))/Second],
			Description -> "The minimum rate at which the autosampler can inject sample into the flow path.",
			Category -> "Operating Limits"
		},
		MaxInjectionRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxInjectionRate]],
			Pattern :> GreaterP[(0*(Micro*Liter))/Second],
			Description -> "The maximum rate at which the autosampler can inject sample into the flow path.",
			Category -> "Operating Limits"
		},
		MinIncubationTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinIncubationTemperature]],
			Pattern :> GreaterP[-20*Celsius],
			Description -> "The minimum temperature at which the autosampler can hold a plate while it is being processed.",
			Category -> "Operating Limits"
		},
		MaxIncubationTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxIncubationTemperature]],
			Pattern :> GreaterP[-20*Celsius],
			Description -> "The minimum temperature at which the autosampler can hold a plate while it is being processed.",
			Category -> "Operating Limits"
		},
		MinSampleVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinSampleVolume]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "The minimum volume of sample that the autosampler is capable of injecting.",
			Category -> "Operating Limits"
		},
		MaxSampleVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxSampleVolume]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "The maximum volume of sample that the autosampler is capable of injecting.",
			Category -> "Operating Limits"
		},
		MinWashVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinWashVolume]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "The minimum volume that the autosampler is capable of using to wash between one sample and the next.",
			Category -> "Operating Limits"
		},
		MaxWashVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxWashVolume]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "The maximum volume that the autosampler is capable of using to wash between one sample and the next.",
			Category -> "Operating Limits"
		},
		SheathFluid->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The sample used be the instrument to hydrodynamically focus the beam of cells flowing through the instrument.",
			Category->"Instrument Specifications"
		},
		SecondarySheathFluid->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The additional sample used be the instrument to hydrodynamically focus the beam of cells flowing through the instrument.",
			Category->"Instrument Specifications"
		},
		QualityControlBeads->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The fluorescent beads used to characterize the detectors of the instrument prior to measurement.",
			Category->"Instrument Specifications"
		},
		SheathAdditive->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description->"The surfactant sample used lower the surface tension of the sheath fluid to encourage laminar flow.",
			Category->"Instrument Specifications"
		},
		Cleaner->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Sample]],
			Relation->Object[Sample],
			Description-> "The sample used clean the instrument between experiments.",
			Category->"Instrument Specifications"
		},
		SecondaryWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "An additional container associated with the instrument used to collect any liquid waste produced by the instrument during operation.",
			Category -> "Instrument Specifications"
		}
	}
}];
