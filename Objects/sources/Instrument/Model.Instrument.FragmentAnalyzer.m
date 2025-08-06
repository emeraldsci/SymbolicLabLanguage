(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* Model[Instrument,FragmentAnalyzer] *)


DefineObjectType[Model[Instrument, FragmentAnalyzer], {
	Description->"Model information for the array-based capillary electrophoresis instrument used for parallel qualitative or quantitative analysis of nucleic acids via separation based on analyte fragment size. A strong electric field (electrophoresis) is applied across an extremely thin, hollow tube (a capillary) containing a porous medium (gel solution) and facilitates the size-dependent migration of analytes in the sample. Depending on the attached CapillaryArray part, the analysis of either 12-, 48- or 96- samples in a single, parallel run can be performed and allows for high- to ultra-high throughput workflows.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		
		
		SupportedNumberOfCapillaries-> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> FragmentAnalyzerNumberOfCapillariesP,
			Description -> "The number of capillaries per capillary array that the instrument can support. Determines the maximum number of samples ran in parallel in a single injection, including a ladder sample which is recommended for every run.",
			Category -> "Instrument Specifications",
			Abstract-> True
		},
		SupportedCapillaryArrayLength-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FragmentAnalyzerCapillaryArrayLengthP,
			Description -> "The length (Short or Long) of the extremely thin hollow tubes (capillary arrays) that are used by the instrument for analyte separation. For a Short capillary array, the length from the sample inlet end until the detector window (EffectiveLength) is 33 Centimeter, while the length from the sample inlet end until the outlet end (TotalLength) is 55 Centimeter. For a Long capillary array, the length from the sample inlet end up to the detector window (EffectiveLength) is 55 Centimeter, while the length from the sample inlet end up to the outlet end (TotalLength) is 80 Centimeter.",
			(*When Model[Instrument, FragmentAnalyzer, "FragmentAnalyzer 5200"] is made available, add: For an Ultra-Short capillary array, the length from the sample inlet end until the detector window (EffectiveLength) is 22 Centimeter, while the length from the sample inlet end until the outlet end (TotalLength) is 47 Centimeter.*)
			Category -> "Instrument Specifications",
			Abstract-> True
		},
		SupportedCapillaryArray-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Model[Part,CapillaryArray]],
			Relation -> Model[Part, CapillaryArray][CompatibleInstrument],
			Description -> "The model(s) of the ordered bundle of extremely thin, hollow tubes (capillary array) that can be used by the instrument for analyte separation.",
			Category -> "Instrument Specifications"
		},
		ExcitationSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LampTypeP,
			Description -> "The light source available to excite and probe the dye-bound analytes as they pass across the capillary array detection window.",
			Category -> "Instrument Specifications"
		},
		MaxExcitationWavelength -> {
		    Format -> Single,
		    Class -> Real,
		    Pattern :> GreaterP[0*Nanometer],
		    Units -> Nanometer,
		    Description -> "The maximum wavelength the instrument uses to excite the dye-bound analytes.",
			Category -> "Instrument Specifications"
		},
		MinEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nanometer],
			Units -> Nanometer,
			Description -> "The minimum wavelength at which the charge-coupled device (CCD) detector takes fluorescence emission readings.",
			Category -> "Instrument Specifications"
		},
		MaxEmissionWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nanometer],
			Units -> Nanometer,
			Description -> "The maximum wavelength at which the charge-coupled device (CCD) detector takes fluorescence emission readings.",
			Category -> "Instrument Specifications"
		},	
		MinVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Units -> Kilovolt,
			Description -> "The minimum electric potential that the instrument can generate and run across the capillaries in the course of the experiment.",
			Category -> "Operating Limits"
		},
		MaxVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kilovolt],
			Units -> Kilovolt,
			Description -> "The minimum electric potential that the instrument can generate and run across the capillaries in the course of the experiment.",
			Category -> "Operating Limits"
		},
		MinDestinationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> LessEqualP[0.1*PSI],
			Units -> PSI,
			Description -> "The maximum negative pressure that can be applied at capillaries' destination by the high pressure syringe pump in the instrument. An applied negative pressure at the capillaries' destination causes a fluid movement forward from the Plates (Sample, RunningBuffer, RinseBuffer, Marker, Waste), through the capillary towards the end of the capillary connected to the syringe pump.",
			Category -> "Operating Limits"
		},
		MaxDestinationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*PSI],
			Units -> PSI,
			Description -> "The maximum positive pressure that can be applied at the capillaries' destination by the high pressure syringe pump in the instrument. An applied positive pressure at the capillaries' destination causes a fluid movement backwards from the syringe pump through the capillary, and into the Plates (Sample, RunningBuffer, RinseBuffer, Marker, Waste).",
			Category -> "Operating Limits"
		},
		MinHumidity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The minimum relative humidity at which the instrument can perform operations.",
			Category->"Operating Limits"
		},
		MaxHumidity->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*Percent],
			Units->Percent,
			Description->"The maximum relative humidity at which the instrument can perform operations.",
			Category->"Operating Limits"
		},
		DefaultInstrumentDataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The default file path on the instrument computer in which the data generated by the experiment is stored locally.",
			Category -> "Data Processing",
			Developer -> True
		},
		DefaultInstrumentBackupDataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The default file path on the instrument computer in which a back up copy of the data generated by the experiment is stored locally.",
			Category -> "Data Processing",
			Developer -> True
		},
		DefaultInstrumentMethodFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The default file path on the instrument computer that contains the method files used by the software for flush and separation runs.",
			Category -> "Data Processing",
			Developer -> True
		}
  }
}];
