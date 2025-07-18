(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Total Protein Quantification*)


(* ::Subsubsection::Closed:: *)
(*ExperimentTotalProteinQuantification*)


DefineOptions[ExperimentTotalProteinQuantification,
	Options:>{
		{
			OptionName->AssayType,
			Default->Automatic,
			Description->"The style of protein quantification assay that is run in this experiment. The Bradford assay is an absorbance-based assay that relates changes in Coomassie Brilliant Blue G-250 absorbance at the QuantificationWavelength to protein concentration. The BCA (Smith bicinchoninic acid) assay is an absorbance-based assay which relates changes in the absorbance of a copper-BCA complex at the QuantificationWavelength to protein concentration. The FluorescenceQuantification assay relates increase in fluorescence of the QuantificationReagent at the QuantificationWavelength to protein concentration. For more information about compatible reagents and troubleshooting of the three default assays, please see Object[Report,Literature,\"Quick Start Bradford Protein Assay Instruction Manual\"], Object[Report,Literature,\"Pierce BCA Protein Assay Kit Instructions\"], and Object[Report, Literature, \"Quant-iT Protein Assay Kit User Guide\"].",
			ResolutionDescription->"The AssayType is set to be Bradford if specified QuantificationReagent is or has a Model of Model[Sample, \"Quick Start Bradford 1x Dye Reagent\"], to be BCA if the QuantificationReagent is or has a Model of Model[Sample,StockSolution,\"Pierce BCA Protein Assay Quantification Reagent\"], to be FluorescenceQuantification if the QuantificationReagent is or has a Model of Model[Sample,StockSolution,\"Quant-iT Protein Assay Quantification Reagent\"], or to be Custom if the QuantificationReagent is of another Model or is an Object with no Model. If the QuantificationReagent is not specified, the AssayType is set to be Bradford if the DetectionMode is or resolves to Absorbance, or to FluorescenceQuantification if the DetectionMode is or resolves to Fluorescence.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>ProteinQuantificationAssayTypeP
			]
		},
		{
			OptionName->DetectionMode,
			Default->Automatic,
			Description->"The physical phenomenon that is observed as the source of the signal for protein quantification in this experiment.",
			ResolutionDescription->"The DetectionMode is set to be Fluorescence if the AssayType is specified as FluorescenceQuantification or the ExcitationWavelength or Emission-related Options are set. Otherwise, the DetectionMode is set to be Absorbance.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>ProteinQuantificationDetectionModeP
			]
		},
		{
			OptionName->Instrument,
			Default->Automatic,
			Description->"The plate reader that is used to measure the absorbance or fluorescence of the mixture of QuantificationReagent and either the input samples or ProteinStandards (or diluted ConcentratedProteinStandard) present in the QuantificationPlate.",
			ResolutionDescription->"The Instrument is set to be Model[Instrument, PlateReader, \"FLUOstar Omega\"] if DetectionMode is Absorbance, or to be Model[Instrument,PlateReader,\"CLARIOstar\"] if DetectionMode is Fluorescence.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument, PlateReader], Object[Instrument, PlateReader]}]
			]
		},
		{
			OptionName->NumberOfReplicates,
			Default->Null,
			Description-> "The number of wells of the QuantificationPlate in which each sample is mixed with the QuantificationReagent. The protein concentration of the input sample is determined by the average absorbance or fluorescence value of the replicate samples. When the Aliquot and NumberOfReplicates options are both set, one Aliquot is performed on each input sample, and the SampleVolume is transferred from each AliquotSample into NumberOfReplicates wells of the QuantificationPlate.",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterEqualP[2,1]
			]
		},
		IndexMatching[
			IndexMatchingParent->ProteinStandards,
			{
				OptionName->ProteinStandards,
				Default->Automatic,
				Description->"The solutions of standard protein that are mixed with the QuantificationReagent to create the standard curve. The standard concentration curve plotting Absorbance or Fluorescence versus mass concentration is used to determine the protein concentration of the input samples. If specified, the ConcentratedProteinStandard, StandardCurveConcentrations, and ProteinStandardDiluent options must not be specified.",
				ResolutionDescription->"If any of the ConcentratedProteinStandard, StandardCurveConcentrations or ProteinStandardDiluent options are specified, the ProteinStandards is set to Null. If the DetectionMode is Fluorescence, the ProteinStandards is set to be {Model[Sample,\"25 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit\"],Model[Sample,\"50 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit\"],Model[Sample,\"100 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit\"],Model[Sample,\"200 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit\"],Model[Sample,\"300 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit\"],Model[Sample,\"400 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit\"],Model[Sample,\"500 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit\"]}. If the DetectionMode is Absorbance, the ProteinStandards is set to be {Model[Sample,\"0.125 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set\"],Model[Sample,\"0.25 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set\"],Model[Sample,\"0.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set\"],Model[Sample,\"0.75 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set\"],Model[Sample,\"1 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set\"],Model[Sample,\"1.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set\"],Model[Sample,\"2 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set\"]}.",
				AllowNull->True,
				Category->"Standard Curve",
				Widget->Widget[
						Type->Object,
						Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
				]
			},
			{
				OptionName->ProteinStandardsStorageCondition,
				Default->Null,
				Description->"The non-default condition under which the ProteinStandards of this experiment should be stored. By default, ProteinStandard will be stored according to their current StorageCondition.",
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
				Category->"Post Experiment"
			}
		],
		{
			OptionName->ConcentratedProteinStandard,
			Default->Automatic,
			Description->"The concentrated solution of standard protein that is diluted with the ProteinStandardDiluent to the StandardCurveConcentrations to create the standard curve. If ConcentratedProteinStandard is specified, the ProteinStandards option must not be specified.",
			ResolutionDescription->"If the ProteinStandards option is specified, the ConcentratedProteinStandard is set to be Null. Otherwise, it is set to be Model[Sample,\"2 mg/mL Bovine Serum Albumin Standard\"].",
			AllowNull->True,
			Category->"Standard Curve",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			]
		},
		{
			OptionName->ConcentratedProteinStandardStorageCondition,
			Default->Null,
			Description->"The non-default condition under which the ConcentratedProteinStandard of this experiment should be stored. By default, ConcentratedProteinStandard will be stored according to their current StorageCondition.",
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>SampleStorageTypeP|Disposal],
			Category->"Post Experiment"
		},
		{
			OptionName->StandardCurveConcentrations,
			Default->Automatic,
			Description->"The mass concentrations that the ConcentratedProteinStandard is diluted to with the ProteinStandardDiluent to create the standard curve. The standard concentration curve plotting Absorbance or Fluorescence versus mass concentration is used to determine the protein concentration of the input samples. If StandardCurveConcentrations is specified, the ProteinStandards option must not be specified.",
			ResolutionDescription->"If the ProteinStandards option is specified, the StandardCurveConcentrations is set to be Null. The option is set to be {0.025 mg/mL,0.05 mg/mL,0.1 mg/mL,0.2 mg/mL,0.3 mg/mL,0.4 mg/mL,0.5 mg/mL} if the DetectionMode is Fluorescence and to {0.125 mg/mL,0.25 mg/mL,0.5 mg/mL,0.75 mg/mL,1 mg/mL,1.5 mg/mL,2 mg/mL} otherwise.",
			AllowNull->True,
			Category->"Standard Curve",
			Widget-> Adder[
				Widget[
					Type->Quantity,
					Pattern:>RangeP[0.001*Milligram/Milliliter,2*Milligram/Milliliter],
					Units->CompoundUnit[
						{1,{Milligram,{Milligram}}},
						{-1,{Milliliter,{Milliliter}}}
					]
				]
			]
		},
		{
			OptionName->ProteinStandardDiluent,
			Default->Automatic,
			Description->"The sample that is used to dilute the ConcentratedProteinStandard to the StandardCurveConcentrations. If ProteinStandardDiluent is specified, the ProteinStandards option must not be specified.",
			ResolutionDescription->"If the ProteinStandards option is specified, the ProteinStandardDiluent is set to be Null. Otherwise, it is set to be Model[Sample, \"Milli-Q water\"].",
			AllowNull->True,
			Category->"Standard Curve",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			]
		},
		{
			OptionName->StandardCurveBlank,
			Default->Automatic,
			Description->"The sample that is used for the required 0 mg/mL point on the standard curve.",
			ResolutionDescription->"The StandardCurveBlank is set to be the ProteinStandardDiluent if the ProteinStandardDiluent, ConcentratedProteinStandard, or StandardCurveConcentrations options are specified, to Model[Sample, \"Milli-Q water\"] if none of these three options are specified and the DetectionMode is Absorbance, or to Model[Sample,\"0 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit\"] if none of these three options are specified and the DetectionMode is Fluorescence.",
			AllowNull->False,
			Category->"Standard Curve",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			]
		},
		{
			OptionName->StandardCurveReplicates,
			Default->2,
			Description->"The number of wells to add each concentration of ProteinStandards (or diluted ConcentratedProteinStandard) to in the QuantificationPlate. The standard curve is calculated by averaging the absorbance or fluorescence values of the protein standards at each concentration and plotting that average value versus the MassConcentration.",
			AllowNull->False,
			Category->"Standard Curve",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,20,1]
			]
		},
		{
			OptionName->LoadingVolume,
			Default->Automatic,
			Description->"The amount of each input sample, ProteinStandard, or diluted ConcentratedProteinStandard that is mixed with the QuantificationReagent in the QuantificationPlate before the absorbance or fluorescence of the mixture at the QuantificationWavelength is determined.",
			ResolutionDescription-> "The LoadingVolume is set to 10 uL if the DetectionMode is Fluorescence, 25 uL if the AssayType is BCA, or 5 uL is the AssayType is Bradford or Null.",
			AllowNull->False,
			Category->"Quantification",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5*Microliter,150*Microliter],
				Units:>Microliter
			]
		},
		{
			OptionName->QuantificationReagent,
			Default->Automatic,
			Description->"The sample that is added to the input samples and ProteinStandards or dilutions of the ConcentratedProteinStandard in the QuantificationPlate. The QuantificationReagent undergoes a change in absorbance and/or fluorescence in the presence of proteins. This change in absorbance or fluorescence is used to quantify the amount of protein present in the input samples and ProteinStandards.",
			ResolutionDescription->"The QuantificationReagent is set to the Quant-iT stock solution if DetectionMode is Fluorescence, to Model[Sample,\"Quick Start Bradford 1x Dye Reagent\"] if AssayType is Bradford or Null, and to BCA reagent stock solution if AssayType is BCA.",
			AllowNull->False,
			Category->"Quantification",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			]
		},
		{
			OptionName->QuantificationReagentVolume,
			Default->Automatic,
			Description->"The amount of the QuantificationReagent that is added to each appropriate well of the QuantificationPlate. The QuantificationReagent is mixed with either the input samples or the ProteinStandards (or the diluted ConcentratedProteinStandard).",
			ResolutionDescription-> "The QuantificationReagentVolume is automatically set to 200 uL if the DetectionMode is Fluorescence or the AssayType is BCA, or 250 uL if the AssayType is Bradford or Null." ,
			AllowNull->False,
			Category->"Quantification",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0.5*Microliter,299*Microliter],
				Units:>Microliter
			]
		},
		{
			OptionName->QuantificationReactionTime,
			Default->Automatic,
			Description->"The duration which the mixtures of QuantificationReagent and input samples or ProteinStandards (or diluted ConcentratedProteinStandard) are heated to QuantificationReactionTemperature on a heat block before the absorbance or fluorescence of the mixture is measured.",
			ResolutionDescription->"The QuantificationReactionTime is set to 1 hour if the AssayType is BCA, to 5 minutes if the AssayType is not BCA but the QuantificationReactionTemperature is specified, and to Null otherwise.",
			AllowNull->True,
			Category->"Quantification",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[1*Minute,180*Minute],
				Units:>Minute
			]
		},
		{
			OptionName->QuantificationReactionTemperature,
			Default->Automatic,
			Description->"The temperature which the mixtures of QuantificationReagent and input samples or ProteinStandards (or diluted ConcentratedProteinStandard) are heated to on a heat block before the absorbance or fluorescence of the mixture is measured.",
			ResolutionDescription->"The QuantificationReactionTemperature is set to 25 Celsius if the QuantificationReactionTime has been set or has resolved to a non-Null value, and to Null otherwise.",
			AllowNull->True,
			Category->"Quantification",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[$AmbientTemperature,60*Celsius],
				Units:>{1,{Celsius,{Fahrenheit,Celsius}}}
			]
		},
		{
			OptionName -> ExcitationWavelength,
			Default -> Automatic,
			Description ->"The wavelength of light at which the protein-bound QuantificationReagent is excited when DetectionMode is set to Fluorescence.",
			ResolutionDescription ->"The ExcitationWavelength is set to be Null if the DetectionMode is Absorbance, or to 470 nm otherwise.",
			AllowNull -> True,
			Category -> "Quantification",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[320*Nanometer, 740*Nanometer],
				Units :> Nanometer
			]
		},
		{
			OptionName->QuantificationWavelength,
			Default->Automatic,
			Description->"The wavelength(s) at which quantification analysis is performed to determine concentration. If multiple wavelengths are specified, the absorbance or fluorescence values from the wavelengths are averaged for standard curve determination and quantification analysis.",
			ResolutionDescription->"The QuantificationWavelength is set to be 570 nm if the DetectionMode is Fluorescence, to 595 nm if AssayType is Bradford or Null, and to 562 nm otherwise.",
			AllowNull->False,
			Category->"Quantification",
			Widget->Alternatives[
				"Single"-> Widget[
					Type -> Quantity,
					Pattern :> RangeP[320*Nanometer,1000*Nanometer],
					Units:>Nanometer
				],
				"Multiple"->Adder[
					Widget[
						Type ->Quantity,
						Pattern :> RangeP[320*Nanometer,1000*Nanometer],
						Units:>Nanometer
					]
				],
				"Range"->Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[320*Nanometer, 1000*Nanometer, 1*Nanometer],
						Units -> Nanometer
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[320*Nanometer, 1000*Nanometer, 1*Nanometer],
						Units -> Nanometer
					]
				]
			]
		},
		{
			OptionName->QuantificationTemperature,
			Default->Ambient,
			Description->"The temperature of the sample chamber during the absorbance or fluorescence spectra measurement.",
			AllowNull->False,
			Category->"Quantification",
			Widget->Alternatives[
				Widget[
					Type->Quantity,
					Pattern:>RangeP[$AmbientTemperature,45 Celsius],
					Units:>{1,{Celsius,{Celsius,Fahrenheit}}}
				],
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Ambient]
				]
			]
		},
		{
			OptionName->QuantificationEquilibrationTime,
			Default->0*Second,
			Description->"The length of time for which the QuantificationPlate equilibrates at the QuantificationTemperature in the plate reader before being read.",
			AllowNull->False,
			Category->"Quantification",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Minute,1 Hour],
				Units:>{1,{Minute,{Second,Minute,Hour}}}
			]
		},
		{
			OptionName->NumberOfEmissionReadings,
			Default->Automatic,
			Description->"The number of redundant readings which should be taken by the detector to determine a single averaged fluorescence intensity reading for each wavelength.",
			ResolutionDescription->"The NumberOfEmissionReadings is set to be Null if the DetectionMode is Absorbance. If the DetectionMode is Fluorescence, the NumberOfEmissionReadings is set to be 100.",
			AllowNull->True,
			Category->"Quantification",
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[1,200,1]
			]
		},
		{
			OptionName->EmissionAdjustmentSample,
			Default->Automatic,
			Description->"The sample which should be used to perform automatic adjustments of gain and/or focal height values at run time. The focal height will be set so that the highest signal-to-noise ratio can be achieved for the EmissionAdjustmentSample. The gain will be set such that the EmissionAdjustmentSample fluoresces at the specified percentage of the instrument's dynamic range. When multiple aliquots of the same sample is used in the experiment, an index can be specified to use the desired aliquot for adjustments.",
			ResolutionDescription->"The EmissionAdjustmentSample is set to be Null if the DetectionMode is Absorbance. If the DetectionMode is Fluorescence and the Instrument is set to Model[Instrument,PlateReader,\"CLARIOstar\"], EmissionAdjustmentSample is set to FullPlate. Otherwise, EmissionAdjustmentSample is set to HighestConcentration, which refers to the sample with the highest concentration reflected in StandardCurveConcentrations or in ProteinStandards.",
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object, Pattern:>ObjectP[Object[Sample]]],
				{
					"Index"->Widget[Type->Number, Pattern:>RangeP[1, 384, 1]],
					"Sample"->Widget[Type->Object, Pattern:>ObjectP[Object[Sample]]]
				},
				Widget[Type->Enumeration, Pattern:>Alternatives[FullPlate, HighestConcentration]]
			]
		},
		{
			OptionName->EmissionReadLocation,
			Default->Automatic,
			Description->"Indicates if fluorescence is measured using an optic above the plate or one below the plate.",
			ResolutionDescription->"The EmissionReadLocation is set to be Null if the DetectionMode is Absorbance. If the DetectionMode is Fluorescence, the EmissionReadLocation is set to be Top.",
			AllowNull->True,
			Category->"Quantification",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>ReadLocationP
			]
		},
		{
			OptionName->EmissionGain,
			Default->Automatic,
			AllowNull->True,
			Description->"The gain which is applied to the signal reaching the primary detector during the emission scan when DetectionMode is Fluorescence, measured as a percentage of the strongest signal in the QuantificationPlate.",
			ResolutionDescription->"The EmissionGain is set to be Null if the DetectionMode is Absorbance. If the DetectionMode is Fluorescence, the EmissionGain is set to be 90%.",
			Category->"Quantification",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Percent,95*Percent],
				Units:>Percent
			]
		},
		ModelInputOptions,
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SubprotocolDescriptionOption,
		SimulationOption
	}
];



(* ::Subsubsection::Closed:: *)
(* - Messages - *)
(* Messages thrown before the option resolution *)


Error::TooManyTotalProteinQuantificationInputs="The maximum number of input samples for one protocol is 80. Please enter fewer input samples, or queue an additional experiment for the excess input samples.";
Error::InvalidTotalProteinQuantificationStandardCurveOptions="The specified ProteinStandards, ConcentratedProteinStandard, StandardCurveConcentrations, and ProteinStandardDiluent options, set to `1`, `2`, `3`, and `4`, respectively, are in conflict. If ProteinStandards is specified, none of ConcentratedProteinStandard, StandardCurveConcentrations, or ProteinStandardDiluent can be specified. If ProteinStandards is Null, none of the other three options can be Null. If either ConcentratedProteinStandard, StandardCurveConcentrations, or ProteinStandardDiluent is specified, none of the other two options can be Null. Please make sure these option are not in conflict, or consider allowing these options to automatically resolve.";
Error::TotalProteinQuantificationAssayTypeDetectionModeMismatch="The AssayType, (`1`), and specified DetectionMode, (`2`), options are in conflict. If AssayType is BCA or Bradford, DetectionMode cannot be Fluorescence. If AssayType is FluorescenceQuantification, DetectionMode cannot be Absorbance. Please ensure that these options are not in conflict.";
Error::TotalProteinQuantificationAbsorbanceFluorescenceOptionsMismatch="The following options, `1`, are in conflict. If the AssayType is Bradford or BCA, or the DetectionMode is Absorbance, neither ExcitationWavelength nor NumberOfEmissionReadings nor EmissionReadLocation nor EmissionGain can be specified. Please ensure that these options are not in conflict, or consider letting the options automatically resolve.";
Error::TotalProteinQuantificationFluorescenceOptionsMismatch="The following options, `1`, are in conflict. If the AssayType is FluorescenceQuantification or the DetectionMode is Fluorescence, neither ExcitationWavelength nor NumberOfEmissionReadings nor EmissionReadLocation nor EmissionGain can be Null. Please ensure that these options are not in conflict, or consider letting the options automatically resolve.";
Error::TotalProteinQuantificationNullFluorescenceOptionsMismatch="The following options, `1`, are in conflict. If any of ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain are Null, none of the others can be specified. Please ensure that these options are not in conflict, or consider letting the options automatically resolve.";
Warning::TotalProteinQuantificationReagentNotOptimal="The specified QuantificationReagent, `1`,is not the default QuantificationReagent Model for the AssayType, `2`. Please ensure that this is desired. If it is not, consider letting the QuantificationReagent option automatically resolve.";
Error::TotalProteinQuantificationInvalidQuantificationWavelengthSpan="The specified QuantificationWavelength Span, `1`, is invalid. The first element of the Span must be smaller than the last element. Please ensure that the option is properly specified.";
Error::TotalProteinQuantificationInvalidQuantificationWavelengthList="The specified QuantificationWavelength List, `1`, is invalid. When specified as a list, the QuantificationWavelength cannot contain any repeated values. Please remove any duplicate values from the list, or consider letting this option automatically resolve.";
Error::TotalProteinQuantificationWavelengthMismatch="The specified ExcitationWavelength and QuantificationWavelength options, `1` and `2`, are in conflict. The smallest member of QuantificationWavelength must be at least 25 nm larger than the ExcitationWavelength. Please ensure that these options are not in conflict, or consider letting the options automatically resolve.";
Warning::TotalProteinQuantificationDuplicateProteinStandards="The specified ProteinStandards, `1`, has duplicate entries. Duplicate members of ProteinStandards will result in more absorbance or fluorescence data points in the StandardCurve for the associated protein concentration than the other protein concentrations. Please ensure that this duplicate entry is desired.";
Error::TotalProteinQuantificationInvalidVolumes="The specified LoadingVolume and QuantificationReagentVolume options, `1` and `2`, are in conflict. The sum of these two options cannot be larger than 300 uL. Please ensure that these options are not in conflict, or consider letting the options automatically resolve.";
Warning::TotalProteinQuantificationTotalVolumeLow="The sum of the LoadingVolume, `1`, and QuantificationReagentVolume, `2`, is less than 60 uL. Absorbance or Fluorescence values from such a low volume might not be accurate. Please consider increasing these volumes, or letting these options automatically resolve.";
Warning::TotalProteinQuantificationMultipleProteinStandardIdentityModels="The specified ProteinStandards, `1`, do not all have the same Model[Molecule,Protein]s in their Composition fields. The lists of Model[Molecule,Protein]s present in each ProteinStandard are `2`. The StandardCurve generated from these ProteinStandards may not be able to accurately quantify the concentration of proteins in the input samples. Please ensure that the ProteinStandards option has been specified correctly, or consider letting the option resolve automatically.";
Error::TotalProteinQuantificationUnsupportedInstrument="The specified Instrument Option, `1`, is of Model `2`. The supported Instrument Models are Model[Instrument, PlateReader, \"id:mnk9jO3qDzpY\"] (FLUOstar Omega) and Model[Instrument, PlateReader, \"id:E8zoYvNkmwKw\"] (CLARIOstar). Please pick an Instrument of one of these Models, or consider letting the Instrument option automatically resolve.";
Error::TotalProteinQuantificationInstrumentOptionMismatch="The following options, `1`, are in conflict. If the specified Instrument is of Model Model[Instrument, PlateReader, \"CLARIOstar\"], the AssayType cannot be BCA or Bradford, and the DetectionMode cannot be Absorbance. If the supplied Instrument is of Model Model[Instrument, PlateReader, \"FLUOstar Omega\"], the AssayType cannot be FluorescenceQuantification, and the DetectionMode cannot be Fluorescence. Please ensure these options are not in conflict, or consider letting the Instrument option resolve automatically.";
Error::TotalProteinQuantificationInstrumentFluoresceneceOptionsMisMatch="The following options, `1`, are in conflict. If the specified Instrument is of Model Model[Instrument, PlateReader, \"CLARIOstar\"], none of the ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain options can be Null. If the supplied Instrument is of Model Model[Instrument, PlateReader, \"FLUOstar Omega\"], none of the ExcitationWavelength, NumberOfEmissionReadings, EmissionReadLocation, or EmissionGain options can be specified. Please ensure these options are not in conflict, or consider letting the Instrument option resolve automatically.";
Error::TotalProteinQuantificationReactionOptionsMisMatch="The QuantificationReactionTime, `1` and QuantificationReactionTemperature, `2`, are in conflict. If one option is Null, the other must not be specified. Please ensure that the options are not in conflict, or consider letting the options automatically resolve.";
Error::TotalProteinQuantificationConcentratedProteinStandardInvalid="The specified ConcentratedProteinStandard, `1`, does not have its MassConcentration (in the Composition field) informed if it is a Model, or either TotalProteinConcentration or MassConcentration (in the Composition field) informed if it is an Object. Please select another ConcentratedProtienStandard, or consider letting the standard curve-related options automatically resolve.";
Error::TotalProteinQuantificationNullProteinStandardConcentration="The following members of ProteinStandards, `1`, do not have  MassConcentration (in the Composition field) informed if they are Models, or either TotalProteinConcentration or  MassConcentration (in the Composition field) informed if they are Objects. Please select ProteinStandards with these fields informed, or consider letting the option automatically resolve.";
Error::TotalProteinQuantificationCustomAssayTypeInvalid="If the AssayType has been specified as Custom, the QuantificationReagent option must be set. Please specify a QuantificationReagent, or consider letting these two options resolve automatically.";
(* Messages thrown during option resolution *)
Warning::TotalProteinQuantificationLoadingVolumeLow="The LoadingVolume has been automatically set to `1`, which is lower than `2`, the ideal volume for the DetectionMode (`3`) and AssayType (`4`) options. This is because the QuantificationReagentVolume was set to `5`, and the sum of the LoadingVolume and QuantificationReagentVolume cannot be larger than 300 uL. Please consider setting the QuantificationReagentVolume lower, or letting the option resolve automatically.";
Warning::TotalProteinQuantificationQuantificationReagentVolumeLow="The QuantificationReagentVolume has been automatically set to `1`, which is lower than `2`, the ideal volume for the Detection Mode (`3`) and AssayType (`4`). This is because the LoadingVolume was set to `5`, and the sum of the LoadingVolume and QuantificationReagentVolume cannot be larger than 300 uL. Please consider setting the LoadingVolume lower, or letting both options resolve automatically.";

(* Messages thrown after option resolution *)
Error::NotEnoughTotalProteinQuantificationWellsAvailable="There are not enough wells in the QuantificationPlate to run the experiment. The maximum number of wells is 96, but the number of input samples, `1`, times the NumberOfReplicates, `2`, plus the (length of `3`, `4`, plus 1) times the StandardCurveReplicates, `5`, is `6`. Please consider reducing the number of input samples, the NumberOfReplicates option, or the StandardCurveReplicates option.";
Error::InvalidTotalProteinConcentratedProteinStandardOptions="The ConcentratedProteinStandard, `1`, has an TotalProteinConcentration, or  MassConcentration (in the Composition field) of `2`. The following members of StandardCurveConcentrations, `3`, are larger than this value - and thus the ConcentratedProteinStandard cannot be diluted to these concentrations. Please consider changing the ConcentratedProteinStandard or StandardCurveConcentrations, or allowing these options to resolve automatically.";
Error::TotalProteinStandardCurveConcentrationsTooLow="The ConcentratedProteinStandard, `1`, has an InitialMassConcentration, TotalProteinConcentration, or MassConcentration of `2`. The following members of StandardCurveConcentrations, `3`, are are smaller than this value divided by 400 - the ConcentratedProteinStandard cannot be diluted to these concentrations, because the total dilution volume is 200 uL and the smallest possible amount of ConcentratedProteinStandard to use is 0.5 uL. Please consider changing the ConcentratedProteinStandard or StandardCurveConcentrations, or allowing these options to resolve automatically.";
Error::InvalidTotalProteinResolvedExcitationWavelength="The lowest member of the QuantificationWavelength option, `1`, is less than 25 nm larger than the ExcitationWavelength, `2`. No member of the QuantificationWavelength option can be less than 25 nm larger than the ExcitationWavelength. Please set the QuantificationWavelength to a larger value.";
Error::InvalidTotalProteinFluorescenceQuantificationWavelength="The DetectionMode option was set to or has resolved to Fluorescence and the largest member of the QuantificationWavelength option, `1`, is larger than 740 nm. For Fluorescence assays, the largest QuantificationWavelength possible is 740 nm. Please set the QuantificationWavelength option to a shorter wavelength.";
Warning::NonDefaultTotalProteinQuantificationReaction="The QuantificationReactionTime, `1`, and QuantificationReactionTemperature, `2`, have been specified, but the AssayType, `3`, is not BCA. Bradford and FluorescenceQuantification assays should have the absorbance or fluorescence values read shortly after mixing the samples and the QuantificationReagent. Please double-check that these options have been specified correctly.";
Error::ConflictingStandardsStorageCondition = "The `1` cannot be specified when `2` is Null. Please specify the correct standard and storage options.";

(* ::Subsubsection::Closed:: *)
(* ExperimentTotalProteinQuantification Source Code *)


(* - Container to Sample Overload - *)

ExperimentTotalProteinQuantification[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample], Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples,updatedSimulation, containerToSampleSimulation,
		containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,containerToSampleTests},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
	(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentTotalProteinQuantification,
			ToList[myContainers],
			ToList[myOptions]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests, containerToSampleSimulation}=containerToSampleOptions[
			ExperimentTotalProteinQuantification,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation->updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation}=containerToSampleOptions[
				ExperimentTotalProteinQuantification,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result, Simulation},
				Simulation->updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentTotalProteinQuantification[samples,ReplaceRule[sampleOptions,Simulation -> containerToSampleSimulation]]
	]
];

(* -- Main Overload --*)
ExperimentTotalProteinQuantification[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,messages,listedSamples,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed,
		safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,totalProteinQuantificationOptionsAssociation,

		suppliedInstrument,suppliedProteinStandards,suppliedConcentratedProteinStandard,suppliedQuantificationReagent,instrumentDownloadOption,instrumentDownloadFields,
		concentratedProteinStandardDownloadOption,concentratedProteinStandardDownloadFields,uniqueProteinStandardObjects,uniqueProteinStandardModels,
		uniqueProteinStandardObjectDownloadFields,uniqueProteinStandardModelDownloadFields,quantificationReagentDownloadOption,quantificationReagentDownloadFields,
		objectSamplePacketFields,modelSamplePacketFields,objectContainerFields,modelContainerFields,modelContainerPacketFields,liquidHandlerContainers,

		listedSampleContainerPackets,instrumentPacket,concentratedProteinStandardPacket,listedProteinStandardObjectPackets,listedProteinStandardModelPackets,quantificationReagentPacket,
		inputsInOrder,liquidHandlerContainerPackets,

		cacheBall,inputObjects,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resourcePackets,resourcePacketTests,
		protocolObject, updatedSimulation, cache
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* Remove temporal links and named objects. *)
	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentTotalProteinQuantification,
			listedSamples,
			ToList[listedOptions]
		],
		$Failed,
	 	{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPacketsNew. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentTotalProteinQuantification,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentTotalProteinQuantification,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentTotalProteinQuantification,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentTotalProteinQuantification,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentTotalProteinQuantification,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples],Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentTotalProteinQuantification,{ToList[mySamplesWithPreparedSamples]},ToList[myOptionsWithPreparedSamples]],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentTotalProteinQuantification,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Turn the expanded safe ops into an association so we can lookup information from it*)
	totalProteinQuantificationOptionsAssociation=Association[expandedSafeOps];

	(* Pull the info out of the options that we need to download from *)
	{
		suppliedInstrument,suppliedProteinStandards,suppliedConcentratedProteinStandard,suppliedQuantificationReagent
	}=Lookup[totalProteinQuantificationOptionsAssociation,
		{
			Instrument,ProteinStandards,ConcentratedProteinStandard,QuantificationReagent
		}
	];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	(* - Instrument - *)
	instrumentDownloadOption=If[
		(* Only downloading from the instrument option if it is not Automatic *)
		MatchQ[suppliedInstrument,Automatic],
		Nothing,
		suppliedInstrument
	];

	instrumentDownloadFields=Which[
		(* If instrument left as automatic, don't download anything *)
		MatchQ[suppliedInstrument,Automatic],
			Nothing,

		(* If instrument is an object, download fields from the Model *)
		MatchQ[suppliedInstrument,ObjectP[Object[Instrument]]],
			Packet[Model[{Object,WettedMaterials}]],

		(* If instrument is a Model, download fields*)
		MatchQ[suppliedInstrument,ObjectP[Model[Instrument]]],
			Packet[Object,WettedMaterials],

		True,
			Nothing
	];

	(* - ConcentratedProteinStandard - *)
	concentratedProteinStandardDownloadOption=If[
		(* Only downloading from the ConcentratedProteinStandard option if it is not Automatic *)
		MatchQ[suppliedConcentratedProteinStandard,Automatic],
		Nothing,
		suppliedConcentratedProteinStandard
	];

	concentratedProteinStandardDownloadFields=Which[
		(* If the option is left as Automatic, don't download anything *)
		MatchQ[suppliedConcentratedProteinStandard,Automatic],
			Nothing,

		(* If option is an object, download the MassConcentration and TotalProteinConcentration *)
		MatchQ[suppliedConcentratedProteinStandard,ObjectP[Object[Sample]]],
			Packet[Object,Composition,Analytes,TotalProteinConcentration,SamplePreparationCacheFields[Object[Sample],Format->Sequence]],

		(* If option is a Model, download the InitialMassConcentration *)
		MatchQ[suppliedConcentratedProteinStandard,ObjectP[Model[Sample]]],
			Packet[Composition,Analytes,SamplePreparationCacheFields[Model[Sample],Format->Sequence]],

		True,
		Nothing
	];

	(* - ProteinStandards - *)
	(* Make lists of the unique ProteinStandard Objects and Models (will download different fields from the two cases) - later will make replace rules to find a list of the concentrations *)
	uniqueProteinStandardObjects=DeleteDuplicates[Cases[ToList[suppliedProteinStandards],ObjectP[Object]]];
	uniqueProteinStandardModels=DeleteDuplicates[Cases[ToList[suppliedProteinStandards],ObjectP[Model]]];

	(* Define the fields that we want to download from the unique ProteinStandard Objects and Models *)
	uniqueProteinStandardObjectDownloadFields=Packet[Object,Composition,Analytes,TotalProteinConcentration,SamplePreparationCacheFields[Object[Sample],Format->Sequence]];
	uniqueProteinStandardModelDownloadFields=Packet[Composition,Analytes,SamplePreparationCacheFields[Model[Sample],Format->Sequence]];

	(* - QuantificationReagent - *)
	quantificationReagentDownloadOption=If[
		MatchQ[suppliedQuantificationReagent,Automatic],
		Nothing,
		suppliedQuantificationReagent
	];

	quantificationReagentDownloadFields=Which[
		(* If the option is left as Automatic, don't download anything*)
		MatchQ[suppliedQuantificationReagent,Automatic],
			Nothing,

		(* If the option is an object, download the Model *)
		MatchQ[suppliedQuantificationReagent,ObjectP[Object[Sample]]],
			Packet[Object,Composition,Analytes,TotalProteinConcentration,SamplePreparationCacheFields[Object[Sample],Format->Sequence]],

		(* If the option is a Model, download the Object *)
		MatchQ[suppliedQuantificationReagent,ObjectP[Model[Sample]]],
			Packet[Composition,Analytes,SamplePreparationCacheFields[Model[Sample],Format->Sequence]],

		True,
		Nothing
	];

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{TotalProteinConcentration,Composition,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,Composition,SamplePreparationCacheFields[Model[Sample]]}]]];
	objectContainerFields=Join[SamplePreparationCacheFields[Object[Container]],{StorageCondition}];
	modelContainerFields=Join[SamplePreparationCacheFields[Object[Container]],{DefaultStorageCondition}];
	modelContainerPacketFields=Packet@@Flatten[{Object,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container]]}];

	(* - All liquid handler compatible containers (for resources and Aliquot) - *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* - Big Download to make cacheBall and get the inputs in order by ID - *)
	cache = Lookup[expandedSafeOps, Cache, {}];
	{
		listedSampleContainerPackets,instrumentPacket,concentratedProteinStandardPacket,listedProteinStandardObjectPackets,listedProteinStandardModelPackets,quantificationReagentPacket,
		inputsInOrder,liquidHandlerContainerPackets
	}=Quiet[
		Download[
			{
				(* Inputs *)
				ToList[mySamplesWithPreparedSamples],
				{instrumentDownloadOption},
				{concentratedProteinStandardDownloadOption},
				uniqueProteinStandardObjects,
				uniqueProteinStandardModels,
				{quantificationReagentDownloadOption},
				ToList[mySamplesWithPreparedSamples],
				liquidHandlerContainers
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Container[objectContainerFields]],
					Packet[Container[Model][modelContainerFields]],
					Packet[Composition[[All,2]][MolecularWeight]],
					Packet[Container[{Model, Contents, Name, Status, Sterile, TareWeight, StorageCondition, RequestedResources}]]
				},
				{instrumentDownloadFields},
				{concentratedProteinStandardDownloadFields},
				{uniqueProteinStandardObjectDownloadFields},
				{uniqueProteinStandardModelDownloadFields},
				{quantificationReagentDownloadFields},
				{Packet[Object]},
				{modelContainerPacketFields}
			},
			Cache->cache,
			Simulation -> updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* Combine our downloaded and simulated cache. *)
	(* It is important that the sample preparation cache is added first to the cache ball, before the main download. *)
	cacheBall=FlattenCachePackets[
			{
				cache,listedSampleContainerPackets,instrumentPacket,concentratedProteinStandardPacket,listedProteinStandardObjectPackets,
				listedProteinStandardModelPackets,quantificationReagentPacket,liquidHandlerContainerPackets
			}
	];

	(* Get a list of the inputs by ID *)
	inputObjects=Lookup[Flatten[inputsInOrder],Object];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
	(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentTotalProteinQuantificationOptions[inputObjects,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

	(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentTotalProteinQuantificationOptions[inputObjects,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentTotalProteinQuantification,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentTotalProteinQuantification,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		tpqResourcePackets[inputObjects,templatedOptions,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
		{tpqResourcePackets[inputObjects,templatedOptions,resolvedOptions,Cache->cacheBall,Simulation->updatedSimulation],{}}
	];


	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentTotalProteinQuantification,collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOps,Upload],
			Confirm->Lookup[safeOps,Confirm],
			CanaryBranch->Lookup[safeOps,CanaryBranch],
			ParentProtocol->Lookup[safeOps,ParentProtocol],
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,TotalProteinQuantification],
			Cache->cache,
			Simulation->updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentTotalProteinQuantification,collapsedResolvedOptions],
		Preview -> Null
	}

];



(* ::Subsection:: *)
(* resolveExperimentTotalProteinQuantificationOptions *)


DefineOptions[
	resolveExperimentTotalProteinQuantificationOptions,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

resolveExperimentTotalProteinQuantificationOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentTotalProteinQuantificationOptions]]:=Module[
	{
		outputSpecification,output,gatherTests,messages,notInEngine,cache,samplePrepOptions,experimentOptions,simulatedSamples,resolvedSamplePrepOptions,experimentOptionsAssociation,
		suppliedAssayType,suppliedDetectionMode,suppliedInstrument,suppliedNumberOfReplicates,suppliedProteinStandards,suppliedConcentratedProteinStandard,suppliedProteinStandardDiluent,
		suppliedStandardCurveBlank,suppliedStandardCurveReplicates,suppliedQuantificationReagent,suppliedNumberOfEmissionReadings,suppliedEmissionAdjustmentSample,suppliedEmissionReadLocation,suppliedName,
		instrumentDownloadOption,instrumentDownloadFields,concentratedProteinStandardDownloadOption,concentratedProteinStandardObjects,concentratedProteinStandardDownloadFields,uniqueProteinStandardObjects,uniqueProteinStandardModels,
		uniqueProteinStandardObjectDownloadFields,uniqueProteinStandardModelDownloadFields,proteinStandardDownloadOption,
		quantificationReagentDownloadOption,quantificationReagentDownloadFields,concentratedProteinStandardObjectPacket,
		objectSamplePacketFields,modelSamplePacketFields,modelContainerPacketFields,objectContainerPacketFields,modelSampleContainerPacketFields,liquidHandlerContainers,
		listedSampleContainerPackets,instrumentPacket,concentratedProteinStandardPacket,listedProteinStandardObjectPackets,listedProteinStandardModelPackets,quantificationReagentPacket,
		listedProteinStandardCompositionPackets,liquidHandlerContainerPackets,proteinStandardCompositionPackets,proteinStandardPacketsNoNull,standardCompositionIDModels,standardProteinIDModels,uniqueSortedStandardProteinIDModels,
		numberOfUniqueSortedProteinIDModels,uniqueProteinIDModelsWarningQ,uniqueProteinIDModelsWarning,
		samplePackets,sampleModelPackets,sampleComponentPackets,sampleContainerPackets,suppliedInstrumentModel,concentratedProteinStandardConcentration,proteinStandardModelConcentrations,proteinStandardObjectTotalProteinConcentrations,
		proteinStandardObjectMassConcentrations,proteinStandardObjectConcentrations,proteinStandardModelConcentrationReplaceRules,proteinStandardObjectConcentrationReplaceRules,
		proteinStandardConcentrationReplaceRules,proteinStandardConcentrations,suppliedQuantificationReagentModel,nonOptimalQuantificationReagentTests,quantificationReactionWarningQ,
		nonDefaultQuantificationReactionWarning,
		discardedSamplePackets,discardedInvalidInputs,discardedTests,tooManyInvalidInputs,tooManyInputsTests,optionPrecisions,roundedExperimentOptions,optionPrecisionTests,
		suppliedStandardCurveConcentrations,suppliedLoadingVolume,suppliedQuantificationReagentVolume,suppliedQuantificationReactionTime,suppliedQuantificationReactionTemperature,
		suppliedExcitationWavelength,suppliedQuantificationWavelength,suppliedQuantificationTemperature,suppliedQuantificationEquilibrationTime,suppliedEmissionGain,roundedExperimentOptionsList,
		allOptionsRounded,validNameQ,nameInvalidOption,validNameTest,concentratedStandardOptions,concentratedStandardOptionsSetBool,invalidStandardCurveOptions,conflictingStandardCurveOptionsTests,
		invalidDetectionModeOptions,conflictingDetectionModeTests,fluorescenceOptions,invalidConflictingAbsorbanceOptions,conflictingAbsorbanceOptionsTests,invalidConflictingFluorescenceOptions,
		conflictingFluorescenceOptionsTests,
		invalidFluorescenceMismatchOptions,conflictingFluorescenceMismatchOptionsTests,idealQuantificationReagentP,nonOptimalQuantificationReagentBool,invalidSpanQuantificationWavelengthOption,invalidSpanTests,
		invalidListQuantificationWavelengthOptions,invalidQuantificationWavelengthListTests,duplicateProteinStandardsQ,duplicateProteinStandardsWarning,
		lowestSuppliedQuantificationWavelength,invalidExcitationWavelengthOptions,wavelengthMismatchTests,invalidVolumeOptions,volumeMismatchTests,
		notEnoughVolumeWarningQ,lowTotalVolumeWarning,validInstrumentP,invalidUnsupportedInstrumentOption,
		unsupportedInstrumentTests,invalidInstrumentOptions,invalidInstrumentTests,invalidFluorescenceInstrumentOptions,conflictingInstrumentFluorescenceOptionsTests,invalidQuantificationReactionOptions,
		conflictingQuantificationReactionOptionsTests,invalidConcentratedProteinStandardOption,invalidConcentratedProteinStandardTests,invalidProteinStandardsOption,invalidProteinStandards,
		invalidProteinStandardTests,customAssayTypeQuantificationReagentInvalidOptions,invalidAssayTypeTests,
		resolvedAssayType,
		fluorescenceOptionSetQ,resolvedDetectionMode,resolvedInstrument,resolvedQuantificationReagent,resolvedQuantificationReactionTime,resolvedQuantificationReactionTemperature,resolvedExcitationWavelength,
		resolvedEmissionGain,resolvedNumberOfEmissionReadings,resolvedEmissionAdjustmentSample,resolvedEmissionReadLocation,resolvedQuantificationWavelength,resolvedLoadingVolume,
		loadingVolumeNonOptimalBool,idealLoadingVolume,nonIdealLoadingVolumeWarning,resolvedQuantificationReagentVolume,quantificationReagentVolumeNonOptimalBool,idealQuantificationReagentVolume,
		nonIdealQuantificationReagentVolumeWarning,resolvedProteinStandards,resolvedConcentratedProteinStandard,resolvedStandardCurveConcentrations,resolvedProteinStandardDiluent,
		resolvedStandardCurveBlank,
		compatibleMaterialsBool,compatibleMaterialsTests,compatibleMaterialsInvalidOption,intNumberOfReplicates,numberOfSamples,numberOfStandardCurvePoints,standardCurvePointsOption,
		totalNumberOfWells,invalidReplicatesOptions,invalidReplicatesTests,standardCurveConcentrationsCheckQ,concentratedProteinStandardConcentrationNoAutomatic,
		invalidStandardCurveConcentrationOptions,invalidStandardCurveConcentrations,standardCurveConcentrationsTests,invalidTooLowStandardCurveConcentrations,
		invalidTooLowStandardCurveConcentrationOptions,standardCurveConcentrationsTooLowTests,
		lowestResolvedQuantificationWavelength,invalidResolvedExcitationWavelengthOptions,
		invalidResolvedExcitationWavelengthTests,largestResolvedQuantificationWavelength,invalidFluorescenceQuantificationWavelengthOption,invalidFluorescenceQuantificationWavelengthTests,
		invalidInputs,invalidOptions,requiredAliquotAmounts,liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes,potentialAliquotContainers,
		simulatedSamplesContainerModels,requiredAliquotContainers,resolvedAliquotOptions,aliquotTests,resolvedPostProcessingOptions,email,
		resolvedOptions,

		invalidSamplesInStorageConditionResults, invalidSamplesInStorageConditionTests,invalidSamplesInStorageConditionOption,expandedProteinStandardsStorageConditions,
		invalidProteinStandardsStorageConditionResults, invalidProteinStandardsStorageConditionTests,invalidProteinStandardsStorageConditionOption,
		invalidConcentratedProteinStandardStorageConditionResults, invalidConcentratedProteinStandardStorageConditionTests,invalidConcentratedProteinStandardStorageConditionOption,
		conflictingProteinStandardStorage,conflictingProteinStandardStorageOptions,conflictingProteinStandardStorageTests,conflictingConcProteinStandardStorage,
		conflictingConcProteinStandardStorageOptions,conflictingConcProteinStandardStorageTests, simulation, updatedSimulation

	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)
	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages=!gatherTests;

	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine=Not[MatchQ[$ECLApplication,Engine]];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our <Type> options from our Sample Prep options. *)
	{samplePrepOptions,experimentOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation}=resolveSamplePrepOptionsNew[ExperimentTotalProteinQuantification,mySamples,samplePrepOptions,Cache->cache,Simulation->simulation];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	experimentOptionsAssociation = Association[experimentOptions];

	(* --- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --- *)
	(* Pull out information from the non-quantity or number options that we might need - later, after rounding, we will Lookup the rounded options *)
	{
		suppliedAssayType,suppliedDetectionMode,suppliedInstrument,suppliedNumberOfReplicates,suppliedProteinStandards,suppliedConcentratedProteinStandard,suppliedProteinStandardDiluent,
		suppliedStandardCurveBlank,suppliedStandardCurveReplicates,suppliedQuantificationReagent,suppliedNumberOfEmissionReadings,suppliedEmissionAdjustmentSample,suppliedEmissionReadLocation,suppliedName
	}=
	 	Lookup[experimentOptionsAssociation,
			 {
				 AssayType,DetectionMode,Instrument,NumberOfReplicates,ProteinStandards,ConcentratedProteinStandard,ProteinStandardDiluent,StandardCurveBlank,StandardCurveReplicates,QuantificationReagent,
				 NumberOfEmissionReadings,EmissionAdjustmentSample,EmissionReadLocation,Name
			 },
			 Null
 	];

	(* -- Determine which fields from the various Options that can be Objects or Models or Automatic that we need to download -- *)
	(* - Instrument - *)
	instrumentDownloadOption=If[
		(* Only downloading from the instrument option if it is not Automatic *)
		MatchQ[suppliedInstrument,Automatic],
		Nothing,
		suppliedInstrument
	];

	instrumentDownloadFields=Which[
		(* If instrument left as automatic, don't download anything *)
		MatchQ[suppliedInstrument,Automatic],
			Nothing,

		(* If instrument is an object, download fields from the Model *)
		MatchQ[suppliedInstrument,ObjectP[Object[Instrument]]],
			Packet[Model[{Object,WettedMaterials}]],

		(* If instrument is a Model, download fields*)
		MatchQ[suppliedInstrument,ObjectP[Model[Instrument]]],
			Packet[Object,WettedMaterials],

		True,
			Nothing
	];

	(* - ConcentratedProteinStandard - *)
	concentratedProteinStandardDownloadOption=If[
		(* Only downloading from the ConcentratedProteinStandard option if it is not Automatic *)
		MatchQ[suppliedConcentratedProteinStandard,Automatic],
		Nothing,
		suppliedConcentratedProteinStandard
	];

	concentratedProteinStandardObjects = If[
		MatchQ[suppliedConcentratedProteinStandard,ObjectP[Object[Sample]]],
		suppliedConcentratedProteinStandard,
		Nothing
	];

	concentratedProteinStandardDownloadFields=Which[
		(* If the option is left as Automatic, don't download anything *)
		MatchQ[suppliedConcentratedProteinStandard,Automatic],
			Nothing,

		(* If option is an object, download the MassConcentration and TotalProteinConcentration *)
		MatchQ[suppliedConcentratedProteinStandard,ObjectP[Object[Sample]]],
			Packet[Object,Composition,Analytes,TotalProteinConcentration,Sequence@@SamplePreparationCacheFields[Object[Sample]]],

		(* If option is a Model, download the MassConcentration *)
		MatchQ[suppliedConcentratedProteinStandard,ObjectP[Model[Sample]]],
			Packet[Composition,Analytes,Sequence @@ SamplePreparationCacheFields[Model[Sample]]],

		True,
			Nothing
	];

	(* - ProteinStandards - *)
	(* Make lists of the unique ProteinStandard Objects and Models (will download different fields from the two cases) - later will make replace rules to find a list of the concentrations *)
	uniqueProteinStandardObjects=DeleteDuplicates[Cases[ToList[suppliedProteinStandards],ObjectP[Object]]];
	uniqueProteinStandardModels=DeleteDuplicates[Cases[ToList[suppliedProteinStandards],ObjectP[Model]]];

	(* Define the fields that we want to download from the unique ProteinStandard Objects and Models *)
	uniqueProteinStandardObjectDownloadFields=Packet[Object,Composition,Analytes,TotalProteinConcentration,Sequence@@SamplePreparationCacheFields[Object[Sample]]];
	uniqueProteinStandardModelDownloadFields=Packet[Object,Composition,Analytes,Sequence@@SamplePreparationCacheFields[Model[Sample]]];

	(* Define the list of Objects (or Nothing) that we will download from for the ProteinStandards *)
	proteinStandardDownloadOption=If[
		(* Only downloading from the ProteinStandard option if it is not Automatic or Null *)
		MatchQ[suppliedProteinStandards,Automatic|Null],
		{},
		suppliedProteinStandards
	];

	(* - QuantificationReagent - *)
	quantificationReagentDownloadOption=If[
		MatchQ[suppliedQuantificationReagent,Automatic],
		Nothing,
		suppliedQuantificationReagent
	];

	quantificationReagentDownloadFields=Which[
		(* If the option is left as Automatic, don't download anything*)
		MatchQ[suppliedQuantificationReagent,Automatic],
			Nothing,

		(* If the option is an object, download the Model *)
		MatchQ[suppliedQuantificationReagent,ObjectP[Object[Sample]]],
			Packet[Model[{Object}]],

		(* If the option is a Model, download the Object *)
		MatchQ[suppliedQuantificationReagent,ObjectP[Model[Sample]]],
			Packet[Object],

		True,
			Nothing
	];

	(* Create the Packet Download syntax for our Object and Model samples. *)
	objectSamplePacketFields=Packet@@Flatten[{TotalProteinConcentration,Composition,IncompatibleMaterials,SamplePreparationCacheFields[Object[Sample]]}];
	modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,Composition,SamplePreparationCacheFields[Model[Sample]]}]]];
	modelContainerPacketFields=Packet@@Flatten[{Object,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container]]}];
	objectContainerPacketFields=Flatten[{Object,StorageCondition,SamplePreparationCacheFields[Object[Container]]}];
	modelSampleContainerPacketFields=Flatten[{Object,DefualtStorageCondition,SamplePreparationCacheFields[Model[Container]]}];

	(* - All liquid handler compatible containers (for resources and Aliquot) - *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* --- Assemble Download --- *)
	{
		listedSampleContainerPackets,instrumentPacket,concentratedProteinStandardPacket,listedProteinStandardObjectPackets,
		listedProteinStandardModelPackets,quantificationReagentPacket,listedProteinStandardCompositionPackets,liquidHandlerContainerPackets,
		concentratedProteinStandardObjectPacket
	}=Quiet[
		Download[
			{
				(* Inputs *)
				simulatedSamples,
				{instrumentDownloadOption},
				{concentratedProteinStandardDownloadOption},
				uniqueProteinStandardObjects,
				uniqueProteinStandardModels,
				{quantificationReagentDownloadOption},
				proteinStandardDownloadOption,
				liquidHandlerContainers,
				{concentratedProteinStandardObjects}
			},
			{
				{
					objectSamplePacketFields,
					modelSamplePacketFields,
					Packet[Composition[[All,2]][MolecularWeight]],
					Packet[Container[{Model, Contents, Name, Status, Sterile, TareWeight}]],
					Packet[Container[objectContainerPacketFields]],
					Packet[Container[Model][modelSampleContainerPacketFields]]
				},
				{instrumentDownloadFields},
				{
					concentratedProteinStandardDownloadFields
				},
				{
					uniqueProteinStandardObjectDownloadFields,
					Packet[Container[objectContainerPacketFields]],
					Packet[Container[Model][modelSampleContainerPacketFields]]
				},
				{uniqueProteinStandardModelDownloadFields},
				{quantificationReagentDownloadFields},
				{Packet[Composition[[All, 2]][{Object}]]},
				{modelContainerPacketFields},
				{
					Packet[Container[objectContainerPacketFields]],
					Packet[Container[Model][modelSampleContainerPacketFields]]
				}
			},
			Cache->cache,
			Simulation->updatedSimulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* --- Extract out the packets from the download --- *)
	(* -- sample packets -- *)
	samplePackets=listedSampleContainerPackets[[All,1]];
	sampleModelPackets=listedSampleContainerPackets[[All,2]];
	sampleComponentPackets=listedSampleContainerPackets[[All,3]];
	sampleContainerPackets=listedSampleContainerPackets[[All,4]];

	(* -- Instrument packet --*)
	(* - Find the Model of the instrument, if it was specified - *)
	suppliedInstrumentModel=If[
		MatchQ[instrumentPacket,{}],
		Null,
		FirstOrDefault[Lookup[Flatten[instrumentPacket],Object]]
	];

	(* Helper function that gets the total MassConcentration of the protein components from the composition field. *)
	totalProteinMassConcentration[packet_]:=Module[{delistedPacket,modelComposition,allProteinComponents,allProteinAmounts},
		delistedPacket=If[MatchQ[packet,_List],
			First[Flatten[packet]],
			packet
		];

		modelComposition=Lookup[delistedPacket,Composition];

		(* Get all protein components *)
		allProteinComponents=Cases[modelComposition,{_,ObjectP[Model[Molecule,Protein]]}];

		allProteinAmounts=Cases[allProteinComponents[[All,1]],MassConcentrationP];

		If[Length[allProteinAmounts]==0,
			Null,
			Total[allProteinAmounts]
		]
	];

	(* -- ConcentratedProteinStandard -- *)
	(* Find the TotalProteinConcentration or MassConcentration of the Object, or the InitialMassConcentration of the Model *)
	concentratedProteinStandardConcentration=Which[

		(* If the option was left as Automatic, we define this Concentration as Automatic *)
		MatchQ[concentratedProteinStandardPacket,{}],
			Automatic,

		(* If the option was specified as a Model, define this as the MassConcentration of the total protein components in the Composition field *)
		MatchQ[suppliedConcentratedProteinStandard,ObjectP[Model[Sample]]],
			totalProteinMassConcentration[concentratedProteinStandardPacket],

		(* If the option was specified as an Object, define this as the TotalProteinConcentration if it is not Null, otherwise the MassConcentration of the largest protein component in the Composition field *)
		MatchQ[suppliedConcentratedProteinStandard,ObjectP[Object[Sample]]],
			If[
				(*IF the TotalProteinConcentration is Null *)
				MatchQ[First[ToList[Lookup[Flatten[concentratedProteinStandardPacket],TotalProteinConcentration]]],Null],

				(* THEN we set the concentration to the MassConcentration *)
				totalProteinMassConcentration[concentratedProteinStandardPacket],

				(* ELSE we set the concentration to the TotalProteinConcentration *)
				First[ToList[Lookup[Flatten[concentratedProteinStandardPacket],TotalProteinConcentration]]]
			]
	];

	(* -- ProteinStandards -- *)
	(* - From the Models, define the Concentration as the total protein MassConcentration *)
	proteinStandardModelConcentrations=totalProteinMassConcentration/@Flatten[listedProteinStandardModelPackets];

	(* - From the Objects, Lookup both the TotalProteinConcentration and MassConcentration - *)
	proteinStandardObjectTotalProteinConcentrations=Lookup[Flatten[listedProteinStandardObjectPackets],TotalProteinConcentration,{}];
	proteinStandardObjectMassConcentrations=totalProteinMassConcentration/@Flatten[listedProteinStandardObjectPackets];

	(* From the two Object concentration lists, choose the TotalProteinConcentration if it is filled out, otherwise choose the MassConcentration *)
	proteinStandardObjectConcentrations=MapThread[
		If[MatchQ[#1,Null],
			#2,
			#1
		]&,
		{proteinStandardObjectTotalProteinConcentrations,proteinStandardObjectMassConcentrations}
	];

	(* - Write replace rules for the unique ProteinStandard Models and Objects - goal is to get an index matched list of ProteinStandards by Concentration (MassConc or TotalProteinConc) - *)
	proteinStandardModelConcentrationReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueProteinStandardModels,proteinStandardModelConcentrations}
	];
	proteinStandardObjectConcentrationReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueProteinStandardObjects,proteinStandardObjectConcentrations}
	];

	(* Combine the two rules to make the list of replace rules which we will apply to suppliedProteinStandards *)
	proteinStandardConcentrationReplaceRules=Join[proteinStandardModelConcentrationReplaceRules,proteinStandardObjectConcentrationReplaceRules];

	(* Finally, use the replace rules to get a list of Concentrations index-matched to ProteinStandards *)
	proteinStandardConcentrations=suppliedProteinStandards/.proteinStandardConcentrationReplaceRules;

	(* -- QuantificationReagent --*)
	suppliedQuantificationReagentModel=Which[

		(* Case where the user has not specified a QuantificationReagent *)
		MatchQ[quantificationReagentPacket,{}],
			Null,

		(* Case where the user has specified a Model-less Object as the QuantificationReagent *)
		MatchQ[quantificationReagentPacket,{{Null}}],
			quantificationReagentDownloadOption,

		(* All other cases *)
		True,
			FirstOrDefault[Lookup[Flatten[quantificationReagentPacket],Object]]
	];

	(* --- INPUT VALIDATION CHECKS --- *)
	(* Get the samples from simulatedSamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs= If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];

	(* If there are discarded invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&messages,
		Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs,Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["The input samples "<>ObjectToString[discardedInvalidInputs,Simulation -> updatedSimulation]<>" are not discarded:",True,False]
			];

			passingTest=If[Length[discardedInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[simulatedSamples,discardedInvalidInputs],Simulation -> updatedSimulation]<>" are not discarded:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* If there are more than 24 input samples, set all of the samples to tooManyInvalidInputs *)
	tooManyInvalidInputs=If[Length[simulatedSamples]>80,
		Lookup[Flatten[samplePackets],Object,Null],
		{}
	];

	(* If there are too many input samples and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	If[Length[tooManyInvalidInputs]>0&&messages,
		Message[Error::TooManyTotalProteinQuantificationInputs]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyInputsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[tooManyInvalidInputs]==0,
				Nothing,
				Test["There are 24 or fewer input samples in "<>ObjectToString[tooManyInvalidInputs,Simulation -> updatedSimulation],True,False]
			];

			passingTest=If[Length[tooManyInvalidInputs]==Length[simulatedSamples],
				Nothing,
				Test["There are 24 or fewer input samples.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* First, define the option precisions that need to be checked for TotalProteinQuantification *)
	optionPrecisions={
		{StandardCurveConcentrations,10^-3*Milligram/Milliliter},
		{LoadingVolume,10^-1*Microliter},
		{QuantificationReagentVolume,10^-1*Microliter},
		{QuantificationReactionTime,10^0*Minute},
		{QuantificationReactionTemperature,10^0*Celsius},
		{ExcitationWavelength,10^0*Nanometer},
		{QuantificationWavelength,10^0*Nanometer},
		{QuantificationTemperature,10^0*Celsius},
		{QuantificationEquilibrationTime,10^0*Minute},
		{EmissionGain,10^0*Percent}
	};

	(* Verify that the experiment options are not overly precise *)
	{roundedExperimentOptions,optionPrecisionTests}=If[gatherTests,

		(*If we are gathering tests *)
		RoundOptionPrecision[experimentOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]],Output->{Result,Tests}],

		(* Otherwise *)
		{RoundOptionPrecision[experimentOptionsAssociation,optionPrecisions[[All,1]],optionPrecisions[[All,2]]],{}}
	];

	(* For option resolution below, Lookup the options that can be quantities or numbers from roundedExperimentOptions *)
	{
		suppliedStandardCurveConcentrations,suppliedLoadingVolume,suppliedQuantificationReagentVolume,suppliedQuantificationReactionTime,suppliedQuantificationReactionTemperature,
		suppliedExcitationWavelength,suppliedQuantificationWavelength,suppliedQuantificationTemperature,suppliedQuantificationEquilibrationTime,suppliedEmissionGain
	}=Lookup[roundedExperimentOptions,
		{
			StandardCurveConcentrations,LoadingVolume,QuantificationReagentVolume,QuantificationReactionTime,QuantificationReactionTemperature,ExcitationWavelength,QuantificationWavelength,
			QuantificationTemperature,QuantificationEquilibrationTime,EmissionGain
		}
	];

	(* Turn the output of RoundOptionPrecision[experimentOptionsAssociation] into a list *)
	roundedExperimentOptionsList=Normal[roundedExperimentOptions];

	(* Replace the rounded options in myOptions *)
	allOptionsRounded=ReplaceRule[
		myOptions,
		roundedExperimentOptionsList,
		Append->False
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)
	(* - Check that the protocol name is unique - *)
	validNameQ=If[MatchQ[suppliedName,_String],

		(* If the name was specified, make sure its not a duplicate name *)
		Not[DatabaseMemberQ[Object[Protocol,TotalProteinQuantification,suppliedName]]],

		(* Otherwise, its all good *)
		True
	];

	(* If validNameQ is False AND we are throwing messages, then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOption=If[!validNameQ&&messages,
		(
			Message[Error::DuplicateName,"TotalProteinQuantification protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest=If[gatherTests&&MatchQ[suppliedName,_String],
		Test["If specified, Name is not already an TotalProteinQuantification protocol object name:",
			validNameQ,
			True
		],
		Nothing
	];

	(* - Ensure that the ProteinStandards, ConcentratedProteinStandard, StandardCurveConcentrations, and ProteinStandardDiluent options are compatible - *)
	(* I could make this more clear as I did below with different warnings for the various cases, defining variables I use later in option resolution that could be useful here as well *)
	concentratedStandardOptions={suppliedConcentratedProteinStandard,suppliedStandardCurveConcentrations,suppliedProteinStandardDiluent};
	concentratedStandardOptionsSetBool=MemberQ[concentratedStandardOptions,Except[Null|Automatic]];
	(* Define the invalid options *)
	invalidStandardCurveOptions=Switch[{suppliedProteinStandards,suppliedConcentratedProteinStandard,suppliedStandardCurveConcentrations,suppliedProteinStandardDiluent},

		(* If ProteinStandards is anything except Null|Automatic, none of the other options can be specified *)
		{Except[Null|Automatic],Except[Null|Automatic],_,_},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},
		{Except[Null|Automatic],_,Except[Null|Automatic],_},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},
		{Except[Null|Automatic],_,_,Except[Null|Automatic]},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},

		(* If ProteinStandards is Null, none of the other options can be Null *)
		{Null,Null,_,_},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},
		{Null,_,Null,_},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},
		{Null,_,_,Null},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},

		(* If any of the ConcentratedProteinStandard, StandardCurveConcentrations, or ProteinStandardDiluent are specified, none of the others can be Null *)
		{_,Except[Null|Automatic],Null,_},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},
		{_,Except[Null|Automatic],_,Null},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},
		{_,Null,Except[Null|Automatic],_},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},
		{_,_,Except[Null|Automatic],Null},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},
		{_,Null,_,Except[Null|Automatic]},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},
		{_,_,Null,Except[Null|Automatic]},{ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent},

		(* Otherwise, the options are compatible *)
		{_,_,_,_},{}
	];

	(* If the StandardCurve options are in conflict, we throw an Error *)
	If[Length[invalidStandardCurveOptions]!=0&&messages,
		Message[Error::InvalidTotalProteinQuantificationStandardCurveOptions,suppliedProteinStandards,suppliedConcentratedProteinStandard,suppliedStandardCurveConcentrations,suppliedProteinStandardDiluent]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingStandardCurveOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidStandardCurveOptions]==0,
				Nothing,
				Test["The ProteinStandards, ConcentratedProteinStandard, StandardCurveConcentrations, and ProteinStandardDiluent options are in conflict with each other.",True,False]
			];
			passingTest=If[Length[invalidStandardCurveOptions]!=0,
				Nothing,
				Test["The ProteinStandards, ConcentratedProteinStandard, StandardCurveConcentrations, and ProteinStandardDiluent options are in conflict with each other.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Set a variable for the list of the fluorescence-related options *)
	fluorescenceOptions={suppliedExcitationWavelength,suppliedNumberOfEmissionReadings,suppliedEmissionAdjustmentSample,suppliedEmissionReadLocation,suppliedEmissionGain};

	(* - Ensure that if any of the fluorescenceOptions options are specified, none of the other options are Null - *)
	invalidFluorescenceMismatchOptions=If[

		(* IF any of the fluorescenceOptions are Null, and any are something other than Null or Automatic *)
		And[
			MemberQ[fluorescenceOptions,Null],
			MemberQ[fluorescenceOptions,Except[Null|Automatic]]
		],

		(* THEN the options that are Null or specified are in conflict and invalid *)
		PickList[{ExcitationWavelength,NumberOfEmissionReadings,EmissionAdjustmentSample,EmissionReadLocation,EmissionGain},fluorescenceOptions,Except[Automatic]],

		(* ELSE, the options are compatible *)
		{}
	];

	(* If the Fluorescence, AssayType, or DetectionMode options are in conflict when the master switches suggest Fluorescence, we throw an Error *)
	If[Length[invalidFluorescenceMismatchOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationNullFluorescenceOptionsMismatch,invalidFluorescenceMismatchOptions]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingFluorescenceMismatchOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidFluorescenceMismatchOptions]==0,
				Nothing,
				Test["If any of the ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, or EmissionGain options are set, none of the others are Null.",True,False]
			];
			passingTest=If[Length[invalidFluorescenceMismatchOptions]!=0,
				Nothing,
				Test["If any of the ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, or EmissionGain options are set, none of the others are Null.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that the QuantificationWavelength option is cool if set as a Span (first of the Span must be smaller than the last of the Span)- *)
	invalidSpanQuantificationWavelengthOption=If[

		(* IF the suppliedQuantificationWavelength is a Span*)
		MatchQ[Head[suppliedQuantificationWavelength],Span],

		(* THEN, we need to check if the span makes sense *)
		If[
			(*IF the First of the Span is larger than the Last of the span, the option is invalid *)
			First[suppliedQuantificationWavelength]>=Last[suppliedQuantificationWavelength],

			(* THEN, the option is invalid *)
			{QuantificationWavelength},

			(* ELSE, the span makes sense *)
			{}
		],

		(* ELSE, the option is not a Span so its fine *)
		{}
	];

	(* If the QuantificationWavelength is a Span that is incorrectly defined and we are throwing messages, throw an error *)
	If[Length[invalidSpanQuantificationWavelengthOption]!=0&&messages,
		Message[Error::TotalProteinQuantificationInvalidQuantificationWavelengthSpan,suppliedQuantificationWavelength]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidSpanTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidSpanQuantificationWavelengthOption]==0,
				Nothing,
				Test["If the QuantificationWavelength is specified as a Span, the first element of the Span is smaller than the last element.",True,False]
			];
			passingTest=If[Length[invalidSpanQuantificationWavelengthOption]!=0,
				Nothing,
				Test["If the QuantificationWavelength is specified as a Span, the first element of the Span is smaller than the last element.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw an Error if the QuantifcationWavelength option is specified as a List, but an entry is listed more than once - *)
	invalidListQuantificationWavelengthOptions=If[

		(* IF the suppliedQuantificationWavelength is a Span*)
		MatchQ[Head[suppliedQuantificationWavelength],List],

		(* THEN, we need to check if the List has any duplicates *)
		If[
			(*IF the length of the List is not the same as the Length of the list with Duplicates removed *)
			Length[suppliedQuantificationWavelength]!=Length[DeleteDuplicates[suppliedQuantificationWavelength]],

			(* THEN, the option is invalid *)
			{QuantificationWavelength},

			(* ELSE, the List makes sense *)
			{}
		],

		(* ELSE, the option is not a List so its fine *)
		{}
	];

	(* If the QuantificationWavelength is a List that contains repeated values, throw an error *)
	If[Length[invalidListQuantificationWavelengthOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationInvalidQuantificationWavelengthList,suppliedQuantificationWavelength]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidQuantificationWavelengthListTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidListQuantificationWavelengthOptions]==0,
				Nothing,
				Test["If the QuantificationWavelength is specified as a List, it cannot contain any duplicate values in the list.",True,False]
			];
			passingTest=If[Length[invalidListQuantificationWavelengthOptions]!=0,
				Nothing,
				Test["If the QuantificationWavelength is specified as a List, it does not contain any duplicate values in the list.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - If the user has supplied the ProteinStandards option and there are any duplicate entries, throw a Warning - *)
	duplicateProteinStandardsQ=If[

		(* IF the user has not specified the ProteinStandards option, or has specified it as Null *)
		MatchQ[suppliedProteinStandards,Alternatives[Automatic,Null]],

		(* THEN we do not need to throw a warning *)
		False,

		(* ELSE, we will throw a warning if there are duplicate members of ProteinStandards, but not otherwise *)
		If[
			(*IF the length of the List is not the same as the Length of the list with Duplicates removed *)
			Length[suppliedProteinStandards]!=Length[DeleteDuplicates[suppliedProteinStandards]],

			(* THEN, we need to throw a Warning*)
			True,

			(* ELSE, the List is fine *)
			False
		]
	];

	(* If duplicateProteinStandardsQ is True and we are throwing messages, throw a warning *)
	If[duplicateProteinStandardsQ&&messages&&notInEngine,
		Message[Warning::TotalProteinQuantificationDuplicateProteinStandards,suppliedProteinStandards]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	duplicateProteinStandardsWarning=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[!duplicateProteinStandardsQ,
				Nothing,
				Warning["If the ProteinStandards option is specified, it does not contain any duplicate values.",True,False]
			];
			passingTest=If[duplicateProteinStandardsQ,
				Nothing,
				Warning["If the ProteinStandards option is specified, it does not contain any duplicate values.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Find the lowest wavelength of QuantificationWavelength *)
	lowestSuppliedQuantificationWavelength=Which[

		(* Case where suppliedQuantificationWavelength is Automatic *)
		MatchQ[suppliedQuantificationWavelength,Automatic],
			Automatic,

		(* Case where suppliedQuantificationWavelength is a single - it is the lowest *)
		MatchQ[Head[suppliedQuantificationWavelength],Quantity],
			suppliedQuantificationWavelength,

		(* Case where suppliedQuantificationWavelength is a list, lowest is the smallest in the list *)
		MatchQ[Head[suppliedQuantificationWavelength],List],
			First[Sort[suppliedQuantificationWavelength]],

		(* Case where suppliedQuantificationWavelength is a span, lowest is the first in the span *)
		MatchQ[Head[suppliedQuantificationWavelength],Span],
			First[suppliedQuantificationWavelength]
	];

	(* Ensure that if the QuantificationWavelength and ExcitationWavelength options are both specified, that the ExcitationWavelength is at least 25 nm smaller than the lowest QuantificationWavelength *)
	invalidExcitationWavelengthOptions=If[

		(* IF both the ExcitationWavelength and QuantificationWavelength are user-specified *)
		MatchQ[suppliedExcitationWavelength,Except[Automatic|Null]]&&MatchQ[suppliedQuantificationWavelength,Except[Automatic|Null]],

		(* THEN, we need to test to see if the two options will work with each other *)
		If[

			(* IF the ExcitationWavelength is less than 25 nm smaller than the lowest QuantificationWavelength *)
			(lowestSuppliedQuantificationWavelength-suppliedExcitationWavelength)<25*Nanometer,

			(* THEN the options are in conflict *)
			{ExcitationWavelength,QuantificationWavelength},

			(* ELSE they're compatible *)
			{}
		],

		(* ELSE, there is no conflict *)
		{}
	];

	(* If the there are any invalidExcitationWavelengthOptions and we are throwing messages,throw an Error *)
	If[Length[invalidExcitationWavelengthOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationWavelengthMismatch,suppliedExcitationWavelength,suppliedQuantificationWavelength]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	wavelengthMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidExcitationWavelengthOptions]==0,
				Nothing,
				Test["If the ExcitationWavelength and QuantificationWavelength options are specified, the smallest member of QuantificationWavelength is at least 25 nm larger than the ExcitationWavelength.",True,False]
			];
			passingTest=If[Length[invalidExcitationWavelengthOptions]!=0,
				Nothing,
				Test["If the ExcitationWavelength and QuantificationWavelength options are specified, the smallest member of QuantificationWavelength is at least 25 nm larger than the ExcitationWavelength.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that the LoadingVolume and QuantificationReagentVolume sum to less than 300 uL, if they are both set - *)
	invalidVolumeOptions=If[

		(* IF both the LoadingVolume and QuantificationReagentVolume are user-specified *)
		MatchQ[suppliedLoadingVolume,Except[Automatic|Null]]&&MatchQ[suppliedQuantificationReagentVolume,Except[Automatic|Null]],

		(* THEN we must check if the options are valid (sum to 300 uL or less) *)
		If[

			(* IF the options sum to more than 300 uL *)
			(suppliedLoadingVolume+suppliedQuantificationReagentVolume)>300*Microliter,

			(* THEN the options are invalid *)
			{LoadingVolume,QuantificationReagentVolume},

			(* ELSE the options are fine *)
			{}
		],

		(* ELSE the options are fine *)
		{}
	];

	(* If the LoadingVolume and QuantificationReagentVolume sum to more than 300 uL and we are throwing messages, throw an error *)
	If[Length[invalidVolumeOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationInvalidVolumes,suppliedLoadingVolume,suppliedQuantificationReagentVolume]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	volumeMismatchTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidVolumeOptions]==0,
				Nothing,
				Test["If the LoadingVolume and QuantificationReagentVolume options are both specified, the their sum is not larger than 300 uL.",True,False]
			];
			passingTest=If[Length[invalidVolumeOptions]!=0,
				Nothing,
				Test["If the LoadingVolume and QuantificationReagentVolume options are both specified, the their sum is not larger than 300 uL.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Using similar logic as above, throw a warning if the sum of the LoadingVolume and the QuantificationReagentVolume is less than 60 uL - *)
	notEnoughVolumeWarningQ=If[

		(* IF both the LoadingVolume and QuantificationReagentVolume are user-specified *)
		MatchQ[suppliedLoadingVolume,Except[Automatic|Null]]&&MatchQ[suppliedQuantificationReagentVolume,Except[Automatic|Null]],

		(* THEN we must check if the options are valid (sum to at least 60 uL) *)
		If[

			(* IF the options sum less than 60 uL *)
			(suppliedLoadingVolume+suppliedQuantificationReagentVolume)<60*Microliter,

			(* THEN we have to throw a Warning *)
			True,

			(* ELSE the options are fine *)
			False
		],

		(* ELSE the options are fine *)
		False
	];

	(* If notEnoughVolumeWarningQ is True and we are throwing messages, throw a warning *)
	If[notEnoughVolumeWarningQ&&messages&&notInEngine,
		Message[Warning::TotalProteinQuantificationTotalVolumeLow,suppliedLoadingVolume,suppliedQuantificationReagentVolume]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	lowTotalVolumeWarning=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[!notEnoughVolumeWarningQ,
				Nothing,
				Warning["The sum of the LoadingVolume, "<>ToString[suppliedLoadingVolume]<>", and the QuantificationReagentVolume, "<>ToString[suppliedQuantificationReagentVolume]<>", is less than 60 uL. Absorbance or Fluorescence values from such a low volume may not be accurate. Please consider increasing these volumes, or letting the options automatically resolve.",True,False]
			];
			passingTest=If[notEnoughVolumeWarningQ,
				Nothing,
				Warning["The LoadingVolume and QuantificationReagentVolume are either not both specified, or are specified and sum to larger than 60 uL.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that the supplied Instrument option is of a Model that is currently supported in TotalProteinQuantification - *)
	(* Pattern containing the instruments that are currently supported in TPQ *)
	validInstrumentP=Alternatives[
		Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"],
		Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"],
		Model[Instrument, PlateReader, "id:mnk9jO3qDzpY"]
	];

	(* Check to see if the instrument option is set and valid *)
	invalidUnsupportedInstrumentOption=Which[

		(* IF the instrument is not specified, the option is fine *)
		MatchQ[suppliedInstrumentModel,Null],
			{},

		(* IF the instrument model matches validInstrumentP, then the option is valid *)
		MatchQ[suppliedInstrumentModel,validInstrumentP],
			{},

		(* OTHERWISE, the Instrument option is invalid *)
		True,
			{Instrument}
	];

	(* If the LoadingVolume and QuantificationReagentVolume sum to more than 300 uL and we are throwing messages, throw an error *)
	If[Length[invalidUnsupportedInstrumentOption]!=0&&messages,
		Message[Error::TotalProteinQuantificationUnsupportedInstrument,ObjectToString[suppliedInstrument, Simulation -> updatedSimulation],ObjectToString[suppliedInstrumentModel, Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	unsupportedInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidUnsupportedInstrumentOption]==0,
				Nothing,
				Test["If the Instrument option is specified, if is of a supported Model.",True,False]
			];
			passingTest=If[Length[invalidUnsupportedInstrumentOption]!=0,
				Nothing,
				Test["If the Instrument option is specified, if is of a supported Model.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that the AssayType and DetectionMode options are compatible with the supplied Instrument option - *)
	invalidInstrumentOptions= Which[

		(* IF the supplied Instrument model is the CLARIOstar and the AssayType or DetectionMode options suggest an absorbance assay, the options are in conflict *)
		And[
			MatchQ[suppliedInstrumentModel, ObjectP[{Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"], Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"]}]],
			Or[
				MatchQ[suppliedAssayType, Alternatives[BCA, Bradford]],
				MatchQ[suppliedDetectionMode, Absorbance]
			]
		],
		(* THEN the options are in conflict *)
		Join[
			{Instrument},
			If[MatchQ[suppliedAssayType, Alternatives[BCA, Bradford]], {AssayType}, {}],
			If[MatchQ[suppliedDetectionMode, Absorbance], {DetectionMode}, {}]
		],

		(* IF the supplied Instrument model is the FLUOstar Omega and the AssayType or DetectionMode options suggest a fluorescence assay, the options are in conflict *)
		And[
			MatchQ[suppliedInstrumentModel, Model[Instrument, PlateReader, "id:mnk9jO3qDzpY"]],
			Or[
				MatchQ[suppliedAssayType, FluorescenceQuantification],
				MatchQ[suppliedDetectionMode, Fluorescence]
			]
		],
		(* THEN the options are in conflict *)
		Join[
			{Instrument},
			If[MatchQ[suppliedAssayType, FluorescenceQuantification], {AssayType}, {}],
			If[MatchQ[suppliedDetectionMode, Fluorescence], {DetectionMode}, {}]
		],

		(* OTHERWISE, the options are fine *)
		True,
		{}
	];

	(* If the Instrument option is in conflict with either the AssayType or the DetectionMode and we are throwing messages, throw an error *)
	If[Length[invalidInstrumentOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationInstrumentOptionMismatch,invalidInstrumentOptions]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidInstrumentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidInstrumentOptions]==0,
				Nothing,
				Test["If the Instrument option and at least one of the AssayType or DetectionMode options are specified, they are not in conflict.",True,False]
			];
			passingTest=If[Length[invalidInstrumentOptions]!=0,
				Nothing,
				Test["If the Instrument option and at least one of the AssayType or DetectionMode options are specified, they are not in conflict.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that if the instrument option is set, it is okay with the fluorescenceOptions - *)
	invalidFluorescenceInstrumentOptions= Which[

		(* IF the supplied Instrument model is the CLARIOstar, and any of the fluorescenceOptions are Null, then the options are conflicting *)
		And[
			MatchQ[suppliedInstrumentModel, ObjectP[{Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"], Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"]}]],
			MemberQ[fluorescenceOptions, Null]
		],

		(* THEN the Instrument option and the Null options are invalid *)
		Join[
			{Instrument},
			PickList[{ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, EmissionGain}, fluorescenceOptions, Null]
		],

		(* IF the supplied Instrument model is the FLUOstar Omega, and any of the fluorescenceOptions are specified, then the options are conflicting *)
		And[
			MatchQ[suppliedInstrumentModel, Model[Instrument, PlateReader, "id:mnk9jO3qDzpY"]],
			MemberQ[fluorescenceOptions, Except[Null | Automatic]]
		],

		(* THEN the Instrument option and the specified fluorescence options are invalid*)
		Join[
			{Instrument},
			PickList[{ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, EmissionGain}, fluorescenceOptions, Except[Null | Automatic]]
		],

		(*OTHERWISE, the options are not conflicting *)
		True,
		{}
	];

	(* If the Instrument option is in conflict with any of the Fluorescence-related options and we are throwing messages, throw an error *)
	If[Length[invalidFluorescenceInstrumentOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationInstrumentFluoresceneceOptionsMisMatch,invalidFluorescenceInstrumentOptions]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingInstrumentFluorescenceOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidFluorescenceInstrumentOptions]==0,
				Nothing,
				Test["If the Instrument option is specified, it is not in conflict with any of the ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, or EmissionGain options.",True,False]
			];
			passingTest=If[Length[invalidFluorescenceInstrumentOptions]!=0,
				Nothing,
				Test["If the Instrument option is specified, it is not in conflict with any of the ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, or EmissionGain options.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that the QuantificationReaction-related options are compatible - *)
	invalidQuantificationReactionOptions=If[

		(* IF the list of suppliedQuantificationReactionTime and suppliedQuantificationTemperature options contains both a Null and a specified option *)
		And[
			MemberQ[{suppliedQuantificationReactionTime,suppliedQuantificationReactionTemperature},Null],
			MemberQ[{suppliedQuantificationReactionTime,suppliedQuantificationReactionTemperature},Except[Null|Automatic]]
		],

		(* THEN the options are invalid *)
		{QuantificationReactionTime,QuantificationReactionTemperature},

		(* ELSE, the options are fine *)
		{}
	];

	(* If the Instrument option is in conflict with any of the Fluorescence-related options and we are throwing messages, throw an error *)
	If[Length[invalidQuantificationReactionOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationReactionOptionsMisMatch,suppliedQuantificationReactionTime,suppliedQuantificationReactionTemperature]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingQuantificationReactionOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidQuantificationReactionOptions]==0,
				Nothing,
				Test["The QuantificationReactionTime and QuantificationReactionTemperature options are in conflict.",True,False]
			];
			passingTest=If[Length[invalidQuantificationReactionOptions]!=0,
				Nothing,
				Test["The QuantificationReactionTime and QuantificationReactionTemperature options are in conflict.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - If the option is specified, ensure that the MassConcentration or TotalProteinConcentration is informed - *)
	invalidConcentratedProteinStandardOption=Switch[{concentratedProteinStandardConcentration,suppliedConcentratedProteinStandard},

		(* If the Option was left as Automatic, it is not invalid *)
		{Automatic,_},
			{},

		(* If the option was set to be Null, it is not invalid *)
		{_,Null},
			{},

		(* If the Concentration is Null, the option is invalid *)
		{Null,Except[Automatic|Null]},
			{ConcentratedProteinStandard},

		(* Otherwise, its all good *)
		{_,_},
			{}
	];

	(* If the ConcentratedProteinStandard option is specified and it does not have an associated concentration and we are throwing messages, throw an error *)
	If[Length[invalidConcentratedProteinStandardOption]!=0&&messages,
		Message[Error::TotalProteinQuantificationConcentratedProteinStandardInvalid,ObjectToString[suppliedConcentratedProteinStandard, Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidConcentratedProteinStandardTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidConcentratedProteinStandardOption]==0,
				Nothing,
				Test["If specified, the ConcentratedProteinStandard has either its MassConcentration (in the Composition field) or TotalProteinConcentration fields informed.",True,False]
			];
			passingTest=If[Length[invalidConcentratedProteinStandardOption]!=0,
				Nothing,
				Test["If specified, the ConcentratedProteinStandard has either its MassConcentration (in the Composition field) or TotalProteinConcentration fields informed.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that, if specified, every member of ProteinStandards has either its InitialMassConcentration informed if a Model is provided, or either its TotalProteinConcentration or MassConcentration informed if it is an Object - *)
	invalidProteinStandardsOption=If[

		(* IF the option was left as Automatic *)
		MatchQ[suppliedProteinStandards,Automatic],

		(* THEN the option is fine *)
		{},

		(* ELSE, check if any of the members don't have a concentration associated with them *)
		If[
			(* IF any of the ProteinStandards have no concentration associated with them, then the option is invalid *)
			MemberQ[proteinStandardConcentrations,Null],
			{ProteinStandards},

			(* ELSE, the option is fine *)
			{}
		]
	];

	(* Determine which of the ProteinStandards have Null for concentration *)
	invalidProteinStandards=If[MatchQ[suppliedProteinStandards,Automatic|Null],
		{},

		(* The invalid standards are those that have Null as a concentration *)
		PickList[suppliedProteinStandards,proteinStandardConcentrations,Null]
	];

	(* If the ConcentratedProteinStandard option is specified and it does not have an associated concentration and we are throwing messages, throw an error *)
	If[Length[invalidProteinStandards]!=0&&messages,
		Message[Error::TotalProteinQuantificationNullProteinStandardConcentration,ObjectToString[invalidProteinStandards, Simulation -> updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidProteinStandardTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidProteinStandards]==0,
				Nothing,
				Test["If specified, the ProteinStandards have either their MassConcentration (in the Composition field) or TotalProteinConcentration fields informed.",True,False]
			];
			passingTest=If[Length[invalidProteinStandards]!=0,
				Nothing,
				Test["If specified, the ProteinStandards have either their MassConcentration (in the Composition field) or TotalProteinConcentration fields informed.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Throw an Error if the user has specified the AssayType as Custom, but has not specified a QuantificationReagent - *)
	customAssayTypeQuantificationReagentInvalidOptions=If[
		MatchQ[suppliedAssayType,Custom]&&MatchQ[suppliedQuantificationReagent,Automatic],
		{AssayType,QuantificationReagent},
		{}
	];

	(* If the customAssayTypeQuantificationReagentInvalidOptions is not {} and we are throwing messages, throw an error *)
	If[Length[customAssayTypeQuantificationReagentInvalidOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationCustomAssayTypeInvalid,suppliedAssayType]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidAssayTypeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[customAssayTypeQuantificationReagentInvalidOptions]==0,
				Nothing,
				Test["If the AssayType has been specified as Custom, the QuantificationReagent option has also been specified.",True,False]
			];
			passingTest=If[Length[customAssayTypeQuantificationReagentInvalidOptions]!=0&&MatchQ[suppliedAssayType,Custom],
				Nothing,
				Test["If the AssayType has been specified as Custom, the QuantificationReagent option has also been specified.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Throw a warning if any of the specified ProteinStandards do not have identical Protein ID Models in their Composition fields -- *)
	(* First, Flatten the listedProteinStandardCompositionPackets to the First level, to get a list of list of packets (the packets are the things in the Composition field of the ProteinStandards) *)
	proteinStandardCompositionPackets=Flatten[listedProteinStandardCompositionPackets,1];

	(* Next, get rid of any Nulls present in proteinStandardCompostionPackets *)
	proteinStandardPacketsNoNull=Cases[#,PacketP[]]&/@proteinStandardCompositionPackets;

	(* From this list of list of Packets, Lookup the Object of each Packet *)
	standardCompositionIDModels=Lookup[#,Object]&/@proteinStandardPacketsNoNull;

	(* Get a list of all the ID Models that are Proteins for the input samples *)
	standardProteinIDModels=Cases[#,ObjectP[Model[Molecule,Protein]]]&/@standardCompositionIDModels;

	(* Sort each inner list, so that when we DeleteDuplicates it won't miss lists that have identical Models but different order *)
	uniqueSortedStandardProteinIDModels=DeleteDuplicates[Sort[#]&/@standardProteinIDModels];

	(* Get the Length of the list lists of unique ProteinIDModels per ProteinStandard *)
	numberOfUniqueSortedProteinIDModels=Length[uniqueSortedStandardProteinIDModels];

	(* Based on how many different sets or Protein ID Models there are in input ProteinStandards, decide if we need to throw a Warning or not *)
	uniqueProteinIDModelsWarningQ=If[numberOfUniqueSortedProteinIDModels>1,
		True,
		False
	];

	(* If uniqueProteinIDModelsWarningQ is True and we are throwing message and not in Engine, throw a Warning *)
	(* If notEnoughVolumeWarningQ is True and we are throwing messages, throw a warning *)
	If[uniqueProteinIDModelsWarningQ&&messages&&notInEngine,
		Message[Warning::TotalProteinQuantificationMultipleProteinStandardIdentityModels,suppliedProteinStandards,standardProteinIDModels]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	uniqueProteinIDModelsWarning=If[gatherTests&&MatchQ[suppliedProteinStandards,Except[Null|Automatic]],
		Module[{failingTest,passingTest},
			failingTest=If[!uniqueProteinIDModelsWarningQ,
				Nothing,
				Warning["Each member of the ProteinStandards, "<>ObjectToString[suppliedProteinStandards,Simulation -> updatedSimulation]<>", does not have the same Model[Molecule,Protein]s in its Composition field. The lists of Model[Molecule,Protein]s in the ProteinStandards are "<>ObjectToString[standardProteinIDModels, Simulation->updatedSimulation]<>". The StandardCurve generated from these ProteinStandards may not be able to accurately quantify the concentration of proteins in the input Samples.",True,False]
			];
			passingTest=If[uniqueProteinIDModelsWarningQ,
				Nothing,
				Warning["Each member of ProteinStandards has the same Model[Molecule,Protein]s in its Composition field.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- RESOLVE AUTOMATIC OPTIONS --- *)
	(* -- Master switch resolution -- *)
	(* - Resolve AssayType - *)
	(* First, set a Boolean that checks if any of the Fluorescence-related options are set ({ExcitationWavelength,NumberOfEmissionReadings,EmissionAdjustmentSample, EmissionReadLocation,EmissionGain}) *)
	fluorescenceOptionSetQ=MemberQ[fluorescenceOptions,Except[Null|Automatic]];

	(* We resolve the assayType based on the Model of the QuantificationReagent, if set, or if any of the Fluorescence-relation option have been set, if not *)
	resolvedAssayType=Switch[{suppliedAssayType,suppliedQuantificationReagentModel,suppliedDetectionMode,fluorescenceOptionSetQ},

		(* -- If the user has specified the AssayType, we accept it -- *)
		{Except[Automatic],_,_,_},
			suppliedAssayType,

		(* -= Cases where the user has not specified the AssayType -- *)
		(* - Cases where the user has specified a QuantificationReagent - *)
		(* Cases where the user has specified a QuantificationReagent and it is of one of the default Models *)
		{Automatic,Model[Sample, "id:XnlV5jK89053"],_,_},
			Bradford,
		{Automatic,Model[Sample, StockSolution, "id:XnlV5jK8B0lo"],_,_},
			BCA,
		{Automatic,Model[Sample, StockSolution, "id:O81aEBZmMje1"],_,_},
			FluorescenceQuantification,
		(* Case where the user has specified a QuantificationReagent and it is not one of the default Models *)
		{Automatic,ObjectP[],_},
			Custom,

		(* - Cases where the user has not specified a QuantificationReagent - resolution depends on the suppliedDetectionMode or if Fluorescence-related option shave been set - *)
		{Automatic,Null,Absorbance,_},
			Bradford,
		{Automatic,Null,Fluorescence,_},
			FluorescenceQuantification,
		{Automatic,Null,Automatic,False},
			Bradford,
		{Automatic,Null,Automatic,True},
			FluorescenceQuantification,
		(* Catch=all but should never be triggered *)
		{_,_,_,_},
			Bradford
	];

	(* - Resolve DetectionMode - *)
	(* Detection Mode resolves based on the AssayType and if any of the Fluorescence-related options are set *)
	resolvedDetectionMode=Switch[{suppliedDetectionMode,resolvedAssayType,fluorescenceOptionSetQ},

		(* If the user has specified the DetectionMode, we accept the option *)
		{Except[Automatic],_,_},
			suppliedDetectionMode,

		(* Cases where AssayType is Custom, resolution depends on if any of the other fluorescence options are set *)
		{Automatic,Custom,False},
			Absorbance,
		{Automatic,Custom,True},
			Fluorescence,

		(* Cases where AssayType is not Custom, resolution depends on the AssayType *)
		{Automatic,FluorescenceQuantification,_},
			Fluorescence,
		{_,_,_},
			Absorbance
	];

	(* -- Independent option resolution -- *)
	(* - Resolve Instrument - *)
	resolvedInstrument=Switch[{suppliedInstrument,resolvedDetectionMode},

		(* If the user has specified the Instrument, we accept the option*)
		{Except[Automatic],_},
			suppliedInstrument,

		(* Otherwise, we set the Instrument based on the resolvedDetectionMode *)
		{Automatic,Absorbance},
			Model[Instrument, PlateReader, "FLUOstar Omega"],

		{Automatic,Fluorescence},
			Model[Instrument, PlateReader, "CLARIOstar"]
	];

	(* - Resolve QuantificationReagent - *)
	resolvedQuantificationReagent=Switch[{suppliedQuantificationReagent,resolvedAssayType,resolvedDetectionMode},

		(* If the user has specified the QuantificationReagent, we accept the option *)
		{Except[Automatic],_,_},
			suppliedQuantificationReagent,

		(* If the AssayType is not Custom, the option resolves based on the resolvedAssayType *)
		{Automatic,Bradford,_},
			Model[Sample, "Quick Start Bradford 1x Dye Reagent"],
		{Automatic,BCA,_},
			Model[Sample,StockSolution,"Pierce BCA Protein Assay Quantification Reagent"],
		{Automatic,FluorescenceQuantification,_},
			Model[Sample, StockSolution, "Quant-iT Protein Assay Quantification Reagent"],

		(* If the AssayType is Custom, option resolves to Null (an Error will be thrown) *)
		{Automatic,Custom,Absorbance},
			Null, (*Model[Sample, "Quick Start Bradford 1x Dye Reagent"]*)
		{Automatic,Custom,Fluorescence},
			Null (*Model[Sample, StockSolution, "Quant-iT Protein Assay Quantification Reagent"]*)
	];

	(* - Resolve QuantificationReactionTime - *)
	resolvedQuantificationReactionTime=Switch[{suppliedQuantificationReactionTime,resolvedAssayType,suppliedQuantificationReactionTemperature},

		(* If the user has specifeid the option, we accept it *)
		{Except[Automatic],_,_},
			suppliedQuantificationReactionTime,

		(* - Otherwise, we set the option based on the AssayType and supplied QuantificationReactionTemperature - *)
		(* If QuantificationReactionTemperature specified as Null, we resolve the related time to Null *)
		{Automatic,_,Null},
			Null,
		(* If it was not set, and AssayType is BCA, resolve to 1 hour *)
		{Automatic,BCA,_},
			1*Hour,

		(* If the AssayType is not BCA but the user has set the QuantificationReactionTemperature, we resolve to 5 minutes *)
		{Automatic,_,Except[Null|Automatic]},
			5*Minute,

		(* Otherwise, there is no reaction and we set it to Null*)
		{_,_,_},
			Null
	];

	(* - Resolve QuantificationReactionTemperature - *)
	resolvedQuantificationReactionTemperature=Switch[{suppliedQuantificationReactionTemperature,resolvedQuantificationReactionTime},

		(* If the user has specified the option, we accept it *)
		{Except[Automatic],_},
		suppliedQuantificationReactionTemperature,

		(* - Otherwise, we set the option based on the resolved QuantificationReactionTime - *)
		(* If QuantificationReactionTime has resolved to Null, we set the Temperature to Null *)
		{Automatic,Null},
			Null,

		(* Otherwise we resolve to 25 Celsius *)
		{Automatic,_},
			$AmbientTemperature
	];

	(* - Resolve ExcitationWavelength - *)
	resolvedExcitationWavelength=Switch[{suppliedExcitationWavelength,resolvedDetectionMode,suppliedQuantificationWavelength},

		(* If the user has specified the option, we accept it *)
		{Except[Automatic],_,_},
			suppliedExcitationWavelength,

		(* If the resolvedDetectionMode is Absorbance, we set the option to Null *)
		{Automatic,Absorbance,_},
			Null,

		(* If the resolvedDetectionMode is Fluorescence, we set the option to 470 nm, or 50 nm lower than the lowest wavelength in the QuantificationWavelength field, if possible (and to 320 nm if not possible) *)
		{Automatic,Fluorescence,Automatic},
			470*Nanometer,

		(* Case where user has set the QuantificationWavelength option *)
		{Automatic,Fluorescence,_},
			If[
				(* IF the lowest wavelength in the QuantificationWavelength option is 370 nm or smaller *)
				MatchQ[lowestSuppliedQuantificationWavelength,LessEqualP[370*Nanometer]],

				(* THEN we set the ExcitationWavelength to 320 nm (will error check later to see if this is physically possible *)
				320*Nanometer,

				(* ELSE we set the ExcitationWavelength to 50 nm lower than the lowest Wavelength in the QuantificationWavelength option, or 470*Nanometer, whichever is smaller *)
				Min[(lowestSuppliedQuantificationWavelength-50*Nanometer),470*Nanometer]
			]
	];

	(* - Resolve EmissionGain - *)
	resolvedEmissionGain=Switch[{suppliedEmissionGain,resolvedDetectionMode},

		(* If the user has specified the option, we accept it *)
		{Except[Automatic],_},
			suppliedEmissionGain,

		(* Otherwise, we resolve it based on the resolvedDetectionMode *)
		{Automatic,Fluorescence},
			90*Percent,

		{_,_},
			Null
	];

	(* - Resolve NumberOfEmissionReadings - *)
	resolvedNumberOfEmissionReadings=Switch[{suppliedNumberOfEmissionReadings,resolvedDetectionMode},

		(* If the user has specified the option, we accept it *)
		{Except[Automatic],_},
			suppliedNumberOfEmissionReadings,

		(* Otherwise, we resolve it based on the resolvedDetectionMode *)
		{Automatic,Fluorescence},
			100,

		{_,_},
			Null
	];

	(* - Resolve EmissionReadLocation - *)
	resolvedEmissionReadLocation=Switch[{suppliedEmissionReadLocation,resolvedDetectionMode},

		(* If the user has specified the option, we accept it *)
		{Except[Automatic],_},
			suppliedEmissionReadLocation,

		(* Otherwise, we resolve it based on the resolvedDetectionMode *)
		{Automatic,Fluorescence},
			Top,

		{_,_},
			Null
	];

	(* - Resolve QuantificationWavelength - *)
	resolvedQuantificationWavelength=Switch[{suppliedQuantificationWavelength,resolvedAssayType,resolvedDetectionMode},

		(* If the user has specified the option, we accept it *)
		{Except[Automatic],_,_},
			suppliedQuantificationWavelength,

		(* If left as Automatic and the AssayType is not Custom, option depends on the AssayType *)
		{Automatic,Bradford,_},
			595*Nanometer,
		{Automatic,BCA,_},
			562*Nanometer,
		{Automatic,FluorescenceQuantification,_},
			570*Nanometer,

		(* If AssayType is Custom, resolves based on the resolvedDetectionMode *)
		{Automatic,Custom,Fluorescence},
			570*Nanometer,
		{Automatic,Custom,Absorbance},
			595*Nanometer
	];

	(* - Resolve LoadingVolume- *)
	{resolvedLoadingVolume,loadingVolumeNonOptimalBool,idealLoadingVolume}=Switch[{suppliedLoadingVolume,resolvedDetectionMode,resolvedAssayType},

		(* If the user has specified the LoadingVolume, we accept the option *)
		{Except[Automatic],_,_},
			{suppliedLoadingVolume,False,Null},

		(* If the resolvedDetectionMode is Fluorescence, we resolve to 10 uL or to 300 uL minus the suppliedQuantificationReagentVolume *)
		{Automatic,Fluorescence,_},
			If[
				(* IF the suppliedQuantificationReagentVolume is Automatic or equal to or less than 290 uL *)
				MatchQ[suppliedQuantificationReagentVolume,Alternatives[Automatic,LessEqualP[290*Microliter]]],

				(* THEN we resolve to 10 uL *)
				{10*Microliter,False,Null},

				(* ELSE we resolve to 300 uL - suppliedQuantificationReagentVolume and set the warning Bool *)
				{(300*Microliter-suppliedQuantificationReagentVolume),True,10*Microliter}
			],

		(* If the resolvedDetectionMode is Absorbance and the AssayType is BCA, we resolve to 25 uL or to 300 uL minus the suppliedQuantificationReagentVolume *)
		{Automatic,Absorbance,BCA},
			If[
				(* IF the suppliedQuantificationReagentVolume is Automatic or equal to or less than 275 uL *)
				MatchQ[suppliedQuantificationReagentVolume,Alternatives[Automatic,LessEqualP[275*Microliter]]],

				(* THEN we resolve to 25 uL *)
				{25*Microliter,False,Null},

				(* ELSE we resolve to 300 uL - suppliedQuantificationReagentVolume and set the warning Bool *)
				{(300*Microliter-suppliedQuantificationReagentVolume),True,25*Microliter}
			],

		(* In other cases, the AssayType is Bradford or Custom, we resolve to 5 uL or 300 uL minus the suppliedQuantificationReagentVolume *)
		{Automatic,_,_},
			If[
				(* IF the suppliedQuantificationReagentVolume is Automatic or equal to or less than 295 uL *)
				MatchQ[suppliedQuantificationReagentVolume,Alternatives[Automatic,LessEqualP[295*Microliter]]],

				(* THEN we resolve to 5 uL *)
				{5*Microliter,False,Null},

				(* ELSE we resolve to 300 uL - suppliedQuantificationReagentVolume and set the warning Bool *)
				{(300*Microliter-suppliedQuantificationReagentVolume),True,5*Microliter}
			]
	];

	(* If loadingVolumeNonOptimalBool is True and we are throwing messages, throw a warning *)
	If[loadingVolumeNonOptimalBool&&messages&&notInEngine,
		Message[Warning::TotalProteinQuantificationLoadingVolumeLow,resolvedLoadingVolume,idealLoadingVolume,resolvedDetectionMode,resolvedAssayType,suppliedQuantificationReagentVolume]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonIdealLoadingVolumeWarning=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[!loadingVolumeNonOptimalBool,
				Nothing,
				Warning["The LoadingVolume has been automatically set to "<>ToString[resolvedLoadingVolume]<>", which is lower than "<>ToString[idealLoadingVolume]<>", the ideal volume for the DetectionMode, ("<>ToString[resolvedDetectionMode]<>"), and AssayType, ("<>ToString[resolvedAssayType]<>"), options. This is because the QuantificationReagentVolume was set to "<>ToString[suppliedQuantificationReagentVolume]<>", and the sum of the LoadingVolume and QuantificationReagentVolume cannot be larger than 300 uL.",True,False]
			];
			passingTest=If[loadingVolumeNonOptimalBool,
				Nothing,
				Warning["If left as Automatic, the LoadingVolume is ideal for the AssayType and DetectionMode.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Resolve LoadingVolume - *)
	{resolvedQuantificationReagentVolume,quantificationReagentVolumeNonOptimalBool,idealQuantificationReagentVolume}=Switch[{suppliedQuantificationReagentVolume,resolvedDetectionMode,resolvedAssayType},

		(* If the user has specified the QuantificationReagentVolume, we accept the option *)
		{Except[Automatic],_,_},
			{suppliedQuantificationReagentVolume,False,Null},

		(* If the resolvedDetectionMode is Fluorescence, we resolve to 200 uL or to 300 uL minus the resolvedLoadingVolume *)
		{Automatic,Fluorescence,_},
			If[
				(* IF the resolvedLoadingVolume is equal to or less than 100 uL *)
				MatchQ[resolvedLoadingVolume,LessEqualP[100*Microliter]],

				(* THEN we resolve to 200 uL *)
				{200*Microliter,False,Null},

				(* ELSE we resolve to 300 uL - resolvedLoadingVolume and set the warning Bool *)
				{(300*Microliter-resolvedLoadingVolume),True,200*Microliter}
			],

		(* If the resolvedDetectionMode is Absorbance and the AssayType is BCA, we resolve to 200 uL or to 300 uL minus the resolvedLoadingVolume *)
		{Automatic,Absorbance,BCA},
			If[
				(* IF the resolvedLoadingVolume is equal to or less than 50 uL *)
				MatchQ[resolvedLoadingVolume,LessEqualP[100*Microliter]],

				(* THEN we resolve to 250 uL *)
				{200*Microliter,False,Null},

				(* ELSE we resolve to 300 uL - resolvedLoadingVolume and set the warning Bool *)
				{(300*Microliter-resolvedLoadingVolume),True,200*Microliter}
			],

		(* In other cases, the AssayType is Bradford or Custom, we resolve to 200 uL or 300 uL minus the resolvedLoadingVolume *)
		{Automatic,_,_},
		If[
			(* IF the resolvedLoadingVolume is equal to or less than 100 uL *)
			MatchQ[resolvedLoadingVolume,LessEqualP[50*Microliter]],

			(* THEN we resolve to 200 uL *)
			{250*Microliter,False,Null},

			(* ELSE we resolve to 300 uL - resolvedLoadingVolume and set the warning Bool *)
			{(300*Microliter-resolvedLoadingVolume),True,250*Microliter}
		]
	];

	(* If loadingVolumeNonOptimalBool is True and we are throwing messages, throw a warning *)
	If[quantificationReagentVolumeNonOptimalBool&&messages&&notInEngine,
		Message[Warning::TotalProteinQuantificationQuantificationReagentVolumeLow,resolvedQuantificationReagentVolume,idealQuantificationReagentVolume,resolvedDetectionMode,resolvedAssayType,resolvedLoadingVolume]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonIdealQuantificationReagentVolumeWarning=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[!quantificationReagentVolumeNonOptimalBool,
				Nothing,
				Warning["The QuantificationReagentVolume has been automatically set to "<>ToString[resolvedQuantificationReagentVolume]<>", which is lower than "<>ToString[idealQuantificationReagentVolume]<>", the ideal volume for the DetectionMode, ("<>ToString[resolvedDetectionMode]<>"), and AssayType, ("<>ToString[resolvedAssayType]<>"), options. This is because the LoadingVolume was set to "<>ToString[resolvedLoadingVolume]<>", and the sum of the LoadingVolume and QuantificationReagentVolume cannot be larger than 300 uL.",True,False]
			];
			passingTest=If[quantificationReagentVolumeNonOptimalBool,
				Nothing,
				Warning["If left as Automatic, the QuantificationReagentVolume is ideal for the AssayType and DetectionMode.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Resolve ProteinStandards - *)
	resolvedProteinStandards=Switch[{suppliedProteinStandards,concentratedStandardOptionsSetBool,resolvedDetectionMode},

		(* If the user has specified the ProteinStandards, we accept the option *)
		{Except[Automatic],_,_},
			suppliedProteinStandards,

		(* If any of the ConcentratedProteinStandard, StandardCurveConcentrations, or ProteinStandardDiluent are set, we resolve ProteinStandards to be Null *)
		{Automatic, True,_},
			Null,

		(* Otherwise, we set the ProteinStandards based on the resolvedDetectionMode *)
		{Automatic,False,Absorbance},
			{Model[Sample,"0.125 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.25 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"0.75 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"1 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"1.5 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"],Model[Sample,"2 mg/mL Bovine Serum Albumin Standard - Quick Start BSA Standard Set"]},
		{Automatic,False,Fluorescence},
			{Model[Sample,"25 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"50 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"100 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"200 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"300 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"400 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"],Model[Sample,"500 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"]}
	];

	(* - Resolve ConcentratedProteinStandard - *)
	resolvedConcentratedProteinStandard=Switch[{suppliedConcentratedProteinStandard,resolvedProteinStandards},

		(* If the user has specified the ConcentratedProteinStandard, we accept the option *)
		{Except[Automatic],_},
			suppliedConcentratedProteinStandard,

		(* Otherwise, the option resolves based on the resolvedProteinStandards *)
		{Automatic,Null},
			Model[Sample,"2 mg/mL Bovine Serum Albumin Standard"],
		{_,_},
			Null
	];

	(* - Resolve EmissionAdjustmentSample - *)
	resolvedEmissionAdjustmentSample= Switch[{suppliedEmissionAdjustmentSample, resolvedDetectionMode},

		(* If the user has specified the option, we accept it *)
		{Except[Automatic], _},
		suppliedEmissionAdjustmentSample,

		(* Otherwise, we resolve it based on the resolvedDetectionMode *)
		{Automatic, Fluorescence},
		If[MatchQ[resolvedInstrument, ObjectP[{Model[Instrument, PlateReader, "CLARIOstar"], Model[Instrument, PlateReader, "CLARIOstar Plus with ACU"]}]],
			FullPlate,
			HighestConcentration
		],

		{_, _},
		Null
	];



	(* - Resolve the StandardCurveConcentrations - *)
	resolvedStandardCurveConcentrations=Switch[{suppliedStandardCurveConcentrations,resolvedProteinStandards,resolvedDetectionMode},

		(* If the user has specified the StandardCurveConcentrations, we accept the option *)
		{Except[Automatic],_,_},
			suppliedStandardCurveConcentrations,

		(* If the resolvedProteinStandards is Null, the option resolves based on the resolvedDetectionMode *)
		{Automatic,Null,Absorbance},
			{0.125,0.25,0.5,0.75,1,1.5,2}*(Milligram/Milliliter),
		{Automatic,Null,Fluorescence},
			{0.025,0.05,0.1,0.2,0.3,0.4,0.5}*(Milligram/Milliliter),

		(* If the resolvedProteinStandards is not Null, the option resolves to Null *)
		{_,_,_},
			Null
	];

	(* - Resolve the ProteinStandardDiluent - *)
	resolvedProteinStandardDiluent=Switch[{suppliedProteinStandardDiluent,resolvedProteinStandards},

		(* If the user has specified the ProteinStandardDiluent, we accept the option *)
		{Except[Automatic],_},
			suppliedProteinStandardDiluent,

		(* If left as Automatic, the option resolves based on the resolvedProteinStandards *)
		{Automatic,Null},
			Model[Sample, "Milli-Q water"],
		{Automatic,Except[Null]},
			Null
	];

	(* - Resolve the StandardCurveBlank - *)
	resolvedStandardCurveBlank=Switch[{suppliedStandardCurveBlank,resolvedProteinStandardDiluent,resolvedDetectionMode},

		(* If the user has specified the StandardCurveBlank, we accept the option *)
		{Except[Automatic],_,_},
			suppliedStandardCurveBlank,

		(* If the ProteinStandardDiluent has resolved to a non-Null value, set the StandardCurveBlank to that Model/Object  *)
		{Automatic,Except[Null],_},
			resolvedProteinStandardDiluent,

		(* If the StandardCurveBlank is Automatic and the ProteinStandardDiluent is Null (ie, the ProteinStandards option is not-Null), we resolve based on the DetectionMode *)
		{Automatic,Null,Absorbance},
			Model[Sample, "Milli-Q water"],
		{Automatic,Null,Fluorescence},
			Model[Sample,"0 ng/uL Bovine Serum Albumin Standard - Quant-iT Protein Assay Kit"]
	];

	(* --- UNRESOLVABLE OPTION CHECKS ---*)
	(* -- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument -- *)
	{compatibleMaterialsBool,compatibleMaterialsTests}=If[gatherTests,
		CompatibleMaterialsQ[resolvedInstrument,simulatedSamples,Cache->cache,Simulation->updatedSimulation,Output->{Result,Tests}],
		{CompatibleMaterialsQ[resolvedInstrument,simulatedSamples,Cache->cache,Simulation->updatedSimulation,Messages->messages],{}}
	];

	(* If the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption=If[Not[compatibleMaterialsBool]&&messages,
		{Instrument},
		{}
	];

	(* - Ensure that the AssayMode and DetectionMode are compatible - *)
	invalidDetectionModeOptions=If[

		(* IF the supplied AssayType and supplied Detection Mode are in conflict *)
		MatchQ[
			{resolvedAssayType,resolvedDetectionMode},
			Alternatives[
				{BCA|Bradford,Fluorescence},
				{FluorescenceQuantification,Absorbance}
			]
		],

		(* THEN the two options are in conflict *)
		{AssayType,DetectionMode},

		(*ELSE they are compatible *)
		{}
	];

	(* If the StandardCurve options are in conflict, we throw an Error *)
	If[Length[invalidDetectionModeOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationAssayTypeDetectionModeMismatch,resolvedAssayType,resolvedDetectionMode]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingDetectionModeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidDetectionModeOptions]==0,
				Nothing,
				Test["The AssayType and DetectionMode options are in conflict with each other.",True,False]
			];
			passingTest=If[Length[invalidStandardCurveOptions]!=0,
				Nothing,
				Test["The AssayType and DetectionMode options are in conflict with each other.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that none of the fluorescenceOptions are set if the AssayType is BCA or Bradford, or if the DetectionMode is Absorbance - *)
	invalidConflictingAbsorbanceOptions=If[

		(* IF AssayType is BCA or Bradford, or DetectionMode is Absorbance, AND any of the fluorescenceOptions are set, they are in conflict *)
		And[
			Or[
				MatchQ[resolvedAssayType,Alternatives[Bradford,BCA]],
				MatchQ[suppliedDetectionMode,Absorbance]
			],
			MatchQ[fluorescenceOptions,Except[{Alternatives[Null,Automatic]..}]]
		],

		(* THEN the options are in conflict *)
		Join[
			If[MatchQ[resolvedAssayType,Alternatives[Bradford,BCA]],{AssayType},{}],
			If[MatchQ[suppliedDetectionMode,Absorbance],{DetectionMode},{}],
			PickList[{ExcitationWavelength,NumberOfEmissionReadings,EmissionAdjustmentSample, EmissionReadLocation,EmissionGain},fluorescenceOptions,Except[Null|Automatic]]
		],

		(* ELSE the options are compatible *)
		{}
	];

	(* If the Fluorescence, AssayType, or DetectionMode options are in conflict when the master switches suggest Absorbance, we throw an Error *)
	If[Length[invalidConflictingAbsorbanceOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationAbsorbanceFluorescenceOptionsMismatch,invalidConflictingAbsorbanceOptions]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingAbsorbanceOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidConflictingAbsorbanceOptions]==0,
				Nothing,
				Test["The AssayType or DetectionMode option suggests an Absorbance assay, but one or more of the ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, or EmissionGain options are specified.",True,False]
			];
			passingTest=If[Length[invalidConflictingAbsorbanceOptions]!=0,
				Nothing,
				Test["The AssayType or DetectionMode option suggests an Absorbance assay, but one or more of the ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, or EmissionGain options are specified.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Ensure that none of the fluorescenceOptions are set if the AssayType is BCA or Bradford, or if the DetectionMode is Absorbance - *)
	invalidConflictingFluorescenceOptions=If[

		(* IF AssayType is FluorescenceQuantification, or DetectionMode is Fluorescence, AND any of the fluorescenceOptions are Null, they are in conflict *)
		And[
			Or[
				MatchQ[resolvedAssayType,FluorescenceQuantification],
				MatchQ[suppliedDetectionMode,Fluorescence]
			],
			MemberQ[fluorescenceOptions,Null]
		],

		(* THEN the options are in conflict *)
		Join[
			If[MatchQ[resolvedAssayType,FluorescenceQuantification],{AssayType},{}],
			If[MatchQ[suppliedDetectionMode,Fluorescence],{DetectionMode},{}],
			PickList[{ExcitationWavelength,NumberOfEmissionReadings,EmissionAdjustmentSample,EmissionReadLocation,EmissionGain},fluorescenceOptions,Null]
		],

		(* ELSE the options are compatible *)
		{}
	];

	(* If the Fluorescence, AssayType, or DetectionMode options are in conflict when the master switches suggest Fluorescence, we throw an Error *)
	If[Length[invalidConflictingFluorescenceOptions]!=0&&messages,
		Message[Error::TotalProteinQuantificationFluorescenceOptionsMismatch,invalidConflictingFluorescenceOptions]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	conflictingFluorescenceOptionsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidConflictingFluorescenceOptions]==0,
				Nothing,
				Test["The AssayType or DetectionMode option suggests a Fluorescence assay, but one or more of the ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, or EmissionGain options are Null.",True,False]
			];
			passingTest=If[Length[invalidConflictingFluorescenceOptions]!=0,
				Nothing,
				Test["The AssayType or DetectionMode option suggests a Fluorescence assay, but one or more of the ExcitationWavelength, NumberOfEmissionReadings, EmissionAdjustmentSample, EmissionReadLocation, or EmissionGain options are Null.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Define the ideal QuantificationReagents for the AssayTypes in a pattern - *)
	idealQuantificationReagentP=Alternatives[
		(* If the QuantificationReagent has not been set, it doesn't matter what the AssayType is, as it will resolve. *)
		{_,Null},
		(* If the AssayType is Custom or Automatic, we don't check *)
		{Alternatives[Custom,Automatic],_},
		(* Otherwise, the ideal QuantificationReagent is set by the AssayType *)
		{Bradford,Model[Sample, "id:XnlV5jK89053"]},
		{BCA,Model[Sample, StockSolution, "id:XnlV5jK8B0lo"]},
		{FluorescenceQuantification,Model[Sample, StockSolution, "id:O81aEBZmMje1"]}
	];

	(* - If the QuantificationReagent is not ideal for the AssayType, throw a warning - *)
	nonOptimalQuantificationReagentBool=!MatchQ[{resolvedAssayType,suppliedQuantificationReagentModel},idealQuantificationReagentP];

	(* If the supplied QuantificationReagent is not the default for the AssayType and we are throwing messages, throw a Warning *)
	If[nonOptimalQuantificationReagentBool&&messages&&notInEngine,
		Message[Warning::TotalProteinQuantificationReagentNotOptimal,ObjectToString[suppliedQuantificationReagent,Simulation -> updatedSimulation],resolvedAssayType]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonOptimalQuantificationReagentTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[nonOptimalQuantificationReagentBool,
				Warning["The supplied QuantificationReagent, "<>ObjectToString[suppliedQuantificationReagent,Simulation -> updatedSimulation]<>", is not of the default Model for the AssayType, "<>ToString[resolvedAssayType]<>".",True,False],
				Nothing
			];
			passingTest=If[nonOptimalQuantificationReagentBool,
				Warning["If supplied, the QuantificationReagent is the default for the AssayType.",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - If the QuantificationReactionTime/Temperature options are specified and the AssayType is not BCA, throw a Warning - *)
	quantificationReactionWarningQ=If[

		(* IF the QuantificationReactionTime/Temperature are specified and the AssayType is not BCA *)
		And[
			MatchQ[resolvedQuantificationReactionTime,Except[Null]],
			MatchQ[resolvedQuantificationReactionTemperature,Except[Null]],
			MatchQ[resolvedAssayType,Except[BCA]]
		],

		(* THEN we will throw a warning *)
		True,

		(* ELSE, no need - BCA assays are expected to have an incubation time before reading *)
		False
	];

	(* If quantificationReactionWarningQ is True and we are throwing messages, throw a warning *)
	If[quantificationReactionWarningQ&&messages&&notInEngine,
		Message[Warning::NonDefaultTotalProteinQuantificationReaction,resolvedQuantificationReactionTime,resolvedQuantificationReactionTemperature,resolvedAssayType]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonDefaultQuantificationReactionWarning=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[!quantificationReactionWarningQ,
				Nothing,
				Warning["The QuantificationReactionTime, "<>ToString[resolvedQuantificationReactionTime]<>", and the QuantificationReactionTemperature, "<>ToString[resolvedQuantificationReactionTemperature]<>", options are specified, but the AssayType, "<>ToString[resolvedAssayType]<>", is not BCA. Absorbance or Fluorescence values should be read quickly after mixing the reagents for the Bradford and FluorescenceQuantification assays. Please double check that these options have been correctly specified.",True,False]
			];
			passingTest=If[quantificationReactionWarningQ,
				Nothing,
				Warning["The QuantificationReactionTime, QuantificationReactionTemperature, and AssayType options are not in conflict.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Make sure that there are enough wells of the QuantificationPlate for the assay -- *)
	(* Convert numberOfReplicates such that Null->1 *)
	intNumberOfReplicates=suppliedNumberOfReplicates/.{Null->1};

	(* Find the number of input samples *)
	numberOfSamples=Length[simulatedSamples];

	(* Find the number of points there will be on the standard curve (default is 8 if things are left as automatic), and determine which Option was used to calculate this *)
	{numberOfStandardCurvePoints,standardCurvePointsOption}=If[

		(* IF the ProteinStandards has not resolved to Null *)
		!MatchQ[resolvedProteinStandards,Null],

		(* THEN the number of standard curve points is the length of ProteinStandards *)
		{Length[resolvedProteinStandards],ProteinStandards},

		(* ELSE the number of standard curve points is the length of StandardCurveConcentrations *)
		{Length[resolvedStandardCurveConcentrations],StandardCurveConcentrations}
	];

	(* Calculate the number of wells needed *)
	totalNumberOfWells=((numberOfSamples*intNumberOfReplicates)+((numberOfStandardCurvePoints+1)*suppliedStandardCurveReplicates));

	(* If totalNumberOfWells is larger than 96, the options are invalid *)
	invalidReplicatesOptions=If[

		(* IF we require more than 96 wells *)
		totalNumberOfWells>96,

		(* THEN the options are invalid, which options are invalid depends on the standardCurvePointsOption *)
		If[MatchQ[standardCurvePointsOption,ProteinStandards],
			{NumberOfReplicates,ProteinStandards,StandardCurveReplicates},
			{NumberOfReplicates,StandardCurveConcentrations,StandardCurveReplicates}
		],

		(* ELSE the options are fine *)
		{}
	];

	(* If invalidReplicatesOptions contains anything and we are throwing messages, throw an error *)
	Which[
		(* Case in which there are invalid options and ProteinStandards is one of them *)
		Length[invalidReplicatesOptions]>0&&MatchQ[standardCurvePointsOption,ProteinStandards]&&messages,
			Message[Error::NotEnoughTotalProteinQuantificationWellsAvailable,numberOfSamples,intNumberOfReplicates,standardCurvePointsOption,numberOfStandardCurvePoints,suppliedStandardCurveReplicates,totalNumberOfWells],

		(* Case in which there are invalid options and ProteinStandards is one of them *)
		Length[invalidReplicatesOptions]>0&&MatchQ[standardCurvePointsOption,StandardCurveConcentrations]&&messages,
			Message[Error::NotEnoughTotalProteinQuantificationWellsAvailable,numberOfSamples,intNumberOfReplicates,standardCurvePointsOption,numberOfStandardCurvePoints,suppliedStandardCurveReplicates,totalNumberOfWells],

		(* Otherwise, throw no Error *)
		True,
			Null
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidReplicatesTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidReplicatesOptions]==0,
				Nothing,
				If[MatchQ[standardCurvePointsOption,ProteinStandards],
					(* The failing test we show depends on what the standardCurvePointsOption is *)
					Test["The (number of input samples times the NumberOfReplicates) plus (the (length of ProteinStandards +1) times the StandardCurveReplicates) is "<>ToString[totalNumberOfWells]<>", which is larger than 96. A maximum of 96 wells can be filled in the QuantificationPlate in the assay.",True,False],
					Test["The (number of input samples times the NumberOfReplicates) plus (the (length of StandardCurveConcentrations +1) times the StandardCurveReplicates) is "<>ToString[totalNumberOfWells]<>", which is larger than 96. A maximum of 96 wells can be filled in the QuantificationPlate in the assay.",True,False]
				]
			];
			passingTest=If[Length[invalidReplicatesOptions]==0,
				Test["There are enough available wells in the QuantificationPlate for the assay.",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- If resolvedProteinStandards is Null, and the concentratedProteinStandardConcentration is not Null (if it is Null we already would have thrown an Error), check to make sure that the resolvedStandardCurveConcentrations and resovledConcentratedProteinStandard are cool (that the conc of the conc protein standard is equal to or larger than any of the standard curve concentrations) -- *)
	(* First, set a boolean that determines if we actually need to make this check *)
	standardCurveConcentrationsCheckQ=If[

		(* IF resolvedProteinStandards is Null and the concentratedProteinStandardConcentration is not Null, THEN we need to do the check, otherwise we don't *)
		MatchQ[resolvedProteinStandards,Null]&&MatchQ[concentratedProteinStandardConcentration,Except[Null]],
		True,
		False
	];

	(* Change Automatic to 2 mg/mL if the option has not been specified *)
	concentratedProteinStandardConcentrationNoAutomatic=(concentratedProteinStandardConcentration/.{Automatic->2*Milligram/Milliliter});

	(* Figure out which of the StandardCurveConcentrations are greater than the concentration of the ConcentratedProteinStandard (or greater than 2 mg/mL if ConcentratedProteinStandard was left as automatic) *)
	invalidStandardCurveConcentrations=If[

		(* IF we don't need to perform this check as described above, THEN the StandardCurveConcentrations are fine *)
		!standardCurveConcentrationsCheckQ,
		{},

		(* ELSE, pick the ones that are larger than the concentratedProteinStandardConcentrationNoAutomatic  *)
		Cases[resolvedStandardCurveConcentrations,GreaterP[concentratedProteinStandardConcentrationNoAutomatic]]
	];


	(* Define the options that are invalid *)
	invalidStandardCurveConcentrationOptions=If[Length[invalidStandardCurveConcentrations]!=0,
		{StandardCurveConcentrations,ConcentratedProteinStandard},
		{}
	];

	(* If the StandardCurveConcentration options are in conflict, we throw an Error *)
	If[Length[invalidStandardCurveConcentrationOptions]!=0&&messages,
		Message[Error::InvalidTotalProteinConcentratedProteinStandardOptions,ObjectToString[resolvedConcentratedProteinStandard,Simulation -> updatedSimulation],concentratedProteinStandardConcentrationNoAutomatic,invalidStandardCurveConcentrations]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	standardCurveConcentrationsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidStandardCurveConcentrations]==0,
				Nothing,
				Test["The ConcentratedProteinStandard, "<>ObjectToString[resolvedConcentratedProteinStandard,Simulation -> updatedSimulation]<>", has a MassConcentration (in the Composition field) or TotalProteinConcentration of "<>ToString[concentratedProteinStandardConcentrationNoAutomatic]<>". The following members of StandardCurveConcentrations, "<>ToString[invalidStandardCurveConcentrations]<>", are larger than this value - and thus the ConcentratedProteinStandard cannot be diluted to these concentrations.",True,False]
			];
			passingTest=If[Length[invalidStandardCurveConcentrations]!=0,
				Nothing,
				Test["If not Null, the concentration of the ConcentratedProteinStandard is larger to or equal to all of the members of StandardCurveConcentrations.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check to see if we can actually reach the resolvedStandardCurveConcentrations from the ConcentratedProteinStandard, if applicable - *)
	invalidTooLowStandardCurveConcentrations=If[

		(* IF we don't need to perform this check as described above, THEN the StandardCurveConcentrations are fine *)
		!standardCurveConcentrationsCheckQ,
		{},

		(* ELSE, pick the ones that are smaller than the concentratedProteinStandardConcentrationNoAutomatic divided by 400 (the smallest dilution we can perform using micro sample manipulation with a total volume to 200 uL)  *)
		Cases[resolvedStandardCurveConcentrations,LessP[(concentratedProteinStandardConcentrationNoAutomatic)/400]]
	];


	(* Define the options that are invalid *)
	invalidTooLowStandardCurveConcentrationOptions=If[Length[invalidTooLowStandardCurveConcentrations]!=0,
		{StandardCurveConcentrations,ConcentratedProteinStandard},
		{}
	];

	(* If the StandardCurveConcentration options has values that are too low for the ConcentratedProteinStandard, we throw an Error *)
	If[Length[invalidTooLowStandardCurveConcentrationOptions]!=0&&messages,
		Message[Error::TotalProteinStandardCurveConcentrationsTooLow,ObjectToString[resolvedConcentratedProteinStandard,Simulation -> updatedSimulation],concentratedProteinStandardConcentrationNoAutomatic,invalidTooLowStandardCurveConcentrations]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	standardCurveConcentrationsTooLowTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidTooLowStandardCurveConcentrations]==0,
				Nothing,
				Test["The ConcentratedProteinStandard, "<>ObjectToString[resolvedConcentratedProteinStandard,Simulation -> updatedSimulation]<>", has a MassConcentration (in the Composition field) or TotalProteinConcentration of "<>ToString[concentratedProteinStandardConcentrationNoAutomatic]<>". The following members of StandardCurveConcentrations, "<>ToString[invalidTooLowStandardCurveConcentrations]<>", are larger than this value divided by 400 - and thus the ConcentratedProteinStandard cannot be diluted to these concentrations.",True,False]
			];
			passingTest=If[Length[invalidTooLowStandardCurveConcentrations]!=0,
				Nothing,
				Test["If not Null, the concentration of the ConcentratedProteinStandard at most 400 times larger than the smallest member of StandardCurveConcentrations.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- If resolvedDetectionMode is Fluorescence, check to make sure that the lowest member of resolvedQuantificationWavelength is at least 25 nm larger than the resolvedExcitationWavelength -- *)
	(* - First, determine the lowest member of resolvedQuantificationWavelength- *)
	lowestResolvedQuantificationWavelength=Which[

	(* Case where suppliedQuantificationWavelength is a single - it is the lowest *)
		MatchQ[Head[resolvedQuantificationWavelength],Quantity],
		resolvedQuantificationWavelength,

	(* Case where suppliedQuantificationWavelength is a list, lowest is the smallest in the list *)
		MatchQ[Head[resolvedQuantificationWavelength],List],
		First[Sort[resolvedQuantificationWavelength]],

	(* Case where suppliedQuantificationWavelength is a span, lowest is the first in the span *)
		MatchQ[Head[resolvedQuantificationWavelength],Span],
		First[resolvedQuantificationWavelength]
	];

	(* Check to see if the QuantificationWavelength and ExcitationWavelength options are compatible *)
	invalidResolvedExcitationWavelengthOptions=If[

		(* IF resolvedDetectionMode is Absorbance OR the ExcitationWavelength has been set to Null *)
		Or[
			MatchQ[resolvedDetectionMode,Absorbance],
			MatchQ[resolvedExcitationWavelength,Null]
		],

		(* THEN no options are invalid *)
		{},

		(* ELSE, need to check if the options are invalid *)
		If[
			(* IF the ExcitationWavelength is less than 25 nm smaller than the lowest QuantificationWavelength AND not both of these options were set *)
			And[
				(lowestResolvedQuantificationWavelength-resolvedExcitationWavelength)<25*Nanometer,
					Or[
						MatchQ[suppliedExcitationWavelength,Except[Null,Automatic]],
						MatchQ[suppliedQuantificationWavelength,Except[Null,Automatic]]
					]
				],

			(* THEN the options are in conflict *)
			{ExcitationWavelength,QuantificationWavelength},

			(* ELSE they're compatible *)
			{}
		]
	];

	(* If invalidResolvedExcitationWavelengthOptions is not {} and we are throwing messages, throw an Error *)
	If[Length[invalidResolvedExcitationWavelengthOptions]!=0&&messages&&MatchQ[resolvedExcitationWavelength,Except[Null]],
		Message[Error::InvalidTotalProteinResolvedExcitationWavelength,lowestResolvedQuantificationWavelength,resolvedExcitationWavelength]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidResolvedExcitationWavelengthTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidResolvedExcitationWavelengthOptions]==0||MatchQ[resolvedExcitationWavelength,Except[Null]],
				Nothing,
				Test["The lowest member of the supplied QuantificationWavelength option, "<>ToString[lowestResolvedQuantificationWavelength]<>", is less than 25 nm larger than the automatically resolved ExcitationWavelength "<>ToString[resolvedExcitationWavelength]<>".",True,False]
			];
			passingTest=If[Length[invalidResolvedExcitationWavelengthOptions]!=0||MatchQ[resolvedDetectionMode,Absorbance]||MatchQ[resolvedExcitationWavelength,Except[Null]],
				Nothing,
				Test["The lowest member of the supplied QuantificationWavelength option is at least 25 nm larger than the automatically resolved ExcitationWavelength.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- If resolvedDetectionMode is Fluorescence, check to make sure that the largest member of resolvedQuantificationWavelength is no larger than 740 nm -- *)
	(* - First, determine the largest member of resolvedQuantificationWavelength- *)
	largestResolvedQuantificationWavelength=Which[

		(* Case where suppliedQuantificationWavelength is a single - it is the lowest *)
		MatchQ[Head[resolvedQuantificationWavelength],Quantity],
		resolvedQuantificationWavelength,

		(* Case where suppliedQuantificationWavelength is a list, lowest is the smallest in the list *)
		MatchQ[Head[resolvedQuantificationWavelength],List],
		Last[Sort[resolvedQuantificationWavelength]],

		(* Case where suppliedQuantificationWavelength is a span, lowest is the first in the span *)
		MatchQ[Head[resolvedQuantificationWavelength],Span],
		Last[resolvedQuantificationWavelength]
	];

	(* Check to see if the QuantificationWavelength option is too high for DetectionMode of Fluorescence *)
	invalidFluorescenceQuantificationWavelengthOption=If[

		(* IF the DetectionMode option is Absorbance *)
		MatchQ[resolvedDetectionMode,Absorbance],

		(* THEN the QuantificationWavelength option is not invalid *)
		{},

		(* ELSE, we need to check if the option in invalid *)
		If[

			(* IF the largest member of the QuantificationWavelength option is larger than 740 nm *)
			(largestResolvedQuantificationWavelength>740*Nanometer),

			(* THEN the QuantificationWavelength option is invalid *)
			{QuantificationWavelength},

			(* ELSE the option is fine *)
			{}
		]
	];

	(* If invalidFluorescenceQuantificationWavelengthOption is not {} and we are throwing messages, throw an Error *)
	If[Length[invalidFluorescenceQuantificationWavelengthOption]!=0&&messages,
		Message[Error::InvalidTotalProteinFluorescenceQuantificationWavelength,largestResolvedQuantificationWavelength]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidFluorescenceQuantificationWavelengthTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidFluorescenceQuantificationWavelengthOption]==0,
				Nothing,
				Test["The largest member of the supplied QuantificationWavelength option, "<>ToString[largestResolvedQuantificationWavelength]<>", is longer than 740 nanometers, the longest possible QuantificationWavelength when DetectionMode is Fluorescence.",True,False]
			];
			passingTest=If[Length[invalidFluorescenceQuantificationWavelengthOption]!=0||MatchQ[resolvedDetectionMode,Absorbance],
				Nothing,
				Test["The largest member of the QuantificationWavelength option is at most 740 nanometers, the longest possible QuantificationWavelength when DetectionMode is Fluorescence.",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(*Check that the SamplesInStorageCondition is compatible with any samples sharing the same container.*)
	{invalidSamplesInStorageConditionResults, invalidSamplesInStorageConditionTests} = ValidContainerStorageConditionQ[simulatedSamples,Lookup[experimentOptions,SamplesInStorageCondition],Cache->cache, Simulation -> updatedSimulation,Output->{Result, Tests}];
	invalidSamplesInStorageConditionOption = If[MemberQ[invalidSamplesInStorageConditionResults,False]||MatchQ[invalidSamplesInStorageConditionResults,False],{SamplesInStorageCondition},{}];

	(*Check that the resolvedProtienStandards storage conditions are compatible for samples sharing the same container*)
	(*First exapnd the ProteinStandardsStorageConditionOption because the validQ function below requires index matched inputs*)
	expandedProteinStandardsStorageConditions = If[MatchQ[resolvedProteinStandards,Except[Null]]&&MatchQ[Lookup[experimentOptions,ProteinStandardsStorageCondition],Null|SampleStorageTypeP|Disposal],
		ConstantArray[Lookup[experimentOptions,ProteinStandardsStorageCondition],Length[resolvedProteinStandards]],
		Lookup[experimentOptions,ProteinStandardsStorageCondition]
	];

	{invalidProteinStandardsStorageConditionResults, invalidProteinStandardsStorageConditionTests} = If[!MatchQ[resolvedProteinStandards,Null],
		ValidContainerStorageConditionQ[Cases[resolvedProteinStandards,ObjectP[Object[Sample]]],PickList[expandedProteinStandardsStorageConditions,resolvedProteinStandards,ObjectP[Object[Sample]]],Cache->cache, Simulation -> updatedSimulation,Output->{Result,Tests}],
		ValidContainerStorageConditionQ[{},{},Output->{Result,Tests}]
	];
	invalidProteinStandardsStorageConditionOption = If[MemberQ[invalidProteinStandardsStorageConditionResults,False]||MatchQ[invalidProteinStandardsStorageConditionResults,False],{ProteinStandardsStorageCondition},{}];

	(*Check that the resolvedConcentratedProtienStandard storage condition is compatible for samples sharing the same container*)
	{invalidConcentratedProteinStandardStorageConditionResults, invalidConcentratedProteinStandardStorageConditionTests} = If[MatchQ[resolvedConcentratedProteinStandard, ObjectP[Object[Sample]]],
		ValidContainerStorageConditionQ[resolvedConcentratedProteinStandard,Lookup[experimentOptions,ConcentratedProteinStandardStorageCondition],Cache->cache,Simulation->updatedSimulation,Output->{Result,Tests}],
		ValidContainerStorageConditionQ[{},{},Output->{Result,Tests}]
	];
	invalidConcentratedProteinStandardStorageConditionOption = If[MemberQ[invalidConcentratedProteinStandardStorageConditionResults,False]||MatchQ[invalidConcentratedProteinStandardStorageConditionResults,False],{ConcentratedProteinStandStorageCondition},{}];

	(*Check that if the protein standards are Null the storage condition is also Null*)
	conflictingProteinStandardStorage = If[MatchQ[resolvedProteinStandards,Null] && MatchQ[expandedProteinStandardsStorageConditions,{SampleStorageTypeP|Null|Disposal..}|SampleStorageTypeP|Disposal], True, False];
	conflictingProteinStandardStorageOptions = If[MatchQ[conflictingProteinStandardStorage,True],{ProteinStandardsStorageCondition,ProteinStandards},{}];

	If[conflictingProteinStandardStorage==True&&messages,
		Message[Error::ConflictingStandardsStorageCondition,First[conflictingProteinStandardStorageOptions],Last[conflictingProteinStandardStorageOptions]]
	];

	conflictingProteinStandardStorageTests = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[conflictingProteinStandardStorage,False],
				Nothing,
				Test["The ProteinStandards and ProteinStandardsStorageConditions are compatible.",True,False]
			];
			passingTest=If[MatchQ[conflictingProteinStandardStorage,True],
				Nothing,
				Test["The ProteinStandards and ProteinStandardsStorageConditions are compatible.",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*Check that if the concentrated protein standard is Null the storage condition is also Null*)
	conflictingConcProteinStandardStorage = If[MatchQ[resolvedConcentratedProteinStandard,Null] && MatchQ[Lookup[experimentOptions,ConcentratedProteinStandardStorageCondition],SampleStorageTypeP|Disposal], True, False];
	conflictingConcProteinStandardStorageOptions = If[MatchQ[conflictingConcProteinStandardStorage,True],{ConcentratedProteinStandardStorageCondition,ConcentratedProteinStandard},{}];
	If[conflictingConcProteinStandardStorage==True&&messages,
		Message[Error::ConflictingStandardsStorageCondition,First[conflictingConcProteinStandardStorageOptions],Last[conflictingConcProteinStandardStorageOptions]]
	];
	conflictingConcProteinStandardStorageTests = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[conflictingConcProteinStandardStorage,False],
				Nothing,
				Test["The ConcentratedProteinStandard and ConcentratedProteinStandardStorageCondition are compatible.",True,False]
			];
			passingTest=If[MatchQ[conflictingConcProteinStandardStorage,True],
				Nothing,
				Test["The ConcentratedProteinStandard and ConcentratedProteinStandardStorageCondition are compatible.",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. -- *)
	invalidInputs=DeleteDuplicates[Flatten[{discardedInvalidInputs,tooManyInvalidInputs}]];
	invalidOptions=DeleteDuplicates[Flatten[
		{
			nameInvalidOption,invalidStandardCurveOptions,invalidDetectionModeOptions,invalidConflictingAbsorbanceOptions,invalidConflictingFluorescenceOptions,invalidFluorescenceMismatchOptions,
			invalidSpanQuantificationWavelengthOption,invalidListQuantificationWavelengthOptions,invalidExcitationWavelengthOptions,invalidVolumeOptions,invalidUnsupportedInstrumentOption,invalidInstrumentOptions,invalidFluorescenceInstrumentOptions,
			invalidQuantificationReactionOptions,invalidConcentratedProteinStandardOption,invalidProteinStandardsOption,compatibleMaterialsInvalidOption,invalidReplicatesOptions,
			invalidStandardCurveConcentrationOptions,invalidTooLowStandardCurveConcentrationOptions,invalidResolvedExcitationWavelengthOptions,invalidFluorescenceQuantificationWavelengthOption,customAssayTypeQuantificationReagentInvalidOptions,
			invalidSamplesInStorageConditionOption,invalidProteinStandardsStorageConditionOption,invalidConcentratedProteinStandardStorageConditionOption,conflictingProteinStandardStorageOptions,
			conflictingConcProteinStandardStorageOptions
		}
	]];

	(*  Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation -> updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* - Resolve Aliquot Options - *)

	(* Set the RequiredAliquotAmount option to pass to resolveAliquotOptions, which is the loading volume plus 15 uL *)
	requiredAliquotAmounts=Table[(resolvedLoadingVolume+15*Microliter),Length[simulatedSamples]];

	(* - Make a list of the smallest liquid handler compatible container that can potentially hold the needed volume for each sample - *)
	(* First, find the Models and the MaxVolumes of the liquid handler compatible containers *)
	{liquidHandlerContainerModels,liquidHandlerContainerMaxVolumes}=Transpose[Lookup[
		Flatten[liquidHandlerContainerPackets,1],
		{Object,MaxVolume}
	]];

	(* Define the container we would transfer into for each sample, if Aliquotting needed to happen *)
	potentialAliquotContainers=First[
		PickList[
			liquidHandlerContainerModels,
			liquidHandlerContainerMaxVolumes,
			GreaterEqualP[#]
		]
	]&/@requiredAliquotAmounts;

	(* Find the ContainerModel for each input sample *)
	simulatedSamplesContainerModels=Lookup[sampleContainerPackets,Model,{}][Object];

	(* Define the RequiredAliquotContainers - we have to aliquot if the samples are not in a liquid handler compatible container *)
	requiredAliquotContainers=MapThread[
		If[
			MatchQ[#1,Alternatives@@liquidHandlerContainerModels],
			Automatic,
			#2
		]&,
		{simulatedSamplesContainerModels,potentialAliquotContainers}
	];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,

		(* Case where output includes tests *)
		resolveAliquotOptions[
			ExperimentTotalProteinQuantification,
			mySamples,
			simulatedSamples,
			ReplaceRule[allOptionsRounded,resolvedSamplePrepOptions],
			Cache->cache,
			Simulation->updatedSimulation,
			RequiredAliquotContainers->requiredAliquotContainers,
			RequiredAliquotAmounts->requiredAliquotAmounts,
			AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
			Output->{Result,Tests}
		],

		(* Case where we are not gathering tests  *)
		{
			resolveAliquotOptions[
				ExperimentTotalProteinQuantification,
				mySamples,
				simulatedSamples,
				ReplaceRule[allOptionsRounded,resolvedSamplePrepOptions],
				Cache->cache,
				Simulation->updatedSimulation,
				RequiredAliquotContainers->requiredAliquotContainers,
				RequiredAliquotAmounts->requiredAliquotAmounts,
				AliquotWarningMessage->"because the input samples need to be in containers that are compatible with the robotic liquid handlers.",
				Output->Result
			],{}
		}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[allOptionsRounded];

	(* get the resolved Email option; for this experiment. the default is True *)
	email=If[MatchQ[Lookup[allOptionsRounded,Email],Automatic],
		True,
		Lookup[allOptionsRounded,Email]
	];

	(* - Define the resolved options that we will output - *)
	resolvedOptions=ReplaceRule[
		allOptionsRounded,
		Join[
			resolvedSamplePrepOptions,
			resolvedAliquotOptions,
			resolvedPostProcessingOptions,
			{
				AssayType->resolvedAssayType,
				DetectionMode->resolvedDetectionMode,
				Instrument->resolvedInstrument,
				ProteinStandards->resolvedProteinStandards,
				ConcentratedProteinStandard->resolvedConcentratedProteinStandard,
				StandardCurveConcentrations->resolvedStandardCurveConcentrations,
				ProteinStandardDiluent->resolvedProteinStandardDiluent,
				StandardCurveBlank->resolvedStandardCurveBlank,
				LoadingVolume->resolvedLoadingVolume,
				QuantificationReagent->resolvedQuantificationReagent,
				QuantificationReagentVolume->resolvedQuantificationReagentVolume,
				QuantificationReactionTime->resolvedQuantificationReactionTime,
				QuantificationReactionTemperature->resolvedQuantificationReactionTemperature,
				ExcitationWavelength->resolvedExcitationWavelength,
				QuantificationWavelength->resolvedQuantificationWavelength,
				NumberOfEmissionReadings->resolvedNumberOfEmissionReadings,
				EmissionReadLocation->resolvedEmissionReadLocation,
				EmissionAdjustmentSample->resolvedEmissionAdjustmentSample,
				EmissionGain->resolvedEmissionGain
			}
		],
		Append->False
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> Cases[
			Flatten[
				{
					optionPrecisionTests,discardedTests,tooManyInputsTests,validNameTest,conflictingStandardCurveOptionsTests,conflictingDetectionModeTests,conflictingAbsorbanceOptionsTests,conflictingFluorescenceOptionsTests,
					conflictingFluorescenceMismatchOptionsTests,nonOptimalQuantificationReagentTests,invalidSpanTests,wavelengthMismatchTests,volumeMismatchTests,lowTotalVolumeWarning,unsupportedInstrumentTests,invalidInstrumentTests,
					conflictingInstrumentFluorescenceOptionsTests,conflictingQuantificationReactionOptionsTests,invalidConcentratedProteinStandardTests,invalidProteinStandardTests,
					invalidQuantificationWavelengthListTests,duplicateProteinStandardsWarning,uniqueProteinIDModelsWarning,
					nonIdealLoadingVolumeWarning,nonIdealQuantificationReagentVolumeWarning,compatibleMaterialsTests,invalidReplicatesTests,standardCurveConcentrationsTests,invalidAssayTypeTests,
					standardCurveConcentrationsTooLowTests,invalidResolvedExcitationWavelengthTests,invalidFluorescenceQuantificationWavelengthTests,nonDefaultQuantificationReactionWarning,aliquotTests,
					invalidSamplesInStorageConditionTests,invalidProteinStandardsStorageConditionTests,invalidConcentratedProteinStandardStorageConditionTests,conflictingConcProteinStandardStorageTests,
					conflictingProteinStandardStorageTests
				}
			]
			,_EmeraldTest
		]
	}
];



(* ::Subsubsection:: *)
(* tpqResourcePackets *)


(* --- tpqResourcePackets --- *)

DefineOptions[
	tpqResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

tpqResourcePackets[mySamples:ListableP[ObjectP[Object[Sample]]],myTemplatedOptions:{(_Rule|_RuleDelayed)...},myResolvedOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		expandedInputs,expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,protocolID,liquidHandlerContainers,

		numberOfReplicates,instrument,name,assayType,detectionMode,proteinStandards,concentratedProteinStandard,standardCurveConcentrations,proteinStandardDiluent,
		standardCurveBlank,standardCurveReplicates,loadingVolume,quantificationReagent,quantificationReagentVolume,quantificationReactionTime,quantificationReactionTemperature,excitationWavelength,quantificationWavelength,
		quantificationTemperature,quantificationEquilibrationTime,numberOfEmissionReadings,emissionReadLocation,emissionAdjustmentSample,emissionGain,parentProtocol,

		concentratedProteinStandardDownloadObject,concentratedProteinStandardDownloadFields,uniqueProteinStandardObjects,uniqueProteinStandardModels,uniqueProteinStandardObjectDownloadFields,
		uniqueProteinStandardModelDownloadFields,

		listedProteinStandardObjectPackets,listedProteinStandardModelPackets,listedSampleContainers,liquidHandlerContainerDownload,concentratedProteinStandardPacket,
		sampleContainersIn,liquidHandlerContainerMaxVolumes,concentratedProteinStandardConcentration,intNumberOfReplicates,samplesWithReplicates,optionsWithReplicates,expandedAliquotAmounts,
		samplesInStorageCondition,

		concentratedProteinStandardDilutionFactors,concentratedProteinStandardVolumes,proteinStandardDiluentVolumes,expandedLoadingOrAliquotVolumes,sampleVolumeRules,numberOfStandardCurvePoints,numberOfWellsUsed,
		uniqueSampleVolumeRules,sampleResourceReplaceRules,

		quantificationReagentVolumeRule,proteinStandardsVolumeRules,standardCurveBlankVolumeRule,concentratedProteinStandardVolumeRule,proteinStandardDiluentVolumeRule,allVolumeRules,
		uniqueObjectsAndVolumesAssociation,uniqueResources,uniqueObjects,uniqueObjectResourceReplaceRules,samplesInResources,proteinStandardsResources,quantificationReagentResource,
		concentratedProteinStandardResource,proteinStandardDiluentResource,standardCurveBlankResource,standardDilutionPlateResource,quantificationPlateResource,instrumentResource,

		sortedQuantificationWavelengths,proteinStandardModelConcentrations,proteinStandardObjectTotalProteinConcentrations,proteinStandardObjectMassConcentrations,proteinStandardObjectConcentrations,
		proteinStandardModelConcentrationReplaceRules,proteinStandardObjectConcentrationReplaceRules,proteinStandardConcentrationReplaceRules,proteinStandardConcentrations,
		standardCurveConcentrationsField,	emissionWavelengthRange,adjustmentEmissionWavelength,

		proteinStandardsStorageConditions,concProteinStandardStorageCondition,

		protocolPacket,prepPacket,finalizedPacket,allResourceBlobs,resourcesOk,resourceTests,previewRule,optionsRule,testsRule,resultRule, simulation
	},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentTotalProteinQuantification, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentTotalProteinQuantification,
		RemoveHiddenOptions[ExperimentTotalProteinQuantification,myResolvedOptions],
		Ignore->myTemplatedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests; if True, then silence the messages *)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(* get the inherited cache *)
	inheritedCache = Lookup[ToList[ops],Cache,{}];
	simulation=Lookup[ToList[ops], Simulation, Simulation[]];

	(* Generate an ID for the new protocol *)
	protocolID=CreateID[Object[Protocol,TotalProteinQuantification]];

	(* Get all containers which can fit on the liquid handler - many of our resources are in one of these containers *)
	(* In case we need to prepare the resource add 0.5mL tube in 2 mL skirt to the beginning of the list (Engine uses the first requested container if it has to transfer or make a stock solution) *)
	liquidHandlerContainers=hamiltonAliquotContainers["Memoization"];

	(* Pull out relevant non-index matched options from the re-expanded options *)
	{
		numberOfReplicates,instrument,name,assayType,detectionMode,proteinStandards,concentratedProteinStandard,standardCurveConcentrations,proteinStandardDiluent,standardCurveBlank,standardCurveReplicates,loadingVolume,
		quantificationReagent,quantificationReagentVolume,quantificationReactionTime,quantificationReactionTemperature,excitationWavelength,quantificationWavelength,quantificationTemperature,
		quantificationEquilibrationTime,numberOfEmissionReadings,emissionReadLocation,emissionAdjustmentSample,emissionGain,parentProtocol

	}=
			Lookup[expandedResolvedOptions,
				{
					NumberOfReplicates,Instrument,Name,AssayType,DetectionMode,ProteinStandards,ConcentratedProteinStandard,StandardCurveConcentrations,ProteinStandardDiluent,StandardCurveBlank,StandardCurveReplicates,
					LoadingVolume,QuantificationReagent,QuantificationReagentVolume,QuantificationReactionTime,QuantificationReactionTemperature,ExcitationWavelength,QuantificationWavelength,QuantificationTemperature,
					QuantificationEquilibrationTime,NumberOfEmissionReadings,EmissionReadLocation,EmissionAdjustmentSample,EmissionGain,ParentProtocol
				},
				Null
			];


	(* -- Figure out what fields and objects to download from -- *)
	(* - ConcentratedProteinStandard - *)
	(* Determine which object (or Nothing) we will download from for the ConcentratedProteinStandard option *)
	concentratedProteinStandardDownloadObject=If[

		(* IF the option has resovled to Null *)
		MatchQ[concentratedProteinStandard,Null],

		(* THEN we download from Nothing *)
		Nothing,

		(* ELSE, we download from the Object/Model *)
		concentratedProteinStandard
	];

	(* For the ConcentratedProteinStandard we have resolved to, we have to download information about the Concentration *)
	concentratedProteinStandardDownloadFields=Which[
		(* IF the option has resolved to a Model, then we download the InitialMassConcentration *)
		MatchQ[concentratedProteinStandard,ObjectP[Model[Sample]]],
			Packet[Composition,Analytes,Sequence@@SamplePreparationCacheFields[Model[Sample]]],

		(* IF the option has resolved to an Object, then we download the MassConcentration and TotalProteinConcentration *)
		MatchQ[concentratedProteinStandard,ObjectP[Object[Sample]]],
			Packet[Object,Composition,Analytes,TotalProteinConcentration,Sequence@@SamplePreparationCacheFields[Object[Sample]]],

		(* IF the option has resolved to Null (all other cases), then we download Nothing *)
		True,
			Nothing
	];

	(* - ProteinStandards - *)
	(* Make lists of the unique ProteinStandard Objects and Models (will download different fields from the two cases) - later will make replace rules to find a list of the concentrations *)
	uniqueProteinStandardObjects=DeleteDuplicates[Cases[ToList[proteinStandards],ObjectP[Object]]];
	uniqueProteinStandardModels=DeleteDuplicates[Cases[ToList[proteinStandards],ObjectP[Model]]];

	(* Define the fields that we want to download from the unique ProteinStandard Objects and Models *)
	uniqueProteinStandardObjectDownloadFields=Packet[Object,Composition,Analytes,TotalProteinConcentration,Sequence@@SamplePreparationCacheFields[Object[Sample]]];
	uniqueProteinStandardModelDownloadFields=Packet[Object,Composition,Analytes,Sequence@@SamplePreparationCacheFields[Model[Sample]]];

	(* Make a Download call to get the containers of the input samples *)
	{listedSampleContainers,liquidHandlerContainerDownload,concentratedProteinStandardPacket,listedProteinStandardObjectPackets,listedProteinStandardModelPackets}=Quiet[
		Download[
			{
				mySamples,
				liquidHandlerContainers,
				{concentratedProteinStandardDownloadObject},
				uniqueProteinStandardObjects,
				uniqueProteinStandardModels
			},
			{
				{Container[Object]},
				{MaxVolume},
				{concentratedProteinStandardDownloadFields},
				{uniqueProteinStandardObjectDownloadFields},
				{uniqueProteinStandardModelDownloadFields}
			},
			Cache->inheritedCache,
			Simulation -> simulation,
			Date->Now
		],
		{Download::FieldDoesntExist}
	];

	(* Find the list of input sample and antibody containers *)
	sampleContainersIn=DeleteDuplicates[Flatten[listedSampleContainers]];

	(* Find the MaxVolume of all of the liquid handler compatible containers *)
	liquidHandlerContainerMaxVolumes=Flatten[liquidHandlerContainerDownload,1];

	(* Helper function that gets the total MassConcentration of the protein components from the composition field. *)
	totalProteinMassConcentration[packet_]:=Module[{delistedPacket,modelComposition,allProteinComponents,allProteinAmounts},
		delistedPacket=If[MatchQ[packet,_List],
			First[Flatten[packet]],
			packet
		];

		modelComposition=Lookup[delistedPacket,Composition];

		(* Get all protein components *)
		allProteinComponents=Cases[modelComposition,{_,ObjectP[Model[Molecule,Protein]]}];

		allProteinAmounts=Cases[allProteinComponents[[All,1]],MassConcentrationP];

		If[Length[allProteinAmounts]==0,
			Null,
			Total[allProteinAmounts]
		]
	];

	(* - Find the concentration of the resolved ConcentratedProteinStandard that we will use to figure out how much we need to dilute the standard for each point on the StandardCurve - *)
	(* Find the TotalProteinConcentration or MassConcentration of the Object, or the InitialMassConcentration of the Model *)
	concentratedProteinStandardConcentration=Which[

		(* If the option was left as Automatic, we define this Concentration as Null *)
		MatchQ[concentratedProteinStandardPacket,{}],
		Null,

		(* If the option was specified as a Model, define this as the total mass concentration of the Model *)
		MatchQ[concentratedProteinStandard,ObjectP[Model[Sample]]],
		totalProteinMassConcentration[concentratedProteinStandardPacket],

		(* If the option was specified as a Model, define this as the TotalProteinConcentration if it is not Null, otherwise the MassConcentration *)
		MatchQ[concentratedProteinStandard,ObjectP[Object[Sample]]],
		If[
		(*IF the TotalProteinConcentration is Null *)
			MatchQ[First[ToList[Lookup[Flatten[concentratedProteinStandardPacket],TotalProteinConcentration]]],Null],

		(* THEN we set the concentration to the MassConcentration *)
			totalProteinMassConcentration[concentratedProteinStandardPacket],

		(* ELSE we set the concentration to the TotalProteinConcentration *)
			First[ToList[Lookup[Flatten[concentratedProteinStandardPacket],TotalProteinConcentration]]]
		]
	];

	(* -- Expand inputs and index-matched options (of which there are none) to take into account the NumberOfReplicates option -- *)
	(* intNumberOfReplicates replaces Null with 1 for calculation purposes in number of replicates *)
	intNumberOfReplicates=numberOfReplicates/.{Null->1};

	(* - Expand the index-matched inputs for the NumberOfReplicates - *)
	{samplesWithReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentTotalProteinQuantification,mySamples,expandedResolvedOptions];

	{
		expandedAliquotAmounts,samplesInStorageCondition
	}=
     Lookup[optionsWithReplicates,
			 {
				 AliquotAmount,SamplesInStorageCondition
			 },
			 Null
		 ];

	(* -- For the ConcentratedProteinStandard and the StandardProteinDiluent, we need to figure out the volumes we need of each to get the required dilution -- *)
	(* - First, we need to figure out the ratio of the StandardCurveConcentrations to the concentration of the ConcentratedProteinStandard - *)
	concentratedProteinStandardDilutionFactors=If[

		(* IF the option has resolved to Null, THEN we set the list of dilution factors to an empty list *)
		MatchQ[concentratedProteinStandard,Null],
		{},

		(* ELSE, we divide each member of ProteinStandardConcentrations by the concentratedProteinStandardConcentration, rounding to the nearest 0.001, and avoiding 0 *)
		RoundOptionPrecision[(standardCurveConcentrations/(concentratedProteinStandardConcentration)), 10^-3, AvoidZero -> True]
	];

	(* - Next, we use this ratio to calculate how much of the ConcentratedProteinStandard is needed for each well of the StandardDilutionPlate. This amount will vary based on the LoadingVolume - *)
	concentratedProteinStandardVolumes=Which[

		(* In the case where the ConcentratedProteinStandard is Null, the variable will be set to an empty list *)
		MatchQ[concentratedProteinStandard,Null],
		{},

		(* In the case where the LoadingVolume is smaller than 80 uL, we multiply the concentratedProteinStandardDilutionFactors by 200 uL *)
		loadingVolume<80*Microliter,
			RoundOptionPrecision[(200*Microliter*concentratedProteinStandardDilutionFactors),10^-1*Microliter],

		(* In the case where the LoadingVolume is larger than or equal to 80 uL, we multiply the concentratedProteinStandardDilutionFactors by 200 uL *)
		loadingVolume>=80*Microliter,
			RoundOptionPrecision[(200*Microliter*concentratedProteinStandardDilutionFactors),10^-1*Microliter]
	];

	(* - Next, we also use this ratio to calculate how much of the ProteinStandardDiluent is needed for each well of the StandardDilutionPlate. This amount will vary based on the LoadingVolume - *)
	proteinStandardDiluentVolumes=Which[

		(* In the case where the ConcentratedProteinStandard is Null, the variable will be set to an empty list *)
		MatchQ[concentratedProteinStandard,Null],
		{},

		(* In the case where the LoadingVolume is smaller than 80 uL, we multiply (1 minus the concentratedProteinStandardDilutionFactors) by 200 uL *)
		loadingVolume<80*Microliter,
			RoundOptionPrecision[(200*Microliter*(1-concentratedProteinStandardDilutionFactors)),10^-1*Microliter],

		(* In the case where the LoadingVolume is larger than or equal to 80 uL, we multiply (1 minus the concentratedProteinStandardDilutionFactors) by 200 uL *)
		loadingVolume>=80*Microliter,
			RoundOptionPrecision[(200*Microliter*(1-concentratedProteinStandardDilutionFactors)),10^-1*Microliter]
	];

	(* --- To make resources, we need to find the input Objects and Models that are unique, and to request the total volume of them that is needed ---*)
	(* --  For each index-matched input or option object/volume pair, make a list of rules - ask for a bit more than requested in the cases it makes sense to, to take into account dead volumes etc -- *)
	(* - First, we need to make a list of volumes that are index matched to the expanded samples in, with the LoadingVolume if no Aliquotting is occurring, or the AliquotAmount if Aliquotting is happening - *)
	expandedLoadingOrAliquotVolumes=Map[
		If[MatchQ[#,Null],
			(loadingVolume+5*Microliter),
			#
		]&,
		expandedAliquotAmounts
	];

	(* Then, we use this list to create the volume rules for the input samples *)
	sampleVolumeRules=MapThread[
		(#1->#2)&,
		{samplesWithReplicates,expandedLoadingOrAliquotVolumes}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	uniqueSampleVolumeRules=Merge[sampleVolumeRules, Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
	sampleResourceReplaceRules = KeyValueMap[
		Function[{sample, volume},
			If[VolumeQ[volume],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume ],
				sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]]
			]
		],
		uniqueSampleVolumeRules
	];

	(* Use the replace rules to get the sample resources *)
	samplesInResources = Replace[samplesWithReplicates, sampleResourceReplaceRules, {1}];

	(* - Determine how much QuantificationReagent we need - *)
	(* First, define how many wells will be used in the experiment, for all samples and standard curve points *)
	(* Figure out how many number of points there will be on the standard curve (including the blank) *)
	numberOfStandardCurvePoints=If[

		(* IF the ProteinStandards has not resolved to Null *)
		!MatchQ[proteinStandards,Null],

		(* THEN the number of standard curve points is the length of ProteinStandards *)
		(Length[proteinStandards]+1),

		(* ELSE the number of standard curve points is the length of StandardCurveConcentrations *)
		(Length[standardCurveConcentrations]+1)
	];

	(* Use this number to calculate the number of Wells that will be used *)
	numberOfWellsUsed=(Length[samplesWithReplicates]+(numberOfStandardCurvePoints*standardCurveReplicates));

	(* Use this information to create the volume rule for the QuantificationReagent *)
	quantificationReagentVolumeRule={quantificationReagent->RoundOptionPrecision[(quantificationReagentVolume*numberOfWellsUsed+3*Milliliter),10^-1*Microliter]};

	(* - Determine how much of each ProteinStandard we need - *)
	proteinStandardsVolumeRules=If[

		(* IF the ProteinStandards option has resolved to Null *)
		MatchQ[proteinStandards,Null],

		(* THEN we do not need any of them *)
		{Null->0*Microliter},

		(* ELSE, we need the LoadingVolume plus 30 uL of each of the objects in ProteinStandards *)
		Map[
			#->(loadingVolume+30*Microliter)&,
			proteinStandards
		]
	];

	(* - Determine how much of the StandardCurveBlank we need - *)
	standardCurveBlankVolumeRule={standardCurveBlank->RoundOptionPrecision[((loadingVolume*standardCurveReplicates)+40*Microliter),10^-1*Microliter]};

	(* - Determine how much of the ConcentratedProteinStandard we need - *)
	concentratedProteinStandardVolumeRule={concentratedProteinStandard->RoundOptionPrecision[((Total[concentratedProteinStandardVolumes]*standardCurveReplicates)+100*Microliter),10^-1*Microliter]};

	(* - Determine how much of the ProteinStandardDiluent we need - *)
	proteinStandardDiluentVolumeRule={proteinStandardDiluent->RoundOptionPrecision[((Total[proteinStandardDiluentVolumes]*standardCurveReplicates)+100*Microliter),10^-1*Microliter]};

	(* --- Make the resources --- *)
	(* -- We want to make the resources for each unique Object or Model Input, for the total volume required for the experiment for each -- *)
	(* - First, join the lists of the rules above, getting rid of any Rules with the pattern _->0*Microliter or Null->_ - *)
	allVolumeRules=Cases[
		Join[
			quantificationReagentVolumeRule,proteinStandardsVolumeRules,standardCurveBlankVolumeRule,concentratedProteinStandardVolumeRule,proteinStandardDiluentVolumeRule
		],
		Except[Alternatives[_->0*Microliter,Null->_]]
	];

	(* - Make an association whose keys are the unique Object and Model Keys in the list of allVolumeRules, and whose values are the total volume of each of those unique keys - *)
	uniqueObjectsAndVolumesAssociation=Merge[allVolumeRules,Total];

	(* - Use this association to make Resources for each unique Object or Model Key - *)
	uniqueResources=KeyValueMap[
		Module[{amount,containers},
			amount=#2;
			containers=PickList[liquidHandlerContainers,liquidHandlerContainerMaxVolumes,GreaterEqualP[amount]];
			Resource[Sample->#1,Amount->amount,Container->containers,Name->ToString[#1]]
		]&,
		uniqueObjectsAndVolumesAssociation
	];

	(* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
	(* - Find a list of the unique Object/Model Keys - *)
	uniqueObjects=Keys[uniqueObjectsAndVolumesAssociation];

	(* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
	uniqueObjectResourceReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueObjects,uniqueResources}
	];

	(* -- Use the unique object replace rules to make lists of the resources of the inputs and the options / fields that are objects -- *)
	(* - For the inputs and options that are lists, Map over replacing the options with the replace rules at level {1} to get the corresponding list of resources - *)
	{
		proteinStandardsResources
	}=Map[
		Replace[#,uniqueObjectResourceReplaceRules,{1}]&,
		{
			proteinStandards
		}
	];

	(* - For the options that are single objects, Map over replacing the option with the replace rules to get the corresponding resources - *)
	{
		quantificationReagentResource,concentratedProteinStandardResource,proteinStandardDiluentResource,standardCurveBlankResource
	}=Map[
		Replace[#,uniqueObjectResourceReplaceRules]&,
		{
			quantificationReagent,concentratedProteinStandard,proteinStandardDiluent,standardCurveBlank
		}
	];

	(* -- Make resources for other things needed for the experiment -- *)
	(* - Make resources for the intermediate Plates that will be used - *)
	(* We only need the StandardDilutionPlate if ProteinStandards is Null *)
	standardDilutionPlateResource=If[MatchQ[proteinStandards,Null],
		Resource[
			Sample->Model[Container, Plate, "id:1ZA60vwjbbqa"]
		],
		Null
	];

	(* Make the resource for the QuantificationPlate *)
	quantificationPlateResource=Resource[
		Sample->Model[Container, Plate, "id:kEJ9mqR3XELE"]
	];

	(* - Make a resource for the plate reader instrument - *)
	instrumentResource=Resource[
		Instrument->instrument,
		Time->2*Hour
	];

	(* -- Define a few fields of the protocol object that are not resources -- *)
	(* - Turn the supplied QuantificationWavelength option into a sorted list of the Wavelengths (the field in the Protocol will be a multiple field) - *)
	sortedQuantificationWavelengths=Which[

		(* If the suppliedQuantificationWavelength is Automatic, set it as Automatic *)
		MatchQ[quantificationWavelength,Automatic],
		Automatic,

		(* If the suppliedQuantificationWavelength is a single value, put the value in a list *)
		MatchQ[Head[quantificationWavelength],Quantity],
		{quantificationWavelength},

		(* If the suppliedQuantificationWavelength is a list, sort the list *)
		MatchQ[Head[quantificationWavelength],List],
		Sort[quantificationWavelength],

		(* If the supplied QuantificationWavelength is a span, make a list of the wavelengths *)
		MatchQ[Head[quantificationWavelength],Span],
		Range[First[quantificationWavelength],Last[quantificationWavelength]]
	];

	(* -- Define the StandardCurveConcentrations field, which will be populated either with the StandardCurveConcentrations option (plus 0 mg/mL), or the important concentration of the ProteinStandards -- *)
	(* - ProteinStandards - *)
	(* - From the Models, define the Concentration as the InitialMassConcentration - *)
	proteinStandardModelConcentrations=totalProteinMassConcentration/@Flatten[listedProteinStandardModelPackets];

	(* - From the Objects, Lookup both the TotalProteinConcentration and MassConcentration - *)
	proteinStandardObjectTotalProteinConcentrations=Lookup[Flatten[listedProteinStandardObjectPackets],TotalProteinConcentration,{}];
	proteinStandardObjectMassConcentrations=totalProteinMassConcentration/@Flatten[listedProteinStandardObjectPackets];

	(* From the two Object concentration lists, choose the TotalProteinConcentration if it is filled out, otherwise choose the MassConcentration *)
	proteinStandardObjectConcentrations=MapThread[
		If[MatchQ[#1,Null],
			#2,
			#1
		]&,
		{proteinStandardObjectTotalProteinConcentrations,proteinStandardObjectMassConcentrations}
	];

	(* - Write replace rules for the unique ProteinStandard Models and Objects - goal is to get an index matched list of ProteinStandards by Concentration (InitialMassConc or MassConc or TotalProteinConc) - *)
	proteinStandardModelConcentrationReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueProteinStandardModels,proteinStandardModelConcentrations}
	];
	proteinStandardObjectConcentrationReplaceRules=MapThread[
		(#1->#2)&,
		{uniqueProteinStandardObjects,proteinStandardObjectConcentrations}
	];

	(* Combine the two rules to make the list of replace rules which we will apply to suppliedProteinStandards *)
	proteinStandardConcentrationReplaceRules=Join[proteinStandardModelConcentrationReplaceRules,proteinStandardObjectConcentrationReplaceRules];

	(* Finally, use the replace rules to get a list of Concentrations index-matched to ProteinStandards *)
	proteinStandardConcentrations=proteinStandards/.proteinStandardConcentrationReplaceRules;

	(* Use the above information to define the StandardCurveConcentrations protocol object field *)
	standardCurveConcentrationsField=If[MatchQ[proteinStandardConcentrations,Null],
		Prepend[standardCurveConcentrations,0*Milligram/Milliliter],
		Prepend[proteinStandardConcentrations,0*Milligram/Milliliter]
	];

	(* Define the EmissionWavelengthRange field - used to set the EmissionWavelengthRange option of the FluorescenceSpectroscopy subprotocol *)
	emissionWavelengthRange=If[MatchQ[detectionMode,Absorbance],
		Null,
		Span[(excitationWavelength)+25*Nanometer,740*Nanometer]
	];

	(* Define the AdjustmentEmissionWavelength field - used to set the AdjustmentEmissionWavelength option of the FluorescenceSpectroscopy subprotocol *)
	adjustmentEmissionWavelength=If[MatchQ[detectionMode,Absorbance],
		Null,
		RoundOptionPrecision[Mean[{First[sortedQuantificationWavelengths],Last[sortedQuantificationWavelengths]}],10^0*Nanometer]
	];

	(*Look up the protein standard and concentrated protein standard storage condtions*)
	{proteinStandardsStorageConditions,concProteinStandardStorageCondition} = Lookup[optionsWithReplicates,{ProteinStandardsStorageCondition,ConcentratedProteinStandardStorageCondition}];

	(* --- Create the protocol packet --- *)
	protocolPacket=<|
		Type->Object[Protocol,TotalProteinQuantification],
		Object->protocolID,
		Author->If[MatchQ[parentProtocol,Null],
			Link[$PersonID,ProtocolsAuthored]
		],
		ParentProtocol->If[MatchQ[parentProtocol,ObjectP[ProtocolTypes[]]],
			Link[parentProtocol,Subprotocols]
		],
		Replace[ContainersIn]->(Link[Resource[Sample->#],Protocols]&)/@sampleContainersIn,
		Replace[SamplesIn]->(Link[#,Protocols]&/@samplesInResources),

		UnresolvedOptions->RemoveHiddenOptions[ExperimentTotalProteinQuantification,myTemplatedOptions],
		ResolvedOptions->myResolvedOptions,

		Name->name,

		AssayType->assayType,
		DetectionMode->detectionMode,
		Instrument->Link[instrumentResource],
		NumberOfReplicates->numberOfReplicates,
		Replace[ProteinStandards]->(Link[#]&/@proteinStandardsResources),
		Replace[ProteinStandardsStorage]->proteinStandardsStorageConditions,
		ConcentratedProteinStandard->Link[concentratedProteinStandardResource],
		ConcentratedProteinStandardStorage->concProteinStandardStorageCondition,
		Replace[StandardCurveConcentrations]->standardCurveConcentrationsField,
		Replace[ConcentratedProteinStandardVolumes]->concentratedProteinStandardVolumes,
		ProteinStandardDiluent->Link[proteinStandardDiluentResource],
		Replace[ProteinStandardDiluentVolumes]->proteinStandardDiluentVolumes,
		StandardCurveBlank->Link[standardCurveBlankResource],
		StandardDilutionPlate->Link[standardDilutionPlateResource],
		StandardCurveReplicates->standardCurveReplicates,
		LoadingVolume->loadingVolume,
		QuantificationReagent->Link[quantificationReagentResource],
		QuantificationReagentVolume->quantificationReagentVolume,
		QuantificationPlate->Link[quantificationPlateResource],
		QuantificationReactionTime->quantificationReactionTime,
		QuantificationReactionTemperature->(quantificationReactionTemperature/.Ambient->Null),
		ExcitationWavelength->excitationWavelength,
		EmissionWavelengthRange->emissionWavelengthRange,
		Replace[QuantificationWavelengths]->sortedQuantificationWavelengths,
		QuantificationTemperature->(quantificationTemperature/.Ambient->Null),
		QuantificationEquilibrationTime->quantificationEquilibrationTime,
		NumberOfEmissionReadings->numberOfEmissionReadings,
		EmissionReadLocation->emissionReadLocation,
		EmissionAdjustmentSample->emissionAdjustmentSample,
		EmissionGain->emissionGain,
		AdjustmentEmissionWavelength->adjustmentEmissionWavelength,
		Replace[SamplesInStorage]->samplesInStorageCondition,
		Replace[Checkpoints]->{
			{"Preparing Samples",15*Minute,"Preprocessing, such as incubation, centrifugation, filtration, and aliquotting, is performed.",Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]},
			{"Picking Resources",1*Hour,"Samples and plates required to execute this protocol are gathered from storage and stock solutions are freshly prepared.",Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]},
			{"Preparing Quantification Plate",2*Hour,"The StandardDilutionPlate and QuantificationPlate are loaded with the specified reagents.",Link[Resource[Operator -> $BaselineOperator, Time -> 2 Hour]]},
			{"Acquiring Data",1*Hour,"Absorbance or Fluorescence spectra of the QuantificationPlate are acquired.",Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]},
			{"Returning Materials",30*Minute,"Samples are returned to storage.",Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]}
		}
	|>;

	(* - Populate prep field - send in initial samples and options since this handles NumberOfReplicates on its own - *)
	prepPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->inheritedCache,Simulation -> simulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket=Join[protocolPacket,prepPacket];

	(* make list of all the resources we need to check in FRQ *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]],_Resource,Infinity]];

	(* Verify we can satisfy all our resources *)
	{resourcesOk,resourceTests}=Which[
		MatchQ[$ECLApplication,Engine],
		{True,{}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->inheritedCache,Simulation->simulation],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->inheritedCache,Simulation->simulation],Null}
	];

	(* --- Output --- *)
	(* Generate the Preview output rule *)
	previewRule=Preview->Null;

	(* Generate the options output rule *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		resourceTests,
		{}
	];

	(* generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
		finalizedPacket,
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification/.{previewRule,optionsRule,resultRule,testsRule}
];
