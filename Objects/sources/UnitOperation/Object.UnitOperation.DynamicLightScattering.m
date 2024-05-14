(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2022 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,DynamicLightScattering],
	{
		Description->"A detailed set of parameters that specifies a dynamic light scattering experiment.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			SampleLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Model[Container],
					Object[Container]
				],
				Description -> "Source samples to be run in this dynamic light scattering experiment.",
				Category -> "General",
				Migration->SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "Source samples to be run in this dynamic light scattering experiment.",
				Category -> "General",
				Migration->SplitField
			},
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
				Relation -> Null,
				Description -> "Source samples to be run in this dynamic light scattering experiment.",
				Category -> "General",
				Migration->SplitField
			},
			(* This is either Sources or the corresponding WorkingSamples after aliquoting etc. *)
			WorkingSamples -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Description -> "For each member of SampleLink, the samples to be run with a dynamic light scattering experiment after any aliquoting, if applicable.",
				Category -> "Organizational Information",
				IndexMatching -> SampleLink,
				Developer -> True
			},
			WorkingContainers -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of SampleLink, the containers holding the samples to be run with a dynamic foam analysis experiment after any aliquoting, if applicable.",
				Category -> "General",
				IndexMatching -> SampleLink,
				Developer -> True
			},
			SampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleLink, the label of the sample that is analyzed.",
				Category -> "General",
				Developer -> True,
				IndexMatching -> SampleLink
			},
			SampleContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Description -> "For each member of SampleLink, the label of the sample's container.",
				Category -> "General",
				Developer -> True,
				IndexMatching -> SampleLink
			},

			(* experiment options *)
			AssayType->{
				Format->Single,
				Class->Expression,
				Pattern:>DynamicLightScatteringAssayTypeP,
				Description->"The Dynamic Light Scattering (DLS) assay that is run. SizingPolydispersity makes a single DLS measurement that provides information about the size and polydispersity (defined as the ratio of mass-average molar mass to number-average molar mass) of particles in the input samples. ColloidalStability makes DLS measurements at various dilutions of a sample below 25 mg/mL to calculate the diffusion interaction parameter (kD) and the second virial coefficient (B22 or A2), and does the same for a sample of mass concentration 20-100 mg/mL to calculate the Kirkwood-Buff Integral (G22) at each dilution concentration; Static Light Scattering (SLS) measurements can be used to calculate A2 and the molecular weight of the analyte. MeltingCurve makes DLS measurements over a range of temperatures in order to calculate melting temperature (Tm), temperature of aggregation (Tagg), and temperature of onset of unfolding (Tonset). IsothermalStability makes multiple DLS measurements at a single temperature over time in order to probe stability of the analyte at a particular temperature.",
				Category->"General",
				Abstract->True
			},
      AssayFormFactor->{
        Format->Single,
        Class->Expression,
        Pattern:>Alternatives[Capillary,Plate],
        Description->"Indicates if the sample is loaded in capillary strips, which are utilized by a Multimode Spectrophotometer, or a standard plate which is utilized by a DLS Plate Reader.",
        Category->"General",
        Abstract->True
      },
			InstrumentLink->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Instrument],
					Object[Instrument]
				],
				Description->"The instrument used for this experiment. Options comprise models and objects of multimode spectrophotometer and DLS plate reader.",
				Category->"General",
				Migration->SplitField
			},
			InstrumentString->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Relation->Null,
				Description->"The instrument used for this experiment. Options comprise models and objects of multimode spectrophotometer and DLS plate reader.",
				Category->"General",
				Migration->SplitField
			},
			InstrumentExpression->{
				Format->Single,
				Class->Expression,
				Pattern:>ObjectP[
					Model[Instrument],
					Object[Instrument]
				],
				Relation->Null,
				Description->"The instrument used for this experiment. Options comprise models and objects of multimode spectrophotometer and DLS plate reader.",
				Category->"General",
				Migration->SplitField
			},
			SampleLoadingPlateLink->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Container,Plate],
					Model[Container,Plate]
				],
				Description->"When AssayFormFactor is Capillary, the container into which input samples are transferred (or in which input sample dilutions are performed when AssayType is ColloidalStability) before centrifugation and transferring samples into the AssayContainer(s) for DLS measurement.",
				Category->"Sample Loading",
				Migration->SplitField
			},
			SampleLoadingPlateString->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Relation->Null,
				Description->"When AssayFormFactor is Capillary, the container into which input samples are transferred (or in which input sample dilutions are performed when AssayType is ColloidalStability) before centrifugation and transferring samples into the AssayContainer(s) for DLS measurement.",
				Category->"Sample Loading",
				Migration->SplitField
			},
			SampleLoadingPlateExpression->{
				Format->Single,
				Class->Expression,
				Pattern:>ObjectP[
					Object[Container,Plate],
					Model[Container,Plate]
				],
				Relation->Null,
				Description->"When AssayFormFactor is Capillary, the container into which input samples are transferred (or in which input sample dilutions are performed when AssayType is ColloidalStability) before centrifugation and transferring samples into the AssayContainer(s) for DLS measurement.",
				Category->"Sample Loading",
				Migration->SplitField
			},
			WellCoverLink->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Model[Item,PlateSeal],
					Object[Item,PlateSeal],
					Model[Sample],
					Object[Sample]
				],
				Description->"When AssayFormFactor is Plate, determines what covering is used for wells. The manufacturer's recommended coverings are plate seal and oil; other covers (e.g. lids) have not yet been evaluated for their effects on light scattering optics.",
				Category->"Sample Loading",
				Migration->SplitField
			},
			WellCoverString->{
				Format->Single,
				Class->String,
				Pattern:>_String,
				Relation->Null,
				Description->"When AssayFormFactor is Plate, determines what covering is used for wells. The manufacturer's recommended coverings are plate seal and oil; other covers (e.g. lids) have not yet been evaluated for their effects on light scattering optics.",
				Category->"General",
				Migration->SplitField
			},
			WellCoverExpression->{
				Format->Single,
				Class->Expression,
				Pattern:>_Link,
				Relation->ObjectP[
					Model[Item,PlateSeal],
					Object[Item,PlateSeal],
					Model[Sample],
					Object[Sample]
				],
				Description->"When AssayFormFactor is Plate, determines what covering is used for wells. The manufacturer's recommended coverings are plate seal and oil; other covers (e.g. lids) have not yet been evaluated for their effects on light scattering optics.",
				Category->"General",
				Migration->SplitField
			},
			WellCoverHeating->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"When WellCover is a plate seal, indicates if the plate seal is heated.",
				Category->"General"
			},
			SampleVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Microliter],
				Units->Microliter,
				Description->"When AssayType is SizingPolydispersity, MeltingCurve, or IsothermalStability, the SampleVolume is the amount of each input sample that is transferred into the SamplePreparationPlate before the SamplePreparationPlate is centrifuged and 10 uL of each sample is transferred into the AssayContainer(s) for DLS measurement. When the AssayType is ColloidalStability, the amount of input sample required for the experiment is specified with either the DilutionCurve or SerialDilutionCurve option.",
				Category->"Sample Loading"
			},
			TemperatureReal->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Kelvin],
				Units->Celsius,
				Description->"The temperature to which the incubation chamber is set prior to detection.",
				Category->"Sample Loading",
				Migration->SplitField
			},
			TemperatureExpression->{
				Format->Single,
				Class->Expression,
				Pattern:>Ambient,
				Description->"The temperature to which the incubation chamber is set prior to detection.",
				Category->"Sample Loading",
				Migration->SplitField
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
				Description->"For each DLS measurement, the length of time that each acquisition generates speckle patterns to create the measurement's autocorrelation curve.",
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
				Category->"General"
			},
			CalibrationStandardIntensity->{
				Format->Single,
				Class->Real,
				Pattern:>(GreaterEqualP[0]/Second),
				Units->1/Second,
				Description->"The most recent scattered light intensity of a standard sample in counts per second.",
				Category->"Light Scattering"
			},
			CapillaryLoading->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[Robotic, Manual],
				Description->"The loading method for capillaries. When set to Robotic, capillaries are loaded by liquid handler. When set to Manual, capillaries are loaded by a multichannel pipette. Each method presents specific mechanical challenges due to the difficulty of precise loading.",
				Category->"Sample Loading"
			},
			AssayContainerFillDirection->{
				Format->Single,
      	Class->Expression,
      	Pattern:>Alternatives[Row,Column,SerpentineRow,SerpentineColumn],
     		Description->"WhenAssayFormFactor is Capillary, indicates the order in which the capillary strip AssayContainers are filled. Column indicates that all 16 wells of an AssayContainer capillary strip are filled with input samples or sample dilutions before starting to fill a second capillary strip (up to 3 strips, 48 wells). Row indicates that one well of each capillary strip is filled with input samples or sample dilutions before filling the second well of each strip. When AssayFormFactor is Plate, indicates the direction the AssayContainer is filled: either Row, Column, SerpentineRow, or SerpentineColumn.",
      	Category->"Sample Loading"
			},
			ColloidalStabilityParametersPerSample->{
				Format->Single,
				Class->Integer,
				Pattern:>GreaterP[0,1],
				Units->None,
				Description->"The number of dilution concentrations made for, and thus independent B22/A2 and kD or G22 parameters calculated from, each input sample.",
				Category->"Colloidal Stability"
			},
			AnalyteLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Model[Molecule],
				Description->"For each member of SamplesIn, the molecule member of the Composition field whose concentration is used to calculate B22/A2 and kD or G22 when the AssayType is ColloidalStability.",
				Category->"Sample Dilution",
				Migration->SplitField
			},
			AnalyteString->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Relation->None,
				Description->"For each member of SamplesIn, the molecule member of the Composition field whose concentration is used to calculate B22/A2 and kD or G22 when the AssayType is ColloidalStability.",
				Category->"Sample Dilution",
				Migration->SplitField
			},
			AnalyteExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ObjectP[Model[Molecule]],
				Relation->None,
				Description->"For each member of SamplesIn, the molecule member of the Composition field whose concentration is used to calculate B22/A2 and kD or G22 when the AssayType is ColloidalStability.",
				Category->"Sample Dilution",
				Migration->SplitField
			},
			AnalyteMassConcentration->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Milligram/Milliliter],
				Units->(Milligram/Milliliter),
				Description->"For each member of SamplesIn, the initial mass concentration of the Analyte before any dilutions outlined by the DilutionCurve or SerialDilutionCurve are performed when the AssayType is ColloidalStability.",
				Category->"Sample Dilution"
			},
			ReplicateDilutionCurve->{
				Format->Single,
				Class->Expression,
				Pattern:>BooleanP,
				Description->"Indicates if a NumberOfReplicateConcentrations number of DilutionCurves or SerialDilutionCurves are made for each input sample. When ReplicateDilutionCurve is False, the replicate DLS measurements for the B22kD or G22 assay are made from aliquots of a given concentration of the DilutionCurve or SerialDilutionCurve. When ReplicateDilutionCurve is True, the replicate DLS measurements for B22kD or G22 assay are made from the same concentration of each of the StandardCurves or SerialDilutionCurves created from a given input sample.",
				Category->"Sample Dilution"
			},
			SampleAmount->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Microliter],
				Units->Microliter,
				Description->"The volume of the sample that is mixed with the Buffer to the Total Volume to create a desired concentration.",
				Category->"Sample Dilution"
			},
			TotalVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Microliter],
				Units->Microliter,
				Description->"The combined volume of the SampleAmount and Buffer that are mixed to create a desired concentration.",
				Category->"Sample Dilution"
			},
			TargetConcentrations->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0,1],
				Units->None,
				Description->"The Target Concentration is the desired final concentration of analyte after dilution of the input samples with the Buffer.",
				Category->"Sample Dilution"
			},
			TransferVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Microliter],
				Units->Microliter,
				Description->"The Transfer Volume is taken out of the sample and added to a second well with the Buffer Volume of the Buffer. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples.",
				Category->"Sample Dilution"
			},
			BufferVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Microliter],
				Units->Microliter,
				Description->"The volume of Buffer that is mixed with the TransferVolume.",
				Category->"Sample Dilution"
			},
			NumberOfDilutions->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0,1],
				Units->None,
				Description->"The number of times the Transfer Volume is diluted with the buffer to make diluted samples.",
				Category->"Sample Dilution"
			},
			DilutionFactors->{
				Format->Multiple,
				Class->Expression,
				Pattern:>{Alternatives[_Integer,_Real,_Rational]..}|{Null..}|Null,
				Description->"For each member of SamplesIn, the ratios of the volume of input sample to the sum of the input sample volume and diluent volume for each dilution.",
				Category->"Sample Dilution"
			},
			NumberOfSerialDilutions->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0,1],
				Units->None,
				Description->"The number of times the SampleAmount is mixed with the Buffer to obtain DilutionFactors.",
				Category->"Sample Dilution"
			},
			BufferLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Sample]|Model[Sample],
				Description->"For each member of SamplesIn, the sample that is used to dilute the sample to a concentration series.",
				Category->"Sample Dilution",
				Migration->SplitField
			},
			BufferString->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Relation->Null,
				Description->"For each member of SamplesIn, the sample that is used to dilute the sample to a concentration series.",
				Category->"Sample Dilution",
				Migration->SplitField
			},
			BufferExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ObjectP[Object[Sample],Model[Sample]],
				Relation->Null,
				Description->"For each member of SamplesIn, the sample that is used to dilute the sample to a concentration series.",
				Category->"Sample Dilution",
				Migration->SplitField
			},
			DilutionMixType->{
				Format->Multiple,
				Class->Expression,
				Pattern:>MixTypeP,
				Description->"The method used to mix the SampleLoadingPlate or AssayContainer used for dilution.",
				Category->"Sample Dilution"
			},
			DilutionMixVolume->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0 Microliter],
				Units->Microliter,
				Description->"For each member of SamplesIn, the volume that is pipetted up and down from the dilution to mix the sample with the Buffer to make the mixture homogeneous.",
				Category->"Sample Dilution"
			},
			DilutionNumberOfMixes->{
				Format->Multiple,
				Class->Integer,
				Pattern:>GreaterP[0,1],
				Description->"For each member of SamplesIn, the number of pipette out and in cycles that is used to mix the sample with the Buffer to make the DilutionCurve.",
				Category->"Sample Dilution"
			},
			DilutionMixRate->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterP[0*Microliter/Second],
				Units->Microliter/Second,
				Description->"For each member of SamplesIn, the speed at which the DilutionMixVolume is pipetted out of and into the dilution to mix the sample with the Diluent to make the DilutionCurve.",
				Category->"Sample Dilution"
			},
			DilutionMixInstrumentLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>Alternatives[
					Model[Instrument,Pipette],
					Object[Instrument,Pipette],
					Model[Instrument,Vortex],
					Object[Instrument,Vortex],
					Model[Instrument,Nutator],
					Object[Instrument,Nutator]
				],
				Relation->MixInstrumentModelP,
				Description->"The instrument used to mix the dilutions in the SampleLoadingPlate or AssayContainer used for dilution.",
				Category->"Sample Dilution",
				Migration->SplitField
			},
			DilutionMixInstrumentString->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Relation->Null,
				Description->"The instrument used to mix the dilutions in the SampleLoadingPlate or AssayContainer used for dilution.",
				Category->"Sample Dilution",
				Migration->SplitField
			},
			DilutionMixInstrumentExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ObjectP[
					Model[Instrument,Pipette],
					Object[Instrument,Pipette],
					Model[Instrument,Vortex],
					Object[Instrument,Vortex],
					Model[Instrument,Nutator],
					Object[Instrument,Nutator]
				],
				Relation->Null,
				Description->"The instrument used to mix the dilutions in the SampleLoadingPlate or AssayContainer used for dilution.",
				Category->"Sample Dilution",
				Migration->SplitField
			},
			BlankBufferLink->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Sample]|Model[Sample],
				Description->"For each member of SamplesIn, the sample that is used as a 0 mg/mL blank in ColloidalStability assays, to determine the diffusion coefficient at infinite dilution.",
				Category->"Sample Loading",
				Migration->SplitField
			},
			BlankBufferString->{
				Format->Multiple,
				Class->String,
				Pattern:>_String,
				Relation->Null,
				Description->"For each member of SamplesIn, the sample that is used as a 0 mg/mL blank in ColloidalStability assays, to determine the diffusion coefficient at infinite dilution.",
				Category->"Sample Loading",
				Migration->SplitField
			},
			BlankBufferExpression->{
				Format->Multiple,
				Class->Expression,
				Pattern:>ObjectP[Object[Sample],Model[Sample]],
				Relation->Null,
				Description->"For each member of SamplesIn, the sample that is used as a 0 mg/mL blank in ColloidalStability assays, to determine the diffusion coefficient at infinite dilution.",
				Category->"Sample Loading",
				Migration->SplitField
			},
			CalculateMolecularWeight->{
				Format->Single,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"When AssayFormFactor is Plate, determines if Static Light Scattering (SLS) is used to calculate weight-average molecular weight.",
				Category->"Colloidal Stability"
			},
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
			TemperatureRamping->{
				Format->Single,
				Class->Expression,
				Pattern:>Alternatives[Linear,Step],
				Description->"The type of temperature ramp. Linear temperature ramps increase temperature at a constant rate given by TemperatureRampRate. Step temperature ramps increase the temperature by TemperartureRampStep and holds the temperature constant for TemperatureRampStepTime before increasing the temperature again.",
				Category->"Melting Curve"
			},
			TemperatureRampRate->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterP[0*Celsius/Second],
				Units->(Celsius/Second),
				Description->"The absolute value of the rate at which the temperature is changed in the course of one heating/cooling cycle.",
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
				Pattern:>GreaterP[0],
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
				Class->Link,
				Pattern:>_Link,
				Relation->Model[StorageCondition],
				Description->"The conditions under which any leftover samples from the DilutionCurve or SerialDilutionCurve are stored in the SampleLoadingPlate after the samples are transferred to the AssayContainer(s).",
				Category->"Sample Storage"
			}
		}
	}
];