

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, MassSpectrometry], {
	Description->"Analytical data captured for determining molecular weight of compounds by by ionizing them and measuring their mass-to-charge ratio.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		AcquisitionMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AcquisitionModeP,
			Description -> "The type of acquisition used for generating this data. MS mode measures the masses of the intact analytes, whereas MSMS measures the masses of the analytes fragmented by collision-induced dissociation.",
			Category -> "General",
			Abstract -> True
		},
		IonSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonSourceP,
			Description -> "The type of ionization used to create gas phase ions from the molecules in the sample. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission. In matrix-assisted laser desorption/ionization (MALDI), the sample is embedded in a laser energy absorbing matrix which is then irradiated with a pulsed laser, ablating and desorbing the molecules with minimal fragmentation and creating gas phase ions from the analyte molecules in the sample.",
			Category -> "General",
			Abstract -> True
		},
		MassAnalyzer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassAnalyzerTypeP,
			Description -> "The type of the component of the mass spectrometer that performed separation of ions according to their mass-to-charge ratio.",
			Category -> "General",
			Abstract -> True
		},
		IonMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "Indicates if positively or negatively charged ions are generated and analyzed.",
			Category -> "General",
			Abstract -> True
		},
		MinMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The lowest value of the range of measured mass-to-charge ratio (m/z) of this mass spectrometry data.",
			Category -> "General",
			Abstract -> True
		},
		MaxMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The highest value of the range of measured mass-to-charge ratio (m/z) of this mass spectrometry data.",
			Category -> "General",
			Abstract -> True
		},
		MassSelections-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The selected mass-to-charge ratio (m/z) value of the first mass analyzer in mass selection mode (MS1, Quadrupole for both ESI-QQQ and ESI-QTOF).",
			Category -> "General",
			Abstract -> True
		},
		MassAnalysisStage -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Units -> None,
			Description -> "Product ion stage (MS^n) for this mass spectrometry data. For example, in the case of tandem mass spectrometry (n=2), the analysis is performed on precursor ions that have been fragmented once.",
			Category -> "General"
		},
		GridVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The voltage applied to a secondary plate above the MALDI plate in order to create a gradient such that ions with lower initial kinetic energies are accelerated faster than samples with higher kinetic energies which have drifted farther from the MALDI plate. A lower grid voltage is used for samples with a higher molecular weight.",
			Category -> "General"
		},
		LensVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The voltage applied to the electrostatic ion focusing lens located at the entrance of the mass analyser.",
			Category -> "General"
		},
		AccelerationVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kilo*Volt],
			Units -> Kilo Volt,
			Description -> "The voltage applied to the  MALDI plate in order to accelerate ions towards the detector. This voltage is increased to enhance the sensitivity or decreased to enhance the resolution.",
			Category -> "General"
		},
		LaserFrequency -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hertz],
			Units -> Hertz,
			Description -> "The shot frequency of the laser used for desorption/ionization.",
			Category -> "General",
			Abstract -> False
		},
		ShotsPerRaster -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The number of repeated shots between each raster movement within a well.",
			Category -> "General",
			Abstract -> False
		},
		NumberOfShots -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The number of times the mass spectrometer fired the laser to collect this mass spectrometry data.",
			Category -> "General",
			Abstract -> False
		},
		MinLaserPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Watt],
			Units -> Percent,
			Description -> "The minimum laser power used to collect this mass spectrometry data.",
			Category -> "General"
		},
		MaxLaserPower -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Watt],
			Units -> Percent,
			Description -> "The maximum laser power used to collect this mass spectrometry data.",
			Category -> "General"
		},
		DelayTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Nano*Second],
			Units -> Nano Second,
			Description -> "Delay between laser ablation and ion extraction accepted by the instrument.",
			Category -> "General",
			Abstract -> False
		},
		Gain -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "The signal amplification factor applied to the detector.",
			Category -> "General",
			Abstract->False
		},
		(* ESI *)
		(* ESI specific parameters *)
		ESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description -> "The absolute voltage applied to the tip of the stainless steel capillary in order to produce charged droplets. Adjust this voltage to maximize sensitivity. Most compounds are optimized between 0.5 and 3.2 kV in ESI positive ion mode and 0.5 and 2.6 in ESI negative ion mode, but can be altered according to sample type. For low flow applications, best sensitivity will be achieved with a relatively high value in ESI positive (e.g. 3.0 kV), for standard flow UPLC a value of 0.5 kV is typically best for maximum sensitivity.",
			Category -> "General"
		},
		DeclusteringVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description->"For ESI-QTOF, indicates the voltage between the ion block (the reduced-pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer). This voltage attracts charged ions from the capillary tip into the ion block leading into the mass spectrometer. For ESI-QQQ, this controls the voltage applied between the orifice (where ions enter the mass spectrometer) and the ion guide to prevent the ionized small particles from aggregating together.",
			Category -> "General"
		},
		StepwaveVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description -> "This is a unique option for ESI-QTOF. It indicates the voltage offset between the 1st and 2nd stage of the ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired.",
			Category -> "General"
		},
		IonGuideVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description -> "Maximum voltage that can be applied on the Ion guide to guides and focuses the ions through the high-pressure Ion guid region.",
			Category -> "Operating Limits"
		},
		SourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature setting of the source block. Heating the source block discourages condensation and decreases solvent clustering in the reduced vacuum region of the source. This temperature setting is flow rate and sample dependent. Typical values are between 60 to 120 Celsius. For thermally labile analytes, a lower temperature setting is recommended.",
			Category -> "General"
		},
		DesolvationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray. Similarly to DesolvationGasFlow, this setting is dependant on solvent flow rate and composition. A typical range is from 150 to 650 Celsius.",
			Category -> "General"
		},
		DesolvationGasFlow -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[(1*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "The nitrogen gas flow ejected around the ESI (electrospray ionization) capillary, used for solvent evaporation to produce single gas phase ions from the ion spray. This setting affects sensitivity and is usually adjusted according to InfusionFlowRates (the higher the flow rate, the higher the desolvation gas flow). Please refer to the documentation for details.",
			Category -> "General"
		},
		ConeGasFlow -> {
			Format -> Single,
			(* L/Hour for ESI-QTOF, PSI for ESI-QQQ *)
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[(0*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "The nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate on the source block, acting as a first gate between the sprayer and the reduced-pressure ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean.",
			Category -> "General"
		},

		(*Old Field*)
		CollisionVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "The voltage applied to the collision cell to generate collision energy and induce fragmentation in tandem mass spectrometry.",
			Category -> "General"
		},

		(* Tandem Mass Options *)

		FragmentMinMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The lowest value of the range of measured mass-to-charge ratio (m/z) of the first mass analyzer in mass scan mode (MS2, a Quadrupole analyzer for both ESI-QQQ and a Time-of-Flight analyzer ESI-QTOF).",
			Category -> "General",
			Abstract -> True
		},
		FragmentMaxMass -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The highest value of the range of measured mass-to-charge ratio (m/z) of the first mass analyzer in mass scan mode (MS2, a Quadrupole analyzer for both ESI-QQQ and a Time-of-Flight analyzer ESI-QTOF).",
			Category -> "General",
			Abstract -> True
		},
		FragmentMassSelections -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "The selected mass-to-charge ratio (m/z) value of the second mass analyzer in mass selection mode (MS2, a unique option for the second Quadruploe analyzer of ESI-QQQ).",
			Category -> "General",
			Abstract -> True
		},
		CollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description ->"The potential used in the collision cell to fragment the incoming ions,changing collision energy will change the fragmentation pattern of the incoming ion. High collision energy gives higher ion intensities but the mass patterns will also be more complex. Low collision energy gives simpler mass patterns with lower intensity.",
			Category -> "General"
		},
		DwellTimes->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millisecond],
			Units->Millisecond,
			Description->"If the sample will be scan in SelectedIonMonitoring mode or MultipleReactionMonitoring mode, the length of time for each mass selection or mass selection pairs.",
			Category -> "General"
		},
		CollisionCellExitVoltage -> {
 			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0*Volt],
			Units -> Volt,
			Description ->"Also known as the Collision Cell Exit Potential (CXP). This value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2). This potential is tuned to ensure successful ion acceleration out of collision cell and into MS2, and can be adjusted to reach the maximal signal intensity.",
			Category -> "General"
		},
		ScanMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassSpecScanModeP,
			Description -> "The mass scan mode for using in tandem mass analysis (ESI-QQQ).",
			Category -> "General"
		},

	(*Multiple Reaction Monitoring Assays Options, IndexMatched to Mass Pairs *)
		MultipleReactionMonitoringAssays->{
			Format->Multiple,
			Description ->"For each member of SamplesIn, in ESI-QQQ, that firstly targets the ion corresponding to the compound of interest with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).",
			Class->{
				MS1Mass->Expression,
				CollisionEnergy->Expression,
				MS2Mass->Expression,
				DwellTime->Expression
			},
			Pattern :> {
				MS1Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				CollisionEnergy-> {UnitsP[0*Volt]..}|Null,
				MS2Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				DwellTime->{GreaterP[0*Millisecond]..}|Null
			},
			Category -> "General"
		},

		(*MALDI Options*)
		Well -> {
			Format -> Single,
			Class -> String,
			Pattern :> WellP,
			Description -> "Well in the sample plate from which served as the source for the ionization.",
			Category -> "General"
		},
		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassSpectrometryDataTypeP,
			Description -> "Whether this mass spectrometry data was performed on a matrix, calibrant or analyte sample.",
			Category -> "Data Processing",
			Abstract -> True
		},
		Calibrant -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, MassSpectrometry][Analytes],
				Object[Data, MassSpectrometry][Matrix]
			],
			Description -> "Mass Spectrum of the calibrant used to calibrate the instrument prior to collect this data.",
			Category -> "Data Processing"
		},
		CalibrationStandardDeviation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "Standard deviation associated with the calibration used to generate this data.",
			Category -> "Data Processing"
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, MassSpectrometry][Calibrant],
				Object[Data, MassSpectrometry][Matrix]
			],
			Description -> "Mass spectra of analyte sample associated with this Matrix or Calibrant data.",
			Category -> "Data Processing"
		},
		Matrix -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, MassSpectrometry][Analytes],
				Object[Data, MassSpectrometry][Calibrant]
			],
			Description -> "Mass Spectrum of the matrix mixed with this analyte or calibrant when collecting this data.",
			Category -> "Data Processing"
		},
		MassSpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Gram/Mole,ArbitraryUnit}],
			Units -> {Gram/Mole, ArbitraryUnit},
			Description -> "Spectrum of observed mass-to-charge (m/z) ratio vs peak intensity for this analyte, calibrant, or matrix sample detected by the instrument. For ESI-MS infusion experiments, this is the summed signal from all UnintegratedMassSpectra acquired by the instrument over the course of RunDuration.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		IonAbundance3D -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern :> BigQuantityArrayP[{Minute, Gram/Mole, ArbitraryUnit}],
			Units -> {Minute, Gram/Mole, ArbitraryUnit},
			Description -> "The measured counts of intact ions at each m/z for each retention time point during the course of the experiment for the MassSpectrometry detector. Each entry is {Time, MS1 m/z, IonAbundance}.",
			Category -> "Experimental Results"
		},
		IonAbundance -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Minute, ArbitraryUnit}],
			Units -> {Minute, ArbitraryUnit},
			Description -> "The chromatogram of counts for a singular IonAbundanceMass m/z vs. time during the course of the experiment for the MassSpectrometry detector.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		UnintegratedMassSpectra -> {
			Format -> Multiple,
			Class -> {Real, BigQuantityArray},
			Pattern :> {GreaterEqualP[0*Second], BigQuantityArrayP[{Gram/Mole, ArbitraryUnit}]},
			Units -> {Minute, {Gram/Mole, ArbitraryUnit}},
			Description -> "Mass spectra of observed mass-to-charge ratio (m/z) vs. intensity during the course of the direct injection experiment.",
			Headers -> {"Time", "Mass Spectrum"},
			Category -> "Experimental Results"
		},
		(*Tandem Mass Spectroscopy Results *)
		ReactionMonitoringIntensity -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern:>BigQuantityArrayP[{Gram/Mole, Gram/Mole, ArbitraryUnit}],
			Units -> {Gram/Mole, Gram/Mole, ArbitraryUnit},
			Description -> "The total intensity of each ion selection (MS1 only) or reactions (MS1/MS2) monitored over time.",
			Category -> "Experimental Results"
		},
		(*ReactionMonitoringMassChromatogram3D->{
			Format -> Single,
			Class -> {Real,Real,BigQuantityArray},
			Pattern :> {Gram/Mole, Gram/Mole,BigQuantityArrayP[{Minute,ArbitraryUnit}]},
			Units -> {Gram/Mole, Gram/Mole,{Minute, ArbitraryUnit}},
			Headers -> {"MS1","MS2", "Mass Chromatogram"},
			Description -> "The measured counts of intensity changes of different MultipleReactionMonitoring Assays (MS1/MS2 mass pairs) during the course of the experiment for the MassSpectrometry detector. Each entry is {MS1 m/z, MS2 m/z (or Null),{Time,Intensity}}.",
			Category -> "Experimental Results"
		},*)
		ReactionMonitoringMassChromatogram->{
			Format ->Multiple,
			Class ->{Real,Real,BigQuantityArray},
			Pattern :>{GreaterEqualP[0*Gram/Mole],GreaterEqualP[0*Gram/Mole],BigQuantityArrayP[{Minute, ArbitraryUnit}]},
			Units -> {Gram/Mole, Gram/Mole, {Minute,ArbitraryUnit}},
			Description -> "The measured counts of intensity changes of different MultipleReactionMonitoring Assays (MS1/MS2 mass pairs) and Mass Selection Values (MS1 value only) during the course of the experiment for the MassSpectrometry detector. Each entry is {MS1 m/z, MS2 m/z, {Time,Intensity}}.",
			Headers -> {"Mass Selection","Fragment Mass Selection", "Mass Chromatogram"},
			Category -> "Experimental Results"
		},
		IonMonitoringIntensity -> {
			Format -> Single,
			Class -> BigQuantityArray,
			Pattern:>BigQuantityArrayP[{Gram/Mole,ArbitraryUnit}],
			Units -> {Gram/Mole, ArbitraryUnit},
			Description -> "The total intensity of each ion selection (MS1 value) in SelectedIonMonitoring mode, monitored over time.",
			Category -> "Experimental Results"
		},
		IonMonitoringMassChromatogram->{
			Format ->Multiple,
			Class ->{Real,BigQuantityArray},
			Pattern :>{GreaterEqualP[0*Gram/Mole],BigQuantityArrayP[{Minute, ArbitraryUnit}]},
			Units -> {Gram/Mole, {Minute,ArbitraryUnit}},
			Description -> "The measured counts of intensity changes of different Mass Selection Values (MS1 value only) during the course of the experiment for the MassSpectrometry detector. Each entry is {MS1 m/z, {Time,Intensity}}.",
			Headers -> {"Mass Selection","Mass Chromatogram"},
			Category -> "Experimental Results"
		},
		NeutralLossMass->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"The mass offset between MS1 and MS2 in the NeutralIonLoss scan mode.",
			Category -> "Experimental Results"
		},
		ProductionIonMass->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"The fixed mass value for the production ion (value for MS1 in mass selection mode) in ProductionIonScan mode.",
			Category -> "Experimental Results"
		},
      	PrecursorIonMass->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"The fixed mass value for the precursor ion (value for MS2 in mass selection mode) in PrecursorIonScan mode.",
			Category -> "Experimental Results"
		},
		(*Analysis Part*)
		MassSpectrumPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak picking analysis conducted on this spectra.",
			Category -> "Analysis & Reports"
		},
		SmoothingAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Smoothing analysis performed on this data.",
			Category -> "Analysis & Reports"
		},
		MethodFiles -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The method files used to conduct this mass spectrometry measurement for this sample zipped into one directory.",
			Category -> "General"
		},
		RawDataFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing all raw data pertaining to the mass spectrometry measurement of this sample zipped into one directory.",
			Category -> "Experimental Results"
		},
		MzMLFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The data stored in the MassSpectrum field, in mzML format.",
			Category -> "Experimental Results"
		}
	}
}];
