(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol,DynamicLightScattering],{
  Description->"A Dynamic Light Scattering (DLS) experiment. The base function of a DLS assay is the evaluation of the hydrodynamic radius of an analyte in solution. This allows for calculation of polydispersity index (defined as the ratio of mass-average molar mass to number-average molar mass), colloidal stability parameters, and melting curves.",
  CreatePrivileges->None,
  Cache->Session,
  Fields->{
    AssayType->{
      Format->Single,
      Class->Expression,
      Pattern:>DynamicLightScatteringAssayTypeP,
      Description->"The Dynamic Light Scattering (DLS) assay that is run. SizingPolydispersity makes a single DLS measurement that provides information about the size and polydispersity (defined as the ratio of mass-average molar mass to number-average molar mass) of particles in the input samples. ColloidalStability makes DLS measurements at various dilutions of a sample below 25 mg/mL to calculate the diffusion interaction parameter (kD) and the second virial coefficient (B22), and does the same for a sample of mass concentration 20-100 mg/mL to calculate the Kirkwood-Buff Integral (G22) at each dilution concentration; Static Light Scattering (SLS) measurements can be used to calculate A2 and the molecular weight of the analyte. MeltingCurve makes DLS measurements over a range of temperatures in order to calculate melting temperature (Tm), temperature of aggregation (Tagg), and temperature of onset of unfolding (Tonset). IsothermalStability makes multiple DLS measurements at a single temperature over time in order to probe stability of the analyte at a particular temperature.",
      Category -> "General",
      Abstract->True
    },
    AssayFormFactor->{
      Format->Single,
      Class->Expression,
      Pattern:>Alternatives[Capillary,Plate],
      Description->"Indicates if the sample is loaded in capillary strips, which are utilized by a Multimode Spectrophotometer, or a standard plate, which is utilized by a DLS Plate Reader.",
      Category->"General",
      Abstract->True
    },
    Instrument->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[
        Model[Instrument],
        Object[Instrument]
      ],
      Description->"The instrument used for this experiment. Options comprise models and objects of multimode spectrophotometer and DLS plate reader.",
      Category->"General",
      Abstract->True
    },
    AssayContainers->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Object[Container,Plate],Model[Container,Plate]],
      Description->"The capillary strips or plates that the samples are assayed in.",
      Category->"Sample Loading"
    },
    AssayContainerModel->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Container,Plate],
      Description->"When AssayFormFactor is Plate, the plate that the samples are assayed in.",
      Category->"Sample Loading",
      Developer->True
    },
    SampleLoadingPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Container,Plate]|Model[Container,Plate],
      Description->"When AssayFormFactor is Capillary, the container into which input samples are transferred (or in which input sample dilutions are performed when AssayType is ColloidalStability) before centrifugation and transferring samples into the AssayContainer(s) for DLS measurement.",
      Category->"Sample Loading"
    },
    PlatePreparationUnitOperations->{
      Format->Multiple,
      Class->Expression,
      Pattern:>SampleManipulationP,
      Description->"A set of unit operations specifying the transfers and dilutions of the input samples in the SampleLoadingPlate (when AssayFormFactor is Capillary) or AssayContainer (when AssayFormFactor is Plate).",
      Category->"Sample Loading",
      Developer->True
    },
    PlatePreparation->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Protocol,ManualSamplePreparation]|Object[Protocol,RoboticSamplePreparation]|Object[Protocol,SampleManipulation],(*TODO: sort this out at some point*)
      Description->"A sample preparation protocol used to transfer and dilute the input samples in the SampleLoadingPlate (when AssayFormFactor is Capillary) or AssayContainer(when AssayFormFactor is Plate).",
      Category->"Sample Loading"
    },
    WellCover->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Model[Item,PlateSeal],Object[Item,PlateSeal],Model[Sample],Object[Sample]],
      Description->"When AssayFormFactor is Plate, determines what covering is used for wells. The manufacturer's recommended coverings are plate seal and oil; other covers (e.g. lids) have not yet been evaluated for their effects on light scattering optics.",
      Category->"Sample Loading"
    },
    WellCoverHeating->{
      Format->Single,
      Class->Boolean,
      Pattern:>BooleanP,
      Description->"When WellCover is a plate seal, indicates if the plate seal is heated.",
      Category->"Sample Loading"
    },
    WellCoverOilVolume->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Microliter],
      Units->Microliter,
      Description->"When WellCover is an oil, determines the volume of oil used to cover the wells.",
      Category->"Sample Loading",
      Developer->True
    },
    SampleVolume->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Microliter],
      Units->Microliter,
      Description->"When AssayType is SizingPolydispersity, IsothermalStability, or MeltingCurve, the amount of each input sample that is transferred into the SamplePreparationPlate before centrifugation and transfer of input samples into the AssayContainer(s) for DLS measurement.",
      Category->"Sample Loading"
    },
    CapillaryLoadingVolume->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Microliter],
      Units->Microliter,
      Description->"When AssayFormFactor is Capillary, the amount of each input sample, or each concentration of the DilutionCurve, that is loaded from the SampleLoadingPlate into an individual well of the capillary.",
      Category->"Sample Loading"
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
    CollectStaticLightScattering->{
      Format->Single,
      Class->Boolean,
      Pattern:>BooleanP,
      Description->"Indicates if static light scattering (SLS) data are collected along with DLS data.",
      Category->"Light Scattering"
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
      Pattern:>GreaterP[0*Percent],
      Units->Percent,
      Description->"The percent of scattered signal that is allowed to reach the avalanche photodiode mediated by diode attenuators.",
      Category->"Light Scattering"
    },
    DLSRunTime->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0*Minute],
      Units->Minute,
      Description->"The length of time for which the instrument is expected to run given the specified parameters.",
      Category->"Light Scattering"
    },
    CalibrationStandardIntensity->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0],(*Note: this should be moved across the board to units of 1/second*)
      Description->"The most recent scattered light intensity of a standard sample in counts per second.",
      Category->"Light Scattering"
    },
    CapillaryLoading->{
      Format->Single,
      Class->Expression,
      Pattern:>Alternatives[Robotic,Manual],
      Description->"The loading method for capillaries. When set to Robotic, capillaries are loaded by liquid handler. When set to Manual, capillaries are loaded by a multichannel pipette. Each method presents specific mechanical challenges due to the difficulty of precise loading.",
      Category->"Sample Loading"
    },
    ManualLoadingPlate->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Container,Plate]|Object[Container,Plate]|Model[Container,Vessel]|Object[Container,Vessel],
      Description->"The plate from which samples are loaded onto assay capillaries manually using an 8-channel multichannel pipette.",
      Category->"Sample Loading"
    },
    ManualLoadingPipette->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Instrument,Pipette]|Object[Instrument,Pipette],
      Description->"The 8-channel multichannel pipette that is used to manually load samples onto assay capillaries manually.",
      Category->"Sample Loading"
    },
    ManualLoadingTips->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Item,Tips]|Object[Item,Tips],
      Description->"The pipette tips that are used to manually load samples onto assay capillaries manually using an 8-channel multichannel pipette.",
      Category->"Sample Loading"
    },
    ManualLoadingTuples->{(*todo: consider vanquishing*)
      Format->Multiple,
      Class->{
        Sources->Link,
        SourceRow->Expression,
        Targets->Link,
        TargetRow->Expression,
        FirstWell->Expression,
        NumberOfWells->Expression
      },
      Pattern:>{
        Sources->_Link,
        SourceRow->_String,
        Targets->_Link,
        TargetRow->_String,
        FirstWell->_String,
        NumberOfWells->_String
      },
      Relation->{
        Sources->Alternatives[
          Model[Container,Plate],
          Object[Container,Plate],
          Model[Container,Vessel],
          Object[Container,Vessel]
          ],
        SourceRow->Null,
        Targets->Alternatives[
          Model[Container,Plate],
          Object[Container,Plate],
          Model[Container,Vessel],
          Object[Container,Vessel]
        ],
        TargetRow->Null,
        FirstWell->Null,
        NumberOfWells->Null
      },
      Description->"The pipetting instructions used to manually load samples onto assay capillaries manually. This plate is set for loading using an 8-channel multichannel pipette.",
      Category->"Sample Loading",
      Developer->True
    },
    AssayPositions->{
      Format->Multiple,
      Class->String,
      Pattern:>WellPositionP,
      Description->"For each member of SamplesIn, the well positions of the samples in the AssayContainer (either a standard plate or a set of capillaries).",
      IndexMatching->SamplesIn,
      Category->"Sample Loading",
      Developer->True
    },
    CapillaryClips->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation-> Alternatives[Object[Container],Model[Container]],
      Description->"The clips used to seal the capillary assay containers, after which the assembled complex is loaded into the multimode spectrophotometer.",
      Category->"Sample Loading",
      Developer->True
    },
    CapillaryGaskets->{
      Format->Single,
      Class -> Link,
      Pattern:>_Link,
      Relation-> Alternatives[Object[Item,Consumable],Model[Item,Consumable]],
      Description->"The gaskets inserted into the capillary clips prior to sealing the capillary assay containers in order to hold the capillaries in place.",
      Category->"Sample Loading",
      Developer->True
    },
    CapillaryStripLoadingRack->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Alternatives[Object[Container,Plate],Model[Container,Plate]],
      Description->"The capillary strip plate adapter rack for loading samples using a liquid handler.",
      Category->"Sample Loading",
      Developer->True
    },
    SampleStageLid->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation-> Alternatives[Object[Part],Model[Part]],
      Description->"The insulated lid enclosing the sample stage of the multimode spectrophotometer prior to closing the instrument door.",
      Category->"Sample Loading",
      Developer->True
    },
    AssayContainerFillDirection->{
      Format->Single,
      Class->Expression,
      Pattern:>Alternatives[Row,Column,SerpentineRow,SerpentineColumn],
      Description->"WhenAssayFormFactor is Capillary, indicates the order in which the capillary strip AssayContainers are filled. Column indicates that all 16 wells of an AssayContainer capillary strip are filled with input samples or sample dilutions before starting to fill a second capillary strip (up to 3 strips, 48 wells). Row indicates that one well of each capillary strip is filled with input samples or sample dilutions before filling the second well of each strip. When AssayFormFactor is Plate, indicates the direction the AssayContainer is filled: either Row, Column, SerpentineRow, or SerpentineColumn.",
      Category->"Sample Loading"
    },
    CapillaryPlatePreparationUnitOperations->{
      Format->Multiple,
      Class->Expression,
      Pattern:>SampleManipulationP,
      Description->"When AssayFormFactor is Capillary, a set of unit operations specifying the loading of the AssayContainers with the input samples, diluted input samples, and BlankBuffers from the SampleLoadingPlate.",
      Category->"Sample Loading"
    },
    CapillaryPlatePreparation->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Protocol,ManualSamplePreparation]|Object[Protocol,RoboticSamplePreparation],
      Description->"When AssayFormFactor is Capillary, a sample Preparation protocol used to load the AssayContainers from the SampleLoadingPlate.",
      Category->"Sample Loading"
    },
    SamplesPerCapillaryStrip->{(*todo: this should likely be deleted, and anything that employs it should be reworked so this is not necessary*)
      Format->Single,
      Class->{
        PrimaryCapillaryStrip->Integer,
        SecondaryCapillaryStrip->Integer,
        TertiaryCapillaryStrip->Integer
      },
      Pattern:>{
        PrimaryCapillaryStrip->GreaterEqualP[0,1],
        SecondaryCapillaryStrip->GreaterEqualP[0,1],
        TertiaryCapillaryStrip->GreaterEqualP[0,1]
      },
      Units->{
        PrimaryCapillaryStrip->None,
        SecondaryCapillaryStrip->None,
        TertiaryCapillaryStrip->None
      },
      Description->"When AssayFormFactor is Capillary, the number of samples loaded into each AssayContainer when AssayContainerFillDirection is Row.",
      Category->"Sample Loading",
      Developer->True
    },
    EmptyWellsPerCapillaryStrip->{(*todo: this should likely be deleted, and anything that employs it should be reworked so this is not necessary*)
      Format->Single,
      Class->{
        PrimaryCapillaryStrip->Integer,
        SecondaryCapillaryStrip->Integer,
        TertiaryCapillaryStrip->Integer
      },
      Pattern:>{
        PrimaryCapillaryStrip->GreaterEqualP[0,1],
        SecondaryCapillaryStrip->GreaterEqualP[0,1],
        TertiaryCapillaryStrip->GreaterEqualP[0,1]
      },
      Units->{
        PrimaryCapillaryStrip->None,
        SecondaryCapillaryStrip->None,
        TertiaryCapillaryStrip->None
      },
      Description->"When AssayFormFactor is Capillary, the number of capillaries with no sample in each AssayContainer when AssayContainerFillDirection is Row.",
      Category->"Sample Loading",
      Developer->True
    },
    ContainerPlacements->{(*todo: can placement fields be killed? consider, again, vanquishing*)
      Format->Multiple,
      Class->{Link,Expression},
      Pattern:>{_Link,{LocationPositionP}},
      Relation->{Object[Container]|Model[Container]|Object[Part]|Model[Part],Null},
      Description->"When AssayFormFactor is Capillary, a list of placements used to place the capillary strips to be analyzed into the sample stage of the multimode spectrophotometer.",
      Category->"Sample Loading",
      Developer->True,
      Headers->{"Object to Place","Placement Tree"}
    },
    (* Sample Dilution and ColloidalStability Fields (mostly mirroring MeasureSurfaceTension *)
    ColloidalStabilityParameterType->{
      Format->Single,
      Class->Expression,
      Pattern:>Alternatives[B22kD,G22],
      Description->"When AssayFormFactor is Capillary and AssayType is ColloidalStability, the parameter(s) calculated to measure attraction and/or repulsion between analytes in solution. B22 and kD are used when the mass concentration of the analyte is below 20 mg/mL, while G22 is used when the mass concentration of the analyte is above 20 mg/mL.",
      Category->"Sample Loading",
      Developer->True
    },
    ColloidalStabilityParametersPerSample->{
      Format->Single,
      Class->Integer,
      Pattern:>GreaterP[0,1],
      Units->None,
      Description->"The number of dilution concentrations made for, and thus independent B22/A2 and kD or G22 parameters calculated from, each input sample.",
      Category->"Sample Dilution"
    },
    DilutionSampleVolumes->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterEqualP[0*Microliter],
      Units->Microliter,
      Description->"For each member of SamplesIn, the amount of sample or aliquot that is used to make the dilution curves.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution",
      Abstract->True
    },
    Analytes->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Model[Molecule],
      Description->"For each member of SamplesIn, the molecule member of the Composition field whose concentration is used to calculate B22/A2 and kD or G22 when the AssayType is ColloidalStability.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    AnalyteMassConcentrations->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterEqualP[0*Milligram/Milliliter],
      Units->(Milligram/Milliliter),
      Description->"For each member of SamplesIn, the initial mass concentration of the Analyte before any dilutions outlined by the DilutionCurve or SerialDilutionCurve are performed when the AssayType is ColloidalStability.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    AnalyteStoredMolecularWeight->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterP[0*Dalton],
      Units->Dalton,
      Description->"For each member of SamplesIn, the molecular weight stored in the model of the Analyte when the AssayType is ColloidalStability.",
      Category->"Sample Dilution",
      IndexMatching->SamplesIn,
      Developer->True
    },
    ReplicateDilutionCurve->{(*todo: double check this is not being used as a shortcut, but this should not be here*)
      Format->Single,
      Class->Expression,
      Pattern:>BooleanP,
      Description->"Indicates if a NumberOfReplicates number of StandardDilutionCurves or SerialDilutionCurves are made for each input sample. When ReplicateDilutionCurve is True, the replicate DLS measurements for ColloidalStability assay are made from the same concentration of each of the StandardDilutionCurves or SerialDilutionCurves created from a given input sample. When ReplicateDilutionCurve is False, the replicate DLS measurements for the ColloidalStability assay are made from aliquots of a given concentration of the DilutionCurve or SerialDilutionCurve.",
      Category->"Sample Dilution"
    },
    Dilutions->{(*todo: touch base with Harrison about dilution protocols. can we unpack by turning into tuple with SamplesIn?*)
      Format->Multiple,
      Class->Expression,
      Pattern:>{{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}...}|Null,
      Description->"For each member of SamplesIn, the collection of dilutions performed on the sample before making light scattering measurements. This is the volume of the sample and the volume of the diluent that will be mixed together for each concentration in the dilution curve.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    SerialDilutions->{(*todo: can we unpack by turning into tuple with SamplesIn?*)
      Format->Multiple,
      Class->Expression,
      Pattern:>{{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter]}...}|Null,
      Description->"For each member of SamplesIn, the volume of the sample transferred in a serial dilution and the volume of the Diluent it is mixed with at each step.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    DilutionFactors->{(*todo: can we unpack by turning into tuple with SamplesIn?*)
      Format->Multiple,
      Class->Expression,
      Pattern:>{Alternatives[_Integer,_Real,_Rational]..}|{Null..}|Null,
      Description->"For each member of SamplesIn, the ratios of the volume of input sample to the sum of the input sample volume and diluent volume for each dilution.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    DilutionConcentrations->{(*todo: can we unpack by turning into tuple with SamplesIn?*)
      Format->Multiple,
      Class->Expression,
      Pattern:>{GreaterEqualP[0*(Milligram/Milliliter)]..}|{Null..}|Null,
      Description->"For each member of SamplesIn, the analyte mass concentrations of each dilution.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    Buffers->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Sample]|Model[Sample],
      Description->"For each member of SamplesIn, the sample that is used to dilute the sample to a concentration series.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    DilutionMixType->{
      Format->Single,
      Class->Expression,
      Pattern:>MixTypeP,
      Description->"The method used to mix the SampleLoadingPlate or AssayContainer used for dilution.",
      Category->"Sample Dilution"
    },
    DilutionMixVolumes->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterEqualP[0 Microliter],
      Units->Microliter,
      Description->"For each member of SamplesIn, the volume that is pipetted up and down from the dilution to mix the sample with the Buffer to make the mixture homogeneous.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    DilutionNumberOfMixes->{
      Format->Multiple,
      Class->Integer,
      Pattern:>GreaterP[0,1],
      Description->"For each member of SamplesIn, the number of pipette out and in cycles that is used to mix the sample with the Buffer to make the DilutionCurve.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    DilutionMixRates->{
      Format->Multiple,
      Class->Real,
      Pattern:>GreaterP[0*Microliter/Second],
      Units->Microliter/Second,
      Description->"For each member of SamplesIn, the speed at which the DilutionMixVolume is pipetted out of and into the dilution to mix the sample with the Diluent to make the DilutionCurve.",
      IndexMatching->SamplesIn,
      Category->"Sample Dilution"
    },
    DilutionMixInstrument->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->MixInstrumentModelP,
      Description->"The instrument used to mix the dilutions in the SampleLoadingPlate or AssayContainer used for dilution.",
      Category->"Sample Dilution"
    },
    BlankBuffers->{
      Format->Multiple,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Sample]|Model[Sample],
      Description->"For each member of SamplesIn, the sample that is used as a 0 mg/mL blank in ColloidalStability assays, to determine the diffusion coefficient at infinite dilution.",
      IndexMatching->SamplesIn,
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
    (*MeltingCurve fields*)
    MinTemperature->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Kelvin],
      Units->Celsius,
      Description->"The low temperature of the heating or cooling curve; the starting temperature when TemperatureRampOrder is {Heating,Cooling}.",
      Category->"Melting Curve"
    },
    MaxTemperature->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Kelvin],
          Units->Celsius,
      Description->"The high temperature of the heating or cooling curve; the starting temperature when TemperatureRampOrder is {Cooling,Heating}.",
      Category->"Melting Curve"
    },
    TemperatureRampOrder->{
      Format->Single,
      Class->Expression,
      Pattern:>ThermodynamicCycleP,
      Description->"The order of temperature ramping (i.e., heating followed by cooling or vice versa) to be performed in each cycle. Heating is defined as going from MinTemperature to MaxTemperature; cooling is defined as going from MaxTemperature to MinTemperature.",
      Category->"Melting Curve"
    },
    NumberOfCycles->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterEqualP[0,0.5],
      Description->"The number of instances of repeated heating and cooling (or vice versa) cycles.",
      Category->"Melting Curve"
    },
    TemperatureRampRate -> {
      Format -> Single,
      Class -> Real,
      Pattern :> GreaterEqualP[(0*Celsius)/Second],
      Units -> Celsius/Second,
      Description -> "The rate at which the temperature is changed in the course of one heating and/or cooling cycle.",
      Category -> "Melting Curve"
    },
    TemperatureRamping->{
      Format->Single,
      Class->Expression,
      Pattern:>Alternatives[Linear,Step],
      Description->"The type of temperature ramp. Linear temperature ramps increase temperature at a constant rate given by TemperatureRampRate. Step temperature ramps increase the temperature by TemperartureRampStep and holds the temperature constant for TemperatureRampStepTime before increasing the temperature again.",
      Category->"Melting Curve"
    },
    TemperatureResolution->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Kelvin],
      Units->Celsius,
      Description->"The absolute amount by which the temperature is changed between each data point and the next during the melting and/or cooling curves. This value is necessarily positive, as a decrease in temperature is defined as a cooling curve.",
      Category->"Melting Curve"
    },
    NumberOfTemperatureRampSteps->{
      Format->Single,
      Class->Integer,
      Pattern:>GreaterP[0, 1],
      Description->"The number of step changes in temperature for a heating or cooling cycle.",
      Category->"Melting Curve"
    },
    StepHoldTime->{
      Format->Single,
      Class->Real,
      Pattern:>GreaterP[0*Second],
      Units->Second,
      Description->"The length of time samples are held at each temperature during a stepped temperature ramp.",
      Category->"Melting Curve"
    },

    SampleLoadingPlateStorageCondition->{
      Format->Single,
      Class->Expression,
      Pattern:>(SampleStorageTypeP|Disposal|ObjectP[Model[StorageCondition]]),
      Description->"The conditions under which any leftover samples from the DilutionCurve or SerialDilutionCurve are stored in the SampleLoadingPlate after the samples are transferred to the AssayContainer(s).",
      Category->"Sample Storage"
    },
    SamplesInStorageCondition->{
      Description->"The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed.",
      Format->Multiple,
      Class->Expression,
      Pattern:>(SampleStorageTypeP|Disposal|ObjectP[Model[StorageCondition]]),
      Category->"Sample Storage"
    },
    SamplesOutStorageCondition->{
      Format->Single,
      Class->Expression,
      Pattern:>(SampleStorageTypeP|Disposal|ObjectP[Model[StorageCondition]]),
      Description->"The non-default conditions under which the SamplesOut of this experiment should be stored after the protocol is completed.",
      Category->"Sample Storage"
    },

    (* File stuff *)
    NumberOfMeasurements->{
      Format->Single,
      Class->Integer,
      Pattern:>GreaterEqualP[0, 1],
      Description->"The number of measurements conducted by the instrument during a DLS experiment.",
      Category->"Data Processing",
      Developer->True
    },
    MethodFilePath->{
      Format->Single,
      Class->String,
      Pattern:>FilePathP,
      Description->"The full file path (including the file name) of the file containing instructions used by the instrument software to run this protocol.",
      Category->"Data Processing",
      Developer->True
    },
    SampleFilePath->{
      Format->Single,
      Class->String,
      Pattern:>FilePathP,
      Description->"The full file path (including the file name) of the file containing the sample information for this protocol.",
      Category->"Data Processing",
      Developer->True
    },
    MethodFileDirectory->{
      Format->Single,
      Class->String,
      Pattern:>FilePathP,
      Description->"The full file directory for the files containing instructions used by the instrument software to run this protocol.",
      Category->"Data Processing",
      Developer->True
    },
    InstrumentDataFileDirectory->{
      Format->Single,
      Class->String,
      Pattern:>FilePathP,
      Description->"The file directory on the instrument computer in which the data generated by the experiment is stored locally.",
      Category->"Data Processing",
      Developer->True
    },
    DataTransferFilePath->{
      Format->Single,
      Class->String,
      Pattern:>FilePathP,
      Description->"The file path (including the file name) of the .bat file which transfers data to the public drive at the conclusion of the experiment.",
      Category->"Data Processing",
      Developer->True
    },
    DataFileDirectory->{
      Format->Single,
      Class->String,
      Pattern:>FilePathP,
      Description->"The name of the directory where the data files are stored at the conclusion of the experiment.",
      Category->"Data Processing",
      Developer->True
    },
    ImagesFileDirectory->{
      Format->Single,
      Class->String,
      Pattern:>FilePathP,
      Description->"The name of the directory where the well plate image files are stored at the conclusion of the experiment.",
      Category->"Data Processing",
      Developer->True
    },
    DataFileName->{
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"The name of the .bat file (excluding the file extension) which transfers the contents of the InstrumentDataFilePath to the DataFilePath.",
      Category->"Data Processing",
      Developer->True
    },
    DataFile->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[EmeraldCloudFile],
      Description->"The file containing the method information and the data generated by the instrument.",
      Category->"Data Processing"
    },
    LoadExperimentInstruction->{
      Format->Single,
      Class->String,
      Pattern:>_String,
      Description->"The instruction to be provided to the instrument software in order to properly load the given experiment file.",
      Category->"Data Processing",
      Developer->True
    },
    ParserManifoldJob->{
      Format->Single,
      Class->Link,
      Pattern:>_Link,
      Relation->Object[Notebook,Job],
      Description->"The manifold job object created to parse the dynamic light scattering protocol.",
      Category->"Data Processing",
      Developer->True
    },
    DynamicLightScatteringLoadingAnalyses->{
        Format->Multiple,
        Class->Link,
        Pattern:>_Link,
        Relation->Object[Analysis][Reference],
        Description->"Analyses that determine properly loaded dynamic light scattering samples, to account for the difficulty in loading samples into capillaries for multimode spectrophotometers.",
        Category->"Analysis & Reports"
    }
  }
}];
