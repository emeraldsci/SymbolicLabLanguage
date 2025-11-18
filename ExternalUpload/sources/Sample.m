(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadSampleModel*)


(* ::Subsubsection:: *)
(*Options and Messages*)

(* Share the composition widget *)
uploadSampleModelCompositionWidget[] := Adder[{
	"Amount" -> Alternatives[
		Widget[
			Type -> Quantity,
			Pattern :> Alternatives[
				GreaterP[0 Molar],
				GreaterP[0 Gram / Liter],
				RangeP[0 VolumePercent, 100 VolumePercent],
				RangeP[0 MassPercent, 100 MassPercent],
				RangeP[0 PercentConfluency, 100 PercentConfluency],
				GreaterP[0 Cell / Liter],
				GreaterP[0 CFU / Liter],
				GreaterP[0 OD600]
			],
			Units -> Alternatives[
				{1, {Molar, {Micromolar, Millimolar, Molar}}},
				CompoundUnit[
					{1, {Gram, {Kilogram, Gram, Milligram, Microgram}}},
					{-1, {Liter, {Liter, Milliliter, Microliter}}}
				],
				{1, {VolumePercent, {VolumePercent}}},
				{1, {MassPercent, {MassPercent}}},
				{1, {PercentConfluency, {PercentConfluency}}},
				CompoundUnit[
					{1, {EmeraldCell, {EmeraldCell}}},
					{-1, {Milliliter, {Liter, Milliliter, Microliter}}}
				],
				CompoundUnit[
					{1, {CFU, {CFU}}},
					{-1, {Milliliter, {Liter, Milliliter, Microliter}}}
				],
				{1, {OD600, {OD600}}}
			]
		],
		Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
	],
	"Identity Model" -> Alternatives[
		Widget[Type -> Object, Pattern :> ObjectP[List @@ IdentityModelTypeP]],
		Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
	]
}];

DefineOptions[UploadSampleModel,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Name,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The common or proprietary name of the sample, used to identify it in Constellation.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Name.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Synonyms,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
				Description -> "A list of alternative names for this substance.",
				ResolutionDescription -> "If creating a new object, automatically set to the specified object name. If modifying an existing object, automatically set to match the field value of Synonyms.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Composition,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> uploadSampleModelCompositionWidget[],
				Description -> "The various components that constitute this sample model, along with their respective concentrations. Specifying 'Null' for amount indicates a component of unknown concentration, and specifying 'Null' for the component indicates an unknown or proprietary component.",
				ResolutionDescription -> "If creating a new object, composition must be specified. If modifying an existing object, automatically set to match the field value of Composition.",
				Category -> "Composition Information"
			},
			{
				OptionName -> OpticalComposition,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[{
					"Amount" -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> Alternatives[
								RangeP[0 Percent, 100 Percent]
							],
							Units -> Alternatives[
								Percent
							]
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					],
					"Identity Model" -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[List @@ IdentityModelTypeP]],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					]
				}],
				Description -> "If samples of this model contain chiral component(s), the relative amounts of each of the two enantiomers, in percent, for each chiral substance. If only one enantiomer of a pair is present, the amount for that enantiomer must be 100%, and if both are present, the total for the pair must be 100%.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of OpticalComposition.",
				Category -> "Composition Information"
			},
			{
				OptionName -> Media,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Sample]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Cell Culture",
							"Media"
						}
					}
				],
				Description -> "The base cell growth solution of this sample model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Media.",
				Category -> "Composition Information"
			},
			{
				OptionName -> UsedAsMedia,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are typically used as a cell growth medium.",
				ResolutionDescription -> "If creating a new object, automatically set to False. If modifying an existing object, automatically set to match the field value of UsedAsMedia.",
				Category -> "Usage Information"
			},
			{
				OptionName -> Living,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if there is living material in samples of this model.",
				ResolutionDescription -> "If creating a new object, automatically set to False. If modifying an existing object, automatically set to match the field value of Living.",
				Category -> "Biological Information"
			},
			{
				OptionName -> CellType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CellTypeP
				],
				Description -> "The taxon of the organism or cell line from which the cell sample originates.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of CellType.",
				Category -> "Biological Information"
			},
			{
				OptionName -> Solvent,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Sample]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Solvents"
						}
					}
				],
				Description -> "The base component of this sample model that contains, dissolves and disperses the other components.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Solvent.",
				Category -> "Composition Information"
			},
			{
				OptionName -> UsedAsSolvent,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if samples of this model are typically used to dissolve other substances.",
				ResolutionDescription -> "If creating a new object, automatically set to False. If modifying an existing object, automatically set to match the field value of UsedAsSolvent.",
				Category -> "Usage Information"
			},
			{
				OptionName -> ConcentratedBufferDiluent,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Sample]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Solvents"
						}
					}
				],
				Description -> "The solvent required to dilute this sample model to form BaselineStock. The model is diluted by ConcentratedBufferDilutionFactor.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ConcentratedBufferDiluent.",
				Category -> "Stock Solution Information"
			},
			{
				OptionName -> ConcentratedBufferDilutionFactor,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> GreaterP[0]],
				Description -> "The amount by which this the sample must be diluted with its ConcentratedBufferDiluent in order to form standard ratio of Models for 1X buffer, the BaselineStock.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ConcentratedBufferDilutionFactor.",
				Category -> "Stock Solution Information"
			},
			{
				OptionName -> BaselineStock,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Sample]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents"
						}
					}
				],
				Description -> "The 1X version of buffer that this sample model forms when diluted with ConcentratedBufferDiluent by a factor of ConcentrationBufferDilutionFactor.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of BaselineStock.",
				Category -> "Stock Solution Information"
			},
			{
				OptionName -> AlternativeForms,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Model[Sample]]]],
				Description -> "Other sample models representing variations of the same substance with different grades, hydration states, monobasic/dibasic forms, etc.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of AlternativeForms.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Grade,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> GradeP],
				Description -> "The purity standard of this sample model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Grade.",
				Category -> "Purity Information"
			},
			{
				OptionName -> ProductDocumentationFiles,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Alternatives[
					"URL" -> Widget[Type -> String, Pattern :> URLP, Size -> Line],
					"File Path" -> Widget[Type -> String, Pattern :> FilePathP, Size -> Line],
					"EmeraldCloudFile" -> Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]], PatternTooltip -> "A cloud file stored on Constellation that ends in .PDF."]
				]],
				Description -> "PDFs of any product documentation provided by the supplier of this model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ProductDocumentationFiles.",
				Category -> "Documentation"
			},
			{
				OptionName -> Density,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[(0 * Gram) / Milliliter],
					Units -> CompoundUnit[
						{1, {Gram, {Microgram, Milligram, Gram, Kilogram}}},
						Alternatives[
							{-3, {Meter, {Millimeter, Centimeter, Meter}}},
							{-1, {Liter, {Microliter, Milliliter, Liter}}}
						]
					]
				],
				Description -> "The mass of sample per amount of volume for a sample of this model at room temperature and pressure.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Density.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> ExtinctionCoefficients,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[
					{
						"Wavelength" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 * Nanometer],
							Units -> {1, {Nanometer, {Nanometer, Micrometer, Millimeter, Meter}}}
						],
						"ExtinctionCoefficient" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Liter / (Centimeter * Mole)],
							Units -> CompoundUnit[
								{1, {Liter, {Microliter, Milliliter, Liter}}},
								{-1, {Centimeter, {Micrometer, Millimeter, Centimeter, Meter}}},
								{-1, {Mole, {Micromole, Millimole, Mole, Kilomole}}}
							]
						]
					}
				],
				Description -> "A measure of how strongly samples of this model absorb light at a particular wavelength.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ExtinctionCoefficients.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> MeltingPoint,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Kelvin],
					Units -> Alternatives[
						{1, {Celsius, {Celsius}}},
						{1, {Kelvin, {Kelvin}}},
						{1, {Fahrenheit, {Fahrenheit}}}
					]
				],
				Description -> "The temperature at which samples of this model transition from solid to liquid at atmospheric pressure.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of MeltingPoint.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> BoilingPoint,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Kelvin],
					Units -> Alternatives[
						{1, {Celsius, {Celsius}}},
						{1, {Kelvin, {Kelvin}}},
						{1, {Fahrenheit, {Fahrenheit}}}
					]
				],
				Description -> "The temperature at which bulk sample of this model transitions from condensed phase to gas at atmospheric pressure. This occurs when the vapor pressure of the sample equals atmospheric pressure.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of BoilingPoint.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> VaporPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 * Kilo * Pascal],
					Units -> Alternatives[
						{1, {Pascal, {Micropascal, Millipascal, Pascal, Kilopascal, Megapascal}}},
						{1, {Atmosphere, {Atmosphere}}},
						{1, {Bar, {Microbar, Millibar, Bar, Kilobar}}},
						{1, {Torr, {Millitorr, Torr}}}
					]
				],
				Description -> "The pressure of the vapor in thermodynamic equilibrium with condensed phase for samples of this model in a closed system at room temperature.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of VaporPressure.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Viscosity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 * Pascal * Second],
					Units -> Alternatives[
						{1, {Poise, {Millipoise, Centipoise, Poise}}},
						CompoundUnit[
							{1, {Pascal, {Micropascal, Millipascal, Pascal, Kilopascal}}},
							{1, {Second, {Microsecond, Millisecond, Second}}}
						]
					]
				],
				Description -> "The dynamic viscosity of samples of this model at room temperature and pressure, indicating how resistant it is to flow when an external force is applied.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Viscosity.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> pKa,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> Number, Pattern :> RangeP[-Infinity, Infinity]]],
				Description -> "The logarithmic acid dissociation constants of the substance at room temperature in water.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of pKa.",
				Category -> "Physical Properties"
			},
			(* The FixedAmounts and TransferOutSolventVolumes need to be index-matched. It is enforced in VOQ for now *)
			{
				OptionName -> FixedAmounts,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Quantity,
						Pattern :> Alternatives[
							GreaterP[0 * Gram],
							GreaterP[0 * Liter]
						],
						Units -> Alternatives[
							{1, {Gram, {Microgram, Milligram, Gram}}},
							{1, {Liter, {Microliter, Milliliter, Liter}}}
						]
					]
				],
				Description -> "If this sample model is purchased and stored in pre-measured amounts, the amounts that samples of this model exist in.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of FixedAmounts.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> TransferOutSolventVolumes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 * Liter],
						Units -> {1, {Liter, {Microliter, Milliliter, Liter}}}
					]
				],
				Description -> "If this sample model is purchased and stored in pre-measured amounts, the amounts of dissolution solvents required to solvate each of the fixed amounts that this model is handled in.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of TransferOutSolventVolumes.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> SingleUse,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if samples of this model must be used only once and then disposed of after use.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of SingleUse.",
				Category -> "Expiration Properties"
			},
			{
				OptionName -> Tablet,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this sample model is composed of small disks of compressed solid substance.",
				ResolutionDescription -> "If creating a new object, automatically set to False. If modifying an existing object, automatically set to match the field value of Tablet.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> Sachet,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if this sample model is in the form of a small pouch filled with a measured amount of loose solid substance.",
				ResolutionDescription -> "If creating a new object, automatically set to False. If modifying an existing object, automatically set to match the field value of Sachet.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> SolidUnitWeight,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Gram],
					Units -> {1, {Gram, {Microgram, Milligram, Gram}}}
				],
				Description -> "If samples of this model come in tablet or sachet form, the average mass of sample in a single tablet or sachet.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of SolidUnitWeight.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> DefaultSachetPouch,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Material]]],
				Description -> "If samples of this model come in sachet form, the material that the enclosing pouch is made from.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of DefaultSachetPouch.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> Fiber,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if samples of this model consist of a thin cylindrical string of solid substance.",
				ResolutionDescription -> "If creating a new object, automatically set to False. If modifying an existing object, automatically set to match the field value of Fiber.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> FiberCircumference,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> Millimeter
				],
				Description -> "If samples of this model come in fiber form, the length of the perimeter of the circular cross-section of the sample.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of FiberCircumference.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> Products,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Product]]]],
				Description -> "Product objects describing commercially available entities composed of samples of this model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Products.",
				Category -> "Inventory"
			},
			{
				OptionName -> ServiceProviders,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ListableP[ObjectP[Object[Company, Service]]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Service Providers"
						}
					}
				],
				Description -> "Companies that can be contracted to synthesize samples of this model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ServiceProviders.",
				Category -> "Inventory"
			},
			{
				OptionName -> ThawTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> RangeP[-20 Celsius, 90 Celsius], Units -> {1, {Celsius, {Celsius, Fahrenheit, Kelvin}}}],
				Description -> "The typical temperature that samples of this model should be defrosted at before using in experimentation.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ThawTemperature.",
				Category -> "Handling Temperatures"
			},
			{
				OptionName -> ThawTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Second], Units -> {1, {Second, {Hour, Minute, Second}}}],
				Description -> "The typical time that samples of this model should be defrosted before using in experimentation. If the samples are still not thawed after this time, thawing will continue until the samples are fully thawed.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ThawTime.",
				Category -> "Handling Temperatures"
			},
			{
				OptionName -> MaxThawTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 * Second], Units -> {1, {Second, {Hour, Minute, Second}}}],
				Description -> "The default maximum time that samples of this model should be defrosted before using in experimentation.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of MaxThawTime.",
				Category -> "Handling Temperatures"
			},
			{
				OptionName -> PipettingMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Method, Pipetting]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Pipetting Methods"
						}
					}
				],
				Description -> "The default parameters describing how pure samples of this molecule should be manipulated by pipette, such as aspiration and dispensing rates. These parameters may be overridden when creating experiments.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of PipettingMethod.",
				Category -> "Transfer Properties"
			},
			{
				OptionName -> ThawCellsMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Method, ThawCells]]],
				Description -> "The default method object containing the parameters to use to bring cryovials containing this sample model up to ambient temperature.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ThawCellsMethod.",
				Category -> "Handling Temperatures"
			},
			{
				OptionName -> AsepticTransportContainerType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> AsepticTransportContainerTypeP],
				Description -> "The manner in which samples of this model are contained in an aseptic barrier and if they need to be unbagged before being used in an experiment.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of AsepticTransportContainerType.",
				Category -> "Sterility"
			},
			{
				OptionName -> Notebook,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[LaboratoryNotebook]]],
				Description -> "The notebook this sample model will belong to. If set to Null, the sample model will be public and visible to all users.",
				ResolutionDescription -> "If creating a new object, automatically set to $Notebook. If modifying an existing object, automatically set to match the field value of Notebook.",
				Category -> "Hidden"
			},
			{
				OptionName -> PreferredMALDIMatrix,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ListableP[ObjectP[Model[Sample, Matrix]]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Mass Spectrometry",
							"MALDI Matrix"
						}
					}
				],
				Description -> "The substance best suited to co-crystallize with samples of this model in preparation for mass spectrometry using the matrix-assisted laser desorption/ionization (MALDI) technique.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of PreferredMALDIMatrix.",
				Category -> "Compatibility"
			},
			{
				OptionName -> AluminumFoil,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if containers that contain this sample model should be wrapped in aluminum foil to protect the container contents from light by default.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of AluminumFoil.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> Analytes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[
					Type -> Object,
					Pattern :> ObjectP[List@@IdentityModelTypeP]
				]],
				Description -> "The molecular entities of primary interest in this sample model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Analytes.",
				Category -> "Composition Information"
			},
			{
				OptionName -> Aqueous,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are a solution in water.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Aqueous.",
				Category -> "Composition Information"
			},
			{
				OptionName -> AutoclaveUnsafe,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are unstable and can potentially degrade under extreme heating conditions.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of AutoclaveUnsafe.",
				Category -> "Compatibility"
			},
			{
				OptionName -> BarcodeTag,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Item, Consumable]]
				],
				Description -> "The secondary tag used to affix a barcode to this object.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of BarcodeTag.",
				Category -> "Hidden"
			},
			{
				OptionName -> ChangeMediaMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, ChangeMedia]]
				],
				Description -> "The default method object containing the parameters to use to change the base cell growth solution for cultures of this sample model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ChangeMediaMethod.",
				Category -> "Biological Information"
			},
			{
				OptionName -> Conductivity,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Expression,
					Pattern :> DistributionP[Microsiemen / Centimeter],
					Size -> Line
				],
				Description -> "The degree to which samples of this model facilitate the flow of electric charge.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Conductivity.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> ContinuousOperation,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are required to be continuously available for use in the lab, regardless of if it is InUse by a specific protocol.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ContinuousOperation.",
				Category -> "Hidden"
			},
			{
				OptionName -> Deprecated,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates that this model is historical and no longer used in the ECL.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Deprecated.",
				Category -> "Hidden"
			},
			{
				OptionName -> GloveBoxBlowerIncompatible,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates that the glove box blower must be turned off to prevent damage to the catalyst in the glove box that is used to remove traces of water and oxygen when manipulating samples of this model inside of the glove box.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of GloveBoxBlowerIncompatible.",
				Category -> "Compatibility"
			},
			{
				OptionName -> GloveBoxIncompatible,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model cannot be used inside of a glove box due high volatility and/or detrimental reactivity with the catalyst in the glove box that is used to remove traces of water and oxygen. Sulfur and sulfur compounds (such as H2S, RSH, COS, SO2, SO3), halides, halogen (Freon), alcohols, hydrazine, phosphene, arsine, arsenate, mercury, and saturation with water may deactivate the catalyst.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of GloveBoxIncompatible.",
				Category -> "Compatibility"
			},
			{
				OptionName -> InertHandling,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model must be handled in a glove box under an unreactive atmosphere.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of InertHandling.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> KitProducts,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Product]]
				]],
				Description -> "Product objects describing commercially available entities composed of samples of this model, if this model is part of one or more kits.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of KitProducts.",
				Category -> "Inventory"
			},
			{
				OptionName -> LabWasteDisposal,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model may be safely disposed into a regular lab waste container.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of LabWasteDisposal.",
				Category -> "Disposal Information"
			},
			{
				OptionName -> NominalParticleSize,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Expression,
					Pattern :> DistributionP[Nanometer],
					Size -> Line
				],
				Description -> "If containing or composed of discrete fragments of solid, such as a powder or suspension, the manufacturer stated distribution of particle dimensions in the sample model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of NominalParticleSize.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> NucleicAcidFree,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are verified to be free from nucleic acids - large biomolecules composed of nucleotides that may encode genetic information, such as DNA and RNA.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of NucleicAcidFree.",
				Category -> "Compatibility"
			},
			{
				OptionName -> Parafilm,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if containers that contain this sample model should have their covers sealed with parafilm by default.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Parafilm.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> ParticleWeight,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Gram],
					Units -> {1, {Gram, {Nanogram, Microgram, Milligram, Gram}}}
				],
				Description -> "If containing or composed of discrete fragments of solid, such as a powder or suspension, the average weight of a single fragment of the sample.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ParticleWeight.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> pH,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> RangeP[0, 14]],
				Description -> "The logarithmic concentration of hydrogen ions of samples of this model at room temperature.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of pH.",
				Category -> "Chemical Properties"
			},
			{
				OptionName -> PreferredWashBin,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Container, WashBin]]
				],
				Description -> "The recommended bin for samples of this model prior to dishwashing.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of PreferredWashBin.",
				Category -> "Hidden"
			},
			{
				OptionName -> Preparable,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model may be prepared as needed during the course of an experiment.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Preparable.",
				Category -> "Hidden"
			},
			{
				OptionName -> PyrogenFree,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are verified to be free from compounds that induce fever when introduced into the bloodstream, such as Endotoxins.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of PyrogenFree.",
				Category -> "Compatibility"
			},
			{
				OptionName -> RefractiveIndex,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> GreaterP[1]],
				Description -> "The ratio of the speed of light in a vacuum to the speed of light travelling through samples of this model at 20 degree Celsius.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of RefractiveIndex.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Resuspension,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if one of the components in this sample model can only be prepared by adding a solution to its original container to dissolve it. The dissolved sample can be optionally removed from the original container for other preparation steps.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Resuspension.",
				Category -> "Transfer Properties"
			},
			{
				OptionName -> ReversePipetting,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if additional source sample should be aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into a destination position. It is recommended to set ReversePipetting->True if this sample model foams or forms bubbles easily.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ReversePipetting.",
				Category -> "Transfer Properties"
			},
			{
				OptionName -> RNaseFree,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are verified to be free from enzymes that break down ribonucleic acid (RNA).",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of RNaseFree.",
				Category -> "Compatibility"
			},
			{
				OptionName -> SolidUnitWeightDistribution,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Expression,
					Pattern :> DistributionP[Gram],
					Size -> Line
				],
				Description -> "If samples of this model come in tablet or sachet form, the range of masses of sample in a single tablet or sachet.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of SolidUnitWeightDistribution.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> StickeredUponArrival,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if a barcode should be attached to this item during Receive Inventory, or if the unpeeled sticker should be stored with the item and affixed during resource picking.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of StickeredUponArrival.",
				Category -> "Hidden"
			},
			{
				OptionName -> StoragePositions,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[{
					"Container" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Container], Object[Instrument]}]
					],
					"Position" -> Alternatives[
						Widget[
							Type -> String,
							Pattern :> LocationPositionP,
							Size -> Word
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					]
				}],
				Description -> "The specific containers and positions in which samples of this model should typically be stored, allowing more granular organization within storage locations that satisfy default storage condition.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of StoragePositions.",
				Category -> "Hidden"
			},
			{
				OptionName -> SurfaceTension,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Newton / Meter],
					Units -> CompoundUnit[
						{1, {Millinewton, {Millinewton, Newton}}},
						{-1, {Meter, {Micrometer, Millimeter, Centimeter, Meter}}}
					]
				],
				Description -> "The ability of the surface of samples of this model to resist breaking when disrupted by an external force. Surface tension arises from the tendency of the constituent molecules to stick together and minimize the liquid's surface area.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of SurfaceTension.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Tags,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
				Description -> "Labels that are used for the management and organization of samples. If an aliquot is taken out of this sample, the new sample that is generated will inherit this sample's tags.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Tags.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> ThawMixRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 RPM],
					Units -> RPM
				],
				Description -> "The default frequency of rotation the default instrument uses to homogenize samples of this model following thawing.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ThawMixRate.",
				Category -> "Usage Information"
			},
			{
				OptionName -> ThawMixTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Minute],
					Units -> {1 Minute, {Second, Minute, Hour, Day}}
				],
				Description -> "The default duration for which samples of this model are homogenized following thawing.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ThawMixTime.",
				Category -> "Usage Information"
			},
			{
				OptionName -> ThawMixType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> MixTypeP
				],
				Description -> "The default style of motion used to homogenize samples of this model following defrosting.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ThawMixType.",
				Category -> "Usage Information"
			},
			{
				OptionName -> ThawNumberOfMixes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				],
				Description -> "The default number of times samples of this model are homogenized by inversion or pipetting up and down following defrosting.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ThawNumberOfMixes.",
				Category -> "Usage Information"
			},
			{
				OptionName -> TransferTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Kelvin],
					Units -> {1 Celsius, {Celsius, Fahrenheit, Kelvin}}
				],
				Description -> "The temperature at which samples of this model should be heated or cooled to when moved around the lab during experimentation, if different from ambient temperature.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of TransferTemperature.",
				Category -> "Handling Temperatures"
			},
			{
				OptionName -> TransportCondition,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[TransportCondition]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Transport Conditions"
						}
					}
				],
				Description -> "The environment in which samples of this model should be transported when in use by an experiment, if different from ambient conditions.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of TransportCondition.",
				Category -> "Handling Properties"
			},
			{
				OptionName -> UNII,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word],
				Description -> "The Unique Ingredient Identifier of this substance based on the unified identification scheme of FDA.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of UNII.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Verified,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the information in this model has been reviewed for accuracy by an ECL employee.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Verified.",
				Category -> "Hidden"
			},
			{
				OptionName -> WashCellsMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, WashCells]]
				],
				Description -> "The default method object containing the parameters to use to purify cultures of this sample model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of WashCellsMethod.",
				Category -> "Biological Information"
			},
			{
				OptionName -> Waste,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are a collection of other samples that are to be thrown out.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of Waste.",
				Category -> "Hidden"
			},
			{
				OptionName -> WasteType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> WasteTypeP
				],
				Description -> "Indicates the type of waste collected in this sample model.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of WasteType.",
				Category -> "Hidden"
			},
			{
				OptionName -> WettedMaterials,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Adder[Widget[
					Type -> Enumeration,
					Pattern :> MaterialP
				]],
				Description -> "If containing or composed of a structural material, such as a fiber or bead, the types of such matter that may come in direct contact with fluids.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of WettedMaterials.",
				Category -> "Compatibility"
			},
			{
				OptionName -> ForeignMaterialContactDisallowed,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if any contact of this sample with submerged item/part is blocked.",
				ResolutionDescription -> "If modifying an existing object, automatically set to match the field value of ForeignMaterialContactDisallowed.",
				Category -> "Compatibility"
			}
		]
	},

	SharedOptions :> {
		ModelSampleHealthAndSafetyOptions,
		ExternalUploadHiddenOptions
	}
];


installDefaultUploadFunction[
	UploadSampleModel,
	Model[Sample],
	OptionResolver -> resolvedUploadSampleOptions,
	AuxilliaryPacketsFunction -> uploadSampleModelAuxilliaryPackets,
	InputPattern -> Alternatives[
		(* Create a new model with a name *)
		_String,

		(* Modify an existing model *)
		Model[Sample],

		(* Create a new model with composition *)
		ModelCompositionP,

		(* Molecule identifiers *)
		_PubChem,
		GreaterEqualP[1, 1], (* Numbers are interpreted as PubChem ID *)
		InChIP,
		InChIKeyP,
		CASNumberP,
		ThermoFisherURLP,
		MilliporeSigmaURLP
	]
];
installDefaultValidQFunction[UploadSampleModel, Model[Sample]];
installDefaultOptionsFunction[UploadSampleModel, Model[Sample]];


(* ::Subsubsection::Closed:: *)
(*Option Resolver*)

Error::MissingLivingOption = "For inputs, `1`, the Model[Cell](s), `2` were found in the provided Composition. Please use the Living option to specify whether the cells are alive or dead.";

(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
(* This is a legacy resolver where the original version wasn't listable, so this is a bit hacky in the short term *)
(* This helper will soon be re-written *)
(* But I want to get the framework refactor online first as a separate entity for better testing *)
resolvedUploadSampleOptions[myType_, myInput:{___}, myOptions_, rawOptions_] := Module[
	{result, inputsWithInvalidOptions},

	(* Map over the singleton function - this is legacy code *)
	{result, inputsWithInvalidOptions} = Transpose@MapThread[
		Module[{originalResult},

			(* Run the option resolver for each input. Quiet and catch the living option error message that's thrown so we can thrown it just the once later *)
			Quiet[Check[
				originalResult = resolvedUploadSampleOptions[myType, #1, #2, #3];
				{originalResult, {}},

				(* If we threw the missing living option message, store that invalid input *)
				{originalResult, #1},

				(* Only check for intended message *)
				{Error::MissingLivingOption}
			], {Error::MissingLivingOption}]
		]&,
		{myInput, myOptions, rawOptions}
	];

	(* If any of the inputs failed, now throw the message to the front end, once, in listed form *)
	If[!MatchQ[Flatten[inputsWithInvalidOptions], {}],
		Message[Error::MissingLivingOption, Flatten[inputsWithInvalidOptions], Cases[#, ObjectP[Model[Cell]], Infinity] & /@ Lookup[PickList[result, inputsWithInvalidOptions, Except[{}]], Composition]]
	];

	(* Return the output in the expected format *)
	<|
		Result -> result,
		InvalidInputs -> {},
		InvalidOptions -> If[!MatchQ[Flatten[inputsWithInvalidOptions], {}], {Living}, {}],
		Tests -> {}
	|>
];

(* New object overload. *)
resolvedUploadSampleOptions[myType_, myIdentifier : Alternatives[_String, Null, GreaterEqualP[1, 1], _PubChem], myOptions_, rawOptions_] := Module[
	{
		myOptionsAssociation, resolvedNotebook, myOptionsAssociationWithNotebook, myOptionsWithName, pubChemInformation, safeComposition,
		myOptionsWithPubChem, myOptionsWithSynonyms, allIdentityModels, resolvedSafetyOptions, mysemiFinalizedOptions, myOptionsWithSharedResolution,
		modelCellInComposition, cellPacketsInComposition, livingOptionProvidedBool, cellTypeProvidedBool, allIdentityModelPackets,
		resolvedCellType, resolvedSterile, resolvedAsepticHandling, myFinalizedOptions, myManuallyResolvedOptions
	},

	(* Convert the options to an association. *)
	myOptionsAssociation = Association @@ myOptions;
	resolvedNotebook = If[MatchQ[Lookup[myOptionsAssociation, Notebook], Automatic],
		Download[$Notebook, Object],
		Lookup[myOptionsAssociation, Notebook]
	];

	myOptionsAssociationWithNotebook = Append[myOptionsAssociation, Notebook -> resolvedNotebook];

	(* This option resolver is a little unusual in that we have to AutoFill the options in order to compute *)
	(* either the tests or the results. *)

	(* -- AutoFill based on the information we're given. -- *)

	(* Try to get information from PubChem. *)
	(* If unsuccessful, the helper will throw an error and return $Failed. Quiet for now and sub in empty association instead to maintain current behavior *)
	(* Bypass for unit testing *)
	pubChemInformation = Which[
		(* If a name contains $SessionUUID we know it's not a known molecule, so don't bother trying. Speeds up testing *)
		StringQ[myIdentifier] && StringContainsQ[myIdentifier, $SessionUUID],
		<||>,

		(* If Null, nothing we can do *)
		NullQ[myIdentifier],
		<||>,

		(* Integers are PubChem identifiers, which need to be wrapped in PubChem head for the search *)
		MatchQ[myIdentifier, GreaterEqualP[1, 1]],
		Quiet[Check[
			scrapeMoleculeData[PubChem[myIdentifier]],
			<||>
		]],

		(* Otherwise try the search with the input *)
		True,
		Quiet[Check[
			scrapeMoleculeData[myIdentifier],
			<||>
		]]
	];

	(* Overwrite the Name option if it is Null or an identifier was used and we found the name from PubChem *)
	myOptionsWithName = Which[
		(* Use the name option if specified - no modification required *)
		StringQ[Lookup[myOptionsAssociationWithNotebook, Name]],
		myOptionsAssociationWithNotebook,

		(* Otherwise check the input *)
		(* Swap if a clear identifier was provided and we found something from PubChem *)
		And[
			StringQ[Lookup[pubChemInformation, Name]],
			MatchQ[myIdentifier,
				Alternatives[
					_Integer,
					_PubChem,
					URLP,
					CASNumberP,
					InChIP,
					InChIKeyP
				]
			]
		],
		Append[
			myOptionsAssociationWithNotebook,
			Name -> Lookup[pubChemInformation, Name]
		],

		(* Otherwise, use the input if a string *)
		StringQ[myIdentifier],
		Append[
			myOptionsAssociationWithNotebook,
			Name -> myIdentifier
		],

		(* Otherwise Null *)
		True,
		Append[
			myOptionsAssociationWithNotebook,
			Name -> Null
		]
	];

	myOptionsWithPubChem = If[MatchQ[pubChemInformation, $Failed],
		myOptionsWithName,
		Module[{filteredPubChemOptions},
			(* Some PubChem keys may not be options to UploadSampleModel. *)
			filteredPubChemOptions = Association@(KeyValueMap[
				Function[{key, value},
					If[KeyExistsQ[myOptionsAssociationWithNotebook, key],
						key -> value,
						Nothing
					]
				],
				pubChemInformation
			]);

			(* Merge our option sets, favoring user defined options that are non-Null. *)
			Merge[
				{myOptionsWithName, filteredPubChemOptions},
				(If[Length[#] == 1,
					#[[1]],
					If[MatchQ[#[[1]], Alternatives[Null, Automatic]],
						#[[2]],
						#[[1]]
					]
				]&)]
		]
	];

	(* Make sure that if we have a Name and Synonyms field  that Name is apart of the Synonyms list. *)
	myOptionsWithSynonyms = If[MatchQ[Lookup[myOptionsWithPubChem, Synonyms], Alternatives[Null, Automatic]] || (!MemberQ[Lookup[myOptionsWithPubChem, Synonyms], Lookup[myOptionsWithPubChem, Name]] && MatchQ[Lookup[myOptionsWithPubChem, Name], _String]),
		Append[myOptionsWithPubChem, Synonyms -> (Append[Lookup[myOptionsWithPubChem, Synonyms] /. Alternatives[Null, Automatic] -> {}, Lookup[myOptionsWithPubChem, Name]])],
		myOptionsWithPubChem
	];

	(* Resolve any shared options that need custom resolution *)
	myOptionsWithSharedResolution = Module[
		{customResolvedSharedOptions},

		(* Resolve any options within the shared option sets that need custom handling *)
		customResolvedSharedOptions = resolveCustomSharedUploadOptions[myOptionsWithSynonyms];

		(* Merge the newly resolved options into the option set *)
		Join[myOptionsWithSynonyms, customResolvedSharedOptions]
	];

	(* Extract the composition *)
	safeComposition = If[MatchQ[Lookup[myOptionsAssociation, Composition], Alternatives[Null, Automatic]],
		{},
		Lookup[myOptionsAssociation, Composition]
	];

	(* Get the identity models from our composition. *)
	allIdentityModels = Cases[safeComposition[[All, 2]], IdentityModelP];

	(* If we have a composition, combine the EHS information from those identity models. *)
	resolvedSafetyOptions = If[Length[allIdentityModels] > 0,
		Module[{identityModelSafetyFields, identityModelSafetyFieldsPacket},
			(* Get all of the safety fields from our identity models. *)
			identityModelSafetyFields = ToExpression /@ Options[ExternalUpload`Private`IdentityModelHealthAndSafetyOptions][[All, 1]];
			identityModelSafetyFieldsPacket = Packet @@ Flatten[{identityModelSafetyFields, CellType}];

			(* Do our download, this download is also used later when resolving cell type. *)
			allIdentityModelPackets=Quiet[
				Download[allIdentityModels, identityModelSafetyFieldsPacket],
				{Download::FieldDoesntExist, Download::MissingField, Download::ObjectDoesNotExist, Download::Part, Download::MissingCacheField}
			];

			(* For a given safety field, combine the fields from the identity models: *)
			Map[
				Function[{ehsField},
					(* Don't overwrite the user's options. *)
					If[Or[
							MatchQ[Lookup[myOptionsAssociation, ehsField], Except[Null | Automatic]],

							(* MSDSRequired is a hidden option that is overidden with MSDSFile, so don't resolve if MSDSFile was specified *)
							MatchQ[ehsField, MSDSRequired] && !MatchQ[Lookup[myOptionsAssociation, MSDSFile], Null | Automatic]
						],
						Nothing,
						ehsField -> Fold[
							ExternalUpload`Private`combineEHSFields[ehsField, #1, #2][[2]]&, (* Note: ExternalUpload`Private`combineEHSFields returns a rule. *)
							(* if we are working with the cases when a given field is $Failed (for example DoubleGloveRequired for Cells) -> swap it to Null *)
							Lookup[allIdentityModelPackets, ehsField, {Null, Null}]/.{$Failed->Null}
						]
					]
				],
				identityModelSafetyFields
			]
		],
		(* ELSE: Can't resolve safety information. *)
		{}
	];

	(* Combine our safety options from IdentityModelHealthAndSafetyOptions. *)
	(* Note:ModelSampleHealthAndSafetyOptions also contains:Anhydrous, AsepticHandling, CellType, CultureAdhesion, *)
	(* DefaultStorageCondition, Expires, SampleHandling, ShelfLife, State, Sterile, TransportTemperature, UnsealedShelfLife *)
	(* Those options are not in resolvedSafetyOptions, but in myOptionsWithSharedResolution with default/user-specified values *)
	mysemiFinalizedOptions = Merge[{resolvedSafetyOptions, myOptionsWithSharedResolution}, First];

	(* Extract any Model[Cell] from the composition *)
	modelCellInComposition = Cases[safeComposition[[All, 2]], ObjectP[Model[Cell]]];
	cellPacketsInComposition = Cases[allIdentityModelPackets, ObjectP[modelCellInComposition]];

	(* Extract the living option from the rawOptions *)
	livingOptionProvidedBool = MatchQ[Lookup[rawOptions, Living, $Failed], BooleanP];

	(* Throw an error if the Living option was not provided and there are Model[Cell]'s in the Composition *)
	If[Length[modelCellInComposition] > 0 && !livingOptionProvidedBool,
		Message[Error::MissingLivingOption, modelCellInComposition]
	];

	(* Extract the living option from the rawOptions *)
	cellTypeProvidedBool = MatchQ[Lookup[rawOptions, CellType, $Failed], CellTypeP];

	resolvedCellType = Which[
		(* not a living situation *)
		MatchQ[Lookup[mysemiFinalizedOptions, Living], False|Null|Automatic],
			Null,
		(* living and we have a CellType specified *)
		cellTypeProvidedBool,
			Lookup[rawOptions, CellType],
		(* we don't have a provided CellType, resolve from the composition *)
		Length[modelCellInComposition] > 0,
			Which[
				(* we have only one cell in the composition *)
				Length[modelCellInComposition] == 1,
					Lookup[First@cellPacketsInComposition, CellType],
				(* we have only the same type of cells in the composition - steal it from the first one *)
				Length[DeleteDuplicates@Lookup[cellPacketsInComposition, CellType]] == 1,
					Lookup[First@cellPacketsInComposition, CellType],
				(* we have more than 1 different cell type, we are using these in order of Mammalian>Plant>Insect>Fungal>Yeast>Bacteria to get the highest ranking cell type *)
				Length[DeleteDuplicates@Lookup[cellPacketsInComposition, CellType]]>1,
					FirstCase[List@@CellTypeP, Alternatives@@DeleteDuplicates[Lookup[cellPacketsInComposition, CellType]]],
				(* we somehow were not able to resolve the CellType here, return Null *)
				True,
					Null
			],
		(* we somehow failed to resolve it, return Null *)
		True,
			Null
	];

	resolvedSterile = Which[
		(* Do we have Sterile specified *)
		MatchQ[Lookup[rawOptions, Sterile], BooleanP], MatchQ[Lookup[rawOptions, Sterile], BooleanP],
		(* Do we have living set as True? Set False for microbial cells *)
		TrueQ[Lookup[mysemiFinalizedOptions, Living]] && MemberQ[Lookup[cellPacketsInComposition, CellType], MicrobialCellTypeP],
			False,
		(* we somehow failed to resolve it, return Null *)
		True,
			Null
	];

	resolvedAsepticHandling = Which[
		(* Do we have AsepticHandling specified *)
		MatchQ[Lookup[rawOptions, AsepticHandling], BooleanP], MatchQ[Lookup[rawOptions, AsepticHandling], BooleanP],
		(* Do we have living set as True? Set True for all cell samples *)
		TrueQ[Lookup[mysemiFinalizedOptions, Living]], True,
		(* Do we have Sterile set as True? Set True to keep sterile state *)
		TrueQ[resolvedSterile], True,
		(* we somehow failed to resolve it, return Null *)
		True, Null
	];

	(* Upload Sterile/CellType/AsepticHandling options. *)
	myManuallyResolvedOptions = ReplaceRule[
		Normal[mysemiFinalizedOptions],
		{
			CellType -> resolvedCellType,
			Sterile -> resolvedSterile,
			AsepticHandling -> resolvedAsepticHandling
		}
	];


	(* Default simple options *)
	myFinalizedOptions = Module[
		{simpleOptionDefaults, modifications, simpleDefaultedOptions},

		(* List of values to default Automatic to *)
		simpleOptionDefaults = <|
			UsedAsMedia -> False,
			Living -> False,
			UsedAsSolvent -> False,
			Tablet -> False,
			Sachet -> False,
			Fiber -> False
		|>;

		(* For each of the automatic options in the association pull out the default values (if there is one) *)
		modifications = KeyTake[
			simpleOptionDefaults,
			Keys[Select[myOptionsAssociation, MatchQ[#, Automatic] &]]
		];

		(* Merge in the changes *)
		simpleDefaultedOptions = Merge[
			{myManuallyResolvedOptions, modifications},
			Last
		];

		(* Sweep up any final Automatics *)
		Replace[
			simpleDefaultedOptions,
			Automatic -> Null,
			{1}
		]
	];

	(* Return our options. *)
	Normal[myFinalizedOptions]
];

(* New object overload from composition *)
resolvedUploadSampleOptions[myType_, myComposition : ModelCompositionP, myOptions_, rawOptions_] := Module[
	{
		myOptionsWithComposition
	},

	(* If the user specified the composition option, we should use that - it means they overrode the original inputs *)
	(* Otherwise use the input value *)
	(* To specify an empty composition, the user needs to specify {{Null, Null}} so we can override Null/{} *)
	myOptionsWithComposition = If[MatchQ[Lookup[myOptions, Composition, Automatic], Alternatives[Null, Automatic, {}]],
		ReplaceRule[
			myOptions,
			Composition -> myComposition
		],
		myOptions
	];

	(* Call the core create-object resolver *)
	resolvedUploadSampleOptions[myType, Null, myOptionsWithComposition, rawOptions]
];


(* This existing object overload is the same as the default resolver. *)
resolvedUploadSampleOptions[myType_, myInput:ObjectP[], myOptions_, rawOptions_]:=resolveDefaultUploadFunctionOptions[myType, myInput, myOptions, rawOptions];


(* ::Subsubsection::Closed:: *)
(* Auxilliary packets function *)
uploadSampleModelAuxilliaryPackets[myType_, myInputs_List, myOptionsList_List, myResolvedMapThreadOptionsList_List] := Module[
	{
		modelSampleInputQs, auxilliaryPackets,
		activeSamplesPackets, timeOfUpdate
	},

	(* Check if we're modifying an existing Model[Sample] *)
	modelSampleInputQs = MatchQ[#, ObjectP[Model[Sample]]] & /@ myInputs;

	(* Search for any active samples of the models that are being modified and download packets for them *)
	activeSamplesPackets = Module[
		{modelSampleInputs, activeSamplesSearchResult},

		(* Pick out the inputs that are Model[Sample]s *)
		modelSampleInputs = PickList[myInputs, modelSampleInputQs];

		(* Search for the active samples for each input *)
		activeSamplesSearchResult = With[
			{
				types = ConstantArray[Object[Sample], Length[modelSampleInputs]],
				clauses = (Status != Discarded && Model == #) & /@ modelSampleInputs
			},
			Search[types, clauses]
		];

		(* Download whole packets for all the samples *)
		activeSamplesPackets = Download[activeSamplesSearchResult];

		(* Index match the results back with the original inputs, filling with Null *)
		ReplacePart[
			ConstantArray[Null, Length[myInputs]],
			AssociationThread[Position[modelSampleInputQs, True], activeSamplesPackets]
		]
	];

	(* Save the current time to attribute the changes to *)
	timeOfUpdate = Now;

	(* Generate the auxilliary packets for each input *)
	auxilliaryPackets = MapThread[
		Function[{input, resolvedOptionSet, activeSamplePackets},
			Module[
				{},

				(* If our input isn't a Model[Sample] i.e. we're not modifying an existing model, there's nothing to do *)
				If[!MatchQ[input, ObjectP[Model[Sample]]],
					Return[{}, Module]
				];

				(* Otherwise generate packets to copy the changes over to the associated Object[Sample]s *)
				Map[
					Function[samplePacket,
						Module[
							{modifiedOptions, filteredOptions, changePackets},

							(* Make any modifications to the option values *)
							modifiedOptions = Map[
								Function[{optionRule},
									Module[{optionSymbol,optionValue},

										(* Split the option into symbol and value *)
										optionSymbol = First[optionRule];
										optionValue = Last[optionRule];

										(* Append the time to the end of the composition *)
										If[MatchQ[optionSymbol, Composition] && !MatchQ[optionValue, Null | {Null}],
											optionSymbol -> Map[
												Function[{myEntry},
													{myEntry[[1]], Link[myEntry[[2]]], timeOfUpdate}
												],
												optionValue
											],

											(* Otherwise just pass through the option *)
											optionSymbol -> If[MatchQ[optionValue, {Null}], Null, optionValue]
										]
									]
								],
								resolvedOptionSet
							];

							(* Remove any options that shouldn't be used to update fields *)
							filteredOptions = Cases[modifiedOptions, HoldPattern[Except[Name] -> _]];

							(* Return the change packets *)
							changePackets = generateChangePackets[Object[Sample], filteredOptions, ExistingPacket -> samplePacket];

							(* Add in the object key for the existing object *)
							Flatten[{
								Append[
									First[changePackets],
									Object -> Lookup[samplePacket, Object]
								],
								Rest[changePackets]
							}]
						]
					],
					activeSamplePackets
				]
			]
		],
		{myInputs, myResolvedMapThreadOptionsList, activeSamplesPackets}
	];

	(* Return the index matched lists of packets *)
	auxilliaryPackets
];
