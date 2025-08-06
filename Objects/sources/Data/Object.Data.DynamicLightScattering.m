

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, DynamicLightScattering], {
  Description->"Data from a dynamic light scattering experiment.",
  CreatePrivileges->None,
  Cache->Session,
  Fields -> {

    AssayType->{
      Format->Single,
      Class->Expression,
      Pattern:>DynamicLightScatteringAssayTypeP,
      Description->"The Dynamic Light Scattering (DLS) assay that is run. SizingPolydispersity makes a single DLS measurement that provides information about the size and polydispersity (defined as the ratio of mass-average molar mass to number-average molar mass) of particles in the input samples. ColloidalStability makes DLS measurements at various dilutions of a sample below 25 mg/mL to calculate the diffusion interaction parameter (kD) and the second virial coefficient (B22 or A2), and does the same for a sample of mass concentration 20-100 mg/mL to calculate the Kirkwood-Buff Integral (G22) at each dilution concentration; Static Light Scattering (SLS) measurements can be used to calculate A2 and the molecular weight of the analyte. MeltingCurve makes DLS measurements over a range of temperatures in order to calculate melting temperature (Tm), temperature of aggregation (Tagg), and temperature of onset of unfolding (Tonset). IsothermalStability makes multiple DLS measurements at a single temperature over time in order to probe stability of the analyte at a particular temperature.",
      Category->"General"
    },
    NumberOfReplicates->{
      Format->Single,
      Class->Integer,
      Pattern:>GreaterP[0, 1],
      Units->None,
      Description->"The number of times the specified Dynamic Light Scattering (DLS) assay is run for each input sample. Specifically, this refers to the number of wells that each input sample or individual dilution concentration occupies.",
      Category->"General"
    },
    Temperature->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Kelvin],
      Units->Celsius,
      Description->"The temperature to which the incubation chamber is set prior to detection.",
      Category->"Sample Loading"
    },
    EquilibrationTime->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Minute],
      Units->Minute,
      Description->"The length of time for which the samples are held in the chamber which is incubated at the Temperature before the first Dynamic Light Scattering (DLS) measurement is made, in order to warm or cool the samples to Temperature.",
      Category->"Sample Loading"
    },
    AssayContainer->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Object[Container,Plate]],
      Description->"The capillary strips or plates that the samples are assayed in.",
      Category->"Sample Loading"
    },
    AssayPosition->{
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"For each member of AssayContainers, the well positions of the sample dilutions.",
      Category->"Sample Loading"
    },
    AssayContainers->{
      Format->Multiple,
      Class -> Link,
      Pattern:>_Link,
      Relation-> Alternatives[Object[Container,Plate]],
      Description -> "The plate or capillary strips that each sample dilution is assayed in.",
      Category->"Sample Loading"
    },
    AssayPositions->{
      Format->Multiple,
      Class->String,
      Pattern:>_String,
      Description->"For each member of AssayContainers, the well positions of the sample dilutions.",
      Category->"Sample Loading",
      IndexMatching -> AssayContainers
    },
    AssayPlateSample->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Sample],
      Description->"The sample in the well plate analyzed in the specified Dynamic Light Scattering (DLS) assay.",
      Category->"Sample Loading"
    },
    NumberOfAcquisitions->{
      Format->Single,
      Class->Integer,
      Pattern:>GreaterP[0, 1],
      Units->None,
      Description->"For each Dynamic Light Scattering (DLS) measurement, the number of series of speckle patterns that are collected for each sample over the AcquisitionTime to create the measurement's autocorrelation curve.",
      Category->"Light Scattering"
    },
    AcquisitionTime->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Second],
      Units->Second,
      Description->"For each Dynamic Light Scattering (DLS) measurement, the length of time that each acquisition generates speckle patterns to create the measurement's autocorrelation curve.",
      Category->"Light Scattering"
    },
    AutomaticLaserSettings->{
      Format->Single,
      Class->Expression,
      Pattern:>BooleanP,
      Description->"Indicates if the LaserPower and DiodeAttenuation are automatically set at the beginning of the assay by the Instrument to levels ideal for the samples, such that the count rate falls within an optimal, predetermined range.",
      Category->"Light Scattering"
    },
    LaserPower->{
      Format->Single,
      Class->Real,
      Pattern:>RangeP[0*Percent,100*Percent],
      Units->Percent,
      Description->"The percent of the maximum laser power that is used to make Dynamic Light Scattering (DLS) measurements.",
      Category->"Light Scattering"
    },
    DiodeAttenuation->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0*Percent],
      Units->Percent,
      Description->"The percent of scattered signal that is allowed to reach the avalanche photodiode mediated by diode attenuators (in Capillary-type assays) or the percent of scattered signal that is prevented from reaching the avalanche photodiode mediated by diode attenuators (in Plate-type assays).",
      Category->"Light Scattering"
    },
    CalibrationStandardIntensity->{
      Format->Single,
      Class->Real,
      Pattern:>(GreaterEqualP[0/Second]),
      Units->1/Second,
      Description->"The most recent scattered light intensity of a standard sample in counts per second.",
      Category->"Light Scattering"
    },
    Viscosity ->{
      Format->Single,
      Class -> Real,
      Pattern :> GreaterP[0*(Milli*Pascal)*Second],
      Units -> Milli*Pascal*Second,
      Description -> "The viscosity of the sample at 25 C.",
      Category-> "Light Scattering"
    },
    SolventRefractiveIndex -> {
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0],
      Units->None,
      Description->"The refractive index of the solvent at 25 C.",
      Category->"Light Scattering"
    },
    AnalyteStoredMolecularWeight->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Dalton],
      Units->Dalton,
      Description->"The molecular weight stored in the model of the Analyte when the AssayType is ColloidalStability.",
      Category->"Sample Dilution"
    },
    AssayProtein->{
      Format -> Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Molecule],
      Description->"The Model(Molecule,Protein) member of the Composition field whose dilution concentrations are tracked in the DilutionConcentration, which are used to calculate the B22 and kD, or G22 values. Note: this field has been deprecated and replaced by Analyte.",
      Category->"Sample Dilution"
    },
    Analyte->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Molecule],
      Description->"The molecule member of the Composition field whose concentration is used to calculate B22/A2 and kD or G22 when the AssayType is ColloidalStability.",
      Category->"Sample Dilution"
    },
    AnalyteMassConcentrations->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0*Milligram/Milliliter],
      Units->(Milligram/Milliliter),
      Description->"The initial mass concentration of the Analyte before any dilutions outlined by the DilutionCurve or SerialDilutionCurve are performed when the AssayType is ColloidalStability.",
      Category->"Sample Dilution"
    },
    DilutionFactors->{
      Format->Single,
      Class->Expression,
      Pattern:>{Alternatives[_Integer,_Real,_Rational]..}|{Null..}|Null,
      Description->"The ratios of the volume of input sample to the sum of the input sample volume and diluent volume for each dilution.",
      Category->"Sample Dilution"
    },
    DilutionConcentrations->{
      Format->Single,
      Class->Expression,
      Pattern:>{GreaterEqualP[0*(Milligram/Milliliter)]..}|{Null..}|Null,
      Description->"The analyte mass concentrations of each dilution.",
      Category->"Sample Dilution"
    },
    DilutionConcentration->{
      Format->Single,
      Class->Expression,
      Pattern:>GreaterEqualP[0*(Milligram/Milliliter)],
      Description->"The analyte mass concentrations of the dilution in the specified Dynamic Light Scattering (DLS) assay.",
      Category->"Sample Dilution"
    },
    Buffer->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Sample]|Model[Sample],
      Description->"The sample that is used to dilute the sample to a concentration series.",
      Category->"Sample Dilution"
    },
    DilutionMixType->{
      Format->Single,
      Class->Expression,
      Pattern:>MixTypeP,
      Description->"The method used to mix the SampleLoadingPlate or AssayContainer used for dilution.",
      Category->"Sample Dilution"
    },
    DilutionNumberOfMixes->{
      Format->Single,
      Class->Integer,
      Pattern:>RangeP[0,20,1],
      Description->"The number of pipette out and in cycles that is used to mix the sample with the Buffer to make the DilutionCurve.",
      Category->"Sample Dilution"
    },
    DilutionMixRate->{
      Format->Single,
      Class->Real,
      Pattern:>RangeP[0.4 Microliter/Second,250 Microliter/Second],
      Units->Microliter/Second,
      Description->"The speed at which the dilution sample is pipetted out of and into the dilution to mix the sample with the Diluent to make the DilutionCurve.",
      Category->"Sample Dilution"
    },
    BlankBuffer->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Sample]|Model[Sample],
      Description->"The sample that is used as a 0 mg/mL blank in ColloidalStability assays, to determine the diffusion coefficient at infinite dilution.",
      Category->"Sample Dilution"
    },
    (* Isothermal Stability Fields *)
    MeasurementDelayTime->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Hour],
      Units->Hour,
      Description->"The length of time between the consecutive Dynamic Light Scattering (DLS) measurements for a specific AssayContainer well during an IsothermalStability assay. The duration of the experiment is indicated either by this field or by the total IsothermalRunTime.",
      Category->"Isothermal Stability"
    },
    IsothermalMeasurements->{
      Format->Single,
      Class->Integer,
      Pattern:>GreaterP[0,1],
      Units->None,
      Description->"The number of separate DLS measurements that are made during the IsothermalStability assay, either separated by MeasurementDelayTime or distributed over IsothermalRunTime.",
      Category->"Isothermal Stability"
    },
    IsothermalRunTime->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Hour],
      Units->Hour,
      Description->"The total length of the IsothermalStability assay during which the IsothermalMeasurements number of Dynamic Light Scattering (DLS) measurements are made. The duration of the experiment is indicated either by this field or by the MeasurementDelayTime.",
      Category->"Isothermal Stability"
    },
    IsothermalAttenuatorAdjustment->{
      Format->Single,
      Class->Expression,
      Pattern:>Alternatives[First,Every],
      Description->"Indicates if the attenuator level is automatically set for each DLS measurement throughout the IsothermalStability assay. If First, the attenuator level is automatically set for the first DLS measurement and the same level is used throughout the assay.",
      Category->"Isothermal Stability"
    },

    (* - Experimental Results - *)
    (* SizingPolydispersity Data *)
    DataQuality->{
      Format -> Single,
      Class -> String,
      Pattern :> _String,
      Description -> "Describes the quality of dynamic light scattering data for the given measurement, based on the characteristics of the correlation function and intensity.",
      Category -> "Experimental Results"
    },
    ZAverageDiameter->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0*Nanometer],
      Units->Nanometer,
      Description->"The average hydrodynamic diameter of particles in solution.",
      Category->"Experimental Results"
    },
    ZAverageDiffusionCoefficient->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0*(Meter*Meter/Second)],
      Units->(Meter*Meter/Second),
      Description->"Diffusion coefficient calculated from the CorrelationCurve which is inversely proportional to particle size.",
      Category->"Experimental Results"
    },
    DiameterStandardDeviation->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0*Nanometer],
      Units->Nanometer,
      Description->"The standard deviation of the ZAverageDiameter.",
      Category->"Experimental Results"
    },
    PolydispersityIndex->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0],
      Units->None,
      Description->"A measure of the heterogeneity of the calculated hydrodynamic diameters of particles in solution.",
      Category->"Experimental Results"
    },
    ScatteredLightIntensity->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0],
      Units->None,
      Description->"The amount of light that reaches the scattered light detector in counts per second.",
      Category->"Experimental Results"
    },
    NormalizedScatteredLightIntensity->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0],
      Units->None,
      Description->"The amount of light that reaches the scattered light detector in counts per second, normalized for variations in laser power and attenuation.",
      Category->"Experimental Results"
    },
    CorrelationCurve->{
      Format->Single,
      Class->QuantityArray,
      Pattern:>QuantityCoordinatesP[{Micro*Second,ArbitraryUnit}],
      Units->{Micro*Second, ArbitraryUnit},
      Description->"A series of data points which describes the correlation between scattered light intensity over time for the sample. This correlation typically decays from 1 to 0 over time.",
      Category->"Experimental Results"
    },
    CorrelationCurveFitVariance->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0],
      Units->None,
      Description->"A measure of the fit of multiple exponential decay function to the measured CorrelationCurve.",
      Category->"Experimental Results"
    },
    IntensityDistribution->{
      Format->Single,
      Class->QuantityArray,
      Pattern:>QuantityCoordinatesP[{Nanometer,ArbitraryUnit}],
      Units->{Nanometer, ArbitraryUnit},
      Description->"Trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution. Since larger particles scatter more light, larger particles have a higher scattered light intensity per particle in the IntensityDistribution.",
      Category->"Experimental Results"
    },
    MassDistribution->{
      Format->Single,
      Class->QuantityArray,
      Pattern:>QuantityCoordinatesP[{Nanometer,ArbitraryUnit}],
      Units->{Nanometer, ArbitraryUnit},
      Description->"Trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution. In the MassDistribution, as opposed to the IntensityDistribution, the scattered light intensity at each hydrodynamic diameter is corrected for particle size, so this trace gives a more accurate representation of the number of particles of each size in solution.",
      Category->"Experimental Results"
    },
    NumberDistribution->{
      Format->Single,
      Class->QuantityArray,
      Pattern:>QuantityCoordinatesP[{Nanometer,ArbitraryUnit}],
      Units->{Nanometer, ArbitraryUnit},
      Description->"Trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution. In the NumberDistribution, as opposed to the IntensityDistribution and MassDistribution, the scattered light intensity at each hydrodynamic diameter is corrected for particle size and mass, so this trace gives a more accurate representation of the number of particles of each size in solution.",
      Category->"Experimental Results"
    },
    (* IsothermalStability fields *)
    DataQualities->{
      Format -> Multiple,
      Class -> {VariableUnit, String},
      Pattern :> {
        Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]],
        _String
      },
      Headers -> {"Time or Mass Concentration", "Data Quality"},
      Description -> "For each time point or MassConcentration, describes the quality of dynamic light scattering data for the given measurement, based on the characteristics of the correlation function and intensity.",
      Category -> "Experimental Results"
    },
    ZAverageDiameters->{
      Format->Multiple,
      Class->{VariableUnit,Real},
      Pattern:>{
        Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]],
        UnitsP[Nanometer]
      },
      Units->{None,Nanometer},
      Headers->{"Time or Mass Concentration", "Z-Average Diameter"},
      Description->"For each time point or MassConcentration, the average hydrodynamic diameter of particles in solution.",
      Category->"Experimental Results"
    },
    ZAverageDiffusionCoefficients->{
      Format->Multiple,
      Class->{VariableUnit,Real},
      Pattern:> {
        Alternatives[GreaterEqualP[0 * Second], GreaterEqualP[0 * Milligram / Milliliter]],
        GreaterEqualP[0 * (Meter * Meter / Second)]
      },
      Units->{None,(Meter*Meter/Second)},
      Headers->{"Time or Mass Concentration", "Z-Average Diffusion Coefficient"},
      Description->"For each time point or MassConcentration, the diffusion coefficient calculated from the CorrelationCurve which is inversely proportional to particle size.",
      Category->"Experimental Results"
    },
    PolydispersityIndices->{
      Format->Multiple,
      Class->{VariableUnit, Real},
      Pattern:>{
        Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]],
        _Real
      },
      Units->{None,None},
      Headers->{"Time or Mass Concentration", "Polydispersity Index"},
      Description->"For each time point or MassConcentration, a measure of the heterogeneity of the calculated hydrodynamic diameters of particles in solution, defined as the ratio of mass-average molar mass to number-average molar mass.",
      Category->"Experimental Results"
    },
    ScatteredLightIntensities->{
      Format->Multiple,
      Class->{VariableUnit,Real},
      Pattern:>{
        Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]],
        GreaterEqualP[0*ArbitraryUnit]
      },
      Units->{None,ArbitraryUnit},
      Headers->{"Time or Mass Concentration", "Scattered Light Intensity"},
      Description->"For each time point or MassConcentration, the amount of light that reaches the scattered light detector in counts per second, .",
      Category->"Experimental Results"
    },
    NormalizedScatteredLightIntensities->{
      Format->Multiple,
      Class->{VariableUnit,Real},
      Pattern:>{
        Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]],
        GreaterEqualP[0*ArbitraryUnit]
      },
      Units->{None,ArbitraryUnit},
      Headers->{"Time or Mass Concentration", "Scattered Light Intensity"},
      Description->"For each time point or MassConcentration, the amount of light that reaches the scattered light detector in counts per second, normalized for variations in laser power and attenuation.",
      Category->"Experimental Results"
    },
    IntensityDistributions->{
      Format->Multiple,
      Class->{VariableUnit, QuantityArray},
      Pattern:>{Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]], QuantityCoordinatesP[{Nanometer,ArbitraryUnit}]},
      Units->{None, {Nanometer, ArbitraryUnit}},
      Headers->{"Time or Mass Concentration", "Intensity Distribution"},
      Description->"For each time point or MassConcentration, trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution. Since larger particles scatter more light, larger particles have a higher scattered light intensity per particle in the IntensityDistribution.",
      Category->"Experimental Results"
    },
    MassDistributions->{
      Format->Multiple,
      Class->{VariableUnit, QuantityArray},
      Pattern:>{Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]], QuantityCoordinatesP[{Nanometer,ArbitraryUnit}]},
      Units->{None, {Nanometer, ArbitraryUnit}},
      Headers->{"Time or Mass Concentration", "Mass Distribution"},
      Description->"For each time point or MassConcentration, trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution. In the MassDistribution, as opposed to the IntensityDistribution, the scattered light intensity at each hydrodynamic diameter is corrected for particle size, so this trace gives a more accurate representation of the number of particles of each size in solution.",
      Category->"Experimental Results"
    },
    NumberDistributions->{
      Format->Multiple,
      Class->{VariableUnit, QuantityArray},
      Pattern:>{Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]], QuantityCoordinatesP[{Nanometer,ArbitraryUnit}]},
      Units->{None, {Nanometer, ArbitraryUnit}},
      Headers->{"Time or Mass Concentration", "Number Distribution"},
      Description->"For each time point or MassConcentration, trace of the calculated scattered light intensities versus hydrodynamic diameters of particles in solution. In the NumberDistribution, as opposed to the IntensityDistribution and MassDistribution, the scattered light intensity at each hydrodynamic diameter is corrected for particle size and mass, so this trace gives a more accurate representation of the number of particles of each size in solution.",
      Category->"Experimental Results"
    },
    EstimatedMolecularWeights->{
      Format->Multiple,
      Class->{VariableUnit,Real},
      Pattern:>{
        Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]],
        GreaterEqualP[0*Dalton]
      },
      Units->{None,Dalton},
      Headers->{"Time or Mass Concentration", "Estimated Molecular Weight"},
      Description->"For each time point or MassConcentration, the weight-averaged molar mass estimated based on particle conformation, size, and density.",
      Category->"Experimental Results"
    },
    CorrelationCurves->{
      Format->Multiple,
      Class->{VariableUnit, QuantityArray},
      Pattern:>{
        Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]],
        QuantityCoordinatesP[{Micro*Second,ArbitraryUnit}]
      },
      Units->{None,{Micro*Second,ArbitraryUnit}},
      Headers->{"Time or Mass Concentration","Correlation Curve"},
      Description->"For each time point or MassConcentration, a series of data points which describes the correlation between scattered light intensity over time for the sample. This correlation typically decays from 1 to 0 over time.",
      Category->"Experimental Results"
    },
    CorrelationCurveFitVariances->{
      Format->Multiple,
      Class->{VariableUnit,Real},
      Pattern:>{
        Alternatives[GreaterEqualP[0*Second],GreaterEqualP[0*Milligram/Milliliter]],
        _Real
      },
      Units->{None,None},
      Headers->{"Time or Mass Concentration","Correlation Curve Fit Variance"},
      Description->"For each time point or MassConcentration, a measure of the fit of multiple exponential decay function to the measured CorrelationCurve.",
      Category->"Experimental Results"
    },
    KirkwoodBuffIntegral->{
      Format->Multiple,
      Class->{Real,Real},
      Pattern:>{GreaterEqualP[0(Milligram/Milliliter)],UnitsP[(Milliliter/Gram)]},
      Units->{(Milligram/Milliliter),(Milliliter/Gram)},
      Headers->{"Mass Concentration","Kirkwood-Buff Integral"},
      Description->"Also known as G22 - a measure of the colloidal stability of a solution at higher concentrations. Positive G22 values indicate weak net-attractive intermolecular forces between particles, while negative G22 values inidicate net-repulsive interactions.",
      Category->"Experimental Results"
    },
    R90OverK->{
      Format->Multiple,
      Class->{Real,Real},
      Pattern:>{GreaterEqualP[0*(Milligram/Milliliter)],UnitsP[((Gram*Gram)/(Mole*Milliliter))]},
      Units->{(Milligram/Milliliter),((Gram*Gram)/(Mole*Milliliter))},
      Headers->{"Mass Concentration","R90/K"},
      Description->"R90 over K is the ratio between the Rayleigh Ratio (R90) and an optical constant (K) - this value is proportional to the Kirkwood-Buff Integral (G22).",
      Category->"Experimental Results"
    },
    DiffusionInteractionParameterStatistics->{
      Format->Single,
      Class->{
        Real,
        Real,
        Real,
        Real,
        Real,
        Real
      },
      Pattern:>{
        UnitsP[(Milliliter/Gram)],
        _Real,
        _Real,
        UnitsP[Nanometer],
        GreaterEqualP[0],
        GreaterEqualP[0]
      },
      Units->{
        (Milliliter/Gram),
        None,
        None,
        Nanometer,
        None,
        None
      },
      Headers->{
        "Diffusion Interaction Parameter (kD)",
        "kD Slope",
        "kD Intercept",
        "Calculated Hydrodynamic Diameter",
        "R-Squared",
        "kD Fit Quality"
      },
      Description->"The diffusion interaction parameter (kD) is a measure of colloidal stability at lower protein concentrations (<10 mg/mL). A positive kD value indicates weak net-repulsive intermolecular forces between particles, while a negative kD value indicates net-attractive interactions.",
      Category->"Experimental Results"
    },
    DiffusionInteractionParameterData->{
      Format->Single,
      Class->QuantityArray,
      Pattern:>QuantityCoordinatesP[{Milligram/Milliliter,(Meter*Meter)/Second}],
      Units->{Milligram/Milliliter, (Meter*Meter)/Second},
      Description->"Data from which the diffusion interaction parameter is calculated.",
      Category->"Experimental Results"
    },
    SecondVirialCoefficientStatistics->{
      Format->Single,
      Class->{
        Real,
        Real,
        Real,
        Real,
        Real,
        Real
      },
      Pattern:>{
        UnitsP[((Mole*Milliliter)/(Gram*Gram))],
        _Real,
        _Real,
        UnitsP[(Kilo*Dalton)],
        GreaterEqualP[0],
        GreaterEqualP[0]
      },
      Units->{
        ((Mole*Milliliter)/(Gram*Gram)),
        None,
        None,
        (Kilo*Dalton),
        None,
        None
      },
      Headers->{
        "Second Virial Coefficient (B22)",
        "B22 Slope",
        "B22 Intercept",
        "Calculated Molecular Weight",
        "R-Squared",
        "B22 Fit Quality"
      },
      Description->"The second virial coefficient (B22) is a measure of colloidal stability at lower protein concentrations (<10 mg/mL). A positive B22 value indicates weak net-repulsive intermolecular forces between particles, while a negative B22 value inidicates net-attractive interactions.",
      Category->"Experimental Results"
    },
    SecondVirialCoefficientData->{
      Format->Single,
      Class->QuantityArray,
      Pattern:>QuantityCoordinatesP[{(Milligram/Milliliter),(Mole/Gram)}],
      Units->{(Milligram/Milliliter),(Mole/Gram)},
      Description->"Data from which the second virial coefficient is calculated.",
      Category->"Experimental Results"
    },
    EstimatedMolecularWeight->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0*Dalton],
      Units->Dalton,
      Description->"The weight-averaged molar mass estimated based on particle conformation, size, and density.",
      Category->"Experimental Results"
    },
    (*Melting curve fields*)
    (*Values from melting curve*)
    MeltingTemperature->{
      Format-> Multiple,
      Class-> Real,
      Pattern:> GreaterP[0*Kelvin],
      Units-> Celsius,
      Description->"Melting temperature, also known as Midpoint transition temperature or Tm. This is defined as the midpoint in the transition between folded and unfolded states and is determined from Dynamic Light Scattering (DLS) data along with confirmation from Static Light Scattering (SLS) data that aggregation has not occurred.",
      Category->"Experimental Results"
    },
    AggregationOnsetTemperature->{
      Format-> Multiple,
      Class->Real,
      Pattern:> GreaterP[0*Kelvin],
      Units-> Celsius,
      Description->"Temperature of onset of aggregation, also known as Tagg. This is determined from Static Light Scattering (SLS) data to confirm an increase in molar mass of particles.",
      Category->"Experimental Results"
    },
    UnfoldingOnsetTemperature->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterEqualP[0(Kelvin)],
      Units->Celsius,
      Description->"Temperature of onset for global unfolding, also known as Tonset. This is determined by Dynamic Light Scattering (DLS) data as confirmation of expansion of hydrodynamic diameter, with support from Static Light Scattering (SLS) data that aggregation has not occurred.",
      Category->"Experimental Results"
    },
    SLSCalibrationRSquared->{
      Format->Multiple,
      Class->Real,
      Pattern:>RangeP[0,1],
      Units->None,
      Description->"For SLS plate calibrations, the R-squared value of each series of calibrations as functions of concentration. A single value represents the R-squared value at the specified DiodeAttenuation. Multiple values represent the R-squared values at each of 0.0%, 50.0%, 75.0%, 90.0%, and 99.0% attenuations.",
      Category->"Experimental Results"
    },
    RawDataFiles->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[EmeraldCloudFile],
      Description->"The file(s) containing the raw unprocessed data generated by the instrument.",
      Category->"Data Processing"
    },
    MassDistributionAnalyses->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Analysis][Reference],
      Description->"Peak picking analyses performed on the MassDistribution data.",
      Category->"Analysis & Reports"
    },
    IntensityDistributionAnalyses->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Analysis][Reference],
      Description->"Peak picking analyses performed on the IntensityDistribution data.",
      Category->"Analysis & Reports"
    },
    NumberDistributionAnalyses->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Analysis][Reference],
      Description->"Peak picking analyses performed on the NumberDistribution data.",
      Category->"Analysis & Reports"
    },
    DynamicLightScatteringAnalyses->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Analysis][Reference],
      Description->"Analysis of dynamic light scattering to determine the particle size, diffusion interaction parameter, and second virial coefficient.",
      Category->"Analysis & Reports"
    },
    SampleImages->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[EmeraldCloudFile],
      Description->"Images of the bottom of the well plate containing samples.",
      Category->"Analysis & Reports"
    }
  }
}];
