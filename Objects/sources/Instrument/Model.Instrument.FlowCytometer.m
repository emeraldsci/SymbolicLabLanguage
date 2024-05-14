(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, FlowCytometer], {
	Description->"The model for a device for counting and/or sorting cells by individually assessing fluorescence and light scattering properties of the cells as they flow by a detector one by one in a line.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Mode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FlowCytometerModeP,
			Description -> "Type of analysis and/or processing the cytometer can perform (Sorting or Counting).",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		ExcitationLaserWavelengths->{
			Format->Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Nanometer],
			Units -> Nanometer,
			Description->"Light-emitting diode sources available to the instrument. The first quantity is the Center Wavelength, which is the midpoint between the wavelengths where transmittance is 50% (known as Full Width at Half Maximum (FWHM)). The second quantity is the bandwidth or the FWHM of the light source.",
			Category->"Instrument Specifications"
		},
		ExcitationLaserPowers->{
			Format->Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Watt],
			Units -> Milli*Watt,
			Description->"For each member of ExcitationLaserWavelengths, the power output of the laser.",
			IndexMatching->ExcitationLaserWavelengths,
			Category->"Instrument Specifications"
		},
		Detectors -> {
			Format -> Multiple,
			Class -> {Expression, Real, String, String, String, String, String, Real, Real, String},
			Pattern :> {FlowCytometryDetectorP, GreaterP[0*Nano*Meter], _String, _String ,_String, _String, _String,GreaterP[0*Nano*Meter], GreaterP[0*Nano*Meter],_String},
			Units -> {None, Meter Nano, None, None, None, None, None, Meter Nano, Meter Nano,None},
			Description -> "The fluorescence channels available, based on the installed optic module models installed in this modelInstrument in the form: {channel name, excitation wavelength, scatter angles, filters, emission wavelength, emission bandwidth, Fluorophores}.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers -> {"Channel","Excitation Wavelength", "Scatter Angle", "Filter 1", "Filter 2", "Filter 3", "Filter 4", "Min Detected Wavelength", "Max Detected Wavelength", "Fluorophores"}
		},
		MaxEventRate -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0*PerSecond],
			Units -> PerSecond,
			Description -> "The number of events per second this model of flow cytometer is capable of detecting.",
			Category -> "Operating Limits"
		},
		MinInjectionRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Micro*Liter))/Second],
			Units -> (Liter Micro)/Second,
			Description -> "The minimum rate at which the autosampler can inject sample into the flow path.",
			Category -> "Operating Limits"
		},
		MaxInjectionRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*(Micro*Liter))/Second],
			Units -> (Liter Micro)/Second,
			Description -> "The maximum rate at which the autosampler can inject sample into the flow path.",
			Category -> "Operating Limits"
		},
		MinIncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the autosampler can hold a plate while it is being processed.",
			Category -> "Operating Limits"
		},
		MaxIncubationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the autosampler can hold a plate while it is being processed.",
			Category -> "Operating Limits"
		},
		MinSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The minimum volume of sample that the autosampler is capable of injecting.",
			Category -> "Operating Limits"
		},
		MaxSampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The maximum volume of sample that the autosampler is capable of injecting.",
			Category -> "Operating Limits"
		},
		MinWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The minimum volume that the autosampler is capable of using to wash between one sample and the next.",
			Category -> "Operating Limits"
		},
		MaxWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The maximum volume that the autosampler is capable of using to wash between one sample and the next.",
			Category -> "Operating Limits"
		},
		ChannelDimensions ->{
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Micro*Meter], GreaterP[0*Micro*Meter]},
			Units -> {Meter Micro, Meter Micro},
			Description -> "The internal dimensions of the flow channel the sample flows through.",
			Category -> "Instrument Specifications",
			Abstract -> True,
			Headers -> {"Width","Height"}
		},
		ScatterSensitivity->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micrometer],
			Units -> Meter Micro,
			Description -> "The smallest particle a the instrument can resolve with a forward scatter detector.",
			Category -> "Operating Limits"
		},
		SheathFluid->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Model[Sample]],
			Relation->Model[Sample],
			Description->"The sample used be the instrument to hydrodynamically focus the beam of cells flowing through the instrument.",
			Category->"Instrument Specifications"
		},
		QualityControlBeads->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Model[Sample]],
			Relation->Model[Sample],
			Description->"The fluorescent beads used to characterize the detectors of the instrument prior to measurement.",
			Category->"Instrument Specifications"
		},
		SheathAdditive->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Model[Sample]],
			Relation->Model[Sample],
			Description->"The surfactant sample used lower the surface tension of the sheath fluid to encourage laminar flow.",
			Category->"Instrument Specifications"
		},
		Cleaner->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Model[Sample]],
			Relation->Model[Sample],
			Description-> "The sample used clean the instrument between experiments.",
			Category->"Instrument Specifications"
		}
	}
}];
