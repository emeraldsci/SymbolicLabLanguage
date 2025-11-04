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
		Example[{Basic, "Returns 400 HTTP response code if the PubChem ID provided is invalid:"},
			parsePubChem[PubChem[1.1]],
			400
		],
		Example[{Additional, "Identifiers", "The name of the compound is parsed:"},
			Lookup[parsePubChem[PubChem[2519]], Name], (* Caffeine *)
			"Caffeine"
		],
		Example[{Additional, "Identifiers", "Synonyms of the compound name are parsed:"},
			Lookup[parsePubChem[PubChem[2519]], Synonyms], (* Caffeine *)
			{"Caffeine", "1,3,7-Trimethylxanthine", "Caffedrine", "Dexitac","Durvitan", "Vivarin"}
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
(*parseChemicalIdentifier*)

DefineTests[
	parseChemicalIdentifier,
	{
		(* Integration test - this will hit the API *)
		Example[{Basic, "Scrape data for a molecule from PubChem using a molecule object:"},
			parseChemicalIdentifier[Molecule["caffeine"]],
			caffeineDataP
		],
		(* Integration test - this will hit the API *)
		Example[{Basic, "Scrape data for a molecule from PubChem using an InChI identifier:"},
			parseChemicalIdentifier["InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"],
			caffeineDataP
		],
		(* Integration test - this will hit the API *)
		Example[{Additional, "Scrape data for a molecule from PubChem using an InChIKey identifier:"},
			parseChemicalIdentifier["RYYVLZVUVIJVGH-UHFFFAOYSA-N"],
			caffeineDataP
		],
		(* Integration test - this will hit the API *)
		Example[{Additional, "Scrape data for a molecule from PubChem using a CAS number identifier:"},
			parseChemicalIdentifier["58-08-2"],
			caffeineDataP
		],
		(* Integration test - this will hit the API *)
		Example[{Additional, "Scrape data for a molecule from PubChem using a name:"},
			parseChemicalIdentifier["caffeine"],
			caffeineDataP
		],
		(* Integration test - this will hit the API *)
		Example[{Additional, "Returns a 404 status code if a compound cannot be found with a given name:"},
			parseChemicalIdentifier["EmeraldCloudLabium"],
			404 (* Not Found *)
		],
		(* Integration test - this will hit the API *)
		Example[{Additional, "Returns a 400 status code if a an invalid InChI is provided:"},
			parseChemicalIdentifier["InChI=1S/C188H100N300O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"],
			400 (* Bad request - InChI are structural identifiers, so PubChem will understand any valid InChI and return empty data if necessary. *)
			(* Any invalid InChI is therefore considered a bad request rather than the data being missing *)
		],
		(* Integration test - this will hit the API *)
		Example[{Additional, "Returns a 404 status code if a compound cannot be found with a given InChIKey:"},
			parseChemicalIdentifier["XXXXXXXXXXXXXY-XXXXXXX0XX-N"],
			404 (* Not Found - InChIKeys are hashes of InChI, so are no longer structural identifiers and it's unclear if it represents a valid structure on not. *)
			(* PubChem therefore returns a not found error if it can't find a record for the InChIKey *)
		],
		(* Integration test - this will hit the API *)
		Example[{Additional, "Returns a 404 status code if a compound cannot be found with a given CAS:"},
			parseChemicalIdentifier["0000000-00-0"],
			404 (* Not Found *)
		]
	},
	SetUp :> {
		(* Avoid hitting the API too fast *)
		ClearMemoization[],
		Pause[5]
	}
];

(* ::Subsubsection::Closed:: *)
(*parseThermoURL*)

DefineTests[
	parseThermoURL,
	{
		(* Integration test - this will hit the API *)
		Example[{Basic, "Scrape information from a ThermoFisher webpage:"},
			parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"],
			caffeineDataP
		],
		(* Integration test - this will hit the API *)
		Example[{Basic, "Return 404 when the URL is invalid:"},
			parseThermoURL["https://www.thermofisher.com/order/catalog/product/testproduct"],
			404
		]
	},
	SetUp :> {
		(* Avoid hitting the API too fast *)
		ClearMemoization[],
		Pause[5]
	}
];

(* ::Subsubsection::Closed:: *)
(*parseSigmaURL*)

DefineTests[
	parseSigmaURL,
	{
		(* Integration test - this will hit the API *)
		Example[{Basic, "Scrape information from a Millipore-Sigma webpage:"},
			parseSigmaURL["https://www.sigmaaldrich.com/US/en/substance/caffeine1941958082"],
			caffeineDataP
		],
		(* Integration test - this will hit the API *)
		Example[{Basic, "Return 404 when the URL is invalid:"},
			parseSigmaURL["https://www.sigmaaldrich.com/US/en/substance/caffeinezzz"],
			404
		]
	},
	SetUp :> {
		(* Avoid hitting the API too fast *)
		ClearMemoization[],
		Pause[5]
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
		],
		Test["Function result is memoized:",
			findSDS["58-08-2", Output -> URL];

			AbsoluteTiming[findSDS["58-08-2", Output -> URL]],
			{LessP[0.01], URLP}
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
		Example[{Basic, "Specify the object type and field that the file will be uploaded to to automatically select the validation function:"},
			downloadAndValidateURL[
				"https://pubchem.ncbi.nlm.nih.gov/image/imagefly.cgi?cid=702&width=500&height=500",
				Model[Molecule],
				StructureImageFile
			],
			_File
		],
		Example[{Basic, "Download and memoize the file without validation:"},
			downloadAndValidateURL[
				"www.emeraldcloudlab.com/",
				"site.pdf"
			],
			_File
		],
		Example[{Additional, "Validate a file using a standard validation function:"},
			downloadAndValidateURL[
				"https://www.emeraldcloudlab.com/static/bg-about-mission-ea377839c069a8ca98cfb84a93648459.jpg",
				"image.jpg",
				validateImageFile
			],
			_File
		],
		Example[{Additional, "Returns $Failed if the URL is invalid even if there is no provided validation function:"},
			downloadAndValidateURL[
				"https://",
				"image.jpg"
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
			{LessP[0.01], _File}
		],
		Test["Function result is memoized when using field input format:",
			downloadAndValidateURL[
				"https://pubchem.ncbi.nlm.nih.gov/image/imagefly.cgi?cid=702&width=500&height=500",
				Model[Molecule],
				StructureImageFile
			];

			AbsoluteTiming[
				downloadAndValidateURL[
					"https://pubchem.ncbi.nlm.nih.gov/image/imagefly.cgi?cid=702&width=500&height=500",
					Model[Molecule],
					StructureImageFile
				]
			],
			{LessP[0.01], _File}
		]
	},
	SetUp :> {ClearMemoization[]}
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
		Example[{Basic, "Specify the object type and field that the file will be uploaded to to automatically select the validation function:"},
			validateLocalFile[
				FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
				Model[Molecule],
				StructureImageFile
			],
			_File
		],
		Example[{Additional, "Validate a file using a standard validation function:"},
			validateLocalFile[
				FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
				validateImageFile
			],
			_File
		],
		Example[{Additional, "Returns $Failed if the file doesn't exist:"},
			validateLocalFile[
				FileNameJoin[{$TemporaryDirectory, "notarealfile.png"}],
				validateImageFile
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
			{LessP[0.01], _File}
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
(*selectFileValidationFunction*)
(* These tests are to ensure we don't break any relations relied upon by up functions, such as those essential for UploadMolecule *)
DefineTests[selectFileValidationFunction,
	{
		Test["Model[Molecule][MSDSFile] returns validateSDS:",
			selectFileValidationFunction[Model[Molecule], MSDSFile],
			validateSDS
		],
		Test["Model[Molecule] subtypes return validateSDS for MSDSFile:",
			selectFileValidationFunction[Model[Molecule, Oligomer], MSDSFile],
			validateSDS
		],
		Test["MSDSFile returns validateSDS for all types:",
			selectFileValidationFunction[All, MSDSFile],
			validateSDS
		],
		Test["StructureFile field returns validateChemicalStructureFile:",
			selectFileValidationFunction[All, StructureFile],
			validateChemicalStructureFile
		],
		Test["StructureImageFile field returns validateImageFile:",
			selectFileValidationFunction[All, StructureImageFile],
			validateImageFile
		],
		Test["Unlisted field returns True &:",
			selectFileValidationFunction[Model[Container], UnknownField],
			True &
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
			{LessP[0.01], PacketP[]}
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
(*generateChangePackets*)
DefineTests[generateChangePackets,
	{
		Test["Function generates change packets based on resolved options:",
			generateChangePackets[Model[Container, Vessel], {Name -> "Test name for generateChangePackets"}],
			{AssociationMatchP[<| Name -> "Test name for generateChangePackets", Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]}
		],
		Test["In order to generate packets that are ready to upload, either Type or Object must be present in the resolved option input:",
			generateChangePackets[Model[Container, Vessel], {Name -> "Test name for generateChangePackets", Type -> Model[Container]}],
			_?ValidUploadQ
		],
		Test["Options which values are Null, {} or Automatic will be excluded in the change packet:",
			generateChangePackets[Model[Container, Vessel], {Name -> "Test name for generateChangePackets", Dimensions -> {Null, Null, Null}, Positions -> Automatic, PositionPlotting -> {}}],
			{AssociationMatchP[<| Name -> "Test name for generateChangePackets", Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]}
		],
		Test["By default, all Multiple fields will be Replaced:",
			generateChangePackets[Model[Container, Vessel], {CoverFootprints -> {CapSnap7x6}}],
			{AssociationMatchP[<| Replace[CoverFootprints] -> {CapSnap7x6}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]}
		],
		Test["An optional Boolean 3rd input can be supplied, which determines multiple fields will be appended or replaced. If that Boolean is True, fields will be appended:",
			generateChangePackets[Model[Container, Vessel], {CoverFootprints -> {CapSnap7x6}, CoverTypes -> {Snap}}, True],
			{AssociationMatchP[<| Append[CoverFootprints] -> {CapSnap7x6}, Append[Authors] -> LinkP[Object[User, "id:n0k9mG8AXZP6"]], Append[CoverTypes] -> {Snap} |>]}
		],
		Test["The Append option can be supplied, in which case multiple fields present in the list will be appended, other multiple fields will be replaced:",
			generateChangePackets[Model[Container, Vessel], {CoverFootprints -> {CapSnap7x6}, CoverTypes -> {Snap}}, Append -> {CoverTypes}],
			{AssociationMatchP[<| Replace[CoverFootprints] -> {CapSnap7x6}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]}, Append[CoverTypes] -> {Snap} |>]}
		],
		Test["Function correctly converts index-multiple options into named-multiple fields:",
			generateChangePackets[Model[Container, Vessel], {Positions -> {{"A1", Null, 1 Meter, 1 Meter, 1 Meter}}}],
			{AssociationMatchP[<| Replace[Positions] -> {AssociationMatchP[<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 1 Meter, MaxHeight -> 1 Meter |>]}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]}
		],
		Test["Function correctly performs option pre-processing conversions from options into field values:",
			generateChangePackets[
				Object[Sample],
				{Composition -> {
					{99 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]},
					{1 VolumePercent, Model[Molecule, "id:Y0lXejMq5qAa"]}
				}}
			],
			{
				AssociationMatchP[
					<|
						Replace[Composition] -> {
							{EqualP[99 VolumePercent], Link[Model[Molecule, "id:vXl9j57PmP5D"]], RangeP[Now - 1 Minute, Now]},
							{EqualP[1 VolumePercent], Link[Model[Molecule, "id:Y0lXejMq5qAa"]], RangeP[Now - 1 Minute, Now]}
						}
					|>,
					AllowForeignKeys -> True
				]
			}
		],
		Test["Function correctly performs custom conversions from options into field values:",
			generateChangePackets[Model[Sample], {NFPA -> {2, 4, 3, {Corrosive}}}],
			{AssociationMatchP[<|NFPA -> {Health -> 2, Flammability -> 4, Reactivity -> 3, Special -> {Corrosive}}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]}
		],
		Test["Fields in the resolved options that do not exist in the type definition will not be included:",
			packet = First[generateChangePackets[Model[Container, Vessel], {Name -> "Test name for generateChangePackets", Status -> Available}]];
			Lookup[packet, Status, "Missing"],
			"Missing",
			Variables :> {packet}
		],
		Test["If Output -> {Packet, IrrelevantFields}, function will have a second output that lists all options which do not exist as field:",
			generateChangePackets[Model[Container, Vessel], {Name -> "Test name for generateChangePackets", Status -> Available}, Output -> {Packet, IrrelevantFields}],
			{{_Association}, {Status}}
		],
		Test["If Output -> {Packet, IrrelevantFields}, some common options like Upload, Cache won't present in the IrrelevantFields output:",
			generateChangePackets[Model[Container, Vessel], {Name -> "Test name for generateChangePackets", Status -> Available, Upload -> False, Output -> Result, Cache -> {}}, Output -> {Packet, IrrelevantFields}],
			{{_Association}, {Status}}
		],
		Test["If a URL is present in a cloud file field, the contents are downloaded, validated, uploaded to AWS and cloud file packets are returned in addition to the primary packet by this function:",
			generateChangePackets[Model[Molecule], {MSDSFile -> "https://cdn.caymanchem.com/cdn/msds/14118m.pdf"}],
			{
				(* Primary packet *)
				AssociationMatchP[<|MSDSFile -> LinkP[Object[EmeraldCloudFile]], Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]}|>],
				(* Cloud file packet(s) *)
				AssociationMatchP[<|Object -> ObjectReferenceP[Object[EmeraldCloudFile]], FileType -> "pdf", CloudFile -> EmeraldCloudFileP|>, AllowForeignKeys -> True]
			}
		],
		Test["If the contents of a URL fail download or validation, $Failed is returned for that option:",
			generateChangePackets[Model[Molecule], {MSDSFile -> "www.emeraldcloudlab.com"}],
			{
				(* Primary packet *)
				AssociationMatchP[<|MSDSFile -> $Failed, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]}|>]
				(* No cloud file packet(s) *)
			}
		],
		Test["If a local file is present in a cloud file field, the contents are validated, uploaded to AWS and cloud file packets are returned in addition to the primary packet by this function:",
			generateChangePackets[Model[Molecule], {MSDSFile -> FileNameJoin[{tempDirectory, "generatechangepackettestpdf.pdf"}]}],
			{
				(* Primary packet *)
				AssociationMatchP[<|MSDSFile -> LinkP[Object[EmeraldCloudFile]], Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]}|>],
				(* Cloud file packet(s) *)
				AssociationMatchP[<|Object -> ObjectReferenceP[Object[EmeraldCloudFile]], FileType -> "pdf", CloudFile -> EmeraldCloudFileP|>, AllowForeignKeys -> True]
			}
		],
		Test["If the contents of a local file fail validation, $Failed is returned for that option:",
			generateChangePackets[Model[Molecule], {MSDSFile -> FileNameJoin[{tempDirectory, "generatechangepackettestnotpdf.pdf"}]}],
			{
				(* Primary packet *)
				AssociationMatchP[<|MSDSFile -> $Failed, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]}|>]
				(* No cloud file packet(s) *)
			}
		],
		Test["Empty options returns a basic change packet:",
			generateChangePackets[Model[Container, Vessel], {}],
			{_Association}
		],
		Test["If URLs are present in cloud file fields, the downloaded and validated file is memoized:",
			generateChangePackets[Model[Molecule], {MSDSFile -> "https://cdn.caymanchem.com/cdn/msds/14118m.pdf"}];

			AbsoluteTiming[
				generateChangePackets[Model[Molecule], {MSDSFile -> "https://cdn.caymanchem.com/cdn/msds/14118m.pdf"}]
			],
			{LessP[0.01], {_Association..}}
		],
		Test["Does not null out {{Null, Null}} for composition:",
			generateChangePackets[Model[Sample], {Composition -> {{Null, Null}}}],
			{AssociationMatchP[<| Replace[Composition] -> {{Null, Null}}, Replace[Authors] -> {LinkP[Object[User, "id:n0k9mG8AXZP6"]]} |>]}
		]
	},
	Stubs :> {$PersonID = Object[User, "id:n0k9mG8AXZP6"] (* "Test user for notebook-less test protocols" *)},
	Variables :> {tempDirectory},
	SymbolSetUp :> {
		Module[
			{testFileLookup},

			(* Create a temp directory *)
			tempDirectory = FileNameJoin[{$TemporaryDirectory, "generateChangePackets"}];
			CreateDirectory[tempDirectory];

			(* Which files to create *)
			testFileLookup = {
				<|Name -> "generatechangepackettestpdf.pdf", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard15/6dac37b031347eb5a7c6514d4dbfa9c4.pdf"]|>,
				<|Name -> "generatechangepackettestnotpdf.pdf", CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard2/8c0ac0fd305b4d6da8bd8a70f43cf0dd.pdf"]|>
			};

			(* Create the files *)
			Map[
				DownloadCloudFile[Lookup[#, CloudFile], FileNameJoin[{tempDirectory, Lookup[#, Name]}]] &,
				testFileLookup
			]

		]
	},
	SymbolTearDown :> {
		DeleteDirectory[tempDirectory, DeleteContents -> True]
	}
];



(* ::Subsubsection::Closed:: *)
(*stripChangePacket*)
DefineTests[stripChangePacket,
	{
		Example[{Basic, "Reformat a change packet as though it has been downloaded from Constellation:"},
			stripChangePacket[
				<|
					Type -> Model[Molecule],
					Name -> "Test Molecule",
					Replace[Synonyms] -> {"Test Molecule"}
				|>
			],
			AssociationMatchP[
				<|
					Type -> Model[Molecule],
					Name -> "Test Molecule",
					Synonyms -> {"Test Molecule"}
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Example[{Options, ExistingPacket, "Merge the change packet with an object packet from Constellation, with the change packet values superseding those in the existing packet:"},
			stripChangePacket[
				<|
					Type -> Model[Molecule],
					Name -> "Test Molecule",
					Replace[Synonyms] -> {"Test Molecule"}
				|>,
				ExistingPacket -> <|
					Name -> "Old name",
					Base -> True,
					Flammable -> True
				|>
			],
			AssociationMatchP[
				<|
					Type -> Model[Molecule],
					Name -> "Test Molecule",
					Synonyms -> {"Test Molecule"},
					Base -> True,
					Flammable -> True
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Example[{Additional, "Fields not present in the packets are added with Null/{} contents:"},
			stripChangePacket[
				<|
					Type -> Model[Molecule],
					Name -> "Test Molecule",
					Replace[Synonyms] -> {"Test Molecule"}
				|>,
				ExistingPacket -> <|
					Name -> "Old name",
					Base -> True,
					Flammable -> True
				|>
			],
			AssociationMatchP[
				<|
					AffinityLabel -> Null,
					AffinityLabels -> {},
					MolecularFormula -> Null,
					MeltingPoint -> Null,
					pKa -> {},
					Viscosity -> Null
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Example[{Additional, "Replace, Append and Transfer field modifiers are stripped:"},
			stripChangePacket[
				<|
					Type -> Model[Molecule],
					Name -> "Test Molecule",
					Replace[Synonyms] -> {"Test Molecule"},
					Append[pKa] -> {10.1},
					Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "id:aXRlGn6oO5kv"], Objects]
				|>
			],
			AssociationMatchP[
				<|
					Type -> Model[Molecule],
					Name -> "Test Molecule",
					Synonyms -> {"Test Molecule"},
					pKa -> {10.1},
					Notebook -> Link[Object[LaboratoryNotebook, "id:aXRlGn6oO5kv"], Objects]
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Test["Field modifiers are not stripped from the ExistingPacket, which is assumed to already be in download format:",
			stripChangePacket[
				<|
					Type -> Model[Molecule],
					Name -> "Test Molecule"
				|>,
				ExistingPacket -> <|
					Replace[Synonyms] -> {"Test Molecule"},
					Append[pKa] -> {10.1},
					Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "id:aXRlGn6oO5kv"], Objects]
				|>
			],
			AssociationMatchP[
				<|
					Type -> Model[Molecule],
					Name -> "Test Molecule",
					Replace[Synonyms] -> {"Test Molecule"},
					Append[pKa] -> {10.1},
					Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "id:aXRlGn6oO5kv"], Objects]
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*formatFieldValue*)

DefineTests[formatFieldValue,
	{
		Test["Function do not change the value for a non-Link single field:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Name];
			formatFieldValue[Model[Container], Name, "test name", fieldDefinition],
			{"test name", {}}
		],
		Test["Function do not change the value for a non-Link multiple field:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Synonyms];
			formatFieldValue[Model[Container], Synonyms, "test name", fieldDefinition],
			{"test name", {}}
		],
		Test["Given an object, function will output a Link[object] as long as the field is a Link field:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Authors];
			formatFieldValue[Model[Container], Authors, Object[User, "id:n0k9mG8AXZP6"], fieldDefinition],
			{Link[Object[User, "id:n0k9mG8AXZP6"]], {}}
		],
		Test["If the linked field is expecting a bi-directional link, function can format that correctly:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Products];
			formatFieldValue[Model[Container], Products, {Object[Product, "id:xRO9n3Bwp1ox"]}, fieldDefinition],
			{{Link[Object[Product, "id:xRO9n3Bwp1ox"], ProductModel]}, {}}
		],
		Test["If the linked field is expecting a bi-directional link with multiple arguments, function can format that correctly:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], SupportedContainers];
			formatFieldValue[Model[Container], SupportedContainers, {Model[Container, Vessel, "id:bq9LA0dBGGR6"]}, fieldDefinition],
			{{Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], AssociatedAccessories, 1]}, {}}
		],
		Test["For a link field which links to Object[EmeraldCloudFile], if a local file path is provided, function will upload the cloud file to AWS, replace the option value with the newly uploaded file and return the upload packet:",
			filePath = FileNameJoin[{$TemporaryDirectory, CreateUUID[] <> ".png"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/fc8c7b1c6117c373ca05e07786cc2608.jpg", ""], filePath];
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], ImageFile];
			formatFieldValue[Model[Container], ImageFile, filePath, fieldDefinition],
			{
				LinkP[Object[EmeraldCloudFile]],
				{AssociationMatchP[<|Object -> ObjectReferenceP[Object[EmeraldCloudFile]], FileType -> "png", CloudFile -> EmeraldCloudFileP|>, AllowForeignKeys -> True]}
			}
		],
		Test["For a multiple link field, which links to Object[EmeraldCloudFile], mixed inputs can be provided and result in a list of cloud file links:",
			filePath = FileNameJoin[{$TemporaryDirectory, CreateUUID[] <> ".png"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/fc8c7b1c6117c373ca05e07786cc2608.jpg", ""], filePath];
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], ProductDocumentationFiles];
			formatFieldValue[
				Model[Container],
				ProductDocumentationFiles,
				{
					filePath,
					Object[EmeraldCloudFile, "Test CloudFile for formatFieldValue unit tests " <> $SessionUUID]
				},
				fieldDefinition
			],
			{
				{
					LinkP[Object[EmeraldCloudFile]],
					LinkP[Object[EmeraldCloudFile]]
				},
				{AssociationMatchP[<|Object -> ObjectReferenceP[Object[EmeraldCloudFile]], FileType -> "png", CloudFile -> EmeraldCloudFileP|>, AllowForeignKeys -> True]}
			},
			SetUp :> {
				Quiet[Upload[<|Type -> Object[EmeraldCloudFile], Name -> "Test CloudFile for formatFieldValue unit tests " <> $SessionUUID, CloudFile -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/fc8c7b1c6117c373ca05e07786cc2608.jpg", ""]|>]]
			},
			TearDown :> {
				Quiet[EraseObject[Object[EmeraldCloudFile, "Test CloudFile for formatFieldValue unit tests " <> $SessionUUID], Force -> True, Verbose -> False]]
			}
		],
		Test["For a named multiple field, if the input option value is written in index-multiple format, function will be able to interpret and correct that:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Positions];
			formatFieldValue[Model[Container], Positions, {{"A1", Null, 1Meter, 2Meter, 3Meter}}, fieldDefinition],
			{{AssociationMatchP[<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 2 Meter, MaxHeight -> 3 Meter |>]}, {}}
		],
		Test["For a named multiple field, if the input option value is written in named-multiple format, function will be able to interpret and correct that:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], Positions];
			formatFieldValue[Model[Container], Positions, {<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 2 Meter, MaxHeight -> 3 Meter |>}, fieldDefinition],
			{{AssociationMatchP[<| Name -> "A1", Footprint -> Null, MaxWidth -> 1 Meter, MaxDepth -> 2 Meter, MaxHeight -> 3 Meter |>]}, {}}
		],
		Test["Function can wrap objects with Link[] for entries of index or named multiple fields:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], AssociatedAccessories];
			formatFieldValue[Model[Container], AssociatedAccessories, {Model[Container, Vessel, "id:bq9LA0dBGGR6"], 1}, fieldDefinition],
			{{{Link[Model[Container, Vessel, "id:bq9LA0dBGGR6"], SupportedContainers], 1}}, {}}
		],
		Test["Function can auto upload cloud file from local file path for entries of index or named multiple fields:",
			filePath = FileNameJoin[{$TemporaryDirectory, CreateUUID[] <> ".png"}];
			DownloadCloudFile[EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard1/fc8c7b1c6117c373ca05e07786cc2608.jpg", ""], filePath];
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Container]], Fields], InstrumentSchematics];
			formatFieldValue[Model[Container], InstrumentSchematics, {filePath, "dummy caption"}, fieldDefinition],
			{
				{
					{LinkP[Object[EmeraldCloudFile]], "dummy caption"}
				},
				{
					AssociationMatchP[<|Object -> ObjectReferenceP[Object[EmeraldCloudFile]], FileType -> "png", CloudFile -> EmeraldCloudFileP|>, AllowForeignKeys -> True]
				}
			}
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
				{
					{EqualP[99 VolumePercent], Link[Model[Molecule, "id:vXl9j57PmP5D"]], RangeP[Now - 1 Minute, Now]},
					{EqualP[1 VolumePercent], Link[Model[Molecule, "id:Y0lXejMq5qAa"]], RangeP[Now - 1 Minute, Now]}
				},
				{}
			}
		],
		Test["Custom option conversions are implemented:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Sample]], Fields], NFPA];
			formatFieldValue[Model[Sample], NFPA, {1, 2, 3, {WaterReactive}}, fieldDefinition],
			{{Health -> 1, Flammability -> 2, Reactivity -> 3, Special -> {WaterReactive}}, {}}
		],
		Test["Indexed Single fields are converted correctly:",
			fieldDefinition = Lookup[Lookup[LookupTypeDefinition[Model[Item, Column]], Fields], Dimensions];
			formatFieldValue[Model[Item, Column], Dimensions, {1 Centimeter, 1 Centimeter, 10 Centimeter}, fieldDefinition],
			{{1 Centimeter, 1 Centimeter, 10 Centimeter}, {}}
		]
	},
	Variables :> {fieldDefinition, filePath}
];

(* ::Subsubsection::Closed:: *)
(*executeDefaultUploadFunction*)
(* TODO right now a lot of the upload functions are not ready for Strict -> False upload yet, so there's only true unit test now *)
(* In the future we can add more integration tests (i.e., run the function without any weird Stubs) *)

DefineTests[executeDefaultUploadFunction,
	{
		Test["When Model[Sample] is supplied as the first input, function calls UploadSampleModel and use the Name from option as input:",
			Catch[executeDefaultUploadFunction[Model[Sample], {Name -> {"Water"}}, "sample model"]],
			{"Water"},
			Stubs :> {UploadSampleModel[x___] := Throw[First[{x}]]}
		],
		Test["Function modifies the input options, setting Strict -> False and Upload -> False, then pass to the external upload function:",
			Catch[executeDefaultUploadFunction[Model[Sample], {Name -> {"Water"}}, "sample model"]],
			AssociationMatchP[<| Name -> {"Water"}, Upload -> False, Strict -> False |>],
			Stubs :> {UploadSampleModel[x___] := Throw[Association[Last[{x}]]]}
		],
		Test["When Model[Item, Column] is supplied as the first input, function calls UploadColumn and use the Name from option as input:",
			Catch[executeDefaultUploadFunction[Model[Item, Column], {Name -> {"test column"}}, "column model"]],
			{"test column"},
			Stubs :> {UploadColumn[x___] := Throw[First[{x}]]}
		],
		Test["If the upload function did not return a list of packets, this function will return {$Failed, $Failed}:",
			executeDefaultUploadFunction[Model[Container, Plate], {Name -> {"test container"}}, "container model"],
			{$Failed, $Failed},
			Stubs :> {UploadContainerModel[x___] := {"1"}}
		],
		Test["If the upload function returns a list of packets, the first output of this function is the objects that matches the requested type, while the second output is all packets:",
			executeDefaultUploadFunction[Model[Item, Column], {Name -> "test column"}, "column model test"],
			{ObjectP[Model[Item, Column]], {PacketP[Model[Item, Lid]], PacketP[Model[Item, Column]]}},
			(* This test relies on UploadColumn function do not run as usual, but instead search and download one random column model and one random lid model *)
			Stubs :> {UploadColumn[x___] := With[
				{objects = Flatten[Search[{{Model[Item, Lid]}, {Model[Item, Column]}}, MaxResults -> 1]]},
				Download[objects, Packet[Name]]
			]}
		],
		Test["If no function is directly available in $ObjectBuilder to create the requested type, function that creates parent type of the input will be used:",
			Catch[executeDefaultUploadFunction[Model[Container, Plate, Filter], {Name -> {"test plate filter"}}, "container model"]],
			Model[Container, Plate, Filter],
			Stubs :> {UploadContainerModel[x___] := Throw[First[{x}]]}
		]
	},
	SetUp :> {ClearMemoization[]}
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
(*installDefaultUploadFunction*)


DefineTests[installDefaultUploadFunction,
	{
		Example[{Basic, "Generate a generic upload function for Model[Sample] with name 'installDefaultUploadFunctionTestFunction':"},
			installDefaultUploadFunction[installDefaultUploadFunctionTestFunction, Model[Sample]];
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
			installDefaultUploadFunction[
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
			installDefaultUploadFunction[
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
			installDefaultUploadFunction[installDefaultUploadFunctionTestFunction4, Model[Sample]];
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
			installDefaultUploadFunction[installDefaultUploadFunctionTestFunction5, Model[Sample]];
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
			installDefaultUploadFunction[
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
			installDefaultUploadFunction[
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
		Example[{Options, DocumentationDefinitionNumber, "Specify the documentation definition to use for ValidInputLengthsQ:"},
			installDefaultUploadFunction[
				installDefaultUploadFunctionTestFunction13,
				Model[Sample],
				DocumentationDefinitionNumber -> 1
			];
			DownValues[installDefaultUploadFunctionTestFunction13],
			Except[{}],
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction13]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction13]
			}
		],
		Test["Two overloads are defined - one listable and the other singleton:",
			installDefaultUploadFunction[installDefaultUploadFunctionTestFunction8, Model[Sample]];
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
			installDefaultUploadFunction[installDefaultUploadFunctionTestFunction9, Model[Sample]];
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
			installDefaultUploadFunction[
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
			installDefaultUploadFunction[
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
		],
		Test["Usage is not redefined if it already exists:",
			installDefaultUploadFunction[installDefaultUploadFunctionTestFunction12, Model[Sample]];
			Usage[installDefaultUploadFunctionTestFunction12],
			<|"Existing" -> "Docs"|>,
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction12]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction12]
			},
			Stubs :> {
				Usage[installDefaultUploadFunctionTestFunction12] = <|"Existing" -> "Docs"|>
			}
		],
		Test["By default, generateDefaultUploadPackets is used as packet generation function:",
			installDefaultUploadFunction[installDefaultUploadFunctionTestFunction13, Model[Sample]];
			DownValues[installDefaultUploadFunctionTestFunction13],
			_?(MemberQ[#,
				_generateDefaultUploadPackets,
				Infinity
			]&),
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction13]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction13]
			}
		],
		Test["If a custom option packets function is specified, it is used in place of the default:",
			installDefaultUploadFunction[
				installDefaultUploadFunctionTestFunction14,
				Model[Sample],
				PacketCreationFunction -> installDefaultUploadFunctionPacketFunction14
			];
			DownValues[installDefaultUploadFunctionTestFunction14],
			_?(And[
				MemberQ[#,
					_installDefaultUploadFunctionPacketFunction14,
					Infinity
				],
				!MemberQ[#,
					_generateDefaultUploadPackets,
					Infinity
				]
			]&),
			SetUp :> {
				ClearAll[installDefaultUploadFunctionTestFunction14]
			},
			TearDown :> {
				ClearAll[installDefaultUploadFunctionTestFunction14]
			}
		],

		(* Testing the functions themselves *)
		(* Creating new objects *)
		Test["Upload a basic object using the default upload function:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 1 " <> $SessionUUID
			],
			ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 1 " <> $SessionUUID]],
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns packets when Upload -> False when creating a new object:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 2 " <> $SessionUUID,
				Upload -> False
			],
			_?ValidUploadQ,
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns options when Output -> Options when creating a new object:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 3 " <> $SessionUUID,
				Output -> Options
			],
			{_Rule..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns tests when Output -> Tests when creating a new object:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 4 " <> $SessionUUID,
				Output -> Tests
			],
			{TestP..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns mixed output correctly when creating a new object:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 5 " <> $SessionUUID,
				Output -> {
					Result,
					Options,
					Tests
				}
			],
			{
				ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 5 " <> $SessionUUID]],
				{_Rule..},
				{TestP..}
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Upload multiple objects using the default upload function:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 6 " <> $SessionUUID,
					"Test object 2 for UploadIDUFTest1 unit tests 6 " <> $SessionUUID
				}
			],
			{
				ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 6 " <> $SessionUUID]],
				ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest1 unit tests 6 " <> $SessionUUID]]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns packets when Upload -> False when creating multiple new objects:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 7 " <> $SessionUUID,
					"Test object 2 for UploadIDUFTest1 unit tests 7 " <> $SessionUUID
				},
				Upload -> False
			],
			_?ValidUploadQ,
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns options when Output -> Options when creating multiple new objects:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 8 " <> $SessionUUID,
					"Test object 2 for UploadIDUFTest1 unit tests 8 " <> $SessionUUID
				},
				Output -> Options
			],
			{_Rule..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns tests when Output -> Tests when creating multiple new objects:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 9 " <> $SessionUUID,
					"Test object 2 for UploadIDUFTest1 unit tests 9 " <> $SessionUUID
				},
				Output -> Tests
			],
			{TestP..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns mixed output correctly when creating multiple new objects:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 10 " <> $SessionUUID,
					"Test object 2 for UploadIDUFTest1 unit tests 10 " <> $SessionUUID
				},
				Output -> {
					Result,
					Options,
					Tests
				}
			],
			{
				{
					ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 10 " <> $SessionUUID]],
					ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest1 unit tests 10 " <> $SessionUUID]]
				},
				{_Rule..},
				{TestP..}
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Upload a single object in listed form using the default upload function:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 11 " <> $SessionUUID
				}
			],
			{
				ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 11 " <> $SessionUUID]]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns packets when Upload -> False when creating a single new object in listed form:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 12 " <> $SessionUUID
				},
				Upload -> False
			],
			_?ValidUploadQ,
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns options when Output -> Options when creating a single new object in listed form:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 13 " <> $SessionUUID
				},
				Output -> Options
			],
			{_Rule..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns tests when Output -> Tests when creating a single new object in listed form:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 14 " <> $SessionUUID
				},
				Output -> Tests
			],
			{TestP..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Returns mixed output correctly when creating a single new object in listed form:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 15 " <> $SessionUUID
				},
				Output -> {
					Result,
					Options,
					Tests
				}
			],
			{
				{ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 15 " <> $SessionUUID]]},
				{_Rule..},
				{TestP..}
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Core fields are populated when creating a new object with no specified options and the default option resolver:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 16 " <> $SessionUUID
			];
			packet = Download[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 16 " <> $SessionUUID]];
			coreFields = {Object, ID, Name, Authors, CreatedBy, DateCreated, Synonyms, DeveloperObject, Published, Type, Valid};

			{
				(* Test the populated fields in the whole packet *)
				packet,

				(* Pick out the fields that are actually populated. Then drop the fields that should be populated. Leaving an association of those falsely populated *)
				KeyDrop[Select[packet, !MatchQ[#, Alternatives[{}, Null]] &], coreFields]
			},
			{
				AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 16 " <> $SessionUUID]],
						Name -> "Test object 1 for UploadIDUFTest1 unit tests 16 " <> $SessionUUID,
						Authors -> {LinkP[$PersonID]},
						CreatedBy -> LinkP[$PersonID],
						DateCreated -> RangeP[Now - 1 Minute, Now],
						Synonyms -> {"Test object 1 for UploadIDUFTest1 unit tests 16 " <> $SessionUUID}
					|>,
					AllowForeignKeys -> True
				],
				<||>
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			Variables :> {
				packet, coreFields
			}
		],
		Test["Fields of each type are populated correctly when the appropriate option is specified when creating a new object:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 17 " <> $SessionUUID,

				(* Single string *)
				UNII -> "H49AAM893K",

				(* Single boolean *)
				DetectionLabel -> False,

				(* Single Real *)
				BoilingPoint -> 78 Celsius,

				(* Single expression *)
				State -> Liquid,

				(* Single link *)
				DefaultSampleModel -> Model[Sample, "id:Y0lXejGKdEDW"],

				(* Multiple String *)
				Synonyms -> {"Test object 1 for UploadIDUFTest1 unit tests 17 " <> $SessionUUID, "Tag 1", "Tag 2"},

				(* Multiple real *)
				pKa -> {1, 5, 10},

				(* Multiple Link *)
				DetectionLabels -> {
					Model[Molecule, "id:1ZA60vL5W5vq"]
				},

				(* Multiple expression *)
				ExtinctionCoefficients -> {{700 Nanometer, 99 Liter / (Centimeter Mole)}}
			];
			Download[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 17 " <> $SessionUUID]],

			AssociationMatchP[
				<|
					UNII -> "H49AAM893K",
					DetectionLabel -> False,
					BoilingPoint -> EqualP[78 Celsius],
					State -> Liquid,
					DefaultSampleModel -> LinkP[Model[Sample, "id:Y0lXejGKdEDW"]],
					Synonyms -> {"Test object 1 for UploadIDUFTest1 unit tests 17 " <> $SessionUUID, "Tag 1", "Tag 2"},
					pKa -> {EqualP[1], EqualP[5], EqualP[10]},
					DetectionLabels -> {
						LinkP[Model[Molecule, "id:1ZA60vL5W5vq"]]
					},
					ExtinctionCoefficients -> {
						<|Wavelength -> EqualP[700 Nanometer], ExtinctionCoefficient -> EqualP[99 Liter / (Centimeter Mole)]|>
					}
				|>,
				AllowForeignKeys -> True
			],
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Fields of each type are populated correctly when the appropriate option is specified as a single when creating multiple new objects:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 18 " <> $SessionUUID,
					"Test object 2 for UploadIDUFTest1 unit tests 18 " <> $SessionUUID
				},

				(* Single string *)
				UNII -> "H49AAM893K",

				(* Single boolean *)
				DetectionLabel -> False,

				(* Single Real *)
				BoilingPoint -> 78 Celsius,

				(* Single expression *)
				State -> Liquid,

				(* Single link *)
				DefaultSampleModel -> Model[Sample, "id:Y0lXejGKdEDW"],

				(* Multiple String *)
				Synonyms -> {"Tag 1", "Tag 2"},

				(* Multiple real *)
				pKa -> {1, 5, 10},

				(* Multiple Link *)
				DetectionLabels -> {
					Model[Molecule, "id:1ZA60vL5W5vq"]
				},

				(* Multiple expression *)
				ExtinctionCoefficients -> {{700 Nanometer, 99 Liter / (Centimeter Mole)}}
			];
			Download[{
				Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 18 " <> $SessionUUID],
				Model[Molecule, "Test object 2 for UploadIDUFTest1 unit tests 18 " <> $SessionUUID]
			}],

			{
				AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 18 " <> $SessionUUID]],
						UNII -> "H49AAM893K",
						DetectionLabel -> False,
						BoilingPoint -> EqualP[78 Celsius],
						State -> Liquid,
						DefaultSampleModel -> LinkP[Model[Sample, "id:Y0lXejGKdEDW"]],
						Synonyms -> {"Tag 1", "Tag 2", "Test object 1 for UploadIDUFTest1 unit tests 18 " <> $SessionUUID},
						pKa -> {EqualP[1], EqualP[5], EqualP[10]},
						DetectionLabels -> {
							LinkP[Model[Molecule, "id:1ZA60vL5W5vq"]]
						},
						ExtinctionCoefficients -> {
							<|Wavelength -> EqualP[700 Nanometer], ExtinctionCoefficient -> EqualP[99 Liter / (Centimeter Mole)]|>
						}
					|>,
					AllowForeignKeys -> True
				],
				AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest1 unit tests 18 " <> $SessionUUID]],
						UNII -> "H49AAM893K",
						DetectionLabel -> False,
						BoilingPoint -> EqualP[78 Celsius],
						State -> Liquid,
						DefaultSampleModel -> LinkP[Model[Sample, "id:Y0lXejGKdEDW"]],
						Synonyms -> {"Tag 1", "Tag 2", "Test object 2 for UploadIDUFTest1 unit tests 18 " <> $SessionUUID},
						pKa -> {EqualP[1], EqualP[5], EqualP[10]},
						DetectionLabels -> {
							LinkP[Model[Molecule, "id:1ZA60vL5W5vq"]]
						},
						ExtinctionCoefficients -> {
							<|Wavelength -> EqualP[700 Nanometer], ExtinctionCoefficient -> EqualP[99 Liter / (Centimeter Mole)]|>
						}
					|>,
					AllowForeignKeys -> True
				]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Fields of each type are populated correctly when the appropriate option is specified as a list when creating multiple new objects:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 19 " <> $SessionUUID,
					"Test object 2 for UploadIDUFTest1 unit tests 19 " <> $SessionUUID
				},

				(* Single string *)
				UNII -> {"UNII1", "UNII2"},

				(* Single boolean *)
				DetectionLabel -> {False, True},

				(* Single Real *)
				BoilingPoint -> {78 Celsius, 99 Celsius},

				(* Single expression *)
				State -> {Liquid, Solid},

				(* Single link *)
				DefaultSampleModel -> {
					Model[Sample, "id:Y0lXejGKdEDW"],
					Model[Sample, "id:01G6nvkKrrPd"]
				},

				(* Multiple String *)
				Synonyms -> {
					{"Tag 1", "Tag 2"},
					{"Tag 3", "Tag 4"}
				},

				(* Multiple real *)
				pKa -> {
					{1, 5, 10},
					{5}
				},

				(* Multiple Link *)
				DetectionLabels -> {
					{Model[Molecule, "id:1ZA60vL5W5vq"]},
					{Model[Molecule, "id:M8n3rx0676xR"]}
				},

				(* Multiple expression *)
				ExtinctionCoefficients -> {
					{{700 Nanometer, 99 Liter / (Centimeter Mole)}},
					{{900 Nanometer, 101 Liter / (Centimeter Mole)}}
				}
			];
			Download[{
				Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 19 " <> $SessionUUID],
				Model[Molecule, "Test object 2 for UploadIDUFTest1 unit tests 19 " <> $SessionUUID]
			}],

			{
				AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 19 " <> $SessionUUID]],
						UNII -> "UNII1",
						DetectionLabel -> False,
						BoilingPoint -> EqualP[78 Celsius],
						State -> Liquid,
						DefaultSampleModel -> LinkP[Model[Sample, "id:Y0lXejGKdEDW"]],
						Synonyms -> {"Tag 1", "Tag 2", "Test object 1 for UploadIDUFTest1 unit tests 19 " <> $SessionUUID},
						pKa -> {EqualP[1], EqualP[5], EqualP[10]},
						DetectionLabels -> {
							LinkP[Model[Molecule, "id:1ZA60vL5W5vq"]]
						},
						ExtinctionCoefficients -> {
							<|Wavelength -> EqualP[700 Nanometer], ExtinctionCoefficient -> EqualP[99 Liter / (Centimeter Mole)]|>
						}
					|>,
					AllowForeignKeys -> True
				],
				AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest1 unit tests 19 " <> $SessionUUID]],
						UNII -> "UNII2",
						DetectionLabel -> True,
						BoilingPoint -> EqualP[99 Celsius],
						State -> Solid,
						DefaultSampleModel -> LinkP[Model[Sample, "id:01G6nvkKrrPd"]],
						Synonyms -> {"Tag 3", "Tag 4", "Test object 2 for UploadIDUFTest1 unit tests 19 " <> $SessionUUID},
						pKa -> {EqualP[5]},
						DetectionLabels -> {
							LinkP[Model[Molecule, "id:M8n3rx0676xR"]]
						},
						ExtinctionCoefficients -> {
							<|Wavelength -> EqualP[900 Nanometer], ExtinctionCoefficient -> EqualP[101 Liter / (Centimeter Mole)]|>
						}
					|>,
					AllowForeignKeys -> True
				]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],


		(* Modifying existing objects *)
		Test["Modify an existing object using the default upload function:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 1 " <> $SessionUUID],
				Flammable -> True
			],
			ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 1 " <> $SessionUUID]],
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 1 " <> $SessionUUID
					|>
				]
			}
		],
		Test["Returns packets when Upload -> False when modifying an existing object:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 2 " <> $SessionUUID],
				Flammable -> True,
				Upload -> False
			],
			_?ValidUploadQ,
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 2 " <> $SessionUUID
					|>
				]
			}
		],
		Test["Returns options when Output -> Options when modifying an existing object:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 3 " <> $SessionUUID],
				Flammable -> True,
				Output -> Options
			],
			{_Rule..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 3 " <> $SessionUUID
					|>
				]
			}
		],
		Test["Returns tests when Output -> Tests when modifying an existing object:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 4 " <> $SessionUUID],
				Flammable -> True,
				Output -> Tests
			],
			{TestP..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 4 " <> $SessionUUID
					|>
				]
			}
		],
		Test["Returns mixed output correctly when modifying an existing object:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 5 " <> $SessionUUID],
				Flammable -> True,
				Output -> {
					Result,
					Options,
					Tests
				}
			],
			{
				ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 5 " <> $SessionUUID]],
				{_Rule..},
				{TestP..}
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 5 " <> $SessionUUID
					|>
				]
			}
		],
		Test["Modify multiple objects using the default upload function:",
			UploadIDUFTest1[
				{
					Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 6 " <> $SessionUUID],
					Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 6 " <> $SessionUUID]
				},
				Flammable -> True
			],
			{
				ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 6 " <> $SessionUUID]],
				ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 6 " <> $SessionUUID]]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 6 " <> $SessionUUID
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest1 Modification unit tests 6 " <> $SessionUUID
					|>
				}]
			}
		],
		Test["Returns packets when Upload -> False when modifying multiple objects:",
			UploadIDUFTest1[
				{
					Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 7 " <> $SessionUUID],
					Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 7 " <> $SessionUUID]
				},
				Flammable -> True,
				Upload -> False
			],
			_?ValidUploadQ,
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 7 " <> $SessionUUID
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest1 Modification unit tests 7 " <> $SessionUUID
					|>
				}]
			}
		],
		Test["Returns options when Output -> Options when modifying multiple objects:",
			UploadIDUFTest1[
				{
					Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 8 " <> $SessionUUID],
					Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 8 " <> $SessionUUID]
				},
				Flammable -> True,
				Output -> Options
			],
			{_Rule..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 8 " <> $SessionUUID
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest1 Modification unit tests 8 " <> $SessionUUID
					|>
				}]
			}
		],
		Test["Returns tests when Output -> Tests when modifying multiple objects:",
			UploadIDUFTest1[
				{
					Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 9 " <> $SessionUUID],
					Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 9 " <> $SessionUUID]
				},
				Flammable -> True,
				Output -> Tests
			],
			{TestP..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 9 " <> $SessionUUID
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest1 Modification unit tests 9 " <> $SessionUUID
					|>
				}]
			}
		],
		Test["Returns mixed output correctly when modifying multiple objects:",
			UploadIDUFTest1[
				{
					Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 10 " <> $SessionUUID],
					Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 10 " <> $SessionUUID]
				},
				Flammable -> True,
				Output -> {
					Result,
					Options,
					Tests
				}
			],
			{
				{
					ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 10 " <> $SessionUUID]],
					ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 10 " <> $SessionUUID]]
				},
				{_Rule..},
				{TestP..}
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 10 " <> $SessionUUID
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest1 Modification unit tests 10 " <> $SessionUUID
					|>
				}]
			}
		],
		Test["Critical fields are populated but core fields are unchanged when editing an existing object with no specified options and the default option resolver:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 11 " <> $SessionUUID]
			];
			Download[Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 11 " <> $SessionUUID], {Authors, Synonyms}],
			{
				(* Authors is populated *)
				{LinkP[$PersonID]},

				(* But synonyms is not *)
				{}
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 11 " <> $SessionUUID
					|>
				}]
			}
		],
		Test["Fields of each type are updated when the appropriate option is specified when modifying an existing object:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 12 " <> $SessionUUID],

				(* Single string *)
				UNII -> "H49AAM893K",

				(* Single boolean *)
				DetectionLabel -> False,

				(* Single Real *)
				BoilingPoint -> 78 Celsius,

				(* Single expression *)
				State -> Liquid,

				(* Single link *)
				DefaultSampleModel -> Model[Sample, "id:Y0lXejGKdEDW"],

				(* Multiple String *)
				Synonyms -> {"Tag 1", "Tag 2"},

				(* Multiple real *)
				pKa -> {1, 5, 10},

				(* Multiple Link *)
				DetectionLabels -> {
					Model[Molecule, "id:1ZA60vL5W5vq"]
				},

				(* Multiple expression *)
				ExtinctionCoefficients -> {{700 Nanometer, 99 Liter / (Centimeter Mole)}}
			];
			Download[Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 12 " <> $SessionUUID]],

			AssociationMatchP[
				<|
					UNII -> "H49AAM893K",
					DetectionLabel -> False,
					BoilingPoint -> EqualP[78 Celsius],
					State -> Liquid,
					DefaultSampleModel -> LinkP[Model[Sample, "id:Y0lXejGKdEDW"]],
					Synonyms -> {"Tag 1", "Tag 2"},
					pKa -> {EqualP[1], EqualP[5], EqualP[10]},
					DetectionLabels -> {
						LinkP[Model[Molecule, "id:1ZA60vL5W5vq"]]
					},
					ExtinctionCoefficients -> {
						<|Wavelength -> EqualP[700 Nanometer], ExtinctionCoefficient -> EqualP[99 Liter / (Centimeter Mole)]|>
					}
				|>,
				AllowForeignKeys -> True
			],
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 12 " <> $SessionUUID,
						UNII -> "Original",
						DetectionLabel -> True,
						BoilingPoint -> 0 Celsius,
						State -> Solid,
						DefaultSampleModel -> Null,
						Replace[Synonyms] -> {"Test object 1 for UploadIDUFTest1 Modification unit tests 12 " <> $SessionUUID},
						Replace[pKa] -> {0},
						Replace[DetectionLabels] -> {},
						Replace[ExtinctionCoefficients] -> {}
					|>
				}]
			}
		],
		Test["Fields of each type are modified correctly when the appropriate option is specified as a single when modifying multiple existing objects:",
			UploadIDUFTest1[
				{
					Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID],
					Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID]
				},

				(* Single string *)
				UNII -> "H49AAM893K",

				(* Single boolean *)
				DetectionLabel -> False,

				(* Single Real *)
				BoilingPoint -> 78 Celsius,

				(* Single expression *)
				State -> Liquid,

				(* Single link *)
				DefaultSampleModel -> Model[Sample, "id:Y0lXejGKdEDW"],

				(* Multiple String *)
				Synonyms -> {"Tag 1", "Tag 2"},

				(* Multiple real *)
				pKa -> {1, 5, 10},

				(* Multiple Link *)
				DetectionLabels -> {
					Model[Molecule, "id:1ZA60vL5W5vq"]
				},

				(* Multiple expression *)
				ExtinctionCoefficients -> {{700 Nanometer, 99 Liter / (Centimeter Mole)}}
			];
			Download[{
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID],
				Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID]
			}],

			{
				AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID]],
						UNII -> "H49AAM893K",
						DetectionLabel -> False,
						BoilingPoint -> EqualP[78 Celsius],
						State -> Liquid,
						DefaultSampleModel -> LinkP[Model[Sample, "id:Y0lXejGKdEDW"]],
						Synonyms -> {"Tag 1", "Tag 2"},
						pKa -> {EqualP[1], EqualP[5], EqualP[10]},
						DetectionLabels -> {
							LinkP[Model[Molecule, "id:1ZA60vL5W5vq"]]
						},
						ExtinctionCoefficients -> {
							<|Wavelength -> EqualP[700 Nanometer], ExtinctionCoefficient -> EqualP[99 Liter / (Centimeter Mole)]|>
						}
					|>,
					AllowForeignKeys -> True
				],
				AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID]],
						UNII -> "H49AAM893K",
						DetectionLabel -> False,
						BoilingPoint -> EqualP[78 Celsius],
						State -> Liquid,
						DefaultSampleModel -> LinkP[Model[Sample, "id:Y0lXejGKdEDW"]],
						Synonyms -> {"Tag 1", "Tag 2"},
						pKa -> {EqualP[1], EqualP[5], EqualP[10]},
						DetectionLabels -> {
							LinkP[Model[Molecule, "id:1ZA60vL5W5vq"]]
						},
						ExtinctionCoefficients -> {
							<|Wavelength -> EqualP[700 Nanometer], ExtinctionCoefficient -> EqualP[99 Liter / (Centimeter Mole)]|>
						}
					|>,
					AllowForeignKeys -> True
				]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID,
						UNII -> "Original",
						DetectionLabel -> True,
						BoilingPoint -> 0 Celsius,
						State -> Solid,
						DefaultSampleModel -> Null,
						Replace[Synonyms] -> {"Test object 1 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID},
						Replace[pKa] -> {0},
						Replace[DetectionLabels] -> {},
						Replace[ExtinctionCoefficients] -> {}
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID,
						UNII -> "Original",
						DetectionLabel -> True,
						BoilingPoint -> 0 Celsius,
						State -> Solid,
						DefaultSampleModel -> Null,
						Replace[Synonyms] -> {"Test object 2 for UploadIDUFTest1 Modification unit tests 13 " <> $SessionUUID},
						Replace[pKa] -> {0},
						Replace[DetectionLabels] -> {},
						Replace[ExtinctionCoefficients] -> {}
					|>
				}]
			}
		],
		Test["Fields of each type are modified correctly when the appropriate option is specified as a list when modifying multiple existing objects:",
			UploadIDUFTest1[
				{
					Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID],
					Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID]
				},

				(* Single string *)
				UNII -> {"UNII1", "UNII2"},

				(* Single boolean *)
				DetectionLabel -> {False, True},

				(* Single Real *)
				BoilingPoint -> {78 Celsius, 99 Celsius},

				(* Single expression *)
				State -> {Liquid, Solid},

				(* Single link *)
				DefaultSampleModel -> {
					Model[Sample, "id:Y0lXejGKdEDW"],
					Model[Sample, "id:01G6nvkKrrPd"]
				},

				(* Multiple String *)
				Synonyms -> {
					{"Tag 1", "Tag 2"},
					{"Tag 3", "Tag 4"}
				},

				(* Multiple real *)
				pKa -> {
					{1, 5, 10},
					{5}
				},

				(* Multiple Link *)
				DetectionLabels -> {
					{Model[Molecule, "id:1ZA60vL5W5vq"]},
					{Model[Molecule, "id:M8n3rx0676xR"]}
				},

				(* Multiple expression *)
				ExtinctionCoefficients -> {
					{{700 Nanometer, 99 Liter / (Centimeter Mole)}},
					{{900 Nanometer, 101 Liter / (Centimeter Mole)}}
				}
			];
			Download[{
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID],
				Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID]
			}],

			{
				AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID]],
						UNII -> "UNII1",
						DetectionLabel -> False,
						BoilingPoint -> EqualP[78 Celsius],
						State -> Liquid,
						DefaultSampleModel -> LinkP[Model[Sample, "id:Y0lXejGKdEDW"]],
						Synonyms -> {"Tag 1", "Tag 2"},
						pKa -> {EqualP[1], EqualP[5], EqualP[10]},
						DetectionLabels -> {
							LinkP[Model[Molecule, "id:1ZA60vL5W5vq"]]
						},
						ExtinctionCoefficients -> {
							<|Wavelength -> EqualP[700 Nanometer], ExtinctionCoefficient -> EqualP[99 Liter / (Centimeter Mole)]|>
						}
					|>,
					AllowForeignKeys -> True
				],
				AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID]],
						UNII -> "UNII2",
						DetectionLabel -> True,
						BoilingPoint -> EqualP[99 Celsius],
						State -> Solid,
						DefaultSampleModel -> LinkP[Model[Sample, "id:01G6nvkKrrPd"]],
						Synonyms -> {"Tag 3", "Tag 4"},
						pKa -> {EqualP[5]},
						DetectionLabels -> {
							LinkP[Model[Molecule, "id:M8n3rx0676xR"]]
						},
						ExtinctionCoefficients -> {
							<|Wavelength -> EqualP[900 Nanometer], ExtinctionCoefficient -> EqualP[101 Liter / (Centimeter Mole)]|>
						}
					|>,
					AllowForeignKeys -> True
				]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID,
						UNII -> "Original",
						DetectionLabel -> True,
						BoilingPoint -> 0 Celsius,
						State -> Solid,
						DefaultSampleModel -> Null,
						Replace[Synonyms] -> {"Test object 1 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID},
						Replace[pKa] -> {0},
						Replace[DetectionLabels] -> {},
						Replace[ExtinctionCoefficients] -> {}
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID,
						UNII -> "Original",
						DetectionLabel -> True,
						BoilingPoint -> 0 Celsius,
						State -> Solid,
						DefaultSampleModel -> Null,
						Replace[Synonyms] -> {"Test object 2 for UploadIDUFTest1 Modification unit tests 14 " <> $SessionUUID},
						Replace[pKa] -> {0},
						Replace[DetectionLabels] -> {},
						Replace[ExtinctionCoefficients] -> {}
					|>
				}]
			}
		],
		Test["Multiple fields are replaced when editing an existing object with the default option resolver:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 15 " <> $SessionUUID],
				pKa -> {10},
				IncompatibleMaterials -> {Glass}
			];
			Download[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 15 " <> $SessionUUID],
				{
					pKa,
					IncompatibleMaterials
				}
			],
			{
				{EqualP[10]},
				{Glass}
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 15 " <> $SessionUUID,
						Replace[pKa] -> {1},
						Replace[IncompatibleMaterials] -> {Epoxy}
					|>
				}]
			}
		],
		Test["When modifying an existing object, existing field values appear in the resolved options, but are not included in the change packet:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 16 " <> $SessionUUID],
				Flammable -> True,
				Output -> {
					Result,
					Options
				},
				Upload -> False
			],
			{
				{AssociationMatchP[
					<|
						Object -> ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 16 " <> $SessionUUID]],
						Replace[Authors] -> {LinkP[$PersonID]},
						Flammable -> True
					|>,
					RequireAllKeys -> True,
					AllowForeignKeys -> False
				]},
				_?(
					And[
						MemberQ[#, Flammable -> True],
						MemberQ[#, Ventilated -> True]
					]
				&)
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest1 Modification unit tests 16 " <> $SessionUUID,
						Replace[Authors] -> {Link[$PersonID]},
						Ventilated -> True
					|>
				]
			}
		],

		(* Speed *)
		Test["Downloads of URLs are memoized, so repeated function calls are fast:",
			timing1 = First@AbsoluteTiming[UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 20 " <> $SessionUUID,
				StructureImageFile -> "https://www.emeraldcloudlab.com/static/d167d3457dcf81e5d4e6ae0101d359d4/ea92a/robotic-sample-preparation-workcell.png",
				Output -> Options
			]];
			timing2 = First@AbsoluteTiming[
				UploadIDUFTest1[
					"Test object 1 for UploadIDUFTest1 unit tests 20 " <> $SessionUUID,
					StructureImageFile -> "https://www.emeraldcloudlab.com/static/d167d3457dcf81e5d4e6ae0101d359d4/ea92a/robotic-sample-preparation-workcell.png",
					Output -> Options
				];
			];
			timing1 - timing2,
			GreaterP[0], (* Repeat call should be more than about 0.5 seconds faster with memoization. However this varies on manifold so check for 0 *)
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {ClearMemoization[]},
			Variables :> {timing1, timing2}
		],

		(* Options *)
		Example[{Options, OptionResolver, "Specify a custom option resolver:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest2, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define a silly custom option resolver *)
			UploadIDUFTest2Resolver[myType_, myInput : {___}, myOptions_, rawOptions_] := Module[
				{resolvedOptions},

				resolvedOptions = Map[
					Which[
						(* If Automatic, resolve to Null *)
						MatchQ[Last[#], Automatic], First[#] -> Null,

						(* If a string was specified, replace it with spam, obviously *)
						StringQ[Last[#]], First[#] -> "Spam spam spam",

						(* Otherwise resolve to original value *)
						True, #
					] &,
					myOptions,
					{2}
				];

				<|
					Result -> resolvedOptions,
					InvalidInputs -> {},
					InvalidOptions -> {}
				|>
			];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest2,
				Model[Molecule],
				OptionResolver -> UploadIDUFTest2Resolver
			];

			(* Call the function *)
			resolvedOptions = UploadIDUFTest2[
				"Test object 1 for UploadIDUFTest2 unit tests 1 " <> $SessionUUID,
				UNII -> "UNII123",
				IUPAC -> "IUPAC Name",
				MolecularFormula -> "MoF",
				Density -> 0.705 Gram / Milliliter, (* Density of Spam according to Gemini. Though it does caution that "The density of Spam is not a standard measurement"... *)
				Output -> Options
			];

			(* Look up some key options *)
			Lookup[
				resolvedOptions,
				{UNII, IUPAC, MolecularFormula, Density}
			],


			{
				"Spam spam spam",
				"Spam spam spam",
				"Spam spam spam",
				EqualP[0.705 Gram / Milliliter]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest2, UploadIDUFTest2Resolver}]
			},
			Variables :> {resolvedOptions}
		],

		Example[{Options, AuxilliaryPacketsFunction, "Specify a custom auxilliary packets function to make modifications to related objects along with the primary changes:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest3, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define a silly custom auxilliary packets function *)
			UploadIDUFTest3AuxPackets[myType_, myInput:{___}, listedOptions_, resolvedOptions_] := {
				<|
					Object -> Model[Sample, "Test sample 1 for UploadIDUFTest3 Modification unit tests 1 " <> $SessionUUID],
					BoilingPoint -> 100 Celsius
				|>
			};

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest3,
				Model[Molecule],
				AuxilliaryPacketsFunction -> UploadIDUFTest3AuxPackets
			];

			(* Call the function *)
			UploadIDUFTest3[
				"Test object 1 for UploadIDUFTest3 unit tests 1 " <> $SessionUUID,
				UNII -> "UNII123"
			];

			(* Check the key field values *)
			Download[
				{
					Model[Molecule, "Test object 1 for UploadIDUFTest3 unit tests 1 " <> $SessionUUID],
					Model[Sample, "Test sample 1 for UploadIDUFTest3 Modification unit tests 1 " <> $SessionUUID]
				},
				{
					{UNII},
					{BoilingPoint}
				}
			],


			{
				{"UNII123"},
				{EqualP[100 Celsius]}
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			SetUp :> {
				Upload[{
					<|
						Type -> Model[Sample],
						Name -> "Test sample 1 for UploadIDUFTest3 Modification unit tests 1 " <> $SessionUUID
					|>
				}]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest3, UploadIDUFTest3AuxPackets}]
			}
		],

		Example[{Options, InputPattern, "Allow custom input patterns and specify a custom resolver to handle them:"},
			(* Define the new custom input pattern *)
			customInputPattern = Alternatives[_String, Solid, Liquid, Gas];

			(* Set the options *)
			DefineOptions[UploadIDUFTest4, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define some docs - the pattern has to be included here *)
			DefineUsage[
				UploadIDUFTest4,
				{
					BasicDefinitions -> {
						{"UploadIDUFTest4[input]", "output", "description."}
					},
					Input :> {
						{"input", customInputPattern, "description."}
					},
					Output :> {
						{"output", _, "description."}
					},
					SeeAlso -> {"UploadMolecule", "UploadSampleModel"},
					Author -> {"david.ascough"}
				}
			];

			(* Define a custom option resolver *)
			UploadIDUFTest4Resolver[myType_, myInput:{___}, myOptions_, rawOptions_] := Module[
				{resolvedOptions, updatedOptions},

				resolvedOptions = Map[
					Which[
						(* If Automatic, resolve to Null *)
						MatchQ[Last[#], Automatic], First[#] -> Null,

						(* Otherwise resolve to original value *)
						True, #
					] &,
					myOptions,
					{2}
				];

				(* Use the custom Solid/Liquid/Gas input as a state *)
				updatedOptions = MapThread[
					ReplaceRule[
						#2,
						State -> #1
					] &,
					{myInput, resolvedOptions}
				];

				<|
					Result -> updatedOptions,
					InvalidInputs -> {},
					InvalidOptions -> {}
				|>
			];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest4,
				Model[Molecule],
				OptionResolver -> UploadIDUFTest4Resolver,
				InputPattern :> customInputPattern
			];

			(* Call the function *)
			resolvedOptions = UploadIDUFTest4[
				Liquid,
				Name -> "Test object 1 for UploadIDUFTest4 unit tests 1 " <> $SessionUUID,
				Output -> Options
			];

			(* Look up some key options *)
			Lookup[
				resolvedOptions,
				State
			],


			Liquid,
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest4, UploadIDUFTest4Resolver}]
			},
			Variables :> {customInputPattern, resolvedOptions}
		],

		Example[{Options, DuplicateObjectChecks, "Specify fields to check for duplicate objects by:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest5, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest5,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> IUPAC, Check -> Error|>
				}
			];

			(* Call the function *)
			UploadIDUFTest5[
				"Test object 1 for UploadIDUFTest5 unit tests 1 " <> $SessionUUID,
				UNII -> "UNII123",
				IUPAC -> "IUPAC Name",
				MolecularFormula -> "MoF"
			],

			$Failed,
			Messages :> {Error::DuplicateObjects, Error::InvalidInput, Error::InvalidOption},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest5 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest5 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name"
					|>
				]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest5}]
			}
		],

		(* Messages *)
		Example[{Messages, "DuplicateObjects", "Check -> Error works for DuplicateObjectChecks, throwing an error and returning $Failed:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest6, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest6,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> IUPAC, Check -> Error|>
				}
			];

			(* Call the function *)
			UploadIDUFTest6[
				"Test object 1 for UploadIDUFTest6 unit tests 1 " <> $SessionUUID,
				IUPAC -> "IUPAC Name"
			],


			$Failed,
			Messages :> {
				Error::DuplicateObjects,
				Message[Error::InvalidInput, "{Test object 1 for UploadIDUFTest6 unit tests 1 " <> $SessionUUID <> "}"],
				Message[Error::InvalidOption, "{IUPAC}"]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest6 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest6 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name"
					|>
				]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest6}]
			}
		],
		Example[{Messages, "DuplicateObjects", "Check -> Warning works for DuplicateObjectChecks, throwing a soft warning and continuing:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest7, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest7,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> IUPAC, Check -> Warning|>
				}
			];

			(* Call the function *)
			UploadIDUFTest7[
				"Test object 1 for UploadIDUFTest7 unit tests 1 " <> $SessionUUID,
				IUPAC -> "IUPAC Name"
			],


			ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest7 unit tests 1 " <> $SessionUUID]],
			Messages :> {
				Warning::DuplicateObjects
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest7 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest7 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name"
					|>
				]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest7}]
			}
		],
		Example[{Messages, "ObjectAlreadyExists", "Check -> Modification works for DuplicateObjectChecks, throwing a soft warning and automatically modifying the existing object:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest8, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest8,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> IUPAC, Check -> Modification|>
				}
			];

			(* Call the function *)
			updatedObject = UploadIDUFTest8[
				"Test object 1 for UploadIDUFTest8 unit tests 1 " <> $SessionUUID,
				IUPAC -> "IUPAC Name",
				MeltingPoint -> 80 Celsius
			];

			Download[
				updatedObject,
				{
					Object,
					Name,
					IUPAC,
					MeltingPoint,
					UNII,
					State
				}
			],


			{
				ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest8 unit tests 1 " <> $SessionUUID]],
				"Test object 2 for UploadIDUFTest8 unit tests 1 " <> $SessionUUID,
				"IUPAC Name",
				EqualP[80 Celsius],
				"MoF",
				Solid
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest8 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest8 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name",
						UNII -> "MoF",
						State -> Solid
					|>
				]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest8}]
			},
			Variables :> {updatedObject}
		],
		Example[{Messages, "MultipleExistingObjects", "If specified to modify an existing duplicate and multiple are found, throw a hard error:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest9, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest9,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> IUPAC, Check -> Modification|>
				}
			];

			(* Call the function *)
			UploadIDUFTest9[
				"Test object 1 for UploadIDUFTest9 unit tests 1 " <> $SessionUUID,
				IUPAC -> "IUPAC Name",
				MeltingPoint -> 80 Celsius
			],

			$Failed,
			Messages :> {
				Error::MultipleExistingObjects, Error::InvalidInput, Error::InvalidOption
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest9 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create duplicate objects *)
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest9 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name",
						UNII -> "MoF",
						State -> Solid
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test object 3 for UploadIDUFTest9 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name",
						UNII -> "Als0MoF"
					|>
				}]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest9}]
			}
		],
		Example[{Messages, "DuplicateObjects", "If DuplicateObjectChecks finds both an Error and a Warning duplicate for the same input, only the Error is shown:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest10, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest10,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> UNII, Check -> Warning|>,
					<|Field -> IUPAC, Check -> Error|>
				}
			];

			(* Call the function *)
			UploadIDUFTest10[
				"Test object 1 for UploadIDUFTest10 unit tests 1 " <> $SessionUUID,
				IUPAC -> "IUPAC Name",
				UNII -> "UNII123"
			],


			$Failed,
			Messages :> {
				Error::DuplicateObjects,
				Message[Error::InvalidInput, "{Test object 1 for UploadIDUFTest10 unit tests 1 " <> $SessionUUID <> "}"],
				Message[Error::InvalidOption, "{IUPAC}"]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest10 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest10 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name",
						UNII -> "UNII123"
					|>
				]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest10}]
			}
		],
		Example[{Messages, "DuplicateObjects", "If DuplicateObjectChecks finds both an Error and a Modification duplicate for the same input, only the Error is shown:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest11, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest11,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> UNII, Check -> Modification|>,
					<|Field -> IUPAC, Check -> Error|>
				}
			];

			(* Call the function *)
			UploadIDUFTest11[
				"Test object 1 for UploadIDUFTest11 unit tests 1 " <> $SessionUUID,
				IUPAC -> "IUPAC Name",
				UNII -> "UNII123"
			],


			$Failed,
			Messages :> {
				Error::DuplicateObjects,
				Message[Error::InvalidInput, "{Test object 1 for UploadIDUFTest11 unit tests 1 " <> $SessionUUID <> "}"],
				Message[Error::InvalidOption, "{IUPAC}"]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest11 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest11 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name",
						UNII -> "UNII123"
					|>
				]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest11}]
			}
		],
		Example[{Messages, "ObjectAlreadyExists", "If DuplicateObjectChecks finds both an Warning and a Modification duplicate for the same input, only the Modification is shown:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest12, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest12,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> UNII, Check -> Warning|>,
					<|Field -> IUPAC, Check -> Modification|>
				}
			];

			(* Call the function *)
			UploadIDUFTest12[
				"Test object 1 for UploadIDUFTest12 unit tests 1 " <> $SessionUUID,
				IUPAC -> "IUPAC Name",
				UNII -> "UNII123"
			],

			(* Modifies existing object *)
			ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest12 unit tests 1 " <> $SessionUUID]],
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest12 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest12 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name",
						UNII -> "UNII123"
					|>
				]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest12}]
			}
		],
		Example[{Messages, "DuplicateObjects", "If DuplicateObjectChecks finds an Error, Warning and modification duplicate for different inputs, all messages are shown:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest13, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest13,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> UNII, Check -> Warning|>,
					<|Field -> IUPAC, Check -> Error|>,
					<|Field -> CAS, Check -> Modification|>
				}
			];

			(* Call the function *)
			UploadIDUFTest13[
				{
					"Test object 1 for UploadIDUFTest13 unit tests 1 " <> $SessionUUID,
					"Test object 2 for UploadIDUFTest13 unit tests 1 " <> $SessionUUID,
					"Test object 3 for UploadIDUFTest13 unit tests 1 " <> $SessionUUID
				},
				IUPAC -> {
					"IUPAC Name 2",
					Automatic,
					Automatic
				},
				UNII -> {
					Automatic,
					"UNII2",
					Automatic
				},
				CAS -> {
					Automatic,
					Automatic,
					"58-08-2"
				}
			],


			$Failed,
			Messages :> {
				Error::DuplicateObjects,
				Warning::DuplicateObjects,
				Warning::ObjectAlreadyExists,
				Message[Error::InvalidInput, "{Test object 1 for UploadIDUFTest13 unit tests 1 " <> $SessionUUID <> "}"],
				Message[Error::InvalidOption, "{IUPAC}"]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest13 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 4 for UploadIDUFTest13 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name 2",
						UNII -> "UNII2",
						CAS -> "58-08-2"
					|>
				]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest13}]
			}
		],
		Example[{Messages, "DuplicateObjects", "Default duplicate object check checks for duplicates by name, throws an error and returns $Failed:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest14, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest14,
				Model[Molecule]
			];

			(* Call the function *)
			UploadIDUFTest14[
				"Test object 1 for UploadIDUFTest14 unit tests 1 " <> $SessionUUID,
				IUPAC -> "IUPAC Name"
			],


			$Failed,
			Messages :> {
				Error::DuplicateObjects,
				Message[Error::InvalidInput, "{Test object 1 for UploadIDUFTest14 unit tests 1 " <> $SessionUUID <> "}"],
				Message[Error::InvalidOption, "{Name}"]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest14 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[
					<|
						Type -> Model[Molecule],
						Name -> "Test object 1 for UploadIDUFTest14 unit tests 1 " <> $SessionUUID,
						IUPAC -> "IUPAC Name"
					|>
				]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest14}]
			}
		],
		Example[{Options, PacketCreationFunction, "Specify a custom packet creation function to make modifications perform custom changes when converting resolved options into upload packets:"},
			(* Set the options *)
			DefineOptions[UploadIDUFTest15, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define a silly custom auxilliary packets function. Just sets BP of everything to 1 Kelvin *)
			UploadIDUFTest15GeneratedPackets[myType_, myInputs : _List, myOptions_, myOps : OptionsPattern[]] := {
				Map[
					<|
						Type -> myType,
						Name -> #,
						BoilingPoint -> 1 Kelvin
					|> &,
					myInputs
				],
				{},
				{}
			};

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest15,
				Model[Molecule],
				PacketCreationFunction -> UploadIDUFTest15GeneratedPackets
			];

			(* Call the function *)
			UploadIDUFTest15[
				"Test object 1 for UploadIDUFTest15 unit tests 1 " <> $SessionUUID,
				UNII -> "UNII123"
			];

			(* Check the key field values *)
			Download[
				Model[Molecule, "Test object 1 for UploadIDUFTest15 unit tests 1 " <> $SessionUUID],
				{UNII, BoilingPoint}
			],


			{Null, EqualP[1 Kelvin]},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest15, UploadIDUFTest15GeneratedPackets}]
			}
		],
		Test["VOQ error testing is skipped if RunOptionValidationTests -> False:",
			(* Set the options *)
			DefineOptions[UploadIDUFTest16, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest16,
				Model[Molecule],
				RunOptionValidationTests -> False
			];

			(* Call the function *)
			UploadIDUFTest16[
				"Test object 1 for UploadIDUFTest16 unit tests 1 " <> $SessionUUID,
				Acid -> True,
				Base -> True
			],

			ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest16 unit tests 1 " <> $SessionUUID]],
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {
					Test["Both Acid and Base cannot be True simultaneously:",
						{True, True},
						Except[{True, True}],
						Message -> {Hold[Error::AcidAndBase], "Test object 1 for UploadIDUFTest16 unit tests 1 " <> $SessionUUID}
					]
				},
				ValidObjectQ`Private`errorToOptionMap[Model[Molecule]] := {
					"Error::AcidAndBase" -> {Acid, Base}
				}
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest16}]
			}
		],
		Test["Creating, modifying specified and modifying duplicate objects in the same call works:",
			(* Set the options *)
			DefineOptions[UploadIDUFTest17, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];

			(* Define the function *)
			installDefaultUploadFunction[
				UploadIDUFTest17,
				Model[Molecule],
				DuplicateObjectChecks -> {
					<|Field -> Name, Check -> Modification|>
				}
			];

			(* Call the function *)
			updatedObjects = UploadIDUFTest17[
				{
					"Test object 1 for UploadIDUFTest17 unit tests 1 " <> $SessionUUID, (* New object *)
					"Test object 2 for UploadIDUFTest17 unit tests 1 " <> $SessionUUID, (* Duplicate check existing object *)
					Model[Molecule, "Test object 3 for UploadIDUFTest17 unit tests 1 " <> $SessionUUID] (* Modify specified existing object *)
				},
				Flammable -> True
			];

			Download[
				updatedObjects,
				{
					Object,
					Flammable
				}
			],


			{
				{
					ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest17 unit tests 1 " <> $SessionUUID]],
					True
				},
				{
					ObjectP[Model[Molecule, "Test object 2 for UploadIDUFTest17 unit tests 1 " <> $SessionUUID]],
					True
				},
				{
					ObjectP[Model[Molecule, "Test object 3 for UploadIDUFTest17 unit tests 1 " <> $SessionUUID]],
					True
				}
			},
			Messages :> {
				Warning::ObjectAlreadyExists
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {},
				$RequiredSearchName = "for UploadIDUFTest17 unit tests 1 " <> $SessionUUID
			},
			SetUp :> {
				(* Create a duplicate object *)
				Upload[{
					<|
						Type -> Model[Molecule],
						Name -> "Test object 2 for UploadIDUFTest17 unit tests 1 " <> $SessionUUID
					|>,
					<|
						Type -> Model[Molecule],
						Name -> "Test object 3 for UploadIDUFTest17 unit tests 1 " <> $SessionUUID
					|>
				}]
			},
			TearDown :> {
				ClearAll[{UploadIDUFTest17}]
			},
			Variables :> {updatedObjects}
		],

		(* Additional message checks *)
		Test["Throws an error and returns $Failed if attempting to modifying an object that doesn't exist:",
			UploadIDUFTest1[
				Model[Molecule, "Test object 1 for UploadIDUFTest1 Modification unit tests 16 " <> $SessionUUID],
				Flammable -> True
			],
			$Failed,
			Messages :> {
				Error::MissingObjects
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Throws an error and returns $Failed if an invalid URL is supplied for a cloud file field:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 21 " <> $SessionUUID,
				StructureImageFile -> "www.emeraldcloudlab.com"
			],
			$Failed,
			Messages :> {
				Error::InvalidURL,
				Message[Error::InvalidOption, "{StructureImageFile}"]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Throws an error and returns $Failed if an invalid local file path is supplied for a cloud file field:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 22 " <> $SessionUUID,
				StructureImageFile -> FileNameJoin[{$TemporaryDirectory, "test-missing-file.png"}]
			],
			$Failed,
			Messages :> {
				Error::InvalidLocalFile,
				Message[Error::InvalidOption, "{StructureImageFile}"]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Errors thrown by testsForPacket are surfaced to the user and the function returns $Failed if invalid options are included in errorToOptionMap:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 23 " <> $SessionUUID,
				Acid -> True,
				Base -> True
			],
			$Failed,
			Messages :> {
				Error::AcidAndBase,
				Message[Error::InvalidOption, "{Acid, Base}"]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {
					Test["Both Acid and Base cannot be True simultaneously:",
						{True, True},
						Except[{True, True}],
						Message -> {Hold[Error::AcidAndBase], "Test object 1 for UploadIDUFTest1 unit tests 23 " <> $SessionUUID}
					]
				},
				ValidObjectQ`Private`errorToOptionMap[Model[Molecule]] := {
					"Error::AcidAndBase" -> {Acid, Base}
				}
			}
		],
		Test["Errors thrown by testsForPacket are surfaced to the user and the function continues if invalid options are not included in errorToOptionMap:",
			UploadIDUFTest1[
				"Test object 1 for UploadIDUFTest1 unit tests 24 " <> $SessionUUID,
				Acid -> True,
				Base -> True
			],
			ObjectP[Model[Molecule, "Test object 1 for UploadIDUFTest1 unit tests 24 " <> $SessionUUID]],
			Messages :> {
				Error::AcidAndBase
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {
					Test["Both Acid and Base cannot be True simultaneously:",
						{True, True},
						Except[{True, True}],
						Message -> {Hold[Error::AcidAndBase], "Test object 1 for UploadIDUFTest1 unit tests 24 " <> $SessionUUID}
					]
				},
				ValidObjectQ`Private`errorToOptionMap[Model[Molecule]] := {
				}
			}
		],
		Test["Built in error handling combines error messages thrown by VOQ style error checking for all inputs that throw the error:",
			UploadIDUFTest1[
				{
					"Test object 1 for UploadIDUFTest1 unit tests 25 " <> $SessionUUID,
					"Test object 2 for UploadIDUFTest1 unit tests 25 " <> $SessionUUID
				},
				Acid -> True,
				Base -> True
			],
			$Failed,
			Messages :> {
				Message[Error::AcidAndBase, "{Test object 1 for UploadIDUFTest1 unit tests 25 " <> $SessionUUID <> ", Test object 2 for UploadIDUFTest1 unit tests 25 " <> $SessionUUID <> "}"],
				Message[Error::InvalidOption, "{Acid, Base}"]
			},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[packet : AssociationMatchP[<|Name -> "Test object 1 for UploadIDUFTest1 unit tests 25 " <> $SessionUUID|>, AllowForeignKeys -> True]] := {
					Test["Both Acid and Base cannot be True simultaneously:",
						{True, True},
						Except[{True, True}],
						Message -> {Hold[Error::AcidAndBase], "Test object 1 for UploadIDUFTest1 unit tests 25 " <> $SessionUUID}
					]
				},
				ValidObjectQ`Private`testsForPacket[packet : AssociationMatchP[<|Name -> "Test object 2 for UploadIDUFTest1 unit tests 25 " <> $SessionUUID|>, AllowForeignKeys -> True]] := {
					Test["Both Acid and Base cannot be True simultaneously:",
						{True, True},
						Except[{True, True}],
						Message -> {Hold[Error::AcidAndBase], "Test object 2 for UploadIDUFTest1 unit tests 25 " <> $SessionUUID}
					]
				},
				ValidObjectQ`Private`errorToOptionMap[Model[Molecule]] := {
					"Error::AcidAndBase" -> {Acid, Base}
				}
			}
		]
	},
	SetUp :> {
		$CreatedObjects = {}
	},
	TearDown :> {
		EraseObject[
			PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]],
			Force -> True,
			Verbose -> False
		];
		Unset[$CreatedObjects]
	},
	SymbolSetUp :> {
		Module[{allObjects, existingObjects},

			(* All objects generated for unit tests *)
			allObjects = Flatten[{
				Search[{Model[Molecule], Model[Sample]}, StringContainsQ[Name, "UploadIDUFTest"]]
			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Set up test stuff *)
			(* Install a test function using most defaults *)
			DefineOptions[UploadIDUFTest1, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];
			installDefaultUploadFunction[UploadIDUFTest1, Model[Molecule]]
		]
	},
	SymbolTearDown :> {
		Module[{allObjects, existingObjects},

			(* All objects generated for unit tests *)
			allObjects = Flatten[{
				Search[{Model[Molecule], Model[Sample]}, StringContainsQ[Name, "UploadIDUFTest"]]
			}];

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];


			(* Clear up the test stuff *)
			ClearAll[UploadIDUFTest1]
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*installDefaultOptionsFunction*)


DefineTests[installDefaultOptionsFunction,
	{
		Example[{Basic, "Generate a generic options sister function for installDefaultOptionsFunctionTestFunction with name 'installDefaultOptionsFunctionTestFunctionOptions':"},
			installDefaultOptionsFunction[ECL`installDefaultOptionsFunctionTestFunction, Model[Sample]];
			DownValues[ECL`installDefaultOptionsFunctionTestFunctionOptions],
			Except[{}],
			SetUp :> {
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction],
				ClearAll[ECL`installDefaultOptionsFunctionTestFunctionOptions],
				DefineOptions[ECL`installDefaultOptionsFunctionTestFunction, Options :> {CacheOption}],
				installDefaultUploadFunction[ECL`installDefaultOptionsFunctionTestFunction, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction],
				ClearAll[ECL`installDefaultOptionsFunctionTestFunctionOptions]
			}
		],
		Example[{Additional, "Usage is also defined:"},
			installDefaultOptionsFunction[ECL`installDefaultOptionsFunctionTestFunction2, Model[Sample]];
			Usage[ECL`installDefaultOptionsFunctionTestFunction2Options],
			Except[{}],
			SetUp :> {
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction2],
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction2Options],
				DefineOptions[ECL`installDefaultOptionsFunctionTestFunction2, Options :> {CacheOption}],
				installDefaultUploadFunction[ECL`installDefaultOptionsFunctionTestFunction2, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction2],
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction2Options]
			}
		],
		Example[{Additional, "Tests are not defined and must be created separately:"},
			installDefaultOptionsFunction[ECL`installDefaultOptionsFunctionTestFunction3, Model[Sample]];
			Tests[ECL`installDefaultOptionsFunctionTestFunction3Options],
			{},
			SetUp :> {
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction3],
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction3Options],
				DefineOptions[ECL`installDefaultOptionsFunctionTestFunction3, Options :> {CacheOption}],
				installDefaultUploadFunction[ECL`installDefaultOptionsFunctionTestFunction3, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction3],
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction3Options]
			}
		],
		Test["A single overload is defined that calls the named function:",
			installDefaultOptionsFunction[ECL`installDefaultOptionsFunctionTestFunction4, Model[Sample]];
			DownValues[ECL`installDefaultOptionsFunctionTestFunction4Options],
			_?(And[
				MemberQ[#,
					(* Pattern for singleton input definition *)
					Verbatim[HoldPattern][installDefaultOptionsFunctionTestFunction4Options[input_, options_]],
					Infinity
				],
				MemberQ[#,
					(* Pattern for singleton input definition *)
					installDefaultOptionsFunctionTestFunction4[input_, options_],
					Infinity
				]
			]&),
			SetUp :> {
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction4],
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction4Options],
				DefineOptions[ECL`installDefaultOptionsFunctionTestFunction4, Options :> {CacheOption}],
				installDefaultUploadFunction[ECL`installDefaultOptionsFunctionTestFunction4, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction4],
				ClearAll[ECL`installDefaultOptionsFunctionTestFunction4Options]
			}
		],
		Test["Function returns a grid of options:",
			ECL`UploadIDUFOptionsTest1Options[
				"Test object 1 for UploadIDUFOptionsTest1 unit tests " <> $SessionUUID
			],
			_Grid,
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Function returns a list of options when OutputFormat -> List:",
			ECL`UploadIDUFOptionsTest1Options[
				"Test object 1 for UploadIDUFOptionsTest1 unit tests " <> $SessionUUID,
				OutputFormat -> List
			],
			{_Rule..},
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		]
	},
	SymbolSetUp :> {
		Module[{},

			(* Set up test stuff *)
			(* Install a test function using most defaults *)
			DefineOptions[ECL`UploadIDUFOptionsTest1, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];
			installDefaultUploadFunction[ECL`UploadIDUFOptionsTest1, Model[Molecule]];
			installDefaultOptionsFunction[ECL`UploadIDUFOptionsTest1, Model[Molecule]]
		]
	},
	SymbolTearDown :> {
		Module[{},

			(* Clear up the test stuff *)
			ClearAll[UploadIDUFOptionsTest1]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*installDefaultValidQFunction*)


DefineTests[installDefaultValidQFunction,
	{
		Example[{Basic, "Generate a generic options sister function for installDefaultValidQFunctionTestFunction with name 'installDefaultValidQFunctionTestFunctionOptions':"},
			installDefaultValidQFunction[ECL`installDefaultValidQFunctionTestFunction, Model[Sample]];
			DownValues[ECL`ValidinstallDefaultValidQFunctionTestFunctionQ],
			Except[{}],
			SetUp :> {
				ClearAll[ECL`installDefaultValidQFunctionTestFunction],
				ClearAll[ECL`installDefaultValidQFunctionTestFunctionOptions],
				DefineOptions[ECL`installDefaultValidQFunctionTestFunction, Options :> {CacheOption}],
				installDefaultUploadFunction[ECL`installDefaultValidQFunctionTestFunction, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`installDefaultValidQFunctionTestFunction],
				ClearAll[ECL`installDefaultValidQFunctionTestFunctionOptions]
			}
		],
		Example[{Additional, "Usage is also defined:"},
			installDefaultValidQFunction[ECL`installDefaultValidQFunctionTestFunction2, Model[Sample]];
			Usage[ECL`ValidinstallDefaultValidQFunctionTestFunction2Q],
			Except[{}],
			SetUp :> {
				ClearAll[ECL`installDefaultValidQFunctionTestFunction2],
				ClearAll[ECL`ValidinstallDefaultValidQFunctionTestFunction2Q],
				DefineOptions[ECL`installDefaultValidQFunctionTestFunction2, Options :> {CacheOption}],
				installDefaultUploadFunction[ECL`installDefaultValidQFunctionTestFunction2, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`installDefaultValidQFunctionTestFunction2],
				ClearAll[ECL`ValidinstallDefaultValidQFunctionTestFunction2Q]
			}
		],
		Example[{Additional, "Tests are not defined and must be created separately:"},
			installDefaultValidQFunction[ECL`installDefaultValidQFunctionTestFunction3, Model[Sample]];
			Tests[ECL`ValidinstallDefaultValidQFunctionTestFunction3Q],
			{},
			SetUp :> {
				ClearAll[ECL`installDefaultValidQFunctionTestFunction3],
				ClearAll[ECL`ValidinstallDefaultValidQFunctionTestFunction3Q],
				DefineOptions[ECL`installDefaultValidQFunctionTestFunction3, Options :> {CacheOption}],
				installDefaultUploadFunction[ECL`installDefaultValidQFunctionTestFunction3, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`installDefaultValidQFunctionTestFunction3],
				ClearAll[ECL`ValidinstallDefaultValidQFunctionTestFunction3Q]
			}
		],
		Test["A single overload is defined that calls the named function:",
			installDefaultValidQFunction[ECL`installDefaultValidQFunctionTestFunction4, Model[Sample]];
			DownValues[ECL`ValidinstallDefaultValidQFunctionTestFunction4Q],
			_?(And[
				MemberQ[#,
					(* Pattern for singleton input definition *)
					Verbatim[HoldPattern][ValidinstallDefaultValidQFunctionTestFunction4Q[input_, options_]],
					Infinity
				],
				MemberQ[#,
					(* Pattern for singleton input definition *)
					installDefaultValidQFunctionTestFunction4[input_, options_],
					Infinity
				]
			]&),
			SetUp :> {
				ClearAll[ECL`installDefaultValidQFunctionTestFunction4],
				ClearAll[ECL`ValidinstallDefaultValidQFunctionTestFunction4Q],
				DefineOptions[ECL`installDefaultValidQFunctionTestFunction4, Options :> {CacheOption}],
				installDefaultUploadFunction[ECL`installDefaultValidQFunctionTestFunction4, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`installDefaultValidQFunctionTestFunction4],
				ClearAll[ECL`ValidinstallDefaultValidQFunctionTestFunction4Q]
			}
		],
		Test["Function returns a grid of options:",
			ECL`ValidUploadIDUFValidQTest1Q[
				"Test object 1 for UploadIDUFValidQTest1 unit tests " <> $SessionUUID
			],
			True,
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		],
		Test["Function returns a list of tests when OutputFormat -> TestSummary:",
			ECL`ValidUploadIDUFValidQTest1Q[
				"Test object 1 for UploadIDUFValidQTest1 unit tests " <> $SessionUUID,
				OutputFormat -> TestSummary
			],
			_EmeraldTestSummary,
			Stubs :> {
				ValidObjectQ`Private`testsForPacket[___] := {}
			}
		]
	},
	SymbolSetUp :> {
		Module[{},

			(* Set up test stuff *)
			(* Install a test function using most defaults *)
			DefineOptions[ECL`UploadIDUFValidQTest1, Options :> {MoleculeOptions, ExternalUploadHiddenOptions}];
			installDefaultUploadFunction[ECL`UploadIDUFValidQTest1, Model[Molecule]];
			installDefaultValidQFunction[ECL`UploadIDUFValidQTest1, Model[Molecule]]
		]
	},
	SymbolTearDown :> {
		Module[{},

			(* Clear up the test stuff *)
			ClearAll[UploadIDUFValidQTest1]
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*installDefaultVerificationFunction*)


DefineTests[installDefaultVerificationFunction,
	(* These tests verify that installDefaultVerificationFunction is creating reasonable DownValues *)
	(* Validity testing of the actual code generated is best done by the unit tests of actual functions generated using the framework *)
	{
		Example[{Basic, "Generate a generic verification sister function for UploadDefaultVerificationTestFunction with name 'UploadVerifiedDefaultVerificationTestFunction':"},
			installDefaultVerificationFunction[ECL`UploadDefaultVerificationTestFunction, Model[Sample]];
			DownValues[ECL`UploadVerifiedDefaultVerificationTestFunction],
			Except[{}],
			SetUp :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction],
				DefineOptions[ECL`UploadDefaultVerificationTestFunction, Options :> {StrictOption}],
				installDefaultUploadFunction[ECL`UploadDefaultVerificationTestFunction, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction]
			}
		],
		Example[{Basic, "Generate a generic verification sister function for UploadDefaultVerificationTestFunction with name 'UploadVerifiedDefaultVerificationTestFunction', a list of allowed types and a short description of input name:"},
			installDefaultVerificationFunction[ECL`UploadDefaultVerificationTestFunction5, "input", {Model[Sample], Model[Molecule]}];
			DownValues[ECL`UploadVerifiedDefaultVerificationTestFunction5],
			Except[{}],
			SetUp :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction5],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction5],
				DefineOptions[ECL`UploadDefaultVerificationTestFunction5, Options :> {StrictOption}],
				installDefaultUploadFunction[ECL`UploadDefaultVerificationTestFunction5, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction5],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction5]
			}
		],
		Example[{Additional, "Usage is also defined:"},
			installDefaultVerificationFunction[ECL`UploadDefaultVerificationTestFunction2, Model[Sample]];
			Usage[ECL`UploadVerifiedDefaultVerificationTestFunction2],
			Except[{}],
			SetUp :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction2],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction2],
				DefineOptions[ECL`UploadDefaultVerificationTestFunction2, Options :> {StrictOption}],
				installDefaultUploadFunction[ECL`UploadVerifiedDefaultVerificationTestFunction2, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction2],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction2]
			}
		],
		Example[{Additional, "Tests are not defined and must be created separately:"},
			installDefaultVerificationFunction[ECL`UploadDefaultVerificationTestFunction3, Model[Sample]];
			Tests[ECL`UploadVerifiedDefaultVerificationTestFunction3],
			{},
			SetUp :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction3],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction3],
				DefineOptions[ECL`UploadDefaultVerificationTestFunction3, Options :> {StrictOption}],
				installDefaultUploadFunction[ECL`UploadDefaultVerificationTestFunction3, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction3],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction3]
			}
		],
		Test["A single overload is defined that calls the named function:",
			installDefaultVerificationFunction[ECL`UploadDefaultVerificationTestFunction4, Model[Sample]];
			DownValues[ECL`UploadVerifiedDefaultVerificationTestFunction4],
			_?(And[
				MemberQ[#,
					(* Pattern for singleton input definition *)
					Verbatim[HoldPattern][UploadVerifiedDefaultVerificationTestFunction4[input_, options_]],
					Infinity
				],
				MemberQ[#,
					(* Pattern for singleton input definition *)
					UploadDefaultVerificationTestFunction4[input_, options_],
					Infinity
				]
			]&),
			SetUp :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction4],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction4],
				DefineOptions[ECL`UploadDefaultVerificationTestFunction4, Options :> {StrictOption}],
				installDefaultUploadFunction[ECL`UploadDefaultVerificationTestFunction4, Model[Sample]]
			},
			TearDown :> {
				ClearAll[ECL`UploadDefaultVerificationTestFunction4],
				ClearAll[ECL`UploadVerifiedDefaultVerificationTestFunction4]
			}
		],
		Test["If messages were thrown during evaluation of the verification function, the verification function won't set Verified -> True for the input object:",
			installDefaultVerificationFunction[ECL`UploadTestSampleFunctionX, Model[Sample]];
			funcReturn = ECL`UploadVerifiedTestSampleFunctionX[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verify -> True];
			{funcReturn, Download[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified]},
			{$Failed, Null},
			Messages :> {Error::InvalidOption},
			SetUp :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionX],
				Upload[<| Object -> Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified -> Null |>]
			},
			TearDown :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionX],
				Upload[<| Object -> Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified -> Null |>]
			},
			Variables :> {funcReturn}
		],
		Test["If AllowedMessages option is not empty, function will still set the input object Verified -> True as long as no messages or only allowed messages were thrown:",
			installDefaultVerificationFunction[ECL`UploadTestSampleFunctionX, Model[Sample], AllowedMessages -> {Hold[Error::InvalidOption]}];
			funcReturn = ECL`UploadVerifiedTestSampleFunctionX[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verify -> True];
			{funcReturn, Download[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified]},
			{ObjectP[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID]], True},
			Messages :> {Error::InvalidOption},
			SetUp :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionX],
				Upload[<| Object -> Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified -> Null |>]
			},
			TearDown :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionX],
				Upload[<| Object -> Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified -> Null |>]
			},
			Variables :> {funcReturn}
		],
		Test["By default, if only warnings were thrown during evaluation of the verification function, the verification function will still set Verified -> True for the input object:",
			installDefaultVerificationFunction[ECL`UploadTestSampleFunctionY, Model[Sample]];
			funcReturn = ECL`UploadVerifiedTestSampleFunctionY[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verify -> True];
			{funcReturn, Download[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified]},
			{ObjectP[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID]], True},
			Messages :> {Warning::ExistingPipettingMethod},
			SetUp :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionX],
				Upload[<| Object -> Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified -> Null |>]
			},
			TearDown :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionX],
				Upload[<| Object -> Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified -> Null |>]
			},
			Variables :> {funcReturn}
		],
		Test["If the verification function ran with AllowWarnings -> False option, then warnings will prevent the verification function setting Verified -> True for the input object:",
			installDefaultVerificationFunction[ECL`UploadTestSampleFunctionY, Model[Sample]];
			funcReturn = ECL`UploadVerifiedTestSampleFunctionY[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verify -> True, AllowWarnings -> False];
			{funcReturn, Download[Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified]},
			{$Failed, Null},
			Messages :> {Warning::ExistingPipettingMethod},
			SetUp :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionY],
				Upload[<| Object -> Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified -> Null |>]
			},
			TearDown :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionY],
				Upload[<| Object -> Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID], Verified -> Null |>]
			},
			Variables :> {funcReturn}
		],
		Test["One can provide entries in the OptionCategoryChange under the format OptionSymbol -> 'new Category' when running installDefaultVerificationFunction. If that's the case, those options in the created verification functions will have their Categories changed:",
			installDefaultVerificationFunction[ECL`UploadTestSampleFunctionZ, Model[Sample], OptionCategoryChange -> {<|Options -> FastTrack, Category -> "New Category"|>}];
			{
				Lookup[FirstCase[OptionDefinition[ECL`UploadTestSampleFunctionZ], KeyValuePattern["OptionSymbol"->FastTrack]], "Category"],
				Lookup[FirstCase[OptionDefinition[ECL`UploadVerifiedTestSampleFunctionZ], KeyValuePattern["OptionSymbol"->FastTrack]], "Category"]
			},
			{"Hidden", "New Category"},
			SetUp :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionZ]
			},
			TearDown :> {
				ClearAll[ECL`UploadVerifiedTestSampleFunctionZ]
			}
		]
	},
	SymbolSetUp :> Module[
		{allObj, existingObj},
		allObj = {
			Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID]
		};
		existingObj = PickList[allObj, DatabaseMemberQ[allObj]];
		EraseObject[existingObj, Force -> True, Verbose -> False];
		(* define this test function. It throws Error::InvalidOption and returns the input *)
		ClearAll[ECL`UploadTestSampleFunctionX];
		DefineOptions[ECL`UploadTestSampleFunctionX, Options :> {ExternalUploadHiddenOptions}];
		ECL`UploadTestSampleFunctionX[mySampleModel_, ops:OptionsPattern[]] := Module[
			{},
			Message[Error::InvalidOption, Name];
			mySampleModel
		];

		(* define this test function. It throws Warning::ExistingPipettingMethod and returns the input *)
		ClearAll[ECL`UploadTestSampleFunctionY];
		DefineOptions[ECL`UploadTestSampleFunctionY, Options :> {ExternalUploadHiddenOptions}];
		ECL`UploadTestSampleFunctionY[mySampleModel_, ops:OptionsPattern[]] := Module[
			{},
			Message[Warning::ExistingPipettingMethod, 1, 2];
			mySampleModel
		];

		(* define this test function. It just returns the input *)
		ClearAll[ECL`UploadTestSampleFunctionZ];
		DefineOptions[ECL`UploadTestSampleFunctionZ, Options :> {ExternalUploadHiddenOptions, FastTrackOption}];
		ECL`UploadTestSampleFunctionZ[mySampleModel_, ops:OptionsPattern[]] := Module[
			{},
			mySampleModel
		];

		(* Upload the test sample *)
		Upload[<|
			Type -> Model[Sample],
			Name -> "Test sample model for installDefaultVerificationFunction "<>$SessionUUID,
			DeveloperObject -> Null
		|>];
	],
	SymbolTearDown :> Module[
		{allObj, existingObj},
		allObj = {
			Model[Sample, "Test sample model for installDefaultVerificationFunction "<>$SessionUUID]
		};
		existingObj = PickList[allObj, DatabaseMemberQ[allObj]];
		EraseObject[existingObj, Force -> True, Verbose -> False];
		(* define this test function. It throws Error::InvalidOption and returns the input *)
		ClearAll[ECL`UploadTestSampleFunctionX];
		ClearAll[ECL`UploadTestSampleFunctionY];
		ClearAll[ECL`UploadTestSampleFunctionZ];
	]
];

(* ::Subsubsection::Closed:: *)
(*resolveCustomSharedUploadOptions*)
(* Tests for high level stuff - the individual helpers are unit tested for precise resolution testing *)
DefineTests[resolveCustomSharedUploadOptions,
	{
		Test["Returns resolved options for options that have custom resolution:",
			resolveCustomSharedUploadOptions[
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> Automatic|>},
				{<|MSDSFile -> Null, MSDSRequired -> Null|>}
			],
			{
				<|MSDSRequired -> _, MSDSFile -> _|>
			}
		],
		Test["Returns resolved options for a list of inputs:",
			resolveCustomSharedUploadOptions[
				{
					<|MSDSFile -> NotApplicable, MSDSRequired -> False|>,
					<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>
				},
				{
					<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>,
					<|MSDSFile -> Null, MSDSRequired -> Null|>
				}
			],
			{
				<|MSDSRequired -> _, MSDSFile -> _|>,
				<|MSDSRequired -> _, MSDSFile -> _|>
			}
		],
		Test["Returns resolved options for options that have custom resolution when modifying an existing object:",
			resolveCustomSharedUploadOptions[
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> Automatic|>},
				{<|MSDSFile -> Null, MSDSRequired -> Null|>},
				{<|MSDSFile -> Null, MSDSRequired -> Null|>}
			],
			{
				<|MSDSRequired -> _, MSDSFile -> _|>
			}
		],
		Test["Returns resolved options for a list of inputs when modifying an existing object:",
			resolveCustomSharedUploadOptions[
				{
					<|MSDSFile -> NotApplicable, MSDSRequired -> False|>,
					<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>
				},
				{
					<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>,
					<|MSDSFile -> Null, MSDSRequired -> Null|>
				},
				{
					<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>,
					<|MSDSFile -> Null, MSDSRequired -> Null|>
				}
			],
			{
				<|MSDSRequired -> _, MSDSFile -> _|>,
				<|MSDSRequired -> _, MSDSFile -> _|>
			}
		],
		Test["Resolve user provided options with no external data:",
			resolveCustomSharedUploadOptions[
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> Automatic|>}
			],
			{
				<|MSDSRequired -> _, MSDSFile -> _|>
			}
		],
		Test["Only resolved options are returned in the output:",
			resolveCustomSharedUploadOptions[
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> Automatic, ExtraOption1 -> 2, ExtraOption2 -> Value|>},
				{<|MSDSFile -> Null, MSDSRequired -> Null, PubChem1 -> True|>}
			],
			{
				<|MSDSRequired -> _, MSDSFile -> _|>
			}
		],
		Test["Returns an empty association if custom resolved options are not present in the inputs:",
			resolveCustomSharedUploadOptions[
				{<|ExtraOption1 -> 2, ExtraOption2 -> Value|>},
				{<|MSDSFile -> Null, MSDSRequired -> Null, PubChem1 -> True|>}
			],
			{
				<||>
			}
		],
		Test["Singleton overload 1 works:",
			resolveCustomSharedUploadOptions[
				<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> Automatic|>,
				<|MSDSFile -> Null, MSDSRequired -> Null|>,
				<|MSDSFile -> Null, MSDSRequired -> Null|>
			],
			<|MSDSRequired -> _, MSDSFile -> _|>
		],
		Test["Singleton overload 2 works:",
			resolveCustomSharedUploadOptions[
				<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> Automatic|>,
				<|MSDSFile -> Null, MSDSRequired -> Null|>
			],
			<|MSDSRequired -> _, MSDSFile -> _|>
		],
		Test["Singleton overload 3 works:",
			resolveCustomSharedUploadOptions[
				<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> Automatic|>
			],
			<|MSDSRequired -> _, MSDSFile -> _|>
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*resolveMSDSOptions*)
DefineTests[resolveMSDSOptions,
	{
		Test["If user specifies the MSDSFile, MSDSRequired resolves to True:",
			resolveMSDSOptions[
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> Automatic|>},
				{<|MSDSFile -> Null, MSDSRequired -> Null|>}
			],
			{{MSDSRequired -> True, MSDSFile -> "www.emeraldcloudlab.com"}}
		],
		Test["If user declares that an MSDS is not required, MSDSFile resolves to Null and MSDSRequired resolves to True:",
			resolveMSDSOptions[
				{<|MSDSFile -> NotApplicable, MSDSRequired -> Automatic|>},
				{<|MSDSFile -> Null, MSDSRequired -> Null|>}
			],
			{{MSDSRequired -> False, MSDSFile -> Null}}
		],
		Test["If specified options conflict, pass through both values as error checking is performed elsewhere:",
			resolveMSDSOptions[
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> False|>},
				{<|MSDSFile -> Null, MSDSRequired -> Null|>}
			],
			{{MSDSRequired -> False, MSDSFile -> "www.emeraldcloudlab.com"}}
		],
		Test["PubChem values are used if user values are automatic:",
			resolveMSDSOptions[
				{<|MSDSFile -> Automatic, MSDSRequired -> Automatic|>},
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>}
			],
			{{MSDSRequired -> True, MSDSFile -> "www.emeraldcloudlab.com"}}
		],
		Test["Existing object field values are used in preference to PubChem values if user values are automatic:",
			resolveMSDSOptions[
				{<|MSDSFile -> Automatic, MSDSRequired -> Automatic|>},
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>},
				{<|MSDSFile -> Null, MSDSRequired -> False|>}
			],
			{{MSDSRequired -> False, MSDSFile -> Null}}
		],
		Test["User values are used if conflicting with PubChem:",
			resolveMSDSOptions[
				{<|MSDSFile -> NotApplicable, MSDSRequired -> False|>},
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>}
			],
			{{MSDSRequired -> False, MSDSFile -> Null}}
		],
		Test["Resolves lists of values options:",
			resolveMSDSOptions[
				{
					<|MSDSFile -> NotApplicable, MSDSRequired -> False|>,
					<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>
				},
				{
					<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> True|>,
					<|MSDSFile -> Null, MSDSRequired -> Null|>
				}
			],
			{
				{MSDSRequired -> False, MSDSFile -> Null},
				{MSDSRequired -> True, MSDSFile -> "www.emeraldcloudlab.com"}
			}
		],
		Test["Returns empty lists if options are not included in the inputs:",
			resolveMSDSOptions[
				{<||>},
				{<||>}
			],
			{
				{}
			}
		],
		Test["Returns the user values is no external data is provided:",
			resolveMSDSOptions[
				{<|MSDSFile -> "www.emeraldcloudlab.com", MSDSRequired -> Automatic|>},
				{<||>}
			],
			{{MSDSRequired -> True, MSDSFile -> "www.emeraldcloudlab.com"}}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*RunOptionValidationTests*)

Module[{cacheForRunOptionValidationTests, validContainerModel1, validContainerModel2},
	DefineTests[RunOptionValidationTests,
		{
			Test["Ensure the test Model[Container, Vessel] from SymbolSetUp passes ValidObjectQ:",
				{ValidObjectQ[validContainerModel1], ValidObjectQ[validContainerModel2]},
				{True, True}
			],
			Example[{Basic, "Function can take a change packet as input, provided the original packet being included in the Cache option:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[ContainerMaterials] -> {Polypropylene}
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> Result
				],
				True
			],
			Example[{Basic, "Function can take a list of change packets as input:"},
				RunOptionValidationTests[
					{
						<|
							Object -> validContainerModel1,
							Replace[ContainerMaterials] -> {Polypropylene}
						|>,
						<|
							Object -> validContainerModel2,
							Replace[ContainerMaterials] -> {LDPE}
						|>
					},
					Cache -> cacheForRunOptionValidationTests,
					Output -> Result
				],
				True
			],
			Example[{Options, Output, "If the input does not pass all the validation tests, including Messages in the output allows the function to output unit test failure messages in HoldForm:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[Authors] -> {}
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> {Result, Messages},
					Message -> False
				],
				{False, {Hold[Error::UnableToResolveOption, {Authors}, {Model[Container, Vessel]}]}}
			],
			Example[{Options, Output, "If the input does not pass all the validation tests, including FailedTestDescriptions in the output allows the function to output descriptions of all failed tests:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[Authors] -> {}
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> {Result, FailedTestDescriptions},
					Message -> False
				],
				{False, {"Authors is informed:"}}
			],
			Example[{Options, Output, "If the input does not pass all the validation tests, including InvalidOptions in the output allows the function to output list of all failed options:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[Authors] -> {}
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> {Result, InvalidOptions},
					Message -> False
				],
				{False, {Authors}}
			],
			Example[{Options, Output, "If both Messages and FailedTestDescriptions are included in the Output option, only failed tests without UnitTestFailureMessage defined will be output as the FailedTestDescriptions:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[Authors] -> {},
						PreferredCamera -> Plate
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> {Result, Messages, FailedTestDescriptions},
					Message -> False
				],
				{False, {Hold[Error::UnableToResolveOption, {Authors}, {Model[Container, Vessel]}]}, {"PlateImagerRack must be populated if and only if PreferredCamera or CompatibleCameras includes Plate:"}}
			],
			Example[{Options, Message, "If Message -> True, the corresponding unit test failure messages will be thrown directly if any tests fails:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[Authors] -> {}
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> Result,
					Message -> True
				],
				False,
				Messages :> {Error::UnableToResolveOption}
			],
			Example[{Options, Message, "If Message -> True, messages with the same name will be combined and throw only once:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[Authors] -> {},
						SelfStanding -> Null
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> Result,
					Message -> True
				],
				False,
				Messages :> {Message[Error::UnableToResolveOption, {Authors, SelfStanding}, {Model[Container, Vessel]}]}
			],
			Example[{Options, Cache, "When updating an existing model, the original packet must be included in the Cache option, otherwise function will treat the input packet as creating new object:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[ContainerMaterials] -> {Polypropylene}
					|>,
					Cache -> {},
					Output -> Result,
					Message -> False
				],
				False
			],
			Example[{Options, UnresolvedOptions, "Function correctly identify the OptionSource from UnresolvedOptions and pass that to testsForPacket function:"},
				Catch[RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[ContainerMaterials] -> {Polypropylene},
						Ampoule -> False,
						SelfStanding -> True
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> Result,
					UnresolvedOptions -> {Ampoule -> False, ContainerMaterials -> {Polypropylene}}
				]],
				AssociationMatchP[
					<|
						ContainerMaterials -> User,
						Ampoule -> User,
						SelfStanding -> Resolved
					|>,
					AllowForeignKeys -> True
				],
				Stubs :> {ValidObjectQ`Private`testsForPacket[pac:PacketP[], ops:OptionsPattern[]] := Throw[Lookup[ToList[ops], FieldSource]]}
			],
			Example[{Options, ParsedOptions, "Function correctly identify the OptionSource from ParsedOptions and pass that to testsForPacket function:"},
				Catch[RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[ContainerMaterials] -> {Polypropylene},
						Ampoule -> False,
						SelfStanding -> True,
						Dimensions -> {0.1 Meter, 0.1 Meter, 0.1 Meter}
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> Result,
					ParsedOptions -> {Ampoule -> False, Dimensions -> {0.1 Meter, 0.1 Meter, 0.1 Meter}}
				]],
				AssociationMatchP[
					<|
						ContainerMaterials -> Resolved,
						Ampoule -> External,
						SelfStanding -> Resolved,
						Dimensions -> External
					|>,
					AllowForeignKeys -> True
				],
				Stubs :> {ValidObjectQ`Private`testsForPacket[pac:PacketP[], ops:OptionsPattern[]] := Throw[Lookup[ToList[ops], FieldSource]]}
			],
			Example[{Options, ParsedOptions, "Function correctly identify the OptionSource from TemplateOptions and pass that to testsForPacket function:"},
				Catch[RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[ContainerMaterials] -> {Polypropylene},
						Ampoule -> False,
						SelfStanding -> True,
						Dimensions -> {0.1 Meter, 0.1 Meter, 0.1 Meter}
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> Result,
					TemplateOptions -> {Ampoule -> False, Dimensions -> {0.1 Meter, 0.1 Meter, 0.1 Meter}}
				]],
				AssociationMatchP[
					<|
						ContainerMaterials -> Resolved,
						Ampoule -> Template,
						SelfStanding -> Resolved,
						Dimensions -> Template
					|>,
					AllowForeignKeys -> True
				],
				Stubs :> {ValidObjectQ`Private`testsForPacket[pac:PacketP[], ops:OptionsPattern[]] := Throw[Lookup[ToList[ops], FieldSource]]}
			],
			Example[{Additional, "Function merges error message of the same name across different inputs, either when Message -> True, or when Messages are included in the output:"},
				RunOptionValidationTests[
					{
						<|
							Object -> validContainerModel1,
							Replace[Authors] -> {},
							SelfStanding -> Null
						|>,
						<|
							Object -> validContainerModel2,
							Replace[Authors] -> {},
							SelfStanding -> Null
						|>
					},
					Cache -> cacheForRunOptionValidationTests,
					Output -> Messages,
					Message -> True
				],
				{Hold[Error::UnableToResolveOption, {Authors, SelfStanding}, {Model[Container, Vessel]}]},
				Messages :> {Message[Error::UnableToResolveOption, {Authors, SelfStanding}, {Model[Container, Vessel]}]}
			],
			Example[{Additional, "If Messages are part of the Output option, all messages with the same name will be combined:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[Authors] -> {},
						SelfStanding -> Null
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> {Result, Messages},
					Message -> False
				],
				{False, {Hold[Error::UnableToResolveOption, {Authors, SelfStanding}, {Model[Container, Vessel]}]}}
			],
			Example[{Additional, "The message output varies depend on where the problematic option value originates from:"},
				RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[Authors] -> {},
						SelfStanding -> Null
					|>,
					Cache -> cacheForRunOptionValidationTests,
					ParsedOptions -> {Authors -> {}},
					UnresolvedOptions -> {SelfStanding -> Null},
					Output -> {Result, Messages},
					Message -> False
				],
				{False, {Hold[Error::UnableToFindInfo, {Authors}, {Model[Container, Vessel]}, {"web source"}, {"UploadContainerModel"}], Hold[Error::RequiredOptions, {SelfStanding}, {Model[Container, Vessel]}]}}
			],
			Example[{Additional, "In the UnresolvedOptions if an option value is Automatic, that option won't be counted as User-specified:"},
				Catch[RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[ContainerMaterials] -> {Polypropylene},
						Ampoule -> False,
						SelfStanding -> True,
						Dimensions -> {1 Meter, 1 Meter, 1 Meter}
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> Result,
					UnresolvedOptions -> {Ampoule -> Automatic, ContainerMaterials -> {Polypropylene}, Dimensions -> {Automatic, Automatic, Automatic}}
				]],
				AssociationMatchP[
					<|
						ContainerMaterials -> User,
						Ampoule -> Resolved,
						SelfStanding -> Resolved,
						Dimensions -> Resolved
					|>,
					AllowForeignKeys -> True
				],
				Stubs :> {ValidObjectQ`Private`testsForPacket[pac:PacketP[], ops:OptionsPattern[]] := Throw[Lookup[ToList[ops], FieldSource]]}
			],
			Example[{Additional, "If both UnresolvedOptions and ParsedOptions are empty, all fields in the change packet is counted as resolved, those are not in the change packet are counted as downloaded from Constellation:"},
				Catch[RunOptionValidationTests[
					<|
						Object -> validContainerModel1,
						Replace[ContainerMaterials] -> {Polypropylene},
						Ampoule -> False,
						SelfStanding -> True,
						Dimensions -> {1 Meter, 1 Meter, 1 Meter}
					|>,
					Cache -> cacheForRunOptionValidationTests,
					Output -> Result,
					UnresolvedOptions -> {},
					ParsedOptions -> {}
				]],
				AssociationMatchP[
					<|
						ContainerMaterials -> Resolved,
						Ampoule -> Resolved,
						SelfStanding -> Resolved,
						Dimensions -> Resolved,
						Opaque -> Field,
						Name -> Field
					|>,
					AllowForeignKeys -> True
				],
				Stubs :> {ValidObjectQ`Private`testsForPacket[pac:PacketP[], ops:OptionsPattern[]] := Throw[Lookup[ToList[ops], FieldSource]]}
			]
		},
		SymbolSetUp :> {
			Module[{allObjects, existingObjects},
				allObjects = {
					Model[Container, Vessel, "Test Valid Container Model 1 for RunOptionValidationTests "<>$SessionUUID],
					Model[Container, Vessel, "Test Valid Container Model 2 for RunOptionValidationTests "<>$SessionUUID]
				};
				existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
				EraseObject[existingObjects, Force -> True, Verbose -> False];
				(* Use raw upload to create a few objects that should pass VOQ *)
				{validContainerModel1, validContainerModel2} = Upload[{
					<|
						Type -> Model[Container, Vessel],
						Name -> "Test Valid Container Model 1 for RunOptionValidationTests "<>$SessionUUID,
						Replace[Synonyms] -> {"Test Valid Container Model 1 for RunOptionValidationTests "<>$SessionUUID},
						Replace[Authors] -> {Link[Object[User,"Test user for notebook-less test protocols"]]},
						TransportStable -> False,
						StorageOrientation -> Any,
						Stocked -> True,
						Sterile -> False,
						Squeezable -> False,
						SelfStanding -> False,
						RNaseFree -> False,
						Reusable -> False,
						PyrogenFree -> False,
						PreferredCamera -> Small,
						PreferredBalance -> Analytical,
						Replace[Positions] -> {<|
							Name -> "A1", Footprint -> Null, MaxWidth -> 0.03 Meter, MaxDepth -> 0.03 Meter, MaxHeight -> 0.12 Meter
						|>},
						Replace[PositionPlotting] -> {<|
							Name -> "A1", XOffset -> 0.015 Meter, YOffset -> 0.015 Meter, ZOffset -> 0.015 Meter, CrossSectionalShape -> Circle, Rotation -> 0
						|>},
						Opaque -> False,
						NucleicAcidFree -> False,
						MinVolume -> 1 Milliliter,
						MaxVolume -> 50 Milliliter,
						MinTemperature -> 100 Kelvin,
						MaxTemperature -> 400 Kelvin,
						InternalDiameter -> 0.03 Meter,
						InternalDepth -> 0.12 Meter,
						InternalBottomShape -> FlatBottom,
						ImageFile -> Link[Object[EmeraldCloudFile, "id:eGakldevea6z"]],
						Fragile -> False,
						Footprint -> Conical50mLTube,
						Dimensions -> {0.32 Meter, 0.32 Meter, 0.13 Meter},
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DefaultStickerModel -> Link[Model[Item, Sticker, "id:mnk9jO3dexZY"]],
						CrossSectionalShape -> Circle,
						Replace[CoverTypes] -> {Screw},
						Replace[CoverFootprints] -> {CapScrewTube35x13},
						Ampoule -> False,
						Aperture -> 0.3 Meter,
						Replace[ContainerMaterials] -> {LDPE}
					|>,
					<|
						Type -> Model[Container, Vessel],
						Name -> "Test Valid Container Model 2 for RunOptionValidationTests "<>$SessionUUID,
						Replace[Synonyms] -> {"Test Valid Container Model 2 for RunOptionValidationTests "<>$SessionUUID},
						Replace[Authors] -> {Link[Object[User,"Test user for notebook-less test protocols"]]},
						TransportStable -> False,
						StorageOrientation -> Any,
						Stocked -> True,
						Sterile -> False,
						Squeezable -> False,
						SelfStanding -> False,
						RNaseFree -> False,
						Reusable -> False,
						PyrogenFree -> False,
						PreferredCamera -> Small,
						PreferredBalance -> Analytical,
						Replace[Positions] -> {<|
							Name -> "A1", Footprint -> Null, MaxWidth -> 0.03 Meter, MaxDepth -> 0.03 Meter, MaxHeight -> 0.12 Meter
						|>},
						Replace[PositionPlotting] -> {<|
							Name -> "A1", XOffset -> 0.015 Meter, YOffset -> 0.015 Meter, ZOffset -> 0.015 Meter, CrossSectionalShape -> Circle, Rotation -> 0
						|>},
						Opaque -> False,
						NucleicAcidFree -> False,
						MinVolume -> 1 Milliliter,
						MaxVolume -> 50 Milliliter,
						MinTemperature -> 100 Kelvin,
						MaxTemperature -> 400 Kelvin,
						InternalDiameter -> 0.03 Meter,
						InternalDepth -> 0.12 Meter,
						InternalBottomShape -> FlatBottom,
						ImageFile -> Link[Object[EmeraldCloudFile, "id:eGakldevea6z"]],
						Fragile -> False,
						Footprint -> Conical50mLTube,
						Dimensions -> {0.32 Meter, 0.32 Meter, 0.13 Meter},
						DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
						DefaultStickerModel -> Link[Model[Item, Sticker, "id:mnk9jO3dexZY"]],
						CrossSectionalShape -> Circle,
						Replace[CoverTypes] -> {Screw},
						Replace[CoverFootprints] -> {CapScrewTube35x13},
						Ampoule -> False,
						Aperture -> 0.3 Meter,
						Replace[ContainerMaterials] -> {LDPE}
					|>
				}];

				cacheForRunOptionValidationTests = Download[{validContainerModel1, validContainerModel2}];
			]
		},
		SymbolTearDown :> Module[
			{allObjects, existingObjects},
			allObjects = {
				Model[Container, Vessel, "Test Valid Container Model 1 for RunOptionValidationTests "<>$SessionUUID],
				Model[Container, Vessel, "Test Valid Container Model 2 for RunOptionValidationTests "<>$SessionUUID]
			};
			existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*scrapeMoleculeData*)

DefineTests[
	scrapeMoleculeData,
	{
		Example[{Basic, "Scrape data for a molecule object:"},
			scrapeMoleculeData[Molecule["caffeine"]],
			caffeineDataSDSP,
			Stubs :> {
				parseChemicalIdentifier[MoleculeValue[Molecule["caffeine"], "InChI"]] := caffeineData
			}
		],
		Example[{Basic, "Scrape data for a molecule described by InChI:"},
			scrapeMoleculeData[
				ExternalIdentifier["InChI","InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"]
			],
			caffeineDataSDSP,
			Stubs :> {
				parseChemicalIdentifier["InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"] := caffeineData
			}
		],
		Example[{Basic, "Scrape data for a molecule described by name:"},
			scrapeMoleculeData[
				"caffeine"
			],
			caffeineDataSDSP,
			Stubs :> {
				parseChemicalIdentifier["caffeine"] := caffeineData
			}
		],
		Example[{Basic, "Scrape data for a molecule described by a product URL:"},
			scrapeMoleculeData[
				"https://www.thermofisher.com/order/catalog/product/A10431.22"
			],
			caffeineDataThermoP,
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := caffeineData
			}
		],
		Example[{Additional, "Scrape data for multiple molecules:"},
			scrapeMoleculeData[
				{
					Molecule["caffeine"],
					"RYYVLZVUVIJVGH-UHFFFAOYSA-N",
					"cubane"
				}
			],
			{
				caffeineDataSDSP,
				caffeineDataSDSP,
				cubaneDataSDSP
			},
			Stubs :> {
				parseChemicalIdentifier[MoleculeValue[Molecule["caffeine"], "InChI"]] := caffeineData,
				parseChemicalIdentifier["RYYVLZVUVIJVGH-UHFFFAOYSA-N"] := caffeineData,
				parseChemicalIdentifier["cubane"] := cubaneData
			}
		],
		Example[{Additional, "Scrape data for multiple molecules using the first valid identifier in the provided lists:"},
			scrapeMoleculeData[
				{
					{Molecule["caffeine"], "RYYVLZVUVIJVGH-UHFFFAOYSA-N"},
					{"58-08-2"},
					"cubane"
				}
			],
			{
				caffeineDataSDSP,
				caffeineDataSDSP,
				cubaneDataSDSP
			},
			Stubs :> {
				parseChemicalIdentifier[MoleculeValue[Molecule["caffeine"], "InChI"]] := caffeineData,
				parseChemicalIdentifier["RYYVLZVUVIJVGH-UHFFFAOYSA-N"] := caffeineData,
				parseChemicalIdentifier["58-08-2"] := caffeineData,
				parseChemicalIdentifier["cubane"] := cubaneData
			}
		],
		Example[{Additional, "Scrape data for a molecule described by an InChI string:"},
			scrapeMoleculeData[
				"InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"
			],
			caffeineDataSDSP,
			Stubs :> {
				parseChemicalIdentifier["InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"] := caffeineData
			}
		],
		Example[{Additional, "Scrape data for a molecule described by a PubChem identifier:"},
			scrapeMoleculeData[
				PubChem[2519]
			],
			caffeineDataSDSP,
			Stubs :> {
				parsePubChem[PubChem[2519]] := caffeineData
			}
		],
		Example[{Additional, "Scrape data for a molecule described by an InChIKey:"},
			scrapeMoleculeData[
				"RYYVLZVUVIJVGH-UHFFFAOYSA-N"
			],
			caffeineDataSDSP,
			Stubs :> {
				parseChemicalIdentifier["RYYVLZVUVIJVGH-UHFFFAOYSA-N"] := caffeineData
			}
		],
		Example[{Additional, "Scrape data for a molecule described by a CAS identifier:"},
			scrapeMoleculeData[
				"58-08-2"
			],
			caffeineDataSDSP,
			Stubs :> {
				parseChemicalIdentifier["58-08-2"] := caffeineData
			}
		],
		Example[{Additional, "Scrape data for a molecule described on a ThermoFisher product page:"},
			scrapeMoleculeData[
				"https://www.thermofisher.com/order/catalog/product/A10431.22"
			],
			caffeineDataThermoP,
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := caffeineData
			}
		],
		Example[{Additional, "Scrape data for a molecule described on a Millipore-Sigma product page:"},
			scrapeMoleculeData[
				"https://www.sigmaaldrich.com/US/en/product/sial/c0750"
			],
			caffeineDataSigmaP,
			Stubs :> {
				parseSigmaURL["https://www.sigmaaldrich.com/US/en/product/sial/c0750"] := caffeineData
			}
		],
		Example[{Messages, "CompoundNotFound", "Returns $Failed and throws a message saying the compound cannot be found if a user supplies an identifier and the API returns a missing response:"},
			scrapeMoleculeData[
				ExternalIdentifier["InChI","InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"]
			],
			$Failed,
			Messages :> {Error::CompoundNotFound},
			Stubs :> {
				parseChemicalIdentifier["InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"] := 404
			}
		],
		Example[{Messages, "CompoundNotFound", "Returns the result and throws a warning if a user supplies an identifier where the API returns a missing response, but supplies a subsequent successful identifier:"},
			scrapeMoleculeData[
				{{ExternalIdentifier["InChI","InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"], "caffeine"}}
			],
			{caffeineDataSDSP},
			Messages :> {
				Message[Warning::CompoundNotFound, {"InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"}, {"caffeine"}]
			},
			Stubs :> {
				parseChemicalIdentifier["InChI=1S/C8H10N4O2/c1-10-4-9-6-5(10)7(13)12(3)8(14)11(6)2/h4H,1-3H3"] := 404,
				parseChemicalIdentifier["caffeine"] := caffeineData
			}
		],
		Example[{Messages, "URLNotFound", "Returns $Failed and throws a message saying the url is invalid if a user supplies a URL and the API returns a missing response:"},
			scrapeMoleculeData[
				"https://www.thermofisher.com/order/catalog/product/A10431.22"
			],
			$Failed,
			Messages :> {Error::URLNotFound},
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := 404
			}
		],
		Example[{Messages, "URLNotFound", "Returns the result and throws a warning if a user supplies a URL and the API returns a missing response, but supplies a subsequent successful identifier:"},
			scrapeMoleculeData[
				{{"https://www.thermofisher.com/order/catalog/product/A10431.22", "caffeine"}}
			],
			{caffeineDataSDSP},
			Messages :> {
				Message[Warning::URLNotFound, {"https://www.thermofisher.com/order/catalog/product/A10431.22"}, {"caffeine"}]
			},
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := 404,
				parseChemicalIdentifier["caffeine"] := caffeineData
			}
		],
		Example[{Messages, "InvalidIdentifier", "Returns $Failed and throws a message saying the identifier is invalid if the API indicates this with a 400 error:"},
			scrapeMoleculeData[
				ExternalIdentifier["InChI","InChI=1S/CHp/c1"]
			],
			$Failed,
			Messages :> {Error::InvalidIdentifier},
			Stubs :> {
				parseChemicalIdentifier["InChI=1S/CHp/c1"] := 400
			}
		],
		Example[{Messages, "InvalidIdentifier", "Returns the result and and throws a warning if the API indicates an invalid identifier, but the user supplies a subsequent successful identifier:"},
			scrapeMoleculeData[
				{{ExternalIdentifier["InChI","InChI=1S/CHp/c1"], "caffeine"}}
			],
			{caffeineDataSDSP},
			Messages :> {
				Message[Warning::InvalidIdentifier, {"InChI=1S/CHp/c1"}, {"caffeine"}]
			},
			Stubs :> {
				parseChemicalIdentifier["InChI=1S/CHp/c1"] := 400,
				parseChemicalIdentifier["caffeine"] := caffeineData
			}
		],
		Example[{Messages, "BadRequest", "Returns $Failed and throws a message saying the url is a bad request if a user supplies a URL and the API indicates this with a 400 error:"},
			scrapeMoleculeData[
				"https://www.thermofisher.com/order/catalog/product/Invalid"
			],
			$Failed,
			Messages :> {Error::BadRequest},
			Stubs :> {
				(* This stub is made up as I don't think either Thermo or Sigma return 400 which are the only user supplied URL formats *)
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/Invalid"] := 400
			}
		],
		Example[{Messages, "BadRequest", "Returns the result and throws a warning if a user supplies a URL and the API indicates a bad request, but the user supplies a subsequent successful identifier:"},
			scrapeMoleculeData[
				{{"https://www.thermofisher.com/order/catalog/product/Invalid", "caffeine"}}
			],
			{caffeineDataSDSP},
			Messages :> {
				Message[Warning::BadRequest, {"https://www.thermofisher.com/order/catalog/product/Invalid"}, {"caffeine"}]
			},
			Stubs :> {
				(* This stub is made up as I don't think either Thermo or Sigma return 400 which are the only user supplied URL formats *)
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/Invalid"] := 400,
				parseChemicalIdentifier["caffeine"] := caffeineData
			}
		],
		Example[{Messages, "APIRateLimit", "Throws an error and returns $Failed if the server issues a rate limit rejection response:"},
			scrapeMoleculeData[
				"https://www.thermofisher.com/order/catalog/product/A10431.22"
			],
			$Failed,
			Messages :> {Error::APIRateLimit},
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := 429,
				(* Make sure we're not waiting forever as we have back-off logic *)
				Pause[_] := Null
			}
		],
		Example[{Messages, "APIRateLimit", "Throws a warning and returns the result if the server issues a rate limit rejection response but a subsequent successful identifier is supplied:"},
			scrapeMoleculeData[
				{{"https://www.thermofisher.com/order/catalog/product/A10431.22", "caffeine"}}
			],
			{caffeineDataSDSP},
			Messages :> {
				Message[Warning::APIRateLimit, {"https://www.thermofisher.com/order/catalog/product/A10431.22"}, {"caffeine"}]
			},
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := 429,
				parseChemicalIdentifier["caffeine"] := caffeineData,
				(* Make sure we're not waiting forever as we have back-off logic *)
				Pause[_] := Null
			}
		],
		Example[{Messages, "APIUnavailable", "Throws an error and returns $Failed if the server indicates it is temporarily unavailable:"},
			scrapeMoleculeData[
				"https://www.thermofisher.com/order/catalog/product/A10431.22"
			],
			$Failed,
			Messages :> {Error::APIUnavailable},
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := 503,
				(* Make sure we're not waiting forever as we have back-off logic *)
				Pause[_] := Null
			}
		],
		Example[{Messages, "APIUnavailable", "Throws a warning and returns the result if the server indicates it is temporarily unavailable but a subsequent successful identifier is supplied:"},
			scrapeMoleculeData[
				{{"https://www.thermofisher.com/order/catalog/product/A10431.22", "caffeine"}}
			],
			{caffeineDataSDSP},
			Messages :> {
				Message[Warning::APIUnavailable, {"https://www.thermofisher.com/order/catalog/product/A10431.22"}, {"caffeine"}]
			},
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := 503,
				parseChemicalIdentifier["caffeine"] := caffeineData,
				(* Make sure we're not waiting forever as we have back-off logic *)
				Pause[_] := Null
			}
		],
		Example[{Messages, "APIConnectionError", "Throws an error and returns $Failed if the server returns an unhandled error response:"},
			scrapeMoleculeData[
				"https://www.thermofisher.com/order/catalog/product/A10431.22"
			],
			$Failed,
			Messages :> {Error::APIConnectionError},
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := 418,
				(* Make sure we're not waiting forever as we have back-off logic *)
				Pause[_] := Null
			}
		],
		Example[{Messages, "APIConnectionError", "Throws a warning and returns the result if the server returns an unhandled error response but a subsequent successful identifier is supplied:"},
			scrapeMoleculeData[
				{{"https://www.thermofisher.com/order/catalog/product/A10431.22", "caffeine"}}
			],
			{caffeineDataSDSP},
			Messages :> {
				Message[Warning::APIConnectionError, {"https://www.thermofisher.com/order/catalog/product/A10431.22"}, {418}, {"caffeine"}]
			},
			Stubs :> {
				parseThermoURL["https://www.thermofisher.com/order/catalog/product/A10431.22"] := 418,
				parseChemicalIdentifier["caffeine"] := caffeineData,
				(* Make sure we're not waiting forever as we have back-off logic *)
				Pause[_] := Null
			}
		],

		(* Integration tests - these will hit the API *)
		Test["Integration - Scrape data for a molecule object:",
			scrapeMoleculeData[Molecule["cubane"]],
			cubaneDataSDSP
		],
		Test["Integration - Scrape data for a molecule described by InChI:",
			scrapeMoleculeData[
				ExternalIdentifier["InChI","InChI=1S/C8H8/c1-2-5-3(1)7-4(1)6(2)8(5)7/h1-8H"]
			],
			cubaneDataSDSP
		],
		Test["Integration - Scrape data for a molecule described by name:",
			scrapeMoleculeData[
				"cubane"
			],
			cubaneDataSDSP
		],
		Test["Integration - Scrape data for a molecule described by an InChI string:",
			scrapeMoleculeData[
				"InChI=1S/C8H8/c1-2-5-3(1)7-4(1)6(2)8(5)7/h1-8H"
			],
			cubaneDataSDSP
		],
		Test["Integration - Scrape data for a molecule described by a PubChem identifier:",
			scrapeMoleculeData[
				PubChem[136090]
			],
			cubaneDataSDSP
		],
		Test["Integration - Scrape data for a molecule described by an InChIKey:",
			scrapeMoleculeData[
				"TXWRERCHRDBNLG-UHFFFAOYSA-N"
			],
			cubaneDataSDSP
		],
		Test["Integration - Scrape data for a molecule described by a CAS identifier:",
			scrapeMoleculeData[
				"277-10-1"
			],
			cubaneDataSDSP
		],
		Test["Integration - Scrape data for a molecule described on a ThermoFisher product page:",
			scrapeMoleculeData[
				"https://www.thermofisher.com/order/catalog/product/033273.D6"
			],
			AssociationMatchP[
				<|
					Name -> "Sulfuric Acid",
					CAS -> "7664-93-9",
					PubChemID -> 1118,
					Molecule -> _Molecule
				|>,
				AllowForeignKeys -> True
			]
		],
		Test["Integration - Scrape data for a molecule described on a Millipore-Sigma product page:",
			scrapeMoleculeData[
				"https://www.sigmaaldrich.com/US/en/product/aldrich/339741"
			],
			AssociationMatchP[
				<|
					Name -> "Sulfuric Acid",
					CAS -> "7664-93-9",
					PubChemID -> 1118,
					Molecule -> _Molecule
				|>,
				AllowForeignKeys -> True
			]
		],
		Test["The function itself is not memoized, but the helpers called are, so repeated calls are fast:",
			scrapeMoleculeData[
				{
					Molecule["cubane"],
					"cubane",
					"InChI=1S/C8H8/c1-2-5-3(1)7-4(1)6(2)8(5)7/h1-8H",
					PubChem[136090],
					"TXWRERCHRDBNLG-UHFFFAOYSA-N",
					"277-10-1",
					"https://www.thermofisher.com/order/catalog/product/033273.D6",
					"https://www.sigmaaldrich.com/US/en/product/aldrich/339741"
				}
			];
			AbsoluteTiming[scrapeMoleculeData[
				{
					Molecule["cubane"],
					"cubane",
					"InChI=1S/C8H8/c1-2-5-3(1)7-4(1)6(2)8(5)7/h1-8H",
					PubChem[136090],
					"TXWRERCHRDBNLG-UHFFFAOYSA-N",
					"277-10-1",
					"https://www.thermofisher.com/order/catalog/product/033273.D6",
					"https://www.sigmaaldrich.com/US/en/product/aldrich/339741"
				}
			];],
			{LessP[0.1], Null}
		],
		Test["An empty list returns an empty list:",
			scrapeMoleculeData[
				{}
			],
			{}
		],
		Test["A list of empty lists returns $Failed for each empty input:",
			scrapeMoleculeData[
				{{}, {}, {}}
			],
			{$Failed, $Failed, $Failed}
		],
		Test["A mix of empty and non-empty lists returns $Failed for each empty input:",
			scrapeMoleculeData[
				{{}, {}, "InChI=1S/C8H8/c1-2-5-3(1)7-4(1)6(2)8(5)7/h1-8H", {}}
			],
			{$Failed, $Failed, cubaneDataSDSP, $Failed}
		]
	},
	Stubs :> {
		(* Avoid pinging SDS servers - those tests will handle that *)
		findSDS[__, HoldPattern[Vendor -> vendor_], ___] := ToString[vendor] <> "-sds.pdf"
	}
];

(* ::Subsubsection::Closed:: *)
(*downloadDuffPackets*)

DefineTests[downloadDuffPackets,
	{
		Test["Download and make packets of input objects:",
			(* 50mL Tube *)
			downloadDuffPackets[{Model[Container, Vessel, "id:bq9LA0dBGGR6"]}, {}, Null],
			{PacketP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]}
		],
		Test["Download multiple objects simultaneously:",
			(* 50mL Tube and 2mL Tube *)
			downloadDuffPackets[{Model[Container, Vessel, "id:bq9LA0dBGGR6"], Model[Container, Vessel, "id:3em6Zv9NjjN8"]}, {}, Null],
			{PacketP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]], PacketP[Model[Container, Vessel, "id:3em6Zv9NjjN8"]]}
		],
		Test["If second input (Cache) is provided, it will be supplied into the Download function:",
			packet = First[downloadDuffPackets[{Model[Container, Vessel, "id:bq9LA0dBGGR6"]}, {<| Object -> Model[Container, Vessel, "id:bq9LA0dBGGR6"], Name -> "xxx" |>}, Null]];
			Lookup[packet, Name],
			"xxx",
			Variables :> {packet}
		],
		Test["Computable fields are excluded from the downloaded packet:",
			packet = First[downloadDuffPackets[{Model[Container, Vessel, "id:bq9LA0dBGGR6"]}, {}, Null]];
			Lookup[packet, {Name, AllowedPositions}],
			{"50mL Tube", _Missing},
			Variables :> {packet}
		],
		Test["Objects fields are excluded from the downloaded packet for performance reason:",
			packet = First[downloadDuffPackets[{Model[Container, Vessel, "id:bq9LA0dBGGR6"]}, {}, Null]];
			Lookup[packet, {Name, Objects}],
			{"50mL Tube", _Missing},
			Variables :> {packet}
		]
	}
]