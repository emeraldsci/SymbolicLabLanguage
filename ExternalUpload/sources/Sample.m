(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadSampleModel*)


(* ::Subsubsection:: *)
(*Options and Messages*)

(* Share molecule input pattern widgets *)
(* Input widgets - must be := to generate a unique identifier each time it's inserted *)
moleculeNameWidget[] := Widget[Type -> String, Pattern :> _String, Size -> Line, PatternTooltip -> "The common or internal name of this chemical."];
pubChemWidget[] := Widget[
	Type -> Expression,
	Pattern :> Alternatives[GreaterEqualP[1, 1], _PubChem],
	Size -> Line,
	PatternTooltip -> "Enter the PubChem ID of the chemical to upload, as an integer or wrapped in a PubChem[...] head. (e.g. PubChem[679] is the ID of DMSO)."
];
inchiWidget[] := Widget[
	Type -> String,
	Pattern :> InChIP,
	Size -> Paragraph,
	PatternTooltip -> "The InChI of a molecule is a string that begins with InChI=."
];
inchiKeyWidget[] := Widget[
	Type -> String,
	Pattern :> InChIKeyP,
	Size -> Line,
	PatternTooltip -> "The InChIKey of this molecule, which is in the format of **************-**********-N where * is any uppercase letter."
];
casWidget[] := Widget[
	Type -> String,
	Pattern :> CASNumberP,
	Size -> Line,
	PatternTooltip -> "The CAS registry number of a molecule is a unique identifier specified by the American Chemical Society (ACS). CAS Numbers consist of 3 groups of digits, the first containing 2-7 digits, the second containing 2 digits and the final containing 1 digit, separated by hyphens. CAS numbers therefore range from **-**-* to *******-**-* where * is a digit character."
];
thermoWidget[] := Widget[
	Type -> String,
	Pattern :> ThermoFisherURLP,
	Size -> Paragraph,
	PatternTooltip -> "The URL of the ThermoFisher product page for a product of the required sample type."
];
sigmaWidget[] := Widget[
	Type -> String,
	Pattern :> MilliporeSigmaURLP,
	Size -> Paragraph,
	PatternTooltip -> "The URL of the Millipore Sigma product page for a product of the required sample type."
];

(* Shared amount widget for full composition widgets *)
uploadSampleModelCompositionAmountWidget[] := Alternatives[
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
];

(* Share the composition widget *)
uploadSampleModelCompositionWidget[] := Adder[{
	"Amount" -> uploadSampleModelCompositionAmountWidget[],
	"Identity Model" -> Alternatives[
		Widget[Type -> Object, Pattern :> ObjectP[List @@ IdentityModelTypeP]],
		Widget[Type -> Enumeration, Pattern :> Alternatives[Null]],
		(* Allow upload molecule inputs in-situ *)
		moleculeNameWidget[],
		pubChemWidget[],
		inchiWidget[],
		inchiKeyWidget[],
		casWidget[],
		thermoWidget[],
		sigmaWidget[]
	]
}];

(* Define expanded composition pattern that allows UploadMolecule inputs *)
UploadSampleModelFullCompositionP = {{Alternatives[CompositionP, Null], Alternatives[IdentityModelP, _String, _PubChem, GreaterEqualP[1, 1], Null]}..};

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
				Description -> "The various components that constitute this sample model, along with their respective concentrations. Specifying 'Null' for amount indicates a component of unknown concentration, and specifying 'Null' for the component indicates an unknown or proprietary component. If a composition is supplied as both an input and an option, the option takes precedence.",
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
	OptionResolver -> resolveUploadSampleModelOptions,
	PacketCreationFunction -> generateUploadSampleModelPackets,
	AuxiliaryPacketsFunction -> uploadSampleModelAuxiliaryPackets,
	InputPattern -> Alternatives[
		(* Create a new model with a name *)
		_String,

		(* Modify an existing model *)
		Model[Sample],

		(* Create a new model with composition *)
		UploadSampleModelFullCompositionP,

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
installDefaultVerificationFunction[UploadSampleModel, Model[Sample]];


(* ::Subsubsection::Closed:: *)
(*Option Resolver*)

Error::MissingLivingOption = "For inputs, `1`, the Model[Cell](s), `2` were found in the provided Composition. Please use the Living option to specify whether the cells are alive or dead.";
Error::ModelNotFound = "For inputs, `1`, model objects couldn't be found or automatically created for identifiers, `2`, in the supplied composition. Please specify any existing models (such as Model[Molecule]s) directly using their object ID. If trying to create a new model, additional information is required and can't be supplied in this function. Please create the model directly using the appropriate upload function and supply the required information, then use UploadSampleModel afterwards.";

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadSampleModelOptions[myType : Model[Sample], myInputs_List, myMapThreadSafeOptions : {{___}..}, myMapThreadSpecifiedOptions : {{___}..}] := Module[
	{
		safeOptionsAssociations, specifiedOptionsAssociations, refactoredSafeOptions, refactoredSpecifiedOptions, identityModelInvalidInputs,
		identityModelAssociations, optionsWithCompositionIdentityModelData, optionsWithManuallyResolved, finalizedOptions, optionsWithSharedResolution, optionsWithParsedCompositions,
		safeOptionsExistingObjectDefaulted, existingObjectInvalidInputs, existingObjectInvalidOptions, allIdentityModels,
		allIdentityModelPackets, identityModelSafetyFields, optionsWithSafety, optionsWithBio, bioInvalidOptions, uploadingQ,
		resolvedInternalCompositions
	},

	(* Convert the options to lists of associations *)
	safeOptionsAssociations = Association @@@ myMapThreadSafeOptions;
	specifiedOptionsAssociations = Association @@@ myMapThreadSpecifiedOptions;

	(* Check if we're uploading objects or not *)
	uploadingQ = And[
		(* Must have Upload -> True *)
		MemberQ[Flatten[Lookup[safeOptionsAssociations, Upload]], True],

		(* And also be outputting the result *)
		MemberQ[Flatten[Lookup[safeOptionsAssociations, Output]], Result]
	];

	(* Rearrange the inputs and options into a consistent format *)
	(* For example, Composition can be specified as the input, so shift that to the options *)
	{refactoredSafeOptions, refactoredSpecifiedOptions} = Transpose @ MapThread[
		Function[{input, safeOps, specOps},
			Module[{refactoredComposition, refactoredName, optionModifications},

				(* If a molecular identifier was provided as input, fill out the composition *)
				refactoredComposition = Which[
					(* If composition input, and the composition option wasn't specified, populate the option with the input *)
					MatchQ[input, UploadSampleModelFullCompositionP] && MatchQ[Lookup[safeOps, Composition, Automatic], Alternatives[Null, Automatic, {}]],
					input,

					(* Otherwise if a single input was provided, populate that in the composition if Automatic *)
					!MatchQ[input, {{_, _}..}] && !MatchQ[input, ObjectP[]] && MatchQ[Lookup[safeOps, Composition, Automatic], Alternatives[Null, Automatic, {}]],
					{{100 MassPercent, input}},

					(* Otherwise nothing to do *)
					True,
					Null
				];

				(* Handle any provided names *)
				refactoredName = Which[
					(* If name option was provided, use it *)
					StringQ[Lookup[safeOps, Name]],
					Null,

					(* If a string input was provided as input and it's not an identifier, use it as name *)
					StringQ[input] && !MatchQ[input, Alternatives[URLP, CASNumberP, InChIP, InChIKeyP]],
					input,

					(* Otherwise leave it *)
					True,
					Null
				];

				(* Assemble the options modifications *)
				optionModifications = <|
					If[!MatchQ[refactoredComposition, Null],
						Composition -> refactoredComposition,
						Nothing
					],
					If[!MatchQ[refactoredName, Null],
						Name -> refactoredName,
						Nothing
					]
				|>;

				(* Return the updated options *)
				{
					Join[safeOps, optionModifications],
					specOps
				}
			]
		],
		{myInputs, safeOptionsAssociations, specifiedOptionsAssociations}
	];

	(* Resolve the options for the inputs we're modifying *)
	{safeOptionsExistingObjectDefaulted, existingObjectInvalidInputs, existingObjectInvalidOptions} = Module[
		{
			modifyObjectPositions, modifyInputs, modifySafeOptions, modifySpecifiedOptions,
			modifyResolverOutput, modifyInvalidInputs, modifyInvalidOptions, updatedOptions
		},

		(* Check which positions have objects to modify in them *)
		modifyObjectPositions = Position[myInputs, ObjectP[], 1];

		(* Pull out the objects to modify and their options *)
		modifyInputs = Extract[myInputs, modifyObjectPositions];
		modifySafeOptions = Extract[refactoredSafeOptions, modifyObjectPositions];
		modifySpecifiedOptions = Extract[refactoredSpecifiedOptions, modifyObjectPositions];

		(* Use the standard option resolver on them *)
		(* This just takes the existing values for the field and over-writes any that are specified by an option  *)
		modifyResolverOutput = resolveDefaultUploadFunctionOptions[
			Model[Sample],
			modifyInputs,
			(* Function takes options in list of rules form *)
			Replace[modifySafeOptions, Association -> List, {2}, Heads -> True],
			Replace[modifySpecifiedOptions, Association -> List, {2}, Heads -> True]
		];

		(* Lookup the invalid inputs and options *)
		{modifyInvalidInputs, modifyInvalidOptions} = Lookup[modifyResolverOutput, {InvalidInputs, InvalidOptions}];

		(* Re-insert the modified options back into their index-matched position *)
		updatedOptions = ReplacePart[
			refactoredSafeOptions,
			AssociationThread[modifyObjectPositions, Association /@ Lookup[modifyResolverOutput, Result]]
		];

		(* Return the results *)
		{updatedOptions, modifyInvalidInputs, modifyInvalidOptions}
	];

	(* Resolve any molecular identifiers to Models in the composition *)
	(* Uses UploadMolecule and related upload functions *)
	{identityModelAssociations, optionsWithParsedCompositions, identityModelInvalidInputs} = Module[
		{
			indexMatchedConstituents, modifiedCompositionIdentifiers, uploadIdentityModelObjects, uploadIdentityModelOptions,
			uploadIdentityModelOptionRules, uploadIdentityModelObjectRules, updatedCompositions, updatedOptions, identityModelOptionsByInput,
			invalidInputs, invalidIndexMatchedIdentifiers, identityModelRequiresUploadQs, rawUploadIdentityModelObjectRules
		},

		(* Pull out the non-null constituents in the composition for each input *)
		indexMatchedConstituents = Map[
			DeleteCases[#[[All, 2]], Null] &,
			Lookup[safeOptionsExistingObjectDefaulted, Composition, {}]
		];

		(* Modify any identifiers to make suitable for upload function call *)
		modifiedCompositionIdentifiers = Replace[Flatten[indexMatchedConstituents], x_Integer :> PubChem[x], {1}];

		(* Try and find/create molecules etc for each identifier *)
		(* Functions will automatically return the duplicate if it already exists *)
		(* Memoized helper to ensure repeated options resolution is fast *)
		{uploadIdentityModelObjects, uploadIdentityModelOptions, identityModelRequiresUploadQs} = If[!MatchQ[modifiedCompositionIdentifiers, {}],
			Module[{rawObjects, rawOptions, rawPackets, optionsAssociations, requiresUploadQs},

				(* Get/compute the upload function results *)
				(* We're mapping here for a few reasons *)
				(* i) Make sure one bad input doesn't break the others ii) resolvers return a single listed option set, not a list of option sets iii) potentially using different upload functions anyway *)
				(* Speed is actually essentially identical *)
				{rawObjects, rawOptions, rawPackets} = Transpose @ Map[
					duffUploadIdentityModel[#, {Object, Options, Packets}] &,
					modifiedCompositionIdentifiers
				];

				(* Determine booleans for if the molecules exist in the database yet *)
				(* If we're not uploading, check for the presence of upload packets as the smoking gun *)
				requiresUploadQs = MapThread[And[MatchQ[#1, ObjectP[]], !MatchQ[#2, {}]] &, {rawObjects, rawPackets}];

				(* Convert the lists of options into associations. Ensure we don't try to convert invalid things such as $Failed *)
				optionsAssociations = If[MatchQ[#, {_Rule...}],
					Association[#],
					#
				] & /@ rawOptions;

				(* Return the objects and options *)
				{rawObjects, optionsAssociations, requiresUploadQs}
			],
			{{}, {}, {}}
		];

		(* Assemble rules from the original component to the options resolved (identity model field values) *)
		uploadIdentityModelOptionRules = AssociationThread[Flatten[indexMatchedConstituents], uploadIdentityModelOptions];

		(* Assemble rules from the original component to the identity model object resolved *)
		(* All models are included whether they exist yet or not *)
		rawUploadIdentityModelObjectRules = AssociationThread[Flatten[indexMatchedConstituents], uploadIdentityModelObjects];

		(* Assemble rules from identifier to object reference *)
		uploadIdentityModelObjectRules = Module[{notUploadedYet},

			(* Figure out which identity models aren't uploaded yet *)
			notUploadedYet = PickList[uploadIdentityModelObjects, identityModelRequiresUploadQs];

			(* Filter out any molecules that still need uploading so they aren't replaced in the resolved option - instead the (validated) identifier will still show up *)
			(* This avoids problems where the options are re-resolved. If not-yet-existing molecules are specified in the option, we'll throw an error saying they don't exist yet *)
			Select[rawUploadIdentityModelObjectRules, MatchQ[#, Except[ObjectP[notUploadedYet], ObjectP[]]] &]
		];

		(* Throw an error if any constituents couldn't be resolved for any inputs *)
		(* Check if any inputs are missing resolved identity models *)
		invalidIndexMatchedIdentifiers = Map[
			Function[{constituents},
				Select[constituents, !MatchQ[Lookup[rawUploadIdentityModelObjectRules, #], ObjectP[]] &]
			],
			indexMatchedConstituents
		];

		invalidInputs = PickList[myInputs, invalidIndexMatchedIdentifiers, Except[{}]];

		If[!MatchQ[invalidInputs, {}],
			Message[Error::ModelNotFound, invalidInputs, invalidIndexMatchedIdentifiers]
		];

		(* Update the compositions with the objects returned by the upload functions *)
		updatedCompositions = Replace[Lookup[safeOptionsExistingObjectDefaulted, Composition, {}], uploadIdentityModelObjectRules, {3}];

		(* Update the options *)
		updatedOptions = MapThread[
			Function[{safeOps, specOps, newComposition},
				Which[
					(* If the composition option was specified, don't change it *)
					(* If molecule supplied, great. Will throw error if not real *)
					(* If identifier supplied, will stay as identifier and error thrown if there's a problem *)
					MemberQ[Keys[specOps], Composition],
					Append[safeOps, Composition -> Lookup[specOps, Composition]],

					(* If the composition is resolved correctly from the input, use it *)
					(* This may still contain valid/invalid molecular identifiers *)
					(* If an identifier is invalid, a message was thrown. If it's valid, we cached the result behind the scenes *)
					MatchQ[newComposition, UploadSampleModelFullCompositionP],
					Append[safeOps, Composition -> newComposition],

					(* Otherwise Composition resolution failed *)
					True,
					Append[safeOps, Composition -> $Failed]
				]
			],
			{safeOptionsExistingObjectDefaulted, refactoredSpecifiedOptions, updatedCompositions}
		];

		(* Associate the object data with each input *)
		identityModelOptionsByInput = Map[
			Module[
				{modelData},

				(* Lookup the options values for the identity models *)
				modelData = Lookup[uploadIdentityModelOptionRules, #, $Failed];

				(* If the composition wasn't a single item that we got data for, return an empty association *)
				(* Right now, only support propagating properties if we only have one component. So only take forward that one association *)
				If[MatchQ[modelData, {_?AssociationQ}],
					First[modelData],
					<||>
				]
			] &,
			indexMatchedConstituents
		];

		(* Return the updated options and the object data for each input *)
		{
			identityModelOptionsByInput,
			updatedOptions,
			invalidInputs
		}
	];

	(* Merge the data from the composition into the specified options *)
	(* User specified values take precedence *)
	optionsWithCompositionIdentityModelData = MapThread[
		Function[{userOptions, identityModelData},
			If[!AssociationQ[identityModelData],
				(* If no composition data, pass through the options unmodified *)
				userOptions,

				(* Otherwise merge in the identity model data *)
				Module[{filteredIdentityModelOptions},

					(* Filter out any keys that aren't options to UploadSampleModel *)
					(* And filter out fields that are otherwise problematic *)
					filteredIdentityModelOptions = KeyDrop[
						KeyTake[identityModelData, Keys[userOptions]],
						{
							(* Taking name and synonym from the components leads to almost inevitable name clashes *)
							Name, Synonyms
						}
					];

					(* Take User option -> Identity Model data -> leave Automatic *)
					Merge[
						{userOptions, filteredIdentityModelOptions},
						FirstCase[#, Except[Alternatives[Automatic, Null]], Automatic] &
					]
				]
			]
		],
		{optionsWithParsedCompositions, identityModelAssociations}
	];

	(* Resolve any shared options that need custom resolution *)
	optionsWithSharedResolution = Module[
		{customResolvedSharedOptions},

		(* Resolve any options within the shared option sets that need custom handling *)
		customResolvedSharedOptions = resolveCustomSharedUploadOptions[optionsWithCompositionIdentityModelData];

		(* Merge the newly resolved options into the option set *)
		MapThread[
			Join,
			{optionsWithCompositionIdentityModelData, customResolvedSharedOptions}
		]
	];

	(* Prepare some shared variables *)
	(* Pull out the composition *)
	resolvedInternalCompositions = Module[
		{rawCompositions},

		(* Get the compositions as-is *)
		rawCompositions = Lookup[optionsWithSharedResolution, Composition, $Failed];

		(* If it's a valid composition, use the valid entries. Otherwise return an empty list *)
		Map[
			If[ListQ[#],
				Cases[#, {_, _}],
				{}
			] &,
			rawCompositions
		]
	];

	(* Pull all identity models out of the composition *)
	allIdentityModels = Cases[#[[All, 2]], IdentityModelP] & /@ resolvedInternalCompositions;

	(* All the safety fields for sample models *)
	identityModelSafetyFields = ToExpression /@ Options[ExternalUpload`Private`IdentityModelHealthAndSafetyOptions][[All, 1]];

	(* Download the packets for the important fields *)
	allIdentityModelPackets = Module[
		{identityModelSafetyFieldsPacket},

		(* Get all of the safety fields from our identity models. *)
		identityModelSafetyFieldsPacket = Packet @@ Flatten[{identityModelSafetyFields, CellType}];

		Quiet[
			Download[allIdentityModels, identityModelSafetyFieldsPacket],
			{Download::FieldDoesntExist, Download::MissingField, Download::ObjectDoesNotExist, Download::Part, Download::MissingCacheField}
		]
	];

	(* If we have a composition, combine the EHS information from those identity models. *)
	optionsWithSafety = Module[
		{resolvedSafetyOptions},

		(* Resolve the safety related options *)
		resolvedSafetyOptions = MapThread[
			Function[{options, packets},
				Map[
					Function[{ehsField},
						(* Don't overwrite the user's options. *)
						If[Or[
							MatchQ[Lookup[options, ehsField], Except[Null | Automatic]],

							(* MSDSRequired is a hidden option that is overidden with MSDSFile, so don't resolve if MSDSFile was specified *)
							MatchQ[ehsField, MSDSRequired] && !MatchQ[Lookup[options, MSDSFile], Null | Automatic]
						],
							Nothing,
							ehsField -> Fold[
								ExternalUpload`Private`combineEHSFields[ehsField, #1, #2][[2]]&, (* Note: ExternalUpload`Private`combineEHSFields returns a rule. *)
								(* if we are working with the cases when a given field is $Failed (for example DoubleGloveRequired for Cells) -> swap it to Null *)
								Lookup[packets, ehsField, {Null, Null}] /. {$Failed -> Null}
							]
						]
					],
					identityModelSafetyFields
				]
			],
			{optionsWithSharedResolution, allIdentityModelPackets}
		];

		(* Merge in the new options *)
		MapThread[
			Merge[
				{#1, #2},
				FirstCase[#, Except[Alternatives[Automatic, Null]], Automatic] &
			] &,
			{optionsWithSharedResolution, resolvedSafetyOptions}
		]
	];

	(* Resolve bio related options *)
	{optionsWithBio, bioInvalidOptions} = Module[
		{
			resolvedBioOptions, modelCellsInComposition, cellPacketsInComposition, livingOptionProvidedBools,
			resolvedCellTypes, resolvedSteriles, resolvedAsepticHandlings, livingOptionConflictsBools,
			cellTypeProvidedBools, invalidOptions
		},

		(* Extract any Model[Cell] from the composition *)
		modelCellsInComposition = Cases[#[[All, 2]], ObjectP[Model[Cell]]] & /@ resolvedInternalCompositions;
		cellPacketsInComposition = Cases[Flatten[allIdentityModelPackets], ObjectP[#]] & /@ modelCellsInComposition;

		(* Extract the living option from the rawOptions *)
		livingOptionProvidedBools = MatchQ[Lookup[#, Living, $Failed], BooleanP] & /@ refactoredSpecifiedOptions;

		(* Check if any inputs contain cells but Living is not specified *)
		livingOptionConflictsBools = MapThread[
			And[GreaterQ[Length[#1], 0], !#2] &,
			{modelCellsInComposition, livingOptionProvidedBools}
		];

		(* Throw the error if required *)
		invalidOptions = If[MemberQ[livingOptionConflictsBools, True],
			Message[Error::MissingLivingOption, PickList[myInputs, livingOptionConflictsBools], PickList[modelCellsInComposition, livingOptionConflictsBools]];
			{Living},
			{}
		];

		(* Extract the living option from the rawOptions *)
		cellTypeProvidedBools = MatchQ[Lookup[#, CellType, $Failed], CellTypeP] & /@ refactoredSpecifiedOptions;

		(* Resolve the cell types *)
		resolvedCellTypes = MapThread[
			Function[{partiallyResolvedOps, specifiedOps, cellPackets, cellInComposition, cellTypeProvided},
				Which[
					(* not a living situation *)
					MatchQ[Lookup[partiallyResolvedOps, Living], False | Null | Automatic],
					Null,
					(* living and we have a CellType specified *)
					cellTypeProvided,
					Lookup[specifiedOps, CellType],
					(* we don't have a provided CellType, resolve from the composition *)
					Length[cellInComposition] > 0,
					Which[
						(* we have only one cell in the composition *)
						Length[cellInComposition] == 1,
						Lookup[First@cellPackets, CellType],
						(* we have only the same type of cells in the composition - steal it from the first one *)
						Length[DeleteDuplicates@Lookup[cellPackets, CellType]] == 1,
						Lookup[First@cellPackets, CellType],
						(* we have more than 1 different cell type, we are using these in order of Mammalian>Plant>Insect>Fungal>Yeast>Bacteria to get the highest ranking cell type *)
						Length[DeleteDuplicates@Lookup[cellPackets, CellType]] > 1,
						FirstCase[List @@ CellTypeP, Alternatives @@ DeleteDuplicates[Lookup[cellPackets, CellType]]],
						(* we somehow were not able to resolve the CellType here, return Null *)
						True,
						Null
					],
					(* we somehow failed to resolve it, return Null *)
					True,
					Null
				]
			],
			{optionsWithSafety, refactoredSpecifiedOptions, cellPacketsInComposition, modelCellsInComposition, cellTypeProvidedBools}
		];

		(* Resolve sterile boolean *)
		resolvedSteriles = MapThread[
			Function[{partiallyResolvedOps, specifiedOps, cellPackets},
				Which[
					(* Do we have Sterile specified *)
					MatchQ[Lookup[specifiedOps, Sterile], BooleanP], MatchQ[Lookup[specifiedOps, Sterile], BooleanP],
					(* Do we have living set as True? Set False for microbial cells *)
					TrueQ[Lookup[partiallyResolvedOps, Living]] && MemberQ[Lookup[cellPackets, CellType], MicrobialCellTypeP],
					False,
					(* we somehow failed to resolve it, return Null *)
					True,
					Null
				]
			],
			{optionsWithSafety, refactoredSpecifiedOptions, cellPacketsInComposition}
		];

		(* Resolve if special sterile handling practices are required *)
		resolvedAsepticHandlings = MapThread[
			Function[{partiallyResolvedOps, specifiedOps, resolvedSterile},
				Which[
					(* Do we have AsepticHandling specified *)
					MatchQ[Lookup[specifiedOps, AsepticHandling], BooleanP], MatchQ[Lookup[specifiedOps, AsepticHandling], BooleanP],
					(* Do we have living set as True? Set True for all cell samples *)
					TrueQ[Lookup[partiallyResolvedOps, Living]], True,
					(* Do we have Sterile set as True? Set True to keep sterile state *)
					TrueQ[resolvedSterile], True,
					(* we somehow failed to resolve it, return Null *)
					True, Null
				]
			],
			{optionsWithSafety, refactoredSpecifiedOptions, resolvedSteriles}
		];

		(* Assemble all of the bio options *)
		resolvedBioOptions = MapThread[
			<|
				CellType -> #1,
				Sterile -> #2,
				AsepticHandling -> #3
			|> &,
			{resolvedCellTypes, resolvedSteriles, resolvedAsepticHandlings}
		];

		(* Merge in the new options and return with any invalid options *)
		{
			MapThread[
				Merge[
					{#1, #2},
					FirstCase[#, Except[Alternatives[Automatic, Null]], Automatic] &
				] &,
				{optionsWithSafety, resolvedBioOptions}
			],

			invalidOptions
		}
	];

	(* Manually resolve individual options *)
	optionsWithManuallyResolved = Module[
		{
			resolvedNotebooks, resolvedSynonyms, resolvedNames, manuallyResolvedOptions
		},

		(* Resolve the notebooks *)
		resolvedNotebooks = If[MatchQ[#, Automatic],
			$Notebook,
			#
		] & /@ Lookup[optionsWithBio, Notebook];

		(* Resolve the synonyms - make sure the name is a member *)
		{resolvedSynonyms, resolvedNames} = Transpose @ MapThread[
			Function[{synonyms, name},
				Switch[{synonyms, name},
					{Alternatives[Automatic, Null, {}], Alternatives[Automatic, Null]},
					{{}, Null},

					(* Set the synonyms to the name if provided *)
					{Automatic, _},
					{{name}, name},

					(* Set the name to the first synonym if provided *)
					{_, Automatic},
					{synonyms, First[synonyms]},

					(* Otherwise, if the name is not in the synonyms add it *)
					{_, _},
					{
						If[!MemberQ[synonyms, name], Prepend[synonyms, name], synonyms],
						name
					}
				]
			],
			{Lookup[optionsWithBio, Synonyms], Lookup[optionsWithBio, Name]}
		];

		(* Assemble the manually resolved options *)
		manuallyResolvedOptions = MapThread[
			<|
				Notebook -> #1,
				Name -> #2,
				Synonyms -> #3
			|> &,
			{resolvedNotebooks, resolvedNames, resolvedSynonyms}
		];

		(* Merge in the newly resolved options *)
		MapThread[
			Merge[
				{#1, #2},
				Last
			] &,
			{optionsWithBio, manuallyResolvedOptions}
		]
	];

	(* Perform final defaulting *)
	finalizedOptions = Module[
		{simpleOptionDefaults, simpleDefaultModifications},

		(* Now perform final simple defaults if still not resolved *)
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
		simpleDefaultModifications = Map[
			(* Map over each input *)
			Function[options,
				(* Map over the options for that input *)
				KeyValueMap[
					Function[{option, value},
						(* If option remains Automatic, use the default value hard-coded, otherwise resolve to Null if missing *)
						If[MatchQ[value, Automatic],
							option -> Lookup[simpleOptionDefaults, option, Null],
							option -> value
						]
					],
					options
				]
			],
			optionsWithManuallyResolved
		]
	];

	(* Return the results *)
	<|
		(* Options need to be in list of rules format, not association *)
		Result -> (Normal[#, Association] & /@ finalizedOptions),
		InvalidInputs -> identityModelInvalidInputs,
		InvalidOptions -> bioInvalidOptions,
		Tests -> {}
	|>
];

(* Inner helper for duffUploadIdentityModel for calling UploadMolecule, UploadOligomer, ... *)
duffUploadIdentityModelCall[input_] := Module[
	{
		uploadFunction, uploadFunctionReturn,
		result, resolvedIdentityModelObject, resolvedUploadPackets,
		resolvedOptions
	},

	(* Get the correct upload function *)
	uploadFunction = If[MatchQ[input, ObjectP[]],
		Lookup[$ObjectBuilders, input[Type], UploadMolecule],
		UploadMolecule
	];

	(* Run the function - use With to allow us to Stub the function name for unit testing *)
	uploadFunctionReturn =  With[{function = uploadFunction},
		Quiet[function[input, Output -> {Result, Options}, Upload -> False]]
	];

	(* Parse the results *)
	(* Return the object reference and any packets required to create it *)
	(* The list of packets (Result) should be the first item of two returned by the function, but handle any output *)
	{resolvedIdentityModelObject, resolvedUploadPackets} = Module[{safePackets},

		(* Safely extract packets from the return value *)
		safePackets = If[TrueQ[ValidUploadQ[First[uploadFunctionReturn, $Failed]]],
			First[ToList[uploadFunctionReturn]],
			$Failed
		];

		(* Return the existingObject *)
		(* If we found/created a match, it's the object in the first upload packet *)
		Which[
			!FailureQ[safePackets],
			Module[{primaryObjectPacket, objectID, updatedPackets},

				(* Pull the primary object packet out of the upload packets *)
				primaryObjectPacket = First[safePackets];

				(* Pull out the object ID if there is one, otherwise create one *)
				{objectID, updatedPackets} = If[
					MatchQ[Lookup[primaryObjectPacket, Object, $Failed], ObjectP[]],
					(* If ID exists, use it. If an existing molecule was found, no upload required otherwise no packet modification required *)
					{Lookup[primaryObjectPacket, Object], If[DatabaseMemberQ[Lookup[primaryObjectPacket, Object]], {}, safePackets]},

					(* Otherwise create the ID and use it *)
					With[{newID = CreateID[Lookup[primaryObjectPacket, Type]]},
						{newID, ReplacePart[safePackets, 1 -> Append[primaryObjectPacket, Object -> newID]]}
					]
				];

				{objectID, updatedPackets}
			],

			(* If we have an existing object but for some reason the upload function returns an invalid response (typically object is invalid), retain the object ID and don't require upload packets *)
			MatchQ[input, ObjectP[]] && DatabaseMemberQ[input],
			{input, {}},

			(* Otherwise we didn't find an existing object and can't create it *)
			True,
			{$Failed, $Failed}
		]
	];

	(* Parse the options *)
	(* The options (Options) should be the second item of two returned by the function, but handle any output *)
	resolvedOptions = If[MatchQ[Last[uploadFunctionReturn, $Failed], {_Rule..}],
		Last[uploadFunctionReturn],
		$Failed
	];

	(* Parse the results into an association of things we might want in the main function *)
	(* If one thing fails, fail the whole thing *)
	result = If[!MemberQ[{resolvedIdentityModelObject, resolvedUploadPackets, resolvedOptions}, $Failed],
		<|
			Object -> resolvedIdentityModelObject,
			Packets -> resolvedUploadPackets,
			Options -> resolvedOptions
		|>,
		<|
			Object -> $Failed,
			Packets -> $Failed,
			Options -> $Failed
		|>
	];

	(* Return the result *)
	result
];

(* Helper for returning the UploadMolecule, UploadOligomer, ... data and caching the result *)
duffUploadIdentityModel[input_, output : ListableP[Alternatives[Object, Options, Packets]]] := Module[
	{uploadMoleculeData},

	(* Generate or retrieve the data *)
	uploadMoleculeData = If[!MemberQ[Keys[$duffUploadIdentityModelData], input],
		(* If upload function was not already called, call it and store the result *)
		Module[{data},

			(* Generate the data *)
			data = duffUploadIdentityModelCall[input];

			(* Store the result *)
			AppendTo[$duffUploadIdentityModelData, input -> data];

			data
		],

		(* Otherwise get the existing data, if still valid *)
		Module[{existingData},
			existingData = Lookup[$duffUploadIdentityModelData, input];

			(* If the data contains upload packets, do a quick check to ensure the object still doesn't exist. Otherwise get the new object *)
			If[
				And[
					(* Data contains upload packets *)
					MatchQ[Lookup[existingData, Packets], {PacketP[]..}],

					(* And lists the reserved object reference *)
					MatchQ[Lookup[existingData, Object], ObjectP[]],

					(* And molecule currently exists in database - do this check last so only triggered if needed *)
					DatabaseMemberQ[Lookup[existingData, Object]]
				],
				(
					(* Drop the existing data from the cache *)
					KeyDropFrom[$duffUploadIdentityModelData, input];

					(* Then call this function to get the data from the newly existing object *)
					duffUploadIdentityModel[input, output]
				),
				existingData
			]
		]
	];

	(* Return the data requested *)
	output /. uploadMoleculeData
];

(* Variable to store pending upload packets *)
(* Do it this way to prevent repeated UploadMolecule calls, like memoization *)
(* Real memoization if unfortunately too flaky though because ClearMemoization calls are scattered through UnitTest *)
$duffUploadIdentityModelData = <|
	(* duffUploadIdentityModelCall input -> duffUploadIdentityModelCall result *)
|>;

(* ::Subsubsection::Closed:: *)
(* Auxiliary packets function *)
uploadSampleModelAuxiliaryPackets[myType_, myInputs_List, myOptionsList_List, myResolvedMapThreadOptionsList_List] := Module[
	{
		modelSampleInputQs, auxiliaryPackets,
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

	(* Generate the auxiliary packets for each input *)
	auxiliaryPackets = MapThread[
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
	auxiliaryPackets
];


DefineOptions[generateUploadSampleModelPackets, Options :> {
	generateDefaultUploadPackets
}];

(* Custom packet generation is required because of the Composition field *)
(* The resolved option may contain UploadMolecule style identifiers which need to be converted into Model[Molecule] (or similar upload functions/types) *)
generateUploadSampleModelPackets[myType : TypeP[], myInputs : _List, myMapThreadResolvedOptions : {{_Rule..}...}, myOptions : OptionsPattern[generateUploadSampleModelPackets]] := Module[
	{
		optionsUpdatedForComposition, compositionUploadPackets, defaultPrimaryPackets, defaultAuxiliaryPackets,
		defaultInvalidOptions, uploadFunctionInputs, modifiedUploadFunctionInputs, newModels, uploadPackets,
		identifierReplacementRules, updatedCompositionFields, updatedCompositionOptions
	},

	(* Handle the composition field *)
	{optionsUpdatedForComposition, compositionUploadPackets} = Module[
		{existingCompositions, allIdentityModels},

		(* Extract the current compositions *)
		existingCompositions = Lookup[myMapThreadResolvedOptions, Composition, {}];

		(* Extract all of the identity models *)
		allIdentityModels = Flatten[If[ListQ[#],
			#[[All, 2]],
			Nothing
		] & /@ existingCompositions];

		(* Filter down so only UploadMolecule* function inputs are remaining *)
		uploadFunctionInputs = Select[allIdentityModels, And[!MatchQ[#, ObjectP[]], !MatchQ[#, Null]] &];

		(* Modify any identifiers to make suitable for upload function call *)
		modifiedUploadFunctionInputs = Replace[uploadFunctionInputs, x_Integer :> PubChem[x], {1}];

		(* Generate or retrieve the packets for the upload function call *)
		{newModels, uploadPackets} = If[MatchQ[modifiedUploadFunctionInputs, {}],
			{{}, {}},
			Transpose @ Map[
				duffUploadIdentityModel[#, {Object, Packets}] &,
				modifiedUploadFunctionInputs
			]
		];

		(* Create replacement rules from the original identifiers to the new identity model ID *)
		identifierReplacementRules = AssociationThread[uploadFunctionInputs, newModels];

		(* Update the composition fields with the new models *)
		updatedCompositionFields = Replace[existingCompositions, identifierReplacementRules, {3}];

		(* Update the composition options *)
		updatedCompositionOptions = MapThread[
			ReplaceRule[#1, Composition -> #2] &,
			{myMapThreadResolvedOptions, updatedCompositionFields}
		];

		(* Return the updated options with the upload packets *)
		{
			updatedCompositionOptions,
			Flatten[uploadPackets]
		}
	];

	(* Now use the standard packet generation function *)
	{defaultPrimaryPackets, defaultAuxiliaryPackets, defaultInvalidOptions} = generateDefaultUploadPackets[
		myType,
		myInputs,
		optionsUpdatedForComposition,
		myOptions
	];

	(* Return the results with all upload packets combined *)
	{
		defaultPrimaryPackets,
		Flatten[{defaultAuxiliaryPackets, compositionUploadPackets}],
		defaultInvalidOptions
	}
];
