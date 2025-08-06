(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*parsePubChem*)

DefineTests[
	parsePubChem,
	{
		(* These are all integration tests and will hit the API. PubChem has very high rate limits, so it's ok *)
		Example[{Basic, "Scrape data for a molecule from PubChem using a PubChem identifier and return in association format:"},
			parsePubChem[PubChem[2519]], (* Caffeine *)
			caffeineDataP
		],
		Example[{Basic, "Returns $Failed if the PubChem ID provided is invalid:"},
			parsePubChem[PubChem[1.1]],
			$Failed
		],
		Example[{Additional, "Identifiers", "The name of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], Name], (* Caffeine *)
			"Caffeine"
		],
		Example[{Additional, "Identifiers", "Synonyms of the compound name are parsed:"},
			Lookup[parsePubChem[PubChem[2519]], Synonyms], (* Caffeine *)
			{
				"1,3,7-Trimethylxanthine", "Caffedrine", "Caffeine", "Coffeinum N",
				"Coffeinum Purrum", "Dexitac", "Durvitan", "No Doz", "Percoffedrinol N",
				_, (* This synonym has bad encoding from PubChem *)
				 "Quick Pep", "Quick-Pep", "QuickPep", "Vivarin"
			}
		],
		Example[{Additional, "Identifiers", "The CAS registration number of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], CAS], (* Caffeine *)
			"58-08-2"
		],
		Example[{Additional, "Identifiers", "The InChI of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], InChI], (* Caffeine *)
			"InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"
		],
		Example[{Additional, "Identifiers", "The InChIKey of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], InChIKey], (* Caffeine *)
			"RYYVLZVUVIJVGH-UHFFFAOYSA-N"
		],
		Example[{Additional, "Identifiers", "The IUPAC systematic name of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], IUPAC], (* Caffeine *)
			"1,3,7-trimethylpurine-2,6-dione"
		],
		Example[{Additional, "Identifiers", "The UNII of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], UNII], (* Caffeine *)
			"3G6A5W338E"
		],
		Example[{Additional, "Identifiers", "The PubChem ID of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], PubChemID], (* Caffeine *)
			2519
		],

		Example[{Additional, "Chemical Structure", "The molecular formula of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], MolecularFormula], (* Caffeine *)
			"C8H10N4O2"
		],
		Example[{Additional, "Chemical Structure", "Whether a compound is monatomic is parsed:"},
			Lookup[
				{
					parsePubChem[PubChem[23987]], (* He *)
					parsePubChem[PubChem[783]] (* H2 *)
				},
				Monatomic
			],
			{
				True,
				False
			}
		],
		Example[{Additional, "Chemical Structure", "The molecular structure of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], Molecule], (* Caffeine *)
			_Molecule
		],
		Example[{Additional, "Chemical Structure", "A URL to an un-optimized set of 3D coordinates in sdf format is stored:"},
			url = Lookup[parsePubChem[PubChem[753]], StructureFile]; (* Glycerin *)
			{
				url,
				Import[url],
				Import[url, "SDF"]
			},
			{
				URLP,
				{
					{753},
					__
				},
				{_Molecule}
			},
			Variables :> {url}
		],
		Example[{Additional, "Chemical Structure", "A URL to an image of the chemical structure is stored:"},
			url = Lookup[parsePubChem[PubChem[753]], StructureImageFile]; (* Glycerin *)
			{
				url,
				Import[url]
			},
			{
				URLP,
				_Image
			},
			Variables :> {url}
		],

		Example[{Additional, "Physical and Chemical Properties", "The melting point of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[5462222]], MeltingPoint], (* Potassium *)
			RangeP[63 Celsius, 64 Celsius]
		],
		Example[{Additional, "Physical and Chemical Properties", "The boiling point of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[5462222]], BoilingPoint], (* Potassium *)
			RangeP[755 Celsius, 775 Celsius]
		],
		Example[{Additional, "Physical and Chemical Properties", "The density of the compound is parsed:"},
			Lookup[
				{
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[753]], (* Glycerin *)
					parsePubChem[PubChem[14798]], (* NaOH *)
					parsePubChem[PubChem[1118]], (* Sulfuric acid *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[702]] (* Ethanol *)
				},
				Density
			],
			{
				RangeP[1.53 Gram / Centimeter^3, 1.54 Gram / Centimeter^3],
				RangeP[1.25 Gram / Centimeter^3, 1.27 Gram / Centimeter^3],
				RangeP[2.12 Gram / Centimeter^3, 2.14 Gram / Centimeter^3],
				RangeP[1.825 Gram / Centimeter^3, 1.835 Gram / Centimeter^3],
				RangeP[1.45 Gram / Centimeter^3, 1.55 Gram / Centimeter^3],
				RangeP[0.785 Gram / Centimeter^3, 0.795 Gram / Centimeter^3]
			}
		],
		Example[{Additional, "Physical and Chemical Properties", "The vapor pressure of the compound is parsed:"},
			Lookup[
				{
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[753]], (* Glycerin *)
					parsePubChem[PubChem[14798]], (* NaOH *)
					parsePubChem[PubChem[1118]], (* Sulfuric acid *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[702]] (* Ethanol *)
				},
				VaporPressure
			],
			{
				Null,
				RangeP[350 Millipascal, 450 Millipascal],
				RangeP[0 Millipascal, 1 Millipascal],
				RangeP[100 Millipascal, 150 Millipascal],
				RangeP[6 Kilopascal, 7 Kilopascal],
				RangeP[5.5 Kilopascal, 6.5 Kilopascal]
			}
		],
		Example[{Additional, "Physical and Chemical Properties", "The logP of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[33032]], LogP],
			RangeP[-3.8, -3.6]
		],
		Example[{Additional, "Physical and Chemical Properties", "The state of a compound is parsed:"},
			Lookup[
				{
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[702]], (* Ethanol *)
					parsePubChem[PubChem[402]] (* Hydrogen sulfide *)

				},
				State
			],
			{
				Solid,
				Liquid,
				Gas
			}
		],
		Example[{Additional, "Physical and Chemical Properties", "The molecular weight of a compound is parsed:"},
			Lookup[
				{
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[702]], (* Ethanol *)
					parsePubChem[PubChem[402]] (* Hydrogen sulfide *)

				},
				MolecularWeight
			],
			{
				EqualP[147.13 Gram / Mole],
				EqualP[46.07 Gram / Mole],
				EqualP[34.08 Gram / Mole]
			}
		],
		Example[{Additional, "Physical and Chemical Properties", "The exact mass of a compound is parsed:"},
			Lookup[
				{
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[702]], (* Ethanol *)
					parsePubChem[PubChem[402]] (* Hydrogen sulfide *)

				},
				ExactMass
			],
			{
				EqualP[147.05315777` Gram / Mole],
				EqualP[46.041864811` Gram / Mole],
				EqualP[33.98772124` Gram / Mole]
			}
		],
		Example[{Additional, "Physical and Chemical Properties", "The pKas of a compound are parsed:"},
			Lookup[
				{
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[702]], (* Ethanol *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[971]] (* Oxalic acid *)
				},
				pKa
			],
			{
				{RangeP[2.1, 2.3], RangeP[4.1, 4.3], RangeP[9.6, 9.8]},
				{RangeP[15.8, 16.0]},
				{RangeP[-1.5, -1.3]},
				Null,
				{RangeP[1.4, 1.5], RangeP[4.35, 4.45]}
			}
		],
		Example[{Additional, "Physical and Chemical Properties", "The viscosities of a compound are parsed:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[753]], (* Glycerin *)
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[174]] (* Ethylene glycol *)

				},
				Viscosity
			],
			{
				RangeP[0.4 Centipoise, 0.6 Centipoise],
				RangeP[900 Centipoise, 1000 Centipoise],
				Null,
				RangeP[14 Centipoise, 18 Centipoise]
			}
		],
		Example[{Additional, "Physical and Chemical Properties", "Strongly acidic molecules are identified, if that information is included in the record:"},
			Lookup[
				{
					parsePubChem[PubChem[176]], (* Acetic acid *)
					parsePubChem[PubChem[753]], (* Glycerin *)
					parsePubChem[PubChem[174]], (* Ethylene glycol *)
					parsePubChem[PubChem[1004]], (* Phosphoric acid *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[1118]] (* Sulfuric acid *)

				},
				Acid
			],
			{
				Null, (* Weak acid *)
				Null, (* Not acid *)
				Null, (* Not acid *)
				True, (* Chemically weak acid, but strong enough to meet our definition *)
				True, (* Strong acid *)
				True (* Strong acid *)
			}
		],
		Example[{Additional, "Physical and Chemical Properties", "Strong bases are identified, if that information is included in the record:"},
			Lookup[
				{
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[753]], (* Glycerin *)
					parsePubChem[PubChem[14798]], (* Sodium hydroxide *)
					parsePubChem[PubChem[1118]], (* Sulfuric acid *)
					parsePubChem[PubChem[10340]], (* Sodium carbonate *)
					parsePubChem[PubChem[10796]] (* Cesium carbonate *)

				},
				Base
			],
			{
				Null, (* Not base *)
				Null, (* Not base *)
				True, (* Strong base *)
				Null, (* Not base *)
				True, (* Strong base *)
				Null (* No info *)
			}
		],
		Example[{Additional, "Physical and Chemical Properties", "Incompatible materials are populated based on information in the PubChem record:"},
			Lookup[
				{
					parsePubChem[PubChem[962]], (* Water *)
					parsePubChem[PubChem[753]], (* Glycerin *)
					parsePubChem[PubChem[14798]], (* NaOH *)
					parsePubChem[PubChem[1118]], (* Sulfuric acid *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[702]] (* Ethanol *)

				},
				IncompatibleMaterials
			],
			{
				{None},
				{Oxidizer},
				_?(And[
					MemberQ[#, Oxidizer], (* Strong base is not compatible with oxidizers *)
					MemberQ[#, OrganicMaterialP], (* Corrosive to organic materials *)
					MemberQ[#, Zinc], (* Strong bases are reactive with certain metals, such as zinc *)
					!MemberQ[#, Magnesium], (* Strong bases don't react with many metals, unlike acids *)
					!MemberQ[#, Platinum] (* No reaction with inert metals *)
				] &),
				_?(And[
					MemberQ[#, Oxidizer], (* Strong acid is not compatible with oxidizers *)
					MemberQ[#, OrganicMaterialP], (* Corrosive to organic materials *)
					MemberQ[#, Magnesium], (* Strong acids react with many metals *)
					!MemberQ[#, Platinum] (* No reaction with inert metals *)
				] &),
				_?(And[
					MemberQ[#, Oxidizer], (* Strong acids are not compatible with oxidizers *)
					MemberQ[#, OrganicMaterialP], (* Corrosive to organic materials *)
					MemberQ[#, GlassP], (* Nitric acid can etch glasses *)
					MemberQ[#, Magnesium], (* Strong acids react with many metals *)
					!MemberQ[#, Platinum] (* No reaction with inert metals *)
				] &),
				{Oxidizer}
			}
		],


		Example[{Additional, "Hazard and Safety", "Identifies if a compound is radioactive:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[24824]] (* Tritium *)
				},
				Radioactive
			],
			{
				False,
				True
			}
		],
		Example[{Additional, "Hazard and Safety", "Identifies if a compound reaches the ECL definition of a Particularly Hazardous Substance:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[1004]], (* Phosphoric acid *)
					parsePubChem[PubChem[174]], (* Ethylene glycol *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[5462222]], (* Potassium *)
					parsePubChem[PubChem[6228]] (* Dimethylformamide *)
				},
				ParticularlyHazardousSubstance
			],
			{
				False,
				False,
				False,
				False,
				True,
				False,
				True
			}
		],
		Example[{Additional, "Hazard and Safety", "Particularly Hazardous Substance refers to toxicity, rather than other hazards, so BuLi returns False:"},
			Lookup[
				parsePubChem[PubChem[28112]], (* LiAlH4 *)
				{
					ParticularlyHazardousSubstance,
					Flammable,
					Pyrophoric,
					WaterReactive
				}
			],
			{
				False,
				True,
				True,
				True
			}
		],
		Example[{Additional, "Hazard and Safety", "Identifies if a compound requires an MSDS:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[1004]], (* Phosphoric acid *)
					parsePubChem[PubChem[174]], (* Ethylene glycol *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[5462222]], (* Potassium *)
					parsePubChem[PubChem[28112]], (* LiAlH4 *)
					parsePubChem[PubChem[6228]] (* Dimethylformamide *)
				},
				MSDSRequired
			],
			{
				True,
				False,
				True,
				True,
				True,
				True,
				True,
				True
			}
		],
		Example[{Additional, "Hazard and Safety", "Identifies the DOT Hazard class of a compound:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[1004]], (* Phosphoric acid *)
					parsePubChem[PubChem[174]], (* Ethylene glycol *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[5462222]], (* Potassium *)
					parsePubChem[PubChem[6228]] (* Dimethylformamide *)
				},
				DOTHazardClass
			],
			{
				"Class 3 Flammable Liquids Hazard",
				Null,
				"Class 8 Division 8 Corrosives Hazard",
				Null,
				"Class 8 Division 8 Corrosives Hazard",
				"Class 4 Division 4.3 Dangerous when Wet Hazard",
				"Class 3 Flammable Liquids Hazard"
			}
		],
		Example[{Additional, "Hazard and Safety", "Null DOTHazardClass indicates that information could not be found, not that a compound is not hazardous:"},
			Lookup[
				parsePubChem[PubChem[61028]], (* BuLi *)
				DOTHazardClass
			],
			Null
		],
		Example[{Additional, "Hazard and Safety", "Identifies the NFPA hazard information of a compound:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[1004]], (* Phosphoric acid *)
					parsePubChem[PubChem[174]], (* Ethylene glycol *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[5462222]], (* Potassium *)
					parsePubChem[PubChem[6228]] (* Dimethylformamide *)
				},
				NFPA
			],
			{
				{1,3,0,{}},
				Null,
				{3,0,0,{}},
				{2,1,0,{}},
				{4,0,0,{Oxidizer}},
				{3, 1, 2, {WaterReactive}},
				{2, 2, 0, {}}
			}
		],
		Example[{Additional, "Hazard and Safety", "Null NFPA hazard information may mean that information was not found, rather than no hazard:"},
			Lookup[
				parsePubChem[PubChem[28112]], (* LiAlH4 *)
				{
					NFPA,
					Flammable,
					Pyrophoric,
					WaterReactive
				}
			],
			{
				Null,
				True,
				True,
				True
			}
		],
		Example[{Additional, "Hazard and Safety", "Identifies if a compound is readily flammable or not:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[1004]], (* Phosphoric acid *)
					parsePubChem[PubChem[174]], (* Ethylene glycol *)
					parsePubChem[PubChem[944]] (* Nitric acid *)
				},
				Flammable
			],
			{
				True,
				False,
				False,
				False,
				False
			}
		],
		Example[{Additional, "Hazard and Safety", "Low flammability combustible compounds are not marked as flammable:"},
			Lookup[
				parsePubChem[PubChem[957]], (* 1-octanol *)
				Flammable
			],
			False
		],
		Example[{Additional, "Hazard and Safety", "Non-combustible compounds that may readily generate flammable situations are marked as flammable:"},
			Lookup[
				parsePubChem[PubChem[5462222]], (* Potassium *)
				Flammable
			],
			True
		],
		Example[{Additional, "Hazard and Safety", "Identifies if a compound is pyrophoric:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[28112]], (* LiAlH4 *)
					parsePubChem[PubChem[944]] (* Nitric acid *)
				},
				Pyrophoric
			],
			{
				False,
				True,
				False
			}
		],
		Example[{Additional, "Hazard and Safety", "Compounds that react with moisture in the air are not marked as pyrophoric:"},
			Lookup[
				parsePubChem[PubChem[5462222]], (* Potassium *)
				Pyrophoric
			],
			False
		],
		Example[{Additional, "Hazard and Safety", "Identifies if a compound is water reactive:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[1004]], (* Phosphoric acid *)
					parsePubChem[PubChem[5462222]], (* Potassium *)
					parsePubChem[PubChem[1118]], (* Sulfuric acid *)
					parsePubChem[PubChem[28112]] (* LiAlH4 *)
				},
				WaterReactive
			],
			{
				False,
				False,
				False,
				True,
				True,
				True
			}
		],
		Example[{Additional, "Hazard and Safety", "Identifies if a compound requires ventilation:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[957]], (* 1-octanol *)
					parsePubChem[PubChem[33032]], (* Glutamic acid *)
					parsePubChem[PubChem[1004]], (* Phosphoric acid *)
					parsePubChem[PubChem[5462222]], (* Potassium *)
					parsePubChem[PubChem[1118]], (* Sulfuric acid *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[18502]] (* Cyclohexyl isocyanate *)
				},
				{Fuming, Pungent, ParticularlyHazardousSubstance, Ventilated}
			],
			{
				{True, False, False, True},
				{False, False, False, False}, (* Some describe 1-octanol as pungent, but most don't *)
				{False, False, False, False},
				{False, False, False, False},
				{False, False, False, False},
				{False, False, False, False},
				{True, True, True, True},
				{True, True, True, True}
			}
		],
		Example[{Additional, "Hazard and Safety", "Identifies if a compound should not be disposed of down a drain:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[24947]], (* Cadmium chloride *)
					parsePubChem[PubChem[24085]], (* Mercuric chloride *)
					parsePubChem[PubChem[36187]], (* Tetrachlorobiphenyl *)
					parsePubChem[PubChem[2519]], (* Caffeine *)
					parsePubChem[PubChem[24824]] (* Tritium *)
				},
				DrainDisposal
			],
			{
				False,
				Null,
				False,
				False,
				False,
				Null,
				False
			}
		],
		Example[{Additional, "Hazard and Safety", "Identifies if a compound is light sensitive:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[24563]], (* Silver iodide *)
					parsePubChem[PubChem[784]], (* Hydrogen peroxide *)
					parsePubChem[PubChem[3283]] (* Diethyl ether *)
				},
				LightSensitive
			],
			{
				False,
				True,
				True,
				True
			}
		],
		Example[{Additional, "Hazard and Safety", "Identifies if a compound has a strong odor:"},
			Lookup[
				{
					parsePubChem[PubChem[356]], (* Octane *)
					parsePubChem[PubChem[24563]], (* Silver iodide *)
					parsePubChem[PubChem[784]], (* Hydrogen peroxide *)
					parsePubChem[PubChem[18502]], (* Cyclohexyl isocyanate *)
					parsePubChem[PubChem[944]], (* Nitric acid *)
					parsePubChem[PubChem[2519]] (* Caffeine *)

				},
				Pungent
			],
			{
				False,
				False,
				True,
				True,
				True,
				False
			}
		],
		Test["Radioactivity -> True is correctly parsed:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Radioactive
			],
			True,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Record Description"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A moderately radioactive solid."|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Something else."|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["The most common IUPAC name is used if multiple appear:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IUPAC
			],
			"Name2",
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "IUPAC Name"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Name1"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Name2"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Name3"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Name2"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["The most common, valid InChI is used if multiple appear:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				InChI
			],
			"InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3",
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "InChI"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "InChI=Name1"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "InChI=Name3"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotAnInChI"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotAnInChI"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotAnInChI"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["The most common, valid InChIKey is used if multiple appear:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				InChIKey
			],
			"RYYVLZVUVIJVGH-UHFFFAOYSA-N",
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "InChIKey"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "RYYVLZVUVIJVGH-UHFFFAOYSA-N"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "RYYVLZVUVIJVGH-UHFFFAOYSA-N"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "RYYVLZVUVIJVGH-AAAAAAAAAA-N"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "RYYVLZVUVIJVGH-BBBBBBBBBB-N"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotAnInChIKey"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotAnInChIKey"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotAnInChIKey"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["The most common, valid CAS Number is used if multiple appear:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				CAS
			],
			"58-08-2",
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "CAS"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "58-08-2"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "58-08-2"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "60-00-0"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "99-00-1"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotACAS"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotACAS"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotACAS"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["The most common, valid UNII number is used if multiple appear:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				UNII
			],
			"3G6A5W338E",
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "UNII"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "3G6A5W338E"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "3G6A5W338E"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "ABC"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "ABCD"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "!!!!!!"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "!!!!!!"|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "!!!!!!"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["The median molecular weight is returned:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				MolecularWeight
			],
			EqualP[100 Gram / Mole],
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Molecular Weight"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "99.0"|>}, "Unit" -> "g/mol"|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "99.5"|>}, "Unit" -> "g/mol"|>|>, (* Valid *)
					<|"Value" -> <|"Number" -> {100.5}, "Unit" -> "g/mol"|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "101.0"|>}, "Unit" -> "g/mol"|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "0.1"|>}|>|> (* Invalid *)
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["The median logP is returned:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				LogP
			],
			EqualP[-2.5],
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "LogP"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "-1.0"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "-2"|>}|>|>, (* Valid *)
					<|"Value" -> <|"Number" -> {-3.0}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "log Kow = -4.0"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "log invalid = 0.1"|>}|>|> (* Invalid *)
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["The median median pKa is returned for each cluster of values:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				pKa
			],
			{EqualP[2.2], EqualP[4.4], EqualP[9.1]},
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Dissociation Constants"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "2.1"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "2.3"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "4.4"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "9.1"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "9.05"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "9.5"|>}|>|> (* Valid *)
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["pKa parsing only interprets strings that match known patterns to reduce import of invalid data:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				pKa
			],
			{EqualP[0.1], EqualP[1.0], EqualP[2.3], EqualP[3.4], EqualP[4.4], EqualP[5.6], EqualP[6.7], EqualP[9.5]},
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Dissociation Constants"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "0.1 (ref, 1990)"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "pKa = 1."|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "pK1 = 2.3"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "pK1 = 3.4 (ref, 1992)"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "pK1 = 4.4; pK2 = 5.6; pK3 = 6.7"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "pKb = 7.5"|>}|>|>, (* Invalid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "pKaH = 8.6"|>}|>|>, (* Invalid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "pKa = 9.5; pKb = 10.2"|>}|>|> (* Mixed *)
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Viscosity parsing only interprets strings that match known patterns to reduce import of invalid data, and returns the median:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Viscosity
			],
			EqualP[1.7 Centipoise],
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Viscosity"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "1.0 Centipoise"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "1.2 cP"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "1.3-1.4 cP"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "1.6 cP at 25 \[Degree]C"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "1.7 cP @ 77 Fahrenheit"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "1.8 cP AT 298 Kelvin (ref, 2012)"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "1.9 mPa-s; 2.0 mPa.s; 2.1 mPa*sec"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "9 cP at 35 \[Degree]C"|>}|>|>, (* Invalid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "NotMyCompound: 9 cP"|>}|>|>, (* Invalid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "9 cP (70% soln)"|>}|>|>, (* Invalid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "9 cP (random stuff)"|>}|>|> (* Treated as invalid, as we can't interpret the unknown string *)
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Melting point parsing attempts to filter invalid data and returns the median:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				MeltingPoint
			],
			EqualP[15 Celsius],
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Melting Point"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "14.2 Celsius"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "14.3 \[Degree]C"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "59 Fahrenheit"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "59 \[Degree]F"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "289.15 Kelvin"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "14.8-15.4 Celsius"|>}|>|>, (* Valid - use average value *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "24 TO 26 Centigrade"|>}|>|>, (* Parsed but ignored as out of range *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Latent heat of fusion - 10.5 kJ/mol (999 \[Degree]C)"|>}|>|>, (* Parsed but ignored *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "My compound: 28 Celsius; not my compound 1: 60 Celsius; no really, it's 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius;"|>}|>|> (* Parsed but spam filtered down and ignored *)
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Boiling point parsing attempts to filter invalid data and returns the median:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				BoilingPoint
			],
			EqualP[15 Celsius],
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Boiling Point"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "14.2 Celsius"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "14.3 \[Degree]C at 760 mmHg"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "59 Fahrenheit @ 760 mm Hg"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "59 \[Degree]F"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "289.15 Kelvin"|>}|>|>, (* Valid *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "14.8-15.4 Celsius at 1 atm"|>}|>|>, (* Valid - use average value *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "24 TO 26 Centigrade"|>}|>|>, (* Parsed but ignored as out of range *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Latent heat of fusion - 10.5 kJ/mol (999 \[Degree]C)"|>}|>|>, (* Parsed but ignored *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "My compound: 28 Celsius; not my compound 1: 60 Celsius; no really, it's 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius; 61 Celsius;"|>}|>|>, (* Parsed but spam filtered down and ignored *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "14.3 \[Degree]C at 740 mmHg"|>}|>|>, (* Ignored as wrong pressure *)
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "14.3 \[Degree]C at 720 mmHg"|>}|>|> (* Ignored as wrong pressure *)
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["State -> Solid is correctly parsed:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				State
			],
			Solid,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Physical Description"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A powdery solid."|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A solid that dissolves in liquid."|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["State -> Liquid is correctly parsed:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				State
			],
			Liquid,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Physical Description"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A yellow oil."|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Oily liquid."|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["State -> Gas is correctly parsed:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				State
			],
			Gas,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Physical Description"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A colorless gas."|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A colorless gas that's commonly used as a cryogenic liquid."|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["State is determined from melting and boiling points if the description doesn't provide a clear state:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				State
			],
			Gas,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Physical Description"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A colorless gas that's commonly used as a cryogenic liquid."|>}|>|>,
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A colorless gas that's commonly used as a cryogenic liquid."|>}|>|>
				},
				extractJSON[__, {HoldPattern["TOCHeading" == "Boiling Point"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "-50 Celsius"|>}|>|>
				},
				extractJSON[__, {HoldPattern["TOCHeading" == "Melting Point"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "-100 Celsius"|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["NFPA hazard information is correctly parsed from the NFPA diamond:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				NFPA
			],
			{2, 3, 4, {Oxidizer}},
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "NFPA Hazard Classification"], "Information"}] = {
					<|"Name" -> "NFPA Fire Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA Health Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA Instability Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA Specific Notice", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "Ox - description"|>}|>|>,
					<|"Name" -> "NFPA 704 Diamond", "Value" -> <|"StringWithMarkup" -> {<|"Extra" -> "2-3-4-Ox"|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["If information conflicts, the highest hazard rating is used, and specific conditions are additive:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				NFPA
			],
			{3, 4, 4, {Corrosive, Oxidizer}},
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "NFPA Hazard Classification"], "Information"}] = {
					<|"Name" -> "NFPA Fire Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA Fire Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "4 - description"|>}|>|>,
					<|"Name" -> "NFPA Fire Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "3 - description"|>}|>|>,
					<|"Name" -> "NFPA Health Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "3 - description"|>}|>|>,
					<|"Name" -> "NFPA Instability Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA Specific Notice", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "Cor - description"|>}|>|>,
					<|"Name" -> "NFPA 704 Diamond", "Value" -> <|"StringWithMarkup" -> {<|"Extra" -> "2-3-4-Ox"|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as non-hazardous and doesn't require an MSDS if it is described as non-hazardous and has no H-codes:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				{
					MSDSRequired,
					ParticularlyHazardousSubstance
				}
			],
			{
				False,
				False
			},
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <||>,
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Reported as not meeting GHS hazard criteria"|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound requires an MSDS if it has H-codes but not those indicating a high level of toxicity:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				{
					MSDSRequired,
					ParticularlyHazardousSubstance
				}
			],
			{
				True,
				False
			},
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H227"|>}|>|>,
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> ""|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as particularly hazardous and requiring an MSDS if it has H-codes that indicate high toxicity:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				{
					MSDSRequired,
					ParticularlyHazardousSubstance
				}
			],
			{
				True,
				True
			},
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H300"|>}|>|>,
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> ""|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as flammable if it has a flammable H-code:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Flammable
			],
			True,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H205"|>}|>|>
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is not marked as flammable if it doesn't have a flammable H-code:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Flammable
			],
			False,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H300"|>}|>|>
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as flammable if the NFPA hazard information indicates it is:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Flammable
			],
			True,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H300"|>}|>|>,
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "NFPA Hazard Classification"], "Information"}] = {
					<|"Name" -> "NFPA Fire Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "4 - description"|>}|>|>,
					<|"Name" -> "NFPA Health Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "3 - description"|>}|>|>,
					<|"Name" -> "NFPA Instability Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA Specific Notice", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "Cor - description"|>}|>|>,
					<|"Name" -> "NFPA 704 Diamond", "Value" -> <|"StringWithMarkup" -> {<|"Extra" -> "3-4-1-Cor"|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Flammable is left as null if no safety information was parsed:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Flammable
			],
			Null,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>]
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as pyrophoric if it has a pyrophoric H-code:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Pyrophoric
			],
			True,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H220"|>}|>|>
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is not marked as pyrophoric if it doesn't have a pyrophoric H-code:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Pyrophoric
			],
			False,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H205"|>}|>|>
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Pyrophoric is left as null if no safety information was parsed:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Pyrophoric
			],
			Null,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>]
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as water reactive if it has a water reactive H-code:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				WaterReactive
			],
			True,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H260"|>}|>|>
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as water reactive if NFPA hazard information indicates it is:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				WaterReactive
			],
			True,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "NFPA Hazard Classification"], "Information"}] = {
					<|"Name" -> "NFPA Fire Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "4 - description"|>}|>|>,
					<|"Name" -> "NFPA Health Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "3 - description"|>}|>|>,
					<|"Name" -> "NFPA Instability Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA 704 Diamond", "Value" -> <|"StringWithMarkup" -> {<|"Extra" -> "3-4-1-w"|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is not marked as water reactive if it doesn't have a water reactive H-code:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				WaterReactive
			],
			False,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H205"|>}|>|>
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["WaterReactive is left as null if no safety information was parsed:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				WaterReactive
			],
			Null,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>]
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as fuming if it has H-codes the imply that:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Fuming
			],
			True,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H330"|>}|>|>
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as fuming if the description implies that:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Fuming
			],
			True,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H220"|>}|>|>,
				extractJSON[__, {HoldPattern["TOCHeading" == "Physical Description"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A fuming liquid."|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["A compound is marked as non-fuming if neither the H-codes nor description imply that:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Fuming
			],
			False,
			Stubs :> {
				(* We're simulating the required data, so stub the HTTP response to prevent unnecessary download *)
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H220"|>}|>|>,
				extractJSON[__, {HoldPattern["TOCHeading" == "Physical Description"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "A liquid."|>}|>|>
				}
			},
			(* parsePubChem memoizes and for these tests we want different stubs each time *)
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["DOT hazard class can be identified from UN shipping identifier:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				DOTHazardClass
			],
			"Class 3 Flammable Liquids Hazard",
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Transport Information"], "Section", HoldPattern["TOCHeading" == "DOT Label"], "Information"}] := $Failed,
				extractJSON[__, {HoldPattern["TOCHeading" == "UN Number"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "1111"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["DOT hazard class can be identified directly from data imported from PubChem:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				DOTHazardClass
			],
			"Class 3 Flammable Liquids Hazard",
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Transport Information"], "Section", HoldPattern["TOCHeading" == "DOT Label"], "Information"}] := {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Flammable Liquid"|>}|>|>
				},
				extractJSON[__, {HoldPattern["TOCHeading" == "UN Number"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "1000"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Strong acids can be identified from pKa:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Acid
			],
			True,
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Dissociation Constants"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "-1"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Strong acids can be identified from NFPA hazard diamond:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Acid
			],
			True,
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "NFPA Hazard Classification"], "Information"}] = {
					<|"Name" -> "NFPA Fire Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA Health Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA Instability Rating", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "1 - description"|>}|>|>,
					<|"Name" -> "NFPA Specific Notice", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "Acid - description"|>}|>|>,
					<|"Name" -> "NFPA 704 Diamond", "Value" -> <|"StringWithMarkup" -> {<|"Extra" -> "2-3-4-Acid"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Strong bases can be identified from description in the pH section:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				Base
			],
			True,
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "pH"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Forms strongly alkaline solutions in water."|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Substances incompatible with oxidizers can be identified from reactivity data:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IncompatibleMaterials
			],
			_?(MemberQ[#, Oxidizer] &),
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Handling and Storage"], "Section", HoldPattern["TOCHeading" == "Safe Storage"], "Information"}] = {
					<|"Name" -> "", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "Store separated from strong oxidants"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Flammable substances are incompatible with oxidizers:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IncompatibleMaterials
			],
			_?(MemberQ[#, Oxidizer] &),
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Hazards Identification"], "Section", HoldPattern["TOCHeading" == "GHS Classification"], "Information", HoldPattern["Name" == "GHS Hazard Statements"]}] = <|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "H205"|>}|>|>
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Strong acids are incompatible with oxidizers:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IncompatibleMaterials
			],
			_?(MemberQ[#, Oxidizer] &),
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Dissociation Constants"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "-1"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Strong bases are incompatible with oxidizers:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IncompatibleMaterials
			],
			_?(MemberQ[#, Oxidizer] &),
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "pH"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Forms strongly alkaline solutions in water."|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Substances that etch glass can be identified from reactivity data:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IncompatibleMaterials
			],
			_?(MemberQ[#, GlassP] &),
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Handling and Storage"], "Section", HoldPattern["TOCHeading" == "Safe Storage"], "Information"}] = {
					<|"Name" -> "", "Value" -> <|"StringWithMarkup" -> {<|"String" -> "Etches glass"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Strong acids are incompatible with organics:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IncompatibleMaterials
			],
			_?(MemberQ[#, OrganicMaterialP] &),
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Dissociation Constants"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "-1"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Strong bases are incompatible with organics:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IncompatibleMaterials
			],
			_?(MemberQ[#, OrganicMaterialP] &),
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "pH"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Forms strongly alkaline solutions in water."|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Strong acids are incompatible with most metals:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IncompatibleMaterials
			],
			_?(
				And[
					MemberQ[#, Zinc],
					MemberQ[#, Magnesium],
					!MemberQ[#, Platinum]
				]
					&),
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "Dissociation Constants"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "-1"|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		],
		Test["Strong bases are incompatible with some metals:",
			Lookup[
				parsePubChem[PubChem[2.2]], (* Invalid ID for local testing *)
				IncompatibleMaterials
			],
			_?(
				And[
					MemberQ[#, Zinc],
					!MemberQ[#, Magnesium],
					!MemberQ[#, Platinum]
				]
					&),
			Stubs :> {
				URLRead[__] = HTTPResponse[ExportString[<|"Record" -> <||>|>, "RawJSON"], <|"StatusCode" -> 200|>],
				extractJSON[__, {HoldPattern["TOCHeading" == "pH"], "Information"}] = {
					<|"Value" -> <|"StringWithMarkup" -> {<|"String" -> "Forms strongly alkaline solutions in water."|>}|>|>
				}
			},
			SetUp :> {ClearMemoization[parsePubChem]}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*approximateDensity*)

DefineTests[approximateDensity,
	{
		Test["Approximates density when provided composition with 2 VolumePercent components:",
			Round[UnitConvert[approximateDensity[{
				{50 VolumePercent,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample1"], ID->"id:testSample1"|>},
				{50 VolumePercent,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.67 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when provided composition with 2 MassPercent components:",
			Round[UnitConvert[approximateDensity[{
				{50 MassPercent,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample1"], ID->"id:testSample1"|>},
				{50 MassPercent,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.5 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when provided composition with 1 MassPercent and 1 VolumePercent components:",
			Round[UnitConvert[approximateDensity[{
				{50 MassPercent,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample1"], ID->"id:testSample1"|>},
				{50 VolumePercent,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.67 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when provided volumes for both components being mixed:",
			Round[UnitConvert[approximateDensity[{
				{1 Milliliter,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Object[Sample], Object->Object[Sample, "id:testSample1"], ID->"id:testSample1"|>},
				{1 Milliliter,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Object[Sample], Object->Object[Sample, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.67 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when transferring 0 mL to 0 mL to not freak out and just pick water's density:",
			Round[UnitConvert[approximateDensity[{
				{0 Milliliter, <|State -> Liquid, Density -> Null, Type -> Object[Sample], Object -> Object[Sample, "id:testSample1"], ID -> "id:testSample1"|>},
				{0 Milliliter, <|State -> Liquid, Density -> Null, Type -> Object[Sample], Object -> Object[Sample, "id:testSample2"], ID -> "id:testSample2"|>}
			}], "Grams" / "Milliliters"], 0.01],
			(1. Gram / Milliliter),
			EquivalenceFunction -> Equal
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*findSDS*)

DefineTests[
	findSDS,
	{
		(* Integration test - pings ChemicalSafety.com (data is memoized between tests) *)
		Example[{Basic, "Return the URL to a potential SDS file for a compound with the supplied CAS number:"},
			findSDS["58-08-2", Output -> URL],
			URLP
		],
		Example[{Basic, "Return the URL to a potential SDS file for a compound with the supplied name:"},
			findSDS["caffeine", Output -> URL],
			URLP
		],
		(* Integration test - downloads SDS from Thermo. (data is memoized between tests) *)
		Example[{Options, Output, "Confirm that the URL returned is valid and points to a pdf:"},
			findSDS["58-08-2", Output -> ValidatedURL],
			URLP
		],
		Example[{Options, Output, "Download an SDS for the requested compound and return the filepath to the downloaded file:"},
			findSDS["58-08-2", Output -> TemporaryFile],
			_File
		],
		Example[{Options, Output, "Download an SDS for the requested compound and open it:"},
			findSDS["58-08-2", Output -> Open],
			Null,
			Stubs :> {SystemOpen[___] := Null}
		],
		Example[{Options, Output, "Download an SDS for the requested compound and upload it to constellation:"},
			findSDS["58-08-2", Output -> CloudFile],
			ObjectP[Object[EmeraldCloudFile]]
		],
		Example[{Options, Vendor, "Specify a preferred vendor to obtain the SDS from. Vendor names should match part of the vendor's URL:"},
			findSDS["58-08-2", Output -> URL, Vendor -> "Thermofisher"],
			URLP
		],
		Example[{Options, Vendor, "Specify a preferred manufacturer to obtain the SDS for. Manufacturer names should match the name of the manufacturer used by ChemicalSafety:"},
			findSDS["58-08-2", Output -> URL, Manufacturer -> "Thermofisher"],
			URLP
		],
		Example[{Options, Product, "Specify the preferred product ID to obtain the SDS for. The ID must match part of the vendor's URL:"},
			findSDS["58-08-2", Output -> URL, Product -> "ALFAA39214"],
			URLP
		],
		Test["Default vendor, manufacturer and product prioritization works as expected:",
			findSDS["Test", Output -> URL],
			"http://www.thermofisher.com/url1.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		],
		Test["Product ID prioritization works as expected:",
			findSDS["Test", Product -> "123v3", Output -> URL],
			"http://www.sigmaaldrich.com/product123v3-url1.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		],
		Test["Vendor prioritization works as expected:",
			findSDS["Test", Vendor -> "emerald", Output -> URL],
			"http://www.emeraldcloudlab.com/url1.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		],
		Test["Manufacturer prioritization works as expected:",
			findSDS["Test", Manufacturer -> "random", Output -> URL],
			"http://www.sigmaaldrich.com/url1.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		],
		Test["Combining Manufacturer and Vendor prioritization works as expected:",
			findSDS["Test", Manufacturer -> "Fisher", Vendor -> "sigma", Output -> URL],
			"http://www.sigmaaldrich.com/url4.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*downloadAndValidateURL*)

DefineTests[downloadAndValidateURL,
	{
		Example[{Basic, "Download and memoize a website and check that the downloaded version contains valid HTML:"},
			downloadAndValidateURL[
				"www.emeraldcloudlab.com",
				"site.html",
				MatchQ[FileFormat[#], "HTML"] &
			],
			_File
		],
		Example[{Basic, "Returns and memoizes $Failed if the downloaded file doesn't pass validation:"},
			downloadAndValidateURL[
				"www.emeraldcloudlab.com/",
				"site.pdf",
				MatchQ[FileFormat[#], "PDF"] &
			],
			$Failed
		],
		Test["Function result is memoized:",
			downloadAndValidateURL[
				"www.emeraldcloudlab.com",
				"site.html",
				MatchQ[FileFormat[#], "HTML"] &
			];

			AbsoluteTiming[
				downloadAndValidateURL[
					"www.emeraldcloudlab.com",
					"site.html",
					MatchQ[FileFormat[#], "HTML"] &
				]
			],
			{LessP[0.001], _File}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*validateLocalFile*)

DefineTests[validateLocalFile,
	{
		Example[{Basic, "Validate a local file, memoize the result and return the valid file:"},
			validateLocalFile[
				FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
				ImageQ[Import[#]] &
			],
			_File
		],
		Example[{Basic, "Returns and memoizes $Failed if the file doesn't pass validation:"},
			validateLocalFile[
				FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
				MatchQ[FileFormat[#], "PDF"] &
			],
			$Failed
		],
		Test["Function result is memoized:",
			validateLocalFile[
				FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
				ImageQ[Import[#]] &
			];

			AbsoluteTiming[
				validateLocalFile[
					FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
					ImageQ[Import[#]] &
				]
			],
			{LessP[0.001], _File}
		]
	},
	SymbolSetUp :> {
		DownloadCloudFile[
			EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard4/a9557e8d9b5ce7efacaa523b5e87b17a.png"],
			FileNameJoin[{$TemporaryDirectory, "testfile.png"}]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*pathToCloudFilePacket*)


DefineTests[pathToCloudFilePacket,
	{
		Example[{Basic, "Validate a local file, memoize the result and return the valid file:"},
			pathToCloudFilePacket[FileNameJoin[{$TemporaryDirectory, "testfile.png"}]],
			PacketP[]
		],
		Test["The packet generated is a valid upload:",
			pathToCloudFilePacket[FileNameJoin[{$TemporaryDirectory, "testfile.png"}]],
			_?ValidUploadQ
		],
		Test["Function result is memoized:",
			pathToCloudFilePacket[FileNameJoin[{$TemporaryDirectory, "testfile.png"}]];

			AbsoluteTiming[pathToCloudFilePacket[FileNameJoin[{$TemporaryDirectory, "testfile.png"}]]],
			{LessP[0.001], PacketP[]}
		]
	},
	SetUp :> {ClearMemoization[]},
	SymbolSetUp :> {
		DownloadCloudFile[
			EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard4/a9557e8d9b5ce7efacaa523b5e87b17a.png"],
			FileNameJoin[{$TemporaryDirectory, "testfile.png"}]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*indexToNamedMultiple*)
DefineTests[indexToNamedMultiple,
	{
		Test["Function converts an option value, which is in index-multiple format, into the correct named-multiple format as defined in field definition:",
			updatedOption = indexToNamedMultiple[{Positions -> {{"A1", Null, 1 Meter, 1 Meter, 1 Meter}}}, Model[Container]];
			Lookup[updatedOption, Positions],
			{AssociationMatchP[<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 1 Meter, MaxHeight -> 1 Meter |>]},
			Variables :> {updatedOption}
		],
		Test["Function do not change option values that are not defined as named-multiple fields in the type:",
			updatedOption = indexToNamedMultiple[{StoragePositions -> {{Null, "A1"}}}, Model[Container]];
			Lookup[updatedOption, StoragePositions],
			{{Null, "A1"}},
			Variables :> {updatedOption}
		],
		Test["Function works on a mixture of multiple index-multiple options and other options:",
			updatedOption = indexToNamedMultiple[
				{
					Positions -> {{"A1", Null, 1 Meter, 1 Meter, 1 Meter}},
					PositionPlotting -> {{"A1", 0 Meter, 0 Meter, 0 Meter, Circular, 0}, {"A2", 0 Meter, 1 Meter, 2 Meter, Circular, 4}},
					StoragePositions -> {{Null, "A1"}, {Null, Null}, {"123", "321"}},
					Name -> "test name"
				},
				Model[Container]
			];
			Lookup[updatedOption, {Positions, PositionPlotting, StoragePositions, Name}],
			{
				{AssociationMatchP[<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 1 Meter, MaxHeight -> 1 Meter |>]},
				{
					AssociationMatchP[<| Name -> "A1", XOffset -> 0 Meter, YOffset -> 0 Meter, ZOffset -> 0 Meter, CrossSectionalShape -> Circular, Rotation -> 0 |>],
					AssociationMatchP[<| Name -> "A2", XOffset -> 0 Meter, YOffset -> 1 Meter, ZOffset -> 2 Meter, CrossSectionalShape -> Circular, Rotation -> 4 |>]
				},
				{{Null, "A1"}, {Null, Null}, {"123", "321"}},
				"test name"
			},
			Variables :> {updatedOption}
		],
		Test["Function still works if one single layer of list is provided as value to an indexed-multiple option:",
			updatedOption = indexToNamedMultiple[{Positions -> {"A1", Null, 1 Meter, 1 Meter, 1 Meter}}, Model[Container]];
			Lookup[updatedOption, Positions],
			{AssociationMatchP[<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 1 Meter, MaxHeight -> 1 Meter |>]},
			Variables :> {updatedOption}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*generateChangePacket*)
DefineTests[generateChangePacket,
	{
		Test["Function generates a change packet based on resolved options:",
			generateChangePacket[Model[Container, Vessel], {Name -> "Test name for generateChangePacket"}],
			AssociationMatchP[<| Name -> "Test name for generateChangePacket", Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]
		],
		Test["In order to generate a packet that's ready to upload, either Type or Object must be present in the resolved option input:",
			generateChangePacket[Model[Container, Vessel], {Name -> "Test name for generateChangePacket", Type -> Model[Container]}],
			_?ValidUploadQ
		],
		Test["Options which values are Null, {} or Automatic will be excluded in the change packet:",
			generateChangePacket[Model[Container, Vessel], {Name -> "Test name for generateChangePacket", Dimensions -> {Null, Null, Null}, Positions -> Automatic, PositionPlotting -> {}}],
			AssociationMatchP[<| Name -> "Test name for generateChangePacket", Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]
		],
		Test["By default, all Multiple fields will be Replaced:",
			generateChangePacket[Model[Container, Vessel], {CoverFootprints -> {CapSnap7x6}}],
			AssociationMatchP[<| Replace[CoverFootprints] -> {CapSnap7x6}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]
		],
		Test["An optional Boolean 3rd input can be supplied, which determines multiple fields will be appended or replaced. If that Boolean is True, fields will be appended:",
			generateChangePacket[Model[Container, Vessel], {CoverFootprints -> {CapSnap7x6}, CoverTypes -> {Snap}}, True],
			AssociationMatchP[<| Append[CoverFootprints] -> {CapSnap7x6}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]}, Append[CoverTypes] -> {Snap} |>]
		],
		Test["The Append option can be supplied, in which case multiple fields present in the list will be appended, other multiple fields will be replaced:",
			generateChangePacket[Model[Container, Vessel], {CoverFootprints -> {CapSnap7x6}, CoverTypes -> {Snap}}, Append -> {CoverTypes}],
			AssociationMatchP[<| Replace[CoverFootprints] -> {CapSnap7x6}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]}, Append[CoverTypes] -> {Snap} |>]
		],
		Test["Function correctly converts index-multiple options into named-multiple fields:",
			generateChangePacket[Model[Container, Vessel], {Positions -> {{"A1", Null, 1 Meter, 1 Meter, 1 Meter}}}],
			AssociationMatchP[<| Replace[Positions] -> {AssociationMatchP[<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 1 Meter, MaxHeight -> 1 Meter |>]}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]
		],
		Test["Function correctly performs option pre-processing conversions from options into field values:",
			generateChangePacket[
				Object[Sample],
				{Composition -> {
					{99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{1 VolumePercent, Model[Molecule, "id:Y0lXejMq5qAa"]}
				}}
			],
			AssociationMatchP[
				<|
					Replace[Composition] -> {
						{EqualP[99 VolumePercent], Link[Model[Molecule, "id:vXl9j57PmP5D"]], RangeP[Now - 1 Minute, Now]},
						{EqualP[1 VolumePercent], Link[Model[Molecule, "id:Y0lXejMq5qAa"]], RangeP[Now - 1 Minute, Now]}
					}
				|>,
				AllowForeignKeys -> True
			]
		],
		Test["Function correctly performs custom conversions from options into field values:",
			generateChangePacket[Model[Sample], {NFPA -> {2, 4, 3, {Corrosive}}}],
			AssociationMatchP[<|NFPA -> {Health -> 2, Flammability -> 4, Reactivity -> 3, Special -> {Corrosive}}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]
		],
		Test["Fields in the resolved options that do not exist in the type definition will not be included:",
			packet = generateChangePacket[Model[Container, Vessel], {Name -> "Test name for generateChangePacket", Status -> Available}];
			Lookup[packet, Status, "Missing"],
			"Missing",
			Variables :> {packet}
		],
		Test["If Output -> {Packet, IrrelevantFields}, function will have a second output that lists all options which do not exist as field:",
			generateChangePacket[Model[Container, Vessel], {Name -> "Test name for generateChangePacket", Status -> Available}, Output -> {Packet, IrrelevantFields}],
			{_Association, {Status}}
		],
		Test["If Output -> {Packet, IrrelevantFields}, some common options like Upload, Cache won't present in the IrrelevantFields output:",
			generateChangePacket[Model[Container, Vessel], {Name -> "Test name for generateChangePacket", Status -> Available, Upload -> False, Output -> Result, Cache -> {}}, Output -> {Packet, IrrelevantFields}],
			{_Association, {Status}}
		]
	},
	Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"] (* "Test user for notebook-less test protocols" *)}
];

(* ::Subsubsection::Closed:: *)
(*formatFieldValue*)

DefineTests[formatFieldValue,
	{
		Test["Function do not change the value for a non-Link single field:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Name];
			formatFieldValue[Model[Container], Name, "test name", fieldDefinition],
			"test name"
		],
		Test["Function do not change the value for a non-Link multiple field:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Synonyms];
			formatFieldValue[Model[Container], Synonyms, "test name", fieldDefinition],
			"test name"
		],
		Test["Given an object, function will output a Link[object] as long as the field is a Link field:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Authors];
			formatFieldValue[Model[Container], Authors, Object[User, "id:n0k9mG8AXZP6"], fieldDefinition],
			Link[Object[User, "id:n0k9mG8AXZP6"]]
		],
		Test["If the linked field is expecting a bi-directional link, function can format that correctly:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Products];
			formatFieldValue[Model[Container], Products, {Object[Product, "id:xRO9n3Bwp1ox"]}, fieldDefinition],
			{Link[Object[Product, "id:xRO9n3Bwp1ox"], ProductModel]}
		],
		Test["If the linked field is expecting a bi-directional link with multiple arguments, function can format that correctly:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], SupportedContainers];
			formatFieldValue[Model[Container], SupportedContainers, {Model[Container, Vessel, "id:bq9LA0dBGGR6"]}, fieldDefinition],
			{Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], AssociatedAccessories, 1]}
		],
		Test["For a link field which links to Object[EmeraldCloudFile], if a local file path is provided, function will upload the cloud file and replace the option value with the newly uploaded file:",
			filePath = FileNameJoin[{$TemporaryDirectory, CreateUUID[] <> ".png"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/fc8c7b1c6117c373ca05e07786cc2608.jpg", ""], filePath];
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], ImageFile];
			formatFieldValue[Model[Container], ImageFile, filePath, fieldDefinition],
			LinkP[Object[EmeraldCloudFile]]
		],
		Test["For a named multiple field, if the input option value is written in index-multiple format, function will be able to interpret and correct that:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Positions];
			formatFieldValue[Model[Container], Positions, {{"A1", Null, 1Meter, 2Meter, 3Meter}}, fieldDefinition],
			{AssociationMatchP[<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 2 Meter, MaxHeight -> 3 Meter |>]}
		],
		Test["For a named multiple field, if the input option value is written in named-multiple format, function will be able to interpret and correct that:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Positions];
			formatFieldValue[Model[Container], Positions, {<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 2 Meter, MaxHeight -> 3 Meter |>}, fieldDefinition],
			{AssociationMatchP[<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 2 Meter, MaxHeight -> 3 Meter |>]}
		],
		Test["Function can wrap objects with Link[] for entries of index or named multiple fields:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], AssociatedAccessories];
			formatFieldValue[Model[Container], AssociatedAccessories, {Model[Container, Vessel, "id:bq9LA0dBGGR6"], 1}, fieldDefinition],
			{{Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], SupportedContainers], 1}}
		],
		Test["Function can auto upload cloud file from local file path for entries of index or named multiple fields:",
			filePath = FileNameJoin[{$TemporaryDirectory, CreateUUID[] <> ".png"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/fc8c7b1c6117c373ca05e07786cc2608.jpg", ""], filePath];
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], InstrumentSchematics];
			formatFieldValue[Model[Container], InstrumentSchematics, {filePath, "dummy caption"}, fieldDefinition],
			{{LinkP[Object[EmeraldCloudFile]], "dummy caption"}}
		],
		Test["Custom option pre-processing is implemented:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Object[Sample]], Fields], Composition];
			formatFieldValue[
				Object[Sample],
				Composition,
				{
					{99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{1 VolumePercent, Model[Molecule, "id:Y0lXejMq5qAa"]}
				},
				fieldDefinition
			],
			{
				{EqualP[99 VolumePercent], Link[Model[Molecule, "id:vXl9j57PmP5D"]], RangeP[Now - 1 Minute, Now]},
				{EqualP[1 VolumePercent], Link[Model[Molecule, "id:Y0lXejMq5qAa"]], RangeP[Now - 1 Minute, Now]}
			}
		],
		Test["Custom option conversions are implemented:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Sample]], Fields], NFPA];
			formatFieldValue[Model[Sample], NFPA, {1, 2, 3, {WaterReactive}}, fieldDefinition],
			{Health -> 1, Flammability -> 2, Reactivity -> 3, Special -> {WaterReactive}}
		],
		Test["Indexed Single fields are converted correctly:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Item, Column]], Fields], Dimensions];
			formatFieldValue[Model[Item, Column], Dimensions, {1 Centimeter, 1 Centimeter, 10 Centimeter}, fieldDefinition],
			{1 Centimeter, 1 Centimeter, 10 Centimeter}
		]
	},
	Variables :> {fieldDefinition, filePath}
];


(* ::Subsubsection::Closed:: *)
(*translateCustomOptionValue*)
DefineTests[translateCustomOptionValue,
	{
		Test["Converts the NFPA option to a valid field value:",
			translateCustomOptionValue[NFPA, {1, 2, 3, {Oxidizer}}],
			{Health -> 1, Flammability -> 2, Reactivity -> 3, Special -> {Oxidizer}}
		],
		Test["NFPA option Null list of specials is converted to an empty list:",
			translateCustomOptionValue[NFPA, {2, 3, 4, Null}],
			{Health -> 2, Flammability -> 3, Reactivity -> 4, Special -> {}}
		],
		Test["NFPA option empty list of specials is converted to an empty list:",
			translateCustomOptionValue[NFPA, {4, 3, 2, {}}],
			{Health -> 4, Flammability -> 3, Reactivity -> 2, Special -> {}}
		],
		Test["ExtinctionCoefficients option has pseudo-headers added:",
			translateCustomOptionValue[
				ExtinctionCoefficients,
				{
					{260 Nanometer, 144900 Liter / (Centimeter Mole)},
					{300 Nanometer, 170000 Liter / (Centimeter Mole)}
				}
			],
			{
				<|Wavelength -> EqualP[260 Nanometer], ExtinctionCoefficient -> EqualP[144900 Liter / (Centimeter Mole)]|>,
				<|Wavelength -> EqualP[300 Nanometer], ExtinctionCoefficient -> EqualP[170000 Liter / (Centimeter Mole)]|>
			}
		],
		Test["An option without custom conversion is passed through unchanged:",
			translateCustomOptionValue[OpticalComposition, {{50 Percent, Link[Model[Sample, "id:8qZ1VWNmdLBD"]]}}],
			{{50 Percent, Link[Model[Sample, "id:8qZ1VWNmdLBD"]]}}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*preProcessOptionValue*)
DefineTests[preProcessOptionValue,
	{
		Test["Adds upload dates to Object[Sample][Composition] if missing:",
			preProcessOptionValue[
				Object[Sample],
				Composition,
				{
					{99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{1 VolumePercent, Model[Molecule, "id:Y0lXejMq5qAa"]}
				}
			],
			{
				{EqualP[99 VolumePercent], Model[Molecule, "id:vXl9j57PmP5D"], RangeP[Now - 1 Minute, Now]},
				{EqualP[1 VolumePercent], Model[Molecule, "id:Y0lXejMq5qAa"], RangeP[Now - 1 Minute, Now]}
			}
		],
		Test["Object[Sample][Composition] is unchanged if dates are already present:",
			preProcessOptionValue[
				Object[Sample],
				Composition,
				{
					{99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"], DateObject[{2025, 1, 1, 0, 0, 0}]},
					{1 VolumePercent, Model[Molecule, "id:Y0lXejMq5qAa"], DateObject[{2025, 1, 1, 0, 0, 0}]}
				}
			],
			{
				{EqualP[99 VolumePercent], Model[Molecule, "id:vXl9j57PmP5D"], EqualP[DateObject[{2025, 1, 1, 0, 0, 0}]]},
				{EqualP[1 VolumePercent], Model[Molecule, "id:Y0lXejMq5qAa"], EqualP[DateObject[{2025, 1, 1, 0, 0, 0}]]}
			}
		],
		Test["Other fields are unchanged:",
			preProcessOptionValue[
				Model[Sample],
				Composition,
				{
					{99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{1 VolumePercent, Model[Molecule, "id:Y0lXejMq5qAa"]}
				}
			],
			{
				{EqualP[99 VolumePercent], Model[Molecule, "id:vXl9j57PmP5D"]},
				{EqualP[1 VolumePercent], Model[Molecule, "id:Y0lXejMq5qAa"]}
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*InstallDefaultUploadFunction*)


DefineTests[InstallDefaultUploadFunction,
	(* These tests verify that InstallDefaultUploadFunction is creating reasonable DownValues *)
	(* Validity testing of the actual code generated is best done by the unit tests of actual functions generated using the framework *)
	{
		Example[{Basic, "Generate a generic upload function for Model[Sample] with name 'installDefaultUploadFunctionTestFunction':"},
			InstallDefaultUploadFunction[installDefaultUploadFunctionTestFunction, Model[Sample]];
			DownValues[installDefaultUploadFunctionTestFunction],
			Except[{}],
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction]
			}
		],
		Example[{Options, OptionResolver, "Generate an upload function for Model[Sample] with name 'installDefaultUploadFunctionTestFunction2' that uses a custom option resolver:"},
			InstallDefaultUploadFunction[
				installDefaultUploadFunctionTestFunction2,
				Model[Sample],
				OptionResolver -> installDefaultUploadFunctionOptionResolver2
			];
			DownValues[installDefaultUploadFunctionTestFunction2],
			Except[{}],
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction2]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction2]
			}
		],
		Example[{Options, AuxilliaryPacketsFunction, "Generate an upload function for Model[Sample] with name 'installDefaultUploadFunctionTestFunction3' that uses a custom option resolver and auxilliary packet function:"},
			InstallDefaultUploadFunction[
				installDefaultUploadFunctionTestFunction3,
				Model[Sample],
				OptionResolver -> installDefaultUploadFunctionOptionResolver3,
				AuxilliaryPacketsFunction -> installDefaultUploadFunctionAuxilliaryPacketsFunction3
			];
			DownValues[installDefaultUploadFunctionTestFunction3],
			Except[{}],
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction3]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction3]
			}
		],
		Example[{Additional, "Usage is also defined:"},
			InstallDefaultUploadFunction[installDefaultUploadFunctionTestFunction4, Model[Sample]];
			Usage[installDefaultUploadFunctionTestFunction4],
			Except[{}],
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction4]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction4]
			}
		],
		Example[{Additional, "Tests are not defined and must be created separately:"},
			InstallDefaultUploadFunction[installDefaultUploadFunctionTestFunction5, Model[Sample]];
			Tests[installDefaultUploadFunctionTestFunction5],
			{},
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction5]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction5]
			}
		],
		Example[{Options, InstallNameOverload, "Allow string inputs to the upload function which sets the name of an uploaded object:"},
			InstallDefaultUploadFunction[
				installDefaultUploadFunctionTestFunction6,
				Model[Sample],
				InstallNameOverload -> True,
				InstallObjectOverload -> False
			];
			DownValues[installDefaultUploadFunctionTestFunction6],
			Except[{}],
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction6]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction6]
			}
		],
		Example[{Options, InstallObjectOverload, "Allow existing objects as inputs to the upload function, for modifying the existing object:"},
			InstallDefaultUploadFunction[
				installDefaultUploadFunctionTestFunction7,
				Model[Sample],
				InstallObjectOverload -> True,
				InstallNameOverload -> False
			];
			DownValues[installDefaultUploadFunctionTestFunction7],
			Except[{}],
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction7]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction7]
			}
		],
		Test["Two overloads are defined - one listable and the other singleton:",
			InstallDefaultUploadFunction[installDefaultUploadFunctionTestFunction8, Model[Sample]];
			DownValues[installDefaultUploadFunctionTestFunction8],
			_?(And[
				MemberQ[#,
					(* Pattern for singleton input definition *)
					Verbatim[HoldPattern][installDefaultUploadFunctionTestFunction8[input_ : Except[_List], options_]],
					Infinity
				],
				MemberQ[#,
					(* Pattern for listed input definition *)
					Verbatim[HoldPattern][installDefaultUploadFunctionTestFunction8[input_ : _List, options_]],
					Infinity
				]
			]&),
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction8]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction8]
			}
		],
		Test["By default, resolveDefaultUploadFunctionOptions is used as option resolver:",
			InstallDefaultUploadFunction[installDefaultUploadFunctionTestFunction9, Model[Sample]];
			DownValues[installDefaultUploadFunctionTestFunction9],
			_?(MemberQ[#,
				_resolveDefaultUploadFunctionOptions,
				Infinity
				]&),
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction9]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction9]
			}
		],
		Test["If a custom option resolver is specified, it is used in place of the default:",
			InstallDefaultUploadFunction[
				installDefaultUploadFunctionTestFunction10,
				Model[Sample],
				OptionResolver -> installDefaultUploadFunctionOptionResolver10
			];
			DownValues[installDefaultUploadFunctionTestFunction10],
			_?(And[
				MemberQ[#,
					_installDefaultUploadFunctionOptionResolver10,
					Infinity
				],
				!MemberQ[#,
					_resolveDefaultUploadFunctionOptions,
					Infinity
				]
			]&),
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction10]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction10]
			}
		],
		Test["If an auxilliary packet function is specified, it is used:",
			InstallDefaultUploadFunction[
				installDefaultUploadFunctionTestFunction11,
				Model[Sample],
				OptionResolver -> installDefaultUploadFunctionOptionResolver11,
				AuxilliaryPacketsFunction -> installDefaultUploadFunctionAuxilliaryPacketsFunction11
			];
			DownValues[installDefaultUploadFunctionTestFunction11],
			_?(And[
				MemberQ[#,
					_installDefaultUploadFunctionAuxilliaryPacketsFunction11,
					Infinity
				],
				!MemberQ[#,
					_generateDefaultUploadFunctionAuxilliaryPackets,
					Infinity
				]
			]&),
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction11]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction11]
			}
		]
	}
];