(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, DynamicLightScattering], {
    (*Past tense*)
    Description->"Analysis of a dynamic light scattering experiment that calculates properties like average particle sizes, diffusion coefficients, diffusion interaction parameter, second virial coefficient, and Kirkwood Buff integral.",
    CreatePrivileges->None,
    Cache->Session,
    Fields -> {
        Protocols -> {
            Format -> Multiple,
            Class -> Link,
            Pattern :> _Link,
            Relation -> Alternatives[
                Object[Protocol,DynamicLightScattering],
                Object[Protocol,ThermalShift]
            ],
            Description -> "The experimental protocols that generated the data analyzed in this object.",
            Category -> "General"
        },
        DiffusionCoefficients->{
            Format -> Multiple,
            Class -> VariableUnit,
            Pattern :> GreaterEqualP[0 Centimeter^2 / Second],
            Description -> "For each member of AssayConditions, the diffusion coefficients for each member of CorrelationCurves in the data object.",
            Category -> "Analysis & Reports",
			IndexMatching -> AssayConditions
        },
        ZAverageDiameters->{
            Format -> Multiple,
            Class -> VariableUnit,
            Pattern :> GreaterEqualP[0 Nano Meter],
            Description -> "For each member of AssayConditions, the average particle diameters in solution as measured by their intensity distributions.",
            Category -> "Analysis & Reports",
			IndexMatching -> AssayConditions
        },
        PeakSpecificDiameters->{
            Format -> Multiple,
            Class -> Expression,
            Pattern :> {GreaterEqualP[0 Nano Meter]..},
            Description -> "For each member of AssayConditions, the peak specific particle diameters in solution as measured by their intensity distributions.",
            Category -> "Analysis & Reports",
			IndexMatching -> AssayConditions
        },
        PolyDispersityIndices->{
            Format -> Multiple,
            Class -> Real,
            Pattern :> GreaterEqualP[0],
            Description -> "For each member of AssayConditions, the polydispersity index for that sample.",
            Category -> "Analysis & Reports",
			IndexMatching -> AssayConditions
        },
        AverageViscosity->{
            Format -> Single,
            Class -> VariableUnit,
            Pattern :> GreaterEqualP[0 Centipoise],
            Description -> "The average viscosity for the sample.",
            Category -> "Experimental Results"
        },
        RefractiveIndex->{
            Format -> Single,
            Class -> Real,
            Pattern :> _?NumericQ,
            Description -> "The refractive index of the solvent in the sample.",
            Category -> "Experimental Results"
        },
        CalibrationStandardIntensity->{
            Format->Single,
            Class-> Real,
            Pattern:>GreaterEqualP[0],
            Description -> "The amount of light that reaches the scattered light detector in counts per second for the calibration toluene sample.",
            Category->"Experimental Results"
        },
        CalibrationDate->{
            Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date of the last instrument calibration.",
			Category -> "Experimental Results"
		},
        OpticalConstantValue->{
            Format-> Single,
            Class-> VariableUnit,
            Pattern:>GreaterP[0 * Centimeter^2*Mole/Gram^2],
            Description -> "The constant used to estimate the second virial coefficient, which is a function of the wavelength, solvent refractive index, and the derivative of the refractive index with respect to the sample concentration.",
            Category->"Experimental Results"
        },
        SolventRayleighRatios->{
            Format->Multiple,
            Class-> VariableUnit,
            Pattern:>GreaterP[-10^-6 * 1/Centimeter],
            Description -> "For each member of AssayConditions, the solvent Rayleigh ratio which is based on light scattering intensity through the sample solvent relative to toluene.",
            Category->"Experimental Results",
            IndexMatching -> AssayConditions
        },
        DerivedScatteredLightIntensities->{
            Format->Multiple,
            Class-> Real,
            Pattern:>GreaterP[0],
            Description -> "For each member of AssayConditions, the derived amount of light that reaches the scattered light detector in counts per second.",
            Category->"Experimental Results",
            IndexMatching -> AssayConditions
        },
        BufferDerivedLightIntensity->{
            Format->Single,
            Class-> Real,
            Pattern:>GreaterP[0],
            Description -> "The derived amount of light that reaches the scattered light detector in counts per second for the buffer sample.",
            Category->"Experimental Results"
        },
        CorrelationCurves->{
            Format->Multiple,
            Class->QuantityArray,
            Pattern:>QuantityCoordinatesP[{Micro*Second,ArbitraryUnit}],
            Units->{Micro*Second,ArbitraryUnit},
            Description -> "For each member of AssayConditions, a series of data points which describes the correlation between scattered light intensity over time for the sample. This correlation typically decays from 1 to 0 over time.",
            Category->"Experimental Results",
            IndexMatching -> AssayConditions
        },
        AssayConditions -> {
            Format->Multiple,
            Class->Expression,
            Pattern:>Alternatives[
                (* Concentration *)
                GreaterEqualP[0*Milligram/Milliliter],
                (* Time *)
                GreaterEqualP[0*Second],
                (* ThermalShift *)
                Initial,
                Final
            ],
            Description -> "The independent variable used to evaluate correlation curve data. For B22kD and G22 analysis the reference is mass concentration, for IsothermalStability it is time, and for ThermalShift it is the step in the process of the measurement, Initial or Final.",
            Category->"Experimental Results"
        },
        DiffusionInteractionParameterStatistics->{
          Format->Single,
          Class->{
            DiffusionInteractionParameter -> Real,
            Slope -> Real,
            Intercept -> Real,
            RSquared -> Real,
            HydrodynamicDiameter -> Real
          },
          Pattern:>{
            DiffusionInteractionParameter -> UnitsP[(Milliliter/Gram)],
            Slope -> UnitsP[(Meter^2*Milliliter/(Second*Gram))],
            Intercept -> UnitsP[(Meter^2/Second)],
            RSquared -> _?NumericQ,
            HydrodynamicDiameter -> UnitsP[(Nanometer)]
          },
          Units->{
            DiffusionInteractionParameter -> (Milliliter/Gram),
            Slope -> (Meter^2*Milliliter/(Second*Gram)),
            Intercept -> (Meter^2/Second),
            RSquared -> None,
            HydrodynamicDiameter -> Nanometer
          },
          Description -> "The fit for the interaction parameter (kD) associated with the average particle size. The diffusion interaction parameter (kD) is a measure of colloidal stability at lower protein concentrations (<10 mg/mL). A positive kD value indicates weak net-repulsive intermolecular forces between particles, while a negative kD value indicates net-attractive interactions.",
          Category -> "Analysis & Reports"
        },
        DiffusionInteractionParameterFit->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Analysis, Fit]],
			Relation->Object[Analysis, Fit],
			Description-> "The object that stores linear fit of the dominant peak particle diffusion data versus concentration. The ratio of the slope to y-intercept describes the diffusion interaction parameter. The y-intercept is the limit of diffusion in low concentration, and that value is used to estimate the hydrodyanmic diameter using the Stokes-Einstein equation.",
			Category->"Analysis & Reports"
		},
        DominantPeakDiffusionInteractionParameterStatistics->{
          Format->Multiple,
          Class->{
            Real,
            Real,
            Real,
            Real,
            Real
          },
          Pattern:>{
            UnitsP[(Milliliter/Gram)],
            UnitsP[(Meter^2*Milliliter/(Second*Gram))],
            UnitsP[(Meter^2/Second)],
            _?NumericQ,
            UnitsP[(Nanometer)]
          },
          Units->{
            (Milliliter/Gram),
            (Meter^2*Milliliter/(Second*Gram)),
            (Meter^2/Second),
            None,
            Nanometer
          },
          Headers->{
            "Diffusion Interaction Parameter (kD)",
            "kD Slope",
            "kD Intercept",
            "R Squared",
            "Hydrodynamic diameter"
          },
          Description -> "The fit for the interaction parameter (kD) associated with the peak specific diffusion rates.",
          Category -> "Analysis & Reports"
        },
        DominantPeakDiffusionInteractionParameterFit->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Analysis, Fit]],
			Relation->Object[Analysis, Fit],
			Description->"The object that stores the linear fit of the dominant peak particle diffusion data versus concentration. The ratio of the slope to y-intercept describes the diffusion interaction parameter. The y-intercept is the limit of diffusion in low concentration, and that value is used to estimate the hydrodyanmic diameter using the Stokes-Einstein equation.",
			Category->"Analysis & Reports"
		},
        SecondVirialCoefficientStatistics->{
          Format->Single,
          Class->{
            SecondVirialCoefficient->Real,
            Slope ->VariableUnit,
            Intercept ->VariableUnit,
            RSquared ->Real,
            TrueMolecularWeight ->Real
          },
          Pattern:>{
            SecondVirialCoefficient->UnitsP[((Mole*Milliliter)/(Gram*Gram))],
            Slope -> Alternatives[UnitsP[((Mole*Milliliter)/(Gram*Gram))], UnitsP[((Milliliter)/(Mole))]],
            Intercept -> Alternatives[UnitsP[((Mole)/(Gram))],UnitsP[((Gram)/(Mole))]],
            RSquared ->_?NumericQ,
            TrueMolecularWeight ->UnitsP[((Gram)/(Mole))]
          },
          Units->{
            SecondVirialCoefficient->((Mole*Milliliter)/(Gram*Gram)),
            Slope->None,
            Intercept->None,
            RSquared -> None,
            TrueMolecularWeight ->((Gram)/(Mole))
          },
          Description -> "The fit for the second virial coefficient. The second virial coefficient (B22) is a measure of colloidal stability at lower protein concentrations (<10 mg/mL). A positive B22 value indicates weak net-repulsive intermolecular forces between particles, while a negative B22 value inidicates net-attractive interactions.",
          Category-> "Analysis & Reports"
        },
        SecondVirialCoefficientFit->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Analysis, Fit]],
			Relation->Object[Analysis, Fit],
			Description-> "The object that stores the linear fit of the product of the optical constant, concentration, and inverse Rayleigh ratio versus concentration. The second virial coefficient is estimated as half of the slope. The apparent molecular weight is the inverse of the y-intercept.",
			Category->"Analysis & Reports"
		},
        EstimatedMolecularWeight->{
          Format->Single,
          Class->Real,
          Pattern:>UnitsP[((Gram)/(Mole))],
          Units->((Gram)/(Mole)),
          Description->"The estimated molecular weight of particles in the sample. The molecular weight is calculated as the y-intercept in the linear regression ApparentMolecularWeight versus concentration.",
          Category->"Analysis & Reports"
        },
        KirkwoodBuffIntegralStatistics->{
          Format->Single,
          Class->{
            KirkwoodBuffIntegral->Real,
            Slope ->Real,
            Intercept ->Real,
            RSquared ->Real,
            TrueMolecularWeight ->Real
          },
          Pattern:>{
            KirkwoodBuffIntegral->UnitsP[((Milliliter)/(Gram))],
            Slope ->UnitsP[((Gram)/(Mole))],
            Intercept ->UnitsP[((Milliliter)/(Mole))],
            RSquared ->_?NumericQ,
            TrueMolecularWeight ->UnitsP[((Gram)/(Mole))]
          },
          Units->{
            KirkwoodBuffIntegral->((Milliliter)/(Gram)),
            Slope ->((Gram)/(Mole)),
            Intercept ->((Milliliter)/(Mole)),
            RSquared ->None,
            TrueMolecularWeight ->((Gram)/(Mole))
          },
          Description -> "The fit for the Kirkwood Buff integral. The Kirkwood Buff integral (G22) is a measure of colloidal stability at higher protein concentrations. A negative G22 value indicates weak net-repulsive intermolecular forces between particles, while a positive G22 value indicates net-attractive interactions.",
          Category-> "Analysis & Reports"
        },
        KirkwoodBuffIntegralFit->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[Object[Analysis, Fit]],
			Relation->Object[Analysis, Fit],
			Description-> "The object that stores the fit of the Rayleigh ratio divided by the optical constant versus a first and second order protein concentration term. The Kirkwood Buff integral second order term divided by the protein's molecular weight. The apparent molecular weight is the coefficient for the first order term.",
			Category->"Analysis & Reports"
		},
        SizeDistributions->{
            Format -> Multiple,
            Class -> QuantityArray,
            Pattern :> QuantityCoordinatesP[{Nanometer, ArbitraryUnit}],
            Units -> {Nanometer, ArbitraryUnit},
            Description -> "For each member of AssayConditions, the distribution of particle sizes fit to the correlation curves.",
            IndexMatching -> AssayConditions,
            Category -> "Analysis & Reports"
        }
    }
}];
