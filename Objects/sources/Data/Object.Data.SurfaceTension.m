(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Data, SurfaceTension], {
	Description->"Measurements of the surface tension of a sample at varying concentrations.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Diluent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample that the material being analyzed was diluted in.",
			Category -> "General",
			Abstract -> True
		},
		Concentrations-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> Alternatives[GreaterP[0 Molar], GreaterP[0 Gram/Liter],GreaterP[0 Percent]],
			Description -> "For each member of the dilution curve, the concentrations of the sample that were measured.",
			Category -> "Experimental Results"
		},
		DilutionFactors-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0,1],
			Description -> "For each member of the dilution curve, the dilution factors of the sample that were measured.",
			Category -> "Experimental Results"
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of the dilution curve, the temperatures (as measured inside the instrument) at which the measurements were acquired.",
			Category -> "Experimental Results"
		},
		SurfaceTensions-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[-50 Milli Newton/Meter,500 Milli Newton/Meter],
			Units-> Milli Newton/Meter,
			Description -> "For each member of the dilution curve, the surface tensions measured.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		SurfacePressures-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[-10 Milli Newton/Meter],
			Description -> "For each member of the dilution curve, the decrease in surface tensions measured.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		AssayContainers->{
			Format->Multiple,
			Class -> Link,
			Pattern:>_Link,
			Relation-> Object[Container],
			Description -> "For each member of the dilution curve, the container the sample was in during measurement.",
			Category->"Sample Loading"
		},
		AssayPositions->{
			Format->Multiple,
			Class->String,
			Pattern:>WellPositionP,
			Description->"For each member of the dilution curve, the well position of the sample in the measurement plate.",
			Category->"Sample Loading"
		},
		CriticalMicelleConcentrationAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, CriticalMicelleConcentration][AssayData],
			Description -> "Critical micelle concentration analyses performed on the surface tensions.",
			Category -> "Analysis & Reports"
		},
		CriticalMicelleConcentration->{
			Format->Single,
			Class->Real,
			Pattern :> GreaterP[0*Molar]|GreaterP[0 Gram/Liter]|RangeP[0 Percent,100 Percent],
			Description-> "The concentration of surfactants above which micelles form and all additional surfactants added to the system go to micelles. This is the concentration where increasing the concentration of the sample stops decreasing the surface tension.",
			Category->"Analysis & Reports"
			},
		ApparentPartitioningCoefficient->{
			Format->Single,
			Class->Real,
			Pattern :> GreaterP[0/Molar]|GreaterP[0 Liter/Gram]|GreaterP[0 /Percent],
			Description-> "An apparent partitioning coefficient used to quantify partitioning the air-water interface. This is the inverse of the concentration where increasing the concentration of the sample starts decreasing the surface tension.",
			Category->"Analysis & Reports"
			},
		SurfaceExcessConcentration->{
			Format->Single,
			Class->Real,
			Pattern :> GreaterP[0*Mole/Meter^2],
			Description-> "The amount of surfactant adsorbed at the air water interface per surface area. This is calculated by taking the negative of the slope of the concentration dependent region of a surface tension vs. log of concentration graph divided by the temperature the measurement was taken at and the ideal gas constant.",
			Category->"Analysis & Reports"
			},
		CrossSectionalArea->{
			Format->Single,
			Class->Real,
			Pattern :> GreaterP[0*Meter^2],
			Description-> "The area of the surfactant molecule at the surface. This is calculated by taking the inverse of the SurfaceExcessConcentration and the Avogadro constant.",
			Category->"Analysis & Reports"
			},
		MaxSurfacePressure->{
			Format->Single,
			Class->Real,
			Pattern :> GreaterP[0*Milli Newton/Meter],
			Description-> "The largest surface pressure of the dilutions. This is also the difference between the surface tension of the diluent and the surface tension of the most concentrated dilution.",
			Category->"Analysis & Reports"
			}
			
	}
}];
