(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*Options*)

DefineOptions[ExperimentFlashChromatography,
	Options:>{
		{
			OptionName->Instrument,
			Default->Model[Instrument,FlashChromatography,"CombiFlash Rf 200"],
			Description->"The device that will separate the sample by differential adsorption by flowing the sample and buffer through a column, measure absorbance of UV light through the separated sample as it leaves the column, and collect fractions of the separated sample.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Instrument,FlashChromatography],Object[Instrument,FlashChromatography]}],
				OpenPaths->{
					{
						Object[Catalog,"Root"],
						"Instruments",
						"Chromatography",
						"Flash Chromatography"
					}
				}
			],
			Category->"General"
		},
		{
			OptionName->SeparationMode,
			Default->Automatic,
			Description->"The category of mobile and stationary phase used to elicit differential column retention. This option is used to suggest the column and buffers.",
			ResolutionDescription->"If the specified columns and cartridges include a mix of normal and reverse phase, automatically set to NormalPhase. Otherwise, if the specified columns and cartridges are reverse phase, automatically set ReversePhase. Otherwise, automatically set to NormalPhase.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>FlashChromatographySeparationModeP (* NormalPhase|ReversePhase *)
			],
			Category->"General"
		},
		(* At the moment, FlashChromatographyDetectorTypeP would only include UV. *)
		{
			OptionName->Detector,
			Default->UV,
			Description->"The type of measurement to employ. Currently, we offer only UV (measures the absorbance of UV light that passes through effluent from the column).",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>FlashChromatographyDetectorTypeP (* UV *)
			],
			Category->"General"
		},

		(* --- Buffers --- *)
		{
			OptionName->BufferA,
			Default->Automatic,
			Description->"The solvent pumped through channel A of the flow path. Typically, Buffer A is the weaker solvent (less polar for normal phase chromatography or more polar for reverse phase).",
			ResolutionDescription->"Automatically set from the SeparationMode option. Defaults to Hexane for normal phase or Water for reverse phase.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			],
			Category->"Priming"
		},
		{
			OptionName->BufferB,
			Default->Automatic,
			Description->"The solvent pumped through channel B of the flow path. Typically, Buffer B is the stronger solvent (more polar for normal phase chromatography or less polar for reverse phase).",
			ResolutionDescription->"Automatically set from the SeparationMode option. Defaults to Ethyl Acetate for normal phase or Methanol for reverse phase.",
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Sample],Model[Sample]}]
			],
			Category->"Priming"
		},

		(* --- SamplesIn IndexMatched Options --- *)

		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the sample to be separated by flash chromatography, for use in unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->SampleContainerLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the container of the sample to be separated by flash chromatography, for use in unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->Column,
				Default->Automatic,
				Description->"The item containing the stationary phase through which the buffers and sample flow. It adsorbs and separates the molecules within the sample based on the properties of the mobile phase, Samples, and column material (stationary phase).",
				ResolutionDescription->"If LoadingAmount is unspecified, and the SeparationMode is ReversePhase resolve to Model[Item,Column,\"RediSep Gold Reverse Phase C18 Column 15.5g\"]. If LoadingAmount is unspecified, and the SeparationMode is NormalPhase resolve to Model[Item,Column,\"RediSep Gold Normal Phase Silica Column 12g\"]. If LoadingAmount is specified, resolve to the smallest column of the SeparationMode from the default list that is large enough that the column's VoidVolume times the MaxLoadingPercent is greater than or equal to the LoadingAmount.",
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Item,Column],Object[Item,Column]}]
				],
				Category->"General"
			},
			{
				OptionName->ColumnLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the column through which the sample is forced, for use in unit operations.",
				AllowNull->False,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->PreSampleEquilibration,
				Default->Automatic,
				Description->"The length of time that of buffer is pumped through the column at the specified FlowRate prior to sample loading. The buffer used will be the initial composition of the Gradient.",
				ResolutionDescription->"If LoadingType is Preloaded, automatically set to Null. Otherwise, automatically set to the length of time it takes for 3 column volumes of buffer to flow through the column (3 times the column's VoidVolume divided by the FlowRate).",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute,$MaxFlashChromatographyGradientTime],
					Units->{Minute,{Second,Minute}}
				],
				Category->"Priming"
			},
			(* It is possible to load liquid samples with the Solid LoadingType: drop them on the solid media in a prefilled cartridge. *)
			(* But it is not possible to load solid samples with the Liquid LoadingType. Would have to dissolve them first. This sort of sample manipulation should be done beforehand? *)
			{
				OptionName->LoadingType,
				Default->Automatic,
				Description->"The method by which sample is introduced to the instrument: liquid injection, solid load cartridge, or preloaded directly on the column. With LoadingType->Liquid, the column is pre-equilibrated with BufferA and then the sample is loaded by syringe into the instrument's injection valve. With LoadingType->Solid, the column is equilibrated with BufferA and then the sample is loaded into a solid load cartridge packed with solid media which is upstream of the column. With LoadingType->Preloaded the sample is loaded by syringe directly into the column and no column pre-equilibration step occurs.",
				ResolutionDescription->"Automatically set to Solid if any cartridge-related options (Cartridge, CartridgePackingMaterial, CartridgeFunctionalGroup, CartridgePackingMass, CartridgeDryingTime) are specified or to Liquid otherwise.",
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FlashChromatographyLoadingTypeP (* Liquid|Solid|Preloaded *)
				],
				Category->"Sample Loading"
			},
			(* Instead of Automatically setting to All, should I go up to an amount appropriate for some particular (small) column size? *)
			{
				OptionName->LoadingAmount,
				Default->Automatic,
				Description->"The volume of sample loaded into the flow path of the flash chromatography instrument that will be separated by differential adsorption.",
				ResolutionDescription->"Automatically set to MaxLoadingPercent times the VoidVolume of the Column.",
				AllowNull->False,
				Widget->Alternatives[
					"All"->Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					"Liquid"->Widget[
						Type->Quantity,
						Pattern:>RangeP[0 Milliliter,50 Milliliter],
						Units->Milliliter
					]
				],
				Category->"Sample Loading"
			},
			{
				OptionName->MaxLoadingPercent,
				Default->Automatic,
				Description->"The maximum amount of liquid sample to be loaded on the flash chromatography instrument. Expressed as a percent of the Column's VoidVolume. If LoadingAmount is not specified, then LoadingAmount will be MaxLoadingPercent times the VoidVolume of the Column. If LoadingAmount is specified but Column is not, then a Column will be chosen such that its VoidVolume times MaxLoadingPercent is greater than or equal to the LoadingAmount. If both LoadingAmount and Column are specified, then MaxLoadingPercent must be greater than or equal to LoadingAmount divided by the Column's VoidVolume.",
				ResolutionDescription->"Automatically set to 6% if the LoadingType is Liquid or Preloaded or to 12% if the LoadingType is Solid.",
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Percent,100 Percent],
					Units->Percent
				],
				Category->"Sample Loading"
			},
			{
				OptionName->Cartridge,
				Default->Automatic,
				Description->"The item attached upstream of the column into which sample will be introduced if the Solid LoadingType is specified. If the Cartridge's PackingType is Prepacked, it is filled with solid media from the manufacturer. If it is HandPacked, it will be filled as specified by the CartridgePackingMaterial, CartridgeFunctionalGroup, and CartridgePackingMass options.",
				ResolutionDescription->"If LoadingType is Solid, automatically set to a Prepacked cartridge model filled with Silica for NormalPhase SeparationMode or C18 for ReversePhase. Automatically choose a cartridge size based on the BedWeight of the resolved Column as described in Table... If LoadingType is not Solid, automatically set to Null.",
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Container,ExtractionCartridge],Object[Container,ExtractionCartridge]}]
				],
				Category->"Sample Loading"
			},
			{
				OptionName->CartridgeLabel,
				Default->Automatic,
				Description->"A user defined word or phrase used to identify the solid load cartridge into which the sample is loaded, for use in unit operations.",
				AllowNull->True,
				Category->"General",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				],
				UnitOperation->True
			},
			{
				OptionName->CartridgePackingMaterial,
				Default->Automatic,
				Description->"The material with which the solid load cartridge is filled. The sample will be loaded onto this material inside the cartridge.",
				ResolutionDescription->"Automatically set to Null if Cartridge is Null. If the PackingType of the Cartridge is Prepacked, automatically set to the PackingMaterial of the Cartridge. Otherwise automatically set to Silica.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FlashChromatographyCartridgePackingMaterialP
				],
				Category->"Sample Loading"
			},
			{
				OptionName->CartridgeFunctionalGroup,
				Default->Automatic,
				Description->"The functional group displayed on the material with which the solid load cartridge is filled.",
				ResolutionDescription->"Automatically set to Null if Cartridge is Null. If the PackingType of the Cartridge is Prepacked, automatically set to the FunctionalGroup of the Cartridge. Otherwise automatically set to C18 if SeparationMode is ReversePhase or to Null otherwise.",
				AllowNull->True,
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FlashChromatographyCartridgeFunctionalGroupP
				],
				Category->"Sample Loading"
			},
			{
				OptionName->CartridgePackingMass,
				Default->Automatic,
				Description->"The mass of the material with which the solid load cartridge is filled.",
				ResolutionDescription->"Automatically set to Null if Cartridge is Null. If the PackingType of the Cartridge is Prepacked, automatically set to the BedWeight of the Cartridge. Otherwise automatically set to the BedWeight of the Column or to the MaxBedWeight of the Cartridge, whichever is smaller.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Gram,65 Gram],
					Units->Gram
				],
				Category->"Sample Loading"
			},
			{
				OptionName->CartridgeDryingTime,
				Default->Automatic,
				Description->"The duration of time for which the solid sample cartridge is dried with pressurized air after the sample is loaded.",
				ResolutionDescription->"Automatically set to Null if Cartridge is Null, otherwise set to 0 minutes.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute,15 Minute],
					Units->{Minute,{Second,Minute}}
				],
				Category->"Sample Loading"
			},
			(* --- Separation --- *)
			{
				OptionName->GradientA,
				Default->Automatic,
				Description->"The composition of BufferA within the flow over time, in the form {Time, % Buffer A}. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientA->{{0 Minute, 90 Percent},{30 Minute, 10 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition is 50 Percent.",
				ResolutionDescription->"Automatically set from the GradientB option by complementing 100%.",
				AllowNull->False,
				Category->"Separation",
				Widget->Adder[
					{
						"Time"->Widget[
							Type->Quantity,
							Pattern:>RangeP[0 Minute,$MaxFlashChromatographyGradientTime],
							Units->{Minute,{Second,Minute}}
						],
						"Buffer A Composition"->Widget[
							Type->Quantity,
							Pattern:>RangeP[0 Percent,100 Percent],
							Units->Percent
						]
					},
					Orientation->Vertical
				]
			},
			{
				OptionName->GradientB,
				Default->Automatic,
				Description->"The composition of BufferB within the flow over time, in the form {Time, % Buffer B}. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition is 50 Percent.",
				ResolutionDescription->"If they are specified, automatically set from the gradient shortcut options (GradientStart, GradientEnd, GradientDuration, EquilibrationTime, and FlushTime). Otherwise if Gradient is specified, automatically set from the Gradient option. Otherwise, if GradientA is specified, automatically set from the GradientA option by complementing 100%. Otherwise, automatically set such that the gradient stays at 0% for X min, ramps from 0% to 100% over 12*X min, stays at 100% for 2*X min, then stays at 50% for 2*X min for C18 or C8 columns or at 0% for X min for other columns. For large columns, X is approximately the length of time it takes for one column volume of liquid to flow through the column. For small columns it is longer so as not too ramp too quickly for effective separation. X min = ( (55.5361 gram^2)/(the column's BedWeight in grams)^2 + 1 ) * (the column's VoidVolume in mL) / (the FlowRate in mL/min).",
				AllowNull->False,
				Category->"Separation",
				Widget->Adder[
					{
						"Time"->Widget[
							Type->Quantity,
							Pattern:>RangeP[0 Minute,$MaxFlashChromatographyGradientTime],
							Units->{Minute,{Second,Minute}}
						],
						"Buffer B Composition"->Widget[
							Type->Quantity,
							Pattern:>RangeP[0 Percent,100 Percent],
							Units->Percent
						]
					},
					Orientation->Vertical
				]
			},
			{
				OptionName->FlowRate,
				Default->Automatic,
				Description->"The speed of the fluid through the pump and into the column after the sample is loaded during separation.",
				ResolutionDescription->"Automatically set to a rate appropriate for the column size and type.",
				AllowNull->False,
				Category->"Separation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[5 Milliliter/Minute,200 Milliliter/Minute],
					Units->CompoundUnit[
						{1,{Milliliter,{Milliliter,Liter}}},
						{-1,{Minute,{Second,Minute}}}
					]
				]
			},
			{
				OptionName->GradientStart,
				Default->Null,
				Description->"A shorthand option to specify the starting BufferB composition in the fluid flow. This option must be specified with GradientEnd and GradientDuration.",
				AllowNull->True,
				Category->"Separation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Percent,100 Percent],
					Units->Percent
				]
			},
			{
				OptionName->GradientEnd,
				Default->Null,
				Description->"A shorthand option to specify the final BufferB composition in the fluid flow. This option must be specified with GradientStart and GradientDuration.",
				AllowNull->True,
				Category->"Separation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Percent,100 Percent],
					Units->Percent
				]
			},
			{
				OptionName->GradientDuration,
				Default->Null,
				Description->"A shorthand option to specify the total length of time during which the buffer composition changes. This option must be specified with GradientStart and GradientEnd.",
				AllowNull->True,
				Category->"Separation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute,$MaxFlashChromatographyGradientTime],(* That is the limit in the instrument's software. Do we want to limit to less time? *)
					Units->{Minute,{Second,Minute}}
				]
			},
			{
				OptionName->EquilibrationTime,
				Default->Null,
				Description->"A shorthand option to specify the duration of equilibration at the starting buffer composition before the start of gradient change. The buffer composition is the same as that of GradientStart. This option must be specified with GradientStart.",
				AllowNull->True,
				Category->"Separation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute,$MaxFlashChromatographyGradientTime],
					Units->{Minute,{Second,Minute}}
				]
			},
			{
				OptionName->FlushTime,
				Default->Null,
				Description->"A shorthand option to specify the duration of constant buffer composition flushing at the end of the gradient change. The buffer composition is the same as that of GradientEnd. This option must be specified with GradientEnd.",
				AllowNull->True,
				Category->"Separation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute,$MaxFlashChromatographyGradientTime],
					Units->{Minute,{Second,Minute}}
				]
			},
			{
				OptionName->Gradient,
				Default->Automatic,
				Description->"The composition of BufferA and BufferB within the flow over time, in the form {Time, % Buffer A, % Buffer B}. The composition is linearly interpolated for the intervening periods between the defined time points. For example for Gradient->{{0 Minute, 90 Percent, 10 Percent},{30 Minute, 10 Percent, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition is 50 Percent.",
				ResolutionDescription->"Automatically set to match GradientA and GradientB.",
				AllowNull->False,
				Category->"Separation",
				Widget->Adder[
					{
						"Time"->Widget[
							Type->Quantity,
							Pattern:>RangeP[0 Minute,$MaxFlashChromatographyGradientTime],
							Units->{Minute,{Second,Minute}}
						],
						"Buffer A Composition"->Widget[
							Type->Quantity,
							Pattern:>RangeP[0 Percent,100 Percent],
							Units->Percent
						],
						"Buffer B Composition"->Widget[
							Type->Quantity,
							Pattern:>RangeP[0 Percent,100 Percent],
							Units->Percent
						]
					},
					Orientation->Vertical
				]
			},
			(* --- Fraction Collection Parameters --- *)
			{
				OptionName->CollectFractions,
				Default->True,
				Description->"Indicates if effluents from the column (fractions) should be captured and stored.",
				AllowNull->False,
				Category->"Fraction Collection",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>BooleanP
				]
			},
			(* Start and end times using the Initial Waste and Time Windows parameters of the CombiFlash *)
			{
				OptionName->FractionCollectionStartTime,
				Default->Automatic,
				Description->"The time at which to start column effluent capture. Time is measured from the start of the Gradient.",
				ResolutionDescription->"Automatically set to 0 minutes if CollectFractions is True, or to Null otherwise.",
				AllowNull->True,
				Category->"Fraction Collection",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute,$MaxFlashChromatographyGradientTime],
					Units->{Minute,{Second,Minute,Hour}}
				]
			},
			{
				OptionName->FractionCollectionEndTime,
				Default->Automatic,
				Description->"The time at which to end column effluent capture. Time is measured from the start of the Gradient. Fraction collection will end at this time regardless of peak collection status.",
				ResolutionDescription->"Automatically set to the last time point of the Gradient if CollectFractions is True, or to Null otherwise.",
				AllowNull->True,
				Category->"Fraction Collection",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Minute,$MaxFlashChromatographyGradientTime],
					Units->{Minute,{Second,Minute,Hour}}
				]
			},
			{
				OptionName->FractionContainer,
				Default->Automatic,
				Description->"The type of containers in which fractions of the separated sample are collected after flowing out of the the column and past the detector.",
				ResolutionDescription->"If CollectFractions is False, resolve to Null. If CollectFractions is True and MaxFractionVolume is specified, resolve to the smallest compatible container large enough to hold the MaxFractionVolume. Otherwise resolve to Model[Container,Vessel,\"15mL Tube\"].",
				AllowNull->True,
				Category->"Fraction Collection",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container,Vessel]]
				]
			},
			{
				OptionName->MaxFractionVolume,
				Default->Automatic,
				Description->"The maximum volume of effluent collected in a single fraction container before moving on to the next fraction container.",
				ResolutionDescription->"Automatically set to 80% of the value of the MaxVolume field of the FractionContainer.",
				AllowNull->True,
				Category->"Fraction Collection",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[1 Milliliter,50 Milliliter],
					Units->{Milliliter,{Microliter,Milliliter}}
				]
			},
			{
				OptionName->FractionCollectionMode,
				Default->Automatic,
				Description->"Indicates if All effluent from the column should be collected as fractions with MaxFractionVolume, or only effluent corresponding to Peaks detected by PeakDetectors.",
				ResolutionDescription->"Automatically set to Peaks if CollectionFractions is True. Automatically set to Null if CollectFractions is False.",
				AllowNull->True,
				Category->"Fraction Collection",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[All,Peaks]
				]
			},
			{
				OptionName->Detectors,
				Default->All,
				Description->"The set or sets of wavelengths of light used to measure absorbance through the separated sample. Independent measurements are collected using up to three of a single primary wavelength, a single secondary wavelength, and the average of a wide range of wavelengths.",
				AllowNull->False,
				Widget->Alternatives[
					"Select"->Widget[
						Type->MultiSelect,
						Pattern:>DuplicateFreeListableP[PrimaryWavelength|SecondaryWavelength|WideRangeUV]
					],
					"All"->Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					] (* The same as selecting all three of PrimaryWavelength, SecondaryWavelength, and WideRangeUV *)
				],
				Category->"Detection"
			},
			{
				OptionName->PrimaryWavelength,
				Default->Automatic,
				Description->"The wavelength of light passed through the flow cell whose absorbance is measured by the PrimaryWavelength Detector.",
				ResolutionDescription->"Automatically set to 254 Nanometer if PrimaryWavelength is one of the Detectors or to Null otherwise.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[200 Nanometer,360 Nanometer],
					Units->Nanometer
				],
				Category->"Detection"
			},
			{
				OptionName->SecondaryWavelength,
				Default->Automatic,
				Description->"The wavelength of light passed through the flow cell whose absorbance is measured by the SecondaryWavelength Detector.",
				ResolutionDescription->"Automatically set to 280 Nanometer if SecondaryWavelength is one of the Detectors or to Null otherwise.",
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[200 Nanometer,360 Nanometer],
					Units->Nanometer
				],
				Category->"Detection"
			},
			{
				OptionName->WideRangeUV,
				Default->Automatic,
				Description->"The span of wavelengths of UV light passed through the flow cell from which a single absorbance value is measured by the WideRangeUV Detector. The total absorbance from wavelengths in the specified range is measured. All indicates that the absorbance from all wavelengths in the range from 200 to 360 nanometers will be measured.",
				ResolutionDescription->"Automatically set to All (200 to 360 nanometers) if WideRangeUV is one of the Detectors or to Null otherwise.",
				AllowNull->True,
				Widget->Alternatives[
					"All"->Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					],
					"Range"->Span[
						Widget[
							Type->Quantity,
							Pattern:>RangeP[200 Nanometer,360 Nanometer],
							Units->Nanometer
						],
						Widget[
							Type->Quantity,
							Pattern:>RangeP[200 Nanometer,360 Nanometer],
							Units->Nanometer
						]
					]
				],
				Category->"Detection"
			},
			{
				OptionName->PeakDetectors,
				Default->Automatic,
				Description->"The set of detectors (PrimaryWavelength, SecondaryWavelength, and/or WideRangeUV) used to identify peaks in absorbance through the sample. A peak is called if there is a peak called by any of the detectors.",
				ResolutionDescription->"Automatically set to include whichever of PrimaryWavelength and SecondaryWavelength are present in Detectors and WideRangeUV if it is present in Detectors and any WideRangeUV-related peak detection options are specified. Otherwise automatically set to {WideRangeUV}.",
				AllowNull->True,
				Widget->Widget[
					Type->MultiSelect,
					Pattern:>DuplicateFreeListableP[PrimaryWavelength|SecondaryWavelength|WideRangeUV]
				],
				Category->"Detection"
			},
			{
				OptionName->PrimaryWavelengthPeakDetectionMethod,
				Default->Automatic,
				Description->"The method(s) by which the sample's absorbance measurements from the PrimaryWavelength Detector are used to call peaks (and to collect those peaks as fractions if FractionCollectionMethod is Peaks). Slope calls peaks by an algorithm that looks for sudden increases in slope leading to peaks that persist for a specified duration (PrimaryWavelengthPeakWidth). Threshold calls peaks if the absorbance measurement increases above a specified value (PrimaryWavelengthPeakThreshold). If both Slope and Threshold are selected, a peak will be called whenever either or both methods would have called a peak individually.",
				ResolutionDescription->"If PeakDetectors doesn't include PrimaryWavelength, or both PrimaryWavelengthPeakWidth and PrimaryWavelengthPeakThreshold are Null, automatically set to Null. Otherwise, if PrimaryWavelengthPeakWidth is specified or Automatic, include Slope and if PrimaryWavelengthPeakThreshold is specified, include Threshold. Also include Threshold if PrimaryWavelengthPeakWidth is Null and PrimaryWavelengthPeakThreshold is Automatic.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->MultiSelect,
					Pattern:>DuplicateFreeListableP[Slope|Threshold]
				]
			},
			(* This can only be specific values: 15 sec, 30 sec, 1 min, 2 min, 4 min, 8 min *)
			{
				OptionName->PrimaryWavelengthPeakWidth,
				Default->Automatic,
				Description->"The peak width parameter for the slope-based peak calling algorithm operating on the absorbance measurements from the PrimaryWavelength Detector. When PrimaryWavelengthPeakDetectionMethod includes Slope, the slope detection algorithm will detect peaks in the absorbance measurements from the PrimaryWavelength Detector with widths between 20% and 200% of this value.",
				ResolutionDescription->"If PeakDetectors doesn't include PrimaryWavelength or PrimaryWavelengthPeakDetectionMethod doesn't include Slope, automatically set to Null. Otherwise, automatically set to 1 Minute.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FlashChromatographyPeakWidthP (* Alternatives[15 Second,30 Second,1 Minute,2 Minute,4 Minute,8 Minute] *)
				]
			},
			{
				OptionName->PrimaryWavelengthPeakThreshold,
				Default->Automatic,
				Description->"The signal value from the PrimaryWavelength absorbance Detector above which fractions will always be collected when PrimaryWavelengthPeakDetectionMethod includes Threshold. Instrument CombiFlash Rf 200 has an upper limit of 0.5 Absorbance Units for this threshold.",
				ResolutionDescription->"If PeakDetectors doesn't include PrimaryWavelength or PrimaryWavelengthPeakDetectionMethod doesn't include Threshold, automatically set to Null. Otherwise, automatically set to 200 MilliAbsorbanceUnit.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 MilliAbsorbanceUnit,500 MilliAbsorbanceUnit],
					Units->{1,{MilliAbsorbanceUnit,{MilliAbsorbanceUnit,AbsorbanceUnit}}}
				]
			},
			{
				OptionName->SecondaryWavelengthPeakDetectionMethod,
				Default->Automatic,
				Description->"The method(s) by which the sample's absorbance measurements from the SecondaryWavelength Detector are used to call peaks (and to collect those peaks as fractions if FractionCollectionMethod is Peaks). Slope calls peaks by an algorithm that looks for sudden increases in slope leading to peaks that persist for a specified duration (SecondaryWavelengthPeakWidth). Threshold calls peaks if the absorbance measurement increases above a specified value (SecondaryWavelengthPeakThreshold). If both Slope and Threshold are selected, a peak will be called whenever either or both of them would have called a peak individually.",
				ResolutionDescription->"If PeakDetectors doesn't include SecondaryWavelength, or both SecondaryWavelengthPeakWidth and SecondaryWavelengthPeakThreshold are Null, automatically set to Null. Otherwise, if SecondaryWavelengthPeakWidth is specified or Automatic, include Slope and if SecondaryWavelengthPeakThreshold is specified, include Threshold. Also include Threshold if SecondaryWavelengthPeakWidth is Null and SecondaryWavelengthPeakThreshold is Automatic.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->MultiSelect,
					Pattern:>DuplicateFreeListableP[Slope|Threshold]
				]
			},
			(* This can only be specific values: 15 sec, 30 sec, 1 min, 2 min, 4 min, 8 min *)
			{
				OptionName->SecondaryWavelengthPeakWidth,
				Default->Automatic,
				Description->"The peak width parameter for the slope-based peak calling algorithm operating on the absorbance measurements from the SecondaryWavelength Detector. When SecondaryWavelengthPeakDetectionMethod includes Slope, the slope detection algorithm will detect peaks in the absorbance measurements from the SecondaryWavelength Detector with widths between 20% and 200% of this value.",
				ResolutionDescription->"If PeakDetectors doesn't include SecondaryWavelength or SecondaryWavelengthPeakDetectionMethod doesn't include Slope, automatically set to Null. Otherwise, automatically set to 1 Minute.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FlashChromatographyPeakWidthP (* Alternatives[15 Second,30 Second,1 Minute,2 Minute,4 Minute,8 Minute] *)
				]
			},
			{
				OptionName->SecondaryWavelengthPeakThreshold,
				Default->Automatic,
				Description->"The signal value from the SecondaryWavelength absorbance Detector above which fractions will always be collected when SecondaryWavelengthPeakDetectionMethod includes Threshold. Instrument CombiFlash Rf 200 has an upper limit of 0.5 Absorbance Units for this threshold.",
				ResolutionDescription->"If PeakDetectors doesn't include SecondaryWavelength or SecondaryWavelengthPeakDetectionMethod doesn't include Threshold, automatically set to Null. Otherwise, automatically set to 200 MilliAbsorbanceUnit.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 MilliAbsorbanceUnit,500 MilliAbsorbanceUnit],
					Units->{1,{MilliAbsorbanceUnit,{MilliAbsorbanceUnit,AbsorbanceUnit}}}
				]
			},
			{
				OptionName->WideRangeUVPeakDetectionMethod,
				Default->Automatic,
				Description->"The method(s) by which the sample's absorbance measurements from the WideRangeUV Detector are used to call peaks (and to collect those peaks as fractions if FractionCollectionMethod is Peaks). Slope calls peaks by an algorithm that looks for sudden increases in slope leading to peaks that persist for a specified duration (WideRangeUVPeakWidth). Threshold calls peaks if the absorbance measurement increases above a specified value (WideRangeUVPeakThreshold). If both Slope and Threshold are selected, a peak will be called whenever either or both of them would have called a peak individually.",
				ResolutionDescription->"If PeakDetectors doesn't include WideRangeUV, or both WideRangeUVPeakWidth and WideRangeUVPeakThreshold are Null, automatically set to Null. Otherwise, if WideRangeUVPeakWidth is specified or Automatic, include Slope and if WideRangeUVPeakThreshold is specified, include Threshold. Also include Threshold if WideRangeUVPeakWidth is Null and WideRangeUVPeakThreshold is Automatic.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->MultiSelect,
					Pattern:>DuplicateFreeListableP[Slope|Threshold]
				]
			},
			(* This can only be specific values: 15 sec, 30 sec, 1 min, 2 min, 4 min, 8 min *)
			{
				OptionName->WideRangeUVPeakWidth,
				Default->Automatic,
				Description->"The peak width parameter for the slope-based peak calling algorithm operating on the absorbance measurements from the WideRangeUV Detector. When WideRangeUVPeakDetectionMethod includes Slope, the slope detection algorithm will detect peaks in the absorbance measurements from the WideRangeUV Detector with widths between 20% and 200% of this value.",
				ResolutionDescription->"If PeakDetectors doesn't include WideRangeUV or WideRangeUVPeakDetectionMethod doesn't include Slope, automatically set to Null. Otherwise, automatically set to 1 Minute.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>FlashChromatographyPeakWidthP (* Alternatives[15 Second,30 Second,1 Minute,2 Minute,4 Minute,8 Minute] *)
				]
			},
			{
				OptionName->WideRangeUVPeakThreshold,
				Default->Automatic,
				Description->"The signal value from the WideRangeUV absorbance Detector above which fractions will always be collected when WideRangeUVPeakDetectionMethod includes Threshold. Instrument CombiFlash Rf 200 has an upper limit of 0.5 Absorbance Units for this threshold.",
				ResolutionDescription->"If PeakDetectors doesn't include WideRangeUV or WideRangeUVPeakDetectionMethod doesn't include Threshold, automatically set to Null. Otherwise, automatically set to 200 MilliAbsorbanceUnit.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 MilliAbsorbanceUnit,500 MilliAbsorbanceUnit],
					Units->{1,{MilliAbsorbanceUnit,{MilliAbsorbanceUnit,AbsorbanceUnit}}}
				]
			},
			(* Add a single or multiuse field to Model[Item, Column]? Or hard code particular columns as multi-use? *)
			{
				OptionName->ColumnStorageCondition,
				Default->Automatic,
				Description->"Indicates whether the column should be disposed of or stored after the sample run is completed and, if stored, under what condition it should be stored.",
				ResolutionDescription->"Automatically set to Disposal for single-use columns (Reusable->True) and AmbientStorage for multiple-use columns (Reusable->False). If Reusable is Null, automatically set to AmbientStorage for columns with C18, C8 or Amine FunctionalGroup, and to Disposal otherwise.",
				AllowNull->False,
				Category->"Cleaning",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget->Widget[
					Type->Enumeration,
					Pattern:>SampleStorageTypeP|Disposal
				]
			},
			(* Should always purge for columns that are being discarded, never for columns being kept. *)
			(* We let them air purge columns they intend to keep *)
			(* Would the machine even let us if they are RFID-tagged? *)
			(* Always AirPurge if column is being disposed of (throw error if user tries to say not to). Allow users to AirPurge if they are storing the column, but give a warning. *)
			{ (* todo: include the pressure this is done at *)
				OptionName->AirPurgeDuration,
				Default->Automatic,
				Description->"The amount of time to force pressurized air through the column to remove mobile phase liquid from the column.",
				ResolutionDescription->"Automatically set to 1 minute if ColumnStorageCondition is Disposal, otherwise automatically set to 0 minutes.",
				AllowNull->True,
				Category->"Cleaning",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Second,20 Minute],
					Units->{Minute,{Minute,Second}}
				]
			}
			(* Options for how to preload columns? *)
		],

		{
			OptionName->EnableSamplePreparation,
			Default->True,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if the sample preparation options for this function should be resolved. This option is set to False when an experiment is called within resolveSamplePrepOptions to avoid an infinite loop.",
			Category->"Hidden"
		},

		SimulationOption,
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SamplesOutStorageOptions,
		PreparationOption,
		ModelInputOptions
	}
];

(* ::Subsection::Closed:: *)
(*Messages*)

Error::MissingSampleVolumes="The samples, `1`, are missing volume information and cannot be processed. Please ensure the Volume field of each sample is not Null.";
Error::NonLiquidSamples="The samples, `1`, are not in the liquid state and cannot be processed. Please ensure the State field of each sample is Liquid.";

Error::InvalidFlashChromatographyPreparation="The Preparation option is specified to `1`, but ExperimentFlashChromatography can only be prepared manually. Please leave Preparation unspecified or specify it to Manual or Automatic.";
Warning::MixedSeparationModes="The separation modes indicated by the specified Column, `1`, Cartridge, `2`, or CartridgeFunctionalGroup, `3`, options are not all the same. Results may be unsatisfactory if columns or cartridges with different intended separation modes are used together. All Automatic options will be resolved for `4` separation. If this is not desired, please specify a different SeparationMode or call ExperimentFlashChromatography separately for desired SeparationMode.";
Warning::MismatchedSeparationModes="The specified SeparationMode, `1`, doesn't match the separation modes indicated by the specified Column, `2`, Cartridge, `3`, and CartridgeFunctionalGroup, `4`, options. All Automatic options will be resolved for `1` separation. If this is not desired, please specify a different SeparationMode or call ExperimentFlashChromatography separately for desired SeparationMode.";
Error::IncompleteBufferSpecification="Only one of BufferA, `1`, and BufferB, `2`, is specified, but BufferA and BufferB must be specified together or not at all. Please either specify both buffers or specify neither to use BufferA: `4` and BufferB: `5`, the default buffers for the SeparationMode (`3`).";

Error::MismatchedCartridgeOptions="Some cartridge-related options (Cartridge, `2`, CartridgePackingMaterial, `3`, CartridgeFunctionalGroup, `4`, CartridgePackingMass, `5`, and CartridgeDryingTime, `6`) that are index-matched to `1` are specified and some are Null. Please ensure that if any cartridge-related options are specified for a sample, none of the others are Null and vice versa.";
Error::MismatchedSolidLoadNullCartridgeOptions="For samples, `1`, LoadingType is specified to Solid, but some cartridge-related options (Cartridge, `2`, CartridgePackingMaterial, `3`, CartridgePackingMass, `4`, and CartridgeDryingTime, `5`) are Null. Please ensure that if LoadingType is specified to Solid, that cartridge-related options are either left unspecified to resolve automatically or are specified to non-Null values.";
Error::MismatchedLiquidLoadSpecifiedCartridgeOptions="For samples, `1`, LoadingType is specified to Liquid, but some cartridge-related options (Cartridge, `2`, CartridgePackingMaterial, `3`, CartridgeFunctionalGroup, `4`, CartridgePackingMass, `5`, and CartridgeDryingTime, `6`) are specified. Please ensure that if LoadingType is specified to Liquid, that no cartridge-related options are specified. To load samples in solid load cartridges, please specify LoadingType to Solid.";
Warning::RecommendedMaxLoadingPercentExceeded="The specified MaxLoadingPercent values, `1`, are greater than `2`, the recommended MaxLoadingPercent values for the resolved LoadingType values, `3`. Results may be unsatisfactory if recommended MaxLoadingPercent values are exceeded.";
Error::DeprecatedColumn="The specified columns, `1`, are Deprecated->True. Please specify columns with Models with Deprecated field values of False or Null, or leave the Column option unspecified and it will automatically resolve to appropriate columns of the resolved SeparationMode, `2`.";
Error::IncompatibleColumnType="The specified columns, `1`, have ChromatographyType, `2`. Please specify columns with ChromatographyType Flash, or leave the Column option unspecified and it will automatically resolve to appropriate columns of the resolved SeparationMode, `3`.";
Error::IncompatibleFlowRates="The MinFlowRate, `1`, and MaxFlowRate, `2`, of the specified `3`, `4`, do not overlap with those of the `5`, `6`: `7` to `8`. Please specify `3` with flow rates compatible with the `5` or leave the `9` option unspecified.";
Error::InsufficientSampleVolumeFlashChromatography="The specified LoadingAmount values, `1`, are larger than the Volume values, `2`, of the samples, `3`. Please either specify lower LoadingAmount or use samples with higher volumes.";
Error::InvalidLoadingAmountForColumn="The specified LoadingAmount values, `1`, are larger than the MaxLoadingPercent times the VoidVolume, `2` * `3` = `4`, of the Model of the specified columns, `5`. Please either decrease LoadingAmount, increase MaxLoadingPercent, or specify columns with Models with larger VoidVolume values.";
Error::InvalidLoadingAmount="The specified LoadingAmount values, `1`, are larger than the MaxLoadingPercent times the VoidVolume, `2` * `3` = `4`, of the largest default column Model, `5`, of the SeparationMode, `6`. Please either decrease LoadingAmount, increase MaxLoadingPercent, or specify columns with Models with larger VoidVolume values.";
Error::InvalidLoadingAmountForInstrument="For samples, `1`, the resolved LoadingAmount values, `2`, are outside of the MinSampleVolume to MaxSampleVolume interval, `3`, of the resolved Instrument, `4`. Please ensure that the specified LoadingAmount (and the sample or aliquot volume) falls within the range of values allowed for the instrument.";
Error::InvalidLoadingAmountForSyringes="For samples, `1`, the resolved LoadingAmount values, `2`, are outside of the interval of values, `3`, that can be transferred by instrument-compatible syringes, `4`. Please ensure that the specified LoadingAmount (and the sample or aliquot volume) falls within the range of values that can be transferred by compatible syringes, or contact ECL to add new syringe models.";
Error::IncompatibleCartridgeLoadingType="The Cartridge option is specified, `1`, but the values of LoadingType are `2`. Solid load cartridges can only be used with the Solid LoadingType. Please set the values of LoadingType to Solid or leave the Cartridge option unspecified.";
Error::IncompatibleCartridgeType="The specified cartridges, `1`, have ChromatographyType, `2`. Please specify cartridges with ChromatographyType Flash, or leave the Cartridge option unspecified.";
Error::IncompatibleCartridgePackingType="The specified cartridges, `1`, have PackingType, `2`. Please specify cartridges with PackingType Prepacked or HandPacked, or leave the Cartridge option unspecified.";

Error::IncompatibleInjectionAssemblyLength="The total length of the injection assemblies (column length + (optional) cartridge length + injection valve length) for resolved columns, `1`, and cartridges, `2`, are `3` + `4` + `5` = `6` which are either undefined or greater than the MaxInjectionAssemblyLength of the instrument, `7`: `8`. Please specify shorter columns or cartridges or ensure that their ColumnLength and CartridgeLength fields are informed.";
Error::InvalidCartridgeMaxBedWeight="The cartridges, `1`, have MaxBedWeight, `2`, but only cartridges with MaxBedWeight values of 5, 25, or 65 grams are compatible with the cartridge caps necessary to load the cartridges on the instrument. Please specify a cartridge with ChromatographyType Flash and a MaxBedWeight of 5, 25, or 65 grams.";
Warning::MismatchedColumnAndPrepackedCartridge="The SeparationMode, PackingMaterial, and FunctionalGroup fields of the columns, `1`, are (`2`, `3`, `4`) which are not the same as those of the Prepacked cartridges, `5`, which are (`6`, `7`, `8`). Results may be unsatisfactory if these values do not match.";
Error::InvalidCartridgePackingMaterial="CartridgePackingMaterial is specified to `1` but the resolved cartridges, `2`, have PackingType `3`. CartridgePackingMaterial can only be specified if a cartridge with a Model with a PackingType of HandPacked is specified. Please specify HandPacked cartridges or leave CartridgePackingMaterial unspecified.";
Error::InvalidCartridgeFunctionalGroup="CartridgeFunctionalGroup is specified to `1` but the resolved cartridges, `2`, have PackingType `3`. CartridgeFunctionalGroup can only be specified if a cartridge with a Model with a PackingType of HandPacked is specified. Please specify HandPacked cartridges or leave CartridgeFunctionalGroup unspecified.";
Warning::MismatchedColumnAndCartridge="The PackingMaterial and FunctionalGroup fields of the columns, `1`, are (`2`, `3`) which are not the same as the resolved CartridgePackingMaterial and CartridgeFunctionalGroup options of the cartridges, `4`, which are (`5`, `6`). Results may be unsatisfactory if these values do not match.";
Error::InvalidCartridgePackingMass="CartridgePackingMass is specified to `1` but the resolved cartridges, `2`, have PackingType `3`. CartridgePackingMass can only be specified if a cartridge with a Model with a PackingType of HandPacked is specified. Please specify HandPacked cartridges or leave CartridgePackingMass unspecified.";
Error::TooHighCartridgePackingMass="CartridgePackingMass is specified to `1` but the resolved cartridges, `2`, have MaxBedWeight `3`. CartridgePackingMass must be less than or equal to the cartridge's Model's MaxBedWeight. Please specify larger cartridges or lower values of CartridgePackingMass or leave CartridgePackingMass unspecified.";
Error::TooLowCartridgePackingMass="For samples, `1`, the resolved values of CartridgePackingMass, `2`, must be greater than or equal to the resolved LoadingAmount times the cartridge loading factor: `3` * `4` = `5`. Please specify a higher CartridgePackingMass (and a larger Cartridge if necessary) or a lower LoadingAmount.";
Error::InvalidPackingMassForCartridgeCaps="For samples, `1`, the resolved CartridgePackingMass values, `2`, are outside of the interval of values, `3`, that can be loaded into cartridges attached to instrument-compatible cartridge caps, `4`. Please ensure that the specified CartridgePackingMass falls within the range of values that can be accommodated by compatible cartridge caps.";
Error::IncompatibleFlowRateFlashChromatography="The values of FlowRate, `1`, do not fall within the MinFlowRate to MaxFlowRate ranges of the Instrument, `2`, `3` to `4`, the columns, `5`, `6` to `7`, and the cartridges (if cartridges are being used), `8`, `9` to `10`. Please choose values of FlowRate in the intervals, `11` or specify an instrument, columns, and cartridges with compatible flow rates.";
Error::IncompatiblePreSampleEquilibration="PreSampleEquilibration is specified to `1`, but the LoadingType is Preloaded. PreSampleEquilibration cannot be specified if LoadingType is Preloaded. Please change the LoadingType to Solid or Liquid or leave PreSampleEquilibration unspecified.";
Error::RedundantGradientShortcut="For samples, `1`, some of the shortcut gradient options (GradientStart, GradientEnd, GradientDuration, EquilibrationTime, or FlushTime) and some of the non-shortcut gradient options (Gradient, GradientA, or GradientB) are specified but the gradients don't match one another. Shortcuts and non-shortcuts may not be specified together for the same sample unless they specify the same gradient. Please specify just shortcut options or just non-shortcut options, or specify the same gradient with each, or leave them unspecified to use a default gradient.";
Error::IncompleteGradientShortcut="For samples, `1`, some of the shortcut gradient options (GradientStart, GradientEnd, GradientDuration, EquilibrationTime, or FlushTime) are specified, but all of GradientStart, GradientEnd, and GradientDuration are not specified. GradientStart, GradientEnd, and GradientDuration must all be specified to specify a gradient for a sample. Please specify GradientStart, GradientEnd, and GradientDuration or leave all gradient shortcut options unspecified.";
Error::ZeroGradientShortcut="For samples, `1`, the gradient shortcut options were used to specify gradients, but the total lengths of time of the gradients are 0 minutes. Please increase the time of the GradientDuration, EquilibrationTime and/or FlushTime options.";
Error::RedundantGradientSpecification="For samples, `1`, more than one of the gradient options (Gradient, GradientA, or GradientB) are specified and they do not match each other. If more than one of these options is specified, they must all indicate the same gradient. Please specify just one of Gradient, GradientA, or GradientB or make sure that all specified gradients match.";
Error::InvalidGradientTime="The `1` option is specified to `2`. The specified times, `3`, are invalid. Please specify the gradient with monotonically increasing times beginning at 0 minutes and ending at greater than 0 minutes.";
Error::InvalidTotalGradientTime="For samples, `1`, the total resolved GradientB times are `2` which are higher than the maximum time allowed for flash chromatography gradients, `3`. Please specify a shorter gradient.";
Warning::MethanolPercent="For samples, `1`, BufferB is methanol and the GradientB values are `2` which include values higher than 50%, the maximum recommended percentage of methanol that should be used with silica-based solid media. Using greater than 50% methanol may give unsatisfactory results due to the silica dissolving.";
Error::InvalidFractionCollectionOptions="For samples, `1`, CollectFractions is True, but some fraction collection-related options (FractionCollectionStartTime, `2`, FractionCollectionEndTime, `3`, FractionContainer, `4`, MaxFractionVolume, `5`, or FractionCollectionMode, `6`) are Null. Please ensure that if CollectFractions is True, that fraction collection-related options are either left unspecified to resolve automatically or are specified to non-Null values. To not collect fractions, please specify CollectFractions to False.";
Error::InvalidCollectFractions="For samples, `1`, CollectFractions is False, but some fraction collection-related options (FractionCollectionStartTime, `2`, FractionCollectionEndTime, `3`, FractionContainer, `4`, MaxFractionVolume, `5`, or FractionCollectionMode, `6`) are specified. Please ensure that if CollectFractions is False, that fraction collection-related options are either Null, Automatic, or are left unspecified. To collect fractions, please specify CollectFractions to True.";
Error::MismatchedFractionCollectionOptions="Some fraction collection-related options (FractionCollectionStartTime, `2`, FractionCollectionEndTime, `3`, FractionContainer, `4`, MaxFractionVolume, `5`, or FractionCollectionMode, `6`) that are index-matched to `1` are specified and some are Null. Please ensure that if any fraction collection-related options are specified for a sample, none of the others are Null and vice versa.";
Error::InvalidFractionCollectionStartTimeFlash="FractionCollectionStartTime is specified to `1`, but the total resolved GradientB lengths are `2`. FractionCollectionStartTime must be less than the total gradient time. Please either reduce FractionCollectionStartTime, leave FractionCollectionStartTime unspecified, or specify longer gradients.";
Error::InvalidFractionCollectionEndTimeFlash="FractionCollectionEndTime is specified to `1`, but the resolved FractionCollectionStartTime values are `3` and the total resolved GradientB lengths are `2`. FractionCollectionEndTime must be greater than FractionCollectionStartTime and less than or equal to the total gradient time. Please ensure that FractionCollectionStartTime < FractionCollectionEndTime <= `2`.";
Error::InvalidFractionContainer="The specified values of FractionContainer, `1`, are not on the list of allowed flash chromatography fraction collection containers, `2`. Please specify fraction containers from the list, or leave the option unspecified to resolve it automatically.";
Error::InvalidMaxFractionVolumeForContainer="The specified values of MaxFractionVolume, `1`, are larger than, `2`, which are `3` times the MaxVolume, `4`, of the specified FractionContainer values, `5`. Please specify a lower MaxFractionVolume or a larger FractionContainer or leave the options unspecified to resolve them automatically.";
Error::InvalidMaxFractionVolume="The specified values of MaxFractionVolume, `1`, are larger than, `2`, which is `3` times the MaxVolume, `4`, of the largest default FractionContainer, `5`. Please specify a lower MaxFractionVolume or leave the option unspecified to resolve it automatically.";
Error::InvalidSpecifiedDetectors="For samples, `1`, some detector options (PrimaryWavelength, `2`, SecondaryWavelength, `3`, WideRangeUV, `4`) are specified, but are not included in the lists of detectors set by the Detectors option, `5`. All specified detector options must be included in Detectors. Please specify Detectors to include all the desired detectors.";
Error::InvalidNullDetectors="For samples, `1`, some detector options (PrimaryWavelength, `2`, SecondaryWavelength, `3`, WideRangeUV, `4`) are Null, but are included in the lists of detectors set by the Detectors option, `5`. If a detector option is set to Null, it must not be included in Detectors. Please specify Detectors to include only the desired detectors.";
Error::InvalidWideRangeUV="For samples, `1`, WideRangeUV is specified to `2`. WideRangeUV should be specified as a span of wavelengths of light in the form minimumWavelength;;maximumWavelength. Please ensure that the first element of the Span of WideRangeUV is less than or equal to the second element.";
Error::MissingPeakDetectors="For samples, `1`, the specified values of the PeakDetectors option are `2` which are not all included in the list of detectors, `3`. Only detectors included in the Detectors option can be used for peak detection. Please ensure that all elements of PeakDetectors are also present in Detectors.";

Error::InvalidSpecifiedPeakDetection="For samples, `1`, some peak detection-related options (`2`: `3`, `4`: `5`, `6`: `7`) are specified, but the associated detector, `8`, is not included in the PeakDetectors option, `9`. The detector for all specified peak detection options must be included in PeakDetectors. Please specify PeakDetectors to include `8`, or set `8`-related peak detection options to Automatic or Null.";
Error::InvalidNullPeakDetectionMethod="For samples, `1`, `2` is set to Null but the associated detector, `3`, is included in the resolved PeakDetectors option, `4`. If a detector is included in PeakDetectors, the associated PeakDetectionMethod option cannot be set to Null. Please specify `2` to a non-Null value or Automatic, or do not include `3` in PeakDetectors.";
Error::InvalidNullPeakDetectionParameters="For samples, `1`, both `2` and `3` are set to Null, but the associated detector, `4` is included in the resolved PeakDetectors option, `5`. If a detector is included in PeakDetectors, the associated PeakWidth and PeakThreshold options cannot both be set to Null. Please specify `2` and/or `3` to non-Null values or Automatic, or do not include `4` in PeakDetectors.";
Error::InvalidPeakWidth="For samples, `1`, `2` is specified to `3`, but `4` is resolved to `5` which does not include Slope. If a PeakWidth option is specified, the associated PeakDetectionMethod must include Slope. Please specify `4` to include Slope, or set `2` to Automatic or Null.";
Error::InvalidPeakThreshold="For samples, `1`, `2` is specified to `3`, but `4` is resolved to `5` which does not include Threshold. If a PeakThreshold option is specified, the associated PeakDetectionMethod must include Threshold. Please specify `4` to include Threshold, or set `2` to Automatic or Null.";
Error::InvalidColumnStorageCondition="For samples, `1`, columns, `2`, have ColumnStorageCondition specified to Disposal, but the Columns are also specified to be used with later input samples. Columns can not be disposed of until after the last time they are specified to be used. Please only set ColumnStorageCondition to Disposal for the last time the column will be used.";
Error::InvalidAirPurgeDuration="For samples, `1`, columns, `2`, have AirPurgeDuration specified to `3`, but ColumnStorageCondition is `4`. Columns that are being disposed of must be air purged. Please either specify AirPurgeDuration to greater than 0 Minute, leave AirPurgeDuration unspecified so that it resolves automatically, or specify ColumnStorageCondition to indicate how the column should be stored.";
Warning::AirPurgeAndStoreColumn="For samples, `1`, columns, `2`, have AirPurgeDuration specified to `3`, but ColumnStorageCondition is `4`. The columns will be air purged before being stored. If this is not desired, please change the specification of AirPurgeDuration or ColumnStorageCondition. It is not recommended to air purge columns that will be kept for future use.";
Error::InvalidNullCartridgeLabel="For samples, `1`, Cartridge is resolved to `2`, but CartridgeLabel is specified to `3`. CartridgeLabel cannot be Null if Cartridge is non-Null. Please specify CartridgeLabel to a non-Null value, or leave it unspecified to resolve automatically.";
Error::InvalidSpecifiedCartridgeLabel="For samples, `1`, Cartridge is resolved to `2`, but CartridgeLabel is specified to `3`. CartridgeLabel cannot be a String if Cartridge is Null. Please specify CartridgeLabel to Null or Automatic. Alternatively, please specify LoadingType to Solid if you wish to load sample into a solid load cartridge.";
Error::InvalidLabel="Some values of `1` are duplicates: `2`, but the corresponding `3` values are different: `4`. If any `1` values are the same `5`, the index-matched `3` values must be identical. Please ensure that any duplicate `5` values in `1` have corresponding `3` values that are identical to one another.";
(* Error::InvalidLabel example calls for:
	invalidColumnObjectLabel
	1: Column
	2: {list of duplicate columns}
	3: ColumnLabel
	4: {list of corresponding labels}
	5: Object[Item,Column]

	invalidColumnLabel
	1: ColumnLabel
	2: {list of duplicate labels}
	3: Column
	4: {list of corresponding columns}
	5: String
*)
Error::InvalidTotalBufferVolume="The total volume of `1` required for the experiment is `2`, but the maximum volume of `1` allowed for the experiment is `3`. Please reduce the required volume of `1` either by reducing the number of samples, by reducing the total length of time of the Gradient, or by reducing the FlowRate while keeping the length of time of the Gradient constant. With automatic option resolution, larger columns use a higher FlowRate and more `1`, so also consider using a smaller column and, if necessary, loading less sample.";
Error::InvalidTotalFractionVolume="For samples, `1`, FractionCollectionMode is All and the total number of required FractionContainers, `2`, is `3`, which is more than `4`, the maximum number that can be held in two compatible fraction collection racks, `5`. Please reduce the total number of fractions to be collected by either setting FractionCollectionMode to Peaks, by reducing the duration of the Gradient, by reducing the duration of the fraction collection time window specified by FractionCollectionStartTime and FractionCollectionEndTime, by increasing the specified MaxFractionVolume, or by specifying a FractionContainer with a higher MaxVolume.";
Warning::TotalFractionVolume="For samples, `1`, FractionCollectionMode is Peaks and the total number of required FractionContainers, `2`, could be as high as `3` (if peaks are called for the entire fraction collection duration), which is more than `4`, the maximum number that can be held in two compatible fraction collection racks, `5`. If two racks of fractions are collected before the end of the gradient, the experiment will end early. If this is not desired, please reduce the total number of fractions to be collected either by reducing the duration of the Gradient, by reducing the duration of the fraction collection time window specified by FractionCollectionStartTime and FractionCollectionEndTime, by increasing the specified MaxFractionVolume, or by specifying a FractionContainer with a higher MaxVolume.";


(* ::Subsection::Closed:: *)
(*Helper Functions*)

(*fetchModelPacketFromFastAssoc*)
(* A helper function to return the model packet for an object or model from a fast association *)
fetchModelPacketFromFastAssoc[myObject_,myAssoc_Association]:=Switch[myObject,

	(* If myObject is a Model, return its packet from the fast association *)
	ObjectP[Model],fetchPacketFromFastAssoc[myObject,myAssoc],

	(* If myObject is an Object, return the packet of its model from the fast association *)
	ObjectP[Object],fetchPacketFromFastAssoc[fastAssocLookup[myAssoc,myObject,Model],myAssoc],

	(* Otherwise, return an empty association *)
	_,<||>
];


(* Helper function that returns a list of CombiFlash compatible syringes *)
combiFlashCompatibleSyringe[memoization_String]:=combiFlashCompatibleSyringe[memoization]=Module[{},

	If[!MemberQ[$Memoization,Experiment`Private`combiFlashCompatibleSyringe],
		AppendTo[$Memoization,Experiment`Private`combiFlashCompatibleSyringe]
	];

	Search[
		Model[Container,Syringe],
		And[
			Deprecated!=True,
			ConnectionType==LuerLock,
			Reusable==False,
			StringContainsQ[Name,"syringe",IgnoreCase->True],
			DeveloperObject!=True
		]
	]
];

(* Helper function that returns a list of CombiFlash compatible cartridge caps *)
combiFlashCompatibleCartridgeCap[memoization_String]:=combiFlashCompatibleCartridgeCap[memoization]=Module[{},

	If[!MemberQ[$Memoization,Experiment`Private`combiFlashCompatibleCartridgeCap],
		AppendTo[$Memoization,Experiment`Private`combiFlashCompatibleCartridgeCap]
	];

	Search[
		Model[Part,CartridgeCap],
		And[
			Deprecated!=True,
			SupportedInstruments==Model[Instrument,FlashChromatography,"id:bq9LA0dBGGDe"],
			DeveloperObject!=True
		]
	]
];


(* Helper function that returns a list of CombiFlash compatible racks
Expected to return the following, but it should gracefully handle new compatible racks:
{Model[Container,Rack,"18mm Tube Rack"],Model[Container,Rack,"25mm Tube Rack"],Model[Container,Rack,"16mm Tube Rack"]} *)
combiFlashCompatibleRack[memoization_String]:=combiFlashCompatibleRack[memoization]=Module[{},

	If[!MemberQ[$Memoization,Experiment`Private`combiFlashCompatibleRack],
		AppendTo[$Memoization,Experiment`Private`combiFlashCompatibleRack]
	];

	Search[
		Model[Container,Rack],
		And[
			Deprecated!=True,
			Footprint==CombiFlashRack,
			DeveloperObject!=True
		]
	]
];

DefineOptions[
	combiFlashCompatibleFractionContainer,
	Options:>{CacheOption}
];

(* Helper function that returns a list of CombiFlash compatible fraction collection containers for each
CombiFlash compatible rack *)
(* Expected to return the following, but it should gracefully handle new compatible racks and tubes:
	{
		{Model[Container,Vessel,"15mL Tube"]},
		{},
		{}
	}
*)
combiFlashCompatibleFractionContainer[memoization_String,ops:OptionsPattern[]]:=combiFlashCompatibleFractionContainer[memoization]=Module[
	{
		safeOps,racks,maxDiameters,maxHeights,compatibleContainers
	},

	If[!MemberQ[$Memoization,Experiment`Private`combiFlashCompatibleFractionContainer],
		AppendTo[$Memoization,Experiment`Private`combiFlashCompatibleFractionContainer]
	];

	(* Get the safe options *)
	safeOps=SafeOptions[combiFlashCompatibleFractionContainer,ToList[ops]];

	(* Get a list of all CombiFlash compatible racks *)
	racks=combiFlashCompatibleRack["Memoization"];

	(* Get the max diameters and heights of the wells of each type of compatible rack *)
	{maxDiameters,maxHeights}=Transpose[Download[
		racks,
		{WellDiameter,Positions[[1,5]]},
		Cache->Lookup[safeOps,Cache]
	]];

	(* Get the containers that would be compatible with each type of compatible rack *)
	(* This search must be narrower than the one finding potential fraction containers for the big download in the main
	ExperimentFlashChromatography function *)
	compatibleContainers=MapThread[
		Function[{maxDiameter,maxHeight},
			Search[
				Model[Container,Vessel],
				And[
					Deprecated!=True,
					CrossSectionalShape==Circle,
					Opaque!=True,
					InternalBottomShape==(RoundBottom|VBottom),
					CoverTypes!={},
					MaxVolume>=15 Milliliter,
					Dimensions[[1]]<maxDiameter,
					Dimensions[[1]]>maxDiameter*0.9,
					Dimensions[[3]]<maxHeight,
					Dimensions[[3]]>maxHeight*0.7,
					DeveloperObject!=True
				],
				SubTypes->False
			]
		],
		{maxDiameters,maxHeights}
	]
];


(* A helper function that takes the FlowRate, PreSampleEquilibrium, GradientA, and GradientB values,
and returns the total volume of buffer A and B required for the experiment in the form {bufferAVolume,bufferBVolume} *)
flashChromatographyBufferVolumes[myFlowRate_,myPreSampleEquilibration_,myGradientA_,myGradientB_]:=Module[
	{
		extraBufferVolume,bufferAVolumes,bufferBVolumes
	},

	(* Set an extra buffer dead volume *)
	(* If you change this, also change the line in simulateExperimentFlashChromatography where 300 mL is subtracted out*)
	extraBufferVolume=300 Milliliter;

	(* Get lists of the volumes of buffer A and B required for each sample *)
	{bufferAVolumes,bufferBVolumes}=Transpose[
		MapThread[
			Function[{flowRate,preSampleEquilibration,gradientA,gradientB},

				(* Return the total volume of buffer A and B required for this sample by mapping over gradient A and B *)
				Map[
					Function[{gradient},
						Module[{gradientTimes,gradientTimeLengths,equilibrationTimeLength,primeFlushBufferVolume,bufferFractions,equilibrationBufferVolume,bufferFractionAverages,gradientBufferVolume},

							(* Get the times from the gradient *)
							gradientTimes=gradient[[All,1]];

							(* Get the length of time of each segment of the gradient *)
							gradientTimeLengths=Differences[gradientTimes];

							(* If PreSampleEquilibration is Null, use 0 minutes instead *)
							equilibrationTimeLength=If[TimeQ[preSampleEquilibration],preSampleEquilibration,0 Minute];

							(* The volume of buffer used for priming/flushing the system before/after sample separation *)
							primeFlushBufferVolume=100 Milliliter;

							(* Get the fraction of buffer at each gradient time *)
							bufferFractions=Unitless[gradient[[All,2]],Percent]/100.;

							(* Get the volume of buffer used for equilibration of the column (% buffer * time * flow rate) *)
							equilibrationBufferVolume=First[bufferFractions]*equilibrationTimeLength*flowRate;

							(* Get the average fraction of buffer during each segment of the gradient *)
							bufferFractionAverages=MovingAverage[bufferFractions,2];

							(* Get the volume of buffer used during the gradient *)
							gradientBufferVolume=Total[bufferFractionAverages*gradientTimeLengths*flowRate];

							(* Return the total volume of this buffer used for this sample *)
							primeFlushBufferVolume+equilibrationBufferVolume+gradientBufferVolume
						]
					],
					{gradientA,gradientB}
				]
			],
			{myFlowRate,myPreSampleEquilibration,myGradientA,myGradientB}
		]
	];

	(* Return the total volume of buffer A and B required for the experiment *)
	{
		Total[bufferAVolumes]+extraBufferVolume,
		Total[bufferBVolumes]+extraBufferVolume
	}
];

(* A helper function that take the resolved FractionContainer option,
and returns an index-matched list of fraction collection rack models to use with them *)
flashChromatographyRackModels[myResolvedFractionContainer_]:=Module[
	{
		compatibleRacksList,compatibleContainersListOfLists,compatibleContainerToRackRules
	},

	(* Get a list of compatible fraction collection racks *)
	compatibleRacksList=combiFlashCompatibleRack["Memoization"];

	(* Get a list of lists of fraction collection containers compatible with each rack *)
	(* Index matched to the above list of racks *)
	compatibleContainersListOfLists=combiFlashCompatibleFractionContainer["Memoization"];

	(* Get a list of rules linking each compatible fraction collection container to the fraction collection rack it is
	compatible with. In the form container->rack. *)
	compatibleContainerToRackRules=DeleteDuplicates[Flatten[
		MapThread[
			Function[{compatibleContainersList,compatibleRack},
				Map[
					#->compatibleRack&,
					compatibleContainersList
				]
			],
			{compatibleContainersListOfLists,compatibleRacksList}
		]
	]];

	(* Return a list of required rack models, index matched to FractionContainer (and therefore to SamplesIn) *)
	myResolvedFractionContainer/.compatibleContainerToRackRules
];

(* A helper function that take the resolved CollectFractions, FractionCollectionStartTime, FractionCollectionEndTime,
FlowRate, and MaxFractionVolume options and returns an index-matched list of the maximum number of fraction collection
containers that are needed. *)
flashChromatographyNumbersOfContainers[myResolvedCollectFractions_,myResolvedFractionCollectionStartTime_,myResolvedFractionCollectionEndTime_,myResolvedFlowRate_,myResolvedMaxFractionVolume_]:=Module[
	{
		fractionCollectionTimes,maxTotalFractionVolumes
	},

	(* Get the amount of time for which fractions are collected for each sample *)
	(* For each sample, if CollectFractions is True, return the length of the fraction collection time, otherwise return 0 Minute *)
	fractionCollectionTimes=MapThread[
		If[TrueQ[#1],
			#3-#2,
			0 Minute
		]&,
		{myResolvedCollectFractions,myResolvedFractionCollectionStartTime,myResolvedFractionCollectionEndTime}
	];

	(* Get the maximum total volume of all fractions collected for each sample *)
	(* If FractionCollectionMode is All, exactly this much should be collected *)
	(* If FractionCollectionMode is Peaks, up to this much should be collected *)
	(* If FractionCollectionMode is Null, 0 Milliliter will be collected *)
	(* Allow for 10% extra volume to account for instrument variability and ensure we have enough fraction containers *)
	maxTotalFractionVolumes=fractionCollectionTimes*myResolvedFlowRate*1.1;

	(* Return the index-matched list of the number of max number of fraction containers required for each sample *)
	(* If CollectFractions is True, the max number of containers required is found by dividing the max total fraction
	volume by the max fraction volume allowed per container, then rounding up to the nearest integer
	If CollectFractions is False, we don't need any containers *)
	MapThread[
		If[TrueQ[#1],
			Ceiling[#2/#3],
			0
		]&,
		{myResolvedCollectFractions,maxTotalFractionVolumes,myResolvedMaxFractionVolume}
	]
];

(* Must round sample volume to the same precision in resolver, resource packets, and simulation function, so define here *)
flashChromatographyVolumePrecision[]:=10^-1 Milliliter;


DefineOptions[
	flashChromatographyFractionCompositions,
	Options:>{
		{SampleIndex->Null,_Integer,"Indicates the index of the sample whose fraction's compositions should be calculated. If Null, the compositions of all sample's fractions are calculated."},
		SimulationOption,
		CacheOption
	}
];

(* A helper function that takes a FlashChromatography protocol and lists of the start and end times of each fraction for
each sample and returns lists of the compositions of each fraction for each sample. The relative amounts of BufferA and
BufferB are determined by each fraction's start and end time within the gradient, the amounts of the components from the
sample are set to Null *)
flashChromatographyFractionCompositions[
	myProtocol:ObjectP[Object[Protocol,FlashChromatography]],
	myFractionStartTimes:{{TimeP...}..},
	myFractionEndTimes:{{TimeP...}..},
	myOptions:OptionsPattern[]
]:=Module[
	{
		safeOps,cache,simulation,sampleIndex,
		bufferAComposition,bufferBComposition,samplesInCompositions,workingSamplesCompositions,gradientBField,sampleCompositions,
		index
	},

	(* Get the safe options *)
	safeOps=SafeOptions[flashChromatographyFractionCompositions,ToList[myOptions]];

	(* Lookup option values *)
	{cache,simulation,sampleIndex}=Lookup[safeOps,{Cache,Simulation,SampleIndex}];

	(* Download information from our protocol object *)
	{
		bufferAComposition,
		bufferBComposition,
		samplesInCompositions,
		workingSamplesCompositions,
		gradientBField
	}=Quiet[
		Download[
			myProtocol,
			{
				BufferA[Composition],
				BufferB[Composition],
				SamplesIn[Composition],
				WorkingSamples[Composition],
				GradientB
			},
			Cache->cache,
			Simulation->simulation
		],
		{Download::NotLinkField,Download::FieldDoesntExist}
	];

	(* If the Composition of the WorkingSamples is defined, then use it, otherwise use the Composition of the samplesIn.
	When this function is called by importPeakTrak in the parser to actually define the fraction composition, WorkingSamples
	will be defined. In the simulation, we use the composition of the SamplesIn instead.
	remove time from composition *)
	sampleCompositions=MapThread[
		If[NullQ[#2], #1[[All, {1, 2}]], #2[[All, {1, 2}]]]&,
		{samplesInCompositions,workingSamplesCompositions}
	];

	(* Get the index of the sample to calculate fraction for (or do it for All samples if the option is unspecified) *)
	index=If[NullQ[sampleIndex],All,{sampleIndex}];

	(* For each sample, get a list of the compositions of each fraction: the relative amounts of BufferA and BufferB are
	determined by each fraction's start and end time within the gradient, the amounts of the components from the sample are Null *)
	MapThread[
		Function[{startTimes,endTimes,sampleComposition,gradientB},
			Module[{extendedGradientB,interpolatableGradientB,fGradientB,bufferBPercents,bufferBProportions,bufferAProportions},

				(* Extend the last step of gradient B by 1 minute *)
				(* To account for the instrument sometimes collecting fractions slightly beyond the specified end time *)
				extendedGradientB=Append[gradientB,{First[Last[gradientB]]+1 Minute,Last[Last[gradientB]]}];

				(* Get a version of gradient B that can be interpolated (no duplicate x-values) *)
				interpolatableGradientB=extendedGradientB+Array[{# Microsecond,0 Percent}&,Length[extendedGradientB],0];

				(* Get a piecewise linear function of gradient B*)
				fGradientB=Interpolation[interpolatableGradientB,InterpolationOrder->1];

				(* Get the average buffer B percentage for each collected fraction *)
				(* Add 1 Microsecond to the end times so that we can still calculate a value, even if startTime==endTime
				for a particular fraction (the instrument sometimes generates fractions like this when it skips over a tube) *)
				bufferBPercents=MapThread[
					Integrate[fGradientB[x],{x,#1,#2}]/(#2-#1)&,
					{startTimes,endTimes+1 Microsecond}
				];

				(* Get the proportion of each collected fraction that is made up by buffer B and by buffer A *)
				(* The Min call prevents rounding errors that would lead to very small negative buffer A proportions *)
				bufferBProportions=Map[Min[#,1]&,Unitless[bufferBPercents,Percent]/100];
				bufferAProportions=1-bufferBProportions;

				(* Return a list of the fractions' compositions with the appropriate amounts of the components of buffer
				A and B based on the time the fraction was collected and with Null amounts of the components of the sample,
				or nothing for the sample if the sample's composition is Null *)
				MapThread[
					Join[
						bufferAComposition[[All, {1, 2}]]/.{{composition:CompositionP,model:IdentityModelP}:>{#1*composition,Link[model]}},
						bufferBComposition[[All, {1, 2}]]/.{{composition:CompositionP,model:IdentityModelP}:>{#2*composition,Link[model]}},
						If[NullQ[sampleComposition],
							Nothing,
							sampleComposition/.{{CompositionP,model:IdentityModelP}:>{Null,Link[model]}}
						]
					]&,
					{bufferAProportions,bufferBProportions}
				]
			]
		],
		{myFractionStartTimes,myFractionEndTimes,sampleCompositions[[index]],gradientBField[[index]]}
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentFlashChromatography*)

(* Mixed input overload *)
ExperimentFlashChromatography[
	myInputs:ListableP[Alternatives[
		ObjectP[{Object[Container],Object[Sample],Model[Sample]}],
		_String,
		{LocationPositionP,_String|ObjectP[Object[Container]]}
	]],
	myOptions:OptionsPattern[]
]:=Module[
	{
		listedContainers,listedOptions,outputSpecification,output,gatherTests,containerToSampleResult,samples,
		sampleOptions,containerToSampleTests,containerToSampleOutput,validSamplePreparationResult,containerToSampleSimulation,
		mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Remove temporal links and named objects. *)
	{listedContainers,listedOptions}={ToList[myInputs],ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentFlashChromatography,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
			ExperimentFlashChromatography,
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
			{containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
				ExperimentFlashChromatography,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->{Result,Simulation},
				Simulation->updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers,Error::ContainerEmptyWells,Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null,
			InvalidInputs->{},
			InvalidOptions->{}
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentFlashChromatography[samples,ReplaceRule[sampleOptions,Simulation->containerToSampleSimulation]]
	]
];

(* Main overload *)
ExperimentFlashChromatography[
	mySamples:ListableP[ObjectP[Object[Sample]]],
	myOptions:OptionsPattern[]
]:=Module[
	{
		outputSpecification,output,gatherTests,listedSamples,listedOptions,validSamplePreparationResult,
		samplesWithPreparedSamplesNamed,optionsWithPreparedSamplesNamed,updatedSimulation,
		safeOptionsNamed,safeOpsTests,
		samplesWithPreparedSamples,safeOps,optionsWithPreparedSamples,
		validLengths,validLengthTests,templatedOptions,templateTests,specifiedGradientOptionsQ,safeTemplatedOptions,
		inheritedOptions,upload,confirm,canaryBranch,fastTrack,parentProtocol,cache,priority,startDate,holdOrder,queuePosition,
		multiSelectOptions,multiSelectOptionValues,multiSelectRules,multiSelectReplacedOptions,expandedSafeOps,
		allInstrumentModels,allColumnModels,allCartridgeModels,allFractionContainerModels,
		instrumentOption,instrumentObjects,instrumentModels,
		columnOption,columnObjects,columnModels,
		bufferAOption,bufferBOption,bufferObjects,bufferModels,
		cartridgeOption,cartridgeObjects,cartridgeModels,
		fractionContainerOption,fractionContainerObjects,fractionContainerModels,
		rackModels,syringeModels,cartridgeCapModels,
		objectSampleFields,modelSampleFields,objectContainerFields,modelContainerFields,packetObjectSample,
		modelColumnFields,modelCartridgeFields,
		downloadedStuff,cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,
		resolvedPreparation,returnEarlyQ,performSimulationQ,
		resourcePackets,resourcePacketTests,
		simulatedProtocol,simulation,postProcessingOptions,result
	},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{samplesWithPreparedSamplesNamed,optionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentFlashChromatography,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentFlashChromatography,optionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentFlashChromatography,optionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* replace all objects referenced by Name to ID *)
	{samplesWithPreparedSamples,safeOps,optionsWithPreparedSamples}=sanitizeInputs[samplesWithPreparedSamplesNamed,safeOptionsNamed,optionsWithPreparedSamplesNamed,Simulation->updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentFlashChromatography,{samplesWithPreparedSamples},optionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentFlashChromatography,{samplesWithPreparedSamples},optionsWithPreparedSamples],{}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests}],
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentFlashChromatography,{ToList[samplesWithPreparedSamples]},optionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentFlashChromatography,{ToList[samplesWithPreparedSamples]},optionsWithPreparedSamples],{}}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests}],
			Options->$Failed,
			Preview->Null,
			Simulation->Null
		}]
	];

	(* Set a Boolean indicating whether any Gradient options were specified by the user *)
	specifiedGradientOptionsQ=IntersectingQ[
		Keys[optionsWithPreparedSamples],
		{Gradient,GradientA,GradientB,GradientStart,GradientEnd,GradientDuration,EquilibrationTime,FlushTime}
	];

	(* If the user specified any gradient options, don't copy over Gradient, GradientA, or GradientB from the template
	If we copied over the old gradients, we would get errors saying that the gradient options are conflicting *)
	safeTemplatedOptions=If[specifiedGradientOptionsQ,
		DeleteCases[templatedOptions,Rule[Gradient|GradientA|GradientB,_]],
		templatedOptions
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,safeTemplatedOptions];

	(* get assorted hidden options *)
	{
		upload,
		confirm,
		canaryBranch,
		fastTrack,
		parentProtocol,
		cache,
		priority,
		startDate,
		holdOrder,
		queuePosition
	}=Lookup[inheritedOptions,{Upload,Confirm,CanaryBranch,FastTrack,ParentProtocol,Cache,Priority,StartDate,HoldOrder,QueuePosition}];

	(*- Replace specified from MultiSelect options with listed versions of those specified options -*)
	(* Necessary to prevent incorrect interactions between ExpandIndexMatchedInputs and mapThreadOptions *)

	(* Get a list of the options defined with MultiSelect Widgets *)
	multiSelectOptions={
		Detectors,
		PeakDetectors,
		PrimaryWavelengthPeakDetectionMethod,
		SecondaryWavelengthPeakDetectionMethod,
		WideRangeUVPeakDetectionMethod
	};

	(* Lookup the values of the MultiSelect options *)
	multiSelectOptionValues=Lookup[inheritedOptions,multiSelectOptions];

	(* Create replace rules for the MultiSelect options
	Only ToList specified values, not Automatic, Null, or All *)
	multiSelectRules=MapThread[
		Function[{multiSelectOption,multiSelectOptionValue},
			multiSelectOption->If[
				MatchQ[multiSelectOptionValue,Automatic|Null|All],
				multiSelectOptionValue,
				ToList[multiSelectOptionValue]
			]
		],
		{multiSelectOptions,multiSelectOptionValues}
	];

	(* Get a list of all options with the MultiSelect options replaced by listed versions *)
	multiSelectReplacedOptions=ReplaceRule[inheritedOptions,multiSelectRules];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentFlashChromatography,{ToList[samplesWithPreparedSamples]},multiSelectReplacedOptions]];

	(* --- Search for and Download all the information we need for resolver and resource packets function --- *)

	(* Search to get everything we could need *)
	{
		allInstrumentModels,
		allColumnModels,
		allCartridgeModels,
		allFractionContainerModels
	}=Search[
		{
			{Model[Instrument,FlashChromatography]},
			{Model[Item,Column]},
			{Model[Container,ExtractionCartridge]},
			{Model[Container,Vessel]}
		},
		{
			Deprecated!=True,
			And[
				Deprecated!=True,
				ChromatographyType==Flash,
				VoidVolume!=Null,
				BedWeight!=Null
			],
			And[
				Deprecated!=True,
				ChromatographyType==Flash
			],
			(* This should find all fraction collection container models that would be compatible with any CombiFlash
			rack that currently exists. Make the search broader if you are adding a new rack. *)
			(* This search should be broader than that inside the combiFlashCompatibleFractionContainer helper function *)
			And[
				Deprecated!=True,
				CrossSectionalShape==Circle,
				Opaque!=True,
				InternalBottomShape==(RoundBottom|VBottom),
				MaxVolume>=8 Milliliter,
				CoverTypes!={},
				Dimensions[[1]]<=26. Millimeter,
				Dimensions[[1]]>=12. Millimeter,
				Dimensions[[3]]>=80. Millimeter
			]
		}
	];

	(* Get any user-provided instrument *)
	instrumentOption=Lookup[expandedSafeOps,Instrument];

	(* Get the instrument objects and models *)
	instrumentObjects=Cases[Flatten[{instrumentOption}],ObjectP[Object[Instrument,FlashChromatography]]];
	instrumentModels=Union[
		Cases[Flatten[{instrumentOption}],ObjectP[Model[Instrument,FlashChromatography]]],
		allInstrumentModels
	];

	(* Get any user-provided columns *)
	columnOption=Lookup[expandedSafeOps,Column];

	(*  Get the column objects and models  *)
	columnObjects=Cases[Flatten[{columnOption}],ObjectP[Object[Item,Column]]];
	columnModels=Union[
		Cases[Flatten[{columnOption}],ObjectP[Model[Item,Column]]],
		allColumnModels
	];

	(* Get any user-provided buffers *)
	bufferAOption=Lookup[expandedSafeOps,BufferA];
	bufferBOption=Lookup[expandedSafeOps,BufferB];

	(* Get the buffer objects and models *)
	bufferObjects=Cases[Flatten[{bufferAOption,bufferBOption}],ObjectP[Object[Sample]]];
	bufferModels=Union[
		Cases[Flatten[{bufferAOption,bufferBOption}],ObjectP[Model[Sample]]],
		(* The default buffers we may resolve to *)
		{
			Model[Sample,"id:1ZA60vwjbb5E"],(* Model[Sample,"Hexanes"] *)
			Model[Sample,"id:9RdZXvKBeeGK"],(* Model[Sample,"Ethyl acetate, HPLC Grade"] *)
			Model[Sample,"id:8qZ1VWNmdLBD"],(* Model[Sample,"Milli-Q water"] *)
			Model[Sample,"id:vXl9j5qEnnRD"] (* Model[Sample,"Methanol"] *)
		}
	];

	(* Get any user-provided cartridges *)
	cartridgeOption=Lookup[expandedSafeOps,Cartridge];

	(*  Get the cartridge objects and models  *)
	cartridgeObjects=Cases[Flatten[{cartridgeOption}],ObjectP[Object[Container,ExtractionCartridge]]];
	cartridgeModels=Union[
		Cases[Flatten[{cartridgeOption}],ObjectP[Model[Container,ExtractionCartridge]]],
		allCartridgeModels
	];

	(* Get any user-provided fraction containers *)
	fractionContainerOption=Lookup[expandedSafeOps,FractionContainer];

	(*  Get the fractionContainer objects and models  *)
	fractionContainerObjects=Cases[Flatten[{fractionContainerOption}],ObjectP[Object[Container,Vessel]]];
	fractionContainerModels=Union[
		Cases[Flatten[{fractionContainerOption}],ObjectP[Model[Container,Vessel]]],
		allFractionContainerModels
	];

	(* Search for and memoize the compatible fraction collection rack Models *)
	rackModels=combiFlashCompatibleRack["Memoization"];

	(* Search for and memoize the compatible syringes *)
	syringeModels=combiFlashCompatibleSyringe["Memoization"];

	(* Search for and memoize the compatible syringes *)
	cartridgeCapModels=combiFlashCompatibleCartridgeCap["Memoization"];

	(* Required fields for samples and containers *)
	objectSampleFields=Union[SamplePreparationCacheFields[Object[Sample]],{Solvent}];
	modelSampleFields=Union[SamplePreparationCacheFields[Model[Sample]],{Solvent,UsedAsSolvent}];
	objectContainerFields=Union[SamplePreparationCacheFields[Object[Container]],{MaxVolume}];
	modelContainerFields=Union[SamplePreparationCacheFields[Model[Container]],{MaxVolume,WellDiameter,NumberOfPositions}];

	(* Combined packet for samples *)
	packetObjectSample={
		Packet@@objectSampleFields,
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Model[modelSampleFields]]
	};

	(* Required fields for column models *)
	modelColumnFields={Name,ChromatographyType,SeparationMode,PackingMaterial,FunctionalGroup,BedWeight,VoidVolume,MinFlowRate,MaxFlowRate,MinPressure,MaxPressure,Diameter,ColumnLength,Reusable,Deprecated};

	(* Required fields for cartridge models *)
	modelCartridgeFields=Union[
		modelContainerFields,
		{Name,ChromatographyType,SeparationMode,PackingMaterial,PackingType,FunctionalGroup,BedWeight,MaxBedWeight,MinFlowRate,MaxFlowRate,MinPressure,MaxPressure,Diameter,CartridgeLength}
	];

	(* Download all the things *)
	downloadedStuff=Quiet[Download[
		{
			samplesWithPreparedSamples,
			instrumentObjects,
			instrumentModels,
			columnObjects,
			columnModels,
			bufferObjects,
			bufferModels,
			cartridgeObjects,
			cartridgeModels,
			fractionContainerObjects,
			fractionContainerModels,
			rackModels,
			syringeModels,
			cartridgeCapModels
		},
		Evaluate[{
			(* Sample Objects *)
			packetObjectSample,

			(* Instrument Objects *)
			{
				Packet[Name,Model],
				Packet[Model[{Name,Positions,MaxFlowRate,MinFlowRate,InjectionValveLength,MaxInjectionAssemblyLength,Connections,WettedMaterials,MinSampleVolume,MaxSampleVolume}]]
			},

			(* Instrument Models *)
			{Packet[Name,Positions,MaxFlowRate,MinFlowRate,InjectionValveLength,MaxInjectionAssemblyLength,Connections,WettedMaterials,MinSampleVolume,MaxSampleVolume]},

			(* Column Objects *)
			{
				Packet[Name,Model],
				Packet[Model[modelColumnFields]]
			},

			(* Column Models *)
			{Packet@@modelColumnFields},

			(* Buffer Objects *)
			packetObjectSample,

			(* Buffer Models *)
			{Packet@@modelSampleFields},

			(* Cartridge Objects *)
			{
				Packet@@objectContainerFields,
				Packet[Model[modelCartridgeFields]]
			},

			(* Cartridge Models *)
			{Packet@@modelCartridgeFields},

			(* Fraction Container Objects *)
			{
				Packet@@objectContainerFields,
				Packet[Model[modelContainerFields]]
			},

			(* Fraction Container Models *)
			{Packet@@modelContainerFields},

			(* Rack Models *)
			{Packet@@modelContainerFields},

			(* Syringe Models *)
			{Packet@@modelContainerFields},

			(* CartridgeCap Models *)
			{Packet[Name,Connections,MaxBedWeight,MinBedWeight]}
		}],
		Cache->cache,
		Simulation->updatedSimulation,
		Date->Now
	],{Download::ObjectDoesNotExist,Download::FieldDoesntExist,Download::NotLinkField}];

	(* get all the cache and put it together *)
	cacheBall=FlattenCachePackets[{cache,Cases[Flatten[downloadedStuff],PacketP[]]}];

	(* Build the resolved options *)
	resolvedOptionsResult=Check[
		{resolvedOptions,resolvedOptionsTests}=If[gatherTests,
			resolveExperimentFlashChromatographyOptions[samplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->{Result,Tests}],
			{resolveExperimentFlashChromatographyOptions[samplesWithPreparedSamples,expandedSafeOps,Cache->cacheBall,Simulation->updatedSimulation,Output->Result],{}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		ExperimentFlashChromatography,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(* Lookup our resolved Preparation option. *)
	resolvedPreparation=Lookup[resolvedOptions,Preparation];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ=Which[
		MatchQ[resolvedOptionsResult,$Failed],True,
		gatherTests,Not[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,Verbose->False,OutputFormat->SingleBoolean]],
		True,False
	];

	(* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
	(* need to return some type of simulation to our parent function that called us. *)
	(*performSimulationQ = MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];*)
	performSimulationQ=MemberQ[output,Result|Simulation];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ&&!performSimulationQ,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests}],
			Options->If[MatchQ[resolvedPreparation,Robotic],
				resolvedOptions,
				RemoveHiddenOptions[ExperimentFlashChromatography,collapsedResolvedOptions]
			],
			Preview->Null,
			Simulation->Simulation[]
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests}=Which[

		returnEarlyQ,{$Failed,{}},

		gatherTests,flashChromatographyResourcePackets[
			samplesWithPreparedSamples,
			templatedOptions,
			resolvedOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			Output->{Result,Tests}
		],

		True,
		{
			flashChromatographyResourcePackets[
				samplesWithPreparedSamples,
				templatedOptions,
				resolvedOptions,
				Cache->cacheBall,
				Simulation->updatedSimulation,
				Output->Result
			],
			{}
		}
	];

	(*If we were asked for a simulation, also return a simulation.*)
	{simulatedProtocol,simulation}=Which[
		MatchQ[resourcePackets,$Failed],
		{$Failed, Simulation[]},
		performSimulationQ,
		simulateExperimentFlashChromatography[
			resourcePackets[[1]],
			Flatten[ToList[resourcePackets[[2]]]],
			ToList[samplesWithPreparedSamples],
			resolvedOptions,
			Cache->cacheBall,
			Simulation->updatedSimulation
		],
		True,{Null,updatedSimulation}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->If[MatchQ[resolvedPreparation,Robotic],
				resolvedOptions,
				RemoveHiddenOptions[ExperimentFlashChromatography,collapsedResolvedOptions]
			],
			Preview->Null,
			Simulation->simulation
		}]
	];

	postProcessingOptions=Map[
		If[
			MatchQ[Lookup[safeOps,#],Except[Automatic]],
			#->Lookup[safeOps,#],
			Nothing
		]&,
		{ImageSample,MeasureVolume,MeasureWeight}
	];

	(* We have to return the result. Either a simulation or a protocol object *)
	result=Which[

		(* If our resource packets failed, we can't upload anything. *)
		MatchQ[resourcePackets,$Failed],$Failed,

		(* If we're in global script simulation mode (but not inside a procedure Simulation for Object[Maintenance,
		FlashChromatography]) we want to upload our simulation to the global simulation. *)
		And[
			MatchQ[$CurrentSimulation,SimulationP],
			!MatchQ[parentProtocol,ObjectP[Object[Maintenance,FlashChromatography]]]
		],
		Module[{},
			UpdateSimulation[$CurrentSimulation,simulation];

			If[MatchQ[upload,False],
				Lookup[simulation[[1]],Packets],
				simulatedProtocol
			]
		],

		(* Otherwise, upload our protocol object *)
		True,
		UploadProtocol[
			(* protocol packet *)
			resourcePackets[[1]],
			(* unit operation packets *)
			resourcePackets[[2]],
			Upload->upload,
			Confirm->confirm,
			CanaryBranch->canaryBranch,
			ParentProtocol->parentProtocol,
			Priority->priority,
			StartDate->startDate,
			HoldOrder->holdOrder,
			QueuePosition->queuePosition,
			ConstellationMessage->{Object[Protocol,FlashChromatography]},
			Cache->cacheBall,
			Simulation->simulation
		]
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->result,
		Tests->Cases[Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],TestP],
		Options->If[MatchQ[resolvedPreparation,Robotic],
			collapsedResolvedOptions,
			RemoveHiddenOptions[ExperimentFlashChromatography,collapsedResolvedOptions]
		],
		Preview->Null,
		Simulation->simulation
	}
];

(* ::Subsection:: *)
(* resolveFlashChromatographyMethod *)

DefineOptions[resolveFlashChromatographyMethod,
	SharedOptions:>{
		ExperimentFlashChromatography,
		CacheOption,
		SimulationOption,
		OutputOption
	}
];

(* NOTE: mySamples can be Automatic when the user has not yet specified a value for autofill. *)
resolveFlashChromatographyMethod[
	myInputs:ListableP[Alternatives[
		ObjectP[{Object[Container],Object[Sample]}],
		_String,
		{LocationPositionP,_String|ObjectP[Object[Container]]}
	]],
	myOptions:OptionsPattern[]
]:=Module[
	{safeOptions,outputSpecification,output,gatherTests,result,tests},

	(* Get our safe options. *)
	safeOptions=SafeOptions[resolveFlashChromatographyMethod,ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[safeOptions,Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* For FlashChromatography, result is always ManualSamplePreparation and there are no tests *)
	result=Manual;
	tests={};

	outputSpecification/.{Result->result,Tests->tests}
];


(* ::Subsection::Closed:: *)
(*resolveExperimentFlashChromatographyOptions*)

DefineOptions[
	resolveExperimentFlashChromatographyOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveExperimentFlashChromatographyOptions[
	myInputSamples:{ObjectP[Object[Sample]]...},
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentFlashChromatographyOptions]
]:=Module[
	{outputSpecification,output,gatherTests,messages,notInEngine,cache,simulation,samplePrepOptions,flashChromatographyOptions,

		simulatedSamples,
		resolvedSamplePrepOptions,updatedSimulation,samplePrepTests,
		samplePackets,sampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls,cacheBall,sampleDownloads,fastAssoc,
		myInputSampleContainers,
		sampleContainerModelPackets,sampleContainerPackets,discardedSamplePackets,discardedInvalidInputs,discardedTest,
		missingVolumeSamplePackets,missingVolumeInvalidInputs,missingVolumeTest,

		optionsAssociation,timePrecision,percentPrecision,flowRatePrecision,volumePrecision,massPrecision,wavelengthPrecision,absorbancePrecision,
		roundedOptions,roundedTests,

		(* Post-rounding options*)
		specifiedPreparation,
		specifiedInstrument,specifiedDetector,specifiedSeparationMode,specifiedBufferA,specifiedBufferB,specifiedLoadingType,
		specifiedColumn,specifiedPreSampleEquilibration,specifiedLoadingAmount,specifiedMaxLoadingPercent,specifiedCartridge,
		specifiedCartridgePackingMaterial,specifiedCartridgeFunctionalGroup,specifiedCartridgePackingMass,specifiedCartridgeDryingTime,
		specifiedGradientA,specifiedGradientB,specifiedFlowRate,specifiedGradientStart,specifiedGradientEnd,specifiedGradientDuration,
		specifiedEquilibrationTime,specifiedFlushTime,specifiedGradient,specifiedCollectFractions,specifiedFractionCollectionStartTime,
		specifiedFractionCollectionEndTime,specifiedFractionContainer,specifiedMaxFractionVolume,specifiedFractionCollectionMode,
		specifiedDetectors,specifiedPrimaryWavelength,specifiedSecondaryWavelength,specifiedWideRangeUV,specifiedPeakDetectors,
		specifiedPrimaryWavelengthPeakDetectionMethod,specifiedPrimaryWavelengthPeakWidth,specifiedPrimaryWavelengthPeakThreshold,
		specifiedSecondaryWavelengthPeakDetectionMethod,specifiedSecondaryWavelengthPeakWidth,specifiedSecondaryWavelengthPeakThreshold,
		specifiedWideRangeUVPeakDetectionMethod,specifiedWideRangeUVPeakWidth,specifiedWideRangeUVPeakThreshold,
		specifiedColumnStorageCondition,specifiedAirPurgeDuration,

		(* For resolving non-index-matched options before the MapThread *)
		invalidPreparationError,invalidPreparationOptions,invalidPreparationTest,resolvedPreparation,
		resolvedInstrument,resolvedDetector,
		mixedSeparationModesWarning,mapThreadFriendlyOptions,
		specColumnSeparationModes,specCartridgeSeparationModes,specCartridgeFunctionalGroups,preferredSeparationModes,
		anyNormalPhaseQ,anyReversePhaseQ,

		preferredSeparationMode,resolvedSeparationMode,
		mixedSeparationModesTest,mismatchedSeparationModesWarning,mismatchedSeparationModesTest,
		preferredBufferA,resolvedBufferA,preferredBufferB,resolvedBufferB,
		incompleteBufferSpecificationError,incompleteBufferSpecificationInvalidOptions,incompleteBufferSpecificationTest,

		compatibleSamplesAndInstrumentQ,compatibleSamplesAndInstrumentTests,compatibleSamplesAndInstrumentInvalidOptions,
		compatibleBuffersAndInstrumentQ,compatibleBuffersAndInstrumentTests,compatibleBuffersAndInstrumentInvalidOptions,

		resolvedInstrumentModelPacket,resolvedInstrumentMinFlowRate,resolvedInstrumentMaxFlowRate,
		resolvedInstrumentMaxInjectionAssemblyLength,resolvedInstrumentInjectionValveLength,
		resolvedInstrumentMinSampleVolume,resolvedInstrumentMaxSampleVolume,resolvedInstrumentVolumeInterval,
		resolvedBufferBModel,syringeModels,syringeModelPackets,syringeVolumeIntervals,syringeVolumeInterval,
		cartridgeCapModels,cartridgeCapModelPackets,cartridgeCapVolumeIntervals,cartridgeCapBedWeightInterval,

		defaultColumns,defaultColumnPackets,defaultColumnVoidVolumes,largestDefaultColumn,largestDefaultColumnVoidVolume,
		defaultContainers,defaultContainerPackets,defaultContainerMaxVolumes,largestDefaultContainers,largestDefaultContainer,
		largestDefaultContainerMaxVolume,fractionOfMaxVolume,sampleVolumesRaw,sampleVolumes,cartridgeLoadingFactor,
		detectorOptions,sampleIndexes,

		(* Resolved options set by the MapThread *)
		resolvedLoadingType,resolvedMaxLoadingPercent,
		resolvedColumn,
		resolvedPreSampleEquilibration,resolvedLoadingAmount,resolvedCartridge,
		resolvedCartridgePackingMaterial,resolvedCartridgeFunctionalGroup,resolvedCartridgePackingMass,resolvedCartridgeDryingTime,
		resolvedGradientA,resolvedGradientB,resolvedFlowRate,resolvedGradientStart,resolvedGradientEnd,resolvedGradientDuration,
		resolvedEquilibrationTime,resolvedFlushTime,resolvedGradient,resolvedCollectFractions,resolvedFractionCollectionStartTime,
		resolvedFractionCollectionEndTime,resolvedFractionContainer,resolvedMaxFractionVolume,resolvedFractionCollectionMode,
		resolvedDetectors,resolvedPrimaryWavelength,resolvedSecondaryWavelength,resolvedWideRangeUV,resolvedPeakDetectors,
		resolvedPrimaryWavelengthPeakDetectionMethod,resolvedPrimaryWavelengthPeakWidth,resolvedPrimaryWavelengthPeakThreshold,
		resolvedSecondaryWavelengthPeakDetectionMethod,resolvedSecondaryWavelengthPeakWidth,resolvedSecondaryWavelengthPeakThreshold,
		resolvedWideRangeUVPeakDetectionMethod,resolvedWideRangeUVPeakWidth,resolvedWideRangeUVPeakThreshold,resolvedColumnStorageCondition,
		resolvedAirPurgeDuration,resolvedSampleLabel,resolvedSampleContainerLabel,resolvedColumnLabel,resolvedCartridgeLabel,

		(* Error tracking variables set by the MapThread *)
		mismatchedCartridgeOptionsErrors,mismatchedSolidLoadNullCartridgeOptionsErrors,mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors,
		recommendedMaxLoadingPercentExceededWarnings,deprecatedColumnErrors,incompatibleColumnTypeErrors,incompatibleColumnAndInstrumentFlowRateErrors,
		insufficientSampleVolumeErrors,invalidLoadingAmountForColumnErrors,invalidLoadingAmountErrors,
		invalidLoadingAmountForInstrumentErrors,invalidLoadingAmountForSyringesErrors,
		incompatibleCartridgeLoadingTypeErrors,incompatibleCartridgeTypeErrors,incompatibleCartridgePackingTypeErrors,
		incompatibleCartridgeAndInstrumentFlowRateErrors,incompatibleCartridgeAndColumnFlowRateErrors,invalidCartridgeMaxBedWeightErrors,
		incompatibleInjectionAssemblyLengthErrors,mismatchedColumnAndPrepackedCartridgeWarnings,invalidCartridgePackingMaterialErrors,
		invalidCartridgeFunctionalGroupErrors,mismatchedColumnAndCartridgeWarnings,invalidCartridgePackingMassErrors,
		tooHighCartridgePackingMassErrors,tooLowCartridgePackingMassErrors,invalidPackingMassForCartridgeCapsErrors,
		incompatibleFlowRateErrors,incompatiblePreSampleEquilibrationErrors,
		redundantGradientShortcutErrors,incompleteGradientShortcutErrors,zeroGradientShortcutErrors,
		redundantGradientSpecificationErrors,invalidGradientBTimeErrors,invalidGradientATimeErrors,invalidGradientTimeErrors,
		invalidTotalGradientTimeErrors,methanolPercentWarnings,
		invalidFractionCollectionOptionsErrors,invalidCollectFractionsErrors,mismatchedFractionCollectionOptionsErrors,
		invalidFractionCollectionStartTimeErrors,invalidFractionCollectionEndTimeErrors,invalidFractionContainerErrors,
		invalidMaxFractionVolumeForContainerErrors,invalidMaxFractionVolumeErrors,
		invalidSpecifiedDetectorsErrors,invalidNullDetectorsErrors,invalidWideRangeUVErrors,
		missingPeakDetectorsErrors,
		invalidSpecifiedPrimaryWavelengthPeakDetectionErrors,invalidSpecifiedSecondaryWavelengthPeakDetectionErrors,invalidSpecifiedWideRangeUVPeakDetectionErrors,
		invalidNullPrimaryWavelengthPeakDetectionMethodErrors,invalidNullSecondaryWavelengthPeakDetectionMethodErrors,invalidNullWideRangeUVPeakDetectionMethodErrors,
		invalidNullPrimaryWavelengthPeakDetectionParametersErrors,invalidNullSecondaryWavelengthPeakDetectionParametersErrors,invalidNullWideRangeUVPeakDetectionParametersErrors,
		invalidPrimaryWavelengthPeakWidthErrors,invalidSecondaryWavelengthPeakWidthErrors,invalidWideRangeUVPeakWidthErrors,
		invalidPrimaryWavelengthPeakThresholdErrors,invalidSecondaryWavelengthPeakThresholdErrors,invalidWideRangeUVPeakThresholdErrors,
		invalidColumnStorageConditionErrors,
		invalidAirPurgeDurationErrors,airPurgeAndStoreColumnWarnings,invalidNullCartridgeLabelErrors,
		invalidSpecifiedCartridgeLabelErrors,

		(* Other values set by the MapThread *)
		preferredMaxLoadingPercents,resolvedMaxLoadingFractions,
		specifiedColumnChromatographyTypes,specifiedColumnMinFlowRates,specifiedColumnMaxFlowRates,specifiedColumnVoidVolumes,
		resolvedColumnMinFlowRates,resolvedColumnMaxFlowRates,specifiedLoadingAmountVolumes,resolvedLoadingAmountVolumes,specifiedCartridgeChromatographyTypes,
		specifiedCartridgePackingTypes,specifiedCartridgeMinFlowRates,specifiedCartridgeMaxFlowRates,
		resolvedColumnLengths,resolvedCartridgeLengths,injectionAssemblyLengths,resolvedColumnSeparationModes,
		resolvedColumnPackingMaterials,resolvedColumnFunctionalGroups,resolvedCartridgeSeparationModes,
		resolvedCartridgePackingMaterials,resolvedCartridgeFunctionalGroups,resolvedCartridgePackingTypes,
		resolvedCartridgeMaxBedWeights,resolvedCartridgeMinFlowRates,resolvedCartridgeMaxFlowRates,resolvedFlowRateIntervals,
		specifiedGradientBTimes,specifiedGradientATimes,specifiedGradientTimes,resolvedTotalGradientBTimes,
		resolvedContainerMaxVolumes,resolvedDetectorsLists,

		(* After MapThread *)
		mismatchedCartridgeOptions,mismatchedCartridgeOptionsTest,
		mismatchedSolidLoadNullCartridgeOptions,mismatchedSolidLoadNullCartridgeOptionsTest,
		mismatchedLiquidLoadSpecifiedCartridgeOptions,mismatchedLiquidLoadSpecifiedCartridgeOptionsTest,
		recommendedMaxLoadingPercentExceededTest,
		deprecatedColumnOptions,deprecatedColumnTest,
		incompatibleColumnTypeOptions,incompatibleColumnTypeTest,incompatibleColumnAndInstrumentFlowRateOptions,incompatibleColumnAndInstrumentFlowRateTest,
		insufficientSampleVolumeOptions,insufficientSampleVolumeTest,
		invalidLoadingAmountForColumnOptions,invalidLoadingAmountForColumnTest,invalidLoadingAmountOptions,invalidLoadingAmountTest,
		invalidLoadingAmountForInstrumentOptions,invalidLoadingAmountForInstrumentTest,
		invalidLoadingAmountForSyringesOptions,invalidLoadingAmountForSyringesTest,
		incompatibleCartridgeLoadingTypeOptions,incompatibleCartridgeLoadingTypeTest,
		incompatibleCartridgeTypeOptions,incompatibleCartridgeTypeTest,
		incompatibleCartridgePackingTypeOptions,incompatibleCartridgePackingTypeTest,
		incompatibleCartridgeAndInstrumentFlowRateOptions,incompatibleCartridgeAndInstrumentFlowRateTest,
		incompatibleCartridgeAndColumnFlowRateOptions,incompatibleCartridgeAndColumnFlowRateTest,
		invalidCartridgeMaxBedWeightOptions,invalidCartridgeMaxBedWeightTest,
		incompatibleInjectionAssemblyLengthOptions,incompatibleInjectionAssemblyLengthTest,
		mismatchedColumnAndPrepackedCartridgeTest,
		invalidCartridgePackingMaterialOptions,invalidCartridgePackingMaterialTest,
		invalidCartridgeFunctionalGroupOptions,invalidCartridgeFunctionalGroupTest,
		mismatchedColumnAndCartridgeTest,
		invalidCartridgePackingMassOptions,invalidCartridgePackingMassTest,
		tooHighCartridgePackingMassOptions,tooHighCartridgePackingMassTest,
		tooLowCartridgePackingMassOptions,tooLowCartridgePackingMassTest,
		invalidPackingMassForCartridgeCapsOptions,invalidPackingMassForCartridgeCapsTest,
		incompatibleFlowRateOptions,incompatibleFlowRateTest,
		incompatiblePreSampleEquilibrationOptions,incompatiblePreSampleEquilibrationTest,
		redundantGradientShortcutOptions,redundantGradientShortcutTest,
		incompleteGradientShortcutOptions,incompleteGradientShortcutTest,
		zeroGradientShortcutOptions,zeroGradientShortcutTest,
		redundantGradientSpecificationOptions,redundantGradientSpecificationTest,
		invalidGradientBTimeOptions,invalidGradientBTimeTest,
		invalidGradientATimeOptions,invalidGradientATimeTest,
		invalidGradientTimeOptions,invalidGradientTimeTest,
		invalidTotalGradientTimeOptions,invalidTotalGradientTimeTest,
		methanolPercentTest,
		invalidFractionCollectionOptions,invalidFractionCollectionOptionsTest,
		invalidCollectFractionsOptions,invalidCollectFractionsTest,
		mismatchedFractionCollectionOptions,mismatchedFractionCollectionOptionsTest,
		invalidFractionCollectionStartTimeOptions,invalidFractionCollectionStartTimeTest,
		invalidFractionCollectionEndTimeOptions,invalidFractionCollectionEndTimeTest,
		invalidFractionContainerOptions,invalidFractionContainerTest,
		invalidMaxFractionVolumeForContainerOptions,invalidMaxFractionVolumeForContainerTest,
		invalidMaxFractionVolumeOptions,invalidMaxFractionVolumeTest,
		invalidSpecifiedDetectorsOptions,invalidSpecifiedDetectorsTest,
		invalidNullDetectorsOptions,invalidNullDetectorsTest,
		invalidWideRangeUVOptions,invalidWideRangeUVTest,
		missingPeakDetectorsOptions,missingPeakDetectorsTest,

		peakDetectionMethodOptions,peakWidthOptions,peakThresholdOptions,
		specifiedPeakDetectionMethodList,specifiedPeakWidthList,specifiedPeakThresholdList,
		resolvedPeakDetectionMethodList,
		invalidSpecifiedPeakDetectionErrorsList,invalidNullPeakDetectionMethodErrorsList,
		invalidNullPeakDetectionParametersErrorsList,invalidPeakWidthErrorsList,invalidPeakThresholdErrorsList,

		invalidPeakDetectionOptions,invalidPeakDetectionTests,
		invalidColumnStorageConditionOptions,invalidColumnStorageConditionTest,

		invalidAirPurgeDurationOptions,invalidAirPurgeDurationTest,airPurgeAndStoreColumnTest,
		invalidNullCartridgeLabelOptions,invalidNullCartridgeLabelTest,
		invalidSpecifiedCartridgeLabelOptions,invalidSpecifiedCartridgeLabelTest,

		invalidLabelOptions,invalidLabelTests,

		requiredBufferAVolume,requiredBufferBVolume,

		invalidTotalBufferVolumeOptions,invalidTotalBufferVolumeTests,
		invalidTotalFractionVolumeOptions,invalidTotalFractionVolumeTest,totalFractionVolumeTest,

		maxNumbersOfFractionContainers,fractionContainerRackModels,numbersOfPositions,
		preferredNumbersOfRacks,invalidTotalFractionVolumeErrors,totalFractionVolumeWarnings,


		nonLiquidSamplePackets,
		nonLiquidSampleInvalidInputs,nonLiquidSampleTest,invalidOptions,nameInvalidOption,specifiedOperator,
		upload,specifiedEmail,specifiedName,resolvedEmail,nameInvalidBool,nameInvalidTest,allTests,
		resolvedOperator,resolvedPostProcessingOptions,

		optionsForAliquot,resolvedAliquotOptions,aliquotTests,

		invalidInputs,resolvedOptions,preparationResult,allContainerPackets
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Determine if we are not in Engine, in Engine we silence warnings *)
	notInEngine=Not[MatchQ[$ECLApplication,Engine]];

	(* Fetch our cache from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Simulation[]];

	(* Separate out our flashChromatography options from our Sample Prep options. *)
	{samplePrepOptions,flashChromatographyOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options (only if the sample prep option is not true) *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentFlashChromatography,myInputSamples,samplePrepOptions,EnableSamplePreparation->Lookup[myOptions,EnableSamplePreparation],Cache->cache,Simulation->simulation,Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentFlashChromatography,myInputSamples,samplePrepOptions,EnableSamplePreparation->Lookup[myOptions,EnableSamplePreparation],Cache->cache,Simulation->simulation,Output->Result],{}}
	];

	(* Extract the packets that we need from our downloaded cache. *)
	(* need to do this even if we have caching because of the simulation stuff *)
	sampleDownloads=Quiet[Download[
		simulatedSamples,
		{
			Packet[Name,Volume,State,Status,Container,LiquidHandlerIncompatible,Solvent,Position],
			Packet[Container[{Object,Model,KitComponents}]],
			Packet[Container[Model[{MaxVolume,DestinationContainerModel,RetentateCollectionContainerModel}]]]
		},
		Simulation->updatedSimulation
	],{Download::FieldDoesntExist,Download::NotLinkField}];

	(* combine the cache together *)
	cacheBall=FlattenCachePackets[{
		cache,
		sampleDownloads
	}];

	(* generate a fast cache association *)
	fastAssoc=makeFastAssocFromCache[cacheBall];

	(* Get the containers of the input samples (these are post-sample prep but pre-aliquot).
	Needed for generating and checking SampleContainerLabel *)
	myInputSampleContainers=fastAssocLookup[fastAssoc,#,{Container,Object}]&/@myInputSamples;

	(* pull some stuff out of the cache ball to speed things up below; unfortunately can't eliminate this 100%  *)
	allContainerPackets=Cases[cacheBall,PacketP[{Model[Container],Object[Container]}]];

	(* Get the downloaded mess into a usable form *)
	{
		samplePackets,
		sampleContainerPacketsWithNulls,
		sampleContainerModelPacketsWithNulls
	}=Transpose[sampleDownloads];

	(* If the sample is discarded, it doesn't have a container, so the corresponding container packet is Null.
			Make these packets {} instead so that we can call Lookup on them like we would on a packet. *)
	sampleContainerModelPackets=Replace[sampleContainerModelPacketsWithNulls,{Null->{}},1];
	sampleContainerPackets=Replace[sampleContainerPacketsWithNulls,{Null->{}},1];

	(*-- INPUT VALIDATION CHECKS --*)

	(* NOTE: MAKE SURE NONE OF THE SAMPLES ARE DISCARDED - *)

	(* Get the samples from samplePackets that are discarded. *)
	discardedSamplePackets=Select[Flatten[samplePackets],MatchQ[Lookup[#,Status],Discarded]&];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=Lookup[discardedSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&messages,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Cache->cacheBall]]
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Cache->cacheBall]<>" are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[myInputSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[myInputSamples,discardedInvalidInputs],Cache->cacheBall]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],Nothing
	];

	(* NOTE: MAKE SURE THE SAMPLES ARE LIQUID - *)

	(* Get the samples that are not liquids, cannot load those *)
	nonLiquidSamplePackets=Select[samplePackets,Not[MatchQ[Lookup[#,State],Liquid]]&];

	(* Keep track of samples that are not liquid *)
	nonLiquidSampleInvalidInputs=Lookup[nonLiquidSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs]>0&&messages,
		Message[Error::NonLiquidSamples,ObjectToString[nonLiquidSampleInvalidInputs,Cache->cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nonLiquidSampleInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[nonLiquidSampleInvalidInputs,Cache->cacheBall]<>" have a Liquid State:",True,False]
			];

			passingTest=If[Length[nonLiquidSampleInvalidInputs]==Length[myInputSamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[myInputSamples,nonLiquidSampleInvalidInputs],Cache->cacheBall]<>" have a Liquid State:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* NOTE: MAKE SURE THE SAMPLES HAVE A VOLUME - *)

	(* Get the samples that do not have a volume *)
	missingVolumeSamplePackets=Select[Flatten[samplePackets],NullQ[Lookup[#,Volume]]&];

	(* Keep track of samples that do not have volume *)
	missingVolumeInvalidInputs=Lookup[missingVolumeSamplePackets,Object,{}];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[missingVolumeInvalidInputs]>0&&messages&&Not[MatchQ[$ECLApplication,Engine]],
		Message[Error::MissingSampleVolumes,ObjectToString[missingVolumeInvalidInputs,Cache->cacheBall]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	missingVolumeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[missingVolumeInvalidInputs]==0,
				Nothing,
				Warning["Our input samples "<>ObjectToString[missingVolumeInvalidInputs,Cache->cacheBall]<>" are not missing volume information:",True,False]
			];

			passingTest=If[Length[missingVolumeInvalidInputs]==Length[myInputSamples],
				Nothing,
				Warning["Our input samples "<>ObjectToString[Complement[myInputSamples,missingVolumeInvalidInputs],Cache->cacheBall]<>" are not missing volume information:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(*-- OPTION PRECISION CHECKS --*)

	optionsAssociation=Association[flashChromatographyOptions];

	timePrecision=10^-2 Minute;
	percentPrecision=10^-1 Percent;
	flowRatePrecision=10^-1 Milliliter/Minute;
	volumePrecision=flashChromatographyVolumePrecision[];
	massPrecision=10^-1 Gram;
	wavelengthPrecision=10^0 Nanometer;
	absorbancePrecision=10^0 MilliAbsorbanceUnit;

	(* Build options association with rounded options and list of all option precision tests *)
	{roundedOptions,roundedTests}=Module[{
		gradientOptions,roundedGradientOptions,roundedGradientTests,
		nonGradientOptions,nonGradientPrecisions,roundedNonGradientOptions,roundedNonGradientTests,
		allRoundedOptions,allRoundedTests
	},

		(* Options that specify flow rates, buffer percentages, or times related to gradients *)
		gradientOptions={
			FlowRate,
			PreSampleEquilibration,
			GradientA,
			GradientB,
			Gradient,
			GradientStart,
			GradientEnd,
			GradientDuration,
			EquilibrationTime,
			FlushTime,
			FractionCollectionStartTime,
			FractionCollectionEndTime
		};

		(* Use the helper function to round all of the gradient options collectively *)
		{roundedGradientOptions,roundedGradientTests}=roundGradientOptions[
			gradientOptions,
			optionsAssociation,
			gatherTests,
			GradientPrecision->percentPrecision,
			TimePrecision->timePrecision,
			FlowRatePrecision->flowRatePrecision
		];

		(* Options that specify numerical values not related to gradients *)
		nonGradientOptions={
			LoadingAmount,
			MaxFractionVolume,
			MaxLoadingPercent,
			CartridgePackingMass,
			CartridgeDryingTime,
			AirPurgeDuration,
			PrimaryWavelength,
			SecondaryWavelength,
			WideRangeUV,
			PrimaryWavelengthPeakThreshold,
			SecondaryWavelengthPeakThreshold,
			WideRangeUVPeakThreshold
		};

		(* Precision values for the nonGradientOptions *)
		nonGradientPrecisions={
			volumePrecision,
			volumePrecision,
			percentPrecision,
			massPrecision,
			timePrecision,
			timePrecision,
			wavelengthPrecision,
			wavelengthPrecision,
			wavelengthPrecision,
			absorbancePrecision,
			absorbancePrecision,
			absorbancePrecision
		};

		(* Returns a full options association with the nonGradientOptions rounded *)
		{roundedNonGradientOptions,roundedNonGradientTests}=If[gatherTests,
			RoundOptionPrecision[optionsAssociation,nonGradientOptions,nonGradientPrecisions,Output->{Result,Tests}],
			{RoundOptionPrecision[optionsAssociation,nonGradientOptions,nonGradientPrecisions],{}}
		];

		(* Join all rounded associations together, with rounded values overwriting existing values *)
		allRoundedOptions=Join[
			optionsAssociation,
			KeyTake[roundedGradientOptions,gradientOptions],
			KeyTake[roundedNonGradientOptions,nonGradientOptions]
		];

		(* Join all tests together *)
		allRoundedTests=Join[
			roundedGradientTests,
			roundedNonGradientTests
		];

		(* Return expected tuple of the rounded association and all tests *)
		{allRoundedOptions,allRoundedTests}
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Lookup the values of the rounded options *)
	{
		specifiedPreparation,
		specifiedInstrument,
		specifiedDetector,
		specifiedSeparationMode,
		specifiedBufferA,
		specifiedBufferB,
		specifiedLoadingType,
		specifiedColumn,
		specifiedPreSampleEquilibration,
		specifiedLoadingAmount,
		specifiedMaxLoadingPercent,
		specifiedCartridge,
		specifiedCartridgePackingMaterial,
		specifiedCartridgeFunctionalGroup,
		specifiedCartridgePackingMass,
		specifiedCartridgeDryingTime,
		specifiedGradientA,
		specifiedGradientB,
		specifiedFlowRate,
		specifiedGradientStart,
		specifiedGradientEnd,
		specifiedGradientDuration,
		specifiedEquilibrationTime,
		specifiedFlushTime,
		specifiedGradient,
		specifiedCollectFractions,
		specifiedFractionCollectionStartTime,
		specifiedFractionCollectionEndTime,
		specifiedFractionContainer,
		specifiedMaxFractionVolume,
		specifiedFractionCollectionMode,
		specifiedDetectors,
		specifiedPrimaryWavelength,
		specifiedSecondaryWavelength,
		specifiedWideRangeUV,
		specifiedPeakDetectors,
		specifiedPrimaryWavelengthPeakDetectionMethod,
		specifiedPrimaryWavelengthPeakWidth,
		specifiedPrimaryWavelengthPeakThreshold,
		specifiedSecondaryWavelengthPeakDetectionMethod,
		specifiedSecondaryWavelengthPeakWidth,
		specifiedSecondaryWavelengthPeakThreshold,
		specifiedWideRangeUVPeakDetectionMethod,
		specifiedWideRangeUVPeakWidth,
		specifiedWideRangeUVPeakThreshold,
		specifiedColumnStorageCondition,
		specifiedAirPurgeDuration
	}=Lookup[
		roundedOptions,
		{
			Preparation,
			Instrument,
			Detector,
			SeparationMode,
			BufferA,
			BufferB,
			LoadingType,
			Column,
			PreSampleEquilibration,
			LoadingAmount,
			MaxLoadingPercent,
			Cartridge,
			CartridgePackingMaterial,
			CartridgeFunctionalGroup,
			CartridgePackingMass,
			CartridgeDryingTime,
			GradientA,
			GradientB,
			FlowRate,
			GradientStart,
			GradientEnd,
			GradientDuration,
			EquilibrationTime,
			FlushTime,
			Gradient,
			CollectFractions,
			FractionCollectionStartTime,
			FractionCollectionEndTime,
			FractionContainer,
			MaxFractionVolume,
			FractionCollectionMode,
			Detectors,
			PrimaryWavelength,
			SecondaryWavelength,
			WideRangeUV,
			PeakDetectors,
			PrimaryWavelengthPeakDetectionMethod,
			PrimaryWavelengthPeakWidth,
			PrimaryWavelengthPeakThreshold,
			SecondaryWavelengthPeakDetectionMethod,
			SecondaryWavelengthPeakWidth,
			SecondaryWavelengthPeakThreshold,
			WideRangeUVPeakDetectionMethod,
			WideRangeUVPeakWidth,
			WideRangeUVPeakThreshold,
			ColumnStorageCondition,
			AirPurgeDuration
		}
	];

	(*--- Resolve the non-index-matched options ---*)

	(*-- Preparation --*)

	(* Flip an error switch if Preparation is specified to something besides Manual *)
	invalidPreparationError=And[
		MatchQ[specifiedPreparation,PreparationMethodP],
		!MatchQ[specifiedPreparation,Manual]
	];

	(* Throw an Error if Preparation is specified to something besides Manual *)
	invalidPreparationOptions=If[invalidPreparationError&&messages,
		Message[Error::InvalidFlashChromatographyPreparation,
			specifiedPreparation
		];
		{Preparation},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidFlashChromatographyPreparation *)
	invalidPreparationTest=If[gatherTests,
		Test["If Preparation is specified, it is specified to Manual:",
			invalidPreparationError,
			False
		],
		Nothing
	];

	(* Resolve Preparation *)
	resolvedPreparation=Switch[specifiedPreparation,

		(* If Preparation is unspecified, resolve to Manual *)
		Automatic,Manual,

		(* If Preparation is specified, resolve to the specified value *)
		_,specifiedPreparation
	];

	(*-- Instrument --*)

	(* Currently only one model. Default->Model[Instrument,FlashChromatography,"CombiFlash Rf 200"] *)
	resolvedInstrument=specifiedInstrument;

	(*-- Detector --*)

	(* Currently only one detector. Default->UV *)
	resolvedDetector=specifiedDetector;

	(*-- SeparationMode --*)

	(* Initialize a warning switch for whether there are mixed separation modes indicated by specified options *)
	mixedSeparationModesWarning=False;

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentFlashChromatography,roundedOptions];

	(* Map over the options to get a list of the preferred SeparationMode for each sample *)
	{
		specColumnSeparationModes,
		specCartridgeSeparationModes,
		specCartridgeFunctionalGroups,
		preferredSeparationModes
	}=Transpose[
		MapThread[
			Function[{options},
				Module[{specColumn,specCartridge,specCartridgeFunctionalGroup,
					specColumnSeparationMode,specCartridgeSeparationMode,anyNormalPhaseOptionsQ,anyReversePhaseOptionsQ,
					preferredSampleSeparationMode},

					(* Get the specified options necessary to resolve SeparationMode *)
					{
						specColumn,
						specCartridge,
						specCartridgeFunctionalGroup
					}=Lookup[options,{Column,Cartridge,CartridgeFunctionalGroup}];

					(* Lookup the value of the SeparationMode field from the model of the specified column and cartridge *)
					specColumnSeparationMode=Lookup[fetchModelPacketFromFastAssoc[specColumn,fastAssoc],SeparationMode,Automatic];
					specCartridgeSeparationMode=Lookup[fetchModelPacketFromFastAssoc[specCartridge,fastAssoc],SeparationMode,Automatic];

					(* Set a Boolean that indicates whether any of the options are specified to indicate NormalPhase *)
					anyNormalPhaseOptionsQ=Or[
						MatchQ[specColumnSeparationMode,NormalPhase],
						MatchQ[specCartridgeSeparationMode,NormalPhase]
					];

					(* Set a Boolean that indicates whether any of the options are specified to indicate ReversePhase *)
					anyReversePhaseOptionsQ=Or[
						MatchQ[specColumnSeparationMode,ReversePhase],
						MatchQ[specCartridgeSeparationMode,ReversePhase],
						MatchQ[specCartridgeFunctionalGroup,C8|C18]
					];

					(* Return the preferred SeparationMode for this sample *)
					preferredSampleSeparationMode=Switch[{anyNormalPhaseOptionsQ,anyReversePhaseOptionsQ},

						(* If there are no options indicating NormalPhase or ReversePhase separation,
						then return Automatic *)
						{False,False},Automatic,

						(* If there are no options indicating NormalPhase separation and there are options indicating
						ReversePhase separation, then return ReversePhase *)
						{False,True},ReversePhase,

						(* If there are options indicating NormalPhase separation and there are no options indicating
						ReversePhase separation, then return NormalPhase *)
						{True,False},NormalPhase,

						(* If there are options indicating NormalPhase and ReversePhase separation, then flip a warning switch
						and return NormalPhase *)
						{True,True},mixedSeparationModesWarning=True;NormalPhase
					];

					(* Return values needed for SeparationMode resolution *)
					{
						specColumnSeparationMode,
						specCartridgeSeparationMode,
						specCartridgeFunctionalGroup,
						preferredSampleSeparationMode
					}
				]
			],
			{mapThreadFriendlyOptions}
		]
	];

	(* Set Booleans indicating whether the preferred separation modes include NormalPhase or ReversePhase *)
	anyNormalPhaseQ=MemberQ[preferredSeparationModes,NormalPhase];
	anyReversePhaseQ=MemberQ[preferredSeparationModes,ReversePhase];

	(* Choose the overall preferred SeparationMode option value *)
	preferredSeparationMode=Switch[{anyNormalPhaseQ,anyReversePhaseQ,specifiedSeparationMode},

		(* If none of the preferred separation modes are NormalPhase or ReversePhase and SeparationMode is unspecified,
		then select NormalPhase *)
		{False,False,Automatic},NormalPhase,

		(* If none of the preferred separation modes are NormalPhase or ReversePhase and SeparationMode is specified,
		then select the specified value *)
		{False,False,_},specifiedSeparationMode,

		(* If none of the preferred separation modes are NormalPhase and any of the preferred separation modes are ReversePhase,
		then select ReversePhase *)
		{False,True,_},ReversePhase,

		(* If any of the preferred separation modes are NormalPhase and none of the preferred separation modes are ReversePhase,
		then select NormalPhase *)
		{True,False,_},NormalPhase,

		(* If any of the preferred separation modes are NormalPhase and any others are ReversePhase, then flip an error
		switch and select NormalPhase *)
		{True,True,_},mixedSeparationModesWarning=True;NormalPhase
	];

	(* If SeparationMode is Automatic, resolve to the preferred value. Otherwise resolve to the specified value. *)
	resolvedSeparationMode=Switch[specifiedSeparationMode,
		Automatic,preferredSeparationMode,
		_,specifiedSeparationMode
	];

	(* Throw a Warning if all specified columns and cartridges don't match each other *)
	If[mixedSeparationModesWarning&&messages&&notInEngine,
		Message[Warning::MixedSeparationModes,
			specColumnSeparationModes,
			specCartridgeSeparationModes,
			specCartridgeFunctionalGroups,
			resolvedSeparationMode
		]
	];

	(* If we are gathering tests, make a test for Warning::MixedSeparationModes *)
	mixedSeparationModesTest=If[gatherTests,
		Warning[
			"The separation modes of any specified columns and cartridges match each other:",
			mixedSeparationModesWarning,
			False
		],
		Nothing
	];

	(* Set a Boolean indicating if the SeparationMode is specified and either
	If SeparationMode does not match the preferred SeparationMode given the specified Column, Cartridge, and FunctionalGroup options
	Or if all specified columns and cartridges don't match each other *)
	mismatchedSeparationModesWarning=And[
		!MatchQ[specifiedSeparationMode,Automatic],
		Or[
			!MatchQ[specifiedSeparationMode,preferredSeparationMode],
			mixedSeparationModesWarning
		]
	];

	(* Throw a Warning if if the SeparationMode is specified and does not match the preferred SeparationMode given the
	specified Column, Cartridge, and FunctionalGroup options *)
	If[mismatchedSeparationModesWarning&&messages&&notInEngine,
		Message[Warning::MismatchedSeparationModes,
			specifiedSeparationMode,
			specColumnSeparationModes,
			specCartridgeSeparationModes,
			specCartridgeFunctionalGroups
		]
	];

	(* If we are gathering tests, make a test for Warning::MismatchedSeparationModes *)
	mismatchedSeparationModesTest=If[gatherTests,
		Warning[
			"If SeparationMode is specified, it matches the SeparationMode fields of all specified Columns and Cartridges and matches the separation mode indicated by the CartridgeFunctionalGroup option:",
			mismatchedSeparationModesWarning,
			False
		],
		Nothing
	];

	(*-- BufferA and BufferB --*)

	(* Set the preferred BufferA for each resolved SeparationMode *)
	preferredBufferA=Switch[resolvedSeparationMode,
		NormalPhase,Model[Sample,"Hexanes"],
		ReversePhase,Model[Sample,"Milli-Q water"]
	];

	(* If BufferA is Automatic, resolve to the preferred value, otherwise resolve to the specified value *)
	resolvedBufferA=Switch[specifiedBufferA,
		Automatic,preferredBufferA,
		_,specifiedBufferA
	];

	(* Set the preferred BufferB for each resolved SeparationMode *)
	preferredBufferB=Switch[resolvedSeparationMode,
		NormalPhase,Model[Sample,"Ethyl acetate, HPLC Grade"],
		ReversePhase,Model[Sample,"Methanol"]
	];

	(* If BufferB is Automatic, resolve to the preferred value, otherwise resolve to the specified value *)
	resolvedBufferB=Switch[specifiedBufferB,
		Automatic,preferredBufferB,
		_,specifiedBufferB
	];

	(* Set a Boolean indicating if only one of BufferA and BufferB is specified *)
	incompleteBufferSpecificationError=!MatchQ[
		MatchQ[specifiedBufferA,Automatic],
		MatchQ[specifiedBufferB,Automatic]
	];

	(* Throw an Error if only one of BufferA and BufferB is specified *)
	incompleteBufferSpecificationInvalidOptions=If[incompleteBufferSpecificationError&&messages,
		Message[Error::IncompleteBufferSpecification,
			ObjectToString[specifiedBufferA,Cache->cacheBall],
			ObjectToString[specifiedBufferB,Cache->cacheBall],
			resolvedSeparationMode,
			ObjectToString[preferredBufferA,Cache->cacheBall],
			ObjectToString[preferredBufferB,Cache->cacheBall]
		];
		{BufferA,BufferB},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompleteBufferSpecification *)
	incompleteBufferSpecificationTest=If[gatherTests,
		Test[
			"BufferA and BufferB are specified together or not at all:",
			incompleteBufferSpecificationError,
			False
		],
		Nothing
	];

	(*--- Material Compatibility Tests ---*)

	(* Call CompatibleMaterialsQ to figure out if the samples are compatible with the instrument *)
	{compatibleSamplesAndInstrumentQ,compatibleSamplesAndInstrumentTests}=If[gatherTests,
		CompatibleMaterialsQ[resolvedInstrument,simulatedSamples,Output->{Result,Tests},Cache->cacheBall,Simulation->updatedSimulation],
		{CompatibleMaterialsQ[resolvedInstrument,simulatedSamples,Messages->messages,Cache->cacheBall,Simulation->updatedSimulation],{}}
	];

	(* If the samples are not compatible with the instrument, then the Instrument option is invalid *)
	compatibleSamplesAndInstrumentInvalidOptions=If[compatibleSamplesAndInstrumentQ&&messages,
		{},
		{Instrument}
	];

	(* Call CompatibleMaterialsQ to figure out if the buffers are compatible with the instrument *)
	{compatibleBuffersAndInstrumentQ,compatibleBuffersAndInstrumentTests}=If[gatherTests,
		CompatibleMaterialsQ[resolvedInstrument,{resolvedBufferA,resolvedBufferB},Output->{Result,Tests},Cache->cacheBall,Simulation->updatedSimulation],
		{CompatibleMaterialsQ[resolvedInstrument,{resolvedBufferA,resolvedBufferB},Messages->messages,Cache->cacheBall,Simulation->updatedSimulation],{}}
	];

	(* If the buffers are not compatible with the instrument, then the Instrument, BufferA, and BufferB options are invalid *)
	compatibleBuffersAndInstrumentInvalidOptions=If[compatibleBuffersAndInstrumentQ&&messages,
		{},
		{Instrument,BufferA,BufferB}
	];


	(*--- Resolve the index-matched options ---*)

	(*- Get any packets or field values that will be needed inside the MapThread -*)

	(* Get the packet of the Model of the resolved Instrument *)
	resolvedInstrumentModelPacket=fetchModelPacketFromFastAssoc[resolvedInstrument,fastAssoc];

	(* Lookup required fields from the packet of the resolved instrument's Model *)
	{
		resolvedInstrumentMinFlowRate,
		resolvedInstrumentMaxFlowRate,
		resolvedInstrumentMaxInjectionAssemblyLength,
		resolvedInstrumentInjectionValveLength,
		resolvedInstrumentMinSampleVolume,
		resolvedInstrumentMaxSampleVolume
	}=Lookup[
		resolvedInstrumentModelPacket,
		{MinFlowRate,MaxFlowRate,MaxInjectionAssemblyLength,InjectionValveLength,MinSampleVolume,MaxSampleVolume},
		Null
	];

	(* Get the range of sample volumes that can be loaded into the resolved instrument *)
	resolvedInstrumentVolumeInterval=Interval[{resolvedInstrumentMinSampleVolume,resolvedInstrumentMaxSampleVolume}];

	(* Lookup the model of the resolved BufferB *)
	resolvedBufferBModel=Lookup[
		fetchModelPacketFromFastAssoc[resolvedBufferB,fastAssoc],
		Object,
		Null
	];

	(* Get the list of all syringe models that work with the instrument *)
	syringeModels=combiFlashCompatibleSyringe["Memoization"];

	(* Get the model packets for each of the syringe models *)
	syringeModelPackets=fetchModelPacketFromFastAssoc[#,fastAssoc]&/@syringeModels;

	(* Get the volume interval for each of the syringes *)
	syringeVolumeIntervals=Interval/@Lookup[syringeModelPackets,{MinVolume,MaxVolume}];

	(* Get the total range of volumes that can be transferred by the syringes *)
	syringeVolumeInterval=Fold[IntervalUnion,syringeVolumeIntervals];

	(* Get the list of cartridge caps that work with the instrument *)
	cartridgeCapModels=combiFlashCompatibleCartridgeCap["Memoization"];

	(* Get the model packets for each of the cartridge cap models *)
	cartridgeCapModelPackets=fetchModelPacketFromFastAssoc[#,fastAssoc]&/@cartridgeCapModels;

	(* Get the bed weight interval for each of the cartridge caps *)
	cartridgeCapVolumeIntervals=Interval/@Lookup[cartridgeCapModelPackets,{MinBedWeight,MaxBedWeight}];

	(* Get the total range of bed weights that could be held in cartridges attached to these cartridge caps *)
	cartridgeCapBedWeightInterval=Fold[IntervalUnion,cartridgeCapVolumeIntervals];

	(* Get a list of all columns that can be defaulted to depending on the resolved SeparationMode *)
	defaultColumns=If[MatchQ[resolvedSeparationMode,ReversePhase],
		{
			Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 5.5g"],
			Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 15.5g"],
			Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 30g"],
			Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 50g"],
			Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 100g"],
			Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 150g"]
			(*Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 275g"],
			Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 415g"]*)
		},
		{
			Model[Item,Column,"RediSep Gold Normal Phase Silica Column 4g"],
			Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"],
			Model[Item,Column,"RediSep Gold Normal Phase Silica Column 24g"],
			Model[Item,Column,"RediSep Gold Normal Phase Silica Column 40g"],
			Model[Item,Column,"RediSep Gold Normal Phase Silica Column 80g"],
			Model[Item,Column,"RediSep Gold Normal Phase Silica Column 120g"]
			(*Model[Item,Column,"RediSep Gold Normal Phase Silica Column 220g"],
			Model[Item,Column,"RediSep Gold Normal Phase Silica Column 330g"]*)
		}
	];

	(* Get packets for the default columns *)
	defaultColumnPackets=Map[fetchPacketFromFastAssoc[#,fastAssoc]&,defaultColumns];

	(* Lookup VoidVolume from the default column Model packets *)
	defaultColumnVoidVolumes=Lookup[defaultColumnPackets,VoidVolume,Null];

	(* Get the default column with the largest VoidVolume *)
	largestDefaultColumn=FirstOrDefault[PickList[
		defaultColumns,
		defaultColumnVoidVolumes,
		Max[defaultColumnVoidVolumes]
	]];

	(* Get the VoidVolume of the default column with the largest VoidVolume *)
	largestDefaultColumnVoidVolume=Max[defaultColumnVoidVolumes];

	(* Get a list of all fraction collection containers that can be defaulted to *)
	defaultContainers=Flatten[combiFlashCompatibleFractionContainer["Memoization",Cache->cacheBall]];

	(* Get packets for the default fraction collection containers *)
	defaultContainerPackets=Map[fetchPacketFromFastAssoc[#,fastAssoc]&,defaultContainers];

	(* Lookup MaxVolume from the default fraction collection container packets *)
	defaultContainerMaxVolumes=Lookup[defaultContainerPackets,MaxVolume,Null];

	(* Get the default fraction collection containers with the largest MaxVolume *)
	largestDefaultContainers=PickList[
		defaultContainers,
		defaultContainerMaxVolumes,
		Max[defaultContainerMaxVolumes]
	];

	(* If the list of largestDefaultContainers includes Model[Container,Vessel,"15mL Tube"],
	then default to it, otherwise use the first element of the list (or Null if it is {}) *)
	largestDefaultContainer=If[
		MemberQ[largestDefaultContainers,ObjectP[Model[Container,Vessel,"id:xRO9n3vk11pw"]]],
		Model[Container,Vessel,"id:xRO9n3vk11pw"],
		FirstOrDefault[largestDefaultContainers]
	];

	(* Get the MaxVolume of the default fraction collection container with the largest MaxVolume *)
	largestDefaultContainerMaxVolume=Max[defaultContainerMaxVolumes];

	(* Set the maximum fraction of the fraction collection container's MaxVolume that can be filled *)
	fractionOfMaxVolume=0.8;

	(* Get the sample volumes *)
	sampleVolumesRaw=Lookup[samplePackets,Volume,Null];

	(* Convert the sample volumes from liters to milliliters to display more nicely in error messages *)
	sampleVolumes=Map[
		If[VolumeQ[#],Convert[#,Milliliter],#]&,
		sampleVolumesRaw
	];

	(* Set the requirement for Grams of cartridge packing material per milliliter of sample loaded *)
	cartridgeLoadingFactor=2 Gram/Milliliter;

	(* Get a list of the detector options *)
	detectorOptions={
		PrimaryWavelength,
		SecondaryWavelength,
		WideRangeUV
	};

	sampleIndexes=Range[Length[mapThreadFriendlyOptions]];

	(* MapThread to resolve all index-matched options *)
	(* Convention:
		Unresolved options are called specified outside of the MapThread and unresolved inside
		Resolved options are called resolved outside of the MapThread and by their names in lowercase inside *)
	{
		(* Resolved options *)
		resolvedLoadingType,
		resolvedMaxLoadingPercent,
		resolvedColumn,
		resolvedLoadingAmount,
		resolvedCartridge,
		resolvedCartridgePackingMaterial,
		resolvedCartridgeFunctionalGroup,
		resolvedCartridgePackingMass,
		resolvedCartridgeDryingTime,
		resolvedFlowRate,
		resolvedPreSampleEquilibration,
		resolvedGradientStart,
		resolvedGradientEnd,
		resolvedGradientDuration,
		resolvedEquilibrationTime,
		resolvedFlushTime,
		resolvedGradientB,
		resolvedGradientA,
		resolvedGradient,
		resolvedCollectFractions,
		resolvedFractionCollectionStartTime,
		resolvedFractionCollectionEndTime,
		resolvedFractionContainer,
		resolvedMaxFractionVolume,
		resolvedFractionCollectionMode,
		resolvedDetectors,
		resolvedPrimaryWavelength,
		resolvedSecondaryWavelength,
		resolvedWideRangeUV,
		resolvedPeakDetectors,
		resolvedPrimaryWavelengthPeakDetectionMethod,
		resolvedSecondaryWavelengthPeakDetectionMethod,
		resolvedWideRangeUVPeakDetectionMethod,
		resolvedPrimaryWavelengthPeakWidth,
		resolvedSecondaryWavelengthPeakWidth,
		resolvedWideRangeUVPeakWidth,
		resolvedPrimaryWavelengthPeakThreshold,
		resolvedSecondaryWavelengthPeakThreshold,
		resolvedWideRangeUVPeakThreshold,
		resolvedColumnStorageCondition,
		resolvedAirPurgeDuration,
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedColumnLabel,
		resolvedCartridgeLabel,

		(* Errors and warnings *)
		mismatchedCartridgeOptionsErrors,
		mismatchedSolidLoadNullCartridgeOptionsErrors,
		mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors,
		recommendedMaxLoadingPercentExceededWarnings,
		deprecatedColumnErrors,
		incompatibleColumnTypeErrors,
		incompatibleColumnAndInstrumentFlowRateErrors,
		insufficientSampleVolumeErrors,
		invalidLoadingAmountForColumnErrors,
		invalidLoadingAmountErrors,
		invalidLoadingAmountForInstrumentErrors,
		invalidLoadingAmountForSyringesErrors,
		incompatibleCartridgeLoadingTypeErrors,
		incompatibleCartridgeTypeErrors,
		incompatibleCartridgePackingTypeErrors,
		incompatibleCartridgeAndInstrumentFlowRateErrors,
		incompatibleCartridgeAndColumnFlowRateErrors,
		invalidCartridgeMaxBedWeightErrors,
		incompatibleInjectionAssemblyLengthErrors,
		mismatchedColumnAndPrepackedCartridgeWarnings,
		invalidCartridgePackingMaterialErrors,
		invalidCartridgeFunctionalGroupErrors,
		mismatchedColumnAndCartridgeWarnings,
		invalidCartridgePackingMassErrors,
		tooHighCartridgePackingMassErrors,
		tooLowCartridgePackingMassErrors,
		invalidPackingMassForCartridgeCapsErrors,
		incompatibleFlowRateErrors,
		incompatiblePreSampleEquilibrationErrors,
		redundantGradientShortcutErrors,
		incompleteGradientShortcutErrors,
		zeroGradientShortcutErrors,
		redundantGradientSpecificationErrors,
		invalidGradientBTimeErrors,
		invalidGradientATimeErrors,
		invalidGradientTimeErrors,
		invalidTotalGradientTimeErrors,
		methanolPercentWarnings,
		invalidFractionCollectionOptionsErrors,
		invalidCollectFractionsErrors,
		mismatchedFractionCollectionOptionsErrors,
		invalidFractionCollectionStartTimeErrors,
		invalidFractionCollectionEndTimeErrors,
		invalidFractionContainerErrors,
		invalidMaxFractionVolumeForContainerErrors,
		invalidMaxFractionVolumeErrors,
		invalidSpecifiedDetectorsErrors,
		invalidNullDetectorsErrors,
		invalidWideRangeUVErrors,
		missingPeakDetectorsErrors,
		invalidSpecifiedPrimaryWavelengthPeakDetectionErrors,
		invalidSpecifiedSecondaryWavelengthPeakDetectionErrors,
		invalidSpecifiedWideRangeUVPeakDetectionErrors,
		invalidNullPrimaryWavelengthPeakDetectionMethodErrors,
		invalidNullSecondaryWavelengthPeakDetectionMethodErrors,
		invalidNullWideRangeUVPeakDetectionMethodErrors,
		invalidNullPrimaryWavelengthPeakDetectionParametersErrors,
		invalidNullSecondaryWavelengthPeakDetectionParametersErrors,
		invalidNullWideRangeUVPeakDetectionParametersErrors,
		invalidPrimaryWavelengthPeakWidthErrors,
		invalidSecondaryWavelengthPeakWidthErrors,
		invalidWideRangeUVPeakWidthErrors,
		invalidPrimaryWavelengthPeakThresholdErrors,
		invalidSecondaryWavelengthPeakThresholdErrors,
		invalidWideRangeUVPeakThresholdErrors,
		invalidColumnStorageConditionErrors,
		invalidAirPurgeDurationErrors,
		airPurgeAndStoreColumnWarnings,
		invalidNullCartridgeLabelErrors,
		invalidSpecifiedCartridgeLabelErrors,

		(* Values to populate error messages *)
		preferredMaxLoadingPercents,
		resolvedMaxLoadingFractions,
		specifiedColumnChromatographyTypes,
		specifiedColumnMinFlowRates,
		specifiedColumnMaxFlowRates,
		specifiedColumnVoidVolumes,
		resolvedColumnMinFlowRates,
		resolvedColumnMaxFlowRates,
		specifiedLoadingAmountVolumes,
		resolvedLoadingAmountVolumes,
		specifiedCartridgeChromatographyTypes,
		specifiedCartridgePackingTypes,
		specifiedCartridgeMinFlowRates,
		specifiedCartridgeMaxFlowRates,
		resolvedColumnLengths,
		resolvedCartridgeLengths,
		injectionAssemblyLengths,
		resolvedColumnSeparationModes,
		resolvedColumnPackingMaterials,
		resolvedColumnFunctionalGroups,
		resolvedCartridgeSeparationModes,
		resolvedCartridgePackingMaterials,
		resolvedCartridgeFunctionalGroups,
		resolvedCartridgePackingTypes,
		resolvedCartridgeMaxBedWeights,
		resolvedCartridgeMinFlowRates,
		resolvedCartridgeMaxFlowRates,
		resolvedFlowRateIntervals,
		specifiedGradientBTimes,
		specifiedGradientATimes,
		specifiedGradientTimes,
		resolvedTotalGradientBTimes,
		resolvedContainerMaxVolumes,
		resolvedDetectorsLists
	}=Transpose[
		MapThread[
			Function[{samplePacket,sampleVolume,options,sampleContainerPacket,myInputSample,myInputSampleContainer,sampleIndex},
				Module[
					{
						(* Error tracking variables *)
						mismatchedCartridgeOptionsError,mismatchedSolidLoadNullCartridgeOptionsError,mismatchedLiquidLoadSpecifiedCartridgeOptionsError,
						recommendedMaxLoadingPercentExceededWarning,insufficientSampleVolumeError,invalidLoadingAmountForColumnError,invalidLoadingAmountError,
						invalidLoadingAmountForInstrumentError,invalidLoadingAmountForSyringesError,
						incompatibleCartridgeLoadingTypeError,incompatibleCartridgeTypeError,incompatibleCartridgePackingTypeError,
						incompatibleCartridgeAndInstrumentFlowRateError,incompatibleCartridgeAndColumnFlowRateError,
						invalidCartridgeMaxBedWeightError,
						incompatibleInjectionAssemblyLengthError,mismatchedColumnAndPrepackedCartridgeWarning,
						invalidCartridgePackingMaterialError,invalidCartridgeFunctionalGroupError,mismatchedColumnAndCartridgeWarning,
						invalidCartridgePackingMassError,tooHighCartridgePackingMassError,tooLowCartridgePackingMassError,
						invalidPackingMassForCartridgeCapsError,
						incompatibleFlowRateError,incompatiblePreSampleEquilibrationError,
						redundantGradientShortcutError,incompleteGradientShortcutError,zeroGradientShortcutError,
						redundantGradientSpecificationError,
						invalidGradientBTimeError,invalidGradientATimeError,invalidGradientTimeError,invalidTotalGradientTimeError,
						methanolPercentWarning,
						invalidFractionCollectionOptionsError,invalidCollectFractionsError,mismatchedFractionCollectionOptionsError,
						invalidFractionCollectionStartTimeError,invalidFractionCollectionEndTimeError,invalidFractionContainerError,
						invalidMaxFractionVolumeForContainerError,invalidMaxFractionVolumeError,
						invalidSpecifiedDetectorsError,invalidNullDetectorsError,invalidWideRangeUVError,
						missingPeakDetectorsError,
						invalidSpecifiedPrimaryWavelengthPeakDetectionError,invalidSpecifiedSecondaryWavelengthPeakDetectionError,
						invalidSpecifiedWideRangeUVPeakDetectionError,invalidNullPrimaryWavelengthPeakDetectionMethodError,
						invalidNullSecondaryWavelengthPeakDetectionMethodError,invalidNullWideRangeUVPeakDetectionMethodError,
						invalidNullPrimaryWavelengthPeakDetectionParametersError,invalidNullSecondaryWavelengthPeakDetectionParametersError,
						invalidNullWideRangeUVPeakDetectionParametersError,invalidPrimaryWavelengthPeakWidthError,
						invalidSecondaryWavelengthPeakWidthError,invalidWideRangeUVPeakWidthError,
						invalidPrimaryWavelengthPeakThresholdError,invalidSecondaryWavelengthPeakThresholdError,
						invalidWideRangeUVPeakThresholdError,invalidColumnStorageConditionError,invalidAirPurgeDurationError,airPurgeAndStoreColumnWarning,
						invalidNullCartridgeLabelError,invalidSpecifiedCartridgeLabelError,

						(* For unresolved option Lookup *)
						unresolvedLoadingType,unresolvedColumn,unresolvedPreSampleEquilibration,unresolvedLoadingAmount,unresolvedMaxLoadingPercent,unresolvedCartridge,
						unresolvedCartridgePackingMaterial,unresolvedCartridgeFunctionalGroup,unresolvedCartridgePackingMass,unresolvedCartridgeDryingTime,
						unresolvedGradientA,unresolvedGradientB,unresolvedFlowRate,unresolvedGradientStart,unresolvedGradientEnd,unresolvedGradientDuration,
						unresolvedEquilibrationTime,unresolvedFlushTime,unresolvedGradient,unresolvedCollectFractions,unresolvedFractionCollectionStartTime,
						unresolvedFractionCollectionEndTime,unresolvedFractionContainer,unresolvedMaxFractionVolume,unresolvedFractionCollectionMode,
						unresolvedDetectors,unresolvedPrimaryWavelength,unresolvedSecondaryWavelength,unresolvedWideRangeUV,unresolvedPeakDetectors,
						unresolvedPrimaryWavelengthPeakDetectionMethod,unresolvedPrimaryWavelengthPeakWidth,unresolvedPrimaryWavelengthPeakThreshold,
						unresolvedSecondaryWavelengthPeakDetectionMethod,unresolvedSecondaryWavelengthPeakWidth,unresolvedSecondaryWavelengthPeakThreshold,
						unresolvedWideRangeUVPeakDetectionMethod,unresolvedWideRangeUVPeakWidth,unresolvedWideRangeUVPeakThreshold,unresolvedColumnStorageCondition,
						unresolvedAirPurgeDuration,unresolvedSampleLabel,unresolvedSampleContainerLabel,unresolvedColumnLabel,
						unresolvedCartridgeLabel,

						(* Variables for resolving options *)
						cartridgeOptionsSpecifiedQ,cartridgeOptionsNullQ,loadingType,
						preferredMaxLoadingPercent,maxLoadingPercent,maxLoadingFraction,
						unresolvedColumnModelPacket,
						unresolvedColumnChromatographyType,unresolvedColumnMinFlowRate,unresolvedColumnMaxFlowRate,unresolvedColumnVoidVolume,
						unresolvedColumnDeprecated,
						deprecatedColumnError,incompatibleColumnTypeError,incompatibleColumnAndInstrumentFlowRateError,
						possibleColumnBools,possibleColumns,numberOfPossibleColumns,possibleColumnVoidVolumes,smallestPossibleColumn,
						column,columnModelPacket,columnVoidVolume,columnMinFlowRate,columnMaxFlowRate,columnBedWeight,
						columnLength,columnSeparationMode,columnPackingMaterial,columnFunctionalGroup,columnReusability,
						preferredLoadingAmount,roundedSampleVolume,unresolvedLoadingAmountVolume,loadingAmount,loadingAmountVolume,
						unresolvedCartridgeModelPacket,unresolvedCartridgeChromatographyType,unresolvedCartridgePackingType,
						unresolvedCartridgeMinFlowRate,unresolvedCartridgeMaxFlowRate,
						preferredCartridge,cartridge,cartridgeModelPacket,cartridgeLength,cartridgeSeparationMode,
						cartridgePackingMaterialField,cartridgeFunctionalGroupField,cartridgeBedWeight,cartridgeMaxBedWeight,
						cartridgePackingType,cartridgeMinFlowRate,cartridgeMaxFlowRate,cartridgeChromatographyType,
						cartridgeQ,injectionAssemblyLength,cartridgePackingMaterial,
						cartridgeFunctionalGroup,cartridgePackingMass,cartridgeDryingTime,flowRate,flowRateInterval,
						columnTime,preSampleEquilibration,
						anyShortcutSpecifiedQ,anyNonShortcutSpecifiedQ,allEssentialShortcutsSpecifiedQ,
						gradientStart,gradientEnd,gradientDuration,equilibrationTime,flushTime,gradientShortcutQ,shortcutGradientB,
						shortcutGradientBComplement,
						numberOfSpecifiedGradientOptions,gradientASpecifiedQ,gradientBSpecifiedQ,gradientSpecifiedQ,
						unresolvedGradientAComplement,unresolvedGradientBComplement,
						mismatchedGradientGradientA,mismatchedGradientGradientB,mismatchedGradientAGradientB,
						mismatchedShortcutGradientA,mismatchedShortcutGradientB,mismatchedShortcutGradient,

						unresolvedGradientBTime,unresolvedGradientATime,unresolvedGradientTime,
						maxDefaultGradientBPercent,defaultGradientB,gradientB,gradientA,
						gradientBTime,gradientATime,gradientTimeEqualQ,
						gradientBPercent,gradientAPercent,gradientBPercentComplement,gradient,maxBufferBPercent,
						fractionOptions,fractionOptionsSpecifiedQ,fractionOptionsNullQ,collectFractions,
						totalGradientBTime,fractionCollectionStartTime,fractionCollectionEndTime,
						possibleContainerBools,possibleContainers,numberOfPossibleContainers,possibleContainerMaxVolumes,
						smallestPossibleContainers,smallestPossibleContainer,fractionContainer,containerModelPacket,containerMaxVolume,
						maxFractionVolume,fractionCollectionMode,
						detectorsList,unresolvedDetectorOptionValues,
						detectorOptionMemberQ,primaryWavelengthMemberQ,secondaryWavelengthMemberQ,wideRangeUVMemberQ,
						detectors,primaryWavelength,secondaryWavelength,wideRangeUV,
						unresolvedPeakDetectorsList,preferredPeakDetectors,
						peakDetectors,peakDetectorsList,
						unresolvedPeakDetectionMethodsOptions,unresolvedPeakWidthsOptions,unresolvedPeakThresholdsOptions,
						primaryWavelengthPeakDetectionMethod,secondaryWavelengthPeakDetectionMethod,wideRangeUVPeakDetectionMethod,
						primaryWavelengthPeakWidth,secondaryWavelengthPeakWidth,wideRangeUVPeakWidth,
						primaryWavelengthPeakThreshold,secondaryWavelengthPeakThreshold,wideRangeUVPeakThreshold,
						columnReusedQ,columnStorageCondition,airPurgeDuration,
						simulationObjectToLabelRules,simulationInputSampleLabel,sampleLabel,
						simulationInputSampleContainerLabel,sampleContainerLabel,columnLabel,cartridgeLabel


					},

					(* Initialize error checking switches *)
					{
						mismatchedCartridgeOptionsError,
						mismatchedSolidLoadNullCartridgeOptionsError,
						mismatchedLiquidLoadSpecifiedCartridgeOptionsError,
						recommendedMaxLoadingPercentExceededWarning,
						deprecatedColumnError,
						incompatibleColumnTypeError,
						incompatibleColumnAndInstrumentFlowRateError,
						insufficientSampleVolumeError,
						invalidLoadingAmountForColumnError,
						invalidLoadingAmountError,
						invalidLoadingAmountForInstrumentError,
						invalidLoadingAmountForSyringesError,
						incompatibleCartridgeLoadingTypeError,
						incompatibleCartridgeTypeError,
						incompatibleCartridgePackingTypeError,
						incompatibleCartridgeAndInstrumentFlowRateError,
						incompatibleCartridgeAndColumnFlowRateError,
						invalidCartridgeMaxBedWeightError,
						incompatibleInjectionAssemblyLengthError,
						mismatchedColumnAndPrepackedCartridgeWarning,
						invalidCartridgePackingMaterialError,
						invalidCartridgeFunctionalGroupError,
						mismatchedColumnAndCartridgeWarning,
						invalidCartridgePackingMassError,
						tooHighCartridgePackingMassError,
						tooLowCartridgePackingMassError,
						invalidPackingMassForCartridgeCapsError,
						incompatibleFlowRateError,
						incompatiblePreSampleEquilibrationError,
						redundantGradientShortcutError,
						incompleteGradientShortcutError,
						zeroGradientShortcutError,
						redundantGradientSpecificationError,
						invalidGradientBTimeError,
						invalidGradientATimeError,
						invalidGradientTimeError,
						invalidTotalGradientTimeError,
						methanolPercentWarning,
						invalidFractionCollectionOptionsError,
						invalidCollectFractionsError,
						mismatchedFractionCollectionOptionsError,
						invalidFractionCollectionStartTimeError,
						invalidFractionCollectionEndTimeError,
						invalidFractionContainerError,
						invalidMaxFractionVolumeForContainerError,
						invalidMaxFractionVolumeError,
						invalidSpecifiedDetectorsError,
						invalidNullDetectorsError,
						invalidWideRangeUVError,
						missingPeakDetectorsError,
						invalidSpecifiedPrimaryWavelengthPeakDetectionError,
						invalidSpecifiedSecondaryWavelengthPeakDetectionError,
						invalidSpecifiedWideRangeUVPeakDetectionError,
						invalidNullPrimaryWavelengthPeakDetectionMethodError,
						invalidNullSecondaryWavelengthPeakDetectionMethodError,
						invalidNullWideRangeUVPeakDetectionMethodError,
						invalidNullPrimaryWavelengthPeakDetectionParametersError,
						invalidNullSecondaryWavelengthPeakDetectionParametersError,
						invalidNullWideRangeUVPeakDetectionParametersError,
						invalidPrimaryWavelengthPeakWidthError,
						invalidSecondaryWavelengthPeakWidthError,
						invalidWideRangeUVPeakWidthError,
						invalidPrimaryWavelengthPeakThresholdError,
						invalidSecondaryWavelengthPeakThresholdError,
						invalidWideRangeUVPeakThresholdError,
						invalidColumnStorageConditionError,
						invalidAirPurgeDurationError,
						airPurgeAndStoreColumnWarning,
						invalidNullCartridgeLabelError,
						invalidSpecifiedCartridgeLabelError
					}=ConstantArray[False,70];

					(* Get the unresolved options *)
					{
						unresolvedLoadingType,
						unresolvedColumn,
						unresolvedPreSampleEquilibration,
						unresolvedLoadingAmount,
						unresolvedMaxLoadingPercent,
						unresolvedCartridge,
						unresolvedCartridgePackingMaterial,
						unresolvedCartridgeFunctionalGroup,
						unresolvedCartridgePackingMass,
						unresolvedCartridgeDryingTime,
						unresolvedGradientA,
						unresolvedGradientB,
						unresolvedFlowRate,
						unresolvedGradientStart,
						unresolvedGradientEnd,
						unresolvedGradientDuration,
						unresolvedEquilibrationTime,
						unresolvedFlushTime,
						unresolvedGradient,
						unresolvedCollectFractions,
						unresolvedFractionCollectionStartTime,
						unresolvedFractionCollectionEndTime,
						unresolvedFractionContainer,
						unresolvedMaxFractionVolume,
						unresolvedFractionCollectionMode,
						unresolvedDetectors,
						unresolvedPrimaryWavelength,
						unresolvedSecondaryWavelength,
						unresolvedWideRangeUV,
						unresolvedPeakDetectors,
						unresolvedPrimaryWavelengthPeakDetectionMethod,
						unresolvedPrimaryWavelengthPeakWidth,
						unresolvedPrimaryWavelengthPeakThreshold,
						unresolvedSecondaryWavelengthPeakDetectionMethod,
						unresolvedSecondaryWavelengthPeakWidth,
						unresolvedSecondaryWavelengthPeakThreshold,
						unresolvedWideRangeUVPeakDetectionMethod,
						unresolvedWideRangeUVPeakWidth,
						unresolvedWideRangeUVPeakThreshold,
						unresolvedColumnStorageCondition,
						unresolvedAirPurgeDuration,
						unresolvedSampleLabel,
						unresolvedSampleContainerLabel,
						unresolvedColumnLabel,
						unresolvedCartridgeLabel
					}=Lookup[
						options,
						{
							LoadingType,
							Column,
							PreSampleEquilibration,
							LoadingAmount,
							MaxLoadingPercent,
							Cartridge,
							CartridgePackingMaterial,
							CartridgeFunctionalGroup,
							CartridgePackingMass,
							CartridgeDryingTime,
							GradientA,
							GradientB,
							FlowRate,
							GradientStart,
							GradientEnd,
							GradientDuration,
							EquilibrationTime,
							FlushTime,
							Gradient,
							CollectFractions,
							FractionCollectionStartTime,
							FractionCollectionEndTime,
							FractionContainer,
							MaxFractionVolume,
							FractionCollectionMode,
							Detectors,
							PrimaryWavelength,
							SecondaryWavelength,
							WideRangeUV,
							PeakDetectors,
							PrimaryWavelengthPeakDetectionMethod,
							PrimaryWavelengthPeakWidth,
							PrimaryWavelengthPeakThreshold,
							SecondaryWavelengthPeakDetectionMethod,
							SecondaryWavelengthPeakWidth,
							SecondaryWavelengthPeakThreshold,
							WideRangeUVPeakDetectionMethod,
							WideRangeUVPeakWidth,
							WideRangeUVPeakThreshold,
							ColumnStorageCondition,
							AirPurgeDuration,
							SampleLabel,
							SampleContainerLabel,
							ColumnLabel,
							CartridgeLabel
						}
					];

					(*-- LoadingType --*)

					(* Are any cartridge-related options specified? (to something non-Null) *)
					cartridgeOptionsSpecifiedQ=MemberQ[
						{
							unresolvedCartridge,
							unresolvedCartridgePackingMaterial,
							unresolvedCartridgeFunctionalGroup,
							unresolvedCartridgePackingMass,
							unresolvedCartridgeDryingTime
						},
						Except[Null|Automatic]
					];

					(* Are any cartridge-related options (except CartridgeFunctionalGroup) Null? *)
					cartridgeOptionsNullQ=MemberQ[
						{
							unresolvedCartridge,
							unresolvedCartridgePackingMaterial,
							unresolvedCartridgePackingMass,
							unresolvedCartridgeDryingTime
						},
						Null
					];

					(* Flip an error switch if some cartridge-related options are specified and others are Null *)
					mismatchedCartridgeOptionsError=cartridgeOptionsSpecifiedQ&&cartridgeOptionsNullQ;

					(* Flip an error switch if LoadingType is specified to Solid, but some cartridge-related options are Null *)
					mismatchedSolidLoadNullCartridgeOptionsError=MatchQ[unresolvedLoadingType,Solid]&&cartridgeOptionsNullQ;

					(* Flip an error switch if LoadingType is specified to Liquid, but some cartridge-related options are specified *)
					mismatchedLiquidLoadSpecifiedCartridgeOptionsError=MatchQ[unresolvedLoadingType,Liquid]&&cartridgeOptionsSpecifiedQ;

					(* If LoadingType is Automatic, resolve to Solid if any cartridge-related options are specified and to Liquid otherwise *)
					loadingType=Switch[{unresolvedLoadingType,cartridgeOptionsSpecifiedQ},
						{Automatic,True},Solid,
						{Automatic,False},Liquid,
						{_,_},unresolvedLoadingType
					];

					(*-- MaxLoadingPercent --*)

					(* Set the preferred MaxLoadingPercent depending on whether the LoadingType is Solid or (Liquid or Preloaded) *)
					preferredMaxLoadingPercent=If[MatchQ[loadingType,Solid],
						12 Percent,
						6 Percent
					];

					(* Flip a warning switch if MaxLoadingPercent is specified and it is greater than the preferred MaxLoadingPercent *)
					recommendedMaxLoadingPercentExceededWarning=And[
						MatchQ[unresolvedMaxLoadingPercent,PercentP],
						unresolvedMaxLoadingPercent>preferredMaxLoadingPercent
					];

					(* If MaxLoadingPercent is Automatic, resolve to the preferredMaxLoadingPercent *)
					maxLoadingPercent=Switch[unresolvedMaxLoadingPercent,
						Automatic,preferredMaxLoadingPercent,
						_,unresolvedMaxLoadingPercent
					];

					maxLoadingFraction=Unitless[maxLoadingPercent,Percent]/100.;

					(*-- Column --*)

					(* If Column is specified, get the packet of its Model *)
					unresolvedColumnModelPacket=fetchModelPacketFromFastAssoc[unresolvedColumn,fastAssoc];

					(* Lookup the necessary fields from the column's model packet *)
					{
						unresolvedColumnChromatographyType,
						unresolvedColumnMinFlowRate,
						unresolvedColumnMaxFlowRate,
						unresolvedColumnVoidVolume,
						unresolvedColumnDeprecated
					}=Lookup[
						unresolvedColumnModelPacket,
						{ChromatographyType,MinFlowRate,MaxFlowRate,VoidVolume,Deprecated},
						Null
					];

					(* Flip an error switch if Column is specified and its Model is Deprecated->True *)
					deprecatedColumnError=And[
						MatchQ[unresolvedColumn,ObjectP[{Model[Item,Column],Object[Item,Column]}]],
						TrueQ[unresolvedColumnDeprecated]
					];

					(* Flip an error switch if Column is specified and its Model's ChromatographyType is not Flash *)
					incompatibleColumnTypeError=And[
						MatchQ[unresolvedColumn,ObjectP[{Model[Item,Column],Object[Item,Column]}]],
						!MatchQ[unresolvedColumnChromatographyType,Flash]
					];

					(* Flip an error switch if Column is specified and there is no overlap between the column and
					instrument min/max flow rate intervals *)
					incompatibleColumnAndInstrumentFlowRateError=And[
						MatchQ[unresolvedColumn,ObjectP[{Model[Item,Column],Object[Item,Column]}]],
						!MatchQ[
							IntervalIntersection[
								Interval[{unresolvedColumnMinFlowRate,unresolvedColumnMaxFlowRate}],
								Interval[{resolvedInstrumentMinFlowRate,resolvedInstrumentMaxFlowRate}]
							],
							Quantity[Interval[{NumberP,NumberP}],_]
						]
					];

					(* Round the sample volume down to the instrument's volume precision *)
					roundedSampleVolume=SafeRound[sampleVolume,volumePrecision,Round->Down];

					(* If unresolvedLoadingAmount is All, replace it with the sample volume *)
					unresolvedLoadingAmountVolume=If[MatchQ[unresolvedLoadingAmount,All],
						roundedSampleVolume,
						unresolvedLoadingAmount
					];

					(* Generate a list of Booleans indicating whether for each default column,
					maxLoadingPercent of its VoidVolume is larger than or equal to the specified LoadingAmount
					All False if LoadingAmount is unspecified, or if none of the default columns are big enough to hold the specified LoadingAmount *)
					possibleColumnBools=Map[
						TrueQ[#>=unresolvedLoadingAmountVolume]&,
						defaultColumnVoidVolumes*maxLoadingFraction
					];

					(* Get a list of the default columns that are large enough for the specified LoadingAmount *)
					(* If LoadingAmount is unspecified, or if none of the default columns are big enough to hold the specified LoadingAmount, this is an empty list *)
					possibleColumns=PickList[defaultColumns,possibleColumnBools];

					(* Get the number of default columns that are large enough for the specified LoadingAmount *)
					numberOfPossibleColumns=Length[possibleColumns];

					(* Get a list of the VoidVolumes of the possibleColumns *)
					possibleColumnVoidVolumes=PickList[defaultColumnVoidVolumes,possibleColumnBools];

					(* Get the element of possibleColumns with the smallest VoidVolume *)
					smallestPossibleColumn=FirstOrDefault[PickList[
						possibleColumns,
						possibleColumnVoidVolumes,
						Min[possibleColumnVoidVolumes]
					]];

					(* Resolve Column *)
					column=Switch[{unresolvedColumn,unresolvedLoadingAmount,numberOfPossibleColumns,resolvedSeparationMode},

						(* If Column and LoadingAmount are unspecified and the resolved SeparationMode is ReversePhase,
						resolve to a 15.5g C18 column *)
						{Automatic,Automatic,_,ReversePhase},
						Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 15.5g"],

						(* If Column and LoadingAmount are unspecified and the resolved SeparationMode is NormalPhase,
						resolve to a 12g Silica column *)
						{Automatic,Automatic,_,_},
						Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"],

						(* If Column is unspecified, LoadingAmount is specified, and there are columns from the default
						list large enough to hold the LoadingAmount, resolve to the smallest such column*)
						{Automatic,_,GreaterP[0],_},smallestPossibleColumn,

						(* If Column is unspecified, LoadingAmount is specified, are there aren't any columns from the
						default list large enough to hold the LoadingAmount, then resolve to the largest column from the
						default list. An error switch (invalidLoadingAmountError) will be flipped below. The column will
						be used to populate the error message and for later parts of the resolver that need a column. *)
						{Automatic,_,_,_},largestDefaultColumn,

						(* If Column is specified, resolve to the specified value *)
						{_,_,_,_},unresolvedColumn
					];

					(*-- LoadingAmount --*)

					(* Get the packet of the Model of the resolved Column *)
					columnModelPacket=fetchModelPacketFromFastAssoc[column,fastAssoc];

					(* Lookup the necessary fields from the resolved column's model packet *)
					{
						columnVoidVolume,
						columnMinFlowRate,
						columnMaxFlowRate,
						columnBedWeight,
						columnLength,
						columnSeparationMode,
						columnPackingMaterial,
						columnFunctionalGroup,
						columnReusability
					}=Lookup[
						columnModelPacket,
						{VoidVolume,MinFlowRate,MaxFlowRate,BedWeight,ColumnLength,SeparationMode,PackingMaterial,FunctionalGroup,Reusable},
						Null
					];

					(* The preferred loading amount is the resolved MaxLoadingPercent times the column volume (VoidVolume) *)
					preferredLoadingAmount=If[NullQ[columnVoidVolume],
						Null,
						SafeRound[maxLoadingFraction*columnVoidVolume,volumePrecision]
					];

					(* Flip an error switch if LoadingAmount is specified and is greater than the volume of the sample *)
					insufficientSampleVolumeError=And[
						MatchQ[unresolvedLoadingAmountVolume,VolumeP],
						unresolvedLoadingAmountVolume>roundedSampleVolume
					];

					(* Flip an error switch if LoadingAmount is specified, Column is specified,
					and LoadingAmount is greater than the preferred loading amount *)
					invalidLoadingAmountForColumnError=And[
						MatchQ[unresolvedLoadingAmountVolume,VolumeP],
						MatchQ[unresolvedColumn,ObjectP[{Model[Item,Column],Object[Item,Column]}]],
						unresolvedLoadingAmountVolume>preferredLoadingAmount
					];

					(* Flip an error switch if LoadingAmount is specified, Column is unspecified,
					and LoadingAmount is greater than the preferred loading amount *)
					(* If this switch is flipped, the resolved Column must be largestDefaultColumn from above. *)
					invalidLoadingAmountError=And[
						MatchQ[unresolvedLoadingAmountVolume,VolumeP],
						!MatchQ[unresolvedColumn,ObjectP[{Model[Item,Column],Object[Item,Column]}]],
						unresolvedLoadingAmountVolume>preferredLoadingAmount
					];

					(* Resolve LoadingAmount *)
					loadingAmount=Switch[{unresolvedLoadingAmount,preferredLoadingAmount,roundedSampleVolume},

						(* If LoadingAmount is unspecified and both preferredLoadingAmount and sampleVolume are volumes (i.e. non-Null),
						resolve to whichever of the two is smaller *)
						{Automatic,VolumeP,VolumeP},Min[preferredLoadingAmount,roundedSampleVolume],

						(* If preferredLoadingAmount is not a volume, that means that the column's Model's VoidVolume is
						not defined. All columns of ChromatographyType Flash must have VoidVolume defined, so
						Error::IncompatibleColumnType was thrown above.
						If sampleVolume is not a volume, that means that the sample's Volume is not defined, so
						Error::MissingSampleVolumes was thrown above.
						Resolve to the instrument's minimum sample volume (0.1 mL) to keep going through the resolver. *)
						{Automatic,_,_},resolvedInstrumentMinSampleVolume,

						(* If LoadingAmount is specified, resolve to the specified value *)
						{_,_,_},unresolvedLoadingAmount
					];

					(* Get a version of the resolved LoadingAmount with All replaced by sample volume *)
					loadingAmountVolume=If[MatchQ[loadingAmount,All],
						roundedSampleVolume,
						loadingAmount
					];

					(* Flip an error switch if the resolved LoadingAmount is not within the resolved instrument's
					MinSampleVolume and MaxSampleVolume interval *)
					invalidLoadingAmountForInstrumentError=!IntervalMemberQ[
						resolvedInstrumentVolumeInterval,
						loadingAmountVolume
					];

					(* Flip an error switch if the resolved LoadingAmount is not within the interval of volumes covered
					by the list of instrument-compatible syringes *)
					invalidLoadingAmountForSyringesError=!IntervalMemberQ[
						syringeVolumeInterval,
						loadingAmountVolume
					];

					(*-- Cartridge --*)

					(* If Cartridge is specified, get the packet of its Model *)
					unresolvedCartridgeModelPacket=fetchModelPacketFromFastAssoc[unresolvedCartridge,fastAssoc];

					(* Lookup the necessary fields from the specified cartridge's model packet *)
					{
						unresolvedCartridgeChromatographyType,
						unresolvedCartridgePackingType,
						unresolvedCartridgeMinFlowRate,
						unresolvedCartridgeMaxFlowRate
					}=Lookup[
						unresolvedCartridgeModelPacket,
						{ChromatographyType,PackingType,MinFlowRate,MaxFlowRate},
						Null
					];

					(* Flip an error switch if Cartridge is specified and the resolved LoadingType is not Solid  *)
					incompatibleCartridgeLoadingTypeError=And[
						MatchQ[unresolvedCartridge,ObjectP[{Model[Container,ExtractionCartridge],Object[Container,ExtractionCartridge]}]],
						!MatchQ[loadingType,Solid]
					];

					(* Flip an error switch if Cartridge is specified and its Model's ChromatographyType is not Flash *)
					incompatibleCartridgeTypeError=And[
						MatchQ[unresolvedCartridge,ObjectP[{Model[Container,ExtractionCartridge],Object[Container,ExtractionCartridge]}]],
						!MatchQ[unresolvedCartridgeChromatographyType,Flash]
					];

					(* Flip an error switch if Cartridge is specified and its Model's PackingType is not Prepacked or HandPacked *)
					incompatibleCartridgePackingTypeError=And[
						MatchQ[unresolvedCartridge,ObjectP[{Model[Container,ExtractionCartridge],Object[Container,ExtractionCartridge]}]],
						!MatchQ[unresolvedCartridgePackingType,CartridgePackingTypeP]
					];

					(* Flip an error switch if Cartridge is specified and there is no overlap between the cartridge and
					instrument min/max flow rate intervals *)
					incompatibleCartridgeAndInstrumentFlowRateError=And[
						MatchQ[unresolvedCartridge,ObjectP[{Model[Container,ExtractionCartridge],Object[Container,ExtractionCartridge]}]],
						!MatchQ[
							IntervalIntersection[
								Interval[{unresolvedCartridgeMinFlowRate,unresolvedCartridgeMaxFlowRate}],
								Interval[{resolvedInstrumentMinFlowRate,resolvedInstrumentMaxFlowRate}]
							],
							Quantity[Interval[{NumberP,NumberP}],_]
						]
					];

					(* Flip an error switch if Cartridge is specified and there is no overlap between the cartridge and
					column min/max flow rate intervals *)
					incompatibleCartridgeAndColumnFlowRateError=And[
						MatchQ[unresolvedCartridge,ObjectP[{Model[Container,ExtractionCartridge],Object[Container,ExtractionCartridge]}]],
						!MatchQ[
							IntervalIntersection[
								Interval[{unresolvedCartridgeMinFlowRate,unresolvedCartridgeMaxFlowRate}],
								Interval[{columnMinFlowRate,columnMaxFlowRate}]
							],
							Quantity[Interval[{NumberP,NumberP}],_]
						]
					];

					(* Select a preferred Model of Prepacked cartridge to use if Cartridge is Automatic and LoadingType is Solid *)
					(* Based on the SeparationMode and the size of the resolved column *)
					(*@formatter:off*)
					preferredCartridge=Switch[{resolvedSeparationMode,columnBedWeight},
						{ReversePhase,LessEqualP[10 Gram]}, Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Prepacked with 5g C18"],
						{ReversePhase,LessEqualP[20 Gram]}, Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 12g C18"],
						{ReversePhase,_},                   Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 25g C18"],
						{_,LessEqualP[10 Gram]},            Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Prepacked with 5g Silica"],
						{_,LessEqualP[20 Gram]},            Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 12g Silica"],
						{_,LessEqualP[30 Gram]},            Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 25g Silica"],
						{_,LessEqualP[45 Gram]},            Model[Container,ExtractionCartridge,"RediSep 65g Solid Load Cartridge Prepacked with 32g Silica"],
						{_,_},                              Model[Container,ExtractionCartridge,"RediSep 65g Solid Load Cartridge Prepacked with 65g Silica"]
					];
					(*@formatter:on*)

					(* Resolve Cartridge *)
					cartridge=Switch[{unresolvedCartridge,loadingType},

						(*If Cartridge is Automatic and LoadingType is Solid, resolve to the preferred cartridge *)
						{Automatic,Solid},preferredCartridge,

						(* If Cartridge is Automatic and LoadingType is not Solid, resolve to Null *)
						{Automatic,_},Null,

						(* If LoadingAmount is specified, resolve to the specified value *)
						{_,_},unresolvedCartridge
					];

					(* Get the packet of the Model of the resolved Cartridge *)
					cartridgeModelPacket=fetchModelPacketFromFastAssoc[cartridge,fastAssoc];

					(* Lookup the necessary fields from the resolved cartridge's model packet *)
					{
						cartridgeLength,
						cartridgeSeparationMode,
						cartridgePackingMaterialField,
						cartridgeFunctionalGroupField,
						cartridgeBedWeight,
						cartridgeMaxBedWeight,
						cartridgePackingType,
						cartridgeMinFlowRate,
						cartridgeMaxFlowRate,
						cartridgeChromatographyType
					}=Lookup[
						cartridgeModelPacket,
						{
							CartridgeLength,SeparationMode,PackingMaterial,FunctionalGroup,BedWeight,MaxBedWeight,
							PackingType,MinFlowRate,MaxFlowRate,ChromatographyType
						},
						Null
					];
					(* Namespace note: Above I append Field to cartridgePackingMaterialField and cartridgeFunctionalGroupField
					to distinguish them from cartridgePackingMaterial and cartridgeFunctionalGroup which are used for the
					resolved CartridgePackingMaterial and CartridgeFunctionalGroup options inside the MapThread *)

					(* Set a Boolean to indicate whether cartridge resolved to a cartridge Object or Model (rather than to Null) *)
					cartridgeQ=MatchQ[cartridge,ObjectP[{Model[Container,ExtractionCartridge],Object[Container,ExtractionCartridge]}]];

					(* Flip an error switch if there is a resolved Cartridge of ChromatographyType Flash and it doesn't
					have a MaxBedWeight of 5, 25, or 65 Gram (this is necessary for resource picking for the cartridge cap,
					frits, and plunger) *)
					invalidCartridgeMaxBedWeightError=And[
						cartridgeQ,
						MatchQ[cartridgeChromatographyType,Flash],
						!MatchQ[cartridgeMaxBedWeight,EqualP[5. Gram]|EqualP[25. Gram]|EqualP[65. Gram]]
					];

					(* Calculate the total length of the injection assembly *)
					injectionAssemblyLength=Total[{
						columnLength,
						If[cartridgeQ,cartridgeLength,0 Millimeter],
						resolvedInstrumentInjectionValveLength
					}];

					(* Flip an error switch if the injection assembly length can't be determined, or if the injection
					assembly is longer than the instrument's MaxInjectionAssemblyLength *)
					incompatibleInjectionAssemblyLengthError=Or[
						!DistanceQ[injectionAssemblyLength],
						injectionAssemblyLength>resolvedInstrumentMaxInjectionAssemblyLength
					];

					(* Flip a warning switch if there is a resolved Prepacked cartridge and any of the column and cartridge
					SeparationMode, PackingMaterial, and FunctionalGroup fields don't match *)
					mismatchedColumnAndPrepackedCartridgeWarning=And[
						cartridgeQ,
						MatchQ[cartridgePackingType,Prepacked],
						Or[
							!MatchQ[cartridgeSeparationMode,columnSeparationMode],
							!MatchQ[cartridgePackingMaterialField,columnPackingMaterial],
							!MatchQ[cartridgeFunctionalGroupField,columnFunctionalGroup]
						]
					];

					(*-- CartridgePackingMaterial --*)

					(* Flip an error switch if there is a resolved cartridge, it does not have PackingType HandPacked,
					and CartridgePackingMaterial is specified *)
					invalidCartridgePackingMaterialError=And[
						cartridgeQ,
						!MatchQ[cartridgePackingType,HandPacked],
						MatchQ[unresolvedCartridgePackingMaterial,ColumnPackingMaterialP]
					];

					(* Resolve CartridgePackingMaterial *)
					cartridgePackingMaterial=Switch[{unresolvedCartridgePackingMaterial,cartridgeQ,cartridgePackingType},

						(* If CartridgePackingMaterial is unspecified, there is a resolved cartridge, and the cartridge's
						PackingType is Prepacked, resolve to the cartridge's PackingMaterial field *)
						{Automatic,True,Prepacked},cartridgePackingMaterialField,

						(* If CartridgePackingMaterial is unspecified, there is a resolved cartridge, and the cartridge's
						PackingType is not Prepacked, resolve to Silica *)
						{Automatic,True,_},Silica,

						(* If CartridgePackingMaterial is unspecified and there is not a resolved cartridge (cartridge is Null),
						resolve to Null *)
						{Automatic,_,_},Null,

						(* If CartridgePackingMaterial is specified, resolve to the specified value *)
						{_,_,_},unresolvedCartridgePackingMaterial
					];

					(*-- CartridgeFunctionalGroup --*)

					(* Flip an error switch if there is a resolved cartridge, it does not have PackingType HandPacked,
					and CartridgeFunctionalGroup is specified *)
					invalidCartridgeFunctionalGroupError=And[
						cartridgeQ,
						!MatchQ[cartridgePackingType,HandPacked],
						MatchQ[unresolvedCartridgeFunctionalGroup,ColumnFunctionalGroupP]
					];

					(* Resolve CartridgeFunctionalGroup *)
					cartridgeFunctionalGroup=Switch[{unresolvedCartridgeFunctionalGroup,cartridgeQ,cartridgePackingType,resolvedSeparationMode},

						(* If CartridgeFunctionalGroup is unspecified, there is a resolved cartridge, and the cartridge's
						PackingType is Prepacked, resolve to the cartridge's FunctionalGroup field *)
						{Automatic,True,Prepacked,_},cartridgeFunctionalGroupField,

						(* If CartridgeFunctionalGroup is unspecified, there is a resolved cartridge, the cartridge's
						PackingType is not Prepacked, and the resolved SeparationMode is ReversePhase, resolve to C18 *)
						{Automatic,True,_,ReversePhase},C18,

						(* If CartridgeFunctionalGroup is unspecified, there is a resolved cartridge, the cartridge's
						PackingType is not Prepacked, and the resolved SeparationMode is not ReversePhase, resolve to Null *)
						{Automatic,True,_,_},Null,

						(* If CartridgeFunctionalGroup is unspecified and there is not a resolved cartridge (cartridge is Null),
						resolve to Null *)
						{Automatic,_,_,_},Null,

						(* If CartridgeFunctionalGroup is specified, resolve to the specified value *)
						{_,_,_,_},unresolvedCartridgeFunctionalGroup
					];

					(* Flip a warning switch if there is a resolved cartridge and either of the column's PackingMaterial and
					FunctionalGroup fields don't match the resolved CartridgePackingMaterial and CartridgeFunctionalGroup options *)
					mismatchedColumnAndCartridgeWarning=And[
						cartridgeQ,
						Or[
							!MatchQ[cartridgePackingMaterial,columnPackingMaterial],
							!MatchQ[cartridgeFunctionalGroup,columnFunctionalGroup]
						]
					];

					(*-- CartridgePackingMass --*)

					(* Flip an error switch if there is a resolved cartridge, it does not have PackingType HandPacked,
					and CartridgePackingMass is specified *)
					invalidCartridgePackingMassError=And[
						cartridgeQ,
						!MatchQ[cartridgePackingType,HandPacked],
						MatchQ[unresolvedCartridgePackingMass,MassP]
					];

					(* Flip an error switch if there is a resolved cartridge, CartridgePackingMass is specified, and
					CartridgePackingMass is greater than the cartridge's MaxBedWeight *)
					tooHighCartridgePackingMassError=And[
						cartridgeQ,
						MatchQ[unresolvedCartridgePackingMass,MassP],
						MatchQ[cartridgeMaxBedWeight,MassP],
						unresolvedCartridgePackingMass>cartridgeMaxBedWeight
					];

					(* Resolve CartridgePackingMass *)
					cartridgePackingMass=Switch[{unresolvedCartridgePackingMass,cartridgeQ,cartridgePackingType,columnBedWeight,cartridgeMaxBedWeight},

						(* If CartridgePackingMass is unspecified, there is a resolved cartridge, and the cartridge's
						PackingType is Prepacked, resolve to the cartridge's BedWeight field *)
						{Automatic,True,Prepacked,_,_},cartridgeBedWeight,

						(* If CartridgePackingMass is unspecified, there is a resolved cartridge, the cartridge's
						PackingType is not Prepacked, and both the column's BedWeight field and the cartridge's MaxBedWeight
						field are informed, resolve to whichever of those two fields is smaller *)
						{Automatic,True,_,MassP,MassP},Min[columnBedWeight,cartridgeMaxBedWeight],

						(* If the above is true, but the column's BedWeight field and/or the cartridge's MaxBedWeight field are
						not informed, then Error::IncompatibleColumnType and/or Error::IncompatibleCartridgeType were thrown above.
						Resolve to Null. *)
						{Automatic,True,_,_,_},Null,

						(* If CartridgePackingMass is unspecified and there is not a resolved cartridge (cartridge is Null),
						resolve to Null *)
						{Automatic,_,_,_,_},Null,

						(* If CartridgePackingMass is specified, resolve to the specified value *)
						{_,_,_,_,_},unresolvedCartridgePackingMass
					];

					(* Flip an error switch if there is a resolved cartridge and the resolved CartridgePackingMass is
					less than loadingAmount * cartridgeLoadingFactor (2 Gram/Milliliter) *)
					(* Places an upper bound on the amount of liquid that can be loaded into a cartridge.
					The MaxVolume of the cartridge would be way too high.
					Require at least 2 Gram of packing material for each Milliliter of sample added. Maybe too conservative? *)
					(* TODO: calculate this better using the pore volume and interstitial volume factor of the packing material? *)
					tooLowCartridgePackingMassError=And[
						cartridgeQ,
						MatchQ[cartridgePackingMass,MassP],
						MatchQ[loadingAmountVolume,VolumeP],
						cartridgePackingMass<loadingAmountVolume*cartridgeLoadingFactor
					];

					(* Flip an error switch if there is a resolved cartridge, the cartridge's PackingType is HandPacked,
					and the resolved CartridgePackingMass is not within the interval of bed weights covered by the list
					of instrument-compatible cartridge caps *)
					invalidPackingMassForCartridgeCapsError=And[
						cartridgeQ,
						MatchQ[cartridgePackingType,HandPacked],
						!IntervalMemberQ[
							cartridgeCapBedWeightInterval,
							cartridgePackingMass
						]
					];

					(*-- CartridgeDryingTime --*)

					(* Resolve CartridgeDryingTime *)
					cartridgeDryingTime=Switch[{unresolvedCartridgeDryingTime,cartridgeQ},

						(* If CartridgeDryingTime is unspecified and there is a resolved cartridge, resolve to 0 Minute *)
						{Automatic,True},0 Minute,

						(* If CartridgeDryingTime is unspecified and there is not a resolved cartridge, resolve to Null *)
						{Automatic,_},Null,

						(* If CartridgeDryingTime is specified, resolve to the specified value *)
						{_,_},unresolvedCartridgeDryingTime
					];

					(*-- FlowRate --*)

					(* Resolve FlowRate *)
					flowRate=Switch[{unresolvedFlowRate,cartridgeQ,resolvedInstrumentMaxFlowRate,columnMaxFlowRate,cartridgeMaxFlowRate},

						(* If FlowRate is unspecified, and there is a resolved cartridge, resolve to the smallest of the
						MaxFlowRates of the Instrument, Column, and Cartridge *)
						{Automatic,True,FlowRateP,FlowRateP,FlowRateP},Min[resolvedInstrumentMaxFlowRate,columnMaxFlowRate,cartridgeMaxFlowRate],

						(* If FlowRate is unspecified, and there is not resolved cartridge, resolve to the smallest of the
						MaxFlowRates of the Instrument and the Column *)
						{Automatic,_,FlowRateP,FlowRateP,_},Min[resolvedInstrumentMaxFlowRate,columnMaxFlowRate],

						(* If any of the necessary flow rates aren't specified, an error was thrown above. Resolve to
						5 Milliliter/Minute (the minimum flow rate for the CombiFlash Rf 200) *)
						{Automatic,_,_,_,_},5 Milliliter/Minute,

						(* If FlowRate is specified, resolve to the specified value *)
						{_,_,_,_,_},unresolvedFlowRate
					];

					(* Determine the intersection of the MinFlowRate to MaxFlowRate intervals of the instrument, the column,
					and the cartridge (if there is a resolved cartridge) *)
					(* It seems like a Mathematica bug that IntervalIntersection doesn't evaluate if it has three
					Quantity[Interval[...]] as input, hence the Fold to do things pairwise*)
					flowRateInterval=Fold[IntervalIntersection,{
						Interval[{resolvedInstrumentMinFlowRate,resolvedInstrumentMaxFlowRate}],
						Interval[{columnMinFlowRate,columnMaxFlowRate}],
						If[cartridgeQ,Interval[{cartridgeMinFlowRate,cartridgeMaxFlowRate}],Nothing]
					}];

					(* Flip an error switch if the resolved FlowRate is not within the intersection of the flow rate
					ranges of the instrument, column and cartridge (if there is a resolved cartridge).
					Will also flip if any of the flow rate fields are not FlowRateP because IntervalMemberQ will return
					False if the IntervalIntersection call is unevaluated, i.e. if any inputs to it are Nulls instead of flow rates)
					Only flip this switch if none of the other incompatibleFlowRateErrors have already been flipped *)
					incompatibleFlowRateError=And[
						!IntervalMemberQ[flowRateInterval,flowRate],
						!Or[
							incompatibleColumnAndInstrumentFlowRateError,
							incompatibleCartridgeAndInstrumentFlowRateError,
							incompatibleCartridgeAndColumnFlowRateError
						]
					];

					(*-- PreSampleEquilibration --*)

					(* Flip an error switch if PreSampleEquilibration is specified and the resolved LoadingType is Preloaded
					(aka the specified LoadingType is Preloaded since we never resolve to Preloaded from Automatic) *)
					incompatiblePreSampleEquilibrationError=And[
						MatchQ[unresolvedPreSampleEquilibration,TimeP],
						MatchQ[loadingType,Preloaded]
					];

					(* Calculate the amount of time it takes for one column volume of buffer to pass through the column. *)
					(* We this to be a time to get through the resolver, so if columnVoidVolume is Null (only the case if
					the column is not ChromatographyType->Flash and so Error::IncompatibleColumnType was thrown above),
					we default to 1 Minute. At this stage, flowRate is always FlowRateP (Milliliter/Minute).
					If this is changed, we must also change the equivalent line in exportPeakTrak and importPeakTrak *)
					columnTime=If[MatchQ[columnVoidVolume,VolumeP],
						columnVoidVolume/flowRate,
						1 Minute
					];

					(* Resolve PreSampleEquilibration *)
					preSampleEquilibration=Switch[{unresolvedPreSampleEquilibration,loadingType,columnTime},

						(* If PreSampleEquilibration is unspecified and the resolved LoadingType is Preloaded,
						resolve to Null *)
						{Automatic,Preloaded,_},Null,

						(* If PreSampleEquilibration is unspecified and the resolved LoadingType is not Preloaded,
						resolve to 6 times columnTime *)
						{Automatic,_,TimeP},SafeRound[6*columnTime,timePrecision],

						(* ColumnTime will always be TimeP unless an error was thrown above because the column's Model's
						VoidVolume field isn't informed. Resolve to 1 Minute to keep going through the resolver. *)
						{Automatic,_,_},1 Minute,

						(* If PreSampleEquilibration is specified, resolve to the specified value *)
						{_,_,_},unresolvedPreSampleEquilibration
					];

					(*-- Gradient Shortcut Options --*)

					(* GradientStart, GradientEnd, GradientDuration, EquilibrationTime, and FlushTime default to Null rather
					than Automatic, so for all of them, the unresolved option will be returned at the bottom of the MapThread *)

					(* Set a Boolean to indicate whether any of the shortcut options are specified
					i.e. whether they are not all Null *)
					anyShortcutSpecifiedQ=!AllTrue[
						{
							unresolvedGradientStart,
							unresolvedGradientEnd,
							unresolvedGradientDuration,
							unresolvedEquilibrationTime,
							unresolvedFlushTime
						},
						NullQ
					];

					(* Set a Boolean to indicate whether any of the non-shortcut gradient options are specified
					i.e. whether they are not all Automatic *)
					anyNonShortcutSpecifiedQ=!AllTrue[
						{
							unresolvedGradient,
							unresolvedGradientA,
							unresolvedGradientB
						},
						MatchQ[Automatic]
					];

					(* Set a Boolean to indicate whether all of the essential shortcut options (GradientStart,
					GradientEnd, and GradientDuration) are specified
					i.e. whether none of them are Null *)
					allEssentialShortcutsSpecifiedQ=NoneTrue[
						{
							unresolvedGradientStart,
							unresolvedGradientEnd,
							unresolvedGradientDuration
						},
						NullQ
					];

					(* Flip an error switch if any of the gradient shortcut options are specified and all of GradientStart,
					GradientEnd, and GradientDuration are not specified*)
					incompleteGradientShortcutError=And[
						anyShortcutSpecifiedQ,
						!allEssentialShortcutsSpecifiedQ
					];

					(* The unresolved options will be returned at the end of the MapThread, but here are temporary versions
					to construct the shortcut gradient *)
					gradientStart=unresolvedGradientStart;
					gradientEnd=unresolvedGradientEnd;
					gradientDuration=unresolvedGradientDuration;
					equilibrationTime=If[TimeQ[unresolvedEquilibrationTime],unresolvedEquilibrationTime,0 Minute];
					flushTime=If[TimeQ[unresolvedFlushTime],unresolvedFlushTime,0 Minute];

					(* Flip an error switch if the gradient shortcut specification is complete but the total specified
					shortcut length is 0 Minute *)
					zeroGradientShortcutError=And[
						allEssentialShortcutsSpecifiedQ,
						equilibrationTime+gradientDuration+flushTime==0 Minute
					];

					(* Set a Boolean to indicate whether a shortcut gradient will be used.
					True if the shortcut specification is complete and no shortcut error switches were flipped *)
					gradientShortcutQ=And[
						allEssentialShortcutsSpecifiedQ,
						!redundantGradientShortcutError,
						!incompleteGradientShortcutError,
						!zeroGradientShortcutError
					];

					(* If we are using a shortcut gradient, create it from the shortcut options.
					Otherwise, set the shortcut gradient to Null *)
					shortcutGradientB=If[gradientShortcutQ,
						DeleteDuplicates[{
							{0 Minute,gradientStart},
							{equilibrationTime,gradientStart},
							{equilibrationTime+gradientDuration,gradientEnd},
							{equilibrationTime+gradientDuration+flushTime,gradientEnd}
						}],
						Null
					];

					(* Get the complement of the shortcut gradientB *)
					shortcutGradientBComplement=Replace[shortcutGradientB,percentB:PercentP:>100 Percent-percentB,{2}];

					(*-- GradientB, GradientA, and Gradient --*)

					(* Count the number of GradientB, GradientA, and Gradient that are specified *)
					numberOfSpecifiedGradientOptions=Count[
						{unresolvedGradientB,unresolvedGradientA,unresolvedGradient},
						Except[Automatic]
					];

					(* Set Booleans to indicate whether each gradient option is specified *)
					gradientASpecifiedQ=!MatchQ[unresolvedGradientA,Automatic];
					gradientBSpecifiedQ=!MatchQ[unresolvedGradientB,Automatic];
					gradientSpecifiedQ=!MatchQ[unresolvedGradient,Automatic];

					(* Get the complements of the unresolved GradientA and GradientB *)
					unresolvedGradientAComplement=Replace[unresolvedGradientA,percentA:PercentP:>100 Percent-percentA,{2}];
					unresolvedGradientBComplement=Replace[unresolvedGradientB,percentB:PercentP:>100 Percent-percentB,{2}];

					(* Set a Boolean to True if Gradient and GradientA are both specified and they do not specify the
					same gradient *)
					mismatchedGradientGradientA=And[
						gradientSpecifiedQ,
						gradientASpecifiedQ,
						!Equal[unresolvedGradient[[All,{1,2}]],unresolvedGradientA]
					];

					(* Set a Boolean to True if Gradient and GradientB are both specified and they do not specify the
					same gradient *)
					mismatchedGradientGradientB=And[
						gradientSpecifiedQ,
						gradientBSpecifiedQ,
						!Equal[unresolvedGradient[[All,{1,3}]],unresolvedGradientB]
					];

					(* Set a Boolean to True if GradientA and GradientB are both specified and they do not specify the
					same gradient *)
					mismatchedGradientAGradientB=And[
						gradientASpecifiedQ,
						gradientBSpecifiedQ,
						!Equal[unresolvedGradientA,unresolvedGradientBComplement]
					];

					(* Flip an error switch if more than one of GradientB, GradientA, and Gradient are specified and any
					subset of the specified Gradients do not match each other *)
					redundantGradientSpecificationError=And[
						numberOfSpecifiedGradientOptions>1,
						Or[mismatchedGradientGradientA,mismatchedGradientGradientB,mismatchedGradientAGradientB]
					];

					(* Set a Boolean to True if GradientA is specified and it doesn't match the shortcut gradient *)
					mismatchedShortcutGradientA=And[
						gradientASpecifiedQ,
						!Equal[unresolvedGradientA,shortcutGradientBComplement]
					];

					(* Set a Boolean to True if GradientB is specified and it doesn't match the shortcut gradient *)
					mismatchedShortcutGradientB=And[
						gradientBSpecifiedQ,
						!Equal[unresolvedGradientB,shortcutGradientB]
					];

					(* Set a Boolean to True if Gradient is specified and it doesn't match the shortcut gradient *)
					mismatchedShortcutGradient=And[
						gradientSpecifiedQ,
						!Equal[unresolvedGradient[[All,{1,3}]],shortcutGradientB]
					];

					(* Flip an error switch if any of the shortcut gradient options are specified and any of the
					non-shortcut gradient options are specified and don't match the shortcut *)
					redundantGradientShortcutError=And[
						anyShortcutSpecifiedQ,
						anyNonShortcutSpecifiedQ,
						Or[mismatchedShortcutGradientA,mismatchedShortcutGradientB,mismatchedShortcutGradient]
					];

					(* Get the times and invalid time errors of the unresolved gradients by mapping over the three
					options: GradientB, GradientA, and Gradient *)
					{
						{unresolvedGradientBTime,invalidGradientBTimeError},
						{unresolvedGradientATime,invalidGradientATimeError},
						{unresolvedGradientTime,invalidGradientTimeError}
					}=Map[
						Function[{unresolvedGradientOption},
							Module[{time,invalidTimeError},

								(* Get a list of the times from the specified gradient option *)
								time=If[MatchQ[unresolvedGradientOption,Automatic],
									{},
									unresolvedGradientOption[[All,1]]
								];

								(* Flip an error switch if the gradient option is specified and
									the times do not start at 0 minutes,
									or the times do not end at greater than 0 minutes,
									or the times do not monotonically increase *)
								invalidTimeError=And[
									!MatchQ[unresolvedGradientOption,Automatic],
									Or[
										First[time]!=0 Minute,
										Last[time]<=0 Minute,
										!AllTrue[
											Differences[time],
											GreaterEqualThan[0 Minute]
										]
									]
								];

								(* Return the list of times and the invalidTimeError for the specified gradient option *)
								{time,invalidTimeError}
							]
						],
						{unresolvedGradientB,unresolvedGradientA,unresolvedGradient}
					];

					(*-- GradientB --*)

					(* If BufferB is methanol, the max default gradient B percent should be 50%, otherwise use 100% *)
					maxDefaultGradientBPercent=If[MatchQ[resolvedBufferBModel,ObjectP[Model[Sample,"Methanol"]]],
						50 Percent,
						100 Percent
					];

					(* Calculate the default GradientB to use if there is no GradientB, GradientA, Gradient, or gradient
					shortcut specified *)
					defaultGradientB=Module[{
						columnC18Q,volumeFactor,low,ramp,high,final,roundedLow,roundedRamp,roundedHigh,roundedFinal},

						(* Set a Boolean to indicate if the column is C18, C8, or C18Aq *)
						columnC18Q=MatchQ[columnFunctionalGroup,C18|C8|C18Aq];

						(* Set a volume factor based on the column's BedWeight. For large columns this is close to 1,
						for smaller columns, we use more CVs.
						TODO: Is this really necessary? Doing it here because the CombiFlash default protocols do it.
						TODO: Cleaner explanation of how the default gradient is selected if volumeFactor=1 *)
						(* Need this to be a unitless number, so if columnBedWeight is not MassP (only the case if the column is
						not ChromatographyType->Flash and so Error::IncompatibleColumnType was thrown above), we default to 1 *)
						volumeFactor=If[MatchQ[columnBedWeight,MassP],
							55.5361 Gram^2/columnBedWeight^2+1,
							1
						];

						(* Set the length of time to flow buffer through the column at 0% BufferB before the start of the
						ramp. Based on the volumeFactor times the length of time it takes one CV (one VoidVolume) to flow
						through the column. (low ~= 1CV when volumeFactor ~= 1 *)
						low=volumeFactor*columnTime;

						(* The length of time to spend ramping from 0% to 100% BufferB is low*12 (~12 CV when volumeFactor~=1)
						So the time until ramping is finished is low+low*12 *)
						ramp=low+low*12;

						(* The length of time to hold at 100% BufferB after the end of the ramp is low*2 *)
						high=ramp+low*2;

						(* The length of time to hold at 0% BufferB (or 50% BufferB for C18 or C8 columns) at the end of
						the gradient is low*1 (or low*2 for C18 or C8 columns) *)
						final=high+low*If[columnC18Q,2,1];

						(* Round the calculated time values.
						Must round to the same precision as in the roundGradientOptions call *)
						{
							roundedLow,
							roundedRamp,
							roundedHigh,
							roundedFinal
						}=SafeRound[{low,ramp,high,final},timePrecision];

						(* Return the BufferB gradient constructed from these values *)
						{
							{0 Minute,0 Percent},
							{roundedLow,0 Percent},
							{roundedRamp,maxDefaultGradientBPercent},
							{roundedHigh,maxDefaultGradientBPercent},
							{roundedHigh,If[columnC18Q,50,0] Percent},
							{roundedFinal,If[columnC18Q,50,0] Percent}
						}
					];

					(* Resolve GradientB *)
					gradientB=Switch[{unresolvedGradientB,unresolvedGradientA,unresolvedGradient,gradientShortcutQ},

						(* If GradientB, GradientA, and Gradient are unspecified and we are not using a shortcut,
						resolve to the default gradient *)
						{Automatic,Automatic,Automatic,False},defaultGradientB,

						(* If GradientB, GradientA, and Gradient are unspecified and we are using a shortcut,
						resolve to the gradient B shortcut *)
						{Automatic,Automatic,Automatic,_},shortcutGradientB,

						(* If GradientB and GradientA are unspecified and Gradient is specified,
						resolve to the gradient B part of Gradient *)
						{Automatic,Automatic,_,_},unresolvedGradient[[All,{1,3}]],

						(* If GradientB is unspecified and GradientA is specified,
						resolve to the complement of the specified GradientA *)
						{Automatic,_,_,_},unresolvedGradientAComplement,

						(* If GradientB is specified, resolve to the specified value *)
						{_,_,_,_},unresolvedGradientB
					];

					(*-- GradientA --*)

					(* Resolve GradientA *)
					gradientA=Switch[unresolvedGradientA,
						(* If GradientA is unspecified, resolve to the complement of the resolved GradientB *)
						Automatic,Replace[gradientB,percentB:PercentP:>100 Percent-percentB,{2}],

						(* If GradientA is specified, resolve to the specified value *)
						_,unresolvedGradientA
					];

					(*-- Gradient --*)

					(* Get the resolved times of GradientB and GradientA *)
					gradientBTime=gradientB[[All,1]];
					gradientATime=gradientA[[All,1]];

					(* Set a Boolean to indicate whether the times of the resolved GradientB and GradientA are equal *)
					gradientTimeEqualQ=Equal[gradientBTime,gradientATime];

					(* Get the resolved percents of GradientB and GradientA *)
					gradientBPercent=gradientB[[All,2]];
					gradientAPercent=gradientA[[All,2]];

					(* Get the complement of the resolved percents of GradientB *)
					gradientBPercentComplement=100 Percent-gradientBPercent;

					(* Resolve Gradient *)
					gradient=Switch[{unresolvedGradient,gradientTimeEqualQ},

						(* If Gradient is unspecified and the times of the resolved GradientB and GradientA are equal,
						resolve to the combination of the resolved GradientB and GradientA *)
						{Automatic,True},MapThread[{#1,#2,#3}&,{gradientBTime,gradientAPercent,gradientBPercent}],

						(* If Gradient is unspecified and the times of the resolved GradientB and GradientA are not equal,
						resolve to the gradient specified by the resolved GradientB *)
						(* Only the case when GradientB and GradientA are specified (Error::RedundantGradientSpecification),
						or when a shortcut gradient and GradientA are specified (Error::RedundantGradientShortcut) *)
						{Automatic,_},MapThread[{#1,#2,#3}&,{gradientBTime,gradientBPercentComplement,gradientBPercent}],

						(* If Gradient is specified, resolve to the specified value *)
						{_,_},unresolvedGradient
					];

					(* Will use GradientB for all subsequent resolution that needs a gradient.
					If GradientB doesn't match the other gradients, an error was thrown above. *)

					(* Get the total length of the gradient (the time of the final element of the gradient) *)
					totalGradientBTime=Last[gradientBTime];

					(* Flip an error switch if the total gradient time is greater than the max time allowed *)
					invalidTotalGradientTimeError=TrueQ[totalGradientBTime>$MaxFlashChromatographyGradientTime];

					(* Get the maximum BufferB percentage of the gradient *)
					maxBufferBPercent=Max[gradientBPercent];

					(* Flip a warning if BufferB is methanol, the column or cartridge's packing material is silica,
					and the max BufferB percentage of the gradient is greater than 50% *)
					methanolPercentWarning=And[
						Or[MatchQ[columnPackingMaterial,Silica],MatchQ[cartridgePackingMaterial,Silica]],
						MatchQ[resolvedBufferBModel,ObjectP[Model[Sample,"Methanol"]]],
						maxBufferBPercent>50 Percent
					];

					(*-- CollectFractions --*)

					(* Defaults to True, not Automatic. So can only be True or False. *)

					(* Get a list of fraction collection-related options*)
					fractionOptions={
						unresolvedFractionCollectionStartTime,
						unresolvedFractionCollectionEndTime,
						unresolvedFractionContainer,
						unresolvedMaxFractionVolume,
						unresolvedFractionCollectionMode
					};

					(* Are any fraction collection-related options specified? (to something non-Null) *)
					fractionOptionsSpecifiedQ=MemberQ[fractionOptions,Except[Null|Automatic]];

					(* Are any fraction collection-related options Null? *)
					fractionOptionsNullQ=MemberQ[fractionOptions,Null];

					(* Flip an error switch if CollectFractions is True and any fraction collection-related options are Null *)
					invalidFractionCollectionOptionsError=And[
						TrueQ[unresolvedCollectFractions],
						fractionOptionsNullQ
					];

					(* Flip an error switch if CollectFractions is False and any fraction collection-related options are specified *)
					invalidCollectFractionsError=And[
						!TrueQ[unresolvedCollectFractions],
						fractionOptionsSpecifiedQ
					];

					(* Flip an error switch if any fraction collection-related option is Null and any other is specified *)
					mismatchedFractionCollectionOptionsError=And[
						fractionOptionsNullQ,
						fractionOptionsSpecifiedQ
					];

					(* Resolve CollectFractions *)
					collectFractions=unresolvedCollectFractions;

					(*-- FractionCollectionStartTime --*)

					(* Flip an error switch if FractionCollectionStartTime is specified and it is greater than or equal
					to totalGradientBTime *)
					invalidFractionCollectionStartTimeError=And[
						MatchQ[unresolvedFractionCollectionStartTime,TimeP],
						unresolvedFractionCollectionStartTime>=totalGradientBTime
					];

					(* Resolve FractionCollectionStartTime *)
					fractionCollectionStartTime=Switch[{unresolvedFractionCollectionStartTime,collectFractions},

						(* If FractionCollectionStartTime is unspecified and CollectFractions is True, resolve to 0 Minute *)
						{Automatic,True},0 Minute,

						(* If FractionCollectionStartTime is unspecified and CollectFractions is False, resolve to Null *)
						{Automatic,_},Null,

						(* If FractionCollectionStartTime is specified, resolve to the specified value *)
						{_,_},unresolvedFractionCollectionStartTime
					];

					(*-- FractionCollectionEndTime --*)

					(* Flip an error switch if FractionCollectionEndTime is specified and it is less than or equal to the
					resolved FractionCollectionStartTime or greater than the totalGradientBTime *)
					invalidFractionCollectionEndTimeError=And[
						MatchQ[unresolvedFractionCollectionEndTime,TimeP],
						Or[
							unresolvedFractionCollectionEndTime<=fractionCollectionStartTime,
							unresolvedFractionCollectionEndTime>totalGradientBTime
						]
					];

					(* Resolve FractionCollectionEndTime *)
					fractionCollectionEndTime=Switch[{unresolvedFractionCollectionEndTime,collectFractions},

						(* If FractionCollectionEndTime is unspecified and CollectFractions is True,
						resolve to the total length of GradientB *)
						{Automatic,True},totalGradientBTime,

						(* If FractionCollectionEndTime is unspecified and CollectFractions is False, resolve to Null *)
						{Automatic,_},Null,

						(* If FractionCollectionEndTime is specified, resolve to the specified value *)
						{_,_},unresolvedFractionCollectionEndTime
					];

					(*-- FractionContainer --*)

					(* Flip an error switch if FractionContainer is specified and it isn't in the list of allowed containers *)
					invalidFractionContainerError=And[
						MatchQ[unresolvedFractionContainer,ObjectP[Model[Container,Vessel]]],
						!MemberQ[defaultContainers,unresolvedFractionContainer]
					];

					(* Generate a list of Booleans indicating whether for each default fraction collection container,
					80% of its MaxVolume is greater than or equal to the specified MaxFractionVolume
					All False if MaxFractionVolume is unspecified, or if none of the default fraction collection containers
					are big enough to hold the specified MaxFractionVolume *)
					possibleContainerBools=Map[
						TrueQ[#>=unresolvedMaxFractionVolume]&,
						defaultContainerMaxVolumes*fractionOfMaxVolume
					];

					(* Get a list of the default containers that are large enough for the specified MaxFractionVolume *)
					(* If MaxFractionVolume is unspecified, or if none of the default containers are big enough to hold
					the specified MaxFractionVolume, this is an empty list *)
					possibleContainers=PickList[defaultContainers,possibleContainerBools];

					(* Get the number of default fraction collection containers that are large enough for the specified
					MaxFractionVolume *)
					numberOfPossibleContainers=Length[possibleContainers];

					(* Get a list of the MaxVolumes of the possibleContainers *)
					possibleContainerMaxVolumes=PickList[defaultContainerMaxVolumes,possibleContainerBools];

					(* Get the elements of possibleContainers with the smallest MaxVolume *)
					smallestPossibleContainers=PickList[
						possibleContainers,
						possibleContainerMaxVolumes,
						Min[possibleContainerMaxVolumes]
					];

					(* If the list of smallestPossibleContainers includes Model[Container,Vessel,"15mL Tube"],
					then default to it, otherwise use the first element of the list (or Null if it is {}) *)
					smallestPossibleContainer=If[
						MemberQ[smallestPossibleContainers,ObjectP[Model[Container,Vessel,"id:xRO9n3vk11pw"]]],
						Model[Container,Vessel,"id:xRO9n3vk11pw"],
						FirstOrDefault[smallestPossibleContainers]
					];

					(* Resolve FractionContainer *)
					fractionContainer=Switch[{unresolvedFractionContainer,collectFractions,unresolvedMaxFractionVolume,numberOfPossibleContainers},

						(* If FractionContainer is unspecified, CollectFractions is True and MaxFractionVolume is unspecified,
						resolve to a default tube model *)
						{Automatic,True,Automatic,_},Model[Container,Vessel,"id:xRO9n3vk11pw"],(*Model[Container,Vessel,"15mL Tube"]*)

						(* If FractionContainer is unspecified, CollectFractions is True, MaxFractionVolume is specified,
						and there are fraction collection containers from the default list large enough to hold MaxFractionVolume,
						resolve to the smallest such container *)
						{Automatic,True,VolumeP,GreaterP[0]},smallestPossibleContainer,

						(* If FractionContainer is unspecified, CollectFractions is True, MaxFractionVolume is specified,
						and there aren't any fraction collection containers from the default list large enough to hold
						MaxFractionVolume, resolve to the largest container from the default list. An error switch
						(invalidMaxFractionVolume) will be flipped below. The resolved container will be used to populate
						the error message and for later parts of the resolver that need a fraction collection container. *)
						{Automatic,True,_,_},largestDefaultContainer,

						(* If FractionContainer is unspecified and CollectFractions is False, resolve to Null *)
						{Automatic,_,_,_},Null,

						(* If FractionContainer is specified, resolve to the specified value *)
						{_,_,_,_},unresolvedFractionContainer
					];

					(*-- MaxFractionVolume --*)

					(* Get the packet of the Model of the resolved fraction collection container *)
					containerModelPacket=fetchModelPacketFromFastAssoc[fractionContainer,fastAssoc];

					(* Lookup the necessary fields from the resolved fraction collection container's model packet *)
					{
						containerMaxVolume
					}=Lookup[containerModelPacket,{MaxVolume},Null];

					(* Flip an error switch if MaxFractionVolume is specified, 80% of the resolved FractionContainer's
					MaxVolume is less than the specified MaxFractionVolume, and FractionContainer is specified *)
					invalidMaxFractionVolumeForContainerError=And[
						MatchQ[unresolvedMaxFractionVolume,VolumeP],
						fractionOfMaxVolume*containerMaxVolume<unresolvedMaxFractionVolume,
						MatchQ[unresolvedFractionContainer,ObjectP[Model[Container,Vessel]]]
					];

					(* Flip an error switch if MaxFractionVolume is specified, 80% of the resolved FractionContainer's
					MaxVolume is less than the specified MaxFractionVolume, and FractionContainer is unspecified *)
					invalidMaxFractionVolumeError=And[
						MatchQ[unresolvedMaxFractionVolume,VolumeP],
						fractionOfMaxVolume*containerMaxVolume<unresolvedMaxFractionVolume,
						MatchQ[unresolvedFractionContainer,Automatic]
					];

					(* Resolve MaxFractionVolume *)
					maxFractionVolume=Switch[{unresolvedMaxFractionVolume,collectFractions,fractionContainer},

						(* If MaxFractionVolume is unspecified, CollectFractions is True, and the resolved FractionContainer
						is a Model[Container,Vessel], resolve to 80% of the resolved fraction collection container's MaxVolume *)
						{Automatic,True,ObjectP[Model[Container,Vessel]]},SafeRound[fractionOfMaxVolume*containerMaxVolume,volumePrecision],

						(* If MaxFractionVolume is unspecified, CollectFractions is True, and the resolved FractionContainer
						is not a Model[Container,Vessel] (only the case when the user specified it to Null, so
						the invalidFractionCollectionOptionsError switch was thrown above), resolve to Null *)
						{Automatic,True,_},Null,

						(* If MaxFractionVolume is unspecified and CollectFractions is False,
						resolve to Null *)
						{Automatic,_,_},Null,

						(* If MaxFractionVolume is specified, resolve to the specified value *)
						{_,_,_},unresolvedMaxFractionVolume
					];

					(*-- FractionCollectionMode --*)

					(* Resolve FractionCollectionMode *)
					fractionCollectionMode=Switch[{unresolvedFractionCollectionMode,collectFractions},

						(* If FractionCollectionMode is unspecified and CollectFractions is True, resolve to Peaks *)
						{Automatic,True},Peaks,

						(* If FractionCollectionMode is unspecified and CollectFractions is False, resolve to Null *)
						{Automatic,_},Null,

						(* If FractionCollectionMode is specified, resolve to the specified value *)
						{_,_},unresolvedFractionCollectionMode
					];

					(*-- Detectors --*)
					(* Get a list of the detectors to be used *)
					detectorsList=If[MatchQ[unresolvedDetectors,All],
						{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
						unresolvedDetectors
					];

					(* Get a list of the values of the detector options *)
					unresolvedDetectorOptionValues={
						unresolvedPrimaryWavelength,unresolvedSecondaryWavelength,unresolvedWideRangeUV
					};

					(* Set a list of Booleans indicating whether each detector option is in detectorsList *)
					detectorOptionMemberQ={
						primaryWavelengthMemberQ,secondaryWavelengthMemberQ,wideRangeUVMemberQ
					}=Map[
						MemberQ[detectorsList,#]&,
						{PrimaryWavelength,SecondaryWavelength,WideRangeUV}
					];

					(* Flip an error switch if any of the detector options are specified and aren't in detectorsList *)
					invalidSpecifiedDetectorsError=Or@@MapThread[
						And[MatchQ[#1,DistanceP|Span[DistanceP,DistanceP]],!#2]&,
						{unresolvedDetectorOptionValues,detectorOptionMemberQ}
					];

					(* Flip an error switch if any of the detector options are Null and are in detectorsList *)
					invalidNullDetectorsError=Or@@MapThread[
						And[NullQ[#1],#2]&,
						{unresolvedDetectorOptionValues,detectorOptionMemberQ}
					];

					(* Resolve Detectors *)
					(* Detectors defaults to All, not Automatic, so there is no Automatic resolution *)
					detectors=unresolvedDetectors;

					(*-- PrimaryWavelength --*)

					(* Resolve PrimaryWavelength *)
					primaryWavelength=Switch[{unresolvedPrimaryWavelength,primaryWavelengthMemberQ},

						(* If PrimaryWavelength is unspecified and PrimaryWavelength is in the list of detectors,
						resolve to 254 Nanometer *)
						{Automatic,True},254 Nanometer,

						(* If PrimaryWavelength is unspecified and PrimaryWavelength is not in the list of detectors,
						resolve to Null *)
						{Automatic,_},Null,

						(* If PrimaryWavelength is specified, resolve to the specified value *)
						{_,_},unresolvedPrimaryWavelength
					];

					(*-- SecondaryWavelength --*)

					(* Resolve SecondaryWavelength *)
					secondaryWavelength=Switch[{unresolvedSecondaryWavelength,secondaryWavelengthMemberQ},

						(* If SecondaryWavelength is unspecified and SecondaryWavelength is in the list of detectors,
						resolve to 280 Nanometer *)
						{Automatic,True},280 Nanometer,

						(* If SecondaryWavelength is unspecified and SecondaryWavelength is not in the list of detectors,
						resolve to Null *)
						{Automatic,_},Null,

						(* If SecondaryWavelength is specified, resolve to the specified value *)
						{_,_},unresolvedSecondaryWavelength
					];

					(*-- WideRangeUV --*)

					(* Flip an error switch if WideRangeUV is specified to a Span and the first element of the Span is
					larger than the second *)
					invalidWideRangeUVError=And[
						MatchQ[unresolvedWideRangeUV,_Span],
						First[unresolvedWideRangeUV]>Last[unresolvedWideRangeUV]
					];

					(* Resolve WideRangeUV *)
					wideRangeUV=Switch[{unresolvedWideRangeUV,wideRangeUVMemberQ},

						(* If WideRangeUV is unspecified and WideRangeUV is in the list of detectors,
						resolve to All *)
						{Automatic,True},All,

						(* If WideRangeUV is unspecified and WideRangeUV is not in the list of detectors,
						resolve to Null *)
						{Automatic,_},Null,

						(* If WideRangeUV is specified, resolve to the specified value *)
						{_,_},unresolvedWideRangeUV
					];

					(*-- PeakDetectors --*)

					(* Ensure the unresolved PeakDetectors is in a list, necessary because it can be Null *)
					unresolvedPeakDetectorsList=ToList[unresolvedPeakDetectors];

					(* Flip an error switch if PeakDetectors is specified and detectorsList doesn't contain all elements
					of PeakDetectors *)
					missingPeakDetectorsError=And[
						MatchQ[unresolvedPeakDetectors,ListableP[PrimaryWavelength|SecondaryWavelength|WideRangeUV]],
						!ContainsAll[detectorsList,unresolvedPeakDetectorsList]
					];

					(* Set the preferred PeakDetectors *)
					(* We prefer to use PrimaryWavelength and/or SecondaryWavelength if they are present in detectorsList *)
					(* We will also use WideRangeUV if any WideRangeUV-related peak detection options are specified and
					WideRangeUV is present in detectorsList *)
					preferredPeakDetectors=Intersection[
						detectorsList,
						{
							PrimaryWavelength,
							SecondaryWavelength,
							If[
								Or[
									MatchQ[unresolvedWideRangeUVPeakDetectionMethod,ListableP[Slope|Threshold]],
									MatchQ[unresolvedWideRangeUVPeakWidth,FlashChromatographyPeakWidthP],
									MatchQ[unresolvedWideRangeUVPeakThreshold,AbsorbanceUnitP]
								],
								WideRangeUV,
								Nothing
							]
						}
					];

					(* Resolve PeakDetectors *)
					peakDetectors=Switch[{unresolvedPeakDetectors,preferredPeakDetectors},

						(* If PeakDetectors is unspecified and preferredPeakDetectors is an empty list,
						resolve to detectorsList (detectorsList can't be Null, so it must be {WideRangeUV} if it doesn't
						include PrimaryWavelength or SecondaryWavelength) *)
						{Automatic,{}},detectorsList,

						(* If PeakDetectors is unspecified and preferredPeakDetectors is not an empty list,
						resolve to the preferred peak detectors (whichever of PrimaryWavelength and SecondaryWavelength
						that are present in detectorsList plus WideRangeUV if it is present in detectorsList and any of
						the WideRangeUV peak detection-related options are specified) *)
						{Automatic,_},preferredPeakDetectors,

						(* If PeakDetectors is specified, resolve to the specified value *)
						{_,_},unresolvedPeakDetectors
					];

					(* Ensure the resolved PeakDetectors is in a list, necessary because it can be Null *)
					peakDetectorsList=ToList[peakDetectors];

					(*-- Peak Detector Options --*)

					(* PrimaryWavelengthPeakDetectionMethod, SecondaryWavelengthPeakDetectionMethod, WideRangeUVPeakDetectionMethod,
					PrimaryWavelengthPeakWidth, SecondaryWavelengthPeakWidth, WideRangeUVPeakWidth,
					PrimaryWavelengthPeakThreshold, SecondaryWavelengthPeakThreshold, and WideRangeUVPeakThreshold *)

					(* These options are resolved identically for each detector (PrimaryWavelength, SecondaryWavelength,
					and WideRangeUV), so we will MapThread over them *)

					(* Get a list of the unresolved PeakDetectionMethod options *)
					unresolvedPeakDetectionMethodsOptions={
						unresolvedPrimaryWavelengthPeakDetectionMethod,
						unresolvedSecondaryWavelengthPeakDetectionMethod,
						unresolvedWideRangeUVPeakDetectionMethod
					};

					(* Get a list of the unresolved PeakWidth options *)
					unresolvedPeakWidthsOptions={
						unresolvedPrimaryWavelengthPeakWidth,
						unresolvedSecondaryWavelengthPeakWidth,
						unresolvedWideRangeUVPeakWidth
					};

					(* Get a list of the unresolved PeakThreshold options *)
					unresolvedPeakThresholdsOptions={
						unresolvedPrimaryWavelengthPeakThreshold,
						unresolvedSecondaryWavelengthPeakThreshold,
						unresolvedWideRangeUVPeakThreshold
					};

					(* MapThread to resolve the peak detection options and collect peak detection option errors *)
					{
						(* The resolved PeakDetectionMethod options *)
						{
							primaryWavelengthPeakDetectionMethod,
							secondaryWavelengthPeakDetectionMethod,
							wideRangeUVPeakDetectionMethod
						},
						(* The resolved PeakWidth options *)
						{
							primaryWavelengthPeakWidth,
							secondaryWavelengthPeakWidth,
							wideRangeUVPeakWidth
						},
						(* The resolved PeakThreshold options *)
						{
							primaryWavelengthPeakThreshold,
							secondaryWavelengthPeakThreshold,
							wideRangeUVPeakThreshold
						},
						(* The invalidSpecifiedPeakDetection errors *)
						{
							invalidSpecifiedPrimaryWavelengthPeakDetectionError,
							invalidSpecifiedSecondaryWavelengthPeakDetectionError,
							invalidSpecifiedWideRangeUVPeakDetectionError
						},
						(* The invalidNullPeakDetectionMethod errors *)
						{
							invalidNullPrimaryWavelengthPeakDetectionMethodError,
							invalidNullSecondaryWavelengthPeakDetectionMethodError,
							invalidNullWideRangeUVPeakDetectionMethodError
						},
						(* The invalidNullPeakDetectionParameters errors *)
						{
							invalidNullPrimaryWavelengthPeakDetectionParametersError,
							invalidNullSecondaryWavelengthPeakDetectionParametersError,
							invalidNullWideRangeUVPeakDetectionParametersError
						},
						(* The invalidPeakWidth errors *)
						{
							invalidPrimaryWavelengthPeakWidthError,
							invalidSecondaryWavelengthPeakWidthError,
							invalidWideRangeUVPeakWidthError
						},
						(* The invalidPeakThreshold errors *)
						{
							invalidPrimaryWavelengthPeakThresholdError,
							invalidSecondaryWavelengthPeakThresholdError,
							invalidWideRangeUVPeakThresholdError
						}
					}=Transpose[
						MapThread[
							Function[{detector,unresolvedPeakDetectionMethod,unresolvedPeakWidth,unresolvedPeakThreshold},
								Module[
									{
										(* Resolved options *)
										peakDetectionMethod,peakWidth,peakThreshold,

										(* Error switches *)
										invalidSpecifiedPeakDetectionError,invalidNullPeakDetectionMethodError,
										invalidNullPeakDetectionParametersError,invalidPeakWidthError,invalidPeakThresholdError,

										(* Other variables *)
										peakDetectionOptions,peakDetectionOptionsSpecifiedQ,detectorMemberQ,
										slopeMemberQ,thresholdMemberQ
									},

									(* Initialize the error switches *)
									{
										invalidSpecifiedPeakDetectionError,
										invalidNullPeakDetectionMethodError,
										invalidNullPeakDetectionParametersError,
										invalidPeakWidthError,
										invalidPeakThresholdError
									}=ConstantArray[False,5];

									(*- Peak Detection Option Compatibility Checks -*)

									(* Get a list of the peak detection-related options for this detector *)
									peakDetectionOptions={
										unresolvedPeakDetectionMethod,
										unresolvedPeakWidth,
										unresolvedPeakThreshold
									};

									(* Are any of the peak detection-related options specified? (to something non-Null) *)
									peakDetectionOptionsSpecifiedQ=MemberQ[peakDetectionOptions,Except[Null|Automatic]];

									(* Is the detector in peakDetectorsList? *)
									detectorMemberQ=MemberQ[peakDetectorsList,detector];

									(* Flip an error switch if any peak detection-related option is specified
									and the detector is not in peakDetectorsList *)
									invalidSpecifiedPeakDetectionError=And[
										peakDetectionOptionsSpecifiedQ,
										!detectorMemberQ
									];

									(* Flip an error switch if PeakDetectionMethod is Null
									and the detector is in peakDetectorsList *)
									invalidNullPeakDetectionMethodError=And[
										NullQ[unresolvedPeakDetectionMethod],
										detectorMemberQ
									];

									(* Flip an error switch if both PeakWidth and PeakThreshold are Null
									and the detector is in peakDetectorsList *)
									invalidNullPeakDetectionParametersError=And[
										NullQ[unresolvedPeakWidth],
										NullQ[unresolvedPeakThreshold],
										detectorMemberQ
									];

									(*- PeakDetectionMethod -*)

									(* Resolve PeakDetectionMethod *)
									peakDetectionMethod=Switch[{unresolvedPeakDetectionMethod,detectorMemberQ,unresolvedPeakWidth,unresolvedPeakThreshold},

										(* If PeakDetectionMethod is Automatic, the detector is in PeakDetectors, PeakWidth
										is Automatic or specified, and PeakThreshold is specified, resolve to {Slope,Threshold} *)
										{Automatic,True,Automatic|FlashChromatographyPeakWidthP,AbsorbanceUnitP},{Slope,Threshold},

										(* If PeakDetectionMethod is Automatic, the detector is in PeakDetectors, PeakWidth
										is Automatic or specified, and PeakThreshold is Automatic or Null, resolve to {Slope} *)
										{Automatic,True,Automatic|FlashChromatographyPeakWidthP,Automatic|Null},{Slope},

										(* If PeakDetectionMethod is Automatic, the detector is in PeakDetectors,
										PeakWidth is Null, and PeakThreshold is specified or Automatic, resolve to {Threshold} *)
										{Automatic,True,Null,AbsorbanceUnitP|Automatic},{Threshold},

										(* Otherwise if PeakDetectionMethod is Automatic and the detector is in PeakDetectors,
										(and PeakWidth is Null and PeakThreshold is Null), resolve to Null *)
										{Automatic,True,_,_},Null,

										(* Otherwise if PeakDetectionMethod is Automatic (and the detector is not in PeakDetectors),
										resolve to Null *)
										{Automatic,_,_,_},Null,

										(* If PeakDetectionMethod is specified (or Null), resolve to the specified value *)
										{_,_,_,_},unresolvedPeakDetectionMethod
									];

									(*- PeakWidth -*)

									(* Does peakDetectionMethod include Slope? *)
									slopeMemberQ=MemberQ[peakDetectionMethod,Slope];

									(* Flip an error switch if PeakWidth is specified and peakDetectionMethod doesn't
									include Slope *)
									invalidPeakWidthError=And[
										MatchQ[unresolvedPeakWidth,FlashChromatographyPeakWidthP],
										!slopeMemberQ
									];

									(* Resolve PeakWidth *)
									peakWidth=Switch[{unresolvedPeakWidth,detectorMemberQ,slopeMemberQ},

										(* If PeakWidth is Automatic, the detector is in PeakDetectors, and Slope is in
										PeakDetectionMethod, resolve to 1 Minute *)
										{Automatic,True,True},1 Minute,

										(* If PeakWidth is Automatic, and either the detector is not in PeakDetectors,
										or Slope is not in PeakDetectionMethod, resolve to Null *)
										{Automatic,_,_},Null,

										(* If PeakWidth is specified (or Null), resolve to the specified value *)
										{_,_,_},unresolvedPeakWidth
									];

									(*- PeakThreshold -*)

									(* Does peakDetectionMethod include Slope? *)
									thresholdMemberQ=MemberQ[peakDetectionMethod,Threshold];

									(* Flip an error switch if PeakThreshold is specified and peakDetectionMethod doesn't
									include Threshold *)
									invalidPeakThresholdError=And[
										MatchQ[unresolvedPeakThreshold,AbsorbanceUnitP],
										!thresholdMemberQ
									];

									(* Resolve PeakThreshold *)
									peakThreshold=Switch[{unresolvedPeakThreshold,detectorMemberQ,thresholdMemberQ},

										(* If PeakThreshold is Automatic, the detector is in PeakDetectors, and Threshold
										is in PeakDetectionMethod, resolve to 200 MilliAbsorbanceUnit *)
										{Automatic,True,True},200 MilliAbsorbanceUnit,

										(* If PeakThreshold is Automatic, and either the detector is not in PeakDetectors,
										or Threshold is not in PeakDetectionMethod, resolve to Null *)
										{Automatic,_,_},Null,

										(* If PeakThreshold is specified (or Null), resolve to the specified value *)
										{_,_,_},unresolvedPeakThreshold
									];

									(* Return the resolved options and the error switches *)
									{
										(* Resolved options *)
										peakDetectionMethod,
										peakWidth,
										peakThreshold,

										(* Error switches *)
										invalidSpecifiedPeakDetectionError,
										invalidNullPeakDetectionMethodError,
										invalidNullPeakDetectionParametersError,
										invalidPeakWidthError,
										invalidPeakThresholdError
									}
								]
							],
							{detectorOptions,unresolvedPeakDetectionMethodsOptions,unresolvedPeakWidthsOptions,unresolvedPeakThresholdsOptions}
						]
					];

					(*-- ColumnStorageCondition --*)

					(* Set a Boolean to indicate whether the current Column is specified to an Object[Item,Column] and
					the same column object is also specified for a later input sample *)
					columnReusedQ=And[
						MatchQ[unresolvedColumn,ObjectP[Object[Item,Column]]],
						MemberQ[Drop[specifiedColumn,sampleIndex],unresolvedColumn]
					];

					(* Flip an error switch if ColumnStorageCondition is specified to Disposal and the Column is an
					Object[Item,Column] that is also specified for a later input sample *)
					invalidColumnStorageConditionError=And[
						MatchQ[unresolvedColumnStorageCondition,Disposal],
						columnReusedQ
					];

					(* Resolve ColumnStorageCondition *)
					columnStorageCondition=Switch[{unresolvedColumnStorageCondition,columnReusedQ,columnReusability,columnFunctionalGroup},

						(* If ColumnStorageCondition is unspecified and the column will be reused with a later sample,
						resolve to AmbientStorage *)
						{Automatic,True,_,_},AmbientStorage,

						(* If ColumnStorageCondition is unspecified, the column will not be reused, and the column is multi-use,
						resolve to AmbientStorage *)
						{Automatic,_,True,_},AmbientStorage,

						(* If ColumnStorageCondition is unspecified, the column will not be reused, and the column is single-use,
						resolve to Disposal *)
						{Automatic,_,False,_},Disposal,

						(* If ColumnStorageCondition is unspecified, the column will not be reused, the column model's Reusable field is Null,
						and the column model's FunctionalGroup field is C8, C18, or Amine, resolve to AmbientStorage *)
						{Automatic,_,_,C18|C8|C18Aq|Amine},AmbientStorage,

						(* If ColumnStorageCondition is unspecified, the column will not be reused, the column model's Reusable field is Null,
						and the column model's FunctionalGroup field is not C8, C18, or Amine, resolve to Disposal *)
						{Automatic,_,_,_},Disposal,

						(* If ColumnStorageCondition is specified, resolve to the specified value *)
						{_,_,_,_},unresolvedColumnStorageCondition
					];

					(*-- AirPurgeDuration --*)

					(* Flip an error switch if AirPurgeDuration is specified to 0 Minute or Null and ColumnStorageCondition
					is Disposal *)
					invalidAirPurgeDurationError=And[
						MatchQ[unresolvedAirPurgeDuration,0 Minute|Null],
						MatchQ[columnStorageCondition,Disposal]
					];

					(* Flip a warning switch if AirPurgeDuration is specified to > 0 Minute and ColumnStorageCondition is
					not Disposal *)
					airPurgeAndStoreColumnWarning=And[
						MatchQ[unresolvedAirPurgeDuration,GreaterP[0 Minute]],
						!MatchQ[columnStorageCondition,Disposal]
					];

					(* Resolve AirPurgeDuration *)
					airPurgeDuration=Switch[{unresolvedAirPurgeDuration,columnStorageCondition},

						(* If AirPurgeDuration is unspecified and ColumnStorageCondition is Disposal,
						resolve to 1 Minute *)
						{Automatic,Disposal},1 Minute,

						(* If AirPurgeDuration is unspecified and ColumnStorageCondition is not Disposal,
						resolve to 0 Minute *)
						{Automatic,_},0 Minute,

						(* If AirPurgeDuration is specified, resolve to the specified value *)
						{_,_},unresolvedAirPurgeDuration
					];

					(*-- Label Options --*)

					(* If there is a simulation, get a list of Object->Label rules from it *)
					simulationObjectToLabelRules=If[MatchQ[updatedSimulation,SimulationP],
						Reverse/@Lookup[updatedSimulation[[1]],Labels,{}],
						{}
					];

					(* Get the input sample's label from the simulation if it has one *)
					simulationInputSampleLabel=Lookup[simulationObjectToLabelRules,myInputSample,Null];

					(* Resolve SampleLabel *)
					sampleLabel=Switch[{unresolvedSampleLabel,simulationInputSampleLabel},

						(* If SampleLabel is unspecified and the input sample is labeled in the simulation,
						resolve to the label from the simulation *)
						{Automatic,_String},simulationInputSampleLabel,

						(* If SampleLabel is unspecified and the input sample is not labeled in the simulation,
						resolve to a label using the input sample's object
						We want the post-sample prep, pre-aliquot sample, so we use myInputSamples rather than
						simulatedSamples which is post-aliquot *)
						{Automatic,_},"FlashChromatography Sample: "<>ObjectToString[myInputSample,Cache->cacheBall],

						(* If SampleLabel is specified, resolve to the specified value *)
						{_,_},unresolvedSampleLabel
					];

					(* Get the input sample container's label from the simulation if it has one *)
					simulationInputSampleContainerLabel=Lookup[simulationObjectToLabelRules,myInputSampleContainer,Null];

					(* Resolve SampleContainerLabel *)
					sampleContainerLabel=Switch[{unresolvedSampleContainerLabel,simulationInputSampleContainerLabel},

						(* If SampleContainerLabel is unspecified and the input sample's container is labeled in the simulation,
						resolve to the label from the simulation *)
						{Automatic,_String},simulationInputSampleContainerLabel,

						(* If SampleContainerLabel is unspecified and the input sample's container is not labeled in the simulation,
						resolve to a label using the input sample's container's object *)
						{Automatic,_},"FlashChromatography Sample Container: "<>ObjectToString[myInputSampleContainer,Cache->cacheBall],

						(* If SampleContainerLabel is specified, resolve to the specified value *)
						{_,_},unresolvedSampleContainerLabel
					];

					(* Resolve ColumnLabel *)
					columnLabel=Switch[{unresolvedColumnLabel,column},

						(* If ColumnLabel is unspecified, and the resolved column is an Object[Item,Column],
						resolve to a label using the column's object *)
						{Automatic,ObjectReferenceP[Object[Item,Column]]},
						"FlashChromatography Column: "<>ObjectToString[column,Cache->cacheBall],

						(* If ColumnLabel is unspecified, and the resolved column is a Model[Item,Column],
						resolve to a label using the column's model and a unique identifier *)
						{Automatic,_},"FlashChromatography Column: "<>ObjectToString[column,Cache->cacheBall]<>"-"<>ToString[Unique[]],

						(* If ColumnLabel is specified, resolve to the specified value *)
						{_,_},unresolvedColumnLabel
					];

					(* Flip an error switch if CartridgeLabel is specified to Null and the resolved Cartridge is not Null *)
					invalidNullCartridgeLabelError=And[
						NullQ[unresolvedCartridgeLabel],
						!NullQ[cartridge]
					];

					(* Flip an error switch if CartridgeLabel is specified to a String and the resolved Cartridge is Null *)
					invalidSpecifiedCartridgeLabelError=And[
						StringQ[unresolvedCartridgeLabel],
						NullQ[cartridge]
					];

					(* Resolve CartridgeLabel *)
					cartridgeLabel=Switch[{unresolvedCartridgeLabel,cartridge},

						(* If CartridgeLabel is unspecified, and the resolved cartridge is an Object[Container,ExtractionCartridge],
						resolve to a label using the cartridge's object *)
						{Automatic,ObjectReferenceP[Object[Container,ExtractionCartridge]]},
						"FlashChromatography Cartridge: "<>ObjectToString[cartridge,Cache->cacheBall],

						(* If CartridgeLabel is unspecified, and the resolved cartridge is a Model[Container,ExtractionCartridge],
						resolve to a label using the cartridge's model and a unique identifier *)
						{Automatic,ObjectReferenceP[Model[Container,ExtractionCartridge]]},
						"FlashChromatography Cartridge: "<>ObjectToString[cartridge,Cache->cacheBall]<>"-"<>ToString[Unique[]],

						(* If CartridgeLabel is unspecified, and the resolved cartridge is Null,
						resolve to Null *)
						{Automatic,_},Null,

						(* If CartridgeLabel is specified, resolve to the specified value *)
						{_,_},unresolvedCartridgeLabel
					];


					(* Return the resolved options, errors, and values necessary to populate error messages *)
					{
						(* Resolved options *)
						loadingType,
						maxLoadingPercent,
						column,
						loadingAmount,
						cartridge,
						cartridgePackingMaterial,
						cartridgeFunctionalGroup,
						cartridgePackingMass,
						cartridgeDryingTime,
						flowRate,
						preSampleEquilibration,
						unresolvedGradientStart,(* No Automatic resolution for the shortcuts, so return the unresolved options *)
						unresolvedGradientEnd,
						unresolvedGradientDuration,
						unresolvedEquilibrationTime,
						unresolvedFlushTime,
						gradientB,
						gradientA,
						gradient,
						collectFractions,
						fractionCollectionStartTime,
						fractionCollectionEndTime,
						fractionContainer,
						maxFractionVolume,
						fractionCollectionMode,
						detectors,
						primaryWavelength,
						secondaryWavelength,
						wideRangeUV,
						peakDetectors,
						primaryWavelengthPeakDetectionMethod,
						secondaryWavelengthPeakDetectionMethod,
						wideRangeUVPeakDetectionMethod,
						primaryWavelengthPeakWidth,
						secondaryWavelengthPeakWidth,
						wideRangeUVPeakWidth,
						primaryWavelengthPeakThreshold,
						secondaryWavelengthPeakThreshold,
						wideRangeUVPeakThreshold,
						columnStorageCondition,
						airPurgeDuration,
						sampleLabel,
						sampleContainerLabel,
						columnLabel,
						cartridgeLabel,


						(* Errors and warnings *)
						mismatchedCartridgeOptionsError,
						mismatchedSolidLoadNullCartridgeOptionsError,
						mismatchedLiquidLoadSpecifiedCartridgeOptionsError,
						recommendedMaxLoadingPercentExceededWarning,
						deprecatedColumnError,
						incompatibleColumnTypeError,
						incompatibleColumnAndInstrumentFlowRateError,
						insufficientSampleVolumeError,
						invalidLoadingAmountForColumnError,
						invalidLoadingAmountError,
						invalidLoadingAmountForInstrumentError,
						invalidLoadingAmountForSyringesError,
						incompatibleCartridgeLoadingTypeError,
						incompatibleCartridgeTypeError,
						incompatibleCartridgePackingTypeError,
						incompatibleCartridgeAndInstrumentFlowRateError,
						incompatibleCartridgeAndColumnFlowRateError,
						invalidCartridgeMaxBedWeightError,
						incompatibleInjectionAssemblyLengthError,
						mismatchedColumnAndPrepackedCartridgeWarning,
						invalidCartridgePackingMaterialError,
						invalidCartridgeFunctionalGroupError,
						mismatchedColumnAndCartridgeWarning,
						invalidCartridgePackingMassError,
						tooHighCartridgePackingMassError,
						tooLowCartridgePackingMassError,
						invalidPackingMassForCartridgeCapsError,
						incompatibleFlowRateError,
						incompatiblePreSampleEquilibrationError,
						redundantGradientShortcutError,
						incompleteGradientShortcutError,
						zeroGradientShortcutError,
						redundantGradientSpecificationError,
						invalidGradientBTimeError,
						invalidGradientATimeError,
						invalidGradientTimeError,
						invalidTotalGradientTimeError,
						methanolPercentWarning,
						invalidFractionCollectionOptionsError,
						invalidCollectFractionsError,
						mismatchedFractionCollectionOptionsError,
						invalidFractionCollectionStartTimeError,
						invalidFractionCollectionEndTimeError,
						invalidFractionContainerError,
						invalidMaxFractionVolumeForContainerError,
						invalidMaxFractionVolumeError,
						invalidSpecifiedDetectorsError,
						invalidNullDetectorsError,
						invalidWideRangeUVError,
						missingPeakDetectorsError,
						invalidSpecifiedPrimaryWavelengthPeakDetectionError,
						invalidSpecifiedSecondaryWavelengthPeakDetectionError,
						invalidSpecifiedWideRangeUVPeakDetectionError,
						invalidNullPrimaryWavelengthPeakDetectionMethodError,
						invalidNullSecondaryWavelengthPeakDetectionMethodError,
						invalidNullWideRangeUVPeakDetectionMethodError,
						invalidNullPrimaryWavelengthPeakDetectionParametersError,
						invalidNullSecondaryWavelengthPeakDetectionParametersError,
						invalidNullWideRangeUVPeakDetectionParametersError,
						invalidPrimaryWavelengthPeakWidthError,
						invalidSecondaryWavelengthPeakWidthError,
						invalidWideRangeUVPeakWidthError,
						invalidPrimaryWavelengthPeakThresholdError,
						invalidSecondaryWavelengthPeakThresholdError,
						invalidWideRangeUVPeakThresholdError,
						invalidColumnStorageConditionError,
						invalidAirPurgeDurationError,
						airPurgeAndStoreColumnWarning,
						invalidNullCartridgeLabelError,
						invalidSpecifiedCartridgeLabelError,

						(* Values to populate error messages *)
						preferredMaxLoadingPercent,
						maxLoadingFraction,
						unresolvedColumnChromatographyType,
						unresolvedColumnMinFlowRate,
						unresolvedColumnMaxFlowRate,
						unresolvedColumnVoidVolume,
						columnMinFlowRate,
						columnMaxFlowRate,
						unresolvedLoadingAmountVolume,
						loadingAmountVolume,
						unresolvedCartridgeChromatographyType,
						unresolvedCartridgePackingType,
						unresolvedCartridgeMinFlowRate,
						unresolvedCartridgeMaxFlowRate,
						columnLength,
						cartridgeLength,
						injectionAssemblyLength,
						columnSeparationMode,
						columnPackingMaterial,
						columnFunctionalGroup,
						cartridgeSeparationMode,
						cartridgePackingMaterialField,
						cartridgeFunctionalGroupField,
						cartridgePackingType,
						cartridgeMaxBedWeight,
						cartridgeMinFlowRate,
						cartridgeMaxFlowRate,
						flowRateInterval,
						unresolvedGradientBTime,
						unresolvedGradientATime,
						unresolvedGradientTime,
						totalGradientBTime,
						containerMaxVolume,
						detectorsList
					}
				]
			],
			{samplePackets,sampleVolumes,mapThreadFriendlyOptions,sampleContainerPackets,myInputSamples,myInputSampleContainers,sampleIndexes}
		]
	];

	(*--- Errors and Warnings from the MapThread  ---*)

	(* Throw an error if some cartridge-related options are specified and others are Null *)
	mismatchedCartridgeOptions=If[MemberQ[mismatchedCartridgeOptionsErrors,True]&&messages,
		Message[Error::MismatchedCartridgeOptions,
			ObjectToString[PickList[simulatedSamples,mismatchedCartridgeOptionsErrors],Cache->cacheBall],
			ObjectToString[PickList[specifiedCartridge,mismatchedCartridgeOptionsErrors],Cache->cacheBall],
			PickList[specifiedCartridgePackingMaterial,mismatchedCartridgeOptionsErrors],
			PickList[specifiedCartridgeFunctionalGroup,mismatchedCartridgeOptionsErrors],
			PickList[specifiedCartridgePackingMass,mismatchedCartridgeOptionsErrors],
			PickList[specifiedCartridgeDryingTime,mismatchedCartridgeOptionsErrors]
		];
		{Cartridge,CartridgePackingMaterial,CartridgeFunctionalGroup,CartridgePackingMass,CartridgeDryingTime},
		{}
	];

	(* If we are gathering tests, make a test for Error::MismatchedCartridgeOptions *)
	mismatchedCartridgeOptionsTest=If[gatherTests,
		Test["Cartridge-related options referring to the same sample are not a mix of specified and Null:",
			MemberQ[mismatchedCartridgeOptionsErrors,True],
			False
		]
	];

	(* Throw an error if LoadingType is specified to Solid, but some cartridge-related options are Null *)
	mismatchedSolidLoadNullCartridgeOptions=If[MemberQ[mismatchedSolidLoadNullCartridgeOptionsErrors,True]&&messages,
		Message[Error::MismatchedSolidLoadNullCartridgeOptions,
			ObjectToString[PickList[simulatedSamples,mismatchedSolidLoadNullCartridgeOptionsErrors],Cache->cacheBall],
			ObjectToString[PickList[specifiedCartridge,mismatchedSolidLoadNullCartridgeOptionsErrors],Cache->cacheBall],
			PickList[specifiedCartridgePackingMaterial,mismatchedSolidLoadNullCartridgeOptionsErrors],
			PickList[specifiedCartridgePackingMass,mismatchedSolidLoadNullCartridgeOptionsErrors],
			PickList[specifiedCartridgeDryingTime,mismatchedSolidLoadNullCartridgeOptionsErrors]
		];
		{Cartridge,CartridgePackingMaterial,CartridgePackingMass,CartridgeDryingTime},
		{}
	];

	(* If we are gathering tests, make a test for Error::MismatchedSolidLoadNullCartridgeOptions *)
	mismatchedSolidLoadNullCartridgeOptionsTest=If[gatherTests,
		Test["If LoadingType is specified to Solid, no cartridge-related options referring to the same sample are Null:",
			MemberQ[mismatchedSolidLoadNullCartridgeOptionsErrors,True],
			False
		]
	];

	(* Throw an error if LoadingType is specified to Liquid, but some cartridge-related options are Specified *)
	mismatchedLiquidLoadSpecifiedCartridgeOptions=If[MemberQ[mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors,True]&&messages,
		Message[Error::MismatchedLiquidLoadSpecifiedCartridgeOptions,
			ObjectToString[PickList[simulatedSamples,mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors],Cache->cacheBall],
			ObjectToString[PickList[specifiedCartridge,mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors],Cache->cacheBall],
			PickList[specifiedCartridgePackingMaterial,mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors],
			PickList[specifiedCartridgeFunctionalGroup,mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors],
			PickList[specifiedCartridgePackingMass,mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors],
			PickList[specifiedCartridgeDryingTime,mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors]
		];
		{Cartridge,CartridgePackingMaterial,CartridgeFunctionalGroup,CartridgePackingMass,CartridgeDryingTime},
		{}
	];

	(* If we are gathering tests, make a test for Error::MismatchedLiquidLoadSpecifiedCartridgeOptions *)
	mismatchedLiquidLoadSpecifiedCartridgeOptionsTest=If[gatherTests,
		Test["If LoadingType is specified to Liquid, no cartridge-related options referring to the same sample are specified:",
			MemberQ[mismatchedLiquidLoadSpecifiedCartridgeOptionsErrors,True],
			False
		]
	];

	(* Throw a warning if MaxLoadingPercent is specified and it is greater than the recommended MaxLoadingPercent *)
	If[MemberQ[recommendedMaxLoadingPercentExceededWarnings,True]&&messages&&notInEngine,
		Message[Warning::RecommendedMaxLoadingPercentExceeded,
			PickList[specifiedMaxLoadingPercent,recommendedMaxLoadingPercentExceededWarnings],
			PickList[preferredMaxLoadingPercents,recommendedMaxLoadingPercentExceededWarnings],
			PickList[resolvedLoadingType,recommendedMaxLoadingPercentExceededWarnings]
		]
	];

	(* If we are gathering tests, make a test for Warning::RecommendedMaxLoadingPercentExceeded *)
	recommendedMaxLoadingPercentExceededTest=If[gatherTests,
		Warning["If MaxLoadingPercent is specified, it is less than or equal to the recommended MaxLoadingPercent for the LoadingType:",
			MemberQ[recommendedMaxLoadingPercentExceededWarnings,True],
			False
		]
	];

	(* Flip an error switch if Column is specified and its Model is Deprecated->True *)
	deprecatedColumnOptions=If[MemberQ[deprecatedColumnErrors,True]&&messages,
		Message[Error::DeprecatedColumn,
			ObjectToString[PickList[specifiedColumn,deprecatedColumnErrors],Cache->cacheBall],
			resolvedSeparationMode
		];
		{Column},
		{}
	];

	(* If we are gathering tests, make a test for Error::DeprecatedColumn *)
	deprecatedColumnTest=If[gatherTests,
		Test["If Column is specified, it is not Deprecated:",
			MemberQ[deprecatedColumnErrors,True],
			False
		]
	];

	(* Throw an error if if Column is specified and its Model's ChromatographyType is not Flash *)
	incompatibleColumnTypeOptions=If[MemberQ[incompatibleColumnTypeErrors,True]&&messages,
		Message[Error::IncompatibleColumnType,
			ObjectToString[PickList[specifiedColumn,incompatibleColumnTypeErrors],Cache->cacheBall],
			PickList[specifiedColumnChromatographyTypes,incompatibleColumnTypeErrors],
			resolvedSeparationMode
		];
		{Column},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatibleColumnType *)
	incompatibleColumnTypeTest=If[gatherTests,
		Test["If Column is specified, its Model has ChromatographyType Flash:",
			MemberQ[incompatibleColumnTypeErrors,True],
			False
		]
	];

	(* Throw an error  if there is no overlap between the column and instrument min/max flow rate intervals *)
	incompatibleColumnAndInstrumentFlowRateOptions=If[MemberQ[incompatibleColumnAndInstrumentFlowRateErrors,True]&&messages,
		Message[Error::IncompatibleFlowRates,
			PickList[specifiedColumnMinFlowRates,incompatibleColumnAndInstrumentFlowRateErrors],
			PickList[specifiedColumnMaxFlowRates,incompatibleColumnAndInstrumentFlowRateErrors],
			"columns",
			ObjectToString[PickList[specifiedColumn,incompatibleColumnAndInstrumentFlowRateErrors],Cache->cacheBall],
			"instrument",
			ObjectToString[resolvedInstrument,Cache->cacheBall],
			resolvedInstrumentMinFlowRate,
			resolvedInstrumentMaxFlowRate,
			"Column"
		];
		{Column,Instrument},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatibleFlowRates *)
	incompatibleColumnAndInstrumentFlowRateTest=If[gatherTests,
		Test["If Column is specified, its MinFlowRate and MaxFlowRate range overlaps with the instrument's:",
			MemberQ[incompatibleColumnAndInstrumentFlowRateErrors,True],
			False
		]
	];

	(* Throw an error if LoadingAmount is specified and is greater than the volume of the sample *)
	insufficientSampleVolumeOptions=If[MemberQ[insufficientSampleVolumeErrors,True]&&messages,
		Message[Error::InsufficientSampleVolumeFlashChromatography,
			PickList[specifiedLoadingAmount,insufficientSampleVolumeErrors],
			PickList[sampleVolumes,insufficientSampleVolumeErrors],
			ObjectToString[PickList[simulatedSamples,insufficientSampleVolumeErrors],Cache->cacheBall]
		];
		{LoadingAmount},
		{}
	];

	(* If we are gathering tests, make a test for Error::InsufficientSampleVolumeFlashChromatography *)
	insufficientSampleVolumeTest=If[gatherTests,
		Test["If LoadingAmount is specified, it is less than or equal to the volume of the sample:",
			MemberQ[insufficientSampleVolumeErrors,True],
			False
		]
	];

	(* Throw an error if Column is specified, LoadingAmount is specified, and the LoadingAmount is greater than
	 the column's VoidVolume times MaxLoadingPercent *)
	invalidLoadingAmountForColumnOptions=If[MemberQ[invalidLoadingAmountForColumnErrors,True]&&messages,
		Message[Error::InvalidLoadingAmountForColumn,
			PickList[specifiedLoadingAmountVolumes,invalidLoadingAmountForColumnErrors],
			PickList[resolvedMaxLoadingPercent,invalidLoadingAmountForColumnErrors],
			PickList[specifiedColumnVoidVolumes,invalidLoadingAmountForColumnErrors],
			PickList[resolvedMaxLoadingFractions*specifiedColumnVoidVolumes,invalidLoadingAmountForColumnErrors],
			ObjectToString[PickList[specifiedColumn,invalidLoadingAmountForColumnErrors],Cache->cacheBall]
		];
		{LoadingAmount,Column},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidLoadingAmountForColumn *)
	invalidLoadingAmountForColumnTest=If[gatherTests,
		Test["If LoadingAmount and Column are specified, MaxLoadingPercent times the column's VoidVolume is greater than or equal to the LoadingAmount:",
			MemberQ[invalidLoadingAmountForColumnErrors,True],
			False
		]
	];

	(* Throw an error if Column is unspecified, LoadingAmount is specified, are there aren't any columns from the
	default list large enough to hold the LoadingAmount *)
	invalidLoadingAmountOptions=If[MemberQ[invalidLoadingAmountErrors,True]&&messages,
		Message[Error::InvalidLoadingAmount,
			PickList[specifiedLoadingAmountVolumes,invalidLoadingAmountErrors],
			PickList[resolvedMaxLoadingPercent,invalidLoadingAmountErrors],
			largestDefaultColumnVoidVolume,
			PickList[resolvedMaxLoadingFractions*largestDefaultColumnVoidVolume,invalidLoadingAmountErrors],
			ObjectToString[largestDefaultColumn,Cache->cacheBall],
			resolvedSeparationMode
		];
		{LoadingAmount},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidLoadingAmount *)
	invalidLoadingAmountTest=If[gatherTests,
		Test["If LoadingAmount is specified, at least one of the default columns is large enough that MaxLoadingPercent times the column's VoidVolume is greater than or equal to the LoadingAmount:",
			MemberQ[invalidLoadingAmountErrors,True],
			False
		]
	];

	(* Throw an error if the resolved LoadingAmount is not within the resolved instrument's
	MinSampleVolume and MaxSampleVolume interval *)
	invalidLoadingAmountForInstrumentOptions=If[MemberQ[invalidLoadingAmountForInstrumentErrors,True]&&messages,
		Message[Error::InvalidLoadingAmountForInstrument,
			ObjectToString[PickList[simulatedSamples,invalidLoadingAmountForInstrumentErrors],Cache->cacheBall],
			PickList[Convert[resolvedLoadingAmountVolumes,Milliliter],invalidLoadingAmountForInstrumentErrors],
			Convert[resolvedInstrumentVolumeInterval,Milliliter],
			ObjectToString[resolvedInstrument,Cache->cacheBall]
		];
		{LoadingAmount,Instrument},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidLoadingAmountForInstrument *)
	invalidLoadingAmountForInstrumentTest=If[gatherTests,
		Test["The resolved LoadingAmount is within the range of sample loading volumes allowed for the resolved Instrument:",
			MemberQ[invalidLoadingAmountForInstrumentErrors,True],
			False
		]
	];

	(* Throw an error if the resolved LoadingAmount is not within the interval of volumes covered
	by the list of instrument-compatible syringes *)
	invalidLoadingAmountForSyringesOptions=If[MemberQ[invalidLoadingAmountForSyringesErrors,True]&&messages,
		Message[Error::InvalidLoadingAmountForSyringes,
			ObjectToString[PickList[simulatedSamples,invalidLoadingAmountForSyringesErrors],Cache->cacheBall],
			PickList[Convert[resolvedLoadingAmountVolumes,Milliliter],invalidLoadingAmountForSyringesErrors],
			Convert[syringeVolumeInterval,Milliliter],
			ObjectToString[syringeModels,Cache->cacheBall]
		];
		{LoadingAmount},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidLoadingAmountForSyringes *)
	invalidLoadingAmountForSyringesTest=If[gatherTests,
		Test["The resolved LoadingAmount is within the range of volumes that can be transferred by instrument-compatible syringes:",
			MemberQ[invalidLoadingAmountForSyringesErrors,True],
			False
		]
	];

	(* Throw an error if Cartridge is specified and the resolved LoadingType is not Solid *)
	incompatibleCartridgeLoadingTypeOptions=If[MemberQ[incompatibleCartridgeLoadingTypeErrors,True]&&messages,
		Message[Error::IncompatibleCartridgeLoadingType,
			ObjectToString[PickList[specifiedCartridge,incompatibleCartridgeLoadingTypeErrors],Cache->cacheBall],
			PickList[resolvedLoadingType,incompatibleCartridgeLoadingTypeErrors]
		];
		{Cartridge,LoadingType},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatibleCartridgeLoadingType *)
	incompatibleCartridgeLoadingTypeTest=If[gatherTests,
		Test["If Cartridge is specified, LoadingType is Solid:",
			MemberQ[incompatibleCartridgeLoadingTypeErrors,True],
			False
		]
	];

	(* Throw an error if Cartridge is specified and its Model's ChromatographyType is not Flash *)
	incompatibleCartridgeTypeOptions=If[MemberQ[incompatibleCartridgeTypeErrors,True]&&messages,
		Message[Error::IncompatibleCartridgeType,
			ObjectToString[PickList[specifiedCartridge,incompatibleCartridgeTypeErrors],Cache->cacheBall],
			PickList[specifiedCartridgeChromatographyTypes,incompatibleCartridgeTypeErrors]
		];
		{Cartridge},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatibleCartridgeType *)
	incompatibleCartridgeTypeTest=If[gatherTests,
		Test["If Cartridge is specified, its Model's ChromatographyType is Flash:",
			MemberQ[incompatibleCartridgeTypeErrors,True],
			False
		]
	];

	(* Throw an error if Cartridge is specified and its Model's PackingType is not Prepacked or HandPacked *)
	incompatibleCartridgePackingTypeOptions=If[MemberQ[incompatibleCartridgePackingTypeErrors,True]&&messages,
		Message[Error::IncompatibleCartridgePackingType,
			ObjectToString[PickList[specifiedCartridge,incompatibleCartridgePackingTypeErrors],Cache->cacheBall],
			PickList[specifiedCartridgePackingTypes,incompatibleCartridgePackingTypeErrors]
		];
		{Cartridge},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatibleCartridgePackingType *)
	incompatibleCartridgePackingTypeTest=If[gatherTests,
		Test["If Cartridge is specified, its Model's PackingType is Prepacked or HandPacked:",
			MemberQ[incompatibleCartridgePackingTypeErrors,True],
			False
		]
	];

	(* Throw an error if Cartridge is specified and there is no overlap between the cartridge and instrument min/max flow rate intervals *)
	incompatibleCartridgeAndInstrumentFlowRateOptions=If[MemberQ[incompatibleCartridgeAndInstrumentFlowRateErrors,True]&&messages,
		Message[Error::IncompatibleFlowRates,
			PickList[specifiedCartridgeMinFlowRates,incompatibleCartridgeAndInstrumentFlowRateErrors],
			PickList[specifiedCartridgeMaxFlowRates,incompatibleCartridgeAndInstrumentFlowRateErrors],
			"cartridges",
			ObjectToString[PickList[specifiedCartridge,incompatibleCartridgeAndInstrumentFlowRateErrors],Cache->cacheBall],
			"instrument",
			ObjectToString[resolvedInstrument,Cache->cacheBall],
			resolvedInstrumentMinFlowRate,
			resolvedInstrumentMaxFlowRate,
			"Cartridge"
		];
		{Cartridge,Instrument},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatibleFlowRates *)
	incompatibleCartridgeAndInstrumentFlowRateTest=If[gatherTests,
		Test["If Cartridge is specified, its MinFlowRate and MaxFlowRate range overlaps with the instrument's:",
			MemberQ[incompatibleCartridgeAndInstrumentFlowRateErrors,True],
			False
		]
	];

	(* Throw an error if Cartridge is specified and there is no overlap between the cartridge and column min/max flow rate intervals *)
	incompatibleCartridgeAndColumnFlowRateOptions=If[MemberQ[incompatibleCartridgeAndColumnFlowRateErrors,True]&&messages,
		Message[Error::IncompatibleFlowRates,
			PickList[specifiedCartridgeMinFlowRates,incompatibleCartridgeAndColumnFlowRateErrors],
			PickList[specifiedCartridgeMaxFlowRates,incompatibleCartridgeAndColumnFlowRateErrors],
			"cartridges",
			ObjectToString[PickList[specifiedCartridge,incompatibleCartridgeAndColumnFlowRateErrors],Cache->cacheBall],
			"columns",
			ObjectToString[PickList[resolvedColumn,incompatibleCartridgeAndColumnFlowRateErrors],Cache->cacheBall],
			PickList[resolvedColumnMinFlowRates,incompatibleCartridgeAndColumnFlowRateErrors],
			PickList[resolvedColumnMaxFlowRates,incompatibleCartridgeAndColumnFlowRateErrors],
			"Cartridge"
		];
		{Cartridge,Column},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatibleFlowRates *)
	incompatibleCartridgeAndColumnFlowRateTest=If[gatherTests,
		Test["If Cartridge is specified, its MinFlowRate and MaxFlowRate range overlaps with the columns':",
			MemberQ[incompatibleCartridgeAndColumnFlowRateErrors,True],
			False
		]
	];


	(* Throw an error if there is a resolved Cartridge of ChromatographyType Flash and it doesn't
	have a MaxBedWeight of 5, 25, or 65 Gram (this is necessary for resource picking for the cartridge cap,
	frits, and plunger) *)
	invalidCartridgeMaxBedWeightOptions=If[MemberQ[invalidCartridgeMaxBedWeightErrors,True]&&messages,
		Message[Error::InvalidCartridgeMaxBedWeight,
			ObjectToString[PickList[resolvedCartridge,invalidCartridgeMaxBedWeightErrors],Cache->cacheBall],
			PickList[resolvedCartridgeMaxBedWeights,invalidCartridgeMaxBedWeightErrors]
		];
		{Cartridge},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidCartridgeMaxBedWeight *)
	invalidCartridgeMaxBedWeightTest=If[gatherTests,
		Test["If the Cartridge has ChromatographyType Flash, it has a MaxBedWeight of 5, 25, or 65 grams:",
			MemberQ[invalidCartridgeMaxBedWeightErrors,True],
			False
		]
	];

	(* Throw an error if the injection assembly length can't be determined, or if the injection assembly is longer than
	the instrument's MaxInjectionAssemblyLength *)
	incompatibleInjectionAssemblyLengthOptions=If[MemberQ[incompatibleInjectionAssemblyLengthErrors,True]&&messages,
		Message[Error::IncompatibleInjectionAssemblyLength,
			ObjectToString[PickList[resolvedColumn,incompatibleInjectionAssemblyLengthErrors],Cache->cacheBall],
			ObjectToString[PickList[resolvedCartridge,incompatibleInjectionAssemblyLengthErrors],Cache->cacheBall],
			PickList[resolvedColumnLengths,incompatibleInjectionAssemblyLengthErrors],
			PickList[resolvedCartridgeLengths,incompatibleInjectionAssemblyLengthErrors],
			resolvedInstrumentInjectionValveLength,
			injectionAssemblyLengths,
			ObjectToString[resolvedInstrument,Cache->cacheBall],
			resolvedInstrumentMaxInjectionAssemblyLength
		];
		{Cartridge,Column,Instrument},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatibleInjectionAssemblyLength *)
	incompatibleInjectionAssemblyLengthTest=If[gatherTests,
		Test["The total injection assembly length is less than the instrument's MaxInjectionAssemblyLength:",
			MemberQ[incompatibleInjectionAssemblyLengthErrors,True],
			False
		]
	];

	(* Throw a warning if there is a resolved Prepacked cartridge and any of the column and cartridge SeparationMode,
	PackingMaterial, and FunctionalGroup fields don't match *)
	If[MemberQ[mismatchedColumnAndPrepackedCartridgeWarnings,True]&&messages&&notInEngine,
		Message[Warning::MismatchedColumnAndPrepackedCartridge,
			ObjectToString[PickList[resolvedColumn,mismatchedColumnAndPrepackedCartridgeWarnings],Cache->cacheBall],
			PickList[resolvedColumnSeparationModes,mismatchedColumnAndPrepackedCartridgeWarnings],
			PickList[resolvedColumnPackingMaterials,mismatchedColumnAndPrepackedCartridgeWarnings],
			PickList[resolvedColumnFunctionalGroups,mismatchedColumnAndPrepackedCartridgeWarnings],
			ObjectToString[PickList[resolvedCartridge,mismatchedColumnAndPrepackedCartridgeWarnings],Cache->cacheBall],
			PickList[resolvedCartridgeSeparationModes,mismatchedColumnAndPrepackedCartridgeWarnings],
			PickList[resolvedCartridgePackingMaterials,mismatchedColumnAndPrepackedCartridgeWarnings],
			PickList[resolvedCartridgeFunctionalGroups,mismatchedColumnAndPrepackedCartridgeWarnings]
		]
	];
	(* Nomenclature clarification:
	resolvedCartridgePackingMaterials is a list of the PackingMaterial fields from the resolved Cartridge option values
	resolvedCartridgePackingMaterial is a list of the resolved CartridgePackingMaterial option values *)

	(* If we are gathering tests, make a test for Warning::MismatchedColumnAndPrepackedCartridge *)
	mismatchedColumnAndPrepackedCartridgeTest=If[gatherTests,
		Warning["If there is a resolved Prepacked Cartridge, the SeparationMode, PackingMaterial, and FunctionalGroup fields of the column and the cartridge are the same:",
			MemberQ[mismatchedColumnAndPrepackedCartridgeWarnings,True],
			False
		]
	];

	(* Throw an error if there is a resolved cartridge, it does not have PackingType HandPacked,
	and CartridgePackingMaterial is specified *)
	invalidCartridgePackingMaterialOptions=If[MemberQ[invalidCartridgePackingMaterialErrors,True]&&messages,
		Message[Error::InvalidCartridgePackingMaterial,
			PickList[specifiedCartridgePackingMaterial,invalidCartridgePackingMaterialErrors],
			ObjectToString[PickList[resolvedCartridge,invalidCartridgePackingMaterialErrors],Cache->cacheBall],
			PickList[resolvedCartridgePackingTypes,invalidCartridgePackingMaterialErrors]
		];
		{Cartridge,CartridgePackingMaterial},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidCartridgePackingMaterial *)
	invalidCartridgePackingMaterialTest=If[gatherTests,
		Test["CartridgePackingMaterial is not specified unless the cartridge is HandPacked:",
			MemberQ[invalidCartridgePackingMaterialErrors,True],
			False
		]
	];

	(* Throw an error if there is a resolved cartridge, it does not have PackingType HandPacked,
	and CartridgeFunctionalGroup is specified *)
	invalidCartridgeFunctionalGroupOptions=If[MemberQ[invalidCartridgeFunctionalGroupErrors,True]&&messages,
		Message[Error::InvalidCartridgeFunctionalGroup,
			PickList[specifiedCartridgeFunctionalGroup,invalidCartridgeFunctionalGroupErrors],
			ObjectToString[PickList[resolvedCartridge,invalidCartridgeFunctionalGroupErrors],Cache->cacheBall],
			PickList[resolvedCartridgePackingTypes,invalidCartridgeFunctionalGroupErrors]
		];
		{Cartridge,CartridgeFunctionalGroup},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidCartridgeFunctionalGroup *)
	invalidCartridgeFunctionalGroupTest=If[gatherTests,
		Test["CartridgeFunctionalGroup is not specified unless the cartridge is HandPacked:",
			MemberQ[invalidCartridgeFunctionalGroupErrors,True],
			False
		]
	];

	(* Throw a warning if if there is a resolved cartridge and either of the column's PackingMaterial and
	FunctionalGroup fields don't match the resolved CartridgePackingMaterial and CartridgeFunctionalGroup options *)
	If[MemberQ[mismatchedColumnAndCartridgeWarnings,True]&&messages&&notInEngine,
		Message[Warning::MismatchedColumnAndCartridge,
			ObjectToString[PickList[resolvedColumn,mismatchedColumnAndCartridgeWarnings],Cache->cacheBall],
			PickList[resolvedColumnPackingMaterials,mismatchedColumnAndCartridgeWarnings],
			PickList[resolvedColumnFunctionalGroups,mismatchedColumnAndCartridgeWarnings],
			ObjectToString[PickList[resolvedCartridge,mismatchedColumnAndCartridgeWarnings],Cache->cacheBall],
			PickList[resolvedCartridgePackingMaterial,mismatchedColumnAndCartridgeWarnings],
			PickList[resolvedCartridgeFunctionalGroup,mismatchedColumnAndCartridgeWarnings]
		]
	];

	(* If we are gathering tests, make a test for Warning::MismatchedColumnAndCartridge *)
	mismatchedColumnAndCartridgeTest=If[gatherTests,
		Warning["If there is a resolved Cartridge, the PackingMaterial and FunctionalGroup fields of the resolved column match the resolved CartridgePackingMaterial and CartridgeFunctionalGroup options:",
			MemberQ[mismatchedColumnAndCartridgeWarnings,True],
			False
		]
	];

	(* Throw an error if there is a resolved cartridge, it does not have PackingType HandPacked,
	and CartridgePackingMass is specified *)
	invalidCartridgePackingMassOptions=If[MemberQ[invalidCartridgePackingMassErrors,True]&&messages,
		Message[Error::InvalidCartridgePackingMass,
			PickList[specifiedCartridgePackingMass,invalidCartridgePackingMassErrors],
			ObjectToString[PickList[resolvedCartridge,invalidCartridgePackingMassErrors],Cache->cacheBall],
			PickList[resolvedCartridgePackingTypes,invalidCartridgePackingMassErrors]
		];
		{Cartridge,CartridgePackingMass},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidCartridgePackingMass *)
	invalidCartridgePackingMassTest=If[gatherTests,
		Test["CartridgePackingMass is not specified unless the cartridge is HandPacked:",
			MemberQ[invalidCartridgePackingMassErrors,True],
			False
		]
	];

	(* Throw an error if there is a resolved cartridge, CartridgePackingMass is specified, and
	CartridgePackingMass is greater than the cartridge's MaxBedWeight *)
	tooHighCartridgePackingMassOptions=If[MemberQ[tooHighCartridgePackingMassErrors,True]&&messages,
		Message[Error::TooHighCartridgePackingMass,
			PickList[specifiedCartridgePackingMass,tooHighCartridgePackingMassErrors],
			ObjectToString[PickList[resolvedCartridge,tooHighCartridgePackingMassErrors],Cache->cacheBall],
			PickList[resolvedCartridgeMaxBedWeights,tooHighCartridgePackingMassErrors]
		];
		{Cartridge,CartridgePackingMass},
		{}
	];

	(* If we are gathering tests, make a test for Error::TooHighCartridgePackingMass *)
	tooHighCartridgePackingMassTest=If[gatherTests,
		Test["CartridgePackingMass is less than or equal to the cartridge's MaxBedWeight:",
			MemberQ[tooHighCartridgePackingMassErrors,True],
			False
		]
	];

	(* Throw an error if there is a resolved cartridge and the resolved CartridgePackingMass is
	less than loadingAmount * cartridgeLoadingFactor (2 Gram/Milliliter) *)
	tooLowCartridgePackingMassOptions=If[MemberQ[tooLowCartridgePackingMassErrors,True]&&messages,
		Message[Error::TooLowCartridgePackingMass,
			ObjectToString[PickList[simulatedSamples,tooLowCartridgePackingMassErrors],Cache->cacheBall],
			PickList[resolvedCartridgePackingMass,tooLowCartridgePackingMassErrors],
			PickList[resolvedLoadingAmountVolumes,tooLowCartridgePackingMassErrors],
			cartridgeLoadingFactor,
			PickList[resolvedLoadingAmountVolumes*cartridgeLoadingFactor,tooLowCartridgePackingMassErrors]
		];
		{Cartridge,CartridgePackingMass,LoadingAmount},
		{}
	];

	(* If we are gathering tests, make a test for Error::TooLowCartridgePackingMass *)
	tooLowCartridgePackingMassTest=If[gatherTests,
		Test["CartridgePackingMass is greater than or equal to the LoadingAmount times "<>ToString[cartridgeLoadingFactor]<>":",
			MemberQ[tooLowCartridgePackingMassErrors,True],
			False
		]
	];

	(* Throw an error if there is a resolved cartridge, the cartridge's PackingType is HandPacked,
	and the resolved CartridgePackingMass is not within the interval of bed weights covered by the list
	of instrument-compatible cartridge caps *)
	invalidPackingMassForCartridgeCapsOptions=If[MemberQ[invalidPackingMassForCartridgeCapsErrors,True]&&messages,
		Message[Error::InvalidPackingMassForCartridgeCaps,
			ObjectToString[PickList[simulatedSamples,invalidPackingMassForCartridgeCapsErrors],Cache->cacheBall],
			PickList[Convert[resolvedCartridgePackingMass,Gram],invalidPackingMassForCartridgeCapsErrors],
			Convert[cartridgeCapBedWeightInterval,Gram],
			ObjectToString[cartridgeCapModels,Cache->cacheBall]
		];
		{Cartridge,CartridgePackingMass},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidPackingMassForCartridgeCaps *)
	invalidPackingMassForCartridgeCapsTest=If[gatherTests,
		Test["CartridgePackingMass is within the range of bed weights that can be loaded into cartridges attached to instrument compatible cartridge caps:",
			MemberQ[invalidPackingMassForCartridgeCapsErrors,True],
			False
		]
	];

	(* Throw an error if either:
		The resolved FlowRate is not within the intersection of the flow rate
			ranges of the instrument, column and cartridge (if there is a resolved cartridge)
		Or any of the MinFlowRate or MaxFlowRate fields are not informed *)
	incompatibleFlowRateOptions=If[MemberQ[incompatibleFlowRateErrors,True]&&messages,
		Message[Error::IncompatibleFlowRateFlashChromatography,
			PickList[resolvedFlowRate,incompatibleFlowRateErrors],
			ObjectToString[resolvedInstrument,Cache->cacheBall],
			resolvedInstrumentMinFlowRate,
			resolvedInstrumentMaxFlowRate,
			ObjectToString[PickList[resolvedColumn,incompatibleFlowRateErrors],Cache->cacheBall],
			PickList[resolvedColumnMinFlowRates,incompatibleFlowRateErrors],
			PickList[resolvedColumnMaxFlowRates,incompatibleFlowRateErrors],
			ObjectToString[PickList[resolvedCartridge,incompatibleFlowRateErrors],Cache->cacheBall],
			PickList[resolvedCartridgeMinFlowRates,incompatibleFlowRateErrors],
			PickList[resolvedCartridgeMaxFlowRates,incompatibleFlowRateErrors],
			PickList[resolvedFlowRateIntervals,incompatibleFlowRateErrors]
		];
		{FlowRate,Instrument,Column,Cartridge},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatibleFlowRateFlashChromatography *)
	incompatibleFlowRateTest=If[gatherTests,
		Test["If there is an intersection of the MinFlowRate to MaxFlowRate intervals of the instrument, columns, and cartridges (if there are any cartridges), then the FlowRate is within that intersection:",
			MemberQ[incompatibleFlowRateErrors,True],
			False
		]
	];

	(* Throw an error if PreSampleEquilibration is specified and the resolved LoadingType is Preloaded *)
	incompatiblePreSampleEquilibrationOptions=If[MemberQ[incompatiblePreSampleEquilibrationErrors,True]&&messages,
		Message[Error::IncompatiblePreSampleEquilibration,
			PickList[specifiedPreSampleEquilibration,incompatiblePreSampleEquilibrationErrors]
		];
		{PreSampleEquilibration,LoadingType},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompatiblePreSampleEquilibration *)
	incompatiblePreSampleEquilibrationTest=If[gatherTests,
		Test["If PreSampleEquilibration is specified, LoadingType is not Preloaded:",
			MemberQ[incompatiblePreSampleEquilibrationErrors,True],
			False
		]
	];

	(* Throw an error if any of the shortcut gradient options are specified and any of the non-shortcut gradient options
	are specified and don't match the shortcut *)
	redundantGradientShortcutOptions=If[MemberQ[redundantGradientShortcutErrors,True]&&messages,
		Message[Error::RedundantGradientShortcut,
			ObjectToString[PickList[simulatedSamples,redundantGradientShortcutErrors],Cache->cacheBall]
		];
		{GradientStart,GradientEnd,GradientDuration,EquilibrationTime,FlushTime,Gradient,GradientA,GradientB},
		{}
	];

	(* If we are gathering tests, make a test for Error::RedundantGradientShortcut *)
	redundantGradientShortcutTest=If[gatherTests,
		Test["If shortcut gradient options and non-shortcut gradient options are specified together, they specify the same gradient:",
			MemberQ[redundantGradientShortcutErrors,True],
			False
		]
	];

	(* Throw an error if any of the gradient shortcut options are specified and all of GradientStart, GradientEnd,
	and GradientDuration are not specified *)
	incompleteGradientShortcutOptions=If[MemberQ[incompleteGradientShortcutErrors,True]&&messages,
		Message[Error::IncompleteGradientShortcut,
			ObjectToString[PickList[simulatedSamples,incompleteGradientShortcutErrors],Cache->cacheBall]
		];
		{GradientStart,GradientEnd,GradientDuration,EquilibrationTime,FlushTime},
		{}
	];

	(* If we are gathering tests, make a test for Error::IncompleteGradientShortcut *)
	incompleteGradientShortcutTest=If[gatherTests,
		Test["If any gradient shortcut options are specified, then GradientStart, GradientEnd, and GradientDuration are specified:",
			MemberQ[incompleteGradientShortcutErrors,True],
			False
		]
	];

	(* Throw an error if the gradient shortcut specification is complete but the total specified shortcut length is 0 Minute *)
	zeroGradientShortcutOptions=If[MemberQ[zeroGradientShortcutErrors,True]&&messages,
		Message[Error::ZeroGradientShortcut,
			ObjectToString[PickList[simulatedSamples,zeroGradientShortcutErrors],Cache->cacheBall]
		];
		{GradientStart,GradientEnd,GradientDuration,EquilibrationTime,FlushTime},
		{}
	];

	(* If we are gathering tests, make a test for Error::ZeroGradientShortcut *)
	zeroGradientShortcutTest=If[gatherTests,
		Test["If there is a complete gradient shortcut specification, its total length is greater than 0 minutes:",
			MemberQ[zeroGradientShortcutErrors,True],
			False
		]
	];

	(* Throw an error if more than one of GradientB, GradientA, and Gradient are specified and they
	do not match each other *)
	redundantGradientSpecificationOptions=If[MemberQ[redundantGradientSpecificationErrors,True]&&messages,
		Message[Error::RedundantGradientSpecification,
			ObjectToString[PickList[simulatedSamples,redundantGradientSpecificationErrors],Cache->cacheBall]
		];
		{Gradient,GradientA,GradientB},
		{}
	];

	(* If we are gathering tests, make a test for Error::RedundantGradientSpecification *)
	redundantGradientSpecificationTest=If[gatherTests,
		Test["If more than one of Gradient, GradientA, and GradientB are specified, they match each other:",
			MemberQ[redundantGradientSpecificationErrors,True],
			False
		]
	];

	(* Throw an error if GradientB is specified and
		the times do not start at 0 minutes,
		or the times do not end at greater than 0 minutes,
		or the times do not monotonically increase *)
	invalidGradientBTimeOptions=If[MemberQ[invalidGradientBTimeErrors,True]&&messages,
		Message[Error::InvalidGradientTime,
			GradientB,
			PickList[resolvedGradientB,invalidGradientBTimeErrors],
			PickList[specifiedGradientBTimes,invalidGradientBTimeErrors]
		];
		{GradientB},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidGradientTime *)
	invalidGradientBTimeTest=If[gatherTests,
		Test["If GradientB is specified, the times start at 0 minutes, end at greater than 0 minutes, and are monotonically increasing:",
			MemberQ[invalidGradientBTimeErrors,True],
			False
		]
	];

	(* Throw an error if GradientA is specified and
		the times do not start at 0 minutes,
		or the times do not end at greater than 0 minutes,
		or the times do not monotonically increase *)
	invalidGradientATimeOptions=If[MemberQ[invalidGradientATimeErrors,True]&&messages,
		Message[Error::InvalidGradientTime,
			GradientA,
			PickList[resolvedGradientA,invalidGradientATimeErrors],
			PickList[specifiedGradientATimes,invalidGradientATimeErrors]
		];
		{GradientA},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidGradientTime *)
	invalidGradientATimeTest=If[gatherTests,
		Test["If GradientA is specified, the times start at 0 minutes, end at greater than 0 minutes, and are monotonically increasing:",
			MemberQ[invalidGradientATimeErrors,True],
			False
		]
	];

	(* Throw an error if Gradient is specified and
		the times do not start at 0 minutes,
		or the times do not end at greater than 0 minutes,
		or the times do not monotonically increase *)
	invalidGradientTimeOptions=If[MemberQ[invalidGradientTimeErrors,True]&&messages,
		Message[Error::InvalidGradientTime,
			Gradient,
			PickList[resolvedGradient,invalidGradientTimeErrors],
			PickList[specifiedGradientTimes,invalidGradientTimeErrors]
		];
		{Gradient},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidGradientTime *)
	invalidGradientTimeTest=If[gatherTests,
		Test["If Gradient is specified, the times start at 0 minutes, end at greater than 0 minutes, and are monotonically increasing:",
			MemberQ[invalidGradientTimeErrors,True],
			False
		]
	];

	(* Throw an error if the total gradient time is greater than the max time allowed *)
	invalidTotalGradientTimeOptions=If[MemberQ[invalidTotalGradientTimeErrors,True]&&messages,
		Message[Error::InvalidTotalGradientTime,
			ObjectToString[PickList[simulatedSamples,invalidTotalGradientTimeErrors],Cache->cacheBall],
			PickList[resolvedTotalGradientBTimes,invalidTotalGradientTimeErrors],
			$MaxFlashChromatographyGradientTime
		];
		{GradientB},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidTotalGradientTime *)
	invalidTotalGradientTimeTest=If[gatherTests,
		Test["The total length of time of the resolved GradientB is less than or equal to "<>ToString[$MaxFlashChromatographyGradientTime]<>":",
			MemberQ[invalidTotalGradientTimeErrors,True],
			False
		]
	];

	(* Throw a warning if BufferB is methanol, the column or cartridge's packing material is silica,
	and the max BufferB percentage of the gradient is greater than 50%*)
	If[MemberQ[methanolPercentWarnings,True]&&messages&&notInEngine,
		Message[Warning::MethanolPercent,
			ObjectToString[PickList[simulatedSamples,methanolPercentWarnings],Cache->cacheBall],
			PickList[resolvedGradientB,methanolPercentWarnings]
		]
	];

	(* If we are gathering tests, make a test for Warning::MethanolPercent *)
	methanolPercentTest=If[gatherTests,
		Warning["If BufferB is methanol, and the column or cartridge is silica-based, the max BufferB percent in the gradient is 50%:",
			MemberQ[methanolPercentWarnings,True],
			False
		]
	];

	(* Throw an error if CollectFractions is True and any fraction collection-related options are Null *)
	invalidFractionCollectionOptions=If[MemberQ[invalidFractionCollectionOptionsErrors,True]&&messages,
		Message[Error::InvalidFractionCollectionOptions,
			ObjectToString[PickList[simulatedSamples,invalidFractionCollectionOptionsErrors],Cache->cacheBall],
			PickList[specifiedFractionCollectionStartTime,invalidFractionCollectionOptionsErrors],
			PickList[specifiedFractionCollectionEndTime,invalidFractionCollectionOptionsErrors],
			ObjectToString[PickList[specifiedFractionContainer,invalidFractionCollectionOptionsErrors],Cache->cacheBall],
			PickList[specifiedMaxFractionVolume,invalidFractionCollectionOptionsErrors],
			PickList[specifiedFractionCollectionMode,invalidFractionCollectionOptionsErrors]
		];
		{CollectFractions,FractionCollectionStartTime,FractionCollectionEndTime,FractionContainer,MaxFractionVolume,FractionCollectionMode},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidFractionCollectionOptions *)
	invalidFractionCollectionOptionsTest=If[gatherTests,
		Test["If CollectFractions is True, no fraction collection-related options (FractionCollectionStartTime, FractionCollectionEndTime, FractionContainer, MaxFractionVolume, and FractionCollectionMode) are Null:",
			MemberQ[invalidFractionCollectionOptionsErrors,True],
			False
		]
	];

	(* Throw an error if CollectFractions is False and any fraction collection-related options are specified *)
	invalidCollectFractionsOptions=If[MemberQ[invalidCollectFractionsErrors,True]&&messages,
		Message[Error::InvalidCollectFractions,
			ObjectToString[PickList[simulatedSamples,invalidCollectFractionsErrors],Cache->cacheBall],
			PickList[specifiedFractionCollectionStartTime,invalidCollectFractionsErrors],
			PickList[specifiedFractionCollectionEndTime,invalidCollectFractionsErrors],
			ObjectToString[PickList[specifiedFractionContainer,invalidCollectFractionsErrors],Cache->cacheBall],
			PickList[specifiedMaxFractionVolume,invalidCollectFractionsErrors],
			PickList[specifiedFractionCollectionMode,invalidCollectFractionsErrors]
		];
		{CollectFractions,FractionCollectionStartTime,FractionCollectionEndTime,FractionContainer,MaxFractionVolume,FractionCollectionMode},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidCollectFractions *)
	invalidCollectFractionsTest=If[gatherTests,
		Test["If CollectFractions is False, no fraction collection-related options (FractionCollectionStartTime, FractionCollectionEndTime, FractionContainer, MaxFractionVolume, and FractionCollectionMode) are specified:",
			MemberQ[invalidCollectFractionsErrors,True],
			False
		]
	];

	(* Throw an error if any fraction collection-related option is Null and any other is specified *)
	mismatchedFractionCollectionOptions=If[MemberQ[mismatchedFractionCollectionOptionsErrors,True]&&messages,
		Message[Error::MismatchedFractionCollectionOptions,
			ObjectToString[PickList[simulatedSamples,mismatchedFractionCollectionOptionsErrors],Cache->cacheBall],
			PickList[specifiedFractionCollectionStartTime,mismatchedFractionCollectionOptionsErrors],
			PickList[specifiedFractionCollectionEndTime,mismatchedFractionCollectionOptionsErrors],
			ObjectToString[PickList[specifiedFractionContainer,mismatchedFractionCollectionOptionsErrors],Cache->cacheBall],
			PickList[specifiedMaxFractionVolume,mismatchedFractionCollectionOptionsErrors],
			PickList[specifiedFractionCollectionMode,mismatchedFractionCollectionOptionsErrors]
		];
		{FractionCollectionStartTime,FractionCollectionEndTime,FractionContainer,MaxFractionVolume,FractionCollectionMode},
		{}
	];

	(* If we are gathering tests, make a test for Error::MismatchedFractionCollectionOptions *)
	mismatchedFractionCollectionOptionsTest=If[gatherTests,
		Test["If any of the fraction collection-related options (FractionCollectionStartTime, FractionCollectionEndTime, FractionContainer, MaxFractionVolume, and FractionCollectionMode) is specified, none of the others are Null, and vice versa:",
			MemberQ[mismatchedFractionCollectionOptionsErrors,True],
			False
		]
	];

	(* Throw an error if FractionCollectionStartTime is specified and it is greater than or equal to totalGradientBTime *)
	invalidFractionCollectionStartTimeOptions=If[MemberQ[invalidFractionCollectionStartTimeErrors,True]&&messages,
		Message[Error::InvalidFractionCollectionStartTimeFlash,
			PickList[specifiedFractionCollectionStartTime,invalidFractionCollectionStartTimeErrors],
			PickList[resolvedTotalGradientBTimes,invalidFractionCollectionStartTimeErrors]
		];
		{FractionCollectionStartTime},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidFractionCollectionStartTimeFlash *)
	invalidFractionCollectionStartTimeTest=If[gatherTests,
		Test["If FractionCollectionStartTime is specified, it is less than the total length of time of the resolved GradientB:",
			MemberQ[invalidFractionCollectionStartTimeErrors,True],
			False
		]
	];

	(* Throw an error if FractionCollectionEndTime is specified and it is less than or equal to the resolved
	FractionCollectionStartTime or greater than the totalGradientBTime *)
	invalidFractionCollectionEndTimeOptions=If[MemberQ[invalidFractionCollectionEndTimeErrors,True]&&messages,
		Message[Error::InvalidFractionCollectionEndTimeFlash,
			PickList[specifiedFractionCollectionEndTime,invalidFractionCollectionEndTimeErrors],
			PickList[resolvedTotalGradientBTimes,invalidFractionCollectionEndTimeErrors],
			PickList[resolvedFractionCollectionStartTime,invalidFractionCollectionEndTimeErrors]
		];
		{FractionCollectionEndTime,FractionCollectionStartTime},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidFractionCollectionEndTimeFlash *)
	invalidFractionCollectionEndTimeTest=If[gatherTests,
		Test["If FractionCollectionEndTime is specified, it is greater than the resolved FractionCollectionStartTime and less than or equal to the total length of time of the resolved GradientB:",
			MemberQ[invalidFractionCollectionEndTimeErrors,True],
			False
		]
	];

	(* Throw an error if FractionContainer is specified and it isn't in the list of allowed containers *)
	invalidFractionContainerOptions=If[MemberQ[invalidFractionContainerErrors,True]&&messages,
		Message[Error::InvalidFractionContainer,
			ObjectToString[PickList[specifiedFractionContainer,invalidFractionContainerErrors],Cache->cacheBall],
			ObjectToString[defaultContainers,Cache->cacheBall]
		];
		{FractionContainer},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidFractionContainer *)
	invalidFractionContainerTest=If[gatherTests,
		Test["If FractionContainer is specified, it is one of the allowed flash chromatography fraction collection containers:",
			MemberQ[invalidFractionContainerErrors,True],
			False
		]
	];

	(* Throw an error if MaxFractionVolume is specified, 80% of the resolved FractionContainer's MaxVolume is less than
	the specified MaxFractionVolume, and FractionContainer is specified *)
	invalidMaxFractionVolumeForContainerOptions=If[MemberQ[invalidMaxFractionVolumeForContainerErrors,True]&&messages,
		Message[Error::InvalidMaxFractionVolumeForContainer,
			PickList[specifiedMaxFractionVolume,invalidMaxFractionVolumeForContainerErrors],
			PickList[resolvedContainerMaxVolumes*fractionOfMaxVolume,invalidMaxFractionVolumeForContainerErrors],
			fractionOfMaxVolume,
			PickList[resolvedContainerMaxVolumes,invalidMaxFractionVolumeForContainerErrors],
			ObjectToString[PickList[specifiedFractionContainer,invalidMaxFractionVolumeForContainerErrors],Cache->cacheBall]
		];
		{MaxFractionVolume,FractionContainer},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidMaxFractionVolumeForContainer *)
	invalidMaxFractionVolumeForContainerTest=If[gatherTests,
		Test["If MaxFractionVolume is specified and FractionContainer is specified, the FractionContainer is large enough to hold MaxFractionVolume:",
			MemberQ[invalidMaxFractionVolumeForContainerErrors,True],
			False
		]
	];

	(* Throw an error if MaxFractionVolume is specified, 80% of the resolved FractionContainer's MaxVolume is less than
	the specified MaxFractionVolume, and FractionContainer is unspecified *)
	invalidMaxFractionVolumeOptions=If[MemberQ[invalidMaxFractionVolumeErrors,True]&&messages,
		Message[Error::InvalidMaxFractionVolume,
			PickList[specifiedMaxFractionVolume,invalidMaxFractionVolumeErrors],
			largestDefaultContainerMaxVolume*fractionOfMaxVolume,
			fractionOfMaxVolume,
			largestDefaultContainerMaxVolume,
			ObjectToString[largestDefaultContainer,Cache->cacheBall]
		];
		{MaxFractionVolume},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidMaxFractionVolume *)
	invalidMaxFractionVolumeTest=If[gatherTests,
		Test["If MaxFractionVolume is specified and FractionContainer is unspecified, there is at least one default fraction collection container large enough to hold MaxFractionVolume:",
			MemberQ[invalidMaxFractionVolumeErrors,True],
			False
		]
	];

	(* Throw an error if any of the detector options are specified and aren't in detectorsList *)
	invalidSpecifiedDetectorsOptions=If[MemberQ[invalidSpecifiedDetectorsErrors,True]&&messages,
		Message[Error::InvalidSpecifiedDetectors,
			ObjectToString[PickList[simulatedSamples,invalidSpecifiedDetectorsErrors],Cache->cacheBall],
			PickList[specifiedPrimaryWavelength,invalidSpecifiedDetectorsErrors],
			PickList[specifiedSecondaryWavelength,invalidSpecifiedDetectorsErrors],
			PickList[specifiedWideRangeUV,invalidSpecifiedDetectorsErrors],
			PickList[resolvedDetectorsLists,invalidSpecifiedDetectorsErrors]
		];
		{Detectors,PrimaryWavelength,SecondaryWavelength,WideRangeUV},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidSpecifiedDetectors *)
	invalidSpecifiedDetectorsTest=If[gatherTests,
		Test["Any specified detector options (PrimaryWavelength, SecondaryWavelength, or WideRangeUV) are included in the Detectors option:",
			MemberQ[invalidSpecifiedDetectorsErrors,True],
			False
		]
	];

	(* Throw an error if any of the detector options are Null and are in detectorsList *)
	invalidNullDetectorsOptions=If[MemberQ[invalidNullDetectorsErrors,True]&&messages,
		Message[Error::InvalidNullDetectors,
			ObjectToString[PickList[simulatedSamples,invalidNullDetectorsErrors],Cache->cacheBall],
			PickList[specifiedPrimaryWavelength,invalidNullDetectorsErrors],
			PickList[specifiedSecondaryWavelength,invalidNullDetectorsErrors],
			PickList[specifiedWideRangeUV,invalidNullDetectorsErrors],
			PickList[resolvedDetectorsLists,invalidNullDetectorsErrors]
		];
		{Detectors,PrimaryWavelength,SecondaryWavelength,WideRangeUV},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidNullDetectors *)
	invalidNullDetectorsTest=If[gatherTests,
		Test["Any Null detector options (PrimaryWavelength, SecondaryWavelength, or WideRangeUV) are not included in the Detectors option:",
			MemberQ[invalidNullDetectorsErrors,True],
			False
		]
	];

	(* Throw an error if WideRangeUV is specified to a Span and the first element of the Span is larger than the second *)
	invalidWideRangeUVOptions=If[MemberQ[invalidWideRangeUVErrors,True]&&messages,
		Message[Error::InvalidWideRangeUV,
			ObjectToString[PickList[simulatedSamples,invalidWideRangeUVErrors],Cache->cacheBall],
			PickList[specifiedWideRangeUV,invalidWideRangeUVErrors]
		];
		{WideRangeUV},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidWideRangeUV *)
	invalidWideRangeUVTest=If[gatherTests,
		Test["If WideRangeUV is specified to a Span of wavelengths, the first element of the span is less than or equal to the second element:",
			MemberQ[invalidWideRangeUVErrors,True],
			False
		]
	];

	(* Throw an error if PeakDetectors is specified and detectorsList doesn't contain all elements of PeakDetectors *)
	missingPeakDetectorsOptions=If[MemberQ[missingPeakDetectorsErrors,True]&&messages,
		Message[Error::MissingPeakDetectors,
			ObjectToString[PickList[simulatedSamples,missingPeakDetectorsErrors],Cache->cacheBall],
			PickList[specifiedPeakDetectors,missingPeakDetectorsErrors],
			PickList[resolvedDetectorsLists,missingPeakDetectorsErrors]
		];
		{PeakDetectors,Detectors},
		{}
	];

	(* If we are gathering tests, make a test for Error::MissingPeakDetectors *)
	missingPeakDetectorsTest=If[gatherTests,
		Test["All detectors included in PeakDetectors are also included in Detectors:",
			MemberQ[missingPeakDetectorsErrors,True],
			False
		]
	];

	(*- These invalidOptions and tests are identical for each detector's associated options, so map over the detectors -*)

	(* Get lists of the peak detection-related option names *)
	peakDetectionMethodOptions={
		PrimaryWavelengthPeakDetectionMethod,
		SecondaryWavelengthPeakDetectionMethod,
		WideRangeUVPeakDetectionMethod
	};
	peakWidthOptions={
		PrimaryWavelengthPeakWidth,
		SecondaryWavelengthPeakWidth,
		WideRangeUVPeakWidth
	};
	peakThresholdOptions={
		PrimaryWavelengthPeakThreshold,
		SecondaryWavelengthPeakThreshold,
		WideRangeUVPeakThreshold
	};

	(* Get lists of the specified peak detection-related options *)
	specifiedPeakDetectionMethodList={
		specifiedPrimaryWavelengthPeakDetectionMethod,
		specifiedSecondaryWavelengthPeakDetectionMethod,
		specifiedWideRangeUVPeakDetectionMethod
	};
	specifiedPeakWidthList={
		specifiedPrimaryWavelengthPeakWidth,
		specifiedSecondaryWavelengthPeakWidth,
		specifiedWideRangeUVPeakWidth
	};
	specifiedPeakThresholdList={
		specifiedPrimaryWavelengthPeakThreshold,
		specifiedSecondaryWavelengthPeakThreshold,
		specifiedWideRangeUVPeakThreshold
	};

	(* Get a list of the resolved PeakDetectionMethod options*)
	resolvedPeakDetectionMethodList={
		resolvedPrimaryWavelengthPeakDetectionMethod,
		resolvedSecondaryWavelengthPeakDetectionMethod,
		resolvedWideRangeUVPeakDetectionMethod
	};

	(* Get lists of each set of error tracking Booleans *)
	invalidSpecifiedPeakDetectionErrorsList={
		invalidSpecifiedPrimaryWavelengthPeakDetectionErrors,
		invalidSpecifiedSecondaryWavelengthPeakDetectionErrors,
		invalidSpecifiedWideRangeUVPeakDetectionErrors
	};
	invalidNullPeakDetectionMethodErrorsList={
		invalidNullPrimaryWavelengthPeakDetectionMethodErrors,
		invalidNullSecondaryWavelengthPeakDetectionMethodErrors,
		invalidNullWideRangeUVPeakDetectionMethodErrors
	};
	invalidNullPeakDetectionParametersErrorsList={
		invalidNullPrimaryWavelengthPeakDetectionParametersErrors,
		invalidNullSecondaryWavelengthPeakDetectionParametersErrors,
		invalidNullWideRangeUVPeakDetectionParametersErrors
	};
	invalidPeakWidthErrorsList={
		invalidPrimaryWavelengthPeakWidthErrors,
		invalidSecondaryWavelengthPeakWidthErrors,
		invalidWideRangeUVPeakWidthErrors
	};
	invalidPeakThresholdErrorsList={
		invalidPrimaryWavelengthPeakThresholdErrors,
		invalidSecondaryWavelengthPeakThresholdErrors,
		invalidWideRangeUVPeakThresholdErrors
	};

	(* MapThread over the three detectors to get all the invalidOptions and Tests *)
	{
		invalidPeakDetectionOptions,
		invalidPeakDetectionTests
	}=Transpose[
		MapThread[
			Function[
				{
					detectorOption,
					peakDetectionMethodOption,
					peakWidthOption,
					peakThresholdOption,

					specifiedPeakDetectionMethod,
					specifiedPeakWidth,
					specifiedPeakThreshold,

					resolvedPeakDetectionMethod,

					invalidSpecifiedPeakDetectionErrors,
					invalidNullPeakDetectionMethodErrors,
					invalidNullPeakDetectionParametersErrors,
					invalidPeakWidthErrors,
					invalidPeakThresholdErrors
				},
				Module[{
					invalidSpecifiedPeakDetectionOption,invalidSpecifiedPeakDetectionTest,
					invalidNullPeakDetectionMethodOption,invalidNullPeakDetectionMethodTest,
					invalidNullPeakDetectionParametersOption,invalidNullPeakDetectionParametersTest,
					invalidPeakWidthOption,invalidPeakWidthTest,
					invalidPeakThresholdOption,invalidPeakThresholdTest
				},

					(* Throw an error if any peak detection-related option is specified and the detector is not in PeakDetectors *)
					invalidSpecifiedPeakDetectionOption=If[MemberQ[invalidSpecifiedPeakDetectionErrors,True]&&messages,
						Message[Error::InvalidSpecifiedPeakDetection,
							ObjectToString[PickList[simulatedSamples,invalidSpecifiedPeakDetectionErrors],Cache->cacheBall],
							peakDetectionMethodOption,
							PickList[specifiedPeakDetectionMethod,invalidSpecifiedPeakDetectionErrors],
							peakWidthOption,
							PickList[specifiedPeakWidth,invalidSpecifiedPeakDetectionErrors],
							peakThresholdOption,
							PickList[specifiedPeakThreshold,invalidSpecifiedPeakDetectionErrors],
							detectorOption,
							PickList[resolvedPeakDetectors,invalidSpecifiedPeakDetectionErrors]
						];
						{PeakDetectors,peakDetectionMethodOption,peakWidthOption,peakThresholdOption},
						{}
					];

					(* If we are gathering tests, make a test for Error::InvalidSpecifiedPeakDetection *)
					invalidSpecifiedPeakDetectionTest=If[gatherTests,
						Test["If any "<>ToString[detectorOption]<>"-related options are specified, "<>ToString[detectorOption]<>" is included in PeakDetectors:",
							MemberQ[invalidSpecifiedPeakDetectionErrors,True],
							False
						]
					];

					(* Throw an error if PeakDetectionMethod is Null and the detector is in PeakDetectors *)
					invalidNullPeakDetectionMethodOption=If[MemberQ[invalidNullPeakDetectionMethodErrors,True]&&messages,
						Message[Error::InvalidNullPeakDetectionMethod,
							ObjectToString[PickList[simulatedSamples,invalidNullPeakDetectionMethodErrors],Cache->cacheBall],
							peakDetectionMethodOption,
							detectorOption,
							PickList[resolvedPeakDetectors,invalidNullPeakDetectionMethodErrors]
						];
						{PeakDetectors,peakDetectionMethodOption},
						{}
					];

					(* If we are gathering tests, make a test for Error::InvalidNullPeakDetectionMethod *)
					invalidNullPeakDetectionMethodTest=If[gatherTests,
						Test["If "<>ToString[peakDetectionMethodOption]<>" is Null, "<>ToString[detectorOption]<>" is not included in PeakDetectors:",
							MemberQ[invalidNullPeakDetectionMethodErrors,True],
							False
						]
					];

					(* Throw an error if both PeakWidth and PeakThreshold are Null and the detector is in PeakDetectors *)
					invalidNullPeakDetectionParametersOption=If[MemberQ[invalidNullPeakDetectionParametersErrors,True]&&messages,
						Message[Error::InvalidNullPeakDetectionParameters,
							ObjectToString[PickList[simulatedSamples,invalidNullPeakDetectionParametersErrors],Cache->cacheBall],
							peakWidthOption,
							peakThresholdOption,
							detectorOption,
							PickList[resolvedPeakDetectors,invalidNullPeakDetectionParametersErrors]
						];
						{PeakDetectors,peakWidthOption,peakThresholdOption},
						{}
					];

					(* If we are gathering tests, make a test for Error::InvalidNullPeakDetectionParameters *)
					invalidNullPeakDetectionParametersTest=If[gatherTests,
						Test["If "<>ToString[peakWidthOption]<>" and "<>ToString[peakThresholdOption]<>" are both Null, "<>ToString[detectorOption]<>" is not included in PeakDetectors:",
							MemberQ[invalidNullPeakDetectionParametersErrors,True],
							False
						]
					];

					(* Throw an error if PeakWidth is specified and peakDetectionMethod doesn't include Slope *)
					invalidPeakWidthOption=If[MemberQ[invalidPeakWidthErrors,True]&&messages,
						Message[Error::InvalidPeakWidth,
							ObjectToString[PickList[simulatedSamples,invalidPeakWidthErrors],Cache->cacheBall],
							peakWidthOption,
							PickList[specifiedPeakWidth,invalidPeakWidthErrors],
							peakDetectionMethodOption,
							PickList[resolvedPeakDetectionMethod,invalidPeakWidthErrors]
						];
						{peakDetectionMethodOption,peakWidthOption},
						{}
					];

					(* If we are gathering tests, make a test for Error::InvalidPeakWidth *)
					invalidPeakWidthTest=If[gatherTests,
						Test["If "<>ToString[peakWidthOption]<>" is specified, "<>ToString[peakDetectionMethodOption]<>" includes Slope:",
							MemberQ[invalidPeakWidthErrors,True],
							False
						]
					];

					(* Throw an error if PeakThreshold is specified and peakDetectionMethod doesn't include Threshold *)
					invalidPeakThresholdOption=If[MemberQ[invalidPeakThresholdErrors,True]&&messages,
						Message[Error::InvalidPeakThreshold,
							ObjectToString[PickList[simulatedSamples,invalidPeakThresholdErrors],Cache->cacheBall],
							peakThresholdOption,
							PickList[specifiedPeakThreshold,invalidPeakThresholdErrors],
							peakDetectionMethodOption,
							PickList[resolvedPeakDetectionMethod,invalidPeakThresholdErrors]
						];
						{peakDetectionMethodOption,peakThresholdOption},
						{}
					];

					(* If we are gathering tests, make a test for Error::InvalidPeakThreshold *)
					invalidPeakThresholdTest=If[gatherTests,
						Test["If "<>ToString[peakThresholdOption]<>" is specified, "<>ToString[peakDetectionMethodOption]<>" includes Threshold:",
							MemberQ[invalidPeakThresholdErrors,True],
							False
						]
					];

					(* Return invalidOptions and Tests out of the MapThread *)
					{
						{
							invalidSpecifiedPeakDetectionOption,
							invalidNullPeakDetectionMethodOption,
							invalidNullPeakDetectionParametersOption,
							invalidPeakWidthOption,
							invalidPeakThresholdOption
						},
						{
							invalidSpecifiedPeakDetectionTest,
							invalidNullPeakDetectionMethodTest,
							invalidNullPeakDetectionParametersTest,
							invalidPeakWidthTest,
							invalidPeakThresholdTest
						}
					}
				]
			],
			(* Arguments to the Function. Each is three elements long:
			PrimaryWavelength, SecondaryWavelength, and WideRangeUV *)
			{
				detectorOptions,
				peakDetectionMethodOptions,
				peakWidthOptions,
				peakThresholdOptions,

				specifiedPeakDetectionMethodList,
				specifiedPeakWidthList,
				specifiedPeakThresholdList,

				resolvedPeakDetectionMethodList,

				invalidSpecifiedPeakDetectionErrorsList,
				invalidNullPeakDetectionMethodErrorsList,
				invalidNullPeakDetectionParametersErrorsList,
				invalidPeakWidthErrorsList,
				invalidPeakThresholdErrorsList
			}
		]
	];

	(* Throw an error if ColumnStorageCondition is specified to Disposal and the Column is an
	Object[Item,Column] that is also specified for a later input sample *)
	invalidColumnStorageConditionOptions=If[MemberQ[invalidColumnStorageConditionErrors,True]&&messages,
		Message[Error::InvalidColumnStorageCondition,
			ObjectToString[PickList[simulatedSamples,invalidColumnStorageConditionErrors],Cache->cacheBall],
			ObjectToString[PickList[resolvedColumn,invalidColumnStorageConditionErrors],Cache->cacheBall]
		];
		{Column,ColumnStorageCondition},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidColumnStorageCondition *)
	invalidColumnStorageConditionTest=If[gatherTests,
		Test["If ColumnStorageCondition is not specified to Disposal for any specified Object[Item,Column] that will be used again for a later sample:",
			MemberQ[invalidColumnStorageConditionErrors,True],
			False
		]
	];

	(* Throw an error if AirPurgeDuration is specified to 0 Minute or Null and ColumnStorageCondition is Disposal *)
	invalidAirPurgeDurationOptions=If[MemberQ[invalidAirPurgeDurationErrors,True]&&messages,
		Message[Error::InvalidAirPurgeDuration,
			ObjectToString[PickList[simulatedSamples,invalidAirPurgeDurationErrors],Cache->cacheBall],
			ObjectToString[PickList[resolvedColumn,invalidAirPurgeDurationErrors],Cache->cacheBall],
			PickList[specifiedAirPurgeDuration,invalidAirPurgeDurationErrors],
			PickList[resolvedColumnStorageCondition,invalidAirPurgeDurationErrors]
		];
		{AirPurgeDuration,ColumnStorageCondition},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidAirPurgeDuration *)
	invalidAirPurgeDurationTest=If[gatherTests,
		Test["If ColumnStorageCondition is Disposal, AirPurgeDuration is greater than 0 minutes:",
			MemberQ[invalidAirPurgeDurationErrors,True],
			False
		]
	];

	(* Throw a warning if AirPurgeDuration is specified to > 0 Minute and ColumnStorageCondition is not Disposal *)
	If[MemberQ[airPurgeAndStoreColumnWarnings,True]&&messages&&notInEngine,
		Message[Warning::AirPurgeAndStoreColumn,
			ObjectToString[PickList[simulatedSamples,airPurgeAndStoreColumnWarnings],Cache->cacheBall],
			ObjectToString[PickList[resolvedColumn,airPurgeAndStoreColumnWarnings],Cache->cacheBall],
			PickList[specifiedAirPurgeDuration,airPurgeAndStoreColumnWarnings],
			PickList[resolvedColumnStorageCondition,airPurgeAndStoreColumnWarnings]
		]
	];

	(* If we are gathering tests, make a test for Warning::AirPurgeAndStoreColumn *)
	airPurgeAndStoreColumnTest=If[gatherTests,
		Warning["If ColumnStorageCondition is not Disposal, AirPurgeDuration is 0 minutes or Null:",
			MemberQ[airPurgeAndStoreColumnWarnings,True],
			False
		]
	];

	(* Throw an error if CartridgeLabel is specified to Null and the resolved Cartridge is not Null *)
	invalidNullCartridgeLabelOptions=If[MemberQ[invalidNullCartridgeLabelErrors,True]&&messages,
		Message[Error::InvalidNullCartridgeLabel,
			ObjectToString[PickList[simulatedSamples,invalidNullCartridgeLabelErrors],Cache->cacheBall],
			ObjectToString[PickList[resolvedCartridge,invalidNullCartridgeLabelErrors],Cache->cacheBall],
			PickList[resolvedCartridgeLabel,invalidNullCartridgeLabelErrors]
		];
		{Cartridge,CartridgeLabel},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidNullCartridgeLabel *)
	invalidNullCartridgeLabelTest=If[gatherTests,
		Test["If CartridgeLabel is Null, Cartridge is Null:",
			MemberQ[invalidNullCartridgeLabelErrors,True],
			False
		]
	];

	(* Throw an error if CartridgeLabel is specified to a String and the resolved Cartridge is Null *)
	invalidSpecifiedCartridgeLabelOptions=If[MemberQ[invalidSpecifiedCartridgeLabelErrors,True]&&messages,
		Message[Error::InvalidSpecifiedCartridgeLabel,
			ObjectToString[PickList[simulatedSamples,invalidSpecifiedCartridgeLabelErrors],Cache->cacheBall],
			ObjectToString[PickList[resolvedCartridge,invalidSpecifiedCartridgeLabelErrors],Cache->cacheBall],
			PickList[resolvedCartridgeLabel,invalidSpecifiedCartridgeLabelErrors]
		];
		{Cartridge,CartridgeLabel},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidSpecifiedCartridgeLabel *)
	invalidSpecifiedCartridgeLabelTest=If[gatherTests,
		Test["If CartridgeLabel is a String, Cartridge is a solid load cartridge:",
			MemberQ[invalidSpecifiedCartridgeLabelErrors,True],
			False
		]
	];

	(*- Label Duplicate Tests -*)

	(* MapThread over SamplesIn, ContainersIn, Column and Container to check for:
		duplicate Objects referred to by different Labels
		and duplicate Labels referring to different Objects or Models *)
	{
		invalidLabelOptions,
		invalidLabelTests
	}=Transpose[
		MapThread[
			Function[{optionName,labelOptionName,objectType,resolvedOption,resolvedLabelOption},
				Module[{
					objectTally,labelTally,duplicateObjects,duplicateLabels,labelLists,objectLists,
					invalidObjectLabelErrors,invalidLabelErrors,invalidDuplicateObjects,invalidDuplicateLabels,
					indexedInvalidDuplicateObjects,indexedInvalidDuplicateObjectLabels,invalidObjectLabelOption,invalidObjectLabelTest,
					indexedInvalidDuplicateLabels,indexedInvalidDuplicateLabelObjects,invalidLabelOption,invalidLabelTest
				},

					(* Get a tally of all Objects in the resolved option *)
					objectTally=Tally[Cases[resolvedOption,ObjectReferenceP[objectType]]];

					(* Get a tally of all Strings in the resolved Label option *)
					labelTally=Tally[Cases[resolvedLabelOption,_String]];

					(* Get a list of all Objects that appear more than once in the resolved option *)
					duplicateObjects=PickList[First/@objectTally,Last/@objectTally,GreaterP[1]];

					(* Get a list of all Labels that appear more than once in the resolved Label option *)
					duplicateLabels=PickList[First/@labelTally,Last/@labelTally,GreaterP[1]];

					(* Get lists of the Labels of any duplicate Objects *)
					labelLists=PickList[resolvedLabelOption,resolvedOption,ObjectReferenceP[#]]&/@duplicateObjects;

					(* Get lists of the Objects or Models referred to by any duplicate Labels *)
					objectLists=PickList[resolvedOption,resolvedLabelOption,#]&/@duplicateLabels;

					(* Flip error switches if any of the duplicate Objects have different Labels *)
					invalidObjectLabelErrors=TrueQ[Length[Union[#]]>1]&/@labelLists;

					(* Flip error switches if any of the duplicate Labels refer to different Objects or Models *)
					invalidLabelErrors=TrueQ[Length[Union[#]]>1]&/@objectLists;

					(* Get a list of the duplicate Objects that have non-identical Labels *)
					invalidDuplicateObjects=PickList[duplicateObjects,invalidObjectLabelErrors];

					(* Get a list of the duplicate Labels that have non-identical Objects or Models *)
					invalidDuplicateLabels=PickList[duplicateLabels,invalidLabelErrors];

					(* Get lists of any invalid duplicate Objects and their labels index-matched to each other *)
					indexedInvalidDuplicateObjects=PickList[resolvedOption,MemberQ[invalidDuplicateObjects,#]&/@resolvedOption];
					indexedInvalidDuplicateObjectLabels=PickList[resolvedLabelOption,MemberQ[invalidDuplicateObjects,#]&/@resolvedOption];

					(* Throw an error if any duplicate Objects have different Labels *)
					invalidObjectLabelOption=If[MemberQ[invalidObjectLabelErrors,True]&&messages,
						Message[Error::InvalidLabel,
							optionName,
							ObjectToString[indexedInvalidDuplicateObjects,Cache->cacheBall],
							labelOptionName,
							indexedInvalidDuplicateObjectLabels,
							objectType
						];
						{optionName,labelOptionName},
						{}
					];

					(* If we are gathering tests, make a test for Error::InvalidLabel *)
					invalidObjectLabelTest=If[gatherTests,
						Test["If there are duplicate "<>ToString[objectType]<>" in "<>ToString[optionName]<>", they all have the same "<>ToString[labelOptionName]<>":",
							MemberQ[invalidObjectLabelErrors,True],
							False
						]
					];

					(* Get lists of any invalid duplicate Labels and the Objects or Models they refer to index-matched to each other *)
					indexedInvalidDuplicateLabels=PickList[resolvedLabelOption,MemberQ[invalidDuplicateLabels,#]&/@resolvedLabelOption];
					indexedInvalidDuplicateLabelObjects=PickList[resolvedOption,MemberQ[invalidDuplicateLabels,#]&/@resolvedLabelOption];

					(* Throw an error if any duplicate Labels refer to different Objects or Models *)
					invalidLabelOption=If[MemberQ[invalidLabelErrors,True]&&messages,
						Message[Error::InvalidLabel,
							labelOptionName,
							indexedInvalidDuplicateLabels,
							optionName,
							ObjectToString[indexedInvalidDuplicateLabelObjects,Cache->cacheBall],
							String
						];
						{optionName,labelOptionName},
						{}
					];

					(* If we are gathering tests, make a test for Error::InvalidLabel *)
					invalidLabelTest=If[gatherTests,
						Test["If there are duplicate Labels in "<>ToString[labelOptionName]<>", they all refer to the same Object or Model:",
							MemberQ[invalidLabelErrors,True],
							False
						]
					];

					(* Return the invalidOptions and Tests *)
					{
						{invalidObjectLabelOption,invalidLabelOption},
						{invalidObjectLabelTest,invalidLabelTest}
					}
				]
			],
			(* Arguments to the function: *)
			{
				(* The option names *)
				{SamplesIn,ContainersIn,Column,Cartridge},

				(* The option label names *)
				{SampleLabel,SampleContainerLabel,ColumnLabel,CartridgeLabel},

				(* The object types *)
				{Object[Sample],Object[Container],Object[Item,Column],Object[Container,ExtractionCartridge]},

				(* The lists of columns or cartridges that are labeled *)
				{myInputSamples,myInputSampleContainers,resolvedColumn,resolvedCartridge},

				(* And lists of their labels *)
				{resolvedSampleLabel,resolvedSampleContainerLabel,resolvedColumnLabel,resolvedCartridgeLabel}
			}
		]
	];

	(*- Total buffer volume tests -*)

	(* Get the total volume required of each buffer *)
	{
		requiredBufferAVolume,
		requiredBufferBVolume
	}=flashChromatographyBufferVolumes[resolvedFlowRate,resolvedPreSampleEquilibration,resolvedGradientA,resolvedGradientB];

	(* Map over buffer A and B to test whether too much buffer is required *)
	{
		invalidTotalBufferVolumeOptions,
		invalidTotalBufferVolumeTests
	}=Transpose[
		MapThread[
			Function[{bufferName,requiredBufferVolume},
				Module[{invalidTotalBufferVolumeError,invalidTotalBufferVolumeOption,invalidTotalBufferVolumeTest},

					(* Flip an error switch if too much buffer is required *)
					invalidTotalBufferVolumeError=TrueQ[requiredBufferVolume>$MaxFlashChromatographyBufferVolume];

					(* Throw an error if too much buffer is required *)
					invalidTotalBufferVolumeOption=If[invalidTotalBufferVolumeError&&messages,
						Message[Error::InvalidTotalBufferVolume,
							bufferName,
							Convert[requiredBufferVolume,Liter],
							$MaxFlashChromatographyBufferVolume
						];
						{Gradient,GradientA,GradientB,FlowRate,Column},
						{}
					];

					(* If we are gathering tests, make a test for Error::InvalidTotalBufferVolume *)
					invalidTotalBufferVolumeTest=If[gatherTests,
						Test["The total required volume of "<>ToString[bufferName]<>" is less than "<>ToString[$MaxFlashChromatographyBufferVolume]<>":",
							invalidTotalBufferVolumeError,
							False
						]
					];

					(* Return the invalidOption and Test *)
					{
						invalidTotalBufferVolumeOption,
						invalidTotalBufferVolumeTest
					}
				]
			],
			(* Arguments to the function: *)
			{
				{BufferA,BufferB},
				{requiredBufferAVolume,requiredBufferBVolume}
			}
		]
	];

	(* Number of racks tests *)

	(* Get a list of the numbers of fraction containers needed for each sample *)
	maxNumbersOfFractionContainers=flashChromatographyNumbersOfContainers[resolvedCollectFractions,resolvedFractionCollectionStartTime,resolvedFractionCollectionEndTime,resolvedFlowRate,resolvedMaxFractionVolume];

	(* Get a list of the rack model required for each sample *)
	fractionContainerRackModels=flashChromatographyRackModels[resolvedFractionContainer];

	(* Get the NumberOfPositions of each required rack model *)
	numbersOfPositions=Map[
		Lookup[fetchModelPacketFromFastAssoc[#,fastAssoc],NumberOfPositions,Null]&,
		fractionContainerRackModels
	];

	(* To get the preferred number of required racks for each sample, divide the max number of required containers for the sample by
	the number of positions in the rack then round up to the nearest integer *)
	preferredNumbersOfRacks=Ceiling[maxNumbersOfFractionContainers/numbersOfPositions];

	(* Flip error switches if more than 2 racks are preferred for any sample for which FractionCollectionMode is All *)
	invalidTotalFractionVolumeErrors=MapThread[
		And[
			TrueQ[#1>2],
			MatchQ[#2,All]
		]&,
		{preferredNumbersOfRacks,resolvedFractionCollectionMode}
	];

	(* Throw an error if more than 2 racks are preferred for any sample for which FractionCollectionMode is All *)
	invalidTotalFractionVolumeOptions=If[MemberQ[invalidTotalFractionVolumeErrors,True]&&messages,
		Message[Error::InvalidTotalFractionVolume,
			ObjectToString[PickList[simulatedSamples,invalidTotalFractionVolumeErrors],Cache->cacheBall],
			ObjectToString[PickList[resolvedFractionContainer,invalidTotalFractionVolumeErrors],Cache->cacheBall],
			PickList[maxNumbersOfFractionContainers,invalidTotalFractionVolumeErrors],
			PickList[numbersOfPositions*2,invalidTotalFractionVolumeErrors],
			ObjectToString[PickList[fractionContainerRackModels,invalidTotalFractionVolumeErrors],Cache->cacheBall]

		];
		{FractionCollectionMode,FractionContainer,FractionCollectionStartTime,FractionCollectionEndTime,MaxFractionVolume},
		{}
	];

	(* If we are gathering tests, make a test for Error::InvalidTotalFractionVolume *)
	invalidTotalFractionVolumeTest=If[gatherTests,
		Test["If FractionCollectionMode is All, the collected fractions can be held in less than or equal to 2 fraction collection racks:",
			MemberQ[invalidTotalFractionVolumeErrors,True],
			False
		]
	];

	(* Flip warning switches if more than 2 racks are preferred for any sample for which FractionCollectionMode is Peaks *)
	totalFractionVolumeWarnings=MapThread[
		And[
			TrueQ[#1>2],
			MatchQ[#2,Peaks]
		]&,
		{preferredNumbersOfRacks,resolvedFractionCollectionMode}
	];

	(* Throw a warning if more than 2 racks are preferred for any sample for which FractionCollectionMode is All *)
	If[MemberQ[totalFractionVolumeWarnings,True]&&messages&&notInEngine,
		Message[Warning::TotalFractionVolume,
			ObjectToString[PickList[simulatedSamples,totalFractionVolumeWarnings],Cache->cacheBall],
			ObjectToString[PickList[resolvedFractionContainer,totalFractionVolumeWarnings],Cache->cacheBall],
			PickList[maxNumbersOfFractionContainers,totalFractionVolumeWarnings],
			PickList[numbersOfPositions*2,totalFractionVolumeWarnings],
			ObjectToString[PickList[fractionContainerRackModels,totalFractionVolumeWarnings],Cache->cacheBall]
		]
	];

	(* If we are gathering tests, make a test for Warning::TotalFractionVolume *)
	totalFractionVolumeTest=If[gatherTests,
		Warning["If FractionCollectionMode is Peaks, the maximum number of possible collected fractions can be held in less than or equal to 2 fraction collection racks:",
			MemberQ[totalFractionVolumeWarnings,True],
			False
		]
	];















	(*--- Post-MapThread option resolution  ---*)

	(* Get the options needed to resolve Email and Operator and to check for Error::DuplicateName. *)
	{
		specifiedOperator,
		upload,
		specifiedEmail,
		specifiedName
	}=Lookup[myOptions,{Operator,Upload,Email,Name}];

	(* Adjust the email option based on the upload option *)
	resolvedEmail=If[!MatchQ[specifiedEmail,Automatic],
		specifiedEmail,
		upload&&MemberQ[output,Result]
	];

	(* Resolve the operator option *)
	resolvedOperator=If[NullQ[specifiedOperator],Model[User,Emerald,Operator,"Level 2"],specifiedOperator];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* Check if the name is used already. We will only make one protocol, so don't need to worry about appending index. *)
	nameInvalidBool=StringQ[specifiedName]&&TrueQ[DatabaseMemberQ[Append[Object[Protocol,FlashChromatography],specifiedName]]];

	(* NOTE: unique *)
	(* If the name is invalid, will add it to the list if invalid options later *)
	nameInvalidOption=If[nameInvalidBool&&messages,
		(
			Message[Error::DuplicateName,Object[Protocol,FlashChromatography]];
			{Name}
		),
		{}
	];
	nameInvalidTest=If[gatherTests,
		Test["The specified Name is unique:",False,nameInvalidBool],
		Nothing
	];

	(* add the sample prep options to the options being passed into resolveAliquotOptions *)
	optionsForAliquot=ReplaceRule[myOptions,resolvedSamplePrepOptions];

	(* Resolve Aliquot Options *)
	{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
		resolveAliquotOptions[
			ExperimentFlashChromatography,
			myInputSamples,
			simulatedSamples,
			optionsForAliquot,
			RequiredAliquotAmounts->Null,
			RequiredAliquotContainers->Null,
			AliquotWarningMessage->Null,
			MinimizeTransfers->False,
			AllowSolids->False,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			Output->{Result,Tests}
		],
		{resolveAliquotOptions[
			ExperimentFlashChromatography,
			myInputSamples,
			simulatedSamples,
			optionsForAliquot,
			RequiredAliquotAmounts->Null,
			RequiredAliquotContainers->Null,
			AliquotWarningMessage->Null,
			MinimizeTransfers->False,
			AllowSolids->False,
			Cache->cacheBall,
			Simulation->updatedSimulation,
			Output->Result
		],{}}
	];

	(* Gather all the resolved options together *)
	(* Doing this ReplaceRule ensures that any newly-added defaulted ProtocolOptions are going to be just included in myOptions*)
	resolvedOptions=ReplaceRule[
		myOptions,
		Flatten[{
			Preparation->resolvedPreparation,
			Instrument->resolvedInstrument,
			Detector->resolvedDetector,
			SeparationMode->resolvedSeparationMode,
			BufferA->resolvedBufferA,
			BufferB->resolvedBufferB,
			LoadingType->resolvedLoadingType,
			MaxLoadingPercent->resolvedMaxLoadingPercent,
			Column->resolvedColumn,
			LoadingAmount->resolvedLoadingAmount,
			Cartridge->resolvedCartridge,
			CartridgePackingMaterial->resolvedCartridgePackingMaterial,
			CartridgeFunctionalGroup->resolvedCartridgeFunctionalGroup,
			CartridgePackingMass->resolvedCartridgePackingMass,
			CartridgeDryingTime->resolvedCartridgeDryingTime,
			FlowRate->resolvedFlowRate,
			PreSampleEquilibration->resolvedPreSampleEquilibration,
			GradientStart->resolvedGradientStart,
			GradientEnd->resolvedGradientEnd,
			GradientDuration->resolvedGradientDuration,
			EquilibrationTime->resolvedEquilibrationTime,
			FlushTime->resolvedFlushTime,
			GradientB->resolvedGradientB,
			GradientA->resolvedGradientA,
			Gradient->resolvedGradient,
			CollectFractions->resolvedCollectFractions,
			FractionCollectionStartTime->resolvedFractionCollectionStartTime,
			FractionCollectionEndTime->resolvedFractionCollectionEndTime,
			FractionContainer->resolvedFractionContainer,
			MaxFractionVolume->resolvedMaxFractionVolume,
			FractionCollectionMode->resolvedFractionCollectionMode,
			Detectors->resolvedDetectors,
			PrimaryWavelength->resolvedPrimaryWavelength,
			SecondaryWavelength->resolvedSecondaryWavelength,
			WideRangeUV->resolvedWideRangeUV,
			PeakDetectors->resolvedPeakDetectors,
			PrimaryWavelengthPeakDetectionMethod->resolvedPrimaryWavelengthPeakDetectionMethod,
			SecondaryWavelengthPeakDetectionMethod->resolvedSecondaryWavelengthPeakDetectionMethod,
			WideRangeUVPeakDetectionMethod->resolvedWideRangeUVPeakDetectionMethod,
			PrimaryWavelengthPeakWidth->resolvedPrimaryWavelengthPeakWidth,
			SecondaryWavelengthPeakWidth->resolvedSecondaryWavelengthPeakWidth,
			WideRangeUVPeakWidth->resolvedWideRangeUVPeakWidth,
			PrimaryWavelengthPeakThreshold->resolvedPrimaryWavelengthPeakThreshold,
			SecondaryWavelengthPeakThreshold->resolvedSecondaryWavelengthPeakThreshold,
			WideRangeUVPeakThreshold->resolvedWideRangeUVPeakThreshold,
			ColumnStorageCondition->resolvedColumnStorageCondition,
			AirPurgeDuration->resolvedAirPurgeDuration,
			SampleLabel->resolvedSampleLabel,
			SampleContainerLabel->resolvedSampleContainerLabel,
			ColumnLabel->resolvedColumnLabel,
			CartridgeLabel->resolvedCartridgeLabel,

			Email->resolvedEmail,
			Operator->resolvedOperator,

			resolvedPostProcessingOptions,
			resolvedAliquotOptions,
			resolvedSamplePrepOptions
		}]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{nonLiquidSampleInvalidInputs,discardedInvalidInputs,missingVolumeInvalidInputs}]];

	(* gather all the invalid options together *)
	invalidOptions=DeleteDuplicates[Flatten[{
		nameInvalidOption,
		invalidPreparationOptions,
		incompleteBufferSpecificationInvalidOptions,
		compatibleSamplesAndInstrumentInvalidOptions,
		compatibleBuffersAndInstrumentInvalidOptions,
		mismatchedCartridgeOptions,
		mismatchedSolidLoadNullCartridgeOptions,
		mismatchedLiquidLoadSpecifiedCartridgeOptions,
		deprecatedColumnOptions,
		incompatibleColumnTypeOptions,
		incompatibleColumnAndInstrumentFlowRateOptions,
		insufficientSampleVolumeOptions,
		invalidLoadingAmountForColumnOptions,
		invalidLoadingAmountForInstrumentOptions,
		invalidLoadingAmountForSyringesOptions,
		invalidLoadingAmountOptions,
		incompatibleCartridgeLoadingTypeOptions,
		incompatibleCartridgeTypeOptions,
		incompatibleCartridgePackingTypeOptions,
		incompatibleCartridgeAndInstrumentFlowRateOptions,
		incompatibleCartridgeAndColumnFlowRateOptions,
		invalidCartridgeMaxBedWeightOptions,
		incompatibleInjectionAssemblyLengthOptions,
		invalidCartridgePackingMaterialOptions,
		invalidCartridgeFunctionalGroupOptions,
		invalidCartridgePackingMassOptions,
		tooHighCartridgePackingMassOptions,
		tooLowCartridgePackingMassOptions,
		invalidPackingMassForCartridgeCapsOptions,
		incompatibleFlowRateOptions,
		incompatiblePreSampleEquilibrationOptions,
		redundantGradientShortcutOptions,
		incompleteGradientShortcutOptions,
		zeroGradientShortcutOptions,
		redundantGradientSpecificationOptions,
		invalidGradientBTimeOptions,
		invalidGradientATimeOptions,
		invalidGradientTimeOptions,
		invalidTotalGradientTimeOptions,
		invalidFractionCollectionOptions,
		invalidCollectFractionsOptions,
		mismatchedFractionCollectionOptions,
		invalidFractionCollectionStartTimeOptions,
		invalidFractionCollectionEndTimeOptions,
		invalidFractionContainerOptions,
		invalidMaxFractionVolumeForContainerOptions,
		invalidMaxFractionVolumeOptions,
		invalidSpecifiedDetectorsOptions,
		invalidNullDetectorsOptions,
		invalidWideRangeUVOptions,
		missingPeakDetectorsOptions,
		invalidPeakDetectionOptions,
		invalidColumnStorageConditionOptions,
		invalidAirPurgeDurationOptions,
		invalidNullCartridgeLabelOptions,
		invalidSpecifiedCartridgeLabelOptions,
		invalidLabelOptions,
		invalidTotalBufferVolumeOptions,
		invalidTotalFractionVolumeOptions,

		If[MatchQ[preparationResult,$Failed],
			{Preparation},
			Nothing
		]
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[!gatherTests&&Length[invalidInputs]>0,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->cacheBall]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[!gatherTests&&Length[invalidOptions]>0,
		Message[Error::InvalidOption,invalidOptions]
	];


	(* get all the tests together *)
	allTests=Cases[Flatten[{
		(* Options precision and input tests *)
		roundedTests,
		samplePrepTests,
		discardedTest,
		missingVolumeTest,
		nonLiquidSampleTest,

		(* Pre-MapThread options tests *)
		invalidPreparationTest,
		mixedSeparationModesTest,
		mismatchedSeparationModesTest,
		incompleteBufferSpecificationTest,
		compatibleSamplesAndInstrumentTests,
		compatibleBuffersAndInstrumentTests,

		(* MapThread options tests *)
		mismatchedCartridgeOptionsTest,
		mismatchedSolidLoadNullCartridgeOptionsTest,
		mismatchedLiquidLoadSpecifiedCartridgeOptionsTest,
		recommendedMaxLoadingPercentExceededTest,
		deprecatedColumnTest,
		incompatibleColumnTypeTest,
		incompatibleColumnAndInstrumentFlowRateTest,
		insufficientSampleVolumeTest,
		invalidLoadingAmountForColumnTest,
		invalidLoadingAmountTest,
		invalidLoadingAmountForInstrumentTest,
		invalidLoadingAmountForSyringesTest,
		incompatibleCartridgeLoadingTypeTest,
		incompatibleCartridgeTypeTest,
		incompatibleCartridgePackingTypeTest,
		incompatibleCartridgeAndInstrumentFlowRateTest,
		incompatibleCartridgeAndColumnFlowRateTest,
		invalidCartridgeMaxBedWeightTest,
		incompatibleInjectionAssemblyLengthTest,
		mismatchedColumnAndPrepackedCartridgeTest,
		invalidCartridgePackingMaterialTest,
		invalidCartridgeFunctionalGroupTest,
		mismatchedColumnAndCartridgeTest,
		invalidCartridgePackingMassTest,
		tooHighCartridgePackingMassTest,
		tooLowCartridgePackingMassTest,
		invalidPackingMassForCartridgeCapsTest,
		incompatibleFlowRateTest,
		incompatiblePreSampleEquilibrationTest,
		redundantGradientShortcutTest,
		incompleteGradientShortcutTest,
		zeroGradientShortcutTest,
		redundantGradientSpecificationTest,
		invalidGradientBTimeTest,
		invalidGradientATimeTest,
		invalidGradientTimeTest,
		invalidTotalGradientTimeTest,
		methanolPercentTest,
		invalidFractionCollectionOptionsTest,
		invalidCollectFractionsTest,
		mismatchedFractionCollectionOptionsTest,
		invalidFractionCollectionStartTimeTest,
		invalidFractionCollectionEndTimeTest,
		invalidFractionContainerTest,
		invalidMaxFractionVolumeForContainerTest,
		invalidMaxFractionVolumeTest,
		duplicateDetectorsTest,
		invalidSpecifiedDetectorsTest,
		invalidNullDetectorsTest,
		invalidWideRangeUVTest,
		duplicatePeakDetectorsTest,
		missingPeakDetectorsTest,
		invalidPeakDetectionTests,
		invalidColumnStorageConditionTest,
		invalidAirPurgeDurationTest,
		airPurgeAndStoreColumnTest,
		invalidNullCartridgeLabelTest,
		invalidSpecifiedCartridgeLabelTest,


		(* Post-MapThread options tests *)
		invalidLabelTests,

		invalidTotalBufferVolumeTests,
		invalidTotalFractionVolumeTest,
		totalFractionVolumeTest,

		nameInvalidTest,
		aliquotTests
	}],TestP];

	(* pending to add updatedExperimentFlashChromatographySimulation to the Result *)
	(* return our resolved options and/or tests *)
	outputSpecification/.{Result->resolvedOptions,Tests->allTests}

];

(* ::Subsection::Closed:: *)
(*flashChromatographyResourcePackets*)

DefineOptions[flashChromatographyResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption,
		SimulationOption
	}
];


flashChromatographyResourcePackets[
	mySamples:{ObjectP[Object[Sample]]..},
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myOptions:OptionsPattern[]
]:=Module[
	{
		safeOps,cache,simulation,outputSpecification,output,gatherTests,messages,fastAssoc,
		simulatedSamples,aliquotSimulation,samplePacket,

		(* Resolved option values *)
		resolvedInstrument,resolvedDetector,resolvedSeparationMode,resolvedBufferA,resolvedBufferB,resolvedLoadingType,
		resolvedColumn,resolvedPreSampleEquilibration,resolvedLoadingAmount,resolvedMaxLoadingPercent,resolvedCartridge,
		resolvedCartridgePackingMaterial,resolvedCartridgeFunctionalGroup,resolvedCartridgePackingMass,
		resolvedCartridgeDryingTime,resolvedGradientA,resolvedGradientB,resolvedFlowRate,resolvedGradientStart,
		resolvedGradientEnd,resolvedGradientDuration,resolvedEquilibrationTime,resolvedFlushTime,resolvedGradient,
		resolvedCollectFractions,resolvedFractionCollectionStartTime,resolvedFractionCollectionEndTime,
		resolvedFractionContainer,resolvedMaxFractionVolume,resolvedFractionCollectionMode,resolvedDetectors,
		resolvedPrimaryWavelength,resolvedSecondaryWavelength,resolvedWideRangeUV,resolvedPeakDetectors,
		resolvedPrimaryWavelengthPeakDetectionMethod,resolvedPrimaryWavelengthPeakWidth,
		resolvedPrimaryWavelengthPeakThreshold,resolvedSecondaryWavelengthPeakDetectionMethod,
		resolvedSecondaryWavelengthPeakWidth,resolvedSecondaryWavelengthPeakThreshold,
		resolvedWideRangeUVPeakDetectionMethod,resolvedWideRangeUVPeakWidth,resolvedWideRangeUVPeakThreshold,
		resolvedColumnStorageCondition,resolvedAirPurgeDuration,resolvedAliquotAmount,
		resolvedSampleLabel,resolvedSampleContainerLabel,resolvedColumnLabel,resolvedCartridgeLabel,
		resolvedName,resolvedParentProtocol,resolvedPreparation,

		resolvedDetectorsNoAll,resolvedWideRangeUVNoAll,
		sampleVolumes,resolvedLoadingAmountVolumes,
		pairedSamplesInAndLoadingAmount,sampleVolumeRules,samplesInResourceReplaceRules,samplesInResources,
		containersIn,containersInResourceReplaceRules,containersInResources,

		resolvedCartridgePackets,resolvedCartridgePackingTypes,resolvedCartridgeMaxBedWeights,

		instrumentTimes,runTimes,totalInstrumentTime,instrumentResource,
		totalBufferAVolume,totalBufferBVolume,bufferAResource,bufferBResource,

		columnResources,columnVoidVolumes,cartridgeResources,

		fritModels,pairedFritModelAndAmount,fritAmountRules,fritResourceReplaceRules,fritResources,

		plungerModels,plungerResourceReplaceRules,plungerResources,
		cartridgeMediaModels,pairedMediaAndPackingMass,mediaMassRules,mediaResourceReplaceRules,
		cartridgeMediaResources,beakerResources,

		allCartridgeCapModels,allCartridgeCapMinBedWeights,allCartridgeCapMaxBedWeights,cartridgeCapModels,
		cartridgeCapResourceReplaceRules,cartridgeCapResources,cartridgeCapTubingResourceLink,cartridgeCapTubingResources,

		allSyringeModels,allSyringeMinVolumes,allSyringeMaxVolumes,syringeResources,needleResources,

		maxNumbersOfFractionContainers,fractionContainerRackModels,

		numbersOfPositions,rackPositionsLists,

		preferredNumbersOfRacks,pairedRacksAndNumber,rackNumberRules,rackResourceReplaceRules,preferredRackResources,
		numbersOfRacks,
		initialPrimaryRackResources,primaryRackResources,secondaryRackResources,defaultEmptyRackResource,emptyRackResource,

		rackPlacementsList,
		numbersOfContainers,fractionContainerResourcesList,fractionContainerPlacementsList,

		allowedKeys,unitOperationOptions,mapThreadFriendlyUnitOperationOptions,unitOperationBlobs,
		initialCombinedUnitOperationPackets,unitOperationPackets,unitOperationObjects,

		protocolID,protocolPacketWithoutRequiredObjectsOrSharedFields,sharedFieldPacket,protocolPacketWithoutRequiredObjects,
		allResourceBlobs,protocolPacket,

		fulfillable,frqTests,testsRule,resultRule
	},

	(* Get the safe options for this function *)
	safeOps=SafeOptions[flashChromatographyResourcePackets,ToList[myOptions]];

	(* Pull out the relevant options *)
	{cache,simulation,outputSpecification}=Lookup[safeOps,{Cache,Simulation,Output}];
	output=ToList[outputSpecification];

	(* Decide if we are gathering tests or throwing messages *)
	gatherTests=MemberQ[output,Tests];
	messages=Not[gatherTests];

	(* Make the fast association *)
	fastAssoc=makeFastAssocFromCache[cache];

	(* Simulate the aliquot stuff so we can give the simulation to populateSamplePrepFields and fulfillableResourceQ *)
	{simulatedSamples,aliquotSimulation}=simulateSamplesResourcePacketsNew[ExperimentFlashChromatography,mySamples,myResolvedOptions,Cache->cache,Simulation->simulation];

	(* --- Make our one Download call --- *)
	samplePacket=Download[
		mySamples,
		Packet[Volume,Container],
		Cache->cache,
		Simulation->aliquotSimulation
	];

	(* Lookup option values *)
	{
		resolvedInstrument,
		resolvedDetector,
		resolvedSeparationMode,
		resolvedBufferA,
		resolvedBufferB,
		resolvedLoadingType,
		resolvedColumn,
		resolvedPreSampleEquilibration,
		resolvedLoadingAmount,
		resolvedMaxLoadingPercent,
		resolvedCartridge,
		resolvedCartridgePackingMaterial,
		resolvedCartridgeFunctionalGroup,
		resolvedCartridgePackingMass,
		resolvedCartridgeDryingTime,
		resolvedGradientA,
		resolvedGradientB,
		resolvedFlowRate,
		resolvedGradientStart,
		resolvedGradientEnd,
		resolvedGradientDuration,
		resolvedEquilibrationTime,
		resolvedFlushTime,
		resolvedGradient,
		resolvedCollectFractions,
		resolvedFractionCollectionStartTime,
		resolvedFractionCollectionEndTime,
		resolvedFractionContainer,
		resolvedMaxFractionVolume,
		resolvedFractionCollectionMode,
		resolvedDetectors,
		resolvedPrimaryWavelength,
		resolvedSecondaryWavelength,
		resolvedWideRangeUV,
		resolvedPeakDetectors,
		resolvedPrimaryWavelengthPeakDetectionMethod,
		resolvedPrimaryWavelengthPeakWidth,
		resolvedPrimaryWavelengthPeakThreshold,
		resolvedSecondaryWavelengthPeakDetectionMethod,
		resolvedSecondaryWavelengthPeakWidth,
		resolvedSecondaryWavelengthPeakThreshold,
		resolvedWideRangeUVPeakDetectionMethod,
		resolvedWideRangeUVPeakWidth,
		resolvedWideRangeUVPeakThreshold,
		resolvedColumnStorageCondition,
		resolvedAirPurgeDuration,
		resolvedAliquotAmount,
		resolvedSampleLabel,
		resolvedSampleContainerLabel,
		resolvedColumnLabel,
		resolvedCartridgeLabel,
		resolvedName,
		resolvedParentProtocol,
		resolvedPreparation
	}=Lookup[
		myResolvedOptions,
		{
			Instrument,
			Detector,
			SeparationMode,
			BufferA,
			BufferB,
			LoadingType,
			Column,
			PreSampleEquilibration,
			LoadingAmount,
			MaxLoadingPercent,
			Cartridge,
			CartridgePackingMaterial,
			CartridgeFunctionalGroup,
			CartridgePackingMass,
			CartridgeDryingTime,
			GradientA,
			GradientB,
			FlowRate,
			GradientStart,
			GradientEnd,
			GradientDuration,
			EquilibrationTime,
			FlushTime,
			Gradient,
			CollectFractions,
			FractionCollectionStartTime,
			FractionCollectionEndTime,
			FractionContainer,
			MaxFractionVolume,
			FractionCollectionMode,
			Detectors,
			PrimaryWavelength,
			SecondaryWavelength,
			WideRangeUV,
			PeakDetectors,
			PrimaryWavelengthPeakDetectionMethod,
			PrimaryWavelengthPeakWidth,
			PrimaryWavelengthPeakThreshold,
			SecondaryWavelengthPeakDetectionMethod,
			SecondaryWavelengthPeakWidth,
			SecondaryWavelengthPeakThreshold,
			WideRangeUVPeakDetectionMethod,
			WideRangeUVPeakWidth,
			WideRangeUVPeakThreshold,
			ColumnStorageCondition,
			AirPurgeDuration,
			AliquotAmount,
			SampleLabel,
			SampleContainerLabel,
			ColumnLabel,
			CartridgeLabel,
			Name,
			ParentProtocol,
			Preparation
		}
	];

	(* Replace any instances of All in the resolved Detectors option *)
	resolvedDetectorsNoAll=Map[
		If[MatchQ[#,All],{PrimaryWavelength,SecondaryWavelength,WideRangeUV},#]&,
		resolvedDetectors
	];

	(* Replace any instances of All in the resolved WideRangeUV option *)
	resolvedWideRangeUVNoAll=Map[
		If[MatchQ[#,All],Span[200 Nanometer,360 Nanometer],#]&,
		resolvedWideRangeUV
	];

	(* --- Make all the resources needed in the experiment --- *)

	(*-- SamplesIn Resources --*)

	(* Get the volumes of the simulated samples *)
	sampleVolumes=Lookup[samplePacket,Volume];

	(* Replace All in the resolved LoadingAmount with the rounded simulated sample's volume *)
	resolvedLoadingAmountVolumes=MapThread[
		If[MatchQ[#1,All],#2,#1]&,
		{resolvedLoadingAmount,SafeRound[sampleVolumes,flashChromatographyVolumePrecision[],Round->Down]}
	];

	(* Pair the SamplesIn and their LoadingAmount volumes *)
	pairedSamplesInAndLoadingAmount=MapThread[
		#1->#2&,
		{mySamples,resolvedLoadingAmountVolumes}
	];

	(* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
	sampleVolumeRules=Merge[pairedSamplesInAndLoadingAmount,Total];

	(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource
	per sample including in replicates *)
	samplesInResourceReplaceRules=KeyValueMap[
		Function[{sample,volume},
			sample->Resource[Sample->sample,Name->ToString[Unique[]],Amount->volume]
		],
		sampleVolumeRules
	];

	(* Use the replace rules to get the sample resources *)
	samplesInResources=Replace[mySamples,samplesInResourceReplaceRules,{1}];

	(*-- ContainersIn Resources --*)

	containersIn=Download[Lookup[samplePacket,Container],Object];

	(* Create a resource for each unique sample container *)
	containersInResourceReplaceRules=Map[
		#->Resource[Sample->#,Name->ToString[Unique[]]]&,
		DeleteDuplicates[containersIn]
	];

	(* Create a list of sample container resources index-matched to the samples *)
	containersInResources=Replace[containersIn,containersInResourceReplaceRules,{1}];

	(*-- Instrument Resources --*)

	resolvedCartridgePackets=Map[
		fetchModelPacketFromFastAssoc[#,fastAssoc]&,
		resolvedCartridge
	];

	(* Get the values of the PackingType and MaxBedWeight fields of the resolved cartridges *)
	{
		resolvedCartridgePackingTypes,
		resolvedCartridgeMaxBedWeights
	}=Transpose[
		Lookup[resolvedCartridgePackets,{PackingType,MaxBedWeight},Null]
	];

	(* Estimate the total amount of time the instrument will be required for each SamplesIn and the time that the actual
	sample run will take *)
	{instrumentTimes,runTimes}=Transpose[
		MapThread[
			Function[{preSampleEquilibration,cartridge,cartridgePackingType,cartridgeDryingTime,gradientB,airPurgeDuration},
				Module[{
					noNullPreSampleEquilibration,noNullCartridgeDryingTime,noNullAirPurgeDuration,
					setUpTime,columnEquilibrationTime,handPackedCartridgeTime,cartridgeSetUpTime,gradientTime,airPurgeTime,
					cleanUpTime,totalTime,runTime
				},

					(* Convert any time options that are Null to 0 Minute *)
					{
						noNullPreSampleEquilibration,
						noNullCartridgeDryingTime,
						noNullAirPurgeDuration
					}=Map[
						If[NullQ[#],0 Minute,#]&,
						{preSampleEquilibration,cartridgeDryingTime,airPurgeDuration}
					];

					(* The time to set up the instrument *)
					setUpTime=10 Minute;

					(* The time to equilibrate the column *)
					columnEquilibrationTime=noNullPreSampleEquilibration;

					(* The time to hand pack an empty solid load cartridge *)
					handPackedCartridgeTime=If[MatchQ[cartridgePackingType,HandPacked],
						10 Minute,
						0 Minute
					];

					(* The time to set up (and optionally dry) the solid load cartridge *)
					cartridgeSetUpTime=If[NullQ[cartridge],
						0 Minute,
						10 Minute+noNullCartridgeDryingTime
					];

					(* The time for the gradient to run *)
					gradientTime=First[Last[gradientB]];

					(* The time for the air purge/valve wash
					The valve wash takes 2 minutes, starts at the same time as the air purge, and runs concurrently *)
					airPurgeTime=Max[noNullAirPurgeDuration,2 Minute];

					(* The time for instrument clean up and data transfer *)
					cleanUpTime=10 Minute;

					(* Calculate the total instrument time *)
					totalTime=Total[{
						setUpTime,
						columnEquilibrationTime,
						handPackedCartridgeTime,
						cartridgeSetUpTime,
						gradientTime,
						airPurgeTime,
						cleanUpTime
					}];

					(* Calculate the time required for the sample run.
					For LoadingType Solid (i.e. when Cartridge is not Null), the column equilibration time is included in the run time.
					For LoadingType Liquid, column equilibration happens before sample loading, so it isn't included in the run time.
					For LoadingType Preloaded, there is no column equilibration.
					 *)
					runTime=If[NullQ[cartridge],
						gradientTime+airPurgeTime,
						columnEquilibrationTime+gradientTime+airPurgeTime
					];

					(* Return the total instrument time and the sample run time *)
					{totalTime,runTime}
				]
			],
			{resolvedPreSampleEquilibration,resolvedCartridge,resolvedCartridgePackingTypes,resolvedCartridgeDryingTime,resolvedGradientB,resolvedAirPurgeDuration}
		]
	];

	(* Get the total time the instrument will be required *)
	totalInstrumentTime=Total[instrumentTimes];

	(* Generate the instrument resource *)
	instrumentResource=Link[Resource[Instrument->resolvedInstrument,Time->totalInstrumentTime,Name->ToString[Unique[]]]];

	(*-- Buffer Resources --*)

	(* Get the total volume required of each buffer *)
	{
		totalBufferAVolume,
		totalBufferBVolume
	}=flashChromatographyBufferVolumes[resolvedFlowRate,resolvedPreSampleEquilibration,resolvedGradientA,resolvedGradientB];

	(* Generate the buffer A and B resources *)
	{bufferAResource,bufferBResource}=MapThread[
		Function[{buffer,bufferVolume},
			Link[Resource[
				Sample->buffer,
				Name->ToString[Unique[]],
				Amount->bufferVolume,
				Container->If[bufferVolume>$MaxFlashChromatographyBufferVolume,
					PreferredContainer[bufferVolume],
					Model[Container,Vessel,"Amber Glass Bottle 4 L"]
				],
				RentContainer->True
			]]
		],
		{
			{resolvedBufferA,resolvedBufferB},
			{totalBufferAVolume,totalBufferBVolume}
		}
	];

	(*-- Column Resources --*)

	(* Generate the column resources index-matched to the resolved Column option *)
	columnResources=MapThread[
		Link[Resource[Sample->#1,Name->#2]]&,
		{resolvedColumn,resolvedColumnLabel}
	];

	(* Get the column void volumes *)
	columnVoidVolumes=Map[
		Lookup[fetchModelPacketFromFastAssoc[#,fastAssoc],VoidVolume]&,
		resolvedColumn
	];

	(*-- Cartridge Resources --*)

	(* Generate the cartridge resources index-matched to the resolved Cartridge option *)
	cartridgeResources=MapThread[
		If[NullQ[#1],
			Null,
			Link[Resource[Sample->#1,Name->#2]]
		]&,
		{resolvedCartridge,resolvedCartridgeLabel}
	];

	(*-- Cartridge Packing Resources --*)

	(*- Frit Resources -*)

	(* Get the frit models to use based on the cartridge's PackingType and MaxBedWeight *)
	fritModels=MapThread[
		Switch[{#1,#2},
			{HandPacked,LessEqualP[5 Gram]},
			Model[Item,Consumable,"Frits for RediSep 5g Solid Load Cartridge"],

			{HandPacked,LessEqualP[25 Gram]},
			Model[Item,Consumable,"Frits for RediSep 25g Solid Load Cartridge"],

			{HandPacked,LessEqualP[65 Gram]},
			Model[Item,Consumable,"Frits for RediSep 65g Solid Load Cartridge"],

			{_,_},Null
		]&,
		{resolvedCartridgePackingTypes,resolvedCartridgeMaxBedWeights}
	];

	(* Pair element from the fritModels list with how many will be required (one each) *)
	pairedFritModelAndAmount=Map[
		If[NullQ[#],
			Nothing,
			#->1
		]&,
		fritModels
	];

	(* Get a list of rules for how many of each model of frit will be required *)
	fritAmountRules=Merge[pairedFritModelAndAmount,Total];

	(* Make replace rules for the frits and their resources; doing it this way because we only want to make one resource
	per type of frit *)
	fritResourceReplaceRules=KeyValueMap[
		Function[{frit,amount},
			frit->Link[Resource[
				Sample->frit,
				Name->ToString[Unique[]],
				Amount->amount
			]]
		],
		fritAmountRules
	];

	(* Replace each frit model from the list index-matched to the samples with the frit resource for that model *)
	fritResources=Replace[fritModels,fritResourceReplaceRules,{1}];

	(*- Plunger resources -*)

	(* Get the plunger models to use based on the cartridge's PackingType and MaxBedWeight *)
	plungerModels=MapThread[
		Switch[{#1,#2},
			{HandPacked,LessEqualP[5 Gram]},
			Model[Item,Plunger,"Plunger for RediSep 5g Solid Load Cartridge"],

			{HandPacked,LessEqualP[65 Gram]},
			Model[Item,Plunger,"Plunger for RediSep 25g or 65g Solid Load Cartridge"],

			{_,_},Null
		]&,
		{resolvedCartridgePackingTypes,resolvedCartridgeMaxBedWeights}
	];

	(* Create a resource for each unique plunger model *)
	plungerResourceReplaceRules=Map[
		If[NullQ[#],
			Nothing,
			#->Link[Resource[Sample->#,Name->ToString[Unique[]]]]
		]&,
		DeleteDuplicates[plungerModels]
	];

	(* Create a list of plunger resources index-matched to the samples *)
	plungerResources=Replace[plungerModels,plungerResourceReplaceRules,{1}];

	(*- Cartridge media resources -*)

	(* Get the model of the material with which to pack a HandPacked cartridge *)
	cartridgeMediaModels=MapThread[
		Switch[{#1,#2,#3},
			{HandPacked,Silica,C18},Model[Sample,"C18 Silica Gel Spherical 40-75 um"],
			{HandPacked,Silica,Null},Model[Sample,"Silica Gel Spherical 40-75 um"],
			{_,_,_},Null
		]&,
		{resolvedCartridgePackingTypes,resolvedCartridgePackingMaterial,resolvedCartridgeFunctionalGroup}
	];

	(* Generate resources for the hand-packed cartridge media *)
	(* If the hand-packed media model is not null, then ask for an amount of it equal to the CartridgePackingMass *)
	cartridgeMediaResources=MapThread[
		If[!NullQ[#1],
			Link[Resource[
				Sample->#1,
				Name->ToString[Unique[]],
				Amount->#2
			]],

			(* Otherwise, we don't need any media for hand-packing *)
			Null
		]&,
		{cartridgeMediaModels,resolvedCartridgePackingMass}
	];

	(*- Beaker -*)

	(* Generate a beaker resource for each sample that will be loaded in a cartridge *)
	beakerResources=Map[
		If[!NullQ[#],
			Link[Resource[
				Sample->Model[Container,Vessel,"600mL Pyrex Beaker"],
				Name->ToString[Unique[]]
			]],
			Null
		]&,
		resolvedCartridge
	];

	(*-- Cartridge Cap Resources --*)

	(* Get a list of all cartridge cap models that work with the instrument *)
	allCartridgeCapModels=combiFlashCompatibleCartridgeCap["Memoization"];

	(* Get the min and max bed weights of the cartridge cap models *)
	{
		allCartridgeCapMinBedWeights,
		allCartridgeCapMaxBedWeights
	}=Transpose[Map[
		Lookup[fetchModelPacketFromFastAssoc[#,fastAssoc],{MinBedWeight,MaxBedWeight}]&,
		allCartridgeCapModels
	]];

	(* Get the models of cartridge cap to use with each sample *)
	cartridgeCapModels=MapThread[
		Function[{loadingType,resolvedCartridgeMaxBedWeight},

			(* If the resolved LoadingType is not Solid, there is no cartridge, so return Null for the cartridge cap *)
			If[!MatchQ[loadingType,Solid],
				Null,

				(* Otherwise, find the model of cartridge cap to use with the cartridge *)
				Module[{compatibleCartridgeCapBools,compatibleCartridgeCaps,compatibleCartridgeCapMaxBedWeights,smallestCompatibleCartridgeCap},

					(* Get a list of Booleans indicating which of allCartridgeCapModels can hold the resolved cartridge *)
					compatibleCartridgeCapBools=MapThread[
						IntervalMemberQ[
							Interval[{#1,#2}],
							resolvedCartridgeMaxBedWeight
						]&,
						{allCartridgeCapMinBedWeights,allCartridgeCapMaxBedWeights}
					];

					(* Get a list of which cartridge caps hold the resolved cartridge and a list of their MaxBedWeights *)
					compatibleCartridgeCaps=PickList[allCartridgeCapModels,compatibleCartridgeCapBools];
					compatibleCartridgeCapMaxBedWeights=PickList[allCartridgeCapMaxBedWeights,compatibleCartridgeCapBools];

					(* Return the compatible cartridge cap with the smallest MaxBedWeight *)
					smallestCompatibleCartridgeCap=First[PickList[
						compatibleCartridgeCaps,
						compatibleCartridgeCapMaxBedWeights,
						Min[compatibleCartridgeCapMaxBedWeights]
					]]
				]
			]
		],
		{resolvedLoadingType,resolvedCartridgeMaxBedWeights}
	];

	(* Create a resource for each unique cartridge cap model *)
	cartridgeCapResourceReplaceRules=Map[
		If[NullQ[#],
			Nothing,
			#->Link[Resource[Sample->#,Name->ToString[Unique[]]]]
		]&,
		DeleteDuplicates[cartridgeCapModels]
	];

	(* Create a list of cartridge cap resources index-matched to the samples *)
	cartridgeCapResources=Replace[cartridgeCapModels,cartridgeCapResourceReplaceRules,{1}];

	(*-- Cartridge Cap Tubing Resource --*)

	(* Generate a resource for the tubing used to connect the instrument's injection valve to a cartridge cap if any sample
	is using a cartridge *)
	(* There is only one model of tubing and it fits all CombiFlash cartridge caps so it can be used for each sample that
	uses a cartridge *)
	cartridgeCapTubingResourceLink=If[MemberQ[resolvedLoadingType,Solid],
		Link[Resource[
			Sample->Model[Plumbing,"CombiFlash Adjustable Solid Load Cartridge Cap Tubing"],
			Name->ToString[Unique[]]
		]],
		Null
	];

	(* Provide a link to the cartridge cap tubing resource for each sample that has a Solid LoadingType *)
	cartridgeCapTubingResources=Map[
		If[MatchQ[#,Solid],
			cartridgeCapTubingResourceLink,
			Null
		]&,
		resolvedLoadingType
	];

	(*-- Syringe and Needle Resources --*)

	(* Get a list of all syringe models that work with the instrument *)
	allSyringeModels=combiFlashCompatibleSyringe["Memoization"];

	(* Get the min and max volumes of the syringe models *)
	{
		allSyringeMinVolumes,
		allSyringeMaxVolumes
	}=Transpose[Map[
		Lookup[fetchModelPacketFromFastAssoc[#,fastAssoc],{MinVolume,MaxVolume}]&,
		allSyringeModels
	]];

	(* For each sample, generate a syringe resource that will be used to transfer the sample's LoadingAmount to the instrument *)
	syringeResources=Map[
		Function[{resolvedLoadingAmountVolume},
			Module[{compatibleSyringeBools,compatibleSyringes,compatibleSyringeMaxVolumes,smallestCompatibleSyringe},

				(* Get a list of Booleans indicating which of allSyringeModels can transfer the LoadingAmount*)
				compatibleSyringeBools=MapThread[
					IntervalMemberQ[
						Interval[{#1,#2}],
						resolvedLoadingAmountVolume
					]&,
					{allSyringeMinVolumes,allSyringeMaxVolumes}
				];

				(* Get a list of which syringes can transfer the LoadingAmount and a list of their MaxVolumes *)
				compatibleSyringes=PickList[allSyringeModels,compatibleSyringeBools];
				compatibleSyringeMaxVolumes=PickList[allSyringeMaxVolumes,compatibleSyringeBools];

				(* Get the compatible syringe with the smallest MaxVolume *)
				smallestCompatibleSyringe=First[PickList[
					compatibleSyringes,
					compatibleSyringeMaxVolumes,
					Min[compatibleSyringeMaxVolumes]
				]];

				(* Return a resource for the smallest compatible syringe *)
				Link[Resource[
					Sample->smallestCompatibleSyringe,
					Name->ToString[Unique[]]
				]]
			]
		],
		resolvedLoadingAmountVolumes
	];

	(* Generate resources for the syringe needles, one for each syringe *)
	needleResources=Map[
		Link[Resource[
			Sample->Model[Item,Needle,"id:P5ZnEj4P88YE"],(*Model[Item,Needle,"21g x 1 Inch Single-Use Needle"]*)
			Name->ToString[Unique[]]
		]]&,
		syringeResources
	];

	(*-- Fraction Collection Rack and Container Resources --*)

	(* Get a list of the numbers of fraction containers needed for each sample *)
	maxNumbersOfFractionContainers=flashChromatographyNumbersOfContainers[resolvedCollectFractions,resolvedFractionCollectionStartTime,resolvedFractionCollectionEndTime,resolvedFlowRate,resolvedMaxFractionVolume];

	(* Get a list of the rack model required for each sample *)
	fractionContainerRackModels=flashChromatographyRackModels[resolvedFractionContainer];

	(* Get the NumberOfPositions of each required rack model *)
	numbersOfPositions=Map[
		Lookup[fetchModelPacketFromFastAssoc[#,fastAssoc],NumberOfPositions,Null]&,
		fractionContainerRackModels
	];

	(* Get a list of positions from each required rack model *)
	rackPositionsLists=Map[
		Lookup[fetchModelPacketFromFastAssoc[#,fastAssoc],Positions,{}][[All,1]]&,
		fractionContainerRackModels
	];

	(* To get the preferred number of racks for each sample, divide the max number of required containers for the sample by
	the number of positions in the rack then round up to the nearest integer *)
	preferredNumbersOfRacks=Ceiling[maxNumbersOfFractionContainers/numbersOfPositions];

	(* Pair the rack model for each sample and the preferred number of racks for that sample. *)
	pairedRacksAndNumber=MapThread[
		If[NullQ[#1],
			Nothing,
			#1->#2
		]&,
		{fractionContainerRackModels,preferredNumbersOfRacks}
	];

	(* Get rules relating each rack model to the maximum number of that model that is preferred for any sample
	In the form rack->number *)
	rackNumberRules=Merge[pairedRacksAndNumber,Max];

	(* Generate replace rules with the resources for the fraction collection racks *)
	rackResourceReplaceRules=KeyValueMap[
		Function[{rack,number},
			rack->Table[Link[Resource[Sample->rack,Name->ToString[Unique[]]]],number]
		],
		rackNumberRules
	];

	(* Get list of lists of the preferred rack resources for each sample *)
	preferredRackResources=fractionContainerRackModels/.rackResourceReplaceRules;

	(* Get the numbers of rack resources to request *)
	numbersOfRacks=If[#>2,2,#]&/@preferredNumbersOfRacks;

	(* Get index-matched lists of primary and secondary rack resources *)
	{initialPrimaryRackResources,secondaryRackResources}=Transpose[
		MapThread[
			Function[{numberOfRacks,preferredResources},
				Switch[numberOfRacks,

					(* If the number of required racks is 1, take the first of the resources generated for that model
					of rack for the primary rack and Null for the secondary rack *)
					EqualP[1],{First[preferredResources],Null},

					(* If the number of required racks is 2, take the first of the resources generated for that
					model of rack for the primary rack and the second for the secondary rack *)
					EqualP[2],Take[preferredResources,2],

					(* Otherwise, return Null for both primary and secondary racks *)
					_,{Null,Null}
				]
			],
			{numbersOfRacks,preferredRackResources}
		]
	];

	(* Generate a resource for a fraction collection rack to use if no other racks are being used *)
	defaultEmptyRackResource=Link[Resource[Sample->Model[Container,Rack,"25mm Tube Rack"],Name->ToString[Unique[]]]];

	(* If initialPrimaryRackResources is all Null, then the rack resource to use for samples that aren't collecting fractions
	is the defaultEmptyRackResource, otherwise it is the first rack resource in the list of initialPrimaryRackResources *)
	emptyRackResource=If[MatchQ[initialPrimaryRackResources,{Null..}],
		defaultEmptyRackResource,
		First[Cases[initialPrimaryRackResources,Except[Null]]]
	];

	(* Replace any Nulls in initialPrimaryRackResources with the emptyRackResource because the instrument needs a rack
	loaded on the deck even if no fractions are being collected *)
	primaryRackResources=initialPrimaryRackResources/.Null->emptyRackResource;

	(* Generate deck placements to put the racks on the instrument's fraction collection deck *)
	rackPlacementsList=MapThread[
		{
			If[NullQ[#1],Nothing,{#1,{"Left Slot"}}],
			If[NullQ[#2],Nothing,{#2,{"Right Slot"}}]
		}&,
		{primaryRackResources,secondaryRackResources}
	];

	(* Get the number of fraction collection container resources to generate for each sample *)
	numbersOfContainers=numbersOfRacks*numbersOfPositions;

	(* Get an index matched list of fraction container resources *)
	(* Generate enough container resources to fill the number of racks required for each sample *)
	fractionContainerResourcesList=MapThread[
		Table[Link[Resource[Sample->#1,Name->ToString[Unique[]]]],#2]&,
		{resolvedFractionContainer,numbersOfContainers}
	];

	(* Make a list of placements to put the fraction collection containers in the fraction collection racks for each sample *)
	fractionContainerPlacementsList=MapThread[
		Function[{numberOfRacks,numberOfPositions,primaryRackResource,secondaryRackResource,containerResourcesList,rackPositionsList},
			Switch[numberOfRacks,

				(* If the number of required racks is 1, make placements to put the container resources in the rack resource *)
				EqualP[1],MapThread[{#1,primaryRackResource,#2}&,{containerResourcesList,rackPositionsList}],

				(* If the number of required racks is 1, make placements to put the container resources in the appropriate
				primary and secondary rack resources *)
				EqualP[2],
				Join[
					MapThread[{#1,primaryRackResource,#2}&,{Take[containerResourcesList,numberOfPositions],rackPositionsList}],
					MapThread[{#1,secondaryRackResource,#2}&,{Drop[containerResourcesList,numberOfPositions],rackPositionsList}]
				],

				(* Otherwise, return an empty list *)
				_,{}
			]
		],
		{numbersOfRacks,numbersOfPositions,primaryRackResources,secondaryRackResources,fractionContainerResourcesList,rackPositionsLists}
	];



	(*--- UnitOperations packet ---*)

	(* Get a list of the options allowed for the UnitOperation *)
	allowedKeys=allowedKeysForUnitOperationType[Object[UnitOperation,FlashChromatography]];

	(* Get the options to use to generate the UnitOperations *)
	unitOperationOptions=Select[myResolvedOptions,MatchQ[Keys[#],Alternatives@@allowedKeys]&];

	(* Get the MapThread friendly UnitOperation options *)
	mapThreadFriendlyUnitOperationOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentFlashChromatography,
		unitOperationOptions
	];

	(* Generate the FlashChromatography batched unit operations blobs: one for each sample *)
	unitOperationBlobs=MapThread[
		Function[{
			options,
			samplesInResource,
			columnResource,
			cartridgeResource,
			fractionContainerModel,
			loadingAmountVolume,
			detectorsNoAll,
			wideRangeUVNoAll
		},
			FlashChromatography@@Join[
				{
					Sample->samplesInResource
				},
				ReplaceRule[
					Normal[options],
					{
						(* Fields for non-index-matched options that are resources *)
						Instrument->instrumentResource,
						BufferA->bufferAResource,
						BufferB->bufferBResource,

						(* Fields for index-matched options that are resources *)
						Column->columnResource,
						Cartridge->cartridgeResource,

						(* Fields for index-matched options that stay Models instead of being replaced by resources *)
						FractionContainer->Link[fractionContainerModel],

						(* Use the actual loading amount volume rather than All *)
						LoadingAmount->loadingAmountVolume,

						(* Replace the symbol All in Detectors and in WideRangeUV with the actual values *)
						Detectors->detectorsNoAll,
						WideRangeUV->wideRangeUVNoAll,

						(* So that we don't inherit the name option from the parent *)
						Name->Null
					}
				]
			]
		],
		{
			mapThreadFriendlyUnitOperationOptions,
			samplesInResources,
			columnResources,
			cartridgeResources,
			resolvedFractionContainer,
			resolvedLoadingAmountVolumes,
			resolvedDetectorsNoAll,
			resolvedWideRangeUVNoAll
		}
	];

	(* Make unit operation packets out of the unit operation blobs *)
	initialCombinedUnitOperationPackets=UploadUnitOperation[
		unitOperationBlobs,
		UnitOperationType->Batched,
		Upload->False,
		FastTrack->True
	];

	(* Add extra fields to the unit operation packets: resource fields that aren't options and placement fields *)
	unitOperationPackets=MapThread[
		Function[{
			packet,
			fractionContainerResources,
			primaryRackResource,
			secondaryRackResource,
			syringeResource,
			needleResource,
			fritResource,
			plungerResource,
			cartridgeMediaResource,
			cartridgeCapResource,
			cartridgeCapTubingResource,
			beakerResource,
			fractionContainerPlacements,
			runTime,
			columnVoidVolume,
			rackPlacements
		},
			Join[
				packet,
				<|
					(* Fields for resources that aren't options *)
					Replace[FractionContainers]->fractionContainerResources,
					Replace[Rack]->{primaryRackResource},
					Replace[SecondaryRack]->{secondaryRackResource},
					Replace[Syringe]->{syringeResource},
					Replace[Needle]->{needleResource},
					Replace[Frits]->{fritResource},
					Replace[Plunger]->{plungerResource},
					Replace[CartridgeMedia]->{cartridgeMediaResource},
					Replace[CartridgeCap]->{cartridgeCapResource},
					Replace[CartridgeCapTubing]->{cartridgeCapTubingResource},
					Replace[Beaker]->{beakerResource},

					(* Other fields *)
					Replace[FractionContainerPlacements]->fractionContainerPlacements,
					Replace[RunTime]->{runTime},
					Replace[ColumnVoidVolume]->{columnVoidVolume},
					Replace[FractionRackPlacements]->rackPlacements
				|>
			]
		],
		{
			initialCombinedUnitOperationPackets,
			fractionContainerResourcesList,
			primaryRackResources,
			secondaryRackResources,
			syringeResources,
			needleResources,
			fritResources,
			plungerResources,
			cartridgeMediaResources,
			cartridgeCapResources,
			cartridgeCapTubingResources,
			beakerResources,
			fractionContainerPlacementsList,
			runTimes,
			columnVoidVolumes,
			rackPlacementsList
		}
	];

	(* Get the unit operation objects *)
	unitOperationObjects=Lookup[initialCombinedUnitOperationPackets,Object];

	(*--- Protocol packet ---*)

	(* Create the protocol ID *)
	protocolID=CreateID[Object[Protocol,FlashChromatography]];

	(* Create the protocol packet *)
	protocolPacketWithoutRequiredObjectsOrSharedFields=<|
		Object->protocolID,

		(* Fields for samples and sample containers *)
		(* The ifs below are in case we've got models to deal with instead of objects, which shouldn't backlink to Protocols *)
		Replace[SamplesIn]->Map[Link[#,Protocols]&,samplesInResources],
		Replace[ContainersIn]->Map[
			If[MatchQ[#, ObjectP[Object[Container]]] || (MatchQ[#, _Resource] && MatchQ[#[Sample], ObjectP[Object[Container]]]),
				Link[#, Protocols],
				Link[#]
			]&,
			containersInResources
		],

		(* Fields for non-index-matched options that are resources *)
		Instrument->instrumentResource,
		BufferA->bufferAResource,
		BufferB->bufferBResource,

		(* Fields for index-matched options that are resources *)
		Replace[Column]->columnResources,
		Replace[Cartridge]->cartridgeResources,

		(* Fields for other resources *)
		Replace[FractionContainers]->Flatten[fractionContainerResourcesList],
		Replace[Rack]->primaryRackResources,
		Replace[SecondaryRack]->secondaryRackResources,
		Replace[Syringe]->syringeResources,
		Replace[Needle]->needleResources,
		Replace[Frits]->fritResources,
		Replace[Plunger]->plungerResources,
		Replace[CartridgeMedia]->cartridgeMediaResources,
		Replace[CartridgeCap]->cartridgeCapResources,
		Replace[CartridgeCapTubing]->cartridgeCapTubingResources,
		Replace[Beaker]->beakerResources,

		(* Fields for resolved options that aren't resources*)
		Name->resolvedName,
		SeparationMode->resolvedSeparationMode,
		Detector->resolvedDetector,
		Replace[LoadingType]->resolvedLoadingType,
		Replace[PreSampleEquilibration]->resolvedPreSampleEquilibration,
		Replace[LoadingAmount]->resolvedLoadingAmountVolumes,
		Replace[MaxLoadingPercent]->resolvedMaxLoadingPercent,
		Replace[CartridgePackingMaterial]->resolvedCartridgePackingMaterial,
		Replace[CartridgeFunctionalGroup]->resolvedCartridgeFunctionalGroup,
		Replace[CartridgePackingMass]->resolvedCartridgePackingMass,
		Replace[CartridgeDryingTime]->resolvedCartridgeDryingTime,
		Replace[FlowRate]->resolvedFlowRate,
		Replace[GradientA]->resolvedGradientA,
		Replace[GradientB]->resolvedGradientB,
		Replace[Gradient]->resolvedGradient,
		Replace[CollectFractions]->resolvedCollectFractions,
		Replace[FractionCollectionStartTime]->resolvedFractionCollectionStartTime,
		Replace[FractionCollectionEndTime]->resolvedFractionCollectionEndTime,
		Replace[FractionContainer]->Link/@resolvedFractionContainer,
		Replace[MaxFractionVolume]->resolvedMaxFractionVolume,
		Replace[FractionCollectionMode]->resolvedFractionCollectionMode,
		Replace[Detectors]->resolvedDetectorsNoAll,
		Replace[PrimaryWavelength]->resolvedPrimaryWavelength,
		Replace[SecondaryWavelength]->resolvedSecondaryWavelength,
		Replace[WideRangeUV]->resolvedWideRangeUVNoAll,
		Replace[PeakDetectors]->resolvedPeakDetectors,
		Replace[PrimaryWavelengthPeakDetectionMethod]->resolvedPrimaryWavelengthPeakDetectionMethod,
		Replace[PrimaryWavelengthPeakWidth]->resolvedPrimaryWavelengthPeakWidth,
		Replace[PrimaryWavelengthPeakThreshold]->resolvedPrimaryWavelengthPeakThreshold,
		Replace[SecondaryWavelengthPeakDetectionMethod]->resolvedSecondaryWavelengthPeakDetectionMethod,
		Replace[SecondaryWavelengthPeakWidth]->resolvedSecondaryWavelengthPeakWidth,
		Replace[SecondaryWavelengthPeakThreshold]->resolvedSecondaryWavelengthPeakThreshold,
		Replace[WideRangeUVPeakDetectionMethod]->resolvedWideRangeUVPeakDetectionMethod,
		Replace[WideRangeUVPeakWidth]->resolvedWideRangeUVPeakWidth,
		Replace[WideRangeUVPeakThreshold]->resolvedWideRangeUVPeakThreshold,
		Replace[AirPurgeDuration]->resolvedAirPurgeDuration,
		Replace[ColumnStorageCondition]->resolvedColumnStorageCondition,

		(* UnitOperations, ParentProtocol, options lists and Checkpoints *)
		Replace[BatchedUnitOperations]->Map[Link[#,Protocol]&,unitOperationObjects],
		ParentProtocol->Link[resolvedParentProtocol,Subprotocols],
		UnresolvedOptions->myUnresolvedOptions,
		ResolvedOptions->myResolvedOptions,
		Replace[Checkpoints]->{
			{"Preparing Samples",10 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 2"],Time->10 Minute]]},
			{"Instrument Setup",10 Minute,"Buffers are gathered from storage, connected to the instrument, and used to prime the instrument.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 2"],Time->10 Minute]]},
			{"Separating Samples",totalInstrumentTime-20 Minute,"Samples are separated by Flash Chromatography and fractions are collected.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 2"],Time->totalInstrumentTime-20 Minute]]},
			{"Instrument Cleanup",10 Minute,"The instrument is flushed, buffers are disconnected from the instrument, and the instrument is cleaned.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 2"],Time->10 Minute]]},
			{"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 2"],Time->1 Hour]]},
			{"Returning Materials",10 Minute,"Samples are returned to storage.",Link[Resource[Operator->Model[User,Emerald,Operator,"Level 2"],Time->10 Minute]]}
		}
	|>;

	(* Generate a packet with the shared fields *)
	sharedFieldPacket=populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache,Simulation->aliquotSimulation];

	(* Merge the shared fields with the specific fields *)
	protocolPacketWithoutRequiredObjects=Join[sharedFieldPacket,protocolPacketWithoutRequiredObjectsOrSharedFields];

	(* Get all the resource symbolic representations *)
	(* Need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacketWithoutRequiredObjects]],_Resource,Infinity]];

	(* If we are doing Manual preparation, populate the RequiredObjects and RequiredInstruments fields of the protocol packet;
	Null, if we are doing Robotic preparation (we aren't because FlashChromatography doesn't support it) *)
	protocolPacket=If[MatchQ[resolvedPreparation,Manual],
		Join[
			protocolPacketWithoutRequiredObjects,
			<|
				Replace[RequiredObjects]->Link/@Cases[allResourceBlobs,Resource[KeyValuePattern[Type->Object[Resource,Sample]]]],
				Replace[RequiredInstruments]->Link/@Cases[allResourceBlobs,Resource[KeyValuePattern[Type->Object[Resource,Instrument]]]]
			|>
		],
		Null
	];

	(* Call fulfillableResourceQ on all the resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],{True,{}},
		gatherTests,Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cache,Simulation->aliquotSimulation],
		True,{Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cache,Simulation->aliquotSimulation],{}}
	];

	(* Generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		Cases[Flatten[{frqTests}],TestP],
		{}
	];

	(* Generate the Result output rule *)
	(* If not returning Result, or the resources are not fulfillable, Results rule is $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		{protocolPacket,unitOperationPackets},
		$Failed
	];

	(* Return the output as we desire it *)
	outputSpecification/.{resultRule,testsRule}
];



(* ::Subsection::Closed:: *)
(*simulateExperimentFlashChromatography*)

DefineOptions[
	simulateExperimentFlashChromatography,
	Options:>{CacheOption,SimulationOption}
];

simulateExperimentFlashChromatography[
	myProtocolPacket:PacketP[Object[Protocol,FlashChromatography]]|$Failed|Null,
	myUnitOperationPackets:{PacketP[{Object[UnitOperation,FlashChromatography], Object[UnitOperation, LabelSample]}]..}|{PacketP[Object[Primitive,FlashChromatography]]..}|$Failed,
	mySamples:{ObjectP[Object[Sample]]..},
	myResolvedOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[simulateExperimentFlashChromatography]
]:=Module[
	{
		cache,simulation,fastAssoc,protocolObject,mapThreadFriendlyOptions,

		currentSimulation, batchedUnitOperationPackets, simulatedSamplePacketsPossiblyWithExtras,
		simulatedSampleContainerPacketsPossiblyWithExtras, simulatedFractionContainerPacketsPossiblyWithExtras,
		simulatedFritPacketsPossiblyWithExtras,
		simulatedResolvedOptions,simulatedLoadingAmountVolumes,
		simulatedBufferAPacket,simulatedBufferBPacket,simulatedSamplePackets,simulatedSampleContainerPackets,
		simulatedFractionContainerPackets,simulatedFritPackets,simulatedColumnObjects,simulatedCartridgeObjects,

		simulatedFlowRate,simulatedPreSampleEquilibration,simulatedGradientA,simulatedGradientB,
		simulatedCollectFractions,simulatedFractionCollectionStartTime,simulatedFractionCollectionEndTime,simulatedMaxFractionVolume,
		simulatedSamplesOutStorageCondition,

		fractionDurations,preferredFractionStartTimes,preferredFractionEndTimes,fractionStartTimes,fractionEndTimes,
		fractionCompositions,numbersOfFractions,allFractionContainers,usedFractionContainers,fractionDestinations,
		fractionStorageConditions,fractionVolumes,pickFractions,fractionSamplePackets,

		wasteContainerPackets,fakeWasteContainer,wasteSamplePackets,wasteSample,
		usedBufferAVolume,usedBufferBVolume,

		simulatedSampleObjects,simulatedSampleContainerObjects,samplesToWaste,volumesToWaste,wasteSampleTransferPackets,
		nonNullSimulatedFritPackets,simulatedFritObjects,simulatedFritCounts,originalNumberOfFritsAssoc,usedNumberOfFritsAssoc,
		uniqueFrits,originalNumbers,usedNumbers,fritCountPackets,

		simulationWithLabels,finalSimulation
	},

	(* Lookup our cache and simulation. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation=Lookup[ToList[myResolutionOptions],Simulation,Null];

	(* Make the fast association *)
	fastAssoc=makeFastAssocFromCache[cache];

	(* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
	protocolObject=Which[

		(* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
		MatchQ[myProtocolPacket,$Failed],SimulateCreateID[Object[Protocol,FlashChromatography]],

		(* Otherwise, we have a protocol object *)
		True,Lookup[myProtocolPacket,Object]
	];

	(* Get our map thread friendly options. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
		ExperimentFlashChromatography,
		myResolvedOptions
	];

	(* Simulate the fulfillment of all resources by the procedure. *)
	(* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
	(* just make a shell of a protocol object so that we can return something back. *)
	currentSimulation=Which[

		(* If the resource packets failed, make a placeholder protocol object *)
		MatchQ[myProtocolPacket,$Failed],
		Module[{
			simulatedSamples,aliquotSimulation,samplePacket,compatibleContainers,

			changedGradientA,
			changedGradientB,
			changedGradient,
			changedCollectFractions,
			changedFractionCollectionStartTime,
			changedFractionCollectionEndTime,
			changedCartridgeLabel,
			changedFractionContainer,
			changedMaxFractionVolume,

			fixedOptions,

			fixedLoadingAmount,fixedBufferA,fixedBufferB,fixedColumn,fixedCartridge,
			fixedFlowRate,fixedPreSampleEquilibration,fixedGradientA,fixedGradientB,fixedCollectFractions,
			fixedColumnLabel,fixedCartridgeLabel,fixedFractionContainer,

			sampleVolumes,fixedLoadingAmountVolumes,pairedSamplesInAndLoadingAmount,
			sampleVolumeRules,requestedSampleVolumes,sampleVolumePackets,updatedSampleVolumeSimulation,samplesInResourceReplaceRules,samplesInResources,

			totalBufferAVolume,totalBufferBVolume,bufferAResource,bufferBResource,columnResources,cartridgeResources,

			fixedCartridgePackets,fixedCartridgePackingTypes,fixedCartridgeMaxBedWeights,
			fritModels,pairedFritModelAndAmount,fritAmountRules,fritResourceReplaceRules,fritResources,

			preferredFractionContainerRackModels,fractionContainerRackModels,numbersOfPositions,
			numbersOfRacks,numbersOfContainers,fractionContainerResourcesList,fractionContainerPlacementsList,


			allowedKeys,unitOperationOptions,mapThreadFriendlyUnitOperationOptions,
			unitOperationBlobs,initialUnitOperationPackets,unitOperationObjects,
			protocolPacket,unitOperationPackets},

			(* Simulate the aliquot stuff so we can give the simulation to populateSamplePrepFields and fulfillableResourceQ *)
			{simulatedSamples,aliquotSimulation}=simulateSamplesResourcePacketsNew[ExperimentFlashChromatography,mySamples,myResolvedOptions,Cache->cache,Simulation->simulation];

			(* Download the sample packet from the simulation with aliquoting *)
			samplePacket=Download[
				mySamples,
				Packet[Name,Volume,State,Status,Container,LiquidHandlerIncompatible,Solvent,Position],
				Cache->cache,
				Simulation->aliquotSimulation
			];

			(* Get a list of compatible fraction collection containers *)
			compatibleContainers=Flatten[combiFlashCompatibleFractionContainer["Memoization"]];

			(* A big MapThread to check for any options needed for the simulation that are improperly specified *)
			{
				changedGradientA,
				changedGradientB,
				changedGradient,
				changedCollectFractions,
				changedFractionCollectionStartTime,
				changedFractionCollectionEndTime,
				changedCartridgeLabel,
				changedFractionContainer,
				changedMaxFractionVolume
			}=Transpose[
				MapThread[
					Function[{options},
						Module[{
							oldGradientA,
							oldGradientB,
							oldGradient,
							oldCollectFractions,
							oldFractionCollectionStartTime,
							oldFractionCollectionEndTime,
							oldCartridgeLabel,
							oldFractionContainer,
							oldMaxFractionVolume,

							newGradientA,
							newGradientB,
							newGradient,
							newCollectFractions,
							newFractionCollectionStartTime,
							newFractionCollectionEndTime,
							newCartridgeLabel,
							newFractionContainer,
							newMaxFractionVolume,

							oldGradientBTimes,defaultGradientBTimes,defaultGradientBPercents,defaultGradientAPercents,
							newGradientBTimes,newGradientBStart,newGradientBEnd,
							oldFractionContainerMaxVolume,oldFractionContainerValidQ,oldMaxFractionVolumeValidQ
						},
							(* Lookup resolved option values *)
							{
								oldGradientA,
								oldGradientB,
								oldGradient,
								oldCollectFractions,
								oldFractionCollectionStartTime,
								oldFractionCollectionEndTime,
								oldCartridgeLabel,
								oldFractionContainer,
								oldMaxFractionVolume
							}=Lookup[options,{
								GradientA,
								GradientB,
								Gradient,
								CollectFractions,
								FractionCollectionStartTime,
								FractionCollectionEndTime,
								CartridgeLabel,
								FractionContainer,
								MaxFractionVolume
							}];

							(*-- Changes to GradientA, GradientB, Gradient --*)

							(* Get the times of the resolved GradientB *)
							oldGradientBTimes=oldGradientB[[All,1]];

							(* Choose a default gradient to use if something is wrong with the resolved gradients *)
							defaultGradientBTimes={0 Minute,15 Minute};
							defaultGradientBPercents={0 Percent,100 Percent};
							defaultGradientAPercents=100 Percent-defaultGradientBPercents;

							(* If all the resolved gradients match and are valid, use them *)
							{newGradientA,newGradientB,newGradient}=If[
								And[
									Equal[oldGradient[[All,{1,2}]],oldGradientA],
									Equal[oldGradient[[All,{1,3}]],oldGradientB],
									Equal[oldGradientA,Replace[oldGradientB,percentB:PercentP:>100 Percent-percentB,{2}]],
									First[oldGradientBTimes]==0 Minute,
									Last[oldGradientBTimes]>0 Minute,
									AllTrue[
										Differences[oldGradientBTimes],
										GreaterEqualThan[0 Minute]
									]
								],
								{oldGradientA,oldGradientB,oldGradient},

								(* Otherwise, use a default gradient *)
								Transpose[MapThread[
									{{#1,#2},{#1,#3},{#1,#2,#3}}&,
									{defaultGradientBTimes,defaultGradientAPercents,defaultGradientBPercents}
								]]
							];

							(* Get the times of the fixed GradientB *)
							newGradientBTimes=newGradientB[[All,1]];
							newGradientBStart=First[newGradientBTimes];
							newGradientBEnd=Last[newGradientBTimes];

							(* Changes to FractionCollectionStartTime, FractionCollectionEndTime *)

							(* Use the resolved CollectFractions (it defaulted to True, so it is either True or user-specified to False) *)
							newCollectFractions=oldCollectFractions;

							(* Fix the fraction collection start and end times if necessary *)
							{newFractionCollectionStartTime,newFractionCollectionEndTime}=Which[

								(* If CollectFractions is False, set the start and end times to Null *)
								MatchQ[newCollectFractions,False],{Null,Null},

								(* If the resolved start and end times are valid, then use them *)
								And[
									oldFractionCollectionStartTime<oldFractionCollectionEndTime,
									newGradientBStart<=oldFractionCollectionStartTime<newGradientBEnd,
									newGradientBStart<oldFractionCollectionEndTime<=newGradientBEnd
								],
								{oldFractionCollectionStartTime,oldFractionCollectionEndTime},

								(* Otherwise, use the beginning and end times of the gradient *)
								True,{newGradientBStart,newGradientBEnd}
							];

							(*-- Changes to FractionContainer and MaxFractionVolume --*)

							oldFractionContainerMaxVolume=Lookup[
								fetchModelPacketFromFastAssoc[oldFractionContainer,fastAssoc],MaxVolume,Null
							];

							(* Set a Boolean indicating whether the resolved FractionContainer is compatible with the
							instrument and has its MaxVolume field informed *)
							oldFractionContainerValidQ=And[
								MemberQ[compatibleContainers,oldFractionContainer],
								MatchQ[oldFractionContainerMaxVolume,VolumeP]
							];

							(* Set a Boolean indicating whether the resolved MaxFractionVolume is less than or equal to
							the container's MaxVolume *)
							oldMaxFractionVolumeValidQ=And[
								MatchQ[oldFractionContainerMaxVolume,VolumeP],
								MatchQ[oldMaxFractionVolume,VolumeP],
								oldMaxFractionVolume<=oldFractionContainerMaxVolume
							];

							(* Fix the fraction container and max fraction volume if necessary *)
							{newFractionContainer,newMaxFractionVolume}=Switch[
								{newCollectFractions,oldFractionContainerValidQ,oldMaxFractionVolumeValidQ},

								(* If CollectFractions is True and FractionContainer and MaxFractionVolume are valid,
								then use them *)
								{True,True,True},{oldFractionContainer,oldMaxFractionVolume},

								(* If CollectFractions is True and FractionContainer is valid but MaxFractionVolume isn't,
								then use the container and its MaxVolume *)
								{True,True,_},{oldFractionContainer,oldFractionContainerMaxVolume},

								(* Otherwise if CollectFractions is True,
								then use Model[Container,Vessel,"15mL Tube"] and a max volume of 12 mL *)
								{True,_,_},{Model[Container,Vessel,"id:xRO9n3vk11pw"],12 Milliliter},

								(* Otherwise, use Null for both *)
								{_,_,_},{Null,Null}
							];

							(*-- Changes to CartridgeLabel --*)

							(* If Cartridge is not Null, and CartridgeLabel is Null, set a new CartridgeLabel *)
							newCartridgeLabel=If[!NullQ[Lookup[options,Cartridge]]&&NullQ[oldCartridgeLabel],
								ToString[Unique[]],
								oldCartridgeLabel
							];

							(* Return the newly fixed option values *)
							{
								newGradientA,
								newGradientB,
								newGradient,
								newCollectFractions,
								newFractionCollectionStartTime,
								newFractionCollectionEndTime,
								newCartridgeLabel,
								newFractionContainer,
								newMaxFractionVolume
							}
						]
					],
					{mapThreadFriendlyOptions}
				]
			];

			(* Replace any options that were fixed *)
			fixedOptions=ReplaceRule[
				myResolvedOptions,
				{
					GradientA->changedGradientA,
					GradientB->changedGradientB,
					Gradient->changedGradient,
					CollectFractions->changedCollectFractions,
					FractionCollectionStartTime->changedFractionCollectionStartTime,
					FractionCollectionEndTime->changedFractionCollectionEndTime,
					CartridgeLabel->changedCartridgeLabel,
					FractionContainer->changedFractionContainer,
					MaxFractionVolume->changedMaxFractionVolume
				}
			];

			(* Lookup option values *)
			{
				fixedLoadingAmount,
				fixedBufferA,
				fixedBufferB,
				fixedColumn,
				fixedCartridge,
				fixedFlowRate,
				fixedPreSampleEquilibration,
				fixedGradientA,
				fixedGradientB,
				fixedCollectFractions,
				fixedColumnLabel,
				fixedCartridgeLabel,
				fixedFractionContainer
			}=Lookup[
				fixedOptions,
				{
					LoadingAmount,
					BufferA,
					BufferB,
					Column,
					Cartridge,
					FlowRate,
					PreSampleEquilibration,
					GradientA,
					GradientB,
					CollectFractions,
					ColumnLabel,
					CartridgeLabel,
					FractionContainer
				}
			];

			(*-- SamplesIn Resources --*)

			(* Get the rounded volumes of the simulated samples, if they don't have a volume, use 1 Milliliter *)
			sampleVolumes=Map[
				If[MatchQ[#,VolumeP],#,1 Milliliter]&,
				Lookup[samplePacket,Volume]
			];

			(* Replace All in LoadingAmount with the rounded simulated sample's volume *)
			fixedLoadingAmountVolumes=MapThread[
				If[MatchQ[#1,All],#2,#1]&,
				{fixedLoadingAmount,SafeRound[sampleVolumes,flashChromatographyVolumePrecision[],Round->Down]}
			];

			(* Pair the SamplesIn and their LoadingAmount volumes *)
			pairedSamplesInAndLoadingAmount=MapThread[
				#1->#2&,
				{mySamples,fixedLoadingAmountVolumes}
			];

			(* Merge the SamplesIn volumes together to get the requested total volume of each sample's resource *)
			sampleVolumeRules=Merge[pairedSamplesInAndLoadingAmount,Total];

			(* Get a list of the requested total volumes for each sampleIn *)
			requestedSampleVolumes=mySamples/.sampleVolumeRules;

			(* Ensure that the samples are liquid and that they have enough volume for the requested loading amounts *)
			sampleVolumePackets=MapThread[
				<|
					Object->#1,
					State->Liquid,
					Volume->Max[#2,#3]
				|>&,
				{mySamples,sampleVolumes,requestedSampleVolumes}
			];

			(* Update the simulation with the sample volume packets *)
			updatedSampleVolumeSimulation=UpdateSimulation[aliquotSimulation,Simulation[sampleVolumePackets]];

			(* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource
			per sample including in replicates *)
			samplesInResourceReplaceRules=KeyValueMap[
				Function[{sample,volume},
					sample->Resource[Sample->sample,Name->ToString[Unique[]],Amount->volume]
				],
				sampleVolumeRules
			];

			(* Use the replace rules to get the sample resources *)
			samplesInResources=Replace[mySamples,samplesInResourceReplaceRules,{1}];

			(*-- Buffer Resources --*)

			(* Get the total volume required of each buffer *)
			{
				totalBufferAVolume,
				totalBufferBVolume
			}=flashChromatographyBufferVolumes[fixedFlowRate,fixedPreSampleEquilibration,fixedGradientA,fixedGradientB];

			(* Generate the buffer A and B resources *)
			{bufferAResource,bufferBResource}=MapThread[
				Function[{buffer,bufferVolume},
					Link[Resource[
						Sample->buffer,
						Name->ToString[Unique[]],
						Amount->bufferVolume,
						Container->If[bufferVolume>$MaxFlashChromatographyBufferVolume,
							PreferredContainer[bufferVolume],
							Model[Container,Vessel,"Amber Glass Bottle 4 L"]
						],
						RentContainer->True
					]]
				],
				{
					{fixedBufferA,fixedBufferB},
					{totalBufferAVolume,totalBufferBVolume}
				}
			];

			(*-- Column Resources --*)

			(* Generate the column resources index-matched to the Column option *)
			columnResources=MapThread[
				Link[Resource[Sample->#1,Name->#2]]&,
				{fixedColumn,fixedColumnLabel}
			];

			(*-- Cartridge Resources --*)

			(* Generate the cartridge resources index-matched to the Cartridge option *)
			cartridgeResources=MapThread[
				If[NullQ[#1],
					Null,
					Link[Resource[Sample->#1,Name->#2]]
				]&,
				{fixedCartridge,fixedCartridgeLabel}
			];

			(*-- Frit Resources --*)

			fixedCartridgePackets=Map[
				fetchModelPacketFromFastAssoc[#,fastAssoc]&,
				fixedCartridge
			];

			(* Get the values of the PackingType and MaxBedWeight fields of the cartridges *)
			{
				fixedCartridgePackingTypes,
				fixedCartridgeMaxBedWeights
			}=Transpose[
				Lookup[fixedCartridgePackets,{PackingType,MaxBedWeight},Null]
			];

			(* Get the frit models to use based on the cartridge's PackingType and MaxBedWeight *)
			fritModels=MapThread[
				Switch[{#1,#2},
					{HandPacked,LessEqualP[5 Gram]},
					Model[Item,Consumable,"Frits for RediSep 5g Solid Load Cartridge"],

					{HandPacked,LessEqualP[25 Gram]},
					Model[Item,Consumable,"Frits for RediSep 25g Solid Load Cartridge"],

					{HandPacked,LessEqualP[65 Gram]},
					Model[Item,Consumable,"Frits for RediSep 65g Solid Load Cartridge"],

					{_,_},Null
				]&,
				{fixedCartridgePackingTypes,fixedCartridgeMaxBedWeights}
			];

			(* Pair element from the fritModels list with how many will be required (one each) *)
			pairedFritModelAndAmount=Map[
				If[NullQ[#],
					Nothing,
					#->1
				]&,
				fritModels
			];

			(* Get a list of rules for how many of each model of frit will be required *)
			fritAmountRules=Merge[pairedFritModelAndAmount,Total];

			(* Make replace rules for the frits and their resources; doing it this way because we only want to make one resource
			per frit *)
			fritResourceReplaceRules=KeyValueMap[
				Function[{frit,amount},
					frit->Link[Resource[
						Sample->frit,
						Name->ToString[Unique[]],
						Amount->amount
					]]
				],
				fritAmountRules
			];

			(* Replace each frit model from the list index-matched to the samples with the frit resource for that model *)
			fritResources=Replace[fritModels,fritResourceReplaceRules,{1}];

			(*-- Fraction Container Resources --*)

			(* Get a list of the preferred rack model required for each sample *)
			preferredFractionContainerRackModels=flashChromatographyRackModels[fixedFractionContainer];

			(* If the preferred rack model is not a rack model, replace it with Model[Container,Rack,"18mm Tube Rack"] *)
			fractionContainerRackModels=Map[
				If[MatchQ[#,ObjectP[Model[Container,Rack]]],
					#,
					Model[Container,Rack,"18mm Tube Rack"]
				]&,
				preferredFractionContainerRackModels
			];

			(* Get the NumberOfPositions of each required rack model, default to 70 if it isn't informed *)
			numbersOfPositions=Map[
				Lookup[fetchModelPacketFromFastAssoc[#,fastAssoc],NumberOfPositions,70]&,
				fractionContainerRackModels
			];

			(* For the simulation, use 2 racks if we are collecting fractions, 0 otherwise *)
			numbersOfRacks=If[#,2,0]&/@fixedCollectFractions;

			(* Get the number of fraction collection container resources to generate for each sample *)
			numbersOfContainers=numbersOfRacks*numbersOfPositions;

			(* Get an index matched list of fraction container resources *)
			(* Generate enough container resources to fill the number of racks required for each sample *)
			fractionContainerResourcesList=MapThread[
				Table[Link[Resource[Sample->#1,Name->ToString[Unique[]]]],#2]&,
				{fixedFractionContainer,numbersOfContainers}
			];

			(* Make a list of placements to put the fraction collection containers in the fraction collection racks for each sample *)
			fractionContainerPlacementsList=MapThread[
				Function[{numberOfContainers,containerResourcesList},
					If[numberOfContainers==0,
						{},
						Map[{#,Null,Null}&,containerResourcesList]
					]
				],
				{numbersOfContainers,fractionContainerResourcesList}
			];

			(*-- UnitOperation packets --*)

			(* Get a list of the options allowed for the UnitOperation *)
			allowedKeys=allowedKeysForUnitOperationType[Object[UnitOperation,FlashChromatography]];

			(* Get the options to use to generate the UnitOperations *)
			unitOperationOptions=Select[fixedOptions,MatchQ[Keys[#],Alternatives@@allowedKeys]&];

			(* Get the MapThread friendly UnitOperation options *)
			mapThreadFriendlyUnitOperationOptions=OptionsHandling`Private`mapThreadOptions[
				ExperimentFlashChromatography,
				unitOperationOptions
			];

			(* Generate the FlashChromatography batched unit operations blobs with the fields necessary for simulateExperimentFlashChromatography *)
			unitOperationBlobs=Map[FlashChromatography[Sample->#]&,samplesInResources];

			(* Make unit operation packets out of the unit operation blobs *)
			initialUnitOperationPackets=UploadUnitOperation[
				unitOperationBlobs,
				UnitOperationType->Batched,
				Upload->False,
				FastTrack->True
			];

			(* Get the unit operation packets with the fields required in simulateExperimentFlashChromatography *)
			unitOperationPackets=MapThread[
				Function[{
					packet,
					fractionContainerResources,
					fritResource,
					fractionContainerPlacements
				},
					Join[
						packet,
						<|
							Replace[FractionContainers]->fractionContainerResources,
							Replace[Frits]->{fritResource},
							Replace[FractionContainerPlacements]->fractionContainerPlacements
						|>
					]
				],
				{
					initialUnitOperationPackets,
					fractionContainerResourcesList,
					fritResources,
					fractionContainerPlacementsList
				}
			];

			(* Get the unit operation objects *)
			unitOperationObjects=Lookup[initialUnitOperationPackets,Object];

			(* Make a protocol packet with all the fields required in simulateExperimentFlashChromatography and flashChromatographyFractionCompositions*)
			protocolPacket=<|
				Object->protocolObject,
				Replace[SamplesIn]->Map[Link[#,Protocols]&,samplesInResources],
				Replace[FractionContainers]->Flatten[fractionContainerResourcesList],
				BufferA->bufferAResource,
				BufferB->bufferBResource,
				Replace[Column]->columnResources,
				Replace[Cartridge]->cartridgeResources,
				Replace[Frits]->fritResources,

				Replace[LoadingAmount]->fixedLoadingAmountVolumes,
				Replace[GradientB]->fixedGradientB,
				Replace[CollectFractions]->fixedCollectFractions,

				Replace[BatchedUnitOperations]->Map[Link[#,Protocol]&,unitOperationObjects],
				ResolvedOptions->fixedOptions
			|>;

			(* Simulate resources for the mock protocol and unitOperations packets *)
			SimulateResources[protocolPacket,unitOperationPackets,Simulation->updatedSampleVolumeSimulation]
		],

		(* Otherwise, our resource packets went fine and we have an Object[Protocol,FlashChromatography] *)
		True,SimulateResources[myProtocolPacket,myUnitOperationPackets,Simulation->simulation]
	];

	(* Download information from our simulated protocol object *)
	{
		simulatedResolvedOptions,
		simulatedLoadingAmountVolumes,
		simulatedBufferAPacket,
		simulatedBufferBPacket,
		batchedUnitOperationPackets,
		simulatedSamplePacketsPossiblyWithExtras,
		simulatedSampleContainerPacketsPossiblyWithExtras,
		simulatedFractionContainerPacketsPossiblyWithExtras,
		simulatedFritPacketsPossiblyWithExtras,
		simulatedColumnObjects,
		simulatedCartridgeObjects
	}=Quiet[
		Download[
			protocolObject,
			{
				ResolvedOptions,
				LoadingAmount,
				Packet[BufferA[{Model,Name,Composition,Volume,Container}]],
				Packet[BufferB[{Model,Name,Composition,Volume,Container}]],
				Packet[BatchedUnitOperations[{SampleLink, FractionContainerPlacements, Frits}]],
				Packet[BatchedUnitOperations[SampleLink][[1]][{Model,Name,Composition,Volume,Container}]],
				Packet[BatchedUnitOperations[SampleLink][[1]][Container][{Model,Name,MaxVolume}]],
				Packet[BatchedUnitOperations[FractionContainerPlacements][[All,1]][{Model,MaxVolume}]],
				Packet[BatchedUnitOperations[Frits][[1]][{Model,Count}]],
				Column[Object],
				Cartridge[Object]
			},
			Cache->cache,
			Simulation->currentSimulation
		],
		{Download::NotLinkField,Download::FieldDoesntExist}
	];

	{
		simulatedSamplePackets,
		simulatedSampleContainerPackets,
		simulatedFractionContainerPackets,
		simulatedFritPackets
	} = Map[
		PickList[#, batchedUnitOperationPackets, ObjectP[Object[UnitOperation, FlashChromatography]]]&,
		{
			simulatedSamplePacketsPossiblyWithExtras,
			simulatedSampleContainerPacketsPossiblyWithExtras,
			simulatedFractionContainerPacketsPossiblyWithExtras,
			simulatedFritPacketsPossiblyWithExtras
		}
	];

	(* Lookup the necessary option values *)
	{
		simulatedFlowRate,
		simulatedPreSampleEquilibration,
		simulatedGradientA,
		simulatedGradientB,
		simulatedCollectFractions,
		simulatedFractionCollectionStartTime,
		simulatedFractionCollectionEndTime,
		simulatedMaxFractionVolume,
		simulatedSamplesOutStorageCondition
	}=Lookup[simulatedResolvedOptions,{FlowRate,PreSampleEquilibration,GradientA,GradientB,CollectFractions,
		FractionCollectionStartTime,FractionCollectionEndTime,MaxFractionVolume,SamplesOutStorageCondition}];

	(*-- Generate fraction samples --*)

	(* For each sample, calculate the time it would take to collect a fraction with MaxFractionVolume *)
	fractionDurations=simulatedMaxFractionVolume/simulatedFlowRate;

	(* Get lists of each sample's fraction collection preferred start and end times *)
	(* This is assuming that fractions are being continuously collected during the fraction collection time window.
	That will only be true if FractionCollectionMode is All or if it is Peak and peaks are being called for the entire window,
	But for the simulation we assume that we get the max number of fractions that is possible *)
	{preferredFractionStartTimes,preferredFractionEndTimes}=Transpose[
		MapThread[
			Function[{collectFractions,fractionDuration,collectionStart,collectionEnd},
				If[TrueQ[collectFractions],
					Transpose[
						ReplacePart[
							Array[
								collectionStart+fractionDuration*{(#-1),#}&,
								Ceiling[(collectionEnd-collectionStart)/fractionDuration]
							],
							{-1,-1}->collectionEnd
						]
					],
					{{},{}}
				]
			],
			{simulatedCollectFractions,fractionDurations,simulatedFractionCollectionStartTime,simulatedFractionCollectionEndTime}
		]
	];

	(* Get lists of all of the fraction container objects simulated for each sample *)
	(* We are skipping instances of $Failed in simulatedFractionContainerPackets, which might be from LabelSample UOs *)
	allFractionContainers=Lookup[#,Object,{}]&/@DeleteCases[simulatedFractionContainerPackets,$Failed];

	(* Trim the preferred fraction start and end times down to the number of containers we have (two full collection
	rack's worth) if the number of containers is less than the number of preferred fractions *)
	{fractionStartTimes,fractionEndTimes}=Transpose[MapThread[
		{
			Take[#1,Min[Length[#1],Length[#3]]],
			Take[#2,Min[Length[#2],Length[#3]]]
		}&,
		{preferredFractionStartTimes,preferredFractionEndTimes,allFractionContainers}
	]];

	(* For each sample, get a list of the compositions of each fraction: the relative amounts of BufferA and BufferB are
	determined by each fraction's start and end time within the gradient, the amounts of the components from the sample are Null *)
	fractionCompositions=flashChromatographyFractionCompositions[protocolObject,fractionStartTimes,fractionEndTimes,
		Cache->cache,
		Simulation->currentSimulation
	];

	(* Get the number of fractions we will simulate for each sample *)
	numbersOfFractions=Length/@fractionStartTimes;

	(* For each sample, take the fraction collection containers that will be used to hold our simulated fractions for each sample *)
	usedFractionContainers=MapThread[
		Take[#1,#2]&,
		{allFractionContainers,numbersOfFractions}
	];

	(* For each sample, get a list of the destination positions and containers each fraction will be collected in *)
	fractionDestinations=usedFractionContainers/.{container:ObjectP[Object[Container,Vessel]]:>{"A1",container}};

	(* For each sample, get a list of the storage condition of the collected fractions, resolve any Null to Automatic *)
	fractionStorageConditions=MapThread[
		ConstantArray[#1,#2]&,
		{simulatedSamplesOutStorageCondition,numbersOfFractions}
	]/.{Null->Automatic};

	(* For each sample, get a list of the volumes of each fraction (these will be MaxFractionVolume for all fractions except the last) *)
	fractionVolumes=(fractionEndTimes-fractionStartTimes)*simulatedFlowRate;

	(* A helper function that choose elements of a list corresponding to samples for which CollectFractions is True,
	then flattens the resulting lists corresponding to fractions from each sample to one list for all fractions *)
	pickFractions[x_List]:=Flatten[PickList[x,simulatedCollectFractions],1];

	(* Simulate the fraction samples *)
	fractionSamplePackets=UploadSample[
		Flatten[fractionCompositions,1],
		Flatten[fractionDestinations,1],
		InitialAmount->Flatten[fractionVolumes,1],
		StorageCondition->Automatic,
		State->Liquid,
		Simulation->currentSimulation,
		UpdatedBy->protocolObject,
		FastTrack->True,
		Upload->False,
		SimulationMode -> True
	];

	(* Update the current simulation with the fraction sample packets *)
	currentSimulation=UpdateSimulation[currentSimulation,Simulation[fractionSamplePackets]];

	(*-- Send samples and buffers to waste --*)

	(* Make a waste container *)
	wasteContainerPackets=UploadSample[
		{
			Model[Container,Vessel,"id:3em6Zv9NjjkY"]
		},
		{
			{"A1",Object[Container,Room,"id:GmzlKjPrmZX5"]}(* Object[Container, Room, "FakeResources dump"] *)
		},
		Simulation->currentSimulation,
		UpdatedBy->protocolObject,
		FastTrack->True,
		Upload->False,
		SimulationMode -> True
	];

	(* Get the Object of the waste container *)
	fakeWasteContainer=Lookup[wasteContainerPackets[[1]],Object];

	(* Update the current simulation with the waste container packets *)
	currentSimulation=UpdateSimulation[currentSimulation,Simulation[wasteContainerPackets]];

	(* Put a BufferA sample in the waste container *)
	wasteSamplePackets=UploadSample[
		{
			Lookup[simulatedBufferAPacket,Model]
		},
		{
			{"A1",fakeWasteContainer}
		},
		State->Liquid,
		InitialAmount->Null,
		Simulation->currentSimulation,
		UpdatedBy->protocolObject,
		FastTrack->True,
		Upload->False,
		SimulationMode -> True
	];

	(* Get the Object of the waste sample *)
	wasteSample=Lookup[wasteSamplePackets[[1]],Object];

	(* Update the current simulation with the waste sample packets *)
	currentSimulation=UpdateSimulation[currentSimulation,Simulation[wasteSamplePackets]];

	(* Get the total volumes of BufferA and BufferB that will be used (subtract the 300 Milliliter of dead buffer
	volume added in flashChromatographyBufferVolumes) *)
	{
		usedBufferAVolume,
		usedBufferBVolume
	}=flashChromatographyBufferVolumes[simulatedFlowRate,simulatedPreSampleEquilibration,simulatedGradientA,simulatedGradientB]
		-300 Milliliter;

	(* Get lists of the simulated sample objects and their containers *)
	simulatedSampleObjects=Lookup[simulatedSamplePackets,Object,Null];
	simulatedSampleContainerObjects=Lookup[
		If[MatchQ[simulatedSampleContainerPackets,{Null}],{},simulatedSampleContainerPackets],
		Object,
		{Null}
	];

	(* Get a list of the samples that will be sent to waste*)
	samplesToWaste=Flatten[{
		Lookup[simulatedBufferAPacket,Object],
		Lookup[simulatedBufferBPacket,Object],
		simulatedSampleObjects
	}];

	(* Get a list of the volumes of each sample to send to waste *)
	volumesToWaste=Flatten[{
		usedBufferAVolume,
		usedBufferBVolume,
		simulatedLoadingAmountVolumes
	}];

	(* Transfer the gradient buffers and the samples into the waste container *)
	wasteSampleTransferPackets=UploadSampleTransfer[
		samplesToWaste,
		ConstantArray[wasteSample,Length[samplesToWaste]],
		volumesToWaste,
		Simulation->currentSimulation,
		UpdatedBy->protocolObject,
		FastTrack->True,
		Upload->False
	];

	(* Update the current simulation with the waste sample transfer packets *)
	currentSimulation=UpdateSimulation[currentSimulation,Simulation[wasteSampleTransferPackets]];

	(*-- Update Frit Counts --*)

	(* Get the non-null frit packets *)
	nonNullSimulatedFritPackets=Cases[simulatedFritPackets,Except[Null|$Failed]];

	(* Get the frit objects and counts *)
	simulatedFritObjects=Lookup[nonNullSimulatedFritPackets,Object,{}];
	simulatedFritCounts=Lookup[nonNullSimulatedFritPackets,Count,{}];

	(* Get an association of the unique frit objects and their original counts *)
	originalNumberOfFritsAssoc=AssociationThread[simulatedFritObjects->simulatedFritCounts];

	(* Get an association of the number of frits from each unique frit object that will be used *)
	usedNumberOfFritsAssoc=Counts[simulatedFritObjects];

	(* Get a list of the unique frit objects *)
	uniqueFrits=Keys[originalNumberOfFritsAssoc];

	(* Get a list of the original counts of the unique frit objects *)
	originalNumbers=Values[originalNumberOfFritsAssoc];

	(* Get the number of each unique frit object that will be used *)
	usedNumbers=uniqueFrits/.usedNumberOfFritsAssoc;

	(* Simulate an update to the Count field of the frit objects *)
	fritCountPackets=UploadCount[
		uniqueFrits,
		originalNumbers-usedNumbers,
		UpdatedBy->protocolObject,
		FastTrack->True,
		Upload->False,
		Simulation->currentSimulation
	];

	(* Update the current simulation with the frit count packets *)
	currentSimulation=UpdateSimulation[currentSimulation,Simulation[fritCountPackets]];

	(*--- Update labels ---*)

	(* Update the simulation's labels *)
	simulationWithLabels=Simulation[
		Labels->Join[
			Rule@@@Cases[
				DeleteDuplicates[Transpose[{Lookup[myResolvedOptions,SampleLabel],simulatedSampleObjects}]],
				{_String,ObjectP[]}
			],
			Rule@@@Cases[
				DeleteDuplicates[Transpose[{Lookup[myResolvedOptions,SampleContainerLabel],simulatedSampleContainerObjects}]],
				{_String,ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,ColumnLabel],simulatedColumnObjects}],
				{_String,ObjectP[]}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,CartridgeLabel],simulatedCartridgeObjects}],
				{_String,ObjectP[]}
			]
		],
		LabelFields->Join[
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,SampleLabel],(Field[SampleLink[[#]]]&)/@Range[Length[simulatedSampleObjects]]}],
				{_String,_}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,SampleContainerLabel],(Field[SampleLink[[#]][Container]]&)/@Range[Length[simulatedSampleContainerObjects]]}],
				{_String,_}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,ColumnLabel],(Field[ColumnLink[[#]]]&)/@Range[Length[simulatedColumnObjects]]}],
				{_String,_}
			],
			Rule@@@Cases[
				Transpose[{Lookup[myResolvedOptions,CartridgeLabel],(Field[CartridgeLink[[#]]]&)/@Range[Length[simulatedCartridgeObjects]]}],
				{_String,_}
			]
		]
	];

	(* Update the current simulation with the labels *)
	finalSimulation=UpdateSimulation[currentSimulation,simulationWithLabels];

	(* Return the simulated Protocol object and the simulation *)
	{
		protocolObject,
		finalSimulation
	}
];

(* ::Subsection::Closed:: *)
(*ExperimentFlashChromatographyOptions*)


DefineOptions[ExperimentFlashChromatographyOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[Table,List]
			],
			Description->"Indicates whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions:>{ExperimentFlashChromatography}
];

ExperimentFlashChromatographyOptions[myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,(Output->_)|(OutputFormat->_)];

	(* return only the options for ExperimentFlashChromatography *)
	options=ExperimentFlashChromatography[myInput,Append[noOutputOptions,Output->Options]];

	(* If options fail, return failure *)
	If[MatchQ[options,$Failed],
		Return[$Failed]
	];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentFlashChromatography],
		options
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentFlashChromatographyPreview*)

DefineOptions[ExperimentFlashChromatographyPreview,
	SharedOptions:>{ExperimentFlashChromatography}
];

ExperimentFlashChromatographyPreview[myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions},

	(* Get the options as a list*)
	listedOptions=ToList[myOptions];

	(* Remove the Output options before passing to the main function.*)
	noOutputOptions=DeleteCases[listedOptions,Output->_];

	(* Return only the preview for ExperimentFlashChromatography *)
	ExperimentFlashChromatography[myInput,Append[noOutputOptions,Output->Preview]]
];



(* ::Subsection::Closed:: *)
(* ValidExperimentFlashChromatographyQ *)

DefineOptions[ValidExperimentFlashChromatographyQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentFlashChromatography}
];

ValidExperimentFlashChromatographyQ[
	myInput:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String],
	myOptions:OptionsPattern[ValidExperimentFlashChromatographyQ]]:=Module[
	{listedOptions,listedInput,preparedOptions,filterTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];
	listedInput=ToList[myInput];

	(* Remove the Output option before passing to the core function *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentFlashChromatography *)
	filterTests=ExperimentFlashChromatography[listedInput,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[filterTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[listedInput,_String],OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[listedInput,_String],validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest,filterTests,voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMeasureConductivityQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentFlashChromatographyQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentFlashChromatographyQ"]
];

